# Change Log

### 4.18.1.0

- Canvas Shape DSL
- Hello, Canvas! Sample
- Animation DSL
- Hello, Canvas Animation! Sample
- Fixed issue with async_exec not working in ShellProxy when delegate widget is nil

### 4.18.0.2

- Minor update on Hello, Dialog! Sample
- Upgrade to glimmer v1.0.7

### 4.18.0.1

- Hello, Dialog! Sample
- Added Glimmer icon to Glimmer Meta-Sample (Sample of Samples)
- Upgrade Scaffolded projects to JRuby v9.2.14.0
- Switch back to official git gem v1.8.1 now that glimmer-git gem branch is merged into it
- Fix issue with not reporting exception encountered in editing a tree item if consumer code had a bug

### 4.18.0.0

- Upgrade to SWT v4.18
- Upgrade to JRuby v9.2.14.0
- Apply all WidgetProxy property converters upon normal setting of properties too (not just in DSL) (like `some_widget.background = color_symbol`)
- Update Hello, Menu Bar! sample to show accelerators on menu items
- Have the `swt` keyword (SWTProxy) support accepting a string character (to build an accelerator style)
- Make accelerator property accept symbols and character directly (without swt)
- Write meta-sample changes to user directory to avoid permission issues
- Zero margin_left, margin_right, margin_top, margin_bottom in layouts given that margin_width and margin_height are set by default
- Prevent editing/launching meta-sample from Glimmer Meta-Sample
- Fix enablement on `menu` (as opposed to menu_item, where it works)
- Fix issue relating to background image scaling on resize of widget

### 4.17.10.8

- Support editing sample code in the Glimmer Meta-Sample to enable experimentation and learning
- Add a "Reset" button to the Glimmer Meta-Sample to allow resetting sample code changes
- Refactor/revise hello_message_box.rb and hello_pop_up_context_menu.rb samples
- Upgrade to glimmer 1.0.6

### 4.17.10.7

- Loosened dependencies on most Glimmer author-owned gems
- Refactored/Simplified/Fixed Hello, Link! Sample

### 4.17.10.6

- Hello, Link! Sample
- Refactor hello list samples

### 4.17.10.5

- Hello, Button! Sample

### 4.17.10.4

- Do not select first row in a table by default (keep unselected)
- Prevented extra call to model data in table items data-binding
- Upgraded to glimmer v1.0.5

### 4.17.10.3

- Fixed issue in StyledText data-binding relating to capturing selection changes on mouse click

### 4.17.10.2

- Upgraded glimmer gem to version 1.0.4
- Fixed issues relating to data-binding `styled_text` widget

### 4.17.10.1

- Upgraded glimmer gem to version 1.0.3
- Upgraded rouge gem to version 3.25.0

### 4.17.10.0

- Support table editing via `date_time` for date/time values
- Support table default sort configuration via sort_property
- Support table default sort configuration via sort block
- Support table default sort configuration via sort_by block
- Hello, Table! Sample editor :date_time, property: :date_time in
- Hello, Table! Sample label for  (Baseball Game Schedule)
- Hello, Table! Sample combo for selecting nlds, nlcs, alds, alcs, world series
- Hello, Table! Sample promotion field that indicates things like Free Bobblehead, Free Towel, Free Umbrella, etc...
- ShellProxy#include_focus_control?
- Fix issue with table selection data-binding when in single selection mode vs multi
- Hello, Spinner! Sample

### 4.17.9.0

- Add table style :editable to hook editing listener on mouse click automatically (instead of manually via on_widget_selected)
- Support table editing via `spinner` for integer values
- date_time widget official data-binding support of date_time, date, time, year, month, day, hours, minutes, and seconds
- date widget alias for date_time(:date)
- time widget alias for date_time(:time)
- calendar widget alias for date_time(:calendar)
- date_drop_down widget alias for date_time(:date, :drop_down)
- Hello, Date Time! Sample

### 4.17.8.3

- Hello, Table! Sample
- Disable editing on a column with `editor :none`
- Improve `code_text` performance immensely by only styling the lines being shown upon editing
- Fix dead spots with syntax highlighting in some files in Gladiator like file.rb

### 4.17.8.2

- Hello, Group! Sample

### 4.17.8.1

- Fixed an issue in Windows with code_text

### 4.17.8.0

- Officially Support SWT FileDialog with the `file_dialog` keyword (was unofficially supported before via standard SWT)
- Officially Support SWT DirectoryDialog with the `directory_dialog` keyword (was unofficially supported before via standard SWT)
- Hello, File Dialog! Sample
- Hello, Directory Dialog! Sample
- Prevent tree items data-binding from updating if no tree data change occurred
- Performance optimization for `code_text` syntax highlighting through caching

### 4.17.7.0

- `checkbox_group` built-in custom widget
- Hello, Checkbox Group! Sample
- Refactor `radio_group` to render labels instead of relying on radio button text since they are better stylable
- Refactor Glimmer Meta-Sample to use `radio_group` instead of `radio`
- Fix issue with ExpandBar fill_layout with the extra element at the end (remove it)

### 4.17.6.0

- New `radio_group` built-in Glimmer custom widget
- Hello, Radio! Sample
- Hello, Radio Group! Sample
- Hello, Checkbox! Sample

### 4.17.5.0

- Support auto-scaling by aspect ratio of width and height (write specs)
- Support SWT ExpandBar via expand_bar keyword
- Hello, Expand Bar! Sample
- Hello, Styled Text! Sample
- Use expand_bar in Glimmer Meta-Sample

### 4.17.4.2

- Support StyledText data-binding of caret_offset, selection_count, selection, top_index, and top_pixel, useful for code_text
- Support `width, height` hash options for ImageProxy and image properties on widgets
- Default SWT styles for tool_bar (:border) and tool_item (:push)

### 4.17.4.1

- Optimize code_text line style listener algorithm or avoid setting code_text style via listener for performance reasons
- Optimize code_text syntax highlighting by not lexing except when content changes (e.g. during scrolling, do not lex)

### 4.17.4.0

- Glimmer sample app to launch samples (sample of samples meta-sample)
- Syntax Color Highlighting in meta-sample
- Make sash_form weights accept splat array elements (not wrapped in [])
- Make sash_form weights not get set till the closing of the sash_form (to allow putting it above content instead of below as originally required by SWT)
- Replace dependency on tty-markdown gem with dependency on rouge gem instead
- Remove rake tasks `sample:list`, `sample:code` and `sample:run`
- Add rake task `samples` to point to the new Glimmer Meta-Sample
- Have meta-sample load samples from gems

### 4.17.3.0

- `glimmer scaffold:desktopify[appname,website]` Mac
- `glimmer scaffold:desktopify[appname,website]` Windows
- `glimmer scaffold:desktopify[appname,website]` Linux (have scaffolding include the glimmer-cw-browser-chromium gem in scaffolded app on Linux)
- Remove the native packaging from Linux scaffolding since it is not officially supported
- Add gem packaging as part of scaffolding on Linux
- Launch the app at the end of scaffolding in Linux
- Provide a `glimmer package:gem` task
- Add support for scaffolding "app/scaffolded_app/launch" and "lib/namespace/custom_shell/launch" to enable launching SWT apps in Glimmer DSL for Opal without changing a line of code
- Add a binary executable shell in "app" mode (just like "custom shell gem" mode)
- Have glimmer packaging check the Java version and give a warning if an unsupported version is used.


### 4.17.2.4

- New `glimmer run` glimmer command task.
- Add built in support for handling jar file paths like that in ImageProxy code processing "uri:classloader" path
- Document that gif background_image only works without on_top and no_trim styles in Windows
- Give a good error message when Git is not properly setup for Glimmer Scaffolding
- Give an error message when attempting to scaffold over an already scaffolded directory
- Fix issue on Windows regarding use of the new EXPERIMENTAL Animated gif support in the `composite#background_image` property
- Fix SWTProxy.deconstruct method


### 4.17.2.3

- Maintain image file path upon scaling an ImageProxy
- Add a glimmer rake task that wraps the juwelier rake gemspec:generate task
- Accept `ImageProxy` as arg for `image` and `background_image` property methods
- (EXPERIMENTAL) Animate gif images when set as a `background_image` on a `composite`
- Fix issue with table redraw after data-binding changes leaving old removed table items visible (even if user cannot interact with anymore)
- Fix issue with running package rake task from `glimmer` command TUI

### 4.17.2.2

- Small updates/refactorings in samples
- Fix issue with displaying `glimmer` command tasks on Windows

### 4.17.2.1

- Add `--bundler=group` option to `glimmer` command
- Add `--pd` option to `glimmer` command
- Hello, Custom Widget! sample
- Hello, Custom Shell! sample

### 4.17.2.0

- `glimmer` command --bundler option to run with bundler/setup (instead of picking gems directly)
- Remove Gemfile dependency on Juwelier since it does not relate to GUI (delaying install of it till scaffolding)
- Remove Gemfile dependency on Warbler since it does not relate to GUI (delaying install of it till packaging)
- Move Package and Scaffold classes under Glimmer::RakeTask (Glimmer::Package.javapackager_extra_args is now Glimmer::RakeTask::Package.javapackager_extra_args)
- Fixed issue with scaffolding spec/spec_helper.rb with Juwelier (since it changed from Jeweler)

### 4.17.1.1

- Fixed issue with showing glimmer command tasks twice

### 4.17.1.0

- Switch to Juwelier gem (from Jeweler)
- Load samples from Glimmer gems automatically (no need for configuration)
- Empty body validation in CustomWidget (and CustomShell by inheritance)
- require 'bundler/setup' in `glimmer` command if a `Gemfile` is present (disabled with GLIMMER_BUNDLER_SETUP=false env var)
- Upgrade to rvm-tui version 0.2.2

### 4.17.0.0

- Upgrade to SWT (Standard Widget Toolkit) 4.17 and sync version with SWT going forward
- Upgrade to Glimmer (DSL Engine) 1.0.0
- Sync version number with the SWT version number (first two numbers, leaving the last two as minor and patch)

### 0.6.9

- Log error messages when running inside sync_exec or async_exec (since you cannot rescue their errors from outside them)
- Exclude gladiator from required libraries during sample listing/running/code-display
- Ensured creating a widget with swt_widget keyword arg doesn't retrigger initializers on its parents if already initialized
- Extract `WidgetProxy#interpret_style` to make it possible to extend with further styles with less code (e.g. CDateTimeProxy adds CDT styles by overriding method)

### 0.6.8

- Support external configuration of `WidgetProxy::KEYWORD_ALIASES` (e.g. `radio` is an alias for `button(:radio)`)
- Support external configuration of `Glimmer::Config::SAMPLE_DIRECTORIES` for the `glimmer sample` commands from Glimmer gems

### 0.6.7

- Fix issue with re-initializing layout for already initialized swt_widget being wrapped by WidgetProxy via swt_widget keyword args
- Change naming of scaffolded app bundle for mac to start with a capital letter (e.g. com.evernote.Evernote not com.evernote.evernote)

### 0.6.6

- Add User Profile sample from DZone article
- Colored Ruby syntax highlighting for sample:code and sample:run tasks courtesy of tty-markdown
- Support `check` as alias to `checkbox` DSL keyword for Button widget with :check style.
- Validate scaffolded custom shell gem name to ensure it doesn't clash with a built in Ruby method
- GLIMMER_LOGGER_ASYNC env var for disabling async logging when needed for immediate troubleshooting purposes
- Fix issue with table equivalent sort edge case (that is two sorts that are equivalent causing an infinite loop of resorting since the table is not correctly identified as sorted already)

### 0.6.5

- Added the [rake-tui](https://github.com/AndyObtiva/rake-tui) gem as a productivity tool for arrow key navigation/text-filtering/quick-triggering of rake tasks
- Use rake-tui gem in `glimmer` command by default on Mac and Linux

### 0.6.4

- Display glimmer-dsl-swt gem version in glimmer command usage
- Include Glimmer Samples in Gem and provide access via `glimmer samples:list`, `glimmer samples:run`, and `glimmer samples:code` commands
- Fix issue with glimmer not listing commands in usage without having a Rakefile
- Fix issue with passing --log-level or --debug to the `girb` command

### 0.6.3

**Scaffolding:**

- Add mnemonic to Preferences menu in scaffolding
- Make bin/glimmer, bin/girb, and scaffolded bin/script files call jruby instead of ruby in the shebang
- Launch scaffolded app on Linux without using packaging (via `glimmer bin/app_script`)
- Add all of Mac, Windows, and Linux icons upon scaffolding (not just for the OS we are on)

**Packaging:**

- Perform gemspec:generate first during packaging
- Ensure lock_jars step happens before package:jar to have vendor jar-dependencies packaged inside JAR file
- Change lock_jar vendor-dir to vendor/jars and add it to .gitignore
- Handle naming of -Bwin.menuGroup properly for Windows in scaffolded custom shell gems (and apps) (e.g. instead of Glimmer Cs Timer set to Timer only or namespace when available in a CustomShell)
- Support passing javapackager extra args after `glimmer package:native` command inside double-quotes (e.g. `glimmer package:native "-title 'CarMaker'"`)
- JDK14 experimental `jpackage` support as a packaging alternative to `javapackager` (Not recommended for production use and must specify JDK8 as JRE with an additional option since SWT doesn't support JDK14 yet)

**GUI:**

- Add radio and checkbox table editors
- Add `content` method to DisplayProxy
- Add `content` method to MessageBox
- WidgetProxy now supports taking a fully constructed swt_widget argument instead of init_args

**CI:**

- Add Windows to Travis-CI

**Issues:**

- Fix issue with TableProxy editor rejecting false and nil values set on items
- Fix issue with message_box getting stuck upon closing when no parent in its args
- Fix transient issue with git bash not interpretting glimmer package[msi] as a rake task (yet as packages instead as it resolves [msi] by picking s to match packages local directory)
- Fix issue with getting "Namespace is required!" when running `glimmer scaffold[app_name]` or `glimmer scaffold:gem:customshell[name,namespace]` (https://github.com/AndyObtiva/glimmer/issues/5)

### 0.6.2

- Set default margins on layouts (FilLayout, RowLayout, GridLayout, and any layout that responds to marginWidth and marginHeight)
- Have scrolled_composite autoset min width and min height based on parent size
- Add `radio`, `toggle`, `checkbox`, and `arrow` widgets as shortcuts to `button` widget with different styles
- Add parent_proxy method to WidgetProxy
- Add post_add_content hook method to WidgetProxy
- Add `image` keyword to create an ImageProxy and be able to scale it
- Fix issue with ImageProxy not being scalable before swt_image is called

### 0.6.1

- Lock JARs task for jar-dependencies as part of packaging
- Add 'vendor' to require_paths for custom shell gem
- Add Windows icon to scaffold
- Generate scaffolded app/custom-shell-gem gemspec as part of packaging (useful for jar-dependencies)
- Support a package:native type option for specifying native type
- Add a preferences menu for Windows (since it does not have one out of the box)
- Fix app scaffold on Windows by having it generate jeweler gem first (to have gemspec for jar-dependencies)
- Fix girb for Windows

### 0.6.0

- Upgrade to JRuby 9.2.13.0
- Upgrade to SWT 4.16
- Support `font` keyword
- Support cursor setting via SWT style symbols directly
- Support `cursor` keyword

### 0.5.6

- Fixed issue with excluding on_swt_* listeners from Glimmer DSL engine processing in CustomWidget
- Add shell minimum_size to Tic Tac Toe sample for Linux

### 0.5.5

- Add 'package' directory to 'config/warble.rb' for packaging in JAR file
- Fix issue with image path conversion to imagedata on Mac vs Windows

### 0.5.4

- Fix issue with uri:classloader paths generated by JRuby when using File.expand_path inside packaged JAR files

### 0.5.3

- Set widget `image`/`images` property via string file path(s) just like `background_image`

### 0.5.2

- Added :full_selection to table widget default SWT styles

### 0.5.1

- Made packaging -BsystemWide option true on the Mac only

### 0.5.0

- Upgrade to glimmer 0.10.1 to take advantage of the new logging library
- Make Glimmer commands support acronym, dash and no separator (default) alternatives
- Support scaffold commands for gems with `scaffold:gem:cw` pattern (`cs` as other suffix)
- Support listing commands with `list:gems:cw` pattern (`cs` as other suffix)
- Add -BinstalldirChooser=true / -Bcopyright=string / -Bvendor=string / -Bwin.menuGroup=string to Package class to support Windows packaging
- Configure 'logging' gem to generate log files on Windows/Linux/Mac and syslog where available
- Configure 'logging' gem to do async buffered logging via a thread to avoid impacting app performance with logging
- Make GLIMMER_LOGGER_LEVEL env var work with logging gem
- Update all logger calls to be lazy blocks
- Add logging formatter (called layout in logging library)
- Support legacy rake tasks for package and scaffold (the ones without gem/gems nesting)
- GLIMMER_LOGGER_LEVEL env var disables async logging in logging gem to help with immediate troubleshooting
- Create 'log' directory if :file logging device is specified
- Remember log level when reseting logger after the first time
- Dispose all tree items when removed
- Dispose all table items when removed
- Remove table model collection observers when updating
- Make message_box instantiate a shell if none passed in
- Eliminate unimportant (false negative) log messages getting reported as ERROR when running test suite
- Sort table on every change to maintain its sort according to its sorted column

### 0.4.1

- Fixed an issue with async_exec and sync_exec keywords not working when used from a module that mixes Glimmer

### 0.4.0

- Support SWT listener events that take multiple-args (as in custom libraries like Nebula GanttChart)
- Drop on_event_* keywords in favor of on_swt_* for SWT constant events
- Remove Table#table_editor_text_proxy in favor of Table#table_editor_widget_proxy
- Set WidgetProxy/ShellProxy/DisplayProxy data('proxy') objects
- Set CustomWidget data('custom_widget') objects
- Set CustomShell data('custom_shell') objects
- Delegate all WidgetProxy/ShellProxy/DisplayProxy/CustomWidget/CustomShell methods to wrapped SWT object on method_missing

### 0.3.1

- Support multiple widgets for editing table items

## 0.3.0

- Update API for table column sorting to pass models not properties to sorting blocks
- Support table multi-column sort_property
- Support table additional_sort_properties array
- Display table column sorting direction sign
- Update Scaffold MessageBox reference to message_box DSL keyword
- Fix issue with different sorting blocks not reseting each other on different table columns

## 0.2.4

- Make table auto-sortable
- Configure custom sorters for table columns
- Support for ScrolledComposite smart default behavior (auto setting of content, h_scroll/v_scroll styles, and horizontal/vertical expand)

## 0.2.3

- Upgraded to Glimmer 0.9.4
- Add vendor directory to warble config for glimmer package command.
- Make WidgetProxy register only the nearest ancestor property observer, calling on_modify_text and on_widget_selected for widgets that support these listeners, or otherwise the widget specific customizations
- Add glimmer package:clean command
- Make scaffolding gems fail when no namespace is specified
- Add a hello menu samples

## 0.2.2

- Support Combo custom-text-entry data-binding
- Remove Gemfile.lock from .gitignore in scaffolding apps/gems

## 0.2.1

- Support latest JRuby 9.2.12.0
- Support extra args (other than style) in WidgetProxy just like ShellProxy
- Specify additional Java packages to import when including Glimmer via Glimmer::Config::import_swt_packages=(packages)
- Add compatibility for ActiveSupport (automatically call ActiveSupport::Dependencies.unhook! if ActiveSupport is loaded)
- Fix bug with table items data binding ignoring bind converters

## 0.2.0

- Simplified Drag and Drop API by being able to attach drag and drop event listener handlers directly on widgets
- Support drag and drop events implicitly on all widgets without explicit drag source and drop target declarations
- Set drag and drop transfer property to :text by default if not specified
- Automatically set `event.detail` inside `on_drag_enter` to match the first operation specified in `drop_target` (make sure it doesn't cause problems if source and target have differnet operations, denying drop gracefully)
- Support `dnd` keyword for easily setting `event.detail` (e.g. dnd(:drop_copy)) inside `on_drag_enter` (and consider supporting symbol directly as well)
- Support Drag and Drop on Custom Widgets
- Fix hello_computed.rb sample (convert camelcase to underscore case for layout data properties)

## 0.1.3

- Added 'org.eclipse.swt.dnd' to glimmer auto-included Java packages
- Updated Tic Tac Toe sample to use new `message_box` keyword
- Add DragSource and DropTarget transfer expression that takes a symbol or symbol array representing one or more of the following: FileTransfer, HTMLTransfer, ImageTransfer, RTFTransfer, TextTransfer, URLTransfer
- Set default style DND::DROP_COPY in DragSource and DropTarget widgets
- Support Glimmer::SWT::DNDProxy for handling Drop & Drop styles
- Implemented list:* rake tasks for listing Glimmer custom widget gems, custom shell gems, and dsl gems
- Support querying for Glimmer gems (not just listing them)
- Fix bug with table edit remaining when sorting table or re-listing (in contact_manager.rb sample)
- Update icon of scaffolded apps to Glimmer logo

## 0.1.2

- Extracted common model data-binding classes into glimmer

## 0.1.1

- Fixed issue with packaging after generating gemspec
- Fixed issue with enabling development mode in glimmer command

## 0.1.0

- Extracted Glimmer DSL for SWT (glimmer-dsl-swt gem) from Glimmer
