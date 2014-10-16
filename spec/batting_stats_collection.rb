require 'spec_helper'

describe BattingStatsCollection do
  let(:sums) { { 'H' => 1, '2B' => 2, '3B' => 3, 'HR' => 4, 'AB' => 5 } }
  let(:imported_stats) { [CollectionObject.new(sums)] }
  let(:collection)     { BattingStatsCollection.new(imported_stats) }

  it 'can calculate the slugging percentage' do
    result = double
    expect(collection).to receive(:summarize).and_return(sums)
    expect(Calculator).to receive(:slugging_percentage).with(1,2,3,4,5).and_return(result)

    expect(collection.slugging_percentage).to eq result
  end

  it 'adds the batting average to each collection object' do
    expect(collection.to_ary.first.batting_average).to eq( sums['H'] / sums['AB'].to_f )
  end
end