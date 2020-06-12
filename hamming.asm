.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern fscanf: proc
extern printf: proc
extern fprintf: proc
extern scanf: proc
extern fopen: proc
extern fclose: proc
extern fseek: proc
include mylib.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
mode_read DB "r",0
mode_write DB "w",0
format DB "%s",0
file_name DB "fisier.in",0
fileout_name DB "rez.out",0
decimal DB "%d",0
sir DB 32 DUP(30h),0
sir_hamming DB 38 DUP(48),0
adresa_fisier_citire DD 0
adresa_fisier_scriere DD 0
message_correct DB "Correct!",0
message_incorrect DB "Error on bit %d",0
message_wrong DB "Incorect!",0
message_corrected_array DB "Correct: %s",0
options DB "Choose one option:",10,"1 - Generate Hamming Code",10,"2 - Check Hamming Code",10,0
val_option DD 0
wrongbit DD 0
newline DD 10
nr_adrese DD 1024
var_seek_cur dd 1
var2 dd 2
;aici declaram date

.code
reinit_ham proc
push EBP
mov EBP,ESP

mov ESI,[EBP+8]
mov al,30h

mov [ESI],al

add ESI,1
mov [ESI],al

add ESI,2
mov [ESI],al

add ESI,4
mov [ESI],al

add ESI,8
mov [ESI],al

add ESI,16
mov [ESI],al

mov ESP,EBP
pop EBP
ret 4
reinit_ham endp
start:
	;aici se scrie codul
	;deschidere_fisier_citire:
	push offset options
	push offset format
	call printf
	add ESP,8
	
	push offset val_option
	push offset decimal
	call scanf
	add ESP,8
	
	mov ebx,val_option
	cmp ebx,2
	je checkoption
generateoption:	
	push offset mode_read
	push offset file_name
	call fopen
	add ESP,8
	mov adresa_fisier_citire,EAX
	
	push offset mode_write
	push offset fileout_name
	call fopen
	add ESP,8
	mov adresa_fisier_scriere,EAX
	
	mov ECX,nr_adrese
	
citire_sir:
	push ECX
	
	push offset sir
	push offset format
	push adresa_fisier_citire
	call fscanf
	add ESP,12
	
	push offset sir_hamming
	call reinit_ham
	
	push offset sir_hamming
	push offset sir
	call generate_hamming
	
	push offset sir_hamming
	push offset format
	call printf
	add ESP,8
	
	push offset newline
	push offset format
	call printf
	add ESP,8
	
	push offset sir_hamming
	push offset format
	push adresa_fisier_scriere
	call fprintf
	add ESP,12
	
	push offset newline
	push offset format
	push adresa_fisier_scriere
	call fprintf
	add ESP,12
	
	pop ECX
	sub ECX,1
	cmp ECX,0
	jnz citire_sir
	jmp finalizare
	
checkoption:
	push offset mode_read
	push offset fileout_name
	call fopen
	add ESP,8
	mov adresa_fisier_scriere,eax
	
	mov ECX,nr_adrese
citire_sir_hamming:
	push ECX
	
	push offset sir_hamming
	push offset format
	push adresa_fisier_scriere
	call fscanf	
	add ESP,12
	
	;push var_seek_cur
	;push var2
	;push adresa_fisier_scriere
	;call fseek
	;add ESP,12
	;add var2,40
	
	mov EDX,0
	push offset sir_hamming
	call check_hamming
	
	mov wrongbit,edx
	
	cmp wrongbit,0
	je no_error
show_error:
	push offset message_wrong
	push offset format
	call printf
	add ESP,8
	
	push offset newline
	push offset format
	call printf
	add ESP,8
	
	push wrongbit
	push offset message_incorrect
	call printf
	add ESP,8
	
	push offset newline
	push offset format
	call printf
	add ESP,8
	
	lea ESI,sir_hamming
	add ESI,wrongbit
	sub ESI,1
	
	mov bl,30h
	mov cl,31h
	
	mov AL,[ESI]
	cmp AL,30h
	je process1
	
	mov [ESI],bl
	jmp skip1
process1:
	mov [ESI],cl
skip1:
	push offset sir_hamming
	push offset message_corrected_array
	call printf
	add ESP,8
	push offset newline
	push offset format
	call printf
	add ESP,8
	jmp dont_print_ok
no_error:
	push offset message_correct
	push offset format
	call printf
	add ESP,8
	push offset newline
	push offset format
	call printf
	add ESP,8
	
dont_print_ok:
	pop ECX
	sub ECX,1
	cmp ECX,0
	jnz citire_sir_hamming
finalizare:
	;terminarea programului
	push 0
	call exit
end start
