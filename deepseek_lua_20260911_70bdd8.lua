--[[
    ZEN HUB X — MERGED EDITION
    Farm Egg + Visual Pet + Spy ESP + Teleport Step
    Nguồn: Apex Hub + ThanhDuyHub + zen hubX
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local VirtualUser       = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local DISCORD_LINK = "https://discord.gg/vGh9KqMsk"
local DISCORD_CODE = "vGh9KqMsk"

-- ============================================================
-- COMPAT
-- ============================================================
if type(table.pack) ~= "function" then function table.pack(...) return {n = select("#", ...), ...} end end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(v, mn, mx) if v < mn then return mn elseif v > mx then return mx end return v end
end
if type(table.find) ~= "function" then
    function table.find(t, v, init) if type(t) ~= "table" then return nil end
        for i = tonumber(init) or 1, #t do if t[i] == v then return i end end return nil end
end

local genv = (getgenv and getgenv()) or _G

-- ============================================================
-- DISCORD GATE
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
    local St = Instance.new("UIStroke", Frame)
    St.Color = Color3.fromHex("#8A2BE2"); St.Thickness = 2

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1
    Title.Text = "ZEN HUB X — XÁC MINH DISCORD"
    Title.TextColor3 = Color3.fromRGB(255,255,255); Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold

    local Desc = Instance.new("TextLabel", Frame)
    Desc.Size = UDim2.new(1, -30, 0, 50); Desc.Position = UDim2.fromOffset(15, 40)
    Desc.BackgroundTransparency = 1
    Desc.Text = "Bạn cần tham gia Server Discord để tiếp tục!"
    Desc.TextColor3 = Color3.fromRGB(180, 190, 210); Desc.TextSize = 12
    Desc.TextWrapped = true; Desc.Font = Enum.Font.Gotham

    local JoinBtn = Instance.new("TextButton", Frame)
    JoinBtn.Size = UDim2.new(1, -40, 0, 38); JoinBtn.Position = UDim2.fromOffset(20, 100)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
    JoinBtn.Text = "1. Tham Gia Discord"
    JoinBtn.TextColor3 = Color3.fromRGB(255,255,255); JoinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8)

    local VerifyBtn = Instance.new("TextButton", Frame)
    VerifyBtn.Size = UDim2.new(1, -40, 0, 38); VerifyBtn.Position = UDim2.fromOffset(20, 150)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(40,160,90)
    VerifyBtn.Text = "2. Xác Minh & Bắt Đầu"
    VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255); VerifyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    local clicked = false
    JoinBtn.MouseButton1Click:Connect(function()
        clicked = true
        if setclipboard then setclipboard(DISCORD_LINK) end
        local req = request or http_request or (syn and syn.request)
        if req then
            pcall(function()
                req({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",
                    Headers = {["Content-Type"]="application/json", ["Origin"]="https://discord.com"},
                    Body = HttpService:JSONEncode({ cmd="INVITE_BROWSER",
                        args = {code = DISCORD_CODE}, nonce = HttpService:GenerateGUID(false)})})
            end)
        end
        JoinBtn.Text = "✓ Đã sao chép / mở Discord!"
    end)
    VerifyBtn.MouseButton1Click:Connect(function()
        if clicked then isVerified = true; Gui:Destroy() end
    end)
end
CreateDiscordVerificationUI()
repeat task.wait(0.1) until isVerified

-- ============================================================
-- WINDUI
-- ============================================================
local cloneref = cloneref or clonereference or function(i) return i end
local WindUI
do
    local ok, result = pcall(function() return require("./src/Init") end)
    if ok then WindUI = result
    else
        if RunService:IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
        end
    end
end

local PurpleColor = Color3.fromHex("#8A2BE2")

-- ============================================================
-- CONSTANTS (rarity từ Apex Hub, area load động từ Data module)
-- ============================================================
local RARITIES = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Divine","Eternal"}
local RarityWeight = {Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythic=6,Cosmic=7,Secret=8,Eternal=9,Divine=10}
local MUTATIONS = {"Golden","Rainbow","Silver"}
local AREA_ORDER_FALLBACK = {"Forest","Lake","Desert","Jungle","Snow","Volcano","Abyss Ocean","Prehistoric","Cosmic"}
local STEAL_PRIORITIES = {"Rarest","Nearest","Furthest","Biggest Size"}

local AreaList, AreaLabelById, AreaRarityById = {}, {}, {}
local function LoadAreas()
    local Data = ReplicatedStorage:FindFirstChild("Data")
    local Areas = Data and Data:FindFirstChild("Areas")
    local ok, mod = pcall(function() return Areas and require(Areas) end)
    local dir = ok and type(mod) == "table" and (mod.Directory or mod) or nil
    if type(dir) == "table" then
        local entries = {}
        for id, item in pairs(dir) do
            if type(id) == "string" and type(item) == "table" then
                local rarity = 0
                local rname
                if type(item.Rarity) == "table" then
                    rarity = tonumber(item.Rarity.RarityNumber) or 0
                    rname = item.Rarity.DisplayName or item.Rarity._id
                end
                local label = item.DisplayName or item.Name or id
                entries[#entries+1] = {id = id, label = label, rarity = rarity, rname = rname}
            end
        end
        table.sort(entries, function(a,b)
            if a.rarity == b.rarity then return a.label < b.label end
            return a.rarity < b.rarity
        end)
        for _, e in ipairs(entries) do
            AreaLabelById[e.id] = e.label
            AreaRarityById[e.id] = e.rarity
            table.insert(AreaList, e.label)
        end
    end
    if #AreaList == 0 then
        for _, n in ipairs(AREA_ORDER_FALLBACK) do table.insert(AreaList, n) end
    end
end
LoadAreas()

-- ============================================================
-- STATE
-- ============================================================
local Config = {
    AutoFarmEgg = false,
    AutoReturn = true,
    SecretPriority = true,
    FarmMethod = "Speed",
    TeleportStep = 18,
    TeleportDelay = 0.04,
    StealSpeed = 800,
    BypassSpeed = 900,
    AntiCheat = false,
    HumReady = false,
    AntiTrap = true,
    AutoHatch = false,
    AutoPlace = false,
    AutoEquipBest = false,
    AutoClaim = false,
    ClaimInterval = 20,
    AutoUpgrade = false,
    AutoHop = false,
    MaxHops = 15,
    HopDelay = 20,
    HopCount = 0,
    EggESP = false,
    SpyEggESP = false,
    PetESP = false,
    FpsBoost = false,
    AreaFocus = {},
    RarityFilter = {},
    VisualPets = {},
    Unloaded = false,
}

local Character, HRP, Humanoid
local running = true
local IsBypassing = false
local OriginalSpeed = 16

local function track(c) return c end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function setupCharacter(char)
    if not char then return end
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)
    HRP = char:WaitForChild("HumanoidRootPart", 5)
    if Humanoid then
        if not Config.AntiCheat then OriginalSpeed = Humanoid.WalkSpeed end
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
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- ============================================================
-- REMOTES (từ Apex Hub + ThanhDuyHub)
-- ============================================================
local NetPackages = ReplicatedStorage:FindFirstChild("Packages")
NetPackages = NetPackages and NetPackages:FindFirstChild("Networking") or nil

local Remotes = {
    EggSnapshot = "RF/EggWorld/AskFieldEggSnapshot",
    EggCarry    = "RF/EggWorld/AskFieldEggCarry",
    EggPlace    = "RF/EggWorld/AskPlaceEgg",
    EggDrop     = "RF/EggWorld/AskFieldEggDrop",
    EggLive     = "RF/EggWorld/AskLiveSnapshot",
    Hatch       = "RF/EggWorld/AskHatch",
    HatchFinish = "RF/EggWorld/AskFinishHatch",
    SkipGrowth  = "RF/EggWorld/AskSkipGrowth",
    PlotState   = "RF/Homestead/AskState",
    BaseRaise   = "RE/Homestead/AskBaseTierRaise",
    Collect     = "RF/AwayEarnings/AskCollect",
    CodexAll    = "RF/Codex/AskRedeemAll",
    WearBest    = "RF/Haul/WearBest",
    SellEveryPet= "RE/PetSatchel/SellEveryPet",
    SellPet     = "RE/PetSatchel/SellPet",
    PetSnapshot = "RF/PenRoster/AskLiveSnapshot",
    TreadRaise  = "RF/Treadmill/AskTierRaise",
    WearTool    = "RF/EggWorld/AskWearTool",
    DoffTool    = "RF/EggWorld/AskDoffTool",
    RigWipe     = "RE/RigSync/AskRigWipe",
}

local function GetRemote(name)
    return NetPackages and NetPackages:FindFirstChild(name) or nil
end
local function InvokeNet(name, ...)
    local r = GetRemote(name)
    if not r then return nil end
    if r:IsA("RemoteFunction") then
        local ok, res = pcall(r.InvokeServer, r, ...)
        return ok and res or nil
    end
    return pcall(r.FireServer, r, ...) or nil
end

-- ============================================================
-- ANTI-CHEAT HUMANOID SWAP (từ Apex Hub + ThanhDuy)
-- ============================================================
local HUM_COPY = {"RigType","HipHeight","JumpPower","JumpHeight","UseJumpPower","AutoRotate",
    "MaxSlopeAngle","DisplayDistanceType","NameDisplayDistance","HealthDisplayDistance",
    "AutomaticScalingEnabled","BreakJointsOnDeath","RequiresNeck","EvaluateStateMachine"}

local function createAntiCheatHumanoid()
    local char = LocalPlayer.Character
    local oldHum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not oldHum then return false end
    local data = {}
    for _, k in ipairs(HUM_COPY) do
        local ok, v = pcall(function() return oldHum[k] end)
        if ok then data[k] = v end
    end
    local ws = oldHum.WalkSpeed
    pcall(function() oldHum:Destroy() end)
    RunService.Heartbeat:Wait()
    local newHum = Instance.new("Humanoid")
    for k, v in pairs(data) do pcall(function() newHum[k] = v end) end
    newHum.Parent = char
    RunService.Heartbeat:Wait()
    newHum.WalkSpeed = ws
    pcall(function() newHum:ChangeState(Enum.HumanoidStateType.Landed) end)
    local cam = Workspace.CurrentCamera
    if cam then pcall(function() cam.CameraSubject = newHum end) end
    Config.HumReady = true
    return true
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
RunService.Stepped:Connect(function()
    if IsBypassing then return end
    local h = getHum(); local r = getRoot()
    if not h or not r then return end
    h.PlatformStand = false
    local st = h:GetState()
    if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
    or st == Enum.HumanoidStateType.Physics then
        h:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("Motor6D") then v.Enabled = true end
    end
    local vel = r.AssemblyLinearVelocity
    if vel.Y > 30 then r.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
end)

-- ============================================================
-- BYPASS MOVE (từ Apex Hub)
-- ============================================================
local BYPASS_SPEED = 900
local function stripMovers(root)
    if not root then return end
    for _, inst in ipairs(root:GetChildren()) do
        local c = inst.ClassName
        if c == "BodyVelocity" or c == "BodyGyro" or c == "BodyPosition"
        or c == "LinearVelocity" or c == "VectorForce" then
            pcall(function() inst:Destroy() end)
        end
    end
end
local function bypassMoveTo(pos, keepGoing, speed)
    if typeof(pos) ~= "Vector3" or not running then return false end
    speed = speed or BYPASS_SPEED
    local root = getRoot(); if not root then return false end
    stripMovers(root)
    local h = getHum(); if h then h.Sit = false; h.PlatformStand = true end
    local dest = pos
    if (root.Position - dest).Magnitude <= 4 then
        if h then h.PlatformStand = false end
        return true
    end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 3000; bg.D = 50; bg.CFrame = root.CFrame; bg.Parent = root
    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then break end
        root = getRoot(); if not root then break end
        local off = dest - root.Position
        if off.Magnitude <= 4 then arrived = true; break end
        local dir = off.Unit
        bv.Velocity = dir * speed
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude > 0.001 then
            bg.CFrame = CFrame.lookAt(root.Position, root.Position + flat.Unit)
        end
        RunService.Heartbeat:Wait()
    end
    if bv.Parent then bv:Destroy() end
    if bg.Parent then bg:Destroy() end
    root = getRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        if arrived then root.CFrame = CFrame.new(dest) end
    end
    if h then h.PlatformStand = false end
    return arrived
end

-- ============================================================
-- EGG SCAN (từ ThanhDuy + Apex Hub, chuẩn hóa)
-- ============================================================
local function GetEggSlotPart(uid)
    local c = Workspace:FindFirstChild("AreaEggSlotsClient")
    local slot = c and c:FindFirstChild(uid)
    if not slot then return nil end
    return slot.PrimaryPart or slot:FindFirstChild("Hitbox") or slot:FindFirstChildWhichIsA("BasePart")
end

local function rarityRank(name)
    return RarityWeight[name] or 0
end

local function selectEgg()
    local snap = InvokeNet(Remotes.EggSnapshot)
    local records = snap and snap.Records
    if type(records) ~= "table" then return nil end
    local best, bestScore = nil, -math.huge
    local root = getRoot()
    for _, rec in pairs(records) do
        if rec.State == "Slot" and rec.Uid then
            local part = GetEggSlotPart(rec.Uid)
            local pos = part and part.Position
                or (rec.BoundsCFrame and rec.BoundsCFrame.Position)
                or (rec.BottomCFrame and rec.BottomCFrame.Position)
            if pos then
                local areaId = rec.AreaId or "Unknown"
                local rObj = rec.Rarity or rec.RarityName or rec.Tier or rec.RarityId
                if type(rObj) == "table" then rObj = rObj.DisplayName or rObj._id or rObj.Name end
                local rarityName = type(rObj) == "string" and rObj or "Common"
                local rank = rarityRank(rarityName)

                local areaMatch = true
                if next(Config.AreaFocus) then
                    areaMatch = Config.AreaFocus[AreaLabelById[areaId] or areaId] == true
                end
                local rarityMatch = true
                if next(Config.RarityFilter) then
                    rarityMatch = Config.RarityFilter[rarityName] == true
                end
                if Config.SecretPriority and rank >= 8 then rarityMatch = true end

                if areaMatch and rarityMatch then
                    local dist = root and (root.Position - pos).Magnitude or 0
                    local score = rank * 100000 - math.min(dist, 99999)
                    if score > bestScore then
                        bestScore = score
                        best = {uid = rec.Uid, pos = pos, rarity = rarityName, area = areaId, rank = rank}
                    end
                end
            end
        end
    end
    return best
end

-- ============================================================
-- PICKUP + RETURN (code người dùng cung cấp, chuẩn hóa)
-- ============================================================
local function HasItemAcquired()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if char and char:FindFirstChildOfClass("Tool") then return true end
    if bp and #bp:GetChildren() > 0 then return true end
    return false
end

local function NonLagStepTeleport(targetCFrame, checkDrop)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local stepSize = Config.TeleportStep
    local stepDelay = Config.TeleportDelay
    local startPos = hrp.Position
    local targetPos = targetCFrame.Position
    local dist = (targetPos - startPos).Magnitude
    if dist <= 3 then hrp.CFrame = targetCFrame; return true end
    local dir = (targetPos - startPos).Unit
    local totalSteps = math.ceil(dist / stepSize)
    local success = true
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
    for i = 1, totalSteps do
        if not Config.AutoFarmEgg then success = false; break end
        if checkDrop and not HasItemAcquired() then success = false; break end
        local currentDist = math.min(i * stepSize, dist)
        local nextPos = startPos + dir * currentDist
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(nextPos, nextPos + dir)
        RunService.Heartbeat:Wait()
        if stepDelay > 0 then task.wait(stepDelay) end
    end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Freefall) end)
    if success then
        hrp.CFrame = targetCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
    return success
end

local function GetBaseCFrame()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.CFrame
end

local isFarming = false

local function runFarmCycle()
    if isFarming then return end
    isFarming = true
    pcall(function()
        local target = selectEgg()
        if not target then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local baseCF = GetBaseCFrame()
        local eggCF = CFrame.new(target.pos)

        if not NonLagStepTeleport(eggCF, false) then return end
        local carryRemote = GetRemote(Remotes.EggCarry)
        if carryRemote then
            pcall(function() carryRemote:InvokeServer({Uid = target.uid}) end)
        end
        task.wait(0.12)
        if not baseCF then return end
        local reachedBase = NonLagStepTeleport(baseCF, true)
        if reachedBase then
            local placeRemote = GetRemote(Remotes.EggPlace)
            if placeRemote then
                pcall(function() placeRemote:InvokeServer({Uid = target.uid}) end)
            end
            task.wait(0.12)
        end
    end)
    isFarming = false
end

-- ============================================================
-- AUTO HATCH / PLACE / SELL / CLAIM / UPGRADE (Apex Hub)
-- ============================================================
local function getSave()
    local Save = ReplicatedStorage:FindFirstChild("Shared")
    Save = Save and Save:FindFirstChild("Save")
    if Save then
        local ok, mod = pcall(function() return require(Save) end)
        if ok and mod and type(mod.Get) == "function" then
            local ok2, save = pcall(mod.Get)
            return ok2 and save or nil
        end
    end
    return nil
end

local function runHatch()
    local live = InvokeNet(Remotes.EggLive)
    if type(live) ~= "table" then return end
    local function walk(tbl)
        for k, item in pairs(tbl) do
            if type(item) == "table" then
                local uid = item.Uid or (type(k) == "string" and k or nil)
                if uid then
                    InvokeNet(Remotes.SkipGrowth, uid)
                    InvokeNet(Remotes.Hatch, uid)
                    InvokeNet(Remotes.HatchFinish, uid)
                end
            end
        end
    end
    for _, group in pairs(live) do
        if type(group) == "table" and type(group.Records) == "table" then walk(group.Records) end
    end
end

local function runClaim()
    InvokeNet(Remotes.Collect)
    InvokeNet(Remotes.CodexAll)
end

local function runUpgrade()
    InvokeNet(Remotes.BaseRaise)
end

local function runEquipBest()
    InvokeNet(Remotes.WearBest)
end

local function runSellAll()
    InvokeNet(Remotes.SellEveryPet)
end

-- ============================================================
-- ESP (Apex Hub)
-- ============================================================
local EspFolder = Instance.new("Folder")
EspFolder.Name = "ZenHubX_ESP"
EspFolder.Parent = Workspace
local EspEntries = {}

local function espColor(rarity)
    local w = RarityWeight[rarity or ""] or 0
    if w >= 9 then return Color3.fromRGB(255,120,255)
    elseif w >= 7 then return Color3.fromRGB(255,90,90)
    elseif w >= 5 then return Color3.fromRGB(255,190,80)
    elseif w >= 3 then return Color3.fromRGB(110,195,255) end
    return Color3.fromRGB(200,200,210)
end

local function ensureEsp(id, color)
    if EspEntries[id] then return EspEntries[id] end
    local anchor = Instance.new("Part")
    anchor.Anchored = true; anchor.CanCollide = false; anchor.CanQuery = false
    anchor.Transparency = 1; anchor.Size = Vector3.new(0.2,0.2,0.2)
    anchor.Parent = EspFolder
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true; bb.Size = UDim2.fromOffset(200,30)
    bb.StudsOffset = Vector3.new(0,2.5,0); bb.Adornee = anchor; bb.Parent = anchor
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.fromScale(1,1)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
    lbl.TextStrokeTransparency = 0.4; lbl.TextColor3 = color
    lbl.Parent = bb
    EspEntries[id] = {anchor=anchor, bb=bb, lbl=lbl}
    return EspEntries[id]
end

local function drawEsp(id, pos, text, color)
    local e = ensureEsp(id, color)
    e.anchor.CFrame = CFrame.new(pos)
    e.lbl.Text = text; e.lbl.TextColor3 = color
end

local function clearEsp()
    for id, e in pairs(EspEntries) do
        if e.anchor then e.anchor:Destroy() end
        EspEntries[id] = nil
    end
end

local function runEggESP()
    clearEsp()
    local snap = InvokeNet(Remotes.EggSnapshot)
    local records = snap and snap.Records
    if type(records) ~= "table" then return end
    for _, rec in pairs(records) do
        if rec.State == "Slot" and rec.Uid then
            local part = GetEggSlotPart(rec.Uid)
            local pos = part and part.Position
                or (rec.BoundsCFrame and rec.BoundsCFrame.Position)
            if pos then
                local rObj = rec.Rarity or rec.RarityName or rec.Tier or rec.RarityId
                if type(rObj) == "table" then rObj = rObj.DisplayName or rObj._id or rObj.Name end
                local rarity = type(rObj) == "string" and rObj or "?"
                drawEsp("egg_"..rec.Uid, pos, tostring(rarity), espColor(rarity))
            end
        end
    end
end

-- ============================================================
-- VISUAL PETS (ThanhDuyHub - orbit)
-- ============================================================
local VP = {spawned = {}, radius = 4, speed = 0.8, folder = nil}
VP.folder = Instance.new("Folder")
VP.folder.Name = "ZenHubX_VisualPets"
VP.folder.Parent = Workspace

local function spawnVisualPet(name)
    local model
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") and d.Name:lower():find(name:lower(), 1, true)
        and d:FindFirstChildWhichIsA("BasePart") and not d:IsDescendantOf(VP.folder) then
            model = d; break
        end
    end
    if not model then return false end
    local clone = model:Clone()
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then d:Destroy() end
        if d:IsA("BasePart") then
            d.Anchored = true; d.CanCollide = false; d.CanTouch = false
        end
    end
    clone.Name = "VP_"..name
    clone.Parent = VP.folder
    VP.spawned[#VP.spawned+1] = {model = clone}
    return true
end

local function clearVisualPets()
    for _, v in ipairs(VP.spawned) do
        pcall(function() v.model:Destroy() end)
    end
    VP.spawned = {}
end

RunService.Heartbeat:Connect(function()
    if #VP.spawned == 0 then return end
    local root = getRoot(); if not root then return end
    local center = root.Position + Vector3.new(0, 1, 0)
    local n = #VP.spawned
    local t = tick()
    for i, v in ipairs(VP.spawned) do
        local a = (i-1) * (math.pi * 2 / n) + t * VP.speed
        local off = Vector3.new(math.cos(a) * VP.radius, 0, math.sin(a) * VP.radius)
        pcall(function() v.model:PivotTo(CFrame.new(center + off)) end)
    end
end)

-- ============================================================
-- ANTI-TRAP
-- ============================================================
local TRAP_WORDS = {"trap","cage","snare","bear_trap"}
local function isTrap(o)
    local n = o.Name:lower()
    for _, w in ipairs(TRAP_WORDS) do if n:find(w, 1, true) then return true end end
    return false
end
local function cleanTraps()
    if not Config.AntiTrap then return end
    for _, d in ipairs(Workspace:GetDescendants()) do
        if (d:IsA("Model") or d:IsA("BasePart")) and isTrap(d) then
            for _, c in ipairs(d:GetDescendants()) do
                if c:IsA("BasePart") then
                    pcall(function() c.CanTouch = false; c.CanCollide = false end)
                end
            end
        end
    end
end

-- ============================================================
-- SERVER HOP
-- ============================================================
local function fetchServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or type(body) ~= "string" then return {} end
    local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then return {} end
    local list = {}
    for _, s in ipairs(data.data) do
        if s.id and s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 30) then
            list[#list+1] = s.id
        end
    end
    return list
end

local function hopOnce()
    local list = fetchServers()
    if #list == 0 then return false end
    local target = list[math.random(1, #list)]
    Config.HopCount = Config.HopCount + 1
    pcall(function() TeleportService:TeleportToPlaceInstance(PlaceId, target, LocalPlayer) end)
    return true
end

-- ============================================================
-- UNLOAD
-- ============================================================
local function unload()
    Config.Unloaded = true
    running = false
    clearEsp()
    clearVisualPets()
    pcall(function() EspFolder:Destroy() end)
    pcall(function() VP.folder:Destroy() end)
end

-- ============================================================
-- UI
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = "zen hubX — Merged",
    Folder = "zenhubX_Merged",
    Icon = "solar:shield-bold",
    Theme = "Dark",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Mở Menu",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 2,
        Enabled = true, Draggable = true, OnlyMobile = false, Scale = 0.5,
        Color = ColorSequence.new(Color3.fromHex("#8A2BE2"), Color3.fromHex("#DA70D6")),
    },
    Topbar = {Height = 44, ButtonsType = "Mac"},
})
Window:Tag({Title = "v13.0 Merged", Icon = "solar:star-bold", Color = PurpleColor, Border = true})

-- Social
local Social = Window:Tab({Title = "Liên kết", Icon = "solar:link-bold", IconColor = PurpleColor, Border = true})
Social:Button({Title = "TikTok: zenhub.z", Desc = "Copy", Callback = function()
    if setclipboard then setclipboard("zenhub.z") end
    WindUI:Notify({Title = "zen hubX", Content = "Đã copy TikTok!"})
end})
Social:Space()
Social:Button({Title = "Discord", Desc = DISCORD_LINK, Callback = function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    WindUI:Notify({Title = "zen hubX", Content = "Đã copy Discord!"})
end})

-- Farm Egg
local FarmTab = Window:Tab({Title = "Farm Egg", Icon = "solar:egg-bold", IconColor = PurpleColor, Border = true})
FarmTab:Section({Title = "Auto Steal"})
FarmTab:Toggle({Title = "Bật Farm Egg", Desc = "Tự động tìm, nhặt, mang về base",
    Value = false, Callback = function(s) Config.AutoFarmEgg = s end})
FarmTab:Space()
FarmTab:Toggle({Title = "Auto Return to Base", Value = true,
    Callback = function(s) Config.AutoReturn = s end})
FarmTab:Space()
FarmTab:Toggle({Title = "Secret Priority", Desc = "Ưu tiên Secret/Divine/Eternal", Value = true,
    Callback = function(s) Config.SecretPriority = s end})
FarmTab:Space()
FarmTab:Dropdown({Title = "Farm Method", Values = {"Speed","TP Walk"}, Value = "Speed",
    Callback = function(v) Config.FarmMethod = v end})
FarmTab:Space()
FarmTab:Slider({Title = "Teleport Step", Step = 2,
    Value = {Min = 4, Max = 100, Default = 18},
    Callback = function(v) Config.TeleportStep = v end})
FarmTab:Space()
FarmTab:Slider({Title = "Teleport Delay (ms)", Step = 10,
    Value = {Min = 0, Max = 200, Default = 40},
    Callback = function(v) Config.TeleportDelay = v / 1000 end})

FarmTab:Section({Title = "Bộ Lọc Khu Vực"})
FarmTab:Dropdown({Title = "Chọn Khu Vực", Values = AreaList, Multi = true, Value = {},
    Callback = function(sel)
        Config.AreaFocus = {}
        if type(sel) == "table" then
            for k, v in pairs(sel) do
                if v == true then Config.AreaFocus[k] = true
                elseif type(v) == "string" then Config.AreaFocus[v] = true end
            end
        end
    end})

FarmTab:Section({Title = "Bộ Lọc Độ Hiếm"})
FarmTab:Dropdown({Title = "Chọn Rarity", Values = RARITIES, Multi = true, Value = {},
    Callback = function(sel)
        Config.RarityFilter = {}
        if type(sel) == "table" then
            for k, v in pairs(sel) do
                if v == true then Config.RarityFilter[k] = true
                elseif type(v) == "string" then Config.RarityFilter[v] = true end
            end
        end
    end})

FarmTab:Section({Title = "Anti-Cheat / Anti-Trap"})
FarmTab:Toggle({Title = "Anti-Cheat Humanoid Swap", Value = false,
    Callback = function(s)
        Config.AntiCheat = s
        if s then task.spawn(createAntiCheatHumanoid) end
    end})
FarmTab:Space()
FarmTab:Toggle({Title = "Anti-Trap", Value = true,
    Callback = function(s) Config.AntiTrap = s; if s then task.spawn(cleanTraps) end end})
FarmTab:Space()
FarmTab:Button({Title = "Quay Về Base Ngay", Callback = function()
    task.spawn(function()
        local base = GetBaseCFrame()
        if base then NonLagStepTeleport(base, false) end
    end)
end})

FarmTab:Section({Title = "Xử Lý Trứng"})
FarmTab:Toggle({Title = "Auto Hatch", Value = false,
    Callback = function(s) Config.AutoHatch = s end})
FarmTab:Space()
FarmTab:Button({Title = "Hatch Ngay", Callback = function() task.spawn(runHatch) end})
FarmTab:Space()
FarmTab:Button({Title = "Equip Best Pets", Callback = function() task.spawn(runEquipBest) end})
FarmTab:Space()
FarmTab:Button({Title = "Sell All Pets", Callback = function() task.spawn(runSellAll) end})

-- Server Hop
local HopTab = Window:Tab({Title = "Server Hop", Icon = "solar:server-square-bold", IconColor = PurpleColor, Border = true})
HopTab:Toggle({Title = "Auto Server Hop", Value = false,
    Callback = function(s) Config.AutoHop = s end})
HopTab:Space()
HopTab:Slider({Title = "Max Hops", Step = 1,
    Value = {Min = 1, Max = 100, Default = 15},
    Callback = function(v) Config.MaxHops = v end})
HopTab:Space()
HopTab:Slider({Title = "Hop Delay (s)", Step = 1,
    Value = {Min = 5, Max = 120, Default = 20},
    Callback = function(v) Config.HopDelay = v end})
HopTab:Space()
HopTab:Button({Title = "Hop Ngay", Callback = function() task.spawn(hopOnce) end})

-- Visual Pet
local VPTab = Window:Tab({Title = "Visual Pets", Icon = "solar:star-bold", IconColor = PurpleColor, Border = true})
local vpInput = ""
VPTab:Input({Title = "Tên Pet", Placeholder = "Ví dụ: Dragon",
    Callback = function(v) vpInput = v end})
VPTab:Space()
VPTab:Slider({Title = "Orbit Radius", Step = 1,
    Value = {Min = 2, Max = 20, Default = 4},
    Callback = function(v) VP.radius = v end})
VPTab:Space()
VPTab:Slider({Title = "Orbit Speed", Step = 1,
    Value = {Min = 0, Max = 10, Default = 1},
    Callback = function(v) VP.speed = v * 0.2 end})
VPTab:Space()
VPTab:Button({Title = "Spawn Pet", Callback = function()
    if vpInput ~= "" then
        local ok = spawnVisualPet(vpInput)
        WindUI:Notify({Title = "Visual Pets", Content = ok and "Đã spawn!" or "Không tìm thấy!"})
    end
end})
VPTab:Space()
VPTab:Button({Title = "Remove All", Callback = function()
    clearVisualPets()
    WindUI:Notify({Title = "Visual Pets", Content = "Đã xóa hết!"})
end})

-- ESP
local EspTab = Window:Tab({Title = "ESP", Icon = "solar:eye-bold", IconColor = PurpleColor, Border = true})
EspTab:Toggle({Title = "Egg ESP", Value = false, Callback = function(s)
    Config.EggESP = s
    if not s then clearEsp() end
end})

-- Movement
local MoveTab = Window:Tab({Title = "Movement", Icon = "solar:bolt-bold", IconColor = PurpleColor, Border = true})
MoveTab:Toggle({Title = "WalkSpeed Override", Value = false, Callback = function(s)
    if s then
        local h = getHum(); if h then h.WalkSpeed = Config.StealSpeed end
    else
        local h = getHum(); if h then h.WalkSpeed = OriginalSpeed end
    end
end})
MoveTab:Space()
MoveTab:Slider({Title = "WalkSpeed", Step = 10,
    Value = {Min = 16, Max = 500, Default = 300},
    Callback = function(v)
        Config.StealSpeed = v
        local h = getHum(); if h then h.WalkSpeed = v end
    end})
MoveTab:Space()
MoveTab:Button({Title = "Void Reset", Callback = function()
    local r = getRoot()
    if r then r.CFrame = CFrame.new(r.Position.X, -350, r.Position.Z) end
end})

-- Fix Lag
local LagTab = Window:Tab({Title = "Fix Lag", Icon = "solar:cpu-bold", IconColor = PurpleColor, Border = true})
LagTab:Button({Title = "Bật Fix Lag", Callback = function()
    Lighting.FogEnd = 1e6; Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")
        or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("tree") or n:find("leaf") or n:find("grass") or n:find("plant") then
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
end})

-- System
local SysTab = Window:Tab({Title = "System", Icon = "solar:settings-bold", IconColor = PurpleColor, Border = true})
SysTab:Toggle({Title = "Anti-AFK", Value = true, Callback = function(s) end})
SysTab:Space()
SysTab:Button({Title = "Unload Script", Callback = function()
    unload()
    pcall(function() Window:Destroy() end)
end})

-- ============================================================
-- BACKGROUND LOOPS
-- ============================================================
task.spawn(function()
    while running do
        task.wait(0.05)
        if Config.AutoFarmEgg and not isFarming then runFarmCycle() end
    end
end)

task.spawn(function()
    while running do
        task.wait(2)
        if Config.EggESP then pcall(runEggESP) end
        if Config.AntiTrap then pcall(cleanTraps) end
        if Config.AutoHatch then pcall(runHatch) end
    end
end)

task.spawn(function()
    while running do
        task.wait(Config.ClaimInterval)
        if Config.AutoClaim then pcall(runClaim) end
        if Config.AutoUpgrade then pcall(runUpgrade) end
        if Config.AutoEquipBest then pcall(runEquipBest) end
    end
end)

task.spawn(function()
    while running do
        task.wait(3)
        if Config.AutoHop and not isFarming then
            if Config.HopCount < Config.MaxHops then hopOnce() end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.End then
        unload(); pcall(function() Window:Destroy() end)
    end
end)

WindUI:Notify({Title = "zen hubX Merged", Content = "Đã load "..#AreaList.." khu vực! Mở tab Farm Egg.", Duration = 6})