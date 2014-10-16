class Stat

  def initialize(hash)
    @hash = hash
  end

  def method_missing(symbol, *args, &blk)
    puts symbol.inspect
    if @hash.keys.include?(symbol.to_s)
      @hash[symbol.to_s]
    elsif @hash.keys.include?(symbol)
      @hash[symbol]
    else
      super
    end
  end

  def to_h
    @hash
  end

end