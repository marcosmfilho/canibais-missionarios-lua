require('tables')
local inicio = {margem1={canibais = 3, missionarios = 3},margem2={canibais=0, missionarios=0},barco='esquerda'}
local jogadas = {}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function verfificaSolucao(jogo)
    if jogo.margem2.missionarios == 3 then
        return true
    else
        return false
    end
end

function verificaEstadoValido(jogo)
    if (jogo.margem1.canibais > jogo.margem1.missionarios and jogo.margem1.missionarios ~= 0) or
       (jogo.margem2.canibais > jogo.margem2.missionarios and jogo.margem2.missionarios ~= 0) or
       jogo.margem1.canibais < 0 or
       jogo.margem1.canibais > 3 or
       jogo.margem1.missionarios < 0 or
       jogo.margem1.missionarios > 3 or
       jogo.margem2.canibais < 0 or
       jogo.margem2.canibais > 3 or
       jogo.margem2.missionarios < 0
       or jogo.margem2.missionarios > 3 then
       return false
   else
       return true;
   end
end

function passa1Canibal(jogo)
    local aux = deepcopy(jogo)
    if aux.barco == 'esquerda' then
        aux.margem1.canibais =  aux.margem1.canibais - 1
        aux.margem2.canibais =  aux.margem2.canibais + 1
        aux.barco = 'direita'
    else
        aux.margem1.canibais =  aux.margem1.canibais + 1
        aux.margem2.canibais =  aux.margem2.canibais - 1
        aux.barco = 'esquerda'
    end
    return aux
end

function passa2Canibais(jogo)
    local aux = deepcopy(jogo)
    if aux.barco == 'esquerda' then
        aux.margem1.canibais =  aux.margem1.canibais - 2
        aux.margem2.canibais =  aux.margem2.canibais + 2
        aux.barco = 'direita'
    else
        aux.margem1.canibais =  aux.margem1.canibais + 2
        aux.margem2.canibais =  aux.margem2.canibais - 2
        aux.barco = 'esquerda'
    end
    return aux
end

function passa1Missionario(jogo)
    local aux = deepcopy(jogo)
    if aux.barco == 'esquerda' then
        aux.margem1.missionarios =  aux.margem1.missionarios - 1
        aux.margem2.missionarios =  aux.margem2.missionarios + 1
        aux.barco = 'direita'
    else
        aux.margem1.missionarios =  aux.margem1.missionarios + 1
        aux.margem2.missionarios =  aux.margem2.missionarios - 1
        aux.barco = 'esquerda'
    end
    return aux
end

function passa2Missionarios(jogo)
    local aux = deepcopy(jogo)
    if aux.barco == 'esquerda' then
        aux.margem1.missionarios =  aux.margem1.missionarios - 2
        aux.margem2.missionarios =  aux.margem2.missionarios + 2
        aux.barco = 'direita'
    else
        aux.margem1.missionarios =  aux.margem1.missionarios + 2
        aux.margem2.missionarios =  aux.margem2.missionarios - 2
        aux.barco = 'esquerda'
    end
    return aux
end

function passa1Canibal1Missionario(jogo)
    local aux = deepcopy(jogo)
    if aux.barco == 'esquerda' then
        aux.margem1.missionarios =  aux.margem1.missionarios - 1
        aux.margem2.missionarios =  aux.margem2.missionarios + 1
        aux.margem1.canibais =  aux.margem1.canibais - 1
        aux.margem2.canibais =  aux.margem2.canibais + 1
        aux.barco = 'direita'
    else
        aux.margem1.missionarios =  aux.margem1.missionarios + 1
        aux.margem2.missionarios =  aux.margem2.missionarios - 1
        aux.margem1.canibais =  aux.margem1.canibais + 1
        aux.margem2.canibais =  aux.margem2.canibais - 1
        aux.barco = 'esquerda'
    end
    return aux
end

function geraEstados(estado)
    local estados = {}
    local aux1 = passa1Canibal(estado)
    local aux2 = passa2Canibais(estado)
    local aux3 = passa1Missionario(estado)
    local aux4 = passa2Missionarios(estado)
    local aux5 = passa1Canibal1Missionario(estado)

    if(verificaEstadoValido(aux1)) then table.insert(estados, aux1) end
    if(verificaEstadoValido(aux2)) then table.insert(estados, aux2) end
    if(verificaEstadoValido(aux3)) then table.insert(estados, aux3) end
    if(verificaEstadoValido(aux4)) then table.insert(estados, aux4) end
    if(verificaEstadoValido(aux5)) then table.insert(estados, aux5) end
    local estado = {}
    table.insert(estado, estados[math.random(#estados)])

    return estado
end

function buscaSolucao(estado)
    table.insert(jogadas, estado)
    if verfificaSolucao(estado) then
        print('Esquerda: ' .. estado.margem1.canibais .. 'C / ' .. estado.margem1.missionarios .. 'M'
        .. ' - Direita: ' .. estado.margem2.canibais .. 'C / ' .. estado.margem2.missionarios .. 'M')
        print(' ')
        print('MISSIONÁRIOS SALVOS! UFA!')
        print(' ')
        print('ESTADO FINAL:')
        print(estado)
        os.exit()
    else
        filhos = geraEstados(estado)
        for i,v in pairs(filhos) do
            table.insert(jogadas, v)
            print('Esquerda: ' .. estado.margem1.canibais .. 'C / ' .. estado.margem1.missionarios .. 'M'
            .. ' - Direita: ' .. estado.margem2.canibais .. 'C / ' .. estado.margem2.missionarios .. 'M')
        end
        table.remove(jogadas, 1)
        for k,v in pairs(jogadas) do
            buscaSolucao(v)
        end
    end
end

buscaSolucao(inicio)
