require_relative './base/agent'

# Consumer Agent
class Consumer < Agent
  attr_accessor :eq_v, :th, :endow, :buy

  def initialize(eq_v, th, endow)
    @eq_v = eq_v
    @th = th
    @endow = endow
    @buy
  end

  def u_a(a, e, b)
    # Unit inside the bracket
    a * e**b
  end

  def u_b(x_1, x_2)
    # Main bracket
    u_a(@eq_v[1], x_1, @eq_v[2]) + u_a(1 - @eq_v[1], x_2, @eq_v[2])
  end

  def utility(p_1, p_2, y_1, y_2)
    # Input: Data for generate plan
    # Output: Utility
    x_1, x_2 = *generate_plan(p_1, p_2, y_1, y_2)
    @eq_v[0] * u_b(x_1, x_2)**(@eq_v[3] / @eq_v[2])
  end

  def g_a(pr, en, y_1, y_2)
    # Input: Price of good, endowment for price, theta & both productions plans
    # Output: Prefered amount of a good
    # [pr * en, @th * pr * y_1, (1 - @th) * pr * y_2].inject(&:+)
    [en, @th * y_1, (1 - @th) * y_2].inject(&:+)
  end

  def generate_plan(p_1, p_2, y_1, y_2)
    # Input: two prices and both production plans
    # Output: Array of prefered ammount for both goods
    @buy = [g_a(p_1, @endow[0], y_1, y_2), g_a(p_2, @endow[1], y_1, y_2)]
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Consumer #{i}\nConsumption Plan = "\
    "Good 1: #{@buy[0]} | Good 2: #{@buy[1]}\n"
  end
end
