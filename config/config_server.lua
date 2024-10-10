sv_config = {
    getGroup = function(source)
        local framework = nil

        if GetResourceState('es_extended') == 'started' then
            framework = 'esx'
        elseif GetResourceState('qb-core') == 'started' then
            framework = 'qbcore'
        elseif GetResourceState('qbox') == 'started' then
            framework = 'qbox'
        elseif GetResourceState('vrp') == 'started' then
            framework = 'vrp'
        elseif GetResourceState('ox_core') == 'started' then
            framework = 'ox_core'
        end

        if framework == 'esx' then
            local xPlayer = exports["es_extended"]:getSharedObject().GetPlayerFromId(source)
            return xPlayer.getGroup()
        elseif framework == 'qbcore' then
            local Player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(source)
            return Player.PlayerData.group -- Assuming QBCore has a 'group' field
        elseif framework == 'qbox' then
            return "default"
        elseif framework == 'vrp' then
            local user_id = vRP.getUserId({source})
            return vRP.getUserGroupByType({user_id, "job"})
        elseif framework == 'ox_core' then
            local Player = exports.ox_core:GetPlayer(source)
            return Player.group
        else
            return "unknown"
        end
    end
}