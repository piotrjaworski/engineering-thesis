class Post < ActiveRecord::Base
  include PgSearch

  self.per_page = 20

  multisearchable against: [:content]

  belongs_to :user
  belongs_to :topic, touch: true
  has_one :notification, as: :notificationable

  before_update :increase_edited_count
  # before_save :check_emoticons_path
  before_save :set_post_number

  validates_length_of :content, minimum: 4, allow_blank: false
  validate :closed_topic

  default_scope { order("created_at ASC") }

  def increase_edited_count
    self.edited_count += 1 unless new_record?
  end

  def check_emoticons_path
    self.content = content.gsub("assets", "/assets")
  end

  def set_post_number
    self.number = topic.posts.count + 1
  end

  def page
    page_number = number / Post.per_page.to_f
    if page_number < 1
      1
    else
      page_number > page_number.to_i ? page_number.to_i + 1 : page_number.to_i
    end
  end

  private

  def closed_topic
    if topic && topic.blocked
      return errors.add(:topic, "is blocked. Cannot edit/update post.")
    end
  end
end
