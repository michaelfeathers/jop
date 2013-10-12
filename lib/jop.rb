
require 'tokenizer'

class Jop
  def initialize command_text
    @command_text = command_text
    @tokens = Tokenizer.new(command_text).tokens.reverse
  end

  def numeric_literal? text
    text =~ /^_?\d+/
  end

  def to_numeric text
     return text.to_i if text =~ /^\d+/
     -(text[1...text.length]).to_i
  end

  def grade_up ary
    ary.zip(0...ary.length).sort_by {|e| e[0] }.map {|e| e[1] }
  end

  def grade_down ary
    grade_up(ary).reverse
  end

  def fill_matrix ranges, elements
    return elements.next if ranges.size <= 0
    (0...ranges.first).map { fill_matrix(ranges.drop(1), elements) }
  end

  def generate_matrix elements, ary
    ranges = elements.take_while {|n| numeric_literal?(n) }.map(&:to_i)
    fill_matrix(ranges, ary.cycle.each)
  end

  def eval_on ary
    return [] if @tokens.empty?
    case @tokens[0]
    when '{.'
      if @tokens.size > 1 && numeric_literal?(@tokens[1])
        number = to_numeric(@tokens[1])
        if number >= 0
          ary.take(number)
        else
          ary.reverse.take(-number).reverse
        end
      else
        ary.take(1).first
      end
    when '}.'
      if @tokens.size > 1 && numeric_literal?(@tokens[1])
        number = to_numeric(@tokens[1])
        if number >= 0
          ary.drop(number)
        else
          ary.reverse.drop(-number).reverse
        end
      else
        ary.drop(1)
      end
    when '|.'
      if @tokens.size > 1 && numeric_literal?(@tokens[1])
        number = to_numeric(@tokens[1])
        segment_length = number % ary.length
        segment = ary.take(segment_length)
        ary.drop(segment_length) + segment
      else
        ary.reverse
      end
    when '#'
      ary.count
    when '+/'
      ary.reduce(:+)
    when '*/'
      ary.reduce(:*)
    when "/:~"
      ary.sort
    when '\:~'
      ary.sort.reverse
    when '/:'
      grade_up(ary)
    when '\:'
      grade_down(ary)
    when '<:'
      ary.map {|e| e - 1 }
    when '>:'
      ary.map {|e| e + 1 }
    when '%'
      ary.map {|e| 1 / e.to_f }
    when '-.'
      ary.map {|e| 1 - e }
    when '+:'
      ary.map {|e| e * 2 }
    when '-:'
      ary.map {|e| e / 2.0 }
    when '+/\\'
      sum = 0
      return ary.each_with_object([]) {|e, ac| sum = sum + e; ac << sum }
    when '{:'
      ary.drop(ary.count-1).first
    when '}:'
      ary.take(ary.count-1)
    when '*'
      ary.map {|e| e <=> 0 }
    when '^'
      ary.map {|n| Math::exp(n) }
    when '*:'
      ary.map {|e| e ** 2 }
    when '<.'
      ary.map {|e| e.floor }
    when '>.'
      ary.map {|e| e.ceil }
    when '$'
      elements = @tokens.drop(1).reverse
      return generate_matrix(elements, ary) if numeric_literal?(elements[0]) && numeric_literal?(elements[1])
      []
    end
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end





