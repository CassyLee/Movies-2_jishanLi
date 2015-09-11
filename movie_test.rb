class MovieTest
  attr_accessor :data, :difference, :size
  def initialize(data)
    @data = data
    @difference = []
    @size = data.size
  end

  def diff_compute()
    @data.each {|instance| @difference.push((instance[3] - instance[2].to_f).abs)}
  end

  def mean()
    sum = @difference.inject{|sum,diff| sum + diff}
    ave_error = sum/@size
    return ave_error
  end

  def stddev()
    sum = @difference.inject{|sum,diff| sum + diff * diff}
    stddev_error = sum/@size
    return stddev_error
  end

  def rms()
    stdd = stddev()
    rms_error = Math.sqrt(stdd)
    return rms_error
  end

  def to_a()
      return @data
  end

end
