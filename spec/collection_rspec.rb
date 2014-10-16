require 'spec_helper'

describe Collection do
  let(:stat1) { CollectionObject.new(a: 1, b: 2, c: 'three', d: nil) }
  let(:stat2) { CollectionObject.new(a: 1, b: 3, c: 'three', d: 4) }
  let(:stat3) { CollectionObject.new(a: 2, b: 2, c: 'three', d: nil) }

  let(:imported_stats) { [stat1, stat2, stat3] }
  let(:collection)     { Collection.new(imported_stats) }
  
  it 'can return the collection of stats' do
    expect(collection.length).to eq 3
    expect(collection.collect{|s| s[:a]}.sort).to eq [1,1,2]
  end

  it 'can compare two collections for equality' do
    c1 = Collection.new([stat1])
    c2 = Collection.new([stat1])
    c3 = Collection.new([stat2])

    expect(c1).to eq c2
    expect(c1).not_to eq c3
  end

  context 'finders' do
    it 'can find items with specific values' do
      expect(collection.where(a: 2).length).to eq 1
    end

    it 'can match multiple conditions' do
      expect(collection.where(a: 1, b: 3).length).to eq 1
      expect(collection.where(a: 1, c: 'three').length).to eq 2
    end

    it 'conditions can use keys or symbols' do
      other = collection.where('a' => 2)

      expect(collection.where(a: 2)).to eq other


      expect(collection.where(a: 2).length).to eq 1
      expect(collection.where('a' => 2).length).to eq 1
    end

    it 'can take a block' do
      expect( collection.where{|stat| stat[:b] > 2}.length ).to eq 1
    end

    it 'raises an error if an invalid condition name is used' do
      expect{
        collection.where(invalid_key_name: 1)
      }.to raise_error("Attribute invalid_key_name was not found in the defined stats")
    end
  end

  it 'can summarize a collection' do
    sum = collection.summarize
    expect(sum[:a]).to eq 4
    expect(sum[:b]).to eq 7
    expect(sum[:c]).to eq 'threethreethree'
    expect(sum[:d]).to eq 4
  end
end