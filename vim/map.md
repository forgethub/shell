##map映射（mappings）
键映射用于改变输入键的含义。最常见的用途是把功能键定义为一系列的命令。比如: 
```
 :map <F2> a<C-R>=strftime("%c")<CR><Esc>
```

快捷键，或称映射，在 Vim 文档中的术语叫 "map"，它的基本用法如下：
```vim
map {lhs} {rhs}
map 快捷键 相当于按下的键序列
```

其中快捷键 `{lhs}` 不一定是单键，也可能是一个（较短的）按键序列，然后 vim 将其
解释为另一个（可能较长较复杂的）的按键序列 `{rhs}`。为方便叙述，我们将 `{lhs}`
称为“左参数”，而将 `{rhs}` 称为“右参数”。左参数是源序列，也可叫被映射键，右参
数是目标序列，也可叫映射键。

例如，在 vim 的默认解释下，普通模式下大写的 `Y` 与两个小写的 `yy` 是完全相同的
功能，就是复制当前行。如果你觉得这浪费了快捷键资源，可将 `Y` 重定义为复制当前
行从当前光标列到列尾的部分，用下面这个映射命令就能实现：
```vim
: map Y y$
```

然而，映射虽然初看起来简单，其中涉及的门道还是很曲折的。让我们先回顾一下 Vim
的模式。

### Vim 的主要模式

模式是 Vim 与其他大多数编辑器的一个显著区别。在不同的模式下，vim 对用户按键的
响应意义有根本的差别。Vim 支持很多种模式，但最主要的模式是以下几种：

* 普通模式，这是 Vim 的默认模式，在其他大多模式下按 `<Esc>` 键都将回到普通模式
  。在该模式下按键被解释为普通命令用以完成快速移动、查找、复制粘贴等操作。
* 插入模式，类似其他“正常”编辑的模式，键盘上的字母、数字、标点等可见符号当作直
  接的字符插入到当前缓冲文件中。从普通模式进入插件模式的命令有：`aAiIoO`
  - `a` 在当前光标后面开始插入，
  - `i` 在当前光标之前开始插入，
  - `A` 在当前行末尾开始插入，
  - `I` 在当前行末首开始插入，
  - `o` 在当前行下面打开新的一行开始插入，
  - `o` 在当前行上面打开新的一行开始插入。
* 可视模式（visual），非正式场合下也可称之为“选择”模式。在该模式下原来的移动命
  令变成改变选区。选区文本往往有不同的高亮模式，使用户更清楚地看到后续命令将要
  操作的目标文本区域。从普通模式下，有三个键分别进入三种不同的可视模式：
  - `v` （小写 v）字符可视模式，可以按字符选择文本，
  - `V` （大写 V）行可视模式，按行选择文本（jk有效，hl无效），
  - `Ctrl-v` 列块可视模式，可选择不同行的相同一列如几列。
  （Vim 还另有一种 "select" 模式，与可视模式的选择意义不同，按键输入直接覆盖替
  换所选择的文本）
* 命令行模式。就是在普通模式时按冒号 `:` 进入的模式，此时 Vim 窗口最后一行将变
  成可编辑输入的命令行（独立于当前所编辑的缓冲文件），按回车执行该命令行后回到
  普通模式。
  本教程所说的 VimL 语言其实不外也是可以在命令行中输入的语句。此外还有一种“Ex
  模式”，与命令行模式类似，不过在回车执行完后仍停留在该模式，可继续输入执行命
  令，不必每次再输入冒号。在“Ex模式”下用 `:vi` 命令才回到普通模式。

大部分初、中级 Vim 用户只要掌握这四种模式就可以了。对应不同模式，就有不同的映
射命令，表示所定义的快捷键只能用于相应的模式下：

* 普通模式：nmap
* 插入模式：imap
* 可视模式：vmap （三种不同可视模式并不区分，也包括选择模式）
* 命令模式：cmap

如果不指定模式，直接的 `map` 命令则同时可作用于普通模式与可视选择模式以及命令
后缀模式（Operator-pending，后文单独讲）。而 `map!` 则同时作用于插入模式与命令
行模式，即相当于 `imap` 与 `cmap` 的综合体。其实 `vmap` 也是 `xmap`（可视模式
）与 `smap` （选择模式）的综合体，只是 `smap` 用得很少，`vmap` 更便于记忆（`v`
命令进入可视模式），因此我在定义可视选择模式下的快捷键时倾向于用 `vmap`。

在其他情况下，建议用对应模式的映射命令，也就是将模式简名作为 `map` 的限定前缀。
而不建议用太过宽泛的 `map` 或 `map!` 命令。

### 特殊键表示

在 `map` 系列命令中，`{lhs}` 与 `{rhs}` 部分可直接表示一般字符，但若要映射（或
被映射）的不可打印字符，则要特殊的标记（`<>`尖括号内不分大小写）：

* 空格：`<Space>` 。映射命令之后的各个参数要用空格分开，所以若正是要重定义空格
  键意义，就得用 `<Space>` 表示。同时映射命令尽量避免尾部空格，因为有些映射会
  把尾部空格当作最后一个参数的一部分。始终用 `<Space>` 是安全可靠的。
* 竖线：`<BAR>`。`|` 在命令行中一般用于分隔多条语句，因此要重定义这个键要用
  `<BAR>` 表示。
* 叹号：`<Bang>`。`!` 可用于很多命令之后，用以修饰该命令，使之做一些相关但不同
  的工作，相当于特殊的额外参数。映射中要用到这个符号最好也以 `<Bang>` 表示。
* 制表符：`<Tab>`，回车：`<CR>`
* 退格：`<BS>`，删除键： `<DEL>`，插入键： `<Ins>`
* 方向键：`<UP>` `<DOWN>` `<LEFT>` `<RIGHT>`
* 功能键：`<F1>` `<F2>` 等
* Ctrl 修饰键：`<C-x>` （这表示同时按下 Ctrl 键与 x 键）
* Shift 修饰键：`<S->`，对于一般字母，直接用大写字母表示即可，如 `A` 即可，不
  必有`<S-a>`。一般对特殊键可双修饰键时才用到，如 `<C-S-a>`。
* Alt `<A->` 或 Meta `<M->` 修饰键。在 term 中运行的 vim 可能不方便映射这个修
  饰键。
* 小括号：`<lt>`，大括号 `<gt>`
* 直接用字符编码表示：`<Char->`，后面可接十进制或十六进制或八进制数字。如
  `<Char-0x7f>` 表示编码为 `127` 那个字符。这种方法虽然统一，但如有可能，优先
  使用上述意义明确方便识记的特殊键名表示法。

### 键映射链的用途与陷阱

键映射是可传递的，例如若有以下映射命令：
```vim
: map x y
: map y z
```
当用户按下 `x`，vim 首先将其解释为相当于按下 `y`，然后发现 `y` 也被映射了，于
是最终解释为相当于按下 `z`。

这就是键映射的传递链特性。那这有什么用呢，为什么不直接定义为 `:map x z` 呢？假
如 `z` 是个很复杂的按键命令，比如 `LongZZZZZZZ`，那么就可先为它定义一个简短的
映射名，如 `y`：
```vim
: map y LongZZZZZZZ
: map x1 y
: map x2 y
```
然后再可以将其他多个键如 `x1` 与 `x2` 都映射为 `y`，不必重复多次写
`LongZZZZZZZ` 了。然而，这似乎仍然很无趣，真正有意义的是用于 `<Plug>`。

假设在某个插件文件中有如下映射命令：
```vim
: map <Plug>(do_some_funny_thing) :call <SID>ActualFunction()<CR>
: map x <Plug>(do_some_funny_thing)
: map <C-x> <Plug>(do_some_funny_thing)
: map <Leader>x <Plug>(do_some_funny_thing)
```

在第一个映射命令中，其 `{lhs}` 部分是 `<Plug>(do_some_funny_thing)`，这也是一
个“按键序列”，不过第一键是 `<Plug>`（其实不可能从键盘输入的键），然后接一个左
括号，接着是一串普通字符按键，最后还是个右括号。其中左右括号不是必须的，甚至
可以不必配对，中间也不一定只能普通字符，加一些任意特殊字符也是允许的。不过当前许
多优秀的插件作者都自觉遵守这个范式：`<Plug>(mapping_name)`。

该命令的 `{rhs}` 部分是 `:call <SID>ActualFunction()<CR>`，表示调用当前脚本中
定义的一个函数，用以完成实际的工作。然而 `<Plug>...` 是不可能由用户按出来的键
序列，所以需要再定义一个映射 `:map x <Plug>...`，让一个可以方便按出的键 `x` 来
触发这个特殊键序列 `<Plug>...`，并最终调用函数工作。当然了，在普通模式的下几乎
每个普通字母 vim 都有特殊意义（不一定是 `x`，而`x`表示删除一个字符），你可能不
应该重定义这个字母按键，可加上 `<Leader>` 前缀修饰或其他修饰键。

那么为何不直接定义 `:map x :call <SID>ActualFunction()<CR>` 呢？一是为了封装隐
藏实现，二是可为映射取个易记的映射名如 `<Plug>(mapping_name)`。这样，插件作者
只将 `<Plug>(mapping_name)` 暴露给用户，用户也可以自己按需要喜好重定义触发键映
射，如 `:map y <Plug>(mapping_name)`。

因此，`<Plug>` 不过是某个普通按键序列的特殊前缀而已，特殊得让它不可能从键盘输
入，主要只用于映射传递，同时该中间序列还可取个意义明确好记的名字。一些插件作者
为了进一步避免这个中间序列被冲突的可能性，还在序列中加入插件名，比如改长为：
`<Plug>(plug_name_mapping_name)`。

不过，映射传递链可能会引起另一个麻烦。例如请看如下这个映射：
```vim
: map j gj
: map k gk
```
在打开具有长文本行的文件时，如果开启了折行显示选项（`&wrap`），则 `gj` 或 `gk`
命令表示按屏幕行移动，这可能比按文件行的 `j` `k` 移动更方便。所以这两个键的重
映射是有意义的，可惜残酷的事实是这并没有达到想要的效果。作了这两个映射命令之后
，若试图按 `j` 或 `k` 时，vim 会报错，指出循环定义链太长了。因为 vim 试图作以
下解释：
```
j --> gj --> ggj --> gggj --> ...
```
无尽循环了，当达到一些深度限制后，vim 就不干了。

为了避免这个问题， vim 提供了另一套命令，在 `map` 命令之前加上 `nore` 前缀改为
`noremap` 即可，表示不要对该命令的 `{rhs}` 部分再次解析映射了。
```vim
: noremap j gj
: noremap k gk
```

当然，前面还提到，良好的映射命令习惯是显示限定模式，模式前缀还应在 `nore` 前缀
之前，如下表示只在普通模式下作此映射命令：
```vim
: nnoremap j gj
: nnoremap k gk
```

结论就是：除了有意设计的 `<Plug>` 映射必须用 `:map` 命令外，其他映射尽量习惯用
`:noremap` 命令，以避免可能的循环映射的麻烦。例如对本节开始提出的示例规范改写
如下：
```vim
: nnoremap <Plug>(do_some_funny_thing) :<C-u>call <SID>ActualFunction()<CR>
: nmap x <Plug>(do_some_funny_thing)
: nmap <C-x> <Plug>(do_some_funny_thing)
```

其中，`:<C-u>` 并不是什么特殊语法，只不过表示当按下冒号刚进入行时先按个 `<C-u>`，
用以先清空当前命令行，确保在执行后面那个命令时不会被其他可能的命令行字符干扰。
（比如若不用 `nnoremap` 而用 `noremap` 时，在可视模式选了一部分文本后，按冒号
就会自己加成 `:'<,'>`，此时在命令行中先按 `<C-u>` 就能把前面的地址标记清除。在
很小心地用了 `nnoremap` 时，还会不会有情况情况导致干扰字符呢，也不好说，反正加
上 `<C-u>` 没坏处。但若你的函数本就设计为允许接收行地址参数，则最好额外定义 
`:vnoremap`，不用 `<C-u>` 的版本。）

### 各种映射命令

前面讲了最基础的 `:map` 命令，还有更安全的 `:noremap` 命令，以及各种模式前缀限
定的命令 `:nnoremap` `:inoremap` 等。这已经能组合出一大群映射命令了，不过它们
仍只算是一类映射命令，就是定义映射的命令。此外，vim 还提供了其他几个映射相关的
命令。

* 退化的映射定义命令用于列表查询。不带参数的 `:map` 裸命令会列出当前已重定义的
  所有映射。带一个参数的 `:map {lhs}` 会列出以 `{lhs}` 开头的映射。同样支持模
  式前缀缩小查询范围，但由于只为查询，没有 `nore` 中缀的必要。定义映射的命令，
  至少含 `{lhs}` 与 `{rhs}` 两个参数。
* 删除指定映射的命令 `:unmap {lhs}`，需要带一个完全匹配的左参数（不像查询命令
  只要求匹配开头，毕竟删除命令比较危险）。可以限定模式前缀，如 `nunmap {lhs}`
  只删除普通模式下的映射 `{lhs}`。注意，模式前缀始终是在最前面，如果你把 `un`
  也视为 `map` 命令的中缀的话。
* 清除所有映射的命令 `:mapclear`。因为清除所有，所以不需要参数了。当然也可限定
  模式前缀，如 `:nmapclear`，表示只清除普通模式下的映射。另外还可以有个
  `<buffer>` 参数，表示只清除当前 buffer 内的局部映射。这类特殊参数在下节继续
  讲解。

### 特殊映射参数

映射命令支持许多特殊参数，也用 `<>` 括起来。但它们不同于特殊键标记，并不是左
参数或右参数序列的一部分。同时必须紧跟映射命令之后，左参数 `{lhs}` 之前，并用
空格分隔参数。

* `<buffer>` 表示只影响当前 buffer 的映射，`:map` `:unmap` 与 `:mapclear` 都可
  接收这个局部参数。
* `<nowait>` 字面意思是不再等待。较短的局部映射将掩盖较长的全局映射。

`<nowait>` 这个参数很少用到。但其中涉及到的一个映射机制有必要了解。假设有如下
两个映射定义：
```vim
* nnoremap x1 something
* nnoremap x2 another-thing
```
因为定义的是两个按键的序列，当用户按下 `x` 键时，vim 会等待一小段时间，以判断
用户是否想用 `x1` 或 `x2` 快捷键，然后触发相应的映射定义。如果超过一定时间后用
户没有按任何键，就按默认的 `x` 键意义处理了。当然如果后面接着的按键不匹配任何
映射，也是按实际按键解释其意义。

因此，若还定义单键 `x` 的映射：
```vim
: nnoremap x simple-thing
```
当用户想通过按 `x` 键来触发该映射时，由于 `x1` 与 `x2` 的存在，仍然需要等待一
小段时间才能确定用户确实是想用 `x` 键来触发 `simple-thing` 这件事。这样的迟滞
效应可不是个好体验。

于是就提出 `<nowait>` 参数，与 `<buffer>` 参数联用，可避免等待：
```vim
: nnoremap <buffer> <nowait> x local-thing
```
这样，在当前 buffer 中按下 `x` 键时就能直接做 `local-thing` 这件事了。

尽管有这个效用，但 `<nowait>` 在实践中还是用得很少。用户在自行设定快捷键时，最
好还是遵循“相同前缀等长快捷键”的原则。也就说当定义 `x1` 或 `x2` 快捷键后，就最好
不要再定义 `x` 或 `x123` 这样的变长快捷键了。规划整齐点，体验会好很多。当然，
如实在想为某个功能定义更方便的快捷键快，可定义为重复按键 `xx`，因为重复按键
的效率会比按不同键快一点。（想想 vim 内置的 `dd` 与 `yy` 命令）
```vim
: nnoremap xx most-used-thing
```

另一方面，局部映射参数 `<buffer>` 却是非常常用，鼓励多用。局部映射会覆盖相同的
全局映射，而且当 `<nowait>` 存在时，会进一步隐藏全局中更长的映射。



##缩写（abbreviations）
我们可以加几个日常编辑中常用的abbreviations。 运行如下命令：
```
:iabbrev @@    steve@stevelosh.com
:iabbrev ccopy Copyright 2013 Steve Losh, all rights reserved.
```

##abbreviations和mappings的区别
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

##热键(Leader)
使用下面的命令设置前置命令
```
let mapleader = "\\"
:autocmd FileType html nnoremap <buffer> <leader>v :s/^\([[:space:]]*\)<!--\(.*\)-->$/\1\2/g<cr>
:autocmd FileType html nnoremap <buffer> <leader>c I<!--<Esc>A--><Esc>
```
这样就可以很方便的写注释了

> FileType自动命令使用setlocal对你喜欢的文件类型做一些设置。你可以针对不同的文件类型设置wrap、list、 spell和number这些选项。

##自动命令的定义语法
自动命令用 :autocmd 这个内置命令定义，它至少要求三个参数：
> : autocmd {event} {pat} {cmd}  
* {event} 就是 Vim 预设的可以监测到的事件，比如读写文件，切换窗口等。参考:help autocmd-events
* {pat} 这是模式条件的意思，一般指是否匹配当前文件。
* {cmd} 就是事件发生且满足条件时，要自动执行的命令。

常用的用法，nginx配置文件语法高亮
> autocmd BufRead,BufNewFile /usr/local/services/tengine-2.1.2/conf/* set filetype=nginx

##自动命令组
自动命令组可以避免重复执行自动命令。
常用的事件是FileType事件。这个事件会在Vim设置一个缓冲区的filetype的时候触发, 让我们针对不同文件类型设置一些有用的映射。运行命令：
```
    :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
    :autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>
```
打开一个Javascript文件（后缀为.js的文件）,将光标移动到某一行，敲击<localleader>c，光标所在的那一行会被注释掉。  
现在打开一个Python文件（后缀为.py的文件）,将光标移动到某一行，敲击<localleader>c，同样的那一行会被注释掉，不同的是此时所用的是Python的注释字符！

```
augroup type_file
    autocmd!
    au! BufNewFile,BufRead *.sls setf sls
augroup END

let mapleader = "\\"
augroup comment
    autocmd!
    nnoremap <buffer> <localleader>c I#<esc>
    nnoremap <buffer> <localleader>v :s/^\([[:space:]]*\)#\(.*\)$/\1\2/g<cr>
    autocmd FileType c,java nnoremap <buffer> <leader>c I//<esc>
    autocmd FileType c,java nnoremap <buffer> <leader>v :s#\([[:space:]]*\)//\(.*\)#\1\2#g<cr>
    autocmd FileType html nnoremap <buffer> <leader>c I<!--<Esc>A--><Esc>
    autocmd FileType html nnoremap <buffer> <leader>v :s/^\([[:space:]]*\)<!--\(.*\)-->$/\1\2/g<cr>
    autocmd FileType sls setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END
```
