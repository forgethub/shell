set nocompatible              " required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" All of your Plugins must be added before the following line
syntax on
set background=dark "背景色  
color desert  
set ruler           "在左下角显示当前文件所在行  
set showcmd         "在状态栏显示命令  
set showmatch       "显示匹配的括号  
set ignorecase      "大小写无关匹配  
set smartcase       "只能匹配，即小写全匹配，大小写混合则严格匹配  
set hlsearch        "搜索时高亮显示  
set incsearch       "增量搜索  
"set nohls           "搜索时随着输入立即定位，不知什么原因会关闭结果高亮  
set report=0        "显示修改次数  
set mouse=a         "控制台启用鼠标  
set number          "行号  
set nobackup        "无备份  
set cursorline      "高亮当前行背景  
"set fileformat=unix "换行使用unix方式  
set updatecount=0   "不使用交换文件  

"gvim字体设置
"set guifont=新宋体:h12:cGB2312
set guifont=courier_new:h12
"gvim内部编码
set encoding=utf-8
"当前编辑的文件编码
set fileencoding=utf-8
"gvim打开支持编码的文件
set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,big5,euc-jp,euc-kr,latin1
set langmenu=zh_CN
let $LANG = 'zh_CN.UTF-8'
"解决consle输出乱码
language messages zh_CH.utf-8
"解释菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"设置终端编码为gvim内部编码encoding
let &termencoding=&encoding
"防止特殊符号无法正常显示
set ambiwidth=double
"缩进尺寸为4个空格
set sw=4
"tab宽度为4个字符
set ts=4
"编辑时将所有tab替换为空格
set et
"按一次backspace就删除4个空格了
set smarttab
set backspace=indent,eol,start
 
"映射常用操作  
map <F5> :!D:\python\python.exe %<cr>
map <F6> I<!--<Esc>A--><Esc>
map <F7> :s/^\([[:space:]]\+\)<!--\(.*\)-->$/\1\2/g<cr>

if has("gui_running")  
    set lines=25  
    set columns=80  
    set lazyredraw  "延迟重绘  
    set guioptions-=m   "不显示菜单  
    set guioptions-=T   "不显示工具栏  
    set guifont=consolas\ 10  
endif  
  
set nowritebackup
set noswapfile

let Tlist_Ctags_Cmd='ctags.exe'
let Tlist_Auto_Open=1
  
set tags=F:\shell_script\tags;
set paste
" 在浏览器预览 for win32

function! ViewInBrowser(name)
    let file = expand("%:p")
    exec ":update " . file
    let l:browsers = {
        \"cr":"D:/WebDevelopment/Browser/Chrome/Chrome.exe",
        \"ff":"D:/firefox/firefox.exe",
        \"ie":"C:/progra~1/intern~1/iexplore.exe",
        \"iea":"D:/WebDevelopment/Browser/IETester/IETester.exe -all"
    \}
    let htdocs='E:\\apmxe\\htdocs\\'
    let strpos = stridx(file, substitute(htdocs, '\\\\', '\', "g"))
    if strpos == -1
       exec ":silent !start ". l:browsers[a:name] ." file://" . file
    else
        let file=substitute(file, htdocs, "http://127.0.0.1:8090/", "g")
        let file=substitute(file, '\\', '/', "g")
        exec ":silent !start ". l:browsers[a:name] file
    endif
endfunction
nmap <f4> :call ViewInBrowser("ff")<cr>
"nmap <f4>ie :call ViewInBrowser("ie")<cr>
    
map <F2> :call Titlepython()<cr>'s
map <F3> :call TitleDet()<cr>'s
function AddTitle()
    call append(0,"#!/bin/bash")
    call append(1,"#*=============================================================================")
    call append(2,"#")
    call append(3,"# Author: zhouzhibo")
    call append(4,"#")
    call append(5,"# id : 613013")
    call append(6,"#")
    call append(7,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(8,"#")
    call append(9,"# Filename: ".expand("%:t"))
    call append(10,"#")
    call append(11,"# Description: ")
    call append(12,"#")
    call append(13,"#============================================================================*/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf

function AddpythonTitle()
    call append(0,"#!/usr/bin/python3")
    call append(1,"'''")
    call append(2,"#")
    call append(3,"# Author: zhouzhibo")
    call append(4,"#")
    call append(5,"# id : 613013")
    call append(6,"#")
    call append(7,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(8,"#")
    call append(9,"# Filename: ".expand("%:t"))
    call append(10,"#")
    call append(11,"# Description: for freedom")
    call append(12,"#")
    call append(13,"'''")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
"更新最近修改时间和文件名
function UpdateTitle()
    normal m'
    execute '/# *Last modified:/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
    normal ''
    normal mk
    execute '/# *Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
    execute "noh"
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
"判断前10行代码里面，是否有Last modified这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
function TitleDet()
    let n=1
    "默认为添加
    while n < 10
        let line = getline(n)
        if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()
endfunction

function Titlepython()
    let n=1
    "默认为添加
    while n < 10
        let line = getline(n)
        if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddpythonTitle()
endfunction

map <F9> :only <cr>
filetype plugin indent on
set guioptions-=T  
set guioptions-=m

abbreviate _prt System.out.print();
abbreviate _prtl System.out.println();
runtime macros/matchit.vim

xnoremap * : <C-u>call <SID>VSetSearch() <CR>/<C-R>=@/<CR><CR>
xnoremap # : <C-u>call <SID>VSetSearch() <CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

autocmd GUIEnter * simalt ~x
filetype plugin on
let g:pydiction_location = 'D:\Vim\vimfiles\ftplugin\pydiction\complete-dict'
let g:pydiction_menu_height = 11

