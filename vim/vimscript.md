#vim脚本学习

##变量
* 数字

* 字符串
    * 字符串连接使用'.'进行连接。
    * 布尔值判断时所有的非零数字都为真，非空字符串也为假。
    * strlen、split、join、tolower等字符串处理函数
    * 字符串一般使用==#以及==?来实现大小写敏感的比较。
* 特殊字符
    * echo命令会转义后输出。
    * echom 显示换行tab等不可打印字符，不解释（unprintable characters are displayed, not interpreted）
    * 单引号类似于python的r'',原样输出。
* 列表

* 字典
* 变量的作用域
使用let进行变量赋值，echo打印变量的值,unlet销毁变量。对于Vim选项还可用set来更方便地操作，比如set{option},set
no{option},set{option}?。普通变量可以直接引用，环境变量要加前缀$、寄存器变量要加前缀@、Vim选项要加前缀&。
变量默认作用域取决于定义的位置，函数内则为函数作用域，外部则为全局变量。赋值和引用变量时可以使用b:,g:,l:,t:等前缀来指定要操作哪个作用域的变量
```
|buffer-variable|    b:	  Local to the current buffer.
|window-variable|    w:	  Local to the current window.
|tabpage-variable|   t:	  Local to the current tab page.
|global-variable|    g:	  Global.
|local-variable|     l:	  Local to a function.
|script-variable|    s:	  Local to a |:source|'ed Vim script.
|function-argument|  a:	  Function argument (only inside a function).
|vim-variable|       v:	  Global, predefined by Vim.
```
可查阅 :help internal-variables 获取更多变量作用域的使用方式。
##流程语句
* 分支
* 循环

##函数


## [脚本编码规范](https://spacevim.org/cn/conventions/#vim-%E8%84%9A%E6%9C%AC%E4%BB%A3%E7%A0%81%E8%A7%84%E8%8C%83)

#实例
自定义motion
```
nmap <silent> <F4> :set opfunc=CountSpaces<CR>g@
vmap <silent> <F4> :<C-U>call CountSpaces(visualmode(), 1)<CR>

function! CountSpaces(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	if a:0  "可视模式里调用，使用 gv 命令."
		silent exe "normal! gvy"
	elseif a:type == 'line'
		silent exe "normal! '[V']y"
	else
		silent exe "normal! `[v`]y"
	endif

	echomsg strlen(substitute(@@, '[^ ]', '', 'g'))

	let &selection = sel_save
	let @@ = reg_save
	endfunction
```
