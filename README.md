# [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=85 />](https://github.com/AndyObtiva/glimmer) Glimmer DSL for SWT 0.6.2 (Desktop GUI)
[![Gem Version](https://badge.fury.io/rb/glimmer-dsl-swt.svg)](http://badge.fury.io/rb/glimmer-dsl-swt)
[![Travis CI](https://travis-ci.com/AndyObtiva/glimmer-dsl-swt.svg?branch=master)](https://travis-ci.com/github/AndyObtiva/glimmer-dsl-swt)
[![Coverage Status](https://coveralls.io/repos/github/AndyObtiva/glimmer-dsl-swt/badge.svg?branch=master)](https://coveralls.io/github/AndyObtiva/glimmer-dsl-swt?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/aaf1cba142dd351f84bd/maintainability)](https://codeclimate.com/github/AndyObtiva/glimmer-dsl-swt/maintainability)
[![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Glimmer](https://github.com/AndyObtiva/glimmer) DSL for [SWT](https://www.eclipse.org/swt/) enables desktop development with [Glimmer](https://github.com/AndyObtiva/glimmer).

[Glimmer](https://github.com/AndyObtiva/glimmer) is a native-GUI cross-platform desktop development library written in Ruby. Glimmer's main innovation is a JRuby DSL that enables productive and efficient authoring of desktop application user-interfaces while relying on the robust Eclipse SWT library. Glimmer additionally innovates by having built-in data-binding support to greatly facilitate synchronizing the GUI with domain models. As a result, that achieves true decoupling of object oriented components, enabling developers to solve business problems without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models test-first afterwards.

You may find full setup/usage instructions at the main [Glimmer project page](https://github.com/AndyObtiva/glimmer).

Other [Glimmer](https://github.com/AndyObtiva/glimmer) DSL gems:
- [glimmer-dsl-opal](https://github.com/AndyObtiva/glimmer-dsl-opal): Glimmer DSL for Opal (Web GUI Adapter for Desktop Apps)
- [glimmer-dsl-xml](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML)
- [glimmer-dsl-css](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS (Cascading Style Sheets)

## Example

```ruby
include Glimmer
   
shell {
  text 'Glimmer'
  label {
    text 'Hello, World!'
  }
}.open
```

![Glimmer DSL for SWT Hello World](https://github.com/AndyObtiva/glimmer/blob/master/images/glimmer-hello-world.png)

Learn more at the main [Glimmer project page](https://github.com/AndyObtiva/glimmer).

## Help

### Issues

You may submit [issues](https://github.com/AndyObtiva/glimmer/issues) on [GitHub](https://github.com/AndyObtiva/glimmer/issues).

[Click here to submit an issue.](https://github.com/AndyObtiva/glimmer/issues)

### Chat

If you need live help, try to [![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Feature Suggestions

These features have been suggested. You might see them in a future version of Glimmer. You are welcome to contribute more feature suggestions.

[TODO.md](TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md)

## Contributors

* [Andy Maleh](https://github.com/AndyObtiva) (Founder)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer-dsl-swt/graphs/contributors)

## License

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2020 - Andy Maleh. 
See [LICENSE.txt](LICENSE.txt) for further details.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built for [Glimmer](https://github.com/AndyObtiva/glimmer) (Ruby Desktop Development GUI Library).
