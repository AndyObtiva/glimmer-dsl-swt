# Copyright (c) 2007-2021 Andy Maleh
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

require 'glimmer/data_binding/observable_array'
require 'glimmer/data_binding/observable_model'
require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module DataBinding
    class TreeItemsBinding
      include DataBinding::Observable
      include DataBinding::Observer

      include_package 'org.eclipse.swt'
      include_package 'org.eclipse.swt.widgets'
      
      def initialize(parent, model_binding, tree_properties)
        @tree = parent
        @model_binding = model_binding
        @tree_properties = [tree_properties].flatten.first.to_h
        if @tree.respond_to?(:tree_properties=)
          @tree.tree_properties = @tree_properties
        else # assume custom widget
          @tree.body_root.tree_properties = @tree_properties
        end
        Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @model_binding.binding_options[:sync_exec], override_async_exec: @model_binding.binding_options[:async_exec]) do
          call
          model = model_binding.base_model
          observe(model, model_binding.property_name_expression)
          @tree.on_widget_disposed do |dispose_event|
            unregister_all_observables
          end
        end
      end

      def call(new_value=nil)
        Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @model_binding.binding_options[:sync_exec], override_async_exec: @model_binding.binding_options[:async_exec]) do
          @model_tree_root_node = @model_binding.evaluate_property
          old_tree_items = @tree.all_tree_items
          old_model_tree_nodes = old_tree_items.map(&:get_data)
          new_model_tree_nodes = []
          recursive_depth_first_search(@model_tree_root_node, @tree_properties, new_model_tree_nodes)
          return if old_model_tree_nodes == new_model_tree_nodes && old_tree_items.map(&:text) == new_model_tree_nodes.map {|model_tree_node| model_tree_node.send(@tree_properties[:text])}
          populate_tree(@model_tree_root_node, @tree, @tree_properties)
        end
      end

      def populate_tree(model_tree_root_node, parent, tree_properties)
        # TODO get rid of model_tree_root_node, parent, tree_properties as an argument given it is stored as an instance variable
        # TODO make it change things by delta instead of removing all
        old_tree_items = parent.all_tree_items
        selected_tree_item_models = parent.swt_widget.getSelection.map(&:get_data)
        old_tree_item_expansion_by_data = old_tree_items.reduce({}) {|hash, ti| hash.merge(ti.getData => ti.getExpanded)}
        old_tree_items.each do |tree_item|
          tree_item.getData('observer_registrations').each(&:unregister)
        end
        parent.swt_widget.items.each(&:dispose)
        parent.swt_widget.removeAll
        populate_tree_node(model_tree_root_node, parent.swt_widget, tree_properties)
        parent.all_tree_items.each { |ti| ti.setExpanded(!!old_tree_item_expansion_by_data[ti.getData]) }
        selected_tree_items = parent.depth_first_search {|item| selected_tree_item_models.include?(item.get_data) }
        parent.swt_widget.setSelection(selected_tree_items)
      end

      def populate_tree_node(model_tree_node, parent, tree_properties)
        return if model_tree_node.nil?
        tree_item = TreeItem.new(parent, SWT::SWTProxy[:none])
        observer_registrations = @tree_properties.reduce([]) do |array, key_value_pair|
          array + [observe(model_tree_node, key_value_pair.last)]
        end
        
        tree_item.set_data('observer_registrations', observer_registrations)
        tree_item.set_data(model_tree_node)
        tree_item.text = (model_tree_node && model_tree_node.send(tree_properties[:text])).to_s
        [model_tree_node && model_tree_node.send(tree_properties[:children])].flatten.to_a.compact.each do |child|
          populate_tree_node(child, tree_item, tree_properties)
        end
      end
      
      def recursive_depth_first_search(model_tree_node, tree_properties, collection)
        return if model_tree_node.nil?
        collection << model_tree_node
        model_tree_node.send(tree_properties[:children]).to_a.each do |child_model_tree_node|
          recursive_depth_first_search(child_model_tree_node, tree_properties, collection)
        end
      end
      
    end
    
  end
  
end
