

require 'jop'

describe Jop do
  it "does identity" do
    [].j('').should eq([])
  end

  it "sums" do
    [3,2,1].j('+/').should eq([6])
  end

  it "multiplies" do
    [2,4,6].j('*/').should eq([48])
  end

  it "sorts ascending" do
    [1,0,2].j('/:~').should eq([0,1,2])
  end

  it "sort descending" do
    [1,0,2].j('\:~').should eq([2,1,0])
  end

  it "reverses" do
    [1,0,2].j('|.').should eq([2,0,1])
  end

  it "takes two elements" do
    [1,2,3].j('2 {.').should eq([1,2])
  end

  it "takes one element" do
    [1,2,3,4].j('1 {.').should eq([1])
  end

  it "takes three elements" do
    [1,2,3,4].j('3 {.').should eq([1,2,3])
  end

  it "overtakes" do
    [1,2,3].j('5 {.').should eq([1,2,3,0,0])
  end

  it "undertakes" do
    [1,2,3].j('_5 {.').should eq([0,0,1,2,3])
  end

  it "takes negative elements" do
    [1,2,3].j('_2 {.').should eq([2,3])
  end

  it "drops two elements" do
    [1,2,3].j('2 }.').should eq([3])
  end

  it "drops negative elements" do
    [1,2,3].j('_2 }.').should eq([1])
  end

  it "grades up" do
    [3,5,4].j('/:').should eq([0,2,1])
  end

  it "grades down" do
    [3,5,4].j('\:').should eq([1,2,0])
  end

  it "decrements" do
    [1,2,3].j('<:').should eq([0,1,2])
  end

  it "increments" do
    [1,2,3].j('>:').should eq([2,3,4])
  end

  it "sizes arrays" do
    [1,2].j('#').should eq([2])
  end

  it "calculates the reciprocal" do
    [1,2].j('%').should eq([1,0.5])
  end

  it "calculates the reciprocal with zeros" do
    [0].j('%').should eq([Float::INFINITY])
  end

  it "does complements" do
    [0.3,0.2].j('-.').should eq([0.7,0.8])
  end

  it "rotates right" do
    [0,1,2].j('1 |.').should eq([1,2,0])
  end

  it "rotates right an even number of times" do
    [0,1,2].j('12 |.').should eq([0,1,2])
  end

  it "rotates right an odd number of times" do
    [0,1,2].j('13 |.').should eq([1,2,0])
  end

  it "rotates left" do
    [0,1,2].j('_1 |.').should eq([2,0,1])
  end

  it "rotates left an even number of times" do
    [0,1,2].j('_12 |.').should eq([0,1,2])
  end

  it "rotates left an odd number of times" do
    [0,1,2].j('_13 |.').should eq([2,0,1])
  end

  it "doubles" do
    [0,1,2].j('+:').should eq([0,2,4])
  end

  it "halves" do
    [0,1,2].j('-:').should eq([0,0.5,1.0])
  end

  it "heads" do
    [0,1,2].j('{.').should eq([0])
  end

  it "tails" do
    [0,1,2].j('{:').should eq([2])
  end

  it "beheads" do
    [0,1,2].j('}.').should eq([1,2])
  end

  it "curtails" do
    [0,1,2].j('}:').should eq([0,1])
  end

  it "signs" do
    [0,1,2,-5].j('*').should eq([0,1,1,-1])
  end

  it "exponentiates" do
    [0,1,2].j('^').should eq([1, Math.exp(1), Math.exp(2)])
  end

  it "squares" do
    [0,1,2].j('*:').should eq([0,1,4])
  end

  it "creates a 2 x 2 matrix from 4 elements" do
    [0,1,2,3].j('2 2 $').should eq([[0,1],[2,3]])
  end

  it "creates a 2 x 2 matrix from a single element" do
    [0].j('2 2 $').should eq([[0,0],[0,0]])
  end

  it "creates a 2 x 2 x 2 matrix from a single element" do
    [0].j('2 2 2 $').should eq([[[0,0],[0,0]],[[0,0],[0,0]]])
  end

  it "creates a 2 x 3 matrix from a 2-period cycle" do
    [0,1].j('2 3 $').should eq([[0,1,0],[1,0,1]])
  end

  it "floors" do
    [0.5,1.6,2.0].j('<.').should eq([0,1,2])
  end

  it "ceilings" do
    [1.7,2.2,0.1].j('>.').should eq([2,3,1])
  end

  it "executes two commands" do
    [0,1,2].j('#+:').should eq([3])
  end

  it "does identity" do
    [0,1,2].j('+').should eq([0,1,2])
  end

  it "applies floor deeply" do
    [[0.1,2.3],[3.4,5.5]].j('<.')
  end

  it "applies double deeply" do
    [[0,1,2],[3,4,5]].j('+:').should eq([[0,2,4],[6,8,10]])
  end

  it "applies decrement deeply" do
    [[0,1,2],[3,4,5]].j('<:').should eq([[-1,0,1],[2,3,4]])
  end

  it "handles multidimensional sort" do
    [[0,0,0],[0,0,1],[0,0,0]].j('/:~').should eq([[0,0,0],[0,0,0],[0,0,1]])
  end

  it "handles multidimensional gradeup" do
    [[0,0,0],[0,0,1],[0,0,0]].j('/:').should eq([0,2,1])
  end

  it "handles invalid input" do
    [].j('`').should eq([])
  end

  it "handles shape with other operators" do
    [1.5].j('<. 2 2 $').should eq([[1,1],[1,1]])
  end

  it "handles array addition" do
    [1,2,3].j('2 3 4 +').should eq([3,5,7])
  end

  it "does a double insert" do
    [[1, 2, 3], [4, 5, 6]].j('+/+/').should eq([21])
  end

  it "does a selection" do
    [0,1,2].j('0 }').should eq([0])
  end

  it "selects more than one element" do
    [0,1,2].j('0 2 }').should eq([0, 2])
  end

  pending "selects using a negative index" do
    [0,1,2].j('_1 }').should eq([0, 2])
  end

  # it "handles empty case on head"
  # it "shape works with arbirtary number of dimensions"
  # it "shape works in a train"

end
