class BoardGames::Game
	attr_accessor :title, :rank, :url, :geek, :avg_rating, :id, :types, :players, :playtime, :type, :category, :description
	@@all = []

	def self.new_compiled(row)
		title = row.css('.collection_objectname a').text
		url = row.css('.collection_objectname a').attr("href").text
		geek= row.css('.collection_bggrating')[0].text.strip
		avg_rating = row.css('.collection_bggrating')[1].text.strip
		game_id = url[/(\/\d*\/)/].gsub("/", "")
		rank = row.css(".collection_rank").text.strip
		self.new(title, rank, url, avg_rating, game_id)
	end #end scrape list
#~~~~~~~~~~~~~~~~
	def initialize(title = nil, rank = nil, url = nil, avg_rating = nil, game_id = nil, type = nil)
		@title = title
		@rank = rank
		@url = url
		@avg_rating = avg_rating
		@game_id = game_id
		@type = type
		@@all << self
	end #end the init method
#~~~~~~~~~~~~~~~~
#	def self.add_type(type)
#			@type=type
#	end
#~~~~~~~~~~~~~~~~
	def self.all
		@@all
	end
#~~~~~~~~~~~~~~~~
	def self.scrapegame(url)
		session=Capybara::Session.new(:poltergeist)
		session.visit("https://boardgamegeek.com#{url}")
		g=self.new
		g.players = session.find('.gameplay').text.split[0]
		g.playtime = session.find('.gameplay').text.split[7]
		gary = session.find('.panel.panel-bottom.game-classification').text.split
		i_type = gary.index('Type')
		i_cat = gary.index('Category')
		i_mech = gary.index('Mechanisms')
		g.type = gary.drop(i_type+1).take(i_cat-i_type-1).join(" ")
		g.category = gary.drop(i_cat+1).take(i_mech-i_cat-1).join(" ~ ")
		g.description = session.find('.game-description-body').text.split('.')
		g
	end #end scrapegame
#~~~~~~~~~~~~~~~~
	def self.get_types(url)
		types=[]
		session=Capybara::Session.new(:poltergeist)
		session.visit("https://boardgamegeek.com#{url}")
		gary = session.find('.panel.panel-bottom.game-classification').text.split
		i_type = gary.index('Type')
		i_cat = gary.index('Category')
		#binding.pry
		type = gary.drop(i_type+1).take(i_cat-i_type-1)
		type.each do |item|
			unless type.index(item)==(type.length-1)
				types << item.chop
			else
				types << item
				end #end the unless
			end #end the each do
			types
	end #end the get_types
end #end the class
