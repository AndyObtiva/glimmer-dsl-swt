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
      def schedule
        @schedule ||= [
          new('Chicago Cubs', 'Milwaukee Brewers', Time.new(2037, 10, 6, 12, 0)),
          new('Chicago Cubs', 'Milwaukee Brewers', Time.new(2037, 10, 7, 12, 0)),
          new('Milwaukee Brewers', 'Chicago Cubs', Time.new(2037, 10, 8, 12, 0)),
          new('Milwaukee Brewers', 'Chicago Cubs', Time.new(2037, 10, 9, 12, 0)),
          new('Milwaukee Brewers', 'Chicago Cubs', Time.new(2037, 10, 10, 12, 0)),
          new('Chicago White Sox', 'St Louis Cardinals', Time.new(2037, 10, 6, 18, 0)),
          new('Chicago White Sox', 'St Louis Cardinals', Time.new(2037, 10, 7, 18, 0)),
          new('St Louis Cardinals', 'Chicago White Sox', Time.new(2037, 10, 8, 18, 0)),
          new('St Louis Cardinals', 'Chicago White Sox', Time.new(2037, 10, 9, 18, 0)),
          new('St Louis Cardinals', 'Chicago White Sox', Time.new(2037, 10, 10, 18, 0)),
        ]
      end
      
      def schedule=(new_schedule)
        @schedule = new_schedule
      end
    end
    
    include Glimmer::DataBinding::ObservableModel
    
    TEAM_BALLPARKS = {
      'Chicago Cubs'       => 'Wrigley Field',
      'Chicago White Sox'  => 'Guaranteed Rate Field',
      'Milwaukee Brewers'  => 'Miller Park',
      'St Louis Cardinals' => 'Busch Stadium'
    }
    
    attr_accessor :home_team, :away_team, :date_time, :ballpark
    
    def initialize(home_team, away_team, date_time)
      self.home_team = home_team
      self.away_team = away_team
      self.date_time = date_time
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
    
    def game_date_time
      date_time.strftime("%Y-%m-%d %I:%M %p")
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
      text 'Hello, Table!'
      # TODO label for  (Baseball Game Schedule)
      # TODO combo for selecting nlds, nlcs, alds, alcs, world series
      table { |table_proxy|
        table_column {
          text 'Game Date/Time'
          width 150
          editor :date_time, property: :date_time
          sort_property :date_time # ensure sorting by real date value (not `game_date_time` string specified in items below)
        }
        table_column {
          text 'Home Team'
          width 150
          editor :combo, :read_only
        }
        table_column {
          text 'Away Team'
          width 150
          editor :combo, :read_only
        }
        table_column {
          text 'Ballpark'
          width 150
          editor :none
        }
        
        # Data-bind table items (rows) to a model collection property, specifying column properties ordering per nested model
        items bind(BaseballGame, :schedule), column_properties(:game_date_time, :home_team, :away_team, :ballpark)
        
        # Sort by these additional properties after handling the main column sort the user selected
        additional_sort_properties :date_time, :home_team, :away_team, :ballpark
        
        on_mouse_up { |event|
          table_proxy.edit_table_item(event.table_item, event.column_index)
        }
      }
    }.open
  end
end

HelloTable.new.launch
