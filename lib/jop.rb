

class Jop
  def initialize command_text
    @command_text = command_text
  end

  def numeric_literal? text
    text =~ /^_?\d+/
  end

  def to_numeric text
     return text.to_i if text =~ /^\d+/
     -(text[1...text.length]).to_i
  end

  def grade_up ary
    ary.zip(0..ary.count).sort_by {|e| e[0] }.map {|e| e[1] }
  end

  def grade_down ary
    grade_up(ary).reverse
  end

  def number_prefix_command command_ary, ary
    number = to_numeric(command_ary[0])
    case command_ary[1]
    when '{.'
      return ary.take(number) if number >= 0
      return ary.reverse.take(-number).reverse
    when '}.'
      return ary.drop(number) if number >= 0
      return ary.reverse.drop(-number).reverse
    when '|.'
      segment_length = number % ary.length
      segment = ary.take(segment_length)
      return ary.drop(segment_length) + segment
    end
    []
  end

  def eval_on ary
    return [] if @command_text.size == 0
    case @command_text
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
    when '|.'
      ary.reverse
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
    else
      elements = @command_text.split
      return number_prefix_command(elements, ary) if numeric_literal?(elements[0])
      []
    end
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end
