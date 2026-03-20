![alt text](image-73.png)

# O nível de microarquitetura

O nível acima do lógico digital é o nível de microarquitetura. Sua função é executar o nível ISA (Instruction Set Architecture – arquitetura do conjunto de instruções) acima dele, como ilustrado na Figura 1.2. O projeto do nível de microarquitetura depende da ISA que está sendo implementada, bem como das metas
de custo e desempenho do computador. Muitas ISAs modernas, em particular projetos RISC, têm instruções simples que normalmente podem ser executadas em um único ciclo de clock. ISAs mais complexas, como a Core i7, podem exigir muitos ciclos para executar uma única instrução. Executar uma instrução pode requerer localizar os operandos na memória, ler esses operandos e armazenar resultados de volta na memória. A sequência de operações dentro de uma única instrução muitas vezes leva a uma abordagem de controle diferente da adotada para ISAs simples.

## 4.1 Um exemplo de microarquitetura
O ideal seria que nós apresentássemos este tópico explicando os princípios gerais do projeto de microarquitetura. Infelizmente, não há princípios gerais; cada microarquitetura é um caso especial. Por conseguinte, resolvemos discutir um exemplo detalhado. Para nossa ISA que servirá de exemplo, escolhemos um subconjunto da Java Virtual Machine, como prometemos no Capítulo 1. Esse subconjunto contém somente instruções com inteiros, portanto, nós o denominamos IJVM para enfatizar que ele trata somente de inteiros. Começaremos pela descrição da microarquitetura sobre a qual realizaremos a IJVM, arquitetura que tem algumas instruções complexas. Muitas dessas arquiteturas costumam ser executadas ao se recorrer à microprogra- mação, como discutimos no Capítulo 1. Embora a IJVM seja pequena, é um bom ponto de partida para descrever o controle e a sequência de instruções.

Nossa microarquitetura conterá um microprograma (em ROM) cuja tarefa é buscar, decodificar e executar instruções IJVM. Não podemos usar o interpretador Oracle JVM para o microprograma porque precisamos de um microprograma diminuto, que comande com eficiência portas individuais no hardware propriamente dito. Por comparação, o interpretador Oracle JVM foi escrito em C por questão de portabilidade, e não pode controlar o hardware de forma alguma.

Como o hardware utilizado consiste apenas nos componentes básicos descritos no Capítulo 3, em teoria, se o leitor entender completamente esse capítulo, deverá estar habilitado a sair e comprar uma sacola de transistores e montar esse subconjunto da máquina JVM. Os estudantes que conseguirem executar essa tarefa com sucesso ganharão créditos extras (e um exame psiquiátrico completo).

Um modelo conveniente para o projeto de microarquitetura é pensar no projeto como um problema de programação no qual cada instrução no nível ISA é uma função a ser chamada por um programa mestre. Nesse modelo, o programa mestre é um laço simples, sem fim, que determina uma função a ser invocada, chama a função e então começa de novo, algo muito parecido com a Figura 2.3.

O microprograma tem um conjunto de variáveis denominado estado do computador, que pode ser acessado por todas as funções. Cada função altera ao menos algumas das variáveis que compõem o estado. Por exemplo, o contador de programa (Program Counter – PC) é parte do estado. Ele indica a localização da memória que
contém a próxima função (isto é, instrução ISA) a ser executada. Durante a execução de cada instrução, o PC é incrementado para indicar a próxima instrução a ser executada.

Instruções IJVM são curtas e fáceis. Cada instrução tem alguns campos, em geral um ou dois, e cada um deles tem alguma finalidade específica. O primeiro campo de toda instrução é o opcode (abreviatura de operation code – código de operação), que identifica a instrução, informando se ela é um ADD ou um BRANCH, ou qualquer
outra coisa. Muitas instruções têm um campo adicional que especifica o operando. Por exemplo, instruções que acessam uma variável local precisam de um campo que identifique qual variável.

Esse modelo de execução, às vezes denominado ciclo buscar-decodificar-executar, é útil em termos abstratos e também pode ser a base para execução de ISAs como a IJVM, isto é, que tenham instruções complexas. Logo adiante, descreveremos como ela funciona, qual é o aspecto da microarquitetura e como ela é controlada pelas
microinstruções; cada uma delas controla o caminho de dados durante um ciclo. A lista de microinstruções forma o microprograma, que apresentaremos e discutiremos detalhadamente.

## 4.1.1 O caminho de dados
O caminho de dados é a parte da CPU que contém a ULA, suas entradas e suas saídas. O caminho de dados de nossa microarquitetura de exemplo é mostrado na Figura 4.1. Embora tenha sido cuidadosamente otimizado para interpretar programas IJVM, ele guarda uma razoável semelhança com o caminho de dados usado na maioria das máquinas. Contém vários registradores de 32 bits, aos quais atribuímos nomes simbólicos como PC, SP e MDR. Embora alguns desses nomes sejam familiares, é importante entender que esses registradores são acessíveis apenas no nível de microarquitetura (pelo microprograma). Eles recebem esses nomes porque em geral contêm um valor correspondente à variável do mesmo nome na arquitetura do nível de ISA. A maior parte dos registradores pode dirigir seu conteúdo para o barramento B. A saída da ULA comanda o deslocador e em seguida o barramento C, cujo valor pode ser escrito em um ou mais registradores ao mesmo tempo. Por enquanto, não há nenhum barramento A; incluiremos um mais adiante.

A ULA é idêntica à mostrada nas figuras 3.18 e 3.19. Sua função é determinada por seis linhas de controle. O segmento de reta diagonal com rótulo “6” na Figura 4.1 indica que há seis linhas de controle de ULA, a saber: F0 e F1 para determinar a operação da ULA; ENA e ENB para habilitar as entradas individualmente; INVA para inverter a entrada esquerda e INC para forçar um vai-um para o bit de ordem baixa, somando 1 ao resultado. Contudo, nem todas as 64 combinações de linhas de controle de ULA fazem algo de útil.

Algumas das combinações mais interessantes são mostradas na Figura 4.2. Nem todas essas funções são necessárias para a IJVM, mas, para a JVM completa, muitas delas viriam a calhar. Em muitos casos, há várias possibilidades de conseguir o mesmo resultado. Nessa tabela, + significa “mais” aritmético e – significa “menos”
aritmético; assim, por exemplo, –A significa o complemento de dois de A.

Figura 4.1   Caminho de dados da microarquitetura de exemplo usada neste capítulo.
DE E PARA A MEMÓRIA PRINCIPAL
              ^            |
              |            v
        +-----------+-----------+
        |    MAR    |    MDR    | <--- Registradores de Controle
        +-----------+-----------+      da Memória
              ^            |
              |     +------+------+
              |     |     PC      |
              |     +-------------+
              |     |     MBR     | <--- Memory Byte Register
              |     +-------------+
              |     |     SP      | <--- Stack Pointer
              |     +-------------+
              |     |     LV      | <--- Local Variables
 BARRAMENTO C |     +-------------+     BARRAMENTO B
   (Escrita)  |     |     CPP     |      (Leitura)
              |     +-------------+
              |     |     TOS     | <--- Top of Stack
              |     +-------------+
              |     |     OPC     |
              |     +-------------+
              |     |      H      | ----+
              |     +------+------+     |
              |            |            |
              +------------|------------+-----> [ Sinais de Controle ]
                           |            |       (Habilita B / Escreve C)
                           v            v
                        +---------------+
                        |    A     B    | <--- Entradas da ULA
                        |               |
       [Controle] ----> |      ULA      | ----> [ Flags N, Z ]
                        |               |
                        +-------+-------+
                                |
                                v
                        +---------------+
       [Controle] ----> |  DESLOCADOR   | <--- (Shifter)   <--------/---- Controle de deslocador
                        +-------+-------+                           2
                                |
                                +---------------------------+
                                                            |
        <---------------------------------------------------+

Microarquitetura de Exemplo (Datapath)

Processamento                                          Armazenamento

ULA (Cálculos)                                         Registradores
ULA (Executa operações lógicas e aritméticas)          PC, SP, LV, CPP, TOS, OPC, H
Deslocador (Realiza shifts à esquerda/direita)         H (Retenção para entrada A)

                                                       BARRAMENTO INTERNO
UC (Controle)                                          RI (Instrução Atual)
UC (Sinais de controle p/ Barramentos B e C)           MBR (Mantém o byte vindo da memória)
REM (Endereços) ---> [B. Endereços]                    Decodificador
MAR (Memory Address Register)                          Decodificador (Lógica de controle da ULA)
CI (Próxima Inst.)                                     RDM (Dados) <-> [B. Dados]
PC (Program Counter)                                   MDR (Memory Data Register)
CLOCK (Sincronismo)                                    MEMÓRIA PRINCIPAL (RAM)
CLOCK (Ciclo: busca, opera, grava)"                    RAM (Operandos e Instruções)

Caminho de Dados (Datapath) clássico da microarquitetura Mic-1 (comumente usada por Tanenbaum), em um diagrama ASCII detalhado.

Este diagrama é o "coração" do processamento, mostrando como os dados fluem dos registradores, passam pela ULA, sofrem deslocamento e retornam para o armazenamento através dos barramentos.

A ULA da Figura 4.1 precisa de duas entradas de dados: uma entrada esquerda (A) e uma entrada direita (B). Ligado à entrada esquerda está um registrador de retenção, H. Ligado à entrada direita está o barramento B, que pode ser carregado por cada uma de nove fontes, indicadas pelas nove setas cinza que chegam até ele. Um projeto alternativo, com dois barramentos completos, tem um conjunto diferente de opções de projeto e será discutido mais adiante neste capítulo.

H pode ser carregado com a escolha de uma função da ULA que passe diretamente da entrada direita (vinda do barramento B) para a saída da ULA. Uma função desse tipo seria somar as entradas da ULA, porém, com ENA negado, de modo que a entrada esquerda é forçada a zero. Adicionar zero ao valor no barramento B resulta somente no valor no barramento B. Então, esse resultado pode ser passado pelo deslocador sem modificação e armazenado em H.

Além das funções citadas, duas outras linhas de controle podem ser usadas independentemente para controlar a saída da ULA. SLL8 (Shift Left Logical) desloca o conteúdo para a esquerda por 1 byte, preenchendo os 8 bits menos significativos com zeros. SRA1 (Shift Right Arithmetic) desloca o conteúdo para a direita por 1 bit,deixando inalterado o bit mais significativo.

## Insight para seus projetos
Nesta arquitetura, o Barramento B é de leitura única por ciclo, e o Barramento C é o caminho de volta para os resultados.

 1. O papel do registrador H: Note que a entrada A da ULA vem sempre de H, enquanto a entrada B pode vir de qualquer outro registrador. Isso significa que, para somar dois valores (ex: SP + 1), a UC deve primeiro mover um valor para H e depois habilitar o outro no barramento B.

 2. Eficiência em Pilhas: Registradores como SP (Stack Pointer) e TOS (Top of Stack) são fundamentais para as Torres de Hanói, permitindo que o topo da pilha seja acessado sem cálculos extras de endereço.

Figura 4.2   Combinações úteis de sinais de ULA e a função executada.
+----+----+-----+-----+-----+-----+------------------+
| F0 | F1 | ENA | ENB | INV | INC | FUNÇÃO EXECUTADA |
+----+----+-----+-----+-----+-----+------------------+
| 0  | 1  |  1  |  0  |  0  |  0  | A                |
| 0  | 1  |  0  |  1  |  0  |  0  | B                |
| 0  | 1  |  1  |  0  |  1  |  0  | NOT A            |
| 1  | 0  |  1  |  1  |  0  |  0  | NOT B            |
| 1  | 1  |  1  |  1  |  0  |  0  | A + B            |
| 1  | 1  |  1  |  1  |  0  |  1  | A + B + 1        |
| 1  | 1  |  1  |  0  |  0  |  1  | A + 1            |
| 1  | 1  |  0  |  1  |  0  |  1  | B + 1            |
| 1  | 1  |  1  |  1  |  1  |  1  | B - A            |
| 1  | 1  |  0  |  1  |  1  |  0  | B - 1            |
| 1  | 1  |  1  |  0  |  1  |  1  | - A              |
| 0  | 0  |  1  |  1  |  0  |  0  | A AND B          |
| 0  | 1  |  1  |  1  |  0  |  0  | A OR B           |
| 0  | 1  |  0  |  0  |  0  |  0  | 0                |
| 1  | 1  |  0  |  0  |  0  |  1  | 1                |
| 1  | 1  |  0  |  0  |  1  |  0  | - 1              |
+----+----+-----+-----+-----+-----+------------------+

Organização de Hardware: Processamento da ULA (Seu Padrão)
Veja como os componentes que você mapeou interagem com esses sinais:

Processamento                                              Armazenamento
ULA (Cálculos)                                             Registradores
ULA (Recebe os 6 bits de controle da tabela acima)         H (Fornece a entrada A)
Deslocador (Pode dobrar o resultado de A+B)                Barramento B (Fornece a entrada B)

                                                           BARRAMENTO INTERNO
UC (Controle)                                              RI (Instrução Atual)
UC (Gera os sinais F0, F1, ENA, ENB, INV, INC)"            MBR (Pode ser a fonte do sinal para o Barramento B)
REM (Endereços) ---> [B. Endereços]                        Decodificador
MAR (Guarda o endereço se a função for carregar dados)     Decodificador (Traduz o Opcode para os bits da tabela)
CI (Próxima Inst.)                                         RDM (Dados) <-> [B. Dados]
PC (Incrementado usando a função A + 1 da ULA)             MDR (Recebe o resultado da ULA via Barramento C)
CLOCK (Sincronismo)                                        MEMÓRIA PRINCIPAL (RAM)
CLOCK (Garante que os sinais estabilizem antes da soma)    RAM (Onde os resultados finais são armazenados)

É explicitamente possível ler e escrever o mesmo registrador em um único ciclo. Por exemplo, é permitido colocar SP no barramento B, desativar a entrada esquerda da ULA, habilitar o sinal INC e armazenar o resultado em SP, desse modo incrementando SP em 1 (veja a oitava linha na Figura 4.2). Como um registrador pode ser lido e escrito no mesmo ciclo sem produzir lixo? A solução é que leitura e escrita na verdade são executadas em instantes diferentes dentro do ciclo. Quando um registrador é selecionado como a entrada direita da ULA, seu valor é colocado no barramento B no início do ciclo e ali é mantido durante todo o ciclo. Depois, a ULA realiza seu trabalho, produzindo um resultado que passa pelo deslocador e entra no barramento C. Próximo ao final do ciclo, quando se sabe que as saídas da ULA e deslocador são estáveis, um sinal de clock ativa o armazenamento do conteúdo do barramento C e o passa para um ou mais dos registradores. Um deles pode perfeitamente ser aquele que forneceu sua saída ao barramento B. A temporização exata do caminho de dados possibilita ler e escrever o mesmo registrador em um único ciclo, como descreveremos a seguir.

## Insight para seus projetos
Observe a linha 1 1 1 0 0 1 (A + 1).
 - No seu sistema, o PC (CI) é incrementado a cada ciclo de busca.
 - Para isso, a UC coloca o valor do PC no Barramento B, habilita os sinais para somar 1 e grava o resultado de volta no PC através do Barramento C.
 - Nas Torres de Hanói, a função B - 1 (sinais 1 1 0 1 1 0) é usada constantemente para calcular o parâmetro $n-1$ das chamadas recursivas.

## Temporização do caminho de dados
A temporização desses eventos é mostrada na Figura 4.3. Um pulso curto é produzido no início de cada ciclo de clock. Ele pode ser derivado do clock principal, como ilustra a Figura 3.20(c). Na borda descendente do pulso, os bits que comandarão todas as portas são ajustados, o que leva um tempo finito e conhecido, ∆w. Depois, o registrador necessário no barramento B é selecionado e conduzido até este. Demora ∆x para o valor ficar estável. Então, a ULA e o deslocador começam a operar com dados válidos. Após outro ∆y, as saídas da ULA e do deslocador estão estáveis. Após um ∆z adicional, os resultados se propagaram ao longo do barramento C até os registradores, onde podem ser carregados na borda ascendente do próximo pulso. A carga deve ser acionada pela borda ascendente do próximo pulso e de forma rápida, de modo que, se alguns dos registradores de entrada forem alterados, o efeito não será sentido no barramento C até muito tempo após os registradores terem sido carregados.

Figura 4.3   Diagrama de temporização de um ciclo de caminho de dados.

CLOCK 1                                          CLOCK 2
  |                                                |
  v (Borda Ascendente)                             v
--+                                              +-----------
  |       CICLO DE CLOCK 1 (T1 + T2 + T3 + T4)     |
  +----------------------------------------------+
  |                                              |
  |  Δw: Prepara sinais (UC -> MIR)              |
  |  |---->|                                     |
  |                                              |
  |  Δx: Drive H e Barramento B (Leitura)        |
  |        |------>|                             |
  |                                              |
  |  Δy: Operação ULA e Deslocador               |
  |                |---------->|                 |
  |                                              |
  |  Δz: Propagação do Deslocador p/ Registr.    |
  |                            |-------->|       |
  |                                              |
  |                                      [CARGA] |
  |      (Os registradores capturam os dados     |
  |       do Barramento C nesta borda) --------->|
  |                                              |
  |  Novo MPC/MIR carregado aqui ----------------^

Tabela: Organização de Hardware e o Tempo (Seu Padrão)Cada intervalo ($\Delta$) da Figura 4.3 ativa partes diferentes da sua tabela de hardware:

Processamento                                                  Armazenamento
ULA (Cálculos)                                                 Registradores
:--------------------------------------------------------------:-----------------------------------------------------------------
Δy: ULA e Deslocador processam os dados.                       Δx: Registradores (H, SP, etc.) colocam dados no Barramento B.
                                                               Início do Ciclo 2: Registradores são carregados via Barramento C.
                                                               BARRAMENTO INTERNO
UC (Controle)                                                  RI (Instrução Atual)
Δw: UC prepara sinais para comandar o caminho.                 MPC/MIR: Carregados com a próxima microinstrução no fim do ciclo.
REM (Endereços) ---> [B. Endereços]                            Decodificador
MAR (Estabiliza o endereço para a memória).                    Decodificador (Traduz o sinal para os barramentos).
CI (Próxima Inst.)                                             RDM (Dados) <-> [B. Dados]
PC (Preparado para incremento no próximo ciclo).               MDR (Recebe dados da RAM simultaneamente ao fim do ciclo).
CLOCK (Sincronismo)                                            MEMÓRIA PRINCIPAL (RAM)
CLOCK: Define o ritmo total (Soma de Δw+Δx+Δy+Δz).             RAM (Acessada em paralelo enquanto o datapath trabalha).

## Insight para seus projetos
O motivo de termos esses delays (Δ) é físico: 
 - Δw: Os fios da Unidade de Controle precisam de tempo para "avisar" os registradores quem deve abrir a porta para o Barramento B.
 - Δx: O dado precisa viajar fisicamente do registrador até a entrada da ULA.
 - Δy: A eletrônica dentro da ULA precisa de tempo para somar os bits e gerar o vai-um (Carry).
 - Δz: O resultado sai da ULA e precisa percorrer o Barramento C de volta para o topo da CPU.
 Se o seu CLOCK for rápido demais e não esperar a soma desses quatro intervalos, o processador tentará gravar um dado que ainda não "chegou" ao destino, causando erros no seu algoritmo.

Também na borda ascendente do pulso, o registrador que comanda o barramento B para de fazê-lo preparando-se para o próximo ciclo. MPC, MIR e a memória são mencionados na figura; em breve, discutiremos seus papéis.

É importante perceber que, ainda que não haja nenhum elemento de armazenamento no caminho de dados, há um tempo de propagação finito por ele. Uma alteração de valor no barramento B só provocará uma alteração no barramento C após um tempo finito (por causa dos atrasos finitos de cada etapa). Por conseguinte, mesmo que
um armazenamento altere um dos registradores de entrada, o valor estará guardado em segurança no registrador muito antes que o valor (agora incorreto) que está sendo colocado no barramento B (ou H) possa alcançar a ULA.

Fazer esse esquema funcionar requer rígida temporização, um ciclo de clock longo, um tempo mínimo de propagação pela ULA conhecido e uma carga rápida dos registradores pelo barramento C. Contudo, com cuidadosa engenharia, o caminho de dados pode ser projetado de modo que funcione corretamente o tempo todo. Na
verdade, as máquinas reais funcionam desse modo.

Um modo um pouco diferente de ver o ciclo de caminho de dados é imaginá-lo fragmentado em subciclos implícitos. O início do subciclo 1 é acionado pela borda descendente do clock. As atividades que ocorrem durante os subciclos são mostradas a seguir, junto com as extensões dos subciclos (entre parênteses).

    1. Os sinais de controle são ajustados (∆w).
    2. Os registradores são carregados no barramento B (∆x).
    3. Operação da ULA e deslocador (∆y).
    4. Os resultados se propagam ao longo do barramento C de volta aos registradores (∆z).

O intervalo de tempo após ∆z oferece alguma tolerância, pois os tempos não são exatos. Na borda ascendente do próximo ciclo de clock, os resultados são armazenados nos registradores.

Dissemos que é melhor imaginar os subciclos como implícitos. Com isso, queremos dizer que não há nenhum pulso de clock ou outros sinais explícitos que indiquem à ULA quando operar ou que digam aos resultados que entrem no barramento C. Na verdade, a ULA e o deslocador funcionam o tempo todo. Contudo, suas entradas são lixo até um tempo ∆w + ∆x após a borda descendente do clock. Do mesmo modo, suas saídas são lixo até que ∆w + ∆x + ∆y tenha transcorrido após a borda descendente do clock. Os únicos sinais explícitos que comandam o caminho de dados são a borda descendente do clock, que inicia o ciclo do caminho de dados, e a borda ascendente, que carrega os registradores a partir do barramento C. As outras fronteiras de subciclos são determinadas implicitamente pelos tempos de propagação inerentes dos circuitos envolvidos. Cabe aos engenheiros de projeto garantir que o tempo ∆w + ∆x + ∆y + ∆z venha suficientemente antes da borda ascendente do clock para fazer as cargas de registrador funcionarem de modo confiável o tempo todo.

## Operação de memória
Nossa máquina tem dois modos diferentes de se comunicar com a memória: uma porta de memória de 32 bits, endereçável por palavra, e outra de 8 bits, endereçável por byte. A porta de 32 bits é controlada por dois registradores, MAR (Memory Address Register – registrador de endereço de memória) e MDR (Memory Data
Register – registrador de dados de memória), como mostra a Figura 4.1. A porta de 8 bits é controlada por um registrador, PC, que lê 1 byte para os 8 bits de ordem baixa do MBR. Essa porta só pode ler dados da memória; ela não pode escrever dados na memória.

Cada um desses registradores (e todos os outros na Figura 4.1) é comandado por um ou dois sinais de controle. Uma seta clara sob um registrador indica um sinal de controle que habilita a saída do registrador para o barramento B. Visto que MAR não tem conexão com o barramento B, não tem sinal de habilitação. H também não
tem esse sinal porque está sempre habilitado, por ser a única entrada esquerda possível da ULA.

Uma seta negra sob um registrador indica um sinal de controle que escreve (isto é, carrega) o registrador a partir do barramento C. Uma vez que MBR não pode ser carregado a partir do barramento C, não tem um sinal de escrita (embora tenha dois outros sinais de habilitação, descritos mais adiante). Para iniciar uma leitura ou escrita da memória, os registradores de memória adequados devem ser carregados e em seguida deve ser emitido um sinal de leitura ou escrita para a memória (não mostrado na Figura 4.1).

MAR contém endereços de palavras, de modo que os valores 0, 1, 2 etc. se referem a palavras consecutivas. PC contém endereços de bytes, portanto, os valores 0, 1, 2 etc. se referem a bytes consecutivos. Assim, colocar um 2 em PC e iniciar uma leitura de memória lerá o byte 2 da memória e o colocará nos 8 bits de ordem baixa do MBR. Colocar 2 em MAR e iniciar uma leitura de memória lerá os bytes 8–11 (isto é, palavra 2) da memória e os colocará em MDR.

Essa diferença de funcionalidade é necessária porque MAR e PC serão usados para referenciar duas partes diferentes da memória. A necessidade dessa distinção ficará mais clara adiante. Por enquanto, basta dizer que a combinação MAR/MDR é usada para ler e escrever palavras de dados de nível ISA e a combinação PC/MBR é
empregada para ler o programa executável de nível ISA, que consiste em uma sequência de bytes. Todos os outros registradores que contêm endereços usam endereço de palavras, como o MAR.

Na implementação física propriamente dita, há apenas uma memória real que funciona com bytes. Permitir que MAR conte palavras (isso é necessário por causa do modo como a JVM é definida) enquanto a memória física conta bytes depende de um truque simples. Quando o MAR é colocado no barramento de endereço, seus 32 bits não são mapeados diretamente para as 32 linhas de endereço, 0–31. Em vez disso, o bit 0 do MAR é ligado à linha 2 do barramento de endereço, o bit 1 do MAR é ligado à linha 3 do barramento de endereço e assim por diante. Os 2 bits superiores do MAR são descartados, visto que só são necessários para endereços de palavra acima de 232, nenhum dos quais é válido para nossa máquina de 4 GB. Usando esse mapeamento, quando MAR é 1, o endereço 4 é colocado no barramento; quando
MAR é 2, o endereço 8 é colocado no barramento e assim por diante. Esse estratagema está ilustrado na Figura 4.4.

Como já mencionamos, dados lidos da memória por uma porta de memória de 8 bits são devolvidos em MBR, um registrador de 8 bits. MBR pode ser copiado (gated) para o barramento B por um entre dois modos: com ou sem sinal. Quando é preciso o valor sem sinal, a palavra de 32 bits colocada no barramento B contém o valor MBR nos 8 bits de ordem baixa e zeros nos 24 bits superiores. Valores sem sinal são úteis para indexar em uma tabela ou quando um inteiro de 16 bits tem de ser montado a partir de 2 bytes consecutivos (sem sinal) na sequência de instrução.

A outra opção para converter o MBR de 8 bits em uma palavra de 32 bits é tratá-lo como um valor com sinal entre –128 e +127 e usar esse valor para gerar uma palavra de 32 bits com o mesmo valor numérico. Essa conversão é feita duplicando o bit de sinal do MBR (o bit mais à esquerda) nas 24 posições superiores de bits do barramento B, um processo denominado extensão de sinal. Quando essa opção é escolhida, os 24 bits superiores serão todos 0s ou todos 1s, dependendo do bit mais à esquerda do MBR de 8 bits ser um 0 ou um 1.196

A Figura 4.4 ilustra um conceito fundamental de arquitetura de computadores: o alinhamento de memória.No Mic-1 (e em muitas CPUs reais), o registrador MAR conta endereços em palavras (geralmente de 4 bytes), mas a memória física é endereçada em bytes. Para converter o endereço de "palavra" para "byte", o hardware realiza um deslocamento de 2 bits para a esquerda, o que equivale a multiplicar por 4 (2^2 = 4).

Mapeamento MAR para Barramento (Figura 4.4)
MAR de 32 bits (Endereço em Palavras)
    +---------------------------------------------+
    | 31 30 29 ...                           2 1 0|
    +--+--+----------------------------------+--+--+
       |  |                                  |  |  |
 Descartados  (Deslocamento p/ esquerda)     |  |  |
   [X][X] |                                  |  |  |
          |   +------------------------------+  |  |
          |   |                                 |  |
          v   v                                 v  v  (Bits fixos)
    +--+--+--+---------------------------------+--+--+
    | 31 30 29 ...                           2 | 0| 0|
    +------------------------------------------+-----+
      Barramento de Endereço (Endereço em Bytes)

Processamento                                                           Armazenamento
ULA (Cálculos)                                                          Registradores
ULA (Calcula o índice de um array, ex: v[i])                            MAR (Guarda o índice da palavra)
Deslocador (Realiza o shift de 2 bits p/ esquerda)                      H (Pode segurar o valor base do endereço)

                                                                        BARRAMENTO INTERNO
UC (Controle)                                                           RI (Instrução Atual)
UC (Sinaliza que uma leitura de memória é necessária)                   MBR (Receberá o dado após o mapeamento)
REM (Endereços) ---> [B. Endereços]                                     Decodificador
MAR mapeado via deslocamento para o barramento                          Decodificador (Ativa a linha de memória correta)
CI (Próxima Inst.)                                                      RDM (Dados) <-> [B. Dados]
PC (Também precisa ser mapeado se for buscar instr.)                    MDR (Dados lidos da RAM)
CLOCK (Sincronismo)                                                     MEMÓRIA PRINCIPAL (RAM)
CLOCK (Sincroniza o tempo de propagação do endereço)                    RAM (Endereçada byte a byte)

## Insight para seus projetos
Por que os dois últimos bits do barramento de endereço são fixos em 00?

 1. Multiplicação por 4: Em binário, adicionar dois zeros à direita de um número é o mesmo que multiplicá-lo por 4.

 2. Alinhamento: Isso garante que a CPU sempre peça endereços que comecem no início de uma palavra (0, 4, 8, 12...).

 3. Aplicação: Se você estiver implementando uma Lista Encadeada no seu diretório estruturas_de_dados, cada ponteiro (que é um endereço) apontará para uma dessas fronteiras alinhadas.

A opção de converter o MBR de 8 bits em um valor de 32 bits com sinal ou sem sinal no barramento B é determinada por qual dos dois sinais de controle (setas claras sob MBR na Figura 4.1) for ativado. A necessidade dessas duas opções é a razão de haver duas setas presentes. A capacidade de fazer o MBR de 8 bits agir como uma fonte de 32 bits para o barramento B é indicada pelo retângulo tracejado na figura.

## 4.1.2 Microinstruções
Para controlar o caminho de dados da Figura 4.1 precisamos de 29 sinais, que podem ser divididos em cinco
grupos funcionais, como descreveremos a seguir:
 - 9 sinais para controlar escrita de dados do barramento C para registradores.
 - 9 sinais para controlar habilitação de registradores dirigidos ao barramento B para a entrada da ULA.
 - 8 sinais para controlar as funções da ULA e do deslocador.
 - 2 sinais (não mostrados) para indicar leitura/escrita na memória via MAR/MDR.
 - 1 sinal (não mostrado) para indicar busca na memória via PC/MBR.

Os valores desses 29 sinais de controle especificam as operações para um ciclo do caminho de dados. Um ciclo consiste em copiar valores dos registradores para o barramento B, propagar os sinais pela ULA e pelo deslocador, dirigi-los ao barramento C e, por fim, escrever os resultados no registrador ou registradores adequados. Além disso, se um sinal de leitura de dados da memória for ativado, a operação de memória é iniciada no final do ciclo de caminho de dados, após o MAR ter sido carregado. Os dados da memória estão disponíveis no final do ciclo seguinte em MBR ou MDR e podem ser usados no ciclo que vem depois daquele. Em outras palavras, uma leitura de memória em qualquer porta iniciada no final do ciclo k entrega dados que não podem ser usados no ciclo k + 1, porém, somente
no ciclo k + 2 ou mais tarde.

Esse comportamento que parece anti-intuitivo é explicado pela Figura 4.3. Os sinais de controle da memória não são gerados no ciclo de clock 1 até que MAR e PC sejam carregados na borda ascendente do clock, próximo ao final do ciclo de clock 1. Consideraremos que a memória coloca seus resultados nos barramentos de memória dentro de um ciclo, portanto, que MBR e/ou MDR podem ser carregados na próxima borda ascendente do clock, junto com os outros registradores.

Em outras palavras, carregamos MAR no final de um ciclo de caminho de dados e iniciamos a memória logo após. Por conseguinte, na realidade não podemos esperar que os resultados de uma operação de leitura estejam em MDR no início do próximo ciclo, em especial se a largura do pulso de clock for curta. Não há tempo suficiente se a memória demora um ciclo de clock. Um ciclo de caminho de dados deve ser interposto entre o início de uma leitura de memória e a utilização do resultado. É claro que outras operações podem ser executadas durante aquele ciclo, mas não as que necessitam da palavra de memória.

Supor que a memória leva um ciclo para operar equivale a supor que a taxa de presença na cache de nível 1 é 100%. Essa suposição nunca é verdadeira, mas a complexidade introduzida por um tempo de ciclo de memória de duração variável é mais do que o que queremos discutir aqui.

Uma vez que MBR e MDR são carregados na borda ascendente do clock, com todos os outros registradores, eles podem ser lidos durante ciclos em que está sendo realizada uma nova leitura de memória. Eles retornam aos valores antigos, já que a leitura ainda não teve tempo de sobrescrevê-los. Aqui não há ambiguidade alguma; até que novos valores sejam carregados em MBR e MDR na borda ascendente do clock, os precedentes ainda estão ali e podem ser usados. Note que é possível fazer leituras seguidas em dois ciclos consecutivos, uma vez que uma leitura leva apenas um. Além disso, ambas as memórias podem funcionar ao mesmo tempo. Contudo, tentar ler e escrever o mesmo byte em simultâneo gera resultados indefinidos.

Embora talvez seja desejável escrever a saída no barramento C em mais de um registrador, nunca é aconselhável habilitar mais de um por vez no barramento B. Na verdade, algumas implementações reais sofrerão dano físico se isso for feito. Com um pequeno aumento no conjunto de circuitos podemos reduzir o número de bits necessários para selecionar entre as possíveis fontes para comandar o barramento B. Há somente nove registradores de entrada possíveis que podem comandar o barramento B (onde cada versão do MBR com sinal e sem sinal é contada como uma versão individual). Portanto, podemos codificar as informações do barramento B em 4 bits e usar um decodificador para gerar os 16 sinais de controle, sete dos quais não são necessários. Em um projeto comercial, os arquitetos seriam atacados por um desejo desesperado de se livrar de um dos registradores de modo que 3 bits fizessem o trabalho. Como acadêmicos, podemos nos dar ao enorme luxo de desperdiçar 1 bit para obter um projeto mais limpo e mais simples.

Nesse ponto, podemos controlar o caminho de dados com 9 + 4 + 8 + 2 + 1 = 24 sinais, daí 24 bits. Contudo, esses 24 bits só controlam o caminho de dados por um ciclo. A segunda parte do controle é determinar o que fazer no ciclo seguinte. Para incluir isso no projeto do controlador, criaremos um formato para descrever as operações a serem realizadas usando os 24 bits de controle mais dois campos adicionais: NEXT_ADDRESS e JAM. O conteúdo de cada um desses campos será discutido em breve. A Figura 4.5 mostra um formato possível, dividido em seis grupos (listados abaixo da instrução) e contendo os seguintes 36 sinais:

   - Addr – Contém o endereço de uma microinstrução potencial seguinte.
   - JAM – Determina como a próxima microinstrução é selecionada.
   - ULA – Funções da ULA e do deslocador.
   - C   – Seleciona quais registradores são escritos a partir do barramento C.
   - Mem – Funções de memória.
   - B   – Seleciona a fonte do barramento B; é codificado como mostrado.

A ordem dos grupos é, em princípio, arbitrária, embora na verdade a tenhamos escolhido com muito cuidado para minimizar cruzamentos de linhas na Figura 4.6. Cruzamentos de linhas em diagramas esquemáticos como essa figura costumam corresponder a cruzamento de fios em chips, o que causa problemas em projetos bidimen-
sionais, portanto, é melhor minimizá-los.

Figura 4.5   Formato da microinstrução para a Mic-1 (descrita em breve adiante).

Formato da Microinstrução Mic-1 (36 Bits)
| <--- Controladora (Addr) ---> | <--- ULA ---> | <--- Barramento C (Escrita) ---> | <--- Mem ---> | <--- Barramento B (Leitura) ---> |
+-------------------------------+---------------+----------------------------------+---------------+----------------------------------+
| NEXT_ADDRESS | JAM | SLL8 | SRA1 | F0 | F1 | ENA | ENB | INV | INC | H | OPC | TOS | CPP | LV | SP | PC | MDR | WR | RD | FETCH |  B_BUS_ADDR  |
+--------------+-----+------+------+----+----+-----+-----+-----+-----+---+-----+-----+-----+----+----+----+-----+----+----+-------+--------------+
|    9 bits    | 3b  |  1b  |  1b  | 1b | 1b | 1b  | 1b  | 1b  | 1b  | 1b| 1b  | 1b  | 1b  | 1b | 1b | 1b | 1b  | 1b | 1b |  1b   |    4 bits    |
+--------------+-----+------+------+----+----+-----+-----+-----+-----+---+-----+-----+-----+----+----+----+-----+----+----+-------+--------------+
      |          |      |      |      |                         |                                       |                |               |
      v          v      v      v      v                         v                                       v                v               v
  Endereço    Desvios Deslocador   Controle                  Seleção de                       Comandos de        Codificação do
  da Próxima  (JMPC,    (Shift)      ULA                    Registradores                      Memória            Barramento B
  Microinst.  JAMN, JAMZ)                                   para Gravação                                        (0-8: MDR a OPC)

Essa estrutura é o cérebro da microarquitetura: cada bit ou grupo de bits (campos) aqui decide o que cada componente do hardware fará em um único ciclo de clock. No seu diretório estruturas_de_dados, entenda que uma única instrução Assembly é, na verdade, composta por várias dessas microinstruções.

Processamento                                                           Armazenamento
ULA (Cálculos)                                                          Registradores
:----------------------------------------------------------------,:-----------------------------------------------------------------------------
F0, F1, ENA, ENB, INV, INC: Comandam a operação da ULA.                 H, OPC, TOS, CPP, LV, SP, PC, MDR: Bits do
                                                                        Barramento C habilitam a gravação neles.
SLL8, SRA1: Comandam o Deslocador (Shift).                              B_BUS_ADDR: 4 bits que escolhem qual registrador será lido.

                                                                        BARRAMENTO INTERNO
UC (Controle)                                                           RI (Instrução Atual)
NEXT_ADDRESS: Aponta para a próxima microinstrução.                     FETCH: Inicia a busca do próximo byte de instrução no MBR.
REM (Endereços) ---> [B. Endereços]                                     Decodificador
MAR: Habilitado para escrita pelo bit correspondente no Barramento C.   JAM: Lógica de desvio (JAMN/JAMZ testam flags N e Z da ULA).
CI (Próxima Inst.)                                                      RDM (Dados) <-> [B. Dados]
PC: Habilitado tanto para leitura (B_BUS) quanto para escrita (Bus C).  RD / WR: Bits que comandam a leitura/escrita na Memória Principal.
CLOCK (Sincronismo)                                                     MEMÓRIA PRINCIPAL (RAM)
CLOCK: Define o momento em que os bits de escrita surtem efeito.        RAM: Ativada pelos sinais RD/WR e o endereço no MAR.

Gabarito de Codificação do Barramento B (4 bits)
Como temos apenas 4 bits para o Barramento B, usamos um decodificador para economizar espaço na microinstrução:

 - 0: MDR | 1: PC | 2: MBR | 3: MBRU

 - 4: SP  | 5: LV | 6: CPP | 7: TOS

 - 8: OPC | 9-15: Nenhum

Insight para seus projetos
Esta microinstrução é o que permite a Recursividade nas Torres de Hanói no nível mais baixo:

 1. Para fazer um PUSH, a UC executa uma microinstrução que coloca o valor do SP no Barramento B, usa a ULA para fazer B-1, e grava o resultado de volta no SP (Barramento C).

 2. Simultaneamente, ela pode ativar o bit WR para que a memória comece a gravar o dado no endereço que o MAR aponta.

 3. Tudo isso acontece em um único ciclo de clock, graças a esses 36 bits trabalhando em paralelo.

Figura 4.6   Diagrama de blocos completo de nossa microarquitetura de exemplo, a Mic-1.
Microarquitetura Mic-1 Completa

Sinais de Controle de Memória (rd, wr, fetch)
             ^            ^             ^
  +----------|------------|-------------|-----------------------+
  |          |   [ MEMÓRIA PRINCIPAL (RAM) ]                    |
  |          +------------+-------------+                       |
  |                       |             |                       |
  |       +-------+  +----+----+  +-----+-----+                 |
  |       |  MAR  |  |   MDR   |  |    MBR    |                 |
  |       +---+---+  +----+----+  +-----+-----+                 |
  |           ^           ^             |                       |
  |           |           |             v                       |
  |   +-------+-----------+-------------+-------+               |
  |   |        BARRAMENTO B (Leitura)           |               |
  |   +-------+-----------+-------------+-------+               |
  |           |           |             |                       |
  |    +------+-----+     |      +------+------+                |
  |    |     H      |     |      | Registradores|                |
  |    +------+-----+     |      | (PC, SP, LV, |                |
  |           |           |      |  CPP, TOS,   |                |
  |           v           v      |  OPC, etc.)  |                |
  |       +---+-----------+---+  +------+------+                |
  |       |   A           B   |         ^                       |
  |       |        ULA        |--[Z,N]--|                       |
  |       +---------+---------+         |                       |
  |                 |                   |                       |
  |                 v                   |                       |
  |       +---------+---------+         |                       |
  |       |    DESLOCADOR     |         |    [UNIDADE DE        |
  |       +---------+---------+         |     CONTROLE]         |
  |                 |                   |                       |
  |   +-------------+-------------------|-------------------+   |
  |   |        BARRAMENTO C (Escrita)   |                   |   |
  |   +---------------------------------|-------------------+   |
  |                                     |                       |
  |        +----------------------------+                       |
  |        |      +-----------+     +-------+                   |
  |        |      |    MPC    |<----| JMPC  |                   |
  |        v      +-----+-----+     +-------+                   |
  |  +-----------+      |               ^                       |
  |  | JAMN/JAMZ |      v               |                       |
  |  +-----------+  +---------+         |                       |
  |                 |  Store  |         |                       |     
  |                 | Control |---[36]--+                       |      
  |                 +----+----+         |                       |
  |                      |              |                       |
  |                      v              |                       |
  |                 +---------+         |                       |
  |                 |   MIR   |---------+ (Sinais de Controle)  |
  +-----------------+---------+---------------------------------+
Organização de Hardware: Mic-1 (Seu Padrão)
Aqui está a consolidação final para o seu estudo em estruturas_de_dados:

Processamento                                                                           Armazenamento
ULA (Cálculos)                                                                          Registradores
ULA e Deslocador (Executam o microprograma)                                             H, PC, SP, LV, CPP, TOS, OPC
JAMN/JAMZ (Lógica de salto condicional)                                                 MPC (Micro Program Counter)

                                                                                        BARRAMENTO INTERNO (B e C)
UC (Controle)                                                                           RI (Instrução Atual)
MIR (Micro Instruction Register - 36 bits)                                              MBR (Porta de entrada para Opcodes)
Decodificador 4 para 16 (Para o Barramento B)                                           Control Store (512 x 36 bits - ROM interna)
REM (Endereços) ---> [B. Endereços]                                                     Decodificador
MAR (Memory Address Register)                                                           Decodificador do Barramento B
CI (Próxima Inst.)                                                                      RDM (Dados) <-> [B. Dados]
MPC (Próxima microinstrução)                                                            MDR (Memory Data Register)
CLOCK (Sincronismo)                                                                     MEMÓRIA PRINCIPAL (RAM)
CLOCK (Coordena o ciclo MIR -> ULA -> Regs)                                             RAM (Onde o programa em Java/C reside)

## Insight para seus projetos
O fluxo desta arquitetura é um loop infinito:

 1. O MIR envia sinais de controle para o Caminho de Dados.

 2. A ULA processa e pode alterar as flags Z (Zero) e N (Negativo).

 3. O JAMN/JAMZ lê essas flags e o campo ADDR do MIR para decidir qual será o próximo endereço no MPC.

 4. O Control Store fornece a nova microinstrução para o MIR, e o ciclo recomeça.

Nas Torres de Hanói, quando você testa se n == 0, a ULA faz a subtração, o Z fica ativo, e o JAMZ força o MPC a saltar para a microinstrução que trata o caso base da recursão.

## 4.1.3 Controle de microinstrução: a Mic-1
Até aqui, descrevemos como o caminho de dados é controlado, mas ainda não explicamos como é decidido qual dos sinais de controle deve ser habilitado em cada ciclo. Isso é determinado por um sequenciador, que é responsável por escalonar a sequência de operações necessárias para a execução de uma única instrução ISA.
O sequenciador deve produzir dois tipos de informação a cada ciclo:

 1. O estado de cada sinal de controle no sistema.
 2. O endereço da microinstrução que deve ser executada em seguida.

A Figura 4.6 é um diagrama de blocos detalhado da microarquitetura completa de nossa máquina de exemplo, que denominaremos Mic-1. Ela pode parecer imponente de início, mas vale a pena estudá-la com cuidado. Quando você entender totalmente cada retângulo e cada linha dessa figura, terá avançado bastante no entendimento do nível de microarquitetura. O diagrama de blocos tem duas partes: o caminho de dados, à esquerda, que já discutimos em detalhes, e a seção de controle, à direita, que estudaremos agora.

O maior item e também o mais importante na parte do controle da máquina é uma memória denominada armazenamento de controle. É conveniente imaginá-la como uma memória que contém o microprograma completo, embora às vezes ele seja executado como um conjunto de portas lógicas. Em geral, vamos nos referir a ele como o armazenamento de controle para evitar confusão com a memória principal, acessada por meio de MBR e MDR. Contudo, em termos funcionais, o armazenamento de controle é uma memória que apenas contém microinstruções em vez de instruções ISA. No caso da nossa máquina de exemplo, ele contém 512 palavras, cada uma consistindo em uma microinstrução de 36 bits do tipo ilustrado na Figura 4.5. Na verdade, nem todas essas palavras são necessárias, mas (por razões que explicaremos em breve) precisamos de endereços para 512 palavras distintas.

Em um aspecto importante, o armazenamento de controle é bem diferente da memória principal: instruções na memória principal são sempre executadas em ordem de endereço (exceto para os desvios); microinstruções não são. O ato de incrementar o contador de programa na Figura 2.3 expressa o fato de que a instrução padrão (default) a executar após a instrução corrente é a instrução seguinte àquela corrente na memória. Microprogramas precisam de mais flexibilidade (porque as sequências de microinstruções tendem a ser curtas), e, portanto, não costumam ter essa propriedade. Em vez disso, cada microinstrução especifica explicitamente sua sucessora.

Uma vez que, em termos funcionais, o armazenamento de controle é uma memória (só de leitura), ele precisa de seu próprio registrador de endereço de memória e de seu próprio registrador de dados de memória. Não precisa ler nem escrever sinais porque está sendo lido continuamente. Denominaremos o registrador de endereço de memória do armazenamento de controle MPC (MicroProgram Counter – contador de microprograma). Esse nome é irônico, já que as localizações nele são explicitamente não ordenadas, portanto, o conceito de contagem não é útil (mas quem somos nós para discutir uma tradição?). O registrador de dados de memória é denominado MIR (MicroInstruction Register – registrador de microinstrução). Sua função é conter a microinstrução corrente, cujos bits comandam os sinais de controle que operam o caminho de dados.

O registrador MIR na Figura 4.6 contém os mesmos seis grupos da Figura 4.5. Os grupos Addr e J (de JAM) controlam a seleção da microinstrução seguinte e serão discutidos em breve. O grupo ULA contém os 8 bits que selecionam a função ULA e comandam o deslocador. Os bits C fazem os registradores individuais carregarem a saída da ULA vinda do barramento C. Os bits M controlam operações de memória.

Por fim, os últimos 4 bits comandam o decodificador que determina o que entra no barramento B. Nesse caso, preferimos usar um decodificador padrão 4 para 16, mesmo que sejam requeridas apenas nove possibilidades. Em um projeto mais afinado, poderia ser usado um decodificador 4 para 9. Nesse caso, o compromisso é usar um circuito padrão que possa ser encontrado em uma biblioteca de circuitos em vez de projetar um circuito fabricado sob especificação. Usar o circuito padrão é mais simples e a probabilidade de introduzir bugs é menor. Construir seu próprio circuito usa menos área de chip, mas leva mais tempo para projetar e há sempre a possibilidade de você errar.

A operação da Figura 4.6 é a seguinte. No início de cada ciclo de clock (a borda descendente na Figura 4.3), MIR é carregado a partir da palavra no armazenamento de controle apontada pelo MPC. O tempo de carga do MIR é indicado na figura por ∆w. Se pensarmos em termos de subciclos, MIR é carregado durante o primeiro.

Assim que a microinstrução é estabelecida em MIR, os vários sinais se propagam para dentro do caminho de dados. Um registrador é copiado para o barramento B, a ULA sabe qual operação realizar e a atividade é frenética. Esse é o segundo subciclo. Após um intervalo ∆w + ∆x a partir do início do ciclo, as entradas da ULA estão estáveis.

Após mais um ∆y, tudo se acomoda e as saídas da ULA, N, Z e do deslocador estão estáveis. Então, os valores N e Z são salvos em um par de flip-flops de 1 bit. Esses bits, como os registradores que são carregados a partir do barramento C e na memória, são salvos na borda ascendente do clock, próximo ao final do ciclo do caminho de dados. A saída da ULA não é serializada, mas apenas alimentada no deslocador. A atividade da ULA e do deslocador ocorre durante o subciclo 3.

Após um intervalo adicional, ∆z, a saída do deslocador alcançou os registradores via barramento C. Então, estes podem ser carregados perto do final do ciclo (borda ascendente do pulso de clock na Figura 4.3). O subciclo 4 consiste em carregar os registradores e flip-flops N e Z e termina um pouco após a borda ascendente do clock, quando todos os resultados foram salvos e os produtos das operações de memória anteriores estão disponíveis e o MPC foi carregado. O processo continua até alguém se entediar e desligar a máquina.

Em paralelo com o comando do caminho de dados, o microprograma tem de determinar qual microinstrução executar em seguida, porque elas precisam ser executadas na ordem em que aparecem no armazenamento de controle. O cálculo do endereço da próxima microinstrução começa após MIR ter sido carregado e estar estável. Primeiro, o campo NEXT_ADDRESS de 9 bits é copiado para MPC. Enquanto essa cópia está ocorrendo, o campo JAM é inspecionado. Se tiver valor 000, nada mais é feito; quando a cópia de NEXT_ADDRESS estiver concluída, o MPC apontará a próxima microinstrução.

Se um ou mais dos bits JAM for 1, é preciso mais trabalho. Se JAMN estiver ativado, o flip-flop N de 1 bit sofre uma operação OR com o bit de ordem alta do MPC. De modo semelhante, se JAMZ estiver ativado, é o flip-flop Z de 1 bit que passa pela operação OR. Se ambos estiverem ajustados, ambos passam por OR. A razão de os flip-flops N e Z serem necessários é que, após a borda ascendente do clock (enquanto o clock está alto), o barramento B não está mais sendo comandado, portanto, as saídas da ULA não podem mais ser tomadas como corretas. Salvar os flags de estado da ULA em N e Z torna os valores corretos disponíveis e estáveis para o cálculo do MPC, não importa o que esteja ocorrendo na ULA.

  Na Figura 4.6, a lógica que faz tal cálculo é denominada “bit alto”. A função booleana que ela calcula é F = (JAMZ AND Z) OR (JAMN AND N) OR NEXT_ADDRESS[8]
  Note que, em todos os casos, MPC só pode assumir um de dois valores possíveis:

  1.O valor de NEXT_ADDRESS.
  2.O valor de NEXT_ADDRESS com o bit de ordem alta que passa por uma operação OR com 1.

Não existe nenhuma outra possibilidade. Se o bit de ordem alta de NEXT_ADDRESS já for 1, usar JAMN ou JAMZ não tem sentido.

Note que, quando os bits JAM são todos zeros, o endereço da próxima microinstrução a ser executada é simplesmente o número de 9 bits em seu campo NEXT_ADDRESS. Quando ou JAMN ou JAMZ é 1, há dois sucessores potenciais: NEXT_ADDRESS e NEXT_ADDRESS com operação OR com 0x100 (considerando que NEXT_ADDRESS ≤ 0xFF). (Note que 0x indica que o número que vem em seguida está em hexadecimal.) Esse ponto é ilustrado na Figura 4.7. A microinstrução corrente, na localização 0x75, tem NEXT_ADDRESS = 0x92 e JAMZ ajustado para 1. Por conseguinte, o próximo endereço da microinstrução depende do bit Z armazenado durante a operação de ULA anterior. Se o bit Z for 0, a próxima microinstrução vem de 0x92. Se o bit Z for 1, a próxima microinstrução vem de 0x192.

O terceiro bit no campo JAM é JMPC. Se ele estiver ativado, os 8 bits MBR passam por uma operação OR bit a bit com os 8 bits de ordem baixa do campo NEXT_ADDRESS que vem da microinstrução corrente. O resultado é enviado a MPC. O retângulo com o rótulo “O” na Figura 4.6 faz uma OR de MBR com NEXT_ADDRESS se JMPC for 1, mas apenas passa NEXT_ADDRESS diretamente para MPC se JMPC for 0. Quando JMPC é 1, os 8 bits de ordem baixa de NEXT_ADDRESS em geral são zero. O bit de ordem alta pode ser 0 ou 1, portanto, o valor de NEXT_ADDRESS usado com JMPC normalmente é 0x000 ou 0x100. A razão para usar às vezes 0x000 e às vezes 0x100 será discutida mais adiante.

A capacidade de efetuar OR entre MBR e NEXT_ADDRESS e armazenar o resultado em MPC permite uma execução eficiente de um desvio (jump) multivias. Note que qualquer um dos 256 endereços pode ser especificado, determinado exclusivamente pelos bits presentes em MBR. Em uma utilização típica, MBR contém um código de operação, que chamaremos de opcode, portanto, a utilização de JMPC resultará em uma seleção única para a próxima microinstrução a ser executada para todo opcode possível. Esse método é útil para fazer desvios rápidos diretamente para a função correspondente ao opcode que acabou de ser buscado.

Entender a temporização da máquina é crítico para o que vem a seguir, portanto, talvez valha a pena repeti-la. Faremos isso em termos de subciclos, uma vez que é fácil de visualizar, mas os únicos eventos de clock reais são a borda descendente, que inicia o ciclo, e a borda ascendente, que carrega os registradores e os flip-flops N e Z. Favor consultar a Figura 4.3 mais uma vez.

Figura 4.7   Microinstrução com JAMZ ajustado para 1 tem duas sucessoras potenciais.
Lógica de Próximo Endereço com JAMZ 
MICROINSTRUÇÃO ATUAL (No endereço 0x75)
      +-----------------+-------+-----------------------+
      |  NEXT_ADDRESS   |  JAMZ |   BITS DE CONTROLE    |
      |      0x92       |   1   |  DO CAMINHO DE DADOS  |
      +-----------------+-------+-----------------------+
                |           |
                v           |          FLAG Z (DA ULA)
          [ LOGICA MPC ] <---(+)--- [ 0 ou 1 ]
                |
                |          Se Z = 0: Próximo é 0x092 (0x092 OR 0x000)
                +--------> Se Z = 1: Próximo é 0x192 (0x092 OR 0x100)
                |
                v
      +---------------------------+
      |    OPÇÕES DE SUCESSORA    |
      +---------------------------+
      | 0x092 (Caminho se Z=0)    |  <-- "Falso" (n != 0)
      +---------------------------+
      | 0x192 (Caminho se Z=1)    |  <-- "Verdadeiro" (n == 0)
      +---------------------------+

A Figura 4.7 ilustra como o hardware toma decisões de "desvio" (branching) no nível de microcódigo. Quando o bit JAMZ está em 1, a microarquitetura usa a flag Z (Zero) da ULA para decidir o próximo endereço do MPC.

Durante o subciclo 1, iniciado pela borda descendente do clock, MIR é carregado a partir do endereço contido em MPC no instante em questão. Durante o subciclo 2, os sinais de MIR se propagam e o barramento B é carregado a partir do registrador selecionado. Durante o subciclo 3, a ULA e o deslocador funcionam e produzem um resultado estável. Durante o subciclo 4, os valores do barramento C, dos barramentos de memória e da ULA tornam-se estáveis. Na borda ascendente do clock, os registradores são carregados a partir do barramento C, flip-flops N e Z são carregados e MBR e MDR obtêm seus resultados da operação de memória iniciada no final do ciclo de caminho de dados anterior (se houver algum). Assim que o valor de MBR estiver disponível, MPC é carregado em preparação para a próxima microinstrução. Assim, MPC obtém seu valor em algum instante durante o meio do intervalo quando o clock está alto, mas após MBR/MDR estarem prontos. Ele poderia ser ativado no nível (em vez de ativado pela borda) ou ativado pela borda com um atraso fixo após a borda ascendente do clock. O que realmente importa é que MPC não seja carregado até que os registradores dos quais ele depende (MBR, N e Z) estejam prontos. Tão logo o clock caia, MPC pode endereçar o armazenamento de controle e um novo ciclo pode começar.

Note que cada ciclo é autossuficiente. Ele especifica o que ocorre no barramento B, o que a ULA e o deslocador têm de fazer, onde o barramento C deve ser armazenado e, por fim, qual deve ser o próximo valor de MPC.

Vale a pena fazer uma observação final sobre a Figura 4.6. Estamos tratando o MPC como um registrador propriamente dito, com 9 bits de capacidade de armazenamento, que é carregado enquanto o clock está alto. Na realidade, não há necessidade alguma de um registrador ali. Todas as suas entradas podem ser alimentadas diretamente para o armazenamento de controle. Basta que elas estejam presentes no armazenamento de controle na borda descendente do clock quando MIR é selecionado e lido. Na verdade, não há necessidade alguma de armazená-las em MPC. Por essa razão, o MPC pode perfeitamente ser executado como um registrador virtual, que é apenas um lugar de reunião para sinais, mais como se fosse um painel de conexão eletrônico do que um registrador real. Transformar o MPC em um registrador virtual simplifica a temporização: agora, os eventos acontecem somente nas bordas descendentes e ascendentes do clock e em nenhum outro lugar. Porém, se for mais fácil para você imaginar um MPC como um registrador real, esse ponto de vista também é válido.

Organização de Hardware: Decisão de Fluxo (Seu Padrão)
Veja como os componentes que você mapeou trabalham juntos para realizar esse "salto" de microcódigo:

Processamento                                                                    Armazenamento
ULA (Cálculos)                                                                   Registradores
ULA (Gera a flag Z após uma operação)                                            MIR (Contém o Addr 0x92 e o JAMZ = 1)
JAMN/JAMZ (Faz a operação OR entre Z e o bit 8 do Addr)                          MPC (Recebe o resultado final: 0x92 ou 0x192)

                                                                                 BARRAMENTO INTERNO
UC (Controle)                                                                    RI (Instrução Atual)
UC (Usa o Addr para buscar a próxima microinstrução)                             Control Store (Contém as duas opções de destino)
REM (Endereços) ---> [B. Endereços]                                              Decodificador
MAR (Não é afetado por saltos de microcódigo)                                    Decodificador (Não ativado nesta lógica de fluxo)
CI (Próxima Inst.)                                                               RDM (Dados) <-> [B. Dados]
MPC (Atua como o ""CI"" do microprograma)                                        MDR (Não participa da decisão de desvio)
CLOCK (Sincronismo)                                                              MEMÓRIA PRINCIPAL (RAM)
CLOCK (Define quando o MPC será atualizado)                                      RAM (Alheia ao que ocorre no microcódigo interno)

## Insight para seus projetos
A "mágica" aqui é puramente binária e extremamente rápida:

 1. O endereço base é 0x92 (em binário: 0 1001 0010).

 2. Se o bit JAMZ for 1 e a flag Z for 1, o hardware faz um OR lógico entre o bit Z e o bit de alta ordem (bit 8) do endereço.

 3. Isso transforma o endereço 0x92 em 0x192 instantaneamente, sem precisar de uma unidade de cálculo complexa.

Nas Torres de Hanói, isso é o que permite que a CPU saiba instantaneamente se deve continuar movendo discos ou se deve encerrar a recursão (caso base).

## 4.2 Exemplo de ISA: IJVM
Vamos continuar nosso exemplo introduzindo o nível ISA da máquina a ser interpretado pelo microprograma que é executado na microarquitetura da Figura 4.6 (IJVM). Por conveniência, às vezes vamos nos referir a Instruction Set Architecture (ISA) como a macroarquitetura, para contrastá-la com a microarquitetura. Contudo, antes de descrever a IJVM, vamos fazer uma ligeira digressão com o intuito de motivação.

## 4.2.1 Pilhas
Praticamente todas as linguagens de programação trabalham com o conceito de procedimentos (métodos),
que têm variáveis locais. Essas variáveis podem ser acessadas de dentro dos procedimentos, mas deixam de ser acessíveis assim que o procedimento é devolvido. Portanto, surge a pergunta: “Em que lugar da memória essas variáveis devem ser mantidas?”.

A solução mais simples, dar a cada variável um endereço de memória absoluto, não funciona. O problema é que um procedimento pode chamar a si mesmo. Estudaremos esses procedimentos recursivos no Capítulo 5. Por enquanto, basta dizer que, se um procedimento for ativado – isto é, chamado – duas vezes, é impossível armazenar suas variáveis em localizações absolutas de memória porque a segunda chamada irá interferir com a primeira.

Em vez disso, é usada uma estratégia diferente. Uma área da memória, denominada pilha, é reservada para variáveis, mas variáveis individuais não obtêm endereços absolutos nela. Em vez disso, um registrador, por exemplo, LV, é preparado para apontar para a base das variáveis locais para o procedimento em questão. Na Figura 4.8(a), um procedimento A, que tem variáveis locais a1, a2 e a3, foi chamado, portanto, foi reservado armazenamento para suas variáveis locais, começando na localização de memória apontada por LV. Outro registrador, SP, aponta para a palavra mais alta das variáveis locais de A. Se LV for 100 e as palavras tiverem 4 bytes, então SP será 108. Variáveis são referenciadas dando seu deslocamento (distância) em relação a LV. A estrutura de dados entre LV e SP (e incluindo ambas as palavras apontadas) é denominada quadro de variáveis locais de A.

Figura 4.8   Utilização de uma pilha para armazenar variáveis locais. (a) Enquanto A está ativo. (b) Após A chamar B. (c) Após B chamar
C. (d) Após C e B retornarem e A chamar D.

Evolução da Pilha de Variáveis Locais 
Observe como os registradores SP (topo) e LV (base do quadro atual) se deslocam:
(a) A ativo        (b) A chama B      (c) B chama C      (d) C/B voltam,
                                                                  A chama D
    +---------+        +---------+        +---------+        +---------+
    |         |    SP->|   b4    |        |   c2    |    SP->|   d5    |
    |         |        |   b3    |    SP->|   c1    |        |   d4    |
SP->|   a3    |        |   b2    |        |   b4    |        |   d3    |
    |   a2    |    LV->|   b1    |        |   b3    |        |   d2    |
LV->|   a1    |        |   a3    |        |   b2    |    LV->|   d1    |
    +---------+        |   a2    |    LV->|   b1    |        |   a3    |
      (100)            |   a1    |        |   a3... |        |   a2    |
                       +---------+        +---------+        +---------+

Processamento                                                                   Armazenamento
ULA (Cálculos)                                                                  Registradores
:-------------------------------------------------------------------------------:----------------------------------------
ULA (Calcula SP + offset para novas variáveis)                                  SP (Stack Pointer): Aponta para o topo da pilha.
                                                                                LV (Local Variables): Aponta para a base do frame atual.

                                                                                BARRAMENTO INTERNO
UC (Controle)                                                                   RI (Instrução Atual)
UC (Coordena as microinstruções de chamada/retorno)                             TOS (Top of Stack): Cópia do topo para agilizar a ULA.
REM (Endereços) ---> [B. Endereços]                                             Decodificador
MAR (Recebe valor de SP/LV para acessar a RAM)                                  Decodificador (Seleciona a célula de memória correta)
CI (Próxima Inst.)                                                              RDM (Dados) <-> [B. Dados]
PC (Salta para o endereço da função B, C ou D)                                  MDR (Escreve as variáveis locais a1, b1, c1 na RAM)
CLOCK (Sincronismo)                                                             MEMÓRIA PRINCIPAL (RAM)
CLOCK (Sincroniza a limpeza do frame no retorno)                                RAM (Onde a pilha física reside e evolui)

Agora, vamos considerar o que acontece se A chamar outro procedimento, B. Onde deveriam ser armazenadas as quatro variáveis locais de B (b1, b2, b3, b4)? Resposta: na pilha, em cima das variáveis de A, conforme mostra a Figura 4.8(b). Observe que LV foi ajustado pela chamada de procedimento para que aponte para as variáveis locais de B em vez das de A. As variáveis locais de B podem ser referenciadas dando seu deslocamento em relação a LV. De modo semelhante, se B chamar C, LV e SP são ajustados novamente para alocar espaço para as duas variáveis de C, como mostra a Figura 4.8(c).

Quando C retorna, B torna-se ativo de novo e a pilha volta a ser ajustada para a Figura 4.8(b), de modo que LV agora aponta outra vez para as variáveis locais de B. Da mesma forma, quando B retorna, voltamos à situação da Figura 4.8(a). Sob todas as condições, LV aponta para a base do quadro da pilha para o procedimento ativo no momento em questão e SP aponta para o topo do quadro da pilha.

Agora, suponha que A chama D, que tem cinco variáveis locais. Essa é a situação da Figura 4.8(d), na qual as variáveis locais de D usam a mesma memória que as de B usaram, bem como parte das de C. Com essa organização, a memória só é alocada para procedimentos que estão ativos no momento em questão. Quando um procedimento retorna, a memória usada por suas variáveis locais é liberada.

Pilhas têm outra utilização além de conter variáveis locais. Elas podem ser usadas para reter operandos durante o cálculo de uma expressão aritmética. Quando usada dessa maneira, a pilha é denominada pilha de operandos. Suponha, por exemplo, que, antes de chamar B, A tenha de calcular a1 = a2 + a3;

## Insight para seus projetos
Nas Torres de Hanói, cada vez que você faz uma chamada recursiva:

 1. Isolamento (b e c): O registrador LV garante que a função B não sobrescreva acidentalmente as variáveis de A (a1, a2, a3). Elas continuam lá, "protegidas" abaixo do novo quadro.

 2. Limpeza (d): Quando B e C terminam, o SP e o LV simplesmente "voltam" para as posições originais de A. Os dados de B e C não precisam ser apagados bit a bit; eles são apenas ignorados pelo hardware no próximo ciclo.

 3. Diferença entre (a) e (d): Note que, embora D tenha sido chamada após A, ela ocupa o espaço que antes era de B, otimizando o uso da Memória Principal.

Um modo de efetuar essa soma é passar a2 para a pilha, como ilustra a Figura 4.9(a). Nesse caso, SP foi incrementado pelo número de bytes em uma palavra, por exemplo, 4, e o primeiro operando foi armazenado no endereço agora apontado por SP. Em seguida, a3 é passada para a pilha, conforme mostra a Figura 4.9(b). (Como parte da notação, usaremos uma fonte Helvetica para todos os fragmentos de programa, como fizemos anteriormente. Também usaremos essa fonte para opcodes em linguagem de montagem e registradores de máquina, mas, em texto corrente, variáveis de programa e procedimentos serão dados em itálico. A diferença é que nomes de variáveis de programas e nomes de procedimento são escolhidos pelo usuário; nomes de opcodes e registradores vêm com a máquina.)

Figura 4.9   Utilização de uma pilha de operandos para efetuar um cálculo aritmético.
Pilha de Operandos em Ação
(a) Estado        (b) Push de a3      (c) Operação      (d) Pop/Store
         Inicial                                ADD              em a3
                                                              
    +-----------+      +-----------+      +-----------+      +-----------+
SP->|/// a2 /// |  SP->| ///a3 /// |      | ////////  |      |           |
    +-----------+      +-----------+  SP->|  a2 + a3  |      |           |
    |    a3     |      | ///a2///  |      +-----------+      |           |
    |    a2     |      |    a3     |      |    a3     |  SP->|    a3     |
LV->|    a1     |  LV->|    a2     |  LV->|    a2     |      |  a2 + a3  |
    +-----------+      |    a1     |      |    a1     |  LV->|    a2     |
                       +-----------+      +-----------+      |    a1     |
                                                             +-----------+

Essa figura ilustra o funcionamento interno da Pilha de Operandos, que é onde a "mágica" aritmética acontece na JVM e na Mic-1. Diferente das variáveis locais (que ficam paradas em seus endereços), os operandos são "empilhados" para que a ULA possa processá-los.

No seu diretório estruturas_de_dados, este é o comportamento clássico de uma Pilha (Stack) para avaliação de expressões em pós-fixo (Reverse Polish Notation).

Agora, o cálculo propriamente dito pode ser feito executando uma instrução que retira duas palavras da pilha, soma as duas e devolve o resultado para a pilha, conforme a Figura 4.9(c). Por fim, a palavra que está no topo pode ser retirada da pilha e armazenada de novo na variável local a1, como ilustrado na Figura 4.9(d). Os quadros de variáveis locais e as pilhas de operandos podem ser misturados. Por exemplo, ao calcular uma expressão como x2 + f(x), parte dela (por exemplo, x2) pode estar em uma pilha de operandos quando a função f é chamada. O resultado da função é deixado na pilha, em cima de x2, de modo que a próxima instrução pode somá-la. Vale a pena observar que, enquanto todas as máquinas usam uma pilha para armazenar variáveis locais, nem todas usam uma pilha de operandos como essa para efetuar aritmética. Na verdade, a maioria delas não usa, mas a JVM e a IJVM trabalham assim, e é por isso que apresentamos aqui as operações com a pilha. Vamos estudá-las com mais detalhes no Capítulo 5.

Organização de Hardware: Ciclo do Operando (Seu Padrão)
Veja como os componentes que você mapeou trabalham em cada etapa (a, b, c, d):

Processamento                                                       Armazenamento
ULA (Cálculos)                                                      Registradores
:-------------------------------------------------------------------:--------------------------------------------------------
ULA: Realiza a soma a2 + a3 no passo (c).                           SP: Sobe no (b) e desce no (c) e (d).
Deslocador: Pode ser usado se a soma precisar de shift.             TOS: Mantém o valor do topo (ex: a3) para a ULA.

                                                                    BARRAMENTO INTERNO
UC (Controle)                                                       RI (Instrução Atual)
UC: Decodifica o IADD e gera os sinais de controle.                 H: Segura o primeiro operando (a2) para a ULA.
REM (Endereços) ---> [B. Endereços]                                 Decodificador
MAR: Aponta para o endereço de SP na RAM.                           Decodificador: Traduz o comando de ""Somar"".
CI (Próxima Inst.)                                                  RDM (Dados) <-> [B. Dados]
PC: Aponta para a próxima instrução após a soma.                    MDR: Recebe o resultado a2 + a3 para gravar na RAM.
CLOCK (Sincronismo)                                                 MEMÓRIA PRINCIPAL (RAM)
CLOCK: Sincroniza cada PUSH e POP da pilha.                         RAM: Onde os valores a1, a2, a3 residem fisicamente.

## Insight para seus projetos
Esta sequência explica por que as CPUs de pilha são tão simples, mas exigem muitos acessos à memória:

 1. Passo (b): Para somar, você primeiro precisa "duplicar" ou mover os dados para o topo.

 2. Passo (c): A ULA retira dois valores, soma-os e coloca um de volta. O SP (Stack Pointer) é ajustado automaticamente.

 3. Passo (d): O resultado que estava no topo da pilha é finalmente movido para o endereço da variável local (neste caso, a3 foi sobrescrito pelo resultado).

Nas Torres de Hanói, esse processo é usado para calcular o parâmetro n - 1. O valor n é colocado na pilha, o valor 1 é colocado em cima, a ULA subtrai, e o resultado é passado para a nova chamada da função.

## 4.2.2 Modelo de memória IJVM(Instruções Java Virtual Machine)
Agora, estamos prontos para estudar a arquitetura da IJVM. Em essência, ela consiste em uma memória que pode ser vista de dois modos: um arranjo de 4.294.967.296 bytes (4 GB) ou um arranjo de 1.073.741.824 palavras, cada uma consistindo em 4 bytes. Diferente da maioria das ISAs, a Java Virtual Machine (máquina virtual Java) não deixa nenhum endereço absoluto de memória diretamente visível no nível ISA, mas há vários endereços implícitos que fornecem a base para um ponteiro. Instruções IJVM só podem acessar a memória indexando a partir desses ponteiros. Em qualquer instante, as seguintes áreas de memória são definidas:

  1. O conjunto de constantes. Essa área não pode ser escrita por um programa IJVM e consiste em constantes, cadeias e ponteiros para outras áreas da memória que podem ser referenciadas. Ele é carregado quando o programa é trazido para a memória e não é alterado depois. Há um registrador implícito, CPP, que contém o endereço da primeira palavra do conjunto de constantes.

  2. O quadro de variáveis locais. Para cada invocação de um método é alocada uma área para armazenar variáveis durante o tempo de vida da invocação, denominada quadro de variáveis locais. No início desse quadro estão os parâmetros (também denominados argumentos) com os quais o método foi invocado. O quadro de variáveis locais não inclui a pilha de operandos, que é separada. Contudo, por questões de eficiência, nossa implementação prefere executar a pilha de operandos logo acima do quadro de variáveis locais. Há um registrador implícito que contém o endereço da primeira localização do quadro de variáveis locais. Nós o denominaremos LV. Os parâmetros passados na chamada do método são armazenados no início do quadro de variáveis locais.

   3. A pilha de operandos. É garantido que o quadro não exceda certo tamanho, calculado com antecedência pelo compilador Java. O espaço da pilha de operandos é alocado diretamente acima do quadro de variáveis locais, como ilustrado na Figura 4.10. Em nossa implementação, é conveniente imaginar a pilha de operandos como parte do quadro de variáveis locais. De qualquer modo, há um registrador implícito que contém o endereço da palavra do topo da pilha. Note que, diferente do CPP e do LV, esse ponteiro, SP, muda durante a execução do método à medida que operandos são passados para a pilha ou retirados dela.

  4.A área de método. Por fim, há uma região da memória que contém o programa, à qual nos referimos como a área de “texto” em um processo UNIX. Há um registrador implícito que contém o endereço da instrução a ser buscada em seguida. Esse ponteiro é denominado contador de programa (Program Counter) ou PC. Diferente das outras regiões da memória, a área de método é tratada como um vetor de bytes.

Figura 4.10   As várias partes da memória IJVM.
DIREÇÃO DOS ENDEREÇOS CRESCENTES
                     |
                     v
      +-----------------------------+
      |      ÁREA DE MÉTODO         | <--- PC (Program Counter)
      | (Código/Bytecodes do Prog)  |      Aponta para a instrução atual.
      +-----------------------------+
      |   CONJUNTO DE CONSTANTES    | <--- CPP (Constant Pool Pointer)
      |  (Strings, números fixos)   |      Ponteiro para constantes.
      +-----------------------------+
      |   QUADRO 1 (Var. Locais)    |
      +-----------------------------+
      |   QUADRO 2 (Var. Locais)    |
      +-----------------------------+
      |   QUADRO 3 (Var. Locais)    | <--- LV (Local Variables)
      |  (Variáveis do Método Atual)|      Base do quadro corrente.
      +-----------------------------+
      |   PILHA DE OPERANDOS 3      | <--- SP (Stack Pointer)
      | (Cálculos do Método Atual)  |      Topo da pilha de dados.
      +-----------------------------+
                     |
                     v
É preciso esclarecer uma questão em relação aos ponteiros. Os registradores CPP, LV e SP são todos ponteiros para palavras, não para bytes, e são deslocados pelo número de palavras. Para o subconjunto de inteiros que escolhemos, todas as referências a itens no conjunto de constantes, o quadro de variáveis locais e as pilhas são palavras, e todos os deslocamentos usados para indexar esses quadros são deslocamentos de palavras. Por exemplo, LV, LV + 1 e LV + 2 se referem às primeiras três palavras do quadro de variáveis locais. Em comparação, LV, LV + 4 e LV + 8 se referem a palavras em intervalos de quatro palavras (16 bytes).

Ao contrário, PC contém um endereço de byte, e uma adição ou subtração ao PC altera o endereço por um número de bytes, e não por um número de palavras. O endereçamento para PC é diferente dos outros e esse fato é aparente na porta de memória especial fornecida para PC na Mic-1. Lembre-se de que a largura dessa porta é de apenas 1 byte. Incrementar o PC por um fator de um e iniciar uma leitura resulta em uma busca pelo próximo byte. Incrementar o SP por um fator de um e iniciar uma leitura resulta em uma busca pela próxima palavra.

Organização de Hardware: Gerenciamento de Memória (Seu Padrão)
Abaixo, veja como os componentes que você mapeou interagem com cada uma dessas áreas da memória:

Processamento                                                           Armazenamento
ULA (Cálculos)                                                          Registradores
:----------------------------------------------------------------------:--------------------------------------------------------
ULA (Calcula endereços baseados em LV ou SP)                            PC, CPP, LV, SP: Guardam os ponteiros para as áreas acima.
                                                                        TOS: Mantém o topo da ""Pilha 3"" para cálculos rápidos

                                                                        BARRAMENTO INTERNO
UC (Controle)                                                           RI (Instrução Atual)
UC (Busca bytecodes na Área de Método)                                  MBR: Recebe os bytes de instrução vindos da Área de Método.
REM (Endereços) ---> [B. Endereços]                                     Decodificador
MAR: Aponta para o endereço físico na RAM                               Decodificador (Traduz ILOAD para buscar no quadro de LV)
CI (Próxima Inst.)                                                      RDM (Dados) <-> [B. Dados]
PC: Incrementado após ler cada bytecode                                 MDR: Transporta dados entre a RAM e os registradores.
CLOCK (Sincronismo)                                                     MEMÓRIA PRINCIPAL (RAM)
CLOCK (Sincroniza o ciclo de leitura de memória)                        RAM: Onde todas as áreas do diagrama residem.

## Insight para seus projetos
Esta divisão de memória é o que permite que as Torres de Hanói funcionem sem colisão de dados:

 1. Área de Método: Contém a "receita" do algoritmo (o código compilado). O PC percorre essa área.

 2. CPP: Se você tiver um limite máximo de discos definido como uma constante, ele estará aqui.

 3. Quadros (LV): Cada chamada recursiva cria um novo quadro (1, 2, 3...). O registrador LV sempre "pula" para o quadro mais recente.

 4. Pilha de Operandos: É o rascunho. Quando você faz n - 1, esse cálculo ocorre temporariamente na pilha de operandos antes de ser passado para o próximo quadro.

## 4.2.3 Conjunto de instruções da IJVM
O conjunto de instruções da IJVM é mostrado na Figura 4.11. Cada instrução consiste em um opcode e às vezes um operando, tal como um deslocamento de memória ou uma constante. A primeira coluna dá a codificação hexadecimal da instrução. A segunda dá seu mnemônico em linguagem de montagem. A terceira dá uma breve descrição de seu efeito.

Figura 4.11   Conjunto de instruções da IJVM. Os operandos byte, const e varnum são de 1 byte. Os operandos disp, index e offset são
de 2 bytes.

Figura 4.11   Conjunto de instruções da IJVM. Os operandos byte, const e varnum são de 1 byte. Os operandos disp, index e offset são
de 2 bytes.
+------+-----------------------+-------------------------------------------------------+
| HEXA | MNEMÔNICO             | SIGNIFICADO                                           |
+------+-----------------------+-------------------------------------------------------+
| 0x10 | BIPUSH byte           | Carregue o byte para a pilha                          |
| 0x59 | DUP                   | Copie a palavra do topo e empilhe-a novamente         |
| 0xA7 | GOTO offset           | Desvio incondicional                                  |
| 0x60 | IADD                  | Retire duas palavras da pilha; empilhe a soma         |
| 0x7E | IAND                  | Retire duas palavras da pilha; empilhe AND booleano   |
| 0x99 | IFEQ offset           | Retire da pilha e desvie se for zero                  |
| 0x9B | IFLT offset           | Retire da pilha e desvie se for menor que zero        |
| 0x9F | IF_ICMPEQ offset      | Retire duas da pilha; desvie se forem iguais          |
| 0x84 | IINC varnum const     | Some uma constante a uma variável local               |
| 0x15 | ILOAD varnum          | Carregue variável local para a pilha                  |
| 0xB6 | INVOKEVIRTUAL disp    | Invoque um método (Call)                              |
| 0x80 | IOR                   | Retire duas palavras da pilha; empilhe OR booleano    |
| 0xAC | IRETURN               | Retorne do método com valor inteiro                   |
| 0x36 | ISTORE varnum         | Retire da pilha e armazene na variável local          |
| 0x64 | ISUB                  | Retire duas palavras da pilha; empilhe a diferença    |
| 0x13 | LDC_W index           | Carregue constante do pool para a pilha               |
| 0x00 | NOP                   | Não faça nada (No Operation)                          |
| 0x57 | POP                   | Apague a palavra no topo da pilha                     |
| 0x5F | SWAP                  | Troque as duas palavras do topo entre si              |
| 0xC4 | WIDE                  | Prefixo para índices de 16 bits na inst. seguinte     |
+------+-----------------------+-------------------------------------------------------+

Organização de Hardware: Execução IJVM (Seu Padrão)
Veja como os componentes que você mapeou reagem a essas instruções específicas:

Processamento                                                                    Armazenamento
ULA (Cálculos)                                                                   Registradores
:-------------------------------------------------------------------------------:-----------------------------------------
ULA (Executa IADD, ISUB, IAND, IOR)                                              SP: Atualizado por quase todas (BIPUSH, IADD, POP)
JAMN/JAMZ: (Essencial para IFEQ e IFLT)                                          LV: Usado como base para ILOAD e ISTORE.

                                                                                 BARRAMENTO INTERNO
UC (Controle)                                                                    RI (Instrução Atual)
UC (Decodifica o Hexa e seleciona o microprograma)                               MBR: Recebe os bytes (byte, varnum, const) após o Opcode.
REM (Endereços) ---> [B. Endereços]                                              Decodificador
MAR: Aponta para o endereço de varnum (LV + offset)                              Decodificador (Mapeia o Hexa 0x60 para o início do microcódigo IADD)
CI (Próxima Inst.)                                                               RDM (Dados) <-> [B. Dados]
PC: Aponta para o próximo Opcode na área de método                               MDR: Transporta as palavras de 32 bits da RAM para a pilha.
CLOCK (Sincronismo)                                                              MEMÓRIA PRINCIPAL (RAM)
CLOCK (Sincroniza o acesso ao Pool de Constantes - LDC_W)                        RAM: Onde o Control Store busca o microprograma.

## Insight para seus projetos
Para as Torres de Hanói, estas instruções formam o fluxo lógico:

 1. ILOAD: Busca o número de discos n do seu quadro de variáveis locais.

 2. BIPUSH 1 + ISUB: Faz o cálculo n - 1 na pilha de operandos.

 3. IFEQ: Verifica se n chegou a zero (caso base).

 4. INVOKEVIRTUAL: Faz a mágica da recursão, criando um novo quadro na pilha para a próxima sub-tarefa.

São fornecidas instruções para passar para a pilha uma palavra que pode vir de diversas fontes. Entre essas fontes estão o conjunto de constantes (LDC_W), o quadro de variáveis locais (ILOAD) e a própria instrução (BIPUSH). Uma variável também pode ser retirada da pilha e armazenada no quadro de variáveis locais (ISTORE). Duas operações aritméticas (IADD e ISUB), bem como duas operações lógicas booleanas (IAND e IOR), podem ser efetuadas usando as duas palavras de cima da pilha como operandos. Em todas as operações aritméticas e lógicas, duas palavras são retiradas da pilha e o resultado é devolvido a ela. São fornecidas quatro instruções de desvio, uma incondicional (GOTO) e três condicionais (IFEQ, IFLT e IF_ICMPEQ). Todas as instruções de ramificação, se tomadas, ajustam o valor de PC conforme o tamanho de seus deslocamentos (16 bits com sinal), que vem após o opcode na instrução. Esse deslocamento é adicionado ao endereço do opcode. Há também instruções IJVM para trocar as duas palavras do topo da pilha uma pela outra (SWAP), duplicando a palavra do topo (DUP) e retirando-a (POP).

Algumas instruções têm vários formatos, o que permite uma forma abreviada para versões comumente usadas. Na IJVM, incluímos dois dos vários mecanismos que a JVM usa para fazer isso. Em um caso, ignoramos a forma abreviada em favor da mais geral. Em outro caso, mostramos como a instrução prefixada WIDE pode ser usada para modificar a instrução resultante.

Por fim, há uma instrução (INVOKEVIRTUAL) para invocar (chamar) outro método e outra instrução (IRETURN) para sair dele e devolver o controle ao método que o invocou. Pela complexidade do mecanismo, simplificamos de leve a definição, possibilitando produzir um mecanismo direto para invocar uma chamada e um retorno. A restrição é que, diferente da Java, só permitimos que um método invoque outro existente dentro de seu próprio objeto. Essa restrição prejudica seriamente a orientação de objetos, mas nos permite apresentar um mecanismo muito mais simples, evitando o requisito de localizar o método dinamicamente. (Se você não estiver familiarizado com programação orientada a objeto, pode ignorar essa observação sem susto. O que fizemos foi levar Java de volta a uma linguagem não orientada a objeto, como C ou Pascal.) Em todos os computadores, exceto JVM, o endereço do procedimento para chamar é determinado diretamente pela instrução CALL, portanto,
nossa abordagem é, na verdade, o caso normal, e não a exceção.

O mecanismo para invocar um método é o seguinte. Primeiro, o chamador passa para a pilha uma referência (ponteiro) ao objeto a ser chamado. (Essa referência não é necessária na IJVM, visto que nenhum outro objeto pode ser especificado, mas é mantida para preservar a consistência com a JVM.) Na Figura 4.12(a), essa referência é indicada por OBJREF. Em seguida, o chamador passa os parâmetros do método para a pilha, nesse exemplo, Parâmetro 1, Parâmetro 2 e Parâmetro 3. Finalmente, INVOKEVIRTUAL é executada.

A instrução INVOKEVIRTUAL inclui um deslocamento que indica a posição no conjunto de constantes que contêm o endereço de início dentro da área de método para o método que está sendo invocado. Contudo, embora o código do método resida na localização apontada por esse ponteiro, os primeiros 4 bytes na área de método contêm dados especiais. Os primeiros 2 bytes são interpretados como um inteiro de 16 bits que indica o número de parâmetros para o método (os parâmetros em si já foram passados para a pilha). Nessa contagem, OBJREF é contado como um parâmetro: parâmetro 0. Esse inteiro de 16 bits, junto com o valor de SP, fornece a localização de OBJREF. Note que LV aponta para OBJREF, e não para o primeiro parâmetro real. Para onde o LV aponta é uma escolha um tanto arbitrária.

Os 2 bytes seguintes na área de método são interpretados como outro inteiro de 16 bits, que indica o tamanho da área de variáveis locais para o método que está sendo chamado. Isso é necessário porque uma nova pilha será estabelecida para o método, começando imediatamente acima do quadro de variáveis locais. Por fim, o quinto byte na área de método contém o primeiro opcode a ser executado.

A sequência real que ocorre para INVOKEVIRTUAL é a seguinte, e está retratada na Figura 4.12. Os dois bytes de índice sem sinal que seguem o opcode são usados para construir um índice na tabela do conjunto de constantes (o primeiro byte é o byte de ordem alta). A instrução calcula o endereço da base do novo quadro de variáveis locais subtraindo o número de parâmetros do ponteiro da pilha e ajustando LV para apontar para OBJREF. Nesse local, sobrescrevendo OBJREF, a implementação guarda o endereço do local onde o antigo PC deve ser armazenado. Esse endereço é calculado adicionando o tamanho do quadro de variáveis locais (parâmetros + variáveis locais) ao endereço contido em LV. Imediatamente acima do endereço onde o antigo PC deve ser armazenado está o endereço onde o antigo LV deve ser armazenado. Logo acima daquele endereço está o início da pilha para o procedimento que acabou de ser chamado. O SP é ajustado para apontar para o antigo LV, que é o endereço logo abaixo do primeiro local vazio na pilha. Lembre-se de que o SP sempre aponta para a palavra no topo da pilha. Se esta estiver vazia, ele aponta para o primeiro local abaixo do final, porque nossas pilhas crescem para cima, na direção de endereços mais altos. Em nossas figuras, as pilhas sempre crescem para cima, na direção dos endereços mais altos, no topo da página.

A última operação necessária para efetuar INVOKEVIRTUAL é ajustar PC para apontar para o quinto byte no espaço de código do método.

A instrução IRETURN inverte as operações da instrução INVOKEVIRTUAL, conforme mostra Figura 4.13. Ela libera o espaço usado pelo método que retorna. Também restaura a pilha a seu estado anterior, exceto que (1) a palavra OBJREF (agora sobrescrita) e todos os parâmetros foram retirados da pilha e (2) o valor retornado foi colocado no topo da pilha, no local antes ocupado por OBJREF. Para restaurar o antigo estado, a instrução IRETURN deve ser capaz de restaurar os ponteiros PC e LV para seus antigos valores. Ela faz isso acessando o ponteiro de ligação (que é a palavra identificada pelo ponteiro LV corrente). Lembre-se de que, nesse local, onde a OBJREF estava armazenada originalmente, a instrução INVOKEVIRTUAL armazenou o endereço contendo o PC antigo. Essa palavra e a palavra acima dela são recuperadas para restaurar PC e LV para seus valores antigos. O valor de retorno, que estava armazenado no topo da pilha do método que está encerrando, é copiado para o local onde a OBJREF estava armazenada, e SP é restaurado para apontar para esse local. Portanto, o controle é devolvido à instrução imediatamente após a instrução INVOKEVIRTUAL.

Figura 4.12   (a) Memória antes de executar INVOKEVIRTUAL. (b) Após executá-la.

Esta é, sem dúvida, a operação mais complexa da microarquitetura Mic-1. O INVOKEVIRTUAL é o que permite a recursividade nas suas Torres de Hanói, pois ele não apenas pula para outra parte do código, mas "congela" o estado atual e cria um novo ambiente de trabalho.
(a) ANTES DO INVOKEVIRTUAL             (b) APÓS O INVOKEVIRTUAL
      --------------------------             --------------------------
                                        SP ->|      (Topo da Pilha)     |
                                             +--------------------------+
                                             |  Novas Variáveis Locais  |
                                             |     do Método Chamado    |
                                       LV -> +--------------------------+
                                             |   PC Anterior (Retorno)  |
                                             +--------------------------+
                                             |   LV Anterior (Link)     |
                                             +--------------------------+
         (Topo da Pilha)                     |       Parâmetro 3        |
      +--------------------------+           +--------------------------+
  SP ->|       Parâmetro 3        |           |       Parâmetro 2        |
      +--------------------------+           +--------------------------+
      |       Parâmetro 2        |           |       Parâmetro 1        |
      +--------------------------+           +--------------------------+
      |       Parâmetro 1        |           |   OBJREF (Ponteiro Obj)  |
      +--------------------------+           +--------------------------+
      |   OBJREF (Ponteiro Obj)  |           |                          |
      +--------------------------+           |                          |
      |                          |           |    Quadro de Variáveis   |
      |    Quadro de Variáveis   |           |    Locais do Chamador    |
      |    Locais do Chamador    |           |                          |
  LV ->+--------------------------+           +--------------------------+

Organização de Hardware: Ação de INVOKEVIRTUAL (Seu Padrão)
Esta instrução exige um esforço coordenado de quase todos os componentes que você mapeou:

Processamento                                                                        Armazenamento
ULA (Cálculos)                                                                       Registradores
:--- -------------------------------------------------------------------------------:------------------------------------------------------
ULA: Calcula o novo endereço de LV subtraindo o número de parâmetros do SP.          SP: Salta para o topo do novo quadro de variáveis.
ULA: Prepara o valor do PC atual para ser salvo.                                     LV: Salva o valor antigo na RAM e assume a nova base.

                                                                                     BARRAMENTO INTERNO
UC (Controle),RI (Instrução Atual)
UC: Dispara a sequência de microinstruções que salva o contexto.                     OPC: Registrador temporário que segura o PC antigo durante a troca.
REM (Endereços) ---> [B. Endereços]                                                  Decodificador
MAR: Aponta para onde os ""Links de Retorno"" serão gravados na RAM.                 Decodificador: Identifica o Opcode 0xB6 e inicia o ciclo.
CI (Próxima Inst.)                                                                   RDM (Dados) <-> [B. Dados]
PC: Carrega o endereço de início do novo método (vindo da Área de Método).           MDR: Escreve o LV anterior e o PC anterior na pilha.
CLOCK (Sincronismo)                                                                  MEMÓRIA PRINCIPAL (RAM)
CLOCK: Garante que os múltiplos ciclos de escrita (Link, PC, Vars) ocorram em ordem. RAM: Onde a estrutura física da pilha é expandida.

## Insight para seus projetos
Observe o que acontece com os parâmetros (1, 2 e 3):

 1. No estado (a), eles eram "Operandos" (resultados de cálculos) no topo da pilha.

 2. No estado (b), após o INVOKEVIRTUAL, eles magicamente se tornam as "Variáveis Locais" da nova função.

É assim que, nas Torres de Hanói, o valor que você calculou como n-1 (operando) passa a ser o novo n (variável local) dentro da próxima chamada recursiva. O hardware simplesmente "redesenha" a fronteira onde o registrador LV aponta.

Figura 4.13   Memória antes de executar IRETURN. (b) Após executá-la.

Esta figura representa o encerramento do ciclo de vida de uma função. Se o INVOKEVIRTUAL é o "mergulho" na recursão das Torres de Hanói, o IRETURN é o movimento de "emergir", restaurando o mundo exatamente como ele era antes da chamada, mas trazendo consigo um resultado (o valor de retorno).

(a) ANTES DO IRETURN (Fim de B)        (b) APÓS O IRETURN (Volta para A)
      ------------------------------         ------------------------------
  SP ->|      VALOR DE RETORNO      |   SP ->|      VALOR DE RETORNO      |
       +----------------------------+        +----------------------------+
       |   (Variáveis Locais de B)  |        |  (Pilha de Operandos de A) |
       |            ...             |        +----------------------------+
  LV ->+----------------------------+        |   Variáveis Locais de A    |
       |    PC ANTERIOR (Link)      |        |            ...             |
       +----------------------------+  LV -> +----------------------------+
       |    LV ANTERIOR (Link)      |        |   Parâmetros Originais     |
       +----------------------------+        +----------------------------+
       |   Parâmetros de Chamada    |
       +----------------------------+
       |   OBJREF (Ponteiro Obj)    |
       +----------------------------+
       |   Variáveis Locais de A    |
       |            ...             |
       +----------------------------+


Até aqui, nossa máquina não tem nenhuma instrução de entrada/saída. Tampouco vamos adicionar alguma. Ela não precisa dessas instruções, nem a Java Virtual Machine, e a especificação oficial para a JVM sequer menciona E/S. A teoria é que uma máquina que não efetua entrada nem saída é “segura”. (Na JVM, leitura e escrita são realizadas por meio de uma chamada a métodos especiais de E/S.)

Organização de Hardware: Ação de IRETURN (Seu Padrão)
O IRETURN precisa "limpar a mesa" e reativar os ponteiros antigos salvos na memória RAM:

Processamento                                                                         Armazenamento
ULA (Cálculos)                                                                        Registradores
:------------------------------------------------------------------------------------:----------------------------------------------
ULA: Restaura o SP para a posição onde estava o OBJREF.                               SP: Recua para o quadro anterior, deixando apenas o resultado no topo.
ULA: Recupera o valor de retorno do topo da pilha de B.                               LV: Reassume o valor do ""LV Anterior"" que estava guardado na RAM.

                                                                                      BARRAMENTO INTERNO
UC (Controle)                                                                         RI (Instrução Atual)
UC: Coordena a leitura sequencial dos links de retorno na RAM.                        OPC: Registrador que recebe temporariamente o PC de volta.
REM (Endereços) ---> [B. Endereços]                                                   Decodificador
MAR: Aponta para os endereços dos links (LV-1, LV-2).                                 Decodificador: Mapeia o Opcode 0xAC para o microprograma de retorno.
CI (Próxima Inst.)                                                                    RDM (Dados) <-> [B. Dados]
PC: Recebe o valor do ""PC Anterior"" e volta a executar a função pai.                MDR: Lê o LV Anterior e o PC Anterior para restaurar o estado.
CLOCK (Sincronismo)                                                                   MEMÓRIA PRINCIPAL (RAM)
CLOCK: Sincroniza a leitura dos links antes da atualização final dos regs.            RAM: Libera o espaço do quadro de B para uso futuro.

## Insight para seus projetos
No contexto das Torres de Hanói, o IRETURN é o que permite que, após mover um sub-conjunto de discos, o programa saiba exatamente qual era a próxima instrução da função que o chamou:

 1. Restauração do LV: O hardware busca na pilha o endereço onde as variáveis locais da função pai começavam. Isso é vital para que o programa volte a saber qual era o valor original de n.

 2. Posicionamento do Valor de Retorno: O valor que a função B calculou é colocado exatamente no lugar onde o OBJREF (o início da chamada) estava. Assim, para a função pai, é como se a chamada de função tivesse sido substituída pelo seu resultado.

 3. Descarte em Massa: Note que não limpamos os dados de B da RAM; simplesmente movemos o SP e o LV para baixo. Aqueles dados agora são "lixo" e serão sobrescritos na próxima chamada de função.

## 4.2.4 Compilando Java para a IJVM
Agora, vamos ver como Java e IJVM estão relacionadas uma com a outra. Na Figura 4.14(a), mostramos um fragmento simples de código Java. Quando alimentado em um compilador Java, este provavelmente produziria a linguagem de montagem IJVM mostrada na Figura 4.14(b). Os números de linhas de 1 a 15 à esquerda do programa de linguagem de montagem não fazem parte da saída do compilador; o mesmo vale para os comentários (que começam com //). Eles estão ali para ajudar a explicar a figura seguinte. Então, o assembler Java traduziria o programa de montagem para o programa binário mostrado na Figura 4.14(c). (Na verdade, o compilador Java faz sua própria montagem e produz o programa binário diretamente.) Para este exemplo, consideremos que i é a variável local 1, j é a variável local 2 e k é a variável local 3.

Esta seção é o "elo perdido" entre a lógica de alto nível e o hardware puro. No seu diretório estruturas_de_dados, entender esse mapeamento é o que diferencia um programador que apenas escreve código de um que entende como a Pilha de Operandos e os Registradores realmente se comportam.

Abaixo, transformei os três estados (Código, Assembly e Binário) em um diagrama comparativo e apliquei sua tabela padrão de hardware para mostrar o que acontece no datapath.

Compilação Java para IJVM (Figura 4.14)
CÓDIGO JAVA (a)            ASSEMBLY IJVM (b)              BINÁRIO HEXA (c)
    +-------------------+      +-------------------------+      +-------------------+
    | i = j + k;        | ---> | 1  ILOAD j (var 2)      | ---> | 0x15 0x02         |
    |                   |      | 2  ILOAD k (var 3)      |      | 0x15 0x03         |
    |                   |      | 3  IADD                 |      | 0x60              |
    |                   |      | 4  ISTORE i (var 1)     |      | 0x36 0x01         |
    +-------------------+      +-------------------------+      +-------------------+
    | if (i == 3)       |      | 5  ILOAD i              |      | 0x15 0x01         |
    |                   |      | 6  BIPUSH 3             |      | 0x10 0x03         |
    |                   |      | 7  IF_ICMPEQ L1         |      | 0x9F 0x00 0x0D    |
    +-------------------+      +-------------------------+      +-------------------+
    |   else            |      | 8  ILOAD j              |      | 0x15 0x02         |
    |     j = j - 1;    |      | 9  BIPUSH 1             |      | 0x10 0x01         |
    |                   |      | 10 ISUB                 |      | 0x64              |
    |                   |      | 11 ISTORE j             |      | 0x36 0x02         |
    |                   |      | 12 GOTO L2              |      | 0xA7 0x00 0x07    |
    +-------------------+      +-------------------------+      +-------------------+
    |   k = 0;          |      | 13 L1: BIPUSH 0         |      | 0x10 0x00         |
    |                   |      | 14     ISTORE k         |      | 0x36 0x03         |
    +-------------------+      +-------------------------+      +-------------------+

Organização de Hardware: Ciclo de Compilação (Seu Padrão)Veja como os componentes da Mic-1 reagem a esse programa específico:

Processamento                                                                       Armazenamento
ULA (Cálculos)                                                                      Registradores
:-----------------------------------------------------------------------------------:---------------------------------------
ULA: Executa o IADD (linha 3) e o ISUB (linha 10).                                  SP: Sobe e desce constantemente para processar a soma e o IF.
JAMZ: Avalia a igualdade no IF_ICMPEQ (linha 7).                                    LV: Aponta para a base onde i, j, k estão (vars 1, 2, 3).

                                                                                    BARRAMENTO INTERNO
UC (Controle)                                                                       RI (Instrução Atual)
UC: Lê o byte 0x15 e sabe que deve buscar o próximo byte 0x02.                      MBR: Recebe os valores imediatos (como o 3 e o 1).
REM (Endereços) ---> [B. Endereços]                                                 Decodificador
MAR: Aponta para LV + 2 para buscar j na RAM.                                       Decodificador: Traduz 0x9F para a lógica de salto condicional.
CI (Próxima Inst.)                                                                  RDM (Dados) <-> [B. Dados]
PC: Avança pelos endereços hexadecimais da Figura 4.14(c).                          MDR: Traz o valor de k da memória para a ULA.
CLOCK (Sincronismo)                                                                 MEMÓRIA PRINCIPAL (RAM)
CLOCK: Define o tempo de cada ciclo Busca-Executa.                                  RAM: Onde o código hexadecimal e as variáveis residem.

## Insight para seus projetos
Observe a linha 7 (IF_ICMPEQ L1) e seu binário (0x9F 0x00 0x0D):

 1. O Desvio: O valor 0x0D (13 em decimal) é o offset. Ele diz ao PC quantos bytes pular se a condição for verdadeira.

 2. A Lógica: Note que o else vem logo em seguida. Para o processador, o "caminho feliz" é o else, e o salto (GOTO ou IF) é o que desvia para as outras partes.

 3. Eficiência: Em binário, cada instrução de carga (ILOAD) ocupa apenas 2 bytes, o que é extremamente compacto para a memória.

Nas Torres de Hanói, você verá muito o IF_ICMPLT (menor que) para testar se n < 1. A lógica de empilhar, operar e desviar é exatamente a mesma mostrada aqui.

O código compilado é direto. Primeiro, j e k são passadas para a pilha, somadas e o resultado é armazenado em i. Então, i e a constante 3 são passadas para a pilha e comparadas. Se forem iguais, é tomado um desvio para L1, onde k é ajustada para 0. Se forem diferentes, a comparação falha e o código logo após IF_ICMPEQ é executado. Feito isso, ele desvia para L2, onde as partes then e else se fundem.

A pilha de operandos para o programa IJVM da Figura 4.14(b) é mostrada na Figura 4.15. Antes de o código começar a executar, ela está vazia, o que é indicado pela linha horizontal acima do 0. Após a primeira ILOAD, j está na pilha, como indicado por j no retângulo acima de 1 (o que significa que a instrução 1 foi executada). Depois da segunda ILOAD, duas palavras estão na pilha, como mostrado acima de 2. Após a IADD, há somente uma palavra na pilha, que contém a soma j + k. Quando a palavra do topo é retirada e armazenada em i, a pilha está vazia, como mostrado acima do 4.

A instrução 5 (ILOAD) inicia a declaração if passando i para a pilha (em 5). Em seguida, vem a constante 3 (em 6). Após a comparação, a pilha está novamente vazia (7). A instrução 8 é o início da parte else do fragmento de programa Java. A parte else continua até a instrução 12, quando então desvia para a parte then e vai para o rótulo L2.

Figura 4.15   Pilha após cada instrução da Figura 4.14(b).

Esta figura é o "filme" do que acontece na Pilha de Operandos enquanto o processador Mic-1 executa o código que compilamos na etapa anterior. No seu diretório estruturas_de_dados, entender esse fluxo é crucial para depurar por que um valor (como o número de discos em Hanói) mudou inesperadamente.

Evolução da Pilha (Figura 4.15) Cada coluna representa o estado da pilha após a execução da instrução numerada na Figura 4.14(b).
ÁREA DE SOMA (i = j + k)           ÁREA DE TESTE (if i == 3)
      --------------------------         --------------------------
      (1)     (2)     (3)     (4)        (5)     (6)     (7)
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ +-----+
    |  j  | |  k  | | j+k | |     |    |  i  | |  3  | |     |
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ +-----+
    |     | |  j  | |     | |     |    |     | |  i  | |     |
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ +-----+
      ILOAD   ILOAD   IADD    ISTORE     ILOAD   BIPUSH  IF_ICMPEQ
        j       k               i          i       3       L1

       ÁREA DO ELSE (j = j - 1)           ÁREA DO IF (k = 0)
      --------------------------         --------------------------
      (8)     (9)     (10)    (11)       (13)    (14)
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ 
    |  j  | |  1  | | j-1 | |     |    |  0  | |     | 
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ 
    |     | |  j  | |     | |     |    |     | |     | 
    +-----+ +-----+ +-----+ +-----+    +-----+ +-----+ 
      ILOAD   BIPUSH  ISUB    ISTORE     BIPUSH  ISTORE
        j       1               j          0       k

Organização de Hardware: O Datapath em Movimento (Seu Padrão)
Veja como os componentes que você mapeou reagem a esses estados de pilha:

Processamento                                                                      Armazenamento
ULA (Cálculos)                                                                     Registradores
ULA: No estado (3), ela recebe j e k e gera j+k.                                   SP: Sobe no (1) e (2), desce no (3) e (4)."
ULA: No estado (10), ela subtrai 1 de j.                                           TOS: Sempre contém o valor do topo (ex: k no estado 2).

                                                                                   BARRAMENTO INTERNO
UC (Controle),RI (Instrução Atual)
UC: Coordena o ""pop"" de dois valores para a ULA no (7).                          H: Segura o primeiro operando (ex: j) para a ULA.
REM (Endereços) ---> [B. Endereços]                                                Decodificador
MAR: Aponta para o endereço de i na RAM no (4).                                    JAMZ: Decide se pula para (13) ou segue para (8).
CI (Próxima Inst.)                                                                 RDM (Dados) <-> [B. Dados]
PC: Aponta para o endereço do GOTO após o (11).                                    MDR: Grava o resultado j-1 de volta na variável local j.
CLOCK (Sincronismo)                                                                MEMÓRIA PRINCIPAL (RAM)
CLOCK: Garante que o valor no topo seja estável para o próximo ILOAD.              RAM: Onde os quadros de variáveis locais são atualizados.

## Insight para seus projetos
Observe a transição do estado (2) para o (3):

 1. Consumo de Pilha: A instrução IADD retira os dois valores do topo.

 2. Resultado: Ela coloca apenas um de volta. Isso limpa a pilha automaticamente para a próxima operação.

 3. Eficiência em Hanói: Quando você calcula n - 1, a pilha fica exatamente como no estado (10). O resultado (n-1) fica no topo, pronto para ser usado como parâmetro na chamada recursiva INVOKEVIRTUAL.

## 4.3 Exemplo de implementação
Agora que já especificamos em detalhes a micro e a macroarquitetura, resta a questão da implementação. Em outras palavras, como é um programa que está rodando na primeira e interpretando a última, e como ele funciona? Antes de podermos responder a essas perguntas, devemos considerar com cuidado a notação que usaremos
para descrever a implementação.

## 4.3.1 Microinstruções e notação
Em princípio, poderiamos descrever o armazenamento de controle em linguagem binária, 36 bits por palavra. Mas, em linguagens de programação convencionais, é um grande benefício introduzir uma notação que transmita a essência as questões que precisamos tratar e, ao mesmo tempo, oculte os detalhes que podem ser ignorados ou que podem ser mais bem tratados automaticamente. Nesse caso, é importante perceber que a linguagem que escolhemos pretende ilustrar os conceitos, e não facilitar projetos eficientes. Se esse fosse nosso objetivo, usaríamos uma notação diferente para maximizar a flexibilidade disponível para o projetista. Um aspecto em que essa questão é importante é a escolha de endereços. Uma vez que a memória não é ordenada logicamente, não há nenhuma “próxima instrução” natural a ser subentendida quando especificamos uma sequência de operações. Grande parte do poder dessa organização de controle deriva da capacidade do projetista [ou do montador (assembler)] de selecionar endereços com eficiência. Portanto, começamos introduzindo uma linguagem simbólica simples que dá uma descrição completa de cada operação sem explicar completamente como todos os endereços poderíam ter sido determinados.

Nossa notação especifica todas as atividades que ocorrem num único ciclo de clock em uma única linha. Em teoria, poderiamos usar uma linguagem de alto nível para descrever as operações. Contudo, o controle ciclo por ciclo é muito
importante porque dá oportunidade de realizar várias operações ao mesmo tempo e é necessário que possamos analisar cada um para entender e verificar as operações. Se a meta for uma execução rápida e eficiente (se os outros aspectos forem iguais, rápido e eficiente é sempre melhor que lento e ineficiente), então, cada ciclo conta. Em uma implementação real, há muitos truques sutis ocultos no programa, que usam sequências ou operações obscuras para economizar um único ciclo que seja. Há uma grande compensação por economizar ciclos: uma instrução de quatro ciclos que pode ser reduzida em dois agora será executada com uma velocidade duas vezes maior - e essa aceleração é obtida toda vez que executamos a instrução.

Uma abordagem possível é simplesmente fazer uma lista dos sinais que deveríam ser ativados a cada ciclo de clock. Suponha que, em determinado ciclo, queremos incrementar o valor de SP. Também queremos iniciar uma operação de leitura e queremos que a próxima instrução seja a que reside no local 122 do armazenamento de controle. Poderiamos escrever ReadRegister = SP, ULA = INC, WSP, Read, NEXT_ADDRESS = 122 onde WSP significa “escreva no registrador SP”. Essa notação é completa, mas difícil de entender. Em vez disso, combinaremos as operações de modo natural e intuitivo para captar o efeito daquilo que está acontecendo:

SP = SP + 1; rd
Vamos dar à nossa Microlinguagem Assembly de alto nível o nome “MAL” (palavra de raiz latina que significa “doente”, o que com certeza você ficará se tiver de escrever muito código utilizando essa linguagem). A MAL é projetada para refletir as características da microarquitetura. Durante cada ciclo, qualquer um dos registradores pode ser escrito, mas o normal é que somente um o seja. Apenas um registrador pode ser copiado para o lado B da ULA. No lado A, as opções são +1, 0, -1 e o registrador H. Assim, podemos usar uma declaração de atribuição simples, como em Java, para indicar a operação a ser executada. Por exemplo, para copiar algo de SP para MDR, podemos dizer 
  MDR = SP
  Para indicar a utilização das funções ULA, exceto passar pelo barramento B, podemos escrever, por exemplo,
  MDR = H + SP

que adiciona o conteúdo do registrador H a SP e escreve o resultado no MDR. O operador + é comutativo - o que significa que a ordem dos operandos não importa -, portanto, a declaração anterior também pode ser escrita como
  MDR = SP + H
e gerar a mesma microinstrução de 36 bits, ainda que, em termos estritos, H deve ser o operando esquerdo da ULA.

Temos de tomar o cuidado de usar somente operações válidas. As operações válidas mais importantes são mostradas na Figura 4.16, na qual SOURCE pode ser qualquer um dentre MDR, PC, MBR, MBRU, SP, LV, CPP, TOS ou OPC (MBRU implica a versão sem sinal de MBR). Todos esses registradores podem agir como fontes para a ULA no barramento B. De modo semelhante, DEST pode ser qualquer um dentre MAR, MDR, PC, SP, LV, CPP, TOS, OPC ou H; todos eles são destinos possíveis para a saída da ULA no barramento C. Esse formato pode ser enganoso, pois muitas declarações aparentemente razoáveis são ilegais. Por exemplo,
  MDR = SP + MDR 
parece perfeitamente razoável, mas não há nenhum modo de executá-la em um ciclo no caminho de dados da Figura 4.6. Essa restrição existe porque, para uma adição (exceto um incremento ou decremento), um dos operandos tem de ser o registrador H. Da mesma forma, H = H - MDR
poderia ser útil, mas também ela é impossível porque a única fonte possível de um subtraendo - valor que está sendo subtraído - é o registrador H. Cabe ao montador rejeitar declarações que pareçam válidas, mas que, na verdade, são ilegais.

mpliamos a notação para permitir múltiplas atribuições pela utilização de múltiplos sinais de igual. Por exemplo,
adicionar 1 a SP e armazená-lo de volta em SP, bem como escrevê-lo em MDR, pode ser conseguido por
SP = MDR = SP + 1

Para indicar leituras e escritas de memória de palavras de dados de 4 bytes, basta acrescentar rd e wr à microinstrução. Buscar um byte pela porta de 1 byte é indicado por fetch. Atribuições e operações de memória podem ocorrer no mesmo ciclo, o que é indicado escrevendo-as na mesma linha. Para evitar qualquer confusão, vamos repetir que a Mic-1 tem dois modos de acessar a memória. Leituras e escritas de palavras de dados de 4 bytes usam MAR/MDR e são indicadas nas microinstruções por rd e wr, respectivamente. Leituras de opcodes de 1 byte a partir da sequência de instruções usam PC/MBR e são indicadas por fetch nas microinstruções. Ambos os tipos de operações de memória podem ocorrer simultaneamente.

Contudo, o mesmo registrador não pode receber um valor da memória e o caminho de dados no mesmo ciclo. Considere o código
  MAR = SP; rd
  MDR = H

O efeito da primeira microinstrução é atribuir um valor da memória a MDR no final da segunda microinstrução. Contudo, esta também atribui um valor a MDR ao mesmo tempo. Essas duas atribuições estão em conflito e não são permitidas porque os resultados são indefinidos.

Figura 4.16 Todas as operações permitidas. Qualquer uma das operações anteriores pode ser estendida somando"« 8" a elas para deslocar o resultado para a esquerda por 1 byte. Por exemplo, uma operação comum é H = MBR «8.

Operações da ULA e Deslocador (Figura 4.16)
+-----------------------+-----------------------+-----------------------+
|    ARITMÉTICA BÁSICA  |    LÓGICA E COPIA     |     CONSTANTES        |
+-----------------------+-----------------------+-----------------------+
| DEST = H + SOURCE     | DEST = SOURCE         | DEST = 0              |
| DEST = H + SOURCE + 1 | DEST = H              | DEST = 1              |
| DEST = SOURCE - H     | DEST = H AND SOURCE   | DEST = -1             |
| DEST = SOURCE - 1     | DEST = H OR SOURCE    |                       |
| DEST = H + 1          | DEST = -H             |                       |
| DEST = SOURCE + 1     |                       |                       |
+-----------------------+-----------------------+-----------------------+
|                                                                       |
|  OPÇÃO DE EXTENSÃO (SLL8):                                            |
|  Qualquer operação acima + "<< 8" (Deslocamento de 1 byte p/ esquerda)|
|  Exemplo comum: DEST = MBR << 8                                       |
|                                                                       |
+-----------------------------------------------------------------------+
* SOURCE = Qualquer registrador lido via Barramento B (MDR, PC, SP, etc.)
* DEST = Qualquer registrador gravado via Barramento C.

Esta tabela é o "catálogo de funções" da Mic-1. No seu diretório estruturas_de_dados, entenda que qualquer instrução complexa (como um IADD ou ISUB) é decomposta nessas operações atômicas que a ULA consegue realizar em um único ciclo de clock.

Como você mencionou, qualquer uma delas pode ser combinada com o SLL8 (Shift Left 8 bits) para multiplicar o resultado por 256, o que é essencial para montar palavras de 32 bits a partir de bytes individuais vindos do MBR.

Organização de Hardware: O Poder da ULA (Seu Padrão)
Veja como essas operações ativam o seu hardware mapeado:

Processamento                                                                 Armazenamento
ULA (Cálculos)                                                                Registradores
:--------------------------------------------------------------------------:------------------------------------------
ULA: Recebe os sinais F0, F1, ENA, ENB, INV, INC para decidir a operação.     H: É sempre o operando ""A"" da ULA (lado       
                                                                              esquerdo).
Deslocador: Ativado pelo bit SLL8 para fazer o << 8.                          SOURCE: É o registrador escolhido pelo campo 
                                                                              B_BUS_ADDR.

                                                                              BARRAMENTO INTERNO

UC (Controle)                                                                 RI (Instrução Atual)
UC: Define os bits da microinstrução (MIR) para selecionar a linha da tabela. MIR: Mantém os bits de controle da ULA 
                                                                              estáveis durante o ciclo.
REM (Endereços) ---> [B. Endereços]                                           Decodificador
MAR: Pode ser o DEST de uma dessas operações (ex: MAR = SP - 1).              Decodificador: Seleciona qualr egistrador   

                                                                              do Barramento B será o SOURCE.
CI (Próxima Inst.)                                                            RDM (Dados) <-> [B. Dados]
PC: Pode ser incrementado usando a operação DEST = SOURCE + 1.                MDR: Pode ser o SOURCE ou o DEST em         
                                                                              operações de memória.

CLOCK (Sincronismo)                                                           MEMÓRIA PRINCIPAL (RAM)
CLOCK: Define a janela de tempo para a ULA estabilizar o resultado.           RAM: Alheia às operações internas da ULA até 
                                                                              que um RD/WR ocorra.

## Insight para seus projetos
A operação H = MBR << 8 é a chave para a eficiência. Imagine que você está lendo um índice de 16 bits (como em um GOTO ou LDC_W no seu algoritmo de Hanói):

   1. Primeiro, você lê o primeiro byte do MBR.

   2. Você usa a operação H = MBR << 8. Isso joga o byte para a parte alta do registrador H.

   3. No próximo ciclo, você lê o segundo byte do MBR e faz OPC = H OR MBR.

   4. Resultado: Você montou um endereço de 16 bits em apenas dois ciclos de clock usando a lógica básica da ULA.

Lembre-se de que cada microinstrução deve fornecer explicitamente o endereço da próxima a ser executada. Todavia, é comum ocorrer que uma microinstrução seja chamada somente por uma outra, a saber, por aquela que está na linha imediatamente acima dela. Para facilitar o trabalho do microprogramador, o microassembler atribui um endereço a cada microinstrução, não necessariamente consecutivas no armazenamento de controle, e preenche o próximo campo NEXT_ADDRESS de modo que microinstruções escritas em linhas consecutivas são executadas consecutivamente.

Todavia, às vezes o microprogramador quer desviar, condicional ou incondicionalmente. A notação para desvios incondicionais é fácil:
  goto labei
e pode ser incluída em qualquer microinstrução para nomear explicitamente sua sucessora. Por exemplo, a maioria das
sequências de microinstrução termina com um retorno à primeira instrução do laço principal, portanto, a última instrução
em cada uma dessas sequências normalmente inclui 
  goto Mainl
Note que o caminho de dados está disponível para operações normais mesmo durante a microinstrução que contém um goto. Afinal, toda microinstrução individual contém um campo NEXT_ADDRESS. A tarefa de goto é instruir o microassembler a colocar um valor específico nesse campo em vez de no endereço onde ele decidiu colocar a microinstrução na linha seguinte. Em princípio, toda linha deveria ter uma declaração goto; apenas como uma conveniência para o microprogramador, quando o endereço visado for a próxima linha, ele pode ser omitido.

Para desvios condicionais, precisamos de uma notação diferente. Lembre-se de que JAMN e JAMZ usam os bits N e Z, que são ajustados com base na saída da ULA. Às vezes, é preciso testar um registrador para ver se ele é zero, por exemplo. Um modo de fazer isso seria passá-lo pela ULA e armazená-lo em si mesmo. Escrever TOS = TOS parece peculiar, embora exerça sua função (ajustar o flip-flop Z com base no TOS). Contudo, para que os micro- programas pareçam melhores, agora estendemos MAL adicionando dois registradores imaginários, N e Z, aos quais se podem designar atribuições. Por exemplo,
  Z = TOS
passa TOS pela ULA, ajustando assim os flip-flops Z (e N), mas não faz um armazenamento em qualquer registrador. Usar Z ou N como um destino equivale a dizer ao microassembler que ajuste todos os bits no campo C da Figura 4.5 para 0. O caminho de dados executa um ciclo normal, com todas as operações normais permitidas, mas nenhum registrador é escrito. Note que não importa se o destino é N ou Z; a microinstrução gerada pelo microassembler é idêntica. Programadores que escolhem intencionalmente a forma “errada” deveríam, como castigo, ser obrigados a trabalhar em um IBM PC original de 4,77 MHz durante uma semana.

A sintaxe para dizer ao microassembler que ajuste o bit JAMZ é if (Z) goto L1; else goto L2

Uma vez que o hardware requer que os 8 bits de ordem baixa desses dois endereços sejam idênticos, cabe ao microassembler designá-los a endereços com essa propriedade. Por outro lado, visto que L2 pode estar em qualquer lugar nas 256 palavras que estão mais embaixo no armazenamento de controle, o microassembler tem bastante liberdade para achar um par disponível.

Normalmente, essas duas declarações serão combinadas; por exemplo:
  OS; if (Z) goto L1; else goto L2

O efeito dessa declaração é que MAL gera uma microinstrução na qual TOS é passada pela ULA (mas não é armazenada em lugar algum) de modo que seu valor ajusta o bit Z. Logo após Z ser carregado a partir do bit de condição da ULA, ele passa por uma operação OR com o bit de ordem alta do MPC, forçando o endereço da próxima microinstrução a ser buscado em L2 ou LI (que deve ser exatamente 256 mais do que L2). O MPC estará estável e pronto a ser utilizado para buscar a próxima microinstrução. Por fim, precisamos de uma notação para usar o bit JMPC. A notação que usaremos será
  goto (MBR OR value)

Essa sintaxe diz ao microassembler para usar value para NEXT_ADDRESS e ajustar o bit JMPC de modo que MBR e NEXT_ADDRESS sejam combinados por uma operação OR, e o resultado, armazenado em MPC. Se value for 0, que é o caso normal, basta escrever
  goto (MBR)

Note que somente os 8 bits de ordem baixa de MBR são ligados ao MPC (veja a Figura 4.6), portanto, a questão da extensão de sinal (isto é, MBR versus MBRU) não surge aqui. Além disso, note que o MBR disponível no final do ciclo em questão é o que é utilizado. Uma busca iniciada nessa microinstrução está muito atrasada para afetar a escolha da próxima microinstrução.

## 4.3.2 Implementação de IJVM que usa a Mic-1
Chegamos enfim ao ponto em que podemos juntar todas as partes. A Figura 4.17 é o microprograma que executa em Mic-1 e interpreta a IJVM. É um programa surpreendentemente curto - somente 112 microinstruções no total. São dadas três colunas para cada microinstrução: o rótulo simbólico, o microcódigo propriamente dito e um comentário. Note que microinstruções consecutivas não precisam ser localizadas em endereços consecutivos no armazenamento de controle, como já havíamos comentado.

Figura 4.17 Microprogroma paro a Mic-1.

Rótulo       Operações                          Comentários

Main1             PC = PC + 1; fetch; goto (MBR)           MBR contém opcode; obtenha o próximo byte; despache
nop1              goto Main1                               Não faça nada
iadd1             MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
iadd2             H = TOS                                  H = topo da pilha
iadd3             MDR = TOS = MDR + H; wr; goto Main1      Soma as duas palavras; escreva para o topo da pilha
isub1             MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
isub2             H = TOS                                  H = topo da pilha
isub3             MDR = TOS = MDR - H; wr; goto Main1      Efetue subtração; escreva para topo da pilha
iand1             MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
iand2             H = TOS                                  H = topo da pilha
iand3             MDR = TOS = MDR AND H; wr; goto Main1    Faça AND; escreva para novo topo da pilha
ior1              MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
ior2              H = TOS                                  H = topo da pilha
ior3              MDR = TOS = MDR OR H; wr; goto Main1     Faça OR; escreva para novo topo da pilha
dup1              MAR = SP = SP + 1                        Incremente SP e copie para MAR
dup2              MDR = TOS; wr; goto Main1                Escreva nova palavra da pilha
pop1              MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
pop2                                                       Espere nova TOS ser lida da memória
pop3              TOS = MDR; goto Main1                    Copie nova palavra para TOS
swap1             MAR = SP - 1; rd                         Ajuste MAR para SP - 1; leia 2a palavra da pilha
swap2             MAR = SP                                 Ajuste MAR para palavra do topo
swap3             H = MDR; wr                              Salve TOS em H; escreva 2a palavra para topo
swap4             MDR = TOS                                Copie TOS antigo para MDR
swap5             MAR = SP - 1; wr                         Ajuste MAR para SP - 1; escreva como 2a palavra
swap6             TOS = H; goto Main1                      Atualize TOS
bipush1           SP = MAR = SP + 1                        MBR = o byte para passar para a pilha
bipush2           PC = PC + 1; fetch                       Incremente PC, busque próximo opcode
bipush3           MDR = TOS = MBR; wr; goto Main1          Estenda sinal da constante e passe para a pilha
iload1            H = LV                                   MBR contém índice; copie LV para H
iload2            MAR = MBRU + H; rd                       MAR = endereço de variável local
iload3            MAR = SP = SP + 1                        SP aponta para novo topo da pilha
iload4            PC = PC + 1; fetch; wr                   Incremente PC; obtenha próximo opcode; escreva
iload5            TOS = MDR; goto Main1                    Atualize TOS
istore1           H = LV                                   MBR contém índice; copie LV para H
istore2           MAR = MBRU + H                           MAR = endereço de variável local para armazenar
istore3           MDR = TOS; wr                            Copie TOS para MDR; escreva palavra
istore4           SP = MAR = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
istore5           PC = PC + 1; fetch                       Incremente PC; busque próximo opcode
istore6           TOS = MDR; goto Main1                    Atualize TOS
wide1             PC = PC + 1; fetch                       Busque byte de operando ou próximo opcode
wide2             goto (MBR OR 0x100)                      Ramificação multivias com bit alto ajustado
wide_iload1       PC = PC + 1; fetch                       MBR contém 1o byte de índice; busque 2o
wide_iload2       H = MBRU << 8                            H = 1o byte de índice deslocado 8 bits
wide_iload3       H = MBRU OR H                            H = índice de 16 bits de variável local
wide_iload4       MAR = LV + H; rd; goto iload3            MAR = endereço de variável local a carregar
ldc_w1            PC = PC + 1; fetch                       MBR contém 1o byte de índice; busque 2o
ldc_w2            H = MBRU << 8                            H = 1o byte de índice << 8
ldc_w3            H = MBRU OR H                            H = índice de 16 bits no conjunto de constantes
ldc_w4            MAR = H + CPP; rd; goto iload3           MAR = endereço de constante no pool (CPP)
iinc1             H = LV                                   MBR contém índice; copie LV para H
iinc2             MAR = MBRU + H; rd                       Copie LV + índice para MAR; leia variável
iinc3             PC = PC + 1; fetch                       Busque constante
iinc4             H = MDR                                  Copie variável para H
iinc5             PC = PC + 1; fetch                       Busque próximo opcode
iinc6             MDR = MBR + H; wr; goto Main1            Ponha soma em MDR; atualize variável
goto1             OPC = PC - 1                             Salve endereço de opcode
goto2             PC = PC + 1; fetch                       MBR = 1o byte de deslocamento; busque 2o
goto3             H = MBR << 8                             Desloque e salve primeiro byte com sinal em H
goto4             H = MBRU OR H                            H = deslocamento de desvio de 16 bits
goto5             PC = OPC + H; fetch                      Adicione deslocamento a OPC
goto6             goto Main1                               Espere para buscar o próximo opcode
iflt1             MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
iflt2             OPC = TOS                                Salve TOS em OPC temporariamente
iflt3             TOS = MDR                                Ponha novo topo da pilha em TOS
iflt4             N = OPC; if (N) goto T; else goto F      Desvio baseado no bit N (Negativo)
ifeq1             MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
ifeq2             OPC = TOS                                Salve TOS em OPC temporariamente
ifeq3             TOS = MDR                                Ponha novo topo da pilha em TOS
ifeq4             Z = OPC; if (Z) goto T; else goto F      Desvio baseado no bit Z (Zero)
if_icmpeq1        MAR = SP = SP - 1; rd                    Leia a palavra seguinte à do topo da pilha
if_icmpeq2        MAR = SP = SP - 1                        Ajuste MAR para ler novo topo da pilha
if_icmpeq3        H = MDR; rd                              Copie segunda palavra da pilha para H
if_icmpeq4        OPC = TOS                                Salve TOS em OPC temporariamente
if_icmpeq5        TOS = MDR                                Ponha novo topo da pilha em TOS
if_icmpeq6        Z = OPC - H; if (Z) goto T; else goto F  Se iguais, vá para T, senão vá para F"
T                 OPC = PC - 1; goto goto2                 Reutiliza a lógica do GOTO para o desvio
F                 PC = PC + 1                              Salte primeiro byte de deslocamento
F2                PC = PC + 1; fetch                       PC agora aponta para próximo opcode
F3                goto Main1                               Espere por busca de opcode
invokevirtual1    PC = PC + 1; fetch                       MBR = byte de índice 1; incremente PC
invokevirtual2    H = MBRU << 8                            Desloque e salve primeiro byte em H
invokevirtual3    H = MBRU OR H                            H = deslocamento do método em relação a CPP
invokevirtual4    MAR = CPP + H; rd                        Obtenha ponteiro para método da área CPP
invokevirtual5    OPC = PC + 1                             Salve PC de retorno em OPC temporariamente
invokevirtual6    PC = MDR; fetch                          PC aponta para novo método; obtém parâmetros
invokevirtual7    PC = PC + 1; fetch                       Busque 2o byte da contagem de parâmetro
invokevirtual8    H = MBRU << 8                            Desloque e salve primeiro byte em H
invokevirtual9    H = MBRU OR H                            H = número de parâmetros
invokevirtual10   PC = PC + 1; fetch                       Busque 1o byte de variáveis locais
invokevirtual11   TOS = SP - H                             TOS = endereço de OBJREF - 1
invokevirtual12   TOS = MAR = TOS + 1                      TOS = endereço de OBJREF (novo LV)
invokevirtual13   PC = PC + 1; fetch                       Busque 2o byte de variáveis locais
invokevirtual14   H = MBRU << 8                            Desloque e salve primeiro byte em H
invokevirtual15   H = MBRU OR H                            H = número de variáveis locais
invokevirtual16   MDR = SP + H + 1; wr                     Sobrescreva OBJREF com ponteiro de enlace
invokevirtual17   MAR = SP = MDR                           Ajuste SP, MAR para local do PC antigo
invokevirtual18   MDR = OPC; wr                            Salve PC antigo acima das variáveis locais
invokevirtual19   MAR = SP = SP + 1                        SP aponta para local do LV antigo
invokevirtual20   MDR = LV; wr                             Salve LV antigo acima do PC salvo
invokevirtual21   PC = PC + 1; fetch                       Busque primeiro opcode do novo método
invokevirtual22   LV = TOS; goto Main1                     Ajuste LV para novo quadro
ireturn1          MAR = SP = LV; rd                        Reajuste SP   MAR para obter ponteiro de ligação
ireturn2                                                   Espere por leitura
ireturn3          LV = MAR = MDR; rd                       Ajuste LV para ponteiro de ligação; obtém PC antigo
ireturn4          MAR = LV + 1                             Ajuste MAR para ler LV antigo
ireturn5          PC = MDR; rd; fetch                      Restaure PC; busque próximo opcode
ireturn6          MAR = SP                                 Ajuste MAR para escrever TOS
ireturn7          LV = MDR                                 Restaure LV
ireturn8          MDR = TOS; wr; goto Main1                Salve valor de retorno no topo da pilha original

##  Insight de Hardware
Observe como as operações matemáticas de alto nível (como iadd ou isub) levam apenas 3 ciclos, enquanto o gerenciamento de chamadas de método (invokevirtual) leva mais de 20 ciclos. Isso explica por que, em estruturas de dados recursivas, o custo de "chamar" a função é muitas vezes maior do que a conta que ela faz internamente.

A essa altura a escolha de nomes para a maioria dos registradores na Figura 4.1 já deve ser óbvia: CPP, LV e SP são
usados para conter os ponteiros para o conjunto de constantes, variáveis locais e o topo da pilha, enquanto PC contém o
endereço do próximo byte a ser buscado no fluxo de instruções. MBR é um registrador de 1 byte que contém os bytes da
sequência de instrução, à medida que eles chegam da memória para ser interpretados. TOS e OPC são registradores extras. Sua utilização é descrita a seguir.

Em certas ocasiões, é garantido que cada um desses registradores contenha certo valor, mas cada um pode ser usado como um registrador transitório, se necessário. No início e no final de cada instrução, TOS contém o valor do endereço de memória apontado por SP, a palavra que está no topo da pilha. Esse valor é redundante, uma vez que sempre pode ser lido da memória, mas tê-lo em um registrador muitas vezes economiza uma referência à memória. Para algumas poucas instruções, manter TOS significa mais operações de memória. Por exemplo, a instrução POP joga fora a palavra do topo e, portanto, deve buscar a nova palavra do topo da pilha na memória e passá-la para TOS.

O registrador OPC é um registrador temporário . Ele não tem nenhuma utilização predeterminada. É usado, por exemplo, para salvar o endereço do opcode para uma instrução de desvio enquanto o PC é incrementado para acessar parâmetros. Também é usado como um registrador temporário nas instruções de desvio condicional da IJVM.

Como todos os interpretadores, o microprograma da Figura 4.17 tem um laço principal que busca, decodifica e executa instruções do programa que está sendo interpretado, nesse caso, instruções IJVM. Seu laço principal começa na linha de rótulo Mainl. Inicia com a invariante de que o PC tenha sido previamente carregado com um endereço de um local da memória que contém um opcode. Além do mais, esse opcode já foi trazido para dentro do MBR. Contudo, observe que isso implica que, quando voltarmos a esse local, devemos assegurar que o PC foi atualizado para apontar o próximo opcode a ser interpretado e o próprio byte do opcode já foi trazido para dentro do MBR.

Essa sequência inicial de instruções é executada no início de cada instrução, então, é importante que ela seja a mais
curta possível. Por meio de um projeto muito cuidadoso do hardware e do software da Mic-1, conseguimos reduzir o laço
principal a uma única microinstrução. Uma vez iniciada a máquina, toda vez que essa microinstrução for executada, o
opcode IJVM a executar já está presente no MBR. A tarefa dessa microinstrução é desviar para o microcódigo para executar
a instrução IJVM e também iniciar a busca do byte após o opcode, que pode ser um byte de operando ou o próximo opcode.

Agora podemos revelar a razão real por que cada microinstrução nomeia sua sucessora em vez de executá-las em sequência. Todos os endereços do armazenamento de controle correspondentes a opcodes devem ser reservados para a primeira palavra do interpretador de instrução correspondente. Assim, pela Figura 4.11, vemos que o código que interpreta POP começa em 0x57 e o código que interpreta DUP começa em 0x59. (Como o MAL consegue colocar POP em 0x57? Possivelmente, há um arquivo em algum lugar que o informa.)

Infelizmente, o código para POP tem três microinstruções de comprimento, portanto, se colocado em palavras consecutivas, interferiria com o início de DUP. Uma vez que todos os endereços do armazenamento de controle correspondentes a opcodes são de fato reservados, as microinstruções, exceto a inicial em cada sequência, devem ser colocadas nos espaços entre os endereços reservados. Por essa razão, há muitos saltos para lá e para cá; dessa maneira, ter um microdesvio explícito - microinstrução que desvia - a cada poucas microinstruções para saltar de buraco em buraco seria muito desperdício.

Para ver como o interpretador trabalha, vamos considerar, por exemplo, que MBR contém o valor 0x60, isto é, o opcode para IADD (veja a Figura 4.11). No laço principal de uma só microinstrução realizamos três coisas:

  1. Incrementamos o PC, que fica contendo o endereço do primeiro byte após o opcode.
  2. Iniciamos uma busca do próximo byte para MBR. Mais cedo ou mais tarde, esse byte sempre será necessário, seja como um operando para a instrução IJVM corrente, seja como o próximo opcode (como no caso da instrução IADD, que não tem bytes de operando).
  3. Executamos um desvio multivias até o endereço contido em MBR no início de Mainl. Esse endereço é igual ao valor numérico do opcode que está sendo executado no momento em questão. Ele foi colocado ali pela microinstrução anterior. Não se esqueça de observar que o valor que está sendo buscado nessa microinstrução não desempenha nenhum papel no desvio multivias.

A busca do próximo byte é iniciada aqui, portanto, ele estará disponível no início da terceira microinstrução. Ele pode ser ou não necessário nesse momento, porém, mais cedo ou mais tarde, será necessário. Portanto, em todo caso, iniciar a busca agora não poderá fazer mal algum.

Se acaso os bytes em MBR forem todos zeros, o opcode para uma instrução NOP, a microinstrução seguinte, é a que tem rótulo nop1, buscada da localização 0. Como essa instrução nada faz, ela apenas desvia de volta ao início do laço principal, onde a sequência é repetida, mas com um novo opcode buscado em MBR.

Mais uma vez destacamos que as microinstruções na Figura 4.17 não são consecutivas na memória e que Mainl não está no endereço 0 do armazenamento de controle (porque nop1 tem de estar no endereço 0). Cabe ao microassembler colocar cada microinstrução em um endereço adequado e ligá-las em sequências curtas usando o campo NEXT_ADDRESS. Cada sequência começa no endereço correspondente ao valor numérico do opcode IJVM que interpreta (por exemplo, POP começa em 0x57), mas o resto da sequência pode estar em qualquer lugar do armazenamento de controle, e não necessariamente no endereço consecutivo.
Agora, considere a instrução IJVM IADD. A microinstrução para a qual o laço principal desviou é a que tem o rótulo iaddl. Essa instrução inicia o trabalho específico de IADD:

  1. O TOS já está presente, mas a palavra anterior à que está no topo da pilha deve ser buscada na memória.
  2. O TOS deve ser adicionado à palavra anterior à do topo da pilha que foi buscada na memória.
  3. O resultado, que deve ser passado para a pilha, deve ser armazenado de volta na memória, bem como armazenado no registrador TOS.

Para buscar o operando na memória, é necessário decrementar o ponteiro da pilha e escrevê-lo em MAR. Note que, por conveniência, esse endereço também é o endereço que será usado para a escrita subsequente. Além do mais, visto que tal localização será o novo topo da pilha, esse valor deve ser atribuído a SP. Portanto, uma única operação pode determinar o novo valor de SP e MAR, decrementar SP e escrevê-lo em ambos os registradores.

Essas coisas são realizadas no primeiro ciclo, iaddl, e a operação de leitura é iniciada. Além disso, MPC obtém o valor do campo NEXT_ADDRESS de iaddl, que é o endereço de iadd2, onde quer que ele possa estar. Então, iadd2 é lida do armazenamento de controle. Durante o segundo ciclo, enquanto espera o operando ser lido da memória, copiamos a palavra do topo da pilha do TOS para H, onde ela ficará disponível para a adição quando a leitura for concluída.

No início do terceiro ciclo, iadd3, MDR contém o somando buscado na memória. Neste ciclo, ele é adicionado ao conteúdo de H, e o resultado é armazenado de volta em MDR, bem como em TOS. Também é iniciada uma operação de escrita, armazenando a nova palavra de topo de pilha de volta à memória. Neste ciclo, o goto tem o efeito de atribuir o endereço de Mainl ao MPC, o que nos leva de volta ao ponto de partida para a execução da próxima instrução.

Se o opcode IJVM subsequente, agora contido em MBR, for 0x64 (ISUB), quase exatamente a mesma sequência de eventos ocorre de novo. Após a execução de Mainl, o controle é transferido para a microinstrução em 0x64 (isubl). Essa microinstrução é seguida por isub2 e isub3, e então novamente Mainl. A única diferença entre essa sequência e a anterior é que em isub3, o conteúdo de H é subtraído de MDR em vez de somado a ele.

A interpretação de IAND é quase idêntica à de IADD e ISUB, exceto que as duas palavras do topo da pilha passam por uma operação AND bit a bit em vez de serem somadas ou subtraídas. Algo semelhante acontece para IOR.

Se o opcode ÍJVC for DUP, POP ou SWAP, a pilha deve ser ajustada. A instrução DUP apenas duplica a palavra do topo da pilha. Uma vez que o valor dessa palavra já está armazenado em TOS, a operação é tão simples quanto incrementar SP para apontar para a nova localização e armazenar TOS naquela localização. A instrução POP é quase tão simples, apenas decrementa SP para descartar a palavra que está no topo da pilha. Contudo, para manter a palavra do topo em TOS, agora é necessário ler a nova palavra do topo na memória e escrevê-la em TOS. Por fim, a instrução SWAP envolve permutar entre si os valores em duas localizações de memória: as duas palavras do topo da pilha. A operação é facilitada de certa forma pelo fato de o TOS já conter um desses valores, portanto, ele não precisa ser lido da memória. Essa instrução será discutida com mais detalhes mais adiante.

A instrução BIPUSH é um pouco mais complicada porque o opcode é seguido por um único byte, conforme mostra a Figura 4.18. O byte deve ser interpretado como um inteiro com sinal. Esse byte, que já foi buscado para MBR em Mainl, deve ser estendido em sinal para 32 bits e passado para o topo da pilha. Portanto, essa sequência deve estender em sinal o byte em MBR para 32 bits e copiá-lo para MDR. Por fim, SP é incrementado e copiado para MAR, permitindo que o operando seja escrito para o topo da pilha. No caminho, esse operando também deve ser copiado para o TOS. Além disso, antes de retornar para o programa principal, note que o PC deve ser incrementado de modo que o próximo opcode estará disponível em Mainl.

Figura 4.18 Formato da instrução BIPUSH.
          +--------------+----------------+
          |    BIPUSH    |     BYTE       |
          |    (0x10)    |                |        
          +--------------+----------------+
Em seguida, considere a instrução ILOAD. Ela também tem um byte após o opcode, como ilustra a Figura 4.19(a), mas esse byte é um índice (sem sinal) para identificar a palavra no espaço de variáveis locais que será passada para a pilha. Uma vez que há somente 1 byte, apenas 28 = 256 palavras podem ser distinguidas, a saber, as primeiras 256 palavras no espaço de variáveis locais. A instrução ILOAD requer uma leitura (para obter a palavra), bem como uma escrita (para passá-la para o topo da pilha). Para determinar o endereço para leitura, entretanto, o deslocamento, contido em MBR, deve ser adicionado ao conteúdo de LV. Uma vez que ambos, MBR e LV, só podem ser acessados pelo barramento B, LV primeiro é copiado para H (em iloadl), então MBR é adicionado. O resultado dessa adição é copiado para MAR e uma leitura é iniciada (em iload2)

Figura 4.19 (a) ILOAD com um índice de 1 byte. (b) WIDE ILOAD com um índice de 2 bytes.

+----------+----------+      +----------+----------+-----------+-----------+
|  ILOAD   | INDEX    |      |   WIDE   |  ILOAD   |  INDEX    |   INDEX   |
|  (0x54)  |          |      |  (0xC4)  |  (0x15)  |  BYTE 1   |   BYTE 2  |
+----------+----------+      +----------+----------+-----------+-----------+
          (a)                                     (b)

ILOAD vs. WIDE ILOAD (Figura 4.19)
Aqui vemos como o PC (Program Counter) e a memória se organizam para cada caso:
(a) ILOAD (Normal)                 (b) WIDE ILOAD (Expandido)
      ------------------                 -------------------------
      Endereço   Conteúdo                Endereço   Conteúdo
     +----------+----------+            +----------+----------+
  PC |   0x50   |   0x15   | (ILOAD)    |   0x50   |   0xC4   | (WIDE)
     +----------+----------+            +----------+----------+
     |   0x51   |  index   | (1 byte)   |   0x51   |   0x15   | (ILOAD)
     +----------+----------+            +----------+----------+
     |   0x52   | (Próxima)|            |   0x52   |  byte 1  | (index
     +----------+----------+            +----------+----------+  alto)
                                        |   0x53   |  byte 2  | (index
                                        +----------+----------+  baixo)
                                        |   0x54   | (Próxima)|
                                        +----------+----------+
Organização de Hardware: O Impacto do WIDE (Seu Padrão)
O uso do prefixo WIDE altera o fluxo de busca da Unidade de Controle:

Processamento                                                                       Armazenamento

ULA (Cálculos)                                                                      Registradores
:----------------------------------------------------------------------------------:-----------------------------------------------------------------
ULA: No caso (b), realiza o shift e a soma para montar o índice de 16 bits.         PC: Incrementado 2 vezes no caso (a) e 4 vezes no caso (b).
Deslocador: Essencial para fazer o H = MBR << 8 no WIDE.                            H: Armazena temporariamente o primeiro byte do índice de 16 bits.

                                                                                    BARRAMENTO INTERNO
UC (Controle)                                                                       RI (Instrução Atual)
"UC: Ao ler 0xC4, ela desvia para um microprograma que modifica a próxima busca.    MBR: Recebe os bytes do índice um por um da memória.
REM (Endereços) ---> [B. Endereços]                                                 Decodificador
"MAR: Aponta para LV + index. No caso (b), o index pode ser muito maior.            Decodificador: Identifica o prefixo 0xC4 e prepara a lógica estendida.
CI (Próxima Inst.)                                                                  RDM (Dados) <-> [B. Dados]
PC: Controla o avanço byte a byte na área de método.                                MDR: Traz o conteúdo da variável local após o cálculo do índice.
CLOCK (Sincronismo)                                                                 MEMÓRIA PRINCIPAL (RAM)
CLOCK: O WIDE ILOAD leva mais ciclos de clock para ser concluído.                   RAM: Armazena o código bytecode de tamanhos variáveis.

## Insight para seus projetos

Por que o WIDE existe?

  1. Economia de Espaço: 99% das vezes, suas funções de Torres de Hanói terão poucas variáveis locais. Usar 1 byte para o índice economiza memória.

  2. Flexibilidade: Se você criar um algoritmo extremamente complexo com mais de 256 variáveis locais, o compilador insere o 0xC4 (WIDE) (opcode de instrução que significa WIDE) automaticamente para que a CPU consiga endereçar até 65.536 variáveis.

É um excelente exemplo de como o hardware (Mic-1) se adapta via Microprogramação para suportar extensões da linguagem sem precisar mudar os circuitos físicos.

Contudo, a utilização de MBR como um índice é um pouco diferente do que em BIPUSH, onde ele era estendido em sinal. No caso de um índice, o deslocamento é sempre positivo, portanto, o deslocamento do byte deve ser interpretado como um inteiro sem sinal, diferente de BIPUSH, onde era interpretado como um inteiro de 8 bits com sinal. A interface de MBR ao barramento B é projetada para possibilitar ambas as operações. No caso de BIPUSH (inteiro de 8 bits com sinal), a operação adequada é a extensão de sinal, isto é, o bit da extrema esquerda no MBR de 1 byte é copiado para os 24 bits superiores no barramento B. No caso de ILOAD (inteiro de 8 bits sem sinal), a operação adequada é preencher com zeros. Nesse caso, os 24 bits superiores do barramento B são simplesmente fornecidos com zeros. Essas duas operações são distinguidas por sinais separados que indicam qual operação deve ser executada (veja a Figura 4.6). No microcódigo, isso é indicado por MBR (estendido em sinal, como em BIPUSH 3) ou MBRU (sem sinal, como em iload2).

Enquanto está esperando que a memória forneça o operando (em iload3), SP é incrementado para conter o valor para armazenar o resultado, o novo topo da pilha. Esse valor também é copiado para MAR em preparação para escrever o operando para o topo. Mais uma vez, o PC deve ser incrementado para buscar o próximo opcode (em iload4). Por fim, MDR é copiado para TOS para refletir o novo topo da pilha (em iload5).

ISTORE é a operação inversa de ILOAD, isto é, uma palavra é retirada do topo da pilha e armazenada na localização especificada pela soma de LV e do índice contido na instrução. Ela usa o mesmo formato de ILOAD, mostrado na Figura 4.19(a), exceto que o opcode é 0x36 em vez de 0x15. Essa instrução é um pouco diferente do que poderiamos esperar porque a palavra do topo da pilha já é conhecida (em TOS), portanto, ela pode ser armazenada de imediato. Contudo, a nova palavra do topo da pilha deve ser buscada. Assim, são necessárias uma escrita, bem como uma leitura, mas elas podem ser realizadas em qualquer ordem (ou até em paralelo, se isso fosse possível).

Ambas, ILOAD e ISTORE, são restritas, já que só podem acessar as primeiras 256 variáveis locais. Ao passo que para grande parte dos programas esse espaço de variáveis locais seja mais do que suficiente, claro que é necessário poder acessar uma variável onde quer que ela esteja localizada no espaço de variáveis locais. Para fazer isso, a IJVM usa o mesmo mecanismo empregado na JVM: um opcode especial WIDE (largo), conhecido como byte de prefixo, seguido pelo
opcode ILOAD ou ISTORE. Quando essa sequência ocorre, as definições de ILOAD e ISTORE são modificadas, com um índice de 16 bits após o opcode, em vez de um índice de 8 bits, como mostra a Figura 4.19(b).

WIDE é decodificada do modo usual, levando um desvio para widel que manipula o opcode WIDE. Embora o opcode para alargar (ou ampliar - widen) já esteja disponível em MBR, widel busca o primeiro byte após o opcode, porque a lógica do microprograma sempre espera que ele esteja ali. Então, é feito um segundo desvio multivias em wide2, agora usando o byte após a WIDE para despachar. Contudo, já que WIDE ILOAD requer microcódigo diferente do de ILOAD, e WIDE ISTORE requer microcódigo diferente do de ISTORE etc., o segundo desvio multivias não pode só usar o opcode como endereço de destino, do mesmo modo que faz Mainl.

Em vez disso, wide2 efetua uma operação OR de 0x100 com o opcode enquanto o coloca em MPC. O resultado é que a interpretação de WIDE ILOAD começa em 0x115 (em vez de 0x15), a interpretação de WIDE ISTORE começa em 0x136 (e não 0x36) e assim por diante. Desse modo, todo opcode WIDE começa em um endereço 256 palavras mais alto, isto é, 0x100, no armazenamento de controle que o opcode regular correspondente. A sequência inicial de microinstruções para ambas,
ILOAD e WIDE ILOAD, é mostrada na Figura 4.20.

Uma vez alcançado o código para implementar WIDE ILOAD (0x115), a diferença entre ele e o ILOAD normal é apenas que o índice deve ser construído concatenando 2 bytes de índice em vez de simplesmente estender em sinal um byte único. A concatenação e subsequente adição devem ser efetuadas em etapas, primeiro copiando INDEX BYTE 1 em H deslocado 8 bits para a esquerda. Visto que o índice é um inteiro sem sinal, o MBR é estendido em zeros usando MBRU. Agora, o segundo byte do índice é adicionado (a operação de adição é idêntica à concatenação, já que o byte de ordem baixa de H agora é zero, garantindo que não haverá vai-um entre os bytes) e, de novo, o resultado é armazenado em H. Daí em diante, a operação pode seguir exatamente como se fosse uma ILOAD padrão. Em vez de duplicar as instruções finais de ILOAD (iload3 a iload5), apenas desviamos de wide_iload4 para iload3. Todavia, note que PC deve ser incrementado duas vezes durante a execução da instrução de modo que passe a apontar para o próximo opcode. A instrução ILOAD o incrementa uma vez; a sequência WIDE_ILOAD também o incrementa uma vez.

Fluxo de Microinstruções (Figura 4.20)
O diagrama mostra como o WIDE "pega carona" no código do ILOAD comum após processar o byte extra:

ENDEREÇOS DO CONTROL STORE (Exemplos)
     +----------------------------------------+
     |  (Início ILOAD)                        |
0x15 |  iload1:  MAR = LV + MBRU; rd          | <--- Ciclo 1 (Normal)
     |  iload2:  MAR = SP = SP + 1            | <--- Ciclo 2 (Normal)
0x17 |  iload3:  MDR = TOS; wr; goto Main1    | <--- PONTO DE RECONTRO
     +----------------------------------------+          ^
                                                         |
     +----------------------------------------+          |
     |  (Início WIDE)                         |          |
0xC4 |  wide1:   PC = PC + 1; fetch           |          |
     |  wide2:   (Decodifica próxima inst.)    |          |
     |  ...                                   |          |
0xA2 |  wide_iload1: H = MBRU << 8            |          |
     |  wide_iload2: H = H OR MBRU            |          |
     |  wide_iload3: MAR = LV + H; rd         |          |
     |  wide_iload4: goto iload3 -------------|----------+
     +----------------------------------------+
Essa transição entre o ILOAD comum e o WIDE ILOAD é um exemplo perfeito de reutilização de microcódigo. Na Mic-1, o espaço no Control Store (512 palavras) é precioso. Por isso, em vez de escrever um programa inteiro novo para o WIDE, os engenheiros fazem com que o final da sequência do WIDE "salte" para o meio da sequência do ILOAD normal.

No seu diretório estruturas_de_dados, pense nisso como uma função que prepara os dados e depois chama uma sub-rotina já existente para finalizar o trabalho.


Fluxo de Controle no Control Store (Figura 4.20)
O diagrama mostra como o MPC (Micro Program Counter) navega pelos endereços hexadecimais para executar as microinstruções.
ENDEREÇO (HEX)      ARMAZENAMENTO DE CONTROLE         ORDEM DE EXECUÇÃO
+--------------+    +---------------------------+    +-------------------+
|    0x00      |    | Main1: PC = PC + 1; fetch | <---+ (Ciclo de Busca)  |
+--------------+    +---------------------------+    |                   |
|     ...      |    |           ...             |    |                   |
+--------------+    +---------------------------+    |   [ CAMINHO ILOAD ]
|    0x15      |    | iload1: MAR = LV + MBRU;rd| <---+-- (1) Executa     |
|              |    | iload2: MAR = SP = SP + 1 |     |   (2) Executa     |
|              |    | iload3: MDR = TOS; wr...  |     |   (3) Finaliza    |
+--------------+    +---------------------------+    |                   |
|     ...      |    |           ...             |    |                   |
+--------------+    +---------------------------+    |   [ CAMINHO WIDE ] |
|    0xC4      |    | wide1:  PC = PC + 1; fetch| <---+-- (1) Identifica  |
|              |    | wide2:  goto (MBR)        |     |   (2) Decodifica  |
+--------------+    +---------------------------+    |                   |
|    0x100     |    | Main1 (Cópia ou Retorno)  |     |                   |
+--------------+    +---------------------------+    |                   |
|    0x115     |    | wide_iload1: H = MBRU << 8| <---+-- (1) Monta 16bit |
|              |    | wide_iload2: H = H OR MBRU|     |   (2) Completa    |
|              |    | wide_iload3: MAR = LV+H;rd|     |   (3) Busca Dado  |
|              |    | wide_iload4: goto iload3 -|-----+-- (4) Reutiliza!  |
+--------------+    +---------------------------+
|    0x1FF     |    | (Limite do Control Store) |
+--------------+    +---------------------------+
A mesma situação ocorre para WIDE_STORE: após a execução das primeiras quatro microinstruções (wide_istore1 até wide_istore4), a sequência é a mesma de ISTORE após as duas primeiras instruções, portanto, wide_istore4 desvia para
istore3.

Nosso próximo exemplo é uma instrução LDC_W. Esse opcode tem duas diferenças em relação a ILOAD. A primeira é que ele tem um deslocamento sem sinal de 16 bits (como a versão larga, ou ampliada, de ILOAD). A segunda, ele é indexado a partir de CPP em vez de LV, pois sua função é ler do conjunto de constantes em vez do quadro de variáveis locais. (Na verdade, há uma forma curta de LDC_W (LDC), mas não incluímos em 1JVM, já que a forma longa incorpora todas as possíveis variações da forma curta, mas toma 3 bytes em vez de 2.)

A instrução IINC é a única da IJVM, exceto a instrução ISTORE, que pode modificar uma variável local. Ela o faz incluindo dois operandos, cada um de 1 byte de comprimento, como apresenta a Figura 4.21.

Organização de Hardware: Fluxo de Endereços (Seu Padrão)
Veja como os componentes que você salvou gerenciam esse "trânsito" de endereços:

Processamento                                                                  Armazenamento
ULA (Cálculos)                                                                 Registradores
:------------------------------------------------------------------------------:--------------------------------------------------------------
ULA: No endereço 0x115, combina os dois bytes do índice.                       MPC: O ""CI"" do microprograma. Salta de 0x00 para 0x15 ou 0xC4."
JAM: Decide o próximo endereço do MPC baseado no Opcode.                       H: Temporário para o wide_iload no endereço 0x115.

                                                                               BARRAMENTO INTERNO
UC (Controle),RI (Instrução Atual)
UC: Lê o endereço 0x1FF como o limite da sua memória de controle.              MIR: No endereço 0x115, contém a instrução H = MBRU << 8.
REM (Endereços) ---> [B. Endereços]                                            Decodificador
MAR: Aponta para a RAM física (fora do Control Store).                         Decodificador: Transforma o byte 0x15 no endereço de microcódigo 0x15.
CI (Próxima Inst.)                                                             RDM (Dados) <-> [B. Dados]
MPC: É o ponteiro que percorre os endereços 0x00 a 0x1FF.                      Control Store: Memória interna que guarda os 36 bits de cada microinstrução.
CLOCK (Sincronismo)                                                            MEMÓRIA PRINCIPAL (RAM)
CLOCK: Sincroniza o salto do wide_iload4 (0x115) para o iload3 (0x15).         RAM: Alheia a este processo; ela apenas espera o sinal de rd ou wr.

## Insight para seus projetos

   1. Endereçamento Espelhado: Note que o endereço do microcódigo do ILOAD é 0x15, exatamente o mesmo valor hexadecimal do seu Opcode. Isso é feito para que o hardware não precise de uma tabela de busca complexa; ele apenas copia o Opcode para o MPC.

   2. O Salto do WIDE: Quando o processador lê 0xC4, ele vai para o endereço 0xC4 no Control Store. Lá, o microcódigo o instrui a ler o próximo byte (0x15) e somar um bit de alta ordem (gerando o endereço 0x115).

   3. Reuso: O endereço 0x115 termina com um goto iload3. Isso economiza memória interna ao não repetir o código de finalização.

Nas Torres de Hanói, cada comando que você dá passa por esse "labirinto" de endereços hexadecimais no Control Store antes de mover um único bit na RAM.

Figura 4.21 A instrução IINC tem dois campos de operando diferentes.
            
              +-----------+-------------+-------------+
              |    IINC   |    INDEX    |    CONST    |
              |   (0x84)  |             |             |
              +-----------+-------------+-------------+


A instrução IINC usa INDEX para especificar o deslocamento em relação ao início do quadro de variáveis locais. Ela lê aquela variável, incrementando-a por CONST, um valor contido na instrução, e volta a armazená-la no mesmo local. Note que essa instrução pode incrementar por uma quantidade negativa, isto é, CONST é uma constante de 8 bits com sinal, na faixa -128 a +127. A JVM completa inclui uma versão ampliada da IINC, onde cada operando tem 2 bytes de
comprimento.

Agora, chegamos à primeira instrução de desvio da IJVM: GOTO. A função exclusiva dessa instrução é alterar o valor de PC, de modo que a próxima instrução IJVM executada seja a que está no endereço calculado adicionando o deslocamento de 16 bits (com sinal) ao endereço opcode do desvio. Uma complicação que surge nesse caso é que o deslocamento é relativo ao valor que o PC tinha no início da decodificação da instrução, e não ao valor que ele tem depois que os 2 bytes de deslocamento foram buscados. Para esclarecer esse ponto, na Figura 4.22(a) vemos a situação no início de Main1. O opcode já está em MBR, mas o PC ainda não foi incrementado. Na Figura 4.22(b), vemos a situação no início de goto1. A essa altura, o PC já foi incrementado, mas o primeiro byte do deslocamento ainda não foi buscado para MBR. Uma microinstrução depois, temos a Figura 4.22(c), na qual o antigo PC, que aponta para o opcode, foi salvo em OPC e o primeiro byte do deslocamento está em MBR. Esse valor é necessário porque o deslocamento da instrução GOTO da IJVM é relativa a ele e não ao valor corrente de PC. Na verdade, essa é a razão primordial por que precisamos do registrador.

Figura 4.22 Situação no início de vários microinstruções. (o) Mainl. (b) gotol. (c) goto2. (d) goto3 (e) goto4.

Esta figura é fundamental para entender o salto (branching) na Mic-1. Ela mostra como o processador "monta" um endereço de 16 bits a partir de dois bytes individuais vindos da memória RAM. Para o seu algoritmo das Torres de Hanói, esse é o processo que permite ao GOTO ou IF pular para a linha correta do código.
Montagem do Offset no GOTO (Figura 4.22)
O diagrama abaixo ilustra os 5 estados (a até e) da memória e dos registradores enquanto o GOTO (0xA7) é processado:
ESTADO:          (a) Main1       (b) goto1       (c) goto2       (d) goto3       (e) goto4
               +-----------+   +-----------+   +-----------+   +-----------+   +-----------+
MEMÓRIA:       |           |   |           |   |           |   |           |   |           |
 n+3           |  (Próx)   |   |  (Próx)   |   |  (Próx)   |   |  (Próx)   |   |  (Próx)   |
               +-----------+   +-----------+   +-----------+   +-----------+   +-----------+
 n+2 (OFF 2)   |  Byte 2   |   |  Byte 2   |   |  Byte 2   |   |  Byte 2   |   |  Byte 2   |
               +-----------+   +-----------+   +-----------+   +-----------+   +-----------+
 n+1 (OFF 1)   |  Byte 1   |   |  Byte 1   |   |  Byte 1   |   |  Byte 1   |   |  Byte 1   |
               +-----------+   +-----------+   +-----------+   +-----------+   +-----------+
 n             | GOTO(0xA7)|   | GOTO(0xA7)|   | GOTO(0xA7)|   | GOTO(0xA7)|   | GOTO(0xA7)|
               +-----------+   +-----------+   +-----------+   +-----------+   +-----------+

REGISTRADORES:
   PC -------->      n             n+1             n+2             n+3             n+3
   OPC ------->      -              n               n               n               n
   MBR ------->    0xA7           OFF 1           OFF 1           OFF 2           OFF 2
   H ---------->      -              -           OFF 1<<8        OFF 1<<8        OFF 1<<8

Organização de Hardware: O Ciclo do Salto (Seu Padrão)
Veja como os componentes que você salvou trabalham para realizar essa montagem:

Processamento                                                                 Armazenamento
ULA (Cálculos)                                                                Registradores
:-----------------------------------------------------------------------------:-------------------------------------
ULA: No estado (c), faz o shift H = MBR << 8.                                 PC: Incrementa a cada byte lido (n, n+1, n+2).
ULA: No estado (e), faz PC = OPC + H OR MBR.                                  OPC: Salva o n original para servir de base ao salto.

                                                                              BARRAMENTO INTERNO
UC (Controle)                                                                 RI (Instrução Atual)
UC: Coordena os 4 ciclos de microcódigo (goto1 a goto4).                      H: Guarda o Byte 1 deslocado enquanto o Byte 2 chega.
REM (Endereços) ---> [B. Endereços]                                           Decodificador
MAR: Aponta para os endereços n+1 e n+2 na RAM.                               Decodificador: Identifica o 0xA7 e inicia a sequência.
CI (Próxima Inst.)                                                            RDM (Dados) <-> [B. Dados]
PC: Após o estado (e), ele assume o novo destino do salto.                    MBR: Recebe os bytes um por um do barramento de dados.
CLOCK (Sincronismo)                                                           MEMÓRIA PRINCIPAL (RAM)
CLOCK: Garante a estabilidade do H antes do OR final.                         RAM: Fornece os bytes do offset para o processador.

## Insight para seus projetos

Por que o OPC é usado aqui?

   1.  Base do Salto: O GOTO na IJVM é relativo. Isso significa que ele diz "pule 10 bytes para frente a partir de onde a instrução começou".

   2.  Preservação: No estado (b), o hardware copia o PC (que vale n) para o OPC. Assim, mesmo que o PC continue andando para ler os bytes do offset, a CPU "lembra" onde a instrução GOTO estava originalmente.

   3.  Cálculo Final: No estado (e), a ULA soma o endereço base (OPC) com o deslocamento total (H OR MBR).

Nas Torres de Hanói, isso é o que acontece no final de cada bloco de IF/ELSE para desviar a ex

A microinstrução em goto2 inicia a busca do segundo byte de deslocamento, o que leva à Figura 4.22(d) no início de goto3. Depois que o primeiro byte do deslocamento foi deslocado 8 bits para a esquerda e copiado para H, chegamos em goto4 e à Figura 4.22(e). Agora, temos o primeiro byte de deslocamento desviado para a esquerda em H, o segundo byte de deslocamento em MBR e a base em OPC. Construindo o deslocamento de 16 bits completo em H e então o adicionando à base, obtemos o novo endereço para colocar em PC, em goto5. Não se esqueça de observar que usamos MBRU em goto4 em vez de MBR porque não queremos extensão de sinal do segundo byte. Na verdade, o deslocamento de 16 bits é construído efetuando uma operação OR com as duas metades. Por fim, temos de buscar o próximo opcode antes de voltar a Main1 porque o código que ali está espera o próximo opcode em MBR. O último ciclo, goto6, é necessário porque os dados da memória podem ser buscados a tempo de aparecer em MBR durante Main1.

Os deslocamentos usados na instrução goto da IJVM são valores de 16 bits com sinal, com um mínimo de -32768 e um máximo de +32767. Isso significa que desvios para qualquer lado para rótulos mais distantes do que esses valores não são possíveis. Essa propriedade pode ser considerada um bug ou uma característica na IJVM (e também na JVM). A turma do bug diria que a definição da JVM não deveria restringir seu estilo de programação. A turma da qualidade diria que o trabalho de muitos programadores sofreria uma melhoria radical se eles tivessem pesadelos com a temida mensagem do compilador:
  
  Program is too big and hairy. You must rewrite it. Compilation aborted.
  (Programa muito grande e confuso. Você precisa reescrevê-lo. Compilação abortada.)

Infelizmente (de nosso ponto de vista), essa mensagem só aparece quando uma cláusula then ou else passa de 32 KB, o que normalmente representa 50 páginas de Java.

Agora, considere as três instruções IJVM de desvio condicional: IFLT, IFEQ e IF_ICMPEQ. As duas primeiras retiram a palavra que está no topo da pilha, desviando se a palavra for menor do que zero ou igual a zero, respectivamente. IF_ICMPEQ retira as duas palavras do topo da pilha e desvia se, e somente se, elas forem iguais. Em todos os três casos, é necessário ler uma nova palavra do topo da pilha para armazenar no TOS.

O controle para essas três instruções é semelhante: o operando ou operandos são primeiro colocados em registradores, depois o novo valor do topo de pilha é lido para o TOS e, por fim, são realizados o teste e o desvio. Considere IFLT em primeiro lugar. A palavra a testar já está em TOS, porém, como IFLT retira uma palavra da pilha, o novo topo tem de ser lido para armazenar em TOS. Essa leitura é iniciada em iflt1. Em iflt2, a palavra a ser testada é salva em OPC por enquanto, portanto, o novo valor pode ser colocado em TOS dentro em pouco sem perder o valor corrente. Em iflt3, a nova palavra do topo da pilha está disponível em MDR, portanto, é copiada para TOS. Por fim, em iflt4, a palavra a ser testada, agora salva em OPC, é passada pela ULA sem ser armazenada e o bit N é amostrado e testado. Essa microinstrução também contém um desvio, que escolhe T se o teste foi bem-sucedido e F, caso contrário.

Se bem-sucedido, o restante da operação é, em essência, a mesma que no início da instrução GOTO, e a sequên­cia simplesmente continua no meio da sequência GOTO, com goto2. Se malsucedida, é necessária uma sequência curta (F, F2 e F3) para pular o resto da instrução (o deslocamento) antes de voltar a Main1 para continuar com a instrução seguinte.

O código em ifeq2 e ifeq3 segue a mesma lógica, só que usando o bit Z em vez do bit N. Em ambos os casos, cabe ao assembler de MAL reconhecer que os endereços T e F são especiais e garantir que seus endereços sejam colocados em endereços de armazenamento de controle cuja diferença seja apenas o bit da extrema esquerda.

A lógica para IF_ICMPEQ é bastante semelhante à IFEQ, exceto que nesse caso precisamos ler também o segundo operando. Esse operando é armazenado em H em if_icmpeq3, onde a leitura da nova palavra do topo da pilha é iniciada. Mais uma vez, a palavra do topo da pilha corrente é salva em OPC e a nova é instalada em TOS. Por fim, o teste em if_icmpeq6 é semelhante a ifeq4.

Agora, consideramos a execução de INVOKEVIRTUAL e IRETURN, as instruções para invocar um procedimento de chamada e retorno, como descrito na Seção 4.2.3. INVOKEVIRTUAL é uma sequência de 22 microinstruções e é a mais complexa instrução realizada em IJVM. Sua operação foi mostrada na Figura 4.12. A instrução usa seu deslocamento de 16 bits para determinar o endereço do método a ser invocado. Em nossa implementação, esse deslocamento é simplesmente um deslocamento no conjunto de constantes. Sua localização nesse conjunto aponta o método a ser invocado. Contudo, lembre-se de que os primeiros 4 bytes de cada método não são instruções, e sim dois ponteiros de 16 bits. O primeiro dá o número de palavras de parâmetro – incluindo OBJREF (veja a Figura 4.12). O segundo dá o
tamanho da área de variáveis locais em palavras. Esses campos são buscados por meio da porta de 8 bits e montados exatamente como se fossem deslocamentos de 16 bits dentro de uma instrução.

Então, a informação de enlace necessária para restaurar a máquina a seu estado anterior – o endereço do início da área de variáveis antiga e o PC antigo – é armazenada imediatamente acima da área de variáveis locais recém-criada e abaixo da nova pilha. Por fim, o opcode da próxima instrução é buscado e o PC é incrementado antes de retornar a Main1 para iniciar a próxima instrução.

IRETURN é uma instrução simples que não contém operandos. Ela apenas usa o endereço armazenado na primeira palavra da área de variáveis locais para recuperar a informação de ligação, então, restaura SP, LV e PC a seus valores anteriores e copia o valor de retorno do topo da pilha corrente para o topo da pilha original, conforme ilustra a Figura 4.13.

## 4.4 Projeto do nível de microarquitetura
Como quase tudo na ciência da computação, o projeto da microarquitetura está repleto de compromissos. Computadores têm muitas características desejáveis, entre elas velocidade, custo, confiabilidade, facilidade de utilização, requisitos de energia e tamanho físico. Contudo, um compromisso comanda as decisões mais impor-
tantes que os projetistas de CPU devem tomar: velocidade versus custo. Nesta seção, estudaremos esse assunto detalhadamente, para ver o que pode ser permutado pelo que, que grau de desempenho pode ser alcançado e a que preço em hardware e complexidade.

## 4.4.1 Velocidade versus custo
Embora a tecnologia mais rápida tenha resultado no maior dos aumentos de velocidade em qualquer perío­do de tempo considerado, esse assunto não se enquadra no escopo deste livro. Melhorias de velocidade graças à organização, embora menos espetaculares do que as propiciadas por circuitos mais rápidos, ainda assim são
impressionantes. Velocidade pode ser medida de várias maneiras, mas dadas uma tecnologia de circuitos e uma ISA, há três abordagens básicas para aumentar a velocidade de execução:

  1. Reduzir o número de ciclos de clock necessários para executar uma instrução.
  2. Simplificar a organização de modo que o ciclo de clock possa ser mais curto.
  3. Sobrepor a execução de instruções.

As duas primeiras são óbvias, mas há uma surpreendente variedade de oportunidades de projeto que pode afetar drasticamente o número de ciclos de clock, o período de clock, ou – em grande parte das vezes – ambos. Nesta seção, daremos um exemplo de como a codificação e a decodificação de uma operação podem afetar o ciclo de clock.

O número de ciclos de clock necessários para executar um conjunto de operações é conhecido como comprimento do caminho. Às vezes, o comprimento do caminho pode ser encurtado adicionando-se hardware especializado. Por exemplo, adicionando um incrementador – conceitualmente, um somador com um lado ligado de modo permanente a “some 1” (add 1) – ao PC, não precisamos mais usar a ULA para fazer avançar o PC, eliminando ciclos. O preço a pagar é mais hardware. Todavia, essa capacidade não ajuda tanto como seria de esperar. Na maioria das instruções, os ciclos consumidos para incrementar o PC também são ciclos em que uma operação de leitura está sendo executada. Em todo caso, a instrução seguinte não pode ser executada mais cedo porque ela depende dos dados que vêm da memória.

Reduzir o número de ciclos de instrução necessários para buscar instruções requer mais do que apenas um circuito adicional para incrementar o PC. Para acelerar a busca de instrução em qualquer grau significativo, a terceira técnica – sobreposição de execução – deve ser explorada. Separar o circuito de busca de instruções – a porta de memória de 8 bits e os registradores MBR e PC – é mais efetivo se, em termos funcionais, a unidade for montada independentemente do caminho de dados principal. Desse modo, ela pode buscar o próximo opcode ou operando por conta própria, talvez até mesmo executando fora de sincronia em relação ao restante da CPU e buscando uma ou mais instruções com antecedência.

Uma das fases que mais consome o tempo da execução de muitas das instruções é buscar um deslocamento de 2 bytes, estendê-lo adequadamente e acumular no registrador H em preparação para uma adição, por exemplo, em um desvio para PC ± n bytes. Uma solução potencial – construir uma porta de memória de 16 bits de largura – complica muito a operação porque, na verdade, a memória tem 32 bits de largura. Os 16 bits necessários podem se espalhar por fronteiras de palavras, de modo que até mesmo uma única leitura de 32 bits não buscará necessariamente ambos os bytes necessários.

Sobrepor a execução de instruções é, de longe, o mais interessante e oferece a melhor oportunidade para drásticos aumentos de velocidade. A simples sobreposição da busca e execução de instruções dá um resultado surpreendentemente efetivo. Entretanto, técnicas mais sofisticadas avançam muito mais, sobrepondo a execução de muitas instruções. Na verdade, essa ideia está no coração do projeto de computadores modernos. Mais adiante, discutiremos algumas das técnicas básicas para sobrepor a execução de instruções e apresentaremos o motivo para as mais sofisticadas.

Velocidade é apenas uma metade do quadro; custo é a outra. O custo pode ser medido de vários modos, mas uma definição precisa é problemática. Algumas medidas são muito simples, tal como uma contagem do número de componentes, o que era válido em particular na época em que os processadores eram compostos de componentes discretos, que eram comprados e montados. Hoje, o processador inteiro está contido em um único chip, mas chips maiores e mais complexos são muito mais caros do que os menores, mais simples. Componentes individuais – por exemplo, transistores, portas ou unidades funcionais – podem ser contados, mas quase sempre o número resultante não é tão importante quanto a quantidade de área requerida no circuito integrado. Quanto mais área for requerida para as funções incluídas, maior será o chip, e o custo de fabricação deste cresce com rapidez muito maior do que sua área. Por essa razão, projetistas costumam falar de custo em termos utilizados na área imobiliária, isto é, a área exigida por um circuito (imagino que seja medida em pico-hectares).

Um dos circuitos mais exaustivamente estudados na história é o somador binário. Há milhares de projetos e os mais rápidos são muito mais velozes do que os mais lentos – e também muito mais complexos. O projetista de sistemas tem de decidir se a maior velocidade vale o preço do espaço.

Somadores não são os únicos componentes que têm muitas opções. Praticamente qualquer componente do sistema pode ser projetado para executar de modo mais rápido ou mais lento, com um diferencial de custo. O desafio para o projetista é identificar os componentes que mais podem melhorar o sistema e então aumentar a velocidade deles. O interessante é que muitos componentes individuais podem ser substituídos por um muito mais veloz e causar pouco ou nenhum efeito sobre a velocidade. Nas seções seguintes, examinaremos algumas das questões de projeto e os compromissos correspondentes.

Um dos fatores fundamentais para determinar a velocidade em que um clock pode executar é a quantidade de trabalho que deve ser realizada em cada ciclo de clock. É óbvio que, quanto mais trabalho a ser realizado, mais longo será o ciclo. Claro que não é assim tão simples, porque o hardware é muito bom para fazer coisas em paralelo. Portanto, na verdade, o que determina o comprimento do ciclo de clock é a sequência de operações que devem ser executadas em série em um único ciclo.

Um aspecto que pode ser controlado é a quantidade de decodificação que deve ser realizada. Lembre-se, por exemplo, de que na Figura 4.6 vimos que, embora qualquer um de nove registradores pudesse ser lido para a ULA a partir do barramento B, precisávamos de apenas 4 bits na palavra de microinstrução para especificar qual registrador devia ser selecionado. Infelizmente, essas economias têm um preço. O circuito de decodificação agrega atraso ao caminho crítico, e isso significa que qualquer registrador que habilite seus dados para o barramento B receberá o comando um pouquinho mais tarde e obterá seus dados no barramento um pouquinho mais tarde. Isso provoca um efeito em cascata, com a ULA recebendo suas entradas um pouco mais tarde e produzindo seus resultados um pouco mais tarde. Por fim, o resultado estará disponível no barramento C para ser escrito nos registradores também um pouco mais tarde. Como esse atraso muitas vezes é o fator que determina o comprimento do ciclo de clock, isso pode significar que o clock não pode funcionar com tanta rapidez e todo o computador deve funcionar um pouco mais lentamente. Assim, há uma permuta entre velocidade e custo. A redução do armazenamento de controle em 5 bits por palavra é obtida ao custo da redução da velocidade do clock. O engenheiro deve levar em conta os objetivos do projeto ao decidir qual é a opção correta. Para uma implementação de alto desempenho, usar um decodificador talvez não seja uma boa ideia; para uma de baixo custo, pode ser.

## 4.4.2 Redução do comprimento do caminho de execução
A Mic-1 foi projetada para ser moderadamente simples e moderadamente rápida, embora admitamos que há uma enorme tensão entre esses dois objetivos. Em poucas palavras, máquinas simples não são rápidas e máquinas rápidas não são simples. A CPU da Mic-1 também usa uma quantidade mínima de hardware: 10 registradores, a ULA simples da Figura 3.19 repetida 32 vezes, um deslocador, um decodificador, um armazenamento de controle e um pouquinho de cola aqui e ali. O sistema inteiro poderia ser montado com menos de 5.000 transistores mais o tanto que o armazenamento de controle (ROM) e a memória principal (RAM) precisarem.

Agora que já vimos como IJVM pode ser executada de modo direto em microcódigo com pouco hardware, é hora de examinar implementações alternativas, mais rápidas. A seguir, vamos estudar modos de reduzir o número de microinstruções por instrução ISA (isto é, reduzir o comprimento do caminho de execução). Depois disso, vamos considerar outras técnicas.

#### Incorporação do laço do interpretador ao microcódigo
Na Mic-1, o laço principal consiste em uma microinstrução que deve ser executada no início de cada instrução IJVM. Em alguns casos, é possível sobrepô-la à instrução anterior. Na verdade, isso já foi conseguido, ao menos em parte. Note que, quando Main1 é executada, o opcode a ser interpretado já está em MBR. O opcode está ali porque foi buscado pelo laço principal anterior (se a instrução anterior não tinha operandos) ou durante a execução da instrução anterior.

Esse conceito de sobrepor o início da instrução pode ser levado mais adiante e, na realidade, em alguns casos o laço principal pode ser reduzido a nada. Isso pode ocorrer da seguinte maneira. Considere cada sequência de microinstruções que termina desviando para Main1. Em cada lugar, a microinstrução do laço principal pode ser agregada ao final da sequência, em vez de ao início da próxima, e o desvio multivias agora é repetido em muitos lugares, mas sempre com o mesmo conjunto de alvos. Em alguns casos, a microinstrução Main1 pode ser incorporada a microinstruções anteriores, já que elas nem sempre são totalmente utilizadas.

Na Figura 4.23, é mostrada a sequência dinâmica de instruções para uma instrução POP. O laço principal ocorre antes e depois de cada instrução; na figura, mostramos apenas a ocorrência após a instrução POP. Note que a execução dessa instrução leva quatro ciclos de clock: três para as microinstruções específicas para POP e um para o laço principal.

Figura 4.23   Sequência original de microprograma para executar POP.

Rótulo         Operações                        Comentários
pop1           MAR = SP = SP – 1; rd            Leia a palavra seguinte à do topo da pilha
pop2                                            Espere novo TOS ser lido da memória
pop3           TOS = MDR; goto Main1            Copie nova palavra para TOS
Main1          PC = PC + 1; fetch; goto (MBR)   MBR contém o opcode; obtenha próximo byte; despache

Na Figura 4.24, a sequência foi reduzida a três instruções que incorporam as instruções do laço principal, aproveitando um ciclo de clock no qual a ULA não é usada em pop2 para economizar um ciclo e novamente em Main1. Não se esqueça de observar que o final dessa sequência desvia diretamente para o código específico para a instrução seguinte, portanto, são requeridos apenas três ciclos no total. Esse pequeno estratagema reduz em um ciclo o tempo de execução da próxima microinstrução; portanto, por exemplo, uma IADD subsequente passa de quatro ciclos para três. Assim, isso equivale a aumentar a velocidade do clock de 250 MHz (microinstruções de 4 ns) para 333 MHz (microinstruções de 3 ns) sem pagar nada.

Figura 4.24   Sequência de microprograma melhorada para executar POP.

Rótulo        Operações                        Comentários
pop1          MAR = SP = SP – 1; rd            Leia a palavra seguinte à do topo da pilha
Main1.pop     PC = PC + 1; fetch               MBR contém opcode; busque próximo byte
pop3T         OS = MDR; goto (MBR)             Copie nova palavra para TOS; despache em opcode

A instrução POP se encaixa particularmente nesse tratamento porque ela tem um ciclo ocioso no meio que não usa a ULA. Contudo, o laço principal usa a ULA. Por isso, reduzir o comprimento da instrução por um fator dentro dela requer achar um ciclo na instrução no qual a ULA não está em uso. Esses ciclos ociosos não são comuns, mas ocorrem; portanto, vale a pena incorporar Main1 ao final de cada sequência de microinstrução. Tudo isso custa um pouco de armazenamento de controle. Assim, temos nossa primeira técnica para reduzir o comprimento do caminho: Incorpore o laço do interpretador ao final de cada sequência de microcódigo.

### Arquitetura de três barramentos
O que mais podemos fazer para reduzir o comprimento do caminho de execução? Outra solução fácil é ter dois barramentos completos de entrada para ULA, um barramento A e um B, o que dá três barramentos no total. Todos os registradores (ou ao menos a maioria deles) devem ter acesso a ambos os barramentos de entrada. A vantagem de ter dois barramentos de entrada é que então é possível adicionar qualquer registrador a qualquer outro registrador em um só ciclo. Para ver o valor dessa característica, considere a execução de ILOAD na Mic-1, apresentada novamente na Figura 4.25.

Figura 4.25   Código Mic-1 para executar ILOAD.

Rótulo        Operações                       Comentários

iload1        H = LV                          MBR contém índice; copie LV para H
iload2        MAR = MBRU + H; rd              MAR = endereço de variáveis locais a buscar
iload3        MAR = SP = SP + 1               SP aponta para novo topo da pilha; prepare escrita
iload4        PC = PC + 1; fetch; wr          Incremente PC; obtenha novo opcode; escreva topo da pilha
iload5        TOS = MDR; goto Main1           Atualize TOS
Main1         PC = PC + 1; fetch; goto (MBR)  MBR contém opcode; obtenha próximo byte; despache

Vemos aqui que, em iload1, LV é copiado para H. A única razão para LV ser copiado para H é que, assim, ele poder ser adicionado a MBRU em iload2. Em nosso projeto original de dois barramentos, não há nenhum modo de adicionar registradores arbitrários, portanto, primeiro um deles tem de ser copiado para H. Com nosso novo projeto de três barramentos, podemos economizar um ciclo, conforme mostra a Figura 4.26. Nesse caso, adicionamos o laço do interpretador a ILOAD, mas isso nem aumenta nem diminui o comprimento do caminho de execução. Ainda assim, o barramento adicional reduziu o tempo total de execução de ILOAD de seis para cinco ciclos. Agora, temos nossa segunda técnica para reduzir o comprimento de caminho: Passe de um projeto de dois barramentos para um projeto de três barramentos.

Figura 4.26   Código de três barramentos para executar ILOAD.

Rótulo        Operações                       Comentários

iload1        MAR = MBRU + LV; rd             MAR = endereço de variável local a buscar
iload2        MAR = SP = SP + 1               SP aponta para novo topo da pilha; prepare escrita
iload3        PC = PC + 1; fetch; wr          Incremente PC; obtenha novo opcode; escreva topo da pilha
iload4        TOS = MDR                       Atualize TOS
iload5        PC = PC + 1; fetch; goto (MBR)  MBR já contém opcode; busque byte de índice]

### Unidade de busca de instrução
Vale a pena usar essas duas técnicas, mas, para conseguir uma melhoria drástica, precisamos de algo muito mais radical. Vamos voltar atrás um pouco e examinar as partes comuns de toda instrução: a busca e a decodificação dos campos da instrução. Observe que, para cada instrução, podem ocorrer as seguintes operações:

  1. O PC é passado pela ULA e incrementado.
  2. O PC é usado para buscar o próximo byte na sequência de instruções.
  3. Operandos são lidos da memória.
  4. Operandos são escritos para a memória.
  5. A ULA efetua um cálculo e os resultados são armazenados de volta.

Se uma instrução tiver campos adicionais (para operandos), cada campo deve ser buscado explicitamente, um byte por vez, e montado antes de poder ser usado. Buscar e montar um campo ocupa a ULA por no mínimo um ciclo por byte para incrementar o PC, e então de novo para montar o índice ou deslocamento resultante. A ULA é usada em praticamente todos os ciclos para uma série de operações que têm a ver com buscar a instrução e montar os campos dentro da instrução, além do “trabalho” real da instrução.

Para sobrepor o laço principal, é necessário liberar a ULA de algumas dessas tarefas. Isso poderia ser feito com a introdução de uma segunda ULA, embora não seja necessária uma completa para grande parte da atividade. Observe que, em muitos casos, ela é apenas usada como um caminho para copiar um valor de um registrador para outro. Esses ciclos poderiam ser eliminados introduzindo-se caminhos de dados adicionais que não passem pela ULA. Como exemplo, pode-se conseguir algum benefício criando um caminho de TOS a MDR, ou de MDR a TOS, uma vez que a palavra do topo da pilha é muitas vezes copiada entre esses dois registradores.

Na Mic-1, grande parte da carga pode ser retirada da ULA criando uma unidade independente para buscar e processar as instruções. Essa unidade, denomina IFU (Instruction Fetch Unit – unidade de busca de instrução), pode incrementar o PC independentemente e buscar bytes antes de eles serem necessários. Essa unidade requer apenas um incrementador, um circuito muito mais simples do que um somador completo. Levando essa ideia mais adiante, a IFU também pode montar operandos de 8 e 16 bits de modo que eles estejam prontos para uso imediato sempre que necessário. Há no mínimo dois modos de fazer isso:

  1. A IFU pode interpretar cada opcode, determinando quantos campos adicionais devem ser buscados, e montá-los em um registrador pronto para a utilização pela unidade de execução principal.
  2. A IFU pode aproveitar a natureza sequencial das instruções e disponibilizar os próximos fragmentos de 8 e 16 bits todas as vezes, quer isso tenha ou não algum sentido. Então, a unidade de execução principal pode requisitar o que precisar.

Mostramos os rudimentos do segundo esquema na Figura 4.27. Em vez de um único MBR de 8 bits, agora há dois MBRs: o MBR1 de 8 bits e o MBR2 de 16 bits. A IFU monitora o(s) byte(s) mais recentemente consumido(s) pela unidade de execução principal. Também disponibiliza o próximo byte em MBR1 como na Mic-1, exceto que percebe automaticamente quando MBR1 é lido, busca o próximo byte por antecipação e o carrega em MBR1 de imediato. Como na Mic-1, ela tem duas interfaces com o barramento B: MBR1 e MBR1U. A primeira é estendida em sinal para 32 bits; a outra é estendida para zero.

De modo semelhante, o MBR2 oferece a mesma funcionalidade, mas contém os próximos 2 bytes. Também tem duas interfaces com o barramento B: MBR2 e MBR2U, que copiam os valores de 32 bits estendidos em sinal e estendidos em zeros, respectivamente.

A IFU é responsável por buscar uma sequência de bytes, e faz isso usando uma porta de memória convencional de 4 bytes, buscando palavras inteiras de 4 bytes antes da hora e carregando os bytes consecutivos em um registrador de deslocamento que os fornece um ou dois por vez, na ordem em que foram buscados. A função do registrador de deslocamento é manter uma fila de bytes da memória, para alimentar MBR1 e MBR2.

Figura 4.27   Unidade de busca para a Mic-1.
Esta seção descreve a IFU (Instruction Fetch Unit), uma otimização crucial que permite à Mic-1 buscar instruções da memória em paralelo com a execução na ULA. No seu diretório estruturas_de_dados, pense na IFU como um Buffer ou uma Fila (Queue) que mantém o processador sempre "alimentado" com bytes, evitando que ele fique ocioso esperando a RAM.

Unidade de Busca de Instruções (Figura 4.27)
A IFU funciona como um registrador de deslocamento que "engole" palavras de 4 bytes e fornece bytes individuais (MBR1) ou pares (MBR2).
DA MEMÓRIA (Palavras de 32 bits)
               |
               v
      +-----------------------+
      | REG. DE DESLOCAMENTO  | [ ][ ][ ][ ][ ][ ] (Capacidade: 6 bytes)
      +-----------------------+
        /             \
       /               \
  [ MBR1 ]          [ MBR2 ]
  (1 byte)          (2 bytes)
     |                 |
     +---- BARRAMENTO B ----+------> Para a ULA

Organização de Hardware: IFU e FSM (Seu Padrão)
Abaixo, veja como a IFU interage com os componentes que você mapeou:

Processamento                                                         Armazenamento
ULA (Cálculos)                                                        Registradores
:----------------------------------------------------------:-------------------------------------------------------------
FSM (Controle): Decide quando buscar nova palavra (estados 0, 1, 2).  PC: Endereço base da busca. Pode ser incrementado por +1 ou +2.
Deslocador: Move os bytes para a direita após cada leitura.           MBR1/MBR2: Buffers de saída para o Barramento B.

                                                                      BARRAMENTO INTERNO
UC (Controle)                                                         RI (Instrução Atual)
IFU: Antecipa a busca (Prefetch), agindo como uma UC independente.    IMAR: Registrador de endereço de memória da IFU.
REM (Endereços) ---> [B. Endereços]                                   Decodificador
IMAR: Aponta para a próxima palavra na área de código.                FSM: Traduz a quantidade de bytes no buffer em ações de leitura.
CI (Próxima Inst.)                                                    RDM (Dados) <-> [B. Dados]
PC: Atualizado sempre que um salto (GOTO, INVOKE) ocorre.             Barramento de Dados: Traz 4 bytes por vez da RAM para o buffer.
CLOCK (Sincronismo)                                                   MEMÓRIA PRINCIPAL (RAM)
CLOCK: Sincroniza o deslocamento dos bytes a cada ciclo de leitura.   RAM: Acessada em ciclos de 4 bytes para preencher a IFU.

O Modelo da FSM (Máquina de Estados Finitos)
A Figura 4.28 (descrita no seu texto) funciona com as seguintes regras de transição:

 1. Estado n: Indica quantos bytes válidos estão no buffer (0 a 6).
 2. Evento MBR1: Se você lê 1 byte, o estado passa de n para n-1.
 3. Evento MBR2: Se você lê 2 bytes, o estado passa de n para n-2.
 4. Evento Memória: Quando uma palavra chega da RAM, o estado aumenta em +4.
 5. Gatilho de Busca: Sempre que o estado cai para 2, 1 ou 0, a FSM dispara um sinal de leitura para a memória.

### Insight para seus projetos
Imagine que seu algoritmo de Torres de Hanói está sendo executado. Sem a IFU, o processador teria que parar e esperar a memória toda vez que precisasse de um BIPUSH ou ILOAD. Com a IFU:

 - Enquanto a ULA está somando discos no registrador H, a IFU já está buscando os próximos 4 bytes do código na RAM.
 - Isso cria um Pipeline primitivo, onde a busca e a execução acontecem ao mesmo tempo.

Esta unidade de busca (IFU) é o que chamamos de Prefetch Unit. Ela atua como um "garçom" para a ULA, garantindo que o próximo byte de instrução já esteja pronto antes mesmo de a ULA terminar a operação atual.

No seu diretório estruturas_de_dados, entenda a IFU como um Buffer Circular ou uma Fila (FIFO) implementada em hardware.
Unidade de Busca para a Mic-1 (Figura 4.27)
DA MEMÓRIA (Palavras de 32 bits)
                             |
                             v
           +-----------------------------------------+
           |       REGISTRADOR DE DESLOCAMENTO       |
           |  [Byte 5][Byte 4][Byte 3][Byte 2][Byte 1][Byte 0]  |
           +-----------------------------------------+
             /               |                     \
            /                |                      \
    [  MBR2  ]          [  MBR1  ]              [  IMAR  ] <--- (Endereço
    (16 bits)           (8 bits)                (Endereço)       de Busca)
        |                    |                      ^
        |                    |                      |
        |          +---------+---------+            | (+1)
        |          |    BARRAMENTO B   |            |
        |          +---------+---------+      +-----+-----+
        |                    |                |    PC     |
        +--------------------+                +-----------+
                                                    ^
                                                    | (Barramento C)
                                              [ Escreva PC ]

## Insight para seus projetos

    1. Paralelismo: A grande vantagem aqui é que o fetch (busca) não ocupa mais um ciclo de microinstrução na ULA. Enquanto a ULA executa um IADD, a IFU está deslocando os bytes para que o próximo Opcode já esteja no MBR1 no início do próximo ciclo.

    2. Desalinhamento: Como você leu no texto, as instruções IJVM não são alinhadas. A IFU resolve isso "fatiando" as palavras de 32 bits da memória em bytes individuais, não importando se a instrução começa no meio de uma palavra de memória.

    3. Flush (Limpeza): Quando seu programa faz um GOTO, o hardware dá um sinal de Escreva PC. Isso invalida todos os bytes que estão no Registrador de Deslocamento, pois eles pertenciam ao caminho linear que não será mais seguido.

Em todas as vezes, MBR1 contém o byte mais antigo no registrador de deslocamento e MBR2 contém os 2 bytes mais antigos (byte mais antigo na esquerda), para formar um inteiro de 16 bits (veja a Figura 4.19(b)). Os 2 bytes em MBR2 podem ser de palavras de memória diferentes, porque instruções IJVM não se alinham em fronteiras de palavras na memória.

Sempre que MBR1 é lido, o registrador de deslocamento desloca 1 byte para a direita. Sempre que MBR2 é lido, ele desloca 2 bytes para a direita. Então, MBR1 e MBR2 são recarregados a partir do byte mais antigo e do par de bytes mais antigo, respectivamente. Se agora restar espaço suficiente no registrador de deslocamento para mais outra palavra inteira, a IFU inicia um ciclo de memória para lê-la. Admitimos que, quando qualquer um dos registradores MBR é lido, ele é preenchido outra vez no início do ciclo seguinte, de modo que pode ser lido em ciclos consecutivos.

O projeto da IFU pode ser modelado por uma FSM (Finite State Machine – máquina de estado finito), como ilustra a Figura 4.28. Todas as FSMs consistem em duas partes: estados, representados por círculos, e transições, representadas por arcos que vão de um estado a outro. Cada estado representa uma situação possível na qual a FSM pode estar. Essa FSM particular tem sete estados, correspondentes aos estados do registrador de deslocamento da Figura 4.27. Os sete estados correspondem à quantidade de bytes que estão naquele registrador no momento em questão, um número entre 0 e 6, inclusive.

Cada arco representa um evento que pode ocorrer. Três eventos diferentes podem ocorrer nesse caso. O primeiro deles é a leitura de 1 byte do MBR1. Esse evento faz o registrador de deslocamento ser ativado e 1 byte ser deslocado para fora da extremidade direita, que reduz o estado por um fator de 1. O segundo evento é a leitura de 2 bytes do MBR2, o que reduz o estado por um fator de dois. Essas duas transições fazem MBR1 e MBR2 serem recarregados. Quando a FSM passa para os estados 0, 1 ou 2, é iniciada uma referência à memória para buscar uma nova palavra (considerando que a memória já não esteja ocupada lendo uma). A chegada da palavra adianta o estado por um fator de 4.

Para trabalhar corretamente, a IFU deve bloquear quando requisitada a fazer algo que não pode, tal como fornecer o valor de MBR2 quando há somente 1 byte no registrador de deslocamento e a memória ainda está ocupada buscando uma nova palavra. Além disso, ela só pode fazer uma coisa por vez, portanto, eventos que estão chegando devem ser serializados. Por fim, sempre que o PC é alterado, a IFU deve ser atualizada. Esses detalhes a tornam mais complicada do que mostramos. Ainda assim, muitos dispositivos de hardware são construídos como FSMs.

## nsight para seus projetos
 1. Paralelismo: A grande vantagem aqui é que o fetch (busca) não ocupa mais um ciclo de microinstrução na ULA. Enquanto a ULA executa um IADD, a IFU está deslocando os bytes para que o próximo Opcode já esteja no MBR1 no início do próximo ciclo.

 2. Desalinhamento: Como você leu no texto, as instruções IJVM não são alinhadas. A IFU resolve isso "fatiando" as palavras de 32 bits da memória em bytes individuais, não importando se a instrução começa no meio de uma palavra de memória.

 3. Flush (Limpeza): Quando seu programa faz um GOTO, o hardware dá um sinal de Escreva PC. Isso invalida todos os bytes que estão no Registrador de Deslocamento, pois eles pertenciam ao caminho linear que não será mais seguido.

 Figura 4.28 Máquina de estado finito para implementar a IFU.
 Esta FSM (Máquina de Estados Finitos) é o cérebro que gerencia o fluxo de dados na IFU. No seu diretório estruturas_de_dados, você pode visualizar essa FSM como um gerenciador de buffer que decide se há "estoque" (bytes) suficiente para a ULA ou se precisa "fazer um pedido" (leitura de memória) ao fornecedor (RAM).

FSM da Unidade de Busca (Figura 4.28)
Os círculos representam quantos bytes estão no buffer. As setas são as transições baseadas nas leituras da CPU ou na chegada de dados da memória.

+---[ Palavra (+4) ]---+          +---[ Palavra (+4) ]---+
       |                      |          |                      |
       v                      |          v                      |
    (Est 0) --[MBR1]--> (Est 0*)      (Est 2) --[MBR1]--> (Est 1)
       |                      ^          |                      ^
       +---[ MBR2 (-2) ]------+          +---[ MBR2 (-2) ]------+
                                         
    (Est 3) --[MBR1]--> (Est 2)       (Est 5) --[MBR1]--> (Est 4)
       |                                 |
       +---[ MBR2 (-2) ]--> (Est 1)      +---[ MBR2 (-2) ]--> (Est 3)

    (Est 4) --[MBR1]--> (Est 3)       (Est 6) --[MBR1]--> (Est 5)
       |                                 |
       +---[ MBR2 (-2) ]--> (Est 2)      +---[ MBR2 (-2) ]--> (Est 4)

   *Nota: Se o estado cai para 0, 1 ou 2, a FSM dispara a busca de 4 bytes (+4).*

Processamento                                                Armazenamento
ULA (Operações de Buffer)                                    Registradores (Estado)
:-----------------------------------------------------------:------------------------------------------------------------
FSM: Calcula o próximo estado (n−1,n−2,n+4).                 Contador de Bytes: Registrador que armazena o estado atual (0 a 6).
Comparador: Verifica se n≤2 para disparar o fetch.           MBR1/MBR2: Saídas do registrador de deslocamento controladas pela FSM.

                                                             BARRAMENTO INTERNO
UC (Controle)                                                RI (Instrução Atual)

Lógica Sequencial: Garante que a IFU bloqueie a ULA          IMAR: Atualizado pela FSM sempre que uma 
se o buffer estiver vazio.                                   palavra é buscad(+4 bytes).

REM (Endereços) ---> [B. Endereços]                          Decodificador
MAR: Usado pela FSM para buscar a próxima palavra da RAM.    Lógica da FSM: Decodifica os sinais de leitura rd vindos da CPU.

CI (Próxima Inst.)                                           RDM (Dados) <-> [B. Dados]
PC: Se o Escreva PC for ativado, a FSM reseta para   .       Bus de Dados: Alimenta o registrador de deslocamento com 32 
o Estado 0.                                                  bits.
                                                
CLOCK (Sincronismo)                                          MEMÓRIA PRINCIPAL (RAM)
CLOCK: Sincroniza as transições entre estados a cada ciclo.  RAM: Responde aos pedidos de busca disparados nos estados 0,  
                                                             1 e 2.
#### Insight para seus projetos

   1. O Gatilho (Trigger): Note que a busca de memória não espera o buffer esvaziar. Quando você chega no Estado 2, a FSM já inicia a leitura. Isso é vital porque a memória é lenta; se esperássemos chegar ao Estado 0, a ULA ficaria "congelada" (stalled) esperando dados.

   2.  Capacidade Máxima: O buffer tem 6 bytes, mas a memória entrega 4. Por isso, só podemos buscar quando temos espaço para pelo menos 4 novos bytes (ou seja, quando temos 2 ou menos no buffer: 2+4=6).

   3. Serialização: Se a ULA pedir um MBR2 e a memória entregar uma palavra ao mesmo tempo, a FSM age como um árbitro, decidindo quem acessa o registrador de deslocamento primeiro para evitar corrupção de dados.

Nas Torres de Hanói, essa FSM é o que permite que o processador "enxergue" as próximas instruções de movimento de discos enquanto ainda está processando o INVOKEVIRTUAL da chamada atual.  

A IFU tem seu próprio registrador de endereço de memória, denominado IMAR, que é usado para endereçar a memória quando uma nova palavra tem de ser buscada. Esse registrador tem seu próprio incrementador dedicado, de modo que a ULA principal não é necessária para incrementá-lo nem para buscar a próxima palavra. A IFU deve
monitorar o barramento C de modo que, sempre que PC for carregado, o novo valor de PC é copiado para IMAR. Uma vez que o novo valor em PC pode não estar sobre uma fronteira de palavra, a IFU tem de buscar a palavra necessária e fazer o ajuste adequado do registrador de deslocamento.

Com a IFU, a unidade de execução principal escreve para o PC somente quando for necessário alterar a natureza sequencial do fluxo de bytes da instrução. Ela escreve por causa de uma instrução de desvio bem-sucedida e em virtude da INVOKEVIRTUAL e IRETURN.

Já que o microprograma não mais incrementa o PC explicitamente, porque opcodes são buscados, a IFU deve manter o PC atualizado. Ela o faz percebendo quando um byte da instrução foi consumido, isto é, quando MBR1 ou MBR2, ou as versões sem sinal, foram lidos. Associado com o PC há um incrementador separado, capaz de incrementar por fatores de 1 ou 2, dependendo de quantos bytes foram consumidos. Assim, o PC sempre contém o endereço do primeiro byte que não foi consumido. No início de cada instrução, MBR contém o endereço do opcode para aquela instrução.

Note que há dois incrementadores separados e eles executam funções diferentes. O PC conta bytes e incrementa por um fator de 1 ou 2. O IMAR conta palavras, e incrementa somente por um fator de 1 (para 4 bytes novos). Como o MAR, o IMAR está ligado “obliquamente” ao barramento de endereço, sendo que o bit 0 do IMAR está conectado à linha de endereço 2, e assim por diante, para efetuar uma conversão implícita de endereços de palavras para endereços de bytes.

Como detalharemos em breve, não ter de incrementar o PC no laço principal representa um grande ganho, porque a microinstrução na qual ele é incrementado costuma fazer pouco mais do que isso. Se tal microinstrução puder ser eliminada, o caminho de execução pode ser reduzido. Nesse caso, a permuta é mais hardware por uma máquina mais rápida, portanto, nossa terceira técnica para reduzir o comprimento do caminho é: Busque instruções na memória com uma unidade funcional especializada.

## 4.4.3 0 projeto com busca antecipada: a Mic-2
A IFU pode reduzir muito o comprimento do caminho da instrução média. Primeiro, ela elimina todo o laço principal, visto que o final de cada instrução apenas desvia diretamente para a próxima. Segundo, evita ocupar a ULA com a tarefa de incrementar o PC. Terceiro, reduz o comprimento do caminho sempre que um índice de 16 bits ou um deslocamento é calculado, porque ela monta o valor de 16 bits e o passa diretamente para a ULA como um valor de 32 bits, evitando a necessidade de montagem em H. A Figura 4.29 mostra a Mic-2, uma versão melhorada da Mic-1 à qual foi acrescentada a IFU da Figura 4.27. O microcódigo para a máquina melhorada é ilustrado na Figura 4.30. 

Figura 4.29 0 caminho de dados para a Mic-2.
A Mic-2 representa uma evolução significativa em relação à Mic-1 que estávamos analisando. A grande mudança aqui é a introdução do Barramento A, transformando a arquitetura em um sistema de três barramentos. No seu diretório estruturas_de_dados, isso significa que o processador agora pode ler dois operandos simultaneamente (um pelo Barramento A e outro pelo Barramento B), eliminando a necessidade de usar o registrador H como um passo intermediário obrigatório em quase todas as operações da ULA.

Caminho de Dados da Mic-2 (Figura 4.29)
Observe como a estrutura se tornou mais simétrica e eficiente com a adição do novo barramento:
Sinais de Controle: [ Habilite p/ Barramento A/B ] [ Escreva no Barramento C ]
  __________________________________________________________________________________
 |                                                                                  |
 |                              BARRAMENTO C (Escrita)                              |
 |__________________________________________________________________________________|
    |       |       |       |       |       |       |       |       |       |
    v       v       v       v       v       v       v       v       v       v
 +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
 | MAR | | MDR | | PC  | | MBR | |SP   | | LV  | | CPP | | TOS | | OPC | |  H  |
 +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
    |       |       |     MBR2      |       |       |       |       |       |
    |  /----+-------+-------+-------+-------+-------+-------+-------+-------/
    |  |    |       |       |       |       |       |       |       |       |
  __v__v____v_______v_______v_______v_______v_______v_______v_______v_______v__
 |                                                                             |
 |       BARRAMENTO A (Leitura)                     BARRAMENTO B (Leitura)     |
 |__________________________                        ___________________________|
                            \                      /
                             \                    /
                              v                  v
                            +----------------------+   [ Controle da ULA ]
                            |         ULA          | <------- (6 bits)
                            +----------------------+
                             |      |          |
                             |      v          v
                             |    [ N ]      [ Z ] (Registradores de Estado)
                             v
                      +--------------+
                      |  DESLOCADOR  |
                      +--------------+
                             |
                             +------> (Retorna ao Barramento C)
                             
   [ Conexões Externas ]
   MAR/MDR <---> Memória Principal
   PC/MBR  <---  IFU (Unidade de Busca de Instrução)
                |  DESLOCADOR  |
                +--------------+
                       |
                       +-----> [ Volta para o Barramento C ]

Organização de Hardware: A Eficiência da Mic-2 (Seu Padrão)
Esta nova configuração altera drasticamente como as microinstruções que vimos na tabela anterior seriam executadas:

Processamento                                                                       Armazenamento
ULA (Cálculos de 2 Entradas)                                                        Registradores (Dual-Port)
:-----------------------------------------------------------------------------------:-------------------------------------------------------------------  
ULA: Agora pode somar SP + 1 ou LV + MBR diretamente sem o H.                       Barramento A/B: Permite leitura simultânea de dois registradores.
Deslocador: Continua processando a saída da ULA para o Barramento C.                IFU: Integrada para fornecer MBR1/MBR2 sem atrasar a ULA.

                                                                                    BARRAMENTO INTERNO
UC (Controle)                                                                       RI (Instrução Atual)
UC: As microinstruções agora precisam de campos para selecionar o Barramento A.     MBR: Agora alimentado pela IFU diretamente para os barramentos de leitura.
REM (Endereços) ---> [B. Endereços]                                                 Decodificador
MAR/MDR: Conectados de forma mais independente para operações de memória.           Lógica de Controle: Mais complexa para gerenciar três barramentos.
CI (Próxima Inst.),RDM (Dados) <-> [B. Dados]
PC: Pode ser lido e incrementado em um único ciclo via ULA.                         Memória: Interface mantida, mas a alimentação de dados é mais fluida.
CLOCK (Sincronismo)                                                                 MEMÓRIA PRINCIPAL (RAM)
CLOCK: Cada ciclo de clock agora realiza muito mais trabalho útil.                  RAM: Continua sendo o depósito de código e dados.

### nsight para seus projetos

Por que a Mic-2 é um "upgrade" para suas simulações de Torres de Hanói?

   1. Redução de Ciclos: No seu diretório estruturas_de_dados, você notará que instruções como IADD na Mic-1 levavam 3 ciclos (porque precisávamos carregar o H primeiro). Na Mic-2, como podemos ler o topo da pilha e o próximo valor simultaneamente pelos Barramentos A e B, o IADD pode ser feito em menos ciclos.

   2. O Fim do Gargalo do H: O registrador H deixa de ser um "pedágio" obrigatório. Ele ainda existe para compatibilidade e operações específicas, mas o caminho direto entre registradores e ULA agora é duplo.

   3. IFU Melhorada: A Unidade de Busca de Instruções agora "injeta" os dados diretamente nos barramentos de leitura, permitindo que os operandos das instruções cheguem à ULA com latência zero.

Tabela: Microprograma para a Mic-2 (Figura 4.30)
Aqui estão os comandos do microprograma da Mic-2 organizados em três colunas.

Rótulo            Operações                                   Comentários

nop1              goto (MBR)                                  Desvie para a próxima instrução
iadd1             MAR = SP = SP – 1; rd                       Leia a palavra seguinte à do topo da pilha
iadd2             H = TOS                                     H = topo da pilha
iadd3             MDR = TOS = MDR + H; wr; goto (MBR1)        Some duas palavras do topo; escreva para novo topo
isub1             MAR = SP = SP – 1; rd                       Leia a palavra seguinte à do topo da pilha
isub2             H = TOS                                     H = topo da pilha
isub3             MDR = TOS = MDR – H; wr; goto (MBR1)        Subtraia TOS da palavra anterior na pilha
iand1             MAR = SP = SP – 1; rd                       Leia a palavra seguinte à do topo da pilha
iand2             H = TOS                                     H = topo da pilha
iand3             MDR = TOS = MDR AND H; wr; goto (MBR1)      AND palavra anterior da pilha com TOS
ior1              MAR = SP = SP – 1; rd                       Leia a palavra seguinte à do topo da pilha
ior2              H = TOS                                     H = topo da pilha
ior3              MDR = TOS = MDR OR H; wr; goto (MBR1)       OR palavra anterior da pilha com TOS
dup1              MAR = SP = SP + 1                           Incremente SP; copie para MAR
dup2              MDR = TOS; wr; goto (MBR1)                  Escreva nova palavra da pilha
pop1              MAR = SP = SP – 1; rd                       Leia a palavra seguinte à do topo da pilha
pop2                                                          Espere pela leitura
pop3             TOS = MDR; goto (MBR1)                       Copie nova palavra para TOS
swap1            MAR = SP – 1; rd                             Leia a segunda palavra; ajuste MAR para SP
swap2            MAR = SP                                     Prepare para escrever nova 2a palavra
swap3            H = MDR; wr                                  Salve novo TOS; escreva 2a palavra para pilha
swap4            MDR = TOS                                    Copie antigo TOS para MDR
swap5            MAR = SP – 1; wr                             Escreva antigo TOS para 2o lugar na pilha
swap6            TOS = H; goto (MBR1)                         Atualize TOS
bipush1          SP = MAR = SP + 1                            Ajuste MAR para escrever para novo topo
bipush2          MDR = TOS = MBR1; wr; goto (MBR1)            Atualize pilha em TOS e memória
iload1           MAR = LV + MBR1U; rd                         Passe LV + índice para MAR; leia operando
iload2           MAR = SP = SP + 1                            Incremente SP; passe novo SP para MAR
iload3           TOS = MDR; wr; goto (MBR1)                   Atualize pilha em TOS e memória
istore1          MAR = LV + MBR1U                             Ajuste MAR para LV + índice
istore2          MDR = TOS; wr                                Copie TOS para armazenamento
istore3          MAR = SP = SP – 1; rd                        Decremente SP; leia novo TOS
istore4                                                       Espere por leitura
istore5         TOS = MDR; goto (MBR1)                        Atualize TOS
wide1           goto (MBR1 OR 0x100)                          Ramificação multivias com bit alto ajustado
wide_iload1     MAR = LV + MBR2U; rd; goto iload2             Idêntica a iload1 mas usando índice de 2 bytes
wide_istore1    MAR = LV + MBR2U; goto istore2                Idêntica a istore1 mas usando índice de 2 bytes
ldc_w1          MAR = CPP + MBR2U; rd; goto iload2            Idêntica a wide_iload1 indexando a partir de CPP
iinc1           MAR = LV + MBR1U; rd                          Ajuste MAR para LV + índice para leitura
iinc2           H = MBR1                                      Ajuste H para constante
iinc3           MDR = MDR + H; wr; goto (MBR1)                Incremente por constante e atualize
goto1           H = PC – 1                                    Copie PC para H
goto2           PC = H + MBR2                                 Some deslocamento e atualize PC
goto3                                                         Espera que IFU busque novo opcode
goto4           goto (MBR1)                                   Despache para a próxima instrução
iflt1           MAR = SP = SP – 1; rd                         Leia a palavra seguinte à do topo da pilha
iflt2           OPC = TOS                                     Salve TOS em OPC temporariamente
iflt3           TOS = MDR                                     Ponha novo topo da pilha em TOS
iflt4           N = OPC; if (N) goto T; else goto F           Desvie no bit N (Negativo)
ifeq1           MAR = SP = SP – 1; rd                         Leia a palavra seguinte à do topo da pilha
ifeq2           OPC = TOS                                     Salve TOS em OPC temporariamente
ifeq3           TOS = MDR                                     Ponha novo topo da pilha em TOS
ifeq4           Z = OPC; if (Z) goto T; else goto F           Desvie no bit Z (Zero)
if_icmpeq1      MAR = SP = SP – 1; rd                         Leia a palavra seguinte à do topo da pilha
if_icmpeq2      MAR = SP = SP – 1                             Ajuste MAR para ler novo topo da pilha
if_icmpeq3      H = MDR; rd                                   Copie segunda palavra da pilha para H
if_icmpeq4      OPC = TOS                                     Salve TOS em OPC temporariamente
if_icmpeq5      TOS = MDR                                     Ponha novo topo da pilha em TOS
if_icmpeq6      Z = H – OPC; if (Z) goto T; else goto F       Se iguais (H-OPC=0), vá para T
T               H = PC – 1; goto goto2                        O mesmo que goto1
F               H = MBR2                                      Toque bytes em MBR2 para descartar
F2              goto (MBR1)                                   Despache para a próxima instrução
invokevirtual1  MAR = CPP + MBR2U; rd                         Ponha endereço de ponteiro de método em MAR
invokevirtual2  OPC = PC                                      Salve Return PC em OPC
invokevirtual3  PC = MDR                                      Ajuste PC para o início do método
invokevirtual4  TOS = SP – MBR2U                              TOS = endereço de OBJREF – 1
invokevirtual5  TOS = MAR = H = TOS + 1                       TOS = endereço de OBJREF
invokevirtual6  MDR = SP + MBR2U + 1; wr                      Sobrescreva OBJREF com ponteiro de ligação
invokevirtual7  MAR = SP = MDR,"Ajuste SP                     MAR para local do PC antigo"
invokevirtual8  MDR = OPC; wr                                 Prepare para salvar PC antigo
invokevirtual9  MAR = SP = SP + 1                             Incremente SP para local do LV antigo
invokevirtual10 MDR = LV; wr                                  Salve LV antigo
invokevirtual11 LV = TOS; goto (MBR1)                         Ajuste LV e despache
ireturn1        MAR = SP = LV; rd                             Reajuste SP, MAR para obter ponteiro de ligação
ireturn2                                                      Espere por ponteiro de ligação
ireturn3        LV = MAR = MDR; rd                            Ajuste LV, MAR; leia PC antigo"
ireturn4        MAR = LV + 1                                  Ajuste MAR para ler LV antigo
ireturn5        PC = MDR; rd                                  Restaure PC
ireturn6        MAR = SP                                      Ajuste MAR para escrever TOS
ireturn7        LV = MDR                                      Restaure LV
ireturn8        MDR = TOS; wr; goto (MBR1)                    Salve valor de retorno e despache

#### Diferenças Notáveis da Mic-2
 1. MBR1 e MBR2: Você notará o uso constante desses registradores. O MBR1U (sem sinal) e MBR2U permitem que os índices sejam lidos e usados em operações de . endereço (MAR = LV + MBR1U) em um único ciclo.

 2. Eliminação da Main1: Na Mic-1, quase toda instrução terminava com um salto para Main1. Na Mic-2, o hardware da IFU permite que a última microinstrução já faça o goto (MBR1), saltando diretamente para o início da próxima instrução.

 3. Habilidade de Endereçamento: Repare em iinc3. A ULA agora consegue somar o conteúdo da memória (MDR) com uma constante vinda da instrução (H) de forma muito mais direta.

Observe que, graças à inclusão da IFU (Unidade de Busca de Instrução) e dos três barramentos na Mic-2, muitas instruções agora terminam com goto (MBR1), o que indica um "despacho" imediato para a próxima instrução, tornando o ciclo muito mais eficiente que na Mic-1.

Como exemplo do modo de funcionamento da Mic-2, examine a IADD. Ela pega a segunda palavra em uma pilha e efetua a adição como antes, só que agora, quando termina, ela não tem de ir até Main1 para incremen- tar PC e despachar para a próxima microinstrução. Quando a IFU vê que MBR1 foi referenciado em iadd3, seu
registrador de deslocamento interno empurra tudo para a direita e recarrega MBR1 e MBR2. Ela também faz a transição para um estado um grau mais baixo do que o corrente. Se o novo estado for 2, a IFU começa a buscar uma palavra da memória. Tudo isso é feito em hardware – o microprograma não tem de fazer nada. É por isso
que a IADD pode ser reduzida de quatro para três microinstruções.

A Mic-2 melhora algumas instruções mais do que outras. LDC_W passa de nove microinstruções para apenas três, reduzindo seu tempo de execução por um fator de três. Por outro lado, SWAP só passa de oito para seis microinstruções. O que de fato conta para o desempenho geral é o ganho para as instruções mais comuns. Podemos citar ILOAD (eram 6, agora são 3), IADD (eram 4, agora são 3) e IF_ICMPEQ (eram 13, agora são 10 para o caso do desvio tomado; eram 10, agora são 8 para o caso do desvio não tomado). Para medir a melhoria, teríamos de escolher e executar alguns padrões de comparação, mas é claro que tudo isso representa um grande ganho.

## 4.4.4 Projeto com pipeline: a Mic-3
A Mic-2 é uma melhoria clara em relação à Mic-1. É mais rápida e usa menos armazenamento de controle, em­bora o custo da IFU sem dúvida seja maior do que o ganho obtido por ter um armazenamento de controle menor. Portanto, ela é uma máquina bem mais rápida por um preço pouca coisa mais alto. Vamos ver se podemos fazê-la ficar ainda mais rápida.

Que tal tentar reduzir o tempo de ciclo? Ele é determinado, em considerável proporção, pela tecnologia subjacente. Quanto menores os transistores e mais curtas as distâncias físicas entre eles, mais rapidamente o clock pode ser executado. Para uma determinada tecnologia, o tempo requerido para executar uma operação completa de caminho de dados é fixo (ao menos de nosso ponto de vista). Ainda assim, temos certa liberdade e em breve a exploraremos ao máximo.

Nossa outra opção é introduzir mais paralelismo na máquina. No momento, a Mic-2 é altamente sequencial. Ela coloca registradores em seus barramentos, espera que a ULA e o deslocador os processem para depois escrever os resultados de volta nos registradores. Exceto pela IFU, há pouco paralelismo presente. Adicionar paralelismo é uma oportunidade real.

Como já dissemos, o ciclo de clock é limitado pelo tempo necessário para que os sinais se propaguem pelo caminho de dados. A Figura 4.3 mostra um desdobramento do atraso em vários componentes durante cada ciclo. Há três componentes importantes no ciclo do caminho de dados propriamente dito:

  1. O tempo para levar os registradores selecionados até os barramentos A e B.
  2. O tempo para que a ULA e o deslocador realizem seu trabalho.
  3. O tempo para os resultados voltarem aos registradores e serem armazenados.

Na Figura 4.31, mostramos uma nova arquitetura e três barramentos, incluindo a IFU, mas com três registradores adicionais, cada um inserido no meio de cada barramento. Os registradores são escritos em todo o ciclo. Na realidade, eles repartem o caminho de dados em partes distintas que agora podem funcionar de modo independente. Denominaremos isso Mic-3, ou modelo pipeline.

Figura 4.31   Caminho de dados de três barramentos usados em Mic-3.
A Mic-3 é a evolução direta da Mic-2, focada em introduzir o conceito de Pipelining. A principal diferença física que você notará nesta figura é a adição de Latches (Latches A, B e C). No seu diretório estruturas_de_dados, pense nos latches como "estacionamentos temporários" de dados que permitem que a ULA trabalhe em uma parte da instrução enquanto os barramentos já estão preparando a próxima.

Caminho de Dados da Mic-3 (Figura 4.31)
Este diagrama destaca como os Latches isolam a ULA dos barramentos, permitindo que o ciclo de clock seja dividido em sub-etapas.

Sinais de Controle: [ Habilite A/B ] [ Escreva C ]
  _________________________________________________________________________
 |                                                                         |
 |                         BARRAMENTO C (Escrita)                          |
 |_________________________________________________________________________|
    |       |       |       |       |       |       |       |       |
    v       v       v       v       v       v       v       v       v
 +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
 | MAR | | MDR | | PC  | | SP  | | LV  | | CPP | | TOS | | OPC | |  H  |
 +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
    |       |       |       |       |       |       |       |       |
    |  /----+-------+-------+-------+-------+-------+-------+-------/
    |  |    |       |       |       |       |       |       |       |
  __v__v____v_______v_______v_______v_______v_______v_______v_______v__
 |                                                                     |
 |       BARRAMENTO A (Leitura)             BARRAMENTO B (Leitura)     |
 |__________________________                ___________________________|
              |                                          |
              v                                          v
        +----------+                               +----------+
        | LATCH A  |                               | LATCH B  |
        +----------+                               +----------+
              \                                          /
               \________________   _____________________/
                                \ /
                                 v
                       +--------------------+   [ Controle da ULA ]
                       |        ULA         | <------- (6 bits)
                       +--------------------+
                                 |
                                 v
                        +------------------+
                        |    DESLOCADOR    |
                        +------------------+
                                 |
                                 v
                        +------------------+
                        |     LATCH C      |
                        +------------------+
                                 |
                                 +-----> (Volta para o Barramento C)

   [ Unidade de Busca ]
   IFU ---> MBR1 / MBR2 (Alimentam Barramento B)

Organização de Hardware: A Lógica de Pipeline (Seu Padrão)
A Mic-3 permite que diferentes partes do hardware trabalhem em "turnos" diferentes. Veja como isso afeta os componentes:

Processamento                                                                   Armazenamento

ULA (Isolada por Latches)                                                       Registradores (Interface)
:------------------------------------------------------------------------------:-----------------------------------------------------------------
ULA: Não lê mais direto dos barramentos; ela lê dos Latches A e B.              Barramento A/B: Podem carregar novos valores enquanto a ULA calcula.
Latch C: Segura o resultado do deslocador para ser escrito no ciclo seguinte.   IFU: Continua fornecendo bytes, agora sincronizada com o pipeline.

                                                                                BARRAMENTO INTERNO
UC (Controle)                                                                   RI (Instrução Atual)
UC: Agora precisa gerenciar o tempo de propagação entre os latches.             MBR1/MBR2: Operandos prontos para entrar no Latch B.
REM (Endereços) ---> [B. Endereços]                                             Decodificador
MAR: Carregado a partir do Latch C no final do ciclo de pipeline.               Lógica de Pipeline: Divide o ciclo em: Carga de Latch -> ULA -> Escrita.
CI (Próxima Inst.)                                                              RDM (Dados) <-> [B. Dados]
PC: Pode ser incrementado e salvo de forma assíncrona à ULA.                    MDR: Isolado para evitar conflitos de barramento durante a escrita.
CLOCK (Sincronismo)                                                             MEMÓRIA PRINCIPAL (RAM)
"CLOCK: O período de clock pode ser menor, pois as tarefas são menores.         RAM: Continua sendo o destino final de leituras e escritas.

### Insight para seus projetos: O que os Latches mudam?
Nas Torres de Hanói, a Mic-3 seria extremamente veloz por causa da sobreposição de tarefas:

 - Ciclo 1: Os valores de SP e LV são colocados nos Latches A e B.

 - Ciclo 2: A ULA processa a soma de SP + LV enquanto os barramentos já estão buscando os próximos valores para a próxima microinstrução.

 - Ciclo 3: O resultado que estava no Latch C é finalmente escrito de volta no registrador de destino.

Diferente da Mic-1, onde a ULA precisava esperar o barramento ficar livre, na Mic-3 a ULA é uma "ilha" de processamento cercada por latches. Isso permite aumentar a frequência do clock significativamente.

Como esses registradores extras podem ajudar? Agora, leva três ciclos de clock para usar o caminho de dados: um para carregar os latches A e B, um para executar a ULA e deslocador e carregar o latch C, e um para armazenar o latch C de volta nos registradores. Certamente, isso é pior do que tínhamos antes.
Estamos loucos? (Dica: Não!) Inserir os registradores tem dupla finalidade:

  1. Podemos aumentar a velocidade do clock porque o atraso máximo agora é mais curto.
  2. Podemos usar todas as partes do caminho de dados durante cada ciclo.

Desmembrando o caminho de dados em três partes, o atraso máximo é reduzido e o resultado é que a frequência do clock pode ser mais alta. Vamos supor que, desmembrando o ciclo do caminho de dados em três intervalos de tempo, o comprimento de cada um seja cerca de 1/3 do original, de modo que podemos triplicar a
velocidade do clock. (Isso não é de todo realidade, já que também adicionamos dois registradores ao caminho de dados, mas serve como uma primeira aproximação.)

Como estamos considerando que todas as leituras e escritas da memória podem ser satisfeitas na cache de nível 1, e que esta é feita do mesmo material que os registradores, continuaremos a supor que uma operação de memória leva um ciclo. Porém, na prática, isso pode não ser fácil de conseguir.

O segundo ponto trata do rendimento, e não da velocidade, de uma instrução individual. Na Mic-2, durante a primeira e a terceira partes de cada ciclo de clock, a ULA fica ociosa. Desmembrando o caminho de dados em três pedaços, poderemos usar a ULA em cada ciclo, obtendo três vezes mais trabalho da máquina.

Agora, vamos ver como o caminho de dados da Mic-3 funciona. Antes de começar, precisamos de uma notação para lidar com os registradores. A óbvia é denominar os registradores A, B e C e tratá-los como os outros registradores, tendo em mente as restrições do caminho de dados. A Figura 4.32 mostra um exemplo de sequência
de código, a execução de SWAP para a Mic-2.

Figura 4.32   Código Mic-2 para SWAP.

Rótulo             Operações               Comentários

swap1              MAR = SP – 1; rd        Leia a segunda palavra da pilha; ajuste MAR a SP
swap2              MAR = SP                Prepare para escrever nova segunda palavra
swap3              H = MDR; wr             Salve novo TOS; escreva segunda palavra para pilha
swap4              MDR = TOS               Copie TOS antigo para MDR
swap5              MAR = SP – 1; wr        Escreva TOS antigo para o segundo lugar na pilha
swap6              TOS = H; goto (MBR1)    Atualize TOS

Agora, vamos reimplementar essa sequência na Mic-3. Lembre-se de que o caminho de dados agora requer três ciclos para operar: um para carregar A e B, um para efetuar a operação e carregar C e um para escrever o resultado de volta para os registradores. Denominaremos cada um desses pedaços microetapa.

A implementação de SWAP para Mic-3 é mostrada na Figura 4.33. No ciclo 1, começamos em swap1 copiando SP para B. Não importa o que acontece em A porque, para subtrair 1 de B, ENA é negado (veja a Figura 4.2). Para simplificar, não mostramos atribuições que não são usadas. No ciclo 2, efetuamos a subtração. No ciclo 3, o resultado é armazenado em MAR e a operação de leitura é iniciada no final do ciclo 3, após MAR ter sido armazenado. Já que leituras de memória agora levam um ciclo, essa não estará concluída até o final do ciclo 4, o que é indicado mostrando a atribuição MDR no ciclo 4. O valor em MDR não pode ser lido antes do ciclo 5.

Figura 4.33   A implementação de SWAP na Mic-3.

       Swap1             Swap2       Swap3         Swap4       Swap5              Swap6
 
Ciclo  MAR = SP – 1; rd  MAR = SP    H = MDR; wr   MDR = TOS   MAR = SP – 1; wr   TOS = H; goto (MBR1)
 1     B = SP
 2     C=B–1             B = SP
 3     MAR = C; rd       C = B
 4     MDR = Mem         MAR = C
 5                                   B = MDR
 6                                   C = B         B = TOS
 7                                   H = C; wr     C = B       B = SP
 8                                   Mem = MDR     MDR = C     C= B–1              B = H
 9                                                             MAR = C; wr         C = B
 10                                                            Mem = MDR           TOS = C
 11                                                                                goto (MBR1)

Vamos voltar ao ciclo 2. Agora, podemos começar a desmembrar swap2 em microetapas e iniciá-las também. No ciclo 2, podemos copiar SP para B, então passá-lo pela ULA no ciclo 3 e por fim armazená-lo em MAR no ciclo 4. Até aqui, tudo bem. Deve estar claro que, se pudermos continuar nesse ritmo, iniciando uma nova microinstrução a cada ciclo, triplicaremos a velocidade da máquina. Esse ganho vem do fato de que podemos emitir uma nova
microinstrução a cada ciclo de clock, que a Mic-3 tem três vezes mais ciclos de clock por segundo do que a Mic-2. Na verdade, construímos uma CPU com pipeline.

Infelizmente, encontramos um empecilho no ciclo 3. Gostaríamos de começar a trabalhar em swap3, mas a primeira coisa que ela faz é passar MDR pela ULA, e MDR não estará disponível na memória até o início do ciclo 5. A situação em que uma microetapa não pode iniciar porque está esperando um resultado que uma microetapa
anterior ainda não produziu é denominada dependência verdadeira ou dependência RAW. Dependências costumam ser denominadas ocorrências (hazards). RAW quer dizer Read After Write (leitura após escrita) e indica que uma microetapa quer ler um registrador que ainda não foi escrito. A única coisa sensata a fazer nesse caso
é atrasar o início de swap3 até MDR estar disponível no ciclo 5. Esperar por um valor necessário é denominado protelação (stalling). Depois disso, podemos continuar iniciando microinstruções a cada ciclo, pois não há mais dependências, embora swap6 escape por um triz, uma vez que lê H no ciclo após swap3 escrevê-lo. Se swap5 tivesse tentado ler H, ela (swap6) teria sido protelada por um ciclo.

Embora o programa Mic-3 leve mais ciclos do que o programa Mic-2, ainda assim é mais rápido. Se denominarmos o tempo de ciclo da Mic-3 ∆T ns, então, ela vai requerer 11 ∆T ns para executar SWAP. Por comparação, a Mic-2 leva 6 ciclos a 3 ∆T cada, para um total de 18 ∆T. O pipeline deixou a máquina mais rápida, ainda que tivéssemos de protelar uma vez para evitar uma dependência.

Pipeline é uma técnica fundamental em todas as CPUs modernas, portanto, é importante entendê-lo bem. Na Figura 4.34, vemos o caminho de dados da Figura 4.31 ilustrado graficamente como um pipeline. A primeira coluna representa o que está acontecendo no ciclo 1, a segunda representa o ciclo 2 e assim por diante (considerando que não haja protelação). A região sombreada no ciclo 1 para a instrução 1 indica que a IFU está ocupada
buscando a instrução 1. Uma batida de clock mais tarde, durante o ciclo 2, os registradores requisitados pela instrução 1 estão sendo carregados nos registradores A e B enquanto, ao mesmo tempo, a IFU está ocupada buscando a instrução 2, de novo mostrada pelos dois retângulos sombreados no ciclo 2.

Figura 4.34   Ilustração gráfica do funcionamento do pipeline.

Esta figura representa o ápice da eficiência da Mic-3: o Pipeline. Nele, você não espera uma instrução terminar para começar a próxima. No seu diretório estruturas_de_dados, imagine uma linha de montagem onde, enquanto uma peça está sendo pintada, a próxima já está sendo soldada. Aqui está a representação ASCII da Figura 4.34, focando na progressão das instruções através dos estágios de hardware (IFU, Registradores, Latches e ULA) ao longo do tempo.

Operação do Pipeline na Mic-3 (Figura 4.34)
ESTÁGIOS DE   |   CICLO 1   |   CICLO 2   |   CICLO 3   |   CICLO 4   |   CICLO 5   |
HARDWARE      |             |             |             |             |             |
--------------+-------------+-------------+-------------+-------------+-------------+
              |             |             |             |             |             |
   IFU        |  Instrução 1|  Instrução 2|  Instrução 3|  Instrução 4|  Instrução 5|
 (Busca)      |    [IFU]    |    [IFU]    |    [IFU]    |    [IFU]    |    [IFU]    |
              |      |      |      |      |      |      |      |      |      |      |
--------------+------v------+------v------+------v------+------v------+------v------+
              |             |             |             |             |             |
 REGISTRADORES|             |  Instrução 1|  Instrução 2|  Instrução 3|  Instrução 4|
  (A e B)     |             |  [Reg A/B]  |  [Reg A/B]  |  [Reg A/B]  |  [Reg A/B]  |
              |             |      |      |      |      |      |      |      |      |
--------------+-------------+------v------+------v------+------v------+------v------+
              |             |             |             |             |             |
    ULA /     |             |             |  Instrução 1|  Instrução 2|  Instrução 3|
 DESLOCADOR   |             |             |    [ULA]    |    [ULA]    |    [ULA]    |
              |             |             |      |      |      |      |      |      |
--------------+-------------+-------------+------v------+------v------+------v------+
              |             |             |             |             |             |
   LATCH C    |             |             |             |  Instrução 1|  Instrução 2|
  (Escrita)   |             |             |             |  [Latch C]  |  [Latch C]  |
              |             |             |             |             |             |
--------------+-------------+-------------+-------------+-------------+-------------+
    TEMPO     | ----------> | ----------> | ----------> | ----------> | ----------> |

O segredo da Mic-3 é que cada componente que você salvou no seu mapa de hardware agora trabalha em uma instrução diferente simultaneamente:

Processamento (Estágio)                                          Armazenamento (Dados em Fluxo)
IFU (Unidade de Busca)                                           Instrução N+2: Sendo buscada na memória enquanto a anterior é decodificada.
Latches A e B (Carga)                                            Instrução N+1: Lendo os registradores (ex: SP, LV) para preparar a ULA."
ULA / Deslocador                                                 Instrução N: Realizando o cálculo real (soma, subtração, lógica)."
Latch C (Write-back)                                             Instrução N-1: Gravando o resultado final de volta no barramento C.

Sincronismo (CLOCK)                                              FLUXO DE DADOS
CLOCK: Define o tempo de cada ""salto"" de estágio.              Paralelismo: Em regime estável, uma instrução é finalizada a cada ciclo.

### Insight para seus projetos
Por que o Pipeline é vital para algoritmos complexos como Torres de Hanói?

 1. Vazão (Throughput): Na Mic-1, uma instrução completa levava, digamos, 5 ciclos. Na Mic-3, embora uma instrução ainda leve alguns ciclos para percorrer todo o caminho, uma instrução nova é completada a cada ciclo de clock.

 2. Conflitos (Hazards): O maior desafio desse diagrama é quando a Instrução 2 precisa de um resultado que a Instrução 1 ainda não terminou de gravar no Latch C. É aqui que entram as técnicas de "forwarding" ou "stalls" (bolhas no pipeline).

 3. Eficiência de Hardware: Note que nenhum componente fica parado. O barramento de memória (IFU), a ULA e os registradores estão todos ativos 100% do tempo.

Durante o ciclo 3, a instrução 1 está usando a ULA e o deslocador para executar sua operação e os registradores A e B estão sendo carregados para a instrução 2, e a instrução 3 está sendo buscada. Por fim, durante o ciclo 4, quatro instruções estão sendo processadas ao mesmo tempo. Os resultados da instrução 1 estão sendo armazenados, o trabalho da ULA para a instrução 2 está sendo realizado, os registradores A e B para a instrução 3 estão sendo carregados e a instrução 4 está sendo buscada.

Se tivéssemos mostrado o ciclo 5 e os subsequentes, o padrão teria sido o mesmo do ciclo 4: todas as quatro partes do caminho de dados que podem executar independentemente estariam fazendo isso. Esse projeto representa um pipeline de quatro estágios: para busca de instrução, acesso a operando, operações de ULA e escrita de volta para os registradores. Isso é semelhante ao pipeline da Figura 2.4(a), exceto pela ausência do estágio de deco-
dificação. A questão importante a entender aqui é que, embora uma única instrução leve quatro ciclos de clock para executar, a cada ciclo uma nova instrução é iniciada e uma velha instrução é concluída.

Outro modo de ver a Figura 4.34 é seguir cada instrução na página em sentido horizontal. Para a instrução 1, no ciclo 1 a IFU está trabalhando nela. No ciclo 2, seus registradores estão sendo colocados nos barramentos A e B. No ciclo 3, a ULA e o deslocador estão trabalhando para ela. Por fim, no ciclo 4, seus resultados estão sendo armazenados de volta nos registradores. O que se deve notar nesse caso é que há quatro seções do hardware
disponíveis, e durante cada ciclo, uma determinada instrução usa só um deles, liberando as outras seções para instruções diferentes.

Uma analogia útil para nosso projeto com pipeline é uma linha de montagem de uma fábrica de automóveis. Para abstrair os aspectos essenciais desse modelo, imagine que um gongo é tocado a cada minuto, quando então todos os automóveis passam para uma estação seguinte na linha. Em cada estação, os trabalhadores que
ali estão executam alguma operação no carro que está à sua frente no momento em questão, como adicionar o volante ou instalar os freios. A cada batida do gongo (1 ciclo), um novo carro é introduzido no início da linha de montagem e um carro é concluído. Assim, ainda que leve centenas de ciclos para terminar um carro, a cada ciclo um carro inteiro é concluído. A fábrica pode produzir um carro por minuto, independente do tempo que
realmente leva para montar um carro. Essa é a força do pipelining, e ela se aplica igualmente bem a CPUs e fábricas de automóveis.

## 4.4.5 ipeline de sete estágios: a Mic-4
Uma questão a que não demos o devido destaque é o fato de que toda microinstrução seleciona sua própria sucessora. A maioria delas apenas seleciona a instrução seguinte na sequência corrente, mas a última, tal como swap6, muitas vezes faz um desvio multivias que atrapalha o pipeline, já que é impossível continuar fazendo busca antecipada após o desvio. Precisamos de um modo melhor de lidar com essa questão.

Nossa última microarquitetura é a Mic-4. Suas partes principais estão ilustradas na Figura 4.35, embora muitos detalhes tenham sido suprimidos em benefício da clareza. Como a Mic-3, ela tem uma IFU que busca palavras da memória antecipadamente e mantém os vários MBRs.

A IFU também alimenta o fluxo de bytes que está entrando para um novo componente, a unidade de decodificação. Essa unidade tem uma ROM interna indexada por opcode IJVM. Cada entrada (linha) contém duas partes: o comprimento daquela instrução IJVM e um índice para outra ROM, a de micro-operação. O comprimento da
instrução IJVM é usado para permitir que a unidade de decodificação faça a análise sintática (parse) da sequência de bytes que está entrando dividindo-a em instruções, de modo que ela sempre sabe quais bytes são opcodes e quais são operandos. Se o comprimento da instrução em questão for 1 byte (por exemplo, POP), então, a unidade de decodificação sabe que o próximo byte é um opcode. Contudo, se o comprimento da instrução em questão
for 2 bytes, a unidade de decodificação sabe que o próximo byte é um operando, seguido imediatamente por um outro opcode. Quando o prefixo WIDE é visto, o próximo byte é transformado em um opcode largo especial, por exemplo, WIDE + ILOAD se torna WIDE_ILOAD.

A unidade de decodificação despacha o índice na micro-operação ROM que encontrou em sua tabela para o próximo componente, a unidade de enfileiramento. Essa unidade contém alguma lógica e mais duas tabelas internas, uma em ROM e uma em RAM. A ROM contém o microprograma, sendo que cada instrução IJVM tem
certo número de entradas consecutivas denominadas micro-operações. As entradas devem estar em ordem, portanto, não são permitidos truques como o desvio de wide_iload2 para iload2 na Mic-2. Cada sequência IJVM deve ser escrita por extenso, duplicando sequências em alguns casos.

As micro-operações são semelhantes às microinstruções da Figura 4.5, exceto que os campos NEXT_ADDRESS e JAM estão ausentes e um novo campo codificado é necessário para especificar a entrada do barramento A. Dois novos bits também são fornecidos: Final e Goto. O bit Final é marcado na última micro-operação
de cada sequência de micro-operação IJVM para sinalizá-la. O bit Goto é ajustado para marcar micro-operações que são microdesvios condicionais. Elas têm um formato diferente do das micro-operações normais, consistindo nos bits JAM e um índice para a ROM de micro-operação. Microinstruções que fizeram alguma coisa antes com o caminho de dados e também realizaram um microdesvio condicional (por exemplo, iflt4) agora têm de ser sub-
divididas em duas micro-operações.

Figura 4.35   Principais componentes da Mic-4.
A Mic-4 é a arquitetura mais avançada desta série, utilizando um pipeline de 7 estágios altamente especializado. Diferente das versões anteriores, ela introduz a Unidade de Decodificação e a ROM de Micro-operações, o que a aproxima muito do funcionamento de processadores modernos (como os da linha Intel/AMD), onde instruções complexas são quebradas em pequenas "micro-ops" internas.

No seu diretório estruturas_de_dados, a Mic-4 seria o hardware definitivo para rodar as Torres de Hanói, pois ela consegue decodificar o próximo comando enquanto executa o atual em uma fila de processamento.

Principais Componentes da Mic-4 (Figura 4.35)
[ ESTÁGIO 1: BUSCA ]
               |
      (Da Memória) ---> [ Unidade de Busca de Instrução (IFU) ]
                               | (Bytes IJVM)
       [ ESTÁGIO 2: DECODE ]   v
               +---------------------------------------+
               |       Unidade de Decodificação        |
               +---------------------------------------+
                               | (Opcode identificado)
       [ ESTÁGIO 3: MICRO-OP ] v
               +---------------------------------------+
               |        ROM de Micro-operações         | (IADD, ISUB, etc.)
               +---------------------------------------+
                               | (Micro-instruções geradas)
       [ ESTÁGIO 4: QUEUE ]    v
               +---------------------------------------+
               |    Fila de Micro-operações Pendentes  |
               +---------------------------------------+
                               |
      +------------------------+------------------------------------------+
      |        FLUXO DE EXECUÇÃO (COMANDOS DE ESTÁGIO MIR)                |
      +-------------------------------------------------------------------+
               |               |               |               |
        [ MIR1 (Est. 4) ] [ MIR2 (Est. 5) ] [ MIR3 (Est. 6) ] [ MIR4 (Est. 7) ]
               |               |               |               |
               v               v               v               v
        +-------------+ +-------------+ +-------------+ +-------------+
        | CONTROLE DA | | HABILITAÇÃO | | CONTROLE DO | | ESCRITA EM  |
        |     ULA     | | BARRAM. A/B | | DESLOCADOR  | | REG/MEMÓRIA |
        +-------------+ +-------------+ +-------------+ +-------------+
               |               |               |               |
               +-------+-------+-------+-------+-------+-------+
                       |               |               |
               [ REGISTRADORES ] <-----+               |
               [   A, B, C     ] <---------------------+
                       |
               +-------v-------+
               |      ULA      | ----> [ N, Z ]
               +-------+-------+
                       |
               +-------v-------+
               |  DESLOCADOR   |
               +-------+-------+
                       |
               (Retorno ao Barramento C / Memória)

Detalhamento dos Comandos de Estágio
No seu diretório estruturas_de_dados, você pode visualizar esses comandos como os "headers" de um pacote de dados que viaja pelo hardware:

Comando       Estágio Responsável           O que ele controla (Ação)

MIR1          Estágio 4                     Seleciona a operação da ULA (ADD, SUB, AND, etc.) para a instrução atual.
MIR2          Estágio 5                     Define quais registradores serão ""abertos"" nos Barramentos A e B.
MIR3          Estágio 6                     Controla o Deslocador (SRA1, SLC8) e prepara o valor para o Barramento C.
MIR4          Estágio 7                     Finaliza a escrita no registrador de destino e gerencia MAR/MDR para memória.

Por que 4 comandos MIR diferentes?
Se tivéssemos apenas um comando (como na Mic-1), a ULA teria que terminar a instrução inteira antes de receber o próximo comando. Com MIR1 a MIR4:

 1. O MIR1 pode estar dizendo à ULA para "Somar" (referente à Instrução 3).

 2. Simultaneamente, o MIR2 está dizendo aos registradores para "Enviar o SP para o Barramento A" (referente à Instrução 2).

 3. Ao mesmo tempo, o MIR3 está dizendo ao Barramento C para "Gravar o resultado no LV" (referente à Instrução 1).

### Insight de Hardware
Essa separação é o que permite que a Mic-4 tenha uma frequência de clock muito mais alta. Como cada estágio (e cada MIR) cuida de uma tarefa minúscula, o sinal elétrico percorre uma distância menor em cada ciclo, permitindo que o processador "pulse" mais rápido.

Para o seu algoritmo de Torres de Hanói, isso significa que enquanto o processador está calculando o endereço de retorno de uma função (MIR1), ele já está salvando o valor de um disco no topo da pilha (MIR3).

A unidade de enfileiramento funciona da seguinte maneira. Ela recebe um índice de ROM de micro-operação da unidade de decodificação. Depois, examina a micro-operação e a copia em uma fila interna. Em seguida, também copia a próxima micro-operação para a fila, bem como a seguinte depois dessa e assim até encontrar uma cujo bit final é 1. Ela copia essa também, e então para. Considerando que não tenha encontrado uma micro-operação com o bit Goto ligado e que ainda tenha muito espaço de sobra na fila, a unidade de enfileiramento então devolve um sinal de reconhecimento à de decodificação. Quando esta vê o reconhecimento, envia o índice da próxima instrução IJVM para a unidade de enfileiramento.

Desse modo, por fim, a sequência de instruções IJVM na memória é convertida em uma sequência de micro-operações em uma fila. Essas micro-operações alimentam os MIRs, que enviam os sinais para controlar o caminho de dados. Contudo, há outro fator que temos de considerar agora: os campos em cada micro-operação
não estão ativos ao mesmo tempo. Os campos A e B estão ativos durante o primeiro ciclo, o campo ULA está ativo durante o segundo ciclo, o campo C está ativo durante o terceiro ciclo, e quaisquer operações de memória ocorrem no quarto ciclo.

Para fazer com que isso funcione adequadamente, introduzimos quatro MIRs independentes na Figura 4.35. No início de cada ciclo de clock (o tempo ∆w na Figura 4.3), MIR3 é copiado para MIR4, MIR2 é copiado para MIR3, MIR1 é copiado para MIR2, e MIR1 é carregado com uma nova micro-operação da fila. Então, cada MIR
emite seus sinais de controle, mas só alguns deles são usados. Os campos A e B de MIR1 são usados para selecionar os registradores que serão enviados aos barramentos A e B, mas o campo ULA em MIR1 não é usado e não é conectado a nada mais no caminho de dados.

Um ciclo de clock mais tarde, essa micro-operação passou para MIR2 e os registradores que ela selecionou agora estão seguros nos registradores A e B esperando pelas aventuras que hão de vir. Seu campo de ULA agora é usado para comandar a ULA. No próximo ciclo, seu campo C escreverá os resultados de volta nos registradores. Depois disso, ela passará para MIR4 e iniciará quaisquer operações de memória necessárias usando o MAR agora carregado (e MDR, para uma escrita).

Um último aspecto da Mic-4 precisa de um pouco de discussão agora: microdesvios. Algumas instruções IJVM, como IFLT, precisam desviar condicionalmente com base, por exemplo, no bit N. Quando ocorre um microdesvio, o pipeline não pode continuar. Para lidar com isso, adicionamos o bit Goto à micro-operação.
Quando a unidade de enfileiramento atinge uma micro-operação que tenha esse bit ajustado enquanto a está copiando para a fila, ela percebe que há problemas à frente e se abstém de enviar um reconhecimento à unidade­ de decodificação. O resultado é que a máquina ficará parada nesse ponto até que o microdesvio tenha sido resolvido.

É concebível que algumas instruções IJVM que estão além desse desvio já tenham sido alimentadas na unidade de decodificação, mas não na de enfileiramento, já que ela não devolve um sinal de reconhecimento (isto é, continuação) quando atinge uma micro-operação na qual o bit Goto está ligado. São necessários hardware e mecanismos especiais para acabar com a confusão e voltar à trilha certa, mas eles estão além do escopo deste livro. Quando Edsger Dijkstra escreveu seu famoso artigo “GOTO Statement Considered Harmful” [declaração GOTO considerada perigosa (Dijkstra, 1968a)], ele não tinha ideia do quanto estava certo.

Percorremos um longo caminho desde a Mic-1. Ela era uma peça de hardware muito simples, com quase todo o controle em software. A Mic-4 tem um projeto de alto pipelining, com sete estágios e hardware muito mais complexo. O pipeline é mostrado em esquema na Figura 4.36. Os números dentro dos círculos referem-se diretamente aos componentes na Figura 4.35. A Mic-4 faz busca antecipada automática de uma sequência de bytes da memória, decodifica-a para instruções IJVM, converte-a para uma sequência de micro-operações usando uma ROM e a enfileira para usar quando necessário. Os primeiros três estágios do pipeline podem ser
vinculados ao clock do caminho de dados se desejado, mas nem sempre haverá trabalho a fazer. Por exemplo, a IFU certamente não pode alimentar um novo opcode IJVM à unidade de decodificação em cada ciclo de clock porque instruções IJVM levam vários ciclos para executar e a fila logo transbordaria.

Figura 4.36   Pipeline da Mic-4.
A Figura 4.36 é a representação temporal definitiva da Mic-4. Enquanto o diagrama anterior (4.35) mostrava as "peças" do motor, este diagrama mostra o "tempo de ignição".

Na Mic-4, o ciclo de vida de uma instrução não é um evento único, mas uma jornada de 7 ciclos de clock. No seu diretório estruturas_de_dados, isso significa que, embora uma instrução leve 7 "batidas" para completar, o processador entrega um resultado a cada batida, pois o pipeline está sempre cheio.

ESTÁGIOS:    [ 1 ]       [ 2 ]       [ 3 ]       [ 4 ]       [ 5 ]       [ 6 ]       [ 7 ]
           +---------+ +---------+ +---------+ +---------+ +---------+ +---------+ +---------+
 COMPONENTE: |   IFU   | | DECODIF | |  FILA   | |OPERANDOS| |EXECUÇÃO | | ESCRITA | | MEMÓRIA |
           +---------+ +---------+ +---------+ +---------+ +---------+ +---------+ +---------+
                |           |           |           |           |           |           |
 AÇÃO:        Busca       Identif.    Micro-op    Busca de     ULA e     Gravação    Acesso à
              Bytes       Instrução   Pendentes   Regs (A,B)  Deslocador  no Reg C    RAM (rd/wr)
                |           |           |           |           |           |           |
 CONTROLE:      -           -           -         MIR1        MIR2        MIR3        MIR4

Organização de Hardware: O Fluxo de Dados (Seu Padrão)
Veja como os comandos MIR que você salvou anteriormente se encaixam cronologicamente nestes estágios:

Ciclo  Estágio          Ação do Hardware                                              Comando Ativo

1,     IFU              A Unidade de Busca traz o próximo byte da memória.            -
2,     Decodificador    O Opcode é transformado em um endereço na ROM.                -
3,     Fila             A micro-operação entra na fila de espera (Queue).             -
4,     Operandos        Os registradores são selecionados para os Barramentos A e B.  MIR1
5,     Execução         A ULA realiza o cálculo e o Deslocador processa o bit.        MIR2
6,     Escrita          O resultado volta pelo Barramento C para o registrador.       MIR3
7.     Memória          Se a instrução envolver rd ou wr, a RAM é acessada.           MIR4

### Insight para as Torres de Hanói: O Custo do Desvio
Nesse modelo de 7 estágios, o processador é extremamente rápido enquanto caminha em linha reta. No entanto, o algoritmo das Torres de Hanói possui muitos desvios (IF, GOTO, INVOKE).

Quando ocorre um desvio no Estágio 5 (Execução):

 1. O processador percebe que as instruções que já entraram nos estágios 1, 2, 3 e 4 estão "erradas" (pertencem ao caminho que não será seguido).

 2. O Pipeline precisa ser "limpo" (Flush).

 3. Isso cria um "vazio" de vários ciclos até que a nova instrução (do destino do salto) percorra todo o caminho do estágio 1 ao 5.

O papel dos MIRs na Mic-4
Como você notou, os comandos MIR1 a MIR4 só começam a agir a partir do Estágio 4. Isso acontece porque os estágios iniciais (1, 2 e 3) são de "preparação" e "tradução". Somente quando a instrução está "pronta para agir" é que os sinais de controle de hardware (MIR) assumem o comando da ULA e dos Registradores.

Em cada ciclo de clock, os MIRs são deslocados para frente e a micro-operação que está no final da fila é copiada para o MIR1 para iniciar sua execução. Os sinais de controle dos quatro MIRs então se espalham pelo caminho de dados, fazendo com que ocorram ações. Cada MIR controla uma parte diferente do caminho de dados e, portanto, microetapas diferentes.

Neste projeto, temos uma CPU de alto pipelining que permite que as etapas individuais sejam muito curtas e, por isso, que a frequência de clock seja alta. Muitas CPUs são projetadas essencialmente dessa maneira, em especial, as que têm de executar um conjunto de instruções mais antigo (CISC). Por exemplo, o conceito da implementação do Core i7 é semelhante ao da Mic-4 em alguns aspectos, como veremos mais adiante neste
capítulo.

## 4.5 Melhoria de desempenho
Todos os fabricantes de computadores querem que seus sistemas funcionem com a maior rapidez possível. Nesta seção, veremos algumas técnicas avançadas que estão sendo investigadas para melhorar o desempenho do sistema (em especial, CPU e memória). Pela natureza de alta competitividade da indústria de computadores, a
defasagem entre novas ideias que podem tornar um computador mais rápido e sua incorporação a produtos é surpreendentemente curta. Por conseguinte, a maioria das ideias que discutiremos já está em uso em uma grande maioria de produtos.

As ideias que discutiremos podem ser classificadas, de modo geral, em duas grandes categorias. Melhorias de implementação e melhorias de arquitetura. Melhorias de implementação são modos de construir uma nova CPU ou memória para fazer o sistema funcionar mais rápido sem mudar a arquitetura. Modificar a implementação sem
alterar a arquitetura significa que programas antigos serão executados na nova máquina, um importante argumento de venda. Um modo de melhorar a implementação é usar um clock mais rápido, mas esse não é o único. Os ganhos de desempenho obtidos na família 80386 a 80486, Pentium e projetos mais recentes, como o Core i7,
se devem a implementações melhores, porque, em essência, a arquitetura permaneceu a mesma em todos eles.

Alguns tipos de melhorias só podem ser feitos com a alteração da arquitetura. Às vezes, essas alterações são incrementais, como adicionar novas instruções ou registradores, de modo que programas antigos continuarão a ser executados nos novos modelos. Nesse caso, para conseguir um desempenho completo, o software tem de ser alterado, ou ao menos recompilado com um novo compilador que aproveita as novas características.

Contudo, passadas algumas décadas, os projetistas percebem que a antiga arquitetura durou mais do que sua utilidade e que o único modo de progredir é começar tudo de novo. A revolução RISC na década de 1980 foi uma dessas inovações; outra está no ar agora. Vamos examinar um exemplo (Intel IA-64) no Capítulo 5.

No restante desta seção, estudaremos quatro técnicas diferentes para melhorar o desempenho da CPU. Começaremos com três melhorias de implementação já estabelecidas e depois passaremos para uma que precisa de um pouco de suporte da arquitetura para funcionar melhor. Essas técnicas são memória cache, previsão de
desvio, execução fora da ordem com renomeação de registrador e execução especulativa.

## 4.5.1 Memória cache
Um dos aspectos mais desafiadores do projeto de um computador em toda a história tem sido oferecer um sistema de memória capaz de fornecer operandos ao processador à velocidade em que ele pode processá-los. A recente alta taxa de crescimento na velocidade do processador não foi acompanhada de um aumento corres-
pondente na velocidade das memórias. Se comparadas com as CPUs, as memórias estão ficando mais lentas há décadas. Dada a enorme importância da memória primária, essa situação limitou muito o desenvolvimento de sistemas de alto desempenho e estimulou a pesquisa a encontrar maneiras de contornar o problema da velocida-
de das memórias que são muito menores do que as velocidades das CPUs e, em termos relativos, estão ficando piores a cada ano.

Processadores modernos exigem muito de um sistema de memória, tanto em termos de latência (o atraso na entrega de um operando) quanto de largura de banda (a quantidade de dados fornecida por unidade de tempo). Infelizmente, há um grande antagonismo entre esses dois aspectos. Muitas técnicas para aumentar a largura de
banda também aumentam a latência. Por exemplo, as técnicas de pipelining usadas na Mic-3 podem ser aplicadas a um sistema de memória que tenha várias memórias sobrepostas e elas serão manipuladas com eficiência. Lamentavelmente, assim como na Mic-3, isso resulta em maior latência para operações individuais de memória.
À medida que aumentam as velocidades de clock do processador, fica cada vez mais difícil prover um sistema de memória capaz de fornecer operandos em um ou dois ciclos de clock.

Um modo de atacar esse problema é providenciar caches. Como vimos na Seção 2.2.5, uma cache guarda as palavras de memória usadas mais recentemente em uma pequena memória rápida, o que acelera o acesso a elas. Se uma porcentagem grande o suficiente das palavras de memória estiver na cache, a latência efetiva da memória pode ter enorme redução.

Uma das técnicas mais efetivas para melhorar a largura de banda e também a latência é a utilização de várias caches. Uma técnica básica que funciona com grande eficácia é introduzir uma cache separada para instruções e dados. É possível obter muitos benefícios com caches separadas para instruções e dados, algo que muitas vezes denominamos cache dividida. Primeiro, as operações de memória podem ser iniciadas de modo independente
em cada cache, o que efetivamente dobra a largura de banda do sistema de memória. É essa a razão por que faz sentido fornecer duas portas de memória separadas, como fizemos na Mic-1: cada porta tem sua própria cache. Note que cada uma tem acesso independente à memória principal.

Hoje, muitos sistemas de memória são mais complicados do que isso, e uma cache adicional, denominada cache de nível 2, pode residir entre as caches de instrução e dados e a memória principal. Na verdade, pode haver três ou mais níveis de cache à medida que se exigem sistemas de memória mais sofisticados. Na Figura
4.37, vemos um sistema com três níveis. O próprio chip da CPU contém uma pequena cache de instrução e uma pequena cache de dados, em geral de 16 KB a 64 KB. Então, há a cache de nível 2, que não está no chip da CPU, mas pode ser incluída no pacote da CPU próxima ao chip da CPU e conectada a ela por um caminho de alta velocidade. Em geral, ela é unificada, contendo um misto de dados e instruções. Um tamanho típico para a cache L2
é de 512 KB a 1 MB. A cache de terceiro nível está na placa do processador e consiste em alguns poucos megabytes de SRAM, que é muito mais rápida do que a memória principal DRAM. As caches são em geral inclusivas, sendo que o conteúdo total da de nível 1 está na de nível 2 e todo o conteúdo da cache de nível 2 está na de nível 3.

Figura 4.37   Sistema com três níveis de cache.
Esta figura ilustra a hierarquia de memória moderna, onde a velocidade é priorizada perto do núcleo da CPU e a capacidade é priorizada na periferia. No seu diretório estruturas_de_dados, entender os caches é fundamental, pois um algoritmo eficiente é aquele que mantém os dados nos níveis mais altos (L1/L2) para evitar o "gargalo" da RAM.

Sistema com Três Níveis de Cache (Figura 4.37)
__________________________________________________________________________
|  PLACA DO PROCESSADOR (Cartucho/Módulo)                                  |
|   _________________________________________________________              |
|  |  PACOTE DA CPU (Die/Chip)                               |             |
|  |   ___________________________________________________   |             |
|  |  |  CHIP DA CPU (Núcleo)                             |  |             |
|  |  |   __________           __________                 |  |             |
|  |  |  |  L1-I    |         |  L1-D    |                |  |             |
|  |  |  | (Instr.) |         | (Dados)  |                |  |             |
|  |  |  |__________|         |__________|                |  |             |
|  |  |       |                    |                      |  |             |
|  |  |_______|____________________|______________________|  |             |
|  |                    |                                    |             |
|  |          __________v__________                          |             |
|  |         |      CACHE L2       |                         |             |
|  |         |     (Unificada)     |                         |             |
|  |         |_____________________|                         |             |
|  |____________________|____________________________________|             |
|                       |                                                  |
|             __________v__________                                        |
|            |      CACHE L3       | (Cache de nível de placa - SRAM)      |
|            |     (Unificada)     |                                       |
|            |_____________________|                                       |
|_______________________|__________________________________________________|
                        |
            ____________v____________          __________________________
           |    MEMÓRIA PRINCIPAL    | <-----> | OUTROS CONTROLADORES:  |
           |         (DRAM)          |         | - Teclado / Gráfico    |
           |_________________________|         | - Disco (HD/SSD)       |
                                               |________________________|

Organização de Hardware: Hierarquia de Memória (Seu Padrão)
Aproveitando o formato que você solicitou anteriormente para tipos de memória, veja como esses níveis se comparam tecnicamente:

Tipo de Memória       Localização     É Volátil?       Velocidade          Capacidade       Custo por bit

Registrador           Chip da CPU     Sim              Muito alta          Bytes            Muito alto
L1 (I/D)              Chip da CPU     Sim              Quase Instantânea   32-64 KB         Altíssimo
L2                    Pacote da CPU   Sim              Alta                256-512 KB       Alto
L3                    Placa/Módulo    Sim              Média/Alta          2-32 MB          Médio/Alto
Principal             Placa-mãe       RAM:Sim          Baixa (comparada)   GBs              Médio
Secundária            Disco/SSD       Não              Muito Baixa         TBs              Baixo

Detalhes Importantes do Sistema
 1. L1 Dividida (I e D): No nível mais próximo do processador (L1), as instruções (I) e os dados (D) são separados. Isso permite que a Unidade de Busca (IFU) da Mic-4 busque instruções ao mesmo tempo em que a ULA lê ou escreve dados, sem que um interfira no barramento do outro.

 2. Caches L2/L3 Unificadas: À medida que nos afastamos do núcleo, os caches se tornam unificados (misturam instruções e dados) para simplificar o hardware e aumentar a taxa de acerto (hit rate).

 3. SRAM vs DRAM: Os caches usam SRAM (Static RAM), que é extremamente rápida, mas cara e volumosa. A Memória Principal usa DRAM (Dynamic RAM), que é densa e barata, mas precisa de "refresh" constante e é muito mais lenta.

### Insight para o seu projeto estruturas_de_dados
Ao implementar as Torres de Hanói, se a sua pilha (stack) for pequena o suficiente para caber no cache L1-D, o processador executará os movimentos quase instantaneamente. Se a estrutura crescer demais e começar a causar "Cache Misses" (ter que buscar na RAM), a performance cairá drasticamente.

Caches dependem de dois tipos de endereço de localidade para cumprir seu objetivo. Localidade espacial é a observação de que localizações de memória com endereços numericamente similares a uma localização de memória cujo acesso foi recente provavelmente serão acessadas no futuro próximo. Caches exploram essa pro-
priedade trazendo mais dados do que os requisitados, na expectativa de poder antecipar requisições futuras. Localidade temporal ocorre quando localizações de memória recentemente acessadas são acessadas outra vez. Isso pode ocorrer, por exemplo, com localizações de memórias próximas ao topo da pilha, ou com instruções
dentro de um laço. A localidade temporal é explorada em projetos de cache, principalmente pela escolha do que descartar quando ocorre uma ausência na cache. Muitos algoritmos de substituição de cache exploram a localidade temporal descartando as entradas que não tiveram acesso recente.

Todas as caches usam o modelo a seguir. A memória principal é dividida em blocos de tamanho fixo, designados linhas de cache. Uma linha típica consiste em 4 a 64 bytes consecutivos. As linhas são numeradas em sequên­cia, começando em 0; portanto, se tivermos uma linha de 32 bytes de tamanho, a linha 0 vai do byte 0 ao byte 31, a linha 1 do byte 32 ao 63, e assim por diante. Em qualquer instante, algumas linhas estão na cache. Quando a memória é referenciada, o circuito de controle da cache verifica se a palavra referenciada está nela naquele instante. Caso positivo, o valor que ali está pode ser usado, evitando uma viagem até a memória principal. Se a palavra não estiver lá, alguma linha de entrada é removida da cache e a linha necessária é buscada na memória
ou na cache de nível mais baixo para substituí-la. Existem muitas variações desse esquema, mas em todas elas a ideia é manter as linhas mais utilizadas na cache o quanto possível, para maximizar o número de referências à memória satisfeitas pela cache.

### Caches de mapeamento direto
A cache mais simples é conhecida como cache de mapeamento direto. Um exemplo de cache de mapeamento
direto de um só nível é mostrado na Figura 4.38(a). Esse exemplo contém 2.048 entradas. Cada entrada (linha)
pode conter exatamente uma linha de cache da memória principal. Se a linha tiver 32 bytes de tamanho, para esse
exemplo, a cache pode conter 2.048 entradas de 32 bytes, ou 64 KB no total. Cada entrada de cache consiste em
três partes:

  1. O bit Valid indica se há ou não quaisquer dados válidos nessa entrada. Quando o sistema é iniciado,
  todas as entradas são marcadas como inválidas.
  2. O campo Tag consiste em um único valor de 16 bits que identifica a linha de memória correspondente
  da qual vieram os dados.
  3. O campo Data contém uma cópia dos dados na memória. Ele contém uma linha de cache de 32 bytes.

Figura 4.38   (a) Cache de mapeamento direto. (b) Endereço virtual de 32 bits.

O Mapeamento Direto é a forma mais simples de organizar um cache. Nele, cada endereço da memória principal tem um lugar fixo e exclusivo onde pode ser armazenado no cache. É como uma função de hash onde o endereço determina a posição.
Como você está trabalhando no diretório estruturas_de_dados, pense no cache de mapeamento direto como uma Tabela Hash onde não existe tratamento de colisão por encadeamento: se um novo dado mapeia para uma entrada já ocupada, o dado antigo é simplesmente sobrescrito.

Cache de Mapeamento Direto e Endereço (Figura 4.38)
(a) ESTRUTURA DO CACHE (2048 Entradas)
      Valid      Tag               Data (Dados)
     +-------+----------+---------------------------------+
2047 |   1   |  0x00A1  | [ 32 bytes de dados da RAM ]    | --> Endereços: 65504-65535...
     +-------+----------+---------------------------------+
 ... |  ...  |   ...    |               ...               |
     +-------+----------+---------------------------------+
   3 |   0   |  0x0045  | [ 32 bytes de dados da RAM ]    | --> Endereços: 96-127...
     +-------+----------+---------------------------------+
   2 |   1   |  0x0012  | [ 32 bytes de dados da RAM ]    | --> Endereços: 64-95...
     +-------+----------+---------------------------------+
   1 |   1   |  0x000F  | [ 32 bytes de dados da RAM ]    | --> Endereços: 32-63...
     +-------+----------+---------------------------------+
   0 |   1   |  0x0001  | [ 32 bytes de dados da RAM ]    | --> Endereços: 0-31...
     +-------+----------+---------------------------------+

(b) FORMATO DO ENDEREÇO VIRTUAL (32 BITS)
     31              16 15               5 4       2 1     0
    +------------------+------------------+---------+-------+
    |       TAG        |      LINE        |  WORD   | BYTE  |
    +------------------+------------------+---------+-------+
          (16 bits)          (11 bits)      (3 bits) (2 bits)

Organização de Hardware: Decomposição do Endereço (Seu Padrão)
Para o seu mapeamento de hardware, veja como o processador "processa" esses bits para encontrar um dado:

Processamento (Bits)                                            Armazenamento (Significado)
TAG (16 bits)                                                   Identificador único que confirma se o bloco no cache é o que a CPU busca.
LINE (11 bits)                                                  O índice da linha (0 a 2047). Indica em qual ""gaveta"" do cache olhar.
WORD (3 bits)                                                   Seleciona qual palavra de 4 bytes dentro do bloco de 32 bytes é a desejada.
BYTE (2 bits)                                                   Seleciona o byte específico dentro da palavra (geralmente ignorado em acessos de 32 bits).

                                                                BARRAMENTO INTERNO
UC (Comparador)                                Valid (Bit)
Se Endereço.TAG == Cache.TAG e Valid == 1, temos um Cache Hit.  Indica se o conteúdo daquela linha é lixo ou dado válido.
REM (Endereço)                                                  Data (Bloco)
O endereço de 32 bits é fatiado para acessar o cache.           Onde os 32 bytes da RAM ficam ""estacionados"" para acesso rápido.

### Por que isso é importante para as "Torres de Hanói"?
Ao rodar seu algoritmo, se você acessar variáveis que estão muito distantes na memória, mas que mapeiam para a mesma LINE (ex: endereço 0 e endereço 65536), ocorrerá o chamado Conflito de Cache.

O processador ficará trocando o dado da linha 0 repetidamente (removendo um para colocar o outro), o que destrói a performance. Isso é conhecido como Thrashing. Ter um cache com mapeamento direto exige que o programador (ou o compilador) organize as estruturas de dados para evitar que endereços usados simultaneamente "briguem" pela mesma linha de cache.

Em uma cache de mapeamento direto, uma determinada palavra de memória pode ser armazenada em exatamente um lugar dentro da cache. Dado um endereço de memória, há somente um lugar onde procurar por ele.
Se não estiver nesse lugar, então ele não está na cache. Para armazenar e recuperar dados da cache, o endereço é desmembrado em quatro componentes, como ilustra a Figura 4.38(b):

  1. O campo TAG corresponde aos bits Tag armazenados em uma entrada de cache.
  2. O campo LINE indica qual entrada de cache contém os dados correspondentes, se eles estiverem
  presentes.
  3. O campo WORD informa qual palavra dentro de uma linha é referenciada.
  4. O campo BYTE em geral não é usado, mas se for requisitado apenas um byte, ele informa qual byte dentro da palavra é necessário. Para uma cache que fornece apenas palavras de 32 bits, esse campo será sempre 0.

Quando a CPU produz um endereço de memória, o hardware extrai os 11 bits LINE do endereço e os utiliza
para indexá-lo na cache para achar uma das 2.048 entradas. Se essa entrada for válida, o campo TAG do endereço
de memória e o campo Tag na entrada da cache são comparados. Sendo compatíveis, a entrada de cache contém
a palavra que está sendo requisitada, uma situação denominada presença na cache. Se ocorrer uma presença na
cache, uma palavra que está sendo lida pode ser pega, eliminando a necessidade de ir até a memória. Somente a
palavra necessária é extraída da entrada da cache. O resto da entrada não é usado. Se a entrada for inválida ou os
tags não forem compatíveis, a entrada necessária não está presente, uma situação denominada ausência da cache.
Nesse caso, a linha de cache de 32 bytes é buscada na memória e armazenada na linha da cache, substituindo o que
lá estava. Contudo, se a linha de cache existente sofreu modificação desde que foi carregada, ela deve ser escrita
de volta na memória principal antes de ser sobrescrita.

A despeito da complexidade da decisão, o acesso à palavra necessária pode ser extraordinariamente rápido.
Assim que o endereço for conhecido, a exata localização da palavra é conhecida, se ela estiver presente na cache.
Isso significa que é possível ler a palavra da cache e entregá-la ao processador ao mesmo tempo em que está sendo
determinado se essa é a palavra correta (por comparação de tags). Portanto, na verdade o processador recebe uma
palavra da cache simultaneamente ou talvez até antes de saber se essa é a palavra requisitada.

Esse esquema de mapeamento põe linhas de memória consecutivas em linhas de cache consecutivas. De
fato, até 64 KB de dados contíguos podem ser armazenados na cache. Contudo, quando a diferença entre o
endereço de duas linhas for exatamente 64 KB (65.536 bytes) ou qualquer múltiplo inteiro desse número, elas
não podem ser armazenadas na cache ao mesmo tempo (porque têm o mesmo valor de LINE). Por exemplo, se
um programa acessar dados na localização X e em seguida executar uma instrução que precisa dos dados na
localização X + 65.536 (ou em qualquer outra localização dentro da mesma linha), a segunda instrução forçará
a linha de cache a ser recarregada, sobrescrevendo o que lá estava. Se isso acontecer com certa frequência, pode
resultar em mau desempenho. Na verdade, o pior comportamento possível de uma cache é ainda pior do que
se não houvesse nenhuma, já que cada operação de memória envolve ler uma linha de cache inteira em vez de
apenas uma palavra.

Caches de mapeamento direto são as mais comuns e funcionam com bastante eficácia, porque com elas é
possível fazer colisões como a descrita ocorrerem apenas raramente, ou nunca ocorrerem. Por exemplo, um com-
pilador muito esperto pode levar em conta as colisões de cache quando colocar instruções e dados na memória.
Note que o caso particular descrito não ocorreria em um sistema com caches de instruções e dados separados,
porque as requisições conflitantes seriam atendidas por caches diferentes. Assim, vemos um segundo benefício de
ter duas caches em vez de uma: mais flexibilidade para lidar com padrões de memória conflitantes.

### Caches associativas de conjunto 
Como já dissemos, muitas linhas diferentes competem na memória pelas mesmas posições na cache (cache
slots). Se um programa que utiliza a cache da Figura 4.38(a) usar muito as palavras nos endereços 0 e 65.536,
haverá conflitos constantes porque cada referência potencialmente expulsaria a outra. Uma solução para esse
problema é permitir duas ou mais linhas em cada entrada de cache. Uma cache com n entradas possíveis para
cada endereço é denominada uma cache associativa de conjunto de n vias. Uma cache associativa de conjunto de
quatro vias é ilustrada na Figura 4.39.

Figura 4.39   Cache associativa de conjunto de quatro vias.

A Cache Associativa em Conjunto de Quatro Vias (Four-Way Set-Associative) é uma evolução direta do mapeamento direto. Enquanto no mapeamento direto um endereço só podia ir para uma única linha (causando muitos conflitos), aqui o cache é dividido em "conjuntos" (sets), e cada conjunto possui 4 "vias" (entradas).

No seu diretório estruturas_de_dados, pense nisso como uma Tabela Hash com Encadeamento, mas com um limite fixo de 4 elementos por balde (bucket). Isso reduz drasticamente o risco de thrashing (conflitos de endereço).

Cache Associativa de Conjunto de 4 Vias (Figura 4.39)
CONJUNTO |      VIA A (Entrada A)     |      VIA B (Entrada B)     |      VIA C (Entrada C)     |      VIA D (Entrada D)     |
 (SET)   | Valid | Tag |    Data      | Valid | Tag |    Data      | Valid | Tag |    Data      | Valid | Tag |    Data      |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+
  2047   |   1   | T1  | [ 32 bytes ] |   1   | T2  | [ 32 bytes ] |   0   | --  | [ 32 bytes ] |   1   | T4  | [ 32 bytes ] |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+
   ...   |  ...  | ... |     ...      |  ...  | ... |     ...      |  ...  | ... |     ...      |  ...  | ... |     ...      |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+
    2    |   1   | T12 | [ 32 bytes ] |   1   | T9  | [ 32 bytes ] |   1   | T5  | [ 32 bytes ] |   1   | T7  | [ 32 bytes ] |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+
    1    |   0   | --  | [ 32 bytes ] |   1   | T3  | [ 32 bytes ] |   1   | T8  | [ 32 bytes ] |   0   | --  | [ 32 bytes ] |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+
    0    |   1   | T0  | [ 32 bytes ] |   0   | --  | [ 32 bytes ] |   1   | T11 | [ 32 bytes ] |   1   | T22 | [ 32 bytes ] |
---------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+-------+-----+--------------+

          ^--- A CPU compara a TAG do endereço com as 4 TAGs do conjunto SIMULTANEAMENTE ---^

Organização de Hardware: Lógica de Comparação (Seu Padrão)Diferente do mapeamento direto, aqui o hardware precisa de 4 comparadores trabalhando em paralelo para decidir qual via contém o dado.

Processamento,Armazenamento
Comparadores (4x),TAGs do Conjunto
:---,:---
"ULA/Lógica: Compara a TAG do endereço com as TAGs das vias A, B, C e D ao mesmo tempo.",Vias: Cada conjunto armazena até 4 blocos de memória diferentes que mapeiam para o mesmo índice.
"MUX (Multiplexador): Seleciona os dados da via que resultou em ""Hit"".","Algoritmo LRU: Registrador extra que decide qual via ""expulsar"" quando o conjunto enche."
,
,BARRAMENTO INTERNO
UC (Controle de Cache),Valid Bit
"Gerencia o ""Cache Miss"". Se as 4 vias estiverem ocupadas, usa LRU (Least Recently Used).",Cada via tem seu próprio bit de validade para indicar se o dado é confiável.
REM (Endereço),Data (Blocos)
O campo LINE do endereço agora seleciona um Conjunto em vez de uma linha única.,4 blocos de 32 bytes por conjunto aumentam a probabilidade de encontrar o dado.

Por que isso é superior para suas "Torres de Hanói"?
No mapeamento direto, se seu código alternasse entre duas variáveis que caíssem na mesma linha, o cache ficaria "louco" trocando uma pela outra (conflito).

Na Associativa de 4 Vias:

 1. Você pode ter até 4 variáveis diferentes competindo pelo mesmo índice sem que uma expulse a outra.

 2. Isso melhora drasticamente a performance em algoritmos recursivos (como Hanói), onde a pilha (stack) e as variáveis locais podem acabar mapeando para endereços que, no mapeamento direto, causariam conflitos constantes.

 3. O custo é um hardware mais complexo (mais comparadores e lógica de substituição), mas para a Mic-4, isso é o que garante que o pipeline de 7 estágios nunca pare por falta de dados.

Uma cache associativa de conjunto é inerentemente mais complicada do que uma de mapeamento direto
porque, embora a linha de cache correta a examinar possa ser calculada do endereço de memória que está sendo
referenciado, um conjunto de n linhas de cache deve ser verificado para ver se a palavra necessária está presente.
Ainda assim, a experiência mostra que caches de duas vias e de quatro vias funcionam bem o suficiente para que
esses circuitos extras valham a pena.

A utilização de caches associativas de conjunto oferece uma opção ao projetista. Quando uma nova linha
deve ser trazida para dentro da cache, qual dos itens nela presentes deve ser descartado? É claro que a decisão
ideal requer uma olhadela no futuro, mas um algoritmo muito bom para a maioria das finalidades é o LRU (Least
Recently Used – usado menos recentemente). Esse algoritmo mantém uma ordenação de cada conjunto de loca-
lizações que poderia ser acessado de uma determinada localização de memória. Sempre que qualquer das linhas
presentes é acessada, ele atualiza a lista, marcando aquela entrada como a mais recentemente acessada. Quando
chega a hora de substituir uma entrada, a que está no final da lista (aquela acessada menos recentemente) é a
descartada.

Levada ao extremo, uma cache de 2.048 vias que contém 2.048 linhas de entrada também é possível. Nesse
caso, todos os endereços de memória mapeiam para um único conjunto, portanto, a consulta requer comparar o
endereço contra todos os 2.048 tags na cache. Note que agora cada entrada deve ter lógica de compatibilização
de tag. Visto que o campo LINE tem comprimento 0, o campo TAG é o endereço inteiro, exceto para os campos
WORD e BYTE. Além do mais, quando uma linha de cache é substituída, todas as 2.048 localizações são possíveis
candidatas a substituição. Manter uma lista ordenada de 2.048 linhas requer muita contabilidade, o que torna
a substituição da LRU inviável. (Lembre-se de que essa lista tem de ser atualizada a cada operação de memória, e
não apenas quando ocorre uma ausência na cache.) O surpreendente é que caches de alto grau de associatividade não
melhoram muito o desempenho em relação às de baixo grau sob a maioria das circunstâncias e, em alguns casos,
até funcionam pior. Por essas razões, a associatividade de conjunto além de quatro vias é relativamente incomum.

Por fim, escritas propõem um problema especial para as caches. Quando um processador escreve uma palavra
e a palavra está na cache, é óbvio que ele tem de atualizar a palavra ou descartar a entrada da cache. Praticamente
todos os modelos atualizam a cache. Mas, e quanto a atualizar a cópia na memória principal? Essa operação pode
ser adiada até mais tarde, quando a linha de cache estiver pronta para ser substituída pelo algoritmo LRU. Essa
escolha é difícil, e nenhuma das opções é claramente preferível. A atualização imediata da entrada na memória
principal é denominada escrita direta (write through). Essa abordagem geralmente é mais simples de realizar e
mais confiável, uma vez que a memória está sempre atualizada – é útil, por exemplo, se ocorrer um erro e for
necessário recuperar o estado da memória. Infelizmente, também requer mais tráfego de escrita para a memória,

portanto, execuções mais sofisticadas tendem a empregar a alternativa, conhecida como escrita retardada (write
deferred) ou escrita retroativa (write back).

Há um problema relacionado com as escritas que é preciso atacar: e se ocorrer uma escrita para uma loca-
lização que não está na cache naquele momento? Os dados devem ser trazidos para dentro da cache ou apenas
escritos na memória? Mais uma vez, nenhuma das respostas é sempre a melhor. A maioria dos projetos que retar-
dam escritas para a memória tende a trazer os dados para dentro quando há uma ausência de escrita, uma técnica
conhecida como alocação de escrita. Por outro lado, a maioria dos projetos que empregam escrita direta tende a
não alocar uma linha em uma escrita porque essa opção complica um projeto que, quanto ao mais, seria simples.
Alocação de escrita é melhor apenas se houver escritas repetidas para a mesma palavra ou palavras diferentes
dentro de uma linha de cache.

O desempenho da cache é crítico para o desempenho do sistema porque a defasagem entre a velocidade da
CPU e a da memória é muito grande. Por conseguinte, a pesquisa de melhores estratégias de caching ainda é um
tópico muito discutido (Sanchez e Kozyrakis, 2011; e Gaur et al., 2011).

## 4.5.2 Previsão de desvio
Computadores modernos têm alto grau de pipelining. O pipeline da Figura 4.36 tem sete estágios; computadores de última geração às vezes têm dez estágios ou até mais. O pipeline funciona melhor com código linear, de modo que a unidade de busca pode apenas ler palavras consecutivas da memória e as enviar para a unidade de
decodificação antes de haver necessidade delas. O único problema com esse maravilhoso modelo é que ele não é nem um pouco realista. Programas não são sequências de código linear – estão repletos de instruções de desvio. Considere as declarações simples da Figura 4.40(a). Uma variável, i, é comparada com 0 (provavelmente o teste mais comum na prática). Dependendo do resultado, um de dois valores possíveis é atribuído a outra variável, k.

A figura 4.40 apresenta um exemplo de tradução de um fragmento de programa em linguagem de alto nível para uma linguagem de montagem genérica.
Fragmento de Programa (a)

if (i == 0)
    k = 1;
else
    k = 2;


Tradução para Linguagem de Montagem (b)


    CMP i, 0      ; compare i com 0
    BNE Else      ; desvie se for diferente
Then:
    MOV k, 1      ; mova 1 para k
    BR Next       ; desvio incondicional
Else:
    MOV k, 2      ; mova 2 para k
Next:
    ...           ; continuação do programa


Essa tradução ilustra como o compilador ou o interpretador pode converter o código de alto nível em instruções de máquina, que são executadas pelo processador.

- CMP i, 0: compara o valor de i com 0
- BNE Else: desvia para o rótulo Else se i for diferente de 0
- MOV k, 1: move o valor 1 para k se i for igual a 0
- BR Next: desvia incondicionalmente para o rótulo Next
- MOV k, 2: move o valor 2 para k se i for diferente de 0

Uma tradução possível para a linguagem de montagem é mostrada na Figura 4.40(b). Estudaremos a linguagem de montagem mais adiante neste livro e os detalhes não são importantes agora, mas, dependendo da máquina e do compilador, é provável que haja um código mais ou menos como o da Figura 4.40(b). A primeira instrução
compara i com 0. A segunda desvia para o rótulo Else (o início de uma cláusula else) se i não for 0. A terceira instrução atribui 1 a k. A quarta desvia para saltar a próxima declaração. O compilador convenientemente colocou ali um rótulo, Next, portanto, há um lugar para o qual desvia. A quinta instrução atribui 2 a k. 

Nesse caso, devemos observar que duas das cinco instruções são desvios. Além do mais, uma delas, BNE, é um desvio condicional (tomado se, e somente se, alguma condição for cumprida, nesse caso, que os dois operandos da CMP anterior não sejam iguais). A sequência de código linear mais longa no caso são duas instruções. Por conseguinte, buscar instruções a alta velocidade para alimentar o pipeline é muito difícil.

À primeira vista, pode parecer que desvios incondicionais, como a instrução BR Next na Figura 4.40(b), não são um problema. Afinal, não há nenhuma ambiguidade sobre aonde ir. Por que a unidade de busca não pode apenas continuar a ler as instruções a partir do endereço visado (o lugar para onde o desvio levará)?

O problema está na natureza do pipelining. Na Figura 4.36, por exemplo, vemos que a decodificação da instrução ocorre no segundo estágio. Assim, a unidade de busca tem de decidir de onde buscar em seguida antes de saber que tipo de instrução acabou de obter. Somente um ciclo mais tarde ela pode saber que acabou de pegar um desvio incondicional e, a essa altura, já começou a buscar a instrução que vem após esse desvio. Por conseguinte, um número substancial de máquinas com pipeline (como a UltraSPARCIII) tem a seguinte propriedade: a instrução seguinte a um desvio incondicional é executada, ainda que logicamente não devesse ser. A posição após um desvio é denominada posição de retardo (delay slot). O Core i7 (e a máquina usada na Figura 4.40(b)) não tem essa propriedade, mas a complexidade interna para contornar o problema costuma ser enorme. Um compilador otimizador tentará encontrar alguma instrução útil para colocar na posição de retardo, mas com frequência não há nada disponível, então, ele é forçado a inserir ali uma instrução NOP. Assim, o programa fica correto, mas também maior e mais lento.

Por mais que desvios incondicionais sejam irritantes, os desvios condicionais são piores. Além de também terem posições de retardo, agora a unidade de busca não sabe de onde ler até muito mais adiante no pipeline. As primeiras máquinas com pipeline apenas protelavam até saberem se o desvio seria tomado ou não. Uma protelação de três ou quatro ciclos em cada desvio condicional, em especial se 20% das instruções forem desvios condicionais, arrasa o desempenho.

Por conseguinte, o que a maioria das máquinas faz quando chega a um desvio condicional é prever se ele vai ser tomado ou não. Seria maravilhoso se pudéssemos apenas ligar uma bola de cristal em um encaixe PCI livre para ajudar na previsão, mas até agora essa abordagem não deu frutos.

Na falta de tal periférico, foram arquitetadas várias maneiras de fazer a previsão. Um modo muito simples é o seguinte: considere que todos os desvios condicionais para trás serão tomados e todos os desvios para frente não serão tomados. O raciocínio que fundamenta a primeira parte é que os desvios para trás costumam estar localizados no final de um laço. A maioria dos laços é executada várias vezes, portanto, prever que um desvio de volta ao início do laço será tomado, em geral é um bom palpite.

A segunda parte é mais tumultuada. Alguns desvios para frente ocorrem quando são detectadas condições de erro em software (por exemplo, um arquivo não pode ser aberto). Erros são raros, portanto, quase todos os desvios associados a eles não são tomados. É claro que há uma grande quantidade de desvios para frente que não
estão relacionados com o tratamento de erros, portanto, a taxa de sucesso não é tão boa quanto a dos desvios para trás. Embora não seja fantástica, essa regra é, no mínimo, melhor do que nada.

Se um desvio for previsto corretamente, não há nada de especial a fazer. A execução apenas continua no endereço de destino. O problema começa quando o desvio é previsto de forma errada. Imaginar para onde ir e ir para lá não é difícil. A parte difícil é desfazer as instruções que já foram executadas e não deveriam ter sido.

Há dois modos de resolver isso. O primeiro é permitir que as instruções buscadas após um desvio condicional previsto executem até que tentem mudar o estado da máquina (por exemplo, armazenando em um registrador). Em vez de sobrescrever o registrador, o valor calculado é colocado em um registrador transitório
(secreto) e somente copiado para o registrador real após saber que a previsão estava correta. O segundo é registrar o valor de qualquer registrador que esteja pronto para ser sobrescrito – por exemplo, em um registrador transitório secreto –, de modo que a máquina possa ser levada de volta ao estado em que estava no momento em que tomou o desvio mal previsto. Ambas as soluções são complexas e requerem contabilidade de nível industrial para conseguir efetuá-las direito. Além do mais, se um segundo desvio condicional for atingido antes de se saber se a previsão do primeiro estava correta, as coisas podem ficar complicadas de fato.

### Previsão dinâmica de desvios
Claro que previsões exatas têm grande valor, uma vez que permitem que a CPU funcione a toda velocidade. Como consequência, grande parte da pesquisa em curso tem como objetivo melhorar algoritmos de previsão de desvio (Chen et al., 2003; Falcon et al., 2004; Jimenez, 2003; e Parikh et al., 2004). Uma abordagem é a CPU manter uma tabela histórica (em hardware especial) na qual registra desvios condicionais à medida que eles ocorrem, de modo que eles possam ser consultados quando ocorrerem novamente. A versão mais simples desse esquema é mostrada na Figura 4.41(a). Nesse exemplo, a tabela histórica contém uma linha para cada instrução de desvio condicional. A linha contém o endereço da instrução de desvio junto com um bit que informa se ele foi tomado da última vez que foi executado. Usando esse esquema, a previsão é apenas que o desvio irá para o mesmo lugar da última vez. Se a previsão estiver errada, o bit na tabela de histórico é alterado.

Figura 4.41   (a) Histórico de desvio de 1 bit. (b) Histórico de desvio de 2 bits. (c) Mapeamento entre endereço de instrução de desvio e
endereço de destino.
Esta figura aborda a Previsão de Desvios (Branch Prediction), uma técnica vital para processadores com pipeline longo, como a Mic-4. No seu diretório estruturas_de_dados, imagine que o processador está percorrendo um loop das Torres de Hanói: em vez de esperar o resultado da comparação para saber se deve continuar o loop ou sair, ele "aposta" no resultado mais provável para manter o pipeline cheio.

Mecanismos de Previsão de Desvio (Figura 4.41)
(a) Histórico de 1 Bit e (b) Histórico de 2 Bits
O histórico de 1 bit é simples: ele apenas lembra o que aconteceu na última vez. O de 2 bits (Máquina de Estados) é mais robusto, pois exige dois erros seguidos para mudar a previsão, sendo ideal para loops.
(a) 1-BIT PREDICTOR             (b) 2-BIT PREDICTOR
    +-------+----------+            +-------+----------+
    | Valid | Predict  |            | Valid | Predict  |
    +-------+----------+            +-------+----------+
 6  |   1   |    T     |         6  |   1   |    11    | (Fortemente Tomado)
 5  |   1   |    NT    |         5  |   1   |    00    | (Fortemente Não Tomado)
 4  |   0   |    -     |         4  |   0   |    01    | (Fracamente Não Tomado)
 3  |   1   |    T     |         3  |   1   |    10    | (Fracamente Tomado)
    +-------+----------+            +-------+----------+
    T = Taken (Tomado)              11, 10 = Prever Tomado
    NT = Not Taken                  01, 00 = Prever Não Tomado

(c) Mapeamento de Endereço (Branch Target Buffer - BTB)
Este é o cache que armazena para onde o processador deve pular se a previsão for "Tomado".
(c) BRANCH TARGET BUFFER (BTB)
    +-------+-------------------+-----------------------+
    | Valid |  Tag (End. Desvio)| Endereço de Destino   |
    +-------+-------------------+-----------------------+
 6  |   1   |    0x00001050     |      0x000010A4       |
 5  |   1   |    0x00002100     |      0x00002150       |
 4  |   0   |        --         |          --           |
    +-------+-------------------+-----------------------+
Organização de Hardware: Previsão de Desvios (Seu Padrão)

Processamento                                                                 Armazenamento
ULA (Validação)                                                               BTB (Branch Target Buffer)
:-------------------------------------------------------------------------:-------------------------------------------------------------------------
FSM de 2 Bits: Atualiza o estado da previsão baseada no resultado real.       Tabela de Predição: Armazena os bits de histórico (1 ou 2 bits).
Comparador de Tag: Verifica se o endereço atual do PC é um desvio conhecido.  Endereço de Destino: Armazena o alvo do pulo para carregamento imediato.

                                                                              BARRAMENTO INTERNO
UC (Controle de Pipeline)                                                     Bit de Validade
Se a previsão falhar, a UC dispara o Flush (limpeza) do pipeline.             Indica se aquela entrada na tabela de desvios é útil.
REM (Endereços)                                                               Tag de Endereço
O PC é comparado com as Tags no estágio de busca (IFU).                       Garante que o destino pertence ao desvio correto.

Por que 2 bits são melhores que 1?
No seu código de Hanói, imagine um loop que roda 100 vezes.

 - Com 1 bit: O preditor acertará 99 vezes, mas errará na última (quando o loop sai) e errará na primeira vez que o loop rodar novamente (porque ele lembrará que a última vez foi "não tomado").

 - Com 2 bits: Ele lida melhor com essa variação. Ele precisa de dois erros para mudar de "Modo Loop" para "Modo Saída", o que evita erros bobos em estruturas de repetição aninhadas.

### Insight para a Mic-4
Na Mic-4, como temos 7 estágios, um erro de previsão custa caro (perdemos o trabalho de 5 ou 6 estágios). Por isso, o uso do BTB (c) é essencial: ele permite que a IFU comece a buscar as instruções do destino do desvio antes mesmo de saber se o desvio será tomado ou não.

Há diversos modos de organizar a tabela de histórico. Na verdade, são exatamente os mesmos modos usados para organizar uma cache. Considere uma máquina com instruções de 32 bits que são alinhadas por palavra de modo que os 2 bits de ordem baixa de cada endereço de memória sejam 00. Com uma tabela de histórico de
mapeamento direto que contém 2n entradas, os n + 2 bits de ordem baixa de uma instrução de desvio podem ser extraídos e deslocados 2 bits para a direita. Esse número de n bits pode ser usado como um índice para a tabela de histórico, onde é feita uma verificação para ver se o endereço ali armazenado é compatível com o endereço do desvio. Como acontece com uma cache, não há necessidade de armazenar os n + 2 bits de ordem baixa, portanto, eles podem ser omitidos (isto é, somente os bits mais altos de endereço – o tag – são armazenados). Se houver compatibilidade, ou seja, uma presença na tabela, o bit de previsão é usado para prever o desvio. Se o tag errado estiver presente ou a entrada for inválida, ocorre uma ausência na tabela (ou não há compatibilidade), exatamente como na cache. Nesse caso, pode ser usada a regra do desvio para frente e para trás.

Se a tabela de histórico de desvio tiver, por exemplo, 4.096 entradas, então os desvios nos endereços 0, 16384, 32768, ... serão conflitantes, um problema semelhante ao que encontramos na cache. A mesma solução é possível: uma entrada associativa de duas vias, quatro vias ou n vias. Assim como para a cache, o caso limite é uma única entrada associativa de n vias, que requer associatividade total de consulta.

Dada uma tabela de tamanho suficiente e suficiente associatividade, esse esquema funciona bem na maioria das situações. Contudo, sempre ocorre um problema sistemático. Quando por fim se atingir a saída de um laço, é feita uma previsão errada para o desvio e, pior ainda, a má previsão mudará o bit na tabela de histórico para indicar uma futura previsão de “nenhum desvio”. Na próxima vez que se entrar no laço, haverá uma previsão errada de desvio ao final da primeira iteração. Se o laço estiver dentro de um laço externo, ou dentro de um procedimento que é chamado muitas vezes, esse erro pode acontecer com frequência.

Para eliminar essa má previsão, podemos dar uma segunda chance à entrada da tabela. Por tal método, a previsão só é alterada após duas previsões incorretas. Essa abordagem requer dois bits de previsão na tabela de histórico, um para o que o desvio “deve” fazer e um para o que fez da última vez, como mostra a Figura 4.41(b).

Um modo ligeiramente diferente de considerar esse algoritmo é vê-lo como uma máquina de estado finito de quatro estados, como ilustra a Figura 4.42. Após uma série de previsões sucessivas certas de “nenhum desvio”, a FSM estará no estado 00 e preverá “nenhum desvio” na próxima vez. Se essa previsão estiver errada, ela passará para o estado 01, mas preverá “nenhum desvio” também na proxima vez. Só se essa previsão estiver errada, ela passará agora para o estado 11 e preverá desvios o tempo todo. Na verdade, o bit da extrema esquerda do estado é a previsão e o da extrema direita é o que o desvio fez da última vez. Embora esse projeto use apenas 2 bits para o histórico, um projeto que monitora 4 ou 8 bits de histórico também é possível.

Figura 4.42   Máquina de estado finito de 2 bits para previsão de desvio.
Esta Figura 4.42 detalha a lógica por trás do preditor de 2 bits que mencionamos anteriormente. No seu diretório estruturas_de_dados, você pode visualizar esta FSM (Máquina de Estados Finitos) como um mecanismo de histerese: ela resiste a mudanças bruscas de opinião, o que é perfeito para loops onde o desvio é "tomado" muitas vezes e "não tomado" apenas uma vez no final.

FSM de 2 Bits para Previsão de Desvios (Figura 4.42)
A máquina possui quatro estados, representados pelos bits de previsão. A ideia central é que são necessários dois erros seguidos para mudar radicalmente a previsão de "Tomado" para "Não Tomado".

Nenhum Desvio                   Nenhum Desvio
           (Acerto/Estável)                (Erro/Transição)
            <----------+                    <----------+
           /            \                  /            \
     +----/---+      +---\----+      +----/---+      +---\----+
     |   00   |      |   01   |      |   10   |      |   11   |
     | Prever |      | Prever |      | Prever |      | Prever |
     | Nenhum |      | Nenhum |      | Desvio |      | Desvio |
     +--------+      +--------+      +--------+      +--------+
           \            /                  \            /
            +---------->                    +---------->
               Desvio                          Desvio
          (Erro/Transição)                (Acerto/Estável)

    ----------------------------------------------------------------
    LEGENDA DOS ESTADOS:
    00: Fortemente Não Tomado (Strongly Not Taken)
    01: Fracamente Não Tomado (Weakly Not Taken)
    10: Fracamente Tomado     (Weakly Taken)
    11: Fortemente Tomado     (Strongly Taken)

Organização de Hardware: Lógica de Predição (Seu Padrão)Abaixo, veja como essa FSM se integra aos componentes de controle da Mic-4:

Processamento (Transições)                                                   Armazenamento (Estados)

Entrada: Resultado real do desvio vindo da ULA (Z ou N).                     00 / 01: Estados onde a IFU continua buscando a instrução seguinte (PC + 1).
Lógica: Se o estado é 10 e ocorre ""Nenhum Desvio"", o próximo estado é 01.  10 / 11: Estados onde a IFU busca o destino do desvio no BTB.
Saída: Sinal para a IFU decidir qual endereço buscar no próximo ciclo.       Contador Saturado: Nome técnico desta FSM; ela ""trava"" nos extremos 00 e 11.

                                                                             BARRAMENTO INTERNO
UC (Controle de Erro)                                                        Bits de Predição
Se a previsão (ex: 11) ≠ Resultado Real, a UC reseta os MIRs.                Dois bits armazenados em uma tabela (BHT - Branch History Table).
CLOCK (Sincronismo)                                                          Feedback da ULA
A atualização do estado da FSM ocorre no final do estágio de execução.       O bit de Zero (Z) da ULA confirma se o desvio foi realmente tomado.

Por que isso é vital para as "Torres de Hanói"?
Em algoritmos recursivos ou com loops, como o que você está estudando, o comportamento dos desvios é geralmente repetitivo:

 1. O Loop de Movimentação: O desvio será "Tomado" (11) por 100 iterações.

 2. A Saída: Na 101ª vez, o desvio não ocorre. O preditor de 1 bit erraria aqui e na próxima vez que o loop começasse.

 3. A Vantagem dos 2 Bits: O preditor de 2 bits apenas "balança" do estado 11 para o 10. Ele entende que foi uma exceção e permanece prevendo "Desvio" para a próxima execução, economizando ciclos de flush no pipeline da Mic-4.

### Vamos simular uma sequência de desvios para ver como a FSM de 2 bits se comporta em comparação com a de 1 bit.

Imagine que temos um loop no seu código de Torres de Hanói que se repete 3 vezes e depois encerra. A sequência de resultados reais será: Tomado (T), Tomado (T), Tomado (T) e Não Tomado (NT).

Simulação de Estados: 1-Bit vs 2-Bits

Passo    Resultado Real        Preditor de 1 Bit (Estado/Previsão)       Preditor de 2 Bits (Estado/Previsão)     Resultado 2-Bits

Início   -                     NT (Assume não tomado)                    00 (Forte Não Tomado)                    -
1ª vez   T                     Errou (Muda para T)                       Errou (Muda para 01)                     Erro
2ª vez   T                     Acertou                                   Errou (Muda para 10)                     Erro
3ª vez   T                     Acertou                                   Acertou (Muda para 11)                   Acerto
4ª vez   NT                    Errou (Muda para NT)                      Errou (Muda para 10)                     Erro
Reinício T                     Errou (Muda para T)                       Acertou (Mantém previsão T)              Acerto!

Organização de Hardware: Análise da Simulação (Seu Padrão)
Abaixo, veja como o hardware da Mic-4 reagiu a essa sequência:

Processamento                                                                  Armazenamento

ULA (Z/N bits)                                                                 Registrador de Estado
:------------------------------------------------------------------------------:------------------------------------------------------------------------------
Detecção de Erro: No 4º passo, a ULA informou que o desvio não ocorreu,        Histerese: O estado 10 (Fracamente Tomado) salvou o 
mas o hardware previu que sim.                                                 próximo ciclo de reinício.

Flush do Pipeline: O hardware limpou os estágios 1 a 4 quando                  BHT (Branch History Table): Armazena esses 2 bits para cada endereço de desvio 
o NT foi detectado                                                             no seu código.

                                                                               BARRAMENTO INTERNO
UC (Controle de Fluxo)                                                         Bits de Decisão
Comanda a IFU para buscar o endereço de ""queda"" (PC + 1) após o erro.        01 e 10: São os estados de ""dúvida"". Eles evitam que uma única mudança mude 
                                                                               tudo.
CLOCK (Sincronismo)                                                            Saturação
A cada ciclo, a FSM sobe ou desce, mas nunca passa de 11 ou abaixo de 00.      00/11: Estabilizam o pipeline em loops longos.

Por que o "Acerto!" no reinício é o segredo?
Note que no Reinício, o preditor de 1 bit errou novamente porque ele ficou com a "última impressão" (a saída do loop). Já o preditor de 2 bits, por ter uma memória mais persistente, continuou prevendo que o desvio seria tomado.

Para a Mic-4, isso é a diferença entre ter que esvaziar os 7 estágios do pipeline ou continuar processando a toda velocidade.

Essa não é nossa primeira FSM. A Figura 4.28 também era uma FSM. Na realidade, todos os nossos micro-programas podem ser considerados FSMs, uma vez que cada linha representa um estado específico no qual a máquina pode estar, com transições bem definidas para um conjunto finito de outros estados. FSMs são muito
usadas em todos os aspectos do projeto de hardware.

Até aqui, consideramos que o alvo de cada desvio condicional era conhecido, ou como um endereço explícito para o qual desviar (contido dentro da própria instrução), ou como um deslocamento relativo com referência à instrução corrente (isto é, um número com sinal para adicionar ao contador de programa). Muitas vezes, essa suposição é válida, mas algumas instruções de desvio calculam o endereço de destino efetuando a aritmética nos registradores e então se dirigem para aquele endereço. Mesmo que a FSM da Figura 4.42 preveja com exatidão que o desvio será tomado, essa previsão de nada serve se o endereço de destino for desconhecido. Um modo de lidar com essa situação é armazenar na tabela de histórico o endereço ao qual o desvio se dirigiu da última vez, como mostra a Figura
4.41(c). Desse modo, se a tabela informar que da última vez que o desvio no endereço 516 foi tomado ele foi para o endereço 4.000, se a previsão agora for “desvio”, a suposição de trabalho será um desvio para 4.000 novamente.

Uma abordagem diferente para a previsão de desvio é monitorar se os últimos k desvios condicionais encontrados foram tomados, pouco importando quais instruções eram. Esse número de k bits, mantido no registrador de deslocamento da tabela de histórico, é então comparado em paralelo com todas as entradas de uma tabela de
histórico que tenham uma chave de k bits e, se ocorrer um sucesso, a previsão encontrada será usada. Por mais surpreendente que seja, essa técnica funciona bastante bem.

### Previsão estática de desvio
Todas as técnicas de previsão de desvio discutidas até agora são dinâmicas, isto é, são realizadas em tempo de execução, durante a execução do programa. Elas também se adaptam ao comportamento corrente do programa, o que é bom. A desvantagem é que elas requerem hardware especializado e caro e muita complexidade no chip.

Um modo diferente de trabalhar é fazer com que o compilador ajude. Quando o compilador vir uma declaração como
    for (i = 0; i < 1000000; i++) { ... }

ele sabe muito bem que o desvio no final do laço será tomado quase toda vez. Se ao menos houvesse um meio de ele informar ao hardware, muito esforço seria poupado.

Embora seja uma alteração de arquitetura, e não apenas uma questão de execução, algumas máquinas, como a UltraSPARC III, têm um segundo conjunto de instruções de desvio condicional, além das normais, que são necessárias por compatibilidade. As novas contêm um bit no qual o compilador pode especificar que ele acha
que o desvio será tomado (ou não tomado). Quando uma dessas é encontrada, a unidade de busca apenas faz o que lhe disseram para fazer. Além do mais, não há necessidade de desperdiçar precioso espaço da tabela de histórico de desvios com essas instruções, reduzindo assim o conflito que ali acontece.

Por fim, nossa última técnica de previsão de desvio é baseada na determinação de perfil (Fisher e Freudenberger, 1992). Essa também é uma técnica estática, mas em vez de fazer o compilador tentar adivinhar quais desvios serão tomados e quais não serão, o programa é executado (normalmente em um simulador) e o
comportamento do desvio é capturado. Essa informação é alimentada no compilador, que então usa as instruções de desvio condicional especial para informar ao hardware o que ele deve fazer.

## 4.5.3 Execução fora de ordem e renomeação de registrador
Grande parte das CPUs modernas tem pipeline e também são superescalares, conforme mostra a Figura 2.6. Em geral, isso significa que há uma unidade de busca que retira palavras de instrução da memória antes que elas sejam necessárias, para alimentar uma unidade de decodificação. Esta emite as instruções decodificadas para as unidades funcionais adequadas para execução. Em alguns casos, ela pode desmembrar instruções individuais em micro-operações antes de emiti-las para as unidades funcionais, dependendo do que as unidades funcionais podem fazer.

Claro que o projeto da máquina é mais simples se as instruções forem executadas na ordem em que são buscadas (considerando, por enquanto, que o algoritmo de previsão de desvio nunca faça uma previsão errada). Contudo, a execução em ordem nem sempre resulta em desempenho ideal, devido às dependências entre instru-
ções. Se uma instrução precisar de um valor calculado pela anterior, a segunda não pode começar a executar até que a primeira tenha produzido o valor necessário. Nessa situação (uma dependência RAW), a segunda instrução tem de esperar. Também existem outros tipos de dependência, como veremos em breve.

Em uma tentativa de contornar esses problemas e produzir melhor desempenho, algumas CPUs permitem saltar instruções dependentes para chegar a instruções futuras que não são dependentes. Não é preciso dizer que o algoritmo de escalonamento de instruções internas usado deve causar o mesmo efeito que causaria se o programa
fosse executado na ordem escrita. Agora, demonstraremos como a reordenação de instruções funciona usando um exemplo detalhado.

Para ilustrar a natureza do problema, começaremos com uma máquina que sempre emite instruções na ordem do programa e também requer que sua execução seja concluída na ordem do programa. A significância dessa última exigência ficará clara mais adiante.

Nosso exemplo de máquina tem oito registradores visíveis para o programador, R0 até R7. Todas as instruções aritméticas usam três registradores: dois para os operandos e um para o resultado, igual à Mic-4. Vamos considerar que, se uma instrução for decodificada no ciclo n, a execução inicia no ciclo n + 1. Para uma instrução simples, como uma adição ou subtração, a escrita retroativa no registrador de destino ocorre ao final do ciclo n + 2. Para uma instrução mais complicada, como uma multiplicação, a escrita retroativa ocorre ao final do ciclo n + 3. Para tornar o exemplo realista, permitiremos que a unidade de decodificação emita até duas instruções por ciclo de clock. Há várias CPUs escalares comerciais que podem emitir quatro ou até seis por ciclo de clock.

Nosso exemplo de sequência de execução é mostrado na Figura 4.43. Nesse caso, a primeira coluna dá o número do ciclo e a segunda dá o número da instrução. A terceira coluna relaciona a instrução decodificada. A quarta informa qual instrução está sendo emitida (com um máximo de duas por ciclo de clock). A quinta informa qual instrução foi retirada, ou concluída. Lembre-se de que nesse exemplo estamos exigindo emissão em ordem, bem como conclusão em ordem, portanto, a instrução k + 1 não pode ser emitida até que a k tenha sido emitida e a instrução k + 1 não pode ser retirada (ou seja, não pode ser escrita retroativamente no registrador de destino) até que k tenha sido retirada. As outras 16 colunas são discutidas logo adiante.

Figura 4.43   CPU superescalar com emissão em ordem e conclusão em ordem

A Figura 4.43 apresenta o conceito de uma CPU Superescalar. Enquanto a Mic-4 era uma "linha de montagem" única (pipeline), uma CPU superescalar possui várias unidades de execução (múltiplas ULAs, unidades de ponto flutuante, etc.) operando em paralelo.

No seu diretório estruturas_de_dados, imagine que em vez de um operário movendo os discos das Torres de Hanói, você tem dois ou três operários trabalhando simultaneamente, desde que um não dependa do movimento do outro.

Operação Superescalar (Figura 4.43)
Nesta configuração de Emissão em Ordem (In-order Issue) e Conclusão em Ordem (In-order Retirement), as instruções são lançadas para as unidades de execução aos pares, mas devem ser finalizadas na sequência original para garantir a integridade dos dados.

CICLO | DECODIFICAÇÃO | EMISSÃO (Executando) | RETORNO (Conclusão) | STATUS DO REGISTRADOR
------+---------------+----------------------+---------------------+----------------------
  1   | Instr 1 & 2   |                      |                     | 
  2   | Instr 3 & 4   | Instr 1 & 2          |                     | R1, R4 em uso (W)
  3   | Instr 5 & 6   | Instr 3              | Instr 1             | R3 escrito!
  4   | Instr 7 & 8   |                      | Instr 2             | R4 escrito!
  5   |               | Instr 4              | Instr 3             | R5 escrito!
  6   |               | Instr 5 & 6          | Instr 4             | R6 escrito!
  7   |               |                      |                     | Esperando Mul (*)
  8   |               |                      |                     | Esperando Mul (*)
  9   |               |                      | Instr 5             | R7 escrito!
 10   |               |                      | Instr 6             | R1 escrito! (Reuso)
 11   |               | Instr 7              |                     |
 12   |               | Instr 8              |                     |
 ...  |      ...      |         ...          |         ...         |
 18   |               |                      | Instr 8             | R1 final (Commit)
------+---------------+----------------------+---------------------+----------------------

 [ UNIDADES DE EXECUÇÃO ]
    /---> [ ULA 1 ] ---\
---I      [ ULA 2 ]      R---> [ BUFFER DE REORDENAÇÃO ]
    \---> [ FPU   ] ---/

Organização de Hardware: Análise de Conflitos (Seu Padrão)Abaixo, veja os motivos técnicos pelos quais a execução se arrasta até o ciclo 18:

Processamento (Gargalo),Armazenamento (Dependência)
Latência da Unidade de Multiplicação,RAW (Read After Write)
:---,:---
A Instrução 5 (R7=R1*R2) demora muito mais ciclos na unidade de execução do que uma soma simples.,A Instrução 4 depende de R4. Ela não pode ser emitida até que a Instr 2 termine de escrever em R4.
Unidade de Retorno (Retirement),WAW (Write After Write)
"Como a conclusão é em ordem, a Instr 6 não pode ser ""aposentada"" antes da 5, mesmo que termine antes.",A Instrução 6 e 8 tentam escrever em R1. O hardware precisa garantir que a ordem final seja respeitada.
,
,BARRAMENTO INTERNO
Scoreboard / Registradores,Buffer de Reordenação (ROB)
"Rastreia quais instruções estão ""pendentes"" para evitar que dados errados sejam lidos.",Armazena os resultados temporários entre os ciclos 7 e 18 antes de torná-los permanentes.

Por que demora tanto? (Insight para Hanói)
O motivo da figura ir até o ciclo 18 é ilustrar que ter mais ULAs não resolve tudo.

Dependência de Dados: Se a Instrução 8 depende da Instrução 7, e a 7 depende da 6, o paralelismo morre. O processador volta a ser sequencial (um passo por vez).

Ocupação das Unidades: Se o multiplicador está ocupado pela Instrução 5, a próxima instrução que precisar multiplicar terá que esperar na fila.

Em um algoritmo de Torres de Hanói, isso acontece muito nas chamadas recursivas: cada nova chamada depende dos parâmetros calculados na linha anterior. Mesmo em uma CPU superescalar potente, o código muitas vezes fica preso nessas "correntes de dependência".

Após decodificar a instrução, a unidade de decodificação tem de decidir se pode ou não emiti-la imediata-
mente. Para tomar essa decisão, a unidade de decodificação precisa conhecer o estado de todos os registradores.
Se, por exemplo, a instrução corrente precisar de um registrador cujo valor ainda não foi calculado, ela não pode
ser emitida e a CPU deve protelar.

A utilização do registrador será monitorada com um dispositivo denominado tabela de pontuação (score-
board), encontrado pela primeira vez no CDC 6600. A tabela tem um pequeno contador para cada registrador,
que informa quantas vezes um determinado registrador é usado como uma fonte por instruções que estão sendo
executadas naquele momento. Se, por exemplo, o número máximo de instruções que podem ser executadas ao
mesmo tempo for 15, então um contador de 4 bits será suficiente. Quando uma instrução é emitida, as entradas da
tabela de pontuação para seus registradores de operandos são incrementadas. Quando uma instrução é retirada,
as entradas são decrementadas.

A tabela de pontuação também tem contadores para monitorar os registradores usados como destino. Uma
vez que só é permitida uma escrita por vez, esses contadores podem ter um bit de largura. As 16 colunas da
extrema direita na Figura 4.43 mostram a tabela de pontuação.

Em máquinas reais, a tabela também monitora a utilização da unidade funcional, para evitar emitir uma
instrução para a qual não há nenhuma unidade funcional disponível. Para simplificar, consideraremos que há
sempre uma, portanto, não mostraremos as unidades funcionais na tabela de pontuação.

A primeira linha da Figura 4.43 mostra I1 (instrução 1), que multiplica R0 por R1 e coloca o resultado em
R3. Uma vez que nenhum desses registradores está em uso ainda, a instrução é emitida e a tabela de pontuação é
atualizada para refletir que R0 e R1 estão sendo lidos, e R3 está sendo escrito. Nenhuma instrução subsequente

pode escrever para qualquer um deles, nem pode ler R3, até que I1 seja retirada. Visto que essa instrução é uma
multiplicação, ela será concluída no final do ciclo 4. Os valores da tabela de pontuação mostrados em cada linha
refletem seus estados após a emissão da instrução que está naquela linha. Entradas em branco são 0s.

Visto que nosso exemplo é uma máquina superescalar que pode emitir duas instruções por ciclo, a segunda
instrução (I2) é emitida durante o ciclo 1. Ela soma R0 e R2 e armazena o resultado em R4. Para ver se essa ins-
trução pode ser emitida, são aplicadas as seguintes regras:

  1.Se qualquer operando estiver sendo escrito, não emita (dependência RAW).
  2.Se o registrador de resultado estiver sendo lido, não emita (dependência WAR).
  3.Se o registrador de resultado estiver sendo escrito, não emita (dependência WAW).

Já vimos dependências RAW, que ocorrem quando uma instrução precisa usar como fonte um resultado
que uma instrução prévia ainda não produziu. As outras duas dependências são menos sérias – são, em essência,
conflitos de recursos. Em uma dependência WAR (Write After Read – escrita após leitura), uma instrução está
tentando sobrescrever um registrador que uma instrução anterior pode não ter terminado de ler ainda. Uma
dependência WAW (Write After Write – escrita após escrita) é parecida. Muitas vezes, elas podem ser evitadas
obrigando a segunda instrução a colocar seus resultados em algum outro lugar (talvez temporariamente). Se não
existir nenhuma das três dependências citadas e a unidade funcional de que a instrução necessita estiver disponí-
vel, a instrução é emitida. Nesse caso, I2 usa um registrador (R0) que está sendo lido por uma instrução pendente,
mas essa sobreposição é permitida, portanto, I2 é emitida. De modo semelhante, I3 é emitida durante o ciclo 2.

Agora, chegamos à I4, que precisa usar R4. Infelizmente, vemos pela linha 3 que R4 está sendo escrita. Nesse
caso, temos uma dependência RAW, portanto, a unidade de decodificação protela até que R4 fique disponível.
Durante a protelação, a unidade de decodificação para de retirar instruções da unidade de busca. Quando os
buffers internos da unidade de busca estiverem cheios, ela para de fazer a busca antecipada.

Vale a pena notar que a próxima instrução na ordem do programa, I5, não tem conflitos com nenhuma das
instruções pendentes. Ela poderia ter sido decodificada e emitida se não fosse pelo fato de esse projeto exigir que
as instruções sejam emitidas em ordem.

Agora, vamos ver o que acontece durante o ciclo 3. I2, por ser uma adição (dois ciclos), termina no final do
ciclo 3. Infelizmente, ela não pode ser retirada (e liberar R4 para I4). Por que não? A razão é que esse projeto
também requer retirada em ordem. Por quê? Que mal poderia acontecer por fazer o armazenamento em R4 agora
e marcá-lo como disponível?

A resposta é sutil, mas importante. Suponha que instruções pudessem concluir fora de ordem. Então, se
ocorresse uma interrupção, seria muito difícil salvar o estado da máquina de modo que ele pudesse ser restaura-
do mais tarde. Em particular, não seria possível afirmar que todas as instruções até algum endereço tinham sido
executadas e que todas as instruções depois dele, não. Essa característica é denominada interrupção exata e é
desejável em uma CPU (Moudgill e Vassiliadis, 1996). A retirada fora de ordem torna as interrupções inexatas,
e é por isso que algumas máquinas requerem conclusão de instrução em ordem.

Voltando a nosso exemplo, no final do ciclo 4, todas as três instruções pendentes podem ser retiradas,
portanto, I4 pode ser enfim emitida no ciclo 5, junto com a I5 recém-decodificada. Sempre que uma instrução é
retirada, a unidade de decodificação tem de verificar se há uma instrução protelada que agora possa ser emitida.

No ciclo 6, I6 é protelada por que ela precisa escrever para R1, mas R1 está ocupado. Por fim, ela é iniciada
no ciclo 9. A sequência inteira de oito instruções leva 18 ciclos para ser concluída devido a muitas dependências,
ainda que o hardware seja capaz de emitir duas instruções em cada ciclo. Entretanto, note que, ao ler a coluna
Emit. da Figura 4.43 de cima para baixo, todas as instruções foram emitidas em ordem. Da mesma forma, a
coluna Ret. mostra que elas também foram retiradas na ordem.

Agora, vamos considerar um projeto alternativo: execução fora de ordem. Nesse projeto, instruções podem
ser emitidas e também podem ser retiradas fora de ordem. A mesma sequência de oito instruções é mostrada na
Figura 4.44, só que agora são permitidas emissão fora de ordem e retirada fora de ordem.

Figura 4.44   Operação de uma CPU superescalar com emissão de instrução fora de ordem e conclusão de instrução fora de ordem.

Esta Figura 4.44 representa a evolução definitiva da performance: a Execução Fora de Ordem (Out-of-Order Execution - OoO). Note que, ao contrário da figura anterior que ia até o ciclo 18, esta finaliza tudo no Ciclo 9.

A mágica aqui acontece por dois motivos:
Renomeação de Registradores: O hardware usa nomes temporários (como o S1 e S2 que você vê na figura) para evitar que uma instrução trave só porque quer usar o mesmo nome de registrador (como o R1) que outra.

Emissão e Conclusão Fora de Ordem: Se a Instrução 5 está demorando na unidade de multiplicação, as instruções 6, 7 e 8 podem "passar à frente", ser executadas e até finalizadas, desde que não dependam do resultado da 5.

Execução Fora de Ordem (Figura 4.44)

CICLO | DECODIFICAÇÃO | EMISSÃO (Executando) | RETORNO (Conclusão) | NOTA TÉCNICA
-------+---------------+----------------------+---------------------+-----------------------
   1   |  Instr 1 & 2  |                      |                     | 
   2   |  Instr 3 & 4  |   Instr 1 & 2        |                     | R1 e R4 sendo calculados
   3   |  Instr 5 & 6  |   Instr 3 & 6        |     Instr 1         | Instr 6 fura a fila!
   4   |  Instr 7 & 8  |   Instr 5 & 8        |     Instr 2 & 6     | Instr 2 e 6 concluem
   5   |               |   Instr 4            |     Instr 3 & 8     | Instr 3 e 8 concluem
   6   |               |   Instr 7            |     Instr 4         | R4 pronto -> Instr 4
   7   |               |                      |     Instr 7         | S2 finalizado
   8   |               |                      |                     | Esperando Mult (*)
   9   |               |                      |     Instr 5         | FIM (Tudo em 9 ciclos)
-------+---------------+----------------------+---------------------+-----------------------


Organização de Hardware: Arquitetura OoO (Seu Padrão)
Abaixo, veja como os componentes que você salvou no seu mapa de hardware se adaptaram para essa velocidade:

Processamento,Armazenamento
Estações de Reserva,"Renomeação (S1, S2...)"
:---,:---
"Despacho Dinâmico: As instruções esperam em ""janelas"" até que seus operandos estejam prontos.",Registradores de Rascunho: Eliminam o conflito de nomes (WAW/WAR) criando cópias virtuais.
Unidades Funcionais: Operam de forma totalmente assíncrona.,"ROB (Reorder Buffer): Embora concluam fora de ordem, os resultados são organizados antes da escrita final."
,
,BARRAMENTO INTERNO
UC (Lógica de Tomasulo),Janela de Instrução
Algoritmo que gerencia a execução fora de ordem.,"Espaço onde as instruções decodificadas ""olham"" para os barramentos esperando dados."
Data Forwarding,Dependência Verdadeira (RAW)
O resultado de uma ULA vai direto para a outra sem passar pelos registradores.,A única coisa que ainda trava o processador é quando um dado realmente não existe ainda.

O Impacto: De 18 para 9 Ciclos (Insight)
O que você vê na figura é a redução de 50% do tempo de execução.

 - Na Mic-4 e na Superescalar "em ordem", a CPU era escrava da sequência do programador.

 - Na Mic-4 "OoO", a CPU analisa o código, percebe que a Instrução 6 (S1=R0-R2) não depende de ninguém à frente dela e a executa no Ciclo 3, ganhando tempo precioso.

Aplicação nas Torres de Hanói
Para o seu projeto no diretório estruturas_de_dados, uma CPU OoO é um sonho. Enquanto o processador está esperando um dado vir da Memória RAM (que é lenta), ele "olha adiante" no seu código de Hanói, calcula os próximos endereços de retorno, incrementa contadores e prepara tudo. Quando o dado da RAM finalmente chega, metade do trabalho seguinte já está pronto.

A primeira diferença ocorre no ciclo 3. Ainda que I4 tenha sido protelada, temos permissão para decodificar
e emitir I5, uma vez que ela não conflita com qualquer instrução pendente. Contudo, saltar instruções causa um
novo problema. Suponha que I5 tenha usado um operando calculado pela instrução que foi saltada, I4. Com a tabe-
la de pontuação corrente, não teríamos notado isso. Por conseguinte, temos de estender a tabela para monitorar
os armazenamentos feitos por instruções que foram saltadas. Isso pode ser feito adicionando um segundo mapa de
bits, 1 bit por registrador, para monitorar armazenamentos feitos por instruções proteladas. (Esses contadores não
são mostrados na figura.) Agora, a regra de emissão tem de ser estendida para evitar a emissão de qualquer instru-
ção que tenha um operando escalonado para ser armazenado por uma instrução que veio antes, mas que foi saltada.

Vamos voltar e examinar I6, I7 e I8 na Figura 4.43. Nela, vemos que I6 calcula um valor em R1 que é usado
por I7. Contudo, vemos também que o valor nunca é usado de novo porque I8 sobrescreve R1. Não há nenhuma
razão real para usar R1 como o lugar para conter o resultado de I6. Pior ainda, R1 é uma péssima escolha de
registrador intermediário, embora seja perfeitamente razoável para um compilador ou programador acostumado
com a ideia de execução sequencial sem nenhuma sobreposição de instruções.

Na Figura 4.44, introduzimos uma nova técnica para resolver esse problema: registrador de renomeação.
A sábia unidade de decodificação transfere a utilização de R1 em I6 (ciclo 3) e I7 (ciclo 4) para um registrador
secreto, S1, que não é visível para o programador. Agora, I6 pode ser emitida ao mesmo tempo em que I5. CPUs
modernas costumam ter dezenas de registradores secretos para usar com renomeação de registrador. Essa técnica
muitas vezes pode eliminar dependências WAR e WAW.

Em I8, usamos outra vez a renomeação de registrador. Desta vez, R1 é renomeado para S2, de modo que
a adição pode ser iniciada antes que R1 esteja livre, no final do ciclo 6. Se acaso o resultado realmente tiver de
estar em R1 desta vez, o conteúdo de S2 sempre pode ser copiado de volta para lá a tempo. Melhor ainda, todas
as futuras instruções que precisem dele podem ter suas fontes renomeadas para o registrador onde elas de fato
estão armazenadas. Seja como for, desse modo a adição I8 conseguiu começar mais cedo.

Em muitas máquinas reais, a renomeação está profundamente embutida no modo como os registradores são
organizados. Há muitos registradores secretos e uma tabela que mapeia os registradores visíveis ao programador
para os registradores secretos. Assim, o registrador real que está sendo usado para, por exemplo, R0, é localizado examinando-se a entrada 0 dessa tabela de mapeamento. Desse modo, não existe nenhum registrador real R0,
mas apenas uma vinculação entre o nome R0 e um dos registradores secretos. Essa vinculação muda muitas vezes
durante a execução, para evitar dependências.

Note que, na Figura 4.44, quando lemos a quarta coluna de cima para baixo, as instruções não foram emiti-
das em ordem. Tampouco foram retiradas em ordem. A conclusão desse exemplo é simples: usando a execução
fora de ordem e a renomeação de registrador, podemos acelerar o cálculo por um fator de dois.

# A EVOLUÇÃO DA FAMÍLIA Mic:
Concebida por Andrew Tanenbaum para ilustrar o funcionamento de processadores éuma jornada de otimização de vazão (throughput) e paralelismo. No seu diretório estruturas_de_dados, essa evolução representa a transição de um processamento puramente sequencial para um sistema de "linha de montagem" de alta performance.

Aqui está o resumo dessa trajetória:
1. Mic-1: A Base Sequencial
É a arquitetura mais simples, focada em executar microinstruções de forma rígida.

 - Barramentos: Possui apenas dois barramentos (um de leitura e um de escrita).

 - Ciclo: Precisa de vários ciclos para uma única instrução IJVM. Por exemplo, para somar dois valores, é necessário carregar o registrador H primeiro, pois a ULA só lê uma entrada do barramento por vez.

 - Busca: A busca da instrução faz parte da execução, o que deixa a CPU ociosa enquanto espera a memória.

2. Mic-2: Otimização e IFU
Introduz melhorias significativas para reduzir o número de ciclos por instrução.

 - Três Barramentos: Adiciona o Barramento A, permitindo que a ULA leia dois registradores simultaneamente.

 - IFU (Instruction Fetch Unit): Cria uma unidade independente para buscar instruções na memória antes de a CPU precisar delas, evitando esperas.

 - Desempenho: Instruções como IADD caem de 3 ciclos para apenas 1 ou 2.

3. Mic-3: O Pipeline Básico
Aqui o conceito de "estacionamento de dados" (Latches) é introduzido.

 - Pipeline: Divide a microinstrução em três partes: carregar registradores, operar na ULA e escrever o resultado.

 - Latches: Com a inclusão dos latches A, B e C, o processador pode começar a preparar a próxima microinstrução enquanto a atual ainda está sendo calculada pela ULA.

4. Mic-4: A Arquitetura Moderna
A Mic-4 é o ápice da série, focada no desacoplamento entre a busca e a execução.

 - 7 Estágios: Divide o trabalho em: Busca, Decodificação, Micro-op, Operandos, Execução, Escrita e Memória.

 - Micro-operações (Micro-ops): Como nos chips Intel/AMD, as instruções complexas são quebradas em partes menores e enfileiradas.

 - Fila de Espera: Possui uma unidade de enfileiramento que permite que a "frente" do processador (decodificação) trabalhe em uma velocidade diferente da "traseira" (ULA).

Resumo Comparativo (Seu Padrão)
Abaixo, veja como os componentes de processamento e armazenamento evoluíram para sustentar esse avanço:

Modelo   Processamento (Destaque)          Armazenamento / Controle

Mic-1    ULA (Cálculos Sequenciais)        Registrador H obrigatório
Mic-2    IFU (Busca Antecipada)            Três Barramentos (A, B, C)
Mic-3    Latches A, B, C                   Início do Pipeline
Mic-4    Fila de Micro-operações           Pipeline de 7 estágios (MIR1-4)

### Insight para seus projetos
Se você rodar o algoritmo de Torres de Hanói em uma Mic-1, o tempo de execução será limitado pela velocidade com que a ULA consegue "limpar" o barramento para a próxima tarefa. Na Mic-4, os 7 estágios permitem que, enquanto o processador está salvando o movimento de um disco na memória (estágio 7), ele já esteja decodificando a próxima chamada recursiva (estágio 2).

## 4.5.4 Execução especulativa
Na seção anterior, introduzimos o conceito de reordenação de instruções de modo a melhorar o desempe-
nho. Embora não o tenhamos mencionado explicitamente, o foco estava sobre a reordenação de instruções dentro
de um único bloco básico. Agora, está na hora de examinar essa questão mais de perto.

Programas de computador podem ser desmembrados em blocos básicos, em que cada um consiste em uma
sequência linear de código com um ponto de entrada no início e uma saída no final. Um bloco básico não con-
tém qualquer estrutura de controle (por exemplo, instruções if ou declarações while), de modo que sua tradução
para linguagem de máquina não contém nenhum desvio. Os blocos básicos são conectados por declarações de
controle.

Um programa nessa forma pode ser representado por um gráfico orientado, conforme mostra a Figura 4.45.
Nesse exemplo, calculamos as somas dos cubos dos inteiros pares e ímpares até algum limite e as acumulamos
em evensum e oddsum, respectivamente. Dentro de cada bloco básico, as técnicas de reordenação da seção anterior
funcionam bem.

Figura 4.45   (a) Fragmento de programa. (b) Gráfico de blocos básicos correspondente.
Esta figura ilustra um dos maiores desafios para as CPUs modernas: os Desvios Condicionais. No seu diretório estruturas_de_dados, esse conceito é crucial porque mostra como o compilador e o hardware enxergam a estrutura lógica de um loop (como o das Torres de Hanói) e tentam otimizá-lo através da Elevação de Código.

Blocos Básicos e Fluxo de Controle (Figura 4.45)
Um Bloco Básico é uma sequência de instruções com uma única entrada (no início) e uma única saída (no fim). Desvios quebram esses blocos, criando o gráfico abaixo.
(a) FRAGMENTO DE PROGRAMA            (b) GRÁFICO DE BLOCOS BÁSICOS
                                     +---------------------------+
 evensum = 0;                        |       evensum = 0;        |
 oddsum = 0;                         |       oddsum = 0;         |
 i = 0;                              |       i = 0;              |
                                     +-------------+-------------+
                                                   |
                                     +-------------v-------------+
 while (i < limit) {                 |      while (i < limit)    | <-----+
   k = i * i * i;                    +-------------+-------------+       |
                                            | (i < limit)                |
                                     +------v--------------------+       |
   if (i % 2 == 0)                   |      k = i * i * i;       |       |
                                     |      if (i % 2 == i)      |       |
                                     +------/------------\-------+       |
                                           / T          F \              |
     evensum += k;           +------------v---+      +-----v----------+  |
                           | evensum += k;  |      |  oddsum += k;  |  |
   else                      +------------\---+      +-----/----------+  |
     oddsum += k;                          \            /                |
                                     +------v----------v---------+       |
   i = i + 1;                        |       i = i + 1;          |       |
 }                                   +-------------+-------------+-------+
                                                   | (i >= limit)
                                                   v
                                                [ FIM ]
Organização de Hardware: Otimização de Blocos (Seu Padrão)

Processamento,Armazenamento
Elevação de Código,Bloco Básico
:---,:---
"Otimização: Mover o cálculo de k = i * i * i para antes do if (ou até antes do while, se possível).","Escopo: Conjunto de instruções sem saltos. Quanto maior o bloco, mais o pipeline da Mic-4 brilha."
Cadeia de Dependência: A CPU tenta identificar que i = i + 1 pode começar antes mesmo de evensum ser atualizado.,"Registradores Temporários: Usados para guardar resultados ""elevados"" antes que o desvio seja confirmado."
,
,BARRAMENTO INTERNO
UC (Previsão de Desvio),Instruções Especulativas
"Tenta ""adivinhar"" se o caminho será T ou F para carregar o bloco seguinte.",Instruções que foram elevadas e executadas antes de sabermos se seriam necessárias.
REM (Endereço de Salto),Latência de LOAD
Endereços que marcam o fim de um bloco e o início de outro.,"Se houver um LOAD no Bloco F, o hardware tenta iniciá-lo enquanto ainda decide o desvio."

O que é a "Elevação" e por que usá-la? (Insight)
Como você leu no texto, blocos básicos curtos são ruins para o paralelismo. Se o processador superescalar emitir 4 instruções por ciclo, mas o bloco só tiver 2 instruções, metade da potência da CPU é desperdiçada.

 1. A Elevação: O hardware (ou compilador) move instruções de blocos inferiores para blocos superiores.

 2. O Ganho: No exemplo, o cálculo de k (um cubo, que é lento) pode começar assim que o while é testado, sem esperar o if.

 3. O Risco: Se você elevar uma instrução que causa um erro (como uma divisão por zero) e o desvio nem chegaria a executá-la, a CPU precisa saber ignorar esse erro "especulativo".

Aplicação nas Torres de Hanói
Em seu algoritmo, as chamadas recursivas criam muitos blocos básicos minúsculos. A Elevação de Código permitiria que o processador começasse a preparar os parâmetros da próxima chamada (n-1, origem, destino) enquanto ainda está executando a lógica de exibição do movimento atual.

O problema é que a maioria dos blocos básicos é curta e não há paralelismo suficiente para explorá-los de
modo efetivo. Por conseguinte, a próxima etapa é permitir que a reordenação cruze as fronteiras de blocos básicos
na tentativa de preencher todas as posições de emissão. Os maiores ganhos ocorrem quando uma operação poten-
cialmente lenta pode ser passada para cima no gráfico para ser iniciada mais cedo. Essa instrução pode ser uma
instrução LOAD, uma operação de ponto flutuante ou até mesmo o início de uma longa cadeia de dependência.
A transferência de um código para cima através de um desvio é denominada elevação.

Imagine que, na Figura 4.45, todas as variáveis fossem mantidas em registradores, exceto evensum e oddsum,
por falta de registradores. Portanto, talvez fizesse sentido passar suas instruções LOAD para o topo do laço antes
de calcular k, para iniciá-las cedo, de modo que os valores estarão disponíveis quando necessários. Claro que
somente uma delas será necessária em cada iteração, portanto, a outra LOAD será desperdiçada, mas se a cache e
a memória tiverem pipelining e houver posições de emissão disponíveis, talvez ainda valesse a pena fazer isso. A
execução de código antes mesmo de saber se ele será necessário é denominada execução especulativa. Usar essa
técnica requer suporte do compilador e do hardware, bem como algumas extensões na arquitetura. Em geral,
reordenar instruções atravessando fronteiras de blocos básicos está além da capacidade do hardware, portanto, o
compilador deve mover as instruções explicitamente.

A execução especulativa introduz alguns problemas interessantes. Um deles é que nenhuma das instruções
especulativas tem resultados irrevogáveis, porque mais tarde pode-se descobrir que elas não deveriam ter sido
executadas. Na Figura 4.45, é bom buscar evensum e oddsum, e também é bom efetuar a adição tão logo k esteja
disponível (mesmo antes da declaração if), mas não é bom armazenar os resultados de volta na memória. Em
sequências de código mais complicadas, um modo comum de evitar que o código especulativo sobrescreva regis-
tradores antes de se saber se isso é desejado é renomear todos os registradores de destino usados pelo código
especulativo. Desse modo, apenas registradores temporários são modificados, portanto, não há problema algum
se, afinal, o código não for necessário. Se o código for necessário, os registradores transitórios são copiados para
os verdadeiros registradores de destino. Como você pode imaginar, a tabela de pontuação para monitorar tudo
isso não é simples, mas, com hardware suficiente, pode ser feita.

Entretanto, há outro problema introduzido pelo código especulativo que não pode ser resolvido por reno-
meação de registrador. O que acontece se uma instrução executada por especulação causar uma exceção? Um
exemplo doloroso, mas não fatal, é uma instrução LOAD que causa uma ausência da cache em uma máquina cuja
linha de cache é de tamanho grande (por exemplo, 256 bytes) e a memória é muito mais lenta do que a CPU
e a cache. Se um LOAD que é realmente necessário fizer a máquina parar de vez durante muitos ciclos enquanto
a linha de cache está sendo carregada, bom, são coisas da vida, já que a palavra é necessária. Contudo, protelar a
máquina para buscar uma palavra que, afinal, não é necessária, é contraproducente. Muitas dessas “otimizações”
podem fazer a CPU ficar mais lenta do que se ela não as tivesse. Se a máquina tiver memória virtual, que é dis-
cutida no Capítulo 6, um LOAD especulativo pode até causar uma falta de página, o que requer uma operação de
disco para trazer a página necessária. Falsas faltas de página podem causar um efeito terrível sobre o desempenho,
portanto, é importante evitá-las.

Uma solução presente em várias máquinas modernas é inserir uma instrução SPECULATIVE-LOAD que tenta
buscar a palavra na cache, mas, se ela não estiver lá, desiste. Se o valor estiver na cache quando for mesmo neces-
sário, ele pode ser usado ou não; caso não esteja, o hardware tem de entrar em cena e obtê-lo imediatamente. Se
o valor se revelar não necessário, nada de ruim aconteceu pela ausência da cache.

  Uma situação muito pior pode ser ilustrada com a seguinte declaração:
  if (x > 0) z = y/x;

em que x, y e z são variáveis de ponto flutuante. Suponha que as variáveis são todas buscadas com antecedên-
cia para registradores e que a divisão com ponto flutuante (uma operação lenta) é elevada para cima do teste if.
Infelizmente, x é 0 e a exceção resultante, isto é, a divisão por zero, encerra o programa. O resultado líquido é
que a especulação causou a falha de um programa correto. Pior ainda, o programador inseriu um código explícito
para evitar essa situação e, mesmo assim, ela aconteceu. Provavelmente, o programador não ficará feliz com isso.

Uma solução possível é ter versões especiais e instruções que poderiam causar exceções. Além disso, um
bit denominado bit envenenado é adicionado a cada registrador. Quando uma instrução especulativa especial
falhar, em vez de causar uma exceção, ela ajusta o bit envenenado no registrador de resultado. Se mais adiante
uma instrução normal chegar a esse registrador, a armadilha ocorre nesse momento (como deveria). Contudo,
se o resultado nunca é usado, o bit envenenado mais cedo ou mais tarde é eliminado e não há prejuízo algum.

## 4.6 Exemplos do nível de microarquitetura
Nesta seção, apresentaremos exemplos resumidos de três processadores de alta tecnologia, mostrando como
eles empregam os conceitos explorados neste capítulo. Os exemplos terão que ser breves porque máquinas reais
são de uma complexidade enorme, contendo milhões de portas. Os exemplos são os mesmos que usamos até
agora: Core i7, OMAP4430 e ATmega168.

## 4.6.1 A microarquitetura da CPU Core i7
Por fora, o Core i7 parece uma máquina CISC tradicional, com um conjunto de instruções imenso e desajeitado
que suporta operações com inteiros de 8, 16 e 32 bits, bem como operações de ponto flutuante de 32 bits e 64 bits.
Tem somente oito registradores visíveis por processador e não há dois deles que sejam exatamente iguais. Os com-
primentos de instruções variam de 1 a 17 bytes. Resumindo, é uma arquitetura herdada que parece fazer tudo errado.

Entretanto, por dentro, contém um núcleo RISC moderno, enxuto e de alto grau de pipelining, que trabalha a
uma taxa de clock de extrema rapidez e que provavelmente crescerá nos anos vindouros. É impressionante como
os engenheiros da Intel conseguiram construir um processador de última geração para implementar uma arquite-
tura antiga. Nesta seção, examinaremos a microarquitetura do Core i7 para ver como ela funciona.

### Visão geral da microarquitetura Sandy Bridge do Core i7 
A microarquitetura do Core i7, denominada microarquitetura Sandy Bridge, é uma ruptura total em relação
às microarquiteturas Intel anteriores, incluindo as antigas P4 e P6. Uma visão geral esquemática da microarqui-
tetura do Core i7 é dada na Figura 4.46.

Figura 4.46   Diagrama de blocos do Core i7.

Esta figura representa a arquitetura de um processador moderno de alto desempenho. Enquanto a Mic-1 era um motor de um único cilindro, o Core i7 é uma usina complexa que utiliza execução fora de ordem, múltiplos níveis de cache e tradução de instruções.

O Core i7 não executa instruções x86 diretamente; sua unidade de decodificação as transforma em micro-operações, que são então processadas por um núcleo muito parecido com uma versão extremamente "bombada" da Mic-4.

Arquitetura do Core i7 (Figura 4.46)

[ SUBSISTEMA DE MEMÓRIA ] <----------> [ CACHE L3 COMPARTILHADA ]
                  |
       ___________v___________________________________________________
      |  INTERFACE DO SISTEMA E CACHE L2 (Instruções e Dados)         |
      |_______________________________________________________________|
                  |                                 |
        __________v__________             __________v__________
       | CACHE L1 DE INSTR.  |           | CACHE L1 DE DADOS   |
       |_____________________|           |_____________________|
                  |                                 ^
        __________v__________             __________|__________
       |  UNIDADE DE BUSCA   |           |                     |
       |  E DECODIFICAÇÃO    |           | UNIDADE DE EXECUÇÃO |
       |_____________________|           | (ULAs, FPU, Buffer  |
                  |                      |  de Armazenamento)  |
        __________v__________             |_____________________|
       | CACHE DE MICRO-OPS  |                      ^
       |_____________________|                      |
                  |                      ___________|__________
        __________v__________           |                      |
       | PREVISOR DE DESVIO  |           | CONTROLE FORA-DE-ORD |
       |_____________________|           | (Renomeação e        |
                  |                      |  Escalonamento)      |
        __________v__________           |_____________________|
       |   TERMINAL FRONTAL  |                      ^
       |    (FRONT END)      |                      |
       |_____________________|           __________v__________
                  |                     |                     |
                  +-------------------->| UNIDADE DE RETIRADA |
                                        |    (RETIREMENT)     |
                                        |_____________________|

Organização de Hardware: Divisão de Tarefas (Seu Padrão)
No seu diretório estruturas_de_dados, você pode dividir o Core i7 em três grandes seções que trabalham em paralelo:

Processamento (Seções),Componentes e Armazenamento
Front-End (Terminal Frontal),Cache de Micro-ops e Previsor de Desvio
:---,:---
Busca/Decodificação: Pega as instruções complexas e as quebra em micro-operações simples.,Previsão: Tenta adivinhar o caminho dos desvios para manter a fila cheia.
Out-of-Order Engine,Renomeação e Escalonamento
Controle OoO: Decide qual instrução está pronta para rodar (independente da ordem original).,"Buffer de Reordenação: Mantém o controle de quem é quem durante a ""bagunça"" da execução."
Execution Engine,"ULAs, FPU e L1-D"
Unidade de Execução: Onde o cálculo real acontece. Possui múltiplas portas para disparar várias operações por ciclo.,Retirada (Retirement): O estágio final que coloca tudo em ordem antes de gravar o resultado.

Por que o Core i7 é tão rápido? (Insight)

 1. Cache de Micro-ops: Se o processador entra em um loop (como o das Torres de Hanói), ele não precisa decodificar as mesmas instruções repetidamente. Ele as busca já decodificadas na Cache de Micro-ops, economizando tempo e energia.

 2. Unidade de Retirada: É o "juiz" do processador. As instruções podem ser executadas de forma caótica para ganhar velocidade, mas a Unidade de Retirada garante que elas sejam finalizadas na ordem correta, mantendo a integridade do seu programa.

 3. Subsistema de Memória: A conexão com a L3 compartilhada permite que múltiplos núcleos troquem dados rapidamente sem precisar ir até a RAM (DRAM).

Conexão com seu Projeto
Ao rodar algoritmos complexos de estruturas de dados, o Core i7 utiliza o Escalonamento para identificar que a atualização de um ponteiro pode ser feita ao mesmo tempo que um cálculo aritmético em outro registrador. Essa capacidade de processar até 4 ou mais micro-instruções por ciclo é o que o torna ordens de magnitude mais rápido que a Mic-1.

O Core i7 consiste em quatro subseções principais: o subsistema de memória, o terminal frontal, o controle
de fora de ordem e as unidades de execução. Vamos examiná-las uma por uma, começando na parte superior
esquerda e percorrendo o chip em sentido anti-horário.

Cada processador no Core i7 contém um subsistema de memória com uma cache L2 (de nível 2) unificada,
bem como a lógica para acessar a cache L3 (nível 3). Uma única cache L3 grande é compartilhada por todos os
processadores, e essa é a última parada antes de sair do chip da CPU e fazer a longa jornada até a RAM externa
pelo barramento de memória. As caches L2 do Core i7 têm um tamanho de 256 KB, e cada uma é organizada
como uma cache associativa de 8 vias com linhas de 64 bytes. A cache L3 compartilhada varia em tamanho de 1
MB a 20 MB. Se você pagar mais à Intel, terá mais cache em retorno. Independentemente do seu tamanho, a L3 é
organizada como uma cache associativa em 12 vias, com linhas de cache de 64 bytes. Caso haja uma ausência de
cache L3, o acesso é enviado à RAM externa por meio do barramento de RAM DDR3.

Associada à cache L1 estão duas unidades de busca antecipada (que não aparecem na figura) que tentam
buscar dados com antecedência de níveis inferiores do sistema de memória para a cache L1, antes de eles serem
necessários. Uma unidade de busca antecipada consulta o próximo bloco de memória quando detecta que um
“fluxo” de sequência da memória está sendo buscado para o processador. Um segundo buscador antecipado, mais
sofisticado, cuida da sequência de endereços dos loads e stores do programa específico. Se eles prosseguirem a um
passo regular (por exemplo, 0x1000... 0x1020... 0x1040...), ele buscará o próximo elemento que provavelmente
será acessado de modo antecipado ao programa. Essa pré-busca orientada a passo faz maravilhas para programas
que estão marchando pelas fileiras de variáveis estruturadas.

O subsistema de memória na Figura 4.46 está conectado tanto ao terminal frontal quanto à cache de dados
L1. O terminal frontal é responsável por buscar instruções do sistema de memória, decodificando-as para micro-
-operações parecidas com RISC e armazenando-as em duas caches de armazenamento de instrução. Todas as ins-
truções buscadas são colocadas na cache de instrução L1 (nível 1). Esta tem um tamanho de 32 KB e é organizada
como uma cache associativa de 8 vias com blocos de 64 bytes. À medida que as instruções são buscadas da cache
L1, elas entram nos decodificadores que determinam a sequência de micro-operações usada para implementar
a instrução no pipeline de execução. O mecanismo decodificador une a lacuna entre um conjunto de instruções
CISC antigo e um caminho de dados RISC moderno.

As micro-operações decodificadas são alimentadas na cache de micro-operações, que a Intel chama de cache
de instruções L0 (de nível 0). Ela é semelhante a uma cache de instruções tradicional, mas tem muito espaço
extra para armazenar as sequências de micro-operações produzidas pelas instruções individuais. Quando as
micro-operações decodificadas, em vez das instruções originais, são colocadas em cache, não é preciso deco-
dificar a instrução em execuções subsequentes. À primeira vista, você poderia pensar que a Intel fez isso para
acelerar o pipeline (e, na verdade, isso agiliza o processo de produção de uma instrução), mas a empresa afirma
que a cache de micro-operações foi incluída para reduzir o consumo de potência do terminal frontal. Com a
cache de micro-operações no lugar, o restante do terminal frontal dorme em um modo de baixa potência sem
clock durante 80% do tempo.

A previsão de desvio também é realizada no terminal frontal. O previsor de desvio é responsável por desco-
brir quando o fluxo do programa sai da busca de sequência pura, e deve ser capaz de fazer isso muito antes que
as instruções de desvio sejam executadas. O previsor de desvio no Core i7 é incrível. Infelizmente para nós, os
detalhes dos previsores de desvio do processador são segredos mantidos para a maior parte dos projetos. Isso por-
que o desempenho do previsor geralmente é o componente mais crítico da velocidade geral do projeto. Quanto
mais exatidão na previsão os projetistas puderem espremer de cada micrômetro quadrado de silício, melhor o
desempenho do projeto inteiro. Assim, as empresas escondem esses segredos a sete chaves, e até mesmo ameaçam
os funcionários com processo criminal se qualquer um deles decidir compartilhar essas joias de conhecimento.
Basta dizer, no entanto, que todos eles acompanham de que modo os desvios anteriores seguiram e usam isso para
fazer previsões. Os detalhes de exatamente o que eles registram e como eles armazenam e consultam a informação
é um algoritmo altamente secreto. Afinal, se você tivesse um modo infalível de prever o futuro, é bem provável
que não o colocaria na Web para todo mundo ver.

Instruções são alimentadas da cache de micro-operações para o escalonador fora de ordem, na ordem ditada
pelo programa, porém, elas não são necessariamente emitidas na ordem do programa. Quando é encontrada uma
micro-operação que não pode ser executada, o escalonador a retém mas continua processando o fluxo de instru-
ções para emitir instruções subsequentes para as quais todos os recursos (registradores, unidades funcionais etc.) estão disponíveis. A renomeação de registradores também é feita aqui, para permitir que instruções com uma
dependência WAR ou WAW prossigam sem atraso.

Embora instruções possam ser emitidas fora de ordem, o requisito de interrupções exatas da arquitetura do
Core i7 significa que as instruções ISA devem ser retiradas (isto é, seus resultados devem ficar visíveis) na ordem
original do programa. A unidade de retirada executa essa tarefa.

No back end do processador, temos as unidades de execução que efetuam as instruções de inteiros, de ponto
flutuante e especializadas. Existem várias dessas unidades e elas funcionam em paralelo. Elas obtêm seus dados
do arquivo do registrador e da cache de dados L1.

## O pipeline da Sandy Bridge do Core i7
A Figura 4.47 é uma versão simplificada da microarquitetura Sandy Bridge, mostrando o pipeline. Na parte
superior, está o terminal frontal, cuja tarefa é buscar instruções na memória e prepará-las para execução. O
terminal frontal recebe novas instruções x86 da cache de instruções L1. Ele as decodifica para micro-operações
para armazenamento na cache de micro-operações, que retém mais ou menos 1,5 K micro-operações. Uma cache
de micro-operações desse tamanho dá um desempenho comparável ao de uma cache L0 convencional de 6 KB.
A cache de micro-operações contém grupos de seis micro-operações em uma única linha de rastreamento. Para
sequências mais longas de micro-operações, várias linhas de rastreamento podem ser interligadas.

Figura 4.47   Visão simplificada do caminho de dados do Core i7.
Esta figura detalha o coração da execução do Core i7. Enquanto a figura anterior mostrava a organização lógica, a Figura 4.47 foca no fluxo físico dos dados (o Data Path).
O ponto mais impressionante aqui é a divisão entre o Escalonador sem memória (para cálculos puros) e o Escalonador com memória (para buscar e salvar dados). Isso permite que o processador execute operações matemáticas e acessos à memória de forma totalmente paralela.

Caminho de Dados do Core i7 (Figura 4.47)
[ FRONT-END (Busca/Decodificação) ]
           | (Micro-operações)
  _________v_________________________________
 |  UNIDADE DE ALOCAÇÃO E RENOMEAÇÃO         |
 | (Elimina dependências falsas de registr.) |
 |___________________________________________|
           |
  _________v_________________________________
 |      CONTROLE DE FORA DE ORDEM            |
 | (Janela de Instruções / Buffer de Reord.) |
 |___________________________________________|
           |                          |
  _________v_________        _________v_________
 |  ESCALONADOR      |      |  ESCALONADOR      |
 |  SEM MEMÓRIA      |      |  COM MEMÓRIA      |
 |___________________|      |___________________|
      |      |      |            |      |      |
  +---v--+ +-v----+ +-v----+ +---v--+ +-v----+ +-v----+
  | ULA 1| | ULA 2| | ULA 3| | LOAD1| | LOAD2| |STORE |
  +------+ +------+ +------+ +------+ +------+ +------+
      |      |      |            |      |      |
  ____v______v______v____________v______v______v______
 |              CACHE DE DADOS L1                     |
 |____________________________________________________|
           |                          |
 [ CACHE L2 UNIFICADA ] <----> [ CACHE L3 COMPARTILHADA ]

Organização de Hardware: O Caminho do Dado (Seu Padrão)
No contexto do seu diretório estruturas_de_dados, veja como o Core i7 processa uma instrução de alto nível:

Processamento,Armazenamento
Alocação/Renomeação,Cache de Micro-ops
:---,:---
"Lógica: Transforma nomes de registradores lógicos (como EAX) em físicos (S1, S2...) para evitar travamentos.","Buffer: Armazena as micro-instruções prontas para serem ""despachadas""."
Escalonadores,Unidades de Execução (6+)
"Dinâmico: O escalonador ""com memória"" inicia os LOADs o mais cedo possível para esconder a latência da RAM.",Paralelismo: Pode disparar 3 cálculos e 3 acessos à memória no mesmo ciclo de clock.
,
,BARRAMENTO INTERNO
UC (Unidade de Retirada),L1 Data Cache
Garante que os resultados das 6 unidades de execução sejam gravados na ordem correta.,"Pequena (32KB), mas extremamente rápida e com múltiplas portas de acesso."
Interface L2/L3,Previsor de Desvio/BTB
"Se o dado não está na L1, o hardware busca nas camadas superiores sem parar as ULAs.",Decide qual fluxo de micro-ops deve alimentar o terminal frontal.

Por que existem dois escalonadores? (Insight)
A grande sacada da arquitetura Core i7 demonstrada nesta figura é a especialização:

Escalonador sem Memória: Foca apenas em manter as ULAs ocupadas. Ele é otimizado para velocidade pura (somas, multiplicações, lógica).

Escalonador com Memória: É o "gerente de logística". Ele lida com as incertezas da memória. Se um Load 1 demora porque o dado está na L3, o Load 2 pode tentar buscar outro dado que já está na L1, mantendo o fluxo.

Aplicação prática (Torres de Hanói)
Se o seu código faz: disco = pilha[topo]; novo_topo = topo - 1;, o Core i7 fará o seguinte:

 - O Escalonador com Memória dispara o Load de pilha[topo].

 - Simultaneamente, o Escalonador sem Memória já calcula topo - 1 na ULA 1.

 - A CPU não espera o disco chegar da memória para atualizar o valor do topo. Quando o disco finalmente chega (via Load 1), o endereço para guardá-lo já está pronto.

Se a unidade de decodificação encontrar um desvio condicional, ela consulta sua direção prevista no Previsor
de Desvio. O previsor de desvio contém o histórico dos desvios encontrados no passado e usa esse histórico para
descobrir se um desvio condicional será ou não tomado da próxima vez que for encontrado. É aí que é usado o
algoritmo altamente secreto.

Se a instrução de desvio não estiver na tabela, é usada previsão estática. Um desvio para trás é entendido
como parte de um laço e admite-se que deve ser tomado. A exatidão dessas previsões estáticas é extremamente
alta. Um desvio para frente é entendido como parte de uma declaração if e admite-se que não deve ser tomado. A
exatidão dessas previsões estáticas é bem mais baixa do que a de desvios para trás.

###  Esta tabela final encerra a jornada da arquitetura de computadores, partindo da simplicidade educacional da Mic-1 até a complexidade industrial do Core i7. 
No seu diretório estruturas_de_dados, essa evolução é o que permite que algoritmos complexos (como as Torres de Hanói recursivas) passem de segundos para milissegundos de execução.

Tabela Comparativa: Mic-1 vs. Core i7
Seguindo o formato que você solicitou, aqui está o comparativo técnico:

Processamento,Armazenamento
ULA (Cálculos),Registradores
Mic-1: 1 ULA básica (sequencial).,"Mic-1: 9 Registradores fixos (SP, LV, etc.)."
"Core i7: Múltiplas ULAs (3+ para inteiros, FPUs).",Core i7: Centenas (Renomeação física dinâmica).
,
,BARRAMENTO INTERNO
"Mic-1: 2 barramentos de leitura (A, B) e 1 de escrita (C).",Mic-1: Conexão direta e simples.
Core i7: Barramentos superescalares (6+ operações/ciclo).,Core i7: Malha complexa (Ring Interconnect/Mesh).
,
UC (Controle),RI (Instrução Atual)
Mic-1: Microprograma rígido (ROM).,Mic-1: Executa instruções IJVM puras.
Core i7: Fora-de-Ordem (Algoritmo de Tomasulo).,Core i7: Traduz para Micro-operações (Micro-ops).
,
REM (Endereços),Decodificador
Mic-1: 1 porta de endereço para RAM.,Mic-1: Simples (Mapeia Opcode para ROM).
Core i7: Múltiplas unidades Load/Store (especulativas).,"Core i7: Hardware complexo que ""fatia"" x86 em micro-ops."
,
CI (Próxima Inst.),RDM (Dados)
Mic-1: PC (Program Counter) simples.,Mic-1: Buffer de dados básico para RAM.
Core i7: Previsão de Desvios (BTB/Histórico de 2 bits).,"Core i7: Hierarquia de Caches (L1, L2, L3) e Prefetching."
,
CLOCK (Sincronismo),MEMÓRIA PRINCIPAL (RAM)
Mic-1: 1 microinstrução por ciclo.,Mic-1: Acesso direto (gargalo total).
Core i7: Giga-Hertz (Pipeline de ~14-19 estágios).,Core i7: Controladores DDR integrados e Quad-Channel.

Resumo da Jornada
 - Mic-1: Foco em clareza. Ótima para aprender como cada bit se move, mas ineficiente por ser puramente sequencial.

 - Mic-4: Foco em pipeline. Introduziu a ideia de "linha de montagem", onde cada estágio (1-7) cuida de uma parte da instrução.

 - Core i7: Foco em paralelismo e especulação. O hardware não apenas executa, mas tenta "adivinhar" o futuro do seu código para nunca deixar as ULAs paradas.

Com essa base, você tem todo o conhecimento necessário para entender como o hardware influencia a eficiência do seu código de estruturas de dados.

ara um desvio tomado, o BTB (Branch Target Buffer – buffer de alvo de desvio) é consultado para deter-
minar o endereço de destino. O BTB mantém o endereço de destino do desvio na última vez que ele foi tomado.
Quase sempre, esse endereço está correto (na verdade, ele está sempre correto para desvios com um deslocamento
constante). Os desvios indiretos, como os usados pelas chamadas de função virtual e comandos switch da C++,
vão para muitos endereços, e eles podem ser interpretados incorretamente pelo BTB.

A segunda parte do pipeline, a lógica de controle fora de ordem, é alimentada a partir da cache de micro-
-operações. À medida que cada micro-operação chega ao terminal frontal, até quatro por ciclo, a unidade de
alocação/renomeação a registra em uma tabela de 168 entradas denominada ROB (ReOrder Buffer – buffer
de reordenação). Essa entrada monitora o estado da micro-operação até ela ser retirada. Em seguida, a unidade de
alocação/renomeação verifica para ver se os recursos de que a micro-operação necessita estão disponíveis.
Se estiverem, ela é enfileirada para execução em uma das filas do escalonador. São mantidas filas separadas
para micro-operações da memória e para as que não são da memória. Se uma micro-operação não puder ser
executada, ela é retardada, mas as subsequentes são processadas, o que leva à execução fora de ordem das
micro-operações. Essa estratégia foi projetada para manter todas as unidades funcionais o mais ocupadas possí-
vel. Até 154 instruções podem estar no ar a qualquer instante e até 64 dessas podem ser carregadas da memória
e até 36 podem ser armazenamentos para a memória.

Às vezes, uma micro-operação é protelada porque precisa escrever para um registrador que está sendo lido
ou escrito por uma micro-operação anterior. Esses conflitos são denominados dependências WAR e WAW, res-
pectivamente, como vimos antes. Renomeando o alvo da nova micro-operação para permitir que ela escreva seu
resultado em um dos 160 registradores transitórios em vez de no alvo pretendido, mas ainda ocupado, pode ser
possível escalonar a micro-operação para execução imediatamente. Se não houver nenhum registrador transitório
disponível, ou se a micro-operação tiver uma dependência RAW (que nunca poderá ser ignorada), o alocador
observa a natureza do problema na entrada do ROB. Quando todos os recursos requisitados ficam disponíveis
mais tarde, a micro-operação é colocada em uma das filas do escalonador.

O escalonador envia as micro-operações para as seis unidades funcionais quando elas estiverem prontas para
executar. As unidades funcionais são as seguintes:

  1.ULA 1 e a unidade de multiplicação de ponto flutuante.
  2.ULA 2 e a unidade de adição/subtração de ponto flutuante.
  3.ULA 3 e a unidade de processamento de desvio e comparações de ponto flutuante.
  4.Instruções store.
  5.Instruções load 1.
  6.Instruções load 2.

Uma vez que os escalonadores e as ULAs podem processar uma operação por ciclo, um Core i7 de 3 GHz
tem o desempenho do escalonador para realizar 18 bilhões de operações por segundo; porém, o processador
na realidade nunca alcançará esse nível de vazão. Visto que o terminal frontal fornece no máximo quatro
micro-operações por ciclo, seis micro-operações só podem ser emitidas em curtas rajadas, pois logo as filas do
escalonador se esvaziarão. Além disso, cada unidade de memória usa quatro ciclos para processar suas opera-
ções, de modo que elas poderiam contribuir para a vazão de execução máxima apenas em pequenas rajadas.
Apesar de serem capazes de saturar totalmente os recursos de execução, as unidades funcionais oferecem uma
capacidade de execução significativa, e é por isso que o controle de fora de ordem tem tanto trabalho para
encontrar trabalho para ela realizarem.

As três ULAs de inteiros não são idênticas. A ULA 1 pode executar todas as operações aritméticas, lógicas,
multiplicações e desvios. A ULA 2 pode efetuar apenas operações aritméticas e lógicas. A ULA 3 pode realizar
operações aritméticas e lógicas e resolver desvios. Da mesma forma, as duas unidades de ponto flutuante também
não são idênticas. A primeira pode realizar aritmética de ponto flutuante, incluindo multiplicações, enquanto a
segunda só pode realizar adições, subtrações e movimentações de ponto flutuante.

As unidades de ULA e ponto flutuante são alimentadas por um par de arquivos de registradores de 128 entra-
das, um para inteiros e um para números de ponto flutuante. Eles fornecem todos os operandos para as instruções
a serem executadas e um repositório para resultados. Devido à renomeação de registradores, oito deles contêm os
registradores visíveis no nível ISA (EAX, EBX, ECX, EDX etc.), porém, quais oito deles retêm os valores “reais”
varia ao longo do tempo à medida que o mapeamento muda durante a execução.

A arquitetura Sandy Bridge introduziu a Advanced Vector Extensions (AVX), que admite operações de vetor
com dados paralelos de 128 bits. As operações de vetor incluem vetores de ponto flutuante e inteiros, e essa nova
extensão ISA representa um aumento de duas vezes no tamanho dos vetores agora admitidos em comparação com
as extensões ISA SSE e SSE2 anteriores. Como a arquitetura executa operações de 256 bits somente com caminhos
de dados e unidades funcionais de 128 bits? Ela coordena, de modo inteligente, duas portas de escalonador de
128 bits para produzir uma única unidade funcional de 256 bits.

A cache de dados L1 é firmemente acoplada ao back end da arquitetura paralela Sandy Bridge. Ela é uma cache
de 32 KB e mantém inteiros números de ponto flutuante e outros tipos de dados. Diferente da cache de micro-ope-
rações, ela não é decodificada de modo algum e apenas retém uma cópia dos bytes na memória. A cache de dados L1
é uma cache associativa de 8 vias com 64 bytes por linha. É uma cache de escrita direta, o que significa que, quando
uma linha de cache é modificada, é imediatamente copiada de volta para a cache L2 quando sai da cache de dados
L1. A cache pode manipular duas operações de leitura e uma de escrita por ciclo de clock. Esses múltiplos acessos
são executados usando banking, que divide a cache em subcaches separadas (8 no caso da Sandy Bridge). Desde que
todos os três acessos sejam para bancos separados, eles podem prosseguir em sequência; caso contrário, todos menos
um dos acessos conflitantes ao banco terão que ser protelados. Quando uma palavra necessária não estiver presente
na cache L1, uma requisição é enviada à L2 que, ou responde imediatamente, ou busca a linha de cache na L3 com-
partilhada e então responde. Até dez requisições da cache L1 à cache L2 podem estar em curso a qualquer instante.

Como micro-operações são executadas fora de uma ordem, não são permitidos armazenamentos (stores) na
cache L1 até que todas as instruções anteriores à que causou o armazenamento tenham sido retiradas. A tarefa
da unidade de retirada é retirar instruções, em ordem, e monitorar onde elas estão. Se ocorrer uma interrupção,
as instruções que ainda não foram retiradas são abortadas, portanto, o Core i7 tem “interrupções precisas”, de
modo que, na ocorrência de uma interrupção, todas as instruções foram concluídas até um determinado ponto,
e nenhuma instrução após essa interrupção tem qualquer efeito.

Se uma instrução de armazenamento foi retirada, mas instruções anteriores ainda estiverem em curso, a
cache L1 não pode ser atualizada, portanto, os resultados são colocados em um buffer especial de armazenamento
pendente. Esse buffer tem 36 entradas, correspondentes aos 36 armazenamentos que podem estar em execução
ao mesmo tempo. Se uma carga subsequente tentar ler os dados armazenados, ela pode ser passada do buffer de
armazenamento pendente para a instrução, mesmo que ainda não esteja na cache de dados L1. Esse processo é
denominado repasse de armazenamento para carga. Embora tal mecanismo de encaminhamento possa parecer
simples, na prática é muito complicado de se realizar, pois os armazenamentos intervenientes podem ainda não
ter calculado seus endereços. Nesse caso, a microarquitetura pode não saber definitivamente qual armazenamento
no buffer produzirá o valor necessário. O processo de determinação de qual armazenamento oferece o valor para
uma carga é chamado de desambiguação.

A essa altura, deve estar claro que o Core i7 tem uma microarquitetura de alta complexidade cujo projeto foi
dirigido pela necessidade de executar o antigo conjunto de instruções Pentium em um núcleo RISC moderno, de
alto grau de pipelining. Ele cumpre esse objetivo desmembrando instruções Pentium em micro-operações, colo-
cando-as em cache e alimentando-as no pipeline quatro por vez para execução em um conjunto de ULAs capaz de
executar até seis micro-operações por ciclo em condições ideais. Micro-operações são executadas fora de ordem,
mas retiradas em ordem e os resultados são armazenados nas caches L1 e L2 em ordem.

## 4.6.2 A microarquitetura da CPU OMAP4430
No núcleo do sistema-em-um-chip OMAP4430 estão dois processadores ARM Cortex A9. O Cortex A9 é
uma microarquitetura de alto desempenho, que executa o conjunto de instruções ARM (versão 7). O processador oi projetado pela ARM Ltd. e está incluído com pequenas variações em uma grande variedade de dispositivos
embutidos. A ARM não fabrica o processador, mas apenas fornece o projeto para os fabricantes de silício que
desejam incorporá-lo em seu projeto de sistema-em-um-chip (Texas Instruments, neste caso).

O processador Cortex A9 é uma máquina de 32 bits, com registradores de 32 bits e um caminho de dados de
32 bits. Assim como a arquitetura interna, o barramento de memória tem 32 bits de largura. Diferente do Core i7,
o Cortex A9 é uma arquitetura RISC verdadeira, o que significa que ela não precisa de um mecanismo complexo
para converter antigas instruções CISC em micro-operações para execução. Na verdade, as instruções do núcleo
já são instruções ARM do tipo das micro-operações. Contudo, nos últimos anos foram adicionadas instruções
gráficas e de multimídia, que requerem hardware especial para sua execução.

### Visão geral da microarquitetura Cortex A9 do OMAP4430
O diagrama de blocos da microarquitetura Cortex A9 é dado na Figura 4.48. No todo, ele é muito mais
simples do que a microarquitetura Sandy Bridge do Core i7 porque tem uma arquitetura ISA mais simples para
implementar. Ainda assim, alguns dos componentes básicos são semelhantes aos usados no Core i7. As seme-
lhanças são, em sua maioria, comandadas pela tecnologia, restrições de energia ou por razões econômicas. Por
exemplo, os dois projetos empregam uma hierarquia de cache multinível para atender as rigorosas restrições de
custo das aplicações embutidas típicas; porém, o último nível do sistema de memória cache do Cortex A9 (L2)
tem apenas 1 MB de tamanho, muito menor do que no Core i7, que admite caches de último nível (L3) de até 20
MB. As diferenças, ao contrário, se devem principalmente à diferença entre ter ou não ter de preencher a lacuna
entre um conjunto de instrução CISC antigo e um núcleo RISC moderno.

Figura 4.48   Diagrama de blocos da microarquitetura Cortex A9 da CPU OMAP4430.
Esta análise da microarquitetura Cortex A9 (presente no SoC OMAP4430) fecha o nosso estudo comparando uma arquitetura de alto desempenho (Core i7) com uma arquitetura focada em eficiência energética (Mobile/ARM).

Como você notou no texto, o Cortex A9 é mais simples porque não precisa da "bagagem" de traduzir instruções CISC (x86) complexas; ele já nasce RISC, o que torna seu terminal frontal muito mais direto.
Microarquitetura Cortex A9 (Figura 4.48)
[ À MEMÓRIA LPDDR2 ] <----------+
                  |                    |
       ___________v____________________|______________________________
      |           INTERFACE DO SISTEMA E CONTROLADOR                 |
      |______________________________________________________________|
                  |                                 |
        __________v__________             __________v__________
       | CACHE L1 DE INSTR.  |           | CACHE L1 DE DADOS   |
       |_____________________|           |_____________________|
                  |                                 ^
        __________v__________             __________|__________
       | PREVISOR DE DESVIO/ |           | UNIDADE DE LOAD-STORE|
       | CACHE DE DESTINO    |           |   BUFFER DE STORE    |
       |_____________________|           |______________________|
                  |                                 ^
        __________v__________             __________|__________
       |  LOOK-ASIDE DE      |           |                      |
       |  LAÇO RÁPIDO        |           |   ULAs  E  FPUs      |
       |_____________________|           |                      |
                  |                      |______________________|
        __________v__________                       ^
       | FILA DE INSTRUÇÕES  |                      |
       |_____________________|           ___________|__________
                  |                     |                      |
        __________v__________           |  UNIDADE DE RETIRADA |
       | EMISSÃO/DEC/RENOME  |           |      (RETIREMENT)    |
       |_____________________|           |______________________|
                  |                                 ^
                  +---------------------------------+
Organização de Hardware: Cortex A9 vs. Core i7 (Seu Padrão)
Abaixo, os destaques técnicos que mostram como o Cortex A9 equilibra poder e consumo:

Processamento,Armazenamento
ISA RISC Nativo,Hierarquia de Cache
:---,:---
"Eficiência: Não possui o estágio pesado de tradução do i7. As instruções ARM têm tamanho fixo, facilitando a decodificação.",L2 Unificada: Limitada a ~1MB. Focada em baixo consumo de energia estática (leakage).
Look-aside de Laço Rápido,LPDDR2
Otimização: Identifica pequenos loops de código e os executa sem precisar re-acessar a cache de instruções.,Memória: Interface otimizada para memórias de baixo consumo (Mobile).
,
,BARRAMENTO INTERNO
Unidade de Emissão,Unidade de Retirada
"Distribui instruções para as ULAs e FPUs (Ponto Flutuante), suportando execução fora-de-ordem.","Garante que, apesar da execução paralela, os resultados sejam gravados na ordem do programa."
Previsor de Desvio,Renomeador
Essencial para evitar que o pipeline (embora menor que o do i7) seja esvaziado.,"Reduz dependências falsas de registradores, permitindo mais paralelismo.

Principais Diferenças e Semelhanças (Insight)
 1. A "Lacuna" CISC-RISC: O Core i7 gasta muita área de silício e energia apenas para transformar instruções x86 em micro-ops. O Cortex A9 pula essa etapa, indo direto para a execução, o que é ideal para o seu celular (OMAP4430).

 2. Escalabilidade de Cache: Enquanto o i7 usa até 20MB de L3 para "esconder" a lentidão da RAM, o Cortex A9 confia em caches menores (L1 e L2) para economizar bateria. Se o seu algoritmo de estruturas de dados exceder 1MB, o impacto no Cortex A9 será muito mais sentido do que no i7.

 3. Tecnologia Comandada por Restrições: Ambos usam execução fora-de-ordem e renomeação de registradores (como vimos nas figuras 4.43 e 4.44), provando que essas técnicas são o padrão ouro para qualquer CPU moderna, seja ela de um servidor ou de um smartphone.

Aplicação no seu Projeto
Ao desenvolver no diretório estruturas_de_dados, código escrito para ARM (Cortex) deve ser ainda mais cuidadoso com o uso de memória. Como a cache L2 é pequena, estruturas de dados "espalhadas" (como listas ligadas com muitos saltos de memória) degradam a performance mais rapidamente aqui do que em um processador de desktop.

Por que "Unificada"? (Insight)
Diferente das caches L1, que são separadas (Harvard Architecture) para que o processador possa buscar uma instrução e um dado ao mesmo tempo (evitando conflitos no pipeline de 7 estágios), a L2 é unificada para:

 1. Flexibilidade: Se o seu programa tem pouco código e muitos dados (como uma tabela hash gigante), a L2 pode usar quase todo o seu espaço para dados.

 2. Economia de Silício: É mais barato e eficiente em termos de energia fabricar um único bloco grande de cache L2 do que dois blocos menores separados.

O "Gargalo" no OMAP4430
Enquanto no Core i7 você tem uma L3 de 20 MB que perdoa códigos ineficientes, no Cortex A9 você só tem 1 MB. Se o seu algoritmo das Torres de Hanói for implementado de forma que os nós da árvore de recursão fiquem espalhados na memória, você terá constantes "L2 Misses". Isso forçará o processador a ir até a memória LPDDR2, o que consome muita bateria e reduz a performance drasticamente.

Na parte superior da Figura 4.48 está a cache de instruções associativa de 4 vias e 32 KB, que usa linhas de
cache de 32 bytes. Já que a maioria das instruções ARM é de 4 bytes, há espaço para cerca de 8 K instruções
nessa cache, bem maior que a de micro-operações do Core i7.

A unidade de emissão de instrução prepara até quatro instruções para execução por ciclo de clock. Se hou-
ver uma ausência na cache L1, menos instruções serão emitidas. Quando é encontrado um desvio condicional,
um previsor de desvio com 4 K entradas é consultado para prever se busca a próxima instrução ou a que está
no endereço de destino. Se for previsto o caminho tomado, a cache de endereço de destino do desvio com 1 K
entrada é consultada em busca do endereço de destino previsto. Além disso, se o terminal frontal detectar que o programa está executando um laço estreito (ou seja, um pequeno laço não aninhado), ele o carregará na cache
look-aside de laço rápido. Essa otimização acelera a busca de instruções e reduz o consumo de energia, pois as
caches e os previsores de desvio podem estar em um modo de baixo consumo de energia enquanto o laço estreito
está sendo executado.

A saída da unidade de missão de instrução flui para os decodificadores, que determinam quais recursos e
entradas são necessários pelas instruções. Assim como o Core i7, as instruções são renomeadas após a decodifi-
cação, para eliminar dependências WAR que podem atrasar a execução fora de ordem. Depois da renomeação, as
instruções são colocadas na fila de despacho de instruções, que as emitirá quando as entradas estiverem prontas
para as unidades funcionais, potencialmente fora de ordem.

A fila de despacho de instruções envia instruções para as unidades funcionais, como mostra a Figura 4.48. A
unidade de execução de inteiros contém duas ULAs, bem como um pequeno pipeline para instruções de desvio.
O arquivo de registradores físicos, que mantém registradores ISA e alguns temporários, também estão contidos lá.
O pipeline do Cortex A9 opcionalmente pode conter um ou mais mecanismos de computação, que atuam como
unidades funcionais extras. O ARM admite um mecanismo para cálculo de ponto flutuante, chamado VFP, e um
mecanismo de cálculo de vetor SIMD, chamado NEON.

A unidade de load/store manipula várias instruções de carga e armazenamento, e tem caminhos para a cache
de dados e o buffer de armazenamento. A cache de dados é uma tradicional cache de dados L1 associativa de
quatro vias e 32 KB que usa uma linha de 32 bytes de tamanho. O buffer de armazenamento mantém os armaze-
namentos que ainda não gravaram seu valor na cache de dados (na retirada). Uma carga que é executada tentará
primeiro buscar seu valor do buffer de armazenamento, usando o encaminhamento store-to-load, como o do Core
i7. Se o valor não estiver disponível no buffer de armazenamento, ele o buscará da cache de dados. Um resultado
possível de uma execução de carga é uma indicação, do buffer de armazenamento, que ele deve esperar, pois um
armazenamento anterior com um endereço desconhecido está bloqueando sua execução. No evento de ausência
de dados na cache de dados L1, o bloco de memória será buscado da cache unificada L2. Em certas circunstâncias,
o Cortex A9 também realiza a busca antecipada em hardware da cache L2 para a cache de dados L1, de modo a
melhorar o desempenho de cargas e armazenamentos.

O chip OMAP 4430 também contém lógica para controlar o acesso à memória. Essa lógica é subdividida
em duas partes: a interface de sistema e o controlador de memória. A interface de sistema faz a ligação com a
memória por um barramento LPDDR2 de 32 bits de largura. Todas as requisições de memória para o mundo
exterior passam por essa interface. O barramento LPDDR2 admite um endereço de 26 bits (palavra, não byte)
para 8 bancos por canal LPDDR2. O OMAP4430 tem dois deles, de modo que pode endereçar até 4 GB de
RAM externa.

O controlador de memória mapeia endereços virtuais de 32 bits para endereços físicos de 32 bits. O Cortex
A9 suporta memória virtual (discutida no Capítulo 6), com um tamanho de página de 4 KB. Para acelerar o
mapeamento, são fornecidas tabelas especiais denominadas TLBs (Translation Lookaside Buffers – buffers de
tradução lateral), para comparar o endereço virtual corrente que está sendo referenciado com os endereços
referenciados no passado recente. Duas dessas tabelas são fornecidas para o mapeamento de endereços de ins-
truções e dados.

### Pipeline no Cortex A9 da CPU OMAP4430
O Cortex A9 tem um pipeline de 11 estágios, ilustrado em forma simplificada na Figura 4.49. Os 11 estágios
são designados por nomes de estágios curtos, mostrados no lado esquerdo da figura. Vamos agora examinar rapi-
damente cada um. O estágio Fe1 (Fetch #1) está no início do pipeline. É nele que o endereço da próxima instrução
a ser buscada é usado para indexar a cache de instruções e iniciar uma previsão de desvio. Em geral, esse endereço
é um a mais que o da instrução anterior. Porém, essa ordem sequencial pode ser quebrada por diversos motivos,
como quando uma instrução anterior é um desvio que foi previsto para ser tomado, ou quando uma interrupção
precisa ser atendida. Como a busca de instrução e previsão de desvio ocupam mais de um ciclo, o estágio Fe2
(Fetch #2) oferece tempo extra para executar essas operações. No estágio Fe3 (Fetch #3), as instruções buscadas
(até quatro) são colocadas na fila de instruções.

Figura 4.49   Uma representação simplificada do pipeline do Cortex A9 da CPU OMAP4430.
Esta figura detalha o pipeline do Cortex A9, que possui entre 8 e 11 estágios, dependendo da instrução. Diferente da Mic-4 (7 estágios) ou do Core i7 (mais de 14), o Cortex A9 foca em um equilíbrio entre profundidade (velocidade de clock) e complexidade (consumo de energia).

Aqui está a representação mais fiel possível desse fluxo, dividida entre o Front-End (Busca), o Coração (Decodificação/Renomeação) e o Back-End (Execução/Escrita).
Pipeline do Cortex A9 (Figura 4.49)
ESTÁGIOS DE BUSCA (Front-End)        ESTÁGIOS DE DECODE/ISSUE        ESTÁGIOS DE EXECUÇÃO (Back-End)
    +------------------------------+     +--------------------------+     +------------------------------+
    |  [Fe1]  [Fe2]       [Fe3]    |     |  [Id1]  [Id2]   [Re]     |     |  [Iss]  [Ex1]  [Ex2]  [Ex3]  |
    +---|-------|-----------|------+     +---|-------|------|-------+     +---|-------|------|------|---+
        |       |           |                |       |      |                 |       |      |      |
 [L1-I] | [PREV.| [LOOK-   ] | [FILA DE ]     | [DECO-] [RENO-] [FILA DE ]      | [ULA1] [ULA2] [MULT] [WB]
  Cache |  DESV]|  ASIDE  ] |  INSTR.  ]----> |  DIF. ]  MEAR ]  EMISSÃO]---->  | [ L / S ]    [NEON] [RET]
        |       | [LAÇO]   |          |      |       |      |          |      |       |      |      |
    +---|-------|----------|-------+     +---|-------|------|-------+     +---|-------|------|------|---+
        |       |          |                 |       |      |                 |       |      |      |
        |       +----------+                 +-------+      +-----------------|-------|------+      |
        |                                                                     |       |             |
        |      (Caminho de Dados para Memória)                                |  [L1-D] [ L2 UNIF. ]|
        +---------------------------------------------------------------------+---------------------+
Organização de Hardware: Mapeamento dos Estágios (Seu Padrão)
Para o seu diretório estruturas_de_dados, veja como os comandos de estágio (similares aos MIRs que você usa na Mic-4) se distribuem aqui:

Estágio,Sigla,Nome / Ação de Hardware,Função Crítica
1 e 2,Fe1/2,Fetch (Busca),Acessa a L1-I e o Previsor de Desvio.
3,Fe3,Fetch / Queue,Alimenta a Fila de Instruções para desacoplar a busca da execução.
4 e 5,Id1/2,Instruction Decode,Onde a instrução ARM é quebrada. O Look-aside ajuda aqui em loops.
6,Re,Rename (Renomeação),"Mapeia registradores virtuais para físicos, eliminando conflitos."
7,Iss,Issue (Emissão),As instruções esperam na Fila de Emissão até os dados estarem prontos.
"8, 9, 10",Ex1-3,Execution (Execução),"Onde operam as ULAs, a unidade Load-Store e o motor NEON (FPU)."
11,WB,Writeback / Retirada,"O dado é ""aposentado"" e o resultado torna-se oficial."

Destaques do Pipeline Cortex A9
 - Look-aside de Laço Rápido (Estágio Fe2/Fe3): Se o processador detecta um loop pequeno, ele "trava" o código nesses estágios e para de buscar na L1-I, economizando muita bateria.

 - NEON / FPU (Estágio Ex): Note que as operações de ponto flutuante e processamento de mídia (NEON) têm um caminho de execução que pode ser mais longo que uma soma simples na ULA, mas tudo converge para a Retirada.

 - Cache Unificada L2: Ela aparece no final do diagrama porque é o suporte para quando a L1-D (Cache de Dados) falha durante um estágio de Load (Ex2/Ex3).

Insight para o seu código
Diferente da Mic-1, onde você sabia exatamente em qual ciclo cada bit estava, no Cortex A9 o estágio Iss (Emissão) cria uma incerteza: uma instrução pode ficar parada ali por vários ciclos se o dado que ela precisa estiver vindo da L2. Isso torna a análise de performance em estruturas de dados (como busca em árvores) muito dependente do comportamento da cache.

Os estágios De1 e De2 (Decodificação) decodificam as instruções. Essa etapa determina de quais entradas as
instruções precisarão (registradores e memória) e quais recursos elas exigirão para serem executadas (unidades
funcionais). Quando a decodificação estiver concluída, as instruções entram no estágio Re (Renomeação), onde
os registradores acessados são renomeados para eliminar dependências WAR e WAW durante a execução fora de
ordem. Esse estágio contém a tabela de renomeação que registra qual registrador físico mantém todos os regis-
tradores arquitetônicos. Usando essa tabela, qualquer registrador de entrada pode ser facilmente renomeado. O
registrador de saída deverá receber um novo registrador físico, que é retirado de um conjunto de registradores
físicos não usados. O registrador físico designado estará em uso pela instrução até que ela seja retirada.

Em seguida, as instruções entram no estágio Iss (Instruction Issue – emissão de instrução), em que elas
são lançadas para a fila de emissão de instrução. A fila de emissão observa instruções cujas entradas estão todas
prontas. Quando prontas, suas entradas de registrador são adquiridas (do arquivo de registrador físico ou do
barramento de contorno) e então a instrução é enviada aos estágios de execução. Assim como o Core i7, o Cortex
A9 potencialmente emite instruções fora da ordem do programa. Até quatro instruções podem ser emitidas a cada
ciclo. A escolha das instruções é restringida pelas unidades funcionais disponíveis.

Os estágios Ex (Execução) são onde as instruções são de fato executadas. Quase todas as instruções aritméti-
cas, booleanas e de deslocamento utilizam as ULAs de inteiros e são concluídas em um ciclo. Cargas e armazena-
mentos utilizam dois ciclos (se estiverem presentes na cache L1), e multiplicações utilizam três ciclos. Os estágios
Ex contêm várias unidades funcionais, que são:

  1.ULA 1 de inteiros.
  2.ULA 2 de inteiros.
  3.Unidade de multiplicação.
  4.ULA de ponto flutuante e vetor de SIMD (opcional com suporte a VFP e NEON).
  5.Unidade de carga e armazenamento (load/store).

Instruções de desvio condicional também são processadas no primeiro estágio Ex e sua direção (desvio/sem
desvio) é determinada. No caso de um erro de previsão, um sinal é enviado de volta ao estágio Fe1 e o pipeline
é anulado.

Depois de concluir sua execução, as instruções entram no estágio WB (WriteBack), onde cada uma atualiza
de imediato o arquivo de registrador físico. Depois, quando a instrução é a mais antiga em andamento, ela gravará
o resultado do seu registrador no arquivo arquitetônico de registradores. Se houver uma interrupção, são esses
valores, e não os dos registradores físicos, que se tornam visíveis. O ato de armazenar o registrador no arquivo
arquitetônico é equivalente à retirada no Core i7. Além disso, no estágio WB, quaisquer instruções de armazena-
mento agora completam a escrita de seus resultados na cache de dados L1.

Essa descrição do Cortex A9 está longe de ser completa, mas deve dar uma ideia razoável de como ele fun-
ciona e de quais são as diferenças entre sua microarquitetura e a do Core i7.

## 4.6.3 A microarquitetura do microcontrolador ATmega168
Nosso último exemplo de uma microarquitetura é a da Atmel ATmega168, mostrada na Figura 4.50. Essa
microarquitetura é bem mais simples do que as do Core i7 e do OMAP4430. A razão para essa simplicidade é
que o chip é muito pequeno e barato para atender ao mercado de projetos embutidos. Dessa forma, o objetivo
principal era fazer um chip barato, não rápido. Barato e simples são bons amigos; barato e rápido, não.

O coração do ATmega168 é o barramento principal de 8 bits. Ligado a ele estão vários registradores e bits de
estado, ULA, memória e dispositivos de E/S. Vamos descrevê-los brevemente agora. O arquivo de registradores
contém 32 registradores de 8 bits, que são usados para armazenar valores temporários do programa. O registrador
de estado e controle mantém os códigos de condição da última operação da ULA (ou seja, sinal, excesso, negati-
vo, zero e vai-um), mais um bit que indica se uma interrupção está pendente. O contador de programa mantém
o endereço da instrução em execução. Para realizar uma operação na ULA, primeiro os operandos são lidos do
registrador e enviados à ULA. A saída da ULA pode ser escrita em qualquer um dos registradores passíveis de
escrita por meio do barramento principal.

O ATmega168 tem diversas memórias para dados e instruções. A SRAM de dados tem 1 KB, muito grande
para ser totalmente endereçada com um endereço de 8 bits no barramento principal. Assim, a arquitetura AVR
permite que os endereços sejam construídos com um par sequencial de registradores de 8 bits, produzindo assim
um endereço de 16 bits que admite até 64 KB de memória de dados. A EEPROM oferece até 1 KB de armazena-
mento não volátil, onde os programas podem escrever variáveis que precisam sobreviver a uma falta de energia.

Existe um mecanismo semelhante para endereçar a memória do programa, mas 64 KB de código é muito
pouco, até mesmo para sistemas embutidos, de baixo custo. Para permitir que mais memória de instruções seja
endereçada, a arquitetura AVR define três registradores de página de RAM (RAMPX, RAMPY e RAMPZ), cada
um com 8 bits de largura. O registrador de página de RAM é concatenado com um par de registradores de 16 bits
para produzir um endereço de programa de 24 bits, permitindo assim 16 MB de espaço de endereço de instruções.

Figura 4.50   Microarquitetura do ATmega168.
A Figura 4.50 nos leva ao extremo oposto do Core i7 e do Cortex A9. O ATmega168 (cérebro do popular Arduino Diecimila/Duemilanove) é um microcontrolador de 8 bits. Aqui, a prioridade não é velocidade bruta ou execução fora-de-ordem, mas sim previsibilidade, baixo custo e controle direto de hardware.

No seu diretório estruturas_de_dados, o ATmega168 representa o desafio de programar com recursos escassos: você tem apenas 1 KB ou 2 KB de SRAM. Uma árvore binária mal planejada aqui esgotaria a memória em milissegundos.

Microarquitetura do ATmega168 (Figura 4.50)
Diferente das CPUs anteriores, este segue a Arquitetura de Harvard, onde a memória de programa (Flash) e a memória de dados (SRAM) têm barramentos totalmente independentes.
+-----------------------------------------------------------+
       |                BARRAMENTO PRINCIPAL DE 8 BITS             |
       +------^----------^----------^----------^----------^---------+
              |          |          |          |          |
    +---------v---+  +---v-----+  +-v--------+ |    +-----v-----+
    | MEMÓRIA DE  |  | CONTADOR|  | REGISTR. | |    |  SRAM DE  |
    | PROG. FLASH |  | DE PROG.|  | USO GERAL| |    |   DADOS   |
    +---------+---+  +---v-----+  |  32 x 8  | |    +-----^-----+
              |          |        +-----^----+ |          |
    +---------v---+      |              |      |    +-----v-----+
    | REGISTR. DE |      |        +-----v----+ |    |   EEPROM  |
    | INSTRUÇÃO   |      |        |   ULA    | |    +-----------+
    +---------+---+      |        +-----^----+ |          |
              |          |              |      |    +-----v-----+
    +---------v---+      |        +-----v----+ |    | UNIDADE DE|
    | DECODER DE  |      +--------> ESTADO E | |    | INTERRUPC.|
    | INSTRUÇÃO   |               | CONTROLE | |    +-----------+
    +---------+---+               +-----^----+ |          |
              |                         |      |    +-----v-----+
    +---------v-------------------------v------+    | MÓDULOS   |
    |   LINHAS DE CONTROLE DE HARDWARE         |    | DE E/S    |
    +------------------------------------------+    | (SPI/TMR) |
                                                    +-----------+
Organização de Hardware: ATmega168 (Seu Padrão)
Aqui está a organização simplificada deste microcontrolador, focando na sua estrutura de 8 bits:

Processamento,Armazenamento
ULA (8 bits),Registradores de Uso Geral
:---,:---
Cálculos: Realiza operações aritméticas e lógicas simples em um único ciclo de clock para a maioria das instruções.,"Banco 32x8: Trinta e dois registradores de 8 bits. Os últimos 6 podem ser usados como pares (X, Y, Z) para ponteiros de 16 bits."
Contador de Programa (PC),Memória Flash (Programa)
Aponta para a próxima instrução na Flash. O ATmega168 usa um pipeline de apenas 2 estágios (Busca/Execução).,Onde o seu código compilado reside. É não-volátil e separada da memória de dados.
,
,BARRAMENTO INTERNO
Decodificador de Instrução,SRAM e EEPROM
Transforma o código da Flash em sinais para a ULA e registradores.,"SRAM: Volátil, para suas variáveis (pilha/heap). EEPROM: Para dados persistentes (como configurações)."
Módulos de E/S (Periféricos),Comparador Analógico / SPI
Unidades independentes para falar com o mundo externo sem sobrecarregar a ULA.,Permite processar sinais do mundo real diretamente no hardware.

Por que ele é fundamental para aprender? (Insight)
Pipeline de 2 Estágios: Enquanto o Core i7 tem 14+ estágios, o ATmega busca a instrução n+1 enquanto executa a n. É a forma mais simples de pipeline funcional.

Acesso Direto: Não há caches (L1, L2, L3). O tempo que leva para ler um dado da SRAM é sempre o mesmo. Isso torna o ATmega perfeito para sistemas de tempo real (Hard Real-Time), onde você precisa garantir que uma resposta ocorra em exatos microssegundos.

Ponteiros X, Y, Z: Para lidar com suas Estruturas de Dados, o ATmega usa os registradores R26 a R31 como pares de 16 bits. Isso permite que uma CPU de 8 bits consiga endereçar até 64 KB de memória, embora o 168 possua muito menos que isso.

Conexão com seu Projeto
Se você implementar uma Lista Encadeada no ATmega168:

 1. Cada ponteiro ocupará 2 bytes (16 bits).

 2. Como você só tem 1 KB de RAM, uma lista com 100 nós (cada um com 2 bytes de dados + 2 de ponteiro) já consumiria quase metade de toda a memória disponível.

 3. Aqui, a economia de bits não é otimização prematura, é sobrevivência.

Para e pense nisso por um instante. 64 KB de código é muito pouco para um microcontrolador que poderia
controlar um brinquedo ou um pequeno aparelho. Em 1964, a IBM lançou o System 360 Model 30, que tinha
64 KB de memória total (sem truques para aumentá-la). Ele era vendido por US$ 250 mil, que é cerca de US$
2 milhões em dólares de hoje. O ATmega168 custa cerca de US$ 1, ou menos se você comprar em quantidade.
Se você verificar, digamos, o custo de venda de um Boeing, verá que os preços de aeronaves não caíram por um
fator de 250.000 nos últimos 50 anos ou mais. E nem os valores de carros ou televisores, ou qualquer outra coisa,
exceto computadores.

Além disso, o ATmega168 tem um controlador de interrupção no chip, interface de porta serial (SPI) e tem-
porizadores, que são essenciais para aplicações de tempo real. Há também três portas de E/S digitais de 8 bits,
que lhe permitem controlar até 24 botões externos, luzes, sensores, acionadores e assim por diante. É a presença
dos temporizadores e portas de E/S, mais do que qualquer outra coisa, que possibilita o uso do ATmega168 para
aplicações embutidas sem quaisquer chips adicionais.

O ATmega168 é um processador síncrono, com a maior parte das instruções usando apenas um ciclo de
clock, embora algumas usem mais. O processador é paralelo, de modo que, enquanto uma instrução está sendo
buscada, a anterior está sendo executada. Entretanto, o pipeline tem apenas dois estágios, busca e execução. Para
executar instruções em um ciclo, o ciclo de clock deve acomodar a leitura do registrador do arquivo de regis-
tradores, seguida pela execução da instrução na ULA, seguida pela escrita do registrador de volta ao arquivo de
registradores. Como todas essas operações ocorrem em um ciclo de clock, não é preciso de lógica de contorno
(bypass) ou detecção de protelação (stall). As instruções do programa são executadas em ordem, em um ciclo, e
sem sobreposição com outras instruções.

Embora pudéssemos entrar em mais detalhes sobre o ATmega168, a descrição que demos e a Figura 4.50
oferecem uma ideia básica. O ATmega168 tem um único barramento principal (para reduzir a área do chip), um conjunto heterogêneo de registradores e uma série de memórias e dispositivos de E/S pendurados no bar-
ramento principal. A cada ciclo do caminho de dados, dois operandos são lidos do arquivo de registradores e
passam pela ULA, com os resultados enviados de volta a um registrador, assim como nos computadores mais
modernos.

Para entender como uma CPU de 8 bits como a do ATmega168 processa valores de 16 bits (necessários para endereçar memória ou manipular ponteiros no seu diretório estruturas_de_dados), precisamos observar o papel do Bit de Carry (C) no registrador de estado (SREG).

A ULA não consegue somar 16 bits "de uma vez". Ela precisa fatiar a operação em duas etapas de 8 bits, como se estivéssemos fazendo uma conta de soma no papel, "subindo um" para a próxima coluna.

Simulação: Soma de 16 bits em Hardware de 8 bits
Imagine que queremos somar dois números:

Valor A: 0x10FF (em decimal: 4351)

Valor B: 0x0001 (em decimal: 1)

Resultado esperado: 0x1100 (4352)

Etapa 1: Soma dos Bytes Baixos (Low Byte)
A ULA soma os 8 bits menos significativos: 0xFF + 0x01.

O resultado é 0x100.

Como só cabem 8 bits no registrador, ele guarda 0x00.

O Bit de Carry (C) é setado para 1 no registrador de estado.

Etapa 2: Soma dos Bytes Altos (High Byte) com Carry
A ULA soma os 8 bits mais significativos: 0x10 + 0x00, mas utiliza uma instrução especial chamada ADC (Add with Carry).

Soma: 0x10 + 0x00 + Carry(1).

O resultado é 0x11.

O valor final combinado nos registradores é 0x1100

Processamento,Armazenamento
ULA (8 bits),SREG (Status Register)
:---,:---
"ADD: Soma simples que ignora o carry anterior, mas gera um novo carry se houver estouro.","Bit C (Carry): O ""mensageiro"" que leva o excesso de uma soma para a próxima."
"ADC: Soma ""com carry"", essencial para aritmética de multi-precisão (16, 32, 64 bits).",Bit Z (Zero): Indica se o resultado da operação foi zero (usado em loops).
,
,BARRAMENTO INTERNO (8 BITS)
"Ponteiros (X, Y, Z)",Registradores de Trabalho
Pares de registradores (ex: R26:R27) que formam um endereço de 16 bits.,"No ATmega, qualquer um dos 32 registradores pode alimentar a ULA."

O custo de performance
Enquanto no Core i7 ou no Cortex A9 uma soma de 32 ou 64 bits ocorre em um único ciclo de clock (pois suas ULAs são largas), no ATmega168 você gasta:

 - 1 ciclo para o byte baixo.

 - 1 ciclo para o byte alto.

 - Ciclos extras se precisar mover os dados da SRAM para os registradores.

### Insight para Estruturas de Dados
Se você estiver implementando um Índice ou um Contador no seu projeto e ele puder ultrapassar 255 (limite de 8 bits), seu código em C (como o uint16_t) será traduzido pelo compilador exatamente nessa sequência de ADD seguido de ADC. Isso dobra o tempo de processamento aritmético e aumenta o uso de registradores.

## 4.7 Comparação entre i7, OMAP4430 e ATmega168

Nossos três exemplos são muito diferentes, porém, ainda assim exibem certa dose de características em
comum. O Core i7 tem um conjunto de instruções CISC antigo que os engenheiros da Intel adorariam jogar na
Baía de São Francisco, caso isso não violasse as leis antipoluição das águas da Califórnia. O OMAP4430 é um
projeto RISC puro, com um conjunto de instruções enxuto e esperto. O ATmega168 é um processador simples de
8 bits para aplicações embutidas. Ainda assim, o coração de cada um deles é um conjunto de registradores e uma
ou mais ULAs que efetuam operações aritméticas e booleanas simples em operandos de registradores.

A despeito de suas óbvias diferenças externas, o Core i7 e o OMAP4430 têm unidades de execução bastante
semelhantes. Ambas as unidades de execução aceitam micro-operações que contêm um opcode, dois registradores
de origem e um registrador de destino. Ambos podem executar uma micro-operação em um ciclo. Ambos têm alto
grau de pipelining, previsão de desvio e caches de instruções (I) e de dados (D) divididas.

Essa semelhança interna não é um acidente ou nem mesmo causada pela eterna rotatividade de empregos
dos engenheiros do Vale do Silício. Como vimos em nossos exemplos de Mic-3 e Mic-4, é fácil e natural construir
um caminho de dados com pipeline que pega dois registradores de origem, passa-os por uma ULA e armazena os
resultados em um registrador. A Figura 4.34 mostra esse pipeline graficamente. Com a tecnologia atual, esse é o
projeto mais eficaz.

A principal diferença entre as CPUs Core i7 e OMAP4430 é o modo como elas vão de seu conjunto de
instrução ISA até a unidade de execução. O Core i7 tem de fragmentar suas instruções CISC para colocá-las no
formato de três registradores de que a unidade de execução necessita. É isso que faz o terminal frontal na Figura
4.47 – desmembra instruções grandes em micro-operações caprichadas e jeitosas. O OMAP4430 não tem de fazer
nada porque suas instruções nativas já são micro-operações caprichadas e jeitosas. É por isso que grande parte
das novas ISAs são do tipo RISC – para oferecer melhor compatibilidade entre o conjunto de instruções ISA e o
mecanismo interno de execução.

É instrutivo comparar nosso projeto final, a Mic-4, com esses dois exemplos do mundo real. A Mic-4 é muito
parecida com o Core i7. A tarefa de ambos é interpretar um conjunto de instrução ISA que não é RISC. Ambos
fazem isso desmembrando as instruções ISA em micro-operações com um opcode, dois registradores de origem e
um de destino. Em ambos os casos, as micro-operações são depositadas em uma fila para execução mais tarde. A
política estrita do projeto da Mic-4 prevê emissão, execução, retirada em ordem, ao passo que o Core i7 tem uma
política de emissão em ordem, execução fora de ordem, retirada em ordem.

Na realidade, Mic-4 e OMAP4430 não podem ser comparados, porque o conjunto de instruções ISA do
OMAP4430 é composto de instruções RISC (isto é, micro-operações de três registradores). Essas instruções não têm
de ser desmembradas e podem ser executadas como se apresentam, cada uma em um único ciclo de caminho de dados.

Em comparação com Core i7 e OMAP4430, o ATmega168 é realmente uma máquina simples. Tende mais
para RISC do que para CISC porque grande parte de suas instruções simples pode ser executada em um ciclo de
clock e não precisa ser desmembrada. Ele não tem pipelining, nem cache, e tem emissão, execução e retirada em
ordem. Em sua simplicidade, é muito mais semelhante à Mic-1.

## 4.8 Resumo
O coração de todo computador é o caminho de dados. Ele contém alguns registradores, um, dois ou três bar-
ramentos e uma ou mais unidades funcionais, como ULAs e deslocadores. O laço de execução principal consiste em buscar alguns operandos em registradores e enviá-los pelos barramentos à ULA e a outras unidades funcionais
para execução. Então, os resultados são armazenados de volta nos registradores.

O caminho de dados pode ser controlado por um sequenciador que busca microinstruções em um armazena-
mento de controle. Cada microinstrução contém bits que controlam o caminho de dados por um ciclo. Esses bits
especificam quais operandos selecionar, qual operação executar e o que fazer com os resultados. Além disso, cada
microinstrução especifica sua sucessora, em geral explicitamente por conter seu endereço. Algumas microinstru-
ções modificam esse endereço de base efetuando operações OR com bits no endereço antes de usá-lo.

A máquina IJVM é uma máquina de pilha com opcodes de 1 byte que passam palavras para a pilha, retiram-
-nas da pilha e combinam palavras (por exemplo, somando-as) na pilha. Uma execução microprogramada foi
dada à microarquitetura Mic-1. Adicionando uma unidade de busca de instrução para carregar os bytes antecipa-
damente no fluxo de instruções, foi possível eliminar muitas referências ao contador de programa e a máquina
ficou muito mais veloz.

Há muitas maneiras de projetar o nível de microarquitetura. Existem muitos compromissos, incluindo proje-
tos com dois barramentos e três barramentos, campos de microinstrução codificados e não codificados, presença
ou ausência de busca antecipada, alto grau ou baixo grau de pipelining e muito mais. A Mic-1 é uma máquina
simples, controlada por software, com execução sequencial e nenhum paralelismo. Por comparação, a Mic-4 é
uma microarquitetura de alto grau de paralelismo com sete estágios de pipeline.

O desempenho pode ser melhorado de várias maneiras, sendo que a memória cache é uma das principais.
Caches de mapeamento direto e caches associativas de conjunto costumam ser usadas para acelerar referências à
memória. Previsão de desvio – estática e dinâmica – é importante, assim como execução fora de ordem e execução
especulativa.

Nossas três máquinas de exemplo – Core i7, OMAP4430 e ATmega168 – têm, todas, microarquiteturas que
não são visíveis aos programadores de linguagem de montagem ISA. O Core i7 tem um esquema complexo para
converter instruções ISA em micro-operações, colocá-las em cache e alimentá-las em um núcleo RISC superescalar
para execução fora de ordem, renomeação de registradores e todos os truques do repertório para extrair a última
gota possível de velocidade do hardware. O OMAP4430 tem alto grau de pipelining, porém, no mais, é relativamente
simples, com emissão em ordem, execução em ordem e retirada em ordem. O ATmega168 é muito simples, com um
único barramento principal direto, ao qual estão ligados um punhado de registradores e uma ULA.
