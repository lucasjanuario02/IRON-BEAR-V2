Para configurar o arquivo JavaScript para se conectar à rede NBH usando a biblioteca `aws-sdk`, você precisa definir as credenciais AWS e criar uma instância do serviço EC2 para interagir com as instâncias da AWS.

Aqui está um exemplo de como você pode fazer isso:

```javascript
const AWS = require('aws-sdk');

// Configuração das credenciais AWS
AWS.config.update({
  accessKeyId: 'YOUR_ACCESS_KEY_ID',
  secretAccessKey: 'YOUR_SECRET_ACCESS_KEY',
  region: 'YOUR_AWS_REGION'
});

// Cria uma instância do serviço EC2
const ec2 = new AWS.EC2();

// Função para listar todas as instâncias EC2
async function listInstances() {
  try {
    const params = {
      Filters: [
        {
          Name: 'tag:Name', // Filtro por nome da instância (opcional)
          Values: ['YOUR_INSTANCE_NAME']
        }
      ]
    };

    const data = await ec2.describeInstances(params).promise();
    console.log('Instances:', JSON.stringify(data, null, 2));
  } catch (err) {
    console.error('Error listing instances:', err);
  }
}

// Função para iniciar uma instância EC2
async function startInstance(instanceId) {
  try {
    const params = {
      InstanceIds: [instanceId]
    };

    const data = await ec2.startInstances(params).promise();
    console.log('Instance started successfully:', JSON.stringify(data, null, 2));
  } catch (err) {
    console.error('Error starting instance:', err);
  }
}

// Função para parar uma instância EC2
async function stopInstance(instanceId) {
  try {
    const params = {
      InstanceIds: [instanceId]
    };

    const data = await ec2.stopInstances(params).promise();
    console.log('Instance stopped successfully:', JSON.stringify(data, null, 2));
  } catch (err) {
    console.error('Error stopping instance:', err);
  }
}

// Chamadas de função para listar, iniciar e parar instâncias EC2
listInstances();
// startInstance('INSTANCE_ID');
// stopInstance('INSTANCE_ID');
```

Certifique-se de substituir `'YOUR_ACCESS_KEY_ID'`, `'YOUR_SECRET_ACCESS_KEY'`, `'YOUR_AWS_REGION'`, e `'YOUR_INSTANCE_NAME'` com suas próprias credenciais, região e nome da instância EC2 na AWS. Além disso, descomente e ajuste as chamadas de função `startInstance` e `stopInstance` conforme necessário para iniciar e parar as instâncias EC2.