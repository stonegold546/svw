require_relative './base/agent'

# Producer Agent
class Producer < Agent
  # Producer's utility function is of Cobb-Douglas form
  # => Y(x_1, x_2) = @eq_k(x_1**@eq_a*x_2**@eq_b)
  # => cap: Production constraint of producer
  # => @build: an array containing the producer's production plan for each good

  attr_accessor :eq_k, :eq_a, :eq_b, :build

  def initialize(eq_k, eq_a, eq_b)
    @eq_k = eq_k
    @eq_a = eq_a
    @eq_b = eq_b
  end

  def cap
    50
  end

  def find_x2(p_1, p_2)
    b = cap * (p_1 / p_2 * @eq_a / @eq_b)**-@eq_a / @eq_k
    Math.exp((Math.log(b)) / (@eq_a + @eq_b))
  end

  def generate_plan(p_1, p_2)
    # Input: the prices of two goods
    # Output: an array containing the production plan for each good
    x_2 = find_x2(p_1, p_2)
    @build = [
      p_1 / p_2 * @eq_a / @eq_b * x_2,
      x_2
    ]
    # Assuming Consumer Cobb-Douglas
    # @build = [@eq_a / (@eq_a + @eq_b) * cap / p_1,
    #           @eq_b / (@eq_a + @eq_b) * cap / p_2]
    # Assuming Cobb-Douglas but make-belief equation
    # @build = [@eq_a / (@eq_a + @eq_b) * cap * p_1 / (p_1 + p_2),
    #           @eq_b / (@eq_a + @eq_b) * cap * p_2 / (p_1 + p_2)]
    # Assuming Leo
    # @build = [@eq_a / 1 * cap / p_1, # / (p_1 + p_2),
    #           @eq_b / 1 * cap / p_2] # / (p_1 + p_2)]
  end

  def announce(i)
    header = ''
    header = "---\n" unless i == 1
    puts "#{header}Producer #{i}\nProduction Plan = "\
    "Good 1: #{@build[0]} | Good 2: #{@build[1]}\n"
  end
end
