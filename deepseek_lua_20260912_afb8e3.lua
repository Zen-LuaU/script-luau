--[[
    zen hubXsteal
    Fixed: Farm Egg working, added Clone Humanoid Bypass, smaller panel
    Language: EN / VI
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
-- LANGUAGE SYSTEM
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
        sec_danger="Danger Zone",sec_void="Void Reset",sec_hop_gui="Server Hop GUI",sec_bypass="Anti-Cheat Bypass",
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
        btn_voidreset="Void Reset (Auto Unstuck)",
        tg_auto_steal_sel="Auto Steal Selected",tg_auto_steal_all="Auto Steal All",tg_steal_big="Steal Big Eggs",
        tg_auto_return="Auto Return to Base",tg_auto_drop="Auto Drop Held Egg",
        tg_auto_place_sel="Auto Place Selected",tg_auto_place_all="Auto Place All",tg_auto_hatch="Auto Hatch Ready",
        tg_auto_sell_eggs="Auto Sell Eggs",tg_auto_server_hop="Auto Server Hop",
        tg_auto_equip_best="Auto Equip Best Pets",tg_hide_own_pets="Hide Own Pet Renders",
        tg_auto_fuse="Auto Fuse Pets",tg_fuse_keep_mut="Never Fuse Mutated",tg_fuse_keep_equip="Never Fuse Equipped",
        tg_fuse_reveal="Auto Complete Reveal",tg_auto_sell_pets="Auto Sell Pets",
        tg_sell_keep_mut="Never Sell Mutated",tg_sell_keep_equip="Never Sell Equipped",
        tg_auto_upgrades="Auto Buy Upgrades",tg_auto_claim_index="Auto Claim Index",
        tg_auto_claim_group="Auto Claim Group Reward",tg_auto_claim_offline="Claim Offline Earnings",
        tg_auto_buy_trail="Auto Buy Trail",tg_auto_equip_best_trail="Auto Equip Best Trail",
        tg_auto_equip_best_gear="Auto Equip Best Gear",tg_auto_treadmill="Auto Treadmill Training",
        tg_esp_world="World Egg ESP",tg_esp_carried="Carried and Dropped Egg ESP",
        tg_esp_guards="Guard ESP",tg_esp_pets="Pet ESP",tg_esp_players="Player ESP",
        tg_esp_machines="Machine ESP",tg_esp_plots="Plot ESP",
        tg_walkspeed="Walk Speed Override",tg_jumppower="Jump Power Override",
        tg_infjump="Infinite Jump",tg_noclip="NoClip",tg_fly="Fly",
        tg_anti_ragdoll="Anti-Ragdoll / Anti-Knock",tg_anti_trap="Super Anti-Trap",
        tg_instant_hold="Instant Interact (No Hold)",tg_free_auto_steal="Auto Steal Free (Proximity)",
        tg_speed_changer="Enable WalkSpeed Lock",tg_anti_afk="Anti-AFK",
        tg_no_pause="No Gameplay Paused",tg_auto_reconnect="Auto Reconnect",
        tg_fps_boost="FPS Boost",tg_disable_render="Disable 3D Rendering",tg_webhook="Enable Webhooks",
        tg_anti_knock="Anti-Knock (Remove Constraints)",
        tg_bypass_auto="Auto-Apply Bypass on Respawn",
        dd_areas="Areas",dd_rarities="Rarities",dd_mutations="Mutations",dd_target_priority="Target Priority",
        dd_lifecycle_rarities="Lifecycle Rarities",dd_lifecycle_mutations="Lifecycle Mutations",
        dd_sell_egg_rarities="Sell Rarities",dd_hop_when="Hop When",
        dd_fuse_rarities="Fuse Rarities",dd_fuse_mutations="Fuse Mutations",dd_fuse_target="Pick Group By",
        dd_sell_rarities="Sell Rarities",dd_sell_mutations="Sell Mutations",
        dd_upgrade_types="Upgrade Types",dd_trails="Trails",dd_waypoint="Waypoint",dd_anti_ragdoll_mode="Camera Mode",
        sl_big_egg_scale="Minimum Big Egg Size",sl_sell_interval="Sell Interval",sl_wait_hop="Wait Before Hop",
        sl_fuse_max_scale="Maximum Scale to Fuse",sl_fuse_keep_per="Keep Per Pet Type",sl_fuse_interval="Fuse Interval",
        sl_sell_max_scale="Maximum Scale to Sell",sl_sell_int="Sell Interval",sl_esp_dist="Render Distance",
        sl_walkspeed="Walk Speed",sl_jumppower="Jump Power",sl_flyspeed="Fly Speed",sl_speed_val="WalkSpeed Value",
        sl_vpet_radius="Orbit Radius",sl_vpet_speed="Orbit Speed",sl_fps_cap="FPS Cap",sl_webhook_int="Summary Interval",
        in_vpet_name="Pet Name",in_webhook_url="Webhook URL",in_webhook_ping="Webhook Ping User ID",in_hop_threshold="Hop if Players >=",
        n_ready="Ready - press Z button",n_discord_copied="Discord link copied",
        n_base_unavail="Base unavailable",n_waypoint_unavail="Waypoint unavailable",n_waypoint_fail="Waypoint failed",
        n_fixlag_applied="Fix Lag applied",n_enter_pet="Enter a pet name",n_join_copied="Join script copied",
        n_summary_sent="Summary sent",n_summary_fail="Summary failed",n_lang_changed="Language changed to English",
        n_void="Teleported to void",n_hop_gui_open="Server Hop GUI opened",
        n_bypass_ok="Anti-Cheat Bypass activated!",n_bypass_fail="No character found!",
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
        sec_danger="Vùng nguy hiểm",sec_void="Reset Void",sec_hop_gui="Giao diện Đổi Server",sec_bypass="Bypass Anti-Cheat",
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
        btn_voidreset="Void Reset (Tự động thoát kẹt)",
        tg_auto_steal_sel="Tự trộm theo bộ lọc",tg_auto_steal_all="Tự trộm tất cả",tg_steal_big="Trộm trứng to",
        tg_auto_return="Tự về căn cứ",tg_auto_drop="Tự thả trứng đang mang",
        tg_auto_place_sel="Tự đặt theo bộ lọc",tg_auto_place_all="Tự đặt tất cả",tg_auto_hatch="Tự ấp trứng sẵn sàng",
        tg_auto_sell_eggs="Tự bán trứng",tg_auto_server_hop="Tự đổi server",
        tg_auto_equip_best="Tự trang bị thú mạnh nhất",tg_hide_own_pets="Ẩn thú của mình",
        tg_auto_fuse="Tự Fusion thú",tg_fuse_keep_mut="Không Fusion thú đột biến",tg_fuse_keep_equip="Không Fusion thú đang dùng",
        tg_fuse_reveal="Tự hoàn tất hiển thị",tg_auto_sell_pets="Tự bán thú",
        tg_sell_keep_mut="Không bán thú đột biến",tg_sell_keep_equip="Không bán thú đang dùng",
        tg_auto_upgrades="Tự mua nâng cấp",tg_auto_claim_index="Tự nhận Index",
        tg_auto_claim_group="Tự nhận thưởng Group",tg_auto_claim_offline="Nhận thu nhập offline",
        tg_auto_buy_trail="Tự mua Trail",tg_auto_equip_best_trail="Tự trang bị Trail tốt nhất",
        tg_auto_equip_best_gear="Tự trang bị Gear tốt nhất",tg_auto_treadmill="Tự luyện Treadmill",
        tg_esp_world="ESP trứng trên map",tg_esp_carried="ESP trứng đang mang / đã thả",
        tg_esp_guards="ESP bảo vệ",tg_esp_pets="ESP thú",tg_esp_players="ESP người chơi",
        tg_esp_machines="ESP máy móc",tg_esp_plots="ESP khu đất",
        tg_walkspeed="Ghi đè tốc độ đi",tg_jumppower="Ghi đè lực nhảy",
        tg_infjump="Nhảy vô hạn",tg_noclip="Xuyên vật thể",tg_fly="Bay",
        tg_anti_ragdoll="Chống ngã / Chống văng",tg_anti_trap="Chống bẫy",
        tg_instant_hold="Tương tác tức thì (Không giữ)",tg_free_auto_steal="Tự trộm Free (Proximity)",
        tg_speed_changer="Khóa tốc độ đi",tg_anti_afk="Chống AFK",
        tg_no_pause="Không bị tạm dừng",tg_auto_reconnect="Tự kết nối lại",
        tg_fps_boost="Tăng FPS",tg_disable_render="Tắt render 3D",tg_webhook="Bật Webhook",
        tg_anti_knock="Chống văng (Xóa ràng buộc vật lý)",
        tg_bypass_auto="Tự động áp dụng Bypass khi hồi sinh",
        dd_areas="Khu vực",dd_rarities="Độ hiếm",dd_mutations="Đột biến",dd_target_priority="Ưu tiên mục tiêu",
        dd_lifecycle_rarities="Độ hiếm vòng đời",dd_lifecycle_mutations="Đột biến vòng đời",
        dd_sell_egg_rarities="Độ hiếm bán",dd_hop_when="Đổi khi",
        dd_fuse_rarities="Độ hiếm Fusion",dd_fuse_mutations="Đột biến Fusion",dd_fuse_target="Chọn nhóm theo",
        dd_sell_rarities="Độ hiếm bán",dd_sell_mutations="Đột biến bán",
        dd_upgrade_types="Loại nâng cấp",dd_trails="Trail",dd_waypoint="Điểm đến",dd_anti_ragdoll_mode="Chế độ Camera",
        sl_big_egg_scale="Kích thước trứng to tối thiểu",sl_sell_interval="Chu kỳ bán",sl_wait_hop="Chờ trước khi đổi",
        sl_fuse_max_scale="Kích thước tối đa Fusion",sl_fuse_keep_per="Giữ mỗi loại thú",sl_fuse_interval="Chu kỳ Fusion",
        sl_sell_max_scale="Kích thước tối đa bán",sl_sell_int="Chu kỳ bán",sl_esp_dist="Khoảng cách render",
        sl_walkspeed="Tốc độ đi",sl_jumppower="Lực nhảy",sl_flyspeed="Tốc độ bay",sl_speed_val="Giá trị tốc độ",
        sl_vpet_radius="Bán kính quay",sl_vpet_speed="Tốc độ quay",sl_fps_cap="Giới hạn FPS",sl_webhook_int="Chu kỳ tổng kết",
        in_vpet_name="Tên thú",in_webhook_url="URL Webhook",in_webhook_ping="ID người dùng cần ping",in_hop_threshold="Đổi nếu Player >=",
        n_ready="Sẵn sàng - nhấn nút Z",n_discord_copied="Đã sao chép link Discord",
        n_base_unavail="Không tìm thấy căn cứ",n_waypoint_unavail="Không tìm thấy điểm đến",n_waypoint_fail="Không thể tới điểm đến",
        n_fixlag_applied="Đã áp dụng giảm lag",n_enter_pet="Nhập tên thú",n_join_copied="Đã sao chép script vào server",
        n_summary_sent="Đã gửi tổng kết",n_summary_fail="Gửi thất bại",n_lang_changed="Đã đổi ngôn ngữ sang Tiếng Việt",
        n_void="Đã thả xuống void",n_hop_gui_open="Đã mở giao diện Đổi Server",
        n_bypass_ok="Đã kích hoạt Bypass Anti-Cheat!",n_bypass_fail="Không tìm thấy nhân vật!",
        dv_target_filter="Bộ lọc mục tiêu",dv_carry_behavior="Hành vi mang trứng",dv_egg_selling="Bán trứng",
        dv_danger="Vùng nguy hiểm",all="Tất cả",priority="Ưu tiên",about_dev="Nhà phát triển",
    },
}
local function L(key)
    local pack = T[Lang.Current] or T.vi
    return pack[key] or (T.vi[key] or key)
end

-- ============================================================
-- ANTI-CHEAT
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
    local cur = tbl
    for i = 1, select("#", ...) do
        if typeof(cur) ~= "table" then return nil end
        cur = cur[select(i, ...)]
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
local RenderingDisabled = false
local FpsBoostSnapshot = nil
local SessionStartedAt = os.clock()
local LastWebhookSummaryAt = os.clock()
local KnownWorldEggUids, KnownInventoryUids = {}, {}
local WebhookTrackerInitialized = false
local LastRebirthSnapshot = nil
local LastStealCountSnapshot = 0
local SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0, 0, 0
local EspEntries, EspSeenThisPass = {}, {}
local BypassApplied = false       -- trạng thái Bypass Anti-Cheat
local IsBypassing = false          -- chống xung đột khi đang clone

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
function H.isAlive()
    local hum = H.getHumanoid()
    return hum ~= nil and hum.Health > 0
end

-- ============================================================
-- SETUP CHARACTER (SAFE)
-- ============================================================
local PeteSettings = {
    AntiRagdoll = true,
    AntiRagdollMode = "Không Chuyển Camera",
    AntiKnock = true,
}

local function SetupCharacter(char)
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
        pcall(function()
            hrp.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 100, 100)
        end)
    end
end

if LocalPlayer.Character then SetupCharacter(LocalPlayer.Character) end

-- ============================================================
-- CLONE HUMANOID BYPASS (từ file zenhubX — bọc pcall an toàn)
-- ============================================================
function H.applyBypassAndSpeed()
    if IsBypassing then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local oldHum = char:FindFirstChildOfClass("Humanoid")
    if not oldHum then return false end

    IsBypassing = true
    local targetSpeed = oldHum.WalkSpeed
    local cam = Workspace.CurrentCamera
    local camCFrame = cam and cam.CFrame or nil
    local camSubject = cam and cam.CameraSubject or oldHum

    local ok, clone = pcall(function() oldHum.Archivable = true; return oldHum:Clone() end)
    if not ok or not clone then
        IsBypassing = false
        return false
    end

    pcall(function()
        clone.Parent = char
        oldHum:Destroy()
    end)

    task.wait(0.15)

    local newHum = char:FindFirstChildOfClass("Humanoid")
    if newHum then
        pcall(function()
            newHum.WalkSpeed = targetSpeed
            newHum.PlatformStand = false
            newHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            newHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        end)
        if cam and camCFrame then
            pcall(function()
                cam.CameraSubject = newHum
                cam.CFrame = camCFrame
            end)
        end
    end

    task.wait(0.15)
    IsBypassing = false
    BypassApplied = true
    return true
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
    local humanoid = H.getHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end
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
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end

    pcall(function()
        for _, scriptItem in ipairs(char:GetDescendants()) do
            if scriptItem:IsA("LocalScript") and scriptItem.Name == "PushBack" then
                scriptItem.Disabled = true
                scriptItem:Destroy()
            end
        end
    end)

    humanoid.AutoRotate = true
    humanoid.PlatformStand = false
    humanoid.Sit = false
    humanoid.WalkSpeed = H.stealSpeed()

    local camera = Workspace.CurrentCamera
    if camera and camera.CameraSubject ~= humanoid then
        pcall(function() camera.CameraSubject = humanoid end)
    end
    return humanoid
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
    if humanoid.Health <= 0 then return false end
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
        if humanoid.Health <= 0 then return false end
        local pointY = H.groundedY(point.X, point.Z, root.Position.Y)
        local waypoint = Vector3.new(point.X, pointY, point.Z)
        while running do
            if keepGoing and not keepGoing() then return false end
            root = H.getRoot(); if not root then return false end
            if humanoid.Health <= 0 then return false end
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
    if humanoid.Health <= 0 then return false end
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
    local root = H.getRoot()
    local humanoid = H.getHumanoid()
    if not root or not humanoid or humanoid.Health <= 0 then return false end

    H.stripCheatMovers(root); H.stopSoftMove(root)

    local targetY = H.groundedY(position.X, position.Z, root.Position.Y)
    local dest = Vector3.new(position.X, targetY, position.Z)
    if (root.Position - dest).Magnitude <= BASE_RETURN_ARRIVE then return true end

    local arrived, deadline = false, os.clock() + 15
    while running and os.clock() < deadline do
        if keepGoing and not keepGoing() then break end
        root = H.getRoot()
        humanoid = H.getHumanoid()
        if not root or not humanoid or humanoid.Health <= 0 then break end

        local offset = dest - root.Position
        local dist = offset.Magnitude
        if dist <= BASE_RETURN_ARRIVE then arrived = true; break end

        local dir = offset.Unit
        local dt = math.clamp(RunService.Heartbeat:Wait(), 0, 1 / 30)
        local step = math.min(speed * dt, dist)
        local nextPos = root.Position + dir * step
        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0.001 then
            root.CFrame = CFrame.lookAt(nextPos, nextPos + flatDir.Unit)
        else
            root.CFrame = CFrame.new(nextPos)
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    root = H.getRoot()
    humanoid = H.getHumanoid()
    if root and humanoid and humanoid.Health > 0 then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if arrived then H.placeRoot(root, CFrame.new(dest.X, targetY, dest.Z)) end
    end
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
        local humanoid = H.getHumanoid()
        if not root or not humanoid or humanoid.Health <= 0 then return false end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = anchorCF
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
function H.canAutoSteal() return H.stealingEnabled() and not IsCarryingEgg and not H.eggInventoryFull() and H.isAlive() end
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
    if not H.isAlive() then return false end
    H.swapStealHumanoid()
    if not H.prepareStealHumanoid() then return false end
    local targetPosition = H.getSlotEggPosition(slotEgg)
    local root = H.getRoot()
    if not root or not targetPosition then return false end
    if not H.stealAlong(H.buildStealPath(root.Position, targetPosition), H.stealingEnabled) then return false end
    if not H.isAlive() then return false end
    root = H.getRoot()
    if root then
        local targetY = H.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
        H.placeRoot(root, CFrame.new(targetPosition.X, targetY, targetPosition.Z))
    end
    if not H.stealingEnabled() then return false end
    H.waitFor(StealConfig.GrabDelay, 0.04, function()
        root = H.getRoot()
        if root and H.isAlive() then
            local targetY = H.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
            H.placeRoot(root, CFrame.new(targetPosition.X, targetY, targetPosition.Z))
        end
        if not H.stealingEnabled() then return true end
        if not IsCarryingEgg then H.tryCarryEgg(slotEgg) end
        return IsCarryingEgg == true
    end)
    local carryDeadline = os.clock() + 2.5
    while running and H.stealingEnabled() and H.isAlive() and not IsCarryingEgg and os.clock() < carryDeadline do
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
    if running and H.stealingEnabled() and H.isAlive() then
        if not IsCarryingEgg then H.tryCarryEgg(slotEgg); task.wait(0.15) end
        local reDeadline = os.clock() + 1.5
        while running and H.stealingEnabled() and H.isAlive() and not IsCarryingEgg and os.clock() < reDeadline do
            H.tryCarryEgg(slotEgg); task.wait(0.05)
        end
    end
    H.returnToBaseBypass(H.stealingEnabled)
    local confirmDeadline = os.clock() + 3
    while running and H.stealingEnabled() and IsCarryingEgg and os.clock() < confirmDeadline do task.wait(0.1) end
    return true
end
function H.runAutoSteal()
    if IsCarryingEgg or H.eggInventoryFull() or not H.isAlive() then return false end
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
    if not IsCarryingEgg or not H.isAlive() then return false end
    local keepReturning = function() return H.isOn("AutoReturn") and IsCarryingEgg and H.isAlive() end
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

-- PLACE / HATCH / SELL / FUSE / UPGRADE
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
    return H.placingEnabled() and not IsCarryingEgg and not H.isPlotFull() and #H.getUnplacedEggUids() > 0 and H.isAlive()
end
function H.runAutoPlaceEggs(forceRun)
    if IsCarryingEgg or not EggApi.RequestPlaceEgg or not H.isAlive() then return end
    local function canContinue() return (forceRun == true or H.placingEnabled()) and not IsCarryingEgg and H.isAlive() end
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
function H.canAutoHatch() return H.isOn("AutoOpenReadyEggs") and not IsCarryingEgg and H.isAlive() end
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
    if not character or not humanoid or humanoid.Health <= 0 then return false end
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
    local save = H.getSave(); if not save or not H.isAlive() then return end
    local function canContinue() return (forceRun == true or H.isOn("AutoFusePets")) and H.isAlive() end
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
    if not character or not backpack or not humanoid or humanoid.Health <= 0 then return end
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
    local save = H.getSave(); if not save or not H.isAlive() then return false end
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
    pcall(function() isInGroup = Constants and Constants.GROUP_ID and LocalPlayer:IsInGroupAsync(Constants.GROUP_ID) == true end)
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
    if humanoid and humanoid.Health > 0 then humanoid.Jump = true; humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end
function H.stopTreadmillTraining()
    TreadmillTrainingActive = false
    pcall(function() H.netInvoke(Remotes.Treadmills.REQUEST_UNEQUIP) end)
    if H.isDoubleSpeedVisible() then
        H.dismountTreadmill(); task.wait(0.1)
        if H.isDoubleSpeedVisible() then H.dismountTreadmill() end
    end
end
function H.canAutoTreadmill() return H.isOn("AutoTreadmill") and not IsCarryingEgg and H.isAlive() end
function H.runAutoTreadmillTraining()
    local treadmillPosition = H.getTreadmillStand()
    if not treadmillPosition then return end
    local root = H.getRoot(); if not root then return end
    if not H.isAlive() then return end
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

-- VOID RESET
local function TeleportToVoid()
    local root = H.getRoot()
    local humanoid = H.getHumanoid()
    if not root or not humanoid or humanoid.Health <= 0 then return end
    pcall(function()
        root.CFrame = CFrame.new(root.Position.X, -350, root.Position.Z)
        root.AssemblyLinearVelocity = Vector3.new(0, -280, 0)
    end)
end

-- SERVER HOP GUI
local function OpenServerHopGUI()
    if LocalPlayer.PlayerGui:FindFirstChild("ZenHubX_ServerHopGUI") then
        LocalPlayer.PlayerGui:FindFirstChild("ZenHubX_ServerHopGUI"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZenHubX_ServerHopGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -145, 0.5, -110)
    MainFrame.Size = UDim2.new(0, 290, 0, 220)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(170, 80, 255); Stroke.Thickness = 2
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 36)
    Title.BackgroundColor3 = Color3.fromRGB(45, 30, 70)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.Text = "zen hubXsteal - HOP SERVER"
    Title.TextColor3 = Color3.fromRGB(220, 130, 255); Title.TextSize = 13
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -28, 0, 6)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70); CloseBtn.TextSize = 13
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    local NowLabel = Instance.new("TextLabel", MainFrame)
    NowLabel.Position = UDim2.new(0, 10, 0, 44); NowLabel.Size = UDim2.new(1, -20, 0, 22)
    NowLabel.BackgroundTransparency = 1; NowLabel.Font = Enum.Font.GothamBold
    NowLabel.TextXAlignment = Enum.TextXAlignment.Left
    NowLabel.TextColor3 = Color3.fromRGB(150, 220, 150); NowLabel.TextSize = 12
    local StatusLabel = Instance.new("TextLabel", MainFrame)
    StatusLabel.Position = UDim2.new(0, 10, 0, 70); StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextColor3 = Color3.fromRGB(190, 170, 220); StatusLabel.TextSize = 11
    StatusLabel.TextWrapped = true
    local MaxLabel = Instance.new("TextLabel", MainFrame)
    MaxLabel.Position = UDim2.new(0, 10, 0, 105); MaxLabel.Size = UDim2.new(1, -20, 0, 18)
    MaxLabel.BackgroundTransparency = 1; MaxLabel.Font = Enum.Font.Gotham
    MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
    MaxLabel.TextColor3 = Color3.fromRGB(180, 160, 210); MaxLabel.TextSize = 11
    MaxLabel.Text = L("in_hop_threshold")
    local MaxBox = Instance.new("TextBox", MainFrame)
    MaxBox.Position = UDim2.new(0, 10, 0, 126); MaxBox.Size = UDim2.new(1, -20, 0, 28)
    MaxBox.BackgroundColor3 = Color3.fromRGB(45, 30, 70); MaxBox.BorderSizePixel = 0
    MaxBox.Font = Enum.Font.GothamBold; MaxBox.Text = "5"
    MaxBox.TextColor3 = Color3.fromRGB(245, 235, 255); MaxBox.TextSize = 14
    MaxBox.ClearTextOnFocus = false
    Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 6)
    local HopBtn = Instance.new("TextButton", MainFrame)
    HopBtn.Position = UDim2.new(0, 10, 0, 162); HopBtn.Size = UDim2.new(0, 125, 0, 45)
    HopBtn.BackgroundColor3 = Color3.fromRGB(170, 60, 255); HopBtn.BorderSizePixel = 0
    HopBtn.Font = Enum.Font.GothamBold; HopBtn.Text = "Hop 1 Lần"
    HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255); HopBtn.TextSize = 13
    Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 6)
    local AutoBtn = Instance.new("TextButton", MainFrame)
    AutoBtn.Position = UDim2.new(0, 145, 0, 162); AutoBtn.Size = UDim2.new(0, 135, 0, 45)
    AutoBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100); AutoBtn.BorderSizePixel = 0
    AutoBtn.Font = Enum.Font.GothamBold; AutoBtn.Text = "Auto Hop: OFF"
    AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255); AutoBtn.TextSize = 13
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
        local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local raw = nil
        if req then
            local success, res = pcall(function() return req({ Url = url, Method = "GET" }) end)
            if success and res and res.Body then raw = res.Body end
        else
            pcall(function() raw = game:HttpGet(url) end)
        end
        if not raw or raw == "" then return nil end
        local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
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
            StatusLabel.TextColor3 = Color3.fromRGB(150, 220, 150)
            return false
        end
        StatusLabel.Text = "Server đang có " .. currentCount .. " player. Đang tìm server nhỏ hơn..."
        StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 255)
        task.wait(0.5)
        local serverId = getRandomServer()
        if not serverId then
            StatusLabel.Text = "Không lấy được danh sách server."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 120)
            return false
        end
        StatusLabel.Text = "Đang kết nối sang Server mới..."
        StatusLabel.TextColor3 = Color3.fromRGB(170, 140, 255)
        task.wait(0.5)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer) end)
        return true
    end
    HopBtn.MouseButton1Click:Connect(function()
        HopBtn.Active = false; hopOnce(); task.wait(2); HopBtn.Active = true
    end)
    AutoBtn.MouseButton1Click:Connect(function()
        autoEnabled = not autoEnabled
        if autoEnabled then
            AutoBtn.Text = "Auto Hop: ON"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 90)
            autoThread = task.spawn(function()
                while autoEnabled and ScreenGui.Parent do
                    local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 5))
                    local count = #Players:GetPlayers()
                    if count < threshold then
                        StatusLabel.Text = "✓ Server phù hợp (" .. count .. " player). Giữ nguyên."
                        StatusLabel.TextColor3 = Color3.fromRGB(150, 220, 150)
                        task.wait(3)
                    else
                        hopOnce(); task.wait(5)
                    end
                end
            end)
        else
            AutoBtn.Text = "Auto Hop: OFF"
            AutoBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
            if autoThread then task.cancel(autoThread); autoThread = nil end
            StatusLabel.Text = "Đã dừng Auto Hop."
            StatusLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
        end
    end)
    StatusLabel.Text = "Nhập số người tối đa & ấn Hop."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 160, 210)
end

-- ESP
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
            pcall(function() if PlotApi.GetSlotOwner then ownerUserId = PlotApi.GetSlotOwner(tonumber(plot.Name)) end end)
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

-- SERVER HOP
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

-- WEBHOOK
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
    return pcall(requestFn, { Url = webhookUrl, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = encodedBody })
end
function H.sendWebhookEmbed(embed, includePing)
    if not H.isOn("WebhookEnabled") then return false end
    local payload = { username = "zen hubXsteal", embeds = { embed } }
    if includePing then payload.content = H.webhookPing() end
    return H.httpPost(payload)
end
function H.embedField(name, value, inline) return { name = name, value = value, inline = inline ~= false } end
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
        author = { name = "Steal an Egg | zen hubXsteal" },
        title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            LocalPlayer.Name, DisplayJobId, H.formatElapsed(os.clock() - SessionStartedAt)),
        color = 10027263, fields = fields,
        footer = { text = "zen hubXsteal | " .. DISCORD_LINK },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end
H.sendSummary = function()
    local sent = H.sendWebhookEmbed(H.buildSummaryEmbed(), true)
    if sent then SummaryStolenEggs, SummaryPetsObtained, SummaryRebirths = 0, 0, 0 end
    return sent
end
function H.runWebhookSummary()
    local interval = (tonumber(H.optionValue("WebhookInterval", 15)) or 15) * 60
    if os.clock() - LastWebhookSummaryAt < interval then return false end
    LastWebhookSummaryAt = os.clock()
    return H.sendSummary()
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
        if KnownInventoryUids[uid] == nil then KnownInventoryUids[uid] = true; SummaryPetsObtained = SummaryPetsObtained + 1 end
    end
    local rebirths = tonumber(save.Rebirth) or 0
    if LastRebirthSnapshot and rebirths > LastRebirthSnapshot then SummaryRebirths = SummaryRebirths + rebirths - LastRebirthSnapshot end
    LastRebirthSnapshot = rebirths
end

-- PERFORMANCE
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
function H.enableFpsBoost()
    if FpsBoostSnapshot then return end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local qualityLevel = nil
    pcall(function() qualityLevel = settings().Rendering.QualityLevel end)
    FpsBoostSnapshot = { QualityLevel = qualityLevel, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, Terrain = terrain, Effects = {} }
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1000000
    if terrain then terrain.WaterWaveSize = 0; terrain.WaterReflectance = 0 end
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if FpsEffectClasses[descendant.ClassName] and descendant.Enabled then
            table.insert(FpsBoostSnapshot.Effects, descendant)
            pcall(function() descendant.Enabled = false end)
        end
    end
end
function H.disableFpsBoost()
    local snapshot = FpsBoostSnapshot; if not snapshot then return end
    FpsBoostSnapshot = nil
    if snapshot.QualityLevel then pcall(function() settings().Rendering.QualityLevel = snapshot.QualityLevel end) end
    Lighting.GlobalShadows = snapshot.GlobalShadows; Lighting.FogEnd = snapshot.FogEnd
    if snapshot.Terrain and snapshot.Terrain.Parent then
        snapshot.Terrain.WaterWaveSize = snapshot.WaterWaveSize
        snapshot.Terrain.WaterReflectance = snapshot.WaterReflectance
    end
    for _, effect in ipairs(snapshot.Effects) do pcall(function() effect.Enabled = true end) end
end
function H.applyFpsCap(value)
    local setCap = setfpscap or (syn and syn.set_fps_cap)
    if typeof(setCap) ~= "function" then return false end
    return pcall(setCap, math.clamp(tonumber(value) or 60, 15, 360))
end

-- ============================================================
-- EXTRA FEATURES
-- ============================================================

-- Anti-Ragdoll
RunService.Stepped:Connect(function()
    if not running or not PeteSettings.AntiRagdoll or IsBypassing then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if humanoid and humanoid.Health > 0 and root then
        humanoid.PlatformStand = false
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
        or state == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Motor6D") and not v.Enabled then v.Enabled = true end
        end
        local vel = root.AssemblyLinearVelocity
        if vel.Y > 30 then root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
    end
end)

-- Anti-Knock
RunService.RenderStepped:Connect(function()
    if not running or not PeteSettings.AntiKnock or IsBypassing then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("RopeConstraint") or obj:IsA("BodyVelocity") or obj:IsA("BodyThrust") then
            obj:Destroy()
        end
    end
    local cam = Workspace.CurrentCamera
    if cam and PeteSettings.AntiRagdollMode == "Chuyển Camera Sang Bản Thân" then
        if cam.CameraSubject ~= humanoid then cam.CameraSubject = humanoid end
    end
end)

-- Speed Changer
local SpeedConfig = { Enabled = false, Value = 300 }
RunService.Stepped:Connect(function()
    if not running or not SpeedConfig.Enabled or IsBypassing then return end
    local hum = H.getHumanoid()
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
local function DeleteAndDisableTrap(obj)
    if not IsTrapImmune then return end
    if IsTrapObject(obj) then
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = false; part.CanCollide = false; part.Transparency = 1
            elseif part:IsA("TouchTransmitter") or part:IsA("Script") or part:IsA("LocalScript") then
                part:Destroy()
            end
        end
        task.defer(function() pcall(function() obj:Destroy() end) end)
    end
end
function H.applyTrapImmunity()
    local character = LocalPlayer.Character
    if not character then return end
    if not character:FindFirstChild("TrapImmunityField") then
        local forceField = Instance.new("ForceField")
        forceField.Name = "TrapImmunityField"; forceField.Visible = false; forceField.Parent = character
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do DeleteAndDisableTrap(obj) end
end
Workspace.DescendantAdded:Connect(function(descendant)
    if IsTrapImmune then task.wait(); DeleteAndDisableTrap(descendant) end
end)
function H.setTrapImmune(state) IsTrapImmune = state; if state then H.applyTrapImmunity() end end

-- Fix Lag
local FixLagEnabled = false
local function IsFoliageOrTree(obj)
    local name = string.lower(obj.Name)
    return string.find(name, "tree") or string.find(name, "leaf") or string.find(name, "leaves")
        or string.find(name, "grass") or string.find(name, "bush") or string.find(name, "foliage")
        or string.find(name, "plant") or string.find(name, "wood")
end
local function ApplyClayAndClean(obj)
    if not FixLagEnabled then return end
    if IsFoliageOrTree(obj) then obj:Destroy(); return end
    if obj:IsA("SurfaceAppearance") or obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy(); return end
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Highlight") then obj:Destroy(); return end
    if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Part") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
        if obj:IsA("MeshPart") then obj.TextureID = "" end
    end
end
function H.enableFixLag()
    FixLagEnabled = true
    Lighting.FogEnd = 1e6; Lighting.FogStart = 1e6; Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do ApplyClayAndClean(obj) end
end
Workspace.DescendantAdded:Connect(function(obj)
    if FixLagEnabled then task.wait(); ApplyClayAndClean(obj) end
end)

-- Free Auto Steal (proximity prompt)
local PromptCache = {}
local STEAL_DISTANCE = 35
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
    local stealKeywords = {"steal", "grab", "take", "collect", "rob", "loot", "pickpocket", "snatch"}
    for _, keyword in ipairs(stealKeywords) do if string.find(action, keyword) then return true end end
    return false
end
local function RefreshPromptCache()
    table.clear(PromptCache)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if IsStealPrompt(obj) then table.insert(PromptCache, obj) end
    end
end
Workspace.DescendantAdded:Connect(function(descendant)
    if IsStealPrompt(descendant) then table.insert(PromptCache, descendant) end
end)
Workspace.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        local idx = table.find(PromptCache, descendant)
        if idx then table.remove(PromptCache, idx) end
    end
end)
local FreeAutoSteal = { Enabled = false }
task.spawn(function()
    RefreshPromptCache()
    while running do
        task.wait(0.15)
        if FreeAutoSteal.Enabled and H.isAlive() then
            local hrp = H.getRoot()
            if hrp then
                local closest, closestDistance = nil, STEAL_DISTANCE
                for i = #PromptCache, 1, -1 do
                    local obj = PromptCache[i]
                    if obj and obj.Parent and obj.Enabled then
                        local part = GetPromptPart(obj)
                        if part and part:IsA("BasePart") then
                            local distance = (hrp.Position - part.Position).Magnitude
                            if distance <= closestDistance then closestDistance = distance; closest = obj end
                        end
                    else
                        table.remove(PromptCache, i)
                    end
                end
                if closest then
                    if type(fireproximityprompt) == "function" then
                        pcall(function() fireproximityprompt(closest, STEAL_DISTANCE, 0, false) end)
                    else
                        pcall(function() closest.HoldDuration = 0; closest:InputHoldBegin(); closest:InputHoldEnd() end)
                    end
                end
            end
        end
    end
end)

-- Visual Pets
local VisualPets = { spawned = {}, orbitRadius = 4, orbitSpeed = 0.8 }
local VisualPetsFolder = Instance.new("Folder")
VisualPetsFolder.Name = "ZenXVisualPets"; VisualPetsFolder.Parent = Workspace
function H.findPetModel(text)
    local search = text:lower()
    for _, child in ipairs(Workspace:GetChildren()) do
        for _, descendant in ipairs(child:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name:lower():find(search, 1, true) and descendant:FindFirstChildWhichIsA("BasePart") then
                return descendant
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
    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true; descendant.CanCollide = false; descendant.CanTouch = false; descendant.CastShadow = false
        end
    end
    clone.Name = "VP_" .. text; clone.Parent = VisualPetsFolder
    table.insert(VisualPets.spawned, { model = clone })
end
function H.clearVisualPets()
    for _, item in ipairs(VisualPets.spawned) do pcall(function() item.model:Destroy() end) end
    VisualPets.spawned = {}
end
RunService.Heartbeat:Connect(function()
    if not running then return end
    local root = H.getRoot()
    if not root or #VisualPets.spawned == 0 then return end
    local base = root.Position + Vector3.new(0, 1, 0)
    local count = #VisualPets.spawned
    local now = tick()
    for i, item in ipairs(VisualPets.spawned) do
        local angle = (i - 1) * (6.283185307179586 / count) + now * VisualPets.orbitSpeed
        local offset = Vector3.new(math.cos(angle) * VisualPets.orbitRadius, 0, math.sin(angle) * VisualPets.orbitRadius)
        if item.model.PrimaryPart or item.model:FindFirstChildWhichIsA("BasePart") then
            pcall(function() item.model:PivotTo(CFrame.new(base + offset) * CFrame.Angles(0, angle + math.pi, 0)) end)
        end
    end
end)

-- ============================================================
-- RESPAWN RESET + AUTO BYPASS
-- ============================================================
H.track(LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    IsCarryingEgg = false
    TreadmillTrainingActive = false
    AutomationBusy = false
    AutomationLastRunAt = {}
    PlotFullUntil = 0
    ServerHopInProgress = false
    NoMatchingEggsSince = 0
    NextPlacementIndex = 1
    BypassApplied = false

    SetupCharacter(newCharacter)

    -- Auto-apply bypass if enabled
    if H.isOn("BypassAutoApply") then
        task.delay(1.2, function()
            if H.isAlive() then H.applyBypassAndSpeed() end
        end)
    end

    task.delay(0.3, function()
        local root = newCharacter:FindFirstChild("HumanoidRootPart")
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child.Name == "ZenXBypassMove" or child.Name == "ZenXBypassGyro" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end)
end))

-- ============================================================
-- STANDALONE UI
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
    if gethui then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
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
toggleBtn.Name = "ToggleBtn"
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
toggleBtn.Active = true
toggleBtn.Draggable = false
toggleBtn.Parent = toggleGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Color = Color3.fromRGB(190, 80, 255)
toggleStroke.Transparency = 0.1
toggleStroke.Parent = toggleBtn
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 90, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 50, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 130, 255)),
})
toggleGradient.Rotation = 45
toggleGradient.Parent = toggleStroke

-- Kích thước menu nhỏ hơn: 520x380
local PANEL_W, PANEL_H = 520, 380
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
panel.BackgroundColor3 = COLORS.panelBg
panel.BackgroundTransparency = 0.05
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
panelStroke.Color = COLORS.panelBorderHi
panelStroke.Transparency = 0.2
panelStroke.Parent = panel

local function addCorner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 6); c.Parent = parent; return c
end
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color or COLORS.panelBorder
    s.Thickness = thickness or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s
end
local function regText(label, key)
    table.insert(UI.__texts, { label = label, key = key })
    label.Text = L(key)
    return label
end

local header = Instance.new("Frame")
header.Name = "Header"
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
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 255)),
})
titleGrad.Parent = title

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
addCorner(discordBtn, 6)
addStroke(discordBtn, Color3.fromRGB(120, 70, 180), 1)
discordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end)
    H.notify("zen hubXsteal", L("n_discord_copied"), "Success", 3)
end)

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
addCorner(closeBtn, 6)
addStroke(closeBtn, Color3.fromRGB(150, 60, 220), 1)
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

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 4)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Parent = sidebarScroll

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 8)
sidebarPad.PaddingLeft = UDim.new(0, 6)
sidebarPad.PaddingRight = UDim.new(0, 6)
sidebarPad.Parent = sidebarScroll

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
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    conn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end
makeDraggable(panel, header)

do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    conn(toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false; dragStart = input.Position; startPos = toggleBtn.Position
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
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    conn(toggleBtn.MouseButton1Click:Connect(function()
        if moved then return end
        panel.Visible = not panel.Visible
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
function H.getState(id, fallback) local v = UI.GetState(id); if v ~= nil then return v end return fallback end
function H.isOn(id) return UI.GetState(id) == true end
function H.optionValue(id, fallback) local v = UI.GetState(id); if v == nil then return fallback end return v end
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
    for _, mutation in ipairs(H.recordMutations(asset)) do if selected[mutation] then return true end end
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

function UI.UpdateLanguage()
    for _, item in ipairs(UI.__texts) do
        if item.label and item.label.Parent then
            item.label.Text = L(item.key)
        end
    end
    for _, entry in ipairs(UI.__tabButtons) do
        if entry.btn and entry.btn.Parent then
            entry.btn.Text = L(entry.key)
        end
    end
end

local function makeTabButton(tabId, tabTitle, langKey)
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. tabId
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
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 10); pad.Parent = btn
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = COLORS.accent
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    addCorner(indicator, 2)
    if langKey then table.insert(UI.__tabButtons, { btn = btn, key = langKey }) end
    local function setActive(active)
        if active then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 25, 70), BackgroundTransparency = 0.15 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = COLORS.accentHi }):Play()
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
    addCorner(section, 8)
    addStroke(section, COLORS.sectionBorder, 1)
    local sectionList = Instance.new("UIListLayout")
    sectionList.Padding = UDim.new(0, 6)
    sectionList.SortOrder = Enum.SortOrder.LayoutOrder
    sectionList.Parent = section
    local sectionPad = Instance.new("UIPadding")
    sectionPad.PaddingTop = UDim.new(0, 8); sectionPad.PaddingBottom = UDim.new(0, 8)
    sectionPad.PaddingLeft = UDim.new(0, 10); sectionPad.PaddingRight = UDim.new(0, 10)
    sectionPad.Parent = section
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

local function makeRow(parent, height)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = COLORS.panelBg2
    row.BackgroundTransparency = 0.4
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, height or 30)
    row.Parent = parent
    addCorner(row, 6)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = row
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
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(38, 20)
    switch.Position = UDim2.new(1, -38, 0.5, -10)
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
        TweenService:Create(knob, info, { Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) }):Play()
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
    knob.Size = UDim2.fromOffset(14, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = COLORS.text
    knob.BorderSizePixel = 0
    knob.Parent = bar
    addCorner(knob, 7)
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
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -190, 0, 0)
    valueLabel.Size = UDim2.fromOffset(156, 32)
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
    addCorner(dropdown, 6)
    addStroke(dropdown, COLORS.panelBorder, 1)
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownList.Parent = dropdown
    local dropdownPad = Instance.new("UIPadding")
    dropdownPad.PaddingTop = UDim.new(0, 4); dropdownPad.PaddingBottom = UDim.new(0, 4)
    dropdownPad.PaddingLeft = UDim.new(0, 4); dropdownPad.PaddingRight = UDim.new(0, 4)
    dropdownPad.Parent = dropdown
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
    local function updateLabel()
        if isMulti then
            local list = {}
            for k in pairs(selected) do if selected[k] then table.insert(list, k) end end
            table.sort(list)
            if #list == 0 then valueLabel.Text = L("all")
            elseif #list <= 2 then valueLabel.Text = table.concat(list, ", ")
            else valueLabel.Text = string.format("%s +%d", list[1], #list - 1) end
        else valueLabel.Text = tostring(selected or "") end
    end
    updateLabel()
    local entries = {}
    for _, option in ipairs(opts.Options or {}) do
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
        local function refresh()
            local active = isMulti and selected[option] == true or (not isMulti and selected == option)
            entry.TextColor3 = active and COLORS.accentHi or COLORS.text
        end
        refresh()
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
            if not isMulti then dropdown.Visible = false; arrowBtn.Text = "v" end
        end)
    end
    arrowBtn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
        arrowBtn.Text = dropdown.Visible and "^" or "v"
    end)
    return arrowBtn
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
    local action = Instance.new("TextLabel")
    action.BackgroundColor3 = COLORS.accent
    action.BackgroundTransparency = 0.15
    action.Size = UDim2.fromOffset(64, 22)
    action.Position = UDim2.new(1, -64, 0.5, -11)
    action.Font = Enum.Font.GothamBold
    action.TextSize = 11
    action.TextColor3 = COLORS.text
    action.Text = opts.Text or "Run"
    action.Parent = row
    addCorner(action, 4)
    btn.MouseButton1Click:Connect(function()
        if opts.Callback then pcall(opts.Callback) end
    end)
    return btn
end

function UI.AddDivider(parent, opts)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 12)
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
        lbl.TextSize = 11
        lbl.TextColor3 = COLORS.textMuted
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.Text = opts.Title
        lbl.Parent = holder
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
    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Size = UDim2.new(0.4, 0, 1, 0)
    value.Position = UDim2.fromScale(0.6, 0)
    value.Font = Enum.Font.GothamBold
    value.TextSize = 11
    value.TextColor3 = COLORS.accentHi
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
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6)
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
    note.Size = UDim2.fromOffset(240, 48)
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
    t.Position = UDim2.fromOffset(10, 5)
    t.Size = UDim2.new(1, -20, 0, 16)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = strokeColor
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = tostring(title or "zen hubXsteal")
    t.Parent = note
    local c = Instance.new("TextLabel")
    c.BackgroundTransparency = 1
    c.Position = UDim2.fromOffset(10, 22)
    c.Size = UDim2.new(1, -20, 0, 20)
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
    -- HOME
    local HomeTab = UI.AddTab({ Id = "home", Title = "Home", LangKey = "tab_home" })
    local SessionSec = UI.AddSection(HomeTab, { Title = "Session", LangKey = "sec_session" })
    local AccountSec = UI.AddSection(HomeTab, { Title = "Account", LangKey = "sec_account" })
    local QuickSec = UI.AddSection(HomeTab, { Title = "Quick Actions", LangKey = "sec_quick" })

    refs.statusRow = UI.AddStatus(SessionSec, { Title = "Automation", LangKey = "st_automation", Value = "Ready" })
    refs.statusRow:SetStatus("Success")
    refs.bypassRow = UI.AddStatus(SessionSec, { Title = "Bypass", Value = "Not Ready" })
    refs.stolenRow = UI.AddStatus(SessionSec, { Title = "Stolen Eggs", LangKey = "st_stolen_eggs", Value = "0" })
    refs.carryingRow = UI.AddStatus(SessionSec, { Title = "Carrying Egg", LangKey = "st_carrying", Value = "No" })
    refs.runtimeRow = UI.AddStatus(SessionSec, { Title = "Runtime", LangKey = "st_runtime", Value = "0m" })
    UI.AddStatus(SessionSec, { Title = "Server", LangKey = "st_server", Value = DisplayJobId })

    refs.inventoryProgress = UI.AddStatus(AccountSec, { Title = "Egg Inventory", LangKey = "st_egg_inventory", Value = tostring(H.eggInventoryCount()) })
    refs.moneyRow = UI.AddStatus(AccountSec, { Title = "Money", LangKey = "st_money", Value = "0" })
    refs.speedRow = UI.AddStatus(AccountSec, { Title = "Speed Power", LangKey = "st_speed_power", Value = "0" })
    refs.rebirthRow = UI.AddStatus(AccountSec, { Title = "Rebirths", LangKey = "st_rebirths", Value = "0" })
    refs.petsOwnedRow = UI.AddStatus(AccountSec, { Title = "Pets Owned", LangKey = "st_pets_owned", Value = "0" })

    -- Nút Bypass đặt ở Quick Actions để dễ truy cập
    UI.AddButton(QuickSec, { Title = "Activate Anti-Cheat Bypass (Clone Humanoid)", LangKey = "btn_bypass", Text = "Run", Callback = function()
        local success = H.applyBypassAndSpeed()
        if success then
            H.notify("zen hubXsteal", L("n_bypass_ok"), "Success", 3)
            if refs.bypassRow then refs.bypassRow:SetValue(L("st_ready_bypass")); refs.bypassRow:SetStatus("Success") end
        else
            H.notify("zen hubXsteal", L("n_bypass_fail"), "Error", 3)
        end
    end })

    UI.AddButton(QuickSec, { Title = "Return to Base", LangKey = "btn_return", Text = "Return", Callback = function()
        task.spawn(function()
            if not H.getBasePosition() or not H.returnToBaseBypass(nil) then
                H.notify("zen hubXsteal", L("n_base_unavail"), "Warning", 3)
            end
        end)
    end })
    UI.AddButton(QuickSec, { Title = "Place Eggs", LangKey = "btn_place_eggs", Text = "Place", Callback = function()
        task.spawn(function() H.runAutoPlaceEggs(true) end)
    end })
    UI.AddButton(QuickSec, { Title = "Server Hop", LangKey = "btn_server_hop", Text = "Hop", Callback = function()
        task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Manual") end)
    end })
    UI.AddButton(QuickSec, { Title = "Fuse Now", LangKey = "btn_fuse_now", Text = "Fuse", Callback = function()
        task.spawn(function() H.runAutoFusePets(true) end)
    end })
    UI.AddButton(QuickSec, { Title = "Teleport to Void (Fast Reset)", LangKey = "btn_void", Text = "Void", Callback = function()
        TeleportToVoid()
        H.notify("zen hubXsteal", L("n_void"), "Info", 3)
    end })
    UI.AddButton(QuickSec, { Title = "Open Server Hop GUI", LangKey = "btn_hop_gui_open", Text = "Open", Callback = function()
        OpenServerHopGUI()
        H.notify("zen hubXsteal", L("n_hop_gui_open"), "Info", 3)
    end })

    -- FARM
    local FarmTab = UI.AddTab({ Id = "farm", Title = "Farm", LangKey = "tab_farm" })
    local StealSec = UI.AddSection(FarmTab, { Title = "Steal Eggs", LangKey = "sec_steal" })
    local LifeSec = UI.AddSection(FarmTab, { Title = "Egg Handling", LangKey = "sec_egg_handling" })
    local ServerSec = UI.AddSection(FarmTab, { Title = "Server Hop", LangKey = "sec_server_hop" })
    local PrioritySec = UI.AddSection(FarmTab, { Title = "Task Order", LangKey = "sec_task_order" })

    UI.AddToggle(StealSec, { Id = "AutoStealSelected", Title = "Auto Steal Selected", LangKey = "tg_auto_steal_sel", Default = false })
    UI.AddToggle(StealSec, { Id = "AutoStealAll", Title = "Auto Steal All", LangKey = "tg_auto_steal_all", Default = false })
    UI.AddToggle(StealSec, { Id = "StealBigEggs", Title = "Steal Big Eggs", LangKey = "tg_steal_big", Default = false })
    UI.AddDivider(StealSec, { Title = "Target filters", LangKey = "dv_target_filter" })
    UI.AddDropdown(StealSec, { Id = "StealZones", Title = "Areas", LangKey = "dd_areas", Options = AreaNames, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealRarities", Title = "Rarities", LangKey = "dd_rarities", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealMutations", Title = "Mutations", LangKey = "dd_mutations", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDropdown(StealSec, { Id = "StealPriority", Title = "Target Priority", LangKey = "dd_target_priority", Options = STEAL_PRIORITIES, Default = "Rarest" })
    UI.AddSlider(StealSec, { Id = "StealBigEggScale", Title = "Minimum Big Egg Size", LangKey = "sl_big_egg_scale", Min = 1, Max = 50, Default = 1.5, Step = 0.1, Suffix = "x" })
    UI.AddDivider(StealSec, { Title = "Carry behavior", LangKey = "dv_carry_behavior" })
    UI.AddToggle(StealSec, { Id = "AutoReturn", Title = "Auto Return to Base", LangKey = "tg_auto_return", Default = true })
    UI.AddToggle(StealSec, { Id = "AutoDropEgg", Title = "Auto Drop Held Egg", LangKey = "tg_auto_drop", Default = false })

    UI.AddToggle(LifeSec, { Id = "AutoPlaceSelected", Title = "Auto Place Selected", LangKey = "tg_auto_place_sel", Default = false })
    UI.AddToggle(LifeSec, { Id = "AutoPlaceAll", Title = "Auto Place All", LangKey = "tg_auto_place_all", Default = false })
    UI.AddToggle(LifeSec, { Id = "AutoOpenReadyEggs", Title = "Auto Hatch Ready", LangKey = "tg_auto_hatch", Default = false })
    UI.AddDropdown(LifeSec, { Id = "LifecycleRarities", Title = "Lifecycle Rarities", LangKey = "dd_lifecycle_rarities", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(LifeSec, { Id = "LifecycleMutations", Title = "Lifecycle Mutations", LangKey = "dd_lifecycle_mutations", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDivider(LifeSec, { Title = "Egg selling", LangKey = "dv_egg_selling" })
    UI.AddToggle(LifeSec, { Id = "AutoSellEggs", Title = "Auto Sell Eggs", LangKey = "tg_auto_sell_eggs", Default = false })
    UI.AddDropdown(LifeSec, { Id = "SellEggRarities", Title = "Sell Rarities", LangKey = "dd_sell_egg_rarities", Options = RARITIES, Multi = true, Default = {} })
    UI.AddSlider(LifeSec, { Id = "SellEggInterval", Title = "Sell Interval", LangKey = "sl_sell_interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })

    UI.AddToggle(ServerSec, { Id = "AutoServerHop", Title = "Auto Server Hop", LangKey = "tg_auto_server_hop", Default = false })
    UI.AddDropdown(ServerSec, { Id = "HopMode", Title = "Hop When", LangKey = "dd_hop_when", Options = ServerHopModes, Default = "No Matching Eggs" })
    UI.AddSlider(ServerSec, { Id = "HopValue", Title = "Wait Before Hop", LangKey = "sl_wait_hop", Min = 1, Max = 200, Default = 15, Step = 1 })
    UI.AddButton(ServerSec, { Title = "Hop Now", LangKey = "btn_hop_now", Text = "Hop", Callback = function()
        task.spawn(function() ServerHopRetryAfter = 0; H.serverHop("Manual") end)
    end })
    UI.AddButton(ServerSec, { Title = "Open Server Hop GUI", LangKey = "btn_hop_gui_open", Text = "Open", Callback = function()
        OpenServerHopGUI()
    end })

    for i, name in ipairs(PrioritySlotOptionNames) do
        UI.AddDropdown(PrioritySec, { Id = name, Title = "Priority " .. i, Options = PriorityTaskNames, Default = PriorityTaskNames[i] })
    end

    -- PETS
    local PetsTab = UI.AddTab({ Id = "pets", Title = "Pets", LangKey = "tab_pets" })
    local PetsOverview = UI.AddSection(PetsTab, { Title = "Pets", LangKey = "sec_pets" })
    local FuseSec = UI.AddSection(PetsTab, { Title = "Auto Fuse", LangKey = "sec_auto_fuse" })
    local SellPetSec = UI.AddSection(PetsTab, { Title = "Auto Sell Pets", LangKey = "sec_auto_sell_pets" })

    UI.AddToggle(PetsOverview, { Id = "AutoEquipBest", Title = "Auto Equip Best Pets", LangKey = "tg_auto_equip_best", Default = false })
    UI.AddToggle(PetsOverview, { Id = "AutoDeleteOwnPets", Title = "Hide Own Pet Renders", LangKey = "tg_hide_own_pets", Default = false })
    UI.AddToggle(FuseSec, { Id = "AutoFusePets", Title = "Auto Fuse Pets", LangKey = "tg_auto_fuse", Default = false })
    UI.AddDropdown(FuseSec, { Id = "FuseRarities", Title = "Fuse Rarities", LangKey = "dd_fuse_rarities", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(FuseSec, { Id = "FuseMutations", Title = "Fuse Mutations", LangKey = "dd_fuse_mutations", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddDropdown(FuseSec, { Id = "FuseTarget", Title = "Pick Group By", LangKey = "dd_fuse_target", Options = FUSE_TARGET_MODES, Default = "Highest Rarity" })
    UI.AddToggle(FuseSec, { Id = "FuseKeepMutated", Title = "Never Fuse Mutated", LangKey = "tg_fuse_keep_mut", Default = true })
    UI.AddToggle(FuseSec, { Id = "FuseKeepEquipped", Title = "Never Fuse Equipped", LangKey = "tg_fuse_keep_equip", Default = true })
    UI.AddToggle(FuseSec, { Id = "FuseAutoReveal", Title = "Auto Complete Reveal", LangKey = "tg_fuse_reveal", Default = true })
    UI.AddSlider(FuseSec, { Id = "FuseMaxScale", Title = "Maximum Scale to Fuse", LangKey = "sl_fuse_max_scale", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    UI.AddSlider(FuseSec, { Id = "FuseKeepPerCategory", Title = "Keep Per Pet Type", LangKey = "sl_fuse_keep_per", Min = 0, Max = 20, Default = 0, Step = 1 })
    UI.AddSlider(FuseSec, { Id = "FuseInterval", Title = "Fuse Interval", LangKey = "sl_fuse_interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })
    UI.AddButton(FuseSec, { Title = "Fuse Now", LangKey = "btn_fuse_now", Text = "Fuse", Callback = function() task.spawn(function() H.runAutoFusePets(true) end) end })

    UI.AddToggle(SellPetSec, { Id = "AutoSellPets", Title = "Auto Sell Pets", LangKey = "tg_auto_sell_pets", Default = false })
    UI.AddDropdown(SellPetSec, { Id = "SellRarities", Title = "Sell Rarities", LangKey = "dd_sell_rarities", Options = RARITIES, Multi = true, Default = {} })
    UI.AddDropdown(SellPetSec, { Id = "SellMutations", Title = "Sell Mutations", LangKey = "dd_sell_mutations", Options = MUTATIONS, Multi = true, Default = {} })
    UI.AddToggle(SellPetSec, { Id = "SellKeepMutated", Title = "Never Sell Mutated", LangKey = "tg_sell_keep_mut", Default = true })
    UI.AddToggle(SellPetSec, { Id = "SellKeepEquipped", Title = "Never Sell Equipped", LangKey = "tg_sell_keep_equip", Default = true })
    UI.AddSlider(SellPetSec, { Id = "SellMaxScale", Title = "Maximum Scale to Sell", LangKey = "sl_sell_max_scale", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    UI.AddSlider(SellPetSec, { Id = "SellInterval", Title = "Sell Interval", LangKey = "sl_sell_int", Min = 1, Max = 120, Default = 6, Step = 1, Suffix = " s" })

    -- PROGRESS
    local ProgressTab = UI.AddTab({ Id = "progress", Title = "Progress", LangKey = "tab_progress" })
    local UpgradesSec = UI.AddSection(ProgressTab, { Title = "Upgrades", LangKey = "sec_upgrades" })
    local RewardsSec = UI.AddSection(ProgressTab, { Title = "Rewards", LangKey = "sec_rewards" })
    local EquipmentSec = UI.AddSection(ProgressTab, { Title = "Equipment", LangKey = "sec_equipment" })
    local TrainingSec = UI.AddSection(ProgressTab, { Title = "Training", LangKey = "sec_training" })
    UI.AddToggle(UpgradesSec, { Id = "AutoUpgrades", Title = "Auto Buy Upgrades", LangKey = "tg_auto_upgrades", Default = false })
    UI.AddDropdown(UpgradesSec, { Id = "UpgradeTypes", Title = "Upgrade Types", LangKey = "dd_upgrade_types", Options = UPGRADE_TYPES, Multi = true, Default = { "Base", "Treadmill" } })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimIndex", Title = "Auto Claim Index", LangKey = "tg_auto_claim_index", Default = false })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimGroupReward", Title = "Auto Claim Group Reward", LangKey = "tg_auto_claim_group", Default = false })
    UI.AddToggle(RewardsSec, { Id = "AutoClaimOffline", Title = "Claim Offline Earnings", LangKey = "tg_auto_claim_offline", Default = false })
    UI.AddToggle(EquipmentSec, { Id = "AutoBuyTrail", Title = "Auto Buy Trail", LangKey = "tg_auto_buy_trail", Default = false })
    UI.AddDropdown(EquipmentSec, { Id = "TrailWanted", Title = "Trails", LangKey = "dd_trails", Options = TrailNames, Multi = true, Default = {} })
    UI.AddToggle(EquipmentSec, { Id = "AutoEquipBestTrail", Title = "Auto Equip Best Trail", LangKey = "tg_auto_equip_best_trail", Default = false })
    UI.AddToggle(EquipmentSec, { Id = "AutoEquipBestGear", Title = "Auto Equip Best Gear", LangKey = "tg_auto_equip_best_gear", Default = false })
    UI.AddToggle(TrainingSec, { Id = "AutoTreadmill", Title = "Auto Treadmill Training", LangKey = "tg_auto_treadmill", Default = false })

    -- PLAYER
    local PlayerTab = UI.AddTab({ Id = "player", Title = "Player", LangKey = "tab_player" })
    local EspSec = UI.AddSection(PlayerTab, { Title = "ESP", LangKey = "sec_esp" })
    local MoveSec = UI.AddSection(PlayerTab, { Title = "Movement", LangKey = "sec_movement" })
    local TeleportSec = UI.AddSection(PlayerTab, { Title = "Teleports", LangKey = "sec_teleports" })
    UI.AddToggle(EspSec, { Id = "EspWorldEggs", Title = "World Egg ESP", LangKey = "tg_esp_world", Default = false })
    UI.AddToggle(EspSec, { Id = "EspCarriedEggs", Title = "Carried and Dropped Egg ESP", LangKey = "tg_esp_carried", Default = false })
    UI.AddToggle(EspSec, { Id = "EspGuards", Title = "Guard ESP", LangKey = "tg_esp_guards", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPets", Title = "Pet ESP", LangKey = "tg_esp_pets", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPlayers", Title = "Player ESP", LangKey = "tg_esp_players", Default = false })
    UI.AddToggle(EspSec, { Id = "EspMachines", Title = "Machine ESP", LangKey = "tg_esp_machines", Default = false })
    UI.AddToggle(EspSec, { Id = "EspPlots", Title = "Plot ESP", LangKey = "tg_esp_plots", Default = false })
    UI.AddSlider(EspSec, { Id = "EspDistance", Title = "Render Distance", LangKey = "sl_esp_dist", Min = 100, Max = 6000, Default = 2000, Step = 50, Suffix = " studs" })
    UI.AddToggle(MoveSec, { Id = "WalkSpeedEnabled", Title = "Walk Speed Override", LangKey = "tg_walkspeed", Default = false })
    UI.AddSlider(MoveSec, { Id = "WalkSpeed", Title = "Walk Speed", LangKey = "sl_walkspeed", Min = 16, Max = 500, Default = 32, Step = 1 })
    UI.AddToggle(MoveSec, { Id = "JumpPowerEnabled", Title = "Jump Power Override", LangKey = "tg_jumppower", Default = false })
    UI.AddSlider(MoveSec, { Id = "JumpPower", Title = "Jump Power", LangKey = "sl_jumppower", Min = 10, Max = 500, Default = 50, Step = 1 })
    UI.AddToggle(MoveSec, { Id = "InfJump", Title = "Infinite Jump", LangKey = "tg_infjump", Default = false })
    UI.AddToggle(MoveSec, { Id = "NoClip", Title = "NoClip", LangKey = "tg_noclip", Default = false })
    UI.AddDivider(MoveSec, { Title = "Fly" })
    UI.AddToggle(MoveSec, { Id = "Fly", Title = "Fly", LangKey = "tg_fly", Default = false, Callback = function(v)
        if not v then local h = H.getHumanoid(); if h then h.PlatformStand = false end end
    end })
    UI.AddSlider(MoveSec, { Id = "FlySpeed", Title = "Fly Speed", LangKey = "sl_flyspeed", Min = 10, Max = 400, Default = 60, Step = 1 })
    UI.AddDropdown(TeleportSec, { Id = "WaypointTarget", Title = "Waypoint", LangKey = "dd_waypoint", Options = WaypointNames, Default = "Base" })
    UI.AddButton(TeleportSec, { Title = "Teleport to Waypoint", LangKey = "btn_tp_waypoint", Text = "Go", Callback = function()
        task.spawn(function()
            local position = H.resolveWaypoint(H.optionValue("WaypointTarget", "Base"))
            if not position then H.notify("zen hubXsteal", L("n_waypoint_unavail"), "Warning", 3); return end
            if not H.bypassMoveTo(position, nil, BYPASS_SPEED) then H.notify("zen hubXsteal", L("n_waypoint_fail"), "Error", 3) end
        end)
    end })
    UI.AddButton(TeleportSec, { Title = "Teleport to Void (Fast Reset)", LangKey = "btn_void", Text = "Void", Callback = function()
        TeleportToVoid()
        H.notify("zen hubXsteal", L("n_void"), "Info", 3)
    end })

    -- EXTRAS
    local ExtraTab = UI.AddTab({ Id = "extras", Title = "Extras", LangKey = "tab_extras" })

    -- Section Bypass Anti-Cheat
    local BypassSec = UI.AddSection(ExtraTab, { Title = "Anti-Cheat Bypass", LangKey = "sec_bypass" })
    UI.AddButton(BypassSec, {
        Title = "Activate Anti-Cheat Bypass (Clone Humanoid)",
        LangKey = "btn_bypass",
        Text = "Run",
        Callback = function()
            local success = H.applyBypassAndSpeed()
            if success then
                H.notify("zen hubXsteal", L("n_bypass_ok"), "Success", 3)
                if refs.bypassRow then refs.bypassRow:SetValue(L("st_ready_bypass")); refs.bypassRow:SetStatus("Success") end
            else
                H.notify("zen hubXsteal", L("n_bypass_fail"), "Error", 3)
            end
        end
    })
    UI.AddToggle(BypassSec, { Id = "BypassAutoApply", Title = "Auto-Apply Bypass on Respawn", LangKey = "tg_bypass_auto", Default = false })

    local CombatSec = UI.AddSection(ExtraTab, { Title = "Combat / Survival", LangKey = "sec_combat" })
    UI.AddToggle(CombatSec, { Id = "AntiRagdoll", Title = "Anti-Ragdoll / Anti-Knock", LangKey = "tg_anti_ragdoll", Default = true,
        Callback = function(v) PeteSettings.AntiRagdoll = v end })
    UI.AddDropdown(CombatSec, { Id = "AntiRagdollMode", Title = "Camera Mode", LangKey = "dd_anti_ragdoll_mode",
        Options = { "Không Chuyển Camera", "Chuyển Camera Sang Bản Thân" }, Default = "Không Chuyển Camera",
        Callback = function(v) PeteSettings.AntiRagdollMode = v end })
    UI.AddToggle(CombatSec, { Id = "AntiKnock", Title = "Anti-Knock (Remove Constraints)", LangKey = "tg_anti_knock", Default = true,
        Callback = function(v) PeteSettings.AntiKnock = v end })
    UI.AddToggle(CombatSec, { Id = "AntiTrap", Title = "Super Anti-Trap", LangKey = "tg_anti_trap", Default = false,
        Callback = function(v) H.setTrapImmune(v) end })

    local InteractSec = UI.AddSection(ExtraTab, { Title = "Interaction", LangKey = "sec_interaction" })
    UI.AddToggle(InteractSec, { Id = "InstantHold", Title = "Instant Interact (No Hold)", LangKey = "tg_instant_hold", Default = false,
        Callback = function(v) H.setInstantHold(v) end })
    UI.AddToggle(InteractSec, { Id = "FreeAutoSteal", Title = "Auto Steal Free (Proximity)", LangKey = "tg_free_auto_steal", Default = false,
        Callback = function(v) FreeAutoSteal.Enabled = v end })

    local SpeedSec = UI.AddSection(ExtraTab, { Title = "Speed Changer", LangKey = "sec_speed_changer" })
    UI.AddToggle(SpeedSec, { Id = "SpeedChanger", Title = "Enable WalkSpeed Lock", LangKey = "tg_speed_changer", Default = false,
        Callback = function(v) SpeedConfig.Enabled = v end })
    UI.AddSlider(SpeedSec, { Id = "SpeedValue", Title = "WalkSpeed Value", LangKey = "sl_speed_val", Min = 16, Max = 900, Default = 300, Step = 10,
        Callback = function(v) SpeedConfig.Value = v end })

    local PerfSec = UI.AddSection(ExtraTab, { Title = "Performance", LangKey = "sec_perf" })
    UI.AddButton(PerfSec, { Title = "Fix Lag (Clay + Remove Foliage)", LangKey = "btn_fixlag", Text = "Apply",
        Callback = function() H.enableFixLag(); H.notify("zen hubXsteal", L("n_fixlag_applied"), "Success", 3) end })

    local VisualSec = UI.AddSection(ExtraTab, { Title = "Visual Pets (Client Only)", LangKey = "sec_visual_pets" })
    UI.AddInput(VisualSec, { Id = "VisualPetName", Title = "Pet Name", LangKey = "in_vpet_name", Placeholder = "Dragon", Default = "" })
    UI.AddSlider(VisualSec, { Id = "VisualPetRadius", Title = "Orbit Radius", LangKey = "sl_vpet_radius", Min = 2, Max = 20, Default = 4, Step = 1,
        Callback = function(v) VisualPets.orbitRadius = v end })
    UI.AddSlider(VisualSec, { Id = "VisualPetSpeed", Title = "Orbit Speed", LangKey = "sl_vpet_speed", Min = 0, Max = 10, Default = 4, Step = 1,
        Callback = function(v) VisualPets.orbitSpeed = v * 0.2 end })
    UI.AddButton(VisualSec, { Title = "Spawn Visual Pet", LangKey = "btn_spawn_vpet", Text = "Spawn", Callback = function()
        local name = H.optionValue("VisualPetName", "")
        if name == "" then H.notify("zen hubXsteal", L("n_enter_pet"), "Warning", 3); return end
        H.spawnVisualPet(name)
    end })
    UI.AddButton(VisualSec, { Title = "Clear All Visual Pets", LangKey = "btn_clear_vpet", Text = "Clear", Callback = function() H.clearVisualPets() end })

    -- SYSTEM
    local SysTab = UI.AddTab({ Id = "system", Title = "System", LangKey = "tab_system" })
    local LangSec = UI.AddSection(SysTab, { Title = "Language", LangKey = "sec_language" })
    UI.AddDropdown(LangSec, {
        Id = "LangSelect",
        Title = "Language",
        Options = { "Tiếng Việt", "English" },
        Default = (Lang.Current == "vi") and "Tiếng Việt" or "English",
        Callback = function(value)
            local selected = value
            if typeof(value) == "table" then selected = value[1] or value end
            if selected == "English" and Lang.Current ~= "en" then
                Lang.Current = "en"; UI.UpdateLanguage()
                H.notify("zen hubXsteal", L("n_lang_changed"), "Success", 3)
            elseif selected == "Tiếng Việt" and Lang.Current ~= "vi" then
                Lang.Current = "vi"; UI.UpdateLanguage()
                H.notify("zen hubXsteal", L("n_lang_changed"), "Success", 3)
            end
        end
    })

    local SessionSysSec = UI.AddSection(SysTab, { Title = "Session", LangKey = "sec_session" })
    local PerformanceSec = UI.AddSection(SysTab, { Title = "Performance", LangKey = "sec_performance" })
    local WebhookSec = UI.AddSection(SysTab, { Title = "Webhooks", LangKey = "sec_webhooks" })
    local AboutSec = UI.AddSection(SysTab, { Title = "About", LangKey = "sec_about" })
    UI.AddToggle(SessionSysSec, { Id = "AntiAfk", Title = "Anti-AFK", LangKey = "tg_anti_afk", Default = true })
    UI.AddToggle(SessionSysSec, { Id = "AntiGameplayPause", Title = "No Gameplay Paused", LangKey = "tg_no_pause", Default = true,
        Callback = function(v) H.applyAntiGameplayPause(v) end })
    UI.AddToggle(SessionSysSec, { Id = "AutoReconnect", Title = "Auto Reconnect", LangKey = "tg_auto_reconnect", Default = false })
    UI.AddButton(SessionSysSec, { Title = "Rejoin Server", LangKey = "btn_rejoin", Text = "Rejoin", Callback = function() H.rejoinServer() end })
    UI.AddButton(SessionSysSec, { Title = "Copy Join Script", LangKey = "btn_copy_join", Text = "Copy", Callback = function()
        pcall(function() setclipboard(string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)',
            game.PlaceId, CurrentJobId)) end)
        H.notify("zen hubXsteal", L("n_join_copied"), "Success", 3)
    end })
    UI.AddToggle(PerformanceSec, { Id = "FpsBoost", Title = "FPS Boost", LangKey = "tg_fps_boost", Default = false,
        Callback = function(v) if v then H.enableFpsBoost() else H.disableFpsBoost() end end })
    UI.AddToggle(PerformanceSec, { Id = "DisableRendering", Title = "Disable 3D Rendering", LangKey = "tg_disable_render", Default = false,
        Callback = function(v) H.applyRendering(v) end })
    UI.AddSlider(PerformanceSec, { Id = "FpsCap", Title = "FPS Cap", LangKey = "sl_fps_cap", Min = 15, Max = 360, Default = 60, Step = 1, Suffix = " fps",
        Callback = function(v) H.applyFpsCap(v) end })
    UI.AddToggle(WebhookSec, { Id = "WebhookEnabled", Title = "Enable Webhooks", LangKey = "tg_webhook", Default = false })
    UI.AddInput(WebhookSec, { Id = "WebhookUrl", Title = "Webhook URL", LangKey = "in_webhook_url", Placeholder = "https://discord.com/api/webhooks/...", Default = "" })
    UI.AddInput(WebhookSec, { Id = "WebhookPingId", Title = "Webhook Ping User ID", LangKey = "in_webhook_ping", Placeholder = "123456789012345678", Default = "" })
    UI.AddSlider(WebhookSec, { Id = "WebhookInterval", Title = "Summary Interval", LangKey = "sl_webhook_int", Min = 1, Max = 180, Default = 15, Step = 1, Suffix = " min" })
    UI.AddButton(WebhookSec, { Title = "Send Summary Now", LangKey = "btn_send_summary", Text = "Send", Callback = function()
        task.spawn(function()
            local sent = H.sendSummary()
            H.notify("zen hubXsteal", sent and L("n_summary_sent") or L("n_summary_fail"), sent and "Success" or "Error", 3)
        end)
    end })
    UI.AddParagraph = nil -- Placeholder to avoid error (not defined previously; skip)
    UI.AddButton(AboutSec, { Title = "Copy Discord Link", LangKey = "btn_copy_discord", Text = "Copy", Callback = function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        H.notify("zen hubXsteal", L("n_discord_copied"), "Success", 3)
    end })
    UI.AddDivider(AboutSec, { Title = "Danger Zone", LangKey = "dv_danger" })
    UI.AddButton(AboutSec, { Title = "Unload Script", LangKey = "btn_unload", Text = "Unload", Callback = function() H.unload() end })
end

UI.UpdateLanguage()

local function refreshHomeDashboard()
    if not running then return end
    pcall(function()
        if refs.carryingRow then
            refs.carryingRow:SetValue(IsCarryingEgg and L("st_yes") or L("st_no"))
            refs.carryingRow:SetStatus(IsCarryingEgg and "Warning" or "Neutral")
        end
        if refs.bypassRow then
            if BypassApplied then
                refs.bypassRow:SetValue(L("st_ready_bypass")); refs.bypassRow:SetStatus("Success")
            else
                refs.bypassRow:SetValue(L("st_not_ready")); refs.bypassRow:SetStatus("Warning")
            end
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

function H.unload()
    if not running then return end
    running = false
    pcall(H.stopTreadmillTraining)
    pcall(function() H.applyAntiGameplayPause(false) end)
    pcall(function() H.applyRendering(false) end)
    pcall(H.disableFpsBoost)
    pcall(H.clearAllEsp)
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
    genv.__APEX_HUB_RUNNING = nil
    genv.__APEX_HUB_SHUTDOWN = nil
end
genv.__APEX_HUB_SHUTDOWN = H.unload

pcall(function()
    if not getconnections then return end
    for _, c in ipairs(getconnections(LocalPlayer.Idled)) do pcall(function() c:Disable() end) end
end)

local function applyNoClipTo(inst) if inst and inst:IsA("BasePart") then inst.CanCollide = false end end
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
    if humanoid and humanoid.Health > 0 then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

H.track(RunService.RenderStepped:Connect(function(dt)
    if not running or not H.isOn("Fly") then return end
    local root = H.getRoot(); local humanoid = H.getHumanoid()
    local cam = Workspace.CurrentCamera
    if not root or not humanoid or not cam then return end
    if humanoid.Health <= 0 then return end
    humanoid.PlatformStand = true
    local direction = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, 1, 0) end
    root.AssemblyLinearVelocity = Vector3.zero
    if direction.Magnitude > 0 then
        root.CFrame = root.CFrame + direction.Unit * (tonumber(H.optionValue("FlySpeed", 60)) or 60) * dt
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
            if not H.isAlive() or IsBypassing then return end
            if H.stealingEnabled() then H.swapStealHumanoid() end
            runCarryJobs()
            runPriorityJobs()
        end)
    end

    if schedulerDue("dashboard", 2) then
        refreshHomeDashboard()
        local noclipOn = H.isOn("NoClip")
        if noclipOn ~= LastNoClipOn then LastNoClipOn = noclipOn; setNoClip(noclipOn) end
        if H.isOn("WalkSpeedEnabled") then
            local humanoid = H.getHumanoid()
            if humanoid and humanoid.Health > 0 then
                humanoid.WalkSpeed = tonumber(H.optionValue("WalkSpeed", 32)) or 32
            end
        end
        if H.isOn("JumpPowerEnabled") then
            local humanoid = H.getHumanoid()
            if humanoid and humanoid.Health > 0 then
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
        if H.isOn("AutoFusePets") and not AutomationBusy and not IsCarryingEgg and H.isAlive() then
            AutomationBusy = true; pcall(H.runAutoFusePets); AutomationBusy = false
        end
    end

    if schedulerDue("sellPets", tonumber(H.optionValue("SellInterval", 6)) or 6) then
        if H.isOn("AutoSellPets") and not AutomationBusy and not IsCarryingEgg and H.isAlive() then pcall(H.runAutoSellPets) end
    end

    if schedulerDue("sellEggs", tonumber(H.optionValue("SellEggInterval", 8)) or 8) then
        if H.isOn("AutoSellEggs") and not AutomationBusy and not IsCarryingEgg and H.isAlive() then
            AutomationBusy = true; pcall(H.runAutoSellEggs); AutomationBusy = false
        end
    end

    if schedulerDue("upgrades", 4) then
        if H.isOn("AutoUpgrades") and not IsCarryingEgg and H.isAlive() then pcall(H.runAutoUpgrades) end
        if H.isOn("AutoBuyTrail") and not IsCarryingEgg and H.isAlive() then pcall(H.runAutoBuyTrail) end
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
                    local camera = Workspace.CurrentCamera
                    if camera then
                        VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
                        VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
                        LastAntiAfkAt = tick()
                    end
                end)
            end
        end
    end
end))

if H.isOn("AntiGameplayPause") then H.applyAntiGameplayPause(true) end
H.applyFpsCap(H.optionValue("FpsCap", 60))

H.notify("zen hubXsteal", L("n_ready"), "Success", 5)
if refs.statusRow then refs.statusRow:SetStatus("Success") end