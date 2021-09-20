## Glimmer Packaging and Distribution

Note: this section mostly applies to Mac and Windows. On Linux, you can just run `glimmer package:gem` and after installing the gem, you get an executable matching the name of the app/custom-shell-gem you are building (e.g. `calculator` command becomes available after installing the [glimmer-cs-calculator](https://github.com/AndyObtiva/glimmer-cs-calculator) gem). On Windows, ensure system PATH includes Java bin directory `"C:\Program Files\Java\jdk-16.0.2\bin"` for `jpackage` command to work during packaging Glimmer applications.

Note 2: Glimmer packaging has a strong dependency on JDK16 since it includes the packaging tool `jpackage`.

Glimmer simplifies the process of native-executable packaging and distribution on Mac and Windows via a single `glimmer package` command:

```
glimmer package
```

It works out of the box for any application scaffolded by [Glimmer Scaffolding](#scaffolding), generating all available packaging types on the current platform (e.g. `dmg`, `pkg`, `app-image` on the Mac) and displaying a message indicating what pre-requisite setup tools are needed if not installed already (e.g. [Wix Toolset](https://wixtoolset.org/) to generate MSI files on Windows). If you install Wix, make sure it is on the system PATH by adding for example "C:\Program Files (x86)\WiX Toolset v3.11\bin" to the Windows Environment Variables.

You may choose to generate a specific type of packaging instead by addionally passing in the `[type]` option. For example, this generates an MSI setup file on Windows:

```
glimmer package[msi]
```

Make sure to surround with double-quotes when running from ZShell (zsh):

```
glimmer "package[msi]"
```

- Available Mac packaging types are `dmg`, `pkg`, and `app-image` (image means a pure Mac `app` without a setup program). Keep in mind that the packages you produce are compatible with the same MacOS you are on or older.
- Available Windows packaging types are `msi`, `exe`, and `app-image` (image means a Windows application directory without a setup program). Learn more about Windows packaging are [over here](#windows-application-packaging).

Note: if you are using Glimmer manually, to make the `glimmer package` command available, you must add the following line to your application `Rakefile` (automatically done for you if you scaffold an app or gem with `glimmer scaffold[AppName]` or `glimmer scaffold:gem:customshell[GemName]`):

```ruby
require 'glimmer/rake_task'
```

The Glimmer packaging process done in the `glimmer package` command consists of the following steps:
1. Generate gemspec via [Juwelier](https://rubygems.org/gems/juwelier) (`glimmer package:gemspec`): Having a gemspec is required by the [`jar-dependencies`](https://github.com/mkristian/jar-dependencies) JRuby gem, used by JRuby libraries to declare JAR dependencies.
1. Lock JAR versions (`glimmer package:lock_jars`): This locks versions of JAR dependencies leveraged by the `jar-dependencies` JRuby gem, downloading them into the `./vendor` directory so they would get inside the top-level Glimmer app/gem JAR file.
1. Generate [Warbler](https://github.com/jruby/warbler) config (`glimmer package:config`): Generates initial Warbler config file (under `./config/warble.rb`) to use for generating JAR file.
1. Generate JAR file using [Warbler](https://github.com/jruby/warbler) (`glimmer package:jar`): Enables bundling a Glimmer app into a JAR file under the `./dist` directory
1. Generate native executable using [jpackage](https://docs.oracle.com/en/java/javase/14/jpackage/packaging-tool-user-guide.pdf) (`glimmer package:native`): Enables packaging a JAR file as a DMG/PKG/APP file on Mac, MSI/EXE/APP on Windows, and DEB/RPM/APP on Linux (Glimmer does not officially support Linux with the `glimmer package` command yet, but it generates the JAR file successfully, and you could use `jpackage` manually afterwards if needed).

Those steps automatically ensure generating a JAR file under the `./dist` directory using [Warbler](https://github.com/jruby/warbler), which is then used to automatically generate a DMG/MSI file (and other executables) under the `./packages/bundles` directory using `jpackage`.
The JAR file name will match your application local directory name (e.g. `MathBowling.jar` for `~/code/MathBowling`)
The DMG file name will match the humanized local directory name + dash + application version (e.g. `Math Bowling-1.0.dmg` for `~/code/MathBowling` with version 1.0 or unspecified)

The `glimmer package` command will automatically set "mac.CFBundleIdentifier" to ="org.#{project_name}.application.#{project_name}".
You may override by configuring as an extra argument for javapackger (e.g. Glimmer::RakeTask::Package.jpackage_extra_args = " --mac-package-identifier org.andymaleh.application.MathBowling")

### Packaging Defaults

Glimmer employs smart defaults in packaging.

The package application name (shows up in top menu bar on the Mac) will be a human form of the app root directory name (e.g. "Math Bowling" for "MathBowling" or "math_bowling" app root directory name). However, application name and version may be specified explicitly via "--name", "--mac-package-name" and "--version" options.

Also, the package will only include these directories: app, config, db, lib, script, bin, docs, fonts, images, sounds, videos

After running once, you will find a `config/warble.rb` file. It has the JAR packaging configuration. You may adjust included directories in it if needed, and then rerun `glimmer package` and it will pick up your custom configuration. Alternatively, if you'd like to customize the included directories to begin with, don't run `glimmer package` right away. Run this command first:

```
glimmer package:config
```

This will generate `config/warble.rb`, which you may configure and then run `glimmer package` afterwards.

### Packaging Configuration

- Ensure you have a Ruby script under `bin` directory that launches the application, preferably matching your project directory name (e.g. `bin/math_bowling`) :
```ruby
require_relative '../app/my_application.rb'
```
- Include Icon (Optional): If you'd like to include an icon for your app (.icns format on the Mac), place it under `package/macosx` matching the humanized application local directory name (e.g. 'Math Bowling.icns' [containing space] for MathBowling or math_bowling). You may generate your Mac icon easily using tools like Image2Icon (http://www.img2icnsapp.com/) or manually using the Mac terminal command `iconutil` (iconutil guide: https://applehelpwriter.com/tag/iconutil/)
- Include DMG Background Icon (Optional): Simply place a .png file under `package/macosx/{HumanAppName}-background.png`
- Include Version (Optional): Create a `VERSION` file in your application and fill it your app version on one line (e.g. `1.1.0`)
- Include License (Optional): Create a `LICENSE.txt` file in your application and fill it up with your license (e.g. MIT). It will show up to people when installing your app. Note that, you may optionally also specify license type, but you'd have to do so manually via `--license-file LICENSE.txt` shown in an [example below](#jpackage-extra-arguments).
- Extra args (Optional): You may optionally add the following to `Rakefile` to configure extra arguments for jpackage: `Glimmer::RakeTask::Package.jpackage_extra_args = "..."` (Useful to avoid re-entering extra arguments on every run of rake task.). Read about them in [their section below](#jpackage-extra-arguments).

### jpackage Extra Arguments

(note: currently `Glimmer::RakeTask::Package.jpackage_extra_args` is only honored when packaging from bash, not zsh)

In order to explicitly configure jpackage, Mac package attributes, or sign your Mac app to distribute on the App Store, you can follow more advanced instructions for `jpackage` here:
- Run `jpackage --help` for more info
- https://docs.oracle.com/en/java/javase/14/jpackage/packaging-tool-user-guide.pdf
- https://developer.apple.com/library/archive/releasenotes/General/SubmittingToMacAppStore/index.html#//apple_ref/doc/uid/TP40010572-CH16-SW8

The Glimmer rake task allows passing extra options to jpackage via:
- `Glimmer::RakeTask::Package.jpackage_extra_args="..."` in your application Rakefile
- Environment variable: `JPACKAGE_EXTRA_ARGS`

Example (Rakefile):

```ruby
require 'glimmer/rake_task'

Glimmer::RakeTask::Package.jpackage_extra_args = '--license-file LICENSE.txt --mac-sign --mac-signing-key-user-name "Andy Maleh"'
```

Example (env var):

```
JPACKAGE_EXTRA_ARGS='--mac-package-name "Math Bowling Game"' glimmer package
```

That overrides the default application display name.

### Verbose Mode

Pass `-v` to jpackage in `Glimmer::RakeTask::Package.jpackage_extra_args` or by running `glimmer package:native[type] -v` to learn more about further available customizations for the installer you are requesting to generate.

### Windows Application Packaging

Windows s two options for setup packaging:
- `msi` (recommended): simpler packaging option. Requires [WiX Toolset](https://wixtoolset.org/) and [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework). Simply run `glimmer package[msi]` (or `glimmer package:native[msi]` if it's not your first time) and it will give you more details on the pre-requisites you need to install (e.g. [WiX Toolset](https://wixtoolset.org/) and [.NET Framework 3.5 SP1](https://dotnet.microsoft.com/download/dotnet-framework/net35-sp1)).
- `exe`: more advanced packaging option. Requires [Inno Setup](https://jrsoftware.org/isinfo.php). Simply run `glimmer package[exe]` (or `glimmer package:native[exe]` if it's not your first time) and it will tell you what you need to install.

If you just want to test out packaging into a native Windows app that is not packaged for Windows setup, just pass `image` to generate a native Windows app only.

### Mac Application Distribution

Recent macOS versions (starting with Catalina) have very stringent security requirements requiring all applications to be signed before running (unless the user goes to System Preferences -> Privacy -> General tab and clicks "Open Anyway" after failing to open application the first time they run it). So, to release a desktop application on the Mac, it is recommended to enroll in the [Apple Developer Program](https://developer.apple.com/programs/) to distribute on the [Mac App Store](https://developer.apple.com/distribute/) or otherwise request [app notarization from Apple](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) to distribute independently.

Afterwards, you may add signing arguments to `jpackage` via `Glimmer::RakeTask::Package.jpackage_extra_args` or `JPACKAGE_EXTRA_ARGS` according to this webpage: https://docs.oracle.com/en/java/javase/14/jpackage/packaging-tool-user-guide.pdf

```
  --mac-package-signing-prefix <prefix string>
          When signing the application package, this value is prefixed
          to all components that need to be signed that don't have
          an existing package identifier.
  --mac-sign
          Request that the package be signed
  --mac-signing-keychain <file path>
          Path of the keychain to search for the signing identity
          (absolute path or relative to the current directory).
          If not specified, the standard keychains are used.
  --mac-signing-key-user-name <team name>
          Team name portion in Apple signing identities' names.
          For example "Developer ID Application: "
```

### Packaging Gotchas

1. Zsh (Z Shell)

Currently, `Glimmer::RakeTask::Package.jpackage_extra_args` is only honored when packaging from bash, not zsh.

You can get around that in zsh by running glimmer package commands with `bash -c` prefix:

```
bash -c 'source ~/.glimmer_source; glimmer package'
```

2. Java on Windows System PATH

If you get any errors running Java on Windows, keep in mind that you need to have the Java binaries "C:\Program Files\Java\jdk-16.0.2\bin" on the Windows System PATH environment variable.

The problem is Oracle seems to be adding an indirect Java path junction in later versions of their installer:
`C:\Program Files (x86)\Common Files\Oracle\Java\javapath`

Simply replace it with the simple path mentioned above (`"C:\Program Files\Java\jdk-16.0.2\bin"` matching your correct version number) and then reinstall JRuby to have it use Java from the right path.
