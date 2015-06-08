require_relative './base/agent'

# Consumer Agent
class Consumer < Agent
  attr_accessor :eq_v, :th, :endow, :buy

  def initialize(eq_v, th, endow)
    @eq_v = eq_v
    @th = th # this is share
    @endow = endow
  end

  def g_a(pr, en, y_1, y_2)
    # Input: Price of good, endowment for price, theta & both productions plans
    # Output: Prefered amount of a good
    # [@th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+) / pr + en
    [pr * en, @th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+)
    # [en, @th[0] * y_1, @th[1] * y_2].inject(&:+)
  end

  def cap(p_1, p_2, y_1, y_2)
    [g_a(p_1, @endow[0], y_1[0], y_2[0]),
     g_a(p_2, @endow[1], y_1[1], y_2[1])].inject(&:+)
  end

  def generate_plan(p_1, p_2, y_1, y_2)
    # Input: two prices and both production plans
    # Output: Array of prefered ammount for both goods
    @buy = [
      # Assuming that MAJOR!
      d_b(p_1, @eq_v[1]) * plan_help(p_1, p_2, y_1, y_2),
      d_b(p_2, 1 - @eq_v[1]) * plan_help(p_1, p_2, y_1, y_2)
    ]
  end

  def d_b(p, a_b)
    rho = 1 / (1 - @eq_v[2])
    (p / a_b)**-rho
  end

  def plan_help(p_1, p_2, y_1, y_2)
    cap(p_1, p_2, y_1, y_2) / demand_help(p_1, p_2)
  end

  def demand_help(p_1, p_2)
    d_a(p_1, @eq_v[1]) + d_a(p_2, 1 - @eq_v[1])
  end

  def d_a(p, a_b)
    rho = 1 / (1 - @eq_v[2])
    a_b**rho * p**(1 - rho)
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Consumer #{i}\nConsumption Plan = "\
    "Good 1: #{@buy[0]} | Good 2: #{@buy[1]}\n"
  end
end
