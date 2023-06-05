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

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    return nil if array.empty?

    mid_index = array.length / 2
    root = Node.new(array[mid_index])
    root.left_child = build_tree(array[0...mid_index])
    root.right_child = build_tree(array[mid_index + 1..])
    root
  end

  # Thank you pretty print, whoever your creator is!
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
sorted_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
quack = Tree.new(sorted_array)
quack.pretty_print
