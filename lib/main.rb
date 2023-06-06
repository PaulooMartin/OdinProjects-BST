class Node
  include Comparable
  attr_accessor :left, :right, :data

  def initialize(value)
    @data = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

class Tree # rubocop:disable Metrics/ClassLength
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    return nil if array.empty?

    mid_index = array.length / 2
    root = Node.new(array[mid_index])
    root.left = build_tree(array[0...mid_index])
    root.right = build_tree(array[mid_index + 1..])
    root
  end

  # Wonder how others did this, mine is a bit questionable because of re-assign of already correct nodes
  def insert(value, current_node = @root)
    return Node.new(value) if current_node.nil?
    return current_node if current_node.data == value

    if value < current_node.data
      current_node.left = insert(value, current_node.left)
    else
      current_node.right = insert(value, current_node.right)
    end
    current_node
  end

  def delete(value, current_node = @root)
    return nil if current_node.nil?

    result = value <=> current_node.data
    if result.negative?
      current_node.left = delete(value, current_node.left)
    elsif result.positive?
      current_node.right = delete(value, current_node.right)
    else
      return delete_matched(current_node)
    end
    current_node
  end

  def find(value, current_node = @root)
    return puts "#{value} is not in BST" if current_node.nil?

    result = value <=> current_node.data
    if result.positive?
      find(value, current_node.right)
    elsif result.negative?
      find(value, current_node.left)
    else
      current_node
    end
  end

  def level_order
    queue = [@root]
    all_values = []
    until queue.empty?
      if block_given?
        yield queue[0]
      else
        all_values << queue[0].data
      end
      queue << queue[0].left if queue[0].left
      queue << queue[0].right if queue[0].right
      queue.shift
    end
    all_values unless all_values.empty?
  end

  def inorder(&code_block)
    if block_given?
      inorder_with_block(@root, code_block)
    else
      values = []
      inorder_no_block(@root, values)
      values
    end
  end

  def preorder(&code_block)
    if block_given?
      preorder_with_block(@root, code_block)
    else
      values = []
      preorder_no_block(@root, values)
      values
    end
  end

  def postorder(&code_block)
    if block_given?
      postorder_with_block(@root, code_block)
    else
      values = []
      postorder_no_block(@root, values)
      values
    end
  end

  def height(start_node)
    height_with_start(start_node) - 1
  end

  def depth(node_to_find)
    return if find(node_to_find.data).nil?

    depth = 0
    current_node = @root
    until current_node == node_to_find
      current_node = node_to_find.data < current_node.data ? current_node.left : current_node.right
      depth += 1
    end
    depth
  end

  def balanced?
    result = true
    level_order do |node|
      difference = height(node.left) - height(node.right)
      result = difference.abs < 2
      return result unless result
    end
    result
  end

  def rebalance
    return if balanced?

    new_tree = inorder
    @root = build_tree(new_tree)
  end

  # Thank you pretty print, whoever your creator is!
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def delete_matched(delete_node)
    # It's not really deleting, it's replacing with the lowest value from right subtree
    if delete_node.left.nil?
      delete_node.right
    elsif delete_node.right.nil?
      delete_node.left
    else
      lowest_node = find_min_value_node(delete_node.right)
      delete_node.data = lowest_node.data
      delete_node.right = delete(lowest_node.data, delete_node.right)
      delete_node
    end
  end

  def find_min_value_node(right_subtree)
    lowest_node = right_subtree
    lowest_node = lowest_node.left until lowest_node.left.nil?
    lowest_node
  end

  def inorder_with_block(current_node, code_block)
    return if current_node.nil?

    inorder_with_block(current_node.left, code_block)
    code_block.call current_node
    inorder_with_block(current_node.right, code_block)
  end

  def inorder_no_block(current_node, array_to_fill)
    return if current_node.nil?

    inorder_no_block(current_node.left, array_to_fill)
    array_to_fill << current_node.data
    inorder_no_block(current_node.right, array_to_fill)
  end

  def preorder_with_block(current_node, code_block)
    return if current_node.nil?

    code_block.call current_node
    preorder_with_block(current_node.left, code_block)
    preorder_with_block(current_node.right, code_block)
  end

  def preorder_no_block(current_node, array_to_fill)
    return if current_node.nil?

    array_to_fill << current_node.data
    preorder_no_block(current_node.left, array_to_fill)
    preorder_no_block(current_node.right, array_to_fill)
  end

  def postorder_with_block(current_node, code_block)
    return if current_node.nil?

    postorder_with_block(current_node.left, code_block)
    postorder_with_block(current_node.right, code_block)
    code_block.call current_node
  end

  def postorder_no_block(current_node, array_to_fill)
    return if current_node.nil?

    postorder_no_block(current_node.left, array_to_fill)
    postorder_no_block(current_node.right, array_to_fill)
    array_to_fill << current_node.data
  end

  def height_with_start(start_node)
    return 0 if start_node.nil?

    left_height = 1
    right_height = 1

    left_height += height_with_start(start_node.left)
    right_height += height_with_start(start_node.right)
    left_height > right_height ? left_height : right_height
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
puts quack.find(26)
quack.level_order
puts '-----------------------------'
quack.inorder { |node| puts node.data }
p quack.inorder
puts '-----------------------------'
quack.preorder { |node| puts node.data }
p quack.preorder
puts '-----------------------------'
quack.postorder { |node| puts node.data }
p quack.postorder
quack.pretty_print
test_node = quack.find(8)
puts quack.height(test_node)
puts quack.depth(test_node)
quack.insert(27)
quack.pretty_print
p quack.balanced?
puts '-----------------------------'
quack.rebalance
quack.pretty_print
p quack.balanced?
