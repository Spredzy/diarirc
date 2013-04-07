require 'rubygems'

class Message

  attr_reader :nick, :message, :date

  def initialize(nick, message, date)
    @nick = nick
    @message = message
    @date = date
  end

  def to_s
    "[#{date}] #{nick}> #{message}"
  end

end
