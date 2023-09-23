## TODO

Here is a list of tasks to do (moved to [CHANGELOG.md](CHANGELOG.md) once done).

## Next

- Hello, Pixel! example demonstrating pixel graphics
- Upgrade to rouge 4.x (e.g. 4.1.3) after upgrading JRuby to a version compatible with Ruby 2.7+
- Fix window dimension issues on Linux with some sample games like Tetris and Connect 4
- Rename `ext` directory to `glimmer-dsl-swt-ext` to avoid conflict with other gems having `ext`
- Look into not having Klondike Solitaire conflict with Battleship when the latter is run first in Meta-Sample
- Provide a method on any custom widget to instantly access its parent custom widget without using `get_data` or `data` because it is obscure
- Remove extra line after `body {}` in scaffolded custom widgets/shells/shapes
- Refactor Meta-Sample to pull in remote video tutorial data in a separate thread
- Fix `moveable`/`resizable` attributes for `table_column` (they don't work as they should)
- Support `-s`/`-S` `glimmer` command switch to enable running a glimmer script with `glimmer-dsl-swt` required and `Glimmer` module mixed into main object already.
- Upgrade juwelier's/github_api's dependency on EOL'ed oauth2

- support a splash screen in native executable packaging, leveraging the Java AWT splash screen feature: https://docs.oracle.com/en/java/javase/18/docs/api/java.desktop/java/awt/SplashScreen.html & https://docs.oracle.com/en/java/javase/17/jpackage/support-application-features.html#GUID-C7B49351-7258-4AE1-AA6F-D67859ED716A
- Support `refined_table` column-specific filtering using `:` (e.g. `name:Lisa`)
- Support `refined_table` ANDing of query terms when including multiple terms separated by space
- Support `refined_table` exact term filtering when using double-quotes around multiple words
- Consider supporting `table` converters at the model attribute level (similar to general data-binding on_read and on_write converters)
- Add indent/outdent keyboard shortcuts to `code_text` default behavior (with some refactoring to simplify modifications via a presenter model)
- Test tray_item in Windows after having removed on_widget_selected from its menu
- Offload Internet call to grab latest tutorials in Glimmer Meta-Sample to an asynchronous thread to avoid delaying startup time

- Enable select-all/zooming `code_text` with right-click contextual pop up menu
- Enable cut/copy/paste in `code_text` with right-click contextual pop up menu
- Enable undo/redo in `code_text` with right-click contextual pop up menu
- Look into why line_style_value reverts back to original value in Hello, Canvas Data-Binding! after dragging/dropping endpoints

- Rails-style Scaffolding of MVC structure + Database (flat file or relational db)
- Use custom widgets (method-based or class-based) for the app_menu_bar and dialogs in scaffolded apps (and improve code spacing of menu items) / and make File menu Help menu instead by default

- Support a property_list custom widget on top of table or tree [tree-table] (similar to this https://www.codeproject.com/Articles/7282/Property-list-ActiveX-control or https://www.viksoe.dk/code/propertylist.htm )

- Refactor Hello, Table! to utilize a presenter in place of `BallparkGame` singleton class
- Refactor all samples to include Glimmer::UI::Application instead of CustomShell

- Update Hello, File Dialog! to demonstrate both :Open and :Save SWT styles

- Custom Widget `after_body` hook fires after its own internal body is called. What about the externally added body by passing custom widget keyword a block? Support `after_external_body` or something similar.
- Support `table` data-binding to row data Array of Arrays just like Glimmer DSL for LibUI
- Support `table` data-binding to row data Array of Hashes (do so in Glimmer DSL for LibUI too)

- Support setting properties to true by simply declaring property name (e.g. `drag_source` instead of `drag_source true`)
- Support being able to declare extra listeners on custom widgets declaratively instead of by overriding handle_observation_request
- Fix issue with Hello, Custom Shape! where if user clicks inside head, it changes color despite not being filled. It must not do so even if listener is attached to containing shape.

- Include flat file database (e.g. YAML, JSON, or CSV) support into all Glimmer scaffolded apps in a passive state by default that users can activate by calling the FlatfileDatabase.store(hash)/FlatfileDatabase.load(hash) methods for example
- Include auto-synchronizing flat file database support across all app instances (it auto-propogates local hash changes persisted as JSON/YAML to the cloud by diffing and it listens to changes coming from the cloud). Explore different schema-less solutions to help with implementing this faster (like Reddis or Firebase).
- Include ActiveRecord/SQLite DB support into all Glimmer scaffolded apps in a passive state by default that users can activate by adding a migration and an ActiveRecord model.

- Add JFace to Glimmer DSL for SWT to use some of the JFace facilities like the Notification API and Notification Builder. Demonstrate the Notification API in Hello, Tray Item!

-Update Canvas Data Binding sample to include all shapes
- Add Zoom feature with CMD/+ CMD/- and CMD/0 to `code_text` (CTRL instead of CMD on Win/Linux)

- `generator`/`generators`: enables spawning a widget or a collection of widgets based on a data-bound variable depending on whether using `generator` or `generators` (e.g. `generators(user, :addresses) { |address| address_widget {...} }` spawns 3 `AddressWidget`s if `user.addresses` is set with 3 addresses; and replaces with 2 `AddressWidget`s if `user.addresses` is reset with 2 addresses only).
Consider replacing all children of parent as simplest implementation (or otherwise, remembering last sibling and spawning widgets next to it)
In the future, it can be optimized where new addresses are compared to old addresses, and if any are the same, their widgets are retained.
```ruby
composite {
  generators(person, :addresses) {|address, index, addresses|
    group {
      text "Address #{index+1}"
      
      label {
        text <= [address, :street]
      }
      label {
        text <= [address, :city]
      }
      label {
        text <= [address, :state]
      }
      label {
        text <= [address, :zip]
      }
    }
  }
}

composite {
  generator(person, :company) {|company|
    if company # clears the label widget below if company is updated to nil
      label {
        text <= [person, :company]
      }
    end
  }
}
```
- Consider the idea of not implementing `generator` in favor of actually supporting a property of `content` that could be set via data-binding like any other property, except the content set would be a Glimmer DSL hierarchy of widgets instead of a simple object like String as with normal properties. That said, maybe `generator` provides a more software engineer friendly syntax if the keyword is renamed to `content` as well.
- Refactor Glimmer Wordle to utilize the new Generator feature
- Nested generator support

- Support data-binding `table` `checked`, `grayed` properties
- Allow a custom widget to override where children are nested underneath it instead of them getting instead below the body_root by default
- Fix issue in Tetris with I tetromino when tilted horizontally near the right side where it does not fit anymore horizontally (3 blocks or less from the edge)

- Support a parent_widget_proxy method on Shape to get to parent widget in a hierarchy immediately
- Hello, Listener!
- Hello, Tooltip!

- Autoconvert file drag and drop event data to a Ruby array for dropped files

- Try using bundler from within Warbler JAR file (test if it works if the Gemfile and Gemfile.lock are included)
- Support specifying code_text custom theme via hash of color values, and make it data-bindable.
- Note the need to set Display.app_name = before app launch (not inside before_body) to work
- Fix display of icon in shells
- Stop thread in Hello, Custom Widget! on widget disposed
- Fix issue with code_text syntax highlighting not taking into account multi-line colored blocks (e.g. using /* */ in JavaScript syntax)
- Look into issue with unidirectional databinding of widget image property (and hot_image on menu_item)
- Add the Gladiator-style about dialog to the scaffolded app
- require app view after declaring app body in scaffolded app
- Support being able to nest child shapes under a CustomShape parent
- Support configuration of global widget default properties to quickly affect the style of an entire app globally without the complexity of CSS expressions.
- Provide a simple DSL way of supporting image cursors (e.g. being able to pass image path directly as a cursor value)

- Fix intermittent slowdown issue with closing Mandelbrot Fractal sample (only happens after keeping it open for a while, complains about threads)
- Support `square` and `circle` shapes (as well as any other missing shapes like polybezier/polyquad)
- Support setting both background and foreground on shapes causing a fill/draw of two shapes (one with background and one with foreground) (remove support of gradients via specifying both background/foreground in rectangles)
- Support background_pattern gradiant data-binding
- Improve Contact Manager elaborate sample to add/remove/clear contacts, add phone and address, and store contacts permanently on hard drive.
- Auto-derive column properties from column names (by convention through dehumanize of each column name)
- Support data-binding `_options` method items on list and combo (not just main value), thus making options update if `notify_observers(:some_attr_options)` is called)
- Fix issue with jpackage_extra_args not overriding main args when packaging (add extra logic to fix this) [if still needed, might not be a true issue]
- Hello, Tooltip!
- look into hooking on_shape_disposed in WidgetBinding without slowing down shapes in samples like Tetris

## Soon

- Ruby 3.1.0 removed the `matrix` gem from inside Ruby. Note when JRuby supports Ruby 3.1.0 and removes the `matrix` gem from itself as well to bundle it manually in Gemfile.
- Support SWT CSS styling (org.eclipse.e4.ui.css.core.elementProvider and org.eclipse.e4.ui.css.core.propertyHandler in https://www.vogella.com/tutorials/Eclipse4CSS/article.html#css-support-for-custom-widgets) (and https://www.eclipse.org/forums/index.php/t/1102568/)
- Support canvas drag & drop `on_drag_start` event to enable running logic upon dragging to determine whether to allow dragging or not conditionally (refactor Quarto with it when implemented)
- Document support for Edge browser on Windows: https://www.eclipse.org/swt/faq.php#howuseedge

## Future Consideration

- Look into supporting adding automated form validation features
- Look into using Tracepoint to do automatic computed data-binding
- Extract Metronome sample into an external sample and enhance further (like click-based tempo calculation)
- Demo drag and drop sample reordering a list or faux-list of labels
- Support `drag_source true` on advanced `tab_item` widgets (`styled_text`, `link`, `tab_item`, `c_tab_item`, `tooltip`, `tree_item`) to further simplify drag and drop for default cases
- Support `drop_target true` on advanced widgets (`styled_text`, `link`, `tab_item`, `c_tab_item`, `tooltip`, `tree_item`) to further simplify drag and drop for default cases
- Support canvas drag & drop across canvases

- Support updating code_text language/theme on the fly (right now, it is only supported during declaration construction)
- Fix issue with moving Paths (like through drag and drop). It seems that move_by is not working correctly with them (cubics disappear, and lines rotate instead of move)
- Cache/memoize awt geom objects when used in shape contain?/include? methods
- Support z_order property for Canvas Shape DSL Layer Support Z-Order (Ensure z-order is honored when adding canvas shapes after the fact). Perhaps support :last or :top also as value
- Support shape listeners for on_mouse_enter, on_mouse_exit, and on_mouse_hover (the SWT default implementation for canvas wouldn't work as is)
- Implement charts and graphs custom widgets using Nebula Visualization and Draw2D (glimmer-cw-visualization-nebula)
- Consider building a Spreadsheet Chart Nebula Sample showing 4 tabs of chart types based on a spreadsheet that can be edited with data.

- Make images have a transparent background by default
- Support percentage based width and height
- Canvas Shape shadows (or access to previous shape to paint a shadow if needed)

- Build a game sample to demonstrate all the latest canvas graphics features (above)

- Auto-Focusable canvas element (with keyboard)
- Support passing transform matrices as double-arrays to be more readable if needed
- Capture Canvas Shape events like mouse clicks and route them to shape enabling shape handling of events withing shape regions (or lines/points)

- Support width, height keyword args for Shape DSL drawimage to scale it to the intended size
- Support Glimmer::UI::CustomShape#to_image/to_swt_image/to_image_proxy method to build a custom image (aka sprite) from a custom shape (that could be parameterized with options) using the Canvas Shape DSL. Also, support being able to pass a custom shape to an image property directly (autoconverting it)
- Add a `#save` method to ImageProxy similar to the one on `ImageLoader` that takes location and format.

- Add progress dialog to meta-sample for launching bigger apps like Tetris
- Provide an on_dialog_closed alias for on_shell_closed (for use in dialogs)

- In addition to `widget_proxy.content {}`, support prepend, append, before, and after.
- Auto-Dispose `display` MacOS event listener registrations (e.g. `on_about`) declared inside custom widgets and custom shells (during their construction with before_body or after_body) with the observe keyword.

- Handle listener name space clashes by providing on_listener_event option instead of typical on_event

- Canvas Shape DSL autoscalable shapes or canvases (e.g. support percentages)
- Canvas animation property data-binding for cycle count, cycle count index, frame index, duration
- Canvas animation loop_count property to set number of loops assuming it is a finite animation (having frame count, cycle count, or duration)
- Canvas consider supporting an async: false option (to use sync_exec instead of async_exec)

- Build oval in Canvas Shape DSL with radius or diameter as alternatives to width and height

- Add a samples directory to scaffolded custom widget gems and custom shape gems that demonstrate them (encouraging 3rd party makers to show off their widgets)
- Support --no-shine option to disable if needed or there are concerns about conflicts between it and other keywords/methods that take no args
- Provide an SWTProxy API method for picking out line styles (line_style property in Canvas Shape DSL)
- Make ShellProxy#size work by setting initial size properly when invoked from content body (to avoid having to set on_swt_show event)
- Consider a universal after_edit (whether save or cancel) hook for Table editing
- Support an automatic progress bar dialog that shows up automatically for long running tasks in Glimmer (TODO figure out the details)
- Consider tweaking the Tetris color scheme
- Add meta-sample support for browsing all sample subdirectory files not just the top file (opening all files in tabs)
- Add line numbers to meta-sample code viewer
- Make `error_dialog` an official built-in Glimmer Custom Widget (extract from meta-sample/gladiator)
- Allow setting accelerator on cascade menu item via drop down menu proxy by automatically delegating the attribute
- Make shell proxy pack_same_size re-focus focused element before repacking

- Fix Gladiator issue regarding scrolling text to view when editing a line off screen in a styled_text widget

- Make Hello, Table! and Hello, Tree! stateful as in avoid static class to enable reruns after making changes in Meta-Sample
- Amend contact_manager to add a contact

- Hello, Image!
- An elaborate sample that demos every widget that comes with SWT out of the box
- Update Hello, Menu Bar! sample to show images on menu items
- Look into supporting `menu` pop up in Hello, Tool Bar! (automating linking it to a specific tool item)
- Update Hello, Message Box! Sample to include more options

- Make display detect if an on_about dialog is already setup before adding one (like in Tetris)
- Refactor `table` to optionally receive sort_attribute and additional_sort_attributes as options to bind items keyword since they are related
- Ensure a `table`'s columns cannot be clicked for sorting when it is bound as one-way datainbinding with `items <= ...` for example.

- Use flyweight pattern with fonts
- Use flyweight pattern with cursors
- Update Hello, Drag and Drop! sample to change mouse cursor while dragging and dropping (like drag a flag of the country)
- Provide a way to customize display in its own file in scaffolded app (just like configuration) instead of embedding in custom shell which custom shells invoke automatically behind the scenes instead of having to add to before_block
- add a config file during scaffolding that lists glimmer options (consider using a config dsl)
- Swtich scaffolding models/views directories into true Ruby namespaces nested under the project main namespace (e.g. calculator namespace for glimmer-cs-calculator)
- Consider adding `glimmer release` task to publish a Glimmer app as a gem (not just custom widgets or custom shells)
- Expose system menu items via proxies
- Support being able to wrap an swt widget with a proxy using Glimmer GUI DSL syntax
- Support being able to pass swt_widget to MenuProxy
- Distinguish between display filters and listeners
- Upgrade Contact Manager elaborate sample merging with Login and User Profile

- glimmer webify task, which generates a Glimmer DSL for Opal Rails app from a pre-existing desktop app, starts local rails server, launches website in the browser, and publishes app on Heroku if available
- glimmer scaffold:webready task, which generates a web-ready desktop app (including a Glimmer DSL for Opal Rails app), packages desktop app, starts local rails server, launches website in the browser, and publishes app on Heroku if available
- Document webify and scaffold:webready
- Document Heroku pre-requisite as optional for webready/webify modes.
- Document use of jruby in rails and ability to switch manually to CRuby with RVM

- Update Hello, Menu Bar! to have Language and Country just like the same sample in Glimer DSL for Tk (showing dialogs upon selection)
- Make code_text custom widget auto-detect current programming language
- Accept :read_only alternative to :readonly SWT style
- Use upcoming Glimmer support for observing properties on all array elements (not just a specific index as currently supported)
- Improve `link` widget support to make it work just like `button` by not requiring HTML (auto-generated) and auto-aligning with labels around the link (improving upon the original SWT widget API design)
- Highlight `table` selection after changing `table` collection out and back in again to the model collection that had the selection
- Support passing spinner `table` editor properties
- Add checkbox column editor to Hello, Table! Sample
- insert/delete contact in Contact Manager Sample
- insert employee and delete employee in Hello, Tree! Sample
- Document that consumers of spinner must bind selection after setting other properties (gotcha)
- Make tables detect inital sort property matching custom sort property on a column header and highlight sort on it

- Move glimmer projects underneath glimmer organization

- Add a right-click menu to code_text for undo/redo/cut/copy/paste/select-all
- Support a clean way of specifying different widget properties per OS (e.g. taking a hash of OS mappings instead of raw property values or supporting mac, windows, linux Glimmer keywords that wrap blocks around platform specific logic, perhaps make a web equivalent in opal)
- Add preferences dialog/menu-items to desktopify app
- Remove default margins from composites/layouts. They are not as helpful as they seemed.
- Make shell activation on show an option, not the default
- Remove name column from listing of gems
- Investigate Gladiator issue with shrinking on opening files
- Support glimmer list:gems (listing all types of gems together)
- Support a background Glimmer runner that keeps a Glimmer daemon running in the background and enables running any Glimmer app instantly. Should work on Windows and Linux fine. On the Mac, perhaps it would work handicapped since all apps will nest under one icon in the dock

- Simplify tab_folder/tab_item api (like having methods for switch to next tab and previous tab, and instead of relying on selection and get_data('proxy'), provide a shortcut)
- Move ext folder underneath glimmer-dsl-swt
- Log exceptions that happen in CustomWidget body, before_body, and after_body blocks
- Fix focus on `focus true` (maybe use force_focus by default or add a delay through `focus 0.5` or something)
- Maybe reparent shape by being able to change parent attribute via parent= method
- Fix issue with scaffolding custom widget and custom shell inside app when working in a custom shell gem
- Fix text_proxy.text method call (should proxy to swt_widget.getText automatically)
- Run glimmer command rake task presents a TUI file chooser
- Windows support for glimmer command TUI
- Validate/Indicate required glimmer task first args (e.g. name for custom shell gem)
- Make `image` keyword generate and set image on parent if called inside a widget declaration
- Provide a way to scale images via `image` property keyword by passing width/height hash args (can be in pixels or :widget)
- Support background_image property without stretching of image on resize
- Support Custom SWT styles that are no composite of others / Fix issue with no_margin messing with the composite style (-7 isn't working without interference)
- Add FillLayout default style if not passed in
- Make GitHub username optional for Scaffolding
- Have scaffolding of custom widget and custom shell within app match the namespace when inside a custom shell gem (or app if namespace is used), and reference APP_ROOT correctly
- Remove dependencies on gems that are only needed for Glimmer tasks (loading them at the time of running those tasks only)

- Add shortcuts for password (adding :border as default style) and other text widget types
- Add shortcuts for error_box, information_box, etc... message_box variations based on style (e.g. SWT::ICON_INFORMATION)
- Support horizontal_span in addition to horizontalSpan in layout data (and other properties)
- Add a display default filter listener for closing dialogs (only one)
- Support clearing radio buttons when setting model property value to nil
- Add a simple :integer / :positive_integer / :decimal SWT style for adding verify_text validation for text field
- Add a shortcut for a numeric text field
- Fix transient issue with git bash not interpretting glimmer package[msi] as a rake task
- glimmer command run rake task
- glimmer command girb rake task
- Support Windows with colored code output and tty prompt (perhaps only when using the special windows terminals that support that)
- Support ImageProxy fit_to_width and fit_to_height options

- Make scaffolded app gemspec complete in accordance to config/warble when available
- Add automatic ActiveRecord Observable support (ObservableActiveRecord)
- Add DB migration scaffolding support for ActiveRecord (bringing in rails migration/schema generation)
- Add Form scaffolding support for ActiveRecord (bringing in rails migration/schema generation)
- Look into making properties that expect an SWT widget auto-call .swt_widget if they receive a proxy
- Consider splitting more glimmer command dependencies (e.g. rake-tui) from glimmer GUI gem dependencies
- Support multiple consecutive font names specified in an array to use in order of availability (better than comma separated text that is error prone)

## Feature Suggestions
- Glimmer Wizard: provide a standard structure for building a Glimmer wizard (multi-step/multi-screen process)
- Consider updating Mandelbrot Fractical sample to optionally utilize GPU cores instead of CPU cores (consider Java OpenCL)
- Look into clipping drawing area when doing drag and drop to improve performance
- Make it an option to close app fast or execute dispose listeners when exiting app (closing the last shell)
- Introduce a backdoor to amend code while a Glimmer app is running for troubleshooting purposes
- Canvas Transform DSL property data-binding
- Look into the idea of supporting zooming on any desktop application for accessibility reasons
- Scroll bar listener support
- Extract FileTree Glimmer Custom widget from Gladiator
- Support Cygwin with glimmer command
- Build a debug console widget to inspect Glimmer GUI objects
- Desktopify web apps with a single command or click
- Provide a Glimmer App Store for Windows and Linux with Automatic Update support given that Glimmer only supports Mac App Store. Consider expanding to the Mac too with the selling point over the Mac store being that it does not require notarization.
- Support a Glimmer DSL for TUI that can convert any desktop app into a textual user interface without needing a change of code just like the Glimmer DSL for Opal
- Provide a performance troubleshooting option that automatically logs all method activities if any GUI action takes more than a few seconds to complete (i.e. hung temporarily while showing a spinning wheel)
- code_text support method switcher of language that automatically updates the lexer redrawing styled_text completely
- code_text support method for redrawing the syntax highlighting
- Support CustomWidget/CustomShell option data-binding with the ability to pass options via content block if needed (update hello code text example to use data binding of its options)
- Consider marking custom widget options as required when you have to have them at construction time before rendering content block
- Consider adding the jface tooltip as an external custom widget
- Augment the Weather app elaborate sample with graphics like showing the sun, wind gusts, clouds, etc...
- Quarto help pop up checkbox saying "do not show anymore"
- Make ESCAPE key cancel a canvas drag and drop in the middle of dragging
- Refactor Quarto to have each custom shape update itself instead of updates coming from quarto.rb

## Issues

- Fix issue with Quarto where dropped piece is exactly where OK button appears in message_box_panel and thus user closes dialog inadvertantly by dropping piece
- Fix setting logo icon on app shell (though it seems to be a recent SWT issue, so consider reporting after proving in Java)
- Fix issue with building images on the fly (with image nested DSL) on Windows
- Fix issue with Hello, Canvas Drag and Drop refactoring to use data-binding for drop target text not reflecting changes upon dropping balls until it hits 10 (seems caused by caching until textExtent is changed which happens between a single digit number to double-digits)
- Fix issue with hello canvas data binding changing of x and y after changing line width overwrites/annuls it
- Fix issue with setting shell app icon in meta-sample (not working from the inside of the app shell anymore)
- Fix the weird code text github theme gray artifacts in the html example (to the left of indented text, which goes away on hitting enter)
- Report funnotator issue to SWT folks
```ruby
shell do
  fill_layout
  text "Funnotator"
  minimum_size 1000, 700

  composite do
    grid_layout 10, true

    char = Struct.new :char, :annotation

    code = 5.times.map do |i|
      10.times.map do |j|
        char.new("Z").tap do |char|
          button do
            enabled false
            font height: 30, style: :bold
            text bind(char, :char)
            layout_data do
              width_hint 90
              height_hint 80
            end
          end
        end
      end
    end
  end
end.open
```
- Fix issue with `glimmer samples` (meta-sample) having an issue with using margin_width and margin_height inside root inside code_text (perhaps it's a styled_text issue only because it stops rerendering when typing)
- It seems that disposing a composite containing canvases with shapes that have data-bindings on properties (like background) does not deregister the observers properly
- Fix date/time Table editor visual/usability glitches on Windows if not issues in SWT itself
- Fix issue with not being able to data-bind layout data like exclude (often done along with visiblity on the widget)
- Investigate why widget.layout does not return layout but widget.getLayout or widget.get_layout does (probably a JRuby issue)
- Check this issue, which seems to happen when no expression handler can handle the DSL keyword being processed:

[DEVELOPMENT MODE] (detected /Users/User/code/glimmer-dsl-swt/lib/glimmer-dsl-swt.rb)
[2020-10-20 06:35:41] ERROR glimmer: Encountered an invalid keyword at this object: #<SampleDirectory:0x42e25b0b>
[2020-10-20 06:35:41] ERROR glimmer: /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:58:in `handle': Glimmer keyword content with args [] cannot be handled inside parent #<Glimmer::SWT::WidgetProxy:0x52d645b1>! Check the validity of the code. (Glimmer::InvalidKeywordError)
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/expression_handler.rb:52:in `handle'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/engine.rb:169:in `interpret'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer.rb:73:in `method_missing'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/data_binding/model_binding.rb:240:in `invoke_property_reader'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/data_binding/model_binding.rb:217:in `evaluate_property'
  from /Users/User/code/glimmer-dsl-swt/lib/glimmer/dsl/swt/data_binding_expression.rb:46:in `interpret'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/engine.rb:174:in `interpret_expression'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer/dsl/engine.rb:170:in `interpret'
  from /Users/User/.rvm/gems/jruby-9.2.13.0@glimmer-dsl-swt/gems/glimmer-1.0.1/lib/glimmer.rb:73:in `method_missing'
  from /Users/User/code/glimmer-dsl-swt/samples/meta_sample.rb:142:in `block in launch'


## Technical Tasks

- Allow running `glimmer samples/` as `glimmer samples`
- Explore supporting Shine variations:
```ruby
items <=> {model: model, property: :property, on_read: ->(v) {}, on_write: ->(v) {}} # bidirectional
items <= {model: model, property: property, on_read: ->(v) {}, on_write: ->(v) {}} # ready-only
items <=> {model: model, attribute: :property, on_read: ->(v) {}, on_write: ->(v) {}} # bidirectional
items <= {model: model, attribute: property, on_read: ->(v) {}, on_write: ->(v) {}} # ready-only
- Improve tree databinding so that replacing content array value updates the tree (instead of clearing and rereading elements)
- Support a declarative simple way of adding support for listeners on a custom widget (`Glimmer::UI::CustomWidget`)
- Consider need for a startup progress dialog (with Glimmer branding)
- Externalize constants to make easily configurable
- Check for need to recursively call dispose on widget descendants
- Report a friendly error message for  can't modify frozen NilClass when mistakenly observing a nil model instead of doing a nested bind(self, 'model.property')
- Provide general DSL to construct any object with Glimmer even if not a widget. Useful for easily setting style_range on a StyledText widget. Maybe make it work like layout_data where it knows type to instantiate automatically. With style_range, that's easy since it can be inferred from args.
- Consider implementing Glimmer.app_dir as Pathname object referring to app root path of Glimmer application project (not Glimmer library)
- Get rid of dispose widget error upon quitting a Glimmer app
- Make observers 'method?' friendly
- Compose ModelBinding out of another ModelBinding (nesting deeper)
- add a `#shell` method to WidgetProxy and custom widget classes to get ShellProxy containing them (or custom shell [think about the implications of this one])
- Support proper `dispose` of widgets across the board (already supporting garbage collecting observers upon dispose... check if anything else is missing, like nested widget disposal)
- consider detecting type on widget property method and automatically invoking right converter (e.g. :to_s for String text property, :to_i for Integer property, etc...)
- Provide girb option to run without including Glimmer. Useful when testing an application that is not a "hello, world!" sort of example
- Correct attribute/property naming (unify as attributes)
- Make WidgetProxy and custom widgets proxy method calls to wrapped widget
- Implement a Graphical Glimmer sample launcher
- Support `=>` syntax alternative for `computed_by` data-binding
- Support data binding boolean properties ending with ? bidirectionally (already supported for read-only)
- Support XML Top-Level Static Expression (xml { })
- Support XML DSL comments <!-- COMMENT -->
- Support XML Document Declaration Tag: <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
- Support HTML Doctype Declaration <!DOCTYPE html>
- TODO consider documenting `generate_icon` in Glimmer DSL for SWT or even providing scaffolding for it
```ruby
@i = image(200, 200) {oval(0,0,200,200) {background :red}} # replace with any image like Tetris logo
i = org.eclipse.swt.graphics.Image.new(display.swt_display, 200, 200)
gc = org.eclipse.swt.graphics.GC.new(i)
gc.drawImage(@i.swt_image, 0, 0)
il = ImageLoader.new(); il.data = [i.image_data]; il.save('icon.jpg', swt(:image_jpeg))
```
- Log to SysLog using this gem: https://www.rubydoc.info/gems/syslog-logger/1.6.8
- Implement Glimmer#respond_to? to accommodate method_missing
- Provide option to not dispose shape children upon disposing a shape (perhaps passing `children: false`)
- Support the idea of application pre-warm up where an app is preloaded and shows up right away from launched
- Support data-binding shell size and location
- Support data-bind two widget attributes to each other
- Generate rspec test suite for app scaffolding
- Support eager/lazy/manual loading of SWT packages/classes. Give consumers the option to use eager (java_import), lazy (include_package), or manual, to be done in their apps.
- Consider dropping duality of data-binding syntax: bind(model, 'property'). Unify by always using bind('model.property') instead, which is simpler and better as it supports the case of model being nil starting with self as the model.
- Automatic relayout of glimmer widgets (or parent widget) when disposing a widget (or as an option when disposing)
- Make Glimmer defaults configurable
- Ensure support for packaging on Windows (exe file)
- Refactor entire codebase to get rid of Java getters/setters in favor of Ruby attributes
- Support Mac top-menu-bar app-mini-icon
- Consider namespacing data_binding classes as SWT just like DSL is namespaced
- Introduce a new level of logging
- Scaffold a Glimmer DSL
- Scaffold a model + view form + data-binding connecting the two
- Scaffold an ActiveRecord model + migration + view form + data-binding connecting the two
- Test DB support with Derby DB
- Support c_tab_folder/c_tab_item
- Support auto-java-import all SWT widgets as an option (and consider making it happen automatically if an SWT widget wasn't loaded successfully)
- Support Glimmer CSS styling alternative to SWT CSS in case it is too complicated to use
- Support HTML-like CSS styling by translating SWT widgets into HTML equivalents in an inspector and then applying CSS styles with another translater. This makes styling desktop apps appealing to web designers.
- Make scaffolding generate a README.md that mentions "Built with Glimmer" or "Built for Glimmer" (app vs gem) and includes Glimmer logo
- Make app scaffolding building a full MVP app not just hello world, with database access too
- Wrap SWT as a Maven plugin and use jar-dependencies gem to rely on it instead of including it in the project gem
- Provide a helper method that loads a font from inside an app
- Allow passing random args to custom widget in order to get them passed to SWT widget (right now it only accepts swt styles)
- Fix issue with passing ShellProxy as parent to ShellProxy (and not accepting a raw shell as parent)
- Consider something like a "scaffold" widget that automatically introspects activerecord attributes (or ruby model attributes) and selects the appropriate widgets for them, as well as data-binds automatically
- Add a feature where Glimmer will guess a widget if a bad widget name was used and say "Did you mean xyz?" (e.g. composite for compsite)
- Contribute to JRuby an improvement that makes even Java public variables follow Ruby form (margin_width instead of marginWidth) to improve SWT programming syntax in Ruby
- Scroll to widget when it gains focus (perhaps look at its parents to find out which is a ScrolledComposite and scroll it to widget location)
- Consider scaffolding an app with a splash screen (option)
- Consider support for building apps for Linux app stores like Snapstore: https://snapcraft.io/docs/adding-parts
- Publish MacOS apps on Homebrew (instructions: https://docs.brew.sh/Formula-Cookbook)
- Add `widget` keyword to build proxies for swt widgets without directly using Glimmer::SWT::WidgetProxy
- Look into modularizing the menu and prefrences into separate components for a scaffolded app/custom-shell
- Consider adding sash_form children style for having a fixed size when resizing, or provide a flexible alternative via sash widget
- Enhance sash_form so that one may specify a background color for sash on hover
- Speed up glimmer command with CRuby compatibility via jruby-jars gem
- Build a TUI for browsing/running internal gem samples
- Syntax-highlight sample code when output with `glimmer sample:code` command
- Add man pages for glimmer commands
- Added an SWT::Asynchronous module or something similar to automatically turn all methods in a class as threaded async (needed for use with drb)
- Provide a friendly message when scaffolded app/gem/file already exists instead of an error
- Integrate https://sveinbjorn.org/platypus into DRB pure Ruby client packaging on Mac
- Use tty-markdown to output code of samples with syntax highlighting
- Use tty-option to rewrite glimmer command more cleanly
- Look into modular Java as a way to speed up launching of packaged Glimmer apps
- Look into module Ruby (mruby) as a way to speed up launching of packaged Glimmer apps
- Move ext directory under glimmer-dsl-swt to namespace it for safety with other libraries
- Use platybus for splash screen on the mac since it shows up immediately with it
- Support the idea of pre-launching a JVM server (perhaps Nailgun with OSGi or simply DRB on JRuby) and instrumenting apps unto it to run immediately instead of taking the time to launch a JVM server first. Perhaps an intial version requires JAR files preloaded loaded on install. Future version would support the idea of a client sending the JAR to the server to include at runtime.
- Glimmer DSL for RubyMotion widget support on the Mac only
- Support a Glimmer command GUI as an option to use in place of the TUI
- Introduce a logging level below debug and below info to avoid noisiness
- Fix issue with proxy.layout not working forcing me to do proxy.get_layout
- Support JRuby/Ruby -e and -r options in `glimmer` command
- Indicate which Ruby gems are installed or not when running `glimmer list:gems:` commands
- Rewrite Glimmer command with tty-option gem
- Consider idea of having custom shells auto-set human text on their shell from their class name by convention
- List all gems (not just cw or cs, etc..)
- Make Glimmer detect a Glimmer project (cw, cs, dsl) when in it locally and provide its samples for running if any
- Support on_listener_event_name alternative name for events (makes some events more readable)
- Make girb instrument an already running shell by making shell.open behave differently under it (spawning a thread)
- Link to SWT Maven repositories using jar-dependencies: https://mvnrepository.com/artifact/org.eclipse.platform/org.eclipse.swt.gtk.linux.aarch64
- Auto-refresh GUI from changes in rb files
- Load development gems for "package" tasks
- Make property setting inside a widget inside a custom shell body block not die silently when there is a Ruby error (e.g. invalid constant)
- Consider supporting Hash-object based Data-Binding instead of Ruby attributes using the same Data-Binding syntax. Comes in handy in situations where the data is coming raw from a database without having a Model that wraps it.
- Consider a dual gemspec strategy (one for rake tasks and one for glimmer run of apps)
- Ensure support for packaging on Linux
- Have scaffolded app Rakefile include in gemspec all directories in Warble config.dirs automatically
- Text-based (TUI) progress indicator when launching a glimmer app
- Make a `composite`/`canvas` behave like a `scrolled_composite` if passed :v_scroll and/or :h_scroll styles (it transparently and automatically behind the scenes instantiates a scrolled_composite wrapping itself)
- Support background warm launching of Glimmer apps (in glimmer-cs-timer GitHub project branch: glimmer-app-type-client-server) (i.e. keeping them running in the background after initial start and then launching instantly when needed)
- Support shorter syntax for fonts when passing in one property only (e.g. `font 18` for height, `font :bold` for style, `font 'Lucida Console'` for name)
- TODO consider the idea of aliasing getCaretPosition in StyledText to match Text
- consider supporting adding `Shape#content {}` without redraw (by passing `(redraw: false)`)
- Support styledtext setting of styles via data-binding
- Support :accordion style for ExpandBar
- Consider supporting sound in Glimmer just for the sake of making java sound dependent apps runnable in Glimmer DSL for Opal
- Diff Tree when updating it to discover where to delete nodes, insert new nodes, and do it all in one shot (O(n) algorithm) to avoid recreating all nodes
- Consider the idea of showing External Samples in the Glimmer Meta-Sample by installing a gem and running its command right away for calculator and timer
- Refactor specs to utilize SWTBot instead of raw Event objects for GUI interaction
- Support automatic table editor setting based on data type (e.g. combo for a property accompanied by options, spinner for an integer, date_time for a date/time, etc...)
- Support custom table editor block to use estoric unsupported widgets on the fly if needed
- Consider auto-synchronizing access/mutation of attributes from threads other than the main thread (https://github.com/jruby/jruby/wiki/Concurrency-in-jruby) or at least supporting a 'syncrhonize' keyword in Glimmer DSL
- Preload all SWT widgets as static keywords to optimize performance if needed
- Support setting default sort direction on `table` (and sort direction on any sort_property option)
- Think about widget subclasses overriding set_attribute to add more attributes vs adding as Ruby attributes directly
- Consider extracting has_attribute?, set_attribute, and get_attribute from all classes into common modules (mixins)
- Support auto-selection of table column editor based on data type
- Consider getting rid of set_attribute / get_attribute on WidgetProxy by moving logic to method_missing and updating propertyexpression (and other expressions) to rely on send instead
- Consider extracting property_expression to glimmer
- Consider generalizing DataBindingExpression and moving to glimmer (making class for WidgetBinding configurable or generalized via a Binding ancestor to it and ModelBinding)
- Support ability o data-bind widgets to each other directly
- Upgrade to JDK15
- Include Splash screen support automatically in CustomShell and a hook for adding require statements (or work) so they'd happen after the splash shows up or just automate all of it by convention
- Consider supporting balanced_async_exec (balancing async_exec runs via an intermediate queue that segragates by passed in symbol argument and optional weight (default=1)) (e.g. balanced_async_exec('key_event', weight: 2, &runnable))
- Consider the idea of shape (specific) layouts
- Consider the idea of non-square bound widgets
- Implement a variation on puts_debuggerer that shows logging in a Glimmer window for Glimmer apps (perhaps pd with glimmer: true which can be configured globally)
- Add [SWT OpenGL support](https://www.eclipse.org/swt/opengl/) (JOGL)
- Consider supporting auto-relayout by detecting changes to data on widgets (as an option or global option)
- Tetris Immediate Drop playfield collision shake animation effect on impact
- Support spriting of images using standard SWT layout techniques like GridLayout (i.e. building an image of multiple images or canvases containing shapes while obeying applied layout rules if a canvas contains other canvases)
- Support routing of property setting/data-binding in a custom widget to a nested widget underneath its body root using the custom_widget_property_owner desginator method (called in the body of the widget that owns the properties or else body_root is the one)
- Provide a way to still route property setting/data-binding to root composite if need be in a custom widget with a nested property owner
- Consider building drag panning into ScrolledComposite ( scrolled_composite ) as an option
- Build image with a transparent background by default
- Look into the idea of applying `transform` objects on any widget's rendering
- Canvas Shape DSL Support default sizing (default width/height) of Arc containing text (or any shapes)
- Optimize Flicker Free repaints of canvas shapes on data-binding changes (consider forms of regional clipping/caching/buffering)
- Support nesting `polyline` and `polygon` under path in Canvas Shape DSL (breaking them down into lines)
- Support a Canvas Shape DSL `path` containing a `rectangle` (point is auto-derived from last point if not specified)
- Support a Canvas Shape DSL `path` containing a `arc` (point is auto-derived from last point if not specified)
- Support a Canvas Shape DSL `path` containing a `string` (point is auto-derived from last point if not specified)
- Support a scrolled_composite auto-growing based on its content (e.g. canvas)
- Support a path containing a `quad` bezier curve optional `previous_point_connected` property (first point is auto-derived from previous point if not specified. If points are 1, it auto-connects to previous point and auto-fills the middle control point through an equilateral triangle.)
- Support a path containing a `cubic` bezier curve optional `previous_point_connected` property (first point is auto-derived from previous point if not specified. If points are 1, it auto-connects to previous point and auto-fills the 2 middle control points through a square. If points are 2, it only fills the missing middle control point symmetrically to the first control point)
- Support nesting a `quad` directly under a canvas or shape, instead of path (behaving as a full path object instead of just a path segment)
- Support nesting a `cubic` directly under a canvas or shape, instead of path (behaving as a full path object instead of just a path segment)
- Support a line `point_array` property to be consistent with `quad` `polygon` and `polyline` (behaving differently inside a path)
- Support a path containing a nested `path`
- Consider implementing undo/redo support for adding points/lines/quads/cubics to paths
- `tab_folder` look into auto-packing issues
- Support a `curve` Custom Shape keyword as a custom path with a `type` (as `point`, `line`, `quad`, or `cubic`), a `point_array` (or optionally `line_array`, `quad_array`, or `cube_array`, preserving data when switching type), and an optional `previous_point_connected true` property. If it starts as cubic, and you change type via data-binding while keeping the same points, it intelligently drops the control points only (remembering them in case you change the type back unless you update the points afterwards). If it starts as quad or line and you change the type upward, it intelligently fills missing control points symettrically. Consider supporting functions at the `curve` shape level also with start/end/division properties). Perhaps provide option for what to do when changing type (preserve_points_on_type_change false option)
- Hello, Curve! redoes Hello, Canvas Path! in a single screen (no tabs) by providing a dropdown or radio to scale up to quad or cubic for a better visualization. Also, the option to flatten the data.
- Support the idea of appending _widget to shape names to create self-contained independent canvas-drawn single shapes (e.g. rectangle_widget, or oval_widget, etc...). Their background is transparent or inherited from their parent (simulating transparency) by default. Their foreground is also inherited by default
- Update Hello, Tree! to enable adding/removing nodes
- code_text custom widget syntax highlighting for Glimmer DSL syntax (not just Ruby). It can be done by recognizing all the widgets, options, properties, listeners, and methods, and coloring them uniquely.
- Optimize performance of startup time in requiring glimmer-dsl-swt
- Make dropping in canvas drag and drop work through testing overlap of dragged shape and drop target instead of containment of x,y in drop target to be more permissive, accurate, and user-friendly (this needs calculation of area of overlap to pick the biggest overlap for deciding where to drop)
- Support `table` Lazy Loading via `Enumerator` or `Enumerator::Lazy`
- Support `table` Live Loading via a block that takes each cell's row and column before it is rendered and generates/loads its data

## Samples

- Hello, Listener!
- Hello, Tooltip!
- Hello, Task Bar! (bottom status bar) (support `task_bar` and `task_item` widgets under shell)
- Hello, Popup List! (selectable items that appear in own shell positioned above parent shell; e.g. text autocomplete) (support `popup_list` widget and/or `autocomplete_text` custom widget)
- Envelope printing app: modify app to do a form similar to Hello, Computed!, building an envelope with a personal address and target address
- Sliding Puzzle Sample
- Music playing app
- Medical Patient Management app
- Business Accounting app
- Add improvements to Timer to do Countup and Pomodoro, and use Nebula's digital clock custom widget
- TodoMVC External Sample
- IdeaRank External Sample

## Side Projects

- Publish a Glimmer app on the Mac App Store

### Playcoloring

A young girl coloring game that teaches them how to color with a computer while trying to beat a timed coloring deadline.

Target audience is 1st-3rd grade school girls

Use Cases:
- Start with a random painting (an internal selection of canvas graphics, eventually supporting free svgs from the Internet)
- Hover mouse over a colorable area to highlight and it lights up
- Click a highlighted area and a color dialog pops up to select a color (or pick last color)
- Close color dialog for color to be selected

Difficulties:
- Easy (internal canvases at easy level)
- Medium (internal canvases at medium level)
- Hard (internal canvases at hard level)
- Random (svgs picked from the internet)

### Glimmer Time Tracker (Demo Video App)

A task time-tracking app that stores time-tracking data in the cloud by integrating with a Heroku Rails app. Make a demo video about this app, showing how to build it bit by bit.

Use-Cases:
- List task times in a table (task name, start time, duration, end time)
- Start timing a task (task name and then click start button so the app would record start time)
- Stop timing a task (click stop button and app automatically records duration and end time, and adds to task time list)

Build it as a system tray item app

Package for Mac, Windows, and Linux (on Linux, an auto-generated custom shell script is more than good enough)

Convert into an Glimmer DSL for Opal app once done.

Video Demo Series:
- Basic app implementation of use-cases with packaging on Mac, Windows, and Linux
- Add a system tray icon
- Store data in the cloud in a Rails app on Heroku
- Run as a Glimmer DSL for Opal web app

### Concise Term (Terminal App)

A terminal written in Glimmer DSL for SWT.

- Ruby based shell (not bash or zsh)
- Supports pixel perfect full-color 2D painting without relying on ASCII. Ability to render perfect high res photos/graphics
- Consider optional mouse interaction support and in-terminal GUI
- Dark look and feel by default (themable through terminal command configuration only)

### Connector (Web Browser)

- JxBrowser based Glimmer DSL for SWT Ruby web browser
- Supports "Ruby powered web pages"
- Supports Glimmer GUI apps natively via Glimmer DSL for SWT (Glimmer DSL for Opal automatically sends pure Ruby code instead of transpiling to JS)

### Glimmer Platform

- A web-browser-like platform-app (perhaps builds on [Connector](#connector-web-browser)) that opens web links hosting pure Ruby code, including Glimmer GUI DSL code.
- Ruby files are hyper-linked via require-like statements that do lazy-downloading/caching of Ruby files on a per-need basis (e.g. button click) while background-downloading/caching Ruby files ahead of time when the user is not taking actions (apps may have a specified list of initial vs delayed requires).
- Allows distributing incrementally-updating apps very easily.
- Integration with GitHub as the way to release app code
- Can have an enterprise-section that require enterprise membership to access specific enterprise apps only
- Can have a paid-section that would allow people to purchase any app they like
- Can have a free-section where anyone can build/publish/update apps instantly alone
- Can have a free-organization/team-section for multiple people collaborating on apps
- Can have a free-for-all-section where GitHub code is managed by the platform, including automation of accepting pull requests, and random people can collaborate or contribute to projects by pulling code from and pushing code to GitHub. This encourages programming as a social and learning activity.
- Ability to gel any Glimmer Platform app into a standalone app on the machine
- SSL connection encryption and baked in authentication/account management services for customers and developers
- Glimmer Platform becomes a framework that handles many concerns and services (accounts, location, configuration, etc...) effortlessly so that developers can very productively roll out desktop apps with pure Ruby code (this becomes the default way to build Glimmer apps)
- Glimmer Platform can integrate perfectly with the FreeHire website to deliver work for free
- Add minimum_width and minimum_height convenience attributes on ShellProxy for `shell` keyword

### UML For Life

- A UML diagraming app (consider eventually webifying via Opal)

## Custom Widgets/Shells/Shapes/Images

Acronyms:
cw: custom widget
cs: custom shell
cp: custom shape
ci: custom image

- glimmer-cw-datetimerange: start time end time (or date) duo that includes automatic validation/correctness (ensuring start is always before or equal to end depending on options). Perhaps have it upgrade to Nebula CDateTime if available (or as an option)
- glimmer-cw-gif
- weather custom widget example leveraging shapes too
- glimmer-cp-audiovisualizer. Options include audio data and time input.

## Documentation Tasks

- Recapture all of readme's sample screenshots on Mac, Windows, and Linux (except the general widget listing for now)
- Add Glossary
- Document custom widget custom properties/observers
- Explain MVC and MVP
- Double down on using the wording property vs attribute to minimize confusion
- Document async_exec and sync_exec
- Document example of using an external Java SWT custom widget by importing its java package directly to do the trick
- Make a video documenting how to build Tic Tac Toe (no AI) step by step
- Document on_ SWT event listeners for events declared on SWT constant like show and hide
- Document Glimmer DSL in full detail by generating translated documentation from SWT API (write a program) and adding to it
- Document how to use Glimmer as the View layer only of a Java app rebuilding tic tac toe following that kind of application architecture.
- Document structure of a glimmer app as generated by scaffold command
- Document different Windows setup alternatives like standard CMD, Git Bash, Cygwin, and Ubuntu Bash Sybsystem
- Document message_box keyword
- Add a gif demo of how to scaffold a Glimmer app from scratch
- Write an article about how you built the Glimmer Calculator sample and share online
- Document example of app reusing a glimmer custom shell gem and add to gladiator and calculator
- Document JRuby syntax for SWT Java objects having rubyish alternatives (e.g. items for getItems)
- Document how to publish apps on MacUpdate.com
- Split Ruby Style Guide into its own md file adding in code examples to demonstrate each point (here is a good example to follow: https://github.com/rubocop-hq/ruby-style-guide#the-ruby-style-guide)
- Update Sample screenshots given the new default margin layout changes
