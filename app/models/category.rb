class Category < ActiveRecord::Base
  self.per_page = 20

  has_many :topics

  before_destroy :check_topics

  validates :name, presence: true, uniqueness: true

  def self.search(query)
    Category.where("lower(name) LIKE ?", "%#{query.downcase}%")
  end

  def no_topics?
    topics.empty?
  end

  private

  def check_topics
    return false if topics.present?
  end
end
