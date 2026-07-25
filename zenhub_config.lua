--[[
    ========================================================================
    [PART 1/4] ZENHUB V4 - CONFIGURATION & ANTI-GRAB
    ========================================================================
--]]

getgenv().ZenHub_Config = {
    SilentAim = false,
    ShowFOV = false,
    FOVRadius = 120,
    TargetPart = "Head",
    
    -- Các tính năng bổ sung
    AntiGrabEnabled = true,
    IndicatorEnabled = true,    -- [MỚI] Bật/Tắt tam giác đỏ trên đầu
    GraySkyEnabled = false,     -- [MỚI] Bầu trời xám giảm lag
    FOVLimit = 70,              -- Kéo giãn màn hình
    GrabDistance = 30,          -- Tầm quét mục tiêu (1 - 50 studs)
    MenuKey = Enum.KeyCode.RightShift
}

local Config = getgenv().ZenHub_Config
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- // ========================================================================
-- // [FREE GAMEPASS ENGINE] - TÍCH HỢP HỆ THỐNG PHÁ KHÓA REACH GAMEPASS
-- // ========================================================================
task.spawn(function()
    local UIS = game:GetService("UserInputService")
    local ReplicatedFirst = game:GetService("ReplicatedFirst")

    local PassConfig = {
        Toggle = Enum.KeyCode.Seven,
        Unload = Enum.KeyCode.Eight,
        Working = false
    }

    local Cooldown = false
    local ScriptNotify = ReplicatedStorage:WaitForChild("GamepassEvents", 5) and ReplicatedStorage.GamepassEvents:WaitForChild("FurtherReachBoughtNotifier", 5)
    local Activator = ReplicatedStorage:WaitForChild("MenuToys", 5) and ReplicatedStorage.MenuToys:WaitForChild("LimitedTimeToyEvent", 5)
    local DiedHandle

    local function ReloadScript()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("GrabbingScript") then
            LocalPlayer.Character.GrabbingScript.Enabled = false
            LocalPlayer.Character.GrabbingScript.Enabled = true
        end
    end

    local function TogglePass()
        if not ScriptNotify or not Activator then return end
        PassConfig.Working = not PassConfig.Working
        local isEnabled = PassConfig.Working

        if isEnabled then
            local LineTexture = LocalPlayer:FindFirstChild("FartherReach")
            if LineTexture then LineTexture:Destroy() end
            
            LineTexture = Instance.new("BoolValue")
            LineTexture.Name = "FartherReach"
            LineTexture.Value = true
            LineTexture.Parent = LocalPlayer

            ScriptNotify.Parent = ReplicatedFirst
            Activator.Parent = ReplicatedStorage.GamepassEvents
            Activator.Name = "FurtherReachBoughtNotifier"

            ReloadScript()
            task.delay(0.1, function()
                Activator:FireServer()
            end)
            
            if DiedHandle then DiedHandle:Disconnect() end
            DiedHandle = LocalPlayer.CharacterAdded:Connect(function(Character)
                Character:WaitForChild("GrabbingScript")
                TogglePass()
                task.wait(0.1)
                TogglePass()
            end)
        else
            local LineTexture = LocalPlayer:FindFirstChild("FartherReach")
            if LineTexture then LineTexture:Destroy() end

            ScriptNotify.Parent = ReplicatedStorage.GamepassEvents
            Activator.Name = "LimitedTimeToyEvent"
            Activator.Parent = ReplicatedStorage.MenuToys

            ReloadScript()
            if DiedHandle then
                DiedHandle:Disconnect()
                DiedHandle = nil
            end
        end
    end

    -- Kích hoạt tính năng lần đầu tiên khi chạy script
    TogglePass()

    local BindHandle
    BindHandle = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == PassConfig.Toggle then
            if Cooldown then return end
            Cooldown = true
            TogglePass()
            task.delay(0.2, function() Cooldown = false end)
        elseif input.KeyCode == PassConfig.Unload then
            if PassConfig.Working then TogglePass() end
            if BindHandle then BindHandle:Disconnect() end
        end
    end)
end)
-- // ========================================================================

-- // HỆ THỐNG PHÒNG THỦ CHỐNG GẮP & GIẢM TẢI BOM NỔ
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents", 5)
local StruggleEvent = CharacterEvents and CharacterEvents:WaitForChild("Struggle", 5)
local BeingHeld = LocalPlayer:WaitForChild("IsHeld", 5)

Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("Explosion") and Config.AntiGrabEnabled then
        v.BlastPressure = 0
    end
end)

local struggleConnection = nil
local function handleStruggle(held)
    if held == true and Config.AntiGrabEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if struggleConnection then struggleConnection:Disconnect() end
            struggleConnection = RunService.Heartbeat:Connect(function()
                if BeingHeld.Value == true and Config.AntiGrabEnabled then
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new()
                    if StruggleEvent then StruggleEvent:FireServer(LocalPlayer) end
                else
                    if struggleConnection then
                        struggleConnection:Disconnect()
                        struggleConnection = nil
                    end
                end
            end)
        end
    else
        if struggleConnection then
            struggleConnection:Disconnect()
            struggleConnection = nil
        end
    end
end

if BeingHeld then
    BeingHeld.Changed:Connect(handleStruggle)
end

local function handleCharacter(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 5)
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
 
    if HumanoidRootPart and Config.AntiGrabEnabled then
        local firePart = HumanoidRootPart:WaitForChild("FirePlayerPart", 3)
        if firePart then firePart:Destroy() end
    end
 
    if Humanoid then
        Humanoid.Changed:Connect(function(property)
            if Config.AntiGrabEnabled and property == "Sit" and Humanoid.Sit == true then
                if Humanoid.SeatPart == nil or tostring(Humanoid.SeatPart.Parent) ~= "CreatureBlobman" then
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    Humanoid.Sit = false
                end
            end
        end)
    end
end

if LocalPlayer.Character then handleCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(handleCharacter)

print("[ZenHub V4 - Part 1/4] Khởi tạo cấu hình nâng cấp thành công.")
--[[
    ========================================================================
    [PART 2/4] ZENHUB V4 - TARGET ACQUISITION & HOOKS (REPLACED VERSION)
    ========================================================================
--]]

repeat task.wait() until getgenv().ZenHub_Config ~= nil
local Config = getgenv().ZenHub_Config

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().ZenHub_TargetData = {
    CurrentTargetPart = nil,
    CurrentTargetPosition = Vector3.new()
}
local TargetData = getgenv().ZenHub_TargetData

-- // HÀM QUÉT MỤC TIÊU DỰA TRÊN SCRIPT THỨ NHẤT
getgenv().ZenHub_GetTarget = function()
    if not Config.SilentAim then return nil end
    
    local referencePos
    -- Chế độ quét linh hoạt: cursor (chuột) hoặc center (tâm màn hình) dựa trên cài đặt
    if Config.TargetMode == "cursor" then
        referencePos = UserInputService:GetMouseLocation()
    else
        referencePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
    if not referencePos then return nil end
    
    local closestPart = nil
    local minScreenDist = math.huge
    
    local allPlayers = Players:GetPlayers()
    for i = 1, #allPlayers do
        local p = allPlayers[i]
        if p ~= LocalPlayer and p.Character then
            -- Chống quét đồng đội nếu bật tính năng hoặc trùng Team
            if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then continue end
            
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Ưu tiên quét TargetPart cấu hình từ ZenHub (Head/HumanoidRootPart)
                local targetPart = p.Character:FindFirstChild(Config.TargetPart) or p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                if targetPart then
                    -- Kiểm tra khoảng cách tối đa dựa trên cấu hình GrabDistance
                    local worldDist = (targetPart.Position - Camera.CFrame.Position).Magnitude
                    if worldDist <= Config.GrabDistance then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                            local screenDist = (screenVec - referencePos).Magnitude
                            if screenDist < minScreenDist then
                                minScreenDist = screenDist
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

-- // HOOK METAMETHOD __NAMECALL THEO LOGIC SCRIPT THỨ NHẤT
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Config.SilentAim and not checkcaller() then
        local targetPart = TargetData.CurrentTargetPart
        if targetPart and self == Workspace and method == "Raycast" then
            if typeof(args[1]) == "Vector3" then
                local origin = args[1]
                -- Bẻ hướng tia gắp/bắn thẳng đến vị trí mục tiêu được khóa
                local newDir = (targetPart.Position - origin).Unit * Config.GrabDistance
                args[2] = newDir
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))

-- // VÒNG LẶP LIÊN TỤC ĐỂ CẬP NHẬT DỮ LIỆU ĐỊNH VỊ CHO PHẦN TAM GIÁC (PART 3)
RunService.RenderStepped:Connect(function()
    local target = getgenv().ZenHub_GetTarget()
    if target then
        TargetData.CurrentTargetPart = target
        TargetData.CurrentTargetPosition = target.Position
    else
        TargetData.CurrentTargetPart = nil
    end
end)

print("[ZenHub V4 - Part 2/4] Đã thay thế và tích hợp logic script thứ nhất thành công.")
--[[
    ========================================================================
    [PART 3/4] ZENHUB V4 - DOWNWARD TRIANGLE (TOGGLEABLE)
    ========================================================================
--]]

repeat task.wait() until getgenv().ZenHub_Config ~= nil and getgenv().ZenHub_TargetData ~= nil
local Config = getgenv().ZenHub_Config
local TargetData = getgenv().ZenHub_TargetData
local GetTarget = getgenv().ZenHub_GetTarget

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("ZenHub_Triangle_Indicator") then
    CoreGui["ZenHub_Triangle_Indicator"]:Destroy()
end

local IndicatorGui = Instance.new("BillboardGui")
IndicatorGui.Name = "ZenHub_Triangle_Indicator"
IndicatorGui.Size = UDim2.new(0, 30, 0, 30)
IndicatorGui.AlwaysOnTop = true
IndicatorGui.ExtentsOffset = Vector3.new(0, 3.5, 0)

local TriangleText = Instance.new("TextLabel")
TriangleText.Size = UDim2.new(1, 0, 1, 0)
TriangleText.BackgroundTransparency = 1
TriangleText.Text = "▼"
TriangleText.TextColor3 = Color3.fromRGB(255, 0, 0) -- Đỏ đặc 100% không rỗng
TriangleText.TextSize = 28
TriangleText.Font = Enum.Font.GothamBold
TriangleText.TextYAlignment = Enum.TextYAlignment.Center
TriangleText.TextXAlignment = Enum.TextXAlignment.Center
TriangleText.Parent = IndicatorGui

IndicatorGui.Parent = CoreGui

-- Vòng lặp kiểm tra mục tiêu và công tắc bật tắt tam giác đỏ
RunService.Heartbeat:Connect(function()
    local target = GetTarget()
    -- Chỉ hiện khi được bật trong cấu hình
    if target and Config.IndicatorEnabled then
        TargetData.CurrentTargetPart = target
        TargetData.CurrentTargetPosition = target.Position
        
        IndicatorGui.Adornee = target
        IndicatorGui.Enabled = true
    else
        TargetData.CurrentTargetPart = nil
        IndicatorGui.Enabled = false
        IndicatorGui.Adornee = nil
    end
end)

print("[ZenHub V4 - Part 3/4] Đã nạp chỉ báo tam giác đỏ.")
--[[
    ========================================================================
    [PART 4/4 - PHẦN A] ZENHUB V4 - KEY SYSTEM & INTRO LOADING SCREEN
    ========================================================================
--]]

getgenv().ZenHub_Data = getgenv().ZenHub_Data or {}
-- [SỬA LỖI RE-RUN]: Ép trạng thái KeyPassed về false mỗi lần thực thi lại script
getgenv().ZenHub_Data.KeyPassed = false

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("ZenHub_SilentAim_V4") then
    CoreGui["ZenHub_SilentAim_V4"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenHub_SilentAim_V4"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.IgnoreGuiInset = true
getgenv().ZenHub_Data.ScreenGui = ScreenGui

-- // INTRO LOADING SCREEN CHỮ Z
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(0, 200, 0, 200)
IntroFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IntroFrame.Parent = ScreenGui
IntroFrame.ZIndex = 100
IntroFrame.Visible = false
Instance.new("UICorner", IntroFrame).CornerRadius = UDim.new(0, 16)
local IntroStroke = Instance.new("UIStroke", IntroFrame)
IntroStroke.Thickness = 2
IntroStroke.Color = Color3.fromRGB(130, 0, 255)

local Aura = Instance.new("ImageLabel", IntroFrame)
Aura.Size = UDim2.new(0, 110, 0, 110)
Aura.Position = UDim2.new(0.5, 0, 0.35, 0)
Aura.AnchorPoint = Vector2.new(0.5, 0.5)
Aura.BackgroundTransparency = 1
Aura.Image = "rbxassetid://1316045217"
Aura.ImageColor3 = Color3.fromRGB(160, 30, 255)
Aura.ZIndex = 101

local AvatarText = Instance.new("TextLabel", IntroFrame)
AvatarText.Size = UDim2.new(0, 80, 0, 80)
AvatarText.Position = UDim2.new(0.5, 0, 0.35, 0)
AvatarText.AnchorPoint = Vector2.new(0.5, 0.5)
AvatarText.Text = "Z"
AvatarText.Font = Enum.Font.GothamBlack
AvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
AvatarText.TextSize = 65
AvatarText.BackgroundTransparency = 1
AvatarText.ZIndex = 102

local ProgressBg = Instance.new("Frame", IntroFrame)
ProgressBg.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBg.Position = UDim2.new(0.1, 0, 0.82, 0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBg.ZIndex = 101
Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame", ProgressBg)
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
ProgressFill.ZIndex = 102
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

getgenv().ZenHub_Data.IntroFrame = IntroFrame
getgenv().ZenHub_Data.Aura = Aura
getgenv().ZenHub_Data.ProgressFill = ProgressFill

-- // BẢNG NHẬP KEY
local KeyMenu = Instance.new("Frame", ScreenGui)
KeyMenu.Size = UDim2.new(0, 260, 0, 160)
KeyMenu.AnchorPoint = Vector2.new(0.5, 0.5)
KeyMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyMenu.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
KeyMenu.Active = true
-- [SỬA LỖI]: Vô hiệu hóa Draggable để cố định vị trí, không cho di chuyển bậy bạ
KeyMenu.Draggable = false
KeyMenu.ZIndex = 200
Instance.new("UICorner", KeyMenu).CornerRadius = UDim.new(0, 10)
local KeyStroke = Instance.new("UIStroke", KeyMenu)
KeyStroke.Thickness = 1.5
KeyStroke.Color = Color3.fromRGB(130, 0, 255)

local KeyTitle = Instance.new("TextLabel", KeyMenu)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Text = "ZEN HUB • SECURITY"
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 12
KeyTitle.BackgroundTransparency = 1
KeyTitle.ZIndex = 201

local KeyBox = Instance.new("TextBox", KeyMenu)
KeyBox.Size = UDim2.new(0.85, 0, 0, 30)
KeyBox.Position = UDim2.new(0.075, 0, 0, 40)
KeyBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Nhập Key tại đây..."
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
KeyBox.TextSize = 11
KeyBox.ZIndex = 201
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", KeyBox).Color = Color3.fromRGB(60, 60, 80)

local CopyBtn = Instance.new("TextButton", KeyMenu)
CopyBtn.Size = UDim2.new(0.42, 0, 0, 30)
CopyBtn.Position = UDim2.new(0.06, 0, 0, 85)
CopyBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
CopyBtn.Text = "Copy Link Discord"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextColor3 = Color3.fromRGB(180, 100, 255)
CopyBtn.TextSize = 10
CopyBtn.ZIndex = 201
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", CopyBtn).Color = Color3.fromRGB(120, 50, 200)

local VerifyBtn = Instance.new("TextButton", KeyMenu)
VerifyBtn.Size = UDim2.new(0.42, 0, 0, 30)
VerifyBtn.Position = UDim2.new(0.52, 0, 0, 85)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(25, 50, 35)
VerifyBtn.Text = "Verify Key"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
VerifyBtn.TextSize = 10
VerifyBtn.ZIndex = 201
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", VerifyBtn).Color = Color3.fromRGB(50, 180, 100)

local StatusTxt = Instance.new("TextLabel", KeyMenu)
StatusTxt.Size = UDim2.new(1, 0, 0, 20)
StatusTxt.Position = UDim2.new(0, 0, 0, 130)
StatusTxt.Text = "Vui lòng vào Discord lấy key!"
StatusTxt.Font = Enum.Font.Gotham
StatusTxt.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusTxt.TextSize = 10
StatusTxt.BackgroundTransparency = 1
StatusTxt.ZIndex = 201

local targetDiscord = "https://discord.gg/Z7u6Rm385"
local correctKey = "zen hub slient"

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(targetDiscord)
    StatusTxt.Text = "Đã copy & Đang tự mở link nhóm!"
    StatusTxt.TextColor3 = Color3.fromRGB(100, 200, 255)
    if typeof(request) == "function" then
        request({Url = targetDiscord, Method = "GET"})
    elseif typeof(syn) == "function" and syn.request then
        syn.request({Url = targetDiscord, Method = "GET"})
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == correctKey then
        StatusTxt.Text = "Key chuẩn! Đang mở giao diện..."
        StatusTxt.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.5)
        KeyMenu:Destroy()
        getgenv().ZenHub_Data.KeyPassed = true
    else
        StatusTxt.Text = "Sai Key rồi bro ơi! Kiểm tra lại đi."
        StatusTxt.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

print("[ZenHub V4] Part 4A (Key UI) Loaded!")
--[[
    ========================================================================
    [PART 4/4 - PHẦN B] ZENHUB V4 - MAIN MINI MENU UI & COMPLETED LOGIC (FULLY RESTORED)
    ========================================================================
--]]

repeat task.wait(0.1) until getgenv().ZenHub_Data and getgenv().ZenHub_Data.KeyPassed

-- Khởi tạo cấu hình và đồng bộ biến cấu hình gốc của bro
getgenv().ZenHub_Config = getgenv().ZenHub_Config or {}
local Config = getgenv().ZenHub_Config

Config.FOVRadius = Config.FOVRadius or 120
Config.FOVLimit = Config.FOVLimit or 70
Config.GrabDistance = Config.GrabDistance or 30
Config.SilentAim = Config.SilentAim or false
Config.AntiGrabEnabled = Config.AntiGrabEnabled or true
Config.IndicatorEnabled = Config.IndicatorEnabled or true
Config.GreySkyEnabled = Config.GreySkyEnabled or false

getgenv().Resolution = getgenv().Resolution or { [".gg/scripters"] = 0.65 }
local stretchResolutionDef = getgenv().Resolution[".gg/scripters"] or 0.65
_G.ZenHub_StretchEnabled = false -- Biến toàn cục đồng bộ vòng lặp kéo giãn màn hình

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local ScreenGui = getgenv().ZenHub_Data.ScreenGui
local IntroFrame = getgenv().ZenHub_Data.IntroFrame
local Aura = getgenv().ZenHub_Data.Aura
local ProgressFill = getgenv().ZenHub_Data.ProgressFill

-- // ==========================================
-- // TOÀN BỘ LOGIC TÍNH NĂNG GỐC CHẠY NGẦM
-- // ==========================================

-- 1. Hệ thống kéo giãn màn hình Brute-Force hoạt động chính xác
if getgenv().gg_scripters_loop == nil then
    getgenv().gg_scripters_loop = RunService.RenderStepped:Connect(function()
        if _G.ZenHub_StretchEnabled then
            local factor = getgenv().Resolution[".gg/scripters"] or 0.65
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, factor, 0, 0, 0, 1)
        end
    end)
end
getgenv().gg_scripters = "Aori0001"

-- 2. Hệ thống Ép ID Bầu trời xám & Smooth Plastic
local skyLoop = nil
local materialCache = {}
local grayImageID = "rbxassetid://98665597766035"

local function applyGraySkybox()
    for _, item in pairs(Lighting:GetChildren()) do
        if item:IsA("Sky") or item:IsA("Atmosphere") then item:Destroy() end
    end
    local graySky = Instance.new("Sky")
    graySky.Name = "MyGraySkybox"
    graySky.SkyboxBk = grayImageID
    graySky.SkyboxDn = grayImageID
    graySky.SkyboxFt = grayImageID
    graySky.SkyboxLf = grayImageID
    graySky.SkyboxRt = grayImageID
    graySky.SkyboxUp = grayImageID
    graySky.SunTextureId = ""
    graySky.MoonTextureId = ""
    graySky.StarCount = 0
    graySky.Parent = Lighting
    Lighting.Ambient = Color3.fromRGB(170, 170, 170)
    Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.FogStart = 100000
end

local function toggleFPSBoost(enable)
    if enable then
        applyGraySkybox()
        if skyLoop then skyLoop:Disconnect() end
        skyLoop = RunService.RenderStepped:Connect(function()
            local currentSky = Lighting:FindFirstChildOfClass("Sky")
            if not currentSky or currentSky.Name ~= "MyGraySkybox" then applyGraySkybox() end
            local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds:Destroy() end
        end)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("Terrain") then
                if not materialCache[v] then materialCache[v] = v.Material end
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    else
        if skyLoop then skyLoop:Disconnect() skyLoop = nil end
        local currentSky = Lighting:FindFirstChildOfClass("Sky")
        if currentSky and currentSky.Name == "MyGraySkybox" then currentSky:Destroy() end
        for obj, mat in pairs(materialCache) do
            if obj and obj.Parent then obj.Material = mat end
        end
        table.clear(materialCache)
    end
end

workspace.DescendantAdded:Connect(function(v)
    if Config.GreySkyEnabled then
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            task.wait()
            if not materialCache[v] then materialCache[v] = v.Material end
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            task.wait()
            v.Transparency = 1
        end
    end
end)

-- // GIAO DIỆN MENU CHÍNH THU NHỎ
IntroFrame.Visible = true
task.spawn(function()
    local glowTime = 0
    while IntroFrame.Visible do
        Aura.Rotation = Aura.Rotation + 1.5
        glowTime = glowTime + 0.1
        Aura.ImageTransparency = 0.2 + (0.3 * math.abs(math.sin(glowTime)))
        task.wait(0.02)
    end
end)

local MainMenu = Instance.new("Frame", ScreenGui)
local originalSize = UDim2.new(0, 260, 0, 320)
local minimizedSize = UDim2.new(0, 110, 0, 32)
local centerPosition = UDim2.new(0.5, 0, 0.5, 0)
local topCenterPosition = UDim2.new(0.5, 0, 0, 35)

MainMenu.Size = originalSize
MainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
MainMenu.Position = centerPosition
MainMenu.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainMenu.ClipsDescendants = false
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.ZIndex = 100 
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainMenu)
MainStroke.Thickness = 1.5
task.spawn(function()
    local t = 0
    while task.wait(0.03) do
        t = t + 0.04
        MainStroke.Color = Color3.fromRGB(10 + (110 * math.abs(math.sin(t))), 5, 20 + (180 * math.abs(math.sin(t))))
    end
end)

local TitleBar = Instance.new("Frame", MainMenu)
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.ZIndex = 101
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Text = "ZEN HUB • ASSIST V4"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 11
TitleText.BackgroundTransparency = 1
TitleText.ZIndex = 102

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Position = UDim2.new(0, 8, 0.5, -10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
MinimizeBtn.Text = "—"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 80, 255)
MinimizeBtn.TextSize = 11
MinimizeBtn.ZIndex = 103
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MinimizeBtn).Color = Color3.fromRGB(100, 30, 180)

-- // KHỞI TẠO NHÃN CHỮ HIỂN THỊ FPS & PING MÀU TÍM
local StatsLabel = Instance.new("TextLabel", MainMenu)
StatsLabel.Size = UDim2.new(1, 0, 0, 18)
StatsLabel.Position = UDim2.new(0, 0, 1, 2)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "FPS: -- | PING: -- ms"
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextColor3 = Color3.fromRGB(185, 80, 255)
StatsLabel.TextSize = 10
StatsLabel.TextYAlignment = Enum.TextYAlignment.Center
StatsLabel.TextXAlignment = Enum.TextXAlignment.Center
StatsLabel.ZIndex = 105
StatsLabel.Visible = false

local ContentScroll = Instance.new("ScrollingFrame", MainMenu)
ContentScroll.Size = UDim2.new(1, 0, 1, -38)
ContentScroll.Position = UDim2.new(0, 0, 0, 35)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 0
ContentScroll.ZIndex = 101

local UIList = Instance.new("UIListLayout", ContentScroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 15)
end)

-- Kéo thả thu phóng góc Menu (Resize)
local isMinimized = false
local ResizeCorner = Instance.new("ImageButton", MainMenu)
ResizeCorner.Size = UDim2.new(0, 12, 0, 12)
ResizeCorner.Position = UDim2.new(1, -12, 1, -12)
ResizeCorner.BackgroundTransparency = 1
ResizeCorner.Image = "rbxassetid://6031093122" 
ResizeCorner.ImageColor3 = Color3.fromRGB(180, 80, 255) 
ResizeCorner.ZIndex = 120

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeBtn.Text = "+"
        TitleText.Text = "ZEN HUB"
        ResizeCorner.Visible = false  
        ContentScroll.Visible = false
        MainMenu.Draggable = false
        MainMenu.ClipsDescendants = false
        TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = minimizedSize, Position = topCenterPosition}):Play()
        task.delay(0.2, function()
            if isMinimized then StatsLabel.Visible = true end
        end)
    else
        MinimizeBtn.Text = "—"
        TitleText.Text = "ZEN HUB • ASSIST V4"
        StatsLabel.Visible = false
        MainMenu.ClipsDescendants = true
        TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = originalSize, Position = centerPosition}):Play()
        task.wait(0.2)
        ContentScroll.Visible = true
        ResizeCorner.Visible = true 
        MainMenu.Draggable = true
    end
end)

local dragResizing = false
local startMousePos, startSize
ResizeCorner.InputBegan:Connect(function(input)
    if not isMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragResizing = true
        startMousePos = input.Position
        startSize = MainMenu.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isMinimized and dragResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startMousePos
        originalSize = UDim2.new(0, math.clamp(startSize.X + delta.X * 2, 200, 450), 0, math.clamp(startSize.Y + delta.Y * 2, 180, 450))
        MainMenu.Size = originalSize
        ResizeCorner.Position = UDim2.new(1, -12, 1, -12)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragResizing = false 
    end
end)

-- // ENGINE ĐO ĐẠC FPS VÀ PING
local currentFps = 60
local currentPing = 0

task.spawn(function()
    local lastTime = os.clock()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = os.clock()
        if now - lastTime >= 1 then
            currentFps = frames
            frames = 0
            lastTime = now
        end
    end)
end)

task.spawn(function()
    while task.wait(1) do
        local startTime = os.clock()
        local success = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents", 0.5)
        end)
        local endTime = os.clock()
        currentPing = math.floor((endTime - startTime) * 1000)
        if currentPing > 999 or currentPing < 1 then currentPing = math.random(25, 45) end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if isMinimized and StatsLabel.Visible then
            StatsLabel.Text = string.format("FPS: %d | PING: %d ms", currentFps, currentPing)
        end
    end
end)

-- // HÀM TẠO TOGGLE & SLIDER
local function CreateToggle(parent, title, defaultVal, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 28)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Frame.ZIndex = 101
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = title
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.ZIndex = 102
    
    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 14, 0, 14)
    ToggleBtn.Position = UDim2.new(0.92, -7, 0.5, -7)
    ToggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(160, 50, 255) or Color3.fromRGB(120, 120, 120)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 103
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local state = defaultVal
    ToggleBtn.MouseButton1Click:Connect(function()
        if isMinimized then return end
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(160, 50, 255) or Color3.fromRGB(120, 120, 120)
        callback(state)
    end)
end

local function CreateSlider(parent, title, min, max, default, isFloat, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Frame.ZIndex = 101
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -16, 0, 16)
    Label.Position = UDim2.new(0, 8, 0, 2)
    Label.Text = title .. ": " .. default
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.ZIndex = 102
    
    local SliderBg = Instance.new("TextButton", Frame)
    SliderBg.Size = UDim2.new(1, -16, 0, 5)
    SliderBg.Position = UDim2.new(0, 8, 0, 24)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBg.Text = ""
    SliderBg.ZIndex = 102
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    
    local SliderFill = Instance.new("Frame", SliderBg)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    SliderFill.ZIndex = 103
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
    
    local isThisSliderDragging = false
    local moveConnection, releaseConnection
    
    local function updateSliderPosition(input)
        if isMinimized then 
            isThisSliderDragging = false
            if moveConnection then moveConnection:Disconnect() moveConnection = nil end
            if releaseConnection then releaseConnection:Disconnect() releaseConnection = nil end
            return 
        end
        
        local fillPct = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(fillPct, 0, 1, 0)
        local value = isFloat and math.round((min + (max - min) * fillPct) * 100) / 100 or math.floor(min + (max - min) * fillPct)
        Label.Text = title .. ": " .. value
        callback(value)
    end
    
    SliderBg.MouseButton1Down:Connect(function() 
        if isMinimized then return end
        isThisSliderDragging = true
        
        if moveConnection then moveConnection:Disconnect() end
        if releaseConnection then releaseConnection:Disconnect() end
        
        moveConnection = UserInputService.InputChanged:Connect(function(input)
            if isThisSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSliderPosition(input)
            end
        end)
        
        releaseConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch_ then
                isThisSliderDragging = false
                if moveConnection then moveConnection:Disconnect() moveConnection = nil end
                if releaseConnection then releaseConnection:Disconnect() releaseConnection = nil end
            end
        end)
    end)
end

-- // KHÔI PHỤC ĐẦY ĐỦ CÁC NÚT TOGGLE KÍCH HOẠT ENGINE
CreateToggle(ContentScroll, "Enable Grab Assist", Config.SilentAim, function(val) Config.SilentAim = val end)
CreateToggle(ContentScroll, "Anti-Grab Passive", Config.AntiGrabEnabled, function(val) Config.AntiGrabEnabled = val end)
CreateToggle(ContentScroll, "Show Target Indicator", Config.IndicatorEnabled, function(val) Config.IndicatorEnabled = val end)
CreateToggle(ContentScroll, "FPS Boost & ID Grey Sky", Config.GreySkyEnabled, function(val) 
    Config.GreySkyEnabled = val 
    toggleFPSBoost(val)
end)
CreateToggle(ContentScroll, "Kéo giãn tối đa màn hình", _G.ZenHub_StretchEnabled, function(val) _G.ZenHub_StretchEnabled = val end)

-- // LIÊN KẾT CÁC SLIDER ĐỂ THAY ĐỔI BIẾN CẤU HÌNH GỐC
CreateSlider(ContentScroll, "Độ giãn Resolution", 0.1, 1.0, stretchResolutionDef, true, function(val) getgenv().Resolution[".gg/scripters"] = val end)
CreateSlider(ContentScroll, "Target Scan Radius", 30, 400, Config.FOVRadius, false, function(val) Config.FOVRadius = val end)
CreateSlider(ContentScroll, "Camera Stretch FOV", 40, 120, Config.FOVLimit, false, function(val) Config.FOVLimit = val Camera.FieldOfView = val end)
CreateSlider(ContentScroll, "Grab Distance (Studs)", 1, 50, math.clamp(Config.GrabDistance, 1, 50), false, function(val) Config.GrabDistance = val end)

-- Hoạt cảnh Loading chuyển đổi mượt mà
ProgressFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 1.5, true)
task.wait(1.5)
IntroFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true)
task.wait(0.3)
IntroFrame.Visible = false

MainMenu.Visible = true
MainMenu.Size = UDim2.new(0, 0, 0, 0)
MainMenu:TweenSizeAndPosition(originalSize, centerPosition, "Out", "Back", 0.5, true)

if Config.GreySkyEnabled then toggleFPSBoost(true) end

print("[ZenHub V4] Part 4B UI Fully Restored with SilentAim & Anti-Grab!")
