class Bulletin
  include Mongoid::Document
  field :thread_id, type: String
  field :message_snippets, type: Object
  field :subject, type: Object
end
