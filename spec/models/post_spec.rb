require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:topic) { create(:topic) }
  let(:post) { topic.posts.first }

  describe '.per_page' do
    it { expect(Post.per_page).to eq(20) }
  end

  describe 'associations' do
    it { belong_to(:user) }
    it { belong_to(:topic) }
    it { have_many(:notifications) }
  end

  describe 'validations' do
    it { validate_length_of(:content) }
  end

  describe 'callbacks' do
    it "shouldn't update post if topic is closed" do
      post.topic.close
      expect(post.update_attribute(:content, "new cont")).to eq(false)
      expect(post.errors.present?).to eq(true)
      expect(post.errors.first.last).to eq("is blocked. Cannot edit/update post.")
    end

    it 'should set post a number' do
      new_post = topic.posts.create(content: "content", user_id: topic.posts.first.user_id)
      expect(post.number).to eq(1)
      expect(new_post.number).to eq(2)
    end

    it 'should increases edited count' do
      expect(post.edited_count).to eq(0)
      post.update_attribute(:content, "new content")
      expect(post.edited_count).to eq(1)
    end
  end

  describe 'default scope' do
    it 'should be set to created_at ASC' do
      new_post = topic.posts.create(content: "content", user_id: topic.posts.first.user_id)
      post.update_attribute(:content, "new content")
      expect(topic.posts.first).to eq(post)
      expect(topic.posts.last).to eq(new_post)
    end
  end
end
