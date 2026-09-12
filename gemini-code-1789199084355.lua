--[[
    Apex Hub -> zen hubXsteal
    Standalone UI (no external library)
    Features merged from ThanhDuy Hub + zen hubX
--]]

-- ============================================================
-- COMPAT SHIMS
-- ============================================================
local _G_ENV = (getgenv and getgenv()) or _G
if type(table.pack) ~= "function" then function table.pack(...) return { n = select("#", ...), ... } end end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(v, mn, mx) if v < mn then return mn elseif v > mx then return mx end return v end
end
if type(table.find) ~= "function" then
    function table.find(t, v, init)
        if type(t) ~= "table" then return nil end
        for i = tonumber(init) or 1, #t do if t[i] == v then return i end end
        return nil
    end
end

-- ============================================================
-- ANTI-CHEAT (kích hoạt ngay khi chạy script)
-- ============================================================
pcall(function()
    if type(getgc) == "function" and type(getrawmetatable) == "function" and type(setmetatable) == "function" then
        for _, obj in getgc(true) do
            if typeof(obj) ~= "table" or getrawmetatable(obj) then continue end
            local mainrun = false
            for _, v in obj do
                if v == obj then mainrun = true break end
            end
            if not mainrun then continue end
            for _, v in obj do
                if typeof(v) == "number" and v >= 1 and v <= 3 and obj[v] == nil then
                    setmetatable(obj, {__newindex = function() end})
                    break
                end
            end
        end
    end
end)

local genv = _G_ENV
if type(genv.__APEX_HUB_SHUTDOWN) == "function" then pcall(genv.__APEX_HUB_SHUTDOWN); task.wait(0.1) end
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
local HEADER_TEXT  = "zen hubXsteal"
local SUBTITLE     = "Discord: " .. DISCORD_LINK

-- ============================================================
-- GAME MODULES
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
-- LANGUAGE SYSTEM (HỆ THỐNG NGÔN NGỮ)
-- ============================================================
local Languages = {
    VN = {
        Settings = "Cài đặt",
        Language = "Ngôn ngữ",
        LanguageDesc = "Chọn ngôn ngữ (Tiếng Việt/English)",
        AntiRagdoll = "Chống Ngã (Anti-Ragdoll)",
        SpeedChanger = "Tốc Độ (Speed Changer)",
        InstantInteract = "Tương Tác Nhanh (Instant Interact)",
        AntiTrap = "Chống Bẫy (Anti-Trap)"
    },
    EN = {
        Settings = "Settings",
        Language = "Language",
        LanguageDesc = "Select Language (Tiếng Việt/English)",
        AntiRagdoll = "Anti-Ragdoll",
        SpeedChanger = "Speed Changer",
        InstantInteract = "Instant Interact",
        AntiTrap = "Anti-Trap"
    }
}
local CurrentLang = "VN"

function H.GetLang(key)
    return Languages[CurrentLang] and Languages[CurrentLang][key] or key
end

-- Hàm giả định lấy cài đặt (cập nhật với UI hub của bạn)
function H.isOn(flag) return false end 
function H.optionValue(flag, default) return default end
function H.selectionAllows(...) return true end
function H.matchesEggFilters(...) return true end
function H.multiSelected(flag) return {} end
function H.multiHasAny(flag) return false end

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
EspFolder.Name = "ZenXstealEggEsp"
EspFolder.Parent = Workspace

function H.track(c) table.insert(conns, c); return c end

-- ============================================================
-- GAME HELPERS
-- ============================================================
function H.getHumanoid() local ch = LocalPlayer.Character; return ch and ch:FindFirstChildOfClass("Humanoid") or nil end
function H.getRoot() local ch = LocalPlayer.Character; return ch and ch:FindFirstChild("HumanoidRootPart") or nil end
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
function H.countTable(value) if typeof(value) ~= "table" then return 0 end local count = 0 for _ in pairs(value) do count = count + 1 end return count end
function H.formatNumber(value)
    local number = tonumber(value) or 0
    local suffixes = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local suffixIndex = 1
    for _ = 1, 6 do if number >= 1000 then number = number / 1000; suffixIndex = suffixIndex + 1 end end
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
        pcall(function() camera.CameraSubject = newHumanoid; if cameraCFrame then camera.CFrame = cameraCFrame end end)
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
    if not humanoid or humanoid.Health <= 0 or not root then return false end -- ADDED HEALTH CHECK
    humanoid.Sit = false; humanoid.PlatformStand = false; humanoid.AutoRotate = true
    humanoid.WalkSpeed = H.stealSpeed()
    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= StealConfig.ArriveDistance then return true end
    local route = H.buildStealPath(root.Position, dest)
    if #route == 0 then route = { dest } end
    for _, point in ipairs(route) do
        if not running or (keepGoing and not keepGoing()) or humanoid.Health <= 0 then return false end -- CHECK HEALTH
        root = H.getRoot(); if not root then return false end
        local pointY = H.groundedY(point.X, point.Z, root.Position.Y)
        local waypoint = Vector3.new(point.X, pointY, point.Z)
        while running do
            if keepGoing and not keepGoing() or humanoid.Health <= 0 then return false end -- CHECK HEALTH
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
    bv.Name = "ZenXBypassMove"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250; bv.Velocity = Vector3.zero; bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "ZenXBypassGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 3000; bg.D = 50; bg.CFrame = root.CFrame; bg.Parent = root
    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() or (humanoid and humanoid.Health <= 0) then break end -- ADDED HEALTH CHECK
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
    local humanoid = H.getHumanoid()
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() or (humanoid and humanoid.Health <= 0) then return false end -- ADDED HEALTH CHECK
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
-- EXTRA FEATURES
-- ============================================================

-- Anti-Ragdoll / Anti-Knock
local PeteSettings = { AntiRagdoll = true, AntiRagdollMode = "Không Chuyển Camera" }
RunService.Stepped:Connect(function()
    if not running or not PeteSettings.AntiRagdoll then return end
    local character = LocalPlayer.Character
    local humanoid = H.getHumanoid()
    local root = H.getRoot()
    
    -- FIXED BUG DEATH LOOP
    if not character or not humanoid or not root or humanoid.Health <= 0 then return end
    
    humanoid.PlatformStand = false
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("Motor6D") then v.Enabled = true end
    end
    local vel = root.AssemblyLinearVelocity
    if vel.Y > 30 then root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
end)

-- Speed Changer
local SpeedConfig = { Enabled = false, Value = 300 }
RunService.Stepped:Connect(function()
    if not running or not SpeedConfig.Enabled then return end
    local hum = H.getHumanoid()
    
    -- FIXED BUG DEATH LOOP
    if hum and hum.Health > 0 and hum.WalkSpeed ~= SpeedConfig.Value then 
        hum.WalkSpeed = SpeedConfig.Value 
    end
end)

-- Instant Interact
local InstantHoldEnabled = false
local function ApplyInstantHoldToPrompt(prompt)
    if not InstantHoldEnabled then return end
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if character and prompt:IsDescendantOf(character) then return end
    if backpack and prompt:IsDescendantOf(backpack) then return end
    prompt.HoldDuration = 0
end
Workspace.DescendantAdded:Connect(function(descendant)
    if InstantHoldEnabled and descendant:IsA("ProximityPrompt") then
        task.wait()
        ApplyInstantHoldToPrompt(descendant)
    end
end)
function H.setInstantHold(state)
    InstantHoldEnabled = state
    if state then
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then ApplyInstantHoldToPrompt(prompt) end
        end
    end
end

-- Anti-Trap
local IsTrapImmune = false
local function IsTrapObject(obj)
    local name = string.lower(obj.Name)
    return string.find(name, "trap") or string.find(name, "snare") or string.find(name, "bear_trap") or string.find(name, "playertrap")
end

-- ĐÃ VIẾT HOÀN THIỆN HÀM BỊ CẮT DỞ
local function DeleteAndDisableTrap(obj)
    if not IsTrapImmune then return end
    if IsTrapObject(obj) then
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = false; part.CanCollide = false; part.Transparency = 1
            elseif part:IsA("TouchTransmitter") or part:IsA("Script") or part:IsA("LocalScript") then
                pcall(function() part:Destroy() end)
            end
        end
    end
end

Workspace.DescendantAdded:Connect(function(descendant)
    task.wait()
    DeleteAndDisableTrap(descendant)
end)


-- ============================================================
-- CÀI ĐẶT UI (TÍCH HỢP CHO RAYFIELD / ZEN HUB)
-- ============================================================
-- Vì bạn đang dùng UI Hub (ví dụ: Rayfield), bạn có thể tích hợp đoạn 
-- này vào phần tạo Tab Cài đặt (Settings Tab).
-- Dưới đây là template tạo dropdown ngôn ngữ mẫu:

--[[ 
local SettingsTab = Window:CreateTab(H.GetLang("Settings"), 4483362458) 

local LangDropdown = SettingsTab:CreateDropdown({
    Name = H.GetLang("Language"),
    Options = {"Tiếng Việt", "English"},
    CurrentOption = {"Tiếng Việt"},
    MultipleOptions = false,
    Flag = "LanguageSelector", 
    Callback = function(Option)
        if Option[1] == "English" then
            CurrentLang = "EN"
        else
            CurrentLang = "VN"
        end
        
        -- Rayfield:Notify({
        --     Title = "Zen Hub",
        --     Content = CurrentLang == "EN" and "Language set to English." or "Đã chuyển sang Tiếng Việt.",
        --     Duration = 3
        -- })
        
        -- Cập nhật lại UI sau khi chuyển đổi nếu cần
        -- H.UpdateUILanguage()
    end,
})
--]]