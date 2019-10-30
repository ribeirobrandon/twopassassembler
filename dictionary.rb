# Universidade Estadual de Santa Cruz
# DCET - Ciência da Computação
# CET088 - Software Básico
# Brandon Antunes Neri Ribeiro - 201320040

$passage = 0                                                                # Keeps the current passage
$instructions = ['mov', 'xor', 'cmp', 'je', 'jmp', 'call', 'syscall']       # Instruction token
$macros = ['exit', 'print', 'scan']                                         # Macros
$macro_lines = { }                                                          # Hash that will be filled with each macro lines
$labels = { }                                                               # List of labels and their memory address
$mnems = { 'mov rax':  { 'opcode': 'b8', 'size': 5 },                   
           'mov rdx':  { 'opcode': 'ba', 'size': 8 },                   
           'mov rdi':  { 'opcode': 'bf', 'size': 8 },                   
           'mov rsi':  { 'opcode': '48be461760000000', 'size': 10 },        # Opcode Mnemonics 
           'mov r14':  { 'opcode': '4cb8342574176000', 'size': 8},
           'mov r15':  { 'opcode': '41bf30000000', 'size': 6},
           'cmp': { 'opcode': '4983fe30', 'size': 4 },               
           'xor': { 'opcode': '4831ff', 'size': 3 },                    
           'je':  { 'opcode': '7402', 'size': 2 },                        
           'jmp': { 'opcode': 'eb57', 'size': 2 },                      
           'call':  { 'opcode': 'e8ae000000', 'size': 5 },              
           'syscall':  { 'opcode': '0f05', 'size': 2 } }               
$check_3rd_op = ['mov rax', 'mov rdx', 'mov rdi', 'cmp', 'je']              # Array that determines each mnemonics needs to consider the 3rd operator
$constants = { 'STDIN': 0,
                'STDOUT': 1,
                'STDERR': 2,                                                # System constants
                'SYS_READ': 0,
                'SYS_WRITE': 1,
                'SYS_EXIT': 60 }
$variables = {  'tipoFechadoLen': 15,
                'tipoAbertoLen': 13,
                'isTipoLen': 45,
                'portaoFechadoLen': 1387 ,                                  # System variables
                'portaoFechandoLen': 1320,
                'portaoAbertoLen': 1344,
                'portaoAbrindoLen': 1320 }
$macro_variables = ['%1', '%2', '%1,', '%2,']                               # Received parametres on macro
$ilc = 0                                                                    # ILC Variable 

$header = "7F 45 4C 46 02 01 01 00 00 00 00 00 00 00 00 00 01 00 3E 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 40 00 08 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40 02 00 00 00 00 00 00 8D 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00 08 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D0 17 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0C 00 00 00 01 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D0 17 00 00 00 00 00 00 35 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 10 19 00 00 00 00 00 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1C 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 50 19 00 00 00 00 00 00 30 0C 00 00 00 00 00 00 06 00 00 00 81 00 00 00 08 00 00 00 00 00 00 00 18 00 00 00 00 00 00 00 24 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 25 00 00 00 00 00 00 81 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2C 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 10 2D 00 00 00 00 00 00 D8 00 00 00 00 00 00 00 05 00 00 00 03 00 00 00 08 00 00 00 00 00 00 00 18 00 00 00 00 00 00 00"

$footer = "00 00 00 00 00 00 00 00 00 00 00 00 2E 64 61 74 61 00 2E 62 73 73 00 2E 74 65 78 74 00 2E 73 68 73 74 72 74 61 62 00 2E 73 79 6D 74 61 62 00 2E 73 74 72 74 61 62 00 2E 72 65 6C 61 2E 74 65 78 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 04 00 F1 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 13 00 00 00 00 00 F1 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 19 00 00 00 00 00 F1 FF 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00 00 F1 FF 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 27 00 00 00 00 00 F1 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 00 00 00 00 00 F1 FF 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3A 00 00 00 00 00 F1 FF 3C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 52 00 00 00 00 00 01 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 00 00 00 00 00 01 00 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 00 00 00 00 00 01 00 A8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7F 00 00 00 00 00 01 00 E0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8E 00 00 00 00 00 01 00 18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9D 00 00 00 00 00 01 00 50 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AC 00 00 00 00 00 01 00 88 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 BB 00 00 00 00 00 01 00 C0 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CA 00 00 00 00 00 01 00 F8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 DA 00 00 00 00 00 01 00 30 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EA 00 00 00 00 00 01 00 68 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FA 00 00 00 00 00 01 00 A0 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0A 01 00 00 00 00 01 00 D8 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1A 01 00 00 00 00 01 00 10 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2A 01 00 00 00 00 01 00 48 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3A 01 00 00 00 00 01 00 80 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4A 01 00 00 00 00 01 00 B8 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5A 01 00 00 00 00 01 00 F0 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6A 01 00 00 00 00 01 00 28 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7A 01 00 00 00 00 01 00 60 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 01 00 00 00 00 01 00 98 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9A 01 00 00 00 00 01 00 D0 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AA 01 00 00 00 00 01 00 08 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 BA 01 00 00 00 00 F1 FF 40 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CB 01 00 00 00 00 01 00 40 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D9 01 00 00 00 00 01 00 78 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E7 01 00 00 00 00 01 00 B0 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F5 01 00 00 00 00 01 00 E8 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 02 00 00 00 00 01 00 20 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 11 02 00 00 00 00 01 00 58 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1F 02 00 00 00 00 01 00 90 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2D 02 00 00 00 00 01 00 C8 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3B 02 00 00 00 00 01 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 49 02 00 00 00 00 01 00 38 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 58 02 00 00 00 00 01 00 70 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 67 02 00 00 00 00 01 00 A8 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 76 02 00 00 00 00 01 00 E0 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 85 02 00 00 00 00 01 00 18 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 94 02 00 00 00 00 01 00 50 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A3 02 00 00 00 00 01 00 88 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 B2 02 00 00 00 00 01 00 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C1 02 00 00 00 00 01 00 F8 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D0 02 00 00 00 00 01 00 30 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 DF 02 00 00 00 00 01 00 68 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EE 02 00 00 00 00 01 00 A0 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FD 02 00 00 00 00 01 00 D8 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0C 03 00 00 00 00 01 00 10 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1B 03 00 00 00 00 01 00 48 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2A 03 00 00 00 00 F1 FF 40 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3A 03 00 00 00 00 01 00 80 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4A 03 00 00 00 00 01 00 B8 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5A 03 00 00 00 00 01 00 F0 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6A 03 00 00 00 00 01 00 28 0B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7A 03 00 00 00 00 01 00 60 0B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 03 00 00 00 00 01 00 98 0B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9A 03 00 00 00 00 01 00 D0 0B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AA 03 00 00 00 00 01 00 08 0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 BA 03 00 00 00 00 01 00 40 0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CA 03 00 00 00 00 01 00 78 0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 DB 03 00 00 00 00 01 00 B0 0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EC 03 00 00 00 00 01 00 E8 0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FD 03 00 00 00 00 01 00 20 0D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0E 04 00 00 00 00 01 00 58 0D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1F 04 00 00 00 00 01 00 90 0D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 04 00 00 00 00 01 00 C8 0D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 04 00 00 00 00 01 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 52 04 00 00 00 00 01 00 38 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63 04 00 00 00 00 01 00 70 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 74 04 00 00 00 00 01 00 A8 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 85 04 00 00 00 00 01 00 E0 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 96 04 00 00 00 00 01 00 18 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A7 04 00 00 00 00 01 00 50 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 B8 04 00 00 00 00 01 00 88 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C9 04 00 00 00 00 F1 FF 40 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 DB 04 00 00 00 00 01 00 C0 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EA 04 00 00 00 00 01 00 FB 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F9 04 00 00 00 00 01 00 32 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 05 00 00 00 00 01 00 6D 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 17 05 00 00 00 00 01 00 A8 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 26 05 00 00 00 00 01 00 E3 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 35 05 00 00 00 00 01 00 1E 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 05 00 00 00 00 01 00 58 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 05 00 00 00 00 01 00 93 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 62 05 00 00 00 00 01 00 CD 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 72 05 00 00 00 00 01 00 07 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 05 00 00 00 00 01 00 42 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 92 05 00 00 00 00 01 00 7D 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A2 05 00 00 00 00 01 00 B8 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 B2 05 00 00 00 00 01 00 F3 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C2 05 00 00 00 00 01 00 2E 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D2 05 00 00 00 00 01 00 69 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E2 05 00 00 00 00 01 00 A4 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F2 05 00 00 00 00 01 00 DF 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 06 00 00 00 00 01 00 1A 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00 12 06 00 00 00 00 01 00 55 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00 22 06 00 00 00 00 01 00 90 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00 32 06 00 00 00 00 01 00 CB 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 06 00 00 00 00 01 00 06 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 52 06 00 00 00 00 F1 FF 81 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63 06 00 00 00 00 01 00 41 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6F 06 00 00 00 00 F1 FF 0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7E 06 00 00 00 00 01 00 50 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 89 06 00 00 00 00 F1 FF 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 97 06 00 00 00 00 01 00 5E 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9E 06 00 00 00 00 F1 FF 2E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A8 06 00 00 00 00 01 00 8C 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AE 06 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 B9 06 00 00 00 00 03 00 0B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C6 06 00 00 00 00 03 00 4C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CC 06 00 00 00 00 03 00 5C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E1 06 00 00 00 00 03 00 66 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F5 06 00 00 00 00 03 00 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 07 00 00 00 00 03 00 79 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 07 00 00 00 00 03 00 9B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 07 00 00 00 00 03 00 BE 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40 07 00 00 00 00 03 00 C6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 07 00 00 00 00 03 00 FD 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 B2 06 00 00 10 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 6F 72 74 61 6F 42 72 61 6E 64 6F 6E 2E 61 73 6D 00 53 54 44 49 4E 00 53 54 44 4F 55 54 00 53 54 44 45 52 52 00 53 59 53 5F 52 45 41 44 00 53 59 53 5F 57 52 49 54 45 00 53 59 53 5F 45 58 49 54 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 33 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 34 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 35 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 36 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 37 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 38 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 39 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 30 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 31 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 32 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 33 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 34 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 35 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 36 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 37 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 38 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 31 39 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 30 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 31 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 32 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 33 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 32 34 00 70 6F 72 74 61 6F 41 62 72 69 6E 64 6F 4C 65 6E 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 33 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 34 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 35 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 36 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 37 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 38 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 39 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 30 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 31 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 32 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 33 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 34 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 35 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 36 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 37 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 38 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 31 39 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 30 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 31 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 32 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 33 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 32 34 00 70 6F 72 74 61 6F 41 62 65 72 74 6F 4C 65 6E 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 33 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 34 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 35 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 36 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 37 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 38 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 39 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 30 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 31 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 32 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 33 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 34 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 35 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 36 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 37 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 38 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 31 39 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 30 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 31 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 32 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 33 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 32 34 00 70 6F 72 74 61 6F 46 65 63 68 61 6E 64 6F 4C 65 6E 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 33 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 34 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 35 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 36 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 37 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 38 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 39 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 30 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 31 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 32 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 33 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 34 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 35 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 36 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 37 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 38 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 31 39 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 30 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 31 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 32 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 33 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 32 34 00 70 6F 72 74 61 6F 46 65 63 68 61 64 6F 4C 65 6E 00 74 69 70 6F 46 65 63 68 61 64 6F 00 74 69 70 6F 46 65 63 68 61 64 6F 4C 65 6E 00 74 69 70 6F 41 62 65 72 74 6F 00 74 69 70 6F 41 62 65 72 74 6F 4C 65 6E 00 69 73 54 69 70 6F 00 69 73 54 69 70 6F 4C 65 6E 00 62 6F 74 61 6F 00 6E 75 6D 00 5F 73 74 61 72 74 00 5F 65 78 65 63 75 74 61 50 72 6F 67 00 5F 6C 6F 6F 70 00 5F 6C 6F 6F 70 2E 6D 61 6E 74 65 6D 50 72 6F 67 72 61 6D 61 00 5F 6C 6F 6F 70 2E 66 65 63 68 61 50 72 6F 67 72 61 6D 61 00 5F 61 6C 74 65 72 61 54 69 70 6F 00 5F 61 6C 74 65 72 61 54 69 70 6F 2E 61 62 72 65 50 6F 72 74 61 6F 00 5F 61 6C 74 65 72 61 54 69 70 6F 2E 66 65 63 68 61 50 6F 72 74 61 6F 00 5F 70 72 69 6E 74 54 69 70 6F 41 74 75 61 6C 00 5F 70 72 69 6E 74 54 69 70 6F 41 74 75 61 6C 2E 70 72 69 6E 74 54 69 70 6F 46 65 63 68 61 64 6F 00 5F 70 72 69 6E 74 54 69 70 6F 41 74 75 61 6C 2E 70 72 69 6E 74 54 69 70 6F 41 62 65 72 74 6F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1C 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 5E 15 00 00 00 00 00 00 37 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 8C 15 00 00 00 00 00 00 50 00 00 00 00 00 00 00 0B 00 00 00 02 00 00 00 8C 15 00 00 00 00 00 00 85 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 A7 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 80 0A 00 00 00 00 00 00 D2 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 C0 0F 00 00 00 00 00 00 ED 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 41 15 00 00 00 00 00 00 09 01 00 00 00 00 00 00 01 00 00 00 02 00 00 00 40 05 00 00 00 00 00 00 24 01 00 00 00 00 00 00 01 00 00 00 02 00 00 00 50 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00"