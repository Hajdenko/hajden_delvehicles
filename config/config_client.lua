---@param msg string Message to display
---@param type? 'info'|'warning'|'error'|'success' Type of notification
Config.Notify = function(msg, type)
    lib.notify({
        title = locale('notification_title'),
        description = msg,
        type = type or 'info'
    })
end

Config.RepeatedTimer = {
    enabled = true,

    --- In minutes interval, the timer will run every X minutes
    interval = 10,

    --- The vehicle deletion will take X minutes
    minutes = 5
}