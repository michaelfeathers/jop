


class Tokenizer
  attr_reader :tokens, :stream

  def operator? char
    '+/#'.include?(char)
  end

  def initialize text
    @stream = make_stream(text)
    @tokens = []

    while stream.length > 0
      if operator?(current_char)
        if '.:'.include?(next_char)
          @tokens << current_char + next_char
          advance(2)
        else
          @tokens << current_char
          advance(1)
        end
      else
        if stream =~ /^\d/
          len = stream.chars.take_while {|e| e =~ /^\d/ }.length
          @tokens << stream.to_i.to_s
          advance(len)
        end
      end
    end
  end

  private

  def make_stream text
    text
  end

  def current_char
    @stream.length > 0 ? @stream[0] : ' '
  end

  def next_char
    @stream.length > 1 ? @stream[1] : ' '
  end

  def advance amount
    @stream = @stream[amount..-1]
  end


end
