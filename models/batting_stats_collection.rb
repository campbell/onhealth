require './models/collection'

class BattingStatsCollection < Collection

  def initialize(stats, keys = nil)
    @batting_stats = stats

    # Append the batting average to each stat
    @batting_stats.each do |stat|
      stat['batting_average'] = Calculator.batting_average(stat.H, stat.AB) if stat.H && stat.AB
    end

    @keys = keys || @batting_stats.first.keys
  end

  def slugging_percentage
    sums = summarize
    Calculator.slugging_percentage(sums['H'], sums['2B'], sums['3B'], sums['HR'], sums['AB'])
  end

end