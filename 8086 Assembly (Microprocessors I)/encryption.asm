#make_bin#

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=0500h#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0500h#	; same as loading segment
#IP=0000h#	; same as loading offset

; set segment registers
#DS=0800h#	; same as loading segment
#ES=0800h#	; same as loading segment

; set stack
#SS=0300h#	; same as loading segment
#SP=FFFEh#	; set to top of loading segment


jmp start ; skipping decalarations


;;;;;;;;;; variable and constants  definitions ;;;;;
BUFFER_SIZE equ 17 ; 15 bytes+ carriage return + NULL

MESSAGE_OFFSET               equ 0100h
ENCRYPTED_MESSAGE_OFFSET     equ 0140h
DECRYPTED_MESSAGE_OFFSET     equ 0180h
TRIMMED_ENC_MESSAGE_OFFSET   equ 0220h
TRIMMED_DEC_MESSAGE_OFFSET   equ 0260h
ENCRYPTION_INDEX_LUT_OFFSET  equ 0300h

;;;;;;;;;; variable and constants  definitions ;;;;;

;;;;;;;;;;;;;;;;;;;; macro definitions ;;;;;;;;;;;;;
include 'emu8086.inc' ; emulator macros defined here 

; This macro defines a procedure to get a null terminated
; string from user, the received string is written to buffer
; at DS:DI, buffer size should be in DX.
; Procedure stops the input when 'Enter' is pressed.
DEFINE_GET_STRING      

; this macro defines a procedure to print a null terminated
; string at current cursor position,
; receives address of string in DS:SI
DEFINE_PRINT_STRING

;;;;;;;;;;;;;;;;;;;; macro definitions ;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;; procedure definitions ;;;;;;;;;;;

; prints welcome message and instructions
welcome proc
    PRINTN 'welcome to string encryption software'
    PRINTN 'instructions:'
    PRINTN '-you will be asked to enter a word 16 chars or less'
    PRINTN '-the encrypted word is printed'
    PRINTN '-the program decrypts the encrypted word and prints the result'
    PRINTN ' '
    PRINTN ' '
    ret        
endp

; receives user input string and stores it at ds:[MESSAGE_OFFSET]
get_user_input proc
    PRINT 'please enter a 16 char or less string >'
    mov dx,BUFFER_SIZE
    mov di,MESSAGE_OFFSET
    call GET_STRING
    PRINTN ''
    ret    
endp

; fills the encryption index look up table 
fill_lut proc
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET],0
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+1],8
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+2],4
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+3],12
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+4],2
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+5],10
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+6],6
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+7],14
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+8],1
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+9],9
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+10],5
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+11],13
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+12],3
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+13],11
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+14],7
    mov ds:[ENCRYPTION_INDEX_LUT_OFFSET+15],15
    ret
endp

 
; encrypts stored string and re-stores it
encrypt proc
    mov cx,16
    scan_loop:
        mov bx,16
        sub bx,cx      ; now bx has char index (0:15)
        mov dl,ds:[bx+MESSAGE_OFFSET] ; dl now has char
        
        mov bl,ds:[bx+ENCRYPTION_INDEX_LUT_OFFSET]   ; now bx has new encrypted char index
        and bx,00ffh
        mov ds:[bx+ENCRYPTED_MESSAGE_OFFSET],dl ; storing char at encrypted index
        loop scan_loop
    ret   
endp

; trims null characters from encrypted string
trim_enc_message proc
    mov cx,16
    mov si,0
    trim_loop:
        mov bx,16
        sub bx,cx      ; bx now has char index (0:15)
        mov dl,ds:[ENCRYPTED_MESSAGE_OFFSET+bx] ; dl has encrypted char
        cmp dl,0
        jne store_non_zero_char
        loop trim_loop
    ret
    store_non_zero_char:
        mov ds:[TRIMMED_ENC_MESSAGE_OFFSET+si],dl
        inc si
        dec cx
        jmp trim_loop    
    
endp        

; decrypts the message
decrypt proc
    mov cx,16
    scan_loop2:
        mov bx,16
        sub bx,cx      ; now bx has char index (0:15)
        mov dl,ds:[bx+ENCRYPTED_MESSAGE_OFFSET] ; dl now has char
        
        mov bl,ds:[bx+ENCRYPTION_INDEX_LUT_OFFSET]   ; now bx has new decrypted char index
        and bx,00ffh
        mov ds:[bx+DECRYPTED_MESSAGE_OFFSET],dl ; storing char at decrypted index
        loop scan_loop2
    ret   
endp

; trims null characters from decrypted string
trim_dec_message proc
    mov cx,16
    mov si,0
    trim_loop2:
        mov bx,16
        sub bx,cx      ; bx now has char index (0:15)
        mov dl,ds:[DECRYPTED_MESSAGE_OFFSET+bx] ; dl has encrypted char
        cmp dl,0
        jne store_non_zero_char2
        loop trim_loop2
    ret    
    store_non_zero_char2:
        mov ds:[TRIMMED_DEC_MESSAGE_OFFSET+si],dl
        inc si
        dec cx
        jmp trim_loop2
endp 

; prints encrypted message
print_enc_message proc
    PRINT 'the encrypted message is > '
    mov si,TRIMMED_ENC_MESSAGE_OFFSET
    call PRINT_STRING
    PRINTN ''    
    ret    
endp

; prints decrypted message
print_dec_message proc
    PRINT 'the decrypted message is > '
    mov si,TRIMMED_DEC_MESSAGE_OFFSET
    call PRINT_STRING
    PRINTN ''
    ret    
endp

; clears buffers between iterations, so that no residual data is left 
clear_buffers proc
    mov cx,16
    mov ax,0
    clr_loop:
        mov bx,16
        sub bx,cx
        mov ds:[MESSAGE_OFFSET+bx],al
        mov ds:[ENCRYPTED_MESSAGE_OFFSET+bx],al
        mov ds:[TRIMMED_ENC_MESSAGE_OFFSET+bx],al
        mov ds:[TRIMMED_DEC_MESSAGE_OFFSET+bx],al
        mov ds:[DECRYPTED_MESSAGE_OFFSET+bx],al
        loop clr_loop
    ret
endp


;;;;;;;;;;;;;;;;;; procedure definitions ;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;; main program flow ;;;;;;;;;;;;;
start:

; pseudocode ::
; welcome and instructions
; take user input string and store
; encrypt string and store
; trim encrypted string
; print trimmed encrypted string
; decrypt the encrypted string
; trim the decrypted string
; print the trimmed decrypted string
; loop to 2

    ;call welcome
    call fill_lut
main:
    call clear_buffers
    call get_user_input
    call encrypt
    call trim_enc_message
    call print_enc_message
    
    PRINTN 'now doing the decryption of the trimmed encrypted message...'    
    
    call decrypt     
    call trim_dec_message
    call print_dec_message
    jmp main

ret
;;;;;;;;;;;;;;;;;;;; main program flow ;;;;;;;;;;;;;



