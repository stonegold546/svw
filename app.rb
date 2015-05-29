require_relative './agents/auctioneer'
require_relative './agents/consumer'
require_relative './agents/producer'
require_relative './lib/good'

goo_s = [Good.new(1, 0.1), Good.new(1, 0.1)]
endow_1, endow_2, endow_3 = *[[3, 5], [4, 2], [2, 6]]
con_s = [Consumer.new([2, 0.5, 0.9, 0.5], 0.8, endow_1),
         Consumer.new([3, 0.6, 0.95, 1.6], 0.3, endow_2),
         Consumer.new([5, 0.7, 0.8, 0.7], 0.6, endow_3)]
pro_s = [Producer.new(2, 0.7, 0.3), Producer.new(3, 0.2, 0.6)]
pro_1, pro_2 = *pro_s
con_1, con_2, con_3 = *con_s
auctioneer = Auctioneer.new

count, eps = *[0, Float::EPSILON]
a = b = count

loop do
  # TODO: Find new prices
  # TODO: Find market clear
  count += 1
  gp_1, gp_2 = *goo_s.map(&:price)
  sleep(04) if count % 10_000 == 0
  puts "Auctioneer:\nWelcome to round #{count} of negotiations.\n"\
  "The prices have been set at:\n  #{gp_1} for Good 1; and"\
  "\n  #{gp_2} for Good 2\n"\
  "Producers, would you please turn in your production plans?\n================"
  pro_plan = []
  con_plan = []
  pro_s.each do |pro|
    pro_plan.push(pro.generate_plan(gp_1, gp_2))
  end
  # sleep(1.5)
  pro_1.announce(1)
  pro_2.announce(2)
  puts '================'
  # sleep(1.5)
  puts "Auctioneer:\nConsumers, please submit your requests your requests"\
  ".\n================"
  # con_s.each do |con|
  #   puts con.utility
  # end
  con_s.each do |con|
    con_plan.push(con.generate_plan(gp_1, gp_2, *pro_plan))
  end
  # sleep(1.5)
  # puts "#{con_plan}"
  con_1.announce(1)
  con_2.announce(2)
  con_3.announce(3)
  puts '================'
  goo_s.each_with_index.map do |goo, idx|
    goo.price = auctioneer.generate_plan(goo, pro_s, con_s, idx)
    idx.even? ? a = auctioneer.terminator.abs : b = auctioneer.terminator.abs
  end
  puts "#{goo_s[0].price} #{goo_s[1].price}"
  puts "#{a} #{b}"
  # puts "#{pro_plan[0] == a} #{pro_plan[1] == b}"
  puts "\n\n\n\n\n"
  break if a < eps && b < eps
end
