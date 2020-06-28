require 'facets'
require 'text-table'

module Glimmer
  module RakeTask
    # Lists Glimmer related gems to use in rake_task.rb
    class List
      class << self
        REGEX_GEM_LINE = /^([^\(]+) \(([^\)]+)\)$/
        
        def custom_widget_gems(query=nil)
          list_gems('glimmer-cw-', query) do |result|
            puts
            puts "  Glimmer Custom Widget Gems#{" matching [#{query}]" if query} at rubygems.org:"
            puts result
          end
        end

        def custom_shell_gems(query=nil)
          list_gems('glimmer-cs-', query) do |result|
            puts
            puts "  Glimmer Custom Shell Gems#{" matching [#{query}]" if query} at rubygems.org:"
            puts result
          end
        end

        def dsl_gems(query=nil)
          list_gems('glimmer-dsl-', query) do |result|
            puts
            puts "  Glimmer DSL Gems#{" matching [#{query}]" if query} at rubygems.org:"
            puts result
          end
        end
        
        def list_gems(gem_prefix, query=nil, &printer)
          lines = `gem search -d #{gem_prefix}`.split("\n")
          gems = lines.slice_before {|l| l.match(REGEX_GEM_LINE) }.to_a
          gems = gems.map do |gem|
            {            
              name: gem[0].match(REGEX_GEM_LINE)[1],
              version: gem[0].match(REGEX_GEM_LINE)[2],
              author: gem[1].strip,
              description: gem[4..-1].map(&:strip).join(' ')
            }
          end.select do |gem|
            query.nil? || "#{gem[:name]} #{gem[:author]} #{gem[:description]}".downcase.include?(query.to_s.downcase)
          end
          printer.call(tablify(gem_prefix, gems))
        end
        
        def tablify(gem_prefix, gems)
          array_of_arrays = gems.map do |gem|
            [
              gem[:name].sub(gem_prefix, '').underscore.titlecase,
              gem[:name],
              gem[:version],
              gem[:author].sub('Author: ', ''),
              gem[:description],
            ]
          end
          Text::Table.new(
            :head => %w[Name Gem Version Author Description],
            :rows => array_of_arrays,
            :horizontal_padding    => 1,
            :vertical_boundary     => ' ',
            :horizontal_boundary   => ' ',
            :boundary_intersection => ' '
          )
        end
      end
    end
  end
end
