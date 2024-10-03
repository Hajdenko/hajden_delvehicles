---@class Config
---@field Debug boolean Whether debug mode is enabled
Config = {}
Config.Debug = true

---@type SafeZone[]
Config.SafeZones = {
    -- {x = 200.0, y = 300.0, z = 30.0, radius = 100.0},
    -- {x = -500.0, y = -600.0, z = 25.0, radius = 150.0}
}

---@type DeletionConfig
Config.Deletion = {
    WaitTimeBeforeNotify = 10,
    NotifyTimeLimit = 5,
    NotifyFrequency = 1,
    DeleteVehiclesInSafeZone = false,
    ExcludeJobVehicles = true,
    IgnorePlayerVehicles = true
}

---@type MenuConfig
Config.Menu = {
    Command = { 'vh', 'vehicledelete', 'vehdel', 'delvehs', 'delvehicles', 'carcleanup' },
    RestrictedToGroups = {'admin', 'mod'}
}