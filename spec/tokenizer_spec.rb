

require 'tokenizer'

describe Tokenizer do

  def tokens text
    Tokenizer.new(text).tokens
  end

  it 'produces no tokens on an empty string' do
    tokens('').count.should eq(0)
  end

  it 'recognizes a number' do
    tokens('42')[0].should eq('42')
  end

  it 'recognizes count' do
    tokens('#')[0].should eq('#')
  end

  it 'recognizes plus' do
    tokens('+')[0].should eq('+')
  end

  it 'recognizes double' do
    tokens('+:')[0].should eq('+:')
  end

end
