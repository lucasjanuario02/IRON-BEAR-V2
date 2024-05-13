Aqui está o código combinado em um único arquivo:

```dart
import 'dart:typed_data';
import 'package:convert/convert.dart';

class Blake2bfMessageDigest {
  Uint8List _buffer = Uint8List(213);
  int _bufferIndex = 0;
  Uint8List _digest = Uint8List(64);

  Uint8List digest() {
    if (_bufferIndex != 213) {
      throw Exception('Buffer not filled with 213 bytes');
    }
    var blake2f = Blake2f();
    blake2f.update(_buffer);
    return blake2f.digest();
  }

  void update(int value) {
    _buffer[_bufferIndex++] = value;
    if (_bufferIndex > 213) {
      throw Exception('Buffer overflow');
    }
  }

  void updateBytes(Uint8List bytes, int offset, int length) {
    for (var i = offset; i < offset + length; i++) {
      update(bytes[i]);
    }
  }

  void updateBigEndianInt(int value) {
    var byteList = Uint8List(4);
    byteList[0] = (value >> 24) & 0xff;
    byteList[1] = (value >> 16) & 0xff;
    byteList[2] = (value >> 8) & 0xff;
    byteList[3] = value & 0xff;
    updateBytes(byteList, 0, 4);
  }

  void reset() {
    _bufferIndex = 0;
  }
}

void main() {
  var messageDigest = Blake2bfMessageDigest();

  // Testes
  for (var i = 0; i < 213; i++) {
    messageDigest.update(0);
  }
  print(hex.encode(messageDigest.digest())); // Imprime o digest esperado

  // Mais testes aqui...
}

// Classe Blake2f e suas dependências devem ser incluídas aqui para que o código seja executado com sucesso.
``` 

Certifique-se de incluir a classe `Blake2f` e suas dependências para que o código seja executado corretamente.