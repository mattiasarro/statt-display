require 'split_random'

class Randomer
  def initialize(attr)
    @nr_visitors = attr[:nr_visitors]
    @nr_loads = attr[:nr_loads]
    @from = attr[:from]
    @to = attr[:to]
    @site = attr[:site]
    
    populate_visitors
    populate_loads
  end
  
  attr_reader :visitors, :loads, :from, :to
  
  def populate_visitors
    @visitors = []
    @nr_visitors.times.each do
      cl_user_id = Faker::Name.first_name if (Random.rand(10) > 7)
      ip = Faker::Internet.ip_v4_address
      @visitors.push({
        site_id: @site.id,
        cl_user_id: cl_user_id, 
        ip: ip,
        visitor_id: Moped::BSON::ObjectId.new,
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4",
        screenx: 1440,
        browserx: 1170,
        browsery: 501
      })
    end
  end
  
  def populate_loads
    @loads = Array.new(@nr_loads) {{ site_id: @site.id }}
    @loads.split_random(@nr_visitors).each do |slice|
      visitor = @visitors.pop
      http_referer = "http://google.com"
      visit_times = LoadRandomer.new(self, slice.size)
      
      slice.each do |load|
        load[:time] = visit_times.next_load_time
        load[:title] = Faker::Name.title
        load[:ip] = visitor[:ip]
        load[:cl_user_id] = visitor[:cl_user_id]
        load[:visitor_id] = visitor[:visitor_id]
        
        load[:http_referer] = http_referer # from the next guy
        load[:uri_string] = Faker::Internet.url
        http_referer = load[:uri_string] # for the next guy
      end
    end
  end
  
end

class LoadRandomer
  
  AVG_TIME_ON_PAGE = 60 # 1 minute
  def initialize(randomer, nr_loads)
    @from = randomer.from
    @to = randomer.to
    @nr_loads = nr_loads
  end
  
  def next_load_time
    @nr_loads -= 1
    if @load_time
      return(@load_time = get_next)
    else
      return(@load_time = first_load)
    end
  end
  
  # dumb implementation, lets it run over time boundaries
  def get_next
    time_on_page = rand(1..(AVG_TIME_ON_PAGE*2))
    @load_time + time_on_page
  end
  
  def first_load
    nr_avg_loads = (@to - @from).to_f / AVG_TIME_ON_PAGE
    i = rand(nr_avg_loads) + 1 # if 60 from..to == 60 min, i is the minute index for the first load    
    Time.at(@from + (i * AVG_TIME_ON_PAGE))
  end
end