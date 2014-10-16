require 'spec_helper'

describe StatsCollection do
  let(:imported_results) { CsvImporter.new('./spec/fixtures/batting_stats.csv').import }
  let(:stats) {[
    {a: 1, b: 2, c: 'three', d: nil},
    {a: 1, b: 2, c: 'three', d: nil},
    {a: 1, b: 2, c: 'three', d: nil},
  ]}
  let(:stats) { StatsCollection.new(imported_results) }
  
  it 'can return the collection' do
    expect(stats.all.length).to eq 2
  end

  it 'can find items in the collection' do
    expect(stats.filter{|s| s['yearID'] > 2013}.length).to eq 0
    expect(stats.filter{|s| s['yearID'] > 2012}.length).to eq 1
    expect(stats.filter{|s| s['yearID'] > 2011}.length).to eq 2


    expect(stats.filter{|s| s['yearID'] > 2011}.filter{|s| s['yearID'] > 2012}.filter{|s| s['playerID'] == 'def'}.length).to eq 1

    expect(stats.where(yearID: 2013, playerID: 'def').length).to eq 1


    expect(stats.where(playerID: 'def'){|s| s['yearID'] > 2011}.length).to eq 1

#    puts stats.yearID(2012, 2013).CS(10)
    s = stats.where('3B' => 6){|s| s['yearID'] > 2012 && s['CS'] == 10}

    puts s.inspect
    puts s.yearID


  end
end