-- ====================================================================
-- DuckHub Clean + Modern Interactive UI & Config Manager
-- Game: Roblox Anime Dice (PlaceId: 113290951185459)
-- 100% Deobfuscated & Clean Source Code (Free of Luarmor / Luraph VM)
-- ====================================================================

repeat task.wait() until game:IsLoaded()

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
            ["Legendary"] = false,
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
        ["Keep Equipped"] = true,
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
        ["Enabled"] = true,
        ["Mode"] = "JobFile",
        ["Target JobId"] = "",
        ["Use JobFile"] = true,
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

-- Destroy old UI if exists
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("DuckHub_Trade_GUI")
    if old then old:Destroy() end
    local old2 = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("DuckHub_Trade_GUI")
    if old2 then old2:Destroy() end
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
MainFrame.Size = UDim2.new(0, 580, 0, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
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
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = THEME.Accent
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Text = "DUCKHUB | ANIME DICE"
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
    btn.Size = UDim2.new(0, 105, 1, -6)
    btn.BackgroundColor3 = THEME.Bg
    btn.BackgroundTransparency = 1
    btn.TextColor3 = THEME.TextMuted
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
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
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- Server Hop Engine State & Core Functions
local isHopping = false

pcall(function()
    TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        if player == LocalPlayer then
            isHopping = false
            addLog("Teleport gagal: " .. tostring(errorMessage), THEME.Rose)
        end
    end)
end)

local function hopToLowestServer()
    if isHopping then return end
    isHopping = true
    addLog("Mencari server paling sepi (pemain paling sedikit)...", THEME.Accent)
    task.spawn(function()
        local targetServerId = nil
        local targetPlaying = 0
        local targetPing = 0
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local raw = game:HttpGet(url)
            local x = HttpService:JSONDecode(raw)
            if x and x.data then
                local candidates = {}
                for _, s in ipairs(x.data) do
                    if s.id ~= game.JobId and s.playing and s.playing > 0 and s.playing < (s.maxPlayers - 1) then
                        table.insert(candidates, s)
                    end
                end

                -- Urutkan dari server paling sepi (pemain paling sedikit)
                -- Jika jumlah pemain sama, prioritaskan ping paling rendah
                table.sort(candidates, function(a, b)
                    if a.playing == b.playing then
                        local pingA = a.ping or 999
                        local pingB = b.ping or 999
                        return pingA < pingB
                    end
                    return a.playing < b.playing
                end)

                if #candidates > 0 then
                    targetServerId = candidates[1].id
                    targetPlaying = candidates[1].playing
                    targetPing = candidates[1].ping or 0
                end
            end
        end)

        if targetServerId then
            addLog(string.format("Berpindah ke server sepi (%d/%d pemain, %d ms): %s...", targetPlaying, Players.MaxPlayers, targetPing, string.sub(targetServerId, 1, 8)), THEME.Cyan)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, LocalPlayer)
        else
            addLog("Tidak menemukan server sepi via list. Menggunakan random teleport...", THEME.Yellow)
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end

        task.wait(12)
        isHopping = false
    end)
end

-- ====================================================================
-- 4. Population of UI Tabs
-- ====================================================================
local DashTab = createTab("Dash", "Dashboard")
local UnitsTab = createTab("Units", "Units")
local TokensTab = createTab("Tokens", "Tokens/Spins")
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
end

-- 4.2 Units Tab
do
    createToggle(UnitsTab, "Units Auto-Trade Enabled", Config.Units.Enabled, function(val)
        Config.Units.Enabled = val
    end)

    createToggle(UnitsTab, "Keep Equipped Units (Simpan Unit Terpakai)", Config.Units["Keep Equipped"], function(val)
        Config.Units["Keep Equipped"] = val
    end)

    createToggle(UnitsTab, "Keep Locked Units (Simpan Unit Terkunci)", Config.Units["Keep Locked"], function(val)
        Config.Units["Keep Locked"] = val
    end)

    local secLabel = Instance.new("TextLabel")
    secLabel.Size = UDim2.new(1, 0, 0, 24)
    secLabel.BackgroundTransparency = 1
    secLabel.Font = Enum.Font.GothamBold
    secLabel.TextSize = 12
    secLabel.TextColor3 = THEME.Accent
    secLabel.TextXAlignment = Enum.TextXAlignment.Left
    secLabel.Text = "Filter Rarity yang Dikirim ke Receiver:"
    secLabel.Parent = UnitsTab

    local rarities = { "Legendary", "Mythical", "Divine", "Celestial", "Exotic", "Secret I", "Secret II", "Heavenly", "Exclusive" }
    for _, r in ipairs(rarities) do
        local isEnabled = Config.Units.Rarities[r] == true
        createToggle(UnitsTab, "  Transfer: " .. r, isEnabled, function(val)
            Config.Units.Rarities[r] = val
        end)
    end
end

-- 4.3 Tokens & Spins Tab
do
    createToggle(TokensTab, "Transfer Gems", Config.Tokens.Gems.Enabled, function(val)
        Config.Tokens.Gems.Enabled = val
    end)
    createTextInput(TokensTab, "Gems Keep Amount (Sisa Disimpan)", Config.Tokens.Gems["Keep Amount"], function(val)
        Config.Tokens.Gems["Keep Amount"] = tonumber(val) or 0
    end)

    createToggle(TokensTab, "Transfer Trait Rerolls", Config.Tokens["Trait Reroll"].Enabled, function(val)
        Config.Tokens["Trait Reroll"].Enabled = val
    end)
    createTextInput(TokensTab, "Trait Reroll Keep Amount", Config.Tokens["Trait Reroll"]["Keep Amount"], function(val)
        Config.Tokens["Trait Reroll"]["Keep Amount"] = tonumber(val) or 0
    end)

    createToggle(TokensTab, "Transfer Lucky Spins", Config.Spins["Lucky Spin"].Enabled, function(val)
        Config.Spins["Lucky Spin"].Enabled = val
    end)
    createTextInput(TokensTab, "Lucky Spin Keep Amount", Config.Spins["Lucky Spin"]["Keep Amount"], function(val)
        Config.Spins["Lucky Spin"]["Keep Amount"] = tonumber(val) or 0
    end)

    createToggle(TokensTab, "Transfer Jackpot Spins", Config.Spins["Jackpot Spin"].Enabled, function(val)
        Config.Spins["Jackpot Spin"].Enabled = val
    end)
    createTextInput(TokensTab, "Jackpot Spin Keep Amount", Config.Spins["Jackpot Spin"]["Keep Amount"], function(val)
        Config.Spins["Jackpot Spin"]["Keep Amount"] = tonumber(val) or 0
    end)
end

-- 4.4 Settings & Hop Tab
do
    createToggle(SettingsTab, "Stop Trade Saat Kosong (Hentikan Jika Habis)", Config.Settings["Stop When Empty"], function(val)
        Config.Settings["Stop When Empty"] = val
    end)

    createTextInput(SettingsTab, "Offer Delay (detik per unit)", Config.Settings["Offer Delay"], function(val)
        Config.Settings["Offer Delay"] = tonumber(val) or 0.3
    end)

    createTextInput(SettingsTab, "Ready Wait Time (detik)", Config.Settings["Ready Wait Time"], function(val)
        Config.Settings["Ready Wait Time"] = tonumber(val) or 1.0
    end)

    createToggle(SettingsTab, "Server Hop via JobFile (Sinkronisasi Alt)", Config.Hop["Use JobFile"], function(val)
        Config.Hop["Use JobFile"] = val
        Config.Hop.Enabled = val
        saveConfig()
    end)

    createToggle(SettingsTab, "Receiver Auto Hop If Full (Server Penuh)", Config.Hop["Receiver Auto Hop If Full"], function(val)
        Config.Hop["Receiver Auto Hop If Full"] = val
        if val then Config.Hop.Enabled = true end
        saveConfig()
    end)

    createTextInput(SettingsTab, "Max Players Threshold", Config.Hop["Max Players Threshold"], function(val)
        Config.Hop["Max Players Threshold"] = tonumber(val) or 8
        saveConfig()
    end)

    createButton(SettingsTab, "🚀 Hop ke Server Paling Sepi Sekarang", THEME.Cyan, function()
        hopToLowestServer()
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
local LogContainer = nil
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

local function addLog(text, color)
    print("[DuckHub] " .. text)
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
        l.Text = string.format("[%s] %s", timeStr, text)
        l.Parent = LogContainer
        LogContainer.CanvasPosition = Vector2.new(0, 999999)
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
                local catAllowed = table.find(Config.Boosts.Categories or {}, cat) ~= nil

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

local function hasItemsToSend()
    local units = getEligibleUnits()
    if #units > 0 then return true end

    local tokens = getEligibleTokens()
    if #tokens > 0 then return true end

    local boosts = getEligibleBoosts()
    if #boosts > 0 then return true end

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

-- Trade Network Events Hook
TradeEventRemote.OnClientEvent:Connect(function(eventType, payload)
    if not Config.Enabled then return end
    local role = getRole()

    if eventType == "RequestReceived" then
        local sender = payload and payload.player
        if not sender then return end

        if role == "Receiver" then
            if isAllowedSender(sender.Name) then
                addLog("Menerima request trade dari: " .. sender.Name, THEME.Green)
                RespondToRequestRemote:FireServer(true)
            else
                addLog("Menolak request trade dari non-whitelist: " .. sender.Name, THEME.Red)
                RespondToRequestRemote:FireServer(false)
            end
        else
            if sender.Name:lower() == (Config.Receiver or ""):lower() then
                if Config.Settings and Config.Settings["Stop When Empty"] and not hasItemsToSend() then
                    addLog("Menolak trade dari Receiver (inventaris kosong).", THEME.TextMuted)
                    RespondToRequestRemote:FireServer(false)
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
        local readyDelay = (Config.Settings and Config.Settings["Ready Wait Time"]) or 1.0

        if role == "Sender" and not isProcessingOffer then
            if phase == "Offer" and not ownReady and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(readyDelay)
                    if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                        addLog("Sender menekan READY...", THEME.Cyan)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(readyDelay)
                    if inTradeSession and activeTradeData and not activeTradeData.ownAccepted then
                        addLog("Sender menekan CONFIRM ACCEPT...", THEME.Green)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            end
        end

        if role == "Receiver" then
            if phase == "Offer" and not ownReady and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(0.5)
                    if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                        addLog("Receiver menekan READY...", THEME.Cyan)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(0.5)
                    if inTradeSession and activeTradeData and not activeTradeData.ownAccepted then
                        addLog("Receiver menekan CONFIRM...", THEME.Green)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
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
        StatusBadge.Text = role:upper() .. " [IDLE]"
        StatusBadge.TextColor3 = THEME.Cyan

        if role == "Sender" then
            task.spawn(function()
                task.wait(2)
                triggerFarmerV5Switch("Trade Selesai")
            end)
        end
        return
    end
end)

-- Server Hop & Request Engine Loop
task.spawn(function()
    while task.wait(3) do
        if not Config.Enabled then continue end
        local role = getRole()

        if role == "Receiver" then
            pcall(function()
                if writefile then
                    writefile(JOB_FILE, game.JobId)
                end
            end)

            if not isHopping and not inTradeSession and Config.Hop and Config.Hop["Receiver Auto Hop If Full"] then
                local threshold = tonumber(Config.Hop["Max Players Threshold"]) or 8
                local currentPlayers = #Players:GetPlayers()
                if currentPlayers >= threshold then
                    local hopDelay = tonumber(Config.Hop["Hop Delay"]) or 5
                    addLog("Server penuh (" .. currentPlayers .. "/" .. Players.MaxPlayers .. " >= " .. threshold .. "). Menunggu " .. hopDelay .. " detik sebelum hop ke server sepi...", THEME.Accent)
                    task.wait(hopDelay)
                    if not inTradeSession then
                        hopToLowestServer()
                    end
                end
            end
        else
            if not inTradeSession and (Config.Settings and Config.Settings["Auto Loop Trade"]) then
                local invLoaded = false
                pcall(function()
                    invLoaded = (DataController and DataController.Inventory and DataController.Inventory() ~= nil)
                end)

                if invLoaded and (tick() - scriptStartTime >= 6) and (not hasItemsToSend()) then
                    if tick() - lastEmptyNoticeTime >= 15 then
                        lastEmptyNoticeTime = tick()
                        StatusBadge.Text = role:upper() .. " [KOSONG]"
                        StatusBadge.TextColor3 = THEME.TextMuted
                        addLog("Inventaris kosong. Mengirim sinyal ganti akun ke FarmerV5...", THEME.TextMuted)
                    end
                    triggerFarmerV5Switch("Inventaris Kosong")
                else
                    local recPlayer = Players:FindFirstChild(Config.Receiver)
                    if recPlayer then
                        if tick() - lastRequestTime >= 8 then
                            lastRequestTime = tick()
                            addLog("Mengirim trade request ke: " .. Config.Receiver, THEME.TextMuted)
                            RequestTradeRemote:FireServer(recPlayer)
                        end
                    else
                        if not isHopping and Config.Hop and Config.Hop["Use JobFile"] then
                            pcall(function()
                                if isfile and isfile(JOB_FILE) then
                                    local targetJob = readfile(JOB_FILE):gsub("%s+", "")
                                    if targetJob ~= "" and targetJob ~= game.JobId then
                                        isHopping = true
                                        addLog("Receiver di server lain (" .. string.sub(targetJob, 1, 8) .. "). Mengikuti receiver...", THEME.Cyan)
                                        task.wait(2)
                                        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJob, LocalPlayer)
                                        task.wait(12)
                                        isHopping = false
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

addLog("DuckHub UI & Trade Engine siap digunakan!", THEME.Accent)
