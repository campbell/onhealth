require 'spec_helper'

describe StatsCollection do
  let(:imported_results) { CsvImporter.new('./spec/fixtures/batting_stats.csv').import }
  let(:stats) {[
    {a: 1, b: 2, c: 'three', d: nil},
    {a: 1, b: 3, c: 'three', d: 4},
    {a: 2, b: 2, c: 'three', d: nil},
  ]}
  let(:stats) { StatsCollection.new(stats) }
  
  it 'can return the collection' do
    expect(stats.all.length).to eq 3
  end

  it 'can find items in the collection' do
    expect(stats.where(a: 2).length).to eq 1
  end
end