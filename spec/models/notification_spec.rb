require 'rails_helper'

RSpec.describe Notification, type: :model do
  before(:each) do
    @user = create(:user)
    @admin = create(:admin)
    @topic = create(:topic)
    @post = @topic.posts.create(content: "content", user_id: @user.id)
    @message_thread = MessageThread.create(topic: 'topic', sender_id: @user.id, addressee_id: @admin.id)
    @message = Message.create(content: 'content', sender_id: @user.id, addressee_id: @admin.id, message_thread_id: @message_thread.id, unread: true)
    @notification = Notification.create(notificationable_type: "Message",
                                        notificationable_id: @message.id,
                                        user_id: @user.id,
                                        name: "message")
    @notification2 = Notification.create(notificationable_type: "Post",
                                         notificationable_id: @post.id,
                                         user_id: @user.id,
                                         name: "post")
  end

  describe '.per_page' do
    it { expect(Notification.per_page).to eq(6) }
  end

  describe 'associations' do
    it { belong_to(:user) }
    it { belong_to(:notificationable) }
  end

  describe 'scopes' do
    it 'has default scope which sorts by updated_at' do
      expect(Notification.first).to eq(@notification2)
      expect(Notification.last).to eq(@notification)
    end

    it 'has unread scope which returns unread notification' do
      expect(Notification.unread.count).to eq(2)
      expect(Notification.unread.first).to eq(@notification2)
    end

    it 'has read scope which return read notifications' do
      expect(Notification.read.count).to eq(0)
    end
  end

  describe 'object' do
    it 'should returns request object' do
      expect(@notification.object).to eq(@message)
    end
  end

  describe 'unread?' do
    it 'should return true if notification is unread' do
      expect(@notification.unread?).to eq(true)
    end
  end

  describe 'read?' do
    it 'should returns true if has been read' do
      expect(@notification.read?).to eq(false)
    end
  end

  describe 'read' do
    it 'should be set to true by default' do
      expect(@notification.read).to eq(false)
    end
  end

  describe 'object_class_name' do
    it { expect(@notification.object_class_name).to eq("Message") }
  end

  describe 'mark_as_read' do
    it { expect(@notification.mark_as_read).to eq(true) }
  end
end
