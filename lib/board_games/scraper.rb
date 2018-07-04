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
		scrape_list.each{|row| BoardGames::Game.new_compiled(row)}
 	end #gen list
#~~~~~~~~~~~~~~~~


end #end the scraper
