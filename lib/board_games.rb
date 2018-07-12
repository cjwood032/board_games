module BoardGames
end

require 'nokogiri'
require 'pry'
require 'open-uri'
require 'capybara/poltergeist'
require_relative "board_games/scraper"
require_relative "board_games/game"
require_relative "board_games/cli"
require_relative "board_games/version"
