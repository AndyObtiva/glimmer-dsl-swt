# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: glimmer-dsl-swt 4.25.0.1 ruby lib bin

Gem::Specification.new do |s|
  s.name = "glimmer-dsl-swt".freeze
  s.version = "4.25.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "bin".freeze]
  s.authors = ["Andy Maleh".freeze]
  s.date = "2022-10-02"
  s.description = "Glimmer DSL for SWT (JRuby Desktop Development GUI Framework) is a native-GUI cross-platform desktop development library written in JRuby, an OS-threaded faster JVM version of Ruby. It includes SWT 4.25 (released 31 Aug 2022). Glimmer's main innovation is a declarative Ruby DSL that enables productive and efficient authoring of desktop application user-interfaces by relying on the robust Eclipse SWT library. Glimmer additionally innovates by having built-in data-binding support, which greatly facilitates synchronizing the GUI with domain models, thus achieving true decoupling of object oriented components and enabling developers to solve business problems (test-first) without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models (test-first) afterwards. Not only does Glimmer provide a large set of GUI widgets, but it also supports drawing Canvas Graphics like Shapes and Animations. To get started quickly, Glimmer offers scaffolding options for Apps, Gems, and Custom Widgets. Glimmer also includes native-executable packaging support, sorely lacking in other libraries, thus enabling the delivery of desktop apps written in Ruby as truly native DMG/PKG/APP files on the Mac, MSI/EXE files on Windows, and DEB/RPM files on Linux. Glimmer was the first Ruby gem to bring SWT (Standard Widget Toolkit) to Ruby, thanks to creator Andy Maleh, EclipseCon/EclipseWorld/RubyConf speaker.".freeze
  s.email = "andy.am@gmail.com".freeze
  s.executables = ["glimmer".freeze, "girb".freeze, "glimmer-setup".freeze]
  s.extra_rdoc_files = [
    "README.md",
    "docs/reference/GLIMMER_COMMAND.md",
    "docs/reference/GLIMMER_CONFIGURATION.md",
    "docs/reference/GLIMMER_GIRB.md",
    "docs/reference/GLIMMER_GUI_DSL_SYNTAX.md",
    "docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md",
    "docs/reference/GLIMMER_SAMPLES.md",
    "docs/reference/GLIMMER_STYLE_GUIDE.md"
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
    "bin/glimmer-setup",
    "docs/reference/GLIMMER_COMMAND.md",
    "docs/reference/GLIMMER_CONFIGURATION.md",
    "docs/reference/GLIMMER_GIRB.md",
    "docs/reference/GLIMMER_GUI_DSL_SYNTAX.md",
    "docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md",
    "docs/reference/GLIMMER_SAMPLES.md",
    "docs/reference/GLIMMER_STYLE_GUIDE.md",
    "glimmer-dsl-swt.gemspec",
    "icons/scaffold_app.icns",
    "icons/scaffold_app.ico",
    "icons/scaffold_app.png",
    "lib/ext/glimmer.rb",
    "lib/ext/glimmer/config.rb",
    "lib/ext/rouge/themes/glimmer.rb",
    "lib/ext/rouge/themes/glimmer_dark.rb",
    "lib/glimmer-dsl-swt.rb",
    "lib/glimmer/Rakefile",
    "lib/glimmer/data_binding/list_selection_binding.rb",
    "lib/glimmer/data_binding/observable_widget.rb",
    "lib/glimmer/data_binding/table_items_binding.rb",
    "lib/glimmer/data_binding/tree_items_binding.rb",
    "lib/glimmer/data_binding/widget_binding.rb",
    "lib/glimmer/dsl/swt/animation_expression.rb",
    "lib/glimmer/dsl/swt/async_exec_expression.rb",
    "lib/glimmer/dsl/swt/auto_exec_expression.rb",
    "lib/glimmer/dsl/swt/bind_expression.rb",
    "lib/glimmer/dsl/swt/block_property_expression.rb",
    "lib/glimmer/dsl/swt/c_tab_item_expression.rb",
    "lib/glimmer/dsl/swt/checkbox_group_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/color_expression.rb",
    "lib/glimmer/dsl/swt/column_properties_expression.rb",
    "lib/glimmer/dsl/swt/combo_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/cursor_expression.rb",
    "lib/glimmer/dsl/swt/custom_shape_expression.rb",
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
    "lib/glimmer/dsl/swt/listener_expression.rb",
    "lib/glimmer/dsl/swt/menu_bar_expression.rb",
    "lib/glimmer/dsl/swt/menu_expression.rb",
    "lib/glimmer/dsl/swt/message_box_expression.rb",
    "lib/glimmer/dsl/swt/multiply_expression.rb",
    "lib/glimmer/dsl/swt/observe_expression.rb",
    "lib/glimmer/dsl/swt/pixel_expression.rb",
    "lib/glimmer/dsl/swt/property_expression.rb",
    "lib/glimmer/dsl/swt/radio_group_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/rgb_expression.rb",
    "lib/glimmer/dsl/swt/rgba_expression.rb",
    "lib/glimmer/dsl/swt/shape_expression.rb",
    "lib/glimmer/dsl/swt/shell_expression.rb",
    "lib/glimmer/dsl/swt/shine_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/swt_expression.rb",
    "lib/glimmer/dsl/swt/sync_call_expression.rb",
    "lib/glimmer/dsl/swt/sync_exec_expression.rb",
    "lib/glimmer/dsl/swt/tab_item_expression.rb",
    "lib/glimmer/dsl/swt/table_items_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/timer_exec_expression.rb",
    "lib/glimmer/dsl/swt/transform_expression.rb",
    "lib/glimmer/dsl/swt/tray_expression.rb",
    "lib/glimmer/dsl/swt/tray_item_expression.rb",
    "lib/glimmer/dsl/swt/tree_items_data_binding_expression.rb",
    "lib/glimmer/dsl/swt/tree_properties_expression.rb",
    "lib/glimmer/dsl/swt/widget_expression.rb",
    "lib/glimmer/launcher.rb",
    "lib/glimmer/rake_task.rb",
    "lib/glimmer/rake_task/list.rb",
    "lib/glimmer/rake_task/package.rb",
    "lib/glimmer/rake_task/scaffold.rb",
    "lib/glimmer/swt/c_tab_item_proxy.rb",
    "lib/glimmer/swt/color_proxy.rb",
    "lib/glimmer/swt/combo_proxy.rb",
    "lib/glimmer/swt/cursor_proxy.rb",
    "lib/glimmer/swt/custom/animation.rb",
    "lib/glimmer/swt/custom/checkbox_group.rb",
    "lib/glimmer/swt/custom/code_text.rb",
    "lib/glimmer/swt/custom/drawable.rb",
    "lib/glimmer/swt/custom/radio_group.rb",
    "lib/glimmer/swt/custom/refined_table.rb",
    "lib/glimmer/swt/custom/shape.rb",
    "lib/glimmer/swt/custom/shape/arc.rb",
    "lib/glimmer/swt/custom/shape/cubic.rb",
    "lib/glimmer/swt/custom/shape/focus.rb",
    "lib/glimmer/swt/custom/shape/image.rb",
    "lib/glimmer/swt/custom/shape/line.rb",
    "lib/glimmer/swt/custom/shape/oval.rb",
    "lib/glimmer/swt/custom/shape/path.rb",
    "lib/glimmer/swt/custom/shape/path_segment.rb",
    "lib/glimmer/swt/custom/shape/point.rb",
    "lib/glimmer/swt/custom/shape/polygon.rb",
    "lib/glimmer/swt/custom/shape/polyline.rb",
    "lib/glimmer/swt/custom/shape/quad.rb",
    "lib/glimmer/swt/custom/shape/rectangle.rb",
    "lib/glimmer/swt/custom/shape/text.rb",
    "lib/glimmer/swt/date_time_proxy.rb",
    "lib/glimmer/swt/dialog_proxy.rb",
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
    "lib/glimmer/swt/properties.rb",
    "lib/glimmer/swt/proxy_properties.rb",
    "lib/glimmer/swt/sash_form_proxy.rb",
    "lib/glimmer/swt/scrolled_composite_proxy.rb",
    "lib/glimmer/swt/shape_listener_proxy.rb",
    "lib/glimmer/swt/shell_proxy.rb",
    "lib/glimmer/swt/style_constantizable.rb",
    "lib/glimmer/swt/styled_text_proxy.rb",
    "lib/glimmer/swt/swt_proxy.rb",
    "lib/glimmer/swt/tab_folder_proxy.rb",
    "lib/glimmer/swt/tab_item_proxy.rb",
    "lib/glimmer/swt/table_column_proxy.rb",
    "lib/glimmer/swt/table_proxy.rb",
    "lib/glimmer/swt/tool_bar_proxy.rb",
    "lib/glimmer/swt/transform_proxy.rb",
    "lib/glimmer/swt/tray_item_proxy.rb",
    "lib/glimmer/swt/tray_proxy.rb",
    "lib/glimmer/swt/tree_proxy.rb",
    "lib/glimmer/swt/widget_listener_proxy.rb",
    "lib/glimmer/swt/widget_proxy.rb",
    "lib/glimmer/ui.rb",
    "lib/glimmer/ui/custom_shape.rb",
    "lib/glimmer/ui/custom_shell.rb",
    "lib/glimmer/ui/custom_widget.rb",
    "lib/glimmer/util/proc_tracker.rb",
    "samples/elaborate/battleship.rb",
    "samples/elaborate/battleship/model/cell.rb",
    "samples/elaborate/battleship/model/game.rb",
    "samples/elaborate/battleship/model/grid.rb",
    "samples/elaborate/battleship/model/ship.rb",
    "samples/elaborate/battleship/model/ship_collection.rb",
    "samples/elaborate/battleship/view/action_panel.rb",
    "samples/elaborate/battleship/view/cell.rb",
    "samples/elaborate/battleship/view/grid.rb",
    "samples/elaborate/battleship/view/ship.rb",
    "samples/elaborate/battleship/view/ship_collection.rb",
    "samples/elaborate/calculator.rb",
    "samples/elaborate/calculator/model/command.rb",
    "samples/elaborate/calculator/model/command/all_clear.rb",
    "samples/elaborate/calculator/model/command/command_history.rb",
    "samples/elaborate/calculator/model/command/equals.rb",
    "samples/elaborate/calculator/model/command/number.rb",
    "samples/elaborate/calculator/model/command/operation.rb",
    "samples/elaborate/calculator/model/command/operation/add.rb",
    "samples/elaborate/calculator/model/command/operation/divide.rb",
    "samples/elaborate/calculator/model/command/operation/multiply.rb",
    "samples/elaborate/calculator/model/command/operation/subtract.rb",
    "samples/elaborate/calculator/model/command/point.rb",
    "samples/elaborate/calculator/model/presenter.rb",
    "samples/elaborate/clock.rb",
    "samples/elaborate/connect4.rb",
    "samples/elaborate/connect4/model/grid.rb",
    "samples/elaborate/connect4/model/slot.rb",
    "samples/elaborate/contact_manager.rb",
    "samples/elaborate/contact_manager/contact.rb",
    "samples/elaborate/contact_manager/contact_manager_presenter.rb",
    "samples/elaborate/contact_manager/contact_repository.rb",
    "samples/elaborate/game_of_life.rb",
    "samples/elaborate/game_of_life/model/cell.rb",
    "samples/elaborate/game_of_life/model/grid.rb",
    "samples/elaborate/klondike_solitaire.rb",
    "samples/elaborate/klondike_solitaire/model/column_pile.rb",
    "samples/elaborate/klondike_solitaire/model/dealing_pile.rb",
    "samples/elaborate/klondike_solitaire/model/dealt_pile.rb",
    "samples/elaborate/klondike_solitaire/model/foundation_pile.rb",
    "samples/elaborate/klondike_solitaire/model/game.rb",
    "samples/elaborate/klondike_solitaire/model/playing_card.rb",
    "samples/elaborate/klondike_solitaire/view/action_panel.rb",
    "samples/elaborate/klondike_solitaire/view/column_pile.rb",
    "samples/elaborate/klondike_solitaire/view/dealing_pile.rb",
    "samples/elaborate/klondike_solitaire/view/dealt_pile.rb",
    "samples/elaborate/klondike_solitaire/view/empty_playing_card.rb",
    "samples/elaborate/klondike_solitaire/view/foundation_pile.rb",
    "samples/elaborate/klondike_solitaire/view/hidden_playing_card.rb",
    "samples/elaborate/klondike_solitaire/view/klondike_solitaire_menu_bar.rb",
    "samples/elaborate/klondike_solitaire/view/playing_card.rb",
    "samples/elaborate/klondike_solitaire/view/tableau.rb",
    "samples/elaborate/login.rb",
    "samples/elaborate/mandelbrot_fractal.rb",
    "samples/elaborate/meta_sample.rb",
    "samples/elaborate/meta_sample/tutorials.yml",
    "samples/elaborate/metronome.rb",
    "samples/elaborate/parking.rb",
    "samples/elaborate/parking/model/parking_floor.rb",
    "samples/elaborate/parking/model/parking_presenter.rb",
    "samples/elaborate/parking/model/parking_spot.rb",
    "samples/elaborate/quarto.rb",
    "samples/elaborate/quarto/model/game.rb",
    "samples/elaborate/quarto/model/piece.rb",
    "samples/elaborate/quarto/model/piece/cube.rb",
    "samples/elaborate/quarto/model/piece/cylinder.rb",
    "samples/elaborate/quarto/view/available_pieces_area.rb",
    "samples/elaborate/quarto/view/board.rb",
    "samples/elaborate/quarto/view/cell.rb",
    "samples/elaborate/quarto/view/cube.rb",
    "samples/elaborate/quarto/view/cylinder.rb",
    "samples/elaborate/quarto/view/message_box_panel.rb",
    "samples/elaborate/quarto/view/piece.rb",
    "samples/elaborate/quarto/view/selected_piece_area.rb",
    "samples/elaborate/snake.rb",
    "samples/elaborate/snake/model/apple.rb",
    "samples/elaborate/snake/model/game.rb",
    "samples/elaborate/snake/model/snake.rb",
    "samples/elaborate/snake/model/vertebra.rb",
    "samples/elaborate/snake/presenter/cell.rb",
    "samples/elaborate/snake/presenter/grid.rb",
    "samples/elaborate/stock_ticker.rb",
    "samples/elaborate/tetris.rb",
    "samples/elaborate/tetris/model/block.rb",
    "samples/elaborate/tetris/model/game.rb",
    "samples/elaborate/tetris/model/past_game.rb",
    "samples/elaborate/tetris/model/tetromino.rb",
    "samples/elaborate/tetris/view/bevel.rb",
    "samples/elaborate/tetris/view/block.rb",
    "samples/elaborate/tetris/view/high_score_dialog.rb",
    "samples/elaborate/tetris/view/playfield.rb",
    "samples/elaborate/tetris/view/score_lane.rb",
    "samples/elaborate/tetris/view/tetris_menu_bar.rb",
    "samples/elaborate/tic_tac_toe.rb",
    "samples/elaborate/tic_tac_toe/board.rb",
    "samples/elaborate/tic_tac_toe/cell.rb",
    "samples/elaborate/timer.rb",
    "samples/elaborate/timer/sounds/alarm1.wav",
    "samples/elaborate/user_profile.rb",
    "samples/elaborate/weather.rb",
    "samples/hello/hello_arrow.rb",
    "samples/hello/hello_browser.rb",
    "samples/hello/hello_button.rb",
    "samples/hello/hello_c_combo.rb",
    "samples/hello/hello_c_tab.rb",
    "samples/hello/hello_canvas.rb",
    "samples/hello/hello_canvas_animation.rb",
    "samples/hello/hello_canvas_animation_multi.rb",
    "samples/hello/hello_canvas_data_binding.rb",
    "samples/hello/hello_canvas_drag_and_drop.rb",
    "samples/hello/hello_canvas_path.rb",
    "samples/hello/hello_canvas_shape_listeners.rb",
    "samples/hello/hello_canvas_transform.rb",
    "samples/hello/hello_checkbox.rb",
    "samples/hello/hello_checkbox_group.rb",
    "samples/hello/hello_code_text.rb",
    "samples/hello/hello_color_dialog.rb",
    "samples/hello/hello_combo.rb",
    "samples/hello/hello_composite.rb",
    "samples/hello/hello_computed.rb",
    "samples/hello/hello_cool_bar.rb",
    "samples/hello/hello_cursor.rb",
    "samples/hello/hello_custom_shape.rb",
    "samples/hello/hello_custom_shell.rb",
    "samples/hello/hello_custom_widget.rb",
    "samples/hello/hello_date_time.rb",
    "samples/hello/hello_dialog.rb",
    "samples/hello/hello_directory_dialog.rb",
    "samples/hello/hello_drag_and_drop.rb",
    "samples/hello/hello_expand_bar.rb",
    "samples/hello/hello_file_dialog.rb",
    "samples/hello/hello_font_dialog.rb",
    "samples/hello/hello_group.rb",
    "samples/hello/hello_label.rb",
    "samples/hello/hello_layout.rb",
    "samples/hello/hello_link.rb",
    "samples/hello/hello_list_multi_selection.rb",
    "samples/hello/hello_list_single_selection.rb",
    "samples/hello/hello_menu_bar.rb",
    "samples/hello/hello_message_box.rb",
    "samples/hello/hello_pop_up_context_menu.rb",
    "samples/hello/hello_print.rb",
    "samples/hello/hello_print_dialog.rb",
    "samples/hello/hello_progress_bar.rb",
    "samples/hello/hello_radio.rb",
    "samples/hello/hello_radio_group.rb",
    "samples/hello/hello_refined_table.rb",
    "samples/hello/hello_sash_form.rb",
    "samples/hello/hello_scale.rb",
    "samples/hello/hello_scrolled_composite.rb",
    "samples/hello/hello_shape.rb",
    "samples/hello/hello_shell.rb",
    "samples/hello/hello_slider.rb",
    "samples/hello/hello_spinner.rb",
    "samples/hello/hello_styled_text.rb",
    "samples/hello/hello_tab.rb",
    "samples/hello/hello_table.rb",
    "samples/hello/hello_table/baseball_park.png",
    "samples/hello/hello_text.rb",
    "samples/hello/hello_toggle.rb",
    "samples/hello/hello_tool_bar.rb",
    "samples/hello/hello_tray_item.rb",
    "samples/hello/hello_tree.rb",
    "samples/hello/hello_world.rb",
    "samples/hello/images/copy.png",
    "samples/hello/images/cut.png",
    "samples/hello/images/denmark.png",
    "samples/hello/images/finland.png",
    "samples/hello/images/france.png",
    "samples/hello/images/germany.png",
    "samples/hello/images/italy.png",
    "samples/hello/images/mexico.png",
    "samples/hello/images/netherlands.png",
    "samples/hello/images/norway.png",
    "samples/hello/images/paste.png",
    "samples/hello/images/usa.png",
    "sounds/metronome-down.wav",
    "sounds/metronome-up.wav",
    "vendor/swt/linux/swt.jar",
    "vendor/swt/linux_aarch64/swt.jar",
    "vendor/swt/mac/swt.jar",
    "vendor/swt/mac_aarch64/swt.jar",
    "vendor/swt/windows/swt.jar"
  ]
  s.homepage = "http://github.com/AndyObtiva/glimmer-dsl-swt".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = ["\nYou are ready to use `glimmer` and `girb` commands on Windows and Linux.\n\nOn the Mac, run `glimmer-setup` command to complete setup of Glimmer DSL for SWT (it will configure a Mac required jruby option globally `-J-XstartOnFirstThread` so that you do not have to add manually), making `glimmer` and `girb` commands ready for use:\n\nglimmer-setup\n\n".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.3".freeze)
  s.rubygems_version = "3.2.29".freeze
  s.summary = "Glimmer DSL for SWT (JRuby Desktop Development GUI Framework)".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<glimmer>.freeze, ["~> 2.7.3"])
    s.add_runtime_dependency(%q<super_module>.freeze, [">= 1.4.1", "< 2.0.0"])
    s.add_runtime_dependency(%q<nested_inherited_jruby_include_package>.freeze, [">= 0.3.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<puts_debuggerer>.freeze, [">= 0.13.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<rake-tui>.freeze, [">= 0.2.3", "< 2.0.0"])
    s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 1.1.7", "< 2.0.0"])
    s.add_runtime_dependency(%q<jruby-win32ole>.freeze, [">= 0.8.5", "< 2.0.0"])
    s.add_runtime_dependency(%q<os>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<rake>.freeze, [">= 13.0.0"])
    s.add_runtime_dependency(%q<text-table>.freeze, [">= 1.2.4", "< 2.0.0"])
    s.add_runtime_dependency(%q<rouge>.freeze, [">= 3.26.0", "< 4.0.0"])
    s.add_development_dependency(%q<juwelier>.freeze, [">= 2.4.9", "< 3.0.0"])
    s.add_development_dependency(%q<warbler>.freeze, [">= 2.0.5", "< 3.0.0"])
    s.add_development_dependency(%q<rspec-mocks>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
    s.add_development_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
    s.add_development_dependency(%q<jruby-openssl>.freeze, [">= 0.14.1.cr2"])
  else
    s.add_dependency(%q<glimmer>.freeze, ["~> 2.7.3"])
    s.add_dependency(%q<super_module>.freeze, [">= 1.4.1", "< 2.0.0"])
    s.add_dependency(%q<nested_inherited_jruby_include_package>.freeze, [">= 0.3.0", "< 2.0.0"])
    s.add_dependency(%q<puts_debuggerer>.freeze, [">= 0.13.0", "< 2.0.0"])
    s.add_dependency(%q<rake-tui>.freeze, [">= 0.2.3", "< 2.0.0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 1.1.7", "< 2.0.0"])
    s.add_dependency(%q<jruby-win32ole>.freeze, [">= 0.8.5", "< 2.0.0"])
    s.add_dependency(%q<os>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 13.0.0"])
    s.add_dependency(%q<text-table>.freeze, [">= 1.2.4", "< 2.0.0"])
    s.add_dependency(%q<rouge>.freeze, [">= 3.26.0", "< 4.0.0"])
    s.add_dependency(%q<juwelier>.freeze, [">= 2.4.9", "< 3.0.0"])
    s.add_dependency(%q<warbler>.freeze, [">= 2.0.5", "< 3.0.0"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
    s.add_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
    s.add_dependency(%q<jruby-openssl>.freeze, [">= 0.14.1.cr2"])
  end
end

