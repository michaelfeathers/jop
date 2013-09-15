

class Jop
  def initialize command_text
    @command_text = command_text
  end

  def numeric_literal? text
    text =~ /_?\d+/
  end

  def to_numeric text
     return text.to_i if text =~ /^\d+/
     return -(text[1..text.length-1]).to_i
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
      ary.zip(0..(ary.count)).sort_by {|e| e[0] }.map {|e| e[1] }
    when '\:'
      ary.zip(0..(ary.count)).sort_by {|e| e[0] }.map {|e| e[1] }.reverse
    when '<:'
      ary.map {|e| e - 1 }
    when '>:'
      ary.map {|e| e + 1 }
    else
      elements = @command_text.split
      if numeric_literal?(elements[0])
        times = to_numeric(elements[0])
        return ary.take(times) if times >= 0
        return ary.reverse.take(-times).reverse
      end
      []
    end
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end
