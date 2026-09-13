--[[
    ZenHubX v3 - Steal an Egg
    Standalone UI (no external library)
    Discord: https://discord.gg/vggkAdBcuJ
    TikTok: zenhub.z
    Merged: Anti-Kick + Anti-Cheat Bypass + Visual Pets + Spy Egg ESP
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
    pcall(genv.__ZENHUBX_SHUTDOWN)
    if task then task.wait(0.1) end
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
-- LANGUAGE SYSTEM
-- ============================================================
local LANG = {
    Current = "vi",
    Strings = {
        vi = {
            tabHome = "Trang Chủ", tabFarm = "Farm", tabPets = "Thú Cưng",
            tabProgress = "Tiến Trình", tabPlayer = "Người Chơi",
            tabExtras = "Mở Rộng", tabSystem = "Hệ Thống",
            sectionSession = "Phiên Chơi", sectionAccount = "Tài Khoản",
            sectionQuick = "Hành Động Nhanh", sectionHelp = "Hướng Dẫn",
            sectionSteal = "Cướp Trứng", sectionLifecycle = "Xử Lý Trứng",
            sectionServer = "Đổi Server", sectionPriority = "Thứ Tự Ưu Tiên",
            sectionSettings = "Cài Đặt", sectionSocial = "Liên Kết",
            language = "Ngôn Ngữ", langVN = "Tiếng Việt", langEN = "English",
            copyDiscord = "Sao Chép Discord", copyTikTok = "Sao Chép TikTok",
            copied = "Đã sao chép", ready = "Sẵn sàng - ấn avatar mở menu",
            copy = "Chép",
        },
        en = {
            tabHome = "Home", tabFarm = "Farm", tabPets = "Pets",
            tabProgress = "Progress", tabPlayer = "Player",
            tabExtras = "Extras", tabSystem = "System",
            sectionSession = "Session", sectionAccount = "Account",
            sectionQuick = "Quick Actions", sectionHelp = "Help",
            sectionSteal = "Steal Eggs", sectionLifecycle = "Egg Handling",
            sectionServer = "Server Hop", sectionPriority = "Task Order",
            sectionSettings = "Settings", sectionSocial = "Social",
            language = "Language", langVN = "Tiếng Việt", langEN = "English",
            copyDiscord = "Copy Discord", copyTikTok = "Copy TikTok",
            copied = "Copied", ready = "Ready - press avatar to open",
            copy = "Copy",
        },
    },
}
function L(key) return (LANG.Strings[LANG.Current] and LANG.Strings[LANG.Current][key]) or key end

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