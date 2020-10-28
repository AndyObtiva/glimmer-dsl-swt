# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: glimmer-dsl-swt 4.17.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "glimmer-dsl-swt".freeze
  s.version = "4.17.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["AndyMaleh".freeze]
  s.date = "2020-10-28"
  s.description = "Glimmer DSL for SWT (JRuby Desktop Development GUI Library)".freeze
  s.email = "andy.am@gmail.com".freeze
  s.executables = ["glimmer".freeze, "girb".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md",
    "RUBY_VERSION",
    "VERSION",
    "bin/girb",
    "bin/girb_runner.rb",
    "bin/glimmer",
    "glimmer-dsl-swt.gemspec",
    "icons/scaffold_app.icns",
    "icons/scaffold_app.ico",
    "icons/scaffold_app.png",
    "lib/ext/glimmer.rb",
    "lib/ext/glimmer/config.rb",
    "lib/glimmer-dsl-swt.rb",
    "lib/glimmer/Rakefile",
    "lib/glimmer/data_binding/list_selection_binding.rb",
    "lib/glimmer/data_binding/observable_widget.rb",
    "lib/glimmer/data_binding/shine.rb",
    "lib/glimmer/data_binding/table_items_binding.rb",
    "lib/glimmer/data_binding/tree_items_binding.rb",
    "lib/glimmer/data_binding/widget_binding.rb",
    "lib/glimmer/dsl/swt/async_exec_expression.rb",
    "lib/glimmer/dsl/swt/bind_expression.rb",
    "lib/glimmer/dsl/swt/block_property_expression.rb",
    "lib/glimmer/dsl/swt/color_expression.rb",
    "lib/glimmer/dsl/swt/column_properties_expression.rb",
    "lib/glimmer/dsl/swt/combo_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/cursor_expression.rb",
    "lib/glimmer/dsl/swt/custom_widget_expression.rb",
    "lib/glimmer/dsl/swt/data_binding_expression.rb",
    "lib/glimmer/dsl/swt/dialog_expression.rb",
    "lib/glimmer/dsl/swt/display_expression.rb",
    "lib/glimmer/dsl/swt/dnd_expression.rb",
    "lib/glimmer/dsl/swt/dsl.rb",
    "lib/glimmer/dsl/swt/exec_expression.rb",
    "lib/glimmer/dsl/swt/expand_item_expression.rb",
    "lib/glimmer/dsl/swt/font_expression.rb",
    "lib/glimmer/dsl/swt/image_expression.rb",
    "lib/glimmer/dsl/swt/layout_data_expression.rb",
    "lib/glimmer/dsl/swt/layout_expression.rb",
    "lib/glimmer/dsl/swt/list_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/menu_bar_expression.rb",
    "lib/glimmer/dsl/swt/menu_expression.rb",
    "lib/glimmer/dsl/swt/message_box_expression.rb",
    "lib/glimmer/dsl/swt/observe_expression.rb",
    "lib/glimmer/dsl/swt/property_expression.rb",
    "lib/glimmer/dsl/swt/radio_group_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/rgb_expression.rb",
    "lib/glimmer/dsl/swt/rgba_expression.rb",
    "lib/glimmer/dsl/swt/shell_expression.rb",
    "lib/glimmer/dsl/swt/swt_expression.rb",
    "lib/glimmer/dsl/swt/sync_exec_expression.rb",
    "lib/glimmer/dsl/swt/tab_item_expression.rb",
    "lib/glimmer/dsl/swt/table_items_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/tree_items_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/tree_properties_expression.rb",
    "lib/glimmer/dsl/swt/widget_expression.rb",
    "lib/glimmer/dsl/swt/widget_listener_expression.rb",
    "lib/glimmer/launcher.rb",
    "lib/glimmer/rake_task.rb",
    "lib/glimmer/rake_task/list.rb",
    "lib/glimmer/rake_task/package.rb",
    "lib/glimmer/rake_task/scaffold.rb",
    "lib/glimmer/swt/color_proxy.rb",
    "lib/glimmer/swt/cursor_proxy.rb",
    "lib/glimmer/swt/custom/code_text.rb",
    "lib/glimmer/swt/custom/radio_group.rb",
    "lib/glimmer/swt/display_proxy.rb",
    "lib/glimmer/swt/dnd_proxy.rb",
    "lib/glimmer/swt/expand_item_proxy.rb",
    "lib/glimmer/swt/font_proxy.rb",
    "lib/glimmer/swt/image_proxy.rb",
    "lib/glimmer/swt/layout_data_proxy.rb",
    "lib/glimmer/swt/layout_proxy.rb",
    "lib/glimmer/swt/menu_proxy.rb",
    "lib/glimmer/swt/message_box_proxy.rb",
    "lib/glimmer/swt/packages.rb",
    "lib/glimmer/swt/sash_form_proxy.rb",
    "lib/glimmer/swt/scrolled_composite_proxy.rb",
    "lib/glimmer/swt/shell_proxy.rb",
    "lib/glimmer/swt/style_constantizable.rb",
    "lib/glimmer/swt/styled_text_proxy.rb",
    "lib/glimmer/swt/swt_proxy.rb",
    "lib/glimmer/swt/tab_item_proxy.rb",
    "lib/glimmer/swt/table_column_proxy.rb",
    "lib/glimmer/swt/table_proxy.rb",
    "lib/glimmer/swt/tree_proxy.rb",
    "lib/glimmer/swt/widget_listener_proxy.rb",
    "lib/glimmer/swt/widget_proxy.rb",
    "lib/glimmer/ui/custom_shell.rb",
    "lib/glimmer/ui/custom_widget.rb",
    "lib/glimmer/util/proc_tracker.rb",
    "samples/elaborate/contact_manager.rb",
    "samples/elaborate/contact_manager/contact.rb",
    "samples/elaborate/contact_manager/contact_manager_presenter.rb",
    "samples/elaborate/contact_manager/contact_repository.rb",
    "samples/elaborate/login.rb",
    "samples/elaborate/meta_sample.rb",
    "samples/elaborate/tic_tac_toe.rb",
    "samples/elaborate/tic_tac_toe/board.rb",
    "samples/elaborate/tic_tac_toe/cell.rb",
    "samples/elaborate/user_profile.rb",
    "samples/hello/hello_browser.rb",
    "samples/hello/hello_checkbox.rb",
    "samples/hello/hello_combo.rb",
    "samples/hello/hello_computed.rb",
    "samples/hello/hello_computed/contact.rb",
    "samples/hello/hello_custom_shell.rb",
    "samples/hello/hello_custom_widget.rb",
    "samples/hello/hello_drag_and_drop.rb",
    "samples/hello/hello_expand_bar.rb",
    "samples/hello/hello_list_multi_selection.rb",
    "samples/hello/hello_list_single_selection.rb",
    "samples/hello/hello_menu_bar.rb",
    "samples/hello/hello_message_box.rb",
    "samples/hello/hello_pop_up_context_menu.rb",
    "samples/hello/hello_radio.rb",
    "samples/hello/hello_radio_group.rb",
    "samples/hello/hello_sash_form.rb",
    "samples/hello/hello_styled_text.rb",
    "samples/hello/hello_tab.rb",
    "samples/hello/hello_world.rb",
    "vendor/swt/linux/swt.jar",
    "vendor/swt/mac/swt.jar",
    "vendor/swt/windows/swt.jar"
  ]
  s.homepage = "http://github.com/AndyObtiva/glimmer-dsl-swt".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.3".freeze)
  s.rubygems_version = "3.1.4".freeze
  s.summary = "Glimmer DSL for SWT".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<glimmer>.freeze, ["~> 1.0.2"])
    s.add_runtime_dependency(%q<super_module>.freeze, ["~> 1.4.1"])
    s.add_runtime_dependency(%q<nested_inherited_jruby_include_package>.freeze, ["~> 0.3.0"])
    s.add_runtime_dependency(%q<puts_debuggerer>.freeze, ["~> 0.10.2"])
    s.add_runtime_dependency(%q<rake-tui>.freeze, [">= 0.2.3", "< 2.0.0"])
    s.add_runtime_dependency(%q<git-glimmer>.freeze, ["= 1.7.0"])
    s.add_runtime_dependency(%q<logging>.freeze, [">= 2.3.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<os>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<rake>.freeze, [">= 10.1.0", "< 14.0.0"])
    s.add_runtime_dependency(%q<text-table>.freeze, [">= 1.2.4", "< 2.0.0"])
    s.add_runtime_dependency(%q<rouge>.freeze, [">= 3.23.0", "< 4.0.0"])
    s.add_development_dependency(%q<juwelier>.freeze, [">= 2.4.9", "< 3.0.0"])
    s.add_development_dependency(%q<warbler>.freeze, [">= 2.0.5", "< 3.0.0"])
    s.add_development_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_development_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
    s.add_development_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
  else
    s.add_dependency(%q<glimmer>.freeze, ["~> 1.0.2"])
    s.add_dependency(%q<super_module>.freeze, ["~> 1.4.1"])
    s.add_dependency(%q<nested_inherited_jruby_include_package>.freeze, ["~> 0.3.0"])
    s.add_dependency(%q<puts_debuggerer>.freeze, ["~> 0.10.2"])
    s.add_dependency(%q<rake-tui>.freeze, [">= 0.2.3", "< 2.0.0"])
    s.add_dependency(%q<git-glimmer>.freeze, ["= 1.7.0"])
    s.add_dependency(%q<logging>.freeze, [">= 2.3.0", "< 3.0.0"])
    s.add_dependency(%q<os>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 10.1.0", "< 14.0.0"])
    s.add_dependency(%q<text-table>.freeze, [">= 1.2.4", "< 2.0.0"])
    s.add_dependency(%q<rouge>.freeze, [">= 3.23.0", "< 4.0.0"])
    s.add_dependency(%q<juwelier>.freeze, [">= 2.4.9", "< 3.0.0"])
    s.add_dependency(%q<warbler>.freeze, [">= 2.0.5", "< 3.0.0"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
    s.add_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
  end
end

