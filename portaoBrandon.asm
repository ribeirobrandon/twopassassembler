; Universidade Estadual de Santa Cruz
; DCET - Ciência da Computação
; CET088 - Software Básico
; Brandon Antunes Neri Ribeiro - 201320040


STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0	;Syscall
SYS_WRITE equ 1	;Syscall
SYS_EXIT equ 60	;Syscall

%macro exit 0
    mov rax, SYS_EXIT   ; system call for exit
    xor rdi, rdi        ; exit code 0
    syscall             ; invoke operating system to exit
%endmacro

%macro print 2

    mov rax, SYS_WRITE  ; systemcall for write
    mov rdi, STDOUT     ; file handle 1 is stdout
    mov rsi, %1         ; address of string to output
    mov rdx, %2         ; number of bytes
    syscall

%endmacro

%macro scan 2

    mov rax, SYS_READ   ; systemcall for read
    mov rdi, STDIN      ; file handle 1 is stdout
    mov rsi, %1         ; address of string to output
    mov rdx, %2         ; number of bytes
    syscall

%endmacro

section .data
	;Portao abrindo
	portaoAbrindo1:	db '----------------------            ---------------------', 10
	portaoAbrindo2:	db '     /     /    /   /|           /     /     /    /   /', 10
	portaoAbrindo3:	db '--------------------/|            -------------------  ', 10
	portaoAbrindo4:	db '    |     |     |  | |     -------------------    |  | ', 10
	portaoAbrindo5:	db '--------------------/|     |                 |-------  ', 10
	portaoAbrindo6:	db '      |      |     | |     |                 | |   |   ', 10
	portaoAbrindo7:	db '--------------------/|  x| |                 |-------  ', 10
	portaoAbrindo8:	db '    |     |     |  | |     |                 |   |   | ', 10
	portaoAbrindo9:	db '--------------------/      |                 |-------  ', 10
	portaoAbrindo10:db '               fcf /       |0----()----()----|  fca    ', 10
	portaoAbrindo11:db '                  /            /                       ', 10
	portaoAbrindo12:db '                 /    --->    /                        ', 10
	portaoAbrindo13:db '                /            /                         ', 10
	portaoAbrindo14:db '               /            /                          ', 10
	portaoAbrindo15:db '              /            /                           ', 10
	portaoAbrindo16:db '             /            /                            ', 10
	portaoAbrindo17:db '   / \                                                 ', 10
	portaoAbrindo18:db '  /   \                                                ', 10
	portaoAbrindo19:db '    |                                                  ', 10
	portaoAbrindo20:db '    |                                                  ', 10
	portaoAbrindo21:db '  |---|                                                ', 10
	portaoAbrindo22:db '  | 0 | ba                                             ', 10
	portaoAbrindo23:db '  | 0 | bf                                             ', 10
	portaoAbrindo24:db '  |---|                                                ', 10
	portaoAbrindoLen:equ $ - portaoAbrindo1

	;Portao Aberto
	portaoAberto1:	db '----------------------            ---------------------', 10
	portaoAberto2:	db '     /     /    /   /|           /     /     /    /   /', 10
	portaoAberto3:	db '--------------------/|            -------------------  ', 10
	portaoAberto4:	db '    |     |     |  | |     -------------------------|  ', 10
	portaoAberto5:	db '--------------------/|     -------|                 |  ', 10
	portaoAberto6:	db '      |      |     | |      |   | |                 |  ', 10
	portaoAberto7:	db '--------------------/|         x| |                 |  ', 10
	portaoAberto8:	db '    |     |     |  | |      |   | |                 |  ', 10
	portaoAberto9:	db '--------------------/      -------|                 |  ', 10
	portaoAberto10:	db '               fcf /         fca  |0----()----()----|  ', 10
	portaoAberto11:	db '                  /            /                       ', 10
	portaoAberto12:	db '                 /            /                        ', 10
	portaoAberto13:	db '                /            /                         ', 10
	portaoAberto14:	db '               /            /                          ', 10
	portaoAberto15:	db '              /            /                           ', 10
	portaoAberto16:	db '             /            /                            ', 10
	portaoAberto17:	db '   / \                                                 ', 10
	portaoAberto18:	db '  /   \                                                ', 10
	portaoAberto19:	db '    |                                                  ', 10
	portaoAberto20:	db '    |                                                  ', 10
	portaoAberto21:	db '  |---|                                                ', 10
	portaoAberto22:	db '  | 0 | ba                                             ', 10
	portaoAberto23:	db '  | 0 | bf                                             ', 10
	portaoAberto24:	db '  |---|                                                ', 10
	portaoAbertoLen:	equ $ - portaoAberto1
	
	;Portao Fechando
	portaoFechando1:	db '----------------------            ---------------------', 10
	portaoFechando2:	db '     /     /    /   /|           /     /     /    /   /', 10
	portaoFechando3:	db '--------------------/|            -------------------  ', 10
	portaoFechando4:	db '    |     |     |  | |     -------------------    |  | ', 10
	portaoFechando5:	db '--------------------/|     |                 |-------  ', 10
	portaoFechando6:	db '      |      |     | |     |                 | |   |   ', 10
	portaoFechando7:	db '--------------------/|  x| |                 |-------  ', 10
	portaoFechando8:	db '    |     |     |  | |     |                 |   |   | ', 10
	portaoFechando9:	db '--------------------/      |                 |-------  ', 10
	portaoFechando10:	db '               fcf /       |0----()----()----|  fca    ', 10
	portaoFechando11:	db '                  /            /                       ', 10
	portaoFechando12:	db '                 /    <---    /                        ', 10
	portaoFechando13:	db '                /            /                         ', 10
	portaoFechando14:	db '               /            /                          ', 10
	portaoFechando15:	db '              /            /                           ', 10
	portaoFechando16:	db '             /            /                            ', 10
	portaoFechando17:	db '   / \                                                 ', 10
	portaoFechando18:	db '  /   \                                                ', 10
	portaoFechando19:	db '    |                                                  ', 10
	portaoFechando20:	db '    |                                                  ', 10
	portaoFechando21:	db '  |---|                                                ', 10
	portaoFechando22:	db '  | 0 | ba                                             ', 10
	portaoFechando23:	db '  | 0 | bf                                             ', 10
	portaoFechando24:	db '  |---|                                                ', 10
	portaoFechandoLen:	equ $ - portaoFechando1
	
	;Portao Fechado
    portaoFechado1:  db '---------------------            -------------------------', 10
    portaoFechado2:  db '    /    /    /    |		         /   /    /    /    /  ', 10
    portaoFechado3:  db '-------------------|            -----------------------   ', 10
    portaoFechado4:  db '   |    |     |    |-------------------|    |    |     |  ', 10
    portaoFechado5:  db '-------------------|                   |---------------   ', 10
    portaoFechado6:  db '     |     |     | |                   |     |    |       ', 10
    portaoFechado7:  db '-----------------x||                   |---------------   ', 10
    portaoFechado8:  db '   |    |     |    |                   |    |    |     |  ', 10
    portaoFechado9:  db '-------------------|                   |---------------   ', 10
    portaoFechado10: db '             fcf  /|0-----()-----()----| fca              ', 10
    portaoFechado11: db '                 /            /                           ', 10
    portaoFechado12: db '                /            /                            ', 10
    portaoFechado13: db '               /            /                             ', 10
    portaoFechado14: db '              /            /                              ', 10
    portaoFechado15: db '             /            /                               ', 10
    portaoFechado16: db '            /            /                                ', 10
    portaoFechado17: db '    / \                                                   ', 10
    portaoFechado18: db '   /   \                                                  ', 10
    portaoFechado19: db '     |                                                    ', 10
    portaoFechado20: db '     |                                                    ', 10
    portaoFechado21: db '   |---|                                                  ', 10
    portaoFechado22: db '   | 0 | ba                                               ', 10
    portaoFechado23: db '   | 0 | bf                                               ', 10
    portaoFechado24: db '   |---|                                                  ', 10
	portaoFechadoLen:	equ $ - portaoFechado1

	; Estado do Portao Fechado
	tipoFechado: db 'Portao fechado', 10
	tipoFechadoLen: equ $ - tipoFechado
	
	; Estado do Portao Aberto
	tipoAberto: db 'Portao aberto', 10
	tipoAbertoLen: equ $ - tipoAberto

	; Botao para Abrir/Fechar Portao
	isTipo: db 'ENTER para abrir/fechar portao ou 0 para sair', 10
	isTipoLen: equ $ - isTipo

	botao: db 0

section .bss
	num: resb 8

section .text
	global _start
	_start:
		mov r15, 48								; A execucao se dara primeiramente com o portao fechado, ou seja, 0 em r15
		call _executaProg						; Inicia-se a execucao do programa

	; Execucao do programa
	_executaProg:
		call _printTipoAtual			
		print isTipo, isTipoLen					; Printa o estado atual do portao (primeiramente fechado)
		scan botao, 1							; Escaneia o botao
		call _loop								; Execucao do loop
	ret

	; Loop
	_loop:
		mov r14, [botao]						; Acao de abertura/fechamento
		cmp r14, 48								; Se o 0 foi pressionado
		je .fechaPrograma						; Fecha-se o programa
		jmp .mantemPrograma						; Senão, continua execucao do programa
		.mantemPrograma:
			call _alteraTipo					; Ao continuar, abre/fecha o portao
			call _executaProg					; Continua a execucao do programa
		.fechaPrograma:
			exit								; Finaliza a execucao
		ret

	; Mostra o portao abrindo ou fechando
	_alteraTipo:
		cmp r15, 48									; Caso o portao esteja fechado
		je .abrePortao								; Abre-se o portao
		jmp .fechaPortao							; Caso não esteja, fecha o portao
		.abrePortao:								; Abertura do portao
			print portaoAbrindo1, portaoAbrindoLen
			;print portaoAberto1, portaoAbertoLen
			mov r15, 49								; Apos abrir o portao, altera-se o tipo
			ret
		.fechaPortao:								; Fechamento do portao
			print portaoFechando1, portaoFechandoLen
			;print portaoFechado1, portaoFechadoLen
			mov r15, 48								; Apos fechar o portao, altera-se o tipo
			ret
		ret
		
	;Impressao do estado atual do portao
	_printTipoAtual:
		cmp r15, 48									; Com o portao fechado
		je .printTipoFechado						; Imprime-se fechado
		jmp .printTipoAberto						; Caso não, imprime aberto
		.printTipoFechado:
			print portaoFechado1, portaoFechadoLen	; Imprime o portao fechado
			print tipoFechado, tipoFechadoLen		; Imprime que o portao esta fechado			
			ret
				
		.printTipoAberto:
			print portaoAberto1, portaoAbertoLen	; Imprime o portao aberto
			print tipoAberto, tipoAbertoLen			; Imprime que o portao esta aberto
			ret
		ret