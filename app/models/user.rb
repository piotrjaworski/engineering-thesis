class User < ActiveRecord::Base
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :topics, class_name: 'Topic', foreign_key: 'creator_id'
  has_many :posts

  validates_presence_of :full_name, :username
  validates_uniqueness_of :username

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>", small: "70x70", mini: "45x45" },
                             default_url: "/images/:style/missing.png",
                             url: "/system/:class/:attachment/:id/:style/:basename.:extension",
                             path: ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :avatar, content_type: ['image/gif', 'image/jpeg', 'image/png', 'image/x-ms-bmp']

  before_create :get_avatar

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
    else
      "Undefinied role"
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
    self.avatar = gravatar.get_image(400)
    self.avatar_file_name = "gravatar-#{self.id}"
    self.gravatar = true
    self.save
    "Gravatar has been reloaded"
  end

end
