require_relative './base/agent'

# Producer Agent
class Producer < Agent
  attr_accessor :eq_k, :eq_a, :eq_b, :build

  def initialize(eq_k, eq_a, eq_b)
    @eq_k = eq_k
    @eq_a = eq_a
    @eq_b = eq_b
  end

  def cap
    50
  end

  def generate_plan(p_1, p_2)
    @build = [@eq_a / (@eq_a + @eq_b) * cap / p_1,
              @eq_b / (@eq_a + @eq_b) * cap / p_2]
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Producer #{i}\nProduction Plan = "\
    "Good 1: #{@build[0]} | Good 2: #{@build[1]}\n"
  end
end
