class Post < ActiveRecord::Base
  include PgSearch

  self.per_page = 20

  multisearchable against: [:content]

  attr_accessor :who_deletes

  belongs_to :user
  belongs_to :topic
  has_many :notifications, as: :notificationable, dependent: :destroy

  before_save :set_post_number
  before_save :check_closed_topic
  after_create :notify_users, unless: :skip_callbacks
  before_update :increase_edited_count
  before_destroy :can_be_removed

  validates :content, length: { minimum: 4, allow_blank: false }

  default_scope { order("created_at ASC") }

  def self.search(query)
    Post.where("lower(content) LIKE ?", "%#{query.downcase}%")
  end

  def increase_edited_count
    self.edited_count += 1 unless new_record?
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

  def new?
  end

  def last?
    self == topic.posts.last ? true : false
  end

  private

  def can_be_removed
    if last? || who_deletes.superuser?
      topic = self.topic
      self.delete
      topic.recount_posts unless last?
    else
      return false
    end
  end

  def check_closed_topic
    if topic && topic.closed?
      errors.add(:topic, "is blocked. Cannot edit/update post.")
      return false
    end
  end

  def notify_users
    topic.all_users.each do |u|
      if u.want_post_notifications? and u != user
        NotificationsWorker.perform_async(u.id, class: "Post", id: id)
      end
    end
  end

  def skip_callbacks
    Rails.env == "test"
  end
end
