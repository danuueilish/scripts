local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local function applyAntiLag()
  pcall(function() Lighting.GlobalShadows=false end)
  pcall(function() Lighting.Brightness=1 end)
  pcall(function() Lighting.EnvironmentSpecularScale=0 end)
  pcall(function() Lighting.EnvironmentDiffuseScale=0 end)
  pcall(function() Lighting.ClockTime = 12 end)

  for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
      pcall(function() v.Enabled=false end)
    end
  end

  pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,  false) end)
  pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false) end)
end

local M = {}
function M.mount(tab)
  local s = tab:Section("Anti-Lag")
  s:Label("Kurangi efek visual untuk performa lebih stabil (client-side).")
  s:Button("Apply Now", function()
    applyAntiLag()
    StarterGui:SetCore("SendNotification", {Title="Anti-Lag", Text="Applied ✓", Duration=2})
  end)
end
return M
