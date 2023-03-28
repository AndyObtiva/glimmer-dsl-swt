# Change Log

## 4.27.0.1

- Avoid displaying confusing "No such file or directory" message when scaffolding fails due to missing GitHub user configuration (by displaying a friendly message for when either GitHub user or Git user is missing)

## 4.27.0.0

- Upgrade to SWT 4.27
- Upgrade to jruby-9.3.10.0

## 4.26.0.1

- Fix an issue that prevented data-binding the `image` widget property using Shine syntax (e.g. `image <= [model, :attr]` inside `tool_item`)

## 4.26.0.0

- Upgrade to SWT 4.26
- Ensure that scaffolded custom widget (red label) uses SWT constants passed to custom widget
- Update sash form weights in Meta Sample for bigger monitors (give more space to code)
- Pass border to multi-line lists since it will not be included by default anymore given they are overridden with :multi SWT style

## 4.25.0.2

- Fix issue with Hello, Label! crashing because image width is getting passed as 0 and the new SWT 4.25 ImageData API rejecting it as not a valid argument

## 4.25.0.1

- Contact Manager Create Button and Table Delete Menu Item
- Make default table sorting behavior for strings case-insensitive

## 4.25.0.0

- Upgrade to SWT 4.25
- Upgrade to JRuby 9.3.8.0
- Upgrade to JDK 19
- Make `:edge` the default SWT style for `browser` widget on Windows (Microsoft Edge Browser)
- Fix Hello, Tool Bar! look in Linux

## 4.24.4.8

- Optimize `refined_table` sorting to avoid re-running upon navigating pages
- Fix issue with `refined_table` sorting breaking page remembering behavior upon entering a filter query

## 4.24.4.7

- Optimize performance of `refined_table` in filtering (it now caches results and replays them) and pagination (it now remembers last query page and avoids refiltering when paginating on the same query value)
- Improve `combo` `selection` data-binding by auto-converting `_options` values to `String` before setting as `Item`s on `combo` (e.g. in case `Integer` values were set like years)

## 4.24.4.6

- Support `refined_table` sorting (now clicking on headers sorts the entire `model_array` collection, not just the visible rows)
- Support `table` `no_sort` attribute to disable sorting in general if needed
- Fix issue with Tetris sample upon restart of game (WidgetProxy#shell_proxy method was failing for being disposed, now it retains a reference to parent that stays if disposed)

## 4.24.4.5

- Support `refined_table` `:editable` SWT style and `model_array` bidirectional data-binding
- Update Hello, Refined Table! to allow editing the table
- Support `Glimmer::UI::CustomWidget`/`Glimmer::UI::CustomShell` support for `swt_style_symbols` read-only attribute to access array of SWT style symbols (works better than `swt_style` because some widgets support custom Glimmer-only SWT style symbols not originally supported by SWT)

## 4.24.4.4

- Support `refined_table` `selection` data-binding
- Remove extra horizontal/vertical margins in `refined_table` pagination area
- Update Hello, Refined Table! to support booking a game with right-click pop up context menu
- Have `Glimmer::UI::CustomWidget` better delegate listners and data-binding observers to `@children_owner` when set

## 4.24.4.3

- Fix issue with failed `table` extra property data-binding (e.g. foreground color, background color) due to asynchronous multi-threading optimization (now it works).

## 4.24.4.2

- `refined_table` filtering support
- Ensure correct `refined_table` enablement of pagination buttons based on whether on first/last page or not
- Display vertical scroll bar when setting `refined_table` `per_page` to a height value that results in table exceeding screen height
- Support `refined_table` nested elements `first_button {}`, `previous_button {}`, `page_text {}`, `next_button {}`, `last_button {}` to customize every widget within.
- Support `refined_table` attributes for accessing nested elements: `table_proxy`, `first_button_proxy`, `previous_button_proxy`, `page_text_proxy`, `next_button_proxy`, `last_button_proxy` to customize every widget within.

## 4.24.4.1

- Optimize `table` data-binding performance (improving paging performance in `refined_table`) by making observer registrations run asynchronously in a separate thread
- Fix cleaning of old `table` data-binding observers (it was retaining some old observers after table updates)
- Fix issue with ActiveSupport overriding Facets String `underscore`/`snakecase`/`titlecase`/`camelcase` methods with different incompatible implementations when loaded by a project (now, that is repaired automatically)

## 4.24.4.0

- `refined_table` custom widget with pagination support (and future filtering support)
- Hello, Refined Table! sample demonstrating `refined_table`
- Save `WidgetBinding` instances on `WidgetProxy` objects via `widget_bindings` attribute
- Support specifying `@children_owner` in any custom widget for which adding children will not add them under the `body_root` (e.g. a composite wrapping a table will designate the table as the `@children_owner` for adding `table_column`s)
- Add explicit `shell_proxy` method to `Glimmer::UI::CustomWidget` that delegates to `body_root` to avoid annoying false negative error every time that method is called
- Optimize `table` data-binding performance for single-model update scenarios
- Fix issue with data-binding a table as the body root of a custom widget when customizing column_attributes

## 4.24.3.2

- Have `table` data-binding infer model attribute names from column names by convention (no need to specify `column_properties`)
- Support `table` data-binding `column_properties` mapping of column names to model attribute names via a `Hash`
- Support `table` data-binding alias of `column_attributes` in place of `column_properties` because the word 'attribute' is more Ruby-idiomatic than 'property' in the Ruby world
- Handle boundary condition of font height reaching 0 on repeated zoom out of `code_text`
- Battleship Video Tutorial in Glimmer Meta-Sample

## 4.24.3.1

- `code_text` default behavior support of zoom in (CMD+= on Mac, CTRL+= on Win/Linux), zoom out (CMD+- on Mac, CTRL+- on Win/Linux), and restore original font height (CMD+0 on Mac, CTRL+0 on Win/Linux).

## 4.24.3.0

- Support `table` `items` data-binding of table row cell `background`, `foreground`, `font`, `image` to model attributes by convention based on specified `column_properties` (e.g. for `column_properties` model `name` attribute, automatically assume model `name_background` provides `[r, g, b]` array of color)
- Update Hello, Table! sample to demonstrate data-binding `table` `items` `background`, `foreground`, `font`, `image` to model attributes by convention, and to add `booked` attribute on `BaseballGame` to disable Book button when already booked
- Update Hello, Table! sample to add `booked` attribute to `BaseballGame` to disable Book button when already booked
- Update Hello, Table! sample to enable booking by hitting the ENTER keyboard button
- Optimize `table` data-binding performance by not recreating table-items when the table grows or stays at the same size, and by not updating a table item (row) when no changes have occurred (detect through diffing)
- Update `font` keyword and `FontProxy` to support lightweight creation/caching/sharing following Flyweight Design Pattern

## 4.24.2.3

- Default `code_text` font name in Mac is changed back to `'Courier'`

## 4.24.2.2

- Upgrade to jruby-9.3.7.0
- `code_text` can use external Rouge custom themes similar to `ext/rouge/themes/glimmer_dark`. When in Dark Mode, the specified custom theme must have the word 'dark' in its name to avoid forcing the `glimmer_dark` theme instead as per default behavior.
- Look for 'Monospace' and 'Liberation Mono' fonts on Linux if 'Courier' is not available
- Fix issue discovered in Red Hat Linux related to ImageExpression getting loaded before others and missing `require 'glimmer/dsl/parent_expression'` statement (issue does not happen in other operating systems that load classes in a different order)

## 4.24.2.1

- Fix mistake of changing all themes to dark themes in Hello, Code Text! (not it works just like before)

## 4.24.2.0

- Update `code_text` to support Dark Mode with `glimmer_dark` theme, which is applied by default when app is run with OS in dark mode
- Fix issue with `code_text` showing gibberish on Linux when Courier & Consolas fonts are not available. It will attempt to use the first Monospace font it finds now or otherwise stick to the default font.
- Update Hello, Code Text! and Glimmer Meta-Sample to support Dark Mode
- Refactor Hello, Custom Widget! with on_widget_disposed thread cleanup code
- Refactor Hello, Custom Shell! to support keyboard display of emails by hitting ENTER/SPACE after selecting a table row

## 4.24.1.3

- Fix Windows freezing issue with warbler during packaging with the `glimmer package` command (caused by bundler included in JRuby on JDK18, fixed by installing latest bundler)

## 4.24.1.2

- Fix issue where you cannot call `tab_item_proxy.text` or `tab_item_proxy.text = 'new text'` because its `swt_widget` is the contained `composite`
- Refactor Parking sample to clarify rotation details

## 4.24.1.1

- Fix `jar-dependencies` gem version to v0.4.1 in scaffolded applications to avoid issue encountered in newly released v0.4.2

## 4.24.1.0

- Upgrade to JRuby 9.3.6.0
- Speed up app scaffolding by dropping packaging from the scaffolding steps as there is no point in packaging an unfinished product
- Refactor/simplify Hello, Canvas Path!

## 4.24.0.2

- Update Hello, Canvas Data-Binding! to support quadratic bezier curves, cubic bezier curves, and Drag & Drop of endpoints / control points
- Fix issue with data-binding `quad` & `cubic` path shape `point_array`

## 4.24.0.1

- Support declaratively setting shape data via `data` property
- Update Hello, Canvas Drag and Drop! sample to set data in draggable shapes for a more sophisticated drag and drop example
- Refactor Game of Life sample
- Hello, Drag and Drop!, Hello, Canvas Drag and Drop!, and Game of Life Video Tutorials added to Glimmer Meta-Sample

## 4.24.0.0

- Upgrade to SWT 4.24

## 4.23.1.5

- Refactor/Improve the Hello, Cursor! sample
- Add Hello, Cursor! video tutorial to Glimmer Meta-Sample

## 4.23.1.4

- Improve convenience by making `sash_form` accept `orientation` with SWT style symbols directly (`:horizontal` directly instead of `swt(:horizontal)`)
- Improve convenience by making `sash_form` accept `maximized_control` as Glimmer DSL for SWT widget proxy instead of low-level SWT widget (`@label` instead of `@label.swt_widget`)
- Update Hello, Sash Form! to add Sash Color and simplify with new `sash_form` improvements

## 4.23.1.3

- Update initial tab folder width in Weather sample
- Add Help menu to scaffolded apps/gems with About menu item that used to be in the scaffolded File menu
- Fix names of icons generated for custom shell gems to get them picked up by the `glimmer package` command
- Fix issue with shell not packing layout correctly on initial open (might be caused by the latest version of SWT under certain scenarios)
- Fix setting of Display app_name and app_version in scaffolded apps and custom shells

## 4.23.1.2

- Add Hello, Pop Up Context Menu! video tutorial to Glimmer Meta-Sample
- Add Hello, Menu Bar! video tutorial to Glimmer Meta-Sample
- Add Language & Country menus to Hello, Menu Bar!
- Fix "Last Name" label in Hello, Tree! (was a duplicate "First Name" by mistake)

## 4.23.1.1

- Switch order of buttons in Glimmer Meta-Sample to put Tutorial first
- Make Glimmer Meta-Sample pull list of tutorials from GitHub to avoid needing to update gem when adding new tutorials

## 4.23.1.0

- Upgrade to JRuby 9.3.4.0
- Upgrade to glimmer 2.7.3
- Add "Tutorial" button to Glimmer Meta-Sample to show Youtube Video Tutorial

## 4.23.0.1

- Add "Speed" menu to the Tetris sample
- Add "Show Next Block Preview" View menu item to the Tetris sample
- Document Glimmer::UI::Application alias for Glimmer::UI::CustomShell

## 4.23.0.0

- Upgrade to SWT 4.23
- Upgrade to JDK 18

## 4.22.2.6

- Fix issue whereby updating `string` property on the `text`/`string` shape does not trigger a redraw on the shape because the text dimensions remained the same despite the change of content (e.g. switching from `string` content of letter `A` to `S` results in the same dimensions)
- Canvas Shape DSL graduated from Beta to Final

## 4.22.2.5

- Update all samples to match the [GLIMMER_STYLE_GUIDE.md](/docs/reference/GLIMMER_STYLE_GUIDE.md)
- Update scaffolding code to match the [GLIMMER_STYLE_GUIDE.md](/docs/reference/GLIMMER_STYLE_GUIDE.md)

## 4.22.2.4

- Address the warning regarding using Ruby singletons on Java objects (shows up when running `glimmer samples`)
- Fix order of calling `require 'app_name/view/app_view'` in scaffolded app (must be last)

## 4.22.2.3

- Support `#content { }` on `layout_data`
- Fix issue with data-binding `layout_data {exclude}` property using Shine `<=>` syntax

## 4.22.2.2

- Snake elaborate sample
- Fixed `timer_exec(time_in_millis) {}` expresion

## 4.22.2.1

- Upgrade to glimmer 2.6.0
- Fixed issue of `"unsupported Java version "17", defaulting to 1.7"` when scaffolding an application

## 4.22.2.0

- Upgrade to JRuby 9.3.3.0 (supporting ARM64/AARCH64)

## 4.22.1.2

- Fix support for ARM64 on Mac
- Upgrade to glimmer v2.5.5, reusing newly added Glimmer::DSL::ShineDataBindingExpression
- Include .gladiator-scratchpad in scaffolded app/gem .gitignore
- `ShellProxy#center_in_display` as alias to `#center_within_display`

## 4.22.1.1

- Fix minor issue with Shape listener disposal
- Fix minor issue with Quarto not displaying help message box after game over

## 4.22.1.0

- New Quarto game sample: https://en.gigamic.com/game/quarto-classic
- Make Klondike Solitaire (sample) playing cards bigger to be more readable and make tableau slightly taller
- Update Hello, Custom Widget! sample with a custom listener example
- Optimize performance of `glimmer` command to be exactly as fast as using `jruby` directly by avoiding calling `jgem` or loading `rake`/`Rakefile` when not needed
- Remove `logging` gem dependency, improving startup time (still available as an option as per [docs/reference/GLIMMER_CONFIGURATION.md](/docs/reference/GLIMMER_CONFIGURATION.md)).
- Ensure that setting both `Shape` `drag_source true` and `drag_and_move true` results in the last one winning (they are mutually exclusive)
- Default `text` shape to flags: `[:draw_transparent, :draw_delimiter]` to handle newline delimiter correctly when sizing text extent automatically (e.g. when passing width/height 2nd/3rd args as `:default` or not passing at all)
- Remove `" - App View"` from shell title in `desktopify` scaffolding mode
- Remove SWT Chromium browser option since it is no longer supported by SWT.
- Support being able to hook listeners on a shape directly via Shape#on_event calls
- Support Shape#on_shape_disposed listener
- Automatic display listener disposal upon disposing a custom shape (for listeners defined in before_body/after_body of custom shape)
- Ensure deregistering drag & drop listeners from shapes with `drag_source=true`/`drag_and_move=true` when they are disposed
- Support `Shape#transform_point(x, y)` by applying current `transform` to point (similar to existing opposite: `inverse_transform_point`)
- Look into forwarding options for `CustomShape#dispose(...)` to `body_root` `Shape#dispose(...)` (e.g. `.dispose(dispose_images: true, dispose_patterns: true, redraw: true)`)
- Fix Linux-only issue with JRuby 9.3.1.0 where GC#drawPolyline requires passing array of values calling array.to_java(:int) manually (it automatically converts array on other platforms and other versions of JRuby)
- Fix canvas drag and drop issue (edge case) with having multiple on drop handlers and one of them before the last one setting doit=false while a subsequent on_drop handler being able to handle the drop request but not getting a chance to
- Fix canvas drag and drop issue (edge case) with failing when dragging a custom shape by one of its deep children
- Fix slowdown issue that occurs with drag and drop in Klondike Solitaire after finishing a full game or multiple games (it seems something is accumulating in memory and slowing things down after a while.. ensure there is no caching residue relating to drag and drop)

## 4.22.0.0

- Upgrade to SWT 4.22
- Upgrade to JDK17
- Upgrade to glimmer 2.5.4
- Support new SWT 4.22 `sync_call` keyword, which is like `sync_exec`, but returns value of evaluating expression (though `sync_exec` was already enhanced by Glimmer to return the expression evaluated value just like `sync_call`)
- More work regarding: Do not clean observers when disposing of a widget while closing the last shell  (e.g. when closing an app, it is not needed to clean observers, so it is better to exit faster)
- Fix issue in Battleship sample caused by data-binding nil model, which is forbidden in glimmer 2.5.x
- Fix issue with closing Stock Ticker sample taking too long

## 4.21.2.5

- Hello, Scrolled Composite! sample

## 4.21.2.4

- Update gem `post_install_message` to clearly indicate that `-J-XstartOnFirstThread` jruby option is needed on the Mac and is handled automatically with global configuration after running `glimmer-setup`.

## 4.21.2.3

- Upgrade to glimmer 2.5.1 to fix an issue with mistakenly referencing `OpenStruct` without `'ostruct'` being loaded

## 4.21.2.2

- Demo file drag and drop in Hello, Drag and Drop!
- Make shapes added inside a widget with `:default` or `:max` dimensions auto-resize as the widget resizes
- Upgrade to glimmer 2.5.0

## 4.21.2.1

- Update Hello, Drag and Drop! to include `list`, `label`, `text`, and `spinner` examples
- Add manual and fully customizable drag and drop syntax alternatives to Hello, Drag and Drop!
- Support simpler drag and drop syntax (`drag_source true`/`drop_target true`) for simple cases concerning `list`, `label`, `text`, and `spinner`

## 4.21.2.0

- Support Linux packaging of deb/rpm native executable installers (not just gems) through standard `glimmer package` call (e.g. `glimmer package[deb]` or `glimmer package[rpm]`)
- Update `Glimmer::SWT::ImageProxy` implementation of image loading from JAR to use `JRuby.runtime.jruby_class_loader.get_resource_as_stream(file_path).to_io.to_input_stream`
- Remove scaffolding/packaging building/using of a generated Java `Resource` class
- Force installing `gem 'psych', '3.3.2'` in scaffolded app as a temporary workaround to `psych` issues with the latest jruby (jruby-9.3.1.0)

## 4.21.1.1

- Fix samples for Windows, espcially Hello, Cool Bar!, Hello, Tool Bar!, and Weather
- Fix down button for Tetris on Windows/Linux
- Fix pause menu item for Tetris

## 4.21.1.0

- Upgrade to jruby 9.3.1.0
- Upgrade to glimmer 2.4.0 (with better observing of array of arrays nested changes)
- Minor sample fixes for Linux: Tetris (down button now works), Hello, Scale! (now fits horizontally), and Hello, Slider! (now fits horizontally)
- Adjusted minimum size of Meta-Sample to allow more shrinking (`minimum_size 640, 384`)
- Do not clean observers when disposing of a widget while closing the last shell  (e.g. when closing an app, it is not needed to clean observers, so it is better to exit faster)

## 4.21.0.1

- Updated default width for `shell` to `190` (was `130` before)

## 4.21.0.0

- Upgrade to SWT 4.21
- Upgrade to JDK 16.0.2
- Upgrade to JRuby 9.3.0.0
- Update packaging to rely on JDK 16 `jpackage` (instead of older JDK 8 `javapackager`)
- Renamed `Glimmer::RakeTask::Package.javapackager_extra_args` to `Glimmer::RakeTask::Package.jpackage_extra_args` to match the name of `jpackage` in JDK 16
- Change `package/[os]` scaffolding placement for packaging icons into `icons/[os]` to accomodate Java 9 Module security for icon retrieval from within a JAR

## 4.20.15.5

- Upgrade to glimmer 2.1.5

## 4.20.15.4

- Fix issue with not tying observer registrations to custom widgets correctly automatically

## 4.20.15.3

- Updated Hello, Text! sample to have a no-border `text` widget

## 4.20.15.2

- Fixed `widget#print` support and Hello, Print Dialog! handling of cancellation of printing

## 4.20.15.1

- Glimmer Clock elaborate sample

## 4.20.15.0

- Hello, Print Dialog!
- Hello, Print!
- `widget#print` method that automates work in Hello, Print Dialog! and is used in Hello, Print!

## 4.20.14.2

- Hello, Toggle!

## 4.20.14.1

- Upgrade to Glimmer 2.1.1
- Correct Hello, Slider! sample class name

## 4.20.14.0

- Extract ObserveExpression into Glimmer
- Upgrade to Glimmer 2.1.0

## 4.20.13.18

- Change `arrow` widget default SWT style to include `:down`
- Hello, Arrow! sample

## 4.20.13.17

- Hello, Slider! sample

## 4.20.13.16

- Fix issue with setting app name (via `Display.app_name=`) when app is not packaged (always gets set to Glimmer)
- Fix Hello, Custom Shell! sample

## 4.20.13.15

- Battleship elaborate sample

## 4.20.13.14

- Connect 4 elaborate sample

## 4.20.13.13

- Parking elaborate sample
- Support shape contain?/include? when a transform (e.g. rotation) is applied

## 4.20.13.12

- Fixed issue with dragged shapes having `drag_source true` not going back to original position when not dropped in a target if they were part of a composite shape

## 4.20.13.11

- Conway's Game of Life elaborate sample

## 4.20.13.10

- Update Glimmer Style Guide, scaffolding, and samples to have `before_body` and `after_body` in custom widgets/shells/shapes always take a `do; end` block since they contain logic not visuals

## 4.20.13.9

- Update Klondike Solitaire to have playing card suit symbols and avoid clipping of cards on the boundaries

## 4.20.13.8

- Glimmer Klondike Solitaire elaborate sample

## 4.20.13.7

- Support accepting ImageProxy objects in Canvas Shape DSL (not just image paths)
- Fix issue in ImageProxy not flattening args before selecting file path

## 4.20.13.6

- Ensure a dragged shape can be dropped back into a parent it originally belonged to without it counting as a drop into itself.
- Add set_data and get_data to Glimmer::UI::CustomShape, which proxies calls to body_root

## 4.20.13.5

- Fix issue occurring with shape drag & drop when the dragged shape is a drop target too, thus getting dropped back to itself.

## 4.20.13.4

- Improved shape drag and drop checking for inclusion in drop target when there are multiple drop targets

## 4.20.13.3

- Fix issue regarding `nil` calculated_width/calculated_height encountered in Shape#contain?

## 4.20.13.2

- Support `drop_event.doit = false` to deny dropping and move dragged shape back to where it was

## 4.20.13.1

- Supporting having a `drag_source` that is dragged and not dropped at a target go back to its original position
- Fix issue of dragged shape getting obscured by ensuring that it is rendered on top of all other shapes
- Fix issue with shapes obscured by shapes on top of them getting preference when dragged (surprising behavior). Now, the top-most shapes get dragged first if they overlap with others.

## 4.20.13.0

- Shape `drag_and_move true` property to make shapes movable via dragging
- Shape `drag_source true` and `on_drop {|event| }` built-in support for drag and drop
- Refactor Hello, Canvas Drag and Drop! to use new Shape built-in support for drag and drop

## 4.20.12.4

- Update Hello, Shape! to take advantage of shape listeners (on mouse click, change color)

## 4.20.12.3

- Make Custom Shapes support on_event listeners just like Shapes
- Update Hello, Custom Shape! to take advantage of custom shape listeners (on mouse click, change color)

## 4.20.12.2

- Make Shape listeners check inclusion against all sub-shapes
- Refactor Hello, Canvas Drag & Drop! sample to use composite shapes (e.g. ball containing a ball border)

## 4.20.12.1

- Hello, Canvas Drag & Drop! sample

## 4.20.12.0

- Canvas Shape Listeners: on_mouse_up, on_mouse_down, on_mouse_move, on_drag_detected
- Make scaffolding not generate an empty () after shell
- Hello, Canvas Shape Listeners! Sample

## 4.20.11.1

- Make scaffolded app project use bundler optionally only and still load glimmer-dsl-swt otherwise, like in gem-packaged mode (`glimmer package:gem`) to avoid erroring out about bundler.

## 4.20.11.0

- Shape `#center_x`/`#center_y` methods to identify a shape's center point
- Shape `#rotate` method to rotate around center point

## 4.20.10.2

- Fix issue "Resolve 'NameError: uninitialized constant Glimmer::DataBinding' on Windows" https://github.com/AndyObtiva/glimmer-dsl-swt/issues/9 (originally in https://github.com/AMaleh/glimmer-dsl-swt/pull/1)

## 4.20.10.1

- Hello, Scale! sample.

## 4.20.10.0

- Support noun alternatives for `Canvas Transform DSL` operations:
  - `multiply(&block)` => `multiplication(&block)`
  - `invert`           => `inversion`
  - `rotate(angle)`    => `rotation(angle)`
  - `translate(x, y)`  => `translation(x, y)`

## 4.20.9.1

- Fix issue with not being able to use :default x/y location with composite/custom shapes containing lines

## 4.20.9.0

- Canvas animation fps/frame_rate property to set frames-per-second rate of rendering (alternative to every)

## 4.20.8.0

- Support data-binding Animation `duration_limit` property
- Improve support of Animation `duration_limit` property in recognizing when an animation is finished
- Added duration limit to Hello, Canvas Animation! sample

## 4.20.7.0

- Add Canvas Animation DSL #finished, #finished?, #finished= properties
- Update Hello, Canvas Animation! (formerly had Data Binding suffix)
- Update Hello, Canvas Animation Multi! (formerly did not have Multi suffix)

## 4.20.6.0

- Canvas Animation DSL: support parallel animations per canvas (running along canvas static shapes too)

## 4.20.5.2

- Identify trimmed Canvas Shape DSL attribute `fill_rule` styles without `fill_` prefix
- Identify trimmed Canvas Shape DSL attribute `line_cap` styles without `cap_` prefix
- Identify trimmed Canvas Shape DSL attribute `line_join` styles without `join_` prefix

## 4.20.5.1

- Fix issue with Namespace is required always showing up when buildling a custom widget gem or custom shape gem

## 4.20.5.0

- Relax glimmer-dsl-swt version number when scaffolding custom shape/widget/shell gems. Keep it strict for app development.
- Explicit support for `tray_item` keyword as nested under `shell`, having `menu` nested under `tray_item`, automating everything relating to using SWT TrayItem (no need to work with the Display System Tray or Menu objects manually).
- Hello, Tray Item! Sample

## 4.20.4.2

- Hello, Label!

## 4.20.4.1

- Ensure a `table` with `:editable` style loses it if `items <= ...` one-way data-binding (having read_only: true option) was setup.
- Tweak/refactor/improve samples

## 4.20.4.0

- Extracted Shine data-binding syntax and `BindExpression` to Glimmer 2

## 4.20.3.0

- Shine data-binding support for `custom widgets`, `custom shells`, and `custom shapes`
- Update remaining samples with `bind` keyword to switch to Shine data-binding syntax
- Switch scaffolded classes' data-binding to Shine
- Fix `table` Shine syntax support for unidirectional (one-way) data-binding

## 4.20.2.1

- Shine data-binding support for `animation` (also supporting `#content {}` method in `Animation`)
- Update Hello, Custom Shell! to use Shine data-binding syntax
- Fix `table` automatic sorting support when using one-way Shine data-binding syntax (which was disabling reads)

## 4.20.2.0

- Shine data-binding syntax support for `tree` widget
- Use Shine syntax in Hello, Tree! sample

## 4.20.1.0

- Shine data-binding syntax support for `table` widget
- Use Shine syntax in Hello, Table! and Contact Manager samples

## 4.20.0.5

- Hello, Text! sample
- Timer elaborate sample (copied and simplified from external sample)
- Calculator elaborate sample (copied and simplified from external sample)
- Fixed issue relating to cleaning up display listeners

## 4.20.0.4

- Weather elaborate sample

## 4.20.0.3

- Hello, Shell! sample

## 4.20.0.2

- Hello, Tool Bar! sample
- Hello, Cool Bar! sample

## 4.20.0.1

- Hello, Composite! sample
- Hello, Layout! sample
- Removed inclusion of Glimmer module in scaffolded App class since it is no longer needed with relying on SomeCustomShell.launch method

## 4.20.0.0

- Upgrade to SWT 4.20, supporting AARCH64 experimentally
- Upgrade to JRuby 9.2.19.0
- Shine syntax for data-binding
- Tweak/Fix Samples

## 4.19.0.2

- Fixed issue with Meta-Sample code editing not showing changes properly (although recording them)
- Stop Mandelbrot Fractal sample background calculation when its custom shell is closed

## 4.19.0.1

- Upgrade to JRuby 9.2.17.0
- Fix Hello, C Tab! sample not showing flags on Windows
- Fix Stock Ticker elaborate sample non-scrolling and clipped stock names on Windows

## 4.19.0.0

- Upgrade to SWT 4.19
- Upgrade to JRuby 9.2.16.0
- Speed up glimmer command startup time by not spawning a jruby a second time for handling Mac-specific options (cutting down glimmer app startup time to half)
- glimmer-setup command configures `glimmer` and `girb` for the Mac with `-X-JstartOnFirstThread` in a `JRUBY_OPTS` environment variable
- Switch all scaffolded models/views to `Model::` and `View::` namespacing instead of the namespaceless 'models' and 'views' directories (new scheme was originally introduced in the Tetris sample)
- Make sure that scaffolded shell/app uses new custom shell built-in `.launch` method instead of custom written `.open` method
- Make `scaffold:desktopify` generated app window shell fill the screen by default
- Support `c_tab_folder` and `c_tab_item`
- Support `c_combo` (`org.eclipse.swt.custom.CCombo` SWT widget) data-binding
- Hello, CCombo!
- Hello, C Tab!
- Shape#clear_shapes just like that of Drawable in WidgetProxy
- Set default background of `rgb(230, 230, 230)` on sash_form to make it more spottable to resize the sash
- Fix issue with processing arguments for the `glimmer package` command.
- Fix mandelbrot fractal sample on Windows (added missing `jruby-win32ole` gem for use with `concurrent-ruby` gem)
- Fix this `glimmer package` message, which comes out even with the right Java version: `WARNING! Glimmer Packaging Pre-Requisite Java Version 1.8.0_241 Is Not Found!`

## 4.18.7.7

- Upgrade to glimmer v1.3.0
- Handle `code_text` encountering errors in adding observation request
- Always notify widget binding observer on `async_exec: true` data-bindings

## 4.18.7.6

- Update the Hello, Code Text! sample to use data-binding
- Upgrade `puts_debuggerer` gem dependency to version 0.12.0
- Fix issue with `code_text` data-binding

## 4.18.7.5

- Update `ImageProxy` with missing methods `#size`, `#parent_proxy`, and `#parent`, needed for a better "Shapes in an Image" support.

## 4.18.7.4

- Add `glimmer scaffold:customshape[name,namespace]` command
- Add `glimmer scaffold:gem:customshape[name,namespace]` command
- Add `glimmer list:gems:customshape[keyword]` command
- Support automatic inference of `fill: true` for `path` just like other shapes
- Support `filled: true` alternative for `fill: true` Canvas Shape DSL option
- Fix issue with having to pass base_color to `bevel` custom shape in Tetris before data-binding instead of data-binding being sufficient

## 4.18.7.3

- Support the ability for nested shapes to override their parent `shape` common shared properties
- Refactor Tetris to use a custom shape (`bevel`) for its blocks given they are used in both the game and the icon, thus achieving code reuse
- Fix issue with moving filled polygon (moving drawn polygon works)

## 4.18.7.2

- Enable defining custom shapes with direct args just like basic shapes (alternative to using keyword arg options)
- Fix interpretation of `:max`/`:default` `width`/`height` values in Canvas Shape DSL

## 4.18.7.1

- Hello, Canvas Animation Data Binding! Sample
- Metronome Elaborate Sample
- Update Hello, Spinner! Sample to data bind a Thank you message to selected value

## 4.18.7.0

- Support direct use of the `shape` keyword as a shape composite that could contain other shapes and shares common attributes (e.g. background color) with all of them
- Hello, Shape! Sample (implements a method-based custom shape containing other nested shapes)
- Support custom shapes via including the Glimmer::UI::CustomShape module to add new shape keywords to the Glimmer GUI DSL / Canvas Shape DSL, representing shapes composed of a group of nested shapes (e.g. `car` shape representing a group of nested `polygon` shapes)
- Hello, Custom Shape! Sample (redoes Hello, Shape! with the use of a class-based custom shape)
- Support :max value for Canvas Shape DSL width and height, meaning fill up parent (useful for using rectangles as borders)
- Upgrade to glimmer v1.2.0

## 4.18.6.3

- Support `Glimmer::SWT::Custom::Shape::PathSegment#dispose` method
- Amend Hello, Canvas Path! sample with ability to regenerate paths
- Make `tab_folder` preinit all its tabs by default while supporting the SWT style of `:initialize_tabs_on_select` to init tabs on first select instead.
- Support trimming line style symbols (no need to say line_ before each style. e.g. `:line_solid` becomes `:solid`) in Canvas Shape DSL line_style property
- Support `antialias true` as an alternative to `antialias :on`, `antialias false` as an alternative to `antialias :off`, and `antialias nil` as an alternative to `antialias :default`

## 4.18.6.2

- Hello, Canvas Data Binding! Sample
- Update Stock Ticker sample to keep stock names visible when scrolling graphs off the screen
- `rgb` keyword tolerance of nil values (converts to 0)
- Canvas Path DSL Data-Binding
- Added `Glimmer::SWT::Custom::Shape::PathSegment` `#path` and `#root_path` API methods to enable determining what path/root-path the path segment is part of.
- Fixed issues with geometry calculation of path segments (especially line)

## 4.18.6.1

- Fixed issues with Canvas Path DSL handling of connected vs non-connected path segments (including in geometry calculations)
- Optimized Canvas Path DSL redraw performance by removing extra redraws
- Fixed issues in the Hello, Canvas Path! sample and renamed to Stock Ticker
- Added a new simpler Hello, Canvas Path! sample

## 4.18.6.0

- Canvas Path DSL support (Alpha) for `path` as drawn or filled (`fill: true`) to the Canvas Shape DSL, supporting `point`, `line` (first point is auto-derived from previous point if not specified)
- Hello, Canvas Path! sample showing a Stock Ticker with line curves for multiple company stocks, animated with randomly generated data, moving to the left out of screen second by second. Has multiple tabs demonstrating different types of paths for graphing/charting of different real world business applications: point, line, quad, cubic.
- Fix issue to allow invocation of `set_min_size` off of `scrolled_composite` proxy directly (not just swt_widget), thus taking advantage of implicit `auto_exec`
- Support `Shape#content {}` method just like `WidgetProxy#content` to enable reopening and adding nested shapes at runtime after initial construction
- Support a path containing a `quad` bezier curve with `point_array` property
- Support a path containing a `cubic` bezier curve with `point_array` property

## 4.18.5.5

- Automatically recalculate default size (width/height) to accomodate nested shapes when changing x/y/width/height sticking out of parent from right or bottom.
- Support special case of centering a nested shape with default x/y within a parent with default width/height calculated from nested shape
- Consider Canvas Shape DSL support for LineAttributes `line_dash_offset` and `line_miter_limit`
- Canvas Shape DSL Polygon `include?` does an outer/inner check of edge detection only
- Ensure all Canvas Shape DSL properties are restored upon painting a shape to what they were prior to painting that shape
- Fix issue with bringing high score dialog up in Tetris caused by latest dialog changes for supporting the new `color_dialog` and `font_dialog`

## 4.18.5.4

- Support passing width, height as :default (or nil or not passed in if they are the last args) in all shapes that include other shapes to indicate they are calculated automatically from nested shapes, text/string extent, or otherwise defaulting to 0, 0
- Support [:default, width_delta], [:default, height_delta] attributes for width and height, which add/subtract from defaults used for shape
- Switch from use of `:default` with x_delta/y_delta to passing `[:default, x_delta]` or `[:default, y_delta]` (e.g. `image(file, [:default, -30], :default)` for x = default - 30 and y = default + 0)
- Support a bounding box for all shapes, implementing `#bounds` (x, y, width, and height) and `#size` (width, height) for the ones that don't receive as parameters (like polygon)

## 4.18.5.3

- Support nesting shapes within shapes, with relative positioning (meaning x, y coordinates are assumed relative to parent's x, y in nested shapes)
- Support passing x, y coordinates as :default (or nil or not passed in if they are the last args) in all shapes, meaning they are centered within parent taking their width and height into account
- Support default_x_delta, y_delta attributes, which add/subtract from defaults used for shape

## 4.18.5.2

- Support checking if an `arc` shape accurately includes a point x,y coordinates within pie region only
- Support checking if an `oval` shape includes a point x,y coordinates in oval region only (not its rectangular region)
- Support checking if a `focus` shape includes a point x,y coordinates
- Support checking point inclusion differently in drawed vs filled Rectangle (only check the drawn border when not filled)
- Support checking point inclusion differently in drawed vs filled Oval (only check the drawn border when not filled)
- Support checking point inclusion differently in drawed vs filled Arc (only check the drawn border when not filled)
- Support `#include?(x, y)` and `#contain?(x, y)` methods in `text` shape
- Fix point inclusion check for polyline
- Fix issue with `polygon` check if it includes a point x,y coordinates (replace with available `java.awt` robust geometry algorithms)
- Fix issue with transforms not working after the latest changes

## 4.18.5.1

- Hello, Color Dialog! Sample
- Hello, Font Dialog! Sample
- Handle SWT RGB color data objects when setting colors on widgets (e.g. background)
- Enhance Hello, Canvas! with Color selector via right-click menu
- Fixed issue with tree multi selection throwing an exception

## 4.18.5.0

- Automatic `sync_exec` usage from threads other than the GUI thread, thus absolving software engineers from the need to use `sync_exec` explicitly anymore.
- `auto_exec` keyword to automatically use `sync_exec` with SWT code when needed (running from a thread other than GUI thread)
- Implement `sync_exec:` option in `bind` keyword with table, tree, combo, and list data-binding (other data-binding types than the standard)
- Add `async_exec` option to `bind` keyword (covering `data_binding_expression.rb` with `async_exec` properly)
- Support tree multi-selection data-binding
- Hello, Tree! sample
- Enhance Hello, Canvas! with Shape Movement
- Add Jars.lock to scaffold .gitignore file
- Add Glimmer::GUI alias for Glimmer::UI module, thus permitting inclusion of Glimmer::GUI::CustomWidget, Glimmer::GUI::CustomShell, and Glimmer::GUI::CustomWindow
- Provide a quick method for grabbing all available cursor/color options off of SWTProxy (SWTProxy.cursor_options, SWTProxy.cursor_styles, SWTProxy.color_options, SWTProxy.color_styles)
- Remove explicit git gem dependency given that it is installed via juwelier during scaffolding and is not needed otherwise
- Support partial image shape drawing by passing source and destination dimensions to `image` shape [documented in docs]
- Support alternate Canvas Shape DSL syntax for `image` by passing nested properties
- Canvas Shape DSL argument data-binding support for `image`
- Support alternate Canvas Shape DSL syntax for `rectangle` by passing nested properties
- Canvas Shape DSL argument data-binding support for `rectangle(x, y, width, height, fill: false)` standard rectangle, which can be optionally filled
- Canvas Shape DSL argument data-binding support for `rectangle(x, y, width, height, arcWidth = 60, arcHeight = 60, fill: false, round: true)` round rectangle, which can be optionally filled, and takes optional extra round angle arguments
- Canvas Shape DSL argument data-binding support for `rectangle(x, y, width, height, vertical = true, fill: true, gradient: true)` gradient rectangle, which is always filled, and takes an optional extra argument to specify true for vertical gradient (default) and false for horizontal gradient
- Canvas Shape DSL argument data-binding support for `arc(x, y, width, height, startAngle, arcAngle, fill: false)` arc is part of a circle within an oval area, denoted by start angle (degrees) and end angle (degrees)
- Canvas Shape DSL argument data-binding support for `focus(x, y, width, height)` this is just like rectangle but its foreground color is always that of the OS widget focus color (useful when capturing user interaction via a shape)
- Canvas Shape DSL argument data-binding support for `line(x1, y1, x2, y2)` line
- Canvas Shape DSL argument data-binding support for `oval(x, y, width, height, fill: false)` oval if width does not match heigh and circle if width matches height. Can be optionally filled.
- Canvas Shape DSL argument data-binding support for `point(x, y)` point
- Canvas Shape DSL argument data-binding support for `polygon(pointArray, fill: false)` polygon consisting of points, which close automatically to form a shape that can be optionally filled (when points only form a line, it does not show up as filled)
- Canvas Shape DSL argument data-binding support for `polyline(pointArray)` polyline is just like a polygon, but it does not close up to form a shape, remaining open (unless the points close themselves by having the last point or an intermediate point match the first)
- Canvas Shape DSL argument data-binding support for `text(string, x, y, flags = nil)` text with optional flags (flag format is `swt(comma_separated_flags)` where flags can be :draw_delimiter (i.e. new lines), :draw_tab, :draw_mnemonic, and :draw_transparent as explained in [GC API](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html))
- Update Hello, Button!, Hello, Table! sample, Hello, Checkbox Group! sample, Hello, Radio Group! sample, Hello, Combo! sample, Hello, List Single Selection! sample, Hello, List Multi Selection! sample to utilize a CustomShell
- Refactor all samples to rely on Glimmer::UI::CustomShell given its new class launch method for productive app declaration
- Fix issue with logging remaining async in debug mode
- Fix issue with combo, list, radio group, and checkbox group not supporting nested data-binding

## 4.18.4.11

- Support creating images pixel by pixel with `image(width, height) {|x,y| [r, g, b]}` keyword, which takes a block with x, y coordinates based on the image width and height and returns a pixel foreground color per point
- Add proper indentation in code_text upon hitting ENTER
- Reset Canvas Shape DSL alpha value to 255 when not explicitly set on a shape (Apply in Hello, Canvas! Sample)
- Provide terse syntax for building canvas objects (autodetecting its width and height)
- Provide terse syntax for building `:image_double_buffered` canvas objects (autodetecting its width and height):
- Center mandelbrot where mouse is clicked upon zoom
- Fix issue with Mandelbrot sample off by one error on Cores selected via Menu
- Fix use of on_events in code_text widget with lines mode true

## 4.18.4.10

- Hello, Progress Bar!
- Alias shell as window, Glimmer::UI::CustomShell as Glimmer::UI::CustomWindow, on_shell_xyz events as on_window_xyz events, and :shell_trim SWT style as :window_trim SWT Glimmer custom style
- `bind` option of `async_exec` or `sync_exec` (e.g. `bind(model, :property, async_exec: true)`) to perform GUI updates from another thread safely
- Show progress bar for Mandelbrot calculation
- Mandelbrot Cores menu options to switch the number of CPU cores being used for calculation on the next zoom calculation cycle

## 4.18.4.9

- Hello, Cursor! Sample
- Log errors that occur in widget event listener blocks to help with troubleshooting
- disposed? method for Shape objects
- Add `dispose_images: false, dispose_patterns: false` options to `Shape#dispose` to avoid disposing images/patterns when needed
- Mandelbrot background thread pre-calculation of future zoom levels
- Mandelbrot menu bar menu items
- Mandelbrot panning via scrollbars or dragging

## 4.18.4.8

- Make `image` a top-level expression keyword
- Default placing image on Canvas at coordinates 0, 0 if they are not specified (e.g. canvas {image some_image})
- Support passing in color args directly to the `pixel` keyword as an rgb value array without using the `color`/`rgb` keyword, to improve performance for large pixel counts
- Support Image Double Buffering by nesting an `image` built from shapes within a `canvas`
- Shrink image of baseball background for Hello, Table! Sample to reduce the glimmer-dsl-swt gem size (recently bloated)
- Fix issue with closing a canvas shell with pixel graphics freezing temporarily for a long time while disposing shapes
- Fix issue with disposing `image` having shapes

## 4.18.4.7

- Fixed issue with Tetris breaking with the latest Canvas Shape/Animation DSL performance optimizations

## 4.18.4.6

- Mandlebrot Fractal Elaborate Sample
- Optimize Canvas Shape/Animation DSL performance by combining multiple shapes in a single paint listener
- Memoized attribute-to-SWT-property-method-name translation
- Support a `pixel` static expression that is an optimized `point`, which takes a foreground hash property to bypass the dynamic DSL chain of responsibility

## 4.18.4.5

- Added double_buffered SWT style as default for `canvas` widget to ensure smooth animations
- Officially support `timer_exec` keyword to execute code asynchronously after time has elapsed
- Added `disposed?` guard to animation frames regarding parent widget for extra safety if a widget was disposed in the middle of an animation
- Auto-Dispose observers declared inside custom widgets and custom shells (during their construction with before_body or after_body) with the observe keyword.
- Refactor Tetris sample to remove observer deregister calls now that they happen automatically

## 4.18.4.4

- Ensure code_text line numbers text font matches that of the actual styled_text widget
- Use after_read data binding option to update top pixel in code text line numbers after updating text (ensuring top_pixel remains in sync after text changes)
- Remove unnecessary image copies in hello canvas transform and meta-sample samples

## 4.18.4.3

- Fix flashing issue when using ShellProxy#pack_same_size on Windows
- Double buffer Hello, Canvas Animation! Sample to remove flickering
- Tetris - Added `:double_buffered` SWT style for Tetris Playfield and Block to avoid rendering flicker on Windows
- Tetris - Substituted command key with control on Windows/Linux to make Tetris menu shortcuts work (e.g. CTRL+P pauses)
- Tetris - Workaround for Windows issue with  tetromino down invisibility upon holding down arrow key (now holding down does only one down)

## 4.18.4.2

- Remove Tetris Clear button from High Score dialog (since it is available via menu and is rarely used)
- Make right control button rotate right with Tetris
- Avoid adding the widget listeners for read_only data-binding (instead of just relying on ModelBinding raising exceptions)
- Clean up the meta sample code_text style by removing root composite margins/spacing
- Made background for top label of Hello, Table! transparent for Windows
- Fix `glimmer samples` command and Meta-Sample on Windows
- Fix Tetris on Windows
- Fix Hello, Canvas on Windows
- Fix Hello, Canvas Transform when launched from `glimmer samples`
- Fix Table editing write_on_cancel option use on Windows
- Fix issue with adding content to the end of a styled text widget breaking line number scrolling
- Fix issue with code_text not showing line numbers for extra new lines at the end

## 4.18.4.1

- Support data-binding of `code_text` with lines enabled.
- Upgrade the Glimmer Meta-Sample with code_text lines: {width: 2}
- With code_text lines enabled, support setting/data-binding properties on root composite via nesting `root { }` underneath
- With code_text lines enabled, support setting/data-binding properties on line numbers styled text widget via nesting `line_numbers { }` underneath
- Update the Hello, Code Text! sample to remove borders and line numbers background in the JavaScript example
- Fix issue with updating layout upon later reopening layout/layout data via `proxy.content {}` method

## 4.18.4.0

- Extract line numbers part of text_editor widget from Gladiator into Glimmer code_text and make it an option (e.g. lines: true or lines: {width: 4})
- code_text support select all via CMD+A
- code_text support end of line via CTRL+E and beginning of line via CTRL+A
- Support automatic inferrence of Canvas Shape DSL gradient option (just like fill option)
- Support automatic inferrence of Canvas Shape DSL round option (just like fill option)
- Add a background image to Hello, Table! Sample + font/color changes
- Make Canvas patterns auto-reused and auto-disposed when canvas is disposed
- Make Canvas images auto-dispose themselves when canvas is disposed
- Update Hello, Code Text!
- Change Glimmer Tetris Sample up arrow default to rotate left
- Fix issue with "undefined method lex for nil:NilClass" in `code_text`

## 4.18.3.5

- Add `write_on_cancel: true` option for TableProxy#edit_table_item to make cancel behave just like save for special cases where you cannot cancel except the edit mode itself
- Make code_text custom widget support multiple code languages via `language: 'java'` option
- Make code_text custom widget support multiple themes via `theme: 'github'` option
- Hello, Code Text! Sample
- Fix issue with High Score Dialog in Tetris Sample not sorting by scores correctly (string compare instead of numeric compare) until first game is completed
- Fix issue with setting date geting rejected in `date_time` for month or day being incompatible with the year/month/day combo

## 4.18.3.4

- Support building Image objects with the Glimmer Canvas Shape DSL
- Tetris build icon image in-game by nesting Glimmer Shape DSL syntax
- Canvas Make shapes auto-fill if you specify a background only (no need to say fill: true) or not fill if you specify a foreground only
- Tetris option to switch Up Arrow between Instant Down, Rotate Right, and Rotate Left

## 4.18.3.3

- Support Table data binding read_only_sort: true option to allow visual sorting without affecting model data
-  on_quit to
- Tetris Add lines and level to High Score Dialog
- Tetris Immediate Drop on Arrow Up
- Tetris Pause on showing High Score Dialog
- Tetris Make High Scores -> Show a check menu item
- Tetris Disable pause button upon showing High Score Dialog
- Fix Quit Tetris CMD+Q shortcut by adding on_quit event to display
- Tetris Fix escape button upon entering high score name
- If WidgetBinding encounters a disposed widget, it deregisters all observables that it is observing

## 4.18.3.2

- Tetris High Scores
- Tetris Modify High Score Player Name
- Tetris Show High Scores (Menu Item + Accelerator)
- Tetris add a menu item with beep enablement option
- Tetris Clear High Scores
- Tetris Add left and right alt (option) buttons as alternative to shift for rotation. Use left ctrl as rotate left. Use a, s, d as left, down, right.
- Fix issues relating to setting parenthood with custom widgets before building their body (instead of after)
- Fix issues relating to not respecting arity of passed in table editing callbacks: before_write, after_write, and after_cancel

## 4.18.3.1

- Provide an auto_sync_exec all data-binding config option to automatically sync_exec GUI calls from other threads instead of requiring users to use sync_exec on model attribute-change logic. Default value to false.
- Have CustomShell::launch method take options to pass to custom shell keyword invocation
- Update Glimmer Meta-Sample to load entire gem into user directory (since some new samples rely on images)
- Update Glimmer Meta-Sample to display errors in a `dialog` instead of a `message_box` to allow scrolling
- Removed newly added CustomShell::shutdown as unnecessary (could just do CustomShell::launchd_custom_shell.close)
- Supporting deregistering Display listeners just like standard listeners via deregister
- Enhance performance of excluded keyword check
- Remove CustomWidget support for multiple before_body/after_body blocks instead of one each since it is not needed.
- Add new :fill_screen style for `shell` to start app filling the screen size (not full screen mode though)
- Tetris Menu Bar with Game Menu -> Start, Pause, Restart, and Exit
- Tetris refactor mutation methods to end with bangs
- Tetris Stop game if user does not play again in the end (instead of closing it)
- End Tetris Thread loop gracefully if game over is encountered
- Tetris use more observers instead of callbacks to Game
- Turn Tetris::Model::Game class from a singleton class to a standard class supporting instances
- Fix issue of `tetris` keyword not found when run from meta-sample app

## 4.18.3.0

- Canvas Transform DSL (DSL declared Transform objects are auto-disposed after getting used by their parent shape)
- Canvas support a top-level Transform DSL fluent interface for methods that use Transform arguments manually (e.g. tr1 = transform.rotate(90).translate(0, -100))
- Hello, Canvas Transformation!

## 4.18.2.5

- ColorProxy args now are automatically fit into 0..255 bounds upon use of the `color`/`rgb`/`rgba` keywords
- Canvas Shape DSL (Property) Data-Binding support (No Argument Data-Binding support yet)
- Add a more bevel 3D look to Tetris blocks
- Use flyweight pattern with colors
- Use flyweight pattern with widget classes
- Use flyweight pattern with custom widget classes
- Optimized performance of Canvas Shape DSL
- Optimized performance of Tetris game
- Fixed issue with top-level sync_exec/async_exec use randomly bombing

## 4.18.2.4

- Tetris scoring
- Tetris eliminated Line tracking
- Tetris level tracking and speed-ups
- Tetris preview upcoming tetromino shape
- Added parent_proxy to CustomWidget and CustomShell classes
- Update CustomShell#center and ShellProxy#center to center_within_display to avoid clash with `row_layout` center property
- Fixed issue with shell/dialog/custom-shell not maintaining parent when not passed
- Fix Tetris sideways edge detection

## 4.18.2.3

- Added Tetris Elaborate Sample
- Added support for CustomShell `::launch` and `::shutdown` class methods to treat a top-level custom shell as a self contained launchable app (saving you from writing boilerplate code for launching Glimmer applications)

## 4.18.2.2

- Fixed issue with processing shape color due to missing Color class package name

## 4.18.2.1

- Ensure drawing image works in Shape DSL
- Support passing image as simply an image path or image proxy to Shape DSL image method

## 4.18.2.0

- Canvas animation start method (useful if animation had a frame count limit or cycle count limit and needed to be started again after it stopped)
- Canvas animation stop method
- Canvas animation restart method (restarts from frame 1)
- Canvas animation started? # meaning it is animating
- Canvas animation stopped? # meaning it has stopped animating
- Canvas animation duration_limit option
- Make gradient/round rectangles in Shape DSL receive an option of `gradient: true` and `round: true` instead of prefix
- Canvas Shape DSL support for Background/Foreground Pattern (NOTE: not extensively tested yet)
- Canvas Shape DSL smart defaults for background/foreground depending on shape being drawn
- Canvas Shape DSL smart defaults for fill option depending on shape being drawn
- Added fallback font "Courier" for `code_text` widget when "Consolas" is not available.

## 4.18.1.1

- Add smart defaults for round rectangle angles (defaults to 60 degrees angles)
- Add smart default for gradient rectangle vertical option
- Small update to Hello, Canvas! Sample
- Convert SWT style symbol to SWT style integer if method takes integer but receives a symbol (or string)
- Make polygon not require [] for its array args
- Allow cycle to receive splatted array as varargs
- Change references to `Display.setAppName` and `Display.setAppVersion` to `Display.app_name =` and `Display.app_version =`
- Default Glimmer app name to "Glimmer" (instead of previous "SWT") unless `Display.app_name = "Somename"` is set by consumer before instantiating first display
- Set default background to system widget background default for fill shapes
- Set default foreground to black for draw shapes
- Fix issue with shapes always requiring a block (even an empty one) to render
- Fix issue with animation requiring changes to canvas directly in addition to shapes
- Fix issue with `glimmer list:gems:dsl` command
- Fix issue with scaffolding still depending on git-glimmer despite being merged back to git gem

## 4.18.1.0

- Canvas Shape DSL
- Hello, Canvas! Sample
- Animation DSL
- Hello, Canvas Animation! Sample
- Fixed issue with async_exec not working in ShellProxy when delegate widget is nil

## 4.18.0.2

- Minor update on Hello, Dialog! Sample
- Upgrade to glimmer v1.0.7

## 4.18.0.1

- Hello, Dialog! Sample
- Added Glimmer icon to Glimmer Meta-Sample (Sample of Samples)
- Upgrade Scaffolded projects to JRuby v9.2.14.0
- Switch back to official git gem v1.8.1 now that glimmer-git gem branch is merged into it
- Fix issue with not reporting exception encountered in editing a tree item if consumer code had a bug

## 4.18.0.0

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

## 4.17.10.8

- Support editing sample code in the Glimmer Meta-Sample to enable experimentation and learning
- Add a "Reset" button to the Glimmer Meta-Sample to allow resetting sample code changes
- Refactor/revise hello_message_box.rb and hello_pop_up_context_menu.rb samples
- Upgrade to glimmer 1.0.6

## 4.17.10.7

- Loosened dependencies on most Glimmer author-owned gems
- Refactored/Simplified/Fixed Hello, Link! Sample

## 4.17.10.6

- Hello, Link! Sample
- Refactor hello list samples

## 4.17.10.5

- Hello, Button! Sample

## 4.17.10.4

- Do not select first row in a table by default (keep unselected)
- Prevented extra call to model data in table items data-binding
- Upgraded to glimmer v1.0.5

## 4.17.10.3

- Fixed issue in StyledText data-binding relating to capturing selection changes on mouse click

## 4.17.10.2

- Upgraded glimmer gem to version 1.0.4
- Fixed issues relating to data-binding `styled_text` widget

## 4.17.10.1

- Upgraded glimmer gem to version 1.0.3
- Upgraded rouge gem to version 3.25.0

## 4.17.10.0

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

## 4.17.9.0

- Add table style :editable to hook editing listener on mouse click automatically (instead of manually via on_widget_selected)
- Support table editing via `spinner` for integer values
- date_time widget official data-binding support of date_time, date, time, year, month, day, hours, minutes, and seconds
- date widget alias for date_time(:date)
- time widget alias for date_time(:time)
- calendar widget alias for date_time(:calendar)
- date_drop_down widget alias for date_time(:date, :drop_down)
- Hello, Date Time! Sample

## 4.17.8.3

- Hello, Table! Sample
- Disable editing on a column with `editor :none`
- Improve `code_text` performance immensely by only styling the lines being shown upon editing
- Fix dead spots with syntax highlighting in some files in Gladiator like file.rb

## 4.17.8.2

- Hello, Group! Sample

## 4.17.8.1

- Fixed an issue in Windows with code_text

## 4.17.8.0

- Officially Support SWT FileDialog with the `file_dialog` keyword (was unofficially supported before via standard SWT)
- Officially Support SWT DirectoryDialog with the `directory_dialog` keyword (was unofficially supported before via standard SWT)
- Hello, File Dialog! Sample
- Hello, Directory Dialog! Sample
- Prevent tree items data-binding from updating if no tree data change occurred
- Performance optimization for `code_text` syntax highlighting through caching

## 4.17.7.0

- `checkbox_group` built-in custom widget
- Hello, Checkbox Group! Sample
- Refactor `radio_group` to render labels instead of relying on radio button text since they are better stylable
- Refactor Glimmer Meta-Sample to use `radio_group` instead of `radio`
- Fix issue with ExpandBar fill_layout with the extra element at the end (remove it)

## 4.17.6.0

- New `radio_group` built-in Glimmer custom widget
- Hello, Radio! Sample
- Hello, Radio Group! Sample
- Hello, Checkbox! Sample

## 4.17.5.0

- Support auto-scaling by aspect ratio of width and height (write specs)
- Support SWT ExpandBar via expand_bar keyword
- Hello, Expand Bar! Sample
- Hello, Styled Text! Sample
- Use expand_bar in Glimmer Meta-Sample

## 4.17.4.2

- Support StyledText data-binding of caret_offset, selection_count, selection, top_index, and top_pixel, useful for code_text
- Support `width, height` hash options for ImageProxy and image properties on widgets
- Default SWT styles for tool_bar (:border) and tool_item (:push)

## 4.17.4.1

- Optimize code_text line style listener algorithm or avoid setting code_text style via listener for performance reasons
- Optimize code_text syntax highlighting by not lexing except when content changes (e.g. during scrolling, do not lex)

## 4.17.4.0

- Glimmer sample app to launch samples (sample of samples meta-sample)
- Syntax Color Highlighting in meta-sample
- Make sash_form weights accept splat array elements (not wrapped in [])
- Make sash_form weights not get set till the closing of the sash_form (to allow putting it above content instead of below as originally required by SWT)
- Replace dependency on tty-markdown gem with dependency on rouge gem instead
- Remove rake tasks `sample:list`, `sample:code` and `sample:run`
- Add rake task `samples` to point to the new Glimmer Meta-Sample
- Have meta-sample load samples from gems

## 4.17.3.0

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


## 4.17.2.4

- New `glimmer run` glimmer command task.
- Add built in support for handling jar file paths like that in ImageProxy code processing "uri:classloader" path
- Document that gif background_image only works without on_top and no_trim styles in Windows
- Give a good error message when Git is not properly setup for Glimmer Scaffolding
- Give an error message when attempting to scaffold over an already scaffolded directory
- Fix issue on Windows regarding use of the new EXPERIMENTAL Animated gif support in the `composite#background_image` property
- Fix SWTProxy.deconstruct method


## 4.17.2.3

- Maintain image file path upon scaling an ImageProxy
- Add a glimmer rake task that wraps the juwelier rake gemspec:generate task
- Accept `ImageProxy` as arg for `image` and `background_image` property methods
- (EXPERIMENTAL) Animate gif images when set as a `background_image` on a `composite`
- Fix issue with table redraw after data-binding changes leaving old removed table items visible (even if user cannot interact with anymore)
- Fix issue with running package rake task from `glimmer` command TUI

## 4.17.2.2

- Small updates/refactorings in samples
- Fix issue with displaying `glimmer` command tasks on Windows

## 4.17.2.1

- Add `--bundler=group` option to `glimmer` command
- Add `--pd` option to `glimmer` command
- Hello, Custom Widget! sample
- Hello, Custom Shell! sample

## 4.17.2.0

- `glimmer` command --bundler option to run with bundler/setup (instead of picking gems directly)
- Remove Gemfile dependency on Juwelier since it does not relate to GUI (delaying install of it till scaffolding)
- Remove Gemfile dependency on Warbler since it does not relate to GUI (delaying install of it till packaging)
- Move Package and Scaffold classes under Glimmer::RakeTask (Glimmer::Package.javapackager_extra_args is now Glimmer::RakeTask::Package.javapackager_extra_args)
- Fixed issue with scaffolding spec/spec_helper.rb with Juwelier (since it changed from Jeweler)

## 4.17.1.1

- Fixed issue with showing glimmer command tasks twice

## 4.17.1.0

- Switch to Juwelier gem (from Jeweler)
- Load samples from Glimmer gems automatically (no need for configuration)
- Empty body validation in CustomWidget (and CustomShell by inheritance)
- require 'bundler/setup' in `glimmer` command if a `Gemfile` is present (disabled with GLIMMER_BUNDLER_SETUP=false env var)
- Upgrade to rvm-tui version 0.2.2

## 4.17.0.0

- Upgrade to SWT (Standard Widget Toolkit) 4.17 and sync version with SWT going forward
- Upgrade to Glimmer (DSL Engine) 1.0.0
- Sync version number with the SWT version number (first two numbers, leaving the last two as minor and patch)

## 0.6.9

- Log error messages when running inside sync_exec or async_exec (since you cannot rescue their errors from outside them)
- Exclude gladiator from required libraries during sample listing/running/code-display
- Ensured creating a widget with swt_widget keyword arg doesn't retrigger initializers on its parents if already initialized
- Extract `WidgetProxy#interpret_style` to make it possible to extend with further styles with less code (e.g. CDateTimeProxy adds CDT styles by overriding method)

## 0.6.8

- Support external configuration of `WidgetProxy::KEYWORD_ALIASES` (e.g. `radio` is an alias for `button(:radio)`)
- Support external configuration of `Glimmer::Config::SAMPLE_DIRECTORIES` for the `glimmer sample` commands from Glimmer gems

## 0.6.7

- Fix issue with re-initializing layout for already initialized swt_widget being wrapped by WidgetProxy via swt_widget keyword args
- Change naming of scaffolded app bundle for mac to start with a capital letter (e.g. com.evernote.Evernote not com.evernote.evernote)

## 0.6.6

- Add User Profile sample from DZone article
- Colored Ruby syntax highlighting for sample:code and sample:run tasks courtesy of tty-markdown
- Support `check` as alias to `checkbox` DSL keyword for Button widget with :check style.
- Validate scaffolded custom shell gem name to ensure it doesn't clash with a built in Ruby method
- GLIMMER_LOGGER_ASYNC env var for disabling async logging when needed for immediate troubleshooting purposes
- Fix issue with table equivalent sort edge case (that is two sorts that are equivalent causing an infinite loop of resorting since the table is not correctly identified as sorted already)

## 0.6.5

- Added the [rake-tui](https://github.com/AndyObtiva/rake-tui) gem as a productivity tool for arrow key navigation/text-filtering/quick-triggering of rake tasks
- Use rake-tui gem in `glimmer` command by default on Mac and Linux

## 0.6.4

- Display glimmer-dsl-swt gem version in glimmer command usage
- Include Glimmer Samples in Gem and provide access via `glimmer samples:list`, `glimmer samples:run`, and `glimmer samples:code` commands
- Fix issue with glimmer not listing commands in usage without having a Rakefile
- Fix issue with passing --log-level or --debug to the `girb` command

## 0.6.3

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

## 0.6.2

- Set default margins on layouts (FilLayout, RowLayout, GridLayout, and any layout that responds to marginWidth and marginHeight)
- Have scrolled_composite autoset min width and min height based on parent size
- Add `radio`, `toggle`, `checkbox`, and `arrow` widgets as shortcuts to `button` widget with different styles
- Add parent_proxy method to WidgetProxy
- Add post_add_content hook method to WidgetProxy
- Add `image` keyword to create an ImageProxy and be able to scale it
- Fix issue with ImageProxy not being scalable before swt_image is called

## 0.6.1

- Lock JARs task for jar-dependencies as part of packaging
- Add 'vendor' to require_paths for custom shell gem
- Add Windows icon to scaffold
- Generate scaffolded app/custom-shell-gem gemspec as part of packaging (useful for jar-dependencies)
- Support a package:native type option for specifying native type
- Add a preferences menu for Windows (since it does not have one out of the box)
- Fix app scaffold on Windows by having it generate jeweler gem first (to have gemspec for jar-dependencies)
- Fix girb for Windows

## 0.6.0

- Upgrade to JRuby 9.2.13.0
- Upgrade to SWT 4.16
- Support `font` keyword
- Support cursor setting via SWT style symbols directly
- Support `cursor` keyword

## 0.5.6

- Fixed issue with excluding on_swt_* listeners from Glimmer DSL engine processing in CustomWidget
- Add shell minimum_size to Tic Tac Toe sample for Linux

## 0.5.5

- Add 'package' directory to 'config/warble.rb' for packaging in JAR file
- Fix issue with image path conversion to imagedata on Mac vs Windows

## 0.5.4

- Fix issue with uri:classloader paths generated by JRuby when using File.expand_path inside packaged JAR files

## 0.5.3

- Set widget `image`/`images` property via string file path(s) just like `background_image`

## 0.5.2

- Added :full_selection to table widget default SWT styles

## 0.5.1

- Made packaging -BsystemWide option true on the Mac only

## 0.5.0

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

## 0.4.1

- Fixed an issue with async_exec and sync_exec keywords not working when used from a module that mixes Glimmer

## 0.4.0

- Support SWT listener events that take multiple-args (as in custom libraries like Nebula GanttChart)
- Drop on_event_* keywords in favor of on_swt_* for SWT constant events
- Remove Table#table_editor_text_proxy in favor of Table#table_editor_widget_proxy
- Set WidgetProxy/ShellProxy/DisplayProxy data('proxy') objects
- Set CustomWidget data('custom_widget') objects
- Set CustomShell data('custom_shell') objects
- Delegate all WidgetProxy/ShellProxy/DisplayProxy/CustomWidget/CustomShell methods to wrapped SWT object on method_missing

## 0.3.1

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
