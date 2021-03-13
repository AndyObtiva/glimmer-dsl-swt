## Glimmer Command

The `glimmer` command allows you to run, scaffold, package, and list Glimmer applications/gems.

You can bring up usage instructions by running the `glimmer` command without arguments:

```
glimmer
```

On Mac and Linux, it additionally brings up a TUI (Text-based User Interface) for interactive navigation and execution of Glimmer tasks (courtesy of [rake-tui](https://github.com/AndyObtiva/rake-tui)).

On Windows, it simply lists the available Glimmer tasks at the end (courtsey of [rake](https://github.com/ruby/rake)).

If you are new to Glimmer, you may read the Basic Usage section and skip the rest until you have gone through [Girb (Glimmer irb) Command](#girb-glimmer-irb-command), [Glimmer GUI DSL Syntax](#glimmer-gui-dsl-syntax), and [Samples](#samples).

Note: If you encounter an issue running the `glimmer` command, run `bundle exec glimmer` instead.

### Basic Usage

```
glimmer application.rb
```

Runs a Glimmer application using JRuby, automatically preloading
the glimmer ruby gem and SWT jar dependency.

Run Glimmer samples with:

```
glimmer samples
```
This brings up the [Glimmer Meta-Sample (The Sample of Samples)](#samples)

If you cloned this project locally instead of installing the gem, run `bin/glimmer` instead.

Example:
```
bin/glimmer samples
```

### Advanced Usage

Below are the full usage instructions that come up when running `glimmer` without args.

```
Glimmer (JRuby Desktop Development GUI Framework) - JRuby Gem: glimmer-dsl-swt v4.18.7.4
      
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

Example (Glimmer/JRuby option specified):
```
glimmer --debug samples/hello/hello_world.rb
```

Runs Glimmer application with JRuby debug option to enable JRuby debugging.

Example (Multiple apps):
```
glimmer samples/hello/hello_world.rb samples/hello/hello_tab.rb
```

Launches samples/hello/hello_world.rb and samples/hello_tab.rb at the same time, each in a separate JRuby thread.

Note: under Zsh (Z Shell), glimmer can only be used in its advanced TUI mode (e.g. `glimmer` and then selecting a task) not the primitive rake task mode (e.g. `glimmer scaffold[app]`)

### Glimmer Samples

You can list available Glimmer samples by running:

```
glimmer samples
```

This brings up the [Glimmer Meta-Sample (The Sample of Samples)](#samples):

![Glimmer Meta-Sample](/images/glimmer-meta-sample.png)

### Scaffolding

Glimmer borrows from Rails the idea of Scaffolding, that is generating a structure for your app files that
helps you get started just like true building scaffolding helps construction workers, civil engineers, and architects.

Glimmer scaffolding goes beyond just scaffolding the app files that Rails does. It also packages it and launches it,
getting you to a running and delivered state of an advanced "Hello, World!" Glimmer application right off the bat.

This should greatly facilitate building a new Glimmer app by helping you be productive and focus on app details while
letting Glimmer scaffolding take care of initial app file structure concerns, such as adding:
- Main application class that includes Glimmer (`app/{app_name}.rb`)
- Main application view that houses main window content, menu, about dialog, and preferences dialog
- View and Model directories (`app/views` and `app/models`)
- Rakefile including Glimmer tasks (`Rakefile`)
- Version (`VERSION`)
- License (`LICENSE.txt`)
- Icon (under `package/{platform}/{App Name}.{icon_extension}` for `macosx` .icns, `windows` .ico, and `linux` .png)
- Bin file for starting application (`bin/{app_name}.rb`)

You need to have your Git `user.name` and `github.user` configured before scaffolding since Glimmer uses Juwelier, which relies on them in creating a Git repo for your Glimmer app.

#### App

Before you start, make sure you are in a JRuby environment with Glimmer gem installed as per "Direct Install" pre-requisites.

To scaffold a Glimmer app from scratch, run the following command:

```
glimmer scaffold[AppName]
```

This will generate an advanced "Hello, World!" app, package it as a Mac DMG/PKG/APP, Windows APP, or Linux GEM, and launch it all in one fell swoop.

Suppose you run:

```
glimmer scaffold[greeter]
```

You should see output like the following:

```
$ glimmer scaffold[greeter]
  create  .gitignore
  create  Rakefile
  create  Gemfile
  create  LICENSE.txt
  create  README.rdoc
  create  .document
  create  lib
  create  lib/greeter.rb
  create  spec
  create  spec/spec_helper.rb
  create  spec/greeter_spec.rb
  create  .rspec
Juwelier has prepared your gem in ./greeter
Created greeter/.gitignore
Created greeter/.ruby-version
Created greeter/.ruby-gemset
Created greeter/VERSION
Created greeter/LICENSE.txt
Created greeter/Gemfile
Created greeter/Rakefile
Created greeter/app/greeter.rb
Created greeter/app/views/greeter/app_view.rb
Created greeter/package/windows/Greeter.ico
Created greeter/package/macosx/Greeter.icns
Created greeter/package/linux/Greeter.png
Created greeter/bin/greeter
Created greeter/spec/spec_helper.rb
...
```

Eventually, it will launch an advanced "Hello, World!" app window having the title of your application ("Greeter").

![Glimmer Scaffold App](/images/glimmer-scaffolding-app.png)

It also comes with a boilerplate Preferences dialog.

![Glimmer Scaffold App Preferences](/images/glimmer-scaffolding-app-preferences.png)

Here is the Windows version of the scaffolded "Greeter" app:

![Glimmer Scaffold App Windows](/images/glimmer-scaffolding-app-windows.png)

And, here is the Windows version of the boilerplate Preferences dialog.

![Glimmer Scaffold App Windows Preferences](/images/glimmer-scaffolding-app-windows-preferences.png)

In order to run the app after making changes, you must run the `glimmer run`. It automatically detects the generated run script under the `bin` directory and uses it as an argument.

```
glimmer run
```

Alternatively, to mantually run the app, you may type:

```
glimmer run[bin/greeter]
```

or:

```
glimmer bin/greeter
```

#### Desktopify

Desktopify basically turns a website into a desktop application by wrapping the website within a [Browser Widget](#browser-widget).

The desktopify app is similar to the standard scaffolded app. It can be extended and the [browser may even be instrumented](https://help.eclipse.org/2020-09/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/browser/Browser.html).

The app even remembers your cookies if you log into the website, close the app, and reopen again.

Note that on Linux, the default SWT browser, which runs on webkit, does not support HTML5 Video out of the box. If you need video support, open `Gemfile` after scaffolding and enable the line that has the `glimmer-cw-browser-chromium` gem then replace the `browser` in "app/views/snowboard_utah/app_view.rb" with `browser(:chromium)`

Before you start, make sure you are in a JRuby environment with Glimmer gem installed as per "Direct Install" pre-requisites.

To scaffold a Glimmer desktopify app from scratch, run the following command:

```
glimmer scaffold:desktopify[app_name,website]
```

This will generate a Glimmer app, package it as a Mac DMG/PKG/APP, Windows APP, or Linux GEM, and launch it all in one fell swoop.

Suppose you run:

```
glimmer scaffold:desktopify[snowboard_utah,https://www.brightonresort.com]
```

You should see output like the following:

```
$ glimmer scaffold:desktopify[snowboard_utah,https://www.brightonresort.com]
Fetching kamelcase-0.0.2.gem
Fetching github_api-0.19.0.gem
Fetching highline-2.0.3.gem
Fetching juwelier-2.4.9.gem
Fetching hashie-3.6.0.gem
Fetching nokogiri-1.10.10-java.gem
Fetching semver2-3.4.2.gem
Successfully installed semver2-3.4.2
Successfully installed kamelcase-0.0.2
Successfully installed highline-2.0.3
Successfully installed hashie-3.6.0
Successfully installed github_api-0.19.0
Successfully installed nokogiri-1.10.10-java
Successfully installed juwelier-2.4.9
7 gems installed
  create  .gitignore
  create  Rakefile
  create  Gemfile
  create  LICENSE.txt
  create  README.markdown
  create  .document
  create  lib
  create  lib/snowboard_utah.rb
  create  .rspec
Juwelier has prepared your gem in ./snowboard_utah
Created snowboard_utah/.gitignore
Created snowboard_utah/.ruby-version
Created snowboard_utah/.ruby-gemset
Created snowboard_utah/VERSION
Created snowboard_utah/LICENSE.txt
Created snowboard_utah/Gemfile
Created snowboard_utah/Rakefile
Created snowboard_utah/app/snowboard_utah.rb
Created snowboard_utah/app/views/snowboard_utah/app_view.rb
Created snowboard_utah/package/windows/Snowboard Utah.ico
Created snowboard_utah/package/macosx/Snowboard Utah.icns
Created snowboard_utah/package/linux/Snowboard Utah.png
Created snowboard_utah/bin/snowboard_utah
...
```

Eventually, it will launch a desktopified version of "https://www.brightonresort.com" having the title of ("Snowboard Utah").

Desktopified App on Mac

![Glimmer Scaffold App](/images/glimmer-scaffolding-desktopify.png)

It also comes with a boilerplate About dialog.

![Glimmer Scaffold App About](/images/glimmer-scaffolding-desktopify-about.png)

Desktopified App on Windows

![Glimmer Scaffold App](/images/glimmer-scaffolding-desktopify-windows.png)

Desktopified App on Linux

![Glimmer Scaffold App](/images/glimmer-scaffolding-desktopify-linux.png)

In order to run the app after making changes, you must run the `glimmer run`. It automatically detects the generated run script under the `bin` directory and uses it as an argument.

```
glimmer run
```

#### Custom Shell

To scaffold a Glimmer [custom shell](#custom-shells) (full window view) for an existing Glimmer app, run the following command:

```
glimmer scaffold:customshell[name]
```

Or the following alternative abbreviation:

```
glimmer scaffold:cs[name]
```

#### Custom Widget

To scaffold a Glimmer [custom widget](GLIMMER_GUI_DSL_SYNTAX.md#custom-widgets) (part of a view) for an existing Glimmer app, run the following command:

```
glimmer scaffold:customwidget[name]
```

Or the following alternative abbreviation:

```
glimmer scaffold:cw[name]
```

#### Custom Shape

To scaffold a Glimmer [custom shape](GLIMMER_GUI_DSL_SYNTAX.md#custom-shapes) (a composite or customized shape) for an existing Glimmer app, run the following command:

```
glimmer scaffold:customshape[name]
```

Or the following alternative abbreviation:

```
glimmer scaffold:cp[name]
```

#### Custom Shell Gem

Custom shell gems are self-contained Glimmer apps as well as reusable [custom shells](#custom-shells).
They have everything scaffolded Glimmer apps come with in addition to gem content like a [Juwelier](https://rubygems.org/gems/juwelier) Rakefile that can build gemspec and release gems.
Unlike scaffolded Glimmer apps, custom shell gem content lives under the `lib` directory (not `app`).
They can be packaged as both a native executable (e.g. Mac DMG/PKG/APP) and a Ruby gem.
Of course, you can just build a Ruby gem and disregard native executable packaging if you do not need it.

To scaffold a Glimmer custom shell gem (full window view distributed as a Ruby gem), run the following command:

```
glimmer scaffold:gem:customshell[name,namespace]
```

Or the following alternative abbreviation:

```
glimmer scaffold:gem:cs[name,namespace]
```

It is important to specify a namespace to avoid having your gem clash with existing gems.

The Ruby gem name will follow the convention "glimmer-cs-customwidgetname-namespace" (the 'cs' is for Custom Shell).

Only official Glimmer gems created by the Glimmer project committers will have no namespace (e.g. [glimmer-cs-gladiator](https://rubygems.org/gems/glimmer-cs-gladiator) Ruby gem)

Since custom shell gems are both an app and a gem, they provide two ways to run:
- Run the `glimmer` command and pass it the generated script under the `bin` directory that matches the gem name (e.g. run `glimmer bin/glimmer-cs-calculator`)
- Run the executable shell script that ships with the gem directly (does not need the `glimmer` command). It intentionally has a shorter name for convenience since it is meant to be used on the command line (not in a package), so you can leave out the `glimmer-cs-` prefix (e.g. run `bin/calculator` directly). This is also used as the main way of running custom shell gems on Linux.

Examples:

- [glimmer-cs-gladiator](https://github.com/AndyObtiva/glimmer-cs-gladiator): Gladiator (Glimmer Editor)
- [glimmer-cs-calculator](https://github.com/AndyObtiva/glimmer-cs-calculator): Glimmer Calculator

#### Custom Widget Gem

To scaffold a Glimmer [custom widget](GLIMMER_GUI_DSL_SYNTAX.md#custom-widgets) gem (part of a view distributed as a Ruby gem), run the following command:

```
glimmer scaffold:gem:customwidget[name,namespace]
```

Or the following alternative abbreviation:

```
glimmer scaffold:gem:cw[name,namespace]
```


It is important to specify a namespace to avoid having your gem clash with existing gems.

The Ruby gem name will follow the convention "glimmer-cw-customwidgetname-namespace" (the 'cw' is for Custom Widget; name words are not separated)

Only official Glimmer gems created by the Glimmer project committers will have no namespace (e.g. [glimmer-cw-video](https://rubygems.org/gems/glimmer-cw-video) Ruby gem)

Examples:

- [glimmer-cw-video](https://github.com/AndyObtiva/glimmer-cw-video): Video Widget
- [glimmer-cw-nebula](https://github.com/AndyObtiva/glimmer-cw-nebula): The Nebula Project 50+ enterprise-grade high quality custom widgets for SWT
- [glimmer-cw-cdatetime-nebula](https://github.com/AndyObtiva/glimmer-cw-cdatetime-nebula): Nebula CDateTime Widget (piecemeal)

#### Custom Shape Gem

To scaffold a Glimmer [custom shape](GLIMMER_GUI_DSL_SYNTAX.md#custom-shapes) gem (part of a view distributed as a Ruby gem), run the following command:

```
glimmer scaffold:gem:customshape[name,namespace]
```

Or the following alternative abbreviation:

```
glimmer scaffold:gem:cp[name,namespace]
```


It is important to specify a namespace to avoid having your gem clash with existing gems.

The Ruby gem name will follow the convention "glimmer-cp-customshapename-namespace" (the 'cp' is for Custom Shape; name words are not separated)

Only official Glimmer gems created by the Glimmer project committers will have no namespace (e.g. [glimmer-cp-bevel](https://rubygems.org/gems/glimmer-cp-bevel) Ruby gem)

Examples:

- [glimmer-cp-bevel](https://github.com/AndyObtiva/glimmer-cp-bevel): Bevel

### Gem Listing

The `glimmer` command comes with tasks for listing Glimmer related gems to make it easy to find Glimmer [Custom Shells](#custom-shells), [Custom Widgets](#custom-widgets), and DSLs published by others in the Glimmer community on [rubygems.org](http://www.rubygems.org).

#### Listing Custom Shell Gems

The following command lists available Glimmer [Custom Shell Gems](#custom-shell-gem) (prefixed with "glimmer-cs-" by scaffolding convention) created by the the Glimmer community and published on [rubygems.org](http://www.rubygems.org):

```
glimmer list:gems:customshell[query]
```

Or the following alternative abbreviation:

```
glimmer list:gems:cs[query]
```

Example:

```
glimmer list:gems:cs
```

Output:

```

  Glimmer Custom Shell Gems at rubygems.org:
                                                                                                                 
     Name               Gem            Version     Author                        Description
                                                                                                                 
  Calculator   glimmer-cs-calculator   1.0.2     Andy Maleh   Calculator - Glimmer Custom Shell
  Gladiator    glimmer-cs-gladiator    0.2.4     Andy Maleh   Gladiator (Glimmer Editor) - Glimmer Custom Shell
  Timer        glimmer-cs-timer        1.0.0     Andy Maleh   Timer - Glimmer Custom Shell
                                                                                                                 
```

#### Listing Custom Widget Gems

The following command lists available Glimmer [Custom Widget Gems](#custom-widget-gem) (prefixed with "glimmer-cw-" by scaffolding convention) created by the the Glimmer community and published on [rubygems.org](http://www.rubygems.org):

```
glimmer list:gems:customwidget[query]
```

Or the following alternative abbreviation:

```
glimmer list:gems:cw[query]
```

Example:

Check if there is a custom video widget for Glimmer.

```
glimmer list:gems:cw[video]
```

Output:

```

  Glimmer Custom Widget Gems matching [video] at rubygems.org:
                                                                                   
  Name          Gem          Version     Author              Description
                                                                                   
  Video   glimmer-cw-video   1.0.0     Andy Maleh   Glimmer Custom Widget - Video
                                                                                   
```

Example:

Check all custom widgets for Glimmer.

```
glimmer list:gems:cw
```

Output:

```

  Glimmer Custom Widget Gems at rubygems.org:
                                                                                                                                
         Name                      Gem                Version      Author                       Description
                                                                                                                                
  Browser (Chromium)   glimmer-cw-browser-chromium   1.0.0       Andy Maleh   Chromium Browser - Glimmer Custom Widget
  Cdatetime (Nebula)   glimmer-cw-cdatetime-nebula   1.5.0.0.1   Andy Maleh   Nebula CDateTime Widget - Glimmer Custom Widget
  Video                glimmer-cw-video              1.0.0       Andy Maleh   Glimmer Custom Widget - Video
  
```

#### Listing Custom Shape Gems

The following command lists available Glimmer [Custom Shape Gems](#custom-shape-gem) (prefixed with "glimmer-cp-" by scaffolding convention) created by the the Glimmer community and published on [rubygems.org](http://www.rubygems.org):

```
glimmer list:gems:customshape[query]
```

Or the following alternative abbreviation:

```
glimmer list:gems:cp[query]
```

Example:

```
glimmer list:gems:customshape
```

Output:

```

  Glimmer Custom Shape Gems at rubygems.org:
                                                                                                     
     Name                Gem             Version     Author                 Description              
                                                                                                     
  Bevel         glimmer-cp-bevel         0.1.1     Andy Maleh   Bevel - Glimmer Custom Shape         
  Stickfigure   glimmer-cp-stickfigure   0.1.1     Andy Maleh   Stick Figure - Glimmer Custom Shape  
  
```

#### Listing DSL Gems

The following command lists available Glimmer [DSL Gems](#multi-dsl-support) (prefixed with "glimmer-dsl-" by convention) created by the the Glimmer community and published on [rubygems.org](http://www.rubygems.org):

```
glimmer list:gems:dsl[query]
```

Example:

```
glimmer list:gems:dsl
```

Output:

```

  Glimmer DSL Gems at rubygems.org:
                                                                         
  Name         Gem          Version    Author          Description
                                                                         
  Css    glimmer-dsl-css    1.1.0     AndyMaleh    Glimmer DSL for CSS
  Opal   glimmer-dsl-opal   0.10.2     AndyMaleh    Glimmer DSL for Opal
  Swt    glimmer-dsl-swt    4.18.4.4  AndyMaleh    Glimmer DSL for SWT
  Tk     glimmer-dsl-tk     0.0.6     AndyMaleh    Glimmer DSL for Tk
  Xml    glimmer-dsl-xml    1.1.0     AndyMaleh    Glimmer DSL for XML
```

### Packaging

Glimmer supports packaging applications as native files on Mac and Windows.

Glimmer packaging tasks are detailed under [Packaging & Distribution](/docs/reference/GLIMMER_PACKAGING_AND_DISTRIBUTION.md).

On Linux, the Glimmer [App](#app) and [Custom Shell Gem](#custom-shell-gem) scaffolding options provide a Gem Packaged Shell Script (e.g. `calculator` command becomes available after installing the [glimmer-cs-calculator](https://github.com/AndyObtiva/glimmer-cs-calculator) gem)

You may run `glimmer package:gem` to generate gem or just rely on the included [Juwelier](https://rubygems.org/gems/juwelier) `rake release` task to release the gem.

### Raw JRuby Command

If there is a need to run Glimmer directly via the `jruby` command, you
may run the following on Windows/Linux:

```
jruby -r glimmer-dsl-swt -S application.rb
```

Or, the following on Mac:

```
jruby -J-XstartOnFirstThread -r glimmer-dsl-swt -S application.rb
```

If you want to use a specific custom version of SWT, run the following on Windows/Linux:

```
jruby -J-classpath "path_to/swt.jar" -r glimmer-dsl-swt -S application.rb
```

Or, the following on Mac:

```
jruby -J-XstartOnFirstThread -J-classpath "path_to/swt.jar" -r glimmer-dsl-swt -S application.rb
```

The `-J-classpath` option specifies the `swt.jar` file path, which can be a
manually downloaded version of SWT, or otherwise the one included in the gem. You can lookup the one included in the gem by running `jgem which glimmer` to find the gem path and then look through the `vendor` directory.

The `-r` option preloads (requires) the `glimmer` library in Ruby.

The `-S` option specifies a script to run.

#### Mac Support

The Mac is well supported with the `glimmer` command. The advice below is not needed if you are using it.

However, if there is a reason to use the raw `jruby` command directly instead of the `glimmer` command, you need to pass an extra option (`-J-XstartOnFirstThread`) to JRuby on the Mac (Glimmer automatically passes it for you when using the `glimmer` command).

Example:
```
jruby -J-XstartOnFirstThread -J-classpath "path_to/swt.jar" -r glimmer-dsl-swt -S application.rb
```

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2021 - Andy Maleh.
