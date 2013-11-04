


class Tokenizer
  attr_reader :tokens

  def operator? char
    '~^-%*|<>\\{}+/#$!'.include?(char)
  end

  def initialize text
    @stream = text
    @tokens = []

    skip_whitespace
    while tokenizing?
      if operator?(current_char)
        if '.:'.include?(next_char)
          @tokens << current_char + next_char
          advance(2)
        else
          @tokens << current_char
          advance(1)
        end
      else
        if @stream =~ /^_?\d+/
          match_data = /^_?\d+/.match(@stream)
          @tokens << match_data[0]
          advance(match_data[0].length)
        else
          break
        end
      end
      skip_whitespace
    end
  end

  private

  def tokenizing?
    @stream.length > 0
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

  def skip_whitespace
    @stream.lstrip!
  end
end
