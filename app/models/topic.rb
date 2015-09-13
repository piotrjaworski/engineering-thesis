class Topic < ActiveRecord::Base
  is_impressionable counter_cache: true, column_name: :views

  belongs_to :category
  belongs_to :user, class_name: 'User', foreign_key: 'creator_id'
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts, reject_if: proc { |attributes| attributes['content'].blank? }

  validates_presence_of :name

  default_scope { order("updated_at DESC") }
  scope :top_records, -> { unscope(:order).order("views DESC") }
  scope :new_records, -> { where("created_at >= ?", Time.now - 1.minutes) }

  def posts_count
    posts.count
  end

  def new?
    (Time.parse(DateTime.now.to_s) - Time.parse(created_at.to_s))/3600 < 6 ? true : false
  end

  def assing_user(user)
    posts.each { |p| p.user_id = user.id }
  end

  def self.build_new(user, params)
    topic = user.topics.new(params)
    topic.assing_user(user)
    topic
  end

  def build_post(user, params)
    post = self.posts.new(params)
    post.user = user
    post
  end

end
