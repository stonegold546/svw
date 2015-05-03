require_relative './base/agent'

# Producer Agent
class Producer < Agent
  attr_accessor :eq_k, :eq_a, :eq_b

  def initialize(eq_k, eq_a, eq_b)
    @eq_k = eq_k
    @eq_a = eq_a
    @eq_b = eq_b
  end

  def generate_plan(x, y)
    @eq_k * x ^ @eq_a * y ^ @eq_b
  end
end
