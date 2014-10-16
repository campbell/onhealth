module Helpers
  # A hackish but effective way of implementing hashes with indifferent access
  def find_actual_key(keys, key)
    if found_key = (keys & [key.to_sym, key.to_s]).first
      found_key
    else
      raise StandardError, "Attribute #{key} was not found in the defined stats"
    end
  end
end