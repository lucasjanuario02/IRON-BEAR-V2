Para adaptar este código para o protocolo NBH de autenticação de chaves, precisaremos fazer algumas modificações para incorporar a funcionalidade de autenticação de chaves. Vou começar adicionando uma classe para representar as chaves e, em seguida, vamos ajustar as classes existentes e adicionar novos métodos conforme necessário.

```ruby
require 'bigdecimal'

# Classe para representar chaves
class Key
  attr_reader :public_key, :private_key

  def initialize(public_key, private_key)
    @public_key = public_key
    @private_key = private_key
  end
end

# Classe para trabalhar com lattices
class Lattice
  attr_reader :vectors, :inverse, :det

  def initialize(vectors, inverse, det)
    @vectors = vectors
    @inverse = inverse
    @det = det
  end

  def decompose(k)
    n = @inverse.length
    c = Array.new(n)

    # Calculate closest vector in lattice to <k,0,0,...> with Babai's rounding.
    (0...n).each do |i|
      c[i] = k * @inverse[i]
      round(c[i], @det)
    end

    # Transform vectors according to c and subtract <k,0,0,...>.
    out = Array.new(n)
    temp = BigDecimal(0)

    (0...n).each do |i|
      out[i] = BigDecimal(0)

      (0...n).each do |j|
        temp = c[j] * @vectors[j][i]
        out[i] += temp
      end

      out[i] = -out[i] + 2 * @vectors[0][i] + k
    end

    out[0] += k

    out
  end

  def precompute(&add)
    n = @vectors.length
    total = 1 << n

    (0...n).each do |i|
      (0...total).each do |j|
        add.call(i, j) if (j >> i) & 1 == 1
      end
    end
  end

  def multi(scalar)
    decomp = decompose(scalar)

    max_len = 0
    decomp.each do |x|
      max_len = x.to_s(2).length if x.to_s(2).length > max_len
    end

    out = Array.new(max_len, 0)
    decomp.each_with_index do |x, j|
      x.to_s(2).chars.each_with_index do |bit, i|
        out[i] += bit.to_i * (1 << j)
      end
    end

    out
  end

  private

  def round(num, denom)
    r = BigDecimal(num.to_s) % BigDecimal(denom.to_s)
    num += 1 if r > 0.5
  end
end

# Chaves para a curva
curve_key = Key.new(curve_lattice, target_lattice)
```

Neste ponto, a classe `Key` foi adicionada para representar as chaves pública e privada, e a variável `curve_key` foi inicializada com as chaves para a curva. Agora, podemos continuar a ajustar o código conforme necessário para a autenticação de chaves usando o protocolo NBH. Se precisar de mais assistência com isso, por favor, me avise!