Aqui está o código unificado em um único arquivo:

```dart
import 'dart:math';

class FieldElement {
  final BigInt value;
  static final BigInt fieldModulus = BigInt.parse("21888242871839275222246405745257275088696311157297823662689037894645226208583");

  FieldElement(this.value);

  FieldElement operator +(FieldElement other) {
    return FieldElement((value + other.value) % fieldModulus);
  }

  FieldElement operator -(FieldElement other) {
    return FieldElement((value - other.value) % fieldModulus);
  }

  FieldElement operator *(FieldElement other) {
    return FieldElement((value * other.value) % fieldModulus);
  }

  FieldElement operator /(FieldElement other) {
    // Calcula o inverso multiplicativo de other
    BigInt inverse = other.value.modInverse(fieldModulus);
    return FieldElement((value * inverse) % fieldModulus);
  }

  FieldElement operator ^(BigInt exponent) {
    return FieldElement(value.modPow(exponent, fieldModulus));
  }

  bool operator ==(Object other) {
    if (other is FieldElement) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return value.toString();
  }
}

class AbstractFieldPoint<U extends AbstractFieldPoint> {
  static final BigInt two = BigInt.two;

  final FieldElement x;
  final FieldElement y;

  AbstractFieldPoint(this.x, this.y);

  U infinity();

  U newInstance(FieldElement x, FieldElement y);

  bool isInfinity() {
    return x.value == BigInt.zero && y.value == BigInt.zero;
  }

  U add(U other) {
    if (isInfinity() || other.isInfinity()) {
      return isInfinity() ? other : this as U;
    } else if (this == other) {
      return doub();
    } else if (x == other.x) {
      return infinity();
    } else {
      final FieldElement x1 = x;
      final FieldElement y1 = y;
      final FieldElement x2 = other.x;
      final FieldElement y2 = other.y;

      final FieldElement m = (y2 - y1) / (x2 - x1);
      final FieldElement mSquared = m ^ BigInt.two;
      final FieldElement newX = mSquared - x1 - x2;
      final FieldElement newY = (-m * newX) + m * x1 - y1;

      return newInstance(newX, newY);
    }
  }

  U multiply(U other) {
    return null;
  }

  U multiply(BigInt n) {
    if (n == BigInt.zero) {
      return infinity();
    } else if (n == BigInt.one) {
      return newInstance(x, y);
    } else if (n % two == BigInt.zero) {
      return (doub() * (n ~/ two)) as U;
    } else {
      return (doub() * (n ~/ two) + this) as U;
    }
  }

  U doub() {
    final FieldElement xSquared = x ^ BigInt.two;
    final FieldElement m = (xSquared * BigInt.from(3)) / (y * BigInt.two);
    final FieldElement mSquared = m ^ BigInt.two;
    final FieldElement newX = mSquared - (x * BigInt.two);
    final FieldElement newY = (-m * newX) + (m * x) - y;

    return newInstance(newX, newY);
  }

  U negate() {
    if (isInfinity()) {
      return this as U;
    }

    return newInstance(x, -y);
  }

  @override
  String toString() {
    return 'x: $x, y: $y';
  }

  @override
  bool operator ==(Object other) {
    if (this == other) return true;
    if (other is! AbstractFieldPoint) return false;
    AbstractFieldPoint otherPoint = other as AbstractFieldPoint;
    return x == otherPoint.x && y == otherPoint.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Test {
  static void main() {
    // Test code here
    FieldElement a = FieldElement(BigInt.from(10));
    FieldElement b = FieldElement(BigInt.from(20));
    FieldElement c = a + b;
    print(c); // Output: 30

    // Example usage of AbstractFieldPoint
    // AbstractFieldPoint implementation is omitted for brevity
    // You can implement your concrete subclass and test it here
  }
}

void main() {
  Test.main();
}
```

Este arquivo contém as classes `FieldElement` e `AbstractFieldPoint` no mesmo arquivo, com o método de teste `Test` demonstrando a utilização da classe `FieldElement`. Certifique-se de implementar a classe `AbstractFieldPoint` de acordo com suas necessidades específicas.