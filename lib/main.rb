class Node
  include Comparable
  attr_accessor :left_child, :right_child, :data

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

  # Wonder how others did this, mine is a bit questionable because of re-assign of already correct nodes
  def insert(value, current_node = @root)
    return Node.new(value) if current_node.nil?
    return current_node if current_node.data == value

    if value < current_node.data
      current_node.left_child = insert(value, current_node.left_child)
    else
      current_node.right_child = insert(value, current_node.right_child)
    end
    current_node
  end

  def delete(value, current_node = @root)
    return nil if current_node.nil?

    result = value <=> current_node.data
    if result.negative?
      current_node.left_child = delete(value, current_node.left_child)
    elsif result.positive?
      current_node.right_child = delete(value, current_node.right_child)
    else
      return delete_matched(current_node)
    end
    current_node
  end

  # Thank you pretty print, whoever your creator is!
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  def delete_matched(delete_node)
    if delete_node.left_child.nil?
      delete_node.right_child
    elsif delete_node.right_child.nil?
      delete_node.left_child
    else
      lowest_node = find_min_value_node(delete_node.right_child)
      delete_node.data = lowest_node.data
      delete_node.right_child = delete(lowest_node.data, delete_node.right_child)
      delete_node
    end
  end

  def find_min_value_node(right_subtree)
    lowest_node = right_subtree
    lowest_node = lowest_node.left_child until lowest_node.left_child.nil?
    lowest_node
  end
end

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
quack = Tree.new(test_array)
quack.insert(24)
quack.insert(25)
quack.insert(26)
quack.pretty_print
puts '-----------------------------'
quack.delete(24)
quack.pretty_print
