require 'spec_helper'

describe CollectionObject do
  let(:hash) { {a: 1, '2b' => 2, c: nil} }
  let(:stat) { CollectionObject.new(hash) }

  it 'can access the stat attributes by name' do
    expect(stat.a).to eq 1
  end

  it 'can access the stat attributes like a hash' do
    expect(stat['2b']).to eq 2
  end

  it 'raises an error for invalid attributes' do
    expect{stat.d}.to raise_error(StandardError)
  end

  it 'raises an error for invalid keys' do
    expect{stat['3d']}.to raise_error(StandardError)
  end

  it 'can compare two CollectionObjects for equality' do
    expect(stat).to eq CollectionObject.new(hash)
  end

  it 'sets missing values to 0' do
    expect(stat.c).to eq 0
  end

  it 'can list the available attribute names' do
    keys = stat.keys
    expect(keys.length).to eq 3
    expect(keys).to include(:a)
    expect(keys).to include('2b')
    expect(keys).to include(:c)
  end
end