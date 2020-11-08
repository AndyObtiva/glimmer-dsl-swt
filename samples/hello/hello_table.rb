# Copyright (c) 2007-2020 Andy Maleh
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

class HelloTable
  class BaseballGame
    class << self
      def all_playoff_games
        {
          'NLDS' => [
            new(Time.new(2037, 10, 6, 12, 0),  'Chicago Cubs', 'Milwaukee Brewers', 5, 7),
            new(Time.new(2037, 10, 7, 12, 0),  'Chicago Cubs', 'Milwaukee Brewers', 11, 7),
            new(Time.new(2037, 10, 8, 12, 0),  'Milwaukee Brewers', 'Chicago Cubs', 2, 3),
            new(Time.new(2037, 10, 9, 12, 0),  'Milwaukee Brewers', 'Chicago Cubs', 1, 0),
            new(Time.new(2037, 10, 10, 12, 0), 'Milwaukee Brewers', 'Chicago Cubs', 9, 10),
            new(Time.new(2037, 10, 6, 18, 0),  'Cincinnati Reds', 'St Louis Cardinals', 2, 4),
            new(Time.new(2037, 10, 7, 18, 0),  'Cincinnati Reds', 'St Louis Cardinals', 5, 6),
            new(Time.new(2037, 10, 8, 18, 0),  'St Louis Cardinals', 'Cincinnati Reds', 0, 7),
            new(Time.new(2037, 10, 9, 18, 0),  'St Louis Cardinals', 'Cincinnati Reds', 3, 4),
            new(Time.new(2037, 10, 10, 18, 0), 'St Louis Cardinals', 'Cincinnati Reds', 11, 13),
          ],
          'ALDS' => [
            new(Time.new(2037, 10, 6, 12, 0),  'New York Yankees', 'Boston Red Sox', 4, 16),
            new(Time.new(2037, 10, 7, 12, 0),  'New York Yankees', 'Boston Red Sox', 9, 8),
            new(Time.new(2037, 10, 8, 12, 0),  'Boston Red Sox', 'New York Yankees', 2, 13),
            new(Time.new(2037, 10, 9, 12, 0),  'Boston Red Sox', 'New York Yankees', 1, 0),
            new(Time.new(2037, 10, 10, 12, 0), 'Boston Red Sox', 'New York Yankees', 10, 9),
            new(Time.new(2037, 10, 6, 18, 0),  'Houston Astros', 'Cleveland Indians', 4, 8),
            new(Time.new(2037, 10, 7, 18, 0),  'Houston Astros', 'Cleveland Indians', 2, 9),
            new(Time.new(2037, 10, 8, 18, 0),  'Cleveland Indians', 'Houston Astros', 1, 6),
            new(Time.new(2037, 10, 9, 18, 0),  'Cleveland Indians', 'Houston Astros', 6, 8),
            new(Time.new(2037, 10, 10, 18, 0), 'Cleveland Indians', 'Houston Astros', 5, 6),
          ],
          'NLCS' => [
            new(Time.new(2037, 10, 12, 12, 0), 'Chicago Cubs', 'Cincinnati Reds', 6, 8),
            new(Time.new(2037, 10, 13, 12, 0), 'Chicago Cubs', 'Cincinnati Reds', 12, 6),
            new(Time.new(2037, 10, 14, 12, 0), 'Cincinnati Reds', 'Chicago Cubs', 3, 4),
            new(Time.new(2037, 10, 15, 12, 0), 'Cincinnati Reds', 'Chicago Cubs', 2, 0),
            new(Time.new(2037, 10, 16, 12, 0), 'Cincinnati Reds', 'Chicago Cubs', 3, 10),
            new(Time.new(2037, 10, 17, 12, 0), 'Chicago Cubs', 'Cincinnati Reds', 6, 7),
            new(Time.new(2037, 10, 18, 12, 0), 'Chicago Cubs', 'Cincinnati Reds', 11, 5),
          ],
          'ALCS' => [
            new(Time.new(2037, 10, 12, 12, 0), 'Houston Astros', 'Boston Red Sox', 5, 7),
            new(Time.new(2037, 10, 13, 12, 0), 'Houston Astros', 'Boston Red Sox', 11, 7),
            new(Time.new(2037, 10, 14, 12, 0), 'Boston Red Sox', 'Houston Astros', 2, 3),
            new(Time.new(2037, 10, 15, 12, 0), 'Boston Red Sox', 'Houston Astros', 1, 0),
            new(Time.new(2037, 10, 16, 12, 0), 'Boston Red Sox', 'Houston Astros', 19, 10),
            new(Time.new(2037, 10, 17, 12, 0), 'Houston Astros', 'Boston Red Sox', 15, 7),
            new(Time.new(2037, 10, 18, 12, 0), 'Houston Astros', 'Boston Red Sox', 11, 17),
          ],
          'World Series' => [
            new(Time.new(2037, 10, 20, 12, 0), 'Chicago Cubs', 'Boston Red Sox', 0, 4),
            new(Time.new(2037, 10, 21, 12, 0), 'Chicago Cubs', 'Boston Red Sox', 4, 9),
            new(Time.new(2037, 10, 22, 12, 0), 'Boston Red Sox', 'Chicago Cubs', 12, 3),
            new(Time.new(2037, 10, 23, 12, 0), 'Boston Red Sox', 'Chicago Cubs', 10, 0),
            new(Time.new(2037, 10, 24, 12, 0), 'Boston Red Sox', 'Chicago Cubs', 0, 1),
            new(Time.new(2037, 10, 25, 12, 0), 'Chicago Cubs', 'Boston Red Sox', 15, 14),
            new(Time.new(2037, 10, 26, 12, 0), 'Chicago Cubs', 'Boston Red Sox', 11, 17),
          ]
        }
      end
    
      def playoff_type
        @playoff_type ||= 'NLDS'
      end
      
      def playoff_type=(new_playoff_type)
        @playoff_type = new_playoff_type
        self.schedule=(all_playoff_games[@playoff_type])
      end
      
      def playoff_type_options
        all_playoff_games.keys
      end
      
      def schedule
        @schedule ||= all_playoff_games[playoff_type]
      end
      
      def schedule=(new_schedule)
        @schedule = new_schedule
      end
      
    end
    
    include Glimmer
    include Glimmer::DataBinding::ObservableModel
    
    TEAM_BALLPARKS = {
      'Boston Red Sox'     => 'Fenway Park',
      'Chicago Cubs'       => 'Wrigley Field',
      'Cincinnati Reds'    => 'Great American Ball Park',
      'Cleveland Indians'  => 'Progressive Field',
      'Houston Astros'     => 'Minute Maid Park',
      'Milwaukee Brewers'  => 'Miller Park',
      'New York Yankees'   => 'Yankee Stadium',
      'St Louis Cardinals' => 'Busch Stadium',
    }
    
    attr_accessor :date_time, :home_team, :away_team, :ballpark, :home_team_runs, :away_team_runs
    
    def initialize(date_time, home_team, away_team, home_team_runs, away_team_runs)
      self.date_time = date_time
      self.home_team = home_team
      self.away_team = away_team
      self.home_team_runs = home_team_runs
      self.away_team_runs = away_team_runs
      observe(self, :date_time) do |new_value|
        notify_observers(:game_date)
        notify_observers(:game_time)
      end
    end
    
    def home_team=(home_team_value)
      if home_team_value != away_team
        @home_team = home_team_value
        self.ballpark = TEAM_BALLPARKS[@home_team]
      end
    end
    
    def away_team=(away_team_value)
      if away_team_value != home_team
        @away_team = away_team_value
      end
    end
    
    def date
      Date.new(date_time.year, date_time.month, date_time.day)
    end
    
    def time
      Time.new(0, 1, 1, date_time.hour, date_time.min, date_time.sec, '+00:00')
    end
    
    def game_date
      date_time.strftime("%m/%d/%Y")
    end
        
    def game_time
      date_time.strftime("%I:%M %p")
    end
        
    def home_team_options
      TEAM_BALLPARKS.keys
    end
    
    def away_team_options
      TEAM_BALLPARKS.keys
    end
  end

  include Glimmer
  
  def launch
    shell {
      grid_layout
      
      text 'Hello, Table!'
      
      label {
        layout_data :center, :center, true, false
        
        text 'Baseball Playoffs'
        font height: 30, style: :bold
      }
      
      combo(:read_only) {
        layout_data :center, :center, true, false
        selection bind(BaseballGame, :playoff_type)
        font height: 16
      }
      
      table(:editable) { |table_proxy|
        layout_data :fill, :fill, true, true
      
        table_column {
          text 'Game Date'
          width 150
          sort_property :date # ensure sorting by real date value (not `game_date_time` string specified in items below)
          editor :date_drop_down, property: :date_time
        }
        table_column {
          text 'Game Time'
          width 150
          sort_property :time # ensure sorting by real date value (not `game_date_time` string specified in items below)
          editor :time, property: :date_time
        }
        table_column {
          text 'Ballpark'
          width 180
          editor :none
        }
        table_column {
          text 'Home Team'
          width 150
          editor :combo, :read_only
        }
        table_column {
          text 'Runs'
          width 50
          editor :spinner
        }
        table_column {
          text 'Away Team'
          width 150
          editor :combo, :read_only
        }
        table_column {
          text 'Runs'
          width 50
          editor :spinner
        }
        
        # Data-bind table items (rows) to a model collection property, specifying column properties ordering per nested model
        items bind(BaseballGame, :schedule), column_properties(:game_date, :game_time, :ballpark, :home_team, :home_team_runs, :away_team, :away_team_runs)
        
        sort_property :date
        
        # Sort by these additional properties after handling sort by the column the user clicked
        additional_sort_properties :date, :time, :home_team, :away_team, :ballpark, :home_team_runs, :away_team_runs
      }
    }.open
  end
end

HelloTable.new.launch
