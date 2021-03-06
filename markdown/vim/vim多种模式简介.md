#普通模式 
##减少重复的操作（结识.范式）
vim之所以能高效地重复，是因为它会记录我们最
近的操作，让我们用较少的按键就能重复上次的修改。   
> 使用jkhl替代上下左右键，因为会无法使用.范式。
> . 命令是一个微型的宏。

example: 在每行的结尾添加一个分号
```
var foo = 1
var bar = ' a '
var foobar = foo + bar
```

##构造可重复的修改 Vim
&emsp;对重复操作进行了优化，要利用这一点，我们必须考虑该如何构造修改。在 Vim
中，要完成一件事，总是有不止一种方式。在评估哪种方式最好时，最显
而易见的指标是效率，即需要的按键次数最少的手段。  
&emsp;Example:假设光标位于行尾处的字符“h”上，而我们想要删除单词“nigh”。
```
 The end is nigh
```
* 反向删除 因为光标已经位于单词末尾，我们可以先反向删除该词。 

| 按键操作 | 缓冲区内容 |
| -------- | ---------- |
| {start} | the end is nigh |
| db | the end is n |
| x | the end is |
* 正向删除 

| 按键操作 | 缓冲区内容 |
| -------- | ---------- |
| {start} | the end is nigh |
| b | the end is n |
| dw | the end is |

* 删除整个单词

| 按键操作 | 缓冲区内容 |
| -------- | ---------- |
| {start} | the end is nigh |
| daw | the end is |

上面三个方式都只需要三个按键，但是推荐使用第三种方式，它可以使用.去重复上次删除单词的命令，
（ ex：. = = daw ），daw 可以发挥 . 命令的最大威力 

###vim 数学运算 
| 按键 | 说明 | 
| ------ | ------ |
| &lt;c+a&gt; | 加一 | 
| &lt;c+x&gt;| 减一 |

&emsp;Example: 
```
source：
.blog, .news { background-image: url (/ sprite.png ); }
.blog { background-position: 0px 0px }

target：
.blog, .news { background-image: url (/ sprite.png ); }
.blog { background-position: 180px 0px }
```

##Operator-pending模式 
###操作符 + [重复次数] + 动作命令 = 操作 
d{motion} 命令可以对一个字符（ dl ）、一个完整单词（ daw ）或一整个段落（ dap
）进行操作，它作用的范围由动作命令决定。 c{motion} 、 y{motion} 以及其他一些命令
也类似，它们被统称为操作符（operator）。你可以用 :h operator 来查阅完整的列表

eg:
| 按键 | 操作 | 移动 |
| ------ | ------ | ------ | 
| dw | 删除 | 到下一个单词 |
| ci( | 修改 | 在括号内 | 
| yat | 复制 | 整个标记对 | 
| gUi" | 修改为大写 | 引号里面的内容 | 
| =ap | 格式化输出 | 当前段落 | 

####自定义操作符 
####自定义动作命令(Operator-Pending映射)
> :onoremap b /return&lt;cr&gt; 如果执行Vim把整个函数体中直到return上面的内容都删除了  
> :onoremap &lt;silent&gt; F :&lt;C-U&gt;normal! 0f(hviw&lt;CR&gt; 
> 可以通过v可视模式来选中非光标作为起始位置,&lt;C-U&gt;是为了remove the range。

#插入模式
插入模式只专注于做一件事，那就是输入文字，而普通模式却是我们大部分时间
所使用的模式（顾名思义），因此能快速在这两种模式间切换是很重要的。本节将介绍
一些技巧，可以减少模式切换所带来的损耗.

| 按键 | 用途 | 
| ------ | ------ |
| &lt;Esc&gt; | 切换到普通模式 |
| &lt;c-[&gt; | 切换到普通模式 |
| o/O/a/A/i/I | 普通模式切换到插入模式 |
| &lt;c-o&gt; | 切换到插入-普通模式 |

插入-普通模式是普通模式的一个特例，它能让我们执行一次普遍模式命令。在此
模式中，我们可以执行一个普通模式命令，执行完后，马上就又返回到插入模式
在当前行正好处于窗口顶部或底部时，有时我会滚动一下屏幕，以便看到更多的
上下文。用 zz 命令可以重绘屏幕，并把当前行显示在窗口正中，这样就能够阅读当
前行之上及之下的半屏内容。

##用字符编码插入非常用字符
Vim 可以用字符编码（Character Code）插入任意字符。使用此功能可以很方便地
输入键盘上找不到的符号，Vim 所接受的字符编码共包含 3 位数字。例如，假设我们想插入大写字母“A”， 它的字符编码是 65，因此我们需要输入&ltC-v&gt065 

##用替换模式替换已有文本

| 按键 | 用途 | 
| ------ | ------ |
| r/R | 替换之前的文本 |

## 自动补全

| 按键 | 用途 | 
| ------ | ------ |
| &lt;c-n&gt;\&lt;c-p&gt; | 补全缓冲区能匹配到的字符串 |
| &lt;c-x-f&gt;| 路径补全 |
| &lt;c-x-]&gt;| ctags标签文件补全 |
| &lt;c-x-l&gt;| 整行补全 |
| &lt;c-x-k&gt;| 整行补全 |

> 把下载或者自定义的字典文件放到/usr/share/dict/目录下，set dictionary=/usr/share/dict/nim012.dict



python 代码的自动补全需要插件的支持

#命令行模式
Vim 的先祖是 vi，正是 vi 开创了区分模式编辑的范例。相应的，vi 奉一个名为 ex
的行编辑器为先祖,Ex的优点是命令影响范围广且距离远

| 按键 | 用途 | 
| ------ | ------ |
| : | 普通模式切换到命令行模式 |
| [range]delete [x] | 删除指定范围内的行[到寄存器 x 中] |
| [range]yank [x] | 复制指定范围的行[到寄存器 x 中] |
| [range]copy {address}  | 把指定范围内的行拷贝到 {address} 所指定的行之下 |
| [range]move {address}  | 把指定范围内的行复制到 {address} 所指定的行之下 |
| [range]join  | 连接指定范围内的行 |
| [range]normal {commands}  | 对指定范围内的每一行执行普通模式命令 {commands} |
| :6t.  | 把第6行的内容复制到当前行下方 |
| [range]substitute/{pattern}/{string}/[flags]  | 把指定范围内出现{pattern}的地方替换为{string} |

## 自动补全Ex命令

> :&lt;c-d&gt;  &lt;c-d&gt;命令可以显示补全列表
> 把当前的单词插入命令行， <C-r><C-w> 映射项会复制光标下的单词并把它插入到命

令行中。我们可以利用这一功能减少击键的次数。
eg: 假设我们想把下面这段代码中的变量 tally 重命名为 counter
```
var tally;
for (tally=1; tally <= 10; tally++) {
// do something with tally
}
```
###回溯历史命令
```
q/ /<c-f> 将打开一个命令行窗口，里面记录着刚才输入的历史查找
q:/:<c-f> 将打开一个命令行窗口，里面记录着刚才输入的历史ex命令
```
### 执行外部命令
!{cmd}
> :w !sudo tee % 强制保存没有权限的机器

#可视模式
只要可能，最好用操作符命令，而不是可视命令
可视模式可能比 Vim 的普通模式操作起来更自然一些，但是它有一个缺点：在这
个模式下 . 命令有时会有一些异常的表现。我们可以用普通模式下的操作符命令来规
避此缺点
eg:假设我们想把下面列表中的链接文字转换为大写格式
```
<a href="#">one</a>
<a href="#">two</a>
<a href="#">three</a>
```

##列可视模式
##行可视模式
eg:我们想用管道符画一条竖线来隔开这两列文本，使之看起来更像一个表格。但是
在此之前，要先减少两列之间的间隔，使它们不要分得这么开。
```
Chapter                   Page
Normal                    mode 15
Insert                    mode 31
Visual                    mode 44
```
> {start} x... gv r|

### 选择模式
```
在一个典型的文本编辑器环境中，当选中一段文本后，再输入任意可见字符时，
这些选中的文本将会被删除。虽然 Vim 的可视模式未遵从此惯例，但是其选择模式
（ Select Mode ）却按此方式工作。根据 Vim 的内置文档所述，选择模式“类似于 Microsoft
Windows 的选择模式”（参见 :h Select-mode ）。在此模式下，输入的可见字符会使
所选中的文本被删除，同时 Vim 会进入插入模式，并插入这个可见字符。
按 <C-g> 可以在可视模式及选择模式间切换。切换后看到的唯一不同是屏幕下方的提
示信息会在 “-- 可视 --”（ -- VISUAL -- ）及“--选择--”（ --SELECT-- ）间转换。但是，如果
在选择模式中输入任意可见字符的话，此字符会替换所选内容并切换到插入模式。当然，
如果是在可视模式中，你仍可以像往常一样用 c 键来修改所选内容
```
