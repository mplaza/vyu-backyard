require 'google/api_client'

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String


  field :google_access_token, type: String
  field :google_token_expires, type: Date
  field :google_refresh_token, type: String

  has_one :profile

  validates_format_of :email, with: /\@vyutv.com/


  def self.find_for_google_oauth2(access_token)
    data = access_token.info
    puts access_token.credentials
    # puts data
    if User.where(:email => data.email).first
      user = User.where(:email => data.email).first
    else
      # @user = User.new(:email => data.email, :password => Devise.friendly_token[0,20])
      # @profile = Profile.new(:email => data.email, :name => data.name, :profile_picture => data.image)
      # if @user.save
        user = User.create!(:google_token_expires => Time.at(access_token.credentials.expires_at), :google_access_token => access_token.credentials.token, :google_refresh_token => access_token.credentials.refresh_token, :email => data.email, :password => Devise.friendly_token[0,20])
        profile = Profile.create!(:email => data.email, name: data.name, :profile_picture => data.image, :user_id => user.id)
        User.where(email: profile.email).to_a[0].get_location_from_calendar
        # profile = Profile.create!(:email => data.email, :name => data.name, :profile_picture => data.image)

      # end
    end
    user
  end

  def query_email
    self.refresh_google_access_token if self.google_token_expires.past?
    @google_api_client = Google::APIClient.new(
      :application_name => 'Vyu Backyard',
      :application_version => '1.0.0')
    @google_api_client.authorization.access_token = self.google_access_token
    @gmail = @google_api_client.discovered_api('gmail', "v1")
    @emails = @google_api_client.execute(
        api_method: @gmail.users.messages.list,
        parameters: {
            userId: "me",

            # searching messages based on number of queries:
            # https://developers.google.com/gmail/api/guides/filtering
            q: "is:unread"
        },
        headers: {'Content-Type' => 'application/json'}
        )
    @emails.data.messages.count

  end

  def query_email_for_bulletin
    self.refresh_google_access_token if self.google_token_expires.past?
    @google_api_client = Google::APIClient.new(
      :application_name => 'Vyu Backyard',
      :application_version => '1.0.0')
    @google_api_client.authorization.access_token = self.google_access_token
    @gmail = @google_api_client.discovered_api('gmail', "v1")
    @threads = @google_api_client.execute(
        api_method: @gmail.users.threads.list,
        parameters: {
            userId: "me",
            # searching messages based on number of queries:
            # https://developers.google.com/gmail/api/guides/filtering
            q: "to:vyu-all@vyutv.com"
        },
        headers: {'Content-Type' => 'application/json'}
        )
    @threads.data.threads.each do |t|
      @message_snippets = @google_api_client.execute(
        api_method: @gmail.users.threads.get,
        parameters: {
            userId: "me",
            id: t.id,
            fields: 'messages(payload,snippet) ',
            q: "to:vyu-all@vyutv.com"
        },
        headers: {'Content-Type' => 'application/json'}
        )
      if Bulletin.where(thread_id: t.id).to_a.length == 0
        Bulletin.create!(thread_id: t.id, message_snippets: JSON.parse(@message_snippets.body), subject: JSON.parse(@message_snippets.body)['messages'][0]['payload']['headers'].select{|v| v["name"] == "Subject" }[0])
      end
    end
  end

  def get_events_from_calendar
    self.refresh_google_access_token if self.google_token_expires.past?
    @google_api_client = Google::APIClient.new(
      :application_name => 'Vyu Backyard',
      :application_version => '1.0.0')
    @google_api_client.authorization.access_token = self.google_access_token
    @calendar = @google_api_client.discovered_api('calendar', "v3")
    @result = @google_api_client.execute(:api_method => @calendar.events.list, 
      :parameters => {'calendarId' => 'primary', :singleEvents => true,
      :timeMin => DateTime.now}, 
            )
    @events = JSON.parse(@result.body)['items']
  end

  def get_location_from_calendar
    self.refresh_google_access_token if self.google_token_expires.past?
    @google_api_client = Google::APIClient.new(
      :application_name => 'Vyu Backyard',
      :application_version => '1.0.0')
    @google_api_client.authorization.access_token = self.google_access_token
    @calendar = @google_api_client.discovered_api('calendar', "v3")
    @result = @google_api_client.execute(:api_method => @calendar.calendars.get,
          parameters: {
            'calendarId' => 'primary'
            }
            )
    if @result.body
      @location = JSON.parse(@result.body)['timeZone'].split("/")[1].split("_").join(" ")
    end
    if @location
      self.profile.update_attribute(:location, @location)
    end
  end

  def refresh_google_access_token
  options = {
    body: {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      refresh_token: self.google_refresh_token,
      grant_type: 'refresh_token'
    },
    headers: {
      'Content-Type' => 'application/x-www-form-urlencoded'
      }
  }
  @response = HTTParty.post('https://accounts.google.com/o/oauth2/token', options)
  if @response.code == 200
    self.google_access_token = @response.parsed_response['access_token']
    self.google_token_expires = Time.at(@response.parsed_response['expires_in'])
    self.save        
  else
    Rails.logger.error("Unable to refresh google_oauth2 authentication token.")
    Rails.logger.error("Refresh token response body: #{@response.body}")
  end
  end

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
end
