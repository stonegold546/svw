require_relative './base/agent'

# Actioneer Agent
class Auctioneer < Agent
  attr_accessor :terminator

  def find_price(pg, lamb, sumi, sumy)
    pg + lamb * (sumi - sumy)
  end

  def build(producers)
    producers.map(&:build)
  end

  def endow(consumers)
    consumers.map(&:endow)
  end

  def buy(consumers)
    consumers.map(&:buy)
  end

  def inner_b(consumers, a)
    buy(consumers).map(&:"#{a}").inject(&:+) - endow(
      consumers).map(&:"#{a}").inject(&:+)
  end

  def rem_b(producers)
    build(producers).inject(&:+)
  end

  def brack(consumers, idx)
    if idx == 0
      inner_b(consumers, 'first')
    elsif idx == 1
      inner_b(consumers, 'last')
    end
  end

  def b_brack(producers, consumers, idx)
    @terminator = brack(consumers, idx) - rem_b(producers)
  end

  def generate_plan(good, producers, consumers, idx)
    good.price + good.lamb * b_brack(producers, consumers, idx)
  end
end
