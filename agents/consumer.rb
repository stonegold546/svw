require_relative './base/agent'

# Consumer Agent
class Consumer < Agent
  attr_accessor :a, :b, :c, :d, :e

  def initialize(a, b, c, d, e)
    @a = a
    @b = b
    @c = c
    @d = d
    @e = e
  end

  def generate_plan(x, y)
    @a * (@b * x ^ c + (1 - @b) * y ^ c) ^ (d / c)
  end
end
