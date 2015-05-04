require_relative './base/agent'

# Actioneer Agent
class Auctioneer < Agent
  def find_price(pg, lamb, sumi, sumy)
    pg + lamb * (sumi - sumy)
  end
end
