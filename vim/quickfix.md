
#quickfix 代码调试功能

```
/* hello world demo */
#include <stdio.h"
int main(int argc, char **argv)
{
    int i;
    print("hello world\n");
    return 0;
} 
```
该程序包含三个小错误，我们用vim来调试代码。
首先设置编译的makeprg选项。
> :set makeprg=gcc\ -Wall\ -ohello\ hello.c 
上面的命令会把hello.c编译为名hello的可执行文件，并打开了所有的Warnning。
> :make编译 ：cw可以打开一个窗口
```
:cc                显示详细错误信息 ( :help :cc )
:cp                跳到上一个错误 ( :help :cp )
:cn                跳到下一个错误 ( :help :cn )
:cl                列出所有错误 ( :help :cl )
:cw                如果有错误列表，则打开quickfix窗口 ( :help :cw )
:col               到前一个旧的错误列表 ( :help :col )
:cnew              到后一个较新的错误列表 ( :help :cnew )
```
#也可以用来调试python代码
Plug skywind3000/asyncrun.vim
