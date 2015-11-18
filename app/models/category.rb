class Category < ActiveRecord::Base
  has_many :topics
  before_destroy :check_topics

  validates :name, presence: true, uniqueness: true

  private

  def check_topics
    return false if topics.present?
  end
end
