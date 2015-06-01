require_relative './base/agent'

# Consumer Agent
class Consumer < Agent
  attr_accessor :eq_v, :th, :endow, :buy

  def initialize(eq_v, th, endow)
    @eq_v = eq_v
    @th = th # this is share
    @endow = endow
  end

  def utility_a(a, e, b)
    # Unit inside the bracket
    a * e**b
  end

  def utility_b(x_1, x_2)
    # Main bracket
    utility_a(@eq_v[1], x_1, @eq_v[2]) + utility_a(1 - @eq_v[1], x_2, @eq_v[2])
  end

  def utility(p_1, p_2, y_1, y_2)
    # Input: Data for generate plan
    # Output: Utility
    x_1, x_2 = *generate_plan(p_1, p_2, y_1, y_2)
    @eq_v[0] * utility_b(x_1, x_2)**(@eq_v[3] / @eq_v[2])
  end

  def g_a(pr, en, y_1, y_2)
    # Input: Price of good, endowment for price, theta & both productions plans
    # Output: Prefered amount of a good
    [@th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+) / pr + en
    # [pr * en, @th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+) / pr
    # [en, @th[0] * y_1, @th[1] * y_2].inject(&:+)
  end

  def generate_plan(p_1, p_2, y_1, y_2)
    # Input: two prices and both production plans
    # Output: Array of prefered ammount for both goods
    @buy = [g_a(p_1, @endow[0], y_1, y_2), g_a(p_2, @endow[1], y_1, y_2)]
    # @endow = @buy
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Consumer #{i}\nConsumption Plan = "\
    "Good 1: #{@buy[0]} | Good 2: #{@buy[1]}\n"
  end
end
