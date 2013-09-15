

class Jop
  def initialize command_text
    @command_text = command_text
  end

  def eval_on ary
    case @command_text
    when '+/'
      ary.reduce(:+)
    when '*/'
      ary.reduce(:*)
    when "/:~"
      ary.sort
    when '\:~'
      ary.sort.reverse
    else
      []
    end
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end
