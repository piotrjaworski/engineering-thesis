class MessageThreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message_thread, only: [:show, :respond, :reply]
  before_action :mark_as_read, only: [:show]

  autocomplete :user, :username

  def index
    @message_threads = if params[:type].nil? or params[:type] == "all"
                         current_user.message_threads.paginate(page: params[:page])
                       elsif params[:type] == "mine"
                         current_user.message_threads_sent.paginate(page: params[:page])
                       elsif params[:type] == "unread"
                         current_user.unread_message_threads.paginate(page: params[:page])
                       else
                         redirect_to user_message_threads_path(current_user) and return
                         flash[:error] = "Wrong message sort type"
                       end
    @message_threads_count = current_user.message_threads.count
    @started_threads_count = current_user.message_threads_sent.count
    @unread_threads_count = current_user.unread_message_threads.count

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    if params[:new].present?
      @message_thread = current_user.message_threads_sent.new
    else
      @addressee = User.friendly.find(params[:user_id])
      @message_thread = current_user.message_threads_sent.new(addressee_id: @addressee.id)
    end
    @message_thread.messages.build
  end

  def create
    addressee_id = check_user_params
    return redirect_to user_message_threads_path(current_user), alert: "Cannot send message to user who doesn't exist" if addressee_id.nil?

    @message_thread = current_user.message_threads_sent.new(message_thread_params.except(:message))
    @message_thread.addressee_id = addressee_id if @message_thread.addressee_id.nil?
    @message_thread.messages.new(addressee_id: addressee_id, sender_id: current_user.id, content: message_thread_params.delete(:message)[:content])

    return redirect_to user_message_threads_path(current_user), alert: "You cannot send message to yourself" if addressee_id == current_user.id
    if @message_thread.save
      redirect_to user_message_thread_path(current_user, @message_thread), notice: "Your message has been submitted successfully"
    else
      render :new, alert: "Cannot submit this message, #{@message_thread.errors}"
    end
  end

  def show
    @new_message = Message.new(sender_id: current_user.id)
  end

  def reply
    @message = @message_thread.messages.new(content: params[:message][:content], sender_id: current_user.id)
    @message.addressee = @message.exclude_user(current_user)
    if @message.save
      redirect_to user_message_thread_path(current_user, @message_thread), notice: "Your message has been sent successfully"
    else
      redirect_to user_message_thread_path(current_user, @message_thread), alert: "Cannot send message, please try again"
    end
  end

  private

  def message_thread_params
    params.require(:message_thread).permit(:addressee_id, :topic, message: [:content])
  end

  def set_message_thread
    @message_thread = MessageThread.includes(:messages).find(params[:id])
  end

  def check_user_params
    if params["message_thread"]["addressee"]
      User.find_by_username(params["message_thread"]["addressee"]).try(:id)
    else
      message_thread_params.delete(:addressee_id)
    end
  end

  def mark_as_read
    @message_thread.messages.where(unread: true).each { |message| message.mark_as_read if message.addressee_id == current_user.id }
  end
end
