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
endow_1, endow_2, endow_3 = *[[3, 5], [4, 2], [2, 6]]
con_s = [Consumer.new([2, 0.5, 0.9, 0.5], 0.8, endow_1),
         Consumer.new([3, 0.6, 0.95, 1.6], 0.3, endow_2),
         Consumer.new([5, 0.7, 0.8, 0.7], 0.6, endow_3)]
pro_s = [Producer.new(2, 0.7, 0.3), Producer.new(3, 0.2, 0.6)]

count = 0
loop do
  count += 1
  gp_1, gp_2 = *goo_s.map(&:price)
  puts "Auctioneer:\nWelcome to round #{count} of negotiations.\n"\
  "The prices have been set at:\n#{gp_1} for Good 1; and\n#{gp_1} for Good 2\n"\
  "Producers, would you please turn in your production plans?\n================"
  pro_plan = []
  con_plan = []
  pro_s.each do |pro|
    pro_plan.push(pro.generate_plan(gp_1, gp_2))
  end
  sleep(1.5)
  puts "Producer 1\nProduction Plan: #{pro_plan[0]}\n---"
  puts "Producer 2\nProduction Plan: #{pro_plan[1]}\n================"
  sleep(1.5)
  puts "Auctioneer:\nConsumers, please submit your requests your requests"\
  ".\n================"
  # con_s.each do |con|
  #   puts con.utility
  # end
  con_s.each do |con|
    con_plan.push(con.generate_plan(gp_1, gp_2, *pro_plan))
  end
  sleep(1.5)
  # puts "#{con_plan}"
  puts "Consumer 1\nConsumption Plan = "\
  "Good 1: #{con_plan[0][0]} | Good 2: #{con_plan[0][1]}\n---"
  puts "Producer 2\nConsumption Plan = "\
  "Good 1: #{con_plan[1][0]} | Good 2: #{con_plan[1][0]}\n---"
  puts "Producer 3\nConsumption Plan = "\
  "Good 1: #{con_plan[2][0]} | Good 2: #{con_plan[2][0]}\n================"
  break if 1 == 1
end
