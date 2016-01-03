class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged

  self.per_page = 20

  delegate :location, :about_me, :signature, :webpage, :post_notifications, :message_notifications, to: :profile

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :topics, class_name: "Topic", foreign_key: "creator_id"
  has_many :posts
  has_many :message_threads_received, class_name: "MessageThread", foreign_key: :addressee_id
  has_many :message_threads_sent, class_name: "MessageThread", foreign_key: :sender_id
  has_many :notifications
  has_one :profile, dependent: :destroy

  before_create :create_profile
  after_create :add_avatar_to_queue, unless: :skip_callbacks

  validates :full_name, :username, presence: true
  validates :username, uniqueness: true

  default_scope { order("created_at") }

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>", small: "70x70", mini: "45x45" },
                             default_url: "/images/missing/:style.png",
                             url: "/system/:class/:attachment/:id/:style/:basename.:extension",
                             path: ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :avatar, content_type: ['image/gif', 'image/jpeg', 'image/png', 'image/x-ms-bmp']

  ROLES = { 1 => :admin, 2 => :moderator, 3 => :user }

  def self.from_omniauth(response)
    data = response.info
    user = User.find_by_email(data[:email])
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: data[:email], password: password, password_confirmation: password,
                      uid: response[:uid], provider: "google", full_name: data[:name], username: data[:email])
      user.avatar_from_url(response[:info][:image])
      user.save
    end
    user.update_attributes(provider: "google", uid: response[:uid]) if user.provider != "google"
    user
  end

  def self.search(query)
    User.where("lower(username) LIKE ? OR lower(full_name) LIKE ? OR lower(email) LIKE ?",
               "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%")
  end

  def avatar_from_url(url)
    self.avatar = open(url)
  end

  def latest_posts
    posts.order(created_at: :desc)
  end

  def latest_topics
    topics.order(created_at: :desc)
  end

  def message_threads
    MessageThread.includes(:messages).where("addressee_id = ? or sender_id = ?", id, id).order(created_at: :desc)
  end

  def unread_message_threads
    message_threads_received.includes(:messages).where("messages.unread = ?", true).references(:messages)
  end

  def user_errors
    errors.any? ? errors.full_messages.join("<br>".html_safe) : nil
  end

  def want_message_notifications?
    profile.message_notifications
  end

  def want_post_notifications?
    profile.post_notifications
  end

  def is?(role)
    ROLES[self.role] == role
  end

  def role?
    if admin?
      "Admin"
    elsif moderator?
      "Moderator"
    elsif user?
      "User"
    end
  end

  def admin?
    role == 1
  end

  def moderator?
    role == 2
  end

  def user?
    role == 3
  end

  def superuser?
    admin? || moderator?
  end

  def blocked?
    blocked
  end

  def block
    return false if blocked || admin?
    update_attribute(:blocked, true)
  end

  def unblock
    return false if !blocked || admin?
    update_attribute(:blocked, false)
  end

  def get_avatar
    gravatar = Gravatar.new(email)
    image = gravatar.get_image(400)
    if image.present?
      self.avatar = image
      self.gravatar = true
      save
      "Gravatar has been reloaded"
    else
      "Please set your gravatar"
    end
  end

  def name_with_email
    "#{full_name} #{@addressee.email}"
  end

  private

  def create_profile
    build_profile
  end

  def add_avatar_to_queue
    AvatarsWorker.perform_async(id)
  end

  def skip_callbacks
    Rails.env == "test"
  end
end
