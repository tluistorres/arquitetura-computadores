Arquitetura de Computadores: Subsistema de Memória
Para que o processador execute programas, dados e instruções devem estar armazenados na memória. O subsistema de memória é uma estrutura interligada que equilibra a alta velocidade das CPUs com a capacidade de armazenamento.

Curiosidade: Uma CPU manipula um dado em média em 5 ns, enquanto a memória principal transfere dados em cerca de 60 ns. Essa diferença justifica a existência da hierarquia.

1. Hierarquia de Memória
A hierarquia organiza as memórias de acordo com velocidade, capacidade e custo.

Tipo de Memória | Localização | É Volátil? | Velocidade | Capacidade de Armazenamento | Custo por bit ---|---|---|---|---|--- Registrador | Processador | Sim | Muito alta | Muito baixa (Bytes) | Muito alto Cache | Processador | Sim | Alta | Baixa (KB) | Alto Principal | Placa-mãe | RAM: Sim / ROM: Não | Rápida | Média (MB e GB) | Médio Secundária | HD, SSD, CD, etc. | Não | Baixa | Alta (GB e TB) | Baixo

Representação Visual (Pirâmide)

HIERARQUIA DE MEMÓRIA (ASCII)
      _______________________________
     /               ^               \
    /          [REGISTRADOR]          \  --+ PROCESSADOR
   /           [CACHE L1/L2]           \ --|
  /_____________________________________\  |
 /                                       \ |
/        [MEMÓRIA PRINCIPAL - RAM]        \| -- PLACA-MÃE
\_________________________________________/
 \                                       /
  \       [MEMÓRIA SECUNDÁRIA]          /
   \___________________________________/
           |               |
           v               v
   +---------------+   +---------------+
   |      HD       |   |   SSD / PEN   |
   | (Magnético)   |   |   (Flash)     |
   |  _______      |   |    _______    |
   | |  ( )  |     |   |   | [===] |   |
   | |___^___|     |   |   |_______|   |
   +---------------+   +---------------+

## Hierarquia de memórias

A imagem apresenta a hierarquia de memória, um conceito fundamental em arquitetura de computadores que organiza os tipos de memória de acordo com sua velocidade, capacidade e custo.

Níveis da hierarquia de memória (de cima para baixo na pirâmide):1. Registrador:
    - Características: alto custo, alta velocidade e baixa capacidade.
    - Função: Armazena dados temporários diretamente acessíveis pela CPU.

2. Memória cache:
    - Características: custo e velocidade intermediários, capacidade maior que registradores.
    - Função: Reduz o tempo de acesso aos dados frequentemente usados, armazenando cópias da memória principal.

3. Memória principal (RAM e ROM):
    - Características: custo moderado, velocidade média e capacidade significativa.
    - Função: Armazena programas e dados em execução (RAM) ou firmware (ROM).

4. Memória secundária ou de massa:
    - Exemplos: disco rígido, CD/DVD, pen-drive.
    - Características: baixo custo, baixa velocidade e alta capacidade.
    - Função: Armazenamento permanente de dados e programas não em uso.

Importância da hierarquia:- Otimização de desempenho: Prioriza o uso de memórias rápidas (registradores/cache) para dados críticos.
- Equilíbrio custo-benefício: Combina memórias caras e rápidas com outras mais baratas e lentas.


Detalhes para o seu .md
HD (Hard Disk): Utiliza tecnologia de armazenamento magnético com discos (platôs) e um braço atuador. Possui o menor custo por byte armazenado na pirâmide.

SSD / Pen Drive: Utilizam tecnologia eletrônica (Flash) sem partes móveis, o que os torna significativamente mais rápidos que os HDs convencionais.

Fluxo de Dados: Dispositivos secundários não possuem acesso direto pelo processador. Os dados devem ser carregados primeiro na Memória Principal (RAM) antes de serem processad

Tipo de Memória | Localização | É Volátil? | Velocidade | Capacidade de Armazenamento | Custo por bit
---|---|---|---|---|---
Registrador | Processador | Sim | Muito alta | Muito baixa (Bytes) | Muito alto
Cache | Processador | Sim | Alta | Baixa (KB) | Alto
Principal | Placa-mãe | RAM: Sim / ROM: Não | Rápida | Média (MB e GB) | Médio
Secundária | HD, SSD, CD, etc. | Não | Baixa | Alta (GB e TB) | Baixo

## Registradores

O processador busca dados e instruções de onde estiverem armazenadas e os deposita temporariamente em seu interior para realizar as operações solicitadas.

Os dispositivos denominados registradores são os locais onde esse conteúdo fica armazenado.

     O conceito de registrador surgiu da necessidade do processador de armazenar temporariamente dados intermediários durante um processaento.
      - Volátil        - Extremamento rápido           - Disponibilidade limitada

## Memória Cache

Considerando que o processador precisa buscar dados e instruções na memória principal (RAM) e que ele é bem mais rápido qua a RAM, surgiu a necessidade de ter uma memória auxiliar (cache).

A função da cache é acelerar a velocidade da transferência das informações entre processador e memória principal e, com isso, aumentar o desempenho dos sistemas de computação.
      - Volátil        - Muito rápida                   - Cache interna L1                  - Cache externa L2

## Detalhamento da Cache e Memória Principal
De acordo com o diagrama técnico da segunda imagem, a estrutura de memória mais próxima do processamento funciona da seguinte forma:

Cache Interna L1: Localizada dentro do processador, dividida em L1d (dados, 16 a 128 KB) e L1i (instruções, 16 a 64 KB).

Cache Externa L2: Utiliza tecnologia SRAM (Static Random Access Memory) com capacidade entre 2 a 8 MB.

Memória Principal: Utiliza tecnologia DRAM (Dynamic Random Access Memory) e serve como o próximo nível de busca para o processador quando os dados não estão na Cache.

_____________________________________________________
      |                     PROCESSADOR                     |
      |                                                     |
      |   +---------------------------------------------+   |
      |   |                     CPU                     |   |
      |   +---------------------------------------------+   |
      |             |                       |               |
      |             v                       v               |
      |   +-----------------------+ +-----------------------+       +-----------------------+
      |   |   Cache Interna L1d   | |   Cache Interna L1i   |------>|   Cache Externa L2    |
      |   |    (16 a 128 KB)      | |    (16 a 64 KB)       |       |      (2 a 8 MB)       |
      |   |        DADOS          | |     INSTRUÇÕES        |       |         SRAM          |
      |   +-----------------------+ +-----------------------+       +-----------------------+
      |_____________________________________________________|                   |
                                |                                               |
                                v                                               |
                  +-----------------------------------------+                   |
                  |            MEMÓRIA PRINCIPAL            |<------------------+
                  |                  DRAM                   |
                  +-----------------------------------------+

Resumo Técnico dos Componentes
L1d e L1i: Caches de primeiro nível integradas ao núcleo, separadas para evitar conflitos entre dados e instruções.

L2 (SRAM): Memória estática, mais rápida que a RAM comum, servindo de intermediária entre a L1 e a memória principal.

Memória Principal (DRAM): Memória dinâmica onde o processador busca informações quando não as encontra nas caches (Cache Miss).

## Memória principal

Memória indispensável para o funcionamento do computador, além de alocar os dados e instruções de progrmas, ela dá acesso às memórias secundárias.

A memória principal é denominada memória RAM (Random Access Memory), corresponde a um tipo de memória volátil.
      A memória RAM é denominada genericamente de DRAM (Dynamic RAM), ou RAM dinâmica, pelo fato de possuir uma característica chamada refrescamento de memória.

Pelo fato de precisar ser "refrescadas" ou realimentadas constantemente, as memórias DRAM consomem muitos ciclos do processador para a realimentação.

## Padrões de RAM e Clock
A memória DDR (Double Data Rate) permite a transferência de dois lotes de dados (64 bits por lote) em um único ciclo de clock, duplicando o desempenho em relação às tecnologias anteriores.

Frequência: Medida em Hertz (Hz). Um processador de 2 GHz executa 2 bilhões de ciclos por segundo.

Evolução: As gerações DDR2, DDR3 e DDR4 trazem melhorias contínuas em velocidade, latência e redução de voltagem.

Diagrama ASCII: Funcionamento do Clock DDR
O diferencial da tecnologia DDR é capturar dados tanto na subida quanto na descida do sinal de clock:

Sinal de Clock (Hz)
      +------+      +------+      +------+
      |      |      |      |      |      |
------+      +------+      +------+      +------
      ^      ^      ^      ^      ^      ^
      |      |      |      |      |      |
      |      |      |      |      |      |
    DADO   DADO   DADO   DADO   DADO   DADO
     (1)    (2)    (3)    (4)    (5)    (6)
    
    [Subida] [Descida] -> 2 Transferências por Ciclo

Tabela de Hierarquia de Memória (.md)
Conforme sua solicitação de formato personalizado, aqui está o resumo da hierarquia onde a RAM se encaixa:

Tipo de Memória | Localização | É Volátil? | Velocidade | Capacidade de Armazenamento | Custo por bit ---|---|---|---|---|--- Registrador | Processador | Sim | Muito alta | Muito baixa (Bytes) | Muito alto Cache | Processador | Sim | Alta | Baixa (KB) | Alto Principal | Placa-mãe | RAM: Sim / ROM: Não | Rápida | Média (MB e GB) | Médio Secundária | HD, SSD, CD, etc. | Não | Baixa | Alta (GB e TB) | Baixo

Detalhes Técnicos Adicionais
Cache L1 e L2: A Cache L1 é dividida em L1d (dados - 16 a 128 KB) e L1i (instruções - 16 a 64 KB). A Cache L2 é externa ao núcleo (mas geralmente no mesmo chip), usa tecnologia SRAM e possui entre 2 a 8 MB.

DRAM vs SRAM: A memória principal (RAM) utiliza tecnologia DRAM (Dynamic RAM), enquanto as memórias cache utilizam SRAM (Static RAM), que é mais rápida e cara.

## Formatos Físicos de Memória RAM
A diferença principal entre memórias para computadores de mesa e portáteis está no tamanho físico do módulo:

DIMM (Dual Inline Memory Module): Formato padrão utilizado em desktops.

SO-DIMM (Small Outline DIMM): Utilizado em laptops, possuindo aproximadamente metade do tamanho de um módulo DIMM convencional.

Funcionamento do Padrão DDR (Double Data Rate)
A tecnologia DDR permite que a memória transfira dados duas vezes por ciclo de clock (na subida e na descida do sinal), o que dobra o desempenho em relação ao padrão anterior.

Transferência: São transmitidos 64 bits por ciclo de clock.

Clock e Frequência: A frequência é medida em Hertz (Hz). Por exemplo, um processador de 2 GHz executa 2 bilhões de ciclos de clock por segundo.

Evolução: As gerações (DDR2, DDR3, DDR4) apresentam melhorias constantes em velocidade, redução de latência e menor consumo de voltagem.

## Memória ROM
Memória ROM (Read Only Memory): é uma memória somente leitura, ou seja, seu conteúdo é escrito uma vez e não é mais alterado, apenas consultado(não volátil).

É uma memória do tipo não volátil; os dados gravados não são perdidos na ausência de energia elétrica ao dispositivo.

Um software que é armazenado em uma memória ROM passa a ser chamado de firmware.

Armazena três programas principais:

BIOS (Basic Input Output System): ou Sistema Básico de Entrada e Saída.

POST (Power On Self Test): Autoteste – programa de verificação e teste que se executa após a ligação do computador.

SETUP: Programa que altera os parâmetros armazenados na memória de configuração.

## Memória Secundária
Também chamada de memória de massa, permite o armazenamento permanente (não volátil).

Apresenta o menor custo por byte armazenado por estar na base da pirâmide.

Acesso: Não possui acesso direto pelo processador; os dados precisam ser carregados na memória principal antes de serem enviados à CPU.

MEMÓRIA SECUNDÁRIA (NÃO VOLÁTIL)
      _________________________________
     |                                 |
     |   [ HARD DISK - HD ]            |
     |    _______                      |  - Armazenamento Magnético
     |   |  ( )  | <--- Disco/Platô    |  - Menor custo por byte
     |   |___^___| <--- Braço Atuador  |  - Base da Pirâmide
     |                                 |
     |_________________________________|
     |                                 |
     |   [ SSD / PEN DRIVE ]           |
     |    _______                      |  - Armazenamento Eletrônico (Flash)
     |   | [===] | <--- Chips de       |  - Sem partes móveis
     |   | [===] |      Memória        |  - Mais rápido que o HD
     |   |_______|                     |
     |      |_| <--- Conector USB      |
     |_________________________________|


