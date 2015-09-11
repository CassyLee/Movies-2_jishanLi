
class MovieDataPre
	attr_accessor :userfile, :moviefile, :most_simi
	def initialize()
		@userfile = {}
    @moviefile = {}
		@most_simi = {}
	end

	def load_data(name)
	#load data from file u.data
    	file = open(name)
    	lines = file.readlines
    	lines.each do |line|
    		data = line.split(' ')
    		u_id = data[0]
    		m_id = data[1]
    		rating = data[2]

    		 #store all rating from each user in hash @userfile
    		if @userfile.has_key?(u_id)
    			@userfile[u_id][m_id] = rating
    		else @userfile[u_id] = {m_id =>rating}
    		end

    		#store all rating for each movie in hash @moviefile
    		if @moviefile.has_key?(m_id)
    			@moviefile[m_id][u_id] = rating
    		else @moviefile[m_id] = {u_id =>rating}
    		end

				if @most_simi.has_key?(u_id)
				else
					@most_simi[u_id] = most_similar(u_id)
				end
    	end
	end

	#I count the popularity score in two parts, heat and valuation
	# heat reflected from the ratio of the number of user that has viewed the movie and number of all users
	# valuation reflected from the ratio of total points from all viewers and the full mark from this amount of viewers
	# I think heat is more important to popularity so I doubled the heat part.
	"""def popularity(movie_id)
		data = @moviefile[movie_id]
		rate_num = data.length
		sum = 0
		data.each { |a| sum+=a.to_i }
		score = (rate_num/@usernum)*2 + sum/(rate_num * 5.0)
		return score
	end

	# call the popularity function to calculate each movie's popularity and store them in hash
	# sort the hash decreasingly
	def popularity_list()
		poplist = {}
		@moviefile.keys.each do |m_id|
			score = popularity(m_id)
			poplist[m_id] = score
		end
		poplist = poplist.sort_by {|k, v| v}.reverse
		return poplist
	end"""

	def similarity(user1,user2)
		data1 = @userfile[user1]
		data2 = @userfile[user2]
		common = data1.keys & data2.keys
		num_com = common.length.to_f  #number of common movies two users viewed
		rating_diff = 0   #difference of ratings two users give to common movies
		common.each { |a| rating_diff += (data1[a].to_i - data2[a].to_i).abs }
		rating_diff += 1  # in case it's 0
		amount_diff = (data1.keys.length - data2.keys.length).abs #difference of total amount of movies two users viewed
		amount_diff += 1  # in case it's 0
		score = num_com/amount_diff + num_com / rating_diff  # I think they somehow should be in inverse proportion
		return score
	end


	def most_similar(u)
		similist = {}
		@userfile.keys.each do |u_id|
			score = similarity(u,u_id)
			similist[u_id] = score
		end
		similist = similist.sort_by {|k, v| v}.reverse
		most_simi = []
		similist[0..20].each {|x| most_simi.push(x[0]) }
		return most_simi
	end
end
