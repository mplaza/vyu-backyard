class Tool
  include Mongoid::Document
  field :name, type: String
  field :link, type: String
  field :description, type: String
end
