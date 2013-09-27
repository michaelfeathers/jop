


class Tokenizer
  attr_reader :tokens

  def inflectable? char
    '+/'.include?(char)
  end

  def initialize text
    @tokens = []
    stream = make_stream(text)
    case stream[0]
    when '#','+'
      @tokens << stream[0]
    when ':'
      @tokens << (stream[1] + ':') if inflectable?(stream[1])
    else
      @tokens << text.to_i.to_s if text =~ /^\d/
    end
  end

  private

  def make_stream text
    text.reverse + (lookahead_pad = ' ')
  end

end
