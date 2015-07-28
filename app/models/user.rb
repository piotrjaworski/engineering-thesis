class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :topics, class_name: 'Topic', foreign_key: 'creator_id'
  has_many :posts

  validates_presence_of :full_name, :username
  validates_uniqueness_of :username

  def image_url(size = 200)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png&?s=#{size}"
  end

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

end
