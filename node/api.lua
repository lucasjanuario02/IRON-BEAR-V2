```lua
-- Define a tabela que conterá os métodos da API
local Node = {}

-- Métodos da API administrativa privada
local privateAdminAPI = {
    -- Adiciona um par de chaves
    addPeer = function(self, url)
        local server = self.node.server
        if not server then
            return false, "Nó parado"
        end
        local node, err = enode.parse(enode.ValidSchemes, url)
        if err then
            return false, "enode inválido: " .. err
        end
        server:addPeer(node)
        return true, nil
    end,
    -- Remove um par de chaves
    removePeer = function(self, url)
        local server = self.node.server
        if not server then
            return false, "Nó parado"
        end
        local node, err = enode.parse(enode.ValidSchemes, url)
        if err then
            return false, "enode inválido: " .. err
        end
        server:removePeer(node)
        return true, nil
    end,
    -- Adiciona um par de chaves confiável
    addTrustedPeer = function(self, url)
        local server = self.node.server
        if not server then
            return false, "Nó parado"
        end
        local node, err = enode.parse(enode.ValidSchemes, url)
        if err then
            return false, "enode inválido: " .. err
        end
        server:addTrustedPeer(node)
        return true, nil
    end,
    -- Remove um par de chaves confiável
    removeTrustedPeer = function(self, url)
        local server = self.node.server
        if not server then
            return false, "Nó parado"
        end
        local node, err = enode.parse(enode.ValidSchemes, url)
        if err then
            return false, "enode inválido: " .. err
        end
        server:removeTrustedPeer(node)
        return true, nil
    end,
    -- Eventos de par
    peerEvents = function(self)
        local server = self.node.server
        if not server then
            return nil, "Nó parado"
        end
        local events = server:subscribeEvents()
        return events
    end,
    -- Inicia o servidor HTTP RPC API
    startHTTP = function(self, host, port, cors, apis, vhosts)
        local node = self.node
        local config = {
            CorsAllowedOrigins = node.config.HTTPCors,
            Vhosts = node.config.HTTPVirtualHosts,
            Modules = node.config.HTTPModules
        }
        if cors then
            config.CorsAllowedOrigins = {}
            for _, origin in ipairs(cors:split(",")) do
                table.insert(config.CorsAllowedOrigins, origin:trim())
            end
        end
        if vhosts then
            config.Vhosts = {}
            for _, vhost in ipairs(vhosts:split(",")) do
                table.insert(config.Vhosts, vhost:trim())
            end
        end
        if apis then
            config.Modules = {}
            for _, m in ipairs(apis:split(",")) do
                table.insert(config.Modules, m:trim())
            end
        end
        node.http:setListenAddr(host or node.config.HTTPHost, port or node.config.HTTPPort)
        node.http:enableRPC(node.rpcAPIs, config)
        node.http:start()
        return true, nil
    end,
    -- Inicia o servidor WebSocket RPC API
    startWS = function(self, host, port, allowedOrigins, apis)
        local node = self.node
        local config = {
            Modules = node.config.WSModules,
            Origins = node.config.WSOrigins
        }
        if apis then
            config.Modules = {}
            for _, m in ipairs(apis:split(",")) do
                table.insert(config.Modules, m:trim())
            end
        end
        if allowedOrigins then
            config.Origins = {}
            for _, origin in ipairs(allowedOrigins:split(",")) do
                table.insert(config.Origins, origin:trim())
            end
        end
        local server = node:wsServerForPort(port or node.config.WSPort, false)
        server:setListenAddr(host or node.config.WSHost, port or node.config.WSPort)
        local openApis, _ = node:GetAPIs()
        server:enableWS(openApis, config)
        server:start()
        node.http.log:info("Ponto de extremidade WebSocket aberto", "url", node:WSEndpoint())
        return true, nil
    end,
    -- Interrompe todos os servidores WebSocket
    stopWS = function(self)
        self.node.http:stopWS()
        self.node.ws:stop()
        return true, nil
    end
}

-- Métodos da API administrativa pública
local publicAdminAPI = {
    -- Pares
    peers = function(self)
        local server = self.node.server
        if not server then
            return nil, "Nó parado"
        end
        return server:peersInfo(), nil
    end,
    -- Informações do nó
    nodeInfo = function(self)
        local server = self.node.server
        if not server then
            return nil, "Nó parado"
        end
        return server:nodeInfo(), nil
    end,
    -- Diretório de dados
    datadir = function(self)
        return self.node:dataDir()
    end
}

-- Métodos da API Web3 pública
local publicWeb3API = {
    -- Versão do cliente
    clientVersion = function(self)
        return self.stack:server().Name
    end,
    -- Aplica o hash SHA3
    sha3 = function(self, input)
        return crypto.Keccak256(input)
    end
}

-- Retorna a tabela contendo os métodos da API
return Node
```

Este é um equivalente Lua do pacote `node` do Go. Dividi os métodos em três categorias: `privateAdminAPI`, `publicAdminAPI` e `publicWeb3API`, de acordo com sua acessibilidade. Certifique-se de ajustar qualquer outra funcionalidade ou uso dependendo do contexto da sua aplicação Lua.