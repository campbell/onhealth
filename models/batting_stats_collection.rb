require './models/collection'

# Wrapper for a Collection that provides some features specific to batting statistics.
# Other types of collections (eg. pitching) can follow this same pattern.

class BattingStatsCollection < Collection

  def initialize(stats, keys = nil)
    @batting_stats = stats

    # Append the batting average to each stat
    @batting_stats.each do |stat|
      avg = (stat.H && stat.AB && stat.AB > 0) ? Calculator.batting_average(stat.H, stat.AB) : nil
      stat['batting_average'] = avg
    end

    @keys = keys || @batting_stats.first.keys
  end

  # Calculate the slugging percentage for the entire collection.
  def slugging_percentage
    sums = summarize
    Calculator.slugging_percentage(sums['H'], sums['2B'], sums['3B'], sums['HR'], sums['AB'])
  end

end