require 'spec_helper'

describe BattingStatsCollection do
  let(:sums) { { 'H' => 1, '2B' => 2, '3B' => 3, 'HR' => 4, 'AB' => 5 } }
  let(:imported_stats) { [CollectionObject.new(sums)] }

  context 'for a collection' do
    it 'can calculate the slugging percentage' do
      collection = BattingStatsCollection.new(imported_stats)
      result = double

      expect(collection).to receive(:summarize).and_return(sums)
      expect(Calculator).to receive(:slugging_percentage).with(1,2,3,4,5).and_return(result)

      expect(collection.slugging_percentage).to eq result
    end
  end

end