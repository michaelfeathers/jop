


class Tokenizer
  attr_reader :tokens

  def inflectable? char
    '+/'.include?(char)
  end

  def initialize text
    @tokens = []
    stream = make_stream(text)
    case stream[0]
    when '#'
      @tokens << stream[0]
    when '+'
      @tokens << stream[0]
    when ':'
      @tokens << (stream[1] + ':') if inflectable?(stream[1])
    else
      number = text.chars.take_while {|c| c =~ /^\d/ }.reduce(:+)
      @tokens << number if number && number.length > 0
    end
  end

  private

  def make_stream text
    text.reverse + (lookahead_pad = ' ')
  end

end
