#!/usr/bin/env ruby

module CalcoloNumerico

  class Matrix

    def [](r, c)
      @data[self.position(r, c)]
    end

    def []=(r, c, n)
      raise ArgumentError, "Required a numeric" unless n.is_a? Numeric
      @data[self.position(r, c)] = n
    end

    def each_index
      0.upto(@rows) do |r|
        0.upto(@cols) do |c|
          yield(r, c)
        end
      end
    end

    def each
      self.each_index do |r, c|
        yield(self[r, c])
      end
    end

    private

    def position(r, c)
      if @transposed
        return r * @cols + c
      else
        return c * @rows + r
      end
    end

    def initialize_array(ary)
      ary.each do |a|
        raise ArgumentError, "Array must contain Arrays" unless a.is_a? Array
        a.each { |v| raise ArgumentError, "All subArray must contain values" unless a.is_a? Numeric }
      end
      ary(1..-1).map { |e| e.size }.each { |d|
        raise ArgumentError, "Dimension mismatch" unless d == ary[0].size
      }

      @rows = ary.size
      @cols = ary[0].size
      @transposed = false
      @data = []
      self.each_index do |r, c|
        self[r, c] = ary[r][c]
      end
    end # initialize_array
  end # Matrix

end # CalcoloNumerico
