# O NÍVEL DE LINGUAGEM DE MONTAGEM

Este capítulo trata principalmente de outro nível que, em essência, também está presente em todos os computadores modernos: o nível da linguagem de montagem (ou assembly). 

O nível da linguagem de montagem tem uma característica significativamente diferente em relação aos níveis de microarquitetura, ISA e máquina do sistema operacional - é implantado por tradução em vez de interpretação.

Programas que convertem um programa de usuário escrito em alguma linguagem para outra são denominados tradutores. A linguagem na qual o programa original é escrito é denominada linguagem-fonte, e a linguagem para a qual ela é convertida é denominada linguagem-alvo. Ambas, linguagem-fonte e linguagem-alvo, definem níveis. Se houver um processador disponível que possa executar diretamente programas escritos em linguagem- -fonte, não há nenhuma necessidade de traduzir o programa-fonte para a l

## Tradução vs. Interpretação

A principal distinção entre os dois processos reside em como e quando o código é executado:

## Tradução

 - O código-fonte não é executado diretamente. Ele passa por um processo de conversão total antes de rodar.

 - Etapa 1 (Geração): O programa original (linguagem-fonte) é convertido em um programa-objeto ou binário executável.

 - Etapa 2 (Execução): O novo programa é executado somente após o término completo da tradução.

 - Características: As duas etapas são temporalmente separadas. O programa-fonte original não é mais necessário após a geração do objeto.

## Interpretação

 - Existe apenas uma etapa global: a execução do programa-fonte original.

 - Processo: O interpretador lê e executa as instruções "on-the-fly".

 - Código Intermediário: Embora não gere um binário final de antemão, pode converter o fonte para uma forma intermediária (como o Bytecode Java) para agilizar o processo.

2. Níveis de Máquina em Tempo de Execução

Um ponto crítico é a mudança na hierarquia de níveis durante a execução de um programa traduzido:

 - Desaparecimento do Fonte: Durante a execução do programa-objeto, todos os vestígios da linguagem-fonte original desaparecem da memória.

 - Níveis em Evidência: Apenas três níveis permanecem ativos durante o tempo de execução:

   1. Nível de Microarquitetura.

   2. Nível ISA (Instruction Set Architecture).

   3. Nível de Máquina do Sistema Operacional.

 - Programas na Memória: Consequentemente, três programas coexistem na memória: o programa-objeto do usuário, o sistema operacional e o microprograma (se a arquitetura o utilizar).

3. Perspectiva de Definição

O texto ressalta que a definição de um "nível" deve-se às instruções e construções linguísticas disponíveis para o programador, independentemente da técnica de execução (se traduzido ou interpretado). Contudo, nota-se que alguns autores preferem distinguir níveis baseando-se justamente na forma como são implementados em tempo de execução.

## 7.1 Introdução à linguagem de montagem

A classificação dos tradutores é determinada pela relação de proximidade entre a linguagem de origem (fonte) e a linguagem de destino (alvo).

Tipos de Tradutores

 - Assembler (Montador): É o tradutor utilizado quando a linguagem-fonte é uma representação simbólica de uma linguagem de máquina numérica.

 - Compilador: É o tradutor utilizado quando a linguagem-fonte é de alto nível (como C ou Java) e a linguagem-alvo é uma linguagem de máquina numérica ou sua representação simbólica.

Definições de Linguagem

 - Linguagem de Montagem (Assembly): É a linguagem-fonte composta por símbolos que representam diretamente as instruções numéricas da máquina.

 - Linguagem de Alto Nível: Linguagens complexas que exigem uma tradução mais profunda (compilação) para serem compreendidas pelo hardware.

## 7.1.1 O que é uma Linguagem de Montagem?

Uma linguagem de montagem pura é definida pela sua correspondência um-para-um com as instruções de máquina. Isso significa que cada declaração no código assembly resulta em exatamente uma instrução binária para o processador.

Principais Características e Vantagens

 - Facilidade de Programação: Ao contrário da linguagem de máquina (binário/hexadecimal), o assembly utiliza nomes simbólicos (mnemônicos como ADD, SUB, MUL, DIV) e endereços simbólicos para locais de memória.

 - Acesso Total ao Hardware: O programador de assembly tem acesso a todos os recursos da máquina-alvo, como registradores específicos e bits de estado (ex: bit de excesso/overflow), que geralmente não estão disponíveis em linguagens de alto nível como Java.

 - Poder de Execução: Tudo o que a máquina é capaz de fazer via linguagem de máquina pode ser realizado em linguagem de montagem.

 - Linguagens Híbridas: Linguagens como C são consideradas híbridas, pois oferecem a sintaxe de alto nível, mas mantêm grande parte do acesso direto ao hardware característico do assembly.

## Comparativo de Linguagens

+-----------------+---------------------------------+---------------------------------+
| CARACTERÍSTICA  |     LINGUAGEM DE MONTAGEM       |     LINGUAGEM DE ALTO NÍVEL     |
+-----------------+---------------------------------+---------------------------------+
| PORTABILIDADE   | Restrita a uma única família    | Potencial para rodar em diversos|
|                 | de máquinas.                    | equipamentos (Portável).        |
+-----------------+---------------------------------+---------------------------------+
| ABSTRAÇÃO       | Baixa: Mapeamento um-para-um    | Alta: Foco na lógica e no       |
|                 | com o hardware.                 | problema, não no hardware.      |
+-----------------+---------------------------------+---------------------------------+
| ACESSO A        | Total: Registradores, bits de   | Limitado pelas bibliotecas e    |
| RECURSOS        | status e instruções de máquina. | pelo ambiente de execução.      |
+-----------------+---------------------------------+---------------------------------+

## 7.1.2 Por que usar Linguagem de Montagem?

Embora a programação em linguagem de montagem seja descrita como difícil, lenta para escrever, complexa para depurar e de manutenção árdua, ela permanece indispensável por motivos específicos.

Razões para Programar em Assembly

 - Desempenho e Tamanho: Um programador especializado pode produzir código significativamente menor e mais rápido que um compilador de alto nível.

 - Aplicações Críticas: É essencial para sistemas onde rapidez e economia de espaço são vitais, como cartões inteligentes (smart cards), RFID, rotinas de BIOS e bibliotecas de alto desempenho.

 - Acesso Direto ao Hardware: Permite realizar procedimentos impossíveis em linguagens de alto nível, como o controle de interrupções e exceções de baixo nível em sistemas operacionais ou drivers de dispositivos.

Razões para Estudar a Linguagem

 - Compreensão de Compiladores: Como os compiladores precisam produzir código de montagem ou realizar a montagem internamente, o estudo é fundamental para entender como eles funcionam.

 - Visão da Máquina Real: Escrever em assembly é a única forma de um estudante de arquitetura de computadores compreender como as máquinas operam no nível da arquitetura, expondo o hardware real sem abstrações.

## 7.1.3 Formato de uma Declaração em Linguagem de Montagem

Embora as linguagens de montagem variem conforme a arquitetura da máquina (como o x86 citado), elas possuem uma estrutura geral padronizada que permite uma discussão comum sobre seus componentes.

Estrutura e Funcionalidade

 - Representação Simbólica: A estrutura de uma declaração em assembly assemelha-se fortemente à instrução de máquina que ela representa.
 
 - Tipos de Instruções: O código é geralmente dividido entre representações de instruções de execução e comandos para o assembler.
 
 - Pseudo-instruções (Diretivas): No exemplo mencionado ($N = I + J$), as declarações que reservam memória para variáveis não são instruções de máquina propriamente ditas, mas sim comandos (diretivas) para o montador organizar o espaço na memória.

Organização de Hardware (Seu Formato Padrão)

Na execução de uma instrução como a do exemplo ($N = I + J$), os componentes da sua tabela interagem da seguinte forma: o REM busca os endereços de $I$ e $J$, a ULA realiza a soma, e o resultado é movido para o endereço de $N$ via Barramento de Dados.

## Para seus arquivos no diretório arquitetura_computadores, você pode estruturar a anatomia de uma linha de assembly assim:

+----------+------------+------------+-----------------------+
|  Rótulo  | Mnemônico  |  Operandos |       Comentário      |
+----------+------------+------------+-----------------------+
|  INICIO: |    MOV     |   EAX, I   | ; Move valor de I     |
|          |    ADD     |   EAX, J   | ; Soma J ao EAX       |
|          |    MOV     |   N, EAX   | ; Guarda result em N  |
+----------+------------+------------+-----------------------+


## Arquitetura de Processamento e Armazenamento

UNIDADE CENTRAL DE PROCESSAMENTO (CPU)
+-----------------------------------------------------------+
| [ PROCESSAMENTO ]                 [ ARMAZENAMENTO ]       |
|                                                           |
|  +-------------------+           +---------------------+  |
|  |  ULA (Cálculos)   | <-------> |    Registradores    |  |
|  +-------------------+           +----------+----------+  |
|                                             |             |
|  +------------------------------------------+----------+  |
|  |                BARRAMENTO INTERNO                   |  |
|  +--+-----------+-----------+-----------+-----------+--+  |
|     |           |           |           |           |     |
|  +--v---+   +---v---+   +---v---+   +---v---+   +---v---+ |
|  |  UC  |   |  RI   |   |  REM  |   |  CI   |   |  RDM  | |
|  (Contr)|   (Instr) |   (Endere)|   (Prox I)|   (Dados) | |
|  +--+---+   +-------+   +---+---+   +-------+   +---+---+ |
|     |           |           |           |           |     |
|  +--v-----------v-----------v-----------v-----------v---+ |
|  |     Decodificador  /  CLOCK (Sincronismo)            | |
|  +------------------------------------------------------+ |
+-----------------------------+-----------------------------+
              |               |               ^
              | [B. Endereços]|               | [B. Dados]
              v               |               v
+-----------------------------+-----------------------------+
|                                                           |
|                 MEMÓRIA PRINCIPAL (RAM)                   |
|                                                           |
+-----------------------------------------------------------+

Breve Resumo dos Componentes

 - ULA: Onde a mágica da matemática acontece (Soma, Subtração, AND, OR).

 - CI (Contador de Instrução): O "GPS" do processador, guardando o endereço da próxima instrução.

 - RI (Registrador de Instrução): Onde a instrução atual "mora" enquanto é decodificada.

 - REM e RDM: As portas de saída e entrada para a RAM; o REM diz "onde" e o RDM diz "o quê".

## Figura 7.1: Cálculo de $N = I + J$ no x86

Este exemplo ilustra como uma operação aritmética simples de alto nível é decomposta em instruções de máquina simbólicas e como o espaço de memória é reservado para os dados.

Análise do Código

 - Instruções de Execução: As três primeiras linhas representam o fluxo de processamento real, utilizando o registrador acumulador (EAX) para realizar a soma.
 
 - Diretivas de Reserva (Pseudo-instruções): As linhas após o espaço em branco (DD) instruem o montador a alocar 4 bytes (Double Word) na memória principal para cada variável, definindo seus valores iniciais.

Abaixo, a representação visual da anatomia das instruções contidas na figura:

ETIQUETA    OPCODE    OPERANDOS       COMENTÁRIOS
+-----------+---------+------------+-------------------------------+
| FORMULA:  |  MOV    |  EAX, I    | ; registrador EAX = I         |
|           |  ADD    |  EAX, J    | ; registrador EAX = I + J     |
|           |  MOV    |  N, EAX    | ; N = I + J                   |
+-----------+---------+------------+-------------------------------+
|           |         |            |                               |
| I         |  DD     |  3         | ; reserva 4 bytes (val=3)     |
| J         |  DD     |  4         | ; reserva 4 bytes (val=4)     |
| N         |  DD     |  0         | ; reserva 4 bytes (val=0)     |
+-----------+---------+------------+-------------------------------+

Destaque Técnico

Note que o rótulo FORMULA: permite que o CI (Contador de Instrução) salte para este bloco de código se necessário, enquanto as etiquetas I, J e N são resolvidas pelo montador como endereços de memória que serão carregados no REM durante a execução.

Etrutura de uma Declaração em Assembly
Uma declaração típica em linguagem de montagem é composta por quatro partes fundamentais, embora nenhuma delas seja estritamente obrigatória.

1. Campo de Etiqueta (Label)

 - Finalidade: Atribuir nomes simbólicos a endereços de memória.

 - Uso em Código: Permite que o programa realize desvios (jumps) para pontos específicos.

 - Uso em Dados: Torna os dados acessíveis por nomes em vez de endereços numéricos.

 - Sintaxe MASM: Requer dois-pontos (:) para etiquetas de código (ex: FORMULA:), mas não para etiquetas de dados. Os dois-pontos ajudam a evitar ambiguidades quando a etiqueta aparece sozinha em uma linha.

2. Campo de Operação (Opcode)

 - Instruções de Máquina: Contém abreviaturas simbólicas (mnemônicos) para instruções reais, como MOV (usado no MASM tanto para carregar quanto para armazenar dados).

 - Diretivas do Assembler: Comandos para o próprio montador, como o DD (Define Double), usado para reservar 32 bits de espaço para variáveis.

3. Campo de Operandos

 - Especificação: Define quais endereços, constantes ou registradores (como EAX, EBX) serão utilizados pela instrução.

 - Função: Em uma soma, indica o que será somado; em um desvio, indica o destino.

4. Campo de Comentários

 - Documentação: Essencial para a compreensão humana do código; um programa sem comentários é considerado quase incompreensível.

 - Processamento: É ignorado pelo assembler e não afeta o programa gerado.

## Diagrama ASCII: Anatomia da Declaração

Para facilitar a visualização no seu diretório arquitetura_computadores, veja como os campos se organizam:

COLUNA 1      CAMPO SEGUINTE      ESPAÇO/TAB       APÓS ";"
+-----------+------------------+-----------------+-----------------------+
|  ETIQUETA |      OPCODE      |    OPERANDOS    |       COMENTÁRIO      |
+-----------+------------------+-----------------+-----------------------+
| FORMULA:  |      MOV         |     EAX, I      | ; Comentário humano   |
| (Simbólico|     (Instrução ou|    (Dados/Regs) | (Não gera binário)    |
| Endereço) |      Diretiva)   |                 |                       |
+-----------+------------------+-----------------+-----------------------+

## 7.1.4 Pseudoinstrucões(diretivas)

Diferente dos mnemônicos como MOV ou ADD, as pseudoinstruções servem para organizar a estrutura do código, gerenciar símbolos e alocar memória.

Categorias Principais:

1. Gerenciamento de Segmentos: SEGMENT e ENDS definem onde começam e terminam as áreas de código (texto) e dados.

2. Alocação de Dados: Determinam quanto espaço será reservado na memória:

 - DB (Byte - 8 bits)

 - DW (Word - 16 bits)

 - DD (Double Word - 32 bits)

 - DQ (Quad Word - 64 bits)

3. Procedimentos e Macros: PROC/ENDP e MACRO/ENDM estruturam blocos lógicos de código reaproveitáveis.

4. Símbolos e Arquivos: EQU define constantes, enquanto INCLUDE, PUBLIC e EXTERN gerenciam a modularização do código.

5. Controle de Fluxo do Assembler: IF, ELSE e ENDIF permitem a montagem condicional, decidindo quais partes do código serão geradas com base em expressões.

## Diagrama ASCII: Tabela de Pseudoinstruções MASM (Figura 7.2)

+-----------------+----------------------------------------------------------+
| PSEUDOINSTRUÇÃO |                      SIGNIFICADO                         |
+-----------------+----------------------------------------------------------+
| SEGMENT / ENDS  | Inicia / Encerra um segmento (Texto, Dados, etc.)        |
+-----------------+----------------------------------------------------------+
| ALIGN           | Controla o alinhamento da próxima instrução ou dados     |
+-----------------+----------------------------------------------------------+
| EQU             | Define um novo símbolo igual a uma expressão             |
+-----------------+----------------------------------------------------------+
| DB / DW / DD    | Aloca espaço: Byte (8b), Word (16b) ou Double (32b)      |
+-----------------+----------------------------------------------------------+
| PROC / ENDP     | Inicia / Encerra um procedimento (função)                |
+-----------------+----------------------------------------------------------+
| MACRO / ENDM    | Inicia / Encerra uma definição de macro                  |
+-----------------+----------------------------------------------------------+
| PUBLIC / EXTERN | Exporta ou importa nomes entre diferentes módulos        |
+-----------------+----------------------------------------------------------+
| INCLUDE         | Busca e inclui o conteúdo de outro arquivo               |
+-----------------+----------------------------------------------------------+
| IF / ELSE /ENDIF| Controle de montagem condicional                         |
+-----------------+----------------------------------------------------------+
| END             | Termina o programa de montagem                           |
+-----------------+----------------------------------------------------------+

Exemplo Prático de Aplicação:

Se você usar DATA_VAR DD 10, o assembler entende que deve reservar o próximo endereço disponível na Memória Principal (RAM), com tamanho de 32 bits, e colocar o valor 10 lá. Quando o programa rodar, o REM usará o endereço simbólico DATA_VAR para buscar esse valor.

1. Organização e Alinhamento

 - SEGMENT e ENDS: Permitem alternar entre seções de código e dados. O assembler agrupa essas partes logicamente, mesmo que você alterne entre elas várias vezes no arquivo-fonte.

 - ALIGN: Garante que o próximo dado ou instrução comece em um endereço múltiplo do argumento (ex: ALIGN 4). Isso é vital para o desempenho, pois a leitura de dados alinhados na RAM é mais rápida para o processador.

2. Definições e Constantes

 - EQU: Cria apelidos para valores ou expressões (ex: BASE EQU 1000). Facilita a manutenção, pois alterar o valor no EQU atualiza todo o código. No MASM, a definição deve vir antes do uso.

3. Alocação de Dados (Tabelas e Variáveis)

 - DB, DW, DD, DQ: Alocam espaço inicializado. Uma lista de valores (ex: TABLE DB 11, 23, 49) cria um vetor (array) na memória. O rótulo TABLE passa a representar o endereço do primeiro elemento.

4. Modularização e Visibilidade

 - PUBLIC / EXTERN: Essenciais para projetos com múltiplos arquivos. PUBLIC "exporta" um símbolo para outros arquivos; EXTERN avisa ao assembler que um símbolo usado ali será definido em outro lugar.

 - INCLUDE: Insere o conteúdo de um arquivo externo no atual, ideal para centralizar definições de constantes e macros.

5. Montagem Condicional

 - IF / ELSE / ENDIF: Permite que o assembler decida quais partes do código incluir no binário final. É muito usado para criar programas "portáveis" que podem ser compilados para 32 bits ou 64 bits apenas mudando uma variável de controle.

## Insights para seu diretório estruturas_de_dados

O uso de DB com vários valores e o uso de ALIGN são a base de como Arrays e Structs são construídos em baixo nível. O alinhamento evita que um dado de 4 bytes fique "quebrado" entre duas palavras de memória, o que exigiria dois ciclos de leitura do barramento em vez de um.

## 7.2 Macros: Otimização e Reuso de Código

A necessidade de repetir sequências de instruções é comum em Assembly. Existem três formas de lidar com isso, cada uma com suas trocas (trade-offs):

1. Repetição Manual: Escrever o código toda vez. É tedioso, aumenta o tamanho do arquivo-fonte e dificulta a manutenção.

2. Procedimentos (Funções): Transforma a sequência em um bloco único chamado via CALL.

 - Desvantagem: Gera "sobrecarga" (overhead). O processador gasta tempo salvando o endereço de retorno na pilha e saltando, o que é ineficiente para sequências muito curtas.

3.Macros: Uma solução de "abreviação" de texto.

7.2.1 Definição, Chamada e Expansão

Diferente de uma função, a macro não existe como um bloco separado na memória durante a execução. Ela funciona na base da substituição:

 - Definição: O programador dá um nome (ex: SWAP) a um conjunto de instruções.

 - Chamada: O programador escreve apenas SWAP no código.

 - Expansão: O Assembler, antes de gerar o binário, apaga a palavra SWAP e "cola" as instruções originais naquele local.

Resumo Técnico:

 - Macro = Velocidade: Não há instruções de CALL ou RET. A execução é puramente linear.

 - Macro = Tamanho: O programa binário fica maior, pois o código é duplicado na RAM toda vez que a macro é chamada.

 - Procedimento = Economia de Espaço: O código existe apenas uma vez na RAM, mas é mais lento devido ao desvio.

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Código sem Macro    |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
| MOV EAX, P          |               |           |          |            |             |
| MOV EBX, Q          |               |           |          |            |             |
| MOV Q, EAX          |               |           |          |            |             |
| MOV P, EBX          |               |           |          |            |             |
| MOV EAX, P          |               |           |          |            |             |
| MOV EBX, Q          |               |           |          |            |             |
| MOV Q, EAX          |               |           |          |            |             |
| MOV P, EBX          |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Código com Macro    |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
| SWAP MACRO          |               |           |          |            |             |
|   MOV EAX, P        |               |           |          |            |             |
|   MOV EBX, Q        |               |           |          |            |             |
|   MOV Q, EAX        |               |           |          |            |             |
|   MOV P, EBX        |               |           |          |            |             |
| ENDM                |               |           |          |            |             |
| SWAP                |               |           |          |            |             |
| SWAP                |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+


Resumo do Funcionamento nos Componentes:

1.REM: Aponta para o endereço de P.

2.RDM: Recebe o valor de P vindo da RAM.

3.Registradores: O valor de P é guardado no EAX.

4.UC: Repete o processo para carregar Q no EBX e depois inverte as ordens para gravar de volta.

5.CI: Como é uma macro, o CI apenas incrementa sequencialmente, sem realizar saltos (Jumps) para outras áreas.

Embora assemblers diferentes tenham notações ligeiramente diferentes para definir macros, todos requerem as
mesmas partes básicas em uma definição de macro:

1. Um cabeçalho de macro que dê o nome da macro que está sendo definida.
2. O texto que abrange o corpo da macro.
3. Uma pseudoinstrução que marca o final da definição (por exemplo, ENDM).

## 7.2.1 Expansão vs. Execução

Expansão de Macro: Ocorre no Assembler. O código é "copiado e colado" no arquivo antes de virar binário. No final, o binário dos exemplos (a) e (b) da Figura 7.3 são idênticos.

Chamada de Procedimento: Ocorre na CPU. O binário contém uma instrução real (CALL) que faz o hardware desviar o fluxo para outro endereço.

Figura 7.4 Comparação de chamadas de macro com chamadas de procedimento.

+------------------------------------+--------------------------+--------------------------+
|                                    |                          |                          |
| Item                               | Chamada de Macro         | Chamada de Procedimento  |
+------------------------------------+--------------------------+--------------------------+
| Quando a chamada é feita?          | Durante a montagem       | Durante a execução       |
+------------------------------------+--------------------------+--------------------------+
| O corpo é inserido no programa-    |                          |                          |
| objeto em todos os lugares em que  | Sim                      | Não                      |
| a chamada é feita?                 |                          |                          |
+------------------------------------+--------------------------+--------------------------+
| Uma instrução de chamada é         |                          |                          |
| inserida no programa-objeto e      | Não                      | Sim                      |
| executada mais tarde?              |                          |                          |
+------------------------------------+--------------------------+--------------------------+
| Deve ser usada uma instrução de    |                          |                          |
| retorno após a conclusão da        | Não                      | Sim                      |
| chamada?                           |                          |                          |
+------------------------------------+--------------------------+--------------------------+
| Quantas cópias do corpo aparecem   | Uma por chamada de macro | Apenas uma               |
| no programa-objeto?                |                          |                          |
+------------------------------------+--------------------------+--------------------------+

O Processo de Montagem em Duas Etapas

+---------------------------------------------------------------------------+
| ETAPA 1: O PROCESSADOR DE MACROS (Manipulação de Strings)                 |
+---------------------------------------------------------------------------+
| 1. Lê o código-fonte original.                                            |
| 2. Identifica definições (MACRO...ENDM) e as guarda em uma tabela interna. |
| 3. Localiza chamadas de macro no texto.                                   |
| 4. SUBSTITUI a chamada pela cadeia de caracteres do corpo da macro.       |
| 5. RESULTADO: Um novo texto (Assembly puro) sem NENHUMA macro.            |
+---------------------------------------------------------------------------+
|                                     |                                     |
|                                     v                                     |
+---------------------------------------------------------------------------+
| ETAPA 2: O ASSEMBLER REAL (Tradução para Código de Máquina)               |
+---------------------------------------------------------------------------+
| 1. Recebe o texto expandido da Etapa 1.                                   |
| 2. Traduz mnemônicos (MOV, ADD) para OpCodes binários.                    |
| 3. Calcula endereços de memória.                                          |
| 4. GERAÇÃO: Arquivo de objeto (.obj / .bin) pronto para execução.         |
+---------------------------------------------------------------------------+

## 7.2.2 Macros com parâmetros

O processador de macros agora não apenas cola o texto, mas atua como um preenchedor de lacunas (parâmetros formais), substituindo-as pelos nomes reais das variáveis (parâmetros reais) fornecidos na chamada.

Figura 7.5: Macros com Parâmetros (Formais vs. Reais)

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| (a) Sem Macro       |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
| MOV EAX, P          |               |           |          |            |             |
| MOV EBX, Q          |               |           |          |            |             |
| MOV Q, EAX          |               |           |          |            |             |
| MOV P, EBX          |               |           |          |            |             |
|                     |               |           |          |            |             |
| MOV EAX, R          |               |           |          |            |             |
| MOV EBX, S          |               |           |          |            |             |
| MOV S, EAX          |               |           |          |            |             |
| MOV R, EBX          |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| (b) Com Macro       |               |           |          |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+
| CHANGE MACRO P1, P2 | ; P1 e P2 são parâmetros formais (moldes)         |             |
|   MOV EAX, P1       |               |           |          |            |             |
|   MOV EBX, P2       |               |           |          |            |             |
|   MOV P2, EAX       |               |           |          |            |             |
|   MOV P1, EBX       |               |           |          |            |             |
| ENDM                |               |           |          |            |             |
|                     |               |           |          |            |             |
| CHANGE P, Q         | ; P e Q são parâmetros reais         |            |             |
| CHANGE R, S         | ; R e S são parâmetros reais         |            |             |
+---------------------+---------------+-----------+----------+------------+-------------+

## 7.2.3 Características Avançadas (MASM e Outros)

As macros modernas não apenas substituem texto, elas possuem lógica interna para evitar erros comuns:

1. Rótulos Locais (LOCAL): Resolve o problema de duplicidade. Se uma macro tem um JUMP para um rótulo LOOP:, e você a chama duas vezes, o Assembler daria erro. Com a diretiva LOCAL, o próprio Assembler gera nomes únicos (ex: ??0001, ??0002) a cada expansão.

2. Macros Aninhadas: Você pode definir uma macro dentro de outra. A macro interna só passará a existir para o Assembler depois que a macro externa for chamada.

3. Montagem Condicional (IF/ELSE): Permite que a macro se comporte de forma diferente dependendo do ambiente (ex: mudar o tamanho da palavra de 16 para 32 bits).

4. Recursividade: Macros que chamam a si mesmas. Requerem uma condição de parada, ou o Assembler entrará em loop infinito tentando expandir o código até esgotar a memória do sistema.

Exemplo de Lógica Condicional (Seu Formato)

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Estrutura de Macro  | Explicação Técnica        | Comportamento no Hardware           |
+---------------------+---------------+-----------+----------+------------+-------------+
| IF WORDSIZE GT 16   | Verifica se a máquina é   | A UC operará com registradores de   |
|   M2 (Versão 32 bits)| maior que 16 bits         | 32 bits (EAX, EBX, etc.)            |
+---------------------+---------------+-----------+----------+------------+-------------+
| ELSE                | Caso contrário (Máquina   | A UC operará com registradores de   |
|   M2 (Versão 16 bits)| de 16 bits)               | 16 bits (AX, BX, etc.)              |
+---------------------+---------------+-----------+----------+------------+-------------+
| ENDIF               | Finaliza a decisão        | O código resultante é linear        |
+---------------------+---------------+-----------+----------+------------+-------------+

## 7.2.4 Implementação de um processador de macros em um assembler

Para o assembler processar macros, ele utiliza duas estruturas principais de dados (que você pode salvar no seu diretório estruturas_de_dados como exemplos de aplicação prática):

 1. Tabela de Nomes de Macro: Guarda o nome (ex: CHANGE), a quantidade de parâmetros e um ponteiro para o corpo.

 2. Tabela de Definição de Macro: Uma tabela grande que armazena o corpo da macro como uma cadeia de caracteres contínua, usando marcadores especiais (como &) para identificar onde os parâmetros devem ser injetados.

Diagrama ASCII: Fluxo de Implementação

Abaixo, a representação de como o Assembler organiza a macro CHANGE internamente:

+---------------------------------------------------------------------------+
| TABELA DE NOMES (Índice)                                                  |
+----------------------+--------------------+-------------------------------+
| Nome da Macro        | Num. Parâmetros   | Ponteiro para Definição       |
+----------------------+--------------------+-------------------------------+
| CHANGE               | 2                  | [Endereço na Tabela Corpo] -->|
+----------------------+--------------------+-------------------------------+
|                      |                    |                               |
|                      v                    |                               |
+---------------------------------------------------------------------------+
| TABELA DE DEFINIÇÃO (O Corpo da Macro)                                    |
+---------------------------------------------------------------------------+
| "MOV EAX, &P1; MOV EBX, &P2; MOV &P2, EAX; MOV &P1, EBX;"                 |
+---------------------------------------------------------------------------+
|                      |                                                    |
|                      v                                                    |
+---------------------------------------------------------------------------+
| PROCESSO DE EXPANSÃO (Quando você escreve: CHANGE R, S)                   |
+---------------------------------------------------------------------------+
| 1. Assembler para de ler o arquivo principal.                             |
| 2. Vai até a Tabela de Definição usando o ponteiro.                       |
| 3. Substitui "&P1" por "R" e "&P2" por "S".                               |
| 4. Injeta o resultado de volta no fluxo que vai para o Assembler.         |
+---------------------------------------------------------------------------+

## 7.3 0 processo de montagem

Nas seções seguintes, vamos descrever resumidamente como um assembler funciona. Embora cada máquina tenha
uma linguagem de montagem diferente, o processo de montagem é semelhante o suficiente para que possamos
descrevê-lo em termos gerais.

## 7.3.1 Assemblers de duas etapas

Quando você escreve JMP L, e o rótulo L: está no final do código, o Assembler encontra um símbolo desconhecido no momento da leitura. A solução é dividir o trabalho em duas etapas (passagens):

 1. Passagem 1 (Coleta): O Assembler lê o código apenas para encontrar e guardar as definições de macros e os endereços de todos os rótulos (símbolos) em uma Tabela de Símbolos.

 2. Passagem 2 (Tradução): Com todos os endereços já mapeados, o Assembler lê o código novamente, substituindo os nomes (como L ou P) pelos endereços reais de memória e gerando o código de máquina.

Diagrama ASCII: Assembler de Duas Etapas

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| PASSAGEM 1          | Ações Realizadas          | Resultado (Saída)                   |
+---------------------+---------------+-----------+----------+------------+-------------+
| Leitura do Fonte    | Escaneia rótulos e macros | Tabela de Símbolos preenchida       |
| Identificação       | Define endereços de cada  | Ex: [L] -> Endereço 0x00A4          |
|                     | instrução (Contador)      |                                     |
+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| PASSAGEM 2          | Ações Realizadas          | Resultado (Saída)                   |
+---------------------+---------------+-----------+----------+------------+-------------+
| Geração de Código   | Traduz mnemônicos para    | Arquivo Objeto (.obj / .bin)        |
|                     | binário (OpCodes)         |                                     |
| Resolução           | Substitui "L" pelo valor  | Programa pronto para carregar       |
|                     | 0x00A4                    | na RAM                              |
+---------------------+---------------+-----------+----------+------------+-------------+

## 7.3.2 Passagem Um: A Construção da Tabela de Símbolos

A função vital desta etapa é mapear nomes para números (endereços). Para isso, o Assembler usa o ILC (Instruction Location Counter).

 - O que é o ILC? É um contador interno do Assembler que simula o CI (Contador de Instrução) do hardware.

 - Como funciona? Ele começa em 0. Para cada instrução lida, o Assembler calcula quantos bytes ela ocupará e soma esse valor ao ILC.

 - Símbolos vs. Instruções: Se uma linha tem um rótulo (ex: INICIO:), o Assembler guarda na Tabela de Símbolos: INICIO = valor atual do ILC.

Diagrama ASCII: O Funcionamento do ILC (Exemplo x86)
Veja como o Assembler "varre" o código para preencher a tabela de símbolos:

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Código Fonte (.asm) | Tamanho (Bytes)| ILC (Antes)| ILC (Depois)| Tabela de Símbolos  |
+---------------------+---------------+-----------+----------+------------+-------------+
| BUFSIZE EQU 8192    | 0 (Constante) | 0000      | 0000     | BUFSIZE = 8192           |
+---------------------+---------------+-----------+----------+------------+-------------+
| INICIO: MOV EAX, 0  | 5 bytes       | 0000      | 0005     | INICIO  = 0000           |
+---------------------+---------------+-----------+----------+------------+-------------+
| LOOP: ADD EAX, 1    | 3 bytes       | 0005      | 0008     | LOOP    = 0005           |
+---------------------+---------------+-----------+----------+------------+-------------+
| JMP LOOP            | 2 bytes       | 0008      | 0010     |                          |
+---------------------+---------------+-----------+----------+------------+-------------+

Figura 7.6: O Contador de Localização de Instrução (ILC) em Ação

+-----------+-----------+------------+-----------------------+-------------+-----+
| Rótulo    | Opcode    | Operandos  | Comentários           | Comprimento | ILC |
+-----------+-----------+------------+-----------------------+-------------+-----+
| MARIA:    | MOV       | EAX, 1     | EAX = 1               | 5           | 100 |
+-----------+-----------+------------+-----------------------+-------------+-----+
|           | MOV       | EBX, J     | EBX = J               | 6           | 105 |
+-----------+-----------+------------+-----------------------+-------------+-----+
| ROBERTA:  | MOV       | ECX, K     | ECX = K               | 6           | 111 |
+-----------+-----------+------------+-----------------------+-------------+-----+
|           | IMUL      | EAX, EAX   | EAX = 1 * 1           | 2           | 117 |
+-----------+-----------+------------+-----------------------+-------------+-----+
|           | IMUL      | EBX, EBX   | EBX = J * J           | 3           | 119 |
+-----------+-----------+------------+-----------------------+-------------+-----+
|           | IMUL      | ECX, ECX   | ECX = K * K           | 3           | 122 |
+-----------+-----------+------------+-----------------------+-------------+-----+
| MARILYN:  | ADD       | EAX, EBX   | EAX = 1*1 + J*J       | 2           | 125 |
+-----------+-----------+------------+-----------------------+-------------+-----+
|           | ADD       | EAX, ECX   | EAX = I*I + J*J + K*K | 2           | 127 |
+-----------+-----------+------------+-----------------------+-------------+-----+
| STEPHANY: | JMP       | DONE       | Desviar para DONE     | 5           | 129 |
+-----------+-----------+------------+-----------------------+-------------+-----+

A passagem um da maioria dos assemblers usa no mínimo três tabelas internas: a tabela de símbolos, a de
pseudoinstruções e a de opcodes. Se necessário, também é mantida uma tabela de literais. A tabela de símbolos tem uma
entrada para cada símbolo, como ilustrado na Figura 7.7. Símbolos são definidos usando-os como rótulos ou por
definição explícita (por exemplo, EQU). Cada entrada da tabela de símbolos contém o símbolo em si (ou um ponteiro
para ele), seu valor numérico e, às vezes, outras informações. Essas informações adicionais podem incluir:

 1. O comprimento do campo de dados associado com o símbolo.

 2. Os bits de relocação. (O símbolo muda de valor se o programa for carregado em um endereço diferente
daquele considerado pelo assembler?)

 3. Se o símbolo deve ser acessível ou não fora do procedimento.

Figura 7.7: Tabela de Símbolos (Gerada a partir da Fig. 7.6)

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Símbolo             | Valor (ILC)   |           |          | Outras Informações       |
+---------------------+---------------+-----------+----------+------------+-------------+
| MARIA               | 100           |           |          | Rótulo de Instrução      |
| ROBERTA             | 111           |           |          | Rótulo de Instrução      |
| MARILYN             | 125           |           |          | Rótulo de Instrução      |
| STEPHANY            | 129           |           |          | Rótulo de Instrução      |
+---------------------+---------------+-----------+----------+------------+-------------+

Figura 7.8: Estrutura da Tabela de Opcodes (Resumo)

Enquanto a Tabela de Símbolos muda a cada programa, a Tabela de Opcodes é fixa para a arquitetura (x86 neste caso). Ela serve como o "manual de tradução" do Assembler.

+-----------+------------+------------+-------------+------------+----------------------+
| Mnemônico | Operandos  | Valor Hex  | Comprimento | Tipo/Grupo | Ação no Hardware     |
+-----------+------------+------------+-------------+------------+----------------------+
| MOV       | EAX, imm32 | B8         | 5           | 1          | Carrega Reg 32-bits  |
| ADD       | EAX, EBX   | 01 D8      | 2           | 4          | Soma Registradores   |
| JMP       | rel8       | EB         | 2           | 9          | Salto Curto          |
| IMUL      | r32, r32   | 0F AF      | 3           | 6          | Multiplicação        |
+-----------+------------+------------+-------------+------------+----------------------+

Figura 7.8: Excertos da Tabela de Opcodes (x86)

Esta tabela mostra que o assembler não olha apenas para o nome da instrução (ADD), mas para a combinação de Mnemônico + Operandos.

+--------+------------+------------+---------+-------------+--------+
| Opcode | 1º Operando| 2º Operando| Hex     | Comprimento | Classe |
+--------+------------+------------+---------+-------------+--------+
| AAA    | —          | —          | 37      | 1           | 6      |
+--------+------------+------------+---------+-------------+--------+
| ADD    | EAX        | immed32    | 05      | 5           | 4      |
+--------+------------+------------+---------+-------------+--------+
| ADD    | reg        | reg        | 01      | 2           | 19     |
+--------+------------+------------+---------+-------------+--------+
| AND    | EAX        | immed32    | 25      | 5           | 4      |
+--------+------------+------------+---------+-------------+--------+
| AND    | reg        | reg        | 21      | 2           | 19     |
+--------+------------+------------+---------+-------------+--------+

Conceitos Chave de Implementação

1. Classes de Instrução: São índices para procedimentos internos do assembler. Em vez de escrever um código de tradução para cada uma das centenas de instruções, o assembler agrupa todas que têm o mesmo formato (ex: Classe 19 para todas as que usam reg, reg) e chama o mesmo procedimento de tratamento.

2. Literais vs. Imediatos:

 - Imediato: O valor faz parte da própria instrução (ex: MOV EAX, 5).

 - Literal: O programador escreve o valor (ex: =F'5'), mas o assembler é quem reserva um espaço de memória no final do programa, coloca o valor lá e troca a instrução original por uma que aponta para aquele endereço.

3. Arquivo Intermediário: Para evitar o custo de processar o texto (parsing) duas vezes, a Passagem Um gera um arquivo temporário já "mastigado" para a Passagem Dois, contendo o tipo, o opcode e o comprimento calculado.

## Figura 7.10 Passagem dois de um ossembler simples.

public static void pass_two() {
// Esse procedimento é um esboço de passagem dois para um assembler simples.
boolean morejnput = true; // sinal que para a passagem dois
String line, opcode; // campos da instrução
int location_counter, length, type; // variáveis diversas
final int END_STATEMENT = -2; // sinaliza final da entrada
final int MAX_CODE = 16; // máximo de bytes de código por instrução
byte code[ ] = new byte[MAX_CODE]; //contém código gerado por instrução
location_counter = 0; // monta a primeira instrução em 0
while (morejnput) { type =
read_type(); opcode =
read_opcode(); length =
readjength(); line =
readjine();
// morejnput ajustada para falso por END // obtém
campo de tipo da próxima linha // obtém campo de
opcode da próxima linha // obtém comprimento de
campo da próxima linha // obtém a linha de entrada
propriamente dita
if (type != 0) | // tipo 0 é para linhas de comentário
switch(type) { // gerar o código de saída
case 1: eval_type1 (opcode, length, line, code); break; case
2: eval_type2(opcode, length, line, code); break;
// outros casos aqui
l
}
write_output(code); // escreva o código binário
writeJisting(code, line); // imprima uma linha na listagem
location_counter = location_counter + length; // atualize loc_ctr if (type ==
END_STATEMENT) { // terminamos a entrada?
morejnput = false; // se terminamos, execute tarefas de manutenção
finish_up(); // execute tarefas de manutenção gerais e termine
}
1
}

Figura 7.9: Lógica da Passagem Um (Algoritmo)

+---------------------------------------------------------------------------+
| INICIALIZAÇÃO: location_counter = 0 | initialize_tables()                 |
+---------------------------------------------------------------------------+
| LOOP PRINCIPAL (Enquanto houver entrada de texto):                        |
|                                                                           |
|  1. LER LINHA: Obtém a instrução do arquivo .asm                          |
|  2. FILTRAR: Se for comentário, ignora.                                   |
|  3. ROTULAR: Se houver Símbolo (MARIA:), salva [Símbolo, location_counter] |
|  4. LITERAL: Se houver literal (=F'5'), salva na Tabela de Literais       |
|  5. ANALISAR OPCODE:                                                      |
|     - Busca na Tabela de Opcodes (MOV, ADD...)                            |
|     - Se não achar, busca na Tabela de Pseudoinstruções (EQU, DB...)      |
|  6. CALCULAR TAMANHO: Baseado no 'type', define quantos bytes ocupa       |
|  7. ARQUIVAR: Escreve [tipo, opcode, length, line] no arquivo temporário  |
|  8. INCREMENTAR: location_counter = location_counter + length             |
+---------------------------------------------------------------------------+
| FINALIZAÇÃO (Ao ler END):                                                 |
|                                                                           |
|  - Rebobina arquivo temporário para a Passagem Dois                       |
|  - Ordena e remove duplicatas da Tabela de Literais                       |
+---------------------------------------------------------------------------+

7.3.3 Passagem Dois: Geração de Código e Resolução

Nesta fase, o assembler utiliza a Tabela de Símbolos (criada na Passagem Um) para substituir nomes por números. Se a instrução for JMP ROBERTA, o assembler consulta a tabela, vê que ROBERTA = 111 e gera o código binário correspondente.

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Etapa               | Ação Principal            | Recurso Utilizado                   |
+---------------------+---------------+-----------+----------+------------+-------------+
| Leitura Temporária  | Lê tipo/comprimento       | Arquivo Intermediário               |
| Avaliação (Eval)    | Traduz para binário       | Tabela de Opcodes                   |
| Resolução           | Troca nomes por endereços | Tabela de Símbolos                  |
| Escrita (Output)    | Acumula em Buffer         | Arquivo Objeto (.obj/.exe)          |
| Listagem            | Gera texto Hex + Fonte    | Arquivo de Listagem (.lst)          |
+---------------------+---------------+-----------+----------+------------+-------------+

Erros Comuns na Montagem

Visto que a suposição de um programa sem erros é irreal, o assembler deve estar preparado para detectar:

 1. Símbolo Não Definido: O programador usa um rótulo (ex: JMP FIM), mas nunca define onde FIM: está.

 2. Símbolo Duplicado: O mesmo rótulo é definido em dois endereços diferentes.

 3. Opcode Inválido: O mnemônico digitado não existe na Tabela de Opcodes (ex: MOVV).

 4. Erro de Sintaxe/Operandos: O opcode existe, mas os operandos são incompatíveis (ex: ADD EAX, "Texto").

 5. Estouro de Capacidade: Tentar colocar um valor de 32 bits em um registrador ou espaço de 8 bits.

## 7.3.4 Organização da Tabela de Símbolos

O objetivo é transformar um par (símbolo, valor) em uma estrutura de busca rápida. Abaixo, as três técnicas comparadas:

+---------------------+---------------+-----------+----------+------------+-------------+
|                     |               |           |          |            |             |
| Técnica             | Complexidade  | Vantagem             | Desvantagem              |
+---------------------+---------------+-----------+----------+------------+-------------+
| Pesquisa Linear     | O(n)          | Fácil de programar   | Muito lenta para n grande|
+---------------------+---------------+-----------+----------+------------+-------------+
| Busca Binária       | O(log n)      | Muito rápida         | Exige tabela ordenada    |
+---------------------+---------------+-----------+----------+------------+-------------+
| Hash (Espalhamento) | O(1) média    | Desempenho constante | Requer função hash e RAM |
+---------------------+---------------+-----------+----------+------------+-------------+

Detalhamento das Estruturas (Para estruturas_de_dados)

1. Busca Binária: O Assembler precisa ordenar a tabela (geralmente ao final da Passagem Um). Ela divide o espaço de busca ao meio sucessivamente. Para 1024 símbolos, resolve em no máximo 10 tentativas.

2. Hashing (Encadeamento):

 - Função Hash: Transforma o nome (ex: MARIA) em um índice numérico.

 - Colisões: Se MARIA e ROBERTA resultarem no mesmo índice i, elas são armazenadas em uma Lista Ligada naquela posição.

 - Eficiência: Se o número de posições (k) for próximo ao número de símbolos (n), a busca é quase instantânea.

Aqui está a representação da Figura 7.11 em diagrama ASCII, integrando os conceitos de Tabela Hash e Listas Encadeadas conforme o seu padrão de estudo:

Figura 7.11: Implementação de Tabela Hash com Encadeamento

+-------------------------------------------------------------------------------+
| (a) DADOS E HASHES CALCULADOS                                                 |
+---------+-------+------+   +---------+-------+------+   +---------+-------+---+
| Símbolo | Valor | Hash |   | Símbolo | Valor | Hash |   | Símbolo | Valor | H |
+---------+-------+------+   +---------+-------+------+   +---------+-------+---+
| Andy    | 14025 |  0   |   | Erik    | 47357 |  6   |   | Jan     | 17097 | 5 |
| Anton   | 31253 |  4   |   | Francês | 56445 |  3   |   | Jaco    | 64533 | 6 |
| Cathy   | 65254 |  5   |   | Frank   | 14332 |  3   |   | Maarten | 23267 | 0 |
| Dick    | 54185 |  0   |   | Gerrit  | 32334 |  4   |   | Reind   | 63453 | 1 |
| Hans    | 44546 |  4   |   | Henri   | 75544 |  2   |   | Roel    | 76764 | 7 |
+---------+-------+------+   +---------+-------+------+   +---------+-------+---+

+-------------------------------------------------------------------------------+
| (b) ESTRUTURA NA MEMÓRIA (TABELA HASH DE 8 ENTRADAS)                          |
+-------+      +----------------------------------------------------------------+
| ÍNDICE|      | LISTA ENCADEADA (PONTEIROS)                                    |
+-------+      +----------------------------------------------------------------+
|   0   | ---> [ Andy | 14025 ] ---> [ Dick | 54185 ] ---> [ Maarten | 23267 ]  |
+-------+      +----------------------------------------------------------------+
|   1   | ---> [ Reind | 63453 ] ---> [ Wiebren | 34344 ]                       |
+-------+      +----------------------------------------------------------------+
|   2   | ---> [ Henri | 75544 ]                                                |
+-------+      +----------------------------------------------------------------+
|   3   | ---> [ Francês | 56445 ] ---> [ Frank | 14332 ]                       |
+-------+      +----------------------------------------------------------------+
|   4   | ---> [ Anton | 31253 ] ---> [ Gerrit | 32334 ] ---> [ Hans | 44546 ]  |
+-------+      +----------------------------------------------------------------+
|   5   | ---> [ Cathy | 65254 ] ---> [ Jan | 17097 ]                           |
+-------+      +----------------------------------------------------------------+
|   6   | ---> [ Erik | 47357 ] ---> [ Jaco | 64533 ] ---> [ Willem | 34544 ]   |
+-------+      +----------------------------------------------------------------+
|   7   | ---> [ Roel | 76764 ]                                                 |
+-------+      +----------------------------------------------------------------+

Notas Técnicas para seu repositório estruturas_de_dados:

 - Colisões: Observe o Índice 4. Três nomes (Anton, Gerrit, Hans) resultaram no mesmo Hash. Isso é uma colisão. A solução usada aqui é o Encadeamento Externo (External Chaining).

 - Eficiência: Em vez de procurar entre 17 nomes (pesquisa linear), se o assembler buscar por "Hans", ele vai direto ao índice 4 e procura apenas entre 3 nomes.

 - Memória: Cada nó da lista encadeada na RAM consome espaço extra para o ponteiro que aponta para o próximo elemento.

## 7.4 Ligação e carregamento

Esta seção descreve o processo de transição entre o código que o assembler gera e o programa que o hardware realmente consegue executar. O ponto fundamental aqui é a modularidade: o fato de podermos traduzir arquivos separadamente e "colá-los" depois.

## 7.4 O Processo de Ligação (Linkage)

Quando um projeto cresce, ele é dividido em vários arquivos .asm. O Assembler transforma cada um em um Módulo Objeto, mas esses módulos ainda não "se conhecem". É o Ligador (Linker) que resolve os endereços externos (quando o Arquivo A chama uma função que está no Arquivo B).

As Duas Etapas da Tradução:

1. Etapa de Tradução: O Assembler/Compilador cria arquivos .obj individuais. Cada um tem seu próprio mapa de endereços começando do zero.

2. Etapa de Ligação: O Ligador combina os .obj, resolve as referências cruzadas e gera um único Executável Binário (.exe ou .bin).

Figura 7.12: Fluxo de Geração do Executável

+---------------------+      +---------------------+      +---------------------+
| Procedimento-Fonte  |      | Procedimento-Fonte  |      | Procedimento-Fonte  |
|      (A.asm)        |      |      (B.asm)        |      |      (C.asm)        |
+----------+----------+      +----------+----------+      +----------+----------+
           |                            |                            |
           v                            v                            v
    [ ASSEMBLER ]                [ ASSEMBLER ]                [ ASSEMBLER ]
           |                            |                            |
           v                            v                            v
+----------+----------+      +----------+----------+      +----------+----------+
|   Módulo Objeto     |      |   Módulo Objeto     |      |   Módulo Objeto     |
|      (A.obj)        |      |      (B.obj)        |      |      (C.obj)        |
+----------+----------+      +----------+----------+      +----------+----------+
           |                            |                            |
           +----------------------------+----------------------------+
                                        |
                                        v
                                 [   LIGADOR   ] <------- [ Biblioteca ]
                                 |  (LINKER)   |          |   (.lib)   |
                                 +------+------+          +------------+
                                        |
                                        v
                             +-----------------------+
                             |  PROGRAMA EXECUTÁVEL  |
                             |       (.exe)          |
                             +-----------------------+

O Assembly é o tradutor

Abaixo, detalho as razões técnicas para essa separação, focando na eficiência de desenvolvimento e na estrutura de arquivos que você utiliza no diretório arquitetura_computadores:

+---------------------+---------------+--------------------+
| Sistema Operacional | Módulo Objeto | Binário Executável |
+---------------------+---------------+--------------------+
| Windows             | .obj          | .exe               |
| UNIX / Linux        | .o            | (sem extensão)     |
+---------------------+---------------+--------------------+

## 7.4.1 Tarefas realizadas pelo ligador

O Desafio do Espaço de Endereçamento Independente

Como cada módulo (.obj) é montado isoladamente, todos acreditam que são os "donos" do endereço 0. Quando o ligador tenta juntá-los, ocorre um conflito: dois objetos não podem ocupar o mesmo espaço.

 - O Problema na Figura 7.13 e 7.14(a)

 - Módulo A: Tem um BRANCH para uma instrução MOVE que ele acha estar no endereço 200.

 - O Ligador: Coloca o Módulo A no endereço 100 da memória real (ou virtual).

 - A Consequência: A instrução MOVE agora está fisicamente no endereço 300 ($100 + 200$). Se o BRANCH original (que aponta para 200) for executado sem ajustes, ele saltará para o lugar errado.

Figura 7.13: Módulos Independentes (Visão do Assembler)

+-------------------+ +-------------------+ +-------------------+ +-------------------+
|     Módulo A      | |     Módulo B      | |     Módulo C      | |     Módulo D      |
+-------------------+ +-------------------+ +-------------------+ +-------------------+
| 0: BRANCH (to 200)| | 0: BRANCH (to 100)| | 0: BRANCH (to 150)| | 0: BRANCH (to 400)|
|       ...         | |       ...         | |       ...         | |       ...         |
| 200: MOVE         | | 100: MOVE         | | 150: MOVE         | | 400: MOVE         |
+-------------------+ +-------------------+ +-------------------+ +-------------------+

Figura 7.14(a): A Imagem do Executável (Endereços Conflitantes)

O ligador empilha os módulos, criando novos endereços de base para cada um:

+-----------------+---------------+-------------+
| Módulo          | Endereço de Base | Tamanho  |
+-----------------+---------------+-------------+
| Módulo A        | 100           | 400 bytes   |
| Módulo B        | 500           | 300 bytes   |
| Módulo C        | 800           | 500 bytes   |
| Módulo D        | 1300          | 200 bytes   |
+-----------------+---------------+-------------+


Esta explicação é crucial porque separa os dois grandes "enigmas" que o ligador precisa resolver para que o software funcione no hardware: a Relocação (ajuste interno) e a Referência Externa (ajuste entre módulos).

Como você bem observou, sistemas modernos (Windows/Linux) preferem um espaço de endereço linear. Isso simplifica a gestão da memória, mas joga toda a responsabilidade de "colagem" para o ligador.

Aqui está a representação da Figura 7.14 e o resumo das etapas, organizado para o seu repositório:

Figura 7.14: Relocação e Resolução de Referências Externas
Abaixo, comparamos o estado "bruto" (a) com o estado "ligado" (b). Observe como o ligador altera os operandos das instruções BRANCH e CALL.

+------------------------------------+---------------------------------------+
| (a) ANTES DA LIGAÇÃO (ERRO)        | (b) APÓS A LIGAÇÃO (CORRETO)          |
+---------+--------------------------+----------+----------------------------+
| Endereço| Instrução                | Endereço | Instrução                  |
+---------+--------------------------+----------+----------------------------+
|   ...   |      MÓDULO D            |    ...   |      MÓDULO D              |
|   1800  | MOVE S TO X              |    1800  | MOVE S TO X                |
|   1600  | BRANCH TO 200 (Erro!)    |    1600  | BRANCH TO 1800 (Corrigido) |
+---------+--------------------------+----------+----------------------------+
|   ...   |      MÓDULO C            |    ...   |      MÓDULO C              |
|   1300  | MOVE R TO X              |    1300  | MOVE R TO X                |
|   1100  | BRANCH TO 200 (Erro!)    |    1100  | BRANCH TO 1300 (Corrigido) |
+---------+--------------------------+----------+----------------------------+
|   1000  | CALL C (Quem é C?)       |    1000  | CALL 1100 (Resolvido)      |
|   ...   |      MÓDULO B            |    ...   |      MÓDULO B              |
|    800  | MOVE Q TO X              |     800  | MOVE Q TO X                |
|    500  | BRANCH TO 300 (Erro!)    |     500  | BRANCH TO 800 (Corrigido)  |
+---------+--------------------------+----------+----------------------------+
|    400  | CALL B (Quem é B?)       |     400  | CALL 500 (Resolvido)       |
|   ...   |      MÓDULO A            |    ...   |      MÓDULO A              |
|    300  | MOVE P TO X              |     300  | MOVE P TO X                |
|    100  | BRANCH TO 200 (Erro!)    |     100  | BRANCH TO 300 (Corrigido)  |
+---------+--------------------------+----------+----------------------------+

As 4 Etapas do Ligador (Seu Resumo Técnico)

 1. Inventário: Cria uma tabela com Módulo | Tamanho.
 
 2. Mapeamento: Define a base de cada um (Ex: A=100, B=500...)
 3. Relocação Interna: Soma a base do módulo aos endereços locais.
 
   - Fórmula: Endereço_Real = Endereço_Original + Base_Módulo

 4. Resolução Externa: Troca nomes de procedimentos (CALL B) pelos endereços de início calculados na Etapa 2.

Esta tabela é o resultado direto da Etapa 1 do ligador. Ela representa o "mapa de ocupação" da memória que guiará todos os cálculos de relocação subsequentes.
Sem esse mapeamento prévio, o ligador não saberia qual "constante de deslocamento" somar a cada instrução.

Aqui está a organização técnica para o seu diretório arquitetura_computadores:

Tabela de Mapeamento de Módulos (Ligador - Etapa 1)O ligador define onde cada "bloco" de código começa, garantindo que não haja sobreposição na RAM. Note que o endereço de início de um módulo é sempre o Endereço de Início do anterior + Comprimento do anterior.

-----------------+----------+---------------+------------------------+
| Módulo          | Comprimento | Endereço de Início | Fim do Módulo |
+-----------------+----------+---------------+-----------------------+
| A              | 400      | 100           | 499                    |
| B              | 600      | 500           | 1.099                  |
| C              | 500      | 1.100         | 1.599                  |
| D              | 300      | 1.600         | 1.899                  |
+-----------------+----------+---------------+-----------------------+

## 7.4.2 Estrutura de um módulo-objeto

Módulos-objeto costumam conter seis partes, como mostra a Figura 7.15. A primeira parte contém o nome do
módulo, certas informações de que o ligador precisa, como os comprimentos das várias partes do módulo, e, às vezes, a
data de montagem.

7.4.2 Anatomia do Módulo-Objeto

Esta seção revela a "anatomia" de um arquivo .obj ou .o. É fascinante notar que apenas uma pequena fração do arquivo gerado pelo assembler é código real; o restante é metadado essencial para que o ligador consiga "costurar" os diferentes módulos.

O arquivo objeto é organizado em seis seções lógicas. Imagine-o como um formulário que o Assembler preenche para o Ligador:

O Processo de Duas Passagens do Ligador

Assim como o assembler, o ligador também precisa de duas passagens para não se perder:

 1. Passagem 1: Coleta os nomes de todos os módulos, seus tamanhos e constrói a Tabela Global de Símbolos (unindo todos os Pontos de Entrada e Referências Externas).

 2. Passagem 2: Lê os módulos novamente, aplica as somas do Dicionário de Relocação e substitui os nomes das funções externas pelos endereços reais descobertos na Passagem 1.

Representação Visual (Seu Formato)

ESTRUTURA INTERNA DO .OBJ (FIGURA 7.15)
+---------------------------------------+
| 1. IDENTIFICAÇÃO (Header)             |
+---------------------------------------+
| 2. PONTOS DE ENTRADA (Exportações)    | <- "PUBLIC"
+---------------------------------------+
| 3. REF. EXTERNAS (Importações)        | <- "EXTERN"
+---------------------------------------+
| 4. CÓDIGO E DADOS (Text Segment)      | <- Único carregado na RAM
+---------------------------------------+
| 5. DICIONÁRIO DE RELOCAÇÃO            | <- Onde somar a Base
+---------------------------------------+
| 6. FIM DO MÓDULO (Trailer)            |
+---------------------------------------+

+---------------------------------------------------------------------------------------+
| ESTRUTURA INTERNA DO MÓDULO-OBJETO                                                    |
+---+----------------------------+------------------------------------------------------+
| # | SEÇÃO                      | FUNÇÃO TÉCNICA                                       |
+---+----------------------------+------------------------------------------------------+
| 1 | Identificação              | Nome do módulo, versão, data e o "mapa" (tamanhos)   |
+---+----------------------------+------------------------------------------------------+
| 2 | Tabela de Pontos Entrada   | Lista símbolos PUBLIC (Ex: "Eu tenho a função X")    |
+---+----------------------------+------------------------------------------------------+
| 3 | Tabela de Refs. Externas   | Lista símbolos EXTERN (Ex: "Preciso da função Z")    |
+---+----------------------------+------------------------------------------------------+
| 4 | Código e Constantes        | O binário real (Única parte que sobrevive na RAM)    |
+---+----------------------------+------------------------------------------------------+
| 5 | Dicionário de Relocação    | O "mapa": indica quais bytes devem ser somados à base|
+---+----------------------------+------------------------------------------------------+
| 6 | Fim do Módulo              | Marca de término e Checksum (Soma de verificação)    |
+---+----------------------------+------------------------------------------------------+

## 7.4.3 Tempo de vinculação e relocação dinâmica

Esta seção toca em um ponto nevrálgico da arquitetura moderna: a mobilidade do código. Se um programa "nasce" acreditando que vai morar no endereço 100, mas o Sistema Operacional o joga no endereço 400, o hardware quebraria se não houvesse uma solução dinâmica.

Aqui está o detalhamento técnico do Tempo de Vinculação (Binding Time) e da Relocação Dinâmica para o seu repositório:

7.4.3 Tempo de Vinculação (Binding Time)

O "momento da verdade" em que um nome simbólico (como L ou MARIA) vira um endereço físico na RAM pode ocorrer em seis fases distintas. Quanto mais tarde isso acontece, mais flexível é o programa:

 1. Programação: Endereços fixos no código (ex: JMP 0x100).

 2. Tradução (Assembler): O código só roda onde o assembler decidiu.

 3. Ligação (Linker): O .exe já sai com endereços fixos (problema da Fig. 7.16).

 4. Carregamento (Loader): O programa é ajustado no momento em que entra na RAM.

 5. Carga do Reg. Base: O endereço é calculado somando um valor em um registrador de hardware.

 6. Execução: O endereço é resolvido instrução por instrução (Memória Virtual/MMU).

Figura 7.16: O Desastre da Movimentação Estática

Se o ligador gerou endereços absolutos (Vinculação em Tempo de Ligação) e o programa for movido, os saltos apontarão para o lugar antigo:

+---------------------------------------------------------------------------+
| PROBLEMA DA MOVIMENTAÇÃO (RELOCAÇÃO ESTÁTICA)                             |
+-------------------+-----------------------+-------------------------------+
| ESTADO ORIGINAL   | ESTADO APÓS MOVER     | RESULTADO                     |
| (Base 100)        | (Base 400)            | (ERRO)                        |
+-------------------+-----------------------+-------------------------------+
| Instrução:        | Instrução:            | A CPU tentará ler o endereço  |
| BRANCH TO 300     | BRANCH TO 300         | 300, mas o dado agora está em |
|                   |                       | 600!                          |
+-------------------+-----------------------+-------------------------------+
| Alvo (MOVE):      | Alvo (MOVE):          | O programa trava ou acessa    |
| no endereço 300   | no endereço 600       | memória de outro processo.    |
+-------------------+-----------------------+-------------------------------+

A Solução: Endereçamento Relativo e Registradores de BasePara evitar o custo de "remendar" o código toda vez que ele se move, as CPUs modernas usam a Relocação Dinâmica:

 - O programa é escrito usando endereços relativos ao início do módulo (Offsets).

 - A UC possui um Registrador de Base.
 
 - Sempre que uma instrução referencia a memória, o hardware soma automaticamente: 
 
   Endereço_Físico = Endereço_Instrução + Registrador_Base.

Figura 7.16: Falha de Execução por Deslocamento (Relocação Estática)

Endereço Físico   Instrução (Binário no RDM)     Estado do Salto
      (RAM)
      2200 +------------------------------+
           |       MÓDULO D               |
      2100 |   MOVE S TO X                |
      1900 |   BRANCH TO 1800  -----------|---> [APONTA PARA LUGAR ERRADO!]
      1800 +------------------------------+     (Deveria ser 2100)
           |                              |
      1800 +------------------------------+
           |       MÓDULO C               |
      1600 |   MOVE R TO X                |
      1400 |   BRANCH TO 1300  -----------|---> [APONTA PARA LUGAR ERRADO!]
      1300 |   CALL 1600       -----------|---> [APONTA PARA LUGAR ERRADO!]
           +------------------------------+
           |                              |
      1300 +------------------------------+
           |       MÓDULO B               |
      1100 |   MOVE Q TO X                |
       800 |   BRANCH TO 800   -----------|---> [APONTA PARA LUGAR ERRADO!]
           +------------------------------+
           |                              |
       800 +------------------------------+
           |       MÓDULO A               |
       700 |   CALL 500        -----------|---> [APONTA PARA LUGAR ERRADO!]
       600 |   MOVE P TO X                |
       400 |   BRANCH TO 300   -----------|---> [APONTA PARA O VAZIO (End. 300)]
       400 +------------------------------+

Por que o programa quebrou?

Observe o Módulo A:

 - Originalmente: Estava no endereço 100. O BRANCH apontava para o MOVE em 300 ($100 + 200$).
 
 - Agora: O programa foi movido 300 endereços para cima (Base 400).
 
 - O Erro: A instrução no endereço 400 ainda contém o valor binário do salto para o endereço 300. Porém, no endereço 300 não há mais nada do seu programa! O MOVE que ele busca está agora em 600 ($400 + 200$).

Esta seção descreve a "ponte" final entre o código e a execução física, apresentando três soluções fundamentais para que o erro da Figura 7.16 (o crash por deslocamento) nunca aconteça na prática.

Aqui está o resumo dos mecanismos de Relocação em Tempo de Execução organizado para o seu repositório arquitetura_computadores:

Mecanismos de Relocação DinâmicaPara que um programa possa ser movido na RAM sem "quebrar", o hardware deve intervir no momento em que o endereço sai da CPU em direção à memória.

Mecanismos de Relocação em Tempo de Execução

+-----------------------+---------------------------------------+-----------------------+
| MECANISMO             | FUNCIONAMENTO                         | FLEXIBILIDADE         |
+-----------------------+---------------------------------------+-----------------------+
| Paginação             | Mapeia endereços virtuais (fixos) para| MÁXIMA: O programa    |
|                       | páginas físicas via Tabela de Páginas.| pode estar espalhado  |
|                       |                                       | de forma não contígua.|
+-----------------------+---------------------------------------+-----------------------+
| Registrador de        | O hardware soma automaticamente o     | MÉDIA: O programa deve|
| Relocação             | valor de um reg. "Base" a cada        | ser movido como um    |
|                       | endereço no momento do acesso.        | bloco único (contíguo)|
+-----------------------+---------------------------------------+-----------------------+
| Código Independente   | As instruções usam deslocamentos      | ALTA: O código roda em|
| de Posição (PIC)      | relativos ao CI (Counter) em vez de   | qualquer lugar sem    |
|                       | endereços absolutos (Ex: PC + Offset).| auxílio do hardware.  |
+-----------------------+---------------------------------------+-----------------------+

A Diferença entre Endereço Virtual e Físico

O texto traz um insight valioso: o Ligador cria um Espaço de Endereço Virtual.

 - Os nomes MARIA, ROBERTA, etc., são vinculados a endereços virtuais (estáticos dentro do .exe).

 - A MMU (Memory Management Unit) ou o Registrador de Relocação vincula esses endereços virtuais aos endereços físicos da RAM no momento da execução.

## 7.4.4 Ligação dinâmica (Dynamic Linking)

A Ligação Dinâmica é o auge da flexibilidade em arquitetura de sistemas. Enquanto a ligação estática (que vimos antes) "cola" tudo antes do programa rodar, a dinâmica aplica o princípio de "Lazy Loading" (carregamento sob demanda): o código só é buscado e ligado se, e quando, for realmente necessário.

Aqui está o resumo técnico deste mecanismo, com foco no modelo pioneiro do MULTICS, para o seu repositório arquitetura_computadores:

Diferente do modelo tradicional, aqui o compilador não insere o endereço real da função, mas sim um ponteiro para um Segmento de Ligação.

O Processo no MULTICS (Passo a Passo)

1. A Armadilha (Trap): O compilador gera uma instrução de chamada que aponta para um endereço inválido propositalmente.

2. A Exceção: Quando a UC tenta executar essa chamada, o hardware detecta o endereço inválido e gera uma interrupção (trap) para o Sistema Operacional.

3. A Busca: O ligador dinâmico assume o controle, lê o nome da função (string) que está logo após o endereço inválido e busca o arquivo correspondente no disco.

4. A Cura: O ligador carrega o procedimento na memória virtual, descobre seu endereço e sobrescreve aquele endereço inválido original com o endereço real.

5. A Continuidade: A instrução é reiniciada. Agora, o ponteiro é válido e o código flui normalmente.

Figura 7.17: O Segmento de Ligação (Antes e Depois)

(a) ANTES DA PRIMEIRA CHAMADA             (b) APÓS A LIGAÇÃO DINÂMICA
+----------------------------+            +----------------------------+
|    Segmento de Ligação     |            |    Segmento de Ligação     |
+----------------------------+            +----------------------------+
| Endereço: [ INVÁLIDO ]  ---|---> ERRO!| Endereço: [ 0x7FFF0010 ]---|---> VÁLIDO!
+----------------------------+   (Trap)   +----------------------------+     (CALL)
| Nome: "PROC_ERRO_99"       |            | Nome: "PROC_ERRO_99"       |
+----------------------------+            +----------------------------+
| ...outros blocos...        |            | ...outros blocos...        |
+----------------------------+            +----------------------------+

Esta figura detalha visualmente o conceito de Indireção. O compilador não sabe onde a função EARTH está, então ele cria um "buraco" (a palavra indireta) que aponta para um nome. O hardware, ao tentar acessar esse endereço inválido, força o sistema a resolver o mistério em tempo de execução.

Figura 7.17: O Mecanismo de Ligação Dinâmica (MULTICS)

(a) ESTADO INICIAL (TRAP)                 (b) ESTADO VINCULADO (DIRETO)
+----------------------------+            +----------------------------+
|   SEGMENTO DE LIGAÇÃO      |            |   SEGMENTO DE LIGAÇÃO      |
+----------------------------+            +----------------------------+
| [ ENDEREÇO INVÁLIDO ] <----|--+         | [ ADDR: 0x00A410 ] <-------|--+
+----------------------------+  |         +----------------------------+  |
| "E" | "A" | "R" | "T" | "H"|  |         | "E" | "A" | "R" | "T" | "H"|  |
+----------------------------+  |         +----------------------------+  |
| [ ENDEREÇO INVÁLIDO ]      |  |         | [ ENDEREÇO INVÁLIDO ]      |  |
+----------------------------+  |         +----------------------------+  |
| "A" | "I" | "R" | " " | " "|  |         | "A" | "I" | "R" | " " | " "|  |
+----------------------------+  |         +----------------------------+  |
                                |                                         |
   A UC tenta acessar este -----+            A UC agora acessa o ---------+
   ponto e gera uma EXCEÇÃO                  endereço real diretamente

Funcionamento Técnico

1. O Gatilho: No estado (a), a instrução CALL EARTH aponta para a "Palavra Indireta". Como o conteúdo é um padrão de bits inválido, a UC interrompe a execução e chama o Ligador Dinâmico.

2. A Resolução: O Ligador lê a string "EARTH", localiza o procedimento no disco, carrega-o na RAM e descobre seu endereço físico (ex: 0x00A410).

3. A Sobrescrita: O Ligador substitui o "Endereço Inválido" pelo valor 0x00A410.

4. A Reexecução: O programa volta um passo e tenta o CALL de novo. Desta vez, ele encontra um caminho válido.

## 7.4.4 Ligação Dinâmica no Windows (DLL)

Esta evolução do conceito do MULTICS para o ecossistema Windows mostra como a arquitetura de sistemas se tornou eficiente ao tratar o código como um recurso compartilhável. A DLL não é apenas um arquivo; é uma estratégia para economizar o recurso mais precioso do hardware: a Memória Principal (RAM).

A principal inovação das DLLs é permitir que o Código e Constantes (Seção 4 do módulo-objeto) residam em um único local da memória física, enquanto múltiplos processos "enxergam" esse código em seus próprios espaços de endereçamento virtual.

Figura 7.18: Compartilhamento de DLL entre Processos

ESPAÇO VIRTUAL                      MEMÓRIA FÍSICA                     ESPAÇO VIRTUAL
        (PROCESSO 1)                           (RAM)                           (PROCESSO 2)
+-----------------------+              +-----------------------+              +-----------------------+
| Código do Programa 1  |              | Código do Programa 1  |              | Código do Programa 2  |
+-----------------------+              +-----------------------+              +-----------------------+
| Chamada para Proc. A--|---+          | Código do Programa 2  |          +---|--Chamada para Proc. C |
+-----------------------+   |          +-----------------------+          |   +-----------------------+
                            |          |      ARQUIVO DLL      |          |
                            |          | +-------------------+ |          |
                            +--------->| | Procedimento A    | |<---------+
                                       | +-------------------+ |
                                       | | Procedimento B    | |
                                       | +-------------------+ |
                                       | | Procedimento C    | |
                                       | +-------------------+ |
                                       | | Procedimento D    | |
                                       | +-------------------+ |
                                       +-----------------------+

 Modos de Vinculação às DLLs

O Windows oferece dois caminhos, dependendo de quando você quer que o "custo" do carregamento ocorra:  

Comparação: Métodos de Vinculação de DLL (Windows)

+----------------+-------------------------------+-------------------------------+
| CARACTERÍSTICA | LIGAÇÃO IMPLÍCITA             | LIGAÇÃO EXPLÍCITA             |
+----------------+-------------------------------+-------------------------------+
| Mecanismo      | Usa "Biblioteca de Importação"| Usa chamadas de API do Windows|
|                | (.lib) para resolver nomes.   | (ex: LoadLibrary, GetProcAddr)|
+----------------+-------------------------------+-------------------------------+
| Carregamento   | Automático: ocorre quando o   | Manual: ocorre no meio da     |
|                | programa principal inicia.    | execução (sob demanda).       |
+----------------+-------------------------------+-------------------------------+
| Facilidade     | TRANSPARENTE: para o programar| COMPLEXA: exige código extra  |
|                | parece uma ligação estática.  | para carregar e gerenciar end.|
+----------------+-------------------------------+-------------------------------+
| Uso Comum      | APIs padrão (Kernel32, GDI) e | Plugins, módulos opcionais e  |
|                | bibliotecas gráficas.         | sistemas de extensões/temas.  |
+----------------+-------------------------------+-------------------------------+
| Desvinculação  | Quando o processo termina.    | Via chamada explícita         |
|                |                               | (FreeLibrary).                |
+----------------+-------------------------------+-------------------------------+

• Ligação dinâmica no UNIX

O modelo de bibliotecas compartilhadas no UNIX (geralmente arquivos .so - Shared Objects) foca na simplicidade e na padronização, utilizando predominantemente a ligação implícita para garantir que as dependências essenciais, como a biblioteca padrão C (libc), estejam sempre disponíveis de forma eficiente.

Bibliotecas Compartilhadas no UNIX (.so)

Diferente do Windows, que oferece flexibilidade total entre explícita e implícita, o UNIX tradicional prioriza a estrutura de duas partes para garantir que o binário saiba exatamente o que esperar ao ser carregado.

Estrutura de Biblioteca Compartilhada (UNIX)

+---------------------------------------------------------------------------------------+
| COMPONENTES DA BIBLIOTECA COMPARTILHADA (.so)                                         |
+---+-------------+-------------------+-------------------------------------------------+
| # | PARTE       | NOME              | FUNÇÃO TÉCNICA                                  |
+---+-------------+-------------------+-------------------------------------------------+
| 1 | Hospedeira  | Stub / Import Lib | Código estático no seu .exe. Contém os nomes dos|
|   |             |                   | procedimentos e "ponteiros" para a parte alvo.  |
+---+-------------+-------------------+-------------------------------------------------+
| 2 | Alvo        | Target Library    | O arquivo .so real (ex: libc.so). Contém o      |
|   |             |                   | binário que será mapeado e compartilhado na RAM.|
+---+-------------+-------------------+-------------------------------------------------+

## 7.5 Resumo

Embora a maioria dos programas pudesse e devesse ser escrita em uma linguagem de alto nível, existem situações
nas quais é necessária uma linguagem de montagem, ao menos em parte. Programas para computadores portáteis pobres
em recursos, tais como smart cards, processadores embutidos em eletrodomésticos e agendas digitais portáteis sem fio são
candidatos potenciais. Um programa em linguagem de montagem é uma representação simbólica para algum programa
subjacente em linguagem de máquina. Ele é traduzido para a linguagem de máquina por um programa denominado
assembler.

Quando a execução extremamente rápida é crítica para o sucesso de alguma aplicação, uma abordagem melhor do
que escrever tudo em linguagem de montagem é primeiro escrever todo o programa em uma linguagem de alto nível,
então medir onde ele está gastando seu tempo e, por fim, reescrever somente as partes do programa que são muito
usadas. Na prática, em geral uma pequena fração do código é responsável por uma grande fração do tempo de execução.

Muitos assemblers têm um recurso de macro que permite ao programador dar nomes simbólicos a sequências de
código muito usadas para inclusão subsequente. Em geral, essas macros podem ser parametrizadas de modo direto.
Macros são executadas por um tipo de algoritmo de processamento literal de cadeias.

A maioria dos assemblers é de duas passagens. A passagem um é dedicada a montar uma tabela de símbolos para
rótulos, literais e identificadores especificamente declarados. Os símbolos podem ser mantidos sem ordenação e então
pesquisados linha por linha, ou primeiro ordenados e depois pesquisados usando busca binária,ou passar por uma
uma operação de hash. Se não for preciso apagar os símbolos durante a passagem um, o hashing costuma ser
o melhor método. A passagem dois faz a geração de código. Algumas pseudoinstruções são executadas na passagem um e
algumas na passagem dois.

Programas montados de modo independente podem ser interligados para formar um programa binário executável
que pode ser executado. Esse trabalho é feito pelo ligador. Suas principais tarefas são relocação e vin- culação de nomes.
Ligação dinâmica é uma técnica na qual certos procedimentos só são ligados quando forem chamados. As DLLs do
Windows e as bibliotecas compartilhadas do UNIX usam ligação dinâmica.


