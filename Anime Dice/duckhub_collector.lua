-- ====================================================================
-- DuckHub Collector Edition (Method 2: Receiver PC Join Sender VPS 1-by-1)
-- Mekanisme: Hybrid Cloud Sync (VPS <-> PC) + Local Queue -> Kosong Hapus JobId & Trigger FarmerV5
-- Game: Roblox Anime Dice (PlaceId: 113290951185459)
-- 100% Deobfuscated & Clean Source Code (Free of Luarmor / Luraph VM)
-- ====================================================================

repeat task.wait() until game:IsLoaded()

-- Single-Instance Manager & Duplicate Prevention
if _G.DuckHub_Instance then
    pcall(function()
        _G.DuckHub_Instance:Destroy()
    end)
end

-- Ensure game's native TradeController connection remains ENABLED and restore if disabled
pcall(function()
    if getconnections then
        local net = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
        local tradeService = net and net:FindFirstChild("TradeService")
        local re = tradeService and tradeService:FindFirstChild("RE")
        local tradeEvent = re and re:FindFirstChild("TradeEvent")
        if tradeEvent then
            for _, conn in ipairs(getconnections(tradeEvent.OnClientEvent)) do
                local isGameScript = false
                pcall(function()
                    if getinfo then
                        local inf = getinfo(conn.Function)
                        local src = tostring(inf.source or "")
                        if string.find(src, "TradeController") or string.find(src, "Framework") then
                            isGameScript = true
                        end
                    end
                end)
                if isGameScript then
                    -- Re-enable game's native trading UI controller
                    pcall(function() conn:Enable() end)
                else
                    -- Disable orphaned DuckHub connections from previous executions
                    pcall(function() conn:Disable() end)
                end
            end
        end
    end
end)

local InstanceManager = {
    Connections = {},
    Threads = {},
    IsAlive = true,
}

function InstanceManager:AddConnection(conn)
    if conn then
        table.insert(self.Connections, conn)
    end
    return conn
end

function InstanceManager:Spawn(fn)
    local thread = task.spawn(fn)
    table.insert(self.Threads, thread)
    return thread
end

function InstanceManager:Destroy()
    self.IsAlive = false
    for _, conn in ipairs(self.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    self.Connections = {}
    for _, thread in ipairs(self.Threads) do
        pcall(task.cancel, thread)
    end
    self.Threads = {}
    pcall(function()
        local targets = {game:GetService("CoreGui")}
        if gethui then
            pcall(function() table.insert(targets, gethui()) end)
        end
        local lp = game:GetService("Players").LocalPlayer
        if lp and lp:FindFirstChild("PlayerGui") then
            table.insert(targets, lp.PlayerGui)
        end
        for _, p in ipairs(targets) do
            if p then
                for _, c in ipairs(p:GetChildren()) do
                    if c.Name == "DuckHub_Trade_GUI" then
                        c:Destroy()
                    end
                end
            end
        end
    end)
end

_G.DuckHub_Instance = InstanceManager

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.5)
    LocalPlayer = Players.LocalPlayer
end

-- ====================================================================
-- 1. Configuration & Persistence System (DuckHub/config.json)
-- ====================================================================
local FOLDER_NAME = "DuckHub"
local CONFIG_FILE = "DuckHub/config.json"
local JOB_FILE = "DuckHub_Trade_JobId.txt"
local SENDER_QUEUE_FILE = "DuckHub/sender_queue.json"
local HISTORY_FILE = "DuckHub/animedice_traded.json"

local DEFAULT_CONFIG = {
    ["Enabled"] = true,
    ["Receiver"] = "dimsongkang1",
    ["Whitelist Senders"] = {},
    ["Accept Any Sender"] = true,
    ["Units"] = {
        ["Enabled"] = false,
        ["Mode"] = "Rarity",
        ["Rarities"] = {
            ["Common"] = false,
            ["Uncommon"] = false,
            ["Rare"] = false,
            ["Epic"] = false,
            ["Legendary"] = false,
            ["Mythical"] = true,
            ["Divine"] = true,
            ["Celestial"] = true,
            ["Exotic"] = true,
            ["Secret I"] = true,
            ["Secret II"] = true,
            ["Heavenly"] = true,
            ["Galactic"] = true,
            ["Cosmic"] = true,
            ["Exclusive"] = true,
        },
        ["Whitelist Units"] = {},
        ["Keep Equipped"] = true,
        ["Keep Locked"] = true,
        ["Keep Tower Team"] = true,
    },
    ["Tokens"] = {
        ["Gems"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Trait Reroll"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Reset Token"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
    },
    ["Spins"] = {
        ["Lucky Spin"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Jackpot Spin"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Mega Jackpot"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Grand Jackpot"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Daily Jackpot"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Pumpkin Spin"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Pumpkin Jackpot"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
        ["Witch's Jackpot"] = { ["Enabled"] = true, ["Keep Amount"] = 0 },
    },
    ["Boosts"] = {
        ["Enabled"] = true,
        ["Min Tier"] = 1,
        ["Keep Amount"] = 0,
        ["Selected Categories"] = {
            ["Soul Luck"] = true,
            ["Soul Damage"] = true,
            ["Soul Income"] = true,
            ["Shadow Luck"] = true,
            ["Shadow Speed"] = true,
            ["Shadow Income"] = true,
            ["Slayer Luck"] = true,
            ["Slayer Damage"] = true,
            ["Slayer Income"] = true,
            ["Leaf Luck"] = true,
            ["Leaf Damage"] = true,
            ["Leaf Income"] = true,
            ["Pirate Luck"] = true,
            ["Pirate Damage"] = true,
            ["Pirate Income"] = true,
            ["Cursed Luck"] = true,
            ["Cursed Damage"] = true,
            ["Cursed Income"] = true,
            ["Dragon Luck"] = true,
            ["Dragon Damage"] = true,
            ["Dragon Income"] = true,
            ["Luck"] = true,
            ["Damage"] = true,
            ["Income"] = true,
            ["Spooky Luck"] = true,
            ["Candy Pot"] = true,
            ["Pumpkin Pot"] = true,
            ["Haunted Potion"] = true,
        },
        ["Categories"] = {
            "Soul Luck", "Soul Damage", "Soul Income",
            "Shadow Luck", "Shadow Speed", "Shadow Income",
            "Slayer Luck", "Slayer Damage", "Slayer Income",
            "Leaf Luck", "Leaf Damage", "Leaf Income",
            "Pirate Luck", "Pirate Damage", "Pirate Income",
            "Cursed Luck", "Cursed Damage", "Cursed Income",
            "Dragon Luck", "Dragon Damage", "Dragon Income",
            "Luck", "Damage", "Income",
            "Spooky Luck", "Candy Pot", "Pumpkin Pot", "Haunted Potion"
        }
    },
    ["Gear"] = {
        ["Enabled"] = true,
        ["Keep Equipped"] = false,
        ["Keep Amount"] = 0,
        ["Rarities"] = {
            ["Divine"] = true,
            ["Haunted"] = true,
            ["Legendary"] = true,
            ["Rare"] = true
        },
        ["Slots"] = {
            ["Back"] = true,
            ["Head"] = true,
            ["Torso"] = true,
            ["Upper"] = true,
            ["Waist"] = true
        },
        ["Selected Gears"] = {
            ["Enol's Drums"] = true,
            ["Reaper's Scythe"] = true,
            ["Vampire Cape"] = true,
            ["Ichiga's Zangetsu"] = true,
            ["Jogu's Robe"] = true,
            ["Obita's War Fan"] = true,
            ["Pikolo's Cape"] = true,
            ["Shizui's Tanto"] = true,
            ["Igras's Helm"] = true,
            ["Obita's Mask"] = true,
            ["Pumpkin Head"] = true,
            ["Golden Hair"] = true,
            ["Nezuka's Bamboo"] = true,
            ["Ulquiro's Mask"] = true,
            ["Usop's Hat"] = true,
            ["Mazun's Coat"] = true,
            ["Mummy Wraps"] = true,
            ["Monarch's Coat"] = true,
            ["Todoh's Vest"] = true,
            ["Angel's Halo"] = true,
            ["Ghost Wisps"] = true,
            ["Aizan's Katana"] = true,
            ["Sakuna's Sash"] = true,
            ["Candy Bucket"] = true,
            ["Tanjuro's Katana"] = true,
            ["Zaro's Swords"] = true,
            ["Jinwoo's Daggers"] = true
        },
        ["Whitelist Gear"] = {}
    },
    ["Settings"] = {
        ["Auto Loop Trade"] = true,
        ["Stop When Empty"] = true,
        ["Offer Delay"] = 0.3,
        ["Ready Wait Time"] = 1.0,
        ["Anti AFK"] = true,
        ["Safety Delay"] = 0.5,
    },
    ["Hop"] = {
        ["Enabled"] = true,
        ["Mode"] = "Friend",
        ["Target JobId"] = "",
        ["Use JobFile"] = false,
        ["Receiver Auto Hop If Full"] = true,
        ["Max Players Threshold"] = 8,
        ["Publish Interval"] = 5,
        ["Hop Delay"] = 5,
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
        ["Rarities"] = {
            ["Common"] = true,
            ["Uncommon"] = true,
            ["Rare"] = true,
            ["Epic"] = true,
            ["Legendary"] = false,
            ["Mythical"] = false,
            ["Divine"] = false,
            ["Celestial"] = false,
            ["Exotic"] = false,
            ["Secret I"] = false,
            ["Secret II"] = false,
            ["Heavenly"] = false,
            ["Galactic"] = false,
            ["Cosmic"] = false,
            ["Exclusive"] = false,
        },
    },
    ["Auto Change"] = {
        ["Enabled"] = true,
        ["Farmsync"] = { ["Enabled"] = false, ["Folder From"] = "", ["Folder To"] = "", ["Without Replace"] = false, ["Config ID"] = nil },
        ["Yummy"] = { ["Enabled"] = false },
        ["Farmerv5"] = { ["Enabled"] = true, ["API Key"] = "ak_9b01456dd738b682fa9ef5ed989130bf471794cf06e91d6bc9474507cd72d1bc", ["Option"] = 1, ["Base URL"] = "https://accountops.org" },
    }
}

local function deepCopy(t)
    if type(t) ~= "table" then return t end
    local res = {}
    for k, v in pairs(t) do
        res[k] = type(v) == "table" and deepCopy(v) or v
    end
    return res
end

local function deepMerge(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" and type(target[k]) == "table" then
            deepMerge(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
end

local Config = deepCopy(DEFAULT_CONFIG)

local function ensureFolderExists()
    pcall(function()
        if makefolder then
            if isfolder and not isfolder(FOLDER_NAME) then
                makefolder(FOLDER_NAME)
            elseif not isfolder then
                makefolder(FOLDER_NAME)
            end
        end
    end)
end

local function saveConfig()
    ensureFolderExists()
    pcall(function()
        if writefile then
            local json = HttpService:JSONEncode(Config)
            writefile(CONFIG_FILE, json)
            print("[DuckHub] Config saved to " .. CONFIG_FILE)
        end
    end)
end

local function loadConfig()
    ensureFolderExists()
    local loaded = false
    pcall(function()
        if isfile and isfile(CONFIG_FILE) and readfile then
            local content = readfile(CONFIG_FILE)
            if content and #content > 5 then
                local data = HttpService:JSONDecode(content)
                if type(data) == "table" then
                    deepMerge(data, DEFAULT_CONFIG)
                    Config = data
                    loaded = true
                    print("[DuckHub] Config loaded successfully from " .. CONFIG_FILE)
                end
            end
        end
    end)
    if not loaded then
        Config = deepCopy(DEFAULT_CONFIG)
        saveConfig()
    end
    if Config.Hop and Config.Hop["Receiver Auto Hop If Full"] then
        Config.Hop.Enabled = true
    end
    getgenv().TradeConfig = Config
end

loadConfig()

-- ====================================================================
-- 2. Game Remotes & Data Interfaces
-- ====================================================================
local TradeNetwork = ReplicatedStorage:WaitForChild("Network"):WaitForChild("TradeService")
local RE = TradeNetwork:WaitForChild("RE")
local RequestTradeRemote = RE:WaitForChild("RequestTrade")
local RespondToRequestRemote = RE:WaitForChild("RespondToRequest")
local ChangeOfferRemote = RE:WaitForChild("ChangeOffer")
local AdvanceTradeRemote = RE:WaitForChild("AdvanceTrade")
local CancelTradeRemote = RE:WaitForChild("CancelTrade")
local SetTradeRequestsEnabledRemote = RE:WaitForChild("SetTradeRequestsEnabled")
local TradeEventRemote = RE:WaitForChild("TradeEvent")

local DataController = nil
local EntryRegistry = nil
local TradeConfigModule = nil

pcall(function() DataController = require(ReplicatedStorage.Framework.Features.Data.DataController) end)
pcall(function() EntryRegistry = require(ReplicatedStorage.Framework.Features.Inventory.EntryRegistry) end)
pcall(function() TradeConfigModule = require(ReplicatedStorage.Framework.Features.Trading.TradeConfig) end)

pcall(function()
    SetTradeRequestsEnabledRemote:FireServer(true)
end)

local function getRole()
    local myName = LocalPlayer.Name:lower()
    local recName = (Config.Receiver or ""):lower()
    return (myName == recName) and "Receiver" or "Sender"
end

-- ====================================================================
-- 3. Modern Glass UI Construction
-- ====================================================================
local THEME = {
    Bg = Color3.fromRGB(16, 18, 24),
    Card = Color3.fromRGB(24, 27, 36),
    CardHover = Color3.fromRGB(32, 36, 48),
    Border = Color3.fromRGB(42, 47, 62),
    Accent = Color3.fromRGB(255, 196, 0),       -- Duck Yellow / Gold
    AccentDark = Color3.fromRGB(210, 155, 0),
    Cyan = Color3.fromRGB(0, 212, 255),
    Green = Color3.fromRGB(0, 230, 118),
    Red = Color3.fromRGB(255, 68, 68),
    Text = Color3.fromRGB(245, 247, 252),
    TextMuted = Color3.fromRGB(150, 156, 175)
}

local LogContainer = nil
local function addLog(text, color)
    print("[DuckHub] " .. tostring(text))
    if not LogContainer then return end
    pcall(function()
        local timeStr = os.date("%H:%M:%S")
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 18)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.Code
        l.TextSize = 11
        l.TextColor3 = color or THEME.Text
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = string.format("[%s] %s", timeStr, tostring(text))
        l.Parent = LogContainer
        LogContainer.CanvasPosition = Vector2.new(0, 999999)
    end)
end

-- Destroy old UI if exists
pcall(function()
    local targets = {game:GetService("CoreGui")}
    if gethui then
        pcall(function() table.insert(targets, gethui()) end)
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        table.insert(targets, LocalPlayer.PlayerGui)
    end
    for _, p in ipairs(targets) do
        if p then
            for _, c in ipairs(p:GetChildren()) do
                if c.Name == "DuckHub_Trade_GUI" then
                    c:Destroy()
                end
            end
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DuckHub_Trade_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647
pcall(function() ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)

local parentTarget = nil
pcall(function()
    if gethui then parentTarget = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        parentTarget = game:GetService("CoreGui")
    else
        parentTarget = LocalPlayer:WaitForChild("PlayerGui")
    end
end)
ScreenGui.Parent = parentTarget or LocalPlayer:WaitForChild("PlayerGui")

-- 3.1 Floating Toggle Pill (Draggable)
local TogglePill = Instance.new("TextButton")
TogglePill.Name = "TogglePill"
TogglePill.Size = UDim2.new(0, 135, 0, 36)
TogglePill.Position = UDim2.new(0.02, 0, 0.45, 0)
TogglePill.BackgroundColor3 = THEME.Bg
TogglePill.TextColor3 = THEME.Text
TogglePill.Font = Enum.Font.GothamBold
TogglePill.TextSize = 13
TogglePill.Text = " 🦆 DuckHub"
TogglePill.AutoButtonColor = false
TogglePill.Parent = ScreenGui

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(0, 18)
PillCorner.Parent = TogglePill

local PillStroke = Instance.new("UIStroke")
PillStroke.Color = THEME.Accent
PillStroke.Thickness = 1.5
PillStroke.Parent = TogglePill

local PillDot = Instance.new("Frame")
PillDot.Name = "Dot"
PillDot.Size = UDim2.new(0, 8, 0, 8)
PillDot.Position = UDim2.new(0, 12, 0.5, -4)
PillDot.BackgroundColor3 = Config.Enabled and THEME.Green or THEME.Red
PillDot.BorderSizePixel = 0
PillDot.Parent = TogglePill

local PillDotCorner = Instance.new("UICorner")
PillDotCorner.CornerRadius = UDim.new(1, 0)
PillDotCorner.Parent = PillDot

-- Dragging logic for Pill
do
    local dragging, dragInput, dragStart, startPos
    TogglePill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = TogglePill.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TogglePill.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TogglePill.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 3.2 Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = THEME.Border
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Dragging logic for MainFrame
do
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Toggle visibility on Pill click
TogglePill.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Top Title Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = THEME.Card
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 310, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = THEME.Accent
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Text = "DUCKHUB | COLLECTOR (VPS <-> PC)"
TitleLabel.Parent = TopBar

local StatusBadge = Instance.new("TextLabel")
StatusBadge.Name = "StatusBadge"
StatusBadge.Size = UDim2.new(0, 140, 0, 24)
StatusBadge.Position = UDim2.new(1, -210, 0.5, -12)
StatusBadge.BackgroundColor3 = THEME.Bg
StatusBadge.Font = Enum.Font.GothamMedium
StatusBadge.TextSize = 11
StatusBadge.TextColor3 = THEME.Cyan
StatusBadge.Text = getRole():upper() .. " [IDLE]"
StatusBadge.Parent = TopBar

local StatusBadgeCorner = Instance.new("UICorner")
StatusBadgeCorner.CornerRadius = UDim.new(0, 6)
StatusBadgeCorner.Parent = StatusBadge

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = THEME.CardHover
CloseBtn.TextColor3 = THEME.TextMuted
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Text = "X"
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Selector Buttons
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -24, 0, 34)
TabBar.Position = UDim2.new(0, 12, 0, 50)
TabBar.BackgroundColor3 = THEME.Card
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabBar

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -24, 1, -96)
ContentFrame.Position = UDim2.new(0, 12, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Tabs = {}
local TabButtons = {}

local function createTab(tabId, tabName)
    local page = Instance.new("ScrollingFrame")
    page.Name = tabId .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Border
    page.Visible = false
    page.Parent = ContentFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = page

    Tabs[tabId] = page

    local btn = Instance.new("TextButton")
    btn.Name = tabId .. "Btn"
    btn.Size = UDim2.new(0, 76, 1, -6)
    btn.BackgroundColor3 = THEME.Bg
    btn.BackgroundTransparency = 1
    btn.TextColor3 = THEME.TextMuted
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Text = tabName
    btn.AutoButtonColor = false
    btn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for id, tPage in pairs(Tabs) do
            tPage.Visible = (id == tabId)
        end
        for id, tBtn in pairs(TabButtons) do
            local active = (id == tabId)
            tBtn.TextColor3 = active and THEME.Accent or THEME.TextMuted
            tBtn.BackgroundTransparency = active and 0 or 1
        end
    end)

    TabButtons[tabId] = btn
    return page
end

-- UI Builder Helper Functions
local function createToggle(parent, labelText, defaultVal, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = THEME.Card
    card.BorderSizePixel = 0
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = THEME.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = labelText
    lbl.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 48, 0, 24)
    btn.Position = UDim2.new(1, -58, 0.5, -12)
    btn.BackgroundColor3 = defaultVal and THEME.Green or THEME.Border
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = defaultVal and THEME.Bg or THEME.TextMuted
    btn.Text = defaultVal and "ON" or "OFF"
    btn.AutoButtonColor = false
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    local state = defaultVal
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and THEME.Green or THEME.Border
        btn.TextColor3 = state and THEME.Bg or THEME.TextMuted
        btn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
        saveConfig()
    end)
    return card
end

local function createTextInput(parent, labelText, defaultVal, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = THEME.Card
    card.BorderSizePixel = 0
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.48, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = THEME.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = labelText
    lbl.Parent = card

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.48, -12, 0, 26)
    box.Position = UDim2.new(0.52, 0, 0.5, -13)
    box.BackgroundColor3 = THEME.Bg
    box.TextColor3 = THEME.Accent
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 12
    box.Text = tostring(defaultVal or "")
    box.ClearTextOnFocus = false
    box.Parent = card

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box

    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
        saveConfig()
    end)
    return card
end

local function createSectionHeader(parent, headerText, subtitle)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, subtitle and 38 or 28)
    header.BackgroundColor3 = THEME.Card
    header.BorderSizePixel = 0
    header.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = header

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, subtitle and 4 or 5)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = THEME.Accent
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = headerText
    lbl.Parent = header

    if subtitle then
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -16, 0, 14)
        sub.Position = UDim2.new(0, 10, 0, 20)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 10
        sub.TextColor3 = THEME.TextMuted
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Text = subtitle
        sub.Parent = header
    end

    return header
end

local function createButton(parent, labelText, btnColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = btnColor or THEME.Accent
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.Bg
    btn.Text = labelText
    btn.AutoButtonColor = true
    btn.ZIndex = 15
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local lastClick = 0
    local function trigger()
        if tick() - lastClick < 0.4 then return end
        lastClick = tick()
        if callback then callback() end
    end

    btn.MouseButton1Click:Connect(trigger)
    btn.Activated:Connect(trigger)
    return btn
end

-- Server Hop & Hybrid Cloud Collector Queue Engine (Sender VPS <-> Receiver PC 1-by-1)
local isHopping = false
local lastHopAttemptTime = 0
local lastTargetJobId = nil
local lastQueueLogTime = 0
local isTeleportQueued = false
local lastCloudHeartbeatTime = 0
local lastBroadcastedJobId = nil
local lastBroadcastedState = nil
local lastAcceptRequestTime = 0
local lastTradeEndedTime = 0
local lastCloudFetchTime = 0
local cachedCloudQueue = {} -- Cache in-memory agar jika ntfy.sh kena limit HTTP 429 sesaat, antrean tidak hilang/kosong!
local completedSessionJobIds = {} -- Memory guard hanya untuk JobId yang gagal dimasuki / sudah 100% bersih semua bot-nya
local completedSessionSenders = {} -- Memory guard per-username agar jika 1 JobId ada >1 bot, bot lain di JobId sama tidak ikut terhapus!

local function getHttpRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
end

local function getCloudQueueTopic()
    local rec = tostring(Config.Receiver or "default"):lower():gsub("[^a-z0-9_]", "")
    if rec == "" then rec = "default" end
    -- Gunakan prefix unik berdasarkan Receiver & 8 karakter pertama API Key (jika ada) agar channel privat untuk Anda sendiri
    local keyHash = "v1"
    pcall(function()
        local k = Config["Auto Change"] and Config["Auto Change"].Farmerv5 and Config["Auto Change"].Farmerv5["API Key"]
        if k and #k >= 10 then
            keyHash = tostring(k):sub(4, 11):lower():gsub("[^a-z0-9]", "")
        end
    end)
    return "dh_col_" .. rec .. "_" .. keyHash
end

local function readLocalSenderQueue()
    ensureFolderExists()
    local q = {}
    pcall(function()
        if isfile and isfile(SENDER_QUEUE_FILE) and readfile then
            local raw = readfile(SENDER_QUEUE_FILE)
            if raw and #raw > 2 then
                local decoded = HttpService:JSONDecode(raw)
                if type(decoded) == "table" then
                    q = decoded
                end
            end
        end
    end)
    return q
end

local function writeLocalSenderQueue(q)
    ensureFolderExists()
    pcall(function()
        if writefile then
            local encoded = HttpService:JSONEncode(q or {})
            writefile(SENDER_QUEUE_FILE, encoded)
        end
    end)
end

local DEFAULT_QUEUE_SERVER_URL = "https://dimsong.online"
local DUCKHUB_HANDSHAKE_SIGNATURE = "DUCKHUB_V2_VERIFIED"

local function getTargetReceiverName()
    local r = tostring((Config and Config.Receiver) or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if r == "" and LocalPlayer then
        r = tostring(LocalPlayer.Name)
    end
    return r
end

local function isEntryForThisReceiver(entry)
    if type(entry) ~= "table" then return false end
    local myRec = getTargetReceiverName():lower()
    if myRec == "" then return true end
    local entryRec = tostring(entry.Receiver or entry.receiver or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
    -- Jika entri menyertakan variabel Receiver, wajib cocok dengan Receiver kita!
    if entryRec ~= "" then
        return entryRec == myRec or (LocalPlayer and entryRec == tostring(LocalPlayer.Name):lower())
    end
    return true
end

local function getCustomQueueServerUrl()
    local u = Config and Config.Hop and Config.Hop["Queue Server URL"]
    if type(u) == "string" then
        u = u:gsub("^%s+", ""):gsub("%s+$", ""):gsub("/+$", "")
        if #u > 4 and (u:sub(1, 7) == "http://" or u:sub(1, 8) == "https://") then
            return u
        end
    end
    return DEFAULT_QUEUE_SERVER_URL
end

local function postCloudQueueEvent(payloadTable)
    local reqFn = getHttpRequestFn()
    if not reqFn then return false end
    if type(payloadTable) == "table" then
        if not payloadTable.receiver then
            payloadTable.receiver = getTargetReceiverName()
        end
        if not payloadTable.handshake then
            payloadTable.handshake = DUCKHUB_HANDSHAKE_SIGNATURE
        end
    end
    local customUrl = getCustomQueueServerUrl()
    local url
    if customUrl then
        url = customUrl .. "/event"
    else
        url = "https://ntfy.sh/" .. getCloudQueueTopic()
    end
    local ok, res = pcall(function()
        return reqFn({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "Mozilla/5.0"
            },
            Body = HttpService:JSONEncode(payloadTable)
        })
    end)
    return ok and res ~= nil
end

local function fetchCloudSenderQueue()
    local customUrl = getCustomQueueServerUrl()

    -- Jika memakai Custom HTTP Server sendiri (https://dimsong.online), langsung GET /queue?receiver=<nama_receiver>
    if customUrl then
        local targetRec = getTargetReceiverName()
        local url = customUrl .. "/queue?receiver=" .. HttpService:UrlEncode(targetRec)
        local rawBody = nil
        local reqFn = getHttpRequestFn()
        if reqFn then
            pcall(function()
                local res = reqFn({
                    Url = url,
                    Method = "GET",
                    Headers = { ["User-Agent"] = "Mozilla/5.0" }
                })
                if res and (tonumber(res.StatusCode or res.Status) == 200) then
                    rawBody = res.Body or res.body
                end
            end)
        end
        if not rawBody then
            pcall(function()
                rawBody = game:HttpGet(url)
            end)
        end
        if rawBody and #rawBody > 2 then
            pcall(function()
                local decoded = HttpService:JSONDecode(rawBody)
                if type(decoded) == "table" and type(decoded.queue) == "table" then
                    local cleanQ = {}
                    for uname, entry in pairs(decoded.queue) do
                        local doneSenderAt = completedSessionSenders[tostring(uname):lower()]
                        if isEntryForThisReceiver(entry) and not (doneSenderAt and (os.time() - doneSenderAt <= 45)) then
                            cleanQ[uname] = entry
                        end
                    end
                    cachedCloudQueue = cleanQ
                end
            end)
        end
        if next(cachedCloudQueue) ~= nil or (tick() - lastCloudFetchTime < 15.0) then
            return cachedCloudQueue
        end
    end

    -- Fallback / Bridge ntfy.sh (untuk sesi bot lama yang belum re-execute): jangan GET lebih cepat dari 15 detik sekali
    if (tick() - lastCloudFetchTime < 15.0) and next(cachedCloudQueue) ~= nil then
        return cachedCloudQueue
    end
    lastCloudFetchTime = tick()

    local topic = getCloudQueueTopic()
    local url = "https://ntfy.sh/" .. topic .. "/json?poll=1&since=5m"
    local rawBody = nil
    local statusCode = 0

    local reqFn = getHttpRequestFn()
    if reqFn then
        pcall(function()
            local res = reqFn({
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0" }
            })
            if res then
                statusCode = tonumber(res.StatusCode or res.Status) or 0
                if statusCode == 200 then
                    rawBody = res.Body or res.body
                end
            end
        end)
    end

    if not rawBody and statusCode ~= 429 then
        pcall(function()
            rawBody = game:HttpGet(url)
        end)
    end

    -- Jika terkena HTTP 429 (rate limit ntfy.sh) atau gagal jaringan sementara, pertahankan cachedCloudQueue!
    if not rawBody then
        return cachedCloudQueue
    end

    local cloudQueue = {}
    if #rawBody > 0 then
        local events = {}
        for line in tostring(rawBody):gmatch("[^\r\n]+") do
            pcall(function()
                local env = HttpService:JSONDecode(line)
                if env and env.event == "message" and type(env.message) == "string" then
                    local data = HttpService:JSONDecode(env.message)
                    if type(data) == "table" and data.action then
                        data._serverTime = tonumber(env.time) or os.time()
                        table.insert(events, data)
                    end
                end
            end)
        end

        -- Urutkan event secara kronologis
        table.sort(events, function(a, b)
            local ta = tonumber(a._serverTime) or 0
            local tb = tonumber(b._serverTime) or 0
            if ta == tb then
                return (tonumber(a.seq) or 0) < (tonumber(b.seq) or 0)
            end
            return ta < tb
        end)

        local nowServer = os.time()
        if #events > 0 then
            nowServer = tonumber(events[#events]._serverTime) or os.time()
        end

        for _, ev in ipairs(events) do
            local act = tostring(ev.action)
            local uname = tostring(ev.username or "")
            local jid = tostring(ev.jobId or "")

            if act == "CLEAR_ALL" then
                if isEntryForThisReceiver(ev) then
                    cloudQueue = {}
                end
            elseif act == "EMPTY" then
                if uname ~= "" then
                    -- Hapus HANYA akun bot yang sudah kosong ini! Bot lain di JobId yang sama tetap aman di antrean!
                    cloudQueue[uname] = nil
                elseif jid ~= "" then
                    -- Hanya jika event EMPTY tidak menyebut username (misal JobId error/mati), baru hapus berdasarkan JobId
                    completedSessionJobIds[jid] = os.time()
                    for k, v in pairs(cloudQueue) do
                        if tostring(v.JobId) == jid then
                            cloudQueue[k] = nil
                        end
                    end
                end
            elseif act == "READY" and uname ~= "" and jid ~= "" then
                -- Cek apakah akun bot spesifik ini baru saja selesai di sisi lokal Receiver (< 45 detik lalu) & cocok dengan Receiver kita
                local doneSenderAt = completedSessionSenders[uname:lower()]
                if isEntryForThisReceiver(ev) and (not doneSenderAt or (os.time() - doneSenderAt > 45)) then
                    -- Jika ada bot aktif di JobId ini, buka kunci JobId agar tidak terblokir
                    completedSessionJobIds[jid] = nil
                    local prev = cloudQueue[uname]
                    cloudQueue[uname] = {
                        Username = uname,
                        Receiver = tostring(ev.receiver or getTargetReceiverName()),
                        JobId = jid,
                        PlaceId = tonumber(ev.placeId) or game.PlaceId,
                        Players = tonumber(ev.players) or 1,
                        MaxPlayers = tonumber(ev.maxPlayers) or 9,
                        HasItems = true,
                        RegisteredAt = (prev and tonumber(prev.RegisteredAt)) or tonumber(ev._serverTime) or os.time(),
                        LastSeen = tonumber(ev._serverTime) or os.time(),
                        _nowRef = nowServer
                    }
                end
            end
        end

        -- Bersihkan entri Cloud yang sudah tidak kirim heartbeat > 180 detik (3 menit)
        for uname, entry in pairs(cloudQueue) do
            local ref = tonumber(entry._nowRef) or os.time()
            if (ref - (tonumber(entry.LastSeen) or 0)) > 180 then
                cloudQueue[uname] = nil
            end
        end
    end

    cachedCloudQueue = cloudQueue
    return cloudQueue
end

local function readCombinedSenderQueue()
    local combined = readLocalSenderQueue()
    local now = os.time()

    for uname, entry in pairs(combined) do
        local doneSenderAt = completedSessionSenders[uname:lower()]
        local isSenderDone = doneSenderAt and (now - doneSenderAt <= 45)
        if type(entry) ~= "table" or not isEntryForThisReceiver(entry) or (now - (tonumber(entry.LastSeen) or 0) > 180) or isSenderDone or completedSessionJobIds[tostring(entry.JobId)] then
            combined[uname] = nil
        end
    end

    local cloud = fetchCloudSenderQueue()
    for uname, entry in pairs(cloud) do
        if isEntryForThisReceiver(entry) then
            combined[uname] = entry
        end
    end

    return combined
end

local function verifyDuckHubHandshake(senderName)
    if not senderName or senderName == "" then return false end
    -- Jika pengguna mematikan fitur Handshake DuckHub Only secara manual di Settings
    if Config and Config.Settings and Config.Settings["Handshake DuckHub Only"] == false then
        return true
    end

    local sLow = tostring(senderName):lower():gsub("^%s+", ""):gsub("%s+$", "")

    -- 1. Cek jika masuk di Whitelist Senders manual
    if Config and type(Config["Whitelist Senders"]) == "table" then
        for _, w in ipairs(Config["Whitelist Senders"]) do
            if tostring(w):lower():gsub("^%s+", ""):gsub("%s+$", "") == sLow then
                return true
            end
        end
    end

    -- 2. Cek di cache antrean aktif (0ms)
    local function checkInMap(mapTbl)
        if type(mapTbl) ~= "table" then return false end
        for uname, entry in pairs(mapTbl) do
            if tostring(uname):lower() == sLow and type(entry) == "table" and isEntryForThisReceiver(entry) then
                local hs = tostring(entry.Handshake or entry.handshake or DUCKHUB_HANDSHAKE_SIGNATURE)
                if hs == DUCKHUB_HANDSHAKE_SIGNATURE then
                    return true
                end
            end
        end
        return false
    end

    if checkInMap(cachedCloudQueue) or checkInMap(readLocalSenderQueue()) then
        return true
    end

    -- 3. Jika belum ada di cache lokal (misal bot baru saja masuk server detik ini), paksa refresh cepat dari dimsong.online
    lastCloudFetchTime = 0
    local freshQ = readCombinedSenderQueue()
    if checkInMap(freshQ) then
        return true
    end

    return false
end

local function removeSenderFromQueue(username, optionalJobId)
    if not username or username == "" then return end
    completedSessionSenders[tostring(username):lower()] = os.time()
    cachedCloudQueue[tostring(username)] = nil
    pcall(function()
        local q = readLocalSenderQueue()
        local jid = optionalJobId or (q[username] and q[username].JobId) or ""
        if q[username] ~= nil then
            q[username] = nil
            writeLocalSenderQueue(q)
        end
        task.spawn(function()
            postCloudQueueEvent({
                action = "EMPTY",
                username = tostring(username),
                receiver = getTargetReceiverName(),
                jobId = tostring(jid),
                seq = tick()
            })
        end)
        print("[DuckHub Collector] Menghapus akun Sender " .. tostring(username) .. " dari Cloud & Local Queue (bot lain di JobId sama tetap aman).")
    end)
end

local function removeJobIdFromQueue(targetJobId)
    if not targetJobId or targetJobId == "" then return end
    completedSessionJobIds[tostring(targetJobId)] = os.time()
    for uname, entry in pairs(cachedCloudQueue) do
        if type(entry) == "table" and tostring(entry.JobId) == tostring(targetJobId) then
            cachedCloudQueue[uname] = nil
        end
    end
    pcall(function()
        local q = readLocalSenderQueue()
        local changed = false
        for uname, entry in pairs(q) do
            if type(entry) == "table" and tostring(entry.JobId) == tostring(targetJobId) then
                q[uname] = nil
                changed = true
            end
        end
        if changed then
            writeLocalSenderQueue(q)
        end
        task.spawn(function()
            postCloudQueueEvent({
                action = "EMPTY",
                username = "",
                receiver = getTargetReceiverName(),
                jobId = tostring(targetJobId),
                seq = tick()
            })
        end)
        print("[DuckHub Collector] Menghapus JobId mati/penuh dari Cloud & Local Queue: " .. tostring(targetJobId))
    end)
end

local function updateSelfInSenderQueue(hasItems, forceCloudNow)
    pcall(function()
        local q = readLocalSenderQueue()
        local now = os.time()
        local targetRec = getTargetReceiverName()

        for uname, entry in pairs(q) do
            if type(entry) ~= "table" or (now - (tonumber(entry.LastSeen) or 0) > 180) then
                q[uname] = nil
            end
        end

        if hasItems then
            local prev = q[LocalPlayer.Name]
            q[LocalPlayer.Name] = {
                Username = LocalPlayer.Name,
                Receiver = targetRec,
                Handshake = DUCKHUB_HANDSHAKE_SIGNATURE,
                JobId = tostring(game.JobId),
                PlaceId = tonumber(game.PlaceId),
                Players = #Players:GetPlayers(),
                MaxPlayers = tonumber(Players.MaxPlayers) or 9,
                HasItems = true,
                RegisteredAt = (type(prev) == "table" and tonumber(prev.RegisteredAt)) or now,
                LastSeen = now
            }
            writeLocalSenderQueue(q)

            -- Kirim heartbeat ke Server Domain Sendiri (https://dimsong.online) setiap 15-20 detik (bebas limit!)
            local hbInterval = 15 + ((tonumber(LocalPlayer.UserId) or 0) % 6)
            local shouldPostCloud = forceCloudNow
                or (lastBroadcastedState ~= "READY")
                or (lastBroadcastedJobId ~= tostring(game.JobId))
                or (tick() - lastCloudHeartbeatTime >= hbInterval)

            if shouldPostCloud then
                lastCloudHeartbeatTime = tick()
                lastBroadcastedJobId = tostring(game.JobId)
                lastBroadcastedState = "READY"
                task.spawn(function()
                    postCloudQueueEvent({
                        action = "READY",
                        username = LocalPlayer.Name,
                        receiver = targetRec,
                        handshake = DUCKHUB_HANDSHAKE_SIGNATURE,
                        jobId = tostring(game.JobId),
                        placeId = tonumber(game.PlaceId),
                        players = #Players:GetPlayers(),
                        maxPlayers = tonumber(Players.MaxPlayers) or 9,
                        seq = tick()
                    })
                end)
            end
        else
            -- Jika sudah kosong, langsung hapus akun ini dari Local & Cloud Queue!
            q[LocalPlayer.Name] = nil
            writeLocalSenderQueue(q)

            if lastBroadcastedState == "READY" or forceCloudNow then
                lastBroadcastedState = "EMPTY"
                -- Kirim secara sinkron (blocking singkat) agar sebelum game:Shutdown() sinyal hapus sudah masuk ke Cloud!
                postCloudQueueEvent({
                    action = "EMPTY",
                    username = LocalPlayer.Name,
                    receiver = targetRec,
                    jobId = tostring(game.JobId),
                    seq = tick()
                })
            end
        end
    end)
end

local function getNextWaitingSender()
    local q = readCombinedSenderQueue()
    local candidates = {}

    for uname, entry in pairs(q) do
        if type(entry) == "table" and entry.HasItems and entry.JobId and entry.JobId ~= "" and isEntryForThisReceiver(entry) then
            local jid = tostring(entry.JobId)
            if uname:lower() ~= LocalPlayer.Name:lower() and jid ~= tostring(game.JobId) and not completedSessionJobIds[jid] then
                table.insert(candidates, entry)
            end
        end
    end

    -- Urutkan 1 per 1 berdasarkan urutan masuk antrean (FIFO)
    table.sort(candidates, function(a, b)
        local regA = tonumber(a.RegisteredAt) or 0
        local regB = tonumber(b.RegisteredAt) or 0
        if regA == regB then
            return tostring(a.Username) < tostring(b.Username)
        end
        return regA < regB
    end)

    return candidates[1], #candidates
end

local function queueCollectorOnTeleport()
    if isTeleportQueued then return end
    pcall(function()
        local qot = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if qot then
            isTeleportQueued = true
            qot([[
                repeat task.wait() until game:IsLoaded()
                if isfile and loadfile and isfile("duckhub_collector.lua") then
                    loadfile("duckhub_collector.lua")()
                elseif isfile and loadfile and isfile("DuckHub/duckhub_collector.lua") then
                    loadfile("DuckHub/duckhub_collector.lua")()
                else
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/dhimsongkang/script-gacor-dimsongkang/main/Anime%20Dice/duckhub_collector.lua?t=" .. tostring(tick())))()
                end
            ]])
        end
    end)
end

pcall(function()
    InstanceManager:AddConnection(TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        if player == LocalPlayer then
            isHopping = false
            addLog("Teleport gagal (" .. tostring(teleportResult) .. "): " .. tostring(errorMessage), THEME.Rose)
            if lastTargetJobId then
                removeJobIdFromQueue(lastTargetJobId)
                lastTargetJobId = nil
            end
        end
    end))
end)

local function hopToLowestServer(isForced)
    if isHopping and not isForced and (tick() - lastHopAttemptTime < 15) then
        addLog("Server hop sedang berjalan, mohon tunggu...", THEME.Yellow)
        return
    end
    isHopping = true
    lastHopAttemptTime = tick()
    addLog("Mencari server paling sepi (pemain paling sedikit)...", THEME.Accent)

    task.spawn(function()
        local targetServerId = nil
        local targetPlaying = 0
        local targetPing = 0
        local ok, err = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local raw = game:HttpGet(url)
            local x = HttpService:JSONDecode(raw)
            if x and x.data then
                local candidates = {}
                for _, s in ipairs(x.data) do
                    if s.id ~= game.JobId and s.playing and s.playing > 0 and s.playing < (s.maxPlayers - 2) then
                        table.insert(candidates, s)
                    end
                end

                table.sort(candidates, function(a, b)
                    if a.playing == b.playing then
                        local pingA = a.ping or 999
                        local pingB = b.ping or 999
                        return pingA < pingB
                    end
                    return a.playing < b.playing
                end)

                if #candidates > 0 then
                    -- Pilih acak dari 15 server paling sepi agar banyak bot di VPS tidak menumpuk ke 1 server yang sama!
                    local pickIdx = math.random(1, math.min(15, #candidates))
                    targetServerId = candidates[pickIdx].id
                    targetPlaying = candidates[pickIdx].playing
                    targetPing = candidates[pickIdx].ping or 0
                end
            end
        end)

        if not ok then
            addLog("Gagal query server list (" .. tostring(err) .. "). Menggunakan random hop...", THEME.Yellow)
        end

        queueCollectorOnTeleport()

        if targetServerId then
            addLog(string.format("Berpindah ke server sepi (%d/%d pemain, %d ms): %s...", targetPlaying, Players.MaxPlayers, targetPing, string.sub(targetServerId, 1, 8)), THEME.Cyan)
            local tpOk, tpErr = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, LocalPlayer)
            end)
            if not tpOk then
                addLog("Gagal teleport instance (" .. tostring(tpErr) .. "). Mencoba random hop...", THEME.Yellow)
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
        else
            addLog("Tidak menemukan server sepi via list. Menggunakan random teleport...", THEME.Yellow)
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end

        task.wait(10)
        isHopping = false
    end)
end

local function copyServerLink()
    local placeId = tostring(game.PlaceId)
    local jobId = tostring(game.JobId)
    local joinLink = "https://www.roblox.com/games/" .. placeId .. "?gameInstanceId=" .. jobId
    local deepLink = "roblox://experiences/start?placeId=" .. placeId .. "&gameInstanceId=" .. jobId

    local copied = false
    pcall(function()
        local setclip = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
        if setclip then
            setclip(joinLink)
            copied = true
        end
    end)

    pcall(function()
        if writefile then
            writefile("DuckHub/Server_Link.txt", joinLink)
        end
    end)

    if copied then
        addLog("Link Server Public berhasil disalin ke Clipboard!", THEME.Green)
    else
        addLog("Link Server disimpan ke DuckHub/Server_Link.txt!", THEME.Green)
    end
    print("[DuckHub] Public Server Link:", joinLink)
    print("[DuckHub] Deep Link (roblox://):", deepLink)
end

-- ====================================================================
-- 3.5 Multi-Layer Anti-AFK System (Pure Silent Keep-Alive from HipHub)
-- ====================================================================
local function purgeGameAfkScript()
    pcall(function()
        local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        if ps then
            for _, ch in ipairs(ps:GetChildren()) do
                if ch:IsA("LocalScript") and (ch.Name == "AFK" or string.find(string.lower(ch.Name), "afk")) then
                    ch:Destroy()
                end
            end
        end
    end)
end

local function hookTeleportAndKick()
    pcall(function()
        if typeof(hookfunction) == "function" then
            pcall(function()
                local oldTeleport
                oldTeleport = hookfunction(TeleportService.Teleport, function(self, placeId, ...)
                    if Config.Settings and Config.Settings["Anti AFK"] and self == TeleportService and (placeId == game.PlaceId or placeId == nil) then
                        return nil
                    end
                    return oldTeleport(self, placeId, ...)
                end)
            end)
            pcall(function()
                local oldKick
                oldKick = hookfunction(LocalPlayer.Kick, function(self, message, ...)
                    if Config.Settings and Config.Settings["Anti AFK"] and self == LocalPlayer then
                        local msg = tostring(message or ""):lower()
                        if msg:find("afk") or msg:find("idle") or msg:find("inactive") or msg == "" then
                            return nil
                        end
                    end
                    return oldKick(self, message, ...)
                end)
            end)
        end
    end)

    pcall(function()
        if typeof(hookmetamethod) == "function" then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if Config.Settings and Config.Settings["Anti AFK"] then
                    if method == "Teleport" and self == TeleportService then
                        local args = { ... }
                        if args[1] == game.PlaceId or args[1] == nil then
                            return nil
                        end
                    elseif (method == "Kick" or method == "kick") and self == LocalPlayer then
                        local args = { ... }
                        local msg = tostring(args[1] or ""):lower()
                        if msg:find("afk") or msg:find("idle") or msg:find("inactive") or msg == "" then
                            return nil
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        end
    end)
end

pcall(hookTeleportAndKick)

local function disableIdleConnections()
    pcall(function()
        local getconns = rawget(_G, "getconnections") or rawget(_G, "get_signal_cons")
            or (type(getconnections) == "function" and getconnections)

        if getconns and LocalPlayer then
            for _, conn in pairs(getconns(LocalPlayer.Idled)) do
                pcall(function()
                    if conn.Disable then
                        conn:Disable()
                    elseif conn.Disconnect then
                        conn:Disconnect()
                    end
                    if conn.Enabled ~= nil then
                        conn.Enabled = false
                    end
                end)
            end
        end
    end)
end

local function runAntiAfkCycle()
    purgeGameAfkScript()
    disableIdleConnections()
end

local function applyAntiAfkState(enabled)
    if enabled then
        pcall(function() LocalPlayer:SetAttribute("AntiAfkIdleOverride", 99999999) end)
        runAntiAfkCycle()
    else
        pcall(function() LocalPlayer:SetAttribute("AntiAfkIdleOverride", nil) end)
    end
end

if Config.Settings and Config.Settings["Anti AFK"] then
    applyAntiAfkState(true)
end

-- Listener Idled event: Reset idle counter & VirtualUser fallback
InstanceManager:AddConnection(LocalPlayer.Idled:Connect(function()
    if Config.Settings and Config.Settings["Anti AFK"] then
        runAntiAfkCycle()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
        addLog("Anti-AFK: Berhasil mereset status idle (Keep-Alive).", THEME.TextSecondary)
    end
end))

-- Watchdog script AFK yang di-insert runtime
pcall(function()
    local ps = LocalPlayer:WaitForChild("PlayerScripts", 10)
    if ps then
        InstanceManager:AddConnection(ps.ChildAdded:Connect(function(child)
            if Config.Settings and Config.Settings["Anti AFK"] and child:IsA("LocalScript") and (child.Name == "AFK" or string.find(string.lower(child.Name), "afk")) then
                task.defer(function()
                    pcall(function() child:Destroy() end)
                end)
            end
        end))
    end
end)

-- Background loop keep-alive cycle setiap 15 detik
InstanceManager:Spawn(function()
    while InstanceManager.IsAlive and task.wait(15) do
        if Config.Settings and Config.Settings["Anti AFK"] then
            runAntiAfkCycle()
        end
    end
end)

-- ====================================================================
-- 4. Population of UI Tabs
-- ====================================================================
local DashTab = createTab("Dash", "Dashboard")
local UnitsTab = createTab("Units", "Units")
local TokensTab = createTab("Tokens", "Tokens/Spins")
local PotionsTab = createTab("Potions", "Potions")
local GearTab = createTab("Gear", "Gear")
local SettingsTab = createTab("Settings", "Settings/Hop")
local LogsTab = createTab("Logs", "Logs")

-- 4.1 Dashboard Tab
do
    local roleBanner = Instance.new("Frame")
    roleBanner.Size = UDim2.new(1, 0, 0, 48)
    roleBanner.BackgroundColor3 = THEME.Card
    roleBanner.Parent = DashTab

    local bannerCorner = Instance.new("UICorner")
    bannerCorner.CornerRadius = UDim.new(0, 6)
    bannerCorner.Parent = roleBanner

    local bannerText = Instance.new("TextLabel")
    bannerText.Size = UDim2.new(1, -20, 1, 0)
    bannerText.Position = UDim2.new(0, 12, 0, 0)
    bannerText.BackgroundTransparency = 1
    bannerText.Font = Enum.Font.GothamMedium
    bannerText.TextSize = 13
    bannerText.TextColor3 = THEME.Text
    bannerText.TextXAlignment = Enum.TextXAlignment.Left
    bannerText.Text = string.format("Akun Ini: %s | Role: %s\nTarget Receiver: %s", LocalPlayer.Name, getRole(), Config.Receiver)
    bannerText.Parent = roleBanner

    createToggle(DashTab, "Master Auto Trade (Aktifkan Bot)", Config.Enabled, function(val)
        Config.Enabled = val
        PillDot.BackgroundColor3 = val and THEME.Green or THEME.Red
    end)

    createTextInput(DashTab, "Receiver Username (Penerima)", Config.Receiver, function(val)
        Config.Receiver = val
        bannerText.Text = string.format("Akun Ini: %s | Role: %s\nTarget Receiver: %s", LocalPlayer.Name, getRole(), Config.Receiver)
        StatusBadge.Text = getRole():upper() .. " [IDLE]"
    end)

    createToggle(DashTab, "Accept Any Sender (Terima dari Siapa Saja)", Config["Accept Any Sender"], function(val)
        Config["Accept Any Sender"] = val
    end)

    createToggle(DashTab, "Auto Loop Trade (Otomatis Loop Kirim/Terima)", Config.Settings["Auto Loop Trade"], function(val)
        Config.Settings["Auto Loop Trade"] = val
    end)

    createButton(DashTab, "📋 Salin Link Server Public (Copy Server Link)", THEME.Green, function()
        copyServerLink()
    end)
end

-- 4.2 Units Tab
do
    createToggle(UnitsTab, "Units Auto-Trade Enabled", Config.Units.Enabled, function(val)
        Config.Units.Enabled = val
        saveConfig()
    end)

    createToggle(UnitsTab, "Keep Equipped Units (Simpan Unit Terpakai)", Config.Units["Keep Equipped"], function(val)
        Config.Units["Keep Equipped"] = val
        saveConfig()
    end)

    createToggle(UnitsTab, "Keep Locked Units (Simpan Unit Terkunci)", Config.Units["Keep Locked"], function(val)
        Config.Units["Keep Locked"] = val
        saveConfig()
    end)

    createToggle(UnitsTab, "Keep Tower Team (Simpan Tim Tower)", Config.Units["Keep Tower Team"] ~= false, function(val)
        Config.Units["Keep Tower Team"] = val
        saveConfig()
    end)

    createSectionHeader(UnitsTab, "⭐ FILTER RARITY UNIT", "Pilih rarity unit yang akan ditransfer ke Receiver")

    local rarities = {
        "Common", "Uncommon", "Rare", "Epic", "Legendary",
        "Mythical", "Divine", "Celestial", "Exotic",
        "Secret I", "Secret II", "Heavenly", "Galactic", "Cosmic", "Exclusive"
    }
    for _, r in ipairs(rarities) do
        local isEnabled = Config.Units.Rarities and Config.Units.Rarities[r] == true
        createToggle(UnitsTab, "Transfer: " .. r, isEnabled, function(val)
            if not Config.Units.Rarities then Config.Units.Rarities = {} end
            Config.Units.Rarities[r] = val
            saveConfig()
        end)
    end
end

-- 4.3 Tokens & Spins Tab
do
    createToggle(TokensTab, "Transfer Gems", Config.Tokens.Gems.Enabled, function(val)
        Config.Tokens.Gems.Enabled = val
        saveConfig()
    end)
    createTextInput(TokensTab, "Gems Keep Amount (Sisa Disimpan)", Config.Tokens.Gems["Keep Amount"], function(val)
        Config.Tokens.Gems["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createToggle(TokensTab, "Transfer Trait Rerolls", Config.Tokens["Trait Reroll"].Enabled, function(val)
        Config.Tokens["Trait Reroll"].Enabled = val
        saveConfig()
    end)
    createTextInput(TokensTab, "Trait Reroll Keep Amount", Config.Tokens["Trait Reroll"]["Keep Amount"], function(val)
        Config.Tokens["Trait Reroll"]["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createToggle(TokensTab, "Transfer Reset Tokens (Quest)", (Config.Tokens["Reset Token"] and Config.Tokens["Reset Token"].Enabled ~= false), function(val)
        if not Config.Tokens["Reset Token"] then Config.Tokens["Reset Token"] = { ["Enabled"] = true, ["Keep Amount"] = 0 } end
        Config.Tokens["Reset Token"].Enabled = val
        saveConfig()
    end)
    createTextInput(TokensTab, "Reset Token Keep Amount", (Config.Tokens["Reset Token"] and Config.Tokens["Reset Token"]["Keep Amount"]) or 0, function(val)
        if not Config.Tokens["Reset Token"] then Config.Tokens["Reset Token"] = { ["Enabled"] = true, ["Keep Amount"] = 0 } end
        Config.Tokens["Reset Token"]["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createToggle(TokensTab, "Transfer Lucky Spins", Config.Spins["Lucky Spin"].Enabled, function(val)
        Config.Spins["Lucky Spin"].Enabled = val
        saveConfig()
    end)
    createTextInput(TokensTab, "Lucky Spin Keep Amount", Config.Spins["Lucky Spin"]["Keep Amount"], function(val)
        Config.Spins["Lucky Spin"]["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createToggle(TokensTab, "Transfer Jackpot Spins", Config.Spins["Jackpot Spin"].Enabled, function(val)
        Config.Spins["Jackpot Spin"].Enabled = val
        saveConfig()
    end)
    createTextInput(TokensTab, "Jackpot Spin Keep Amount", Config.Spins["Jackpot Spin"]["Keep Amount"], function(val)
        Config.Spins["Jackpot Spin"]["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createSectionHeader(TokensTab, "🎰 SEMUA JENIS JACKPOT & EVENT SPINS", "Aktifkan transfer untuk varian jackpot dan spin event lainnya")

    local additionalSpins = {
        "Mega Jackpot", "Grand Jackpot", "Daily Jackpot",
        "Pumpkin Spin", "Pumpkin Jackpot", "Witch's Jackpot"
    }
    for _, spinName in ipairs(additionalSpins) do
        local isEn = Config.Spins[spinName] and Config.Spins[spinName].Enabled ~= false
        local keepAmt = (Config.Spins[spinName] and Config.Spins[spinName]["Keep Amount"]) or 0
        createToggle(TokensTab, "Transfer " .. spinName, isEn, function(val)
            if not Config.Spins[spinName] then Config.Spins[spinName] = { ["Enabled"] = true, ["Keep Amount"] = 0 } end
            Config.Spins[spinName].Enabled = val
            saveConfig()
        end)
        createTextInput(TokensTab, spinName .. " Keep Amount", keepAmt, function(val)
            if not Config.Spins[spinName] then Config.Spins[spinName] = { ["Enabled"] = true, ["Keep Amount"] = 0 } end
            Config.Spins[spinName]["Keep Amount"] = tonumber(val) or 0
            saveConfig()
        end)
    end
end

-- 4.4 Potions Tab (Tower Potions / Boosts)
do
    createToggle(PotionsTab, "⚡ Transfer Potions / Boosts (Master Enable)", Config.Boosts.Enabled, function(val)
        Config.Boosts.Enabled = val
        if val then
            addLog("Transfer Potions diaktifkan.", THEME.Green)
        else
            addLog("Transfer Potions dinonaktifkan.", THEME.TextMuted)
        end
    end)

    createTextInput(PotionsTab, "Min Tier Potion (1 = Tier I, 2 = II, 3 = III, 4 = IV)", Config.Boosts["Min Tier"] or 1, function(val)
        Config.Boosts["Min Tier"] = tonumber(val) or 1
    end)

    createTextInput(PotionsTab, "Potion Keep Amount (Sisa Disimpan Tiap Jenis)", Config.Boosts["Keep Amount"] or 0, function(val)
        Config.Boosts["Keep Amount"] = tonumber(val) or 0
    end)

    -- Quick Action Buttons
    local actionRow = Instance.new("Frame")
    actionRow.Size = UDim2.new(1, 0, 0, 32)
    actionRow.BackgroundTransparency = 1
    actionRow.Parent = PotionsTab

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.Parent = actionRow

    local selectAllBtn = Instance.new("TextButton")
    selectAllBtn.Size = UDim2.new(0.5, -4, 1, 0)
    selectAllBtn.BackgroundColor3 = THEME.Cyan
    selectAllBtn.Font = Enum.Font.GothamBold
    selectAllBtn.TextSize = 11
    selectAllBtn.TextColor3 = THEME.Bg
    selectAllBtn.Text = "✅ Centang Semua (Select All)"
    selectAllBtn.AutoButtonColor = false
    selectAllBtn.Parent = actionRow

    local selectAllCorner = Instance.new("UICorner")
    selectAllCorner.CornerRadius = UDim.new(0, 6)
    selectAllCorner.Parent = selectAllBtn

    local deselectAllBtn = Instance.new("TextButton")
    deselectAllBtn.Size = UDim2.new(0.5, -4, 1, 0)
    deselectAllBtn.BackgroundColor3 = THEME.Card
    deselectAllBtn.Font = Enum.Font.GothamBold
    deselectAllBtn.TextSize = 11
    deselectAllBtn.TextColor3 = THEME.TextMuted
    deselectAllBtn.Text = "❌ Hapus Semua (Deselect All)"
    deselectAllBtn.AutoButtonColor = false
    deselectAllBtn.Parent = actionRow

    local deselectAllCorner = Instance.new("UICorner")
    deselectAllCorner.CornerRadius = UDim.new(0, 6)
    deselectAllCorner.Parent = deselectAllBtn

    local potionToggleCallbacks = {}

    selectAllBtn.MouseButton1Click:Connect(function()
        if not Config.Boosts["Selected Categories"] then Config.Boosts["Selected Categories"] = {} end
        for _, cat in ipairs(Config.Boosts.Categories or {}) do
            Config.Boosts["Selected Categories"][cat] = true
            if potionToggleCallbacks[cat] then
                potionToggleCallbacks[cat](true)
            end
        end
        saveConfig()
        addLog("Semua jenis potion tower dicentang (aktif).", THEME.Green)
    end)

    deselectAllBtn.MouseButton1Click:Connect(function()
        if not Config.Boosts["Selected Categories"] then Config.Boosts["Selected Categories"] = {} end
        for _, cat in ipairs(Config.Boosts.Categories or {}) do
            Config.Boosts["Selected Categories"][cat] = false
            if potionToggleCallbacks[cat] then
                potionToggleCallbacks[cat](false)
            end
        end
        saveConfig()
        addLog("Semua pilihan potion tower dikosongkan.", THEME.Yellow)
    end)

    local towerGroups = {
        {
            title = "👑 SOUL TOWER (Godly)",
            subtitle = "Tier I - IV: Soul Luck, Soul Damage, Soul Income",
            potions = { "Soul Luck", "Soul Damage", "Soul Income" }
        },
        {
            title = "🌌 SHADOW TOWER (Abyssal)",
            subtitle = "Tier I - IV: Shadow Luck, Shadow Speed, Shadow Income",
            potions = { "Shadow Luck", "Shadow Speed", "Shadow Income" }
        },
        {
            title = "⚔️ SLAYER TOWER (Nightmare)",
            subtitle = "Tier I - III: Slayer Luck, Slayer Damage, Slayer Income",
            potions = { "Slayer Luck", "Slayer Damage", "Slayer Income" }
        },
        {
            title = "🍃 HIDDEN LEAF TOWER (Extreme)",
            subtitle = "Tier I - III: Leaf Luck, Leaf Damage, Leaf Income",
            potions = { "Leaf Luck", "Leaf Damage", "Leaf Income" }
        },
        {
            title = "🏴‍☠️ PIRATE TOWER (Hard)",
            subtitle = "Tier I - III: Pirate Luck, Pirate Damage, Pirate Income",
            potions = { "Pirate Luck", "Pirate Damage", "Pirate Income" }
        },
        {
            title = "🔮 CURSED TOWER (Medium)",
            subtitle = "Tier I - III: Cursed Luck, Cursed Damage, Cursed Income",
            potions = { "Cursed Luck", "Cursed Damage", "Cursed Income" }
        },
        {
            title = "🐉 DRAGON TOWER (Easy)",
            subtitle = "Tier I - III: Dragon Luck, Dragon Damage, Dragon Income",
            potions = { "Dragon Luck", "Dragon Damage", "Dragon Income" }
        },
        {
            title = "♾️ INFINITY TOWER (Infinity)",
            subtitle = "Tier I - IV: General Luck, Damage, Income",
            potions = { "Luck", "Damage", "Income" }
        },
        {
            title = "🎃 EVENT & HALLOWEEN POTIONS",
            subtitle = "Spooky Luck, Candy Pot, Pumpkin Pot, Haunted Potion",
            potions = { "Spooky Luck", "Candy Pot", "Pumpkin Pot", "Haunted Potion" }
        }
    }

    local function addPotionToggle(parent, catName, displayName)
        local initialVal = true
        if Config.Boosts["Selected Categories"] and Config.Boosts["Selected Categories"][catName] ~= nil then
            initialVal = Config.Boosts["Selected Categories"][catName]
        end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 34)
        card.BackgroundColor3 = THEME.Card
        card.BorderSizePixel = 0
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = displayName or ("Transfer " .. catName)
        lbl.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 22)
        btn.Position = UDim2.new(1, -58, 0.5, -11)
        btn.BackgroundColor3 = initialVal and THEME.Green or THEME.Border
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextColor3 = initialVal and THEME.Bg or THEME.TextMuted
        btn.Text = initialVal and "ON" or "OFF"
        btn.AutoButtonColor = false
        btn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 11)
        btnCorner.Parent = btn

        local curState = initialVal
        local function setVisualState(newState)
            curState = newState
            btn.BackgroundColor3 = curState and THEME.Green or THEME.Border
            btn.TextColor3 = curState and THEME.Bg or THEME.TextMuted
            btn.Text = curState and "ON" or "OFF"
        end

        potionToggleCallbacks[catName] = setVisualState

        btn.MouseButton1Click:Connect(function()
            curState = not curState
            setVisualState(curState)
            if not Config.Boosts["Selected Categories"] then
                Config.Boosts["Selected Categories"] = {}
            end
            Config.Boosts["Selected Categories"][catName] = curState
            saveConfig()
        end)
    end

    for _, group in ipairs(towerGroups) do
        createSectionHeader(PotionsTab, group.title, group.subtitle)
        for _, pCat in ipairs(group.potions) do
            addPotionToggle(PotionsTab, pCat, "Transfer " .. pCat)
        end
    end
end

-- 4.5 Gear Tab
do
    createToggle(GearTab, "⚡ Transfer Gear (Master Enable)", Config.Gear.Enabled, function(val)
        Config.Gear.Enabled = val
        if val then
            addLog("Transfer Gear diaktifkan.", THEME.Green)
        else
            addLog("Transfer Gear dinonaktifkan.", THEME.TextMuted)
        end
        saveConfig()
    end)

    createToggle(GearTab, "🛡️ Keep Equipped Gear (Jangan Trade Gear yang Dipakai)", Config.Gear["Keep Equipped"], function(val)
        Config.Gear["Keep Equipped"] = val
        saveConfig()
    end)

    createTextInput(GearTab, "Keep Amount (Sisakan Tiap Gear di Tas)", Config.Gear["Keep Amount"] or 0, function(val)
        Config.Gear["Keep Amount"] = tonumber(val) or 0
        saveConfig()
    end)

    createSectionHeader(GearTab, "⭐ FILTER GEAR BERDASARKAN RARITY", "Aktifkan/nonaktifkan rarity gear yang ingin ditransfer")

    local gearRarityCallbacks = {}
    local function addGearRarityToggle(parent, rarityName)
        local initialVal = true
        if Config.Gear.Rarities and Config.Gear.Rarities[rarityName] ~= nil then
            initialVal = Config.Gear.Rarities[rarityName]
        end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 34)
        card.BackgroundColor3 = THEME.Card
        card.BorderSizePixel = 0
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = "Transfer Rarity: " .. rarityName
        lbl.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 22)
        btn.Position = UDim2.new(1, -58, 0.5, -11)
        btn.BackgroundColor3 = initialVal and THEME.Green or THEME.Border
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextColor3 = initialVal and THEME.Bg or THEME.TextMuted
        btn.Text = initialVal and "ON" or "OFF"
        btn.AutoButtonColor = false
        btn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 11)
        btnCorner.Parent = btn

        local curState = initialVal
        local function setVisualState(newState)
            curState = newState
            btn.BackgroundColor3 = curState and THEME.Green or THEME.Border
            btn.TextColor3 = curState and THEME.Bg or THEME.TextMuted
            btn.Text = curState and "ON" or "OFF"
        end

        gearRarityCallbacks[rarityName] = setVisualState

        btn.MouseButton1Click:Connect(function()
            curState = not curState
            setVisualState(curState)
            if not Config.Gear.Rarities then Config.Gear.Rarities = {} end
            Config.Gear.Rarities[rarityName] = curState
            saveConfig()
        end)
    end

    for _, rName in ipairs({ "Divine", "Haunted", "Legendary", "Rare" }) do
        addGearRarityToggle(GearTab, rName)
    end

    createSectionHeader(GearTab, "🎽 FILTER GEAR BERDASARKAN SLOT", "Aktifkan/nonaktifkan slot gear yang ingin ditransfer")

    local gearSlotCallbacks = {}
    local function addGearSlotToggle(parent, slotName)
        local initialVal = true
        if Config.Gear.Slots and Config.Gear.Slots[slotName] ~= nil then
            initialVal = Config.Gear.Slots[slotName]
        end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 34)
        card.BackgroundColor3 = THEME.Card
        card.BorderSizePixel = 0
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = "Transfer Slot: " .. slotName
        lbl.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 22)
        btn.Position = UDim2.new(1, -58, 0.5, -11)
        btn.BackgroundColor3 = initialVal and THEME.Green or THEME.Border
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextColor3 = initialVal and THEME.Bg or THEME.TextMuted
        btn.Text = initialVal and "ON" or "OFF"
        btn.AutoButtonColor = false
        btn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 11)
        btnCorner.Parent = btn

        local curState = initialVal
        local function setVisualState(newState)
            curState = newState
            btn.BackgroundColor3 = curState and THEME.Green or THEME.Border
            btn.TextColor3 = curState and THEME.Bg or THEME.TextMuted
            btn.Text = curState and "ON" or "OFF"
        end

        gearSlotCallbacks[slotName] = setVisualState

        btn.MouseButton1Click:Connect(function()
            curState = not curState
            setVisualState(curState)
            if not Config.Gear.Slots then Config.Gear.Slots = {} end
            Config.Gear.Slots[slotName] = curState
            saveConfig()
        end)
    end

    for _, sName in ipairs({ "Back", "Head", "Torso", "Upper", "Waist" }) do
        addGearSlotToggle(GearTab, sName)
    end

    -- Quick Action Buttons for Gears
    local gearActionsFrame = Instance.new("Frame")
    gearActionsFrame.Size = UDim2.new(1, 0, 0, 36)
    gearActionsFrame.BackgroundTransparency = 1
    gearActionsFrame.Parent = GearTab

    local gearActionsLayout = Instance.new("UIListLayout")
    gearActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    gearActionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gearActionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    gearActionsLayout.Padding = UDim.new(0, 10)
    gearActionsLayout.Parent = gearActionsFrame

    local selectAllGearBtn = Instance.new("TextButton")
    selectAllGearBtn.Size = UDim2.new(0.5, -5, 1, 0)
    selectAllGearBtn.BackgroundColor3 = THEME.Card
    selectAllGearBtn.Font = Enum.Font.GothamBold
    selectAllGearBtn.TextSize = 11
    selectAllGearBtn.TextColor3 = THEME.Green
    selectAllGearBtn.Text = "✅ Select All Gears"
    selectAllGearBtn.AutoButtonColor = false
    selectAllGearBtn.Parent = gearActionsFrame
    local sagCorner = Instance.new("UICorner")
    sagCorner.CornerRadius = UDim.new(0, 6)
    sagCorner.Parent = selectAllGearBtn

    local deselectAllGearBtn = Instance.new("TextButton")
    deselectAllGearBtn.Size = UDim2.new(0.5, -5, 1, 0)
    deselectAllGearBtn.BackgroundColor3 = THEME.Card
    deselectAllGearBtn.Font = Enum.Font.GothamBold
    deselectAllGearBtn.TextSize = 11
    deselectAllGearBtn.TextColor3 = THEME.Red
    deselectAllGearBtn.Text = "❌ Deselect All Gears"
    deselectAllGearBtn.AutoButtonColor = false
    deselectAllGearBtn.Parent = gearActionsFrame
    local dagCorner = Instance.new("UICorner")
    dagCorner.CornerRadius = UDim.new(0, 6)
    dagCorner.Parent = deselectAllGearBtn

    local individualGearCallbacks = {}

    selectAllGearBtn.MouseButton1Click:Connect(function()
        if not Config.Gear["Selected Gears"] then Config.Gear["Selected Gears"] = {} end
        for gName, cb in pairs(individualGearCallbacks) do
            Config.Gear["Selected Gears"][gName] = true
            cb(true)
        end
        saveConfig()
        addLog("Semua individual gear di-select.", THEME.Green)
    end)

    deselectAllGearBtn.MouseButton1Click:Connect(function()
        if not Config.Gear["Selected Gears"] then Config.Gear["Selected Gears"] = {} end
        for gName, cb in pairs(individualGearCallbacks) do
            Config.Gear["Selected Gears"][gName] = false
            cb(false)
        end
        saveConfig()
        addLog("Semua individual gear di-deselect.", THEME.Red)
    end)

    local gearGroups = {
        {
            slot = "Back",
            title = "🎒 SLOT: BACK (Punggung)",
            subtitle = "Enol's Drums, Reaper's Scythe, Vampire Cape, Zangetsu, dll",
            gears = {
                { name = "Enol's Drums", rarity = "Divine" },
                { name = "Reaper's Scythe", rarity = "Haunted" },
                { name = "Vampire Cape", rarity = "Haunted" },
                { name = "Ichiga's Zangetsu", rarity = "Legendary" },
                { name = "Jogu's Robe", rarity = "Legendary" },
                { name = "Obita's War Fan", rarity = "Legendary" },
                { name = "Pikolo's Cape", rarity = "Legendary" },
                { name = "Shizui's Tanto", rarity = "Rare" }
            }
        },
        {
            slot = "Head",
            title = "👑 SLOT: HEAD (Kepala)",
            subtitle = "Igras's Helm, Obita's Mask, Pumpkin Head, Bamboo, dll",
            gears = {
                { name = "Igras's Helm", rarity = "Divine" },
                { name = "Obita's Mask", rarity = "Divine" },
                { name = "Pumpkin Head", rarity = "Haunted" },
                { name = "Golden Hair", rarity = "Rare" },
                { name = "Nezuka's Bamboo", rarity = "Rare" },
                { name = "Ulquiro's Mask", rarity = "Rare" },
                { name = "Usop's Hat", rarity = "Rare" }
            }
        },
        {
            slot = "Torso",
            title = "🥋 SLOT: TORSO (Badan)",
            subtitle = "Mazun's Coat, Mummy Wraps, Monarch's Coat, Todoh's Vest",
            gears = {
                { name = "Mazun's Coat", rarity = "Divine" },
                { name = "Mummy Wraps", rarity = "Haunted" },
                { name = "Monarch's Coat", rarity = "Legendary" },
                { name = "Todoh's Vest", rarity = "Rare" }
            }
        },
        {
            slot = "Upper",
            title = "✨ SLOT: UPPER (Atas / Aura)",
            subtitle = "Angel's Halo, Ghost Wisps",
            gears = {
                { name = "Angel's Halo", rarity = "Divine" },
                { name = "Ghost Wisps", rarity = "Haunted" }
            }
        },
        {
            slot = "Waist",
            title = "⚔️ SLOT: WAIST (Pinggang)",
            subtitle = "Aizan's Katana, Sakuna's Sash, Candy Bucket, Tanjuro, Zaro, Jinwoo",
            gears = {
                { name = "Aizan's Katana", rarity = "Divine" },
                { name = "Sakuna's Sash", rarity = "Divine" },
                { name = "Candy Bucket", rarity = "Haunted" },
                { name = "Tanjuro's Katana", rarity = "Legendary" },
                { name = "Zaro's Swords", rarity = "Legendary" },
                { name = "Jinwoo's Daggers", rarity = "Rare" }
            }
        }
    }

    local function addIndividualGearToggle(parent, gearName, rarity)
        local initialVal = true
        if Config.Gear["Selected Gears"] and Config.Gear["Selected Gears"][gearName] ~= nil then
            initialVal = Config.Gear["Selected Gears"][gearName]
        end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 34)
        card.BackgroundColor3 = THEME.Card
        card.BorderSizePixel = 0
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = string.format("%s [%s]", gearName, rarity)
        lbl.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 22)
        btn.Position = UDim2.new(1, -58, 0.5, -11)
        btn.BackgroundColor3 = initialVal and THEME.Green or THEME.Border
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextColor3 = initialVal and THEME.Bg or THEME.TextMuted
        btn.Text = initialVal and "ON" or "OFF"
        btn.AutoButtonColor = false
        btn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 11)
        btnCorner.Parent = btn

        local curState = initialVal
        local function setVisualState(newState)
            curState = newState
            btn.BackgroundColor3 = curState and THEME.Green or THEME.Border
            btn.TextColor3 = curState and THEME.Bg or THEME.TextMuted
            btn.Text = curState and "ON" or "OFF"
        end

        individualGearCallbacks[gearName] = setVisualState

        btn.MouseButton1Click:Connect(function()
            curState = not curState
            setVisualState(curState)
            if not Config.Gear["Selected Gears"] then Config.Gear["Selected Gears"] = {} end
            Config.Gear["Selected Gears"][gearName] = curState
            saveConfig()
        end)
    end

    for _, group in ipairs(gearGroups) do
        createSectionHeader(GearTab, group.title, group.subtitle)
        for _, gInfo in ipairs(group.gears) do
            addIndividualGearToggle(GearTab, gInfo.name, gInfo.rarity)
        end
    end
end

-- 4.6 Settings & Hop Tab
do
    createToggle(SettingsTab, "Stop Trade Saat Kosong (Hentikan Jika Habis)", Config.Settings["Stop When Empty"], function(val)
        Config.Settings["Stop When Empty"] = val
    end)

    createToggle(SettingsTab, "Anti-AFK (Multi-Layer & Keep Alive)", Config.Settings["Anti AFK"] ~= false, function(val)
        Config.Settings["Anti AFK"] = val
        applyAntiAfkState(val)
        if val then
            addLog("Anti-AFK diaktifkan (Pure silent keep-alive).", THEME.Green)
        else
            addLog("Anti-AFK dinonaktifkan.", THEME.TextMuted)
        end
        saveConfig()
    end)

    createTextInput(SettingsTab, "Offer Delay (detik per unit)", Config.Settings["Offer Delay"], function(val)
        Config.Settings["Offer Delay"] = tonumber(val) or 0.3
    end)

    createTextInput(SettingsTab, "Ready Wait Time (detik)", Config.Settings["Ready Wait Time"], function(val)
        Config.Settings["Ready Wait Time"] = tonumber(val) or 1.0
    end)

    createToggle(SettingsTab, "Handshake DuckHub Only (Tolak Trade Pemain Publik/Random)", Config.Settings["Handshake DuckHub Only"] ~= false, function(val)
        Config.Settings["Handshake DuckHub Only"] = val
        saveConfig()
    end)

    createToggle(SettingsTab, "Aktifkan Collector Hop (Receiver PC Join Sender VPS 1-per-1)", Config.Hop.Enabled ~= false, function(val)
        Config.Hop.Enabled = val
        saveConfig()
    end)

    createTextInput(SettingsTab, "Queue Server URL (Domain Sendiri)", Config.Hop["Queue Server URL"] or DEFAULT_QUEUE_SERVER_URL, function(val)
        Config.Hop["Queue Server URL"] = tostring(val or ""):gsub("^%s+", ""):gsub("%s+$", "")
        saveConfig()
    end)

    createButton(SettingsTab, "🗑️ Bersihkan Antrean JobId Cloud & Lokal (Reset Queue)", THEME.Red, function()
        writeLocalSenderQueue({})
        cachedCloudQueue = {}
        completedSessionJobIds = {}
        completedSessionSenders = {}
        task.spawn(function()
            postCloudQueueEvent({ action = "CLEAR_ALL", seq = tick() })
        end)
        addLog("Antrean Cloud (VPS <-> PC) & Lokal berhasil dikosongkan!", THEME.Yellow)
    end)

    createTextInput(SettingsTab, "Max Players Threshold", Config.Hop["Max Players Threshold"], function(val)
        Config.Hop["Max Players Threshold"] = tonumber(val) or 8
        saveConfig()
    end)

    createButton(SettingsTab, "🚀 Hop ke Server Paling Sepi Sekarang", THEME.Cyan, function()
        addLog("Tombol ditekan: Memulai pencarian server paling sepi...", THEME.Cyan)
        hopToLowestServer(true)
    end)

    createButton(SettingsTab, "📋 Salin Link Server Public (Copy Server Link)", THEME.Green, function()
        copyServerLink()
    end)

    createToggle(SettingsTab, "FarmerV5 Auto Change (Ganti Akun)", Config["Auto Change"].Farmerv5.Enabled, function(val)
        Config["Auto Change"].Farmerv5.Enabled = val
        if Config["Auto Change"] then
            Config["Auto Change"].Enabled = val
        end
        saveConfig()
    end)

    createTextInput(SettingsTab, "FarmerV5 API Key", Config["Auto Change"].Farmerv5["API Key"], function(val)
        Config["Auto Change"].Farmerv5["API Key"] = val
        saveConfig()
    end)

    createTextInput(SettingsTab, "FarmerV5 Autoswap Rule (Option)", Config["Auto Change"].Farmerv5["Option"] or 1, function(val)
        Config["Auto Change"].Farmerv5["Option"] = tonumber(val) or 1
        saveConfig()
    end)

    createTextInput(SettingsTab, "FarmerV5 Base URL (Domain / IP)", Config["Auto Change"].Farmerv5["Base URL"] or "https://accountops.org", function(val)
        Config["Auto Change"].Farmerv5["Base URL"] = val
        saveConfig()
    end)

    -- Save Button
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(1, 0, 0, 36)
    saveBtn.BackgroundColor3 = THEME.Accent
    saveBtn.TextColor3 = THEME.Bg
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 13
    saveBtn.Text = "SIMPAN PENGATURAN (SAVE CONFIG.JSON)"
    saveBtn.AutoButtonColor = false
    saveBtn.Parent = SettingsTab

    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, 6)
    saveCorner.Parent = saveBtn

    saveBtn.MouseButton1Click:Connect(function()
        saveConfig()
        saveBtn.Text = "BERHASIL DISIMPAN!"
        task.wait(1.5)
        saveBtn.Text = "SIMPAN PENGATURAN (SAVE CONFIG.JSON)"
    end)
end

-- 4.5 Logs Tab
do
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1, 0, 0, 28)
    clearBtn.BackgroundColor3 = THEME.Card
    clearBtn.TextColor3 = THEME.TextMuted
    clearBtn.Font = Enum.Font.GothamMedium
    clearBtn.TextSize = 12
    clearBtn.Text = "Bersihkan Log"
    clearBtn.AutoButtonColor = false
    clearBtn.Parent = LogsTab

    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearBtn

    LogContainer = Instance.new("ScrollingFrame")
    LogContainer.Size = UDim2.new(1, 0, 1, -36)
    LogContainer.BackgroundColor3 = THEME.Card
    LogContainer.BorderSizePixel = 0
    LogContainer.ScrollBarThickness = 4
    LogContainer.ScrollBarImageColor3 = THEME.Border
    LogContainer.Parent = LogsTab

    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 6)
    logCorner.Parent = LogContainer

    local logList = Instance.new("UIListLayout")
    logList.SortOrder = Enum.SortOrder.LayoutOrder
    logList.Padding = UDim.new(0, 4)
    logList.Parent = LogContainer

    local logPad = Instance.new("UIPadding")
    logPad.PaddingLeft = UDim.new(0, 8)
    logPad.PaddingRight = UDim.new(0, 8)
    logPad.PaddingTop = UDim.new(0, 8)
    logPad.PaddingBottom = UDim.new(0, 8)
    logPad.Parent = LogContainer

    clearBtn.MouseButton1Click:Connect(function()
        for _, c in ipairs(LogContainer:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
    end)
end

-- Default tab open: Dashboard
TabButtons["Dash"].TextColor3 = THEME.Accent
TabButtons["Dash"].BackgroundTransparency = 0
Tabs["Dash"].Visible = true

-- ====================================================================
-- 5. Trading Core Engine
-- ====================================================================
local inTradeSession = false
local activePartner = nil
local activeTradeData = nil
local isProcessingOffer = false
local isAdvancing = false
local isConfirming = false
local tradeSessionStartTime = 0
local lastReadyAttemptTime = 0
local confirmPhaseStartTime = 0
local lastRequestTime = 0
local lastEmptyNoticeTime = 0
local scriptStartTime = tick()
local isFarmerSwitching = false
local lastFarmerSwitchTime = 0

local function getEquippedUUIDs()
    local equipped = {}
    pcall(function()
        local slots = DataController and DataController.___X and DataController.___X.Slots
        if slots then
            for _, slot in pairs(slots) do
                if type(slot) == "table" and slot.unitId then
                    equipped[tostring(slot.unitId)] = true
                end
            end
        end
    end)
    return equipped
end

local function getEligibleUnits()
    local eligible = {}
    if not (Config.Units and Config.Units.Enabled) then return eligible end

    local equippedMap = getEquippedUUIDs()
    local inv = nil
    pcall(function()
        inv = DataController and DataController.Inventory and DataController.Inventory()
    end)
    if not inv then return eligible end

    for uuid, itemGetter in pairs(inv) do
        local item = type(itemGetter) == "function" and itemGetter() or itemGetter
        if item and item.name then
            local entryConfig = EntryRegistry and EntryRegistry.getEntryConfig(item.name)
            local kind = entryConfig and entryConfig.kind or "Unit"
            
            if kind == "Unit" then
                local isTradeable = true
                if TradeConfigModule and TradeConfigModule.IsTradeable then
                    local s, res = pcall(function() return TradeConfigModule.IsTradeable(item) end)
                    if s then isTradeable = (res == true) end
                elseif TradeConfigModule and TradeConfigModule.UNTRADEABLE_ENTRIES then
                    isTradeable = not table.find(TradeConfigModule.UNTRADEABLE_ENTRIES, item.name)
                end

                if isTradeable then
                    local isLocked = item.attributes and (item.attributes.locked == true) or false
                    local isEquipped = (equippedMap[tostring(uuid)] == true)

                    local allowEquipped = not (Config.Units["Keep Equipped"] and isEquipped)
                    local allowLocked = not (Config.Units["Keep Locked"] and isLocked)

                    if allowEquipped and allowLocked then
                        local rarity = entryConfig and entryConfig.rarity or "Unknown"
                        local rarityMatch = (Config.Units.Rarities and Config.Units.Rarities[rarity] == true)
                        
                        local isWhitelisted = true
                        if Config.Units["Whitelist Units"] and #Config.Units["Whitelist Units"] > 0 then
                            isWhitelisted = table.find(Config.Units["Whitelist Units"], item.name) ~= nil
                        end

                        if rarityMatch and isWhitelisted then
                            table.insert(eligible, {
                                uuid = tostring(uuid),
                                name = item.name,
                                rarity = rarity,
                                count = 1
                            })
                        end
                    end
                end
            end
        end
    end
    return eligible
end

local function getEligibleTokens()
    local eligibleTokens = {}
    local inv = nil
    pcall(function()
        inv = DataController and DataController.Inventory and DataController.Inventory()
    end)
    if not inv then return eligibleTokens end

    for id, itemGetter in pairs(inv) do
        local item = type(itemGetter) == "function" and itemGetter() or itemGetter
        if item and item.name then
            local entryConfig = EntryRegistry and EntryRegistry.getEntryConfig(item.name)
            local kind = entryConfig and entryConfig.kind or "Unknown"

            if kind == "Token" and Config.Tokens and Config.Tokens[item.name] and Config.Tokens[item.name].Enabled then
                local keep = tonumber(Config.Tokens[item.name]["Keep Amount"]) or 0
                local currentAmt = tonumber(item.amount) or 0
                local toSend = currentAmt - keep
                if toSend > 0 then
                    table.insert(eligibleTokens, {
                        id = tostring(id),
                        name = item.name,
                        amount = toSend,
                        kind = "Token"
                    })
                end
            elseif kind == "Spin" and Config.Spins and Config.Spins[item.name] and Config.Spins[item.name].Enabled then
                local keep = tonumber(Config.Spins[item.name]["Keep Amount"]) or 0
                local currentAmt = tonumber(item.amount) or 0
                local toSend = currentAmt - keep
                if toSend > 0 then
                    table.insert(eligibleTokens, {
                        id = tostring(id),
                        name = item.name,
                        amount = toSend,
                        kind = "Spin"
                    })
                end
            end
        end
    end
    return eligibleTokens
end

local function getEligibleBoosts()
    local eligibleBoosts = {}
    if not (Config.Boosts and Config.Boosts.Enabled) then return eligibleBoosts end

    local inv = nil
    pcall(function()
        inv = DataController and DataController.Inventory and DataController.Inventory()
    end)
    if not inv then return eligibleBoosts end

    for id, itemGetter in pairs(inv) do
        local item = type(itemGetter) == "function" and itemGetter() or itemGetter
        if item and item.name then
            local entryConfig = EntryRegistry and EntryRegistry.getEntryConfig(item.name)
            local kind = entryConfig and entryConfig.kind or "Unknown"

            if kind == "Boost" then
                local cat = entryConfig.category or ""
                local tier = tonumber(entryConfig.tier) or 1
                local minTier = tonumber(Config.Boosts["Min Tier"]) or 1
                local catAllowed = false
                if Config.Boosts["Selected Categories"] and type(Config.Boosts["Selected Categories"]) == "table" then
                    if Config.Boosts["Selected Categories"][cat] ~= nil then
                        catAllowed = Config.Boosts["Selected Categories"][cat] == true
                    else
                        catAllowed = table.find(Config.Boosts.Categories or {}, cat) ~= nil
                    end
                else
                    catAllowed = table.find(Config.Boosts.Categories or {}, cat) ~= nil
                end

                if catAllowed and tier >= minTier then
                    local keep = tonumber(Config.Boosts["Keep Amount"]) or 0
                    local currentAmt = tonumber(item.amount) or 0
                    local toSend = currentAmt - keep
                    if toSend > 0 then
                        table.insert(eligibleBoosts, {
                            id = tostring(id),
                            name = item.name,
                            amount = toSend,
                            kind = "Boost"
                        })
                    end
                end
            end
        end
    end
    return eligibleBoosts
end

local function getEligibleGear()
    local eligibleGear = {}
    if not (Config.Gear and Config.Gear.Enabled) then return eligibleGear end

    local inv = nil
    pcall(function()
        inv = DataController and DataController.Inventory and DataController.Inventory()
    end)
    if not inv then return eligibleGear end

    local equippedSet = {}
    if Config.Gear["Keep Equipped"] then
        pcall(function()
            local eqGears = nil
            if DataController.EquippedGear then
                eqGears = DataController.EquippedGear()
            elseif DataController.___X and DataController.___X.EquippedGear then
                eqGears = DataController.___X.EquippedGear
            end
            if type(eqGears) == "table" then
                for _, gName in pairs(eqGears) do
                    if gName and gName ~= "" then
                        equippedSet[gName] = (equippedSet[gName] or 0) + 1
                    end
                end
            end
        end)
    end

    for id, itemGetter in pairs(inv) do
        local item = type(itemGetter) == "function" and itemGetter() or itemGetter
        if item and item.name then
            local entryConfig = EntryRegistry and EntryRegistry.getEntryConfig(item.name)
            local kind = entryConfig and entryConfig.kind or "Unknown"

            if kind == "Gear" then
                local isTradeable = true
                if TradeConfigModule and TradeConfigModule.IsTradeable then
                    local s, res = pcall(function() return TradeConfigModule.IsTradeable(item) end)
                    if s then isTradeable = (res == true) end
                elseif TradeConfigModule and TradeConfigModule.UNTRADEABLE_ENTRIES then
                    isTradeable = not table.find(TradeConfigModule.UNTRADEABLE_ENTRIES, item.name)
                end

                if isTradeable then
                    local rarity = entryConfig and entryConfig.rarity or "Unknown"
                    local slot = entryConfig and entryConfig.slot or "Unknown"

                    local rarityMatch = (Config.Gear.Rarities and Config.Gear.Rarities[rarity] == true)
                    local slotMatch = (Config.Gear.Slots and Config.Gear.Slots[slot] == true)

                    local individualMatch = true
                    if Config.Gear["Selected Gears"] and type(Config.Gear["Selected Gears"]) == "table" then
                        if Config.Gear["Selected Gears"][item.name] ~= nil then
                            individualMatch = (Config.Gear["Selected Gears"][item.name] == true)
                        end
                    end

                    local whitelistMatch = true
                    if Config.Gear["Whitelist Gear"] and #Config.Gear["Whitelist Gear"] > 0 then
                        whitelistMatch = table.find(Config.Gear["Whitelist Gear"], item.name) ~= nil
                    end

                    if rarityMatch and slotMatch and individualMatch and whitelistMatch then
                        local keep = tonumber(Config.Gear["Keep Amount"]) or 0
                        if Config.Gear["Keep Equipped"] and (equippedSet[item.name] and equippedSet[item.name] > 0) then
                            keep = math.max(keep, equippedSet[item.name])
                        end

                        local currentAmt = tonumber(item.amount) or 0
                        local toSend = currentAmt - keep
                        if toSend > 0 then
                            table.insert(eligibleGear, {
                                id = tostring(id),
                                name = item.name,
                                amount = toSend,
                                rarity = rarity,
                                slot = slot,
                                kind = "Gear"
                            })
                        end
                    end
                end
            end
        end
    end
    return eligibleGear
end

local function hasItemsToSend()
    local units = getEligibleUnits()
    if #units > 0 then return true end

    local tokens = getEligibleTokens()
    if #tokens > 0 then return true end

    local boosts = getEligibleBoosts()
    if #boosts > 0 then return true end

    local gear = getEligibleGear()
    if #gear > 0 then return true end

    return false
end

local function isAllowedSender(senderName)
    if Config["Accept Any Sender"] then return true end
    local sName = senderName:lower()
    if Config["Whitelist Senders"] then
        for _, w in ipairs(Config["Whitelist Senders"]) do
            if w:lower() == sName then return true end
        end
    end
    return false
end

local function triggerFarmerV5Switch(reason)
    if getRole() == "Receiver" then return end
    if isFarmerSwitching or (tick() - lastFarmerSwitchTime < 15) then return end
    
    local autoChange = Config["Auto Change"]
    local farmerCfg = autoChange and autoChange.Farmerv5
    if not farmerCfg then return end

    local isEnabled = (farmerCfg.Enabled == true) or (autoChange and autoChange.Enabled == true)
    if not isEnabled then return end

    local apiKey = farmerCfg["API Key"]
    if not apiKey or apiKey == "" then return end

    local req = request or (syn and syn.request) or (http and http.request) or http_request
    if not req then
        addLog("FarmerV5: Executor tidak mendukung fungsi HTTP request!", THEME.Red)
        return
    end

    isFarmerSwitching = true
    lastFarmerSwitchTime = tick()

    task.spawn(function()
        local why = reason or "Event"
        addLog("FarmerV5: Mengirim autoswap (" .. why .. ")...", THEME.Accent)
        
        local baseUrl = farmerCfg["Base URL"] or "https://accountops.org"
        if not baseUrl or baseUrl == "" or baseUrl:find("127.0.0.1") or baseUrl:find("localhost") then
            baseUrl = "https://accountops.org"
        end
        baseUrl = baseUrl:gsub("/+$", "")
        local endpoint = baseUrl .. "/api/accounts/autoswap-complete"

        local payload = HttpService:JSONEncode({
            ["username"] = tostring(LocalPlayer.Name),
            ["option"] = tonumber(farmerCfg["Option"]) or 1
        })
        
        local success, res = pcall(function()
            return req({
                Url = endpoint,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-Api-Key"] = tostring(apiKey),
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                },
                Body = payload
            })
        end)

        if success and res then
            local statusCode = tonumber(res.StatusCode or res.status_code) or 200
            local bodyText = res.Body or res.body or ""
            local data = nil
            pcall(function() data = HttpService:JSONDecode(bodyText) end)

            if data and data.outcome then
                if data.outcome == "swapped" then
                    addLog("FarmerV5: Berhasil Swap Akun! Pengganti: " .. tostring(data.replacement or "-"), THEME.Green)
                    task.spawn(function()
                        task.wait(2)
                        pcall(function() game:Shutdown() end)
                        task.wait(1)
                        pcall(function() LocalPlayer:Kick("FarmerV5 Autoswap: Berganti ke " .. tostring(data.replacement or "akun baru")) end)
                    end)
                elseif data.outcome == "moved" then
                    addLog("FarmerV5: Akun dipindahkan (moved). Menutup game...", THEME.Green)
                    task.spawn(function()
                        task.wait(2)
                        pcall(function() game:Shutdown() end)
                        task.wait(1)
                        pcall(function() LocalPlayer:Kick("FarmerV5: Akun selesai dipanen.") end)
                    end)
                elseif data.outcome == "not_fired" then
                    addLog("FarmerV5: Autoswap not_fired (cek rule / ketersediaan pengganti).", THEME.TextMuted)
                    isFarmerSwitching = false
                else
                    addLog("FarmerV5: Response: " .. tostring(data.outcome), THEME.Cyan)
                end
            else
                addLog("FarmerV5: Sinyal terkirim (Status: " .. tostring(statusCode) .. ")", THEME.Green)
            end
        else
            addLog("FarmerV5: Gagal kirim sinyal (" .. tostring(res) .. ")", THEME.Red)
            isFarmerSwitching = false
        end
    end)
end

local function findReceiverPlayer()
    local target = tostring(Config.Receiver or ""):lower():gsub("%s+", "")
    if target == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pName = p.Name:lower():gsub("%s+", "")
            local pDisplay = p.DisplayName:lower():gsub("%s+", "")
            if pName == target or pDisplay == target then
                return p
            end
        end
    end
    return nil
end

local function isReceiverPlayer(playerObj)
    if not playerObj then return false end
    local target = tostring(Config.Receiver or ""):lower():gsub("%s+", "")
    if target == "" then return false end
    local pName = playerObj.Name:lower():gsub("%s+", "")
    local pDisplay = playerObj.DisplayName:lower():gsub("%s+", "")
    return pName == target or pDisplay == target
end

-- Trade Network Events Hook
InstanceManager:AddConnection(TradeEventRemote.OnClientEvent:Connect(function(eventType, payload)
    if not InstanceManager.IsAlive or not Config.Enabled then return end
    local role = getRole()

    if eventType == "RequestReceived" then
        local sender = payload and payload.player
        if not sender then return end

        if role == "Receiver" then
            if inTradeSession or (tick() - lastAcceptRequestTime < 2.8) then
                addLog("Sedang sibuk trade dengan bot lain, menunda request dari: " .. sender.Name, THEME.Yellow)
                return
            end
            if isAllowedSender(sender.Name) and verifyDuckHubHandshake(sender.Name) then
                lastAcceptRequestTime = tick()
                addLog("[Handshake OK] Menerima request trade dari DuckHub: " .. sender.Name, THEME.Green)
                RespondToRequestRemote:FireServer(true)
            else
                addLog("[Handshake DITOLAK] Menolak trade dari non-DuckHub/publik: " .. sender.Name, THEME.Red)
                RespondToRequestRemote:FireServer(false)
            end
        else
            if isReceiverPlayer(sender) then
                if Config.Settings and Config.Settings["Stop When Empty"] and not hasItemsToSend() then
                    addLog("Menolak trade dari Receiver (inventaris kosong). Menghapus akun dari Cloud Queue...", THEME.TextMuted)
                    RespondToRequestRemote:FireServer(false)
                    updateSelfInSenderQueue(false, true)
                    triggerFarmerV5Switch("Inventaris Kosong Saat Trade Request")
                else
                    addLog("Menerima trade request dari Receiver: " .. sender.Name, THEME.Green)
                    RespondToRequestRemote:FireServer(true)
                end
            end
        end
        return
    end

    if eventType == "Started" then
        local partner = payload and payload.partner
        if not partner then return end

        inTradeSession = true
        activePartner = partner
        activeTradeData = nil
        isProcessingOffer = false
        isAdvancing = false
        isConfirming = false
        tradeSessionStartTime = tick()
        lastReadyAttemptTime = 0
        confirmPhaseStartTime = 0

        StatusBadge.Text = role:upper() .. " [TRADING]"
        StatusBadge.TextColor3 = THEME.Green
        addLog("Sesi trade dimulai dengan: " .. partner.Name, THEME.Cyan)

        if role == "Sender" then
            task.spawn(function()
                task.wait(0.5)
                if not inTradeSession then return end
                isProcessingOffer = true

                local offerDelay = (Config.Settings and Config.Settings["Offer Delay"]) or 0.3
                local eligibleUnits = getEligibleUnits()
                local eligibleTokens = getEligibleTokens()
                local eligibleBoosts = getEligibleBoosts()
                local eligibleGear = getEligibleGear()
                local totalOffered = 0
                local maxEntries = (TradeConfigModule and TradeConfigModule.MAX_UNIQUE_ENTRIES) or 20

                for _, u in ipairs(eligibleUnits) do
                    if not inTradeSession or totalOffered >= maxEntries then break end
                    addLog(string.format("Offering Unit: %s [%s]", u.name, u.rarity), THEME.Accent)
                    ChangeOfferRemote:FireServer(u.uuid, 1)
                    totalOffered = totalOffered + 1
                    task.wait(offerDelay)
                end

                for _, t in ipairs(eligibleTokens) do
                    if not inTradeSession or totalOffered >= maxEntries then break end
                    addLog(string.format("Offering %s: %s x%d", t.kind, t.name, t.amount), THEME.Accent)
                    ChangeOfferRemote:FireServer(t.id, t.amount)
                    totalOffered = totalOffered + 1
                    task.wait(offerDelay)
                end

                for _, b in ipairs(eligibleBoosts) do
                    if not inTradeSession or totalOffered >= maxEntries then break end
                    addLog(string.format("Offering Boost: %s x%d", b.name, b.amount), THEME.Accent)
                    ChangeOfferRemote:FireServer(b.id, b.amount)
                    totalOffered = totalOffered + 1
                    task.wait(offerDelay)
                end

                for _, g in ipairs(eligibleGear) do
                    if not inTradeSession or totalOffered >= maxEntries then break end
                    addLog(string.format("Offering Gear: %s [%s] x%d", g.name, g.rarity, g.amount), THEME.Accent)
                    ChangeOfferRemote:FireServer(g.id, g.amount)
                    totalOffered = totalOffered + 1
                    task.wait(offerDelay)
                end

                isProcessingOffer = false
                if totalOffered > 0 then
                    addLog(string.format("Selesai memasukkan %d item ke tawaran. Menunggu ready...", totalOffered), THEME.Green)
                else
                    addLog("Tidak ada item yang memenuhi filter (Cek 'Keep Equipped' atau 'Rarities')!", THEME.Red)
                end
            end)
        end
        return
    end

    if eventType == "Updated" then
        if not inTradeSession then return end
        activeTradeData = payload

        local phase = payload and payload.phase or "Offer"
        local ownReady = payload and payload.ownReady or false
        local ownAccepted = payload and payload.ownAccepted or false
        local readyDelay = (Config.Settings and tonumber(Config.Settings["Ready Wait Time"])) or 1.0

        if phase == "Confirm" or phase == "Saving" then
            if confirmPhaseStartTime == 0 then
                confirmPhaseStartTime = tick()
            end
        end

        if role == "Sender" and not isProcessingOffer then
            if phase == "Offer" and not ownReady and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(readyDelay)
                    if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                        lastReadyAttemptTime = tick()
                        addLog("Sender menekan READY...", THEME.Cyan)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isConfirming then
                isConfirming = true
                task.spawn(function()
                    local countdown = (TradeConfigModule and tonumber(TradeConfigModule.COUNTDOWN_DURATION)) or 3
                    local delayTime = countdown + 0.3 + math.max(0, readyDelay)
                    task.wait(delayTime)
                    local retries = 0
                    while inTradeSession and activeTradeData and (activeTradeData.phase == "Confirm" or activeTradeData.phase == "Saving") and not activeTradeData.ownAccepted and retries < 15 do
                        addLog(string.format("Sender menekan CONFIRM ACCEPT (attempt %d)...", retries + 1), THEME.Green)
                        AdvanceTradeRemote:FireServer()
                        retries = retries + 1
                        task.wait(0.6)
                    end
                    isConfirming = false
                end)
            end
        end

        if role == "Receiver" then
            if phase == "Offer" and not ownReady and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(0.5)
                    if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                        lastReadyAttemptTime = tick()
                        addLog("Receiver menekan READY...", THEME.Cyan)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isConfirming then
                isConfirming = true
                task.spawn(function()
                    local countdown = (TradeConfigModule and tonumber(TradeConfigModule.COUNTDOWN_DURATION)) or 3
                    local delayTime = countdown + 0.3 + math.max(0, readyDelay)
                    task.wait(delayTime)
                    local retries = 0
                    while inTradeSession and activeTradeData and (activeTradeData.phase == "Confirm" or activeTradeData.phase == "Saving") and not activeTradeData.ownAccepted and retries < 15 do
                        addLog(string.format("Receiver menekan CONFIRM ACCEPT (attempt %d)...", retries + 1), THEME.Green)
                        AdvanceTradeRemote:FireServer()
                        retries = retries + 1
                        task.wait(0.6)
                    end
                    isConfirming = false
                end)
            end
        end
        return
    end

    if eventType == "Ended" or eventType == "Completed" then
        local pName = activePartner and activePartner.Name or "Unknown"
        addLog("Trade selesai dengan: " .. pName, THEME.Green)

        inTradeSession = false
        activePartner = nil
        activeTradeData = nil
        isProcessingOffer = false
        isAdvancing = false
        isConfirming = false
        tradeSessionStartTime = 0
        lastReadyAttemptTime = 0
        confirmPhaseStartTime = 0
        StatusBadge.Text = role:upper() .. " [IDLE]"
        StatusBadge.TextColor3 = THEME.Cyan

        lastTradeEndedTime = tick()
        lastAcceptRequestTime = 0

        if role == "Sender" then
            -- Segera cek apakah setelah trade ini inventori Sender di VPS sudah habis
            task.spawn(function()
                task.wait(1.2)
                if not inTradeSession and not hasItemsToSend() then
                    addLog("Semua item telah ditransfer! Menghapus akun dari Cloud Queue & kirim sinyal ke FarmerV5...", THEME.Green)
                    updateSelfInSenderQueue(false, true)
                    StatusBadge.Text = "SENDER [KOSONG]"
                    StatusBadge.TextColor3 = THEME.TextMuted
                    triggerFarmerV5Switch("Trade Selesai & Inventaris Kosong")
                elseif not inTradeSession then
                    -- Masih ada sisa batch berikutnya (item > 20), percepat request batch ke-2 & perbarui heartbeat antrean
                    lastRequestTime = tick() - 4.5
                    updateSelfInSenderQueue(true, true)
                end
            end)
        end
        return
    end
end))

-- Trade Watchdog: Anti-Stuck & Auto-Recovery Loop (Ready, Confirm, & Session Timeout)
InstanceManager:Spawn(function()
    while InstanceManager.IsAlive and task.wait(1) do
        if inTradeSession and Config.Enabled and (Config.Settings and Config.Settings["Auto Loop Trade"]) then
            local role = getRole()
            local phase = activeTradeData and activeTradeData.phase or "Offer"
            local ownReady = activeTradeData and activeTradeData.ownReady
            local ownAccepted = activeTradeData and activeTradeData.ownAccepted
            local readyDelay = (Config.Settings and tonumber(Config.Settings["Ready Wait Time"])) or 1.0

            -- 1. Anti-Stuck untuk Tombol READY (Offer Phase)
            if phase == "Offer" and not ownReady and not isProcessingOffer then
                local canRetryReady = false
                if role == "Receiver" then
                    if (tradeSessionStartTime > 0 and (tick() - tradeSessionStartTime >= 0.8)) and (tick() - lastReadyAttemptTime >= 1.5) then
                        canRetryReady = true
                    end
                elseif role == "Sender" then
                    if (tradeSessionStartTime > 0 and (tick() - tradeSessionStartTime >= readyDelay + 0.5)) and (tick() - lastReadyAttemptTime >= 1.5) then
                        canRetryReady = true
                    end
                end

                if canRetryReady then
                    lastReadyAttemptTime = tick()
                    addLog(string.format("[Watchdog] %s menekan ulang tombol READY...", role), THEME.Cyan)
                    AdvanceTradeRemote:FireServer()
                end
            end
            
            -- 2. Anti-Stuck untuk Confirm/Saving phase (server countdown is 3s)
            if (phase == "Confirm" or phase == "Saving") and not ownAccepted then
                local countdown = (TradeConfigModule and tonumber(TradeConfigModule.COUNTDOWN_DURATION)) or 3
                if confirmPhaseStartTime > 0 and (tick() - confirmPhaseStartTime >= countdown + 0.8) then
                    AdvanceTradeRemote:FireServer()
                end
            end

            -- 3. Anti-Stuck untuk Sesi Trade Keseluruhan: Jika macet > 40s (karena freeze/bug), batalkan untuk reset
            if tradeSessionStartTime > 0 and (tick() - tradeSessionStartTime > 40) then
                addLog("[Watchdog] Sesi trade macet > 40 detik! Membatalkan trade untuk recovery...", THEME.Red)
                CancelTradeRemote:FireServer()
            end
        end
    end
end)

-- Collector Mode Engine Loop (Sender VPS Broadcasts JobId to Cloud -> Receiver PC Joins Senders 1-by-1 & Multi-Bot Safe)
InstanceManager:Spawn(function()
    while InstanceManager.IsAlive and task.wait(3.5) do
        local loopOk, loopErr = pcall(function()
            if not Config.Enabled or not InstanceManager.IsAlive then return end
            local role = getRole()

            if role == "Sender" then
                pcall(function()
                    SetTradeRequestsEnabledRemote:FireServer(true)
                end)

                if inTradeSession then return end
                if not (Config.Settings and Config.Settings["Auto Loop Trade"]) then return end

                local invLoaded = false
                pcall(function()
                    invLoaded = (DataController and DataController.Inventory and DataController.Inventory() ~= nil)
                end)

                if not invLoaded or (tick() - scriptStartTime < 6) then
                    return
                end

                -- 1. Cek apakah inventori Sender di VPS sudah kosong (termasuk saat akun baru login)
                if not hasItemsToSend() then
                    -- Hapus akun ini saja dari Cloud & Local Queue (bot lain di JobId sama tetap aman)
                    updateSelfInSenderQueue(false, false)

                    if tick() - lastEmptyNoticeTime >= 15 then
                        lastEmptyNoticeTime = tick()
                        StatusBadge.Text = "SENDER [KOSONG]"
                        StatusBadge.TextColor3 = THEME.TextMuted
                        addLog("Inventaris kosong. Akun dihapus dari Cloud Queue & mengirim sinyal ke FarmerV5...", THEME.TextMuted)
                    end
                    triggerFarmerV5Switch("Inventaris Kosong")
                    return
                end

                -- 2. Daftarkan/perbarui JobId ke Cloud Queue (VPS -> PC, refresh setiap 45-60s)
                updateSelfInSenderQueue(true, false)

                -- 3. Cek apakah Receiver sudah datang ke server ini
                local recPlayer = findReceiverPlayer()
                if recPlayer then
                    StatusBadge.Text = "SENDER [READY]"
                    StatusBadge.TextColor3 = THEME.Green
                    -- Jeda unik per-UserId (6s - 8.5s) agar jika ada 2+ bot di 1 server tidak bentrok terus-menerus
                    local reqInterval = 6.0 + ((tonumber(LocalPlayer.UserId) or 0) % 5) * 0.5
                    if tick() - lastRequestTime >= reqInterval then
                        lastRequestTime = tick()
                        addLog("Receiver ada di server! Mengirim trade request ke: " .. Config.Receiver, THEME.Cyan)
                        RequestTradeRemote:FireServer(recPlayer)
                    end
                else
                    StatusBadge.Text = "SENDER [IN QUEUE]"
                    StatusBadge.TextColor3 = THEME.Accent
                end
            else
                -- ROLE == "Receiver" di PC (Collector 1-per-1 Lintas VPS, Mendukung Banyak Bot di 1 JobId)
                pcall(function()
                    SetTradeRequestsEnabledRemote:FireServer(true)
                end)

                if inTradeSession or isHopping then return end
                if not (Config.Hop and Config.Hop.Enabled ~= false) then return end

                local q = readCombinedSenderQueue()
                if inTradeSession or isHopping then return end
                local activeSendersInCurrentServer = {}

                -- 1. Periksa SEMUA akun Sender yang ada di server (JobId) saat ini dan ditujukan untuk Receiver ini
                for uname, entry in pairs(q) do
                    if type(entry) == "table" and isEntryForThisReceiver(entry) and tostring(entry.JobId) == tostring(game.JobId) then
                        local pObj = nil
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Name:lower() == uname:lower() then
                                pObj = p
                                break
                            end
                        end

                        if pObj and entry.HasItems and isAllowedSender(pObj.Name) then
                            table.insert(activeSendersInCurrentServer, {
                                Player = pObj,
                                Entry = entry
                            })
                        elseif not pObj and (tick() - scriptStartTime >= 8) then
                            -- Akun Sender spesifik ini sudah keluar dari server (di-swap FarmerV5), hapus akun ini saja dari Cloud!
                            addLog("Sender [" .. uname .. "] sudah keluar dari server. Menghapus akun dari Cloud Queue...", THEME.TextMuted)
                            removeSenderFromQueue(uname, tostring(game.JobId))
                        end
                    end
                end

                -- Urutkan bot di server ini berdasarkan urutan daftar (FIFO)
                table.sort(activeSendersInCurrentServer, function(a, b)
                    local ra = tonumber(a.Entry.RegisteredAt) or 0
                    local rb = tonumber(b.Entry.RegisteredAt) or 0
                    if ra == rb then
                        return a.Player.Name < b.Player.Name
                    end
                    return ra < rb
                end)

                if #activeSendersInCurrentServer > 0 then
                    local firstBot = activeSendersInCurrentServer[1].Player
                    StatusBadge.Text = string.format("COLLECT (%d BOT): %s", #activeSendersInCurrentServer, string.sub(firstBot.Name, 1, 7))
                    StatusBadge.TextColor3 = THEME.Green
                    if tick() - lastQueueLogTime >= 10 then
                        lastQueueLogTime = tick()
                        addLog(string.format("Ada %d bot aktif di server ini. Memproses antrean: %s", #activeSendersInCurrentServer, firstBot.Name), THEME.Green)
                    end
                    return
                end

                -- Beri jeda 6 detik saat baru masuk server, ATAU 8 detik setelah trade terakhir selesai
                -- (agar jika ada bot ke-2 / batch ke-2 di server yang sama sempat kirim request sebelum Receiver pindah)
                if (tick() - scriptStartTime < 6) or (lastTradeEndedTime > 0 and (tick() - lastTradeEndedTime < 8)) then
                    return
                end

                -- Semua bot di server ini sudah benar-benar habis! Tandai JobId ini bersih sementara
                completedSessionJobIds[tostring(game.JobId)] = os.time()

                -- 2. Tidak ada lagi Sender aktif di server ini -> Cari target Sender VPS berikutnya 1 per 1 dari Cloud Queue
                local nextTarget, waitingCount = getNextWaitingSender()
                if nextTarget and nextTarget.JobId then
                    isHopping = true
                    lastHopAttemptTime = tick()
                    lastTargetJobId = nextTarget.JobId
                    StatusBadge.Text = "HOP -> " .. string.sub(nextTarget.Username, 1, 8)
                    StatusBadge.TextColor3 = THEME.Cyan

                    addLog(string.format("Collector [VPS -> PC]: Pindah ke server Sender [%s] (JobId: %s | Antrean Cloud: %d)...",
                        tostring(nextTarget.Username),
                        string.sub(tostring(nextTarget.JobId), 1, 8),
                        waitingCount
                    ), THEME.Cyan)

                    queueCollectorOnTeleport()

                    task.spawn(function()
                        task.wait(1.5)
                        local tpOk, tpErr = pcall(function()
                            TeleportService:TeleportToPlaceInstance(tonumber(nextTarget.PlaceId) or game.PlaceId, tostring(nextTarget.JobId), LocalPlayer)
                        end)
                        if not tpOk then
                            addLog("Gagal teleport ke Sender " .. tostring(nextTarget.Username) .. " (" .. tostring(tpErr) .. "). Menghapus akun...", THEME.Red)
                            removeSenderFromQueue(nextTarget.Username, nextTarget.JobId)
                        end
                        task.wait(10)
                        isHopping = false
                    end)
                else
                    StatusBadge.Text = "RECEIVER [WAIT VPS]"
                    StatusBadge.TextColor3 = THEME.Accent
                    if tick() - lastQueueLogTime >= 15 then
                        lastQueueLogTime = tick()
                        addLog("Antrean Cloud VPS kosong. Menunggu akun Sender di VPS mendaftarkan JobId...", THEME.TextMuted)
                    end
                end
            end
        end)
        if not loopOk then
            print("[DuckHub Collector Loop Error]:", loopErr)
        end
    end
end)

addLog("DuckHub Collector Mode (VPS <-> PC Cloud Sync 1-by-1 & Multi-Bot Per Server) siap digunakan!", THEME.Accent)
