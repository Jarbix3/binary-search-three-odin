
class Tree
  attr_accessor :data, :root

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return if array.empty?
    res = array.sort.uniq
    return Node.new(res[0]) if res.length == 1
    mid = res.length / 2
    root = Node.new(res[mid])
    root.left = build_tree(res[0...mid])
    root.right = build_tree(res[mid+1..-1])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
 

  def insert(value, node = @root)
    # insert a value to the tree
    
    return if node == value
    insert_left(value, node) if value < node.data
    insert_right(value, node) if value > node.data
  end

  def insert_left(value, node)
    return Node.new(value) if node.left.nil?
    insert(value, node.left)
  end

  def insert_right(value, node)
    return Node.new(value) if node.right.nil?
    insert(value, node.right)
  end

  def delete(value)
    return nil if find(value).nil?
    
    parent = find_parent(value)
    if find(value).left.nil? && find(value).right.nil?
      delete_leaf(parent, value)
    elsif find(value).left.nil? || find(value).right.nil?
      delete_one_child(parent, value)
    else
      delete_two_children(parent, value)
    end
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node == value
    node > value ? find(value, node.left) : find(value, node.right)
  end

  def find_parent(value, node = @root)
    return nil if node == value
    return node if node.left == value || node.right == value
    node > value ? find_parent(value, node.left) : find_parent(value, node.right)
    
  end

  def delete_leaf(parent, value)
    parent > value ? parent.left = nil : parent.right = nil
  end

  def delete_one_child(parent,value)
    grandchild = find(value).left.nil? ? find(value).right : find(value).left
    attach_right(parent,grandchild) if parent.right == value
    attach_left(parent,grandchild) if parent.left == value
  end

  def delete_two_children(parent,value)
    successor = find_successor(value)
    delete(successor.data)
    attach_right(successor,find(value).right)
    attach_left(successor,find(value).left)
    attach_right(parent,successor) if parent.right == find(value)
    attach_left(parent,successor) if parent.left == find(value)
  end

  def attach_right(parent,child)
    parent.right = child
  end

  def attach_left(parent,child)
    parent.left = child
  end

  def find_successor(value)
    res = find(value + 1)
    return res unless res.nil?
    find_successor(value + 1)
  end

  def level_order(node = @root, queue = [], res = [])
    queue = [node] if queue.empty?
    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : res << current.data
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    res unless block_given?
  end

  def inorder(node = @root, res = [])
    return if node.nil?
    inorder(node.left, res)
    block_given? ? yield(node) : res << node.data
    inorder(node.right, res)
    res unless block_given?
  end

  def preorder(node = @root, res = [])
    return if node.nil?
    block_given? ? yield(node) : res << node.data
    preorder(node.left,res)
    preorder(node.right,res)
    res unless block_given?
  end

  def postorder(node = @root, res = [])
    return if node.nil?
    postorder(node.left,res)
    postorder(node.right,res)
    block_given? ? yield(node) : res << node.data
    res unless block_given?
  end

  def height(node = @root)
    return -1 if node.nil?
    left = height(node.left)
    right = height(node.right)
    left > right ? left + 1 : right + 1
  end
    
  def depth(node = @root, parent = @root, depth = 0)
    return nil if node.nil?
    return depth if node == value
    depth += 1
    node > parent.data ? depth(node.left, value, depth) : depth
  end

  def balanced?(node = @root)
    return true if node.nil?
    left = height(node.left)
    right = height(node.right)
    return true if (left - right).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    false
  end

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  def inorder_array(node = @root, res = [])
    unless node.nil?
      inorder_array(node.left, res)
      res << node.data
      inorder_array(node.right, res)
    end
    res
  end
    

end