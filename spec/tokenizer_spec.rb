

require 'tokenizer'

describe Tokenizer do
  it "produces no tokens on an empty string" do
    Tokenizer.new('').tokens.count.should eq(0)
  end
end
