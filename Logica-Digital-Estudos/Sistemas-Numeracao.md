Tabela de Equivalência entre Bases

Decimal | Binário | Octal | Hexadecimal
------- | ------- | ----- | -----------
0       | 0000    | 0     | 0
1       | 0001    | 1     | 1                  
2       | 0010    | 2     | 2
3       | 0011    | 3     | 3
4       | 0100    | 4     | 4
5       | 0101    | 5     | 5
6       | 0110    | 6     | 6
7       | 0111    | 7     | 7
8       | 1000    | 10    | 8
9       | 1001    | 11    | 9
10      | 1010    | 12    | A
11      | 1011    | 13    | B
12      | 1100    | 14    | C
13      | 1101    | 15    | D
14      | 1110    | 16    | E
15      | 1111    | 17    | F
16      | 10000   | 20    | 10
17      | 10001   | 21    | 11
18      | 10010   | 22    | 12
19      | 10011   | 23    | 13
20      | 10100   | 24    | 14

## Sequência Binária

0 +  1 = 1
1 +  1 = 10
10 + 1 = 11
11 + 1 = 100       11 
                  + 1
                  100
100 + 1 = 101
101 + 1 = 110     101
                  + 1
                  110
110 + 1 = 111
111 + 1 = 100     111
                   +1
                 1000

## Conversão de bases

1) Conversão de binário para octal
Para converter um número binário em octal, é preciso agrupar os dígitos binários em grupos de três, da direita para esquerda.

 * 3Nbin -> Em seguida, podemos converter cada grupo de trẽs dígitos em um dígito ocatal, conforme tabela de equivalência apresentada.

   EX1:.  101111011101                  EX2:.  1101011011

   101 111 011 101 = 5735, na base 8         001 101 011 011 = 1533, na base 8       
    5   7   3   5                             1   5   3   3

2) Conversão de binaŕio para hexadecimal
Para converter um número binário em hexadecimal, é preciso agrupar os dígitos binários em grupos de quatro números, da direita para esquerda.

 * 4Nbin -> Em seguida, podemos converter cada grupo de quatro dígitos binários em um dígito hexadecimal, conforme tabela de equivalência apresentada.

   EX1:.  101111011101

   1011 1101 1101 = BDD, na base 16
     B    D    D    

3) Conversão de binário (ou qualquer base) para decimal.

M2Enoi -> Então par converter um número binário para decimal, basta escrever o número binárioe, para cada dígito, multiplica por 2 e elevar pelo número da ordem inversa, começando em zero, sempre da direita para a esquerda.

Converter o número binário 10110 para decimal.

EX:.    1        0         1         1         0 
        1x2   +  0x2   +   1x2   +   1x2   +   0x2
        1x2^4 +  0x2^3 +   1x2^2 +   1x2^1 +   0x2^0

         16   +  0     +   4     +    2    +   0    = 22, na base decimal.

EX:.    101101 b=2, n = 6

M2Enoi  1        0         1         1           0           1
        1x2   +  0x2   +   1x2   +   1x2    +    0x2    +    1x2
        1x2^5 +  0x2^4 +   1x2^3 +   1x2^2  +    0x2^1  +    1X2^0
          32  +    0   +     8   +      4   +       0   +      1   = 45, na base 10.

- Conversão de octal para decima.

EX:.  27 = ? na base 10        b = 8, n = 2

M8Eoi - 2x8¹  +  7x8⁰  = 16 + 7 = 23, na base 10.

-  Concwersão de hexadecimal para decimal

M16Eoi - 2A5 = ? na base 16   b =16, n = 3

         2x16² + 10x16¹ +  5x16⁰ 
          512  +  160   +    5    = 677, na base 10


4) Conversão de decimal para binário.

EX:. Converter o número decimal 22 para binário

Ds2Sob - Divisões sucessivas por dois, depois pega os restos de cada uma dessas divisões de baixo para cima

22 / 2 -> Resto 0
11 / 2 -> Resto 1 
5 / 2  -> Resto 1 
2 / 2  -> Resto 0
1 / 2  -> Resto 1 -----> 10110

Para converter um número decimal em uma base diferente, você deve dividir o número decimal pelo valor da nova base, anotar o resto da divisão e continuar dividindo o resultado da divisão anterior até que o quociente seja menor que a nova base. Em seguida, anote os restos das divisões em ordem revresa. Essa será o número na nova base.

5) Conversão de decimal para hexadecimal:

EX:. Converter o número decimal 22 para hexadecimal

Ds16Sob - 

    22 / 16 -> Resto 6
    1 / 16  -> Resto 1  -----> 16

6) Conversão de decimal para octal:

EX:. Converter o número decimal 22 para octal

Da8Sob -

    22 / 8 -> Resto 6
    2  / 8 -> Resto 2  -----> 26

## Conversões de bases

1) Conversão de binário para octal  **3Nbin**
2) Conversão de binário para hexadecimal **4Nbin**
3) Conversão de binário (qualquer base) para decimal **M2Enoi**
  - Octal para decimal **M8Enoi**
  - Hexadecimal para decimal **M16Enoi**
4) Conversão de decimal para binário **Ds2Sob**
5) Conversão de decimal para hexadecimal **Ds16Sob**
6) Conversão de decimal para octal **Ds8Sob**

Exemplos:. a) 8 em binário  -> 1000
           b) Uma memória RAM, aparece um endereço em hexadecimal A6, converter p/ base decimal -> 166
           c) 111 + 110 -> 1101

1) Converter os seguintes valores decimais em valores binários e hexadecimais:

a) 329₁₀
- Binário: 101001001₂
- Hexadecimal: 149₁₆

b) 284₁₀
- Binário: 100011100₂
- Hexadecimal: 11C₁₆

c) 473₁₀
- Binário: 111011001₂
- Hexadecimal: 1D9₁₆

d) 69₁₀
- Binário: 1000101₂
- Hexadecimal: 45₁₆

e) 135₁₀
- Binário: 10000111₂
- Hexadecimal: 87₁₆ 🚀

2) Converter os seguintes valores binários em valores decimais, octais e hexadecimais:

## a) 11011101010₂
- Decimal: 1770₁₀
- Octal: 3352₈
- Hexadecimal: 6EA₁₆

## b) 11001101101₂
- Decimal: 1645₁₀
- Octal: 3155₈
- Hexadecimal: 66D₁₆

## c) 1000001111₂
- Decimal: 527₁₀
- Octal: 1017₈
- Hexadecimal: 20F₁₆

## d) 11101100010₂
- Decimal: 1906₁₀
- Octal: 3552₈
- Hexadecimal: 772₁₆

## e) 111001101001₂
- Decimal: 3673₁₀
- Octal: 7131₈
- Hexadecimal: E59₁₆

        

    
      
