

class Jop
  def initialize command_text
    @command_text = command_text
  end

  def eval_on ary
    return [] if @command_text.size == 0
    elements = []
    times = 0
    case @command_text
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
    else
      elements = @command_text.split
      times_string = elements[0]
      times = times_string[0] == '_' ? -times_string[1..(times_string.length-1)].to_i : times_string.to_i
      return ary.take(times) if times >= 0
      ary.reverse.take(-times).reverse
    end
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end
