class BoardGames::CLI
	attr_accessor :given_range
	def call
		BoardGames::Scraper.new.gen_list
		@given_range = 25
		@games=BoardGames::Game.all
		@sort_games=[]
		@types=[]
		list_games
	end #end the call method
#~~~~~~~~~~~~~~~~
	def list_games
		puts  <<-DOC
    	Here are the current top #{@given_range} games.
Rank	Game
    DOC
		counter = 0
		@games.each do |game|
			if counter < @given_range
				puts "#{game.rank} 	#{game.title}"
			end #end the if
			counter +=1
		end #ends the each do
			top_menu
	end #end the list games method
#~~~~~~~~~~~~~~~~
  def top_menu
        puts <<-DOC



    What would you like to do?
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Get more information on a specific game:
    2. Filter:
    3. Change range:
    4. Exit program
    DOC
    input=gets.strip
    case input
    when "1"
      info_menu
    when "2"
      filter_menu
    when "3"
      update_menu
    when "4"
      abort("Always a pleasure")
    else
      puts "Please enter a valid selection"
      top_menu
    end #end the case-when
  end #end top menu
#~~~~~~~~~~~~~~~~
  def info_menu
    puts <<-DOC
    Please enter the overall rank number
    to see details of a specific game
    DOC
    input = gets.strip.to_i
		if input >=1 && input <= 100
			@games.each do |game|
				if game.rank.to_i == input
					show_deets(game)
				end #end check
			end #end the each do
		else
			puts "Please select a valid number:"
			info_menu
		end #end the if/else
  end #end the info menu
#~~~~~~~~~~~~~~~~
  def filter_menu
		@sortgames = []
		if @types==[]
			get_typelist
		end
		puts <<-DOC


  	Type in a game type
Type 'list types' for a list of types. Type 'quit' to go back
  	DOC
  	input=gets.strip
  	if input== "list types"
			puts @types
			filter_menu
		elsif input == "quit"
			@types = []
			top_menu
		elsif @types.include?(input)
			count = 0
			@games.each do |game|
				count +=1
				if count > @given_range
					break
				end
				if game.type.include?(input)
					@sort_games << game
				end #end the include
			end #end the games each do
			puts ""
			puts "#{input} games"
			@sort_games.each do |game|
				puts "#{game.title}"
			end #end the each do
			@sort_games.clear
			filter_menu
		else
			puts "Input not recognized, please try again"
			filter_menu
		end #end of the list input check
		@types = [] #clear types
    top_menu
  end #end the filter
#~~~~~~~~~~~~~~~~
	def get_typelist
		puts "working... scraping #{@given_range} games, please be patient :)"
		count=0
		@games.each do |game|
			count +=1
			if count > @given_range
				break
			end
			type=game.get_types
			game.types=type
			@types << type
		end #end the games each do
		@types=@types.flatten.uniq
	end #end the typelist
#~~~~~~~~~~~~~~~~
  def update_menu
    puts "Enter the number of games you would like to see (up to 100)"
		input=gets.strip.to_i
		if input >= 1 && input <= 100
			@given_range = input
		else
			puts "Please select a valid number."
			update_menu
		end #end the if/else
    list_games
  end #end the update menu
#~~~~~~~~~~~~~~~~
  def show_deets(bg)
		bg.scrapegame
		#binding.pry
		puts <<-DOC
          #{bg.title}
    Ranked: ##{bg.rank} overall.
    For #{bg.players} players.
    Average playtime is #{bg.playtime} minutes.
    Types: #{bg.types}
  Categories: ~#{bg.category}~
		DOC
		binding.pry
    bg.description.each do |x|
			puts x.center(20)
		end #end description
		top_menu
  end #end show deets
end #end the class
