require 'rails_helper'

RSpec.describe Message, type: :model do
  before(:each) do
    @user = create(:user)
    @user1 = create(:user)
    @admin = create(:admin)
    @message_thread = MessageThread.create(topic: 'topic', sender_id: @user.id, addressee_id: @admin.id)
    @message = Message.create(content: 'content', sender_id: @user.id, addressee_id: @admin.id, message_thread_id: @message_thread.id, unread: true)
  end

  describe 'associations' do
    it { belong_to(:addressee) }
    it { belong_to(:sender) }
    it { belong_to(:message_thread) }
    it { have_one(:notifiaction) }
  end

  describe 'users' do
    it 'should returns users only which belong to message' do
      expect(User.count).not_to eq(2)
      expect(@message.users.count).to eq(2)
    end
  end

  describe 'exclude_user' do
    it 'should returns not excluded users' do
      expect(@message.exclude_user(@user)).to eq(@admin)
      expect(@message.exclude_user(@admin)).to eq(@user)
    end
  end

  describe 'mark_as_read' do
    it 'should marks as read requested message' do
      expect(@message.unread).to eq(true)
      expect(@message.mark_as_read).to eq(true)
    end

    it 'should marks as read requested message' do
      @message.mark_as_read
      expect(@message.unread).to eq(false)
      expect(@message.mark_as_read).to eq(false)
    end
  end
end
