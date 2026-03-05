Algoritmo "memoria_ram"

var
  // No Portugol/VisuAlg, definimos o intervalo do vetor assim:
  memoria: vetor [0..9] de inteiro
  endereco: inteiro

inicio
  // Atribuindo valores aos endereços de memória (0 a 9)
  memoria[0] <- 3
  memoria[1] <- 21
  memoria[2] <- 64
  memoria[3] <- 83
  memoria[4] <- 44
  memoria[5] <- 50
  memoria[6] <- 67
  memoria[7] <- 96
  memoria[8] <- 37
  memoria[9] <- 74

  escreval("Endereço | Valor")
  escreval("-----------------")

  // Percorrendo o vetor para exibir o conteúdo
  para endereco de 0 ate 9 faca
     escreval("    ", endereco, "    |  ", memoria[endereco])
  fimpara

fimalgoritmo