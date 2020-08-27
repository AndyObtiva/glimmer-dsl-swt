# TODO

Here is a list of tasks to do (moved to [CHANGELOG.md](CHANGELOG.md) once done). 

## Next

### 0.7.0

- Make sure bin/runner file for scaffolded Custom Shell gems calls jruby on windows not ruby
- Add built in support for handling jar file paths
- Add Windows icon to scaffolding
- Support `glimmer package` passing of extra args afterwards to use with glimmer package:native
- Add :no_margin SWT style to layouts and composites
- Accept ImageProxy as arg for image method
- Provide a way to scale images via `image` property keyword by passing width/height hash args (can be in pixels or :widget)
- Add shortcuts for password (adding :border as default style) and other text widget types
- Add shortcuts for error_box, information_box, etc... message_box variations based on style (e.g. SWT::ICON_INFORMATION)
- Support horizontal_span in addition to horizontalSpan in layout data (and other properties)
- Add a display default filter listener for closing dialogs (only one)
- Support clearing radio buttons when setting model property value to nil
- Add a simple :integer / :positive_integer / :decimal SWT style for adding verify_text validation for text field
- Add a shortcut for a numeric text field
- Set margin left margin right margin top margin bottom to 0 when available on a layout (like rowlayout)
- Make javapackager preferred over jpackage if both were available
- Fix transient issue with git bash not interpretting glimmer package[msi] as a rake task

### Soon (Version TBD)

- Make scaffolded app gemspec complete in accordance to config/warble when available
- Build a mini Glimmer app to launch samples (sample of samples meta-sample)
- Have property expression automatically call to_java(Type) on arrays for property methods that take arguments
- Add automatic ActiveRecord Observable support (ObservableActiveRecord)
- Add DB migration scaffolding support for ActiveRecord (bringing in rails migration/schema generation)
- Add Form scaffolding support for ActiveRecord (bringing in rails migration/schema generation)

## Feature Suggestions
- Glimmer Wizard: provide a standard structure for building a Glimmer wizard (multi-step/multi-screen process)
- bind_content: an iterator that enables spawning widgets based on a variable collection (e.g. `bind_content('user.addresses').each { |address| address_widget {...} }` spawns 3 `AddressWidget`s if `user.addresses` is set with 3 addresses; and replaces with 2 `AddressWidget`s if `user.addresses` is reset with 2 addresses only). Needs further thought on naming and functionality.
Another idea in which each is triggered upon every update to bind's content:
```ruby
bind_content(model, 'username') { |username|
  label {
    text username
  }
}

bind_content(model, 'addresses').each { |address|
  label {
    bind(address, :street)
  }
  label {
    bind(address, :zip)    
  }
}
```
- Image custom widget similar to video, and supporting gif
- Scroll bar listener support
- Extract FileTree Glimmer Custom widget from Gladiator
- Support Cygwin with glimmer command
- Build a debug console widget to inspect Glimmer GUI objects
- Desktopify web apps with a single command or click
- Provide a Glimmer App Store for Windows and Linux with Automatic Update support given that Glimmer only supports Mac App Store. Consider expanding to the Mac too with the selling point over the Mac store being that it does not require notarization (approval) though any apps that violate Glimmer's policy (no profane language or evil purposes) might be taken down permanently after distribution without warning.

## Issues

- Fix issue with not being able to data-bind layout data like exclude (often done along with visiblity on the widget)
- Investigate why widget.layout does not return layout but widget.getLayout or widget.get_layout does (probably a JRuby issue)

## Technical Tasks

- Explore supporting new Shine data-binding syntax (data-binding with spaceship operator <=>):
```ruby
items <=> 'model.property' # bidirectional
items <= 'model.property' # ready-only
items <=> binding('model.property') # bidirectional explicit binding
items <= binding('model.property') # ready-only explicit binding
items <= binding('model.property') {|x| x + 2} # read-only explicit binding with converter
items <=> binding('model.property') { # bidirectional explicit binding on_read/on_write converters
  on_read {|v| !v}
  on_write {|v| !v}
}
items <=> binding {
  path 'model.property'
  on_read {|v| !v}
  on_write {|v| !v}
}
```
- Improve tree databinding so that replacing content array value updates the tree (instead of clearing and rereading elements)
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
- Log to SysLog using this gem: https://www.rubydoc.info/gems/syslog-logger/1.6.8
- Implement Glimmer#respond_to? to accommodate method_missing
- Support the idea of application pre-warm up where an app is preloaded and shows up right away from launched
- Support data-binding shell size and location
- Support data-bind two widget attributes to each other
- Generate rspec test suite for app scaffolding
- Support eager/lazy/manual loading of SWT packages/classes. Give consumers the option to use eager (java_import), lazy (include_package), or manual, to be done in their apps.
- Consider dropping duality of data-binding syntax: bind(model, 'property'). Unify by always using bind('model.property') instead, which is simpler and better as it supports the case of model being nil starting with self as the model.
- Automatic relayout of glimmer widgets (or parent widget) when disposing a widget (or as an option when disposing)
- Make Glimmer defaults configurable
- Ensure support for packaging on Windows (exe file)
- Ensure support for packaging on Linux
- Refactor entire codebase to get rid of Java getters/setters in favor of Ruby attributes
- Support Mac top-menu-bar app-mini-icon
- Consider namespacing data_binding classes as SWT just like DSL is namespaced
- Introduce a new level of logging
- Scaffold a Glimmer DSL
- Scaffold a model + view form + data-binding connecting the two
- Scaffold an ActiveRecord model + migration + view form + data-binding connecting the two
- Test DB support with Derby DB
- Support auto-java-import all SWT widgets as an option (and consider making it happen automatically if an SWT widget wasn't loaded successfully)
- Support SWT CSS styling (org.eclipse.e4.ui.css.core.elementProvider and org.eclipse.e4.ui.css.core.propertyHandler in https://www.vogella.com/tutorials/Eclipse4CSS/article.html#css-support-for-custom-widgets)
- Support table default sort configuration via default_sort_property, default_sort block, or default_sort_by block
- Make scaffolding generate a README.md that mentions "Built with Glimmer" or "Built for Glimmer" (app vs gem) and includes Glimmer logo
- Make app scaffolding building a full MVP app not just hello world, with database access too
- Change table editing support to rely on data-binding
- Switch to juwelier gem for scaffolding and add `--markdown` option
- Wrap SWT as a Maven plugin and use jar-dependencies gem to rely on it instead of including it in the project gem
- Provide a helper method that loads a font from inside an app
- Allow passing random args to custom widget in order to get them passed to SWT widget (right now it only accepts swt styles)
- Fix issue with passing ShellProxy as parent to ShellProxy (and not accepting a raw shell as parent)
- Consider something like a "scaffold" widget that automatically introspects activerecord attributes (or ruby model attributes) and selects the appropriate widgets for them, as well as data-binds automatically
- Add a feature where Glimmer will guess a widget if a bad widget name was used and say "Did you mean xyz?" (e.g. composite for compsite)
- Contribute to JRuby an improvement that makes even Java public variables follow Ruby form (margin_width instead of marginWidth) to improve SWT programming syntax in Ruby
- Support table editing via spinner for integer values
- Add a default table editor for when a non-supported widget is provided, which uses that widget (perhaps take a :widget_property as a hash string value for knowing how to data-bind)
- Scroll to widget when it gains focus (perhaps look at its parents to find out which is a ScrolledComposite and scroll it to widget location)
- Consider adding a Glimmer::SWT::App that includes a Splash automatically and a hook for adding require statements so they'd happen after the splash shows up
- Consider support for building apps for Linux app stores like Snapstore: https://snapcraft.io/docs/adding-parts
- Publish MacOS apps on Homebrew (instructions: https://docs.brew.sh/Formula-Cookbook)
- Add `widget` keyword to build proxies for swt widgets without directly using Glimmer::SWT::WidgetProxy
- Look into modularizing the menu and prefrences into separate components for a scaffolded app/custom-shell
- Consider adding sash_form children style for having a fixed size when resizing, or provide a flexible alternative via sash widget

## Samples

- Build a sample of samples app (meta-sample) for easily browsing and launching all Glimmer samples
- HR Employee Management app
- Medical Patient Management app
- Business Accounting app
- Improve Contact Manager sample to add/remove/clear contacts, add phone and address, and store contacts permanently on hard drive.
- Add hello samples for every built-in SWT widget including the custom package
- Tetris Sample

## Side Projects

### glimmer-dsl-uml

A DSL for building UML diagrams based on the Glimmer engine. Renders as SWT app to start. Support web later via opal. 

### glimmertalk project

- Build a Smalltalk-like Ruby app to allow people to build and edit GUI apps by introspecting GUI directly without restarting

## Custom Widgets/Shells

- glimmer-cs-splash: splash shell widget
- glimmer-cw-datetimerange: start time end time (or date) duo that includes automatic validation/correctness (ensuring start is always before or equal to end depending on options)

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
