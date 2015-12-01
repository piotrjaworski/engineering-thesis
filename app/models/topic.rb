class Topic < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:name, :description]

  self.per_page = 30

  is_impressionable counter_cache: true, column_name: :views

  belongs_to :category
  belongs_to :user, class_name: 'User', foreign_key: 'creator_id'
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts, reject_if: proc { |attributes| attributes['content'].blank? }

  validates :name, :category, presence: true

  default_scope { order("updated_at DESC") }
  scope :top_records, -> { unscope(:order).order("views DESC") }
  scope :new_records, -> { where("created_at >= ?", Time.zone.now - 6.hours) }

  def to_param
    [id, name.parameterize].join("-")
  end

  def self.search(query)
    Topic.where("lower(name) LIKE ? OR lower(description) LIKE ?", "%#{query.downcase}%", "%#{query.downcase}%")
  end

  def self.build_new(user, params)
    topic = user.topics.new(params)
    topic.assign_user(user)
    topic
  end

  def build_post(user, params)
    post = posts.new(params)
    post.user = user
    post
  end

  def new?
    (Time.zone.parse(DateTime.now.in_time_zone.to_s) - Time.zone.parse(created_at.to_s)) / 3600 < 6 ? true : false
  end

  def assign_user(user)
    posts.each { |p| p.user_id = user.id }
  end

  def close
    return false if closed?
    update_column(:blocked, true)
  end

  def open
    return false if opened?
    update_column(:blocked, false)
  end

  def closed?
    blocked
  end

  def opened?
    !blocked
  end

  def creator
    User.find(creator_id)
  end

  def users
    User.find(users_ids)
  end

  def all_users
    User.where(id: posts.pluck(:user_id).uniq)
  end

  def users_ids
    posts.pluck(:user_id).uniq.reverse.take(4)
  end

  def can_delete?
    if posts.count < 2
      true
    else
      false
    end
  end

  def last_page
    last_post = Post.unscoped do
      posts.order(number: :desc).limit(1).first
    end
    page = last_post.number.to_f / Post.per_page
    page > page.to_i ? page.to_i + 1 : page.to_i
  end
end
