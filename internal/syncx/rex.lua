```lua
-- Define a tabela que conterá os métodos da API
local Syncx = {}

-- Cria um novo mutex que também pode ser fechado
function Syncx.newClosableMutex()
    local ch = { true } -- Inicialmente, o mutex está aberto
    return {
        -- Tenta bloquear o mutex
        tryLock = function()
            if ch[1] then
                ch[1] = false
                return true
            else
                return false
            end
        end,
        -- Bloqueia o mutex
        mustLock = function()
            if ch[1] then
                ch[1] = false
            else
                error("mutex fechado")
            end
        end,
        -- Libera o mutex
        unlock = function()
            if ch[1] then
                error("Unlock de um mutex já desbloqueado")
            else
                ch[1] = true
            end
        end,
        -- Fecha o mutex
        close = function()
            if ch[1] then
                ch[1] = false
                ch = nil -- Liberando a memória do mutex
            else
                error("Close de um mutex já fechado")
            end
        end
    }
end

-- Retorna a tabela contendo os métodos da API
return Syncx
```

Esta é a versão Lua do `ClosableMutex` da biblioteca `syncx` do Go. Os métodos `tryLock`, `mustLock`, `unlock` e `close` correspondem diretamente às operações equivalentes em Go. Certifique-se de adaptar o uso desses métodos de acordo com sua aplicação Lua.