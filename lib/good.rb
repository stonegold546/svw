# Products for auction
class Good
  attr_accessor :price, :lamb

  def initialize(price, lamb)
    @price = price
    @lamb = lamb
  end
end
