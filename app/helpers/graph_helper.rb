module GraphHelper
  def graph_pagination(graph, direction)
    case direction
    when :prev then @new_from_time = @from - @graph_duration
    when :next then @new_from_time = @from + @graph_duration
    end
    @new_to_time = @new_from_time + @graph_duration

    ret = { "type" => "custom" } # todo: take from graph_type
    ret.merge!(pack_time(@new_from_time, :from))
    ret.merge!(pack_time(@new_to_time, :to))
  end
  
  def pack_time(time, sym)
    {
      "#{sym}(1i)" => time.year,
      "#{sym}(2i)" => time.month,
      "#{sym}(3i)" => time.day,
      "#{sym}(4i)" => time.hour,
      "#{sym}(5i)" => time.min,
      "#{sym}(6i)" => time.sec
    }
  end
end