


class Tokenizer
  attr_reader :tokens

  def initialize text
    @stream = text
    @tokens = []

    while tokenizing?
      skip_whitespace
      if operator?
        operator_token
      elsif numeric?
        numeric_token
      else
        break
      end
    end
  end

  private

  def operator_token
    if not '.:'.include?(next_char)
      @tokens << current_char
      advance(1)
      return
    end
    @tokens << current_char + next_char
    advance(2)
  end

  def numeric_token
    match_data = /^_?\d+/.match(@stream)
    @tokens << match_data[0]
    advance(match_data[0].length)
  end

  def operator?
    '~^-%*|<>\\{}+/#$!?i'.include?(current_char)
  end

  def numeric?
     @stream =~ /^_?\d+/
  end

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
