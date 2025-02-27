---@param source number Player who triggered the command
---@param args string[] Command arguments
RegisterCommand('vh_cleanup', function(source, args)
    local minutes = tonumber(args[1]) or Config.Deletion.WaitTimeBeforeNotify
    TriggerClientEvent('hajden_delvehicles:forceStart', -1, minutes)
end)

---@param source number Player who triggered the command
RegisterCommand('vh_stop', function(source)
    TriggerClientEvent('hajden_delvehicles:forceStop', -1)
end)

lib.callback.register('hajden_delvehicles:getGroup', function(source)
    return sv_config.getGroup(source)
end)

lib.addCommand(Config.Menu.Command, {
    help = 'Vehicle Cleanup',
}, function(source, args, raw)
    lib.callback.await('hajden_delvehicles:MenuCommand', source)
end)
