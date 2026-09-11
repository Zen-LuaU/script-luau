--[[
    ZEN HUB X + APEX FARM MERGED
    - WindUI framework (giữ từ zen hubX)
    - Farm Egg logic + Area/Rarity/Mutation lists (từ Apex Hub)
    - Anti-cheat Humanoid swap, bypass movement, return-to-base
    - Discord verification giữ nguyên
]]

local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local DISCORD_INVITE_LINK = "https://discord.gg/vGh9KqMsk"
local DISCORD_INVITE_CODE = "vGh9KqMsk"

-- ============================================================
-- CONSTANTS (từ Apex Hub)
-- ============================================================
local RARITIES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }
local RarityWeight = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}
local MUTATIONS = { "Golden", "Rainbow", "Silver" }
local AREA_ORDER = { "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic" }
local STEAL_PRIORITIES = { "Rarest", "Nearest", "Furthest", "Biggest Size" }

local DEFAULT_STEAL_SPEED = 800
local BYPASS_SPEED = 900
local BASE_RETURN_ARRIVE = 4
local STEAL_HOLD_TIME = 3
local STEAL_DISTANCE = 35

-- ============================================================
-- DISCORD VERIFICATION (giữ từ zen hubX)
-- ============================================================
local isVerified = false

local function CreateDiscordVerificationUI()
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "DiscordVerificationGui"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(340, 220)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromHex("#8A2BE2")
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "ZEN HUB X - XÁC MINH DISCORD"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold

    local Desc = Instance.new("TextLabel", Frame)
    Desc.Size = UDim2.new(1, -30, 0, 50)
    Desc.Position = UDim2.fromOffset(15, 40)
    Desc.BackgroundTransparency = 1
    Desc.Text = "Bạn cần tham gia Server Discord để tiếp tục!"
    Desc.TextColor3 = Color3.fromRGB(180, 190, 210)
    Desc.TextSize = 12
    Desc.TextWrapped = true
    Desc.Font = Enum.Font.Gotham

    local JoinBtn = Instance.new("TextButton", Frame)
    JoinBtn.Size = UDim2.new(1, -40, 0, 38)
    JoinBtn.Position = UDim2.fromOffset(20, 100)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    JoinBtn.Text = "1. Tham Gia Discord"
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8)

    local VerifyBtn = Instance.new("TextButton", Frame)
    VerifyBtn.Size = UDim2.new(1, -40, 0, 38)
    VerifyBtn.Position = UDim2.fromOffset(20, 150)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
    VerifyBtn.Text = "2. Xác Minh & Bắt Đầu"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    local joinedClicked = false
    JoinBtn.MouseButton1Click:Connect(function()
        joinedClicked = true
        if setclipboard then setclipboard(DISCORD_INVITE_LINK) end
        local req = request or http_request or (syn and syn.request)
        if req then
            pcall(function()
                req({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                    Body = HttpService:JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = {code = DISCORD_INVITE_CODE},
                        nonce = HttpService:GenerateGUID(false)
                    })
                })
            end)
        end
        JoinBtn.Text = "✓ Đã sao chép / mở Discord!"
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        if joinedClicked then
            isVerified = true
            Gui:Destroy()
        else
            VerifyBtn.Text = "⚠️ Nhấp nút 1 trước!"
            task.wait(1.5)
            VerifyBtn.Text = "2. Xác Minh & Bắt Đầu"
        end
    end)
end

CreateDiscordVerificationUI()
repeat task.wait(0.1) until isVerified

-- ============================================================
-- WINDUI LOAD
-- ============================================================
local cloneref = cloneref or clonereference or function(i) return i end
local WindUI
do
    local ok, result = pcall(function() return require("./src/Init") end)
    if ok then WindUI = result
    else
        if cloneref(RunService):IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
        end
    end
end

local PurpleColor = Color3.fromHex("#8A2BE2")
local Window = WindUI:CreateWindow({
    Title = "zen hubX + Apex Farm",
    Folder = "zenhubX_Apex",
    Icon = "solar:shield-bold",
    Theme = "Dark",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Mở Menu",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        Color = ColorSequence.new(Color3.fromHex("#8A2BE2"), Color3.fromHex("#DA70D6")),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})
Window:Tag({ Title = "v13.0 Merged Farm", Icon = "solar:star-bold", Color = PurpleColor, Border = true })

-- ============================================================
-- CHARACTER / MOVEMENT CORE (từ Apex Hub + zen hubX)
-- ============================================================
local Character, HRP, Humanoid = nil, nil, nil
local IsBypassing = false
local OriginalSpeed = 16
local running = true
local conns = {}

local function track(c) table.insert(conns, c); return c end

local function getHumanoid()
    if not Character or not Character.Parent then return nil end
    return Character:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    if not Character or not Character.Parent then return nil end
    return Character:FindFirstChild("HumanoidRootPart")
end

local function SetupCharacter(char)
    if not char then return end
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)
    HRP = char:WaitForChild("HumanoidRootPart", 5)
    if Humanoid then
        if not SpeedConfig.Enabled then OriginalSpeed = Humanoid.WalkSpeed end
        Humanoid.PlatformStand = false
        pcall(function()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        end)
    end
    if HRP then
        pcall(function() HRP.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 100, 100) end)
    end
end

-- ============================================================
-- AREA / RARITY FILTER STATE
-- ============================================================
local FarmConfig = {
    Enabled = false,
    AutoReturn = true,
    AutoPlace = false,
    AutoHatch = false,
    UseAllAreas = true,
    UseAllRarities = true,
    UseAllMutations = true,
    Priority = "Rarest",
    SelectedAreas = {},
    SelectedRarities = {},
    SelectedMutations = {},
    StealSpeed = BYPASS_SPEED,
    CarryHold = STEAL_HOLD_TIME,
    MaxDistance = 2000,
}

-- ============================================================
-- ANTI-CHEAT HUMAN0ID SWAP (từ Apex Hub)
-- ============================================================
local function swapStealHumanoid()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("LocalScript") and string.find(d.Name, "PushBack") then
            pcall(function() d.Disabled = true; d:Destroy() end)
        end
    end
    return true
end

local function prepareStealHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local cam = Workspace.CurrentCamera
    local camCF = cam and cam.CFrame or nil
    local newHum
    local ok, clone = pcall(function() hum.Archivable = true; return hum:Clone() end)
    if ok and clone then
        newHum = clone
        newHum.Parent = char
        pcall(function() hum:Destroy() end)
    else newHum = hum end
    task.wait(0.1)
    newHum = char:FindFirstChildOfClass("Humanoid") or newHum
    if newHum then
        newHum.Sit = false
        newHum.PlatformStand = false
        newHum.WalkSpeed = DEFAULT_STEAL_SPEED
        newHum.AutoRotate = true
    end
    if cam and newHum then
        pcall(function()
            cam.CameraSubject = newHum
            if camCF then cam.CFrame = camCF end
        end)
    end
    return newHum
end

local function stripCheatMovers(root)
    if not root then return end
    for _, inst in ipairs(root:GetChildren()) do
        local cn = inst.ClassName
        if cn == "BodyVelocity" or cn == "BodyPosition" or cn == "BodyGyro"
        or cn == "BodyAngularVelocity" or cn == "LinearVelocity"
        or cn == "VectorForce" or cn == "AlignOrientation" then
            pcall(function() inst:Destroy() end)
        end
    end
end

-- ============================================================
-- MOVEMENT LOGIC (từ Apex Hub)
-- ============================================================
local function getLaneZ() return -365.5 end
local function getLaneY()
    local root = getRoot()
    return root and root.Position.Y or 70
end

local function placeRoot(root, cf)
    if not root or not cf then return end
    stripCheatMovers(root)
    local char = LocalPlayer.Character
    if char and char.Parent then pcall(function() char:PivotTo(cf) end)
    else root.CFrame = cf end
end

local function groundedY(x, z, fallbackY)
    local laneY = getLaneY()
    local hum = getHumanoid()
    local hip = (hum and hum.HipHeight > 0) and hum.HipHeight or 2
    local root = getRoot()
    local half = root and root.Size.Y * 0.5 or 1
    local offset = hip + half
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = {}
    if LocalPlayer.Character then table.insert(excluded, LocalPlayer.Character) end
    params.FilterDescendantsInstances = excluded
    local hitY = nil
    for _ = 1, 20 do
        local hit = Workspace:Raycast(Vector3.new(x, laneY + 40, z), Vector3.new(0, -160, 0), params)
        if not hit then break end
        local y = hit.Position.Y
        local n = hit.Instance.Name
        if n == "Ground" or string.find(string.lower(n), "ground", 1, true) or y <= laneY + 1.5 then
            hitY = y; break
        end
        table.insert(excluded, hit.Instance)
    end
    if hitY then return math.clamp(hitY + offset, laneY - 2, laneY + 5) end
    if typeof(fallbackY) == "number" then return math.clamp(fallbackY, laneY - 2, laneY + 5) end
    return laneY + 3
end

local function buildStealPath(startPos, targetPos)
    local laneZ, laneY = getLaneZ(), getLaneY()
    local wp = {}
    if math.abs(startPos.Z - laneZ) > 3 then table.insert(wp, Vector3.new(startPos.X, laneY, laneZ)) end
    if math.abs(startPos.X - targetPos.X) > 2 then table.insert(wp, Vector3.new(targetPos.X, laneY, laneZ)) end
    table.insert(wp, Vector3.new(targetPos.X, laneY, targetPos.Z))
    return wp
end

local function humanoidStealMoveTo(position, keepGoing)
    if typeof(position) ~= "Vector3" or not running then return false end
    local hum = getHumanoid()
    local root = getRoot()
    if not hum or not root then return false end
    hum.Sit = false; hum.PlatformStand = false; hum.AutoRotate = true
    hum.WalkSpeed = DEFAULT_STEAL_SPEED
    local targetY = groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= 1.35 then return true end
    local route = buildStealPath(root.Position, dest)
    if #route == 0 then route = { dest } end
    for _, point in ipairs(route) do
        if not running or (keepGoing and not keepGoing()) then return false end
        root = getRoot(); if not root then return false end
        local pointY = groundedY(point.X, point.Z, root.Position.Y)
        local wp = Vector3.new(point.X, pointY, point.Z)
        while running do
            if keepGoing and not keepGoing() then return false end
            root = getRoot(); if not root then return false end
            local offset = wp - root.Position
            local dist = offset.Magnitude
            if dist <= 1.35 then break end
            local dir = offset.Unit
            local dt = math.clamp(RunService.Heartbeat:Wait(), 0, 1/30)
            local step = math.min(DEFAULT_STEAL_SPEED * dt, dist)
            local nextPos = root.Position + dir * step
            local flatDir = Vector3.new(dir.X, 0, dir.Z)
            if flatDir.Magnitude > 0.001 then root.CFrame = CFrame.lookAt(nextPos, nextPos + flatDir.Unit)
            else root.CFrame = CFrame.new(nextPos) end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    root = getRoot(); if not root then return false end
    root.CFrame = CFrame.new(dest)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return (root.Position - dest).Magnitude <= 4
end

local function bypassMoveTo(position, keepGoing, speed)
    if typeof(position) ~= "Vector3" or not running then return false end
    speed = tonumber(speed) or BYPASS_SPEED
    local root = getRoot(); if not root then return false end
    stripCheatMovers(root)
    local hum = getHumanoid()
    if hum then hum.Sit = false; hum.PlatformStand = true end
    local targetY = groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= BASE_RETURN_ARRIVE then
        if hum then hum.PlatformStand = false end
        return true
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ApexBypassMove"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "ApexBypassGyro"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 3000; bg.D = 50; bg.CFrame = root.CFrame; bg.Parent = root
    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then break end
        root = getRoot(); if not root then break end
        local offset = dest - root.Position
        local dist = offset.Magnitude
        if dist <= BASE_RETURN_ARRIVE then arrived = true; break end
        local dir = offset.Unit
        bv.Velocity = dir * speed
        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0.001 then bg.CFrame = CFrame.lookAt(root.Position, root.Position + flatDir.Unit) end
        RunService.Heartbeat:Wait()
    end
    if bv and bv.Parent then bv:Destroy() end
    if bg and bg.Parent then bg:Destroy() end
    root = getRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if arrived then placeRoot(root, CFrame.new(dest.X, targetY, dest.Z)) end
    end
    hum = getHumanoid()
    if hum then hum.PlatformStand = false end
    return arrived
end

local function holdAtPosition(seconds, keepGoing)
    seconds = tonumber(seconds) or 3
    local root = getRoot(); if not root then return false end
    local anchorCF = root.CFrame
    local deadline = os.clock() + seconds
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then return false end
        root = getRoot()
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = anchorCF
        end
        RunService.Heartbeat:Wait()
    end
    return true
end

-- ============================================================
-- BASE POSITION / RETURN
-- ============================================================
local function getBasePosition()
    local spawn = Workspace:FindFirstChild("SpawnLocation")
    if spawn and spawn:IsA("BasePart") then return spawn.Position end
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local areas = objects and objects:FindFirstChild("Areas")
    local startArea = areas and areas:FindFirstChild("StartArea")
    if startArea and startArea:IsA("BasePart") then return startArea.Position end
    return nil
end

local function returnToBase(keepGoing)
    local bp = getBasePosition()
    if not bp then
        local root = getRoot()
        if root then bp = Vector3.new(root.Position.X, root.Position.Y, -365.5) else return false end
    end
    return bypassMoveTo(Vector3.new(bp.X, bp.Y + 3, bp.Z), keepGoing, BYPASS_SPEED)
end

-- ============================================================
-- PROXIMITY PROMPT EGG DETECTION (từ zen hubX + filter Apex)
-- ============================================================
local PromptCache = {}

local function getPromptPart(prompt)
    local parent = prompt.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Attachment") then return parent.Parent end
    if parent:IsA("Model") then return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart", true) end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

local function isEggPrompt(obj)
    if not obj:IsA("ProximityPrompt") then return false end
    local action = string.lower(tostring(obj.ActionText or ""))
    local keywords = {"steal", "grab", "take", "collect", "rob", "loot", "snatch", "open", "egg", "pick"}
    for _, kw in ipairs(keywords) do
        if string.find(action, kw) then return true end
    end
    local name = string.lower(obj.Name or "")
    local pname = string.lower(obj.Parent and obj.Parent.Name or "")
    return string.find(name, "egg") ~= nil or string.find(pname, "egg") ~= nil
        or string.find(name, "steal") ~= nil or string.find(pname, "steal") ~= nil
end

local function refreshPromptCache()
    table.clear(PromptCache)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isEggPrompt(obj) then table.insert(PromptCache, obj) end
    end
end

track(Workspace.DescendantAdded:Connect(function(d)
    if isEggPrompt(d) then table.insert(PromptCache, d) end
end))
track(Workspace.DescendantRemoving:Connect(function(d)
    if d:IsA("ProximityPrompt") then
        local idx = table.find(PromptCache, d)
        if idx then table.remove(PromptCache, idx) end
    end
end))

-- ============================================================
-- FILTER LOGIC (từ Apex Hub)
-- ============================================================
local function multiHasAny(tbl)
    for _, v in pairs(tbl) do if v then return true end end
    return false
end

local function areaAllowed(areaId)
    if FarmConfig.UseAllAreas then return true end
    if not multiHasAny(FarmConfig.SelectedAreas) then return true end
    return FarmConfig.SelectedAreas[areaId] == true
end

local function rarityAllowed(rarity)
    if FarmConfig.UseAllRarities then return true end
    if not multiHasAny(FarmConfig.SelectedRarities) then return true end
    return FarmConfig.SelectedRarities[rarity] == true
end

local function mutationAllowed(prompt)
    if FarmConfig.UseAllMutations then return true end
    if not multiHasAny(FarmConfig.SelectedMutations) then return true end
    local name = string.lower(prompt.Name .. " " .. (prompt.Parent and prompt.Parent.Name or ""))
    for mut in pairs(FarmConfig.SelectedMutations) do
        if string.find(name, string.lower(mut)) then return true end
    end
    return false
end

local function detectAreaFromName(name)
    local lower = string.lower(name)
    for _, area in ipairs(AREA_ORDER) do
        if string.find(lower, string.lower(area)) then return area end
    end
    return "Unknown"
end

local function detectRarityFromName(name)
    local lower = string.lower(name)
    for _, r in ipairs(RARITIES) do
        if string.find(lower, string.lower(r)) then return r end
    end
    return "Common"
end

-- ============================================================
-- PICK TARGET (từ Apex Hub, adapted cho prompt)
-- ============================================================
local function pickStealTarget()
    local root = getRoot()
    if not root then return nil end
    local best, bestScore = nil, -math.huge
    for i = #PromptCache, 1, -1 do
        local obj = PromptCache[i]
        if not obj or not obj.Parent or not obj.Enabled then
            table.remove(PromptCache, i)
        else
            local part = getPromptPart(obj)
            if part and part:IsA("BasePart") and part.Parent then
                local dist = (root.Position - part.Position).Magnitude
                local area = detectAreaFromName(obj.Name .. " " .. (obj.Parent and obj.Parent.Name or ""))
                local rarity = detectRarityFromName(obj.Name .. " " .. (obj.Parent and obj.Parent.Name or ""))
                if areaAllowed(area) and rarityAllowed(rarity) and mutationAllowed(obj) then
                    local score
                    if FarmConfig.Priority == "Nearest" then score = -dist
                    elseif FarmConfig.Priority == "Furthest" then score = dist
                    else score = (RarityWeight[rarity] or 0) * 100000 - math.min(dist, 99999) end
                    if score > bestScore then best = obj; bestScore = score end
                end
            end
        end
    end
    return best
end

-- ============================================================
-- STEAL EGG FULL SEQUENCE (từ Apex Hub)
-- ============================================================
local function activatePrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    if type(fireproximityprompt) == "function" then
        pcall(function() fireproximityprompt(prompt, STEAL_DISTANCE, 0, false) end)
    else
        pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()
        end)
    end
    return true
end

local function stealPrompt(prompt)
    if not prompt then return false end
    swapStealHumanoid()
    if not prepareStealHumanoid() then return false end
    local part = getPromptPart(prompt)
    if not part then return false end
    local targetPos = part.Position
    local root = getRoot()
    if not root then return false end

    local keepGoing = function() return FarmConfig.Enabled end
    local route = buildStealPath(root.Position, targetPos)
    for _, wp in ipairs(route) do
        if not keepGoing() then return false end
        if not humanoidStealMoveTo(wp, keepGoing) then return false end
    end

    root = getRoot()
    if root then
        local ty = groundedY(targetPos.X, targetPos.Z, targetPos.Y)
        placeRoot(root, CFrame.new(targetPos.X, ty, targetPos.Z))
    end
    if not keepGoing() then return false end

    holdAtPosition(0.35, keepGoing)
    for _ = 1, 6 do
        if activatePrompt(prompt) then break end
        task.wait(0.15)
    end
    holdAtPosition(FarmConfig.CarryHold, keepGoing)

    if FarmConfig.AutoReturn then
        returnToBase(keepGoing)
    end
    return true
end

local function runAutoSteal()
    local target = pickStealTarget()
    if not target then return false end
    return stealPrompt(target)
end

-- ============================================================
-- AUTO PLACE / HATCH (placeholder cho game cụ thể)
-- ============================================================
local function runAutoPlace()
    -- Cần module riêng của game; ở đây gọi remote nếu tìm thấy
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction"))
        and string.find(string.lower(d.Name), "place") then
            pcall(function() d:FireServer() end)
            return true
        end
    end
    return false
end

local function runAutoHatch()
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction"))
        and (string.find(string.lower(d.Name), "hatch") or string.find(string.lower(d.Name), "open")) then
            pcall(function() d:FireServer() end)
            return true
        end
    end
    return false
end

-- ============================================================
-- SPEED CONFIG (giữ từ zen hubX)
-- ============================================================
local SpeedConfig = { Enabled = false, Value = 300 }

-- ============================================================
-- UI TABS
-- ============================================================
if LocalPlayer.Character then SetupCharacter(LocalPlayer.Character) end
track(LocalPlayer.CharacterAdded:Connect(SetupCharacter))

-- --- SOCIAL TAB ---
local SocialTab = Window:Tab({ Title = "Liên kết", Icon = "solar:link-bold", IconColor = PurpleColor, Border = true })
SocialTab:Button({
    Title = "TikTok: zenhub.z",
    Desc = "Sao chép username",
    Callback = function()
        if setclipboard then setclipboard("zenhub.z") end
        WindUI:Notify({ Title = "zen hubX", Content = "Đã sao chép TikTok!" })
    end,
})
SocialTab:Space()
SocialTab:Button({
    Title = "Discord Server",
    Desc = DISCORD_INVITE_LINK,
    Callback = function()
        if setclipboard then setclipboard(DISCORD_INVITE_LINK) end
        WindUI:Notify({ Title = "zen hubX", Content = "Đã sao chép Discord!" })
    end,
})

-- --- FARM TAB (NEW - từ Apex Hub) ---
local FarmTab = Window:Tab({ Title = "Farm Egg", Icon = "solar:egg-bold", IconColor = PurpleColor, Border = true })

FarmTab:Section({ Title = "Auto Steal Egg" })
FarmTab:Toggle({
    Title = "Bật Farm Egg Tự Động",
    Desc = "Tự động tìm, di chuyển tới và nhặt trứng",
    Value = false,
    Callback = function(state) FarmConfig.Enabled = state end,
})
FarmTab:Space()
FarmTab:Toggle({
    Title = "Tự Động Quay Về Base",
    Desc = "Sau khi nhặt trứng, tự bay về base",
    Value = true,
    Callback = function(state) FarmConfig.AutoReturn = state end,
})
FarmTab:Space()
FarmTab:Dropdown({
    Title = "Ưu Tiên Mục Tiêu",
    Values = STEAL_PRIORITIES,
    Value = "Rarest",
    Callback = function(v) FarmConfig.Priority = v end,
})
FarmTab:Space()
FarmTab:Slider({
    Title = "Tốc Độ Bay Farm",
    Step = 50,
    Value = { Min = 200, Max = 1500, Default = 900 },
    Callback = function(v) FarmConfig.StealSpeed = v end,
})
FarmTab:Space()
FarmTab:Slider({
    Title = "Thời Gian Giữ Trứng (s)",
    Step = 0.5,
    Value = { Min = 0.5, Max = 10, Default = 3 },
    Callback = function(v) FarmConfig.CarryHold = v end,
})

FarmTab:Section({ Title = "Bộ Lọc Khu Vực" })
FarmTab:Toggle({
    Title = "Dùng Tất Cả Khu Vực",
    Value = true,
    Callback = function(state) FarmConfig.UseAllAreas = state end,
})
FarmTab:Space()
FarmTab:Dropdown({
    Title = "Chọn Khu Vực",
    Values = AREA_ORDER,
    Multi = true,
    Value = {},
    Callback = function(sel)
        FarmConfig.SelectedAreas = {}
        for _, v in ipairs(sel) do FarmConfig.SelectedAreas[v] = true end
    end,
})

FarmTab:Section({ Title = "Bộ Lọc Độ Hiếm" })
FarmTab:Toggle({
    Title = "Dùng Tất Cả Độ Hiếm",
    Value = true,
    Callback = function(state) FarmConfig.UseAllRarities = state end,
})
FarmTab:Space()
FarmTab:Dropdown({
    Title = "Chọn Độ Hiếm",
    Values = RARITIES,
    Multi = true,
    Value = {},
    Callback = function(sel)
        FarmConfig.SelectedRarities = {}
        for _, v in ipairs(sel) do FarmConfig.SelectedRarities[v] = true end
    end,
})

FarmTab:Section({ Title = "Bộ Lọc Mutation" })
FarmTab:Toggle({
    Title = "Dùng Tất Cả Mutation",
    Value = true,
    Callback = function(state) FarmConfig.UseAllMutations = state end,
})
FarmTab:Space()
FarmTab:Dropdown({
    Title = "Chọn Mutation",
    Values = MUTATIONS,
    Multi = true,
    Value = {},
    Callback = function(sel)
        FarmConfig.SelectedMutations = {}
        for _, v in ipairs(sel) do FarmConfig.SelectedMutations[v] = true end
    end,
})

FarmTab:Section({ Title = "Xử Lý Trứng" })
FarmTab:Toggle({
    Title = "Auto Place Egg",
    Desc = "Tự động đặt trứng xuống khu nuôi",
    Value = false,
    Callback = function(state) FarmConfig.AutoPlace = state end,
})
FarmTab:Space()
FarmTab:Toggle({
    Title = "Auto Hatch Egg",
    Desc = "Tự động mở trứng đã sẵn sàng",
    Value = false,
    Callback = function(state) FarmConfig.AutoHatch = state end,
})

FarmTab:Section({ Title = "Anti-Cheat" })
FarmTab:Button({
    Title = "Bypass Anti-Cheat (Humanoid Swap)",
    Desc = "Clone Humanoid để vượt qua bộ lọc anti-cheat",
    Callback = function()
        local ok = prepareStealHumanoid()
        WindUI:Notify({ Title = "Anti-Cheat", Content = ok and "✓ Đã bypass!" or "✗ Lỗi!" })
    end,
})
FarmTab:Space()
FarmTab:Button({
    Title = "Quay Về Base Ngay",
    Callback = function() task.spawn(function() returnToBase(nil) end) end,
})

-- --- MAIN TAB (giữ từ zen hubX) ---
local MainTab = Window:Tab({ Title = "Main Features", Icon = "solar:widget-bold", IconColor = PurpleColor, Border = true })
MainTab:Button({
    Title = "Bay Xuống Void (Reset Fast)",
    Callback = function()
        local hrp = getRoot()
        if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -350, hrp.Position.Z) end
    end,
})
MainTab:Space()
MainTab:Toggle({
    Title = "Bỏ Qua Ấn Giữ (Instant Interact)",
    Value = false,
    Callback = function(state)
        if state then
            for _, p in ipairs(Workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
            end
        end
    end,
})

-- --- PETE TAB ---
local PeteTab = Window:Tab({ Title = "Pete Features", Icon = "solar:user-bold", IconColor = PurpleColor, Border = true })
local PeteSettings = { AntiRagdoll = true }
PeteTab:Toggle({
    Title = "Anti-Ragdoll / Anti-Knock",
    Value = true,
    Callback = function(state) PeteSettings.AntiRagdoll = state end,
})
PeteTab:Space()
PeteTab:Toggle({
    Title = "Auto Steal (Prompt 35 studs)",
    Value = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                while PeteSettings.AutoSteal do
                    local p = pickStealTarget()
                    if p then activatePrompt(p) end
                    task.wait(0.15)
                end
            end)
        end
        PeteSettings.AutoSteal = state
    end,
})

-- --- SPEED TAB ---
local SpeedTab = Window:Tab({ Title = "Speed", Icon = "solar:bolt-bold", IconColor = PurpleColor, Border = true })
SpeedTab:Toggle({
    Title = "WalkSpeed Override",
    Value = false,
    Callback = function(state)
        SpeedConfig.Enabled = state
        local h = getHumanoid()
        if h then h.WalkSpeed = state and SpeedConfig.Value or OriginalSpeed end
    end,
})
SpeedTab:Space()
SpeedTab:Slider({
    Title = "Tốc Độ",
    Step = 10,
    Value = { Min = 100, Max = 900, Default = 300 },
    Callback = function(v)
        SpeedConfig.Value = v
        if SpeedConfig.Enabled then
            local h = getHumanoid()
            if h then h.WalkSpeed = v end
        end
    end,
})

-- --- FIX LAG TAB ---
local FixLagTab = Window:Tab({ Title = "Fix Lag", Icon = "solar:cpu-bold", IconColor = PurpleColor, Border = true })
FixLagTab:Button({
    Title = "Bật Fix Lag (Clay + Xóa cây)",
    Callback = function()
        Lighting.FogEnd = 1e6
        Lighting.GlobalShadows = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")
            or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
        end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local n = string.lower(obj.Name)
            if string.find(n, "tree") or string.find(n, "leaf") or string.find(n, "grass")
            or string.find(n, "bush") or string.find(n, "plant") then
                pcall(function() obj:Destroy() end)
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") then
                pcall(function() obj:Destroy() end)
            end
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            end
        end
    end,
})

-- --- ANTI TRAP TAB ---
local AntiTrapTab = Window:Tab({ Title = "Anti Trap", Icon = "solar:shield-check-bold", IconColor = PurpleColor, Border = true })
local IsTrapImmune = false
AntiTrapTab:Toggle({
    Title = "Xóa & Ẩn Bẫy",
    Value = false,
    Callback = function(state)
        IsTrapImmune = state
        if state then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                local n = string.lower(obj.Name)
                if string.find(n, "trap") or string.find(n, "snare") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end,
})

-- ============================================================
-- BACKGROUND LOOPS
-- ============================================================
refreshPromptCache()

-- Anti-ragdoll loop
track(RunService.Stepped:Connect(function()
    if IsBypassing then return end
    if not PeteSettings.AntiRagdoll then return end
    local h = getHumanoid()
    local hrp = getRoot()
    if not h or not hrp then return end
    h.PlatformStand = false
    local st = h:GetState()
    if st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.FallingDown
    or st == Enum.HumanoidStateType.Physics then
        h:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    local vel = hrp.AssemblyLinearVelocity
    if vel.Y > 30 then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
end))

-- Farm loop
track(RunService.Heartbeat:Connect(function()
    if not FarmConfig.Enabled then return end
    if not running then return end
    task.spawn(function()
        pcall(runAutoSteal)
    end)
end))

-- Auto place / hatch loop
track(RunService.Heartbeat:Connect(function()
    if FarmConfig.AutoPlace then task.spawn(function() pcall(runAutoPlace) end) end
    if FarmConfig.AutoHatch then task.spawn(function() pcall(runAutoHatch) end) end
end))

-- Speed loop
track(RunService.Stepped:Connect(function()
    if SpeedConfig.Enabled then
        local h = getHumanoid()
        if h and h.WalkSpeed ~= SpeedConfig.Value then h.WalkSpeed = SpeedConfig.Value end
    end
end))

WindUI:Notify({ Title = "zen hubX + Apex", Content = "Đã load thành công! Mở tab Farm Egg.", Duration = 5 })