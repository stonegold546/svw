# Products for auction
class Good
  # Each good has two attributes: price and lamb
  attr_accessor :price, :lamb

  def initialize(price, lamb)
    @price = price
    @lamb = lamb
  end
end
