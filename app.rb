require_relative './agents/auctioneer'
require_relative './agents/consumer'
require_relative './agents/producer'
require_relative './lib/good'

# goo_1, goo_2 = *[Good.new(1, 0.1), Good.new(1, 0.1)]
# goo_2 = Good.new(1, 0.1)
# con_1, con_2, con_3 = *[Consumer.new(2, 0.5, 0.9, 0.5),
#                         Consumer.new(3, 0.6, 0.95, 1.6),
#                         Consumer.new(5, 0.7, 0.8, 0.7)]
# con_2 = Consumer.new(3, 0.6, 0.95, 1.6)
# con_3 = Consumer.new(5, 0.7, 0.8, 0.7)
# pro_1, pro_2 = *[Producer.new(2, 0.7, 0.3), Producer.new(3, 0.2, 0.6)]
# pro_2 = Producer.new(3, 0.2, 0.6)
goo_s = [Good.new(1, 0.1), Good.new(1, 0.1)]
con_s = [Consumer.new(2, 0.5, 0.9, 0.5), Consumer.new(3, 0.6, 0.95, 1.6),
         Consumer.new(5, 0.7, 0.8, 0.7)]
pro_s = [Producer.new(2, 0.7, 0.3), Producer.new(3, 0.2, 0.6)]

loop do
  # puts goo_s, con_s, pro_s
  con_s.each do |con|
    puts con.utility(*goo_s.map(&:price))
  end
  pro_s.each do |pro|
    puts pro.generate_plan(*goo_s.map(&:price))
  end
  break if 1 == 1
end
