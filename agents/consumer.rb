require_relative './base/agent'

# Consumer Agent
class Consumer < Agent
  attr_accessor :eq_a, :eq_b, :eq_c, :eq_d

  def initialize(eq_a, eq_b, eq_c, eq_d)
    @eq_a = eq_a
    @eq_b = eq_b
    @eq_c = eq_c
    @eq_d = eq_d
  end

  def utility(x, y)
    @eq_a * (@eq_b * x ^ @eq_c + (1 - @eq_b) * y ^ @eq_c) ^ (@eq_d / @eq_c)
  end

  def plan
  end
end
