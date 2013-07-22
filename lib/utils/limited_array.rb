class LimitedArray < Array

  attr_accessor :limit

  def initialize(limit)
    @limit = limit
    super()
  end

  def full?
    size == limit
  end

  def <<(val)
    if full?
      self.rotate!
      self[limit-1] = val
    else
      super
    end
  end
  
  def average
    sum.to_f / size
  end

  def sum
    inject(:+)
  end
 
end
