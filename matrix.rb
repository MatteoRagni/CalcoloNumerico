#!/usr/bin/env ruby

module CalcoloNumerico

  class Matrix

    private
    def initialize_array(ary)
      ary.each do |a|
        raise ArguementError, "Array must contain Arrays" unless a.is_a? Array
      end
    end
  end # Matrix

end # CalcoloNumerico
