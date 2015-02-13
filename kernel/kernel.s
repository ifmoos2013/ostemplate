%include "tty/tty.inc"

section .text

global kernel_main

;;; Entry point of the kernel.
kernel_main:
	call kernel_welcome

	hlt
	jmp $

kernel_welcome:
	TTY_CLEAR
	TTY_PUTS_STYLED TTY_STYLE(TTY_BLACK, TTY_YELLOW), welcome_msg
	ret

welcome_msg: db '                              Welcome to the itmOS',10
             db '                               ( \',10
             db '                                \ \',10
             db '                                / /                |\\',10
             db '                               / /     .-`````-.   / ^`-.',10
             db '                               \ \    /         \_/  {|} `o',10
             db '                                \ \  /   .---.   \\ _  ,--',39,10
             db '                                 \ \/   /     \,  \( `^^^',10
             db '                                  \   \/\      (\  )',10
             db '                                   \   ) \     ) \ \',10
             db '                                    ) /__ \__  ) (\ \___',10
             db '                                   (___)))__))(__))(__)))',10,0
