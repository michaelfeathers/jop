 require 'tokenizer'

class Op
  def numeric_literal? text
    text =~ /^_?\d+/
  end

  def to_numeric text
     return text.to_i if text =~ /^\d+/
     -(text[1...text.length]).to_i
  end

  def integer_args interpreter
    interpreter.tokens
               .take_while {|n| numeric_literal?(n) }
               .reverse
               .map {|s| to_numeric(s) }
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
    apply_monad_deep(ary) {|e| e - 1 }
  end
end


class Double < Op; REP = '+:'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e * 2 }
  end
end

class Drop < Op; REP = '}.'
  def run ary, interpreter
    args = integer_args(interpreter)
    return ary.drop(1) if args.empty?
    count = args[0]
    interpreter.advance(1)
    count >= 0 ? ary.drop(count) : ary.reverse.drop(-count).reverse
  end

end


class Exp < Op; REP = '^'
  def run ary, interpreter
    apply_monad_deep(ary) {|n| Math::exp(n) }
  end
end


class Factorial < Op; REP = '!'
  def run ary, interpreter
    apply_monad_deep(ary) {|n| (1..n).reduce(:*) || 1 }
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


class Increment < Op; REP = '>:'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e + 1 }
  end
end


class Insert < Op; REP = '/'
  def run ary, interpreter
    if interpreter.tokens[0] == Plus::REP
      interpreter.advance(1)
      box ary.reduce(&method(:add))
    elsif interpreter.tokens[0] == Sign::REP
      interpreter.advance(1)
      box ary.reduce(:*)
    end
  end

  private

  def add x, y
    return x + y unless arrays? [x,y]
    x.zip(y).map {|x,y| add(x,y) }
  end

  def box e
    e.kind_of?(Array) ? e : [e]
  end

  def arrays? ary
    ary.all? {|e| e.kind_of? Array }
  end
end


class NoOp < Op; REP = ''
  def run ary, interpreter
  end
end


class Plus < Op; REP = '+'
  def run ary, interpreter
    args = integer_args(interpreter)
    interpreter.advance(args.length)
    args.empty? ? ary : ary.zip(args).map {|x,y| x + y }
  end
end


class Reciprocal < Op; REP = '%'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| 1 / e.to_f }
  end
end


class RandomOp < Op; REP = '?'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| @@generator.rand }
  end

  @@generator = Random::DEFAULT

  def RandomOp.generator= new_value
    @@generator = new_value
  end
end


class ReverseRotate < Op; REP = '|.'
  def run ary, interpreter
    args = integer_args(interpreter)
    return ary.reverse if args.empty?
    return [] unless args.size == 1
    steps = args.first
    interpreter.advance(1)

    segment_length = steps % ary.length
    segment = ary.take(segment_length)
    ary.drop(segment_length) + segment
  end
end


class Select < Op; REP = '}'
  def run ary, interpreter
    indices = integer_args(interpreter)
    interpreter.advance(indices.length)
    indices.map {|i| ary[i] }
  end
end


class Shape < Op; REP = '$'
  def run ary, interpreter
    ranges = integer_args(interpreter)
    return shape_of(ary) if ranges.empty?
    interpreter.advance(ranges.length)
    construct(ranges, ary)
  end

  def shape_of ary
    shape = []
    while ary.kind_of? Array
      shape << ary.size
      ary = ary.first
    end
    shape
  end

  def construct ranges, elements
    fill_matrix(ranges, elements.cycle.each)
  end

  private

  def fill_matrix ranges, elements
    return elements.next if ranges.size <= 0
    (0...ranges.first).map { fill_matrix(ranges.drop(1), elements) }
  end
end


class Sign < Op; REP = '*'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e <=> 0 }
  end
end


class Square < Op; REP = '*:'
  def run ary, interpreter
    apply_monad_deep(ary) {|e| e ** 2 }
  end
end


class Tail < Op; REP = '{:'
  def run ary, interpreter
    ary.drop(ary.count-1)
  end
end


class Take < Op; REP = '{.'
  def run ary, interpreter
    args = integer_args(interpreter)
    return ary.take(1) if args.empty?
    count = args[0]
    interpreter.advance(1)
    count >= 0 ? padded_take(ary, count) : padded_take(ary.reverse, -count).reverse
  end

  private

  def padded_take ary, n
    pad_out(ary, n).take(n)
  end

  def pad_out ary, n
    pad_length = [0, n - ary.length].max
    ary + pad(ary) * pad_length
  end

  def pad ary
    return [0] unless ary.first.kind_of? Array
    op = Shape.new
    shape = op.shape_of(ary[0])
    [op.construct(shape, [0])]
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
    @tokens = Tokenizer.new(command_text).tokens.reverse
  end

  def advance amount
    @tokens = @tokens[amount...@tokens.length]
  end

  def eval_on ary
    until @tokens.empty?
      ary = eval_op(ary)
    end
    ary
  end

  private

  def operators
    unless @operators
      @operators = []
      ObjectSpace.each_object(::Class) {|klass| @operators << klass.new if klass < Op }
    end
    @operators
  end

  def eval_op ary
    token = @tokens[0]
    advance(1)
    operators.detect(NoOp.new) {|op| op.class::REP == token }
             .run(ary, self)
  end
end

class Array
  def j command_text
    Jop.new(command_text).eval_on(self)
  end
end





