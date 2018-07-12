class BoardGames::Game
	attr_accessor :title, :rank, :url, :geek, :avg_rating, :id, :types, :players, :playtime, :category, :description
	@@all = []

#~~~~~~~~~~~~~~~~
	def initialize(title = nil, rank = nil, url = nil, avg_rating = nil, game_id = nil, type = nil, players = nil, playtime = nil, category = nil, description = nil )
		@title = title
		@rank = rank
		@url = url
		@avg_rating = avg_rating
		@game_id = game_id
		@types = type
		@players = players
		@playtime = playtime
		@category = category
		@description = description
		@@all << self
	end #end the init method
#~~~~~~~~~~~~~~~~
	def self.all
		@@all
	end
#~~~~~~~~~~~~~~~~
	def scrapegame
		session=Capybara::Session.new(:poltergeist)
		session.visit("https://boardgamegeek.com#{@url}")
		@players = session.find('.gameplay').text.split[0]
		@playtime = session.find('.gameplay').text.split[7]
		gary = session.find('.panel.panel-bottom.game-classification').text.split
		i_type = gary.index('Type')
		i_cat = gary.index('Category')
		i_mech = gary.index('Mechanisms')
		@types = gary.drop(i_type+1).take(i_cat-i_type-1).join(" ")
		@category = gary.drop(i_cat+1).take(i_mech-i_cat-1).join(" ~ ")
		@description = session.find('.game-description-body').text.split('.')
		self
	end #end scrapegame
#~~~~~~~~~~~~~~~~
	def get_types
		types=[]
		session=Capybara::Session.new(:poltergeist)
		session.visit("https://boardgamegeek.com#{@url}")
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
