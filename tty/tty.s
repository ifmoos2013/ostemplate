section .text

global tty_clear
global tty_puts
global tty_putc
global tty_endl
global tty_set_style

;;; Clear the screen
tty_clear:
	mov edi, video_start
	mov ecx, 4000
	.loop:
	mov byte [edi + ecx], 0
	loop .loop
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
	;; if cursor_pos = 80 * x + y then cursor_pos := 80 * (x + 1)
	;; TODO
	ret

;;; Address of the start of the video memory
video_start: equ 0xB8000

section .data
;;; Cursor position (assuming that screen has size 80x25)
text_style: db 0x07
cursor_pos: dw 0
