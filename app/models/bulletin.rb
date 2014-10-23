class Bulletin
  include Mongoid::Document
  field :thread_id, type: Integer
  field :message_snippets, type: Object
end
