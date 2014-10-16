class Award

  def initialize(stats_collection, players_collection)
    @stats_collection = stats_collection
    @players_collection = players_collection
  end

  def announce_results
    slugging_percentage_result = slugging_percentage('OAK', 2007)
    most_improved_winners = most_improved(2009, 2010).collect{|playerID| get_player_name(playerID)}
    triple_crown_winners_2011 = triple_crown_winners(2011).collect!{|playerID| get_player_name(playerID)}
    triple_crown_winners_2012 = triple_crown_winners(2012).collect!{|playerID| get_player_name(playerID)}

    "Most improved batting average between 2009 & 2010: " + most_improved_winners.join(', ') + "\n" +
    "Slugging percentage for OAK in 2007 was #{ '%0.3f' % slugging_percentage_result }\n" + 
    "Triple-crown-winner(s) for 2011: " + triple_crown_winners_2011.join(', ') + "\n" +
    "Triple-crown-winner(s) for 2012: " + triple_crown_winners_2012.join(', ')
  end

  def slugging_percentage(team, year)
    @stats_collection.teamID(team).yearID(year).slugging_percentage
  end

  def most_improved(year1, year2)
    # CollectionObjects with > 199 at-bats
    eligible_stats = @stats_collection.where{|stat| stat.AB > 199}

    # Filter by year1
    y1 = eligible_stats.yearID(year1)

    # Filter by year2 and players from year1
    y1_players = y1.collect(&:playerID).uniq

    y2 = eligible_stats.yearID(year2).where{|stat| y1_players.include?(stat.playerID)}

    # Subtract the year1 average from year2
    improvement = Hash.new { 0 }
    y2.each{|stat| improvement[stat.playerID] += Calculator.batting_average(stat.H, stat.AB)}
    y1.each{|stat| improvement[stat.playerID] -= Calculator.batting_average(stat.H, stat.AB)}

    # Find the best improvement & keep those records
    max_improvement = improvement.values.max
    improvement.keep_if{|player, improvement| improvement == max_improvement}.collect{|player, _| player}
  end

  def triple_crown_winners(year)
    leagues = @stats_collection.collect(&:league).compact.uniq

    winners = leagues.collect do |league|
      eligible_stats = @stats_collection.where(league: league, yearID: year).where{|stat| stat.AB > 399}
      max_homeruns = eligible_stats.collect(&:HR).max
      max_rbis = eligible_stats.collect(&:RBI).max
      max_average = eligible_stats.collect(&:batting_average).max

      eligible_stats.where(HR: max_homeruns, RBI: max_rbis, batting_average: max_average).collect(&:playerID)
    end

    winners.flatten!.compact!
    winners.length > 0 ? winners : ['(No winner)']
  end

  def get_player_name(playerID)
    found_names = @players_collection.where(playerID: playerID).collect{|p| p.nameFirst + ' ' + p.nameLast}
    found_names.first || playerID
  end

end