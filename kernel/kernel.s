section .text
global kmain

;;; Entry point of the kernel.
kmain:
	jmp $ 			; Infinity cycle
