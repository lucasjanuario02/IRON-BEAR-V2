<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Wallet TES Token</title>
  <!-- Adicione qualquer folha de estilo personalizada aqui -->
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <!-- Adicione a div onde o aplicativo Flutter será incorporado -->
  <div id="flutter-app"></div>

  <!-- Adicione scripts necessários -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/flutter/2.10.0/flutter_web.js"></script>
  <script>
    // Função para configurar o token TES no aplicativo Flutter
    function configureTesToken() {
      // Chame sua função ou método Flutter para configurar o token TES aqui
      // Por exemplo:
      // MyApp.configureTesToken("TOKEN_AQUI");
    }

    // Configura o aplicativo Flutter para ser incorporado na div 'flutter-app'
    window.flutterApp = flutterWebPlatform.runApp({
      widget: MyApp(), // Substitua MyApp pelo widget principal do seu aplicativo Flutter
      // Adicione quaisquer outros parâmetros necessários aqui
      // Por exemplo:
      // token: "TOKEN_AQUI",
      onReady: configureTesToken // Chama a função de configuração do token TES quando o aplicativo estiver pronto
    });
  </script>
</body>
</html>
