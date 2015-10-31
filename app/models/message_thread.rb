class MessageThread < ActiveRecord::Base
  belongs_to :sender, class_name: "User", primary_key: :sender_id, foreign_key: :id
  belongs_to :addressee, class_name: "User", primary_key: :addressee_id, foreign_key: :id
  has_many :messages
  accepts_nested_attributes_for :messages, reject_if: proc { |attributes| attributes['content'].blank? }

  self.per_page = 15

  def to_param
    [id, topic.parameterize].join('-')
  end

end
