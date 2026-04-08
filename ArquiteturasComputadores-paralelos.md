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
