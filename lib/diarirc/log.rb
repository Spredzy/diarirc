require 'rubygems'

class Log

  attr_reader :nick, :reason, :action, :date

  def initialize(nick, reason, action, date)
    @nick = nick
    @reason = reason
    @action = action
    @date = date
  end

  def to_s
    "[[#{@action}]] #{@nick} - #{@reason}"
  end

end
