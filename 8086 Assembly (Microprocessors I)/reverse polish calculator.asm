org 100h

name "reverse polish calculator"

jmp start           ; skips declarations 

;;;;;;;;;;;;;;;;;;;;;;;; macro definitions ;;;;;;;;;;;;;;;;;
include 'emu8086.inc' ; emulator macros defined here 

; emulator procedure definitions macros
DEFINE_SCAN_NUM       ; gets a num, results are stored in CX                         
DEFINE_PRINT_NUM      ; prints the number in AX
DEFINE_PRINT_NUM_UNS  ; prints the unsigned number in AX
DEFINE_GET_STRING     ; gets a string,buffer size is DX
; used macros are
; PRINTN 'string'     ; prints a string and a newline
; PRINT  'string'     ; prints a string 
;;;;;;;;;;;;;;;;;;;;;;;; end macro definitions ;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;; variable definitions ;;;;;;;;;;;;;;;;;

; two operands 16 bits
num1 dw ?
num2 dw ?
result_l dw ?
result_h dw ?                                                           
; operator 8 bits
operator db ?                                                           
                                                                                                                      
;;;;;;;;;;;;;;;;;;; end variable definitions ;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;; procedure definitions ;;;;;;;;;;;;;;;;;;

print_welcome proc      ;prints welcome and instructions
    PRINTN 'welcome to the accumulating calculator [reverse polish calculator] program'
    PRINTN 'instructions:'
    PRINTN '- first,enter the initial accumulator value (first operand) '
    PRINTN '- then enter the second operand'
    PRINTN '- enter the operator (+,-,*,/) '
    PRINTN '- the result of the operation [ op1 operator op2 ] should appear'
    PRINTN '- the result is stored at the accumulator, you will be prompted to enter another operand and another operator'
    PRINTN '- the program keeps repeating in this manner...'
    PRINTN ' '
endp

get_first_operand proc  ; gets a signed 16bit number from user
    PRINT 'please enter the first operand >'
    call SCAN_NUM   ; result stored in CX 
    mov num1,CX
    ret
endp

get_second_operand_and_operator proc 
    push CX
    PRINTN ' '
    PRINT 'please enter the second operand >'
    call SCAN_NUM   ; result stored in CX
    mov num2,CX
    PRINTN ' '
    PRINT 'please enter the operator + _ / * >'
    mov dx,2        ; operator is one byte, buffer size=1
    call GET_STRING
    PRINTN ' '
    mov bl,DS:[DI] ; stores the char in operator variable
    mov operator,bl
    pop cx
    ret
endp
     
calculate_and_result proc 
    cmp operator,'+'
    je plus

    cmp operator,'-'
    je minus
    
    cmp operator,'*'
    je multiply
    
    cmp operator,'/'
    je divide
        
    wrong_operator:
    PRINTN 'enter a correct operator !! '    
    ret
    
    plus:
    add ax,num2
    mov result_l,ax
    PRINT 'the result is > '
    call PRINT_NUM
    PRINTN ' '
    ret
    
    minus:
    sub ax,num2
    mov result_l,ax
    PRINT 'the result is > '
    call PRINT_NUM
    PRINTN ' '
    ret
    
    multiply:
    imul num2    
    PRINT 'the result is > '
    call PRINT_NUM 
    ret
    
    divide:
    mov dx,0
    div num2
    mov result_l,ax
    mov result_h,dx    
    PRINT 'the quotient is > '
    call PRINT_NUM
    PRINTN ' '
       
    mov ax,dx
    PRINT 'the remainder is > '
    call PRINT_NUM
    PRINTN ' '
    mov ax,result_l
    ret
    
endp

    
;;;;;;;;;;;;;;;;;; end procedure definitions ;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;; main program flow ;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
    call print_welcome
    call get_first_operand
    mov AX,num1     
    mov cx,10       ; allows 10 successive operations
    accumulate:
        call get_second_operand_and_operator
        call calculate_and_result
        loop accumulate
    ret  
    
;;;;;;;;;;;;;;; end main program flow ;;;;;;;;;;;;;;;;;;;;;;


