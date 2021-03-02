## Glimmer Packaging and Distribution

Note: this section mostly applies to Mac and Windows. On Linux, you can just run `glimmer package:gem` and after installing the gem, you get an executable matching the name of the app/custom-shell-gem you are building (e.g. `calculator` command becomes available after installing the [glimmer-cs-calculator](https://github.com/AndyObtiva/glimmer-cs-calculator) gem). On Windows, ensure system PATH includes Java bin directory like "C:\Program Files\Java\jdk1.8.0_241\bin" for javapackager command to work during packaging Glimmer applications.

Note 2: Glimmer packaging has a strong dependency on JDK8 at the moment. JDK9 & JDK10 might work, but JDK11 and onward definitely won't since they dropped javapackager, which later came back as jpackage in JDK14, but it's not ready for prime time yet. Just stick to JDK8 for now, strongly supported by Oracle for the next 6 years at least.

Glimmer simplifies the process of native-executable packaging and distribution on Mac and Windows via a single `glimmer package` command:

```
glimmer package
```

It works out of the box for any application scaffolded by [Glimmer Scaffolding](#scaffolding), generating all available packaging types on the current platform (e.g. `DMG`, `PKG`, `APP` on the Mac) and displaying a message indicating what pre-requisite setup tools are needed if not installed already (e.g. [Wix Toolset](https://wixtoolset.org/) to generate MSI files on Windows). If you install Wix, make sure it is on the system PATH by adding for example "C:\Program Files (x86)\WiX Toolset v3.11\bin" to the Windows Environment Variables.

(note: if you see this error on the Mac 'Error: Bundler "DMG Installer" (dmg) failed to produce a bundle.', ignore it as it should have produced a bundle anyways. It is a harmless issue in 3rd party dependency: javapackager.)

You may choose to generate a specific type of packaging instead by addionally passing in the `[type]` option. For example, this generates an MSI setup file on Windows:

```
glimmer package[msi]
```

- Available Mac packaging types are `dmg`, `pkg`, and `image` (image means a pure Mac `app` without a setup program). Keep in mind that the packages you produce are compatible with the same MacOS you are on or older.
- Available Windows packaging types are `msi`, `exe`, and `image` (image means a Windows application directory without a setup program). Learn more about Windows packaging are [over here](#windows-application-packaging).

Note: if you are using Glimmer manually, to make the `glimmer package` command available, you must add the following line to your application `Rakefile` (automatically done for you if you scaffold an app or gem with `glimmer scaffold[AppName]` or `glimmer scaffold:gem:customshell[GemName]`):

```ruby
require 'glimmer/rake_task'
```

The Glimmer packaging process done in the `glimmer package` command consists of the following steps:
1. Generate gemspec via [Juwelier](https://rubygems.org/gems/juwelier) (`glimmer package:gemspec`): Having a gemspec is required by the [`jar-dependencies`](https://github.com/mkristian/jar-dependencies) JRuby gem, used by JRuby libraries to declare JAR dependencies.
1. Lock JAR versions (`glimmer package:lock_jars`): This locks versions of JAR dependencies leveraged by the `jar-dependencies` JRuby gem, downloading them into the `./vendor` directory so they would get inside the top-level Glimmer app/gem JAR file.
1. Generate [Warbler](https://github.com/jruby/warbler) config (`glimmer package:config`): Generates initial Warbler config file (under `./config/warble.rb`) to use for generating JAR file.
1. Generate JAR file using [Warbler](https://github.com/jruby/warbler) (`glimmer package:jar`): Enables bundling a Glimmer app into a JAR file under the `./dist` directory
1. Generate native executable using [javapackager](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/javapackager.html) (`glimmer package:native`): Enables packaging a JAR file as a DMG/PKG/APP file on Mac, MSI/EXE/APP on Windows, and DEB/RPM/APP on Linux (Glimmer does not officially support Linux with the `glimmer package` command yet, but it generates the JAR file successfully, and you could use `javapackager` manually afterwards if needed).

Those steps automatically ensure generating a JAR file under the `./dist` directory using [Warbler](https://github.com/jruby/warbler), which is then used to automatically generate a DMG/MSI file (and other executables) under the `./packages/bundles` directory using `javapackager`.
The JAR file name will match your application local directory name (e.g. `MathBowling.jar` for `~/code/MathBowling`)
The DMG file name will match the humanized local directory name + dash + application version (e.g. `Math Bowling-1.0.dmg` for `~/code/MathBowling` with version 1.0 or unspecified)

The `glimmer package` command will automatically set "mac.CFBundleIdentifier" to ="org.#{project_name}.application.#{project_name}".
You may override by configuring as an extra argument for javapackger (e.g. Glimmer::RakeTask::Package.javapackager_extra_args = " -Bmac.CFBundleIdentifier=org.andymaleh.application.MathBowling")

### Packaging Defaults

Glimmer employs smart defaults in packaging.

The package application name (shows up in top menu bar on the Mac) will be a human form of the app root directory name (e.g. "Math Bowling" for "MathBowling" or "math_bowling" app root directory name). However, application name and version may be specified explicitly via "-Bmac.CFBundleName" and "-Bmac.CFBundleVersion" options.

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
- Include License (Optional): Create a `LICENSE.txt` file in your application and fill it up with your license (e.g. MIT). It will show up to people when installing your app. Note that, you may optionally also specify license type, but you'd have to do so manually via `-BlicenseType=MIT` shown in an [example below](#javapackager-extra-arguments).
- Extra args (Optional): You may optionally add the following to `Rakefile` to configure extra arguments for javapackager: `Glimmer::RakeTask::Package.javapackager_extra_args = "..."` (Useful to avoid re-entering extra arguments on every run of rake task.). Read about them in [their section below](#javapackager-extra-arguments).

### javapackager Extra Arguments

(note: currently `Glimmer::RakeTask::Package.javapackager_extra_args` is only honored when packaging from bash, not zsh)

In order to explicitly configure javapackager, Mac package attributes, or sign your Mac app to distribute on the App Store, you can follow more advanced instructions for `javapackager` here:
- https://docs.oracle.com/javase/9/tools/javapackager.htm#JSWOR719
- https://docs.oracle.com/javase/8/docs/technotes/tools/unix/javapackager.html
- https://docs.oracle.com/javase/8/docs/technotes/guides/deploy/self-contained-packaging.html#BCGICFDB
- https://docs.oracle.com/javase/8/docs/technotes/guides/deploy/self-contained-packaging.html
- https://developer.apple.com/library/archive/releasenotes/General/SubmittingToMacAppStore/index.html#//apple_ref/doc/uid/TP40010572-CH16-SW8

The Glimmer rake task allows passing extra options to javapackager via:
- `Glimmer::RakeTask::Package.javapackager_extra_args="..."` in your application Rakefile
- Environment variable: `JAVAPACKAGER_EXTRA_ARGS`

Example (Rakefile):

```ruby
require 'glimmer/rake_task'

Glimmer::RakeTask::Package.javapackager_extra_args = '-BlicenseType="MIT" -Bmac.category="public.app-category.business" -Bmac.signing-key-developer-id-app="Andy Maleh"'
```

Note that `mac.category` defaults to "public.app-category.business", but can be overridden with one of the category UTI values mentioned here:

https://developer.apple.com/library/archive/releasenotes/General/SubmittingToMacAppStore/index.html#//apple_ref/doc/uid/TP40010572-CH16-SW8

Example (env var):

```
JAVAPACKAGER_EXTRA_ARGS='-Bmac.CFBundleName="Math Bowling Game"' glimmer package
```

That overrides the default application display name.

### Verbose Mode

Pass `-v` to javapackager in `Glimmer::RakeTask::Package.javapackager_extra_args` or by running `glimmer package:native[type] -v` to learn more about further available customizations for the installer you are requesting to generate.

### Windows Application Packaging

Windows s two options for setup packaging:
- `msi` (recommended): simpler packaging option. Requires [WiX Toolset](https://wixtoolset.org/) and [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework). Simply run `glimmer package[msi]` (or `glimmer package:native[msi]` if it's not your first time) and it will give you more details on the pre-requisites you need to install (e.g. [WiX Toolset](https://wixtoolset.org/) and [.NET Framework 3.5 SP1](https://dotnet.microsoft.com/download/dotnet-framework/net35-sp1)).
- `exe`: more advanced packaging option. Requires [Inno Setup](https://jrsoftware.org/isinfo.php). Simply run `glimmer package[exe]` (or `glimmer package:native[exe]` if it's not your first time) and it will tell you what you need to install.

If you just want to test out packaging into a native Windows app that is not packaged for Windows setup, just pass `image` to generate a native Windows app only.

### Mac Application Distribution

Recent macOS versions (starting with Catalina) have very stringent security requirements requiring all applications to be signed before running (unless the user goes to System Preferences -> Privacy -> General tab and clicks "Open Anyway" after failing to open application the first time they run it). So, to release a desktop application on the Mac, it is recommended to enroll in the [Apple Developer Program](https://developer.apple.com/programs/) to distribute on the [Mac App Store](https://developer.apple.com/distribute/) or otherwise request [app notarization from Apple](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) to distribute independently.

Afterwards, you may add developer-id/signing-key arguments to `javapackager` via `Glimmer::RakeTask::Package.javapackager_extra_args` or `JAVAPACKAGER_EXTRA_ARGS` according to this webpage: https://docs.oracle.com/javase/9/tools/javapackager.htm#JSWOR719

DMG signing key argument:
```
-Bmac.signing-key-developer-id-app="..."
```

PKG signing key argument:
```
-Bmac.signing-key-developer-id-installer="..."
```

Mac App Store signing key arguments:
```
-Bmac.signing-key-app="..."
-Bmac.signing-key-pkg="..."
```

### Self Signed Certificate

You may still release a signed DMG file without enrolling into the Apple Developer Program with the caveat that users will always fail in opening the app the first time, and have to go to System Preferences -> Privacy -> General tab to "Open Anyway".

To do so, you may follow these steps (abbreviated version from https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/Procedures/Procedures.html#//apple_ref/doc/uid/TP40005929-CH4-SW2):
- Open Keychain Access
- Choose Keychain Access > Certificate Assistant > Create Certificate ...
- Enter Name (referred to below as "CertificateName")
- Set 'Certificate Type' to 'Code Signing'
- Create (if you alternatively override defaults, make sure to enable all capabilities)
- Add the following option to javapackager: `-Bmac.signing-key-developer-id-app="CertificateName"` via `Glimmer::RakeTask::Package.javapackager_extra_args` or `JAVAPACKAGER_EXTRA_ARGS`

Example:

```ruby
Glimmer::RakeTask::Package.javapackager_extra_args = '-Bmac.signing-key-developer-id-app="Andy Maleh"'
```

Now, when you run `glimmer package`, it builds a self-signed DMG file. When you make available online, and users download, upon launching application, they are presented with your certificate, which they have to sign if they trust you in order to use the application.

### Packaging Gotchas

1. Specifying License File

The javapackager documentation states that a license file may be specified with "-BlicenseFile" javapackager option. However, in order for that to work, one must specify as a source file via "-srcfiles" javapackager option.
Keep that in mind if you are not going to rely on the default `LICENSE.txt` support.

Example:

```ruby
Glimmer::RakeTask::Package.javapackager_extra_args = '-srcfiles "ACME.txt" -BlicenseFile="ACME.txt" -BlicenseType="ACME"'
```

2. Mounted DMG Residue

If you run `glimmer package` multiple times, sometimes it leaves a mounted DMG project in your finder. Unmount before you run the command again or it might fail with an error saying: "Error: Bundler "DMG Installer" (dmg) failed to produce a bundle."

By the way, keep in mind that during normal operation, it does also indicate a false-negative while completing successfully similar to the following (please ignore):

```
Exec failed with code 2 command [[/usr/bin/SetFile, -c, icnC, /var/folders/4_/g1sw__tx6mjdgyh3mky7vydc0000gp/T/fxbundler4076750801763032201/images/MathBowling/.VolumeIcon.icns] in unspecified directory
```

3. Zsh (Z Shell)

Currently, `Glimmer::RakeTask::Package.javapackager_extra_args` is only honored when packaging from bash, not zsh.

You can get around that in zsh by running glimmer package commands with `bash -c` prefix:

```
bash -c 'glimmer package'
```

4. Java on Windows System PATH

If you get any errors running Java on Windows, keep in mind that you need to have the Java binaries on the Windows System PATH environment variable:
c:\program files\java\jre1.8.0_241

The problem is Oracle seems to be adding an indirect Java path junction in later versions of their installer:
C:\Program Files (x86)\Common Files\Oracle\Java\javapath

Simply replace with the simple one above (setting the correct version number) and then reinstall JRuby to have it use Java from the right path.
