class Message < ActiveRecord::Base
  belongs_to :addressee
  belongs_to :sender
  belongs_to :message_thread
end
