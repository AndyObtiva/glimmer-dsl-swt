## Glimmer Configuration

Glimmer configuration may be done via the `Glimmer::Config` module.

### logger

The Glimmer DSL engine supports logging via a standard `STDOUT` Ruby `Logger` configured in the `Glimmer::Config.logger` config option.
It is set to level Logger::ERROR by default.
Log level may be adjusted via `Glimmer::Config.logger.level` just like any other Ruby Logger.

Example:

```ruby
Glimmer::Config.logger.level = :debug
```
This results in more verbose debug logging to `STDOUT`, which is very helpful in troubleshooting Glimmer DSL syntax when needed.

Example log:
```
D, [2017-07-21T19:23:12.587870 #35707] DEBUG -- : method: shell and args: []
D, [2017-07-21T19:23:12.594405 #35707] DEBUG -- : ShellCommandHandler will handle command: shell with arguments []
D, [2017-07-21T19:23:12.844775 #35707] DEBUG -- : method: composite and args: []
D, [2017-07-21T19:23:12.845388 #35707] DEBUG -- : parent is a widget: true
D, [2017-07-21T19:23:12.845833 #35707] DEBUG -- : on listener?: false
D, [2017-07-21T19:23:12.864395 #35707] DEBUG -- : WidgetCommandHandler will handle command: composite with arguments []
D, [2017-07-21T19:23:12.864893 #35707] DEBUG -- : widget styles are: []
D, [2017-07-21T19:23:12.874296 #35707] DEBUG -- : method: list and args: [:multi]
D, [2017-07-21T19:23:12.874969 #35707] DEBUG -- : parent is a widget: true
D, [2017-07-21T19:23:12.875452 #35707] DEBUG -- : on listener?: false
D, [2017-07-21T19:23:12.878434 #35707] DEBUG -- : WidgetCommandHandler will handle command: list with arguments [:multi]
D, [2017-07-21T19:23:12.878798 #35707] DEBUG -- : widget styles are: [:multi]
```

The `logger` instance may be replaced with a custom logger via `Glimmer::Config.logger = custom_logger`

To reset `logger` to the default instance, you may call `Glimmer::Config.reset_logger!`

All logging is done lazily via blocks (e.g. `logger.debug {message}`) to avoid affecting app performance with logging when below the configured logging level threshold.

Optionally, [Glimmer DSL for SWT](https://github.com/AndyObtiva/glimmer-dsl-swt) enhances Glimmer default logging support via the Ruby [`logging`](https://github.com/TwP/logging) gem, enabling buffered asynchronous logging in a separate thread, thus completely unhindering normal desktop app performance.

You can alternatively use the [logging](https://github.com/TwP/logging) gem for asynchronous logging (note that it adds about 0.5 - 1.0 second to startup time) by adding the gem:
```ruby
gem 'logging', '>= 2.3.0', '< 3.0.0'
```

And, updating the logger type:
```ruby
require 'logging'
Glimmer::Config.logger_type = :logging
```

Other config options related to the [logging](https://github.com/TwP/logging) gem are mentioned below.

#### logging_devices

This is an array of these possible values: `:stdout` (default), `:stderr`, `:file`, `:syslog` (default), `:stringio`

It defaults to `[:stdout, :syslog]`

When `:file` is included, Glimmer creates a 'log' directory directly below the Glimmer app local directory.
It may also be customized further via the `logging_device_file_options` option.
This is useful on Windows as an alternative to `syslog`, which is not available on Windows by default.

#### logging_device_file_options

This is a hash of [`logging`](https://github.com/TwP/logging) gem options for the `:file` logging device.

Default: `{size: 1_000_000, age: 'daily', roll_by: 'number'}`

That ensures splitting log files at the 1MB size and daily, rolling them by unique number.

#### logging_appender_options

Appender options is a hash passed as options to every appender (logging device) used in the [`logging`](https://github.com/TwP/logging) gem.

Default: `{async: true, auto_flushing: 500, write_size: 500, flush_period: 60, immediate_at: [:error, :fatal], layout: logging_layout}`

That ensures asynchronous buffered logging that is flushed every 500 messages and 60 seconds, or immediately at error and fatal log levels

#### logging_layout

This is a [`logging`](https://github.com/TwP/logging) gem layout that formats the logging output.

Default:

```
Logging.layouts.pattern(
  pattern: '[%d] %-5l %c: %m\n',
  date_pattern: '%Y-%m-%d %H:%M:%S'
)
```

### import_swt_packages

Glimmer automatically imports all SWT Java packages upon adding `include Glimmer`, `include Glimmer::UI::CustomWidget`, or `include Glimmer::UI::CustomShell` to a class or module. It relies on JRuby's `include_package` for lazy-importing upon first reference of a Java class.

As a result, you may call SWT Java classes from Glimmer Ruby code without mentioning Java package references explicitly.

For example, `org.eclipse.swt.graphics.Color` can be referenced as just `Color`

The Java packages imported come from the [`Glimmer::Config.import_swt_packages`](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/lib/ext/glimmer/config.rb) config option, which defaults to `Glimmer::Config::DEFAULT_IMPORT_SWT_PACKAGES`, importing the following Java packages:
```
org.eclipse.swt.*
org.eclipse.swt.widgets.*
org.eclipse.swt.layout.*
org.eclipse.swt.graphics.*
org.eclipse.swt.browser.*
org.eclipse.swt.custom.*
org.eclipse.swt.dnd.*
```

If you need to import additional Java packages as extra Glimmer widgets, you may add more packages to [`Glimmer::Config.import_swt_packages`](https://github.com/AndyObtiva/glimmer-dsl-swt/blob/master/lib/ext/glimmer/config.rb) by using the `+=` operator (or alternatively limit to certain packages via `=` operator).

Example:

```ruby
Glimmer::Config.import_swt_packages += [
  'org.eclipse.nebula.widgets.ganttchart'
]
```

Another alternative is to simply add a `java_import` call to your code (e.g. `java_import 'org.eclipse.nebula.widgets.ganttchart.GanttChart'`). Glimmer will automatically take advantage of it (e.g. when invoking `gantt_chart` keyword)

Nonetheless, you can disable automatic Java package import if needed via this Glimmer configuration option:

```ruby
Glimmer::Config.import_swt_packages = false
```

Once disabled, to import SWT Java packages manually, you may simply:

1. `include Glimmer::SWT::Packages`: lazily imports all SWT Java packages to your class, lazy-loading SWT Java class constants on first reference.

2. `java_import swt_package_class_string`: immediately imports a specific Java class where `swt_package_class_string` is the Java full package reference of a Java class (e.g. `java_import 'org.eclipse.swt.SWT'`)

Note: Glimmer relies on [`nested_imported_jruby_include_package`](https://github.com/AndyObtiva/nested_inherited_jruby_include_package), which automatically brings packages to nested-modules/nested-classes and sub-modules/sub-classes.

You can learn more about importing Java packages into Ruby code at this JRuby WIKI page:

https://github.com/jruby/jruby/wiki/CallingJavaFromJRuby

### loop_max_count

Glimmer has infinite loop detection support.
It can detect when an infinite loop is about to occur in method_missing and stops it.
It detects potential infinite loops when the same keyword and args repeat more than 100 times, which is unusual in a GUI app.

The max limit can be changed via the `Glimmer::Config::loop_max_count=(count)` config option.

Infinite loop detection may be disabled altogether if needed by setting `Glimmer::Config::loop_max_count` to `-1`

### excluded_keyword_checkers

Glimmer permits consumers to exclude keywords from DSL processing by its engine via the `excluded_keyword_checkers` config option.

To do so, add a proc to it that returns a boolean indicating if a keyword is excluded or not.

Note that this proc runs within the context of the Glimmer object (as in the object mixing in the Glimmer module), so checker can can pretend to run there with its `self` object assumption.

Example of keywords excluded by [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt):

```ruby
Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
  method = method_symbol.to_s
  result = false
  result ||= method.start_with?('on_swt_') && is_a?(Glimmer::UI::CustomWidget) && respond_to?(method)
  result ||= method == 'dispose' && is_a?(Glimmer::UI::CustomWidget) && respond_to?(method)
  result ||= ['drag_source_proxy', 'drop_target_proxy'].include?(method) && is_a?(Glimmer::UI::CustomWidget)
  result ||= method == 'post_initialize_child'
  result ||= method.end_with?('=')
  result ||= ['finish_edit!', 'search', 'all_tree_items', 'depth_first_search'].include?(method) && is_a?(Glimmer::UI::CustomWidget) && body_root.respond_to?(method)
end
```

### log_excluded_keywords

(default = false)

This just tells Glimmer whether to log excluded keywords or not (at the debug level). It is off by default.

### auto_sync_exec

(default = true)

This automatically uses sync_exec on GUI calls from threads other than the main GUI thread instead of requiring users to manually use sync_exec.

Keep in mind that this could cause redraws on every minor change in the models instead of applying large scope changes together.
In rare cases where you need to avoid causing stutter in the GUI as a result, you can wrap large-scale GUI updates in `auto_exec` manually.

As such, this saves developers a lot of headache by not requiring wrapping every bit of GUI update in other threads with `sync_exec`, yet only
large scale updates in the rare cases where optimization is needed.

## License

[MIT](LICENSE.txt)

Copyright (c) 2007-2025 - Andy Maleh.
