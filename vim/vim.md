##vim寄存器

显示当前寄存器的内容
    :reg


##vim 数学运算
| 按键 | 说明 | 
| ------ | ------ |
| <c+a> | 加一 |
| <c+x> | 减一 |



##FileType事件
最有用的事件是FileType事件。这个事件会在Vim设置一个缓冲区的filetype的时候触发, 让我们针对不同文件类型设置一些有用的映射。运行命令：
```
    :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
    :autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>
```
打开一个Javascript文件（后缀为.js的文件）,将光标移动到某一行，敲击<localleader>c，光标所在的那一行会被注释掉。  
现在打开一个Python文件（后缀为.py的文件）,将光标移动到某一行，敲击<localleader>c，同样的那一行会被注释掉，不同的是此时所用的是Python的注释字符！

##设置映射



###map映射（mappings）

###缩写（abbreviations）
我们可以加几个日常编辑中常用的abbreviations。 运行如下命令：
```
:iabbrev @@    steve@stevelosh.com
:iabbrev ccopy Copyright 2013 Steve Losh, all rights reserved.
```

###热键(Leader)
使用下面的命令设置前置命令
```
let mapleader = "\\"
:autocmd FileType html nnoremap <buffer> <leader>v :s/^\([[:space:]]*\)<!--\(.*\)-->$/\1\2/g<cr>
:autocmd FileType html nnoremap <buffer> <leader>c I<!--<Esc>A--><Esc>
```
这样就可以很方便的写注释了

>FileType自动命令使用setlocal对你喜欢的文件类型做一些设置。你可以针对不同的文件类型设置wrap、list、 spell和number这些选项。

###自定义文件类型以及根据文件类型缩进
如下的代码是设置yaml文件使用tab键输入两个空格。
    au! BufNewFile,BufRead *.sls setf sls
    autocmd FileType sls setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

常用的用法，nginx配置文件语法高亮
    autocmd BufRead,BufNewFile /usr/local/services/tengine-2.1.2/conf/* set filetype=nginx
###abbreviations和mappings的区别
abbreviations和mappings很像，但是他们的定位不同。看个例子：
```
:inoremap ssig -- <cr>Steve Losh<cr>steve@stevelosh.com
```
这个 mapping 用于快速插入你的签名。进入insert模式并输入ssig试试看。
看起来一切正常，但是还有个问题。进入insert模式并输入如下文字：
```
Larry Lessig wrote the book "Remix".
```
注意到Vim将Larry名字中的ssig也替换了！mappings不管被映射字符串的前后字符是什么,它只在文本中查找指定的字符串并替换他们。

##vim多窗口运行
###批量修改多个窗口中的内容
```
:argdo %s//n/g
```
