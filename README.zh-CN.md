[English](./README.md) | 简体中文

# reorder-file

reorder-file 是一个 Emacs 插件， 分析 Buffer 的内容， 并自动重新排序内容中的序号。

因为这个插件是基于 [cloel](https://github.com/manateelazycat/cloel) 开发的， 可以充分利用 Clojure 的多线程能力， 不管多大的文件都不会卡住 Emacs。

## 安装

1. 安装 [cloel](https://github.com/manateelazycat/cloel)

2. 安装 reorder-file
   - 克隆仓库并添加到 Emacs 配置：
   ```elisp
   (add-to-list 'load-path "<path-to-reorder-file>")
   (require 'reorder-file)
   ```

## 使用
M-x `reorder-file`, 支持当前 buffer 和选中区域

如果当前区域的文本是以数字开头的， 就会对内容重排每行前面的序号。

如果当前区域的文本是其他类型的， 会按照 Alpha 顺序排列所有行。