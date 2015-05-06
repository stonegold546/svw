require_relative './base/agent'

# Actioneer Agent
class Auctioneer < Agent
  attr_accessor :terminator

  def inner_b(consumers, a)
    consumers.map(&:buy).map(&:"#{a}").inject(&:+) - consumers.map(
      &:endow).map(&:"#{a}").inject(&:+)
  end

  def rem_b(producers)
    producers.map(&:build).inject(&:+)
  end

  def outer_b(consumers, idx)
    if idx == 0
      inner_b(consumers, 'first')
    elsif idx == 1
      inner_b(consumers, 'last')
    end
  end

  def b_brack(producers, consumers, idx)
    @terminator = outer_b(consumers, idx) - rem_b(producers)
  end

  def generate_plan(good, producers, consumers, idx)
    good.price + good.lamb * b_brack(producers, consumers, idx)
  end
end
