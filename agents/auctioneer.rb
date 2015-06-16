require_relative './base/agent'

# Actioneer Agent
class Auctioneer < Agent
  # Auctioneer adjusts the price according to the generate_plan method
  # => @demand: aggregate demand across consumers
  # => @supply: aggregate supply across producers
  # => @terminator: demand minus supply for specific good
  attr_accessor :terminator, :demand, :supply

  def inner_b(consumers, a)
    @demand = consumers.map(&:buy).map(&:"#{a}").inject(&:+) - consumers.map(
      &:endow).map(&:"#{a}").inject(&:+)
  end

  def rem_b(producers, a)
    @supply = producers.map(&:build).map(&:"#{a}").inject(&:+)
  end

  def outer_b(consumers, idx, producers)
    if idx == 0
      inner_b(consumers, 'first') - rem_b(producers, 'first')
    elsif idx == 1
      inner_b(consumers, 'last') - rem_b(producers, 'last')
    end
  end

  def b_brack(producers, consumers, idx)
    # Ouput: aggregate demand - aggregate supply
    @terminator = outer_b(consumers, idx, producers)
  end

  def generate_plan(good, producers, consumers, idx)
    # Input: good, producers, consumers, index of good in good array
    # => good: a good object
    # => producers: array of production plans for both producers
    # => consumers: array of consumption plans for all consumers
    # Output: New price of goods
    good.price + good.lamb * b_brack(producers, consumers, idx)
  end
end
