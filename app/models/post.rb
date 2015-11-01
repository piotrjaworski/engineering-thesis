class Post < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:content]

  belongs_to :user
  belongs_to :topic, touch: true
  before_update :increase_edited_count
  before_save :check_emoticons_path
  before_save :set_post_number
  validates_length_of :content, minimum: 4, allow_blank: false
  validate :closed_topic

  default_scope { order("created_at ASC") }

  def increase_edited_count
    self.edited_count = self.edited_count + 1 unless new_record?
  end

  def check_emoticons_path
    # tinymce issue
    self.content = self.content.gsub("assets", "/assets")
  end

  def set_post_number
    self.number = self.topic.posts.count + 1
  end

  private

    def closed_topic
      if self.topic.blocked
        return errors.add(:topic, "is blocked. Cannot edit/update post.")
      end
    end

end
