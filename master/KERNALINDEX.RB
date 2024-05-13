Aqui está um exemplo básico de como você pode estruturar o arquivo `index_composer.rb` em Ruby para chamar os kernels da página principal:

```ruby
# index_composer.rb

# Require dos módulos ou classes necessárias
require_relative 'kernel1'
require_relative 'kernel2'
# Adicione outros requires conforme necessário

# Defina uma classe para o IndexComposer
class IndexComposer
  def initialize
    # Inicialize quaisquer variáveis ​​ou configurações necessárias
  end

  # Método para compor a página principal
  def compose_index
    # Chame os kernels da página principal aqui
    kernel1_result = Kernel1.execute
    kernel2_result = Kernel2.execute
    # Adicione chamadas para outros kernels conforme necessário

    # Retorne os resultados para serem usados na página principal
    {
      kernel1: kernel1_result,
      kernel2: kernel2_result
      # Adicione outros resultados conforme necessário
    }
  end
end

# Exemplo de uso:
# composer = IndexComposer.new
# index_content = composer.compose_index
# puts index_content
```

Neste exemplo:

- `require_relative` é usado para incluir os arquivos dos kernels que você deseja chamar.
- A classe `IndexComposer` é definida com um método `compose_index` que chama os kernels da página principal e retorna os resultados.
- Você precisará substituir `'kernel1'`, `'kernel2'`, etc., pelos nomes reais dos arquivos e classes dos kernels que você está usando.
- Você pode adicionar mais `require_relative` para outros kernels e mais lógica para chamar esses kernels dentro do método `compose_index`.
- No exemplo de uso no final, você pode criar uma instância do `IndexComposer`, chamar o método `compose_index` e receber os resultados para usar na página principal.

Certifique-se de ajustar isso de acordo com a estrutura e a lógica específicas do seu projeto.
