require_relative './base/agent'

# Producer Agent
class Producer < Agent
  attr_accessor :k, :a, :b, :c

  def initialize(k, a, b, c)
    @k = k
    @a = a
    @b = b
    @c = c
  end

  def generate_plan(x, y)
    @k * x ^ @a * y ^ @b
  end
end
