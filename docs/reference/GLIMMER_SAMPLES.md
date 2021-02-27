- [Samples](#samples)
  - [Hello Samples](#hello-samples)
    - [Hello, World!](#hello-world)
    - [Hello, Tab!](#hello-tab)
    - [Hello, Combo!](#hello-combo)
    - [Hello, List Single Selection!](#hello-list-single-selection)
    - [Hello, List Multi Selection!](#hello-list-multi-selection)
    - [Hello, Computed!](#hello-computed)
    - [Hello, Message Box!](#hello-message-box)
    - [Hello, Browser!](#hello-browser)
    - [Hello, Drag and Drop!](#hello-drag-and-drop)
    - [Hello, Menu Bar!](#hello-menu-bar)
    - [Hello, Pop Up Context Menu!](#hello-pop-up-context-menu)
    - [Hello, Custom Widget!](#hello-custom-widget)
    - [Hello, Custom Shell!](#hello-custom-shell)
    - [Hello, Sash Form!](#hello-sash-form)
    - [Hello, Styled Text!](#hello-styled-text)
    - [Hello, Expand Bar!](#hello-expand-bar)
    - [Hello, Radio!](#hello-radio)
    - [Hello, Radio Group!](#hello-radio-group)
    - [Hello, Group!](#hello-group)
    - [Hello, Checkbox!](#hello-checkbox)
    - [Hello, Checkbox Group!](#hello-checkbox-group)
    - [Hello, Directory Dialog!](#hello-directory-dialog)
    - [Hello, File Dialog!](#hello-file-dialog)
    - [Hello, Date Time!](#hello-date-time)
    - [Hello, Spinner!](#hello-spinner)
    - [Hello, Table!](#hello-table)
    - [Hello, Button!](#hello-button)
    - [Hello, Link!](#hello-link)
    - [Hello, Dialog!](#hello-dialog)
    - [Hello, Code Text!](#hello-code-text)
    - [Hello, Canvas!](#hello-canvas)
    - [Hello, Canvas Animation!](#hello-canvas-animation)
    - [Hello, Canvas Transform!](#hello-canvas-transform)
    - [Hello, Cursor!](#hello-cursor)
    - [Hello, Progress Bar!](#hello-progress-bar)
    - [Hello, Tree!](#hello-tree)
    - [Hello, Color Dialog!](#hello-color-dialog)
    - [Hello, Font Dialog!](#hello-font-dialog)
  - [Elaborate Samples](#elaborate-samples)
    - [User Profile](#user-profile)
    - [Login](#login)
    - [Tic Tac Toe](#tic-tac-toe)
    - [Contact Manager](#contact-manager)
    - [Glimmer Tetris](#glimmer-tetris)
    - [Mandelbrot Fractal](#mandelbrot-fractal)
  - [External Samples](#external-samples)
    - [Glimmer Calculator](#glimmer-calculator)
    - [Gladiator](#gladiator)
    - [Timer](#timer)
- [License](#license)

## Samples

Check the [samples](/samples) directory in [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) for examples on how to write Glimmer applications. To run a sample, make sure to install the `glimmer-dsl-swt` gem first and then use the `glimmer samples` command to run it (alternatively, you may clone the repo, follow [CONTRIBUTING.md](CONTRIBUTING.md) instructions, and run samples locally with development glimmer command: `bin/glimmer`).

You may run any sample via this command:

```
glimmer samples
```

This brings up the [Glimmer Meta-Sample (The Sample of Samples)](/samples/elaborate/meta_sample.rb)

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

You may edit the code of any sample before launching it by clicking on the "Launch" button. This helps you learn by experimenting with Glimmer GUI DSL syntax. To go back to original code, simply hit the "Reset" button.

Note that if you fail to run any sample through the Glimmer Meta-Sample for whatever reason, you could always run directly by cloning the project, running `bundle`, and then this command (drop the "bin" if you install the glimmer-dsl-swt gem instead):

```ruby
bin/glimmer samples/hello/hello_canvas_transform.rb
```

### Hello Samples

For hello-type simple samples, check the following.

#### Hello, World!

Code:

[samples/hello/hello_world.rb](/samples/hello/hello_world.rb)

![Hello World](/images/glimmer-hello-world.png)

#### Hello, Tab!

Code:

[samples/hello/hello_tab.rb](/samples/hello/hello_tab.rb)

![Hello Tab English](/images/glimmer-hello-tab-english.png)
![Hello Tab French](/images/glimmer-hello-tab-french.png)

#### Hello, Combo!

This sample demonstrates combo data-binding.

Code:

[samples/hello/hello_combo.rb](/samples/hello/hello_combo.rb)

![Hello Combo](/images/glimmer-hello-combo.png)
![Hello Combo Expanded](/images/glimmer-hello-combo-expanded.png)

#### Hello, List Single Selection!

This sample demonstrates list single-selection data-binding.

Code:

[samples/hello/hello_list_single_selection.rb](/samples/hello/hello_list_single_selection.rb)

![Hello List Single Selection](/images/glimmer-hello-list-single-selection.png)

#### Hello, List Multi Selection!

This sample demonstrates list multi-selection data-binding.

Code:

[samples/hello/hello_list_multi_selection.rb](/samples/hello/hello_list_multi_selection.rb)

![Hello List Multi Selection](/images/glimmer-hello-list-multi-selection.png)

#### Hello, Computed!

This sample demonstrates computed data-binding.

Code:

[samples/hello/hello_computed.rb](/samples/hello/hello_computed.rb)

![Hello Browser](/images/glimmer-hello-computed.png)

#### Hello, Message Box!

This sample demonstrates a `message_box` dialog.

Code:

[samples/hello/hello_message_box.rb](/samples/hello/hello_message_box.rb)

![Hello Message Box](/images/glimmer-hello-message-box.png)
![Hello Message Box Dialog](/images/glimmer-hello-message-box-dialog.png)

#### Hello, Browser!

This sample demonstrates the `browser` widget.

Code:

[samples/hello/hello_browser.rb](/samples/hello/hello_browser.rb)

![Hello Browser](/images/glimmer-hello-browser.png)

#### Hello, Drag and Drop!

This sample demonstrates drag and drop in Glimmer.

Code:

[samples/hello/hello_drag_and_drop.rb](/samples/hello/hello_drag_and_drop.rb)

![Hello Drag and Drop](/images/glimmer-hello-drag-and-drop.gif)

#### Hello, Menu Bar!

This sample demonstrates menus in Glimmer, including accelerators on the Mac.

Code:

[samples/hello/hello_menu_bar.rb](/samples/hello/hello_menu_bar.rb)

![Hello Menu Bar](/images/glimmer-hello-menu-bar.png)

![Hello Menu Bar File Menu](/images/glimmer-hello-menu-bar-file-menu.png)

The Mac Menu includes Accelerator Keys (keyboard shortcuts).

![Hello Menu Bar File Menu Mac Accelerators](/images/glimmer-hello-menu-bar-file-menu-mac-accelerators.png)

![Hello Menu Bar Edit Menu](/images/glimmer-hello-menu-bar-edit-menu.png)

The Mac Menu includes Accelerator Keys (keyboard shortcuts).

![Hello Menu Bar Edit Menu Mac Accelerators](/images/glimmer-hello-menu-bar-edit-menu-mac-accelerators.png)

![Hello Menu Bar Options Menu Disabled](/images/glimmer-hello-menu-bar-options-menu-disabled.png)

![Hello Menu Bar Options Menu Select One](/images/glimmer-hello-menu-bar-options-menu-select-one.png)

![Hello Menu Bar Options Menu Select Multiple](/images/glimmer-hello-menu-bar-options-menu-select-multiple.png)

![Hello Menu Bar Format Menu Background Color](/images/glimmer-hello-menu-bar-format-menu-background-color.png)

![Hello Menu Bar Format Menu Foreground Color](/images/glimmer-hello-menu-bar-format-menu-foreground-color.png)

![Hello Menu Bar View Menu](/images/glimmer-hello-menu-bar-view-menu.png)

![Hello Menu Bar View Small](/images/glimmer-hello-menu-bar-view-small.png)

![Hello Menu Bar View Large](/images/glimmer-hello-menu-bar-view-large.png)

![Hello Menu Bar Help Menu](/images/glimmer-hello-menu-bar-help-menu.png)

The Mac Menu includes Accelerator Keys (keyboard shortcuts) and Mac built-in Search.

![Hello Menu Bar Help Menu Mac Accelerators](/images/glimmer-hello-menu-bar-help-menu-mac-accelerators.png)

#### Hello, Pop Up Context Menu!

This sample demonstrates pop up context menus in Glimmer.

Code:

[samples/hello/hello_pop_up_context_menu.rb](/samples/hello/hello_pop_up_context_menu.rb)

![Hello Pop Up Context Menu](/images/glimmer-hello-pop-up-context-menu.png)
![Hello Pop Up Context Menu Popped Up](/images/glimmer-hello-pop-up-context-menu-popped-up.png)

#### Hello, Custom Widget!

This sample demonstrates the use of a custom widget in Glimmer.

Code:

[samples/hello/hello_custom_widget.rb](/samples/hello/hello_custom_widget.rb)

![Hello Custom Widget](/images/glimmer-hello-custom-widget.gif)

#### Hello, Custom Shell!

This sample demonstrates the use of a custom shell (aka custom window) in Glimmer.

Code:

[samples/hello/hello_custom_shell.rb](/samples/hello/hello_custom_shell.rb)

![Hello Custom Shell](/images/glimmer-hello-custom-shell.png)
![Hello Custom Shell Email1](/images/glimmer-hello-custom-shell-email1.png)
![Hello Custom Shell Email2](/images/glimmer-hello-custom-shell-email2.png)
![Hello Custom Shell Email3](/images/glimmer-hello-custom-shell-email3.png)

#### Hello, Sash Form!

This sample demonstrates the use of a `sash_form` in Glimmer.

Code:

[samples/hello/hello_sash_form.rb](/samples/hello/hello_sash_form.rb)

Hello, Sash Form! Horizontal Orientation

![Hello Sash Form](/images/glimmer-hello-sash-form.png)

Hello, Sash Form! Resized

![Hello Sash Form Resized](/images/glimmer-hello-sash-form-resized.png)

Hello, Sash Form! Sash Width Changed

![Hello Sash Form Sash Width Changed](/images/glimmer-hello-sash-form-sash-width-changed.png)

Hello, Sash Form! Vertical Orientation

![Hello Sash Form Vertical](/images/glimmer-hello-sash-form-vertical.png)

Hello, Sash Form! Green Label Maximized

![Hello Sash Form Green Maximized](/images/glimmer-hello-sash-form-green-maximized.png)

Hello, Sash Form! Red Label Maximized

![Hello Sash Form Red Maximized](/images/glimmer-hello-sash-form-red-maximized.png)

#### Hello, Styled Text!

This sample demonstrates the use of a `styled_text` in Glimmer.

Code:

[samples/hello/hello_styled_text.rb](/samples/hello/hello_styled_text.rb)

Hello, Styled Text!

![Hello Styled Text](/images/glimmer-hello-styled-text.png)

#### Hello, Expand Bar!

This sample demonstrates the use of a `expand_bar` and `expand_item` in Glimmer.

Code:

[samples/hello/hello_expand_bar.rb](/samples/hello/hello_expand_bar.rb)

Hello, Expand Bar! All Expanded

![Hello Expand Bar All Expanded](/images/glimmer-hello-expand-bar-all-expanded.png)

Hello, Expand Bar! Productivity Expanded

![Hello Expand Bar Productivity Expanded](/images/glimmer-hello-expand-bar-productivity-expanded.png)

Hello, Expand Bar! Tools Expanded

![Hello Expand Bar Tools Expanded](/images/glimmer-hello-expand-bar-tools-expanded.png)

Hello, Expand Bar! Reading Expanded

![Hello Expand Bar Reading Expanded](/images/glimmer-hello-expand-bar-reading-expanded.png)

#### Hello, Radio!

This sample demonstrates the use of a `radio` (aka `button(:radio)`) in Glimmer.

Code:

[samples/hello/hello_radio.rb](/samples/hello/hello_radio.rb)

Hello, Radio!

![Hello Radio](/images/glimmer-hello-radio.png)

#### Hello, Radio Group!

This sample demonstrates the use of a `radio_group` in Glimmer, which provides terser syntax for representing multiple radio buttons by relying on data-binding to automatically spawn the `radio` widgets based on available options on the model.

Code:

[samples/hello/hello_radio_group.rb](/samples/hello/hello_radio_group.rb)

Hello, Radio Group!

![Hello Radio Group](/images/glimmer-hello-radio-group.png)

#### Hello, Group!

This sample demonstrates the use of a `group` in Glimmer (not to be confused with the logical radio group custom widget, this is just an alternative to `composite` that provides a border around content).

Code:

[samples/hello/hello_group.rb](/samples/hello/hello_group.rb)

Hello, Group!

![Hello Group](/images/glimmer-hello-group.png)

#### Hello, Checkbox!

This sample demonstrates the use of a `checkbox` (aka `check` or `button(:check)`) in Glimmer.

Code:

[samples/hello/hello_checkbox.rb](/samples/hello/hello_checkbox.rb)

Hello, Checkbox!

![Hello Checkbox](/images/glimmer-hello-checkbox.png)

#### Hello, Checkbox Group!

This sample demonstrates the use of a `checkbox_group` (aka `check_group`) in Glimmer, which provides terser syntax for representing multiple checkbox buttons (`button(:check)`) by relying on data-binding to automatically spawn the `checkbox` widgets (`button(:check)`) based on available options on the model.

Code:

[samples/hello/hello_checkbox_group.rb](/samples/hello/hello_checkbox_group.rb)

Hello, Checkbox Group!

![Hello Checkbox Group](/images/glimmer-hello-checkbox-group.png)

#### Hello, Directory Dialog!

This sample demonstrates the use of a `directory_dialog` in Glimmer.

Code:

[samples/hello/hello_directory_dialog.rb](/samples/hello/hello_directory_dialog.rb)

Hello, Directory Dialog!

![Hello Directory Dialog](/images/glimmer-hello-directory-dialog.png)

Hello, Directory Dialog! Browse...

![Hello Directory Dialog](/images/glimmer-hello-directory-dialog-browse.png)

Hello, Directory Dialog! Selected Directory

![Hello Directory Dialog](/images/glimmer-hello-directory-dialog-selected-directory.png)

#### Hello, File Dialog!

This sample demonstrates the use of a `file_dialog` in Glimmer.

Code:

[samples/hello/hello_file_dialog.rb](/samples/hello/hello_file_dialog.rb)

Hello, File Dialog!

![Hello File Dialog](/images/glimmer-hello-file-dialog.png)

Hello, File Dialog! Browse...

![Hello File Dialog](/images/glimmer-hello-file-dialog-browse.png)

Hello, File Dialog! Selected File

![Hello File Dialog](/images/glimmer-hello-file-dialog-selected-file.png)

#### Hello, Date Time!

This sample demonstrates the use of [date_time](#datetime) widget keywords in Glimmer: `date`, `date_drop_down`, `time`, and `calendar`

Code:

[samples/hello/hello_date_time.rb](/samples/hello/hello_date_time.rb)

Hello, Date Time!

![Hello Date Time](/images/glimmer-hello-date-time.png)

#### Hello, Spinner!

This sample demonstrates the use of `spinner` widget in Glimmer

Code:

[samples/hello/hello_spinner.rb](/samples/hello/hello_spinner.rb)

Hello, Spinner!

![Hello Spinner](/images/glimmer-hello-spinner.png)

#### Hello, Table!

This sample demonstrates the use of [table](#table) widget in Glimmer, including data-binding, multi-type editing, sorting, and filtering.

Code:

[samples/hello/hello_table.rb](/samples/hello/hello_table.rb)

Hello, Table!

![Hello Table](/images/glimmer-hello-table.png)

Hello, Table! Editing Game Date

![Hello Table](/images/glimmer-hello-table-editing-game-date.png)

Hello, Table! Editing Game Time

![Hello Table](/images/glimmer-hello-table-editing-game-time.png)

Hello, Table! Editing Home Team

![Hello Table](/images/glimmer-hello-table-editing-home-team.png)

Hello, Table! Sorted Game Date Ascending

![Hello Table](/images/glimmer-hello-table-sorted-game-date-ascending.png)

Hello, Table! Sorted Game Date Descending

![Hello Table](/images/glimmer-hello-table-sorted-game-date-descending.png)

Hello, Table! Playoff Type Combo

![Hello Table](/images/glimmer-hello-table-playoff-type-combo.png)

Hello, Table! Playoff Type Changed

![Hello Table](/images/glimmer-hello-table-playoff-type-changed.png)

Hello, Table! Game Booked

![Hello Table](/images/glimmer-hello-table-game-booked.png)

Hello, Table! Context Menu

![Hello Table](/images/glimmer-hello-table-context-menu.png)

#### Hello, Button!

This sample demonstrates the use of the `button` widget in Glimmer, including data-binding and click event triggering via `on_widget_selected`.

Code:

[samples/hello/hello_button.rb](/samples/hello/hello_button.rb)

Hello, Button!

![Hello Button](/images/glimmer-hello-button.png)

Hello, Button! Incremented 7 times!

![Hello Button Incremented](/images/glimmer-hello-button-incremented.png)

#### Hello, Link!

This sample demonstrates the use of the `link` widget in Glimmer, including identifying which link was clicked and performing an action (displaying help) based on its location.

Code:

[samples/hello/hello_link.rb](/samples/hello/hello_link.rb)

Hello, Link!

![Hello Link](/images/glimmer-hello-link.png)

Hello, Link! Clicked

![Hello Link Clicked](/images/glimmer-hello-link-clicked.png)

#### Hello, Dialog!

This sample demonstrates the use of the `dialog` widget in Glimmer, which provides a modal `shell` that blocks shells beneath it until closed. And unlike `message_box`, it can contain arbitrary widgets (not just a message).

Code:

[samples/hello/hello_dialog.rb](/samples/hello/hello_dialog.rb)

Hello, Dialog!

![Hello Dialog](/images/glimmer-hello-dialog.png)

Hello, Dialog! Open Dialog

![Hello Dialog Open Dialog](/images/glimmer-hello-dialog-open-dialog.png)

#### Hello, Code Text!

This sample demonstrates the Glimmer Built-In [Code Text Custom Widget](#code-text-custom-widget).

Code:

[samples/hello/hello_code_text.rb](/samples/hello/hello_code_text.rb)

Hello, Code Text! Ruby Language / Glimmer Theme / Show Line Numbers (default width of 4)

![Hello Code Text Ruby](/images/glimmer-hello-code-text-ruby.png)

Hello, Code Text! JavaScript Language / Pastie Theme / Show Line Numbers (custom width of 2)

![Hello Code Text JavaScript](/images/glimmer-hello-code-text-javascript.png)

Hello, Code Text! HTML Language / GitHub Theme / No Line Numbers

![Hello Code Text HTML](/images/glimmer-hello-code-text-html.png)

#### Hello, Canvas!

This sample demonstrates the use of the `canvas` widget and [Shape DSL](#canvas-shape-dsl) in Glimmer.

Code:

[samples/hello/hello_canvas.rb](/samples/hello/hello_canvas.rb)

Hello, Canvas!

![Hello Canvas](/images/glimmer-hello-canvas.png)

Hello, Canvas! Moving Shapes and Nested Shapes via Drag'n'Drop

![Hello Canvas Moving Shapes](/images/glimmer-hello-canvas-moving-shapes.gif)

Hello, Canvas! with Moved Shapes (via Drag'n'Drop)

![Hello Canvas Moved Shapes](/images/glimmer-hello-canvas-moved-shapes.png)

Hello, Canvas! Menu (for background/foreground color changes)

![Hello Canvas Menu](/images/glimmer-hello-canvas-menu.png)

Hello, Canvas! Color Dialog

![Hello Canvas Color Dialog](/images/glimmer-hello-canvas-color-dialog.png)

Hello, Canvas! Colors Changed

![Hello Canvas Colors Changed](/images/glimmer-hello-canvas-colors-changed.png)

Hello, Canvas! Data-Binding (changing a `text` shape `string` via data-binding changes from another thread)

![Hello Canvas Data Binding](/images/glimmer-hello-canvas-data-binding.gif)

#### Hello, Canvas Animation!

This sample demonstrates the use of the `canvas` widget and [Animation DSL](#canvas-animation-dsl) in Glimmer.

Code:

[samples/hello/hello_canvas_animation.rb](/samples/hello/hello_canvas_animation.rb)

Hello, Canvas Animation!

![Hello Canvas Animation](/images/glimmer-hello-canvas-animation.png)

Hello, Canvas Animation Another Frame!

![Hello Canvas Animation Frame 2](/images/glimmer-hello-canvas-animation-frame2.png)

#### Hello, Canvas Transform!

This sample demonstrates the use of the `transform` keyword as part of the [Transform DSL](#canvas-transform-dsl) within the [Shape DSL](#canvas-shape-dsl).

Code:

[samples/hello/hello_canvas_transform.rb](/samples/hello/hello_canvas_transform.rb)

Hello, Canvas Transform!

![Hello Canvas Transform](/images/glimmer-hello-canvas-transform.png)

#### Hello, Cursor!

This sample demonstrates the use of the `cursor` property keyword to change the mouse cursor.

Code:

[samples/hello/hello_cursor.rb](/samples/hello/hello_cursor.rb)

Hello, Cursor!

![Hello Cursor](/images/glimmer-hello-cursor.gif)

#### Hello, Progress Bar!

This sample demonstrates the use of the `progress_bar` widget keyword.

It includes an `:indeterminate` progress bar on top, for cases when you could not calculate progress, but still want to inform the user there is an operation happening in the background.

Below it, there are a determinate `:horizontal` (default) progress bar and a `:vertical` progress bar.

Code:

[samples/hello/hello_progress_bar.rb](/samples/hello/hello_progress_bar.rb)

Hello, Progress Bar!

![Hello Progress Bar](/images/glimmer-hello-progress-bar.gif)

#### Hello, Tree!

This sample demonstrates the use of the `tree` widget along with tree data-binding.

Code:

[samples/hello/hello_tree.rb](/samples/hello/hello_tree.rb)

Hello, Tree!

![Hello Tree](/images/glimmer-hello-tree.png)

#### Hello, Color Dialog!

This sample demonstrates the use of the `color_dialog` keyword.

Code:

[samples/hello/hello_color_dialog.rb](/samples/hello/hello_color_dialog.rb)

Hello, Color Dialog!

![Hello Color Dialog](/images/glimmer-hello-color-dialog.png)

![Hello Color Dialog Choose Color](/images/glimmer-hello-color-dialog-choose-color.png)

![Hello Color Dialog Color Changed](/images/glimmer-hello-color-dialog-color-changed.png)

#### Hello, Font Dialog!

This sample demonstrates the use of the `font_dialog` keyword.

Code:

[samples/hello/hello_font_dialog.rb](/samples/hello/hello_font_dialog.rb)

Hello, Font Dialog!

![Hello Font Dialog](/images/glimmer-hello-font-dialog.png)

![Hello Font Dialog Choose Font](/images/glimmer-hello-font-dialog-choose-font.png)

![Hello Font Dialog Font Changed](/images/glimmer-hello-font-dialog-font-changed.png)

### Elaborate Samples

For more elaborate samples, check the following:

#### User Profile

This sample was used in the [DZone Article about Glimmer](https://dzone.com/articles/an-introduction-glimmer), demonstrating Glimmer widgets in general.

Please note that the code has changed since that article was written (the GUI DSL has been improved/simplified), so use the code sample mentioned here instead as the correct version.

Code:

[samples/elaborate/user_profile.rb](/samples/elaborate/user_profile.rb)

![User Profile](/images/glimmer-user-profile.png)

#### Login

This sample demonstrates basic data-binding, password and text fields, and field enablement data-binding.

Code:

[samples/elaborate/login.rb](/samples/elaborate/login.rb)

![Login](/images/glimmer-login.png)
![Login Filled In](/images/glimmer-login-filled-in.png)
![Login Logged In](/images/glimmer-login-logged-in.png)

#### Tic Tac Toe

This sample demonstrates a full MVC application, including GUI layout, text and enablement data-binding, and test-driven development (has [specs](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/spec/samples/elaborate/tic_tac_toe/board_spec.rb)).

Code:

(Please note that on some Linux instances where the display x-axis is set to double-scale, you need to set the `shell` `minimum_size` to `300, 178` instead of `150, 178`)

[samples/elaborate/tic_tac_toe.rb](/samples/elaborate/tic_tac_toe.rb)

![Tic Tac Toe](/images/glimmer-tic-tac-toe.png)
![Tic Tac Toe In Progress](/images/glimmer-tic-tac-toe-in-progress.png)
![Tic Tac Toe Game Over](/images/glimmer-tic-tac-toe-game-over.png)

#### Contact Manager

This sample demonstrates table data-binding, sorting, filtering, GUI layout, MVP pattern, and test-driven development (has [specs](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/spec/samples/elaborate/contact_manager/contact_manager_presenter_spec.rb)).

Code:

[samples/elaborate/contact_manager.rb](/samples/elaborate/contact_manager.rb)

Contact Manager

![Contact Manager](/images/glimmer-contact-manager.png)

Contact Manager - Find

![Contact Manager](/images/glimmer-contact-manager-find.png)

Contact Manager - Edit Started

![Contact Manager](/images/glimmer-contact-manager-edit-started.png)

Contact Manager - Edit In Progress

![Contact Manager](/images/glimmer-contact-manager-edit-in-progress.png)

Contact Manager - Edit Done

![Contact Manager](/images/glimmer-contact-manager-edit-done.png)

#### Glimmer Tetris

This sample demonstrates how to build an interactive animated game with MVC architecture, custom-shell/custom-widgets, multi-threading, asynchronous programming, data-binding, canvas shape graphic decorations, canvas shape icon image generation, and keyboard events/shortcuts.

Note that it works optimally on the Mac. It is very new, so it has not been optimized for Windows and Linux yet given their minor differences from the Mac.

Code:

[samples/elaborate/tetris.rb](/samples/elaborate/tetris.rb)

![Tetris Icon](/images/glimmer-tetris-icon.png)

![Tetris](/images/glimmer-tetris.png)

![Tetris Game Over](/images/glimmer-tetris-game-over.png)

![Tetris Game Over](/images/glimmer-tetris-game-over-sorted-by-score.png)

![Tetris High Scores](/images/glimmer-tetris-high-score-dialog.png)

![Tetris Game Menu](/images/glimmer-tetris-game-menu.png)

![Tetris View Menu](/images/glimmer-tetris-view-menu.png)

![Tetris Options Menu](/images/glimmer-tetris-options-menu.png)

![Tetris Help Menu](/images/glimmer-tetris-help-menu.png)

#### Mandelbrot Fractal

This sample demonstrates how to render canvas graphics with multi-threaded processing taking advantage of all CPU cores and doing background processing of images.

It renders the famous Mandelbrot Fractal, enabling zooming and panning (go to Help -> Instructions for more details)

The Mandelbrot Fractal is known to take a long time to render, but thanks to multi-core processing, the app starts in about 10 seconds with 4 CPU cores (runs faster the more cores you have)

Lower the cores in the menu to get more responsive interaction (e.g. zooming/panning). Once you change the cores, the change will not take effect till the next zoom calculation cycle.

Code:

[samples/elaborate/mandelbrot_fractal.rb](/samples/elaborate/mandelbrot_fractal.rb)

![Mandelbrot Fractal Zoom 1](/images/glimmer-mandelbrot-zoom1.png)

![Mandelbrot Fractal Zoom 3](/images/glimmer-mandelbrot-zoom3.png)

![Mandelbrot Fractal Zoom 5](/images/glimmer-mandelbrot-zoom5.png)

![Mandelbrot Fractal View Menu](/images/glimmer-mandelbrot-menu-view.png)

![Mandelbrot Fractal Cores Menu](/images/glimmer-mandelbrot-menu-cores.png)

![Mandelbrot Fractal Help Menu](/images/glimmer-mandelbrot-menu-help.png)

### External Samples

#### Glimmer Calculator

[<img alt="Glimmer Calculator Icon" src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-calculator/master/glimmer-cs-calculator-icon.png" height=40 /> Glimmer Calculator](https://github.com/AndyObtiva/glimmer-cs-calculator) is a basic calculator sample app demonstrating data-binding and TDD (test-driven-development) with Glimmer following the MVP pattern (Model-View-Presenter).

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-calculator/master/glimmer-cs-calculator-screenshot.png" />](https://github.com/AndyObtiva/glimmer-cs-calculator)

#### Gladiator

[<img src='https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-gladiator/master/images/glimmer-cs-gladiator-logo.png' height=40 /> Gladiator](https://github.com/AndyObtiva/glimmer-cs-gladiator) (short for Glimmer Editor) is a Glimmer sample project under on-going development.
You may check it out to learn how to build a Glimmer Custom Shell gem.

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-gladiator/master/images/glimmer-gladiator.png" />](https://github.com/AndyObtiva/glimmer-cs-gladiator)

Gladiator is a good demonstration of:
- MVP Pattern
- Tree data-binding
- List data-binding
- Text selection data-binding
- Tabs
- Context menus
- Custom Shell
- Custom widget

#### Timer

[<img alt="Glimmer Timer Icon" src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/images/glimmer-timer-logo.png" height=40 /> Timer](https://github.com/AndyObtiva/glimmer-cs-timer) is a sample app demonstrating data-binding, multi-threading, and JSound (Java Sound) library integration in a desktop application.

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/glimmer-timer-screenshot.png" />](https://github.com/AndyObtiva/glimmer-cs-timer)

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2021 - Andy Maleh.
