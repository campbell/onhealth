class Stat
  include Helpers

  def initialize(hash)
    @hash = hash
  end

  def batting_average
    @hash['H'] / @hash['AB'].to_f
  end

  def slugging_percentage
    (
      ( @hash['H'] - @hash['2B'] - @hash['3B'] - @hash['HR'] ) +
      @hash['2B']*2 +
      @hash['3B']*3 +
      @hash['HR']*4
    ) / @hash['AB'].to_f
  end

  # Allow access as a hash
  def [](key)
    self.send(key)
  end

  def method_missing(symbol, *args, &blk)
    if key = find_actual_key(@hash.keys, symbol)  # Allow access as an attribute
      @hash[key]
    else
      super
    end
  end

end