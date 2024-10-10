sv_config = {
    getGroup = function(source)
        local xPlayer = exports["es_extended"]:getSharedObject().GetPlayerFromId(source)
        return xPlayer.getGroup()
    end
}