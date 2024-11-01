English | [简体中文](./README.zh-CN.md)

# reorder-file

reorder-file is an Emacs plugin that analyzes the content of a buffer and automatically reorders the numbering within the content.

Since this plugin is developed based on [cloel](https://github.com/manateelazycat/cloel), it can fully utilize Clojure's multi-threading capabilities, ensuring that Emacs won't freeze even when processing large files.

## Installation

1. Install [cloel](https://github.com/manateelazycat/cloel)

2. Install reorder-file
   - Clone the repository and add it to your Emacs configuration:
   ```elisp
   (add-to-list 'load-path "<path-to-reorder-file>")
   (require 'reorder-file)
   ```

## Usage
M-x `reorder-file` supports both current buffer and selected region

If the text in the current region starts with numbers, it will reorder the numbers at the beginning of each line.

If the text in the current region is of other types, it will sort all lines in alphabetical order.