class Topic < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:name, :description]

  is_impressionable counter_cache: true, column_name: :views

  belongs_to :category
  belongs_to :user, class_name: 'User', foreign_key: 'creator_id'
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts, reject_if: proc { |attributes| attributes['content'].blank? }

  validates_presence_of :name, :category

  default_scope { order("updated_at DESC") }
  scope :top_records, -> { unscope(:order).order("views DESC") }
  scope :new_records, -> { where("created_at >= ?", Time.now - 6.hours) }

  def to_param
    [id, name.parameterize].join("-")
  end

  def posts_count
    posts.count
  end

  def new?
    (Time.parse(DateTime.now.to_s) - Time.parse(created_at.to_s))/3600 < 6 ? true : false
  end

  def assign_user(user)
    posts.each { |p| p.user_id = user.id }
  end

  def self.build_new(user, params)
    topic = user.topics.new(params)
    topic.assign_user(user)
    topic
  end

  def build_post(user, params)
    post = self.posts.new(params)
    post.user = user
    post
  end

  def close
    self.update_column(:blocked, true)
  end

  def closed?
    blocked
  end

  def opened?
    !blocked
  end

  def open
    self.update_column(:blocked, false)
  end

  def creator
    User.find(self.creator_id)
  end

  def users
    User.find(users_ids)
  end

  def users_ids
    posts.pluck(:user_id).reverse.uniq.take(4)
  end

end
