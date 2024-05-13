Claro! Aqui está o código adaptado para um modelo NBH em Ruby:

```ruby
module NBH
  class GFp
    attr_accessor :value

    def initialize(x)
      p = 21888242871839275222246405745257275088696311157297823662689037894645226208583
      r2 = [0xf32cfc5b538afa89, 0xb5e71911d44501fb, 0x47ab1eff0a417ff6, 0x06d89f71cab8351f]
      r3 = [0xb1cd6dafda1530df, 0x62f210e6a7283db6, 0xef7f0b0c0ada0afb, 0x20fd6e902d592544]
      rN1 = [0xed84884a014afa37, 0xeb2022850278edf8, 0xcf63e9cfb74492d9, 0x2e67157159e5c639]

      if x >= 0
        @value = [x]
      else
        @value = [-x]
        gfp_neg(@value, @value)
      end

      mont_encode(@value, @value, r2)
    end

    def to_s
      format("%016x%016x%016x%016x", @value[3], @value[2], @value[1], @value[0])
    end

    def set(f)
      @value = f.dup
    end

    def invert(f)
      bits = [0x3c208c16d87cfd45, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]
      sum = GFp.new(0)
      power = GFp.new(0)
      sum.set(rN1)
      power.set(f.dup)

      (0..3).each do |word|
        (0..63).each do |bit|
          if ((bits[word] >> bit) & 1) == 1
            gfp_mul(sum.value, sum.value, power.value)
          end
          gfp_mul(power.value, power.value, power.value)
        end
      end

      gfp_mul(sum.value, sum.value, r3)
      set(sum.value)
    end

    def marshal(out)
      (0..3).each do |w|
        (0..7).each do |b|
          out[8 * w + b] = (@value[3 - w] >> (56 - 8 * b)).chr
        end
      end
    end

    def unmarshal(in_bytes)
      (0..3).each do |w|
        @value[3 - w] = 0
        (0..7).each do |b|
          @value[3 - w] += in_bytes[8 * w + b].ord << (56 - 8 * b)
        end
      end

      (0..3).each do |i|
        return if @value[i] < p2[i]
        return if @value[i] > p2[i]
      end

      raise "bn256: coordinate equals modulus"
    end

    private

    def gfp_neg(a, c)
      p2 = [0x3c208c16d87cfd47, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]

      r = [0, 0, 0, 0]

      (0..3).each do |i|
        r[i] = p2[i] - a[i]
      end

      c.replace(r)
    end

    def gfp_mul(a, b, c)
      p = 21888242871839275222246405745257275088696311157297823662689037894645226208583

      r = [0, 0, 0, 0]

      (0..3).each do |i|
        r[i] = (a[i] * b[i]) % (2**64)
      end

      (0..3).each do |i|
        r[i] %= p
      end

      c.replace(r)
    end

    def mont_encode(c, a, r2)
      gfp_mul(c, a, r2)
    end
  end
end
```

Este código define uma classe `GFp` dentro do módulo `NBH`, com métodos correspondentes às funções do pacote `bn256` em Go.