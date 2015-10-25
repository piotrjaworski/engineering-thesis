class MessageThreadsController < ApplicationController

  def new
    @addressee = User.friendly.find(params[:user_id])
    @message_thread = current_user.message_threads_sent.new(addressee_id: @addressee.id)
    @message_thread.messages.build
  end

  def create
    @message_thread = current_user.message_threads_sent.new(message_thread_params.except(:message))
    @message_thread.messages.new(addressee_id: message_thread_params.delete(:addressee_id),
                                sender_id: current_user.id,
                                content: message_thread_params.delete(:message)[:content])
    if @message_thread.save
      redirect_to root_path, notice: "created"
    else
      redirect_to root_path, alert: "failed"
    end
  end

  private

    def message_thread_params
      params.require(:message_thread).permit(:addressee_id, :topic, { message: [:content] })
    end

end
