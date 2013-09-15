

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
end
