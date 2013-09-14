

class Jop
  def initialize command_text
    @command_text = command_text
  end

  def eval_on ary
    return ary if @command_text.empty?
    return ary.reduce(:+) if @command_text == "+/"
    []
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end
