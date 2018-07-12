class BoardGames::Scraper

	#add to scraper
	def noko_main
		Nokogiri::HTML(open("https://www.boardgamegeek.com/browse/boardgame"))
	end#end listgen
#~~~~~~~~~~~~~~~~
	def scrape_list
		self.noko_main.css(".collection_table tr#row_")
	end#end scrape_list
#~~~~~~~~~~~~~~~~
	def gen_list
		scrape_list.each{|row| new_compiled(row)}
 	end #gen list
#~~~~~~~~~~~~~~~~
def new_compiled(row)
	title = row.css('.collection_objectname a').text
	url = row.css('.collection_objectname a').attr("href").text
	geek= row.css('.collection_bggrating')[0].text.strip
	avg_rating = row.css('.collection_bggrating')[1].text.strip
	game_id = url[/(\/\d*\/)/].gsub("/", "")
	rank = row.css(".collection_rank").text.strip
	BoardGames::Game.new(title, rank, url, avg_rating, game_id)
end #end scrape list
#~~~~~~~~~~~~~~~~
end #end the scraper
