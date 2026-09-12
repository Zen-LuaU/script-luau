--[[
    zen hubXsteal
    Farm Egg system ported from ThanhDuy Hub
    - Remove old farm logic, add ThanhDuy's farm: Speed/TP Walk, area focus, egg pickup → deliver to base
    - Keep purple UI, language EN/VI
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
if type(math.round) ~= "function" then
    function math.round(n) return math.floor(n + 0.5) end
end

-- ============================================================
-- LANGUAGE
-- ============================================================
local Lang = { Current = "vi" }
local T = {
    en = {
        discord="Discord",
        tab_home="Home",tab_farm="Farm",tab_pets="Pets",tab_progress="Progress",tab_player="Player",tab_extras="Extras",tab_system="System",
        sec_session="Session",sec_account="Account",sec_quick="Quick Actions",
        sec_steal="Steal Eggs",sec_egg_handling="Egg Handling",sec_server_hop="Server Hop",sec_task_order="Task Order",
        sec_pets="Pets",sec_auto_fuse="Auto Fuse",sec_auto_sell_pets="Auto Sell Pets",
        sec_upgrades="Upgrades",sec_rewards="Rewards",sec_equipment="Equipment",sec_training="Training",
        sec_esp="ESP",sec_movement="Movement",sec_teleports="Teleports",
        sec_combat="Combat / Survival",sec_interaction="Interaction",sec_speed_changer="Speed Changer",
        sec_perf="Performance",sec_visual_pets="Visual Pets (Client Only)",
        sec_performance="Performance",sec_webhooks="Webhooks",sec_about="About",sec_language="Language",
        sec_danger="Danger Zone",sec_bypass="Anti-Cheat Bypass",
        st_automation="Automation",st_current_job="Current Job",st_stolen_eggs="Stolen Eggs",st_carrying="Carrying Egg",
        st_runtime="Runtime",st_server="Server",st_egg_inventory="Egg Inventory",st_money="Money",
        st_speed_power="Speed Power",st_rebirths="Rebirths",st_pets_owned="Pets Owned",
        st_ready="Ready",st_idle="Idle",st_yes="Yes",st_no="No",st_ready_bypass="Bypass Ready",st_not_ready="Not Ready",
        btn_return="Return to Base",btn_place_eggs="Place Eggs",btn_server_hop="Server Hop",btn_fuse_now="Fuse Now",
        btn_hop_now="Hop Now",btn_rejoin="Rejoin Server",btn_copy_join="Copy Join Script",
        btn_send_summary="Send Summary Now",btn_copy_discord="Copy Discord Link",btn_unload="Unload Script",
        btn_fixlag="Fix Lag (Clay + Remove Foliage)",btn_spawn_vpet="Spawn Visual Pet",btn_clear_vpet="Clear All Visual Pets",
        btn_tp_waypoint="Teleport to Waypoint",btn_void="Teleport to Void (Fast Reset)",btn_hop_gui_open="Open Server Hop GUI",
        btn_bypass="Activate Anti-Cheat Bypass (Clone Humanoid)",
        tg_auto_steal="Enable Auto Steal (ThanhDuy)",tg_auto_hatch="Auto Hatch Ready",
        tg_secret_priority="Secret Egg Priority",tg_anti_trap="Anti-Trap",
        tg_auto_equip_best="Auto Equip Best Pets",tg_hide_own_pets="Hide Own Pet Renders",
        tg_auto_fuse="Auto Fuse Pets",tg_auto_sell_pets="Auto Sell Pets",
        tg_auto_server_hop="Auto Server Hop",tg_auto_claim="Auto Claim",tg_auto_upgrade="Auto Upgrade",
        tg_auto_treadmill="Auto Treadmill",tg_auto_upgrade_tread="Auto Upgrade Treadmill",
        tg_esp_world="World Egg ESP",tg_esp_players="Player ESP",tg_esp_pets="Pet ESP",
        tg_walkspeed="Walk Speed Override",tg_jumppower="Jump Power Override",
        tg_infjump="Infinite Jump",tg_noclip="NoClip",tg_fly="Fly",
        tg_anti_ragdoll="Anti-Ragdoll / Anti-Knock",tg_instant_hold="Instant Interact (No Hold)",
        tg_speed_changer="Enable WalkSpeed Lock",tg_anti_afk="Anti-AFK",
        tg_no_pause="No Gameplay Paused",tg_fps_boost="FPS Boost",tg_webhook="Enable Webhooks",
        tg_bypass_auto="Auto-Apply Bypass on Respawn",
        dd_areas="Areas",dd_rarities="Rarities",dd_steal_priority="Target Priority",
        dd_farm_method="Farm Method",
        dd_hop_when="Hop When",dd_waypoint="Waypoint",dd_anti_ragdoll_mode="Camera Mode",
        sl_tp_step="TP Walk Step Size",sl_tp_wait="TP Walk Delay (ms)",
        sl_wait_hop="Wait Before Hop",sl_max_hops="Max Hops",sl_hop_delay="Check Delay",
        sl_walkspeed="Walk Speed",sl_jumppower="Jump Power",sl_flyspeed="Fly Speed",
        sl_speed_val="WalkSpeed Value",sl_claim_int="Claim Interval",sl_upgrade_int="Upgrade Interval",
        sl_esp_dist="Render Distance",sl_fps_cap="FPS Cap",sl_webhook_int="Summary Interval",
        in_vpet_name="Pet Name",in_webhook_url="Webhook URL",in_webhook_ping="Webhook Ping User ID",
        n_ready="Ready - press Z button",n_discord_copied="Discord link copied",
        n_base_unavail="Base unavailable",n_waypoint_unavail="Waypoint unavailable",n_waypoint_fail="Waypoint failed",
        n_fixlag_applied="Fix Lag applied",n_enter_pet="Enter a pet name",n_join_copied="Join script copied",
        n_summary_sent="Summary sent",n_summary_fail="Summary failed",n_lang_changed="Language changed to English",
        n_void="Teleported to void",n_hop_gui_open="Server Hop GUI opened",
        n_bypass_ok="Anti-Cheat Bypass activated!",n_bypass_fail="No character found!",
        n_autosteal_on="Auto Steal started.",n_autosteal_off="Auto Steal stopped.",
        n_hatched="Hatched %d eggs.",n_placed="Placed %d eggs.",
        n_no_area="No areas loaded yet - waiting for game data.",
        dv_target_filter="Target filters",dv_carry_behavior="Carry behavior",dv_egg_selling="Egg selling",
        dv_danger="Danger Zone",all="All",priority="Priority",about_dev="Script Dev",
    },
    vi = {
        discord="Discord",
        tab_home="Trang chính",tab_farm="Farm",tab_pets="Thú cưng",tab_progress="Tiến trình",tab_player="Nhân vật",tab_extras="Tính năng thêm",tab_system="Hệ thống",
        sec_session="Phiên",sec_account="Tài khoản",sec_quick="Hành động nhanh",
        sec_steal="Trộm trứng",sec_egg_handling="Xử lý trứng",sec_server_hop="Đổi server",sec_task_order="Thứ tự tác vụ",
        sec_pets="Thú cưng",sec_auto_fuse="Tự động Fusion",sec_auto_sell_pets="Tự bán thú",
        sec_upgrades="Nâng cấp",sec_rewards="Phần thưởng",sec_equipment="Trang bị",sec_training="Luyện tập",
        sec_esp="ESP",sec_movement="Di chuyển",sec_teleports="Dịch chuyển",
        sec_combat="Chiến đấu / Sinh tồn",sec_interaction="Tương tác",sec_speed_changer="Chỉnh tốc độ",
        sec_perf="Hiệu năng",sec_visual_pets="Thú cưng ảo (Chỉ hiển thị)",
        sec_performance="Hiệu năng",sec_webhooks="Webhook",sec_about="Giới thiệu",sec_language="Ngôn ngữ",
        sec_danger="Vùng nguy hiểm",sec_bypass="Bypass Anti-Cheat",
        st_automation="Tự động",st_current_job="Tác vụ hiện tại",st_stolen_eggs="Trứng đã trộm",st_carrying="Đang mang trứng",
        st_runtime="Thời gian chạy",st_server="Server",st_egg_inventory="Túi trứng",st_money="Tiền",
        st_speed_power="Sức mạnh tốc độ",st_rebirths="Tái sinh",st_pets_owned="Thú sở hữu",
        st_ready="Sẵn sàng",st_idle="Đang chờ",st_yes="Có",st_no="Không",st_ready_bypass="Bypass sẵn sàng",st_not_ready="Chưa sẵn sàng",
        btn_return="Về căn cứ",btn_place_eggs="Đặt trứng",btn_server_hop="Đổi server",btn_fuse_now="Fusion ngay",
        btn_hop_now="Đổi server ngay",btn_rejoin="Vào lại server",btn_copy_join="Sao chép Script vào server",
        btn_send_summary="Gửi tổng kết ngay",btn_copy_discord="Sao chép Link Discord",btn_unload="Tắt Script",
        btn_fixlag="Giảm lag (Đất sét + Xóa cây)",btn_spawn_vpet="Tạo thú ảo",btn_clear_vpet="Xóa tất cả thú ảo",
        btn_tp_waypoint="Dịch chuyển tới điểm",btn_void="Bay xuống Void (Reset nhanh)",btn_hop_gui_open="Mở giao diện Đổi Server",
        btn_bypass="Kích hoạt Bypass Anti-Cheat (Clone Humanoid)",
        tg_auto_steal="Bật Auto Steal (ThanhDuy)",tg_auto_hatch="Tự ấp trứng sẵn sàng",
        tg_secret_priority="Ưu tiên trứng Secret",tg_anti_trap="Chống bẫy",
        tg_auto_equip_best="Tự trang bị thú mạnh nhất",tg_hide_own_pets="Ẩn thú của mình",
        tg_auto_fuse="Tự Fusion thú",tg_auto_sell_pets="Tự bán thú",
        tg_auto_server_hop="Tự đổi server",tg_auto_claim="Tự nhận thưởng",tg_auto_upgrade="Tự nâng cấp",
        tg_auto_treadmill="Tự luyện Treadmill",tg_auto_upgrade_tread="Tự nâng cấp Treadmill",
        tg_esp_world="ESP trứng trên map",tg_esp_players="ESP người chơi",tg_esp_pets="ESP thú",
        tg_walkspeed="Ghi đè tốc độ đi",tg_jumppower="Ghi đè lực nhảy",
        tg_infjump="Nhảy vô hạn",tg_noclip="Xuyên vật thể",tg_fly="Bay",
        tg_anti_ragdoll="Chống ngã / Chống văng",tg_instant_hold="Tương tác tức thì (Không giữ)",
        tg_speed_changer="Khóa tốc độ đi",tg_anti_afk="Chống AFK",
        tg_no_pause="Không bị tạm dừng",tg_fps_boost="Tăng FPS",tg_webhook="Bật Webhook",
        tg_bypass_auto="Tự động áp dụng Bypass khi hồi sinh",
        dd_areas="Khu vực",dd_rarities="Độ hiếm",dd_steal_priority="Ưu tiên mục tiêu",
        dd_farm_method="Phương thức Farm",
        dd_hop_when="Đổi khi",dd_waypoint="Điểm đến",dd_anti_ragdoll_mode="Chế độ Camera",
        sl_tp_step="Bước TP Walk",sl_tp_wait="Độ trễ TP Walk (ms)",
        sl_wait_hop="Chờ trước khi đổi",sl_max_hops="Số hop tối đa",sl_hop_delay="Chu kỳ kiểm tra",
        sl_walkspeed="Tốc độ đi",sl_jumppower="Lực nhảy",sl_flyspeed="Tốc độ bay",
        sl_speed_val="Giá trị tốc độ",sl_claim_int="Chu kỳ nhận",sl_upgrade_int="Chu kỳ nâng cấp",
        sl_esp_dist="Khoảng cách render",sl_fps_cap="Giới hạn FPS",sl_webhook_int="Chu kỳ tổng kết",
        in_vpet_name="Tên thú",in_webhook_url="URL Webhook",in_webhook_ping="ID người dùng cần ping",
        n_ready="Sẵn sàng - nhấn nút Z",n_discord_copied="Đã sao chép link Discord",
        n_base_unavail="Không tìm thấy căn cứ",n_waypoint_unavail="Không tìm thấy điểm đến",n_waypoint_fail="Không thể tới điểm đến",
        n_fixlag_applied="Đã áp dụng giảm lag",n_enter_pet="Nhập tên thú",n_join_copied="Đã sao chép script vào server",
        n_summary_sent="Đã gửi tổng kết",n_summary_fail="Gửi thất bại",n_lang_changed="Đã đổi ngôn ngữ sang Tiếng Việt",
        n_void="Đã thả xuống void",n_hop_gui_open="Đã mở giao diện Đổi Server",
        n_bypass_ok="Đã kích hoạt Bypass Anti-Cheat!",n_bypass_fail="Không tìm thấy nhân vật!",
        n_autosteal_on="Auto Steal đã bật.",n_autosteal_off="Auto Steal đã tắt.",
        n_hatched="Đã ấp %d trứng.",n_placed="Đã đặt %d trứng.",
        n_no_area="Chưa load được khu vực - đang chờ dữ liệu game.",
        dv_target_filter="Bộ lọc mục tiêu",dv_carry_behavior="Hành vi mang trứng",dv_egg_selling="Bán trứng",
        dv_danger="Vùng nguy hiểm",all="Tất cả",priority="Ưu tiên",about_dev="Nhà phát triển",
    },
}
local function L(key)
    local pack = T[Lang.Current] or T.vi
    return pack[key] or (T.vi[key] or key)
end

-- ============================================================
-- ANTI-CHEAT (kích hoạt ngay)
-- ============================================================
pcall(function()
    if type(getgc) == "function" and type(getrawmetatable) == "function" and type(setmetatable) == "function" then
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
    end
end)

local genv = _G_ENV
if type(genv.__ZEN_HUB_SHUTDOWN) == "function" then pcall(genv.__ZEN_HUB_SHUTDOWN); task.wait(0.1) end
if genv.__ZEN_HUB_RUNNING then return end
genv.__ZEN_HUB_RUNNING = true
if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
-- SERVICES
-- ============================================================
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

local unpackValues = table.unpack or unpack

-- ============================================================
-- H NAMESPACE (helpers)
-- ============================================================
local H = {}
local running = true
local conns = {}
function H.track(c) table.insert(conns, c); return c end
function H.clearTable(t) if type(t) ~= "table" then return end for k in pairs(t) do t[k] = nil end end
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
function H.getHumanoid() local ch = LocalPlayer.Character; return ch and ch:FindFirstChildWhichIsA("Humanoid") or nil end
function H.getRoot() local ch = LocalPlayer.Character; return ch and ch:FindFirstChild("HumanoidRootPart") or nil end
function H.isAlive()
    local hum = H.getHumanoid()
    return hum ~= nil and hum.Health > 0
end
function H.getSave()
    if not H.SaveModule or typeof(H.SaveModule.Get) ~= "function" then return nil end
    local ok, save = pcall(H.SaveModule.Get)
    return ok and save or nil
end
function H.countTable(v) if typeof(v) ~= "table" then return 0 end local c = 0 for _ in pairs(v) do c = c + 1 end return c end
function H.formatNumber(v)
    local n = tonumber(v) or 0
    local s = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local i = 1
    for _ = 1, 6 do if n >= 1000 then n = n / 1000; i = i + 1 end end
    if i == 1 then return string.format("%d", n) end
    return string.format("%.2f%s", n, s[i])
end
function H.formatElapsed(sec)
    local t = math.max(0, math.floor(sec))
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    if h > 0 then return string.format("%dh %dm", h, m) end
    return string.format("%dm", m)
end

-- ============================================================
-- MODULE LOADERS
-- ============================================================
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

H.SaveModule = H.requirePath(ReplicatedStorage, 6, "Shared", "Save") or H.findModule("Save")

-- ============================================================
-- REMOTE PATHS (ThanhDuy layout)
-- ============================================================
local networking = ReplicatedStorage:FindFirstChild("Packages")
networking = networking and networking:FindFirstChild("Networking") or nil

H.REMOTE_PATHS = {
    EggSnapshot    = "RF/EggWorld/AskFieldEggSnapshot",
    EggCarry       = "RF/EggWorld/AskFieldEggCarry",
    EggPlace       = "RF/EggWorld/AskPlaceEgg",
    EggDrop        = "RF/EggWorld/AskFieldEggDrop",
    EggLive        = "RF/EggWorld/AskLiveSnapshot",
    Hatch          = "RF/EggWorld/AskHatch",
    HatchFinish    = "RF/EggWorld/AskFinishHatch",
    SkipGrowth     = "RF/EggWorld/AskSkipGrowth",
    PlotState      = "RF/Homestead/AskState",
    BaseTierRaise  = "RE/Homestead/AskBaseTierRaise",
    NearbyBuy      = "RE/Homestead/AskNearbyPurchase",
    Collect        = "RF/AwayEarnings/AskCollect",
    CodexAll       = "RF/Codex/AskRedeemAll",
    WearBest       = "RF/Haul/WearBest",
    SatchelSale    = "RF/Haul/OfferFullSatchelSale",
    SellEveryPet   = "RE/PetSatchel/SellEveryPet",
    TreadRaise     = "RF/Treadmill/AskTierRaise",
    WearTool       = "RF/EggWorld/AskWearTool",
    DoffTool       = "RF/EggWorld/AskDoffTool",
    RigWipe        = "RE/RigSync/AskRigWipe",
}

function H.getRemote(path)
    if not networking then return nil end
    local ok = networking:FindFirstChild(path)
    return ok
end
function H.invoke(path, ...)
    local r = H.getRemote(path)
    if not r then return nil end
    if r:IsA("RemoteFunction") then
        local ok, res = pcall(r.InvokeServer, r, ...)
        return ok and res or nil
    end
    return pcall(r.FireServer, r, ...) or nil
end

-- ============================================================
-- AREA LIST (ThanhDuy)
-- ============================================================
local AreaData = H.requirePath(ReplicatedStorage, 6, "Data", "Areas") or H.findModule("Areas")

H.AreaLabel      = {}
H.AreaRarity     = {}
H.AreaTierName   = {}
H.AreaByLabel    = {}
H.AreaOrder      = {}
H.areaWanted     = {}
H.areaWantedCount = 0

function H.addArea(areaId, label, rarity, tierName)
    if not areaId or H.AreaLabel[areaId] then return end
    label = label or areaId
    H.AreaLabel[areaId]    = label
    H.AreaRarity[areaId]   = rarity or 0
    H.AreaTierName[areaId] = tierName
    H.AreaByLabel[label]   = areaId
    table.insert(H.AreaOrder, areaId)
end
function H.sortAreas()
    table.sort(H.AreaOrder, function(a, b)
        local ra = H.AreaRarity[a] or 0
        local rb = H.AreaRarity[b] or 0
        if ra == rb then return tostring(H.AreaLabel[a]) < tostring(H.AreaLabel[b]) end
        return ra < rb
    end)
end
function H.getAreaLabels()
    local out = {}
    for _, id in ipairs(H.AreaOrder) do table.insert(out, H.AreaLabel[id]) end
    return out
end

-- Load from game Data/Areas
do
    local dir = AreaData and (AreaData.Directory or AreaData) or nil
    if type(dir) == "table" then
        for k, item in pairs(dir) do
            if type(k) == "string" and type(item) == "table" then
                local num = 0
                local tier
                if type(item.Rarity) == "table" then
                    num = tonumber(item.Rarity.RarityNumber) or 0
                    tier = item.Rarity.DisplayName or item.Rarity._id
                end
                H.addArea(k, item.DisplayName or item.Name or k, num, tier)
            end
        end
    end
    if #H.AreaOrder == 0 then
        local areas = Workspace:FindFirstChild("Areas") or Workspace:FindFirstChild("Islands")
        if areas then
            local n = 0
            for _, item in ipairs(areas:GetChildren()) do
                n = n + 1
                H.addArea(item.Name, item.Name, n, nil)
            end
        end
    end
    H.sortAreas()
end

-- Rarity ladder
H.Rarities = { "Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Divine","Eternal" }
H.RarityLadder = {}
for i, name in ipairs(H.Rarities) do H.RarityLadder[name] = i end
function H.rarityRank(name)
    if type(name) ~= "string" then return 0 end
    return H.RarityLadder[name] or 0
end

-- Filter sets
H.rarityWanted = {}
H.rarityWantedCount = 0
function H.refreshAreaWanted(list)
    local wanted = {}
    local count = 0
    for _, label in ipairs(list or {}) do
        wanted[H.AreaByLabel[label] or label] = true
        count = count + 1
    end
    H.areaWanted = wanted
    H.areaWantedCount = count
end
function H.refreshRarityWanted(list)
    local wanted = {}
    local count = 0
    for _, name in ipairs(list or {}) do
        wanted[name] = true
        count = count + 1
    end
    H.rarityWanted = wanted
    H.rarityWantedCount = count
end

-- ============================================================
-- EGG LIST (ThanhDuy's iData.value49)
-- ============================================================
H.EggList = {}
H.EggListAt = 0
H.TriedUids = {}
H.FailUids = {}
H.AreaDirty = false

function H.getSlotsClient()
    return Workspace:FindFirstChild("AreaEggSlotsClient")
end
function H.getSlotModel(uid)
    local folder = H.getSlotsClient()
    return folder and folder:FindFirstChild(uid) or nil
end
function H.getSlotPart(uid)
    local model = H.getSlotModel(uid)
    if not model then return nil end
    return model.PrimaryPart or model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart")
end

function H.buildEggList(force)
    if not force and tick() - H.EggListAt < 1.5 then
        return H.EggList
    end
    local snap = H.invoke(H.REMOTE_PATHS.EggSnapshot)
    local records = snap and snap.Records
    if type(records) ~= "table" then return H.EggList end

    local list = {}
    for _, rec in pairs(records) do
        if rec.State == "Slot" and rec.Uid then
            local part = H.getSlotPart(rec.Uid)
            local pos
            if part then
                pos = part.Position
            else
                local cf = rec.BoundsCFrame or rec.BottomCFrame
                pos = cf and cf.Position or nil
            end
            if pos then
                local areaId = rec.AreaId
                if areaId and not H.AreaLabel[areaId] then
                    local tname = rec.Rarity or rec.RarityName or rec.Tier or rec.RarityId
                    if type(tname) == "table" then
                        tname = tname.DisplayName or tname._id or tname.Name or tname.Id
                    end
                    H.addArea(areaId, areaId, #H.AreaOrder + 1, type(tname) == "string" and tname or nil)
                    H.AreaDirty = true
                end
                local rarityId = rec.Rarity or rec.RarityName or rec.Tier or rec.RarityId
                if type(rarityId) == "table" then
                    rarityId = rarityId.DisplayName or rarityId._id or rarityId.Name or rarityId.Id
                end
                rarityId = type(rarityId) == "string" and rarityId or nil
                if H.rarityRank(rarityId) == 0 then rarityId = nil end
                if not rarityId and areaId then rarityId = H.AreaTierName[areaId] end
                local label = areaId and H.AreaLabel[areaId] or "Unknown"
                local tier  = areaId and H.AreaRarity[areaId] or 0
                local rank  = H.rarityRank(rarityId)
                local mut   = (rec.BaseMutation ~= nil) or (type(rec.Mutations) == "table" and next(rec.Mutations) ~= nil)
                local size  = rec.BoundsSize and rec.BoundsSize.Magnitude or 3
                table.insert(list, {
                    uid = rec.Uid, area = areaId, label = label, pos = pos,
                    tier = tier, rarity = rarityId, rank = rank, mutated = mut, size = size,
                })
            end
        end
    end

    if H.AreaDirty then
        H.AreaDirty = false
        H.sortAreas()
    end
    H.EggList = list
    H.EggListAt = tick()
    return list
end

-- ============================================================
-- FILTER (ThanhDuy's iData.value50)
-- ============================================================
function H.eggAllowed(egg)
    local t = H.TriedUids[egg.uid]
    if t then
        local fails = H.FailUids[egg.uid] or 0
        local delay = 6
        if fails >= 4 then delay = 600
        elseif fails == 3 then delay = 120
        elseif fails == 2 then delay = 45
        elseif fails == 1 then delay = 18 end
        if delay > tick() - t then return false end
    end
    if H.areaWantedCount > 0 then
        if not H.areaWanted[egg.area] then return false end
        return true
    end
    if egg.rank >= (H.RarityLadder.Secret or 8) then return true end
    if H.rarityWantedCount > 0 and not H.rarityWanted[egg.rarity] then return false end
    return true
end

-- ============================================================
-- PICK BEST TARGET (ThanhDuy's handleFlag)
-- ============================================================
function H.pickEggTarget()
    local root = H.getRoot()
    if not root then return nil end
    H.buildEggList(false)
    local origin = root.Position
    local best, bestScore
    for _, egg in ipairs(H.EggList) do
        if H.eggAllowed(egg) then
            local dist = (egg.pos - origin).Magnitude
            local tier = egg.tier > 0 and egg.tier or egg.rank
            local score = egg.rank * 1e12 + tier * 1e8 + (egg.mutated and 1e6 or 0) - math.min(dist, 1e5)
            if not bestScore or bestScore < score then
                bestScore = score
                best = egg
            end
        end
    end
    return best
end

-- ============================================================
-- GROUND PROBE (ThanhDuy's iData.value59)
-- ============================================================
H.groundParams = RaycastParams.new()
H.groundParams.FilterType = Enum.RaycastFilterType.Exclude
H.groundParams.IgnoreWater = true

local function skipCharacter(parent)
    for _ = 1, 6 do
        if not parent or parent == Workspace then return false end
        if (parent:IsA("Model") and parent:FindFirstChildWhichIsA("Humanoid"))
            or parent:FindFirstChildWhichIsA("AnimationController") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function H.rayGroundY(x, z, startY, depth)
    local y = startY
    for _ = 1, 4 do
        local hit = Workspace:Raycast(Vector3.new(x, y, z), Vector3.new(0, -(y - (startY - depth)), 0), H.groundParams)
        if not hit then return nil end
        if not skipCharacter(hit.Instance) then return hit.Position.Y end
        y = hit.Position.Y - 0.6
        if y <= startY - depth then return nil end
    end
    return nil
end
function H.groundY(x, z, baseY)
    local PROBE_LOW, PROBE_HIGH, PROBE_DOWN = 7, 160, 420
    local a = H.rayGroundY(x, z, baseY + PROBE_LOW, PROBE_LOW + PROBE_DOWN)
    if a then return a end
    local b = H.rayGroundY(x, z, baseY + PROBE_HIGH, PROBE_HIGH + PROBE_DOWN)
    if b and b > baseY + PROBE_LOW then return b end
    return nil
end

-- ============================================================
-- GROUND REFRESH / FILTER (ThanhDuy's iData.value56/57)
-- ============================================================
function H.refreshGroundFilter()
    local exclude = {}
    if LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then table.insert(exclude, p.Character) end
    end
    local slot = H.getSlotsClient()
    if slot then table.insert(exclude, slot) end
    H.groundParams.FilterDescendantsInstances = exclude
end

-- ============================================================
-- ANTI-TRAP (ThanhDuy's iData.value52/53/54)
-- ============================================================
H.TrapRadius = 16
H.TrapWords = { "trap", "cage", "snare" }
H.TrapList = {}
H.TrapModels = {}
H.TrapAt = 0
H.AntiTrap = true

function H.refreshTraps()
    local list, models = {}, {}
    local debris = Workspace:FindFirstChild("__DEBRIS")
    for _, container in ipairs({ debris, Workspace }) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                local isTrap = false
                if child:IsA("Model") then
                    if child:FindFirstChild("UnplacePrompt") then
                        isTrap = true
                    else
                        local lower = child.Name:lower()
                        for _, w in ipairs(H.TrapWords) do
                            if lower:find(w, 1, true) then isTrap = true; break end
                        end
                    end
                end
                if isTrap then
                    local ok, pivot = pcall(function() return child:GetPivot() end)
                    local pos = ok and pivot and pivot.Position
                    if not pos then
                        local part = child:FindFirstChildWhichIsA("BasePart")
                        pos = part and part.Position
                    end
                    if pos then
                        table.insert(list, pos)
                        table.insert(models, child)
                        if H.AntiTrap then
                            for _, d in ipairs(child:GetDescendants()) do
                                if d:IsA("BasePart") then
                                    pcall(function() d.CanTouch = false end)
                                    pcall(function() d.CanCollide = false end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    H.TrapList = list
    H.TrapModels = models
    H.TrapAt = tick()
    return list
end
function H.getTraps()
    if tick() - H.TrapAt > 2 then H.refreshTraps() end
    return H.TrapList
end
function H.inTrap(x, z, radius)
    if not H.AntiTrap then return false end
    local r = (radius or H.TrapRadius); r = r * r
    for _, v in ipairs(H.getTraps()) do
        local dx, dz = v.X - x, v.Z - z
        if r > dx*dx + dz*dz then return true end
    end
    return false
end

-- ============================================================
-- ROUTE PLANNER (simplified ThanhDuy value67)
-- ============================================================
function H.planRoute(fromPos, toPos)
    -- Simple straight plan; if traps block, try side offsets
    local from = fromPos
    local dx, dz = toPos.X - from.X, toPos.Z - from.Z
    local dist = math.sqrt(dx*dx + dz*dz)
    if dist < 1 then return { toPos } end
    -- Check straight line sampling
    local samples = math.ceil(dist / 14)
    local blocked = false
    for i = 1, samples do
        local t = i / samples
        local x, z = from.X + dx*t, from.Z + dz*t
        if H.inTrap(x, z) then blocked = true; break end
    end
    if not blocked then return { toPos } end
    -- Side step around
    local ux, uz = dx/dist, dz/dist
    local sx, sz = -uz, ux
    for _, offset in ipairs({ 30, -30, 70, -70, 140, -140 }) do
        local mx, mz = from.X + dx*0.5 + sx*offset, from.Z + dz*0.5 + sz*offset
        local y = H.groundY(mx, mz, from.Y) or from.Y
        return { Vector3.new(mx, y, mz), toPos }
    end
    return { toPos }
end

-- ============================================================
-- MOVEMENT: Speed (ThanhDuy's iData.value68)
-- ============================================================
H.TRAVEL_SPEED = 1000
H.STEP_MAX = 6

local function teleportStep(root, dest, dt)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(dest)
end

function H.moveSpeed(targetPos, tolerance, keepGoing)
    local root = H.getRoot()
    if not root then return false end
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")

    local origin = root.Position
    local dx, dz = targetPos.X - origin.X, targetPos.Z - origin.Z
    local dist = math.sqrt(dx*dx + dz*dz)
    if dist <= 0.5 then
        -- Grab near prompt
        task.spawn(function()
            local origin2 = H.getRoot()
            if not origin2 then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local part = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent
                        or obj.Parent:FindFirstChildWhichIsA("BasePart"))
                    if part and (part.Position - origin2.Position).Magnitude <= 12 then
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(obj)
                            else
                                obj.HoldDuration = 0
                                obj:InputHoldBegin(); obj:InputHoldEnd()
                            end
                        end)
                    end
                end
            end
        end)
        return true
    end

    local ux, uz = dx/dist, dz/dist
    local rot = CFrame.lookAt(Vector3.zero, Vector3.new(ux, 0, uz)).Rotation

    -- Ground base
    local baseY = origin.Y
    local groundBase = H.groundY(origin.X, origin.Z, baseY) or baseY

    local traveled = 0
    local deadline = tick() + 10
    while running and (not keepGoing or keepGoing()) and tick() < deadline do
        if not H.isAlive() then return false end
        local dt = RunService.Heartbeat:Wait()
        local newRoot = H.getRoot()
        if not newRoot then return false end
        local step = math.min(H.TRAVEL_SPEED * math.min(dt, 0.1), dist - traveled)
        local pieces = math.max(1, math.ceil(step / H.STEP_MAX))
        local piece = step / pieces
        for _ = 1, pieces do
            traveled = math.min(dist, traveled + piece)
            local x, z = origin.X + ux * traveled, origin.Z + uz * traveled
            local y = H.groundY(x, z, groundBase) or groundBase
            pcall(function()
                newRoot.CFrame = CFrame.new(x, y, z) * rot
            end)
            pcall(function()
                newRoot.AssemblyLinearVelocity = Vector3.zero
                newRoot.AssemblyAngularVelocity = Vector3.zero
            end)
            if traveled >= dist - 0.01 then break end
        end
        if traveled >= dist - 0.01 then
            task.spawn(function()
                local origin2 = H.getRoot()
                if not origin2 then return end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local part = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent
                            or obj.Parent:FindFirstChildWhichIsA("BasePart"))
                        if part and (part.Position - origin2.Position).Magnitude <= 12 then
                            pcall(function()
                                if fireproximityprompt then
                                    fireproximityprompt(obj)
                                else
                                    obj.HoldDuration = 0
                                    obj:InputHoldBegin(); obj:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end
            end)
            return true
        end
    end
    local newRoot = H.getRoot()
    if not newRoot then return false end
    return (Vector3.new(targetPos.X - newRoot.Position.X, 0, targetPos.Z - newRoot.Position.Z).Magnitude <= (tolerance or 8))
end

-- ============================================================
-- MOVEMENT: TP Walk (ThanhDuy's updateHatchCursor)
-- ============================================================
H.TP_STEP = 45
H.TP_WAIT = 0.08

function H.moveTP(targetPos, tolerance, keepGoing)
    local root = H.getRoot()
    if not root then return false end
    local targetX, targetZ = targetPos.X, targetPos.Z
    local stand = (H.getRoot().Size.Y * 0.5) + (H.getHumanoid() and H.getHumanoid().HipHeight or 2)

    local deadline = tick() + 30
    while running and (not keepGoing or keepGoing()) and tick() < deadline do
        local cur = H.getRoot()
        if not cur or not H.isAlive() then break end
        local dx, dz = targetX - cur.Position.X, targetZ - cur.Position.Z
        local rem = math.sqrt(dx*dx + dz*dz)
        if rem <= 0.5 then return true end
        local step = math.min(rem, H.TP_STEP)
        local inv = 1 / rem
        local nx, nz = cur.Position.X + dx * inv * step, cur.Position.Z + dz * inv * step
        local rot = CFrame.lookAt(Vector3.zero, Vector3.new(dx * inv, 0, dz * inv)).Rotation
        local y = (H.groundY(nx, nz, cur.Position.Y - stand) or (cur.Position.Y - stand)) + stand
        pcall(function() cur.CFrame = CFrame.new(nx, y, nz) * rot end)
        pcall(function()
            cur.AssemblyLinearVelocity = Vector3.zero
            cur.AssemblyAngularVelocity = Vector3.zero
        end)
        if rem - step <= 0.5 then return true end
        task.wait(H.TP_WAIT)
    end
    local cur = H.getRoot()
    if not cur then return false end
    return (Vector3.new(targetPos.X - cur.Position.X, 0, targetPos.Z - cur.Position.Z).Magnitude <= (tolerance or 8))
end

function H.goTo(targetPos, tolerance, keepGoing)
    if not targetPos then return false end
    if H.isInRange(targetPos, tolerance or 8) then return true end
    H.refreshGroundFilter()
    H.refreshTraps()
    local root = H.getRoot()
    if not root then return false end
    local route = H.planRoute(root.Position, targetPos)
    local mover = (H.FarmMethod == "TP Walk") and H.moveTP or H.moveSpeed
    for i, wp in ipairs(route) do
        local tol = (i == #route) and (tolerance or 8) or 4
        if not mover(wp, tol, keepGoing) then return false end
    end
    local endRoot = H.getRoot()
    if not endRoot then return false end
    return (Vector3.new(targetPos.X - endRoot.Position.X, 0, targetPos.Z - endRoot.Position.Z).Magnitude <= (tolerance or 8) + 6
end
function H.isInRange(pos, tol)
    local r = H.getRoot()
    if not r or not pos then return false end
    return (Vector3.new(r.Position.X, 0, r.Position.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude <= (tol or 8)
end

-- ============================================================
-- PLOT & PEN (ThanhDuy's iData.value72/73)
-- ============================================================
H.CachedPlot = nil
H.CachedSlot = nil
H.PlotTried = 0
H.PenCache = nil

function H.findPlot()
    if H.CachedPlot and H.CachedPlot.Parent then return H.CachedPlot end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    if not H.CachedSlot then
        local state = H.invoke(H.REMOTE_PATHS.PlotState)
        if type(state) == "table" then
            local data = state.OwnersBySlot or state.SlotOwners or state.Owners or state.Slots
            if type(data) == "table" then
                for k, v in pairs(data) do
                    local id = v
                    if type(v) == "table" then
                        id = v.UserId or v.OwnerUserId or v.Id or v.Name
                    end
                    if id == LocalPlayer.UserId or id == tostring(LocalPlayer.UserId) or id == LocalPlayer.Name then
                        H.CachedSlot = k
                        break
                    end
                end
            end
        end
    end

    if H.CachedSlot then
        local p = plots:FindFirstChild(tostring(H.CachedSlot))
        if p then H.CachedPlot = p; return p end
    end

    if tick() - H.PlotTried < 10 then return nil end
    H.PlotTried = tick()
    for _, plot in ipairs(plots:GetChildren()) do
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local ok, txt = pcall(function() return d.Text end)
                if ok and type(txt) == "string" and txt:find(LocalPlayer.Name, 1, true) then
                    H.CachedPlot = plot
                    return plot
                end
            end
        end
    end
    return nil
end
function H.findPlotPivot()
    local p = H.findPlot()
    if not p then return nil end
    local ok, piv = pcall(function() return p:GetPivot() end)
    return ok and piv or nil
end
function H.findPen()
    if H.PenCache then return H.PenCache end
    local plot = H.findPlot()
    if plot then
        for _, d in ipairs(plot:GetDescendants()) do
            if d.Name:lower():find("pen", 1, true) then
                if d:IsA("BasePart") then H.PenCache = d.CFrame; return H.PenCache end
                if d:IsA("Model") then
                    local ok, piv = pcall(function() return d:GetPivot() end)
                    if ok and piv then H.PenCache = piv; return piv end
                end
            end
        end
    end
    local p = H.findPlotPivot()
    if p then
        H.PenCache = p * CFrame.new(0, 0, 15)
        return H.PenCache
    end
    return nil
end

-- ============================================================
-- EGG CARRY (ThanhDuy's iData.value83)
-- ============================================================
function H.carryEgg(uid)
    if H.invoke(H.REMOTE_PATHS.EggCarry, { Uid = uid }) ~= true then return false end
    task.spawn(function()
        for _ = 1, 3 do
            if H.hasTool() then return end
            H.invoke(H.REMOTE_PATHS.WearTool, uid)
            task.wait(0.15)
        end
    end)
    return true
end
function H.hasTool()
    local ch = LocalPlayer.Character
    return ch ~= nil and ch:FindFirstChildWhichIsA("Tool") ~= nil
end
function H.wearToolUntil(uid)
    if H.hasTool() then return true end
    for _ = 1, 8 do
        H.invoke(H.REMOTE_PATHS.WearTool, uid)
        for _ = 1, 4 do
            RunService.Heartbeat:Wait()
            if H.hasTool() then return true end
        end
    end
    return false
end

-- ============================================================
-- EGG PLACEMENT (ThanhDuy's secondaryUpdateInstanceProperties)
-- ============================================================
H.PlaceOrigin = nil
H.PlaceFails = 0
H.ClaimedCells = {}

function H.getPlotOrigins()
    local list = {}
    local plot = H.findPlot()
    if plot then
        local ok, primary = pcall(function() return plot.PrimaryPart end)
        if ok and primary then table.insert(list, primary.CFrame) end
        local bestPart, bestSize
        for _, c in ipairs(plot:GetChildren()) do
            if c:IsA("BasePart") then
                local lower = c.Name:lower()
                local matched = lower:find("base") or lower:find("plate") or lower:find("pad") or lower:find("floor") or lower:find("ground") or lower:find("origin")
                if matched then
                    local area = c.Size.X * c.Size.Z
                    if not bestSize or area > bestSize then bestPart, bestSize = c, area end
                end
            end
        end
        if bestPart then table.insert(list, bestPart.CFrame) end
        local ok2, piv = pcall(function() return plot:GetPivot() end)
        if ok2 and piv then table.insert(list, piv) end
    end
    if #list == 0 then table.insert(list, CFrame.new()) end
    return list
end
function H.placeEggAt(uid, originIndex, worldCFrame)
    local origins = H.getPlotOrigins()
    local origin = origins[originIndex]
    if not origin then return false end
    if not H.hasTool() then return false end
    local remote = H.getRemote(H.REMOTE_PATHS.EggPlace)
    if not remote or not remote:IsA("RemoteFunction") then return false end
    local localPos = (origin:Inverse() * worldCFrame).Position
    local ok, res = pcall(function()
        return remote:InvokeServer({ Uid = uid, LocalCFrame = CFrame.new(localPos) })
    end)
    if not ok then return false end
    for _ = 1, 16 do
        if not H.hasTool() then return true end
        RunService.Heartbeat:Wait()
    end
    return false
end
function H.deliverEgg(uid)
    if not H.wearToolUntil(uid) then return false end
    local origins = H.getPlotOrigins()
    for idx, _ in ipairs(origins) do
        local world = CFrame.new(Vector3.new(0,0,0))
        if H.placeEggAt(uid, idx, world) then
            H.PlaceOrigin = idx
            H.PlaceFails = 0
            return true
        end
        task.wait(0.04)
    end
    H.PlaceFails = H.PlaceFails + 1
    if H.PlaceFails >= 3 then H.PlaceOrigin = nil; H.PlaceFails = 0 end
    return false
end

-- ============================================================
-- HATCH (ThanhDuy's hatchAll)
-- ============================================================
function H.getPlacedEggUids()
    local data = H.invoke(H.REMOTE_PATHS.EggLive)
    local out = {}
    if type(data) ~= "table" then return out end
    local function collect(records)
        for k, item in pairs(records) do
            if type(item) == "table" then
                local uid = item.Uid or (type(k) == "string" and k or nil)
                if uid then
                    item.Uid = uid
                    table.insert(out, item)
                end
            end
        end
    end
    for _, group in pairs(data) do
        if type(group) == "table" then
            local owner = group.OwnerUserId or group.UserId or group.PlayerId or group.Owner
            if type(owner) == "table" then owner = owner.UserId or owner.Id end
            local isMine = (owner == LocalPlayer.UserId) or (owner == tostring(LocalPlayer.UserId)) or (owner == LocalPlayer.Name)
            if isMine and type(group.Records) == "table" then
                collect(group.Records)
            end
        end
    end
    if #out == 0 then
        for _, group in pairs(data) do
            if type(group) == "table" and type(group.Records) == "table" then collect(group.Records) end
        end
    end
    if #out == 0 and type(data.Records) == "table" then collect(data.Records) end
    return out
end
H.HatchCursor = 0
function H.hatchAll(forceAll)
    local placed = H.getPlacedEggUids()
    local count = #placed
    if count == 0 then
        H.HatchCursor = 0
        return 0
    end
    if count <= H.HatchCursor then H.HatchCursor = 0 end
    local step = forceAll and count or math.min(count, 12)
    local hatched = 0
    for i = 1, step do
        local egg = placed[(H.HatchCursor + i - 1) % count + 1]
        local uid = egg and egg.Uid
        if uid then
            H.invoke(H.REMOTE_PATHS.SkipGrowth, uid)
            H.invoke(H.REMOTE_PATHS.Hatch, uid)
            H.invoke(H.REMOTE_PATHS.HatchFinish, uid)
            hatched = hatched + 1
            task.wait(0.06)
        end
    end
    H.HatchCursor = (H.HatchCursor + step) % count
    return hatched
end

-- ============================================================
-- ANTI-CHEAT HUMANOID CLONE (ThanhDuy's createAutoStealHumanoid)
-- ============================================================
H.HumReady = false
H.HumProps = {
    "RigType","HipHeight","JumpPower","JumpHeight","UseJumpPower","AutoRotate","MaxSlopeAngle",
    "DisplayDistanceType","NameDisplayDistance","HealthDisplayDistance","AutomaticScalingEnabled",
    "BreakJointsOnDeath","RequiresNeck","EvaluateStateMachine",
}
function H.cloneHumanoid()
    local char = LocalPlayer.Character
    if not char then return false end
    local oldHum = char:FindFirstChildWhichIsA("Humanoid")
    if not oldHum then return false end
    local snap = {}
    for _, k in ipairs(H.HumProps) do
        local ok, v = pcall(function() return oldHum[k] end)
        if ok then snap[k] = v end
    end
    local ws = oldHum.WalkSpeed
    pcall(function() oldHum:Destroy() end)
    RunService.Heartbeat:Wait()
    local newHum = Instance.new("Humanoid")
    for k, v in pairs(snap) do pcall(function() newHum[k] = v end) end
    newHum.Parent = char
    RunService.Heartbeat:Wait()
    if char ~= newHum.Parent then return false end
    newHum.WalkSpeed = ws
    pcall(function() newHum:ChangeState(Enum.HumanoidStateType.Landed) end)
    local cam = Workspace.CurrentCamera
    if cam then pcall(function() cam.CameraSubject = newHum end) end
    H.HumReady = true
    return true
end

-- ============================================================
-- MAIN AUTO-STEAL LOOP (ThanhDuy's steal handler)
-- ============================================================
H.AutoSteal = false
H.SecretPriority = true
H.FarmMethod = "Speed"
H.carryingUid = nil
H.deliverAt = 0
H.deliverFails = 0
H.dryRuns = 0
H.travelToken = 0
H.travelling = false
H.warnPlantAt = 0
H.SessionStolenEggs = 0

function H.getStandOffset()
    local r = H.getRoot()
    local hum = H.getHumanoid()
    local h = (r and r.Size.Y * 0.5 or 1)
    local hip = 2
    if hum then local ok, v = pcall(function() return hum.HipHeight end); if ok and type(v)=="number" and v>0 then hip=v end end
    return h + hip
end
function H.isBlockedByTrap()
    local r = H.getRoot()
    if not r then return false end
    return H.inTrap(r.Position.X, r.Position.Z)
end
function H.deliverToBase(uid)
    local pen = H.findPen()
    if not pen then return false end
    local penPos = pen.Position
    local stand = H.getStandOffset()
    if not H.isInRange(penPos, 26) then
        H.goTo(Vector3.new(penPos.X, penPos.Y, penPos.Z), 14, function() return H.AutoSteal end)
        if not H.AutoSteal then return false end
    end
    local pen2 = H.findPen()
    if pen2 and not H.isInRange(pen2.Position, 12) then
        H.goTo(Vector3.new(pen2.Position.X, pen2.Position.Y, pen2.Position.Z), 8, function() return H.AutoSteal end)
        if not H.AutoSteal then return false end
    end
    local delivered = H.deliverEgg(uid)
    if delivered then return true end
    -- try smart prompt as fallback
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local lower = (obj.Name .. " " .. tostring(obj.ActionText) .. " " .. tostring(obj.ObjectText)):lower()
            if lower:find("place", 1, true) or lower:find("plant", 1, true) or lower:find("drop", 1, true) then
                if H.isInRange(obj.Parent and obj.Parent.Position or Vector3.zero, 12) then
                    pcall(function()
                        if fireproximityprompt then fireproximityprompt(obj)
                        else obj.HoldDuration = 0; obj:InputHoldBegin(); obj:InputHoldEnd() end
                    end)
                    for _ = 1, 12 do
                        if not H.hasTool() then return true end
                        RunService.Heartbeat:Wait()
                    end
                end
            end
        end
    end
    return false
end

function H.tryStealEgg(egg)
    local target = egg.pos
    H.TriedUids[egg.uid] = tick()

    local tol = math.max(9, egg.size * 0.6 + 7)
    local ok = H.goTo(target, tol, function() return H.AutoSteal end)
    if not H.AutoSteal then return end

    -- Try carry
    local carried = H.carryEgg(egg.uid)
    if not carried then task.wait(0.1); carried = H.carryEgg(egg.uid) end
    if carried then
        H.FailUids[egg.uid] = nil
        H.carryingUid = egg.uid
        H.deliverAt = tick()
        H.deliverFails = 0
        if H.deliverToBase(egg.uid) then
            H.carryingUid = nil
            H.SessionStolenEggs = H.SessionStolenEggs + 1
        else
            H.deliverFails = 1
        end
    else
        H.FailUids[egg.uid] = (H.FailUids[egg.uid] or 0) + 1
    end
end

function H.runStealLoop()
    while running and H.AutoSteal do
        local waitTime = 0.1
        if H.AutoSteal and H.isAlive() then
            local ok, err = pcall(function()
                -- Deliver current egg if any
                if H.carryingUid then
                    if not H.hasTool() and not H.getSlotsClient():FindFirstChild(H.carryingUid) then
                        H.carryingUid = nil; H.deliverFails = 0; return
                    end
                    if tick() - H.deliverAt < 1 then return end
                    H.deliverAt = tick()
                    if H.deliverToBase(H.carryingUid) then
                        H.carryingUid = nil; H.deliverFails = 0
                        H.SessionStolenEggs = H.SessionStolenEggs + 1
                        return
                    end
                    H.deliverFails = H.deliverFails + 1
                    if H.deliverFails >= 4 then
                        H.deliverFails = 0
                        H.invoke(H.REMOTE_PATHS.DoffTool, H.carryingUid)
                        H.carryingUid = nil
                    end
                    return
                end

                -- Secret priority: if we see a Secret and we're carrying lower, drop
                if H.SecretPriority and H.carryingUid then
                    H.buildEggList(false)
                    for _, e in ipairs(H.EggList) do
                        if e.rank >= (H.RarityLadder.Secret or 8) and H.eggAllowed(e) then
                            local cur
                            for _, x in ipairs(H.EggList) do
                                if x.uid == H.carryingUid then cur = x; break end
                            end
                            if (cur and cur.rank or 0) < e.rank then
                                pcall(function() H.invoke(H.REMOTE_PATHS.DoffTool, H.carryingUid) end)
                                H.carryingUid = nil
                                H.deliverFails = 0
                                H.travelToken = H.travelToken + 1
                                break
                            end
                        end
                    end
                end

                local egg = H.pickEggTarget()
                if not egg then
                    H.dryRuns = H.dryRuns + 1
                    H.buildEggList(true)
                    waitTime = math.min(0.6 + H.dryRuns * 0.4, 3)
                    return
                end
                H.dryRuns = 0
                H.tryStealEgg(egg)
                waitTime = 0
            end)
            if not ok then
                warn("[zen hubXsteal] steal: " .. tostring(err))
                task.wait(0.5)
            end
        else
            if H.carryingUid then
                pcall(function() H.invoke(H.REMOTE_PATHS.DoffTool, H.carryingUid) end)
                H.carryingUid = nil; H.deliverFails = 0
                H.travelToken = H.travelToken + 1
            end
            waitTime = 0.3
        end
        if waitTime > 0 then task.wait(waitTime) else RunService.Heartbeat:Wait() end
    end
end

-- Kick off a stale-travel watchdog
RunService.Heartbeat:Connect(function()
    if H.travelling and tick() - (H.lastTravelStep or 0) > 6 then
        H.travelling = false
    end
end)

-- Character respawn cleanup
LocalPlayer.CharacterAdded:Connect(function()
    H.travelToken = H.travelToken + 1
    H.travelling = false
    H.carryingUid = nil
    H.deliverFails = 0
    H.PenCache = nil
    H.HumReady = false
    task.wait(0.7)
    if H.AutoSteal then
        if not H.HumReady and H.isAlive() then
            task.spawn(H.cloneHumanoid)
        end
    end
end)

-- ============================================================
-- SETUP CHARACTER
-- ============================================================
local function setupCharacter(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hum then
        hum.PlatformStand = false
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        end)
    end
    if hrp then
        pcall(function() hrp.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 100, 100) end)
    end
end
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- ============================================================
-- EXTRA FEATURES
-- ============================================================
local PeteSettings = { AntiRagdoll = true, AntiKnock = true, AntiRagdollMode = "Không Chuyển Camera" }

RunService.Stepped:Connect(function()
    if not running or not PeteSettings.AntiRagdoll then return end
    local ch = LocalPlayer.Character
    if not ch then return end
    local hum = ch:FindFirstChildWhichIsA("Humanoid")
    local root = ch:FindFirstChild("HumanoidRootPart")
    if hum and hum.Health > 0 and root then
        hum.PlatformStand = false
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.FallingDown
            or s == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        for _, v in ipairs(ch:GetDescendants()) do
            if v:IsA("Motor6D") and not v.Enabled then v.Enabled = true end
        end
        local vel = root.AssemblyLinearVelocity
        if vel.Y > 30 then root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
    end
end)

RunService.RenderStepped:Connect(function()
    if not running or not PeteSettings.AntiKnock then return end
    local ch = LocalPlayer.Character
    if not ch then return end
    local hum = ch:FindFirstChildWhichIsA("Humanoid")
    if not hum or hum.Health <= 0 then return end
    for _, obj in ipairs(ch:GetDescendants()) do
        if obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("RopeConstraint")
            or obj:IsA("BodyVelocity") or obj:IsA("BodyThrust") then
            obj:Destroy()
        end
    end
    local cam = Workspace.CurrentCamera
    if cam and PeteSettings.AntiRagdollMode == "Chuyển Camera Sang Bản Thân" then
        if cam.CameraSubject ~= hum then cam.CameraSubject = hum end
    end
end)

local SpeedConfig = { Enabled = false, Value = 300 }
RunService.Stepped:Connect(function()
    if not running or not SpeedConfig.Enabled then return end
    local hum = H.getHumanoid()
    if hum and hum.Health > 0 and hum.WalkSpeed ~= SpeedConfig.Value then
        hum.WalkSpeed = SpeedConfig.Value
    end
end)

-- Instant interact
local InstantHold = false
local function applyInstantHold(prompt)
    if not InstantHold then return end
    local ch = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if ch and prompt:IsDescendantOf(ch) then return end
    if bp and prompt:IsDescendantOf(bp) then return end
    prompt.HoldDuration = 0
end
Workspace.DescendantAdded:Connect(function(d)
    if InstantHold and d:IsA("ProximityPrompt") then task.wait(); applyInstantHold(d) end
end)
function H.setInstantHold(s)
    InstantHold = s
    if s then
        for _, p in ipairs(Workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then applyInstantHold(p) end
        end
    end
end

-- Fix lag
local FixLag = false
local function isFoliage(o)
    local n = o.Name:lower()
    return n:find("tree") or n:find("leaf") or n:find("leaves") or n:find("grass")
        or n:find("bush") or n:find("foliage") or n:find("plant") or n:find("wood")
end
local function clayClean(o)
    if not FixLag then return end
    if isFoliage(o) then o:Destroy(); return end
    if o:IsA("SurfaceAppearance") or o:IsA("Texture") or o:IsA("Decal") then o:Destroy(); return end
    if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Sparkles") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Highlight") then
        o:Destroy(); return
    end
    if o:IsA("BasePart") or o:IsA("MeshPart") then
        o.Material = Enum.Material.SmoothPlastic
        o.CastShadow = false
        if o:IsA("MeshPart") then o.TextureID = "" end
    end
end
function H.enableFixLag()
    FixLag = true
    Lighting.FogEnd = 1e6; Lighting.FogStart = 1e6; Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")
            or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end
    for _, o in ipairs(Workspace:GetDescendants()) do clayClean(o) end
end
Workspace.DescendantAdded:Connect(function(o)
    if FixLag then task.wait(); clayClean(o) end
end)

-- Visual pets
local VisualPets = { spawned = {}, orbitRadius = 4, orbitSpeed = 0.8 }
local VisualPetsFolder = Instance.new("Folder")
VisualPetsFolder.Name = "ZenXVisualPets"; VisualPetsFolder.Parent = Workspace
function H.findPetModel(text)
    local s = text:lower()
    for _, child in ipairs(Workspace:GetChildren()) do
        for _, d in ipairs(child:GetDescendants()) do
            if d:IsA("Model") and d.Name:lower():find(s, 1, true) and d:FindFirstChildWhichIsA("BasePart") then
                return d
            end
        end
    end
    return nil
end
function H.spawnVisualPet(text)
    local model = H.findPetModel(text)
    if not model then return end
    local clone = model:Clone()
    for _, item in ipairs(clone:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("ModuleScript") then item:Destroy() end
    end
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BasePart") then
            d.Anchored = true; d.CanCollide = false; d.CanTouch = false; d.CastShadow = false
        end
    end
    clone.Name = "VP_" .. text; clone.Parent = VisualPetsFolder
    table.insert(VisualPets.spawned, { model = clone })
end
function H.clearVisualPets()
    for _, it in ipairs(VisualPets.spawned) do pcall(function() it.model:Destroy() end) end
    VisualPets.spawned = {}
end
RunService.Heartbeat:Connect(function()
    if not running then return end
    local root = H.getRoot()
    if not root or #VisualPets.spawned == 0 then return end
    local base = root.Position + Vector3.new(0, 1, 0)
    local n = #VisualPets.spawned
    local now = tick()
    for i, it in ipairs(VisualPets.spawned) do
        local ang = (i - 1) * (math.pi * 2 / n) + now * VisualPets.orbitSpeed
        local off = Vector3.new(math.cos(ang) * VisualPets.orbitRadius, 0, math.sin(ang) * VisualPets.orbitRadius)
        if it.model.PrimaryPart or it.model:FindFirstChildWhichIsA("BasePart") then
            pcall(function() it.model:PivotTo(CFrame.new(base + off) * CFrame.Angles(0, ang + math.pi, 0)) end)
        end
    end
end)

-- Void reset
local function teleportToVoid()
    local r = H.getRoot(); local hum = H.getHumanoid()
    if not r or not hum or hum.Health <= 0 then return end
    pcall(function()
        r.CFrame = CFrame.new(r.Position.X, -350, r.Position.Z)
        r.AssemblyLinearVelocity = Vector3.new(0, -280, 0)
    end)
end

-- ============================================================
-- UI (kept from previous, trimmed)
-- ============================================================
local UI = {}
UI.__state = {}
UI.__callbacks = {}
UI.__tabs = {}
UI.__activeTab = nil
UI.__connections = {}
UI.__texts = {}
UI.__tabButtons = {}
local function conn(c) table.insert(UI.__connections, c); return c end

local COLORS = {
    panelBg       = Color3.fromRGB(14, 10, 22),
    panelBg2      = Color3.fromRGB(22, 16, 34),
    panelBorder   = Color3.fromRGB(80, 40, 130),
    panelBorderHi = Color3.fromRGB(170, 80, 255),
    sidebarBg     = Color3.fromRGB(10, 6, 18),
    sectionBg     = Color3.fromRGB(30, 20, 48),
    sectionBorder = Color3.fromRGB(90, 45, 150),
    text          = Color3.fromRGB(245, 235, 255),
    textDim       = Color3.fromRGB(190, 170, 220),
    textMuted     = Color3.fromRGB(140, 120, 175),
    accent        = Color3.fromRGB(170, 60, 255),
    accentHi      = Color3.fromRGB(210, 120, 255),
    toggleOn      = Color3.fromRGB(180, 70, 255),
    toggleOff     = Color3.fromRGB(55, 40, 80),
    success       = Color3.fromRGB(150, 100, 255),
    warning       = Color3.fromRGB(220, 150, 255),
    error         = Color3.fromRGB(255, 90, 200),
    info          = Color3.fromRGB(160, 110, 255),
}
local function getGuiParent()
    if gethui then local ok, p = pcall(gethui); if ok and p then return p end end
    return CoreGui
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZenHubXstealGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 9999
screenGui.Parent = getGuiParent()

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ZenHubXstealToggle"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.DisplayOrder = 9998
toggleGui.Parent = getGuiParent()

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(52, 52)
toggleBtn.Position = UDim2.new(0, 24, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
toggleBtn.BackgroundTransparency = 0.05
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "Z"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 30
toggleBtn.TextColor3 = Color3.fromRGB(220, 130, 255)
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = toggleGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2; toggleStroke.Color = Color3.fromRGB(190, 80, 255); toggleStroke.Parent = toggleBtn
local toggleGrad = Instance.new("UIGradient", toggleStroke)
toggleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 90, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 50, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 130, 255)),
})
toggleGrad.Rotation = 45

local PANEL_W, PANEL_H = 520, 380
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.Position = UDim2.new(0.5, -PANEL_W/2, 0.5, -PANEL_H/2)
panel.BackgroundColor3 = COLORS.panelBg
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Active = true
panel.Visible = false
panel.Parent = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Thickness = 1.5; panelStroke.Color = COLORS.panelBorderHi; panelStroke.Transparency = 0.2; panelStroke.Parent = panel

local function addCorner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = p; return c end
local function addStroke(p, color, th)
    local s = Instance.new("UIStroke"); s.Color = color or COLORS.panelBorder; s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end
local function regText(lbl, key) table.insert(UI.__texts, {label = lbl, key = key}); lbl.Text = L(key); return lbl end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
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
title.Position = UDim2.fromOffset(16, 6)
title.Size = UDim2.new(0, 260, 0, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = COLORS.accentHi
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = HEADER_TEXT
title.Parent = header
local titleGrad = Instance.new("UIGradient", title)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 255)),
})

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(16, 26)
subtitle.Size = UDim2.new(0, 320, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextColor3 = COLORS.textDim
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = SUBTITLE
subtitle.Parent = header

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.fromOffset(86, 24)
discordBtn.Position = UDim2.new(1, -158, 0, 11)
discordBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 110)
discordBtn.BackgroundTransparency = 0.15
discordBtn.BorderSizePixel = 0
discordBtn.AutoButtonColor = false
discordBtn.Font = Enum.Font.GothamSemibold
discordBtn.TextSize = 11
discordBtn.TextColor3 = COLORS.text
discordBtn.Text = "Discord"
discordBtn.Parent = header
addCorner(discordBtn, 6); addStroke(discordBtn, Color3.fromRGB(120, 70, 180), 1)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 90)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = COLORS.text
closeBtn.Text = "X"
closeBtn.Parent = header
addCorner(closeBtn, 6); addStroke(closeBtn, Color3.fromRGB(150, 60, 220), 1)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

local SIDEBAR_W = 136
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 46)
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -46)
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
local sidebarList = Instance.new("UIListLayout", sidebarScroll)
sidebarList.Padding = UDim.new(0, 4)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
local sidebarPad = Instance.new("UIPadding", sidebarScroll)
sidebarPad.PaddingTop = UDim.new(0, 8); sidebarPad.PaddingLeft = UDim.new(0, 6); sidebarPad.PaddingRight = UDim.new(0, 6)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(SIDEBAR_W + 8, 54)
content.Size = UDim2.new(1, -(SIDEBAR_W + 16), 1, -62)
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
local contentList = Instance.new("UIListLayout", contentScroll)
contentList.Padding = UDim.new(0, 8)
contentList.SortOrder = Enum.SortOrder.LayoutOrder
local contentPad = Instance.new("UIPadding", contentScroll)
contentPad.PaddingRight = UDim.new(0, 6); contentPad.PaddingBottom = UDim.new(0, 10)

-- Draggable
local function makeDraggable(frame, dragArea)
    dragArea = dragArea or frame
    local dragging, dragStart, startPos = false, nil, nil
    conn(dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
end
makeDraggable(panel, header)

do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    conn(toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false; dragStart = input.Position; startPos = toggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    conn(toggleBtn.MouseButton1Click:Connect(function()
        if moved then return end
        panel.Visible = not panel.Visible
    end))
end

-- State API
function UI.GetState(id) return UI.__state[id] end
function UI.SetState(id, v, fire)
    UI.__state[id] = v
    if fire and UI.__callbacks[id] then
        for _, cb in ipairs(UI.__callbacks[id]) do pcall(cb, v) end
    end
end
function H.getState(id, fb) local v = UI.GetState(id); if v ~= nil then return v end return fb end
function H.isOn(id) return UI.GetState(id) == true end
function H.optionValue(id, fb) local v = UI.GetState(id); if v == nil then return fb end return v end
function H.multiSelected(id)
    local value = UI.GetState(id)
    local sel = {}
    if typeof(value) ~= "table" then
        if typeof(value) == "string" and value ~= "" then sel[value] = true end
        return sel
    end
    for k, item in pairs(value) do
        if item == true then sel[k] = true
        elseif typeof(k) == "number" and typeof(item) == "string" then sel[item] = true end
    end
    return sel
end

function UI.UpdateLanguage()
    for _, item in ipairs(UI.__texts) do
        if item.label and item.label.Parent then item.label.Text = L(item.key) end
    end
    for _, entry in ipairs(UI.__tabButtons) do
        if entry.btn and entry.btn.Parent then entry.btn.Text = L(entry.key) end
    end
end

local function makeTabButton(tabId, tabTitle, langKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
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
    addCorner(btn, 6)
    local pad = Instance.new("UIPadding", btn); pad.PaddingLeft = UDim.new(0, 10)
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = COLORS.accent
    indicator.BorderSizePixel = 0
    addCorner(indicator, 2)
    if langKey then table.insert(UI.__tabButtons, {btn = btn, key = langKey}) end
    local function setActive(active)
        if active then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45,25,70), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = COLORS.accentHi}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), {Size = UDim2.new(0,3,0.7,0)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.sectionBg, BackgroundTransparency = 0.5}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = COLORS.textDim}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), {Size = UDim2.new(0,3,0,0)}):Play()
        end
    end
    btn.MouseButton1Click:Connect(function()
        if UI.__activeTab == tabId then return end
        for tid, other in pairs(UI.__tabs) do
            other.Page.Visible = (tid == tabId)
            other.SetActive(tid == tabId)
        end
        UI.__activeTab = tabId
    end)
    return btn, setActive
end

function UI.AddTab(opts)
    local id = opts.Id
    local btn, setActive = makeTabButton(id, opts.Title, opts.LangKey)
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
    local pl = Instance.new("UIListLayout", page)
    pl.Padding = UDim.new(0, 8); pl.SortOrder = Enum.SortOrder.LayoutOrder
    local pp = Instance.new("UIPadding", page); pp.PaddingRight = UDim.new(0, 6)
    local tab = {Id = id, Page = page, Button = btn, SetActive = setActive}
    UI.__tabs[id] = tab
    if not UI.__activeTab then UI.__activeTab = id; page.Visible = true; setActive(true) end
    return tab
end

function UI.AddSection(tab, opts)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = COLORS.sectionBg
    section.BackgroundTransparency = 0.3
    section.BorderSizePixel = 0
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = tab.Page
    addCorner(section, 8); addStroke(section, COLORS.sectionBorder, 1)
    local sl = Instance.new("UIListLayout", section)
    sl.Padding = UDim.new(0, 6); sl.SortOrder = Enum.SortOrder.LayoutOrder
    local sp = Instance.new("UIPadding", section)
    sp.PaddingTop = UDim.new(0, 8); sp.PaddingBottom = UDim.new(0, 8)
    sp.PaddingLeft = UDim.new(0, 10); sp.PaddingRight = UDim.new(0, 10)
    if opts.Title then
        local h = Instance.new("TextLabel")
        h.BackgroundTransparency = 1
        h.Size = UDim2.new(1, 0, 0, 18)
        h.Font = Enum.Font.GothamBold
        h.TextSize = 12
        h.TextColor3 = COLORS.accentHi
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.Text = opts.Title
        h.Parent = section
        if opts.LangKey then regText(h, opts.LangKey) end
    end
    return section
end

local function makeRow(parent, h)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = COLORS.panelBg2
    row.BackgroundTransparency = 0.4
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, h or 30)
    row.Parent = parent
    addCorner(row, 6)
    local pad = Instance.new("UIPadding", row); pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    return row
end

function UI.AddToggle(parent, opts)
    local row = makeRow(parent, 34)
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Size = UDim2.new(1, -56, 0, 20)
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 12
    name.TextColor3 = COLORS.text
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Text = opts.Title or "Toggle"
    name.Parent = row
    if opts.LangKey then regText(name, opts.LangKey) end
    local sw = Instance.new("TextButton")
    sw.Size = UDim2.fromOffset(38, 20)
    sw.Position = UDim2.new(1, -38, 0.5, -10)
    sw.BackgroundColor3 = COLORS.toggleOff
    sw.BorderSizePixel = 0
    sw.Text = ""
    sw.AutoButtonColor = false
    sw.Parent = row
    addCorner(sw, 10)
    local knob = Instance.new("Frame", sw)
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = COLORS.text
    knob.BorderSizePixel = 0
    addCorner(knob, 8)
    local state = opts.Default == true
    local function render(anim)
        local info = TweenInfo.new(anim and 0.18 or 0)
        TweenService:Create(sw, info, {BackgroundColor3 = state and COLORS.toggleOn or COLORS.toggleOff}):Play()
        TweenService:Create(knob, info, {Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)}):Play()
    end
    render(false)
    UI.__state[opts.Id] = state
    sw.MouseButton1Click:Connect(function()
        state = not state
        UI.SetState(opts.Id, state, true)
        render(true)
        if opts.Callback then pcall(opts.Callback, state) end
    end)
    return sw
end

function UI.AddSlider(parent, opts)
    local row = makeRow(parent, 42)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Slider"
    label.Parent = row
    if opts.LangKey then regText(label, opts.LangKey) end
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(1, -70, 0, 0)
    valLbl.Size = UDim2.fromOffset(70, 18)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11
    valLbl.TextColor3 = COLORS.accentHi
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row
    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0, 24)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.BackgroundColor3 = COLORS.toggleOff
    bar.BorderSizePixel = 0
    bar.Parent = row
    addCorner(bar, 3)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.accent
    fill.BorderSizePixel = 0
    addCorner(fill, 3)
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.fromOffset(14, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = COLORS.text
    knob.BorderSizePixel = 0
    addCorner(knob, 7)
    local minV, maxV, stepV = opts.Min or 0, opts.Max or 100, opts.Step or 1
    local suffix = opts.Suffix or ""
    local value = tonumber(opts.Default) or minV
    UI.__state[opts.Id] = value
    local function render()
        local a = (value - minV) / math.max(0.0001, (maxV - minV))
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        valLbl.Text = tostring(value) .. suffix
    end
    render()
    local dragging = false
    local function updateFromX(x)
        local absX = bar.AbsolutePosition.X
        local absW = bar.AbsoluteSize.X
        local a = math.clamp((x - absX) / math.max(1, absW), 0, 1)
        local raw = minV + a * (maxV - minV)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateFromX(input.Position.X)
        end
    end)
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end))
    conn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    return bar
end

function UI.AddDropdown(parent, opts)
    local isMulti = opts.Multi == true
    local row = makeRow(parent, 32)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Dropdown"
    label.Parent = row
    if opts.LangKey then regText(label, opts.LangKey) end
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(1, -190, 0, 0)
    valLbl.Size = UDim2.fromOffset(156, 32)
    valLbl.Font = Enum.Font.Gotham
    valLbl.TextSize = 11
    valLbl.TextColor3 = COLORS.textDim
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd
    valLbl.Parent = row
    local arrow = Instance.new("TextButton")
    arrow.Size = UDim2.fromOffset(26, 22)
    arrow.Position = UDim2.new(1, -30, 0.5, -11)
    arrow.BackgroundColor3 = COLORS.toggleOff
    arrow.BackgroundTransparency = 0.4
    arrow.BorderSizePixel = 0
    arrow.AutoButtonColor = false
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 11
    arrow.TextColor3 = COLORS.text
    arrow.Text = "v"
    arrow.Parent = row
    addCorner(arrow, 4)
    local dd = Instance.new("Frame")
    dd.BackgroundColor3 = COLORS.panelBg2
    dd.BorderSizePixel = 0
    dd.Size = UDim2.new(1, 0, 0, 0)
    dd.AutomaticSize = Enum.AutomaticSize.Y
    dd.Visible = false
    dd.Parent = parent
    addCorner(dd, 6); addStroke(dd, COLORS.panelBorder, 1)
    local dl = Instance.new("UIListLayout", dd)
    dl.Padding = UDim.new(0, 2); dl.SortOrder = Enum.SortOrder.LayoutOrder
    local dp = Instance.new("UIPadding", dd)
    dp.PaddingTop = UDim.new(0, 4); dp.PaddingBottom = UDim.new(0, 4)
    dp.PaddingLeft = UDim.new(0, 4); dp.PaddingRight = UDim.new(0, 4)
    local selected
    if isMulti then
        selected = {}
        if typeof(opts.Default) == "table" then for _, v in ipairs(opts.Default) do selected[v] = true end end
        UI.__state[opts.Id] = {}
        for k in pairs(selected) do table.insert(UI.__state[opts.Id], k) end
    else
        selected = opts.Default or (opts.Options and opts.Options[1])
        UI.__state[opts.Id] = selected
    end
    local function upd()
        if isMulti then
            local l = {}
            for k in pairs(selected) do if selected[k] then table.insert(l, k) end end
            table.sort(l)
            if #l == 0 then valLbl.Text = L("all")
            elseif #l <= 2 then valLbl.Text = table.concat(l, ", ")
            else valLbl.Text = string.format("%s +%d", l[1], #l - 1) end
        else valLbl.Text = tostring(selected or "") end
    end
    upd()
    local entries = {}
    for _, opt in ipairs(opts.Options or {}) do
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
        entry.Text = "  " .. tostring(opt)
        entry.Parent = dd
        addCorner(entry, 4)
        entries[opt] = entry
        local function refresh()
            local active = isMulti and selected[opt] == true or (not isMulti and selected == opt)
            entry.TextColor3 = active and COLORS.accentHi or COLORS.text
        end
        refresh()
        entry.MouseButton1Click:Connect(function()
            if isMulti then
                selected[opt] = not selected[opt]
                local l = {}
                for k, v in pairs(selected) do if v then table.insert(l, k) end end
                UI.SetState(opts.Id, l, true)
            else
                selected = opt
                UI.SetState(opts.Id, selected, true)
            end
            for o, e in pairs(entries) do
                local act = isMulti and selected[o] == true or (not isMulti and selected == o)
                e.TextColor3 = act and COLORS.accentHi or COLORS.text
            end
            upd()
            if opts.Callback then pcall(opts.Callback, UI.__state[opts.Id]) end
            if not isMulti then dd.Visible = false; arrow.Text = "v" end
        end)
    end
    arrow.MouseButton1Click:Connect(function()
        dd.Visible = not dd.Visible
        arrow.Text = dd.Visible and "^" or "v"
    end)
    return arrow
end

function UI.AddButton(parent, opts)
    local row = makeRow(parent, 32)
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
    if opts.LangKey then regText(btn, opts.LangKey) end
    local act = Instance.new("TextLabel")
    act.BackgroundColor3 = COLORS.accent
    act.BackgroundTransparency = 0.15
    act.Size = UDim2.fromOffset(64, 22)
    act.Position = UDim2.new(1, -64, 0.5, -11)
    act.Font = Enum.Font.GothamBold
    act.TextSize = 11
    act.TextColor3 = COLORS.text
    act.Text = opts.Text or "Run"
    act.Parent = row
    addCorner(act, 4)
    btn.MouseButton1Click:Connect(function() if opts.Callback then pcall(opts.Callback) end end)
    return btn
end

function UI.AddDivider(parent, opts)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 12)
    holder.Parent = parent
    local line = Instance.new("Frame", holder)
    line.BackgroundColor3 = COLORS.panelBorder
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Size = UDim2.new(1, 0, 0, 1)
    if opts and opts.Title then
        local lbl = Instance.new("TextLabel", holder)
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextColor3 = COLORS.textMuted
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.Text = opts.Title
        if opts.LangKey then regText(lbl, opts.LangKey) end
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
    if opts.LangKey then regText(name, opts.LangKey) end
    local val = Instance.new("TextLabel")
    val.BackgroundTransparency = 1
    val.Size = UDim2.new(0.4, 0, 1, 0)
    val.Position = UDim2.fromScale(0.6, 0)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextColor3 = COLORS.accentHi
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.Text = tostring(opts.Value or "")
    val.Parent = row
    local api = {}
    function api.SetValue(v) val.Text = tostring(v) end
    function api.SetStatus(s)
        if s == "Success" then val.TextColor3 = COLORS.success
        elseif s == "Warning" then val.TextColor3 = COLORS.warning
        elseif s == "Error" then val.TextColor3 = COLORS.error
        elseif s == "Info" then val.TextColor3 = COLORS.info
        else val.TextColor3 = COLORS.text end
    end
    return api
end

function UI.AddInput(parent, opts)
    local row = makeRow(parent, 32)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = opts.Title or "Input"
    label.Parent = row
    if opts.LangKey then regText(label, opts.LangKey) end
    local box = Instance.new("TextBox")
    box.BackgroundColor3 = COLORS.toggleOff
    box.BackgroundTransparency = 0.2
    box.BorderSizePixel = 0
    box.Position = UDim2.fromScale(0.42, 0.5)
    box.AnchorPoint = Vector2.new(0, 0.5)
    box.Size = UDim2.new(0.58, -10, 0, 24)
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
    local p = Instance.new("UIPadding", box); p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6)
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
local NL = Instance.new("UIListLayout", NotifyHolder)
NL.Padding = UDim.new(0, 6)
NL.VerticalAlignment = Enum.VerticalAlignment.Bottom
NL.HorizontalAlignment = Enum.HorizontalAlignment.Right

function H.notify(title, content, variant, duration)
    local n = Instance.new("Frame")
    n.BackgroundColor3 = COLORS.panelBg
    n.BackgroundTransparency = 0.05
    n.BorderSizePixel = 0
    n.Size = UDim2.fromOffset(240, 48)
    n.Parent = NotifyHolder
    addCorner(n, 8)
    local sc = COLORS.panelBorderHi
    if variant == "Success" then sc = COLORS.success
    elseif variant == "Warning" then sc = COLORS.warning
    elseif variant == "Error" then sc = COLORS.error
    elseif variant == "Info" then sc = COLORS.info end
    addStroke(n, sc, 1.5)
    local t = Instance.new("TextLabel", n)
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(10, 5)
    t.Size = UDim2.new(1, -20, 0, 16)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = sc
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = tostring(title or "zen hubXsteal")
    local c = Instance.new("TextLabel", n)
    c.BackgroundTransparency = 1
    c.Position = UDim2.fromOffset(10, 22)
    c.Size = UDim2.new(1, -20, 0, 20)
    c.Font = Enum.Font.Gotham
    c.TextSize = 10
    c.TextColor3 = COLORS.textDim
    c.TextXAlignment = Enum.TextXAlignment.Left
    c.TextWrapped = true
    c.Text = tostring(content or "")
    task.delay(tonumber(duration) or 3, function()
        local info = TweenInfo.new(0.25)
        TweenService:Create(n, info, {BackgroundTransparency = 1}):Play()
        for _, d in ipairs(n:GetDescendants()) do
            if d:IsA("TextLabel") then TweenService:Create(d, info, {TextTransparency = 1}):Play()
            elseif d:IsA("UIStroke") then TweenService:Create(d, info, {Transparency = 1}):Play() end
        end
        task.wait(0.3); n:Destroy()
    end)
end

-- ============================================================
-- BUILD UI
-- ============================================================
local refs = {}
do
    -- HOME
    local HomeTab = UI.AddTab({Id = "home", Title = "Home", LangKey = "tab_home"})
    local SessionSec = UI.AddSection(HomeTab, {Title = "Session", LangKey = "sec_session"})
    local AccountSec = UI.AddSection(HomeTab, {Title = "Account", LangKey = "sec_account"})
    local QuickSec = UI.AddSection(HomeTab, {Title = "Quick Actions", LangKey = "sec_quick"})

    refs.statusRow = UI.AddStatus(SessionSec, {Title = "Automation", LangKey = "st_automation", Value = "Ready"})
    refs.statusRow:SetStatus("Success")
    refs.bypassRow = UI.AddStatus(SessionSec, {Title = "Bypass", Value = "Not Ready"})
    refs.stolenRow = UI.AddStatus(SessionSec, {Title = "Stolen Eggs", LangKey = "st_stolen_eggs", Value = "0"})
    refs.carryingRow = UI.AddStatus(SessionSec, {Title = "Carrying Egg", LangKey = "st_carrying", Value = "No"})
    refs.runtimeRow = UI.AddStatus(SessionSec, {Title = "Runtime", LangKey = "st_runtime", Value = "0m"})
    UI.AddStatus(SessionSec, {Title = "Server", LangKey = "st_server", Value = "..."})
    refs.moneyRow = UI.AddStatus(AccountSec, {Title = "Money", LangKey = "st_money", Value = "0"})
    refs.rebirthRow = UI.AddStatus(AccountSec, {Title = "Rebirths", LangKey = "st_rebirths", Value = "0"})

    UI.AddButton(QuickSec, {Title = "Activate Anti-Cheat Bypass (Clone Humanoid)", LangKey = "btn_bypass", Text = "Run", Callback = function()
        local ok = H.cloneHumanoid()
        if ok then
            H.notify("zen hubXsteal", L("n_bypass_ok"), "Success", 3)
            refs.bypassRow:SetValue(L("st_ready_bypass")); refs.bypassRow:SetStatus("Success")
        else
            H.notify("zen hubXsteal", L("n_bypass_fail"), "Error", 3)
        end
    end})
    UI.AddButton(QuickSec, {Title = "Server Hop", LangKey = "btn_server_hop", Text = "Hop", Callback = function()
        task.spawn(function() H.serverHop() end)
    end})
    UI.AddButton(QuickSec, {Title = "Teleport to Void (Fast Reset)", LangKey = "btn_void", Text = "Void", Callback = function()
        teleportToVoid(); H.notify("zen hubXsteal", L("n_void"), "Info", 3)
    end})

    -- FARM (ThanhDuy system)
    local FarmTab = UI.AddTab({Id = "farm", Title = "Farm", LangKey = "tab_farm"})
    local StealSec = UI.AddSection(FarmTab, {Title = "Steal Eggs", LangKey = "sec_steal"})
    local PrioritySec = UI.AddSection(FarmTab, {Title = "Task Order", LangKey = "sec_task_order"})
    local LifeSec = UI.AddSection(FarmTab, {Title = "Egg Handling", LangKey = "sec_egg_handling"})

    UI.AddToggle(StealSec, {Id = "AutoSteal", Title = "Enable Auto Steal (ThanhDuy)", LangKey = "tg_auto_steal",
        Description = "Speed/TP Walk: steal rarest egg → plant at base",
        Default = false,
        Callback = function(on)
            H.AutoSteal = on
            if on then
                task.spawn(H.cloneHumanoid)
                task.spawn(H.runStealLoop)
                H.notify("zen hubXsteal", L("n_autosteal_on"), "Success", 3)
            else
                H.travelToken = H.travelToken + 1
                H.travelling = false
                H.notify("zen hubXsteal", L("n_autosteal_off"), "Warning", 3)
            end
        end})

    UI.AddToggle(StealSec, {Id = "SecretPriority", Title = "Secret Egg Priority", LangKey = "tg_secret_priority", Default = true,
        Callback = function(on) H.SecretPriority = on end})

    UI.AddDropdown(StealSec, {Id = "FarmMethod", Title = "Farm Method", LangKey = "dd_farm_method",
        Options = { "Speed", "TP Walk" }, Default = "Speed",
        Callback = function(v)
            local val = v
            if typeof(v) == "table" then val = v[1] or v end
            if val == "Speed" or val == "TP Walk" then
                H.FarmMethod = val
                H.travelToken = H.travelToken + 1
                H.travelling = false
            end
        end})

    UI.AddSlider(StealSec, {Id = "TpStep", Title = "TP Walk Step Size", LangKey = "sl_tp_step",
        Min = 10, Max = 200, Default = H.TP_STEP, Step = 5,
        Callback = function(v) H.TP_STEP = v end})
    UI.AddSlider(StealSec, {Id = "TpWait", Title = "TP Walk Delay (ms)", LangKey = "sl_tp_wait",
        Min = 0, Max = 300, Default = math.round(H.TP_WAIT * 1000), Step = 10,
        Callback = function(v) H.TP_WAIT = v / 1000 end})

    UI.AddDivider(StealSec, {Title = "Target filters", LangKey = "dv_target_filter"})
    local areaValues = H.getAreaLabels()
    if #areaValues == 0 then areaValues = { "Loading..." } end
    refs.areaDropdown = UI.AddDropdown(StealSec, {
        Id = "FocusAreas", Title = "Areas", LangKey = "dd_areas",
        Options = areaValues, Multi = true, Default = {},
        Callback = function(v)
            local list = {}
            if typeof(v) == "table" then
                for k, item in pairs(v) do
                    if item == true then list[#list+1] = k
                    elseif typeof(k) == "number" and typeof(item) == "string" then list[#list+1] = item end
                end
            end
            H.refreshAreaWanted(list)
        end})
    UI.AddDropdown(StealSec, {
        Id = "RarityFilter", Title = "Rarities", LangKey = "dd_rarities",
        Options = H.Rarities, Multi = true, Default = {},
        Callback = function(v)
            local list = {}
            if typeof(v) == "table" then
                for k, item in pairs(v) do
                    if item == true then list[#list+1] = k
                    elseif typeof(k) == "number" and typeof(item) == "string" then list[#list+1] = item end
                end
            end
            H.refreshRarityWanted(list)
        end})
    UI.AddToggle(StealSec, {Id = "AntiTrap", Title = "Anti-Trap", LangKey = "tg_anti_trap", Default = true,
        Callback = function(v)
            H.AntiTrap = v
            if v then H.refreshTraps() end
        end})

    UI.AddToggle(LifeSec, {Id = "AutoHatch", Title = "Auto Hatch Ready", LangKey = "tg_auto_hatch", Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while running and H.isOn("AutoHatch") do
                        pcall(H.hatchAll, false)
                        task.wait(2)
                    end
                end)
            end
        end})
    UI.AddButton(LifeSec, {Title = "Hatch Once", Text = "Hatch", Callback = function()
        task.spawn(function()
            local n = H.hatchAll(true)
            H.notify("zen hubXsteal", string.format(L("n_hatched"), n), "Success", 3)
        end)
    end})

    -- PETS
    local PetsTab = UI.AddTab({Id = "pets", Title = "Pets", LangKey = "tab_pets"})
    local PetsSec = UI.AddSection(PetsTab, {Title = "Pets", LangKey = "sec_pets"})
    UI.AddToggle(PetsSec, {Id = "AutoEquipBest", Title = "Auto Equip Best Pets", LangKey = "tg_auto_equip_best", Default = false})
    UI.AddToggle(PetsSec, {Id = "HideOwnPets", Title = "Hide Own Pet Renders", LangKey = "tg_hide_own_pets", Default = false})
    UI.AddToggle(PetsSec, {Id = "AutoFusePets", Title = "Auto Fuse Pets", LangKey = "tg_auto_fuse", Default = false})
    UI.AddToggle(PetsSec, {Id = "AutoSellPets", Title = "Auto Sell Pets", LangKey = "tg_auto_sell_pets", Default = false})

    -- PLAYER
    local PlayerTab = UI.AddTab({Id = "player", Title = "Player", LangKey = "tab_player"})
    local EspSec = UI.AddSection(PlayerTab, {Title = "ESP", LangKey = "sec_esp"})
    local MoveSec = UI.AddSection(PlayerTab, {Title = "Movement", LangKey = "sec_movement"})
    UI.AddToggle(EspSec, {Id = "EspWorldEggs", Title = "World Egg ESP", LangKey = "tg_esp_world", Default = false})
    UI.AddToggle(EspSec, {Id = "EspPlayers", Title = "Player ESP", LangKey = "tg_esp_players", Default = false})
    UI.AddToggle(EspSec, {Id = "EspPets", Title = "Pet ESP", LangKey = "tg_esp_pets", Default = false})
    UI.AddToggle(MoveSec, {Id = "WalkSpeedEnabled", Title = "Walk Speed Override", LangKey = "tg_walkspeed", Default = false})
    UI.AddSlider(MoveSec, {Id = "WalkSpeed", Title = "Walk Speed", LangKey = "sl_walkspeed", Min = 16, Max = 500, Default = 32, Step = 1})
    UI.AddToggle(MoveSec, {Id = "JumpPowerEnabled", Title = "Jump Power Override", LangKey = "tg_jumppower", Default = false})
    UI.AddSlider(MoveSec, {Id = "JumpPower", Title = "Jump Power", LangKey = "sl_jumppower", Min = 10, Max = 500, Default = 50, Step = 1})
    UI.AddToggle(MoveSec, {Id = "InfJump", Title = "Infinite Jump", LangKey = "tg_infjump", Default = false})
    UI.AddToggle(MoveSec, {Id = "NoClip", Title = "NoClip", LangKey = "tg_noclip", Default = false})
    UI.AddToggle(MoveSec, {Id = "Fly", Title = "Fly", LangKey = "tg_fly", Default = false,
        Callback = function(v) if not v then local h = H.getHumanoid(); if h then h.PlatformStand = false end end end})
    UI.AddSlider(MoveSec, {Id = "FlySpeed", Title = "Fly Speed", LangKey = "sl_flyspeed", Min = 10, Max = 400, Default = 60, Step = 1})

    -- EXTRAS
    local ExtraTab = UI.AddTab({Id = "extras", Title = "Extras", LangKey = "tab_extras"})
    local BypassSec = UI.AddSection(ExtraTab, {Title = "Anti-Cheat Bypass", LangKey = "sec_bypass"})
    UI.AddButton(BypassSec, {Title = "Activate Anti-Cheat Bypass (Clone Humanoid)", LangKey = "btn_bypass", Text = "Run",
        Callback = function()
            local ok = H.cloneHumanoid()
            if ok then
                H.notify("zen hubXsteal", L("n_bypass_ok"), "Success", 3)
                refs.bypassRow:SetValue(L("st_ready_bypass")); refs.bypassRow:SetStatus("Success")
            else
                H.notify("zen hubXsteal", L("n_bypass_fail"), "Error", 3)
            end
        end})
    UI.AddToggle(BypassSec, {Id = "BypassAutoApply", Title = "Auto-Apply Bypass on Respawn", LangKey = "tg_bypass_auto", Default = false})

    local CombatSec = UI.AddSection(ExtraTab, {Title = "Combat / Survival", LangKey = "sec_combat"})
    UI.AddToggle(CombatSec, {Id = "AntiRagdoll", Title = "Anti-Ragdoll / Anti-Knock", LangKey = "tg_anti_ragdoll", Default = true,
        Callback = function(v) PeteSettings.AntiRagdoll = v end})
    UI.AddDropdown(CombatSec, {Id = "AntiRagdollMode", Title = "Camera Mode", LangKey = "dd_anti_ragdoll_mode",
        Options = { "Không Chuyển Camera", "Chuyển Camera Sang Bản Thân" }, Default = "Không Chuyển Camera",
        Callback = function(v) PeteSettings.AntiRagdollMode = v end})

    local InteractSec = UI.AddSection(ExtraTab, {Title = "Interaction", LangKey = "sec_interaction"})
    UI.AddToggle(InteractSec, {Id = "InstantHold", Title = "Instant Interact (No Hold)", LangKey = "tg_instant_hold", Default = false,
        Callback = function(v) H.setInstantHold(v) end})

    local SpeedSec = UI.AddSection(ExtraTab, {Title = "Speed Changer", LangKey = "sec_speed_changer"})
    UI.AddToggle(SpeedSec, {Id = "SpeedChanger", Title = "Enable WalkSpeed Lock", LangKey = "tg_speed_changer", Default = false,
        Callback = function(v) SpeedConfig.Enabled = v end})
    UI.AddSlider(SpeedSec, {Id = "SpeedValue", Title = "WalkSpeed Value", LangKey = "sl_speed_val", Min = 16, Max = 900, Default = 300, Step = 10,
        Callback = function(v) SpeedConfig.Value = v end})

    local PerfSec = UI.AddSection(ExtraTab, {Title = "Performance", LangKey = "sec_perf"})
    UI.AddButton(PerfSec, {Title = "Fix Lag (Clay + Remove Foliage)", LangKey = "btn_fixlag", Text = "Apply",
        Callback = function() H.enableFixLag(); H.notify("zen hubXsteal", L("n_fixlag_applied"), "Success", 3) end})

    local VisualSec = UI.AddSection(ExtraTab, {Title = "Visual Pets (Client Only)", LangKey = "sec_visual_pets"})
    UI.AddInput(VisualSec, {Id = "VisualPetName", Title = "Pet Name", LangKey = "in_vpet_name", Placeholder = "Dragon", Default = ""})
    UI.AddSlider(VisualSec, {Id = "VpRadius", Title = "Orbit Radius", LangKey = "sl_vpet_radius", Min = 2, Max = 20, Default = 4, Step = 1,
        Callback = function(v) VisualPets.orbitRadius = v end})
    UI.AddSlider(VisualSec, {Id = "VpSpeed", Title = "Orbit Speed", LangKey = "sl_vpet_speed", Min = 0, Max = 10, Default = 4, Step = 1,
        Callback = function(v) VisualPets.orbitSpeed = v * 0.2 end})
    UI.AddButton(VisualSec, {Title = "Spawn Visual Pet", LangKey = "btn_spawn_vpet", Text = "Spawn", Callback = function()
        local n = H.optionValue("VisualPetName", "")
        if n == "" then H.notify("zen hubXsteal", L("n_enter_pet"), "Warning", 3); return end
        H.spawnVisualPet(n)
    end})
    UI.AddButton(VisualSec, {Title = "Clear All Visual Pets", LangKey = "btn_clear_vpet", Text = "Clear", Callback = function() H.clearVisualPets() end})

    -- SYSTEM
    local SysTab = UI.AddTab({Id = "system", Title = "System", LangKey = "tab_system"})
    local LangSec = UI.AddSection(SysTab, {Title = "Language", LangKey = "sec_language"})
    UI.AddDropdown(LangSec, {
        Id = "LangSelect", Title = "Language",
        Options = { "Tiếng Việt", "English" },
        Default = (Lang.Current == "vi") and "Tiếng Việt" or "English",
        Callback = function(value)
            local sel = value
            if typeof(value) == "table" then sel = value[1] or value end
            if sel == "English" and Lang.Current ~= "en" then
                Lang.Current = "en"; UI.UpdateLanguage()
                H.notify("zen hubXsteal", L("n_lang_changed"), "Success", 3)
            elseif sel == "Tiếng Việt" and Lang.Current ~= "vi" then
                Lang.Current = "vi"; UI.UpdateLanguage()
                H.notify("zen hubXsteal", L("n_lang_changed"), "Success", 3)
            end
        end})

    local SessionSys = UI.AddSection(SysTab, {Title = "Session", LangKey = "sec_session"})
    local PerfSys = UI.AddSection(SysTab, {Title = "Performance", LangKey = "sec_performance"})
    local AboutSys = UI.AddSection(SysTab, {Title = "About", LangKey = "sec_about"})
    UI.AddToggle(SessionSys, {Id = "AntiAfk", Title = "Anti-AFK", LangKey = "tg_anti_afk", Default = true})
    UI.AddToggle(SessionSys, {Id = "NoPause", Title = "No Gameplay Paused", LangKey = "tg_no_pause", Default = true})
    UI.AddButton(SessionSys, {Title = "Rejoin Server", LangKey = "btn_rejoin", Text = "Rejoin", Callback = function() H.rejoinServer() end})
    UI.AddToggle(PerfSys, {Id = "FpsBoost", Title = "FPS Boost", LangKey = "tg_fps_boost", Default = false})
    UI.AddSlider(PerfSys, {Id = "FpsCap", Title = "FPS Cap", LangKey = "sl_fps_cap", Min = 15, Max = 360, Default = 60, Step = 1, Suffix = " fps"})
    UI.AddButton(AboutSys, {Title = "Copy Discord Link", LangKey = "btn_copy_discord", Text = "Copy", Callback = function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        H.notify("zen hubXsteal", L("n_discord_copied"), "Success", 3)
    end})
    UI.AddDivider(AboutSys, {Title = "Danger Zone", LangKey = "dv_danger"})
    UI.AddButton(AboutSys, {Title = "Unload Script", LangKey = "btn_unload", Text = "Unload", Callback = function() H.unload() end})
end

UI.UpdateLanguage()

-- ============================================================
-- SERVER HOP / REJOIN
-- ============================================================
H.Visited = {}
function H.fetchServers()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100"
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or type(body) ~= "string" then return {} end
    local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then return {} end
    local out = {}
    for _, s in ipairs(data.data) do
        if s.id and s.id ~= game.JobId and not H.Visited[s.id] and (s.playing or 0) < (s.maxPlayers or 30) then
            table.insert(out, s.id)
        end
    end
    for i = #out, 2, -1 do
        local j = math.random(i)
        out[i], out[j] = out[j], out[i]
    end
    return out
end
function H.serverHop()
    local targets = H.fetchServers()
    for _, id in ipairs(targets) do
        H.Visited[id] = true
        if pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer) end) then
            task.wait(6)
            return true
        end
    end
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    return #targets > 0
end
function H.rejoinServer()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end

-- ============================================================
-- ESP (simple world egg + player)
-- ============================================================
local EspFolder = Instance.new("Folder")
EspFolder.Name = "ZenXEsp"; EspFolder.Parent = Workspace
local EspEntries = {}
local function getEspEntry(uid)
    if EspEntries[uid] then return EspEntries[uid] end
    local anchor = Instance.new("Part", EspFolder)
    anchor.Name = "EspAnchor_" .. uid
    anchor.Anchored = true; anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false
    anchor.Transparency = 1; anchor.Size = Vector3.new(0.2, 0.2, 0.2)
    local bb = Instance.new("BillboardGui", anchor)
    bb.Size = UDim2.fromOffset(200, 30); bb.AlwaysOnTop = true; bb.StudsOffset = Vector3.new(0, 3, 0)
    local tl = Instance.new("TextLabel", bb)
    tl.BackgroundTransparency = 1; tl.Size = UDim2.fromScale(1, 1)
    tl.Font = Enum.Font.GothamBold; tl.TextSize = 12; tl.TextColor3 = Color3.fromRGB(220, 130, 255)
    tl.TextStrokeTransparency = 0.4
    EspEntries[uid] = { anchor = anchor, label = tl }
    return EspEntries[uid]
end
local function releaseEsp(uid)
    local e = EspEntries[uid]
    if e then pcall(function() e.anchor:Destroy() end); EspEntries[uid] = nil end
end
task.spawn(function()
    while running do
        task.wait(1)
        if H.isOn("EspWorldEggs") then
            H.buildEggList(false)
            local seen = {}
            for _, egg in ipairs(H.EggList) do
                seen[egg.uid] = true
                local e = getEspEntry(egg.uid)
                e.anchor.CFrame = CFrame.new(egg.pos)
                e.label.Text = egg.label .. " [" .. tostring(egg.rarity or "?") .. "]"
            end
            for uid in pairs(EspEntries) do
                if not seen[uid] then releaseEsp(uid) end
            end
        else
            for uid in pairs(EspEntries) do releaseEsp(uid) end
        end
    end
end)

-- ============================================================
-- SCHEDULER
-- ============================================================
local SchedAt = {}
local LastNoClipOn = false
local function due(name, interval)
    local now = os.clock()
    if now < (SchedAt[name] or 0) then return false end
    SchedAt[name] = now + interval
    return true
end
local function applyNoClip(inst) if inst:IsA("BasePart") then inst.CanCollide = false end end
local noClipConn = nil
local function setNoClip(on)
    if noClipConn then pcall(function() noClipConn:Disconnect() end); noClipConn = nil end
    if not on then return end
    local ch = LocalPlayer.Character
    if not ch then return end
    for _, i in ipairs(ch:GetDescendants()) do applyNoClip(i) end
    noClipConn = ch.DescendantAdded:Connect(applyNoClip)
end

local StartTime = os.clock()
local function refreshDash()
    if not running then return end
    pcall(function()
        if refs.carryingRow then
            refs.carryingRow:SetValue(H.carryingUid and L("st_yes") or L("st_no"))
        end
        if refs.runtimeRow then refs.runtimeRow:SetValue(H.formatElapsed(os.clock() - StartTime)) end
        if refs.stolenRow then refs.stolenRow:SetValue(tostring(H.SessionStolenEggs)) end
        if refs.bypassRow then
            refs.bypassRow:SetValue(H.HumReady and L("st_ready_bypass") or L("st_not_ready"))
        end
        local save = H.getSave()
        if save then
            if refs.moneyRow then refs.moneyRow:SetValue(H.formatNumber(save.Money)) end
            if refs.rebirthRow then refs.rebirthRow:SetValue(tostring(save.Rebirth or 0)) end
        end
    end)
end
refreshDash()

H.track(RunService.Heartbeat:Connect(function()
    if not running then return end
    if due("dash", 2) then
        refreshDash()
        local noclipOn = H.isOn("NoClip")
        if noclipOn ~= LastNoClipOn then LastNoClipOn = noclipOn; setNoClip(noclipOn) end
        if H.isOn("WalkSpeedEnabled") then
            local h = H.getHumanoid()
            if h and h.Health > 0 then h.WalkSpeed = tonumber(H.optionValue("WalkSpeed", 32)) or 32 end
        end
        if H.isOn("JumpPowerEnabled") then
            local h = H.getHumanoid()
            if h and h.Health > 0 then h.UseJumpPower = true; h.JumpPower = tonumber(H.optionValue("JumpPower", 50)) or 50 end
        end
    end
end))

-- Fly
H.track(RunService.RenderStepped:Connect(function(dt)
    if not running or not H.isOn("Fly") then return end
    local root = H.getRoot(); local hum = H.getHumanoid()
    local cam = Workspace.CurrentCamera
    if not root or not hum or not cam or hum.Health <= 0 then return end
    hum.PlatformStand = true
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
    root.AssemblyLinearVelocity = Vector3.zero
    if dir.Magnitude > 0 then
        root.CFrame = root.CFrame + dir.Unit * (tonumber(H.optionValue("FlySpeed", 60)) or 60) * dt
    end
end))

-- Infinite jump
H.track(UserInputService.JumpRequest:Connect(function()
    if not running or not H.isOn("InfJump") then return end
    local h = H.getHumanoid()
    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

-- FPS cap
H.track(RunService.Heartbeat:Connect(function()
    if not running then return end
    if due("fpscap", 5) and H.isOn("FpsCapActive") then
        -- (optional) nothing – keep placeholder
    end
end))

-- End key
H.track(UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.End then H.unload() end
end))

-- ============================================================
-- UNLOAD
-- ============================================================
function H.unload()
    if not running then return end
    running = false
    H.AutoSteal = false
    H.travelToken = H.travelToken + 1
    pcall(H.clearVisualPets)
    if EspFolder then pcall(function() EspFolder:Destroy() end) end
    if VisualPetsFolder then pcall(function() VisualPetsFolder:Destroy() end) end
    for _, c in ipairs(conns) do
        pcall(function() if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end)
    end
    H.clearTable(conns)
    for _, c in ipairs(UI.__connections) do
        pcall(function() if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end)
    end
    pcall(function() screenGui:Destroy() end)
    pcall(function() toggleGui:Destroy() end)
    genv.__ZEN_HUB_RUNNING = nil
    genv.__ZEN_HUB_SHUTDOWN = nil
end
genv.__ZEN_HUB_SHUTDOWN = H.unload

-- ============================================================
-- FILL AREA LIST AFTER GAME DATA LOADS
-- ============================================================
task.spawn(function()
    if not H.isAlive() then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(0.7)
    end
    H.buildEggList(true)
    if #H.AreaOrder > 0 and refs.areaDropdown then
        pcall(function()
            refs.areaDropdown:Refresh(H.getAreaLabels())
        end)
        pcall(function()
            refs.areaDropdown:SetValues(H.getAreaLabels())
        end)
    end
end)

H.notify("zen hubXsteal", L("n_ready"), "Success", 5)
if refs.statusRow then refs.statusRow:SetStatus("Success") end