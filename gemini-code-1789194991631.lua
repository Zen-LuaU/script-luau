--[[
    Zen Hub - Steal an Egg
    Standalone UI (no external library)
    Discord: https://discord.gg/kptjwzKWgX
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
if type(genv.__APEX_HUB_SHUTDOWN) == "function" then
    pcall(genv.__APEX_HUB_SHUTDOWN); task.wait(0.1)
end
if genv.__APEX_HUB_RUNNING then return end
genv.__APEX_HUB_RUNNING = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")
local TeleportService    = game:GetService("TeleportService")
local UserInputService   = game:GetService("UserInputService")
local Lighting           = game:GetService("Lighting")
local VirtualUser        = game:GetService("VirtualUser")
local Workspace          = game:GetService("Workspace")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local GuiService         = game:GetService("GuiService")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
pcall(function() LocalPlayer:WaitForChild("PlayerGui", 10) end)

local DISCORD_LINK = "https://discord.gg/kptjwzKWgX"
local TOGGLE_ICON  = "rbxassetid://131679774975668"
local HEADER_TEXT  = "Zen Hub"
local SUBTITLE     = "Discord: " .. DISCORD_LINK

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
    Backpack = {
        EQUIP_BEST = H.remoteFrom(RemotesModule, "Haul", "WearBest")
            or H.findRemoteContains("WearBest") or H.findRemoteContains("EQUIP_BEST"),
    },
    Plots = {
        REQUEST_BASE_UPGRADE = H.remoteFrom(RemotesModule, "Homestead", "AskBaseTierRaise")
            or H.findRemoteContains("AskBaseTierRaise") or H.findRemoteContains("BaseUpgrade"),
    },
    Treadmills = {
        REQUEST_UPGRADE = H.remoteFrom(RemotesModule, "Treadmill", "AskTierRaise") or H.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC = H.remoteFrom(RemotesModule, "Treadmill", "AskWearStill") or H.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP = H.remoteFrom(RemotesModule, "Treadmill", "AskDoff") or H.findRemoteContains("AskDoff"),
    },
    Index = { REQUEST_CLAIM_ALL = H.remoteFrom(RemotesModule, "Codex", "AskRedeemAll") or H.findRemoteContains("AskRedeemAll") },
    AssetInventory = {
        SELL_ASSET = H.remoteFrom(RemotesModule, "PetSatchel", "SellPet")
            or H.findRemoteContains("SellPet") or H.findRemoteContains("SELL_ASSET"),
    },
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
local DEFAULT_STEAL_SPEED = 800
local BYPASS_SPEED = 900
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
    local history = getgenv().ApexHubHopHistory
    if typeof(history) ~= "table" then history = {}; getgenv().ApexHubHopHistory = history end
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
EspFolder.Name = "ApexEggEsp"
EspFolder.Parent = Workspace

function H.track(c) table.insert(conns, c); return c end

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
        if className == "BodyVelocity" or className == "BodyPosition" or className == "BodyGyro" or className == "BodyAngularVelocity" or className == "LinearVelocity" or className == "VectorForce" or className == "AlignOrientation" then
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
    if character and character.Parent then pcall(function() character:PivotTo(cf) end)
    else root.CFrame = cf end
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
function H.stealSpeed() return DEFAULT_STEAL_SPEED end
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
    local newHumanoid
    local ok, clone = pcall(function() humanoid.Archivable = true; return humanoid:Clone() end)
    if ok and clone then
        newHumanoid = clone
        newHumanoid.Parent = character
        pcall(function() humanoid:Destroy() end)
    else newHumanoid = humanoid end
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
    humanoid.Sit = false; humanoid.PlatformStand = false; humanoid.AutoRotate = true
    humanoid.WalkSpeed = H.stealSpeed()
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= StealConfig.ArriveDistance then return true end
    local route = H.buildStealPath(root.Position, dest)
    if #route == 0 then route = { dest } end
    for _, point in ipairs(route) do
        if not running or (keepGoing and not keepGoing()) then return false end
        root = H.getRoot(); if not root then return false end
        local pointY = H.groundedY(point.X, point.Z, root.Position.Y)
        local waypoint = Vector3.new(point.X, pointY, point.Z)
        while running do
            if keepGoing and not keepGoing() then return false end
            root = H.getRoot(); if not root then return false end
            local offset = waypoint - root.Position
            local distance = offset.Magnitude
            if distance <= StealConfig.ArriveDistance then break end
            local direction = offset.Unit
            local dt = math.clamp(RunService.Heartbeat:Wait(), 0, 1 / 30)
            local step = math.min(H.stealSpeed() * dt, distance)
            local nextPos = root.Position + direction * step
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
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
    speed = tonumber(speed) or BYPASS_SPEED
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
    bv.Name = "ApexBypassMove"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "ApexBypassGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
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
    local part = eggInstance:FindFirstChild("Hitbox") or eggInstance:FindFirstChild("CustomBoundingBox") or eggInstance:FindFirstChildOfClass("BasePart")
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
function H.getSellablePets()
    local save = H.getSave()
    local inventory = save and save.Inventory
    local result = {}
    if typeof(inventory) ~= "table" then return result end
    local equipped = save.EquippedAssets or {}
    local maxScale = tonumber(H.optionValue("SellMaxScale", 10)) or 10
    local keepMutated = H.isOn("SellKeepMutated")
    local keepEquipped = H.isOn("SellKeepEquipped")
    local selectedMutations = H.multiSelected("SellMutations")
    local filterMutations = H.multiHasAny("SellMutations")
    local selectedRarities = H.multiSelected("SellRarities")
    local filterRarities = H.multiHasAny("SellRarities")
    for uid, asset in pairs(inventory) do
        if typeof(uid) == "string" and typeof(asset) == "table" then
            local itemData = H.getPetItemData(asset)
            local isEquipped = table.find(equipped, uid) ~= nil
            local protected = not itemData or itemData.IsFavorite == true or itemData.InFuse == true or (keepEquipped and isEquipped)
            if not protected then
                local mutations = H.recordMutations(asset)
                local mutationAllowed = not (keepMutated and #mutations > 0)
                if mutationAllowed and filterMutations then
                    mutationAllowed = false
                    for _, mutation in ipairs(mutations) do
                        if selectedMutations[mutation] then mutationAllowed = true; break end
                    end
                end
                local scale = tonumber(asset.Scale) or 0
                local rarity = H.resolveRarity(asset.Category)
                local rarityAllowed = not filterRarities or (typeof(rarity) == "string" and selectedRarities[rarity] == true)
                if mutationAllowed and scale <= maxScale and rarityAllowed then table.insert(result, uid) end
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
    local payload = { username = "Zen Hub", embeds = { embed } }
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
        author = { name = "Steal an Egg | Zen Hub" },
        title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            LocalPlayer.Name, DisplayJobId, H.formatElapsed(os.clock() - SessionStartedAt)),
        color = 11141375, fields = fields,
        footer = { text = "Zen Hub | " .. DISCORD_LINK },
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
    if enabled then
        pcall(function()
            if sethiddenproperty then sethiddenproperty(LocalPlayer, "GameplayPaused", false)
            else LocalPlayer.GameplayPaused = false end
        end)
    end
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
            author = { name = "Steal an Egg | Zen Hub" },
            title = "Disconnected",
            description = string.format("**Player** `%s`\n**Reason** %s", LocalPlayer.Name, tostring(reason or "Connection lost")),
            color = 15158332,
            footer = { text = "Zen Hub | " .. DISCORD_LINK },
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
    panelBg       = Color3.fromRGB(16, 12, 22),
    panelBg2      = Color3.fromRGB(24, 18, 34),
    panelBorder   = Color3.fromRGB(70, 40, 100),
    panelBorderHi = Color3.fromRGB(170, 70, 255),
    sidebarBg     = Color3.fromRGB(12, 8, 18),
    sectionBg     = Color3.fromRGB(28, 20, 40),
    sectionBorder = Color3.fromRGB(80, 45, 115),
    text          = Color3.fromRGB(245, 240, 255),
    textDim       = Color3.fromRGB(180, 160, 200),
    textMuted     = Color3.fromRGB(125, 105, 145),
    accent        = Color3.fromRGB(170, 0, 255),
    accentHi      = Color3.fromRGB(210, 80, 255),
    toggleOn      = Color3.fromRGB(170, 0, 255),
    toggleOff     = Color3.fromRGB(50, 40, 65),
    success       = Color3.fromRGB(90, 210, 130),
    warning       = Color3.fromRGB(235, 175, 70),
    error         = Color3.fromRGB(240, 90, 90),
    info          = Color3.fromRGB(110, 170, 240),
}

local function getGuiParent()
    if gethui then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    return CoreGui
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZenHubGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 9999
screenGui.Parent = getGuiParent()

-- Toggle
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ZenHubToggle"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.DisplayOrder = 9998
toggleGui.Parent = getGuiParent()

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.fromOffset(56, 56)
toggleBtn.Position = UDim2.new(0, 24, 0.4, 0)
toggleBtn.BackgroundColor3 = COLORS.panelBg
toggleBtn.BackgroundTransparency = 0.15
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "z"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.TextColor3 = COLORS.accentHi
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Draggable = false
toggleBtn.Parent = toggleGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.5
toggleStroke.Color = COLORS.panelBorderHi
toggleStroke.Transparency = 0.3
toggleStroke.Parent = toggleBtn

-- Panel
local PANEL_W, PANEL_H = 640, 440
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

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel
local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1.5
panelStroke.Color = COLORS.panelBorder
panelStroke.Transparency = 0.15
panelStroke.Parent = panel

local function addCorner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 6); c.Parent = parent; return c
end
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color or COLORS.panelBorder
    s.Thickness = thickness or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s
end

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 52)
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
title.Position = UDim2.fromOffset(20, 8)
title.Size = UDim2.new(0, 300, 0, 22)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = COLORS.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = HEADER_TEXT
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(20, 30)
subtitle.Size = UDim2.new(0, 400, 0, 16)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = COLORS.textDim
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = SUBTITLE
subtitle.Parent = header

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.fromOffset(96, 26)
discordBtn.Position = UDim2.new(1, -174, 0, 13)
discordBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
discordBtn.BackgroundTransparency = 0.15
discordBtn.BorderSizePixel = 0
discordBtn.AutoButtonColor = false
discordBtn.Font = Enum.Font.GothamSemibold
discordBtn.TextSize = 12
discordBtn.TextColor3 = COLORS.text
discordBtn.Text = "Discord"
discordBtn.Parent = header
addCorner(discordBtn, 6)
addStroke(discordBtn, COLORS.panelBorderHi, 1)
discordBtn.MouseEnter:Connect(function() TweenService:Create(discordBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play() end)
discordBtn.MouseLeave:Connect(function() TweenService:Create(discordBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play() end)
discordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end)
    H.notify("Zen Hub", "Discord link copied", "Success", 3)
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 60)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = COLORS.text
closeBtn.Text = "z"
closeBtn.Parent = header
addCorner(closeBtn, 6)
addStroke(closeBtn, COLORS.accentHi, 1)
closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.accent, BackgroundTransparency = 0 }):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(60, 20, 60), BackgroundTransparency = 0.2 }):Play() end)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

-- Sidebar
local SIDEBAR_W = 150
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 52)
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -52)
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
sidebarList.Padding = UDim.new(0, 4)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Parent = sidebarScroll

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 10)
sidebarPad.PaddingLeft = UDim.new(0, 8)
sidebarPad.PaddingRight = UDim.new(0, 8)
sidebarPad.Parent = sidebarScroll

toggleBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)