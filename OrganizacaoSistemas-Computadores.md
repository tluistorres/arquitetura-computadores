![alt text](image-61.png)

## Organização de sistemas de computadores

Um computador digital consiste em um sistema interconectado de processadores, memória e dispositi-
vos de entrada/saída. Este capítulo é uma introdução a esses três componentes e a sua interconexão,
como base para o exame mais detalhado de níveis específicos nos cinco capítulos subsequentes.
Processadores, memórias e dispositivos de entrada/saída são conceitos fundamentais e estarão presentes em
todos os níveis, portanto, iniciaremos nosso estudo da arquitetura de computadores examinando todos os três,
um por vez.

## 2.1 Processadores
A organização de um computador simples com barramento é mostrada na Figura 2.1. A CPU (Central Processing
Unit - unidade central de processamento) é o “cérebro” do computador. Sua função é executar programas armazenados
na memória principal buscando suas instruções, examinando-as e então executando-as uma após a outra. Os
componentes são conectados por um barramento, conjunto de fios paralelos que transmitem endereços, dados e sinais de
controle. Barramentos podem ser externos à CPU, conectando-a à memória e aos dispositivos de E/S, mas também
podem ser internos, como veremos em breve. Os computadores modernos possuem vários barramentos.

### Figura 2.1 A organização de um computador simples com uma CPU e dois dispositivos de E/S.

A Figura 2.1 é fundamental, pois ela resume a Organização de um Computador Simples baseada no modelo de Von Neumann, conectando a CPU, a Memória e os Periféricos através de um Barramento compartilhado.

    UNIDADE CENTRAL DE PROCESSAMENTO (CPU)
        +-----------------------------------------+
        |                                         |
        |   [ UNIDADE DE CONTROLE ]               |
        |                                         |
        |-----------------------------------------|
        |                                         |
        |   [ UNIDADE DE LÓGICA E ARITMÉTICA ]    |
        |               (ULA)                     |
        |                                         |
        |-----------------------------------------|
        |                                         |
        |   [ REGISTRADORES ]                     |
        |    +---+  +---+  +---+  +---+           |
        |    | R0|  | R1|  | R2|  | R3|           |
        |    +---+  +---+  +---+  +---+           |
        |                                         |
        +----+------------------------------------+
             |
     ========+=======+=======+=======+=======+=======  <-- BARRAMENTO DE DADOS/ENDEREÇOS
                     |       |       |
                +----+----+  |  +----+----+
                |         |  |  |         |
                | MEMÓRIA |  |  | DISCO   |
                | PRINCIP.|  |  | (E/S)   |
                |         |  |  |         |
                +---------+  |  +---------+
                             |
                        +----+----+
                        |         |
                        |IMPRESSO.|
                        | (E/S)   |
                        |         |
                        +---------+
![alt text](image-77.png)

    Processamento	                                    Armazenamento

    CPU (Unidade de Controle e ULA)             	    Registradores e Memória Principal

    A Unidade de Controle decodifica as instruções      Registradores: Armazenamento interno ultrarrápido na CPU (Nível 1). Memória 
    ULA (Figura 1.5) executa os cálculos aritméticos    Principal: Onde o Mapa de Memória reside (Figura 3.60).
    e lógicos.

                                                        BARRAMENTO DE DADOS/ENDEREÇOS

    Dispositivos de E/S (Periféricos)	                Ciclo de Execução

    O Disco e a Impressora se comunicam com a CPU       As instruções e dados viajam pelo Barramento da Memória para a CPU para através do barramento, usando interfaces como a     serem processados.
    PIO (Figura 3.59).

### Insight para seus Estudos
A organização vista na Figura 2.1 explica por que o seu "Projeto IDS" roda com tanta eficiência. Ferramentas como o iwatch e tcpdump dependem de um subsistema de E/S de baixa latência e de núcleos de processamento que consigam gerenciar dados em tempo real. No seu Lenovo IdeaPad, o barramento compartilhado foi substituído por conexões ponto-a-ponto rápidas (como o PCIe na Figura 3.57), mas a lógica de comunicação entre a CPU, Memória e Periféricos permanece a mesma.

A CPU é composta por várias partes distintas. A unidade de controle é responsável por buscar instruções na
memória principal e determinar seu tipo. A unidade de aritmética e lógica efetua operações como adição e AND (E)
booleano para executar as instruções.

A CPU também contém uma pequena memória de alta velocidade usada para armazenar resultados temporários e
para algum controle de informações. Essa memória é composta de uma quantidade de registradores, cada um deles com
determinado tamanho e função. Em geral, todos os registradores têm o mesmo tamanho. Cada um pode conter um
número, até algum máximo definido pelo tamanho do registrador. Registradores podem ser lidos e escritos em alta
velocidade porque são internos à CPU.

O registrador mais importante é o Contador de Programa (PC - Program Counter), que indica a próxima instrução a
ser buscada para execução. (O nome “contador de programa” é um tanto enganoso, porque nada tem a ver com contar
qualquer coisa; porém, o termo é de uso universal.) Também importante é o Registrador de Instrução (IR - Instruction
Register), que mantém a instrução que está sendo executada no momento em questão. A maioria dos computadores
também possui diversos outros registradores, alguns de uso geral, outros de uso específico. Outros registradores são
usados pelo sistema operacional para controlar o computador.

## 2.1.1 Organização da CPU
A organização interna de parte de uma típica CPU de von Neumann é mostrada na Figura 2.2 com mais detalhes.
Essa parte é denominada caminho de dados e é composta por registradores (em geral 1 a 32), da ULA (unidade lógica e
aritmética) e por diversos barramentos que conectam as partes. Os registradores alimentam dois registradores de entrada
da ULA, representados por A e B n a figura. Eles contêm a entrada da ULA enquanto ela está executando alguma
operação de computação. O caminho de dados é muito importante em todas as máquinas e nós o discutiremos
minuciosamente em todo este livro.

### Figura 2.2 0 caminho de dados de uma típica máquina de von Neumann.

A Figura 2.2 detalha o Caminho de Dados interno da CPU, mostrando como uma operação aritmética simples ( A + B) acontece fisicamente entre os registradores e a ULA.

        +---------------------------------------+
        |             REGISTRADORES             |
        |  +---------------------------------+  |
        |  |              A + B              |  | <---+
        |  +---------------------------------+  |     |
        |  |                A                |  |     | (Feedback)
        |  +---------------------------------+  |     |
        |  |                B                |  |     |
        |  +---------------------------------+  |     |
        +-------+-----------------------+-------+     |
                |                       |             |
                v                       v             |
        +---------------+       +---------------+     |
        | REG. ENTRADA  |       | REG. ENTRADA  |     |
        |  DA ULA (A)   |       |  DA ULA (B)   |     |
        +-------+-------+       +-------+-------+     |
                |                       |             |
                v                       v             |
        +---------------------------------------+     |
        |      UNIDADE DE LÓGICA E ARITMÉTICA   |     |
        |                 (ULA)                 |     |
        +-------------------+-------------------+     |
                            |                         |
                            v                         |
                +-----------------------+             |
                |  REG. SAÍDA DA ULA    |             |
                |        (A + B)        |-------------+
                +-----------------------+

![alt text](image-78.png)

    Processamento	                                               Armazenamento

    Ciclo da ULA	                                               Hierarquia de Registradores

    A ULA recebe os operandos dos registradores de entrada,        Os registradores (Nível 1) são a memória mais rápida do sistema, realiza a soma e coloca o resultado no registrador             servindo de fonte e destino imediato para a ULA.
    de saída.

                                                                   BARRAMENTO INTERNO

    Feedback de Dados	                                           Execução em Hardware

    O resultado (A+B) volta para o banco de registradores          Este processo é o que acontece bilhões de vezes por segundo 
    para ser usado em instruções futuras.                          dentro do seu Core i7.

### Insight 
Este diagrama é o "coração" do que você estuda em Assembly e C:

 - No seu Projeto IDS: Quando você faz uma comparação de endereços IP no seu código, a CPU move os valores para os Registradores de Entrada, a ULA subtrai um do outro para verificar a igualdade e o resultado define o próximo passo do seu firewall.

 - Eficiência: Como vimos na Figura 1.12, chips modernos têm múltiplos núcleos, cada um com seu próprio caminho de dados como este, permitindo processar milhões de pacotes simultaneamente no seu Ubuntu 24.04.

A ULA efetua adição, subtração e outras operações simples sobre suas entradas, produzindo assim um resultado no
registrador de saída, o qual pode ser armazenado em um registrador. Mais tarde, ele pode ser escrito (isto é, armazenado)
na memória, se desejado. Nem todos os projetos têm os registradores A, B e de saída. No exemplo, ilustramos uma adição,
mas as ULAs também realizam outras operações.

Grande parte das instruções pode ser dividida em uma de duas categorias: registrador-memória ou
registrador-registrador. Instruções registrador-memória permitem que palavras de memória sejam buscadas em
registradores, onde podem ser usadas como entradas de ULA em instruções subsequentes, por exemplo. (“Palavras” são
as unidades de dados movimentadas entre memória e registradores. Uma palavra pode ser um número inteiro.
Discutiremos organização de memória mais adiante neste capítulo.) Outras instruções registrador-memória permitem
que registradores voltem à memória para armazenagem.

O outro tipo de instrução é registrador-registrador. Uma instrução registrador-registrador típica busca dois
operandos nos registradores, traz os dois até os registradores de entrada da ULA, efetua alguma operação com eles (por
exemplo, adição ou AND booleano) e armazena o resultado em um dos registradores. O processo de passar dois
operandos pela ULA e armazenar o resultado é denominado ciclo do caminho de dados e é o coração da maioria das
CPUs. Até certo ponto considerável, ele define o que a máquina pode fazer. Quanto mais rápido for o ciclo do caminho de
dados, mais rápido será o funcionamento da máquina.

## 2.1.2 Execucõo de instrução
A CPU executa cada instrução em uma série de pequenas etapas. Em termos simples, as etapas são as seguintes:

    1. Trazer a próxima instrução da memória até o registrador de instrução.
    
    2. Alterar o contador de programa para que aponte para a próxima instrução.Capítulo 2 • Organização de sistemas de computadores
    
    3. Determinar o tipo de instrução trazida.
    
    4. Se a instrução usar uma palavra na memória, determinar onde essa palavra está.
    
    5. Trazer a palavra para dentro de um registrador da CPU, se necessário.
    
    6. Executar a instrução.
    
    7. Voltar à etapa 1 para iniciar a execução da instrução seguinte.

Tal sequência de etapas costuma ser denominada ciclo buscar-decodificar-executar. É fundamental para a operação
de todos os computadores.

Essa descrição do modo de funcionamento de uma CPU é muito parecida com um programa escrito em inglês. A
Figura 2.3 mostra esse programa informal reescrito como um método Java (isto é, um procedimento) denominado
interpret. A máquina que está sendo interpretada tem dois registradores visíveis para programas usuários: o contador de
programa (PC), para controlar o endereço da próxima instrução a ser buscada, e o acumulador (AC), para acumular
resultados aritméticos. Também tem registradores internos para conter a instrução corrente durante sua execução (instr),
o tipo da instrução corrente (instr_type), o endereço do operando da instrução (datajoc) e o operando corrente em si
(data). Admitimos que as instruções contêm um único endereço de memória. A localização de memória endereçada
contém o operando, por exemplo, o item de dado a ser somado ao acumulador.

### Figura 2.3 Interpretador para um computador simples (escrito em Java).

public class Interp {
    
    static int PC;                                       // contador de programa contém endereço da próxima instr
    static int AC;                                       // o acumulador , um registrador para efetuar aritmética
    static int instr;                                    // um registrador para conter a instrução corrente
    static int instr_type;                               // um tipo de instrução (opcode)
    static int data_loc;                                 // o endereço dos dados, ou -1 se nenhum
    static int data;                                     // mantém o operando corrente
    static boolean run_bit = true;                       // um bit que pode ser desligado para parar a máquina
    
                                                    
    public static void interpret(int memory[ ], int starting_ address) (
        // Esse procedimento interpreta programas para uma máquina simples com instruções que têm 
        // um operando na memória. A máquina tem um registrador AC (acumulador), usado para 
        // aritmética. A instrução ADD soma um inteiro na memória do AC, por exemplo.
        // 0 interpretador continua funcionando até o bit de funcionamento ser desligado pela instrução HALT. 
        // 0 estado de um processo que roda nessa máquina consiste em memória, o 
        // contador de programa, bit de funcionamento e AC. Os parâmetros de entrada consistem 
        // na imagem da memória e no endereço inicial.

    PC = starting_address; 
        while (run_bit) (
        instr = memory[PC];                                    // busca a próxima instrução e armazena em instr
        PC = PC + 1;                                           // incrementa contador do programa
        instr_type = get_instr_type(instr);                    // determina tipo de instrução
        data_loc = find_data(instr, instr_type);               // localiza dados (-1 se nenhum)
        if (data_loc >= 0)                                     // se data_loc é -1, não há nenhum operando
            data = memory [data_loc];                          // busca os dados
        execute(instr_type, data);                             // executa instrução
        }
    }
    private static int get_instr_type(int addr) ( . . . )
    private static int find_data(int instr, int type) ( . . . )
    private static void execute(int type, int data) ( . . . )

Essa equivalência entre processadores de hardware e interpretadores tem importantes implicações para a
organização de computadores e para o projeto de sistemas de computadores. Após a especificação da linguagem de
máquina, L, para um novo computador, a equipe de projeto pode decidir se quer construir um processador de hardware
para executar programas em L diretamente ou se quer escrever um interpretador para interpretar programas em L. Se a
equipe preferir escrever um interpretador, também deve providenciar alguma máquina de hardware para executá-lo. São
possíveis ainda certas construções híbridas, com um pouco de execução em hardware, bem como alguma interpretação de
software.

Um interpretador subdivide as instruções da máquina em questão em pequenas etapas. Por conseguinte, a máquina
na qual o interpretador roda deve ser muito mais simples e menos cara do que seria um processador de hardware para a
máquina citada. Essa economia é bastante significativa se a máquina em questão tiver um grande número de instruções e
estas forem razoavelmente complicadas, com muitas opções. Basicamente, a economia vem do fato de que o hardware
está sendo substituído por software (o interpretador) e custa mais reproduzir hardware do que software.

Os primeiros computadores tinham conjuntos de instruções pequenos, simples. Mas a procura por equipamentos
mais poderosos levou, entre outras coisas, a instruções individuais mais poderosas. Logo se descobriu que instruções
mais complexas muitas vezes levavam à execução mais rápida do programa mesmo que as instruções individuais
demorassem mais para ser executadas. Uma instruçáo de ponto flutuante é um exemplo de instrução mais complexa. O
suporte direto para acessar elementos matriciais é outro. Às vezes, isso era simples como observar que as mesmas duas
instruções muitas vezes ocorriam em sequência, de modo que uma única instrução poderia fazer o trabalho de ambas.

As instruções mais complexas eram melhores porque a execução de operações individuais às vezes podia ser
sobreposta ou então executada em paralelo usando hardware diferente. No caso de computadores caros, de alto
desempenho, o custo desse hardware extra poderia ser justificado de imediato. Assim, computadores caros, de alto
desempenho, passaram a ter mais instruções do que os de custo mais baixo. Contudo, requisitos de compatibilidade de
instruções e o custo crescente do desenvolvimento de software criaram a necessidade de executar instruções complexas
mesmo em computadores de baixo custo, nos quais o custo era mais importante do que a velocidade.

No final da década de 1950, a IBM (na época a empresa que dominava o setor de computadores) percebeu que
prestar suporte a uma única família de máquinas, todas executando as mesmas instruções, tinha muitas vantagens, tanto
para a IBM quanto para seus clientes. Então, a empresa introduziu o termo arquitetura para descrever esse nível de
compatibilidade. Uma nova família de computadores teria uma só arquitetura, mas muitas implementações diferentes
que poderiam executar o mesmo programa e seriam diferentes apenas em preço e velocidade. Mas como construir um
computador de baixo custo que poderia executar todas as complicadas instruções de máquinas caras, de alto
desempenho?

A resposta foi a interpretação. Essa técnica, que já tinha sido sugerida por Maurice Wilkes (1951), permitia o projeto
de computadores simples e de menor custo, mas que, mesmo assim, podiam executar um grande número de instruções. O
resultado foi a arquitetura IBM System/360, uma família de computadores compatíveis que abrangia quase duas ordens
de grandeza, tanto em preço quanto em capacidade. Uma implementação de hardware direto (isto é, não interpretado)
era usada somente nos modelos mais caros.
Computadores simples com instruções interpretadas também tinham outros benefícios, entre os quais os mais
importantes eram:

1.A capacidade de corrigir em campo instruções executadas incorretamente ou até compensar deficiências de
projeto no hardware básico.

2.A oportunidade de acrescentar novas instruções a um custo mínimo, mesmo após a entrega da máquina.

3.Projeto estruturado que permitia desenvolvimento, teste e documentação eficientes de instruções complexas.

À medida que o mercado explodia em grande estilo na década de 1970 e as capacidades de computação cresciam
depressa, a demanda por máquinas de baixo custo favorecia projetos de computadores que usassem interpretadores. A
capacidade de ajustar hardware e interpretador para um determinado conjunto de instruções surgiu como um projeto
muito eficiente em custo para processadores. À medida que a tecnologia subjacente dos semicondutores avançava, as
vantagens do custo compensavam as oportunidades de desempenho mais alto e as arquiteturas baseadas em
interpretador se tornaram o modo convencional de projetar computadores. Quase todos os novos computadores
projetados na década de 1970, de microcomputadores a mainframes, tinham a interpretação como base.

No final da década de 1970, a utilização de processadores simples que executavam interpretadores tinha se
propagado em grande escala, exceto entre os modelos mais caros e de desempenho mais alto, como o Cray-1 e a série
Cyber da Control Data. A utilização de um interpretador eliminava as limitações de custo inerentes às instruções
complexas, de modo que os projetistas começaram a explorar instruções muito mais complexas, em particular os modos
de especificar os operandos a utilizar.

A tendência alcançou seu ponto mais alto com o VAX da Digital Equipment Corporation, que tinha várias centenas
de instruções e mais de 200 modos diferentes de especificar os operandos a serem usados em cada instrução. Infelizmente,
desde o início a arquitetura do VAX foi concebida para ser executada com um interpretador, sem dar muita atenção à
realização de um modelo de alto desempenho. Esse modo de pensar resultou na inclusão de um número muito grande de
instruções de valor marginal e que eram difíceis de executar diretamente. Essa omissão mostrou ser fatal para o VAX e,
por fim, também para a DEC (a Compaq comprou a DEC em 1998 e a Hewlett-Packard comprou a Compaq em 2001).

Embora os primeiros microprocessadores de 8 bits fossem máquinas muito simples com conjuntos de instruções
muito simples, no final da década de 1970 até os microprocessadores tinham passado para projetos baseados em
interpretador. Durante esse período, um dos maiores desafios enfrentados pelos projetistas de microprocessadores era
lidar com a crescente complexidade, possibilitada por meio de circuitos integrados. Uma importante vantagem do
método baseado em interpretador era a capacidade de projetar um processador simples e confinar quase toda a
complexidade na memória que continha o interpretador. Assim, um projeto complexo de hardware se transformou em
um projeto complexo de software.

O sucesso do Motorola 68000, que tinha um grande conjunto de instruções interpretadas, e o concomitante fracasso
do Zilog Z8000 (que tinha um conjunto de instruções tão grande quanto, mas sem um interpretador) demonstraram as
vantagens de um interpretador para levar um novo microprocessador rapidamente ao mercado. Esse sucesso foi ainda
mais surpreendente dada a vantagem de que o Zilog desfrutava (o antecessor do Z8000, o Z80, era muito mais popular do
que o antecessor do 68000, o 6800). Claro que outros fatores também contribuíram para isso, e um dos mais importantes
foi a longa história da Motorola como fabricante de chips e a longa história da Exxon (proprietária da Zilog) como
empresa de petróleo, e não como fabricante de chips.

Outro fator a favor da interpretação naquela época foi a existência de memórias rápidas somente de leitura,
denominadas memórias de controle, para conter os interpretadores. Suponha que uma instrução interpretada típica
precisasse de 10 instruções do interpretador, denominadas microinstruções, a 100 ns cada, e duas referências à memória
principal a 500 ns cada. Então, o tempo total de execução era 2.000 ns, apenas um fator de dois pior do que o melhor que a
execução direta podia conseguir. Se a memória de controle não estivesse disponível, a instrução levaria 6.000 ns. Uma
penalidade de fator seis é muito mais difícil de aceitar do que uma penalidade de fator dois.

## 2.1.1 RISC versus CISC
Durante o final da década de 1970, houve experiências com instruções muito complexas que eram possibilitadas
pelo interpretador. Os projetistas tentavam fechar a “lacuna semântica” entre o que as máquinas podiam fazer e o que as
linguagens de programação de alto nível demandavam. Quase ninguém pensava em projetar máquinas mais simples,
exatamente como agora não há muita pesquisa na área de projeto de planilhas, redes, servidores Web etc. menos
poderosos (o que talvez seja lamentável).

Um grupo que se opôs à tendência e tentou incorporar algumas das idéias de Seymour Cray em um minicom-
putador de alto desempenho foi liderado por John Cocke na IBM. Esse trabalho resultou em um minicomputador
denominado 801. Embora a IBM nunca tenha lançado essa máquina no mercado e os resultados tenham sido publicados
só muitos anos depois (Radin, 1982), a notícia vazou e outros começaram a investigar arquiteturas semelhantes.

Em 1980, um grupo em Berkeley, liderado por David Patterson e Cario Séquin, começou a projetar chips para CPUs
VLSI que não usavam interpretação (Patterson, 1985; Patterson e Séquin, 1982). Eles cunharam o termo RISC para esse
conceito e deram ao seu chip de CPU o nome RISC I CPU, seguido logo depois pelo RISC II. Um pouco mais tarde, em
1981, do outro lado da baía de São Francisco, em Stanford, John Hennessy projetou e fabricou um chip um pouco
diferente, que ele chamou de MIPS (Hennessy, 1984). Esses chips evoluíram para produtos de importância comercial, o
SPARC e o MIPS, respectivamente.

Esses novos processadores tinham diferenças significativas em relação aos que havia no comércio naquela época.
Uma vez que essas novas CPUs não eram compatíveis com os produtos existentes, seus projetistas tinham liberdade para
escolher novos conjuntos de instruções que maximizassem o desempenho total do sistema. Embora a ênfase inicial
estivesse dirigida a instruções simples, que podiam ser executadas rapidamente, logo se percebeu que projetar instruções
que podiam ser emitidas (iniciadas) rapidamente era a chave do bom desempenho. Na verdade, o tempo que uma
instrução demorava importava menos do que quantas delas podiam ser iniciadas por segundo.

Na época em que o projeto desses processadores simples estava no início, a característica que chamou a atenção de
todos era o número relativamente pequeno de instruções disponíveis, em geral cerca de 50. Esse número era muito menor
do que as 200 a 300 de computadores como o VAX da DEC e os grandes mainframes da IBM. De fato, o acrônimo RISC quer
dizer Reduced Instruction Set Computer (computador com conjunto de instruções reduzido), em comparação com CISC,
que significa Complex Instruction Set Computer (computador com conjunto de instruções complexo), uma referência
nada sutil ao VAX que, na época, dominava os departamentos de ciência da computação das universidades. Hoje em dia,
poucas pessoas acham que o tamanho do conjunto de instruções seja um assunto importante, mas o nome pegou.

Encurtando a história, seguiu-se uma grande guerra santa, com os defensores do RISC atacando a ordem
estabelecida (VAX, Intel, grandes mainframes da IBM). Eles afirmavam que o melhor modo de projetar um computador era
ter um pequeno número de instruções simples que executassem em um só ciclo do caminho de dados da Figura 2.2, ou
seja, buscar dois registradores, combiná-los de algum modo (por exemplo, adicionando-os ou fazendo AND) e armazenar
o resultado de volta em um registrador. O argumento desses pesquisadores era de que, mesmo que uma máquina RISC
precisasse de quatro ou cinco instruções para fazer o que uma CISC fazia com uma só, se as instruções RISC fossem dez
vezes mais rápidas (porque não eram interpretadas), o RISC vencia. Também vale a pena destacar que, naquele tempo, a
velocidade de memórias principais tinha alcançado a velocidade de memórias de controle somente de leitura, de modo
que a penalidade imposta pela interpretação tinha aumentado demais, o que favorecia muito as máquinas RISC.

Era de imaginar que, dadas as vantagens de desempenho da tecnologia RISC, as máquinas RISC (como a Sun
UltraSPARC) passariam como rolo compressor sobre as máquinas CISC (tal como a Pentium da Intel) existentes no
mercado. Nada disso aconteceu. Por quê?

Antes de tudo, há a questão da compatibilidade e dos bilhões de dólares que as empresas tinham investido em
software para a linha Intel. Em segundo lugar, o que era surpreendente, a Intel conseguiu empregar as mesmas idéias
mesmo em uma arquitetura CISC. A partir do 486, as CPUs da Intel contêm um núcleo RISC que executa as instruções
mais simples (que normalmente são as mais comuns) em um único ciclo do caminho de dados, enquanto interpreta as
mais complicadas no modo CISC de sempre. O resultado disso é que as instruções comuns são rápidas e as menos comuns
são lentas. Mesmo que essa abordagem híbrida não seja tão rápida quanto um projeto RISC puro, ela resulta em
desempenho global competitivo e ainda permite que softwares antigos sejam executados sem modificação.

## 2.1.2 Princípios de projeto para computadores modernos
Agora que já se passaram mais de duas décadas desde que as primeiras máquinas RISC foram lançadas, certos
princípios de projeto passaram a ser aceitos como um bom modo de projetar computadores, dado o estado atual da
tecnologia de hardware. Se ocorrer uma importante mudança na tecnologia (por exemplo, se, de repente, um novo
processo de fabricação fizer o ciclo de memória ficar dez vezes mais rápido do que o tempo de ciclo da CPU), todas as
apostas perdem. Assim, os projetistas de máquinas devem estar sempre de olho nas mudanças tecnológicas que possam
afetar o equilíbrio entre os componentes.

Dito isso, há um conjunto de princípios de projeto, às vezes denominados princípios de projeto RISC, que os
arquitetos de CPUs de uso geral se esforçam por seguir. Limitações externas, como a exigência de compatibilidade com
alguma arquitetura existente, muitas vezes exigem uma solução de conciliação de tempos em tempos, mas esses
princípios são metas que a maioria dos projetistas se esforça para cumprir. A seguir, discutiremos os principais.

**• Todas as instruções são executadas diretamente por hardware**

Todas as instruções comuns são executadas diretamente pelo hardware - não são interpretadas por micro-
instruções. Eliminar um nível de interpretação dá alta velocidade à maioria das instruções. No caso de computadores que
executam conjuntos de instruções CISC, as instruções mais complexas podem ser subdivididas em partes separadas que
então podem ser executadas como uma sequência de microinstruções. Essa etapa extra torna a máquina mais lenta,
porém, para instruções que ocorrem com menos frequência, isso pode ser aceitável.

**• Maximize a taxa de execucão das instruções**

Computadores modernos recorrem a muitos truques para maximizar seu desempenho, entre os quais o principal é
tentar iniciar o máximo possível de instruções por segundo. Afinal, se você puder emitir 500 milhões de instruções por
segundo, terá construído um processador de 500 MIPS, não importa quanto tempo elas realmente levem para ser
concluídas. (MIPS quer dizer Milhões de Instruções Por Segundo. O processador MIPS recebeu esse nome como um
trocadilho desse acrônimo. Oficialmente, ele significa Microprocessor without Interlocked Pipeline Stages -
microprocessador sem estágios paralelos de interbloqueio.) Esse princípio sugere que o paralelismo pode desempenhar
um importante papel na melhoria do desempenho, uma vez que emitir grandes quantidades de instruções lentas em curto
intervalo de tempo só é possível se várias instruções puderem ser executadas ao mesmo tempo.

Embora as instruções sempre sejam encontradas na ordem do programa, nem sempre elas são executadas nessa
mesma ordem (porque algum recurso necessário pode estar ocupado) e não precisam terminar na ordem do programa. É
claro que, se a instrução 1 estabelece um registrador e a instrução 2 usa esse registrador, deve-se tomar muito cuidado
para garantir que a instrução 2 não leia o registrador até que ele contenha o valor correto. Fazer isso funcionar direito
requer muito controle, mas possibilita ganhos de desempenho por executar várias instruções ao mesmo tempo.

**• Instruções devem ser fáceis de decodificar**

Um limite crítico para a taxa de emissão de instruções é a decodificação de instruções individuais para determinar
quais recursos elas necessitam. Qualquer coisa que possa ajudar nesse processo é útil. Isso inclui fazer instruções
regulares, de comprimento fixo, com um pequeno número de campos. Quanto menor o número de formatos diferentes
para as instruções, melhor.

**• Somente LOAD e STORE devem referenciar a memória**

Um dos modos mais simples de subdividir operações em etapas separadas é requerer que os operandos para a
maioria das instruções venham de registradores da CPU e a eles retornem. A operação de movimentação de operandos da
memória para registradores pode ser executada em instruções separadas. Uma vez que o acesso à memória pode levar um longo tempo, e que o atraso é imprevisível, o melhor é sobrepor essas instruções a outras se elas
nada fizerem exceto movimentar operandos entre registradores e memória. Essa observação significa que somente
instruções LOAD e STORE devem referenciar a memória. Todas as outras devem operar apenas em registradores.

**• Providencie muitos registradores**

Visto que o acesso à memória é relativamente lento, é preciso providenciar muitos registradores (no mínimo, 32) de
modo que, assim que uma palavra for buscada, ela possa ser mantida em um registrador até não ser mais necessária.
Esgotar os registradores e ter de descarregá-los de volta à memória só para ter de recarregá-los mais tarde é indesejável e
deve ser evitado o máximo possível. A melhor maneira de conseguir isso é ter um número suficiente de registradores.

## 2.1.3 Paralelismo no nível de instrução
Arquitetos de computadores estão sempre se esforçando para melhorar o desempenho das máquinas que projetam.
Fazer os chips funcionarem com maior rapidez aumentando suas velocidades de clock é um modo, mas, para cada novo
projeto, há um limite para o que é possível fazer por força bruta naquele momento da História. Por conseguinte, grande
parte dos arquitetos de computadores busca o paralelismo (fazer duas ou mais coisas ao mesmo tempo) como um meio de
conseguir desempenho ainda melhor para dada velocidade de clock.

O paralelismo tem duas formas gerais, a saber, no nível de instrução e no nível de processador. Na primeira, o
paralelismo é explorado dentro de instruções individuais para obter da máquina mais instruções por segundo. Na última,
várias CPUs trabalham juntas no mesmo problema. Cada abordagem tem seus próprios méritos. Nesta seção, vamos
estudar o paralelismo no nível de instrução; na seção seguinte, estudaremos o paralelismo no nível de processador.

**• Pipelining (paralelismo)**

Há anos sabe-se que o processo de buscar instruções na memória é um grande gargalo na velocidade de execução da
instrução. Para amenizar esse problema, os computadores, desde o IBM Stretch (1959), tinham a capacidade de buscar
instruções na memória antecipadamente, de maneira que estivessem presentes quando necessárias. Essas instruções eram
armazenadas em um conjunto de registradores denominado buffer de busca antecipada (ou prefetch buffer). Desse modo,
quando necessária, uma instrução podia ser apanhada no buffer de busca antecipada, em vez de esperar pela conclusão de
uma leitura da memória.

Na verdade, a busca antecipada divide a execução da instrução em duas partes: a busca e a execução propriamente
dita. O conceito de pipeline (paralelismo, canalização) amplia muito mais essa estratégia. Em vez de dividir a execução da
instrução em apenas duas partes, muitas vezes ela é dividida em muitas partes (uma dúzia ou mais), cada uma
manipulada por uma parte dedicada do hardware, e todas elas podem executar em paralelo.

A Figura 2.4(a) ilustra um pipeline com cinco unidades, também denominadas estágios. O estágio 1 busca a instrução
na memória e a coloca em um buffer até que ela seja necessária. O estágio 2 decodifica a instrução, determina seu tipo e de
quais operandos ela necessita. O estágio 3 localiza e busca os operandos, seja nos registradores, seja na memória. O estágio
4 é que realiza o trabalho de executar a instrução, normalmente fazendo os operandos passarem pelo caminho de dados
da Figura 2.2. Por fim, o estágio 5 escreve o resultado de volta no registrador adequado.

### Figura 2.4 (a) Pipeline de cinco estágios, (b) Estado de cada estágio como uma função do tempo. São ilustrados nove ciclos de clock.

Essa é uma das ilustrações mais clássicas para entender como a CPU consegue processar tantas informações ao mesmo tempo. A Figura 2.4 explica o conceito de Pipeline, que é basicamente a "linha de montagem" do processador.

Em vez de esperar uma instrução terminar completamente para começar a próxima, a CPU divide o trabalho em estágios. Assim que o estágio 1 termina para a "Instrução A", ele já começa a trabalhar na "Instrução B", enquanto a "A" segue para o estágio 2.

### Figura 2.4: Pipeline de Cinco Estágios

    (a) Os Estágios do Pipeline

       S1             S2             S3             S4             S5
    +---------+      +---------+      +---------+      +---------+      +---------+
    | Unidade |      | Unidade |      | Unidade |      | Unidade |      | Unidade |
    |  Busca  |----->|  Decod. |----->|  Busca  |----->|  Exec.  |----->|  Grav.  |
    |  Instr. |      |  Instr. |      |  Oper.  |      |  Instr. |      |  Resul. |
    +---------+      +---------+      +---------+      +---------+      +---------+

    (b) Fluxo de Instruções no Tempo

    ESTÁGIO | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |  <-- Ciclos de Clock
    --------+---+---+---+---+---+---+---+---+---+
    S1    | I1| I2| I3| I4| I5| I6| I7| I8| I9|
    S2    |   | I1| I2| I3| I4| I5| I6| I7| I8|
    S3    |   |   | I1| I2| I3| I4| I5| I6| I7|
    S4    |   |   |   | I1| I2| I3| I4| I5| I6|
    S5    |   |   |   |   | I1| I2| I3| I4| I5|

### Insight 
O Pipeline é o segredo da velocidade do seu Lenovo IdeaPad:

 - Eficiência no C: Quando você compila seu "Projeto IDS", o compilador tenta organizar as instruções para evitar "bolhas" (pausas) no pipeline. Se uma instrução depende do resultado da anterior, o pipeline pode travar por um ciclo.

 - No seu Ubuntu 24.04: O kernel gerencia o contexto de execução, mas é o hardware (Figura 1.12) que mantém esse fluxo constante para garantir que a análise de pacotes do seu IDS ocorra sem atrasos.


Na Figura 2.4(b), vemos como o pipeline funciona em função do tempo. Durante o ciclo de clock 1, o estágio SI está
trabalhando na instrução 1, buscando-a na memória. Durante o ciclo 2, o estágio S2 decodifica a instrução 1, enquanto o
estágio SI busca a instrução 2. Durante o ciclo 3, o estágio S3 busca os operandos para a instrução 1, o estágio S2 decodifica a instrução 2 e o estágio SI busca a terceira instrução. Durante o ciclo 4, o estágio S4 executa a instrução 1, S3 busca os operandos para a instrução 2, S2 decodifica a instrução 3 e SI busca a instrução 4. Por fim, durante o ciclo 5, S5 escreve (grava) o resultado da instrução 1 de volta ao registrador, enquanto os outros estágios trabalham nas instruções seguintes.

Vamos considerar uma analogia para esclarecer melhor o conceito de pipelining. Imagine uma fábrica de bolos na
qual a operação de produção dos bolos e a operação da embalagem para expedição são separadas. Suponha que o
departamento de expedição tenha uma longa esteira transportadora ao longo da qual trabalham cinco funcionários
(unidades de processamento). A cada 10 segundos (o ciclo de clock), o funcionário 1 coloca uma embalagem de bolo vazia
na esteira. A caixa é transportada até o funcionário 2, que coloca um bolo dentro dela. Um pouco mais tarde, a caixa chega
à estação do funcionário 3, onde é fechada e selada. Em seguida, prossegue até o funcionário 4, que coloca uma etiqueta
na embalagem. Por fim, o funcionário 5 retira a caixa da esteira e a coloca em um grande contêiner que mais tarde será
despachado para um supermercado. Em termos gerais, esse é o modo como um pipeline de computador também funciona:
cada instrução (bolo) passa por diversos estágios de processamento antes de aparecer já concluída na extremidade final.

Voltando ao nosso pipeline da Figura 2.4, suponha que o tempo de ciclo dessa máquina seja 2 ns. Sendo assim, uma
instrução leva 10 ns para percorrer todo o caminho do pipeline de cinco estágios. À primeira vista, como uma instrução
demora 10 ns, parece que a máquina poderia funcionar em 100 MIPS, mas, na verdade, ela funciona muito melhor do que
isso. A cada ciclo de clock (2 ns), uma nova instrução é concluída, portanto, a velocidade real de processamento é 500
MIPS, e não 100 MIPS.


O pipelining permite um compromisso entre latência (o tempo que demora para executar uma instrução) e largura de
banda de processador (quantos MIPS a CPU tem). Com um tempo de ciclo de T ns e n estágios no pipeline, a latência é nT
ns porque cada instrução passa por n estágios, cada um dos quais demora T ns.

Visto que uma instrução é concluída a cada ciclo de clock e que há 109/T ciclos de clock por segundo, o número de
instruções executadas por segundo é 107T. Por exemplo, se T = 2 ns, 500 milhões de instruções são executadas a cada
segundo. Para obter o número de MIPS, temos de dividir a taxa de execução de instrução por 1 milhão para obter
(109/T)/106 = 1.000/T MIPS. Em teoria, poderiamos medir taxas de execução de instrução em BIPS em vez de MIPS, mas
ninguém faz isso, portanto, nós também não o faremos.

**• Arquiteturas superescalares**

Se um pipeline é bom, então certamente dois pipelines são ainda melhores. Um projeto possível para uma CPU com
dois pipelines, com base na Figura 2.4, é mostrado na Figura 2.5. Nesse caso, uma única unidade de busca de instruções
busca pares de instruções ao mesmo tempo e coloca cada uma delas em seu próprio pipeline, completo com sua própria
ULA para operação paralela. Para poder executar em paralelo, as duas instruções não devem ter conflito de utilização de
recursos (por exemplo, registradores) e nenhuma deve depender do resultado da outra. Assim como em um pipeline
único, ou o compilador deve garantir que essa situação aconteça (isto é, o hardware não verifica e dá resultados incorretos
se as instruções não forem compatíveis), ou os conflitos deverão ser detectados e eliminados durante a execução usando
hardware extra.

#### Figura 2.5 Pipelines duplos de cinco estágios com uma unidade de busca de instrução em comum.

A Figura 2.5 leva o conceito de pipeline um passo adiante, introduzindo os Pipelines Duplos. Enquanto o pipeline simples (Figura 2.4) foca em processar uma instrução por estágio, esta arquitetura permite que a CPU execute duas instruções simultaneamente usando uma única unidade de busca em comum.

                     S2              S3              S4              S5
               +---------------+---------------+---------------+---------------+
               | Unid. Decodif.| Unid. Busca   | Unid. Execução| Unid. de      |
          +--->| de Instrução  | de Operando   | de Instrução  | Gravação      |
          |    +---------------+---------------+---------------+---------------+
    +-----+-----+
    | Unidade de|
    | Busca de  |   S1
    | Instrução |
    +-----+-----+
          |    +---------------+---------------+---------------+---------------+
          +--->| Unid. Decodif.| Unid. Busca   | Unid. Execução| Unid. de      |
               | de Instrução  | de Operando   | de Instrução  | Gravação      |
               +---------------+---------------+---------------+---------------+
                     S2              S3              S4              S5

    Processamento	                                               Armazenamento

    Arquitetura Superescalar	                                   Vazão Duplicada (Throughput)

    A CPU pode iniciar e concluir duas instruções por ciclo        Exige um banco de registradores (Figura 2.2) com mais portas de de clock, desde que não haja dependências entre elas.          leitura/escrita para suportar o acesso simultâneo dos dois 
                                                                   caminhos.

                                                                   BARRAMENTO INTERNO

    Unidade de Busca Comum (S1)	                                   Lógica de Conflito

    Uma única unidade busca as instruções na Memória (Figura 2.1)  Se a segunda instrução depender da primeira, o hardware deve   as distribui para os dois pipelines paralelos.                 detectar o conflito e pausar o segundo pipeline.

### Insight 
Esta arquitetura é o que transformou CPUs simples em processadores de alto desempenho:

 - No seu Lenovo IdeaPad: Processadores modernos (como o seu Core i7) são muito mais complexos que isso, possuindo pipelines que podem ter 14 estágios ou mais e emitir até 6 instruções por ciclo.

 - Impacto no seu Código: Quando você escreve em C/C++, o compilador tenta "desenrolar" loops (loop unrolling) para que as instruções possam preencher ambos os pipelines da Figura 2.5, dobrando a velocidade de execução do seu Projeto IDS sem aumentar o clock.

Embora pipelines, simples ou duplos, sejam usados em sua maioria em máquinas RISC (o 386 e seus
antecessores não tinham nenhum), a partir do 486 a Intel começou a acrescentar pipelines de dados em
suas CPUs. O 486 tinha um pipeline e o Pentium original tinha pipelines de cinco estágios mais ou menos
como os da Figura 2.5, embora a exata divisão do trabalho entre os estágios 2 e 3 (denominados decode-1 e
decode-2) era ligeiramente diferente do que em nosso exemplo. O pipeline principal, denominado pipeline u,
podia executar uma instrução Pentium qualquer. O segundo, denominado pipeline v, podia executar apenas
instruções com números inteiros (e também uma instrução simples de ponto flutuante – FXCH).

Regras fixas determinavam se um par de instruções era compatível e, portanto, se elas podiam ser exe-
cutadas em paralelo. Se as instruções em um par não fossem simples o suficiente ou se fossem incompatíveis,
somente a primeira era executada (no pipeline u). A segunda era retida para fazer par com a instrução seguin-
te. Instruções eram sempre executadas em ordem. Assim, os compiladores específicos para Pentium que
produziam pares compatíveis podiam produzir programas de execução mais rápidos do que compiladores
mais antigos. Medições mostraram que um código de execução Pentium otimizado para ele era exatamente
duas vezes mais rápido para programas de inteiros do que um 486 que executava à mesma velocidade de
clock (Pountain, 1993). Esse ganho podia ser atribuído inteiramente ao segundo pipeline.

Passar para quatro pipelines era concebível, mas exigiria duplicar muito hardware (cientistas da compu-
tação, ao contrário de especialistas em folclore, não acreditam no número três). Em vez disso, uma aborda-
gem diferente é utilizada em CPUs de topo de linha. A ideia básica é ter apenas um único pipeline, mas lhe
dar várias unidades funcionais, conforme mostra a Figura 2.6. Por exemplo, a arquitetura Intel Core tem uma
estrutura semelhante à dessa figura, que será discutida no Capítulo 4. O termo arquitetura superescalar foi
cunhado para essa técnica em 1987 (Agerwala e Cocke, 1987). Entretanto, suas raízes remontam a mais de
40 anos, ao computador CDC 6600. O 6600 buscava uma instrução a cada 100 ns e a passava para uma das
10 unidades funcionais para execução paralela enquanto a CPU saía em busca da próxima instrução.

### Figura 2.6 Processador superescalar com cinco unidades funcionais.

A Figura 1.12 e a 1.14 mostram a implementação física dessas arquiteturas, enquanto a Figura 2.5 detalha a lógica de processamento paralelo.

Figura 1.12: Anatomia do Intel Core i7-3960X 
Este chip de 2011 é um exemplo clássico de processador de alto desempenho com múltiplos núcleos e cache compartilhada.

    +-----------------------------------------------------------+
    |          Fila, Uncore & Entrada/Saída (E/S)               |
    +-----------+-----------------------------------+-----------+
    |  NÚCLEO   |                                   |  NÚCLEO   |
    +-----------+       CACHE L3 COMPARTILHADO      +-----------+
    |  NÚCLEO   |                                   |  NÚCLEO   |
    +-----------+     (Onde os dados ficam prontos  +-----------+
    |  NÚCLEO   |      para acesso ultra-rápido)    |  NÚCLEO   |
    +-----------+                                   +-----------+
    |                 CONTROLADOR DE MEMÓRIA                    |
    +-----------------------------------------------------------+

Figura 1.14: Sistema Nvidia Tegra 2 (SoC)
Diferente do i7, o Tegra 2 é um System on a Chip, integrando funções multimídia e de rede no mesmo silício.

    +-----------------------------------------------------------+
    | [ Proc. Sinal Imagem ]  [ Proc. Codificação Vídeo ] [CACHE]|
    |                         [ Proc. Decodif. Vídeo    ] [CPU A7]|
    +-----------------------+---------------------------+-------+
    |                       |                           |  CPU  |
    | [ Proc. Áudio ]       |          E / S            | CORTEX|
    |                       |        (Entrada           |  A9   |
    +-----------------------+           e               +-------+
    | [ Video Dual ]        |         Saída)            |  CPU  |
    |                       |                           | CORTEX|
    +-------+-------+-------+-----------+---------------+  A9   |
    | HDMI  | NAND  |  USB  |           | [ Proc. Gráfico ]     |
    +-------+-------+-------+-----------+-----------------------+

Figura 2.6: Processador Superescalar
Este diagrama ilustra a lógica interna (estágios S1 a S5) que permite que o seu processador execute múltiplas operações simultaneamente através de unidades funcionais dedicadas.

    [S1]         [S2]         [S3]           [S4]           [S5]
    +--------+   +--------+   +--------+   +-------------+  +--------+
    | Unid.  |   | Unid.  |   | Unid.  |   |    ULA 1    |  |        |
    | busca  |-->| decod. |-->| busca  |-->+-------------+  | Unid.  |
    | instr. |   | instr. |   | oper.  |   |    ULA 2    |  | gravação|
    +--------+   +--------+   +--------+   +-------------+  |        |
                                    |        |    LOAD     |  | (Resul.)|
                                    |        +-------------+  |        |
                                    |        |    STORE    |  |        |
                                    |        +-------------+  |        |
                                    |        |  Pto. Flut. |  |        |
                                    |        +-------------+  +--------+

![alt text](image-79.png)

    Mapeamento Técnico para o seu Repositório

    Arquitetura              Vantagem para o seu IDS                    Camada de Hardware

    Multi-core (1.12)        Permite que o motor do seu IDS e           Nível 1: Microarquitetura.
                             o log de rede rodem em núcleos isolados.

    SoC (1.14)	             Baixa latência no acesso a periféricos 	Nível 0: Lógico Digital.
                             (NAND/USB) para backups automatizados.

    Superescalar (2.6)       Executa múltiplas comparações de pacotes  Nível 1: Pipeline de Execução.                        
                             por ciclo de clock.

A definição de “superescalar” evoluiu um pouco ao longo do tempo. Agora, ela é usada para descrever
processadores que emitem múltiplas instruções – frequentemente, quatro ou seis – em um único ciclo de
clock. Claro que uma CPU superescalar deve ter várias unidades funcionais para passar todas essas instru-
ções. Uma vez que, em geral, os processadores superescalares têm um só pipeline, tendem a ser parecidos
com os da Figura 2.6.

Usando essa definição, o 6600 não era tecnicamente um computador superescalar, pois emitia apenas uma
instrução por ciclo. Todavia, o efeito era quase o mesmo: instruções eram terminadas em uma taxa muito mais alta
do que podiam ser executadas. A diferença conceitual entre uma CPU com um clock de 100 ns que executa uma
instrução a cada ciclo para um grupo de unidades funcionais e uma CPU com um clock de 400 ns que executa
quatro instruções por ciclo para o mesmo grupo de unidades funcionais é muito pequena. Em ambos os casos,
a ideia fundamental é que a taxa final é muito mais alta do que a taxa de execução, sendo a carga de trabalho
distribuída entre um conjunto de unidades funcionais.

Implícito à ideia de um processador superescalar é que o estágio S3 pode emitir instruções com rapidez
muito maior do que o estágio S4 é capaz de executá-las. Se o estágio S3 executasse uma instrução a cada 10 ns
e todas as unidades funcionais pudessem realizar seu trabalho em 10 ns, nunca mais do que uma unidade
estaria ocupada ao mesmo tempo, o que negaria todo o raciocínio. Na verdade, grande parte das unidades fun-
cionais no estágio 4 leva um tempo bem maior do que um ciclo de clock para executar, decerto as que acessam
memória ou efetuam aritmética de ponto flutuante. Como pode ser visto na figura, é possível ter várias ULAs
no estágio S4.

## 2.1.6 Paralelismo no nível do processador
A demanda por computadores cada vez mais rápidos parece ser insaciável. Astrônomos querem simular o
que aconteceu no primeiro microssegundo após o Big Bang, economistas querem modelar a economia mundial e
adolescentes querem se divertir com jogos multimídia em 3D com seus amigos virtuais pela Internet. Embora as
CPUs estejam cada vez mais rápidas, haverá um momento em que elas terão problemas com a velocidade da luz,
que provavelmente permanecerá a 20 cm/nanossegundo em fio de cobre ou fibra ótica, não importando o grau
de inteligência dos engenheiros da Intel. Chips mais velozes também produzem mais calor, cuja dissipação é um
problema. De fato, a dificuldade para se livrar do calor produzido é o principal motivo pelo qual as velocidades
de clock da CPU se estagnaram na última década.

Paralelismo no nível de instrução ajuda um pouco, mas pipelining e operação superescalar raramente rendem
mais do que um fator de cinco ou dez. Para obter ganhos de 50, 100 ou mais, a única maneira é projetar compu-
tadores com várias CPUs; portanto, agora vamos ver como alguns deles são organizados.

**• Computadores paralelos**

Um número substancial de problemas em domínios de cálculo como ciências físicas, engenharia e gráficos de
computador envolve laços e matrizes, ou então tem estrutura de alta regularidade. Muitas vezes, os mesmos cálcu-
los são efetuados em muitos conjuntos diferentes de dados ao mesmo tempo. A regularidade e a estrutura desses
programas os tornam alvos especialmente fáceis para aceleração por meio de execução paralela. Há dois métodos
que têm sido usados para executar esses programas altamente regulares de modo rápido e eficaz: processadores
SIMD e processadores vetoriais. Embora esses dois esquemas guardem notáveis semelhanças na maioria de seus
aspectos, por ironia o primeiro deles é considerado um computador paralelo, enquanto o segundo é considerado
uma extensão de um processador único.

Computadores paralelos de dados encontraram muitas aplicações bem-sucedidas como consequência de
sua notável eficiência. Eles são capazes de produzir poder de computação significativo com menos transis-
tores do que os métodos alternativos. Gordon Moore (da lei de Moore) observou que o silício custa cerca de 1 bilhão
de dólares por acre (4.047 m²). Assim, quanto mais poder de computação puder ser espremido desse acre de
silício, mais dinheiro uma empresa de computador poderá obter vendendo silício. Os processadores paralelos
de dados são um dos meios mais eficientes de espremer o desempenho do silício. Como todos os processado-
res estão rodando a mesma instrução, o sistema só precisa de um “cérebro” controlando o computador. Em
consequência, o processador só precisa de um estágio de busca, um estágio de decodificação e um conjunto
de lógica de controle. Essa é uma enorme economia no silício, que dá aos computadores paralelos uma grande
vantagem sobre outros processadores, desde que o software que eles estejam rodando seja altamente regular,
com bastante paralelismo.

Um processador SIMD (Single Instruction-stream Multiple Data-stream, ou fluxo único de instruções,
fluxo múltiplo de dados) consiste em um grande número de processadores idênticos que efetuam a mesma
sequên­cia de instruções sobre diferentes conjuntos de dados. O primeiro processador SIMD do mundo foi o
ILLIAC IV da Universidade de Illinois (Bouknight et al., 1972). O projeto original do ILLIAC IV consistia em qua-
tro quadrantes, cada um deles com uma grade quadrada de 8 × 8 elementos de processador/memória. Uma única
unidade de controle por quadrante transmitia uma única instrução a todos os processadores, que era executada
no mesmo passo por todos eles, cada um usando seus próprios dados de sua própria memória. Por causa de um
excesso de custo, somente um quadrante de 50 megaflops (milhões de operações de ponto flutuante por segun-
do) foi construído; se a construção da máquina inteira de 1 gigaflop tivesse sido concluída, ela teria duplicado a
capacidade de computação do mundo inteiro.

As modernas unidades de processamento de gráficos (GPUs) contam bastante com o processamento SIMD
para fornecer poder computacional maciço com poucos transistores. O processamento de gráficos foi apropriado
para processadores SIMD porque a maioria dos algoritmos é altamente regular, com operações repetidas sobre
pixels, vértices, texturas e arestas. A Figura 2.7 mostra o processador SIMD no núcleo da GPU Fermi da Nvidia.
A GPU Fermi contém até 16 multiprocessadores de fluxo (com memória compartilhada – SM) SIMD, com cada
multiprocessador contendo 32 processadores SIMD. A cada ciclo, o escalonador seleciona dois threads para
executar no processador SIMD. A próxima instrução de cada thread é então executada em até 16 processadores
SIMD, embora possivelmente menos se não houver paralelismo de dados suficiente. Se cada thread for capaz de
realizar 16 operações por ciclo, um núcleo GPU Fermi totalmente carregado com 32 multiprocessadores realizará
incríveis 512 operações por ciclo. Esse é um feito impressionante, considerando que uma CPU quad-core de uso
geral com tamanho semelhante lutaria para conseguir 1/32 desse processamento.

### Figura 2.7 O núcleo SIMD da unidade de processamento de gráficos Fermi.

    +-----------------------------------------------------------+
    |                  Cache de Instruções                      |
    +-----------------------------+-----------------------------+
    |   Despacho de Instruções    |    Despacho de Instruções   |
    +-----------------------------+-----------------------------+
    |                  Arquivo de Registradores                 |
    +-----------------------------------------------------------+
    |                                                           |
    | [N][N][N][N]   [N][N][N][N] | [N][N][N][N]   [N][N][N][N] | <-- Blocos de Núcleos
    | [N][N][N][N]   [N][N][N][N] | [N][N][N][N]   [N][N][N][N] | (Total: centenas de [N])
    | [N][N][N][N]   [N][N][N][N] | [N][N][N][N]   [N][N][N][N] |
    | [N][N][N][N]   [N][N][N][N] | [N][N][N][N]   [N][N][N][N] |
    |                                                           |
    |           +-----+--------> [ DETALHE DE 'N' ] <------+----+
    |           |                                          |
    |           |   [Operando A]        [Operando B]       |
    |           |       /     \         /      \           |
    |           |   +--v---+   +-------v--+     +--v---+   |
    |           |   |Unid. |   |   ULA    |     |Unid. |   |
    |           |   | Ponto|---| (Operaçõ.|     |  de  |   |
    |           |   | Flutu|   | Inteiras)|-----| Busca|   |
    |           |   | ante |   |          |     | Oper.|   |
    |           |   +--+---+   +-------+--+     +------+   |
    |           |       \             /                    |
    |           |        v           v                     |
    |           |   [Registrador de Resultado]             |
    |                                                           |
    +-----------------------------------------------------------+
    |                    Rede de Interconexão                   |
    +-----------------------------------------------------------+
    |                     Memória Compartilhada                 |
    +-----------------------------------------------------------+


![alt text](image-80.png)

    Mapeamento Técnico para seu Repositório

    Processamento                                       Armazenamento

    Arquitetura Massivamente                            ParalelaAcesso à Memória (SIMD)

    O "Despacho de Instruções" envia a mesma ordem      Todos os núcleos [N] acessam a "Memória Compartilhada" de forma coordenada, (ex: SUB) para todos os núcleos [N] de um bloco     minimizando conflitos de barramento (visto na Figura 2.1).
    simultaneamente.

                                                        BARRAMENTO INTERNO

    Unidades Especializadas em 'N'	                    Impacto no seu Código (C/C++)

    Cada núcleo simples [N] tem sua própria ULA e       Ao programar em CUDA, você "desenrola" seu código para que ele se encaixe Unidade de Ponto Flutuante, mas não tem a complexa  nessas centenas de unidades funcionais, acelerando cálculos matemáticos no Unidade de Controle da CPU.                         seu Projeto IDS.

### Insight para o seu Projetos de TI
A Figura 2.7 é o "divisor de águas" da computação moderna. Ela explica como as GPUs evoluíram de renderizadores de polígonos para processadores genéricos de alta performance (GPGPU):

 - O seu IdeaPad: O seu notebook não usa apenas a CPU da Figura 1.12. Para tarefas pesadas, como o treinamento de modelos de IA ou a renderização 3D, ele delega o trabalho para a GPU NVIDIA que segue essa arquitetura massivamente paralela.

 - No seu Projeto IDS: Imagine monitorar 100 mil pacotes de rede por segundo. Em uma CPU, você os processa em lotes pequenos. Em uma GPU com arquitetura SIMD, você pode rodar a mesma regra de comparação em 10 mil pacotes simultaneamente, atingindo vazões Petabyte de dados (visto na Figura 1.16), essenciais para análises em tempo real.

Para um programador, um processador vetorial se parece muito com um processador SIMD. Assim como
um processador SIMD, ele é muito eficiente para executar uma sequência de operações em pares de elementos
de dados. Porém, diferente de um processador SIMD, todas as operações de adição são efetuadas em uma única
unidade funcional, de alto grau de paralelismo. A Cray Research, empresa fundada por Seymour Cray, produziu
muitos processadores vetoriais, começando com o Cray-1 em 1974 e continuando até os modelos atuais.

Processadores SIMD, bem como processadores vetoriais, trabalham com matrizes de dados. Ambos execu-
tam instruções únicas que, por exemplo, somam os elementos aos pares para dois vetores. Porém, enquanto o
processador SIMD faz isso com tantos somadores quantos forem os elementos do vetor, o processador vetorial
tem o conceito de um registrador vetorial, que consiste em um conjunto de registradores convencionais que
podem ser carregados com base na memória em uma única instrução que, na verdade, os carrega serialmente
com base na memória. Então, uma instrução de adição vetorial efetua as adições a partir dos elementos de dois
desses vetores, alimentando-os em um somador com paralelismo (pipelined) com base em dois registradores
vetoriais. O resultado do somador é outro vetor, que pode ser armazenado em um registrador vetorial ou usado
diretamente como um operando para outra operação vetorial. As instruções SSE (Streaming SIMD Extension)
disponíveis na arquitetura Intel Core utilizam esse modelo de execução para agilizar o cálculo altamente
regular, como multimídia e software científico. Nesse aspecto particular, o ILLIAC IV é um dos ancestrais da
arquitetura Intel Core.

**• Multiprocessadores**

Os elementos de processamento em um processador SIMD não são CPUs independentes, uma vez que há
uma só unidade de controle compartilhada por todos eles. Nosso primeiro sistema paralelo com CPUs totalmen-
te desenvolvidas é o multiprocessador, um sistema com mais de uma CPU que compartilha uma memória em
comum, como um grupo de pessoas que, dentro de uma sala de aula, compartilha um quadro em comum. Uma
vez que cada CPU pode ler ou escrever em qualquer parte da memória, elas devem se coordenar (em software)
para evitar que uma atrapalhe a outra. Quando duas ou mais CPUs têm a capacidade de interagir de perto, como
é o caso dos multiprocessadores, diz-se que elas são fortemente acopladas.

Há vários esquemas de implementação possíveis. O mais simples é um barramento único com várias CPUs e
uma memória, todas ligadas nele. Um diagrama desse tipo de multiprocessador de barramento único é mostrado
na Figura 2.8(a).

### Figura 2.8 (a) Multiprocessador de barramento único. (b) Multicomputador com memórias locais.

Figura 2.8: Comparação de Sistemas Paralelos (

(a) Multiprocessador de barramento único

      [CPU]   [CPU]   [CPU]   [CPU]      [ MEMÓRIA ]
        |       |       |       |       [ COMPART. ]
    +---+-------+-------+-------+------------+------+
    |                BARRAMENTO GERAL               |
    +-----------------------------------------------+

(b) Multicomputador com memórias locais

    [MEM.L] [MEM.L] [MEM.L] [MEM.L]
        |       |       |       |
    [CPU ]  [CPU ]  [CPU ]  [CPU ]      [ MEMÓRIA ]
        |       |       |       |       [ COMPART. ]
   +----+-------+-------+-------+------------+------+
    |                BARRAMENTO GERAL               |
    +-----------------------------------------------+
    *(Legenda: MEM.L = Memória Local)*

![alt text](image-81.png)

### Insight para seus Projetos de TI
A distinção vista na Figura 2.8 explica como o seu notebook funciona hoje:

 - O seu Lenovo IdeaPad é um Multiprocessador (a) em miniatura. As diferentes CPUs (os múltiplos núcleos que vimos na Figura 1.12) compartilham a mesma RAM física através do barramento interno da placa-mãe (Figura 1.10).

 - Mas quando você roda um cluster distribuído ou containers no Ubuntu, você está operando em um Multicomputador (b) virtual, onde cada container ou nó do cluster tem seu próprio sistema operacional (Nível 3) e memória local, mas compartilha a rede (barramento geral).

Não é preciso muita imaginação para perceber que, com um grande número de processadores velozes ten-
tando acessar a memória pelo mesmo barramento, surgirão conflitos. Projetistas de multiprocessadores apresen-
taram vários esquemas para reduzir essa disputa e melhorar o desempenho. Um desses esquemas, mostrado na
Figura 2.8(b), dá a cada processador um pouco de memória local só dele, que não é acessível para os outros. Essa
memória pode ser usada para o código de programa e para os itens de dados que não precisam ser compartilhados.
O acesso a essa memória privada não usa o barramento principal, o que reduz muito o tráfego no barramento.
Outros esquemas (por exemplo, caching – veja mais adiante) também são possíveis.

Multiprocessadores têm a vantagem sobre outros tipos de computadores paralelos: é fácil trabalhar com o
modelo de programação de uma única memória compartilhada. Por exemplo, imagine um programa que procura
células cancerosas na foto de algum tecido, tirada por um microscópio. A fotografia digitalizada poderia ser man-
tida na memória em comum, sendo cada processador designado para caçar essas células em alguma região. Uma
vez que cada processador tem acesso a toda a memória, estudar a célula que começa em sua região designada mas
atravessa a fronteira da próxima região não é problema.

**• Multicomputadores

Embora seja um tanto fácil construir multiprocessadores com um número modesto de processadores
(≤ 256), construir grandes é surpreendentemente difícil. A dificuldade está em conectar todos os processado-
res à memória. Para evitar esses problemas, muitos projetistas simplesmente abandonaram a ideia de ter uma
memória compartilhada e passaram a construir sistemas que consistissem em grandes números de computa-
dores interconectados, cada um com sua própria memória privada, mas nenhuma em comum. Esses sistemas
são denominados multicomputadores. Costuma-se dizer que as CPUs de um multicomputador são fracamente
acopladas, para contrastá-las com as CPUs fortemente acopladas de um multiprocessador.

As CPUs de um multicomputador se comunicam enviando mensagens umas às outras, mais ou menos como
enviar e-mails, porém, com muito mais rapidez. Em sistemas grandes, não é prático ter cada computador liga-
do a todos os outros, portanto, são usadas topologias como malhas 2D e 3D, árvores e anéis. O resultado é que
mensagens de um computador para outro muitas vezes passam por um ou mais computadores ou comutadores
(chaves) intermediários para ir da fonte até o destino. Não obstante, podem-se conseguir tempos de transmissão
de mensagem da ordem de alguns microssegundos sem muita dificuldade. Multicomputadores com mais de 250
mil CPUs, como o Blue Gene/P da IBM, já foram construídos.

Uma vez que multiprocessadores são mais fáceis de programar e multicomputadores são mais fáceis de cons-
truir, há muita pesquisa sobre projetos de sistemas híbridos que combinam as boas propriedades de cada um.
Esses computadores tentam apresentar a ilusão de memória compartilhada sem bancar a despesa de realmente
construí-la. Falaremos mais de multiprocessadores e multicomputadores no Capítulo 8.

## 2.2 Memória primária
A memória é a parte do computador onde são armazenados programas e dados. Alguns cientistas da com-
putação (em especial, os britânicos) usam o termo armazém ou armazenagem em vez de memória, se bem que
o termo “armazenagem” está sendo usado cada vez mais para a armazenagem em disco. Sem uma memória da
qual os processadores possam ler e na qual possam gravar, ou escrever, informações, não haveria computadores
digitais com programas armazenados.

## 2.2.1 Bits
A unidade básica de memória é dígito binário, denominado bit. Um bit pode conter um 0 ou um 1. É a
unidade mais simples possível. (Um dispositivo capaz de armazenar somente zeros dificilmente poderia formar a
base de um sistema de memória; são necessários pelo menos dois valores.)

As pessoas costumam dizer que computadores usam aritmética binária porque ela é “eficiente”. O que elas
querem dizer, embora quase nunca percebam, é que informações digitais podem ser armazenadas distinguindo
entre valores diferentes de alguma quantidade física contínua, tal como tensão ou corrente elétrica. Quanto maior
for o número de valores que precisam ser distinguidos, menores serão as separações entre valores adjacentes, e
menos confiável será a memória. O sistema numérico binário requer a distinção entre apenas dois valores. Por
conseguinte, é o método mais confiável para codificar informações digitais. Se você não estiver familiarizado com
números binários, consulte o Apêndice A.

Há empresas que anunciam que seus computadores têm aritmética decimal, bem como binária, como é o
caso da IBM e seus grandes mainframes. Essa façanha é realizada usando-se 4 bits para armazenar um dígito
decimal que utiliza um código denominado BCD (Binary Coded Decimal – decimal codificado em binário).
Quatro bits oferecem 16 combinações, usadas para os 10 dígitos de 0 a 9, mas seis combinações não são usa-
das. O número 1.944 é mostrado a seguir codificado em formato decimal e em formato binário puro, usando
16 bits em cada exemplo:

    decimal: 0001 1001 0100 0100        binário: 0000011110011000

Dezesseis bits no formato decimal podem armazenar os números de 0 a 9999, dando somente 10 mil com-
binações, ao passo que um número binário puro de 16 bits pode armazenar 65.536 combinações diferentes. Por
essa razão, as pessoas dizem que o binário é mais eficiente.

No entanto, considere o que aconteceria se algum jovem e brilhante engenheiro elétrico inventasse um dis-
positivo eletrônico de alta confiabilidade que pudesse armazenar diretamente os dígitos de 0 a 9 dividindo a região
de 0 a 10 volts em 10 intervalos. Quatro desses dispositivos poderiam armazenar qualquer número decimal de 0 a
9999. Quatro desses dispositivos dariam 10 mil combinações. Eles também poderiam ser usados para armazenar números binários usando somente 0 e 1, caso em que quatro deles só poderiam armazenar 16 combinações. Com
tais dispositivos, o sistema decimal é obviamente mais eficiente.

## 2.2.2 Endereços de memória
Memórias consistem em uma quantidade de células (ou locais), cada uma das quais podendo armazenar uma
informação. Cada célula tem um número, denominado seu endereço, pelo qual os programas podem se referir a
ela. Se a memória tiver n células, elas terão endereços de 0 a n – 1. Todas as células em uma memória contêm o
mesmo número de bits. Se uma célula consistir em k bits, ela pode conter quaisquer das 2k diferentes combina-
ções de bits. A Figura 2.9 mostra três organizações diferentes para uma memória de 96 bits. Note que as células
adjacentes têm endereços consecutivos (por definição).

### Figura 2.9 Três maneiras de organizar uma memória de 96 bits.

Três formas de estruturar a mesma quantidade de bits em diferentes larguras de célula.

    (a) 12 x 8 bits          (b) 8 x 12 bits          (c) 6 x 16 bits
        
    0 [][][][][][][][]       0 [][][][][][][][][][][][]   0 [][][][][][][][][][][][][][][][]
    1 [][][][][][][][]       1 [][][][][][][][][][][][]   1 [][][][][][][][][][][][][][][][]
    2 [][][][][][][][]       2 [][][][][][][][][][][][]   2 [][][][][][][][][][][][][][][][]
    3 [][][][][][][][]       3 [][][][][][][][][][][][]   3 [][][][][][][][][][][][][][][][]
    .        ...             4 [][][][][][][][][][][][]   4 [][][][][][][][][][][][][][][][]
    11 [][][][][][][][]       .        ...                5 [][][][][][][][][][][][][][][][]
                             7 [][][][][][][][][][][][]

![alt text](image-82.png)

Computadores que usam o sistema de números binários (incluindo notação octal ou hexadecimal para
números binários) expressam endereços de memória como números binários. Se um endereço tiver m bits, o
número máximo de células endereçáveis é 2m. Por exemplo, um endereço usado para referenciar a memória da

Figura 2.9(a) precisa de no mínimo 4 bits para expressar todos os números de 0 a 11. Contudo, um endereço
de 3 bits é suficiente para as figuras 2.9(b) e (c). O número de bits no endereço determina o número máximo
de células diretamente endereçáveis na memória e é independente do número de bits por célula. Uma memória
com 212 células de 8 bits cada e uma memória com 212 células de 64 bits cada precisam de endereços de 12 bits.
A Figura 2.10 mostra o número de bits por célula para alguns computadores que já foram vendidos comer-
cialmente.

A significância da célula é que ela é a menor unidade endereçável. Há poucos anos, praticamente todos os fabri-
cantes de computadores padronizaram células de 8 bits, que é denominada um byte. O termo octeto também é usado.
Bytes são agrupados em palavras. Um computador com uma palavra de 32 bits tem 4 bytes/palavra, enquanto um
computador com uma palavra de 64 bits tem 8 bytes/palavra. A significância de uma palavra é que grande parte das
instruções efetua operações com palavras inteiras, por exemplo, somando duas palavras. Assim, uma máquina de 32
bits terá registradores de 32 bits e instruções para manipular palavras de 32 bits, enquanto uma máquina de 64 bits
terá registradores de 64 bits e instruções para movimentar, somar, subtrair e, em geral, manipular palavras de 64 bits.

### Figura 2.10 Número de bits por célula para alguns computadores comerciais historicamente interessantes.
    
    +----------------------+--------------+--------------------------------------------+
    | Computador           | Bits/Célula  | Notas de Arquitetura                       |
    +----------------------+--------------+--------------------------------------------+
    | Burroughs B1700      |      1       | Endereçamento ao nível de bit.             |
    | IBM PC               |      8       | Padronização do Byte (padrão atual).       |
    | DEC PDP-8            |     12       | Minicomputadores laboratoriais antigos.    |
    | IBM 1130             |     16       | Computação científica e engenharia.        |
    | DEC PDP-15           |     18       | Utilizado em sistemas de tempo real.       |
    | XDS 940              |     24       | Primeiros sistemas de tempo compartilhado. |
    | Electrologica X8     |     27       | Arquitetura europeia distinta.             |
    | XDS Sigma 9          |     32       | Base para a arquitetura de 32 bits.        |
    | Honeywell 6180       |     36       | Base do Multics (avô do Unix/Linux).       |
    | CDC 3600             |     48       | Supercomputador: precisão numérica.        |
    | CDC Cyber            |     60       | Extrema performance para a época.          |
    +----------------------+--------------+--------------------------------------------+

### Por que isso é relevante para o seu projeto?
Entender que o IBM PC consolidou os 8 bits como padrão explica por que, no seu código em C e Assembly, o endereçamento de memória (Figura 2.9) sempre salta em bytes:

 - Eficiência: No seu IDS, ler 8 bits de cada vez permite processar cabeçalhos de protocolos de rede de forma muito mais rápida do que em máquinas de 1 bit (Burroughs) ou 60 bits (CDC Cyber).

 - Compatibilidade: O seu sistema Ubuntu 24.04 e o hardware Lenovo são descendentes diretos da padronização de 8 bits mostrada nesta tabela.

### Por que isso importa para o seu eBook?
Ao escrever sobre Estruturas de Dados no seu eBook, entender essa tabela explica por que o tipo char em C quase sempre tem 8 bits:

 - História: A indústria convergiu para o modelo do IBM PC (8 bits) por ser o equilíbrio ideal entre representar o alfabeto e eficiência de hardware.

 - Impacto no seu IDS: Se você estivesse rodando seu sistema de detecção em um Honeywell 6180, um ponteiro de memória não saltaria de 1 em 1 byte, mas de 36 em 36 bits!
    
## 2.2.3 Ordenação de bytes

Os bytes em uma palavra podem ser numerados da esquerda para a direita ou da direita para a esquerda. A
princípio, essa opção pode parecer sem importância, mas, como veremos em breve, ela tem consideráveis impli-
cações. A Figura 2.11(a) retrata parte da memória de um computador de 32 bits cujos bytes são numerados da
esquerda para a direita, tal como o SPARC ou os grandes mainframes da IBM. A Figura 2.11(b) dá uma represen-
tação análoga de um computador de 32 bits que usa uma numeração da direita para a esquerda, como a família
Intel. O primeiro sistema, no qual a numeração começa na ordem “grande”, isto é, na ordem alta, é denominado
computador big endian, ao contrário do little endian da Figura 2.11(b). Esses termos se devem a Jonathan Swift,
cujo livro As viagens de Gulliver satirizava os políticos que discutiam por que uns eram a favor de quebrar ovos
no lado grande (big end) e outros achavam que deviam ser quebrados no lado pequeno (little end). O termo foi
empregado pela primeira vez na arquitetura de computadores em um interessante artigo de Cohen (1981).

### Figura 2.11 (a) Memória big endian. (b) Memória little endian.

Crucial para entender como palavras de 32 bits são distribuídas na memória endereçada por byte. No Big Endian, o byte mais significativo fica no menor endereço; no Little Endian (padrão do seu Lenovo/Intel), ocorre o oposto.

    (a) BIG ENDIAN                  (b) LITTLE ENDIAN
        
        Endereço de Byte                Endereço de Byte
         0   1   2   3                   3   2   1   0
        +---+---+---+---+               +---+---+---+---+
    0   | 0 | 1 | 2 | 3 |            0  | 3 | 2 | 1 | 0 |
        +---+---+---+---+               +---+---+---+---+
    4   | 4 | 5 | 6 | 7 |            4  | 7 | 6 | 5 | 4 |
        +---+---+---+---+               +---+---+---+---+
    8   | 8 | 9 |10 |11 |            8  |11 |10 | 9 | 8 |
        +---+---+---+---+               +---+---+---+---+
    12  |12 |13 |14 |15 |           12  |15 |14 |13 |12 |
        +---+---+---+---+               +---+---+---+---+
    <--Palavra de 32 bits-->        <--Palavra de 32 bits--> 

![alt text](image-83.png)

    Resumo para seu Repositório

    Conceito                      Vantagem Técnica                  Aplicação no seu IDS

    Arquitetura (2.1)             Modularidade via Barramento.      Facilita a adição de interfaces de rede rápidas.

    Pipeline (2.4/2.5)            Paralelismo de Instrução.         Aumenta a vazão de análise de pacotes por segundo.

    Endianness (2.11)             Compatibilidade de Protocolo.     Vital para decodificar corretamente cabeçalhos 
                                                                    TCP/IP (Big Endian) no seu PC (Little Endian).
                                                                    
É importante entender que, tanto no sistema big endian como no little endian, um inteiro de 32 bits com o
valor numérico de, digamos, 6 é representado pelos bits 110 nos três bits mais à direita (baixa ordem) de uma
palavra e os zeros nos 29 bits da esquerda. No esquema big endian, os bits 110 estão no byte 3 (ou 7, ou 11 etc.),
enquanto no esquema little endian eles estão no byte 0 (ou 4, ou 8 etc.). Em ambos os casos, a palavra que contém
esses inteiros tem endereço 0.

Se os computadores somente armazenassem inteiros, não haveria nenhum problema. Contudo, muitas apli-
cações requerem uma mistura de inteiros, cadeias de caracteres e outros tipos de dados. Considere, por exemplo,
um simples registro de pessoal composto de uma cadeia (nome do empregado) e dois inteiros (idade e número do
departamento). A cadeia é encerrada com 1 ou mais bytes de valor 0 para completar uma palavra. Para o registro
“Jim Smith, idade 21, departamento 260 (1 × 256 + 4 = 260)”, a representação big endian é mostrada na Figura
2.12(a) e a representação little endian é mostrada na Figura 2.12(b).

**• Figura 2.12 (a) Registro de pessoal para uma máquina big endian. (b) O mesmo registro para uma máquina little endian. (c) Resultado da transferência do registro de uma máquina big endian para uma little endian. (d) Resultado da troca de bytes (c).**

A Figura 2.12. Esta figura é vital para o seu "Projeto IDS", pois demonstra o que acontece quando dados estruturados (como nomes e números) são transferidos entre sistemas com arquiteturas de bytes opostas.

Este exemplo usa um registro de pessoal com um nome ("JIM SMITH") e um número de matrícula (21, 12, 00, 00).

    (a) Máquina Big Endian           (b) Máquina Little Endian
        0   1   2   3                    3   2   1   0
        +---+---+---+---+                +---+---+---+---+
    0   | J | I | M |   |             0  |   | M | I | J |  (Nome)
        +---+---+---+---+                +---+---+---+---+
    4   | S | M | I | T |             4  | T | I | M | S |  (Nome)
        +---+---+---+---+                +---+---+---+---+
    8   | H |   | 0 | 0 |             8  | 0 | 0 |   | H |  (H = matrícula)
        +---+---+---+---+                +---+---+---+---+
    12  | 21| 12| 0 | 0 |            12  | 0 | 0 | 12| 21|  (ID numérico)
        +---+---+---+---+                +---+---+---+---+

        (c) Após Transferência           (d) Após Troca de Bytes (Swap)
             (Sem correção)                   (Resultado desejado)
        3   2   1   0                    3   2   1   0
        +---+---+---+---+                +---+---+---+---+
    0   | J | I | M |   |             0  |   | M | I | J |  <-- Nome "quebra"
        +---+---+---+---+                +---+---+---+---+
    4   | S | M | I | T |             4  | T | I | M | S |  <-- Nome "quebra"
        +---+---+---+---+                +---+---+---+---+
    8   | H |   | 0 | 0 |             8  | 0 | 0 |   | H |  <-- Numérico OK!
        +---+---+---+---+                +---+---+---+---+
    12  | 21| 12| 0 | 0 |            12  | 0 | 0 | 12| 21|  <-- Numérico OK!
        +---+---+---+---+                +---+---+---+---+

![alt text](image-84.png)

A a Figura 2.12 ilustra o "pesadelo" dos desenvolvedores de sistemas de rede. Se você apenas trocar os bytes para consertar o número da matrícula (item d), você acaba invertendo a ordem das letras no nome (que já estavam certas por serem lidas individualmente).

Isso reforça por que, no seu eBook, é importante destacar que strings e inteiros exigem tratamentos diferentes na memória.

Ambas as representações são boas e internamente consistentes. Os problemas começam quando uma das
máquinas tenta enviar um registro à outra por uma rede. Vamos supor que a big endian envie o registro à little
endian um byte por vez, começando com o byte 0 e terminando com o byte 19. (Vamos ser otimistas e supor que
os bits dos bytes não sejam invertidos pela transmissão porque, assim como está, já temos problemas suficientes.)
Portanto, o byte 0 da big endian entra na memória da little endian no byte 0 e assim por diante, como mostra a
Figura 2.12(c).

Quando a little endian tenta imprimir o nome, ela funciona bem, mas a idade sai como 21 × 224 e o depar-
tamento também fica errado. Essa situação surge porque a transmissão inverteu a ordem dos caracteres em uma
palavra, como deveria, mas também inverteu os bytes de um inteiro, o que não deveria.

Uma solução óbvia é fazer o software inverter os bytes de uma palavra após tê-la copiado. Isso leva à Figura
2.12(d), que faz os dois inteiros se saírem bem, mas transforma a cadeia em “MIJTIMS” e deixa o “H” perdido
no meio do nada. Essa inversão da cadeia ocorre porque, ao ler a cadeia, o computador lê primeiro o byte 0 (um
espaço), em seguida o byte 1 (M), e assim por diante.

Não há nenhuma solução simples. Um modo que funciona – porém, ineficiente – é incluir um cabeçalho
na frente de cada item de dado, que informa qual tipo de dado vem a seguir (cadeia, inteiro ou outro) e qual é
seu comprimento. Isso permite que o destinatário efetue apenas as conversões necessárias. De qualquer modo, é
preciso deixar claro que a falta de um padrão para a ordenação de bytes é um grande aborrecimento quando há
troca de dados entre máquinas diferentes.

## 2.2.4 Códigos de correção de erro
Memórias de computador podem cometer erros de vez em quando devido a picos de tensão na linha elé-
trica, raios cósmicos ou outras causas. Para se resguardar contra esses erros, algumas memórias usam códigos de
detecção de erros ou códigos de correção de erros. Quando são usados, bits extras são adicionados a cada palavra
de memória de modo especial. Quando uma palavra é lida na memória, os bits extras são verificados para ver se
ocorreu um erro.

Para entender como os erros podem ser manipulados, é preciso ver de perto o que é, na realidade, um erro.
Suponha que uma palavra de memória consista em m bits de dados, aos quais serão adicionados r bits redundantes, ou de verificação. Seja o comprimento total n (isto é, n = m + r). Uma unidade de n bits que contém m dados e r
bits de verificação costuma ser denominada uma palavra de código de n bits.

Dadas duas palavras de código quaisquer, por exemplo, 10001001 e 10110001, é possível determinar quan-
tos bits correspondentes são diferentes. Nesse caso, 3 bits são diferentes. Para saber quantos bits são diferentes,
basta calcular o EXCLUSIVE OR (OU EXCLUSIVO) booleano bit por bit das duas palavras de código e contar o
número de bits 1 no resultado. O número de posições de bit nas quais as duas palavras de código diferem é deno-
minado distância de Hamming (Hamming, 1950). Sua principal significância é que, se duas palavras de código
estiverem separadas por uma distância de Hamming d, será preciso d erros de único bit para converter uma na
outra. Por exemplo, as palavras de código 11110001 e 00110000 estão a uma distância de Hamming 3 porque é
preciso 3 erros de único bit para converter uma na outra.

Com uma palavra de memória de m bits, todos os 2m padrões de bits são válidos, mas, devido ao modo como
os bits de verificação são computados, somente 2m das 2n palavras de código são válidas. Se uma leitura de memó-
ria aparecer com uma palavra de código inválida, o computador sabe que ocorreu um erro de memória. Dado o
algoritmo para calcular os bits de verificação, é possível montar uma lista completa das palavras de código válidas
e, por meio dela, achar as duas palavras de código cuja distância de Hamming seja mínima. Essa distância é a
distância de Hamming do código completo.

As propriedades de detecção de erro e correção de erro de um código dependem de sua distância de
Hamming. Para detectar d erros de único bit, você precisa de um código de distância d + 1 porque, com tal
código, não existe nenhum modo que permita que d erros de único bit mudem uma palavra de código válida
para outra. De modo semelhante, para corrigir erros de único bit, você precisa de um código de distância 2d +
1 porque, desse modo, as palavras de código válidas estão tão distantes uma da outra que, mesmo que d mude,
a palavra de código original ainda estará mais perto do que qualquer outra, portanto, ela pode ser unicamente
determinada.

Como um exemplo simples de um código de detecção de erro, considere um código em que um único bit
de paridade é anexado aos dados. O bit de paridade é escolhido de modo que o número de bits 1 na palavra de
código seja par (ou ímpar). Tal código tem uma distância 2, uma vez que qualquer erro de bit único produz uma
palavra de código com paridade errada. Ou seja, ele precisa de dois erros de único bit para ir de uma palavra de
código válida até outra palavra de código válida. Ele pode ser usado para detectar erros isolados. Sempre que uma
palavra que contenha paridade errada for lida da memória, uma condição de erro é sinalizada. O programa não
pode continuar, mas, ao menos, nenhum resultado errado é calculado.

Como um exemplo simples de um código de correção de erros, considere um código que tenha apenas quatro
palavras de código válidas:

    0000000000        0000011111          1111100000     e     1111111111

Esse código tem uma distância 5, o que significa que pode corrigir erros duplos. Se a palavra de código
0000000111 chegar, o destinatário sabe que a original deve ter sido 0000011111 (se não houver mais do
que um duplo erro). Contudo, se um erro triplo mudar 0000000000 para 0000000111, o erro não pode ser
corrigido.

Imagine que queremos projetar um código com m bits de dados e r bits de verificação que permitirá que
todos os erros de bits únicos sejam corrigidos. Cada uma das 2m palavras de memória válidas tem n palavras de
código inválidas a uma distância 1. Essas palavras de código inválidas são formadas sistematicamente invertendo
cada um dos n bits na palavra de código de n bits formada com base nela. Assim, cada uma das 2m palavras de
memória válidas requer n + 1 padrões de bits dedicados a ela (para os n possíveis erros e padrão de correção).
Uma vez que o número total de padrões de bits é 2n, temos de ter (n + 1)2m ≤ 2n. Usando n = m + r, esse requisito
se torna (m + r + 1) ≤ 2r. Dado m, isso impõe um limite inferior ao número de bits de verificação necessários para
corrigir erros únicos. A Figura 2.13 mostra o número de bits de verificação requeridos por vários tamanhos de
palavras de memória.

### Figura 2.13 Número de bits de verificação para um código que pode corrigir um erro único.

Essa tabela (Figura 2.13) é fundamental para o seu eBook, pois ela quantifica o custo de implementação de códigos de correção de erro (como o de Hamming) em diferentes tamanhos de palavra.

Para um sistema de alta performance como o seu "Projeto IDS", entender o acréscimo percentual é vital para equilibrar segurança de dados e largura de banda.

    +---------+-------------+---------+------------+
    | Tamanho |   Bits de   | Tamanho | Acréscimo  |
    | Palavra | Verificação |  Total  | Percentual |
    +---------+-------------+---------+------------+
    |    8    |      4      |    12   |     50%    |
    |   16    |      5      |    21   |     31%    |
    |   32    |      6      |    38   |     19%    |
    |   64    |      7      |    71   |     11%    |
    |  128    |      8      |   136   |      6%    |
    |  256    |      9      |   265   |      4%    |
    |  512    |     10      |   522   |      2%    |
    +---------+-------------+---------+------------+

    **Mapeamento Técnico**

    Processamento	                                                  Armazenamento

    Cálculo de Síndrome	                                              Redundância de Dados

    A ULA (Figura 2.2) precisa de ciclos extras para calcular os	  Palavras maiores (512 bits) são mais eficientes, pois a  bits de paridade antes de processar a instrução.                  a redutâncua cai para apenas 2%.

                                                                      BARRAMENTO INTERNO

    Confiabilidade no Barramento	                                  Impacto no seu Código C

    Evita que ruídos elétricos no barramento (Figura 2.1) alterem um  Ao lidar com structs grandes no seu IDS, você aproveita bit de um pacote de rede crítico.                                     melhor o hardware se a palavra for larga (E. AVX-512 no seu i                                                                 i7).

### Insight: "A Economia de Escala Digital"
Ao documentar isso no seu eBook, note que quanto maior a palavra, menor o "imposto" de bits que você paga pela segurança:

 - Palavras Curtas (8 bits): Como visto no IBM PC (Figura 2.10), você perde metade da capacidade (50%) apenas para corrigir erros.

 - Palavras Longas (512 bits): Em servidores modernos (como os que você gerencia na OCI), o custo é quase desprezível, permitindo uma integridade de dados massiva sem sacrificar o armazenamento.

Esse limite inferior teórico pode ser conseguido usando um método criado por Richard Hamming (1950).
Antes de analisar o algoritmo de Hamming, vamos examinar uma representação gráfica simples que ilustra com
clareza a ideia de um código de correção de erros para palavras de 4 bits. O diagrama de Venn da Figura 2.14(a)
contém três círculos, A, B e C, que juntos formam sete regiões. Como exemplo, vamos codificar a palavra de
memória de 4 bits 1100 nas regiões AB, ABC, AC e BC, 1 bit por região (em ordem alfabética). Essa codificação
é mostrada na Figura 2.14(a).

**Figura 2.14 (a) Codificação de 1100. (b) Paridade par adicionada. (c) Erro em AC.**

**Figura 2.14: Codificação de Erros**
Visualização de como bits de paridade são usados para detectar e corrigir erros em uma sequência de dados.

    ((a) Codificação              (b) Paridade                (c) Erro em C
          de 1100                      Adicionada                  (Detection)
    
          /---\                        /---\                        /---\
         /  0  \                      /  0  \                      /  0  \
        |--- ---|                    |--- ---|                    |--- ---|
     /--| 1 | 0 |--\              /--| 1 | 0 |--\              /--| 1 | 0 |--\
    /  1 \ --- / 0  \            /  1 \ --- / 1  \            /  1 \ --- / 1  \
    \    /     \    /            \    /     \    /            \    /   X \    / <-- ERRO!
     \--/       \--/              \--/       \--/              \--/       \--/
       B         C                  B         C                  B         C
                                                          (Soma de paridade em C = ÍMPAR)
![alt text](image-85.png)

Em seguida, acrescentamos um bit de paridade a cada uma dessas três regiões vazias para produzir pari-
dade par, como ilustrado na Figura 2.14(b). Por definição, agora a soma dos bits em cada um dos três círculos,
A, B e C, é um número par. No círculo A, temos os quatro números 0, 0, 1 e 1, cuja soma total é 2, um núme-
ro par. No círculo B, os números são 1, 1, 0 e 0, cuja soma total é 2, um número par. Por fim, no círculo C,
temos a mesma coisa. Nesse exemplo, por acaso todos os círculos são iguais, mas as somas de 0 e 4 também
são possíveis em outros exemplos. Essa figura corresponde a uma palavra de código com 4 bits de dados e 3
bits de paridade.

Agora, suponha que algo de ruim aconteça com o bit na região AC e ele mude de 0 para 1, conforme mostra
a Figura 2.14(c). Agora, o computador pode ver que os círculos A e C têm a paridade errada (ímpar). A única
mudança de bit individual que pode corrigi-los é restaurar AC para 0, o que corrige o erro. Desse modo, o com-
putador pode corrigir automaticamente erros de memória em único bit.

Agora, vamos ver como o algoritmo de Hamming pode ser usado para construir códigos de correção de erros
para qualquer tamanho de palavra de memória. Em um código de Hamming, são acrescentados r bits de paridade
a uma palavra de m bits, formando uma nova palavra de comprimento m + r bits. Os bits são numerados come-
çando com 1, não com 0, sendo que o bit 1 é o da extrema esquerda (ordem alta). Todos os bits cujo número de
bit for uma potência de 2 são de paridade; os restantes são usados para dados. Por exemplo, com uma palavra
de 16 bits, são adicionados 5 bits de paridade. Os bits 1, 2, 4, 8 e 16 são bits de paridade e todos os restantes são bits de dados. No total, a palavra de memória tem 21 bits (16 de dados, 5 de paridade). Neste exemplo, usaremos
(arbitrariamente) a paridade par.

Cada bit de paridade verifica posições específicas de bits; o bit de paridade é estabelecido de modo que o
número de 1s nas posições verificadas seja par. As posições de bits verificadas pelos bits de paridade são

    Bit 1 verifica bits 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21.
    Bit 2 verifica bits 2, 3, 6, 7, 10, 11, 14, 15, 18, 19.
    Bit 4 verifica bits 4, 5, 6, 7, 12, 13, 14, 15, 20, 21.
    Bit 8 verifica bits 8, 9, 10, 11, 12, 13, 14, 15.
    Bit 16 verifica bits 16, 17, 18, 19, 20, 21.

Em geral, o bit b é verificado pelos bits b1, b2, ..., bj tais que b1 + b2 + ... + bj = b. Por exemplo, o bit 5 é
verificado pelos bits 1 e 4 porque 1 + 4 = 5. O bit 6 é verificado pelos bits 2 e 4 porque 2 + 4 = 6 e assim por
diante.

A Figura 2.15 mostra a construção de um código de Hamming para a palavra de memória de 16 bits
1111000010101110. A palavra de código de 21 bits é 001011100000101101110. Para ver como funciona a
correção de erros, considere o que aconteceria se o bit 5 fosse invertido por uma sobrecarga elétrica na linha de
força. A nova palavra de código seria 001001100000101101110 em vez de 001011100000101101110. Os 5 bits
de paridade serão verificados com os seguintes resultados:

    Bit de paridade 1 incorreto (1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21 contêm cinco 1s).
    Bit de paridade 2 correto (2, 3, 6, 7, 10, 11, 14, 15, 18, 19 contêm seis 1s).
    Bit de paridade 4 incorreto (4, 5, 6, 7, 12, 13, 14, 15, 20, 21 contêm cinco 1s).
    Bit de paridade 8 correto (8, 9, 10, 11, 12, 13, 14, 15 contêm dois 1s).
    Bit de paridade 16 correto (16, 17, 18, 19, 20, 21 contêm quatro 1s).

**Figura 2.15 Construção do código de Hamming para a palavra de memória 1111000010101110 adicionando 5 bits de verificação aos
16 bits de dados**

    Palavra de Dados Original: 1 1 1 1 0 0 0 0 1 0 1 0 1 1 1 0 (16 bits)

    Posição:  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21
              |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
    Conteúdo: P  P  1  P  1  1  1  P  0  0  0  0  1  0  1  P  1  1  1  0  1
              ^  ^     ^           ^                       ^
              |__|_____|___________|_______________________|
                        Bits de Paridade (P)
                nas posições de potência de 2 (1, 2, 4, 8, 16)

![alt text](image-86.png)

    Mapeamento Técnico 

    Processamento                                            Armazenamento                     

    Lógica de Potência de 2                                  Custo de Redundância

    A Unidade de Controle (Figura 2.1) reserva posições      Para 16 bits de dados, o acréscimo é de 31% (5 bits extras), específicas (2^n) para os bits de paridade, facilitando  totalizando 21 bits na memória (Figura 2.13).
    a localização do erro via hardware
                                                             BARRAMENTO INTERNO

    Confiabilidade no Barramento                             Aplicação no seu IDS
    
    Garante que um "bit flip" durante a transmissão pelo     Essencial para logs de segurança críticos onde um único bit alterado barramento (Figura 2.8) seja corrigido sem interromper   pode mudar um endereço IP ou uma flag de invasão.
    a execução.

### Insight 
Esta figura explica por que as memórias ECC (Error Correction Code) de servidores são mais caras e eficientes:

 - Hardware Transparente: No seu Lenovo, se ocorrer um erro de bit na RAM, o sistema pode travar (Tela Azul/Kernel Panic). Em sistemas com o código da Figura 2.15, o hardware corrige o bit "no voo" e o software nem percebe.

 - Eficiência no seu Código: Ao entender que os bits de paridade ocupam posições fixas, você entende por que o alinhamento de memória (Figura 2.9) é tão importante para o desempenho em C.

O número total de 1s nos bits 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 e 21 deve ser par porque está sendo usada a
paridade par. O bit incorreto deve ser um dos bits verificados pelo bit de paridade 1 – ou seja, bit 1, 3, 5, 7, 9,
11, 13, 15, 17, 19 ou 21. O bit de paridade 4 está incorreto, o que significa que um dos bits 4, 5, 6, 7, 12, 13, 14,
15, 20 ou 21 está incorreto. O erro deve ser um dos bits que está em ambas as listas, a saber, 5, 7, 13, 15 ou 21.
Contudo, o bit 2 está correto, o que elimina os bits 7 e 15. De modo semelhante, o bit 8 está correto, eliminando
o 13. Por fim, o bit 16 está correto, eliminando o 21. O único que sobrou é 5, que é o bit que está com erro. Uma
vez que foi lido como um 1, ele deveria ser um 0. Dessa maneira, os erros podem ser corrigidos.

Um método simples para achar o bit incorreto é calcular antes todos os bits de paridade. Se todos estiverem
corretos, não houve nenhum erro (ou então houve mais de um). Em seguida, somar todos os bits de paridade incorretos, contando 1 para o bit 1, 2 para o bit 2, 4 para o bit 4 e assim por diante. A soma resultante é a posição
do bit incorreto. Por exemplo, se os bits de paridade 1 e 4 estiverem incorretos, mas 2, 8 e 16 estiverem corretos,
o bit 5 (1 + 4) foi invertido.

## 2.2.5 Memória cache
Historicamente, as CPUs sempre foram mais rápidas do que as memórias. Conforme memórias melhoraram
as CPUs também se aperfeiçoaram, mantendo o desequilíbrio. Na verdade, à medida que fica possível colocar cada
vez mais circuitos em um chip, os projetistas estão usando essas novas facilidades no paralelismo (pipelining) e em
operação superescalar, fazendo as CPUs ficarem ainda mais velozes. Projetistas de memória costumam usar nova
tecnologia para aumentar a capacidade de seus chips, e não a velocidade, portanto, parece que os problemas estão
piorando com o passar do tempo. Na prática, o significado desse desequilíbrio é que, após emitir uma requisição
de memória, a CPU não obterá a palavra de que necessita por muitos ciclos de CPU. Quanto mais lenta a memó-
ria, mais ciclos a CPU terá de esperar.

Como já destacamos, há duas maneiras de tratar desse problema. O modo mais simples é somente iniciar
READs (leituras) de memória quando elas forem encontradas, mas continuar executando e bloquear a CPU se
uma instrução tentar usar a palavra de memória antes de ela chegar. Quanto mais lenta a memória, maior será a
frequência desse problema e maior será a penalidade quando isso, de fato, ocorrer. Por exemplo, se uma instru-
ção em cinco toca na memória e o tempo de acesso à memória for de cinco ciclos, o tempo de execução será o
dobro daquele que teria sido na memória instantânea. Mas, se o tempo de acesso for de 50 ciclos, então o tempo
de execução será elevado por um fator de 11 (5 ciclos para executar instruções mais 50 ciclos para esperar pela
memória).

A outra solução é ter máquinas que não ficam bloqueadas, mas, em vez disso, exigem que o compilador
não gere código para usar palavras antes que elas tenham chegado. O problema é que é muito mais fácil falar
dessa abordagem do que executá-la. Muitas vezes, não há nada mais a fazer após um LOAD (carregar), portanto,
o compilador é forçado a inserir instruções NOP (nenhuma operação), que nada mais fazem do que ocupar um
intervalo (slot) e gastar tempo. Com efeito, essa abordagem é um bloqueio de software em vez de um bloqueio de
hardware, mas a degradação do desempenho é a mesma.

Na verdade, o problema não é tecnológico, mas econômico. Os engenheiros sabem como construir memórias
tão rápidas quanto as CPUs, mas para que executem a toda velocidade, elas têm de estar localizadas no chip da
CPU (porque passar pelo barramento para alcançar a memória é uma operação muito lenta). Instalar uma memó-
ria grande no chip da CPU faz com que esta fique maior e, portanto, mais cara. Ainda que o custo não fosse uma
questão a considerar, há limites de tamanho para um chip de CPU. Assim, a opção se resume a ter uma pequena
quantidade de memória rápida ou uma grande quantidade de memória lenta. O que nós gostaríamos de ter é uma
grande quantidade de memória rápida a um preço baixo.

O interessante é que há técnicas conhecidas para combinar uma pequena quantidade de memória rápida com
uma grande quantidade de memória lenta para obter (quase) a velocidade da memória rápida e a capacidade da
memória grande a um preço módico. A memória pequena e rápida é denominada cache (do francês cacher, que
significa “esconder” e se pronuncia “késh”). Em seguida, descreveremos brevemente como as caches são usadas e
como funcionam. O Capítulo 4 apresenta uma descrição mais detalhada.

A ideia básica de uma cache é simples: as palavras de memória usadas com mais frequência são mantidas na
cache. Quando a CPU precisa de uma palavra, ela examina em primeiro lugar a cache. Somente se a palavra não
estiver ali é que ela recorre à memória principal. Se uma fração substancial das palavras estiver na cache, o tempo
médio de acesso pode ser muito reduzido.

Assim, o sucesso ou o fracasso depende da fração das palavras que estão na cache. Há anos todos sabemos
que programas não acessam suas memórias de forma totalmente aleatória. Se uma dada referência à memória for
para o endereço A, é provável que a próxima estará na vizinhança geral de A. Um exemplo simples é o próprio
programa. Exceto quando se trata de desvios e de chamadas de procedimento, as instruções são buscadas em
localizações consecutivas da memória. Além do mais, grande parte do tempo de execução de um programa é gasto em laços, nos quais um número limitado de instruções é executado repetidas vezes. De modo semelhante,
é provável que um programa de manipulação de matrizes fará muitas referências à mesma matriz antes de passar
para outra coisa qualquer.

A observação de que referências à memória feitas em qualquer intervalo de tempo curto tendem a usar
apenas uma pequena fração da memória total é denominada princípio da localidade, e forma a base de todos
os sistemas de cache. A ideia geral é que, quando uma palavra for referenciada, ela e algumas de suas vizinhas
sejam trazidas da memória grande e lenta para a cache, de modo que, na próxima vez em que for usada, ela
possa ser acessada rapidamente. Um arranjo comum da CPU, cache e memória principal é ilustrado na Figura
2.16. Se uma palavra for lida ou escrita k vezes em um curto intervalo de tempo, o computador precisará de
1 referência à memória lenta e k – 1 referências à memória rápida. Quanto maior for k, melhor será o desem-
penho global.

### Figura 2.16- A localização lógica da cache é entre a CPU e a memória principal. Em termos físicos, há diversos lugares em que ela poderia estar localizada.

A Figura 2.16 ilustra o conceito de hierarquia de memória, focando na localização lógica da cache, que atua como uma ponte de alta velocidade entre a CPU e a memória principal.

No seu IdeaPad, essa arquitetura é o que impede que o processador i7 fique "ocioso" esperando dados da RAM, aumentando drasticamente o desempenho global.

    +----------+              +-------------------+
    |          |              |                   |
    |   CPU    |              | Memória Principal |
    |          |              |      (RAM)        |
    +----+-----+              +---------+---------+
        |                              |
        |          Cache               |
        +------->+-------+             |
                 |       |             |
                 +---+---+             |
                     |                 |
        =============+=================+============= BARRAMENTO

![alt text](image-87.png)

### Insight para o seu eBook: "A Ponte de Velocidade"
Ao documentar a Figura 2.16, você pode destacar dois pontos cruciais para seus leitores:

 - O Gargalo do Barramento: Como visto na Figura 2.1, o barramento é compartilhado. A cache diminui o tráfego nesse barramento, pois a CPU encontra o que precisa localmente.

 - Transparência de Software: Para o programador, a cache é "invisível". No entanto, escrever códigos "cache-friendly" (como os que você está desenvolvendo no repositório estruturas_de_dados) diferencia um software comum de um de alta performance.

Podemos formalizar esse cálculo introduzindo c, o tempo de acesso à cache; m, o tempo de acesso à memória
principal; e h, a taxa de acerto, que é a fração de todas as referências que podem ser satisfeitas através da cache.
Em nosso pequeno exemplo do parágrafo anterior, h = (k – 1)/k. Alguns autores também definem a taxa de falha
(na cache), que é 1 – h.

    Com essas definições, podemos calcular o tempo de acesso médio como segue:

    tempo de acesso médio = c + (1 – h) m

À medida que h → 1, todas as referências podem ser satisfeitas fora da cache e o tempo de acesso médio se
aproxima de c. Por outro lado, à medida que h → 0, toda vez será necessária uma referência à memória, portanto,
o tempo de acesso se aproxima de c + m, primeiro um tempo para verificar a cache (sem sucesso) e então um
tempo m para fazer a referência à memória. Em alguns sistemas, a referência à memória pode ser iniciada em
paralelo com a busca na cache, de modo que, se ocorrer uma falha na cache (cache miss), o ciclo da memória já
terá sido iniciado. Contudo, essa estratégia requer que a memória possa ser interrompida se houver uma presença
na cache (cache hit), o que torna a implantação mais complicada.

Usando o princípio da localidade como guia, memórias principais e caches são divididas em blocos de tama-
nho fixo. Ao nos referirmos a esses blocos dentro da cache, eles costumam ser chamados de linhas de cache.
Quando a busca na cache falha, toda a linha de cache é carregada da memória principal para a cache, e não
apenas a palavra que se quer. Por exemplo, com uma linha de cache de 64 bytes de tamanho, uma referência
ao endereço de memória 260 puxará a linha que consiste nos bytes 256 a 319 para uma linha de cache. Com
um pouco de sorte, algumas das outras palavras na linha de cache também serão necessárias em breve. Esse
tipo de operação é mais eficiente do que buscar palavras individuais porque é mais rápido buscar k palavras de
uma vez só do que uma palavra k vezes. Além disso, ter entradas de cache de mais do que uma palavra significa
que há menor número delas; por conseguinte, é preciso menos memória auxiliar (overhead). Por fim, muitos
computadores podem transferir 64 ou 128 bits em paralelo em um único ciclo do barramento, até mesmo em
máquinas de 32 bits.

O projeto de cache é uma questão de importância cada vez maior para CPUs de alto desempenho. Um aspec-
to é o tamanho da cache. Quanto maior, melhor seu funcionamento, mas também maior é o custo. Um segundo
aspecto é o tamanho da linha de cache. Uma cache de 16 KB pode ser dividida em até 1.024 linhas de 16 bytes,
2.048 linhas de 8 bytes e outras combinações. Um terceiro aspecto é a maneira de organização, isto é, como ela
controla quais palavras de memória estão sendo mantidas no momento. Examinaremos caches detalhadamente
no Capítulo 4.

]Um quarto aspecto do projeto é se as instruções e dados são mantidos na mesma cache ou em caches dife-
rentes. Ter uma cache unificada (instruções e dados usam a mesma cache) é um projeto mais simples e mantém
automaticamente o equilíbrio entre buscas de instruções e buscas de dados. No entanto, a tendência hoje é uma
cache dividida, com instruções em uma cache e dados na outra. Esse projeto também é denominado arquitetura
Harvard e essa referência volta ao passado até o computador Mark III de Howard Aiken, que tinha memórias
diferentes para instruções e dados. A força que impele os projetistas nessa direção é a utilização muito difundida­
de CPUs com paralelismo (pipelined). A unidade de busca de instrução precisa acessar instruções ao mesmo
tempo em que a unidade de busca de operandos precisa de acesso aos dados. Uma cache dividida permite acessos
paralelos; uma cache unificada, não. Além disso, como as instruções não são modificadas durante a execução, o
conteúdo da cache de instrução nunca tem de ser escrito de volta na memória.

Por fim, um quinto aspecto é o número de caches. Hoje em dia não é incomum ter chips com uma cache
primária no chip, uma cache secundária fora dele, mas no mesmo pacote do chip da CPU, e uma terceira cache ainda
mais distante.

## 2.2.6 Empacotamento e tipos de memória
Desde os primeiros dias da memória de semicondutor até o início da década 1990, a memória era fabrica-
da, comprada e instalada como chips únicos. As densidades dos chips iam de 1 K bits até 1 M bits e além, mas
cada chip era vendido como uma unidade separada. Os primeiros PCs costumavam ter soquetes vazios nos quais
podiam ser ligados chips de memória adicionais, se e quando o comprador precisasse deles.

Desde o início da década de 1990, usa-se um arranjo diferente. Um grupo de chips, em geral 8 ou 16, é
montado em uma minúscula placa de circuito impresso e vendido como uma unidade. Essa unidade é deno-
minada SIMM (Single Inline Memory Module – módulo único de memória em linha) ou DIMM (Dual Inline
Memory Module – módulo duplo de memória em linha), dependendo se tem uma fileira de conectores de um
só lado ou de ambos os lados da placa. Os SIMMs têm um conector de borda com 72 contatos e transferem
32 bits por ciclo de clock. Os DIMMs em geral têm conectores de borda com 120 contatos em cada lado da
placa, perfazendo um total de 240 contatos e transferem 64 bits por ciclo de clock. Os mais comuns hoje são
os DIMMs DDR3, que é a terceira versão das memórias de taxa dupla. Um exemplo típico de DIMM é ilustrado
na Figura 2.17.

### Figura 2.17 Visão superior de um DIMM de 4 GB, com oito chips de 256 MB em cada lado. O outro lado tem a mesma aparência.

        <-------------------- 133 mm -------------------->
        +--------------------------------------------------+
        |  +---+   +---+   +---+   +---+   +---+   +---+   |
        |  |CHIP|  |CHIP|  |CHIP|  |CHIP|  |CHIP|  |CHIP|  | --+
        |  |256 |  |256 |  |256 |  |256 |  |256 |  |256 |  |   | Lado A:
        |  | MB |  | MB |  | MB |  | MB |  | MB |  | MB |  |   | 8 Chips
        |  +---+   +---+   +---+   +---+   +---+   +---+   | --+
        |                                                  |
        +--||||||||||||||||||||||||||||||||||||||||||||||--+
            ^^^^^^^^^^^^^^^^^^ CONECTOR ^^^^^^^^^^^^^^^^^^

    Mapeamento Técnico 

    Processamento                                                  Armazenamento
    
    Barramento de Dados                                            Capacidade de Agregação
    -----------------------------------------------------------------------------------------------------------------------------
    O conector DIMM permite que a CPU (Figura 2.1) acesse 64 bits  Cada chip de 256 MB contribui para o total. Dois lados com 8 de dados simultaneamente (oito chips de 8 bits cada).             chips cada resultam em 16 chips × 256 MB = 4 GB por módulo.
    
                                                                   BARRAMENTO INTERNO
    Localização Física                                             Hierarquia de Memória
    
    Conecta-se diretamente à placa-mãe através do barramento de    Situada após a Cache (Figura 2.16), a RAM DIMM é onde o seu sistema (Figura 2.8).                                          Ubuntu carrega os processos do seu IDS.


### Insight para o eBook: "Do Bit ao Pente de Memória"
Ao adicionar esta figura ao seu material, você conecta todos os pontos anteriores:

 - Paridade e ECC: Em módulos voltados para servidores (como os da OCI), você verá frequentemente um nono chip no centro do DIMM. Esse chip extra serve especificamente para armazenar os bits de verificação da Figura 2.13 e realizar a correção da Figura 2.15.

 - Upgrade de Hardware: Se o seu notebook tem dois slots e você usa módulos de 4 GB como o da figura, você atinge 8 GB de RAM, o que é o "espaço de trabalho" real para suas estruturas de dados em C e JS.

Uma configuração típica de DIMM poderia ter oito chips de dados com 256 MB cada. Então, o módulo intei-
ro conteria 2 GB. Muitos computadores têm espaço para quatro módulos, o que dá uma capacidade total de 8 GB
se usarem módulos de 2 GB e mais, se usarem módulos maiores.

Um DIMM fisicamente menor, denominado SO-DIMM (Small Outline DIMM – DIMM pequeno perfil)
é usado em notebooks. Pode-se adicionar um bit de paridade ou correção de erro aos DIMMS, porém, visto
que a taxa média de erro de um módulo é de um erro a cada dez anos, na maioria dos computadores de uso
comum e doméstico, detecção e correção de erros são omitidas.

## 2.3 Memória secundária Seja qual for o tamanho da memória principal, ela sempre será muito pequena. As pessoas sempre querem
armazenar mais informações do que a memória pode conter, ainda mais porque, à medida que a tecnologia melho-
ra, elas começam a pensar em armazenar coisas que antes estavam inteiramente no reino da ficção científica. Por
exemplo, como as diretrizes orçamentárias do governo dos Estados Unidos obrigam as agências governamentais a
gerar sua própria receita, podemos imaginar a Biblioteca do Congresso decidindo digitalizar e vender todo o seu
conteúdo como um artigo de consumo (“Todo o conhecimento humano por apenas US$ 299,95”). Cerca de 50
milhões de livros, cada qual com 1 MB de texto e 1 MB de figuras comprimidas, requerem armazenagem de 1014
bytes ou 100 terabytes. Armazenar todos os 50 mil filmes produzidos até agora também faz parte desse carnaval.
Essa quantidade de informação não caberá na memória principal, ao menos por algumas décadas.

## 2.3.1 Hierarquias de memória
A solução tradicional para armazenar grandes quantidades de dados é uma hierarquia de memória, como
ilustrada na Figura 2.18. No topo, estão os registradores da CPU, que podem ser acessados à velocidade total da
CPU. Em seguida, vem a memória cache, que está na faixa de 32 KB a alguns megabytes. A memória vem logo
após, hoje com tamanhos que vão de 1 GB para sistemas básicos até centenas de gigabytes na extremidade mais
alta. Depois, vêm os discos magnéticos, o atual burro de carga da armazenagem permanente. Por fim, temos fitas
magnéticas e discos ópticos para armazenagem de arquivos.

À medida que descemos na hierarquia, três parâmetros aumentam. Primeiro, o tempo de acesso fica maior.
Os registradores da CPU podem ser acessados em um nanossegundo ou menos. Memórias cache demoram um
pequeno múltiplo dos registradores da CPU. Acessos à memória principal normalmente levam 10 nanossegundos.
Agora, vem uma grande lacuna, porque tempos de acesso a discos são no mínimo 10 vezes mais lentos para discos
em estado sólido e centenas de vezes mais lentos para discos magnéticos. Acessos a fitas ou discos óticos podem
ser medidos em segundos se a mídia tiver de ser buscada e inserida no drive.

### Figura 2.18 - Hierarquia de memória de cinco níveis.

                 /  \
                /----\
               / Reg  \  <-- Dentro da CPU (Velocidade Extrema)
              /--------\
             /  Cache   \ <-- L1, L2, L3 (Onde seu IDS brilha)
            /------------\
           / Mem. Principal\ <-- DIMM de 4GB (Seu Ubuntu roda aqui)
          /----------------\
         / SSD / Disco Mag. \ <-- Armazenamento Persistente
        /--------------------\
       / Fita / Disco Óptico  \ <-- Backup (Arquivamento)
      /------------------------\

    ![alt text](image-88.png)

### Conexão com seu "Projeto IDS"
Ao documentar essas figuras, você explica por que o seu analisador de pacotes atinge taxas altas (como os 12.165 pacotes/seg que você registrou):

 - Pipeline/Superescalar: Permite que o código de checagem de IP e o de log rodem quase em paralelo.

 - Hierarquia: O seu objetivo é manter as regras de filtragem sempre nos Registradores ou na Cache (topo da pirâmide 2.18) para evitar o atraso da Memória Principal.

Segundo, a capacidade de armazenagem aumenta à medida que descemos na hierarquia. Registradores de
CPU são bons para, talvez, 128 bytes, caches para algumas dezenas de megabytes, memórias principais para
alguns gigabytes, discos em estado sólido para centenas de gigabytes e discos magnéticos para terabytes. Fitas
e discos ópticos costumam ser mantidos off-line, portanto, sua capacidade é limitada apenas pelo orçamento
do usuário.

Terceiro, o número de bits por dólar gasto aumenta descendo a hierarquia. Embora os preços atuais mudem
com rapidez, a memória principal é medida em dólares/megabyte, o disco em estado sólido em dólares/gigabyte
e a armazenagem em disco magnético e fita em centavos/gigabyte.

Já vimos registradores, cache e memória principal. Nas seções seguintes, vamos examinar os discos magnéticos
e os discos em estado sólido; depois, estudaremos os discos óticos. Não estudaremos fitas porque são raramente
usadas, exceto para cópias de segurança (backup) e, de qualquer forma, não há muita coisa a dizer sobre elas.

## 2.3.2 Discos magnéticos
Um disco magnético é composto de um ou mais pratos de alumínio com um revestimento magnetizável.
No início, esses pratos tinham até 50 cm de diâmetro, mas agora têm normalmente de 3 a 9 cm, e discos para
notebooks já estão com menos de 3 cm e continuam encolhendo. Um cabeçote de disco que contém uma bobina
de indução flutua logo acima da superfície, apoiado sobre um colchão de ar. Quando uma corrente positiva ou
negativa passa pelo cabeçote, ele magnetiza a superfície logo abaixo dele, alinhando as partículas magnéticas para
a esquerda ou para a direita, dependendo da polaridade da corrente. Quando o cabeçote passa sobre uma área
magnetizada, uma corrente positiva ou negativa é induzida nele, o que possibilita a leitura dos bits armazenados
antes. Assim, à medida que o prato gira sob o cabeçote, uma corrente de bits pode ser escrita e mais tarde lida. A
geometria de uma trilha de disco é mostrada na Figura 2.19.

### Figura 2.19 Porção de uma trilha de disco. Dois setores são ilustrados.



![alt text](image-90.png)

Todos os discos têm braços móveis que podem se mover para dentro e para fora a diferentes distâncias
radiais da haste ao redor da qual o prato gira. A cada distância radial pode ser escrita uma trilha diferente.
Assim, as trilhas são uma série de círculos concêntricos ao redor da haste. A largura de uma trilha depende
da largura do cabeçote e da precisão com que ele pode ser posicionado radialmente. Com tecnologia atual, os
discos têm em torno de 50 mil trilhas por centímetro, resultando em larguras de trilha na faixa de 200 nanô-
metros (1 nanômetro = 1/1.000.000 mm). Deve-se notar que uma trilha não é um sulco físico na superfície,
mas apenas um anel de material magnetizado com pequenas áreas de proteção que o separa das trilhas que
estão dentro e fora dele.

A densidade linear de bits ao redor da circunferência da trilha é diferente da radial. Em outras palavras, o
número de bits por milímetro medida em torno de uma trilha é diferente do número de bits por milímetro a partir
do centro em direção à borda externa. A densidade ao redor de uma trilha é determinada em grande parte pela
pureza da superfície e pela qualidade do ar. Os discos de hoje atingem densidades de 25 gigabits/cm. A densidade
radial é determinada pela precisão que o braço pode ter para chegar a uma trilha. Assim, um bit é muitas vezes
maior na direção radial em comparação com a circunferência, conforme sugere a Figura 2.19.

Para atingir densidades ainda mais altas, os fabricantes de discos estão desenvolvendo tecnologias nas quais a
dimensão “longa” dos bits não está ao longo da circunferência do disco, mas na direção vertical, dentro do óxido
de ferro. Essa técnica é denominada gravação perpendicular e demonstrou-se que pode oferecer densidades de
dados de até 100 gigabits/cm. É provável que essa se torne a tecnologia dominante nos próximos anos.

Para conseguir alta qualidade de superfície e ar, a maioria dos discos é selada na fábrica para evitar a
entrada de pó. Esses drives eram denominados discos Winchester, pois os primeiros deles (criados pela IBM)
tinham 30 MB de armazenagem selada e fixa e 30 MB de armazenagem removível. Conta a história que esses
discos 30-30 lembravam às pessoas os rifles Winchester 30-30, que desempenharam um papel importante na
abertura das fronteiras norte-americanas, e o nome “Winchester” ficou. Agora, eles são chamados simples-
mente de discos rígidos, para diferenciá-los dos antigos disquetes (ou discos flexíveis) usados nos primeiros
computadores pessoais. Nessa área, é muito difícil escolher um nome para alguma coisa que não se torne
ridículo 30 anos depois.

A maioria dos discos é composta de vários pratos empilhados na vertical, como ilustrado na Figura 2.20.
Cada superfície tem seu próprio braço e cabeçote. Os braços são agrupados de modo que todos se movimentem
para diferentes posições radiais ao mesmo tempo. O conjunto de trilhas em uma dada posição radial é denomi-

### Figura 2.20 - Disco com quatro pratos.

![alt text](image-89.png)