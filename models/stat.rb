class Stat
  include Helpers

  def initialize(hash)
    @hash = hash
  end

  def ==(other)
    (@hash && other) == @hash
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