require_relative './agents/auctioneer'
require_relative './agents/consumer'
require_relative './agents/producer'
require_relative './lib/good'

goo_s = [Good.new(1, 0.001), Good.new(1, 0.001)]
endow_1, endow_2, endow_3 = *[[3, 5], [4, 2], [2, 6]]
share_1, share_2, share_3 = *[[0.4, 0.3], [0.3, 0.5], [0.3, 0.2]]
# share_1, share_2, share_3 = *[[0.4, 0.3], [0.3, 0.5], [0.2, 0.2]]
# => Price around e-14
# share_1, share_2, share_3 = *[[0.4, 0.3], [0.3, 0.5], [0.3, 0.2]]
# => What are conditions for equilibrium?
con_s = [Consumer.new([2, 0.5, 0.9, 0.5], share_1, endow_1),
         Consumer.new([3, 0.6, 0.95, 1.6], share_2, endow_2),
         Consumer.new([5, 0.7, 0.8, 0.7], share_3, endow_3)]
pro_s = [Producer.new(2, 0.7, 0.3), Producer.new(3, 0.2, 0.6)]
pro_1, pro_2 = *pro_s
con_1, con_2, con_3 = *con_s
auctioneer = Auctioneer.new

a, b, count, eps = *[0, 0, 0, 2**-23] # Using single precision machine epsilon
# a, b, count, eps = *[0, 0, 0, 2**-52] # Using double precision machine epsilon

f_1 = File.new('graph_1.csv', 'w+')
# f_1 = File.new('graph_b_1.csv', 'w+')
f_1.write("round, demand, supply, price, demand-supply\n")
f_2 = File.new('graph_2.csv', 'w+')
# f_2 = File.new('graph_b_2.csv', 'w+')
f_2.write("round, demand, supply, price, demand-supply\n")

loop do
  # TODO: Find new prices
  # TODO: Find market clear
  # TODO: Pass productions plans to R code
  count += 1
  gp_1, gp_2 = *goo_s.map(&:price)
  sleep(04) if count % 1_000 == 0
  puts "Auctioneer:\nWelcome to round #{count} of negotiations.\n"\
  "The prices have been set at:\n  #{gp_1} for Good 1; and"\
  "\n  #{gp_2} for Good 2\n"\
  "Producers, would you please turn in your production plans?\n================"
  pro_plan = []
  con_plan = []
  pro_s.each do |pro|
    pro_plan.push(pro.generate_plan(gp_1, gp_2))
  end
  pro_1.announce(1)
  pro_2.announce(2)
  puts '================'
  puts "Auctioneer:\nConsumers, please submit your requests your requests"\
  ".\n================"
  con_s.each do |con|
    con_plan.push(con.generate_plan(gp_1, gp_2, *pro_plan))
  end
  con_1.announce(1)
  con_2.announce(2)
  con_3.announce(3)
  puts '================'
  goo_s.each_with_index.map do |goo, idx|
    goo.price = auctioneer.generate_plan(goo, pro_s, con_s, idx)
    t = "#{count}, #{auctioneer.demand}, #{auctioneer.supply}, #{goo.price}, "
    if idx.even?
      a = auctioneer.terminator.abs
      t = t << "#{a}\n"
      f_1.write(t)
    else
      b = auctioneer.terminator.abs
      t = t << "#{b}\n"
      f_2.write(t)
    end
  end
  puts "#{goo_s[0].price} #{goo_s[1].price}"
  puts "#{a} #{b}"
  puts "\n\n"
  break if a < eps && b < eps
end
