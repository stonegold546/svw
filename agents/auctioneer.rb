require_relative './base/agent'

# Actioneer Agent
class Auctioneer < Agent
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
    @terminator = outer_b(consumers, idx, producers)
  end

  def generate_plan(good, producers, consumers, idx)
    good.price + good.lamb * b_brack(producers, consumers, idx)
  end
end
