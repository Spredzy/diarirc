require 'rubygems'

class Log

  attr_reader :nick, :reason, :date

  def initialize(nick, reason, date)
    @nick = nick
    @reason = reason
    @date = date
  end

  def to_s
    "[[#{reason}]] #{nick} - #{reason}"
  end

end
