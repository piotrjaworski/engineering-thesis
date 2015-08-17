class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  before_update :increase_edit_count

  default_scope { order("created_at ASC") }

  def increase_edit_count
    binding.pry
    self.edited_count += 1
  end

end
