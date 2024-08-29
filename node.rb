

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def to_s
    @data.to_s
  end

  def <=>(other)
    value = other.is_a?(Node) ? other.data : other
    @data <=> value
  end
end