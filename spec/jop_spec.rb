

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
end
