# Create a collection of objects. The collection can be filtered by specific values or by a block.
# These three statements are equivalent & return a collection with only objects that have year = 2013
#
#  collection.yearID(2013)
#  collection.where(yearID: 2013)
#  collection.where{|obj| obj[:yearID] == 2013}
#
# Collection filters are chainable:
#
#  collection.yearID(2013).where(personID: 'abc')
#
# The objects are expected to behave like a hash though they don't have to be a true Hash. 
# This class accesses the object attributes using a hash syntax but the actual object can
# be accessed within the custom filter blocks. 
class Collection
  include Helpers

  def initialize(stats_hash, keys = nil)
    @batting_stats = stats_hash
    @keys = keys || @batting_stats.first.keys
  end

  # Returns a new collection by filtering the current collection based on the conditions.
  # Because a collection is returned, this call is chainable.
  def where(conditions = {}, &blk)
    b = self

    # Each condition becomes a Proc for the #filter method
    procs = conditions.collect do |key, value|
      Proc.new {|s| s[find_actual_key(@keys, key)] == value}
    end

    procs << blk if block_given?

    # Apply each filter
    procs.each{|proc| b = b.filter(&proc)}

    b
  end

  # Sum up all stat fields within the collection and return the result as a hash
  def summarize
    sums = Hash.new
    @batting_stats.each do |stat|
      @keys.each do |key|
        if sums[key]
          sums[key] += stat[key] if stat[key]
        else
          sums[key] = stat[key]
        end
      end
    end
    sums
  end

  # We should really delegate all array methods to @batting_stats
  def each(&blk)
    @batting_stats.each(&blk)
  end

  def collect(&blk)
    @batting_stats.collect(&blk)
  end

  def ==(other)
    @batting_stats == other.to_ary
  end

  def length
    @batting_stats.length
  end

  def to_ary
    @batting_stats
  end

  # Allow field names to be used as methods for filtering:
  #   stat.yearID(2012)
  def method_missing(symbol, *args, &blk)
    key = find_actual_key(@keys, symbol)

    if @keys.include?(key)
      args.length > 0 ? filter{|s| args.include?(s[key])} : s[key]
    else
      super
    end
  end

  protected  # Because we're returning a new Collection object after each filter

  # Return an instance of Collection so this call is chainable
  def filter(&blk)

    # We need to pass through the keys in case no results are returned.
    # This allows subsequent filters to behave properly and not thrown
    # method_missing errors.
    self.class.new( @batting_stats.select{|s| yield(s)}, @keys )
  end


end