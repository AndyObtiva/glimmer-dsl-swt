# Change Log

## 0.1.3

- Added 'org.eclipse.swt.dnd' to glimmer auto-included Java packages
- Updated Tic Tac Toe sample to use new `message_box` keyword 
- Add DragSource and DropTarget transfer expression that takes a symbol or symbol array representing one or more of the following: FileTransfer, HTMLTransfer, ImageTransfer, RTFTransfer, TextTransfer, URLTransfer
- Set default style DND::DROP_COPY in DragSource and DropTarget widgets
- Support Glimmer::SWT::DNDProxy for handling Drop & Drop styles
- Implemented list:* rake tasks for listing Glimmer custom widget gems, custom shell gems, and dsl gems
- Support querying for Glimmer gems (not just listing them)
- Fix bug with table edit remaining when sorting table or re-listing (in contact_manager.rb sample)
- Update icon of scaffolded apps to Glimmer logo

## 0.1.2

- Extracted common model data-binding classes into glimmer

## 0.1.1

- Fixed issue with packaging after generating gemspec
- Fixed issue with enabling development mode in glimmer command

## 0.1.0

- Extracted Glimmer DSL for SWT (glimmer-dsl-swt gem) from Glimmer
