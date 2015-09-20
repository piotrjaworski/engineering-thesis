class Post < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:content]

  belongs_to :user
  belongs_to :topic, touch: true
  before_update :increase_edited_count

  default_scope { order("created_at ASC") }

  def increase_edited_count
    self.edited_count = self.edited_count + 1 unless new_record?
  end

end
