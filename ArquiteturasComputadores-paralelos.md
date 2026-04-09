![alt text](image-114.png)

# Arquiteturas de computadores paralelos
Embora os computadores continuem a ficar cada vez mais rápidos, as demandas impostas a eles estão crescendo no mínimo com a mesma rapidez. Astrônomos querem simular toda a história do universo, desde o big bang até o final do espetáculo. Cientistas farmacêuticos adorariam projetar em seus computadores medicamentos por encomenda para doenças específicas, em vez de ter de sacrificar legiões de ratos. Projetistas de aeronaves poderiam inventar produtos mais eficientes no consumo de combustível se os computadores pudessem fazer todo o trabalho sem a necessidade de construir protótipos físicos para testar em túneis aerodinâmicos. Em
suma, seja qual for a capacidade de computação disponível, para muitos usuários, em especial nas áreas da ciência, engenharia e industrial, ela nunca será suficiente.

Embora as velocidades de clock continuem subindo, velocidades de circuitos não podem aumentar indefinidamente. A velocidade da luz já é um grande problema para projetistas de computadores de alta tecnologia, e as perspectivas de conseguir que elétrons e fótons se movam com maior rapidez são desanimadoras. Questões de
dissipação de calor estão transformando supercomputadores em condicionadores de ar de última geração. Por fim, como o tamanho dos transistores continua a diminuir, chegará um ponto em que cada transistor terá um número tão pequeno de átomos dentro dele que os efeitos da mecânica quântica (por exemplo, o princípio da incerteza de Heisenberg) podem se tornar um grande problema.

Portanto, para enfrentar problemas cada vez maiores, os arquitetos de computadores estão recorrendo cada vez mais a computadores paralelos. Apesar de talvez não ser possível construir uma máquina com uma única CPU e um tempo de ciclo de 0,001 ns, pode ser perfeitamente viável produzir uma com 1.000 CPUs com um tempo
de ciclo de 1 ns cada. Embora esse último projeto use CPUs mais lentas do que o primeiro, sua capacidade total de computação é teoricamente a mesma. E é aqui que reside a esperança.

O paralelismo pode ser introduzido em vários níveis. No nível mais baixo, ele pode ser adicionado ao chip da CPU, por pipeline e projetos superescalares com várias unidades funcionais. Também pode ser adicionado por meio de palavras de instrução muito longas com paralelismo implícito. Características especiais podem ser adicionadas à CPU para permitir que ela manipule múltiplos threads de controle ao mesmo tempo. Por fim, várias CPUs podem ser reunidas no mesmo chip. Juntas, essas características podem equivaler, talvez, a um fator de 10 vezes em desempenho em relação a projetos puramente sequenciais.

No nível seguinte, placas extras de CPU com capacidade de processamento adicional podem ser acrescentadas a um sistema. Em geral, essas CPUs de encaixe têm funções especializadas, tais como processamento de pacotes de rede, processamento de multimídia ou criptografia. No caso de funções especializadas, o fator de ganho também pode ser de, talvez, 5 a 10.

Contudo, para conseguir um fator de cem, de mil, ou de milhão, é necessário replicar CPUs inteiras e fazer que todas elas funcionem juntas com eficiência. Essa ideia leva a grandes multiprocessadores e multicomputa- dores (computadores em cluster). Nem é preciso dizer que interligar milhares de processadores em um grande
sistema gera seus próprios problemas, que precisam ser resolvidos.

Por fim, agora é possível envolver organizações inteiras pela Internet e formar grades de computação fracamente acopladas. Esses sistemas estão apenas começando a surgir, mas têm um potencial interessante para o futuro.

Quando duas CPUs ou dois elementos de processamento estão perto um do outro, têm alta largura de banda, o atraso entre eles é baixo e são muito próximos em termos computacionais, diz-se que são fortemente acoplados. Por outro lado, quando estão longe um do outro, têm baixa largura de banda e alto atraso e são remotos
em termos computacionais, diz-se que são fracamente acoplados. Neste capítulo, vamos examinar os princípios de projeto para essas várias formas de paralelismo e estudar variados exemplos. Começaremos com os sistemas mais fortemente acoplados, os que usam paralelismo no chip, passaremos aos poucos para sistemas cada vez
mais fracamente acoplados, e concluiremos com alguns comentários sobre computação em grade. Esse espectro é ilustrado em linhas gerais na Figura 8.1.

Toda a questão do paralelismo, de uma extremidade do espectro à outra, é um tópico de pesquisa muito atual e concorrido. Por isso, daremos um número muito maior de referências neste capítulo, de preferência a artigos recentes sobre o assunto. Muitas conferências e periódicos também publicam artigos sobre o assunto, e a literatura está crescendo rapidamente.

**• Figura 8.1   (a) Paralelismo no chip. (b) Coprocessador. (c) Multiprocessador. (d) Multicomputador. (e) Grade**

    +------------------------------------------------------------------------+
    |                 TAXONOMIA DE SISTEMAS PARALELOS                        |
    |========================================================================|
    |                                                                        |
    |  (a) CHIP      (b) COPROCES.    (c) MULTIPROC.   (d) MULTICOMP.        |
    |   +-----+        +---+            +-----+          +-----+             |
    |   | {S} |        |CP |            | CPU |          |  M  |             |
    |   | {S} | <---   +---+            +--|--+          +--|--+             |
    |   | CPU |        |CPU| <---        [ M ]           | CPU |             |
    |   +-----+        +---+            +--|--+          +-----+             |
    |                                   | CPU |          |  M  |             |
    |                                   +-----+          +--|--+             |
    |                                                    | CPU |             |
    |                                                    +-----+             |
    |  <--- FORTEMENTE ACOPLADO                       FRACAMENTE ACOPLADO -->|
    +------------------------------------------------------------------------+

![alt text](image-116.png)

    +-----------------------------------------------------------------+
    |                  Arquiteturas                                   |
    +-----------------------------------------------------------------+
    |  Tipo           | Nível de Acoplamento  | Descrição Técnica     |
    +-----------------+-----------------------+-----------------------+
    | (a)             | Fortemente Acoplado   | Múltiplas threads     |
    | Paralelismo     |                       | de execução           |
    | no Chip         |                       | compartilhando        |
    |                 |                       | recursos internos     |
    +-----------------+-----------------------+-----------------------+
    | (b)             | Fortemente Acoplado   | CPU principal         |
    | Coprocessador   |                       | delegando tarefas     |
    |                 |                       | específicas           |
    +-----------------+-----------------------+-----------------------+
    | (c)             | Fortemente Acoplado   | Duas ou mais CPUs     |
    | Multiprocessador|                       | compartilhando M      |
    |                 |                       | através de barramento | 
    +-----------------+-----------------------+-----------------------+
    | (d)             | Fracamente Acoplado   | Cada CPU com M        |
    | Multicomputador |                       | privada e troca de    |
    |                 |                       | mensagens             |
    +-----------------+-----------------------+-----------------------+
    | (e)             | Fracamente Acoplado   | Computadores          |
    | Grade (Grid)    |                       | independentes         |
    |                 |                       | conectados via        |
    |                 |                       | Internet              |
    +-----------------+-----------------------+-----------------------+

## 8.1 Paralelismo no chip
Um modo de aumentar a produtividade de um chip é conseguir que ele faça mais coisas ao mesmo tempo. Em outras palavras, explorar o paralelismo. Nesta seção, vamos estudar alguns modos de conseguir aumentar a velocidade por meio do paralelismo no nível do chip, incluídos paralelismo no nível da instrução, multithreading e a colocação de mais de uma CPU no chip. Essas técnicas são bem diferentes, mas cada uma delas ajuda à sua própria maneira. Mas, em todos os casos, a ideia é conseguir que mais atividades aconteçam ao mesmo tempo.

## 8.1.1 Paralelismo no nível da instrução

Um modo de conseguir paralelismo no nível mais baixo é emitir múltiplas instruções por ciclo de clock. Há duas variedades de CPUs de emissão múltipla: processadores superescalares e processadores VLIW. Na verdade, já comentamos alguma coisa sobre essas duas no livro, mas talvez seja útil revisar aqui esse material.

Vimos CPUs superescalares antes (por exemplo, na Figura 2.5). Na configuração mais comum, em certo ponto do pipeline há uma instrução pronta para ser executada. CPUs superescalares são capazes de emitir múltiplas instruções para as unidades de execução em um único ciclo de clock. O número real de instruções emitidas
depende do projeto do processador, bem como das circunstâncias correntes. O hardware determina o número máximo que pode ser emitido, em geral duas a seis instruções. Contudo, se uma instrução precisar de uma unidade funcional que não está disponível ou de um resultado que ainda não foi calculado, ela não será emitida.

A outra forma de paralelismo no nível da instrução é encontrada em processadores VLIW (Very Long Instruction Word – palavra de instrução muito longa). Na forma original, máquinas VLIW de fato tinham palavras longas que continham instruções que usavam múltiplas unidades funcionais. Considere, por exemplo, o pipeline da Figura 8.2(a), no qual a máquina tem cinco unidades funcionais e pode efetuar, simultaneamente, duas operações com inteiros, uma operação de ponto flutuante, um carregamento e um armazenamento. Uma instrução VLIW para essa máquina conteria cinco opcodes e cinco pares de operandos, um opcode e um par de operandos por unidade funcional. Com 6 bits por opcode, 5 bits por registrador e 32 bits por endereço de memória, as instruções poderiam facilmente ter 134 bits – bem compridas, de fato.

Contudo, esse projeto revelou ser muito rígido porque nem toda instrução podia utilizar todas as unidades funcionais, o que resultava em muitas NO-OP inúteis usadas como filtro, como ilustrado na Figura 8.2(b). Por conseguinte, modernas máquinas VLIW têm um modo de marcar um grupo de instruções que formam um conjunto com um bit de “final de grupo”, conforme mostra a Figura 8.2(c). Então, o processador pode buscar o grupo inteiro e emiti-lo de uma vez só. Cabe ao compilador preparar grupos de instruções compatíveis.

Na verdade, VLIW transfere do tempo de execução para o tempo de compilação o trabalho de determinar quais instruções podem ser emitidas em conjunto. Essa opção não apenas simplifica o hardware e o torna mais rápido, mas também, visto que um compilador otimizador pode funcionar durante um longo tempo se for preciso,
permite que se montem pacotes melhores do que o hardware poderia montar durante o tempo de execução. É claro que tal mudança radical na arquitetura da CPU será difícil de introduzir, como demonstra a lenta aceitação do Itanium, exceto para aplicações de nicho.

Vale a pena observar que o paralelismo no nível da instrução não é a única forma de paralelismo de baixo nível. Outra forma é o paralelismo no nível da memória, no qual há múltiplas operações de memória no ar ao mesmo tempo (Chou et al., 2004).

**•A CPU VLIW TriMedia**
Estudamos um exemplo de uma CPU VLIW, a Itanium-2, no Capítulo 5. Agora, vamos examinar um processador VLIW muito diferente, o TriMedia, projetado pela Philips, a empresa holandesa de equipamentos eletrônicos que também inventou o CD de áudio e o CD-ROM. A utilização pretendida do TriMedia é como um processador embutido em aplicações que fazem uso intensivo de imagem, áudio e vídeo, como reprodutores de CD, DVD e players MP3, gravadores de CD e DVD, televisores interativos, câmeras digitais, filmadoras e assim por diante. Dadas essas áreas de aplicação, não é surpresa que ele seja consideravelmente diferente da Itanium-2, que é uma CPU de uso geral, voltada para servidores de alta tecnologia.

**• Figura 8.2   (a) Pipeline de CPU. (b) Sequência de instruções VLIW. (c) Fluxo de instruções com pacotes marcados.**

A Figura 8.2 é fundamental para o seu eBook, pois ela descreve como os processadores modernos otimizam a execução de tarefas através de paralelismo em nível de instrução. No seu Lenovo IdeaPad, o processador utiliza técnicas similares para garantir que o seu sistema Ubuntu rode de forma fluida mesmo com múltiplas aplicações abertas.

    +-------------------------------------------------------------+
    |              FLUXO DE EXECUÇÃO DA CPU (PIPELINE)            |
    |=============================================================|
    |                                                             |
    |   (a) ESTÁGIOS DO PIPELINE:                                 |
    |   [ BUSCA ] -> [ DECODIFICAÇÃO ] -> [ EMISSÃO ]             |
    |                                         ||                  |
    |          +------------------------------VV--------------+   |
    |          | UNIDADES DE EXECUÇÃO: INTEIRO, PONTO FLUT.,  |   |
    |          | CARGA E ARMAZENAMENTO                        |   |
    |          +------------------------------||--------------+   |
    |                                         VV                  |
    |                                    [ RETIRADA ]             |
    |                                                             |
    |   (b) VLIW: [ OP1 | OP2 | OP3 | OP4 ] (Uma instrução longa) |
    |                                                             |
    |   (c) GRUPOS: [ IL NFS ] / [ IFLS ] / [ IFL ] (Marcadores)  |
    +-------------------------------------------------------------+

![alt text](image-117.png)

    +-------------------------------------------------+
    |                  Conceitos de Processamento     |
    +-------------------------------------------------+
    |  Conceito  | Descrição Técnica                  |
    +------------+------------------------------------+
    | (a)        | A CPU divide a execução de uma     |
    | Pipeline   | instrução em etapas sequenciais:   |
    | de CPU     | Busca, Decodificação, Emissão,     |
    |            | Execução e Retirada.               |
    +------------+------------------------------------+
    | (b)        | Very Long Instruction Word. O      |
    | Sequência  | compilador agrupa operações        |
    | VLIW       | independentes em uma instrução     |
    |            | longa para execução paralela.      |
    +------------+------------------------------------+
    | (c)        | Representa o fluxo de instruções   |
    | Fluxo com  | agrupadas. O processador utiliza   |
    | Pacotes    | Marcadores de final de grupo para  |
    |            | identificar instruções a serem     |
    |            | executadas juntas.                 |
    +------------+------------------------------------+

**• Decodificação dos Símbolos (Legenda Técnica)**
Cada letra no diagrama indica uma unidade funcional específica que será ativada naquele ciclo de clock:

 - I (Inteiro): Operações aritméticas básicas (adição, subtração) ou lógica de bits.

 - L (Carga - Load): Instrução para buscar um dado da memória (RAM/Cache) para o registrador.

 - S (Armazenamento - Store): Instrução para gravar um dado do registrador na memória.

 - F (Ponto Flutuante - Float): Operações matemáticas complexas com casas decimais.

 - Traço (—): Representa um Slot Vazio ou uma operação No-op (sem operação). Indica que, naquele ciclo, aquela unidade funcional específica não tem trabalho a fazer.

    +-----------------------------------------------------------------+
    |                  Unidades de Execução                           |
    +-----------------------------------------------------------------+
    |  Símbolo  | Unidade de Execução | Importância no seu Projeto    |
    +-----------+---------------------+-------------------------------+
    | I         | Unidade Inteira     | Essencial para manipulação    |
    |           |                     | de ponteiros em C e índices   |
    |           |                     | de arrays.                    |
    +-----------+---------------------+-------------------------------+
    | L/S       | Memória (Load/Store)| Crítico para o desempenho do  |
    |           |                     | backup de projetos e acesso   |
    |           |                     | a arquivos .md.               |
    +-----------+---------------------+-------------------------------+
    | /         | Marcador de Grupo   | Define o limite do paralelismo|
    |           |                     | que o seu Ubuntu pode extrair |
    |           |                     | do código.                    |
    +-----------+---------------------+-------------------------------+

O TriMedia é um verdadeiro processador VLIW, no qual todas as instruções contêm até cinco operações. Em
condições completamente ideais, a cada ciclo de clock é iniciada uma instrução e são emitidas cinco operações. O
clock funciona a 266 MHz ou 300 MHz; porém, como ele pode emitir cinco operações por ciclo, a velocidade efe-
tiva de clock é cinco vezes mais alta. Na discussão a seguir, focalizaremos a implementação TM3260 do TriMedia;
as diferenças em relação a outras versões são muito pequenas.

Uma instrução típica é ilustrada na Figura 8.3. As instruções variam de instruções padrões de inteiros de 8, 16
e 32 bits, passando por aquelas de ponto flutuante IEEE 754, até as de multimídia paralela. Como consequência das
cinco emissões por ciclo e das instruções de multimídia paralela, o TriMedia é rápido o suficiente para decodificar
vídeo digital de uma filmadora em tempo real em tamanho total e taxa de quadros total em software.

O TriMedia tem uma memória baseada em bytes, e os registradores de E/S são mapeados para o espaço de memó-
ria. Meias-palavras (16 bits) e palavras completas (32 bits) devem ser alinhadas em suas fronteiras naturais. Ela pode
funcionar como little-endian ou big-endian, dependendo de um bit PSW que o sistema operacional pode ajustar. Esse
bit afeta somente o modo com que as operações de carga e as de armazenamento transferem dados entre memória
e registradores. A CPU contém uma cache dividida de 8 vias de conjuntos associativos com tamanho de linha de 64
bytes para a cache de instruções, bem como para a de dados. A cache de instruções é de 64 KB; a de dados é de 16 KB.

**• Figura 8.3   Instrução TriMedia típica, mostrando cinco operações possíveis.**
    +---------------------------------------------------------------------------+
    |                   INSTRUÇÃO VLIW TÍPICA (TRIMEDIA)                        |
    |===========================================================================|
    |                                                                           |
    |  [ Posição 1 ]  [ Posição 2 ]  [ Posição 3 ]  [ Posição 4 ]  [ Posição 5 ]|
    |  +----------+   +----------+   +-----------+  +----------+  +----------+  |
    |  |  ADIÇÃO  |   | DESLOCA- |   | MULTIMÍDIA|  |   LOAD   |  |   STORE  |  |
    |  |   (Add)  |   |  MENTO   |   |   (DSP)   |  | (Carga)  |  |(Armazena)|  |
    |  +----------+   +----------+   +-----------+  +----------+  +----------+  |
    |                                                                           |
    |  <-------------------------- 1 ÚNICA INSTRUÇÃO ------------------------>  |
    +---------------------------------------------------------------------------+

**• Detalhando as Operações (Explicação para o eBook)**
No contexto de sistemas como o seu Ubuntu rodando no Lenovo IdeaPad, cada posição da instrução TriMedia utiliza uma unidade de execução distinta:

 - Posição 1 (Adição): Executa operações aritméticas inteiras (ex: i++ em um loop C).

 - Posição 2 (Deslocamento/Shift): Move bits para a esquerda ou direita. É vital para criptografia e manipulação de protocolos de rede no seu IDS Sentinel.

 - Posição 3 (Multimídia): Instruções especializadas (SIMD) que processam vários dados de imagem ou som de uma vez.

 - Posição 4 (Load): Busca um dado da memória RAM/Cache e traz para os registradores da CPU.

 - Posição 5 (Store): Pega o resultado processado e o grava de volta na memória.

**• Resumo Técnico para Documentação**

Característica                 Detalhe

Tipo de Arquitetura            VLIW (Very Long Instruction Word)

Paralelismo	                   Explícito (o compilador deve garantir que as 5 operações sejam independentes)

Vantagem	                   Alta performance com baixo consumo de energia, pois a CPU não precisa "adivinhar" o que pode ser feito em paralelo.

Há 128 registradores de uso geral de 32 bits. O registrador R0 é travado com valor 0. O registrador R1 é travado
em 1. Tentar mudar qualquer um deles provoca um ataque cardíaco na CPU. Os 126 registradores restantes são
todos equivalentes em termos funcionais e podem ser utilizados para qualquer finalidade. Além disso, há também
quatro registradores de uso especial de 32 bits: o contador de programa, a palavra de estado de programa e dois
registradores relacionados a interrupções. Por fim, um registrador de 64 bits conta o número de ciclos de CPU
desde sua última reinicialização. A 300 MHz, o contador leva cerca de dois mil anos para dar uma volta completa e
reiniciar o ciclo de contagem.

O Trimedia TM3260 tem 11 unidades funcionais diferentes para efetuar operações aritméticas, lógicas e de
controle de fluxo (bem como uma para controle de cache que não discutiremos aqui). Elas estão relacionadas na
Figura 8.4. As duas primeiras colunas dão o nome da unidade e uma breve descrição do que ela faz. A terceira
informa quantas cópias da unidade existem em hardware. A quarta dá a latência, isto é, quantos ciclos de clock
ela leva para concluir. Nesse contexto, vale a pena observar que todas as unidades funcionais, exceto a unidade
de ponto flutuante de raiz quadrada/divisão, têm paralelismo. A latência dada na tabela informa quanto tempo
falta para o resultado de uma operação estar disponível, mas uma nova operação pode ser iniciada a cada ciclo.
Assim, por exemplo, cada uma das três instruções consecutivas pode conter duas operações de carregamento, o
que resulta em seis carregamentos em vários estágios de execução ao mesmo tempo.

Por fim, as últimas cinco colunas mostram quais posições de instrução podem ser utilizadas por qual uni-
dade funcional. Por exemplo, operações de comparação de ponto flutuante devem aparecer somente na terceira
posição de uma instrução.

**• Figura 8.4   Unidades funcionais da TM3260, sua quantidade, latência e as posições de instrução que usam.**

    +-------------------------------------------------------------------------------+
    |              UNIDADES FUNCIONAIS DA TM3260 (TABELA CORRIGIDA)                 |
    |===============================================================================|
    |                                                                               |
    |  Unidade        | Descrição                        | Qtd | Lat |  1 2 3 4 5   |
    |-----------------|----------------------------------|-----|-----|--------------|
    |  Constante      | Operações imediatas              |  5  |  1  |  x x x x x   |
    |  ULA de inteiros| Operações aritmét., bool, 32 bit |  5  |  1  |  x x x x x   |
    |  Deslocador     | Deslocamentos multibits          |  2  |  1  |  x x x x x   |
    |  Load/Store     | Operações de memória             |  2  |  3  |        x x   |
    |  Int/FP MUL     | Multiplic. int e PF 32 bits      |  2  |  3  |    x x       |
    |  ULA de PF      | Aritmética de PF                 |  2  |  3  |  x     x     |
    |  Comparação PF  | Compara Ponto Flutuante          |  1  |  1  |      x       |
    |  Raiz/div de PF | Divisão e raiz quadrada PF       |  1  | 17  |    x         |
    |  Desvio         | Controle de fluxo (Jumps)        |  3  |  3  |    x x x     |
    |  ULA DSP        | Aritmét. multimídia (8/16 bits)  |  2  |  3  |  x   x   x   |
    |  MUL DSP        | Multiplic. multimídia (8/16 bits)|  2  |  3  |    x x       |
    |                                                                               |
    |  (Legenda: x = Unidade disponível nesta posição | Espaço vazio = Indisponível)|
    +-------------------------------------------------------------------------------+

**• Insights para sua Documentação de Hardware:**

 - Slots Dedicados: Note que a unidade de Raiz/div de PF só pode ser acionada na posição 2. O compilador do seu processador precisa garantir que qualquer divisão em C caia exatamente naquele slot, ou o código falhará.

 - Latência: A latência de 17 ciclos para a divisão significa que, se você iniciar essa operação no ciclo 0, o resultado só estará disponível no ciclo 18 (17 ciclos de espera).

 - Gargalo de Memória: Como só existem 2 unidades de Load/Store e elas operam nas posições 4 e 5, o seu sistema só consegue ler ou gravar 2 dados da memória RAM por ciclo.

A unidade de constante é usada para operações imediatas, como carregar em um registrador um número
armazenado na própria operação. A ULA de inteiros efetua adição, subtração, as operações booleanas normais e
operações de empacotamento/desempacotamento. O deslocador (shifter) pode mover um registrador em qualquer
direção por um número especificado de bits.

A unidade de Load/Store (carregamento/armazenamento) traz palavras da memória para dentro de regis-
tradores e as escreve de volta na memória. O TriMedia é, na essência, uma CPU RISC aumentada, portanto,
operações normais são efetuadas em registradores e a unidade de Load/Store é usada para acessar a memória.
Transferências podem ser de 8, 16 ou 32 bits. Instruções aritméticas e lógicas não acessam a memória.

A unidade de multiplicação efetua multiplicações de inteiros e de ponto flutuante. As três unidades
seguintes efetuam, na ordem, adições/subtrações, comparações, e raiz quadrada e divisões de ponto flutuante.

Operações de desvio são executadas pela unidade de desvio. Há um atraso fixo de 3 ciclos após um des-
vio, portanto, as três instruções (até 15 operações) que vêm após um desvio são sempre executadas, mesmo
para desvios incondicionais.

Por fim, chegamos às duas unidades de multimídia, que executam as operações especiais de multimídia. O
DSP no nome da unidade funcional refere-se a Digital Signal Processor (processador de sinal digital) que, na
verdade, as operações de multimídia substituem. Mais adiante, faremos uma breve descrição das operações de
multimídia. Um aspecto digno de nota é que todas elas utilizam aritmética saturada em vez de aritmética de com-
plemento de dois usada pelas operações com inteiros. Quando uma operação produz um resultado que não pode
ser expresso por causa de excesso, em vez de gerar uma exceção ou dar resultado lixo, é usado o número válido
mais próximo. Por exemplo, com números de 8 bits sem sinal, somar 130 com 130 dá 255.

Como nem toda operação pode aparecer em toda posição, muitas vezes acontece de uma instrução
não conter todas as cinco operações potenciais. Quando uma posição não é usada, ela é compactada para
minimizar a quantidade de espaço desperdiçada. Operações que estão presentes ocupam 26, 34 ou 42 bits.
Dependendo do número de operações que de fato estão presentes, as instruções TriMedia variam entre 2 e
28 bytes, incluindo algum cabeçalho fixo.

O TriMedia não verifica durante a execução se as operações um uma instrução são compatíveis. Se não
forem, ele as executa mesmo assim e obtém a resposta errada. Deixar a verificação de fora foi uma decisão
deliberada para poupar tempo e transistores. O Core i7 faz verificação em tempo de execução para ter certeza
de que todas as operações superescalares são compatíveis, mas a um custo imenso em termos de complexidade,
tempo e transistores. O TriMedia evita esse custo passando a carga do escalonamento para o compilador, que
tem todo o tempo do mundo para otimizar com cuidado o posicionamento de operações em palavras de instru-
ção. Por outro lado, se uma operação precisar de uma unidade funcional que não está disponível, a instrução
protelará até que ela fique disponível.

Como na Itanium-2, as operações do TriMedia são predicadas. Cada operação (com duas pequenas exce-
ções) especifica um registrador que é testado antes de ser executada. Se o bit de ordem baixa do registrador
estiver marcado (valor 1), a operação é executada; caso contrário, ela é saltada. Cada uma das (até) cinco
operações é predicada individualmente. Um exemplo de uma operação predicada é
    
    **IF R2 IADD R4, R5 –> R8**

que testa R2 e, se o bit de ordem baixa for 1, soma R4 com R5 e armazena o resultado em R8. Uma operação
pode ser transformada em incondicional usando R1 (que é sempre 1) como o registrador de predicado. Usar
R0 (que é sempre 0) a transforma em uma no-op.

As operações multimídia do TriMedia podem ser agrupadas nos 15 grupos relacionados na Figura 8.5.
Muitas das operações envolvem clipping (corte), que especifica um operando e uma faixa e obriga o operan-
do a entrar na faixa usando os valores mais baixo ou mais alto para operandos que caem fora da faixa. O
clipping pode ser feito em operandos de 8, 16 ou 32 bits. Por exemplo, quando o clipping é realizado dentro
de uma faixa de 0 a 255 sobre 40 e 340, os resultados cortados são 40 e 255, respectivamente. O grupo clip
efetua operações de corte.

Os quatro grupos seguintes da Figura 8.5 efetuam a operação indicada com operandos de vários tama-
nhos, cortando os resultados para ajustá-los a uma faixa específica. O grupo mínimo, máximo examina dois
registradores e acha o maior e o menor valor para cada byte. De modo semelhante, o grupo comparação
considera dois registradores como quatro pares de bytes e compara cada par.

É raro que operações de multimídia sejam efetuadas com inteiros de 32 bits porque a maioria das
imagens é composta de pixels RGB com valores de 8 bits para cada uma das cores vermelha, verde e azul.
Quando uma imagem está sendo processada – por exemplo, comprimida –, ela é em geral representada por
três componentes, um para cada cor (espaço RGB) ou por uma forma equivalente em termos lógicos (espaço
YUV, que será discutido mais adiante neste capítulo). De qualquer modo, muito processamento é executado
em arranjos retangulares que contêm inteiros de 8 bits sem sinal.

**• Figura 8.5   Principais grupos de operações que vêm com o TriMedia.**

+---------------------------------------------------------------------------------------------------------+
|                  Grupos de Operações TriMedia                                                           |
+---------------------------------------------------------------------------------------------------------+
| Grupo                      | Descrição                                                                  |
+----------------------------+----------------------------------------------------------------------------+
| Clip                       | Corta 4 bytes ou 2 meias-palavras                                          |
+----------------------------+----------------------------------------------------------------------------+
| Valor absoluto             | Valor cortado, com sinal, absoluto DSP                                     |                                                     
+----------------------------+----------------------------------------------------------------------------+
| Adição DSP                 | Adição cortada, com sinal                                                  |
+----------------------------+----------------------------------------------------------------------------+
| Subtração DSP              | Subtração cortada, com sinal                                               |
+----------------------------+----------------------------------------------------------------------------+
| Multiplicação              | Multiplicação cortada, com sinal DSP                                       |                             
+----------------------------+----------------------------------------------------------------------------+
| Mínimo, máximo             | Obtém mínimo ou máximo de pares de quatro bytes                            |               
+----------------------------+----------------------------------------------------------------------------+
| Comparação                 | Compara dois registradores byte por byte                                   |
+----------------------------+----------------------------------------------------------------------------+
| Deslocamento               | Desloca um par de operandos de 16 bits                                     |
+----------------------------+----------------------------------------------------------------------------+
| Soma de produtos           | Soma, com sinal, produtos de 8 ou 16 bits                                  |
+----------------------------+----------------------------------------------------------------------------+
| Merge, pack, swap          | Manipulação de bytes e meias-palavras                                      |      
+----------------------------+----------------------------------------------------------------------------+
| Médias quadráticas de byte | Média quádrupla, sem sinal, byte por byte                                  |
+----------------------------+----------------------------------------------------------------------------+
| Médias de byte             | Média de quatro elementos, sem sinal, byte por byte                        |
+----------------------------+----------------------------------------------------------------------------+
| Multiplicações de byte     | Multiplicação, sem sinal, de 8 bits                                        |
+----------------------------+----------------------------------------------------------------------------+
| Estimativa de movimento    | Soma, sem sinal, de valores absolutos de diferenças de 8 bits com sinal    |
+----------------------------+----------------------------------------------------------------------------+
| Diversos                   | Outras operações aritméticas                                               |
+----------------------------+----------------------------------------------------------------------------+

O TriMedia tem um grande número de operações projetadas especificamente para o processamento eficiente
de matrizes de inteiros de 8 bits sem sinal. Como um exemplo simples, considere o canto superior esquerdo de
uma matriz de valores de 8 bits armazenados em memória (big-endian), como ilustra a Figura 8.6(a). O bloco 4 × 4
mostrado nesse canto contém 16 valores de 8 bits rotulados de A até P. Suponha, por exemplo, que a imagem precisa
ser transposta, para produzir a Figura 8.6(b). Como essa tarefa deve ser realizada?

**• Figura 8.6 - (a) Matriz de elementos de 8 bits. (b) Matriz transposta. (c) Matriz original buscada em quatro registradores. (d) Matriz transposta em quatro registradores.

    +-----------------------------------------------------------------------------+
    |              TRANSPOSIÇÃO DE MATRIZ (REGISTRADORES DE 32 BITS)              |
    |=============================================================================|
    |                                                                             |
    | (a) Matriz Original (8-bit elem)      (b) Matriz Transposta                 |
    |      A  B  C  D                            A  E  I  M                       |
    |      E  F  G  H                            B  F  J  N                       |
    |      I  J  K  L                            C  G  K  O                       |
    |      M  N  O  P                            D  H  L  P                       |
    |                                                                             |
    |-----------------------------------------------------------------------------|
    |                                                                             |
    | (c) Carregamento nos Registradores    (d) Resultado nos Registradores       |
    |                                                                             |
    | R2: [ A ][ B ][ C ][ D ]              R2: [ A ][ E ][ I ][ M ]              |
    | R3: [ E ][ F ][ G ][ H ]    ====>     R3: [ B ][ F ][ J ][ N ]              |
    | R4: [ I ][ J ][ K ][ L ]              R4: [ C ][ G ][ K ][ O ]              |
    | R5: [ M ][ N ][ O ][ P ]              R5: [ D ][ H ][ L ][ P ]              |
    |                                                                             |
    +-----------------------------------------------------------------------------+

**• Detalhamento Técnico para o eBook**
Esta operação demonstra o poder das unidades de processamento que você está documentando:

 - Estrutura de Dados: Cada registrador de 32 bits comporta quatro elementos de 8 bits (1 byte cada), permitindo que uma única instrução atue sobre quatro dados simultaneamente.

 - A Operação (Transposição):

    - No estado (c), cada registrador armazena uma linha da matriz.

    - No estado (d), após a operação de transposição (geralmente usando instruções de "shuffle" ou "unpack"), cada registrador passa a armazenar uma coluna da matriz original.

Um modo de fazer a transposição é usar 12 operações, cada qual carregando um byte em um registrador
diferente, seguidas de mais 12 operações, cada qual armazenando um byte em sua localização correta. (Nota: os
quatro bytes na diagonal não são movidos na transposição.) O problema dessa abordagem é que ela requer 24
operações (longas e lentas) que referenciam a memória.

Uma abordagem alternativa é começar com quatro operações, cada qual carregando uma palavra dentro de
quatro registradores diferentes, R2 a R5, como mostra a Figura 8.6(c). Então, as quatro palavras produzidas são
montadas por operações de mascaramento e deslocamento para conseguir a saída desejada, conforme mostra a
Figura 8.6(d). Por fim, essas palavras são armazenadas na memória. Embora esse modo de fazer a transposição
reduza o número de referências à memória de 24 para 8, o mascaramento e o deslocamento são caros por causa
das muitas operações requeridas para extrair e inserir cada byte na posição correta.

O TriMedia proporciona uma solução melhor do que essas duas. Ela começa trazendo as quatro palavras para
registradores. Todavia, em vez de construir a saída usando mascaramento e deslocamento, são utilizadas opera-
ções especiais que extraem e inserem bytes em registradores para construir a saída. O resultado é que, com oito
referências à memória e oito dessas operações especiais de multimídia, pode-se realizar a transposição. Primeiro,
o código contém uma operação com duas operações de carregamento nas posições 4 e 5, para carregar palavras
em R2 e R3, seguida por outra operação como essa para carregar R4 e R5.

As instruções que contêm essas operações podem usar as posições 1, 2 e 3 para outras finalidades. Quando
todas as palavras forem carregadas, as oito operações especiais de multimídia podem ser empacotadas em duas
instruções para construir a saída, seguidas por duas operações para armazená-las. No total, são necessárias apenas
seis instruções, e 14 das 30 posições nessas instruções ficam disponíveis para outras operações. Na verdade, todo
o trabalho pode ser realizado com o equivalente efetivo a cerca de três instruções. Outras operações de multimí-
dia são igualmente eficientes. Entre essas operações poderosas e as cinco posições de emissão por instrução, o
TriMedia é muito eficiente para efetuar os tipos de cálculos necessários em processamento de multimídia.

## 8.1.2 Multithreading no chip
Todas as CPUs modernas, com paralelismo (pipeline), têm um problema inerente: quando uma referência à
memória encontra uma ausência das caches de nível 1 e nível 2, há uma longa espera até que a palavra requisitada
(e sua linha de cache associada) sejam carregadas na cache, portanto, o pipeline para. Uma abordagem para lidar
com essa situação, denominada multithreading no chip, permite que a CPU gerencie múltiplos threads de controle
ao mesmo tempo em uma tentativa de mascarar essas protelações. Em suma, se o thread 1 estiver bloqueado, a
CPU ainda tem uma chance de executar o thread 2, de modo a manter o hardware totalmente ocupado.

Embora a ideia básica seja bastante simples, existem múltiplas variantes, que examinaremos agora. A primeira
abordagem, multithreading de granulação fina, é ilustrada na Figura 8.7 para uma CPU que tem a capacidade de
emitir uma instrução por ciclo de clock. Na Figura 8.7(a)–(c), vemos três threads, A, B e C, para 12 ciclos de máquina.
Durante o primeiro ciclo, o thread A executa a instrução A1. Essa instrução conclui em um ciclo, portanto, no segun-
do, a instrução A2 é iniciada. Infelizmente, essa instrução encontra uma ausência de cache de nível 1, portanto, dois
ciclos são desperdiçados enquanto a palavra necessária é buscada na cache de nível 2. O thread continua no ciclo 5.
De modo semelhante, os threads B e C também protelam por vezes, como ilustrado na figura. Nesse modelo, se uma
instrução protelar, as subsequentes não podem ser emitidas. É claro que, mesmo com uma tabela de escalonamento
mais sofisticada, às vezes podem ser emitidas novas instruções, mas, nesta discussão, vamos ignorar tal possibilidade.

**• Figura 8.7 - (a)–(c) Três threads. Os retângulos vazios indicam que o thread parou esperando por memória. (d) Multithreading de granula-
ção fina. (e) Multithreading de granulação grossa.**

    THREADS INDIVIDUAIS:
    (a) A: [A1][A2][  ][  ][A3][A4][A5][  ][  ][A6][A7][A8]
    (b) B: [B1][  ][  ][  ][B2][  ][  ][B3][B4][B5][B6][B7]
    (c) C: [C1][C2][C3][C4][  ][  ][  ][  ][C5][C6][  ][  ]

    ESTRATÉGIAS DE EXECUÇÃO:
    (d) GRANULAÇÃO FINA (Alternância por ciclo):
        [A1][B1][C1][A2][  ][C2][  ][  ][C3][A3][B2][C4]...

    (e) GRANULAÇÃO GROSSA (Troca na espera longa):
        [A1][A2][ B1 ][C1][C2][C3][C4][A3][A4][A5][B2]...

O multithreading de granulação fina mascara as protelações executando os threads segundo uma política de
alternância circular, com um thread diferente em ciclos consecutivos, como ilustrado na Figura 8.7(d). Quando
chega o quarto ciclo, a operação de memória iniciada em A1 foi concluída, portanto, a instrução A2 pode ser
executada, ainda que necessite do resultado de A1. Nesse caso, a protelação máxima é dois ciclos, portanto, com
três threads, a operação protelada sempre é concluída a tempo. Se uma protelação de memória demorasse quatro
ciclos, precisaríamos de quatro threads para garantir a operação contínua e assim por diante.

Uma vez que threads diferentes nada têm a ver um com o outro, cada um precisa de seu próprio conjunto
de registradores. Quando uma instrução é emitida, é preciso incluir, com ela, um ponteiro para seu conjunto, de
modo que, se um registrador for referenciado, o hardware saberá qual conjunto de registradores usar. Por conse-
guinte, o número máximo de threads que podem ser executados de uma vez só é fixado na ocasião em que o chip
é projetado.

Operações de memória não são a única razão para protelação. Às vezes, uma instrução precisa de um resul-
tado calculado por uma instrução anterior que ainda não foi concluída. Às vezes, uma instrução não pode iniciar
porque ela vem após um desvio condicional cuja direção ainda não é conhecida. Em geral, se o pipeline tiver k
estágios, mas houver no mínimo k threads para fazer alternância circular, nunca haverá mais de uma instrução
por thread no pipeline a qualquer momento, portanto, não pode ocorrer nenhum conflito. Nessa situação, a CPU
pode executar na velocidade total, sem nunca ficar ociosa.

É claro que pode não haver tantos threads disponíveis quantos são os estágios do pipeline, portanto, alguns
projetistas preferem uma abordagem diferente, conhecida como multithreading de granulação grossa, ilustrada
na Figura 8.7(e). Nesse caso, o thread A inicia e continua a emitir instruções até protelar, desperdiçando um ciclo.
Nesse ponto, ocorre uma troca e B1 é executado. Visto que a primeira instrução do thread B protela, acontece
outra troca de thread e C1 é executado no ciclo 6. Como se perde um ciclo sempre que uma instrução protela,
o multithreading de granulação grossa é potencialmente menos eficiente do que o de granulação fina, mas tem a
grande vantagem de precisar de um número muito menor de threads para manter a CPU ocupada. Em situações
em que há um número insuficiente de threads ativos, para garantir que será encontrado um que pode ser execu-
tado, o multithreading de granulação grossa funciona melhor.

Embora tenhamos demonstrado que o multithreading de granulação grossa troca threads quando há uma
protelação, essa não é a única opção. Outra possibilidade é trocar de imediato em qualquer instrução que poderia
acarretar uma protelação, tal como uma instrução de carregamento, armazenamento ou desvio, antes mesmo de
descobrir se ela de fato causa isso. Essa última estratégia permite que uma troca ocorra mais cedo (tão logo a
instrução seja decodificada) e pode possibilitar evitar ciclos mortos. Na verdade, ela está dizendo: “Execute até
achar que poderia haver um problema, então troque, só por precaução”. Isso faz o multithreading de granulação
grossa ficar mais parecido com o de granulação fina, com suas trocas frequentes.

Seja qual for o tipo de multithreading usado, é preciso ter algum meio de monitorar qual operação pertence
a qual thread. Com o multithreading de granulação fina, a única possibilidade séria é anexar um identificador
de thread a cada operação, para que sua identidade fique clara ao percorrer o pipeline. Com o multithreading de
granulação grossa, existe outra maneira: ao trocar threads, limpe o pipeline e só então inicie o próximo thread.
Desse modo, somente um thread por vez está no pipeline e sua identidade nunca é duvidosa. É claro que deixar o
pipeline funcionar no vazio durante uma troca de thread só faz sentido se as trocas ocorrerem em intervalos muito
mais longos do que o tempo gasto para esvaziar o pipeline.

Até aqui, consideramos que a CPU só pode emitir uma única instrução por ciclo. Todavia, como já vimos,
CPUs modernas podem emitir múltiplas instruções por ciclo. Na Figura 8.8, consideramos que a CPU pode emitir
duas instruções por ciclo de clock, mas mantivemos a regra que diz que, quando uma instrução protela, as sub-
sequentes não podem ser emitidas. Na Figura 8.8(a), vemos como funciona o multithreading de granulação fina
com uma CPU superescalar de emissão dual. Para o thread A, as duas primeiras instruções podem ser emitidas
no primeiro ciclo, mas para o thread B encontramos logo um problema no próximo ciclo, portanto, somente uma
instrução pode ser emitida, e assim por diante.

**• Figura 8.8 - Multithreading com uma CPU superescalar de emissão dual. (a) Multithreading de granulação fina. (b) Multithreading de gra-
nulação grossa. (c) Multithreading simultâneo.**

    +-----------------------------------------------------------------------+
    |           COMPARAÇÃO DE MULTITHREADING (EMISSÃO DUAL)                 |
    |=======================================================================|
    |                                                                       |
    | (a) GRANULAÇÃO FINA:                                                  |
    |     Ciclo 1: [ A1 ][ A2 ]  <- Alterna a thread a cada ciclo           |
    |     Ciclo 2: [ B1 ][    ]                                             |
    |     Ciclo 3: [ C1 ][ C2 ]                                             |
    |                                                                       |
    | (b) GRANULAÇÃO GROSSA:                                                |
    |     Ciclo 1: [ A1 ][ A2 ]  <- Executa a mesma thread até encontrar    |
    |     Ciclo 2: [ B1 ][    ]     uma espera de memória longa.            |
    |     Ciclo 3: [ C1 ][ C2 ]                                             |
    |                                                                       |
    | (c) MULTITHREADING SIMULTÂNEO (SMT):                                  |
    |     Ciclo 1: [ A1 ][ A2 ]  <- Instruções de threads DIFERENTES podem  |
    |     Ciclo 2: [ B1 ][ C1 ]     ocupar o mesmo ciclo de clock.          |
    |     Ciclo 3: [ C2 ][ C3 ]                                             |
    |                                                                       |
    +-----------------------------------------------------------------------+

    +-----------------------------------------------------------------------+
    |          ESCALONAMENTO SUPERESCALAR DE DUAS VIAS (EMISSÃO DUAL)       |
    |=======================================================================|
    |                                                                       |
    | (a) GRANULAÇÃO FINA (Fine-grained)                                    |
    |     Ciclo:   1      2      3      4      5      6                     |
    |     Slot 1: [A1]   [B1]   [C1]   [A3]   [B2]   [C3]                   |
    |     Slot 2: [A2]   [  ]   [C2]   [A4]   [  ]   [C4]                   |
    |             (Alterna a thread a cada ciclo de clock)                  |
    |                                                                       |
    |-----------------------------------------------------------------------|
    |                                                                       |
    | (b) GRANULAÇÃO GROSSA (Coarse-grained)                                |
    |     Ciclo:   1      2      3      4      5      6                     |
    |     Slot 1: [A1]   [B1]   [C1]   [C3]   [A3]   [A5]                   |
    |     Slot 2: [A2]   [  ]   [C2]   [C4]   [A4]   [  ]                   |
    |             (Troca de thread apenas em esperas longas)                |
    |                                                                       |
    |-----------------------------------------------------------------------|
    |                                                                       |
    | (c) MULTITHREADING SIMULTÂNEO (SMT)                                   |
    |     Ciclo:   1      2      3      4      5      6                     |
    |     Slot 1: [A1]   [B1]   [C2]   [C4]   [A4]   [B2]                   |
    |     Slot 2: [A2]   [C1]   [C3]   [A3]   [A5]   [C5]                   |
    |             (Instruções de threads diferentes no mesmo ciclo)         |
    |                                                                       |
    +-----------------------------------------------------------------------+

    (a) Multithreading de Granulação Fina (Fine-grained) Alterna a thread a cada ciclo de clock.

    +-----------------------------------------------------------+
    | A1 | B1 | C1 | A3 | B2 | C3 | A5 | B3 | C5 | A6 | B5 | C7 |
    +-----------------------------------------------------------+
    | A2 |    | C2 | A4 |    | C4 |    | B4 | C6 | A7 | B6 | C8 |
    +-----------------------------------------------------------+

    (b) Multithreading de Granulação Grossa (Coarse-grained) Troca de thread apenas quando ocorre uma espera longa (ex: falta de dados no cache).

    +-----------------------------------------------------------+
    | A1 | B1 | C1 | C3 | A3 | A5 | B2 | C5 | A6 | A8 | B3 | B5 |
    +-----------------------------------------------------------+
    | A2 |    | C2 | C4 | A4 |    |    | C6 | A7 |    | B4 | B6 |
    +-----------------------------------------------------------+

    c) Multithreading Simultâneo (SMT) Instruções de threads diferentes podem ocupar o mesmo ciclo simultaneamente.

    +-----------------------------------------------------------+
    | A1 | B1 | C2 | C4 | A4 | B2 | C6 | A7 | B3 | B5 | B7 | C7 |
    +-----------------------------------------------------------+
    | A2 | C1 | C3 | A3 | A5 | C5 | A6 | A8 | B4 | B6 | B8 | C8 |
    +-----------------------------------------------------------+

**• Destaques para sua Documentação:**
 - Slots Vazios: Note que nas opções (a) e (b) existem espaços em branco. Isso representa unidades funcionais (como as ULAs que vimos na Figura 8.4) que ficaram ociosas naquele ciclo porque a thread atual não tinha uma segunda instrução pronta para disparar.

 - Eficiência do SMT: A representação (c) é a mais densa. Ela aproveita que as threads A, B e C são independentes para "empilhar" instruções e manter o hardware do seu IdeaPad operando na capacidade máxima.

![alt text](image-118.png)

Na Figura 8.8(b), vemos como funciona o multithreading de granulação grossa com uma CPU de emissão
dual, mas agora com um escalonador estático que não introduz um ciclo morto após uma instrução que protela.
Em essência, os threads são executados um por vez, sendo que a CPU emite duas instruções por thread até atingir um
que protela, ponto em que troca para o próximo thread no início do ciclo seguinte.

Com CPUs superescalares há um terceiro modo, denominado multithreading simultâneo, ilustrado na
Figura 8.8(c). Essa técnica pode ser considerada um refinamento do multithreading de granulação grossa, na qual
um único thread tem permissão de emitir duas instruções por ciclo pelo tempo que puder, mas, quando prote-
lar, as instruções são tomadas imediatamente do próximo thread na sequência, para manter a CPU ocupada por
completo. O multithreading simultâneo também pode ajudar a manter ocupadas todas as unidades funcionais.
Quando uma instrução não puder ser iniciada porque uma unidade funcional de que ela necessita está ocupada,
pode-se escolher uma instrução de um thread diferente no lugar daquela. Nessa figura, estamos considerando que
B8 protela no ciclo 11, portanto, C7 é iniciada no ciclo 12.

    Se quiser mais informações sobre multithreading, consulte Gebhart et al., 2011; e Wing-kei et al., 2011.

**• Hyperthreading no Core i7**
Agora que já vimos o multithreading no campo abstrato, vamos considerar um exemplo prático: o Core i7.
No início da década de 2000, processadores como Pentium 4 não ofereciam os aumentos de desempenho de que
a Intel precisava para manter suas vendas. Depois que o Pentium 4 já estava em produção, os arquitetos da Intel
procuraram vários meios de aumentar sua velocidade sem mudar a interface de programadores, algo que jamais
seria aceito. Logo surgiram cinco modos:

    1. Aumentar a velocidade de clock.

    2. Colocar duas CPUs em um chip.

    3. Adicionar unidades funcionais.

    4. Aumentar o comprimento do pipeline.

    5. Usar multithreading.

Um modo óbvio de melhorar o desempenho é aumentar a velocidade de clock sem alterar mais nada. Isso é
algo relativamente direto e bem entendido, portanto, cada novo chip lançado em geral é um pouco mais rápido do
que seu predecessor. Infelizmente, um clock mais rápido também tem duas desvantagens principais que limitam
o tanto de aumento que pode ser tolerado. Primeiro, um clock mais rápido usa mais energia, o que é um enorme problema para notebooks e outros dispositivos que funcionam com bateria. Segundo, a entrada de energia extra
significa que o chip fica mais quente e que há mais calor para dissipar.

Colocar duas CPUs em um chip é relativamente direto, mas equivale a quase duplicar a área do chip se cada
uma tiver suas próprias caches e, por isso, reduz por um fator de dois o número de chips por lâmina, o que dobra
o custo de fabricação por unidade. Se os dois chips compartilharem uma cache em comum, do mesmo tamanho
da original, a área do chip não é dobrada, mas o tamanho da cache por CPU é dividido ao meio, o que reduz o
desempenho. Além disso, enquanto aplicações de servidores de alto desempenho muitas vezes podem utilizar
totalmente múltiplas CPUs, nem todas as aplicações para computadores de mesa têm paralelismo inerente sufi-
ciente para justificar duas CPUs completas.

Adicionar unidades funcionais também é razoavelmente fácil, mas é importante conseguir o equilíbrio corre-
to. Não adianta muito ter dez ULAs se o chip é incapaz de alimentar instruções no pipeline com rapidez suficiente
para mantê-las todas ocupadas.

Um pipeline mais longo, com mais estágios, cada um realizando uma porção menor do trabalho em um
período de tempo mais curto eleva o desempenho, mas também aumenta os efeitos negativos das previsões erra-
das de desvios, ausências da cache, interrupções e outros fatores que obstruem o fluxo normal no pipeline. Além
do mais, para o total aproveitamento de um pipeline mais longo, a velocidade de clock tem de ser aumentada, o
que significa que mais energia é consumida e mais calor é produzido.

Por fim, pode-se adicionar multithreading. Seu valor está em fazer um segundo thread utilizar hardware que,
não fosse por isso, ficaria abandonado. Após algumas experimentações, ficou claro que um aumento de 5% na
área do chip para suporte de multithreading resultaria em ganho de 25% em desempenho para muitas aplicações,
o que significava uma boa escolha. A primeira CPU com multithreading da Intel foi a Xeon em 2002, porém,
mais tarde ele foi adicionado ao Pentium 4, a partir da versão de 3,06 GHz e continuando com versões mais
rápidas do processador Pentium, incluindo o Core i7. A Intel deu o nome de hyperthreading à implementação
de multithreading usada nos seus processadores.

A ideia básica é permitir que dois threads (ou talvez processos, já que a CPU não pode distinguir entre
thread e processo) executem ao mesmo tempo. Para o sistema operacional, o chip Core i7 com hyperthreading
parece um processador dual em que ambas as CPUs compartilham em comum uma cache e a memória principal.
O sistema operacional escalona os threads de modo independente. Se duas aplicações estiverem executando ao
mesmo tempo, o sistema operacional pode executar ambos ao mesmo tempo. Por exemplo, se um daemon de cor-
reio estiver enviando ou recebendo e-mail em segundo plano enquanto um usuário está interagindo com algum
programa em primeiro plano, o programa daemon e o programa usuário podem executar em paralelo, como se
houvesse duas CPUs disponíveis.

Um software de aplicação projetado para executar como threads múltiplos pode usar ambas as CPUs virtuais.
Por exemplo, programas de edição de vídeo em geral permitem que os usuários especifiquem certos filtros para
aplicar a cada quadro dentro de algum limite. Esses filtros podem modificar o brilho, o contraste, o equilíbrio
de cores e outras propriedades. Então, o programa pode designar uma CPU para processar os quadros de números
pares e a outra para processar os de números ímpares e as duas conseguem executar em paralelo.

Uma vez que dois threads compartilham todos os recursos de hardware, é preciso uma estratégia para
gerenciar o compartilhamento. A Intel identificou quatro estratégias úteis para compartilhamento de recursos
em conjunto com hyperthreading: duplicação de recursos, partição de recursos, compartilhamento limitado e
compartilhamento total. Vamos estudar cada uma delas por vez.

Para começar, alguns recursos são duplicados só para fazer o threading. Por exemplo, visto que cada thread
tem seu próprio fluxo de controle, é preciso acrescentar um segundo contador de programa. Além disso, a tabela
que mapeia os registradores de arquitetura (EAX, EBX etc.) para registradores físicos também tem de ser dupli-
cada, assim como o controlador de interrupção, já que os threads podem ser interrompidos independentemente.

Em seguida, temos o, compartilhamento por partição de recursos, no qual os recursos do hardware são divi-
didos rigidamente entre os threads. Por exemplo, se a CPU tiver uma fila entre dois estágios de pipeline funcional, metade das posições poderia ser dedicada ao thread 1 e a outra metade ao thread 2. A partição é fácil de executar,
não tem sobrecarga e impede que os threads interfiram uns com os outros. Se todos os recursos são repartidos, na
verdade temos duas CPUs separadas. Como desvantagem, é fácil acontecer que, em algum ponto, um thread não
esteja usando alguns de seus recursos de que o outro necessita, porém está proibido de acessar. Por conseguinte,
recursos que poderiam ter sido usados produtivamente ficam ociosos.

O oposto do compartilhamento por partição de recursos é o compartilhamento total de recursos. Quando
esse esquema é usado, qualquer thread pode adquirir quaisquer recursos de que precisar, conforme política do
primeiro a chegar, primeiro a ser atendido. Contudo, imagine um thread rápido que consiste em adições e sub-
trações e um lento que consiste em multiplicações e divisões. Se as instruções forem buscadas na memória com
maior rapidez do que as multiplicações e divisões podem ser efetuadas, a provisão de instruções buscadas para o
thread lento e enfileiradas, mas ainda não alimentadas no pipeline, crescerá com o tempo.

Em dado instante, essa provisão ocupará toda a fila de instruções, o que ocasiona a parada do thread por
falta de espaço nessa fila. O compartilhamento total resolve o problema de um recurso que fica ocioso enquanto
outro thread o quer, mas cria um novo problema: um thread poderia tomar para si uma quantidade tão grande de
recursos que provocaria a redução da velocidade do outro ou o faria parar por completo.

Um esquema intermediário é o compartilhamento limitado, no qual um thread pode adquirir recursos
dinamicamente (não há partições fixas), mas apenas até um máximo. Quando há recursos duplicados, essa téc-
nica permite flexibilidade sem o perigo de um thread morrer de fome pela incapacidade de adquirir uma parte
do recurso. Por exemplo, se nenhum thread puder adquirir mais do que 3/4 da fila de instruções, não importa
o que o thread lento faça, o thread rápido sempre poderá executar. O hyperthreading do Core i7 usa estraté-
gias diferentes para recursos diferentes na tentativa de enfrentar os vários problemas que acabamos de citar. A
duplicação é usada para recursos que cada thread requer o tempo todo, como o contador de programa, o mapa
de registradores e o controlador de interrupção. Duplicar esses recursos aumenta a área do chip em apenas 5%,
um preço modesto a pagar pelo multithreading. Recursos disponíveis com tal abundância que não há perigo de um
único thread capturar todos eles, como linhas de cache, são totalmente compartilhados de um modo dinâmico.
Por outro lado, recursos que controlam a operação do pipeline, como as várias filas dentro do pipeline, são repar-
tidos e cada thread recebe metade das posições. O pipeline principal da microarquitetura Sandy Bridge usada no
Core i7 é ilustrado na Figura 8.9; os retângulos brancos e cinza indicam como os recursos são alocados entre os
threads brancos e cinza.

**• Figura 8.9 - Compartilhamento de recursos entre threads na microarquitetura Core i7.**
Figura 8.9, que detalha a microarquitetura do processador Core i7 (como o do seu Lenovo IdeaPad) e como ele compartilha recursos físicos entre diferentes threads para realizar o Multithreading Simultâneo (SMT).

    +-----------------------------------------------------------------------+
    |        FLUXO DE EXECUÇÃO E COMPARTILHAMENTO DE THREADS (i7)           |
    |=======================================================================|
    |                                                                       |
    |  [PC A] [PC B]  <-- Program Counters (Duplicados por Thread)          |
    |      |      |                                                         |
    |  +--------------+                                                     |
    |  |   Cache I    |  <-- Cache de Instruções (Compartilhado)            |
    |  +--------------+                                                     |
    |         |                                                             |
    |  +--------------+                                                     |
    |  | Fila / Busca |  <-- Fila de Alocação e Renomeação (Particionada)   |
    |  +--------------+                                                     |
    |      /      \                                                         |
    | [Buffer A] [Buffer B] <-- Buffers de Reordenação (Particionados)      |
    |      \      /                                                         |
    |  +--------------+                                                     |
    |  |  Escalonador |  <-- Scheduler Único (Compartilhado)                |
    |  +--------------+                                                     |
    |         |                                                             |
    |  +--------------+      +---------------------------+                  |
    |  | Registradores| ---> | UNIDADES DE EXECUÇÃO (6)  |                  |
    |  +--------------+      | (ALUs, FP, Load/Store...) |                  |
    |                        +---------------------------+                  |
    |                                     |                                 |
    |  +--------------+           +--------------+                          |
    |  |   Cache D    | <---------| Fila Retirada |  <-- (Particionada)     |
    |  +--------------+           +--------------+                          |
    |                                                                       |
    +-----------------------------------------------------------------------+

![alt text](image-119.png)

**• Detalhes Técnicos para o seu eBook:**

 - Recursos Duplicados: Para que o SMT funcione, o hardware duplica apenas o estado lógico (como o PC - Program Counter e os Registradores), fazendo o sistema operacional acreditar que existem dois núcleos onde só existe um.

 - Recursos Particionados: Elementos como o Buffer de Reordenação e as Filas de Retirada são divididos: metade do espaço para a Thread A e metade para a Thread B.

 - Recursos Compartilhados: O "coração" do chip, que inclui o Escalonador e as Unidades de Execução (como as que vimos na Figura 8.4), é totalmente compartilhado. Se a Thread A não estiver usando uma ULA em um ciclo, a Thread B pode usá-la imediatamente.

Nessa figura, podemos ver que todas as filas são repartidas, sendo que metade das posições em cada fila é
reservada para cada thread. Nessa partição, nenhum thread pode estrangular o outro. O alocador e renomeador
de registrador também é repartido. O escalonador é compartilhado dinamicamente, mas com um limite, para
impedir que qualquer dos threads reivindique para si todas as posições. Os estágios restantes do pipeline são
totalmente compartilhados.

Entretanto, nem tudo são flores no multithreading – também há uma desvantagem. Embora o particio-
namento seja barato, o compartilhamento dinâmico de qualquer recurso e, em especial, com um limite sobre
quanto um thread pode pegar, requer contabilidade durante a execução, para monitorar a utilização. Além
disso, podem surgir situações nas quais programas funcionam muito pior com multithreading do que sem ele.
Por exemplo, imagine que temos dois threads e que cada um precisa de 3/4 da cache para funcionar bem. Se
executados em separado, cada um funciona bem e encontra poucas ausências da cache (caras). Se executados
juntos, cada um encontra um grande número de ausências da cache e o resultado líquido é bem pior do que
se não houvesse multithreading.

Mais informações sobre multithreading e sua implementação dentro dos processadores Intel são dadas em
Gerber e Binstock, 2004; e Gepner et al., 2011.

## 8.1.3 Multiprocessadores com um único chip
Embora o multithreading ofereça ganhos em desempenho significativos por um custo modesto, para algu-
mas aplicações é preciso um ganho em desempenho muito maior do que ele pode oferecer. Para conseguir esse
desempenho estão sendo desenvolvidos chips multiprocessadores. Há duas áreas de interesse para esses chips
que contêm duas ou mais CPUs: servidores de alta tecnologia e equipamentos eletrônicos de consumo. A seguir,
vamos fazer um breve estudo de cada uma delas.

**• Multiprocessadores homogêneos em um chip**
Com os avanços na tecnologia VLSI, agora é possível colocar duas ou mais CPUs de grande capacidade em
um único chip. Visto que essas CPUs em geral compartilham a mesma cache de nível 2 e memória principal, elas
se qualificam como um multiprocessador, como discutimos no Capítulo 2. Uma área de aplicação típica é um
grande conjunto de hospedeiros Web (server farm) composto de muitos servidores. Ao colocar duas CPUs na
mesma caixa, compartilhando não só memória, mas também discos e interfaces de rede, muitas vezes pode-se
dobrar o desempenho do servidor sem dobrar o custo (porque, mesmo ao dobro do preço, o chip de CPU é apenas
uma fração do custo total do sistema).

Há dois projetos predominantes para multiprocessadores de pequena escala em um único chip. No primeiro,
mostrado na Figura 8.10(a), na realidade há só um chip, mas ele tem um segundo pipeline, o que pode dobrar a
taxa de execução de instruções. No segundo, mostrado na Figura 8.10(b), há núcleos separados no chip e cada
um contém uma CPU completa. Um núcleo é um grande circuito, tal como uma CPU, controlador de E/S ou
cache, que pode ser colocado em um chip de forma modular, normalmente ao lado de outros núcleos.

**• Figura 8.10   Multiprocessadores com um único chip. (a) Chip com pipeline dual. (b) Chip com dois núcleos.**

    (a) Chip com Pipeline Dual          (b) Chip com Dois Núcleos
    +--------------------------+        +--------------------------+
    |  CPU                     |        |  CPU 1       CPU 2       |
    |  [ooooooo] (Pipeline 1)  |        |  [ooooooo]   [ooooooo]   |
    |  [ooooooo] (Pipeline 2)  |        |                          |
    +--------------------------+        +--------------------------+
    |      Memória Cache       |        |      Memória Cache       |
    +--------------------------+        +--------------------------+

**• Conclusão para o eBook:**

 - Pipeline Dual (a): Compartilha mais recursos internos, sendo uma forma mais simples de paralelismo.

 - Dois Núcleos (b): Cada núcleo é independente, o que é o padrão atual do seu Lenovo IdeaPad, permitindo que tarefas pesadas como o seu IDS Sentinel rodem em um núcleo enquanto o sistema operacional gerencia o restante no outro.

![alt text](image-120.png)

O primeiro projeto permite que recursos, como unidades funcionais, sejam compartilhados entre os proces-
sadores, o que permite que uma CPU use recursos que a outra não necessita. Por outro lado, essa técnica requer
um novo projeto para o chip e não funciona muito bem para mais de duas CPUs. Por comparação, colocar dois
ou mais núcleos de CPU no mesmo chip é algo relativamente fácil de fazer.

Discutiremos multiprocessadores mais adiante neste capítulo. Embora o foco dessa discussão esteja mais em
multiprocessadores construídos a partir de chips com uma única CPU, grande parte também pode ser aplicada a
chips com múltiplas CPUs.

**• O multiprocessador em um único chip Core i7**
A CPU Core i7 é um processador em um único chip manufaturado com quatro ou mais núcleos em uma
única pastilha de silício. A organização de alto nível de um processador Core i7 é ilustrada na Figura 8.11.

**• Figura 8.11   Arquitetura do multiprocessador em um único chip do Core i7.**

        +-----------------------------------------------------------------------+
        |                 ARQUITETURA DO CHIP INTEL CORE I7                     |
        |=======================================================================|
        |                                                                       |
        |  +-----------+    +-----------+    +-----------+    +-----------+     |
        |  | IA-32 CPU |    | IA-32 CPU |    | IA-32 CPU |    | IA-32 CPU |     |
        |  |   + L1    |    |   + L1    |    |   + L1    |    |   + L1    |     |
        |  +-----------+    +-----------+    +-----------+    +-----------+     |
        |        |                |                |                |           |
        |  +-----------+    +-----------+    +-----------+    +-----------+     |
        |  | Cache L2  |    | Cache L2  |    | Cache L2  |    | Cache L2  |     |
        |  +-----------+    +-----------+    +-----------+    +-----------+     |
        |        |                |                |                |           |
        |      | R |            | R |            | R |            | R |         |
        |        |                |                |                |           |
        | [======================== REDE EM ANEL ============================]  |
        |                                |                                      |
        |                              | R |                                    |
        |                  +---------------------------+                        |
        |                  |   CACHE L3 COMPARTILHADA  |                        |
        |                  +---------------------------+                        |
        +-----------------------------------------------------------------------+

**•  Insights Técnicos para o seu eBook:**

- Hierarquia de Cache: Cada núcleo tem seu próprio Cache L1 e L2 (privados), o que garante velocidade para tarefas locais. O Cache L3 é o grande "pátio comum" onde todos os núcleos trocam dados.

- Rede em Anel (Ring Bus): É o barramento de alta velocidade que conecta as CPUs ao Cache L3 e ao controlador de memória, permitindo que a comunicação entre núcleos ocorra com latência mínima.

 - Eficiência de Pipeline: Ao unir as latências da Figura 8.4 com essa estrutura, você vê por que o Multithreading é necessário: se um núcleo trava em uma divisão de 17 ciclos, a rede em anel permite que as outras CPUs continuem acessando o Cache L3 sem interrupções.

Cada processador no Core i7 tem suas próprias caches L1 privada para instrução e dados, mais sua própria
cache L2 unificada privada. Os processadores são conectados às caches privadas com conexões ponto a ponto
dedicadas. O próximo nível da hierarquia de memória é a cache de dados L3 compartilhada e unificada.

As caches L2 se conectam à cache compartilhada L3 usando uma rede em anel. Quando um pedido de comu-
nicação entra na rede em anel, ele é encaminhado para o próximo nó na rede, onde é verificado se alcançou seu
nó de destino. Esse processo continua de um nó para outro no anel, até que o nó de destino seja encontrado ou o
pedido chegue a sua origem novamente (quando o destino não existe). A vantagem de uma rede em anel é que ela
é um modo barato de conseguir alta largura de banda, com o custo de maior latência enquanto os pedidos saltam
de um nó para outro. A rede em anel do Core i7 tem duas finalidades principais. Primeiro, ela oferece um modo
de mover pedidos de memória e E/S entre as caches e processadores. Segundo, ela executa as verificações neces-
sárias para garantir que cada processador esteja sempre tendo uma visão coerente da memória. Aprenderemos
mais sobre essas verificações de coerência mais adiante neste capítulo.

**• Multiprocessadores heterogêneos em um chip**
Uma área de aplicação completamente diferente que utiliza multiprocessadores em um único chip é a de
sistemas embutidos, em especial em equipamentos eletrônicos audiovisuais de consumo, como aparelhos de
televisão, DVDs, filmadoras, consoles de jogos, telefones celulares e assim por diante. Esses sistemas possuem
requisitos de desempenho exigentes e restrições rígidas. Embora tendo aparências diferentes, cada vez mais esses
aparelhos são só pequenos computadores, com uma ou mais CPUs, memórias, controladores de E/S e alguns dispositivos de E/S próprios. Um telefone celular, por exemplo, é um mero PC com uma CPU, memória, teclado
diminuto, microfone, alto-falante e uma conexão de rede sem fio, dentro de um pequeno pacote.

Considere, como exemplo, um aparelho portátil de DVD. O computador que está dentro dele tem de mani-
pular as seguintes funções:

1. Controle de um servomecanismo barato, não confiável, para posicionamento do cabeçote.

2. Conversão de analógico para digital.

3. Correção de erros.

4. Decriptação e gerenciamento de direitos digitais.

5. Descompressão de vídeo MPEG-2.

6. Descompressão de áudio.

7. Codificação da saída para aparelhos de televisão NTSC, PAL ou SECAM.

Esse trabalho deve ser realizado em rígidas restrições de tempo real, qualidade de serviço, energia, dissipação
de calor, tamanho, peso e preço.

Discos de CD, DVD e Blu-ray contêm uma longa espiral na qual estão as informações, como ilustrado na
Figura 2.25 (para um CD). Nesta seção, discutiremos os DVDs, pois eles ainda são mais comuns do que os discos
Blu-ray, mas estes são muito semelhantes aos DVDs, exceto por utilizarem codificação MPEG-4 em vez de MPEG-2.
Com toda mídia ótica, o cabeçote de leitura deve percorrer a espiral com precisão à medida que o disco gira. O
preço é mantido baixo pela utilização de um projeto mecânico relativamente simples e pelo rígido controle da
posição do cabeçote em software. O sinal que sai do cabeçote é um sinal analógico que deve ser convertido para
forma digital antes de ser processado. Após ser digitalizado, é preciso extensa correção de erros porque DVDs são
prensados e contêm muitos erros, que devem ser corrigidos em software. O vídeo é comprimido usando o padrão
internacional MPEG-2, que requer cálculos complexos para a descompressão (parecidos com transformadas de
Fourier). O áudio é comprimido usando um modelo psicoacústico que também requer cálculos sofisticados para
descompressão. Por fim, áudio e vídeo têm de ser entregues em uma forma adequada para reprodução em apare-
lhos de televisão NTSC, PAL ou SECAM, dependendo do país para o qual o aparelho de DVD será despachado.
Não é nenhuma surpresa que seja impossível fazer todo esse trabalho em tempo real, em software, com uma CPU
barata de uso geral. Nesse caso, precisamos de um multiprocessador heterogêneo que contenha múltiplos núcleos,
cada um especializado para uma tarefa particular. Um exemplo de aparelho de DVD é dado na Figura 8.12.

**• Figura 8.12 - A estrutura lógica de um simples aparelho de DVD contém um multiprocessador heterogêneo com múltiplos núcleos para diferentes funções.**

    +---------------------------------------------------------------+
    |          CHIP MULTIPROCESSADOR HETEROGÊNEO (6 NÚCLEOS)        |
    |===============================================================|
    |  [ Proc. ] [ Decod. ] [ Decod. ] [ Codif. ] [ Contr. ] [ C  ] |
    |  [ Contr.] [ Video  ] [ Áudio  ] [ Video  ] [ Disco  ] [ a  ] |
    |  [       ] [ MPEG   ] [        ] [ Comp.  ] [        ] [ che] |
    +---------------------------------------------------------------+
          |            |            |            |            |
     [======================== BARRAMENTO =========================]
          |                                      |
    +-----------+                          +-----------+
    |  MEMÓRIA  |                          | DISPOSIT. |
    +-----------+                          +-----------+

![alt text](image-121.png)

**• Notas para o seu eBook:**

 - Especialização vs. Generalização: Enquanto o processador do seu Lenovo é feito para rodar qualquer código (C, JS, Assembly), o chip da Figura 8.12 é otimizado. O "Decodificador de Vídeo MPEG" faz apenas uma coisa, mas a faz consumindo muito menos energia do que um núcleo comum.

 - Paralelismo Funcional: No exemplo do DVD, todos esses núcleos podem trabalhar ao mesmo tempo: um lê o disco, outro decodifica o som e um terceiro processa a imagem.

 - Conexão com Sistemas Operacionais: No Ubuntu, você consegue ver essa especialização ao usar a aceleração de hardware da sua GPU para processar vídeos, aliviando os núcleos principais da CPU.

As funções dos núcleos na Figura 8.12 são todas diferentes, e cada uma é projetada com cuidado para ser muito
boa no que faz pelo preço mais baixo possível. Por exemplo, o vídeo de DVD é comprimido usando um esquema
conhecido como MPEG-2 (que quer dizer Motion Picture Experts Group – grupo de especialistas em filmes –, que
o inventou). O sistema consiste em dividir cada quadro em blocos de pixels e fazer uma transformação complexa em
cada um. Um quadro pode consistir inteiramente em blocos transformados ou especificar que certo bloco é igual a
outro já encontrado no quadro anterior, exceto por um par de pixels que foram alterados, porém localizado com um
afastamento de (Δx, Δy) em relação à posição corrente. Esse cálculo em software é extremamente lento, mas é possível
construir uma máquina de decodificação MPEG-2 que pode efetuá-lo em hardware com bastante rapidez. De modo
semelhante, a decodificação de áudio e a recodificação de sinal de áudio-vídeo composto para ficar de acordo com um
dos padrões mundiais de televisão podem ser mais bem executadas por processadores dedicados em hardware. Essas
observações não tardaram a gerar chips multiprocessadores heterogêneos que contêm múltiplos núcleos projetados
para aplicações audiovisuais. Contudo, como o processador de controle é uma CPU programável de uso geral, o chip
multiprocessador também pode ser usado em outras aplicações semelhantes, como um gravador de DVD.

Outro dispositivo que requer um multiprocessador heterogêneo é o que está dentro de um telefone celular
avançado. Os atuais às vezes têm máquinas fotográficas, videocâmeras, máquinas de jogos, browsers Web, leitores
de e-mail e receptores de rádio por satélite, que usam a tecnologia de telefonia celular (CDMA ou GSM, dependendo
do país) ou Internet sem fio (IEEE 802.11, também chamada WiFi); os futuros podem incluir todos esses. À medida
que os dispositivos adquirem cada vez mais funcionalidade, com relógios que se transformam em mapas baseados
em GPS e óculos que se transformam em rádios, a necessidade de multiprocessadores heterogêneos só aumentará.

Dentro em pouco, os chips terão dezenas de bilhões de transistores. Chips como esses são grandes demais
para que se projete uma porta e um fio por vez. O esforço humano requerido faria com que os chips ficassem
obsoletos quando fossem terminados. A única maneira viável é usar núcleos (basicamente, bibliotecas) que con-
tenham subconjuntos grandes o suficiente e então colocá-los e interconectá-los no chip conforme necessário.
Então, os projetistas têm de determinar qual núcleo de CPU usar para o processador de controle e quais proces-
sadores de uso especial acrescentar para ajudá-lo. Atribuir mais carga ao software que executa no processador de
controle faz o sistema ficar mais lento, mas resulta em um chip menor (e mais barato). Ter vários processadores
de uso especial para processamento de áudio e vídeo ocupa área do chip, aumentando o custo, mas resulta em
desempenhos mais altos e uma taxa de clock mais baixa, o que significa menor consumo de energia e menos dis-
sipação de calor. Assim, os projetistas de chips enfrentam cada vez mais esses compromissos macroscópicos em
vez de se preocupar com onde vão colocar cada transistor.

Aplicações audiovisuais utilizam dados intensamente. Enormes quantidades de dados têm de ser processadas de
modo muito rápido, portanto, o normal é que 50% a 75% da área do chip sejam dedicados à memória de uma forma
ou outra, e a quantidade está crescendo. Neste caso, as questões de projeto são numerosas. Quantos níveis devem ser
usados? As caches devem ser divididas ou unificadas? Qual deverá ser o tamanho de cada uma? Qual deverá ser a rapi-
dez? Um pouco da memória também tem de ir para o chip? Ela deve ser SRAM ou SDRAM? As respostas para cada uma
dessas perguntas têm importantes implicações para o desempenho, consumo de energia e dissipação de calor do chip.

Além do projeto de processadores e sistema de memória, outra questão de considerável consequência é o sis-
tema de comunicação – como todos os núcleos se comunicam uns com os outros? No caso de sistemas pequenos,
um único barramento costuma dar conta do negócio, mas para sistemas maiores ele logo se torna um gargalo.
Muitas vezes, o problema pode ser resolvido migrando para múltiplos barramentos ou, talvez, para um anel que
vai de um núcleo a outro. Nesse último caso, a arbitração é conduzida passando um pequeno pacote, denomina-
do permissão, ao redor do anel. Para transmitir, primeiro um núcleo deve capturar a permissão. Ao concluir, ele
devolve a permissão ao anel, de modo que ela possa continuar circulando. Esse protocolo evita colisões no anel.

Como exemplo de uma interconexão no chip, considere o CoreConnect da IBM, ilustrado na Figura 8.13.
É uma arquitetura para conectar núcleos em um multiprocessador heterogêneo de um único chip. Trata-se de um
projeto de sistema-em-um-chip especialmente completo. De certo modo, o CoreConnect é para multiprocessadores
de chip único o que o barramento PCI foi para o Pentium – a cola que mantém juntas todas as partes. (Com os
modernos sistemas Core i7, PCIe é a cola, mas é uma rede ponto a ponto, sem um barramento compartilhado, como
PCI.) Contudo, ao contrário do barramento PCI, o CoreConnect foi projetado sem qualquer exigência de compa-
tibilidade com equipamentos herdados ou protocolos e sem as restrições de barramentos de nível de placa, como
limites ao número de pinos que o conector de borda pode ter.

**• Figura 8.13   Exemplo da arquitetura CoreConnect da IBM.**
