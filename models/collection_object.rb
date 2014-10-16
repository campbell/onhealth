class CollectionObject
  include Helpers

  def initialize(hash = {})
    @hash = hash
  end

  def keys
    @keys ||= @hash.keys
  end

  def to_h
    @hash
  end

  def ==(other)
    @hash == other.to_h
  end

  # Allow access as a hash
  def [](key)
    self.send(key)
  end

  def []=(key, value)
    @hash[key] = value
  end

  def method_missing(symbol, *args, &blk)
    if key = find_actual_key(@hash.keys, symbol)  # Allow access as an attribute
      @hash[key] || 0
    else
      super
    end
  end

end