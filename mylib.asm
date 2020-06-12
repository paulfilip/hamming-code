.code
generate_hamming proc
push EBP
mov EBP,ESP

mov ESI,[EBP+8] ;luam primul argument care este adresa sirului sursa
mov EDI,[EBP+12] ; luam al doilea argument care este adresa sirului in care dorim sa scriem datele
;scriere_date_in_sir_hamming(se copiaza din sirul de date bitii pe pozitiile din codul hamming)
	add EDI,2
	mov ECX,1
	rep movsb ;se scrie bitul 3
	
	add EDI,1
	mov ECX,3
	rep movsb; se scriu bitii 5-7
	
	add EDI,1
	mov ECX,7
	rep movsb ; se scriu bitii 9-15
	
	add EDI,1
	mov ECX,15
	rep movsb ;se scriu bitii 17-31
	
	add EDI,1
	mov ECX,6
	rep movsb ;se scriu bitii 33-38
;calculare P1 - se calculeaza bitul de pe pozitia 1 (xor intre 1,3,5,7,...) - se incepe de la poz1
	mov ESI,[EBP+12]
	mov ecx,19
	xor al,al
	calcul_p1:
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,2
		loop calcul_p1
		
		
	mov ESI,[EBP+12]
	add AL,30h
	mov [ESI],AL
	
;calculare P2 - se calculeaza bitul de pe pozitia 2(xor intr 2,3,6,7,10,11,...) se iau cate 2, apoi se sare peste 2 - se incepe de la poz2
	mov ESI,[EBP+12]
	add ESI,1
	mov ECX,9
	xor al,al
	calcul_p2:
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,1
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,3
		loop calcul_p2
	mov bl,[esi]
	sub bl,30h
	xor al,bl
	mov ESI,[EBP+12]
	add ESI,1
	add al,30h
	mov [ESI],al
	
;calculare P4 - se calculeaza bitul de pe pozitita 4(xor intre 4,5,6,7,12,13,14,15,...) se iau 4,apoi se sare peste 4 - se incepe de la poz4
mov ESI,[EBP+12]
add ESI,3
mov ECX,4
xor al,al
calcul_p4:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	
	add ESI,5
	loop calcul_p4
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov ESI,[EBP+12]
	add ESI,3
	add al,30h
	mov [ESI],al

;calculare P8 - se calculeaza bitul de pe pozitia 8 - xor intre 8 biti, apoi se trece peste alti 8 samd - se incepe de la poz8
mov ESI,[EBP+12]
add ESI,7
mov ECX,8
xor al,al
b8to15:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b8to15
add ESI,8
mov ECX,8
b24to31:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
loop b24to31

mov ESI,[EBP+12]
add ESI,7
add al,30h
mov [ESI],al

;calculare P16 - xor intre poz 16-31
mov ESI,[EBP+12]
add ESI,15
mov ECX,16
xor al,al
b16to31:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b16to31

mov ESI,[EBP+12]
add ESI,15
add al,30h
mov [ESI],al

;calculare P32 - xor intre  poz 32-38
mov ESI,[EBP+12]
add ESI,31
mov ECX,7
xor al,al
b32to38:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b32to38

mov ESI,[EBP+12]
add ESI,31
add al,30h
mov [ESI],al

mov ESP,EBP
pop EBP
ret 8
generate_hamming endp

check_hamming proc

push EBP
mov EBP,ESP

xor EDX,EDX
mov ESI,[EBP+8] ;luam de pe stiva adresa sirului hamming

;calcul p1
	mov ecx,19
	xor al,al
	calcul_p1:
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,2
		loop calcul_p1

		cmp al,00h
		je continue1
adauga_1:
	add dl,01h
continue1:
	add dl,0

;calcul p2
mov ESI,[EBP+8]
add ESI,1
	mov ECX,9
	xor al,al
	calcul_p2:
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,1
		mov bl,[ESI]
		sub bl,30h
		xor al,bl
		add ESI,3
		loop calcul_p2
	mov bl,[esi]
	sub bl,30h
	xor al,bl

	cmp al,00h
	je continue2
adauga_2:
	add dl,02h
continue2:
	add dl,0

;calcul p4
mov ESI,[EBP+8]
add ESI,3
mov ECX,4
xor al,al
calcul_p4:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	
	add ESI,5
	loop calcul_p4
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1

	cmp al,00h
	je continue4
adauga_4:	
	add dl,04h
continue4:
	add dl,0

;calcul p8
mov ESI,[EBP+8]
add ESI,7
mov ECX,8
xor al,al
b8to15:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b8to15
add ESI,8
mov ECX,8
b24to31:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
loop b24to31
	
	cmp al,00h
	je continue_8
adauga_8:
	add dl,08h
continue_8:
	add dl,0
;calcul p16
mov ESI,[EBP+8]
add ESI,15
mov ECX,16
xor al,al
b16to31:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b16to31

	cmp al,00h
	je continue_16
adauga_16:
	add dl,10h
continue_16:
	add dl,0


;calcul p32
mov ESI,[EBP+8]
add ESI,31
mov ECX,7
xor al,al
b32to38:
	mov bl,[ESI]
	sub bl,30h
	xor al,bl
	add ESI,1
	loop b32to38
	
	cmp al,00h
	je continue_32
adauga_32:
	add dl,20h
continue_32:
	add dl,0

mov ESP,EBP
pop EBP
ret 4
check_hamming endp










	






