#include <dos.h>
#include <stdio.h>
#include <conio.h>

void interrupt (*oldhandler)( );

void interrupt newhandler( )
{
    _asm {
        pushf
        pop  ax
        test ah,8
        jz   noov
        mov  al,0
    noov:
        and  ah,0F6h
        push ax
        popf
        iret
    }
}

int main()
{
    oldhandler = getvect(0x04);
    setvect(0x04, newhandler);

    printf("Custom INTO handler installed\n");
    printf("Testing signed overflow...\n");

    _asm {
        mov  al,127
        add  al,100        /* 127 + 100 = overflow -> trigger INTO */
    }

    printf("After overflow AL = %d (should be 0)\n", _AL);

    _asm {
        mov  ax,0x8000
        mov  bl,-1
        idiv bl            /* another overflow case */
    }
    printf("After division AL = %d (should be 0)\n", _AL);

    setvect(0x04, oldhandler);
    printf("Original handler restored\n");
    printf("Press any key to exit...");
    getch();
    return 0;
}