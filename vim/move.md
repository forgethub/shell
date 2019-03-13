#快速移动和查找

##基于单行內的移动
| 命令 | 说明 |
| ------ | ------ |
| jkhl | 上下左右 |
| gj | 根据屏幕显示的行移动而非实际行 |
| w/W | 正向移动到下一个单词的开头 |
| b/B | 反向移动到当前单词/上一个单词的结尾 |
| e/E | 反向移动到当前单词/上一个单词的结尾 |
| f{char} | 跳转到{char}第一匹配char的地方 |
> 一个单词由字母、数字、下划线，或其他非空白字符的序列组成，单词间以空白
字符分隔

##文件内跳转
| 命令 | 说明 |
| ------ | ------ |
| / | 向下查找 |
| / | 向上查找 |
| { | 跳转到匹配的括号所在之处 |
| [count]G | 跳转到指定的行号 |
| H/M/L | 跳到屏幕最上方/正中间/最下方 |
| `{mark} | 跳到一个标记的位置,其中``为跳转到上一次定义的位置 |
```
/<c-f> 将打开一个命令行窗口，里面记录着刚才输入的历史查找
:<c-f> 将打开一个命令行窗口，里面记录着刚才输入的历史ex命令
```

##跨文件的快速跳转
| EX模式 | 普通模式 | 说明 |
| ------ | -------- | ---- |
| - | gt | 不同标签间的跳转 |
| - | "&lt;-w"&gt; | 不同窗口间的跳转 |
| next\previous | - | buffer缓冲区间的跳转 |
| - | gf | 跳转到光标下的文件名 |
| e# | - |[跳转到\#号寄存器所在的内容](F:\person_git\shell\vim\健步如飞.md) |

##jump list

#Ctags 和taglist安装和使用
vim的函数跳转功能需要借助于第三方插件来实现

1. [安装ctags软件](#ctags文件探秘)。  
- 在项目的根目录下执行ctags -R，为了加快速度也可以在每一级目录下执行ctags。  
- 在家目录的.vimrc文件中增加set tags=./tags;,tags。  
- [tags用技巧](#tags使用技巧)

##ctags文件探秘
```
{tagname} {TAB} {tagfile} {TAB} {tagaddress} {term} {field} ..
```
* {tagname} - 标识符名字，例如函数名、类名、结构名、宏等。不能包含制表符。
* {tagfile} - 包含 {tagname} 的文件。它不能包含制表符。
* {tagaddress} - 可以定位到 {tagname}光标位置的 Ex 命令。通常只包含行号或搜索命令。出于安全的考虑，vim会限制其中某些命令的执行。
* {term} - 设为 ;" ，这是为了兼容Vi编辑器，使Vi忽略后面的{field}字段。
* {field} .. - 此字段可选，通常用于表示此{tagname}的类型是函数、类、宏或是其它。
在{tagname}、{tagfile}和{tagaddress}之间，采用制表符(TAB符，即C语言中的"\t")分隔，也就是说{tagname}、{tagfile}的内容中不能包含制表符。 

c       类classes)  
d       宏定义(macro definitions)  
e       枚举变量(enumerators)  
f       函数定义(function definitions)  
g       枚举类型(enumeration names)  
l       局部变量(local variables)，默认不提取  
m       类、结构体、联合体(class, struct, and union members)  
n       命名空间(namespaces)  
p       函数原型(function prototypes)，默认不提取  
s       结构体类型(structure names)  
t       (typedefs)  
u       联合体类型(union names)  
v       变量定义(variable definitions)  
x       外部变量(external and forward variable declarations)，默认不提取  

##tags使用技巧

| Ex命令 | 普通模式 | 说明 |
| ------ | ------ |
|  [count]ta[g][!] {name}| "&lt;ctrl-]&gt;"(&lt;ctrl-o&gt;也可以实现类似的功能</br>但是会和tags打印出来的堆栈内容不一致，不推荐) | 向后跳转count个tag stack,如果是新增把标识符和位置压入tag stack("!"代表当前文件被修改时候放弃修改强制跳转) |
|  :[count]po[p][!]| "&lt;ctrl-t&gt;" or "&lt;ctrl-t&gt;(&lt;ctrl-i&gt;也可以实现类似的功能</br>但是会和tags打印出来的堆栈内容不一致，不推荐)"  | 向前跳转count个tag stack("!"代表当前文件被修改时候放弃修改强制跳转) |
| tags | - |输出tag stack 的内容 |
| ts[elect][!] [name]| g] | 当有函数有多个地方地方定义时推荐使用这个可以选择  |
| gd | - | 跳转到变量定义的地方(仅仅适用于函数内部跳转) |
> &lt;ctrl-w&gt;]可以打开新窗口显示选择的标签
> 终端里面的pushd,popd,dirs命令也是维护一个stack记录之前push过的目录，和这个ctags有异曲同工之妙。
##安装vim-gutentag插件(推荐)
为了解决每次文件变化后需要手工执行ctags -R重新生成tags文件的操作。[参考]（ https://zhuanlan.zhihu.com/p/43671939 ）
##安装taglist插件（比较美观）



