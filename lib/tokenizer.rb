


class Tokenizer
  attr_reader :tokens

  def operator? char
    '+/#'.include?(char)
  end

  def initialize text
    @tokens = []
    stream = make_stream(text)

    while stream.length > 0
      if operator?(stream[0])
        if '.:'.include?(stream[1])
          @tokens << stream[0] + stream[1]
          stream = stream[2..-1]
        else
          @tokens << stream[0]
          stream = stream[1..-1]
        end
      else
        @tokens << stream.to_i.to_s if stream =~ /^\d/
          stream = stream[1..-1]
      end
    end
  end

  private

  def make_stream text
    text + ' '
  end

end
