class StatsCollection

  def initialize(stats_hashes, keys = nil)
    @batting_stats = stats_hashes
    @keys = keys || @batting_stats.first.keys
  end

  def all
    @batting_stats
  end

  # Return an instance of StatsCollection so this call is chainable
  def filter(&blk)
    StatsCollection.new( @batting_stats.select{|s| yield(s)}, @keys )
  end

  def where(conditions = {}, &blk)
    b = self

    # Each condition becomes a Proc for the #filter method
    procs = conditions.collect do |key, value|
      Proc.new {|s| s[key.to_s] == value}
    end

    procs << blk if block_given?

    # Apply each filter
    procs.each{|proc| b = b.filter(&proc)}

    b
  end

  def length
    all.length
  end

  def to_ary
    all
  end

  # Allow field names to be used as methods for filtering:
  #   stat.year(2012)
  def method_missing(symbol, *args, &blk)
    key = symbol.to_s
    if @keys.include?(key)
      args.length > 0 ? filter{|s| args.include?(s[key])} : s[key]
    else
      super
    end
  end

end