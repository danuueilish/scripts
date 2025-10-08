local HttpService = game:GetService("HttpService")
local ok, res = pcall(function()
    local placeId = game.PlaceId
    local jobId = game.JobId
    local joinUrl = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

    return HttpService:RequestAsync({
        Url = "https://discord.com/api/webhooks/1423994162012749916/p1SqRjg3Ta3ZBAut3R_alAUh3H6-CwCVq3xmqpiU9Yv3yRhglScexsMeBmbqtjCXlr2x",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({
            embeds = {{
                title = "[Expedition]",
                description = ("by: %s\n[Join Server](%s)")
                    :format(game.Players.LocalPlayer.Name, joinUrl),
                color = 0x2ecc71
            }}
        })
    })
end)

print("[danuu-hub] starting...")

local base = "https://raw.githubusercontent.com/danuueilish/danuueilish/main/src/"

local UI = loadstring(game:HttpGet(base.."ui_main.lua"))()

pcall(function() loadstring(game:HttpGet(base.."home.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."auto_loop.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."auto_crash.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."sticky_notes.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."rejoin.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."antilag.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."mount_atin.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."mount_manual.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."local_player.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."player_backpack.lua"))() end)
pcall(function() loadstring(game:HttpGet(base.."part_detector.lua"))() end)

print("[danuu-hub] semua modul sudah di-load ✓")
