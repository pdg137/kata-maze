require 'spec_helper'

INF = Float::INFINITY

describe Maze do
  let(:nodes) { [1,2,3,4] }
  let(:connections) {
    { 1 => [2],
      2 => [1,3,4],
      3 => [2,4],
      4 => [2,3] }
  }
  let(:maze) { Maze.new(nodes, connections) }

  context "a simple maze" do
    it "finds the distances to 4" do
      expect(maze.solve(4)).to eq [2,1,1,0]
    end

    it "finds the distances to 1" do
      expect(maze.solve(1)).to eq [0,1,2,2]
    end
  end

  describe "#initial_score" do
    specify "given node 1, it sets that to 0 and others to infinity" do
      expect(maze.initial_score(1)).to eq [0,INF,INF,INF]
    end

    specify "given node 2, it sets that to 0 and others to infinity" do
      expect(maze.initial_score(2)).to eq [INF,0,INF,INF]
    end
  end

  describe "#closest_node" do
    specify "given a trivial case, it returns the only node" do
      expect(maze.closest([1],[0,0,0,0])).to eq 1
    end

    specify "given a more interesting case, it returns the node with lowest score" do
      expect(maze.closest([1,2,3],[3,1,7,0])).to eq 2
    end
  end

  describe "#expand" do
    specify "given a 0 node surrounded by INF, sets neighbors to 1" do
      score = [1,INF,INF,0]
      maze.expand(score, 4)
      expect(score).to eq [1,1,1,0]
    end

    specify "given a 1 node surrounded by INF, sets neighbors to 2" do
      score = [1,INF,INF,1]
      maze.expand(score,4)
      expect(score).to eq [1,2,2,1]
    end

    specify "given a different 1 node surrounded by INF, sets neighbors to 2" do
      score = [1,INF,INF,1]
      maze.expand(score,1)
      expect(score).to eq [1,2,INF,1]
    end

    it "doesn't overwrite lower scores" do
      score = [1,3,0,1]
      maze.expand(score, 4)
      expect(score).to eq [1,2,0,1]
    end
  end

end
