// Simulando a memória RAM com um Array (Vetor)
let memoria = [3, 21, 64, 83, 44, 50, 67, 96, 37, 74];

// Exibindo os valores como se fosse o pente de memória
console.log("Endereço | Valor");
memoria.forEach((valor, endereco) => {
    console.log(`   ${endereco}     |  ${valor}`);
});

