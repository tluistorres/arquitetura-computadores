![alt text](image-75.png)

# Nível OSM (Operating System Machine).

Em resumo, o computador é visto como uma hierarquia de níveis onde cada camada adiciona funcionalidades à inferior. O nível OSM situa-se acima do nível ISA (Instruction Set Architecture) e funciona como uma interface estendida para o programador.

## Pontos Chave do Nível OSM:

Um computador moderno é construído em níveis, cada um adicionando funcionalidade ao nível anterior. Agora, vamos explorar o nível do sistema operacional (OSM), que acrescenta novas instruções e características além do nível ISA (Arquitetura do Conjunto de Instrução).

- O sistema operacional é um programa que executa em software (ou hardware) e adiciona instruções ao nível ISA.
- O nível OSM é interpretado, ou seja, as instruções são executadas passo a passo pelo sistema operacional.
- As chamadas de sistema são instruções adicionadas pelo sistema operacional, que chamam serviços predefinidos.
- Exemplos de chamadas de sistema incluem ler dados de um arquivo.

## Três tópicos importantes relacionados aos sistemas operacionais:

1. Memória Virtual: Técnica que faz com que a máquina pareça ter mais memória do que realmente tem.
2. E/S de Arquivo: Conceito de nível mais alto que as instruções de E/S, que permite a manipulação de arquivos.
3. Processamento Paralelo: Permite que vários processos executem, se comuniquem e sincronizem.

## Conceito de Processo: 
Um processo é um programa em execução e todas as suas informações de estado (memória, registradores, contador de programa, estado de E/S, etc.).

Exemplos de Sistemas Operacionais: 
O texto menciona dois exemplos de sistemas operacionais:
- Windows 7 (no Core i7)
- Linux (no OMAP4430 com CPU ARM)

O microcontrolador ATmega168 não é mencionado como tendo um sistema operacional, pois é usado em sistemas embutidos.

## Memória Virtual: 

A memória virtual é uma técnica que permite que um computador use mais memória do que realmente tem disponível. Isso é feito usando uma combinação de memória principal (RAM) e memória secundária (disco).

 - História: 
No passado, as memórias eram pequenas e caras, e os programadores tinham que dividir os programas em partes (sobreposições) para que coubessem na memória. Isso era um processo trabalhoso e propenso a erros.

 - Solução: 
Em 1961, um grupo de pesquisadores em Manchester propôs um método para executar o processo de sobreposição automaticamente, sem que o programador soubesse. Essa técnica é conhecida como memória virtual.

 - Funcionamento: 
A memória virtual usa a memória secundária (disco) para armazenar partes do programa que não estão sendo usadas no momento. Quando o programa precisa de uma parte que não está na memória principal, o sistema operacional a traz da memória secundária para a memória principal.

 - Vantagens: 
A memória virtual permite que os programadores escrevam programas sem se preocupar com a quantidade de memória disponível. Além disso, permite que os computadores usem mais memória do que realmente têm.

 - Agora, até computadores de um só chip, incluindo o Core i7 e a CPU ARM do OMAP4430, têm
sistemas de memória virtual altamente sofisticados.

 - Exemplos: 
A memória virtual é usada em muitos computadores modernos, incluindo o Core i7 e a CPU ARM do OMAP4430.

## Paginação: 

A paginação é uma técnica usada para separar o espaço de endereço do espaço de memória física. Isso permite que um computador use mais memória do que realmente tem disponível.

 - Espaço de Endereço vs. Espaço de Memória: 
O espaço de endereço é o conjunto de todos os endereços possíveis que um programa pode acessar. O espaço de memória é o conjunto de endereços de memória física disponíveis no computador.

 - Exemplo: 
Um computador com 16 bits de endereço pode acessar 65.536 palavras de memória (2^16). No entanto, o computador pode ter apenas 4.096 palavras de memória física.

 - Mapeamento: 
A paginação define um mapeamento do espaço de endereço para o espaço de memória física. Isso é feito usando uma tabela de páginas, que associa cada endereço de página a um endereço de memória física.

 - Funcionamento: 
Quando um programa acessa um endereço de memória, o sistema operacional verifica se a página correspondente está na memória física. Se estiver, o acesso é feito diretamente. Se não estiver, o sistema operacional busca a página na memória secundária e a carrega na memória física.
 
 - Vantagens: 
A paginação permite que os programas usem mais memória do que realmente está disponível. Além disso, permite que os programas sejam executados em computadores com diferentes configurações de memória.

## Fig 6.2 Mapeamento no qual endereços virtuais 4.096 a 8.191 são mapeados p/ endereços da memória principal 0 a 4.095
 +---------------------------+
|     Espaço de Endereço    |
+---------------------------+
|                           |
|  8191                     |
|  ...                      |
|  4096                     |
|                           |
+---------------------------+
          |
          | Mapeamento Memória
          | principal de 4 K
          v
+---------------------------+
|     Memória Principal     |
+---------------------------+
|                           |
|  4095                     |
|  ...                      |
|  0                        |
|                           |
+---------------------------+

Endereços virtuais 4096 a 8101 são mapeados p/ endeços da memória principal 0 a 4096.


## Detalhando 
Pense na Paginação como um sistema de biblioteca: o "Espaço de Endereço" é o catálogo de livros (infinito no papel), mas o "Espaço de Memória Física" são as estantes reais (limitadas). Você só coloca na estante o que está lendo agora.
1. A Estrutura: Páginas vs. Molduras (Frames)

Para o mapeamento funcionar, a memória é dividida em blocos de tamanho fixo:

    Páginas (Virtuais): Blocos no espaço de endereço do programa.

    Molduras ou Frames (Físicos): Blocos na memória RAM real.

2. O Mapeamento na Prática

Imagine o exemplo que você deu (16 bits de endereço vs. 4.096 palavras de RAM). Se definirmos que cada página tem 1.024 palavras:
Conceito	        Cálculo	        Resultado
Páginas Virtuais	65.536/1.024	64 páginas (O programa acha que tem isso)

Frames Físicos	4.096/1.024	4 frames (O que a RAM realmente tem)

3. Exemplo de Funcionamento: O "Page Fault"

O componente de hardware chamado MMU (Memory Management Unit) faz a tradução instantânea.

    O Pedido: O programa pede o dado no endereço virtual da Página 5.

    A Consulta: A Tabela de Páginas verifica: "A Página 5 está na RAM?".

    O Acerto (Hit): Se a Página 5 estiver mapeada no Frame 2, o processador acessa a RAM e pronto.

    A Falha (Page Fault): Se a Página 5 não estiver na RAM (está no HD/SSD):

        O SO interrompe a execução.

        Ele escolhe uma página antiga na RAM para "expulsar" (Swap out).

        Ele traz a Página 5 do disco para o frame vazio (Swap in).

        A Tabela de Páginas é atualizada e o programa continua como se nada tivesse acontecido.

Vantagens Detalhadas

    Memória Virtual: Você pode rodar um jogo de 16GB em um PC com 8GB de RAM, pois o SO só mantém na RAM os arquivos do "cenário" onde você está no momento.

    Proteção: Um programa não consegue acessar a memória de outro, pois cada um tem sua própria Tabela de Páginas. Se ele tentar acessar um endereço fora da sua tabela, ocorre o famoso "Erro de Segmentação".

    Fim da Fragmentação Externa: Como as páginas são de tamanho fixo, não sobram "buracos" inúteis na RAM; qualquer frame livre serve para qualquer página.

Um ponto de atenção

Embora poderosa, a paginação em excesso pode causar o Thrashing (Bateção de cabeça). Isso acontece quando o sistema gasta mais tempo trocando páginas entre o disco e a RAM do que executando o programa de fato, deixando o computador extremamente lento.

## O que acontece quando um programa acessa um endereço inválido? 

Se um programa desvia para um endereço entre 8.192 e 12.287 em uma máquina sem memória virtual, o programa causaria uma exceção e seria encerrado.

Com Memória Virtual: 

Se a máquina tiver memória virtual, as seguintes etapas ocorrem:

1. O sistema operacional verifica se a página correspondente ao endereço acessado está na memória física.
2. Se a página não estiver na memória física, o sistema operacional busca a página na memória secundária (disco).
3. Se a página não existir na memória secundária, o sistema operacional gera uma exceção e encerra o programa.
4. Se a página existir na memória secundária, o sistema operacional a carrega na memória física e atualiza a tabela de páginas.
5. O programa é reiniciado no ponto onde ocorreu a exceção, e o acesso à memória é refeito.

 - Vantagens da Memória Virtual: 

A memória virtual permite que os programas sejam executados mesmo se eles acessarem endereços inválidos ou não existam na memória física. Além disso, ela fornece uma camada de proteção entre os programas e o hardware, impedindo que um programa acesse a memória de outro programa.

 - A paginação é uma técnica que permite que um programa use mais memória do que realmente está disponível na memória principal.

Passos da Paginação: 

1. O conteúdo da memória principal é salvo em disco.
2. As palavras 8.192 a 12.287 são localizadas no disco.
3. As palavras 8.192 a 12.287 são carregadas para a memória principal.
4. O mapa de endereços é alterado para mapear endereços 8.192 a 12.287 para localizações de memória 0 a 4.095.
5. A execução continua como se nada de incomum tivesse acontecido.

Vantagens da Paginação: 

- Permite que os programas usem mais memória do que realmente está disponível.
- Fornece uma camada de proteção entre os programas e o hardware.
- É transparente para o programador, que pode programar como se a paginação não existisse.

Espaço de Endereço Virtual e Físico: 

- O espaço de endereço virtual é o conjunto de endereços que o programa pode referenciar.
- O espaço de endereço físico é o conjunto de endereços de memória ligados (físicos) propriamente ditos.
- A tabela de páginas mapeia os endereços virtuais para os endereços físicos.

Ilusão da Memória: 
A paginação dá ao programador a ilusão de que a memória principal é maior do que realmente é, permitindo que os programas sejam executados sem se preocupar com a quantidade de memória disponível.

## Implementação de Paginação: 

A paginação é implementada usando uma tabela de páginas que mapeia os endereços virtuais para os endereços físicos.

Requisitos: 

- Um disco para guardar todo o programa e todos os dados.
- O espaço de endereço virtual é desmembrado em páginas do mesmo tamanho (512 a 64 KB).
- O espaço de endereço físico é desmembrado em quadros de página do mesmo tamanho das páginas.

Funcionamento: 

1. O programa gera um endereço virtual.
2. A tabela de páginas é consultada para encontrar o quadro de página correspondente.
3. Se a página estiver na memória principal, o acesso é feito diretamente.
4. Se a página não estiver na memória principal, ela é carregada do disco para a memória principal.
5. A tabela de páginas é atualizada para refletir a nova localização da página.

Tamanho da Página: 
O tamanho da página é uma potência de 2 (2k), o que facilita a representação dos endereços.

Exemplo: 
A Figura 6.3(a) ilustra um exemplo de divisão do espaço de endereço virtual em páginas de 4 KB.

Tabela de Páginas: 
A tabela de páginas contém tantas entradas quantas forem as páginas no espaço de endereço virtual. Cada entrada contém o endereço físico do quadro de página correspondente.

Figura 6.3
(a) Os primeiros 64 KB do espaço de endereço virtual divididos em 16 páginas, cada página com 4 K.
(b) Memória principal de 32 KB dividida em oito quadros de página de 4 KB cada.

          Quadro de página   Endereços virtuais
          ----------------------------------------
          15                 61440 - 65535
          14                 57344 - 61439
          13                 53248 - 57343
          12                 49152 - 53247
          11                 45056 - 49151
          10                 40960 - 45055
          9                  36864 - 40959
          8                  32768 - 36863
          7                  28672 - 32767
          6                  24576 - 28671
          5                  20480 - 24575
          4                  16384 - 20479
          3                  12288 - 16383
          2                  8192  - 12287
          1                  4096  - 8191
          0                  0     - 4095

(b)
            32 KB da parte inferior Quadro da memória principal
          Quadro de página   Endereços físicos
          ----------------------------------------
          7                  28672 - 32767
          6                  24576 - 28671
          5                  20480 - 24575
          4                  16384 - 20479
          3                  12288 - 16383
          2                  8192  - 12287
          1                  4096  - 8191
          0                  0     - 4095
    

A figura ilustra a divisão do espaço de endereço virtual em páginas e a memória principal em quadros de página.

(a) Espaço de Endereço Virtual: 

- Os primeiros 64 KB do espaço de endereço virtual são divididos em 16 páginas de 4 KB cada.
- Cada página tem um endereço virtual único.

(b) Memória Principal: 

- A memória principal tem 32 KB, divididos em 8 quadros de página de 4 KB cada.
- Cada quadro de página tem um endereço físico único.

Mapeamento: 
A tabela de páginas mapeia os endereços virtuais das páginas para os endereços físicos dos quadros de página na memória principal.

A Figura 6.3(b) mostra uma memória física que consiste em oito quadros de página de 4 KB. Essa memória
poderia ser limitada a 32 KB porque (1) isso é tudo que a máquina tinha (um processador embutido em uma
lavadora ou em um forno de micro-ondas poderia não precisar de mais), ou (2) o resto da memória foi alocado
a outros programas.

## Mapeamento de Endereços Virtuais para Físicos: 

MMU (Memory Management Unit – unidade de gerenciamento de memória) é responsável por mapear os endereços virtuais para os endereços físicos da memória principal.

Funcionamento da MMU: 

1. A MMU recebe um endereço virtual de 32 bits.
2. O endereço virtual é separado em:
- Número de página virtual de 20 bits.
- Deslocamento de 12 bits dentro da página (para páginas de 4 K).
3. O número de página virtual é usado como índice para a tabela de páginas.
4. A tabela de páginas fornece o endereço físico do quadro de página correspondente.

## Figura 6.4 - Formação de um endereço de memória principal

ENDEREÇO VIRTUAL (32 BITS) - REGISTRADOR DE ENTRADA
      +----------------------------+----------------------------+
      |    Página Virtual (20 bits)|   Deslocamento (12 bits)   |
      | [00...0000011] (Índice 3)  |     [000000010110]         |
      +--------------+-------------+-------------+--------------+
                     |                           |
        (Aponta para | a entrada 3)              | (Mantém o valor)
                     v                           |
            TABELA DE PÁGINAS                    |
            +---+-----------+                    |
         15 |   |           |                    |
            +---+-----------+                    |
         14 |   |           |                    |
            +---+-----------+                    |
            |...|    ...    |                    |
            +---+-----------+                    |
          3 | 1 |    110 ---+--- (Frame 110)     |
            +---+-----------+   |                |
          2 |   |           |   |                |
            +---+-----------+   |                |
          1 |   |           |   |                |
            +---+-----------+   |                |
          0 |   |           |   |                |
            +---+-----------+   |                |
              ^       ^         |                |
              |       |         |                |
        Bit Presente  Moldura   |                |
        (1 = Na RAM)  (Pág Fís) |                |
                                v                v
                        +-------+-------+--------+-------+
                        |  0 0 0 0 0 0 0| 0 0 0 0 0 0 0  |
                        +---------------+----------------+
                         ENDEREÇO FÍSICO (15 BITS TOTAL)
                         REGISTRADOR DE SAÍDA (RAM)

O que acontece na imagem:
MMU (Memory Management Unit): É o componente (não ilustrado explicitamente, mas que realiza essa lógica) que recebe o endereço de 32 bits.

Tradução: O "Deslocamento" (Offset) nunca muda; ele apenas diz onde a informação está dentro da página. O que muda é o prefixo (a página virtual vira uma página física/moldura).

Bit de Presença: Se o bit na tabela fosse 0, ocorreria um Page Fault, e o sistema operacional teria que buscar o dado no HD/SSD.

Esse diagrama ASCII representa o processo de tradução de um endereço virtual para um endereço físico usando uma tabela de páginas, conforme mostrado na imagem original. 

Exemplo: 
Na Figura 6.4, o número de página virtual é 3, então a entrada 3 da tabela de páginas é selecionada. O endereço físico do quadro de página correspondente é 7 (em hexadecimal).

Resultado: 
O endereço virtual é mapeado para o endereço físico 7xxx, onde xxx é o deslocamento de 12 bits dentro da página.

## Verificação da Página na Memória: 

A MMU verifica se a página referenciada está na memória principal examinando o bit presente/ausente na entrada da tabela de páginas.

Passos: 

1. Se o bit presente/ausente for 1, a página está na memória.
2. O valor do quadro de página é copiado para os 3 bits superiores do registrador de saída de 15 bits.
3. Os 12 bits menos significativos do endereço virtual (deslocamento da página) são copiados para os 12 bits de ordem baixa do registrador de saída.

Exemplo: 
Na Figura 6.4, o bit presente/ausente é 1, então a página está na memória. O valor do quadro de página é 6, que é copiado para os 3 bits superiores do registrador de saída.

## TMapeamento de Memória (Figura 6.5)

TABELA DE PÁGINAS                   MEMÓRIA PRINCIPAL (RAM)
   (Pág. Virtual | Bit | Quadro)            (Quadros de Página)
   +-------+---+-------+                  +----------------------+
   |  15   | 0 |   0   |                  |       Quadro 7       |
   +-------+---+-------+                  |   (Página Virtual 6) | <---|
   |  14   | 1 |   4   |----------------->+----------------------+     |
   +-------+---+-------+                  |       Quadro 6       |     |
   |  13   | 0 |   0   |                  |   (Página Virtual 5) | <---|---|
   +-------+---+-------+                  +----------------------+     |   |
   |  12   | 0 |   0   |                  |       Quadro 5       |     |   |
   +-------+---+-------+                  |   (Página Virtual 11)| <---|---|---|
   |  11   | 1 |   5   |----------------->+----------------------+     |   |   |
   +-------+---+-------+                  |       Quadro 4       |     |   |   |
   |  10   | 0 |   0   |                  |   (Página Virtual 14)| <---|   |   |
   +-------+---+-------+                  +----------------------+         |   |
   |   9   | 0 |   0   |                  |       Quadro 3       |         |   |
   +-------+---+-------+                  |   (Página Virtual 8) | <---|   |   |
   |   8   | 1 |   3   |----------------->+----------------------+     |   |   |
   +-------+---+-------+                  |       Quadro 2       |     |   |   |
   |   7   | 0 |   0   |                  |   (Página Virtual 3) | <---|---|---|
   +-------+---+-------+                  +----------------------+     |       |
   |   6   | 1 |   7   |----------------->|       Quadro 1       |     |       |
   +-------+---+-------+                  |   (Página Virtual 0) | <---|       |
   |   5   | 1 |   6   |----------------->+----------------------+             |
   +-------+---+-------+                  |       Quadro 0       |             |
   |   4   | 0 |   0   |                  |   (Página Virtual 1) | <-----------|
   +-------+---+-------+                  +----------------------+
   |   3   | 1 |   2   |----------------->
   +-------+---+-------+         Legenda:
   |   2   | 0 |   0   |         Bit 1 = Presente na memória
   +-------+---+-------+         Bit 0 = Ausente (No Disco/Swap)
   |   1   | 1 |   0   |----------------->
   +-------+---+-------+
   |   0   | 1 |   1   |----------------->
   +-------+---+-------+

Esse diagrama ASCII mostra o mapeamento entre as páginas virtuais e os quadros de página na memória principal, indicando quais páginas estão presentes na memória (1 = presente, 0 = ausente).


Mapeamento: 
A Figura 6.5 mostra um possível mapeamento entre páginas virtuais e quadros de páginas físicas:
- Página virtual 0 → Quadro de página 1
- Página virtual 1 → Quadro de página 0
- Página virtual 2 → Não está na memória
- Página virtual 3 → Quadro de página 2
- Página virtual 4 → Não está na memória
- Página virtual 5 → Quadro de página 6
- ...

## Paginação por Demanda e Conjunto de Trabalho: 

A paginação por demanda é uma técnica que carrega as páginas na memória principal apenas quando são necessárias.

Funcionamento: 

1. O programa é iniciado sem que as páginas estejam na memória principal.
2. Quando uma página é referenciada, ocorre uma falta de página.
3. A página é carregada na memória principal e registrada na tabela de páginas.
4. O programa continua executando.

Conjunto de Trabalho (Working Set): 
O conjunto de trabalho é o conjunto de páginas usadas pelas k referências mais recentes à memória. Ele varia lentamente com o tempo e pode ser usado para prever quais páginas serão necessárias.

Paginação por Demanda vs. Pré-Carregamento: 
A paginação por demanda carrega as páginas apenas quando necessário, enquanto o pré-carregamento carrega as páginas antecipadamente com base no conjunto de trabalho.

Vantagens: 
A paginação por demanda é eficiente, pois carrega apenas as páginas necessárias. O pré-carregamento pode reduzir as faltas de página, mas pode carregar páginas desnecessárias.

## Política de Substituição de Página: 

A política de substituição de página é usada para decidir qual página remover da memória principal quando ocorre uma falta de página.

Algoritmo LRU (Least Recently Used): 

- Remove a página que foi usada menos recentemente.
- Funciona bem em muitos casos, mas pode falhar em situações específicas.

Exemplo de Falha do LRU: 
Um programa executa um laço que se estende por 9 páginas virtuais em uma máquina com espaço para apenas 8 páginas na memória principal. O LRU remove a página 0, que será necessária novamente em breve, causando uma falta de página desnecessária.

Outras Opções: 
- Algoritmo FIFO (First-In-First-Out): remove a página que foi carregada primeiro.
- Algoritmo Ótimo: remove a página que não será necessária por mais tempo (difícil de implementar na prática).
- Algoritmo Aleatório: remove uma página aleatória (pode funcionar bem em alguns casos).

## Figura 6.6 - Falha do algoritmo LRU

(a) Estado inicial da pilha de páginas:
+-------------------+
| Página virtual 7 |
+-------------------+
| Página virtual 6 |
+-------------------+
| Página virtual 5 |
+-------------------+
| Página virtual 4 |
+-------------------+
| Página virtual 3 |
+-------------------+
| Página virtual 2 |
+-------------------+
| Página virtual 1 |
+-------------------+
| Página virtual 0 |
+-------------------+

(b) Após acesso à página 8 (substituição LRU):
+-------------------+
| Página virtual 7 |
+-------------------+
| Página virtual 6 |
+-------------------+
| Página virtual 5 |
+-------------------+
| Página virtual 4 |
+-------------------+
| Página virtual 3 |
+-------------------+
| Página virtual 2 |
+-------------------+
| Página virtual 1 |
+-------------------+
| Página virtual 8 |  <-- página 0 removida e 8 inserida
+-------------------+

(c) Estado após reorganização (falha do LRU):
+-------------------+
| Página virtual 7 |
+-------------------+
| Página virtual 6 |
+-------------------+
| Página virtual 5 |
+-------------------+
| Página virtual 4 |
+-------------------+
| Página virtual 3 |
+-------------------+
| Página virtual 2 |
+-------------------+
| Página virtual 0 |
+-------------------+
| Página virtual 8 |  <-- página 1 removida e 8 mantida
+-------------------+

Esse diagrama ASCII mostra os estados da pilha de páginas virtuais durante a falha do algoritmo LRU, ilustrando como a página menos recentemente usada é substituída.


## Algoritmos de Substituição de Página: 

- LRU (Least Recently Used): remove a página que foi usada menos recentemente.
- FIFO (First-In-First-Out): remove a página que foi carregada primeiro.

Vantagens e Desvantagens: 

- LRU: tende a minimizar o número de faltas de página, mas pode falhar em situações específicas.
- FIFO: simples de implementar, mas pode não ser tão eficiente quanto o LRU.

Paginação Excessiva (Thrashing): 
Ocorre quando um programa gera faltas de página com frequência e continuamente, devido a um conjunto de trabalho maior do que a memória principal disponível.

Otimização: 
- Verificar se a página está limpa ou suja antes de reescrevê-la no disco.
- Usar um bit de modificação na MMU para indicar se a página foi alterada.

Importância do Conjunto de Trabalho: 
Um conjunto de trabalho pequeno e estável pode reduzir as faltas de página e melhorar o desempenho do sistema.

## Tamanho de Página e Fragmentação: 

- Fragmentação Interna: espaço desperdiçado na última página de um programa.
- Tamanho de Página: trade-off entre minimizar a fragmentação interna e maximizar a eficiência da tabela de páginas e do disco.

Vantagens de Páginas Grandes: 

- Menos entradas na tabela de páginas.
- Transferências de disco mais eficientes.
- Menos tempo gasto carregando e salvando registradores.

Vantagens de Páginas Pequenas: 

- Menos fragmentação interna.
- Menos paginação excessiva (thrashing) em alguns casos.

Tamanho de Página Típico: 
Atualmente, 4 KB é um tamanho de página comum, pois oferece um bom equilíbrio entre as vantagens e desvantagens.

Exemplo: 
Uma matriz de 10.000 × 10.000 elementos, com elementos de 8 bytes, armazenada por coluna. Com páginas de 8 KB, o programa faria paginação excessiva, mas com páginas de 1 KB, isso não aconteceria.

## Segmentação: 

- Definição: divisão da memória em segmentos lógicos, cada um com seu próprio espaço de endereços.
- Vantagens:
- Simplifica o manuseio de estruturas de dados que aumentam e encolhem.
- Facilita a interconexão de procedimentos compilados em separado.
- Permite compartilhamento de procedimentos e dados entre programas.
- Permite proteção de segmentos com diferentes tipos de acesso.

## Figura 6.7 Em um espaço de endereço unidimensional com tabelas que aumentam, uma tabela pode encostar em outra.

ESPAÇO DE ENDEREÇO VIRTUAL (LINEAR)
      +---------------------------------------+
      |       Livre                           |
      |          {                            |
      +---------------------------------------+ <--- Alocado à Pilha
      |       Pilha de chamadas               |
      +---------------------------------------+ <--- COLISÃO IMINENTE!
      |       Árvore de análise (parse)        |
      +---------------------------------------+
      |       Tabela de constantes            |
      +---------------------------------------+
      |       Texto-fonte                     |
      +---------------------------------------+
      |       Tabela de símbolos              |
      +---------------------------------------+

Exemplo: 
Um compilador com várias tabelas (símbolos, texto-fonte, constantes, árvore de análise, pilha de chamadas) pode usar segmentos separados para cada tabela, permitindo que elas cresçam e encolham independentemente.

## Figura 6.8 Uma memória segmentada permite que cada tabela cresça e encolha independentemente das outras tabelas

Diagrama ASCII: Memória Segmentada (Figura 6.8)
Este diagrama ilustra como diferentes tipos de dados residem em segmentos independentes, permitindo que cada um cresça ou encolha sem interferir no vizinho.

TAMANHO (K)
     ^
     |    +-------+
 20K +----+       |
     |    |       |
 16K +----+ Tabela+
     |    |  de   |                                 +-------+
 12K +----+Simbolos|                                 |       |
     |    |       |        +-------+                | Pilha |
  8K +----+       |        | Texto |        +-------+  de   |
     |    |       |        | Fonte |        | Árvore|Chamadas|
  4K +----+       |        +-------+ +----+ | de    |       |
     |    |       |        |       | |Tab.| |Análise|       |
   0 +----+-------+--------+-------+-+----+ +-------+-------+
          Segmento 0       Seg. 1    Seg. 2   Seg. 3  Seg. 4
          (Símbolos)       (Fonte)  (Const.) (Análise)(Pilha)

Proteção: 
- Cada segmento pode ter um tipo de proteção específico (execução, leitura, escrita).
- Ajuda a identificar erros de programação.

Diferença com Memória Unidimensional: 
- Em uma memória unidimensional, o usuário não está ciente da estrutura lógica dos dados.
- A segmentação permite que o usuário defina a estrutura lógica dos dados e aplique proteção adequada.

TABELA MESTRA DE ARQUIVOS (MFT)
      +-------------------------------+
      |              ...              |
      +-------------------------------+
      |       Entrada da MFT          |-----.
      +-------------------------------+     |
      |       Entrada da MFT          |     |     ESTRUTURA DE UMA ENTRADA DA MFT
      +-------------------------------+     |    +----------+----------+--------+-----------+-------+
      |       Entrada da MFT          |     |    | Inform.  | Nome de  | Nome   | Segurança | Dados |
      +-------------------------------+     '--->| Padrão   | Arquivo  | MS-DOS |           |       |
      |       Entrada da MFT          |          +----------+----------+--------+-----------+-------+
      +-------------------------------+          |          Entrada da MFT para um arquivo         |
      |       Entrada da MFT          |          +-------------------------------------------------+
      +-------------------------------+
      |                               |
      |          Cabeçalho            |
      |           da MFT              |
      |                               |
      +-------------------------------+

## Figura 6.9   Comparação entre paginação e segmentação.

| Consideração | Paginação | Segmentação |
| --- | --- | --- |
| O programador precisa estar ciente dela? | Não | Sim |
| Quantos espaços de endereços lineares há? | 1 | Muitos |
| O espaço de endereço virtual pode ser maior do que o tamanho da memória? | Sim | Sim |
| Tabelas de tamanhos variáveis podem ser manipuladas com facilidade? | Não | Sim |
| Por que a técnica foi inventada? | Para simular memórias grandes | Para fornecer vários espaços de endereço |

## Diferença entre Paginação e Segmentação: 

Paginação:
- O programador não está ciente da paginação.
- O conteúdo de uma página é acidental.
- Não é prático usar bits de proteção em cada entrada da tabela de páginas.

Segmentação:
- O programador está ciente da segmentação.
- Cada segmento é uma entidade lógica com proteção e acesso específicos.
- Permite que o programador use a memória de forma mais eficiente e segura.

Objetivo da Paginação e Segmentação: 
- Paginação: simular memórias grandes, eliminando a necessidade de gerenciamento manual da memória.
- Segmentação: fornecer vários espaços de endereço, permitindo que o programáticas usem a memória de forma mais flexível e segura.


## Implementação de Segmentários: 

Dois Modos:
- Permutação (Swapping): segmentos são carregados e removidos da memória conforme a necessidade.
- Paginação (Paging): segmentos são divididos em páginas de tamanho fixo.

Fragmentação Externa: 
- Espaço desperdiçado entre segmentos devido à diferença de tamanho.
- Pode levar a problemas de alocação de memória.

## Figura 6.10 (a) a (d) Desenvolvimento de fragmentação externa (e) remoção de fragmentação por compactação

## (a) Início       (b) Evolução     (c) Fragmentos   (d) Mais Espaço  (e) Compactação
+------------+    +------------+    +------------+    +------------+    +------------+
| Segmento 4 |    | Segmento 4 |    |   (3K) #   |    |    fe>l    |    |     PI     |
|    (7K)    |    |    (7K)    |    | Segmento 5 |    | Segmento 5 |    |            |
+------------+    +------------+    +------------+    +------------+    +------------+
| Segmento 3 |    | Segmento 3 |    | Segmento 3 |    |  ///////   |    |    Effl    |
|    (8K)    |    |    (8K)    |    |    (8K)    |    +------------+    +------------+
+------------+    +------------+    +------------+    | Segmento 6 |    | Segmento 5 |
| Segmento 2 |    | Segmento 2 |    | Segmento 2 |    |    (4K)    |    |    (4K)    |
|    (5K)    |    |    (5K)    |    |    (5K)    |    +------------+    +------------+
+------------+    +------------+    +------------+    | Segmento 2 |    | Segmento 6 |
| Segmento 1 |    |     13     |    | ^(3K)^ /// |    |    (5K)    |    |    (4K)    |
|    (8K)    |    +------------+    +------------+    +------------+    +------------+
+------------+    | Segmento 7 |    | Segmento 7 |    |    IOI     |    | Segmento 2 |
| Segmento 0 |    |    (5K)    |    |    (5K)    |    +------------+    |    (5K)    |
|    (4K)    |    +------------+    +------------+    | Segmento 7 |    +------------+
+------------+    | Segmento 0 |    | Segmento 0 |    |    (5K)    |    | Segmento 7 |
                  |    (4K)    |    |    (4K)    |    +------------+    |    (5K)    |
                  +------------+    +------------+    | Segmento 0 |    +------------+
                                                      |    (4K)    |    | Segmento 0 |
                                                      +------------+    |    (4K)    |
                                                                        +------------+

Exemplo: 
- Figura 6.10: exemplo de memória física com segmentos e lacunas.
- (a) Estado inicial da memória.
- (b) Segmento 1 é removido e segmento 7 é carregado.
- (c) Segmento 4 é removido e segmento 5 é carregado.
- (d) Segmento 3 é removido e segmento 6 é carregado.

Consequências: 
- Fragmentação externa pode levar a problemas de alocação de memória.
- Pode ser necessário compactar a memória para remover lacunas.

## Análise da Figura 6.10: 

A figura ilustra o desenvolvimento da fragmentação externa e sua remoção por compactação.

(a) Estado inicial: memória com 5 segmentos (0 a 4) de tamanhos diferentes.

(b) Substituição do Segmento 1 pelo Segmento 7: cria uma lacuna de 3K.

(c) Substituição do Segmento 4 pelo Segmento 5: cria outra lacuna.

(d) Substituição do Segmento 3 pelo Segmento 6: aumenta a fragmentação externa.

(e) Compactação: remoção da fragmentação externa, reunindo as lacunas em uma grande área livre.

Consequência da Fragmentação Externa: 
Se o programa referencia o segmento 3 na situação (d), não há espaço contínuo suficiente para carregá-lo, mesmo com espaço total disponível nas lacunas.

Solução: 
Compactar a memória para reunir as lacunas pequenas em uma grande, permitindo alocar segmentos maiores.

## Fragmentação Externa: 

O problema é que o espaço total nas lacunas é suficiente para o segmento 3, mas está distribuído em pedaços pequenos e inúteis.

Solução: Compactar a memória, movendo os segmentos para eliminar as lacunas e criar uma grande área livre.

Algoritmos de Gerenciamento de Lacunas: 
- Melhor Ajuste: escolhe a menor lacuna que pode conter o segmento.
- Primeiro Ajuste: escolhe a primeira lacuna grande o suficiente para conter o segmento.

Modos de Segmentação: 
- Permutação (Swapping): segmentos inteiros são passados entre a memória e o disco.
- Paginação: segmentos são divididos em páginas de tamanho fixo e acessadas por demanda.

Exemplo de Sistema: 
O sistema MULTICS combinava segmentação com paginação e foi usado por 35 anos. Seu modelo de memória virtual influenciou as CPUs da Intel.

O endereço MULTICS de duas partes é composto por:
- Número de segmento: 18 bits.
- Endereço dentro do segmento: dividido em número de página (6 bits) e deslocamento dentro da página (10 bits).

A conversão do endereço MULTICS em um endereço da memória principal segue os passos:
1. O número de segmento é usado como índice no segmento de descritores para localizar o descritor do segmento.
2. O descritor aponta para a tabela de páginas do segmento.
3. O número de página é usado como índice na tabela de páginas para encontrar o quadro de página.
4. O deslocamento é combinado com o endereço do quadro de página para formar o endereço físico da palavra na memória principal. 

## CONVERSÃO DE ENDEREÇO MULTICS (Figura 6.11)
      --------------------------------------------

   +-----------+          +-----------+          +-----------+
   |           |          |           |          |           |
   |-----------|          |-----------|          |-----------|
   | Descritor |--------->| Quadro de |--------->|  Palavra  |
   |-----------|          |  página   |          |-----------|
   |           |          |-----------|          |  Página   |
   +-----------+          |           |          +-----------+
    Segmento de           +-----------+                ^
    descritores             Tabela de                  |
        ^                    páginas                   |
        |                       ^                      |
        | Número de             | Número de            | Deslocamento
        | segmento              | página               |
        |                       |                      |
   +-------------------+  +------------------+----------------------+
   | Número de         |  | Número de página | Deslocamento 10 bits |
   | segmento 18 bits  |  |     de 6 bits    |   dentro da página   |
   +-------------------+  +------------------+----------------------+
                    ENDEREÇO MULTICS DE DUAS PARTES

## Memória virtual no Core i7

O Core i7 utiliza um sistema de memória virtual que suporta paginação por demanda, segmentação pura e segmentação com paginação.

Componentes principais: 
- LDT (Local Descriptor Table): tabela de descritores locais, uma para cada programa.
- GDT (Global Descriptor Table): tabela de descritores globais, compartilhada por todos os programas.

Acesso a segmentos: 
1. O programa carrega um seletor no registrador de segmento (CS, DS, etc.).
2. O seletor é um número de 16 bits que identifica o segmento.

Estrutura do seletor: 
- 3 bits: índice na GDT ou LDT.
- 1 bit: indica se o segmento é local (LDT) ou global (GDT).
- 13 bits: índice do segmento na tabela selecionada.

O hardware usa o seletor para acessar a LDT ou GDT e obter o descritor do segmento, que contém informações como o endereço base e o tamanho do segmento. 😊

## SELETOR DO CORE i7 (Figura 6.12)
              ---------------------------------

      Bits      13                  1           2
     +----------------------------+---+-----------+
     |           ÍNDICE           |T|I|    NPL    |
     +----------------------------+---+-----------+
                                   |         |
                                   |         +--> Nível de privilégio
                                   |              (0-3)
                                   |
                                   +------------> 0 = GDT (Global)
                                                  1 = LDT (Local)

## A Figura 6.12 mostra a estrutura do seletor do Core i7, um valor de 16 bits usado para acessar segmentos de memória.

Campos do seletor: 
1. ÍNDICE (13 bits): especifica o número do descritor na tabela (GDT ou LDT).
2. Bit 12 (TI - Table Indicator):
    - 0: o seletor referencia a GDT (Global Descriptor Table).
    - 1: o seletor referencia a LDT (Local Descriptor Table).
3. Nível de privilégio (2 bits): define o nível de proteção do segmento (0 a 3), sendo 0 o mais privilegiado (kernel) e 3 o menos privilegiado (usuário).

O seletor é carregado em registradores de segmento (CS, DS, etc.) para acessar o segmento correspondente na memória virtual.

## SELETOR DO CORE i7 (Figura 6.12)
              ---------------------------------

      Bits      13                  1           2
     +----------------------------+---+-----------+
     |           ÍNDICE           |T|I|    NPL    |
     +----------------------------+---+-----------+
                                   |         |
                                   |         +--> Nível de privilégio
                                   |              Solicitado (0-3)
                                   |
                                   +------------> 0 = GDT (Global)
                                                  1 = LDT (Local)

## Descritor de Segmento do Core i7: 
Um descritor de segmento tem 8 bytes e contém informações essenciais para acessar o segmento.

Campos principais: 
1. Endereço base (32 bits): endereço inicial do segmento na memória.
2. Tamanho (20 bits + 1 bit de granularidade):
    - LIMIT (20 bits): tamanho do segmento.
    - G (Granularidade, 1 bit):
        - 0: LIMIT está em bytes.
        - 1: LIMIT está em páginas de 4 KB.
3. Tipo de segmento e proteção (4 bits): indica se é código, dados, etc.
4. Nível de privilégio (DPL, 2 bits): nível de proteção (0 a 3).
5. Bit de presença (P, 1 bit):
    - 0: segmento não está na memória (causa page fault).
    - 1: segmento está na memória.

O descritor é carregado na MMU quando o seletor é carregado em um registrador de segmento, permitindo acesso rápido ao segmento. 

## Conversão de Endereço (Seletor, Deslocamento) para Endereço Físico: 
1. O hardware usa o seletor para acessar a LDT ou GDT, com base no bit 2 do seletor.
2. O descritor do segmento é carregado na MMU.
3. Verifica-se se o segmento existe e está na memória (bit P = 1).
4. Verifica-se se o deslocamento está dentro do limite do segmento.
5. Calcula-se o endereço linear:
    - Soma-se o BASE (32 bits) do descritor com o deslocamento.

Endereço Linear → Endereço Físico: 
- Se a paginação estiver desabilitada: o endereço linear é o endereço físico.
- Se a paginação estiver habilitada: o endereço linear é traduzido para endereço físico via tabela de páginas.

Campo LIMIT e Granularidade (G): 
- G = 0: LIMIT é o tamanho exato do segmento (até 1 MB).
- G = 1: LIMIT é o tamanho em páginas (até 4 GB com páginas de 4 KB).

O esquema permite segmentação pura (sem paginação) ou segmentação com paginação. 

## DESCRITOR DE SEGMENTO DE CÓDIGO (Figura 6.13)
        ----------------------------------------------

   31                24 23           16 15            8 7             0
  +--------------------+---+---+---+---+-----+---------+---------------+
  |    BASE 24-31      | G | D | 0 |AVL| LIM |P| DPL |T|Y|P|E| BASE 16-23  |
  +--------------------+---+---+---+---+-----+---------+---------------+
  |         BASE 0-15                  |           LIMIT 0-15          |
  +------------------------------------+-------------------------------+

  LEGENDAS:
  * G: Granularidade (0: bytes, 1: páginas)
  * D: Tamanho (0: 16 bits, 1: 32 bits)
  * P: Segmento presente na memória (0: Não, 1: Sim)
  * DPL: Nível de privilégio do descritor (0-3)
  * TYPE: Tipo de segmento e proteção

## CONVERSÃO PARA ENDEREÇO LINEAR (Figura 6.14)
      ----------------------------------------------

      [ SELETOR ]              [ DESLOCAMENTO ]
          |                           |
          v                           |
    +-----------+                     |
    | DESCRITOR |                     |
    |-----------|                     |
    | End.-base |-------------------->(+)
    |-----------|                      |
    |  Limite   |                      |
    |-----------|                      |
    | Outros    |                      v
    +-----------+           +-----------------------+
                            | Endereço linear 32 bit|
                            +-----------------------+

## Paginação no Core i7 com Segmentação: 
- O endereço linear gerado pela segmentação é tratado como um endereço virtual.
- A tradução para endereço físico é feita em dois níveis:
    1. Diretório de páginas (1.024 entradas): indexado pelos 10 bits mais significativos do endereço linear.
    2. Tabela de páginas (1.024 entradas): indexada pelos próximos 10 bits do endereço linear.
    3. O quadro de página é 8 KB, e o deslocamento (12 bits) é usado para acessar a palavra dentro da página.

Detalhes: 
- O diretório de páginas tem 1.024 entradas, cada uma apontando para uma tabela de páginas.
- Cada tabela de páginas tem 1.024 entradas, apontando para quadros de página de 4 KB.
- O TLB (Translation Lookaside Buffer) armazena as traduções mais recentes para acelerar o acesso.

Esse esquema de dois níveis permite gerenciar até 4 GB de memória virtual com eficiência. 

## MAPEAMENTO DE ENDEREÇO (Figura 6.15)
      --------------------------------------

(a) ESTRUTURA DO ENDEREÇO LINEAR:
     Bits:    10               10              12
        +------------+------------+-----------------------+
        |    DIR     |    PAGE    |          OFF          |
        +------------+------------+-----------------------+
              |            |                  |
(b) FLUXO DE TRADUÇÃO:     |                  |
      Diretório            v                  |
      de páginas       Tabela de              |
     +---------+        páginas               |
     |         |       +---------+            |
     |---------|       |         |            v
     | Entrada |------>|---------|        Quadro de
     |---------|       | Entrada |-------> página
     |         |       +---------+       +---------+
     +---------+                         | Palavra | (Selecionada
                                         +---------+  pelo OFF)

## Explicação da Figura 6.15: Mapeamento de Endereço Linear para Físico 

1. Endereço linear (32 bits) é dividido em três partes:
    - DIR (10 bits): índice do diretório de páginas.
    - PAGE (10 bits): índice da tabela de páginas.
    - OFF (12 bits): deslocamento dentro da página (4 KB).

2. Processo de tradução:
    - Os 10 bits DIR selecionam uma entrada no diretório de páginas.
    - Essa entrada aponta para uma tabela de páginas.
    - Os 10 bits PAGE selecionam uma entrada nessa tabela, que aponta para um quadro de página.
    - O OFF é somado ao endereço base do quadro para obter o endereço físico da palavra.

3. Estrutura:
    - Diretório de páginas: 1.024 entradas (10 bits).
    - Tabela de páginas: 1.024 entradas (10 bits).
    - Quadro de página: 4 KB (12 bits de deslocamento).

Esse esquema de dois níveis reduz o tamanho das tabelas de páginas para segmentos pequenos. 

## Proteção no Core i7: 
O Core i7 suporta 4 níveis de privilégio (0 a 3), com 0 sendo o mais privilegiado (kernel) e 3 o menos privilegiado (usuário).

Como funciona: 
1. Cada programa executa em um nível de privilégio (indicado na PSW).
2. Cada segmento tem um nível de privilégio associado (DPL no descritor).
3. O hardware verifica se o nível do programa é suficiente para acessar o segmento.

Regras de proteção: 
- Um programa só pode acessar segmentos com DPL igual ou menos privilegiado que o seu nível.
- Programas de nível 3 (usuário) não podem acessar dados de nível 0 (kernel), por exemplo.

Exemplo de uso: 
- O sistema operacional roda em nível 0 (máximo privilégio).
- Aplicações de usuário rodam em nível 3 (mínimo privilégio).

A proteção ajuda a evitar que programas maliciosos ou com bugs danifiquem o sistema. 

## ANÉIS DE PROTEÇÃO DO CORE i7 (Figura 6.16)
           -------------------------------------------

                     /-------------------------\
                    /      NÍVEL 3 (Usuário)    \
                   /    +-------------------+    \
                  /     | Programas Usuário |     \
                 /    +-----------------------+    \
                /     | NÍVEL 2 (Biliotecas)  |     \
               /    +---------------------------+    \
              /     | NÍVEL 1 (Chamadas Sist.)  |     \
             /    +-------------------------------+    \
            |     |       NÍVEL 0 (NÚCLEO)        |     |
             \    +-------------------------------+    /
              \     |                           |     /
               \    +---------------------------+    /
                \                                   /
                 \---------------------------------/

       POSSÍVEIS USOS DOS NÍVEIS:
       0: Núcleo (Kernel) do Sistema Operacional.
       1: Chamadas de Sistema (Drivers/Serviços).
       2: Bibliotecas Compartilhadas.
       3: Programas do Usuário Final.

Análise da Figura 6.16 – Proteção no Core i7:

## A figura ilustra o modelo de proteção de 4 níveis (anéis) do Core i7:

1. Níveis de privilégio (anéis):
    - Nível 0 (anel interno): Núcleo (kernel) – máximo privilégio.
    - Nível 1: Chamadas do sistema (system calls).
    - Nível 2: Bibliotecas compartilhadas.
    - Nível 3 (anel externo): Programas do usuário – mínimo privilégio.

2. Funcionamento:
    - Cada processo executa em um nível específico.
    - O acesso a recursos (segmentos ou páginas) é controlado pelo nível de privilégio.
    - Um processo só pode acessar dados de níveis iguais ou menos privilegiados (externos).

3. Objetivo:
    - Isolar o kernel (nível 0) para proteger o sistema operacional.
    - Prevenir que programas de usuário (nível 3) interfiram no kernel ou em chamadas de sistema.

Resumo: O modelo de anéis organiza a proteção hierarquicamente, garantindo segurança e isolamento entre o sistema operacional (nível 0) e aplicações de usuário (nível 3).

## Proteção e Chamadas entre Níveis no Core i7: 
- Programas só podem acessar dados no seu nível ou em níveis menos privilegiados.
- Chamadas entre níveis (mais alto ou mais baixo) são controladas por portas de chamada.
- Uma porta de chamada é um descritor que aponta para um procedimento autorizado em outro nível.
- Isso impede desvios arbitrários para código em níveis diferentes, garantindo segurança.

Exemplo de Uso (Figura 6.16): 
1. Nível 0 (kernel): Gerencia E/S, memória, etc.
2. Nível 1: Tratador de chamadas de sistema (system calls).
3. Nível 2: Bibliotecas compartilhadas (somente execução, sem modificação).
4. Nível 3: Programas de usuário (mínimo privilégio).

Funcionamento:
- Um programa no nível 3 (usuário) só pode chamar procedimentos autorizados via portas de chamada.
- Evita que programas de usuário acessem diretamente o kernel ou modifiquem bibliotecas compartilhadas.

Esse modelo é baseado no MULTICS e usa descritores para garantir segurança nas transições de níveis. 

## Memória virtual na CPU ARM do OMAP4430

A CPU ARM do OMAP4430 é uma máquina de 32 bits e suporta uma memória virtual paginada baseada em
endereços virtuais de 32 bits, que são traduzidos para um espaço de endereços físicos de 32 bits. Dessa forma,
uma CPU ARM pode suportar até 232 bytes (4 GB) de memória física. Quatro tamanhos de página são suportados:
4 KB, 64 KB, 1 MB e 16 MB. Os mapeamentos implícitos por esses quatro tamanhos de página são ilustrados na
Figura 6.17.

## Figura 6.17: Mapeamento Virtual para Físico (CPU ARM do OMAP4430)
Diferente do x86, a arquitetura ARM mostrada aqui suporta páginas de diferentes tamanhos (4K, 64K, 1M e 16M), adaptando a divisão de bits entre o Número de Página e o Deslocamento (Desl.)

MAPEAMENTO VIRTUAL PARA FÍSICO - ARM (Figura 6.17)
      ---------------------------------------------------

 (a) PÁGINAS DE 4K           (b) PÁGINAS DE 64K
     Bits:  20      12           Bits:  16      16
    +------------+------+       +------------+------+
    | N. Pág. 4K | Desl.|       | N. Pág. 64K| Desl.|
    +------------+------+       +------------+------+

 (c) SEÇÕES DE 1M            (d) SUPERSEÇÕES DE 16M
     Bits:  12      20           Bits:  10      22
    +------------+------+       +------------+------+
    | N. Pág. 1M | Desl.|       | N. Pág. 16M| Desl.|
    +------------+------+       +------------+------+

    * O mapeamento é direto: o Número de Página Virtual é traduzido 
      para o Número de Página Físico mantendo o Deslocamento.
      
## Mapeamento de Memória Virtual no ARM OMAP4430: 
- Suporta 4 tamanhos de página: 4 KB, 64 KB, 1 MB e 16 MB.
- Usa tabela de páginas em dois níveis (similar ao Core i7):
    1. Descritor de 1º nível: indexado pelos 12 bits mais significativos do endereço virtual.
    2. Descritor de 2º nível: aponta para o quadro de página física (para páginas de 4 KB e 64 KB).

Tamanhos de Página e Mapeamento: 
- 1 MB e 16 MB: Mapeados diretamente no 1º nível (sem 2º nível).
- 64 KB: Usa 16 descritores idênticos no 2º nível (para reduzir entradas na TLB).
- 4 KB: Mapeamento padrão com descritor no 2º nível.

TLB (Translation Lookaside Buffer): 
- Armazena os mapeamentos mais recentes de página virtual → física.
- Reduz o gargalo de tradução de endereços (evita 2 acessos extras à memória por tradução).
- Essencial para desempenho, pois evita o aumento de 200% nos acessos à memória.

O uso de páginas maiores (ex: 64 KB) reduz o número de entradas na TLB, melhorando o desempenho. 

Funcionamento da TLB no ARM OMAP4430: 
- A TLB armazena os mapeamentos mais recentes de página virtual → quadro de página física.
- Quando um endereço virtual é acessado:
    1. A TLB é consultada primeiro.
    2. Se o mapeamento estiver na TLB (hit), a tradução é feita rapidamente.
    3. Se não estiver (miss), o hardware percorre as tabelas de página para obter o mapeamento.
    4. O mapeamento é carregado na TLB (substituindo uma entrada antiga, se necessário).

Ausência de Página (Page Fault): 
- Se a página não estiver na memória, uma ausência de página é gerada.
- O sistema operacional precisa carregar a página da memória secundária para a memória principal.

Importância da TLB: 
- Reduz drasticamente o tempo de tradução de endereços.
- Evita o gargalo de acessar as tabelas de página a cada referência à memória.

A eficiência da TLB é crucial para o desempenho do sistema. 

## Comparação: Core i7 vs ARM OMAP4430 
- Core i7:
    - Suporta segmentação pura, paginação pura e segmentos paginados.
    - Hardware percorre a tabela de páginas em caso de ausência na TLB.
- ARM OMAP4430:
    - Suporta apenas paginação.
    - Hardware também percorre a tabela de páginas em caso de ausência na TLB.

Outras Arquiteturas (ex: SPARC, MIPS): 
- Em caso de ausência na TLB, o controle é passado para o sistema operacional.
- O SO usa instruções privilegiadas para manipular a TLB e carregar os mapeamentos.

Diferença principal: 
- Core i7 e ARM fazem o percurso da tabela em hardware (mais rápido, menos flexível).
- SPARC/MIPS delegam ao SO (mais flexível, potencialmente mais lento).

A abordagem do Core i7 e ARM é mais comum em sistemas que priorizam desempenho. 

## Figura 6.18: Tradução de Endereços Virtuais (ARM)
Aqui vemos como o endereço é decomposto em dois níveis de tabela e como a TLB (hardware da MMU) acelera esse processo.

TRADUÇÃO DE ENDEREÇO VIRTUAL - CPU ARM (Figura 6.18)
     ------------------------------------------------------

 (a) TABELA DE TRADUÇÃO (Dois Níveis)
     
      ENDEREÇO VIRTUAL:
     [ Índice Nível 1 ] [ Índice Nível 2 ] [ Deslocamento ]
     |    (12 bits)    |    (8 bits)     |    (12 bits)    |
     +--------+--------+--------+--------+--------+--------+
              |                 |                 |
     [TTBR]--(+)                |                 |
              |                 |                 |
      +-------v-------+         |                 |
      | Tabela de     |         |                 |
      | Descritores   |         |                 |
      | de 1º Nível   |--------(+)                |
      +---------------+         |                 |
                        +-------v-------+         |
                        | Tabela de     |         |
                        | Descritores   |         |
                        | de 2º Nível   |--------(+)
                        +---------------+         |
                                         +--------v--------+
                                         | Endereço Físico |
                                         +-----------------+

 (b) TLB (HARDWARE DA MMU)
     +--------+--------+--------+--------+--------------+
     | Válido | Pág.   |  ASID  | Pág.   | Sinalizadores|
     |        | Virtual|        | Física |              |
     +--------+--------+--------+--------+--------------+
     |   [ ]  |  XXXX  |   YY   |  ZZZZ  |     ....     |
     +--------+--------+--------+--------+--------------+

## Memória Virtual e Caching: Conceitos Similares 
- Conceito: Ambos lidam com hierarquia de memória, usando um subconjunto de dados em um nível mais rápido (memória principal/cache) para acessar dados de um nível mais lento (disco/memória principal).
- Funcionamento:
    - Memória virtual: Páginas de disco → memória principal.
    - Caching: Blocos de memória → cache.

Diferenças de Implementação: 

1. Gerenciamento de ausências:
    - Cache: Gerenciado pelo hardware (rápido, transparente).
    - Memória virtual: Gerenciado pelo SO (paginador).
2. Tamanho dos blocos:
    - Cache: Blocos pequenos (ex: 64 bytes).
    - Memória virtual: Páginas maiores (ex: 4 KB ou 8 KB).
3. Mapeamento:
    - Cache: Indexado pelos bits de ordem baixa do endereço.
    - Memória virtual: Indexado pelos bits de ordem alta (tabela de páginas).

Conclusão: 
- O conceito é o mesmo (hierarquia e localidade), mas as implementações atendem a objetivos e restrições diferentes.

## Virtualização de Hardware: 
- Permite executar múltiplos sistemas operacionais em um único computador físico.
- Cada máquina virtual parece um sistema independente para o usuário.
- Hipervisor: Gerencia as máquinas virtuais e compartilha recursos (CPU, memória, E/S).

Benefícios: 
- Uso eficiente de servidores (ex: hospedagem na nuvem).
- Isolamento entre sistemas operacionais (segurança e flexibilidade).
- Facilita escalabilidade (adicionar VMs sem precisar de novos servidores físicos).

Suporte de Hardware: 
- Arquiteturas modernas (como Core i7 e ARM) incluem recursos para virtualização eficiente.
- O hipervisor usa esses recursos para gerenciar VMs com menos overhead.

Exemplo: 
- Serviços de nuvem usam virtualização para rodar múltiplos sistemas em um servidor.

## Figura 6.19: Virtualização por Hardware
A virtualização permite a execução simultânea de vários SOs (A, B, C) sobre uma única arquitetura de hardware.

ESTRUTURA DE VIRTUALIZAÇÃO (Figura 6.19)
      -----------------------------------------

   +-------+-------+   +-------+-------+   +-------+-------+   +-------+-------+
   | Apl.X | Apl.Y |   | Apl.Y | Apl.Z |   | Apl.W | Apl.V |   | Apl.V | Apl.Q |
   +-------+-------+   +-------+-------+   +-------+-------+   +-------+-------+
   |     SO A      |   |     SO A      |   |     SO B      |   |     SO C      |
   +---------------+   +---------------+   +---------------+   +---------------+
   |    MV H/W     |   |    MV H/W     |   |    MV H/W     |   |    MV H/W     |
   +---------------+---+---------------+---+---------------+---+---------------+
   |                       Software Hipervisor                                 |
   +---------------------------------------------------------------------------+
   |             Arquitetura de H/W e periféricos do hospedeiro                |
   +---------------------------------------------------------------------------+

   COMPONENTES:
   * MV H/W: Máquina Virtual de Hardware.
   * Hipervisor: Responsável pelo compartilhamento de memória e E/S.
   * SO A, B, C: Sistemas Operacionais hóspedes independentes.

## Arquitetura de Virtualização (Figura 6.19): 
- Hipervisor: Gerencia múltiplas máquinas virtuais (VMs) no hardware hospedeiro.
- Máquinas Virtuais (VMs): Cada uma executa um sistema operacional (SO A, SO B, SO C).
- Aplicações (Apl. X, Y, Z, etc.): Rodam dentro das VMs, isoladas entre si.

Funcionamento: 
1. O hipervisor gerencia o compartilhamento de recursos (CPU, memória, E/S).
2. Cada VM tem seu próprio sistema operacional e aplicações.
3. O hardware hospedeiro é virtualizado para as VMs.

Benefícios: 
- Isolamento: Cada VM é independente (segurança e estabilidade).
- Flexibilidade: Vários SOs rodando no mesmo hardware.
- Eficiência: Melhor uso de recursos (ex: servidores de nuvem).

## Benefícios da Virtualização: 
- Servidores: Administradores podem mover VMs entre servidores para balancear carga.
- Controle de E/S: Particionamento de recursos (ex: largura de banda de rede por usuário).
- Usuários: Rodar múltiplos sistemas operacionais simultaneamente.

Desafios de Virtualização: 
1. Instruções aritmeticas: Fácil – registradores são virtualizados em troca de contexto.
2. Acesso à memória: Requer mapeamento de páginas (VM → hospedeiro).
3. E/S: Hipervisor gerencia acesso (interrupções redirecionadas ao hipervisor).

Suporte de Hardware: 
- Processadores com virtualização (ex: Intel VT-x, AMD-V) ajudam com:
    - Mapeamento de memória.
    - Controle de E/S.
    - Redução de overhead.

## Virtualização no Core i7 (VMX): 
- VMX (Virtual Machine Extensions): Suporte de hardware para virtualização eficiente.
- EPT (Extended Page Tables): Traduz endereços de VMs para endereços físicos do hospedeiro.
    - Usa tabela de páginas adicional (multinível) para mapeamento.
    - Hipervisor gerencia a tabela EPT (políticas de memória).

E/S Virtualizada: 
- VMCS (Virtual-Machine Control Structure): Gerencia interrupções de E/S.
- Quando uma VM acessa E/S:
    1. Gera interrupção para o hipervisor.
    2. Hipervisor simula a operação de E/S (compartilhamento seguro).

Benefícios: 
- Desempenho: Menos overhead graças ao suporte de hardware (EPT e VMCS).
- Controle: Hipervisor gerencia memória e E/S com políticas flexíveis.

## Instruções de E/S de Nível OSM vs ISA: 
- Nível ISA: Instruções de E/S diretas (baixo nível), perigosas para segurança.
- Nível OSM: E/S gerenciada pelo SO (abstração), mais segura e fácil de usar.

Diferenças: 
1. Segurança: Nível ISA permite acesso direto a dispositivos (risco).
2. Complexidade: E/S em ISA é tediosa (manipulação de bits/registradores).
3. Erros comuns: ISA exige verificação manual de erros (ex: disco, memória).

Exemplo de erros de E/S (ISA): 
- Braço do disco não buscou corretamente.
- Memória inexistente usada como buffer.
- E/S iniciada antes do término da anterior.
- Erros de temporização, soma de verificação, etc.

Conclusão: 
- OSM gerencia E/S de forma mais segura e simplificada.
- ISA é mais flexível, mas arriscado para programadores comuns.

Quando ocorre um desses erros, o bit correspondente em um registrador de dispositivo é ajustado. Poucos
usuários querem se incomodar com a monitoração de todos esses bits de erro e uma grande quantidade de infor-
mações de estado adicionais.

## Arquivos: Abstração para E/S Virtual 
- Arquivo: Sequência de bytes armazenada em um dispositivo (ex: disco).
- Pode ser lido (se for em dispositivo de armazenamento) ou não (ex: impressora).
- Cada arquivo tem propriedades (tamanho, tipo de dados, etc.).

Gerenciamento de Arquivos pelo SO: 
1. Chamadas de sistema: open, read, write, close.
2. Acesso: Antes de ler/escrever, o arquivo precisa ser aberto (SO localiza e carrega info na memória).

Vantagem: 
- Simplifica E/S: SO gerencia detalhes de baixo nível; apps focam na estrutura dos dados.

## Operações com Arquivos: 
- Lendo um arquivo:
    1. read precisa: arquivo aberto, buffer de memória, bytes a ler.
    2. SO lê dados, atualiza ponteiro (próximo byte a ler).
    3. close libera recursos do arquivo.

Modelos de Arquivos: 
- UNIX/Linux: Arquivo = sequência de bytes (estrutura é definida pelo app).
- Mainframes (tradicionais): Arquivo = sequência de registros lógicos estruturados.
    - Registros com mesma estrutura OU mistura de tipos.
    - Leitura com base em posição ou chave.

Exemplo de Registro Lógico (mainframe): 
- Nome, Supervisor, Departamento, Escritório, SexoFeminino (estrutura fixa).

## Figura 6.20: Leitura de Arquivo com Registros Lógicos
Este esquema mostra o estado do buffer antes e depois da leitura de um registro específico (neste caso, o registro 19).

GERENCIAMENTO DE BUFFER DE LEITURA (Figura 6.20)
      --------------------------------------------------

 (a) ANTES DE LER REGISTRO 19      (b) APÓS LER REGISTRO 19
    
    Núm. Registro Lógico              Núm. Registro Lógico
    
         14                                15
         15                                16  <-- Próximo a ler
         16                                17
         17                                18
         18                                19
         19  <-- Próximo a ler             20
                                           21
         21                                22
         22  [ Memória   ]                 23  [ Memória   ]
         23  [ Principal ]                 24  [ Principal ]
         24                                25
         25                                26

    ESTADO DO BUFFER:                 ESTADO DO BUFFER:
    [ Registro 18 ] --> Buffer        [ Registro 19 ] --> Buffer

## Análise da Figura 6.20: Leitura de Arquivo com Registros Lógicos 
- (a) Antes da leitura do registro 19:
    - O próximo registro lógico a ser lido é o 18.
    - O registro 18 está na memória principal (buffer).

- (b) Após a leitura do registro 19:
    - O próximo registro lógico a ser lido agora é o 20.
    - O registro 19 foi lido e colocado no buffer da memória principal.

Processo: 
1. A instrução virtual de leitura especifica o arquivo e o destino (buffer).
2. O sistema lê o próximo registro lógico (19) e atualiza o ponteiro.
3. O buffer agora contém o registro 19.

A instrução de saída virtual básica escreve um registro lógico da memória para um arquivo. Instruções write
sequenciais consecutivas produzem registros lógicos consecutivos no arquivo.

## Implementação de E/S de Nível OSM: 
- Alocação de Armazenamento:
    - Unidade básica: bloco (setor ou conjunto de setores consecutivos).
    - Arquivos podem ser armazenados em blocos consecutivos ou não consecutivos.

Exemplos (Figura 6.21): 
- (a) Alocação Consecutiva:
    - Arquivo ocupa setores consecutivos (ex: CD-ROMs).
- (b) Alocação Não Consecutiva:
    - Arquivo em setores dispersos (ex: discos rígidos, SSDs).

Vantagens/Desvantagens: 
- Consecutiva: Leitura rápida, mas fragmenta espaço livre.
- Não Consecutiva: Flexível (melhor uso do espaço), mas pode ser mais lento.

## Diagrama ASCII: Alocação de Arquivos 

(a) Arquivo em setores consecutivos:
Trilha 1: [1][2][3][4] (Arquivo A)
Trilha 2: [5][6][7][8] (Arquivo B)
Trilha 3: [9][10][11][12]

(b) Arquivo em setores não consecutivos:
Trilha 1: [1](A) [2](B) [3](A) [4](B)
Trilha 2: [5](A) [6](livre) [7](B) [8](A)
Trilha 3: [9](B) [10](A) [11](livre) [12](B)

Legenda:
- (A) = Setor do Arquivo A
- (B) = Setor do Arquivo B
- livre = Espaço não alocado

## Visão do Arquivo: Programador vs SO 
- Programador: Sequência linear de bytes/registros lógicos.
- SO: Coleção de unidades de alocação (blocos) no disco (podem ser não consecutivos).

Localização de Dados: 
- Arquivo Consecutivo: SO calcula posição com base no início do arquivo.
- Arquivo Não Consecutivo: SO usa índice de arquivo (tabela com blocos e endereços).

Tipos de Índice de Arquivo: 
1. Lista de endereços de blocos (ex: UNIX).
2. Lista de execuções de blocos consecutivos (ex: Windows).
3. Lista de registros lógicos com chave (mainframes).

Acesso por Chave: 
- Registros com chave → SO busca pelo índice (chave + endereço).

Organização de Arquivos em Lista Encaixada: 
- Cada unidade de alocação contém o endereço da próxima.
- SO pode manter tabela com esses endereços na memória (ex: MS-DOS, Windows antigos).

Vantagens/Desvantagens: 
- Alocação Consecutiva: Administração simples, mas inflexível (ex: CD-ROMs).
- Alocação Não Consecutiva: Flexível (arquivos crescem), mas mais complexo.

Gerenciamento de Espaço Livre: 
- SO usa lista de livres (lacunas de blocos contíguos).
- Exemplo: Figura 6.22(a) → lista de livres para disco da Figura 6.21(b).

Exemplos de Uso: 
- CD-ROM: Alocação consecutiva (tamanho fixo).
- Disco Rígido: Alocação não consecutiva (arquivos dinâmicos).

## Diagrama ASCII: Monitoramento de Setores Disponíveis 

(a) Lista de Livres:
Trilha  Setor  Próximo
0      0     6
0      6     11
1      3     7
1      9     3
2      5     10
3      1     8
3      8     -

(b) Mapa de Bits:
Trilha  0  1  2  3  4  5  6  7  8  9 10 11
0       0  0  1  1  0  0  1  0  0  0  1  0
1       1  0  0  0  1  0  0  0  1  0  0  1
2       0  0  0  1  0  0  0  1  0  0  0  0
3       0  1  0  0  0  0  0  1  1  0  0  0
4       0  0  0  0  1  0  0  0  0  0  0  0

Legenda:
- 0 = Setor livre
- 1 = Setor ocupado

## Métodos de Monitoramento de Espaço em Disco: 
- Lista de Livres: Facilita encontrar lacuna de tamanho específico, mas lista varia de tamanho.
- Mapa de Bits: Tamanho fixo, fácil mudar estado de bloco, mas difícil achar bloco de tamanho específico.

Fatores que Influenciam o Tamanho da Unidade de Alocação: 
1. Tempo de busca e transferência: Grandes unidades são mais eficientes (menos buscas).
2. Índices de arquivo: Unidades menores = mais entradas no índice.
3. Espaço desperdiçado: Unidades grandes = mais espaço desperdiçado em arquivos pequenos.

Tendência: 
- Discos magnéticos: Unidades de alocação maiores (eficiência no tempo).
- Discos em estado sólido: Menos impacto do tempo de busca → unidades menores podem ser viáveis.

## Gerenciamento de Diretório: 
- História: Antigamente, programas/dados eram armazenados em cartões perfurados → evolução para armazenamento em disco (online).
- Online vs Offline:
    - Online: Acesso direto pelo computador (ex: disco rígido).
    - Offline: Necessita intervenção humana (ex: CD-ROM, pendrive).

Necessidades: 
- Instruções para gerenciar arquivos online.
- Agrupar informações em unidades convenientes (diretórios).
- Proteger contra acesso não autorizado.

O modo usual de um sistema operacional organizar arquivos em linha é agrupá-los em diretórios. A Figura
6.23 mostra um exemplo de organização de diretório. São fornecidas chamadas de sistema para as seguintes fun-
ções, no mínimo:
1.Criar um arquivo e entrar em um diretório.
2.Apagar um arquivo de um diretório.
3.Renomear um arquivo.
4.Mudar o estado de proteção de um arquivo.

Fig. 6.23 Exemplo de organização de diretórios.

-------------------+--------------------------------------+
| Arquivo 0         | Nome do arquivo: Patinho de borracha |
+-------------------+--------------------------------------+
| Arquivo 1         | Comprimento: 1.840                  |
+-------------------+--------------------------------------+
| Arquivo 2         | Tipo: imagem/jpeg                    |
+-------------------+--------------------------------------+
| Arquivo 3         | Data de criação: Março 16, 1066     |
+-------------------+--------------------------------------+
| Arquivo 4         | Último acesso: Setembro 1, 1492      |
+-------------------+--------------------------------------+
| Arquivo 5         | Última alteração: Julho 4, 1776      |
+-------------------+--------------------------------------+
| Arquivo 6         | Total de acessos: 144                |
+-------------------+--------------------------------------+
| Arquivo 7         | Bloco 0: Trilha 4, Setor 6           |
+-------------------+--------------------------------------+
| Arquivo 8         | Bloco 1: Trilha 19, Setor 9          |
+-------------------+--------------------------------------+
| Arquivo 9         | Bloco 2: Trilha 11, Setor 2          |
+-------------------+--------------------------------------+
| Arquivo 10        | Bloco 3: Trilha 77, Setor 0          |
+-------------------+--------------------------------------+

Todos os sistemas operacionais modernos permitem que os usuários mantenham mais de um diretório de
arquivos. Cada diretório é, em si, um arquivo típico e, como tal, pode figurar na lista de outro, o que dá origem a
uma árvore de diretórios. Diretórios múltiplos são de particular utilidade para programadores que trabalham em
diversos projetos, porque eles podem agrupar todos os arquivos relacionados a um projeto em um só diretório.
Enquanto eles estiverem trabalhando naquele projeto, não serão perturbados por arquivos não relacionados com
ele. Os diretórios também são uma maneira conveniente de compartilhar arquivos entre membros de um grupo.

Diretórios Múltiplos: 
- Vantagens:
    - Organização por projetos/grupos.
    - Facilita trabalho em projetos específicos.
    - Compartilhamento de arquivos entre grupos.
- Estrutura: Árvore de diretórios (diretórios como arquivos em outros diretórios).

## Instruções de Nívil OSM PARA Processamento Paralelo: 
- Vantagens:
    - Programação mais conveniente para algoritmos específicos.
    - Redução do tempo total de computação.
- Necessidades:
    - Instruções virtuais para coordenação de processos paralelos.
- Limitações Físicas (Einstein): 
    - Velocidade da luz (~30 cm/ns) limita transmissão de sinais.
    - Impacto na organização de computadores (latência memória-CPU).

Processamento Paralelo vs Simulado: 

(a) Processamento Paralelo Real:
CPU1 → Processo A
CPU2 → Processo B
CPU3 → Processo C

(b) Processamento Paralelo Simulado:
CPU1 → [A | B | C | A | B | C] (compartilhamento de tempo)


Diferenças: 
- Paralelo Real: Múltiplas CPUs físicas → processos em simultâneo.
- Paralelo Simulado: 1 CPU física → processos alternados (compartilhamento).

Desafios: 
- Comunicação entre processos (mesmos problemas nos dois casos).
- Depuração complexa.

## Figura 6.24: Paralelismo Verdadeiro vs. Simulado
O diagrama ilustra como o tempo é distribuído entre processos em sistemas com uma ou várias CPUs.

PROCESSAMENTO PARALELO VS. SIMULADO (Figura 6.24)
      ---------------------------------------------------

 (a) PARALELISMO REAL              (b) PARALELISMO SIMULADO
     (Várias CPUs)                     (Uma única CPU)

 TEMPO                             TEMPO
  |                                 |
  |  +------------+                 |  +-+   +-+   +-+
  |  | Processo 3 |                 |  |3|   |3|   |3| <-- Esperando
  |  +------------+                 |  +-+   +-+   +-+
  |                                 |
  |  +------------+                 |      +-+   +-+   +-+
  |  | Processo 2 |                 |      |2|   |2|   |2|
  |  +------------+                 |      +-+   +-+   +-+
  |                                 |
  |  +------------+                 |  +-+   +-+   +-+
  |  | Processo 1 |                 |  |1|   |1|   |1| <-- Em execução
  |  +------------+                 |  +-+   +-+   +-+
  |                                 |
  +------------------->             +------------------->

## Criação de Processos: 
- Necessário para execução de programas.
- Processo inclui: estado (PC, registradores, etc.) e espaço de endereço.
- Sistemas operacionais modernos permitem criação/destruição dinâmica.

Chamada de Sistema para Criação: 
- Clone do processo atual.
- Especificação de estado inicial (programa, dados, endereço).

Controle do Processo-Pai: 
- Pai pode controlar filho (interromper, reiniciar, examinar, encerrar).
- Processos independentes (pai sem controle após criação).

Em alguns casos, a criação de um processo (pai) mantém controle parcial, ou até mesmo total, do processo
criado (filho). Com essa finalidade, existem instruções virtuais para permitir que um processo-pai interrompa,
reinicie, examine e encerre seus filhos. Em outros casos, um pai tem menos controle sobre seus filhos: uma vez
criado um processo, não há nenhum modo de um pai interrompê-lo, reiniciá-lo, examiná-lo ou encerrá-lo à força.
Então, os dois processos rodam independentemente um do outro.

## Condições de Disputa (Race Conditions): 
- Processos paralelos precisam sincronizar.
- Exemplo: Produtor (P1) e Consumidor (P2) compartilhando buffer.
    - P1 gera primos → coloca no buffer.
    - P2 retira do buffer → imprime.

Problemas: 
- Buffer cheio: P1 dorme → espera sinal de P2.
- Buffer vazio: P2 dorme → espera sinal de P1.
- Condições de disputa podem causar comportamento inesperado (ex: perda de dados).

Buffer Circular: 
- Produtor (in) e Consumidor (out) usam ponteiros.
- Estados do buffer:
    - Vazio: in == out
    - Cheio: in + 1 == out (espaço extra não usado para diferenciar)

Funcionamento: 
- Produtor adiciona em in, avança in.
- Consumidor retira em out, avança out.
- Sincronização necessária para evitar condições de disputa.

## Figura 6.25: Uso de um Buffer Circular
O diagrama mostra a evolução dos ponteiros de entrada (In) e saída (Out) conforme o buffer é preenchido e esvaziado.

BUFFER CIRCULAR (Figura 6.25)
              -------------------------------

   (c) Parcial       (d) Quase Cheio    (e) Esvaziando     (f) "Dando a volta"
   +-------+          +-------+          +-------+          +-------+
   |       |          |       |          |       |          |#######| 
   |-------|          |-------|          |-------|          |#######| 
   |       |          |#######|          |       |          |-------| 
   |-------|   In-->  |#######|          |       |   Out--> |       | 
   |#######|          |#######|   In-->  |-------|          |-------| 
   |#######|          |#######|          |#######|          |       | 
   |-------|          |#######|   Out--> |#######|          |-------| 
   |       |          |#######|          |-------|   In-->  |#######| 
   +-------+          +-------+          +-------+          +-------+
     ^   ^              ^   ^              ^   ^              ^   ^
    In  Out            In  Out            In  Out            In  Out

(a) BUFFER VAZIO                      (b) PRODUTOR ADICIONA 4 ELEMENTOS
    in = 0, out = 0                       in = 4, out = 0
    
    +---+---+---+---+---+---+             +---+---+---+---+---+---+
    |   |   |   |   |   |   |             | 2 | 3 | 5 | 7 |   |   |
    +---+---+---+---+---+---+             +---+---+---+---+---+---+
      ^                                     ^               ^
    In/Out                                 Out             In
     (0)                                   (0)             (4)

Resumo da Lógica de Ponteiros
(a) Estado Inicial: Quando in == out, o sistema entende que o buffer está vazio (ou que todos os dados produzidos já foram consumidos).

(b) Escrita: O produtor insere o dado na posição apontada por in e incrementa o ponteiro. No seu exemplo, após inserir 2, 3, 5 e 7, o in parou na posição 4, aguardando o próximo dado.

(c) Leitura: O consumidor sempre retira o dado da posição out. Se o consumidor retirar dois itens, o out passará de 0 para 2.

## Buffer Circular: Exemplo 

(a) Buffer Vazio:
in=0, out=0
+---+---+---+---+---+---+
|   |   |   |   |   |   |
+---+---+---+---+---+---+
 0   1   2   3   4   5

(b) Produtor adiciona 4 elementos:
in=4, out=0
+---+---+---+---+---+---+
| 2 | 3 | 5 | 7 |   |   |
+---+---+---+---+---+---+
 0   1   2   3   4   5

(c) Consumidor retira 2:
in=4, out=2
+---+---+---+---+---+---+
| 2 | 3 |   |   |   |   |
+---+---+---+---+---+---+
 0   1   2   3   4   5

(d) Produtor adiciona 11, 13:
in=6, out=2
+---+---+---+---+---+---+
| 2 | 3 | 5 | 7 | 11| 13|
+---+---+---+---+---+---+
 0   1   2   3   4   5

## Implementação Simples Produtor-Consumidor em Java 

class Principal {
    static final int TAM_BUFFER = 100;
    static int in = 0, out = 0;
    static int buffer[] = new int[TAM_BUFFER];

    public static void main(String[] args) {
        Producer p = new Producer();
        Consumer c = new Consumer();
        p.start();
        c.start();
    }
}

class Producer extends Thread {
    public void run() {
        int item;
        while (true) {
            item = produzirItem();
            while ((Principal.in + 1) % Principal.TAM_BUFFER == Principal.out);
            Principal.buffer[Principal.in] = item;
            Principal.in = (Principal.in + 1) % Principal.TAM_BUFFER;
        }
    }
    int produzirItem() { /* gera primos, etc */ }
}

class Consumer extends Thread {
    public void run() {
        int item;
        while (true) {
            while (Principal.in == Principal.out);
            item = Principal.buffer[Principal.out];
            Principal.out = (Principal.out + 1) % Principal.TAM_BUFFER;
            consumirItem(item);
        }
    }
    void consumirItem(int item) { /* imprime, etc */ }
}


Observações: 
- Usa threads Java para simular processos paralelos.
- Produtor: gera itens → coloca no buffer.
- Consumidor: retira do buffer → consome.

## Processamento paralelo com uma condição de disputa fatal.

public class m {		
final public static int BUF_SIZE = 100;		
// buffer executa de 0 a 99
final public static long MAX_PRIME = 100000000000L; // pare aqui
public static int in = 0, out = 0;			
// ponteiros para os dados
public static long buffer[ ] = new long[BUF_SIZE];
// primos armazenados aqui
public static producer p;				
// nome do produtor
public static consumer c;				
// nome do consumidor
		
public static void main(String args[ ]) {		
// classe principal
p = new producer( );				
// crie o produtor
c = new consumer( );				
// crie o consumidor
p.start( );					
// inicie o produtor
c.start( );					
// inicie o consumidor
}		
// Essa é uma função para incrementar in e out de modo cíclico
public static int next(int k) {if (k < BUF_SIZE − 1) return(k+1); else return(0);}
}		
		
class producer extends Thread {			
// classe produtor
public void run( ) {				
// código do produtor
long prime = 2;					
// variável transitória
		
while (prime < m.MAX_PRIME) {		
prime = next_prime(prime);			
// declaração P1
if (m.next(m.in) == m.out) suspend( );		
// declaração P2
m.buffer[m.in] = prime;			
// declaração P3
m.in = m.next(m.in);				
// declaração P4
if (m.next(m.out) == m.in) m.c.resume( );		
// declaração P5
}		
}		
		
private long next_prime(long prime){ ... }		
// função que calcula o próximo primo
}		
class consumer extends Thread {			
// classe consumidor
public void run( ) {				
// código do consumidor
long emirp = 2;					
// variável transitória
							
while (emirp < m.MAX_PRIME) {			
if (m.in == m.out) suspend( );			
// declaração C1
emirp = m.buffer[m.out];			
// declaração C2
m.out = m.next(m.out);			
// declaração C3
if (m.out == m.next(m.next(m.in))) m.p.resume( ); // declaração C4
System.out.println(emirp);			
// declaração C5
}		
}		
}	

## Problema fatal
- Problema: Produtor e Consumidor acessam in e out sem sincronização.
- Condição de disputa:
    - Exemplo: Produtor verifica in, Consumidor altera out → inconsistência.

Código com potencial condição de disputa: 

// Trecho crítico (sem sincronização)
if (m.next(m.in) == m.out) suspend(); // P2 (Produtor)
if (m.in == m.out) suspend();           // C1 (Consumidor)


Risco: 
- Produtor e Consumidor podem suspender permanentemente → deadlock.

## Threads em Java: 
- Threads vs Processos: Threads compartilham espaço de endereço (útil para buffer compartilhado).
- Execução:
    - Múltiplas CPUs → paralelismo verdadeiro.
    - 1 CPU → compartilhamento de tempo.

Obs:. Threads são fluxos de execução dentro de um processo que compartilham o mesmo espaço de endereçamento, o que significa que elas podem acessar as mesmas variáveis e estruturas de dados. Isso é útil para buffer compartilhados porque permite que as threads troquem dados de forma eficiente, sem precisar copiar os dados entre elas. 

Em outras palavras, as threads são como "sub-processos" dentro de um processo principal, que podem executar tarefas concorrentemente e compartilhar recursos.

## Figura 6.27: Falha no Mecanismo Produtor-Consumidor
O diagrama mostra uma sequência onde um sinal de "despertar" é perdido, o que pode levar ao travamento (deadlock) do sistema

FALHA NA COMUNICAÇÃO PRODUTOR-CONSUMIDOR (Figura 6.27)
      --------------------------------------------------------

 (a) Produtor em P1         (b) Produtor em P1         (c) Produtor em P5
     Consumidor em C5           Consumidor em C1           envia sinal de
                                                           despertar para
                                                           Consumidor em C1
  99|               |       99|               |        99|               |
    |               |         |               |          |               |
    |               |         |               |          |               |
    |               |         |               |          |               |
    |               |         |               |          |               |
    |     In = 22   |         |  In = Out = 22|    In=23 |               |
    |    Out = 21   |         |               |   Out=22 |     Primo     |
    |---------------+         |  Buffer vazio |          +---------------+
    |     Primo     |         |               |          |       ?       |
    |---------------+         |               |          |  1 número no  |
    |       f       |         |               |          |    buffer     |
   0|  1 número no  |        0|               |         0|               |
    |    buffer     |         |               |          |               |

Entendendo a FalhaEstado (a): O buffer contém um item. O produtor está na instrução P1 e o consumidor em C5.

Estado (b): O consumidor leu o item e o buffer ficou vazio ($In = Out = 22$).

Estado (c) - O Problema: O produtor adiciona um novo item ($In = 23$) e tenta enviar um sinal de despertar. Se o consumidor ainda não estiver tecnicamente "dormindo" (embora o buffer esteja vazio), esse sinal pode ser perdido, resultando em um erro de lógica onde o consumidor nunca acorda para ler o novo item.

+---------------------+---------------+-----------+----------+------------+-------------+
| Tipo de Memória     | Localização   | É Volátil?| Velocidade| Capacidade | Custo por bit|
+---------------------+---------------+-----------+----------+------------+-------------+
| Registrador        | Processador   | Sim       | Muito alta| Bytes      | Muito alto  |
| Buffer (IPC)       | Memória RAM   | Sim       | Rápida    | Variável   | Médio       |
| Secundária         | HD/SSD        | Não       | Baixa     | TB         | Baixo       |
+---------------------+---------------+-----------+----------+------------+-------------+

Métodos de Controle: 
- suspend(): thread dorme.
- resume(): thread acorda.

Função next(): 
- Incrementa in/out circularmente (0 a 99 → volta para 0).

Lógica do Produtor e Consumidor: 
- Produtor:
    - Gera primo (P1).
    - Se buffer cheio (P2) → dorme.
    - Insere primo (P3), incrementa in (P4).
    - Se buffer estava vazio → acorda Consumidor (P5).
- Consumidor:
    - Se buffer vazio (C1) → dorme.
    - Retira item (C2), incrementa out (C3).
    - Se buffer estava cheio → acorda Produtor (C4).
    - Imprime item (C5).

Problema em potencial: 
- Uso de suspend() e resume() pode causar deadlock (ex: ambos dormindo).

Condição de Disputa Fatal 
- Problema: Produtor e Consumidor acessam in/out sem sincronia.
- Exemplo (Figura 6.27):
    - Consumidor lê in=22, out=22, vai dormir.
    - Produtor insere item, incrementa in=23, chama resume() → perdido.
    - Ambos dormem → deadlock.

Causa: 
- Sinal de despertar (resume) perdido porque Consumidor ainda estava acordado.

Solução: 
- Usar mecanismos de sincronização (ex: semáforos, monitores).
- Evitar suspend()/resume() → usar wait()/notify() em Java.

## Semáforos: Sincronização de Processos 
- Definição: Variáveis inteiras não negativas para controlar acesso a recursos.
- Operações:
    - down(s): Decrementa s. Se s=0, processo dorme.
    - up(s): Incrementa s. Se havia processo dormindo, acorda um.

Propriedades: 
- Atomicidade: Operações up/down são indivisíveis.
- Armazena sinais: Evita perda de sinais de despertar.

Exemplo de uso: 
- Produtor-Consumidor: Semáforo vazio (inicial=0), cheio (inicial=N).

## Fig. 6.28 Efeito de Operações de Semáforo 

           +-----------------------------------------------------+
           |          Semáforo = 0       |  Semáforo > 0
           +-----------------------------------------------------+
up(s)      | Semáforo = 1; acorda um |  Semáforo = Semáforo + 1
           | processo dormindo (se houver) |
           +-----------------------------------------------------+
down(s)    | Processo dorme até up(s) |  Semáforo = Semáforo - 1
           +-----------------------------------------------------+

## Semáforos em Java (simulação) 
- Semáforos adicionados à classe m:
    - available (inicial=100): espaços vazios no buffer.
    - filled (inicial=0): itens no buffer.
- Sincronização: 
    - Produtor: down(available) → coloca item → up(filled).
    - Consumidor: down(filled) → retira item → up(available).

Exemplo (Figura 6.29): 
- Produtor gera primo → down(available) → insere → up(filled).
- Consumidor down(filled) → retira → up(available).

## Semáforos: Solução para Condição de Disputa 
- Problema resolvido: Semáforos filled e available garantem sincronia.
- Exemplo crítico: 
    - Consumidor em C1 (filled=1 → filled=0), produtor insere item (filled=1).
    - Ordem não importa: consumidor não dorme ou é acordado corretamente.

Propriedades dos Semáforos: 
- Operações indivisíveis (up/down).
- Sinais não perdidos: garante execução correta mesmo com alternância.

Implementação: 
- Desabilitar interrupções (1 CPU) ou mecanismos específicos (multiprocessadores).

## Figura 6.29 Processamento Paralelo com Semáforos 

public class m {
    final static int BUF_SIZE = 100;
    static int in = 0, out = 0;
    static long buffer[] = new long[BUF_SIZE];
    static int filled = 0, available = BUF_SIZE;
}

class Producer extends Thread {
    native void up(int s);
    native void down(int s);

    public void run() {
        long prime = 2;
        while (prime < m.MAX_PRIME) {
            prime = next_prime(prime);       // P1
            down(m.available);               // P2
            m.buffer[m.in] = prime;          // P3
            m.in = m.next(m.in);             // P4
            up(m.filled);                    // P5
        }
    }
}

class Consumer extends Thread {
    native void up(int s);
    native void down(int s);

    public void run() {
        long emirp;
        while (true) {
            down(m.filled);                  // C1
            emirp = m.buffer[m.out];         // C2
            m.out = m.next(m.out);           // C3
            up(m.available);                 // C4
            System.out.println(emirp);      // C5
        }
    }
}


Observações: 
- Semáforos filled e available garantem sincronia.
- down(available) bloqueia produtor se buffer cheio.
- down(filled) bloqueia consumidor se buffer vazio.

Analogia do Piquenique com Semáforos 
- Cesto = Semáforo: bolas = valor do semáforo (0 a 7).
- Quadras = Processos: precisam de bola (recurso) para continuar.
- Ações:
    - down: pegar bola (se não houver, espera).
    - up: devolver bola (libera um processo esperando).

Exemplo: 
- 7 bolas → 7 quadras pegam → 3 ficam esperando.
- 1 bola devolvida → 1 quadra continua.
- +2 bolas → outras 2 quadras continuam.

## Exemplos de sistemas operacionais

Discutiremos exemplos de sistemas, o Core i7 e a CPU ARM do OMAP4430.

Para cada um examinaremos um sistema operacional usado naquele processador. No caso do Core i7, usaremos o
Windows; para a CPU ARM do OMAP4430, usaremos o UNIX. Uma vez que o UNIX é mais simples e, sob muitos
aspectos, mais elegante, começaremos com ele. Ademais, ele foi projetado e implementado em primeiro lugar e
teve grande influência no Windows 7, portanto, essa ordem faz mais sentido do que o inverso.

## Introdução
Nesta seção, daremos uma breve introdução de nossos dois exemplos de sistemas operacionais, UNIX e
Windows 7, focalizando a história, a estrutura e as chamadas de sistema.

## UNIX

História do UNIX 
- Origem (1970): Ken Thompson (Bell Labs) desenvolve UNIX no PDP-7. Depois, Dennis Ritchie cria C e migra UNIX para PDP-11.
- Autores: Thompson e Ritchie → Turing Award (1984) pelo UNIX.
- Publicação (1974): Artigo de Ritchie e Thompson → universidades adotam UNIX.
- Adoção:
    - Universidades (ex: Berkeley) modificam código-fonte.
    - Berkeley UNIX: VAX, memória virtual, TCP/IP, nomes longos (255 chars).
- AT&T:
    - System III (1982) → System V (1984).
    - Não comercializava UNIX devido a monopólio regulamentado.
- Divisão (fim 1980): Berkeley vs System V → incompatibilidade.
- Consequência: Dificuldade para software rodar em diferentes UNIX.
- Solução (POSIX): Padrão IEEE P1003 → portabilidade.

Detalhes do Padrão POSIX e Linux 
- Padrão POSIX: Define chamadas de sistema e utilitários UNIX.
    - P1003.1: ~60 chamadas de sistema (arquivos, processos, etc.).
    - P1003.2: Programas utilitários básicos.
- Linux:
    - Criado por Linus Torvalds (clone do MINIX).
    - Compatível com POSIX P1003.1 (com desvios).
    - Adiciona ~200 chamadas extras (System V + Berkeley).
- Categorias de chamadas no Linux (Figura 6.30): 
    - Gerenciamento de arquivo/diretório (maior categoria).
    - Processos, comunicação, rede, etc.

## Figura 6.30   Divisão aproximada de chamadas de sistema do UNIX.

+----------------------------+--------------------------------------------+
| Categoria                  | Alguns exemplos                           |
+----------------------------+--------------------------------------------+
| Gerenciamento de arquivo   | Abrir, ler, escrever, fechar e bloquear  |
|                            | arquivos                                  |
+----------------------------+--------------------------------------------+
| Gerenciamento de diretório| Criar e apagar diretórios; mover arquivos |
|                            | de um lado para outro                     |
+----------------------------+--------------------------------------------+
| Gerenciamento de processo  | Gerar, encerrar, monitorar e sinalizar    |
|                            | processos                                 |
+----------------------------+--------------------------------------------+
| Gerenciamento de memória   | Compartilhar memória entre processos;     |
|                            | proteger páginas                          |
+----------------------------+--------------------------------------------+
| Obter/ajustar parâmetros   | Obter ID de usuário, grupo, processo;     |
|                            | definir prioridade                        |
+----------------------------+--------------------------------------------+
| Datas e horários           | Definir horários de acesso a arquivos;    |
|                            | usar temporizador de intervalo; execução  |
|                            | de perfil                                 |
+----------------------------+--------------------------------------------+
| Rede                       | Estabelecer/aceitar conexão; enviar/      |
|                            | receber mensagens                         |
+----------------------------+--------------------------------------------+
| Diversos                   | Habilitar contabilidade; manipular cotas  |
|                            | de disco; reiniciar o sistema             |
+----------------------------+--------------------------------------------+
 

Trabalho em Rede no UNIX de Berkeley 
- Soquete (socket): Extremidade de conexão de rede (inspirado em tomadas de telefone).
- Funcionalidade:
    - Processo cria soquete, liga e conecta a máquina distante.
    - Comunicação bidirecional (TCP/IP).
- Impacto: UNIX amplamente usado em servidores Internet.

Estrutura do Sistema Operacional UNIX 
- Camada inferior: Drivers de dispositivo (isolam hardware).
- Problema: Duplicação de código em drivers.
- Solução: Fluxos (streams) de Dennis Ritchie.
    - Conexão bidirecional: processo ↔ hardware.
    - Módulos processam/transformam dados no caminho.

## Figura 6.31: Estrutura de um Sistema UNIX Típico
O diagrama mostra a hierarquia desde o hardware até as aplicações do usuário, dividida pela interface de chamadas de sistema.

ESTRUTURA DO SISTEMA UNIX (Figura 6.31)
           -----------------------------------------

   MODO USUÁRIO
   +-----------------------------------------------------------+
   |      Shell      |             Programas do Usuário        |
   +-----------------------------------------------------------+
                               |
            INTERFACE DE CHAMADA DE SISTEMA (System Calls)
                               |
   MODO NÚCLEO (KERNEL)        v
   +-----------------------------------+-----------------------+
   |       Sistema de Arquivos         | Gerenciamento de Proc.|
   +-----------------------------------+----------+------------+
   |         Cache de Bloco            |    IPC   | Escalonam. |
   +-----------------------------------+----------+------------+
   |      Drivers de Dispositivo       |  Sinais  | Ger. Memór.|
   +-----------------------------------+----------+------------+
                               |
   HARDWARE                    v
   +-----------------------------------------------------------+
   |          Processador, Memória, Discos, I/O                |
   +-----------------------------------------------------------+

Componentes Principais

 - Modo Usuário: Onde rodam o Shell e as aplicações. Eles não têm acesso direto ao hardware por questões de segurança.

 - Interface de Chamada de Sistema: A fronteira que permite que programas solicitem serviços ao núcleo (como ler um arquivo ou criar um processo).

 - Modo Núcleo: Contém os subsistemas críticos:

   - Sistema de Arquivos e Cache de Bloco: Gerenciam como os dados são organizados e armazenados.

   - Gerenciamento de Processos e Escalonamento: Decide qual programa usa a CPU e quando.

   - IPC (Inter-Process Communication) e Sinais: Facilitam a comunicação entre diferentes tarefas.

   - Gerenciamento de Memória: Controla a alocação de RAM e paginação.

## Sistema de Arquivos e Gerenciamento de Processos 

- Sistema de arquivos:
    - Gerencia nomes, diretórios, blocos, proteção.
    - Cache de blocos para otimizar leituras.
    - Exemplos: Berkeley Fast File System, sistemas estruturados em log.
- Gerenciamento de processos:
    - IPC (comunicação entre processos).
    - Escalonamento por prioridades.
    - Sinais (interrupções assíncronas).
    - Gerenciamento de memória virtual paginada.

Evolução do UNIX 
- Início: Sistema pequeno, texto (24x80 ASCII).
- Interface: Shell (nível usuário, linha de comando).
- Evolução: Novas shells mais sofisticadas.

Mais tarde, quando surgiram os terminais gráficos, o MIT desenvolveu um sistema de janelas para o UNIX,
denominado X Windows. Um pouco mais tarde, uma GUI (Graphical User Interface – interface gráfica de
usuário) totalmente desenvolvida, denominada Motif, foi colocada sobre o X Windows. Para se manter fiel à
filosofia do UNIX de ter um núcleo pequeno, quase todos os códigos do X Windows e suas GUIs correspondentes
executam em modo usuário, fora do núcleo.

## História do Windows 
- 1981: IBM PC com MS-DOS 1.0 (16 bits, modo real, 8 KB).
- Evolução MS-DOS:
    - 1983: MS-DOS 2.0 (24 KB, shell com características UNIX).
    - 1984: MS-DOS 3.0 (36 KB, com 286).
- Windows:
    - Inspirado no Macintosh (interface gráfica).
    - Windows 1-3.x: GUI sobre MS-DOS (sem ser SO verdadeiro).
    - Sem proteção de memória → bugs travavam o sistema.

Evolução do Windows 
- Windows 95 (1995): MS-DOS 7.0 incluso (não era 32 bits completo).
    - Memória virtual, processos, multiprogramação.
    - Limitado pelo sistema de arquivos MS-DOS.
- Windows 98/ME: MS-DOS persistia (16 bits).
- Windows NT/2000/XP:
    - Nova linha (32 bits, redesenhado).
    - Focado em servidores → depois desktop.
- Windows Vista (2007): Melhorias gráficas, recursos novos.
    - Adotado lentamente (desempenho, recursos).
- Windows 7 (2009): Ajustes do Vista.
    - Melhor desempenho em hardware antigo.
    - 6 versõe

Antes de entrarmos na interface que o Windows 7 apresenta aos programadores, vamos dar uma rápida olhada em
sua estrutura interna, conforme ilustra a Figura 6.32. Ela consiste em diversos módulos que são estruturados em camadas
e trabalham juntos para executar o sistema operacional. Cada módulo tem alguma função em particular e uma interface
bem definida com outros módulos. Quase todos eles são escritos em C, embora parte da interface gráfica de dispositivo
seja escrita em C++ e algumas pequenas partes das camadas inferiores sejam escritas em linguagem de montagem.

## Figura 6.32: A Estrutura do Windows 7

O Windows 7 utiliza uma estrutura em camadas que isola o hardware das aplicações através de drivers e do executivo do NTOS.
ESTRUTURA DO WINDOWS 7 (Figura 6.32)
            --------------------------------------

   MODO USUÁRIO
   +-----------------------------------------------------------+
   |  Rotinas de despacho do modo usuário do núcleo da bibl.   |
   +-----------------------------------------------------------+
                               |
   MODO NÚCLEO                 v
   +-----------------------------------------------------------+
   | Camada de núcleo | Despacho de exceção / interrupção      |
   | do NTOS          | Escalonamento e sincronização da CPU   |
   +------------------+----------------------------------------+
   |                  | Procedimentos | Memória | Ger. de | Ger. |
   |     Drivers      | e threads     | Virtual | Objetos | Conf.|
   | (Sist. Arquivo,  +---------------+---------+---------+------+
   |  TCP/IP, Vídeo,  | Chamadas proc.| Ger. de | Ger. de | Mon. |
   |  etc.)           | locais        | Cache   | E/S     | Seg. |
   +------------------+-------------------------+---------+------+
   |           Biblioteca em tempo de execução do executivo    |
   +-----------------------------------------------------------+
   |                  Camada do executivo do NTOS              |
   +-----------------------------------------------------------+
   |                 Camada de abstração de hardware (HAL)     |
   +-----------------------------------------------------------+
                               |
   HARDWARE                    v
   +-----------------------------------------------------------+
   |      CPU, MMU, Memória, Dispositivos físicos, BIOS        |
   +-----------------------------------------------------------+

Componentes Chave da Arquitetura

 - HAL (Hardware Abstraction Layer): Uma camada de software que esconde as diferenças de hardware da placa-mãe, permitindo que o SO rode em diferentes plataformas sem mudar o núcleo.

 - Executivo do NTOS: Contém os serviços fundamentais como gerenciamento de memória virtual, gerenciamento de objetos e monitor de segurança.

 - Gerenciador de Cache e E/S: Otimiza o acesso aos drivers e aos sistemas de arquivos.

 - Escalonamento e Sincronização: Localizado na camada de núcleo do NTOS, controla como as threads utilizam a CPU.

Estrutura do Windows 7 
- Camada de Abstração de Hardware (HAL):
    - Abstrai hardware (caches, temporizadores, barramentos, etc.).
    - Facilita portabilidade para outras plataformas.
- Executivo NTOS + Drivers:
    - Gerencia threads, processos, memória, objetos, segurança, E/S.
    - Camada do núcleo: exceções, escalonamento, sincronização.
- Modo usuário:
    - Programas + Biblioteca do sistema (interface via Win32 API).
    - Win32: chamadas padrão para versões do Windows (32/64 bits).

API Win32 vs UNIX 
- Diferenças:
    - UNIX: Interface mínima, pública, remover chamadas reduz funcionalidade.
    - Win32: Interface abrangente, múltiplos modos, inclui funções não-sistema.
- Objetos de núcleo:
    - Criados via API, retornam manipuladores (handles).
    - Manipuladores são específicos do processo (≠ UNIX).
    - Podem ser duplicados para acesso controlado a outros processos.
- Segurança:
    - Objetos têm descritor de segurança (quem pode fazer o quê).
- Orientação a objeto:
    - Win32 usa métodos (API) sobre handles.
    - Faltam recursos como herança e polimorfismo.

## Exemplos de memória virtual

Nesta seção, estudaremos a memória virtual no UNIX e no Windows 7. Em grande parte, elas são bastante
semelhantes do ponto de vista do programador.

Memória virtual do UNIX

O modelo de memória do UNIX é simples. Cada processo tem três segmentos: código, dados e pilha, como
ilustrado na Figura 6.33. Em uma máquina com um único espaço de endereço linear, o código geralmente é
colocado próximo à parte de baixo da memória, seguido pelos dados. A pilha é colocada na parte de cima da
memória. O tamanho do código é fixo, mas os dados e a pilha podem crescer, até mesmo em direções opostas.
Esse modelo é fácil de implementar em praticamente qualquer máquina e é usado por variantes do Linux que
rodam nas CPUs ARM do OMAP4430.

## Figura 6.33: Espaço de Endereçamento de um Processo UNIX
O diagrama mostra a divisão entre código, dados e a pilha (stack), situados entre o endereço base 0 e o endereço máximo 0xFFFFFFFF.

ESPAÇO DE ENDEREÇO DO PROCESSO (Figura 6.33)
      ----------------------------------------------

    Endereço
  0xFFFFFFFF  +--------------------------+
              |          Pilha           | (Cresce para baixo)
              |            |             |
              |            v             |
              |                          |
              |            ^             |
              |            |             |
              |          Dados           | (Cresce para cima)
              +--------------------------+
              |          Código          | (Tamanho fixo)
           0  +--------------------------+

Componentes do Espaço de Endereço

 - Código (Text Segment): Contém as instruções executáveis do programa. Geralmente fica na base da memória e tem tamanho fixo durante a execução.

 - Dados (Data/Heap): Onde ficam as variáveis globais e a memória alocada dinamicamente (malloc). Esta seção cresce em direção aos endereços mais altos.

 - Pilha (Stack): Usada para variáveis locais e chamadas de função. Ela começa no topo do endereço de memória (0xFFFFFFFF em sistemas 32 bits) e cresce para baixo.

    - Nota: O espaço vazio entre Dados e Pilha permite que ambos cresçam conforme a necessidade do programa sem colidirem imediatamente.

Gerenciamento de Memória no UNIX 
- Paginação:
    - Espaço de endereço paginado (programas > memória física).
    - Sistemas sem paginação trocam processos inteiros.
- Mapeamento de Arquivos (System V, Linux):
    - Mapeia arquivo para espaço de endereço (mmap).
    - Lê/escreve no arquivo via acesso direto à memória.
    - Exemplo: mmap(144K, 12K, ..., fd, 0) → lê arquivo em 144K.
- Compartilhamento:
    - Compartilhamento real: escritas visíveis a todos.
    - Cópia na escrita: cada processo tem cópia se modificar.
    - Usado para comunicação ou ilusão de exclusividade.

## Memória Virtual no Windows 7 
- Espaço de endereço:
    - 32 bits: 4 GB (2 GB usuário + 2 GB núcleo) ou 3/1 GB (Server).
    - 64 bits: 8 TB (código/dados).
- Páginas (4 KB):
    - Livre: não usada, causa falta de página.
    - Reservada: indisponível até liberar.
    - Comprometida: mapeada, com página sombra no disco.
- Gerenciamento:
    - Páginas sombras em arquivos de paginação (exceto código executável).
    - Atributos: leitura, escrita, execução.
    - Topo/base (64 KB) sempre livres (pegar erros de ponteiro).

Arquivos Mapeados no Windows 7 
- Mapeamento de arquivos:
    - Arquivo mapeado para espaço de endereço (leitura/escrita via memória).
    - Páginas sombras no disco (≠ arquivo de paginação).
- Compartilhamento entre processos:
    - Múltiplos processos mapeiam o mesmo arquivo.
    - Comunicação via memória (alta largura de banda, sem cópias).
    - Alterações visíveis a todos (mesmo antes de atualizar disco).
- Gerenciamento de memória (API Win32):
    - Funções para gerenciar regiões de páginas (ex.: VirtualAlloc).

## Figura 6.34: Principais chamadas da API do Windows 7 

+-----------------------+------------------------------------------------------+
| FUNÇÃO DA API         | SIGNIFICADO                                          |
+-----------------------+------------------------------------------------------+
| VirtualAlloc          | Reserva ou compromete uma região de memória          |
| VirtualFree           | Libera ou descompromete uma região                   |
| VirtualProtect        | Altera a proteção (ler/escrever/executar) na região  |
| VirtualQuery          | Consulta o estado de uma região                      |
| VirtualLock           | Torna a região residente (desabilita paginação)      |
| VirtualUnlock         | Torna a região paginável novamente                   |
| CreateFileMapping     | Cria um objeto de mapeamento de arquivo              |
| MapViewOfFile         | Mapeia o arquivo para o espaço de endereço           |
| UnmapViewOfFile       | Remove o arquivo mapeado do espaço de endereço       |
| OpenFileMapping       | Abre um objeto de mapeamento de arquivo existente    |
+-----------------------+------------------------------------------------------+



Esta tabela detalha as funções utilizadas pelo sistema para gerenciar o espaço de endereçamento virtual.# 

Funções da API Win32 para Memória 
- Controle de Páginas:
    - VirtualLock: Prende páginas na memória (desabilita paginação).
    - VirtualUnlock: Libera páginas (paginação normal).
    - Requer privilégios de administrador, com limite do sistema.
- Acesso a Memória de Outros Processos:
    - Funções permitem acesso à memória de processos controlados (com handle).

Funções da API para Arquivos Mapeados 
- Gerenciamento de Arquivos Mapeados:
    - CreateFileMapping: Cria objeto de mapeamento (com nome opcional).
    - MapViewOfFile: Mapeia arquivo para espaço de endereço.
    - UnmapViewOfFile: Remove arquivo mapeado.
    - OpenFileMapping: Abre mapeamento existente (compartilhamento).
- Processos compartilham páginas (útil para comunicação).
- Gerenciamento de Memória:
    - Heaps: alocação/liberação de dados (≠ coleta de lixo).
    - Uso semelhante a malloc em UNIX, mas com múltiplos heaps.
    - Usuário gerencia memória (sem coleta de lixo automática).

## Exemplos de E/S virtual em nível de sistema operacional

O coração de qualquer sistema operacional é proporcionar serviços a programas do usuário, em grande
parte serviços de E/S como ler e escrever arquivos. Ambos, UNIX e Windows 7, oferecem uma ampla variedade
de serviços de E/S para programas do usuário. O Windows 7 tem uma chamada equivalente para a maioria das
chamadas de sistema UNIX, mas o contrário não é verdadeiro, porque o Windows 7 tem muito mais chamadas e
cada uma delas é muito mais complicada do que sua correspondente no UNIX.

## E/S em UNIX 
- Arquivos:
    - Sequência linear de bytes (0 a 2⁶⁴-1).
    - Sem estrutura de registros (exceto texto ASCII com \n).
    - Ponteiro indica próximo byte a ler/escrever.
- Acesso:
    - read/write movem ponteiro após operação.
    - Acesso aleatório ajustando ponteiro explicitamente.
- Arquivos Especiais:
    - Acessam dispositivos de E/S (discos, impressoras, etc.).
- Chamadas de Sistema (Fig. 6.35):
    - creat: Cria arquivo (agora open também cria).
    - unlink: Remove arquivo (se em um diretório).

Chamadas de Sistema de E/S em UNIX 
- Gerenciamento de Arquivos:
    - open: Abre/cria arquivo (retorna descritor fd).
    - close: Libera descritor de arquivo.
- E/S:
    - read/write: Lê/escreve dados (usa fd, buffer, count).
- Posicionamento:
    - lseek: Ajusta ponteiro de arquivo (acesso aleatório).

## Figura 6.35  Principais chamadas de sistema de arquivos UNIX.

+----------------------------+-------------------------------------------------------+
| CHAMADA DE SISTEMA         | SIGNIFICADO                                           |
+----------------------------+-------------------------------------------------------+
| creat(name, mode)          | Cria um arquivo; mode especifica a proteção           |
| unlink(name)               | Apaga um arquivo (remove o link do diretório)         |
| open(name, mode)           | Abre/cria arquivo e retorna um descritor (fd)         |
| close(fd)                  | Fecha um arquivo aberto                               |
| read(fd, buffer, count)    | Lê 'count' bytes do arquivo para o buffer             |
| write(fd, buffer, count)   | Escreve 'count' bytes do buffer para o arquivo        |
| lseek(fd, offset, w)       | Move o ponteiro do arquivo (acesso aleatório)         |
| stat(name, buffer)         | Obtém metadados (tamanho, datas) do arquivo           |
| chmod(name, mode)          | Altera as permissões de acesso do arquivo             |
| fcntl(fd, cmd, ...)        | Controle de arquivo (ex: travas/locking de registros) |
+----------------------------+-------------------------------------------------------+

## Cópia de Arquivo em UNIX (Fig. 6.36) 
- Passos:
    1. Abre arquivos:
        - infd = open("data", 0): Abre data para leitura.
        - outfd = creat("newf", ProtectionBits): Cria newf com permissões.
    2. Loop de cópia:
        - read(infd, buffer, bytes): Lê até bytes de infd para buffer.
        - write(outfd, buffer, count): Escreve count bytes em outfd.
        - Repete até count <= 0 (fim do arquivo).
    3. Fecha arquivos:
        - close(infd) e close(outfd): Libera descritores.
- Observações:
    - Código em C (baixo nível).
    - ProtectionBits define permissões (ex.: leitura/escrita).
    - Falta verificação de erros (simplificado).

## Esse fragmento está em C porque Java
oculta as chamadas de sistema de nível baixo e estamos tentando expô-las.

/* Abre os descritores de arquivo. */
infd = open(˝data˝, 0);
outfd = creat(˝newf˝, ProtectionBits);
/* Laço de cópia. */
do {
count = read(infd, buffer, bytes);
if (count > 0) write(outfd, buffer, count);
} while (count > 0);
/* Fecha os arquivos. */
close(infd);
close(outfd);

## FFigura 6.37: Sistema de Diretório Típico do UNIX
Este diagrama ilustra como o diretório raiz (/) se ramifica em subdiretórios até chegar aos arquivos de dados finais (folhas):

DIRETÓRIO RAIZ (/)
                  +---------------+
                  |      bin      |--+
                  |      dev      |--|--+
                  |      lib      |--|--|--+
                  |      usr      |--|--|--|--+
                  |      ...      |  |  |  |  |
                  +---------------+  |  |  |  |
            +------------------------+  |  |  |
            |   +-----------------------+  |  |
            |   |   +----------------------+  |
            v   v   v                         v
          /lib /dev /bin                    /usr
         +---+ +---+ +---+            +---------------+
         |   | |   | |   |            |      ast      |--+
         |---| |---| |---|            |      jim      |--|--+
         |   | |   | |   |            |      ...      |  |  |
         +---+ +---+ +---+            +---------------+  |  |
                                        |                |  |
                 +----------------------+                |  |
                 |                +----------------------+  |
                 v                v                         |
              /usr/ast         /usr/jim                     |
         +---------------+ +---------------+                |
         |      bin      |-|     jotto     |--+             |
         |      data     | +---------------+  |             |
         |      foo.c    |                    |             |
         |      ...      |                    |             |
         +---------------+                    |             |
                 |                            |             |
                 v                            |             |
            /usr/ast/bin                      |             |
         +---------------+                    |             |
         |    game 1     |--+                 |             |
         |    game 2     |--|--+              |             |
         |    game 3     |--|--|--+           |             |
         |    game 4     |--|--|--|--+        |             |
         +---------------+  |  |  |  |        |             |
                            v  v  v  v        v             v
                         [ ARQUIVOS DE DADOS (Folhas da Árvore) ]

Conceitos de Estrutura de Dados Aplicados
Hierarquia de Árvore: O sistema organiza os arquivos em uma estrutura de árvore onde os nós internos são diretórios e as folhas são os arquivos de dados.

Caminhos (Paths): O acesso a um arquivo exige percorrer a árvore. Por exemplo, para chegar em game 1, o SO percorre / -> usr -> ast -> bin -> game 1.

Encadeamento: Cada entrada de diretório aponta para o próximo nível da estrutura ou para os blocos de dados no disco.

## Detalhes sobre read e write em UNIX 
- Parâmetros de read(fd, buffer, bytes):
    - fd: Descritor de arquivo.
    - buffer: Local de armazenamento.
    - bytes: Quantidade desejada.
    - Retorna count (pode ser < bytes se arquivo curto).
- Descritores de Arquivo:
    - Inteiros pequenos (< 20).
    - Especiais: 0 (entrada padrão), 1 (saída padrão), 2 (erro padrão).
    - Redirecionáveis pelo usuário.
- Filtros:
    - Programas que leem de stdin, escrevem em stdout.

Sistema de Diretórios em UNIX 
- Estrutura:
    - Hierarquia a partir do diretório raiz (/).
    - Ex.: /bin, /dev, /usr/ast/bin/game2.
- Caminhos:
    - Absolutos: A partir da raiz (/usr/ast/bin/game2).
    - Relativos: Do diretório de trabalho (bin/game3 se /usr/ast).
- Links:
    - link: Cria atalho (ex.: /usr/ast/bin/game3 → /usr/jim/jotto).
    - Não permite links para diretórios (evita ciclos).
- Chamadas de Sistema (Fig. 6.38):
    - mkdir, rmdir: Cria/remove diretório.
    - opendir, readdir, closedir: Lê entradas.
    - chdir: Muda diretório de trabalho.

## Figura 6.38  Principais chamadas de gerenciamento de diretório do UNIX.

+-------------------------------+-----------------------------------------------------------+
| Chamada de sistema            | Significado                                               |
+-------------------------------+-----------------------------------------------------------+
| mkdir(name, mode)             | Cria um novo diretório                                    |
| rmdir(name)                   | Apaga um diretório vazio                                  |
| opendir(name)                 | Abre um diretório para leitura                            |
| readdir(dirpointer)           | Lê a próxima entrada em um diretório                      |
| closedir(dirpointer)          | Fecha um diretório                                        |
| chdir(dirname)                | Muda diretório de trabalho para dirname                   |
| link(name1, name2)            | Cria uma entrada de diretório name2 que aponta para name1 |
| unlink(name)                  | Remove name de seu diretório                              |
+-------------------------------+-----------------------------------------------------------+
 
 
Detalhes sobre link, unlink e Permissões 
- link(name1, name2):
    - Cria entrada name2 apontando para name1 (mesmo arquivo).
    - Exemplo: link("/usr/ast/bin/game3", "/usr/jim/jotto").
- unlink(name):
    - Remove entrada (apaga arquivo se último link).
- Permissões (RWX):
    - 3 campos: Proprietário, Grupo, Outros.
    - Ex.: RWX R-X --X → dono lê/escreve/executa, grupo lê/executa, outros só executam.
- i-node (64 bytes):
    - Informações do arquivo (dono, permissões, localização).
    - Localizado via número de i-node (cálculo de endereço).

i-node em UNIX (detalhes) 
- Busca por i-node:
    - Sistema analisa caminho (ex.: /usr/ast/data):
        1. Lê raiz → acha usr.
        2. Lê usr → acha ast.
        3. Lê ast → acha data.
        4. Usa número de i-node para acessar informações.
- Campos do i-node:
    1. Tipo e permissões: RWX (dono, grupo, outros) + bits extras.
    2. Links: Contagem de entradas de diretório (0 → arquivo é apagado).
    3. Proprietário e Grupo: Identificadores.
    4. Tamanho: Bytes.
    5. Endereços de disco: 13 ponteiros (diretos + indiretos).
    6. Tempos:
        - Última leitura.
        - Última escrita.
        - Última alteração do i-node.
- Observação:
    - i-node contém metadados (sem dados do arquivo).

Endereçamento de Disco em i-node (UNIX) 
- 10 endereços diretos:
    - Apontam para blocos de dados (até 10.240 bytes com blocos de 1 KB).
- 1 endereço indireto (11º):
    - Aponta para bloco com 256 endereços → até 272.384 bytes.
- 1 endereço indireto duplo (12º):
    - Aponta para 256 blocos indiretos → até 67.381.248 bytes.
- 1 endereço indireto triplo (13º):
    - Aponta para 256 indiretos duplos → até 17.247.250.432 bytes (teórico).
- Blocos livres:
    - Mantidos em lista encadeada (alocação não contígua → fragmentação).

E/S de Arquivo em UNIX (otimizações) 
- Abertura (open):
    - Lê i-node para memória (acelera acessos).
    - Mantém blocos recentes em cache.
- Leitura/Escrita (read/write):
    - Calcula bloco a partir da posição atual.
    - Usa endereços diretos (i-node) ou indiretos (lidos sob demanda).
    - Prefetch do próximo bloco (acelera sequenciais).
- lseek:
    - Apenas atualiza ponteiro (sem E/S).
- link e unlink:
    - link: Cria entrada com i-node e incrementa contador.
    - unlink: Remove entrada, decrementa contador (apaga se 0).

## E/S no Windows 7
O Windows 7 suporta vários sistemas de arquivos, e os mais importantes deles são o NTFS (NT File System
– sistema de arquivos do NT) e o FAT (File Allocation Table – tabela de alocação de arquivos). O primeiro é
um novo sistema de arquivos desenvolvido para o NT; o último é o velho sistema de arquivos do MS-DOS, que
também foi usado nos Windows 95/98 (porém, com suporte para nomes de arquivo mais longos). Dado que o
sistema de arquivos FAT é obsoleto (exceto para pendrives e cartões de memória SD, por exemplo), passaremos
a estudar o NTFS.

NTFS (Windows) vs UNIX 
- Nomes de Arquivos:
    - NTFS: Até 255 chars, Unicode (suporte a línguas não latinas).
    - UNIX: UTF-8 (suporte a internacionalização).
- Case Sensitivity:
    - NTFS: Diferencia maiúsculas/minúsculas (mas Win32 não).
    - UNIX: Diferencia (padrão).
- Arquivos:
    - Sequência linear de bytes (NTFS: até 2⁶⁴-1 bytes).
    - Ponteiros de 64 bits (NTFS) vs 32/64 bits (UNIX).
- API:
    - Win32: Mais parâmetros, segurança diferente, handles * (vs inteiros em UNIX).
    - CreateFile, ReadFile, etc. (Fig. 6.39).

## Figura 6.39  Principais funções da API Win32 para E/S de arquivo.

+-------------------------------+-------------------------------------------------------------------+
| Função da API Win32          | Equivalente UNIX             | Significado                         |
+-------------------------------+-------------------------------------------------------------------+
| CreateFile                   | open                         | Cria/abre arquivo; retorna *handle* |
| DeleteFile                   | unlink                       | Exclui entrada de arquivo           |
| CloseHandle                  | close                        | Fecha um arquivo                    |
| ReadFile                     | read                         | Lê dados de um arquivo              |
| WriteFile                    | write                        | Escreve dados em um arquivo         |
| SetFilePointer               | lseek                        | Ajusta ponteiro de arquivo          |
| GetFileAttributes            | stat                         | Retorna propriedades do arquivo     |
| LockFile                     | fcntl                        | Bloqueia região (exclusão mútua)    |
| UnlockFile                   | fcntl                        | Desbloqueia região bloqueada        |
+-------------------------------+-------------------------------------------------------------------+

CreateFile (Win32) 
- Uso:
    - Cria arquivo novo OU abre existente (não há open separado).
    - Retorna handle para manipulação.
- Parâmetros principais:
    1. Nome do arquivo.
    2. Permissões (leitura/escrita).
    3. Acesso simultâneo (multi-processo).
    4. Descritor de segurança (quem pode acessar).
    5. Comportamento se arquivo existir/não existir.
    6. Atributos (ex.: compressão).
    7. Handle para clonar atributos.
- E/S:
    - Assíncrona (mas pode esperar término).
    - LockFile/UnlockFile: exclusão mútua em regiões.

## Cópia de Arquivo com Win32 API - Fig 6.40
- Código (C, sem verificação de erros):

/* Abra arquivos */
inhandle = CreateFile("data", GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, NULL);
outhandle = CreateFile("newf", GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

/* Copie o arquivo */
do {
    s = ReadFile(inhandle, buffer, BUF_SIZE, &count, NULL);
    if (s > 0 && count > 0)
        WriteFile(outhandle, buffer, count, &ocnt, NULL);
} while (s > 0 && count > 0);

/* Feche os arquivos */
CloseHandle(inhandle);
CloseHandle(outhandle);

- Observações:
    - Equivalente a CopyFile (função da API Win32).
    - Java oculta essas chamadas (exemplo em C para mostrar detalhes).

Usando essas funções da API é possível escrever um procedimento para copiar um arquivo, análogo à ver-
são UNIX da Figura 6.36. Tal procedimento (sem nenhuma verificação de erro) é mostrado na Figura 6.40. Foi
projetado para imitar a estrutura da Figura 6.36. Na prática, não teríamos de programar uma função para cópia
de arquivo, uma vez que CopyFile é uma função da API (que executa algo parecido com esse programa, como um
procedimento de biblioteca)

## Sistema de Arquivos no Windows 7 
- Hierárquico (como UNIX):
    - Separador: \ (ao invés de /).
    - Caminhos relativos/absolutos.
    - Diretório de trabalho corrente.
- Diferenças (pré-Windows 2000):
    - Necessário letra de drive (ex.: C:\windows\file.txt).
    - Sem montagem unificada (como UNIX).
- Pós-Windows 2000:
    - Suporte a montagem estilo UNIX (raiz única).

Gerenciamento de Diretório (Win32) 
- Funções principais (Fig. 6.41):
    - CreateDirectory, RemoveDirectory, SetCurrentDirectory...
    - Equivalente UNIX: mkdir, rmdir, chdir...
- Segurança (Win32):
    - Ficha de acesso (SID, grupos, privilégios).
    - Descritor de segurança (ACL → permissões por SID/grupo).
    - Ex.: Leonora (nenhum), Ricardo (leitura), Linda (leitura/escrita)...

## Figura 6.41  Principais funções da API Win32 para gerenciamento de diretório.

+-------------------------------+-------------------------------------------------------------+
| Função da API Win32          | Equivalente UNIX             | Significado                   |
+-------------------------------+-------------------------------------------------------------+
| CreateDirectory              | mkdir                        | Cria um novo diretório        |
| RemoveDirectory              | rmdir                        | Remove um diretório vazio     |
| FindFirstFile                | opendir                      | Inicializa e lê entradas      |

| FindNextFile                 | readdir                      | Lê a próxima entrada          |
| MoveFile                     | -                            | Move arquivo entre diretórios |
| SetCurrentDirectory          | chdir                        | Muda diretório de trabalho    |
+-------------------------------+-------------------------------------------------------------+
 
Segurança e Implementação de Arquivos (Win32) 
- Verificação de Acesso:
    - Gerenciador de segurança checa:
        1. Nível de integridade (ficha vs descritor do objeto).
        2. Percorre ACL (primeira entrada que combina define acesso).
    - Ex.: Negar acesso a usuário X → colocar antes de "permitir" a grupo Y.
- Níveis de Integridade:
    - Baixo (ex.: código de navegador) → não pode escrever em objetos altos.
- Volumes e Clusters:
    - Volume = partição (mapas de bits, arquivos, diretórios...).
    - Cluster: unidade de alocação (512 bytes a 64 KB).
    - Referenciados por offset de 64 bits (suporta discos grandes).

MFT (Master File Table) no NTFS 
- Estrutura:
    - Cabeçalho: infos do volume (raiz, inicialização, blocos ruins...).
    - Entradas de 1 KB (ou + se cluster > 2 KB):
        - Campos fixos:
            - Padrão de informações (timestamps, links, permissões...).
            - Nome Unicode (até 255 chars).
            - Nome MS-DOS (8+3) opcional.
        - Campos variáveis:
            - Dados (pequenos arquivos podem estar na MFT).
            - Atributos (ex.: compressão, criptografia).
            - Ponteiros para blocos de dados (clusters).
- Vantagens:
    - Flexibilidade (MFT não precisa estar no início).
    - Suporta arquivos pequenos (na própria MFT).
- Metadados:
    - Timestamps (criação, modificação, acesso...).
    - Contagem de links (hard links).
    - Permissões (ACLs).

## Figura 6.42 TABELA MESTRA DE ARQUIVOS (MFT)
      +-------------------------------+
      |              ...              |
      +-------------------------------+
      |       Entrada da MFT          |-----.
      +-------------------------------+     |
      |       Entrada da MFT          |     |     ESTRUTURA DE UMA ENTRADA DA MFT
      +-------------------------------+     |    +----------+----------+--------+-----------+-------+
      |       Entrada da MFT          |     |    | Inform.  | Nome de  | Nome   | Segurança | Dados |
      +-------------------------------+     '--->| Padrão   | Arquivo  | MS-DOS |           |       |
      |       Entrada da MFT          |          +----------+----------+--------+-----------+-------+
      +-------------------------------+          |          Entrada da MFT para um arquivo         |
      |       Entrada da MFT          |          +-------------------------------------------------+
      +-------------------------------+
      |                               |
      |          Cabeçalho            |
      |           da MFT              |
      |                               |
      +-------------------------------+

Detalhes da MFT e Arquivos no NTFS 
- Segurança:
    - Até NT 4.0: descritor na própria entrada MFT.
    - Depois: centralizado em arquivo único (ponteiro na MFT).
- Armazenamento de Dados:
    - Arquivos pequenos: dados na própria entrada MFT ("arquivo imediato").
    - Maiores: ponteiros para clusters (ou carreiras de clusters).
- Capacidade:
    - Tamanho máximo: 2⁶⁴ bytes (15 anos-luz em mm 😱).
- Outras propriedades:
    - Compressão de dados.
    - Tolerância a falhas (transações atômicas).

## Exemplos de Uso da MFT no NTFS 
- Arquivo Pequeno (imediato):
    - Tamanho < ~700 bytes (cabe na MFT).
    - Dados armazenados direto na entrada MFT.
    - Exemplo: nota.txt (texto curto) → conteúdo na MFT.
- Arquivo Grande:
    - Ponteiros para clusters (ou carreiras).
    - Exemplo: video.mp4 (1 GB) → MFT aponta para clusters.
- Segurança:
    - ACLs armazenadas centralmente (desde Win2000).
    - Exemplo: documento.docx → MFT aponta para ACL em $Secure.
- Compressão:
    - NTFS comprime arquivos automaticamente (opcional).
    - Exemplo: log.txt (muito texto repetido) → menor no disco.

## Exemplos de gerenciamento de processo

Tanto UNIX quanto Windows 7 permitem que uma tarefa seja subdividida em vários processos que podem
executar em (pseudo)paralelismo e se comunicar entre si, no estilo do exemplo de produtor-consumidor que já
discutimos. Nesta seção, discorreremos sobre como processos são gerenciados em ambos os sistemas. Os dois
suportam paralelismo dentro de um único processo usando threads, portanto, isso também será abordado.

## Gerenciamento de processo em UNIX

Gerenciamento de Processos em UNIX 
- Criação de Processos:
    - fork(): cria cópia exata do processo pai (filho idêntico).
    - Pai e filho independentes após fork.
- Execução de Programas:
    - exec(): substitui código/dados do processo atual.
    - Exemplo: shell → fork + exec(xyz) → roda xyz.
- Sincronização:
    - wait()/waitpid(): pai espera filho terminar.
    - Filho termina com exit().
## Figura 6.43: Árvore de Processos em UNIX

Este diagrama representa como os processos são criados em uma hierarquia de pai e filho, formando uma estrutura de árvore:

+-------------------------------------------------------------+
|              ESTRUTURA HIERÁRQUICA DE PROCESSOS             |
+-------------------------------------------------------------+
|                                                             |
|          [A]  <-- Processo Original (Raiz)                  |
|         /   \                                               |
|        /     \                                              |
|      [B]     [C] <-- Filhos de A                            |
|     /   \      \                                            |
|   [D]   [E]    [F] <-- Netos de A                           |
|                                                             |
+-------------------------------------------------------------+

## Detalhes do Gerenciamento de Processos em UNIX 
- Fork:
    - Cria cópia exata do processo (mesmo código, dados, descritores...).
    - Retorna:
        - 0 no filho.
        - PID do filho no pai.
    - Exemplo:


    pid = fork();
    if (pid == 0) {
        // código do filho
    } else {
        // código do pai
    }
    

- Exec:
    - Substitui o processo atual por outro programa.
    - Exemplo: exec("ls", "ls", "-l", NULL); → roda ls -l.
- Wait:
    - Pai espera filho terminar: wait(&status);.
    - Retorna PID do filho terminado e status (exit code).
- Exemplo Completo:


    pid = fork();
    if (pid == 0) {
        exec("ls", "ls", "-l", NULL); // filho roda ls
    } else {
        wait(&status); // pai espera
        printf("Filho terminou\n");
    }
    
## ÁRVORE DE PROCESSOS EM UNIX (Figura 6.43)
      -----------------------------------------

                    +-----------+
                    |     A     |  <-- Processo Original (Pai)
                    +-----------+
                          |
          ________________|________________
         |                |                |
   +-----------+    +-----------+    +-----------+
   |     B     |    |     C     |    |     D     | <-- Filhos de A
   +-----------+    +-----------+    +-----------+
                          |
                  ________|________
                 |                 |
           +-----------+     +-----------+
           |     E     |     |     F     | <-- Netos de A
           +-----------+     +-----------+


## Mecanismos de Comunicação entre Processos (IPC)

 - Pipes (Conexão ou Tubulação): Funcionam como um buffer onde um processo escreve dados e outro os retira na mesma ordem (FIFO). Não permitem acesso aleatório nem preservam fronteiras de mensagem, agindo como um fluxo contínuo de bytes.

 - Filas de Mensagens: Disponíveis em System V e Linux, permitem enviar (msgsnd) e receber (msgrecv) mensagens individuais. Diferente dos pipes, elas preservam as fronteiras das mensagens, suportam prioridades para mensagens urgentes e permitem filtrar a recepção por tipo de mensagem.

 - Memória Compartilhada: Vários processos compartilham a mesma região de seus espaços de endereçamento virtual. Qualquer escrita feita por um processo é instantaneamente visível aos outros, oferecendo uma comunicação de alta largura de banda através de chamadas como shmat e shmop.

## Sincronização e Concorrência

 - Semáforos: Utilizados para coordenar processos, funcionando de forma similar ao modelo clássico de produtor-consumidor.

 - Threads (Processos Leves): O UNIX permite múltiplos threads de controle dentro de um único processo. Eles compartilham o mesmo espaço de endereço e recursos, como descritores de arquivo, mas operam como fluxos independentes de execução.

## Threads: Funcionamento e Isolamento

 - Recursos Privados: Embora compartilhem o espaço de endereçamento, cada thread possui seu próprio contador de programa (PC), registradores e pilha.

 - Execução Não Bloqueante: Se um thread bloqueia (aguardando E/S, por exemplo), outros threads do mesmo processo podem continuar executando normalmente.

 - Compartilhamento vs. Processos: Threads em um mesmo processo compartilham descritores de arquivo e variáveis globais, diferindo de processos distintos que precisariam de memória compartilhada e manteriam seus próprios recursos isolados.

 - Java e SO: O sistema de execução Java pode mapear seus threads para threads do sistema operacional, mas essa implementação não é obrigatória.

## Exemplo Prático: Servidor Web

 - Problema do Disco: Em um servidor de thread única, esperar por uma página no disco (cerca de 20 ms) bloqueia todo o processo, impedindo o atendimento de novas requisições.

 - Solução com Threads: Múltiplos threads compartilham uma cache comum de páginas na memória principal.

 - Vantagem: Enquanto um thread aguarda o disco, outros atendem requisições de páginas que já estão na cache, evitando o desperdício de memória que ocorreria ao duplicar a cache em vários processos.

## Padrão e Sincronização

 - POSIX (pthreads): O padrão UNIX para threads é o pthreads (P1003.1C), que define chamadas para criação, gerenciamento e sincronização.

 - Implementação: O padrão não exige que os threads sejam gerenciados pelo núcleo (kernel) ou pelo espaço do usuário, deixando isso a cargo da implementação.

## PRINCIPAIS CHAMADAS DE THREAD POSIX (Figura 6.44)
+------------------------+----------------------------------------------------+
| Chamada de thread      | Significado                                        |
+------------------------+----------------------------------------------------+
| pthread_create         | Cria um novo thread no espaço de endereço          |
+------------------------+----------------------------------------------------+
| pthread_exit           | Encerra o thread que está chamando                 |
+------------------------+----------------------------------------------------+
| pthread_join           | Espera que um thread encerre                       |
+------------------------+----------------------------------------------------+
| pthread_mutex_init     | Cria um novo mutex                                 |
+------------------------+----------------------------------------------------+
| pthread_mutex_destroy  | Destrói um mutex                                   |
+------------------------+----------------------------------------------------+
| pthread_mutex_lock     | Bloqueia um mutex                                  |
+------------------------+----------------------------------------------------+
| pthread_mutex_unlock   | Desbloqueia um mutex                               |
+------------------------+----------------------------------------------------+
| pthread_cond_init      | Cria uma variável de condição                      |
+------------------------+----------------------------------------------------+
| pthread_cond_destroy   | Destrói uma variável de condição                   |
+------------------------+----------------------------------------------------+
| pthread_cond_wait      | Espera em uma variável de condição                 |
+------------------------+----------------------------------------------------+
| pthread_cond_signal    | Libera um thread que está esperando em uma var.    |
+------------------------+----------------------------------------------------+



## ECiclo de Vida do Thread

 - Criação: A chamada pthread_create inicia um novo thread dentro do mesmo espaço de endereçamento do chamador.

 - Encerramento: Um thread finaliza sua execução voluntariamente através de pthread_exit.

 - Sincronização de Término: pthread_join permite que um thread aguarde a finalização de outro; se o alvo já encerrou, a função retorna imediatamente, caso contrário, o chamador bloqueia.spaço de Endereço Virtual (64 KB)

## Exclusão Mútua com Mutexes

 - Definição: Mutexes (exclusão mútua) funcionam como semáforos binários para proteger recursos compartilhados contra condições de disputa.

 - Estados: Um mutex pode estar travado ou destravado.

 - Fluxo de Bloqueio: Ao tentar travar um mutex já ocupado via pthread_mutex_lock, o thread bloqueia até que o recurso seja liberado por pthread_mutex_unlock.

 - Uso Ideal: São destinados à proteção de curto prazo, como o acesso a variáveis ou buffers compartilhados.

## Sincronização de Longo Prazo: Variáveis de Condição

 - Finalidade: Utilizadas para eventos que podem demorar (ex: aguardar a liberação de uma unidade de fita).

 - Operação: Um thread bloqueia em uma variável usando pthread_cond_wait.

 - Sinalização: O thread que detém o recurso sinaliza sua liberação via pthread_cond_signal, despertando exatamente um thread da fila de espera (se houver).

 - Diferença dos Semáforos: Ao contrário dos semáforos, se um sinal for enviado sem que haja threads esperando, o sinal é perdido.

## Como o Windows 7 lida com a execução paralela e a criação de processos, contrastando sua complexidade com o modelo UNIX.

Gerenciamento de Processos e Threads

 - Estrutura: O Windows 7 suporta múltiplos processos, sendo que cada processo deve conter, obrigatoriamente, ao menos um thread.

 - Paralelismo: A combinação de processos e threads permite gerenciar o paralelismo tanto em sistemas uniprocessadores quanto em multiprocessadores.

 - Escalonamento: Os threads podem ser escalonados pelo próprio processo.

## Criação de Processos: CreateProcess

Diferente do esquema simplificado do UNIX (com fork e exec), o Windows utiliza a função CreateProcess, que possui dez parâmetros detalhados:

1. Executável: Ponteiro para o nome do arquivo.

2. Linha de Comando: A string de comando bruta (não analisada).

3. Segurança do Processo: Ponteiro para o descritor de segurança do processo.

4. Segurança do Thread: Ponteiro para o descritor de segurança do thread inicial.

5. Herança: Um bit que define se o novo processo herda manipuladores (handles) do criador.

6. Sinalizadores: Opções diversas como prioridade, depuração e modo de erro.

7. Ambiente: Ponteiro para as cadeias de caracteres de ambiente.

8. Diretório: Nome do diretório de trabalho corrente.

9. Janela: Estrutura que descreve a aparência da janela inicial na tela.

10. Retorno: Estrutura que retorna 18 valores informativos para quem fez a chamada.

## Hierarquia e Criação de Processos e Threads

 - Hierarquia de Processos: O Windows 7 não impõe uma hierarquia pai-filho formal; todos os processos são criados iguais. No entanto, existe uma hierarquia implícita, pois o criador recebe um "manipulador" (handle) que permite controlar o novo processo.

 - Threads: Cada processo nasce com um único thread, podendo criar outros via CreateThread. Esta função é mais simples que a de processos, possuindo seis parâmetros: descritor de segurança, tamanho da pilha, endereço de início, parâmetro do usuário, estado inicial e ID do thread.

 - Gerenciamento pelo Núcleo: O núcleo (kernel) gerencia os threads e realiza o escalonamento focando apenas em threads executáveis, independentemente do processo ao qual pertencem. Como os threads são objetos de núcleo, seus manipuladores podem ser compartilhados entre processos, permitindo que um processo controle threads de outro.

## Comunicação entre Processos (IPC)

 - Pipes: Existem pipes normais e nomeados (estes últimos funcionam em rede). Ambos possuem dois modos: byte (fluxo contínuo como no UNIX) e mensagem (preserva as fronteiras dos dados escritos).

 - Soquetes e RPCs: Soquetes conectam processos em máquinas diferentes ou na mesma. Já as Chamadas Remotas de Procedimento (RPCs) permitem que um processo execute procedimentos no espaço de endereço de outro, exigindo que os dados sejam reunidos e enviados, já que ponteiros não são válidos entre processos.

 - Memória Compartilhada: Processos podem mapear o mesmo arquivo simultaneamente, tornando as escritas de um imediatamente visíveis para os outros.

## Mecanismos de Sincronização

 - O Windows oferece semáforos, mutexes, seções críticas e eventos, todos operando no nível de threads.

 - Semáforos: Criados via CreateSemaphore, possuem valor inicial e máximo. As operações de up e down são chamadas, respectivamente, de ReleaseSemaphore e WaitForSingleObject.

 - Mutexes: São objetos de núcleo mais simples que os semáforos, funcionando essencialmente como travas para exclusão mútua.

## Mecanismos de Sincronização no Windows 7

 - Mutexes: São objetos de núcleo que funcionam como travas simples, sem contadores. Utilizam WaitForSingleObject para travar e ReleaseMutex para destravar. Por serem objetos de núcleo, seus manipuladores podem ser duplicados e compartilhados entre diferentes processos.

 - Seções Críticas: Semelhantes aos mutexes, mas locais ao espaço de endereçamento do thread criador. Não são objetos de núcleo, portanto não possuem manipuladores e são muito mais rápidas, pois operam inteiramente no espaço do usuário através de EnterCriticalSection e LeaveCriticalSection.

 - Eventos: Objetos de núcleo usados para sinalização. Um thread pode esperar por um evento ou liberar outros usando SetEvent (libera um thread) ou PulseEvent (libera todos os threads em espera). São frequentemente usados para sincronizar o término de operações de E/S assíncronas.

 - Compartilhamento e Nomeação: Mutexes, semáforos e eventos podem ser nomeados e armazenados no sistema de arquivos. Isso permite que múltiplos processos sincronizem abrindo o mesmo objeto pelo nome, sem a necessidade de duplicar manipuladores manualmente.

## Resumo

     O sistema operacional pode ser considerado um intérprete para certas características de arquitetura não
encontradas no nível ISA. Entre as principais estão memória virtual, instruções de E/S virtual e facilidades de
processamento paralelo.

     Memória virtual é uma característica de arquitetura cuja finalidade é permitir que programas usem espaço
de endereço maior do que a memória física da máquina, ou proporcionar um mecanismo consistente e flexível
para proteção e compartilhamento de memória. Ela pode ser implementada como paginação pura, segmentação pura
ou uma combinação das duas. Na paginação pura, o espaço de endereço é desmembrado em páginas virtuais de
tamanhos iguais. Algumas delas são mapeadas para quadros de página físicos. Outras não são mapeadas. Uma refe-
rência a uma página mapeada é traduzida pela MMU para o endereço físico correto. Uma referência a uma página não
mapeada causa uma falta de página. Ambos, o Core i7 e a CPU ARM do OMAP4430, têm MMUs que suportam
memória virtual e paginação.

     A mais importante abstração de E/S presente nesse nível é a de arquivo. Um arquivo consiste em uma
sequência de bytes ou registros lógicos que podem ser lidos e escritos sem saber como discos, fitas e outros
dispositivos de E/S funcionam. Arquivos podem ser acessados em sequência, aleatoriamente por número de
registro, ou aleatoriamente por chave. Diretórios podem ser usados para agrupar arquivos. Arquivos podem ser
armazenados em setores consecutivos ou espalhados pelo disco. No último caso, normal em discos rígidos, são
necessárias estruturas de dados para localizar todos os blocos de um arquivo. O armazenamento livre em discos
pode ser monitorado usando uma lista ou um mapa de bits.

     Processamento paralelo geralmente é suportado e é implementado simulando múltiplos processadores que
compartilham tempo em uma única CPU. Interação não controlada entre processos pode levar a condições de
disputa. Para resolver esse problema, são introduzidas primitivas de sincronização, das quais os semáforos são um
exemplo simples. Usando semáforos, problemas de produtor-consumidor podem ser resolvidos com simplicidade
e elegância.

     Dois exemplos de sistemas operacionais sofisticados são UNIX e Windows 7. Ambos suportam paginação
e arquivos mapeados na memória. Também suportam sistemas hierárquicos de arquivos, sendo que os arqui-
vos consistem em sequências de bytes. Por fim, ambos suportam processos e threads e proporcionam meios de
sincronizá-los.


A Figura 6.3(b) mostra uma memória física que consiste em oito quadros de página de 4 KB. Essa memória
poderia ser limitada a 32 KB porque (1) isso é tudo que a máquina tinha (um processador embutido em uma
lavadora ou em um forno de micro-ondas poderia não precisar de mais), ou (2) o resto da memória foi alocado
a outros programas.

## 

- Agora, considere como um endereço virtual de 32 bits pode ser mapeado para um endereço físico de memória principal. Afinal, a única coisa que a memória entende são endereços de memória principal, e não endereços virtuais, portanto, são aqueles que lhe devem ser dado.

- Endereços virtuais (32 bits) precisam ser mapeados para endereços físicos pela MMU (Memory Management Unit).
- A MMU (Memory Management Unit – unidade de gerenciamento de memória), separa o endereço virtual em:

- Página virtual (20 bits): índice para a tabela de páginas.
- Deslocamento (12 bits): posição dentro da página.
- A tabela de páginas traduz a página virtual para um endereço físico.
- Se a página estiver na RAM (bit presente=1), a MMU forma o endereço físico.


Esta imagem descreve o mecanismo de Memória Virtual, onde o processador trabalha com endereços "imaginários" (virtuais) que precisam ser traduzidos para endereços "reais" (físicos) na memória RAM.

| Componente | Tamanho/Valor | Função no Hardware | Descrição |
| --- | --- | --- | --- |
| Endereço Virtual | 32 bits | Entrada do MMU | O endereço gerado pelo software (ex: seu código Java). 🌐 |
| Página Virtual | 20 bits (MSB) | Índice da Tabela | Identifica qual "bloco" de memória o programa quer acessar. 📑 |
| Deslocamento | 12 bits (LSB) | Offset Interno | Indica a posição exata dentro daquela página específica. 📍 |
| Tabela de Páginas | Mapeamento | Tradutor | Converte o número da página virtual em um endereço físico de 15 bits. 🔄 |
| Bit Presente | 1 (Sim) / 0 (Não) | Controle de Falta | Indica se a página está na RAM ou se precisa ser buscada no Disco. 💾 |

 📊 Diagrama de Fluxo: Tradução de Endereço
Abaixo está a representação visual de como os 32 bits se transformam nos 15 bits da Memória Principal, conforme a Figura 6.4:

Snippet de código
graph TD
    subgraph "Endereço Virtual (32 bits)"
        PV[Página Virtual: 20 bits]
        DESP[Deslocamento: 12 bits]
    end

    subgraph "Tabela de Páginas"
        TP[Índice da Tabela]
        BIT{Bit Presente?}
        BASE[Base da Página Física]
    end

    subgraph "Endereço Físico (15 bits)"
        REG_OUT[Página Física + Deslocamento]
    end

    PV --> TP
    TP --> BIT
    BIT -- "1 (Presente)" --> BASE
    BASE --> REG_OUT
    DESP --> REG_OUT
    BIT -- "0 (Ausente)" --> PF[Page Fault / Disco]

🧠 Como esse fluxo funciona no seu arquivo .md:

Entrada: O processador envia um endereço de 32 bits (Virtual).

Divisão: O hardware separa os 20 bits da esquerda (Página) dos 12 bits da direita (Deslocamento).

Consulta: Ele olha na Tabela de Páginas. Se o Bit Presente for 1, ele troca os 20 bits virtuais pelos 15 bits físicos.

Saída: O Deslocamento é "colado" ao novo endereço físico, gerando o local exato para o MAR (Memory Address Register) buscar o dado.

Processo da MMU:

1. Verifica se a página virtual está na memória (bit presente/ausente).
2. Se presente:
- Pega o número do quadro de página física (ex: 6).
- Combina com o deslocamento (12 bits do endereço virtual).
3. Gera endereço físico de 15 bits (3 bits do quadro + 12 bits de deslocamento).
4. Envia para a cache/memória.

- Página virtual 3 → Quadro 6 (física) + deslocamento → Endereço físico.


Tabela de Página (Páginas Virtuais)

| Página Virtual | Quadro de Página Físico | Presente/Ausente |

| --- | --- | --- |
| 15 | - | 0 |

| 14 | 4 | 1 |

| 13 | - | 0 |
| 12 | - | 0 |

| 11 | 5 | 1 |

| 10 | - | 0 |
| 9 | - | 0 |

| 8 | 3 | 1 |
| 7 | - | 0 |
| 6 | 7 | 1 |

| 5 | 6 | 1 |
| 4 | - | 0 |

| 3 | 2 | 1 |
| 2 | - | 0 |
| 1 | 0 | 1 |
| 0 | 1 | 1 |

- Presente (1): Página na memória principal.
- Ausente (0): Página não está na memória principal.

| Quadro de Página Físico | Página Virtual |
| --- | --- |
| 7 | 6 |
| 6 | 5 |
| 5 | 11 |
| 4 | 14 |
| 3 | 8 |
| 2 | 3 |
| 1 | 0 |
| 0 | 1 |


