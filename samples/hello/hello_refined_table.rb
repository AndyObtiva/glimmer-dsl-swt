# Copyright (c) 2007-2022 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer-dsl-swt'
require 'date'

class HelloRefinedTable
  BaseballTeam = Struct.new(:name, :town, :ballpark, keyword_init: true) do
    class << self
      def all
        @all ||= [
          {town: 'Chicago', name: 'White Sox', ballpark: 'Guaranteed Rate Field'},
          {town: 'Cleveland', name: 'Indians', ballpark: 'Progressive Field'},
          {town: 'Detroit', name: 'Tigers', ballpark: 'Comerica Park'},
          {town: 'Kansas City', name: 'Royals', ballpark: 'Kauffman Stadium'},
          {town: 'Minnesota', name: 'Twins', ballpark: 'Target Field'},
          {town: 'Baltimore', name: 'Orioles', ballpark: 'Oriole Park at Camden Yards'},
          {town: 'Boston', name: 'Red Sox', ballpark: 'Fenway Park'},
          {town: 'New York', name: 'Yankees', ballpark: 'Comerica Park'},
          {town: 'Tampa Bay', name: 'Rays', ballpark: 'Tropicana Field'},
          {town: 'Toronto', name: 'Blue Jays', ballpark: 'Rogers Centre'},
          {town: 'Houston', name: 'Astros', ballpark: 'Minute Maid Park'},
          {town: 'Los Angeles', name: 'Angels', ballpark: 'Angel Stadium'},
          {town: 'Oakland', name: 'Athletics', ballpark: 'RingCentral Coliseum'},
          {town: 'Seattle', name: 'Mariners', ballpark: 'T-Mobile Park'},
          {town: 'Texas', name: 'Rangers', ballpark: 'Globe Life Field'},
          {town: 'Chicago', name: 'Cubs', ballpark: 'Wrigley Field'},
          {town: 'Cincinnati', name: 'Reds', ballpark: 'Great American Ball Park'},
          {town: 'Milwaukee', name: 'Brewers', ballpark: 'American Family Field'},
          {town: 'Pittsburgh', name: 'Pirates', ballpark: 'PNC Park'},
          {town: 'St. Louis', name: 'Cardinals', ballpark: 'Busch Stadium'},
          {town: 'Atlanta', name: 'Braves', ballpark: 'Truist Park'},
          {town: 'Miami', name: 'Marlins', ballpark: 'LoanDepot Park'},
          {town: 'New York', name: 'Mets', ballpark: 'Citi Field'},
          {town: 'Philadelphia', name: 'Phillies', ballpark: 'Citizens Bank Park'},
          {town: 'Washington', name: 'Nationals', ballpark: 'Nationals Park'},
          {town: 'Arizona', name: 'Diamondbacks', ballpark: 'Chase Field'},
          {town: 'Colorado', name: 'Rockies', ballpark: 'Coors Field'},
          {town: 'Los Angeles', name: 'Dodgers', ballpark: 'Dodger Stadium'},
          {town: 'San Diego', name: 'Padres', ballpark: 'Petco Park'},
          {town: 'San Francisco', name: 'Giants', ballpark: 'Oracle Park'},
        ].map {|team_kwargs| new(team_kwargs)}
      end
    end
    
    def complete_name
      "#{town} #{name}"
    end
  end
    
  BaseballGame = Struct.new(:date, :home_team, :away_team, keyword_init: true) do
    def home_team_name
      home_team.complete_name
    end
    
    def away_team_name
      away_team.complete_name
    end
    
    def ballpark
      home_team.ballpark
    end
  end
  
  BaseballSeason = Struct.new(:year) do
    def games
      if @games.nil?
        @games = []
        baseball_team_combinations = BaseballTeam.all.combination(2).to_a
        current_day = first_day
        day_offset = 0
        begin
          if (day_offset % 7 != 6)
            day_games = []
            half_teams_count = BaseballTeam.all.count / 2
            while day_games.uniq.count < half_teams_count
              baseball_team_pair = baseball_team_combinations.sample
              teams_played_so_far = day_games.map {|game| [game.home_team, game.away_team]}.flatten
              unless teams_played_so_far.include?(baseball_team_pair.first) || teams_played_so_far.include?(baseball_team_pair.last)
                baseball_game = BaseballGame.new(
                  date: current_day,
                  home_team: baseball_team_pair.first,
                  away_team: baseball_team_pair.last,
                )
                day_games << baseball_game
                @games << baseball_game
              end
            end
          end
          day_offset += 1
          current_day += 1
        end while current_day != first_day_of_playoffs
      end
      @games
    end
    
    def first_day
      @first_day ||= Date.new(year, 04, 01)
    end
    
    def first_day_of_playoffs
      @last_day ||= Date.new(year, 10, 01)
    end
  end
  
  include Glimmer::UI::Application
  
  before_body do
    @baseball_season = BaseballSeason.new(Time.now.year)
  end

  body {
    shell {
      text 'Hello, Refined Table!'
    
      refined_table(per_page: 30) {
        table_column {
          width 100
          text 'Date'
        }
        table_column {
          width 200
          text 'Ballpark'
        }
        table_column {
          width 150
          text 'Home Team'
        }
        table_column {
          width 150
          text 'Away Team'
        }
        
        model_array <= [@baseball_season, :games, column_attributes: {'Home Team' => :home_team_name, 'Away Team' => :away_team_name}]
      }
    }
  }

end

HelloRefinedTable.launch
