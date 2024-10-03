lib.locale()

local enumerate = require('client.enumerate')

local isTimerRunning = false
local currentTimer = 0

---Checks if a vehicle should be excluded from deletion
---@param vehicle number Vehicle entity handle
---@return boolean excluded Whether the vehicle should be excluded
local function IsVehicleExcluded(vehicle)
    if Config.Debug then
        print(locale('debug_vehicle_check', vehicle))
    end

    if Config.Deletion.IgnorePlayerVehicles and cache.vehicle then
        return true
    end
    
    if Config.Deletion.ExcludeJobVehicles then
        local entityState = Entity(vehicle).state
        if entityState.jobVehicle then
            return true
        end
    end
    
    return false
end

---Checks if coordinates are within any safe zone
---@param coords vector3 Coordinates to check
---@return boolean inSafeZone Whether the coordinates are in a safe zone
local function IsInSafeZone(coords)
    for _, zone in ipairs(Config.SafeZones) do
        local distance = #(vector3(zone.x, zone.y, zone.z) - coords)
        if distance <= zone.radius then
            return true
        end
    end
    return false
end

---Deletes only the valid vehicles in the world
---@return number deletedCount Number of vehicles deleted
local function DeleteAllVehicles()
    local deletedCount = 0
    for vehicle in enumerate.EnumerateVehicles() do
        if not IsVehicleExcluded(vehicle) then
            local coords = GetEntityCoords(vehicle)

            if Config.Debug then
                print("Deleted car at: "..coords)
            end
            
            if not Config.Deletion.DeleteVehiclesInSafeZone and IsInSafeZone(coords) then
                goto continue
            end
            
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetEntityAsMissionEntity(vehicle, false, false)
            DeleteVehicle(vehicle)
            
            if DoesEntityExist(vehicle) then
                DeleteVehicle(vehicle)
            end
            
            deletedCount = deletedCount + 1
            
            ::continue::
        end
    end
    
    if Config.Debug then
        print(string.format('Deleted %d vehicles', deletedCount))
    end
    
    TriggerEvent('hajden_delvehicles:deleted', deletedCount)
    Config.Notify(locale('vehicles_deleted', deletedCount), 'success')
    return deletedCount
end

---@param minutes number Minutes until deletion
local function StartTimer(minutes)
    if isTimerRunning then return end
    
    if Config.Debug then
        print(locale('debug_timer_start', minutes))
    end
    
    isTimerRunning = true
    currentTimer = minutes
    
    if minutes ~= 0 then 
        Config.Notify(locale('timer_started', minutes)) 
    end
    
    CreateThread(function()
        while currentTimer > 0 and isTimerRunning do
            Wait(1 * (1000 * 60))
            currentTimer = currentTimer - 1
            
            if currentTimer <= Config.Deletion.NotifyTimeLimit and currentTimer ~= 0 then
                Config.Notify(locale('timer_warning', currentTimer), 'warning')
            end
        end
        
        if isTimerRunning then
            DeleteAllVehicles()
            isTimerRunning = false
        end
    end)
end

local function StopTimer()
    if not isTimerRunning then Config.Notify(locale('timer_not_running'), 'error') return end
    
    if Config.Debug then
        print(locale('debug_timer_stop'))
    end
    
    isTimerRunning = false
    currentTimer = 0
    Config.Notify(locale('timer_stopped'), 'success')
end


local function StartRepeatedTimer()
    while Config.RepeatedTimer.enabled do
        Wait(Config.RepeatedTimer.interval * 60 * 1000)
        
        StartTimer(Config.RepeatedTimer.minutes)
    end
end

local function getGroup()
    return lib.callback.await('hajden_delvehicles:getGroup', false)
end

lib.registerContext({
    id = 'vehicle_cleanup_menu',
    title = locale('menu_title'),
    options = {
        {
            title = locale('start_timer'),
            description = locale('start_description'),
            icon = 'fa-regular fa-clock',
            onSelect = function()
                local input = lib.inputDialog(locale('menu_title'), {
                    {type = 'number', label = locale('input_minutes'), required = true, min = 1}
                })
                
                if input then
                    StartTimer(tonumber(input[1]))
                end
            end
        },
        {
            title = locale('stop_timer'),
            description = locale('stop_description'),
            icon = 'ban',
            onSelect = function()
                local confirm = lib.alertDialog({
                    header = locale('confirm_stop'),
                    content = locale('confirm_stop_desc'),
                    cancel = true
                })
                
                if confirm then
                    StopTimer()
                end
            end
        }
    }
})

-- Commands --
lib.callback.register('hajden_delvehicles:MenuCommand', function(source)
    local hasPermission = false
    for _, group in ipairs(Config.Menu.RestrictedToGroups) do
        if getGroup() == group then
            hasPermission = true
            break
        end
    end
    
    if hasPermission then
        lib.showContext('vehicle_cleanup_menu')
    else
        Config.Notify(locale('no_permission'), 'error')
    end
end)

-- Events --
RegisterNetEvent('hajden_delvehicles:forceStart', function(minutes)
    if getGroup() == 'admin' then
        StartTimer(minutes)
    end
end)

RegisterNetEvent('hajden_delvehicles:forceStop', function()
    if getGroup() == 'admin' then
        StopTimer()
    end
end)

Citizen.CreateThread(StartRepeatedTimer)