require_relative './base/agent'
# require 'rinruby'

# Consumer Agent
class Consumer < Agent
  # Consumer's utility function is of CES Utility form
  # => U(x_1) = @eq_v[0](@eq_v[1]*x_11**@eq_v[2] +
  # =>          (1 - @eq_v[1])*x_12**@eq_v[2])**(@eq_v[3]/@eq_v[2])
  # => @th: an array containing consumer's share of both producers
  # => @endow: an array containing consumer's endowment of both goods
  # => @buy: an array containing the consumer's consumption plan for each good

  attr_accessor :eq_v, :th, :endow, :buy

  def initialize(eq_v, th, endow)
    @eq_v = eq_v
    @th = th # this is share
    @endow = endow
  end

  def r_work(y_1, y_2)
    R.eq_v = *@eq_v
    R.en = *@endow
    R.th = *@th
    R.y_11 = y_1[0]
    R.y_12 = y_1[1]
    R.y_21 = y_2[0]
    R.y_22 = y_2[1]
    R.eval <<EOF
      library(optimx)
      u_f <- function(x, y){
        result <- -(eq_v[1] * (eq_v[2] * x ** eq_v[3] + (1 - eq_v[2]) * y **
                  eq_v[3]) ** (eq_v[4] / eq_v[3]))
        return(result)
      }
      budg <- function(en, y_1, y_2){
        en + th[1] * y_1 + th[2] * y_2
      }
      opt <- optimx(c(0,0), function(x) u_f(x[1], x[2]), lower=0,
      upper=c(budg(en[1], y_11, y_21), budg(en[2], y_12, y_22)))
      a <- opt$p1
      b <- opt$p2
EOF
    [R.a, R.b]
  end

  def g_a(pr, en, y_1, y_2)
    # Input: Price of good, endowment, both production plans for said good
    # Output: Budget cap of consumer for given good
    # [@th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+) / pr + en
    [pr * en, @th[0] * pr * y_1, @th[1] * pr * y_2].inject(&:+)
    # [en, @th[0] * y_1, @th[1] * y_2].inject(&:+)
  end

  def cap(p_1, p_2, y_1, y_2)
    # Input: Prices of both goods & production plans for both goods
    # Output: Budget cap of consumer for both goods
    [g_a(p_1, @endow[0], y_1[0], y_2[0]),
     g_a(p_2, @endow[1], y_1[1], y_2[1])].inject(&:+)
  end

  def generate_plan(p_1, p_2, y_1, y_2)
    # Input: Prices of both goods & production plans for both goods
    # Output: an array containing the consumption plan for each good
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
