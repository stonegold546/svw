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

  def utility(p_1, p_2)
    @eq_a * (@eq_b * p_1**@eq_c + (1 - @eq_b) * p_2**@eq_c)**(@eq_d / @eq_c)
  end

  def plan
  end
end
