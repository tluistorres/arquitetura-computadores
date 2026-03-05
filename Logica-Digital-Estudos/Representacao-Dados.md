## Processamento de dados

Um computador funciona por meio da execução sistemática de instruções que o orientam a realizar algum tipo de operação sobre valores.

Esses valores são genericamente conhecidos como dados.

                         --> Dados(00110001)  
Instruções --> Operações --> Dados(00110011)
                         --> Dados(00110111)

## Processos de conversão

Notação simbólica
number = 10

Se number > 0 então                       // Linguagem natural
     writer ln("is positive")             // Linguagem de alto nível
se não                                    // Alto nível de abstração
     writer ln("is negative")

Então quando a linguagem é convertida, todo esse código vira números binários -> Linguagem de máquina,baixo nível e baixo abstração.

01010010 (82) = 10 em binário
00000010 (2) = 0 em binário
00000101 (5) = positivo em binário
00000011 (3) = negativo em binário

## Processos de Conversão e Abstração
A comunicação entre humanos e máquinas exige diferentes níveis de abstração. Enquanto nós pensamos em lógica e conceitos, o processador entende apenas variações de tensão elétrica (0 e 1).

1. Linguagem de Alto Nível
É a Notação Simbólica, próxima da linguagem natural, que facilita a escrita do programador. Possui alto nível de abstração.

number = 10
if number > 0:
    print("is positive")
else:
    print("is negative")

2. O Processo de Compilação/Interpretação
O código escrito acima passa por um tradutor que o converte em Linguagem de Máquina. Esse nível possui baixo nível de abstração e é composto puramente por números binários.

3. Representação em Baixo Nível
Na linguagem de máquina, cada instrução e cada dado possui um endereço e um valor binário específico:

Dados (Valores): O número 10 é convertido para sua representação binária correspondente (ex: 00001010).

Instruções (Operações): Comandos como "comparar" ou "imprimir" também viram sequências de bits que o Decodificador da CPU consegue interpretar.

| Conceito | Representação Simbólica | Representação Binária (Exemplo) |
| :--- | :--- | :--- |
| Variável | `number = 10` | `01010010 (Endereço) = 00001010 (Valor)` |
| Comparação | `if > 0` | `00000010 (Opcode de comparação)` |
| Resultado A | `"positive"` | `00000101` |
| Resultado B | `"negative"` | `00000011` |

Dica para o seu .md: Você sabia que a Unidade de Controle (UC) é quem decide, com base no código binário, se o dado deve ir para a ULA para um cálculo ou se deve ser apenas movido para a Memória Principal?

## Formas de representação

Existem diferentes formas de representação, cabe ao programador, conforme a própria plataforma de desenvolvimento, estabelecer a forma a ser adotada.

A representação pode ser explícita ou implícita:

  - Explícita (fortemente tipada), quando o prgramador define as variáveis e constantes em seu programa.
  - Implícita (fracamente tipada), quando é deixado para que o compilador faça a escolha.

## Tipos de dados

Definem para o sistema como cada dado deverá ser manipulado, recebendo um tratamento diferenciado pelo procesador.

  - Inteiro (Integer)

O tipo de dado inteiro é usado para representar númmeros inteiros, ou seja, números sem parte decima.

Pode ser representado em diferentes tamanhos, como 8 bits, 18 bits, 32 bits ou 64 bits, dependendo da linguagem. Exemplos de inteiros: -10, 0, 42.

O uso de 8, 16, 32 ou 64 bits para representar inteiros baseia-se na eficiência da arquitetura de computador, que agrupa bits em múltiplos de bytes (8 bits) e potências de 2 (2^{3},2^{4},2^{5},2^6. 

Essa estrutura facilita o armazenamento, aumenta exponencialmente a faixa de números (ex: 32 bits vs. 64 bits) e otimiza o processamento em ciclos. 

 - Por que múltiplos de 8? Um byte tem 8 bits, sendo a menor unidade de endereçamento de memória comum, o que simplifica o gerenciamento de dados pelo hardware.

 - A "dobra" do intervalo: Cada bit adicionado dobra a quantidade de números que podem ser representados, permitindo escalar de valores pequenos (8-bit, 0-255) para extremamente grandes (64-bit).

 - Eficiência do Processador: Processadores modernos (32 ou 64 bits) processam esses tamanhos nativamente em um único ciclo de máquina, otimizando o desempenho.

 - Uso de Memória vs. Precisão:

   - 8/16-bit: Usados em sistemas com memória limitada, IoT ou para economizar espaço.
   - 32/64-bit: Padrão para aplicações modernas, permitindo alta precisão e grandes cálculos (ex: 32-bits: (+/- 2 bilhões);  64-bits: (+/- 9 quintilhões). A escolha do tamanho é um equilíbrio entre a necessidade de representar números maiores e o uso de memória. 

Real (Ponto flutuante)

O tipo de dado ponto flutuante  é usado para representar números com parte decimal.

É útil quando precisamos de valores fracionários.

Os tipos de ponto flutuante mais comuns são o float e double, que diferem em precisão e faixa de balores que podem representar.
Exemplos de ponto flutuante são: 3.14, -0.5, 1.8 e 10 (notação científica).

## Exemplos de Notação


Os números de ponto flutuante podem ser representados de forma direta ou através de notação científica para simplificar valores muito grandes ou muito pequenos:

 - Decimal Simples: 3.14, -0.5, 1.8
 - Notação Científica: 1.0e1 (que representa 10) ou 1.23e4 (que representa 12300).

Notação (Código) | Significado Matemático | Valor Real | Descrição
---|---|---|---
1.0e1 | $1.0 \times 10^{1}$ | 10.0 | O expoente 1 desloca a vírgula uma casa para a direita. ➡️
1.23e4 | $1.23 \times 10^{4}$ | 12300.0 | O expoente 4 desloca a vírgula quatro casas para a direita. ➡️
5.0e-2 | $5.0 \times 10^{-2}$ | 0.05 | O expoente negativo desloca a vírgula para a esquerda. ⬅️

## Caracter (char)

O tipo de dado caractere é usado para representar um único caractere alfanumérico.

Geralmente, é representado entre aspas simples ou spas duplas.

Exemplos de caracteres são: 'A', 'b', '5', '@'

var 
  letra: caractere

inicio
   letra <- 'A'
   escreva(letra)
fimalgoritmo

let letra = 'A';
console.log(letra); ou mais simples

console.log('A');

Notação (Código) | Significado Matemático | Valor Real | Descrição
---|---|---|---
'A' | Código ASCII 65 | Caractere Alfanumérico | Letra maiúscula armazenada como valor numérico. 🔤
'5' | Código ASCII 53 | Caractere Alfanumérico | O dígito 5 como texto, não para cálculos. 🔢
'@' | Código ASCII 64 | Símbolo Especial | Caractere especial usado em endereços e comandos. 📧

## String

O tipo de dado string é usado para representar uma sequência de caracteres.

As strings são geralmente representadas entre aspas simples ou aspas duplas.

Exemplos de sstrings são: "Olá, mundo!".

var
   mensagem: literal

inicio
    mensagem <- "Olá, mundo!"
    escreva(mensagem)
fimalgoritmo

A String (ou Literal) é como um "trem" onde cada vagão é um caractere individual. Vamos organizar essa ideia:

Notação (Código) | Significado Matemático | Valor Real | Descrição
---|---|---|---
mensagem: literal | Vetor de Caracteres | Reserva de Bloco | O sistema reserva vários bytes em sequência na memória. 📦
"Olá, mundo!" | Cadeia de Caracteres | Conjunto de ASCII | Uma sequência de códigos binários terminada por um sinal de "fim". 🧵
escreva(mensagem) | Saída de String | Fluxo de Texto | O sistema percorre a memória exibindo cada caractere até o final da frase. 🖥️

🧠 A String por dentro
Diferente do caractere único, a string precisa de um marcador para o computador saber onde ela termina. Imagine que a memória é uma rua comprida; a string precisa de uma "placa de pare" no último caractere.

Vamos testar um conceito importante de manipulação:

Se você tem a variável mensagem <- "Olá", o computador armazena os códigos para 'O', 'l', 'á'. Se você decidisse mudar apenas o primeiro caractere para 'A', transformando em "Alá", você acha que o computador:

🔄 Substituiria apenas o código binário da primeira posição?

🆕 Teria que criar uma frase inteiramente nova na memória? Opção2.

## Booleano

O tipo Booleano (ou lógico) é o mais simples e, ao mesmo tempo, um dos mais fundamentais na computação. Ele funciona como um interruptor: ou está ligado, ou está desligado. 💡

Notação (Código) | Significado Matemático | Valor Real | Descrição
---|---|---|---
verdadeiro | Lógica Binária (1) | True | Representa uma condição satisfeita ou ligada. ✅
falso | Lógica Binária (0) | False | Representa uma condição não satisfeita ou desligada. ❌
5 > 3 | Expressão Relacional | True | O resultado de uma comparação que a ULA resolve. ⚖️

var estaLigado = true;

if (estaLigado) {
    console.log("A luz está acesa!");
} else {
    console.log("A luz está apagada.");
}

## Representação da memória

Em certo sentido, pode-se dizer que a memória RAM de um computador funciona de maneira semelhante a um vetor, com a diferença de possuir acesso direto e aleatório aos dados, sem a necessidade de percorrer as posições da memória sequencialmente.

| 0 | | 1 | | 2 | | 3 | | 4 | | 5 | | 6 | | 7 | | 8 | | 9 | ---> Endereço
|   | |   | |   | |   | |   | |   | |   | |   | |   | |   | ---> Valor
                          Vetor

As alocações e liberações da memória RAM são controladas por meio de sistemas de gerenciamento de memória, com alocação dinâmica e coleta de lixo.

Algoritmo "memória"

var
  memória: vetor[0..9] de inteiro
  endereco: inteiro

inicio
  // Atribuindo valores a diferentes "endereços de memória"
  memória[0] <- 3
  memória[1] <- 21
  memória[2] <- 64
  memória[3] <- 83
  memória[4] <- 44
  memória[5] <- 50
  memória[6] <- 67
  memória[7] <- 96
  memória[8] <- 37
  memória[9] <- 74

  // Acessando e exibindo os valores armazenados na "memória"
  para endereco de 0 ate 9 faca
     escreva(" |",memoria[endereco])
  fimpara

fimalgoritmo

Notação (Código) | Significado Matemático | Valor Real | Descrição
---|---|---|---
vetor[0..9] | Conjunto Finito | Espaço de 10 inteiros | Reserva 10 "gavetas" numeradas de 0 a 9 na memória. 📦
memoria[2] <- 64 | Atribuição por Índice | Armazenamento Direto | Coloca o valor 64 exatamente na posição 2, sem passar pela 0 ou 1. 🎯
para endereco de 0 ate 9 | Iteração Sequencial | Laço de Repetição | Percorre todas as posições para ler o que foi guardado. 🔄

## Em JavaScript

// Simulando a memória RAM com um Array (Vetor)
let memoria = [3, 21, 64, 83, 44, 50, 67, 96, 37, 74];

// Exibindo os valores como se fosse o pente de memória
console.log("Endereço | Valor");
memoria.forEach((valor, endereco) => {
    console.log(`   ${endereco}     |  ${valor}`);
});


1. Faça um algoritmo que preencha um vetor de 5 posições com números digitados pelo usuário e que em seguida mostra os valores do vetor.

2. Faça um algoritmo que preencha um vetor de 5 posições com nomes digitados pelo usuário e que em seguida mostra os valores do vetor.

3. Faça um algoritmo que preencha um vetor de 10 posições com números aleatórios entre 0 e 50 e que em seguida mostra os valores do vetor.

4. Com base no algoritmo da questão 3, adicione a possibilidade do usuário digitar um valor para ser pesquisado no vetor e em seguida mostra se o valor foi encontrado ou não.

5. Com base no algoritmo da questão 4, adicione ao algoritmo a funcionalidade de mostrar a posição do valor encontrado e a quantidade de tentativas até encontrar o valor.

Aqui estão os algoritmos solicitados na imagem, implementados em pseudocódigo (similar ao Portugol) e também em JavaScript para facilitar a execução:

### 1) Preencher um vetor de 5 posições com números digitados pelo usuário e mostrar os valores.
#### Pseudocódigo:

var vetor[5]: inteiro
inicio
  para i de 0 ate 4 faca
    escreva("Digite um número: ")
    leia(vetor[i])
  fimpara
  escreva("Valores do vetor: ")
  para i de 0 ate 4 faca
    escreva(vetor[i])
  fimpara
fimalgoritmo

#### JavaScript:

let vetor = [];
for (let i = 0; i < 5; i++) {
  vetor[i] = parseInt(prompt("Digite um número:"));
}
console.log("Valores do vetor:", vetor);

### 2) Preencher um vetor de 5 posições com nomes digitados pelo usuário e mostrar os valores.
#### Pseudocódigo:

var vetor[5]: caractere
inicio
  para i de 0 ate 4 faca
    escreva("Digite um nome: ")
    leia(vetor[i])
  fimpara
  escreva("Valores do vetor: ")
  para i de 0 ate 4 faca
    escreva(vetor[i])
  fimpara
fimalgoritmo

#### JavaScript:

let vetor = [];
for (let i = 0; i < 5; i++) {
  vetor[i] = prompt("Digite um nome:");
}
console.log("Valores do vetor:", vetor);

### 3) Preencher um vetor de 10 posições com números aleatórios entre 0 e 50 e mostrar os valores.
#### Pseudocódigo:

var vetor[10]: inteiro
inicio
  para i de 0 ate 9 faca
    vetor[i] <- aleatorio(0, 50)
  fimpara
  escreva("Valores do vetor: ")
  para i de 0 ate 9 faca
    escreva(vetor[i])
  fimpara
fimalgoritmo

#### JavaScript:

let vetor = [];
for (let i = 0; i < 10; i++) {
  vetor[i] = Math.floor(Math.random() * 51);
}
console.log("Valores do vetor:", vetor);

### 4) Pesquisar um valor no vetor da questão 3.
#### Pseudocódigo:

var vetor[10]: inteiro
var valor, encontrado: inteiro
inicio
  // Preenche vetor com aleatórios (questão 3)
  para i de 0 ate 9 faca
    vetor[i] <- aleatorio(0, 50)
  fimpara
  escreva("Digite um valor para pesquisar: ")
  leia(valor)
  encontrado <- 0
  para i de 0 ate 9 faca
    se (vetor[i] = valor) entao
      encontrado <- 1
    fimse
  fimpara
  se (encontrado = 1) entao
    escreva("Valor encontrado!")
  senao
    escreva("Valor não encontrado!")
  fimse
fimalgoritmo

#### JavaScript:

let vetor = Array(10).fill(0).map(() => Math.floor(Math.random() * 51));
let valor = parseInt(prompt("Digite um valor para pesquisar:"));
let encontrado = vetor.includes(valor);
if (encontrado) {
  console.log("Valor encontrado!");
} else {
  console.log("Valor não encontrado!");
}
### 5) Mostrar posição e tentativas do valor encontrado (baseado na questão 4).
#### Pseudocódigo:

var vetor[10]: inteiro
var valor, tentativas, posicao: inteiro
inicio
  // Preenche vetor com aleatórios (questão 3)
  para i de 0 ate 9 faca
    vetor[i] <- aleatorio(0, 50)
  fimpara
  escreva("Digite um valor para pesquisar: ")
  leia(valor)
  tentativas <- 0
  posicao <- -1
  para i de 0 ate 9 faca
    tentativas <- tentativas + 1
    se (vetor[i] = valor) entao
      posicao <- i
      interrompa
    fimse
  fimpara
  se (posicao >= 0) entao
    escreva("Valor encontrado na posição ", posicao)
    escreva("Tentativas: ", tentativas)
  senao
    escreva("Valor não encontrado!")
  fimse
fimalgoritmo

#### JavaScript:

let vetor = Array(10).fill(0).map(() => Math.floor(Math.random() * 51));
let valor = parseInt(prompt("Digite um valor para pesquisar:"));
let posicao = vetor.indexOf(valor);
let tentativas = vetor.length;
if (posicao >= 0) {
  console.log(Valor encontrado na posição ${posicao});
  console.log(Tentativas: ${tentativas});
} else {
  console.log("Valor não encontrado!");
}

