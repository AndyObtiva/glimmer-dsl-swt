# [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=85 />](https://github.com/AndyObtiva/glimmer) Glimmer DSL for SWT 4.29.0.0
## JRuby Desktop Development Cross-Platform Native GUI Framework
### The Quickest Way From Zero To GUI
[![Gem Version](https://badge.fury.io/rb/glimmer-dsl-swt.svg)](http://badge.fury.io/rb/glimmer-dsl-swt)
[![Travis CI](https://travis-ci.com/AndyObtiva/glimmer-dsl-swt.svg?branch=master)](https://travis-ci.com/github/AndyObtiva/glimmer-dsl-swt)
[![Coverage Status](https://coveralls.io/repos/github/AndyObtiva/glimmer-dsl-swt/badge.svg?branch=master)](https://coveralls.io/github/AndyObtiva/glimmer-dsl-swt?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/aaf1cba142dd351f84bd/maintainability)](https://codeclimate.com/github/AndyObtiva/glimmer-dsl-swt/maintainability)
[![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**[If You Liked Shoes, You'll Love Glimmer!](https://github.com/AndyObtiva/glimmer#faq)**

**(Original Glimmer Library Handling World’s Ruby GUI Needs Since 2007. Beware of Imitators!)**

(**[***RubyConf 2022 Talk - Building Native GUI Apps in Ruby***](https://andymaleh.blogspot.com/2023/02/rubyconf-2022-talk-video-for-building.html)**)

(**[***Montreal.rb Talk - Glimmer DSL for SWT - Ruby Desktop Development GUI Framework***](https://andymaleh.blogspot.com/2022/10/montrealrb-talk-slides-for-glimmer-dsl.html)**)

[**(Ruby Rogues Podcast Interview - Desktop Apps in Ruby ft. Andy)**](https://andymaleh.blogspot.com/2022/05/ruby-rogues-podcast-interview-desktop.html)

[GLIMMER VIDEO TUTORIAL CHANNEL](https://www.youtube.com/channel/UC5hzDE23HZXsZLAxYk2UJEw)

![Glimmer DSL for SWT Demo of Hello, World!](/images/glimmer-dsl-swt-demo-hello-world.gif)

[Glimmer](https://github.com/AndyObtiva/glimmer) DSL for [SWT](https://www.eclipse.org/swt/) (formerly [Glimmer](https://github.com/AndyObtiva/glimmer)) is a native GUI (Graphical User Interface) cross-platform desktop development library written in [JRuby](https://www.jruby.org/), an OS-threaded faster [JVM](https://www.java.com/en/download/help/whatis_java.html) version of [Ruby](https://www.ruby-lang.org/en/). [Glimmer](https://github.com/AndyObtiva/glimmer)'s main innovation is a minimalistic declarative [Ruby DSL](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#glimmer-dsl-syntax) (Domain Specific Language) that enables productive and efficient authoring of professional-grade desktop applications by relying on the robust [Eclipse SWT library](https://www.eclipse.org/swt/), with the familiar native look, feel, and behavior of GUI on Mac, Windows, and Linux. [Glimmer](https://rubygems.org/gems/glimmer) additionally innovates by having built-in [data-binding](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#data-binding) support, which greatly facilitates synchronizing the GUI with domain models, thus achieving true decoupling of object oriented components and enabling developers to solve business problems (test-first) without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models afterwards. Not only does Glimmer provide a large set of GUI [widgets](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#widgets), but it also supports drawing Canvas Graphics like [Shapes](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-shape-dsl) and [Animations](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#canvas-animation-dsl). To get started quickly, [Glimmer](https://rubygems.org/gems/glimmer) offers [scaffolding](docs/reference/GLIMMER_COMMAND.md#scaffolding) options for [Apps](#in-production), [Gems](docs/reference/GLIMMER_COMMAND.md#custom-shell-gem), and [Custom Widgets](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#custom-widgets). [Glimmer](https://rubygems.org/gems/glimmer) also includes native-executable [packaging](docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md) support, sorely lacking in other libraries, thus enabling the delivery of desktop apps written in [Ruby](https://www.ruby-lang.org/en/) as truly native DMG/PKG/APP files on the [Mac](https://www.apple.com/ca/macos), MSI/EXE files on [Windows](https://www.microsoft.com/en-ca/windows), and DEB/RPM files on [Linux](https://www.linux.org/). [Glimmer](https://github.com/AndyObtiva/glimmer) was the [first Ruby gem](https://rubygems.org/gems/glimmer) to bring [SWT](https://www.eclipse.org/swt/) (Standard Widget Toolkit) to [Ruby](https://www.ruby-lang.org/en/), thanks to creator [Andy Maleh](https://andymaleh.blogspot.com/), EclipseCon/EclipseWorld/RubyConf speaker.

[<img src="https://covers.oreillystatic.com/images/9780596519650/lrg.jpg" width=105 /><br />
Featured in JRuby Cookbook](http://shop.oreilly.com/product/9780596519650.do) and [Chalmers/Gothenburg University Software Engineering Master's Lecture Material](http://www.cse.chalmers.se/~bergert/slides/guest_lecture_DSLs.pdf)

[SWT](https://www.eclipse.org/swt/) (Standard Widget Toolkit) is a very robust GUI toolkit that is most famous for building the [Eclipse IDE](https://www.eclipse.org/ide/), a free and open-source general language Integrated Development Environment that was the first to provide a high-performance pause-free [Java](https://www.oracle.com/ca-en/java/) IDE (unlike earlier versions of NetBeans and other [Java](https://www.oracle.com/ca-en/java/) IDEs), thanks to its very smart software architecture. Additionally, [Eclipse RCP (Rich Client Platform, built on top of SWT) has been used by NASA to build Mars Rover operational software](https://www.eclipse.org/community/casestudies/NASAfinal.pdf). So, [Eclipse technologies](https://www.eclipse.org/) are not only very highly proven, but are also considered some of the best in the world.

![Eclipse SWT RCP NASA Mars Rover](/images/glimmer-eclipse-swt-rcp-nasa-mars-rover.png)

[Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) 4.29.0.0 includes [SWT 4.29](https://download.eclipse.org/eclipse/downloads/drops4/R-4.29-202309031000/), which was released on September 3, 2023. Gem version numbers are in sync with the SWT library versions. The first two digits represent the SWT version number. The last two digits represent the minor and patch versions of Glimmer DSL for SWT.

**Starting in version 4.20.0.0, [Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) comes with the new [***Shine***](/docs/reference/GLIMMER_GUI_DSL_SYNTAX.md#shine) syntax** for highly intuitive and visually expressive View/Model Attribute Mapping, relying on `<=>` for bidirectional (two-way) data-binding and `<=` for unidirectional (one-way) data-binding, providing an alternative to the `bind` keyword. That was [originally conceived back in 2007](https://andymaleh.blogspot.com/2007/12/data-shining-in-glimmer.html).

Please help make [Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) better by providing feedback and [contributing](#contributing) whenever possible. Any feature suggestions that are accepted could be implemented within weeks if not days.

Learn more about the differences between various [Glimmer](https://github.com/AndyObtiva/glimmer) DSLs by looking at the **[Glimmer DSL Comparison Table](https://github.com/AndyObtiva/glimmer#glimmer-dsl-comparison-table)**.

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

Glimmer app:

![Hello World](images/glimmer-hello-world.png)

Learn more about [Hello, World!](docs/reference/GLIMMER_SAMPLES#hello-world).

### Hello, Table! Sample

Glimmer GUI DSL code (from [samples/hello/hello_table.rb](samples/hello/hello_table.rb)):

```ruby
shell {
  grid_layout
  
  text 'Hello, Table!'
  background_image File.expand_path('hello_table/baseball_park.png', __dir__)
  image File.expand_path('hello_table/baseball_park.png', __dir__)
  
  label {
    layout_data :center, :center, true, false
    
    text 'BASEBALL PLAYOFF SCHEDULE'
    background :transparent if OS.windows?
    foreground rgb(94, 107, 103)
    font name: 'Optima', height: 38, style: :bold
  }
  
  combo(:read_only) {
    layout_data :center, :center, true, false
    selection <=> [BaseballGame, :playoff_type]
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
    items <=> [BaseballGame, :schedule, column_properties: [:game_date, :game_time, :ballpark, :home_team, :away_team, :promotion]]
    
    # Data-bind table selection
    selection <=> [BaseballGame, :selected_game]
    
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
    enabled <= [BaseballGame, :selected_game]
    
    on_widget_selected do
      book_selected_game
    end
  }
}
```

Glimmer App:

![Hello Table](images/glimmer-hello-table.png)

Learn more about [Hello, Table!](docs/reference/GLIMMER_SAMPLES#hello-table).

### Tetris

Glimmer GUI DSL code (from [samples/elaborate/tetris.rb](samples/elaborate/tetris.rb)):

```ruby
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
```

Glimmer app:

![Tetris](images/glimmer-tetris.png)

[Check out many more samples over here.](/docs/reference/GLIMMER_SAMPLES.md)

### Desktop Apps Built with Glimmer DSL for SWT

[<img alt="Are We There Yet Logo" src="https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-logo.svg" width="40" />Are We There Yet?](https://github.com/AndyObtiva/are-we-there-yet) - Small Project Tracking App (leveraging [ActiveRecord](https://rubygems.org/gems/activerecord) and [SQLite](https://www.sqlite.org/index.html))

[![Are We There Yet? App Screenshot](https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-screenshot-windows.png)](https://github.com/AndyObtiva/are-we-there-yet)

[<img alt="Math Bowling Logo" src="https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/math-bowling-logo.png" width="40" />Math Bowling](https://github.com/AndyObtiva/MathBowling) - Elementary Level Math Game Featuring Bowling Rules

[![Math Bowling App Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/Math-Bowling-Screenshot.png)](https://github.com/AndyObtiva/MathBowling)

[Check out other apps in production.](#in-production)

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

[Ruby](https://www.ruby-lang.org) is a dynamically-typed object-oriented language, which provides great productivity gains due to its expressive syntax and dynamic nature. While it is proven by the [Ruby](https://www.ruby-lang.org) on Rails framework for web development, it currently lacks a robust platform-independent framework for building desktop applications. Given that [Java](https://www.oracle.com/ca-en/java/) libraries can now be utilized in Ruby code through JRuby, Eclipse technologies, such as [SWT](https://www.eclipse.org/swt/), JFace, and RCP can help fill the gap of desktop application development with Ruby.

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

SWT supports Canvas graphics drawing, and Glimmer takes that further by provding a Canvas Shape/Transform/Animation DSL, making it very simple to decorate any existing widgets or add new widgets with a completely custom look and feel if needed for branding purposes.

Audio is supported via the Java Sound library in a cross-platform approach and video is supported via a Glimmer custom widget, so any Glimmer app can be enhanced with audio and video where needed.

### Remaining Challenges

JRuby startup time is longer than that of CRuby, but has gotten a lot faster with newer CPUs, especially the latest Mac ARM64 processors (it is now about 2.5 seconds on Mac ARM64 processors like the M1 chip). Thankfully, [there are work-arounds](https://andymaleh.blogspot.com/2021/03/glimmer-dsl-for-swt-41900-halved.html) that could make apps start as fast as instantly when needed.

Contributors who appreciate Glimmer's ultra-high productivity, maintainability, and extensibility might want to help report and resolve remaining challenges in its software architecture.

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

- JDK 19 is recommended / JDK 16 is the minimum except on Mac ARM64 where JDK 17 is the minimum (find at https://www.oracle.com/java/technologies/downloads / Ensure `PATH` env var includes Java bin directory for `jpackage` command to work when packaging Glimmer applications / Preferably setup `JAVA_HOME` env var too to point to JDK home directory before installing JRuby)
- [RVM](http://rvm.io) on Mac & Linux (not needed on Windows)
- JRuby 9.3.11.0 is recommended / JRuby 9.3.6.0 is the minimum (supporting Ruby 2.6.x syntax) (get via [RVM](http://rvm.io) on Mac and Linux by running `rvm install jruby-9.3.11.0`; On Windows, find at [https://www.jruby.org/download](https://www.jruby.org/download))
- SWT 4.25 (already included in the [glimmer-dsl-swt](https://rubygems.org/gems/glimmer-dsl-swt) gem). Note that SWT supports ARM64/AARCH64 on Mac and Linux since version 4.20
- Git (comes with Mac and Linux. Install on Windows: https://git-scm.com/download/win )

Glimmer might still work on other versions of Java, JRuby and SWT, but there are no guarantees, so it is best to stick to the pre-requisites outlined above.

To change the SWT version to a custom `swt.jar` version that you have, simply set the 'SWT_JAR_FILE_PATH' env var.

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
jgem install glimmer-dsl-swt -v 4.29.0.0
```

`jgem` is JRuby's version of `gem` command.
RVM allows running `gem install` directly as an alias.
Otherwise, you may also run `jruby -S gem install ...`

Afterwards, you can use `glimmer` and `girb` commands.

On the Mac, you also have to run:

```
glimmer-setup
```

This ensures configuring required Mac jruby options before using `glimmer` and `girb` commands (adding `export JRUBY_OPTS="$JRUBY_OPTS -J-XstartOnFirstThread"` to `~/.zprofile` and `~/.bash_profile`).

If you are new to Glimmer and would like to continue learning the basics, you may continue to the [Glimmer Command](#glimmer-command) section.

Otherwise, if you are ready to build a Glimmer app, you can jump to the [Glimmer Scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding) section next.

Note: if you're using activerecord or activesupport, keep in mind that Glimmer unhooks ActiveSupport::Dependencies as it does not rely on it.

### Option 2: Bundler
(Use for Manual App Creation)

Add the following to `Gemfile`:
```
gem 'glimmer-dsl-swt', '~> 4.29.0.0'
```

And, then run:
```
jruby -S bundle install
```

Note: if you're using activerecord or activesupport, keep in mind that Glimmer unhooks ActiveSupport::Dependencies as it does not rely on it.

You may learn more about other Glimmer related gems ([`glimmer-dsl-opal`](https://github.com/AndyObtiva/glimmer-dsl-opal), [`glimmer-dsl-xml`](https://github.com/AndyObtiva/glimmer-dsl-xml), and [`glimmer-dsl-css`](https://github.com/AndyObtiva/glimmer-dsl-css)) at [Multi-DSL Support](#multi-dsl-support)

## Glimmer Command

[docs/reference/GLIMMER_COMMAND.md](docs/reference/GLIMMER_COMMAND.md)

You can use the glimmer command to scaffold new apps, run apps & samples, package native executables, and list Glimmer community gems.

```
glimmer
```

```
Glimmer (JRuby Desktop Development GUI Framework) - JRuby Gem: glimmer-dsl-swt v4.29.0.0
      
Usage: glimmer [--bundler] [--pd] [--quiet] [--debug] [--log-level=VALUE] [[ENV_VAR=VALUE]...] [[-jruby-option]...] (application.rb or task[task_args]) [[application2.rb]...]

Runs Glimmer applications and tasks.

When applications are specified, they are run using JRuby,
automatically preloading the glimmer Ruby gem and SWT jar dependency.

Optionally, extra Glimmer options, JRuby options, and/or environment variables may be passed in.

Glimmer options:
- "--bundler=GROUP"   : Activates gems in Bundler default group in Gemfile
- "--pd=BOOLEAN"      : Requires puts_debuggerer to enable pd method
- "--quiet=BOOLEAN"   : Does not announce file path of Glimmer application being launched
- "--debug"           : Displays extra debugging information, passes "--debug" to JRuby, and enables debug logging
- "--log-level=VALUE" : Sets Glimmer's Ruby logger level ("ERROR" / "WARN" / "INFO" / "DEBUG"; default is none)

Tasks are run via rake. Some tasks take arguments in square brackets.

Available tasks are below (if you do not see any, please add `require 'glimmer/rake_task'` to Rakefile and rerun or run rake -T):

Select a Glimmer task to run: (Press ↑/↓ arrow to move, Enter to select and letters to filter)
  glimmer list:gems:customshape[query]                       # List Glimmer custom shape gems available at rubygems.org (query is optional) [alt: list:gems:cp]
‣ glimmer list:gems:customshell[query]                       # List Glimmer custom shell gems available at rubygems.org (query is optional) [alt: list:gems:cs]
  glimmer list:gems:customwidget[query]                      # List Glimmer custom widget gems available at rubygems.org (query is optional) [alt: list:gems:cw]
  glimmer list:gems:dsl[query]                               # List Glimmer DSL gems available at rubygems.org (query is optional)
  glimmer package[type]                                      # Package app for distribution (generating config, jar, and native files) (type is optional)
  glimmer package:clean                                      # Clean by removing "dist" and "packages" directories
  glimmer package:config                                     # Generate JAR config file
  glimmer package:gem                                        # Generate gem under pkg directory
  glimmer package:gemspec                                    # Generate gemspec
  glimmer package:jar                                        # Generate JAR file
  glimmer package:lock_jars                                  # Lock JARs
  glimmer package:native[type]                               # Generate Native files
  glimmer run[app_path]                                      # Runs Glimmer app or custom shell gem in the current directory, unless app_path is specified, then runs it instead (app_path is optional)
  glimmer samples                                            # Brings up the Glimmer Meta-Sample app to allow browsing, running, and viewing code of Glimmer samples
  glimmer scaffold[app_name]                                 # Scaffold Glimmer application directory structure to build a new app
  glimmer scaffold:customshape[name,namespace]               # Scaffold Glimmer::UI::CustomShape subclass (part of a view) under app/views (namespace is optional) [alt: scaffold:cp]
  glimmer scaffold:customshell[name,namespace]               # Scaffold Glimmer::UI::CustomShell subclass (full window view) under app/views (namespace is optional) [alt: scaffold:cs]
  glimmer scaffold:customwidget[name,namespace]              # Scaffold Glimmer::UI::CustomWidget subclass (part of a view) under app/views (namespace is optional) [alt: scaffold:cw]
  glimmer scaffold:desktopify[app_name,website]              # Desktopify a web app
  glimmer scaffold:gem:customshape[name,namespace]           # Scaffold Glimmer::UI::CustomShape subclass (part of a view) under its own Ruby gem project (namespace is required) [alt: scaffold:gem:cp]
  glimmer scaffold:gem:customshell[name,namespace]           # Scaffold Glimmer::UI::CustomShell subclass (full window view) under its own Ruby gem + app project (namespace is required) [alt: scaffold:ge...
  glimmer scaffold:gem:customwidget[name,namespace]          # Scaffold Glimmer::UI::CustomWidget subclass (part of a view) under its own Ruby gem project (namespace is required) [alt: scaffold:gem:cw]
```

Learn more at:

[docs/reference/GLIMMER_COMMAND.md](docs/reference/GLIMMER_COMMAND.md)

## Girb (Glimmer irb) Command

You can use `girb` as an alternative to `irb` when prototyping Glimmer DSL for SWT GUI DSL code.

```
girb
```

![GIRB](/images/glimmer-girb.png)

Learn more at:

[docs/reference/GLIMMER_GIRB.md](docs/reference/GLIMMER_GIRB.md)

## Glimmer GUI DSL Syntax

[docs/reference/GLIMMER_GUI_DSL_SYNTAX.md](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md)

Here is a listing of supported widgets taken from the [SWT website](https://www.eclipse.org/swt/widgets/):

[![SWT Widgets](/images/glimmer-swt-widgets.png)](https://www.eclipse.org/swt/widgets/)

In a nutshell, the Glimmer GUI DSL syntax consists mainly of:

1. Keywords

Widgets are declared with keywords denoting their name in underscored format.

Example of a keyword representing a table widget:

```ruby
table
```

Widgets may optionally receive symbol-style/args within parentheses (otherwise, when there are no style/args, the parentheses are left out).

Example of a multi-line selection table widget:

```ruby
table(:multi)
```

2. Content/Properties

Widget content is always housed within a curly-brace (`{}`) style block.

Example of a multi-line selection table widget with a table column as content that has a header `text` property as 'Name'.

```ruby
table(:multi) {
  table_column {
    text 'Name'
  }
}
```

3. Listeners

Listeners embody the [Observer Design Pattern](https://en.wikipedia.org/wiki/Observer_pattern) and always start with `on_` followed by an event name (e.g. `on_widget_selected`). Also, they are an exception to Glimmer's syntax that requires a `do; end` style block to clearly demarcate as logic as opposed to View syntax.

Example of a button widget with a `text` property and an `on_widget_selected` listener.

```ruby
button {
  text 'Click'
  
  on_widget_selected do
    message_box {
      text 'Clicked'
      message 'Thank you for clicking!'
    }.open
  end
}
```

4. Methods

Widgets have methods that invoke operations on them. Sometimes, they are required to be called in order to display the widgets (like the `open` method on `shell` and `message_box`)

Example of a shell with a `text` property and an invoked `open` method operation.

```ruby
shell {
  text 'Hello, World!'
}.open
```

If you need more widgets, you can check out the [Nebula Project](https://github.com/AndyObtiva/glimmer-cw-nebula) (50+ enterprise-grade custom widgets)

Learn more at:

[docs/reference/GLIMMER_GUI_DSL_SYNTAX.md](docs/reference/GLIMMER_GUI_DSL_SYNTAX.md)

## Glimmer Configuration

Glimmer configuration may be done via the `Glimmer::Config` module.

Learn more at:

[docs/reference/GLIMMER_CONFIGURATION.md](docs/reference/GLIMMER_CONFIGURATION.md)

## Glimmer Style Guide

[docs/reference/GLIMMER_STYLE_GUIDE.md](docs/reference/GLIMMER_STYLE_GUIDE.md)

## Samples

See a listing of samples including screenshots and explanations at:

[docs/reference/GLIMMER_SAMPLES.md](/docs/reference/GLIMMER_SAMPLES.md)

Check the [samples](/docs/reference/GLIMMER_SAMPLES.md) directory in [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) for examples on how to write Glimmer applications. To run a sample, make sure to install the `glimmer-dsl-swt` gem first and then run:
```
glimmer samples
```
 
(alternatively, you may clone the repo, follow [CONTRIBUTING.md](CONTRIBUTING.md) instructions, and run samples locally with development glimmer command: `bin/glimmer`)

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

## In Production

The following production apps have been built with Glimmer.

If you have a Glimmer app you would like referenced here, please mention in a Pull Request.

### Math Bowling

[<img alt="Math Bowling Logo" src="https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/math-bowling-logo.png" width="40" />Math Bowling](https://github.com/AndyObtiva/MathBowling): an educational math game for elementary level kids

[![Math Bowling App Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/Math-Bowling-Screenshot.png)](https://github.com/AndyObtiva/MathBowling)

### Gladiator

[<img src='https://raw.githubusercontent.com/AndyObtiva/glimmer-cs-gladiator/master/images/glimmer-cs-gladiator-logo.png' height=40 /> Gladiator](https://github.com/AndyObtiva/glimmer-cs-gladiator) (short for Glimmer Editor) is a code editor built with Ruby.

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

### Are We There Yet?

[<img alt="Are We There Yet Logo" src="https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-logo.svg" width="40" />Are We There Yet?](https://github.com/AndyObtiva/are-we-there-yet): A tool that helps you learn when your small projects will finish

[![Are We There Yet? App Screenshot](https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-screenshot-windows.png)](https://github.com/AndyObtiva/are-we-there-yet)

This [Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) application connects to a [SQLite](https://www.sqlite.org/index.html) database using [ActiveRecord](https://rubygems.org/gems/activerecord).

### Garderie Rainbow Daily Agenda

[<img alt="Garderie Rainbow Daily Agenda Logo" src="https://github.com/AndyObtiva/garderie_rainbow_daily_agenda/raw/master/images/garderie_rainbow_daily_agenda_logo.png" width="40" />Garderie Rainbow Daily Agenda](https://github.com/AndyObtiva/garderie_rainbow_daily_agenda): A child nursery daily agenda reporting desktop app

[![Garderie Rainbow Daily Agenda App Screenshot](https://github.com/AndyObtiva/garderie_rainbow_daily_agenda/raw/master/images/garderie_rainbow_daily_agenda_screenshot.png)](https://github.com/AndyObtiva/garderie_rainbow_daily_agenda)

This [Glimmer DSL for SWT](https://rubygems.org/gems/glimmer-dsl-swt) application connects to a [Rails](https://rubyonrails.org/) server to submit a nursery child daily agenda via a REST API, storing data in [PostgreSQL](https://www.postgresql.org/).

### Glimmer Gab

[<img alt="Glimmer Gab Logo" src="https://raw.githubusercontent.com/AndyObtiva/glimmer_gab/master/package/linux/Glimmer%20Gab.png" height=40 /> Glimmer Gab](https://github.com/AndyObtiva/glimmer_gab): Desktop App for Gab.com

[![Glimmer Gab App Screenshot](https://github.com/AndyObtiva/glimmer_gab/raw/master/screenshots/glimmer-gab-mac.png)](https://github.com/AndyObtiva/glimmer_gab)

### Connector

[<img alt="Connector Logo" src="https://raw.githubusercontent.com/AndyObtiva/connector/master/package/linux/Connector.png" height=40 /> Connector](https://github.com/AndyObtiva/connector): A minimalist open-source multi-engine web browser

[![Connector App Screenshot](https://github.com/AndyObtiva/connector/raw/master/images/connector-mac.png)](https://github.com/AndyObtiva/connector)

### The DCR Programming Language

[<img alt="Connector Logo" src="https://raw.githubusercontent.com/AndyObtiva/dcr/f31cd45a8503051e899ed8e831fd03654d38e418/package/linux/Draw%20Color%20Repeat.png" height=40 /> Draw Color Repeat](https://github.com/AndyObtiva/dcr): A young boy programming language for Drawing and Coloring with Repetition

[![DCR App Screenshot](https://github.com/AndyObtiva/dcr/raw/master/images/dcr-screenshot.png)](https://github.com/AndyObtiva/dcr)

### Befunge 98 Programming Language

[Befunge 98 GUI](https://github.com/AndyObtiva/befunge98/tree/gui)

[![Befunge 98 App Screenshot](https://github.com/AndyObtiva/befunge98/raw/gui/gui/glimmer-dsl-swt/befunge98_gui_glimmer_dsl_swt/screenshots/befunge98_gui_glimmer_dsl_swt_example_output.png)](https://github.com/AndyObtiva/befunge98/tree/gui)

### Glimmer Klondike Solitaire

[<img alt="Glimmer Klondike Solitaire Icon" src="https://raw.githubusercontent.com/AndyObtiva/glimmer_klondike_solitaire/master/icons/linux/Glimmer%20Klondike%20Solitaire.png" height=40 /> Glimmer Klondike Solitaire](https://github.com/AndyObtiva/glimmer_klondike_solitaire)

[![Glimmer Klondike Solitaire App Screenshot](https://github.com/AndyObtiva/glimmer_klondike_solitaire/raw/master/images/glimmer-klondike-solitaire.png)](https://github.com/AndyObtiva/glimmer_klondike_solitaire)

### Glimmer Metronome

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer_metronome/master/icons/linux/Glimmer%20Metronome.png" height=40 /> Glimmer Metronome](https://github.com/AndyObtiva/glimmer_metronome)

[![Glimmer Metronome App Screenshot](https://raw.githubusercontent.com/AndyObtiva/glimmer_metronome/master/screenshots/glimmer-metronome.gif)](https://github.com/AndyObtiva/glimmer_metronome)

### Glimmer Wordle

[<img src='https://raw.githubusercontent.com/AndyObtiva/glimmer_wordle/master/icons/linux/Glimmer Wordle.png' height=40 /> Glimmer Wordle - Word Game](https://github.com/AndyObtiva/glimmer_wordle)

[![Glimmer Wordle App Screenshot](https://github.com/AndyObtiva/glimmer_wordle/raw/master/screenshots/glimmer-wordle.png)](https://github.com/AndyObtiva/glimmer_wordle)

## Packaging & Distribution

Glimmer simplifies the process of native-executable packaging and distribution on Mac and Windows via a single command:

```
glimmer package
```

Learn more at: [docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md](docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md)

## App Updates

Glimmer should have support for automatic (and manual) app updates via the Mac App Store on the Mac (not tested yet, so contributor help is appreciated). Getting on the App Store requires running the `glimmer package` command with the Mac App Store keys configured as per the [Mac Application Distribution](mac-application-distribution) instructions.

## Glimmer Supporting Libraries

Here is a list of notable 3rd party gems used by Glimmer:
- [juwelier](https://rubygems.org/gems/juwelier): generates app gems during [Glimmer Scaffolding](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/docs/reference/GLIMMER_COMMAND.md#scaffolding)
- [logging](https://github.com/TwP/logging): provides extra logging capabilities not available in Ruby Logger such as multi-threaded buffered asynchronous logging (to avoid affecting app performance) and support for multiple appenders such as stdout, syslog, and log files (the last one is needed on Windows where syslog is not supported)
- [nested_inherited_jruby_include_package](https://github.com/AndyObtiva/nested_inherited_jruby_include_package): makes included [SWT](https://www.eclipse.org/swt/)/[Java](https://www.java.com/en/) packages available to all classes/modules that mix in the Glimmer module without having to manually reimport
- [os](https://github.com/rdp/os): provides OS detection capabilities (e.g. `OS.mac?` or `OS.windows?`) to write cross-platform code inexpensively
- [puts_debuggerer](https://github.com/AndyObtiva/puts_debuggerer): helps in troubleshooting when adding `require 'pd'` and using the `pd` command instead of `puts` or `p` (also `#pd_inspect` or `#pdi` instead of `#inspect`)
- [rake](https://github.com/ruby/rake): used to implement and execute `glimmer` commands
- [rake-tui](https://github.com/AndyObtiva/rake-tui): Rake Text-based User Interface. Allows navigating rake tasks with arrow keys and filtering task list by typing to quickly find an run a rake task.
- [rouge](https://github.com/rouge-ruby/rouge): Ruby syntax highlighter used in the `code_text` [Glimmer DSL for SWT custom widget](#custom-widgets) leveraged by the [Glimmer Meta-Sample](/docs/reference/GLIMMER_SAMPLES.md#samples)
- [super_module](https://github.com/AndyObtiva/super_module): used to cleanly write the Glimmer::UI:CustomWidget and Glimmer::UI::CustomShell modules
- [text-table](https://github.com/aptinio/text-table): renders textual data in a textual table for the command-line interface of Glimmer
- [warbler](https://github.com/jruby/warbler): converts a Glimmer app into a Java JAR file during packaging

## Glimmer Process

[Glimmer Process](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) is the lightweight software development process used for building Glimmer libraries and Glimmer apps, which goes beyond Agile, rendering all Agile processes obsolete. [Glimmer Process](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) is simply made up of 7 guidelines to pick and choose as necessary until software development needs are satisfied.

Learn more by reading the [GPG](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md) (Glimmer Process Guidelines)

## Resources

* [Glimmer DSL for SWT Video Tutorials](https://andymaleh.blogspot.com/search/label/Tutorial+SWT) ([Video Tutorial Playlist](https://www.youtube.com/watch?v=Mi5phsSdNAA&list=PLSN9HhZ_0-n741vRa_dL-M81cLbqD_kem) and [Video Tutorial Channel](https://www.youtube.com/channel/UC5hzDE23HZXsZLAxYk2UJEw))
* [Code Master Blog](http://andymaleh.blogspot.com/search/label/Glimmer)
* [JRuby Cookbook by Justin Edelson & Henry Liu](http://shop.oreilly.com/product/9780596519650.do)
* [InfoQ Article](http://www.infoq.com/news/2008/02/glimmer-jruby-swt)
* [DZone Tutorial](https://dzone.com/articles/an-introduction-glimmer)
* [MountainWest RubyConf 2011 Video](https://confreaks.tv/videos/mwrc2011-whatever-happened-to-desktop-development-in-ruby)
* [RubyConf 2008 Video](https://confreaks.tv/videos/rubyconf2008-desktop-development-with-glimmer)

### SWT Reference

https://www.eclipse.org/swt/docs.php

Here is the SWT Javadoc API:

https://www.eclipse.org/swt/javadoc.php

Here is a visual list of SWT widgets:

https://www.eclipse.org/swt/widgets/

Here is a textual list of SWT widgets:

https://help.eclipse.org/2019-12/topic/org.eclipse.platform.doc.isv/guide/swt_widgets_controls.htm?cp=2_0_7_0_0

Here is a list of SWT style bits as used in widget declaration:

https://wiki.eclipse.org/SWT_Widget_Style_Bits

Here is a SWT style bit constant reference:

https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/SWT.html

Here is an SWT Layout guide:

https://www.eclipse.org/articles/Article-Understanding-Layouts/Understanding-Layouts.htm

Here is an SWT Custom Widget guide:

https://www.eclipse.org/articles/Article-Writing%20Your%20Own%20Widget/Writing%20Your%20Own%20Widget.htm

Here is an SWT Drag and Drop guide:

https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html

Here is an SWT Graphics / Canvas-Drawing guide:

https://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html

Here is an SWT Image guide:

https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html

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
* [Dennis Theisen](https://github.com/Soleone) (Contributor, originally in [Glimmer](https://github.com/AndyObtiva/glimmer/graphs/contributors) before splitting [glimmer-dsl-swt](https://rubygems.org/gems/glimmer))
* [Wayne Vucenic](https://github.com/rubycoder)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer-dsl-swt/graphs/contributors)

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2023 - Andy Maleh.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built for [Glimmer](https://github.com/AndyObtiva/glimmer) (DSL Framework).

Glimmer logo was made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](http://www.flaticon.com)
