set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set nocompatible    "非兼容模式  
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
set fileencodings=ucs-bom,UTF-8,GBK,BIG5,latin1  
set fileencoding=UTF-8  
set fileformat=unix "换行使用unix方式  
set ambiwidth=double  
set noerrorbells    "不显示响铃  
set visualbell      "可视化铃声  
set foldmarker={,}  "缩进符号  
"set foldmethod=indent   "缩进作为折叠标识  
set foldopen-=undo  "撤销时不打开折叠  
set updatecount=0   "不使用交换文件  
set magic           "使用正则时，除了$ . * ^以外的元字符都要加反斜线  
  
"缩进定义  
set shiftwidth=4  
set tabstop=4  
set softtabstop=4  
set expandtab  
set smarttab  
set backspace=2     "退格键可以删除任何东西  
"显示TAB字符为<+++  
"set list  
"set list listchars=tab:<+  
  
"映射常用操作  
map <F5> :!python.exe %<cr>
map <F2> : :NERDTree<cr>
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

let g:pydiction_location = 'D:\Program Files (x86)\Vim\vim80\ftplugin\complete-dict'

let g:pydiction_menu_height = 20
set encoding=utf-8
source $VIMRUNTIME/delmenu.vim  
  
source $VIMRUNTIME/menu.vim  
language messages zh_CN.utf-8
set tags="G:\gitforhub\practice14\tags"
set paste
" 在浏览器预览 for win32

function! ViewInBrowser(name)
    let file = expand("%:p")
    exec ":update " . file
    let l:browsers = {
        \"cr":"D:/WebDevelopment/Browser/Chrome/Chrome.exe",
        \"ff":"D:/program files/Mozilla Firefox/firefox.exe",
        \"ie":"C:/progra~1/intern~1/iexplore.exe",
        \"ie6":"D:/WebDevelopment/Browser/IETester/IETester.exe -ie6",
        \"ie7":"D:/WebDevelopment/Browser/IETester/IETester.exe -ie7",
        \"ie8":"D:/WebDevelopment/Browser/IETester/IETester.exe -ie8",
        \"ie9":"D:/WebDevelopment/Browser/IETester/IETester.exe -ie9",
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
nmap <f4>ie :call ViewInBrowser("ie")<cr>
    
map <F3> :call TitleDet()<cr>'s
function AddTitle()
    call append(0,"/*=============================================================================")
    call append(1,"#")
    call append(2,"# Author: zhouzhibo")
    call append(3,"#")
    call append(4,"# QQ : 1400045186")
    call append(5,"#")
    call append(6,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(7,"#")
    call append(8,"# Filename: ".expand("%:t"))
    call append(9,"#")
    call append(10,"# Description: ")
    call append(11,"#")
    call append(12,"=============================================================================*/")
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

map <F9> :only <cr>
set nocompatible
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

filetype plugin on
