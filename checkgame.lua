repeat task.wait() until game:IsLoaded()
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/exhil13/AstralB1.0/3kdIKfmsdSf/Astral%20Main%20Script', true))()")
    end
end)
if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/exhil13/LiquidBounce4Roblox/3kdIKfmsdSf/kavobedwars.lua", true))()
elseif game.PlaceId == 10255454029 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/exhil13/LiquidBounce4Roblox/3kdIKfmsdSf/kavobedwars.lua", true))()
end
