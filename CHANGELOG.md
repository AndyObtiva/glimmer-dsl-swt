# Change Log

## 0.2.4

- Make table auto-sortable
- Support for ScrolledComposite smart default behavior

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
