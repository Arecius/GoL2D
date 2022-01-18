module GOL
  class Cell
    def initialize(coordinates)
      @alive = [true, false].sample
      @coordinates = coordinates
    end

    def alive?
      @alive
    end

    def dead?
      !alive?
    end

    def die!
      raise 'You cannot kill whats already dead...' unless alive?

      @alive = false
    end

    def revive!
      raise 'Cannot revive a live cell!' if alive?

      @alive = true
    end

    def coordinates
      @coordinates.dup
    end

    def to_s
      alive? ? '-' : '+'
    end
  end
end