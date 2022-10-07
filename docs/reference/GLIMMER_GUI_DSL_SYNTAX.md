This guide should help you get started with Glimmer DSL for SWT. For more advanced SWT details, please refer to the [SWT Reference](/README.md#swt-reference).

- [Glimmer GUI DSL Syntax](#glimmer-gui-dsl-syntax)
  - [DSL Auto-Expansion](#dsl-auto-expansion)
  - [Widgets](#widgets)
    - [Glimmer GUI DSL Keywords](#glimmer-gui-dsl-keywords)
    - [SWT Proxies](#swt-proxies)
      - [swt_widget](#swt_widget)
      - [Shell widget proxy methods](#shell-widget-proxy-methods)
      - [Widget Content Block](#widget-content-block)
      - [Shell Icon](#shell-icon)
        - [Shell Icon Tip for Packaging on Windows](#shell-icon-tip-for-packaging-on-windows)
    - [Dialog](#dialog)
      - [message_box](#message_box)
    - [Display](#display)
    - [Multi-Threading](#multi-threading)
      - [async_exec](#async_exec)
      - [sync_exec](#sync_exec)
      - [timer_exec](#timer_exec)
    - [Menus](#menus)
    - [Tray Item](#tray-item)
    - [ScrolledComposite](#scrolledcomposite)
    - [Sash Form Widget](#sash-form-widget)
    - [Browser Widget](#browser-widget)
  - [Widget Styles](#widget-styles)
    - [Explicit SWT Style Bit](#explicit-swt-style-bit)
    - [Negative SWT Style Bits](#negative-swt-style-bits)
    - [Extra SWT Styles](#extra-swt-styles)
      - [Non-resizable Window](#non-resizable-window)
  - [Widget Properties](#widget-properties)
    - [Color](#color)
      - [`#swt_color`](#swt_color)
    - [Font](#font)
  - [Image](#image)
    - [Image Options](#image-options)
  - [Cursor](#cursor)
  - [Layouts](#layouts)
  - [Layout Data](#layout-data)
  - [Canvas Shape DSL](#canvas-shape-dsl)
    - [Shapes inside a Shape](#shapes-inside-a-shape)
    - [Shapes inside a Widget](#shapes-inside-a-widget)
    - [Shapes inside an Image](#shapes-inside-an-image)
    - [Custom Shapes](#custom-shapes)
    - [Canvas Shape API](#canvas-shape-api)
    - [Pixel Graphics](#pixel-graphics)
  - [Canvas Path DSL](#canvas-path-dsl)
  - [Canvas Transform DSL](#canvas-transform-dsl)
    - [Top-Level Transform Fluent Interface](#top-level-transform-fluent-interface)
  - [Canvas Animation DSL](#canvas-animation-dsl)
    - [Animation via Data-Binding](#animation-via-data-binding)
  - [Data-Binding](#data-binding)
    - [General Examples](#general-examples)
    - [Shine](#shine)
    - [Combo](#combo)
    - [List](#list)
    - [Table](#table)
      - [Table Item Properties](#table-item-properties)
      - [Table Selection](#table-selection)
      - [Table Editing](#table-editing)
      - [Table Sorting](#table-sorting)
      - [Refined Table](#refined-table)
    - [Tree](#tree)
    - [DateTime](#datetime)
  - [Observer](#observer)
    - [Observing Widgets](#observing-widgets)
      - [Alternative Syntax](#alternative-syntax)
    - [Observing Models](#observing-models)
  - [Software Architecture](#software-architecture)
    - [MVC](#mvc)
    - [MVP](#mvp)
    - [Software Architecture Examples](#software-architecture-examples)
      - [MVC Example - Explicit Controller](#mvc-example---explicit-controller)
      - [MVC Example - Implicit Controller](#mvc-example---implicit-controller)
      - [MVP Example - Explicit Presenter](#mvp-example---explicit-presenter)
      - [MVP Example - Implicit Presenter](#mvp-example---implicit-presenter)
      - [MVP Example - Implicit Presenter with Bidirectional Data-Binding](#mvp-example---implicit-presenter-with-bidirectional-data-binding)
  - [Custom Widgets](#custom-widgets)
    - [Simple Example](#simple-example)
      - [Method-Based Custom Widget Example](#method-based-custom-widget-example)
      - [Class-Based Custom Widget Example](#class-based-custom-widget-example)
    - [Custom Widget Lifecycle Hooks](#custom-widget-lifecycle-hooks)
    - [Lifecycle Hooks Example](#lifecycle-hooks-example)
    - [Custom Widget Listeners](#custom-widget-listeners)
    - [Custom Widget API](#custom-widget-api)
    - [Content/Options Example](#contentoptions-example)
    - [Custom Widget Gotchas](#custom-widget-gotchas)
    - [Built-In Custom Widgets](#built-in-custom-widgets)
      - [Checkbox Group Custom Widget](#checkbox-group-custom-widget)
      - [Radio Group Custom Widget](#radio-group-custom-widget)
      - [Code Text Custom Widget](#code-text-custom-widget)
        - [Options](#options)
      - [Video Custom Custom Widget](#video-custom-custom-widget)
    - [Custom Widget Final Notes](#custom-widget-final-notes)
  - [Custom Shells](#custom-shells)
  - [Drag and Drop](#drag-and-drop)
  - [Miscellaneous](#miscellaneous)
    - [Multi-DSL Support](#multi-dsl-support)
      - [SWT](#swt)
      - [Opal](#opal)
      - [XML](#xml)
      - [CSS](#css)
      - [Listing / Enabling / Disabling DSLs](#listing--enabling--disabling-dsls)
    - [Application Menu Items (About/Preferences)](#application-menu-items-aboutpreferences)
    - [App Name and Version](#app-name-and-version)
    - [Performance Profiling](#performance-profiling)
      - [SWT Browser Style Options](#swt-browser-style-options)
- [License](#license)

## Glimmer GUI DSL Syntax

Glimmer's core is a GUI DSL with a lightweight visual syntax that makes it easy to visualize the nesting of widgets in the GUI hierarchy tree.

It is available through mixing in the `Glimmer` module, which makes [Glimmer GUI DSL Keywords](#glimmer-gui-dsl-keywords) available to both the instance scope and class scope:

```ruby
include Glimmer
```

For example, here is the basic "Hello, World!" sample code (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  text "Glimmer"
  
  label {
    text "Hello, World!"
  }
}.open
```

The `include Glimmer` declaration on top mixed the `Glimmer` module into the Ruby global main object making the Glimmer GUI DSL available at the top-level global scope.

While this works well enough for mini-samples, it is better to isolate Glimmer in a class or module during production application development to create a clean separation between view code (GUI) and model code (business domain). Here is the "Hello, World!" sample re-written in a class to illustrate how mixing in the `Glimmer` module (via `include Glimmer`) makes the Glimmer GUI DSL available in both the instance scope and class scope. That is clearly demonstrated by pre-initializing a color constant in the class scope and building the GUI in the `#open` instance method (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
class HelloWorld
  include Glimmer # makes the GUI DSL available in both the class scope and instance scope
  
  COLOR_FOREGROUND_DEFAULT = rgb(255, 0, 0) # rgb is a GUI DSL keyword used in the class scope
  
  def open
    # the following are GUI DSL keywords (shell, text, and label) used in the instance scope
    shell {
      text "Glimmer"
      
      label {
        text "Hello, World!"
        foreground COLOR_FOREGROUND_DEFAULT
      }
    }.open
  end
end

HelloWorld.new.open
```

This renders "Hello, World!" with a red foreground color:

![Hello World Red Foreground Color](/images/glimmer-hello-world-red-foreground-color.png)

The GUI DSL intentionally avoids overly verbose syntax, requiring as little declarative code as possible to describe what GUI to render, how to style it, and what properties to data-bind to the Models.

As such, it breaks off from Ruby's convention of using `do end` for multi-line blocks, opting instead for the lightweight and visual `{ }` curly brace blocks everywhere inside the GUI DSL. More details about Glimmer's syntax conventions may be found in the [Glimmer Style Guide](GLIMMER_STYLE_GUIDE.md)

Glimmer DSL syntax consists mainly of:
- keywords (e.g. `table` for a table widget)
- style/args (e.g. :multi as in `table(:multi)` for a multi-line selection table widget)
- content (e.g. `{ table_column { text 'Name'} }` as in `table(:multi) { table_column { text 'name'} }` for a multi-line selection table widget with a table column having header text property `'Name'` as content)

### DSL Auto-Expansion

Glimmer supports a new and radical Ruby DSL concept called DSL Auto-Expansion. To explain, let's first mention the two types of Glimmer GUI DSL keywords: static and dynamic.

Static keywords are pre-identified keywords in the Glimmer DSL, such as `shell` (alias: `window`), `display`, `message_box`, `async_exec`, `sync_exec`, and `bind`.

Dynamic keywords are dynamically figured out from currently imported (aka required/loaded) SWT widgets and custom widgets. Examples are: `label`, `combo`, and `list` for SWT widgets and `c_date_time`, `video`, and `gantt_chart` for custom widgets.

The only reason to distinguish between the two is to realize that importing new Glimmer [custom widgets](#custom-widgets) and Java SWT custom widget libraries automatically expands Glimmer's DSL vocabulary with new dynamic keywords.

For example, if a project adds this custom Java SWT library from the [Nebula Project](https://github.com/AndyObtiva/glimmer-cw-nebula):

https://www.eclipse.org/nebula/widgets/gallery/gallery.php

Glimmer will automatically support using the keyword `gallery`

This is what DSL Auto-Expansion is.

You will learn more about widgets next.

### Widgets

Glimmer GUIs (user interfaces) are modeled with widgets, which are wrappers around the SWT library widgets found here:

https://www.eclipse.org/swt/widgets/

This screenshot taken from the link above should give a glimpse of how SWT widgets look and feel:

[![SWT Widgets](/images/glimmer-swt-widgets.png)](https://www.eclipse.org/swt/widgets/)

In Glimmer DSL, widgets are declared with lowercase underscored names mirroring their SWT names minus the package name.

For example, here are some Glimmer widgets and their SWT counterparts:
- `shell` (alias: `window`) instantiates `org.eclipse.swt.widgets.Shell`, which represents a window
- `text` instantiates `org.eclipse.swt.widgets.Text`
- `button` instantiates `org.eclipse.swt.widgets.Button`
- `label` instantiates `org.eclipse.swt.widgets.Label`
- `composite` instantiates `org.eclipse.swt.widgets.Composite`
- `tab_folder` instantiates `org.eclipse.swt.widgets.TabFolder`
- `tab_item` instantiates `org.eclipse.swt.widgets.TabItem`
- `table` instantiates `org.eclipse.swt.widgets.Table`
- `table_column` instantiates `org.eclipse.swt.widgets.TableColumn`
- `tree` instantiates `org.eclipse.swt.widgets.Tree`
- `combo` instantiates `org.eclipse.swt.widgets.Combo`
- `list` instantiates `org.eclipse.swt.widgets.List`

Every **widget** is sufficiently declared by name, but may optionally be accompanied with:
- SWT **style**/***arguments*** wrapped by parenthesis according to [Glimmer Style Guide](GLIMMER_STYLE_GUIDE.md) (see [next section](#widget-styles) for details).
- Ruby block containing **content**, which may be **properties** (e.g. `enabled false`) or nested **widgets** (e.g. `table_column` nested inside `table`)

For example, if we were to revisit `samples/hello/hello_world.rb` above (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
shell {
  text "Glimmer"
  
  label {
    text "Hello, World!"
  }
}.open
```

Note that `shell` (alias: `window`) instantiates the outer shell **widget**, in other words, the window that houses all of the desktop graphical user interface.

`shell` is then followed by a ***block*** that contains

```ruby
# ...
  text "Glimmer" # text property of shell
  
  label { # label widget declaration as content of shell
    text "Hello, World!" # text property of label
  }
# ...
```

The first line declares a **property** called `text`, which sets the title of the shell (window) to `"Glimmer"`. **Properties** always have ***arguments*** (not wrapped by parenthesis according to [Glimmer Style Guide](GLIMMER_STYLE_GUIDE.md)), such as the text `"Glimmer"` in this case, and do **NOT** have a ***block*** (this distinguishes them from **widget** declarations).

The second line declares the `label` **widget**, which is followed by a Ruby **content** ***block*** that contains its `text` **property** with value `"Hello, World!"`

The **widget** ***block*** may optionally receive an argument representing the widget proxy object that the block content is for. This is useful in rare cases when the content code needs to refer to parent widget during declaration. You may leave that argument out most of the time and only add when absolutely needed.

Example:

```ruby
shell {|shell_proxy|
  #...
}
```

Remember that The `shell` (alias: `window`) widget is always the outermost widget containing all others in a Glimmer desktop windowed application.

After it is declared, a `shell` must be opened with the `#open` method, which can be called on the block directly as in the example above, or by capturing `shell` in a `@shell` variable (shown in example below), and calling `#open` on it independently (recommended in actual apps)

```ruby
@shell = shell {
  # properties and content
  # ...
}
@shell.open
```

It is centered upon initial display and has a minimum width of 130 (can be re-centered when needed with `@shell.center` method after capturing `shell` in a `@shell` variable as per samples)

Check out the [samples](samples) directory for more examples.

Example from [hello_tab.rb](samples/hello/hello_tab.rb) sample (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

![Hello Tab English](/images/glimmer-hello-tab-english.png)

![Hello Tab French](/images/glimmer-hello-tab-french.png)

```ruby
shell {
  text "Hello, Tab!"
  
  tab_folder {
    tab_item {
      text "English"
      
      label {
        text "Hello, World!"
      }
    }
    
    tab_item {
      text "French"
      
      label {
        text "Bonjour Univers!"
      }
    }
  }
}.open
```

If you are new to Glimmer, you have learned enough to start running some [samples](#samples) directly or by reading through [Glimmer GUI DSL Keywords](#glimmer-gui-dsl-keywords) (which list each keyword's samples). Go ahead and run all Glimmer [samples](#samples), and come back to read the rest in any order you like since this material is more organized like a reference.

If you are an advanced user of Glimmer DSL for SWT and need more widgets, check out the [Nebula Project](https://github.com/AndyObtiva/glimmer-cw-nebula) for an extensive list (50+) of high quality custom widgets.

#### Glimmer GUI DSL Keywords

This is not an exaustive list, but should give you a good start in learning Glimmer GUI DSL keywords, keeping in mind that the full list can be derived from the [SWT documentation](https://www.eclipse.org/swt/widgets/). More will be explained in the following sections.

**Widgets:**
- `button`: featured in [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, Button!](/docs/reference/GLIMMER_SAMPLES.md#hello-button) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Message Box!](/docs/reference/GLIMMER_SAMPLES.md#hello-message-box) / [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login)
- `browser`: featured in [Hello, Browser!](/docs/reference/GLIMMER_SAMPLES.md#hello-browser)
- `calendar`: featured in [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time)
- `checkbox`: featured in [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox)
- `checkbox_group`: featured in [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group)
- `combo`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo)
- `composite`: featured in [Hello, Composite!](/docs/reference/GLIMMER_SAMPLES.md#hello-composite) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `cool_bar`: featured in [Hello, Cool Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-cool-bar)
- `date`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `date_drop_down`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time)
- `group`: featured in [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `label`: featured in [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, World!](/docs/reference/GLIMMER_SAMPLES.md#hello-world) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Tab!](/docs/reference/GLIMMER_SAMPLES.md#hello-tab) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login)
- `list` (w/ optional `:multi` SWT style): featured in [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `menu`: featured in [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table)
- `menu_bar`: featured in [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar)
- `menu_item`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar)
- `message_box`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Message Box!](/docs/reference/GLIMMER_SAMPLES.md#hello-message-box) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar)
- `radio`: featured in [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group)
- `radio_group`: featured in [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group)
- `scrolled_composite`
- `shell`: featured in [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, Button!](/docs/reference/GLIMMER_SAMPLES.md#hello-button) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Tab!](/docs/reference/GLIMMER_SAMPLES.md#hello-tab) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login)
- `tab_folder`: featured in [Hello, Tab!](/docs/reference/GLIMMER_SAMPLES.md#hello-tab)
- `tab_item`: featured in [Hello, Tab!](/docs/reference/GLIMMER_SAMPLES.md#hello-tab)
- `table`: featured in [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `table_column`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `text`: featured in [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `time`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time)
- `tool_bar`: featured in [Hello, Tool Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-tool-bar)
- `tool_item`: featured in [Hello, Tool Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-tool-bar)
- `Glimmer::UI::CustomWidget`: ability to define any keyword as a custom widget - featured in [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget)
- `Glimmer::UI::CustomShell` (alias: `Glimmer::UI::Application`): ability to define any keyword as a custom shell (aka custom window or app) - featured in [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell)

**Layouts:**
- `grid_layout`: featured in [Hello, Layout!](/docs/reference/GLIMMER_SAMPLES.md#hello-layout) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar) / [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `row_layout`: featured in [Hello, Layout!](/docs/reference/GLIMMER_SAMPLES.md#hello-layout) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `fill_layout`: featured in [Hello, Layout!](/docs/reference/GLIMMER_SAMPLES.md#hello-layout) / [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget)
- `layout_data`: featured in [Hello, Layout!](/docs/reference/GLIMMER_SAMPLES.md#hello-layout) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)

**Graphics/Style:**
- `color`: featured in [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar)
- `font`: featured in [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `Point` class used in setting location on widgets
- `swt` and `SWT` class to set SWT styles on widgets - featured in [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)

**Data-Binding/Observers:**
- `bind`: featured in [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed) / [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, Button!](/docs/reference/GLIMMER_SAMPLES.md#hello-button) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) / [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `observe`: featured in [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `on_widget_selected`: featured in [Hello, Combo!](/docs/reference/GLIMMER_SAMPLES.md#hello-combo) / [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) / [Hello, Checkbox!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox) / [Hello, Button!](/docs/reference/GLIMMER_SAMPLES.md#hello-button) / [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) / [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) / [Hello, Radio!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio) / [Hello, Pop Up Context Menu!](/docs/reference/GLIMMER_SAMPLES.md#hello-pop-up-context-menu) / [Hello, Message Box!](/docs/reference/GLIMMER_SAMPLES.md#hello-message-box) / [Hello, Menu Bar!](/docs/reference/GLIMMER_SAMPLES.md#hello-menu-bar) / [Hello, List Single Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-single-selection) / [Hello, List Multi Selection!](/docs/reference/GLIMMER_SAMPLES.md#hello-list-multi-selection) / [Hello, Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-group) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) / [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `on_modify_text`
- `on_key_pressed` (and SWT alias `on_swt_keydown`) - featured in [Login](/docs/reference/GLIMMER_SAMPLES.md#login) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)
- `on_key_released` (and SWT alias `on_swt_keyup`)
- `on_mouse_down` (and SWT alias `on_swt_mousedown`)
- `on_mouse_up` (and SWT alias `on_swt_mouseup`) - featured in [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) / [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager)

**Event loop:**
- `display`: featured in [Tic Tac Toe](/docs/reference/GLIMMER_SAMPLES.md#tic-tac-toe)
- `async_exec`: featured in [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) / [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell)
- `sync_exec`: executes a block on the event loop synchronously (usually from another thread)
- `timer_exec`: executes a block after a delay of time has passed
- `auto_exec`: executes a block on the event loop synchronously only when needed (when running from a thread other than GUI thread)

#### SWT Proxies

Glimmer follows Proxy Design Pattern by having Ruby proxy wrappers for all SWT objects:
- `Glimmer::SWT:WidgetProxy` wraps all descendants of `org.eclipse.swt.widgets.Widget` except the ones that have their own wrappers.
- `Glimmer::SWT::ShellProxy` wraps `org.eclipse.swt.widgets.Shell`
- `Glimmer::SWT:TabItemProxy` wraps `org.eclipse.swt.widget.TabItem` (also adds a composite to enable adding content under tab items directly in Glimmer)
- `Glimmer::SWT:LayoutProxy` wraps all descendants of `org.eclipse.swt.widget.Layout`
- `Glimmer::SWT:LayoutDataProxy` wraps all layout data objects
- `Glimmer::SWT:DisplayProxy` wraps `org.eclipse.swt.widget.Display` (manages displaying GUI)
- `Glimmer::SWT:ColorProxy` wraps `org.eclipse.swt.graphics.Color`
- `Glimmer::SWT:FontProxy` wraps `org.eclipse.swt.graphics.Font`
- `Glimmer::SWT::WidgetListenerProxy` wraps all widget listeners

These proxy objects have an API and provide some convenience methods, some of which are mentioned below.

##### swt_widget

Glimmer SWT proxies come with the instance method `#swt_widget`, which returns the actual SWT `Widget` object wrapped by the Glimmer widget proxy. It is useful in cases you'd like to do some custom SWT programming outside of Glimmer.

##### Shell Widget Proxy Methods

Shell widget proxy has extra methods specific to SWT Shell:
- `#open`: Opens the shell, making it visible and active, and starting the SWT Event Loop (you may learn more about it here: https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/Display.html). If shell was already open, but hidden, it makes the shell visible.
- `#show`: Alias for `#open`
- `#hide`: Hides a shell setting "visible" property to false
- `#close`: Closes the shell
- `#center_within_display`: Centers the shell within monitor it is in
- `#start_event_loop`: (happens as part of `#open`) Starts SWT Event Loop (you may learn more about it here: https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/Display.html). This method is not needed except in rare circumstances where there is a need to start the SWT Event Loop before opening the shell.
- `#visible?`: Returns whether a shell is visible
- `#opened_before?`: Returns whether a shell has been opened at least once before (additionally implying the SWT Event Loop has been started already)
- `#visible=`: Setting to true opens/shows shell. Setting to false hides the shell.
- `#layout`: Lays out contained widgets using SWT's `Shell#layout` method
- `#pack`: Packs contained widgets using SWT's `Shell#pack` method
- `#pack_same_size`: Packs contained widgets without changing shell's size when widget sizes change

##### Widget Content Block

Glimmer allows re-opening any widget and adding properties or extra content after it has been constructed already by using the `#content` method.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
@shell = shell {
  text "Application"
  row_layout
  
  @label1 = label {
    text "Hello,"
  }
}
@shell.content {
  minimum_size 130, 130
  
  label {
    text "World!"
  }
}
@label1.content {
  foreground :red
}
@shell.open
```

##### Tab Folder API

Unlike basic SWT usage, `tab_folder` has the smart default of pre-initializing all tabs so that they are properly sized/filled so no delays occur when a user browses through them for the first time by selecting unselected tabs.

The [Stock Ticker](/docs/reference/GLIMMER_SAMPLES.md#stock-ticker) sample takes advantage of this to ensure all tabs are pre-initialized and filled with rendered data even before the user selects any of them.

That said, `tab_folder` can optionally receive a custom Glimmer SWT style named `:initialize_tabs_on_select`, which disables that behavior by going back to SWT's default of initializing tabs upon first selection (e.g. upon clicking with the mouse).

##### Shell Icon

To set the shell icon, simply set the `image` property under the `shell` widget. This shows up in the operating system toolbar and app-switcher (e.g. CMD+TAB) (and application window top-left corner in Windows)

Example:

```ruby
shell {
  # ...
  image 'path/to/image.png'
  # ...
}
```

###### Shell Icon Tip for Packaging on Windows

When setting shell icon for a [packaged](GLIMMER_PACKAGING_AND_DISTRIBUTION.md#packaging--distribution) app, which has a JAR file at its core, you can reference the `ico` file that ships with the app by going one level up (e.g. `'../AppName.ico'`)

#### Dialog

Dialog is a variation on Shell. It is basically a shell that is modal (blocks what's behind it) and belongs to another shell. It only has a close button.

Glimmer facilitates building dialogs by using the `dialog` keyword, which automatically adds the SWT.DIALOG_TRIM and SWT.APPLICATION_MODAL [widget styles](#widget-styles) needed for a dialog.

Check out [Hello, Dialog!](/docs/reference/GLIMMER_SAMPLES.md#hello-dialog) sample to learn more.

##### message_box

The Glimmer DSL `message_box` keyword is similar to `shell` and `dialog`, but renders a modal dialog with a title `text` property, main body `message` property, and dismissal button(s) only (OK button by default or [more options](https://www.eclipse.org/swt/javadoc.php)). It may also be opened via the `#open` method.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

@shell = shell {
  text 'Hello, Message Box!'
  
  button {
    text 'Please Click To Win a Surprise'
    
    on_widget_selected do
      message_box(@shell) {
        text 'Surprise'
        message "Congratulations!\n\nYou have won $1,000,000!"
      }.open
    end
  }
}
@shell.open
```

![Hello Message Box Dialog](/images/glimmer-hello-message-box-dialog.png)

It is also possible to use `message_box` even before instantiating the first `shell` ([Glimmer](https://rubygems.org/gems/glimmer) builds a throwaway `shell` parent automatically for it):

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

message_box {
  text 'Greeting'
  message "Hello, World!"
}.open
```

#### Display

The SWT `Display` class is a singleton in Glimmer. It is used in SWT to represent your display device, allowing you to manage GUI globally
and access available monitors. Additionally, it is responsible for the SWT event loop, which runs on the first thread the Glimmer application starts on. In multi-threaded programming, `Display` provides the methods `async_exec` and `sync_exec` to enable enqueuing GUI changes asynchronously or synchronously from threads other than the main (first) thread since direct GUI changes are forbidden from other threads by design.

`Display` is automatically instantiated upon first instantiation of a `shell` widget.

Alternatively, for advanced use cases, a `Display` can be created explicitly with the Glimmer `display` keyword. When a `shell` is later declared, it
automatically uses the `display` created earlier without having to explicitly hook it.

```ruby
@display = display {
  cursor_location 300, 300
  
  on_swt_keydown do
    # ...
  end
  # ...
}
@shell = shell { # uses display created above
}
```
The benefit of instantiating an SWT Display explicitly is to set [Properties](#widget-properties) or [Observers](#observer).
Although SWT Display is not technically a widget, it has similar APIs and DSL support.

#### Multi-Threading

[JRuby](https://www.jruby.org/) supports [truly parallel multi-threading](https://github.com/jruby/jruby/wiki/Concurrency-in-jruby) since it relies on the JVM (Java Virtual Machine). As such, it enables development of highly-interactive desktop applications that can do background work while the user is interacting with the GUI. However, any code that interacts with the GUI from a thread other than the main (first) GUI thread must do so only through sync_exec (if it is standard synchronous code) or async_exec.

Most of the time, you simply get away with Ruby [Threads](https://ruby-doc.org/core-2.5.7/Thread.html) and [Mutexes](https://ruby-doc.org/core-2.5.7/Mutex.html).

Otherwise, if you need more advanced concurrency, Glimmer includes the [concurrent-ruby gem](https://rubygems.org/gems/concurrent-ruby), which supports many helpful concurrency techniques such as [Thread Pools](http://ruby-concurrency.github.io/concurrent-ruby/master/file.thread_pools.html) (used in the [Mandelbrot Fractal](/docs/reference/GLIMMER_SAMPLES.md#mandelbrot-fractal) sample).

One thing Glimmer DSL for SWT innovates over plain old SWT is not requiring developers to explicitly use `Display.syncExec` from threads other than the GUI threads.
Glimmer automatically detects if you're running in a different thread and uses `Display.syncExec` automatically using its own enhanced `auto_exec`

In any case, Glimmer still allows developers to manually use `sync_exec`, `async_exec`, `timer_exec`, and `auto_exec` when needed. M

##### async_exec

`async_exec {}` is a Glimmer DSL keyword in addition to being a method on `display`. It accepts a block and when invoked, adds the block to the end of a queue of GUI events scheduled to run on the SWT event loop, executing asynchronously.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```
@shell = shell {
  text 'Glimmer'
  
  @label = label {
    text 'Hello, World!'
  }
}

Thread.new do
  [:red, :dark_green, :blue].cycle do |color|
    async_exec do
      @label.content {
        foreground color if @shell.visible?
      }
    end
    sleep(1)
  end
end

@shell.open
```

##### sync_exec

`sync_exec {}` is required by SWT when running GUI update from a thread other than the GUI thread. In Glimmer, it is automatically invoked for you so that you wouldn't have to worry about it. It works just like `async_exec` except it executes the block synchronously at the earliest opportunity possible, waiting for the block to be finished.

##### sync_call

`sync_exec {}` is required by SWT when running GUI update from a thread other than the GUI thread. In Glimmer, it is automatically invoked for you so that you wouldn't have to worry about it. It works just like `async_exec` except it executes the block synchronously at the earliest opportunity possible, waiting for the block to be finished.

##### auto_exec

`auto_exec(override_sync_exec:, override_async_exec) {}` only executes code block with `sync_exec` when necessary (running from a thread other than the GUI thread). It is used automatically all over the Glimmer DSL for SWT codebase, so you wouldn't need it unless you grab a direct handle on `swt_widget` from a widget proxy.

##### timer_exec

`timer_exec(delay_in_milliseconds) {}` works just like `async_exec` except it executes the block after a delay has elapsed.

#### Menus

Glimmer DSL provides support for SWT Menu and MenuItem widgets.

There are 2 main types of menus in SWT:
- Menu Bar (shows up on top)
- Pop Up Context Menu (shows up when right-clicking a widget)

Underneath both types, there can be a 3rd menu type called Drop Down.

Glimmer provides special support for Drop Down menus as it automatically instantiates associated Cascade menu items and wires together with proper parenting, swt styles, and calling setMenu.

The ampersand symbol indicates the keyboard shortcut key for the menu item (e.g. '&Help' can be triggered on Windows by hitting ALT+H)

Example of a Menu Bar (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

COLORS = [:white, :red, :yellow, :green, :blue, :magenta, :gray, :black]

shell {
  grid_layout {
    margin_width 0
    margin_height 0
  }
  
  text 'Hello, Menu Bar!'
  
  @label = label(:center) {
    font height: 50
    text 'Check Out The Menu Bar Above!'
  }
  
  menu_bar {
    menu {
      text '&File'
      menu_item {
        text '&New'
        accelerator :command, :N
        
        on_widget_selected do
          message_box {
            text 'New'
            message 'New file created.'
          }.open
        end
      }
      menu_item {
        text '&Open...'
        accelerator :command, :O
        
        on_widget_selected do
          message_box {
            text 'Open'
            message 'Opening File...'
          }.open
        end
      }
      menu {
        text 'Open &Recent'
        
        menu_item {
          text 'File 1'
          
          on_widget_selected do
            message_box {
              text 'File 1'
              message 'File 1 Contents'
            }.open
          end
        }
        
        menu_item {
          text 'File 2'
          
          on_widget_selected do
            message_box {
              text 'File 2'
              message 'File 2 Contents'
            }.open
          end
        }
      }
      
      menu_item(:separator)
      
      menu_item {
        text 'E&xit'
        
        on_widget_selected do
          exit(0)
        end
      }
    }
    menu {
      text '&Edit'
      
      menu_item {
        text 'Cut'
        accelerator :command, :X
      }
      
      menu_item {
        text 'Copy'
        accelerator :command, :C
      }
      
      menu_item {
        text 'Paste'
        accelerator :command, :V
      }
    }
    
    menu {
      text '&Options'
      
      menu_item(:radio) {
        text '&Enabled'
        
        on_widget_selected do
          @select_one_menu.enabled = true
          @select_multiple_menu.enabled = true
        end
      }
      
      @select_one_menu = menu {
        text '&Select One'
        enabled false
        
        menu_item(:radio) {
          text 'Option 1'
        }
        
        menu_item(:radio) {
          text 'Option 2'
        }
        
        menu_item(:radio) {
          text 'Option 3'
        }
      }
      
      @select_multiple_menu = menu {
        text '&Select Multiple'
        enabled false
        
        menu_item(:check) {
          text 'Option 4'
        }
        
        menu_item(:check) {
          text 'Option 5'
        }
        
        menu_item(:check) {
          text 'Option 6'
        }
      }
    }
    
    menu {
      text '&Format'
      
      menu {
        text '&Background Color'
        
        COLORS.each { |color_style|
          menu_item(:radio) {
            text color_style.to_s.split('_').map(&:capitalize).join(' ')
            
            on_widget_selected do
              @label.background = color_style
            end
          }
        }
      }
      
      menu {
        text 'Foreground &Color'
        
        COLORS.each { |color_style|
          menu_item(:radio) {
            text color_style.to_s.split('_').map(&:capitalize).join(' ')
            
            on_widget_selected do
              @label.foreground = color_style
            end
          }
        }
      }
    }
    
    menu {
      text '&View'
      
      menu_item(:radio) {
        text 'Small'
        
        on_widget_selected do
          @label.font = {height: 25}
          @label.parent.pack
        end
      }
      
      menu_item(:radio) {
        text 'Medium'
        selection true
        
        on_widget_selected do
          @label.font = {height: 50}
          @label.parent.pack
        end
      }
      
      menu_item(:radio) {
        text 'Large'
        
        on_widget_selected do
          @label.font = {height: 75}
          @label.parent.pack
        end
      }
    }
    
    menu {
      text '&Help'
      
      menu_item {
        text '&Manual'
        accelerator :command, :shift, :M
        
        on_widget_selected do
          message_box {
            text 'Manual'
            message 'Manual Contents'
          }.open
        end
      }
      
      menu_item {
        text '&Tutorial'
        accelerator :command, :shift, :T
        
        on_widget_selected do
          message_box {
            text 'Tutorial'
            message 'Tutorial Contents'
          }.open
        end
      }
      
      menu_item(:separator)
      
      menu_item {
        text '&Report an Issue...'
        
        on_widget_selected do
          message_box {
            text 'Report an Issue'
            message 'Reporting an issue...'
          }.open
        end
      }
    }
  }
}.open
```

Example of a Pop Up Context Menu (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  grid_layout {
    margin_width 0
    margin_height 0
  }
  
  text 'Hello, Pop Up Context Menu!'
  
  label {
    text "Right-Click on the Text to\nPop Up a Context Menu"
    font height: 50
    
    menu {
      menu {
        text '&History'
        
        menu {
          text '&Recent'
          
          menu_item {
            text 'File 1'
            
            on_widget_selected do
              message_box {
                text 'File 1'
                message 'File 1 Contents'
              }.open
            end
          }
          
          menu_item {
            text 'File 2'
            
            on_widget_selected do
              message_box {
                text 'File 2'
                message 'File 2 Contents'
              }.open
            end
          }
        }
        
        menu {
          text '&Archived'
          
          menu_item {
            text 'File 3'
            
            on_widget_selected do
              message_box {
                text 'File 3'
                message 'File 3 Contents'
              }.open
            end
          }
          
          menu_item {
            text 'File 4'
            
            on_widget_selected do
              message_box {
                text 'File 4'
                message 'File 4 Contents'
              }.open
            end
          }
        }
      }
    }
  }
}.open
```

#### Tray Item

![Hello Tray Item Icon](/images/glimmer-hello-tray-item.png)

The system tray allows showing icons for various apps that need to stay on for extended periods of time and provide quick access.

In Glimmer DSL for SWT, generating tray items is automated via the `tray_item` keyword, which can be nested under `shell` and then have a child `menu` underneath that pops up when the user clicks on its icon in the system tray. It is recommended that the related shell is declared with the `:on_top` style (in addition to the default style `:shell_trim`) to ensure it opens above all apps when shown.

Note that if you would like to display notifications, you can use the [JFace Notification API](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/jface/notifications/NotificationPopup.html) and new [JFace Notification builder](https://www.eclipse.org/eclipse/news/4.23/platform_isv.php#notification-api), the [Nebula Notifier custom widget](https://github.com/AndyObtiva/glimmer-cw-nebula#notifier), or the [Two Slices](https://github.com/sshtools/two-slices) Java library.

Example code:

```ruby
    shell(:shell_trim, :on_top) { # make it always appear on top of everything
      row_layout(:vertical) {
        center true
      }
      text 'Hello, Tray Item!'
      
      on_shell_closed do |event|
        # do not perform event that closes app when shell is closed
        event.doit = false
        # body_root is the root shell
        body_root.hide
        self.show_application = false # updates Show Application checkbox menu item indirectly
      end
      
      tray_item {
        tool_tip_text 'Glimmer'
        image @image # could use an image path instead

        menu {
          menu_item {
            text 'About'

            on_widget_selected do
              message_box {
                text 'Glimmer - About'
                message 'This is a Glimmer DSL for SWT Tray Item'
              }.open
            end
          }
          menu_item(:separator)
          menu_item(:check) {
            text 'Show Application'
            selection <=> [self, :show_application]
            
            on_widget_selected do
              # body_root is the root shell
              if body_root.visible?
                body_root.hide
              else
                body_root.show
              end
            end
          }
          menu_item(:separator)
          menu_item {
            text 'Exit'

            on_widget_selected do
              exit(0)
            end
          }
        }
        
        # supported tray item listeners (you can try to add actions to them when needed)
#         on_swt_Show do
#         end
#
#         on_swt_Hide do
#         end
#
#         on_widget_selected do
#         end
#
#         on_menu_detected do
#         end
      }
      
      label(:center) {
        text 'This is the application'
        font height: 30
      }
      label {
        text 'Click on the tray item (circles icon) to open its menu'
      }
      label {
        text 'Uncheck Show Application to hide the app and recheck it to show the app'
      }
    }
```

Learn more at [Hello, Tray Item!](/docs/reference/GLIMMER_SAMPLES.md#hello-tray-item)

#### ScrolledComposite

Glimmer provides smart defaults for the `scrolled_composite` widget by:
- Automatically setting the nested widget as its content (meaning use can just like a plain old `composite` to add scrolling)
- Automatically setting the :h_scroll and :v_scroll SWT styles (can be set manually if only one of either :h_scroll or :v_scroll is desired )
- Automatically setting the expand horizontal and expand vertical SWT properties to `true`

#### Sash Form Widget

`sash_form` is an SWT built-in custom widget that provides a resizable sash that splits a window area into two or more panes.

It can be customized with the `weights` attribute by setting initial weights to size the panes at first display.

One noteworthy thing about the Glimmer implementation is that, unlike behavior in SWT, it allows declaring `weights` before the content of the `sash_form`, thus providing more natural and convenient syntax (Glimmer automatically takes care of sending that declaration to SWT at the end of declaring `sash_form` content as per the SWT requirements)

You can customize the color of the sash by setting the `background` attribute.

Also, you can customize the `sash_width` (`Integer`) and `orientation` properties (`swt(:horizontal)` or `swt(:vertical)`).

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
shell {
  text 'Sash Form Example'
  sash_form {
    label {
      text '(resize >>)'
      background :dark_green
      foreground :white
      font height: 20
    }
    label {
      text '(<< resize)'
      background :red
      foreground :white
      font height: 20
    }
    weights 1, 2
  }
}.open
```

You may check out a more full-fledged example in [Hello, Sash Form!](/docs/reference/GLIMMER_SAMPLES.md#hello-sash-form)

![Hello Sash Form](/images/glimmer-hello-sash-form.png)

#### Browser Widget

![Hello Browser](/images/glimmer-hello-browser.png)

Glimmer DSL for SWT includes a basic [SWT Browser widget](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/browser/Browser.html), which can load URLs or render HTML. It supports WebKit (default on Mac/Linux), Edge (default on Windows), and IE (pass SWT style `:none` to activate on Windows) browsers out of the box. Its JavaScript engine can even be instrumented with Ruby code if needed.

Example loading a URL (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
shell {
  minimum_size 1024, 860
  maximum_size 2000, 1000
  browser {
    url 'http://brightonresort.com/about'
  }
}.open
```

Example rendering HTML with JavaScript on document ready (you may copy/paste in [`girb`](GLIMMER_GIRB.md) provided you install and require [glimmer-dsl-xml gem](https://github.com/AndyObtiva/glimmer-dsl-xml)):

```ruby
shell {
  minimum_size 130, 130
  @browser = browser {
    text html {
      head {
        meta(name: "viewport", content: "width=device-width, initial-scale=2.0")
      }
      body {
        h1 { "Hello, World!" }
      }
    }
    on_completed do # on load of the page execute this JavaScript
      @browser.swt_widget.execute("alert('Hello, World!');")
    end
  }
}.open
```

This relies on Glimmer's [Multi-DSL Support](#multi-dsl-support) for building the HTML text using [Glimmer XML DSL](https://github.com/AndyObtiva/glimmer-dsl-xml).

Learn more at:
- [SWT Browser API](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/browser/Browser.html)
- [SWT Browser FAQ](https://www.eclipse.org/swt/faq.php#whatisbrowser).

The built-in basic SWT `browser` widget might not satisfy all your needs. If so, consider the advanced 3rd-party browser widget [JxBrowser](https://www.teamdev.com/jxbrowser), which utilizes Google Chromium.

### Widget Styles

SWT widgets receive `SWT` styles in their constructor as per this guide:

https://wiki.eclipse.org/SWT_Widget_Style_Bits

Glimmer DSL facilitates that by passing symbols representing `SWT` constants as widget method arguments (i.e. inside widget `()` parentheses according to [Glimmer Style Guide](GLIMMER_STYLE_GUIDE.md). See example below) in lower case version (e.g. `SWT::MULTI` becomes `:multi`).

These styles customize widget look, feel, and behavior.

Example:

```ruby
# ...
list(:multi) { # SWT styles go inside ()
  # ...
}
# ...
```
Passing `:multi` to `list` widget enables list element multi-selection.

```ruby
# ...
composite(:border) { # SWT styles go inside ()
  # ...
}
# ...
```
Passing `:border` to `composite` widget ensures it has a border.

When you need to pass in **multiple SWT styles**, simply separate by commas.

Example:

```ruby
# ...
text(:center, :border) { # Multiple SWT styles separated by comma
  # ...
}
# ...
```

Glimmer ships with SWT style **smart defaults** so you wouldn't have to set them yourself most of the time (albeit you can always override them):

- `text(:border)`
- `table(:border, :virtual, :full_selection)`
- `tree(:border, :virtual, :v_scroll, :h_scroll)`
- `spinner(:border)`
- `list(:border, :v_scroll)`
- `button(:push)`

You may check out all available `SWT` styles here:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html

#### Explicit SWT Style Bit

When building a widget-related SWT object manually (e.g. `GridData.new(...)`), you are expected to use `SWT::CONSTANT` directly or BIT-OR a few SWT constants together like `SWT::BORDER | SWT::V_SCROLL`.

Glimmer facilitates that with `swt` keyword by allowing you to pass multiple styles as an argument array of symbols instead of dealing with BIT-OR.
Example:

```ruby
style = swt(:border, :v_scroll)
```

#### Negative SWT Style Bits

In rare occasions, you might need to apply & with a negative (not) style bit to negate it from another style bit that includes it.
Glimmer facilitates that by declaring the negative style bit via postfixing a symbol with `!`.

Example:

```ruby
style = swt(:shell_trim, :max!) # creates a shell trim style without the maximize button (negated)
```

#### Extra SWT Styles

##### Non-resizable Window

SWT Shell widget by default is resizable. To make it non-resizable, one must pass a complicated style bit concoction like `swt(:shell_trim, :resize!, :max!)`.

Glimmer makes this easier by alternatively ing a `:no_resize` extra SWT style, added for convenience.
This makes declaring a non-resizable window as easy as:

```ruby
shell(:no_resize) {
  # ...
}
```

##### Fill Screen Window

SWT Shell can open and fill the screen with this style `swt(:fill_screen)`. This makes it have the size of the display, thus filling the screen. Keep in mind that this is different from being maximized (which is a special window state, not just filling the screen).

### Widget Properties

Widget properties such as text value, enablement, visibility, and layout details are set within the widget block using methods matching SWT widget property names in lower snakecase. You may refer to SWT widget guide for details on available widget properties:

https://help.eclipse.org/2019-12/topic/org.eclipse.platform.doc.isv/guide/swt_widgets_controls.htm?cp=2_0_7_0_0


Code examples:

```ruby
# ...
label {
  text "Hello, World!" # SWT properties go inside {} block
}
# ...
```

In the above example, the `label` widget `text` property was set to "Hello, World!".

```ruby
# ...
button {
  enabled bind(@tic_tac_toe_board.box(row, column), :empty)
}
# ...
```

In the above example, the `text` widget `enabled` property was data-bound to `#empty` method on `@tic_tac_toe_board.box(row, column)` (learn more about data-binding below)

#### Color

Colors make up a subset of widget properties. SWT accepts color objects created with RGB (Red Green Blue) or RGBA (Red Green Blue Alpha). Glimmer supports constructing color objects using the `rgb` and `rgba` DSL keywords.

Example:

```ruby
# ...
label {
  background rgb(144, 240, 244)
  foreground rgba(38, 92, 232, 255)
}
# ...
```

SWT also supports standard colors available as constants under the `SWT` namespace with the `COLOR_` prefix (e.g. `SWT::COLOR_BLUE`)

Glimmer supports constructing colors for these constants as lowercase Ruby symbols (with or without `color_` prefix) passed to `color` DSL keyword

Example:

```ruby
# ...
label {
  background color(:black)
  foreground color(:yellow)
}
label {
  background color(:color_white)
  foreground color(:color_red)
}
# ...
```

You may check out all available standard colors in `SWT` over here (having `COLOR_` prefix):

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html


##### `#swt_color`

Glimmer color objects come with an instance method `#swt_color` that returns the actual SWT `Color` object wrapped by the Glimmer color object. It is useful in cases you'd like to do some custom SWT programming outside of Glimmer.

Example:

```ruby
color(:black).swt_color # returns SWT Color object
```

#### Font

Fonts are represented in Glimmer as a hash of name, height, and style keys.

The style can be one (or more) of 3 values: `:normal`, `:bold`, and `:italic`

Example:

```ruby
# ...
label {
  font name: 'Arial', height: 36, style: :normal
}
# ...
```

Keys are optional, so some of them may be left off.
When passing multiple styles, they are included in an array.

Example:

```ruby
# ...
label {
  font style: [:bold, :italic]
}
# ...
```

You may simply use the standalone `font` keyword without nesting in a parent if there is a need to build a Font object to use in manual SWT programming outside of widget font property setting.

Example:

```ruby
@font = font(name: 'Arial', height: 36, style: :normal)
```

### Image

The `image` keyword creates an instance of [org.eclipse.swt.graphics.Image](https://help.eclipse.org/2020-09/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/Image.html).

It is a graphics `Image` object (not a widget), but is used used in setting the `image` property on `label` and `background_image` on `composite` (and subclasses)

Glimmer recently included **EXPERIMENTAL** gif animation support for the `background_image` property on `composite' since SWT does not support animation by default. On Windows, it only works inside composites nested under standard shells, not ones that have the SWT styles :on_top or :no_trim

When an app is packaged (i.e. JAR inside a DMG or MSI native executable), jruby generates file paths that start with "uri:classloader". The `image` keyword automatically knows how to interpret such paths when passed as an argument.

Should you need to read a file from a JAR file manually, you may use this code (assuming a `file_path` formed using standard Ruby `File.expand_path` call, which jruby automatically overrides when running from a JAR to generate a `uri:classloader` path) :
```ruby
require 'jruby'
file_path = file_path.sub(/^uri\:classloader\:/, '').sub(/^\/+/, '')
jcl = JRuby.runtime.jruby_class_loader
resource = jcl.get_resource_as_stream(file_path)
file_input_stream = resource.to_io.to_input_stream
```

Learn more about images in general at this SWT Image guide: https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html

#### Image Options

Options may be passed in a hash at the end of `image` arguments:

- `width`: width of image
- `height`: height of image

If only the width or height alone are specified, the other is calculated while maintaining the image aspect ratio.

Example:

```
label {
  image 'someimage.png', width: 400, height: 300
}
```

### Cursor

SWT widget `cursor` property represents the mouse cursor you see on the screen when you hover over that widget.

The `Display` class provides a way to obtain standard system cursors matching of the SWT style constants starting with prefix `CURSOR_` (e.g. `SWT::CURSOR_HELP` shows a question mark mouse cursor)

Glimmer provides an easier way to obtain and set `cursor` property on a widget by simply mentioning the SWT style constant as an abbreviated symbol excluding the "CURSOR_" suffix.

Example:

```ruby
shell {
  minimum_size 128, 128
  cursor :appstarting
}
```

This sets the shell `cursor` to that of `SWT::CURSOR_APPSTARTING`

### Layouts

Glimmer lays widgets out visually using SWT layouts, configurable with many options (e.g. whether widgets are responsive to window sizing), which can only be set on composite widget and subclasses.

The most common SWT layouts are:
- [`fill_layout`](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/layout/FillLayout.html): lays widgets out in equal proportion horizontally or vertically with spacing/margin options. This is the ***default*** layout for ***shell*** (with `:horizontal` option) in Glimmer.
- [`row_layout`](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/layout/RowLayout.html): lays widgets out horizontally or vertically in varying proportions with advanced spacing/margin/justify options
- [`grid_layout`](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/layout/GridLayout.html): lays widgets out in a grid with advanced spacing/margin/alignment/indentation options. This is the **default** layout for **composite** in Glimmer. It is important to master.

Note that if you need to have widgets fill a `row_layout` and resize automatically upon window resize, you must nest `fill true` within. This is the automatic behavior of `fill_layout`. For `grid_layout`, you would have to add `layout_data :fill, :center, true, false` to a child that you want to fill all available space horizontally (whether initially or after window resize) and `layout_data :fill, :fill, true, true` if you want to fill all available space horizontally and vertically.

Do not be alarmed if widget sizes were kept fixed on resize of a window or change of text data. This is normal behavior that can always be overridden with options, such as `fill true` mentioned above. You need to [learn more about each layout](https://help.eclipse.org/latest/index.jsp?topic=/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/layout/package-summary.html) before you have mastered them enough for your needs. [Samples](/docs/reference/GLIMMER_SAMPLES.md) like [Hello, Layout!](/docs/reference/GLIMMER_SAMPLES.md#hello-layout) are greatly helpful in learning too.

In Glimmer DSL, just like widgets, layouts can be specified with lowercase underscored names followed by a block containing properties, also lowercase underscored names (e.g. `RowLayout` is `row_layout`).

Example:

```ruby
# ...
composite {
  row_layout {
    wrap true
    pack false
    justify true
    type :vertical
    margin_left 1
    margin_top 2
    margin_right 3
    margin_bottom 4
    spacing 5
  }
  # ... widgets follow
}
# ...
```

If you data-bind any layout properties, when they change, the shell containing their widget re-packs its children (calls `#pack` method automatically) to ensure proper relayout of all widgets.

Alternatively, a layout may be constructed by following the SWT API for the layout object. For example, a `RowLayout` can be constructed by passing it an SWT style constant (Glimmer automatically accepts symbols (e.g. `:horizontal`) for SWT style arguments like `SWT::HORIZONTAL`.)

```ruby
# ...
composite {
  row_layout :horizontal
  # ... widgets follow
}
# ...
```

Here is a more sophisticated example taken from [hello_computed.rb](samples/hello/hello_computed.rb) sample:

![Hello Computed](/images/glimmer-hello-computed.png)

```ruby
shell {
  text 'Hello, Computed!'
  composite {
    grid_layout {
      num_columns 2
      make_columns_equal_width true
      horizontal_spacing 20
      vertical_spacing 10
    }
    label {text 'First &Name: '}
    text {
      text bind(@contact, :first_name)
      layout_data {
        horizontal_alignment :fill
        grab_excess_horizontal_space true
      }
    }
    label {text '&Last Name: '}
    text {
      text bind(@contact, :last_name)
      layout_data {
        horizontal_alignment :fill
        grab_excess_horizontal_space true
      }
    }
    label {text '&Year of Birth: '}
    text {
      text bind(@contact, :year_of_birth)
      layout_data {
        horizontal_alignment :fill
        grab_excess_horizontal_space true
      }
    }
    label {text 'Name: '}
    label {
      text bind(@contact, :name, computed_by: [:first_name, :last_name])
      layout_data {
        horizontal_alignment :fill
        grab_excess_horizontal_space true
      }
    }
    label {text 'Age: '}
    label {
      text bind(@contact, :age, on_write: :to_i, computed_by: [:year_of_birth])
      layout_data {
        horizontal_alignment :fill
        grab_excess_horizontal_space true
      }
    }
  }
}.open
```

Check out the samples directory for more advanced examples of layouts in Glimmer.

**Defaults**:

Glimmer composites always come with `grid_layout` by default, but you can still specify explicitly if you'd like to set specific properties on it.

Glimmer shell always comes with `fill_layout` having `:horizontal` type.

If you ever want to force a re-layout on a `composite` or `shell`, you can call the following:

```ruby
composite_or_shell.layout(true, true)
composite_or_shell.pack(true)
```

This is a great guide for learning more about SWT layouts:

https://www.eclipse.org/articles/Article-Understanding-Layouts/Understanding-Layouts.htm

Also, for a reference, check the SWT API:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/index.html

### Layout Data

Layouts organize widgets following common rules for all widgets directly under a composite. But, what if a specific widget needs its own rules. That's where layout data comes into play.

By convention, SWT layouts expect widgets to set layout data with a class matching their class name with the word "Data" replacing "Layout":
- `GridLayout` on a composite demands `GridData` on contained widgets
- `RowLayout` on a composite demands `RowData` on contained widgets

Not all layouts support layout data to further customize widget layouts. For example, `FillLayout` supports no layout data.

Unlike widgets and layouts in Glimmer DSL, layout data is simply specified with `layout_data` keyword nested inside a widget block body, and followed by arguments and/or a block of its own properties (lowercase underscored names).

Glimmer automatically deduces layout data class name by convention as per rule above, with the assumption that the layout data class lives under the same exact Java package as the layout (one can set custom layout data that breaks convention if needed in rare cases. See code below for an example)

Glimmer also automatically accepts symbols (e.g. `:fill`) for SWT style arguments like `SWT::FILL`.

Examples:

```ruby
# ...
composite {
  row_layout :horizontal
  label {
    layout_data { # followed by properties
      width 50
      height 30
    }
  }
  # ... more widgets follow
}
# ...
```

```ruby
# ...
composite {
  grid_layout 3, false # grid layout with 3 columns not of equal width
  label {
    # layout data followed by arguments passed to SWT GridData constructor
    layout_data :fill, :end, true, false
  }
}
# ...
```

```ruby
# ...
composite {
  grid_layout 3, false # grid layout with 3 columns not of equal width
  label {
    # layout data with explicit setting of properties instead of relying on arguments
    layout_data {
      horizontal_alignment :fill # could be :beginning, :center or :end too
      vertical_alignment :center # could be :beginning, :fill, or :end too
      grab_excess_horizontal_space true
      grab_excess_vertical_space false
    }
  }
}
# ...
```

```ruby
# ...
composite {
  grid_layout 3, false # grid layout with 3 columns not of equal width
  label {
    # layout data set explicitly via an object (helps in rare cases that break convention)
    layout_data GridData.new(swt(:fill), swt(:end), true, false)
  }
}
# ...
```

If you data-bind any layout data properties, when they change, the shell containing their widget re-packs its children (calls `#pack` method automatically) to ensure proper relayout of all widgets.

Also, if you ever want a widget to be excluded from layout entirely (in addition to having `visible false` on the widget), you can set `layout_data { exclude true }` or data-bind `exclude` property of `layout_data` to have a widget included/excluded automatically based on a condition.

Here is a re-implementation of the [Login sample](/docs/reference/GLIMMER_SAMPLES.md#login) that hides/shows login/logout buttons upon login/logout (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

class LoginPresenter

  attr_accessor :user_name
  attr_accessor :password
  attr_accessor :status

  def initialize
    @user_name = ""
    @password = ""
    @status = "Logged Out"
  end

  def status=(status)
    @status = status
  end
  
  def valid?
    !@user_name.to_s.strip.empty? && !@password.to_s.strip.empty?
  end

  def logged_in?
    self.status == "Logged In"
  end

  def logged_out?
    !self.logged_in?
  end

  def login!
    return unless valid?
    self.status = "Logged In"
  end

  def logout!
    self.user_name = ""
    self.password = ""
    self.status = "Logged Out"
  end

end

class Login
  include Glimmer::UI::CustomShell

  before_body do
    @presenter = LoginPresenter.new
  end

  body {
    shell {
      text "Login"
      
      composite {
        grid_layout(2, false) #two columns with differing widths

        label { text "Username:" } # goes in column 1
        @user_name_text = text {   # goes in column 2
          layout_data :fill, :center, true, false
          text <=> [@presenter, :user_name]
          enabled <= [@presenter, :logged_out?, computed_by: :status]
          
          on_key_pressed { |event|
            @password_text.set_focus if event.keyCode == swt(:cr)
          }
        }

        label { text "Password:" }
        @password_text = text(:password, :border) {
          layout_data :fill, :center, true, false
          text <=> [@presenter, :password]
          enabled <= [@presenter, :logged_out?, computed_by: :status]
          
          on_key_pressed { |event|
            @presenter.login! if event.keyCode == swt(:cr)
          }
        }

        label { text "Status:" }
        label {
          layout_data :fill, :center, true, false
          text <= [@presenter, :status]
        }

        button {
          layout_data {
            exclude <= [@presenter, :logged_in?, computed_by: :status]
          }
          
          text "Login"
          visible <= [@presenter, :logged_out?, computed_by: :status]
          
          on_widget_selected { @presenter.login! }
          on_key_pressed { |event|
            if event.keyCode == swt(:cr)
              @presenter.login!
            end
          }
        }

        button {
          layout_data {
            exclude <= [@presenter, :logged_out?, computed_by: :status]
          }
          
          text "Logout"
          visible <= [@presenter, :logged_in?, computed_by: :status]
          
          on_widget_selected { @presenter.logout! }
          on_key_pressed { |event|
            if event.keyCode == swt(:cr)
              @presenter.logout!
              @user_name_text.set_focus
            end
          }
        }
      }
    }
  }
end

Login.launch
```

Login (with `exclude` data-binding) - Logged Out

![Login Exclude Logged Out](/images/glimmer-login-exclude-logged-out.png)

Login (with `exclude` data-binding) - Logged In

![Login Exclude Logged In](/images/glimmer-login-exclude-logged-in.png)

**NOTE**: Layout data must never be reused between widgets. Always specify or clone again for every widget.

This is a great guide for learning more about SWT layouts:

https://www.eclipse.org/articles/Article-Understanding-Layouts/Understanding-Layouts.htm

Also, for a reference, check the SWT API:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/index.html

### Canvas Shape DSL

While other GUI toolkits only offer a way to draw graphics imperatively (e.g. draw_arc, draw_rectangle, move_to, line_to, etc...), Glimmer DSL for SWT breaks away from the mold by enabling software engineers to draw graphics declaratively. Simply declare all the shapes you want to see with their attributes, like background/foreground colors, and Glimmer DSL for SWT takes care of the rest, painting graphics on a blank `canvas` widget or amending/decorating an existing widget. This is accomplished through the Canvas Shape DSL, a sub-DSL of the Glimmer GUI DSL, which makes it possible to draw graphics declaratively with very understandable and maintainable syntax. Still, for the rare cases where imperative logic is needed, Glimmer DSL for SWT supports imperative painting of graphics through direct usage of SWT.

![Canvas Shape DSL Line](/images/glimmer-canvas-shape-dsl-line.png)
![Canvas Shape DSL Rectangle](/images/glimmer-canvas-shape-dsl-rectangle.png)
![Canvas Shape DSL Oval](/images/glimmer-canvas-shape-dsl-oval.png)
![Canvas Shape DSL Arc](/images/glimmer-canvas-shape-dsl-arc.png)
![Canvas Shape DSL Polyline](/images/glimmer-canvas-shape-dsl-polyline.png)
![Canvas Shape DSL Polygon](/images/glimmer-canvas-shape-dsl-polygon.png)
![Canvas Shape DSL Text](/images/glimmer-canvas-shape-dsl-text.png)

`canvas` has the `:double_buffered` SWT style by default on platforms that need it (Windows & Linux) to ensure flicker-free rendering. If you need to disable it for whatever reason, just pass the `:none` SWT style instead (e.g. `canvas(:none)`)

Shape keywords and their args (including defaults) are listed below (they basically match method names and arguments on [org.eclipse.swt.graphics.GC](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html) minus the `draw` or `fill` prefix in downcase):
- `arc(x, y, width, height, startAngle, arcAngle, fill: false)` arc is part of a circle within an oval area, denoted by start angle (degrees) and end angle (degrees)
- `focus(x, y, width, height)` this is just like rectangle but its foreground color is always that of the OS widget focus color (useful when capturing user interaction via a shape)
- `image(image, x = 0, y = 0)` sets [image](#image), which could be an [org.eclipse.swt.graphics.Image](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/Image.html) object or just a file path string
- `image(image, source_x, source_y, source_width, source_height, destination_x, destination_y, destination_width, destination_height)` sets part of an [image](#image) and scales it to fit destination dimensions on parent canvas/widget
- `line(x1, y1, x2, y2)` line
- `oval(x, y, width, height, fill: false)` oval if width does not match heigh and circle if width matches height. Can be optionally filled.
- `point(x, y)` point
- `polygon(pointArray, fill: false)` polygon consisting of points, which close automatically to form a shape that can be optionally filled (when points only form a line, it does not show up as filled)
- `polyline(pointArray)` polyline is just like a polygon, but it does not close up to form a shape, remaining open (unless the points close themselves by having the last point or an intermediate point match the first)
- `rectangle(x, y, width, height, fill: false)` standard rectangle, which can be optionally filled
- `rectangle(x, y, width, height, arcWidth = 60, arcHeight = 60, fill: false, round: true)` round rectangle, which can be optionally filled, and takes optional extra round angle arguments
- `rectangle(x, y, width, height, vertical = true, fill: true, gradient: true)` gradient rectangle, which is always filled, and takes an optional extra argument to specify true for vertical gradient (default) and false for horizontal gradient
- `text(string, x, y, is_transparent = true)` text with optional is_transparent to indicate if background is transparent (default is true)
- `text(string, x, y, flags)` text with optional flags (flag format is `swt(comma_separated_flags)` where flags can be `:draw_delimiter` (i.e. new lines), `:draw_tab`, `:draw_mnemonic`, and `:draw_transparent` as explained in [GC API](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html))

Shape keywords that can be filled with color can take a keyword argument `fill: true` (or `filled: true`). Defaults to false when not specified unless background is set with no foreground (or foreground is set with no background), in which case a smart default is applied.
Smart defaults can be applied to automatically infer `gradient: true` (rectangle with both foreground and background) and `round: true` (rectangle with more than 4 args, the extra args are numeric) as well.

Optionally, a shape keyword takes a block that can set any attributes from [org.eclipse.swt.graphics.GC](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html) (methods starting with `set`), which enable setting the `background` for filling and `foreground` for drawing.

Here is a list of supported attributes nestable within a block under shapes:
- `advanced` enables advanced graphics subsystem (boolean value). Typically gets enabled automatically when setting alpha, antialias, patterns, interpolation, clipping. Rendering sometimes differs between advanced and non-advanced mode for basic graphics too, so you could enable manually if you prefer its look even for basic graphics.
- `alpha` sets transparency (integer between `0` and `255`)
- `antialias` enables antialiasing (SWT style value of `:default` (or nil), `:off` (or false), `:on` (or true) whereby `:default` applies OS default, which varies per OS)
- `background` sets fill color for fillable shapes (standard color symbol (e.g. `:red`), `rgb(red_integer, green_integer, blue_integer)` color, or Color/ColorProxy object directly)
- `background_pattern` sets fill gradient/image pattern for fillable shape background (takes the same arguments as the SWT [Pattern](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/Pattern.html) class [e.g. `background_pattern 2.3, 4.2, 5.4, 7.2, :red, :blue`] / note: this feature isn't extensively tested yet)
- `clipping` clips area of painting (numeric values for `(x, y, width, height)`)
- `fill_rule` sets filling rule (SWT style value of `:fill_even_odd` or `:fill_winding`)
- `font` sets font (Hash of `:name`, `:height`, and `:style` just like standard widget font property, or Font/FontProxy object directly)
- `foreground` sets draw color for drawable shapes (standard color symbol (e.g. `:red`), `rgb(red_integer, green_integer, blue_integer)` color, or Color/ColorProxy object directly)
- `foreground_pattern` sets foreground gradient/image pattern for drawable shape lines (takes the same arguments as the SWT [Pattern](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/Pattern.html) class [e.g. `foreground_pattern 2.3, 4.2, 5.4, 7.2, :red, :blue`] / note: this feature isn't extensively tested yet)
- `interpolation` sets the interpolation value (SWT style value of `:default`, `:none`, `:low`, `:high`)
- `line_cap` sets line cap (SWT style value of `:flat`, `:round`, or `:square`, with aliases `:cap_flat`, `:cap_round`, and `:cap_square`)
- `line_dash` line dash float values (automatically sets `line_style` to SWT style value of `:line_custom`)
- `line_join` line join style (SWT style value of `:miter`, `:round`, and `:bevel`, with aliases `:join_miter`, `:join_round`, or `:join_bevel`)
- `line_style` line join style (SWT style value of `:solid`, `:dash`, `:dot`, `:dashdot`, `:dashdotdot`, or `:custom` while requiring `line_dash` attribute (or alternatively with `line_` prefix as per official SWT docs like `:line_solid` for `:solid`)
- `line_width` line width in integer (used in draw operations)
- `text_anti_alias` enables text antialiasing (SWT style value of `:default`, `:off`, `:on` whereby `:default` applies OS default, which varies per OS)
- `transform` sets transform object using [Canvas Transform DSL](#canvas-transform-dsl) syntax

If you specify the x and y coordinates as `:default`, `nil`, or leave them out, they get calculated automatically by centering the shape within its parent `canvas`.

If you specify the `width` and `height` parameters as `:max`, they get calculated from the parent's size, filling the parent maximally (and they are auto-calculated on parent resize).

Note that you could shift a shape off its centered position within its parent `canvas` by setting `x` to `[:default, x_delta]` and `y` to `[:default, y_delta]`

Keep in mind that ordering of shapes matters as it is followed in painting. For example, it is recommended you paint filled shapes first and then drawn ones.

Example of `line` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    line(30, 30, 170, 170) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Line](/images/glimmer-canvas-shape-dsl-line.png)

Example of `rectangle` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    rectangle(30, 50, 140, 100) {
      background :yellow
    }
    
    rectangle(30, 50, 140, 100) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Rectangle](/images/glimmer-canvas-shape-dsl-rectangle.png)

Example of `rectangle` with round corners having 60 degree angles by default (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    rectangle(30, 50, 140, 100, round: true) {
      background :yellow
    }
    
    rectangle(30, 50, 140, 100, round: true) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Rectangle Round](/images/glimmer-canvas-shape-dsl-rectangle-round.png)

Example of `rectangle` with round corners having different horizontal and vertical angles (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    rectangle(30, 50, 140, 100, 40, 80) {
      background :yellow
    }
    
    rectangle(30, 50, 140, 100, 40, 80) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Rectangle Round Angles](/images/glimmer-canvas-shape-dsl-rectangle-round-angles.png)

Example of `oval` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    oval(30, 50, 140, 100) {
      background :yellow
    }
    
    oval(30, 50, 140, 100) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Oval](/images/glimmer-canvas-shape-dsl-oval.png)

Example of `arc` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    arc(30, 30, 140, 140, 0, 270) {
      background :yellow
    }
    
    arc(30, 30, 140, 140, 0, 270) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Arc](/images/glimmer-canvas-shape-dsl-arc.png)

Example of `polyline` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    polyline(30, 50, 50, 170, 70, 120, 90, 150, 110, 30, 130, 100, 150, 50, 170, 135) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Polyline](/images/glimmer-canvas-shape-dsl-polyline.png)

Example of `polygon` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    polygon(30, 90, 80, 20, 130, 40, 170, 90, 130, 140, 80, 170, 40, 160) {
      background :yellow
    }
    
    polygon(30, 90, 80, 20, 130, 40, 170, 90, 130, 140, 80, 170, 40, 160) {
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Polygon](/images/glimmer-canvas-shape-dsl-polygon.png)

Example of `text` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    text(" This is \n rendered text ", 30, 50) {
      background :yellow
      foreground :red
      font height: 25, style: :italic
      
      rectangle { # automatically scales to match text extent
        foreground :red
        line_width 3
      }
    }
  }
}.open
```

![Canvas Shape DSL Text](/images/glimmer-canvas-shape-dsl-text.png)

Example of `image` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 512, 542
  
  canvas {
    background :white
    
    image(File.expand_path('icons/scaffold_app.png', __dir__), 0, 5)
  }
}.open
```

![Canvas Shape DSL Image](/images/glimmer-canvas-shape-dsl-image.png)

Example of `image` pre-built with a smaller height (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

@image_object = image(File.expand_path('icons/scaffold_app.png', __dir__), height: 200)

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 230
  
  canvas {
    background :white
    
    image(@image_object, 0, 5)
  }
}.open
```

![Canvas Shape DSL Image](/images/glimmer-canvas-shape-dsl-image-shrunk.png)

Example of setting `background_pattern` attribute to a horizontal gradient (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    oval(30, 30, 140, 140) {
      background_pattern 0, 0, 200, 0, rgb(255, 255, 0), rgb(255, 0, 0)
    }
  }
}.open
```

![Canvas Shape DSL Oval Background Pattern Gradient](/images/glimmer-canvas-shape-dsl-oval-background-pattern-gradient.png)

Example of setting `foreground_pattern` attribute to a vertical gradient (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    oval(30, 30, 140, 140) {
      foreground_pattern 0, 0, 0, 200, :blue, :green
      line_width 10
    }
  }
}.open
```

![Canvas Shape DSL Oval Foreground Pattern Gradient](/images/glimmer-canvas-shape-dsl-oval-foreground-pattern-gradient.png)

Example of setting `line_style` attribute to `:dashdot` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    oval(30, 50, 140, 100) {
      background :yellow
    }
    
    oval(30, 50, 140, 100) {
      foreground :red
      line_width 3
      line_style :dashdot
    }
  }
}.open
```

![Canvas Shape DSL Oval](/images/glimmer-canvas-shape-dsl-oval-line-style-dashdot.png)

Example of setting `line_width` attribute to `10`, `line_join` attribute to `:miter` (default) and `line_cap` attribute to `:flat` (default) (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    polyline(30, 50, 50, 170, 70, 120, 90, 150, 110, 30, 130, 100, 150, 50, 170, 135) {
      foreground :red
      line_width 10
      line_join :miter
      line_cap :flat
    }
  }
}.open
```

![Canvas Shape DSL Polyline Line Join Miter Line Cap Flat](/images/glimmer-canvas-shape-dsl-polyline-line-join-miter-line-cap-flat.png)

Example of setting `line_width` attribute to `10`, `line_join` attribute to `:round` and `line_cap` attribute to `:round` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    polyline(30, 50, 50, 170, 70, 120, 90, 150, 110, 30, 130, 100, 150, 50, 170, 135) {
      foreground :red
      line_width 10
      line_join :round
      line_cap :round
    }
  }
}.open
```

![Canvas Shape DSL Polyline Line Join Round Line Cap Round](/images/glimmer-canvas-shape-dsl-polyline-line-join-round-line-cap-round.png)

Example of setting `line_width` attribute to `10`, `line_join` attribute to `:bevel` and `line_cap` attribute to `:square` (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    polyline(30, 50, 50, 170, 70, 120, 90, 150, 110, 30, 130, 100, 150, 50, 170, 135) {
      foreground :red
      line_width 10
      line_join :bevel
      line_cap :square
    }
  }
}.open
```

![Canvas Shape DSL Polyline Line Join Miter Line Cap Flat](/images/glimmer-canvas-shape-dsl-polyline-line-join-bevel-line-cap-square.png)

Shape declaration parameters perfectly match the method parameters in the [SWT org.eclipse.swt.graphics.GC API](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html). This is useful for developers coming to Glimmer DSL for SWT from SWT.

Glimmer DSL for SWT also supports an alternative syntax for specifying shape parameters by nesting underneath the shape instead of passing as args. This syntax in fact offers the extra-benefit of [data-binding](#data-binding) for shape parameter values (meaning you could use `<=` syntax with them instead of setting values directly)

Example of alternative syntax for specifying shape parameters (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

include Glimmer

shell {
  text 'Canvas Shape DSL'
  minimum_size 200, 220
  
  canvas {
    background :white
    
    rectangle {
      x 30
      y 50
      width 140
      height 100
      arc_width 40
      arc_height 80
      background :yellow
    }
    
    rectangle {
      x 30
      y 50
      width 140
      height 100
      arc_width 40
      arc_height 80
      foreground :red
      line_width 3
    }
  }
}.open
```

![Canvas Shape DSL Rectangle Round Angles](/images/glimmer-canvas-shape-dsl-rectangle-round-angles.png)

Example of canvas shape parameter data-binding (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

class HelloCanvasDataBinding
  class PathShape
    attr_accessor :foreground_red, :foreground_green, :foreground_blue, :line_width_value, :line_style_value
    
    def foreground_value
      [foreground_red, foreground_green, foreground_blue]
    end
    
    def line_style_value_options
      [:solid, :dash, :dot, :dashdot, :dashdotdot]
    end
  end
  
  class LinePathShape < PathShape
    attr_accessor :x1_value, :y1_value, :x2_value, :y2_value
  end
  
  class QuadPathShape < PathShape
    attr_accessor :x1_value, :y1_value, :cx_value, :cy_value, :x2_value, :y2_value
    
    def point_array
      [x1_value, y1_value, cx_value, cy_value, x2_value, y2_value]
    end
  end
  
  class CubicPathShape < PathShape
    attr_accessor :x1_value, :y1_value, :cx1_value, :cy1_value, :cx2_value, :cy2_value, :x2_value, :y2_value
    
    def point_array
      [x1_value, y1_value, cx1_value, cy1_value, cx2_value, cy2_value, x2_value, y2_value]
    end
  end
  
  include Glimmer::GUI::Application # alias for Glimmer::UI::CustomShell / Glimmer::UI::CustomWindow
  
  CANVAS_WIDTH  = 300
  CANVAS_HEIGHT = 300
  
  before_body do
    @line = LinePathShape.new
    @line.x1_value = 5
    @line.y1_value = 5
    @line.x2_value = CANVAS_WIDTH - 5
    @line.y2_value = CANVAS_HEIGHT - 5
    @line.foreground_red = 28
    @line.foreground_green = 128
    @line.foreground_blue = 228
    @line.line_width_value = 3
    @line.line_style_value = :dash
    
    @quad = QuadPathShape.new
    @quad.x1_value = 5
    @quad.y1_value = CANVAS_HEIGHT - 5
    @quad.cx_value = (CANVAS_WIDTH - 10)/2.0
    @quad.cy_value = 5
    @quad.x2_value = CANVAS_WIDTH - 5
    @quad.y2_value = CANVAS_HEIGHT - 5
    @quad.foreground_red = 28
    @quad.foreground_green = 128
    @quad.foreground_blue = 228
    @quad.line_width_value = 3
    @quad.line_style_value = :dot
    
    @cubic = CubicPathShape.new
    @cubic.x1_value = 5
    @cubic.y1_value = (CANVAS_WIDTH - 10)/2.0
    @cubic.cx1_value = (CANVAS_WIDTH - 10)*0.25
    @cubic.cy1_value = (CANVAS_WIDTH - 10)*0.25
    @cubic.cx2_value = (CANVAS_WIDTH - 10)*0.75
    @cubic.cy2_value = (CANVAS_WIDTH - 10)*0.75
    @cubic.x2_value = CANVAS_WIDTH - 5
    @cubic.y2_value = (CANVAS_WIDTH - 10)/2.0
    @cubic.foreground_red = 28
    @cubic.foreground_green = 128
    @cubic.foreground_blue = 228
    @cubic.line_width_value = 3
    @cubic.line_style_value = :dashdot
  end
  
  body {
    shell(:no_resize) {
      text 'Hello, Canvas Data-Binding!'
      
      tab_folder {
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Line'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@line, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@line, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@line, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@line, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@line, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@line, :line_style_value]
          }
          
          @line_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            line {
              x1         <= [@line, :x1_value]
              y1         <= [@line, :y1_value]
              x2         <= [@line, :x2_value]
              y2         <= [@line, :y2_value]
              foreground <= [@line, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width <= [@line, :line_width_value]
              line_style <= [@line, :line_style_value]
            }
            
            @line_oval1 = oval {
              x          <= [@line, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@line, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @line_oval2 = oval {
              x          <= [@line, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@line, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @line_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @line_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @line_oval1
                  @line.x1_value += delta_x
                  @line.y1_value += delta_y
                when @line_oval2
                  @line.x2_value += delta_x
                  @line.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @line_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
        
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Quad'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :cx_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :cy_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@quad, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@quad, :line_style_value]
          }
          
          @quad_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            path {
              foreground  <= [@quad, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width  <= [@quad, :line_width_value]
              line_style  <= [@quad, :line_style_value]
              
              quad {
                point_array <= [@quad, :point_array, computed_by: [:x1_value, :y1_value, :cx_value, :cy_value, :x2_value, :y2_value]]
              }
            }
            
            @quad_oval1 = oval {
              x          <= [@quad, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @quad_oval2 = oval {
              x          <= [@quad, :cx_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :cy_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @quad_oval3 = oval {
              x          <= [@quad, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @quad_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @quad_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @quad_oval1
                  @quad.x1_value += delta_x
                  @quad.y1_value += delta_y
                when @quad_oval2
                  @quad.cx_value += delta_x
                  @quad.cy_value += delta_y
                when @quad_oval3
                  @quad.x2_value += delta_x
                  @quad.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @quad_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
        
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Cubic'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 1 x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 1 y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :cx1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :cy1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 2 x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 2 y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :cx2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :cy2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@cubic, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@cubic, :line_style_value]
          }
          
          @cubic_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            path {
              foreground  <= [@cubic, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width  <= [@cubic, :line_width_value]
              line_style  <= [@cubic, :line_style_value]
              
              cubic {
                point_array <= [@cubic, :point_array, computed_by: [:x1_value, :y1_value, :cx1_value, :cy1_value, :cx2_value, :cy2_value, :x2_value, :y2_value]]
              }
            }
            
            @cubic_oval1 = oval {
              x          <= [@cubic, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @cubic_oval2 = oval {
              x          <= [@cubic, :cx1_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :cy1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @cubic_oval3 = oval {
              x          <= [@cubic, :cx2_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :cy2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @cubic_oval4 = oval {
              x          <= [@cubic, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @cubic_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @cubic_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @cubic_oval1
                  @cubic.x1_value += delta_x
                  @cubic.y1_value += delta_y
                when @cubic_oval2
                  @cubic.cx1_value += delta_x
                  @cubic.cy1_value += delta_y
                when @cubic_oval3
                  @cubic.cx2_value += delta_x
                  @cubic.cy2_value += delta_y
                when @cubic_oval4
                  @cubic.x2_value += delta_x
                  @cubic.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @cubic_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
      }
    }
  }
end

HelloCanvasDataBinding.launch
```

![Glimmer Example Canvas Data-Binding](/images/glimmer-hello-canvas-data-binding.gif)

If you ever have special needs for optimization, you could always default to direct SWT painting via [org.eclipse.swt.graphics.GC](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html) instead. Learn more at the [SWT Graphics Guide](https://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html) and [SWT Image Guide](https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html#Saving%20Images).

Example of manual drawing without relying on the declarative Glimmer Shape DSL (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

image_object = image(File.expand_path('./icons/scaffold_app.png'), width: 100)

shell {
  text 'Canvas Manual Example'
  minimum_size 320, 400

  canvas {
    background :dark_yellow
    
    on_paint_control do |paint_event|
      gc = paint_event.gc
      
      gc.background = color(:dark_red).swt_color
      gc.fill_rectangle(0, 0, 220, 400)
      
      gc.background = color(:yellow).swt_color
      gc.fill_round_rectangle(50, 20, 300, 150, 30, 50)
      
      gc.background = color(:dark_red).swt_color
      gc.foreground = color(:yellow).swt_color
      gc.fill_gradient_rectangle(150, 200, 100, 70, true)
      
      gc.font = font(height: 25, style: :bold).swt_font
      gc.foreground = color(:black).swt_color
      gc.draw_text('Glimmer', 208, 83, true)
      
      gc.foreground = rgb(0, 0, 0).swt_color
      gc.line_width = 3
      gc.draw_rectangle(200, 80, 108, 36)
      
      gc.draw_image(image_object.swt_image, 70, 50)
    end
  }
}.open
```

![Glimmer Example Canvas](/images/glimmer-example-canvas.png)

#### Shapes inside a Shape

Shapes can be nested within each other. If you nest a shape within another, its coordinates are assumed to be relative to its parent.

As such, if you move the parent, it moves all its children with it.

If you specify the `x` and `y` coordinates as `:default`, `nil`, or leave them out, they get calculated automatically by centering the shape within its parent shape relatively (and auto-recalculated on parent resize).

If you specify the `width` and `height` parameters as `:default`, `nil`, or leave them out, they get calculated automatically from the shape's nested children shapes if any (e.g calculating the dimensions of a text from its extent according to its font size) or from the parent's size otherwise.

If you specify the `width` and `height` parameters as `:max`, they get calculated from the parent's size, filling the parent maximally (and auto-recalculated on parent resize).

Note that you could shift a shape off its centered position within its parent shape by setting `x` to `[:default, x_delta]` and `y` to `[:default, y_delta]`

Check [Hello, Canvas!](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas) for an example that nests lines, points, a polyline, and an image within a drawn rectangle parent:

```ruby
        rectangle(205, 50, 88, 96) {
          foreground :yellow
          3.times { |n|
            line(45, 70 + n*10, 65 + n*10, 30 + n*10) {
              foreground :yellow
            }
          }
          10.times {|n|
            point(15 + n*5, 50 + n*5) {
              foreground :yellow
            }
          }
          polyline(45, 60, 55, 20, 65, 60, 85, 80, 45, 60)
          image(@image_object, 0, 5)
        }
```

#### Shapes inside a Widget

Keep in mind that the Shape DSL can be used inside any widget, not just `canvas`. Unlike shapes on a `canvas`, which are standalone graphics, when included in a widget, which already has its own look and feel, shapes are used as a decorative add-on that complements its look by getting painted on top of it. For example, shapes were used to decorate `composite` blocks in the [Tetris](/docs/reference/GLIMMER_SAMPLES.md#tetris) sample to have a more bevel look. In summary, Shapes can be used in a hybrid approach (shapes inside a widget), not just standalone in a `canvas`.

#### Shapes inside an Image

You can build an image using the Canvas Shape DSL (including setting the icon of the application).

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```
include Glimmer

shell {
  text 'Image Shape DSL Example'
  label {
    bevel_constant = 20
    icon_block_size = 64
    icon_bevel_size = icon_block_size.to_f / 25.to_f
    icon_bevel_pixel_size = 0.16*icon_block_size.to_f
    icon_size = 8
    icon_pixel_size = icon_block_size * icon_size
    image(icon_pixel_size, icon_pixel_size) {
      icon_size.times { |row|
        icon_size.times { |column|
          colored = row >= 1 && column.between?(1, 6)
          color = colored ? color([:white, :red, :blue, :green, :yellow, :magenta, :cyan, :dark_blue].sample) : color(:white)
          x = column * icon_block_size
          y = row * icon_block_size
          rectangle(x, y, icon_block_size, icon_block_size) {
            background color
          }
          polygon(x, y, x + icon_block_size, y, x + icon_block_size - icon_bevel_pixel_size, y + icon_bevel_pixel_size, x + icon_bevel_pixel_size, y + icon_bevel_pixel_size) {
            background rgb(color.red + 4*bevel_constant, color.green + 4*bevel_constant, color.blue + 4*bevel_constant)
          }
          polygon(x + icon_block_size, y, x + icon_block_size - icon_bevel_pixel_size, y + icon_bevel_pixel_size, x + icon_block_size - icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_block_size, y + icon_block_size) {
            background rgb(color.red - bevel_constant, color.green - bevel_constant, color.blue - bevel_constant)
          }
          polygon(x + icon_block_size, y + icon_block_size, x, y + icon_block_size, x + icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_block_size - icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size) {
            background rgb(color.red - 2*bevel_constant, color.green - 2*bevel_constant, color.blue - 2*bevel_constant)
          }
          polygon(x, y, x, y + icon_block_size, x + icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_bevel_pixel_size, y + icon_bevel_pixel_size) {
            background rgb(color.red - bevel_constant, color.green - bevel_constant, color.blue - bevel_constant)
          }
        }
      }
    }
  }
}.open
```

![Image Shape DSL](/images/glimmer-example-image-shape-dsl.png)

Example setting the icon of the application (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```
include Glimmer

shell {
  text 'Image Shape DSL Example'
  label {
    text 'Image Shape DSL Example'
    font height: 30
  }
  bevel_constant = 20
  icon_block_size = 64
  icon_bevel_size = icon_block_size.to_f / 25.to_f
  icon_bevel_pixel_size = 0.16*icon_block_size.to_f
  icon_size = 8
  icon_pixel_size = icon_block_size * icon_size
  image(icon_pixel_size, icon_pixel_size) {
    icon_size.times { |row|
      icon_size.times { |column|
        colored = row >= 1 && column.between?(1, 6)
        color = colored ? color([:white, :red, :blue, :green, :yellow, :magenta, :cyan, :dark_blue].sample) : color(:white)
        x = column * icon_block_size
        y = row * icon_block_size
        rectangle(x, y, icon_block_size, icon_block_size) {
          background color
        }
        polygon(x, y, x + icon_block_size, y, x + icon_block_size - icon_bevel_pixel_size, y + icon_bevel_pixel_size, x + icon_bevel_pixel_size, y + icon_bevel_pixel_size) {
          background rgb(color.red + 4*bevel_constant, color.green + 4*bevel_constant, color.blue + 4*bevel_constant)
        }
        polygon(x + icon_block_size, y, x + icon_block_size - icon_bevel_pixel_size, y + icon_bevel_pixel_size, x + icon_block_size - icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_block_size, y + icon_block_size) {
          background rgb(color.red - bevel_constant, color.green - bevel_constant, color.blue - bevel_constant)
        }
        polygon(x + icon_block_size, y + icon_block_size, x, y + icon_block_size, x + icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_block_size - icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size) {
          background rgb(color.red - 2*bevel_constant, color.green - 2*bevel_constant, color.blue - 2*bevel_constant)
        }
        polygon(x, y, x, y + icon_block_size, x + icon_bevel_pixel_size, y + icon_block_size - icon_bevel_pixel_size, x + icon_bevel_pixel_size, y + icon_bevel_pixel_size) {
          background rgb(color.red - bevel_constant, color.green - bevel_constant, color.blue - bevel_constant)
        }
      }
    }
  }
}.open
```

![Image Shape DSL](/images/glimmer-example-image-shape-dsl-app-switcher-icon.png)

#### Custom Shapes

Glimmer enables defining custom shape keywords, which represent shapes made up of other nested shapes.

Custom shapes expand a software engineer's Glimmer GUI DSL vocabulary in their app development to be able to represent
higher visual concepts like vehicles, scenes, and characters with a single keyword (e.g. `car`, `beach`, `player`),
which embody and abstract all the details relating to the visual concept. This enables orders of magnitudes in increased
productivity and readability/maintainability as a result.

Just like [custom widgets](#custom-widgets), custom shapes can be defined in one of two ways:
- method-based custom shapes: Use the `shape` keyword as a parent to represent a shape composite (similar to widget composite) and include other shapes like rectangles, polygons, and lines within.
- class-based custom shapes: Include the `Glimmer::UI::CustomShape` supermodule and define the `options`, `body {}` block, and `before_body/after_body` hooks (similar to how it is down with [custom widgets](#custom-widgets))

Check out [Hello, Shape!](/docs/reference/GLIMMER_SAMPLES.md#hello-shape) and [Hello, Custom Shape!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shape) for examples of both approaches.

#### Canvas Shape API

These Canvas Shape API methods help with manipulating shapes upon user interaction, such as mouse clicking a specific shape.

They are implemented with the help of the highly robust Java built-in shape geometry algorithms.

- `WidgetProxy#shape_at_location(x, y)` : returns shape object at x, y location from a widget proxy like canvas
- `Shape#contain?(x, y)` : indicates if shape contains x, y point
- `Shape#include?(x, y)` : indicates if shape includes x, y point on the edge if drawn or inside if filled (include uses contain for filled shapes)
- `Shape#move_by(x_delta, y_delta)` : moves shape object at x, y location
- `Shape#rotate(angle)` : rotates around center by an angle (not cumulative, reseting angle on every call)
- `Shape#rotatation_angle` : current rotation angle (according to use of rotate method)
- `Shape#dispose` : disposes of shape, removing it form its parent canvas, widget, or shape
- `Shape#content {}` : reopens a shape to add more content inside it using the Glimmer GUI DSL (e.g. Canvas Shape DSL) just like `WidgetProxy#content {}`.
- `Shape#size` : calculated size for shape bounding box (e.g. a polygon with an irregular shape will have its bounding box width and height calculated)
- `Shape#bounds` : calculated bounds (x, y, width, height) for shape bounding box (e.g. a polygon with an irregular shape will have its bounding box top-left x, y, width and height calculated)
- `Shape#width` : static (including `:default`) or derived width for shape (including irregular geometric shapes like Polygon)
- `Shape#height` : static (including `:default`) or derived height for shape (including irregular geometric shapes like Polygon)
- `Shape#default_width?` : whether `:default` or `[:default, delta]` is set for static width
- `Shape#default_height?` : whether `:default` or `[:default, delta]` is set for static height
- `Shape#max_width?` : whether `:max` or `[:max, delta]` is set for static width
- `Shape#max_height?` : whether `:max` or `[:max, delta]` is set for static height
- `Shape#calculated_width` : calculated width for shape when set to :default to indicate it is sized by its children (e.g. in the case of containing text with a specific font size not knowing its width/height dimensions in advance)
- `Shape#calculated_height` : calculated height for shape when set to :default to indicate it is sized by its children (e.g. in the case of containing text with a specific font size not knowing its width/height dimensions in advance)
- `Shape#x` : top-left corner x position, static or `:default` (could be relative if shape is nested within another shape)
- `Shape#y` : top-left corner y position, static or `:default` (could be relative if shape is nested within another shape)
- `Shape#absolute_x` : absolute top-left corner x position
- `Shape#absolute_y` : absolute top-left corner y position
- `Shape#default_x?` : whether x is specified via `:default` style to indicate centering within parent (or `[:default, offset]`)
- `Shape#default_y?` : calculated top-left corner y position
- `Shape#calculated_x` : calculated top-left corner x position when default/delta is set (i.e. centered within parent)
- `Shape#calculated_y` : calculated top-left corner y position when default/delta is set (i.e. centered within parent)
- `Shape#center_x` : center x
- `Shape#center_y` : center y
- `Shape#x_end` : right-most included x coordinate
- `Shape#y_end` : bottom-most included y coordinate

Check [Hello, Canvas!](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas) for an example.


#### Pixel Graphics

If you need to paint pixel graphics, use the optimized `pixel` keyword alternative to `point`, which takes foreground as a hash argument and bypasses the [Glimmer DSL Engine chain of responsibility](https://github.com/AndyObtiva/glimmer#dsl-engine), thus rendering faster when having very large pixel counts.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  
  canvas {
    250.times {|y|
      250.times {|x|
        pixel(x, y, foreground: [y%255, x%255, (x+y)%255])
      }
    }
  }
}.open
```

Result:

![glimmer example pixel graphics](/images/glimmer-example-pixel-graphics.png)

If you are strictly dealing with pixels (no other shapes), you could even avoid the `pixel` keyword altogether and just provide direct foreground colors by passing a block that receives x, y coordinates:

```ruby
include Glimmer
 
shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
   
  canvas { |x, y|
    [y%255, x%255, (x+y)%255]
  }
}.open
```

Remember that you could always default to direct SWT painting via [org.eclipse.swt.graphics.GC](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/GC.html) too for even faster performance when needed in rare circumstances. Learn more at the [SWT Graphics Guide](https://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html) and [SWT Image Guide](https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html#Saving%20Images).

Example of manually doing the same things as in the previous example without relying on the declarative Glimmer Shape DSL (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  
  canvas {
    on_paint_control do |paint_event|
      gc = paint_event.gc
      250.times do |y|
        250.times do |x|
          gc.foreground = Color.new(y%255, x%255, (x+y)%255)
          gc.draw_point(x, y)
        end
      end
    end
  }
}.open
```

(the code could be optimized further if you are repeating colors by simply reusing `Color` objects instead of re-constructing them)

The only downside with the approach above is that it repaints all pixels on repaints to the window (e.g. during window resize). To get around that, we can rely on a technique called **Image Double-Buffering**. That is to buffer the graphics on an Image first and then set it on the Canvas so that resizes of the shell dont cause a repaint of all the pixels. Additionally, this gives us the added benefit of being able to use the image as a Shell icon via its `image` property.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

@the_image = image(250, 250)
250.times {|y|
  250.times {|x|
    @the_image.gc.foreground = Color.new(y%255, x%255, (x+y)%255)
    @the_image.gc.draw_point(x, y)
  }
}

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  image @the_image
  
  canvas {
    image @the_image
  }
}.open
```

If you need a transparent background for the image, replace the image construction line with the following:

```ruby
@the_image = image(250, 250)
@the_image.image_data.alpha = 0
@the_image = image(@the_image.image_data)
```

That way, wherever you don't draw a point, you get transparency (seeing what is behind the image).

Alternatively, with a very minor performance penalty, Glimmer enables you to build the image pixel by pixel with a friendly Ruby syntax by passing a block that takes the x and y coordinates and returns a foreground color rgb array or Color/ColorProxy object.

```ruby
include Glimmer

@the_image = image(250, 250) {|x, y|
  [y%255, x%255, (x+y)%255]
}

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  image @the_image
  
  canvas {
    image @the_image
  }
}.open
```

If you don't need a `shell` image (icon), you can nest the image directly under the canvas by passing in the `top_level` keyword to treat `image` as a top-level keyword (pretending it is built outside the shell).

```ruby
include Glimmer

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  
  canvas {
    image image(250, 250, top_level: true) {|x, y|
      [y%255, x%255, (x+y)%255]
    }
  }
}.open
```

If you don't need a `shell` image (icon) and `pixel` performance is enough, you can automatically apply **Image Double-Buffering** with the `:image_double_buffered` SWT style (custom Glimmer style not available in SWT itself)

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  
  canvas(:image_double_buffered) {
    250.times {|y|
      250.times {|x|
        pixel(x, y, foreground: [y%255, x%255, (x+y)%255])
      }
    }
  }
}.open
```

Of course, you could also take advantage of the pixel-less terser syntax:

```ruby
include Glimmer

shell {
  minimum_size 250, 265
  text 'Pixel Graphics Example'
  
  canvas(:image_double_buffered) { |x, y|
    [y%255, x%255, (x+y)%255]
  }
}.open
```

As they say, there are many ways to skin a cat! This is in line with the Ruby way of providing more ways than one. Pick and choose the right tool for the job just like true software engineers.

### Canvas Path DSL

Unlike common imperative GUI graphing toolkits, Glimmer enables declarative rendering of paths with the Canvas Path DSL via the new `path { }` keyword and by nesting one of the following path segment keywords underneath:
- `point(x1, y1)`: renders a Point (Dot) as part of a path.
- `line(x1, y1, x2=nil, y2=nil)`: renders a Line as part of a path. If you drop x2, y2, it joins to the previous point automatically. You may repeat for a series of lines forming a curve.
- `quad(x1, y1, x2, y2, x3=nil, y3=nil)`: renders a Quadratic Bezier Curve. If you drop x3 and y3, it joins to the previous point automatically.
- `cubic(x1, y1, x2, y2, x3, y3, x4=nil, y4=nil)`: renders a Cubic Bezier Curve. If you drop x4 and y4, it joins to the previous point automatically.

Example:

```ruby
include Glimmer

shell {
  text 'Canvas Path Example'
  minimum_size 300, 300
  
  canvas {
    path {
      foreground :black
      250.times {|n|
        cubic(n + n%30, n+ n%50, 40, 40, 70, 70, n + 20 + n%30, n%30*-1 * n%50)
      }
    }
  }
  
}.open
```

![Canvas Path Example](/images/glimmer-example-canvas-path.png)

Learn more at the [Hello, Canvas Path!](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas-path) and [Stock Ticker](/docs/reference/GLIMMER_SAMPLES.md#stock-ticker) samples.

![Stock Ticker](/images/glimmer-stock-ticker.gif)

#### Canvas Path API

Every path segment object (mixing in [`Glimmer::SWT::Custom::PathSegment`](/lib/glimmer/swt/custom/shape/path_segment.rb) like `path`, `point`, `line`, `quad`, and `cubic`) has the following API methods:
- `#path`: indicates which path the segment is part of.
- `#path_root`: indicates the root path the segment is part of.
- `#dispose`: disposes a path segment from its path
- `#content {}` : reopens a path to add more segments inside it using the Glimmer GUI DSL (e.g. Canvas Path DSL) just like `WidgetProxy#content {}`.
- `#first_path_segment?`: indicates if the path segment is the first in the path

### Canvas Transform DSL

The transform DSL builds [org.eclipse.swt.graphics.Transform](https://help.eclipse.org/2020-12/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/graphics/Transform.html) objects with a nice declarative syntax.

`transform` keyword builds a `Transform` object. It optionally takes the transformation matrix elements: (m11, m12, m21, m22, dx, dy)

The first 2 values represent the 1st row, the second 2 values represent the 2nd row, and the last 2 values represent translation on the x and y axes

Additionally, Transform operation keywords may be nested within the `transform` keyword to set its properties:
- `identity` resets transform to identity (no transformation)
- `invert` (alias: `inversion`) inverts a transform
- `multiply(&transform_properties_block)` (alias: `multiplication`) multiplies by another transform (takes a block representing properties of another transform, no need for using the word transform again)
- `rotate(angle)` (alias: `rotation`) rotates by angle degrees
- `scale(x, y)` scales a shape (stretch)
- `shear(x, y)` shear effect
- `translate(x, y)` (alias: `translation`) translate x and y coordinates (move)
- `elements(m11, m12, m21, m22, dx, dy)` resets all values of the transform matrix (first 2 values represent the 1st row, second 2 values represent the 2nd row, the last 2 values represent translation on x and y axes)
 
Also, setting `transform` to `nil` after a previous `transform` has been set is like calling `identity`. It resets the transform.
 
Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  text 'Canvas Transform Example'
  minimum_size 330, 352
  
  canvas { |canvas_proxy|
    background :white

    text('glimmer', 0, 0) {
      foreground :red
      transform {
        translate 220, 100
        scale 2.5, 2.5
        rotate 90
      }
    }
    text('glimmer', 0, 0) {
      foreground :dark_green
      transform {
        translate 0, 0
        shear 2, 3
        scale 2, 2
      }
    }
    text('glimmer', 0, 0) {
      foreground :blue
      transform {
        translate 0, 220
        scale 3, 3
      }
    }
  }
}.open
```

![Canvas Transform Example](/images/glimmer-example-canvas-transform.png)

#### Top-Level Transform Fluent Interface

When using a transform at the top-level (outside of shell), you get a fluent interface to faciliate manual construction and use.

Example:

```ruby
include Glimmer # make sure it is included in your class/module before using the fluent interface

transform(1, 1, 4, 2, 2, 4).
  multiply(1, 2, 3, 4,3,4).
  scale(1, 2, 3, 4, 5, 6).
  rotate(45).
  scale(2, 4).
  invert.
  shear(2, 4).
  translate(3, 7)
```

Learn more at the [Hello, Canvas Transform! Sample](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas-transform).

### Canvas Animation DSL

**(ALPHA FEATURE)**

(note: this is a very new feature of Glimmer. It may change a bit while getting battle tested. As always, you could default to basic SWT usage if needed.)

Glimmer provides built-in support for animations via a declarative Animation DSL, another sub-DSL of the Glimmer GUI DSL.

Animations take advantage of multi-threading, with Glimmer DSL for SWT automatically running each animation in its own independent thread of execution while updating the GUI asynchronously.

Multiple simultaneous animations are supported per `canvas` (or widget) parent.

`canvas` has the `:double_buffered` SWT style by default on platforms other than the Mac to ensure flicker-free rendering (Mac does not need it). If you need to disable it for whatever reason, just pass the `:none` SWT style instead (e.g. `canvas(:none)`)

This example says it all (it moves a tiny red square across a blue background) (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
include Glimmer

shell {
  text 'Canvas Animation Example'
  minimum_size 400, 400

  canvas {
    animation {
      every 0.1
      
      frame { |index|
        background rgb(index%100, index%100 + 100, index%55 + 200)
        rectangle(index, index, 20, 20) {
          background :red
        }
      }
    }
  }
}.open
```

Screenshot:

![Canvas Animation Example](/images/glimmer-example-canvas-animation.gif)

Keywords:
- `animation` declares an animation under a canvas, which renders frames using a frame block indefinitely or finitely depending on (cycle_count/frame_count) properties
- `every` specifies delay in seconds between every two frame renders (an alternative to `fps`, cannot use together)
- `fps` (alias: `frame_rate`) specifies frame rate as frames per second (an alternative to `every`, cannot use together)
- `frame {|index, cycle_var| }` a block that can contain Shape DSL syntax that is rendered dynamically with variables calculated on the fly
- `cycle` an optional property that takes an array to cycle into a second variable for the `frame` block
- `cycle_count` an optional cycle count limit after which the animation stops (finishes)
- `frame_count` an optional frame count limit after which the animation stops (finishes)
- `duration_limit` an optional duration limit in seconds after which the animation stops (finishes)
- `started`/`started?` a boolean indicating if the animation is started right away or stopped waiting for manual startup via `#start` method
- `finished`/`finished?` a boolean indicating if the animation finished (for finite animations only)

API of Animation Object (returned from `animation` keyword):
- `#start` starts an animation that is indefinite or has never been started before (i.e. having `started: false` option). Otherwise, resumes a stopped animation that has not been completed.
- `#stop` stops animation. Maintains progress when `frame_count`, `cycle_count`, or `duration_limit` are set and haven't finished. That way, if `#start` is called, animation resumes from where it stopped exactly to completion.
- `#restart` restarts animation, restarting progress of `frame_count`, `cycle_count`, and `duration_limit` if set.
- `#started?` returns whether animation started
- `#stopped?` returns whether animation stopped
- `#indefinite?` (alias `infinite?`) returns true if animation does not have `frame_count`, `cycle_count`, or `duration_limit`
- `#finite?` returns true if animation has `frame_count`, `cycle_count` (with `cycle`), or `duration_limit`
- `#frame_count_limited?` returns true if `frame_count` is specified
- `#cycle_enabled?` returns true if `cycle` is specified
- `#cycle_limited?` returns true if `cycle_count` is specified
- `#duration_limited?` returns true if `duration_limit` is specified

Learn more at the [Hello, Canvas Animation!](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas-animation) and [Hello, Canvas Animation Data Binding!](/docs/reference/GLIMMER_SAMPLES.md#hello-canvas-animation-data-binding) samples.

If there is anything missing you would like added to the Glimmer Animation DSL that you saw available in the SWT APIs, you may [report an issue](https://github.com/AndyObtiva/glimmer-dsl-swt/issues) or implement yourself and [contribute](#contributing) via a Pull Request.

#### Animation via Data-Binding

Animation could be alternatively implemented without the `animation` keyword through a loop that invokes model methods inside `sync_exec {}` (or `async_exec {}`), which indirectly cause updates to the GUI via data-binding.

The [Glimmer Tetris](/docs/reference/GLIMMER_SAMPLES.md#tetris) sample provides a good example of that.

### Data-Binding

Data-binding is done with either the [Shine](#shine) syntax `<=>` (bidirectional data-binding) & `<=` (unidirectional data-binding) or via the `bind` keyword, following widget property to bind and taking model and bindable attribute as arguments.

#### General Examples

`text <=> [contact, :first_name]`

This example binds the text property of a widget like `label` to the first name of a contact model using Shine data-binding syntax (recommended).

`text bind(contact, :first_name)`

This example binds the text property of a widget like `label` to the first name of a contact model (older style of data-binding, not recommended).

`text <=> [contact, 'address.street']`

This example binds the text property of a widget like `label` to the nested street of
the address of a contact. This is called nested property data binding.

`text <=> [contact, 'address.street', on_read: :upcase, on_write: :downcase]`

This example adds on the one above it by specifying converters on read and write of the model property, like in the case of a `text` widget. The text widget will then displays the street upper case and the model will store it lower case. When specifying converters, read and write operations must be symmetric (to avoid an infinite update loop between the widget and the model since the widget checks first if value changed before updating)

`text <=> [contact, 'address.street', on_read: ->(s) { s[0..10] }]`

This example also specifies a converter on read of the model property, but via a lambda, which truncates the street to 10 characters only. Note that the read and write operations are assymetric. This is fine in the case of formatting data for a read-only widget like `label`

`text bind(contact, 'address.street') { |s| s[0..10] }`

This is a block shortcut version of the syntax above it. It facilitates formatting model data for read-only widgets since it's a very common view concern. It also saves the developer from having to create a separate formatter/presenter for the model when the view can be an active view that handles common simple formatting operations directly (older style of data-binding, not recommended).

`text <= [contact, 'address.street']`

This is read-ohly data-binding. It doesn't update contact.address.street when widget text property is changed.

`text bind(contact, 'address.street', read_only: true)`

This is read-ohly data-binding. It doesn't update contact.address.street when widget text property is changed (older style of data-binding, not recommended).

`text <=> [contact, 'addresses[1].street']`

This example binds the text property of a widget like `label` to the nested indexed address street of a contact. This is called nested indexed property data binding.

`text <=> [contact, :age, computed_by: :date_of_birth]`

This example demonstrates computed value data binding whereby the value of `age` depends on changes to `date_of_birth`.

`text <=> [contact, :name, computed_by: [:first_name, :last_name]]`

This example demonstrates computed value data binding whereby the value of `name` depends on changes to both `first_name` and `last_name`.

`text <=> [contact, 'profiles[0].name', computed_by: ['profiles[0].first_name', 'profiles[0].last_name']]`

This example demonstrates nested indexed computed value data binding whereby the value of `profiles[0].name` depends on changes to both nested `profiles[0].first_name` and `profiles[0].last_name`.

`text <=> [contact, 'address.street', sync_exec: true]`

This example forces GUI updates via [sync_exec](#sync_exec) assuming they are coming from another thread (different from the GUI thread)

`text <=> [contact, 'address.street', async_exec: true]`

This example forces GUI updates via [async_exec](#async_exec) assuming they are coming from another thread (different from the GUI thread)

Example from [samples/hello/hello_combo.rb](samples/hello_combo.rb) sample (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

#### Shine

The new Shine syntax for View/Model Attribute Mapping allows data-binding visually with simple arrow operators in Ruby.

Use `<=> [model, attribute, options]` for bidirectional (two-way) data-binding instead of `bind(model, attribute, options)`.
Use `<= [model, attribute, options]` for unidirectional (one-way) data-binding instead of `bind(model, attribute, read_only: true, more_options)`

One thing special with the `table` widget is that `<=`, which makes data-binding unidirectional, stops the `table` from supporting automatic sorting by default since that involves modifying the model collection ordering (albeit not the content).
To enable automatic sorting in a `table`, but still not permit edit actions to the data itself, you simply use `<=>` for bidirectional data-binding, but without passing the `:editable` style to the `table`.

Examples:

```ruby
text <=> [@contact, :first_name]
```

```ruby
text <=> [@contact, :last_name]
```

```ruby
text <= [@contact, :name, computed_by: [:first_name, :last_name]]
```

Given that Shine is new, if you encounter any issues, you can use `bind` instead.

Check out [sample code](/samples) for more examples of Shine syntax in action, such as [Hello, Computed!](/docs/reference/GLIMMER_SAMPLES.md#hello-computed).

#### Combo

The `combo` widget provides a dropdown of options. By default, it also allows typing in a new option. To disable that behavior, you may use with the `:read_only` SWT style.

When data-binding a `combo` widget, Glimmer can automatically deduce available options from data-bound model by convention: `{attribute_name}_options` method.

![Hello Combo](/images/glimmer-hello-combo.png)

![Hello Combo](/images/glimmer-hello-combo-expanded.png)

```ruby
class Person
  attr_accessor :country, :country_options

  def initialize
    self.country_options=["", "Canada", "US", "Mexico"]
    self.country = "Canada"
  end

  def reset_country
    self.country = "Canada"
  end
end

class HelloCombo
  include Glimmer
  def launch
    person = Person.new
    shell {
      composite {
        combo(:read_only) {
          selection bind(person, :country)
        }
        button {
          text "Reset"
          on_widget_selected do
            person.reset_country
          end
        }
      }
    }.open
  end
end

HelloCombo.new.launch
```

`combo` widget is data-bound to the country of a person. Note that it expects the `person` object to have the `:country` attribute and `:country_options` attribute containing all available countries (aka options). Glimmer reads these attributes by convention.

#### List

Example from [samples/hello/hello_list_single_selection.rb](samples/hello_list_single_selection.rb) sample:

![Hello List Single Selection](/images/glimmer-hello-list-single-selection.png)

```ruby
shell {
  composite {
    list {
      selection bind(person, :country)
    }
    button {
      text "Reset"
      on_widget_selected do
        person.reset_country
      end
    }
  }
}.open
```

`list` widget is also data-bound to the country of a person similarly to the combo widget. Not much difference here (the rest of the code not shown is the same).

Nonetheless, in the next example, a multi-selection list is declared instead allowing data-binding of multiple selection values to the bindable attribute on the model.

Example from [samples/hello/hello_list_multi_selection.rb](samples/hello_list_multi_selection.rb) sample (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

![Hello List Multi Selection](/images/glimmer-hello-list-multi-selection.png)

```ruby
class Person
  attr_accessor :provinces, :provinces_options

  def initialize
    self.provinces_options=[
      "",
      "Quebec",
      "Ontario",
      "Manitoba",
      "Saskatchewan",
      "Alberta",
      "British Columbia",
      "Nova Skotia",
      "Newfoundland"
    ]
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end

  def reset_provinces
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end
end

class HelloListMultiSelection
  include Glimmer
  def launch
    person = Person.new
    shell {
      composite {
        list(:multi) {
          selection bind(person, :provinces)
        }
        button {
          text "Reset"
          on_widget_selected do
            person.reset_provinces
          end
        }
      }
    }.open
  end
end

HelloListMultiSelection.new.launch
```

The Glimmer code is not much different from above except for passing the `:multi` style to the `list` widget. However, the model code behind the scenes is quite different as it is a `provinces` array bindable to the selection of multiple values on a `list` widget. `provinces_options` contains all available province values just as expected by a single selection `list` and `combo`.

Note that in all the data-binding examples above, there was also an observer attached to the `button` widget to trigger an action on the model, which in turn triggers a data-binding update on the `list` or `combo`. Observers will be discussed in more details in the [next section](#observer).

You may learn more about Glimmer's data-binding syntax by reading the code under the [samples](samples) directory.

#### Table

The SWT Tree widget renders a multi-column data table, such as a contact listing or a sales report.

To data-bind a Table, you need the main model and the collection property. The text for each row cell will be inferred from column names as underscored model attributes. For example, for a column named "Full Name", it is assumed by convention that the model has a `full_name` attribute.

Data-binding involves using the `<=` operator (one-way data-binding) or `<=>` operator (two-way data-binding), and an optional `column_attributes` kwarg (alias: `column_properties`) that takes an array that maps table columns to model attributes or a hash that maps column name strings to model attributes.

It assumes you have already defined table columns via the `table_column` `table`-nested widget.

Example (automatically inferring table items' [rows'] model attributes by convention from column names):

```ruby
shell {
  @table = table {
    table_column {
      text "Name"
      width 120
    }
    table_column {
      text "Age"
      width 120
    }
    table_column {
      text "Adult"
      width 120
    }
    
    items <=> [group, :people]
    selection <=> [group, :selected_person]
    
    on_mouse_up do |event|
      @table.edit_table_item(event.table_item, event.column_index)
    end
  }
}
```

The code above includes two data-bindings and a listener:
- Table `items`, which first data-binds to the model collection property (group.people), and then maps each column to a model attribute (name, age, adult) for displaying each table item column.
- Table `selection`, which data-binds the single table item (row) selected by the user to the model attribute denoted by `<=>` (or data-binds multiple table items to a model attribute array value for a table with `:multi` SWT style)
- The `on_mouse_up` event handler invokes `@table.edit_table_item(event.table_item, event.column_index)` to start edit mode on the clicked table item cell, and then saves or cancel depending on whether the user hits ENTER or ESC once done editing (or focus-out after either making a change or not making any changes.)

Example (specifying `column_attributes` explicitly because some diverge from column names):

```ruby
shell {
  @table = table {
    table_column {
      text "Full Name"
      width 120
    }
    table_column {
      text "Age in Years"
      width 120
    }
    table_column {
      text "Adult"
      width 120
    }
    
    items <=> [group, :people, column_attributes: {'Full Name' => :name, 'Age in Years' => :age}]
    selection <=> [group, :selected_person]
    
    on_mouse_up do |event|
      @table.edit_table_item(event.table_item, event.column_index)
    end
  }
}
```

Example (specifying `column_attributes` explicitly because all diverge from column names):

```ruby
shell {
  @table = table {
    table_column {
      text "Full Name"
      width 120
    }
    table_column {
      text "Age in Years"
      width 120
    }
    table_column {
      text "Is Adult"
      width 120
    }
    
    items <=> [group, :people, column_attributes: [:name, :age, :adult]]
    selection <=> [group, :selected_person]
    
    on_mouse_up do |event|
      @table.edit_table_item(event.table_item, event.column_index)
    end
  }
}
```

Additionally, Table `items` data-binding automatically stores each row model in the [SWT `TableItem`](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/TableItem.html) object representing it, by using the `set_data` method. This enables things like searchability.

The table widget in Glimmer is represented by a subclass of `Glimmer::SWT::WidgetProxy` called `Glimmer::SWT::TableProxy`.
`Glimmer::SWT::TableProxy` includes a `search` method that takes a block to look for a table item.

Example:

```ruby
found_array = @table.search { |table_item| table_item.getData == company.owner }
```

This finds a person. The array is a Java array. This enables easy passing of it to SWT `Table#setSelection` method, which expects a Java array of [`TableItem`](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/TableItem.html) objects.

To edit a table, you must invoke `TableProxy#edit_selected_table_item(column_index, before_write: nil, after_write: nil, after_cancel: nil)` or `TableProxy#edit_table_item(table_item, column_index, before_write: nil, after_write: nil, after_cancel: nil)`.
This automatically leverages the SWT TableEditor custom class behind the scenes, displaying a text widget to the user to change the selected or
passed table item text into something else.
It automatically persists the change to `items` data-bound model on ENTER/FOCUS-OUT or cancels on ESC/NO-CHANGE.

Note that `table` is useful with a maximum of about 100 rows only, not more than that, or otherwise it will not offer a user-friendly experience due to requiring users to scroll through a lot of data.
If you need to display a table with more than 100 rows, then you need to employ pagination. That is already supported in the [Refined Table (`refined_table`)](#refined-table) custom widget documented below.

##### Table Item Properties

When data-binding a `table`'s `items`, extra [`TableItem` properties](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/TableItem.html) are data-bound automatically by convention for `background` color, `foreground` color, `font`, and `image` if corresponding properties (attributes) are available on the model.

That means that if `column_attributes` were `[:name, :age, :adult]`, then the following [`TableItem` properties](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/TableItem.html) are also data-bound by convention:
- `background` to `:name_background, :age_background, :adult_background` model attributes
- `foreground` to `:name_foreground, :age_foreground, :adult_foreground` model attributes
- `font` to `:name_font, :age_font, :adult_font` model attributes
- `image` to `:name_image, :age_image, :adult_image` model attributes

Here are the expected values for each [`TableItem` property](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/TableItem.html):
- `background`: Standard color symbol/string (e.g. `:red`), rgb array (e.g. `[24, 21, 239]`), or rgba array (e.g. `[128, 0, 128, 50]`)
- `foreground`: Standard color symbol/string (e.g. `:red`), rgb array (e.g. `[24, 21, 239]`), or rgba array (e.g. `[128, 0, 128, 50]`)
- `font`: font data hash having `:name`, `:height`, and/or `:style` keys (e.g. `{name: 'Courier New', height: 25, style: [:bold, :italic]}`)
- `image`: image URL with or without image options (e.g. `'/usr/image1.png'` or `['/usr/image1.png', width: 20, height: 20]`)

![Hello Table game booked rows](/images/glimmer-hello-table-game-booked-rows.png)

##### Table Selection

Table Selection data-binding is simply done via the `selection` property.

```ruby
selection bind(group, :selected_person)
```

If it's a multi-selection table (`table(:multi)`), then the data-bound model property oughta be a collection.

```ruby
selection bind(group, :selected_people)
```

##### Table Editing

Glimmer provides a custom SWT style for table editing called `:editable` to obviate the need for an `on_mouse_up` listener.

For example, the code above could be simplified as:

```ruby
shell {
  @table = table(:editable) {
    table_column {
      text "Name"
      width 120
    }
    table_column {
      text "Age"
      width 120
    }
    table_column {
      text "Adult"
      width 120
    }
    items <=> [group, :people]
    selection bind(group, :selected_person)
  }
}
```

Additionally, Glimmer supports the idea of custom editors or no editor per column.

Example:

```ruby
shell {
  @table = table(:editable) {
    table_column {
      text "Name"
      width 120
    }
    table_column {
      text "Age"
      width 120
      editor :spinner
    }
    table_column {
      text "Adult"
      width 120
      editor :checkbox
    }
    items <=> [group, :people]
    selection bind(group, :selected_person)
  }
}
```

The example above uses a `spinner` widget editor for the age column since it's an `Integer` and
a `checkbox` widget (`button(:check)`) editor for the adult column since it's a `Boolean`

Here are all the supported types of table editors:
- `text`: expects a `String` property
- `combo`: expects a `String` property accompanied by a matching `property_options` property by convention to provide items to present in the `combo`
- `checkbox`: expects a `Boolean` property
- `radio`: expects a `Boolean` property
- `spinner`: expects an `Integer` property
- `date`: expects a `DateTime` property
- `date_drop_down`: expects a `DateTime` property
- `time`: expects a `DateTime` property

An editor may also take additional arguments (SWT styles such as :long for the date field) that are passed to the editor widget, as well as hash options to
customize the property being used for editing (e.g. property: :raw_name for a :formatted_name field) in case it differs from the property used to display
the data in the table.

Example:

```ruby
shell {
  @table = table(:editable) {
    table_column {
      text "Date of Birth"
      width 120
      editor :date_drop_down, property: :date_time
    }
    table_column {
      text "Industry"
      width 120
      # assume there is a `Person#industry_options` property method on the model to provide items to the `combo`
      editor :combo, :read_only # passes :ready_only SWT style to `combo` widget
    }
    items <=> [group, :people, column_attributes: {'Date of Birth' => :formatted_date}]
    selection bind(group, :selected_person)
  }
}
```

Check out [Hello, Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-table) for an actual example including table editors.

[Are We There Yet?](#are-we-there-yet) is an actual production Glimmer application that takes full advantage of table capabilities, storing model data in a database via ActiveRecord and SQLite DB. As such, it's an excellent demonstration of how to use Glimmer DSL for SWT with a database. [Contact Manager](https://github.com/AndyObtiva/contact_manager) is an external sample application that also utilizes a table with ActiveRecord and SQLite DB. It comes with a [blog post](https://andymaleh.blogspot.com/2022/06/using-activerecord-with-sqlite-db-in.html?m=0) that provides a step by step guide on how to build such an application.

##### Table Sorting

Glimmer automatically adds sorting support to the SWT `Table` widget.

Check out the [Contact Manager](/docs/reference/GLIMMER_SAMPLES.md#contact-manager) sample for an example.
You may click on any column and it will sort by ascending order first and descending if you click again.

Glimmer automatic table sorting supports `String`, `Integer`, and `Float` columns out of the box as well as any column data that is comparable.

In cases where data is nil, depending on the data-type, it is automatically converted to `Float` with `to_f`, `Integer` with `to_i`, or `String` with `to_s`.

Should you have a special data type that could not be compared automatically, Glimmer s the following 3 alternatives for custom sorting:
- `sort_property`: this may be set to an alternative property to the one data-bound to the table column. For example, a table column called 'adult', which returns `true` or `false` may be sorted with `sort_property :dob` instead. This also support multi-property (aka multi-column) sorting (e.g. `sort_property :dob, :name`).
- `sort_by(&block)`: this works just like Ruby `Enumerable` `sort_by`. The block receives the table column data as argument.
- `sort(&comparator)`: this works just like Ruby `Enumerable` `sort`. The comparator block receives two objects from the table column data.

These alternatives could be used inside `table_column` for column-clicked sorting or in the `table` body directly to set the initial default sort.

You may also set `additional_sort_properties` on the parent `table` widget to have secondary sorting applied. For example, if you set `additional_sort_properties :name, :project_name`, then whenever you sort by `:name`, it additionally sorts by `:project_name` afterwards, and vice versa. This only works for columns that either have no custom sort set or have a `sort_property` with one property only (but no sort or sort_by block)

Example:

```ruby
# ...
  table {
    table_column {
      text 'Task'
      width 120
    }
    table_column {
      text 'Project'
      width 120
    }
    table_column {
      text 'Duration (hours)'
      width 120
      sort_property :duration_in_hours
    }
    table_column {
      text 'Priority'
      width 120
      sort_by { |value| ['High', 'Medium', 'Low'].index(value) }
    }
    table_column {
      text 'Start Date'
      width 120
      sort { |d1, d2| d1.to_date <=> d2.to_date }
    }
    additional_sort_properties :project_name, :duration_in_hours, :name
    items <=> [Task, :list, column_attributes: [:name, :project_name, :duration, :priority, :start_date]]
    # ...
  }
# ...
```

Here is an explanation of the example above:
- Task and Project table columns are data-bound to the `:name` and `:project_name` properties and sorted through them automatically
- Task Duration table column is data-bound to the `:duration` property, but sorted via the `:duration_in_hours` property instead
- Task Priority table column has a custom sort_by block
- Task Start Date table column has a custom sort comparator block
- Additional (secondary) sort properties are applied when sorting by Task, Project, or Duration in the order specified

`<= [model, :property, read_only_sort: true]` could be used with items to make sorting not propagate sorting changes to model.

##### Refined Table

**(BETA FEATURE)**

`refined_table` is a custom widget that can handle very large amounts of data by applying pagination and filtering.

Just use like a standard `table`, but data-bind models to the `model_array` property instead of `items`. `refined_table` will take care of the rest.

Options:
- `per_page` (default: `10`): specifies how many rows to display per page
- `page` (default: `1` if table is filled and `0` otherwise): specifies initial page
- `query` (default: `''`): specifies filter query term (empty shows all results)

When click columns (headers) in a `refined_table`, it sorts the entire `model_array`, not just the visible rows.

Also, upon filtering with a query term, moving in pages, and then unfiltering (backspacing)/refiltering, it remembers the last query term's page and results (through caching) and goes back to them, thus ensuring better performance.

Example taken from [Hello, Refined Table!](/docs/reference/GLIMMER_SAMPLES.md#hello-refined-table):

![hello refined table](/images/glimmer-hello-refined-table.png)

```ruby
      #...
      refined_table(:editable, :border, per_page: 20) { # also `page: 1` by default
        table_column {
          width 100
          text 'Date'
          editor :date_drop_down
        }
        table_column {
          width 200
          text 'Ballpark'
          editor :none
        }
        table_column {
          width 150
          text 'Home Team'
          editor :combo, :read_only # read_only is simply an SWT style passed to combo widget
        }
        table_column {
          width 150
          text 'Away Team'
          editor :combo, :read_only # read_only is simply an SWT style passed to combo widget
        }
        
        menu {
          menu_item {
            text 'Book'
            
            on_widget_selected do
              message_box {
                text 'Game Booked!'
                message "The game \"#{@baseball_season.selected_game}\" has been booked!"
              }.open
            end
          }
        }
        
        model_array <=> [@baseball_season, :games, column_attributes: {'Home Team' => :home_team_name, 'Away Team' => :away_team_name}]
        selection <=> [@baseball_season, :selected_game]
      }
      #...
```

#### Tree

The SWT Tree widget visualizes a tree data-structure, such as an employment or composition hierarchy.

To data-bind a Tree, you need the root model, the children querying method, and the text display attribute on each child.

This involves using the `bind` keyword mentioned above in addition to a special `tree_properties` keyword that takes the children and text attribute methods.

Example:

```ruby
shell {
  @tree = tree {
    items <= [company, :owner, tree_properties: {children: :coworkers, text: :name}]
    selection <=> [company, :selected_coworker]
  }
}
```

The code above includes two data-bindings:
- Tree `items`, which first bind to the root node (company.owner), and then dig down via `coworkers` `children` method, using the `name` `text` attribute for displaying each tree item.
- Tree `selection`, which binds the single tree item selected by the user to the attribute denoted by the `bind` keyword

Additionally, Tree `items` data-binding automatically stores each node model unto the SWT TreeItem object via `setData` method. This enables things like searchability.

The tree widget in Glimmer is represented by a subclass of `WidgetProxy` called `TreeProxy`.
TreeProxy includes a `depth_first_search` method that takes a block to look for a tree item.

Example:

```ruby
found_array = @tree.depth_first_search { |tree_item| tree_item.getData == company.owner }
```

This finds the root node. The array is a Java array. This enables easy passing of it to SWT `Tree#setSelection` method, which expects a Java array of `TreeItem` objects.

To edit a tree, you must invoke `TreeProxy#edit_selected_tree_item` or `TreeProxy#edit_tree_item`. This automatically leverages the SWT TreeEditor custom class behind the scenes, displaying
a text widget to the user to change the selected or passed tree item text into something else. It automatically persists the change to `items` data-bound model on ENTER/FOCUS-OUT or cancels on ESC/NO-CHANGE.

Learn more at the [Hello, Tree!](/docs/reference/GLIMMER_SAMPLES.md#hello-tree) and [Gladiator](/docs/reference/GLIMMER_SAMPLES.md#gladiator) samples.

#### DateTime

`date_time` represents the SWT [DateTime](https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/DateTime.html) widget.

Glimmer s the following alias keywords for it for convenience:
- `date`: `date_time(:date)`
- `date_drop_down`: `date_time(:date, :drop_down)`
- `time`: `date_time(:time)`
- `calendar`: `date_time(:calendar)`

You can data-bind any of these properties:
- `date_time <=> [model, :property]`: produces a Ruby DateTime object
- `date <=> [model, :property]`: produces a Ruby Date object
- `time <=> [model, :property]`: produces a Ruby Time object
- `year <=> [model, :property]`: produces an integer
- `month <=> [model, :property]`: produces an integer
- `day <=> [model, :property]`: produces an integer
- `hours <=> [model, :property]`: produces an integer
- `minutes <=> [model, :property]`: produces an integer
- `seconds <=> [model, :property]`: produces an integer

Learn more at the [Hello, Date Time!](/docs/reference/GLIMMER_SAMPLES.md#hello-date-time) sample.

If you need a better widget with the ability to customize the date format pattern, check out the [Nebula CDateTime Glimmer Custom Widget](https://github.com/AndyObtiva/glimmer-cw-cdatetime-nebula)

### Observer

Glimmer comes with the `Observer` mixin module, which is used internally for data-binding, but can also be used externally for custom use of the Observer Pattern. It is hidden when observing widgets, and used explicitly when observing models. In bidirectional data-binding, `Observer` is automatically unregistered from models once a widget is disposed to avoid memory leaks and worrying about managing them yourself.

#### Observing Widgets

Glimmer supports observing widgets with two main types of events:
1. `on_{swt-listener-method-name}`: where {swt-listener-method-name} is replaced with the lowercase underscored event method name on an SWT listener class (e.g. `on_verify_text` for `org.eclipse.swt.events.VerifyListener#verifyText`).
2. `on_swt_{swt-event-constant}`: where {swt-event-constant} is replaced with an [`org.eclipse.swt.SWT`](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html) event constant (e.g. `on_swt_show` for `SWT.Show` to observe when widget becomes visible)

Additionally, there are two more types of events:
- SWT `display` supports global listeners called filters that run on any widget. They are hooked via `on_swt_{swt-event-constant}`
- SWT `display` supports Mac application menu item observers (`on_about` and `on_preferences`), which you can read about under [Miscellaneous](#miscellaneous).

Number 1 is more commonly used in SWT applications, so make it your starting point. Number 2 covers events not found in number 1, so look into it if you don't find an SWT listener you need in number 1.

**Regarding number 1**, to figure out what the available events for an SWT widget are, check out all of its `add***Listener` API methods, and then open the listener class argument to check its "event methods".

For example, if you look at the `Button` SWT API:
https://help.eclipse.org/2019-12/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fswt%2Fbrowser%2FBrowser.html

It has `addSelectionListener`. Additionally, under its `Control` super class, it has `addControlListener`, `addDragDetectListener`, `addFocusListener`, `addGestureListener`, `addHelpListener`, `addKeyListener`, `addMenuDetectListener`, `addMouseListener`, `addMouseMoveListener`, `addMouseTrackListener`, `addMouseWheelListener`, `addPaintListener`, `addTouchListener`, and `addTraverseListener`

Suppose, we select `addSelectionListener`, which is responsible for what happens when a user selects a button (clicks it). Then, open its argument `SelectionListener` SWT API, and you find the event (instance) methods: `widgetDefaultSelected` and `widgetSelected`. Let's select the second one, which is what gets invoked when a button is clicked.

Now, Glimmer simplifies the process of hooking into that listener (observer) by neither requiring you to call the `addSelectionListener` method nor requiring you to implement/extend the `SelectionListener` API.

Instead, simply add a `on_widget_selected` followed by a Ruby block containing the logic to perform. Glimmer figures out the rest.

Let's revisit the Tic Tac Toe example shown near the beginning of the page:

```ruby
shell {
  text "Tic-Tac-Toe"
  minimum_size 150, 178
  composite {
    grid_layout 3, true
    (1..3).each { |row|
      (1..3).each { |column|
        button {
          layout_data :fill, :fill, true, true
          text        bind(@tic_tac_toe_board[row, column], :sign)
          enabled     bind(@tic_tac_toe_board[row, column], :empty)
          on_widget_selected do
            @tic_tac_toe_board.mark(row, column)
          end
        }
      }
    }
  }
}
```

Note that every Tic Tac Toe grid cell has its `text` and `enabled` properties data-bound to the `sign` and `empty` attributes on the `TicTacToe::Board` model respectively.

Next however, each of these Tic Tac Toe grid cells, which are clickable buttons, have an `on_widget_selected` observer, which once triggered, marks the cell on the `TicTacToe::Board` to make a move.

**Regarding number 2**, you can figure out all available events by looking at the [`org.eclipse.swt.SWT`](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html) API:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

`SWT.Show` - hooks a listener for showing a widget (using `on_swt_show` in Glimmer)
`SWT.Hide` - hooks a listener for hiding a widget (using `on_swt_hide` in Glimmer)

```ruby
shell {
  @button1 = button {
    text "Show 2nd Button"
    visible true
    on_swt_show do
      @button2.swt_widget.setVisible(false)
    end
    on_widget_selected do
      @button2.swt_widget.setVisible(true)
    end
  }
  @button2 = button {
    text "Show 1st Button"
    visible false
    on_swt_show do
      @button1.swt_widget.setVisible(false)
    end
    on_widget_selected do
      @button1.swt_widget.setVisible(true)
    end
  }
}.open
```

**Gotcha:** SWT.Resize event needs to be hooked using **`on_swt_Resize`** because [`org.eclipse.swt.SWT`](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html) has 2 constants for resize: `RESIZE` and `Resize`, so it cannot infer the right one automatically from the underscored version `on_swt_resize`

##### Alternative Syntax

Instead of declaring a widget observer using `on_***` syntax inside a widget content block, you may also do so after the widget declaration by invoking directly on the widget object.

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```
@shell = shell {
  label {
    text "Hello, World!"
  }
}
@shell.on_shell_iconified do
  @shell.close
end
@shell.open
```

The shell declared above has been modified so that the minimize button works just like the close button. Once you minimize the shell (iconify it), it closes.

The alternative syntax can be helpful if you prefer to separate Glimmer observer declarations from Glimmer GUI declarations, or would like to add observers dynamically based on some logic later on.

#### Observing Models

Glimmer DSL includes an `observe` keyword used to register an observer by passing in the observable and the property(ies) to observe, and then specifying in a block what happens on notification.

```ruby
class TicTacToe
  include Glimmer

  def initialize
    # ...
    observe(@tic_tac_toe_board, :game_status) do |game_status|
      display_win_message if game_status == Board::WIN
      display_draw_message if game_status == Board::DRAW
    end
  end
  # ...
end
```

Observers can be a good mechanism for displaying dialog messages in Glimmer (using SWT's [`MessageBox`](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/MessageBox.html) class).

Look at [`samples/elaborate/tictactoe/tic_tac_toe.rb`](samples/tictactoe/tic_tac_toe.rb) for more details starting with the code included below.

```ruby
class TicTacToe
  include Glimmer
  include Observer

  def initialize
    # ...
    observe(@tic_tac_toe_board, :game_status) do |game_status|
      display_win_message if game_status == Board::WIN
      display_draw_message if game_status == Board::DRAW
    end
  end

  def display_win_message
    display_game_over_message("Player #{@tic_tac_toe_board.winning_sign} has won!")
  end

  def display_draw_message
    display_game_over_message("Draw!")
  end

  def display_game_over_message(message)
    message_box(@shell) {
      text 'Game Over'
      message message_text
    }.open
    @tic_tac_toe_board.reset
  end
  # ...
end
```

### Software Architecture

Glimmer DSL for SWT supports both MVC (Model View Controller) and MVP (Model View Presenter) architectural patterns.

#### MVC

Model View Controller architectural pattern is embodied by this diagram.

![model view controller](/images/glimmer-software-architecture-model-view-controller.png)

#### MVP

Model View Presenter architectural pattern is embodied by this diagram.

![model view presenter](/images/glimmer-software-architecture-model-view-presenter.png)

#### Software Architecture Examples

Here are 4 different ways of implementing the [Hello, Button!](/docs/reference/GLIMMER_SAMPLES.md#hello-button) sample (other than the included default implementation).

![Hello Button](/images/glimmer-hello-button.png)

##### MVC Example - Explicit Controller

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

```ruby
require 'glimmer-dsl-swt'

class Counter
  attr_accessor :count
  
  def initialize
    self.count = 0
  end
  
  def increment
    self.count += 1
  end
end

class CounterController
  def initialize(counter)
    @counter = counter
  end
  
  def increment_count
    @counter.increment
  end
end

class HelloButton
  include Glimmer::UI::Application
  
  before_body do
    @counter = Counter.new
    @counter_controller = CounterController.new(@counter)
  end
  
  after_body do
    observe(@counter, :count) do |changed_count|
      @button.text = "Click To Increment: #{changed_count}  "
    end
  end
  
  body {
    shell {
      text 'Hello, Button!'
      
      @button = button {
        text "Click To Increment: 0  "
        
        on_widget_selected do
          @counter_controller.increment_count
        end
      }
    }
  }
end

HelloButton.launch
```

##### MVC Example - Implicit Controller

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

```ruby
require 'glimmer-dsl-swt'

class Counter
  attr_accessor :count
  
  def initialize
    self.count = 0
  end
  
  def increment
    self.count += 1
  end
end

class HelloButton
  include Glimmer::UI::Application
  
  before_body do
    @counter = Counter.new
  end
  
  after_body do
    observe(@counter, :count) do |changed_count|
      @button.text = "Click To Increment: #{changed_count}  "
    end
  end
  
  body {
    shell {
      text 'Hello, Button!'
      
      @button = button {
        text "Click To Increment: 0  "
        
        on_widget_selected do
          @counter.increment
        end
      }
    }
  }
end

HelloButton.launch
```

##### MVP Example - Explicit Presenter

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

```ruby
require 'glimmer-dsl-swt'

class Counter
  attr_accessor :count
  
  def initialize
    self.count = 0
  end
  
  def increment
    self.count += 1
  end
end

class CounterPresenter
  include Glimmer::DataBinding::Observer
  
  def initialize
    @counter = Counter.new
    
    Glimmer::DataBinding::Observer.proc do |changed_count|
      notify_observers(:count)
    end.observe(@counter, :count)
  end
  
  def count
    @counter.count
  end
  
  def increment_count
    @counter.increment
  end
end

class HelloButton
  include Glimmer::UI::Application
  
  before_body do
    @counter_presenter = CounterPresenter.new
  end
  
  body {
    shell {
      text 'Hello, Button!'
      
      button {
        text <= [@counter_presenter, :count, on_read: ->(value) { "Click To Increment: #{value}  " }]
        
        on_widget_selected do
          @counter_presenter.increment_count
        end
      }
      
      
    }
  }
end

HelloButton.launch
```

##### MVP Example - Implicit Presenter

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

```ruby
require 'glimmer-dsl-swt'

class Counter
  attr_accessor :count
  
  def initialize
    self.count = 0
  end
  
  def increment
    self.count += 1
  end
end

class HelloButton
  include Glimmer::UI::Application
  
  before_body do
    @counter = Counter.new
  end
  
  body {
    shell {
      text 'Hello, Button!'
      
      button {
        text <= [@counter, :count, on_read: ->(value) { "Click To Increment: #{value}  " }]
        
        on_widget_selected do
          @counter.count += 1
        end
      }
      
      
      
    }
  }
end

HelloButton.launch
```

##### MVP Example - Implicit Presenter with Bidirectional Data-Binding

![Hello Button](/images/glimmer-hello-button-with-text-bidirectional-data-binding.png)

This version diverges in behavior to demonstrate bidirectional data-binding through a text field that is data-bound bidirectionally to the same attribute that the button is data-bound to for the click count.

```ruby
require 'glimmer-dsl-swt'

class Counter
  attr_accessor :count
  
  def initialize
    self.count = 0
  end
  
  def increment
    self.count += 1
  end
end

class HelloButton
  include Glimmer::UI::Application
  
  before_body do
    @counter = Counter.new
  end
  
  body {
    shell {
      fill_layout(:vertical)
      text 'Hello, Button!'
      
      text {
        text <=> [@counter, :count, on_read: :to_s, on_write: :to_i]
      }
      
      button {
        text <= [@counter, :count, on_read: ->(value) { "Click To Increment: #{value}  " }]
        
        on_widget_selected do
          @counter.count += 1
        end
      }
    }
  }
end

HelloButton.launch
```

### Custom Widgets

Custom widgets are brand new Glimmer DSL keywords that represent aggregates of existing widgets (e.g. `address_form`), customized existing widgets (e.g. `greeting_label`), or brand new widgets (e.g. `oscilloscope`)

You can find out about [published Glimmer Custom Widgets](https://github.com/AndyObtiva/glimmer-dsl-swt#gem-listing) by running the `glimmer list:gems:customwidget` command

Glimmer supports two ways of creating custom widgets with minimal code:
1. Method-based Custom Widgets (for single-view-internal reuse): Extract a method containing Glimmer DSL widget syntax. Useful for quickly eliminating redundant code within a single view.
2. Class-based Custom Widgets (for multiple-view-external reuse): Create a class that includes the `Glimmer::UI::CustomWidget` module and Glimmer DSL widget syntax in a `body {}` block. This will automatically extend Glimmer's DSL syntax with an underscored lowercase keyword matching the class name by convention. Useful in making a custom widget available in many views.

Approach #1 is a casual Ruby-based approach. Approach #2 is the official Glimmer approach. Typically, when referring to Custom Widgets, we are talking about Class-based Custom Widgets.

A developer might start with approach #1 to eliminate duplication in a view and later upgrade it to approach #2 when needing to export a custom widget to make it available in many views.

Class-based Custom Widgets offer a number of benefits over method-based custom widgets, such as built-in support for passing SWT style, nested block of extra widgets and properties, and `before_body`/`after_body` hooks.

#### Simple Example

##### Method-Based Custom Widget Example

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

Definition and usage in the same file:
```ruby
def red_label(label_text)
  label {
    text label_text
    background :red
  }
end

shell {
  red_label('Red Label')
}.open
```

##### Class-Based Custom Widget Example

Simply create a new class that includes `Glimmer::UI::CustomWidget` and put Glimmer DSL code in its `#body` block (its return value is stored in `#body_root` attribute). Glimmer will then automatically recognize this class by convention when it encounters a keyword matching the class name converted to underscored lowercase (and namespace double-colons `::` replaced with double-underscores `__`)

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

Definition:
```ruby
class RedLabel
  include Glimmer::UI::CustomWidget

  body {
    label(swt_style) {
      background :red
    }
  }
end
```

Usage:
```ruby
shell {
  red_label(:center) {
    text 'Red Label'
    foreground :green
  }
}.open
```

As you can see, `RedLabel` became the Glimmer DSL keyword `red_label` and worked just like a standard label by taking in SWT style and nested properties. As such, it is a first-class citizen of the Glimmer GUI DSL.

#### Custom Widget Lifecycle Hooks

You may execute code before or after evaluating the body with these lifecycle hooks:
- `before_body`: takes a block that executes in the custom widget instance scope before calling `body`. Useful for initializing variables to later use in `body`
- `after_body`: takes a block that executes in the custom widget instance scope after calling `body`. Useful for setting up observers on widgets built in `body` (set in instance variables) and linking to other shells.

#### Lifecycle Hooks Example

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

Definition:
```ruby
module Red
  class Composite
    include Glimmer::UI::CustomWidget

    before_body {
      @color = :red
    }

    body {
      composite(swt_style) {
        background @color
      }
    }
  end
end
```

Usage:
```ruby
shell {
  red__composite {
    label {
      foreground :white
      text 'This is showing inside a Red Composite'
    }
  }
}.open
```

Notice how `Red::Composite` became `red__composite` with double-underscore, which is how Glimmer Custom Widgets signify namespaces by convention. Additionally, the `before_body` lifecycle hook was utilized to set a `@color` variable and use inside the `body`.

Keep in mind that namespaces are not needed to be specified if the Custom Widget class has a unique name, not clashing with a basic SWT widget or another custom widget name.

#### Custom Widget Listeners

If you need to declare a custom listener on a custom widget, you must override these methods:
- `can_handle_observation_request?(event, &block)`: returns if an event is supported or delegates to super otherwise (to ensure continued support for built-in events)
- `handle_observation_request(event, &block)`: handles event by storing the block in a list of block handlers to invoke at the right time in the custom widget code

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
require 'glimmer-dsl-swt'

# This class declares a `greeting_label` custom widget (by convention)
class GreetingLabel
  include Glimmer::UI::CustomWidget
  
  # multiple options without default values
  options :name, :colors
  
  # single option with default value
  option :greeting, default: 'Hello'
  
  # internal attribute (not a custom widget option)
  attr_accessor :label_color
  
  def can_handle_observation_request?(event, &block)
    event.to_s == 'on_color_changed' || super
  end
  
  def handle_observation_request(event, &block)
    if event.to_s == 'on_color_changed'
      @color_changed_handlers ||= []
      @color_changed_handlers << block
    else
      super
    end
  end
  
  before_body do
    @font = {height: 24, style: :bold}
    @label_color = :black
  end
  
  after_body do
    return if colors.nil?
    
    Thread.new {
      colors.cycle { |color|
        self.label_color = color
        @color_changed_handlers&.each {|handler| handler.call(color)}
        sleep(1)
      }
    }
  end
  
  body {
    # pass received swt_style through to label to customize (e.g. :center to center text)
    label(swt_style) {
      text "#{greeting}, #{name}!"
      font @font
      foreground <=> [self, :label_color]
    }
  }
  
end

# including Glimmer enables the Glimmer DSL syntax, including auto-discovery of the `greeting_label` custom widget
include Glimmer

shell {
  fill_layout :vertical
  
  minimum_size 215, 215
  text 'Hello, Custom Widget!'
  
  # custom widget options are passed in a hash
  greeting_label(name: 'Sean')
  
  # pass :center SWT style followed by custom widget options hash
  greeting_label(:center, name: 'Laura', greeting: 'Aloha') #
  
  greeting_label(:right, name: 'Rick') {
    # you can nest attributes under custom widgets just like any standard widget
    foreground :red
  }
  
  # the colors option cycles between colors for the label foreground every second
  greeting_label(:center, name: 'Mary', greeting: 'Aloha', colors: [:red, :dark_green, :blue]) {
    on_color_changed do |color|
      puts "Label color changed: #{color}"
    end
  }
}.open
```

#### Custom Widget API

Custom Widgets have the following attributes available to call from inside the `#body` method:
- `#parent`: Glimmer object parenting custom widget
- `#swt_style`: SWT style integer. Can be useful if you want to allow consumers to customize a widget inside the custom widget body
- `#options`: a hash of options passed in parentheses when declaring a custom widget (useful for passing in model data) (e.g. `calendar(events: events)`). Custom widget class can declare option names (array) with `::options` class method as shown below, which generates attribute accessors for every option (not to be confused with `#options` instance method for retrieving options hash containing names & values)
- `#content`: nested block underneath custom widget. It will be automatically called at the end of processing the custom widget body. Alternatively, the custom widget body may call `content.call` at the place where the content is needed to show up as shown in the following example.
- `#body_root`: top-most (root) widget returned from `#body` method.
- `#swt_widget`: actual SWT widget for `body_root`

Additionally, custom widgets can call the following class methods:
- `::options(*option_names)`: declares a list of options by taking an option name array (symbols/strings). This generates option attribute accessors (e.g. `options :orientation, :bg_color` generates `#orientation`, `#orientation=(v)`, `#bg_color`, and `#bg_color=(v)` attribute accessors)
- `::option(option_name, default: nil)`: declares a single option taking option name and default value as arguments (also generates attribute accessors just like `::options`)

#### Content/Options Example

(you may copy/paste in [`girb`](GLIMMER_GIRB.md))

Definition:
```ruby
class Sandwich
  include Glimmer::UI::CustomWidget

  options :orientation, :bg_color
  option :fg_color, default: :black

  body {
    composite(swt_style) { # gets custom widget style
      fill_layout orientation # using orientation option
      background bg_color # using container_background option
      label {
        text 'SANDWICH TOP'
      }
      content.call # this is where content block is called
      label {
        text 'SANDWICH BOTTOM'
      }
    }
  }
end
```

Usage:
```ruby
shell {
  sandwich(:no_focus, orientation: :vertical, bg_color: :red) {
    label {
      background :green
      text 'SANDWICH CONTENT'
    }
  }
}.open
```

Notice how `:no_focus` was the `swt_style` value, followed by the `options` hash `{orientation: :horizontal, bg_color: :white}`, and finally the `content` block containing the label with `'SANDWICH CONTENT'`

#### Custom Widget Gotchas

Beware of defining a custom attribute that is a common SWT widget property name.
For example, if you define `text=` and `text` methods to accept a custom text and then later you write this body:

```ruby
# ...
def text
  # ...
end

def text=(value)
  # ...
end

body {
  composite {
    label {
      text "Hello"
    }
    label {
      text "World"
    }
  }
}
# ...
```

The `text` method invoked in the custom widget body will call the one you defined above it. To avoid this gotcha, simply name the text property above something else, like `custom_text`.

#### Built-In Custom Widgets

##### Checkbox Group Custom Widget

`checkbox_group` (or alias `check_group`) is a Glimmer built-in custom widget that displays a list of `checkbox` buttons (`button(:check)`) based on its `items` property.

`checkbox_group` consists of a root `composite` (with `grid_layout 1, false` by default) that holds nested `checkbox` (`button(:check)`) widgets.

The `selection` property determines which `checkbox` buttons are checked. It expects an `Array` of `String` objects
The `selection_indices` property determines which `checkbox` button indices are checked. It expects an `Array` of index `Integer` objects that are zero-based.
The `checkboxes` property returns the list of nested `checkbox` widgets.

When data-binding `selection`, the model property should have a matching property with `_options` suffix (e.g. `activities_options` for `activities`) to provide an `Array` of `String` objects for `checkbox` buttons.

You may see an example at the [Hello, Checkbox Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-checkbox-group) sample.

![Hello Checkbox Group](/images/glimmer-hello-checkbox-group.png)

##### Radio Group Custom Widget

`radio_group` is a Glimmer built-in custom widget that displays a list of `radio` buttons (`button(:radio)`) based on its `items` property, which expects an `Array` of `String` objects.

`radio_group` consists of a root `composite` (with `grid_layout 1, false` by default) that holds nested `radio` widgets.

The `selection` property determines which `radio` button is selected. It expects a `String`
The `selection_index` property determines which `radio` button index is selected. It expects an index integer that is zero-based.
The `radios` property returns the list of nested `radio` widgets.

When data-binding `selection`, the model property should have a matching property with `_options` suffix (e.g. `country_options` for `country`) to provide text for `radio` buttons.

This custom widget is used in the [Glimmer Meta-Sample (The Sample of Samples)](#samples):

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

Glimmer Meta-Sample Code Example:

```ruby
# ...
radio_group { |radio_group_proxy|
  row_layout(:vertical) {
    fill true
  }
  selection bind(sample_directory, :selected_sample_name)
  font height: 24
}

# ...
```

You may see another example at the [Hello, Radio Group!](/docs/reference/GLIMMER_SAMPLES.md#hello-radio-group) sample.

##### Code Text Custom Widget

`code_text` is a Glimmer built-in custom widget that displays syntax highlighted code (e.g. Ruby/JavaScript/HTML code) for 204 languages (see [options](#code-text-options) for the full list) by automating customizations for the SWT [StyledText](https://help.eclipse.org/2020-09/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/custom/StyledText.html) widget, including ability to zoom font in and out, or restore original font height (more details below).

To utilize, simply use `code_text` in place of the multi-line `text` and `styled_text` widgets. If you set the `code_text` `text` property value to multi-line code content (e.g. Ruby/JavaScript/HTML code), it automatically styles it with syntax highlighting.

`code_text` attempts to use a monospace font if available, seeking font names in the following order (specified in `Glimmer::SWT::Custom::CodeText::FONT_NAMES_PREFERRED`):
1. `'Consolas'`
2. `'Courier'`
3. `'Monospace'`
4. `'Liberation Mono'`
5. First available font that contains the word `mono` (case-insensitive)
6. Default system font (if no other font in the list is found)

It is used in the [Glimmer Meta-Sample (The Sample of Samples)](#samples):

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

Dark Mode:

![Glimmer Meta-Sample](/images/glimmer-meta-sample-dark-mode.png)

Code Text Simple Example (default language is Ruby):

```ruby
code_text {
  text bind(SampleDirectory, 'selected_sample.code', read_only: true)
  editable bind(SampleDirectory, 'selected_sample.editable')
}
```

Code Text Specified Language Example:

```ruby
code_text(language: 'html') {
  text bind(SampleDirectory, 'selected_sample.code', read_only: true)
  editable bind(SampleDirectory, 'selected_sample.editable')
}
```

Code Text Lines and Margins Example:

```ruby
code_text(lines: true) {
  text <=> [SampleDirectory, 'selected_sample.code']
  editable <= [SampleDirectory, 'selected_sample.editable']
  left_margin 7
  right_margin 7
}
```

Code Text Customized Lines Width and Background Example:

```ruby
code_text(lines: {width: 3}) {
  line_numbers {
    background Display.system_dark_theme? ? :black : :white
  }
  text <=> [SampleDirectory, 'selected_sample.code']
  editable <= [SampleDirectory, 'selected_sample.editable']
  left_margin 7
  right_margin 7
}
```

Code Text Customized Root Composite Margins/Spacing Background Example:

```ruby
code_text(lines: true) {
  root {
    grid_layout(2, false) {
      horizontal_spacing 0
      margin_left 0
      margin_right 0
      margin_top 0
      margin_bottom 0
    }
  }
  line_numbers {
    background Display.system_dark_theme? ? :black : :white
  }
  text <=> [SampleDirectory, 'selected_sample.code']
  editable <= [SampleDirectory, 'selected_sample.editable']
  left_margin 7
  right_margin 7
}
```

###### Code Text Options

**lines**
(default: `false`)

Shows line numbers when set to true.

If set to a hash like `{width: 4}`, it sets the initial width of the line numbers lane in character count (default: 4)

Keep in mind that if the text grows and required a wider line numbers area, it grows automatically regardless of initial width.

**theme**
(default: `'glimmer'`)

Changes syntax color highlighting theme. Can be one of the following:
- `'glimmer'`
- `'glimmer_dark'` (always applied when OS is in Dark Mode unless you set another custom theme that has the word `dark` in its name, see more details below)
- `'github'`
- `'pastie'`

Or you can simply implement a new [Rouge](https://github.com/rouge-ruby/rouge) **custom theme** just like the [github](https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/themes/github.rb) theme or the glimmer theme: [lib/ext/rouge/themes/glimmer.rb](/lib/ext/rouge/themes/glimmer.rb)

**language**
(default: `'ruby'`)

Sets the code language, which can be one of the following [rouge gem](#https://rubygems.org/gems/rouge) supported languages:
- abap
- actionscript
- ada
- apache
- apex
- apiblueprint
- apple_script
- armasm
- augeas
- awk
- batchfile
- bbcbasic
- bibtex
- biml
- bpf
- brainf*ck
- brightscript
- bsl
- c
- ceylon
- cfscript
- clean
- clojure
- cmake
- cmhg
- coffeescript
- common_lisp
- conf
- console
- coq
- cpp
- crystal
- csharp
- css
- csvs
- cuda
- cypher
- cython
- d
- dart
- datastudio
- diff
- digdag
- docker
- dot
- ecl
- eex
- eiffel
- elixir
- elm
- email
- epp
- erb
- erlang
- escape
- factor
- fortran
- freefem
- fsharp
- gdscript
- ghc_cmm
- ghc_core
- gherkin
- glsl
- go
- gradle
- graphql
- groovy
- hack
- haml
- handlebars
- haskell
- haxe
- hcl
- hlsl
- hocon
- hql
- html
- http
- hylang
- idlang
- igorpro
- ini
- io
- irb
- isbl
- j
- janet
- java
- javascript
- jinja
- jsl
- json
- json_doc
- jsonnet
- jsp
- jsx
- julia
- kotlin
- lasso
- liquid
- literate_coffeescript
- literate_haskell
- livescript
- llvm
- lua
- lustre
- lutin
- m68k
- magik
- make
- markdown
- mason
- mathematica
- matlab
- minizinc
- moonscript
- mosel
- msgtrans
- mxml
- nasm
- nesasm
- nginx
- nim
- nix
- objective_c
- objective_cpp
- ocaml
- ocl
- openedge
- opentype_feature_file
- pascal
- perl
- php
- plain_text
- plist
- pony
- postscript
- powershell
- praat
- prolog
- prometheus
- properties
- protobuf
- puppet
- python
- q
- qml
- r
- racket
- reasonml
- rego
- rescript
- robot_framework
- ruby
- rust
- sas
- sass
- scala
- scheme
- scss
- sed
- shell
- sieve
- slice
- slim
- smalltalk
- smarty
- sml
- solidity
- sparql
- sqf
- sql
- ssh
- supercollider
- swift
- systemd
- tap
- tcl
- terraform
- tex
- toml
- tsx
- ttcn3
- tulip
- turtle
- twig
- typescript
- vala
- varnish
- vb
- velocity
- verilog
- vhdl
- viml
- vue
- wollok
- xml
- xojo
- xpath
- xquery
- yaml
- yang
- zig

**default_behavior**
(default: true)

**(BETA FEATURE)**

This adds some default keyboard shortcuts:
- CMD+A (CTRL+A on Windows/Linux) to select all
- CTRL+A on Mac to jump to beginning of line
- CTRL+E on Mac to jump to end of line
- CMD+= (CTRL+= on Windows/Linux) to zoom in (bump font height up by 1)
- CMD+- (CTRL+- on Windows/Linux) to zoom out (bump font height down by 1)
- CMD+0 (CTRL+0 on Windows/Linux) to restore to original font height
- Attempts to add proper indentation upon adding a new line when hitting ENTER (currently supporting Ruby only)

If you prefer it to be vanilla with no default key event listeners, then pass the `default_behavior: false` option.

Learn more at [Hello, Code Text!](/docs/reference/GLIMMER_SAMPLES.md#hello-code-text)

##### Video Custom Custom Widget

[![Video Widget](/images/glimmer-video-widget.png)](https://github.com/AndyObtiva/glimmer-cw-video)

Glimmer supports a [video custom widget](https://github.com/AndyObtiva/glimmer-cw-video) not in SWT, which was originally a Glimmer built-in custom widget, but has been later extracted into its own [Ruby gem](https://rubygems.org/gems/glimmer-cw-video).

Simply install the [glimmer-cw-video](https://rubygems.org/gems/glimmer-cw-video) gem.

#### Custom Widget Final Notes

This [Eclipse guide](https://www.eclipse.org/articles/Article-Writing%20Your%20Own%20Widget/Writing%20Your%20Own%20Widget.htm) for how to write custom SWT widgets is also applicable to Glimmer Custom Widgets written in Ruby. I recommend reading it:
[https://www.eclipse.org/articles/Article-Writing%20Your%20Own%20Widget/Writing%20Your%20Own%20Widget.htm](https://www.eclipse.org/articles/Article-Writing%20Your%20Own%20Widget/Writing%20Your%20Own%20Widget.htm)

Also, you may check out [Hello, Custom Widget!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-widget) for another example.

### Custom Shells

Custom shell is a kind of a [custom widget](#custom-widgets) that has `shell` (window) as the body root widget. It can be used to represent an application or a reusable window that may be opened/hidden/closed independently of the main application.

Except in the case of small demos, it is always recommended to build [Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) applications as custom shells.

Custom shells may also be chained in a wizard fashion in some cases.

You can find out about [published Glimmer Custom Shells](https://github.com/AndyObtiva/glimmer-dsl-swt#gem-listing) by running the `glimmer list:gems:customshell` command

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
class WizardStep
  include Glimmer::UI::CustomShell

  options :number, :step_count

  before_body {
    @title = "Step #{number}"
  }

  body {
    shell {
      text "Wizard - #{@title}"
      minimum_size 200, 100
      fill_layout :vertical
      label(:center) {
        text @title
        font height: 30
      }
      if number < step_count
        button {
          text "Go To Next Step"
          on_widget_selected do
            body_root.hide
          end
        }
      end
    }
  }
end

class Wizard
  include Glimmer::UI::CustomShell

  body {
    shell { |app_shell|
      text "Wizard"
      minimum_size 200, 100
      @current_step_number = 1
      @wizard_steps = 5.times.map { |n|
        wizard_step(number: n+1, step_count: 5) {
          on_swt_hide do
            if @current_step_number < 5
              @current_step_number += 1
              app_shell.hide
              @wizard_steps[@current_step_number - 1].open
            end
          end
        }
      }
      button {
        text "Start"
        font height: 40
        on_widget_selected do
          app_shell.hide
          @wizard_steps[@current_step_number - 1].open
        end
      }
    }
  }
end

Wizard.launch
```

If you use a Custom Shell as the top-level app shell, you may invoke the class method `.launch` instead of `open` to avoid building an app class yourself or including Glimmer into the top-level namespace (e.g. `Tetris.launch` instead of `include Glimmer; tetris.open`)

You may check out [Hello, Custom Shell!](/docs/reference/GLIMMER_SAMPLES.md#hello-custom-shell) for another example.

### Drag and Drop

As a first option, Glimmer's Drag and Drop support requires no more than adding `drag_source true` and `drop_target true` for the most basic case concerning `list`, `label`, `text`, and `spinner`, thanks to [SWT](https://www.eclipse.org/swt/) and Glimmer's lightweight [DSL syntax](#glimmer-dsl-syntax).

Example:

```ruby
  label {
    text 'Text To Drag and Drop'
    drag_source true
  }

  label {
    text 'Text To Replace'
    drop_target true
  }
```

As a second option, you may customize the data being transferred through drag and drop:
1. On the drag source widget, add `on_drag_set_data` [DragSourceListener](https://help.eclipse.org/2020-03/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/DragSourceListener.html) event handler block at minimum (you may also add `on_drag_start` and `on_drag_finished` if needed)
2. Set `event.data` to transfer via drag and drop inside the `on_drag_set_data` event handler block (defaults to `transfer` type of `:text`, as in a Ruby String)
3. On the drop target widget, add `on_drop` [DropTargetListener](https://help.eclipse.org/2020-03/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/DropTargetListener.html) event handler block at minimum (you may also add `on_drag_enter` [must set [`event.detail`](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/DropTargetEvent.html#detail) if added], `on_drag_over`, `on_drag_leave`, `on_drag_operation_changed` and `on_drop_accept` if needed)
4. Read `event.data` and consume it (e.g. change widget text) inside the `on_drop` event handler block.

Example (taken from [samples/hello/hello_drag_and_drop.rb](/docs/reference/GLIMMER_SAMPLES.md#hello-drag-and-drop) / you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
class Location
  attr_accessor :country
  
  def country_options
    %w[USA Canada Mexico Columbia UK Australia Germany Italy Spain]
  end
end

@location = Location.new

include Glimmer

shell {
  text 'Hello, Drag and Drop!'
  
  list {
    selection bind(@location, :country)
    
    on_drag_set_data do |event|
      list = event.widget.control
      event.data = list.selection.first
    end
  }
  
  label(:center) {
    text 'Drag a country here!'
    font height: 20
    
    on_drop do |event|
      event.widget.control.text = event.data
    end
  }
}.open
```

![Hello Drag and Drop](/images/glimmer-hello-drag-and-drop.gif)

As a third most advanced option, you may:
- Set a `transfer` property (defaults to `:text`). Values may be: :text (default), :html :image, :rtf, :url, and :file, or an array of multiple values. The `transfer` property will automatically convert your option into a [Transfer](https://help.eclipse.org/2020-03/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/Transfer.html) object as per the SWT API.
- Specify `drag_source_style` operation (may be: :drop_copy (default), :drop_link, :drop_move, :drop_none, or an array of multiple operations)
- Specify `drag_source_effect` (Check [DragSourceEffect](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/DragSourceEffect.html) SWT API for details)
- Specify `drop_target_style` operation (may be: :drop_copy (default), :drop_link, :drop_move, :drop_none, or an array of multiple operations)
- Specify `drop_target_effect` (Check [DropTargetEffect](https://help.eclipse.org/2020-06/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/dnd/DropTargetEffect.html) SWT API for details)
- Set drag operation in `event.detail` (e.g. DND::DROP_COPY) inside `on_drag_enter`

You may learn more about advanced SWT Drag and Drop cases over here: [https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html](https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html)

### Miscellaneous

#### Multi-DSL Support

Glimmer is a DSL engine that supports multiple DSLs (Domain Specific Languages):
- [SWT](https://github.com/AndyObtiva/glimmer-dsl-swt): Glimmer DSL for SWT (Desktop GUI)
- [Opal](https://github.com/AndyObtiva/glimmer-dsl-opal): Glimmer DSL for Opal (Web GUI Adapter for Desktop Apps)
- [XML](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML) - Useful with [SWT Browser Widget](#browser-widget)
- [CSS](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS (Cascading Style Sheets) - Useful with [SWT Browser Widget](#browser-widget)

Glimmer automatically recognizes top-level keywords in each DSL and activates DSL accordingly. Glimmer allows mixing DSLs, which comes in handy when doing things like using the SWT Browser widget with XML and CSS. Once done processing a nested DSL top-level keyword, Glimmer switches back to the prior DSL automatically.

##### SWT

The SWT DSL was already covered in detail. However, for the sake of mixing DSLs, you need to know that the SWT DSL has the following top-level keywords:
- `shell`
- `display`
- `color`
- `observe`
- `async_exec`
- `sync_exec`

##### Opal

Full instructions are found in the [Opal](https://github.com/AndyObtiva/glimmer-dsl-opal) DSL page.

The [Opal](https://github.com/AndyObtiva/glimmer-dsl-opal) DSL is simply a web GUI adapter for desktop apps written in Glimmer. As such, it supports all the DSL keywords of the SWT DSL and shares the same top-level keywords.

##### XML

Simply start with `html` keyword and add HTML inside its block using Glimmer DSL syntax.
Once done, you may call `to_s`, `to_xml`, or `to_html` to get the formatted HTML output.

Here are all the Glimmer XML DSL top-level keywords:
- `html`
- `tag`: enables custom tag creation for exceptional cases by passing tag name as '_name' attribute
- `name_space`: enables namespacing html tags

Element properties are typically passed as a key/value hash (e.g. `section(id: 'main', class: 'accordion')`) . However, for properties like "selected" or "checked", you must leave value `nil` or otherwise pass in front of the hash (e.g. `input(:checked, type: 'checkbox')` )

Example (basic HTML / you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
@xml = html {
  head {
    meta(name: "viewport", content: "width=device-width, initial-scale=2.0")
  }
  body {
    h1 { "Hello, World!" }
  }
}
puts @xml
```

Output:

```
<html><head><meta name="viewport" content="width=device-width, initial-scale=2.0" /></head><body><h1>Hello, World!</h1></body></html>
```

Example (explicit XML tag / you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
puts tag(:_name => "DOCUMENT")
```

Output:

```
<DOCUMENT/>
```

Example (XML namespaces using `name_space` keyword / you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
@xml = name_space(:w3c) {
  html(:id => "thesis", :class => "document") {
    body(:id => "main") {
    }
  }
}
puts @xml
```

Output:

```
<w3c:html id="thesis" class="document"><w3c:body id="main"></w3c:body></w3c:html>
```

Example (XML namespaces using dot operator / you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
@xml = tag(:_name => "DOCUMENT") {
  document.body(document.id => "main") {
  }
}
puts @xml
```

Output:

```
<DOCUMENT><document:body document:id="main"></document:body></DOCUMENT>
```

##### CSS

Simply start with `css` keyword and add stylesheet rule sets inside its block using Glimmer DSL syntax.
Once done, you may call `to_s` or `to_css` to get the formatted CSS output.

`css` is the only top-level keyword in the Glimmer CSS DSL

Selectors may be specified by `s` keyword or HTML element keyword directly (e.g. `body`)
Rule property values may be specified by `pv` keyword or underscored property name directly (e.g. `font_size`)

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
@css = css {
  body {
    font_size '1.1em'
    pv 'background', 'white'
  }
  
  s('body > h1') {
    background_color :red
    pv 'font-size', '2em'
  }
}
puts @css
```

##### Listing / Enabling / Disabling DSLs

Glimmer provides a number of methods on Glimmer::DSL::Engine to configure DSL support or inquire about it:
- `Glimmer::DSL::Engine.dsls`: Lists available Glimmer DSLs
- `Glimmer::DSL::Engine.disable_dsl(dsl_name)`: Disables a specific DSL. Useful when there is no need for certain DSLs in a certain application.
- `Glimmer::DSL::Engine.disabled_dsls': Lists disabled DSLs
- `Glimmer::DSL::Engine.enable_dsl(dsl_name)`: Re-enables disabled DSL
- `Glimmer::DSL::Engine.enabled_dsls=(dsl_names)`: Disables all DSLs except the ones specified.

#### Application Menu Items (About/Preferences)

Mac applications always have About and Preferences menu items. Glimmer provides widget observer hooks for them on the `display`:
- `on_about`: executes code when user selects App Name -> About
- `on_preferences`: executes code when user selects App Name -> Preferences or hits 'CMD+,' on the Mac

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
class Example
  include Glimmer::UI::CustomShell
  
  before_body do
    display {
      on_about do
        message_box(@shell_proxy) {
          text 'About'
          message 'About Application'
        }.open
      end
      on_preferences do
        preferences_dialog = dialog {
          text 'Preferences'
          row_layout {
            type :vertical
            margin_left 15
            margin_top 15
            margin_right 15
            margin_bottom 15
          }
          label {
            text 'Check one of these options:'
          }
          button(:radio) {
            text 'Option 1'
          }
          button(:radio) {
            text 'Option 2'
          }
        }
        preferences_dialog.open
      end
    }
  end
  
  body {
    shell {
      fill_layout {
        margin_width 15
        margin_height 15
      }
      
      text 'Application Menu Items'
      
      label {
        text 'Application Menu Items'
        font height: 30
      }
    }
  }
end

Example.launch
```

#### App Name and Version

Application name (shows up on the Mac in top menu bar) and version may be specified upon [packaging](#packaging--distribution) by specifying "-Bmac.CFBundleName" and "-Bmac.CFBundleVersion" options.

Still, if you would like proper application name to show up on the Mac top menu bar during development, you may do so by invoking the SWT `Display.app_name=` method before any Display object has been instantiated (i.e. before any Glimmer widget like shell has been declared).

Example (you may copy/paste in [`girb`](GLIMMER_GIRB.md)):

```ruby
Display.app_name = 'Glimmer Demo'

shell(:no_resize) {
  text "Glimmer"
  label {
    text "Hello, World!"
  }
}.open
```

Also, you may invoke `Display.app_version = '1.0.0'` if needed for OS app version identification reasons during development, replacing `'1.0.0'` with your application version.

#### Performance Profiling

JRuby comes with built-in support for performance profiling via the `--profile` option (with some code shown below), which can be accepted by the `glimmer` command too:

`glimmer --profile path_to_glimmer_app.rb`

Additionally, add this code to monitor Glimmer app performance around its launch method:

```ruby
require 'jruby/profiler'
profile_data = JRuby::Profiler.profile do
  SomeGlimmerApp.launch
end

profile_printer = JRuby::Profiler::HtmlProfilePrinter.new(profile_data)
ps = java.io.PrintStream.new(STDOUT.to_outputstream)
```

When monitoring app startup time performance, make sure to add a hook to the top-level `shell` `on_swt_show` event that exits the app as soon as the shell shows up to end performance profiling and get the results.

Example:

```ruby
shell {
  # some code
  on_swt_show do
    exit(0)
  end
}
```

You may run `glimmer` with the `--profile.graph` instead for a more detailed output.

Learn more at the [JRuby Performance Profile WIKI page](https://github.com/jruby/jruby/wiki/Profiling-JRuby).

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2022 - Andy Maleh.
