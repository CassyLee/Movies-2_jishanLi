require_relative "movie_data.rb"
require 'pry-byebug'
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

class MovieData

  def initialize(*param)
    fold = param[0]
    file = param[1]
    if file == nil
      training = "#{fold}/u.data"
      @test = nil
    else
      training = "./#{fold}/#{file}.base"
      @test = "#{fold}/#{file}.test"
    end
    @training_set = MovieDataPre.new()
    @training_set.load_data(training)
    @userfile = @training_set.userfile
    @moviefile = @training_set.moviefile
    @most_simi = @training_set.most_simi
  end

  def rating(user,movie)
    if @userfile[user].has_key?(movie)
      rate = @userfile[user][movie]
    else
      rate = 0
    end
    return rate
  end

  def movies(user)
    movie = @userfile[user].keys
    return movie
  end

  def viewers(movie)
    viewer = @moviefile[movie].keys
    return viewer
  end

  def ave_rating(movie)
    if @moviefile.has_key?(movie)
      ratings = @moviefile[movie].values
      sum = 0
      ratings.each{|r| sum += r.to_i}
      num = ratings.length
      ave = sum/num
    else
      ave = 0
    end
    return ave
  end

  def predict(user,movie)
    if @most_simi.has_key?(user)
      similist = @most_simi[user]
    else
      similist = @training_set.most_similar(user)
    end
    ave = ave_rating(movie)
    rating = 0
    viewer = 0
    similist.each do |u_id|
      if @userfile[u_id].has_key?(movie)
        rating += @userfile[u_id][movie].to_f
        viewer += 1
      end
    end
    if viewer == 0
      rating = ave
    else
      rating = rating/viewer
    end
    rating = rating * 0.5 + ave * 0.5
    return rating
  end

  def line_process(line)
    data = line.split(' ')
    instance = [data[0],data[1],data[2],predict(data[0],data[1])]
    return instance
  end

  def run_test(*k)
    if @test == nil
      puts 'empty test file'
    else
      file = open(@test)
      lines = file.readlines
      if k[0] != nil
        lines = lines[0..k[0]]
      end
      data = []
      lines.each {|line| data.push(line_process(line))}
      result = MovieTest.new(data)
      result.diff_compute
      puts "root mean square error is: #{result.rms()}"
    end
    return result
  end

end

m = MovieData.new("ml-100k",:u1)
m.run_test()
