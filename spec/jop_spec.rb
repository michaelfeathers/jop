

require 'jop'

describe Jop do
  it "does identity" do
    [].j('').should eq([])
  end
end
