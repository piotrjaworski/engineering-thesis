class MessageThread < ActiveRecord::Base
  belongs_to :sender, class_name: "User", primary_key: :sender_id, foreign_key: :id
  belongs_to :addressee, class_name: "User", primary_key: :addressee_id, foreign_key: :id
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages, reject_if: proc { |attributes| attributes['content'].blank? }

  self.per_page = 15

  def to_param
    [id, topic.parameterize].join('-')
  end

  def exclude_user(user)
    user_id = user.id == addressee_id ? sender_id : addressee_id
    User.find(user_id)
  end

end
