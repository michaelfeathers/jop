

class JopArray
  def initialize ary
    @ary = ary
  end

  def sum
    reduce('+')
  end

  def factorial
    @ary.j('!')
  end

  def rotate ary
    @ary.j(ary.first.to_s + ' |.')
  end

  def reduce op_string
    @ary.j(op_string + '/')
  end

  def select ary
    @ary.j("#{as_s(ary)}" + '}')
  end

  private

  def as_s ary
    ary.map(&:to_s).join(' ')
  end

end
