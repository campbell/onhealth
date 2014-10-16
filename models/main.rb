class Main

  def initialize(stats_csv_filename, players_csv_filename)
    stats_array = CsvImporter.new(stats_csv_filename).import
    batting_stat_objects = stats_array.collect{|s| CollectionObject.new(s)}
    batting_stats_collection = BattingStatsCollection.new(batting_stat_objects)

    players_array = CsvImporter.new(players_csv_filename).import
    player_objects = players_array.collect{|s| CollectionObject.new(s)}
    players_collection = Collection.new(player_objects)

    @award = Award.new(batting_stats_collection, players_collection)
  end

  def run
    puts @award.announce_results
  end

end