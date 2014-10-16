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

  context 'calculations' do
    let(:hash) { {'H' => 1111, 'AB' => 2222, '2B' => 100, '3B' => 10, 'HR' => 1} }

    it 'calculates the batting average' do
      expect(stat.batting_average).to eq 0.5
    end

    it 'calculates the slugging percentage' do
      # Is it better to DRY up the test by using 'hash[X]' below, or does that
      # just make it more likely that we'll repeat a math error here and in the
      # Stat class? The calculation below is less maintainable but that will only
      # be an issue if this class starts to grow. For now, this is more readable.
      pct = ( (1111 - 100 - 10 - 1) + 100*2 + 10*3 + 1*4 ) / 2222.to_f

      expect(stat.slugging_percentage).to eq pct
    end

  end
end