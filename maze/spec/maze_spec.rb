require 'spec_helper'

# Given
# - a list of nodes
# - connections from each point
# - a target point
# Find the distances to each point.

describe Maze do
  let(:nodes) { [1,2,3,4] }
  let(:maze) { Maze.new(nodes, connections) }
  let(:connections) { instance_double "Proc" }

  context "a simple maze" do
    let(:connections) {
      Proc.new { |p|
        case p
        when 1 then [2]
        when 2 then [1,3,4]
        when 3 then [2,4]
        when 4 then [2,3]
        end
      }
    }

    it "solves a simple maze" do
      expect(maze.score(4)).to eq [2,1,1,0]
    end
  end

  it "starts with only the target set to 0" do
    expect(maze.initial_score(4)).to eq [nil,nil,nil,0]
    expect(maze.initial_score(1)).to eq [0,nil,nil,nil]
  end

  describe "#closest" do
    context "all scores zero" do
      let(:scores) { [0,0,0,0] }

      it "returns the only node" do
        expect(maze.closest([3], scores)).to eq 3
      end
    end

    context "node 3 score nil" do
      let(:scores) { [0,0,nil,0] }
      it "returns nil" do
        expect(maze.closest([3], scores)).to eq nil
      end
    end

    context "various scores" do
      let(:scores) { [4,3,7,5] }
      it "returns 2" do
        expect(maze.closest([1,2,3,4], scores)).to eq 2
      end
    end
  end

  describe "#expand" do
    it "puts 1 on node 2" do
      scores = [0,nil,nil,nil].freeze
      expect(connections).to receive(:call).with(1) { [2] }
      expect(maze.expand(scores,1)).to eq [0,1,nil,nil]
    end

    it "puts 1 on node 1" do
      scores = [nil,0,nil,nil].freeze
      expect(connections).to receive(:call).with(2) { [1] }
      expect(maze.expand(scores,2)).to eq [1,0,nil,nil]
    end

    it "puts 2 on node 2" do
      scores = [1,nil,nil,nil].freeze
      expect(connections).to receive(:call).with(1) { [2] }
      expect(maze.expand(scores,1)).to eq [1,2,nil,nil]
    end

    it "can expand to multiple nodes" do
      scores = [nil,1,nil,nil].freeze
      expect(connections).to receive(:call).with(2) { [1,4] }
      expect(maze.expand(scores,2)).to eq [2,1,nil,2]
    end

    it "does not overwrite lower scores" do
      scores = [1,1,nil,4].freeze
      expect(connections).to receive(:call).with(2) { [1,4] }
      expect(maze.expand(scores,2)).to eq [1,1,nil,2]
    end
  end
end
