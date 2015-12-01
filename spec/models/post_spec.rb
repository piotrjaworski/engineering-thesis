require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '.per_page' do
    it { expect(Post.per_page).to eq(20) }
  end

  describe 'associations' do
    it { belong_to(:user) }
    it { belong_to(:topic) }
    it { have_many(:notifications) }
  end
end
