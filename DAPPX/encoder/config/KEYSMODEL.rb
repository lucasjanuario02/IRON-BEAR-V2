Para adaptar o código para a adição de uma chave unitária para cada usuário usando NBH (Nearest-Plane Heuristic), podemos modificar a classe `Lattice` para incluir métodos para adicionar chaves e gerar uma chave unitária para cada usuário. Aqui está uma versão adaptada do código:

  ```ruby
  require 'bigdecimal'
  
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
  
    # Método para adicionar uma chave unitária para cada usuário na rede de lattice
    def add_user_key(user_index, key)
      @vectors.each_with_index do |vector, i|
        vector[user_index] += key[i]
      end
    end
  
    private
  
    def round(num, denom)
      r = BigDecimal(num.to_s) % BigDecimal(denom.to_s)
      num += 1 if r > 0.5
    end
  end
  
  # Exemplo de uso:
  # Suponha que tenhamos uma rede de lattice e queremos adicionar uma chave unitária para cada usuário
  # Vamos criar uma nova instância de Lattice com vetores, inverso e determinante específicos
  vectors = [
    [BigDecimal('147946756881789319000765030803803410728'), BigDecimal('147946756881789319010696353538189108491')],
    [BigDecimal('147946756881789319020627676272574806254'), BigDecimal('-147946756881789318990833708069417712965')]
  ]
  inverse = [
    BigDecimal('147946756881789318990833708069417712965'),
    BigDecimal('147946756881789319010696353538189108491')
  ]
  det = BigDecimal('43776485743678550444492811490514550177096728800832068687396408373151616991234')
  
  lattice = Lattice.new(vectors, inverse, det)
  
  # Agora, podemos adicionar uma chave unitária para cada usuário
  # Suponha que tenhamos 2 usuários e cada chave seja uma lista de valores para cada dimensão
  user_keys = [
    [BigDecimal('100000000000000000000000000000000000000'), BigDecimal('100000000000000000000000000000000000000')],
    [BigDecimal('200000000000000000000000000000000000000'), BigDecimal('200000000000000000000000000000000000000')]
  ]
  
  # Adicionando as chaves unitárias para cada usuário na rede de lattice
  user_keys.each_with_index do |key, i|
    lattice.add_user_key(i, key)
  end
  ```
  
  Nesse código adaptado, adicionamos o método `add_user_key` à classe `Lattice`, que permite adicionar uma chave unitária para cada usuário na rede de lattice. Depois, no exemplo de uso, criamos uma instância de `Lattice` e adicionamos as chaves unitárias para cada usuário usando o método `add_user_key`.