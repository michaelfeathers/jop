

require 'tokenizer'

describe Tokenizer do
  it "produces no tokens on an empty string" do
    Tokenizer.new('').tokens.count.should eq(0)
  end

  it "recognizes a number" do
    Tokenizer.new('42').tokens[0].should eq('42')
  end

  it "recognizes count" do
    Tokenizer.new('#').tokens[0].should eq('#')
  end

end
