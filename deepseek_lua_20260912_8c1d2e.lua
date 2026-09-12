local Lang = "vi" -- default
local Translations = {
    vi = {
        -- Tab names
        Tab_Home = "Trang chủ",
        Tab_Farm = "Farm Trứng",
        ...
        -- Section names
        Sec_Steal = "Trộm trứng",
        ...
        -- Toggle/button titles
        ...
    },
    en = {
        ...
    }
}
local function T(key) return Translations[Lang][key] or key end