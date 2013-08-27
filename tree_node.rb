class TreeNode

  attr_accessor :parent, :value

  def initialize(value, parent=nil)
    @parent = parent
    parent.add_child(self) unless parent == nil

    @children = []
    @value = value
  end

  def to_s
    "#{value}" #{}, parent value: #{@parent != nil ? @parent.value : "no parent"}, children: [#{@children.map{|x|x.value}}]}"
  end

  def children
    @children
  end

  def add_child(child)
    @children << child
  end

  def self.dfs(node, target=nil, &block)
    found = []
    if block_given? && block.call(node.value)
      found << node
    elsif node.value == target
      found << node
    else
      node.children.each do |child|
        if block_given?
          found.concat(self.dfs(child, &block))
        else
          found.concat(self.dfs(child, target))
        end
      end
    end
    return found
  end

  def self.bfs(node, target=nil, &block)
    found = []
    current_nodes = [node]
    until current_nodes == []
      considered = current_nodes.shift
      if block_given?
        if block.call(considered.value)
          found << considered
        end
      else
        if considered.value == target
          found << considered
        end
      end
      current_nodes.concat(considered.children)
    end

    return found[0]
  end
end

if __FILE__ == $0
  # init tree
  n1 = TreeNode.new(1)
  n2 = TreeNode.new(2,n1)
  n3 = TreeNode.new(3,n2)
  n4 = TreeNode.new(4,n3)
  n5 = TreeNode.new(5,n1)
  n6 = TreeNode.new(6,n5)
  n7 = TreeNode.new(7,n6)
  n8 = TreeNode.new(8,n6)

  # dfs tree
  p TreeNode.dfs(n1){|x|x>6}

  # bfs tree
  # TreeNode.bfs(n1,8).each{|x|p x.value}

end