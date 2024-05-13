Claro, eu posso traduzir o código Go para Lua para você. Aqui está uma versão equivalente do código em Lua:

```lua
-- Configuração do diretório de dados padrão
local function DefaultDataDir()
    -- Lógica para determinar o diretório de dados padrão
    return "/caminho/do/diretorio/de/dados"
end

-- Configuração do host HTTP padrão
local function DefaultHTTPHost()
    -- Lógica para determinar o host HTTP padrão
    return "localhost"
end

-- Porta HTTP padrão
local function DefaultHTTPPort()
    -- Lógica para determinar a porta HTTP padrão
    return 8545
end

-- Configuração do host WebSocket padrão
local function DefaultWSHost()
    -- Lógica para determinar o host WebSocket padrão
    return "localhost"
end

-- Porta WebSocket padrão
local function DefaultWSPort()
    -- Lógica para determinar a porta WebSocket padrão
    return 8546
end

-- Função de configuração do caminho IPC
local function IPCEndpoint(config)
    -- Verificar se IPC está habilitado
    if config.IPCPath == "" then
        return ""
    end
    -- Lógica para determinar o ponto de extremidade IPC com base na plataforma
    if runtime.GOOS == "windows" then
        if string.sub(config.IPCPath, 1, 9) == `\\.\pipe\` then
            return config.IPCPath
        end
        return `\\.\pipe\` .. config.IPCPath
    end
    if string.match(config.IPCPath, "/") then
        return config.IPCPath
    end
    return Path.Join(config.DataDir, config.IPCPath)
end

-- Configuração do ponto de extremidade HTTP
local function HTTPEndpoint(config)
    if config.HTTPHost == "" then
        return ""
    end
    return config.HTTPHost .. ":" .. config.HTTPPort
end

-- Configuração do ponto de extremidade WebSocket
local function WSEndpoint(config)
    if config.WSHost == "" then
        return ""
    end
    return config.WSHost .. ":" .. config.WSPort
end

-- Função para verificar se os RPC externos estão habilitados
local function ExtRPCEnabled(config)
    return config.HTTPHost ~= "" or config.WSHost ~= ""
end

-- Função para obter o nome do nó
local function NodeName(config)
    local name = config.name()
    if name == "geth" or name == "geth-testnet" then
        name = "Geth"
    end
    if config.UserIdent ~= "" then
        name = name .. "/" .. config.UserIdent
    end
    if config.Version ~= "" then
        name = name .. "/v" .. config.Version
    end
    name = name .. "/" .. runtime.GOOS .. "-" .. runtime.GOARCH
    name = name .. "/" .. runtime.Version()
    return name
end

-- Resolução do caminho no diretório de instância
local function ResolvePath(config, path)
    if Path.IsAbs(path) then
        return path
    end
    if config.DataDir == "" then
        return ""
    end
    if config.name() == "geth" then
        local oldpath = Path.Join(config.DataDir, path)
        if Common.FileExist(oldpath) then
            return oldpath
        end
    end
    return Path.Join(config.instanceDir(), path)
end

-- Função para obter a chave do nó
local function NodeKey(config)
    if config.P2P.PrivateKey ~= nil then
        return config.P2P.PrivateKey
    end
    if config.DataDir == "" then
        -- Geração de chave efêmera
        local key, err = Crypto.GenerateKey()
        if err then
            -- Lidar com o erro
        end
        return key
    end
    local keyfile = ResolvePath(config, datadirPrivateKey)
    local key, err = Crypto.LoadECDSA(keyfile)
    if err then
        -- Lidar com o erro
    end
    if key then
        return key
    end
    -- Geração e armazenamento de uma nova chave
    local key, err = Crypto.GenerateKey()
    if err then
        -- Lidar com o erro
    end
    local instanceDir = Path.Join(config.DataDir, config.name())
    local err = FS.MkdirAll(instanceDir, 0700)
    if err then
        -- Lidar com o erro
    end
    local keyfile = Path.Join(instanceDir, datadirPrivateKey)
    err = Crypto.SaveECDSA(keyfile, key)
    if err then
        -- Lidar com o erro
    end
    return key
end

-- Obtenção de nós estáticos
local function StaticNodes(config)
    return ParsePersistentNodes(config, config.ResolvePath(datadirStaticNodes))
end

-- Obtenção de nós confiáveis
local function TrustedNodes(config)
    return ParsePersistentNodes(config, config.ResolvePath(datadirTrustedNodes))
end

-- Análise de nós persistentes
local function ParsePersistentNodes(config, path)
    if config.DataDir == "" then
        return {}
    end
    if not FS.Exists(path) then
        return {}
    end
    -- Lógica para carregar e analisar os nós persistentes
    local nodelist = Common.LoadJSON(path)
    local nodes = {}
    for _, url in ipairs(nodelist) do
        if url ~= "" then
            local node, err = Enode.Parse(Enode.ValidSchemes, url)
            if err then
                -- Lidar com o erro
            end
            table.insert(nodes, node)
        end
    end
    return nodes
end

-- Configuração do diretório de chaves
local function KeyDirConfig(config)
    local keydir = ""
    local err = nil
    if Path.IsAbs(config.KeyStoreDir) then
        keydir = config.KeyStoreDir
    elseif config.DataDir ~= "" then
        if config.KeyStoreDir == "" then
            keydir = Path.Join(config.DataDir, datadirDefaultKeyStore)
        else
            keydir, err = Path.Abs(config.KeyStoreDir)
        end
    elseif config.KeyStoreDir ~= "" then
        keydir, err = Path.Abs(config.KeyStoreDir)
    end
    return keydir, err
end

-- Função para obter o diretório de chaves
local function GetKeyStoreDir(config)
    local keydir, isEphemeral, err = getKeyStoreDir(config)
    if err then
        -- Lidar com o erro
    end
    return keydir, isEphemeral
end

-- Aviso uma vez
local function WarnOnce(config, w, format, ...)
    warnLock.Lock()
    defer warnLock.Unlock()

    if w then
        return
    end
    local l = config.Logger
    if l == nil then
       