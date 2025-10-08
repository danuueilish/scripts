local UI = _G.danuu_hub_ui
if not UI or not UI.Tabs or not UI.Tabs.Utility then return end

local Theme = {
    text  = Color3.fromRGB(235,230,255),
    text2 = Color3.fromRGB(190,180,220),
    accA  = Color3.fromRGB(125,84,255),
    accB  = Color3.fromRGB(215,55,255),
}

local function corner(p,r)  local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function stroke(p,c,t) local s=Instance.new("UIStroke"); s.Color=c or Color3.new(1,1,1); s.Thickness=t or 1; s.Transparency=.6; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s end

local container = UI.NewSection(UI.Tabs.Utility, "Part Detector")

local info = Instance.new("TextLabel")
info.BackgroundTransparency = 1
info.TextWrapped = true
info.TextColor3 = Theme.text2
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.Text = "Fungsinya: kadang ada tangga / part yang tidak bisa diinjek. Daripada buang waktu, aktifin fitur ini, lalu double-click part.\n• Merah = tidak bisa diinjek\n• Hijau = bisa diinjek"
info.Size = UDim2.new(1,0,0,40)
info.Parent = container

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1,0,0,30)
toggleBtn.BackgroundColor3 = Theme.accA
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "Enable Part Detector"
corner(toggleBtn,8); stroke(toggleBtn,Theme.accB,1).Transparency=.4
toggleBtn.Parent = container

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

local running = false
local lastClick, lastPart, outline, gui

local function makeGUI()
    if gui then gui:Destroy() end
    gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "PartChecker"

    local frame = Instance.new("Frame", gui)
    frame.Name = "StatusFrame"
    frame.Size = UDim2.new(0,160,0,45)
    frame.Position = UDim2.new(0,10,0,20)
    frame.BackgroundColor3 = Color3.fromRGB(10,20,40)
    corner(frame,8)

    local label = Instance.new("TextLabel", gui)
    label.Name = "StatusLabel"
    label.Size = UDim2.new(0,148,0,33)
    label.Position = UDim2.new(0,16,0,26)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSans
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = "Double click part to check"
    return label
end

local function clearOutline()
    if outline then outline:Destroy(); outline=nil end
end
local function makeOutline(part)
    clearOutline()
    outline = Instance.new("SelectionBox", workspace)
    outline.Adornee = part
    outline.Color3 = Color3.new(0,0.6,1)
end
local function checkPart(part)
    return part.CanCollide and part.Transparency < 1
end

local function startDetector()
    local statusLabel = makeGUI()
    lastClick, lastPart = 0, nil

    mouse.Button1Down:Connect(function()
        if not running then return end
        local target = mouse.Target
        local now = tick()
        if target and target:IsA("BasePart") then
            makeOutline(target)
            if lastPart == target and (now - lastClick) < 0.5 then
                local walkable = checkPart(target)
                if walkable then
                    statusLabel.Text = "✅ BISA DIINJEK NYET\n" .. target.Name
                    statusLabel.TextColor3 = Color3.fromRGB(0,255,100)
                    outline.Color3 = Color3.new(0,1,0)
                else
                    statusLabel.Text = "❌ GABISA DIINJEK NYET\n" .. target.Name
                    statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
                    outline.Color3 = Color3.new(1,0,0)
                end
                task.spawn(function()
                    wait(4)
                    if running and statusLabel.Parent then
                        statusLabel.Text = "Double click part to check"
                        statusLabel.TextColor3 = Color3.new(1,1,1)
                        clearOutline()
                    end
                end)
            else
                statusLabel.Text = "Click again: " .. target.Name
                statusLabel.TextColor3 = Color3.fromRGB(255,255,100)
            end
            lastPart, lastClick = target, now
        end
    end)

    UserInputService.InputBegan:Connect(function(i)
        if running and i.KeyCode == Enum.KeyCode.C then
            clearOutline()
            if gui and gui:FindFirstChild("StatusLabel") then
                gui.StatusLabel.Text = "Double click part to check"
                gui.StatusLabel.TextColor3 = Color3.new(1,1,1)
            end
        end
    end)
end

local function stopDetector()
    clearOutline()
    if gui then gui:Destroy(); gui=nil end
end

toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        toggleBtn.Text = "Disable Part Detector"
        startDetector()
    else
        toggleBtn.Text = "Enable Part Detector"
        stopDetector()
    end
end)
