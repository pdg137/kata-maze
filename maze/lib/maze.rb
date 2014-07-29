class Maze
  attr_accessor :nodes, :connections

  def initialize(nodes, connections)
    @nodes = nodes
    @connections = connections
  end

  def initial_score(goal)
    nodes.map { |x| x == goal ? 0 : INF }
  end

  def closest(node_list, score)
    return node_list.min_by { |x|
      score[nodes.index(x)]
    }
  end

  def expand(score, node)
    node_val = score[nodes.index(node)]

    connections[node].each do |neighbor|
      old_score = score[nodes.index(neighbor)]
      next if old_score < node_val + 1

      score[nodes.index(neighbor)] = node_val+1
    end
  end

  def solve(goal)
    unchecked_nodes = nodes
    score = initial_score(goal)

    until unchecked_nodes.empty?
      closest_node = closest(unchecked_nodes, score)
      expand(score, closest_node)
      unchecked_nodes -= [closest_node]
    end

    score
  end
end
