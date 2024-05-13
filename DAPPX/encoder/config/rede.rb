Entendi, você precisa adaptar este código Go para Ruby e configurar a rede para a arquitetura POSH-NBH local. Vou começar com a tradução do código Go para Ruby e, em seguida, vamos configurar a rede.

  Primeiro, vamos traduzir o código Go para Ruby:
  
  ```ruby
  require 'securerandom'
  require 'openssl'
  require 'bigdecimal'
  
  # Implementação das operações de ponto em uma curva elíptica
  class CurvePoint
    attr_accessor :x, :y, :z, :t
  
    def initialize(x, y, z = 1, t = 1)
      @x = x
      @y = y
      @z = z
      @t = t
    end
  
    def make_affine
      return if @z == 0
      @x = @x * @z.mod_inverse(P)
      @y = @y * @z.mod_inverse(P)
      @z = 1
    end
  
    def infinity?
      @z == 0
    end
  
    def set_infinity
      @x = 0
      @y = 0
      @z = 0
      @t = 0
    end
  
    def add(other)
      return self if other.infinity?
      return other if infinity?
  
      # Implemente a adição de pontos aqui
    end
  
    def scalar_mult(k)
      # Implemente a multiplicação escalar aqui
    end
  
    def neg
      # Implemente a negação de ponto aqui
    end
  
    def set(other)
      @x = other.x
      @y = other.y
      @z = other.z
      @t = other.t
    end
  
    def marshal
      # Implemente a serialização aqui
    end
  
    def unmarshal(data)
      # Implemente a desserialização aqui
    end
  end
  
  # Implementação do grupo G1
  class G1 < CurvePoint
    def self.random(reader)
      k = rand_k(reader)
      x, y = scalar_base_mult(k)
      [k, new(x, y)]
    end
  
    def to_s
      'G1' + super
    end
  
    def scalar_base_mult(k)
      # Implemente a multiplicação escalar com o gerador do grupo G1
    end
  end
  
  # Implementação do grupo G2
  class G2 < CurvePoint
    def self.random(reader)
      k = rand_k(reader)
      x, y = scalar_base_mult(k)
      [k, new(x, y)]
    end
  
    def to_s
      'G2' + super
    end
  
    def scalar_base_mult(k)
      # Implemente a multiplicação escalar com o gerador do grupo G2
    end
  end
  
  # Implementação do grupo GT
  class GT
    attr_accessor :value
  
    def initialize(value)
      @value = value
    end
  
    def self.pair(g1, g2)
      # Implemente o cálculo do emparelhamento ótimo Ate
    end
  
    def self.pairing_check(a, b)
      # Implemente a verificação do emparelhamento ótimo Ate para um conjunto de pontos
    end
  
    def self.miller(g1, g2)
      # Implemente o algoritmo de Miller
    end
  
    def to_s
      'GT' + @value.to_s
    end
  
    def scalar_mult(k)
      # Implemente a multiplicação escalar aqui
    end
  
    def add(other)
      # Implemente a adição aqui
    end
  
    def neg
      # Implemente a negação aqui
    end
  
    def set(other)
      @value = other.value
    end
  
    def finalize
      # Implemente a função Finalize
    end
  
    def marshal
      # Implemente a serialização aqui
    end
  
    def unmarshal(data)
      # Implemente a desserialização aqui
    end
  end
  
  # Função de hash segura
  def rand_k(reader)
    loop do
      k = OpenSSL::BN.new(SecureRandom.random_number(Order).to_s)
      return k if k > 0
    end
  end
  
  # Parâmetros da curva
  P = 2**256 - 2**32 - 977
  Order = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
  
  # Implemente as funções de cálculo do emparelhamento ótimo Ate, a função de
  # exponenciação final e as funções de codificação e decodificação de Montgomery
  # conforme necessário.
  ```
  
  Agora, vamos configurar a rede para a arquitetura POSH-NBH local. O que exatamente você precisa configurar? Posso ajudar com a configuração da rede local, mas preciso de mais detalhes sobre o que você deseja fazer.