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


  has_one :profile

  # validates_format_of :email, with: /\@vyutv.com/


  def self.find_for_google_oauth2(access_token)
    data = access_token.info
    # puts data
    if User.where(:email => data.email).first
      user = User.where(:email => data.email).first
    else
      # @user = User.new(:email => data.email, :password => Devise.friendly_token[0,20])
      # @profile = Profile.new(:email => data.email, :name => data.name, :profile_picture => data.image)
      # if @user.save
        user = User.create!(:email => data.email, :password => Devise.friendly_token[0,20])
        Profile.create(:email => data.email, name: data.name, :profile_picture => data.image, :user_id => user.id)
        # profile = Profile.create!(:email => data.email, :name => data.name, :profile_picture => data.image)

      # end
    end
    user
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
