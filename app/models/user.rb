class User < ActiveRecord::Base
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :topics, class_name: 'Topic', foreign_key: 'creator_id'
  has_many :posts

  validates_presence_of :full_name, :username
  validates_uniqueness_of :username

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "120x120>", small: "60x60" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_create :create_avatar

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

  def create_avatar
    gravatar = Gravatar.new(email)
    self.avatar = gravatar.get_image(400)
  end

end
