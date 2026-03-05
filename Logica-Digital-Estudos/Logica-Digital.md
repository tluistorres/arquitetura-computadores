# Nível Lógico Digital e Portas Lógicas
Aqui está uma explicação detalhada sobre *nível lógico digital* e portas lógicas:
1. *Objetos internos são chamados de portas lógicas*: Portas lógicas (menor estrutura) são os blocos básicos de construção dos circuitos digitais. Elas realizam operações booleanas (como AND, OR, NOT) em sinais binários (0 e 1).
2. *Não montados a partir de componentes analógicos (transistores)*: Embora as portas lógicas sejam implementadas fisicamente com transistores, no nível lógico elas são tratadas como elementos abstratos, não como circuitos analógicos detalhados.
3. *Cada porta tem uma ou mais entradas digitais (níveis representados por 0 e 1)*: As entradas de uma porta lógica são sinais binários (0 = baixo, 1 = alto).
4. *Saídas simples, como AND ou OR*: Portas básicas incluem:
 - *AND*: saída = 1 apenas se todas as entradas forem 1.
 - *OR*: saída = 1 se pelo menos uma entrada for 1.
 - *NOT*: inverte o sinal (1 → 0 ou 0 → 1).
5. *Cada porta é composta e comporta no máximo alguns transistores*: Fisicamente, portas simples (como NAND) são feitas com 2–4 transistores.
6. *Um conjunto de portas pode formar uma memória de 1 bit*: Usando portas lógicas (ex.: latch ou flip-flop), é possível armazenar um valor binário (0 ou 1).
7. *As memórias de 1 bit podem ser combinadas em grupos de 8, 16, 32 ou 64 (formando registradores)*: Registradores são conjuntos de células de memória que armazenam palavras binárias (ex.: 32 bits).

## Exemplos de Registradores
- EAX no x86 (Intel/AMD): registrador de 32 bits para operações aritméticas.
 a) Exemplo de um registrador EAX de 32 bits.
 - Suponha que EAX = 0x00000005 (5 em decimal).
 - Comando: ADD EAX, 3
 - Resultado: EAX = 0x00000008 (8 em decimal).
 b) Exemplo de um registrador de 16 bits.
 - Suponha que AX = 0x0005 (5 em decimal).
 - Comando: ADD AX, 3
 - Resultado: AX = 0x0008 (8 em decimal).
 c) Exemplo de um registrador de 16 bits (Subtração):
 - Suponha que AX = 0x0008 (8 em decimal).
 - Comando: SUB AX, 3
 - Resultado: AX = 0x0005 (5 em decimal).
 d) Um exemplo com um registrador de 8 bits, como AL no x86:
 - AL é um registrador de 8 bits (parte baixa de AX).
 - Suponha que AL = 0x05 (5 em decimal).
 - Comando: MUL AL, 3
 - Resultado: AX = 0x000F (15 em decimal, resultado da multiplicação 5 * 3).
 e) Um exemplo com um registrador de 64 bits na arquitetura x86-64:
 - RAX é um registrador de 64 bits.
 - Queremos calcular 2^10 = 1024.
 - Comando: MOV RAX, 1 ; MOV RCX, 10 ; SHL RAX, CL
 - Resultado: RAX = 0x0000000000000400 (1024 em decimal).
 f) Exemplos com um registrador de 64 bits (RAX):
 - Adição: RAX = 0x0000000000000005 (5 em decimal).
 - Comando: ADD RAX, 3
 - Resultado: RAX = 0x0000000000000008 (8 em decimal).
 - Subtração: RAX = 0x0000000000000008 (8 em decimal).
 - Comando: SUB RAX, 3
 - Resultado: RAX = 0x0000000000000005 (5 em decimal).
 - Multiplicação: RAX = 0x0000000000000005 (5 em decimal).
 - Comando: MOV RCX, 3 ; IMUL RAX, RCX
 - Resultado: RAX = 0x000000000000000F (15 em decimal).
 g) Dois exemplos com ARM (registradores de 32 bits):
 - Exemplo de um registrador Arm de 32 bits (Adição):
 - R0 = 0x00000005 (5 em decimal).
 - Comando: ADD R0, R0, #3
 - Resultado: R0 = 0x00000008 (8 em decimal).
 - Exemplo de um registrador Arm de 32 bits (Subtração):
 - R1 = 0x00000008 (8 em decimal).
 - Comando: SUB R1, R1, #3
 - Resultado: R1 = 0x0001 (5 em decimal).

## Exemplos Práticos
### Porta Lógica AND de 2 entradas
- **Entradas:** A e B
- **Saída:** S = A ∧ B (S é 1 apenas se A = 1 E B = 1)
#### Tabela verdade:

A | B | S
0 | 0 | 0
0 | 1 | 0
1 | 0 | 0
1 | 1 | 1

#### Implementação com transistores (CMOS):
Vdd ├── P1 (A=0) ─┐  
       ├── P2 (B=0) ─┤── S (saída)  
GND │ N1 (A=1) ─┐  
    │ N2 (B=1) ─┴── GND

### Porta Lógica OR de 2 entradas
- **Entradas:** A e B
- **Saída:** S = A ∨ B (S é 1 se A = 1 OU B = 1)
#### Tabela verdade:

A | B | S
0 | 0 | 0
0 | 1 | 1
1 | 0 | 1
1 | 1 | 1

#### Implementação com transistores (CMOS):
Vdd ├── P1 (A=1) ─┐  
       P2 (B=1) ─┘ ├── S (saída)  
GND │ N1 (A=0) ─┬──┴── N2 (B=0) ─ GND

### Porta Lógica NAND de 2 entradas
- **Entradas:** A e B
- **Saída:** S = ~(A ∧ B) (S é 0 apenas se A = 1 E B = 1)
#### Tabela verdade:

A | B | S
0 | 0 | 1
0 | 1 | 1
1 | 0 | 1
1 | 1 | 0

#### Implementação com transistores (CMOS):
Vdd ├── P1 (A=0) ─┬──┐  
       P2 (B=0) ─┘  ├── S (saída)  
GND │ N1 (A=1) ─┬──┴── N2 (B=1) ─ GND

## Organização Estruturada de Computadores com 6 níveis:
- Nível 0: Lógico digital (hardware).
- Nível 1: Microarquitetura.
- Nível 2: Conjunto de instruções (ISA - inclui assembly).
- Nível 3: Sistema operacional.
- Nível 4: Linguagem de montagem (assembly).
- Nível 5: Linguagem de alto nível.

