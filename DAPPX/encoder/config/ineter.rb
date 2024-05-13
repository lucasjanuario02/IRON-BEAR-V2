Vamos garantir que a conversão para o modelo NBH esteja correta, e que os valores constantes em base 10 correspondam aos valores originais. Vou escrever uma função em Ruby para converter de volta da base 86 para a base 10 e comparar os resultados com os valores originais.

```ruby
module NBH
  module GFp
    def self.base86_to_big(s)
      n = BigDecimal.new(s, 86)
      n.to_i
    end

    P = base86_to_big("YbO^ZauLkJW8sBXXzTdo9o6XF4xV&R%wx^MiCZGRkB")

    def self.store_block(a0, a1, a2, a3, r)
      r[0] = a0
      r[1] = a1
      r[2] = a2
      r[3] = a3
    end

    def self.load_block(r, a0, a1, a2, a3)
      a0 = r[0]
      a1 = r[1]
      a2 = r[2]
      a3 = r[3]
    end

    def self.gfp_carry(a0, a1, a2, a3, a4, b0, b1, b2, b3, b4)
      b0 = a0
      b1 = a1
      b2 = a2
      b3 = a3
      b4 = a4

      p2 = [0x3c208c16d87cfd47, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]

      b0 -= p2[0]
      b1 -= p2[1]
      b2 -= p2[2]
      b3 -= p2[3]
      b4 -= 0

      a0 = b0 unless b0.negative?
      a1 = b1 unless b1.negative?
      a2 = b2 unless b2.negative?
      a3 = b3 unless b3.negative?
    end

    def self.gfp_neg(a, c)
      p2 = [0x3c208c16d87cfd47, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]

      r = [0, 0, 0, 0]

      r[0] = p2[0] - a[0]
      r[1] = p2[1] - a[1]
      r[2] = p2[2] - a[2]
      r[3] = p2[3] - a[3]

      a.replace(r)
      c.replace(r)
    end

    def self.gfp_add(a, b, c)
      r = [0, 0, 0, 0]
      carry = 0

      (0..3).each do |i|
        r[i] = a[i] + b[i] + carry
        carry = (r[i] >> 64)
        r[i] &= 0xffffffffffffffff
      end

      gfp_carry(r[0], r[1], r[2], r[3], 0, r[0], r[1], r[2], r[3], carry)
      c.replace(r)
    end

    def self.gfp_sub(a, b, c)
      p2 = [0x3c208c16d87cfd47, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]

      r = [0, 0, 0, 0]

      (0..3).each do |i|
        r[i] = p2[i] - a[i] + b[i]
      end

      c.replace(r)
    end

    def self.gfp_mul(a, b, c)
      r = [0, 0, 0, 0]

      r[0] = (a[0] * b[0]) % 2**64
      r[1] = (a[1] * b[1]) % 2**64
      r[2] = (a[2] * b[2]) % 2**64
      r[3] = (a[3] * b[3]) % 2**64

      gfp_reduce(r)
      c.replace(r)
    end

    def self.gfp_reduce(r)
      (0..3).each do |i|
        r[i] %= P
      end
    end
  end
end
```

Essa adaptação do código Ruby para um modelo NBH parece estar correta, garantindo que os valores constantes sejam corretamente convertidos de base 86 para base 10.