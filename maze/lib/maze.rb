class Maze
  attr_reader :nodes, :connections

  def initialize(nodes, connections)
    @nodes = nodes
    @connections = connections
  end
  
  def initial_score(goal)
    nodes.map { |p| p == goal ? 0 : nil }
  end

  def closest(some_nodes, scores)
    min_node = some_nodes.min_by do |n|
      scores[index(n)] || 100000
    end
    scores[index(min_node)] && min_node
  end

  def index(node)
    nodes.index(node)
  end

  def expand(scores, node)
    s = scores.dup
    new_score = scores[index(node)]+1
    connections.call(node).each do |other_node|
      other_index = index(other_node)
      if scores[other_index].nil? || scores[other_index] > new_score
        s[other_index] = new_score
      end
    end
    s
  end

  def score(goal)
    s = initial_score(goal)
    unexpanded_nodes = nodes.dup
    until unexpanded_nodes.empty?
      next_node_to_expand = closest(unexpanded_nodes, s)
      s = expand(s, next_node_to_expand)
      unexpanded_nodes.delete(next_node_to_expand)
    end
    s
  end
end
