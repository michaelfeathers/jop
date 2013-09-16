

require 'jop'

describe Jop do
  it "does identity" do
    [].j('').should eq([])
  end

  it "can add" do
    [3,2,1].j('+/').should eq(6)
  end

  it "can multiply" do
    [2, 4, 6].j('*/').should eq(48)
  end

  it "can sort ascending" do
    [1, 0, 2].j('/:~').should eq([0,1,2])
  end

  it "can sort descending" do
    [1, 0, 2].j('\:~').should eq([2,1,0])
  end

  it "can reverse" do
    [1, 0, 2].j('|.').should eq([2,0,1])
  end

  it "can take two elements" do
    [1,2,3].j('2 {.').should eq([1,2])
  end

  it "can take one element" do
    [1,2,3,4].j('1 {.').should eq([1])
  end

  it "can take an arbitrary number of elements" do
    [1,2,3,4].j('3 {.').should eq([1,2, 3])
  end

  it "can take negative elements" do
    [1,2,3].j('_2 {.').should eq([2,3])
  end

  it "can drop two elements" do
    [1,2,3].j('2 }.').should eq([3])
  end

  it "can drop negative elements" do
    [1,2,3].j('_2 }.').should eq([1])
  end

  it "can grade up" do
    [3,5,4].j('/:').should eq([0,2,1])
  end

  it "can grade down" do
    [3,5,4].j('\:').should eq([1,2,0])
  end

  it "can decrement" do
    [1,2,3].j('<:').should eq([0,1,2])
  end

  it "can increment" do
    [1,2,3].j('>:').should eq([2,3,4])
  end

  it "can size arrays" do
    [1,2].j('#').should eq(2)
  end

  it "can do reciprocal" do
    [1,2].j('%').should eq([1, 0.5])
  end

  it "can do reciprocal with zeros" do
    [0].j('%').should eq([Float::INFINITY])
  end

  it "can do complement" do
    [0.3, 0.2].j('-.').should eq([0.7, 0.8])
  end

  it "can rotate right" do
    [0,1,2].j('1 |.').should eq([1, 2, 0])
  end

  it "can rotate right an even number of times" do
    [0,1,2].j('12 |.').should eq([0,1,2])
  end

  it "can rotate an odd number of times" do
    [0,1,2].j('13 |.').should eq([1,2,0])
  end

  it "can rotate left"



end
