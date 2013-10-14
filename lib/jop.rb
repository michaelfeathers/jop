
require 'tokenizer'

class Op
  def numeric_literal? text
    text =~ /^_?\d+/
  end

  def to_numeric text
     return text.to_i if text =~ /^\d+/
     -(text[1...text.length]).to_i
  end

  def apply_monad_deep element, &block
    return yield element unless element.kind_of? Array
    element.map {|e| apply_monad_deep(e, &block) }
  end
end


class Ceil < Op; REP = '>.'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e.ceil }
  end
end


class Complement < Op; REP = '-.'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| 1 - e }
  end
end


class Curtail < Op; REP = '}:'
  def run ary, interpreter
      ary.take(ary.count-1)
  end
end


class Decrement < Op; REP = '<:'
  def run ary, interpreter
    ary.map {|e| e - 1 }
  end
end


class Double < Op; REP = '+:'
  def run ary, interpreter
    ary.map {|e| e * 2 }
  end
end


class Drop < Op; REP = '}.'
  def run ary, interpreter
    if interpreter.tokens.size > 0 && numeric_literal?(interpreter.tokens[0])
      number = to_numeric(interpreter.tokens[0])
      interpreter.advance(1)
      if number >= 0
        ary.drop(number)
      else
        ary.reverse.drop(-number).reverse
      end
    else
      ary.drop(1)
    end
  end
end


class Exp < Op; REP = '^'
  def run ary, interpreter
    apply_monad_deep(ary) {|n| Math::exp(n) }
  end
end


class Floor < Op; REP = '<.'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e.floor }
  end
end


class GradeDown < Op; REP = '\:'
  def run ary, interpreter
    GradeUp.new.run(ary, interpreter).reverse
  end
end


class GradeUp < Op; REP = '/:'
  def run ary, interpreter
    ary.zip(0...ary.length).sort_by {|e| e[0] }.map {|e| e[1] }
  end
end


class Halve < Op; REP = '-:'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e / 2.0 }
  end
end


class Identity < Op; REP = '+'
  def run ary, interpreter
    ary
  end
end

class Increment < Op; REP = '>:'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e + 1 }
  end
end


class Insert < Op; REP = '/'
  def run ary, interpreter
    if interpreter.tokens[0] == Identity::REP
      interpreter.advance(1)
      [ary.reduce(:+)]
    elsif interpreter.tokens[0] == Sign::REP
      interpreter.advance(1)
      [ary.reduce(:*)]
    end
  end
end


class Reciprocal < Op; REP = '%'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| 1 / e.to_f }
  end
end


class ReverseRotate < Op; REP = '|.'
  def run ary, interpreter
    if interpreter.tokens.size > 0 && numeric_literal?(interpreter.tokens[0])
      number = to_numeric(interpreter.tokens[0])
      interpreter.advance(1)
      segment_length = number % ary.length
      segment = ary.take(segment_length)
      ary.drop(segment_length) + segment
    else
      ary.reverse
    end
  end
end


class Shape < Op; REP = '$'
  def run ary, interpreter
    elements = interpreter.tokens.reverse
    interpreter.advance(elements.length)
    return generate_matrix(elements, ary) if numeric_literal?(elements[0]) && numeric_literal?(elements[1])
    []
  end

  private

  def fill_matrix ranges, elements
    return elements.next if ranges.size <= 0
    (0...ranges.first).map { fill_matrix(ranges.drop(1), elements) }
  end

  def generate_matrix elements, ary
    ranges = elements.take_while {|n| numeric_literal?(n) }.map(&:to_i)
    fill_matrix(ranges, ary.cycle.each)
  end
end


class Sign < Op; REP = '*'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e <=> 0 }
  end
end


class Square < Op; REP = '*:'
  def run ary, interpreter
    ary.map {|e| e ** 2 }
    apply_monad_deep(ary) {|e| e ** 2 }
  end
end


class Tail < Op; REP = '{:'
  def run ary, interpreter
      [ary.drop(ary.count-1).first]
  end
end


class Take < Op; REP = '{.'
  def run ary, interpreter
    if interpreter.tokens.size > 0 && numeric_literal?(interpreter.tokens[0])
      number = to_numeric(interpreter.tokens[0])
      interpreter.advance(1)
      if number >= 0
        ary.take(number)
      else
        ary.reverse.take(-number).reverse
      end
    else
      ary.take(1)
    end
  end
end


class Tally < Op; REP = '#'
  def run ary, interpreter
    [ary.count]
  end
end


class Tilde < Op; REP = '~'
  def run ary, interpreter
    if interpreter.tokens[0] == GradeUp::REP
      interpreter.advance(1)
      ary.sort
    elsif interpreter.tokens[0] == GradeDown::REP
      interpreter.advance(1)
      ary.sort.reverse
    end
  end
end


class Jop
  attr_reader :tokens

  def initialize command_text
    @command_text = command_text
    @tokens = Tokenizer.new(command_text).tokens.reverse
  end

  def advance amount
    @tokens = @tokens[amount...@tokens.length]
  end

  def eval_on ary
    result = ary
    while not @tokens.empty?
      result = eval_op(result)
    end
    result
  end

  private

  def operators
    if not @operators
      @operators = []
      ObjectSpace.each_object(::Class) {|klass| @operators << klass.new if klass < Op }
    end
    @operators
  end

  def eval_op ary
    op = @tokens[0]
    advance(1)
    selected = operators.select {|op_class| op_class.class::REP == op }
    selected.first.run(ary, self) if selected.size == 1
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end





