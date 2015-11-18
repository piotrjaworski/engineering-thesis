class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :topics, class_name: "Topic", foreign_key: "creator_id"
  has_many :posts
  has_many :message_threads_received, class_name: "MessageThread", foreign_key: :addressee_id
  has_many :message_threads_sent, class_name: "MessageThread", foreign_key: :sender_id
  has_many :notifications

  validates_presence_of :full_name, :username
  validates_uniqueness_of :username

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>", small: "70x70", mini: "45x45" },
                             default_url: "/images/missing/:style.png",
                             url: "/system/:class/:attachment/:id/:style/:basename.:extension",
                             path: ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :avatar, content_type: ['image/gif', 'image/jpeg', 'image/png', 'image/x-ms-bmp']

  default_scope { order("created_at") }

  after_create :add_avatar_to_queue

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

  def avatar_from_url(url)
    self.avatar = open(url)
  end

  def latest_posts
    posts.order(created_at: :desc)
  end

  def latest_topics
    topics.order(created_at: :desc)
  end

  def user_errors
    errors.any? ? errors.full_messages.join("<br>".html_safe) : nil
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

  def add_avatar_to_queue
    AvatarsWorker.perform_async(id)
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

  def message_threads
    MessageThread.includes(:messages).where("addressee_id = ? or sender_id = ?", id, id).order(created_at: :desc)
  end

  def unread_message_threads
    message_threads_received.includes(:messages).where("messages.unread = ?", true).references(:messages)
  end

  def name_with_email
    "#{full_name} #{@addressee.email}"
  end
end
