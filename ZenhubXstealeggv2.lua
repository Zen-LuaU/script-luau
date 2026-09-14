--[[
    ZenHubX - Steal an Egg
    Standalone UI (no external library)
    Discord: https://discord.gg/vggkAdBcuJ
    TikTok: zenhub.z
    Anti-Kick Edition + Extras + Bilingual
--]]

-- ============================================================
-- COMPAT SHIMS
-- ============================================================
local _G_ENV = (getgenv and getgenv()) or _G
if type(table.pack) ~= "function" then
    function table.pack(...) return { n = select("#", ...), ... } end
end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(v, mn, mx)
        if v < mn then return mn elseif v > mx then return mx end
        return v
    end
end
if type(table.find) ~= "function" then
    function table.find(t, v, init)
        if type(t) ~= "table" then return nil end
        for i = tonumber(init) or 1, #t do if t[i] == v then return i end end
        return nil
    end
end

local genv = _G_ENV
if type(genv.__ZENHUBX_SHUTDOWN) == "function" then
    pcall(genv.__ZENHUBX_SHUTDOWN); task.wait(0.1)
end
if genv.__ZENHUBX_RUNNING then return end
genv.__ZENHUBX_RUNNING = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")
local TeleportService    = game:GetService("TeleportService")
local UserInputService   = game:GetService("UserInputService")
local Lighting           = game:GetService("Lighting")
local Workspace          = game:GetService("Workspace")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local GuiService         = game:GetService("GuiService")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
pcall(function() LocalPlayer:WaitForChild("PlayerGui", 10) end)

local DISCORD_LINK = "https://discord.gg/vggkAdBcuJ"
local TIKTOK_ID    = "zenhub.z"
local HEADER_TEXT  = "ZenHubX"
local SUBTITLE     = "Discord: " .. DISCORD_LINK .. " | TikTok: " .. TIKTOK_ID

-- ============================================================
-- ZENHUBX KEY SYSTEM
-- ============================================================
local ZENHUBX_KEY = "zenhubXsteal"

local function ZenHubXKeyGate()
    local parent
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        parent = ok and result or game:GetService("CoreGui")
    else
        parent = game:GetService("CoreGui")
    end
    local old = parent:FindFirstChild("ZenHubXKeySystem")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZenHubXKeySystem"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 100000
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(360, 230)
    frame.Position = UDim2.new(0.5, -180, 0.5, -115)
    frame.BackgroundColor3 = Color3.fromRGB(14, 10, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(170, 70, 255); stroke.Thickness = 2; stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(18, 15)
    title.Size = UDim2.new(1, -36, 0, 28)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(220, 150, 255)
    title.Text = "zen hubX • KEY SYSTEM"
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.fromOffset(18, 48)
    desc.Size = UDim2.new(1, -36, 0, 45)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11
    desc.TextWrapped = true
    desc.TextColor3 = Color3.fromRGB(195, 180, 210)
    desc.Text = "Tham gia nhóm Discord để nhận key.\nSau đó nhập key vào ô bên dưới để xác minh."
    desc.Parent = frame

    local discord = Instance.new("TextButton")
    discord.Size = UDim2.new(1, -36, 0, 32)
    discord.Position = UDim2.fromOffset(18, 96)
    discord.BackgroundColor3 = Color3.fromRGB(85, 35, 125)
    discord.BorderSizePixel = 0
    discord.Font = Enum.Font.GothamBold
    discord.TextSize = 12
    discord.TextColor3 = Color3.new(1, 1, 1)
    discord.Text = "Tham gia Discord • Sao chép link"
    discord.Parent = frame
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 7); dc.Parent = discord
    discord.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        discord.Text = "Đã sao chép link Discord"
        task.delay(1.5, function()
            if discord.Parent then discord.Text = "Tham gia Discord • Sao chép link" end
        end)
    end)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -36, 0, 32)
    box.Position = UDim2.fromOffset(18, 137)
    box.BackgroundColor3 = Color3.fromRGB(28, 20, 38)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderColor3 = Color3.fromRGB(130, 110, 145)
    box.PlaceholderText = "Nhập key..."
    box.ClearTextOnFocus = false
    box.Parent = frame
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 7); bc.Parent = box
    local bp = Instance.new("UIPadding"); bp.PaddingLeft = UDim.new(0, 10); bp.Parent = box

    local verify = Instance.new("TextButton")
    verify.Size = UDim2.new(1, -36, 0, 32)
    verify.Position = UDim2.fromOffset(18, 178)
    verify.BackgroundColor3 = Color3.fromRGB(145, 55, 220)
    verify.BorderSizePixel = 0
    verify.Font = Enum.Font.GothamBold
    verify.TextSize = 12
    verify.TextColor3 = Color3.new(1, 1, 1)
    verify.Text = "Xác minh key"
    verify.Parent = frame
    local vc = Instance.new("UICorner"); vc.CornerRadius = UDim.new(0, 7); vc.Parent = verify

    local verified = false
    verify.MouseButton1Click:Connect(function()
        if box.Text == ZENHUBX_KEY then
            verified = true
            verify.Text = "✓ Key hợp lệ"
            verify.BackgroundColor3 = Color3.fromRGB(65, 160, 105)
        else
            verify.Text = "✗ Key không đúng"
            verify.BackgroundColor3 = Color3.fromRGB(180, 55, 80)
            task.delay(1.2, function()
                if verify.Parent then
                    verify.Text = "Xác minh key"
                    verify.BackgroundColor3 = Color3.fromRGB(145, 55, 220)
                end
            end)
        end
    end)

    while gui.Parent and not verified do task.wait() end
    if gui.Parent then gui:Destroy() end
    return verified
end

if not ZenHubXKeyGate() then return end

-- ============================================================
-- GAME MODULES
-- ============================================================
local H = {}

function H.cloneList(src)
    local out = {}
    if type(src) ~= "table" then return out end
    for i = 1, #src do out[i] = src[i] end
    return out
end
function H.clearTable(tbl)
    if type(tbl) ~= "table" then return end
    for k in pairs(tbl) do tbl[k] = nil end
end

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
    local names = { ... }
    for _, name in ipairs(names) do
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
    local parts = { ... }
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
    local names = { ... }
    local cur = tbl
    for _, name in ipairs(names) do
        if typeof(cur) ~= "table" then return nil end
        cur = cur[name]
    end
    return cur
end
function H.pickFn(mod, ...)
    if typeof(mod) ~= "table" then return nil end
    for i = 1, select("#", ...) do
        local key = select(i, ...)
        local fn = mod[key]
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
    Backpack = { EQUIP_BEST = H.remoteFrom(RemotesModule, "Haul", "WearBest") or H.findRemoteContains("WearBest") or H.findRemoteContains("EQUIP_BEST") },
    Plots = { REQUEST_BASE_UPGRADE = H.remoteFrom(RemotesModule, "Homestead", "AskBaseTierRaise") or H.findRemoteContains("AskBaseTierRaise") or H.findRemoteContains("BaseUpgrade") },
    Treadmills = {
        REQUEST_UPGRADE = H.remoteFrom(RemotesModule, "Treadmill", "AskTierRaise") or H.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC = H.remoteFrom(RemotesModule, "Treadmill", "AskWearStill") or H.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP = H.remoteFrom(RemotesModule, "Treadmill", "AskDoff") or H.findRemoteContains("AskDoff"),
    },
    Index = { REQUEST_CLAIM_ALL = H.remoteFrom(RemotesModule, "Codex", "AskRedeemAll") or H.findRemoteContains("AskRedeemAll") },
    AssetInventory = { SELL_ASSET = H.remoteFrom(RemotesModule, "PetSatchel", "SellPet") or H.findRemoteContains("SellPet") or H.findRemoteContains("SELL_ASSET") },
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

-- ============================================================
-- CONSTANTS
-- ============================================================
local RARITIES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }
local RarityWeight = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}
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
    local trailEntries = {}
    for trailId, trailData in pairs(TrailsModule.Directory) do
        table.insert(trailEntries, { id = trailId, name = trailData.DisplayName, price = tonumber(trailData.Price) or 0 })
    end
    table.sort(trailEntries, function(a, b) return a.price < b.price end)
    for _, entry in ipairs(trailEntries) do
        table.insert(TrailNames, entry.name)
        TrailIdByName[entry.name] = entry.id
        TrailPriceByName[entry.name] = entry.price
    end
end

local GearCostByName = {}
if GearsModule then
    local gearDirectory = GearsModule.Directory or GearsModule
    if typeof(gearDirectory) == "table" then
        for _, gearData in pairs(gearDirectory) do
            if typeof(gearData) == "table" and typeof(gearData.DisplayName) == "string" then
                GearCostByName[gearData.DisplayName] = tonumber(gearData.MoneyCost) or 0
            end
        end
    end
end

-- ============================================================
-- STATE
-- ============================================================
local MAX_SAFE_SPEED = 700
local DEFAULT_STEAL_SPEED = 700
local BYPASS_SPEED = 700
local BASE_RETURN_ARRIVE = 4
local STEAL_HOLD_TIME = 3
local StealConfig = { GrabDelay = 0.55, ReturnPace = 0.12, ArriveDistance = 1.35, MoveTimeout = 14 }

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
EspFolder.Name = "ZenHubXEggEsp"
EspFolder.Parent = Workspace

function H.track(c) table.insert(conns, c); return c end

-- ============================================================
-- ANTI-KICK HELPERS
-- ============================================================
local function jitterVector(magnitude)
    local m = magnitude or 0.15
    return Vector3.new((math.random() - 0.5) * m, 0, (math.random() - 0.5) * m)
end

local LastCFrameAt = 0
local MIN_CFRAME_INTERVAL = 1 / 45
local function safePivot(root, cf)
    if not root or not cf then return end
    local now = os.clock()
    if now - LastCFrameAt < MIN_CFRAME_INTERVAL then return end
    LastCFrameAt = now
    pcall(function() root.CFrame = cf end)
end

-- ============================================================
-- GAME HELPERS
-- ============================================================
function H.getHumanoid()
    local ch = LocalPlayer.Character
    return ch and ch:FindFirstChildOfClass("Humanoid") or nil
end
function H.getRoot()
    local ch = LocalPlayer.Character
    return ch and ch:FindFirstChild("HumanoidRootPart") or nil
end
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
function H.countTable(value)
    if typeof(value) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(value) do count = count + 1 end
    return count
end
function H.formatNumber(value)
    local number = tonumber(value) or 0
    local suffixes = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local suffixIndex = 1
    for _ = 1, 6 do
        if number >= 1000 then number = number / 1000; suffixIndex = suffixIndex + 1 end
    end
    if suffixIndex == 1 then return string.format("%d", number) end
    return string.format("%.2f%s", number, suffixes[suffixIndex])
end
function H.formatElapsed(seconds)
    local total = math.max(0, math.floor(seconds))
    local hours = math.floor(total / 3600)
    local minutes = math.floor((total % 3600) / 60)
    if hours > 0 then return string.format("%dh %dm", hours, minutes) end
    return string.format("%dm", minutes)
end
function H.resolveRarity(assetCategory)
    if typeof(assetCategory) ~= "string" or not AssetsData or typeof(AssetsData.Directory) ~= "table" then return nil end
    local directoryEntry = AssetsData.Directory[assetCategory]
    local rarity = directoryEntry and directoryEntry.Rarity
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
    local mutations = {}
    if typeof(asset) ~= "table" then return mutations end
    if typeof(asset.Mutations) == "table" then
        for _, mutation in pairs(asset.Mutations) do
            if typeof(mutation) == "string" then table.insert(mutations, mutation) end
        end
    end
    if typeof(asset.BaseMutation) == "string" then table.insert(mutations, asset.BaseMutation) end
    return mutations
end
function H.getLaneZ()
    if AreasFolder then
        local gameplayZ = AreasFolder:FindFirstChild("GameplayZ")
        if gameplayZ and gameplayZ:IsA("BasePart") then return gameplayZ.Position.Z end
        local separationLine = AreasFolder:FindFirstChild("SeparationLine")
        if separationLine and separationLine:IsA("BasePart") then return separationLine.Position.Z end
    end
    return -365.5
end
function H.getLaneY()
    if AreasFolder then
        local gameplayZ = AreasFolder:FindFirstChild("GameplayZ")
        if gameplayZ and gameplayZ:IsA("BasePart") then return gameplayZ.Position.Y + 3 end
    end
    local root = H.getRoot()
    return root and root.Position.Y or 70
end
function H.getEntryPosition()
    if AreasFolder then
        local startArea = AreasFolder:FindFirstChild("StartArea")
        if startArea and startArea:IsA("BasePart") then return Vector3.new(startArea.Position.X, H.getLaneY(), H.getLaneZ()) end
        local separationLine = AreasFolder:FindFirstChild("SeparationLine")
        if separationLine and separationLine:IsA("BasePart") then return Vector3.new(separationLine.Position.X, H.getLaneY(), H.getLaneZ()) end
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
        local className = inst.ClassName
        if className == "BodyVelocity" or className == "BodyPosition" or className == "BodyGyro"
            or className == "BodyAngularVelocity" or className == "LinearVelocity"
            or className == "VectorForce" or className == "AlignOrientation" then
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
    local character = LocalPlayer.Character
    if character and character.Parent then
        pcall(function() character:PivotTo(cf) end)
    else
        safePivot(root, cf)
    end
end
function H.groundedY(x, z, fallbackY)
    local laneY = H.getLaneY()
    local root = H.getRoot()
    local humanoid = H.getHumanoid()
    local hipHeight = 2
    if humanoid and humanoid.HipHeight > 0 then hipHeight = humanoid.HipHeight end
    local rootHalfHeight = root and root.Size.Y * 0.5 or 1
    local characterOffset = hipHeight + rootHalfHeight
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
    if hitY then return math.clamp(hitY + characterOffset, laneY - 2, laneY + 5) end
    if typeof(fallbackY) == "number" then return math.clamp(fallbackY, laneY - 2, laneY + 5) end
    return laneY + 3
end
function H.stealSpeed() return math.min(DEFAULT_STEAL_SPEED, MAX_SAFE_SPEED) end
function H.swapStealHumanoid()
    local character = LocalPlayer.Character
    if not character then return false end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("LocalScript") and string.find(descendant.Name, "PushBack") then
            pcall(function() descendant.Disabled = true; descendant:Destroy() end)
        end
    end
    return true
end

function H.prepareStealHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local camera = Workspace.CurrentCamera
    local cameraCFrame = camera and camera.CFrame or nil
    local newHumanoid = nil
    local ok, clone = pcall(function() humanoid.Archivable = true; return humanoid:Clone() end)
    if ok and clone then
        newHumanoid = clone
        newHumanoid.Parent = character
        RunService.Heartbeat:Wait()
        pcall(function() if humanoid and humanoid.Parent then humanoid:Destroy() end end)
    else
        newHumanoid = humanoid
    end
    task.wait(0.1)
    newHumanoid = character:FindFirstChildOfClass("Humanoid") or newHumanoid
    if newHumanoid then
        newHumanoid.Sit = false
        newHumanoid.PlatformStand = false
        newHumanoid.WalkSpeed = H.stealSpeed()
        newHumanoid.AutoRotate = true
    end
    if camera and newHumanoid then
        pcall(function()
            camera.CameraSubject = newHumanoid
            if cameraCFrame then camera.CFrame = cameraCFrame end
        end)
    end
    return newHumanoid
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
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = H.getRoot()
    if not humanoid or not root then return false end
    humanoid.Sit = false
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    humanoid.WalkSpeed = H.stealSpeed()
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= StealConfig.ArriveDistance then return true end
    local route = H.buildStealPath(root.Position, dest)
    if #route == 0 then route = { dest } end
    local frameCounter = 0
    for _, point in ipairs(route) do
        if not running or (keepGoing and not keepGoing()) then return false end
        root = H.getRoot(); if not root then return false end
        local pointY = H.groundedY(point.X, point.Z, root.Position.Y)
        local waypoint = Vector3.new(point.X, pointY, point.Z)
        local deadline = os.clock() + StealConfig.MoveTimeout
        while running and os.clock() < deadline do
            if keepGoing and not keepGoing() then return false end
            root = H.getRoot(); if not root then return false end
            local offset = waypoint - root.Position
            local distance = offset.Magnitude
            if distance <= StealConfig.ArriveDistance then break end
            local direction = offset.Unit
            local dt = math.clamp(RunService.Heartbeat:Wait(), 0, 1 / 30)
            local step = math.min(H.stealSpeed() * dt, distance)
            local nextPos = root.Position + direction * step + jitterVector(0.1)
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            local newCF
            if flatDir.Magnitude > 0.001 then newCF = CFrame.lookAt(nextPos, nextPos + flatDir.Unit)
            else newCF = CFrame.new(nextPos) end
            safePivot(root, newCF)
            frameCounter = frameCounter + 1
            if frameCounter % 4 == 0 then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
    root = H.getRoot(); if not root then return false end
    H.placeRoot(root, CFrame.new(dest))
    return (root.Position - dest).Magnitude <= math.max(3, StealConfig.ArriveDistance + 1)
end

function H.stealMoveTo(targetX, targetZ, keepGoing)
    local root = H.getRoot(); if not root then return false end
    local y = H.groundedY(targetX, targetZ, root.Position.Y)
    return H.humanoidStealMoveTo(Vector3.new(targetX, y, targetZ), keepGoing)
end
function H.stealAlong(waypoints, keepGoing)
    for _, waypoint in ipairs(waypoints) do
        if keepGoing and not keepGoing() then return false end
        if not H.stealMoveTo(waypoint.X, waypoint.Z, keepGoing) then return false end
    end
    return true
end
function H.getBasePosition()
    if PlotApi.GetRespawnPointCFrame then
        local respawn = PlotApi.GetRespawnPointCFrame()
        if respawn then return respawn.Position end
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
    local standPosition = H.getPetAreaStandPosition()
    return standPosition ~= nil and (root.Position - standPosition).Magnitude <= 30
end

function H.bypassMoveTo(position, keepGoing, speed)
    if typeof(position) ~= "Vector3" or not running then return false end
    speed = math.min(tonumber(speed) or BYPASS_SPEED, MAX_SAFE_SPEED)
    local root = H.getRoot(); if not root then return false end
    H.stripCheatMovers(root); H.stopSoftMove(root)
    local humanoid = H.getHumanoid()
    if humanoid then humanoid.Sit = false; humanoid.PlatformStand = true end
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= BASE_RETURN_ARRIVE then
        if humanoid then humanoid.PlatformStand = false end
        return true
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ZenHubXBypassMove"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "ZenHubXBypassGyro"; bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 3000; bg.D = 50; bg.CFrame = root.CFrame; bg.Parent = root
    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then break end
        root = H.getRoot(); if not root then break end
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
    root = H.getRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if arrived then H.placeRoot(root, CFrame.new(dest.X, targetY, dest.Z)) end
    end
    humanoid = H.getHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    return arrived
end

function H.holdAtPosition(seconds, keepGoing)
    seconds = tonumber(seconds) or 3
    local root = H.getRoot(); if not root then return false end
    local anchorCF = root.CFrame
    local deadline = os.clock() + seconds
    local frameCounter = 0
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then return false end
        root = H.getRoot()
        if root then
            frameCounter = frameCounter + 1
            if frameCounter % 3 == 0 then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            safePivot(root, anchorCF)
        end
        RunService.Heartbeat:Wait()
    end
    return true
end
function H.returnToBaseBypass(keepGoing)
    local basePosition = H.getBasePosition()
    if not basePosition then return false end
    if keepGoing and not keepGoing() then return false end
    return H.bypassMoveTo(Vector3.new(basePosition.X, basePosition.Y + 3, basePosition.Z), keepGoing, BYPASS_SPEED)
end
function H.returnToBase(keepGoing) return H.returnToBaseBypass(keepGoing) end
function H.ensureAtPlot(keepGoing)
    if keepGoing and not keepGoing() then return false end
    if H.isNearPlot() then return true end
    local standPosition = H.getPetAreaStandPosition()
    if not standPosition then return false end
    return H.bypassMoveTo(standPosition, keepGoing, BYPASS_SPEED)
end

-- ============================================================
-- EXTRA FEATURES
-- ============================================================
local ExtrasState = {
    AntiRagdoll = false,
    InstantInteract = false,
    FixLag = false,
    AntiTrap = false,
    LookRocket = false,
    SpeedBypass = false,
    SpeedValue = 300,
    PromptAutoSteal = false,
}

local THROW_MULTIPLIER = 1.8
local lastVelocity = Vector3.zero
local lastRocket = 0

H.track(RunService.RenderStepped:Connect(function()
    if not running then return end
    local ch = LocalPlayer.Character
    local hrp = H.getRoot()
    local hum = H.getHumanoid()
    if not ch or not hrp or not hum then return end

    if ExtrasState.AntiRagdoll then
        hum.PlatformStand = false
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
        or st == Enum.HumanoidStateType.Physics then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        for _, obj in ipairs(ch:GetDescendants()) do
            if obj:IsA("Constraint") and obj:GetAttribute("RagdollConstraint") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Attachment") and obj:GetAttribute("RagdollAttachment") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Motor6D") and not obj.Enabled and string.find(string.lower(obj.Name), "ragdoll") then
                pcall(function() obj.Enabled = true end)
            end
        end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y > 30 then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
    end

    if ExtrasState.LookRocket then
        local cur = hrp.AssemblyLinearVelocity
        local horizontal = Vector3.new(cur.X, 0, cur.Z)
        local oldHorizontal = Vector3.new(lastVelocity.X, 0, lastVelocity.Z)
        if horizontal.Magnitude > 15 and oldHorizontal.Magnitude < 10 and os.clock() - lastRocket > 0.08 then
            local cam = Workspace.CurrentCamera
            if cam then
                local lookDir = cam.CFrame.LookVector.Unit
                local sp = horizontal.Magnitude * THROW_MULTIPLIER
                hrp.AssemblyLinearVelocity = lookDir * sp
                lastRocket = os.clock()
            end
        end
    end
    lastVelocity = hrp.AssemblyLinearVelocity
end))

local function applyInstantHold(prompt)
    if not ExtrasState.InstantInteract or not prompt:IsA("ProximityPrompt") then return end
    if LocalPlayer.Character and prompt:IsDescendantOf(LocalPlayer.Character) then return end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp and prompt:IsDescendantOf(bp) then return end
    pcall(function() prompt.HoldDuration = 0 end)
end
H.track(Workspace.DescendantAdded:Connect(function(d)
    if ExtrasState.InstantInteract and d:IsA("ProximityPrompt") then
        task.defer(applyInstantHold, d)
    end
end))
function ExtrasState.SetInstantHold(on)
    ExtrasState.InstantInteract = on
    if on then
        for _, p in ipairs(Workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then applyInstantHold(p) end
        end
    end
end

local FOLIAGE_WORDS = {"tree","leaf","leaves","grass","bush","foliage","plant","wood","flower"}
local function isFoliage(obj)
    local n = string.lower(obj.Name)
    for _, w in ipairs(FOLIAGE_WORDS) do
        if string.find(n, w, 1, true) then return true end
    end
    return false
end
local function clayAndClean(obj)
    if not ExtrasState.FixLag then return end
    if isFoliage(obj) then pcall(function() obj:Destroy() end); return end
    if obj:IsA("SurfaceAppearance") or obj:IsA("Texture") or obj:IsA("Decal")
    or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles")
    or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Highlight") then
        pcall(function() obj:Destroy() end); return
    end
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        pcall(function()
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            if obj:IsA("MeshPart") then obj.TextureID = "" end
        end)
    end
end
H.track(Workspace.DescendantAdded:Connect(function(d)
    if ExtrasState.FixLag then task.defer(clayAndClean, d) end
end))
function ExtrasState.EnableFixLag()
    ExtrasState.FixLag = true
    pcall(function()
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
        Lighting.GlobalShadows = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
            or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end)
    for _, obj in ipairs(Workspace:GetDescendants()) do clayAndClean(obj) end
end

local TRAP_WORDS = {"trap","snare","bear_trap","playertrap","cage"}
local function isTrap(obj)
    local n = string.lower(obj.Name)
    for _, w in ipairs(TRAP_WORDS) do
        if string.find(n, w, 1, true) then return true end
    end
    return false
end
local function neutralizeTrap(obj)
    if not ExtrasState.AntiTrap or not isTrap(obj) then return end
    for _, p in ipairs(obj:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function() p.CanTouch = false; p.CanCollide = false; p.Transparency = 1 end)
        elseif p:IsA("TouchTransmitter") or p:IsA("Script") or p:IsA("LocalScript") then
            pcall(function() p:Destroy() end)
        end
    end
    task.defer(function() pcall(function() obj:Destroy() end) end)
end
H.track(Workspace.DescendantAdded:Connect(function(d)
    if ExtrasState.AntiTrap then task.defer(neutralizeTrap, d) end
end))
function ExtrasState.EnableAntiTrap()
    ExtrasState.AntiTrap = true
    local ch = LocalPlayer.Character
    if ch and not ch:FindFirstChild("ZenHubXTrapField") then
        local ff = Instance.new("ForceField")
        ff.Name = "ZenHubXTrapField"; ff.Visible = false; ff.Parent = ch
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do neutralizeTrap(obj) end
end

function ExtrasState.ApplySpeedBypass(targetSpeed)
    local ch = LocalPlayer.Character
    if not ch then return false end
    local oldHum = ch:FindFirstChildOfClass("Humanoid")
    if not oldHum then return false end
    local cam = Workspace.CurrentCamera
    local camCF = cam and cam.CFrame or nil
    local clone = oldHum:Clone()
    clone.Parent = ch
    oldHum:Destroy()
    task.wait(0.15)
    local newHum = ch:FindFirstChildOfClass("Humanoid")
    if newHum then
        if cam and camCF then
            pcall(function() cam.CameraSubject = newHum; cam.CFrame = camCF end)
        end
        newHum.WalkSpeed = tonumber(targetSpeed) or ExtrasState.SpeedValue
        pcall(function()
            newHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        end)
    end
    return true
end

H.track(RunService.Stepped:Connect(function()
    if not running or not ExtrasState.SpeedBypass then return end
    local hum = H.getHumanoid()
    if hum and hum.WalkSpeed ~= ExtrasState.SpeedValue then
        hum.WalkSpeed = ExtrasState.SpeedValue
    end
end))

function ExtrasState.VoidReset()
    local hrp = H.getRoot()
    if not hrp then return false end
    pcall(function()
        hrp.CFrame = CFrame.new(hrp.Position.X, -350, hrp.Position.Z)
    end)
    return true
end

-- ProximityPrompt Auto Steal
local STEAL_DISTANCE = 35
local PromptCache = {}
local function GetPromptPart(prompt)
    local parent = prompt.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Attachment") then return parent.Parent end
    if parent:IsA("Model") then return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart", true) end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end
local function IsStealPrompt(obj)
    if not obj:IsA("ProximityPrompt") then return false end
    local action = string.lower(tostring(obj.ActionText or ""))
    local stealKeywords = {"steal", "grab", "take", "collect", "rob", "loot", "pickpocket", "snatch", "open", "interact"}
    for _, keyword in ipairs(stealKeywords) do
        if string.find(action, keyword) then return true end
    end
    local promptName = string.lower(obj.Name or "")
    local parentName = string.lower(obj.Parent and obj.Parent.Name or "")
    return string.find(promptName, "steal") ~= nil or string.find(parentName, "steal") ~= nil
end
local function RefreshPromptCache()
    H.clearTable(PromptCache)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if IsStealPrompt(obj) then table.insert(PromptCache, obj) end
    end
end
H.track(Workspace.DescendantAdded:Connect(function(d)
    if IsStealPrompt(d) then table.insert(PromptCache, d) end
end))
H.track(Workspace.DescendantRemoving:Connect(function(d)
    if d:IsA("ProximityPrompt") then
        local idx = table.find(PromptCache, d)
        if idx then table.remove(PromptCache, idx) end
    end
end))
local function FindNearestStealOptimized()
    local hrp = H.getRoot()
    if not hrp or not hrp.Parent then return nil end
    local closest, closestDistance = nil, STEAL_DISTANCE
    for i = #PromptCache, 1, -1 do
        local obj = PromptCache[i]
        if obj and obj.Parent and obj.Enabled then
            local part = GetPromptPart(obj)
            if part and part:IsA("BasePart") and part.Parent then
                local distance = (hrp.Position - part.Position).Magnitude
                if distance <= closestDistance then
                    closestDistance = distance
                    closest = obj
                end
            end
        else
            if not obj or not obj.Parent then table.remove(PromptCache, i) end
        end
    end
    return closest
end
local function ActivatePrompt(prompt)
    if not prompt or not prompt:IsDescendantOf(Workspace) or not prompt.Enabled then return false end
    if type(fireproximityprompt) == "function" then
        pcall(function() fireproximityprompt(prompt, STEAL_DISTANCE, 0, false) end)
    else
        pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()
        end)
    end
end
H.track(RunService.Heartbeat:Connect(function()
    if not running or not ExtrasState.PromptAutoSteal then return end
    local prompt = FindNearestStealOptimized()
    if prompt then ActivatePrompt(prompt) end
end))
task.spawn(function()
    RefreshPromptCache()
    while running do
        task.wait(3)
        if ExtrasState.PromptAutoSteal then pcall(RefreshPromptCache) end
    end
end)

-- ============================================================
-- EGG / STEAL
-- ============================================================
function H.getAreaEggs()
    if not EggApi.GetAreaEggSnapshot then return {} end
    local snapshot = EggApi.GetAreaEggSnapshot()
    if typeof(snapshot) ~= "table" or typeof(snapshot.Records) ~= "table" then
        if EggApi.RequestAreaEggSnapshot then pcall(EggApi.RequestAreaEggSnapshot) end
        snapshot = EggApi.GetAreaEggSnapshot()
    end
    if typeof(snapshot) ~= "table" or typeof(snapshot.Records) ~= "table" then return {} end
    local records = {}
    for _, record in pairs(snapshot.Records) do
        if typeof(record) == "table" and typeof(record.Uid) == "string" then table.insert(records, record) end
    end
    return records
end
function H.findAreaEggRecord(uid)
    for _, record in ipairs(H.getAreaEggs()) do if record.Uid == uid then return record end end
    return nil
end
function H.getSlotEggPosition(eggInstance)
    local part = eggInstance:FindFirstChild("Hitbox")
        or eggInstance:FindFirstChild("CustomBoundingBox")
        or eggInstance:FindFirstChildOfClass("BasePart")
    if part then return part.Position end
    return eggInstance:GetPivot().Position
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
    for _, record in ipairs(H.getAreaEggs()) do
        if typeof(record.Uid) == "string" then recordsByUid[record.Uid] = record end
    end
    local bypassFilters = H.isOn("AutoStealAll") and not H.isOn("AutoStealSelected")
    local root = H.getRoot()
    local priority = H.optionValue("StealPriority", "Rarest")
    local bestEgg, bestScore = nil, -math.huge
    for _, eggInstance in ipairs(worldEggs) do
        local record = recordsByUid[eggInstance.Name]
        local candidate = record and H.isStealCandidate(record, bypassFilters) or (record == nil and bypassFilters)
        if candidate then
            local position = H.getSlotEggPosition(eggInstance)
            local distance = root and position and (root.Position - position).Magnitude or math.huge
            local score
            if priority == "Nearest" then score = -distance
            elseif priority == "Furthest" then score = distance
            elseif priority == "Biggest Size" then score = tonumber(record and record.AssetScale) or 0
            else score = (record and H.eggScore(record) or 0) * 100000 - math.min(distance, 99999) end
            if score > bestScore then bestEgg = eggInstance; bestScore = score end
        end
    end
    return bestEgg
end
function H.stealingEnabled() return H.isOn("AutoStealSelected") or H.isOn("AutoStealAll") or H.isOn("StealBigEggs") end
function H.eggInventoryCount()
    local save = H.getSave()
    local inventory = save and save.EggInventory
    if typeof(inventory) ~= "table" then return 0 end
    return H.countTable(inventory)
end
function H.eggInventoryFull()
    local capacity = EggTypes and tonumber(EggTypes.MAX_INVENTORY) or math.huge
    return H.eggInventoryCount() >= capacity
end
function H.canAutoSteal() return H.stealingEnabled() and not IsCarryingEgg and not H.eggInventoryFull() end
function H.tryCarryEgg(eggInstance)
    if not eggInstance or not EggApi.RequestCarryAreaEgg then return false end
    local uid = eggInstance.Name
    local slotKey = nil
    if SlotIdentityApi.IsFirstAreaUid and SlotIdentityApi.IsFirstAreaUid(uid) then
        for _, record in ipairs(H.getAreaEggs()) do
            if record.Uid == uid and SlotIdentityApi.BuildSlotKey then
                slotKey = SlotIdentityApi.BuildSlotKey(record.AreaId, record.NestId)
                break
            end
        end
    end
    local ok, carried = pcall(function() return EggApi.RequestCarryAreaEgg(uid, slotKey) end)
    if ok and carried == true then return true end
    return IsCarryingEgg
end
function H.stealEgg(slotEgg)
    H.swapStealHumanoid()
    if not H.prepareStealHumanoid() then return false end
    local targetPosition = H.getSlotEggPosition(slotEgg)
    local root = H.getRoot()
    if not root or not targetPosition then return false end
    if not H.stealAlong(H.buildStealPath(root.Position, targetPosition), H.stealingEnabled) then return false end
    root = H.getRoot()
    if root then
        local targetY = H.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
        H.placeRoot(root, CFrame.new(targetPosition.X, targetY, targetPosition.Z))
    end
    if not H.stealingEnabled() then return false end
    H.waitFor(StealConfig.GrabDelay, 0.04, function()
        root = H.getRoot()
        if root then
            local targetY = H.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
            H.placeRoot(root, CFrame.new(targetPosition.X, targetY, targetPosition.Z))
        end
        if not H.stealingEnabled() then return true end
        if not IsCarryingEgg then H.tryCarryEgg(slotEgg) end
        return IsCarryingEgg == true
    end)
    local carryDeadline = os.clock() + 2.5
    while running and H.stealingEnabled() and not IsCarryingEgg and os.clock() < carryDeadline do
        root = H.getRoot()
        if root then
            local targetY = H.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
            H.placeRoot(root, CFrame.new(targetPosition.X, targetY, targetPosition.Z))
        end
        H.tryCarryEgg(slotEgg)
        if IsCarryingEgg then break end
        task.wait(0.05)
    end
    if not IsCarryingEgg then return false end
    H.holdAtPosition(STEAL_HOLD_TIME, H.stealingEnabled)
    if running and H.stealingEnabled() then
        if not IsCarryingEgg then H.tryCarryEgg(slotEgg); task.wait(0.15) end
        local reDeadline = os.clock() + 1.5
        while running and H.stealingEnabled() and not IsCarryingEgg and os.clock() < reDeadline do
            H.tryCarryEgg(slotEgg); task.wait(0.05)
        end
    end
    H.returnToBaseBypass(H.stealingEnabled)
    local confirmDeadline = os.clock() + 3
    while running and H.stealingEnabled() and IsCarryingEgg and os.clock() < confirmDeadline do task.wait(0.1) end
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
    local keepReturning = function() return H.isOn("AutoReturn") and IsCarryingEgg end
    if not H.returnToBaseBypass(keepReturning) then return false end
    local root = H.getRoot()
    if root and PlotApi.IsWorldPositionWithinLocalPlotBounds and PlotApi.IsWorldPositionWithinLocalPlotBounds(root.Position) then
        H.waitFor(4, 0.15, function() return (not IsCarryingEgg) or (not H.isOn("AutoReturn")) end)
    end
    return true
end

if EggApi.AreaEggCarryStateChanged and typeof(EggApi.AreaEggCarryStateChanged.Connect) == "function" then
    H.track(EggApi.AreaEggCarryStateChanged:Connect(function(state)
        local carryingNow = typeof(state) == "table" and state.IsCarrying == true
        local startedCarrying = carryingNow and not IsCarryingEgg
        if startedCarrying then
            SessionStolenEggs = SessionStolenEggs + 1
            if CarryStartedCallback then CarryStartedCallback(state) end
        end
        IsCarryingEgg = carryingNow
    end))
end

-- ============================================================
-- PLACE / HATCH / SELL / FUSE / UPGRADE
-- ============================================================
function H.getUnplacedEggUids()
    local save = H.getSave()
    local eggInventory = save and save.EggInventory
    local result = {}
    if typeof(eggInventory) ~= "table" then return result end
    local bypass = H.isOn("AutoPlaceAll") and not H.isOn("AutoPlaceSelected")
    for uid, egg in pairs(eggInventory) do
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
    local size = petArea.Size
    local placements = {}
    for x = -size.X * 0.5 + 5, size.X * 0.5 - 5, 7 do
        for z = -size.Z * 0.5 + 5, size.Z * 0.5 - 5, 7 do
            local worldPoint = petArea.CFrame:PointToWorldSpace(Vector3.new(x, 1, z))
            table.insert(placements, centerPoint.CFrame:ToObjectSpace(CFrame.new(worldPoint)))
        end
    end
    return placements
end
function H.canAutoPlace()
    return H.placingEnabled() and not IsCarryingEgg and not H.isPlotFull() and #H.getUnplacedEggUids() > 0
end
function H.runAutoPlaceEggs(forceRun)
    if IsCarryingEgg or not EggApi.RequestPlaceEgg then return end
    local function canContinue() return (forceRun == true or H.placingEnabled()) and not IsCarryingEgg end
    local unplaced = H.getUnplacedEggUids()
    if #unplaced == 0 or not H.ensureAtPlot(canContinue) then return end
    local placements = H.getPlacementLocalCFrames()
    if #placements == 0 then return end
    local placedAny = false
    for _, uid in ipairs(unplaced) do
        if not running or not canContinue() then return placedAny end
        if not H.isNearPlot() and not H.ensureAtPlot(canContinue) then return placedAny end
        if EggApi.RequestEquipTool then pcall(EggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        local placedThisEgg = false
        for offset = 0, #placements - 1 do
            local placementIndex = (NextPlacementIndex + offset - 1) % #placements + 1
            local success = false
            pcall(function() success = EggApi.RequestPlaceEgg(uid, placements[placementIndex]) == true end)
            if success then
                NextPlacementIndex = placementIndex + 1
                placedThisEgg = true; placedAny = true
                task.wait(0.25); break
            end
        end
        if not placedThisEgg then H.markPlotFull(); return placedAny end
        PlotFullUntil = 0
    end
    return placedAny
end
function H.canAutoHatch() return H.isOn("AutoOpenReadyEggs") and not IsCarryingEgg end
function H.runAutoOpenReadyEggs()
    local save = H.getSave()
    local eggInventory = save and save.EggInventory
    if typeof(eggInventory) ~= "table" then return end
    local hatchedAny = false
    for uid, egg in pairs(eggInventory) do
        if not running or not H.isOn("AutoOpenReadyEggs") then return hatchedAny end
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement ~= nil
            and H.matchesEggFilters(egg, nil, "LifecycleRarities", "LifecycleMutations") then
            local ready = false
            if EggApi.IsLocalEggReady then pcall(function() ready = EggApi.IsLocalEggReady(uid) == true end) end
            if ready and EggApi.RequestHatchEgg then
                local hatchStarted = false
                pcall(function() hatchStarted = EggApi.RequestHatchEgg(uid) == true end)
                if hatchStarted then
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
    local ok, itemData = pcall(AssetItemsApi.Deserialize, serializedPet)
    if not ok or typeof(itemData) ~= "table" then return nil end
    return itemData
end
function H.findToolByUid(uid)
    local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") and child:GetAttribute("UID") == uid then return child end
            end
        end
    end
    return nil
end
function H.holdUid(uid)
    local character = LocalPlayer.Character
    local humanoid = H.getHumanoid()
    if not character or not humanoid then return false end
    local tool = H.findToolByUid(uid)
    if not tool then return false end
    if tool.Parent == character then return true end
    pcall(function() humanoid:EquipTool(tool) end)
    return H.waitFor(1, 0.05, function() return tool.Parent == LocalPlayer.Character end)
end
function H.sellUid(uid)
    if not H.holdUid(uid) then return false end
    H.netCall(Remotes.AssetInventory.SELL_ASSET, uid)
    return H.waitFor(2, 0.1, function()
        local save = H.getSave(); if not save then return false end
        local inventory = save.Inventory or {}
        local eggInventory = save.EggInventory or {}
        return inventory[uid] == nil and eggInventory[uid] == nil
    end)
end

-- ============================================================
-- ADVANCED PET SELL SYSTEM (Whitelist / Blacklist)
-- ============================================================
local PetSellConfig = {
    AutoSellPet = false,
    SellPetWhitelist = {},
    SellPetBlacklist = {},
    UseWhitelist = true,
    SellPetInterval = 15,
    KeepBestPet = true,
}
local PetSellCache = { petList = {}, petListAt = 0 }

function H.getPetListForSell(force)
    if not force and os.clock() - PetSellCache.petListAt < 2 then
        return PetSellCache.petList
    end
    local save = H.getSave()
    local inventory = save and save.Inventory
    local list = {}
    if typeof(inventory) == "table" then
        for uid, asset in pairs(inventory) do
            if typeof(uid) == "string" and typeof(asset) == "table" then
                local category = asset.Category
                local name = H.assetName(category)
                local rarity = H.resolveRarity(category) or "Common"
                local scale = tonumber(asset.Scale) or 0
                list[#list + 1] = {
                    uid = uid,
                    name = name,
                    rarity = rarity,
                    scale = scale,
                    category = category,
                    mutations = H.recordMutations(asset),
                }
            end
        end
    end
    PetSellCache.petList = list
    PetSellCache.petListAt = os.clock()
    return list
end

function H.isPetInSellList(pet)
    local name = tostring(pet.name or ""):lower()
    local rarity = tostring(pet.rarity or ""):lower()
    if PetSellConfig.UseWhitelist then
        if next(PetSellConfig.SellPetWhitelist) == nil then return false end
        for k, v in pairs(PetSellConfig.SellPetWhitelist) do
            if v == true then
                local key = tostring(k):lower()
                if name:find(key, 1, true) or rarity:find(key, 1, true) then
                    return true
                end
            end
        end
        return false
    else
        for k, v in pairs(PetSellConfig.SellPetBlacklist) do
            if v == true then
                local key = tostring(k):lower()
                if name:find(key, 1, true) or rarity:find(key, 1, true) then
                    return false
                end
            end
        end
        return true
    end
end

function H.findBestPetPerType(list)
    if not PetSellConfig.KeepBestPet then return {} end
    local best = {}
    for _, pet in ipairs(list) do
        local key = tostring(pet.name):lower()
        if not best[key] or (pet.scale or 0) > (best[key].scale or 0) then
            best[key] = pet
        end
    end
    local keep = {}
    for _, pet in pairs(best) do keep[pet.uid] = true end
    return keep
end

function H.runAutoSellPetsAdvanced()
    local list = H.getPetListForSell(true)
    if #list == 0 then return 0, "Không tìm thấy pet" end
    local keepBest = H.findBestPetPerType(list)
    local sold, skipped = 0, 0
    for _, pet in ipairs(list) do
        if not running or not PetSellConfig.AutoSellPet then break end
        if keepBest[pet.uid] then
            skipped = skipped + 1
        elseif H.isPetInSellList(pet) then
            H.sellUid(pet.uid)
            sold = sold + 1
            task.wait(0.08)
        else
            skipped = skipped + 1
        end
    end
    return sold, string.format("Đã bán %d / bỏ qua %d", sold, skipped)
end

function H.getSellablePets() return H.getPetListForSell(true) end
function H.runAutoSellPets() return H.runAutoSellPetsAdvanced() end

-- ============================================================
-- CONT
-- ============================================================
function H.getSellableEggUids()
    local save = H.getSave()
    local eggInventory = save and save.EggInventory
    local result = {}
    if typeof(eggInventory) ~= "table" then return result end
    local useRarityFilter = H.multiHasAny("SellEggRarities")
    local selectedRarities = H.multiSelected("SellEggRarities")
    for uid, egg in pairs(eggInventory) do
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil then
            local rarity = H.resolveRarity(egg.AssetCategory)
            if not useRarityFilter or (typeof(rarity) == "string" and selectedRarities[rarity] == true) then
                table.insert(result, uid)
            end
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
    local inventory = save and save.Inventory
    local groups = {}
    if typeof(inventory) ~= "table" then return groups end
    local equipped = save.EquippedAssets or {}
    local keepEquipped = H.isOn("FuseKeepEquipped")
    local keepMutated = H.isOn("FuseKeepMutated")
    local maxScale = tonumber(H.optionValue("FuseMaxScale", 10)) or 10
    local filterMutations = H.multiHasAny("FuseMutations")
    local selectedMutations = H.multiSelected("FuseMutations")
    for uid, pet in pairs(inventory) do
        if typeof(uid) == "string" and typeof(pet) == "table" then
            local category = pet.Category
            local selectable = false
            if typeof(category) == "string" and FuseApi.CanSelectPet then
                pcall(function() selectable = FuseApi.CanSelectPet(uid, pet, category, false) == true end)
            end
            if selectable and not (keepEquipped and table.find(equipped, uid) ~= nil) then
                local mutations = H.recordMutations(pet)
                local mutationAllowed = not (keepMutated and #mutations > 0)
                if mutationAllowed and filterMutations then
                    mutationAllowed = false
                    for _, mutation in ipairs(mutations) do
                        if selectedMutations[mutation] then mutationAllowed = true; break end
                    end
                end
                local rarity = H.resolveRarity(category)
                local scale = tonumber(pet.Scale) or 0
                local rarityAllowed = rarity == nil or H.selectionAllows("FuseRarities", rarity)
                if mutationAllowed and scale <= maxScale and rarityAllowed then
                    groups[category] = groups[category] or {}
                    table.insert(groups[category], { uid = uid, scale = scale })
                end
            end
        end
    end
    return groups
end
function H.pickFuseGroup(save)
    local groups = H.fuseGroups(save)
    local keepPerCategory = math.floor(tonumber(H.optionValue("FuseKeepPerCategory", 0)) or 0)
    local targetMode = H.optionValue("FuseTarget", "Highest Rarity")
    local selectedCategory, selectedScore = nil, -math.huge
    for category, pets in pairs(groups) do
        table.sort(pets, function(a, b) return a.scale < b.scale end)
        if #pets - keepPerCategory >= 3 then
            local rarityScore = RarityWeight[H.resolveRarity(category) or "Common"] or 0
            local score = rarityScore
            if targetMode == "Most Duplicates" then score = #pets
            elseif targetMode == "Lowest Rarity" then score = -rarityScore end
            if score > selectedScore then selectedCategory = category; selectedScore = score end
        end
    end
    if not selectedCategory then return nil end
    local pets = groups[selectedCategory]
    return { pets[1].uid, pets[2].uid, pets[3].uid }
end
function H.fusePrice(save, petUids)
    local inventory = save and save.Inventory
    if typeof(inventory) ~= "table" or not FuseApi.CalculateFusePrice then return nil end
    local itemData = {}
    for index, uid in ipairs(petUids) do
        local pet = inventory[uid]
        local decoded = pet and H.getPetItemData(pet)
        if not decoded then return nil end
        itemData[index] = decoded
    end
    local ok, price = pcall(FuseApi.CalculateFusePrice, itemData)
    return ok and tonumber(price) or nil
end
function H.getFuseMachinePosition()
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    local fuseMachine = machines and machines:FindFirstChild("FuseMachine")
    if not fuseMachine then return nil end
    local ok, pivot = pcall(function() return fuseMachine:GetPivot() end)
    if not ok or not pivot then return nil end
    return pivot.Position + Vector3.new(0, 4, 0)
end
function H.runAutoFusePets(forceRun)
    local save = H.getSave(); if not save then return end
    local function canContinue() return forceRun == true or H.isOn("AutoFusePets") end
    if save.FusionLocked == true then
        if H.isOn("FuseAutoReveal") or forceRun == true then H.netInvoke(Remotes.FuseMachine.COMPLETE_REVEAL) end
        return
    end
    local petUids = H.pickFuseGroup(save)
    if not petUids then return end
    local price = H.fusePrice(save, petUids)
    if price and (tonumber(save.Money) or 0) < price then return end
    local fusePosition = H.getFuseMachinePosition()
    if fusePosition and not H.bypassMoveTo(fusePosition, canContinue, BYPASS_SPEED) then return end
    if save.FusionInfoAcknowledged ~= true then H.netInvoke(Remotes.FuseMachine.ACKNOWLEDGE_INFO) end
    for _, uid in ipairs(petUids) do
        if not running or not canContinue() then return end
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
    local ownedTrails = save and save.TrailInventory
    if typeof(ownedTrails) ~= "table" then return false end
    local bestTrailId, bestPrice = nil, -1
    for _, trailName in ipairs(TrailNames) do
        local trailId = TrailIdByName[trailName]
        if trailId and ownedTrails[trailId] then
            local price = TrailPriceByName[trailName] or 0
            if price > bestPrice then bestPrice = price; bestTrailId = trailId end
        end
    end
    local wornSnapshot = H.netInvoke(Remotes.Trails.WORN_SNAPSHOT)
    local wornTrailId = typeof(wornSnapshot) == "table" and wornSnapshot[tostring(LocalPlayer.UserId)] or nil
    if not bestTrailId or wornTrailId == bestTrailId then return false end
    H.netInvoke(Remotes.Trails.REQUEST_SELECT, bestTrailId)
    return true
end
function H.gearBaseName(name) return tostring(name):gsub("%s*%[X%d+%]%s*$", "") end
function H.runAutoEquipBestGear()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local humanoid = H.getHumanoid()
    if not character or not backpack or not humanoid then return end
    local best, bestCost = nil, -1
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local cost = GearCostByName[H.gearBaseName(tool.Name)]
            if cost and cost > bestCost then bestCost = cost; best = tool end
        end
    end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local cost = GearCostByName[H.gearBaseName(tool.Name)]
            if cost and cost >= bestCost then return end
        end
    end
    if best then pcall(function() humanoid:EquipTool(best) end) end
end
function H.runAutoBuyTrail()
    local save = H.getSave()
    if not save or not H.multiHasAny("TrailWanted") then return false end
    local wanted = H.multiSelected("TrailWanted")
    local owned = save.TrailInventory or {}
    local boughtAny = false
    for _, trailName in ipairs(TrailNames) do
        if wanted[trailName] then
            local trailId = TrailIdByName[trailName]
            if trailId and not owned[trailId] then
                local price = TrailPriceByName[trailName] or 0
                if save.Money >= price then
                    H.netCall(Remotes.Trails.REQUEST_PURCHASE, trailId)
                    boughtAny = true; task.wait(0.35)
                    save = H.getSave() or save
                    owned = save.TrailInventory or owned
                end
            end
        end
    end
    return boughtAny
end
function H.runAutoUpgrades()
    local selected = H.multiSelected("UpgradeTypes")
    if not H.multiHasAny("UpgradeTypes") then selected = { Base = true, Treadmill = true } end
    local save = H.getSave(); if not save then return false end
    local upgraded = false
    if selected.Base and BaseUpgradeModule and typeof(BaseUpgradeModule.IsNextTierAffordable) == "function" then
        if BaseUpgradeModule.IsNextTierAffordable(save) then
            H.netCall(Remotes.Plots.REQUEST_BASE_UPGRADE)
            upgraded = true; task.wait(0.35)
        end
    end
    if selected.Treadmill and TreadmillsData and typeof(TreadmillsData.GetByUpgradeLevel) == "function" then
        local currentLevel = tonumber(save.TreadmillUpgradeLevel) or 0
        local nextUpgrade = TreadmillsData.GetByUpgradeLevel(currentLevel + 1)
        if nextUpgrade then
            local price = tonumber(nextUpgrade.Price) or math.huge
            if save.Money >= price then
                H.netCall(Remotes.Treadmills.REQUEST_UPGRADE, nextUpgrade._id)
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
    local isInGroup = false
    pcall(function()
        isInGroup = Constants and Constants.GROUP_ID and LocalPlayer:IsInGroupAsync(Constants.GROUP_ID) == true
    end)
    H.netInvoke(Remotes.GroupReward.CLAIM_REWARD, isInGroup)
    return true
end
function H.deleteOwnPetRenders()
    local renderedAssets = Workspace:FindFirstChild("ClientRenderedAssets")
    if not renderedAssets then return end
    for _, renderedAsset in ipairs(renderedAssets:GetChildren()) do
        if renderedAsset:GetAttribute("OwnerUserId") == LocalPlayer.UserId then pcall(function() renderedAsset:Destroy() end) end
    end
end
function H.getTreadmillStand()
    if not PlotApi.GetPlotData then return nil end
    local plot = PlotApi.GetPlotData()
    local plotFolder = plot and plot.PlotFolder
    local treadmill = plotFolder and plotFolder:FindFirstChild("TreadmillBottom")
    if not treadmill or not treadmill:IsA("BasePart") then return nil end
    return treadmill.Position + Vector3.new(0, 4, 0)
end
function H.isDoubleSpeedVisible()
    local ok, visible = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local elements = playerGui and playerGui:FindFirstChild("Elements")
        local left = elements and elements:FindFirstChild("Left")
        local tools = left and left:FindFirstChild("Tools")
        local doubleSpeed = tools and tools:FindFirstChild("DoubleYourSpeed")
        return doubleSpeed ~= nil and doubleSpeed.Visible == true
    end)
    return ok and visible == true
end
function H.dismountTreadmill()
    pcall(function()
        local input = game:GetService("VirtualInputManager")
        input:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        input:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    local humanoid = H.getHumanoid()
    if humanoid then humanoid.Jump = true; humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
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
    local treadmillPosition = H.getTreadmillStand()
    if not treadmillPosition then return end
    local root = H.getRoot(); if not root then return end
    if (root.Position - treadmillPosition).Magnitude > 12 then
        if not H.bypassMoveTo(treadmillPosition, nil, BYPASS_SPEED) then return end
    end
    H.netInvoke(Remotes.Treadmills.REQUEST_EQUIP_STATIC)
    TreadmillTrainingActive = true
    return true
end

local WaypointNames = { "Base", "Pet Area", "Treadmill", "Fuse Machine", "Lobby Entry" }
for _, zoneName in ipairs(AREA_ORDER) do table.insert(WaypointNames, zoneName) end
function H.resolveWaypoint(name)
    if typeof(name) ~= "string" then return nil end
    if name == "Base" then return H.getBasePosition()
    elseif name == "Pet Area" then return H.getPetAreaStandPosition()
    elseif name == "Treadmill" then return H.getTreadmillStand()
    elseif name == "Fuse Machine" then return H.getFuseMachinePosition()
    elseif name == "Lobby Entry" then return H.getEntryPosition() end
    return H.getZoneLaneCenter(name)
end

-- ============================================================
-- ESP
-- ============================================================
function H.espDistanceLimit() return tonumber(H.optionValue("EspDistance", 2000)) or 2000 end
function H.withinEspRange(position)
    local root = H.getRoot()
    return root ~= nil and (root.Position - position).Magnitude <= H.espDistanceLimit()
end
function H.espColorFor(rarity)
    local weight = RarityWeight[rarity or ""] or 0
    if weight >= 9 then return Color3.fromRGB(255, 120, 255)
    elseif weight >= 7 then return Color3.fromRGB(255, 90, 90)
    elseif weight >= 5 then return Color3.fromRGB(255, 190, 80)
    elseif weight >= 3 then return Color3.fromRGB(110, 195, 255) end
    return Color3.fromRGB(190, 200, 215)
end
function H.ensureEspEntry(id, color)
    local existing = EspEntries[id]
    if existing then return existing end
    local anchor = Instance.new("Part")
    anchor.Name = "EspAnchor"; anchor.Anchored = true; anchor.CanCollide = false
    anchor.CanQuery = false; anchor.CanTouch = false; anchor.Transparency = 1
    anchor.Size = Vector3.new(0.2, 0.2, 0.2); anchor.Parent = EspFolder
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EspLabel"; billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(220, 34); billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = anchor; billboard.Parent = anchor
    local label = Instance.new("TextLabel")
    label.Name = "Text"; label.BackgroundTransparency = 1; label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextStrokeTransparency = 0.4
    label.TextColor3 = color; label.Parent = billboard
    local entry = { anchor = anchor, billboard = billboard, label = label, highlight = nil }
    EspEntries[id] = entry
    return entry
end
function H.drawEspAt(id, position, text, color, adornee)
    local entry = H.ensureEspEntry(id, color)
    entry.anchor.CFrame = CFrame.new(position)
    entry.label.Text = text; entry.label.TextColor3 = color
    if adornee and adornee.Parent then
        if not entry.highlight then
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 0.6; highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = EspFolder; entry.highlight = highlight
        end
        entry.highlight.Adornee = adornee
        entry.highlight.FillColor = color; entry.highlight.OutlineColor = color
    elseif entry.highlight then entry.highlight:Destroy(); entry.highlight = nil end
    EspSeenThisPass[id] = true
end
function H.releaseEsp(id)
    local entry = EspEntries[id]; if not entry then return end
    if entry.highlight then entry.highlight:Destroy() end
    if entry.billboard then entry.billboard:Destroy() end
    if entry.anchor then entry.anchor:Destroy() end
    EspEntries[id] = nil
end
function H.clearAllEsp() for id in pairs(EspEntries) do H.releaseEsp(id) end end
function H.collectEggEsp()
    local showWorldEggs = H.isOn("EspWorldEggs")
    local showCarriedEggs = H.isOn("EspCarriedEggs")
    if not showWorldEggs and not showCarriedEggs then return end
    for _, egg in ipairs(H.getAreaEggs()) do
        local cframe = egg.BottomCFrame or egg.BoundsCFrame
        if cframe then
            local state = egg.State
            local shouldShow = (state == "Slot" and showWorldEggs) or ((state == "Dropped" or state == "Carried") and showCarriedEggs)
            if shouldShow and H.withinEspRange(cframe.Position) then
                local rarity = H.resolveRarity(egg.AssetCategory)
                local label = string.format("%s [%s]", H.assetName(egg.AssetCategory), tostring(rarity or "?"))
                if state == "Dropped" or state == "Carried" then label = string.format("%s\n%s", label, tostring(state)) end
                H.drawEspAt("egg_" .. egg.Uid, cframe.Position, label, H.espColorFor(rarity), nil)
            end
        end
    end
end
function H.collectGuardEsp()
    if not H.isOn("EspGuards") or not GuardAreasFolder then return end
    for _, guardArea in ipairs(GuardAreasFolder:GetChildren()) do
        local guard = guardArea:FindFirstChild("Guard")
        local ok, pivot = pcall(function() return guard and guard:GetPivot() or nil end)
        if ok and pivot and H.withinEspRange(pivot.Position) then
            H.drawEspAt("guard_" .. guardArea.Name, pivot.Position,
                string.format("Guard %s\n%s", guardArea.Name, tostring(guard:GetAttribute("GuardState") or "Idle")),
                Color3.fromRGB(255, 140, 90), guard)
        end
    end
end
function H.collectPetEsp()
    if not H.isOn("EspPets") then return end
    local renderedAssets = Workspace:FindFirstChild("ClientRenderedAssets")
    if not renderedAssets then return end
    local save = H.getSave()
    local inventory = save and save.Inventory or {}
    local runtimeByUid = {}
    pcall(function()
        if AssetRosterApi.GetRuntimeSnapshot then
            local snapshot = AssetRosterApi.GetRuntimeSnapshot() or {}
            for _, group in pairs(snapshot) do
                if typeof(group) == "table" and typeof(group.Records) == "table" then
                    for uid, record in pairs(group.Records) do runtimeByUid[uid] = record end
                end
            end
        end
    end)
    for _, renderedPet in ipairs(renderedAssets:GetChildren()) do
        local uid = renderedPet:GetAttribute("UID")
        local ok, pivot = pcall(function() return renderedPet:GetPivot() end)
        if typeof(uid) == "string" and ok and pivot and H.withinEspRange(pivot.Position) then
            local category, moneyPerSecond = nil, nil
            local savedPet = inventory[uid]
            if typeof(savedPet) == "table" then category = savedPet.Category end
            local runtimeRecord = runtimeByUid[uid]
            if typeof(runtimeRecord) == "table" then
                if not category and runtimeRecord.ItemData then category = runtimeRecord.ItemData.Category end
                moneyPerSecond = tonumber(runtimeRecord.MoneyPerSecond)
            end
            local rarity = H.resolveRarity(category)
            local label = string.format("%s [%s]", H.assetName(category), tostring(rarity or "?"))
            if moneyPerSecond then label = string.format("%s\n%s/s", label, H.formatNumber(moneyPerSecond)) end
            H.drawEspAt("pet_" .. renderedPet.Name, pivot.Position, label, H.espColorFor(rarity), renderedPet)
        end
    end
end
function H.collectPlayerEsp()
    if not H.isOn("EspPlayers") then return end
    local localRoot = H.getRoot()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root and H.withinEspRange(root.Position) then
                local distance = localRoot and (localRoot.Position - root.Position).Magnitude or 0
                H.drawEspAt("player_" .. player.Name, root.Position,
                    string.format("%s\n%d studs", player.DisplayName, math.floor(distance)),
                    Color3.fromRGB(120, 190, 255), character)
            end
        end
    end
end
function H.collectMachineEsp()
    if not H.isOn("EspMachines") then return end
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    if not machines then return end
    for _, machine in ipairs(machines:GetChildren()) do
        local ok, pivot = pcall(function() return machine:GetPivot() end)
        if ok and pivot and H.withinEspRange(pivot.Position) then
            H.drawEspAt("machine_" .. machine.Name, pivot.Position, machine.Name, Color3.fromRGB(230, 200, 120), machine)
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
            local ownerUserId = nil
            pcall(function()
                if PlotApi.GetSlotOwner then ownerUserId = PlotApi.GetSlotOwner(tonumber(plot.Name)) end
            end)
            local ownerText = "Empty"
            local numericUserId = tonumber(ownerUserId)
            if numericUserId then
                local owner = Players:GetPlayerByUserId(numericUserId)
                if owner then
                    ownerText = owner.DisplayName
                    if owner == LocalPlayer then ownerText = ownerText .. " (You)" end
                else ownerText = "User " .. tostring(numericUserId) end
            end
            H.drawEspAt("plot_" .. plot.Name, anchor.Position,
                string.format("Plot %s\n%s", plot.Name, ownerText),
                Color3.fromRGB(200, 170, 255), nil)
        end
    end
end
function H.runEsp()
    H.clearTable(EspSeenThisPass)
    H.collectEggEsp()
    H.collectGuardEsp()
    H.collectPetEsp()
    H.collectPlayerEsp()
    H.collectMachineEsp()
    H.collectPlotEsp()
    for id in pairs(EspEntries) do
        if not EspSeenThisPass[id] then H.releaseEsp(id) end
    end
end

-- ============================================================
-- SERVER HOP
-- ============================================================
function H.rememberVisited(serverId)
    if typeof(serverId) ~= "string" or serverId == "" then return end
    if H.countTable(VisitedServerIds) >= 300 then H.clearTable(VisitedServerIds) end
    VisitedServerIds[serverId] = true
end
H.rememberVisited(tostring(game.JobId))
H.track(TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage)
    if player == LocalPlayer then LastTeleportFailure = tostring(errorMessage or result) end
end))
function H.fetchServerPage(cursor)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100", game.PlaceId)
    if cursor then url = url .. "&cursor=" .. cursor end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or typeof(body) ~= "string" then return nil end
    local decodedOk, page = pcall(function() return HttpService:JSONDecode(body) end)
    if not decodedOk or typeof(page) ~= "table" or typeof(page.data) ~= "table" then return nil end
    return page
end
function H.pickHopTargets()
    local cursor = nil
    local candidates = {}
    for _ = 1, 4 do
        local page = H.fetchServerPage(cursor)
        if not page then break end
        for _, server in ipairs(page.data) do
            if typeof(server) == "table" and typeof(server.id) == "string"
                and server.id ~= game.JobId and not VisitedServerIds[server.id] then
                local playing = tonumber(server.playing) or 0
                local maxPlayers = tonumber(server.maxPlayers) or 0
                if maxPlayers > 0 and playing < maxPlayers then
                    table.insert(candidates, { id = server.id, playing = playing })
                end
            end
        end
        cursor = typeof(page.nextPageCursor) == "string" and page.nextPageCursor or nil
        if not cursor or #candidates >= 40 then break end
        task.wait(0.25)
    end
    table.sort(candidates, function(a, b) return a.playing < b.playing end)
    return candidates
end
function H.tryTeleportTo(serverId)
    LastTeleportFailure = nil
    task.wait(1)
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
        ServerHopRetryAfter = os.clock() + 30
        ServerHopInProgress = false
        return false
    end
    for attempt = 1, 3 do
        if attempt > 1 then
            targets = H.pickHopTargets()
            if typeof(targets) ~= "table" or #targets == 0 then
                ServerHopRetryAfter = os.clock() + 10
                ServerHopInProgress = false
                return false
            end
        end
        for index = 1, math.min(#targets, 10) do
            if not running then ServerHopInProgress = false; return false end
            local target = targets[index]
            H.rememberVisited(target.id)
            if H.tryTeleportTo(target.id) then
                ServerHopInProgress = false
                return true
            end
            task.wait(0.5)
        end
    end
    ServerHopRetryAfter = os.clock() + 10
    ServerHopInProgress = false
    return false
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
        NoMatchingEggsSince = 0
        H.serverHop("No matching eggs in this server")
    end
end
function H.rejoinServer()
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    if not ok then pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end
end
function H.hopLowPop()
    task.spawn(function()
        local page = H.fetchServerPage(nil)
        if not page then
            H.notify("Hop", "Không lấy được danh sách server", "Error", 3)
            return
        end
        local candidates = {}
        for _, s in ipairs(page.data or {}) do
            if typeof(s) == "table" and typeof(s.id) == "string" and s.id ~= game.JobId then
                local playing = tonumber(s.playing) or 0
                local maxP = tonumber(s.maxPlayers) or 30
                if playing > 0 and playing <= 5 and playing < maxP then
                    table.insert(candidates, s.id)
                end
            end
        end
        if #candidates == 0 then
            H.notify("Hop", "Không tìm thấy server ít người", "Warning", 3)
            return
        end
        local pick = candidates[math.random(1, #candidates)]
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, LocalPlayer) end)
        H.notify("Hop", "Đang chuyển sang server ít người", "Success", 3)
    end)
end

function H.openServerHopGUI()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    local old = pg:FindFirstChild("ZenHubX_ServerHopGUI")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZenHubX_ServerHopGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = pg

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -145, 0.5, -110)
    MainFrame.Size = UDim2.new(0, 290, 0, 220)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromHex("#8A2BE2")
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 36)
    Title.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.Text = "ZEN HUB X - HOP SERVER"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -28, 0, 6)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
    CloseBtn.TextSize = 13
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local NowLabel = Instance.new("TextLabel", MainFrame)
    NowLabel.Position = UDim2.new(0, 10, 0, 44)
    NowLabel.Size = UDim2.new(1, -20, 0, 22)
    NowLabel.BackgroundTransparency = 1
    NowLabel.Font = Enum.Font.GothamBold
    NowLabel.TextXAlignment = Enum.TextXAlignment.Left
    NowLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    NowLabel.TextSize = 12

    local StatusLabel = Instance.new("TextLabel", MainFrame)
    StatusLabel.Position = UDim2.new(0, 10, 0, 70)
    StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 11
    StatusLabel.TextWrapped = true

    local MaxLabel = Instance.new("TextLabel", MainFrame)
    MaxLabel.Position = UDim2.new(0, 10, 0, 105)
    MaxLabel.Size = UDim2.new(1, -20, 0, 18)
    MaxLabel.BackgroundTransparency = 1
    MaxLabel.Font = Enum.Font.Gotham
    MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
    MaxLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    MaxLabel.TextSize = 11
    MaxLabel.Text = "Hop nếu số player LỚN HƠN hoặc BẰNG:"

    local MaxBox = Instance.new("TextBox", MainFrame)
    MaxBox.Position = UDim2.new(0, 10, 0, 126)
    MaxBox.Size = UDim2.new(1, -20, 0, 28)
    MaxBox.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    MaxBox.BorderSizePixel = 0
    MaxBox.Font = Enum.Font.GothamBold
    MaxBox.Text = "5"
    MaxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaxBox.TextSize = 14
    MaxBox.ClearTextOnFocus = false
    Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 6)

    local HopBtn = Instance.new("TextButton", MainFrame)
    HopBtn.Position = UDim2.new(0, 10, 0, 162)
    HopBtn.Size = UDim2.new(0, 125, 0, 45)
    HopBtn.BackgroundColor3 = Color3.fromHex("#8A2BE2")
    HopBtn.BorderSizePixel = 0
    HopBtn.Font = Enum.Font.GothamBold
    HopBtn.Text = "Hop 1 Lần"
    HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HopBtn.TextSize = 13
    Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 6)

    local AutoBtn = Instance.new("TextButton", MainFrame)
    AutoBtn.Position = UDim2.new(0, 145, 0, 162)
    AutoBtn.Size = UDim2.new(0, 135, 0, 45)
    AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
    AutoBtn.BorderSizePixel = 0
    AutoBtn.Font = Enum.Font.GothamBold
    AutoBtn.Text = "Auto Hop: OFF"
    AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoBtn.TextSize = 13
    Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 6)

    local autoEnabled = false
    local autoThread = nil

    task.spawn(function()
        while ScreenGui.Parent do
            local count = #Players:GetPlayers()
            NowLabel.Text = "Player ở server hiện tại: " .. count
            task.wait(1)
        end
    end)

    local function getRandomServer()
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local raw = nil
        if req then
            local ok, res = pcall(function() return req({ Url = url, Method = "GET" }) end)
            if ok and res and res.Body then raw = res.Body end
        else
            pcall(function() raw = game:HttpGet(url) end)
        end
        if not raw or raw == "" then return nil end
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok2 or not data or not data.data or #data.data == 0 then return nil end
        local targetMax = tonumber(MaxBox.Text) or 5
        local candidates = {}
        for _, s in ipairs(data.data) do
            if s.id and tostring(s.id) ~= tostring(game.JobId) then
                if s.playing and s.playing < targetMax then table.insert(candidates, tostring(s.id)) end
            end
        end
        if #candidates == 0 then
            for _, s in ipairs(data.data) do
                if s.id and tostring(s.id) ~= tostring(game.JobId) then table.insert(candidates, tostring(s.id)) end
            end
        end
        if #candidates == 0 then return nil end
        return candidates[math.random(1, #candidates)]
    end

    local function hopOnce()
        local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 5))
        local currentCount = #Players:GetPlayers()
        if currentCount < threshold then
            StatusLabel.Text = "✓ Server hiện có " .. currentCount .. " player (< " .. threshold .. "). Không cần hop."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            return false
        end
        StatusLabel.Text = "Server đang có " .. currentCount .. " player. Đang tìm server nhỏ hơn..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(0.5)
        local serverId = getRandomServer()
        if not serverId then
            StatusLabel.Text = "Không lấy được danh sách Server! Vui lòng thử lại..."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            return false
        end
        StatusLabel.Text = "Đang kết nối sang Server mới..."
        StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
        task.wait(0.5)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer) end)
        return true
    end

    HopBtn.MouseButton1Click:Connect(function()
        HopBtn.Active = false
        hopOnce()
        task.wait(2)
        HopBtn.Active = true
    end)

    AutoBtn.MouseButton1Click:Connect(function()
        autoEnabled = not autoEnabled
        if autoEnabled then
            AutoBtn.Text = "Auto Hop: ON"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            autoThread = task.spawn(function()
                while autoEnabled and ScreenGui.Parent do
                    local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 5))
                    local count = #Players:GetPlayers()
                    if count < threshold then
                        StatusLabel.Text = "✓ Đã tìm thấy server phù hợp (" .. count .. " player). Giữ nguyên."
                        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                        task.wait(3)
                    else
                        hopOnce()
                        task.wait(5)
                    end
                end
            end)
        else
            AutoBtn.Text = "Auto Hop: OFF"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
            if autoThread then task.cancel(autoThread); autoThread = nil end
            StatusLabel.Text = "Đã dừng Auto Hop."
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)

    StatusLabel.Text = "Hãy nhập số người tối đa & ấn Hop."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
end

-- ============================================================
-- WEBHOOK
-- ============================================================
function H.webhookPing()
    local numericId = tostring(H.optionValue("WebhookPingId", "") or ""):gsub("%D", "")
    if numericId == "" then return nil end
    return string.format("<@%s>", numericId)
end
function H.httpPost(payload)
    local requestFn = (syn and syn.request) or (http and http.request) or http_request or request
    if typeof(requestFn) ~= "function" then return false end
    local webhookUrl = tostring(H.optionValue("WebhookUrl", "") or "")
    if webhookUrl == "" then return false end
    local encodedBody
    local encoded = pcall(function() encodedBody = HttpService:JSONEncode(payload) end)
    if not encoded then return false end
    return pcall(requestFn, {
        Url = webhookUrl, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = encodedBody,
    })
end
function H.sendWebhookEmbed(embed, includePing)
    if not H.isOn("WebhookEnabled") then return false end
    local payload = { username = "ZenHubX", embeds = { embed } }
    if includePing then payload.content = H.webhookPing() end
    return H.httpPost(payload)
end
function H.embedField(name, value, inline) return { name = name, value = value, inline = inline ~= false } end

CarryStartedCallback = function(eventData)
    if typeof(eventData) ~= "table" then return end
    local record = typeof(eventData.Uid) == "string" and H.findAreaEggRecord(eventData.Uid) or nil
    local category = record and record.AssetCategory or eventData.AssetCategory
    local parts = { string.format("**%s** `%s`", H.assetName(category), tostring(H.resolveRarity(category) or "?")) }
    local areaId = record and record.AreaId or eventData.AreaId
    if typeof(areaId) == "string" then table.insert(parts, areaId) end
    if record then
        local scale = tonumber(record.AssetScale)
        if scale then table.insert(parts, string.format("x%.2f", scale)) end
        local mutations = H.recordMutations(record)
        if #mutations > 0 then table.insert(parts, table.concat(mutations, ", ")) end
    end
    if #ObtainedEggLog < 100 then table.insert(ObtainedEggLog, table.concat(parts, " | ")) end
end
function H.trackWebhookEvents()
    local save = H.getSave()
    if not save then return end
    if not WebhookTrackerInitialized then
        WebhookTrackerInitialized = true
        for uid in pairs(save.Inventory or {}) do KnownInventoryUids[uid] = true end
        for _, egg in ipairs(H.getAreaEggs()) do KnownWorldEggUids[egg.Uid] = true end
        LastRebirthSnapshot = tonumber(save.Rebirth) or 0
        LastStealCountSnapshot = SessionStolenEggs
        return
    end
    SummaryStolenEggs = SummaryStolenEggs + math.max(0, SessionStolenEggs - LastStealCountSnapshot)
    LastStealCountSnapshot = SessionStolenEggs
    for uid in pairs(save.Inventory or {}) do
        if KnownInventoryUids[uid] == nil then
            KnownInventoryUids[uid] = true
            SummaryPetsObtained = SummaryPetsObtained + 1
        end
    end
    local rebirths = tonumber(save.Rebirth) or 0
    if LastRebirthSnapshot and rebirths > LastRebirthSnapshot then
        SummaryRebirths = SummaryRebirths + rebirths - LastRebirthSnapshot
    end
    LastRebirthSnapshot = rebirths
    local currentWorldEggs = {}
    local logSpawns = H.isOn("WebhookEggSpawns")
    for _, egg in ipairs(H.getAreaEggs()) do
        currentWorldEggs[egg.Uid] = true
        if KnownWorldEggUids[egg.Uid] == nil then
            KnownWorldEggUids[egg.Uid] = true
            local rarity = H.resolveRarity(egg.AssetCategory)
            if logSpawns and H.selectionAllows("WebhookRarities", rarity or "") and #SpawnedEggLog < 60 then
                table.insert(SpawnedEggLog, {
                    rank = RarityWeight[rarity or ""] or 0,
                    order = #SpawnedEggLog,
                    text = string.format("**%s** `%s` in %s", H.assetName(egg.AssetCategory), tostring(rarity or "?"), tostring(egg.AreaId)),
                })
            end
        end
    end
    for uid in pairs(KnownWorldEggUids) do
        if not currentWorldEggs[uid] then KnownWorldEggUids[uid] = nil end
    end
end
function H.buildSummaryEmbed()
    local save = H.getSave()
    local fields = {}
    if save then
        table.insert(fields, H.embedField("Money", "`" .. H.formatNumber(save.Money) .. "`"))
        table.insert(fields, H.embedField("Speed Power", "`" .. H.formatNumber(save.SpeedPower) .. "`"))
        table.insert(fields, H.embedField("Rebirth", "`" .. tostring(save.Rebirth or 0) .. "`"))
        table.insert(fields, H.embedField("Pets Owned", "`" .. tostring(H.countTable(save.Inventory)) .. "`"))
    end
    table.insert(fields, H.embedField("Since Last Summary",
        string.format("Eggs stolen: **%d**\nPets obtained: **%d**\nRebirths: **%d**", SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths), false))
    return {
        author = { name = "Steal an Egg | ZenHubX" },
        title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            LocalPlayer.Name, DisplayJobId, H.formatElapsed(os.clock() - SessionStartedAt)),
        color = 10033663, fields = fields,
        footer = { text = "ZenHubX | " .. DISCORD_LINK },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end
H.sendSummary = function()
    local sent = H.sendWebhookEmbed(H.buildSummaryEmbed(), true)
    if sent then
        SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0, 0, 0
        H.clearTable(SpawnedEggLog); H.clearTable(ObtainedEggLog)
    end
    return sent
end
function H.runWebhookSummary()
    local interval = (tonumber(H.optionValue("WebhookInterval", 15)) or 15) * 60
    if os.clock() - LastWebhookSummaryAt < interval then return false end
    LastWebhookSummaryAt = os.clock()
    return H.sendSummary()
end

-- ============================================================
-- PERFORMANCE
-- ============================================================
function H.applyAntiGameplayPause(enabled)
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(not enabled) end)
    pcall(function()
        local notification = CoreGui:FindFirstChild("RobloxNetworkPauseNotification")
        if notification then notification.Enabled = not enabled end
    end)
end
function H.applyRendering(disableRendering)
    pcall(function() RunService:Set3dRenderingEnabled(not disableRendering) end)
    RenderingDisabled = disableRendering
end
local FpsEffectClasses = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
function H.setEffectEnabled(inst, enabled) pcall(function() inst.Enabled = enabled end) end
function H.enableFpsBoost()
    if FpsBoostSnapshot then return end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local qualityLevel = nil
    pcall(function() qualityLevel = settings().Rendering.QualityLevel end)
    FpsBoostSnapshot = {
        QualityLevel = qualityLevel, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
        Terrain = terrain,
        WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
        WaterReflectance = terrain and terrain.WaterReflectance or nil,
        Effects = {},
    }
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1000000
    if terrain then terrain.WaterWaveSize = 0; terrain.WaterReflectance = 0 end
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if FpsEffectClasses[descendant.ClassName] and descendant.Enabled then
            table.insert(FpsBoostSnapshot.Effects, descendant)
            H.setEffectEnabled(descendant, false)
        end
    end
    FpsDescendantAddedConnection = Workspace.DescendantAdded:Connect(function(descendant)
        if FpsEffectClasses[descendant.ClassName] and H.isOn("FpsBoost") then H.setEffectEnabled(descendant, false) end
    end)
end
function H.disableFpsBoost()
    if FpsDescendantAddedConnection then FpsDescendantAddedConnection:Disconnect(); FpsDescendantAddedConnection = nil end
    local snapshot = FpsBoostSnapshot; if not snapshot then return end
    FpsBoostSnapshot = nil
    if snapshot.QualityLevel then pcall(function() settings().Rendering.QualityLevel = snapshot.QualityLevel end) end
    Lighting.GlobalShadows = snapshot.GlobalShadows; Lighting.FogEnd = snapshot.FogEnd
    if snapshot.Terrain and snapshot.Terrain.Parent then
        snapshot.Terrain.WaterWaveSize = snapshot.WaterWaveSize
        snapshot.Terrain.WaterReflectance = snapshot.WaterReflectance
    end
    for _, effect in ipairs(snapshot.Effects) do H.setEffectEnabled(effect, true) end
end
function H.applyFpsCap(value)
    local setCap = setfpscap or (syn and syn.set_fps_cap)
    if typeof(setCap) ~= "function" then
        if not FpsCapUnsupportedNotified then FpsCapUnsupportedNotified = true end
        return false
    end
    return pcall(setCap, math.clamp(tonumber(value) or 60, 15, 360))
end
function H.handleDisconnect(reason)
    if DisconnectHandled then return end
    DisconnectHandled = true
    if H.isOn("WebhookDisconnectAlerts") then
        H.sendWebhookEmbed({
            author = { name = "Steal an Egg | ZenHubX" },
            title = "Disconnected",
            description = string.format("**Player** `%s`\n**Reason** %s", LocalPlayer.Name, tostring(reason or "Connection lost")),
            color = 15158332,
            footer = { text = "ZenHubX | " .. DISCORD_LINK },
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
    for _, optionName in ipairs(PrioritySlotOptionNames) do
        local jobName = H.optionValue(optionName, nil)
        if AutomationJobs[jobName] and not used[jobName] then used[jobName] = true; table.insert(order, jobName) end
    end
    for _, jobName in ipairs(PriorityTaskNames) do
        if not used[jobName] then used[jobName] = true; table.insert(order, jobName) end
    end
    return order
end

-- ============================================================
-- STANDALONE UI
-- ============================================================
local UI = {}
UI.__state = {}
UI.__callbacks = {}
UI.__tabs = {}
UI.__activeTab = nil
UI.__connections = {}

local function conn(c) table.insert(UI.__connections, c); return c end

local COLORS = {
    panelBg       = Color3.fromRGB(14, 10, 20),
    panelBg2      = Color3.fromRGB(22, 16, 32),
    panelBorder   = Color3.fromRGB(55, 40, 80),
    panelBorderHi = Color3.fromRGB(140, 100, 200),
    sidebarBg     = Color3.fromRGB(12, 8, 18),
    sectionBg     = Color3.fromRGB(26, 18, 40),
    sectionBorder = Color3.fromRGB(58, 42, 88),
    text          = Color3.fromRGB(240, 235, 250),
    textDim       = Color3.fromRGB(180, 165, 210),
    textMuted     = Color3.fromRGB(120, 105, 150),
    accent        = Color3.fromRGB(150, 60, 220),
    accentHi      = Color3.fromRGB(185, 110, 255),
    toggleOn      = Color3.fromRGB(160, 70, 230),
    toggleOff     = Color3.fromRGB(48, 40, 62),
    success       = Color3.fromRGB(90, 210, 130),
    warning       = Color3.fromRGB(235, 175, 70),
    error         = Color3.fromRGB(240, 90, 90),
    info          = Color3.fromRGB(150, 130, 240),
}

-- ============================================================
-- LANGUAGE SYSTEM (VI <-> EN)
-- ============================================================
local LANG = { Current = "vi" }

local VI_TO_EN = {
    ["Trang chủ"]="Home", ["Pet"]="Pets", ["Tiến trình"]="Progress",
    ["Người chơi"]="Player", ["Bổ sung"]="Extras", ["Hệ thống"]="System",
    ["Phiên"]="Session", ["Trạng thái trực tiếp"]="Live status",
    ["Tài khoản"]="Account", ["Dữ liệu save"]="Save data", ["Thao tác nhanh"]="Quick Actions",
    ["Tự động hóa"]="Automation", ["Sẵn sàng"]="Ready", ["Tác vụ hiện tại"]="Current Job",
    ["Rảnh"]="Idle", ["Trứng đã trộm"]="Stolen Eggs", ["Đang mang trứng"]="Carrying Egg",
    ["Thời gian chạy"]="Runtime", ["Kho trứng"]="Egg Inventory",
    ["Tiền"]="Money", ["Sức mạnh tốc độ"]="Speed Power", ["Tái sinh"]="Rebirths",
    ["Pet sở hữu"]="Pets Owned",
    ["Về căn cứ"]="Return to Base", ["Về"]="Return", ["Đặt trứng"]="Place Eggs", ["Đặt"]="Place",
    ["Đổi server"]="Server Hop", ["Đổi"]="Hop", ["Gộp pet ngay"]="Fuse Now", ["Gộp"]="Fuse",
    ["Về Void (Reset nhanh)"]="Void Reset (Fast)", ["Void"]="Void",
    ["Trộm trứng"]="Steal Eggs", ["Farm trứng chính"]="Main egg farming",
    ["Trộm trứng (Prompt)"]="Steal Eggs (Prompt)",
    ["Phương pháp tương tác ProximityPrompt"]="ProximityPrompt interaction method",
    ["Xử lý trứng"]="Egg Handling", ["Thứ tự tác vụ"]="Task Order",
    ["Tự trộm mục đã chọn"]="Auto Steal Selected", ["Dùng bộ lọc bên dưới"]="Use filters below",
    ["Tự trộm tất cả"]="Auto Steal All", ["Bỏ qua độ hiếm/biến thể"]="Ignore rarity/mutation",
    ["Trộm trứng lớn"]="Steal Big Eggs",
    ["Bộ lọc mục tiêu"]="Target filters", ["Khu vực"]="Areas", ["Độ hiếm"]="Rarities",
    ["Biến thể"]="Mutations", ["Ưu tiên mục tiêu"]="Target Priority",
    ["Kích thước trứng lớn tối thiểu"]="Minimum Big Egg Size",
    ["Hành vi mang trứng"]="Carry behavior", ["Tự về căn cứ"]="Auto Return to Base",
    ["Tự thả trứng đang cầm"]="Auto Drop Held Egg",
    ["Tự trộm (ProximityPrompt)"]="Auto Steal (ProximityPrompt)",
    ["Tự bấm ProximityPrompt tầm xa 35 studs"]="Auto fire prompts within 35 studs",
    ["Tự đặt mục đã chọn"]="Auto Place Selected", ["Tự đặt tất cả"]="Auto Place All",
    ["Tự ấp trứng sẵn sàng"]="Auto Hatch Ready",
    ["Độ hiếm vòng đời"]="Lifecycle Rarities", ["Biến thể vòng đời"]="Lifecycle Mutations",
    ["Bán trứng"]="Egg selling", ["Tự bán trứng"]="Auto Sell Eggs",
    ["Độ hiếm bán"]="Sell Rarities", ["Chu kỳ bán"]="Sell Interval",
    ["Tự đổi server"]="Auto Server Hop", ["Đổi server khi"]="Hop When",
    ["Chờ trước khi đổi"]="Wait Before Hop", ["Đổi server ngay"]="Hop Now",
    ["Mở GUI đổi server chi tiết"]="Open Detailed Server Hop GUI", ["Mở"]="Open",
    ["Chạy tác vụ sẵn sàng đầu tiên theo thứ tự này."]="Runs the first ready task in this order.",
    ["Ưu tiên 1"]="Priority 1", ["Ưu tiên 2"]="Priority 2", ["Ưu tiên 3"]="Priority 3", ["Ưu tiên 4"]="Priority 4",
    ["Pet hiển thị"]="Visual Pet", ["Đang quét..."]="Scanning...",
    ["Làm mới danh sách pet"]="Refresh Pet List", ["Quét"]="Refresh",
    ["Tên tùy chỉnh"]="Custom Name", ["Bán kính xoay"]="Orbit Radius",
    ["Tốc độ xoay"]="Orbit Speed", ["Spawn Pet"]="Spawn Pet", ["Spawn"]="Spawn",
    ["Xóa pet cuối"]="Remove Last Pet", ["Xóa"]="Remove",
    ["Xóa tất cả pet"]="Remove All Pets", ["Xóa hết"]="Remove All",
    ["Tự gộp"]="Auto Fuse",
    ["Tự bán pet (Auto Sell Pet)"]="Auto Sell Pet",
    ["Bật Auto Sell Pet"]="Enable Auto Sell Pet",
    ["Tự động bán pet theo danh sách đã chọn"]="Auto sell pets based on the selected list",
    ["Dùng Whitelist"]="Use Whitelist",
    ["BẬT = chỉ bán pet trong list | TẮT = bán tất cả trừ pet trong list"]="ON = only sell listed pets | OFF = sell all except listed pets",
    ["Giữ pet mạnh nhất mỗi loại"]="Keep strongest pet of each type",
    ["Không bán pet có scale cao nhất của mỗi tên"]="Do not sell the highest scale pet of each name",
    ["Chu kỳ quét"]="Scan Interval",
    ["Danh sách Pet (theo tên)"]="Pet List (by name)",
    ["Danh sách Rarity"]="Rarity List",
    ["Quét lại danh sách Pet"]="Refresh Pet List",
    ["Bán ngay theo danh sách"]="Sell Now by List",
    ["Xoá danh sách chọn"]="Clear Selection",
    ["Tự trang bị pet tốt nhất"]="Auto Equip Best Pets", ["Ẩn pet của mình"]="Hide Own Pet Renders",
    ["Tự gộp pet"]="Auto Fuse Pets", ["Độ hiếm gộp"]="Fuse Rarities",
    ["Biến thể gộp"]="Fuse Mutations", ["Chọn nhóm theo"]="Pick Group By",
    ["Không gộp pet biến thể"]="Never Fuse Mutated", ["Không gộp pet đang trang bị"]="Never Fuse Equipped",
    ["Tự hoàn tất khám phá"]="Auto Complete Reveal",
    ["Scale tối đa để gộp"]="Maximum Scale to Fuse", ["Giữ mỗi loại pet"]="Keep Per Pet Type",
    ["Chu kỳ gộp"]="Fuse Interval", ["Gộp ngay"]="Fuse Now",
    ["Nâng cấp"]="Upgrades", ["Phần thưởng"]="Rewards", ["Trang bị"]="Equipment",
    ["Huấn luyện"]="Training", ["Tự mua nâng cấp"]="Auto Buy Upgrades",
    ["Loại nâng cấp"]="Upgrade Types", ["Tự nhận Index"]="Auto Claim Index",
    ["Tự nhận thưởng nhóm"]="Auto Claim Group Reward", ["Nhận tiền offline"]="Claim Offline Earnings",
    ["Tự mua Trail"]="Auto Buy Trail", ["Trail"]="Trails",
    ["Tự trang bị Trail tốt nhất"]="Auto Equip Best Trail",
    ["Tự trang bị Gear tốt nhất"]="Auto Equip Best Gear",
    ["Tự tập máy chạy"]="Auto Treadmill Training",
    ["Di chuyển"]="Movement", ["Dịch chuyển"]="Teleports",
    ["ESP trứng trên map"]="World Egg ESP", ["ESP trứng đang cầm/thả"]="Carried and Dropped Egg ESP",
    ["ESP bảo vệ"]="Guard ESP", ["ESP pet"]="Pet ESP", ["ESP người chơi"]="Player ESP",
    ["ESP máy"]="Machine ESP", ["ESP khu đất"]="Plot ESP",
    ["Khoảng cách hiển thị"]="Render Distance",
    ["Chỉnh tốc độ chạy"]="Walk Speed Override", ["Tốc độ chạy"]="Walk Speed",
    ["Chỉnh lực nhảy"]="Jump Power Override", ["Lực nhảy"]="Jump Power",
    ["Nhảy vô hạn"]="Infinite Jump", ["Xuyên tường"]="NoClip",
    ["Bay"]="Fly", ["Tốc độ bay"]="Fly Speed",
    ["Điểm đánh dấu"]="Waypoint", ["Dịch chuyển tới điểm"]="Teleport to Waypoint", ["Đi"]="Go",
    ["Nhân vật"]="Character", ["Thế giới"]="World", ["Bypass tốc độ"]="Speed Bypass",
    ["Chống bẫy"]="Anti Trap", ["Chống ragdoll"]="Anti-Ragdoll",
    ["Tự đứng dậy khi bị hất tung"]="Auto get up when knocked down",
    ["Tương tác tức thì"]="Instant Interact",
    ["Bỏ qua thời gian giữ nút"]="Skip hold duration for prompts",
    ["Chuyển hướng vận tốc khi bị ném"]="Redirect velocity to camera when thrown",
    ["Giảm lag (Clay)"]="Fix Lag (Clay)",
    ["Xóa cây cối + SmoothPlastic"]="Remove foliage + SmoothPlastic",
    ["Chống bẫy (Xóa)"]="Anti Trap (Delete)",
    ["Vô hiệu hóa & ẩn bẫy"]="Disable & hide traps",
    ["Đổi server ít người (1-5)"]="Hop Low-Pop Server (1-5 players)",
    ["Giá trị tốc độ"]="Speed Value",
    ["Khóa tốc độ chạy"]="Lock WalkSpeed",
    ["Khóa WalkSpeed mỗi frame"]="Locks WalkSpeed every frame",
    ["Áp dụng Bypass tốc độ"]="Apply Speed Bypass (Clone Humanoid)",
    ["Áp dụng"]="Apply",
    ["Hiệu năng"]="Performance", ["Liên kết"]="Social", ["Thông tin"]="About",
    ["Cài đặt"]="Settings",
    ["Chống AFK"]="Anti-AFK", ["Không tạm dừng gameplay"]="No Gameplay Paused",
    ["Tự kết nối lại"]="Auto Reconnect", ["Vào lại server"]="Rejoin Server", ["Vào"]="Rejoin",
    ["Sao chép script vào server"]="Copy Join Script", ["Copy"]="Copy",
    ["Tăng FPS"]="FPS Boost", ["Tắt render 3D"]="Disable 3D Rendering",
    ["Giới hạn FPS"]="FPS Cap",
    ["Ngôn ngữ / Language"]="Language / Ngôn ngữ",
    ["Sao chép link Discord"]="Copy Discord Link",
    ["Sao chép TikTok ID"]="Copy TikTok ID",
    ["Bật Webhook"]="Enable Webhooks",
    ["URL Webhook"]="Webhook URL", ["ID người nhận ping"]="Ping User ID",
    ["Chu kỳ tổng kết"]="Summary Interval",
    ["Liệt kê trứng đã spawn"]="List Spawned Eggs",
    ["Cảnh báo mất kết nối"]="Disconnect Alerts",
    ["Gửi tổng kết ngay"]="Send Summary Now", ["Gửi"]="Send",
    ["Nhà phát triển"]="Script Dev", ["Giao diện"]="UI",
    ["Khu vực nguy hiểm"]="Danger Zone",
    ["Tắt script"]="Unload Script", ["Tắt"]="Unload",
    ["Có"]="Yes", ["Không"]="No",
    ["Tiếng Việt"]="Tiếng Việt",
}

local EN_TO_VI = {}
for vi, en in pairs(VI_TO_EN) do EN_TO_VI[en] = vi end

local function translateText(text, targetLang)
    if type(text) ~= "string" then return text end
    if targetLang == "en" then
        return VI_TO_EN[text] or text
    else
        return EN_TO_VI[text] or text
    end
end

local function applyLanguageToUI()
    if not screenGui then return end
    for _, obj in ipairs(screenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local orig = obj:GetAttribute("ZenVI")
            if orig then
                pcall(function() obj.Text = translateText(orig, LANG.Current) end)
            end
        end
    end
end

local LANG_PAIRS = {
    ready        = { vi = "Sẵn sàng - ấn avatar để mở",  en = "Ready - press avatar to open" },
    langChanged  = { vi = "Ngôn ngữ: Tiếng Việt",        en = "Language: English" },
    discordCopy  = { vi = "Đã sao chép link Discord",     en = "Discord link copied" },
    tiktokCopy   = { vi = "Đã sao chép TikTok ID: " .. TIKTOK_ID, en = "TikTok ID copied: " .. TIKTOK_ID },
    baseMissing  = { vi = "Không tìm thấy căn cứ",         en = "Base unavailable" },
    voidDrop     = { vi = "Đã thả xuống Void",             en = "Dropped to void" },
    charMissing  = { vi = "Không tìm thấy nhân vật",       en = "No character" },
    hopSuccess   = { vi = "Đang chuyển sang server ít người", en = "Hopping to low-pop server" },
    hopFail      = { vi = "Không tìm thấy server ít người", en = "No low-pop server found" },
    hopNoList    = { vi = "Không lấy được danh sách server", en = "Server list unavailable" },
    visualNoPet  = { vi = "Không tìm thấy pet: ",           en = "Pet not found: " },
    visualFound  = { vi = "Đã tìm thấy ",                   en = "Found " },
    visualPets   = { vi = " pet.",                          en = " pets." },
    visualSpawn  = { vi = "Đã spawn ",                      en = "Spawned " },
    visualSpawn2 = { vi = " (chỉ client).",                 en = " (client only)." },
    visualNoScan = { vi = "Chưa tìm thấy model pet.",       en = "No pet model found." },
    visualPick   = { vi = "Hãy chọn hoặc nhập tên pet.",    en = "Select or type a pet name." },
    speedOk      = { vi = "Đã bypass ",                     en = "Bypass " },
    speedApplied = { vi = " thành công",                    en = " applied" },
    speedFail    = { vi = "Thất bại",                       en = "Failed" },
    webhookSent  = { vi = "Đã gửi",                         en = "Sent" },
    webhookFail  = { vi = "Thất bại",                       en = "Failed" },
    waypointBad  = { vi = "Không khả dụng",                 en = "Unavailable" },
    waypointFail = { vi = "Thất bại",                       en = "Failed" },
    copied       = { vi = "Đã sao chép",                    en = "Copied" },
    scriptCopied = { vi = "Đã sao chép script vào server", en = "Join script copied" },
    petSellOn    = { vi = "Đã bật. Quét pet mỗi ",         en = "Enabled. Scanning every " },
    petSellOn2   = { vi = "s.",                              en = "s." },
    petSellOff   = { vi = "Đã tắt.",                         en = "Disabled." },
    petSellNone  = { vi = "Không tìm thấy pet nào.",         en = "No pets found." },
    petSellScanned = { vi = "Đã quét ",                       en = "Scanned " },
    petSellScanned2 = { vi = " loại pet.",                    en = " pet types." },
    petSellCleared = { vi = "Đã xoá danh sách.",              en = "Selection cleared." },
}
local function L(key)
    local p = LANG_PAIRS[key]
    if not p then return key end
    return p[LANG.Current] or p.vi or key
end

local function getGuiParent()
    if gethui then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    return CoreGui
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZenHubXGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 9999
screenGui.Parent = getGuiParent()

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ZenHubXToggle"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.DisplayOrder = 9998
toggleGui.Parent = getGuiParent()

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.fromOffset(52, 52)
toggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 190)
toggleBtn.BackgroundTransparency = 0.05
toggleBtn.BorderSizePixel = 0
toggleBtn.Image = "rbxassetid://72639013832251"
toggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.ScaleType = Enum.ScaleType.Crop
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Draggable = false
toggleBtn.Parent = toggleGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Color = Color3.fromRGB(210, 160, 255)
toggleStroke.Transparency = 0.15
toggleStroke.Parent = toggleBtn

local PANEL_W, PANEL_H = 480, 340
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
panel.BackgroundColor3 = COLORS.panelBg
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Active = true
panel.Draggable = false
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner"); panelCorner.CornerRadius = UDim.new(0, 12); panelCorner.Parent = panel
local panelStroke = Instance.new("UIStroke"); panelStroke.Thickness = 1.5; panelStroke.Color = COLORS.panelBorder; panelStroke.Transparency = 0.15; panelStroke.Parent = panel

local function addCorner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 6); c.Parent = parent; return c
end
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color or COLORS.panelBorder
    s.Thickness = thickness or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s
end

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = COLORS.panelBg2
header.BackgroundTransparency = 0.05
header.BorderSizePixel = 0
header.Parent = panel
addCorner(header, 12)

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = COLORS.panelBorder
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 5)
title.Size = UDim2.new(0, 240, 0, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = COLORS.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = HEADER_TEXT
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(16, 24)
subtitle.Size = UDim2.new(0, 320, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextColor3 = COLORS.textDim
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = SUBTITLE
subtitle.Parent = header

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.fromOffset(84, 22)
discordBtn.Position = UDim2.new(1, -152, 0, 11)
discordBtn.BackgroundColor3 = Color3.fromRGB(72, 48, 105)
discordBtn.BackgroundTransparency = 0.15
discordBtn.BorderSizePixel = 0
discordBtn.AutoButtonColor = false
discordBtn.Font = Enum.Font.GothamSemibold
discordBtn.TextSize = 11
discordBtn.TextColor3 = COLORS.text
discordBtn.Text = "Discord"
discordBtn.Parent = header
addCorner(discordBtn, 5)
addStroke(discordBtn, Color3.fromRGB(110, 80, 155), 1)
discordBtn.MouseEnter:Connect(function() TweenService:Create(discordBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play() end)
discordBtn.MouseLeave:Connect(function() TweenService:Create(discordBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play() end)
discordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end)
    H.notify("ZenHubX", L("discordCopy"), "Success", 3)
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(24, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(52, 26, 72)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = COLORS.text
closeBtn.Text = "X"
closeBtn.Parent = header
addCorner(closeBtn, 5)
addStroke(closeBtn, Color3.fromRGB(120, 60, 160), 1)
closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(85, 40, 115), BackgroundTransparency = 0 }):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 26, 72), BackgroundTransparency = 0.2 }):Play() end)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

local SIDEBAR_W = 120
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 44)
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -44)
sidebar.BackgroundColor3 = COLORS.sidebarBg
sidebar.BackgroundTransparency = 0.1
sidebar.BorderSizePixel = 0
sidebar.Parent = panel

local sidebarScroll = Instance.new("ScrollingFrame")
sidebarScroll.BackgroundTransparency = 1
sidebarScroll.BorderSizePixel = 0
sidebarScroll.Size = UDim2.new(1, 0, 1, 0)
sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebarScroll.ScrollBarThickness = 3
sidebarScroll.ScrollBarImageColor3 = COLORS.accent
sidebarScroll.Parent = sidebar

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 3)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Parent = sidebarScroll

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 8)
sidebarPad.PaddingLeft = UDim.new(0, 6)
sidebarPad.PaddingRight = UDim.new(0, 6)
sidebarPad.Parent = sidebarScroll

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(SIDEBAR_W + 8, 52)
content.Size = UDim2.new(1, -(SIDEBAR_W + 16), 1, -60)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.Parent = panel

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.ScrollBarThickness = 4
contentScroll.ScrollBarImageColor3 = COLORS.accent
contentScroll.Parent = content

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 8)
contentList.SortOrder = Enum.SortOrder.LayoutOrder
contentList.Parent = contentScroll

local contentPad = Instance.new("UIPadding")
contentPad.PaddingRight = UDim.new(0, 6)
contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.Parent = contentScroll

local function makeDraggable(frame, dragArea)
    dragArea = dragArea or frame
    local dragging, dragStart, startPos = false, nil, nil
    conn(dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
end
makeDraggable(panel, header)

do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    conn(toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = toggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
            toggleBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
    conn(toggleBtn.MouseButton1Click:Connect(function()
        if moved then return end
        panel.Visible = not panel.Visible
    end))
    conn(toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(230, 180, 255), Transparency = 0 }):Play()
    end))
    conn(toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.05 }):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(210, 160, 255), Transparency = 0.15 }):Play()
    end))
end

function UI.GetState(id) return UI.__state[id] end
function UI.SetState(id, value, fire)
    UI.__state[id] = value
    if fire and UI.__callbacks[id] then
        for _, cb in ipairs(UI.__callbacks[id]) do pcall(cb, value) end
    end
end
function UI.OnChange(id, callback)
    UI.__callbacks[id] = UI.__callbacks[id] or {}
    table.insert(UI.__callbacks[id], callback)
end

function H.getState(id, fallback)
    local v = UI.GetState(id)
    if v ~= nil then return v end
    return fallback
end
function H.isOn(id) return UI.GetState(id) == true end
function H.optionValue(id, fallback)
    local v = UI.GetState(id)
    if v == nil then return fallback end
    return v
end
function H.multiSelected(id)
    local value = UI.GetState(id)
    local selected = {}
    if typeof(value) ~= "table" then
        if typeof(value) == "string" and value ~= "" then selected[value] = true end
        return selected
    end
    for key, item in pairs(value) do
        if item == true then selected[key] = true
        elseif typeof(key) == "number" and typeof(item) == "string" then selected[item] = true end
    end
    return selected
end
function H.multiHasAny(id) return next(H.multiSelected(id)) ~= nil end
function H.selectionAllows(id, value)
    if not H.multiHasAny(id) then return true end
    return H.multiSelected(id)[value] == true
end
function H.matchesMutationFilter(optionName, asset)
    if not H.multiHasAny(optionName) then return true end
    local selected = H.multiSelected(optionName)
    for _, mutation in ipairs(H.recordMutations(asset)) do
        if selected[mutation] then return true end
    end
    return false
end
function H.matchesEggFilters(egg, areaOptionName, rarityOptionName, mutationOptionName)
    if areaOptionName then
        local areaId = egg.AreaId
        if typeof(areaId) ~= "string" or not H.selectionAllows(areaOptionName, areaId) then return false end
    end
    local rarity = H.resolveRarity(egg.AssetCategory)
    if typeof(rarity) ~= "string" or not H.selectionAllows(rarityOptionName, rarity) then return false end
    return H.matchesMutationFilter(mutationOptionName, egg)
end

local function makeTabButton(tabId, tabTitle)
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. tabId
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = COLORS.sectionBg
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = COLORS.textDim
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = tabTitle
    btn.Parent = sidebarScroll
    addCorner(btn, 5)
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 10); pad.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = COLORS.accent
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    addCorner(indicator, 2)

    local function setActive(active)
        if active then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 26, 60), BackgroundTransparency = 0.2 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = COLORS.text }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), { Size = UDim2.new(0, 3, 0.7, 0) }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.sectionBg, BackgroundTransparency = 0.5 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = COLORS.textDim }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), { Size = UDim2.new(0, 3, 0, 0) }):Play()
        end
    end
    btn.MouseEnter:Connect(function()
        if UI.__activeTab ~= tabId then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = COLORS.text }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if UI.__activeTab ~= tabId then setActive(false) end
    end)
    return btn, setActive
end

function UI.AddTab(opts)
    local id = opts.Id
    local btn, setActive = makeTabButton(id, opts.Title)
    local page = Instance.new("ScrollingFrame")
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = COLORS.accent
    page.Visible = false
    page.Parent = contentScroll
    local pageList = Instance.new("UIListLayout")
    pageList.Padding = UDim.new(0, 8)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = page
    local pagePad = Instance.new("UIPadding"); pagePad.PaddingRight = UDim.new(0, 6); pagePad.Parent = page

    local tab = { Id = id, Page = page, Button = btn, SetActive = setActive }
    btn.MouseButton1Click:Connect(function()
        if UI.__activeTab == id then return end
        for tid, other in pairs(UI.__tabs) do
            other.Page.Visible = (tid == id)
            other.SetActive(tid == id)
        end
        UI.__activeTab = id
    end)
    UI.__tabs[id] = tab
    if not UI.__activeTab then
        UI.__activeTab = id
        page.Visible = true
        setActive(true)
    end
    return tab
end

function UI.AddSection(tab, opts)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = COLORS.sectionBg
    section.BackgroundTransparency = 0.35
    section.BorderSizePixel = 0
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = tab.Page
    addCorner(section, 6)
    addStroke(section, COLORS.sectionBorder, 1)
    local sectionList = Instance.new("UIListLayout")
    sectionList.Padding = UDim.new(0, 5)
    sectionList.SortOrder = Enum.SortOrder.LayoutOrder
    sectionList.Parent = section
    local sectionPad = Instance.new("UIPadding")
    sectionPad.PaddingTop = UDim.new(0, 8)
    sectionPad.PaddingBottom = UDim.new(0, 8)
    sectionPad.PaddingLeft = UDim.new(0, 10)
    sectionPad.PaddingRight = UDim.new(0, 10)
    sectionPad.Parent = section

    if opts.Title then
        local h = Instance.new("TextLabel")
        h.BackgroundTransparency = 1
        h.Size = UDim2.new(1, 0, 0, 18)
        h.Font = Enum.Font.GothamBold
        h.TextSize = 12
        h.TextColor3 = COLORS.text
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.Text = opts.Title
        h.Parent = section
    end
    if opts.Description then
        local d = Instance.new("TextLabel")
        d.BackgroundTransparency = 1
        d.Size = UDim2.new(1, 0, 0, 14)
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextColor3 = COLORS.textMuted
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextWrapped = true
        d.Text = opts.Description
        d.Parent = section
    end
    return section
end

local function makeRow(parent, height)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = COLORS.panelBg2
    row.BackgroundTransparency = 0.4
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, height or 28)
    row.Parent = parent
    addCorner(row, 5)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = row
    return row
end

function UI.AddToggle(parent, opts)
    local row = makeRow(parent, 32)
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Size = UDim2.new(1, -55, 0, 18)
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 12
    name.TextColor3 = COLORS.text
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Text = opts.Title or "Toggle"
    name.Parent = row
    if opts.Description then
        local d = Instance.new("TextLabel")
        d.BackgroundTransparency = 1
        d.Position = UDim2.fromOffset(0, 17)
        d.Size = UDim2.new(1, -55, 0, 12)
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextColor3 = COLORS.textMuted
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Text = opts.Description
        d.Parent = row
    end
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(36, 20)
    switch.Position = UDim2.new(1, -36, 0.5, -10)
    switch.BackgroundColor3 = COLORS.toggleOff
    switch.BorderSizePixel = 0
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row
    addCorner(switch, 10)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = COLORS.text
    knob.BorderSizePixel = 0
    knob.Parent = switch
    addCorner(knob, 8)
    local state = opts.Default == true
    local function render(animate)
        local info = TweenInfo.new(animate and 0.18 or 0)
        TweenService:Create(switch, info, { BackgroundColor3 = state and COLORS.toggleOn or COLORS.toggleOff }):Play()
        TweenService:Create(knob, info, { Position = state and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2) }):Play()
    end
    render(false)
    UI.__state[opts.Id] = state
    switch.MouseButton1Click:Connect(function()
        state = not state
        UI.SetState(opts.Id, state, true)
        render(true)
        if opts.Callback then pcall(opts.Callback, state) end
    end)
    return switch
end

function UI.AddSlider(parent, opts)
    local row = makeRow(parent, 40)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Slider"
    label.Parent = row
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -70, 0, 0)
    valueLabel.Size = UDim2.fromOffset(70, 18)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextColor3 = COLORS.accentHi
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row
    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0, 24)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.BackgroundColor3 = COLORS.toggleOff
    bar.BorderSizePixel = 0
    bar.Parent = row
    addCorner(bar, 3)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    addCorner(fill, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(12, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = COLORS.text
    knob.BorderSizePixel = 0
    knob.Parent = bar
    addCorner(knob, 6)
    local minV, maxV, stepV = opts.Min or 0, opts.Max or 100, opts.Step or 1
    local suffix = opts.Suffix or ""
    local value = tonumber(opts.Default) or minV
    UI.__state[opts.Id] = value
    local function render()
        local alpha = (value - minV) / math.max(0.0001, (maxV - minV))
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = tostring(value) .. suffix
    end
    render()
    local dragging = false
    local function updateFromX(x)
        local absX = bar.AbsolutePosition.X
        local absW = bar.AbsoluteSize.X
        local alpha = math.clamp((x - absX) / math.max(1, absW), 0, 1)
        local raw = minV + alpha * (maxV - minV)
        local snapped = math.floor((raw - minV) / stepV + 0.5) * stepV + minV
        snapped = math.clamp(snapped, minV, maxV)
        if snapped ~= value then
            value = snapped
            UI.SetState(opts.Id, value, true)
            render()
            if opts.Callback then pcall(opts.Callback, value) end
        end
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end))
    conn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    return bar
end

-- ============================================================
-- UI.AddDropdown (Patched - supports SetOptions / Refresh / Set)
-- ============================================================
function UI.AddDropdown(parent, opts)
    local isMulti = opts.Multi == true
    local row = makeRow(parent, 30)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Dropdown"
    label.Parent = row
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -190, 0, 0)
    valueLabel.Size = UDim2.fromOffset(155, 30)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 11
    valueLabel.TextColor3 = COLORS.textDim
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
    valueLabel.Parent = row
    local arrowBtn = Instance.new("TextButton")
    arrowBtn.Size = UDim2.fromOffset(26, 22)
    arrowBtn.Position = UDim2.new(1, -30, 0.5, -11)
    arrowBtn.BackgroundColor3 = COLORS.toggleOff
    arrowBtn.BackgroundTransparency = 0.4
    arrowBtn.BorderSizePixel = 0
    arrowBtn.AutoButtonColor = false
    arrowBtn.Font = Enum.Font.GothamBold
    arrowBtn.TextSize = 11
    arrowBtn.TextColor3 = COLORS.text
    arrowBtn.Text = "v"
    arrowBtn.Parent = row
    addCorner(arrowBtn, 4)

    local dropdown = Instance.new("Frame")
    dropdown.BackgroundColor3 = COLORS.panelBg2
    dropdown.BorderSizePixel = 0
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.AutomaticSize = Enum.AutomaticSize.Y
    dropdown.Visible = false
    dropdown.Parent = parent
    addCorner(dropdown, 5)
    addStroke(dropdown, COLORS.panelBorder, 1)
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownList.Parent = dropdown
    local dropdownPad = Instance.new("UIPadding")
    dropdownPad.PaddingTop = UDim.new(0, 4)
    dropdownPad.PaddingBottom = UDim.new(0, 4)
    dropdownPad.PaddingLeft = UDim.new(0, 4)
    dropdownPad.PaddingRight = UDim.new(0, 4)
    dropdownPad.Parent = dropdown

    local selected
    if isMulti then
        selected = {}
        if typeof(opts.Default) == "table" then
            for _, v in ipairs(opts.Default) do selected[v] = true end
        end
        UI.__state[opts.Id] = {}
        for k in pairs(selected) do table.insert(UI.__state[opts.Id], k) end
    else
        selected = opts.Default or (opts.Options and opts.Options[1])
        UI.__state[opts.Id] = selected
    end

    local function updateLabel()
        if isMulti then
            local list = {}
            for k in pairs(selected) do if selected[k] then table.insert(list, k) end end
            table.sort(list)
            if #list == 0 then valueLabel.Text = "All"
            elseif #list <= 2 then valueLabel.Text = table.concat(list, ", ")
            else valueLabel.Text = string.format("%s +%d", list[1], #list - 1) end
        else
            valueLabel.Text = tostring(selected or "")
        end
    end
    updateLabel()

    local entries = {}

    local function addEntry(option)
        local entry = Instance.new("TextButton")
        entry.Size = UDim2.new(1, 0, 0, 22)
        entry.BackgroundColor3 = COLORS.sectionBg
        entry.BackgroundTransparency = 0.6
        entry.BorderSizePixel = 0
        entry.AutoButtonColor = false
        entry.Font = Enum.Font.Gotham
        entry.TextSize = 11
        entry.TextColor3 = COLORS.text
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.Text = "  " .. tostring(option)
        entry.Parent = dropdown
        addCorner(entry, 4)
        entries[option] = entry

        local function refreshColor()
            local active
            if isMulti then active = selected[option] == true
            else active = (selected == option) end
            entry.TextColor3 = active and COLORS.accentHi or COLORS.text
        end
        refreshColor()

        entry.MouseEnter:Connect(function() TweenService:Create(entry, TweenInfo.new(0.12), { BackgroundTransparency = 0.3 }):Play() end)
        entry.MouseLeave:Connect(function()
            TweenService:Create(entry, TweenInfo.new(0.12), { BackgroundTransparency = 0.6 }):Play()
            refreshColor()
        end)
        entry.MouseButton1Click:Connect(function()
            if isMulti then
                selected[option] = not selected[option]
                local list = {}
                for k, v in pairs(selected) do if v then table.insert(list, k) end end
                UI.SetState(opts.Id, list, true)
            else
                selected = option
                UI.SetState(opts.Id, selected, true)
            end
            for optName, e in pairs(entries) do
                local active = isMulti and selected[optName] == true or (not isMulti and selected == optName)
                e.TextColor3 = active and COLORS.accentHi or COLORS.text
            end
            updateLabel()
            if opts.Callback then pcall(opts.Callback, UI.__state[opts.Id]) end
            if not isMulti then
                dropdown.Visible = false
                arrowBtn.Text = "v"
            end
        end)
    end

    for _, option in ipairs(opts.Options or {}) do
        addEntry(option)
    end

    arrowBtn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
        arrowBtn.Text = dropdown.Visible and "^" or "v"
    end)

    -- API for dynamic refresh
    local api = { Button = arrowBtn }
    function api:SetOptions(newOptions)
        for _, entry in pairs(entries) do pcall(function() entry:Destroy() end) end
        for k in pairs(entries) do entries[k] = nil end
        for _, option in ipairs(newOptions or {}) do addEntry(option) end
    end
    function api:Refresh(newOptions)
        api:SetOptions(newOptions or opts.Options or {})
    end
    function api:Set(newSelected)
        if isMulti then
            selected = {}
            if type(newSelected) == "table" then
                for k, v in pairs(newSelected) do
                    if v == true then selected[k] = true end
                end
            end
        else
            selected = newSelected
        end
        UI.SetState(opts.Id, selected, true)
        for optName, e in pairs(entries) do
            local active = isMulti and selected[optName] == true or (not isMulti and selected == optName)
            e.TextColor3 = active and COLORS.accentHi or COLORS.text
        end
        updateLabel()
    end
    return api
end

function UI.AddButton(parent, opts)
    local row = makeRow(parent, 30)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextColor3 = COLORS.text
    btn.Text = opts.Title or "Button"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = row
    local action = Instance.new("TextLabel")
    action.BackgroundColor3 = COLORS.accent
    action.BackgroundTransparency = 0.2
    action.Size = UDim2.fromOffset(62, 22)
    action.Position = UDim2.new(1, -62, 0.5, -11)
    action.Font = Enum.Font.GothamBold
    action.TextSize = 11
    action.TextColor3 = COLORS.text
    action.Text = opts.Text or "Run"
    action.Parent = row
    addCorner(action, 4)
    btn.MouseEnter:Connect(function() TweenService:Create(action, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(action, TweenInfo.new(0.12), { BackgroundTransparency = 0.2 }):Play() end)
    btn.MouseButton1Click:Connect(function()
        if opts.Callback then pcall(opts.Callback) end
    end)
    return btn
end

function UI.AddParagraph(parent, opts)
    local row = makeRow(parent, 40)
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = COLORS.text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = opts.Title or ""
    title.Parent = row
    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(0, 16)
    body.Size = UDim2.new(1, 0, 0, 24)
    body.Font = Enum.Font.Gotham
    body.TextSize = 10
    body.TextColor3 = COLORS.textDim
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.Text = opts.Content or ""
    body.Parent = row
    return row
end

function UI.AddDivider(parent, opts)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 10)
    holder.Parent = parent
    local line = Instance.new("Frame")
    line.BackgroundColor3 = COLORS.panelBorder
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Parent = holder
    if opts and opts.Title then
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextColor3 = COLORS.textMuted
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.Text = opts.Title
        lbl.Parent = holder
    end
    return holder
end

function UI.AddStatus(parent, opts)
    local row = makeRow(parent, 24)
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Size = UDim2.new(0.6, 0, 1, 0)
    name.Font = Enum.Font.Gotham
    name.TextSize = 11
    name.TextColor3 = COLORS.textDim
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Text = opts.Title or "Status"
    name.Parent = row
    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Size = UDim2.new(0.4, 0, 1, 0)
    value.Position = UDim2.fromScale(0.6, 0)
    value.Font = Enum.Font.GothamBold
    value.TextSize = 11
    value.TextColor3 = COLORS.text
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Text = tostring(opts.Value or "")
    value.Parent = row
    local api = {}
    function api.SetValue(v) value.Text = tostring(v) end
    function api.SetStatus(status)
        if status == "Success" then value.TextColor3 = COLORS.success
        elseif status == "Warning" then value.TextColor3 = COLORS.warning
        elseif status == "Error" then value.TextColor3 = COLORS.error
        elseif status == "Info" then value.TextColor3 = COLORS.info
        else value.TextColor3 = COLORS.text end
    end
    return api
end

function UI.AddInput(parent, opts)
    local row = makeRow(parent, 30)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Input"
    label.Parent = row
    local box = Instance.new("TextBox")
    box.BackgroundColor3 = COLORS.toggleOff
    box.BackgroundTransparency = 0.2
    box.BorderSizePixel = 0
    box.Position = UDim2.fromScale(0.42, 0.5)
    box.AnchorPoint = Vector2.new(0, 0.5)
    box.Size = UDim2.new(0.58, -10, 0, 22)
    box.Font = Enum.Font.Gotham
    box.TextSize = 11
    box.TextColor3 = COLORS.text
    box.PlaceholderColor3 = COLORS.textMuted
    box.PlaceholderText = opts.Placeholder or ""
    box.Text = tostring(opts.Default or "")
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = row
    addCorner(box, 4)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = box
    UI.__state[opts.Id] = box.Text
    box.FocusLost:Connect(function()
        UI.SetState(opts.Id, box.Text, true)
        if opts.Callback then pcall(opts.Callback, box.Text) end
    end)
    return box
end

local NotifyHolder = Instance.new("Frame")
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.AnchorPoint = Vector2.new(1, 1)
NotifyHolder.Position = UDim2.new(1, -16, 1, -16)
NotifyHolder.Size = UDim2.fromOffset(260, 380)
NotifyHolder.Parent = screenGui
local NotifyList = Instance.new("UIListLayout")
NotifyList.Padding = UDim.new(0, 6)
NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifyList.Parent = NotifyHolder

function H.notify(title, content, variant, duration)
    local note = Instance.new("Frame")
    note.BackgroundColor3 = COLORS.panelBg
    note.BackgroundTransparency = 0.05
    note.BorderSizePixel = 0
    note.Size = UDim2.fromOffset(250, 50)
    note.Parent = NotifyHolder
    addCorner(note, 8)
    local strokeColor = COLORS.panelBorderHi
    if variant == "Success" then strokeColor = COLORS.success
    elseif variant == "Warning" then strokeColor = COLORS.warning
    elseif variant == "Error" then strokeColor = COLORS.error
    elseif variant == "Info" then strokeColor = COLORS.info end
    addStroke(note, strokeColor, 1.5)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(12, 6)
    t.Size = UDim2.new(1, -24, 0, 18)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = strokeColor
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = tostring(title or "ZenHubX")
    t.Parent = note
    local c = Instance.new("TextLabel")
    c.BackgroundTransparency = 1
    c.Position = UDim2.fromOffset(12, 22)
    c.Size = UDim2.new(1, -24, 0, 22)
    c.Font = Enum.Font.Gotham
    c.TextSize = 10
    c.TextColor3 = COLORS.textDim
    c.TextXAlignment = Enum.TextXAlignment.Left
    c.TextWrapped = true
    c.TextYAlignment = Enum.TextYAlignment.Top
    c.Text = tostring(content or "")
    c.Parent = note
    task.delay(tonumber(duration) or 3, function()
        local info = TweenInfo.new(0.25)
        TweenService:Create(note, info, { BackgroundTransparency = 1 }):Play()
        for _, d in ipairs(note:GetDescendants()) do
            if d:IsA("TextLabel") then TweenService:Create(d, info, { TextTransparency = 1 }):Play()
            elseif d:IsA("UIStroke") then TweenService:Create(d, info, { Transparency = 1 }):Play() end
        end
        task.wait(0.3)
        note:Destroy()
    end)
    return note
end

-- ============================================================
-- BUILD UI
-- ============================================================
local refs = {}

do
    local HomeTab = UI.AddTab({ Id = "home", Title = "Trang chủ" })
    local SessionSec = UI.AddSection(HomeTab, { Title = "Phiên", Description = "Trạng thái trực tiếp" })
    local AccountSec = UI.AddSection(HomeTab, { Title = "Tài khoản", Description = "Dữ liệu save" })
    local QuickSec = UI.AddSection(HomeTab, { Title = "Thao tác nhanh" })

    refs.statusRow = UI.AddStatus(SessionSec, { Title = "Tự động hóa", Value = "Sẵn sàng" })
    refs.statusRow:SetStatus("Success")
    refs.jobRow = UI.AddStatus(SessionSec, { Title = "Tác vụ hiện tại", Value = "Rảnh" })
    refs.stolenRow = UI.AddStatus(SessionSec, { Title = "Trứng đã trộm", Value = "0" })
    refs.carryingRow = UI.AddStatus(SessionSec, { Title = "Đang mang trứng", Value = "Không" })
    refs.runtimeRow = UI.AddStatus(SessionSec, { Title = "Thời gian chạy", Value = "0 phút" })
    UI.AddStatus(SessionSec, { Title = "Server", Value = DisplayJobId })

    refs.inventoryProgress = UI.AddStatus(AccountSec, { Title = "Kho trứng", Value = tostring(H.eggInventoryCount()) })
    refs.moneyRow = UI.AddStatus(AccountSec, { Title = "Tiền", Value = "0" })
    refs.speedRow = UI.AddStatus(AccountSec, { Title = "Sức mạnh tốc độ", Value = "0" })
    refs.rebirthRow = UI.AddStatus(AccountSec, { Title = "Tái sinh", Value = "0" })
    refs.petsOwnedRow = UI.AddStatus(AccountSec, { Title = "Pet sở hữu", Value = "0" })

    UI.AddButton(QuickSec, { Title = "Về căn cứ", Text = "Về", Callback = function()
        task.spawn(function()
            if not H.getBasePosition() or not H.returnToBaseBypass(nil) then
                H.notify("Về căn cứ", L("baseMissing"), "Warning", 3)
            end
        end)
    end })
    UI.AddButton(QuickSec, { Title = "Đặt trứng", Text = "Đặt", Callback = function()
        task.spawn(function() H.runAutoPlaceEggs(true) end)
    end })
    UI.AddButton(QuickSec, { Title = "Đổi server", Text = "Đổi", Callback = function()
        task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Thủ công") end)
    end })
    UI.AddButton(QuickSec, { Title = "Gộp pet ngay", Text = "Gộp", Callback = function()
        task.spawn(function() H.runAutoFusePets(true) end)
    end })
    UI.AddButton(QuickSec, { Title = "Về Void (Reset nhanh)", Text = "Void", Callback = function()
        task.spawn(function()
            if ExtrasState.VoidReset() then
                H.notify("Void", L("voidDrop"), "Success", 3)
            else
                H.notify("Void", L("charMissing"), "Error", 3)
            end
        end)
    end })

    local FarmTab = UI.AddTab({ Id = "farm", Title = "Farm" })
    local StealSec = UI.AddSection(FarmTab, { Title = "Trộm trứng", Description = "Farm trứng chính" })
    local PromptSec = UI.AddSection(FarmTab, { Title = "Trộm trứng (Prompt)", Description = "Phương pháp tương tác ProximityPrompt" })
    local LifeSec = UI.AddSection(FarmTab, { Title = "Xử lý trứng" })
    local ServerSec = UI.AddSection(FarmTab, { Title = "Đổi server" })
    local PrioritySec = UI.AddSection(FarmTab, { Title = "Thứ tự tác vụ" })

    UI.AddToggle(StealSec, { Id = "AutoStealSelected", Title = "Tự trộm mục đã chọn", Description = "Dùng bộ lọc bên dưới", Default = false })
    UI.AddToggle(StealSec, { Id = "AutoStealAll", Title = "Tự trộm tất cả", Description = "Bỏ qua độ hiếm/biến thể", Default = false })
    UI.AddToggle(StealSec, { Id = "StealBigEggs", Title = "Trộm trứng lớn", Default = false })
    UI.AddDivider(StealSec, { Title = "Bộ lọc mục tiêu" })
    UI.AddDropdown(StealSec, { Id = "StealZones", Title = "Khu vực", Options = AreaNames, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealRarities", Title = "Độ hiếm", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealMutations", Title = "Biến thể", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealPriority", Title = "Ưu tiên mục tiêu", Options = STEAL_PRIORITIES, Default = "Rarest" })
    UI.AddSlider(StealSec, { Id = "StealBigEggScale", Title = "Kích thước trứng lớn tối thiểu", Min = 1, Max = 50, Default = 1.5, Step = 0.1, Suffix = "x" })
    UI.AddDivider(StealSec, { Title = "Hành vi mang trứng" })
    UI.AddToggle(StealSec, { Id = "AutoReturn", Title = "Tự về căn cứ", Default = true })
    UI.AddToggle(StealSec, { Id = "AutoDropEgg", Title = "Tự thả trứng đang cầm", Default = false })

    UI.AddToggle(PromptSec, { Id = "PromptAutoSteal", Title = "Tự trộm (ProximityPrompt)",
        Description = "Tự bấm ProximityPrompt tầm xa 35 studs", Default = false,
        Callback = function(v) ExtrasState.PromptAutoSteal = v end })

    UI.AddToggle(LifeSec, { Id = "AutoPlaceSelected", Title = "Tự đặt mục đã chọn", Default = false })
    UI.AddToggle(LifeSec, { Id = "AutoPlaceAll", Title = "Tự đặt tất cả", Default = false })
    UI.AddToggle(LifeSec, { Id = "AutoOpenReadyEggs", Title = "Tự ấp trứng sẵn sàng", Default = false })
    UI.AddDropdown(LifeSec, { Id = "LifecycleRarities", Title = "Độ hiếm vòng đời", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(LifeSec, { Id = "LifecycleMutations", Title = "Biến thể vòng đời", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDivider(LifeSec, { Title = "Bán trứng" })
    UI.AddToggle(LifeSec, { Id = "AutoSellEggs", Title = "Tự bán trứng", Default = false })
    UI.AddDropdown(LifeSec, { Id = "SellEggRarities", Title = "Độ hiếm bán", Options = RARITIES, Multi = true, Default = {} })
    UI.AddSlider(LifeSec, { Id = "SellEggInterval", Title = "Chu kỳ bán", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " giây" })

    UI.AddToggle(ServerSec, { Id = "AutoServerHop", Title = "Tự đổi server", Default = false })
    UI.AddDropdown(ServerSec, { Id = "HopMode", Title = "Đổi server khi", Options = ServerHopModes, Default = "No Matching Eggs" })
    UI.AddSlider(ServerSec, { Id = "HopValue", Title = "Chờ trước khi đổi", Min = 1, Max = 200, Default = 15, Step = 1 })
    UI.AddButton(ServerSec, { Title = "Đổi server ngay", Text = "Đổi", Callback = function()
        task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Thủ công") end)
    end })
    UI.AddButton(ServerSec, { Title = "Mở GUI đổi server chi tiết", Text = "Mở", Callback = function()
        H.openServerHopGUI()
    end })

    UI.AddParagraph(PrioritySec, { Content = "Chạy tác vụ sẵn sàng đầu tiên theo thứ tự này." })
    for i, name in ipairs(PrioritySlotOptionNames) do
        UI.AddDropdown(PrioritySec, { Id = name, Title = "Ưu tiên " .. i, Options = PriorityTaskNames, Default = PriorityTaskNames[i] })
    end

    local PetsTab = UI.AddTab({ Id = "pets", Title = "Pet" })
    local PetsOverview = UI.AddSection(PetsTab, { Title = "Pet" })

    local VisualPetState = { spawned = {}, inputName = "", orbitRadius = 4, orbitSpeed = 0.2 }
    local VisualPetFolder = Instance.new("Folder")
    VisualPetFolder.Name = "ZenHubXVisualPets"
    VisualPetFolder.Parent = Workspace

    local function scanVisualPetNames()
        local names, seen = {}, {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and not obj:IsDescendantOf(VisualPetFolder) then
                local n = obj.Name:lower()
                local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                if not n:find("egg") and not n:find("humanoid")
                    and obj:FindFirstChildWhichIsA("BasePart", true)
                    and (parentName:find("pet") or parentName:find("pen") or parentName:find("render")
                        or parentName:find("slot") or obj:FindFirstChildWhichIsA("AnimationController", true)) then
                    if not seen[obj.Name] then seen[obj.Name] = true; table.insert(names, obj.Name) end
                end
            end
        end
        table.sort(names)
        return names
    end

    local function findVisualPet(name)
        local q = tostring(name or ""):lower()
        if q == "" then return nil end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and not obj:IsDescendantOf(VisualPetFolder)
                and obj.Name:lower():find(q, 1, true)
                and obj:FindFirstChildWhichIsA("BasePart", true) then
                return obj
            end
        end
        return nil
    end

    local function removeAllVisualPets()
        for _, data in ipairs(VisualPetState.spawned) do
            pcall(function() data.model:Destroy() end)
        end
        VisualPetState.spawned = {}
    end

    local function removeLastVisualPet()
        local data = table.remove(VisualPetState.spawned)
        if data then pcall(function() data.model:Destroy() end) end
    end

    local function spawnVisualPet(name)
        local source = findVisualPet(name)
        if not source then
            H.notify("Visual Pet", L("visualNoPet") .. tostring(name), "Warning", 4)
            return
        end
        local clone = source:Clone()
        for _, obj in ipairs(clone:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CastShadow = false
            end
        end
        clone.Name = "VP_" .. tostring(name)
        clone.Parent = VisualPetFolder
        table.insert(VisualPetState.spawned, { model = clone })
        H.notify("Visual Pet", L("visualSpawn") .. tostring(name) .. L("visualSpawn2"), "Success", 3)
    end

    local VisualPetDropdown = UI.AddDropdown(PetsOverview, {
        Id = "VisualPetName", Title = "Pet hiển thị",
        Options = {"Đang quét..."}, Default = "Đang quét...",
        Callback = function(v)
            if type(v) == "table" then v = next(v) end
            if type(v) == "string" then VisualPetState.inputName = v end
        end
    })
    UI.AddButton(PetsOverview, {
        Title = "Làm mới danh sách pet", Text = "Quét",
        Callback = function()
            local list = scanVisualPetNames()
            if #list == 0 then
                H.notify("Visual Pet", L("visualNoScan"), "Warning", 4)
                return
            end
            pcall(function() VisualPetDropdown:SetOptions(list) end)
            VisualPetState.inputName = list[1]
            UI.SetState("VisualPetName", list[1], true)
            H.notify("Visual Pet", L("visualFound") .. #list .. L("visualPets"), "Success", 3)
        end
    })
    UI.AddInput(PetsOverview, {
        Id = "VisualPetCustomName", Title = "Tên tùy chỉnh",
        Placeholder = "Ví dụ: Dragon", Default = "",
        Callback = function(v) VisualPetState.inputName = v end
    })
    UI.AddSlider(PetsOverview, {
        Id = "VisualPetOrbitRadius", Title = "Bán kính xoay",
        Min = 2, Max = 20, Default = 4, Step = 1,
        Callback = function(v) VisualPetState.orbitRadius = tonumber(v) or 4 end
    })
    UI.AddSlider(PetsOverview, {
        Id = "VisualPetOrbitSpeed", Title = "Tốc độ xoay",
        Min = 0, Max = 10, Default = 1, Step = 1,
        Callback = function(v) VisualPetState.orbitSpeed = (tonumber(v) or 1) * 0.2 end
    })
    UI.AddButton(PetsOverview, {
        Title = "Spawn Pet", Text = "Spawn",
        Callback = function()
            if VisualPetState.inputName == "" or VisualPetState.inputName == "Đang quét..." then
                H.notify("Visual Pet", L("visualPick"), "Warning", 4)
                return
            end
            spawnVisualPet(VisualPetState.inputName)
        end
    })
    UI.AddButton(PetsOverview, { Title = "Xóa pet cuối", Text = "Xóa", Callback = removeLastVisualPet })
    UI.AddButton(PetsOverview, { Title = "Xóa tất cả pet", Text = "Xóa hết", Callback = removeAllVisualPets })

    task.delay(2, function()
        pcall(function()
            local list = scanVisualPetNames()
            if #list > 0 then
                VisualPetDropdown:SetOptions(list)
                VisualPetState.inputName = list[1]
                UI.SetState("VisualPetName", list[1], true)
            end
        end)
    end)

    task.spawn(function()
        while screenGui.Parent do
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local count = #VisualPetState.spawned
            if root and count > 0 then
                local center = root.Position + Vector3.new(0, 1, 0)
                local t = os.clock()
                for i, data in ipairs(VisualPetState.spawned) do
                    if data.model and data.model.Parent then
                        local angle = ((i - 1) * (math.pi * 2 / count)) + t * VisualPetState.orbitSpeed
                        local pos = center + Vector3.new(
                            math.cos(angle) * VisualPetState.orbitRadius,
                            0,
                            math.sin(angle) * VisualPetState.orbitRadius
                        )
                        pcall(function()
                            data.model:PivotTo(CFrame.new(pos) * CFrame.Angles(0, angle + math.pi, 0))
                        end)
                    end
                end
            end
            task.wait()
        end
    end)

    local FuseSec = UI.AddSection(PetsTab, { Title = "Tự gộp" })
    local SellPetSec = UI.AddSection(PetsTab, { Title = "Tự bán pet (Auto Sell Pet)" })

    UI.AddToggle(PetsOverview, { Id = "AutoEquipBest", Title = "Tự trang bị pet tốt nhất", Default = false })
    UI.AddToggle(PetsOverview, { Id = "AutoDeleteOwnPets", Title = "Ẩn pet của mình", Default = false })
    UI.AddToggle(FuseSec, { Id = "AutoFusePets", Title = "Tự gộp pet", Default = false })
    UI.AddDropdown(FuseSec, { Id = "FuseRarities", Title = "Độ hiếm gộp", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(FuseSec, { Id = "FuseMutations", Title = "Biến thể gộp", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDropdown(FuseSec, { Id = "FuseTarget", Title = "Chọn nhóm theo", Options = FUSE_TARGET_MODES, Default = "Highest Rarity" })
    UI.AddToggle(FuseSec, { Id = "FuseKeepMutated", Title = "Không gộp pet biến thể", Default = true })
    UI.AddToggle(FuseSec, { Id = "FuseKeepEquipped", Title = "Không gộp pet đang trang bị", Default = true })
    UI.AddToggle(FuseSec, { Id = "FuseAutoReveal", Title = "Tự hoàn tất khám phá", Default = true })
    UI.AddSlider(FuseSec, { Id = "FuseMaxScale", Title = "Scale tối đa để gộp", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    UI.AddSlider(FuseSec, { Id = "FuseKeepPerCategory", Title = "Giữ mỗi loại pet", Min = 0, Max = 20, Default = 0, Step = 1 })
    UI.AddSlider(FuseSec, { Id = "FuseInterval", Title = "Chu kỳ gộp", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " giây" })
    UI.AddButton(FuseSec, { Title = "Gộp ngay", Text = "Gộp", Callback = function() task.spawn(function() H.runAutoFusePets(true) end) end })

    -- ========================================================
    -- AUTO SELL PET (Patched)
    -- ========================================================
    UI.AddToggle(SellPetSec, {
        Id = "AutoSellPets", Title = "Bật Auto Sell Pet",
        Description = "Tự động bán pet theo danh sách đã chọn", Default = false,
        Callback = function(v)
            PetSellConfig.AutoSellPet = v
            if v then
                H.notify("Auto Sell Pet", L("petSellOn") .. PetSellConfig.SellPetInterval .. L("petSellOn2"), "Success", 3)
            else
                H.notify("Auto Sell Pet", L("petSellOff"), "Info", 3)
            end
        end
    })

    UI.AddToggle(SellPetSec, {
        Id = "UseWhitelist", Title = "Dùng Whitelist",
        Description = "BẬT = chỉ bán pet trong list | TẮT = bán tất cả trừ pet trong list",
        Default = true,
        Callback = function(v) PetSellConfig.UseWhitelist = v end
    })

    UI.AddToggle(SellPetSec, {
        Id = "KeepBestPet", Title = "Giữ pet mạnh nhất mỗi loại",
        Description = "Không bán pet có scale cao nhất của mỗi tên",
        Default = true,
        Callback = function(v) PetSellConfig.KeepBestPet = v end
    })

    UI.AddSlider(SellPetSec, {
        Id = "SellPetInterval", Title = "Chu kỳ quét",
        Min = 5, Max = 300, Default = 15, Step = 1, Suffix = " giây",
        Callback = function(v) PetSellConfig.SellPetInterval = v end
    })

    local PetNameDropdown = UI.AddDropdown(SellPetSec, {
        Id = "SellPetNameList", Title = "Danh sách Pet (theo tên)",
        Options = { "Đang quét..." }, Default = {},
        Multi = true,
        Callback = function()
            local list = H.multiSelected("SellPetNameList")
            if PetSellConfig.UseWhitelist then
                PetSellConfig.SellPetWhitelist = {}
                for k in pairs(list) do PetSellConfig.SellPetWhitelist[k] = true end
            else
                PetSellConfig.SellPetBlacklist = {}
                for k in pairs(list) do PetSellConfig.SellPetBlacklist[k] = true end
            end
        end
    })

    UI.AddDropdown(SellPetSec, {
        Id = "SellPetRarityList", Title = "Danh sách Rarity",
        Options = RARITIES, Default = {},
        Multi = true,
        Callback = function()
            local list = H.multiSelected("SellPetRarityList")
            if PetSellConfig.UseWhitelist then
                for k in pairs(list) do PetSellConfig.SellPetWhitelist[k] = true end
            else
                for k in pairs(list) do PetSellConfig.SellPetBlacklist[k] = true end
            end
        end
    })

    UI.AddButton(SellPetSec, {
        Title = "Quét lại danh sách Pet", Text = "Quét",
        Callback = function()
            task.spawn(function()
                local list = H.getPetListForSell(true)
                local names, seen = {}, {}
                for _, pet in ipairs(list) do
                    local n = tostring(pet.name)
                    if not seen[n] then seen[n] = true; names[#names + 1] = n end
                end
                table.sort(names)
                if #names == 0 then
                    H.notify("Auto Sell Pet", L("petSellNone"), "Warning", 3)
                    return
                end
                pcall(function() PetNameDropdown:SetOptions(names) end)
                H.notify("Auto Sell Pet", L("petSellScanned") .. #names .. L("petSellScanned2"), "Success", 3)
            end)
        end
    })

    UI.AddButton(SellPetSec, {
        Title = "Bán ngay theo danh sách", Text = "Bán",
        Callback = function()
            task.spawn(function()
                local sold, msg = H.runAutoSellPetsAdvanced()
                H.notify("Auto Sell Pet", msg, "Info", 4)
            end)
        end
    })

    UI.AddButton(SellPetSec, {
        Title = "Xoá danh sách chọn", Text = "Xoá",
        Callback = function()
            PetSellConfig.SellPetWhitelist = {}
            PetSellConfig.SellPetBlacklist = {}
            pcall(function() PetNameDropdown:Set({}) end)
            UI.SetState("SellPetNameList", {}, true)
            UI.SetState("SellPetRarityList", {}, true)
            H.notify("Auto Sell Pet", L("petSellCleared"), "Info", 3)
        end
    })

    task.delay(5, function()
        pcall(function()
            local list = H.getPetListForSell(true)
            local names, seen = {}, {}
            for _, pet in ipairs(list) do
                local n = tostring(pet.name)
                if not seen[n] then seen[n] = true; names[#names + 1] = n end
            end
            table.sort(names)
            if #names > 0 then
                PetNameDropdown:SetOptions(names)
            end
        end)
    end)

    local ProgressTab = UI.AddTab({ Id = "progress", Title = "Tiến trình" })
    local UpgradesSec = UI.AddSection(ProgressTab, { Title = "Nâng cấp" })
    local RewardsSec = UI.AddSection(ProgressTab, { Title = "Phần thưởng" })
    local EquipmentSec = UI.AddSection(ProgressTab, { Title = "Trang bị" })
    local TrainingSec = UI.AddSection(ProgressTab, { Title = "Huấn luyện" })
    UI.AddToggle(UpgradesSec, { Id = "AutoUpgrades", Title = "Tự mua nâng cấp", Default = false })
    UI.AddDropdown(UpgradesSec, { Id = "UpgradeTypes", Title = "Loại nâng cấp", Options = UPGRADE_TYPES, Multi = true, Default = { "Base", "Treadmill" } })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimIndex", Title = "Tự nhận Index", Default = false })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimGroupReward", Title = "Tự nhận thưởng nhóm", Default = false })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimOffline", Title = "Nhận tiền offline", Default = false })
    UI.AddToggle(EquipmentSec, { Id = "AutoBuyTrail", Title = "Tự mua Trail", Default = false })
    UI.AddDropdown(EquipmentSec, { Id = "TrailWanted", Title = "Trail", Options = TrailNames, Multi = true, Default = {} })
    UI.AddToggle(EquipmentSec, { Id = "AutoEquipBestTrail", Title = "Tự trang bị Trail tốt nhất", Default = false })
    UI.AddToggle(EquipmentSec, { Id = "AutoEquipBestGear", Title = "Tự trang bị Gear tốt nhất", Default = false })
    UI.AddToggle(TrainingSec, { Id = "AutoTreadmill", Title = "Tự tập máy chạy", Default = false })

    local PlayerTab = UI.AddTab({ Id = "player", Title = "Người chơi" })
    local EspSec = UI.AddSection(PlayerTab, { Title = "ESP" })
    local MoveSec = UI.AddSection(PlayerTab, { Title = "Di chuyển" })
    local TeleportSec = UI.AddSection(PlayerTab, { Title = "Dịch chuyển" })
    UI.AddToggle(EspSec, { Id = "EspWorldEggs", Title = "ESP trứng trên map", Default = false })
    UI.AddToggle(EspSec, { Id = "EspCarriedEggs", Title = "ESP trứng đang cầm/thả", Default = false })
    UI.AddToggle(EspSec, { Id = "EspGuards", Title = "ESP bảo vệ", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPets", Title = "ESP pet", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPlayers", Title = "ESP người chơi", Default = false })
    UI.AddToggle(EspSec, { Id = "EspMachines", Title = "ESP máy", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPlots", Title = "ESP khu đất", Default = false })
    UI.AddSlider(EspSec, { Id = "EspDistance", Title = "Khoảng cách hiển thị", Min = 100, Max = 6000, Default = 2000, Step = 50, Suffix = " studs" })
    UI.AddToggle(MoveSec, { Id = "WalkSpeedEnabled", Title = "Chỉnh tốc độ chạy", Default = false })
    UI.AddSlider(MoveSec, { Id = "WalkSpeed", Title = "Tốc độ chạy", Min = 16, Max = 500, Default = 32, Step = 1 })
    UI.AddToggle(MoveSec, { Id = "JumpPowerEnabled", Title = "Chỉnh lực nhảy", Default = false })
    UI.AddSlider(MoveSec, { Id = "JumpPower", Title = "Lực nhảy", Min = 10, Max = 500, Default = 50, Step = 1 })
    UI.AddToggle(MoveSec, { Id = "InfJump", Title = "Nhảy vô hạn", Default = false })
    UI.AddToggle(MoveSec, { Id = "NoClip", Title = "Xuyên tường", Default = false })
    UI.AddDivider(MoveSec, { Title = "Bay" })
    UI.AddToggle(MoveSec, { Id = "Fly", Title = "Bay", Default = false, Callback = function(v)
        if not v then
            local h = H.getHumanoid(); if h then h.PlatformStand = false end
            local root = H.getRoot()
            local lv = root and root:FindFirstChild("ZenHubXFlyLV")
            if lv then lv:Destroy() end
        end
    end })
    UI.AddSlider(MoveSec, { Id = "FlySpeed", Title = "Tốc độ bay", Min = 10, Max = 400, Default = 60, Step = 1 })
    UI.AddDropdown(TeleportSec, { Id = "WaypointTarget", Title = "Điểm đánh dấu", Options = WaypointNames, Default = "Base" })
    UI.AddButton(TeleportSec, { Title = "Dịch chuyển tới điểm", Text = "Đi", Callback = function()
        task.spawn(function()
            local position = H.resolveWaypoint(H.optionValue("WaypointTarget", "Base"))
            if not position then H.notify("Waypoint", L("waypointBad"), "Warning", 3); return end
            if not H.bypassMoveTo(position, nil, BYPASS_SPEED) then H.notify("Waypoint", L("waypointFail"), "Error", 3) end
        end)
    end })

    local ExtrasTab = UI.AddTab({ Id = "extras", Title = "Bổ sung" })
    local CharSec = UI.AddSection(ExtrasTab, { Title = "Nhân vật" })
    local WorldSec = UI.AddSection(ExtrasTab, { Title = "Thế giới" })
    local SpeedSec2 = UI.AddSection(ExtrasTab, { Title = "Bypass tốc độ" })
    local AntiTrapSec = UI.AddSection(ExtrasTab, { Title = "Chống bẫy" })

    UI.AddToggle(CharSec, { Id = "AntiRagdoll", Title = "Chống ragdoll",
        Description = "Tự đứng dậy khi bị hất tung", Default = false,
        Callback = function(v) ExtrasState.AntiRagdoll = v end })

    UI.AddToggle(CharSec, { Id = "InstantInteract", Title = "Tương tác tức thì",
        Description = "Bỏ qua thời gian giữ nút", Default = false,
        Callback = function(v) ExtrasState.SetInstantHold(v) end })

    UI.AddToggle(CharSec, { Id = "LookRocket", Title = "Tele Guiado (LookRocket)",
        Description = "Chuyển hướng vận tốc khi bị ném", Default = false,
        Callback = function(v) ExtrasState.LookRocket = v end })

    UI.AddToggle(WorldSec, { Id = "FixLag", Title = "Giảm lag (Clay)",
        Description = "Xóa cây cối + SmoothPlastic", Default = false,
        Callback = function(v)
            if v then ExtrasState.EnableFixLag()
            else ExtrasState.FixLag = false end
        end })

    UI.AddToggle(AntiTrapSec, { Id = "AntiTrap", Title = "Chống bẫy (Xóa)",
        Description = "Vô hiệu hóa & ẩn bẫy", Default = false,
        Callback = function(v)
            if v then ExtrasState.EnableAntiTrap()
            else ExtrasState.AntiTrap = false end
        end })

    UI.AddButton(AntiTrapSec, { Title = "Đổi server ít người (1-5)", Text = "Đổi",
        Callback = function() H.hopLowPop() end })

    UI.AddSlider(SpeedSec2, { Id = "BypassSpeed", Title = "Giá trị tốc độ",
        Min = 100, Max = 900, Default = 300, Step = 10,
        Callback = function(v) ExtrasState.SpeedValue = v end })

    UI.AddToggle(SpeedSec2, { Id = "SpeedBypassToggle", Title = "Khóa tốc độ chạy",
        Description = "Khóa WalkSpeed mỗi frame", Default = false,
        Callback = function(v) ExtrasState.SpeedBypass = v end })

    UI.AddButton(SpeedSec2, { Title = "Áp dụng Bypass tốc độ", Text = "Áp dụng",
        Callback = function()
            task.spawn(function()
                local sp = tonumber(H.optionValue("BypassSpeed", 300)) or 300
                ExtrasState.SpeedValue = sp
                local ok = ExtrasState.ApplySpeedBypass(sp)
                H.notify("Tốc độ", ok and (L("speedOk") .. sp .. L("speedApplied")) or L("speedFail"),
                    ok and "Success" or "Error", 3)
            end)
        end })

    local SysTab = UI.AddTab({ Id = "system", Title = "Hệ thống" })
    local SessionSysSec = UI.AddSection(SysTab, { Title = "Phiên" })
    local PerformanceSec = UI.AddSection(SysTab, { Title = "Hiệu năng" })
    local SettingsSec = UI.AddSection(SysTab, { Title = "Cài đặt" })
    local SocialSec = UI.AddSection(SysTab, { Title = "Liên kết" })
    local WebhookSec = UI.AddSection(SysTab, { Title = "Webhook" })
    local AboutSec = UI.AddSection(SysTab, { Title = "Thông tin" })

    UI.AddDropdown(SettingsSec, {
        Id = "Language",
        Title = "Ngôn ngữ / Language",
        Options = { "Tiếng Việt", "English" },
        Default = "Tiếng Việt",
        Callback = function(v)
            LANG.Current = (v == "English") and "en" or "vi"
            applyLanguageToUI()
            H.notify("ZenHubX", L("langChanged"), "Success", 3)
        end
    })

    UI.AddToggle(SessionSysSec, { Id = "AntiAfk", Title = "Chống AFK", Default = true })
    UI.AddToggle(SessionSysSec, { Id = "AntiGameplayPause", Title = "Không tạm dừng gameplay", Default = true,
        Callback = function(v) H.applyAntiGameplayPause(v) end })
    UI.AddToggle(SessionSysSec, { Id = "AutoReconnect", Title = "Tự kết nối lại", Default = false })
    UI.AddButton(SessionSysSec, { Title = "Vào lại server", Text = "Vào", Callback = function() H.rejoinServer() end })
    UI.AddButton(SessionSysSec, { Title = "Sao chép script vào server", Text = "Copy", Callback = function()
        pcall(function() setclipboard(string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)',
            game.PlaceId, CurrentJobId)) end)
        H.notify(L("copied"), L("scriptCopied"), "Success", 3)
    end })

    UI.AddToggle(PerformanceSec, { Id = "FpsBoost", Title = "Tăng FPS", Default = false,
        Callback = function(v) if v then H.enableFpsBoost() else H.disableFpsBoost() end end })
    UI.AddToggle(PerformanceSec, { Id = "DisableRendering", Title = "Tắt render 3D", Default = false,
        Callback = function(v) H.applyRendering(v) end })
    UI.AddSlider(PerformanceSec, { Id = "FpsCap", Title = "Giới hạn FPS", Min = 15, Max = 360, Default = 60, Step = 1, Suffix = " fps",
        Callback = function(v) H.applyFpsCap(v) end })

    UI.AddButton(SocialSec, { Title = "Sao chép link Discord", Text = "Copy", Callback = function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        H.notify("Discord", L("discordCopy"), "Success", 3)
    end })
    UI.AddButton(SocialSec, { Title = "Sao chép TikTok ID", Text = "Copy", Callback = function()
        pcall(function() setclipboard(TIKTOK_ID) end)
        H.notify("TikTok", L("tiktokCopy"), "Success", 3)
    end })

    UI.AddToggle(WebhookSec, { Id = "WebhookEnabled", Title = "Bật Webhook", Default = false })
    UI.AddInput(WebhookSec, { Id = "WebhookUrl", Title = "URL Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = "" })
    UI.AddInput(WebhookSec, { Id = "WebhookPingId", Title = "ID người nhận ping", Placeholder = "123456789012345678", Default = "" })
    UI.AddSlider(WebhookSec, { Id = "WebhookInterval", Title = "Chu kỳ tổng kết", Min = 1, Max = 180, Default = 15, Step = 1, Suffix = " phút" })
    UI.AddToggle(WebhookSec, { Id = "WebhookEggSpawns", Title = "Liệt kê trứng đã spawn", Default = true })
    UI.AddDropdown(WebhookSec, { Id = "WebhookRarities", Title = "Độ hiếm", Options = RARITIES, Multi = true, Default = {} })
    UI.AddToggle(WebhookSec, { Id = "WebhookDisconnectAlerts", Title = "Cảnh báo mất kết nối", Default = false })
    UI.AddButton(WebhookSec, { Title = "Gửi tổng kết ngay", Text = "Gửi", Callback = function()
        task.spawn(function()
            local sent = H.sendSummary()
            H.notify("Webhook", sent and L("webhookSent") or L("webhookFail"), sent and "Success" or "Error", 3)
        end)
    end })

    UI.AddParagraph(AboutSec, { Title = "Nhà phát triển", Content = "ZenHubX" })
    UI.AddParagraph(AboutSec, { Title = "Giao diện", Content = "UI tự động, không thư viện ngoài" })
    UI.AddParagraph(AboutSec, { Title = "Discord", Content = DISCORD_LINK })
    UI.AddParagraph(AboutSec, { Title = "TikTok", Content = TIKTOK_ID })
    UI.AddDivider(AboutSec, { Title = "Khu vực nguy hiểm" })
    UI.AddButton(AboutSec, { Title = "Tắt script", Text = "Tắt", Callback = function() H.unload() end })
end

for _, obj in ipairs(screenGui:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        if obj.Text ~= "" then
            pcall(function() obj:SetAttribute("ZenVI", obj.Text) end)
        end
    end
end

-- ============================================================
-- DASHBOARD REFRESH
-- ============================================================
local function refreshHomeDashboard()
    if not running then return end
    pcall(function()
        if refs.carryingRow then
            refs.carryingRow:SetValue(IsCarryingEgg and (LANG.Current == "en" and "Yes" or "Có") or (LANG.Current == "en" and "No" or "Không"))
            refs.carryingRow:SetStatus(IsCarryingEgg and "Warning" or "Neutral")
        end
        if refs.runtimeRow then refs.runtimeRow:SetValue(H.formatElapsed(os.clock() - SessionStartedAt)) end
        if refs.inventoryProgress then
            refs.inventoryProgress:SetValue(string.format("%d / %s", H.eggInventoryCount(),
                tostring(EggTypes and EggTypes.MAX_INVENTORY or "?")))
        end
        local save = H.getSave()
        if save then
            if refs.moneyRow then refs.moneyRow:SetValue(H.formatNumber(save.Money)) end
            if refs.speedRow then refs.speedRow:SetValue(H.formatNumber(save.SpeedPower)) end
            if refs.rebirthRow then refs.rebirthRow:SetValue(tostring(save.Rebirth or 0)) end
            if refs.petsOwnedRow then refs.petsOwnedRow:SetValue(tostring(H.countTable(save.Inventory))) end
        end
        if refs.stolenRow then refs.stolenRow:SetValue(tostring(SessionStolenEggs)) end
    end)
end
refreshHomeDashboard()

-- ============================================================
-- UNLOAD
-- ============================================================
function H.unload()
    if not running then return end
    running = false
    pcall(H.stopTreadmillTraining)
    pcall(function() H.applyAntiGameplayPause(false) end)
    pcall(function() H.applyRendering(false) end)
    pcall(H.disableFpsBoost)
    pcall(H.clearAllEsp)
    if EspFolder then pcall(function() EspFolder:Destroy() end) end
    for _, c in ipairs(conns) do
        pcall(function() if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end)
    end
    H.clearTable(conns)
    for _, c in ipairs(UI.__connections) do
        pcall(function() if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end)
    end
    pcall(function() screenGui:Destroy() end)
    pcall(function() toggleGui:Destroy() end)
    genv.__ZENHUBX_RUNNING = nil
    genv.__ZENHUBX_SHUTDOWN = nil
end
genv.__ZENHUBX_SHUTDOWN = H.unload

-- ============================================================
-- CONNECTIONS
-- ============================================================
local function applyNoClipTo(inst)
    if inst and inst:IsA("BasePart") then inst.CanCollide = false end
end
local NoClipAddedConn = nil
local function setNoClip(enabled)
    if NoClipAddedConn then pcall(function() NoClipAddedConn:Disconnect() end); NoClipAddedConn = nil end
    local character = LocalPlayer.Character
    if not enabled or not character then return end
    for _, inst in ipairs(character:GetDescendants()) do applyNoClipTo(inst) end
    NoClipAddedConn = character.DescendantAdded:Connect(applyNoClipTo)
    H.track(NoClipAddedConn)
end

H.track(UserInputService.JumpRequest:Connect(function()
    if not running or not H.isOn("InfJump") then return end
    local humanoid = H.getHumanoid()
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

H.track(RunService.RenderStepped:Connect(function(dt)
    if not running or not H.isOn("Fly") then return end
    local root = H.getRoot(); local humanoid = H.getHumanoid()
    local cam = Workspace.CurrentCamera
    if not root or not humanoid or not cam then return end
    humanoid.PlatformStand = true
    local lv = root:FindFirstChild("ZenHubXFlyLV")
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = "ZenHubXFlyLV"
        lv.MaxForce = 1e6
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        local att = Instance.new("Attachment")
        att.Name = "ZenHubXFlyAttachment"
        att.Parent = root
        lv.Attachment0 = att
        lv.Parent = root
    end
    local direction = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, 1, 0) end
    local speed = math.min(tonumber(H.optionValue("FlySpeed", 60)) or 60, MAX_SAFE_SPEED)
    if direction.Magnitude > 0 then
        lv.VectorVelocity = direction.Unit * speed
    else
        lv.VectorVelocity = Vector3.zero
    end
end))

H.track(UserInputService.InputBegan:Connect(function() LastInputAt = tick() end))
H.track(UserInputService.InputChanged:Connect(function(input)
    local it = input.UserInputType
    if it == Enum.UserInputType.MouseMovement or it == Enum.UserInputType.Gamepad1 then LastInputAt = tick() end
end))

H.track(LocalPlayer.CharacterAdded:Connect(function()
    if not running then return end
    task.delay(0.35, function()
        if H.stealingEnabled() then H.swapStealHumanoid() end
        if H.isOn("NoClip") then setNoClip(true) end
    end)
end))

H.track(UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.End then H.unload() end
end))

-- ============================================================
-- SCHEDULER
-- ============================================================
local SchedulerAt = {}
local LastNoClipOn = false
local function schedulerDue(name, interval)
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

    if schedulerDue("core", 0.35) then
        task.spawn(function()
            if H.stealingEnabled() then H.swapStealHumanoid() end
            runCarryJobs()
            runPriorityJobs()
        end)
    end

    if schedulerDue("dashboard", 2) then
        refreshHomeDashboard()
        local noclipOn = H.isOn("NoClip")
        if noclipOn ~= LastNoClipOn then LastNoClipOn = noclipOn; setNoClip(noclipOn) end
        if H.isOn("WalkSpeedEnabled") and not ExtrasState.SpeedBypass then
            local humanoid = H.getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = math.min(tonumber(H.optionValue("WalkSpeed", 32)) or 32, MAX_SAFE_SPEED)
            end
        end
        if H.isOn("JumpPowerEnabled") then
            local humanoid = H.getHumanoid()
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = tonumber(H.optionValue("JumpPower", 50)) or 50
            end
        end
        if TreadmillTrainingActive or H.isDoubleSpeedVisible() then
            if not H.isOn("AutoTreadmill") then pcall(H.stopTreadmillTraining) end
        end
        if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
    end

    if schedulerDue("esp", 1.25) then
        local anyEsp = H.isOn("EspWorldEggs") or H.isOn("EspCarriedEggs") or H.isOn("EspGuards")
            or H.isOn("EspPets") or H.isOn("EspPlayers") or H.isOn("EspMachines") or H.isOn("EspPlots")
        if anyEsp then pcall(H.runEsp)
        elseif next(EspEntries) ~= nil then pcall(H.clearAllEsp) end
    end

    if schedulerDue("pets", 5) then
        if H.isOn("AutoEquipBest") and not AutomationBusy then pcall(H.runAutoEquipBest) end
        if H.isOn("AutoEquipBestTrail") then pcall(H.runAutoEquipBestTrail) end
        if H.isOn("AutoEquipBestGear") then pcall(H.runAutoEquipBestGear) end
        if H.isOn("AutoDeleteOwnPets") then pcall(H.deleteOwnPetRenders) end
    end

    if schedulerDue("fuse", tonumber(H.optionValue("FuseInterval", 8)) or 8) then
        if H.isOn("AutoFusePets") and not AutomationBusy and not IsCarryingEgg then
            AutomationBusy = true; pcall(H.runAutoFusePets); AutomationBusy = false
        end
    end

    if schedulerDue("sellPets", tonumber(H.optionValue("SellPetInterval", 15)) or 15) then
        if H.isOn("AutoSellPets") and not AutomationBusy and not IsCarryingEgg then
            task.spawn(function()
                pcall(H.runAutoSellPetsAdvanced)
            end)
        end
    end

    if schedulerDue("sellEggs", tonumber(H.optionValue("SellEggInterval", 8)) or 8) then
        if H.isOn("AutoSellEggs") and not AutomationBusy and not IsCarryingEgg then
            AutomationBusy = true; pcall(H.runAutoSellEggs); AutomationBusy = false
        end
    end

    if schedulerDue("upgrades", 4) then
        if H.isOn("AutoUpgrades") and not IsCarryingEgg then pcall(H.runAutoUpgrades) end
        if H.isOn("AutoBuyTrail") and not IsCarryingEgg then pcall(H.runAutoBuyTrail) end
    end

    if schedulerDue("claims", 12) then
        if H.isOn("AutoClaimIndex") then pcall(H.runAutoClaimIndex) end
        if H.isOn("AutoClaimOffline") then pcall(H.runClaimOfflineEarnings) end
        if H.isOn("AutoClaimGroupReward") then pcall(H.runAutoClaimGroupReward) end
    end

    if schedulerDue("hop", 3) then
        if H.isOn("AutoServerHop") and not AutomationBusy then pcall(H.runServerHop) end
    end

    if schedulerDue("webhook", 5) then
        if H.isOn("WebhookEnabled") then
            pcall(H.trackWebhookEvents)
            pcall(H.runWebhookSummary)
        end
    end

    if schedulerDue("session", 4) then
        if H.isOn("AntiAfk") then
            local idleFor = tick() - LastInputAt
            local sinceLastTap = tick() - LastAntiAfkAt
            if (idleFor >= 300 and sinceLastTap >= 60) or (idleFor < 300 and sinceLastTap >= 300) then
                pcall(function()
                    local humanoid = H.getHumanoid()
                    if humanoid then
                        humanoid.Jump = true
                        LastAntiAfkAt = tick()
                    end
                end)
            end
        end
        if H.isOn("AutoReconnect") or H.isOn("WebhookDisconnectAlerts") then
            local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
            if overlay then
                local err = overlay:FindFirstChild("ErrorPrompt") or overlay:FindFirstChildWhichIsA("Frame")
                if err and err.Visible and tostring(err.Name):find("ErrorPrompt") then
                    H.handleDisconnect("Roblox error prompt")
                end
            end
        end
    end
end))

if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
if H.isOn("FpsBoost") then H.enableFpsBoost() end
H.applyFpsCap(H.optionValue("FpsCap", 60))

H.notify("ZenHubX", L("ready"), "Success", 5)
if refs.statusRow then refs.statusRow:SetStatus("Success") end