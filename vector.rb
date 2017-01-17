#!/usr/bin/env ruby

module CalcoloNumerico
  class CalcoloNumericoError < Exception; end

  ##
  # The Vector class with an arbitrary number of elements
  class Vector
    ##
    # Initializes a new vector. It can be initialized in two ways:
    #  1)  Vector.new [1, 2, 3]
    #  2)  Vector.new(3) { |i| i + 1 }
    # Initializes the same type of vector
    def initialize(dim)
      @vector = []
      @column = true

      if dim.is_a? Array
        @vector = dim
        @dim = @vector.size
      elsif dim.is_a? Fixnum
        raise ArgumentError, "A block is required to initialize a Vector" unless block_given?
        @dim    = dim
        0.upto dim { |i| @vector[i] = yield(i) }
      else
        raise ArgumentError, "Required a Fixnum + Block, or an Array"
      end

      @vector.each do |e|
        raise ArgumentError, "Vector initialized with not numeric data" unless e.is_a? Numeric
      end
    end # initialize

    ##
    # Transposes the vector
    def transpose
      @column = @column ? false : true
    end # transpose

    ##
    # Size of the vector. It is a dimension as it was a matrix
    def size
      @column ? [@dim, 1] : [1, @dim]
    end # size

    ##
    # Length reports the maximum dimension of the vector
    # regardless the trasnposition
    def length
      @dim
    end # length

    ##
    # Slicer function. With an integer it returns a single
    # number, while with a range returns a sub-vector
    def [](i)
      if i.is_a? Fixnum
        raise ArgumentError, "Index out of bound" unless (0...@dim).include? i
        return @vector[i]
      elsif i.is_a? Range
        if (0...@dim).include? i.min and (0...@dim).include? i.max
          return @vector[i.min] if i.min == i.max
          return Vector.new(@vector[i])
        else
          raise ArgumentError, "Slice out of bound"
        end
      else
        raise ArgumentError, "Required an integer or a range as index"
      end
    end # []

    ##
    # Returns the sum of tw vector with the same sizes
    def +(v)
      raise ArgumentError, "Required another vector" unless v.is_a? Vector
      raise CalcoloNumericoError, "Dimension mismatch" unless self.size == v.size
      return Vector.new(@dim) { |i| self[i] + v[i] }
    end # +

    ##
    # Returns the difference of a vector with the same sizes
    def -(v)
      raise ArgumentError, "Required another vector" unless v.is_a? Vector
      raise CalcoloNumericoError, "Dimension mismatch" unless self.size == v.size
      return Vector.new(@dim) { |i| self[i] - v[i] }
    end # -

    ##
    # Generalization of a product function
    # if the other element is a:
    #  1) Vector, may return  a Matrix, or a Number
    #  2) With a Numeric returns the scaled Vector
    def *(a)
      if a.is_a? Vector
        if @column
          raise RuntimeError, "Not yet implemented" # FIXME
        else
          raise CalcoloNumericoError, "Vector size mismatch" if self.size[1] != a.size[0]
          ret = 0
          @vector.each_with_index { |e, k| ret += e * a[k] }
          return ret
        end
      elsif a.is_a? Numeric
        return Vector.new(@dim) { |e| @vector[e] * a }
      else
        raise ArgumentError, "Required a Numeric or a Vector"
      end
    end # *

    ##
    # Returns a scaled vector
    def /(a)
      raise ArgumentError, "Required a Numeric" unless a.is_a? Numeric
      return Vector.new(@dim) {|e| @vector[e]/a }
    end # /

    ##
    # Returns the norm, usually norm L2, but can be selected also
    # norm l1 and norm infinity
    def abs(type=:L2)
      raise ArgumentError, "Required a Symbol (:L1, :L2, :Linf)" unless type.is_a? Symbol
      case type
      when :L1
        return @vector.inject { |s, e| s += e.abs }
      when :L2
        return Math::sqrt(@vector.inject { |s, e| s += (e ** 2) })
      when :Linf
        return @vector.max
      else
        raise CalcoloNumericoError, "Unknown norm"
      end
    end # abs

    ##
    # Returns the String representation of the vector
    def to_s
      "[#{@vector.join(", ")}]#{@column ? "T" : ""}"
    end # to_s

    ##
    # Inspection of the Vector
    def inspect
      "<Vector #{object_id} : dim = #{@dim} values = #{@vector}>"
    end # inspect
  end # Vector

end # CalcoloNumerico
