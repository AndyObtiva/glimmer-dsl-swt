## Glimmer Style Guide

- Widgets are declared with underscored lowercase versions of their SWT names minus the SWT package name.
- Widget declarations may optionally have arguments and be followed by a block (to contain properties and content)
- Widget blocks are always declared with curly braces
- Widget arguments are always wrapped inside parentheses
- Widget properties are declared with underscored lowercase versions of the SWT properties
- Widget property declarations always have arguments and never take a block
- Widget property arguments are never wrapped inside parentheses
- Widget listeners are always declared starting with `on_` prefix and affixing listener event method name afterwards in underscored lowercase form. Their multi-line blocks rely on the `do; end` style.
- Data-binding can be done via `bind` keyword, which always takes arguments wrapped in parentheses, or using `<=>` and `<=` operators, which expect an array of model/property/options as arguments.
- Custom widget/shell/shape `body` blocks open and close with curly braces.
- Custom widget/shell/shape `before_body` and `after_body` blocks are declared as `do; end` blocks.
- Custom widgets receive additional keyword arguments called options, which come after the SWT styles.
- Pure logic multi-line blocks that do not constitute GUI DSL view elements (such as `Thread.new`, `loop`, `each` and `observe` blocks) rely on the `do; end` style to clearly separate logic code from view code.
