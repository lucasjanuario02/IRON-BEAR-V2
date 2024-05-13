Para adaptar este código para o protocolo NBH, precisaremos fazer algumas modificações para integrar a autenticação de chaves NBH. Vou fornecer um exemplo básico de como isso pode ser feito:

```dart
import 'package:web3dart/web3dart.dart';
import 'package:nbh_auth/nbh_auth.dart';

class TES {
  String name = "Token de Margem de 6 Meses";
  String symbol = "TES";
  BigInt annualInterestRate = BigInt.from(90); // 0.9% expresso em pontos-base
  BigInt secondsInYear = BigInt.from(31536000); // Número de segundos em um ano
  BigInt totalSupply = BigInt.zero;
  BigInt releaseDate = BigInt.zero; // Data de liberação dos fundos
  EthereumAddress contractAddress;
  Web3Client client;
  NBHAuthenticator authenticator;

  TES(this.client, this.contractAddress, this.authenticator);

  Future<BigInt> deposit(BigInt amount) async {
    EthereumAddress from = await authenticator.getAccount();
    final function = ContractFunction(
      'deposit',
      [],
      [BigIntType()],
    );
    final response = await client.sendTransaction(
      Transaction.callContract(
        contract: DeployedContract(
          ContractAbi.fromJson(abi, 'TES'),
          contractAddress,
        ),
        function: function,
        parameters: [amount],
        from: from,
      ),
    );
    return response;
  }

  Future<BigInt> withdraw(BigInt amount) async {
    EthereumAddress from = await authenticator.getAccount();
    final function = ContractFunction(
      'withdraw',
      [],
      [BigIntType()],
    );
    final response = await client.sendTransaction(
      Transaction.callContract(
        contract: DeployedContract(
          ContractAbi.fromJson(abi, 'TES'),
          contractAddress,
        ),
        function: function,
        parameters: [amount],
        from: from,
      ),
    );
    return response;
  }

  Future<BigInt> getBalance(EthereumAddress account) async {
    final function = ContractFunction(
      'balanceOf',
      [],
      [AddressType()],
    );
    final response = await client.call(
      contract: DeployedContract(
        ContractAbi.fromJson(abi, 'TES'),
        contractAddress,
      ),
      function: function,
      params: [account],
    );
    return response.single as BigInt;
  }

  Future<BigInt> getTokenBalance(EthereumAddress account) async {
    final function = ContractFunction(
      'tokenBalanceOf',
      [],
      [AddressType()],
    );
    final response = await client.call(
      contract: DeployedContract(
        ContractAbi.fromJson(abi, 'TES'),
        contractAddress,
      ),
      function: function,
      params: [account],
    );
    return response.single as BigInt;
  }

  static final List<dynamic> abi = [
    // Aqui vai a ABI do contrato TES
  ];
}
```

Neste exemplo:

- Foi adicionado um parâmetro `authenticator` ao construtor da classe `TES` para permitir a autenticação de chaves NBH.
- Em vez de extrair diretamente o endereço da conta do cliente, agora usamos o método `getAccount()` do autenticador para obter o endereço da conta autenticada.
- Certifique-se de usar a biblioteca `nbh_auth` para fornecer a implementação do autenticador NBH, conforme necessário.

Esta é uma adaptação básica para integrar a autenticação de chaves NBH ao seu contrato TES. Certifique-se de ajustar a implementação conforme necessário para atender às suas necessidades específicas.