require 'spec_helper'

describe Stat do
  let(:hash) { {a: 1, '2b' => 2} }
  let(:stat) { Stat.new(hash) }

  it 'can access the stat attributes by name' do
    expect(stat.a).to eq 1
  end

  it 'can access the stat attributes like a hash' do
    expect(stat['2b']).to eq 2
  end

  it 'raises an error for invalid attributes' do
    expect{stat.d}.to raise_error(NoMethodError)
  end

  it 'raises an error for invalid keys' do
    expect{stat['3d']}.to raise_error(NoMethodError)
  end

  it 'has equality' do
    expect(stat).to eq Stat.new(hash)
  end
end