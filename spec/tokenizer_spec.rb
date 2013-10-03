

require 'tokenizer'

describe Tokenizer do

  def tokens text
    Tokenizer.new(text).tokens
  end

  def first_of text
    tokens(text)[0]
  end

  it 'produces no tokens on an empty string' do
    tokens('').count.should eq(0)
  end

  it 'recognizes a number' do
    first_of('42').should eq('42')
  end

  it 'recognizes count' do
    first_of('#').should eq('#')
  end

  it 'recognizes plus' do
    first_of('+').should eq('+')
  end

  it 'recognizes double' do
    first_of('+:').should eq('+:')
  end

  it 'recogizes gradeup' do
    first_of('/:').should eq('/:')
  end

  it 'recognizes two tokens' do
    tokens('++')[0].should eq('+')
    tokens('+#')[1].should eq('#')
  end

end
