


class Tokenizer
  attr_reader :tokens

  def initialize text
    @tokens = []
    number = text.chars.take_while {|c| c =~ /\d/ }.reduce(:+)
    @tokens << number if number && number.length > 0
  end
end
