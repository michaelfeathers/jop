

require 'jop'

describe Jop do
  it "does identity" do
    [].j('').should eq([])
  end

  it "sums" do
    [3,2,1].j('+/').should eq(6)
  end

  it "multiplies" do
    [2,4,6].j('*/').should eq(48)
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
    [1,2].j('#').should eq(2)
  end

  it "calcultes the reciprocal" do
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

  it "does running sums" do
    [0,1,2].j('+/\\').should eq([0,1,3])
  end

  it "heads" do
    [0,1,2].j('{.').should eq(0)
  end

  it "tails" do
    [0,1,2].j('{:').should eq(2)
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

  it "handles empty case on head"

end
