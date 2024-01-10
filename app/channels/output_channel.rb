class OutputChannel < ApplicationCable::Channel
  def subscribed
    stream_for "OutputChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
