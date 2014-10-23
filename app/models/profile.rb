class Profile
  include Mongoid::Document
  belongs_to :user
  field :name, type: String
  field :location, type: String
  field :contact_info, type: String
  field :email, type: String
  field :profile_picture, type: String
  field :job_title, type: String
end