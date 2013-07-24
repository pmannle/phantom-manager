module Utils
  class Lock
    def initialize
      @locked=false
    end

    def acquire
      if !locked?
        lock
        yield
        unlock
      end
    end

    def lock
      @locked = true
      self
    end

    def unlock
      @locked = false
      self
    end

    def locked?
      @locked
    end
  end
end
