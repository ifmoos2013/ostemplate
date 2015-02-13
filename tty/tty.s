section .text

global tty_clear
global tty_puts
global tty_putc
global tty_endl
global tty_set_style

;;; Clear the screen
tty_clear:
	push edi
	push ecx

	mov edi, video_start
	mov ecx, video_memory_size_d
	mov eax, 0
	repe stosd
	pop ecx
	pop edi
	ret

;;; Set text style
;;; al = (background_color << 4) + foreground_color
;;; where background_color from 0 to 15
;;; and   foreground_color from 0 to 15
tty_set_style:
	mov byte [text_style], al
	ret

;;; Put string to the cursor position
;;; esi -- zero-ended string
tty_puts:	
	push eax
	push esi

	.loop:
	mov al, [esi]
	test al, al
	jz .end_loop
	call tty_putc
	inc esi
	jmp .loop
	.end_loop

	pop esi
	pop eax
	ret

;;; Put char to the cursor position
;;; al -- character. Character with code 10 means line end.
tty_putc:
	cmp al, 10
	jne .put_char
	call tty_endl
	ret
	.put_char:
	push ebx
	push eax
	mov ebx, video_start 
	add ebx, [cursor_pos]
	add ebx, [cursor_pos]
	mov ah, [text_style]
	mov [ebx], ax
	inc word [cursor_pos]
	pop eax
	pop ebx
	ret

;;; Change cursor position to the start of the next line.
tty_endl:
	push eax
	push edx
	push ecx

	mov dx, 0
	mov ax, [cursor_pos]
	mov cx, screen_width
	div cx
	sub [cursor_pos], dx
	add word [cursor_pos], screen_width

	pop ecx
	pop edx
	pop eax
	ret

;;; Address of the start of the video memory
video_start: equ 0xB8000
screen_width: equ 80
screen_height: equ 25
video_memory_size_d: equ (screen_width * screen_height) / 2

section .data
text_style: db 0x07
align 4
cursor_pos: dw 0
