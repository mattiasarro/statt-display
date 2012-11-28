require 'randomer'

# for testing LoadRandomer
task :randomer => :environment do
  
  @r = Randomer.new(
    nr_visitors: 4,
    nr_loads: 30,
    from: Time.at(60.minutes.ago),
    to: Time.at(Time.now)
  )
  
  @lr = LoadRandomer.new(@r,5)
  
  puts @lr.inspect
  puts "lr.next_load_time: #{@lr.next_load_time}"
  puts "lr.next_load_time: #{@lr.next_load_time}"
end