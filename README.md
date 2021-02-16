# [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=85 />](https://github.com/AndyObtiva/glimmer) Glimmer DSL for SWT 4.18.4.10
## JRuby Desktop Development GUI Framework
[![Gem Version](https://badge.fury.io/rb/glimmer-dsl-swt.svg)](http://badge.fury.io/rb/glimmer-dsl-swt)
[![Travis CI](https://travis-ci.com/AndyObtiva/glimmer-dsl-swt.svg?branch=master)](https://travis-ci.com/github/AndyObtiva/glimmer-dsl-swt)
[![Coverage Status](https://coveralls.io/repos/github/AndyObtiva/glimmer-dsl-swt/badge.svg?branch=master)](https://coveralls.io/github/AndyObtiva/glimmer-dsl-swt?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/aaf1cba142dd351f84bd/maintainability)](https://codeclimate.com/github/AndyObtiva/glimmer-dsl-swt/maintainability)
[![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**[Contributors Wanted! (Submit a Glimmer App Sample to Get Started)](#contributing)**

[Glimmer DSL for SWT](https://github.com/AndyObtiva/glimmer) is a native-GUI cross-platform desktop development library written in [JRuby](https://www.jruby.org/), an OS-threaded faster JVM version of [Ruby](https://www.ruby-lang.org/en/). [Glimmer](https://github.com/AndyObtiva/glimmer)'s main innovation is a declarative [Ruby DSL](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#glimmer-dsl-syntax) that enables productive and efficient authoring of desktop application user-interfaces by relying on the robust [Eclipse SWT library](https://www.eclipse.org/swt/). [Glimmer](https://rubygems.org/gems/glimmer) additionally innovates by having built-in [data-binding](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#data-binding) support, which greatly facilitates synchronizing the GUI with domain models, thus achieving true decoupling of object oriented components and enabling developers to solve business problems (test-first) without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models (test-first) afterwards. Not only does Glimmer provide a large set of GUI [widgets](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#widgets), but it also supports drawing Canvas Graphics like [Shapes](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-shape-dsl) and [Animations](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-animation-dsl). To get started quickly, [Glimmer](https://rubygems.org/gems/glimmer) offers [scaffolding](docs/reference/GLIMMER_COMMAND.md#scaffolding) options for [Apps](#in-production), [Gems](docs/reference/GLIMMER_COMMAND.md#custom-shell-gem), and [Custom Widgets](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#custom-widgets). [Glimmer](https://rubygems.org/gems/glimmer) also includes native-executable [packaging](docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md) support, sorely lacking in other libraries, thus enabling the delivery of desktop apps written in [Ruby](https://www.ruby-lang.org/en/) as truly native DMG/PKG/APP files on the [Mac](https://www.apple.com/ca/macos) + [App Store](https://developer.apple.com/macos/distribution/), MSI/EXE files on [Windows](https://www.microsoft.com/en-ca/windows), and [Gem Packaged Shell Scripts](docs/reference/GLIMMER_COMMAND.md#packaging) on [Linux](https://www.linux.org/).

[Glimmer receives two updates per month](https://rubygems.org/gems/glimmer-dsl-swt/versions). You can trust [Glimmer](https://rubygems.org/gems/glimmer) with your Ruby desktop GUI development needs. Please make [Glimmer](https://rubygems.org/gems/glimmer) even better by providing feedback and [contributing](#contributing) when possible.

Gem version numbers are in sync with the SWT library versions. The first two digits represent the SWT version number. The last two digits represent the minor and patch versions of Glimmer DSL for SWT.

[Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) versions 4.18.x.y come with [SWT 4.18](https://download.eclipse.org/eclipse/downloads/drops4/R-4.18-202012021800/), which was released on December 2, 2020.

[<img src="https://covers.oreillystatic.com/images/9780596519650/lrg.jpg" width=105 /><br />
Featured in JRuby Cookbook](http://shop.oreilly.com/product/9780596519650.do) and [Chalmers/Gothenburg University Software Engineering Master's Lecture Material](http://www.cse.chalmers.se/~bergert/slides/guest_lecture_DSLs.pdf)

Glimmer DSL gems:
- [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt): Glimmer DSL for SWT (JRuby Desktop Development GUI Framework)
- [glimmer-dsl-opal](https://github.com/AndyObtiva/glimmer-dsl-opal): Glimmer DSL for Opal (Pure Ruby Web GUI and Auto-Webifier of Desktop Apps)
- [glimmer-dsl-xml](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML)
- [glimmer-dsl-css](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS
- [glimmer-dsl-tk](https://github.com/AndyObtiva/glimmer-dsl-tk): Glimmer DSL for Tk (MRI Ruby Desktop Development GUI Library)

## Examples

### Hello, World! Sample

Glimmer GUI DSL code (from [samples/hello/hello_world.rb](samples/hello/hello_world.rb)):

```ruby
include Glimmer

shell {
  text "Glimmer"
  label {
    text "Hello, World!"
  }
}.open
```

Run via `glimmer samples` or directly:

```
glimmer samples/hello/hello_world.rb
```

Glimmer app:

![Hello World](images/glimmer-hello-world.png)

Learn more about [Hello, World!](docs/reference/GLIMMER_SAMPLES#hello-world).

### Hello, Table! Sample

Glimmer GUI DSL code (from [samples/hello/hello_table.rb](samples/hello/hello_table.rb)):

```ruby
# ... model code precedes
shell {
  grid_layout
  
  text 'Hello, Table!'
  background_image File.expand_path('hello_table/baseball_park.png', __dir__)
  
  label {
    layout_data :center, :center, true, false
    
    text 'BASEBALL PLAYOFF SCHEDULE'
    background :transparent
    foreground rgb(94, 107, 103)
    font name: 'Optima', height: 38, style: :bold
  }
  
  combo(:read_only) {
    layout_data :center, :center, true, false
    selection bind(BaseballGame, :playoff_type)
    font height: 14
  }
  
  table(:editable) { |table_proxy|
    layout_data :fill, :fill, true, true
  
    table_column {
      text 'Game Date'
      width 150
      sort_property :date # ensure sorting by real date value (not `game_date` string specified in items below)
      editor :date_drop_down, property: :date_time
    }
    table_column {
      text 'Game Time'
      width 150
      sort_property :time # ensure sorting by real time value (not `game_time` string specified in items below)
      editor :time, property: :date_time
    }
    table_column {
      text 'Ballpark'
      width 180
      editor :none
    }
    table_column {
      text 'Home Team'
      width 150
      editor :combo, :read_only # read_only is simply an SWT style passed to combo widget
    }
    table_column {
      text 'Away Team'
      width 150
      editor :combo, :read_only # read_only is simply an SWT style passed to combo widget
    }
    table_column {
      text 'Promotion'
      width 150
      # default text editor is used here
    }
    
    # Data-bind table items (rows) to a model collection property, specifying column properties ordering per nested model
    items bind(BaseballGame, :schedule), column_properties(:game_date, :game_time, :ballpark, :home_team, :away_team, :promotion)
    
    # Data-bind table selection
    selection bind(BaseballGame, :selected_game)
    
    # Default initial sort property
    sort_property :date
    
    # Sort by these additional properties after handling sort by the column the user clicked
    additional_sort_properties :date, :time, :home_team, :away_team, :ballpark, :promotion
    
    menu {
      menu_item {
        text 'Book'
        
        on_widget_selected {
          book_selected_game
        }
      }
    }
  }
  
  button {
    text 'Book Selected Game'
    layout_data :center, :center, true, false
    font height: 14
    enabled bind(BaseballGame, :selected_game)
    
    on_widget_selected {
      book_selected_game
    }
  }
}.open
# ...
```

Run via `glimmer samples` or directly:

```
glimmer samples/hello/hello_table.rb
```

Glimmer App:

![Hello Table](images/glimmer-hello-table.png)

Learn more about [Hello, Table!](docs/reference/GLIMMER_SAMPLES#hello-table).

### Tetris

Glimmer GUI DSL code (from [samples/elaborate/tetris.rb](samples/elaborate/tetris.rb)):

```ruby
# ... more code resides in other files (navigate sample files to learn more)
shell(:no_resize) {
  grid_layout {
    num_columns 2
    make_columns_equal_width false
    margin_width 0
    margin_height 0
    horizontal_spacing 0
  }
  
  text 'Glimmer Tetris'
  minimum_size 475, 500
  image tetris_icon

  tetris_menu_bar(game: game)

  playfield(game_playfield: game.playfield, playfield_width: playfield_width, playfield_height: playfield_height, block_size: BLOCK_SIZE)

  score_lane(game: game, block_size: BLOCK_SIZE) {
    layout_data(:fill, :fill, true, true)
  }
}
# ...
```

Run via `glimmer samples` or directly:

```
glimmer samples/elaborate/tetris.rb
```

Glimmer app:

![Tetris](images/glimmer-tetris.png)


### Desktop Apps Built with Glimmer DSL for SWT

[<img alt="Are We There Yet Logo" src="https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-logo.svg" width="40" />Are We There Yet?](https://github.com/AndyObtiva/are-we-there-yet) - Small Project Tracking App

[![Are We There Yet? App Screenshot](https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-screenshot-windows.png)](https://github.com/AndyObtiva/are-we-there-yet)

[<img alt="Math Bowling Logo" src="https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/math-bowling-logo.png" width="40" />Math Bowling](https://github.com/AndyObtiva/MathBowling) - Elementary Level Math Game Featuring Bowling Rules

[![Math Bowling App Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/Math-Bowling-Screenshot.png)](https://github.com/AndyObtiva/MathBowling)

**Note:** I offer Glimmer DSL for SWT as a free and open-source [Ruby Gem](https://rubygems.org/gems/glimmer-dsl-swt) that represents my interests in Ruby Programming, Desktop GUI application development with SWT, Object Oriented Design, Design Patterns, and Software Architecture.
Additionally, I am sharing my professional experience and expertise in Eclipse SWT given that I am an [EclipseCon](http://andymaleh.blogspot.com/2007/03/eclipsecon-2007-day-3.html)/[EclipseWorld](http://andymaleh.blogspot.com/2008/11/eclipseworld-2008-highlights.html) presenter and have built professional applications in SWT/JFace/RCP for Obtiva and the Pampered Chef in the past. This is also done in the hopes that it would indirectly bring me work in a field I am extremely passionate about.
That said, please keep in mind that I myself am learning topics in Software Engineering too everyday, including newer editions of SWT and JRuby, which seem to pop up every quarter.
If you see anything that needs to be improved, please do not hesitate to contact me on [Gitter](https://gitter.im/AndyObtiva/glimmer) or submit [Issues](https://github.com/AndyObtiva/glimmer-dsl-swt/issues)/[Pull-Requests](https://github.com/AndyObtiva/glimmer-dsl-swt/pulls).

## Table of contents

- [Glimmer (JRuby Desktop Development GUI Framework)](#jruby-desktop-development-gui-framework)
  - [Table of contents](#table-of-contents)
  - [Background](#background)
  - [Software Architecture](#software-architecture)
  - [Platform Support](#platform-support)
  - [Pre-requisites](#pre-requisites)
  - [Setup](#setup)
  - [Glimmer Command](#glimmer-command)
  - [Girb (Glimmer irb) Command](#girb-glimmer-irb-command)
  - [Glimmer GUI DSL Syntax](#glimmer-gui-dsl-syntax)
  - [Glimmer Configuration](#glimmer-configuration)
  - [Glimmer Style Guide](#glimmer-style-guide)
  - [Samples](#samples)
  - [In Production](#in-production)
  - [Packaging & Distribution](#packaging--distribution)
  - [App Updates](#app-updates)
  - [Glimmer Supporting Libraries](#glimmer-supporting-libraries)
  - [Glimmer Process](#glimmer-process)
  - [Resources](#resources)
  - [Help](#help)
  - [Feature Suggestions](#feature-suggestions)
  - [Change Log](#change-log)
  - [Contributing](#contributing)
  - [Contributors](#contributors)
  - [Hire Me](#hire-me)
  - [License](#license)
  
## Background

[Ruby](https://www.ruby-lang.org) is a dynamically-typed object-oriented language, which provides great productivity gains due to its powerful expressive syntax and dynamic nature. While it is proven by the [Ruby](https://www.ruby-lang.org) on Rails framework for web development, it currently lacks a robust platform-independent framework for building desktop applications. Given that Java libraries can now be utilized in Ruby code through JRuby, Eclipse technologies, such as [SWT](https://www.eclipse.org/swt/), JFace, and RCP can help fill the gap of desktop application development with Ruby.

## Software Architecture

There are several requirements for building enterprise-level/consumer-level desktop GUI applications:
- Cross-Platform Support (Mac, Windows, Linux) without compilation/recompilation
- OS Native Look & Feel
- High Performance
- Productivity
- Maintainability
- Extensibility
- Native Executable Packaging
- Multi-Threading / Parallel Programming
- Arbitrary Graphics Painting
- Audio Support

Glimmer provides cross-platform support that does not require Ruby compilation (like Tk does), thanks to JRuby, a JVM (Java Virtual Machine) faster OS-threaded version of Ruby.

Glimmer leverages SWT (Standard Widget Toolkit), which provides cross-platform widgets that automatically use the native GUI libraries under each operating system, such as Win32 on Windows, Cocoa on Mac, and GTK on Linux.

Furthermore, what is special about SWT regarding "High Performance" is that it does all the GUI painting natively outside of Java, thus producing GUI that runs at maximum performance even in Ruby. As such, you do not need to worry about Ruby dynamic typing getting in the way of GUI performance. It has ZERO effect on it and since SWT supports making asynchronous calls for GUI rendering, you could avoid blocking the GUI completely with any computations happening in Ruby no matter how complex, thus never affecting the responsiveness of GUI of applications while taking full advantage of the productivity benefits of Ruby dynamic typing.

Glimmer takes this further by providing a very programmer friendly DSL (Domain Specific Language) that visually maps lightweight Ruby syntax to the containment hierarchy of GUI widgets (meaning Ruby blocks nested within each other map to GUI widgets nested within each other). This provides maximum productivity and maintainability.

Extensibility has never been simpler in desktop GUI application development than with Glimmer, which provides the ability to support any new custom keywords through custom widgets and custom shells (windows). Basically, you map a keyword by declaring a view class matching its name by convention with a GUI body that simply consists of reusable Glimmer GUI syntax. They can be passive views or smart views with additional logic. This provides the ultimate realization of Object Oriented Programming and micro-level MVC pattern.

Thanks to Java and JRuby, Glimmer apps can be packaged as cross-platform JAR files (with JRuby Warbler) and native executables (with Java Packager) as Mac APP/DMG/PACKAGE or Windows EXE/MSI.

The Java Virtual Machine already supports OS-native threads, so Glimmer apps can have multiple things running in parallel with no problem.

SWT supports Canvas graphics drawing, and Glimmer takes that further by provding a Canvas Shape/Transform/Animation DSL, making it very simple to decorate any existing widgets or add new widgets with a completely custom look and feel if needed for branding or entertainment (gaming) purposes.

Audio is supported via the Java Sound library in a cross-platform approach and video is supported via a Glimmer custom widget, so any Glimmer app can be enhanced with audio and video where needed.

## Platform Support

Glimmer runs on the following platforms:
- Mac
- Windows
- Linux

Glimmer's GUI has the native look and feel of each operating system it runs on since it uses SWT behind the scenes, which leverages the following native libraries:
- Win32 on Windows
- Cocoa on Mac
- GTK on Linux

More info about the SWT GUI on various platforms can be found on the Eclipse WIKI and SWT FAQ:

https://wiki.eclipse.org/SWT/Devel/Gtk/Dev_guide#Win32.2FCocoa.2FGTK
https://www.eclipse.org/swt/faq.php

## Pre-requisites

- JDK 8u241 (1.8.0_241) (find at https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html / On Windows, ensure PATH includes Java bin directory  like C:\Program Files\Java\jdk1.8.0_241\bin for javapackager to work during packaging Glimmer applications)
- JRuby 9.2.14.0 (supporting Ruby 2.5.x syntax) (get via [RVM](http://rvm.io) on Mac and Linux or find at [https://www.jruby.org/download](https://www.jruby.org/download) for Windows)
- SWT 4.18 (already included in the [glimmer-dsl-swt](https://rubygems.org/gems/glimmer-dsl-swt) gem)
- Git (comes with Mac and Linux. Install on Windows: https://git-scm.com/download/win )

To obtain JRuby through [RVM](http://rvm.io), you may run:

```bash
rvm install jruby-9.2.14.0
```

Glimmer might still work on other versions of Java, JRuby and SWT, but there are no guarantees, so it is best to stick to the pre-requisites outlined above.

## Setup

Please follow these instructions to make the `glimmer` command available on your system via the [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem.

If you intend to learn the basics of Glimmer but are not ready to build a Glimmer app yet, pick Option 1 ([Direct Install](#option-1-direct-install)).

If you intend to build a Glimmer app from scratch with [scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding), pick Option 1 ([Direct Install](#option-1-direct-install)) as well.

Otherwise, Option 2 ([Bundler](#option-2-bundler)) can be followed in rare cases where you want to build an app without [scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding).

**Note:** if you encounter any [issues](https://github.com/AndyObtiva/glimmer-dsl-swt/issues), please [report](https://github.com/AndyObtiva/glimmer-dsl-swt/issues) and then install a previous version instead from the list of [Glimmer Releases](https://rubygems.org/gems/glimmer-dsl-swt/versions) (keep looking back till you find one that works). Do not be disheartened as nearly everything is only a few days of work away. That said, keep in mind that this project is free and open source, meaning provided as is, so do not expect anything, but if you help with reporting and contributing, you could speed things up or even become part of the project.

### Option 1: Direct Install
(Use for [Scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding))

Run this command to install directly:
```
jgem install glimmer-dsl-swt
```

Or this command if you want a specific version:
```
jgem install glimmer-dsl-swt -v 4.18.4.10
```

`jgem` is JRuby's version of `gem` command.
RVM allows running `gem install` directly as an alias.
Otherwise, you may also run `jruby -S gem install ...`

If you are new to Glimmer and would like to continue learning the basics, you may continue to the [Glimmer Command](https://github.com/AndyObtiva/glimmer#glimmer-command) section.

Otherwise, if you are ready to build a Glimmer app, you can jump to the [Glimmer Scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding) section next.

Note: if you're using activerecord or activesupport, keep in mind that Glimmer unhooks ActiveSupport::Dependencies as it does not rely on it.

### Option 2: Bundler
(Use for Manual App Creation)

Add the following to `Gemfile`:
```
gem 'glimmer-dsl-swt', '~> 4.18.4.10'
```

And, then run:
```
jruby -S bundle install
```

Note: if you're using activerecord or activesupport, keep in mind that Glimmer unhooks ActiveSupport::Dependencies as it does not rely on it.

You may learn more about other Glimmer related gems ([`glimmer-dsl-opal`](https://github.com/AndyObtiva/glimmer-dsl-opal), [`glimmer-dsl-xml`](https://github.com/AndyObtiva/glimmer-dsl-xml), and [`glimmer-dsl-css`](https://github.com/AndyObtiva/glimmer-dsl-css)) at [Multi-DSL Support](#multi-dsl-support)

## Glimmer Command

You can use the glimmer command to scaffold new apps, run apps & samples, package native executables, and list Glimmer community gems.

[docs/reference/GLIMMER_COMMAND.md](docs/reference/GLIMMER_COMMAND.md)

## Girb (Glimmer irb) Command

You can use `girb` as an alternative to `irb` when prototyping Glimmer DSL for SWT GUI DSL code.

[docs/reference/GLIMMER_GIRB.md](docs/reference/GLIMMER_GIRB.md)

## Glimmer GUI DSL Syntax

This guide should help you get started with Glimmer DSL for SWT.

[docs/reference/GLIMMER_GUI_DSL_SYNTAX.md](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md)

For more advanced SWT details, please refer to the [SWT Reference](#swt-reference).

## Glimmer Configuration

Glimmer configuration may be done via the `Glimmer::Config` module.

[docs/reference/GLIMMER_CONFIGURATION.md](docs/reference/GLIMMER_CONFIGURATION.md)

## Glimmer Style Guide

[docs/reference/GLIMMER_STYLE_GUIDE.md](docs/reference/GLIMMER_STYLE_GUIDE.md)

## Samples

Check the [samples](samples) directory in [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) for examples on how to write Glimmer applications. To run a sample, make sure to install the `glimmer` gem first and then use the `glimmer samples` command to run it (alternatively, you may clone the repo, follow [CONTRIBUTING.md](CONTRIBUTING.md) instructions, and run samples locally with development glimmer command: `bin/glimmer`).

[docs/reference/GLIMMER_SAMPLES.md](docs/reference/GLIMMER_SAMPLES.md)

## In Production

The following production apps have been built with Glimmer.

If you have a Glimmer app you would like referenced here, please mention in a Pull Request.

### Math Bowling

[<img alt="Math Bowling Logo" src="https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/math-bowling-logo.png" width="40" />Math Bowling](https://github.com/AndyObtiva/MathBowling): an educational math game for elementary level kids

### Are We There Yet?

[<img alt="Are We There Yet Logo" src="https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-logo.svg" width="40" />Are We There Yet?](https://github.com/AndyObtiva/are-we-there-yet): A tool that helps you learn when your small projects will finish

### Garderie Rainbow Daily Agenda

[<img alt="Garderie Rainbow Daily Agenda Logo" src="https://github.com/AndyObtiva/garderie_rainbow_daily_agenda/raw/master/images/garderie_rainbow_daily_agenda_logo.png" width="40" />Garderie Rainbow Daily Agenda](https://github.com/AndyObtiva/garderie_rainbow_daily_agenda): A child nursery daily agenda reporting desktop app

### Glimmer Gab

[<img alt="Glimmer Gab Logo" src="https://raw.githubusercontent.com/AndyObtiva/glimmer_gab/master/package/linux/Glimmer%20Gab.png" height=40 /> Glimmer Gab](https://github.com/AndyObtiva/glimmer_gab): Desktop App for Gab.com

### Connector

[<img alt="Connector Logo" src="https://raw.githubusercontent.com/AndyObtiva/connector/master/package/linux/Connector.png" height=40 /> Connector](https://github.com/AndyObtiva/connector): A minimalist open-source multi-engine web browser

## Packaging & Distribution

Glimmer simplifies the process of native-executable packaging and distribution on Mac and Windows via a single `glimmer package` command:

[docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md](docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md)

## App Updates

Glimmer already supports automatic (and manual) app updates via the Mac App Store for Mac apps. Simply run the `glimmer package` command with the Mac App Store keys configured as per [Mac Application Distribution](mac-application-distribution) instructions and you get automatic (and manual) app update support courtesy of the Mac App Store.

## Glimmer Supporting Libraries

Here is a list of notable 3rd party gems used by Glimmer:
- [juwelier](https://rubygems.org/gems/juwelier): generates app gems during [Glimmer Scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding)
- [logging](https://github.com/TwP/logging): provides extra logging capabilities not available in Ruby Logger such as multi-threaded buffered asynchronous logging (to avoid affecting app performance) and support for multiple appenders such as stdout, syslog, and log files (the last one is needed on Windows where syslog is not supported)
- [nested_inherited_jruby_include_package](https://github.com/AndyObtiva/nested_inherited_jruby_include_package): makes included [SWT](https://www.eclipse.org/swt/)/[Java](https://www.java.com/en/) packages available to all classes/modules that mix in the Glimmer module without having to manually reimport
- [os](https://github.com/rdp/os): provides OS detection capabilities (e.g. `OS.mac?` or `OS.windows?`) to write cross-platform code inexpensively
- [puts_debuggerer](https://github.com/AndyObtiva/puts_debuggerer): helps in troubleshooting when adding `require 'pd'` and using the `pd` command instead of `puts` or `p` (also `#pd_inspect` or `#pdi` instead of `#inspect`)
- [rake](https://github.com/ruby/rake): used to implement and execute `glimmer` commands
- [rake-tui](https://github.com/AndyObtiva/rake-tui): Rake Text-based User Interface. Allows navigating rake tasks with arrow keys and filtering task list by typing to quickly find an run a rake task.
- [rouge](https://github.com/rouge-ruby/rouge): Ruby syntax highlighter used in the `code_text` [Glimmer DSL for SWT custom widget](#custom-widgets) leveraged by the [Glimmer Meta-Sample](#samples)
- [super_module](https://github.com/AndyObtiva/super_module): used to cleanly write the Glimmer::UI:CustomWidget and Glimmer::UI::CustomShell modules
- [text-table](https://github.com/aptinio/text-table): renders textual data in a textual table for the command-line interface of Glimmer
- [warbler](https://github.com/jruby/warbler): converts a Glimmer app into a Java JAR file during packaging

## Glimmer Process

[Glimmer Process](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) is the lightweight software development process used for building Glimmer libraries and Glimmer apps, which goes beyond Agile, rendering all Agile processes obsolete. [Glimmer Process](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) is simply made up of 7 guidelines to pick and choose as necessary until software development needs are satisfied.

Learn more by reading the [GPG](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) (Glimmer Process Guidelines)

## Resources

* [Code Master Blog](http://andymaleh.blogspot.com/search/label/Glimmer)
* [JRuby Cookbook by Justin Edelson & Henry Liu](http://shop.oreilly.com/product/9780596519650.do)
* [InfoQ Article](http://www.infoq.com/news/2008/02/glimmer-jruby-swt)
* [DZone Tutorial](https://dzone.com/articles/an-introduction-glimmer)
* [MountainWest RubyConf 2011 Video](https://confreaks.tv/videos/mwrc2011-whatever-happened-to-desktop-development-in-ruby)
* [RubyConf 2008 Video](https://confreaks.tv/videos/rubyconf2008-desktop-development-with-glimmer)

### SWT Reference

https://www.eclipse.org/swt/docs.php

Here is the SWT API:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/index.html

Here is a visual list of SWT widgets:

https://www.eclipse.org/swt/widgets/

Here is a textual list of SWT widgets:

https://help.eclipse.org/2019-12/topic/org.eclipse.platform.doc.isv/guide/swt_widgets_controls.htm?cp=2_0_7_0_0

Here is a list of SWT style bits as used in widget declaration:

https://wiki.eclipse.org/SWT_Widget_Style_Bits

Here is a SWT style bit constant reference:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html

Here is an SWT Drag and Drop guide:

https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html

Here is an SWT Custom Widget guide:

https://www.eclipse.org/articles/Article-Writing%20Your%20Own%20Widget/Writing%20Your%20Own%20Widget.htm

Here is an SWT Image guide:

https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html

Here is an SWT Graphics / Canvas-Drawing guide:

https://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html

Here is the Nebula Project (custom widget library) homepage:

https://www.eclipse.org/nebula/

## Help

### Issues

You may submit [issues](https://github.com/AndyObtiva/glimmer-dsl-swt/issues) on [GitHub](https://github.com/AndyObtiva/glimmer-dsl-swt/issues).

[Click here to submit an issue.](https://github.com/AndyObtiva/glimmer-dsl-swt/issues)

### Chat

If you need live help, try to [![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Feature Suggestions

These features have been suggested. You might see them in a future version of Glimmer. You are welcome to contribute more feature suggestions.

[TODO.md](TODO.md)

Glimmer DSL Engine specific tasks are at:

[glimmer/TODO.md](https://github.com/AndyObtiva/glimmer/blob/master/TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

Also: [glimmer/CHANGELOG.md](https://github.com/AndyObtiva/glimmer/blob/master/CHANGELOG.md)

## Contributing

**Contributors Wanted!**

If you would like to contribute to Glimmer, please study up on Glimmer and [SWT](#swt-reference), run all Glimmer [samples](#samples), and build a small sample app (perhaps from [this TODO list](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/TODO.md#samples)) to add to [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) Hello or Elaborate samples via a Pull Request. Once done, contact me on [Chat](#chat).

You may apply for contributing to any of these Glimmer DSL gems whether you prefer to focus on the desktop or web:
- [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt): Glimmer DSL for SWT (Desktop GUI)
- [glimmer-dsl-opal](https://github.com/AndyObtiva/glimmer-dsl-opal): Glimmer DSL for Opal (Web GUI Adapter for Desktop Apps)
- [glimmer-dsl-xml](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML)
- [glimmer-dsl-css](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS (Cascading Style Sheets)

[CONTRIBUTING.md](CONTRIBUTING.md)

## Contributors

* [Andy Maleh](https://github.com/AndyObtiva) (Founder)
* [Dennis Theisen](https://github.com/Soleone) (Contributor, originally in [Glimmer](https://github.com/AndyObtiva/glimmer/graphs/contributors) before splitting glimmer-dsl-swt)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer-dsl-swt/graphs/contributors)

## Hire Me

If your company would like to invest fulltime in further development of the Glimmer open-source project, [hire me](https://www.linkedin.com/in/andymaleh/).

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2021 - Andy Maleh.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built for [Glimmer](https://github.com/AndyObtiva/glimmer) (DSL Framework).
