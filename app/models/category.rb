class Category < ActiveRecord::Base
  has_many :topics
  before_create :set_position

  validates :name, presence: true, uniqueness: true

  default_scope { order(position: :asc) }

  def set_position
    self.position = Category.last.nil? ? 1 : Category.last.position + 1
  end

end
