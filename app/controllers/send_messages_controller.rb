class SentMessagesController < EndUserBaseController
  before_filter :authenticate_filter

  def index
    @sent_messages = current_user.sent_messages.all
  end
end
