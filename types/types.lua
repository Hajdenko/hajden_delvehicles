---@class SafeZone
---@field x number X coordinate of the safe zone center
---@field y number Y coordinate of the safe zone center
---@field z number Z coordinate of the safe zone center
---@field radius number Radius of the safe zone

---@class DeletionConfig
---@field WaitTimeBeforeNotify number Minutes to wait before starting notifications
---@field NotifyTimeLimit number Minutes to keep notifying players
---@field NotifyFrequency number How often to send notifications (in minutes)
---@field DeleteVehiclesInSafeZone boolean Whether to delete vehicles in safe zones
---@field ExcludeJobVehicles boolean Whether to exclude job vehicles from deletion
---@field IgnorePlayerVehicles boolean Whether to ignore vehicles with players in them

---@class MenuConfig
---@field Command string Command to open the menu
---@field RestrictedToGroups string[] Groups that can access the menu