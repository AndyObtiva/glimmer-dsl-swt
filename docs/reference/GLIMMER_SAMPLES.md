- [Samples](#samples)
  - [Hello Samples](#hello-samples)
    - [Hello, World!](#hello-world)
    - [Hello, Button!](#hello-button)
    - [Hello, Label!](#hello-label)
    - [Hello, Text!](#hello-text)
    - [Hello, Composite!](#hello-composite)
    - [Hello, Scrolled Composite!](#hello-scrolled-composite)
    - [Hello, Layout!](#hello-layout)
    - [Hello, Shell!](#hello-shell)
    - [Hello, Tab!](#hello-tab)
    - [Hello, C Tab!](#hello-c-tab)
    - [Hello, Combo!](#hello-combo)
    - [Hello, C Combo!](#hello-c-combo)
    - [Hello, List Single Selection!](#hello-list-single-selection)
    - [Hello, List Multi Selection!](#hello-list-multi-selection)
    - [Hello, Computed!](#hello-computed)
    - [Hello, Toggle!](#hello-toggle)
    - [Hello, Message Box!](#hello-message-box)
    - [Hello, Browser!](#hello-browser)
    - [Hello, Drag and Drop!](#hello-drag-and-drop)
    - [Hello, Menu Bar!](#hello-menu-bar)
    - [Hello, Pop Up Context Menu!](#hello-pop-up-context-menu)
    - [Hello, Arrow!](#hello-arrow)
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
    - [Hello, Print Dialog!](#hello-print-dialog)
    - [Hello, Print!](#hello-print)
    - [Hello, Date Time!](#hello-date-time)
    - [Hello, Scale!](#hello-scale)
    - [Hello, Slider!](#hello-slider)
    - [Hello, Spinner!](#hello-spinner)
    - [Hello, Table!](#hello-table)
    - [Hello, Refined Table!](#hello-refined-table)
    - [Hello, Link!](#hello-link)
    - [Hello, Dialog!](#hello-dialog)
    - [Hello, Code Text!](#hello-code-text)
    - [Hello, Canvas!](#hello-canvas)
    - [Hello, Canvas Animation!](#hello-canvas-animation)
    - [Hello, Canvas Animation Multi!](#hello-canvas-animation-multi)
    - [Hello, Canvas Transform!](#hello-canvas-transform)
    - [Hello, Canvas Path!](#hello-canvas-path)
    - [Hello, Canvas Data Binding!](#hello-canvas-data-binding)
    - [Hello, Canvas Shape Listeners!](#hello-canvas-shape-listeners)
    - [Hello, Canvas Drag and Drop!](#hello-canvas-drag-and-drop)
    - [Hello, Cursor!](#hello-cursor)
    - [Hello, Progress Bar!](#hello-progress-bar)
    - [Hello, Tree!](#hello-tree)
    - [Hello, Color Dialog!](#hello-color-dialog)
    - [Hello, Font Dialog!](#hello-font-dialog)
    - [Hello, Shape!](#hello-shape)
    - [Hello, Custom Shape!](#hello-custom-shape)
    - [Hello, Tool Bar!](#hello-tool-bar)
    - [Hello, Cool Bar!](#hello-cool-bar)
    - [Hello, Tray Item!](#hello-tray-item)
  - [Elaborate Samples](#elaborate-samples)
    - [User Profile](#user-profile)
    - [Login](#login)
    - [Tic Tac Toe](#tic-tac-toe)
    - [Connect 4](#connect-4)
    - [Contact Manager](#contact-manager)
    - [Clock](#clock)
    - [Game of Life](#game-of-life)
    - [Glimmer Tetris](#glimmer-tetris)
    - [Klondike Solitaire](#klondike-solitaire)
    - [Battleship](#battleship)
    - [Mandelbrot Fractal](#mandelbrot-fractal)
    - [Parking](#parking)
    - [Stock Ticker](#stock-ticker)
    - [Metronome](#metronome)
    - [Weather](#weather)
    - [Quarto](#quarto)
    - [Snake](#snake)
  - [External Samples](#external-samples)
    - [Glimmer Calculator](#glimmer-calculator)
    - [Timer](#timer)
    - [Contact Manager App](#contact-manager-app)
- [License](#license)

## Samples

Check the [samples](/samples) directory in [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) for examples on how to write Glimmer applications. To run a sample, make sure to install the `glimmer-dsl-swt` gem first and then use the `glimmer samples` command to run it (alternatively, you may clone the repo, follow [CONTRIBUTING.md](CONTRIBUTING.md) instructions, and run samples locally with development glimmer command: `bin/glimmer`).

You may run any sample via this command:

```
glimmer samples
```

This brings up the [Glimmer Meta-Sample (The Sample of Samples)](/samples/elaborate/meta_sample.rb)

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

You may edit the code of any sample before launching it by clicking on the "Launch" button. This helps you learn by experimenting with Glimmer GUI DSL syntax. To go back to original code, simply hit the "Reset" button. Also, for some samples, you can click the "Tutorial" button, and a YouTube video is played to guide you through learning the sample. The YouTube videos are played from the [Glimmer YouTube Channel](https://www.youtube.com/channel/UC5hzDE23HZXsZLAxYk2UJEw).

Note that if you fail to run any sample through the Glimmer Meta-Sample for whatever reason, you could always run directly by cloning the project, running `bundle`, and then this command (drop the "bin" if you install the glimmer-dsl-swt gem instead):

```ruby
bin/glimmer samples/hello/hello_canvas_transform.rb
```

### Hello Samples

For hello-type simple samples, check the following.

#### Hello, World!

[Hello, World! Video Tutorial](https://www.youtube.com/watch?v=Mi5phsSdNAA&list=PLSN9HhZ_0-n741vRa_dL-M81cLbqD_kem&index=1)

Code:

[samples/hello/hello_world.rb](/samples/hello/hello_world.rb)

![Hello World](/images/glimmer-hello-world.png)

#### Hello, Button!

This sample demonstrates the use of the `button` widget in Glimmer, including data-binding and click event triggering via `on_widget_selected`.

Code:

[samples/hello/hello_button.rb](/samples/hello/hello_button.rb)

Hello, Button!

![Hello Button](/images/glimmer-hello-button.png)

Hello, Button! Incremented 7 times!

![Hello Button Incremented](/images/glimmer-hello-button-incremented.png)

#### Hello, Label!

This sample demonstrates the use of the `label` widget in Glimmer.

Code:

[samples/hello/hello_label.rb](/samples/hello/hello_label.rb)

![Hello Label Left Aligned](/images/glimmer-hello-label-left-aligned.png)

![Hello Label Center Aligned](/images/glimmer-hello-label-center-aligned.png)

![Hello Label Right Aligned](/images/glimmer-hello-label-right-aligned.png)

![Hello Label Images](/images/glimmer-hello-label-images.png)

![Hello Label Background Images](/images/glimmer-hello-label-background_images.png)

![Hello Label Horizontal Separator](/images/glimmer-hello-label-horizontal-separator.png)

![Hello Label Vertical Separator](/images/glimmer-hello-label-vertical-separator.png)

#### Hello, Text!

This sample demonstrates the use of the `text` widget in Glimmer, including data-binding (e.g. via the `<=>` operator) and event handling.

Code:

[samples/hello/hello_text.rb](/samples/hello/hello_text.rb)

Hello, Text!

![Hello Text](/images/glimmer-hello-text.png)

#### Hello, Composite!

This sample demonstrates the `composite` widget, which is simply used as a container for visual layout and organization.

Code:

[samples/hello/hello_composite.rb](/samples/hello/hello_composite.rb)

![Hello Composite](/images/glimmer-hello-composite.png)

#### Hello, Scrolled Composite!

This sample demonstrates the `scrolled_composite` widget, which is used to add scrollbars around content that exceeds the size of the window.

Code:

[samples/hello/hello_scrolled_composite.rb](/samples/hello/hello_scrolled_composite.rb)

![Hello Scrolled Composite](/images/glimmer-hello-scrolled-composite.png)

![Hello Scrolled Composite](/images/glimmer-hello-scrolled-composite-scrolled.png)

#### Hello, Layout!

[Hello, Layout! Video Tutorial](https://www.youtube.com/watch?v=dAVFR9Y_thY&list=PLSN9HhZ_0-n741vRa_dL-M81cLbqD_kem&index=4)

This sample demonstrates the standard 3 layouts in SWT (though one can write their own for very advanced applications): `fill_layout`, `row_layout`, and `grid_layout`

Code:

[samples/hello/hello_layout.rb](/samples/hello/hello_layout.rb)

![Hello Layout Tab1](/images/glimmer-hello-layout-tab1.png)

![Hello Layout Tab2](/images/glimmer-hello-layout-tab2.png)

![Hello Layout Tab3](/images/glimmer-hello-layout-tab3.png)

![Hello Layout Tab4](/images/glimmer-hello-layout-tab4.png)

![Hello Layout Tab5](/images/glimmer-hello-layout-tab5.png)

![Hello Layout Tab6](/images/glimmer-hello-layout-tab6.png)

![Hello Layout Tab7](/images/glimmer-hello-layout-tab7.png)

#### Hello, Shell!

This sample demonstrates the various shells (windows) available in SWT.

Code:

[samples/hello/hello_shell.rb](/samples/hello/hello_shell.rb)

Hello, Shell!

![Hello, Shell!](/images/glimmer-hello-shell.png)

Nested Shell

![Nested Shell](/images/glimmer-hello-shell-nested-shell.png)

Independent Shell

![Independent Shell](/images/glimmer-hello-shell-independent-shell.png)

Close-Button Shell

![Close-Button Shell](/images/glimmer-hello-shell-close-button-shell.png)

Minimize-Button Shell

![Minimize-Button Shell](/images/glimmer-hello-shell-minimize-button-shell.png)

Maximize-Button Shell

![Maximize-Button Shell](/images/glimmer-hello-shell-maximize-button-shell.png)

Buttonless Shell

![Buttonless Shell](/images/glimmer-hello-shell-buttonless-shell.png)

No Trim Shell

![No Trim Shell](/images/glimmer-hello-shell-no-trim-shell.png)

Always On Top Shell

![Always On Top Shell](/images/glimmer-hello-shell-always-on-top-shell.png)

#### Hello, Tab!

[Hello, Tab! Video Tutorial](https://www.youtube.com/watch?v=cMwlYZ78uaQ&list=PLSN9HhZ_0-n741vRa_dL-M81cLbqD_kem&index=3)

Code:

[samples/hello/hello_tab.rb](/samples/hello/hello_tab.rb)

![Hello Tab English](/images/glimmer-hello-tab-english.png)
![Hello Tab French](/images/glimmer-hello-tab-french.png)

#### Hello, C Tab!

This sample demonstrates custom tab widget usage via the `c_tab_folder` and `c_tab_item` variations of `tab_folder` and `tab_item`, which can customize fonts/background/foreground colors for tabs and display additional tabs that do not fit in the window via a drop down.

Code:

[samples/hello/hello_c_tab.rb](/samples/hello/hello_c_tab.rb)

![Hello C Tab](/images/glimmer-hello-c-tab.png)
![Hello C Tab Extra Tabs](/images/glimmer-hello-c-tab-extra-tabs.png)
![Hello C Tab Other Tab](/images/glimmer-hello-c-tab-other-tab.png)

Country flag images were made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](http://www.flaticon.com)

#### Hello, Combo!

This sample demonstrates combo data-binding.

Code:

[samples/hello/hello_combo.rb](/samples/hello/hello_combo.rb)

![Hello Combo](/images/glimmer-hello-combo.png)
![Hello Combo Expanded](/images/glimmer-hello-combo-expanded.png)

#### Hello, C Combo!

This sample demonstrates the custom combo variation on combo, which allows the adjustment of the combo height based on font height or layout data.

Code:

[samples/hello/hello_c_combo.rb](/samples/hello/hello_c_combo.rb)

![Hello Combo](/images/glimmer-hello-c-combo.png)
![Hello Combo Expanded](/images/glimmer-hello-c-combo-expanded.png)

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

#### Hello, Toggle!

This sample demonstrates the use of `toggle` button (aka `button(:toggle)`)

Code:

[samples/hello/hello_toggle.rb](/samples/hello/hello_toggle.rb)

![Hello Toggle](/images/glimmer-hello-toggle.png)

![Hello Toggle Red](/images/glimmer-hello-toggle-red.png)

![Hello Toggle Green](/images/glimmer-hello-toggle-green.png)

![Hello Toggle Blue](/images/glimmer-hello-toggle-blue.png)

![Hello Toggle Red Green](/images/glimmer-hello-toggle-red-green.png)

![Hello Toggle Red Blue](/images/glimmer-hello-toggle-red-blue.png)

![Hello Toggle Green Blue](/images/glimmer-hello-toggle-green-blue.png)

![Hello Toggle Red Green Blue](/images/glimmer-hello-toggle-red-green-blue.png)

#### Hello, Message Box!

[Hello, Message Box! Video Tutorial](https://www.youtube.com/watch?v=N0sDcr0xp40&list=PLSN9HhZ_0-n741vRa_dL-M81cLbqD_kem&index=2)

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

#### Hello, Arrow!

This sample demonstrates `arrow` button (aka `button(:arrow)`).

Code:

[samples/hello/hello_arrow.rb](/samples/hello/hello_arrow.rb)

![Hello Arrow](/images/glimmer-hello-arrow.png)

![Hello Arrow Menu](/images/glimmer-hello-arrow-menu.png)

![Hello Arrow Item Selected](/images/glimmer-hello-arrow-item-selected.png)

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

This sample demonstrates the use of `file_dialog` in Glimmer.

Code:

[samples/hello/hello_file_dialog.rb](/samples/hello/hello_file_dialog.rb)

Hello, File Dialog!

![Hello File Dialog](/images/glimmer-hello-file-dialog.png)

Hello, File Dialog! Browse...

![Hello File Dialog](/images/glimmer-hello-file-dialog-browse.png)

Hello, File Dialog! Selected File

![Hello File Dialog](/images/glimmer-hello-file-dialog-selected-file.png)

#### Hello, Print Dialog!

This sample demonstrates the use of `print_dialog` in Glimmer.

Code:

[samples/hello/hello_print_dialog.rb](/samples/hello/hello_print_dialog.rb)

Hello, Print Dialog!

![Hello Print Dialog](/images/glimmer-hello-print-dialog.png)

#### Hello, Print!

This sample demonstrates the use of `widget#print`, which automates work from Hello, Print Dialog! assuming a single page

Code:

[samples/hello/hello_print.rb](/samples/hello/hello_print.rb)

Hello, Print!

![Hello Print](/images/glimmer-hello-print.png)

#### Hello, Date Time!

This sample demonstrates the use of [date_time](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#datetime) widget keywords in Glimmer: `date`, `date_drop_down`, `time`, and `calendar`

Code:

[samples/hello/hello_date_time.rb](/samples/hello/hello_date_time.rb)

Hello, Date Time!

![Hello Date Time](/images/glimmer-hello-date-time.png)

#### Hello, Scale!

This sample demonstrates the use of `scale` widget in Glimmer

Code:

[samples/hello/hello_scale.rb](/samples/hello/hello_scale.rb)

Hello, Scale!

![Hello Scale](/images/glimmer-hello-scale.png)

#### Hello, Slider!

This sample demonstrates the use of `slider` widget in Glimmer

Code:

[samples/hello/hello_slider.rb](/samples/hello/hello_slider.rb)

Hello, Slider!

![Hello Slider](/images/glimmer-hello-slider.png)

#### Hello, Spinner!

This sample demonstrates the use of `spinner` widget in Glimmer

Code:

[samples/hello/hello_spinner.rb](/samples/hello/hello_spinner.rb)

Hello, Spinner!

![Hello Spinner](/images/glimmer-hello-spinner.png)

#### Hello, Table!

This sample demonstrates the use of [table](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#table) widget in Glimmer, including data-binding, multi-type editing, sorting, and filtering.

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

Hello, Table! Context Menu

![Hello Table](/images/glimmer-hello-table-context-menu.png)

Hello, Table! Game Booked

![Hello Table](/images/glimmer-hello-table-game-booked.png)

Hello, Table! Game Booked Rows

![Hello Table game booked rows](/images/glimmer-hello-table-game-booked-rows.png)

#### Hello, Refined Table!

This sample demonstrates the use of the [`refined_table` widget](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#refined-table), which provides a paginated `table` that can handle very large amounts of data.

Code:

[samples/hello/hello_refined_table.rb](/samples/hello/hello_refined_table.rb)

Hello, Refined Table!

![Hello Refined Table](/images/glimmer-hello-refined-table.png)

Hello, Refined Table! Booking Menu

![Hello Refined Table](/images/glimmer-hello-refined-table-booking-menu.png)

Hello, Refined Table! Game Booked

![Hello Refined Table](/images/glimmer-hello-refined-table-game-booked.png)

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

This sample demonstrates the Glimmer Built-In [Code Text Custom Widget](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#code-text-custom-widget).

Code:

[samples/hello/hello_code_text.rb](/samples/hello/hello_code_text.rb)

Hello, Code Text! HTML Language / GitHub Theme / No Line Numbers

![Hello Code Text HTML](/images/glimmer-hello-code-text-html.png)

Hello, Code Text! JavaScript Language / Pastie Theme / Show Line Numbers (custom width of 2)

![Hello Code Text JavaScript](/images/glimmer-hello-code-text-javascript.png)

Hello, Code Text! Ruby Language / Glimmer Theme / Show Line Numbers (default width of 4)

![Hello Code Text Ruby](/images/glimmer-hello-code-text-ruby.png)

Hello, Code Text! Zoom In (via keyboard shortcut CMD+= on Mac, CTRL+= on Win/Linux)

![Hello Code Text Zoom In](/images/glimmer-hello-code-text-zoom-in.png)

Hello, Code Text! Zoom Out (via keyboard shortcut CMD+- on Mac, CTRL+- on Win/Linux)

![Hello Code Text Zoom Out](/images/glimmer-hello-code-text-zoom-out.png)

Hello, Code Text! Restore Original Font Height (via keyboard shortcut CMD+0 on Mac, CTRL+0 on Win/Linux)

![Hello Code Text Restore Original Font Height](/images/glimmer-hello-code-text-ruby.png)

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

![Hello Canvas Text Data Binding](/images/glimmer-hello-canvas-text-data-binding.gif)

#### Hello, Canvas Animation!

This sample demonstrates the use of the [Canvas Animation DSL](#canvas-animation-dsl) with data-binding.

Code:

[samples/hello/hello_canvas_animation_data_binding.rb](/samples/hello/hello_canvas_animation_data_binding.rb)

Hello, Canvas Animation!

![Hello Canvas Animation Data Binding](/images/glimmer-hello-canvas-animation.gif)

#### Hello, Canvas Animation Multi!

This sample demonstrates parallel animations in the [Canvas Animation DSL](/docs/reference/GLIMMER_GUI_DSL_SYNTAX#canvas-animation-dsl).

Code:

[samples/hello/hello_canvas_animation_multi.rb](/samples/hello/hello_canvas_animation_multi.rb)

Hello, Canvas Animation Multi!

![Hello Canvas Animation Multi](/images/glimmer-hello-canvas-animation-multi.gif)

#### Hello, Canvas Transform!

This sample demonstrates the use of the `transform` keyword as part of the [Transform DSL](#canvas-transform-dsl) within the [Shape DSL](#canvas-shape-dsl).

Code:

[samples/hello/hello_canvas_transform.rb](/samples/hello/hello_canvas_transform.rb)

Hello, Canvas Transform!

![Hello Canvas Transform](/images/glimmer-hello-canvas-transform.png)

#### Hello, Canvas Path!

This sample demonstrates the use of the `path`, `quad`, `cubic`, `line`, and `point` keywords as part of the [Canvas Path DSL](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-path-dsl) within the [Canvas Shape DSL](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-shape-dsl).

Code:

[samples/hello/hello_canvas_path.rb](/samples/hello/hello_canvas_path.rb)

Hello, Canvas Path!

![Hello Canvas Path](/images/glimmer-hello-canvas-path.png)

#### Hello, Canvas Data Binding!

This sample demonstrates Canvas Shape DSL data-binding.

Code:

[samples/hello/hello_canvas_data_binding.rb](/samples/hello/hello_canvas_data_binding.rb)

Hello, Canvas Data Binding!

![Hello Canvas Data Binding](/images/glimmer-hello-canvas-data-binding.gif)

#### Hello, Canvas Shape Listeners!

This sample demonstrates Canvas Shape DSL listeners, which are constrained within the bounds of their owning shape.

Code:

[samples/hello/hello_canvas_shape_listeners.rb](/samples/hello/hello_canvas_shape_listeners.rb)

Hello, Canvas Shape Listeners!

![Hello Canvas Shape Listeners](/images/glimmer-hello-canvas-shape-listeners.png)

Hello, Canvas Shape Listeners! - Dragged Circle

![Hello Canvas Shape Listeners Dragged](/images/glimmer-hello-canvas-shape-listeners-dragged.png)

#### Hello, Canvas Drag and Drop!

This sample demonstrates Canvas Shape DSL drag and drop (different from standard widget drag and drop).

Code:

[samples/hello/hello_canvas_drag_and_drop.rb](/samples/hello/hello_canvas_drag_and_drop.rb)

![Hello Canvas Drag and Drop](/images/glimmer-hello-canvas-drag-and-drop.gif)

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

#### Hello, Shape!

This sample demonstrates the use of the `shape` keyword, which represents shape composites that contain other nested shapes.

Code:

[samples/hello/hello_shape.rb](/samples/hello/hello_shape.rb)

Hello, Shape!

![Hello Shape](/images/glimmer-hello-shape.png)

#### Hello, Custom Shape!

This sample demonstrates the use of the `Glimmer::UI::CustomShape` module, which is used to author new custom shape keywords.
It reimplements Hello, Shape! with a class-based custom shape instead of a method-based custom shape.
Just provides another option that is useful when defining more elaborate shapes to separate them from the main app code.

Code:

[samples/hello/hello_custom_shape.rb](/samples/hello/hello_custom_shape.rb)

Hello, Custom Shape!

![Hello Custom Shape](/images/glimmer-hello-custom-shape.png)

#### Hello, Tool Bar!

This sample demonstrates the use of `tool_bar` & `tool_item` as well as being able to nest `combo` in a `tool_bar`.

Code:

[samples/hello/hello_tool_bar.rb](/samples/hello/hello_tool_bar.rb)

Hello, Tool Bar!

![Hello Tool Bar](/images/glimmer-hello-tool-bar.png)

#### Hello, Cool Bar!

This sample demonstrates the use of `cool_bar` that can contain multiple reorganizable `tool_bar` widgets

Code:

[samples/hello/hello_cool_bar.rb](/samples/hello/hello_cool_bar.rb)

Hello, Cool Bar!

![Hello Cool Bar](/images/glimmer-hello-cool-bar.png)

![Hello Cool Bar Reorg1](/images/glimmer-hello-cool-bar-reorg1.png)

![Hello Cool Bar Reorg2](/images/glimmer-hello-cool-bar-reorg2.png)

![Hello Cool Bar Reorg3](/images/glimmer-hello-cool-bar-reorg3.png)

#### Hello, Tray Item!

This sample demonstrates the use of [`tray_item`](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#tray-item), which enables hiding an app (sending to background) and showing again on top of all other apps. It can also show an About Message Box and exit completely if needed.

Code:

[samples/hello/hello_tray_item.rb](/samples/hello/hello_tray_item.rb)

Hello, Tray Item Icon!

![Hello Tray Item Icon](/images/glimmer-hello-tray-item.png)

Hello, Tray Item Icon App!

![Hello Tray Item App](/images/glimmer-hello-tray-item-app.png)

Hello, Tray Item Icon About Message Box!

![Hello Tray Item Åbout](/images/glimmer-hello-tray-item-about.png)

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

#### Connect 4

This sample demonstrates a widget/shape hybrid MVC application, including GUI layout and data-binding.

Code:

[samples/elaborate/connect4.rb](/samples/elaborate/connect4.rb)

Connect 4

![Connect 4](/images/glimmer-connect4.png)

Connect 4 - About To Drop

![Connect 4 About To Drop](/images/glimmer-connect4-about-to-drop.png)

Connect 4 - Dropped Coin

![Connect 4 Dropped Coin](/images/glimmer-connect4-dropped-coin.png)

Connect 4 - Player 1 Wins (keeps the coin about to drop visual cue)

![Connect 4 Player 1 Wins](/images/glimmer-connect4-player1-wins.png)

Connect 4 - Game Over Message Box

![Connect 4 Game Over Message Box](/images/glimmer-connect4-game-over-dialog.png)

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

#### Clock

This sample demonstrates how to build an animation based application.

Code:

[samples/elaborate/clock.rb](/samples/elaborate/clock.rb)

![Clock](/images/glimmer-clock.png)

#### Game of Life

This sample demonstrates how to build an interactive canvas-based visualization of Conway's Game of Life ([test-first](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/spec/samples/elaborate/game_of_life/model/grid_spec.rb)), taking advantage of data-binding and multi-threading.

Code:

[samples/elaborate/game_of_life.rb](/samples/elaborate/game_of_life.rb)

![Game of Life](/images/glimmer-game-of-life.gif)

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

#### Klondike Solitaire

This sample demonstrates how to build an interactive card game with MVC architecture, canvas, custom-shapes, data-binding, observers, and canvas shape drag & drop.

Code:

[samples/elaborate/klondike_solitaire.rb](/samples/elaborate/klondike_solitaire.rb)

![Klondike Solitaire](/images/glimmer-klondike-solitaire.png)

![Klondike Solitaire Played](/images/glimmer-klondike-solitaire-played.png)

Check out a souped up large-card-size packaged version of the game in the [Glimmer Klondike Solitaire](https://github.com/AndyObtiva/glimmer_klondike_solitaire) application.

#### Battleship

This sample demonstrates how to build an interactive board game with MVC architecture, hybrid canvas widget/shape approach, custom-widgets, data-binding, observers, and widget drag & drop. Note that the A.I. is very simplistic as it is besides the point of this GUI demo, which focuses on leveraging Glimmer DSL for SWT.

Code:

[samples/elaborate/battleship.rb](/samples/elaborate/battleship.rb)

![Battleship](/images/glimmer-battleship.png)

![Battleship Placement](/images/glimmer-battleship-placement.png)

![Battleship Ready for Battle](/images/glimmer-battleship-ready-for-battle.png)

![Battleship Won](/images/glimmer-battleship-won.png)

![Battleship Game Over](/images/glimmer-battleship-game-over.png)

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

#### Parking

This sample demonstrates how to use method-based custom shapes and how to take advantage of transforms (e.g. rotation).

It enables booking a parking spot at the entrance of a building's parking, which in a real scenario would have prompted for payment too.

Code:

[samples/elaborate/parking.rb](/samples/elaborate/parking.rb)

Parking

![Parking](/images/glimmer-parking.png)

Parking Floor 4

![Parking Floor 4](/images/glimmer-parking-floor4.png)

Parking Booked

![Parking Booked](/images/glimmer-parking-booked.png)

#### Stock Ticker

This sample demonstrates a Stock Ticker that generates random stock price data for 4 different stocks and provides 4 different tab views of the graphed data using the [Canvas Path DSL](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-path-dsl). It leverages a thread that runs in the background and ticks the stocks to generate random new stock prices before amending the graphed paths with them.

Code:

[samples/elaborate/stock_ticker.rb](/samples/elaborate/stock_ticker.rb)

![Stock Ticker](/images/glimmer-stock-ticker.gif)

#### Metronome

This sample demonstrates a Metronome that accepts a beat count and bpm rate, ticking at every beat, with an uptick at the beginning of the rhythm interval.

It takes advantage of the Canvas Shape DSL, data-binding, and the Java Sound library. It employs a hybrid approach of relying on standard widget layouts (grid layout) and canvas shape x,y placement.

An external more full-fledged version exists too as [Glimmer Metronome](https://github.com/AndyObtiva/glimmer_metronome).

Code:

[samples/elaborate/metronome.rb](/samples/elaborate/metronome.rb)

![Metronome](/images/glimmer-metronome.gif)

[Download video with sound](/videos/glimmer-metronome.mp4?raw=true).

#### Weather

This sample demonstrates a Weather app that leverages the Ruby built-in `'net/http'` library, courtesy of openweathermap.org. It provides a good example of tackling JSON hierarchical hash/array data and converting into data-bindable model object attributes for Glimmer GUI synchronization.

Code:

[samples/elaborate/weather.rb](/samples/elaborate/weather.rb)

Montreal - Celsius

![Montreal C](/images/glimmer-weather-montreal-celsius.png)

Montreal - Fahrenheit

![Montreal F](/images/glimmer-weather-montreal-fahrenheit.png)

Atlanta - Fahrenheit

![Atlanta F](/images/glimmer-weather-atlanta-fahrenheit.png)

#### Quarto

This sample is a classic game called [Quarto](https://en.gigamic.com/game/quarto-classic), which demonstrates Canvas Drag and Drop and Custom Shapes (`cylinder`, `cube`, and `message_box_panel`) in an MVC application.

Code:

[samples/elaborate/quarto.rb](/samples/elaborate/quarto.rb)

Quarto

![Quarto](/images/glimmer-quarto.png)

#### Snake

This is the classic Snake game, which demonstrates MVP (Model-View-Presenter) and data-binding written [test-first](/spec/samples/elaborate/snake/model/game_spec.rb).

Code:

[samples/elaborate/snake.rb](/samples/elaborate/snake.rb)

Snake

![Snake](/images/glimmer-snake.png)

![Snake Video](/images/glimmer-snake.gif)

### External Samples

#### Glimmer Calculator

[<img alt="Glimmer Calculator Icon" src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-calculator/master/glimmer-cs-calculator-icon.png" height=40 /> Glimmer Calculator](https://github.com/AndyObtiva/glimmer-cs-calculator) is a basic calculator sample app demonstrating data-binding and TDD (test-driven-development) with Glimmer following the MVP pattern (Model-View-Presenter).

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-calculator/master/glimmer-cs-calculator-screenshot.png" />](https://github.com/AndyObtiva/glimmer-cs-calculator)

#### Timer

[<img alt="Glimmer Timer Icon" src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/images/glimmer-timer-logo.png" height=40 /> Timer](https://github.com/AndyObtiva/glimmer-cs-timer) is a sample app demonstrating data-binding, multi-threading, and JSound (Java Sound) library integration in a desktop application.

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-timer/master/glimmer-timer-screenshot.png" />](https://github.com/AndyObtiva/glimmer-cs-timer)

#### Contact Manager App

[<img src="https://raw.githubusercontent.com/AndyObtiva/contact_manager/master/icons/linux/Contact%20Manager.png" height=40 /> Contact Manager](https://github.com/AndyObtiva/contact_manager) is an enhanced version of the included Contact Manager elaborate sample, which demonstrates how to connect to a [SQLite database](https://www.sqlite.org/index.html) with [ActiveRecord](https://rubygems.org/gems/activerecord) and how to implement a [Master-Detail Interface](https://en.wikipedia.org/wiki/Master%E2%80%93detail_interface) following the [Model-View-Presenter Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter). This version can also be packaged as a native executable (DMG/MSI/DEB/RPM).

[<img src="https://raw.githubusercontent.com/AndyObtiva/contact_manager/master/screenshots/contact-manager.gif" /> ](https://github.com/AndyObtiva/contact_manager)

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2022 - Andy Maleh.
