Aqui está uma versão equivalente do código Java em Python, juntamente com um exemplo de uso do modelo de autenticação:

```python
class LoginSecurityKernel:
    loggedInUsers = {}
    MAX_PARTICIPANTS_PER_UNIT = 7
    MAX_UNITS = 300

    @staticmethod
    def login(username, password):
        # Lógica de autenticação
        isAuthenticated = LoginSecurityKernel.authenticate_user(username, password)

        # Se autenticado com sucesso, registra o usuário logado
        if isAuthenticated:
            LoginSecurityKernel.loggedInUsers[username] = LoginSecurityKernel.loggedInUsers.get(username, 0) + 1

        return isAuthenticated

    @staticmethod
    def logout(username):
        # Remove o usuário da lista de usuários logados ao fazer logout
        if username in LoginSecurityKernel.loggedInUsers:
            LoginSecurityKernel.loggedInUsers[username] -= 1
            if LoginSecurityKernel.loggedInUsers[username] == 0:
                del LoginSecurityKernel.loggedInUsers[username]
            return True
        return False

    @staticmethod
    def is_token_closed():
        # Verifica se o número de unidades ativas é menor ou igual a 300
        return len(LoginSecurityKernel.loggedInUsers) <= LoginSecurityKernel.MAX_UNITS

    @staticmethod
    def can_join_unit(username):
        # Verifica se o número de participantes na unidade atual é menor que 7
        return LoginSecurityKernel.loggedInUsers.get(username, 0) < LoginSecurityKernel.MAX_PARTICIPANTS_PER_UNIT

    @staticmethod
    def authenticate_user(username, password):
        # Lógica de autenticação - a ser implementada de acordo com requisitos específicos
        return True  # Simulação de autenticação bem-sucedida


# Exemplo de uso do modelo de autenticação
username = "user123"
password = "password123"

if LoginSecurityKernel.login(username, password):
    print("Login successful")
    if LoginSecurityKernel.can_join_unit(username):
        print("User can join unit")
    else:
        print("Unit is full")
else:
    print("Login failed")

# Simulação de logout
LoginSecurityKernel.logout(username)

# Verifica se o token está fechado
if LoginSecurityKernel.is_token_closed():
    print("Token is closed")
else:
    print("Token is still open")
```

Este código Python replica a funcionalidade do código Java, fornecendo métodos para login, logout, verificação de fechamento do token e verificação de participação na unidade. O modelo de autenticação é simulado retornando sempre `True` na função `authenticate_user`, mas você pode substituir essa lógica pela autenticação real que deseja implementar.