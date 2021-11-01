## Glimmer Packaging and Distribution

Glimmer simplifies the process of native-executable packaging and distribution on Mac, Windows, and Linux via a single `glimmer package` command:

```
glimmer package
```

It works out of the box for any application scaffolded by [Glimmer Scaffolding](#scaffolding), generating default packaging type on the current platform if not specified (i.e. `app-image`) and displaying a message indicating what pre-requisite setup tools are needed if not installed already (e.g. [Wix Toolset](https://wixtoolset.org/) to generate MSI files on Windows. If you install Wix, make sure it is on the system PATH by adding for example "C:\Program Files (x86)\WiX Toolset v3.11\bin" to the Windows Environment Variables.).

You may choose to generate a specific type of packaging instead by addionally passing in the `[type]` option. For example, this generates an MSI setup file on Windows:

```
glimmer package[msi]
```

![glimmer packaging windows msi](/images/glimmer-packaging-windows-msi.png)

This command generates a DMG file on the Mac:

```
glimmer package[dmg]
```

Make sure to surround with double-quotes when running from ZShell (zsh):

```
glimmer "package[dmg]"
```

![glimmer packaging mac dmg license screen](/images/glimmer-packaging-mac-dmg-license-screen.png)

![glimmer packaging mac dmg](/images/glimmer-packaging-mac-dmg.png)

This command generates a DEB file on a Linux that supports deb packages (e.g. Linux Mint Cinnamon):

```
glimmer package[deb]
```

![glimmer packaging linux deb](/images/glimmer-packaging-linux-deb.png)

This command generates an RPM file on a Linux that supports rpm packages (e.g. Red Hat Enterprise Linux):

```
glimmer package[rpm]
```

![glimmer packaging linux rpm](/images/glimmer-packaging-linux-rpm.png)

- Available Mac packaging types are `dmg`, `pkg`, and `app-image` (image means a pure Mac `app` without a setup program). Keep in mind that the packages you produce are compatible with the same MacOS you are on or older.
- Available Windows packaging types are `msi`, `exe`, and `app-image` (image means a Windows application directory without a setup program). Learn more about Windows packaging are [over here](#windows-application-packaging).
- Available Linux packaging types are `deb`, `rpm`, and `app-image` (note the prerequisites: for Red Hat Linux, the `rpm-build` package is required (for rpm) and for Ubuntu Linux, the `fakeroot` package is required (for deb). Also, use common sense to know which package type to generate on what Linux [e.g. use `deb` on `Linux Mint Cinnamon` or use `rpm` on `Fedora Linux`]).

Note 1: On Windows, ensure system environment PATH includes Java bin directory `"C:\Program Files\Java\jdk-16.0.2\bin"` at the top for `jpackage` command to work during packaging Glimmer applications (the default Oracle setup path for Java after installing the JDK is usually not sufficient).

Note 2: Glimmer packaging has a strong dependency on JDK16 since it includes the packaging tool `jpackage`. On the Mac, it seems there is a new gotcha in the latest JDK 16 DMG/PKG installable that is resulting in `jpackage` to be missing from `PATH`. To include, you might need to add `export PATH="/Library/Java/JavaVirtualMachines/jdk-16.0.2.jdk/Contents/Home/bin:$PATH"` to `~/.zprofile` or `~/.bashrc`

Note 3: On Linux, note the prerequisites: for Red Hat Linux, the `rpm-build` package is required (for rpm) and for Ubuntu Linux, the `fakeroot` package is required (for deb). Also, use common sense to know which package type to generate on what Linux (e.g. use `deb` on `Linux Mint Cinnamon` or use `rpm` on `Fedora Linux`)

Note 4: if you are using Glimmer packaging with a manually generated app (without scaffolding), in order to make the `glimmer package` command available, you must add the following line to your application `Rakefile` (automatically done for you if you scaffold an app or gem with `glimmer scaffold[AppName]` or `glimmer scaffold:gem:customshell[GemName]`):

```ruby
require 'glimmer/rake_task'
```

The Glimmer packaging process done in the `glimmer package` command consists of the following steps:
1. Generate gemspec via [Juwelier](https://rubygems.org/gems/juwelier) (`glimmer package:gemspec`): Having a gemspec is required by the [`jar-dependencies`](https://github.com/mkristian/jar-dependencies) JRuby gem, used by JRuby libraries to declare JAR dependencies.
1. Lock JAR versions (`glimmer package:lock_jars`): This locks versions of JAR dependencies leveraged by the `jar-dependencies` JRuby gem, downloading them into the `./vendor` directory so they would get inside the top-level Glimmer app/gem JAR file.
1. Generate [Warbler](https://github.com/jruby/warbler) config (`glimmer package:config`): Generates initial Warbler config file (under `./config/warble.rb`) to use for generating JAR file.
1. Generate JAR file using [Warbler](https://github.com/jruby/warbler) (`glimmer package:jar`): Enables bundling a Glimmer app into a JAR file under the `./dist` directory
1. Generate native executable using [jpackage](https://docs.oracle.com/en/java/javase/16/jpackage/packaging-tool-user-guide.pdf) (`glimmer package:native`): Enables packaging a JAR file as a DMG/PKG/APP file on Mac, MSI/EXE/APP on Windows, and DEB/RPM/APP on Linux (Glimmer does not officially support Linux with the `glimmer package` command yet, but it generates the JAR file successfully, and you could use `jpackage` manually afterwards if needed).

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
- https://docs.oracle.com/en/java/javase/16/jpackage/packaging-tool-user-guide.pdf
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

Windows offers two options for packaging:
- `msi` (recommended): simpler packaging option. Requires [WiX Toolset](https://wixtoolset.org/) and [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework). Simply run `glimmer package[msi]` (or `glimmer package:native[msi]` if it's not your first time) and it will give you more details on the pre-requisites you need to install (e.g. [WiX Toolset](https://wixtoolset.org/) and [.NET Framework 3.5 SP1](https://dotnet.microsoft.com/download/dotnet-framework/net35-sp1)).
- `exe`: more advanced packaging option. Requires [Inno Setup](https://jrsoftware.org/isinfo.php). Simply run `glimmer package[exe]` (or `glimmer package:native[exe]` if it's not your first time) and it will tell you what you need to install.

If you just want to test out packaging into a native Windows app that is not packaged for Windows setup, just pass `app-image` (default) to generate a native Windows app only.

### Mac Application Distribution

Recent macOS versions (starting with Catalina) have very stringent security requirements requiring all applications to be signed before running (unless the user goes to System Preferences -> Security & Privacy -> General tab and clicks "Open Anyway" after failing to open application the first time they run it). So, to release a desktop application on the Mac, it is recommended to enroll in the [Apple Developer Program](https://developer.apple.com/programs/) to distribute on the [Mac App Store](https://developer.apple.com/distribute/) or otherwise request [app notarization from Apple](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) to distribute independently.

Afterwards, you may add signing arguments to `jpackage` via `Glimmer::RakeTask::Package.jpackage_extra_args` or `JPACKAGE_EXTRA_ARGS` according to this webpage: https://docs.oracle.com/en/java/javase/16/jpackage/packaging-tool-user-guide.pdf

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

2. unsupported Java version "16", defaulting to 1.7

If you get this error while packaging:

```
unsupported Java version "16", defaulting to 1.7
[ERROR] Internal error: org.jruby.exceptions.RaiseException: (LoadError) library `java' could not be loaded: java.lang.reflect.InaccessibleObjectException: Unable to make protected native java.lang.Object java.lang.Object.clone() throws java.lang.CloneNotSupportedException accessible: module java.base does not "opens java.lang" to unnamed module @138caeca -> [Help 1]
org.apache.maven.InternalErrorException: Internal error: org.jruby.exceptions.RaiseException: (LoadError) library `java' could not be loaded: java.lang.reflect.InaccessibleObjectException: Unable to make protected native java.lang.Object java.lang.Object.clone() throws java.lang.CloneNotSupportedException accessible: module java.base does not "opens java.lang" to unnamed module @138caeca
  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:121)
  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:863)
  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
  at org.apache.maven.cli.MavenCli.main(MavenCli.java:199)
  at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
  at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:78)
  at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
  at java.base/java.lang.reflect.Method.invoke(Method.java:567)
  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
Caused by: org.jruby.exceptions.RaiseException: (LoadError) library `java' could not be loaded: java.lang.reflect.InaccessibleObjectException: Unable to make protected native java.lang.Object java.lang.Object.clone() throws java.lang.CloneNotSupportedException accessible: module java.base does not "opens java.lang" to unnamed module @138caeca
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
```

3. jpackage missing from PATH on the Mac

On the Mac, the latest JDK 16 installable DMG/PKG is resulting in `jpackage` to be missing from `PATH`. To include, you might need to add `export PATH="/Library/Java/JavaVirtualMachines/jdk-16.0.2.jdk/Contents/Home/bin:$PATH"` to `~/.zprofile` or `~/.bashrc`
```
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/InternalErrorException
```

Please ignore. It should be harmless. If you get blocked by it for any reason, please open an Issue about it.

4. Java on Windows System PATH

If you get any errors running Java on Windows, keep in mind that you need to have the Java binaries "C:\Program Files\Java\jdk-16.0.2\bin" on the Windows System PATH environment variable.

The problem is Oracle seems to be adding an indirect Java path junction in later versions of their installer:
`C:\Program Files (x86)\Common Files\Oracle\Java\javapath`

Simply replace it with the simple path mentioned above (`"C:\Program Files\Java\jdk-16.0.2\bin"` matching your correct version number)

Lastly, reinstall JRuby to ensure it is using Java from the right path.

5. File paths in app running from packaged JAR file

Glimmer packaged apps always reside within a JAR file before being wrapped by a native executable.

JRuby automatically converts any paths produced by File.expand_path inside packaged JAR file into uri:classloader prefixed paths. They work just fine when performing File.read, but if you need to access as a Java input stream, you need to use special code:

```ruby
require 'jruby'
file_path = File.expand_path(some_path, __dir__)
file_path = file_path.sub(/^uri\:classloader\:/, '').sub(/^\/+/, '')
jcl = JRuby.runtime.jruby_class_loader
resource = jcl.get_resource_as_stream(file_path)
file_input_stream = resource.to_io.to_input_stream
``` 

The `image` keyword in Glimmer automatically does that work when passing an image path produced from inside a JAR file.

6. NAME.app is damaged and can't be opened. You should move it to the trash

If you package an app for the Mac and an end-user gets the error message above upon installing, note that you probably have a system incompatibility issue between your OS/CPU Architecture and the end-user's OS/CPU Architecture. To resolve the issue, make sure to repackage the app for the Mac on a system perfectly matching the end-user's OS/CPU Architecture (sometimes, packaging on a newer MacOS with the same CPU Architecture also works, but you would have to test that to confirm and ensure full compatibility).

7. Message about a Mac app for which the developer cannot be verified (Move To Trash or Cancel)

If you get the above message when running a packaged Mac app for the first time, choose cancel and then immediately go to System Preferences -> Security & Privacy -> General Tab -> Choose Open Anyway at the bottom where the app name should be showing.

This would not be an issue if the app was [signed by Apple as per Mac Application Distribution instructions](#mac-application-distribution)
