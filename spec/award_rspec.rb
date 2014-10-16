require 'spec_helper'

def stat_factory(player, year, league, team, at_bats, hits, doubles, triples, home_runs, rbis)
  CollectionObject.new({
    'playerID' => player,
    'yearID' => year,
    'league' => league,
    'teamID' => team,
    'AB' => at_bats,
    'H' => hits,
    '2B' => doubles,
    '3B' => triples,
    'HR' => home_runs,
    'RBI' => rbis
  })
end

describe Award do
  let(:batting_stats) { BattingStatsCollection.new(stats_array)}
  let(:award) { Award.new(batting_stats, [])}

  context 'slugging percentage' do
    let(:stats_array) {[
      stat_factory('a', 2000, nil, 'OAK', 20, 10, 0, 0, 0, 0 ),
      stat_factory('b', 2000, nil, 'OAK', 25, 10, 0, 0, 0, 0 ),
      stat_factory('a', 2001, nil, 'OAK', 30, 10, 0, 0, 0, 0 ),
      stat_factory('d', 2000, nil, 'NYY', 35, 10, 0, 0, 0, 0 )
    ]}

    it 'can be calculated for a team in a given year' do
      expect(award.slugging_percentage('OAK', 2000)).to eq (10 + 10) / (20 + 25).to_f
      expect(award.slugging_percentage('OAK', 2001)).to eq 10/30.to_f
      expect(award.slugging_percentage('NYY', 2000)).to eq 10/35.to_f
    end
  end

  context 'most_improved' do
    let(:stats_array) {[
      # 200+ at-bats, low improvement
      stat_factory('a', 2000, nil, nil, 200, 10, 0, 0, 0, 0 ),
      stat_factory('a', 2001, nil, nil, 201, 20, 0, 0, 0, 0 ),
      # 200+ at-bats, best improvement
      stat_factory('b', 2000, nil, nil, 200, 10, 0, 0, 0, 0 ),
      stat_factory('b', 2001, nil, nil, 200, 30, 0, 0, 0, 0 ),
      # < 200 at-bats in one year
      stat_factory('c', 2000, nil, nil, 199, 10, 0, 0, 0, 0 ),
      stat_factory('c', 2001, nil, nil, 200, 40, 0, 0, 0, 0 ),
      # 200+ at-bats, best improvement
      stat_factory('d', 2000, nil, nil, 200, 10, 0, 0, 0, 0 ),
      stat_factory('d', 2001, nil, nil, 200, 30, 0, 0, 0, 0 ),
      # 200+ at-bats but didn't improve
      stat_factory('e', 2000, nil, nil, 200, 30, 0, 0, 0, 0 ),
      stat_factory('e', 2001, nil, nil, 200, 10, 0, 0, 0, 0 ),
    ]}

    it 'finds the player(s) having > 199 hits with the most improved batting average between 2 years' do
      expect(award.most_improved(2000, 2001)).to eq ['b', 'd']
    end
  end

  context 'triple crown winner' do
    let(:league_1_winner) { stat_factory('winner1', 2000, 'al', nil, 400, 400, 0, 0, 100, 200) }
    let(:league_1_second_winner) { stat_factory('winner1a', 2000, 'al', nil, 400, 400, 0, 0, 100, 200) }
    let(:league_2_winner) { stat_factory('winner2', 2000, 'nl', nil, 400, 400, 0, 0, 100, 200) }
    let(:league_3_winner) { stat_factory('winner3', 2000, 'ol', nil, 400, 400, 0, 0, 100, 200) }

    let(:losing_stats) {[
      stat_factory('b', 2001, 'al', nil, 400, 400, 0, 0, 100, 200), # different year
      stat_factory('c', 2000, 'al', nil, 300, 400, 0, 0, 100, 200), # not enough at-bats
      stat_factory('d', 2000, 'al', nil, 400, 300, 0, 0, 100, 200), # lower batting average
      stat_factory('e', 2000, 'al', nil, 400, 400, 0, 0, 99, 200),  # not enough HRs
      stat_factory('f', 2000, 'al', nil, 400, 400, 0, 0, 100, 199), # not enough RBIs
    ]}

    context 'with a winner' do
      let(:stats_array) { losing_stats << league_1_winner }

      it 'finds the player with > 400 at-bats and the best batting average, home runs & RBI counts' do
        expect(award.triple_crown_winners(2000)).to eq ['winner1']
      end
    end

    context 'with multiple winners' do
      let(:stats_array) { losing_stats << league_1_winner << league_1_second_winner }

      it 'finds them' do
        expect(award.triple_crown_winners(2000)).to eq %w(winner1 winner1a)
      end
    end

    context 'with multiple leagues' do
      let(:stats_array) { losing_stats << league_1_winner << league_2_winner << league_3_winner}

      it 'finds the winners in each league' do
        expect(award.triple_crown_winners(2000)).to eq %w(winner1 winner2 winner3)
      end
    end
  end

  context '#get_player_name' do
    let(:players) {[
      CollectionObject.new({playerID: 'a', nameFirst: 'b', nameLast: 'c'}),
      CollectionObject.new({playerID: 'x', nameFirst: 'y', nameLast: 'z'})
    ]} 
    let(:player_collection)   { Collection.new( players )}
    let(:award) { Award.new([], player_collection)}

    it 'finds the player name from the player collection' do
      expect(award.get_player_name('a')).to eq 'b c'
    end

    it 'returns the playerID if the name is not found' do
      expect(award.get_player_name('fake')).to eq 'fake'
    end
  end

  context '#announce_results' do
    it 'should announce the results'
  end

end
