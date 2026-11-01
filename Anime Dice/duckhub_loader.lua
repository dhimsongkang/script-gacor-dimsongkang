-- ====================================================================
-- DuckHub Anime Dice Loader (Anti-Cache)
-- ====================================================================

repeat task.wait() until game:IsLoaded()

script_key = "EtQIJxtWmDWgERhTazGxfgvuwzFbWolO";
getgenv().script_key = script_key

getgenv().TradeConfig = {
    ["Enabled"] = true,
    ["Receiver"] = "dimsongkang1",
    ["Whitelist Senders"] = {},
    ["Accept Any Sender"] = true,
    ["Units"] = {
        ["Enabled"] = true,
        ["Mode"] = "Rarity",
        ["Rarities"] = {
            ["Legendary"] = true,
            ["Mythical"] = true,
            ["Divine"] = true,
            ["Celestial"] = true,
            ["Exotic"] = true,
            ["Secret I"] = true,
            ["Secret II"] = true,
            ["Heavenly"] = true,
            ["Exclusive"] = true,
        },
        ["Whitelist Units"] = {},
        ["Keep Equipped"] = false,
        ["Keep Locked"] = true,
    },
    ["Tokens"] = {
        ["Gems"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Trait Reroll"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
    },
    ["Spins"] = {
        ["Lucky Spin"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Jackpot Spin"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
    },
    ["Boosts"] = {
        ["Enabled"] = false,
        ["Min Tier"] = 1,
        ["Categories"] = { "Luck", "Damage", "Income", "Dragon Luck", "Dragon Income", "Dragon Damage", "Cursed Luck", "Cursed Damage", "Cursed Income", "Pirate Luck", "Pirate Damage", "Pirate Income", "Leaf Luck", "Leaf Damage", "Leaf Income", "Slayer Luck", "Slayer Damage", "Slayer Income" },
        ["Keep Amount"] = 0
    },
    ["Gear"] = {
        ["Enabled"] = false,
        ["Mode"] = "Rarity",
        ["Rarities"] = { ["Divine"] = true, ["Legendary"] = true, ["Rare"] = false },
        ["Slots"] = { ["Head"] = true, ["Torso"] = true, ["Back"] = true, ["Upper"] = true, ["Waist"] = true },
        ["Whitelist Gear"] = {},
        ["Keep Equipped"] = true,
        ["Keep Amount"] = 0,
    },
    ["Settings"] = {
        ["Auto Loop Trade"] = true,
        ["Stop When Empty"] = true,
        ["Offer Delay"] = 0.3,
        ["Ready Wait Time"] = 1.0,
    },
    ["Hop"] = {
        ["Enabled"] = false,
        ["Mode"] = "JobFile",
        ["Target JobId"] = "",
        ["Use JobFile"] = true,
        ["Receiver Auto Hop If Full"] = true,
        ["Max Players Threshold"] = 8,
        ["Publish Interval"] = 5,
        ["Hop Delay"] = 8,
        ["Max Hops"] = 20,
    },
    ["Auto Sell"] = {
        ["Enabled"] = false,
        ["Max Rarity"] = "Secret I",
        ["Keep Equipped"] = true,
        ["Keep Locked"] = true,
        ["Keep Tower Team"] = true,
        ["Protect Exclusive"] = true,
        ["Free Slots"] = 20,
        ["Max Sell Per Run"] = 10,
    },
    ["Auto Change"] = {
        ["Enabled"] = false,
        ["Farmsync"] = { ["Enabled"] = false, ["Folder From"] = "", ["Folder To"] = "", ["Without Replace"] = false, ["Config ID"] = nil },
        ["Yummy"] = { ["Enabled"] = false },
        ["Farmerv5"] = { ["Enabled"] = false, ["API Key"] = "", ["Option"] = 1 },
    }
}

-- Load DuckHub Core Payload via Anti-Cache GitHub Raw URL
loadstring(game:HttpGet("https://raw.githubusercontent.com/dhimsongkang/script-gacor-dimsongkang/main/Anime%20Dice/duckhub.lua?t=" .. tostring(tick())))()

