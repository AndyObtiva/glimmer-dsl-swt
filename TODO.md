do# TODO

Here is a list of tasks to do (moved to [CHANGELOG.md](CHANGELOG.md) once done).

## Next

# TODO label for  (Baseball Game Schedule)
# TODO combo for selecting nlds, nlcs, alds, alcs, world series
- method on shell to indicate if it conatins widget in focus
- Document Table Editing instructions in README including all editor types like spinner and data_time
- Allow switching Ballpark between home and away team only, switching their positions and score positions when it's reversed
- Add a Game Promotions field to Hello, Table! to indicate things like Free Bobblehead, Free Towel, Free Umbrella, etc...
- Hello, Spinner! Sample

## Soon

- Make code_text custom widget support multiple languages
- Make code_text custom widget auto-detect current language
- Hello, Code Text! Sample

- Support radio data-binding similar to combo (spawning radio buttons automatically based on options)
- Support a clean way of specifying different widget properties per OS (e.g. taking a hash of OS mappings instead of raw property values or supporting mac, windows, linux Glimmer keywords that wrap blocks around platform specific logic, perhaps make a web equivalent in opal)
- Add preferences dialog/menu-items to desktopify app
- Remove default margins from composites/layouts. They are not as helpful as they seemed.
- Make shell activation on show an option, not the default
- Remove name column from listing of gems
- Investigate Gladiator issue with shrinking on opening files
- Support glimmer list:gems (listing all types of gems together)
- glimmer webify task, which generates a Glimmer DSL for Opal Rails app for a desktop app and publishes it on Heroku
- Make glimmer meta samples editable for experimentation before launching a sample
- Support a background Glimmer runner that keeps a Glimmer daemon running in the background and enables running any Glimmer app instantly. Should work on Windows and Linux fine. On the Mac, perhaps it would work handicapped since all apps will nest under one icon in the dock

- Log exceptions that occur in event listener blocks
# - Log exceptions that happen in CustomWidget body, before_body, and after_body blocks
- Fix focus on `focus true` (maybe use force_focus by default or add a delay through `focus 0.5` or something)
- Autodiscover samples in glimmer gems (instead of just allowing their configuration)
- Fix issue with scaffolding custom widget and custom shell inside app when working in a custom shell gem
- Fix text_proxy.text method call (should proxy to swt_widget.getText automatically)
- Run glimmer command rake task presents a TUI file chooser
- Windows support for glimmer command TUI
- Validate/Indicate required glimmer task first args (e.g. name for custom shell gem)
- Make `image` keyword generate and set image on parent if called inside a widget declaration
- Provide a way to scale images via `image` property keyword by passing width/height hash args (can be in pixels or :widget)
- Support background_image property without stretching of image on resize
- Fix issue with no_margin messing with the composite style (-7 isn't working without interference)
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
- Have property expression automatically call to_java(Type) on arrays for property methods that take arguments
- Add automatic ActiveRecord Observable support (ObservableActiveRecord)
- Add DB migration scaffolding support for ActiveRecord (bringing in rails migration/schema generation)
- Add Form scaffolding support for ActiveRecord (bringing in rails migration/schema generation)
- Look into making properties that expect an SWT widget auto-call .swt_widget if they receive a proxy

## Feature Suggestions
- Glimmer Wizard: provide a standard structure for building a Glimmer wizard (multi-step/multi-screen process)
- bind_content: an iterator that enables spawning widgets based on a variable collection (e.g. `bind_content('user.addresses').each { |address| address_widget {...} }` spawns 3 `AddressWidget`s if `user.addresses` is set with 3 addresses; and replaces with 2 `AddressWidget`s if `user.addresses` is reset with 2 addresses only). Needs further thought on naming and functionality.
Another idea in which each is triggered upon every update to bind's content:
```ruby
composite {
  content(model, 'username') {|username|
    label {
      text bind(model, 'username')
    }
  }
}

composite {
  content(model, 'addresses') {|address|
    label {
      bind(address, :street)
    }
    label {
      bind(address, :zip)
    }
  }
}
```
- Scroll bar listener support
- Extract FileTree Glimmer Custom widget from Gladiator
- Support Cygwin with glimmer command
- Build a debug console widget to inspect Glimmer GUI objects
- Desktopify web apps with a single command or click
- Provide a Glimmer App Store for Windows and Linux with Automatic Update support given that Glimmer only supports Mac App Store. Consider expanding to the Mac too with the selling point over the Mac store being that it does not require notarization (approval) though any apps that violate Glimmer's policy (no profane language or evil purposes) might be taken down permanently after distribution without warning.
- Support a Glimmer DSL for TUI that can convert any desktop app into a textual user interface without needing a change of code just like the Glimmer DSL for Opal

## Issues

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
- Change table editing support to rely on data-binding
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
- Consider adding a Glimmer::SWT::App that includes a Splash automatically and a hook for adding require statements so they'd happen after the splash shows up
- Consider support for building apps for Linux app stores like Snapstore: https://snapcraft.io/docs/adding-parts
- Publish MacOS apps on Homebrew (instructions: https://docs.brew.sh/Formula-Cookbook)
- Add `widget` keyword to build proxies for swt widgets without directly using Glimmer::SWT::WidgetProxy
- Look into modularizing the menu and prefrences into separate components for a scaffolded app/custom-shell
- Consider adding sash_form children style for having a fixed size when resizing, or provide a flexible alternative via sash widget
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
- Make a `composite` behave like a `scrolled_composite` if passed :v_scroll and/or :h_scroll styles (it transparently and automatically behind the scenes instantiates a scrolled_composite wrapping itself)
- Support background warm launching of Glimmer apps (in glimmer-cs-timer GitHub project branch: glimmer-app-type-client-server) (i.e. keeping them running in the background after initial start and then launching instantly when needed)
- Support shorter syntax for fonts when passing in one property only (e.g. `font 18` for height, `font :bold` for style, `font 'Lucida Console'` for name)
- TODO consider the idea of aliasing getCaretPosition in StyledText to match Text
- Support styledtext setting of styles via data-binding
- Support :accordion style for ExpandBar
- Consider supporting sound in Glimmer just for the sake of making java sound dependent apps runnable in Glimmer DSL for Opal
- Diff Tree when updating it to discover where to delete nodes, insert new nodes, and do it all in one shot (O(n) algorithm) to avoid recreating all nodes
- Consider the idea of showing External Samples in the Glimmer Meta-Sample by installing a gem and running its command right away for calculator and timer
- Refactor specs to utilize SWTBot instead of raw Event objects for GUI interaction
- Support automatic table editor setting based on data type (e.g. combo for a property accompanied by options, spinner for an integer, date_time for a date/time, etc...)

## Samples

- Add some minor improvements to all samples (e.g. keyboard shortcuts, refactorings, etc...)
- Add hello samples for every built-in SWT widget including the custom package
- Build a sample of samples GUI app (meta-sample) for easily browsing and launching all Glimmer samples
- HR Employee Management app
- Medical Patient Management app
- Business Accounting app
- Improve Contact Manager sample to add/remove/clear contacts, add phone and address, and store contacts permanently on hard drive.
- Tetris Sample

## Side Projects

- Publish any Glimmer app on the Mac App Store

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

### glimmer-dsl-uml

A DSL for building UML diagrams based on the Glimmer engine. Renders as SWT app to start. Support web later via opal.

### Glimmertalk project

- Build a Smalltalk-like Ruby app to allow people to build and edit GUI apps by introspecting GUI directly without restarting

### Glimmer Platform

- A web-browser-like platform-app that opens web links hosting pure Ruby code, including Glimmer GUI DSL code.
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
- Glimmer Platform can integrate perfectly with Glimmertalk to enable direct in-platform development and distribution of apps
- Glimmer Platform can integrate perfectly with the FreeHire website to deliver work for free
- Add minimum_width and minimum_height convenience attributes on ShellProxy for `shell` keyword

## Custom Widgets/Shells

- glimmer-cs-splash: splash shell widget
- glimmer-cw-datetimerange: start time end time (or date) duo that includes automatic validation/correctness (ensuring start is always before or equal to end depending on options)
- glimmer-cw-nebula: packages all of Nebula's widgets should one chooses to add them all in one go

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
