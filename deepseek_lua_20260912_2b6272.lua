--[[
    ZEN HUB X - ULTIMATE MERGED v14.0
    - Fixed return-to-base delay using NonLagStepTeleport
    - Reorganized menu into fewer tabs
    - Full Vietnamese UI with EN/VI toggle
    - Discord: https://discord.gg/HSMcVtMsff
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

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local DISCORD_LINK = "https://discord.gg/HSMcVtMsff"
local DISCORD_CODE = "HSMcVtMsff"
local PurpleColor = Color3.fromHex("#8A2BE2")

-- ============================================================
-- LANGUAGE SYSTEM
-- ============================================================
local Lang = "vi"
local T_ = {
    vi = {
        Tab_Home="Trang chủ", Tab_Farm="Farm Trứng", Tab_Pets="Thú cưng", Tab_Progress="Tiến trình",
        Tab_Player="Nhân vật", Tab_Server="Server", Tab_System="Hệ thống",
        Tag_Merged="v14 - Bản hợp nhất", Tag_Lang="Ngôn ngữ",

        Sec_Steal="Trộm trứng", Sec_StealFilter="Bộ lọc mục tiêu", Sec_Carry="Hành vi cầm trứng",
        Sec_AntiCheat="Vượt Anti-Cheat", Sec_AutoPlace="Tự động đặt trứng", Sec_AutoHatch="Tự động nở trứng",
        Sec_AutoSellEgg="Bán trứng tự động", Sec_PetsOverview="Tổng quan thú cưng", Sec_AutoFuse="Tự động hợp nhất",
        Sec_AutoSellPet="Bán thú cưng tự động", Sec_VisualPet="Thú cưng ảo (chỉ Client)",
        Sec_Upgrades="Nâng cấp", Sec_Rewards="Phần thưởng", Sec_Equipment="Trang bị", Sec_Training="Luyện tập",
        Sec_ESP="ESP", Sec_Movement="Di chuyển", Sec_Teleport="Dịch chuyển",
        Sec_AutoHop="Auto Server Hop", Sec_TaskPriority="Ưu tiên nhiệm vụ",
        Sec_AntiRagdoll="Chống văng / Ragdoll", Sec_AntiTrap="Chống bẫy", Sec_FixLag="Giảm lag",
        Sec_Session="Phiên chơi", Sec_Performance="Hiệu năng", Sec_Webhook="Webhook", Sec_About="Giới thiệu",

        T_AutoStealSelected="Tự trộm theo bộ lọc", TD_AutoStealSelected="Dùng filter bên dưới",
        T_AutoStealAll="Tự trộm TẤT CẢ", TD_AutoStealAll="Bỏ qua rarity/mutation",
        T_StealBigEggs="Trộm trứng to", T_Areas="Khu vực", T_Rarities="Độ hiếm", T_Mutations="Đột biến",
        T_TargetPriority="Ưu tiên mục tiêu", T_MinBigEggSize="Kích thước trứng to tối thiểu",
        T_AutoReturn="Tự về Base", T_AutoDropEgg="Tự thả trứng đang cầm", T_StealNow="Trộm ngay",
        T_BypassAC="Bật Bypass Anti-Cheat + Speed", TD_BypassAC="Clone Humanoid để vượt filter",
        T_WalkSpeedToggle="Bật/Tắt tốc độ chạy", T_MoveSpeed="Tốc độ di chuyển",
        T_SpeedChanger="Đổi tốc độ (Anti-Cheat)", T_VoidUnstuck="Gỡ kẹt bằng Void",
        T_SetBase="Đặt Base tại đây", T_ClearBase="Xoá Base pin",
        T_PlaceSelected="Tự đặt theo bộ lọc", T_PlaceAll="Tự đặt TẤT CẢ",
        T_LifecycleRar="Độ hiếm vòng đời", T_LifecycleMut="Đột biến vòng đời", T_PlaceNow="Đặt ngay",
        T_HatchReady="Tự nở trứng đã sẵn sàng", T_HatchNow="Nở ngay",
        T_SellEggs="Bán trứng tự động", T_SellEggRar="Độ hiếm cần bán", T_SellEggInterval="Chu kỳ bán (giây)",
        T_EquipBest="Tự trang bị tốt nhất", T_HideOwnPet="Ẩn pet render của mình",
        T_AutoFusePets="Tự động hợp nhất pet", T_FuseRar="Độ hiếm hợp nhất", T_FuseMut="Đột biến hợp nhất",
        T_PickGroupBy="Nhóm theo", T_NeverFuseMut="Không hợp nhất đột biến", T_NeverFuseEquip="Không hợp nhất đang trang bị",
        T_AutoReveal="Tự hoàn tất Reveal", T_MaxScaleFuse="Scale tối đa để hợp nhất",
        T_KeepPerType="Giữ mỗi loại", T_FuseInterval="Chu kỳ hợp nhất (giây)", T_FuseNow="Hợp nhất ngay",
        T_SellPets="Bán pet tự động", T_SellRar="Độ hiếm cần bán", T_SellMut="Đột biến cần bán",
        T_NeverSellMut="Không bán đột biến", T_NeverSellEquip="Không bán đang trang bị",
        T_MaxScaleSell="Scale tối đa để bán", T_SellInterval="Chu kỳ bán pet (giây)",
        T_VisualPetPick="Chọn pet", T_RefreshPetList="Làm mới danh sách pet",
        T_CustomName="Tên tuỳ chỉnh", T_OrbitRadius="Bán kính quỹ đạo", T_OrbitSpeed="Tốc độ xoay",
        T_SpawnPet="Spawn pet", T_RemoveLast="Xoá pet cuối", T_RemoveAll="Xoá tất cả",
        T_AutoUpgrades="Tự mua nâng cấp", T_UpgradeTypes="Loại nâng cấp",
        T_ClaimIndex="Tự nhận Index", T_ClaimGroup="Tự nhận thưởng Group", T_ClaimOffline="Nhận thưởng Offline",
        T_BuyTrail="Tự mua Trail", T_Trails="Trails", T_EquipBestTrail="Trang bị Trail tốt nhất",
        T_EquipBestGear="Trang bị Gear tốt nhất", T_AutoTreadmill="Tự luyện Treadmill",
        T_WorldEggEsp="ESP Trứng ngoài map", T_CarriedEggEsp="ESP Trứng cầm/đã thả",
        T_GuardEsp="ESP Guard", T_PetEsp="ESP Pet", T_PlayerEsp="ESP Người chơi",
        T_MachineEsp="ESP Máy móc", T_PlotEsp="ESP Plot", T_RenderDistance="Khoảng cách render",
        T_WalkOverride="Ghi đè tốc độ chạy", T_WalkSpeed="Tốc độ chạy",
        T_JumpOverride="Ghi đè lực nhảy", T_JumpPower="Lực nhảy",
        T_InfJump="Nhảy vô hạn", T_NoClip="Xuyên vật thể", T_Fly="Bay", T_FlySpeed="Tốc độ bay",
        T_Waypoint="Điểm đến", T_TPWaypoint="Dịch chuyển đến điểm", T_DropVoid="Thả xuống Void",
        T_AutoHop="Tự động Hop Server", T_HopWhen="Hop khi", T_WaitBeforeHop="Chờ trước khi hop",
        T_HopNow="Hop ngay", T_Rejoin="Vào lại Server", T_Priority="Ưu tiên",
        T_AntiRagdoll="Chống Ragdoll (Chống văng)", T_AntiTrap="Chống bẫy (Xoá & Ẩn)",
        T_InstantInteract="Bỏ qua ấn giữ (Tương tác tức thì)", T_FixLag="Bật Fix Lag Đất Sét",
        T_AntiAfk="Chống AFK", T_NoGameplayPause="Không dừng Gameplay",
        T_AutoReconnect="Tự kết nối lại", T_FpsBoost="Tăng FPS", T_DisableRender="Tắt render 3D",
        T_FpsCap="Giới hạn FPS", T_WebhookEnabled="Bật Webhook", T_WebhookUrl="URL Webhook",
        T_PingId="ID ping", T_SummaryInterval="Chu kỳ tổng kết (phút)", T_DiscAlert="Cảnh báo mất kết nối",
        T_SendSummary="Gửi tổng kết ngay", T_CopyDiscord="Sao chép link Discord", T_Unload="Tắt Script",
        T_LangSwitch="Ngôn ngữ: Tiếng Việt ▸ Bấm để đổi sang English",
    },
    en = {
        Tab_Home="Home", Tab_Farm="Farm Eggs", Tab_Pets="Pets", Tab_Progress="Progress",
        Tab_Player="Player", Tab_Server="Server", Tab_System="System",
        Tag_Merged="v14 - Merged Build", Tag_Lang="Language",

        Sec_Steal="Steal Eggs", Sec_StealFilter="Target Filters", Sec_Carry="Carry Behavior",
        Sec_AntiCheat="Anti-Cheat Bypass", Sec_AutoPlace="Auto Place", Sec_AutoHatch="Auto Hatch",
        Sec_AutoSellEgg="Auto Sell Eggs", Sec_PetsOverview="Pets Overview", Sec_AutoFuse="Auto Fuse",
        Sec_AutoSellPet="Auto Sell Pets", Sec_VisualPet="Visual Pets (Client Only)",
        Sec_Upgrades="Upgrades", Sec_Rewards="Rewards", Sec_Equipment="Equipment", Sec_Training="Training",
        Sec_ESP="ESP", Sec_Movement="Movement", Sec_Teleport="Teleport",
        Sec_AutoHop="Auto Server Hop", Sec_TaskPriority="Task Priority",
        Sec_AntiRagdoll="Anti-Ragdoll", Sec_AntiTrap="Anti Trap", Sec_FixLag="Fix Lag",
        Sec_Session="Session", Sec_Performance="Performance", Sec_Webhook="Webhooks", Sec_About="About",

        T_AutoStealSelected="Auto Steal Selected", TD_AutoStealSelected="Use filters below",
        T_AutoStealAll="Auto Steal All", TD_AutoStealAll="Ignore rarity/mutation",
        T_StealBigEggs="Steal Big Eggs", T_Areas="Areas", T_Rarities="Rarities", T_Mutations="Mutations",
        T_TargetPriority="Target Priority", T_MinBigEggSize="Minimum Big Egg Size",
        T_AutoReturn="Auto Return to Base", T_AutoDropEgg="Auto Drop Held Egg", T_StealNow="Steal Now",
        T_BypassAC="Bypass Anti-Cheat + Speed", TD_BypassAC="Clone Humanoid to bypass filter",
        T_WalkSpeedToggle="Toggle WalkSpeed", T_MoveSpeed="Move Speed",
        T_SpeedChanger="Speed Changer (Anti-Cheat)", T_VoidUnstuck="Void Unstuck",
        T_SetBase="Set Base Here", T_ClearBase="Clear Base Pin",
        T_PlaceSelected="Auto Place Selected", T_PlaceAll="Auto Place All",
        T_LifecycleRar="Lifecycle Rarities", T_LifecycleMut="Lifecycle Mutations", T_PlaceNow="Place Now",
        T_HatchReady="Auto Hatch Ready", T_HatchNow="Hatch Now",
        T_SellEggs="Auto Sell Eggs", T_SellEggRar="Sell Rarities", T_SellEggInterval="Sell Interval (s)",
        T_EquipBest="Auto Equip Best", T_HideOwnPet="Hide Own Pet Renders",
        T_AutoFusePets="Auto Fuse Pets", T_FuseRar="Fuse Rarities", T_FuseMut="Fuse Mutations",
        T_PickGroupBy="Pick Group By", T_NeverFuseMut="Never Fuse Mutated", T_NeverFuseEquip="Never Fuse Equipped",
        T_AutoReveal="Auto Complete Reveal", T_MaxScaleFuse="Max Scale to Fuse",
        T_KeepPerType="Keep Per Pet Type", T_FuseInterval="Fuse Interval (s)", T_FuseNow="Fuse Now",
        T_SellPets="Auto Sell Pets", T_SellRar="Sell Rarities", T_SellMut="Sell Mutations",
        T_NeverSellMut="Never Sell Mutated", T_NeverSellEquip="Never Sell Equipped",
        T_MaxScaleSell="Max Scale to Sell", T_SellInterval="Sell Interval (s)",
        T_VisualPetPick="Pet", T_RefreshPetList="Refresh Pet List",
        T_CustomName="Custom Name", T_OrbitRadius="Orbit Radius", T_OrbitSpeed="Orbit Speed",
        T_SpawnPet="Spawn Pet", T_RemoveLast="Remove Last", T_RemoveAll="Remove All",
        T_AutoUpgrades="Auto Buy Upgrades", T_UpgradeTypes="Upgrade Types",
        T_ClaimIndex="Auto Claim Index", T_ClaimGroup="Auto Claim Group Reward", T_ClaimOffline="Claim Offline Earnings",
        T_BuyTrail="Auto Buy Trail", T_Trails="Trails", T_EquipBestTrail="Auto Equip Best Trail",
        T_EquipBestGear="Auto Equip Best Gear", T_AutoTreadmill="Auto Treadmill Training",
        T_WorldEggEsp="World Egg ESP", T_CarriedEggEsp="Carried/Dropped Egg ESP",
        T_GuardEsp="Guard ESP", T_PetEsp="Pet ESP", T_PlayerEsp="Player ESP",
        T_MachineEsp="Machine ESP", T_PlotEsp="Plot ESP", T_RenderDistance="Render Distance",
        T_WalkOverride="Walk Speed Override", T_WalkSpeed="Walk Speed",
        T_JumpOverride="Jump Power Override", T_JumpPower="Jump Power",
        T_InfJump="Infinite Jump", T_NoClip="NoClip", T_Fly="Fly", T_FlySpeed="Fly Speed",
        T_Waypoint="Waypoint", T_TPWaypoint="Teleport to Waypoint", T_DropVoid="Drop to Void",
        T_AutoHop="Auto Server Hop", T_HopWhen="Hop When", T_WaitBeforeHop="Wait Before Hop",
        T_HopNow="Hop Now", T_Rejoin="Rejoin Server", T_Priority="Priority",
        T_AntiRagdoll="Anti-Ragdoll", T_AntiTrap="Anti Trap (Delete & Hide)",
        T_InstantInteract="Instant Interact", T_FixLag="Enable Clay Fix Lag",
        T_AntiAfk="Anti-AFK", T_NoGameplayPause="No Gameplay Paused",
        T_AutoReconnect="Auto Reconnect", T_FpsBoost="FPS Boost", T_DisableRender="Disable 3D Rendering",
        T_FpsCap="FPS Cap", T_WebhookEnabled="Enable Webhooks", T_WebhookUrl="Webhook URL",
        T_PingId="Ping User ID", T_SummaryInterval="Summary Interval (min)", T_DiscAlert="Disconnect Alerts",
        T_SendSummary="Send Summary Now", T_CopyDiscord="Copy Discord Link", T_Unload="Unload Script",
        T_LangSwitch="Language: English ▸ Click to switch to Tiếng Việt",
    }
}
local function T(k) local t = T_[Lang] return t[k] or T_["vi"][k] or k end

-- ============================================================
-- COMPAT
-- ============================================================
if type(table.pack) ~= "function" then function table.pack(...) return { n = select("#", ...), ... } end end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then function math.clamp(v,mn,mx) if v<mn then return mn elseif v>mx then return mx end return v end end
if type(table.find) ~= "function" then function table.find(t,v,init) if type(t)~="table" then return nil end for i=tonumber(init) or 1,#t do if t[i]==v then return i end end return nil end end

if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
-- ANTI-CHEAT KICKER
-- ============================================================
if type(getgc)=="function" and type(getrawmetatable)=="function" and type(setmetatable)=="function" then
    pcall(function()
        for _, obj in getgc(true) do
            if typeof(obj) ~= "table" or getrawmetatable(obj) then continue end
            local mainrun = false
            for _, v in obj do if v == obj then mainrun = true break end end
            if not mainrun then continue end
            for _, v in obj do
                if typeof(v) == "number" and v >= 1 and v <= 3 and obj[v] == nil then
                    setmetatable(obj, {__newindex = function() end}); break
                end
            end
        end
    end)
end

-- ============================================================
-- DISCORD VERIFY
-- ============================================================
local isVerified = false
local function CreateVerify()
    local Gui = Instance.new("ScreenGui"); Gui.Name="DiscordVerificationGui"; Gui.ResetOnSpawn=false
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.fromOffset(340,220); Frame.Position = UDim2.new(0.5,-170,0.5,-110)
    Frame.BackgroundColor3 = Color3.fromRGB(20,20,30); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    local St = Instance.new("UIStroke", Frame); St.Color = PurpleColor; St.Thickness = 2
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1,0,0,40); Title.BackgroundTransparency = 1
    Title.Text = "ZEN HUB X - XÁC MINH DISCORD"; Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 14; Title.Font = Enum.Font.GothamBold
    local D = Instance.new("TextLabel", Frame)
    D.Size = UDim2.new(1,-30,0,50); D.Position = UDim2.fromOffset(15,40); D.BackgroundTransparency = 1
    D.Text = "Tham gia Discord để dùng Script!"; D.TextColor3 = Color3.fromRGB(180,190,210)
    D.TextSize = 12; D.TextWrapped = true; D.Font = Enum.Font.Gotham
    local JB = Instance.new("TextButton", Frame)
    JB.Size = UDim2.new(1,-40,0,38); JB.Position = UDim2.fromOffset(20,100)
    JB.BackgroundColor3 = Color3.fromRGB(88,101,242); JB.Text = "1. Tham Gia Discord"
    JB.TextColor3 = Color3.fromRGB(255,255,255); JB.TextSize = 13; JB.Font = Enum.Font.GothamBold
    Instance.new("UICorner", JB).CornerRadius = UDim.new(0,8)
    local VB = Instance.new("TextButton", Frame)
    VB.Size = UDim2.new(1,-40,0,38); VB.Position = UDim2.fromOffset(20,150)
    VB.BackgroundColor3 = Color3.fromRGB(40,160,90); VB.Text = "2. Xác Minh & Bắt Đầu"
    VB.TextColor3 = Color3.fromRGB(255,255,255); VB.TextSize = 13; VB.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VB).CornerRadius = UDim.new(0,8)
    local joined = false
    JB.MouseButton1Click:Connect(function()
        joined = true
        if setclipboard then setclipboard(DISCORD_LINK) end
        local req = request or http_request or (syn and syn.request)
        if req then pcall(function() req({Url="http://127.0.0.1:6463/rpc?v=1",Method="POST",
            Headers={["Content-Type"]="application/json",["Origin"]="https://discord.com"},
            Body=HttpService:JSONEncode({cmd="INVITE_BROWSER",args={code=DISCORD_CODE},nonce=HttpService:GenerateGUID(false)})}) end) end
        JB.Text = "✓ Đã Sao Chép Link!"
    end)
    VB.MouseButton1Click:Connect(function()
        if joined then isVerified = true; Gui:Destroy()
        else VB.Text = "⚠️ Nhấp Nút 1 trước!"; task.wait(1.5); VB.Text = "2. Xác Minh & Bắt Đầu" end
    end)
end
CreateVerify()
repeat task.wait(0.1) until isVerified

-- ============================================================
-- WINDUI LOAD
-- ============================================================
local WindUI
do
    local ok, result = pcall(function() return require("./src/Init") end)
    if ok then WindUI = result
    else
        if cloneref(RunService):IsStudio() then WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))() end
    end
end

-- ============================================================
-- APEX CORE
-- ============================================================
local H = {}
function H.cloneList(s) local o={} if type(s)~="table" then return o end for i=1,#s do o[i]=s[i] end return o end
function H.clearTable(t) if type(t)~="table" then return end for k in pairs(t) do t[k]=nil end end

local running = true
function H.waitFor(timeout, interval, check)
    local dl = os.clock() + (tonumber(timeout) or 1); local gap = tonumber(interval) or 0.05; local pass=false
    repeat if check and check()==true then pass=true elseif running and os.clock()<dl then task.wait(gap) end
    until pass or (not running) or os.clock()>=dl; return pass
end
function H.requirePath(root, timeout, ...)
    local cur = root
    for _, name in ipairs({...}) do if not cur then return nil end
        local c = cur:FindFirstChild(name); if not c then c = cur:WaitForChild(name, timeout or 4) end; cur = c end
    if not cur then return nil end
    local ok, mod = pcall(require, cur); return ok and mod or nil
end
function H.findModule(name)
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("ModuleScript") and d.Name==name then local ok,m=pcall(require,d); if ok then return m end end
    end
end
function H.findRemote(name)
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and d.Name==name then return d end
    end
end
function H.findRemoteContains(...)
    local parts = {...}
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
            local ok=true; for _,p in ipairs(parts) do if not string.find(d.Name,p,1,true) then ok=false break end end
            if ok then return d end
        end
    end
end
function H.pickFromTable(t,...) if typeof(t)~="table" then return nil end local cur=t
    for _,n in ipairs({...}) do if typeof(cur)~="table" then return nil end cur=cur[n] end; return cur end
function H.pickFn(m,...) if typeof(m)~="table" then return nil end
    for i=1,select("#",...) do local k=select(i,...); if typeof(m[k])=="function" then return m[k] end end end
function H.remoteFrom(m,...) local i=H.pickFromTable(m,...); if typeof(i)=="Instance" then return i end end

local SaveModule = H.requirePath(ReplicatedStorage,6,"Shared","Save") or H.findModule("Save")
local Constants = H.requirePath(ReplicatedStorage,4,"Shared","Globals","Constants") or H.findModule("Constants")
local BaseUpgradeModule = H.requirePath(ReplicatedStorage,4,"Client","BaseUpgrade") or H.findModule("BaseUpgrade")
local EggTypes = H.requirePath(ReplicatedStorage,4,"Shared","Types","Eggs") or H.findModule("Eggs")
local AreasModule = H.requirePath(ReplicatedStorage,4,"Data","Areas") or H.findModule("Areas")
local AssetsData = H.requirePath(ReplicatedStorage,4,"Data","Assets") or H.findModule("Assets")
local GearsModule = H.requirePath(ReplicatedStorage,4,"Data","Gears") or H.findModule("Gears")
local TrailsModule = H.requirePath(ReplicatedStorage,4,"Data","Trails") or H.findModule("Trails")
local TreadmillsData = H.requirePath(ReplicatedStorage,4,"Data","Treadmills") or H.findModule("Treadmills")
local EggStateModule = H.requirePath(ReplicatedStorage,6,"Client","EggState") or H.findModule("EggState")
local PlotStateModule = H.requirePath(ReplicatedStorage,6,"Client","PlotState") or H.findModule("PlotState")
local SlotIdentityModule = H.requirePath(ReplicatedStorage,4,"Shared","Util","AreaEggSlotIdentity") or H.findModule("AreaEggSlotIdentity")
local AssetRosterModule = H.requirePath(ReplicatedStorage,4,"Client","AssetRoster") or H.findModule("AssetRoster")
local AssetItemsModule = H.requirePath(ReplicatedStorage,4,"Shared","Util","AssetItems") or H.findModule("AssetItems")
local FuseKernelModule = H.requirePath(ReplicatedStorage,4,"Shared","Util","FuseKernel") or H.findModule("FuseKernel")
local RemotesModule = H.requirePath(ReplicatedStorage,6,"Shared","Remotes") or H.findModule("Remotes")

local EggApi = {
    GetAreaEggSnapshot=H.pickFn(EggStateModule,"ReadFieldEggs","GetAreaEggSnapshot"),
    RequestAreaEggSnapshot=H.pickFn(EggStateModule,"SyncFieldEggs","RequestAreaEggSnapshot"),
    AreaEggCarryStateChanged=EggStateModule and (EggStateModule.CarryChanged or EggStateModule.AreaEggCarryStateChanged),
    RequestCarryAreaEgg=H.pickFn(EggStateModule,"CarryFieldEgg","RequestCarryAreaEgg"),
    RequestDropHeldAreaEgg=H.pickFn(EggStateModule,"DropFieldEgg","RequestDropHeldAreaEgg"),
    IsLocalEggReady=H.pickFn(EggStateModule,"IsReadyToHatch","IsLocalEggReady"),
    RequestHatchEgg=H.pickFn(EggStateModule,"BeginHatch","RequestHatchEgg"),
    RequestCompleteHatchEgg=H.pickFn(EggStateModule,"FinishHatch","RequestCompleteHatchEgg"),
    RequestEquipTool=H.pickFn(EggStateModule,"WearEggTool","RequestEquipTool"),
    RequestPlaceEgg=H.pickFn(EggStateModule,"PlantEgg","RequestPlaceEgg"),
}
local PlotApi = {
    GetRespawnPointCFrame=H.pickFn(PlotStateModule,"FindRespawnCFrame","GetRespawnPointCFrame"),
    GetPlotData=H.pickFn(PlotStateModule,"ResolvePlot","GetPlotData"),
    IsWorldPositionWithinLocalPlotBounds=H.pickFn(PlotStateModule,"ContainsLocalPoint","IsWorldPositionWithinLocalPlotBounds"),
    GetSlotOwner=H.pickFn(PlotStateModule,"LookupOwner","GetSlotOwner"),
}
local SlotIdentityApi = {
    IsFirstAreaUid=H.pickFn(SlotIdentityModule,"LooksLikeFirstAreaUid","IsFirstAreaUid"),
    BuildSlotKey=H.pickFn(SlotIdentityModule,"SlotKey","BuildSlotKey"),
}
local AssetRosterApi = { GetRuntimeSnapshot=H.pickFn(AssetRosterModule,"ReadSnapshot","GetRuntimeSnapshot") }
local AssetItemsApi = { Deserialize=H.pickFn(AssetItemsModule,"Decode","Deserialize") }
local FuseApi = {
    CanSelectPet=H.pickFn(FuseKernelModule,"MayEnterFuse","CanSelectPet"),
    CalculateFusePrice=H.pickFn(FuseKernelModule,"PriceFor","CalculateFusePrice"),
}

local Remotes = {
    Backpack={ EQUIP_BEST=H.remoteFrom(RemotesModule,"Haul","WearBest") or H.findRemoteContains("WearBest") or H.findRemoteContains("EQUIP_BEST") },
    Plots={ REQUEST_BASE_UPGRADE=H.remoteFrom(RemotesModule,"Homestead","AskBaseTierRaise") or H.findRemoteContains("AskBaseTierRaise") },
    Treadmills={
        REQUEST_UPGRADE=H.remoteFrom(RemotesModule,"Treadmill","AskTierRaise") or H.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC=H.remoteFrom(RemotesModule,"Treadmill","AskWearStill") or H.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP=H.remoteFrom(RemotesModule,"Treadmill","AskDoff") or H.findRemoteContains("AskDoff"),
    },
    Index={ REQUEST_CLAIM_ALL=H.remoteFrom(RemotesModule,"Codex","AskRedeemAll") or H.findRemoteContains("AskRedeemAll") },
    AssetInventory={ SELL_ASSET=H.remoteFrom(RemotesModule,"PetSatchel","SellPet") or H.findRemoteContains("SellPet") },
    OfflineAssets={
        GET_SUMMARY=H.remoteFrom(RemotesModule,"AwayEarnings","FetchSummary") or H.findRemoteContains("FetchSummary"),
        REQUEST_REDEEM=H.remoteFrom(RemotesModule,"AwayEarnings","AskCollect") or H.findRemoteContains("AskCollect"),
    },
    FuseMachine={
        COMPLETE_REVEAL=H.remoteFrom(RemotesModule,"Fusery","FinishReveal") or H.findRemoteContains("FinishReveal"),
        ACKNOWLEDGE_INFO=H.remoteFrom(RemotesModule,"Fusery","ConfirmBriefing") or H.findRemoteContains("ConfirmBriefing"),
        INSERT_MOB=H.remoteFrom(RemotesModule,"Fusery","LoadPet") or H.findRemoteContains("LoadPet"),
        START_FUSE=H.remoteFrom(RemotesModule,"Fusery","BeginFuse") or H.findRemoteContains("BeginFuse"),
    },
    Trails={
        REQUEST_PURCHASE=H.remoteFrom(RemotesModule,"Trailwear","AskPurchase") or H.findRemoteContains("AskPurchase"),
        REQUEST_SELECT=H.remoteFrom(RemotesModule,"Trailwear","AskChoose") or H.findRemoteContains("AskChoose"),
        WORN_SNAPSHOT=H.remoteFrom(RemotesModule,"Trailwear","AskWornSnapshot") or H.findRemoteContains("AskWornSnapshot"),
    },
    GroupReward={ CLAIM_REWARD=H.remoteFrom(RemotesModule,"GroupPerk","RedeemPerk") or H.findRemoteContains("RedeemPerk") },
}

local CarryRemote = H.findRemote("RF/EggWorld/AskFieldEggCarry") or H.findRemoteContains("AskFieldEggCarry")
local SnapshotRemote = H.findRemote("RF/EggWorld/AskFieldEggSnapshot") or H.findRemoteContains("AskFieldEggSnapshot")
local PlaceRemote = H.findRemote("RF/EggWorld/AskPlaceEgg") or H.findRemoteContains("AskPlaceEgg")
local NetPackages = ReplicatedStorage:FindFirstChild("Packages")
NetPackages = NetPackages and NetPackages:FindFirstChild("Networking") or nil
local function GetRemote(name) return NetPackages and NetPackages:FindFirstChild(name) or nil end

-- ============================================================
-- CONSTANTS
-- ============================================================
local RARITIES = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
local RarityWeight = {Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythic=6,Cosmic=7,Secret=8,Eternal=9,Divine=10}
local MUTATIONS = {"Golden","Rainbow","Silver"}
local STEAL_PRIORITIES = {"Rarest","Nearest","Furthest","Biggest Size"}
local FUSE_TARGET_MODES = {"Highest Rarity","Lowest Rarity","Most Duplicates"}
local UPGRADE_TYPES = {"Base","Treadmill"}
local PriorityTaskNames = {"Auto Steal Egg","Auto Place Egg","Auto Hatch","Auto Treadmill"}
local PrioritySlotOptionNames = {"PrioritySlot1","PrioritySlot2","PrioritySlot3","PrioritySlot4"}
local ServerHopModes = {"No Matching Eggs","Timed Interval","After Steal Count"}
local AREA_ORDER = {"Forest","Lake","Desert","Jungle","Snow","Volcano","Abyss Ocean","Prehistoric","Cosmic"}

local AreaNames = {}
if AreasModule and typeof(AreasModule.Directory)=="table" then
    for n in pairs(AreasModule.Directory) do table.insert(AreaNames,n) end; table.sort(AreaNames)
else AreaNames = H.cloneList(AREA_ORDER) end

local TrailNames, TrailIdByName, TrailPriceByName = {},{},{}
if TrailsModule and typeof(TrailsModule.Directory)=="table" then
    local es = {}
    for id,d in pairs(TrailsModule.Directory) do table.insert(es,{id=id,name=d.DisplayName,price=tonumber(d.Price) or 0}) end
    table.sort(es,function(a,b) return a.price<b.price end)
    for _,e in ipairs(es) do table.insert(TrailNames,e.name); TrailIdByName[e.name]=e.id; TrailPriceByName[e.name]=e.price end
end

local GearCostByName = {}
if GearsModule then
    local gd = GearsModule.Directory or GearsModule
    if typeof(gd)=="table" then
        for _,g in pairs(gd) do if typeof(g)=="table" and typeof(g.DisplayName)=="string" then GearCostByName[g.DisplayName]=tonumber(g.MoneyCost) or 0 end end
    end
end

-- ============================================================
-- STATE
-- ============================================================
local DEFAULT_STEAL_SPEED = 800
local BYPASS_SPEED = 900
local BASE_RETURN_ARRIVE = 4
local STEAL_HOLD_TIME = 3
local StealConfig = { GrabDelay=0.55, ReturnPace=0.12, ArriveDistance=1.35, MoveTimeout=14 }

local conns = {}
local CurrentJobId = tostring(game.JobId)
local DisplayJobId = CurrentJobId
if #DisplayJobId>18 then DisplayJobId=string.sub(DisplayJobId,1,18).."..." end

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
local FpsBoostSnapshot = nil
local FpsDescendantAddedConnection = nil
local SessionStartedAt = os.clock()
local LastWebhookSummaryAt = os.clock()
local KnownWorldEggUids, KnownInventoryUids = {},{}
local WebhookTrackerInitialized = false
local LastRebirthSnapshot = nil
local LastStealCountSnapshot = 0
local SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0,0,0
local SpawnedEggLog, ObtainedEggLog = {},{}
local EspEntries, EspSeenThisPass = {},{}

local HumReady = false
local IsBypassing = false
local ManualBase = nil
local SpeedValue = 60
local OriginalSpeed = 16
local VoidUnstuck = false
local VisualPetsSpawned = {}
local VisualPetFolder = Instance.new("Folder"); VisualPetFolder.Name="ZenHubX_VisualPets"; VisualPetFolder.Parent=Workspace
local VisitedServerIds = {}
if getgenv then
    local h = getgenv().ZenHubXHopHistory
    if typeof(h)~="table" then h={}; getgenv().ZenHubXHopHistory=h end
    VisitedServerIds = h
end

local AreasFolder = Workspace:FindFirstChild("__OBJECTS") and Workspace.__OBJECTS:FindFirstChild("Areas")
if not AreasFolder then local o = Workspace:WaitForChild("__OBJECTS",8); AreasFolder = o and o:WaitForChild("Areas",8) end
local GuardAreasFolder = AreasFolder and AreasFolder:FindFirstChild("GuardAreas")
if AreasFolder and not GuardAreasFolder then GuardAreasFolder = AreasFolder:WaitForChild("GuardAreas",6) end

local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")
if not AreaEggSlotsClient then AreaEggSlotsClient = Workspace:WaitForChild("AreaEggSlotsClient",10) end

local EspFolder = Instance.new("Folder"); EspFolder.Name="ZenHubX_Esp"; EspFolder.Parent=Workspace

function H.track(c) table.insert(conns,c); return c end

-- ============================================================
-- HELPERS
-- ============================================================
function H.getHumanoid() local c=LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") or nil end
function H.getRoot() local c=LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") or nil end
function H.getSave() if not SaveModule or typeof(SaveModule.Get)~="function" then return nil end
    local ok,s=pcall(SaveModule.Get); return ok and s or nil end
function H.netInvoke(r,...)
    if typeof(r)~="Instance" then return nil end
    local args=table.pack(...); local res,done=nil,false
    task.spawn(function()
        if r:IsA("RemoteFunction") then res=table.pack(pcall(function() return r:InvokeServer(table.unpack(args,1,args.n)) end))
        elseif r:IsA("RemoteEvent") then res=table.pack(pcall(function() r:FireServer(table.unpack(args,1,args.n)); return true end))
        else res=table.pack(false) end; done=true
    end)
    H.waitFor(8,0.05,function() return done==true end)
    if not done or res[1]~=true then return nil end; return res[2],res[3]
end
function H.netCall(r,...)
    if typeof(r)=="Instance" and r:IsA("RemoteEvent") then return pcall(function(...) r:FireServer(...) end,...) end
    return H.netInvoke(r,...)
end
function H.countTable(v) if typeof(v)~="table" then return 0 end local c=0 for _ in pairs(v) do c=c+1 end return c end
function H.formatNumber(v)
    local n=tonumber(v) or 0; local s={"","K","M","B","T","Qa","Qi"}; local i=1
    for _=1,6 do if n>=1000 then n=n/1000; i=i+1 end end
    if i==1 then return string.format("%d",n) end; return string.format("%.2f%s",n,s[i])
end
function H.formatElapsed(s) local t=math.max(0,math.floor(s)); local h=math.floor(t/3600); local m=math.floor((t%3600)/60)
    if h>0 then return string.format("%dh %dm",h,m) end; return string.format("%dm",m) end
function H.resolveRarity(cat)
    if typeof(cat)~="string" or not AssetsData or typeof(AssetsData.Directory)~="table" then return nil end
    local e=AssetsData.Directory[cat]; local r=e and e.Rarity; if not r then return nil end
    return r._id or r.DisplayName
end
function H.assetName(cat)
    if AssetsData and typeof(AssetsData.Directory)=="table" then local e=AssetsData.Directory[cat or ""]; if e and e.DisplayName then return e.DisplayName end end
    return tostring(cat or "Unknown")
end
function H.recordMutations(a)
    local m={}; if typeof(a)~="table" then return m end
    if typeof(a.Mutations)=="table" then for _,x in pairs(a.Mutations) do if typeof(x)=="string" then table.insert(m,x) end end end
    if typeof(a.BaseMutation)=="string" then table.insert(m,a.BaseMutation) end; return m
end
function H.getLaneZ()
    if AreasFolder then local g=AreasFolder:FindFirstChild("GameplayZ"); if g and g:IsA("BasePart") then return g.Position.Z end
        local s=AreasFolder:FindFirstChild("SeparationLine"); if s and s:IsA("BasePart") then return s.Position.Z end end
    return -365.5
end
function H.getLaneY()
    if AreasFolder then local g=AreasFolder:FindFirstChild("GameplayZ"); if g and g:IsA("BasePart") then return g.Position.Y+3 end end
    local r=H.getRoot(); return r and r.Position.Y or 70
end
function H.getEntryPosition()
    if AreasFolder then
        local s=AreasFolder:FindFirstChild("StartArea"); if s and s:IsA("BasePart") then return Vector3.new(s.Position.X,H.getLaneY(),H.getLaneZ()) end
        local sl=AreasFolder:FindFirstChild("SeparationLine"); if sl and sl:IsA("BasePart") then return Vector3.new(sl.Position.X,H.getLaneY(),H.getLaneZ()) end
    end
    return Vector3.new(543.5,H.getLaneY(),H.getLaneZ())
end
function H.getZoneModel(n) return GuardAreasFolder and GuardAreasFolder:FindFirstChild(n) end
function H.getZoneLaneCenter(n)
    local z=H.getZoneModel(n); if not z then return nil end
    local b=z:FindFirstChild("Bounds"); if b and b:IsA("BasePart") then return Vector3.new(b.Position.X,H.getLaneY(),H.getLaneZ()) end
    local ok,p=pcall(function() return z:GetBoundingBox() end); if ok and p then return Vector3.new(p.Position.X,H.getLaneY(),H.getLaneZ()) end
end
function H.stripCheatMovers(root)
    if not root then return end
    for _,i in ipairs(root:GetChildren()) do
        local c=i.ClassName
        if c=="BodyVelocity" or c=="BodyPosition" or c=="BodyGyro" or c=="BodyAngularVelocity" or c=="LinearVelocity" or c=="VectorForce" or c=="AlignOrientation" then
            pcall(function() i:Destroy() end)
        end
    end
end
function H.stopSoftMove(root)
    if not root then return end
    for _,i in ipairs(root:GetChildren()) do if i:IsA("AlignPosition") then pcall(function() i.Enabled=false; i:Destroy() end) end end
end
function H.placeRoot(root, cf)
    if not root or not cf then return end
    H.stopSoftMove(root); H.stripCheatMovers(root)
    local c=LocalPlayer.Character
    if c and c.Parent then pcall(function() c:PivotTo(cf) end) else root.CFrame=cf end
end
function H.stealSpeed() return DEFAULT_STEAL_SPEED end
function H.getBasePosition()
    if PlotApi.GetRespawnPointCFrame then local r=PlotApi.GetRespawnPointCFrame(); if r then return r.Position end end
    if not PlotApi.GetPlotData then return nil end
    local p=PlotApi.GetPlotData(); if not p then return nil end
    if p.CenterPoint then return p.CenterPoint.Position end
    if p.PetArea then return p.PetArea.Position end
end
function H.getPetAreaStandPosition()
    if PlotApi.GetPlotData then local p=PlotApi.GetPlotData(); if p and p.PetArea then return p.PetArea.Position+Vector3.new(0,4,0) end end
    return H.getBasePosition()
end
function H.isNearPlot()
    local r=H.getRoot(); if not r then return false end
    if PlotApi.IsWorldPositionWithinLocalPlotBounds and PlotApi.IsWorldPositionWithinLocalPlotBounds(r.Position) then return true end
    local s=H.getPetAreaStandPosition(); return s~=nil and (r.Position-s).Magnitude<=30
end

-- ============================================================
-- 🔥 FIXED: NON-LAG STEP TELEPORT (from user's code, adapted)
-- ============================================================
local FarmConfig = { TeleportStep = 18, TeleportDelay = 0.04, AutoFarmEgg = false }

local function HasItemAcquired()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char and char:FindFirstChildOfClass("Tool") then return true end
    if backpack and #backpack:GetChildren() > 0 then return true end
    return false
end

local function NonLagStepTeleport(targetCFrame, checkDrop)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    local stepSize = FarmConfig.TeleportStep or 18
    local stepDelay = FarmConfig.TeleportDelay or 0.04
    local startPos = hrp.Position
    local targetPos = targetCFrame.Position
    local dist = (targetPos - startPos).Magnitude

    if dist <= 3 then hrp.CFrame = targetCFrame; return true end

    local dir = (targetPos - startPos).Unit
    local totalSteps = math.ceil(dist / stepSize)
    local success = true

    pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)

    for i = 1, totalSteps do
        if not running then success = false; break end
        if checkDrop and not HasItemAcquired() then success = false; break end

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
    end
    return success
end

-- ============================================================
-- EGG / STEAL (updated with NonLagStepTeleport + wait for server confirm)
-- ============================================================
function H.getAreaEggs()
    if not EggApi.GetAreaEggSnapshot then return {} end
    local s = EggApi.GetAreaEggSnapshot()
    if typeof(s)~="table" or typeof(s.Records)~="table" then
        if EggApi.RequestAreaEggSnapshot then pcall(EggApi.RequestAreaEggSnapshot) end
        s = EggApi.GetAreaEggSnapshot()
    end
    if typeof(s)~="table" or typeof(s.Records)~="table" then return {} end
    local recs = {}
    for _,r in pairs(s.Records) do if typeof(r)=="table" and typeof(r.Uid)=="string" then table.insert(recs,r) end end
    return recs
end
function H.findAreaEggRecord(uid) for _,r in ipairs(H.getAreaEggs()) do if r.Uid==uid then return r end end end
function H.getSlotEggPosition(inst)
    local p = inst:FindFirstChild("Hitbox") or inst:FindFirstChild("CustomBoundingBox") or inst:FindFirstChildOfClass("BasePart")
    if p then return p.Position end
    return inst:GetPivot().Position
end
function H.isBigEgg(e)
    if not H.isOn("StealBigEggs") then return false end
    local s=tonumber(e.AssetScale); if not s then return false end
    return s >= (tonumber(H.optionValue("StealBigEggScale",1.5)) or 1.5)
end
function H.eggScore(e) return RarityWeight[H.resolveRarity(e.AssetCategory) or "Common"] or 0 end
function H.isStealCandidate(r, bypass)
    if typeof(r)~="table" or typeof(r.Uid)~="string" then return false end
    if r.State~="Slot" and r.State~="Dropped" then return false end
    if bypass then return true end
    if H.isBigEgg(r) and H.selectionAllows("StealZones",r.AreaId) then return true end
    if not H.isOn("AutoStealSelected") then return false end
    return H.matchesEggFilters(r,"StealZones","StealRarities","StealMutations")
end
function H.pickStealTarget()
    local we = AreaEggSlotsClient and AreaEggSlotsClient:GetChildren() or {}
    if #we==0 then return nil end
    local byUid = {}
    for _,r in ipairs(H.getAreaEggs()) do if typeof(r.Uid)=="string" then byUid[r.Uid]=r end end
    local bypass = H.isOn("AutoStealAll") and not H.isOn("AutoStealSelected")
    local root = H.getRoot()
    local prio = H.optionValue("StealPriority","Rarest")
    local best, bs = nil, -math.huge
    for _,i in ipairs(we) do
        local r = byUid[i.Name]
        local cand = r and H.isStealCandidate(r,bypass) or (r==nil and bypass)
        if cand then
            local p = H.getSlotEggPosition(i)
            local d = root and p and (root.Position-p).Magnitude or math.huge
            local sc
            if prio=="Nearest" then sc=-d
            elseif prio=="Furthest" then sc=d
            elseif prio=="Biggest Size" then sc=tonumber(r and r.AssetScale) or 0
            else sc=(r and H.eggScore(r) or 0)*100000 - math.min(d,99999) end
            if sc>bs then best=i; bs=sc end
        end
    end
    return best
end
function H.stealingEnabled() return H.isOn("AutoStealSelected") or H.isOn("AutoStealAll") or H.isOn("StealBigEggs") end
function H.eggInventoryCount()
    local s=H.getSave(); local i=s and s.EggInventory
    if typeof(i)~="table" then return 0 end; return H.countTable(i)
end
function H.eggInventoryFull()
    local c=EggTypes and tonumber(EggTypes.MAX_INVENTORY) or math.huge
    return H.eggInventoryCount()>=c
end
function H.canAutoSteal() return H.stealingEnabled() and not IsCarryingEgg and not H.eggInventoryFull() end
function H.tryCarryEgg(eggInst)
    if not eggInst or not EggApi.RequestCarryAreaEgg then return false end
    local uid = eggInst.Name
    local slotKey = nil
    if SlotIdentityApi.IsFirstAreaUid and SlotIdentityApi.IsFirstAreaUid(uid) then
        for _,r in ipairs(H.getAreaEggs()) do if r.Uid==uid and SlotIdentityApi.BuildSlotKey then slotKey=SlotIdentityApi.BuildSlotKey(r.AreaId,r.NestId) break end end
    end
    local ok,car = pcall(function() return EggApi.RequestCarryAreaEgg(uid,slotKey) end)
    if ok and car==true then return true end
    return IsCarryingEgg
end

-- ✅ FIXED stealEgg with NonLagStepTeleport + proper wait for server
function H.stealEgg(slotEgg)
    if not slotEgg then return false end
    local targetPos = H.getSlotEggPosition(slotEgg)
    if not targetPos then return false end
    local uid = slotEgg.Name

    -- Save current position as base reference
    local root = H.getRoot()
    if not root then return false end
    local baseCF = H.getBasePosition()
    local baseFrame = baseCF and CFrame.new(baseCF.X, baseCF.Y+3, baseCF.Z) or root.CFrame

    -- STEP 1: Teleport to egg (fast, no drop check)
    if not NonLagStepTeleport(CFrame.new(targetPos), false) then return false end

    -- STEP 2: Fire carry remote
    local carryRemote = GetRemote("RF/EggWorld/AskFieldEggCarry") or CarryRemote
    if carryRemote then
        if carryRemote:IsA("RemoteFunction") then
            pcall(function() carryRemote:InvokeServer({Uid = uid}) end)
        else
            pcall(function() carryRemote:FireServer({Uid = uid}) end)
        end
    end
    H.tryCarryEgg(slotEgg)

    -- STEP 3: WAIT for server to confirm carry (poll up to 5s, tight loop)
    local waitStart = os.clock()
    local confirmed = false
    while os.clock() - waitStart < 5 and running do
        if IsCarryingEgg or HasItemAcquired() then confirmed = true; break end
        task.wait(0.05)
    end
    if not confirmed then return false end

    -- STEP 4: Small extra wait for physics/tool to settle before teleporting back
    task.wait(0.35)

    -- STEP 5: Teleport back to base with drop check
    if not NonLagStepTeleport(baseFrame, true) then return false end

    -- STEP 6: Wait for the drop/carry state to clear (server-side plant)
    local plantStart = os.clock()
    while os.clock() - plantStart < 4 and running do
        if not IsCarryingEgg and not HasItemAcquired() then break end
        -- Try to place again while waiting
        if EggApi.RequestPlaceEgg then
            local places = H.getPlacementLocalCFrames and H.getPlacementLocalCFrames() or {}
            if #places > 0 then
                local pi = (NextPlacementIndex - 1) % #places + 1
                pcall(function() EggApi.RequestPlaceEgg(uid, places[pi]) end)
            end
        end
        task.wait(0.2)
    end

    H.holdAtPosition(0.3, function() return running end)
    return true
end

function H.runAutoSteal()
    if IsCarryingEgg or H.eggInventoryFull() then return false end
    local t = H.pickStealTarget()
    if not t then return false end
    return H.stealEgg(t)
end
function H.runAutoDropEgg()
    if not IsCarryingEgg then return false end
    if EggApi.RequestDropHeldAreaEgg then return pcall(function() EggApi.RequestDropHeldAreaEgg("PlayerRequest") end) end
    return false
end
function H.runAutoReturn()
    if not IsCarryingEgg then return false end
    local base = H.getBasePosition(); if not base then return false end
    return NonLagStepTeleport(CFrame.new(base.X,base.Y+3,base.Z), true)
end

if EggApi.AreaEggCarryStateChanged and typeof(EggApi.AreaEggCarryStateChanged.Connect)=="function" then
    H.track(EggApi.AreaEggCarryStateChanged:Connect(function(st)
        local now = typeof(st)=="table" and st.IsCarrying==true
        local started = now and not IsCarryingEgg
        if started then SessionStolenEggs=SessionStolenEggs+1; if CarryStartedCallback then CarryStartedCallback(st) end end
        IsCarryingEgg = now
    end))
end

-- Place / Hatch / Sell / Fuse / Upgrades
function H.getUnplacedEggUids()
    local s=H.getSave(); local i=s and s.EggInventory; local r={}
    if typeof(i)~="table" then return r end
    local bypass = H.isOn("AutoPlaceAll") and not H.isOn("AutoPlaceSelected")
    for uid,e in pairs(i) do
        if typeof(uid)=="string" and typeof(e)=="table" and e.Placement==nil
            and (bypass or H.matchesEggFilters(e,nil,"LifecycleRarities","LifecycleMutations")) then table.insert(r,uid) end
    end
    return r
end
function H.placingEnabled() return H.isOn("AutoPlaceSelected") or H.isOn("AutoPlaceAll") end
function H.isPlotFull() return os.clock()<PlotFullUntil end
function H.markPlotFull() PlotFullUntil=os.clock()+30 end
function H.getPlacementLocalCFrames()
    if not PlotApi.GetPlotData then return {} end
    local p=PlotApi.GetPlotData(); if not p or not p.PetArea or not p.CenterPoint then return {} end
    local pa,cp = p.PetArea, p.CenterPoint; local sz=pa.Size; local pl={}
    for x=-sz.X*0.5+5,sz.X*0.5-5,7 do for z=-sz.Z*0.5+5,sz.Z*0.5-5,7 do
        local wp = pa.CFrame:PointToWorldSpace(Vector3.new(x,1,z))
        table.insert(pl, cp.CFrame:ToObjectSpace(CFrame.new(wp)))
    end end
    return pl
end
function H.canAutoPlace() return H.placingEnabled() and not IsCarryingEgg and not H.isPlotFull() and #H.getUnplacedEggUids()>0 end
function H.runAutoPlaceEggs(forceRun)
    if IsCarryingEgg or not EggApi.RequestPlaceEgg then return end
    local function cont() return (forceRun==true or H.placingEnabled()) and not IsCarryingEgg end
    local unp = H.getUnplacedEggUids(); if #unp==0 then return end
    if not H.isNearPlot() then
        local base=H.getBasePosition(); if base then NonLagStepTeleport(CFrame.new(base.X,base.Y+3,base.Z), false) end
    end
    local pl = H.getPlacementLocalCFrames(); if #pl==0 then return end
    local placed = false
    for _,uid in ipairs(unp) do
        if not running or not cont() then return placed end
        if EggApi.RequestEquipTool then pcall(EggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        local ok = false
        for off=0,#pl-1 do
            local pi = (NextPlacementIndex+off-1)%#pl+1
            local success = false
            pcall(function() success = EggApi.RequestPlaceEgg(uid, pl[pi])==true end)
            if success then NextPlacementIndex=pi+1; ok=true; placed=true; task.wait(0.25); break end
        end
        if not ok then H.markPlotFull(); return placed end
        PlotFullUntil = 0
    end
    return placed
end
function H.canAutoHatch() return H.isOn("AutoOpenReadyEggs") and not IsCarryingEgg end
function H.runAutoOpenReadyEggs()
    local s=H.getSave(); local i=s and s.EggInventory; if typeof(i)~="table" then return end
    local any = false
    for uid,e in pairs(i) do
        if not running or not H.isOn("AutoOpenReadyEggs") then return any end
        if typeof(uid)=="string" and typeof(e)=="table" and e.Placement~=nil
            and H.matchesEggFilters(e,nil,"LifecycleRarities","LifecycleMutations") then
            local rdy=false
            if EggApi.IsLocalEggReady then pcall(function() rdy = EggApi.IsLocalEggReady(uid)==true end) end
            if rdy and EggApi.RequestHatchEgg then
                local st=false
                pcall(function() st = EggApi.RequestHatchEgg(uid)==true end)
                if st then any=true; if EggApi.RequestCompleteHatchEgg then pcall(EggApi.RequestCompleteHatchEgg, uid) end; task.wait(0.35) end
            end
        end
    end
    return any
end
function H.getPetItemData(sp)
    if not AssetItemsApi.Deserialize then return nil end
    local ok,d = pcall(AssetItemsApi.Deserialize, sp); if not ok or typeof(d)~="table" then return nil end; return d
end
function H.findToolByUid(uid)
    local c = {LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack")}
    for _,x in ipairs(c) do if x then for _,ch in ipairs(x:GetChildren()) do if ch:IsA("Tool") and ch:GetAttribute("UID")==uid then return ch end end end end
end
function H.holdUid(uid)
    local ch=LocalPlayer.Character; local h=H.getHumanoid(); if not ch or not h then return false end
    local t=H.findToolByUid(uid); if not t then return false end
    if t.Parent==ch then return true end
    pcall(function() h:EquipTool(t) end)
    return H.waitFor(1,0.05,function() return t.Parent==LocalPlayer.Character end)
end
function H.sellUid(uid)
    if not H.holdUid(uid) then return false end
    H.netCall(Remotes.AssetInventory.SELL_ASSET, uid)
    return H.waitFor(2,0.1,function()
        local s=H.getSave(); if not s then return false end
        local i=s.Inventory or {}; local ei=s.EggInventory or {}
        return i[uid]==nil and ei[uid]==nil
    end)
end
function H.getSellablePets()
    local s=H.getSave(); local i=s and s.Inventory; local r={}
    if typeof(i)~="table" then return r end
    local eq = s.EquippedAssets or {}
    local mx = tonumber(H.optionValue("SellMaxScale",10)) or 10
    local kM = H.isOn("SellKeepMutated"); local kE = H.isOn("SellKeepEquipped")
    local sM = H.multiSelected("SellMutations"); local fM = H.multiHasAny("SellMutations")
    local sR = H.multiSelected("SellRarities"); local fR = H.multiHasAny("SellRarities")
    for uid,a in pairs(i) do
        if typeof(uid)=="string" and typeof(a)=="table" then
            local d=H.getPetItemData(a); local isE = table.find(eq,uid)~=nil
            local prot = not d or d.IsFavorite==true or d.InFuse==true or (kE and isE)
            if not prot then
                local m = H.recordMutations(a)
                local ok = not (kM and #m>0)
                if ok and fM then ok=false; for _,x in ipairs(m) do if sM[x] then ok=true break end end end
                local sc = tonumber(a.Scale) or 0; local rar = H.resolveRarity(a.Category)
                local okR = not fR or (typeof(rar)=="string" and sR[rar]==true)
                if ok and sc<=mx and okR then table.insert(r,uid) end
            end
        end
    end
    return r
end
function H.runAutoSellPets()
    for _,uid in ipairs(H.getSellablePets()) do
        if not running or not H.isOn("AutoSellPets") or IsCarryingEgg then return end
        H.sellUid(uid); task.wait(0.15)
    end
end
function H.getSellableEggUids()
    local s=H.getSave(); local i=s and s.EggInventory; local r={}
    if typeof(i)~="table" then return r end
    local useR = H.multiHasAny("SellEggRarities"); local sR = H.multiSelected("SellEggRarities")
    for uid,e in pairs(i) do
        if typeof(uid)=="string" and typeof(e)=="table" and e.Placement==nil then
            local rar = H.resolveRarity(e.AssetCategory)
            if not useR or (typeof(rar)=="string" and sR[rar]==true) then table.insert(r,uid) end
        end
    end
    return r
end
function H.runAutoSellEggs()
    for _,uid in ipairs(H.getSellableEggUids()) do
        if not running or not H.isOn("AutoSellEggs") or IsCarryingEgg then return end
        if EggApi.RequestEquipTool then pcall(EggApi.RequestEquipTool, uid) end
        task.wait(0.15); H.sellUid(uid); task.wait(0.15)
    end
end
function H.fuseGroups(s)
    local i=s and s.Inventory; local g={}
    if typeof(i)~="table" then return g end
    local eq=s.EquippedAssets or {}; local kE=H.isOn("FuseKeepEquipped"); local kM=H.isOn("FuseKeepMutated")
    local mx=tonumber(H.optionValue("FuseMaxScale",10)) or 10
    local fM=H.multiHasAny("FuseMutations"); local sM=H.multiSelected("FuseMutations")
    for uid,p in pairs(i) do
        if typeof(uid)=="string" and typeof(p)=="table" then
            local cat=p.Category; local sel=false
            if typeof(cat)=="string" and FuseApi.CanSelectPet then pcall(function() sel = FuseApi.CanSelectPet(uid,p,cat,false)==true end) end
            if sel and not (kE and table.find(eq,uid)~=nil) then
                local m=H.recordMutations(p); local ok=not (kM and #m>0)
                if ok and fM then ok=false; for _,x in ipairs(m) do if sM[x] then ok=true break end end end
                local rar=H.resolveRarity(cat); local sc=tonumber(p.Scale) or 0
                local okR = rar==nil or H.selectionAllows("FuseRarities",rar)
                if ok and sc<=mx and okR then g[cat]=g[cat] or {}; table.insert(g[cat],{uid=uid,scale=sc}) end
            end
        end
    end
    return g
end
function H.pickFuseGroup(s)
    local g=H.fuseGroups(s); local kpc=math.floor(tonumber(H.optionValue("FuseKeepPerCategory",0)) or 0)
    local mode=H.optionValue("FuseTarget","Highest Rarity")
    local sc,ss=nil,-math.huge
    for cat,ps in pairs(g) do
        table.sort(ps,function(a,b) return a.scale<b.scale end)
        if #ps-kpc>=3 then
            local rs=RarityWeight[H.resolveRarity(cat) or "Common"] or 0; local s=rs
            if mode=="Most Duplicates" then s=#ps elseif mode=="Lowest Rarity" then s=-rs end
            if s>ss then sc=cat; ss=s end
        end
    end
    if not sc then return nil end
    local ps=g[sc]; return {ps[1].uid,ps[2].uid,ps[3].uid}
end
function H.fusePrice(s, uids)
    local i=s and s.Inventory; if typeof(i)~="table" or not FuseApi.CalculateFusePrice then return nil end
    local d={}
    for k,uid in ipairs(uids) do
        local p=i[uid]; local de = p and H.getPetItemData(p); if not de then return nil end; d[k]=de
    end
    local ok,pr = pcall(FuseApi.CalculateFusePrice,d); return ok and tonumber(pr) or nil
end
function H.getFuseMachinePosition()
    local o=Workspace:FindFirstChild("__OBJECTS"); local m=o and o:FindFirstChild("Machines"); local f=m and m:FindFirstChild("FuseMachine")
    if not f then return nil end
    local ok,p=pcall(function() return f:GetPivot() end); if not ok or not p then return nil end
    return p.Position+Vector3.new(0,4,0)
end
function H.runAutoFusePets(forceRun)
    local s=H.getSave(); if not s then return end
    local function cont() return forceRun==true or H.isOn("AutoFusePets") end
    if s.FusionLocked==true then
        if H.isOn("FuseAutoReveal") or forceRun==true then H.netInvoke(Remotes.FuseMachine.COMPLETE_REVEAL) end
        return
    end
    local uids=H.pickFuseGroup(s); if not uids then return end
    local price=H.fusePrice(s,uids); if price and (tonumber(s.Money) or 0)<price then return end
    local pos=H.getFuseMachinePosition()
    if pos then NonLagStepTeleport(CFrame.new(pos), false) end
    if s.FusionInfoAcknowledged~=true then H.netInvoke(Remotes.FuseMachine.ACKNOWLEDGE_INFO) end
    for _,uid in ipairs(uids) do if not running or not cont() then return end
        H.netInvoke(Remotes.FuseMachine.INSERT_MOB, uid); task.wait(0.2) end
    H.netInvoke(Remotes.FuseMachine.START_FUSE); return true
end
function H.runAutoEquipBest()
    local now=Workspace:GetServerTimeNow(); if now-LastEquipBestAt<5 then return end
    LastEquipBestAt=now; H.netCall(Remotes.Backpack.EQUIP_BEST)
end
function H.runAutoEquipBestTrail()
    local s=H.getSave(); local o=s and s.TrailInventory; if typeof(o)~="table" then return false end
    local bi,bp=nil,-1
    for _,n in ipairs(TrailNames) do local id=TrailIdByName[n]; if id and o[id] then local p=TrailPriceByName[n] or 0; if p>bp then bp=p; bi=id end end end
    local w=H.netInvoke(Remotes.Trails.WORN_SNAPSHOT); local wi=typeof(w)=="table" and w[tostring(LocalPlayer.UserId)] or nil
    if not bi or wi==bi then return false end
    H.netInvoke(Remotes.Trails.REQUEST_SELECT, bi); return true
end
function H.gearBaseName(n) return tostring(n):gsub("%s*%[X%d+%]%s*$","") end
function H.runAutoEquipBestGear()
    local c=LocalPlayer.Character; local b=LocalPlayer:FindFirstChildOfClass("Backpack"); local h=H.getHumanoid()
    if not c or not b or not h then return end
    local be,bc=nil,-1
    for _,t in ipairs(b:GetChildren()) do if t:IsA("Tool") then local co=GearCostByName[H.gearBaseName(t.Name)]; if co and co>bc then bc=co; be=t end end end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local co=GearCostByName[H.gearBaseName(t.Name)]; if co and co>=bc then return end end end
    if be then pcall(function() h:EquipTool(be) end) end
end
function H.runAutoBuyTrail()
    local s=H.getSave(); if not s or not H.multiHasAny("TrailWanted") then return false end
    local w=H.multiSelected("TrailWanted"); local o=s.TrailInventory or {}; local got=false
    for _,n in ipairs(TrailNames) do
        if w[n] then local id=TrailIdByName[n]
            if id and not o[id] then local p=TrailPriceByName[n] or 0
                if s.Money>=p then H.netCall(Remotes.Trails.REQUEST_PURCHASE,id); got=true; task.wait(0.35); s=H.getSave() or s; o=s.TrailInventory or o end
            end
        end
    end
    return got
end
function H.runAutoUpgrades()
    local sel=H.multiSelected("UpgradeTypes"); if not H.multiHasAny("UpgradeTypes") then sel={Base=true,Treadmill=true} end
    local s=H.getSave(); if not s then return false end; local up=false
    if sel.Base and BaseUpgradeModule and typeof(BaseUpgradeModule.IsNextTierAffordable)=="function" then
        if BaseUpgradeModule.IsNextTierAffordable(s) then H.netCall(Remotes.Plots.REQUEST_BASE_UPGRADE); up=true; task.wait(0.35) end
    end
    if sel.Treadmill and TreadmillsData and typeof(TreadmillsData.GetByUpgradeLevel)=="function" then
        local l=tonumber(s.TreadmillUpgradeLevel) or 0; local n=TreadmillsData.GetByUpgradeLevel(l+1)
        if n then local p=tonumber(n.Price) or math.huge; if s.Money>=p then H.netCall(Remotes.Treadmills.REQUEST_UPGRADE,n._id); up=true; task.wait(0.35) end end
    end
    return up
end
function H.runAutoClaimIndex() H.netCall(Remotes.Index.REQUEST_CLAIM_ALL) end
function H.runClaimOfflineEarnings()
    local s=H.netInvoke(Remotes.OfflineAssets.GET_SUMMARY); if typeof(s)~="table" then return false end
    if (tonumber(s.ClaimableAmount) or 0)<=0 then return false end
    H.netCall(Remotes.OfflineAssets.REQUEST_REDEEM); return true
end
function H.runAutoClaimGroupReward()
    local s=H.getSave(); if s and s.ClaimedGroupReward==true then return false end
    local ig=false; pcall(function() ig = Constants and Constants.GROUP_ID and LocalPlayer:IsInGroupAsync(Constants.GROUP_ID)==true end)
    H.netInvoke(Remotes.GroupReward.CLAIM_REWARD, ig); return true
end
function H.deleteOwnPetRenders()
    local r=Workspace:FindFirstChild("ClientRenderedAssets"); if not r then return end
    for _,o in ipairs(r:GetChildren()) do if o:GetAttribute("OwnerUserId")==LocalPlayer.UserId then pcall(function() o:Destroy() end) end end
end
function H.getTreadmillStand()
    if not PlotApi.GetPlotData then return nil end
    local p=PlotApi.GetPlotData(); local pf=p and p.PlotFolder; local t=pf and pf:FindFirstChild("TreadmillBottom")
    if not t or not t:IsA("BasePart") then return nil end; return t.Position+Vector3.new(0,4,0)
end
function H.isDoubleSpeedVisible()
    local ok,v = pcall(function()
        local pg=LocalPlayer:FindFirstChild("PlayerGui"); local e=pg and pg:FindFirstChild("Elements")
        local l=e and e:FindFirstChild("Left"); local t=l and l:FindFirstChild("Tools"); local d=t and t:FindFirstChild("DoubleYourSpeed")
        return d~=nil and d.Visible==true
    end)
    return ok and v==true
end
function H.dismountTreadmill()
    pcall(function()
        local i=game:GetService("VirtualInputManager"); i:SendKeyEvent(true,Enum.KeyCode.Space,false,game); task.wait(0.05); i:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
    end)
    local h=H.getHumanoid(); if h then h.Jump=true; h:ChangeState(Enum.HumanoidStateType.Jumping) end
end
function H.stopTreadmillTraining()
    TreadmillTrainingActive=false
    pcall(function() H.netInvoke(Remotes.Treadmills.REQUEST_UNEQUIP) end)
    if H.isDoubleSpeedVisible() then H.dismountTreadmill(); task.wait(0.1); if H.isDoubleSpeedVisible() then H.dismountTreadmill() end end
end
function H.canAutoTreadmill() return H.isOn("AutoTreadmill") and not IsCarryingEgg end
function H.runAutoTreadmillTraining()
    local p=H.getTreadmillStand(); if not p then return end
    local r=H.getRoot(); if not r then return end
    if (r.Position-p).Magnitude>12 then NonLagStepTeleport(CFrame.new(p), false) end
    H.netInvoke(Remotes.Treadmills.REQUEST_EQUIP_STATIC); TreadmillTrainingActive=true; return true
end

local WaypointNames = {"Base","Pet Area","Treadmill","Fuse Machine","Lobby Entry"}
for _,z in ipairs(AREA_ORDER) do table.insert(WaypointNames, z) end
function H.resolveWaypoint(n)
    if typeof(n)~="string" then return nil end
    if n=="Base" then return H.getBasePosition()
    elseif n=="Pet Area" then return H.getPetAreaStandPosition()
    elseif n=="Treadmill" then return H.getTreadmillStand()
    elseif n=="Fuse Machine" then return H.getFuseMachinePosition()
    elseif n=="Lobby Entry" then return H.getEntryPosition() end
    return H.getZoneLaneCenter(n)
end

-- ESP
function H.espDistanceLimit() return tonumber(H.optionValue("EspDistance",2000)) or 2000 end
function H.withinEspRange(p) local r=H.getRoot(); return r~=nil and (r.Position-p).Magnitude<=H.espDistanceLimit() end
function H.espColorFor(r)
    local w=RarityWeight[r or ""] or 0
    if w>=9 then return Color3.fromRGB(255,120,255) elseif w>=7 then return Color3.fromRGB(255,90,90)
    elseif w>=5 then return Color3.fromRGB(255,190,80) elseif w>=3 then return Color3.fromRGB(110,195,255) end
    return Color3.fromRGB(190,200,215)
end
function H.ensureEspEntry(id,c)
    local e=EspEntries[id]; if e then return e end
    local a=Instance.new("Part"); a.Name="EspAnchor"; a.Anchored=true; a.CanCollide=false; a.CanQuery=false; a.CanTouch=false
    a.Transparency=1; a.Size=Vector3.new(0.2,0.2,0.2); a.Parent=EspFolder
    local b=Instance.new("BillboardGui"); b.Name="EspLabel"; b.AlwaysOnTop=true; b.Size=UDim2.fromOffset(220,34)
    b.StudsOffset=Vector3.new(0,2.5,0); b.Adornee=a; b.Parent=a
    local l=Instance.new("TextLabel"); l.Name="Text"; l.BackgroundTransparency=1; l.Size=UDim2.fromScale(1,1)
    l.Font=Enum.Font.GothamBold; l.TextSize=13; l.TextStrokeTransparency=0.4; l.TextColor3=c; l.Parent=b
    local en = {anchor=a,billboard=b,label=l,highlight=nil}; EspEntries[id]=en; return en
end
function H.drawEspAt(id,pos,text,c,ador)
    local e=H.ensureEspEntry(id,c)
    e.anchor.CFrame=CFrame.new(pos); e.label.Text=text; e.label.TextColor3=c
    if ador and ador.Parent then
        if not e.highlight then local h=Instance.new("Highlight"); h.FillTransparency=0.6; h.OutlineTransparency=0
            h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=EspFolder; e.highlight=h end
        e.highlight.Adornee=ador; e.highlight.FillColor=c; e.highlight.OutlineColor=c
    elseif e.highlight then e.highlight:Destroy(); e.highlight=nil end
    EspSeenThisPass[id]=true
end
function H.releaseEsp(id)
    local e=EspEntries[id]; if not e then return end
    if e.highlight then e.highlight:Destroy() end
    if e.billboard then e.billboard:Destroy() end
    if e.anchor then e.anchor:Destroy() end
    EspEntries[id]=nil
end
function H.clearAllEsp() for id in pairs(EspEntries) do H.releaseEsp(id) end end
function H.collectEggEsp()
    local sw=H.isOn("EspWorldEggs"); local sc=H.isOn("EspCarriedEggs"); if not sw and not sc then return end
    for _,e in ipairs(H.getAreaEggs()) do
        local c=e.BottomCFrame or e.BoundsCFrame
        if c then local st=e.State
            local s=(st=="Slot" and sw) or ((st=="Dropped" or st=="Carried") and sc)
            if s and H.withinEspRange(c.Position) then
                local r=H.resolveRarity(e.AssetCategory)
                local l=string.format("%s [%s]",H.assetName(e.AssetCategory),tostring(r or "?"))
                if st=="Dropped" or st=="Carried" then l=string.format("%s\n%s",l,tostring(st)) end
                H.drawEspAt("egg_"..e.Uid, c.Position, l, H.espColorFor(r), nil)
            end
        end
    end
end
function H.collectGuardEsp()
    if not H.isOn("EspGuards") or not GuardAreasFolder then return end
    for _,ga in ipairs(GuardAreasFolder:GetChildren()) do
        local g=ga:FindFirstChild("Guard")
        local ok,p=pcall(function() return g and g:GetPivot() or nil end)
        if ok and p and H.withinEspRange(p.Position) then
            H.drawEspAt("guard_"..ga.Name, p.Position, string.format("Guard %s\n%s",ga.Name,tostring(g:GetAttribute("GuardState") or "Idle")), Color3.fromRGB(255,140,90), g)
        end
    end
end
function H.collectPetEsp()
    if not H.isOn("EspPets") then return end
    local ra=Workspace:FindFirstChild("ClientRenderedAssets"); if not ra then return end
    local s=H.getSave(); local i=s and s.Inventory or {}; local rt={}
    pcall(function()
        if AssetRosterApi.GetRuntimeSnapshot then
            local sn=AssetRosterApi.GetRuntimeSnapshot() or {}
            for _,gr in pairs(sn) do if typeof(gr)=="table" and typeof(gr.Records)=="table" then
                for uid,r in pairs(gr.Records) do rt[uid]=r end end end
        end
    end)
    for _,rp in ipairs(ra:GetChildren()) do
        local uid=rp:GetAttribute("UID"); local ok,p=pcall(function() return rp:GetPivot() end)
        if typeof(uid)=="string" and ok and p and H.withinEspRange(p.Position) then
            local cat,mps=nil,nil
            local sp=i[uid]; if typeof(sp)=="table" then cat=sp.Category end
            local rr=rt[uid]
            if typeof(rr)=="table" then if not cat and rr.ItemData then cat=rr.ItemData.Category end; mps=tonumber(rr.MoneyPerSecond) end
            local r=H.resolveRarity(cat)
            local l=string.format("%s [%s]",H.assetName(cat),tostring(r or "?"))
            if mps then l=string.format("%s\n%s/s",l,H.formatNumber(mps)) end
            H.drawEspAt("pet_"..rp.Name, p.Position, l, H.espColorFor(r), rp)
        end
    end
end
function H.collectPlayerEsp()
    if not H.isOn("EspPlayers") then return end
    local lr=H.getRoot()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then
            local ch=p.Character; local r=ch and ch:FindFirstChild("HumanoidRootPart")
            if r and H.withinEspRange(r.Position) then
                local d = lr and (lr.Position-r.Position).Magnitude or 0
                H.drawEspAt("player_"..p.Name, r.Position, string.format("%s\n%d studs",p.DisplayName,math.floor(d)), Color3.fromRGB(120,190,255), ch)
            end
        end
    end
end
function H.collectMachineEsp()
    if not H.isOn("EspMachines") then return end
    local o=Workspace:FindFirstChild("__OBJECTS"); local m=o and o:FindFirstChild("Machines"); if not m then return end
    for _,x in ipairs(m:GetChildren()) do
        local ok,p=pcall(function() return x:GetPivot() end)
        if ok and p and H.withinEspRange(p.Position) then H.drawEspAt("machine_"..x.Name, p.Position, x.Name, Color3.fromRGB(230,200,120), x) end
    end
end
function H.collectPlotEsp()
    if not H.isOn("EspPlots") then return end
    local pl=Workspace:FindFirstChild("Plots"); if not pl then return end
    for _,p in ipairs(pl:GetChildren()) do
        local a=p:FindFirstChild("PlotSign") or p:FindFirstChild("CenterPoint")
        if a and a:IsA("BasePart") and H.withinEspRange(a.Position) then
            local oid=nil; pcall(function() if PlotApi.GetSlotOwner then oid=PlotApi.GetSlotOwner(tonumber(p.Name)) end end)
            local ot="Empty"; local nid=tonumber(oid)
            if nid then local o=Players:GetPlayerByUserId(nid); if o then ot=o.DisplayName; if o==LocalPlayer then ot=ot.." (You)" end else ot="User "..tostring(nid) end end
            H.drawEspAt("plot_"..p.Name, a.Position, string.format("Plot %s\n%s",p.Name,ot), Color3.fromRGB(200,170,255), nil)
        end
    end
end
function H.runEsp()
    H.clearTable(EspSeenThisPass)
    H.collectEggEsp(); H.collectGuardEsp(); H.collectPetEsp(); H.collectPlayerEsp(); H.collectMachineEsp(); H.collectPlotEsp()
    for id in pairs(EspEntries) do if not EspSeenThisPass[id] then H.releaseEsp(id) end end
end

-- Server Hop
function H.rememberVisited(sid)
    if typeof(sid)~="string" or sid=="" then return end
    if H.countTable(VisitedServerIds)>=300 then H.clearTable(VisitedServerIds) end
    VisitedServerIds[sid]=true
end
H.rememberVisited(tostring(game.JobId))
H.track(TeleportService.TeleportInitFailed:Connect(function(p,r,e) if p==LocalPlayer then LastTeleportFailure=tostring(e or r) end end))
function H.fetchServerPage(cursor)
    local u=string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100",game.PlaceId)
    if cursor then u=u.."&cursor="..cursor end
    local ok,b=pcall(function() return game:HttpGet(u) end)
    if not ok or typeof(b)~="string" then return nil end
    local d,p=pcall(function() return HttpService:JSONDecode(b) end)
    if not d or typeof(p)~="table" or typeof(p.data)~="table" then return nil end
    return p
end
function H.pickHopTargets()
    local c=nil; local cs={}
    for _=1,4 do
        local p=H.fetchServerPage(c); if not p then break end
        for _,s in ipairs(p.data) do
            if typeof(s)=="table" and typeof(s.id)=="string" and s.id~=game.JobId and not VisitedServerIds[s.id] then
                local pl=tonumber(s.playing) or 0; local mp=tonumber(s.maxPlayers) or 0
                if mp>0 and pl<mp then table.insert(cs,{id=s.id,playing=pl}) end
            end
        end
        c=typeof(p.nextPageCursor)=="string" and p.nextPageCursor or nil
        if not c or #cs>=40 then break end
        task.wait(0.25)
    end
    table.sort(cs,function(a,b) return a.playing<b.playing end); return cs
end
function H.tryTeleportTo(sid)
    LastTeleportFailure=nil
    local st=pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,sid,LocalPlayer) end)
    if not st then return false end
    H.waitFor(20,0.25,function() return LastTeleportFailure~=nil or (not running) end)
    if LastTeleportFailure then return false end; return true
end
function H.serverHop(reason)
    if ServerHopInProgress or os.clock()<ServerHopRetryAfter then return false end
    ServerHopInProgress=true
    local ts=H.pickHopTargets()
    if typeof(ts)~="table" or #ts==0 then ServerHopRetryAfter=os.clock()+30; ServerHopInProgress=false; return false end
    for at=1,3 do
        if at>1 then ts=H.pickHopTargets(); if typeof(ts)~="table" or #ts==0 then ServerHopRetryAfter=os.clock()+10; ServerHopInProgress=false; return false end end
        for i=1,math.min(#ts,10) do
            if not running then ServerHopInProgress=false; return false end
            local t=ts[i]; H.rememberVisited(t.id)
            if H.tryTeleportTo(t.id) then ServerHopInProgress=false; return true end
            task.wait(0.5)
        end
    end
    ServerHopRetryAfter=os.clock()+10; ServerHopInProgress=false; return false
end
function H.runServerHop()
    if IsCarryingEgg or ServerHopInProgress then return end
    local mode=H.optionValue("HopMode",ServerHopModes[1]); local th=tonumber(H.optionValue("HopValue",15)) or 15; local now=os.clock()
    if mode=="Timed Interval" then if now-HopIntervalStartedAt>=th*60 then H.serverHop("Interval") end; return end
    if mode=="After Steal Count" then if SessionStolenEggs>=th then H.serverHop("Stole "..SessionStolenEggs) end; return end
    if H.pickStealTarget()~=nil then NoMatchingEggsSince=0; return end
    if NoMatchingEggsSince==0 then NoMatchingEggsSince=now
    elseif now-NoMatchingEggsSince>=th then NoMatchingEggsSince=0; H.serverHop("No eggs") end
end
function H.rejoinServer()
    local ok=pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end)
    if not ok then pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end) end
end

-- Webhook
function H.webhookPing()
    local n=tostring(H.optionValue("WebhookPingId","") or ""):gsub("%D","")
    if n=="" then return nil end; return string.format("<@%s>",n)
end
function H.httpPost(pl)
    local rf=(syn and syn.request) or (http and http.request) or http_request or request
    if typeof(rf)~="function" then return false end
    local u=tostring(H.optionValue("WebhookUrl","") or ""); if u=="" then return false end
    local e; local ok=pcall(function() e=HttpService:JSONEncode(pl) end); if not ok then return false end
    return pcall(rf,{Url=u,Method="POST",Headers={["Content-Type"]="application/json"},Body=e})
end
function H.sendWebhookEmbed(emb, ping)
    if not H.isOn("WebhookEnabled") then return false end
    local pl={username="ZenHubX",embeds={emb}}; if ping then pl.content=H.webhookPing() end
    return H.httpPost(pl)
end
function H.embedField(n,v,i) return {name=n,value=v,inline=i~=false} end
CarryStartedCallback = function(ev)
    if typeof(ev)~="table" then return end
    local r=typeof(ev.Uid)=="string" and H.findAreaEggRecord(ev.Uid) or nil
    local c=r and r.AssetCategory or ev.AssetCategory
    local p={string.format("**%s** `%s`",H.assetName(c),tostring(H.resolveRarity(c) or "?"))}
    if #ObtainedEggLog<100 then table.insert(ObtainedEggLog, table.concat(p," | ")) end
end
function H.trackWebhookEvents()
    local s=H.getSave(); if not s then return end
    if not WebhookTrackerInitialized then
        WebhookTrackerInitialized=true
        for uid in pairs(s.Inventory or {}) do KnownInventoryUids[uid]=true end
        for _,e in ipairs(H.getAreaEggs()) do KnownWorldEggUids[e.Uid]=true end
        LastRebirthSnapshot=tonumber(s.Rebirth) or 0; LastStealCountSnapshot=SessionStolenEggs; return
    end
    SummaryStolenEggs=SummaryStolenEggs+math.max(0,SessionStolenEggs-LastStealCountSnapshot); LastStealCountSnapshot=SessionStolenEggs
    for uid in pairs(s.Inventory or {}) do if KnownInventoryUids[uid]==nil then KnownInventoryUids[uid]=true; SummaryPetsObtained=SummaryPetsObtained+1 end end
    local rb=tonumber(s.Rebirth) or 0
    if LastRebirthSnapshot and rb>LastRebirthSnapshot then SummaryRebirths=SummaryRebirths+rb-LastRebirthSnapshot end
    LastRebirthSnapshot=rb
end
function H.buildSummaryEmbed()
    local s=H.getSave(); local f={}
    if s then
        table.insert(f,H.embedField("Money","`"..H.formatNumber(s.Money).."`"))
        table.insert(f,H.embedField("Rebirth","`"..tostring(s.Rebirth or 0).."`"))
        table.insert(f,H.embedField("Pets","`"..tostring(H.countTable(s.Inventory)).."`"))
    end
    table.insert(f,H.embedField("Since Last",string.format("Eggs: **%d**\nPets: **%d**\nRebirths: **%d**",SummaryStolenEggs,SummaryPetsObtained,SummaryRebirths),false))
    return {author={name="Steal an Egg | ZenHubX"},title="Session Summary",
        description=string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",LocalPlayer.Name,DisplayJobId,H.formatElapsed(os.clock()-SessionStartedAt)),
        color=5793266,fields=f,footer={text="ZenHubX | "..DISCORD_LINK},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}
end
H.sendSummary = function()
    local sent=H.sendWebhookEmbed(H.buildSummaryEmbed(),true)
    if sent then SummaryStolenEggs,SummaryPetsObtained,SummaryRebirths=0,0,0; H.clearTable(SpawnedEggLog); H.clearTable(ObtainedEggLog) end
    return sent
end
function H.runWebhookSummary()
    local iv=(tonumber(H.optionValue("WebhookInterval",15)) or 15)*60
    if os.clock()-LastWebhookSummaryAt<iv then return false end
    LastWebhookSummaryAt=os.clock(); return H.sendSummary()
end

-- Performance
function H.applyAntiGameplayPause(en)
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(not en) end)
    pcall(function() local n=CoreGui:FindFirstChild("RobloxNetworkPauseNotification"); if n then n.Enabled=not en end end)
    if en then pcall(function() if sethiddenproperty then sethiddenproperty(LocalPlayer,"GameplayPaused",false) else LocalPlayer.GameplayPaused=false end end) end
end
function H.applyRendering(dis) pcall(function() RunService:Set3dRenderingEnabled(not dis) end) end
local FpsEffectClasses = {ParticleEmitter=true,Trail=true,Smoke=true,Fire=true,Sparkles=true}
function H.setEffectEnabled(i,e) pcall(function() i.Enabled=e end) end
function H.enableFpsBoost()
    if FpsBoostSnapshot then return end
    local t=Workspace:FindFirstChildOfClass("Terrain"); local ql=nil
    pcall(function() ql=settings().Rendering.QualityLevel end)
    FpsBoostSnapshot={QualityLevel=ql,GlobalShadows=Lighting.GlobalShadows,FogEnd=Lighting.FogEnd,Terrain=t,
        WaterWaveSize=t and t.WaterWaveSize or nil,WaterReflectance=t and t.WaterReflectance or nil,Effects={}}
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows=false; Lighting.FogEnd=1000000
    if t then t.WaterWaveSize=0; t.WaterReflectance=0 end
    for _,d in ipairs(Workspace:GetDescendants()) do if FpsEffectClasses[d.ClassName] and d.Enabled then table.insert(FpsBoostSnapshot.Effects,d); H.setEffectEnabled(d,false) end end
    FpsDescendantAddedConnection=Workspace.DescendantAdded:Connect(function(d) if FpsEffectClasses[d.ClassName] and H.isOn("FpsBoost") then H.setEffectEnabled(d,false) end end)
end
function H.disableFpsBoost()
    if FpsDescendantAddedConnection then FpsDescendantAddedConnection:Disconnect(); FpsDescendantAddedConnection=nil end
    local s=FpsBoostSnapshot; if not s then return end; FpsBoostSnapshot=nil
    if s.QualityLevel then pcall(function() settings().Rendering.QualityLevel=s.QualityLevel end) end
    Lighting.GlobalShadows=s.GlobalShadows; Lighting.FogEnd=s.FogEnd
    if s.Terrain and s.Terrain.Parent then s.Terrain.WaterWaveSize=s.WaterWaveSize; s.Terrain.WaterReflectance=s.WaterReflectance end
    for _,e in ipairs(s.Effects) do H.setEffectEnabled(e,true) end
end
function H.applyFpsCap(v)
    local f=setfpscap or (syn and syn.set_fps_cap); if typeof(f)~="function" then return false end
    return pcall(f, math.clamp(tonumber(v) or 60,15,360))
end
function H.handleDisconnect(r)
    if DisconnectHandled then return end; DisconnectHandled=true
    if H.isOn("WebhookDisconnectAlerts") then
        H.sendWebhookEmbed({author={name="Steal an Egg | ZenHubX"},title="Disconnected",
            description=string.format("**Player** `%s`\n**Reason** %s",LocalPlayer.Name,tostring(r or "Connection lost")),
            color=15158332,footer={text="ZenHubX | "..DISCORD_LINK},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")},true)
    end
    if H.isOn("AutoReconnect") then task.delay(2,H.rejoinServer) end
end

local AutomationJobs = {
    ["Auto Steal Egg"]={Ready=H.canAutoSteal,Run=H.runAutoSteal,Interval=0.25},
    ["Auto Place Egg"]={Ready=H.canAutoPlace,Run=H.runAutoPlaceEggs,Interval=0.45},
    ["Auto Hatch"]={Ready=H.canAutoHatch,Run=H.runAutoOpenReadyEggs,Interval=0.55},
    ["Auto Treadmill"]={Ready=H.canAutoTreadmill,Run=H.runAutoTreadmillTraining,Interval=1.2},
}
function H.priorityOrder()
    local used,o={},{}
    for _,on in ipairs(PrioritySlotOptionNames) do local j=H.optionValue(on,nil); if AutomationJobs[j] and not used[j] then used[j]=true; table.insert(o,j) end end
    for _,j in ipairs(PriorityTaskNames) do if not used[j] then used[j]=true; table.insert(o,j) end end
    return o
end

-- UI state
local UIState = {}
local UIValues = {}
function H.isOn(id) return UIState[id]==true end
function H.optionValue(id,f) local v=UIValues[id]; if v==nil then return f end return v end
function H.multiSelected(id)
    local v=UIValues[id]; local s={}
    if typeof(v)~="table" then if typeof(v)=="string" and v~="" then s[v]=true end; return s end
    for k,i in pairs(v) do if i==true then s[k]=true elseif typeof(k)=="number" and typeof(i)=="string" then s[i]=true end end
    return s
end
function H.multiHasAny(id) return next(H.multiSelected(id))~=nil end
function H.selectionAllows(id,v) if not H.multiHasAny(id) then return true end; return H.multiSelected(id)[v]==true end
function H.matchesMutationFilter(on,a)
    if not H.multiHasAny(on) then return true end
    local s=H.multiSelected(on); for _,m in ipairs(H.recordMutations(a)) do if s[m] then return true end end; return false
end
function H.matchesEggFilters(e,ao,ro,mo)
    if ao then local a=e.AreaId; if typeof(a)~="string" or not H.selectionAllows(ao,a) then return false end end
    local r=H.resolveRarity(e.AssetCategory); if typeof(r)~="string" or not H.selectionAllows(ro,r) then return false end
    return H.matchesMutationFilter(mo,e)
end

-- Visual Pets
function H.findPetModel(n)
    local s=n:lower()
    for _,d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") and d.Name:lower():find(s,1,true) and d:FindFirstChildWhichIsA("BasePart") and not d:IsDescendantOf(VisualPetFolder) then return d end
    end
end
function H.scanPetNames()
    local sn,ns={},{}
    for _,d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") and d:FindFirstChildWhichIsA("BasePart") then
            local n=d.Name:lower()
            if not (n:find("humanoid") or n:find("egg") or n:find("base") or n:find("plot")) then
                local par=d.Parent and d.Parent.Name:lower() or ""
                if par:find("pet") or par:find("pen") or par:find("render") or par:find("slot") or d:FindFirstChildWhichIsA("AnimationController") then
                    if not sn[d.Name] then sn[d.Name]=true; table.insert(ns,d.Name) end
                end
            end
        end
    end
    table.sort(ns); return ns
end
function H.spawnVisualPet(n)
    local s=H.findPetModel(n); if not s then return nil end
    local c=s:Clone()
    for _,d in ipairs(c:GetDescendants()) do if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then d:Destroy() end end
    for _,d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false; d.CanTouch=false; d.CastShadow=false end end
    c.Name="VP_"..n; c.Parent=VisualPetFolder
    table.insert(VisualPetsSpawned,{model=c}); return c
end
function H.clearVisualPets() for _,v in ipairs(VisualPetsSpawned) do pcall(function() v.model:Destroy() end) end; VisualPetsSpawned={} end
RunService.Heartbeat:Connect(function()
    if #VisualPetsSpawned==0 then return end
    local h=H.getRoot(); if not h then return end
    local c=h.Position+Vector3.new(0,1,0); local t=tick(); local tot=#VisualPetsSpawned
    for i,v in ipairs(VisualPetsSpawned) do
        local a=(i-1)*(math.pi*2/tot)+t*0.8
        local p=c+Vector3.new(math.cos(a)*4,0,math.sin(a)*4)
        pcall(function() v.model:PivotTo(CFrame.new(p)*CFrame.Angles(0,a+math.pi,0)) end)
    end
end)

-- Anti features
local PeteAntiRagdoll=true
local SpeedConfig={Enabled=false,Value=300}
local OriginalWalkSpeed=16
local InstantHoldEnabled=false
local IsTrapImmune=false
local FixLagEnabled=false
local function applyNoClipTo(i) if i and i:IsA("BasePart") then i.CanCollide=false end end

RunService.Stepped:Connect(function()
    if IsBypassing then return end
    local ch=LocalPlayer.Character; local h=ch and ch:FindFirstChild("HumanoidRootPart"); local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not (ch and h and hu) then return end
    if PeteAntiRagdoll then
        hu.PlatformStand=false; local st=hu:GetState()
        if st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown or st==Enum.HumanoidStateType.Physics then hu:ChangeState(Enum.HumanoidStateType.GettingUp) end
        for _,v in ipairs(ch:GetDescendants()) do if v:IsA("Motor6D") then v.Enabled=true end end
        local ve=h.AssemblyLinearVelocity; if ve.Y>30 then h.AssemblyLinearVelocity=Vector3.new(ve.X,0,ve.Z) end
    end
end)
RunService.RenderStepped:Connect(function()
    if IsBypassing then return end
    local ch=LocalPlayer.Character; local h=ch and ch:FindFirstChild("HumanoidRootPart"); if not (ch and h) then return end
    if PeteAntiRagdoll then
        for _,o in ipairs(ch:GetDescendants()) do
            if o:IsA("Constraint") or o:IsA("BallSocketConstraint") or o:IsA("RopeConstraint") or o:IsA("BodyVelocity") or o:IsA("BodyThrust") then o:Destroy() end
        end
    end
end)
RunService.Stepped:Connect(function()
    if SpeedConfig.Enabled then local h=H.getHumanoid(); if h and h.WalkSpeed~=SpeedConfig.Value then h.WalkSpeed=SpeedConfig.Value end end
end)
function H.applyNewBypassAndSpeed()
    local ch=LocalPlayer.Character; if not ch then return false end
    local oh=ch:FindFirstChildOfClass("Humanoid"); if not oh then return false end
    IsBypassing=true
    local ts=oh.WalkSpeed; if SpeedConfig.Enabled then ts=SpeedConfig.Value else OriginalWalkSpeed=oh.WalkSpeed end
    local cam=Workspace.CurrentCamera; local cf=cam.CFrame
    local cl=oh:Clone(); cl.Parent=ch; oh:Destroy(); task.wait(0.15)
    local nh=ch:FindFirstChildOfClass("Humanoid")
    if nh then
        cam.CameraSubject=nh; cam.CFrame=cf; nh.WalkSpeed=ts
        pcall(function()
            nh:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false); nh:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            nh:SetStateEnabled(Enum.HumanoidStateType.Physics,false); nh:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
        end)
    end
    task.wait(0.15); IsBypassing=false; return true
end
function H.applyInstantHoldToPrompt(p)
    if not InstantHoldEnabled then return end
    local ch=LocalPlayer.Character; local bp=LocalPlayer:FindFirstChild("Backpack")
    if ch and p:IsDescendantOf(ch) then return end
    if bp and p:IsDescendantOf(bp) then return end
    p.HoldDuration=0
end
Workspace.DescendantAdded:Connect(function(d) if InstantHoldEnabled and d:IsA("ProximityPrompt") then task.wait(); H.applyInstantHoldToPrompt(d) end end)
function H.setInstantHold(s)
    InstantHoldEnabled=s
    if s then for _,p in ipairs(Workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then H.applyInstantHoldToPrompt(p) end end end
end
function H.isFoliageOrTree(o)
    local n=string.lower(o.Name)
    return string.find(n,"tree") or string.find(n,"leaf") or string.find(n,"leaves") or string.find(n,"grass")
        or string.find(n,"bush") or string.find(n,"foliage") or string.find(n,"plant") or string.find(n,"wood")
end
function H.cleanLighting()
    Lighting.FogEnd=1e6; Lighting.FogStart=1e6; Lighting.GlobalShadows=false
    for _,v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end
end
function H.applyClayAndClean(o)
    if not FixLagEnabled then return end
    if H.isFoliageOrTree(o) then o:Destroy(); return end
    if o:IsA("SurfaceAppearance") or o:IsA("Texture") or o:IsA("Decal") then o:Destroy(); return end
    if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Sparkles") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Highlight") then o:Destroy(); return end
    if o:IsA("BasePart") or o:IsA("MeshPart") then o.Material=Enum.Material.SmoothPlastic; o.CastShadow=false; if o:IsA("MeshPart") then o.TextureID="" end end
end
function H.enableFixLag() FixLagEnabled=true; H.cleanLighting(); for _,o in ipairs(Workspace:GetDescendants()) do H.applyClayAndClean(o) end end
Workspace.DescendantAdded:Connect(function(o) if FixLagEnabled then task.wait(); H.applyClayAndClean(o) end end)
function H.isTrapObject(o)
    local n=string.lower(o.Name)
    return string.find(n,"trap") or string.find(n,"snare") or string.find(n,"bear_trap") or string.find(n,"playertrap")
end
function H.deleteAndDisableTrap(o)
    if not IsTrapImmune then return end
    if H.isTrapObject(o) then
        for _,p in ipairs(o:GetDescendants()) do
            if p:IsA("BasePart") then p.CanTouch=false; p.CanCollide=false; p.Transparency=1
            elseif p:IsA("TouchTransmitter") or p:IsA("Script") or p:IsA("LocalScript") then p:Destroy() end
        end
        task.defer(function() pcall(function() o:Destroy() end) end)
    end
end
function H.applyTrapImmunity()
    local ch=LocalPlayer.Character; if not ch then return end
    if not ch:FindFirstChild("TrapImmunityField") then local ff=Instance.new("ForceField"); ff.Name="TrapImmunityField"; ff.Visible=false; ff.Parent=ch end
    for _,o in ipairs(Workspace:GetDescendants()) do H.deleteAndDisableTrap(o) end
end
Workspace.DescendantAdded:Connect(function(d) if IsTrapImmune then task.wait(); H.deleteAndDisableTrap(d) end end)
function H.teleportToVoid() local h=H.getRoot(); if h then h.CFrame=CFrame.new(h.Position.X,-350,h.Position.Z) end end

-- ============================================================
-- WINDUI - REORGANIZED TABS
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = "zen hubX steal an egg",
    Folder = "zenhubX",
    Icon = "solar:shield-bold",
    Theme = "Dark",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "zen hubX steal an egg",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 2,
        Enabled = true, Draggable = true, OnlyMobile = false, Scale = 0.5,
        Color = ColorSequence.new(Color3.fromHex("#8A2BE2"), Color3.fromHex("#DA70D6")),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})

Window:Tag({ Title = T("Tag_Merged"), Icon = "solar:star-bold", Color = PurpleColor, Border = true })

-- Language toggle button at top
local langBtn = Window:Button({
    Title = T("T_LangSwitch"),
    Icon = "solar:global-bold",
    Color = PurpleColor,
    Callback = function()
        Lang = (Lang == "vi") and "en" or "vi"
        WindUI:Notify({
            Title = "ZenHubX",
            Content = (Lang == "vi") and "Đã đổi sang Tiếng Việt. Mở lại menu để cập nhật." or "Switched to English. Reopen menu to refresh."
        })
    end,
})

-- ============ TAB 1: HOME (Trang chủ) ============
local Home = Window:Tab({ Title = T("Tab_Home"), Icon = "solar:home-bold", IconColor = PurpleColor, Border = true })
Home:Section({ Title = "Status / Trạng thái" })
Home:Button({ Title = "Copy Discord", Callback = function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    WindUI:Notify({ Title = "ZenHubX", Content = "Đã copy!" })
end })
Home:Button({ Title = "Rejoin Server", Callback = function() H.rejoinServer() end })
Home:Button({ Title = T("T_DropVoid"), Callback = function() H.teleportToVoid() end })
Home:Button({ Title = T("T_Unload"), Callback = function() running = false end })

-- ============ TAB 2: FARM (Farm Trứng) ============
local Farm = Window:Tab({ Title = T("Tab_Farm"), Icon = "solar:zap-bold", IconColor = PurpleColor, Border = true })

Farm:Section({ Title = T("Sec_Steal") })
Farm:Toggle({ Title = T("T_AutoStealSelected"), Desc = T("TD_AutoStealSelected"), Value = false, Callback = function(v) UIState["AutoStealSelected"] = v end })
Farm:Toggle({ Title = T("T_AutoStealAll"), Desc = T("TD_AutoStealAll"), Value = false, Callback = function(v) UIState["AutoStealAll"] = v end })
Farm:Toggle({ Title = T("T_StealBigEggs"), Value = false, Callback = function(v) UIState["StealBigEggs"] = v end })
Farm:Dropdown({ Title = T("T_Areas"), Values = AreaNames, Multi = true, Value = {}, Callback = function(v) UIValues["StealZones"] = v end })
Farm:Dropdown({ Title = T("T_Rarities"), Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["StealRarities"] = v end })
Farm:Dropdown({ Title = T("T_Mutations"), Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["StealMutations"] = v end })
Farm:Dropdown({ Title = T("T_TargetPriority"), Values = STEAL_PRIORITIES, Value = "Rarest", Callback = function(v) UIValues["StealPriority"] = v end })
Farm:Slider({ Title = T("T_MinBigEggSize"), Min = 1, Max = 50, Default = 1.5, Step = 0.1, Callback = function(v) UIValues["StealBigEggScale"] = v end })
Farm:Slider({ Title = "Teleport Step (studs)", Min = 8, Max = 60, Default = 18, Step = 1, Callback = function(v) FarmConfig.TeleportStep = v end })
Farm:Slider({ Title = "Teleport Delay (ms)", Min = 0, Max = 200, Default = 40, Step = 5, Callback = function(v) FarmConfig.TeleportDelay = v / 1000 end })
Farm:Toggle({ Title = T("T_AutoReturn"), Value = true, Callback = function(v) UIState["AutoReturn"] = v end })
Farm:Toggle({ Title = T("T_AutoDropEgg"), Value = false, Callback = function(v) UIState["AutoDropEgg"] = v end })
Farm:Button({ Title = T("T_StealNow"), Callback = function() task.spawn(H.runAutoSteal) end })

Farm:Section({ Title = T("Sec_AntiCheat") })
Farm:Button({ Title = T("T_BypassAC"), Desc = T("TD_BypassAC"), Callback = function()
    task.spawn(function() local ok = H.applyNewBypassAndSpeed()
        WindUI:Notify({ Title = "ZenHubX", Content = ok and "✓ OK" or "Lỗi/Error" }) end)
end })
Farm:Toggle({ Title = T("T_WalkSpeedToggle"), Value = false, Callback = function(v)
    SpeedConfig.Enabled = v
    local h = H.getHumanoid(); if h then h.WalkSpeed = v and SpeedConfig.Value or OriginalWalkSpeed end
end })
Farm:Slider({ Title = T("T_MoveSpeed"), Min = 100, Max = 900, Default = 300, Step = 10, Callback = function(v)
    SpeedConfig.Value = v; if SpeedConfig.Enabled then local h = H.getHumanoid(); if h then h.WalkSpeed = v end end
end })
Farm:Toggle({ Title = T("T_SpeedChanger"), Value = false, Callback = function(v) UIState["SpeedChanger"] = v end })
Farm:Toggle({ Title = T("T_VoidUnstuck"), Value = false, Callback = function(v) VoidUnstuck = v end })
Farm:Button({ Title = T("T_SetBase"), Callback = function() local h = H.getRoot(); if h then ManualBase = h.Position end end })
Farm:Button({ Title = T("T_ClearBase"), Callback = function() ManualBase = nil end })

Farm:Section({ Title = "Auto Steal Free" })
Farm:Toggle({ Title = "Auto Steal Free", Value = false, Callback = function(v) UIState["AutoStealFree"] = v end })

Farm:Section({ Title = T("Sec_AutoPlace") .. " & " .. T("Sec_AutoHatch") })
Farm:Toggle({ Title = T("T_PlaceSelected"), Value = false, Callback = function(v) UIState["AutoPlaceSelected"] = v end })
Farm:Toggle({ Title = T("T_PlaceAll"), Value = false, Callback = function(v) UIState["AutoPlaceAll"] = v end })
Farm:Dropdown({ Title = T("T_LifecycleRar"), Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["LifecycleRarities"] = v end })
Farm:Dropdown({ Title = T("T_LifecycleMut"), Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["LifecycleMutations"] = v end })
Farm:Toggle({ Title = T("T_HatchReady"), Value = false, Callback = function(v) UIState["AutoOpenReadyEggs"] = v end })
Farm:Button({ Title = T("T_PlaceNow"), Callback = function() task.spawn(function() H.runAutoPlaceEggs(true) end) end })
Farm:Button({ Title = T("T_HatchNow"), Callback = function() task.spawn(function() H.runAutoOpenReadyEggs() end) end })

Farm:Section({ Title = T("Sec_AutoSellEgg") })
Farm:Toggle({ Title = T("T_SellEggs"), Value = false, Callback = function(v) UIState["AutoSellEggs"] = v end })
Farm:Dropdown({ Title = T("T_SellEggRar"), Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["SellEggRarities"] = v end })
Farm:Slider({ Title = T("T_SellEggInterval"), Min = 1, Max = 120, Default = 8, Step = 1, Callback = function(v) UIValues["SellEggInterval"] = v end })

-- ============ TAB 3: PETS (Thú cưng) ============
local Pets = Window:Tab({ Title = T("Tab_Pets"), Icon = "solar:cat-bold", IconColor = PurpleColor, Border = true })
Pets:Section({ Title = T("Sec_PetsOverview") })
Pets:Toggle({ Title = T("T_EquipBest"), Value = false, Callback = function(v) UIState["AutoEquipBest"] = v end })
Pets:Toggle({ Title = T("T_HideOwnPet"), Value = false, Callback = function(v) UIState["AutoDeleteOwnPets"] = v end })

Pets:Section({ Title = T("Sec_AutoFuse") })
Pets:Toggle({ Title = T("T_AutoFusePets"), Value = false, Callback = function(v) UIState["AutoFusePets"] = v end })
Pets:Dropdown({ Title = T("T_FuseRar"), Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["FuseRarities"] = v end })
Pets:Dropdown({ Title = T("T_FuseMut"), Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["FuseMutations"] = v end })
Pets:Dropdown({ Title = T("T_PickGroupBy"), Values = FUSE_TARGET_MODES, Value = "Highest Rarity", Callback = function(v) UIValues["FuseTarget"] = v end })
Pets:Toggle({ Title = T("T_NeverFuseMut"), Value = true, Callback = function(v) UIState["FuseKeepMutated"] = v end })
Pets:Toggle({ Title = T("T_NeverFuseEquip"), Value = true, Callback = function(v) UIState["FuseKeepEquipped"] = v end })
Pets:Toggle({ Title = T("T_AutoReveal"), Value = true, Callback = function(v) UIState["FuseAutoReveal"] = v end })
Pets:Slider({ Title = T("T_MaxScaleFuse"), Min = 0, Max = 10, Default = 10, Step = 0.1, Callback = function(v) UIValues["FuseMaxScale"] = v end })
Pets:Slider({ Title = T("T_KeepPerType"), Min = 0, Max = 20, Default = 0, Step = 1, Callback = function(v) UIValues["FuseKeepPerCategory"] = v end })
Pets:Slider({ Title = T("T_FuseInterval"), Min = 1, Max = 120, Default = 8, Step = 1, Callback = function(v) UIValues["FuseInterval"] = v end })
Pets:Button({ Title = T("T_FuseNow"), Callback = function() task.spawn(function() H.runAutoFusePets(true) end) end })

Pets:Section({ Title = T("Sec_AutoSellPet") })
Pets:Toggle({ Title = T("T_SellPets"), Value = false, Callback = function(v) UIState["AutoSellPets"] = v end })
Pets:Dropdown({ Title = T("T_SellRar"), Values = RARITIES, Multi = true, Value = {}, Callback = function(v) UIValues["SellRarities"] = v end })
Pets:Dropdown({ Title = T("T_SellMut"), Values = MUTATIONS, Multi = true, Value = {}, Callback = function(v) UIValues["SellMutations"] = v end })
Pets:Toggle({ Title = T("T_NeverSellMut"), Value = true, Callback = function(v) UIState["SellKeepMutated"] = v end })
Pets:Toggle({ Title = T("T_NeverSellEquip"), Value = true, Callback = function(v) UIState["SellKeepEquipped"] = v end })
Pets:Slider({ Title = T("T_MaxScaleSell"), Min = 0, Max = 10, Default = 10, Step = 0.1, Callback = function(v) UIValues["SellMaxScale"] = v end })
Pets:Slider({ Title = T("T_SellInterval"), Min = 1, Max = 120, Default = 6, Step = 1, Callback = function(v) UIValues["SellInterval"] = v end })

Pets:Section({ Title = T("Sec_VisualPet") })
local visPetList = Pets:Dropdown({ Title = T("T_VisualPetPick"), Values = {"Scanning..."}, Value = 1, Callback = function(v)
    local n = type(v) == "table" and next(v) or v
    if type(n) == "string" then UIValues["VisualPetSelected"] = n end
end })
Pets:Button({ Title = T("T_RefreshPetList"), Callback = function()
    local ns = H.scanPetNames()
    if #ns > 0 then
        pcall(function() visPetList:Refresh(ns) end); pcall(function() visPetList:SetValues(ns) end)
        WindUI:Notify({ Title = "Visual Pets", Content = #ns .. " pets." })
    end
end })
Pets:Input({ Title = T("T_CustomName"), Placeholder = "e.g. Dragon", Callback = function(v) UIValues["VisualPetCustom"] = v end })
Pets:Slider({ Title = T("T_OrbitRadius"), Min = 2, Max = 20, Default = 4, Step = 1, Callback = function(v) UIValues["VisualPetRadius"] = v end })
Pets:Slider({ Title = T("T_OrbitSpeed"), Min = 0, Max = 10, Default = 1, Step = 1, Callback = function(v) UIValues["VisualPetSpeed"] = v end })
Pets:Button({ Title = T("T_SpawnPet"), Callback = function()
    local n = UIValues["VisualPetCustom"] or UIValues["VisualPetSelected"]
    if not n or n == "" then WindUI:Notify({ Title = "Visual Pets", Content = "Chọn pet trước!" }); return end
    H.spawnVisualPet(n)
end })
Pets:Button({ Title = T("T_RemoveLast"), Callback = function() local v = table.remove(VisualPetsSpawned); if v then pcall(function() v.model:Destroy() end) end end })
Pets:Button({ Title = T("T_RemoveAll"), Callback = function() H.clearVisualPets() end })
task.delay(3, function()
    local ns = H.scanPetNames()
    if #ns > 0 then pcall(function() visPetList:Refresh(ns) end); pcall(function() visPetList:SetValues(ns) end) end
end)

-- ============ TAB 4: PROGRESS (Tiến trình) ============
local Prog = Window:Tab({ Title = T("Tab_Progress"), Icon = "solar:graph-up-bold", IconColor = PurpleColor, Border = true })
Prog:Section({ Title = T("Sec_Upgrades") })
Prog:Toggle({ Title = T("T_AutoUpgrades"), Value = false, Callback = function(v) UIState["AutoUpgrades"] = v end })
Prog:Dropdown({ Title = T("T_UpgradeTypes"), Values = UPGRADE_TYPES, Multi = true, Value = {"Base","Treadmill"}, Callback = function(v) UIValues["UpgradeTypes"] = v end })
Prog:Section({ Title = T("Sec_Rewards") })
Prog:Toggle({ Title = T("T_ClaimIndex"), Value = false, Callback = function(v) UIState["AutoClaimIndex"] = v end })
Prog:Toggle({ Title = T("T_ClaimGroup"), Value = false, Callback = function(v) UIState["AutoClaimGroupReward"] = v end })
Prog:Toggle({ Title = T("T_ClaimOffline"), Value = false, Callback = function(v) UIState["AutoClaimOffline"] = v end })
Prog:Section({ Title = T("Sec_Equipment") })
Prog:Toggle({ Title = T("T_BuyTrail"), Value = false, Callback = function(v) UIState["AutoBuyTrail"] = v end })
Prog:Dropdown({ Title = T("T_Trails"), Values = TrailNames, Multi = true, Value = {}, Callback = function(v) UIValues["TrailWanted"] = v end })
Prog:Toggle({ Title = T("T_EquipBestTrail"), Value = false, Callback = function(v) UIState["AutoEquipBestTrail"] = v end })
Prog:Toggle({ Title = T("T_EquipBestGear"), Value = false, Callback = function(v) UIState["AutoEquipBestGear"] = v end })
Prog:Section({ Title = T("Sec_Training") })
Prog:Toggle({ Title = T("T_AutoTreadmill"), Value = false, Callback = function(v) UIState["AutoTreadmill"] = v end })

-- ============ TAB 5: PLAYER (Nhân vật) ============
local Plr = Window:Tab({ Title = T("Tab_Player"), Icon = "solar:user-bold", IconColor = PurpleColor, Border = true })
Plr:Section({ Title = T("Sec_ESP") })
Plr:Toggle({ Title = T("T_WorldEggEsp"), Value = false, Callback = function(v) UIState["EspWorldEggs"] = v end })
Plr:Toggle({ Title = T("T_CarriedEggEsp"), Value = false, Callback = function(v) UIState["EspCarriedEggs"] = v end })
Plr:Toggle({ Title = T("T_GuardEsp"), Value = false, Callback = function(v) UIState["EspGuards"] = v end })
Plr:Toggle({ Title = T("T_PetEsp"), Value = false, Callback = function(v) UIState["EspPets"] = v end })
Plr:Toggle({ Title = T("T_PlayerEsp"), Value = false, Callback = function(v) UIState["EspPlayers"] = v end })
Plr:Toggle({ Title = T("T_MachineEsp"), Value = false, Callback = function(v) UIState["EspMachines"] = v end })
Plr:Toggle({ Title = T("T_PlotEsp"), Value = false, Callback = function(v) UIState["EspPlots"] = v end })
Plr:Slider({ Title = T("T_RenderDistance"), Min = 100, Max = 6000, Default = 2000, Step = 50, Callback = function(v) UIValues["EspDistance"] = v end })
Plr:Section({ Title = T("Sec_Movement") })
Plr:Toggle({ Title = T("T_WalkOverride"), Value = false, Callback = function(v) UIState["WalkSpeedEnabled"] = v end })
Plr:Slider({ Title = T("T_WalkSpeed"), Min = 16, Max = 500, Default = 32, Step = 1, Callback = function(v) UIValues["WalkSpeed"] = v end })
Plr:Toggle({ Title = T("T_JumpOverride"), Value = false, Callback = function(v) UIState["JumpPowerEnabled"] = v end })
Plr:Slider({ Title = T("T_JumpPower"), Min = 10, Max = 500, Default = 50, Step = 1, Callback = function(v) UIValues["JumpPower"] = v end })
Plr:Toggle({ Title = T("T_InfJump"), Value = false, Callback = function(v) UIState["InfJump"] = v end })
Plr:Toggle({ Title = T("T_NoClip"), Value = false, Callback = function(v) UIState["NoClip"] = v end })
Plr:Toggle({ Title = T("T_Fly"), Value = false, Callback = function(v)
    UIState["Fly"] = v; if not v then local h = H.getHumanoid(); if h then h.PlatformStand = false end end
end })
Plr:Slider({ Title = T("T_FlySpeed"), Min = 10, Max = 400, Default = 60, Step = 1, Callback = function(v) UIValues["FlySpeed"] = v end })
Plr:Section({ Title = T("Sec_Teleport") })
Plr:Dropdown({ Title = T("T_Waypoint"), Values = WaypointNames, Value = "Base", Callback = function(v) UIValues["WaypointTarget"] = v end })
Plr:Button({ Title = T("T_TPWaypoint"), Callback = function()
    task.spawn(function()
        local p = H.resolveWaypoint(H.optionValue("WaypointTarget", "Base"))
        if p then NonLagStepTeleport(CFrame.new(p), false) end
    end)
end })
Plr:Button({ Title = T("T_DropVoid"), Callback = function() H.teleportToVoid() end })

-- ============ TAB 6: SERVER ============
local Srv = Window:Tab({ Title = T("Tab_Server"), Icon = "solar:refresh-bold", IconColor = PurpleColor, Border = true })
Srv:Section({ Title = T("Sec_AutoHop") })
Srv:Toggle({ Title = T("T_AutoHop"), Value = false, Callback = function(v) UIState["AutoServerHop"] = v end })
Srv:Dropdown({ Title = T("T_HopWhen"), Values = ServerHopModes, Value = "No Matching Eggs", Callback = function(v) UIValues["HopMode"] = v end })
Srv:Slider({ Title = T("T_WaitBeforeHop"), Min = 1, Max = 200, Default = 15, Step = 1, Callback = function(v) UIValues["HopValue"] = v end })
Srv:Button({ Title = T("T_HopNow"), Callback = function() task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Manual") end) end })
Srv:Button({ Title = T("T_Rejoin"), Callback = function() H.rejoinServer() end })
Srv:Section({ Title = T("Sec_TaskPriority") })
for i, name in ipairs(PrioritySlotOptionNames) do
    Srv:Dropdown({ Title = T("T_Priority") .. " " .. i, Values = PriorityTaskNames, Value = PriorityTaskNames[i], Callback = function(v) UIValues[name] = v end })
end

-- ============ TAB 7: SYSTEM (Hệ thống) ============
local Sys = Window:Tab({ Title = T("Tab_System"), Icon = "solar:settings-bold", IconColor = PurpleColor, Border = true })
Sys:Section({ Title = T("Sec_AntiRagdoll") .. " / " .. T("Sec_AntiTrap") .. " / " .. T("Sec_FixLag") })
Sys:Toggle({ Title = T("T_AntiRagdoll"), Value = true, Callback = function(v) PeteAntiRagdoll = v end })
Sys:Toggle({ Title = T("T_AntiTrap"), Value = false, Callback = function(v)
    IsTrapImmune = v; if v then H.applyTrapImmunity() end
end })
Sys:Toggle({ Title = T("T_InstantInteract"), Value = false, Callback = function(v) H.setInstantHold(v) end })
Sys:Button({ Title = T("T_FixLag"), Callback = function() H.enableFixLag() end })

Sys:Section({ Title = T("Sec_Session") })
Sys:Toggle({ Title = T("T_AntiAfk"), Value = true, Callback = function(v) UIState["AntiAfk"] = v end })
Sys:Toggle({ Title = T("T_NoGameplayPause"), Value = true, Callback = function(v)
    UIState["AntiGameplayPause"] = v; H.applyAntiGameplayPause(v)
end })
Sys:Toggle({ Title = T("T_AutoReconnect"), Value = false, Callback = function(v) UIState["AutoReconnect"] = v end })

Sys:Section({ Title = T("Sec_Performance") })
Sys:Toggle({ Title = T("T_FpsBoost"), Value = false, Callback = function(v)
    UIState["FpsBoost"] = v; if v then H.enableFpsBoost() else H.disableFpsBoost() end
end })
Sys:Toggle({ Title = T("T_DisableRender"), Value = false, Callback = function(v) H.applyRendering(v) end })
Sys:Slider({ Title = T("T_FpsCap"), Min = 15, Max = 360, Default = 60, Step = 1, Callback = function(v) H.applyFpsCap(v) end })

Sys:Section({ Title = T("Sec_Webhook") })
Sys:Toggle({ Title = T("T_WebhookEnabled"), Value = false, Callback = function(v) UIState["WebhookEnabled"] = v end })
Sys:Input({ Title = T("T_WebhookUrl"), Placeholder = "https://discord.com/api/webhooks/...", Callback = function(v) UIValues["WebhookUrl"] = v end })
Sys:Input({ Title = T("T_PingId"), Placeholder = "123456789012345678", Callback = function(v) UIValues["WebhookPingId"] = v end })
Sys:Slider({ Title = T("T_SummaryInterval"), Min = 1, Max = 180, Default = 15, Step = 1, Callback = function(v) UIValues["WebhookInterval"] = v end })
Sys:Toggle({ Title = T("T_DiscAlert"), Value = false, Callback = function(v) UIState["WebhookDisconnectAlerts"] = v end })
Sys:Button({ Title = T("T_SendSummary"), Callback = function() task.spawn(function() H.sendSummary() end) end })

Sys:Section({ Title = T("Sec_About") })
Sys:Button({ Title = T("T_CopyDiscord"), Callback = function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    WindUI:Notify({ Title = "ZenHubX", Content = "Copied!" })
end })
Sys:Button({ Title = T("T_Unload"), Callback = function() running = false end })

-- ============================================================
-- CONNECTIONS / SCHEDULER
-- ============================================================
pcall(function()
    if not getconnections then return end
    for _, c in ipairs(getconnections(LocalPlayer.Idled)) do pcall(function() c:Disable() end) end
end)

local NoClipAddedConn = nil
local function setNoClip(en)
    if NoClipAddedConn then pcall(function() NoClipAddedConn:Disconnect() end); NoClipAddedConn = nil end
    local ch = LocalPlayer.Character; if not en or not ch then return end
    for _, i in ipairs(ch:GetDescendants()) do applyNoClipTo(i) end
    NoClipAddedConn = ch.DescendantAdded:Connect(applyNoClipTo)
    H.track(NoClipAddedConn)
end

H.track(UserInputService.JumpRequest:Connect(function()
    if not running or not H.isOn("InfJump") then return end
    local h = H.getHumanoid(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))
H.track(RunService.RenderStepped:Connect(function(dt)
    if not running or not H.isOn("Fly") then return end
    local r = H.getRoot(); local h = H.getHumanoid(); local c = Workspace.CurrentCamera
    if not r or not h or not c then return end
    h.PlatformStand = true; local d = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + c.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - c.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - c.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + c.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then d = d - Vector3.new(0,1,0) end
    r.AssemblyLinearVelocity = Vector3.zero
    if d.Magnitude > 0 then r.CFrame = r.CFrame + d.Unit * (tonumber(H.optionValue("FlySpeed",60)) or 60) * dt end
end))
H.track(UserInputService.InputBegan:Connect(function() LastInputAt = tick() end))
H.track(UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Gamepad1 then LastInputAt = tick() end
end))
H.track(LocalPlayer.CharacterAdded:Connect(function()
    if not running then return end
    task.delay(0.35, function()
        if H.stealingEnabled() then end
        if H.isOn("NoClip") then setNoClip(true) end
    end)
end))
H.track(UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.End then running = false end
end))

local SchedulerAt = {}
local LastNoClipOn = false
local function schedDue(n, iv) local now = os.clock(); if now < (SchedulerAt[n] or 0) then return false end; SchedulerAt[n] = now + iv; return true end
local function runCarry()
    if AutomationBusy then return end
    if H.isOn("AutoDropEgg") and IsCarryingEgg then AutomationBusy=true; pcall(H.runAutoDropEgg); AutomationBusy=false; return end
    if H.isOn("AutoReturn") and IsCarryingEgg then AutomationBusy=true; pcall(H.runAutoReturn); AutomationBusy=false end
end
local function runPrio()
    if AutomationBusy then return end
    local o = H.priorityOrder(); if #o < 1 then return end
    for _, jn in ipairs(o) do
        local j = AutomationJobs[jn]; local rdy = j and j.Ready()
        if rdy then local lr = AutomationLastRunAt[jn] or 0; rdy = os.clock() - lr >= j.Interval end
        if rdy then
            AutomationLastRunAt[jn] = os.clock()
            if jn ~= "Auto Treadmill" and (TreadmillTrainingActive or H.isDoubleSpeedVisible()) then pcall(H.stopTreadmillTraining) end
            AutomationBusy = true; local ok, did = pcall(j.Run); AutomationBusy = false
            if ok and did then return end
        end
    end
end

H.track(RunService.Heartbeat:Connect(function()
    if not running then return end
    if schedDue("core", 0.35) then task.spawn(function()
        if H.stealingEnabled() then end
        runCarry(); runPrio()
    end) end
    if schedDue("dash", 2) then
        local nc = H.isOn("NoClip"); if nc ~= LastNoClipOn then LastNoClipOn = nc; setNoClip(nc) end
        if H.isOn("WalkSpeedEnabled") then local h = H.getHumanoid(); if h then h.WalkSpeed = tonumber(H.optionValue("WalkSpeed",32)) or 32 end end
        if H.isOn("JumpPowerEnabled") then local h = H.getHumanoid(); if h then h.UseJumpPower = true; h.JumpPower = tonumber(H.optionValue("JumpPower",50)) or 50 end end
        if TreadmillTrainingActive or H.isDoubleSpeedVisible() then if not H.isOn("AutoTreadmill") then pcall(H.stopTreadmillTraining) end end
        if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
    end
    if schedDue("esp", 1.25) then
        local any = H.isOn("EspWorldEggs") or H.isOn("EspCarriedEggs") or H.isOn("EspGuards")
            or H.isOn("EspPets") or H.isOn("EspPlayers") or H.isOn("EspMachines") or H.isOn("EspPlots")
        if any then pcall(H.runEsp) elseif next(EspEntries) ~= nil then pcall(H.clearAllEsp) end
    end
    if schedDue("pets", 5) then
        if H.isOn("AutoEquipBest") and not AutomationBusy then pcall(H.runAutoEquipBest) end
        if H.isOn("AutoEquipBestTrail") then pcall(H.runAutoEquipBestTrail) end
        if H.isOn("AutoEquipBestGear") then pcall(H.runAutoEquipBestGear) end
        if H.isOn("AutoDeleteOwnPets") then pcall(H.deleteOwnPetRenders) end
    end
    if schedDue("fuse", tonumber(H.optionValue("FuseInterval",8)) or 8) then
        if H.isOn("AutoFusePets") and not AutomationBusy and not IsCarryingEgg then AutomationBusy=true; pcall(H.runAutoFusePets); AutomationBusy=false end
    end
    if schedDue("sellPets", tonumber(H.optionValue("SellInterval",6)) or 6) then
        if H.isOn("AutoSellPets") and not AutomationBusy and not IsCarryingEgg then pcall(H.runAutoSellPets) end
    end
    if schedDue("sellEggs", tonumber(H.optionValue("SellEggInterval",8)) or 8) then
        if H.isOn("AutoSellEggs") and not AutomationBusy and not IsCarryingEgg then AutomationBusy=true; pcall(H.runAutoSellEggs); AutomationBusy=false end
    end
    if schedDue("upg", 4) then
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
    if schedDue("wh", 5) then
        if H.isOn("WebhookEnabled") then pcall(H.trackWebhookEvents); pcall(H.runWebhookSummary) end
    end
    if schedDue("sess", 4) then
        if H.isOn("AntiAfk") then
            local idle = tick() - LastInputAt; local st = tick() - LastAntiAfkAt
            if (idle >= 300 and st >= 60) or (idle < 300 and st >= 300) then
                pcall(function() local c = Workspace.CurrentCamera; if c then
                    VirtualUser:Button2Down(Vector2.new(0,0), c.CFrame); VirtualUser:Button2Up(Vector2.new(0,0), c.CFrame); LastAntiAfkAt = tick() end end)
            end
        end
        if H.isOn("AutoReconnect") or H.isOn("WebhookDisconnectAlerts") then
            local pg = CoreGui:FindFirstChild("RobloxPromptGui"); local ov = pg and pg:FindFirstChild("promptOverlay")
            if ov then local e = ov:FindFirstChild("ErrorPrompt") or ov:FindFirstChildWhichIsA("Frame")
                if e and e.Visible and tostring(e.Name):find("ErrorPrompt") then H.handleDisconnect("Roblox") end end
        end
    end
    if UIState["SpeedChanger"] and SpeedConfig.Enabled then
        local h = H.getHumanoid(); if h and h.WalkSpeed ~= SpeedConfig.Value then h.WalkSpeed = SpeedConfig.Value end
    end
end))

-- Auto Steal Free loop
task.spawn(function()
    while running do
        task.wait(0.5)
        if UIState["AutoStealFree"] and H.getHumanoid() and H.getRoot() then
            local base = ManualBase or H.getBasePosition()
            if base then
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                local hasRun, hasDrop = false, false
                if pg then for _, d in ipairs(pg:GetDescendants()) do
                    if d:IsA("TextButton") or d:IsA("TextLabel") then
                        if d.Text:upper() == "RUN!!" and d.Visible then hasRun = true end
                        if d.Text:lower() == "drop" and d.Visible then hasDrop = true end
                    end
                end end
                if hasRun and hasDrop then
                    NonLagStepTeleport(CFrame.new(base), true)
                end
            end
        end
    end
end)

if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
H.applyFpsCap(60)

WindUI:Notify({ Title = "ZenHubX", Content = (Lang == "vi") and "Đã load! Nhấn nút để mở menu." or "Loaded! Click the button to open." })