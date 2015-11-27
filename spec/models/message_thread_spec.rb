require 'rails_helper'

RSpec.describe MessageThread, type: :model do
  before(:all) do
    @user = create(:user)
    @admin = create(:admin)
    @message_thread = MessageThread.create(topic: 'topic', sender_id: @user.id, addressee_id: @admin.id)
    @message_thread2 = MessageThread.create(topic: 'topic2', sender_id: @user.id, addressee_id: @admin.id)
    @message = Message.create(content: 'content', sender_id: @user.id, addressee_id: @admin.id, message_thread_id: @message_thread.id, unread: true)
    @message = Message.create(content: 'content', sender_id: @user.id, addressee_id: @admin.id, message_thread_id: @message_thread2.id, unread: false)
  end

  describe 'scopes' do
    it 'has default set to updated_at desc' do
      expect(MessageThread.first).to eq(@message_thread2)
      expect(MessageThread.last).to eq(@message_thread)
      @message_thread.update_attributes(topic: 'topic3')
      expect(MessageThread.first).to eq(@message_thread)
      expect(MessageThread.last).to eq(@message_thread2)
    end

    it 'has unread scope which return only unread message_threads' do
      expect(MessageThread.unread.count).to eq(1)
      expect(MessageThread.unread.first).to eq(@message_thread)
    end
  end

  describe '.per_page' do
    it { expect(MessageThread.per_page).to eq(12) }
  end

  describe 'associations' do
    it { belong_to(:sender) }
    it { belong_to(:addressee) }
    it { have_many(:messages) }
  end

  describe 'to_param' do
    it 'should returns valid friendly id format' do
      expect(@message_thread.to_param).to eq("#{@message_thread.id}-#{@message_thread.topic.parameterize}")
    end
  end

  describe 'exclude_user' do
    it 'should returns not excluded users' do
      expect(@message.exclude_user(@user)).to eq(@admin)
      expect(@message.exclude_user(@admin)).to eq(@user)
    end
  end

  describe 'unread?' do
    it 'should returns if thread has unread messages addressed to requested user' do
      expect(@message_thread.unread?(@user)).to eq(false)
      expect(@message_thread.unread?(@admin)).to eq(true)
    end
  end
end
