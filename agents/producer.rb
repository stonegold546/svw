require_relative './base/agent'

# Producer Agent
class Producer < Agent
  attr_accessor :eq_k, :eq_a, :eq_b

  def initialize(eq_k, eq_a, eq_b)
    @eq_k = eq_k
    @eq_a = eq_a
    @eq_b = eq_b
  end

  def cap
    50
  end

  def generate_plan(p_1, p_2)
    @build = [@eq_k * p_1**@eq_a * p_2**@eq_b, cap].min
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Producer #{i}\nProduction Plan: #{@build}\n"
  end
end
