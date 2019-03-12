#普通模式 

##减少重复的操作（结识.范式）
它之所以能高效地重复，是因为它会记录我们最
近的操作，让我们用较少的按键就能重复上次的修改。   
&emsp;Example: 
```
source：
.blog, .news { background-image: url (/ sprite.png ); }
.blog { background-position: 0px 0px }

target：
.blog, .news { background-image: url (/ sprite.png ); }
.blog { background-position: 180px 0px }
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

##Operator-pending模式 
###操作符 + 动作命令 = 操作 
d{motion} 命令可以对一个字符（ dl ）、一个完整单词（ daw ）或一整个段落（ dap
）进行操作，它作用的范围由动作命令决定。 c{motion} 、 y{motion} 以及其他一些命令
也类似，它们被统称为操作符（operator）。你可以用 :h operator 来查阅完整的列表

| 按键 | 操作 | 移动 |
| ------ | ------ | ------ | 
| dw | 删除 | 到下一个单词 |
| ci( | 复制 | 在括号内 | 
####自定义操作符 
####自定义动作命令(Operator-Pending映射)
> :onoremap b /return&lt;cr&gt; 如果执行Vim把整个函数体中直到return上面的内容都删除了  
> :onoremap &lt;silent&gt; F :&lt;C-U&gt;normal! 0f(hviw&lt;CR&gt; 
> 可以通过v可视模式来选中非光标作为起始位置,&lt;C-U&gt;是为了remove the range。

#####Normal命令
* 避免映射
> :nnoremap G dd  
> normal! G 脚本中通过这种方式来避免用户自动映射来影响脚本功能
* 特殊字符
> normal! /foo&lt;cr&gt; 无法解释特殊字符，通过Execute命令解释特殊字符
> 类似于shell或python脚本中的eval命令

#插入模式



#命令行模式



#可视模式
##列可视模式
##行可视模式
##块可视模式
