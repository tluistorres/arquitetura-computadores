# Tabela Verdade

Uma Tabela Verdade é uma ferramenta fundamental na lógica digital, na teoria dos circuitos booleanos e na eletrônica digital. Ela é usada para representar as saídas de uma função lógica (ou porta lógica) para todas as combinações possíveis de entradas.

Elas são úteis para verificar a validade de proposições lógicas, construir circuitos lógicos(fazer testes) e simplificar e simplificar expressões booleanas.

## O que é uma Tabela Verdade?
Uma Tabela Verdade é uma tabela que lista todas as combinações possíveis de entradas de uma função lógica e as saídas correspondentes. Ela é usada para:

* Definir a função lógica
* Analisar o comportamento da função
* Simplificar a função
* Implementar a função em circuitos digitais

## Como funciona?
Uma Tabela Verdade é composta por:

* *Entradas*: São as variáveis de entrada da função lógica. Cada entrada pode ter um valor de 0 (falso) ou 1 (verdadeiro).
* *Saídas*: É o resultado da função lógica para cada combinação de entradas.

## Exemplo
Vamos considerar uma porta lógica AND com duas entradas (A e B):

| A | B | Saída |
| --- | --- | --- |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

Nesse exemplo, a saída é 1 apenas quando ambas as entradas (A e B) são 1.

## Tipos de Tabelas Verdade
Existem diferentes tipos de Tabelas Verdade, incluindo:

* Tabela Verdade de uma porta lógica (AND, OR, NOT, etc.)
* Tabela Verdade de uma função lógica complexa
* Tabela Verdade de um circuito digital

## Importância
A Tabela Verdade é uma ferramenta fundamental na eletrônica digital e na ciência da computação, pois permite:

* Analisar e projetar circuitos digitais
* Implementar funções lógicas complexas
* Verificar a corretude de circuitos digitais

# Tabela Verdade

Uma Tabela Verdade é uma ferramenta fundamental na lógica digital e na eletrônica digital. Ela é usada para representar as saídas de uma função lógica (ou porta lógica) para todas as combinações possíveis de entradas.

## O que é uma Tabela Verdade?
Uma Tabela Verdade é uma tabela que lista todas as combinações possíveis de entradas de uma função lógica e as saídas correspondentes. Ela é usada para:

* Definir a função lógica
* Analisar o comportamento da função
* Simplificar a função
* Implementar a função em circuitos digitais

## Lógica Proposicional
Com o uso desta tabela é possível definir o valor lógico de uma proposição, isto é, aber quando uma sentença é verdadeira ou falsa.

## Proposições
* *Proposição Simples*: É uma afirmação que pode ser verdadeira (V) ou falsa (F). Não fazem usos de conectivos lógicos,com excessão do conectivo de negação.
 p: "O céu é azul".
 q: "Camila é estudiosa".
 r: "O número  é ímpar'.

* *São representadas por letras minúsculas*.

* *Proposição Composta*: É uma combinação de proposições simples usando dois ou mais conectivos lógicos. 
 P: "O céu é azul E o sol brilha".
 Q: "Se hoje é segunda-feira, então amanhã é terça-feira."
 R: "Se x não é maior que y, então x é igual a y ou x é menor que y."
 S: "Antônio é casado ou João é solteiro."

 * *São representadas por letras maiúsculas*.

As proposições representam pensamentos completos e indicam afirmações de fatos ou ideias.
Para combinar proposições simples e formar proposições compostas são utilizados conectivos lógicos.

## Conectivos Lógicos 
São utilizados para combinar ou ,odificar proposições lógicas. Eles são fundamentais para a construção de expressões booleanas e o raciocínio lógico.

| Conectivo | Símbolo | Significado |
| --- | --- | --- |
| Negação | ~ | Não |                   -> p: Antõnio não é casado.
| Conjunção | ∧ | E |                   -> Q: Alexandre é alto e Elivelton é baixo.
| Disjunção | ∨ | Ou |                  -> R: Maria é a melhor ou Joana é a pior.
| Condicional | → | Se... então |       -> S: Se está calor, então vai chove.           
| Bicondicional | ⇔ | Se e somente se | -> T: João vai a praia se, e somente se, Juca tocar violão.

| Conectivo | Símbolo | Operação Lógica | Valor Lógico |
| --- | --- | --- | --- |
| não | ~ | negação | Terá valor falso quando a proposição for verdadeira e vice-versa. |
| e | ∧ | conjunção | Será verdadeira somente quando todas as proposições forem verdadeiras. |
| ou | ∨ | disjunção | Será verdadeira quando pelo menos uma das proposições for verdadeira. |
| se...então | → | condicional | Será falsa quando a proposição antecedente for verdadeira e a consequente for falsa. |
| ...se somente se... | ↔ | bicondicional | Será verdadeira quando ambas as proposições forem verdadeiras ou ambas falsas. |

Explicação dos Conectivos
* *Negação (~)*: Inverte o valor lógico de uma proposição.
* *Conjunção (∧)*: Combina duas proposições que devem ser ambas verdadeiras para resultar em verdadeiro.
* *Disjunção (∨)*: Combina duas proposições onde pelo menos uma deve ser verdadeira para resultar em verdadeiro.
* *Condicional (→)*: Estabelece uma relação de implicação entre duas proposições.
* *Bicondicional (↔)*: Estabelece que duas proposições têm o mesmo valor lógico.

### Tabela-verdade da negação:
    - Se uma proposição \( p \) é Verdadeira (V), sua negação \( \sim p \) é Falsa (F).
    - Se \( p \) é Falsa (F), \( \sim p \) é Verdadeira (V).

| p   | ~p  |
|-----|-----|
| V   | F   |
| F   | V   |

## Exemplo Prático
Se *p = "O céu é azul"*, então:
- *~p*: "O céu não é azul".

Definição: O operador "NÃO" (NOT) transforma uma afirmação em sua oposta, ou seja, nega o valor original.

## Exemplos Práticos
- Proposição: "O céu é azul" (V)
- Negação: "O céu não é azul" (F)

- Proposição: "2 + 2 = 5" (F)
- Negação: "2 + 2 ≠ 5" (V)

- Proposição: "Eu estou com fome" (V)
- Negação: "Eu não estou com fome" (F)

- Proposição: "O sol nasce no oeste" (F)
- Negação: "O sol não nasce no oeste" (V)

Em cada exemplo, a negação inverte o valor de verdade da proposição original.

# Conjunção Lógica (E / AND)

A conjunção lógica (p ∧ q), também representada por "E" (AND), é uma operação que combina duas proposições *p* e *q. O resultado **p ∧ q* é verdadeiro *somente* quando ambas as proposições *p* e *q* são verdadeiras. Caso contrário, o resultado é falso.

## Tabela-Verdade da Conjunção

| p   | q   | p ∧ q |
|-----|-----|-------|
| V   | V   | *V* |
| V   | F   | *F* |
| F   | V   | *F* |
| F   | F   | *F* |

## Exemplo Prático
Se *p = "Está chovendo"* e *q = "Eu tenho um guarda-chuva"*, então:
- *p ∧ q: "Está chovendo **E* eu tenho um guarda-chuva" é verdadeiro apenas se ambas as condições forem verdadeiras.

# Disjunção Lógica (OU / OR)

A disjunção lógica (p ∨ q), também representada por "OU" (OR), é uma operação que combina duas proposições *p* e *q. O resultado **p ∨ q* é verdadeiro quando *pelo menos uma* das proposições *p* ou *q* é verdadeira. É falso *somente* quando ambas são falsas.

## Tabela-Verdade da Disjunção

| p   | q   | p ∨ q |
|-----|-----|-------|
| V   | V   | *V* |
| V   | F   | *V* |
| F   | V   | *V* |
| F   | F   | *F* |

## Exemplo Prático
Se *p = "Vou ao cinema"* e *q = "Vou ao teatro"*, então:
- *p ∨ q: "Vou ao cinema **OU* vou ao teatro" é verdadeiro se ele for ao cinema, ao teatro ou a ambos.

# Condicional Lógico (SE...ENTÃO / IF...THEN)

O condicional (p → q), também conhecido como implicação lógica, é uma operação lógica que afirma: *“se p, então q”*. 

## Tabela-Verdade do Condicional

| p   | q   | p → q |
|-----|-----|-------|
| V   | V   | *V* |
| V   | F   | *F* |
| F   | V   | *V* |
| F   | F   | *V* |

## Explicação do Funcionamento
1. *p → q* só é falso quando a premissa *p* é verdadeira e a conclusão *q* é falsa.
2. Se *p* é falsa, a implicação é sempre verdadeira, independentemente do valor de *q*.

## Exemplo Prático
Se *p = "Chove"* e *q = "Levo um guarda-chuva"*, então:
- *p → q*: "Se chove, então levo um guarda-chuva".
  - Verdadeiro se: chove e levo o guarda-chuva *OU* não chove (com ou sem guarda-chuva).
  - Falso se: chove e não levo o guarda-chuva.

# Bicondicional (p ↔ q)

O bicondicional *p ↔ q* (lê-se “p se e somente se q”) é uma operação lógica que estabelece uma *equivalência* entre duas proposições.

## Tabela-Verdade do Bicondicional

| p   | q   | p ↔ q |
|-----|-----|-------|
| V   | V   | *V* |
| V   | F   | *F* |
| F   | V   | *F* |
| F   | F   | *V* |

## Características do Bicondicional
1. *p ↔ q* é verdadeiro quando *p* e *q* têm o mesmo valor lógico (ambos verdadeiros ou ambos falsos).
2. É falso quando *p* e *q* têm valores lógicos diferentes.
3. Pode ser entendido como a conjunção de dois condicionais: *(p → q) ∧ (q → p)*.

## Exemplo Prático
Se *p = "Estudo"* e *q = "Aprovo"*, então:
- *p ↔ q*: "Estudo se e somente se aprovo".
  - Verdadeiro se: estudo e aprovo *OU* não estudo e não aprovo.
  - Falso se: estudo e não aprovo *OU* não estudo e aprovo.

## Tabela de Conectivos
| p | q | ¬p | p ∧ q | p ∨ q | p → q | p ⇔ q |
| --- | --- | --- | --- | --- | --- | --- |
| V | V | F | V | V | V | V |
| V | F | F | F | V | F | F |
| F | V | V | F | V | V | F |
| F | F | V | F | F | V | V |

## Tabela de Disjunção (p ∨ q)
| p | q | p ∨ q |
| --- | --- | --- |
| V | V | V |
| V | F | V |
| F | V | V |
| F | F | F |

## Tabela Condicional (p → q)
| p | q | p → q |
| --- | --- | --- |
| V | V | V |
| V | F | F |
| F | V | V |
| F | F | V |

## Tabela Bicondicional (p ⇔ q)
| p | q | p ⇔ q |
| --- | --- | --- |
| V | V | V |
| V | F | F |
| F | V | F |
| F | F | V |
