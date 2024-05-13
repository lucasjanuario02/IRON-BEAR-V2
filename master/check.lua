-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2019 ConsenSys AG.

-- Função para verificar se os arquivos possuem cabeçalho SPDX

function checkHeaders(rootPath, spdxHeader, filesRegex, excludeRegex)
    local filesWithoutHeader = {}

    for file in io.popen('find "' .. rootPath .. '" -type f -regex "' .. filesRegex .. '" -not -regex "' .. excludeRegex .. '"'):lines() do
        local f = io.open(file, "r")
        local content = f:read("*all")
        f:close()

        if not string.find(content, spdxHeader, 1, true) then
            table.insert(filesWithoutHeader, file)
        end
    end

    if #filesWithoutHeader > 0 then
        print("Files without headers:")
        for i, file in ipairs(filesWithoutHeader) do
            print(file)
        end
        error("Files without SPDX header found.")
    end
end

-- Chamada da função de verificação
checkHeaders("caminho/para/o/diretorio", "SPDX-License-Identifier: Apache-2.0", ".*", "")
