require 'spec_helper'

describe Stat do
  let(:hash) { {a: 1, b: 2} }
  let(:stat) { Stat.new(hash) }

  it 'accepts a hash of stats' do
    expect(stat).to be_a Stat
  end

  it 'can access the stats by name' do
    expect(stat.a).to eq 1
  end
end