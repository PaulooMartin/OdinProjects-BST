class Node
  include Comparable
  attr_accessor :left_child, :right_child
  attr_reader :data

  def initialize(value)
    @data = value
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

sorted_array = [44, 66, 77, 89, 100, 234]
