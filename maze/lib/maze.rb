class Maze
  attr_accessor :nodes, :connections
  def initialize(nodes, connections)
    @nodes = nodes
    @connections = connections
  end

  def solve(goal)
    score = initial_score(goal)
    unchecked_nodes = nodes
    
    until unchecked_nodes.empty?
      node = closest(unchecked_nodes, score)
      check(score, node)
      unchecked_nodes -= [node]
    end

    score
  end

  def index(node)
    nodes.index node
  end

  def initial_score(goal)
    score = [INF]*nodes.length
    score[index goal] = 0
    score
  end

  def closest(nodes, scores)
    nodes.min_by { |x| scores[index x] }
  end

  def check(score, node)
    connections[node].each do |neighbor|
      score[index neighbor] = score[index node]+1 if score[index neighbor] > score[index node]
    end
  end
end
