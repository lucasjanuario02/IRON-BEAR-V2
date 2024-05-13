Para incorporar toda a lógica de autenticação e interação com a blockchain Ethereum em um único código JavaScript, você pode usar a biblioteca web3.js para interagir com contratos inteligentes Ethereum. Abaixo está um exemplo de como você pode fazer isso:

```javascript
const Web3 = require('web3');

// Conexão com a blockchain Ethereum local (por exemplo, Ganache)
const web3 = new Web3('http://localhost:8545');

// Endereço e ABI do contrato de autenticação
const contractAddress = 'CONTRACT_ADDRESS';
const contractABI = [
    {
        "inputs": [],
        "name": "authenticateUser",
        "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [{ "internalType": "string", "name": "username", "type": "string" }, { "internalType": "bytes32", "name": "passwordHash", "type": "bytes32" }],
        "name": "registerUser",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Registra um novo usuário com um nome de usuário e uma senha hash
async function registerUser(username, passwordHash) {
    try {
        const accounts = await web3.eth.getAccounts();
        await contract.methods.registerUser(username, passwordHash).send({ from: accounts[0] });
        console.log(`User ${username} registered successfully`);
    } catch (error) {
        console.error('Error registering user:', error);
    }
}

// Verifica se um hash de senha corresponde a um usuário registrado
async function authenticateUser(passwordHash) {
    try {
        const result = await contract.methods.authenticateUser(passwordHash).call();
        console.log(`Authenticated user: ${result}`);
    } catch (error) {
        console.error('Error authenticating user:', error);
    }
}

// Exemplo de uso
const username = 'user123';
const passwordHash = 'PASSWORD_HASH';  // Você precisa calcular o hash da senha fora do script JS

// Registra um novo usuário
registerUser(username, passwordHash);

// Verifica se um hash de senha corresponde a um usuário registrado
authenticateUser(passwordHash);
```

Por favor, substitua `'CONTRACT_ADDRESS'` pelo endereço real do seu contrato e `'PASSWORD_HASH'` pelo hash da senha calculado fora do script JS. Certifique-se de que sua rede Ethereum local (por exemplo, Ganache) esteja em execução e acessível na URL especificada.