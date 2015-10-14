class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :topics, class_name: 'Topic', foreign_key: 'creator_id'
  has_many :posts

  validates_presence_of :full_name, :username
  validates_uniqueness_of :username

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>", small: "70x70", mini: "45x45" },
                             default_url: "/images/missing/:style.png",
                             url: "/system/:class/:attachment/:id/:style/:basename.:extension",
                             path: ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :avatar, content_type: ['image/gif', 'image/jpeg', 'image/png', 'image/x-ms-bmp']

  default_scope { order("created_at") }

  after_create :get_avatar

  # def to_param
  #   [id, username.parameterize].join("-")
  # end

  def user_errors
    errors.any? ? errors.full_messages.join("<br>".html_safe) : nil
  end

  def role?
    if is_admin?
      "Admin"
    elsif is_moderator?
      "Moderator"
    elsif is_user?
      "User"
    end
  end

  def is_admin?
    role == 1
  end

  def is_moderator?
    role == 2
  end

  def is_user?
    role == 3
  end

  def get_avatar
    gravatar = Gravatar.new(email)
    image = gravatar.get_image(400)
    if !!image
      self.avatar = image
      self.gravatar = true
      self.save
      "Gravatar has been reloaded"
    else
      "Please set your gravatar"
    end
  end

end
