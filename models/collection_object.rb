# This is basically a wrapper around a hash so we can access the values using an attribute syntax.
# It also supports indifferent access:
#
#   object.key    => value
#   object['key'] => value
#   object[:key]  => value

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

  def [](key)
    self.send(key)
  end

  def []=(key, value)
    @hash[key] = value
  end

  def method_missing(symbol, *args, &blk)
    if key = find_actual_key(@hash.keys, symbol)  # Allow the object to be accessed like an attribute:  object.key => value
      @hash[key] || 0
    else
      super
    end
  end

end