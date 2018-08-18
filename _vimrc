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
set background=dark "����ɫ  
color desert  
set ruler           "�����½���ʾ��ǰ�ļ�������  
set showcmd         "��״̬����ʾ����  
set showmatch       "��ʾƥ�������  
set ignorecase      "��Сд�޹�ƥ��  
set smartcase       "ֻ��ƥ�䣬��Сдȫƥ�䣬��Сд������ϸ�ƥ��  
set hlsearch        "����ʱ������ʾ  
set incsearch       "��������  
"set nohls           "����ʱ��������������λ����֪ʲôԭ���رս������  
set report=0        "��ʾ�޸Ĵ���  
set mouse=a         "����̨�������  
set number          "�к�  
set nobackup        "�ޱ���  
set cursorline      "������ǰ�б���  
"set fileformat=unix "����ʹ��unix��ʽ  
set updatecount=0   "��ʹ�ý����ļ�  

"gvim��������
"set guifont=������:h12:cGB2312
set guifont=courier_new:h12
"gvim�ڲ�����
set encoding=utf-8
"��ǰ�༭���ļ�����
set fileencoding=utf-8
"gvim��֧�ֱ�����ļ�
set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,big5,euc-jp,euc-kr,latin1
set langmenu=zh_CN
let $LANG = 'zh_CN.UTF-8'
"���consle�������
language messages zh_CH.utf-8
"���Ͳ˵�����
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"�����ն˱���Ϊgvim�ڲ�����encoding
let &termencoding=&encoding
"��ֹ��������޷�������ʾ
set ambiwidth=double
"�����ߴ�Ϊ4���ո�
set sw=4
"tab���Ϊ4���ַ�
set ts=4
"�༭ʱ������tab�滻Ϊ�ո�
set et
"��һ��backspace��ɾ��4���ո���
set smarttab
set backspace=indent,eol,start
 
"ӳ�䳣�ò���  
map <F5> :!D:\python\python.exe %<cr>
map <F6> I<!--<Esc>A--><Esc>
map <F7> :s/^\([[:space:]]\+\)<!--\(.*\)-->$/\1\2/g<cr>

if has("gui_running")  
    set lines=25  
    set columns=80  
    set lazyredraw  "�ӳ��ػ�  
    set guioptions-=m   "����ʾ�˵�  
    set guioptions-=T   "����ʾ������  
    set guifont=consolas\ 10  
endif  
  
set nowritebackup
set noswapfile

let Tlist_Ctags_Cmd='ctags.exe'
let Tlist_Auto_Open=1
  
set tags=F:\shell_script\tags;
set paste
" �������Ԥ�� for win32

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
"��������޸�ʱ����ļ���
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
"�ж�ǰ10�д������棬�Ƿ���Last modified������ʣ�
"���û�еĻ�������û����ӹ�������Ϣ����Ҫ����ӣ�
"����еĻ�����ôֻ��Ҫ���¼���
function TitleDet()
    let n=1
    "Ĭ��Ϊ���
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
    "Ĭ��Ϊ���
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

