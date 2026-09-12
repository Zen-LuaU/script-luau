--[[
    ZEN HUB X - ULTIMATE MERGED v15
    Kết hợp: Apex Hub + ThanhDuyHub + ZenHubX UI (WindUI)
    Discord: https://discord.gg/HSMcVtMsff
    Hỗ trợ 2 ngôn ngữ: Tiếng Việt / English
    ✅ FIX v15: Nhặt trứng → Quay về base NGAY LẬP TỨC (không chờ event)
    ✅ FIX v15: Chống chết/reset liên tục
--]]

local cloneref = cloneref or clonereference or function(i) return i end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local HttpService = cloneref(game:GetService("HttpService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local Lighting = cloneref(game:GetService("Lighting"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local GuiService = cloneref(game:GetService("GuiService"))
local PathfindingService = cloneref(game:GetService("PathfindingService"))

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local DISCORD_LINK = "https://discord.gg/HSMcVtMsff"
local DISCORD_CODE = "HSMcVtMsff"
local PurpleColor = Color3.fromHex("#8A2BE2")

-- COMPAT SHIMS
if type(table.pack) ~= "function" then function table.pack(...) return { n = select("#", ...), ... } end end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(v, mn, mx) if v < mn then return mn elseif v > mx then return mx end return v end
end
if type(table.find) ~= "function" then
    function table.find(t, v, init) if type(t) ~= "table" then return nil end for i = tonumber(init) or 1, #t do if t[i] == v then return i end end return nil end
end

if not game:IsLoaded() then game.Loaded:Wait() end

-- 🛡️ ANTI-CHEAT KICKER
if type(getgc) == "function" and type(getrawmetatable) == "function" and type(setmetatable) == "function" then
    pcall(function()
        for _, obj in getgc(true) do
            if typeof(obj) ~= "table" or getrawmetatable(obj) then continue end
            local mainrun = false
            for _, v in obj do if v == obj then mainrun = true break end end
            if not mainrun then continue end
            for _, v in obj do
                if typeof(v) == "number" and v >= 1 and v <= 3 and obj[v] == nil then
                    setmetatable(obj, {__newindex = function() end})
                    break
                end
            end
        end
    end)
end

-- 🌐 HỆ THỐNG NGÔN NGỮ
local Lang = "vi"
local dict = {
    vi = {
        menu_title = "zen hubX steal an egg", open_btn = "Mở Menu zen hubX", tag = "v15.0 - Fix Delay",
        notify_loaded = "Đã load! Nhấn nút bên trái để mở menu.",
        verify_title = "ZEN HUB X - XÁC MINH DISCORD",
        verify_desc = "Bạn cần tham gia Server Discord của chúng tôi để tiếp tục sử dụng Script!",
        join_btn = "1. Tham Gia Discord", verify_btn = "2. Xác Minh & Bắt Đầu Chơi",
        tab_farm = "Nông Trại", tab_pets = "Thú Cưng", tab_progress = "Tiến Trình",
        tab_player = "Nhân Vật", tab_anti = "Bảo Vệ", tab_system = "Hệ Thống",
    },
    en = {
        menu_title = "zen hubX steal an egg", open_btn = "Open zen hubX Menu", tag = "v15.0 - Delay Fix",
        notify_loaded = "Loaded! Press the left button to open the menu.",
        verify_title = "ZEN HUB X - DISCORD VERIFY",
        verify_desc = "You must join our Discord Server to continue using this Script!",
        join_btn = "1. Join Discord", verify_btn = "2. Verify & Start Playing",
        tab_farm = "Farm", tab_pets = "Pets", tab_progress = "Progress",
        tab_player = "Player", tab_anti = "Anti Features", tab_system = "System",
    }
}
function L(key) return (dict[Lang] and dict[Lang][key]) or key end

-- DISCORD VERIFICATION
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
    Stroke.Color = Color3.fromHex("#8A2BE2"); Stroke.Thickness = 2; Stroke.Parent = Frame
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1
    Title.Text = L("verify_title"); Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14; Title.Font = Enum.Font.GothamBold; Title.Parent = Frame
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -30, 0, 50); Desc.Position = UDim2.fromOffset(15, 40)
    Desc.BackgroundTransparency = 1; Desc.Text = L("verify_desc")
    Desc.TextColor3 = Color3.fromRGB(180, 190, 210); Desc.TextSize = 12
    Desc.TextWrapped = true; Desc.Font = Enum.Font.Gotham; Desc.Parent = Frame
    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Size = UDim2.new(1, -40, 0, 38); JoinBtn.Position = UDim2.fromOffset(20, 100)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); JoinBtn.Text = L("join_btn")
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); JoinBtn.TextSize = 13
    JoinBtn.Font = Enum.Font.GothamBold; JoinBtn.Parent = Frame
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8)
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -40, 0, 38); VerifyBtn.Position = UDim2.fromOffset(20, 150)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90); VerifyBtn.Text = L("verify_btn")
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); VerifyBtn.TextSize = 13
    VerifyBtn.Font = Enum.Font.GothamBold; VerifyBtn.Parent = Frame
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)
    local joined = false
    JoinBtn.MouseButton1Click:Connect(function()
        joined = true
        if setclipboard then setclipboard(DISCORD_LINK) end
        local req = request or http_request or (syn and syn.request) or fluxus.request
        if req then
            pcall(function()
                req({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",
                    Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                    Body = HttpService:JSONEncode({cmd = "INVITE_BROWSER", args = {code = DISCORD_CODE}, nonce = HttpService:GenerateGUID(false)})
                })
            end)
        end
        JoinBtn.Text = "✓ Copy OK!"
    end)
    VerifyBtn.MouseButton1Click:Connect(function()
        if joined then isVerified = true; Gui:Destroy() else VerifyBtn.Text = "⚠️ Click 1 first!"; task.wait(1.5); VerifyBtn.Text = L("verify_btn") end
    end)
end
CreateDiscordVerificationUI()
repeat task.wait(0.1) until isVerified

-- LOAD WINDUI
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

-- ============================================================
-- APEX HUB CORE
-- ============================================================
local H = {}
function H.cloneList(src) local out = {} if type(src) ~= "table" then return out end for i = 1, #src do out[i] = src[i] end return out end
function H.clearTable(tbl) if type(tbl) ~= "table" then return end for k in pairs(tbl) do tbl[k] = nil end end

local running = true
function H.waitFor(timeout, interval, check)
    local deadline = os.clock() + (tonumber(timeout) or 1)
    local gap = tonumber(interval) or 0.05
    local passed = false
    repeat
        if check and check() == true then passed = true
        elseif running and os.clock() < deadline then task.wait(gap) end
    until passed or (not running) or os.clock() >= deadline
    return passed
end

function H.requirePath(root, timeout, ...)
    local cur = root
    for _, name in ipairs({...}) do
        if not cur then return nil end
        local child = cur:FindFirstChild(name)
        if not child then child = cur:WaitForChild(name, timeout or 4) end
        cur = child
    end
    if not cur then return nil end
    local ok, mod = pcall(require, cur)
    return ok and mod or nil
end
function H.findModule(name)
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("ModuleScript") and d.Name == name then
            local ok, mod = pcall(require, d)
            if ok then return mod end
        end
    end
    return nil
end
function H.findRemote(name)
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and d.Name == name then return d end
    end
    return nil
end
function H.findRemoteContains(...)
    local parts = {...}
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
            local ok = true
            for _, part in ipairs(parts) do
                if not string.find(d.Name, part, 1, true) then ok = false; break end
            end
            if ok then return d end
        end
    end
    return nil
end
function H.pickFromTable(tbl, ...)
    if typeof(tbl) ~= "table" then return nil end
    local cur = tbl
    for _, name in ipairs({...}) do
        if typeof(cur) ~= "table" then return nil end
        cur = cur[name]
    end
    return cur
end
function H.pickFn(mod, ...)
    if typeof(mod) ~= "table" then return nil end
    for i = 1, select("#", ...) do
        local fn = mod[select(i, ...)]
        if typeof(fn) == "function" then return fn end
    end
    return nil
end
function H.remoteFrom(mod, ...)
    local inst = H.pickFromTable(mod, ...)
    if typeof(inst) == "Instance" then return inst end
    return nil
end

local SaveModule        = H.requirePath(ReplicatedStorage, 6, "Shared", "Save") or H.findModule("Save")
local Constants         = H.requirePath(ReplicatedStorage, 4, "Shared", "Globals", "Constants") or H.findModule("Constants")
local BaseUpgradeModule = H.requirePath(ReplicatedStorage, 4, "Client", "BaseUpgrade") or H.findModule("BaseUpgrade")
local EggTypes          = H.requirePath(ReplicatedStorage, 4, "Shared", "Types", "Eggs") or H.findModule("Eggs")
local AreasModule       = H.requirePath(ReplicatedStorage, 4, "Data", "Areas") or H.findModule("Areas")
local AssetsData        = H.requirePath(ReplicatedStorage, 4, "Data", "Assets") or H.findModule("Assets")
local GearsModule       = H.requirePath(ReplicatedStorage, 4, "Data", "Gears") or H.findModule("Gears")
local TrailsModule      = H.requirePath(ReplicatedStorage, 4, "Data", "Trails") or H.findModule("Trails")
local TreadmillsData    = H.requirePath(ReplicatedStorage, 4, "Data", "Treadmills") or H.findModule("Treadmills")
local EggStateModule    = H.requirePath(ReplicatedStorage, 6, "Client", "EggState") or H.findModule("EggState")
local PlotStateModule   = H.requirePath(ReplicatedStorage, 6, "Client", "PlotState") or H.findModule("PlotState")
local SlotIdentityModule= H.requirePath(ReplicatedStorage, 4, "Shared", "Util", "AreaEggSlotIdentity") or H.findModule("AreaEggSlotIdentity")
local AssetRosterModule = H.requirePath(ReplicatedStorage, 4, "Client", "AssetRoster") or H.findModule("AssetRoster")
local AssetItemsModule  = H.requirePath(ReplicatedStorage, 4, "Shared", "Util", "AssetItems") or H.findModule("AssetItems")
local FuseKernelModule  = H.requirePath(ReplicatedStorage, 4, "Shared", "Util", "FuseKernel") or H.findModule("FuseKernel")
local RemotesModule     = H.requirePath(ReplicatedStorage, 6, "Shared", "Remotes") or H.findModule("Remotes")

local EggApi = {
    GetAreaEggSnapshot = H.pickFn(EggStateModule, "ReadFieldEggs", "GetAreaEggSnapshot"),
    RequestAreaEggSnapshot = H.pickFn(EggStateModule, "SyncFieldEggs", "RequestAreaEggSnapshot"),
    AreaEggCarryStateChanged = EggStateModule and (EggStateModule.CarryChanged or EggStateModule.AreaEggCarryStateChanged),
    RequestCarryAreaEgg = H.pickFn(EggStateModule, "CarryFieldEgg", "RequestCarryAreaEgg"),
    RequestDropHeldAreaEgg = H.pickFn(EggStateModule, "DropFieldEgg", "RequestDropHeldAreaEgg"),
    IsLocalEggReady = H.pickFn(EggStateModule, "IsReadyToHatch", "IsLocalEggReady"),
    RequestHatchEgg = H.pickFn(EggStateModule, "BeginHatch", "RequestHatchEgg"),
    RequestCompleteHatchEgg = H.pickFn(EggStateModule, "FinishHatch", "RequestCompleteHatchEgg"),
    RequestEquipTool = H.pickFn(EggStateModule, "WearEggTool", "RequestEquipTool"),
    RequestPlaceEgg = H.pickFn(EggStateModule, "PlantEgg", "RequestPlaceEgg"),
}
local PlotApi = {
    GetRespawnPointCFrame = H.pickFn(PlotStateModule, "FindRespawnCFrame", "GetRespawnPointCFrame"),
    GetPlotData = H.pickFn(PlotStateModule, "ResolvePlot", "GetPlotData"),
    IsWorldPositionWithinLocalPlotBounds = H.pickFn(PlotStateModule, "ContainsLocalPoint", "IsWorldPositionWithinLocalPlotBounds"),
    GetSlotOwner = H.pickFn(PlotStateModule, "LookupOwner", "GetSlotOwner"),
}
local SlotIdentityApi = {
    IsFirstAreaUid = H.pickFn(SlotIdentityModule, "LooksLikeFirstAreaUid", "IsFirstAreaUid"),
    BuildSlotKey = H.pickFn(SlotIdentityModule, "SlotKey", "BuildSlotKey"),
}
local AssetRosterApi = { GetRuntimeSnapshot = H.pickFn(AssetRosterModule, "ReadSnapshot", "GetRuntimeSnapshot") }
local AssetItemsApi = { Deserialize = H.pickFn(AssetItemsModule, "Decode", "Deserialize") }
local FuseApi = {
    CanSelectPet = H.pickFn(FuseKernelModule, "MayEnterFuse", "CanSelectPet"),
    CalculateFusePrice = H.pickFn(FuseKernelModule, "PriceFor", "CalculateFusePrice"),
}

local Remotes = {
    Backpack = { EQUIP_BEST = H.remoteFrom(RemotesModule, "Haul", "WearBest") or H.findRemoteContains("WearBest") },
    Plots = { REQUEST_BASE_UPGRADE = H.remoteFrom(RemotesModule, "Homestead", "AskBaseTierRaise") or H.findRemoteContains("AskBaseTierRaise") },
    Treadmills = {
        REQUEST_UPGRADE = H.remoteFrom(RemotesModule, "Treadmill", "AskTierRaise") or H.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC = H.remoteFrom(RemotesModule, "Treadmill", "AskWearStill") or H.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP = H.remoteFrom(RemotesModule, "Treadmill", "AskDoff") or H.findRemoteContains("AskDoff"),
    },
    Index = { REQUEST_CLAIM_ALL = H.remoteFrom(RemotesModule, "Codex", "AskRedeemAll") or H.findRemoteContains("AskRedeemAll") },
    AssetInventory = { SELL_ASSET = H.remoteFrom(RemotesModule, "PetSatchel", "SellPet") or H.findRemoteContains("SellPet") },
    OfflineAssets = {
        GET_SUMMARY = H.remoteFrom(RemotesModule, "AwayEarnings", "FetchSummary") or H.findRemoteContains("FetchSummary"),
        REQUEST_REDEEM = H.remoteFrom(RemotesModule, "AwayEarnings", "AskCollect") or H.findRemoteContains("AskCollect"),
    },
    FuseMachine = {
        COMPLETE_REVEAL = H.remoteFrom(RemotesModule, "Fusery", "FinishReveal") or H.findRemoteContains("FinishReveal"),
        ACKNOWLEDGE_INFO = H.remoteFrom(RemotesModule, "Fusery", "ConfirmBriefing") or H.findRemoteContains("ConfirmBriefing"),
        INSERT_MOB = H.remoteFrom(RemotesModule, "Fusery", "LoadPet") or H.findRemoteContains("LoadPet"),
        START_FUSE = H.remoteFrom(RemotesModule, "Fusery", "BeginFuse") or H.findRemoteContains("BeginFuse"),
    },
    Trails = {
        REQUEST_PURCHASE = H.remoteFrom(RemotesModule, "Trailwear", "AskPurchase") or H.findRemoteContains("AskPurchase"),
        REQUEST_SELECT = H.remoteFrom(RemotesModule, "Trailwear", "AskChoose") or H.findRemoteContains("AskChoose"),
        WORN_SNAPSHOT = H.remoteFrom(RemotesModule, "Trailwear", "AskWornSnapshot") or H.findRemoteContains("AskWornSnapshot"),
    },
    GroupReward = { CLAIM_REWARD = H.remoteFrom(RemotesModule, "GroupPerk", "RedeemPerk") or H.findRemoteContains("RedeemPerk") },
}

local CarryRemote    = H.findRemote("RF/EggWorld/AskFieldEggCarry") or H.findRemoteContains("AskFieldEggCarry")
local SnapshotRemote = H.findRemote("RF/EggWorld/AskFieldEggSnapshot") or H.findRemoteContains("AskFieldEggSnapshot")
local PlaceRemote    = H.findRemote("RF/EggWorld/AskPlaceEgg") or H.findRemoteContains("AskPlaceEgg")

if not EggApi.RequestCarryAreaEgg and CarryRemote then
    EggApi.RequestCarryAreaEgg = function(uid, slotKey)
        if CarryRemote:IsA("RemoteFunction") then return CarryRemote:InvokeServer(uid, slotKey) end
        CarryRemote:FireServer(uid, slotKey); return true
    end
end
if not EggApi.RequestAreaEggSnapshot and SnapshotRemote then
    EggApi.RequestAreaEggSnapshot = function()
        if SnapshotRemote:IsA("RemoteFunction") then return SnapshotRemote:InvokeServer() end
        SnapshotRemote:FireServer()
    end
end
if not EggApi.RequestPlaceEgg and PlaceRemote then
    EggApi.RequestPlaceEgg = function(uid, cframe)
        if PlaceRemote:IsA("RemoteFunction") then return PlaceRemote:InvokeServer(uid, cframe) end
        PlaceRemote:FireServer(uid, cframe); return true
    end
end

-- CONSTANTS
local RARITIES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }
local RarityWeight = { Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10 }
local MUTATIONS = { "Golden", "Rainbow", "Silver" }
local STEAL_PRIORITIES = { "Rarest", "Nearest", "Furthest", "Biggest Size" }
local FUSE_TARGET_MODES = { "Highest Rarity", "Lowest Rarity", "Most Duplicates" }
local UPGRADE_TYPES = { "Base", "Treadmill" }
local PriorityTaskNames = { "Auto Steal Egg", "Auto Place Egg", "Auto Hatch", "Auto Treadmill" }
local PrioritySlotOptionNames = { "PrioritySlot1", "PrioritySlot2", "PrioritySlot3", "PrioritySlot4" }
local ServerHopModes = { "No Matching Eggs", "Timed Interval", "After Steal Count" }
local AREA_ORDER = { "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic" }

local AreaNames = {}
if AreasModule and typeof(AreasModule.Directory) == "table" then
    for areaName in pairs(AreasModule.Directory) do table.insert(AreaNames, areaName) end
    table.sort(AreaNames)
else
    AreaNames = H.cloneList(AREA_ORDER)
end

local TrailNames, TrailIdByName, TrailPriceByName = {}, {}, {}
if TrailsModule and typeof(TrailsModule.Directory) == "table" then
    local entries = {}
    for tid, td in pairs(TrailsModule.Directory) do table.insert(entries, { id = tid, name = td.DisplayName, price = tonumber(td.Price) or 0 }) end
    table.sort(entries, function(a, b) return a.price < b.price end)
    for _, e in ipairs(entries) do table.insert(TrailNames, e.name); TrailIdByName[e.name] = e.id; TrailPriceByName[e.name] = e.price end
end

local GearCostByName = {}
if GearsModule then
    local gd = GearsModule.Directory or GearsModule
    if typeof(gd) == "table" then
        for _, g in pairs(gd) do if typeof(g) == "table" and typeof(g.DisplayName) == "string" then GearCostByName[g.DisplayName] = tonumber(g.MoneyCost) or 0 end end
    end
end

-- STATE
local DEFAULT_STEAL_SPEED = 800
local BYPASS_SPEED = 900
local BASE_RETURN_ARRIVE = 4
local STEAL_HOLD_TIME = 1.5  -- 🔧 giảm từ 3s → 1.5s để nhanh hơn
local StealConfig = { GrabDelay = 0.3, ReturnPace = 0.12, ArriveDistance = 1.35, MoveTimeout = 14 }

-- 🔧 CẤU HÌNH STEP TELEPORT - nhanh và mượt
local StepTeleportConfig = {
    Step = 22,      -- Bước dài hơn để nhanh hơn
    Delay = 0.02,   -- Delay ngắn hơn
    Arrive = 4,     -- Khoảng coi như tới nơi
}

-- 🔧 FLAG ĐỂ PHÁT TÍN HIỆU QUAY VỀ BASE NGAY LẬP TỨC
local ForceReturnNow = false
local LastCarryRequestTime = 0

local conns = {}
local CurrentJobId = tostring(game.JobId)
local DisplayJobId = CurrentJobId
if #DisplayJobId > 18 then DisplayJobId = string.sub(DisplayJobId, 1, 18) .. "..." end

local IsCarryingEgg = false
local SessionStolenEggs = 0
local CarryStartedCallback = nil
local AutomationBusy = false
local AutomationLastRunAt = {}
local TreadmillTrainingActive = false
local ServerHopInProgress = false
local ServerHopRetryAfter = 0
local NoMatchingEggsSince = 0
local HopIntervalStartedAt = os.clock()
local LastTeleportFailure = nil
local LastEquipBestAt = 0
local NextPlacementIndex = 1
local PlotFullUntil = 0
local LastInputAt = tick()
local LastAntiAfkAt = tick()
local DisconnectHandled = false
local RenderingDisabled = false
local FpsBoostSnapshot = nil
local FpsDescendantAddedConnection = nil
local FpsCapUnsupportedNotified = false
local SessionStartedAt = os.clock()
local LastWebhookSummaryAt = os.clock()
local KnownWorldEggUids, KnownInventoryUids = {}, {}
local WebhookTrackerInitialized = false
local LastRebirthSnapshot = nil
local LastStealCountSnapshot = 0
local SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0, 0, 0
local SpawnedEggLog, ObtainedEggLog = {}, {}
local EspEntries, EspSeenThisPass = {}, {}

local HumReady = false
local IsBypassing = false
local ManualBase = nil
local SpeedChanger = false
local SpeedValue = 60
local OriginalSpeed = 16
local VoidUnstuck = false
local VisualPetsSpawned = {}
local VisualPetFolder = Instance.new("Folder")
VisualPetFolder.Name = "ZenHubX_VisualPets"
VisualPetFolder.Parent = Workspace

local VisitedServerIds = {}
if getgenv then
    local history = getgenv().ZenHubXHopHistory
    if typeof(history) ~= "table" then history = {}; getgenv().ZenHubXHopHistory = history end
    VisitedServerIds = history
end

local AreasFolder = Workspace:FindFirstChild("__OBJECTS") and Workspace.__OBJECTS:FindFirstChild("Areas")
if not AreasFolder then
    local objects = Workspace:WaitForChild("__OBJECTS", 8)
    AreasFolder = objects and objects:WaitForChild("Areas", 8)
end
local GuardAreasFolder = AreasFolder and AreasFolder:FindFirstChild("GuardAreas")
if AreasFolder and not GuardAreasFolder then GuardAreasFolder = AreasFolder:WaitForChild("GuardAreas", 6) end

local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")
if not AreaEggSlotsClient then AreaEggSlotsClient = Workspace:WaitForChild("AreaEggSlotsClient", 10) end

local EspFolder = Instance.new("Folder")
EspFolder.Name = "ZenHubX_Esp"
EspFolder.Parent = Workspace

function H.track(c) table.insert(conns, c); return c end

-- HELPERS
function H.getHumanoid() local ch = LocalPlayer.Character return ch and ch:FindFirstChildOfClass("Humanoid") or nil end
function H.getRoot() local ch = LocalPlayer.Character return ch and ch:FindFirstChild("HumanoidRootPart") or nil end
function H.getSave()
    if not SaveModule or typeof(SaveModule.Get) ~= "function" then return nil end
    local ok, save = pcall(SaveModule.Get)
    return ok and save or nil
end
function H.netInvoke(remote, ...)
    if typeof(remote) ~= "Instance" then return nil end
    local args = table.pack(...)
    local result, done = nil, false
    task.spawn(function()
        if remote:IsA("RemoteFunction") then
            result = table.pack(pcall(function() return remote:InvokeServer(table.unpack(args, 1, args.n)) end))
        elseif remote:IsA("RemoteEvent") then
            result = table.pack(pcall(function() remote:FireServer(table.unpack(args, 1, args.n)); return true end))
        else result = table.pack(false) end
        done = true
    end)
    H.waitFor(8, 0.05, function() return done == true end)
    if not done or result[1] ~= true then return nil end
    return result[2], result[3]
end
function H.netCall(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
        return pcall(function(...) remote:FireServer(...) end, ...)
    end
    return H.netInvoke(remote, ...)
end
function H.countTable(value) if typeof(value) ~= "table" then return 0 end local c = 0 for _ in pairs(value) do c = c + 1 end return c end
function H.formatNumber(value)
    local n = tonumber(value) or 0
    local suffixes = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local si = 1
    for _ = 1, 6 do if n >= 1000 then n = n / 1000; si = si + 1 end end
    if si == 1 then return string.format("%d", n) end
    return string.format("%.2f%s", n, suffixes[si])
end
function H.formatElapsed(s)
    local t = math.max(0, math.floor(s))
    local h = math.floor(t / 3600); local m = math.floor((t % 3600) / 60)
    if h > 0 then return string.format("%dh %dm", h, m) end
    return string.format("%dm", m)
end
function H.resolveRarity(assetCategory)
    if typeof(assetCategory) ~= "string" or not AssetsData or typeof(AssetsData.Directory) ~= "table" then return nil end
    local entry = AssetsData.Directory[assetCategory]
    local rarity = entry and entry.Rarity
    if not rarity then return nil end
    return rarity._id or rarity.DisplayName
end
function H.assetName(assetCategory)
    if AssetsData and typeof(AssetsData.Directory) == "table" then
        local entry = AssetsData.Directory[assetCategory or ""]
        if entry and entry.DisplayName then return entry.DisplayName end
    end
    return tostring(assetCategory or "Unknown")
end
function H.recordMutations(asset)
    local muts = {}
    if typeof(asset) ~= "table" then return muts end
    if typeof(asset.Mutations) == "table" then for _, m in pairs(asset.Mutations) do if typeof(m) == "string" then table.insert(muts, m) end end end
    if typeof(asset.BaseMutation) == "string" then table.insert(muts, asset.BaseMutation) end
    return muts
end
function H.getLaneZ()
    if AreasFolder then
        local gz = AreasFolder:FindFirstChild("GameplayZ")
        if gz and gz:IsA("BasePart") then return gz.Position.Z end
        local sl = AreasFolder:FindFirstChild("SeparationLine")
        if sl and sl:IsA("BasePart") then return sl.Position.Z end
    end
    return -365.5
end
function H.getLaneY()
    if AreasFolder then
        local gz = AreasFolder:FindFirstChild("GameplayZ")
        if gz and gz:IsA("BasePart") then return gz.Position.Y + 3 end
    end
    local root = H.getRoot()
    return root and root.Position.Y or 70
end
function H.getEntryPosition()
    if AreasFolder then
        local sa = AreasFolder:FindFirstChild("StartArea")
        if sa and sa:IsA("BasePart") then return Vector3.new(sa.Position.X, H.getLaneY(), H.getLaneZ()) end
        local sl = AreasFolder:FindFirstChild("SeparationLine")
        if sl and sl:IsA("BasePart") then return Vector3.new(sl.Position.X, H.getLaneY(), H.getLaneZ()) end
    end
    return Vector3.new(543.5, H.getLaneY(), H.getLaneZ())
end
function H.getZoneModel(zoneName) return GuardAreasFolder and GuardAreasFolder:FindFirstChild(zoneName) end
function H.getZoneLaneCenter(zoneName)
    local zone = H.getZoneModel(zoneName)
    if not zone then return nil end
    local bounds = zone:FindFirstChild("Bounds")
    if bounds and bounds:IsA("BasePart") then return Vector3.new(bounds.Position.X, H.getLaneY(), H.getLaneZ()) end
    local ok, pivot = pcall(function() return zone:GetBoundingBox() end)
    if ok and pivot then return Vector3.new(pivot.Position.X, H.getLaneY(), H.getLaneZ()) end
    return nil
end
function H.stripCheatMovers(root)
    if not root then return end
    for _, inst in ipairs(root:GetChildren()) do
        local cls = inst.ClassName
        if cls == "BodyVelocity" or cls == "BodyPosition" or cls == "BodyGyro" or cls == "BodyAngularVelocity" or cls == "LinearVelocity" or cls == "VectorForce" or cls == "AlignOrientation" then
            pcall(function() inst:Destroy() end)
        end
    end
end
function H.stopSoftMove(root)
    if not root then return end
    for _, inst in ipairs(root:GetChildren()) do
        if inst:IsA("AlignPosition") then pcall(function() inst.Enabled = false; inst:Destroy() end) end
    end
end
function H.placeRoot(root, cf)
    if not root or not cf then return end
    H.stopSoftMove(root); H.stripCheatMovers(root)
    local ch = LocalPlayer.Character
    if ch and ch.Parent then pcall(function() ch:PivotTo(cf) end)
    else root.CFrame = cf end
end
function H.groundedY(x, z, fallbackY)
    local laneY = H.getLaneY()
    local root = H.getRoot()
    local humanoid = H.getHumanoid()
    local hipHeight = 2
    if humanoid and humanoid.HipHeight > 0 then hipHeight = humanoid.HipHeight end
    local rootHalfHeight = root and root.Size.Y * 0.5 or 1
    local charOffset = hipHeight + rootHalfHeight
    local groundThreshold = laneY + 1.5
    local excluded = {}
    if LocalPlayer.Character then table.insert(excluded, LocalPlayer.Character) end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local originY = laneY + 40
    local hitY = nil
    for _ = 1, 20 do
        params.FilterDescendantsInstances = excluded
        local hit = Workspace:Raycast(Vector3.new(x, originY, z), Vector3.new(0, -160, 0), params)
        if not hit then break end
        local y = hit.Position.Y
        local name = hit.Instance.Name
        local looksLikeGround = name == "Ground" or string.find(string.lower(name), "ground", 1, true) ~= nil
        if looksLikeGround or y <= groundThreshold then hitY = y; break end
        table.insert(excluded, hit.Instance)
    end
    if hitY then return math.clamp(hitY + charOffset, laneY - 2, laneY + 5) end
    if typeof(fallbackY) == "number" then return math.clamp(fallbackY, laneY - 2, laneY + 5) end
    return laneY + 3
end
function H.stealSpeed() return DEFAULT_STEAL_SPEED end
function H.swapStealHumanoid()
    local ch = LocalPlayer.Character
    if not ch then return false end
    for _, d in ipairs(ch:GetDescendants()) do
        if d:IsA("LocalScript") and string.find(d.Name, "PushBack") then
            pcall(function() d.Disabled = true; d:Destroy() end)
        end
    end
    return true
end
function H.prepareStealHumanoid()
    local ch = LocalPlayer.Character
    if not ch then return nil end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local cam = Workspace.CurrentCamera
    local camCF = cam and cam.CFrame or nil
    local newHum
    local ok, clone = pcall(function() hum.Archivable = true; return hum:Clone() end)
    if ok and clone then
        newHum = clone
        newHum.Parent = ch
        pcall(function() hum:Destroy() end)
    else newHum = hum end
    task.wait(0.1)
    newHum = ch:FindFirstChildOfClass("Humanoid") or newHum
    if newHum then
        newHum.Sit = false
        newHum.PlatformStand = false
        newHum.WalkSpeed = H.stealSpeed()
        newHum.AutoRotate = true
    end
    if cam and newHum then
        pcall(function() cam.CameraSubject = newHum; if camCF then cam.CFrame = camCF end end)
    end
    return newHum
end

-- 🔧 KIỂM TRA CÓ VẬT PHẨM TRONG TAY/BALO
function H.hasItemAcquired()
    local ch = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if ch and ch:FindFirstChildOfClass("Tool") then return true end
    if bp and #bp:GetChildren() > 0 then return true end
    return false
end

-- 🔧 STEP TELEPORT MƯỢT - Nhanh hơn, ít delay hơn
function H.nonLagStepTeleport(targetCFrame, checkDrop)
    local ch = LocalPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    if hum.Health <= 0 then return false end  -- 🔧 không di chuyển nếu đã chết

    local stepSize = StepTeleportConfig.Step
    local stepDelay = StepTeleportConfig.Delay
    local startPos = hrp.Position
    local targetPos = targetCFrame.Position
    local dist = (targetPos - startPos).Magnitude

    if dist <= StepTeleportConfig.Arrive then
        hrp.CFrame = targetCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        return true
    end

    local dir = (targetPos - startPos).Unit
    local totalSteps = math.ceil(dist / stepSize)
    local success = true

    pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)

    for i = 1, totalSteps do
        if not running then success = false; break end
        -- 🔧 Không còn dừng khi rớt trứng nữa - vẫn về base để an toàn
        -- Chỉ cần checkDrop và rớt thì dừng NGAY
        if checkDrop and not H.hasItemAcquired() and not IsCarryingEgg then
            success = false
            break
        end
        -- 🔧 Nếu chết thì dừng
        local curHum = H.getHumanoid()
        if not curHum or curHum.Health <= 0 then success = false; break end

        local currentDist = math.min(i * stepSize, dist)
        local nextPos = startPos + (dir * currentDist)

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
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    return success
end

function H.buildStealPath(startPosition, targetPosition)
    local laneZ, laneY = H.getLaneZ(), H.getLaneY()
    local waypoints = {}
    if math.abs(startPosition.Z - laneZ) > 3 then table.insert(waypoints, Vector3.new(startPosition.X, laneY, laneZ)) end
    if math.abs(startPosition.X - targetPosition.X) > 2 then table.insert(waypoints, Vector3.new(targetPosition.X, laneY, laneZ)) end
    table.insert(waypoints, Vector3.new(targetPosition.X, laneY, targetPosition.Z))
    return waypoints
end
function H.humanoidStealMoveTo(position, keepGoing)
    if typeof(position) ~= "Vector3" or not running then return false end
    local ch = LocalPlayer.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local root = H.getRoot()
    if not hum or not root then return false end
    hum.Sit = false; hum.PlatformStand = false; hum.AutoRotate = true
    hum.WalkSpeed = H.stealSpeed()
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= StealConfig.ArriveDistance then return true end
    local route = H.buildStealPath(root.Position, dest)
    if #route == 0 then route = { dest } end
    for _, point in ipairs(route) do
        if not running or (keepGoing and not keepGoing()) then return false end
        root = H.getRoot(); if not root then return false end
        local pointY = H.groundedY(point.X, point.Z, root.Position.Y)
        local wp = Vector3.new(point.X, pointY, point.Z)
        while running do
            if keepGoing and not keepGoing() then return false end
            root = H.getRoot(); if not root then return false end
            local offset = wp - root.Position
            local dist = offset.Magnitude
            if dist <= StealConfig.ArriveDistance then break end
            local dir = offset.Unit
            local dt = math.clamp(RunService.Heartbeat:Wait(), 0, 1 / 30)
            local step = math.min(H.stealSpeed() * dt, dist)
            local nextPos = root.Position + dir * step
            local flatDir = Vector3.new(dir.X, 0, dir.Z)
            if flatDir.Magnitude > 0.001 then root.CFrame = CFrame.lookAt(nextPos, nextPos + flatDir.Unit)
            else root.CFrame = CFrame.new(nextPos) end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    root = H.getRoot(); if not root then return false end
    root.CFrame = CFrame.new(dest)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return (root.Position - dest).Magnitude <= math.max(3, StealConfig.ArriveDistance + 1)
end
function H.stealMoveTo(tx, tz, keepGoing)
    local root = H.getRoot(); if not root then return false end
    local y = H.groundedY(tx, tz, root.Position.Y)
    return H.humanoidStealMoveTo(Vector3.new(tx, y, tz), keepGoing)
end
function H.stealAlong(waypoints, keepGoing)
    for _, wp in ipairs(waypoints) do
        if keepGoing and not keepGoing() then return false end
        if not H.stealMoveTo(wp.X, wp.Z, keepGoing) then return false end
    end
    return true
end
function H.getBasePosition()
    if ManualBase then return ManualBase end
    if PlotApi.GetRespawnPointCFrame then
        local r = PlotApi.GetRespawnPointCFrame()
        if r then return r.Position end
    end
    if not PlotApi.GetPlotData then return nil end
    local plot = PlotApi.GetPlotData()
    if not plot then return nil end
    if plot.CenterPoint then return plot.CenterPoint.Position end
    if plot.PetArea then return plot.PetArea.Position end
    return nil
end
function H.getPetAreaStandPosition()
    if PlotApi.GetPlotData then
        local plot = PlotApi.GetPlotData()
        if plot and plot.PetArea then return plot.PetArea.Position + Vector3.new(0, 4, 0) end
    end
    return H.getBasePosition()
end
function H.isNearPlot()
    local root = H.getRoot(); if not root then return false end
    if PlotApi.IsWorldPositionWithinLocalPlotBounds and PlotApi.IsWorldPositionWithinLocalPlotBounds(root.Position) then return true end
    local stand = H.getPetAreaStandPosition()
    return stand ~= nil and (root.Position - stand).Magnitude <= 30
end
function H.bypassMoveTo(position, keepGoing, speed)
    if typeof(position) ~= "Vector3" or not running then return false end
    local root = H.getRoot(); if not root then return false end
    local dist = (position - root.Position).Magnitude
    if dist > 100 then
        return H.nonLagStepTeleport(CFrame.new(position), false)
    end
    speed = tonumber(speed) or BYPASS_SPEED
    H.stripCheatMovers(root); H.stopSoftMove(root)
    local hum = H.getHumanoid()
    if hum then hum.Sit = false; hum.PlatformStand = true end
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= BASE_RETURN_ARRIVE then
        if hum then hum.PlatformStand = false end
        return true
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ZenBypassMove"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "ZenBypassGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 3000; bg.D = 50; bg.CFrame = root.CFrame; bg.Parent = root
    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then break end
        root = H.getRoot(); if not root then break end
        local offset = dest - root.Position
        local d = offset.Magnitude
        if d <= BASE_RETURN_ARRIVE then arrived = true; break end
        local dir = offset.Unit
        bv.Velocity = dir * speed
        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0.001 then bg.CFrame = CFrame.lookAt(root.Position, root.Position + flatDir.Unit) end
        RunService.Heartbeat:Wait()
    end
    if bv and bv.Parent then bv:Destroy() end
    if bg and bg.Parent then bg:Destroy() end
    root = H.getRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if arrived then H.placeRoot(root, CFrame.new(dest.X, targetY, dest.Z)) end
    end
    hum = H.getHumanoid()
    if hum then hum.PlatformStand = false end
    return arrived
end
function H.holdAtPosition(seconds, keepGoing)
    seconds = tonumber(seconds) or 1.5
    local root = H.getRoot(); if not root then return false end
    local anchorCF = root.CFrame
    local deadline = os.clock() + seconds
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then return false end
        root = H.getRoot()
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = anchorCF
        end
        RunService.Heartbeat:Wait()
    end
    return true
end
function H.returnToBaseBypass(keepGoing)
    local base = H.getBasePosition()
    if not base then return false end
    if keepGoing and not keepGoing() then return false end
    return H.bypassMoveTo(Vector3.new(base.X, base.Y + 3, base.Z), keepGoing, BYPASS_SPEED)
end
function H.returnToBase(keepGoing) return H.returnToBaseBypass(keepGoing) end
function H.ensureAtPlot(keepGoing)
    if keepGoing and not keepGoing() then return false end
    if H.isNearPlot() then return true end
    local stand = H.getPetAreaStandPosition()
    if not stand then return false end
    return H.bypassMoveTo(stand, keepGoing, BYPASS_SPEED)
end

-- Egg / Steal
function H.getAreaEggs()
    if not EggApi.GetAreaEggSnapshot then return {} end
    local snap = EggApi.GetAreaEggSnapshot()
    if typeof(snap) ~= "table" or typeof(snap.Records) ~= "table" then
        if EggApi.RequestAreaEggSnapshot then pcall(EggApi.RequestAreaEggSnapshot) end
        snap = EggApi.GetAreaEggSnapshot()
    end
    if typeof(snap) ~= "table" or typeof(snap.Records) ~= "table" then return {} end
    local records = {}
    for _, rec in pairs(snap.Records) do
        if typeof(rec) == "table" and typeof(rec.Uid) == "string" then table.insert(records, rec) end
    end
    return records
end
function H.findAreaEggRecord(uid) for _, r in ipairs(H.getAreaEggs()) do if r.Uid == uid then return r end end return nil end
function H.getSlotEggPosition(inst)
    local part = inst:FindFirstChild("Hitbox") or inst:FindFirstChild("CustomBoundingBox") or inst:FindFirstChildOfClass("BasePart")
    if part then return part.Position end
    return inst:GetPivot().Position
end
function H.isBigEgg(egg)
    if not H.isOn("StealBigEggs") then return false end
    local scale = tonumber(egg.AssetScale)
    if not scale then return false end
    return scale >= (tonumber(H.optionValue("StealBigEggScale", 1.5)) or 1.5)
end
function H.eggScore(egg) return RarityWeight[H.resolveRarity(egg.AssetCategory) or "Common"] or 0 end
function H.isStealCandidate(record, bypassFilters)
    if typeof(record) ~= "table" or typeof(record.Uid) ~= "string" then return false end
    if record.State ~= "Slot" and record.State ~= "Dropped" then return false end
    if bypassFilters then return true end
    if H.isBigEgg(record) and H.selectionAllows("StealZones", record.AreaId) then return true end
    if not H.isOn("AutoStealSelected") then return false end
    return H.matchesEggFilters(record, "StealZones", "StealRarities", "StealMutations")
end
function H.pickStealTarget()
    local worldEggs = AreaEggSlotsClient and AreaEggSlotsClient:GetChildren() or {}
    if #worldEggs == 0 then return nil end
    local recordsByUid = {}
    for _, r in ipairs(H.getAreaEggs()) do if typeof(r.Uid) == "string" then recordsByUid[r.Uid] = r end end
    local bypassFilters = H.isOn("AutoStealAll") and not H.isOn("AutoStealSelected")
    local root = H.getRoot()
    local priority = H.optionValue("StealPriority", "Rarest")
    local bestEgg, bestScore = nil, -math.huge
    for _, inst in ipairs(worldEggs) do
        local record = recordsByUid[inst.Name]
        local cand = record and H.isStealCandidate(record, bypassFilters) or (record == nil and bypassFilters)
        if cand then
            local pos = H.getSlotEggPosition(inst)
            local dist = root and pos and (root.Position - pos).Magnitude or math.huge
            local score
            if priority == "Nearest" then score = -dist
            elseif priority == "Furthest" then score = dist
            elseif priority == "Biggest Size" then score = tonumber(record and record.AssetScale) or 0
            else score = (record and H.eggScore(record) or 0) * 100000 - math.min(dist, 99999) end
            if score > bestScore then bestEgg = inst; bestScore = score end
        end
    end
    return bestEgg
end
function H.stealingEnabled() return H.isOn("AutoStealSelected") or H.isOn("AutoStealAll") or H.isOn("StealBigEggs") end
function H.eggInventoryCount()
    local save = H.getSave()
    local inv = save and save.EggInventory
    if typeof(inv) ~= "table" then return 0 end
    return H.countTable(inv)
end
function H.eggInventoryFull()
    local cap = EggTypes and tonumber(EggTypes.MAX_INVENTORY) or math.huge
    return H.eggInventoryCount() >= cap
end
function H.canAutoSteal() return H.stealingEnabled() and not IsCarryingEgg and not H.eggInventoryFull() end
function H.tryCarryEgg(eggInstance)
    if not eggInstance or not EggApi.RequestCarryAreaEgg then return false end
    local uid = eggInstance.Name
    local slotKey = nil
    if SlotIdentityApi.IsFirstAreaUid and SlotIdentityApi.IsFirstAreaUid(uid) then
        for _, r in ipairs(H.getAreaEggs()) do
            if r.Uid == uid and SlotIdentityApi.BuildSlotKey then
                slotKey = SlotIdentityApi.BuildSlotKey(r.AreaId, r.NestId); break
            end
        end
    end
    local ok, carried = pcall(function() return EggApi.RequestCarryAreaEgg(uid, slotKey) end)
    if ok and carried == true then return true end
    return IsCarryingEgg
end

-- ============================================================
-- 🔥 STEAL EGG - FIX v15: QUAY VỀ BASE NGAY LẬP TỨC
-- ============================================================
function H.stealEgg(slotEgg)
    H.swapStealHumanoid()
    if not H.prepareStealHumanoid() then return false end
    local targetPos = H.getSlotEggPosition(slotEgg)
    local root = H.getRoot()
    if not root or not targetPos then return false end

    -- Bước 1: Tới trứng
    local targetY = H.groundedY(targetPos.X, targetPos.Z, targetPos.Y)
    local eggCF = CFrame.new(targetPos.X, targetY, targetPos.Z)
    if not H.nonLagStepTeleport(eggCF, false) then return false end
    if not H.stealingEnabled() then return false end

    -- ⚡ Bước 2: GỬI CARRY REQUEST VÀ PHÁT TÍN HIỆU QUAY VỀ BASE NGAY
    local uid = slotEgg.Name
    local slotKey = nil
    if SlotIdentityApi.IsFirstAreaUid and SlotIdentityApi.IsFirstAreaUid(uid) then
        for _, r in ipairs(H.getAreaEggs()) do
            if r.Uid == uid and SlotIdentityApi.BuildSlotKey then
                slotKey = SlotIdentityApi.BuildSlotKey(r.AreaId, r.NestId); break
            end
        end
    end

    -- Gọi carry remote
    local carrySuccess = false
    pcall(function()
        if EggApi.RequestCarryAreaEgg then
            local r = EggApi.RequestCarryAreaEgg(uid, slotKey)
            carrySuccess = (r == true) or IsCarryingEgg
        end
    end)

    -- 🔥 BẮT ĐẦU QUAY VỀ BASE NGAY LẬP TỨC - KHÔNG CHỜ EVENT
    -- Đây là chìa khóa để fix delay
    LastCarryRequestTime = tick()
    ForceReturnNow = true

    -- Chờ CỰC NGẮN để tool xuất hiện (tối đa 0.15s thay vì 0.5s)
    local t0 = tick()
    while tick() - t0 < 0.15 do
        if H.hasItemAcquired() then break end
        task.wait(0.01)
    end

    -- Lấy base và bắt đầu step teleport về NGAY
    local base = H.getBasePosition()
    if not base then
        ForceReturnNow = false
        return false
    end
    local baseY = H.groundedY(base.X, base.Z, base.Y)
    local baseCF = CFrame.new(base.X, baseY + 3, base.Z)

    -- 🔥 BƯỚC 3: TELEPORT VỀ BASE NGAY - checkDrop = true để dừng nếu rớt
    local reachedBase = H.nonLagStepTeleport(baseCF, true)

    ForceReturnNow = false

    -- Chờ ngắn xác nhận
    if reachedBase then
        local confirmDeadline = os.clock() + 1
        while running and H.stealingEnabled() and IsCarryingEgg and os.clock() < confirmDeadline do
            task.wait(0.05)
        end
    end
    return true
end

function H.runAutoSteal()
    if IsCarryingEgg or H.eggInventoryFull() then return false end
    local target = H.pickStealTarget()
    if not target then return false end
    return H.stealEgg(target)
end
function H.runAutoDropEgg()
    if not IsCarryingEgg then return false end
    if EggApi.RequestDropHeldAreaEgg then return pcall(function() EggApi.RequestDropHeldAreaEgg("PlayerRequest") end) end
    return false
end
function H.runAutoReturn()
    if not IsCarryingEgg then return false end
    local base = H.getBasePosition()
    if not base then return false end
    local baseY = H.groundedY(base.X, base.Z, base.Y)
    local baseCF = CFrame.new(base.X, baseY + 3, base.Z)
    H.nonLagStepTeleport(baseCF, true)
    local root = H.getRoot()
    if root and PlotApi.IsWorldPositionWithinLocalPlotBounds and PlotApi.IsWorldPositionWithinLocalPlotBounds(root.Position) then
        H.waitFor(3, 0.15, function() return (not IsCarryingEgg) or (not H.isOn("AutoReturn")) end)
    end
    return true
end

-- 🔥 LISTENER: Khi event báo có trứng → phát tín hiệu về base ngay
if EggApi.AreaEggCarryStateChanged and typeof(EggApi.AreaEggCarryStateChanged.Connect) == "function" then
    H.track(EggApi.AreaEggCarryStateChanged:Connect(function(state)
        local carryingNow = typeof(state) == "table" and state.IsCarrying == true
        local started = carryingNow and not IsCarryingEgg
        if started then
            SessionStolenEggs = SessionStolenEggs + 1
            -- 🔥 Phát tín hiệu quay về base ngay khi nhận được event
            ForceReturnNow = true
            if CarryStartedCallback then CarryStartedCallback(state) end
        end
        IsCarryingEgg = carryingNow
    end))
end

-- Place / Hatch / Sell / Fuse / Upgrades
function H.getUnplacedEggUids()
    local save = H.getSave()
    local inv = save and save.EggInventory
    local result = {}
    if typeof(inv) ~= "table" then return result end
    local bypass = H.isOn("AutoPlaceAll") and not H.isOn("AutoPlaceSelected")
    for uid, egg in pairs(inv) do
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil
            and (bypass or H.matchesEggFilters(egg, nil, "LifecycleRarities", "LifecycleMutations")) then
            table.insert(result, uid)
        end
    end
    return result
end
function H.placingEnabled() return H.isOn("AutoPlaceSelected") or H.isOn("AutoPlaceAll") end
function H.isPlotFull() return os.clock() < PlotFullUntil end
function H.markPlotFull() PlotFullUntil = os.clock() + 30 end
function H.getPlacementLocalCFrames()
    if not PlotApi.GetPlotData then return {} end
    local plot = PlotApi.GetPlotData()
    if not plot or not plot.PetArea or not plot.CenterPoint then return {} end
    local petArea, centerPoint = plot.PetArea, plot.CenterPoint
    local sz = petArea.Size
    local placements = {}
    for x = -sz.X * 0.5 + 5, sz.X * 0.5 - 5, 7 do
        for z = -sz.Z * 0.5 + 5, sz.Z * 0.5 - 5, 7 do
            local wp = petArea.CFrame:PointToWorldSpace(Vector3.new(x, 1, z))
            table.insert(placements, centerPoint.CFrame:ToObjectSpace(CFrame.new(wp)))
        end
    end
    return placements
end
function H.canAutoPlace()
    return H.placingEnabled() and not IsCarryingEgg and not H.isPlotFull() and #H.getUnplacedEggUids() > 0
end
function H.runAutoPlaceEggs(forceRun)
    if IsCarryingEgg or not EggApi.RequestPlaceEgg then return end
    local function cont() return (forceRun == true or H.placingEnabled()) and not IsCarryingEgg end
    local unplaced = H.getUnplacedEggUids()
    if #unplaced == 0 or not H.ensureAtPlot(cont) then return end
    local placements = H.getPlacementLocalCFrames()
    if #placements == 0 then return end
    local placedAny = false
    for _, uid in ipairs(unplaced) do
        if not running or not cont() then return placedAny end
        if not H.isNearPlot() and not H.ensureAtPlot(cont) then return placedAny end
        if EggApi.RequestEquipTool then pcall(EggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        local placedThis = false
        for offset = 0, #placements - 1 do
            local pi = (NextPlacementIndex + offset - 1) % #placements + 1
            local success = false
            pcall(function() success = EggApi.RequestPlaceEgg(uid, placements[pi]) == true end)
            if success then
                NextPlacementIndex = pi + 1
                placedThis = true; placedAny = true
                task.wait(0.25); break
            end
        end
        if not placedThis then H.markPlotFull(); return placedAny end
        PlotFullUntil = 0
    end
    return placedAny
end
function H.canAutoHatch() return H.isOn("AutoOpenReadyEggs") and not IsCarryingEgg end
function H.runAutoOpenReadyEggs()
    local save = H.getSave()
    local inv = save and save.EggInventory
    if typeof(inv) ~= "table" then return end
    local hatchedAny = false
    for uid, egg in pairs(inv) do
        if not running or not H.isOn("AutoOpenReadyEggs") then return hatchedAny end
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement ~= nil
            and H.matchesEggFilters(egg, nil, "LifecycleRarities", "LifecycleMutations") then
            local ready = false
            if EggApi.IsLocalEggReady then pcall(function() ready = EggApi.IsLocalEggReady(uid) == true end) end
            if ready and EggApi.RequestHatchEgg then
                local started = false
                pcall(function() started = EggApi.RequestHatchEgg(uid) == true end)
                if started then
                    hatchedAny = true
                    if EggApi.RequestCompleteHatchEgg then pcall(EggApi.RequestCompleteHatchEgg, uid) end
                    task.wait(0.35)
                end
            end
        end
    end
    return hatchedAny
end
function H.getPetItemData(serializedPet)
    if not AssetItemsApi.Deserialize then return nil end
    local ok, data = pcall(AssetItemsApi.Deserialize, serializedPet)
    if not ok or typeof(data) ~= "table" then return nil end
    return data
end
function H.findToolByUid(uid)
    local conts = { LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }
    for _, c in ipairs(conts) do
        if c then
            for _, ch in ipairs(c:GetChildren()) do
                if ch:IsA("Tool") and ch:GetAttribute("UID") == uid then return ch end
            end
        end
    end
    return nil
end
function H.holdUid(uid)
    local ch = LocalPlayer.Character
    local hum = H.getHumanoid()
    if not ch or not hum then return false end
    local tool = H.findToolByUid(uid)
    if not tool then return false end
    if tool.Parent == ch then return true end
    pcall(function() hum:EquipTool(tool) end)
    return H.waitFor(1, 0.05, function() return tool.Parent == LocalPlayer.Character end)
end
function H.sellUid(uid)
    if not H.holdUid(uid) then return false end
    H.netCall(Remotes.AssetInventory.SELL_ASSET, uid)
    return H.waitFor(2, 0.1, function()
        local save = H.getSave(); if not save then return false end
        local inv = save.Inventory or {}
        local eggInv = save.EggInventory or {}
        return inv[uid] == nil and eggInv[uid] == nil
    end)
end
function H.getSellablePets()
    local save = H.getSave()
    local inv = save and save.Inventory
    local result = {}
    if typeof(inv) ~= "table" then return result end
    local equipped = save.EquippedAssets or {}
    local maxScale = tonumber(H.optionValue("SellMaxScale", 10)) or 10
    local keepMutated = H.isOn("SellKeepMutated")
    local keepEquipped = H.isOn("SellKeepEquipped")
    local selMut = H.multiSelected("SellMutations")
    local filterMut = H.multiHasAny("SellMutations")
    local selRar = H.multiSelected("SellRarities")
    local filterRar = H.multiHasAny("SellRarities")
    for uid, asset in pairs(inv) do
        if typeof(uid) == "string" and typeof(asset) == "table" then
            local data = H.getPetItemData(asset)
            local isEquipped = table.find(equipped, uid) ~= nil
            local protected = not data or data.IsFavorite == true or data.InFuse == true or (keepEquipped and isEquipped)
            if not protected then
                local muts = H.recordMutations(asset)
                local mutAllowed = not (keepMutated and #muts > 0)
                if mutAllowed and filterMut then
                    mutAllowed = false
                    for _, m in ipairs(muts) do if selMut[m] then mutAllowed = true; break end end
                end
                local scale = tonumber(asset.Scale) or 0
                local rarity = H.resolveRarity(asset.Category)
                local rarAllowed = not filterRar or (typeof(rarity) == "string" and selRar[rarity] == true)
                if mutAllowed and scale <= maxScale and rarAllowed then table.insert(result, uid) end
            end
        end
    end
    return result
end
function H.runAutoSellPets()
    for _, uid in ipairs(H.getSellablePets()) do
        if not running or not H.isOn("AutoSellPets") or IsCarryingEgg then return end
        H.sellUid(uid); task.wait(0.15)
    end
end
function H.getSellableEggUids()
    local save = H.getSave()
    local inv = save and save.EggInventory
    local result = {}
    if typeof(inv) ~= "table" then return result end
    local useRar = H.multiHasAny("SellEggRarities")
    local selRar = H.multiSelected("SellEggRarities")
    for uid, egg in pairs(inv) do
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil then
            local rarity = H.resolveRarity(egg.AssetCategory)
            if not useRar or (typeof(rarity) == "string" and selRar[rarity] == true) then table.insert(result, uid) end
        end
    end
    return result
end
function H.runAutoSellEggs()
    for _, uid in ipairs(H.getSellableEggUids()) do
        if not running or not H.isOn("AutoSellEggs") or IsCarryingEgg then return end
        if EggApi.RequestEquipTool then pcall(EggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        H.sellUid(uid); task.wait(0.15)
    end
end
function H.fuseGroups(save)
    local inv = save and save.Inventory
    local groups = {}
    if typeof(inv) ~= "table" then return groups end
    local equipped = save.EquippedAssets or {}
    local keepEquipped = H.isOn("FuseKeepEquipped")
    local keepMutated = H.isOn("FuseKeepMutated")
    local maxScale = tonumber(H.optionValue("FuseMaxScale", 10)) or 10
    local filterMut = H.multiHasAny("FuseMutations")
    local selMut = H.multiSelected("FuseMutations")
    for uid, pet in pairs(inv) do
        if typeof(uid) == "string" and typeof(pet) == "table" then
            local cat = pet.Category
            local selectable = false
            if typeof(cat) == "string" and FuseApi.CanSelectPet then
                pcall(function() selectable = FuseApi.CanSelectPet(uid, pet, cat, false) == true end)
            end
            if selectable and not (keepEquipped and table.find(equipped, uid) ~= nil) then
                local muts = H.recordMutations(pet)
                local mutAllowed = not (keepMutated and #muts > 0)
                if mutAllowed and filterMut then
                    mutAllowed = false
                    for _, m in ipairs(muts) do if selMut[m] then mutAllowed = true; break end end
                end
                local rarity = H.resolveRarity(cat)
                local scale = tonumber(pet.Scale) or 0
                local rarAllowed = rarity == nil or H.selectionAllows("FuseRarities", rarity)
                if mutAllowed and scale <= maxScale and rarAllowed then
                    groups[cat] = groups[cat] or {}
                    table.insert(groups[cat], { uid = uid, scale = scale })
                end
            end
        end
    end
    return groups
end
function H.pickFuseGroup(save)
    local groups = H.fuseGroups(save)
    local keepPerCat = math.floor(tonumber(H.optionValue("FuseKeepPerCategory", 0)) or 0)
    local mode = H.optionValue("FuseTarget", "Highest Rarity")
    local selCat, selScore = nil, -math.huge
    for cat, pets in pairs(groups) do
        table.sort(pets, function(a, b) return a.scale < b.scale end)
        if #pets - keepPerCat >= 3 then
            local rarScore = RarityWeight[H.resolveRarity(cat) or "Common"] or 0
            local score = rarScore
            if mode == "Most Duplicates" then score = #pets
            elseif mode == "Lowest Rarity" then score = -rarScore end
            if score > selScore then selCat = cat; selScore = score end
        end
    end
    if not selCat then return nil end
    local pets = groups[selCat]
    return { pets[1].uid, pets[2].uid, pets[3].uid }
end
function H.fusePrice(save, petUids)
    local inv = save and save.Inventory
    if typeof(inv) ~= "table" or not FuseApi.CalculateFusePrice then return nil end
    local data = {}
    for i, uid in ipairs(petUids) do
        local pet = inv[uid]
        local decoded = pet and H.getPetItemData(pet)
        if not decoded then return nil end
        data[i] = decoded
    end
    local ok, price = pcall(FuseApi.CalculateFusePrice, data)
    return ok and tonumber(price) or nil
end
function H.getFuseMachinePosition()
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    local fm = machines and machines:FindFirstChild("FuseMachine")
    if not fm then return nil end
    local ok, pivot = pcall(function() return fm:GetPivot() end)
    if not ok or not pivot then return nil end
    return pivot.Position + Vector3.new(0, 4, 0)
end
function H.runAutoFusePets(forceRun)
    local save = H.getSave(); if not save then return end
    local function cont() return forceRun == true or H.isOn("AutoFusePets") end
    if save.FusionLocked == true then
        if H.isOn("FuseAutoReveal") or forceRun == true then H.netInvoke(Remotes.FuseMachine.COMPLETE_REVEAL) end
        return
    end
    local uids = H.pickFuseGroup(save)
    if not uids then return end
    local price = H.fusePrice(save, uids)
    if price and (tonumber(save.Money) or 0) < price then return end
    local pos = H.getFuseMachinePosition()
    if pos and not H.bypassMoveTo(pos, cont, BYPASS_SPEED) then return end
    if save.FusionInfoAcknowledged ~= true then H.netInvoke(Remotes.FuseMachine.ACKNOWLEDGE_INFO) end
    for _, uid in ipairs(uids) do
        if not running or not cont() then return end
        H.netInvoke(Remotes.FuseMachine.INSERT_MOB, uid)
        task.wait(0.2)
    end
    H.netInvoke(Remotes.FuseMachine.START_FUSE)
    return true
end
function H.runAutoEquipBest()
    local now = Workspace:GetServerTimeNow()
    if now - LastEquipBestAt < 5 then return end
    LastEquipBestAt = now
    H.netCall(Remotes.Backpack.EQUIP_BEST)
end
function H.runAutoEquipBestTrail()
    local save = H.getSave()
    local owned = save and save.TrailInventory
    if typeof(owned) ~= "table" then return false end
    local bestId, bestPrice = nil, -1
    for _, name in ipairs(TrailNames) do
        local id = TrailIdByName[name]
        if id and owned[id] then
            local price = TrailPriceByName[name] or 0
            if price > bestPrice then bestPrice = price; bestId = id end
        end
    end
    local worn = H.netInvoke(Remotes.Trails.WORN_SNAPSHOT)
    local wornId = typeof(worn) == "table" and worn[tostring(LocalPlayer.UserId)] or nil
    if not bestId or wornId == bestId then return false end
    H.netInvoke(Remotes.Trails.REQUEST_SELECT, bestId)
    return true
end
function H.gearBaseName(name) return tostring(name):gsub("%s*%[X%d+%]%s*$", "") end
function H.runAutoEquipBestGear()
    local ch = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local hum = H.getHumanoid()
    if not ch or not bp or not hum then return end
    local best, bestCost = nil, -1
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            local cost = GearCostByName[H.gearBaseName(tool.Name)]
            if cost and cost > bestCost then bestCost = cost; best = tool end
        end
    end
    for _, tool in ipairs(ch:GetChildren()) do
        if tool:IsA("Tool") then
            local cost = GearCostByName[H.gearBaseName(tool.Name)]
            if cost and cost >= bestCost then return end
        end
    end
    if best then pcall(function() hum:EquipTool(best) end) end
end
function H.runAutoBuyTrail()
    local save = H.getSave()
    if not save or not H.multiHasAny("TrailWanted") then return false end
    local wanted = H.multiSelected("TrailWanted")
    local owned = save.TrailInventory or {}
    local bought = false
    for _, name in ipairs(TrailNames) do
        if wanted[name] then
            local id = TrailIdByName[name]
            if id and not owned[id] then
                local price = TrailPriceByName[name] or 0
                if save.Money >= price then
                    H.netCall(Remotes.Trails.REQUEST_PURCHASE, id)
                    bought = true; task.wait(0.35)
                    save = H.getSave() or save
                    owned = save.TrailInventory or owned
                end
            end
        end
    end
    return bought
end
function H.runAutoUpgrades()
    local sel = H.multiSelected("UpgradeTypes")
    if not H.multiHasAny("UpgradeTypes") then sel = { Base = true, Treadmill = true } end
    local save = H.getSave(); if not save then return false end
    local upgraded = false
    if sel.Base and BaseUpgradeModule and typeof(BaseUpgradeModule.IsNextTierAffordable) == "function" then
        if BaseUpgradeModule.IsNextTierAffordable(save) then
            H.netCall(Remotes.Plots.REQUEST_BASE_UPGRADE)
            upgraded = true; task.wait(0.35)
        end
    end
    if sel.Treadmill and TreadmillsData and typeof(TreadmillsData.GetByUpgradeLevel) == "function" then
        local lvl = tonumber(save.TreadmillUpgradeLevel) or 0
        local nxt = TreadmillsData.GetByUpgradeLevel(lvl + 1)
        if nxt then
            local price = tonumber(nxt.Price) or math.huge
            if save.Money >= price then
                H.netCall(Remotes.Treadmills.REQUEST_UPGRADE, nxt._id)
                upgraded = true; task.wait(0.35)
            end
        end
    end
    return upgraded
end
function H.runAutoClaimIndex() H.netCall(Remotes.Index.REQUEST_CLAIM_ALL) end
function H.runClaimOfflineEarnings()
    local summary = H.netInvoke(Remotes.OfflineAssets.GET_SUMMARY)
    if typeof(summary) ~= "table" then return false end
    if (tonumber(summary.ClaimableAmount) or 0) <= 0 then return false end
    H.netCall(Remotes.OfflineAssets.REQUEST_REDEEM)
    return true
end
function H.runAutoClaimGroupReward()
    local save = H.getSave()
    if save and save.ClaimedGroupReward == true then return false end
    local inGroup = false
    pcall(function()
        inGroup = Constants and Constants.GROUP_ID and LocalPlayer:IsInGroupAsync(Constants.GROUP_ID) == true
    end)
    H.netInvoke(Remotes.GroupReward.CLAIM_REWARD, inGroup)
    return true
end
function H.deleteOwnPetRenders()
    local ra = Workspace:FindFirstChild("ClientRenderedAssets")
    if not ra then return end
    for _, obj in ipairs(ra:GetChildren()) do
        if obj:GetAttribute("OwnerUserId") == LocalPlayer.UserId then pcall(function() obj:Destroy() end) end
    end
end
function H.getTreadmillStand()
    if not PlotApi.GetPlotData then return nil end
    local plot = PlotApi.GetPlotData()
    local pf = plot and plot.PlotFolder
    local tm = pf and pf:FindFirstChild("TreadmillBottom")
    if not tm or not tm:IsA("BasePart") then return nil end
    return tm.Position + Vector3.new(0, 4, 0)
end
function H.isDoubleSpeedVisible()
    local ok, vis = pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local el = pg and pg:FindFirstChild("Elements")
        local left = el and el:FindFirstChild("Left")
        local tools = left and left:FindFirstChild("Tools")
        local ds = tools and tools:FindFirstChild("DoubleYourSpeed")
        return ds ~= nil and ds.Visible == true
    end)
    return ok and vis == true
end
function H.dismountTreadmill()
    pcall(function()
        local input = game:GetService("VirtualInputManager")
        input:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        input:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    local hum = H.getHumanoid()
    if hum then hum.Jump = true; hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
function H.stopTreadmillTraining()
    TreadmillTrainingActive = false
    pcall(function() H.netInvoke(Remotes.Treadmills.REQUEST_UNEQUIP) end)
    if H.isDoubleSpeedVisible() then
        H.dismountTreadmill(); task.wait(0.1)
        if H.isDoubleSpeedVisible() then H.dismountTreadmill() end
    end
end
function H.canAutoTreadmill() return H.isOn("AutoTreadmill") and not IsCarryingEgg end
function H.runAutoTreadmillTraining()
    local pos = H.getTreadmillStand()
    if not pos then return end
    local root = H.getRoot(); if not root then return end
    if (root.Position - pos).Magnitude > 12 then
        if not H.bypassMoveTo(pos, nil, BYPASS_SPEED) then return end
    end
    H.netInvoke(Remotes.Treadmills.REQUEST_EQUIP_STATIC)
    TreadmillTrainingActive = true
    return true
end

local WaypointNames = { "Base", "Pet Area", "Treadmill", "Fuse Machine", "Lobby Entry" }
for _, z in ipairs(AREA_ORDER) do table.insert(WaypointNames, z) end
function H.resolveWaypoint(name)
    if typeof(name) ~= "string" then return nil end
    if name == "Base" then return H.getBasePosition()
    elseif name == "Pet Area" then return H.getPetAreaStandPosition()
    elseif name == "Treadmill" then return H.getTreadmillStand()
    elseif name == "Fuse Machine" then return H.getFuseMachinePosition()
    elseif name == "Lobby Entry" then return H.getEntryPosition() end
    return H.getZoneLaneCenter(name)
end

-- ESP
function H.espDistanceLimit() return tonumber(H.optionValue("EspDistance", 2000)) or 2000 end
function H.withinEspRange(pos) local root = H.getRoot() return root ~= nil and (root.Position - pos).Magnitude <= H.espDistanceLimit() end
function H.espColorFor(rarity)
    local w = RarityWeight[rarity or ""] or 0
    if w >= 9 then return Color3.fromRGB(255, 120, 255)
    elseif w >= 7 then return Color3.fromRGB(255, 90, 90)
    elseif w >= 5 then return Color3.fromRGB(255, 190, 80)
    elseif w >= 3 then return Color3.fromRGB(110, 195, 255) end
    return Color3.fromRGB(190, 200, 215)
end
function H.ensureEspEntry(id, color)
    local ex = EspEntries[id]; if ex then return ex end
    local anchor = Instance.new("Part")
    anchor.Name = "EspAnchor"; anchor.Anchored = true; anchor.CanCollide = false
    anchor.CanQuery = false; anchor.CanTouch = false; anchor.Transparency = 1
    anchor.Size = Vector3.new(0.2, 0.2, 0.2); anchor.Parent = EspFolder
    local bb = Instance.new("BillboardGui")
    bb.Name = "EspLabel"; bb.AlwaysOnTop = true
    bb.Size = UDim2.fromOffset(220, 34); bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.Adornee = anchor; bb.Parent = anchor
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Text"; lbl.BackgroundTransparency = 1; lbl.Size = UDim2.fromScale(1, 1)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextStrokeTransparency = 0.4
    lbl.TextColor3 = color; lbl.Parent = bb
    local entry = { anchor = anchor, billboard = bb, label = lbl, highlight = nil }
    EspEntries[id] = entry
    return entry
end
function H.drawEspAt(id, pos, text, color, adornee)
    local entry = H.ensureEspEntry(id, color)
    entry.anchor.CFrame = CFrame.new(pos)
    entry.label.Text = text; entry.label.TextColor3 = color
    if adornee and adornee.Parent then
        if not entry.highlight then
            local h = Instance.new("Highlight")
            h.FillTransparency = 0.6; h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = EspFolder; entry.highlight = h
        end
        entry.highlight.Adornee = adornee
        entry.highlight.FillColor = color; entry.highlight.OutlineColor = color
    elseif entry.highlight then entry.highlight:Destroy(); entry.highlight = nil end
    EspSeenThisPass[id] = true
end
function H.releaseEsp(id)
    local e = EspEntries[id]; if not e then return end
    if e.highlight then e.highlight:Destroy() end
    if e.billboard then e.billboard:Destroy() end
    if e.anchor then e.anchor:Destroy() end
    EspEntries[id] = nil
end
function H.clearAllEsp() for id in pairs(EspEntries) do H.releaseEsp(id) end end
function H.collectEggEsp()
    local showW = H.isOn("EspWorldEggs"); local showC = H.isOn("EspCarriedEggs")
    if not showW and not showC then return end
    for _, egg in ipairs(H.getAreaEggs()) do
        local cf = egg.BottomCFrame or egg.BoundsCFrame
        if cf then
            local st = egg.State
            local should = (st == "Slot" and showW) or ((st == "Dropped" or st == "Carried") and showC)
            if should and H.withinEspRange(cf.Position) then
                local rar = H.resolveRarity(egg.AssetCategory)
                local lbl = string.format("%s [%s]", H.assetName(egg.AssetCategory), tostring(rar or "?"))
                if st == "Dropped" or st == "Carried" then lbl = string.format("%s\n%s", lbl, tostring(st)) end
                H.drawEspAt("egg_" .. egg.Uid, cf.Position, lbl, H.espColorFor(rar), nil)
            end
        end
    end
end
function H.collectGuardEsp()
    if not H.isOn("EspGuards") or not GuardAreasFolder then return end
    for _, ga in ipairs(GuardAreasFolder:GetChildren()) do
        local guard = ga:FindFirstChild("Guard")
        local ok, pivot = pcall(function() return guard and guard:GetPivot() or nil end)
        if ok and pivot and H.withinEspRange(pivot.Position) then
            H.drawEspAt("guard_" .. ga.Name, pivot.Position,
                string.format("Guard %s\n%s", ga.Name, tostring(guard:GetAttribute("GuardState") or "Idle")),
                Color3.fromRGB(255, 140, 90), guard)
        end
    end
end
function H.collectPetEsp()
    if not H.isOn("EspPets") then return end
    local ra = Workspace:FindFirstChild("ClientRenderedAssets")
    if not ra then return end
    local save = H.getSave()
    local inv = save and save.Inventory or {}
    local runtimeByUid = {}
    pcall(function()
        if AssetRosterApi.GetRuntimeSnapshot then
            local snap = AssetRosterApi.GetRuntimeSnapshot() or {}
            for _, group in pairs(snap) do
                if typeof(group) == "table" and typeof(group.Records) == "table" then
                    for uid, r in pairs(group.Records) do runtimeByUid[uid] = r end
                end
            end
        end
    end)
    for _, rp in ipairs(ra:GetChildren()) do
        local uid = rp:GetAttribute("UID")
        local ok, pivot = pcall(function() return rp:GetPivot() end)
        if typeof(uid) == "string" and ok and pivot and H.withinEspRange(pivot.Position) then
            local cat, mps = nil, nil
            local savedPet = inv[uid]
            if typeof(savedPet) == "table" then cat = savedPet.Category end
            local rt = runtimeByUid[uid]
            if typeof(rt) == "table" then
                if not cat and rt.ItemData then cat = rt.ItemData.Category end
                mps = tonumber(rt.MoneyPerSecond)
            end
            local rar = H.resolveRarity(cat)
            local lbl = string.format("%s [%s]", H.assetName(cat), tostring(rar or "?"))
            if mps then lbl = string.format("%s\n%s/s", lbl, H.formatNumber(mps)) end
            H.drawEspAt("pet_" .. rp.Name, pivot.Position, lbl, H.espColorFor(rar), rp)
        end
    end
end
function H.collectPlayerEsp()
    if not H.isOn("EspPlayers") then return end
    local lr = H.getRoot()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local ch = p.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if root and H.withinEspRange(root.Position) then
                local dist = lr and (lr.Position - root.Position).Magnitude or 0
                H.drawEspAt("player_" .. p.Name, root.Position,
                    string.format("%s\n%d studs", p.DisplayName, math.floor(dist)),
                    Color3.fromRGB(120, 190, 255), ch)
            end
        end
    end
end
function H.collectMachineEsp()
    if not H.isOn("EspMachines") then return end
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    if not machines then return end
    for _, m in ipairs(machines:GetChildren()) do
        local ok, pivot = pcall(function() return m:GetPivot() end)
        if ok and pivot and H.withinEspRange(pivot.Position) then
            H.drawEspAt("machine_" .. m.Name, pivot.Position, m.Name, Color3.fromRGB(230, 200, 120), m)
        end
    end
end
function H.collectPlotEsp()
    if not H.isOn("EspPlots") then return end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        local anchor = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("CenterPoint")
        if anchor and anchor:IsA("BasePart") and H.withinEspRange(anchor.Position) then
            local ownerId = nil
            pcall(function() if PlotApi.GetSlotOwner then ownerId = PlotApi.GetSlotOwner(tonumber(plot.Name)) end end)
            local ownerText = "Empty"
            local nid = tonumber(ownerId)
            if nid then
                local owner = Players:GetPlayerByUserId(nid)
                if owner then
                    ownerText = owner.DisplayName
                    if owner == LocalPlayer then ownerText = ownerText .. " (You)" end
                else ownerText = "User " .. tostring(nid) end
            end
            H.drawEspAt("plot_" .. plot.Name, anchor.Position,
                string.format("Plot %s\n%s", plot.Name, ownerText),
                Color3.fromRGB(200, 170, 255), nil)
        end
    end
end
function H.runEsp()
    H.clearTable(EspSeenThisPass)
    H.collectEggEsp(); H.collectGuardEsp(); H.collectPetEsp()
    H.collectPlayerEsp(); H.collectMachineEsp(); H.collectPlotEsp()
    for id in pairs(EspEntries) do if not EspSeenThisPass[id] then H.releaseEsp(id) end end
end

-- Server Hop
function H.rememberVisited(serverId)
    if typeof(serverId) ~= "string" or serverId == "" then return end
    if H.countTable(VisitedServerIds) >= 300 then H.clearTable(VisitedServerIds) end
    VisitedServerIds[serverId] = true
end
H.rememberVisited(tostring(game.JobId))
H.track(TeleportService.TeleportInitFailed:Connect(function(p, r, e) if p == LocalPlayer then LastTeleportFailure = tostring(e or r) end end))
function H.fetchServerPage(cursor)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100", game.PlaceId)
    if cursor then url = url .. "&cursor=" .. cursor end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or typeof(body) ~= "string" then return nil end
    local dok, page = pcall(function() return HttpService:JSONDecode(body) end)
    if not dok or typeof(page) ~= "table" or typeof(page.data) ~= "table" then return nil end
    return page
end
function H.pickHopTargets()
    local cursor = nil; local cands = {}
    for _ = 1, 4 do
        local page = H.fetchServerPage(cursor)
        if not page then break end
        for _, s in ipairs(page.data) do
            if typeof(s) == "table" and typeof(s.id) == "string" and s.id ~= game.JobId and not VisitedServerIds[s.id] then
                local playing = tonumber(s.playing) or 0
                local maxP = tonumber(s.maxPlayers) or 0
                if maxP > 0 and playing < maxP then table.insert(cands, { id = s.id, playing = playing }) end
            end
        end
        cursor = typeof(page.nextPageCursor) == "string" and page.nextPageCursor or nil
        if not cursor or #cands >= 40 then break end
        task.wait(0.25)
    end
    table.sort(cands, function(a, b) return a.playing < b.playing end)
    return cands
end
function H.tryTeleportTo(serverId)
    LastTeleportFailure = nil
    local started = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer) end)
    if not started then return false end
    H.waitFor(20, 0.25, function() return LastTeleportFailure ~= nil or (not running) end)
    if LastTeleportFailure then return false end
    return true
end
function H.serverHop(reason)
    if ServerHopInProgress or os.clock() < ServerHopRetryAfter then return false end
    ServerHopInProgress = true
    local targets = H.pickHopTargets()
    if typeof(targets) ~= "table" or #targets == 0 then
        ServerHopRetryAfter = os.clock() + 30; ServerHopInProgress = false; return false
    end
    for attempt = 1, 3 do
        if attempt > 1 then
            targets = H.pickHopTargets()
            if typeof(targets) ~= "table" or #targets == 0 then
                ServerHopRetryAfter = os.clock() + 10; ServerHopInProgress = false; return false
            end
        end
        for i = 1, math.min(#targets, 10) do
            if not running then ServerHopInProgress = false; return false end
            local t = targets[i]; H.rememberVisited(t.id)
            if H.tryTeleportTo(t.id) then ServerHopInProgress = false; return true end
            task.wait(0.5)
        end
    end
    ServerHopRetryAfter = os.clock() + 10; ServerHopInProgress = false; return false
end
function H.runServerHop()
    if IsCarryingEgg or ServerHopInProgress then return end
    local mode = H.optionValue("HopMode", ServerHopModes[1])
    local threshold = tonumber(H.optionValue("HopValue", 15)) or 15
    local now = os.clock()
    if mode == "Timed Interval" then
        if now - HopIntervalStartedAt >= threshold * 60 then H.serverHop("Interval reached") end
        return
    end
    if mode == "After Steal Count" then
        if SessionStolenEggs >= threshold then H.serverHop(string.format("Stole %d eggs", SessionStolenEggs)) end
        return
    end
    if H.pickStealTarget() ~= nil then NoMatchingEggsSince = 0; return end
    if NoMatchingEggsSince == 0 then NoMatchingEggsSince = now
    elseif now - NoMatchingEggsSince >= threshold then
        NoMatchingEggsSince = 0; H.serverHop("No matching eggs")
    end
end
function H.rejoinServer()
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    if not ok then pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end
end

-- Webhook
function H.webhookPing()
    local nid = tostring(H.optionValue("WebhookPingId", "") or ""):gsub("%D", "")
    if nid == "" then return nil end
    return string.format("<@%s>", nid)
end
function H.httpPost(payload)
    local reqFn = (syn and syn.request) or (http and http.request) or http_request or request
    if typeof(reqFn) ~= "function" then return false end
    local url = tostring(H.optionValue("WebhookUrl", "") or "")
    if url == "" then return false end
    local enc; local ok = pcall(function() enc = HttpService:JSONEncode(payload) end)
    if not ok then return false end
    return pcall(reqFn, { Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = enc })
end
function H.sendWebhookEmbed(embed, ping)
    if not H.isOn("WebhookEnabled") then return false end
    local payload = { username = "ZenHubX", embeds = { embed } }
    if ping then payload.content = H.webhookPing() end
    return H.httpPost(payload)
end
function H.embedField(name, value, inline) return { name = name, value = value, inline = inline ~= false } end
CarryStartedCallback = function(eventData)
    if typeof(eventData) ~= "table" then return end
    local rec = typeof(eventData.Uid) == "string" and H.findAreaEggRecord(eventData.Uid) or nil
    local cat = rec and rec.AssetCategory or eventData.AssetCategory
    local parts = { string.format("**%s** `%s`", H.assetName(cat), tostring(H.resolveRarity(cat) or "?")) }
    if #ObtainedEggLog < 100 then table.insert(ObtainedEggLog, table.concat(parts, " | ")) end
end
function H.trackWebhookEvents()
    local save = H.getSave(); if not save then return end
    if not WebhookTrackerInitialized then
        WebhookTrackerInitialized = true
        for uid in pairs(save.Inventory or {}) do KnownInventoryUids[uid] = true end
        for _, e in ipairs(H.getAreaEggs()) do KnownWorldEggUids[e.Uid] = true end
        LastRebirthSnapshot = tonumber(save.Rebirth) or 0
        LastStealCountSnapshot = SessionStolenEggs
        return
    end
    SummaryStolenEggs = SummaryStolenEggs + math.max(0, SessionStolenEggs - LastStealCountSnapshot)
    LastStealCountSnapshot = SessionStolenEggs
    for uid in pairs(save.Inventory or {}) do
        if KnownInventoryUids[uid] == nil then KnownInventoryUids[uid] = true; SummaryPetsObtained = SummaryPetsObtained + 1 end
    end
    local rb = tonumber(save.Rebirth) or 0
    if LastRebirthSnapshot and rb > LastRebirthSnapshot then SummaryRebirths = SummaryRebirths + rb - LastRebirthSnapshot end
    LastRebirthSnapshot = rb
end
function H.buildSummaryEmbed()
    local save = H.getSave(); local fields = {}
    if save then
        table.insert(fields, H.embedField("Money", "`" .. H.formatNumber(save.Money) .. "`"))
        table.insert(fields, H.embedField("Rebirth", "`" .. tostring(save.Rebirth or 0) .. "`"))
        table.insert(fields, H.embedField("Pets", "`" .. tostring(H.countTable(save.Inventory)) .. "`"))
    end
    table.insert(fields, H.embedField("Since Last",
        string.format("Eggs: **%d**\nPets: **%d**\nRebirths: **%d**", SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths), false))
    return {
        author = { name = "Steal an Egg | ZenHubX" }, title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            LocalPlayer.Name, DisplayJobId, H.formatElapsed(os.clock() - SessionStartedAt)),
        color = 5793266, fields = fields,
        footer = { text = "ZenHubX | " .. DISCORD_LINK },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end
H.sendSummary = function()
    local sent = H.sendWebhookEmbed(H.buildSummaryEmbed(), true)
    if sent then SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0, 0, 0; H.clearTable(SpawnedEggLog); H.clearTable(ObtainedEggLog) end
    return sent
end
function H.runWebhookSummary()
    local iv = (tonumber(H.optionValue("WebhookInterval", 15)) or 15) * 60
    if os.clock() - LastWebhookSummaryAt < iv then return false end
    LastWebhookSummaryAt = os.clock(); return H.sendSummary()
end

-- Performance
function H.applyAntiGameplayPause(enabled)
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(not enabled) end)
    pcall(function()
        local n = CoreGui:FindFirstChild("RobloxNetworkPauseNotification")
        if n then n.Enabled = not enabled end
    end)
    if enabled then
        pcall(function()
            if sethiddenproperty then sethiddenproperty(LocalPlayer, "GameplayPaused", false)
            else LocalPlayer.GameplayPaused = false end
        end)
    end
end
function H.applyRendering(disableRendering) pcall(function() RunService:Set3dRenderingEnabled(not disableRendering) end) end
local FpsEffectClasses = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
function H.setEffectEnabled(inst, enabled) pcall(function() inst.Enabled = enabled end) end
function H.enableFpsBoost()
    if FpsBoostSnapshot then return end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local ql = nil; pcall(function() ql = settings().Rendering.QualityLevel end)
    FpsBoostSnapshot = {
        QualityLevel = ql, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
        Terrain = terrain, WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
        WaterReflectance = terrain and terrain.WaterReflectance or nil, Effects = {},
    }
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1000000
    if terrain then terrain.WaterWaveSize = 0; terrain.WaterReflectance = 0 end
    for _, d in ipairs(Workspace:GetDescendants()) do
        if FpsEffectClasses[d.ClassName] and d.Enabled then
            table.insert(FpsBoostSnapshot.Effects, d); H.setEffectEnabled(d, false)
        end
    end
    FpsDescendantAddedConnection = Workspace.DescendantAdded:Connect(function(d)
        if FpsEffectClasses[d.ClassName] and H.isOn("FpsBoost") then H.setEffectEnabled(d, false) end
    end)
end
function H.disableFpsBoost()
    if FpsDescendantAddedConnection then FpsDescendantAddedConnection:Disconnect(); FpsDescendantAddedConnection = nil end
    local snap = FpsBoostSnapshot; if not snap then return end
    FpsBoostSnapshot = nil
    if snap.QualityLevel then pcall(function() settings().Rendering.QualityLevel = snap.QualityLevel end) end
    Lighting.GlobalShadows = snap.GlobalShadows; Lighting.FogEnd = snap.FogEnd
    if snap.Terrain and snap.Terrain.Parent then
        snap.Terrain.WaterWaveSize = snap.WaterWaveSize; snap.Terrain.WaterReflectance = snap.WaterReflectance
    end
    for _, e in ipairs(snap.Effects) do H.setEffectEnabled(e, true) end
end
function H.applyFpsCap(value)
    local setCap = setfpscap or (syn and syn.set_fps_cap)
    if typeof(setCap) ~= "function" then return false end
    return pcall(setCap, math.clamp(tonumber(value) or 60, 15, 360))
end
function H.handleDisconnect(reason)
    if DisconnectHandled then return end
    DisconnectHandled = true
    if H.isOn("WebhookDisconnectAlerts") then
        H.sendWebhookEmbed({
            author = { name = "Steal an Egg | ZenHubX" }, title = "Disconnected",
            description = string.format("**Player** `%s`\n**Reason** %s", LocalPlayer.Name, tostring(reason or "Connection lost")),
            color = 15158332, footer = { text = "ZenHubX | " .. DISCORD_LINK },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }, true)
    end
    if H.isOn("AutoReconnect") then task.delay(2, H.rejoinServer) end
end

local AutomationJobs = {
    ["Auto Steal Egg"] = { Ready = H.canAutoSteal, Run = H.runAutoSteal, Interval = 0.25 },
    ["Auto Place Egg"] = { Ready = H.canAutoPlace, Run = H.runAutoPlaceEggs, Interval = 0.45 },
    ["Auto Hatch"] = { Ready = H.canAutoHatch, Run = H.runAutoOpenReadyEggs, Interval = 0.55 },
    ["Auto Treadmill"] = { Ready = H.canAutoTreadmill, Run = H.runAutoTreadmillTraining, Interval = 1.2 },
}
function H.priorityOrder()
    local used, order = {}, {}
    for _, o in ipairs(PrioritySlotOptionNames) do
        local job = H.optionValue(o, nil)
        if AutomationJobs[job] and not used[job] then used[job] = true; table.insert(order, job) end
    end
    for _, job in ipairs(PriorityTaskNames) do
        if not used[job] then used[job] = true; table.insert(order, job) end
    end
    return order
end

-- STATE BINDINGS
local UIState = {}
local UIValues = {}
function H.isOn(id) return UIState[id] == true end
function H.optionValue(id, fallback) local v = UIValues[id]; if v == nil then return fallback end return v end
function H.multiSelected(id)
    local v = UIValues[id]; local sel = {}
    if typeof(v) ~= "table" then
        if typeof(v) == "string" and v ~= "" then sel[v] = true end
        return sel
    end
    for k, item in pairs(v) do
        if item == true then sel[k] = true
        elseif typeof(k) == "number" and typeof(item) == "string" then sel[item] = true end
    end
    return sel
end
function H.multiHasAny(id) return next(H.multiSelected(id)) ~= nil end
function H.selectionAllows(id, value)
    if not H.multiHasAny(id) then return true end
    return H.multiSelected(id)[value] == true
end
function H.matchesMutationFilter(optionName, asset)
    if not H.multiHasAny(optionName) then return true end
    local sel = H.multiSelected(optionName)
    for _, m in ipairs(H.recordMutations(asset)) do if sel[m] then return true end end
    return false
end
function H.matchesEggFilters(egg, areaOpt, rarOpt, mutOpt)
    if areaOpt then
        local aid = egg.AreaId
        if typeof(aid) ~= "string" or not H.selectionAllows(areaOpt, aid) then return false end
    end
    local rar = H.resolveRarity(egg.AssetCategory)
    if typeof(rar) ~= "string" or not H.selectionAllows(rarOpt, rar) then return false end
    return H.matchesMutationFilter(mutOpt, egg)
end

-- VISUAL PETS
function H.findPetModel(name)
    local search = name:lower()
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") and d.Name:lower():find(search, 1, true) and d:FindFirstChildWhichIsA("BasePart")
            and not d:IsDescendantOf(VisualPetFolder) then
            return d
        end
    end
    return nil
end
function H.scanPetNames()
    local seen, names = {}, {}
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") and d:FindFirstChildWhichIsA("BasePart") then
            local n = d.Name:lower()
            if not (n:find("humanoid") or n:find("egg") or n:find("base") or n:find("plot")) then
                local parent = d.Parent and d.Parent.Name:lower() or ""
                if parent:find("pet") or parent:find("pen") or parent:find("render") or parent:find("slot") or d:FindFirstChildWhichIsA("AnimationController") then
                    if not seen[d.Name] then seen[d.Name] = true; table.insert(names, d.Name) end
                end
            end
        end
    end
    table.sort(names); return names
end
function H.spawnVisualPet(name)
    local src = H.findPetModel(name)
    if not src then return nil end
    local clone = src:Clone()
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then d:Destroy() end
    end
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BasePart") then
            d.Anchored = true; d.CanCollide = false; d.CanTouch = false; d.CastShadow = false
        end
    end
    clone.Name = "VP_" .. name; clone.Parent = VisualPetFolder
    table.insert(VisualPetsSpawned, { model = clone })
    return clone
end
function H.clearVisualPets()
    for _, v in ipairs(VisualPetsSpawned) do pcall(function() v.model:Destroy() end) end
    VisualPetsSpawned = {}
end
RunService.Heartbeat:Connect(function()
    if #VisualPetsSpawned == 0 then return end
    local hrp = H.getRoot(); if not hrp then return end
    local center = hrp.Position + Vector3.new(0, 1, 0)
    local t = tick(); local total = #VisualPetsSpawned
    for i, v in ipairs(VisualPetsSpawned) do
        local angle = (i - 1) * (math.pi * 2 / total) + t * 0.8
        local pos = center + Vector3.new(math.cos(angle) * 4, 0, math.sin(angle) * 4)
        pcall(function() v.model:PivotTo(CFrame.new(pos) * CFrame.Angles(0, angle + math.pi, 0)) end)
    end
end)

-- ANTI-CHEAT / ANTI-RAGDOLL
local PeteAntiRagdoll = true
local SpeedConfig = { Enabled = false, Value = 300 }
local OriginalWalkSpeed = 16
local InstantHoldEnabled = false
local IsTrapImmune = false
local FixLagEnabled = false

local function applyNoClipTo(inst) if inst and inst:IsA("BasePart") then inst.CanCollide = false end end

-- 🔧 ANTI-RAGDOLL với reset state khi chết
RunService.Stepped:Connect(function()
    if IsBypassing then return end
    local ch = LocalPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (ch and hrp and hum) then return end
    if hum.Health <= 0 then return end  -- 🔧 không can thiệp khi đã chết
    if PeteAntiRagdoll then
        hum.PlatformStand = false
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        for _, v in ipairs(ch:GetDescendants()) do
            if v:IsA("Motor6D") then v.Enabled = true end
        end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y > 30 then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
    end
end)

RunService.RenderStepped:Connect(function()
    if IsBypassing then return end
    local ch = LocalPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (ch and hrp and hum) then return end
    if hum.Health <= 0 then return end  -- 🔧
    if PeteAntiRagdoll then
        for _, obj in ipairs(ch:GetDescendants()) do
            if obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("RopeConstraint") or obj:IsA("BodyVelocity") or obj:IsA("BodyThrust") then
                obj:Destroy()
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if SpeedConfig.Enabled then
        local hum = H.getHumanoid()
        if hum and hum.Health > 0 and hum.WalkSpeed ~= SpeedConfig.Value then hum.WalkSpeed = SpeedConfig.Value end
    end
end)

function H.applyNewBypassAndSpeed()
    local ch = LocalPlayer.Character
    if not ch then return false end
    local oldHum = ch:FindFirstChildOfClass("Humanoid")
    if not oldHum then return false end
    IsBypassing = true
    local targetSpeed = oldHum.WalkSpeed
    if SpeedConfig.Enabled then targetSpeed = SpeedConfig.Value else OriginalWalkSpeed = oldHum.WalkSpeed end
    local cam = Workspace.CurrentCamera
    local camCF = cam.CFrame
    local clone = oldHum:Clone()
    clone.Parent = ch
    oldHum:Destroy()
    task.wait(0.15)
    local newHum = ch:FindFirstChildOfClass("Humanoid")
    if newHum then
        cam.CameraSubject = newHum; cam.CFrame = camCF
        newHum.WalkSpeed = targetSpeed
        pcall(function()
            newHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        end)
    end
    task.wait(0.15); IsBypassing = false
    return true
end

function H.applyInstantHoldToPrompt(prompt)
    if not InstantHoldEnabled then return end
    local ch = LocalPlayer.Character; local bp = LocalPlayer:FindFirstChild("Backpack")
    if ch and prompt:IsDescendantOf(ch) then return end
    if bp and prompt:IsDescendantOf(bp) then return end
    prompt.HoldDuration = 0
end
Workspace.DescendantAdded:Connect(function(d)
    if InstantHoldEnabled and d:IsA("ProximityPrompt") then task.wait(); H.applyInstantHoldToPrompt(d) end
end)
function H.setInstantHold(state)
    InstantHoldEnabled = state
    if state then
        for _, p in ipairs(Workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then H.applyInstantHoldToPrompt(p) end end
    end
end

function H.isFoliageOrTree(obj)
    local n = string.lower(obj.Name)
    return string.find(n, "tree") or string.find(n, "leaf") or string.find(n, "leaves") or string.find(n, "grass")
        or string.find(n, "bush") or string.find(n, "foliage") or string.find(n, "plant") or string.find(n, "wood")
end
function H.cleanLighting()
    Lighting.FogEnd = 1e6; Lighting.FogStart = 1e6; Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end
end
function H.applyClayAndClean(obj)
    if not FixLagEnabled then return end
    if H.isFoliageOrTree(obj) then obj:Destroy(); return end
    if obj:IsA("SurfaceAppearance") or obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy(); return end
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Highlight") then obj:Destroy(); return end
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        obj.Material = Enum.Material.SmoothPlastic; obj.CastShadow = false
        if obj:IsA("MeshPart") then obj.TextureID = "" end
    end
end
function H.enableFixLag()
    FixLagEnabled = true; H.cleanLighting()
    for _, obj in ipairs(Workspace:GetDescendants()) do H.applyClayAndClean(obj) end
end
Workspace.DescendantAdded:Connect(function(obj)
    if FixLagEnabled then task.wait(); H.applyClayAndClean(obj) end
end)

function H.isTrapObject(obj)
    local n = string.lower(obj.Name)
    return string.find(n, "trap") or string.find(n, "snare") or string.find(n, "bear_trap") or string.find(n, "playertrap")
end
function H.deleteAndDisableTrap(obj)
    if not IsTrapImmune then return end
    if H.isTrapObject(obj) then
        for _, p in ipairs(obj:GetDescendants()) do
            if p:IsA("BasePart") then p.CanTouch = false; p.CanCollide = false; p.Transparency = 1
            elseif p:IsA("TouchTransmitter") or p:IsA("Script") or p:IsA("LocalScript") then p:Destroy() end
        end
        task.defer(function() pcall(function() obj:Destroy() end) end)
    end
end
function H.applyTrapImmunity()
    local ch = LocalPlayer.Character
    if not ch then return end
    if not ch:FindFirstChild("TrapImmunityField") then
        local ff = Instance.new("ForceField"); ff.Name = "TrapImmunityField"; ff.Visible = false; ff.Parent = ch
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do H.deleteAndDisableTrap(obj) end
end
Workspace.DescendantAdded:Connect(function(d)
    if IsTrapImmune then task.wait(); H.deleteAndDisableTrap(d) end
end)

function H.teleportToVoid()
    local hrp = H.getRoot()
    if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -350, hrp.Position.Z) end
end

-- ============================================================
-- WINDUI MENU
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = L("menu_title"), Folder = "zenhubX", Icon = "solar:shield-bold", Theme = "Dark",
    NewElements = true, HideSearchBar = false,
    OpenButton = {
        Title = L("open_btn"), CornerRadius = UDim.new(1, 0), StrokeThickness = 2,
        Enabled = true, Draggable = true, OnlyMobile = false, Scale = 0.5,
        Color = ColorSequence.new(Color3.fromHex("#8A2BE2"), Color3.fromHex("#DA70D6")),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})
Window:Tag({ Title = L("tag"), Icon = "solar:star-bold", Color = PurpleColor, Border = true })

-- NÚT CHUYỂN NGÔN NGỮ
local LanguageGui = Instance.new("ScreenGui")
LanguageGui.Name = "ZenHubX_LangToggle"; LanguageGui.ResetOnSpawn = false
LanguageGui.IgnoreGuiInset = true; LanguageGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LanguageGui.DisplayOrder = 99999
pcall(function() LanguageGui.Parent = gethui and gethui() or CoreGui end)
if not LanguageGui.Parent then LanguageGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.fromOffset(96, 34); LangBtn.Position = UDim2.new(1, -110, 0, 12)
LangBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24); LangBtn.BorderSizePixel = 0
LangBtn.Text = "🇻🇳 Tiếng Việt"; LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.Font = Enum.Font.GothamBold; LangBtn.TextSize = 12
LangBtn.AutoButtonColor = false; LangBtn.Active = true; LangBtn.Draggable = true
LangBtn.Parent = LanguageGui
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 8)
local LBStroke = Instance.new("UIStroke", LangBtn)
LBStroke.Color = PurpleColor; LBStroke.Thickness = 1.5; LBStroke.Parent = LangBtn
LangBtn.MouseButton1Click:Connect(function()
    if Lang == "vi" then Lang = "en" else Lang = "vi" end
    LangBtn.Text = (Lang == "vi") and "🇻🇳 Tiếng Việt" or "🇬🇧 English"
    pcall(function()
        WindUI:Notify({ Title = "ZenHubX",
            Content = (Lang == "vi") and "Đã đổi sang Tiếng Việt! Chạy lại script để áp dụng." or "Changed to English! Re-run script to apply.",
            Duration = 5 })
    end)
end)

-- TAB NÔNG TRẠI
local FarmTab = Window:Tab({ Title = L("tab_farm"), Icon = "solar:zap-bold", IconColor = PurpleColor, Border = true })
FarmTab:Section({ Title = "Cướp Trứng" })
FarmTab:Toggle({ Title = "Tự Động Cướp Đã Chọn", Value = false, Callback = function(v) UIState["AutoStealSelected"] = v end })
FarmTab:Toggle({ Title = "Tự Động Cướp Tất Cả", Value = false, Callback = function(v) UIState["AutoStealAll"] = v end })
FarmTab:Toggle({ Title = "Cướp Trứng To", Value = false, Callback = function(v) UIState["StealBigEggs"] = v end })
FarmTab:Dropdown({ Title = "Khu Vực", Values = AreaNames, Multi = true, Value = {}, Callback = function(v) UIValues["StealZones"] = v end })
FarmTab:Dropdown({ Title = "Độ Hiếm", Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["StealRarities"] = v end })
FarmTab:Dropdown({ Title = "Biến Thể", Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["StealMutations"] = v end })
FarmTab:Dropdown({ Title = "Ưu Tiên Mục Tiêu", Values = STEAL_PRIORITIES, Value = "Rarest", Callback = function(v) UIValues["StealPriority"] = v end })
FarmTab:Slider({ Title = "Kích Thước Trứng To Tối Thiểu", Min = 1, Max = 50, Default = 1.5, Step = 0.1, Callback = function(v) UIValues["StealBigEggScale"] = v end })
FarmTab:Toggle({ Title = "Tự Động Về Base", Value = true, Callback = function(v) UIState["AutoReturn"] = v end })
FarmTab:Toggle({ Title = "Tự Động Bỏ Trứng", Value = false, Callback = function(v) UIState["AutoDropEgg"] = v end })
FarmTab:Button({ Title = "Cướp Ngay", Callback = function() task.spawn(H.runAutoSteal) end })

FarmTab:Section({ Title = "Anti-Cheat" })
FarmTab:Button({ Title = "Bypass Anti-Cheat + Tốc Độ", Callback = function()
    task.spawn(function()
        local ok = H.applyNewBypassAndSpeed()
        WindUI:Notify({ Title = "ZenHubX", Content = ok and "✓ Bypass OK" or "Error" })
    end)
end })
FarmTab:Toggle({ Title = "Bật/Tắt Tốc Độ Đi", Value = false, Callback = function(v)
    SpeedConfig.Enabled = v
    local hum = H.getHumanoid()
    if hum then hum.WalkSpeed = v and SpeedConfig.Value or OriginalWalkSpeed end
end })
FarmTab:Slider({ Title = "Tốc Độ Di Chuyển", Min = 100, Max = 900, Default = 300, Step = 10, Callback = function(v)
    SpeedConfig.Value = v
    if SpeedConfig.Enabled then local hum = H.getHumanoid(); if hum then hum.WalkSpeed = v end end
end })
FarmTab:Toggle({ Title = "Đổi Tốc Độ (Anti-Cheat)", Value = false, Callback = function(v) UIState["SpeedChanger"] = v end })
FarmTab:Toggle({ Title = "Thoát Kẹt Void", Value = false, Callback = function(v) VoidUnstuck = v end })
FarmTab:Button({ Title = "Đặt Base Tại Đây", Callback = function()
    local hrp = H.getRoot()
    if hrp then ManualBase = hrp.Position; WindUI:Notify({ Title = "Base", Content = "Đã pin base!" }) end
end })
FarmTab:Button({ Title = "Xóa Điểm Base", Callback = function() ManualBase = nil; WindUI:Notify({ Title = "Base", Content = "Đã xoá pin." }) end })

FarmTab:Section({ Title = "Xử Lý Trứng" })
FarmTab:Toggle({ Title = "Tự Động Đặt Đã Chọn", Value = false, Callback = function(v) UIState["AutoPlaceSelected"] = v end })
FarmTab:Toggle({ Title = "Tự Động Đặt Tất Cả", Value = false, Callback = function(v) UIState["AutoPlaceAll"] = v end })
FarmTab:Dropdown({ Title = "Độ Hiếm Vòng Đời", Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["LifecycleRarities"] = v end })
FarmTab:Dropdown({ Title = "Biến Thể Vòng Đời", Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["LifecycleMutations"] = v end })
FarmTab:Button({ Title = "Đặt Ngay", Callback = function() task.spawn(function() H.runAutoPlaceEggs(true) end) end })
FarmTab:Toggle({ Title = "Tự Động Nở Trứng", Value = false, Callback = function(v) UIState["AutoOpenReadyEggs"] = v end })
FarmTab:Button({ Title = "Nở Ngay", Callback = function() task.spawn(function() H.runAutoOpenReadyEggs() end) end })
FarmTab:Toggle({ Title = "Tự Động Bán Trứng", Value = false, Callback = function(v) UIState["AutoSellEggs"] = v end })
FarmTab:Dropdown({ Title = "Độ Hiếm Bán", Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["SellEggRarities"] = v end })
FarmTab:Slider({ Title = "Chu Kỳ Bán", Min = 1, Max = 120, Default = 8, Step = 1, Callback = function(v) UIValues["SellEggInterval"] = v end })

FarmTab:Section({ Title = "Ưu Tiên" })
for i, name in ipairs(PrioritySlotOptionNames) do
    FarmTab:Dropdown({ Title = "Ưu Tiên " .. i, Values = PriorityTaskNames, Value = PriorityTaskNames[i], Callback = function(v) UIValues[name] = v end })
end

FarmTab:Section({ Title = "Chuyển Server" })
FarmTab:Toggle({ Title = "Tự Động Chuyển Server", Value = false, Callback = function(v) UIState["AutoServerHop"] = v end })
FarmTab:Dropdown({ Title = "Chuyển Khi", Values = ServerHopModes, Value = "No Matching Eggs", Callback = function(v) UIValues["HopMode"] = v end })
FarmTab:Slider({ Title = "Chờ Trước Khi Chuyển", Min = 1, Max = 200, Default = 15, Step = 1, Callback = function(v) UIValues["HopValue"] = v end })
FarmTab:Button({ Title = "Chuyển Ngay", Callback = function() task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Manual") end) end })
FarmTab:Button({ Title = "Vào Lại Server", Callback = function() H.rejoinServer() end })

FarmTab:Section({ Title = "Cướp Trứng Tự Do" })
FarmTab:Toggle({ Title = "Bật Cướp Trứng Tự Do", Desc = "Phát hiện RUN!! + Drop → chạy về base", Value = false, Callback = function(v) UIState["AutoStealFree"] = v end })

-- TAB THÚ CƯNG
local PetsTab = Window:Tab({ Title = L("tab_pets"), Icon = "solar:cat-bold", IconColor = PurpleColor, Border = true })
PetsTab:Section({ Title = "Tổng Quan" })
PetsTab:Toggle({ Title = "Tự Động Trang Bị Tốt Nhất", Value = false, Callback = function(v) UIState["AutoEquipBest"] = v end })
PetsTab:Toggle({ Title = "Ẩn Thú Cưng Của Mình", Value = false, Callback = function(v) UIState["AutoDeleteOwnPets"] = v end })

PetsTab:Section({ Title = "Ghép Thú" })
PetsTab:Toggle({ Title = "Tự Động Ghép Thú", Value = false, Callback = function(v) UIState["AutoFusePets"] = v end })
PetsTab:Dropdown({ Title = "Độ Hiếm Ghép", Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["FuseRarities"] = v end })
PetsTab:Dropdown({ Title = "Biến Thể Ghép", Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["FuseMutations"] = v end })
PetsTab:Dropdown({ Title = "Chọn Nhóm Theo", Values = FUSE_TARGET_MODES, Value = "Highest Rarity", Callback = function(v) UIValues["FuseTarget"] = v end })
PetsTab:Toggle({ Title = "Không Ghép Biến Thể", Value = true, Callback = function(v) UIState["FuseKeepMutated"] = v end })
PetsTab:Toggle({ Title = "Không Ghép Đang Dùng", Value = true, Callback = function(v) UIState["FuseKeepEquipped"] = v end })
PetsTab:Toggle({ Title = "Tự Động Hoàn Thành Tiết Lộ", Value = true, Callback = function(v) UIState["FuseAutoReveal"] = v end })
PetsTab:Slider({ Title = "Kích Thước Tối Đa Ghép", Min = 0, Max = 10, Default = 10, Step = 0.1, Callback = function(v) UIValues["FuseMaxScale"] = v end })
PetsTab:Slider({ Title = "Giữ Lại Mỗi Loại", Min = 0, Max = 20, Default = 0, Step = 1, Callback = function(v) UIValues["FuseKeepPerCategory"] = v end })
PetsTab:Slider({ Title = "Chu Kỳ Ghép", Min = 1, Max = 120, Default = 8, Step = 1, Callback = function(v) UIValues["FuseInterval"] = v end })
PetsTab:Button({ Title = "Ghép Ngay", Callback = function() task.spawn(function() H.runAutoFusePets(true) end) end })

PetsTab:Section({ Title = "Bán Thú Cưng" })
PetsTab:Toggle({ Title = "Tự Động Bán Thú", Value = false, Callback = function(v) UIState["AutoSellPets"] = v end })
PetsTab:Dropdown({ Title = "Độ Hiếm Bán", Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["SellRarities"] = v end })
PetsTab:Dropdown({ Title = "Biến Thể Bán", Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["SellMutations"] = v end })
PetsTab:Toggle({ Title = "Không Bán Biến Thể", Value = true, Callback = function(v) UIState["SellKeepMutated"] = v end })
PetsTab:Toggle({ Title = "Không Bán Đang Dùng", Value = true, Callback = function(v) UIState["SellKeepEquipped"] = v end })
PetsTab:Slider({ Title = "Kích Thước Tối Đa Bán", Min = 0, Max = 10, Default = 10, Step = 0.1, Callback = function(v) UIValues["SellMaxScale"] = v end })
PetsTab:Slider({ Title = "Chu Kỳ Bán", Min = 1, Max = 120, Default = 6, Step = 1, Callback = function(v) UIValues["SellInterval"] = v end })

PetsTab:Section({ Title = "Thú Ảo (Client)" })
local visPetList = PetsTab:Dropdown({ Title = "Thú Cưng", Values = {"Scanning..."}, Value = 1, Callback = function(v)
    local name = type(v) == "table" and next(v) or v
    if type(name) == "string" then UIValues["VisualPetSelected"] = name end
end })
PetsTab:Button({ Title = "Làm Mới Danh Sách", Callback = function()
    local names = H.scanPetNames()
    if #names > 0 then
        pcall(function() visPetList:Refresh(names) end); pcall(function() visPetList:SetValues(names) end)
        WindUI:Notify({ Title = "Visual Pets", Content = #names .. " pets found." })
    else WindUI:Notify({ Title = "Visual Pets", Content = "Không tìm thấy pet nào." }) end
end })
PetsTab:Input({ Title = "Tên Tùy Chỉnh", Placeholder = "e.g. Dragon", Callback = function(v) UIValues["VisualPetCustom"] = v end })
PetsTab:Slider({ Title = "Bán Kính Quỹ Đạo", Min = 2, Max = 20, Default = 4, Step = 1, Callback = function(v) UIValues["VisualPetRadius"] = v end })
PetsTab:Slider({ Title = "Tốc Độ Quay", Min = 0, Max = 10, Default = 1, Step = 1, Callback = function(v) UIValues["VisualPetSpeed"] = v end })
PetsTab:Button({ Title = "Triệu Hồi Thú", Callback = function()
    local name = UIValues["VisualPetCustom"] or UIValues["VisualPetSelected"]
    if not name or name == "" then WindUI:Notify({ Title = "Visual Pets", Content = "Chọn pet trước." }); return end
    H.spawnVisualPet(name); WindUI:Notify({ Title = "Visual Pets", Content = "Đã spawn " .. name })
end })
PetsTab:Button({ Title = "Xóa Con Cuối", Callback = function()
    local v = table.remove(VisualPetsSpawned); if v then pcall(function() v.model:Destroy() end) end
end })
PetsTab:Button({ Title = "Xóa Tất Cả", Callback = function() H.clearVisualPets(); WindUI:Notify({ Title = "Visual Pets", Content = "Đã xoá hết." }) end })
task.delay(3, function()
    local names = H.scanPetNames()
    if #names > 0 then pcall(function() visPetList:Refresh(names) end); pcall(function() visPetList:SetValues(names) end) end
end)

-- TAB TIẾN TRÌNH
local ProgTab = Window:Tab({ Title = L("tab_progress"), Icon = "solar:graph-up-bold", IconColor = PurpleColor, Border = true })
ProgTab:Section({ Title = "Nâng Cấp" })
ProgTab:Toggle({ Title = "Tự Động Mua Nâng Cấp", Value = false, Callback = function(v) UIState["AutoUpgrades"] = v end })
ProgTab:Dropdown({ Title = "Loại Nâng Cấp", Values = UPGRADE_TYPES, Multi = true, Value = {"Base","Treadmill"}, Callback = function(v) UIValues["UpgradeTypes"] = v end })

ProgTab:Section({ Title = "Phần Thưởng" })
ProgTab:Toggle({ Title = "Tự Động Nhận Index", Value = false, Callback = function(v) UIState["AutoClaimIndex"] = v end })
ProgTab:Toggle({ Title = "Nhận Phần Thưởng Nhóm", Value = false, Callback = function(v) UIState["AutoClaimGroupReward"] = v end })
ProgTab:Toggle({ Title = "Nhận Thu Nhập Offline", Value = false, Callback = function(v) UIState["AutoClaimOffline"] = v end })

ProgTab:Section({ Title = "Trang Bị" })
ProgTab:Toggle({ Title = "Tự Động Mua Vệt", Value = false, Callback = function(v) UIState["AutoBuyTrail"] = v end })
ProgTab:Dropdown({ Title = "Vệt", Values = TrailNames, Multi = true, Value = {}, Callback = function(v) UIValues["TrailWanted"] = v end })
ProgTab:Toggle({ Title = "Trang Bị Vệt Tốt Nhất", Value = false, Callback = function(v) UIState["AutoEquipBestTrail"] = v end })
ProgTab:Toggle({ Title = "Trang Bị Đồ Tốt Nhất", Value = false, Callback = function(v) UIState["AutoEquipBestGear"] = v end })

ProgTab:Section({ Title = "Luyện Tập" })
ProgTab:Toggle({ Title = "Tự Động Luyện Treadmill", Value = false, Callback = function(v) UIState["AutoTreadmill"] = v end })

-- TAB NHÂN VẬT
local PlrTab = Window:Tab({ Title = L("tab_player"), Icon = "solar:user-bold", IconColor = PurpleColor, Border = true })
PlrTab:Section({ Title = "ESP" })
PlrTab:Toggle({ Title = "ESP Trứng Ngoài Map", Value = false, Callback = function(v) UIState["EspWorldEggs"] = v end })
PlrTab:Toggle({ Title = "ESP Trứng Đang Cầm/Rớt", Value = false, Callback = function(v) UIState["EspCarriedEggs"] = v end })
PlrTab:Toggle({ Title = "ESP Bảo Vệ", Value = false, Callback = function(v) UIState["EspGuards"] = v end })
PlrTab:Toggle({ Title = "ESP Thú Cưng", Value = false, Callback = function(v) UIState["EspPets"] = v end })
PlrTab:Toggle({ Title = "ESP Người Chơi", Value = false, Callback = function(v) UIState["EspPlayers"] = v end })
PlrTab:Toggle({ Title = "ESP Máy Móc", Value = false, Callback = function(v) UIState["EspMachines"] = v end })
PlrTab:Toggle({ Title = "ESP Khu Đất", Value = false, Callback = function(v) UIState["EspPlots"] = v end })
PlrTab:Slider({ Title = "Khoảng Cách Hiển Thị", Min = 100, Max = 6000, Default = 2000, Step = 50, Callback = function(v) UIValues["EspDistance"] = v end })

PlrTab:Section({ Title = "Di Chuyển" })
PlrTab:Toggle({ Title = "Ghi Đè Tốc Độ Đi", Value = false, Callback = function(v) UIState["WalkSpeedEnabled"] = v end })
PlrTab:Slider({ Title = "Tốc Độ Đi", Min = 16, Max = 500, Default = 32, Step = 1, Callback = function(v) UIValues["WalkSpeed"] = v end })
PlrTab:Toggle({ Title = "Ghi Đè Lực Nhảy", Value = false, Callback = function(v) UIState["JumpPowerEnabled"] = v end })
PlrTab:Slider({ Title = "Lực Nhảy", Min = 10, Max = 500, Default = 50, Step = 1, Callback = function(v) UIValues["JumpPower"] = v end })
PlrTab:Toggle({ Title = "Nhảy Vô Hạn", Value = false, Callback = function(v) UIState["InfJump"] = v end })
PlrTab:Toggle({ Title = "Xuyên Vật Thể", Value = false, Callback = function(v) UIState["NoClip"] = v end })
PlrTab:Toggle({ Title = "Bay", Value = false, Callback = function(v)
    UIState["Fly"] = v
    if not v then local hum = H.getHumanoid(); if hum then hum.PlatformStand = false end end
end })
PlrTab:Slider({ Title = "Tốc Độ Bay", Min = 10, Max = 400, Default = 60, Step = 1, Callback = function(v) UIValues["FlySpeed"] = v end })

PlrTab:Section({ Title = "Dịch Chuyển" })
PlrTab:Dropdown({ Title = "Điểm Đến", Values = WaypointNames, Value = "Base", Callback = function(v) UIValues["WaypointTarget"] = v end })
PlrTab:Button({ Title = "Dịch Chuyển Đến Điểm", Callback = function()
    task.spawn(function()
        local pos = H.resolveWaypoint(H.optionValue("WaypointTarget", "Base"))
        if not pos then WindUI:Notify({ Title = "Waypoint", Content = "Không có." }); return end
        if not H.bypassMoveTo(pos, nil, BYPASS_SPEED) then WindUI:Notify({ Title = "Waypoint", Content = "Thất bại." }) end
    end)
end })
PlrTab:Button({ Title = "Thả Xuống Void", Callback = function() H.teleportToVoid(); WindUI:Notify({ Title = "Void", Content = "Đã thả xuống void." }) end })

-- TAB BẢO VỆ
local AntiTab = Window:Tab({ Title = L("tab_anti"), Icon = "solar:shield-check-bold", IconColor = PurpleColor, Border = true })
AntiTab:Section({ Title = "Chống Văng / Knock" })
AntiTab:Toggle({ Title = "Chống Văng", Value = true, Callback = function(v) PeteAntiRagdoll = v end })
AntiTab:Toggle({ Title = "Chống Bẫy", Value = false, Callback = function(v)
    IsTrapImmune = v
    if v then H.applyTrapImmunity(); WindUI:Notify({ Title = "Anti Trap", Content = "Đã bật!" }) end
end })
AntiTab:Toggle({ Title = "Bỏ Qua Ấn Giữ", Value = false, Callback = function(v) H.setInstantHold(v) end })
AntiTab:Button({ Title = "Bật Fix Lag Đất Sét", Callback = function()
    H.enableFixLag(); WindUI:Notify({ Title = "Fix Lag", Content = "Đã tối ưu!" })
end })

-- TAB HỆ THỐNG
local SysTab = Window:Tab({ Title = L("tab_system"), Icon = "solar:settings-bold", IconColor = PurpleColor, Border = true })
SysTab:Section({ Title = "Phiên Chơi" })
SysTab:Toggle({ Title = "Chống AFK", Value = true, Callback = function(v) UIState["AntiAfk"] = v end })
SysTab:Toggle({ Title = "Không Bị Tạm Dừng", Value = true, Callback = function(v)
    UIState["AntiGameplayPause"] = v; H.applyAntiGameplayPause(v)
end })
SysTab:Toggle({ Title = "Tự Động Kết Nối Lại", Value = false, Callback = function(v) UIState["AutoReconnect"] = v end })

SysTab:Section({ Title = "Hiệu Suất" })
SysTab:Toggle({ Title = "Tăng FPS", Value = false, Callback = function(v)
    UIState["FpsBoost"] = v
    if v then H.enableFpsBoost() else H.disableFpsBoost() end
end })
SysTab:Toggle({ Title = "Tắt Render 3D", Value = false, Callback = function(v) H.applyRendering(v) end })
SysTab:Slider({ Title = "Giới Hạn FPS", Min = 15, Max = 360, Default = 60, Step = 1, Callback = function(v) H.applyFpsCap(v) end })

SysTab:Section({ Title = "Webhook" })
SysTab:Toggle({ Title = "Bật Webhook", Value = false, Callback = function(v) UIState["WebhookEnabled"] = v end })
SysTab:Input({ Title = "URL Webhook", Placeholder = "https://discord.com/api/webhooks/...", Callback = function(v) UIValues["WebhookUrl"] = v end })
SysTab:Input({ Title = "Ping User ID", Placeholder = "123456789012345678", Callback = function(v) UIValues["WebhookPingId"] = v end })
SysTab:Slider({ Title = "Chu Kỳ Tóm Tắt (phút)", Min = 1, Max = 180, Default = 15, Step = 1, Callback = function(v) UIValues["WebhookInterval"] = v end })
SysTab:Toggle({ Title = "Cảnh Báo Mất Kết Nối", Value = false, Callback = function(v) UIState["WebhookDisconnectAlerts"] = v end })
SysTab:Button({ Title = "Gửi Tóm Tắt Ngay", Callback = function() task.spawn(function() H.sendSummary() end) end })

SysTab:Section({ Title = "Giới Thiệu" })
SysTab:Button({ Title = "Sao Chép Link Discord", Callback = function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    WindUI:Notify({ Title = "ZenHubX", Content = "Đã copy Discord link!" })
end })
SysTab:Button({ Title = "Tắt Script", Callback = function()
    running = false
    pcall(H.stopTreadmillTraining)
    pcall(function() H.applyAntiGameplayPause(false) end)
    pcall(function() H.applyRendering(false) end)
    pcall(H.disableFpsBoost)
    pcall(H.clearAllEsp); pcall(H.clearVisualPets)
    if EspFolder then pcall(function() EspFolder:Destroy() end) end
    if VisualPetFolder then pcall(function() VisualPetFolder:Destroy() end) end
    for _, c in ipairs(conns) do pcall(function() if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end) end
    pcall(function() Window:Destroy() end)
    pcall(function() LanguageGui:Destroy() end)
end })

-- CONNECTIONS
pcall(function()
    if not getconnections then return end
    for _, c in ipairs(getconnections(LocalPlayer.Idled)) do pcall(function() c:Disable() end) end
end)

local NoClipAddedConn = nil
local function setNoClip(enabled)
    if NoClipAddedConn then pcall(function() NoClipAddedConn:Disconnect() end); NoClipAddedConn = nil end
    local ch = LocalPlayer.Character
    if not enabled or not ch then return end
    for _, inst in ipairs(ch:GetDescendants()) do applyNoClipTo(inst) end
    NoClipAddedConn = ch.DescendantAdded:Connect(applyNoClipTo)
    H.track(NoClipAddedConn)
end

H.track(UserInputService.JumpRequest:Connect(function()
    if not running or not H.isOn("InfJump") then return end
    local hum = H.getHumanoid()
    if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

H.track(RunService.RenderStepped:Connect(function(dt)
    if not running or not H.isOn("Fly") then return end
    local root = H.getRoot(); local hum = H.getHumanoid()
    local cam = Workspace.CurrentCamera
    if not root or not hum or not cam then return end
    if hum.Health <= 0 then return end
    hum.PlatformStand = true
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
    root.AssemblyLinearVelocity = Vector3.zero
    if dir.Magnitude > 0 then
        root.CFrame = root.CFrame + dir.Unit * (tonumber(H.optionValue("FlySpeed", 60)) or 60) * dt
    end
end))

H.track(UserInputService.InputBegan:Connect(function() LastInputAt = tick() end))
H.track(UserInputService.InputChanged:Connect(function(input)
    local it = input.UserInputType
    if it == Enum.UserInputType.MouseMovement or it == Enum.UserInputType.Gamepad1 then LastInputAt = tick() end
end))

-- ============================================================
-- 🔥 FIX CHẾT LIÊN TỤC KHI RESET - CharacterAdded handler
-- ============================================================
H.track(LocalPlayer.CharacterAdded:Connect(function(newChar)
    -- 🔧 RESET TOÀN BỘ STATE
    IsCarryingEgg = false
    ForceReturnNow = false
    IsBypassing = false
    HumReady = false
    TreadmillTrainingActive = false
    ManualBase = ManualBase  -- giữ pin base
    -- Reset travel token để huỷ mọi lệnh di chuyển cũ
    -- (không có biến travelToken ở phiên bản này nhưng vẫn reset cho an toàn)
    DisconnectHandled = false

    -- 🔧 Dọn sạch BodyVelocity/BodyGyro còn sót lại trên character cũ
    task.wait(0.1)
    pcall(function()
        if newChar then
            for _, d in ipairs(newChar:GetDescendants()) do
                if d:IsA("BodyVelocity") or d:IsA("BodyGyro") or d:IsA("BodyPosition") or d:IsA("BodyAngularVelocity")
                    or d:IsA("LinearVelocity") or d:IsA("VectorForce") or d:IsA("AlignOrientation") or d:IsA("AlignPosition") then
                    pcall(function() d:Destroy() end)
                end
            end
            local newHum = newChar:FindFirstChildOfClass("Humanoid")
            if newHum then
                newHum.PlatformStand = false
                newHum.Sit = false
            end
        end
    end)

    -- 🔧 Chờ một chút rồi mới setup
    task.wait(0.3)
    pcall(function()
        if H.stealingEnabled() and newChar and newChar.Parent then
            H.swapStealHumanoid()
        end
        if H.isOn("NoClip") then setNoClip(true) end
    end)
end))

H.track(UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.End then running = false end
end))

-- SCHEDULER
local SchedulerAt = {}
local LastNoClipOn = false
local function schedDue(name, interval)
    local now = os.clock()
    if now < (SchedulerAt[name] or 0) then return false end
    SchedulerAt[name] = now + interval
    return true
end

local function runCarryJobs()
    if AutomationBusy then return end
    if H.isOn("AutoDropEgg") and IsCarryingEgg then
        AutomationBusy = true; pcall(H.runAutoDropEgg); AutomationBusy = false; return
    end
    if H.isOn("AutoReturn") and IsCarryingEgg then
        AutomationBusy = true; pcall(H.runAutoReturn); AutomationBusy = false
    end
end

local function runPriorityJobs()
    if AutomationBusy then return end
    local order = H.priorityOrder()
    if #order < 1 then return end
    for _, jobName in ipairs(order) do
        local job = AutomationJobs[jobName]
        local ready = job and job.Ready()
        if ready then
            local lastRun = AutomationLastRunAt[jobName] or 0
            ready = os.clock() - lastRun >= job.Interval
        end
        if ready then
            AutomationLastRunAt[jobName] = os.clock()
            if jobName ~= "Auto Treadmill" and (TreadmillTrainingActive or H.isDoubleSpeedVisible()) then
                pcall(H.stopTreadmillTraining)
            end
            AutomationBusy = true
            local ok, didWork = pcall(job.Run)
            AutomationBusy = false
            if ok and didWork then return end
        end
    end
end

H.track(RunService.Heartbeat:Connect(function()
    if not running then return end
    -- 🔧 Nếu nhân vật đã chết thì bỏ qua
    local hum = H.getHumanoid()
    if not hum or hum.Health <= 0 then return end

    if schedDue("core", 0.35) then
        task.spawn(function()
            if H.stealingEnabled() then H.swapStealHumanoid() end
            runCarryJobs()
            runPriorityJobs()
        end)
    end

    if schedDue("dashboard", 2) then
        local nc = H.isOn("NoClip")
        if nc ~= LastNoClipOn then LastNoClipOn = nc; setNoClip(nc) end
        if H.isOn("WalkSpeedEnabled") then
            local h = H.getHumanoid()
            if h then h.WalkSpeed = tonumber(H.optionValue("WalkSpeed", 32)) or 32 end
        end
        if H.isOn("JumpPowerEnabled") then
            local h = H.getHumanoid()
            if h then h.UseJumpPower = true; h.JumpPower = tonumber(H.optionValue("JumpPower", 50)) or 50 end
        end
        if TreadmillTrainingActive or H.isDoubleSpeedVisible() then
            if not H.isOn("AutoTreadmill") then pcall(H.stopTreadmillTraining) end
        end
        if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
    end

    if schedDue("esp", 1.25) then
        local anyEsp = H.isOn("EspWorldEggs") or H.isOn("EspCarriedEggs") or H.isOn("EspGuards")
            or H.isOn("EspPets") or H.isOn("EspPlayers") or H.isOn("EspMachines") or H.isOn("EspPlots")
        if anyEsp then pcall(H.runEsp)
        elseif next(EspEntries) ~= nil then pcall(H.clearAllEsp) end
    end

    if schedDue("pets", 5) then
        if H.isOn("AutoEquipBest") and not AutomationBusy then pcall(H.runAutoEquipBest) end
        if H.isOn("AutoEquipBestTrail") then pcall(H.runAutoEquipBestTrail) end
        if H.isOn("AutoEquipBestGear") then pcall(H.runAutoEquipBestGear) end
        if H.isOn("AutoDeleteOwnPets") then pcall(H.deleteOwnPetRenders) end
    end

    if schedDue("fuse", tonumber(H.optionValue("FuseInterval", 8)) or 8) then
        if H.isOn("AutoFusePets") and not AutomationBusy and not IsCarryingEgg then
            AutomationBusy = true; pcall(H.runAutoFusePets); AutomationBusy = false
        end
    end

    if schedDue("sellPets", tonumber(H.optionValue("SellInterval", 6)) or 6) then
        if H.isOn("AutoSellPets") and not AutomationBusy and not IsCarryingEgg then pcall(H.runAutoSellPets) end
    end

    if schedDue("sellEggs", tonumber(H.optionValue("SellEggInterval", 8)) or 8) then
        if H.isOn("AutoSellEggs") and not AutomationBusy and not IsCarryingEgg then
            AutomationBusy = true; pcall(H.runAutoSellEggs); AutomationBusy = false
        end
    end

    if schedDue("upgrades", 4) then
        if H.isOn("AutoUpgrades") and not IsCarryingEgg then pcall(H.runAutoUpgrades) end
        if H.isOn("AutoBuyTrail") and not IsCarryingEgg then pcall(H.runAutoBuyTrail) end
    end

    if schedDue("claims", 12) then
        if H.isOn("AutoClaimIndex") then pcall(H.runAutoClaimIndex) end
        if H.isOn("AutoClaimOffline") then pcall(H.runClaimOfflineEarnings) end
        if H.isOn("AutoClaimGroupReward") then pcall(H.runAutoClaimGroupReward) end
    end

    if schedDue("hop", 3) then
        if H.isOn("AutoServerHop") and not AutomationBusy then pcall(H.runServerHop) end
    end

    if schedDue("webhook", 5) then
        if H.isOn("WebhookEnabled") then
            pcall(H.trackWebhookEvents); pcall(H.runWebhookSummary)
        end
    end

    if schedDue("session", 4) then
        if H.isOn("AntiAfk") then
            local idleFor = tick() - LastInputAt
            local sinceTap = tick() - LastAntiAfkAt
            if (idleFor >= 300 and sinceTap >= 60) or (idleFor < 300 and sinceTap >= 300) then
                pcall(function()
                    local cam = Workspace.CurrentCamera
                    if cam then
                        VirtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
                        VirtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
                        LastAntiAfkAt = tick()
                    end
                end)
            end
        end
        if H.isOn("AutoReconnect") or H.isOn("WebhookDisconnectAlerts") then
            local pg = CoreGui:FindFirstChild("RobloxPromptGui")
            local ov = pg and pg:FindFirstChild("promptOverlay")
            if ov then
                local err = ov:FindFirstChild("ErrorPrompt") or ov:FindFirstChildWhichIsA("Frame")
                if err and err.Visible and tostring(err.Name):find("ErrorPrompt") then
                    H.handleDisconnect("Roblox error prompt")
                end
            end
        end
    end

    if UIState["SpeedChanger"] and SpeedConfig.Enabled then
        local h = H.getHumanoid()
        if h and h.Health > 0 and h.WalkSpeed ~= SpeedConfig.Value then h.WalkSpeed = SpeedConfig.Value end
    end
end))

-- Auto Steal Free
task.spawn(function()
    while running do
        task.wait(0.5)
        if UIState["AutoStealFree"] and H.getHumanoid() and H.getRoot() then
            local hum = H.getHumanoid()
            if hum and hum.Health > 0 then
                local base = ManualBase or H.getBasePosition()
                if base then
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    local hasRun, hasDrop = false, false
                    if pg then
                        for _, d in ipairs(pg:GetDescendants()) do
                            if d:IsA("TextButton") or d:IsA("TextLabel") then
                                if d.Text:upper() == "RUN!!" and d.Visible then hasRun = true end
                                if d.Text:lower() == "drop" and d.Visible then hasDrop = true end
                            end
                        end
                    end
                    if hasRun and hasDrop then
                        local baseY = H.groundedY(base.X, base.Z, base.Y)
                        H.nonLagStepTeleport(CFrame.new(base.X, baseY + 3, base.Z), true)
                    end
                end
            end
        end
    end
end)

if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
H.applyFpsCap(60)

WindUI:Notify({ Title = "ZenHubX v15", Content = L("notify_loaded") })