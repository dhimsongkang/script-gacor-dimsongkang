_G.hiphub_key = _G.hiphub_key or (getgenv and getgenv().hiphub_key) or "HIPHUB-PREMIUM-E370-53A5"
_G.hiphub_role = _G.hiphub_role or (getgenv and getgenv().hiphub_role) or "Buyer"
_G.hiphub_url = _G.hiphub_url or (getgenv and getgenv().hiphub_url) or "http://localhost:3000"
_G.hiphub_expires_at = 4939282107
if getgenv then getgenv().hiphub_key = _G.hiphub_key end
if getgenv then getgenv().hiphub_role = _G.hiphub_role end
if getgenv then getgenv().hiphub_url = _G.hiphub_url end
if getgenv then getgenv().hiphub_expires_at = _G.hiphub_expires_at end

if _G.hiphub_expires_at and _G.hiphub_expires_at > 0 then
    task.spawn(function()
        while task.wait(30) do
            if os.time() > _G.hiphub_expires_at then
                pcall(function()
                    local coreGui = game:GetService("CoreGui")
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    local function clean(parent)
                        if not parent then return end
                        for _, child in ipairs(parent:GetChildren()) do
                            if child:IsA("ScreenGui") and (string.find(child.Name, "HipHub") or string.find(child.Name, "hiphub")) then
                                child:Destroy()
                            end
                        end
                    end
                    if gethui then clean(gethui()) end
                    clean(coreGui)
                    clean(playerGui)
                end)
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "HipHub",
                        Text = "Key Expired! Please renew subscription at hiphub.cloud",
                        Duration = 10
                    })
                end)
                warn("HipHub: Key has expired. Script terminated.")
                break
            end
        end
    end)
end
do



local HttpService = game:GetService("HttpService")

local Settings = {}
local FOLDER_NAME = "HipHub/AnimeDice"
local FILE_NAME = FOLDER_NAME .. "/config.json"

Settings.Default = {
    
    autoRoll = false,
    instantRoll = false,
    rollDelay = 0.05,
    stopOnRarity = "Celestial",
    autoStopOnRare = false,

    
    autoCollectBalance = false,
    collectDelay = 0.5,
    autoLevelUpSlots = false,
    maxSlotLevel = 0,
    autoEquipBestPlot = false,
    autoLevel50Backpack = false,
    backpackTargetLevel = 50,
    backpackUpgradeSpeed = 0.04,

    
    teamAutoEquip = false,
    teamFocus = "Luck",
    teamAutoEvent = true,

    
    selectedTower = "Pirate Tower",
    autoPlayTower = false,
    instantClearFloor = false,
    autoEquipBestTowerTeam = false,
    autoRepeatTower = false,
    towerShifting = false,
    selectedTowers = {
        ["Pirate Tower"] = true,
        ["Dragon Tower"] = true,
        ["Cursed Tower"] = true,
        ["Hidden Leaf Tower"] = true,
        ["Slayer Tower"] = true,
        ["Shadow Tower"] = true,
        ["Infinity Tower"] = true,
    },
    maxFloorPerTower = 0, 

    
    autoBuyUpgrades = false,
    upgradeFocus = { All = true },
    autoBuyDice = false,
    autoEquipBestDice = false,

    
    autoEquipBestGears = false,
    gearStrategy = "Luck Focus",
    selectedCustomGears = {
        ["Igras's Helm"] = true,
        ["Obita's Mask"] = true,
        ["Mazun's Coat"] = true,
        ["Monarch's Coat"] = true,
        ["Enol's Drums"] = true,
        ["Sakuna's Sash"] = true,
        ["Angel's Halo"] = true,
        ["Obita's War Fan"] = true,
        ["Pikolo's Cape"] = true,
        ["Jogu's Robe"] = true,
        ["Tanjuro's Katana"] = true,
        ["Zaro's Swords"] = true,
        ["Jinwoo's Daggers"] = true,
        ["Golden Hair"] = true,
        ["Nezuka's Bamboo"] = true,
        ["Usop's Hat"] = true,
        ["Todoh's Vest"] = true,
        ["Shizui's Tanto"] = true
    },

    
    backpackEspEnabled = true,
    backpackEspFormat = "Chance (1 in X)",
    backpackEspBadgePosition = "Top Pill Badge",
    backpackEspHighlightRare = true,
    backpackEspShowMutations = true,
    backpackEspMinRarity = "All Rarities",
    autoSell = false,
    autoSellByRarity = false,
    sellRarities = {
        Common = true,
        Uncommon = true,
        Rare = true,
        Epic = false,
        Legendary = false,
        Galactic = false
    },
    autoSellCustom = false,
    autoSellMode = "Below (<=)",
    autoSellThreshold = "0.1",
    autoSellByChance = false,
    autoSellChanceMode = "Below (<=)",
    autoSellChanceThreshold = "1 in 10sx",
    autoLockRare = false,
    lockRarities = {
        Mythical = true,
        Celestial = true,
        Divine = true,
        ["Secret I"] = true,
        ["Secret II"] = true,
        Exotic = true,
        Exclusive = true,
        Heavenly = true,
        Galactic = true
    },
    autoLockCustom = false,
    autoLockMode = "Above (>=)",
    autoLockThreshold = "1",
    autoLockMutated = false,
    autoLockMutatedMode = "By Money/s",
    autoLockMutatedCondition = "Above (>=)",
    autoLockMutatedThreshold = "1",
    mutatedLockRarities = {
        Mythical = true,
        Celestial = true,
        Divine = true,
        ["Secret I"] = true,
        ["Secret II"] = true,
        Exotic = true,
        Exclusive = true,
        Heavenly = true,
        Galactic = true,
        Legendary = true,
        Epic = false,
        Rare = false,
        Uncommon = false,
        Common = false
    },

    
    autoUsePotions = false,
    selectedPotions = {},
    potionInterval = 5,
    potionOnlyWhenExpired = false,

    
    rollUnitSource = "All Units (Plot + Bag)",
    selectedRollUnitKey = "",
    bulkSelectedUnits = {},
    bulkAutoRollBoth = false,
    bulkAutoRollAll = false,
    rollDelayTraitGrade = 0.25,
    autoRollTrait = false,
    targetTrait = "Genesis",
    targetTraits = {
        Genesis = true,
        Paradox = true,
        Eternal = true,
        Transcendent = true,
        Monarch = false,
        Shogun = false
    },
    autoRollGrade = false,
    targetGrade = "Ω",
    targetGrades = {
        ["Ω"] = true,
        ["∞"] = true,
        ["神"] = true,
        ["Z+"] = false,
        ["Z"] = false
    },
    autoRollQuirk = false,
    targetQuirk = "Fortune's Favor",
    targetQuirks = {
        ["Sovereign"] = true,
        ["Fortune's Favor"] = true,
        ["Midas Touch"] = true,
        ["Tycoon"] = true,
        ["Prodigy"] = true,
        ["Fortune III"] = false,
        ["Wealth III"] = false,
        ["Refined III"] = false,
        ["Gifted III"] = false,
        ["Swift III"] = false
    },
    autoProtectQuirks = true,
    autoFuse = false,
    autoFuseByRarity = false,
    autoFuseRarities = {
        Common = true,
        Uncommon = true,
        Rare = true,
        Epic = true,
        Legendary = true,
        Mythical = true,
        Divine = false,
        Exotic = false,
        Celestial = false,
        ["Secret I"] = false,
        ["Secret II"] = false,
        Heavenly = false,
        Galactic = false,
        Exclusive = false
    },
    autoFuseByChance = false,
    autoFuseChanceMode = "Below (<=)",
    autoFuseChanceThreshold = "1 in 10sx",
    autoFuseByMoney = false,
    autoFuseMoneyMode = "Below (<=)",
    autoFuseMoneyThreshold = "0.1",
    autoFuseNeverLocked = true,
    autoFuseNeverMutated = false,
    skipFuseCutscene = true,

    
    autoSendTrade = false,
    selectedTradePlayer = "None",
    autoAcceptTrade = false,
    autoAcceptAnyPlayer = false,
    tradeOfferPotions = false,
    selectedTradePotions = {},
    tradePotionAmount = "All",
    tradeOfferUnitsByRarity = false,
    tradeUnitRarities = {
        Common = true,
        Uncommon = true,
        Rare = true,
        Epic = false,
        Legendary = false,
        Galactic = false
    },
    tradeOfferUnitsByQuirk = false,
    tradeUnitQuirks = {
        ["Any Quirk"] = true,
        ["Sovereign"] = false,
        ["Fortune's Favor"] = false,
        ["Midas Touch"] = false,
        ["Tycoon"] = false,
        ["Prodigy"] = false,
        ["Fortune III"] = false,
        ["Wealth III"] = false,
        ["Refined III"] = false,
        ["Gifted III"] = false,
        ["Swift III"] = false,
        ["Fortune II"] = false,
        ["Wealth II"] = false,
        ["Refined II"] = false,
        ["Gifted II"] = false,
        ["Swift II"] = false,
        ["Fortune I"] = false,
        ["Wealth I"] = false,
        ["Refined I"] = false,
        ["Gifted I"] = false,
        ["Swift I"] = false,
    },
    tradeOnlyOfferQuirks = false,
    tradeOfferUnitsByMoney = false,
    tradeUnitMoneyMode = "Below (<=)",
    tradeUnitMoneyThreshold = "0.1",
    tradeNeverOfferLocked = true,
    tradeNeverOfferMutated = true,
    autoReadyTrade = false,
    autoAcceptTradeFinal = false,

    
    autoClaimDaily = false,
    autoClaimGroup = false,
    autoClaimOffline = false,
    autoClaimQuests = false,
    autoUseSpins = false,
    selectedSpins = {
        ["Jackpot Spin"] = true,
        ["Lucky Spin"] = true
    },
    autoExchangeSpins = false,
    exchangeRecipes = {},
    autoBuyTicketShop = false,
    selectedTicketShopItems = {
        ["Trait Reroll"] = true,
        ["Gems"] = false,
        ["Reset Token"] = false,
        ["Lucky Spin"] = false,
        ["Jackpot Spin"] = false,
        ["Luck"] = false,
        ["Ultra Luck"] = false,
        ["More Cash"] = false,
        ["Roll Speed"] = false,
        ["More Grades"] = false,
        ["More Traits"] = false
    },
    autoRebirth = false,
    autoRebirthStats = false,
    rebirthStatFocus = { Luck = true },

    
    autoTrickOrTreat = false,
    trickOrTreatMethod = "Walk",
    autoPumpkinDice = false,
    autoPumpkinDiceMoon = false,
    autoUseJackpotMoon = false,
    autoUsePotionMoon = false,
    moonPotions = {},
    pumpkinRollAmount = "x5",
    autoBuyCandyShop = false,
    candyShopItems = {},
    autoBuyCandyUpgrades = false,
    candyUpgradeFocusSet = {},
    autoClaimHalloweenQuests = false,
    autoClaimPumpkinPass = false,

    
    walkSpeedEnabled = false,
    walkSpeedValue = 32,
    jumpPowerEnabled = false,
    jumpPowerValue = 70,
    infiniteJump = false,
    noclip = false,
    antiAfk = false,
    hideFloatingMoney = false,
    fpsBooster = false,
    blackScreen = false,
    unlockFps = false,
    capFps3 = false,
    capFps15 = false,

    
    webhookEnabled = false,
    webhookUrl = "",
    webhookNotifyRare = false,
    webhookUnitPullMode = "Above (>=)",
    webhookUnitPullThreshold = "1 in 10t",
    webhookNotifyTower = false,
    webhookNotifyGems = false,
    webhookNotifyTraitPot = false,
    webhookNotifyWeather = false,

    
    autoWeatherHop = false,
    weatherHopTarget = "Luck Event (2.5x Luck)",
    weatherHopMode = "Fewest Players",
    autoHopOnExpire = false,
    autoRollOnWeather = false,
    autoUseLuckPotionOnWeather = false
}

Settings.Current = {}

Settings.Bindings, Settings.Schema = {}, {}

function Settings.CreateControl(key, method, ...)
	local UI = _G.HipHub_AnimeDice_UI
	local args = { ... }
	local callbackIndex = method == "CreateSlider" and 6 or
		((method == "CreateToggle") and 4 or 5)
	local callback = args[callbackIndex]
	local control = UI[method](...)
	local field = {
		key = key,
		label = args[2],
		group = args[1]:GetAttribute("ConfigGroup") or "Automation",
		type = type(Settings.Default[key]),
	}
	if method == "CreateDropdown" or method == "CreateMultiDropdown" then
		field.options = args[3]
	elseif method == "CreateSlider" then
		field.min, field.max = args[3], args[4]
	elseif field.type == "number" then
		field.min = key == "backpackTargetLevel" and 1 or 0
		field.max, field.integer = 1000000, true
	end
	Settings.Bindings[key] = { control = control, callback = callback, method = method, field = field }
	table.insert(Settings.Schema, field)
	if control.Refresh and field.options then
		local refresh = control.Refresh
		control.Refresh = function(options, ...)
			field.options = options
			return refresh(options, ...)
		end
	end
	return control
end

local function validateConfigPatch(patch)
	if type(patch) ~= "table" then return "Settings must be an object." end
	local count = 0
	for key, value in pairs(patch) do
		count = count + 1
		local binding = Settings.Bindings[key]
		if not binding then return "Unsupported setting: " .. tostring(key) end
		local field = binding.field
		if type(value) ~= field.type then return "Invalid type for " .. field.label end
		if field.type == "number" then
			if value ~= value or math.abs(value) == math.huge or
				(field.min and value < field.min) or (field.max and value > field.max) or
				(field.integer and value ~= math.floor(value)) then
				return "Invalid number for " .. field.label
			end
		elseif field.type == "string" then
			if #value > 2048 or (field.options and not table.find(field.options, value)) then
				return "Invalid option for " .. field.label
			end
		elseif field.type == "table" then
			local selections = 0
			for option, selected in pairs(value) do
				selections = selections + 1
				if type(selected) ~= "boolean" or not table.find(field.options or {}, option) then
					return "Invalid selection for " .. field.label
				end
			end
			if selections > 500 then return "Too many selections." end
		end
	end
	if count == 0 or count > 200 then return "Choose between 1 and 200 settings." end
	if patch.capFps3 == true and patch.capFps15 == true then return "Choose one FPS cap." end
	if patch.bulkAutoRollBoth == true and patch.bulkAutoRollAll == true then return "Choose one bulk roll mode." end
	return nil
end

function Settings.ApplyPatch(patch)
	local cfg = Settings.Current
	local invalid = validateConfigPatch(patch)
	if invalid then return false, invalid end
	
	for key, value in pairs(patch) do cfg[key] = value end
	
	for pass = 1, 2 do
		for _, field in ipairs(Settings.Schema) do
			local value = patch[field.key]
			if value ~= nil and ((value == true) == (pass == 2)) then
				local binding = Settings.Bindings[field.key]
				local argument = binding.method == "CreateTextBox" and tostring(value) or value
				local ok, failure = pcall(binding.callback, argument)
				if not ok then return false, field.label .. ": " .. tostring(failure) end
			end
		end
	end
	
	for key, binding in pairs(Settings.Bindings) do
		pcall(binding.control.Set, cfg[key])
	end
	local saved, saveError = Settings.Save()
	if saved == false then return false, "Settings applied, but local save failed: " .. tostring(saveError) end
	return true
end


local function deepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Settings.Init()
    Settings.Current = deepCopy(Settings.Default)
    Settings.Load()
end

function Settings.Save()
    if not isfolder or not writefile or not makefolder then
        return false, "Executor file saving is unavailable."
    end
    return pcall(function()
        if not isfolder("HipHub") then
            makefolder("HipHub")
        end
        if not isfolder(FOLDER_NAME) then
            makefolder(FOLDER_NAME)
        end
        local encoded = HttpService:JSONEncode(Settings.Current)
        writefile(FILE_NAME, encoded)
    end)
end

function Settings.Load()
    pcall(function()
        if not isfile or not readfile then return end
        if isfile(FILE_NAME) then
            local content = readfile(FILE_NAME)
            local decoded = HttpService:JSONDecode(content)
            if decoded and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if type(v) == "table" and type(Settings.Current[k]) == "table" then
                        table.clear(Settings.Current[k])
                        for subK, subV in pairs(v) do
                            Settings.Current[k][subK] = subV
                        end
                    else
                        Settings.Current[k] = v
                    end
                end
            end
        end
    end)
end

function Settings.Reset()
    table.clear(Settings.Current)
    for key, value in pairs(deepCopy(Settings.Default)) do
        Settings.Current[key] = value
    end
    Settings.Save()
end

Settings.Init()

_G.HipHub_AnimeDice_Settings = Settings

end

do





if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
while not player do
	task.wait(0.5)
	player = Players.LocalPlayer
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

player:WaitForChild("PlayerGui")




local COLORS = {
	glassPrimary  = Color3.fromRGB(10, 12, 24),
	glassSurface  = Color3.fromRGB(16, 20, 36),
	glassCard     = Color3.fromRGB(20, 24, 44),
	glassHover    = Color3.fromRGB(28, 34, 58),
	glassActive   = Color3.fromRGB(34, 40, 68),
	accentCyan    = Color3.fromRGB(0, 200, 255),
	accentViolet  = Color3.fromRGB(140, 120, 255),
	accentBlend   = Color3.fromRGB(80, 160, 255),
	accentGlow    = Color3.fromRGB(60, 180, 255),
	accentMuted   = Color3.fromRGB(50, 60, 100),
	toggleOn      = Color3.fromRGB(0, 180, 230),
	toggleOff     = Color3.fromRGB(40, 46, 70),
	textPrimary   = Color3.fromRGB(225, 235, 255),
	textSecondary = Color3.fromRGB(140, 155, 185),
	textMuted     = Color3.fromRGB(90, 105, 135),
	textWhite     = Color3.fromRGB(255, 255, 255),
	borderGlass   = Color3.fromRGB(50, 65, 110),
	borderGlow    = Color3.fromRGB(0, 180, 255),
	dangerRed     = Color3.fromRGB(255, 80, 80),
	successGreen  = Color3.fromRGB(60, 230, 120),
	shadow        = Color3.fromRGB(2, 3, 8),
}

local TRANSPARENCY = {
	glassMain    = 0.02,
	glassSurface = 0.05,
	glassCard    = 0.08,
	glassSidebar = 0.04,
	glassTopBar  = 0.03,
	border       = 0.55,
	borderGlow   = 0.35,
}

local CORNER = {
	large  = UDim.new(0, 14),
	medium = UDim.new(0, 10),
	small  = UDim.new(0, 6),
	pill   = UDim.new(1, 0),
}




local function findOldGui(name)
	local p = player:FindFirstChild("PlayerGui")
	if p then
		local g = p:FindFirstChild(name)
		if g then return g end
	end
	if gethui then
		local ok, g = pcall(function() return gethui():FindFirstChild(name) end)
		if ok and g then return g end
	end
	local okCore, c = pcall(function() return game:GetService("CoreGui"):FindFirstChild(name) end)
	if okCore and c then return c end
	return nil
end

local oldGuis = { "HipHub_DA_UI", "HipHub", "HipHubError" }
for _, name in ipairs(oldGuis) do
	local old = findOldGui(name)
	if old then
		pcall(function() old:Destroy() end)
	end
end




local function applyGlass(frame, opts)
	opts = opts or {}
	local corner = Instance.new("UICorner")
	corner.CornerRadius = opts.corner or CORNER.medium
	corner.Parent = frame

	if opts.stroke then
		local stroke = Instance.new("UIStroke")
		stroke.Color = opts.strokeColor or COLORS.borderGlass
		stroke.Thickness = opts.strokeThickness or 1
		stroke.Transparency = opts.strokeTransparency or TRANSPARENCY.border
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = frame
	end

	if opts.gradient then
		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 190, 220)),
		})
		grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(0.5, 0.12),
			NumberSequenceKeypoint.new(1, 0.03),
		})
		grad.Rotation = opts.gradientRotation or 135
		grad.Parent = frame
	end
end

local function applyPadding(parent, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.Parent = parent
	return p
end

local function applyListLayout(parent, padding, sortOrder)
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, padding or 6)
	layout.Parent = parent
	return layout
end




local parentGui = player:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui")
gui.Name = "HipHub_DA_UI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 2147483647
pcall(function() gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
pcall(function()
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
	elseif protectgui then
		protectgui(gui)
	elseif protect_gui then
		protect_gui(gui)
	end
end)
gui.Parent = parentGui




local defaultWidth = 560
local defaultHeight = 380

local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "ShadowBacking"
shadowFrame.Size = UDim2.new(0, defaultWidth + 12, 0, defaultHeight + 12)
shadowFrame.Position = UDim2.new(0.5, -(defaultWidth + 12) / 2, 0.5, -(defaultHeight + 12) / 2)
shadowFrame.BackgroundColor3 = COLORS.shadow
shadowFrame.BackgroundTransparency = 0.45
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = 0
shadowFrame.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadowFrame

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, defaultWidth, 0, defaultHeight)
mainFrame.Position = UDim2.new(0.5, -defaultWidth / 2, 0.5, -defaultHeight / 2)
mainFrame.BackgroundColor3 = COLORS.glassPrimary
mainFrame.BackgroundTransparency = TRANSPARENCY.glassMain
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

applyGlass(mainFrame, {
	corner = CORNER.large,
	stroke = true,
	strokeColor = COLORS.borderGlow,
	strokeThickness = 1.5,
	strokeTransparency = TRANSPARENCY.borderGlow,
	gradient = true,
	gradientRotation = 145,
})

local function syncShadow()
	if shadowFrame and mainFrame then
		shadowFrame.Position = UDim2.new(
			mainFrame.Position.X.Scale, mainFrame.Position.X.Offset - 6,
			mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset - 6
		)
		shadowFrame.Size = UDim2.new(
			mainFrame.Size.X.Scale, mainFrame.Size.X.Offset + 12,
			mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset + 12
		)
		shadowFrame.Visible = mainFrame.Visible
	end
end
syncShadow()


local mainStroke = mainFrame:FindFirstChildOfClass("UIStroke")
if mainStroke then
	task.spawn(function()
		while mainFrame and mainFrame.Parent do
			TweenService:Create(mainStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Color = COLORS.accentViolet
			}):Play()
			task.wait(2.5)
			if not mainFrame or not mainFrame.Parent then break end
			TweenService:Create(mainStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Color = COLORS.accentCyan
			}):Play()
			task.wait(2.5)
		end
	end)
end


local glassHighlight = Instance.new("Frame")
glassHighlight.Name = "GlassHighlight"
glassHighlight.Size = UDim2.new(1, 0, 0, 60)
glassHighlight.Position = UDim2.new(0, 0, 0, 0)
glassHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassHighlight.BackgroundTransparency = 0.96
glassHighlight.BorderSizePixel = 0
glassHighlight.ZIndex = 1
glassHighlight.Parent = mainFrame

local highlightGrad = Instance.new("UIGradient")
highlightGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.90),
	NumberSequenceKeypoint.new(1, 1),
})
highlightGrad.Rotation = 180
highlightGrad.Parent = glassHighlight


local uiScale = Instance.new("UIScale")
uiScale.Parent = mainFrame

local shadowScale = Instance.new("UIScale")
shadowScale.Parent = shadowFrame

local function updateScale()
	local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 600)
	local scale = 1.0
	if vp.X < 620 or vp.Y < 420 then
		local scaleX = math.clamp((vp.X - 24) / defaultWidth, 0.50, 1.0)
		local scaleY = math.clamp((vp.Y - 24) / defaultHeight, 0.50, 1.0)
		scale = math.min(scaleX, scaleY)
	end
	uiScale.Scale = scale
	shadowScale.Scale = scale
end

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end
updateScale()




local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = COLORS.glassSurface
topBar.BackgroundTransparency = TRANSPARENCY.glassTopBar
topBar.BorderSizePixel = 0
topBar.ZIndex = 2
topBar.Parent = mainFrame

applyGlass(topBar, { corner = CORNER.large })

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 14)
topBarCover.Position = UDim2.new(0, 0, 1, -14)
topBarCover.BackgroundColor3 = COLORS.glassSurface
topBarCover.BackgroundTransparency = TRANSPARENCY.glassTopBar
topBarCover.BorderSizePixel = 0
topBarCover.ZIndex = 2
topBarCover.Parent = topBar

local topBarAccent = Instance.new("Frame")
topBarAccent.Size = UDim2.new(1, 0, 0, 1)
topBarAccent.Position = UDim2.new(0, 0, 1, -1)
topBarAccent.BackgroundColor3 = COLORS.accentCyan
topBarAccent.BackgroundTransparency = 0.7
topBarAccent.BorderSizePixel = 0
topBarAccent.ZIndex = 3
topBarAccent.Parent = topBar

local accentGrad = Instance.new("UIGradient")
accentGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLORS.accentCyan),
	ColorSequenceKeypoint.new(0.5, COLORS.accentViolet),
	ColorSequenceKeypoint.new(1, COLORS.accentCyan),
})
accentGrad.Parent = topBarAccent

local titleLogo = Instance.new("ImageLabel")
titleLogo.Name = "TitleLogo"
titleLogo.Size = UDim2.new(0, 24, 0, 24)
titleLogo.Position = UDim2.new(0, 14, 0.5, -12)
titleLogo.BackgroundTransparency = 1
titleLogo.BorderSizePixel = 0
titleLogo.ZIndex = 3
titleLogo.Parent = topBar

local hubTitle = Instance.new("TextLabel")
hubTitle.Name = "HubTitle"
hubTitle.Size = UDim2.new(0, 72, 1, 0)
hubTitle.Position = UDim2.new(0, 46, 0, 0)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "HipHub"
hubTitle.TextColor3 = COLORS.textWhite
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextSize = 16
hubTitle.TextXAlignment = Enum.TextXAlignment.Left
hubTitle.ZIndex = 3
hubTitle.Parent = topBar

local badge = Instance.new("TextLabel")
badge.Name = "GameBadge"
badge.Size = UDim2.new(0, 115, 0, 22)
badge.Position = UDim2.new(0, 126, 0.5, -11)
badge.BackgroundColor3 = COLORS.accentViolet
badge.BackgroundTransparency = 0.25
badge.Text = "Anime Dice"
badge.TextColor3 = COLORS.textWhite
badge.Font = Enum.Font.GothamBold
badge.TextSize = 10
badge.ZIndex = 3
badge.Parent = topBar

applyGlass(badge, {
	corner = CORNER.pill,
	stroke = true,
	strokeColor = COLORS.accentViolet,
	strokeThickness = 1,
	strokeTransparency = 0.5
})

local fpsBadge = Instance.new("TextLabel")
fpsBadge.Name = "FpsBadge"
fpsBadge.Size = UDim2.new(0, 62, 0, 22)
fpsBadge.Position = UDim2.new(1, -172, 0.5, -11)
fpsBadge.BackgroundColor3 = COLORS.glassSurface
fpsBadge.BackgroundTransparency = 0.25
fpsBadge.Text = "60 FPS"
fpsBadge.TextColor3 = COLORS.accentCyan
fpsBadge.Font = Enum.Font.GothamBold
fpsBadge.TextSize = 10
fpsBadge.ZIndex = 3
fpsBadge.Parent = topBar

applyGlass(fpsBadge, {
	corner = CORNER.pill,
	stroke = true,
	strokeColor = COLORS.accentCyan,
	strokeThickness = 1,
	strokeTransparency = 0.5
})

local fpsStroke = fpsBadge:FindFirstChildOfClass("UIStroke")
local liveFps = 60
local fpsSum = 0
local fpsCount = 0
local lastFpsUpdate = 0
RunService.RenderStepped:Connect(function(dt)
	if dt > 0 then
		fpsSum = fpsSum + (1 / dt)
		fpsCount = fpsCount + 1
		if fpsCount >= 8 then
			liveFps = math.clamp(math.floor(fpsSum / fpsCount), 1, 999)
			fpsSum = 0
			fpsCount = 0
			local now = tick()
			if now - lastFpsUpdate >= 0.35 then
				lastFpsUpdate = now
				if fpsBadge and fpsBadge.Parent then
					local col = (liveFps >= 50 and COLORS.accentCyan)
						or (liveFps >= 30 and Color3.fromRGB(255, 200, 50))
						or Color3.fromRGB(255, 80, 80)
					fpsBadge.Text = string.format("%d FPS", liveFps)
					fpsBadge.TextColor3 = col
					if fpsStroke then fpsStroke.Color = col end
				end
			end
		end
	end
end)

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -38, 0.5, -15)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = COLORS.textSecondary
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.ZIndex = 3
closeButton.Parent = topBar

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.dangerRed }):Play()
end)
closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.textSecondary }):Play()
end)

local fullscreenButton = Instance.new("TextButton")
fullscreenButton.Name = "FullscreenButton"
fullscreenButton.Size = UDim2.new(0, 30, 0, 30)
fullscreenButton.Position = UDim2.new(1, -70, 0.5, -15)
fullscreenButton.BackgroundTransparency = 1
fullscreenButton.Text = "[]"
fullscreenButton.TextColor3 = COLORS.textSecondary
fullscreenButton.Font = Enum.Font.GothamBold
fullscreenButton.TextSize = 12
fullscreenButton.ZIndex = 3
fullscreenButton.Parent = topBar

local isFullscreen = false
local defaultSize = mainFrame.Size
local defaultPos = mainFrame.Position
fullscreenButton.MouseButton1Click:Connect(function()
	isFullscreen = not isFullscreen
	if isFullscreen then
		mainFrame.Size = UDim2.new(0.92, 0, 0.90, 0)
		mainFrame.Position = UDim2.new(0.04, 0, 0.05, 0)
	else
		mainFrame.Size = defaultSize
		mainFrame.Position = defaultPos
	end
	syncShadow()
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -102, 0.5, -15)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = COLORS.textSecondary
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.ZIndex = 3
minimizeButton.Parent = topBar

pcall(function()
	minimizeButton.MouseEnter:Connect(function()
		TweenService:Create(minimizeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.accentCyan }):Play()
	end)
	minimizeButton.MouseLeave:Connect(function()
		TweenService:Create(minimizeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.textSecondary }):Play()
	end)
end)


local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
		syncShadow()
	end
end)




local resizeGrip = Instance.new("TextButton")
resizeGrip.Name = "ResizeGrip"
resizeGrip.Size = UDim2.new(0, 24, 0, 24)
resizeGrip.Position = UDim2.new(1, -24, 1, -24)
resizeGrip.BackgroundTransparency = 1
resizeGrip.Text = ""
resizeGrip.AutoButtonColor = false
resizeGrip.Active = true
resizeGrip.ZIndex = 100
resizeGrip.Parent = mainFrame

local gripContainer = Instance.new("Frame")
gripContainer.Name = "GripContainer"
gripContainer.Size = UDim2.new(1, 0, 1, 0)
gripContainer.BackgroundTransparency = 1
gripContainer.ZIndex = 101
gripContainer.Parent = resizeGrip

local function createGripLine(offset, length)
	local line = Instance.new("Frame")
	line.Size = UDim2.new(0, length, 0, 2)
	line.Position = UDim2.new(1, -offset, 1, -offset)
	line.AnchorPoint = Vector2.new(1, 1)
	line.Rotation = 45
	line.BackgroundColor3 = COLORS.accentCyan
	line.BackgroundTransparency = 0.5
	line.BorderSizePixel = 0
	line.ZIndex = 102
	line.Parent = gripContainer

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = line
	return line
end

local gLine1 = createGripLine(4, 5)
local gLine2 = createGripLine(8, 10)
local gLine3 = createGripLine(12, 15)

local isResizing = false
local resizeStartPos = nil
local resizeStartDims = nil

local function setGripGlow(active)
	local trans = active and 0.05 or 0.5
	local col = active and Color3.fromRGB(120, 235, 255) or COLORS.accentCyan
	TweenService:Create(gLine1, TweenInfo.new(0.15), { BackgroundTransparency = trans, BackgroundColor3 = col }):Play()
	TweenService:Create(gLine2, TweenInfo.new(0.15), { BackgroundTransparency = trans, BackgroundColor3 = col }):Play()
	TweenService:Create(gLine3, TweenInfo.new(0.15), { BackgroundTransparency = trans, BackgroundColor3 = col }):Play()
end

resizeGrip.MouseEnter:Connect(function()
	setGripGlow(true)
end)

resizeGrip.MouseLeave:Connect(function()
	if not isResizing then
		setGripGlow(false)
	end
end)

resizeGrip.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isResizing = true
		resizeStartPos = input.Position
		local scale = (uiScale and uiScale.Scale > 0) and uiScale.Scale or 1.0
		local curW = mainFrame.Size.X.Offset > 0 and mainFrame.Size.X.Offset or (mainFrame.AbsoluteSize.X / scale)
		local curH = mainFrame.Size.Y.Offset > 0 and mainFrame.Size.Y.Offset or (mainFrame.AbsoluteSize.Y / scale)
		resizeStartDims = Vector2.new(curW, curH)
		setGripGlow(true)

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				isResizing = false
				setGripGlow(false)
				syncShadow()
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - resizeStartPos
		local scale = (uiScale and uiScale.Scale > 0) and uiScale.Scale or 1.0
		local deltaX = delta.X / scale
		local deltaY = delta.Y / scale

		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
		local minW = 460
		local minH = 280
		local maxW = math.max(minW, math.floor(vp.X / scale - 30))
		local maxH = math.max(minH, math.floor(vp.Y / scale - 30))

		local newW = math.clamp(math.floor(resizeStartDims.X + deltaX), minW, maxW)
		local newH = math.clamp(math.floor(resizeStartDims.Y + deltaY), minH, maxH)

		mainFrame.Size = UDim2.new(0, newW, 0, newH)
		defaultSize = mainFrame.Size
		isFullscreen = false
		syncShadow()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if isResizing then
			isResizing = false
			setGripGlow(false)
			syncShadow()
		end
	end
end)




local restoreButton = Instance.new("ImageButton")
restoreButton.Name = "RestoreButton"
restoreButton.Size = UDim2.new(0, 48, 0, 48)
restoreButton.Position = UDim2.new(1, -68, 1, -68)
restoreButton.BackgroundColor3 = COLORS.glassSurface
restoreButton.BackgroundTransparency = 0.15
restoreButton.BorderSizePixel = 0
restoreButton.Visible = false
restoreButton.ZIndex = 50
restoreButton.Parent = gui

local restCorner = Instance.new("UICorner")
restCorner.CornerRadius = CORNER.pill
restCorner.Parent = restoreButton

local restStroke = Instance.new("UIStroke")
restStroke.Color = COLORS.accentCyan
restStroke.Thickness = 1.5
restStroke.Transparency = 0.3
restStroke.Parent = restoreButton

local restText = Instance.new("TextLabel")
restText.Name = "RestText"
restText.Size = UDim2.new(1, 0, 1, 0)
restText.BackgroundTransparency = 1
restText.Text = "Hip"
restText.TextColor3 = COLORS.accentCyan
restText.Font = Enum.Font.GothamBold
restText.TextSize = 12
restText.ZIndex = 51
restText.Parent = restoreButton

local function loadLogos()
	local getAsset = getcustomasset or getsynasset
	if getAsset then
		local hasDiskFile = false
		pcall(function()
			if isfile then
				hasDiskFile = isfile("LOGO_H_6.png")
			else
				hasDiskFile = true
			end
		end)

		if hasDiskFile then
			local ok, imgPath = pcall(function() return getAsset("LOGO_H_6.png") end)
			if ok and imgPath and imgPath ~= "" then
				restoreButton.Image = imgPath
				if titleLogo then
					titleLogo.Image = imgPath
				end
				restText.Visible = false
				return true
			end
		end
	end
	return false
end

pcall(function()
	local filename = "LOGO_H_6.png"
	local hasFile = false
	if isfile then
		pcall(function() hasFile = isfile(filename) end)
	end

	if not hasFile and writefile then
		task.spawn(function()
			local urls = {
				"https://hiphub.cloud/LOGO_H_6.png",
				"https://raw.githubusercontent.com/muhammadrafihq/gag-2/main/public/LOGO_H_6.png"
			}
			for _, url in ipairs(urls) do
				local ok, body = pcall(function()
					if game.HttpGet then
						return game:HttpGet(url)
					end
					local req = request or http_request or (syn and syn.request) or (http and http.request)
					if req then
						local res = req({ Url = url, Method = "GET" })
						return res and res.Body
					end
				end)

				if ok and body and #body > 0 then
					pcall(function()
						writefile(filename, body)
						task.wait(0.1)
						loadLogos()
					end)
					break
				end
			end
		end)
	end
end)

loadLogos()


task.spawn(function()
	while restoreButton and restoreButton.Parent do
		if restoreButton.Visible then
			TweenService:Create(restStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.7,
				Color = COLORS.accentViolet,
			}):Play()
			task.wait(1.2)
			if restoreButton and restoreButton.Visible then
				TweenService:Create(restStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Transparency = 0.2,
					Color = COLORS.accentCyan,
				}):Play()
				task.wait(1.2)
			end
		else
			task.wait(0.5)
		end
	end
end)


local rDragging, rDragInput, rDragStart, rStartPos, rDidDrag
restoreButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		rDragging = true
		rDidDrag = false
		rDragStart = input.Position
		rStartPos = restoreButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				rDragging = false
			end
		end)
	end
end)
restoreButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		rDragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == rDragInput and rDragging then
		local delta = input.Position - rDragStart
		if delta.Magnitude > 4 then
			rDidDrag = true
		end
		restoreButton.Position = UDim2.new(
			rStartPos.X.Scale, rStartPos.X.Offset + delta.X,
			rStartPos.Y.Scale, rStartPos.Y.Offset + delta.Y
		)
	end
end)

local function minimizeUI(instant)
	if instant then
		mainFrame.Visible = false
		shadowFrame.Visible = false
		restoreButton.Visible = true
	else
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(shadowFrame, tweenInfo, { BackgroundTransparency = 1 }):Play()
		task.delay(0.2, function()
			mainFrame.Visible = false
			shadowFrame.Visible = false
			mainFrame.BackgroundTransparency = TRANSPARENCY.glassMain
			shadowFrame.BackgroundTransparency = 0.45
			restoreButton.Visible = true
		end)
	end
end

local function restoreUI()
	restoreButton.Visible = false
	mainFrame.Visible = true
	shadowFrame.Visible = true
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	mainFrame.BackgroundTransparency = 0.5
	TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = TRANSPARENCY.glassMain }):Play()
end

minimizeButton.MouseButton1Click:Connect(function()
	minimizeUI(false)
end)

closeButton.MouseButton1Click:Connect(function()
	minimizeUI(false)
end)

restoreButton.MouseButton1Click:Connect(function()
	if not rDidDrag then
		restoreUI()
	end
end)




local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -42)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = COLORS.glassSurface
sidebar.BackgroundTransparency = TRANSPARENCY.glassSidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 1
sidebar.Parent = mainFrame
sidebarInstance = sidebar

applyGlass(sidebar, { corner = CORNER.large })

local sidebarCover = Instance.new("Frame")
sidebarCover.Size = UDim2.new(0, 14, 1, 0)
sidebarCover.Position = UDim2.new(1, -14, 0, 0)
sidebarCover.BackgroundColor3 = COLORS.glassSurface
sidebarCover.BackgroundTransparency = TRANSPARENCY.glassSidebar
sidebarCover.BorderSizePixel = 0
sidebarCover.ZIndex = 1
sidebarCover.Parent = sidebar

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, -56)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.ScrollBarImageColor3 = COLORS.accentCyan
tabContainer.ScrollBarImageTransparency = 0.8
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContainer.ZIndex = 2
tabContainer.Parent = sidebar

applyListLayout(tabContainer, 3)
applyPadding(tabContainer, 8, 8, 8, 4)


local profileCard = Instance.new("Frame")
profileCard.Name = "UserProfile"
profileCard.Size = UDim2.new(1, -16, 0, 44)
profileCard.Position = UDim2.new(0, 8, 1, -52)
profileCard.BackgroundColor3 = COLORS.glassCard
profileCard.BackgroundTransparency = TRANSPARENCY.glassCard
profileCard.BorderSizePixel = 0
profileCard.ZIndex = 2
profileCard.Parent = sidebar

applyGlass(profileCard, {
	corner = CORNER.small,
	stroke = true,
	strokeColor = COLORS.borderGlass,
	strokeThickness = 1,
	strokeTransparency = 0.7
})

local avatarLabel = Instance.new("ImageLabel")
avatarLabel.Name = "AvatarLabel"
avatarLabel.Size = UDim2.new(0, 28, 0, 28)
avatarLabel.Position = UDim2.new(0, 8, 0.5, -14)
avatarLabel.BackgroundColor3 = COLORS.glassHover
avatarLabel.BorderSizePixel = 0
avatarLabel.ZIndex = 3
avatarLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
avatarLabel.Parent = profileCard

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = CORNER.pill
avatarCorner.Parent = avatarLabel

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = COLORS.accentCyan
avatarStroke.Thickness = 1
avatarStroke.Transparency = 0.5
avatarStroke.Parent = avatarLabel

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Name = "UsernameLabel"
usernameLabel.Size = UDim2.new(1, -48, 1, 0)
usernameLabel.Position = UDim2.new(0, 42, 0, 0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = player.DisplayName or player.Name
usernameLabel.TextColor3 = COLORS.textPrimary
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 11
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
usernameLabel.ZIndex = 3
usernameLabel.Parent = profileCard




local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -160, 1, -42)
contentArea.Position = UDim2.new(0, 160, 0, 42)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 1
contentArea.Parent = mainFrame
contentAreaInstance = contentArea




local dropdownDismissArea = Instance.new("TextButton")
dropdownDismissArea.Name = "DropdownDismissArea"
dropdownDismissArea.Size = UDim2.new(1, 0, 1, 0)
dropdownDismissArea.Position = UDim2.new(0, 0, 0, 0)
dropdownDismissArea.BackgroundTransparency = 1
dropdownDismissArea.Text = ""
dropdownDismissArea.Visible = false
dropdownDismissArea.ZIndex = 499
dropdownDismissArea.Parent = mainFrame

local activeOverlay = nil
local function closeDropdowns()
	if activeOverlay then
		activeOverlay.Visible = false
	end
	activeOverlay = nil
	dropdownDismissArea.Visible = false
end
dropdownDismissArea.MouseButton1Click:Connect(closeDropdowns)




local tabs = {}
local activeTab = nil

local function createTabContent(name)
	local frame = Instance.new("ScrollingFrame")
	frame.Name = "Tab_" .. name
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
	frame.ScrollBarImageColor3 = COLORS.accentCyan
	frame.ScrollBarImageTransparency = 0.4
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.ClipsDescendants = true
	frame.Visible = false
	frame.ZIndex = 2
	frame.Parent = contentArea

	applyPadding(frame, 14, 14, 14, 14)
	applyListLayout(frame, 8)
	return frame
end

local function selectTab(tabName)
	for name, data in pairs(tabs) do
		if name == tabName then
			data.Frame.Visible = true
			if data.Button then
				TweenService:Create(data.Button, TweenInfo.new(0.2), {
					BackgroundColor3 = COLORS.glassActive,
					BackgroundTransparency = 0.15,
				}):Play()
				pcall(function()
					data.Button.TextColor3 = COLORS.textWhite
					data.Button.Font = Enum.Font.GothamBold
				end)
			end
			if data.Indicator then
				data.Indicator.Visible = true
				TweenService:Create(data.Indicator, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
			end
		else
			data.Frame.Visible = false
			if data.Button then
				TweenService:Create(data.Button, TweenInfo.new(0.2), {
					BackgroundColor3 = COLORS.glassSurface,
					BackgroundTransparency = 1,
				}):Play()
				pcall(function()
					data.Button.TextColor3 = COLORS.textSecondary
					data.Button.Font = Enum.Font.GothamMedium
				end)
			end
			if data.Indicator then
				TweenService:Create(data.Indicator, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
				task.delay(0.15, function()
					if activeTab ~= name and data.Indicator then
						data.Indicator.Visible = false
					end
				end)
			end
		end
	end
	activeTab = tabName
	closeDropdowns()
end

local function addTab(name, layoutOrder)
	local button = Instance.new("TextButton")
	button.Name = "Nav_" .. name
	button.Size = UDim2.new(1, 0, 0, 30)
	button.BackgroundColor3 = COLORS.glassSurface
	button.BackgroundTransparency = 1
	button.BorderSizePixel = 0
	button.ZIndex = 3
	button.Text = "   " .. name
	button.TextColor3 = COLORS.textSecondary
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 12
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.LayoutOrder = layoutOrder or 1
	button.Parent = tabContainer

	applyGlass(button, { corner = CORNER.small })

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Size = UDim2.new(0, 3, 0, 16)
	indicator.Position = UDim2.new(0, 2, 0.5, -8)
	indicator.BackgroundColor3 = COLORS.accentCyan
	indicator.BackgroundTransparency = 1
	indicator.BorderSizePixel = 0
	indicator.Visible = false
	indicator.ZIndex = 4
	indicator.Parent = button

	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 2)
	indicatorCorner.Parent = indicator

	local contentFrame = createTabContent(name)
	tabs[name] = {
		Frame = contentFrame,
		Button = button,
		Indicator = indicator,
	}

	button.MouseButton1Click:Connect(function()
		selectTab(name)
	end)

	button.MouseEnter:Connect(function()
		if activeTab ~= name then
			TweenService:Create(button, TweenInfo.new(0.15), {
				BackgroundColor3 = COLORS.glassHover,
				BackgroundTransparency = 0.5,
			}):Play()
		end
	end)
	button.MouseLeave:Connect(function()
		if activeTab ~= name then
			TweenService:Create(button, TweenInfo.new(0.15), {
				BackgroundColor3 = COLORS.glassSurface,
				BackgroundTransparency = 1,
			}):Play()
		end
	end)

	return contentFrame
end






local function createButtonRow(labelText, defaultButtonText, isDropdown)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = COLORS.glassSurface
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0

	applyGlass(row, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.85
	})

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -175, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = COLORS.textPrimary
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.ClipsDescendants = true
	label.Parent = row

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 160, 0, 24)
	button.Position = UDim2.new(1, -170, 0.5, -12)
	button.BackgroundColor3 = Color3.fromRGB(24, 28, 48)
	button.BackgroundTransparency = 0.2
	button.BorderSizePixel = 0
	button.Text = ""
	button.ZIndex = 3
	button.Active = true
	button.Selectable = true
	button.Parent = row

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = CORNER.small
	buttonCorner.Parent = button

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = COLORS.accentCyan
	buttonStroke.Thickness = 1.2
	buttonStroke.Transparency = 0.3
	buttonStroke.Parent = button

	local hasDropdownArrow = (isDropdown == true)

	local btnTextLabel = Instance.new("TextLabel")
	btnTextLabel.Name = "ButtonText"
	btnTextLabel.Size = hasDropdownArrow and UDim2.new(1, -24, 1, 0) or UDim2.new(1, -12, 1, 0)
	btnTextLabel.Position = hasDropdownArrow and UDim2.new(0, 8, 0, 0) or UDim2.new(0, 6, 0, 0)
	btnTextLabel.BackgroundTransparency = 1
	btnTextLabel.Text = defaultButtonText or "Action"
	btnTextLabel.TextColor3 = COLORS.textWhite
	btnTextLabel.Font = Enum.Font.GothamBold
	btnTextLabel.TextSize = 11
	btnTextLabel.TextXAlignment = hasDropdownArrow and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
	btnTextLabel.TextTruncate = Enum.TextTruncate.AtEnd
	btnTextLabel.ZIndex = 4
	btnTextLabel.Parent = button

	if hasDropdownArrow then
		local arrow = Instance.new("TextLabel")
		arrow.Name = "Arrow"
		arrow.Size = UDim2.new(0, 18, 1, 0)
		arrow.Position = UDim2.new(1, -18, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "v"
		arrow.TextColor3 = COLORS.accentCyan
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 10
		arrow.ZIndex = 4
		arrow.Parent = button
	end

	local rawButton = button
	local wrapper = {
		_raw = rawButton,
		MouseButton1Click = rawButton.MouseButton1Click,
		MouseButton1Down = rawButton.MouseButton1Down,
		MouseEnter = rawButton.MouseEnter,
		MouseLeave = rawButton.MouseLeave,
	}
	setmetatable(wrapper, {
		__index = function(_, k)
			if k == "Text" then
				return btnTextLabel.Text
			end
			local ok, val = pcall(function() return rawButton[k] end)
			if ok then
				if type(val) == "function" then
					return function(_, ...)
						return val(rawButton, ...)
					end
				end
				return val
			end
			return nil
		end,
		__newindex = function(_, k, v)
			if k == "Text" then
				btnTextLabel.Text = tostring(v)
			else
				pcall(function() rawButton[k] = v end)
			end
		end
	})

	return row, wrapper
end


local function createDropdownMenu(options, defaultSelectedName, onUpdateCallback, isSingleSelect)
	local selectedMap = {}
	if isSingleSelect then
		selectedMap[defaultSelectedName or (options and options[1]) or "Select"] = true
	end

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(0, 260, 1, -56)
	overlay.Position = UDim2.new(1, -270, 0, 48)
	overlay.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
	overlay.BackgroundTransparency = 0
	overlay.BorderSizePixel = 0
	overlay.Visible = false
	overlay.ZIndex = 500

	applyGlass(overlay, {
		corner = CORNER.medium,
		stroke = true,
		strokeColor = COLORS.borderGlow,
		strokeThickness = 1.5,
		strokeTransparency = TRANSPARENCY.borderGlow,
		gradient = true,
		gradientRotation = 145,
	})

	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -20, 0, 30)
	searchBox.Position = UDim2.new(0, 10, 0, 10)
	searchBox.BackgroundColor3 = COLORS.glassSurface
	searchBox.BackgroundTransparency = 0.25
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search..."
	searchBox.PlaceholderColor3 = COLORS.textMuted
	searchBox.TextColor3 = COLORS.textWhite
	searchBox.Font = Enum.Font.GothamMedium
	searchBox.TextSize = 11
	searchBox.ZIndex = 501
	searchBox.Parent = overlay

	applyGlass(searchBox, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.85
	})

	local scrollContainer = Instance.new("ScrollingFrame")
	scrollContainer.Size = UDim2.new(1, -16, 1, -56)
	scrollContainer.Position = UDim2.new(0, 8, 0, 48)
	scrollContainer.BackgroundTransparency = 1
	scrollContainer.BorderSizePixel = 0
	scrollContainer.ScrollBarThickness = 3
	scrollContainer.ScrollBarImageColor3 = COLORS.accentCyan
	scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollContainer.ZIndex = 501
	scrollContainer.Parent = overlay

	local scrollLayout = Instance.new("UIListLayout")
	scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	scrollLayout.Padding = UDim.new(0, 4)
	scrollLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	scrollLayout.Parent = scrollContainer

	applyPadding(scrollContainer, 4, 4, 4, 4)

	scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollContainer.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 8)
	end)

	local optionRows = {}

	local function getSelectedList()
		local list = {}
		if isSingleSelect then
			for optName, isSel in pairs(selectedMap) do
				if isSel then table.insert(list, optName) end
			end
			if #list == 0 and defaultSelectedName then
				table.insert(list, defaultSelectedName)
			end
		else
			for _, optName in ipairs(options) do
				if selectedMap[optName] == true then
					table.insert(list, optName)
				end
			end
		end
		return list
	end

	local function updateSummary(skipCallback)
		local activeList = getSelectedList()
		local summaryText = ""
		if isSingleSelect then
			summaryText = activeList[1] or defaultSelectedName or (options and options[1]) or "Select"
		else
			if #activeList == 0 then
				summaryText = "None Selected"
			elseif #activeList == #options and #options > 1 then
				summaryText = "All Selected (" .. tostring(#options) .. ")"
			elseif #activeList <= 2 then
				summaryText = table.concat(activeList, ", ")
			else
				summaryText = string.format("%s, %s (+%d more)", activeList[1], activeList[2], #activeList - 2)
			end
		end

		if not skipCallback and onUpdateCallback then
			onUpdateCallback(summaryText, activeList, selectedMap)
		end
		return summaryText, activeList
	end

	local function buildOptionRows(optList)
		options = optList or options
		for _, item in ipairs(optionRows) do
			if item.Card and item.Card.Parent then
				item.Card:Destroy()
			end
		end
		table.clear(optionRows)

		if isSingleSelect and #options <= 4 then
			searchBox.Visible = false
			scrollContainer.Position = UDim2.new(0, 8, 0, 10)
			scrollContainer.Size = UDim2.new(1, -16, 1, -20)
			overlay.Size = UDim2.new(0, 260, 0, #options * 38 + 20)
		else
			searchBox.Visible = true
			scrollContainer.Position = UDim2.new(0, 8, 0, 48)
			scrollContainer.Size = UDim2.new(1, -16, 1, -56)
			overlay.Size = UDim2.new(0, 260, 1, -56)
		end

		for idx, name in ipairs(options) do
			local card = Instance.new("TextButton")
			card.Size = UDim2.new(1, 0, 0, 32)
			card.BackgroundColor3 = COLORS.glassActive
			card.BackgroundTransparency = (selectedMap[name] == true) and 0.15 or 1
			card.BorderSizePixel = 0
			card.Text = ""
			card.LayoutOrder = idx
			card.ZIndex = 502
			card.Parent = scrollContainer

			local cCorner = Instance.new("UICorner")
			cCorner.CornerRadius = CORNER.small
			cCorner.Parent = card

			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.new(0, 3, 0, 16)
			indicator.Position = UDim2.new(0, 4, 0.5, -8)
			indicator.BackgroundColor3 = COLORS.accentCyan
			indicator.BorderSizePixel = 0
			indicator.Visible = (selectedMap[name] == true)
			indicator.ZIndex = 503
			indicator.Parent = card

			local indCorner = Instance.new("UICorner")
			indCorner.CornerRadius = UDim.new(0, 2)
			indCorner.Parent = indicator

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -20, 1, 0)
			label.Position = UDim2.new(0, 14, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = name
			label.TextColor3 = (selectedMap[name] == true) and COLORS.textWhite or COLORS.textSecondary
			label.Font = (selectedMap[name] == true) and Enum.Font.GothamBold or Enum.Font.GothamMedium
			label.TextSize = 11
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextTruncate = Enum.TextTruncate.AtEnd
			label.ClipsDescendants = true
			label.ZIndex = 503
			label.Parent = card

			table.insert(optionRows, { Name = name, Card = card, Indicator = indicator, Label = label })

			card.MouseButton1Click:Connect(function()
				if isSingleSelect then
					selectedMap = { [name] = true }
				else
					if selectedMap[name] == true then
						selectedMap[name] = false
					else
						selectedMap[name] = true
					end
				end

				for _, item in ipairs(optionRows) do
					local isSelected = (selectedMap[item.Name] == true)
					item.Card.BackgroundTransparency = isSelected and 0.15 or 1
					item.Indicator.Visible = isSelected
					item.Label.TextColor3 = isSelected and COLORS.textWhite or COLORS.textSecondary
					item.Label.Font = isSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium
				end

				updateSummary(false)
				if isSingleSelect then
					closeDropdowns()
				end
			end)
		end
	end

	buildOptionRows(options)

	local function setSelectedList(activeList, triggerCallback)
		selectedMap = {}
		if isSingleSelect then
			if type(activeList) == "string" and activeList ~= "" then
				selectedMap[activeList] = true
			elseif type(activeList) == "table" and #activeList > 0 then
				selectedMap[activeList[1]] = true
			else
				selectedMap[defaultSelectedName or (options and options[1]) or "Select"] = true
			end
		else
			if type(activeList) == "table" and #activeList > 0 then
				for _, name in ipairs(activeList) do
					selectedMap[name] = true
				end
			elseif type(activeList) == "table" then
				for k, v in pairs(activeList) do
					if v == true then
						selectedMap[k] = true
					else
						selectedMap[k] = false
					end
				end
			elseif type(activeList) == "string" and activeList ~= "" and activeList ~= "None" then
				selectedMap[activeList] = true
			end
		end

		for _, item in ipairs(optionRows) do
			local isSelected = (selectedMap[item.Name] == true)
			item.Card.BackgroundTransparency = isSelected and 0.15 or 1
			item.Indicator.Visible = isSelected
			item.Label.TextColor3 = isSelected and COLORS.textWhite or COLORS.textSecondary
			item.Label.Font = isSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium
		end

		local summaryText = updateSummary(not (triggerCallback == true))
		return summaryText
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local query = searchBox.Text:lower():gsub("%s+", "")
		for _, item in ipairs(optionRows) do
			local cleanName = item.Name:lower():gsub("%s+", "")
			if query == "" or cleanName:find(query, 1, true) ~= nil then
				item.Card.Visible = true
			else
				item.Card.Visible = false
			end
		end
	end)

	overlay.Parent = mainFrame
	return overlay, setSelectedList, function(newOptions, newDefault)
		if newDefault then defaultSelectedName = newDefault end
		buildOptionRows(newOptions)
	end
end


local function createDropdown(parent, labelText, options, defaultVal, callback, layoutOrder)
	local row, btnWrapper = createButtonRow(labelText, tostring(defaultVal or options[1] or "Select"), true)
	row.LayoutOrder = layoutOrder or 1
	row.Parent = parent

	local currentVal = defaultVal or options[1]
	local overlay, setSelectedList, rebuildOptions = createDropdownMenu(options, tostring(currentVal),
		function(summaryText, activeList)
			currentVal = activeList[1] or summaryText
			btnWrapper.Text = currentVal
			if callback then
				task.spawn(callback, currentVal)
			end
		end, true)

	btnWrapper.MouseButton1Click:Connect(function()
		if activeOverlay == overlay then
			closeDropdowns()
		else
			closeDropdowns()
			activeOverlay = overlay
			overlay.Visible = true
			dropdownDismissArea.Visible = true
		end
	end)

	return {
		Frame = row,
		Button = btnWrapper,
		Set = function(v)
			currentVal = v
			btnWrapper.Text = tostring(v)
			setSelectedList(tostring(v), false)
		end,
		Refresh = function(newOptions, newDefault)
			currentVal = newDefault or currentVal or (newOptions and newOptions[1]) or "Select"
			btnWrapper.Text = tostring(currentVal)
			rebuildOptions(newOptions, tostring(currentVal))
			setSelectedList(tostring(currentVal), false)
		end,
		Get = function() return currentVal end
	}
end


local function createMultiDropdown(parent, labelText, options, defaultSelectedMap, callback, layoutOrder)
	local row, btnWrapper = createButtonRow(labelText, "None Selected", true)
	row.LayoutOrder = layoutOrder or 1
	row.Parent = parent

	local currentMap = defaultSelectedMap or {}
	local overlay, setSelectedList, rebuildOptions = createDropdownMenu(options, "None",
		function(summaryText, activeList, selectedMap)
			btnWrapper.Text = summaryText
			currentMap = selectedMap
			if callback then
				task.spawn(callback, selectedMap, activeList)
			end
		end, false)

	if defaultSelectedMap then
		local sumText = setSelectedList(defaultSelectedMap, false)
		btnWrapper.Text = sumText
	end

	btnWrapper.MouseButton1Click:Connect(function()
		if activeOverlay == overlay then
			closeDropdowns()
		else
			closeDropdowns()
			activeOverlay = overlay
			overlay.Visible = true
			dropdownDismissArea.Visible = true
		end
	end)

	return {
		Frame = row,
		Button = btnWrapper,
		Set = function(newMap)
			currentMap = newMap or {}
			local sumText = setSelectedList(currentMap, false)
			btnWrapper.Text = sumText
		end,
		Refresh = function(newOptions, newDefaultMap)
			currentMap = newDefaultMap or currentMap or {}
			rebuildOptions(newOptions)
			local sumText = setSelectedList(currentMap, false)
			btnWrapper.Text = sumText
		end,
		Get = function() return currentMap end
	}
end


local function createSection(parent, title, layoutOrder, defaultExpanded)
	local isCollapsed = not (defaultExpanded == true)

	local header = Instance.new("TextButton")
	header.Name = "SectionHeader_" .. title
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = Color3.fromRGB(24, 28, 52)
	header.BackgroundTransparency = 0.08
	header.BorderSizePixel = 0
	header.Text = ""
	header.LayoutOrder = (layoutOrder or 1) * 2 - 1
	header.Parent = parent

	local hCorner = Instance.new("UICorner")
	hCorner.CornerRadius = UDim.new(0, 8)
	hCorner.Parent = header

	local hStroke = Instance.new("UIStroke")
	hStroke.Color = Color3.fromRGB(50, 65, 110)
	hStroke.Thickness = 1
	hStroke.Transparency = 0.55
	hStroke.Parent = header

	local accentBar = Instance.new("Frame")
	accentBar.Name = "AccentBar"
	accentBar.Size = UDim2.new(0, 3, 0, 18)
	accentBar.Position = UDim2.new(0, 6, 0.5, -9)
	accentBar.BackgroundColor3 = COLORS.accentCyan
	accentBar.BorderSizePixel = 0
	accentBar.Parent = header

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(0, 2)
	accentCorner.Parent = accentBar

	local hTitle = Instance.new("TextLabel")
	hTitle.Name = "HeaderTitle"
	hTitle.Size = UDim2.new(1, -50, 1, 0)
	hTitle.Position = UDim2.new(0, 18, 0, 0)
	hTitle.BackgroundTransparency = 1
	hTitle.Text = string.upper(title)
	hTitle.TextColor3 = Color3.fromRGB(225, 235, 255)
	hTitle.Font = Enum.Font.GothamBold
	hTitle.TextSize = 13
	hTitle.TextXAlignment = Enum.TextXAlignment.Left
	hTitle.Parent = header

	local arrow = Instance.new("TextLabel")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.new(0, 24, 0, 24)
	arrow.Position = UDim2.new(1, -24, 0.5, 0)
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.BackgroundTransparency = 1
	arrow.Text = isCollapsed and ">" or "v"
	arrow.Rotation = isCollapsed and 0 or 90
	arrow.TextColor3 = COLORS.accentCyan
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 14
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.TextYAlignment = Enum.TextYAlignment.Center
	arrow.Parent = header

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.LayoutOrder = (layoutOrder or 1) * 2
	container.ClipsDescendants = true
	container.Visible = not isCollapsed
	container.Parent = parent

	local content = Instance.new("Frame")
	content.Name = "Content"
	content:SetAttribute("ConfigGroup", title)
	content.Size = UDim2.new(1, 0, 0, 0)
	content.Position = UDim2.new(0, 0, 0, 0)
	content.BackgroundTransparency = 1
	content.Visible = not isCollapsed
	content.Parent = container

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.Parent = content

	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, -12, 0, 1)
	bottomLine.Position = UDim2.new(0, 6, 1, -1)
	bottomLine.BackgroundColor3 = COLORS.accentCyan
	bottomLine.BackgroundTransparency = 1
	bottomLine.BorderSizePixel = 0
	bottomLine.ZIndex = 4
	bottomLine.Parent = header

	local lineGrad = Instance.new("UIGradient")
	lineGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, COLORS.accentCyan),
		ColorSequenceKeypoint.new(0.5, COLORS.accentViolet),
		ColorSequenceKeypoint.new(1, COLORS.accentCyan)
	})
	lineGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.25),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.8, 0.25),
		NumberSequenceKeypoint.new(1, 1)
	})
	lineGrad.Parent = bottomLine

	pcall(function()
		header.MouseEnter:Connect(function()
			TweenService:Create(header, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(30, 36, 64),
			}):Play()
			TweenService:Create(accentBar, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(60, 220, 255),
			}):Play()
			hTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		end)
		header.MouseLeave:Connect(function()
			TweenService:Create(header, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(24, 28, 52),
			}):Play()
			TweenService:Create(accentBar, TweenInfo.new(0.15), {
				BackgroundColor3 = COLORS.accentCyan,
			}):Play()
			hTitle.TextColor3 = Color3.fromRGB(225, 235, 255)
		end)
	end)

	local function updateHeight()
		if not isCollapsed then
			local h = contentLayout.AbsoluteContentSize.Y + 12
			container.Size = UDim2.new(1, 0, 0, h)
			content.Size = UDim2.new(1, 0, 0, h)
		else
			container.Size = UDim2.new(1, 0, 0, 0)
			content.Size = UDim2.new(1, 0, 0, 0)
		end
	end

	header.MouseButton1Click:Connect(function()
		isCollapsed = not isCollapsed
		container.Visible = true
		content.Visible = true
		local targetRot = isCollapsed and 0 or 90
		local targetH = isCollapsed and 0 or (contentLayout.AbsoluteContentSize.Y + 12)

		arrow.Text = isCollapsed and ">" or "v"
		TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Rotation = targetRot }):Play()
		local tween = TweenService:Create(container,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = UDim2.new(1, 0, 0, targetH) })
		tween.Completed:Connect(function()
			if isCollapsed then
				container.Visible = false
				content.Visible = false
			end
		end)
		tween:Play()
	end)

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if not isCollapsed then
			container.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 12)
			content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 12)
		end
	end)

	task.spawn(function()
		task.wait(0.1)
		updateHeight()
	end)

	return content
end


local function createToggle(parent, labelText, defaultState, callback, layoutOrder)
	defaultState = defaultState or false

	local card = Instance.new("Frame")
	card.Name = "ToggleCard_" .. tostring(labelText)
	card.Size = UDim2.new(1, 0, 0, 36)
	card.BackgroundColor3 = COLORS.glassCard
	card.BackgroundTransparency = TRANSPARENCY.glassCard
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder or 0
	card.ZIndex = 3
	card.Parent = parent

	applyGlass(card, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.75
	})

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -65, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = labelText
	titleLabel.TextColor3 = COLORS.textPrimary
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextSize = 12
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 4
	titleLabel.Parent = card

	local track = Instance.new("TextButton")
	track.Name = "SwitchTrack"
	track.Size = UDim2.new(0, 38, 0, 20)
	track.Position = UDim2.new(1, -48, 0.5, -10)
	track.BackgroundColor3 = defaultState and COLORS.toggleOn or COLORS.toggleOff
	track.BackgroundTransparency = 0.15
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.ZIndex = 4
	track.Parent = card

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = CORNER.pill
	trackCorner.Parent = track

	local trackStroke = Instance.new("UIStroke")
	trackStroke.Color = COLORS.accentCyan
	trackStroke.Thickness = 1
	trackStroke.Transparency = defaultState and 0.4 or 0.8
	trackStroke.Parent = track

	local thumb = Instance.new("Frame")
	thumb.Name = "Thumb"
	thumb.Size = UDim2.new(0, 14, 0, 14)
	thumb.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	thumb.BackgroundColor3 = COLORS.textWhite
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 5
	thumb.Parent = track

	local thumbCorner = Instance.new("UICorner")
	thumbCorner.CornerRadius = CORNER.pill
	thumbCorner.Parent = thumb

	local fullClickBtn = Instance.new("TextButton")
	fullClickBtn.Name = "FullClick"
	fullClickBtn.Size = UDim2.new(1, 0, 1, 0)
	fullClickBtn.BackgroundTransparency = 1
	fullClickBtn.Text = ""
	fullClickBtn.ZIndex = 6
	fullClickBtn.Parent = card

	local state = defaultState

	local function setState(newState, triggerCallback)
		state = newState
		local targetThumbPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		local targetBgColor = state and COLORS.toggleOn or COLORS.toggleOff
		local targetStrokeTrans = state and 0.4 or 0.8

		TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = targetThumbPos }):Play()
		TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundColor3 = targetBgColor }):Play()
		TweenService:Create(trackStroke, TweenInfo.new(0.2), { Transparency = targetStrokeTrans }):Play()

		if triggerCallback and callback then
			task.spawn(callback, state)
		end
	end

	track.MouseButton1Click:Connect(function()
		setState(not state, true)
	end)
	fullClickBtn.MouseButton1Click:Connect(function()
		setState(not state, true)
	end)

	return {
		card = card,
		Frame = card,
		Set = function(v) setState(v, false) end,
		Get = function() return state end
	}
end


local function createSlider(parent, title, minVal, maxVal, defaultVal, callback, layoutOrder, unit)
	unit = unit or ""
	minVal = tonumber(minVal) or 0
	maxVal = tonumber(maxVal) or 100
	defaultVal = tonumber(defaultVal) or minVal or 0

	local card = Instance.new("Frame")
	card.Name = "SliderCard_" .. tostring(title)
	card.Size = UDim2.new(1, 0, 0, 52)
	card.BackgroundColor3 = COLORS.glassCard
	card.BackgroundTransparency = TRANSPARENCY.glassCard
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder or 0
	card.ZIndex = 3
	card.Parent = parent

	applyGlass(card, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.75
	})

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -90, 0, 20)
	titleLabel.Position = UDim2.new(0, 12, 0, 6)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = COLORS.textPrimary
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextSize = 12
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 4
	titleLabel.Parent = card

	local valBadge = Instance.new("TextLabel")
	valBadge.Name = "ValueBadge"
	valBadge.Size = UDim2.new(0, 72, 0, 18)
	valBadge.Position = UDim2.new(1, -84, 0, 6)
	valBadge.BackgroundColor3 = COLORS.glassSurface
	valBadge.BackgroundTransparency = 0.3
	valBadge.Text = tostring(defaultVal) .. (unit ~= "" and (" " .. unit) or "")
	valBadge.TextColor3 = COLORS.accentCyan
	valBadge.Font = Enum.Font.GothamBold
	valBadge.TextSize = 11
	valBadge.TextXAlignment = Enum.TextXAlignment.Center
	valBadge.ZIndex = 4
	valBadge.Parent = card

	applyGlass(valBadge, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.85
	})

	local sliderTrack = Instance.new("Frame")
	sliderTrack.Name = "Track"
	sliderTrack.Size = UDim2.new(1, -24, 0, 6)
	sliderTrack.Position = UDim2.new(0, 12, 0, 36)
	sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 36, 60)
	sliderTrack.BorderSizePixel = 0
	sliderTrack.ZIndex = 4
	sliderTrack.Parent = card

	local trCorner = Instance.new("UICorner")
	trCorner.CornerRadius = CORNER.pill
	trCorner.Parent = sliderTrack

	local initialRatio = math.clamp((defaultVal - minVal) / math.max(1, maxVal - minVal), 0, 1)

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new(initialRatio, 0, 1, 0)
	sliderFill.BackgroundColor3 = COLORS.accentCyan
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 5
	sliderFill.Parent = sliderTrack

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = CORNER.pill
	fillCorner.Parent = sliderFill

	local currentVal = defaultVal
	local sliding = false

	local function updateFromPos(posX, triggerCallback)
		local absWidth = sliderTrack.AbsoluteSize.X
		local absPos = sliderTrack.AbsolutePosition.X
		local ratio = math.clamp((posX - absPos) / absWidth, 0, 1)
		local rawVal = minVal + ratio * (maxVal - minVal)
		currentVal = (maxVal - minVal > 10) and math.round(rawVal) or (math.floor(rawVal * 100) / 100)
		sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
		valBadge.Text = tostring(currentVal) .. (unit ~= "" and (" " .. unit) or "")
		if triggerCallback and callback then
			task.spawn(callback, currentVal)
		end
	end

	sliderTrack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			updateFromPos(input.Position.X, true)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromPos(input.Position.X, true)
		end
	end)

	return {
		card = card,
		Frame = card,
		Set = function(newVal)
			newVal = math.clamp(newVal, minVal, maxVal)
			currentVal = newVal
			local ratio = (newVal - minVal) / math.max(1, maxVal - minVal)
			sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
			valBadge.Text = tostring(newVal) .. (unit ~= "" and (" " .. unit) or "")
		end,
		Get = function() return currentVal end
	}
end


local function createTextBox(parent, labelText, defaultText, placeholder, callback, layoutOrder)
	local card = Instance.new("Frame")
	card.Name = "TextboxCard_" .. tostring(labelText)
	card.Size = UDim2.new(1, 0, 0, 36)
	card.BackgroundColor3 = COLORS.glassCard
	card.BackgroundTransparency = TRANSPARENCY.glassCard
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder or 0
	card.ZIndex = 3
	card.Parent = parent

	applyGlass(card, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.75
	})

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -175, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = labelText
	titleLabel.TextColor3 = COLORS.textPrimary
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextSize = 12
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 4
	titleLabel.Parent = card

	local box = Instance.new("TextBox")
	box.Name = "TextBox"
	box.Size = UDim2.new(0, 160, 0, 24)
	box.Position = UDim2.new(1, -170, 0.5, -12)
	box.BackgroundColor3 = COLORS.glassSurface
	box.BackgroundTransparency = 0.3
	box.PlaceholderText = placeholder or "Type here..."
	box.PlaceholderColor3 = COLORS.textMuted
	box.Text = tostring(defaultText or "")
	box.TextColor3 = COLORS.textWhite
	box.Font = Enum.Font.GothamMedium
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 4
	box.Parent = card

	applyGlass(box, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.85
	})

	local boxStroke = box:FindFirstChildOfClass("UIStroke")

	box.Focused:Connect(function()
		if boxStroke then
			TweenService:Create(boxStroke, TweenInfo.new(0.15), { Transparency = 0.2, Color = COLORS.accentCyan }):Play()
		end
		TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 34, 60) }):Play()
	end)

	box.FocusLost:Connect(function(enterPressed)
		if boxStroke then
			TweenService:Create(boxStroke, TweenInfo.new(0.15), { Transparency = 0.85, Color = COLORS.borderGlass })
				:Play()
		end
		TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.glassSurface }):Play()
		if callback then
			task.spawn(callback, box.Text)
		end
	end)

	return {
		card = card,
		Frame = card,
		Set = function(v) box.Text = tostring(v) end,
		Get = function() return box.Text end
	}
end


local function createButton(parent, arg2, arg3, arg4, arg5)
	local title, btnText, callback, layoutOrder
	if type(arg3) == "function" then
		title = tostring(arg2)
		btnText = (#title <= 12) and title or "Execute"
		callback = arg3
		layoutOrder = arg4
	else
		title = tostring(arg2)
		btnText = tostring(arg3 or "Execute")
		callback = arg4
		layoutOrder = arg5
	end

	local card = Instance.new("Frame")
	card.Name = "ButtonCard_" .. title
	card.Size = UDim2.new(1, 0, 0, 36)
	card.BackgroundColor3 = COLORS.glassCard
	card.BackgroundTransparency = TRANSPARENCY.glassCard
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder or 0
	card.ZIndex = 3
	card.Parent = parent

	applyGlass(card, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.75
	})

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -120, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = COLORS.textPrimary
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextSize = 12
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 4
	titleLabel.Parent = card

	local actionBtn = Instance.new("TextButton")
	actionBtn.Name = "ActionBtn"
	actionBtn.Size = UDim2.new(0, 100, 0, 24)
	actionBtn.Position = UDim2.new(1, -110, 0.5, -12)
	actionBtn.BackgroundColor3 = COLORS.accentCyan
	actionBtn.BackgroundTransparency = 0.15
	actionBtn.Text = btnText
	actionBtn.TextColor3 = Color3.fromRGB(10, 14, 26)
	actionBtn.Font = Enum.Font.GothamBold
	actionBtn.TextSize = 11
	actionBtn.AutoButtonColor = false
	actionBtn.ZIndex = 4
	actionBtn.Parent = card

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = CORNER.small
	btnCorner.Parent = actionBtn

	actionBtn.MouseButton1Click:Connect(function()
		TweenService:Create(actionBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.4 }):Play()
		task.delay(0.1, function()
			TweenService:Create(actionBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.15 }):Play()
		end)
		if callback then
			task.spawn(callback)
		end
	end)

	actionBtn.MouseEnter:Connect(function()
		TweenService:Create(actionBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 225, 255) }):Play()
	end)
	actionBtn.MouseLeave:Connect(function()
		TweenService:Create(actionBtn, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.accentCyan }):Play()
	end)

	return {
		card = card,
		Frame = card,
		Button = actionBtn
	}
end


local function createStatBox(parent, titleText, valueText, layoutOrder)
	local box = Instance.new("Frame")
	box.Name = "Stat_" .. tostring(titleText)
	box.Size = UDim2.new(1, 0, 0, 42)
	box.BackgroundColor3 = COLORS.glassCard
	box.BackgroundTransparency = TRANSPARENCY.glassCard
	box.BorderSizePixel = 0
	box.LayoutOrder = layoutOrder or 1
	box.ZIndex = 3
	box.Parent = parent

	applyGlass(box, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.75
	})

	local tLabel = Instance.new("TextLabel")
	tLabel.Name = "Title"
	tLabel.Size = UDim2.new(0.55, 0, 1, 0)
	tLabel.Position = UDim2.new(0, 12, 0, 0)
	tLabel.BackgroundTransparency = 1
	tLabel.Text = tostring(titleText):upper()
	tLabel.TextColor3 = COLORS.textMuted
	tLabel.Font = Enum.Font.GothamBold
	tLabel.TextSize = 10
	tLabel.TextXAlignment = Enum.TextXAlignment.Left
	tLabel.ZIndex = 4
	tLabel.Parent = box

	local vLabel = Instance.new("TextLabel")
	vLabel.Name = "Value"
	vLabel.Size = UDim2.new(0.42, -12, 1, 0)
	vLabel.Position = UDim2.new(0.55, 0, 0, 0)
	vLabel.BackgroundTransparency = 1
	vLabel.Text = tostring(valueText or "0")
	vLabel.TextColor3 = COLORS.accentCyan
	vLabel.Font = Enum.Font.GothamBold
	vLabel.TextSize = 13
	vLabel.TextXAlignment = Enum.TextXAlignment.Right
	vLabel.ZIndex = 4
	vLabel.Parent = box

	return {
		card = box,
		Frame = box,
		Set = function(v) vLabel.Text = tostring(v) end,
		Get = function() return vLabel.Text end
	}
end


local function createDivider(parent, labelText, layoutOrder)
	local container = Instance.new("Frame")
	container.Name = "Divider_" .. (labelText or "Line")
	container.Size = UDim2.new(1, 0, 0, (labelText and labelText ~= "") and 24 or 12)
	container.BackgroundTransparency = 1
	container.LayoutOrder = layoutOrder or 1
	container.ZIndex = 2
	container.Parent = parent

	if labelText and labelText ~= "" then
		local lineLeft = Instance.new("Frame")
		lineLeft.Size = UDim2.new(0.5, -85, 0, 1)
		lineLeft.Position = UDim2.new(0, 4, 0.5, 0)
		lineLeft.BackgroundColor3 = COLORS.accentCyan
		lineLeft.BackgroundTransparency = 0.7
		lineLeft.BorderSizePixel = 0
		lineLeft.ZIndex = 3
		lineLeft.Parent = container

		local lineRight = Instance.new("Frame")
		lineRight.Size = UDim2.new(0.5, -85, 0, 1)
		lineRight.Position = UDim2.new(0.5, 81, 0.5, 0)
		lineRight.BackgroundColor3 = COLORS.accentCyan
		lineRight.BackgroundTransparency = 0.7
		lineRight.BorderSizePixel = 0
		lineRight.ZIndex = 3
		lineRight.Parent = container

		local tagLabel = Instance.new("TextLabel")
		tagLabel.Name = "Tag"
		tagLabel.Size = UDim2.new(0, 160, 0, 18)
		tagLabel.Position = UDim2.new(0.5, -80, 0.5, -9)
		tagLabel.BackgroundColor3 = Color3.fromRGB(20, 24, 46)
		tagLabel.BackgroundTransparency = 0.15
		tagLabel.BorderSizePixel = 0
		tagLabel.Text = string.upper(labelText)
		tagLabel.TextColor3 = COLORS.accentCyan
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextSize = 10
		tagLabel.TextXAlignment = Enum.TextXAlignment.Center
		tagLabel.ZIndex = 4
		tagLabel.Parent = container

		applyGlass(tagLabel, {
			corner = CORNER.small,
			stroke = true,
			strokeColor = COLORS.accentCyan,
			strokeThickness = 1,
			strokeTransparency = 0.75
		})
	else
		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, -8, 0, 1)
		line.Position = UDim2.new(0, 4, 0.5, 0)
		line.BackgroundColor3 = COLORS.borderGlass
		line.BackgroundTransparency = 0.65
		line.BorderSizePixel = 0
		line.ZIndex = 3
		line.Parent = container
	end

	return container
end


local function createLogConsole(parent, layoutOrder, height)
	local consoleCard = Instance.new("Frame")
	consoleCard.Name = "ActivityLogConsole"
	consoleCard.Size = UDim2.new(1, 0, 0, height or 140)
	consoleCard.BackgroundColor3 = COLORS.glassPrimary
	consoleCard.BackgroundTransparency = 0.15
	consoleCard.BorderSizePixel = 0
	consoleCard.LayoutOrder = layoutOrder or 1
	consoleCard.ZIndex = 2
	consoleCard.Parent = parent

	applyGlass(consoleCard, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.7
	})

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "LogScroll"
	scroll.Size = UDim2.new(1, -16, 1, -16)
	scroll.Position = UDim2.new(0, 8, 0, 8)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = COLORS.accentCyan
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ZIndex = 3
	scroll.Parent = consoleCard

	local listLayout = applyListLayout(scroll, 3)
	applyPadding(scroll, 4, 4, 4, 4)

	local maxLogs = 50
	local logCount = 0

	local function logMessage(msg, color)
		logCount = logCount + 1
		local timeStr = os.date("%H:%M:%S")

		local logLabel = Instance.new("TextLabel")
		logLabel.Name = "Log_" .. logCount
		logLabel.Size = UDim2.new(1, 0, 0, 16)
		logLabel.BackgroundTransparency = 1
		logLabel.Text = string.format("[%s] %s", timeStr, msg)
		logLabel.TextColor3 = color or COLORS.textSecondary
		logLabel.Font = Enum.Font.Code
		logLabel.TextSize = 11
		logLabel.TextXAlignment = Enum.TextXAlignment.Left
		logLabel.LayoutOrder = logCount
		logLabel.ZIndex = 4
		logLabel.Parent = scroll

		if logCount > maxLogs then
			local first = scroll:FindFirstChildOfClass("TextLabel")
			if first then first:Destroy() end
		end

		task.defer(function()
			scroll.CanvasPosition = Vector2.new(0, listLayout.AbsoluteContentSize.Y)
		end)
	end

	return {
		Frame = consoleCard,
		Log = logMessage,
		Clear = function()
			for _, child in ipairs(scroll:GetChildren()) do
				if child:IsA("TextLabel") then
					child:Destroy()
				end
			end
			logCount = 0
		end
	}
end




local tabMain = addTab("Main", 1)
local tabTower = addTab("Tower", 2)
local tabTeam = addTab("Team Unit", 3)
local tabSell = addTab("Sell & Items", 4)
local tabShop = addTab("Shop & Trade", 5)
local tabUpgrades = addTab("Upgrades", 6)
local tabHalloween = addTab("Halloween", 7)
local tabMisc = addTab("Misc & Config", 8)

selectTab("Main")




local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotificationContainer"
notifContainer.Size = UDim2.new(0, 280, 1, -20)
notifContainer.Position = UDim2.new(1, -290, 0, 10)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 1000
notifContainer.Parent = gui

local notifLayout = applyListLayout(notifContainer, 8, Enum.SortOrder.LayoutOrder)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(title, text, color, duration)
	duration = duration or 4.0
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(1, 0, 0, 52)
	toast.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
	toast.BackgroundTransparency = 0.05
	toast.Position = UDim2.new(1, 50, 0, 0)
	toast.ZIndex = 1001
	toast.Parent = notifContainer

	applyGlass(toast, {
		corner = CORNER.medium,
		stroke = true,
		strokeColor = color or COLORS.accentCyan,
		strokeThickness = 1.5,
		strokeTransparency = 0.3
	})

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 4, 1, -12)
	accent.Position = UDim2.new(0, 6, 0, 6)
	accent.BackgroundColor3 = color or COLORS.accentCyan
	accent.BorderSizePixel = 0
	accent.ZIndex = 1002
	accent.Parent = toast

	local accCorner = Instance.new("UICorner")
	accCorner.CornerRadius = UDim.new(0, 2)
	accCorner.Parent = accent

	local tLabel = Instance.new("TextLabel")
	tLabel.Size = UDim2.new(1, -24, 0, 18)
	tLabel.Position = UDim2.new(0, 16, 0, 6)
	tLabel.BackgroundTransparency = 1
	tLabel.Text = title or "Notification"
	tLabel.TextColor3 = color or COLORS.textWhite
	tLabel.Font = Enum.Font.GothamBold
	tLabel.TextSize = 12
	tLabel.TextXAlignment = Enum.TextXAlignment.Left
	tLabel.ZIndex = 1002
	tLabel.Parent = toast

	local bLabel = Instance.new("TextLabel")
	bLabel.Size = UDim2.new(1, -24, 0, 20)
	bLabel.Position = UDim2.new(0, 16, 0, 24)
	bLabel.BackgroundTransparency = 1
	bLabel.Text = text or ""
	bLabel.TextColor3 = COLORS.textPrimary
	bLabel.Font = Enum.Font.GothamMedium
	bLabel.TextSize = 11
	bLabel.TextXAlignment = Enum.TextXAlignment.Left
	bLabel.TextTruncate = Enum.TextTruncate.AtEnd
	bLabel.ZIndex = 1002
	bLabel.Parent = toast

	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title or "HipHub",
			Text = text or "",
			Duration = duration
		})
	end)

	TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	task.delay(duration, function()
		if toast and toast.Parent then
			local tw = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 50, 0, 0),
				BackgroundTransparency = 1
			})
			tw.Completed:Connect(function()
				if toast and toast.Parent then toast:Destroy() end
			end)
			tw:Play()
		end
	end)
end




local function createWeatherHopperWindow(callbacks)
	callbacks = callbacks or {}
	local winFrame = Instance.new("Frame")
	winFrame.Name = "WeatherHopperWindow"
	winFrame.Size = UDim2.new(0, 360, 0, 470)
	winFrame.Position = UDim2.new(0.5, 330, 0.5, -235)
	winFrame.BackgroundColor3 = COLORS.glassPrimary
	winFrame.BackgroundTransparency = TRANSPARENCY.glassMain
	winFrame.BorderSizePixel = 0
	winFrame.ClipsDescendants = true
	winFrame.Visible = false
	winFrame.ZIndex = 50
	winFrame.Parent = gui

	applyGlass(winFrame, {
		corner = CORNER.large,
		stroke = true,
		strokeColor = COLORS.borderGlow,
		strokeThickness = 1.5,
		strokeTransparency = TRANSPARENCY.borderGlow
	})

	
	local winTopBar = Instance.new("Frame")
	winTopBar.Name = "TopBar"
	winTopBar.Size = UDim2.new(1, 0, 0, 38)
	winTopBar.BackgroundColor3 = COLORS.glassSurface
	winTopBar.BackgroundTransparency = TRANSPARENCY.glassTopBar
	winTopBar.BorderSizePixel = 0
	winTopBar.ZIndex = 51
	winTopBar.Parent = winFrame

	applyGlass(winTopBar, { corner = CORNER.large })

	local winTopCover = Instance.new("Frame")
	winTopCover.Size = UDim2.new(1, 0, 0, 10)
	winTopCover.Position = UDim2.new(0, 0, 1, -10)
	winTopCover.BackgroundColor3 = COLORS.glassSurface
	winTopCover.BackgroundTransparency = TRANSPARENCY.glassTopBar
	winTopCover.BorderSizePixel = 0
	winTopCover.ZIndex = 51
	winTopCover.Parent = winTopBar

	local winTitle = Instance.new("TextLabel")
	winTitle.Name = "Title"
	winTitle.Size = UDim2.new(1, -70, 1, 0)
	winTitle.Position = UDim2.new(0, 14, 0, 0)
	winTitle.BackgroundTransparency = 1
	winTitle.Text = "Weather Server Hopper"
	winTitle.TextColor3 = COLORS.textWhite
	winTitle.Font = Enum.Font.GothamBold
	winTitle.TextSize = 13
	winTitle.TextXAlignment = Enum.TextXAlignment.Left
	winTitle.ZIndex = 52
	winTitle.Parent = winTopBar

	
	local winClose = Instance.new("TextButton")
	winClose.Name = "CloseBtn"
	winClose.Size = UDim2.new(0, 24, 0, 24)
	winClose.Position = UDim2.new(1, -32, 0.5, -12)
	winClose.BackgroundColor3 = COLORS.glassHover
	winClose.BackgroundTransparency = 0.5
	winClose.BorderSizePixel = 0
	winClose.Text = "X"
	winClose.TextColor3 = COLORS.textSecondary
	winClose.Font = Enum.Font.GothamBold
	winClose.TextSize = 12
	winClose.ZIndex = 52
	winClose.Parent = winTopBar

	applyGlass(winClose, { corner = CORNER.small })

	winClose.MouseEnter:Connect(function()
		TweenService:Create(winClose, TweenInfo.new(0.15),
			{ BackgroundColor3 = COLORS.dangerRed, BackgroundTransparency = 0.2, TextColor3 = COLORS.textWhite }):Play()
	end)
	winClose.MouseLeave:Connect(function()
		TweenService:Create(winClose, TweenInfo.new(0.15),
			{ BackgroundColor3 = COLORS.glassHover, BackgroundTransparency = 0.5, TextColor3 = COLORS.textSecondary })
			:Play()
	end)
	winClose.MouseButton1Click:Connect(function()
		TweenService:Create(winFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ BackgroundTransparency = 1 }):Play()
		task.delay(0.2, function()
			winFrame.Visible = false
			winFrame.BackgroundTransparency = TRANSPARENCY.glassMain
		end)
	end)

	
	local dragging, dragInput, dragStart, startPos
	winTopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = winFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	winTopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			winFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale,
				startPos.Y.Offset + delta.Y)
		end
	end)

	
	local scrollBody = Instance.new("ScrollingFrame")
	scrollBody.Name = "Body"
	scrollBody.Size = UDim2.new(1, 0, 1, -38)
	scrollBody.Position = UDim2.new(0, 0, 0, 38)
	scrollBody.BackgroundTransparency = 1
	scrollBody.BorderSizePixel = 0
	scrollBody.ScrollBarThickness = 3
	scrollBody.ScrollBarImageColor3 = COLORS.accentCyan
	scrollBody.ScrollBarImageTransparency = 0.4
	scrollBody.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollBody.ClipsDescendants = true
	scrollBody.ZIndex = 51
	scrollBody.Parent = winFrame

	applyPadding(scrollBody, 10, 10, 10, 10)
	applyListLayout(scrollBody, 8)

	
	local statusCard = Instance.new("Frame")
	statusCard.Name = "StatusCard"
	statusCard.Size = UDim2.new(1, 0, 0, 72)
	statusCard.BackgroundColor3 = COLORS.glassSurface
	statusCard.BackgroundTransparency = 0.15
	statusCard.BorderSizePixel = 0
	statusCard.ZIndex = 52
	statusCard.Parent = scrollBody

	applyGlass(statusCard, {
		corner = CORNER.medium,
		stroke = true,
		strokeColor = COLORS.borderGlass,
		strokeThickness = 1,
		strokeTransparency = 0.7
	})

	local statusDot = Instance.new("Frame")
	statusDot.Name = "StatusDot"
	statusDot.Size = UDim2.new(0, 8, 0, 8)
	statusDot.Position = UDim2.new(0, 12, 0, 14)
	statusDot.BackgroundColor3 = COLORS.textMuted
	statusDot.BorderSizePixel = 0
	statusDot.ZIndex = 53
	statusDot.Parent = statusCard

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = CORNER.pill
	dotCorner.Parent = statusDot

	local statusTitle = Instance.new("TextLabel")
	statusTitle.Name = "StatusTitle"
	statusTitle.Size = UDim2.new(1, -34, 0, 16)
	statusTitle.Position = UDim2.new(0, 26, 0, 10)
	statusTitle.BackgroundTransparency = 1
	statusTitle.Text = "CURRENT SERVER: IDLE (NORMAL)"
	statusTitle.TextColor3 = COLORS.textPrimary
	statusTitle.Font = Enum.Font.GothamBold
	statusTitle.TextSize = 11
	statusTitle.TextXAlignment = Enum.TextXAlignment.Left
	statusTitle.ZIndex = 53
	statusTitle.Parent = statusCard

	local statusSub = Instance.new("TextLabel")
	statusSub.Name = "StatusSub"
	statusSub.Size = UDim2.new(1, -24, 0, 18)
	statusSub.Position = UDim2.new(0, 12, 0, 28)
	statusSub.BackgroundTransparency = 1
	statusSub.Text = "Hopper State: Idle"
	statusSub.TextColor3 = COLORS.accentCyan
	statusSub.Font = Enum.Font.GothamMedium
	statusSub.TextSize = 10
	statusSub.TextXAlignment = Enum.TextXAlignment.Left
	statusSub.ZIndex = 53
	statusSub.Parent = statusCard

	local serverInfoLabel = Instance.new("TextLabel")
	serverInfoLabel.Name = "ServerInfo"
	serverInfoLabel.Size = UDim2.new(1, -24, 0, 16)
	serverInfoLabel.Position = UDim2.new(0, 12, 0, 48)
	serverInfoLabel.BackgroundTransparency = 1
	serverInfoLabel.Text = "JobId: " .. string.sub(tostring(game.JobId), 1, 14) .. "..."
	serverInfoLabel.TextColor3 = COLORS.textMuted
	serverInfoLabel.Font = Enum.Font.Code
	serverInfoLabel.TextSize = 9
	serverInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
	serverInfoLabel.ZIndex = 53
	serverInfoLabel.Parent = statusCard

	
	local targetSection = createSection(scrollBody, "Target Weather Setup", 2, true)

	local targetWeatherDropdown = createDropdown(
		targetSection,
		"Target Weather",
		{
			"Luck Event (2.5x Luck)",
			"Roll Speed Event (2x Roll)",
			"Cash Event (2.5x Money)",
			"Trait Event (2x Trait Luck)",
			"Grade Event (2x Grade Luck)",
			"Haunted Night (2x Candy/Pumpkin Luck)",
			"Any Weather"
		},
		"Luck Event (2.5x Luck)",
		function(v)
			if callbacks.OnTargetChange then
				callbacks.OnTargetChange(v)
			end
		end,
		1
	)

	local hopStrategyDropdown = createDropdown(
		targetSection,
		"Hop Strategy",
		{ "Fewest Players", "Random Server", "Lowest Ping" },
		"Fewest Players",
		function(v)
			if callbacks.OnStrategyChange then
				callbacks.OnStrategyChange(v)
			end
		end,
		2
	)

	
	local autoHopToggle = createToggle(
		targetSection,
		"Auto Hop For Target Weather",
		false,
		function(v)
			if callbacks.OnAutoHopToggle then
				callbacks.OnAutoHopToggle(v)
			end
		end,
		3
	)

	local autoRollWeatherToggle = createToggle(
		targetSection,
		"Auto Roll While Weather Active",
		false,
		function(v)
			if callbacks.OnAutoRollWeatherToggle then
				callbacks.OnAutoRollWeatherToggle(v)
			end
		end,
		4
	)

	local autoLuckPotionToggle = createToggle(
		targetSection,
		"Auto Use Luck Potions on Luck Weather",
		false,
		function(v)
			if callbacks.OnAutoUseLuckPotionToggle then
				callbacks.OnAutoUseLuckPotionToggle(v)
			end
		end,
		5
	)

	local autoExpireToggle = createToggle(
		targetSection,
		"Auto Hop When Weather Expires",
		false,
		function(v)
			if callbacks.OnExpireToggle then
				callbacks.OnExpireToggle(v)
			end
		end,
		6
	)

	
	local actionSection = createSection(scrollBody, "Manual Server Hop Actions", 3, true)

	local manualHopBtn = createButton(
		actionSection,
		"Hop to Next Server Now",
		function()
			if callbacks.OnManualHop then
				callbacks.OnManualHop()
			end
		end,
		1
	)

	
	local logSection = createSection(scrollBody, "Hopper Scanner Logs", 4, true)
	local hopperLogger = createLogConsole(logSection, 1, 100)
	hopperLogger.Log("Weather Server Hopper initialized.", COLORS.accentCyan)

	local function updateHopperUI(data)
		if not data then return end
		local active = data.Active and data.Remaining > 0
		if active then
			statusDot.BackgroundColor3 = COLORS.successGreen
			statusTitle.Text = string.format("WEATHER ACTIVE: %s", string.upper(data.Name or "UNKNOWN"))
			statusTitle.TextColor3 = COLORS.successGreen
			statusSub.Text = string.format("Farming active weather! %s remaining (%ds)", data.FormattedTime or "00:00",
				data.Remaining)
			statusSub.TextColor3 = COLORS.textWhite
		else
			statusDot.BackgroundColor3 = COLORS.textMuted
			statusTitle.Text = "CURRENT SERVER: NO WEATHER"
			statusTitle.TextColor3 = COLORS.textPrimary
			statusSub.Text = data.HopperStatusText or "Idle (Ready to hop for target weather)"
			statusSub.TextColor3 = COLORS.accentCyan
		end
	end

	return {
		Frame = winFrame,
		SetVisible = function(v)
			winFrame.Visible = v
			if v then
				winFrame.BackgroundTransparency = 0.4
				TweenService:Create(winFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundTransparency = TRANSPARENCY.glassMain }):Play()
			end
		end,
		Toggle = function()
			if winFrame.Visible then
				winFrame.Visible = false
			else
				winFrame.Visible = true
				winFrame.BackgroundTransparency = 0.4
				TweenService:Create(winFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundTransparency = TRANSPARENCY.glassMain }):Play()
			end
		end,
		Update = updateHopperUI,
		Logger = hopperLogger,
		SetAutoHop = function(v) if autoHopToggle and autoHopToggle.Set then autoHopToggle.Set(v) end end,
		SetAutoRollWeather = function(v) if autoRollWeatherToggle and autoRollWeatherToggle.Set then
				autoRollWeatherToggle.Set(v) end end,
		SetAutoUseLuckPotion = function(v) if autoLuckPotionToggle and autoLuckPotionToggle.Set then autoLuckPotionToggle
					.Set(v) end end,
		SetAutoHopExpire = function(v) if autoExpireToggle and autoExpireToggle.Set then autoExpireToggle.Set(v) end end,
		SetTarget = function(v) if targetWeatherDropdown and targetWeatherDropdown.Set then targetWeatherDropdown.Set(v) end end,
		SetStrategy = function(v) if hopStrategyDropdown and hopStrategyDropdown.Set then hopStrategyDropdown.Set(v) end end,
	}
end

local UI = {
	Gui = gui,
	MainFrame = mainFrame,
	ShadowFrame = shadowFrame,
	TopBar = topBar,
	TitleLogo = titleLogo,
	RestoreButton = restoreButton,
	MinimizeUI = minimizeUI,
	RestoreUI = restoreUI,
	Notify = notify,
	CreateWeatherHopperWindow = createWeatherHopperWindow,
	CreateWeatherPredictorWindow = createWeatherHopperWindow,
	Tabs = {
		Main = tabMain,
		Dashboard = tabMain,
		Roll = tabMain,
		Plot = tabMain,

		Tower = tabTower,
		Towers = tabTower,

		Team = tabTeam,

		Sell = tabSell,
		Inventory = tabSell,

		Shop = tabShop,
		Trade = tabShop,
		Trading = tabShop,

		Upgrades = tabUpgrades,
		Units = tabUpgrades,

		Halloween = tabHalloween,
		Event = tabHalloween,

		Misc = tabMisc,
		Rewards = tabMisc,
		Webhook = tabMisc,
		Settings = tabMisc,
	},
	CreateSection = createSection,
	CreateCollapsibleSection = createSection,
	CreateToggle = createToggle,
	CreateSlider = createSlider,
	CreateButton = createButton,
	CreateButtonRow = createButtonRow,
	CreateDropdown = createDropdown,
	CreateMultiDropdown = createMultiDropdown,
	CreateDropdownMenu = createDropdownMenu,
	CreateTextBox = createTextBox,
	CreateStatBox = createStatBox,
	CreateDivider = createDivider,
	CreateSubHeader = createDivider,
	CreateLogConsole = createLogConsole,
	CloseDropdowns = closeDropdowns,
	SelectTab = selectTab,
	Colors = COLORS
}

_G.HipHub_AnimeDice_UI = UI

end

do




local success, err = xpcall(function()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	if _G.HipHub_DA_ScriptCleanup then
		pcall(_G.HipHub_DA_ScriptCleanup)
	end
	local scriptRunning = true
	_G.HipHub_DA_ScriptCleanup = function()
		scriptRunning = false
	end

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	while not player do
		task.wait(0.5)
		player = Players.LocalPlayer
	end

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")

	
	local settingsWaitStart = os.clock()
	while not _G.HipHub_AnimeDice_Settings and (os.clock() - settingsWaitStart) < 5 do
		task.wait(0.05)
	end
	local Settings = _G.HipHub_AnimeDice_Settings
	if not Settings then
		pcall(function()
			Settings = loadstring(readfile("HipHub/AnimeDice/settings.lua") or "")()
		end)
	end
	if not Settings or type(Settings) ~= "table" then
		pcall(function()
			Settings = require(script.Parent.settings)
		end)
	end

	local uiWaitStart = os.clock()
	while not _G.HipHub_AnimeDice_UI and (os.clock() - uiWaitStart) < 5 do
		task.wait(0.05)
	end
	local UI = _G.HipHub_AnimeDice_UI
	if not UI then
		pcall(function()
			UI = loadstring(readfile("HipHub/AnimeDice/ui.lua") or "")()
		end)
	end
	if not UI or type(UI) ~= "table" then
		pcall(function()
			UI = require(script.Parent.ui)
		end)
	end

	if not UI then
		warn("[HipHub DA Error]: UI module not loaded")
		return
	end

	local cfg = (Settings and Settings.Current) or {}

	
	
	
	local Framework = ReplicatedStorage:WaitForChild("Framework", 10)
	local Features = Framework and Framework:WaitForChild("Features", 10)

	local DataController = nil
	pcall(function()
		DataController = require(Features.Data.DataController)
	end)

	local TreeStructure = nil
	local Upgrades = nil
	pcall(function()
		TreeStructure = require(Features.Upgrades.TreeStructure)
		Upgrades = require(Features.Upgrades.Upgrades)
	end)

	local Dice = nil
	pcall(function()
		Dice = require(Features.Rolling.Dice)
	end)

	local Towers = nil
	local TowerRefs = nil
	pcall(function()
		Towers = require(Features.Towers.Towers)
		TowerRefs = require(Features.Towers.TowerRefs)
	end)

	local Rarities = nil
	pcall(function()
		Rarities = require(Framework.Other.Rarities)
	end)

	local Traits = nil
	pcall(function()
		Traits = require(Features.Traits.Traits)
	end)

	local Grades = nil
	pcall(function()
		Grades = require(Features.Grades.Grades)
	end)

	local NumberFormatter = nil
	pcall(function()
		NumberFormatter = require(ReplicatedStorage.Packages.NumberFormatter)
	end)

	local UnitUtil = nil
	local UnitConfig = nil
	local EntryRegistry = nil
	local BuffController = nil
	pcall(function()
		UnitUtil = require(Features.Inventory.Kinds.Unit.UnitUtil)
		UnitConfig = require(Features.Inventory.Kinds.Unit.UnitConfig)
		EntryRegistry = require(Features.Inventory.EntryRegistry)
		BuffController = require(Features.Buffs.BuffController)
	end)

	local PlotConfig = nil
	pcall(function()
		PlotConfig = require(Features.Plot.PlotConfig)
	end)

	local RollCutscene = nil
	local RollController = nil
	pcall(function()
		RollCutscene = require(Features.Rolling.RollCutscene)
		RollController = require(Features.Rolling.RollController)
		if hookfunction and RollCutscene then
			local originalCutscene = nil
			originalCutscene = hookfunction(RollCutscene, function(...)
				if (cfg.skipFuseCutscene ~= false) or (cfg.instantRoll == true) then
					return
				end
				return originalCutscene(...)
			end)
		end
		if hookfunction and RollController and RollController.PlayCutscene then
			local originalPlayCutscene = nil
			originalPlayCutscene = hookfunction(RollController.PlayCutscene, function(self, ...)
				if (cfg.skipFuseCutscene ~= false) or (cfg.instantRoll == true) then
					return
				end
				return originalPlayCutscene(self, ...)
			end)
		end
	end)

	
	
	
	local Net = ReplicatedStorage:WaitForChild("Network", 10)

	local rollRF = Net:WaitForChild("RollService"):WaitForChild("RF"):WaitForChild("RollDice")
	local collectBalanceRE = Net:WaitForChild("PlotService"):WaitForChild("RE"):WaitForChild("CollectBalance")
	local levelUpSlotRE = Net:WaitForChild("PlotService"):WaitForChild("RE"):WaitForChild("LevelUpSlot")
	local equipBestPlotRE = Net:WaitForChild("PlotService"):WaitForChild("RE"):WaitForChild("EquipBest")
	local interactSlotRE = nil
	pcall(function()
		interactSlotRE = Net:WaitForChild("PlotService", 5):WaitForChild("RE", 5):WaitForChild("InteractSlot", 5)
	end)

	local playTowerRF = Net:WaitForChild("Towers"):WaitForChild("RF"):WaitForChild("PlayTower")
	local completeTowerFloorRF = Net:WaitForChild("Towers"):WaitForChild("RF"):WaitForChild("CompleteTowerFloor")
	local cancelTowerRF = Net:WaitForChild("Towers"):WaitForChild("RF"):WaitForChild("CancelTower")
	local equipBestTowerTeamRE = Net:WaitForChild("Towers"):WaitForChild("RE"):WaitForChild("EquipBestTowerTeam")

	local buyUpgradeRE = Net:WaitForChild("RE"):WaitForChild("BuyUpgrade")
	local buyDiceRE = Net:WaitForChild("DiceShopService"):WaitForChild("RE"):WaitForChild("BuyDice")
	local equipDiceRE = Net:WaitForChild("DiceShopService"):WaitForChild("RE"):WaitForChild("EquipDice")

	local sellInventoryRF = Net:WaitForChild("SellService"):WaitForChild("RF"):WaitForChild("SellInventory")
	local sellEquippedRF = Net:WaitForChild("SellService"):WaitForChild("RF"):WaitForChild("SellEquipped")

	local setLockedRE = Net:WaitForChild("UnitService"):WaitForChild("RE"):WaitForChild("SetLocked")
	local equipUnitRF = nil
	local unequipUnitRF = nil
	pcall(function()
		equipUnitRF = Net:WaitForChild("UnitService", 5):WaitForChild("RF", 5):WaitForChild("Equip", 5)
		unequipUnitRF = Net:WaitForChild("UnitService", 5):WaitForChild("RF", 5):WaitForChild("Unequip", 5)
	end)
	local rollTraitRE = Net:WaitForChild("TraitService"):WaitForChild("RE"):WaitForChild("Roll")
	local rollGradeRE = Net:WaitForChild("GradeService"):WaitForChild("RE"):WaitForChild("Roll")
	local rollQuirkRE = nil
	local setQuirkProtectedRE = nil
	pcall(function()
		local quirkSvc = Net:WaitForChild("QuirkService", 5)
		local qRE = quirkSvc and quirkSvc:WaitForChild("RE", 5)
		if qRE then
			rollQuirkRE = qRE:FindFirstChild("Roll") or qRE:WaitForChild("Roll", 5)
			setQuirkProtectedRE = qRE:FindFirstChild("SetQuirkProtected") or qRE:WaitForChild("SetQuirkProtected", 5)
		end
	end)
	local rebirthRE = Net:WaitForChild("RebirthService"):WaitForChild("RE"):WaitForChild("Rebirth")
	local useResetTokenRE = nil
	pcall(function()
		useResetTokenRE = Net:WaitForChild("RebirthService", 5):WaitForChild("RE", 5):WaitForChild("UseResetToken", 5)
	end)

	local claimDailyRE = Net:WaitForChild("DailyRewardService"):WaitForChild("RE"):WaitForChild("Claim")
	local claimGroupRE = Net:WaitForChild("GroupRewardService"):WaitForChild("RE"):WaitForChild("Claim")
	local claimOfflineRE = Net:WaitForChild("OfflineEarningsService"):WaitForChild("RE"):WaitForChild("Claim")
	local claimQuestRE = Net:WaitForChild("QuestService"):WaitForChild("RE"):WaitForChild("Claim")
	local buyQuestRE = Net:FindFirstChild("QuestService") and Net.QuestService:FindFirstChild("RE") and
		Net.QuestService.RE:FindFirstChild("Buy")
	if not buyQuestRE then
		pcall(function()
			buyQuestRE = Net:WaitForChild("QuestService", 5):WaitForChild("RE", 5):WaitForChild("Buy", 5)
		end)
	end

	local redeemCodeRE = Net:FindFirstChild("CodesService") and Net.CodesService:FindFirstChild("RE") and
		Net.CodesService.RE:FindFirstChild("RedeemCode")
	if not redeemCodeRE then
		pcall(function()
			redeemCodeRE = Net:WaitForChild("CodesService", 5):WaitForChild("RE", 5):WaitForChild("RedeemCode", 5)
		end)
	end

	local useSpinRE = Net:FindFirstChild("SpinService") and Net.SpinService:FindFirstChild("RE") and
		Net.SpinService.RE:FindFirstChild("Use")
	if not useSpinRE then
		pcall(function()
			useSpinRE = Net:WaitForChild("SpinService", 5):WaitForChild("RE", 5):WaitForChild("Use", 5)
		end)
	end

	local fuseRE = Net:FindFirstChild("FusingService") and Net.FusingService:FindFirstChild("RE") and
		Net.FusingService.RE:FindFirstChild("Fuse")
	if not fuseRE then
		pcall(function()
			fuseRE = Net:WaitForChild("FusingService", 5):WaitForChild("RE", 5):WaitForChild("Fuse", 5)
		end)
	end
	local fuseResultRE = Net:FindFirstChild("FusingService") and Net.FusingService:FindFirstChild("RE") and
		Net.FusingService.RE:FindFirstChild("Result")
	if not fuseResultRE then
		pcall(function()
			fuseResultRE = Net:WaitForChild("FusingService", 5):WaitForChild("RE", 5):WaitForChild("Result", 5)
		end)
	end

	local dropNotificationRE = Net:FindFirstChild("NotificationService") and Net.NotificationService:FindFirstChild("RE") and
		Net.NotificationService.RE:FindFirstChild("DropNotification")
	local useBoostRE = Net:FindFirstChild("BoostService") and Net.BoostService:FindFirstChild("RE") and
		Net.BoostService.RE:FindFirstChild("Use")
	if not useBoostRE then
		pcall(function()
			useBoostRE = Net:WaitForChild("BoostService", 5):WaitForChild("RE", 5):WaitForChild("Use", 5)
		end)
	end

	local equipGearRE = Net:FindFirstChild("GearService") and Net.GearService:FindFirstChild("RE") and
		Net.GearService.RE:FindFirstChild("Equip")
	if not equipGearRE then
		pcall(function()
			equipGearRE = Net:WaitForChild("GearService", 5):WaitForChild("RE", 5):WaitForChild("Equip", 5)
		end)
	end
	local gearSignal = nil
	pcall(function()
		local NetworkPkg = require(ReplicatedStorage.Packages.Network)
		gearSignal = NetworkPkg.ClientComm.new(ReplicatedStorage.Network, false, "GearService"):GetSignal("Equip")
	end)

	local tradeFolder = Net:WaitForChild("TradeService", 10)
	local tradeRE = tradeFolder and tradeFolder:WaitForChild("RE", 10)
	local requestTradeRE = tradeRE and tradeRE:WaitForChild("RequestTrade", 10)
	local respondToRequestRE = tradeRE and tradeRE:WaitForChild("RespondToRequest", 10)
	local changeOfferRE = tradeRE and tradeRE:WaitForChild("ChangeOffer", 10)
	local advanceTradeRE = tradeRE and tradeRE:WaitForChild("AdvanceTrade", 10)
	local cancelTradeRE = tradeRE and tradeRE:WaitForChild("CancelTrade", 10)
	local tradeEventRE = tradeRE and tradeRE:WaitForChild("TradeEvent", 10)

	
	
	
	local RARITY_RANK = {
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Epic = 4,
		Legendary = 5,
		Mythical = 6,
		Divine = 7,
		Exotic = 8,
		Celestial = 9,
		["Secret I"] = 10,
		["Secret II"] = 10,
		Heavenly = 11,
		Galactic = 12,
		Cosmic = 13,
		Exclusive = 14,
		Haunted = 15,
		Supreme = 16
	}

	local ALL_RARITIES = {
		"Common", "Uncommon", "Rare", "Epic", "Legendary",
		"Mythical", "Divine", "Exotic", "Celestial", "Secret I", "Secret II", "Heavenly", "Galactic", "Cosmic",
		"Exclusive",
		"Haunted", "Supreme"
	}

	
	local ALL_TOWERS = {
		"Dragon Tower", "Cursed Tower", "Pirate Tower", "Hidden Leaf Tower", "Slayer Tower", "Shadow Tower",
		"Infinity Tower",
		"Front Yard", "Foyer", "Crypt", "Attic", "Bell Tower", "Catacombs", "The Abyss"
	}

	local ALL_TRAITS = {
		"Genesis",
		"Paradox", "Eternal", "Transcendent", "Monarch", "Shogun", "Samurai",
		"Damage III", "Damage II", "Damage I",
		"Health III", "Health II", "Health I",
		"Money III", "Money II", "Money I"
	}

	local ALL_GRADES = {
		"Ω", "∞", "神", "Z+", "Z", "S+", "S", "A+", "A", "B", "C", "D"
	}

	local ALL_QUIRKS = {
		"Sovereign", "Fortune's Favor", "Midas Touch", "Tycoon", "Prodigy",
		"Fortune III", "Wealth III", "Refined III", "Gifted III", "Swift III",
		"Fortune II", "Wealth II", "Refined II", "Gifted II", "Swift II",
		"Fortune I", "Wealth I", "Refined I", "Gifted I", "Swift I"
	}

	local ALL_TRADE_QUIRKS = {
		"Any Quirk",
		"Sovereign", "Fortune's Favor", "Midas Touch", "Tycoon", "Prodigy",
		"Fortune III", "Wealth III", "Refined III", "Gifted III", "Swift III",
		"Fortune II", "Wealth II", "Refined II", "Gifted II", "Swift II",
		"Fortune I", "Wealth I", "Refined I", "Gifted I", "Swift I"
	}

	local ALL_POTIONS = {
		"Luck I", "Luck II", "Luck III", "Luck IV",
		"Damage I", "Damage II", "Damage III", "Damage IV",
		"Income I", "Income II", "Income III", "Income IV",
		"Leaf Luck I", "Leaf Luck II", "Leaf Luck III",
		"Leaf Damage I", "Leaf Damage II", "Leaf Damage III",
		"Leaf Income I", "Leaf Income II", "Leaf Income III",
		"Pirate Luck I", "Pirate Luck II", "Pirate Luck III",
		"Pirate Damage I", "Pirate Damage II", "Pirate Damage III",
		"Pirate Income I", "Pirate Income II", "Pirate Income III",
		"Dragon Luck I", "Dragon Luck II", "Dragon Luck III",
		"Dragon Damage I", "Dragon Damage II", "Dragon Damage III",
		"Dragon Income I", "Dragon Income II", "Dragon Income III",
		"Cursed Luck I", "Cursed Luck II", "Cursed Luck III",
		"Cursed Damage I", "Cursed Damage II", "Cursed Damage III",
		"Cursed Income I", "Cursed Income II", "Cursed Income III",
		"Slayer Luck I", "Slayer Luck II", "Slayer Luck III",
		"Slayer Damage I", "Slayer Damage II", "Slayer Damage III",
		"Slayer Income I", "Slayer Income II", "Slayer Income III",
		"Shadow Luck I", "Shadow Luck II", "Shadow Luck III", "Shadow Luck IV",
		"Shadow Income I", "Shadow Income II", "Shadow Income III", "Shadow Income IV",
		"Shadow Speed I", "Shadow Speed II", "Shadow Speed III", "Shadow Speed IV",
		"Spooky Luck I", "Spooky Luck II", "Spooky Luck III",
		"Candy Pot I", "Candy Pot II", "Candy Pot III",
		"Pumpkin Pot I", "Pumpkin Pot II", "Pumpkin Pot III",
		"Haunted Potion"
	}

	local ALL_LUCK_POTIONS = {
		"Luck IV", "Luck III", "Luck II", "Luck I",
		"Spooky Luck III", "Spooky Luck II", "Spooky Luck I",
		"Shadow Luck IV", "Shadow Luck III", "Shadow Luck II", "Shadow Luck I",
		"Leaf Luck III", "Leaf Luck II", "Leaf Luck I",
		"Pirate Luck III", "Pirate Luck II", "Pirate Luck I",
		"Dragon Luck III", "Dragon Luck II", "Dragon Luck I",
		"Cursed Luck III", "Cursed Luck II", "Cursed Luck I",
		"Slayer Luck III", "Slayer Luck II", "Slayer Luck I"
	}

	local GEAR_SLOTS = {
		Head = { "Igras's Helm", "Obita's Mask", "Golden Hair", "Nezuka's Bamboo", "Usop's Hat", "Pumpkin Head" },
		Torso = { "Mazun's Coat", "Monarch's Coat", "Todoh's Vest", "Mummy Wraps" },
		Back = { "Enol's Drums", "Obita's War Fan", "Pikolo's Cape", "Jogu's Robe", "Shizui's Tanto", "Vampire Cape", "Reaper's Scythe" },
		Waist = { "Sakuna's Sash", "Tanjuro's Katana", "Zaro's Swords", "Jinwoo's Daggers", "Candy Bucket" },
		Upper = { "Angel's Halo", "Ghost Wisps" }
	}

	local GEAR_TO_SLOT = {
		["Igras's Helm"] = "Head",
		["Obita's Mask"] = "Head",
		["Golden Hair"] = "Head",
		["Nezuka's Bamboo"] = "Head",
		["Usop's Hat"] = "Head",
		["Mazun's Coat"] = "Torso",
		["Monarch's Coat"] = "Torso",
		["Todoh's Vest"] = "Torso",
		["Enol's Drums"] = "Back",
		["Obita's War Fan"] = "Back",
		["Pikolo's Cape"] = "Back",
		["Jogu's Robe"] = "Back",
		["Shizui's Tanto"] = "Back",
		["Angel's Halo"] = "Upper",
		["Sakuna's Sash"] = "Waist",
		["Tanjuro's Katana"] = "Waist",
		["Zaro's Swords"] = "Waist",
		["Jinwoo's Daggers"] = "Waist",
		["Pumpkin Head"] = "Head",
		["Mummy Wraps"] = "Torso",
		["Vampire Cape"] = "Back",
		["Candy Bucket"] = "Waist",
		["Ghost Wisps"] = "Upper",
		["Reaper's Scythe"] = "Back"
	}

	local ALL_GEARS = {
		"Igras's Helm", "Obita's Mask", "Mazun's Coat", "Monarch's Coat", "Enol's Drums", "Sakuna's Sash", "Angel's Halo",
		"Obita's War Fan", "Pikolo's Cape", "Jogu's Robe", "Tanjuro's Katana", "Zaro's Swords", "Jinwoo's Daggers",
		"Golden Hair", "Nezuka's Bamboo", "Usop's Hat", "Todoh's Vest", "Shizui's Tanto",
		"Pumpkin Head", "Mummy Wraps", "Vampire Cape", "Candy Bucket", "Ghost Wisps", "Reaper's Scythe"
	}

	local GEAR_SCORES = {
		["Luck Focus"] = {
			["Igras's Helm"] = 82.5,
			["Mazun's Coat"] = 50,
			["Obita's Mask"] = 40,
			["Enol's Drums"] = 40,
			["Angel's Halo"] = 30,
			["Sakuna's Sash"] = 30,
			["Obita's War Fan"] = 25,
			["Jinwoo's Daggers"] = 25,
			["Usop's Hat"] = 15,
			["Shizui's Tanto"] = 15,
			["Todoh's Vest"] = 12.5,
			["Monarch's Coat"] = 10,
			["Nezuka's Bamboo"] = 10,
			["Golden Hair"] = 5,
			["Zaro's Swords"] = 5,
			["Tanjuro's Katana"] = 5,
			["Pikolo's Cape"] = 5,
			["Jogu's Robe"] = 5,
			["Pumpkin Head"] = 100,
			["Mummy Wraps"] = 60,
			["Vampire Cape"] = 50,
			["Ghost Wisps"] = 40,
			["Reaper's Scythe"] = 100,
			["Candy Bucket"] = 40
		},
		["Money Focus"] = {
			["Igras's Helm"] = 100,
			["Mazun's Coat"] = 100,
			["Monarch's Coat"] = 88,
			["Tanjuro's Katana"] = 80,
			["Enol's Drums"] = 60,
			["Zaro's Swords"] = 60,
			["Obita's War Fan"] = 50,
			["Golden Hair"] = 40,
			["Sakuna's Sash"] = 30,
			["Obita's Mask"] = 30,
			["Angel's Halo"] = 25,
			["Todoh's Vest"] = 20,
			["Pikolo's Cape"] = 20,
			["Jogu's Robe"] = 20,
			["Jinwoo's Daggers"] = 15,
			["Usop's Hat"] = 15,
			["Shizui's Tanto"] = 15,
			["Nezuka's Bamboo"] = 10,
			["Mummy Wraps"] = 110,
			["Candy Bucket"] = 45,
			["Pumpkin Head"] = 30,
			["Vampire Cape"] = 25,
			["Ghost Wisps"] = 25,
			["Reaper's Scythe"] = 25
		},
		["Damage Focus"] = {
			["Sakuna's Sash"] = 100,
			["Monarch's Coat"] = 100,
			["Zaro's Swords"] = 80,
			["Pikolo's Cape"] = 80,
			["Igras's Helm"] = 50,
			["Mazun's Coat"] = 50,
			["Enol's Drums"] = 50,
			["Obita's Mask"] = 40,
			["Angel's Halo"] = 30,
			["Obita's War Fan"] = 30,
			["Tanjuro's Katana"] = 30,
			["Jogu's Robe"] = 25,
			["Jinwoo's Daggers"] = 20,
			["Todoh's Vest"] = 20,
			["Golden Hair"] = 20,
			["Usop's Hat"] = 20,
			["Shizui's Tanto"] = 20,
			["Nezuka's Bamboo"] = 20,
			["Mummy Wraps"] = 105,
			["Vampire Cape"] = 100,
			["Candy Bucket"] = 100,
			["Pumpkin Head"] = 20,
			["Ghost Wisps"] = 20,
			["Reaper's Scythe"] = 150
		},
		["Grade/Trait Focus"] = {
			["Igras's Helm"] = 100,
			["Obita's Mask"] = 100,
			["Sakuna's Sash"] = 100,
			["Jogu's Robe"] = 80,
			["Nezuka's Bamboo"] = 60,
			["Mazun's Coat"] = 40,
			["Enol's Drums"] = 40,
			["Monarch's Coat"] = 30,
			["Angel's Halo"] = 30,
			["Obita's War Fan"] = 30,
			["Pikolo's Cape"] = 30,
			["Tanjuro's Katana"] = 30,
			["Zaro's Swords"] = 30,
			["Jinwoo's Daggers"] = 20,
			["Todoh's Vest"] = 20,
			["Golden Hair"] = 20,
			["Usop's Hat"] = 20,
			["Shizui's Tanto"] = 20,
			["Pumpkin Head"] = 105,
			["Candy Bucket"] = 100,
			["Mummy Wraps"] = 40,
			["Vampire Cape"] = 30,
			["Ghost Wisps"] = 30,
			["Reaper's Scythe"] = 30
		},
		["Highest Tier"] = {
			["Igras's Helm"] = 100,
			["Obita's Mask"] = 100,
			["Mazun's Coat"] = 100,
			["Enol's Drums"] = 100,
			["Sakuna's Sash"] = 100,
			["Angel's Halo"] = 100,
			["Monarch's Coat"] = 70,
			["Obita's War Fan"] = 70,
			["Pikolo's Cape"] = 70,
			["Jogu's Robe"] = 70,
			["Tanjuro's Katana"] = 70,
			["Zaro's Swords"] = 70,
			["Jinwoo's Daggers"] = 40,
			["Golden Hair"] = 40,
			["Nezuka's Bamboo"] = 40,
			["Usop's Hat"] = 40,
			["Todoh's Vest"] = 40,
			["Shizui's Tanto"] = 40,
			["Pumpkin Head"] = 100,
			["Mummy Wraps"] = 100,
			["Vampire Cape"] = 100,
			["Candy Bucket"] = 100,
			["Ghost Wisps"] = 100,
			["Reaper's Scythe"] = 120
		}
	}

	local ALL_TRADE_ITEMS = {
		"Gems",
		"Trait Reroll",
		"Reset Token",
		"Jackpot Spin",
		"Lucky Spin",
		
		"Igras's Helm", "Obita's Mask", "Mazun's Coat", "Monarch's Coat", "Enol's Drums", "Sakuna's Sash", "Angel's Halo",
		"Obita's War Fan", "Pikolo's Cape", "Jogu's Robe", "Tanjuro's Katana", "Zaro's Swords", "Jinwoo's Daggers",
		"Golden Hair", "Nezuka's Bamboo", "Usop's Hat", "Todoh's Vest", "Shizui's Tanto",
		
		"Luck I", "Luck II", "Luck III", "Luck IV",
		"Damage I", "Damage II", "Damage III", "Damage IV",
		"Income I", "Income II", "Income III", "Income IV",
		"Leaf Luck I", "Leaf Luck II", "Leaf Luck III",
		"Leaf Damage I", "Leaf Damage II", "Leaf Damage III",
		"Leaf Income I", "Leaf Income II", "Leaf Income III",
		"Pirate Luck I", "Pirate Luck II", "Pirate Luck III",
		"Pirate Damage I", "Pirate Damage II", "Pirate Damage III",
		"Pirate Income I", "Pirate Income II", "Pirate Income III",
		"Dragon Luck I", "Dragon Luck II", "Dragon Luck III",
		"Dragon Damage I", "Dragon Damage II", "Dragon Damage III",
		"Dragon Income I", "Dragon Income II", "Dragon Income III",
		"Cursed Luck I", "Cursed Luck II", "Cursed Luck III",
		"Cursed Damage I", "Cursed Damage II", "Cursed Damage III",
		"Cursed Income I", "Cursed Income II", "Cursed Income III",
		"Slayer Luck I", "Slayer Luck II", "Slayer Luck III",
		"Slayer Damage I", "Slayer Damage II", "Slayer Damage III",
		"Slayer Income I", "Slayer Income II", "Slayer Income III",
		"Shadow Luck I", "Shadow Luck II", "Shadow Luck III", "Shadow Luck IV",
		"Shadow Income I", "Shadow Income II", "Shadow Income III", "Shadow Income IV",
		"Shadow Speed I", "Shadow Speed II", "Shadow Speed III", "Shadow Speed IV"
	}
	
	
	pcall(function()
		local TradeConfig = require(Features.Trading.TradeConfig)
		local seen, kept = {}, {}
		for _, name in ipairs(ALL_TRADE_ITEMS) do
			if TradeConfig.IsTradeable({ name = name }) then
				table.insert(kept, name)
				seen[name] = true
			end
		end
		for _, kindName in ipairs({ "Token", "Spin", "Gamepass", "Gear", "Boost" }) do
			local kind = Features.Inventory.Kinds:FindFirstChild(kindName)
			local entries = kind and require(kind[kindName .. "Config"]).entries or {}
			local extra = {}
			for name in pairs(entries) do
				if not seen[name] and TradeConfig.IsTradeable({ name = name }) then table.insert(extra, name) end
			end
			table.sort(extra)
			for _, name in ipairs(extra) do
				table.insert(kept, name)
				seen[name] = true
			end
		end
		ALL_TRADE_ITEMS = kept
	end)

	local ALL_GEAR_NAMES = {
		["Igras's Helm"] = true,
		["Obita's Mask"] = true,
		["Mazun's Coat"] = true,
		["Monarch's Coat"] = true,
		["Enol's Drums"] = true,
		["Sakuna's Sash"] = true,
		["Angel's Halo"] = true,
		["Obita's War Fan"] = true,
		["Pikolo's Cape"] = true,
		["Jogu's Robe"] = true,
		["Tanjuro's Katana"] = true,
		["Zaro's Swords"] = true,
		["Jinwoo's Daggers"] = true,
		["Golden Hair"] = true,
		["Nezuka's Bamboo"] = true,
		["Usop's Hat"] = true,
		["Todoh's Vest"] = true,
		["Shizui's Tanto"] = true,
		["Pumpkin Head"] = true,
		["Mummy Wraps"] = true,
		["Vampire Cape"] = true,
		["Candy Bucket"] = true,
		["Ghost Wisps"] = true,
		["Reaper's Scythe"] = true,
	}

	local ALL_TICKET_SHOP_ITEMS = {
		"Trait Reroll",
		"Gems",
		"Reset Token",
		"Lucky Spin",
		"Jackpot Spin",
		"Luck",
		"Ultra Luck",
		"More Cash",
		"Roll Speed",
		"More Grades",
		"More Traits"
	}

	local TICKET_SHOP_PRICES = {
		["Trait Reroll"] = 1,
		["Gems"] = 1,
		["Reset Token"] = 50,
		["Lucky Spin"] = 10,
		["Jackpot Spin"] = 100,
		["Luck"] = 199,
		["More Cash"] = 199,
		["More Grades"] = 299,
		["More Traits"] = 349,
		["Roll Speed"] = 499,
		["Ultra Luck"] = 599
	}

	local TICKET_SHOP_GAMEPASSES = {
		["Luck"] = true,
		["Ultra Luck"] = true,
		["More Cash"] = true,
		["Roll Speed"] = true,
		["More Grades"] = true,
		["More Traits"] = true
	}

	pcall(function()
		local qc = Features and Features.Quests and Features.Quests.QuestConfig
		if not qc and ReplicatedStorage:FindFirstChild("Framework") then
			local fw = ReplicatedStorage.Framework
			local fts = fw:FindFirstChild("Features")
			local qf = fts and fts:FindFirstChild("Quests")
			qc = qf and qf:FindFirstChild("QuestConfig")
		end
		if qc then
			local qcfg = require(qc)
			if qcfg and qcfg.Shop then
				for _, item in ipairs(qcfg.Shop) do
					if item.name then
						if item.tickets then
							TICKET_SHOP_PRICES[item.name] = item.tickets
						end
						if item.gamepass then
							TICKET_SHOP_GAMEPASSES[item.name] = true
						end
						if not table.find(ALL_TICKET_SHOP_ITEMS, item.name) then
							table.insert(ALL_TICKET_SHOP_ITEMS, item.name)
						end
					end
				end
			end
		end
	end)

	local function formatNumber(n)
		if not n then return "0" end
		if NumberFormatter and NumberFormatter.FormatCompact then
			local ok, res = pcall(function() return NumberFormatter.FormatCompact(n, 2) end)
			if ok and res then return res end
		end
		if n >= 1e33 then return string.format("%.2fDc", n / 1e33) end
		if n >= 1e30 then return string.format("%.2fNo", n / 1e30) end
		if n >= 1e27 then return string.format("%.2fOc", n / 1e27) end
		if n >= 1e24 then return string.format("%.2fSp", n / 1e24) end
		if n >= 1e21 then return string.format("%.2fSx", n / 1e21) end
		if n >= 1e18 then return string.format("%.2fQi", n / 1e18) end
		if n >= 1e15 then return string.format("%.2fQa", n / 1e15) end
		if n >= 1e12 then return string.format("%.2fT", n / 1e12) end
		if n >= 1e9 then return string.format("%.2fB", n / 1e9) end
		if n >= 1e6 then return string.format("%.2fM", n / 1e6) end
		if n >= 1e3 then return string.format("%.2fK", n / 1e3) end
		return tostring(math.floor(n))
	end

	local function parseChance(str)
		if type(str) == "number" then return str end
		if type(str) ~= "string" then return 0 end
		local clean = string.lower(str):gsub("1%s*in%s*", ""):gsub("1%s*/%s*", ""):gsub("[%$,/%s%+%-><=%[%]%(%)]", "")
		local num, suffix = clean:match("^([%d%.]+)([a-z]*)$")
		if not num then
			num = clean:match("[%d%.]+")
			suffix = clean:match("[a-z]+$") or ""
		end
		if not num then return 0 end
		local val = tonumber(num) or 0
		suffix = suffix or ""

		local multipliers = {
			k = 1e3,
			m = 1e6,
			b = 1e9,
			t = 1e12,
			qa = 1e15,
			qd = 1e15,
			q = 1e15,
			qi = 1e18,
			qn = 1e18,
			sx = 1e21,
			sp = 1e24,
			oc = 1e27,
			no = 1e30,
			dc = 1e33,
			udc = 1e36,
			ddc = 1e39,
			tdc = 1e42,
			qadc = 1e45,
			qidc = 1e48,
			sxdc = 1e51,
			spdc = 1e54,
			ocdc = 1e57,
			nodc = 1e60,
			vg = 1e63
		}
		if multipliers[suffix] then return val * multipliers[suffix] end
		return val
	end

	local function getUnitChance(unitName, attributes)
		if not unitName or unitName == "Unknown" then return 1 end
		local ok, cfgModule = pcall(function()
			return require(Features.Inventory.EntryRegistry).getEntryConfig(unitName)
		end)
		if ok and cfgModule and cfgModule.chance then
			local okChance, chanceVal = pcall(cfgModule.chance, attributes or {})
			if okChance and type(chanceVal) == "number" then
				return chanceVal
			end
		end
		return 1
	end

	local function parseMoneyValue(str)
		if type(str) == "number" then
			if str < 1e8 and str > 0 then
				return str * 1e6
			end
			return str
		end
		if type(str) ~= "string" then return 0 end
		local clean = string.lower(str):gsub("[%$,/%s%+%-><=%[%]%(%)]", ""):gsub("1in", ""):gsub("/s", "")

		
		local sci = tonumber(clean)
		if sci and (clean:find("e") or clean:find("e%+") or clean:find("e%-")) then
			return sci
		end

		local num, suffix = clean:match("^([%d%.]+)([a-z]*)$")
		if not num then
			num = clean:match("[%d%.]+")
			suffix = clean:match("[a-z]+$") or ""
		end
		if not num then return 0 end
		local val = tonumber(num) or 0
		suffix = suffix or ""

		local multipliers = {
			k = 1e3,
			m = 1e6,
			b = 1e9,
			t = 1e12,
			qa = 1e15,
			qd = 1e15,
			q = 1e15,
			qi = 1e18,
			qn = 1e18,
			sx = 1e21,
			sp = 1e24,
			oc = 1e27,
			no = 1e30,
			dc = 1e33,
			udc = 1e36,
			ddc = 1e39,
			tdc = 1e42,
			qadc = 1e45,
			qidc = 1e48,
			sxdc = 1e51,
			spdc = 1e54,
			ocdc = 1e57,
			nodc = 1e60,
			vg = 1e63,
		}

		if multipliers[suffix] then
			return val * multipliers[suffix]
		elseif suffix == "" then
			
			
			
			if val < 1e8 and val > 0 then
				return val * 1e6
			else
				return val
			end
		end
		return val
	end

	local function getUnitIncome(unitName, attributes)
		if not unitName or unitName == "Unknown" then return 0 end
		local ok, cfgModule = pcall(function()
			return require(Features.Inventory.EntryRegistry).getEntryConfig(unitName)
		end)
		if ok and cfgModule and cfgModule.income then
			local okIncome, incomeVal = pcall(cfgModule.income, attributes or {})
			if okIncome and type(incomeVal) == "number" then
				return incomeVal
			end
		end
		return 0
	end

	local function extractInventory(invObj)
		if DataController then
			if typeof(DataController) == "function" or (getmetatable(DataController) and getmetatable(DataController).__call) then
				local ok, full = pcall(DataController)
				if ok and full and type(full) == "table" and full.Inventory and type(full.Inventory) == "table" then
					return full.Inventory
				end
			end
			if DataController.GetData and type(DataController.GetData) == "function" then
				local ok, full = pcall(function() return DataController:GetData() end)
				if ok and full and type(full) == "table" and full.Inventory and type(full.Inventory) == "table" then
					return full.Inventory
				end
			end
		end
		if not invObj then return {} end
		if typeof(invObj) == "function" or (getmetatable(invObj) and getmetatable(invObj).__call) then
			local ok, res = pcall(invObj)
			if ok and res and type(res) == "table" then
				if res.Inventory then return res.Inventory end
				return res
			end
		end
		if typeof(invObj) == "table" then
			local ok, res = pcall(function() return invObj() end)
			if ok and res and type(res) == "table" then
				if res.Inventory then return res.Inventory end
				return res
			end
			if invObj.___X and invObj.___X.Inventory then
				return invObj.___X.Inventory
			end
			if invObj.Inventory then
				return invObj.Inventory
			end
			local units = {}
			for k, v in pairs(invObj) do
				if typeof(v) == "table" and (v.name or v.id or v.attributes) then
					units[k] = v
				end
			end
			if next(units) then return units end
		end
		return {}
	end

	local function isUnitEntry(k, v)
		if typeof(v) ~= "table" then return false end
		local kStr = tostring(k)
		if #kStr == 36 and string.match(kStr, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
			return true
		end
		if v.name then
			local entryCfg = nil
			pcall(function()
				if EntryRegistry and EntryRegistry.getEntryConfig then
					entryCfg = EntryRegistry.getEntryConfig(v.name)
				end
			end)
			if entryCfg and entryCfg.kind == "Unit" then
				return true
			end
			if UnitConfig and UnitConfig.entries and UnitConfig.entries[v.name] then
				return true
			end
		end
		if v.attributes and (v.attributes.level or v.attributes.mutation or v.attributes.grade or v.attributes.trait) then
			return true
		end
		return false
	end

	local function getUnitCountAndCapacity()
		local rawInv = nil
		if DataController and DataController.Inventory then
			pcall(function()
				rawInv = DataController.Inventory()
			end)
		end
		if not rawInv then
			rawInv = extractInventory(DataController and DataController.Inventory)
		end
		local unitCount = 0
		if type(rawInv) == "table" then
			for k, v in pairs(rawInv) do
				if isUnitEntry(k, v) then
					unitCount = unitCount + 1
				end
			end
		end

		local maxCap = 0
		pcall(function()
			if BuffController and BuffController.GetBuff then
				maxCap = tonumber(BuffController.GetBuff("Unit Storage")) or 0
			end
		end)
		if maxCap == 0 then
			pcall(function()
				local p = Players.LocalPlayer
				local storageLabel = p and p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("Root")
				local text = storageLabel and
					storageLabel.Menus.Backpack.Units.Actions.Storage.Frame.Info.StorageText.Text
				if text then
					local _, cap = string.match(text, "(%d+)/(%d+)")
					if cap then maxCap = tonumber(cap) or 0 end
				end
			end)
		end

		return unitCount, maxCap
	end

	local function isUnitLocked(key, unitObj)
		if not key and not unitObj then return false end
		local keyStr = tostring(key)
		
		if typeof(unitObj) == "table" then
			if unitObj.locked == true then return true end
			if unitObj.attributes and unitObj.attributes.locked == true then return true end
		end
		
		local isL = false
		pcall(function()
			if DataController and DataController.Inventory and keyStr and DataController.Inventory[keyStr] then
				local entry = DataController.Inventory[keyStr]()
				if entry and entry.attributes and entry.attributes.locked == true then
					isL = true
				end
			end
		end)
		if isL then return true end
		
		pcall(function()
			if DataController and DataController.___X and DataController.___X.Inventory and keyStr then
				local entry = DataController.___X.Inventory[keyStr]
				if entry and entry.attributes and entry.attributes.locked == true then
					isL = true
				end
			end
		end)
		return isL
	end

	local function getLiveUnitData(unitKey)
		if not unitKey then return nil end
		local kStr = tostring(unitKey)
		local u = nil
		if DataController and DataController.Inventory then
			pcall(function()
				if typeof(DataController.Inventory[kStr]) == "function" or (getmetatable(DataController.Inventory[kStr]) and getmetatable(DataController.Inventory[kStr]).__call) then
					u = DataController.Inventory[kStr]()
				end
			end)
			if not u then
				pcall(function()
					local raw = DataController.Inventory()
					if raw and raw[kStr] then u = raw[kStr] end
				end)
			end
		end
		if not u then
			local inv = extractInventory(DataController and DataController.Inventory)
			u = inv[kStr]
		end
		return u
	end

	
	local function getMaxPlotSlots()
		local ok, ms = pcall(function() return PlotConfig.GetMaxSlots() end)
		return (ok and typeof(ms) == "number") and ms or 20
	end

	local function getUnlockedPlotSlots()
		local rebirth = 0
		if DataController and DataController.Rebirth then
			local ok, r = pcall(DataController.Rebirth)
			if ok and typeof(r) == "number" then rebirth = r end
		end
		local unlocked = {}
		for slotNum = 1, getMaxPlotSlots() do
			local req = 0
			if PlotConfig and PlotConfig.GetSlotRebirthRequirement then
				local ok, rq = pcall(PlotConfig.GetSlotRebirthRequirement, slotNum)
				if ok and typeof(rq) == "number" then req = rq end
			end
			if rebirth >= req then
				table.insert(unlocked, slotNum)
			end
		end
		if #unlocked == 0 then
			table.insert(unlocked, 1)
		end
		return unlocked
	end

	local function getUnmaxedInventoryUnits(targetLvl)
		targetLvl = targetLvl or tonumber(cfg.backpackTargetLevel) or 50
		local inv = extractInventory(DataController and DataController.Inventory)

		local placedIds = {}
		if DataController and DataController.Slots then
			local ok, slots = pcall(function()
				if typeof(DataController.Slots) == "function" then
					return DataController.Slots()
				end
				return DataController.Slots
			end)
			if ok and slots and type(slots) == "table" then
				for _, s in pairs(slots) do
					local sData = (typeof(s) == "function" and s()) or s
					if sData and sData.unitId then
						placedIds[tostring(sData.unitId)] = true
					end
				end
			end
			for slotNum = 1, getMaxPlotSlots() do
				pcall(function()
					local slotGetter = DataController.Slots[tostring(slotNum)]
					local sData = (typeof(slotGetter) == "function" and slotGetter()) or slotGetter
					if sData and sData.unitId then
						placedIds[tostring(sData.unitId)] = true
					end
				end)
			end
		end

		local unmaxed = {}
		for id, item in pairs(inv) do
			if isUnitEntry(id, item) and not placedIds[tostring(id)] then
				local lvl = tonumber(item.attributes and item.attributes.level or 1) or 1
				if lvl < targetLvl then
					table.insert(unmaxed, {
						id = tostring(id),
						name = item.name or "Unit",
						level = lvl,
						attributes = item.attributes or {}
					})
				end
			end
		end
		return unmaxed
	end

	
	
	
	local inTowerActive = false
	local currentActiveTowerName = nil
	local lastGemsCount = nil
	local lastTraitPotCount = nil

	local function sendWebhook(title, description, fields, color)
		if not cfg.webhookEnabled or not cfg.webhookUrl or cfg.webhookUrl == "" then
			return
		end
		pcall(function()
			local httpRequest = (syn and syn.request) or (http and http.request) or http_request or
				(Fluxus and Fluxus.request) or request
			if not httpRequest then return end

			local embed = {
				title = title,
				description = description,
				color = color or 5814783,
				fields = fields or {},
				footer = { text = "HipHub - Anime Dice | " .. player.Name },
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}

			local payload = HttpService:JSONEncode({
				username = "HipHub Tracker",
				embeds = { embed }
			})

			httpRequest({
				Url = cfg.webhookUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = payload
			})
		end)
	end

	local function getGemsCount()
		if not DataController or not DataController.Inventory then return 0 end
		local ok, inv = pcall(DataController.Inventory)
		if ok and type(inv) == "table" and inv.Gems and inv.Gems.amount then
			return tonumber(inv.Gems.amount) or 0
		end
		return 0
	end

	local function getTraitPotCount()
		if not DataController or not DataController.Inventory then return 0 end
		local ok, inv = pcall(DataController.Inventory)
		if ok and type(inv) == "table" then
			if inv["Trait Reroll"] and inv["Trait Reroll"].amount then
				return tonumber(inv["Trait Reroll"].amount) or 0
			end
			if inv["Trait Potion"] and inv["Trait Potion"].amount then
				return tonumber(inv["Trait Potion"].amount) or 0
			end
			if inv["Trait Pot"] and inv["Trait Pot"].amount then
				return tonumber(inv["Trait Pot"].amount) or 0
			end
		end
		return 0
	end

	local function notifyGemsReceived(amountGained, totalBalance, source)
		if not cfg.webhookNotifyGems then return end
		local sourceText = source or "Gameplay Reward"
		sendWebhook(
			"Gems Obtained",
			string.format("Player **%s** received **+%s Gems**!", player.Name, formatNumber(amountGained)),
			{
				{ name = "Gems Gained",   value = string.format("+%s", formatNumber(amountGained)), inline = true },
				{ name = "Total Balance", value = formatNumber(totalBalance),                       inline = true },
				{ name = "Source",        value = sourceText,                                       inline = true }
			},
			3447003
		)
	end

	local function notifyTraitPotReceived(amountGained, totalOwned, source)
		if not cfg.webhookNotifyTraitPot then return end
		local sourceText = source or "Gameplay Drop"
		sendWebhook(
			"Trait Potion Obtained",
			string.format("Player **%s** obtained **+%d Trait Potion(s)**!", player.Name, amountGained),
			{
				{ name = "Amount Gained", value = string.format("+%d", amountGained), inline = true },
				{ name = "Total Owned",   value = tostring(totalOwned),               inline = true },
				{ name = "Source",        value = sourceText,                         inline = true }
			},
			10181046
		)
	end

	local function notifyWeatherStarted(weatherName, duration, buffDesc)
		if not cfg.webhookNotifyWeather then return end
		local embedColor = 65535
		if string.find(weatherName, "Luck") then
			embedColor = 5763719
		elseif string.find(weatherName, "Speed") or string.find(weatherName, "Dice") or string.find(weatherName, "Roll") then
			embedColor = 10181046
		elseif string.find(weatherName, "Cash") or string.find(weatherName, "Money") then
			embedColor = 16766720
		elseif string.find(weatherName, "Trait") then
			embedColor = 15844367
		elseif string.find(weatherName, "Grade") then
			embedColor = 3447003
		end

		sendWebhook(
			"Weather Event Active",
			string.format("Weather event **%s** has started on the server!", weatherName),
			{
				{ name = "Event Name",  value = weatherName,                                                            inline = true },
				{ name = "Duration",    value = string.format("%d Minutes (%ds)", math.floor(duration / 60), duration), inline = true },
				{ name = "Buff Effect", value = buffDesc or "Special Server Buff",                                      inline = false }
			},
			embedColor
		)
	end

	
	
	
	local WeatherTracker = {
		Active = false,
		Name = "None",
		Duration = 0,
		StartedAt = 0,
		Remaining = 0,
		BuffDescription = "Normal conditions",
		LastNotifiedName = nil
	}

	local function formatWeatherTime(seconds)
		if not seconds or seconds <= 0 then return "00:00" end
		local mins = math.floor(seconds / 60)
		local secs = math.floor(seconds % 60)
		return string.format("%02d:%02d", mins, secs)
	end

	local function getWeatherBuffText(weatherName)
		if weatherName == "Luck Event" then
			return "Luck Multiplier: 2x (+100%)"
		elseif weatherName == "Roll Speed Event" then
			return "Roll Speed: 2x Faster (0.5x duration)"
		elseif weatherName == "Cash Event" then
			return "Money Multiplier: 2.5x (+150%)"
		elseif weatherName == "Trait Event" then
			return "Trait Luck: 2x Higher (+100%)"
		elseif weatherName == "Grade Event" then
			return "Grade Luck: 2x Higher (+100%)"
		elseif weatherName == "Haunted Night" then
			return "Candy Gain 2x + Pumpkin Luck 2x"
		end
		return "Normal Rates (No active buffs)"
	end

	local weatherBoxes = nil

	local function updateWeatherState(raw)
		if raw and type(raw) == "table" and raw.name and raw.startedAt and raw.duration then
			local sTime = workspace:GetServerTimeNow()
			local elapsed = math.max(0, sTime - raw.startedAt)
			local rem = math.max(0, math.floor(raw.duration - elapsed))
			if rem > 0 then
				local isNew = (WeatherTracker.LastNotifiedName ~= raw.name) or not WeatherTracker.Active
				WeatherTracker.Active = true
				WeatherTracker.Name = tostring(raw.name)
				WeatherTracker.Duration = tonumber(raw.duration) or 300
				WeatherTracker.StartedAt = tonumber(raw.startedAt) or sTime
				WeatherTracker.Remaining = rem
				WeatherTracker.BuffDescription = getWeatherBuffText(raw.name)

				if isNew then
					WeatherTracker.LastNotifiedName = raw.name
					if logger then
						logger.Log(
							string.format("[Weather Event]: %s started! (%s remaining)", raw.name, formatWeatherTime(rem)),
							UI.Colors.accentCyan)
					end
					UI.Notify("Weather Alert",
						string.format("%s is active! (%s)", raw.name, WeatherTracker.BuffDescription),
						UI.Colors.accentCyan, 5)
					notifyWeatherStarted(raw.name, WeatherTracker.Duration, WeatherTracker.BuffDescription)

					if cfg.autoUseLuckPotionOnWeather ~= false and tostring(raw.name):lower():find("luck") then
						task.delay(0.5, function()
							if useAllLuckPotions then pcall(useAllLuckPotions) end
						end)
					end
				end
				return
			end
		end

		
		if WeatherTracker.Active then
			if logger then
				logger.Log("[Weather Event]: Weather ended. Returned to normal.", UI.Colors.textMuted)
			end
			UI.Notify("Weather Ended", "Active weather event has expired.", UI.Colors.textSecondary, 3)
		end
		WeatherTracker.Active = false
		WeatherTracker.Name = "None"
		WeatherTracker.Duration = 0
		WeatherTracker.StartedAt = 0
		WeatherTracker.Remaining = 0
		WeatherTracker.BuffDescription = "Normal conditions"
		WeatherTracker.LastNotifiedName = nil
	end

	
	pcall(function()
		local ClientRPMod = ReplicatedStorage:WaitForChild("Packages", 10):WaitForChild("Network", 10):WaitForChild(
			"Client", 10):WaitForChild("ClientRemoteProperty", 10)
		local ClientRP = require(ClientRPMod)
		local activeWeatherRemote = ReplicatedStorage:WaitForChild("Network", 10):WaitForChild("WeatherService", 10)
			:WaitForChild("RP", 10):WaitForChild("ActiveWeather", 10)
		local weatherProp = ClientRP.new(activeWeatherRemote)

		weatherProp:Observe(function(val)
			pcall(updateWeatherState, val)
		end)
	end)

	
	
	
	local isHoppingServer = false
	local hopperStatusText = "Idle"
	local visitedServers = {}

	local VISITED_FILE = "HipHub/AnimeDice/visited_servers.json"
	pcall(function()
		if isfile and readfile and isfile(VISITED_FILE) then
			local decoded = HttpService:JSONDecode(readfile(VISITED_FILE))
			if type(decoded) == "table" then
				visitedServers = decoded
			end
		end
	end)

	local function saveVisitedServers()
		pcall(function()
			if writefile then
				local keys = {}
				for k in pairs(visitedServers) do table.insert(keys, k) end
				if #keys > 150 then
					for i = 1, #keys - 80 do
						visitedServers[keys[i]] = nil
					end
				end
				writefile(VISITED_FILE, HttpService:JSONEncode(visitedServers))
			end
		end)
	end

	if game.JobId and game.JobId ~= "" then
		visitedServers[tostring(game.JobId)] = os.time()
		saveVisitedServers()
	end

	local function fetchPublicServers(placeId)
		local servers = {}
		local cursor = ""
		local maxPages = 4

		for page = 1, maxPages do
			local url = string.format(
				"https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true",
				tostring(placeId))
			if cursor ~= "" then
				url = url .. "&cursor=" .. tostring(cursor)
			end

			local ok, body = pcall(function()
				if game.HttpGet then
					return game:HttpGet(url)
				end
				local req = request or http_request or (syn and syn.request) or (http and http.request)
				if req then
					local res = req({ Url = url, Method = "GET" })
					return res and res.Body
				end
			end)

			if not ok or not body or body == "" then break end

			local okJson, data = pcall(function()
				return HttpService:JSONDecode(body)
			end)

			if not okJson or not data or not data.data or type(data.data) ~= "table" then break end

			for _, s in ipairs(data.data) do
				local playing = tonumber(s.playing) or 0
				local maxPlayers = tonumber(s.maxPlayers) or 10
				local fps = tonumber(s.fps) or 60
				local ping = tonumber(s.ping) or 0

				
				if s.id and s.id ~= game.JobId and playing >= 1 and playing < maxPlayers then
					local exists = false
					for _, ex in ipairs(servers) do
						if ex.id == tostring(s.id) then
							exists = true; break
						end
					end
					if not exists then
						table.insert(servers, {
							id = tostring(s.id),
							playing = playing,
							maxPlayers = maxPlayers,
							fps = fps,
							ping = ping
						})
					end
				end
			end

			if not data.nextPageCursor or data.nextPageCursor == "" or data.nextPageCursor == "null" then
				break
			end
			cursor = tostring(data.nextPageCursor)
			task.wait(0.04)
		end

		return servers
	end

	local function hopToNextServer(reason)
		if isHoppingServer then return end
		isHoppingServer = true
		hopperStatusText = "Scanning public servers..."
		if logger then
			logger.Log("[Weather Hopper]: " .. (reason or "Scanning for target weather server..."),
				UI.Colors.accentCyan)
		end
		UI.Notify("Weather Hopper", reason or "Searching for next server...", UI.Colors.accentCyan, 4)

		task.spawn(function()
			local placeId = game.PlaceId
			local servers = fetchPublicServers(placeId)

			
			local now = os.time()
			local unvisited = {}
			for _, s in ipairs(servers) do
				local visitedAt = visitedServers[s.id]
				if not visitedAt or (now - visitedAt) > 480 then
					table.insert(unvisited, s)
				end
			end

			
			if #unvisited == 0 and #servers > 0 then
				table.clear(visitedServers)
				if game.JobId and game.JobId ~= "" then
					visitedServers[tostring(game.JobId)] = os.time()
				end
				saveVisitedServers()
				for _, s in ipairs(servers) do
					if s.id ~= game.JobId then
						table.insert(unvisited, s)
					end
				end
			end

			local pool = #unvisited > 0 and unvisited or servers
			if #pool == 0 then
				hopperStatusText = "No server list found via API. Teleporting via Roblox matchmaker..."
				if logger then
					logger.Log(
						"[Weather Hopper]: Public API returned 0 servers, falling back to matchmaker...",
						UI.Colors.warningYellow)
				end
				task.wait(1.5)
				pcall(function()
					local queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or
						(fluxus and fluxus.queue_on_teleport)
					if queue_on_teleport then
						pcall(function()
							queue_on_teleport(game:HttpGet("https://hiphub.vercel.app/api/script-roblox/da/main.lua"))
						end)
					end
					TeleportService:Teleport(placeId, player)
				end)
				task.wait(5)
				isHoppingServer = false
				return
			end

			local mode = cfg.weatherHopMode or "Fewest Players"
			local targetServer = nil

			
			local healthy = {}
			for _, s in ipairs(pool) do
				if s.playing >= 2 and s.playing < (s.maxPlayers - 1) then
					table.insert(healthy, s)
				end
			end
			local activePool = #healthy >= 2 and healthy or pool

			if mode == "Fewest Players" then
				table.sort(activePool, function(a, b) return a.playing < b.playing end)
				local topCount = math.min(4, #activePool)
				targetServer = activePool[math.random(1, topCount)]
			elseif mode == "Lowest Ping" then
				table.sort(activePool, function(a, b)
					local pa = (a.ping > 0) and a.ping or 100
					local pb = (b.ping > 0) and b.ping or 100
					return pa < pb
				end)
				local topCount = math.min(4, #activePool)
				targetServer = activePool[math.random(1, topCount)]
			else
				targetServer = activePool[math.random(1, #activePool)]
			end

			if targetServer and targetServer.id then
				hopperStatusText = string.format("Teleporting to server (%d/%d players)...", targetServer.playing,
					targetServer.maxPlayers)
				if logger then
					logger.Log(
						string.format("[Weather Hopper]: Teleporting to %s (%d players)",
							string.sub(targetServer.id, 1, 10),
							targetServer.playing), UI.Colors.successGreen)
				end
				visitedServers[targetServer.id] = os.time()
				saveVisitedServers()

				pcall(function()
					local queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or
						(fluxus and fluxus.queue_on_teleport)
					if queue_on_teleport then
						pcall(function()
							queue_on_teleport(game:HttpGet("https://hiphub.vercel.app/api/script-roblox/da/main.lua"))
						end)
					end
				end)

				TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
			else
				isHoppingServer = false
				hopperStatusText = "Failed to select target server."
			end
		end)
	end

	
	pcall(function()
		local GuiService = game:GetService("GuiService")
		local CoreGui = game:GetService("CoreGui")

		local function handleTeleportError(errorMsg)
			if isHoppingServer then
				isHoppingServer = false
				hopperStatusText = "Teleport error: " .. tostring(errorMsg or "Failed") .. ". Retrying..."
			end
			if logger then
				logger.Log(
					"[Weather Hopper]: Connection error detected (" ..
					tostring(errorMsg or "279") .. "). Auto-reconnecting...", UI.Colors.dangerRed)
			end

			
			pcall(function()
				if GuiService.ClearError then
					GuiService:ClearError()
				end
			end)

			
			pcall(function()
				local robloxPromptGui = CoreGui:FindFirstChild("RobloxPromptGui")
				if robloxPromptGui then
					local promptOverlay = robloxPromptGui:FindFirstChild("promptOverlay")
					if promptOverlay then
						for _, btn in ipairs(promptOverlay:GetDescendants()) do
							if btn:IsA("TextButton") and (btn.Name:lower():find("retry") or btn.Text:lower():find("retry") or btn.Text:lower():find("cancel")) then
								pcall(function()
									if firesignal then firesignal(btn.MouseButton1Click) end
								end)
							end
						end
					end
				end
			end)

			task.wait(1.5)
			
			pcall(function()
				local queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or
					(fluxus and fluxus.queue_on_teleport)
				if queue_on_teleport then
					pcall(function()
						queue_on_teleport(game:HttpGet("https://hiphub.vercel.app/api/script-roblox/da/main.lua"))
					end)
				end
				TeleportService:Teleport(game.PlaceId, player)
			end)
		end

		TeleportService.TeleportInitFailed:Connect(function(pl, teleportResult, errorMsg)
			handleTeleportError("TeleportInitFailed: " .. tostring(errorMsg or teleportResult))
		end)

		GuiService.ErrorMessageChanged:Connect(function(newErrorMessage)
			if newErrorMessage and newErrorMessage ~= "" then
				local errLower = tostring(newErrorMessage):lower()
				if errLower:find("279") or errLower:find("failed to connect") or errLower:find("no response") or errLower:find("277") or errLower:find("260") or errLower:find("524") or errLower:find("773") then
					handleTeleportError("Error: " .. tostring(newErrorMessage))
				end
			end
		end)
	end)

	local ALL_WEATHER_TARGETS = {
		"Luck Event (2.5x Luck)",
		"Roll Speed Event (2x Roll)",
		"Cash Event (2.5x Money)",
		"Trait Event (2x Trait Luck)",
		"Grade Event (2x Grade Luck)",
		"Haunted Night (2x Candy/Pumpkin Luck)",
		"Any Weather"
	}

	local function checkWeatherMatch(targetChoice, activeWeatherName)
		if not activeWeatherName or activeWeatherName == "" or activeWeatherName == "None" then
			return false
		end
		if type(targetChoice) == "table" then
			for optName, isSelected in pairs(targetChoice) do
				if isSelected == true and checkWeatherMatch(optName, activeWeatherName) then
					return true
				end
			end
			return false
		end
		local targetStr = tostring(targetChoice or "")
		if string.find(targetStr, "Any") then
			return true
		end
		local actLower = string.lower(activeWeatherName)
		local tgtLower = string.lower(targetStr)

		if tgtLower:find("haunted") or actLower:find("haunted") then
			return tgtLower:find("haunted") ~= nil and actLower:find("haunted") ~= nil
		end

		if tgtLower:find("trait") and actLower:find("trait") then
			return true
		end
		if tgtLower:find("grade") and actLower:find("grade") then
			return true
		end
		if tgtLower:find("cash") or tgtLower:find("money") then
			if actLower:find("cash") or actLower:find("money") then
				return true
			end
		end
		if tgtLower:find("speed") or tgtLower:find("roll") or tgtLower:find("dice") then
			if actLower:find("speed") or actLower:find("roll") or actLower:find("dice") then
				return true
			end
		end
		if tgtLower:find("luck") and not tgtLower:find("trait") and not tgtLower:find("grade") then
			if actLower:find("luck") and not actLower:find("trait") and not actLower:find("grade") then
				return true
			end
		end
		return false
	end

	local autoRollToggle = nil
	local weatherWindow = nil

	local function useAllLuckPotions()
		if not useBoostRE or not DataController or not DataController.Inventory then return end
		pcall(function()
			local inv = extractInventory(DataController.Inventory)
			local active = (DataController.ActiveEntries and DataController.ActiveEntries()) or {}
			local serverTime = workspace:GetServerTimeNow()

			for _, potionName in ipairs(ALL_LUCK_POTIONS) do
				local itemData = inv[potionName]
				local count = itemData and (itemData.amount or 1) or 0
				if count > 0 then
					local shouldUse = true
					local act = active[potionName]
					if act then
						if typeof(act) == "number" and act > 1 then
							shouldUse = false
						elseif typeof(act) == "table" then
							if typeof(act.remaining) == "number" then
								if act.startedAt and typeof(act.startedAt) == "number" then
									local timeLeft = act.remaining - (serverTime - act.startedAt)
									if timeLeft > 1 then
										shouldUse = false
									end
								elseif act.remaining > 1 then
									shouldUse = false
								end
							end
						end
					end

					if shouldUse then
						useBoostRE:FireServer(potionName)
						if logger then
							logger.Log(
								string.format("[Weather Luck Boost]: Auto Used %s (Left: %d)", potionName,
									math.max(0, count - 1)), UI.Colors.successGreen)
						end
						task.wait(0.12)
					end
				end
			end
		end)
	end

	
	task.spawn(function()
		task.wait(3)
		while task.wait(2.5) do
			pcall(function()
				if cfg.autoUseLuckPotionOnWeather ~= false and WeatherTracker.Active then
					local wName = tostring(WeatherTracker.Name):lower()
					if wName:find("luck") then
						useAllLuckPotions()
					end
				end
			end)
		end
	end)

	
	task.spawn(function()
		task.wait(4)
		local wasAutoRollingForWeather = false

		while task.wait(2) do
			pcall(function()
				if not cfg.autoWeatherHop then
					if wasAutoRollingForWeather then
						wasAutoRollingForWeather = false
					end
					return
				end

				if isHoppingServer then return end

				local hasMatch = checkWeatherMatch(cfg.weatherHopTarget or "Luck Event", WeatherTracker.Name)
				local remainingTime = tonumber(WeatherTracker.Remaining) or 0

				if hasMatch and remainingTime > 5 then
					
					hopperStatusText = string.format("Farming %s (%ds left) - Auto Rolling...", WeatherTracker.Name,
						remainingTime)

					
					if cfg.autoUseLuckPotionOnWeather ~= false and string.find(string.lower(tostring(WeatherTracker.Name)), "luck") then
						useAllLuckPotions()
					end

					
					if cfg.autoRollOnWeather ~= false then
						if not cfg.autoRoll then
							cfg.autoRoll = true
							wasAutoRollingForWeather = true
							if autoRollToggle and autoRollToggle.Set then
								autoRollToggle.Set(true)
							end
							if logger then
								logger.Log(
									string.format(
										"[Weather Hopper]: Target '%s' active! Auto-rolling until weather expires...",
										WeatherTracker.Name), UI.Colors.successGreen)
							end
							UI.Notify("Weather Hopper",
								string.format("Target active: %s! Auto-rolling...", WeatherTracker.Name),
								UI.Colors.successGreen, 3)
						end
					end
				else
					
					if wasAutoRollingForWeather or (cfg.autoRollOnWeather ~= false and cfg.autoRoll) then
						cfg.autoRoll = false
						wasAutoRollingForWeather = false
						if autoRollToggle and autoRollToggle.Set then
							autoRollToggle.Set(false)
						end
						if logger then
							logger.Log(
								"[Weather Hopper]: Weather expired / inactive. Pausing Auto Roll and searching next server...",
								UI.Colors.warningYellow)
						end
					end

					if cfg.autoHopOnExpire ~= false or not hasMatch then
						hopToNextServer(string.format("Searching server with %s...",
							cfg.weatherHopTarget or "Target Weather"))
					else
						hopperStatusText = "Idle in server (Waiting for next weather event)"
					end
				end
			end)
		end
	end)

	
	
	
	local dbTab = UI.Tabs.Main or UI.Tabs.Dashboard
	local statSec = UI.CreateSection(dbTab, "Player Live Stats", 1, true)

	local statBoxes = {
		money = UI.CreateStatBox(statSec, "Balance", "$0", 1),
		rebirth = UI.CreateStatBox(statSec, "Rebirth Count", "0", 2),
		dice = UI.CreateStatBox(statSec, "Equipped Dice", "Basic", 3),
		rolls = UI.CreateStatBox(statSec, "Session Rolls", "0", 4),
		units = UI.CreateStatBox(statSec, "Inventory Units", "0", 5),
		luck = UI.CreateStatBox(statSec, "Luck Multiplier", "1x", 6),
	}

	local mainTargetWeatherDropdown = nil
	local mainAutoHopToggle = nil
	local mainAutoRollWeatherToggle = nil
	local mainAutoLuckPotionToggle = nil
	local mainAutoHopExpireToggle = nil
	local mainHopStrategyDropdown = nil

	pcall(function()
		if UI.CreateWeatherHopperWindow then
			weatherWindow = UI.CreateWeatherHopperWindow({
				OnAutoHopToggle = function(v)
					cfg.autoWeatherHop = v
					if Settings and Settings.Save then Settings.Save() end
					if v then
						logger.Log("Auto Weather Server Hopper enabled.", UI.Colors.successGreen)
					else
						logger.Log("Auto Weather Server Hopper disabled.", UI.Colors.textMuted)
					end
					if mainAutoHopToggle and mainAutoHopToggle.Set then
						mainAutoHopToggle.Set(v)
					end
				end,
				OnAutoRollWeatherToggle = function(v)
					cfg.autoRollOnWeather = v
					if Settings and Settings.Save then Settings.Save() end
					if v then
						logger.Log("Auto Roll during Target Weather enabled.", UI.Colors.successGreen)
					else
						logger.Log("Auto Roll during Target Weather disabled.", UI.Colors.textMuted)
					end
					if mainAutoRollWeatherToggle and mainAutoRollWeatherToggle.Set then
						mainAutoRollWeatherToggle.Set(v)
					end
				end,
				OnAutoUseLuckPotionToggle = function(v)
					cfg.autoUseLuckPotionOnWeather = v
					if Settings and Settings.Save then Settings.Save() end
					if v then
						logger.Log("Auto Use Luck Potions on Luck Weather enabled.", UI.Colors.successGreen)
					else
						logger.Log("Auto Use Luck Potions on Luck Weather disabled.", UI.Colors.textMuted)
					end
					if mainAutoLuckPotionToggle and mainAutoLuckPotionToggle.Set then
						mainAutoLuckPotionToggle.Set(v)
					end
				end,
				OnExpireToggle = function(v)
					cfg.autoHopOnExpire = v
					if Settings and Settings.Save then Settings.Save() end
					if mainAutoHopExpireToggle and mainAutoHopExpireToggle.Set then
						mainAutoHopExpireToggle.Set(v)
					end
				end,
				OnTargetChange = function(v)
					cfg.weatherHopTarget = v
					if Settings and Settings.Save then Settings.Save() end
					logger.Log("Weather Hop Target set to: " .. tostring(v), UI.Colors.accentCyan)
					if mainTargetWeatherDropdown and mainTargetWeatherDropdown.Set then
						mainTargetWeatherDropdown.Set(v)
					end
				end,
				OnStrategyChange = function(v)
					cfg.weatherHopMode = v
					if Settings and Settings.Save then Settings.Save() end
					if mainHopStrategyDropdown and mainHopStrategyDropdown.Set then
						mainHopStrategyDropdown.Set(v)
					end
				end,
				OnManualHop = function()
					hopToNextServer("Manual server hop initiated by user.")
				end
			})
			if weatherWindow then
				if weatherWindow.SetAutoHop then weatherWindow.SetAutoHop(cfg.autoWeatherHop) end
				if weatherWindow.SetAutoRollWeather then weatherWindow.SetAutoRollWeather(cfg.autoRollOnWeather ~= false) end
				if weatherWindow.SetAutoUseLuckPotion then
					weatherWindow.SetAutoUseLuckPotion(cfg
						.autoUseLuckPotionOnWeather ~= false)
				end
				if weatherWindow.SetTarget then weatherWindow.SetTarget(cfg.weatherHopTarget or "Luck Event (2.5x Luck)") end
				if weatherWindow.SetStrategy then weatherWindow.SetStrategy(cfg.weatherHopMode or "Fewest Players") end
				if weatherWindow.SetAutoHopExpire then weatherWindow.SetAutoHopExpire(cfg.autoHopOnExpire) end
			end
		end
	end)

	local weatherSec = UI.CreateSection(dbTab, "Live Weather Tracker & Server Hopper", 2, true)
	weatherBoxes = {
		name = UI.CreateStatBox(weatherSec, "Current Weather", "None (Normal)", 1),
		time = UI.CreateStatBox(weatherSec, "Time Remaining", "Inactive", 2),
		buff = UI.CreateStatBox(weatherSec, "Active Buff", "Normal Rates", 3),
	}

	local currentTargetWeather = cfg.weatherHopTarget or "Luck Event (2.5x Luck)"
	if not table.find(ALL_WEATHER_TARGETS, currentTargetWeather) then
		for _, opt in ipairs(ALL_WEATHER_TARGETS) do
			if string.find(string.lower(opt), string.lower(currentTargetWeather)) then
				currentTargetWeather = opt
				break
			end
		end
	end

	mainTargetWeatherDropdown = Settings.CreateControl("weatherHopTarget", "CreateDropdown", weatherSec, "Target Weather", ALL_WEATHER_TARGETS,
		currentTargetWeather, function(v)
			cfg.weatherHopTarget = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Weather Hop Target set to: " .. tostring(v), UI.Colors.accentCyan)
			if weatherWindow and weatherWindow.SetTarget then
				weatherWindow.SetTarget(v)
			end
		end, 4)

	mainAutoHopToggle = Settings.CreateControl("autoWeatherHop", "CreateToggle", weatherSec, "Auto Hop For Target Weather", cfg.autoWeatherHop, function(v)
		cfg.autoWeatherHop = v
		if Settings and Settings.Save then Settings.Save() end
		if v then
			logger.Log("Auto Weather Server Hopper enabled.", UI.Colors.successGreen)
		else
			logger.Log("Auto Weather Server Hopper disabled.", UI.Colors.textMuted)
		end
		if weatherWindow and weatherWindow.SetAutoHop then
			weatherWindow.SetAutoHop(v)
		end
	end, 5)

	mainAutoRollWeatherToggle = Settings.CreateControl("autoRollOnWeather", "CreateToggle", weatherSec, "Auto Roll While Weather Active", cfg.autoRollOnWeather,
		function(v)
			cfg.autoRollOnWeather = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Roll during Target Weather enabled.", UI.Colors.successGreen)
			else
				logger.Log("Auto Roll during Target Weather disabled.", UI.Colors.textMuted)
			end
			if weatherWindow and weatherWindow.SetAutoRollWeather then
				weatherWindow.SetAutoRollWeather(v)
			end
		end, 6)

	mainAutoLuckPotionToggle = Settings.CreateControl("autoUseLuckPotionOnWeather", "CreateToggle", weatherSec, "Auto Use Luck Potions on Luck Weather",
		cfg.autoUseLuckPotionOnWeather, function(v)
			cfg.autoUseLuckPotionOnWeather = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Use Luck Potions on Luck Weather enabled.", UI.Colors.successGreen)
			else
				logger.Log("Auto Use Luck Potions on Luck Weather disabled.", UI.Colors.textMuted)
			end
			if weatherWindow and weatherWindow.SetAutoUseLuckPotion then
				weatherWindow.SetAutoUseLuckPotion(v)
			end
		end, 7)

	mainAutoHopExpireToggle = Settings.CreateControl("autoHopOnExpire", "CreateToggle", weatherSec, "Hop When Weather Expires", cfg.autoHopOnExpire, function(v)
		cfg.autoHopOnExpire = v
		if Settings and Settings.Save then Settings.Save() end
		if weatherWindow and weatherWindow.SetAutoHopExpire then
			weatherWindow.SetAutoHopExpire(v)
		end
	end, 8)

	mainHopStrategyDropdown = Settings.CreateControl("weatherHopMode", "CreateDropdown", weatherSec, "Hop Strategy",
		{ "Fewest Players", "Random Server", "Lowest Ping" }, cfg.weatherHopMode or "Fewest Players", function(v)
			cfg.weatherHopMode = v
			if Settings and Settings.Save then Settings.Save() end
			if weatherWindow and weatherWindow.SetStrategy then
				weatherWindow.SetStrategy(v)
			end
		end, 9)

	UI.CreateButton(weatherSec, "Manual Server Hop Now", function()
		hopToNextServer("Manual server hop initiated by user.")
	end, 10)

	UI.CreateButton(weatherSec, "Open Dedicated Weather Window", function()
		if weatherWindow then
			weatherWindow.Toggle()
		end
	end, 11)

	local logSec = UI.CreateSection(dbTab, "Automation Activity Log", 5, true)
	local logger = UI.CreateLogConsole(logSec, 1, 130)
	logger.Log("HipHub Anime Dice initialized and running.", UI.Colors.accentCyan)

	local function processItemReward(itemName, amount, source)
		amount = tonumber(amount) or 1
		if amount <= 0 then return end

		if itemName == "Gems" then
			local cur = getGemsCount()
			local total = math.max(cur, (lastGemsCount or 0) + amount)
			lastGemsCount = total
			logger.Log(string.format("Gems Drop: +%s (Total: %s)", formatNumber(amount), formatNumber(total)),
				UI.Colors.accentCyan)
			notifyGemsReceived(amount, total, source)
		elseif itemName == "Trait Reroll" or itemName == "Trait Potion" or itemName == "Trait Pot" then
			local cur = getTraitPotCount()
			local total = math.max(cur, (lastTraitPotCount or 0) + amount)
			lastTraitPotCount = total
			logger.Log(string.format("Trait Potion Drop: +%d (Total: %d)", amount, total), UI.Colors.accentViolet)
			notifyTraitPotReceived(amount, total, source)
		end
	end

	if dropNotificationRE then
		dropNotificationRE.OnClientEvent:Connect(function(entryName, amount)
			if not entryName then return end
			local sourceDesc = inTowerActive and ("Tower: " .. tostring(currentActiveTowerName or "Battle")) or
				"Drop Notification"
			processItemReward(entryName, amount, sourceDesc)
		end)
	end

	local totalSessionRolls = 0

	task.spawn(function()
		lastGemsCount = getGemsCount()
		lastTraitPotCount = getTraitPotCount()
		while task.wait(0.5) do
			pcall(function()
				if DataController then
					if DataController.Money then
						statBoxes.money.Set("$" .. formatNumber(DataController.Money()))
					end
					if DataController.Rebirth then
						statBoxes.rebirth.Set(tostring(DataController.Rebirth()))
					end
					if DataController.Dice then
						statBoxes.dice.Set(tostring(DataController.Dice()))
					end
					if DataController.Inventory then
						local unitCount, maxCap = getUnitCountAndCapacity()
						if maxCap and maxCap > 0 then
							statBoxes.units.Set(string.format("%d/%d", unitCount, maxCap))
						else
							statBoxes.units.Set(tostring(unitCount))
						end

						
						local curGems = getGemsCount()
						if lastGemsCount ~= nil and curGems > lastGemsCount then
							local delta = curGems - lastGemsCount
							lastGemsCount = curGems
							logger.Log(
								string.format("Gained +%s Gems! (Total: %s)", formatNumber(delta), formatNumber(curGems)),
								UI.Colors.accentCyan)
							notifyGemsReceived(delta, curGems,
								inTowerActive and ("Tower: " .. tostring(currentActiveTowerName or "Battle")) or
								"Inventory Update")
						else
							lastGemsCount = curGems
						end

						
						local curPot = getTraitPotCount()
						if lastTraitPotCount ~= nil and curPot > lastTraitPotCount then
							local delta = curPot - lastTraitPotCount
							lastTraitPotCount = curPot
							logger.Log(string.format("Gained +%d Trait Potion(s)! (Total: %d)", delta, curPot),
								UI.Colors.accentViolet)
							notifyTraitPotReceived(delta, curPot,
								inTowerActive and ("Tower: " .. tostring(currentActiveTowerName or "Battle")) or
								"Inventory Update")
						else
							lastTraitPotCount = curPot
						end
					end
				end
			end)
		end
	end)

	
	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				if WeatherTracker.Active and WeatherTracker.StartedAt > 0 and WeatherTracker.Duration > 0 then
					local sTime = workspace:GetServerTimeNow()
					local elapsed = math.max(0, sTime - WeatherTracker.StartedAt)
					local rem = math.max(0, math.floor(WeatherTracker.Duration - elapsed))
					WeatherTracker.Remaining = rem
					if rem <= 0 then
						updateWeatherState(nil)
					end
				end

				if weatherBoxes then
					if WeatherTracker.Active and WeatherTracker.Remaining > 0 then
						weatherBoxes.name.Set(WeatherTracker.Name)
						weatherBoxes.time.Set(formatWeatherTime(WeatherTracker.Remaining))
						weatherBoxes.buff.Set(WeatherTracker.BuffDescription)
					else
						weatherBoxes.name.Set("None (Normal)")
						weatherBoxes.time.Set("Inactive")
						weatherBoxes.buff.Set("Normal Rates")
					end
				end

				if weatherWindow and weatherWindow.Update then
					weatherWindow.Update({
						Active = WeatherTracker.Active,
						Name = WeatherTracker.Name,
						Remaining = WeatherTracker.Remaining,
						FormattedTime = formatWeatherTime(WeatherTracker.Remaining),
						HopperStatusText = hopperStatusText
					})
				end
			end)
		end
	end)

	
	do
		local rollTab = UI.Tabs.Main or UI.Tabs.Roll
		local rollSec = UI.CreateSection(rollTab, "Auto Roll Controls", 3, true)

		autoRollToggle = Settings.CreateControl("autoRoll", "CreateToggle", rollSec, "Auto Roll", cfg.autoRoll, function(v)
			cfg.autoRoll = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Roll activated.", UI.Colors.successGreen)
			else
				logger.Log("Auto Roll paused.", UI.Colors.textMuted)
			end
		end, 1)

		Settings.CreateControl("instantRoll", "CreateToggle", rollSec, "Instant Roll (Skip Cutscene)", cfg.instantRoll, function(v)
			cfg.instantRoll = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Instant Roll set to: " .. tostring(v), UI.Colors.textSecondary)
		end, 2)

		Settings.CreateControl("rollDelay", "CreateSlider", rollSec, "Roll Interval", 0.01, 1.0, cfg.rollDelay, function(v)
			cfg.rollDelay = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3, "s")

		Settings.CreateControl("autoStopOnRare", "CreateToggle", rollSec, "Stop on Rare Pull", cfg.autoStopOnRare, function(v)
			cfg.autoStopOnRare = v
			if Settings and Settings.Save then Settings.Save() end
		end, 4)

		Settings.CreateControl("stopOnRarity", "CreateDropdown", rollSec, "Minimum Rare Tier", ALL_RARITIES, cfg.stopOnRarity, function(v)
			cfg.stopOnRarity = v
			if Settings and Settings.Save then Settings.Save() end
		end, 5)

		task.spawn(function()
			while true do
				if cfg.autoRoll then
					local rollSuccess, rollResult = pcall(function()
						return rollRF:InvokeServer()
					end)

					if rollSuccess and rollResult and type(rollResult) == "table" then
						for _, entry in ipairs(rollResult) do
							totalSessionRolls = totalSessionRolls + 1
							statBoxes.rolls.Set(tostring(totalSessionRolls))

							local unitName = entry.result or "Unknown"
							local mutationName = entry.mutation

							logger.Log(
								string.format("Rolled: %s%s", unitName,
									mutationName and (" (" .. mutationName .. ")") or ""),
								UI.Colors.accentCyan)

							local unitRarity = "Common"
							if Rarities and unitName ~= "Unknown" then
								pcall(function()
									local configModule = require(Features.Inventory.EntryRegistry).getEntryConfig(
										unitName)
									if configModule and configModule.getRarity then
										unitRarity = configModule.getRarity({ mutation = mutationName })
									end
								end)
							end

							local unitChance = getUnitChance(unitName, { mutation = mutationName })
							local unitChanceFormatted = "1 in " .. formatNumber(unitChance)

							local rank = RARITY_RANK[unitRarity] or 1
							local targetRank = RARITY_RANK[cfg.stopOnRarity] or 7

							if rank >= targetRank then
								logger.Log(
									string.format("Pulled Rare Unit: %s [%s] (%s)!", unitName, unitRarity,
										unitChanceFormatted),
									UI.Colors.successGreen)
								if cfg.autoStopOnRare then
									cfg.autoRoll = false
									autoRollToggle.Set(false)
									if Settings and Settings.Save then Settings.Save() end
									logger.Log("Auto Roll stopped due to rare pull threshold.", UI.Colors.accentViolet)
								end
							end

							if cfg.webhookNotifyRare then
								local shouldSendWebhook = true
								local hookMode = cfg.webhookUnitPullMode or "Above (>=)"
								local hookThresholdVal = parseChance(cfg.webhookUnitPullThreshold or "1 in 10t")

								if hookMode == "Above (>=)" then
									if unitChance < hookThresholdVal then
										shouldSendWebhook = false
									end
								elseif hookMode == "Below (<=)" then
									if unitChance > hookThresholdVal then
										shouldSendWebhook = false
									end
								elseif hookMode == "All Pulls" then
									shouldSendWebhook = true
								end

								if shouldSendWebhook then
									sendWebhook(
										"Unit Pulled!",
										string.format("Player **%s** rolled **%s** (%s)!", player.Name, unitName,
											unitChanceFormatted),
										{
											{ name = "Unit",        value = unitName,                    inline = true },
											{ name = "Rarity",      value = unitRarity,                  inline = true },
											{ name = "Chance",      value = unitChanceFormatted,         inline = true },
											{ name = "Mutation",    value = mutationName or "None",      inline = true },
											{ name = "Total Rolls", value = tostring(totalSessionRolls), inline = true }
										},
										65280
									)
								end
							end
						end
					end
					task.wait(cfg.rollDelay or 0.05)
				else
					task.wait(0.2)
				end
			end
		end)
	end

	
	do
		local plotTab = UI.Tabs.Main or UI.Tabs.Plot
		local plotSec = UI.CreateSection(plotTab, "Plot Automation", 4, true)

		local function upgradeAffordableSlots()
			local upgradedCount = 0
			local maxPasses = 100
			local pass = 0
			local maxLvl = tonumber(cfg.maxSlotLevel) or 0

			while pass < maxPasses do
				pass = pass + 1
				local anyInPass = false
				local currentMoney = 0
				if DataController and DataController.Money then
					local ok, val = pcall(DataController.Money)
					if ok and typeof(val) == "number" then currentMoney = val end
				end

				for slot = 1, getMaxPlotSlots() do
					local isUnlocked = true
					if PlotConfig and PlotConfig.GetSlotRebirthRequirement and DataController and DataController.Rebirth then
						local ok, req = pcall(PlotConfig.GetSlotRebirthRequirement, slot)
						local ok2, reb = pcall(DataController.Rebirth)
						if ok and ok2 and typeof(req) == "number" and typeof(reb) == "number" then
							isUnlocked = reb >= req
						end
					end

					if isUnlocked and DataController and DataController.Slots and DataController.Inventory then
						local slotGetter = DataController.Slots[tostring(slot)]
						local slotData = slotGetter and slotGetter()
						if slotData and slotData.unitId then
							local unitGetter = DataController.Inventory[slotData.unitId]
							local unitData = unitGetter and unitGetter()
							if unitData then
								local curLevel = tonumber(unitData.attributes and unitData.attributes.level or 1) or 1
								if maxLvl <= 0 or curLevel < maxLvl then
									local price = nil
									if UnitUtil and UnitUtil.GetLevelPrice then
										local ok, pVal = pcall(UnitUtil.GetLevelPrice, unitData.name, unitData
											.attributes)
										if ok and typeof(pVal) == "number" then price = pVal end
									end

									if price and currentMoney >= price then
										levelUpSlotRE:FireServer(slot)
										anyInPass = true
										upgradedCount = upgradedCount + 1
										currentMoney = currentMoney - price
										task.wait(0.02)
										if DataController.Money then
											local okM, newM = pcall(DataController.Money)
											if okM and typeof(newM) == "number" then currentMoney = newM end
										end
									end
								end
							end
						end
					end
				end

				if not anyInPass then
					break
				end
				task.wait(0.03)
			end
			return upgradedCount
		end

		local isAutoLevel50Running = false
		local function runAutoLevel50Pipeline(isManual)
			if isAutoLevel50Running then
				logger.Log("Auto Level 50 pipeline is already active.", UI.Colors.warningYellow)
				return
			end
			isAutoLevel50Running = true

			local targetLvl = tonumber(cfg.backpackTargetLevel) or 50
			local speed = tonumber(cfg.backpackUpgradeSpeed) or 0.04
			if speed < 0.01 then speed = 0.01 end

			local unlockedSlots = getUnlockedPlotSlots()
			if #unlockedSlots == 0 then
				logger.Log("No unlocked plot slots available for auto level pipeline.", UI.Colors.warningYellow)
				isAutoLevel50Running = false
				return
			end

			logger.Log(string.format("Starting Remote Auto Level %d Backpack Pipeline...", targetLvl),
				UI.Colors.accentCyan)

			
			for _, slotNum in ipairs(unlockedSlots) do
				if not scriptRunning or (not isManual and not cfg.autoLevel50Backpack) then break end

				local slotData = nil
				if DataController and DataController.Slots then
					local ok, getter = pcall(function() return DataController.Slots[tostring(slotNum)] end)
					if ok and getter then
						slotData = (typeof(getter) == "function" and getter()) or getter
					end
				end

				if slotData and slotData.unitId then
					local unitKey = tostring(slotData.unitId)
					local liveUnit = getLiveUnitData(unitKey)
					local lvl = tonumber(liveUnit and liveUnit.attributes and liveUnit.attributes.level or 1) or 1

					while scriptRunning and lvl < targetLvl and (isManual or cfg.autoLevel50Backpack) do
						local currentMoney = 0
						if DataController and DataController.Money then
							local okM, m = pcall(DataController.Money)
							if okM and typeof(m) == "number" then currentMoney = m end
						end

						local price = 0
						if UnitUtil and UnitUtil.GetLevelPrice and liveUnit then
							local okP, p = pcall(UnitUtil.GetLevelPrice, liveUnit.name, liveUnit.attributes or {})
							if okP and typeof(p) == "number" then price = p end
						end

						if price > 0 and currentMoney < price then
							if collectBalanceRE then
								pcall(function() collectBalanceRE:FireServer(slotNum) end)
							end
							task.wait(0.15)
							if DataController and DataController.Money then
								local okM2, m2 = pcall(DataController.Money)
								if okM2 and typeof(m2) == "number" then currentMoney = m2 end
							end
							if currentMoney < price then
								break
							end
						end

						if levelUpSlotRE then
							levelUpSlotRE:FireServer(slotNum)
						end
						task.wait(speed)

						liveUnit = getLiveUnitData(unitKey)
						lvl = tonumber(liveUnit and liveUnit.attributes and liveUnit.attributes.level or targetLvl) or
							targetLvl
					end
				end
			end

			
			while scriptRunning and (isManual or cfg.autoLevel50Backpack) do
				local unmaxedList = getUnmaxedInventoryUnits(targetLvl)
				if #unmaxedList == 0 then
					logger.Log(string.format("All backpack units reached Level %d+!", targetLvl), UI.Colors.successGreen)
					break
				end

				local unitToUpgrade = unmaxedList[1]
				local targetSlot = unlockedSlots[1] or 1

				
				local slotData = nil
				if DataController and DataController.Slots then
					local ok, getter = pcall(function() return DataController.Slots[tostring(targetSlot)] end)
					if ok and getter then
						slotData = (typeof(getter) == "function" and getter()) or getter
					end
				end

				if slotData and slotData.unitId and interactSlotRE then
					interactSlotRE:FireServer(targetSlot)
					task.wait(0.2)
				end

				
				if equipUnitRF then
					pcall(function() equipUnitRF:InvokeServer(unitToUpgrade.id) end)
				end
				task.wait(0.15)
				if interactSlotRE then
					interactSlotRE:FireServer(targetSlot)
				end
				task.wait(0.2)

				
				local startTime = tick()
				local outOfMoney = false
				while scriptRunning and (tick() - startTime < 20) and (isManual or cfg.autoLevel50Backpack) do
					local liveUnit = getLiveUnitData(unitToUpgrade.id)
					local currentLvl = tonumber(liveUnit and liveUnit.attributes and liveUnit.attributes.level or 1) or 1
					if currentLvl >= targetLvl then
						logger.Log(string.format("[%s] upgraded to Level %d!", unitToUpgrade.name, currentLvl),
							UI.Colors.successGreen)
						break
					end

					local currentMoney = 0
					if DataController and DataController.Money then
						local okM, m = pcall(DataController.Money)
						if okM and typeof(m) == "number" then currentMoney = m end
					end

					local price = 0
					if UnitUtil and UnitUtil.GetLevelPrice and liveUnit then
						local okP, p = pcall(UnitUtil.GetLevelPrice, liveUnit.name, liveUnit.attributes or {})
						if okP and typeof(p) == "number" then price = p end
					end

					if price > 0 and currentMoney < price then
						if collectBalanceRE then
							for _, sNum in ipairs(unlockedSlots) do
								pcall(function() collectBalanceRE:FireServer(sNum) end)
							end
						end
						task.wait(0.2)
						if DataController and DataController.Money then
							local okM2, m2 = pcall(DataController.Money)
							if okM2 and typeof(m2) == "number" then currentMoney = m2 end
						end
						if currentMoney < price then
							outOfMoney = true
							break
						end
					end

					if levelUpSlotRE then
						levelUpSlotRE:FireServer(targetSlot)
					end
					task.wait(speed)
				end

				
				if interactSlotRE then
					interactSlotRE:FireServer(targetSlot)
					task.wait(0.2)
				end

				if outOfMoney then
					logger.Log("Auto Level Up: Paused due to insufficient cash.", UI.Colors.warningYellow)
					break
				end
			end

			
			if unequipUnitRF then
				pcall(function() unequipUnitRF:InvokeServer() end)
			end
			task.wait(0.2)
			if equipBestPlotRE then
				equipBestPlotRE:FireServer()
			end
			logger.Log("Remote Level Up Pipeline complete! Best units restored to plot.", UI.Colors.accentCyan)

			isAutoLevel50Running = false
		end

		Settings.CreateControl("autoCollectBalance", "CreateToggle", plotSec, "Auto Collect Plot Balance", cfg.autoCollectBalance, function(v)
			cfg.autoCollectBalance = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Plot Collector started.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("collectDelay", "CreateSlider", plotSec, "Collect Interval", 0.1, 3.0, cfg.collectDelay, function(v)
			cfg.collectDelay = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2, "s")

		Settings.CreateControl("autoLevelUpSlots", "CreateToggle", plotSec, "Auto Level Up Plot Slots", cfg.autoLevelUpSlots, function(v)
			cfg.autoLevelUpSlots = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				local capStr = (cfg.maxSlotLevel and tonumber(cfg.maxSlotLevel) > 0) and
					string.format(" (Cap: Lv. %d)", tonumber(cfg.maxSlotLevel)) or " (Unlimited)"
				logger.Log("Auto Slot Upgrader active" .. capStr .. ".", UI.Colors.successGreen)
			end
		end, 3)

		Settings.CreateControl("maxSlotLevel", "CreateTextBox", plotSec, "Max Slot Level Target (0 = Max)", tostring(cfg.maxSlotLevel or "0"),
			"e.g. 20 (0 for unlimited)", function(val)
				local num = tonumber(val)
				if num then
					cfg.maxSlotLevel = math.max(0, math.floor(num))
					if Settings and Settings.Save then Settings.Save() end
					if cfg.maxSlotLevel > 0 then
						logger.Log(string.format("Set Max Plot Slot Level Cap to Lv. %d", cfg.maxSlotLevel),
							UI.Colors.accentCyan)
					else
						logger.Log("Max Plot Slot Level Cap set to Unlimited.", UI.Colors.accentCyan)
					end
				end
			end, 4)

		Settings.CreateControl("autoEquipBestPlot", "CreateToggle", plotSec, "Auto Equip Best Plot Units", cfg.autoEquipBestPlot, function(v)
			cfg.autoEquipBestPlot = v
			if Settings and Settings.Save then Settings.Save() end
		end, 5)

		Settings.CreateControl("autoLevel50Backpack", "CreateToggle", plotSec, "Auto Level 50 All Backpack Units", cfg.autoLevel50Backpack, function(v)
			cfg.autoLevel50Backpack = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log(
					string.format("Auto Backpack Unit Upgrader active (Target Lv. %d).",
						tonumber(cfg.backpackTargetLevel) or 50), UI.Colors.successGreen)
				task.spawn(function()
					runAutoLevel50Pipeline(false)
				end)
			end
		end, 6)

		Settings.CreateControl("backpackTargetLevel", "CreateTextBox", plotSec, "Backpack Target Level", tostring(cfg.backpackTargetLevel or "50"),
			"e.g. 50", function(val)
				local num = tonumber(val)
				if num and num > 0 then
					cfg.backpackTargetLevel = math.floor(num)
					if Settings and Settings.Save then Settings.Save() end
					logger.Log(string.format("Set Backpack Upgrade Target Level to Lv. %d", cfg.backpackTargetLevel),
						UI.Colors.accentCyan)
				end
			end, 7)

		Settings.CreateControl("backpackUpgradeSpeed", "CreateSlider", plotSec, "Backpack Upgrade Delay", 0.01, 0.2, cfg.backpackUpgradeSpeed or 0.04, function(v)
			cfg.backpackUpgradeSpeed = v
			if Settings and Settings.Save then Settings.Save() end
		end, 8, "s")

		UI.CreateButton(plotSec, "Instant Collect All Balance", function()
			for slot = 1, getMaxPlotSlots() do
				collectBalanceRE:FireServer(slot)
			end
			logger.Log("Collected balance from all slots.", UI.Colors.accentCyan)
		end, 9)

		UI.CreateButton(plotSec, "Upgrade All Affordable Slots Now", function()
			local count = upgradeAffordableSlots()
			local capStr = (cfg.maxSlotLevel and tonumber(cfg.maxSlotLevel) > 0) and
				string.format(" (Cap: Lv. %d)", tonumber(cfg.maxSlotLevel)) or ""
			logger.Log(string.format("Upgraded %d slot levels across plot%s.", count, capStr), UI.Colors.accentCyan)
		end, 10)

		UI.CreateButton(plotSec, "Equip Best Plot Team Now", function()
			equipBestPlotRE:FireServer()
			logger.Log("Equipped best units to plot.", UI.Colors.accentCyan)
		end, 11)

		UI.CreateButton(plotSec, "Upgrade All Backpack Units to Lv. 50 Now", function()
			task.spawn(function()
				runAutoLevel50Pipeline(true)
			end)
		end, 12)

		task.spawn(function()
			while scriptRunning do
				if cfg.autoCollectBalance then
					pcall(function()
						for slot = 1, getMaxPlotSlots() do
							collectBalanceRE:FireServer(slot)
						end
					end)
				end

				if cfg.autoLevelUpSlots then
					pcall(function()
						upgradeAffordableSlots()
					end)
				end

				if cfg.autoEquipBestPlot and not isAutoLevel50Running and not cfg.teamAutoEquip then
					pcall(function()
						equipBestPlotRE:FireServer()
					end)
				end

				if cfg.autoLevel50Backpack and not isAutoLevel50Running then
					pcall(function()
						local unmaxed = getUnmaxedInventoryUnits(tonumber(cfg.backpackTargetLevel) or 50)
						if #unmaxed > 0 then
							local currentMoney = 0
							if DataController and DataController.Money then
								local okM, m = pcall(DataController.Money)
								if okM and typeof(m) == "number" then currentMoney = m end
							end
							if currentMoney > 100 then
								task.spawn(function()
									runAutoLevel50Pipeline(false)
								end)
							end
						end
					end)
				end

				task.wait(cfg.collectDelay or 0.5)
			end
		end)

		
		
		
		local Quirks = nil
		local WeatherConfig = nil
		pcall(function()
			Quirks = require(Features.Quirks.Quirks)
			WeatherConfig = require(Features.Weather.WeatherConfig)
		end)

		
		local TEAM_FOCUS_OPTIONS = { "Luck", "Money", "Trait Luck", "Grade Luck", "Roll Speed" }
		local TEAM_FOCUS_STAT = {
			Luck = "Luck",
			Money = "Money Multiplier",
			["Trait Luck"] = "Trait Luck",
			["Grade Luck"] = "Grade Luck",
			["Roll Speed"] = "Roll Duration",
		}

		local function getEventFocus()
			if not (cfg.teamAutoEvent ~= false and WeatherTracker.Active and WeatherConfig) then return nil end
			local ok, weather = pcall(WeatherConfig.Get, WeatherTracker.Name)
			if not (ok and weather and weather.buffs) then return nil end
			for _, focus in ipairs(TEAM_FOCUS_OPTIONS) do
				if weather.buffs[TEAM_FOCUS_STAT[focus]] then return focus end
			end
			return nil
		end

		local function quirkScore(quirkName, stat)
			local q = quirkName and Quirks and Quirks[quirkName]
			local b = q and q.buffs and q.buffs[stat]
			if not b or type(b.amount) ~= "number" then return 0 end
			
			return stat == "Roll Duration" and -b.amount or b.amount
		end

		
		local function rankTeam(units, slotCount)
			table.sort(units, function(a, b)
				if a.score ~= b.score then return a.score > b.score end
				if a.income ~= b.income then return a.income > b.income end
				return a.id < b.id
			end)
			local picked = {}
			for i = 1, math.min(#units, slotCount) do picked[i] = units[i] end
			return picked
		end

		do
			local r = rankTeam({
				{ id = "a", score = 0,   income = 100 },
				{ id = "b", score = 0.5, income = 1 },
				{ id = "c", score = 0.2, income = 50 },
				{ id = "d", score = 0,   income = 10 },
			}, 3)
			assert(#r == 3 and r[1].id == "b" and r[2].id == "c" and r[3].id == "a", "rankTeam self-check failed")
		end

		local function getTeamUnits(focus)
			local stat = TEAM_FOCUS_STAT[focus] or "Luck"
			local units = {}
			for id, item in pairs(DataController.Inventory()) do
				local entry = EntryRegistry.getEntryConfig(item.name)
				if entry and entry.kind == "Unit" then
					local attrs = item.attributes or {}
					table.insert(units,
						{ id = tostring(id), score = quirkScore(attrs.quirk, stat), income = entry.income(attrs) })
				end
			end
			return units
		end

		local function getTeamSlots()
			local list = {}
			for _, slotNum in ipairs(getUnlockedPlotSlots()) do
				local ok, data = pcall(function() return DataController.Slots[tostring(slotNum)]() end)
				
				if ok and data then table.insert(list, { slot = slotNum, unitId = data.unitId }) end
			end
			return list
		end

		local isTeamApplying = false
		
		local function applyQuirkTeam(focus, isManual)
			if isTeamApplying or isAutoLevel50Running then return 0, 0 end
			if not (DataController and EntryRegistry and equipUnitRF and interactSlotRE) then return 0, 0 end
			isTeamApplying = true
			local swaps, quirkCount = 0, 0
			local ok, err = pcall(function()
				local slots = getTeamSlots()
				local picked = rankTeam(getTeamUnits(focus), #slots)
				local wanted = {}
				for _, u in ipairs(picked) do
					wanted[u.id] = true
					if u.score > 0 then quirkCount = quirkCount + 1 end
				end

				
				local freeSlots = {}
				for _, s in ipairs(slots) do
					if s.unitId and wanted[s.unitId] then
						wanted[s.unitId] = nil
					else
						table.insert(freeSlots, s)
					end
				end

				
				local i = 0
				for _, u in ipairs(picked) do
					if wanted[u.id] then
						i = i + 1
						local s = freeSlots[i]
						if not s or not scriptRunning or not (isManual or cfg.teamAutoEquip) then break end
						
						if s.unitId then collectBalanceRE:FireServer(s.slot) end
						if equipUnitRF:InvokeServer(u.id) then
							interactSlotRE:FireServer(s.slot)
							swaps = swaps + 1
						end
						task.wait(0.55) 
					end
				end
			end)
			isTeamApplying = false
			if not ok then
				logger.Log("[Team Unit] Apply failed: " .. tostring(err), UI.Colors.dangerRed)
			end
			return swaps, quirkCount
		end

		local teamTab = UI.Tabs.Team or UI.Tabs.Main
		local teamSec = UI.CreateSection(teamTab, "Quirk Team Rotation", 1, true)
		local teamFocusBox = UI.CreateStatBox(teamSec, "Active Focus", "Off", 1)
		local teamQuirkBox = UI.CreateStatBox(teamSec, "Focus Quirk Units On Plot", "0", 2)

		local function runTeamApply(focus, isEvent, isManual)
			local swaps, quirkCount = applyQuirkTeam(focus, isManual)
			teamFocusBox.Set(focus .. (isEvent and " (Event)" or ""))
			teamQuirkBox.Set(tostring(quirkCount))
			if swaps > 0 then
				logger.Log(
					string.format("[Team Unit] Swapped %d unit(s) for %s focus (%d quirk unit(s) placed).", swaps,
						focus, quirkCount), UI.Colors.accentCyan)
			end
		end

		Settings.CreateControl("teamAutoEquip", "CreateToggle", teamSec, "Auto Equip Quirk Team", cfg.teamAutoEquip, function(v)
			cfg.teamAutoEquip = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Quirk Team enabled (" .. tostring(cfg.teamFocus or "Luck") .. " focus).",
					UI.Colors.successGreen)
				if cfg.autoEquipBestPlot then
					logger.Log("Auto Equip Best Plot Units is paused while Quirk Team is on.", UI.Colors.warningYellow)
				end
			else
				teamFocusBox.Set("Off")
			end
		end, 3)

		Settings.CreateControl("teamFocus", "CreateDropdown", teamSec, "Team Focus", TEAM_FOCUS_OPTIONS, cfg.teamFocus or "Luck", function(v)
			cfg.teamFocus = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Team Focus set to: " .. tostring(v), UI.Colors.accentCyan)
		end, 4)

		Settings.CreateControl("teamAutoEvent", "CreateToggle", teamSec, "Auto Switch Focus On Weather Event", cfg.teamAutoEvent ~= false, function(v)
			cfg.teamAutoEvent = v
			if Settings and Settings.Save then Settings.Save() end
		end, 5)

		UI.CreateButton(teamSec, "Equip Quirk Team Now", function()
			task.spawn(function()
				local eventFocus = getEventFocus()
				runTeamApply(eventFocus or cfg.teamFocus or "Luck", eventFocus ~= nil, true)
			end)
		end, 6)

		task.spawn(function()
			local lastFocus = nil
			while scriptRunning do
				if cfg.teamAutoEquip then
					local eventFocus = getEventFocus()
					local focus = eventFocus or cfg.teamFocus or "Luck"
					if focus ~= lastFocus then
						lastFocus = focus
						logger.Log(string.format("[Team Unit] Rotating team to %s focus%s.", focus,
							eventFocus and (" (" .. WeatherTracker.Name .. ")") or ""), UI.Colors.successGreen)
					end
					runTeamApply(focus, eventFocus ~= nil)
				else
					lastFocus = nil
				end
				task.wait(3)
			end
		end)
	end

	
	
	
	do
		local towerTab = UI.Tabs.Tower
		local towerSec = UI.CreateSection(towerTab, "Tower Battles", 1, true)

		local NetworkPkg = nil
		pcall(function()
			NetworkPkg = require(ReplicatedStorage.Packages.Network)
		end)

		local towerComm = nil
		local PlayTowerFn = nil
		local CompleteTowerFloorFn = nil
		local CancelTowerFn = nil

		if NetworkPkg and NetworkPkg.ClientComm then
			pcall(function()
				towerComm = NetworkPkg.ClientComm.new(ReplicatedStorage.Network, false, "Towers")
				PlayTowerFn = towerComm:GetFunction("PlayTower")
				CompleteTowerFloorFn = towerComm:GetFunction("CompleteTowerFloor")
				CancelTowerFn = towerComm:GetFunction("CancelTower")
			end)
		end

		
		local lastTowerStartAt = 0
		local function doPlayTower(tName)
			
			local debounceLeft = 5.2 - (os.clock() - lastTowerStartAt)
			if debounceLeft > 0 then task.wait(debounceLeft) end
			if playTowerRF then
				local ok, res = pcall(function() return playTowerRF:InvokeServer(tName) end)
				if ok and res then
					lastTowerStartAt = os.clock()
					return true
				end
			end
			if PlayTowerFn then
				local ok, res = pcall(PlayTowerFn, tName)
				if ok and res then
					lastTowerStartAt = os.clock()
					return true
				end
			end
			return false
		end

		local function doCompleteFloor()
			if completeTowerFloorRF then
				local ok, res = pcall(function() return completeTowerFloorRF:InvokeServer() end)
				if ok and res ~= nil then return res end
			end
			if CompleteTowerFloorFn then
				local ok, res = pcall(CompleteTowerFloorFn)
				if ok and res ~= nil then return res end
			end
			return nil
		end

		local function doCancelTower()
			if cancelTowerRF then
				pcall(function() cancelTowerRF:InvokeServer() end)
			end
			if CancelTowerFn then
				pcall(CancelTowerFn)
			end
		end

		local function getSequenceWaitTime(events, isFirstFloor)
			if not events or type(events) ~= "table" then return 0.1 end
			local total = 0
			local floorStartInitial = (TowerRefs and TowerRefs.FloorStartedWaitTime and TowerRefs.FloorStartedWaitTime.initial) or
				0.76
			local floorStartTransition = (TowerRefs and TowerRefs.FloorStartedWaitTime and TowerRefs.FloorStartedWaitTime.transition) or
				0.38
			local floorStartRepeated = (TowerRefs and TowerRefs.FloorStartedWaitTime and TowerRefs.FloorStartedWaitTime.repeated) or
				0
			local actionWait = (TowerRefs and TowerRefs.ActionWaitTime) or {
				damageEnemy = 0.62,
				damagePlayer = 0.62,
				floorCompleted = 0.24,
				memberDefeated = 0.32,
				ended = 0
			}

			for i, v in ipairs(events) do
				if v.action == "floorStarted" then
					local prev = events[i - 1]
					if i == 1 then
						if isFirstFloor or v.floor == 1 then
							total = total + floorStartInitial
						else
							total = total + floorStartTransition
						end
					elseif prev and prev.action == "memberDefeated" then
						total = total + floorStartTransition
					else
						total = total + floorStartRepeated
					end
				else
					total = total + (actionWait[v.action] or 0)
				end
			end
			return total
		end

		Settings.CreateControl("selectedTower", "CreateDropdown", towerSec, "Select Tower (Single)", ALL_TOWERS, cfg.selectedTower, function(v)
			cfg.selectedTower = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Selected Tower: " .. tostring(v), UI.Colors.textSecondary)
		end, 1)

		Settings.CreateControl("towerShifting", "CreateToggle", towerSec, "Tower Shifting (Rotate Towers)", cfg.towerShifting, function(v)
			cfg.towerShifting = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Tower Shifting enabled.", UI.Colors.accentCyan)
			else
				logger.Log("Tower Shifting disabled.", UI.Colors.textMuted)
			end
		end, 2)

		Settings.CreateControl("selectedTowers", "CreateMultiDropdown", towerSec, "Select Towers to Rotate", ALL_TOWERS, cfg.selectedTowers or {
			["Dragon Tower"] = true,
			["Cursed Tower"] = true,
			["Pirate Tower"] = true,
			["Hidden Leaf Tower"] = true,
			["Infinity Tower"] = true,
		}, function(selectedMap)
			cfg.selectedTowers = selectedMap
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		Settings.CreateControl("maxFloorPerTower", "CreateTextBox", towerSec, "Max Floor per Tower",
			tostring(cfg.maxFloorPerTower ~= nil and cfg.maxFloorPerTower or 0), "0 = unlimited",
			function(text)
				local num = tonumber(text)
				if num and num >= 0 then
					cfg.maxFloorPerTower = math.floor(num)
				else
					cfg.maxFloorPerTower = 0
				end
				if Settings and Settings.Save then Settings.Save() end
				logger.Log(
					"Max Floor per Tower set to: " ..
					tostring(cfg.maxFloorPerTower) .. (cfg.maxFloorPerTower == 0 and " (Unlimited)" or ""),
					UI.Colors.textSecondary)
			end, 4)

		local autoTowerToggle = Settings.CreateControl("autoPlayTower", "CreateToggle", towerSec, "Auto Play Tower", cfg.autoPlayTower, function(v)
			cfg.autoPlayTower = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				if cfg.towerShifting then
					logger.Log("Auto Tower battler started (Shifting Mode)", UI.Colors.successGreen)
				else
					logger.Log("Auto Tower battler started on " .. tostring(cfg.selectedTower), UI.Colors.successGreen)
				end
			else
				logger.Log("Auto Tower battler stopped.", UI.Colors.textMuted)
			end
		end, 5)

		Settings.CreateControl("instantClearFloor", "CreateToggle", towerSec, "Instant Clear Floors (Fast Battle)", cfg.instantClearFloor, function(v)
			cfg.instantClearFloor = v
			if Settings and Settings.Save then Settings.Save() end
		end, 6)

		Settings.CreateControl("autoEquipBestTowerTeam", "CreateToggle", towerSec, "Auto Equip Best Tower Team", cfg.autoEquipBestTowerTeam, function(v)
			cfg.autoEquipBestTowerTeam = v
			if Settings and Settings.Save then Settings.Save() end
		end, 7)

		Settings.CreateControl("autoRepeatTower", "CreateToggle", towerSec, "Auto Repeat / Farm Tower", cfg.autoRepeatTower, function(v)
			cfg.autoRepeatTower = v
			if Settings and Settings.Save then Settings.Save() end
		end, 8)

		UI.CreateButton(towerSec, "Cancel Current Tower Battle", function()
			doCancelTower()
			logger.Log("Cancelled active tower battle.", UI.Colors.dangerRed)
		end, 9)

		local currentShiftIndex = 1

		local function getActiveShiftTowers()
			local list = {}
			for _, tName in ipairs(ALL_TOWERS) do
				if cfg.selectedTowers and cfg.selectedTowers[tName] == true then
					table.insert(list, tName)
				end
			end
			return list
		end

		local function getNextShiftTower()
			local list = getActiveShiftTowers()
			if #list == 0 then
				return cfg.selectedTower or "Pirate Tower"
			end
			if currentShiftIndex > #list then
				currentShiftIndex = 1
			end
			return list[currentShiftIndex]
		end

		local function advanceShiftTower()
			local list = getActiveShiftTowers()
			if #list > 0 then
				currentShiftIndex = (currentShiftIndex % #list) + 1
			else
				currentShiftIndex = 1
			end
		end

		task.spawn(function()
			while scriptRunning do
				if cfg.autoPlayTower then
					pcall(function()
						if cfg.autoEquipBestTowerTeam then
							pcall(function() equipBestTowerTeamRE:FireServer() end)
							task.wait(0.15)
						end

						local towerName = "Pirate Tower"
						if cfg.towerShifting then
							towerName = getNextShiftTower()
						else
							towerName = cfg.selectedTower or "Pirate Tower"
						end

						logger.Log(
							"Starting Tower: " .. tostring(towerName) .. (cfg.towerShifting and " [Shifting]" or ""),
							UI.Colors.accentCyan
						)

						doCancelTower()
						task.wait(0.2)

						local playStarted = doPlayTower(towerName)
						if playStarted then
							inTowerActive = true
							currentActiveTowerName = towerName
							local inTower = true
							local currentFloor = 1
							local consecutiveFails = 0
							local isFirstFloor = true
							local maxFloor = tonumber(cfg.maxFloorPerTower) or 0
							local wasCancelled = false

							while inTower and cfg.autoPlayTower and scriptRunning do
								local callT0 = os.clock()
								local events = doCompleteFloor()
								local callRtt = os.clock() - callT0

								if events == "destroyed" then
									
									inTower = false
									wasCancelled = true
									logger.Log(string.format("Tower %s run was cancelled. Restarting...", towerName),
										UI.Colors.textMuted)
									if cfg.towerShifting then
										advanceShiftTower()
									end
									break
								elseif not events or (type(events) == "table" and #events == 0) then
									consecutiveFails = consecutiveFails + 1
									if consecutiveFails >= 12 then
										inTower = false
										inTowerActive = false
										currentActiveTowerName = nil
										logger.Log("Tower battle exited.", UI.Colors.textMuted)
										if cfg.towerShifting then
											advanceShiftTower()
										end
										break
									end
									task.wait(0.02)
								else
									consecutiveFails = 0
									if type(events) == "table" then
										local ended = false
										local floorFinished = false
										for _, ev in ipairs(events) do
											if ev.action == "floorStarted" and ev.floor then
												currentFloor = ev.floor
												if maxFloor > 0 and currentFloor > maxFloor then
													if cfg.towerShifting then
														logger.Log(
															string.format(
																"Tower %s already above configured Max Floor %d (Current: %d). Shifting next...",
																towerName, maxFloor, currentFloor
															),
															UI.Colors.accentCyan
														)
														doCancelTower()
														inTower = false
														ended = true
														advanceShiftTower()
														break
													else
														logger.Log(
															string.format(
																"Tower %s reached configured Max Floor %d.",
																towerName, maxFloor
															),
															UI.Colors.accentCyan
														)
														doCancelTower()
														inTower = false
														ended = true
														if not cfg.autoRepeatTower then
															cfg.autoPlayTower = false
															if autoTowerToggle and autoTowerToggle.Set then
																autoTowerToggle.Set(false)
															end
															if Settings and Settings.Save then Settings.Save() end
														end
														break
													end
												end
											elseif ev.action == "floorCompleted" then
												floorFinished = true
												if ev.rewards and type(ev.rewards) == "table" then
													for rewardName, rewardAmt in pairs(ev.rewards) do
														processItemReward(rewardName, rewardAmt,
															string.format("Tower %s - Floor %d", towerName, currentFloor))
													end
												end
											elseif ev.action == "ended" then
												ended = true
												if ev.rewards and type(ev.rewards) == "table" then
													for rewardName, rewardAmt in pairs(ev.rewards) do
														processItemReward(rewardName, rewardAmt,
															string.format("Tower %s Completion", towerName))
													end
												end
												break
											end
										end

										if floorFinished then
											logger.Log(
												string.format("Tower %s - Floor %d Cleared!", towerName, currentFloor),
												UI.Colors.successGreen
											)

											if maxFloor > 0 and currentFloor >= maxFloor then
												if cfg.towerShifting then
													logger.Log(
														string.format(
															"Reached configured Max Floor %d on %s. Shifting to next tower...",
															maxFloor, towerName
														),
														UI.Colors.accentCyan
													)
													doCancelTower()
													inTower = false
													inTowerActive = false
													currentActiveTowerName = nil
													advanceShiftTower()
													break
												else
													if cfg.autoRepeatTower then
														logger.Log(
															string.format(
																"Reached configured Max Floor %d on %s. Auto-Repeating tower...",
																maxFloor, towerName
															),
															UI.Colors.accentCyan
														)
														doCancelTower()
														inTower = false
														inTowerActive = false
														currentActiveTowerName = nil
														task.wait(0.2)
														break
													else
														logger.Log(
															string.format(
																"Reached configured Max Floor %d on %s. Completed tower run.",
																maxFloor, towerName
															),
															UI.Colors.successGreen
														)
														doCancelTower()
														inTower = false
														inTowerActive = false
														currentActiveTowerName = nil
														cfg.autoPlayTower = false
														if autoTowerToggle and autoTowerToggle.Set then
															autoTowerToggle.Set(false)
														end
														if Settings and Settings.Save then Settings.Save() end
														if UI.Notify then
															UI.Notify("Tower Target Reached",
																string.format("Finished Floor %d on %s!", maxFloor,
																	towerName), UI.Colors.successGreen, 4)
														end
														break
													end
												end
											end
										end

										if ended then
											inTower = false
											inTowerActive = false
											currentActiveTowerName = nil
											logger.Log(
												string.format("Tower %s run ended at Floor %d.", towerName, currentFloor),
												UI.Colors.accentViolet
											)
											if cfg.webhookNotifyTower then
												sendWebhook(
													"Tower Completed",
													string.format("Player **%s** finished **%s** at Floor %d!",
														player.Name,
														towerName, currentFloor),
													{
														{ name = "Tower",         value = towerName,              inline = true },
														{ name = "Floor Reached", value = tostring(currentFloor), inline = true }
													},
													16753920
												)
											end
											if cfg.towerShifting then
												advanceShiftTower()
											elseif not cfg.autoRepeatTower then
												cfg.autoPlayTower = false
												if autoTowerToggle and autoTowerToggle.Set then
													autoTowerToggle.Set(false)
												end
												if Settings and Settings.Save then Settings.Save() end
											end
											break
										end

										
										if cfg.instantClearFloor then
											local seqWait = getSequenceWaitTime(events, isFirstFloor)
											isFirstFloor = false
											local waitTime = math.max(0.01, seqWait - (callRtt * 0.5) - 0.025)
											task.wait(waitTime)
										else
											task.wait(1.5)
										end
									end
								end
							end

							inTowerActive = false
							currentActiveTowerName = nil

							if not cfg.autoRepeatTower and not wasCancelled and scriptRunning then
								cfg.autoPlayTower = false
								autoTowerToggle.Set(false)
								if Settings and Settings.Save then Settings.Save() end
							else
								if cfg.towerShifting then
									local nextT = getNextShiftTower()
									logger.Log(
										"Tower Shift: next target is " .. tostring(nextT) .. ". Starting next...",
										UI.Colors.accentCyan
									)
								elseif cfg.autoRepeatTower and scriptRunning then
									logger.Log("Auto Repeat active: starting next tower...", UI.Colors.textSecondary)
								end
								task.wait(0.5)
							end
						else
							inTowerActive = false
							currentActiveTowerName = nil
							logger.Log("Failed to start tower: " .. tostring(towerName), UI.Colors.dangerRed)
							if cfg.towerShifting then
								advanceShiftTower()
							end
							task.wait(1.0)
						end
					end)
					task.wait(0.5)
				else
					task.wait(0.5)
				end
			end
		end)
	end

	
	
	
	do
		local upgTab = UI.Tabs.Upgrades
		local shopTab = UI.Tabs.Shop or UI.Tabs.Trade
		local upgSec = UI.CreateSection(upgTab, "Base Upgrades", 1, true)

		Settings.CreateControl("autoBuyUpgrades", "CreateToggle", upgSec, "Auto Buy Upgrades", cfg.autoBuyUpgrades, function(v)
			cfg.autoBuyUpgrades = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Upgrades purchaser active.", UI.Colors.successGreen) end
		end, 1)

		
		local function upgCategory(name) return name:match("^(.-)%s+[IVXLCDM]+$") or name end
		local UPGRADE_FOCUS = {}
		if Upgrades then
			local seen = {}
			for name in pairs(Upgrades) do
				local c = upgCategory(name)
				if c ~= "Start" and not seen[c] then
					seen[c] = true
					table.insert(UPGRADE_FOCUS, c)
				end
			end
			table.sort(UPGRADE_FOCUS)
		end
		table.insert(UPGRADE_FOCUS, 1, "All")

		Settings.CreateControl("upgradeFocus", "CreateMultiDropdown", upgSec, "Upgrade Focus", UPGRADE_FOCUS, cfg.upgradeFocus, function(newMap)
			cfg.upgradeFocus = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		local shopSec = UI.CreateSection(shopTab, "Dice Shop", 1, true)

		Settings.CreateControl("autoBuyDice", "CreateToggle", shopSec, "Auto Buy Best Dice", cfg.autoBuyDice, function(v)
			cfg.autoBuyDice = v
			if Settings and Settings.Save then Settings.Save() end
		end, 1)

		Settings.CreateControl("autoEquipBestDice", "CreateToggle", shopSec, "Auto Equip Highest Luck Dice", cfg.autoEquipBestDice, function(v)
			cfg.autoEquipBestDice = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		task.spawn(function()
			while true do
				if cfg.autoBuyUpgrades and TreeStructure and Upgrades and DataController then
					pcall(function()
						local playerMoney = DataController.Money() or 0
						
						
						local focus = cfg.upgradeFocus or {}
						local wanted
						if not focus.All then
							for name in pairs(Upgrades) do
								if focus[upgCategory(name)] then
									wanted = wanted or {}
									local n = name
									while n and not wanted[n] do
										wanted[n] = true
										n = TreeStructure.GetParent(n)
									end
								end
							end
						end
						local function scanAndBuy(nodeName)
							for _, child in ipairs(TreeStructure.GetChildren(nodeName)) do
								local owned = DataController.Upgrades[child] and DataController.Upgrades[child]()
								if owned then
									scanAndBuy(child)
								else
									local upgData = Upgrades[child]
									if upgData and (not wanted or wanted[child]) and playerMoney >= upgData.price then
										buyUpgradeRE:FireServer(child)
										logger.Log("Bought Upgrade: " .. tostring(child), UI.Colors.successGreen)
										task.wait(0.1)
									end
								end
							end
						end
						scanAndBuy("Start")
					end)
				end

				if (cfg.autoBuyDice or cfg.autoEquipBestDice) and Dice and DataController then
					pcall(function()
						local allDice = Dice.GetAll()
						local playerMoney = DataController.Money() or 0
						local highestLuck = 0
						local bestOwnedDice = nil

						for diceName, diceData in pairs(allDice) do
							local isOwned = DataController.OwnedDice[diceName] and
								DataController.OwnedDice[diceName]() == true

							if not isOwned and cfg.autoBuyDice and diceData.price and playerMoney >= diceData.price then
								buyDiceRE:FireServer(diceName)
								logger.Log("Purchased Dice: " .. tostring(diceName), UI.Colors.successGreen)
								task.wait(0.2)
							end

							if isOwned and diceData.luck and diceData.luck > highestLuck then
								highestLuck = diceData.luck
								bestOwnedDice = diceName
							end
						end

						if cfg.autoEquipBestDice and bestOwnedDice and DataController.Dice() ~= bestOwnedDice then
							equipDiceRE:FireServer(bestOwnedDice)
							logger.Log("Equipped Best Dice: " .. tostring(bestOwnedDice), UI.Colors.accentCyan)
						end
					end)
				end

				task.wait(1.5)
			end
		end)
	end

	
	
	
	do
		local invTab = UI.Tabs.Sell or UI.Tabs.Inventory

		
		local potionSec = UI.CreateSection(invTab, "Potions & Boosts Configuration", 3, true)

		Settings.CreateControl("autoUsePotions", "CreateToggle", potionSec, "Auto Use Selected Potions", cfg.autoUsePotions, function(v)
			cfg.autoUsePotions = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Use Potion engine enabled.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("selectedPotions", "CreateMultiDropdown", potionSec, "Select Potions", ALL_POTIONS,
			cfg.selectedPotions, function(newMap)
				cfg.selectedPotions = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		Settings.CreateControl("potionInterval", "CreateSlider", potionSec, "Potion Use Interval", 1, 60, cfg.potionInterval or 5, function(v)
			cfg.potionInterval = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3, "s")

		Settings.CreateControl("potionOnlyWhenExpired", "CreateToggle", potionSec, "Only Use When Buff Expired", cfg.potionOnlyWhenExpired, function(v)
			cfg.potionOnlyWhenExpired = v
			if Settings and Settings.Save then Settings.Save() end
		end, 4)

		UI.CreateButton(potionSec, "Use All Selected Potions Once", function()
			pcall(function()
				if not useBoostRE or not DataController or not DataController.Inventory then return end
				local inv = DataController.Inventory()
				local usedCount = 0
				for potionName, isSelected in pairs(cfg.selectedPotions or {}) do
					if isSelected == true then
						local itemData = inv[potionName]
						local count = itemData and (itemData.amount or 1) or 0
						if count > 0 then
							useBoostRE:FireServer(potionName)
							usedCount = usedCount + 1
							logger.Log("Used Potion: " .. tostring(potionName), UI.Colors.accentCyan)
							task.wait(0.15)
						end
					end
				end
				if usedCount == 0 then
					logger.Log("No selected potions available in inventory.", UI.Colors.textMuted)
				end
			end)
		end, 5)

		
		local lockSec = UI.CreateSection(invTab, "Auto Lock Configuration", 2, true)

		UI.CreateDivider(lockSec, "Mutated Units", 1)

		Settings.CreateControl("autoLockMutated", "CreateToggle", lockSec, "Lock Mutated Units", cfg.autoLockMutated, function(v)
			cfg.autoLockMutated = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Mutated Unit Locking active.", UI.Colors.successGreen) end
		end, 2)

		Settings.CreateControl("autoLockMutatedMode", "CreateDropdown", lockSec, "Mutated Lock Filter", {
			"All Mutated",
			"By Money/s",
			"By Rarity Tier",
			"Money/s OR Rarity",
			"Money/s AND Rarity"
		}, cfg.autoLockMutatedMode or "By Money/s", function(v)
			cfg.autoLockMutatedMode = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Mutated lock filter set to: " .. tostring(v), UI.Colors.accentCyan)
		end, 3)

		Settings.CreateControl("autoLockMutatedCondition", "CreateDropdown", lockSec, "Mutated Money Condition", { "Above (>=)", "Below (<=)" },
			cfg.autoLockMutatedCondition or "Above (>=)", function(v)
				cfg.autoLockMutatedCondition = v
				if Settings and Settings.Save then Settings.Save() end
			end, 4)

		local initialMutVal = tostring(cfg.autoLockMutatedThreshold or "1")
		if initialMutVal:find("in") then
			initialMutVal = "1"
			cfg.autoLockMutatedThreshold = "1"
		end
		Settings.CreateControl("autoLockMutatedThreshold", "CreateTextBox", lockSec, "Mutated Value Threshold", initialMutVal, "e.g. 100k, 1M, 10B, 1T", function(v)
			cfg.autoLockMutatedThreshold = v
			if Settings and Settings.Save then Settings.Save() end
			local parsed = parseMoneyValue(v)
			logger.Log(
				string.format("Mutated Lock Money/s threshold set to: %s ($%s/s)", tostring(v), formatNumber(parsed)),
				UI.Colors.textSecondary)
		end, 5)

		Settings.CreateControl("mutatedLockRarities", "CreateMultiDropdown", lockSec, "Mutated Rarities to Lock", ALL_RARITIES,
			cfg.mutatedLockRarities, function(newMap)
				cfg.mutatedLockRarities = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 6)

		UI.CreateDivider(lockSec, "General Units", 7)

		Settings.CreateControl("autoLockCustom", "CreateToggle", lockSec, "Lock by Money/s (All Units)", cfg.autoLockCustom, function(v)
			cfg.autoLockCustom = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Lock by Money/s enabled.", UI.Colors.successGreen) end
		end, 8)

		Settings.CreateControl("autoLockMode", "CreateDropdown", lockSec, "Lock Condition (All Units)", { "Above (>=)", "Below (<=)" },
			cfg.autoLockMode or "Above (>=)", function(v)
				cfg.autoLockMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 9)

		local initialLockVal = tostring(cfg.autoLockThreshold or "1")
		if initialLockVal:find("in") then
			initialLockVal = "1"
			cfg.autoLockThreshold = "1"
		end
		Settings.CreateControl("autoLockThreshold", "CreateTextBox", lockSec, "Lock Value Threshold", initialLockVal, "e.g. 100k, 1M, 10B, 1T", function(v)
			cfg.autoLockThreshold = v
			if Settings and Settings.Save then Settings.Save() end
			local parsed = parseMoneyValue(v)
			logger.Log(
				string.format("Auto Lock Money/s threshold set to: %s ($%s/s)", tostring(v), formatNumber(parsed)),
				UI.Colors.textSecondary)
		end, 10)

		Settings.CreateControl("autoLockRare", "CreateToggle", lockSec, "Lock by Rarity Tier (All Units)", cfg.autoLockRare, function(v)
			cfg.autoLockRare = v
			if Settings and Settings.Save then Settings.Save() end
		end, 11)

		Settings.CreateControl("lockRarities", "CreateMultiDropdown", lockSec, "Rarities to Lock (All Units)", ALL_RARITIES,
			cfg.lockRarities, function(newMap)
				cfg.lockRarities = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 12)

		
		local sellSec = UI.CreateSection(invTab, "Auto Sell Configuration", 1, true)

		UI.CreateDivider(sellSec, "By Money / Second", 1)

		Settings.CreateControl("autoSellCustom", "CreateToggle", sellSec, "Auto Sell by Money/s", cfg.autoSellCustom, function(v)
			cfg.autoSellCustom = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Sell by Money/s enabled.", UI.Colors.successGreen) end
		end, 2)

		Settings.CreateControl("autoSellMode", "CreateDropdown", sellSec, "Sell Condition", { "Below (<=)", "Above (>=)" }, cfg.autoSellMode or "Below (<=)",
			function(v)
				cfg.autoSellMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 3)

		local initialSellVal = tostring(cfg.autoSellThreshold or "0.1")
		if initialSellVal:find("in") then
			initialSellVal = "0.1"
			cfg.autoSellThreshold = "0.1"
		end
		Settings.CreateControl("autoSellThreshold", "CreateTextBox", sellSec, "Sell Value Threshold", initialSellVal, "e.g. 100k, 1M, 10B, 1T", function(v)
			cfg.autoSellThreshold = v
			if Settings and Settings.Save then Settings.Save() end
			local parsed = parseMoneyValue(v)
			logger.Log(
				string.format("Auto Sell Money/s threshold set to: %s ($%s/s)", tostring(v), formatNumber(parsed)),
				UI.Colors.textSecondary)
		end, 4)

		UI.CreateDivider(sellSec, "By Chance (1 in X)", 5)

		Settings.CreateControl("autoSellByChance", "CreateToggle", sellSec, "Auto Sell by Chance", cfg.autoSellByChance, function(v)
			cfg.autoSellByChance = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Sell by Chance (1 in X) enabled.", UI.Colors.successGreen) end
		end, 6)

		Settings.CreateControl("autoSellChanceMode", "CreateDropdown", sellSec, "Sell Chance Condition", { "Below (<=)", "Above (>=)" },
			cfg.autoSellChanceMode or "Below (<=)",
			function(v)
				cfg.autoSellChanceMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 7)

		local initialSellChance = tostring(cfg.autoSellChanceThreshold or "1 in 10sx")
		Settings.CreateControl("autoSellChanceThreshold", "CreateTextBox", sellSec, "Sell Chance Threshold", initialSellChance, "e.g. 1 in 10sx, 25sx, 100k", function(v)
			cfg.autoSellChanceThreshold = v
			if Settings and Settings.Save then Settings.Save() end
			local parsed = parseChance(v)
			logger.Log(
				string.format("Auto Sell Chance threshold set to: %s (1 in %s)", tostring(v), formatNumber(parsed)),
				UI.Colors.textSecondary)
		end, 8)

		UI.CreateDivider(sellSec, "By Rarity Tier", 9)

		Settings.CreateControl("autoSellByRarity", "CreateToggle", sellSec, "Sell by Rarity Tier", cfg.autoSellByRarity, function(v)
			cfg.autoSellByRarity = v
			if Settings and Settings.Save then Settings.Save() end
		end, 10)

		Settings.CreateControl("sellRarities", "CreateMultiDropdown", sellSec, "Rarities to Sell", ALL_RARITIES,
			cfg.sellRarities, function(newMap)
				cfg.sellRarities = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 11)

		
		local manualSellSec = UI.CreateSection(invTab, "Manual Inventory Actions", 4, true)

		UI.CreateButton(manualSellSec, "Sell All Unlocked Inventory", function()
			pcall(function()
				if not DataController or not DataController.Inventory then return end
				local inv = extractInventory(DataController.Inventory)
				local keys = {}
				for key, u in pairs(inv) do
					if typeof(u) == "table" and u.attributes and not u.attributes.locked then
						table.insert(keys, key)
					end
				end
				if #keys > 0 then
					sellInventoryRF:InvokeServer(keys)
					logger.Log(string.format("Sold %d units from inventory.", #keys), UI.Colors.accentCyan)
				else
					logger.Log("No sellable units in inventory.", UI.Colors.textMuted)
				end
			end)
		end, 1)

		UI.CreateButton(manualSellSec, "Sell Equipped Unit", function()
			sellEquippedRF:InvokeServer()
			logger.Log("Sold equipped unit.", UI.Colors.accentCyan)
		end, 2)

		UI.CreateButton(manualSellSec, "Use All Potions in Inventory", function()
			pcall(function()
				if not useBoostRE or not DataController or not DataController.Inventory then return end
				local inv = extractInventory(DataController.Inventory)
				local count = 0
				for _, potionName in ipairs(ALL_POTIONS) do
					local item = inv[potionName]
					if item and (item.amount or 1) > 0 then
						useBoostRE:FireServer(potionName)
						count = count + 1
						logger.Log("Used Potion: " .. potionName, UI.Colors.accentCyan)
						task.wait(0.15)
					end
				end
				if count == 0 then
					logger.Log("No potions found in inventory.", UI.Colors.textMuted)
				end
			end)
		end, 3)

		
		
		
		local function formatChanceCompact(c)
			if not c or c <= 0 then return "1" end
			if NumberFormatter and NumberFormatter.FormatCompact then
				local ok, res = pcall(function() return NumberFormatter.FormatCompact(c) end)
				if ok and res then return string.lower(tostring(res)) end
			end
			local abs = math.abs(c)
			if abs >= 1e24 then
				return string.format("%.1fsp", c / 1e24)
			elseif abs >= 1e21 then
				return string.format("%.1fsx", c / 1e21)
			elseif abs >= 1e18 then
				return string.format("%.1fqi", c / 1e18)
			elseif abs >= 1e15 then
				return string.format("%.1fqd", c / 1e15)
			elseif abs >= 1e12 then
				return string.format("%.1ft", c / 1e12)
			elseif abs >= 1e9 then
				return string.format("%.1fb", c / 1e9)
			elseif abs >= 1e6 then
				return string.format("%.1fm", c / 1e6)
			elseif abs >= 1e3 then
				return string.format("%.1fk", c / 1e3)
			end
			return tostring(math.floor(c))
		end

		local RARITY_RANKS = {
			["Common"] = 1,
			["Uncommon"] = 2,
			["Rare"] = 3,
			["Epic"] = 4,
			["Legendary"] = 5,
			["Mythical"] = 6,
			["Divine"] = 7,
			["Exotic"] = 8,
			["Celestial"] = 9,
			["Secret I"] = 10,
			["Secret II"] = 11,
			["Heavenly"] = 12,
			["Galactic"] = 13,
			["Cosmic"] = 14,
			["Exclusive"] = 15,
			["Haunted"] = 16,
			["Supreme"] = 17
		}

		local function shouldShowRarity(rarityName)
			local min = cfg.backpackEspMinRarity or "All Rarities"
			if min == "All Rarities" then return true end
			local targetRank = 1
			if min == "Rare+" then
				targetRank = 3
			elseif min == "Epic+" then
				targetRank = 4
			elseif min == "Legendary+" then
				targetRank = 5
			elseif min == "Mythical+" then
				targetRank = 6
			elseif min == "Divine+" then
				targetRank = 7
			elseif min == "Secret I+" then
				targetRank = 10
			end
			local rRank = RARITY_RANKS[rarityName] or 1
			return rRank >= targetRank
		end

		local function getBackpackUnitData(slotGui)
			if not slotGui or not slotGui:IsA("ImageButton") or slotGui.Name ~= "EntryTemplate" then
				return nil
			end

			local unitKey = slotGui:GetAttribute("HipHub_UnitKey")
			if not unitKey and getconnections then
				local cons = getconnections(slotGui.Activated)
				if #cons == 0 then
					cons = getconnections(slotGui.MouseButton1Click)
				end
				for _, con in ipairs(cons) do
					local fn = con.Function
					if fn and debug and debug.getupvalues then
						local ups = debug.getupvalues(fn)
						for _, v in pairs(ups) do
							if type(v) == "string" and #v > 25 and string.find(v, "-") then
								unitKey = v
								slotGui:SetAttribute("HipHub_UnitKey", v)
								break
							end
						end
					end
					if unitKey then break end
				end
			end

			local raw = (typeof(DataController) == "function" and DataController()) or
				(DataController and DataController.___X) or {}
			local rawInv = raw.Inventory or
				(DataController and DataController.Inventory and typeof(DataController.Inventory) == "table" and DataController.Inventory) or
				{}

			local unitData = unitKey and rawInv[unitKey]
			return unitData, unitKey
		end

		local function applyBackpackSlotEsp(slotGui)
			if not slotGui or not slotGui:IsA("ImageButton") or slotGui.Name ~= "EntryTemplate" then
				return
			end

			local badge = slotGui:FindFirstChild("HipHub_RarityBadge")
			local originalIncome = slotGui:GetAttribute("HipHub_OriginalIncome")

			if cfg.backpackEspEnabled == false then
				if badge then badge.Visible = false end
				if originalIncome and slotGui:FindFirstChild("BottomLabel") then
					slotGui.BottomLabel.Text = originalIncome
				end
				return
			end

			local unitData, unitKey = getBackpackUnitData(slotGui)
			if not unitData or not UnitConfig or not UnitConfig.entries then
				if badge then badge.Visible = false end
				return
			end

			local entry = UnitConfig.entries[unitData.name]
			local rarityName = (entry and entry.rarity) or "Common"
			if not shouldShowRarity(rarityName) then
				if badge then badge.Visible = false end
				if originalIncome and slotGui:FindFirstChild("BottomLabel") then
					slotGui.BottomLabel.Text = originalIncome
				end
				return
			end

			local chanceNum = nil
			if entry and entry.chance then
				if type(entry.chance) == "function" then
					pcall(function() chanceNum = entry.chance(unitData.attributes or {}) end)
				else
					chanceNum = entry.chance
				end
			end

			local compactChance = chanceNum and formatChanceCompact(chanceNum) or
				(entry and entry.limited and "Limited" or "N/A")
			local fullChanceStr = chanceNum and ("1 in " .. compactChance) or
				(entry and entry.limited and "Limited" or rarityName)
			local slashChanceStr = chanceNum and ("1/" .. compactChance) or
				(entry and entry.limited and "Limited" or rarityName)

			local formatMode = cfg.backpackEspFormat or "Chance (1 in X)"
			local badgeText = fullChanceStr
			if formatMode == "Rarity Name" then
				badgeText = rarityName
			elseif formatMode == "Both (Rarity + Chance)" then
				badgeText = rarityName .. " • " .. slashChanceStr
			elseif formatMode == "Compact Chance (1/X)" then
				badgeText = slashChanceStr
			end

			local posMode = cfg.backpackEspBadgePosition or "Top Pill Badge"

			local bottomLabel = slotGui:FindFirstChild("BottomLabel")
			if bottomLabel then
				if not originalIncome and bottomLabel.Text:find("%$") then
					originalIncome = bottomLabel.Text
					slotGui:SetAttribute("HipHub_OriginalIncome", originalIncome)
				end
			end

			if posMode == "Bottom Label (Replace $/s)" then
				if badge then badge.Visible = false end
				if bottomLabel then
					bottomLabel.Text = badgeText
					bottomLabel.Visible = true
				end
			elseif posMode == "Both (Top Rarity + Bottom 1 in X)" then
				if not badge then
					badge = Instance.new("TextLabel")
					badge.Name = "HipHub_RarityBadge"
					badge.Size = UDim2.new(0.88, 0, 0, 15)
					badge.AnchorPoint = Vector2.new(0.5, 0)
					badge.Position = UDim2.new(0.5, 0, 0, 3)
					badge.BackgroundColor3 = Color3.fromRGB(10, 14, 28)
					badge.BackgroundTransparency = 0.20
					badge.BorderSizePixel = 0
					badge.TextColor3 = Color3.fromRGB(255, 255, 255)
					badge.Font = Enum.Font.GothamBold
					badge.TextSize = 9
					badge.ZIndex = 50
					badge.Parent = slotGui

					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(0, 4)
					corner.Parent = badge

					local stroke = Instance.new("UIStroke")
					stroke.Name = "BadgeStroke"
					stroke.Thickness = 1
					stroke.Transparency = 0.35
					stroke.Color = Color3.fromRGB(0, 200, 255)
					stroke.Parent = badge
				end

				badge.Text = rarityName
				badge.Visible = true

				if bottomLabel then
					bottomLabel.Text = fullChanceStr
					bottomLabel.Visible = true
				end
			else
				
				if not badge then
					badge = Instance.new("TextLabel")
					badge.Name = "HipHub_RarityBadge"
					badge.Size = UDim2.new(0.88, 0, 0, 15)
					badge.AnchorPoint = Vector2.new(0.5, 0)
					badge.Position = UDim2.new(0.5, 0, 0, 3)
					badge.BackgroundColor3 = Color3.fromRGB(10, 14, 28)
					badge.BackgroundTransparency = 0.20
					badge.BorderSizePixel = 0
					badge.TextColor3 = Color3.fromRGB(255, 255, 255)
					badge.Font = Enum.Font.GothamBold
					badge.TextSize = 9
					badge.ZIndex = 50
					badge.Parent = slotGui

					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(0, 4)
					corner.Parent = badge

					local stroke = Instance.new("UIStroke")
					stroke.Name = "BadgeStroke"
					stroke.Thickness = 1
					stroke.Transparency = 0.35
					stroke.Color = Color3.fromRGB(0, 200, 255)
					stroke.Parent = badge
				end

				badge.Text = badgeText
				badge.Visible = true

				if bottomLabel and originalIncome then
					bottomLabel.Text = originalIncome
				end
			end

			
			if badge and badge.Visible and Rarities and Rarities.Get then
				local rarInfo = Rarities.Get(rarityName)
				if rarInfo and rarInfo.gradient then
					local grad = badge:FindFirstChildOfClass("UIGradient")
					if not grad then
						grad = Instance.new("UIGradient")
						grad.Parent = badge
					end
					grad.Color = rarInfo.gradient

					local stroke = badge:FindFirstChild("BadgeStroke")
					if stroke then
						local sGrad = stroke:FindFirstChildOfClass("UIGradient")
						if not sGrad then
							sGrad = Instance.new("UIGradient")
							sGrad.Parent = stroke
						end
						sGrad.Color = rarInfo.gradient
					end
				end
			end

			
			if cfg.backpackEspHighlightRare then
				local rRank = RARITY_RANKS[rarityName] or 1
				if rRank >= 6 then
					local holder = slotGui:FindFirstChild("Holder")
					local mainStroke = holder and holder:FindFirstChild("Stroke")
					if mainStroke then
						mainStroke.Thickness = 1.8
						mainStroke.Transparency = 0.15
					end
				end
			end
		end

		local function refreshAllBackpackSlots()
			pcall(function()
				local p = Players.LocalPlayer
				local root = p and p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("Root")
				local backpack = root and root:FindFirstChild("Menus") and root.Menus:FindFirstChild("Backpack")
				local scroll = backpack and backpack:FindFirstChild("Units") and
					backpack.Units:FindFirstChild("ScrollingFrame")
				if scroll then
					for _, ch in ipairs(scroll:GetChildren()) do
						applyBackpackSlotEsp(ch)
					end
				end
			end)
		end

		
		local espSec = UI.CreateSection(invTab, "Backpack Visuals & Rarity ESP", 5, true)

		Settings.CreateControl("backpackEspEnabled", "CreateToggle", espSec, "Enable Backpack Rarity ESP", (cfg.backpackEspEnabled ~= false), function(v)
			cfg.backpackEspEnabled = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Backpack Rarity ESP enabled.", UI.Colors.successGreen)
			else
				logger.Log("Backpack Rarity ESP disabled.", UI.Colors.textMuted)
			end
			task.spawn(refreshAllBackpackSlots)
		end, 1)

		Settings.CreateControl("backpackEspFormat", "CreateDropdown", espSec, "ESP Display Format", {
			"Chance (1 in X)",
			"Rarity Name",
			"Both (Rarity + Chance)",
			"Compact Chance (1/X)"
		}, cfg.backpackEspFormat or "Chance (1 in X)", function(v)
			cfg.backpackEspFormat = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("ESP Format changed to: " .. tostring(v), UI.Colors.accentCyan)
			task.spawn(refreshAllBackpackSlots)
		end, 2)

		Settings.CreateControl("backpackEspBadgePosition", "CreateDropdown", espSec, "Badge Position & Style", {
			"Top Pill Badge",
			"Bottom Label (Replace $/s)",
			"Both (Top Rarity + Bottom 1 in X)"
		}, cfg.backpackEspBadgePosition or "Top Pill Badge", function(v)
			cfg.backpackEspBadgePosition = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Badge position changed to: " .. tostring(v), UI.Colors.accentCyan)
			task.spawn(refreshAllBackpackSlots)
		end, 3)

		Settings.CreateControl("backpackEspHighlightRare", "CreateToggle", espSec, "Highlight Rare Units (Glow Stroke)", (cfg.backpackEspHighlightRare ~= false),
			function(v)
				cfg.backpackEspHighlightRare = v
				if Settings and Settings.Save then Settings.Save() end
				task.spawn(refreshAllBackpackSlots)
			end, 4)

		Settings.CreateControl("backpackEspShowMutations", "CreateToggle", espSec, "Show Mutation Details", (cfg.backpackEspShowMutations ~= false), function(v)
			cfg.backpackEspShowMutations = v
			if Settings and Settings.Save then Settings.Save() end
			task.spawn(refreshAllBackpackSlots)
		end, 5)

		Settings.CreateControl("backpackEspMinRarity", "CreateDropdown", espSec, "Minimum Rarity to Show", {
			"All Rarities",
			"Rare+",
			"Epic+",
			"Legendary+",
			"Mythical+",
			"Divine+",
			"Secret I+"
		}, cfg.backpackEspMinRarity or "All Rarities", function(v)
			cfg.backpackEspMinRarity = v
			if Settings and Settings.Save then Settings.Save() end
			task.spawn(refreshAllBackpackSlots)
		end, 6)

		UI.CreateButton(espSec, "Refresh Backpack ESP Now", function()
			refreshAllBackpackSlots()
			logger.Log("Backpack ESP visual badges refreshed.", UI.Colors.accentCyan)
		end, 7)

		
		local backpackScrollListener = nil
		local function setupBackpackListener()
			pcall(function()
				local p = Players.LocalPlayer
				local root = p and p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("Root")
				local backpack = root and root:FindFirstChild("Menus") and root.Menus:FindFirstChild("Backpack")
				local scroll = backpack and backpack:FindFirstChild("Units") and
					backpack.Units:FindFirstChild("ScrollingFrame")
				if scroll and not backpackScrollListener then
					backpackScrollListener = scroll.ChildAdded:Connect(function(child)
						if cfg.backpackEspEnabled ~= false then
							task.defer(function()
								task.wait(0.05)
								applyBackpackSlotEsp(child)
							end)
						end
					end)
				end
			end)
		end
		setupBackpackListener()

		task.spawn(function()
			while scriptRunning do
				pcall(function()
					local p = Players.LocalPlayer
					local root = p and p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("Root")
					local backpack = root and root:FindFirstChild("Menus") and root.Menus:FindFirstChild("Backpack")
					if backpack and backpack.Visible then
						setupBackpackListener()
						local scroll = backpack:FindFirstChild("Units") and
							backpack.Units:FindFirstChild("ScrollingFrame")
						if scroll and scroll.Visible then
							for _, ch in ipairs(scroll:GetChildren()) do
								if ch:IsA("ImageButton") and ch.Name == "EntryTemplate" then
									applyBackpackSlotEsp(ch)
								end
							end
						end
					end
				end)
				task.wait(0.5)
			end
		end)

		local function getOwnedGears()
			local owned = {}
			pcall(function()
				if not DataController or not DataController.Inventory then return end
				local inv = DataController.Inventory()
				if type(inv) ~= "table" then return end
				for k, v in pairs(inv) do
					local gName = (type(v) == "table" and v.name) or k
					local count = (type(v) == "table" and (v.amount or 1)) or 1
					if GEAR_TO_SLOT[gName] and count > 0 then
						owned[gName] = count
					end
				end
			end)
			return owned
		end

		local function getCurrentlyEquippedGears()
			local eq = {}
			pcall(function()
				if DataController and DataController.___X and DataController.___X.EquippedGear then
					for slotName, gearName in pairs(DataController.___X.EquippedGear) do
						if gearName and gearName ~= "" then
							eq[slotName] = gearName
						end
					end
				end
				if not DataController or not DataController.EquippedGear then return end
				for slotName, _ in pairs(GEAR_SLOTS) do
					if not eq[slotName] then
						local valFunc = DataController.EquippedGear[slotName]
						local cur = nil
						if type(valFunc) == "table" and type(getmetatable(valFunc)) == "table" and getmetatable(valFunc).__call then
							cur = valFunc()
						elseif type(valFunc) == "function" then
							cur = valFunc()
						elseif type(valFunc) == "table" and valFunc.Get then
							cur = valFunc:Get()
						end
						if cur and cur ~= "" then
							eq[slotName] = cur
						end
					end
				end
			end)
			return eq
		end

		local function equipGear(slotName, gearName)
			local ok = false
			if gearSignal then
				pcall(function()
					gearSignal:Fire(slotName, gearName)
					ok = true
				end)
			end
			if not ok and equipGearRE then
				pcall(function()
					equipGearRE:FireServer(slotName, gearName)
					ok = true
				end)
			end
			return ok
		end

		local function equipBestGearsByStrategy(strat)
			local strategy = strat or cfg.gearStrategy or "Luck Focus"
			local scores = GEAR_SCORES[strategy] or GEAR_SCORES["Luck Focus"]
			local owned = getOwnedGears()
			local currentlyEquipped = getCurrentlyEquippedGears()
			local equippedCount = 0

			for slotName, gearList in pairs(GEAR_SLOTS) do
				local bestGear = nil
				local highestScore = -1
				for _, gName in ipairs(gearList) do
					if owned[gName] then
						local score = scores[gName] or 0
						if score > highestScore then
							highestScore = score
							bestGear = gName
						end
					end
				end
				if bestGear and currentlyEquipped[slotName] ~= bestGear then
					equipGear(slotName, bestGear)
					equippedCount = equippedCount + 1
					task.wait(0.15)
				end
			end
			return equippedCount
		end

		local function equipSelectedCustomGears()
			local owned = getOwnedGears()
			local currentlyEquipped = getCurrentlyEquippedGears()
			local count = 0
			for gName, isSel in pairs(cfg.selectedCustomGears or {}) do
				local slotName = GEAR_TO_SLOT[gName]
				if isSel and owned[gName] and slotName then
					if currentlyEquipped[slotName] ~= gName then
						equipGear(slotName, gName)
						count = count + 1
						task.wait(0.15)
					end
				end
			end
			return count
		end

		
		local gearSec = UI.CreateSection(invTab, "Gear Management & Auto Equip", 6, true)

		Settings.CreateControl("autoEquipBestGears", "CreateToggle", gearSec, "Auto Equip Best Gear", cfg.autoEquipBestGears, function(v)
			cfg.autoEquipBestGears = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Equip Best Gear enabled (" .. tostring(cfg.gearStrategy or "Luck Focus") .. ").",
					UI.Colors.successGreen)
			end
		end, 1)

		Settings.CreateControl("gearStrategy", "CreateDropdown", gearSec, "Gear Optimization Strategy",
			{ "Luck Focus", "Money Focus", "Damage Focus", "Grade/Trait Focus", "Highest Tier" },
			cfg.gearStrategy or "Luck Focus", function(v)
				cfg.gearStrategy = v
				if Settings and Settings.Save then Settings.Save() end
				logger.Log("Gear Strategy set to: " .. tostring(v), UI.Colors.accentCyan)
			end, 2)

		Settings.CreateControl("selectedCustomGears", "CreateMultiDropdown", gearSec, "Select Custom Gears to Equip", ALL_GEARS, cfg.selectedCustomGears or {
			["Obita's Mask"] = true,
			["Mazun's Coat"] = true,
			["Enol's Drums"] = true,
			["Sakuna's Sash"] = true,
			["Angel's Halo"] = true
		}, function(newMap)
			cfg.selectedCustomGears = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		UI.CreateButton(gearSec, "Equip Best Gears Now", function()
			pcall(function()
				local count = equipBestGearsByStrategy()
				if count and count > 0 then
					logger.Log(
						string.format("Equipped %d best gear(s) for strategy '%s'!", count,
							cfg.gearStrategy or "Luck Focus"),
						UI.Colors.successGreen)
					if UI.Notify then
						UI.Notify("Gears Equipped",
							string.format("Equipped %d best gears (%s)", count, cfg.gearStrategy or "Luck Focus"),
							UI.Colors.successGreen, 3)
					end
				else
					logger.Log("No owned gears found in bag to equip.", UI.Colors.textMuted)
				end
			end)
		end, 4)

		UI.CreateButton(gearSec, "Equip Custom Selected Gears", function()
			pcall(function()
				local count = equipSelectedCustomGears()
				if count and count > 0 then
					logger.Log(string.format("Equipped %d custom selected gear(s)!", count), UI.Colors.successGreen)
					if UI.Notify then
						UI.Notify("Gears Equipped", string.format("Equipped %d custom gears", count),
							UI.Colors.successGreen, 3)
					end
				else
					logger.Log("No owned selected gears found in bag.", UI.Colors.textMuted)
				end
			end)
		end, 5)

		
		task.spawn(function()
			while true do
				if cfg.autoEquipBestGears and (gearSignal or equipGearRE) and DataController and DataController.Inventory then
					pcall(function()
						equipBestGearsByStrategy()
					end)
				end
				task.wait(10.0)
			end
		end)

		
		task.spawn(function()
			while true do
				if cfg.autoUsePotions and useBoostRE and DataController and DataController.Inventory then
					pcall(function()
						local inv = extractInventory(DataController.Inventory)
						local active = (DataController.ActiveEntries and DataController.ActiveEntries()) or {}
						local serverTime = workspace:GetServerTimeNow()

						for potionName, isSelected in pairs(cfg.selectedPotions or {}) do
							if isSelected == true then
								local itemData = inv[potionName]
								local count = itemData and (itemData.amount or 1) or 0

								if count > 0 then
									local shouldUse = true
									if cfg.potionOnlyWhenExpired then
										local act = active[potionName]
										if act then
											if typeof(act) == "number" and act > 1 then
												shouldUse = false
											elseif typeof(act) == "table" then
												if typeof(act.remaining) == "number" then
													if act.startedAt and typeof(act.startedAt) == "number" then
														local timeLeft = act.remaining - (serverTime - act.startedAt)
														if timeLeft > 1 then
															shouldUse = false
														end
													elseif act.remaining > 1 then
														shouldUse = false
													end
												end
											end
										end
									end

									if shouldUse then
										useBoostRE:FireServer(potionName)
										logger.Log(
											string.format("Auto Used %s (Left: %d)", potionName, math.max(0, count - 1)),
											UI.Colors.accentCyan)
										task.wait(0.15)
									end
								end
							end
						end
					end)
				end
				local interval = math.max(1, tonumber(cfg.potionInterval) or 5)
				task.wait(interval)
			end
		end)

		
		task.spawn(function()
			while true do
				local autoSellActive = (cfg.autoSell == true or cfg.autoSellCustom == true or cfg.autoSellByRarity == true or cfg.autoSellByChance == true)
				local autoLockActive = (cfg.autoLockRare == true or cfg.autoLockCustom == true or cfg.autoLockMutated == true)

				if (autoSellActive or autoLockActive) and DataController and DataController.Inventory then
					pcall(function()
						local inv = extractInventory(DataController.Inventory)
						local toSellKeys = {}

						for key, unit in pairs(inv) do
							if typeof(unit) == "table" and unit.name and isUnitEntry(key, unit) then
								local unitName = unit.name
								local attributes = unit.attributes or {}
								local isLocked = isUnitLocked(key, unit)
								local mutation = attributes.mutation

								
								if not isLocked and autoLockActive then
									local shouldLock = false
									local lockReason = ""

									
									if cfg.autoLockMutated and mutation then
										local mode = cfg.autoLockMutatedMode or "By Money/s"
										local meetsMoney = false
										local meetsRarity = false

										if mode == "All Mutated" then
											shouldLock = true
											lockReason = string.format("Mutation (%s)", tostring(mutation))
										else
											if mode == "By Money/s" or mode == "Money/s OR Rarity" or mode == "Money/s AND Rarity" then
												local unitIncome = getUnitIncome(unitName, attributes)
												local thresholdVal = parseMoneyValue(cfg.autoLockMutatedThreshold or "1")
												local cond = cfg.autoLockMutatedCondition or "Above (>=)"
												if cond == "Above (>=)" and unitIncome >= thresholdVal then
													meetsMoney = true
												elseif cond == "Below (<=)" and unitIncome <= thresholdVal then
													meetsMoney = true
												end
											end

											if mode == "By Rarity Tier" or mode == "Money/s OR Rarity" or mode == "Money/s AND Rarity" then
												if Rarities and unitName then
													local configModule = require(Features.Inventory.EntryRegistry)
														.getEntryConfig(unitName)
													if configModule and configModule.getRarity then
														local r = configModule.getRarity(attributes)
														local targetMap = cfg.mutatedLockRarities or cfg.lockRarities
														if targetMap and targetMap[r] == true then
															meetsRarity = true
														end
													end
												end
											end

											if mode == "By Money/s" and meetsMoney then
												shouldLock = true
												lockReason = string.format("Mutated (%s) - Money $%s/s",
													tostring(mutation), formatNumber(getUnitIncome(unitName, attributes)))
											elseif mode == "By Rarity Tier" and meetsRarity then
												shouldLock = true
												lockReason = string.format("Mutated (%s) - Rarity Tier",
													tostring(mutation))
											elseif mode == "Money/s OR Rarity" and (meetsMoney or meetsRarity) then
												shouldLock = true
												lockReason = string.format("Mutated (%s) - Filter Match",
													tostring(mutation))
											elseif mode == "Money/s AND Rarity" and (meetsMoney and meetsRarity) then
												shouldLock = true
												lockReason = string.format("Mutated (%s) - Rarity & Money Match",
													tostring(mutation))
											end
										end
									end

									
									if not shouldLock and cfg.autoLockCustom then
										local unitIncome = getUnitIncome(unitName, attributes)
										local thresholdVal = parseMoneyValue(cfg.autoLockThreshold or "1")
										local mode = cfg.autoLockMode or "Above (>=)"

										if mode == "Above (>=)" and unitIncome >= thresholdVal then
											shouldLock = true
											lockReason = string.format("Money $%s/s >= %s", formatNumber(unitIncome),
												tostring(cfg.autoLockThreshold))
										elseif mode == "Below (<=)" and unitIncome <= thresholdVal then
											shouldLock = true
											lockReason = string.format("Money $%s/s <= %s", formatNumber(unitIncome),
												tostring(cfg.autoLockThreshold))
										end
									end

									
									if not shouldLock and cfg.autoLockRare and Rarities and unitName then
										local configModule = require(Features.Inventory.EntryRegistry).getEntryConfig(
											unitName)
										if configModule and configModule.getRarity then
											local r = configModule.getRarity(attributes)
											if cfg.lockRarities and cfg.lockRarities[r] == true then
												shouldLock = true
												lockReason = string.format("Tier %s", tostring(r))
											end
										end
									end

									if shouldLock then
										setLockedRE:FireServer({ [tostring(key)] = true })
										logger.Log(string.format("Auto Locked: %s [%s]", tostring(unitName), lockReason),
											UI.Colors.accentViolet)
										isLocked = true
									end
								end

								
								if autoSellActive and not isLocked then
									local shouldSell = false

									
									if not shouldSell and cfg.autoSellByChance then
										local unitChance = getUnitChance(unitName, attributes)
										local thresholdVal = parseChance(cfg.autoSellChanceThreshold or "1 in 10sx")
										local mode = cfg.autoSellChanceMode or "Below (<=)"

										if mode == "Below (<=)" and unitChance <= thresholdVal then
											shouldSell = true
										elseif mode == "Above (>=)" and unitChance >= thresholdVal then
											shouldSell = true
										end
									end

									
									if not shouldSell and cfg.autoSellCustom then
										local unitIncome = getUnitIncome(unitName, attributes)
										local thresholdVal = parseMoneyValue(cfg.autoSellThreshold or "0.1")
										local mode = cfg.autoSellMode or "Below (<=)"

										if mode == "Below (<=)" and unitIncome <= thresholdVal then
											shouldSell = true
										elseif mode == "Above (>=)" and unitIncome >= thresholdVal then
											shouldSell = true
										end
									end

									
									if not shouldSell and cfg.autoSellByRarity then
										local configModule = require(Features.Inventory.EntryRegistry).getEntryConfig(
											unitName)
										if configModule and configModule.getRarity then
											local r = configModule.getRarity(attributes)
											if cfg.sellRarities and cfg.sellRarities[r] == true then
												shouldSell = true
											end
										end
									end

									if shouldSell then
										table.insert(toSellKeys, key)
									end
								end
							end
						end

						if #toSellKeys > 0 then
							sellInventoryRF:InvokeServer(toSellKeys)
							logger.Log(string.format("Auto Sold %d matching units.", #toSellKeys),
								UI.Colors.textSecondary)
						end
					end)
				end
				task.wait(2.0)
			end
		end)
	end

	
	
	
	do
		local unitTab = UI.Tabs.Upgrades or UI.Tabs.Units

		
		local function getInventoryUnitsList()
			local inv = extractInventory(DataController and DataController.Inventory)
			local unitLabels = {}
			local unitMap = {} 
			local keyToLabel = {}

			for k, v in pairs(inv) do
				if isUnitEntry(k, v) then
					local kStr = tostring(k)
					local currentGrade = (v.attributes and v.attributes.grade) or "None"
					local currentTrait = (v.attributes and v.attributes.trait) or "None"
					local currentQuirk = (v.attributes and v.attributes.quirk) or "None"
					local mutationStr = (v.attributes and v.attributes.mutation and (" | " .. v.attributes.mutation)) or
						""
					local shortKey = string.sub(kStr, -6)
					local label = string.format("[%s] %s [Grade: %s | Trait: %s | Quirk: %s%s]", shortKey, v.name,
						currentGrade, currentTrait, currentQuirk,
						mutationStr)
					table.insert(unitLabels, label)
					unitMap[label] = kStr
					keyToLabel[kStr] = label
				end
			end

			if #unitLabels == 0 then
				table.insert(unitLabels, "No Units In Inventory")
				unitMap["No Units In Inventory"] = nil
			end

			return unitLabels, unitMap, keyToLabel
		end

		local initialUnitLabels, initialUnitMap, keyToLabel = getInventoryUnitsList()
		local selectedUnitLabel = keyToLabel[cfg.selectedRollUnitKey] or initialUnitLabels[1]
		if not cfg.selectedRollUnitKey or cfg.selectedRollUnitKey == "" then
			cfg.selectedRollUnitKey = initialUnitMap[selectedUnitLabel] or ""
		end

		local function getActiveRollUnitKey()
			if cfg.rollUnitSource == "Equipped Unit" then
				local ok, eqController = pcall(function()
					return require(Features.Inventory.Kinds.Unit.UnitController)
				end)
				if ok and eqController and eqController.EquippedUnit then
					local eq = eqController.EquippedUnit()
					if eq then return tostring(eq) end
				end
			end
			
			if cfg.selectedRollUnitKey and cfg.selectedRollUnitKey ~= "" then
				local inv = extractInventory(DataController and DataController.Inventory)
				if inv[cfg.selectedRollUnitKey] then
					return cfg.selectedRollUnitKey
				end
			end
			
			local ok, raw = pcall(function()
				return typeof(DataController) == "function" and DataController() or
					(DataController and DataController.___X)
			end)
			if ok and raw and raw.Slots and (raw.Slots["1"] or raw.Slots[1]) then
				local s1 = raw.Slots["1"] or raw.Slots[1]
				if s1 and s1.unitId then
					cfg.selectedRollUnitKey = tostring(s1.unitId)
					return cfg.selectedRollUnitKey
				end
			end
			
			local labels, map = getInventoryUnitsList()
			if labels[1] and map[labels[1]] then
				cfg.selectedRollUnitKey = map[labels[1]]
				return cfg.selectedRollUnitKey
			end
			return nil
		end

		local function getAllPlotEquippedUnitKeys()
			local keys = {}
			local seen = {}
			pcall(function()
				local raw = typeof(DataController) == "function" and DataController() or
					(DataController and DataController.___X)
				if raw and raw.Slots then
					for slotId, sData in pairs(raw.Slots) do
						if sData and sData.unitId and not seen[tostring(sData.unitId)] then
							seen[tostring(sData.unitId)] = true
							table.insert(keys, tostring(sData.unitId))
						end
					end
				end
			end)
			return keys
		end

		local function getTargetUnitKeysList()
			local source = cfg.rollUnitSource or "All Units (Plot + Bag)"
			local keys = {}
			local seen = {}

			if source == "All Units (Plot + Bag)" or source == "All Units" then
				local plotKeys = getAllPlotEquippedUnitKeys()
				for _, pKey in ipairs(plotKeys) do
					if not seen[pKey] then
						seen[pKey] = true
						table.insert(keys, pKey)
					end
				end
				local inv = extractInventory(DataController and DataController.Inventory)
				for k, v in pairs(inv) do
					if isUnitEntry(k, v) and not seen[tostring(k)] then
						seen[tostring(k)] = true
						table.insert(keys, tostring(k))
					end
				end
				return keys
			elseif source == "All Plot-Equipped Units" or source == "Equipped Unit" then
				return getAllPlotEquippedUnitKeys()
			elseif source == "All Bag Units" then
				local inv = extractInventory(DataController and DataController.Inventory)
				for k, v in pairs(inv) do
					if isUnitEntry(k, v) and not seen[tostring(k)] then
						seen[tostring(k)] = true
						table.insert(keys, tostring(k))
					end
				end
				return keys
			elseif source == "Single Selected Unit" or source == "Selected Inventory Unit" then
				local singleKey = getActiveRollUnitKey()
				if singleKey then table.insert(keys, singleKey) end
				return keys
			else
				
				if cfg.bulkSelectedUnits and type(cfg.bulkSelectedUnits) == "table" then
					for k, isSelected in pairs(cfg.bulkSelectedUnits) do
						if isSelected == true and not seen[tostring(k)] then
							seen[tostring(k)] = true
							table.insert(keys, tostring(k))
						end
					end
				end
				if #keys == 0 then
					local singleKey = getActiveRollUnitKey()
					if singleKey then table.insert(keys, singleKey) end
				end
				return keys
			end
		end

		local autoRollTraitToggle
		local autoRollGradeToggle
		local autoRollQuirkToggle
		local autoRollBothToggle
		local autoRollAllToggle
		local singleUnitDropdown
		local bulkUnitDropdown
		local rollSourceDropdown

		local function refreshUnitDropdownList()
			pcall(function()
				local labels, map, k2l = getInventoryUnitsList()
				initialUnitLabels = labels
				initialUnitMap = map
				keyToLabel = k2l
				local curLabel = k2l[cfg.selectedRollUnitKey] or labels[1]
				if singleUnitDropdown and singleUnitDropdown.Refresh then
					singleUnitDropdown.Refresh(labels, curLabel)
				end
				if bulkUnitDropdown and bulkUnitDropdown.Refresh then
					local bulkLabelMap = {}
					if cfg.bulkSelectedUnits and type(cfg.bulkSelectedUnits) == "table" then
						for uKey, isSel in pairs(cfg.bulkSelectedUnits) do
							if isSel and k2l[uKey] then
								bulkLabelMap[k2l[uKey]] = true
							end
						end
					end
					bulkUnitDropdown.Refresh(labels, bulkLabelMap)
				end
			end)
		end

		local function getUnitsSignature()
			local inv = extractInventory(DataController and DataController.Inventory)
			local sigParts = {}
			for k, v in pairs(inv) do
				if isUnitEntry(k, v) then
					local g = (v.attributes and v.attributes.grade) or "-"
					local t = (v.attributes and v.attributes.trait) or "-"
					local q = (v.attributes and v.attributes.quirk) or "-"
					local m = (v.attributes and v.attributes.mutation) or "-"
					table.insert(sigParts, tostring(k) .. ":" .. g .. ":" .. t .. ":" .. q .. ":" .. m)
				end
			end
			table.sort(sigParts)
			return table.concat(sigParts, "|")
		end

		
		task.spawn(function()
			local lastSig = getUnitsSignature()
			while scriptRunning do
				task.wait(1.5)
				pcall(function()
					if DataController then
						local curSig = getUnitsSignature()
						if curSig ~= "" and curSig ~= lastSig then
							lastSig = curSig
							refreshUnitDropdownList()
						end
					end
				end)
			end
		end)

		
		local selectSec = UI.CreateSection(unitTab, "Target Unit Selection (Bulk / Single)", 3, true)

		rollSourceDropdown = Settings.CreateControl("rollUnitSource", "CreateDropdown", selectSec, "Roll Unit Source",
			{ "All Units (Plot + Bag)", "Bulk Selected Units", "Single Selected Unit", "All Plot-Equipped Units",
				"All Bag Units" },
			cfg.rollUnitSource or "All Units (Plot + Bag)", function(v)
				cfg.rollUnitSource = v
				if Settings and Settings.Save then Settings.Save() end
				logger.Log("Roll Target Unit Source set to: " .. tostring(v), UI.Colors.accentCyan)
			end, 1)

		local initialBulkLabelMap = {}
		if cfg.bulkSelectedUnits and type(cfg.bulkSelectedUnits) == "table" then
			for uKey, isSel in pairs(cfg.bulkSelectedUnits) do
				if isSel and keyToLabel[uKey] then
					initialBulkLabelMap[keyToLabel[uKey]] = true
				end
			end
		end

		bulkUnitDropdown = UI.CreateMultiDropdown(selectSec, "Select Units to Roll (Bulk)", initialUnitLabels,
			initialBulkLabelMap,
			function(selectedLabelMap)
				cfg.bulkSelectedUnits = {}
				for label, isSel in pairs(selectedLabelMap) do
					if isSel and initialUnitMap[label] then
						cfg.bulkSelectedUnits[initialUnitMap[label]] = true
					end
				end
				cfg.rollUnitSource = "Bulk Selected Units"
				if rollSourceDropdown and rollSourceDropdown.Set then
					rollSourceDropdown.Set("Bulk Selected Units")
				end
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		singleUnitDropdown = UI.CreateDropdown(selectSec, "Select Single Unit to Roll", initialUnitLabels,
			selectedUnitLabel,
			function(v)
				local key = initialUnitMap[v]
				if key then
					cfg.selectedRollUnitKey = key
					if Settings and Settings.Save then Settings.Save() end
					logger.Log("Selected single unit for rolling: " .. tostring(v), UI.Colors.accentCyan)
				end
			end, 3)

		UI.CreateButton(selectSec, "Select All Units (Plot + Bag)", function()
			local plotKeys = getAllPlotEquippedUnitKeys()
			local inv = extractInventory(DataController and DataController.Inventory)
			cfg.bulkSelectedUnits = {}
			local labelMap = {}
			local totalCount = 0
			for _, pKey in ipairs(plotKeys) do
				cfg.bulkSelectedUnits[pKey] = true
				totalCount = totalCount + 1
				if keyToLabel[pKey] then
					labelMap[keyToLabel[pKey]] = true
				end
			end
			for k, v in pairs(inv) do
				if isUnitEntry(k, v) then
					local uKey = tostring(k)
					if not cfg.bulkSelectedUnits[uKey] then
						cfg.bulkSelectedUnits[uKey] = true
						totalCount = totalCount + 1
						if keyToLabel[uKey] then
							labelMap[keyToLabel[uKey]] = true
						end
					end
				end
			end
			cfg.rollUnitSource = "All Units (Plot + Bag)"
			if rollSourceDropdown and rollSourceDropdown.Set then
				rollSourceDropdown.Set("All Units (Plot + Bag)")
			end
			if bulkUnitDropdown and bulkUnitDropdown.Set then
				bulkUnitDropdown.Set(labelMap)
			end
			if Settings and Settings.Save then Settings.Save() end
			logger.Log(string.format("Selected all %d units (plot + bag) for bulk rolling.", totalCount),
				UI.Colors.successGreen)
		end, 4)

		UI.CreateButton(selectSec, "Select All Plot-Equipped Units", function()
			local plotKeys = getAllPlotEquippedUnitKeys()
			cfg.bulkSelectedUnits = {}
			local labelMap = {}
			for _, pKey in ipairs(plotKeys) do
				cfg.bulkSelectedUnits[pKey] = true
				if keyToLabel[pKey] then
					labelMap[keyToLabel[pKey]] = true
				end
			end
			cfg.rollUnitSource = "Bulk Selected Units"
			if rollSourceDropdown and rollSourceDropdown.Set then
				rollSourceDropdown.Set("Bulk Selected Units")
			end
			if bulkUnitDropdown and bulkUnitDropdown.Set then
				bulkUnitDropdown.Set(labelMap)
			end
			if Settings and Settings.Save then Settings.Save() end
			logger.Log(string.format("Selected all %d plot-equipped unit(s) for bulk rolling.", #plotKeys),
				UI.Colors.successGreen)
		end, 5)

		UI.CreateButton(selectSec, "Select All Bag Units", function()
			local inv = extractInventory(DataController and DataController.Inventory)
			cfg.bulkSelectedUnits = {}
			local labelMap = {}
			local count = 0
			for k, v in pairs(inv) do
				if isUnitEntry(k, v) then
					local uKey = tostring(k)
					cfg.bulkSelectedUnits[uKey] = true
					count = count + 1
					if keyToLabel[uKey] then
						labelMap[keyToLabel[uKey]] = true
					end
				end
			end
			cfg.rollUnitSource = "Bulk Selected Units"
			if rollSourceDropdown and rollSourceDropdown.Set then
				rollSourceDropdown.Set("Bulk Selected Units")
			end
			if bulkUnitDropdown and bulkUnitDropdown.Set then
				bulkUnitDropdown.Set(labelMap)
			end
			if Settings and Settings.Save then Settings.Save() end
			logger.Log(string.format("Selected all %d bag unit(s) for bulk rolling.", count), UI.Colors.successGreen)
		end, 6)

		UI.CreateButton(selectSec, "Clear Selected Units", function()
			cfg.bulkSelectedUnits = {}
			if bulkUnitDropdown and bulkUnitDropdown.Set then
				bulkUnitDropdown.Set({})
			end
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Cleared bulk unit selection.", UI.Colors.textMuted)
		end, 7)

		UI.CreateButton(selectSec, "Refresh Inventory Units List", function()
			refreshUnitDropdownList()
			logger.Log(string.format("Refreshed units list (%d units found).", #initialUnitLabels), UI.Colors.accentCyan)
		end, 8)

		
		local traitSec = UI.CreateSection(unitTab, "Trait Rolling", 4, true)

		autoRollTraitToggle = Settings.CreateControl("autoRollTrait", "CreateToggle", traitSec, "Auto Roll Trait (Bulk / Active)", cfg.autoRollTrait, function(v)
			cfg.autoRollTrait = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Trait roller active (Rolling until target traits hit across selected units).",
					UI.Colors.successGreen)
			end
		end, 1)

		local defaultTraitMap = cfg.targetTraits or { [cfg.targetTrait or "Paradox"] = true }
		Settings.CreateControl("targetTraits", "CreateMultiDropdown", traitSec, "Target Traits to Stop On", ALL_TRAITS, defaultTraitMap, function(newMap)
			cfg.targetTraits = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 2)
		local function doRollTrait(targetKey)
			pcall(function()
				local pGui = player:FindFirstChild("PlayerGui")
				if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Traits") then
					local confirm = pGui.Root.Menus.Traits:FindFirstChild("ConfirmTrait")
					if confirm and confirm.Visible then
						confirm.Visible = false
					end
				end
			end)
			rollTraitRE:FireServer(targetKey, true)
		end

		local function doRollGrade(targetKey)
			pcall(function()
				local pGui = player:FindFirstChild("PlayerGui")
				if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Grades") then
					local confirm = pGui.Root.Menus.Grades:FindFirstChild("ConfirmGrade")
					if confirm and confirm.Visible then
						confirm.Visible = false
					end
				end
			end)
			rollGradeRE:FireServer(targetKey, true)
		end

		local QuirkUtil = nil
		pcall(function()
			QuirkUtil = require(Features.Quirks.QuirkUtil)
		end)

		local function getQuirkRollCost(unitData)
			if QuirkUtil and QuirkUtil.GetRollCost and unitData and unitData.name then
				local ok, c = pcall(function()
					return QuirkUtil.GetRollCost(unitData.name, unitData.attributes)
				end)
				if ok and tonumber(c) then return tonumber(c) end
			end
			return 1000
		end

		local function doRollQuirk(targetKey)
			pcall(function()
				local pGui = player:FindFirstChild("PlayerGui")
				if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Quirks") then
					local confirm = pGui.Root.Menus.Quirks:FindFirstChild("ConfirmQuirk")
					if confirm and confirm.Visible then
						confirm.Visible = false
					end
				end
			end)
			if rollQuirkRE then
				rollQuirkRE:FireServer(targetKey, true)
			end
		end

		UI.CreateButton(traitSec, "Roll Trait Once (Active Unit)", function()
			local targetKeys = getTargetUnitKeysList()
			local targetKey = targetKeys[1] or getActiveRollUnitKey()
			if targetKey then
				doRollTrait(targetKey)
				logger.Log("Fired single trait roll on active unit.", UI.Colors.accentCyan)
				task.delay(0.2, refreshUnitDropdownList)
			else
				logger.Log("No valid unit selected/equipped for trait roll.", UI.Colors.textMuted)
			end
		end, 3)

		
		local gradeSec = UI.CreateSection(unitTab, "Grade Rolling", 5, true)

		autoRollGradeToggle = Settings.CreateControl("autoRollGrade", "CreateToggle", gradeSec, "Auto Roll Grade (Bulk / Active)", cfg.autoRollGrade, function(v)
			cfg.autoRollGrade = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Grade roller active (Rolling until target grades hit across selected units).",
					UI.Colors.successGreen)
			end
		end, 1)

		local defaultGradeMap = cfg.targetGrades or { [cfg.targetGrade or "Ω"] = true }
		Settings.CreateControl("targetGrades", "CreateMultiDropdown", gradeSec, "Target Grades to Stop On", ALL_GRADES, defaultGradeMap, function(newMap)
			cfg.targetGrades = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		UI.CreateButton(gradeSec, "Roll Grade Once (Active Unit)", function()
			local targetKeys = getTargetUnitKeysList()
			local targetKey = targetKeys[1] or getActiveRollUnitKey()
			if targetKey then
				doRollGrade(targetKey)
				logger.Log("Fired single grade roll on active unit.", UI.Colors.accentCyan)
				task.delay(0.2, refreshUnitDropdownList)
			else
				logger.Log("No valid unit selected/equipped for grade roll.", UI.Colors.textMuted)
			end
		end, 3)

		
		local quirkSec = UI.CreateSection(unitTab, "Quirk Rolling (UPD 7)", 6, true)

		autoRollQuirkToggle = Settings.CreateControl("autoRollQuirk", "CreateToggle", quirkSec, "Auto Roll Quirk (Bulk / Active)", cfg.autoRollQuirk, function(v)
			cfg.autoRollQuirk = v
			if Settings and Settings.Save then Settings.Save() end
			if v then
				logger.Log("Auto Quirk roller active (Rolling until target quirks hit across selected units).",
					UI.Colors.successGreen)
			end
		end, 1)

		local defaultQuirkMap = cfg.targetQuirks or
			{ ["Sovereign"] = true, ["Fortune's Favor"] = true, ["Midas Touch"] = true, ["Tycoon"] = true, ["Prodigy"] = true }
		Settings.CreateControl("targetQuirks", "CreateMultiDropdown", quirkSec, "Target Quirks to Stop On", ALL_QUIRKS, defaultQuirkMap, function(newMap)
			cfg.targetQuirks = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		UI.CreateButton(quirkSec, "Roll Quirk Once (Active Unit)", function()
			local targetKeys = getTargetUnitKeysList()
			local targetKey = targetKeys[1] or getActiveRollUnitKey()
			if targetKey then
				doRollQuirk(targetKey)
				logger.Log("Fired single quirk roll on active unit.", UI.Colors.accentCyan)
				task.delay(0.2, refreshUnitDropdownList)
			else
				logger.Log("No valid unit selected/equipped for quirk roll.", UI.Colors.textMuted)
			end
		end, 3)

		Settings.CreateControl("autoProtectQuirks", "CreateToggle", quirkSec, "Auto Protect Target Quirks In-Game", (cfg.autoProtectQuirks ~= false), function(v)
			cfg.autoProtectQuirks = v
			if Settings and Settings.Save then Settings.Save() end
		end, 4)

		
		local combinedSec = UI.CreateSection(unitTab, "Combined Auto Rolling", 7, true)

		autoRollBothToggle = Settings.CreateControl("bulkAutoRollBoth", "CreateToggle", combinedSec, "Auto Roll Both (Trait + Grade) Per Unit", cfg
			.bulkAutoRollBoth, function(v)
				cfg.bulkAutoRollBoth = v
				if v then
					cfg.autoRollTrait = true
					cfg.autoRollGrade = true
					if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(true) end
					if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(true) end
					logger.Log("Combined Auto Trait + Grade active! Rolling both per unit until satisfied.",
						UI.Colors.successGreen)
				else
					cfg.autoRollTrait = false
					cfg.autoRollGrade = false
					if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(false) end
					if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(false) end
					logger.Log("Combined Auto Trait + Grade disabled.", UI.Colors.textMuted)
				end
				if Settings and Settings.Save then Settings.Save() end
			end, 1)

		autoRollAllToggle = Settings.CreateControl("bulkAutoRollAll", "CreateToggle", combinedSec, "Auto Roll ALL THREE (Trait + Grade + Quirk)",
			cfg.bulkAutoRollAll, function(v)
				cfg.bulkAutoRollAll = v
				if v then
					cfg.autoRollTrait = true
					cfg.autoRollGrade = true
					cfg.autoRollQuirk = true
					if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(true) end
					if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(true) end
					if autoRollQuirkToggle and autoRollQuirkToggle.Set then autoRollQuirkToggle.Set(true) end
					logger.Log("TRIPLE ROLLER ACTIVE! Rolling Trait, Grade, and Quirk until all satisfied.",
						UI.Colors.successGreen)
				else
					cfg.autoRollTrait = false
					cfg.autoRollGrade = false
					cfg.autoRollQuirk = false
					if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(false) end
					if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(false) end
					if autoRollQuirkToggle and autoRollQuirkToggle.Set then autoRollQuirkToggle.Set(false) end
					logger.Log("Triple Roller disabled.", UI.Colors.textMuted)
				end
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		Settings.CreateControl("rollDelayTraitGrade", "CreateSlider", combinedSec, "Roll Delay (Seconds)", 0.05, 1.0, cfg.rollDelayTraitGrade or 0.25, function(v)
			cfg.rollDelayTraitGrade = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3, "s")

		
		local fuseSec = UI.CreateSection(unitTab, "Auto Fuse Units", 8, true)

		local autoFuseToggle = Settings.CreateControl("autoFuse", "CreateToggle", fuseSec, "Auto Fuse Units", cfg.autoFuse, function(v)
			cfg.autoFuse = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Fuse engine active.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("autoFuseByRarity", "CreateToggle", fuseSec, "Fuse by Rarity Tier", cfg.autoFuseByRarity, function(v)
			cfg.autoFuseByRarity = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		Settings.CreateControl("autoFuseRarities", "CreateMultiDropdown", fuseSec, "Rarities to Fuse", ALL_RARITIES, cfg.autoFuseRarities or {
			Common = true,
			Uncommon = true,
			Rare = true,
			Epic = true,
			Legendary = true,
			Mythical = true,
			Divine = false,
			Exotic = false,
			Celestial = false,
			["Secret I"] = false,
			["Secret II"] = false,
			Heavenly = false,
			Exclusive = false
		}, function(newMap)
			cfg.autoFuseRarities = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		Settings.CreateControl("autoFuseByChance", "CreateToggle", fuseSec, "Fuse by Chance (1 in X)", cfg.autoFuseByChance, function(v)
			cfg.autoFuseByChance = v
			if Settings and Settings.Save then Settings.Save() end
		end, 4)

		Settings.CreateControl("autoFuseChanceMode", "CreateDropdown", fuseSec, "Fuse Chance Condition", { "Below (<=)", "Above (>=)" },
			cfg.autoFuseChanceMode or "Below (<=)", function(v)
				cfg.autoFuseChanceMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 5)

		local initialFuseChance = tostring(cfg.autoFuseChanceThreshold or "1 in 10sx")
		Settings.CreateControl("autoFuseChanceThreshold", "CreateTextBox", fuseSec, "Fuse Chance Threshold", initialFuseChance, "e.g. 1 in 10sx, 25sx", function(v)
			cfg.autoFuseChanceThreshold = v
			if Settings and Settings.Save then Settings.Save() end
		end, 6)

		Settings.CreateControl("autoFuseByMoney", "CreateToggle", fuseSec, "Fuse by Money/s", cfg.autoFuseByMoney, function(v)
			cfg.autoFuseByMoney = v
			if Settings and Settings.Save then Settings.Save() end
		end, 7)

		Settings.CreateControl("autoFuseMoneyMode", "CreateDropdown", fuseSec, "Fuse Money Condition", { "Below (<=)", "Above (>=)" },
			cfg.autoFuseMoneyMode or "Below (<=)", function(v)
				cfg.autoFuseMoneyMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 8)

		local initialFuseMoney = tostring(cfg.autoFuseMoneyThreshold or "0.1")
		if initialFuseMoney:find("in") then initialFuseMoney = "0.1" end
		Settings.CreateControl("autoFuseMoneyThreshold", "CreateTextBox", fuseSec, "Fuse Money Threshold", initialFuseMoney, "e.g. 100k, 1M, 10B", function(v)
			cfg.autoFuseMoneyThreshold = v
			if Settings and Settings.Save then Settings.Save() end
		end, 9)

		Settings.CreateControl("autoFuseNeverLocked", "CreateToggle", fuseSec, "Never Fuse Locked Units", cfg.autoFuseNeverLocked, function(v)
			cfg.autoFuseNeverLocked = v
			if Settings and Settings.Save then Settings.Save() end
		end, 10)

		Settings.CreateControl("autoFuseNeverMutated", "CreateToggle", fuseSec, "Never Fuse Mutated Units", cfg.autoFuseNeverMutated, function(v)
			cfg.autoFuseNeverMutated = v
			if Settings and Settings.Save then Settings.Save() end
		end, 11)

		Settings.CreateControl("skipFuseCutscene", "CreateToggle", fuseSec, "Skip Fusing Cutscene / Popup", (cfg.skipFuseCutscene ~= false), function(v)
			cfg.skipFuseCutscene = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Skip Fusing Cutscene set to: " .. tostring(v), UI.Colors.accentCyan)
		end, 12)

		local function dismissFusingCutscene()
			pcall(function()
				local pGui = player:FindFirstChild("PlayerGui")
				local root = pGui and pGui:FindFirstChild("Root")
				if root then
					
					local cutsceneFolder = root:FindFirstChild("Cutscene")
					if cutsceneFolder then
						for _, child in ipairs(cutsceneFolder:GetChildren()) do
							if child:IsA("GuiObject") and child.Visible then
								child.Visible = false
							end
						end
					end
					
					local fusingMenu = root:FindFirstChild("Menus") and root.Menus:FindFirstChild("Fusing")
					if fusingMenu then
						local resultFrame = fusingMenu:FindFirstChild("Result")
						if resultFrame and resultFrame.Visible then
							resultFrame.Visible = false
						end
						local portalFrame = fusingMenu:FindFirstChild("Portal")
						if portalFrame and portalFrame:FindFirstChild("Progress") then
							portalFrame.Progress.Text = ""
						end
					end
					
					local rollItemShower = root:FindFirstChild("RollItemShower")
					if rollItemShower then
						for _, c in ipairs(rollItemShower:GetChildren()) do
							c:Destroy()
						end
					end
					
					for _, c in ipairs(workspace:GetChildren()) do
						if c.Name == "CameraModel" or c.Name == "RollCutscene" or c.Name == "lines" then
							pcall(function() c:Destroy() end)
						end
					end
					
					local cam = workspace.CurrentCamera
					if cam then
						cam.CameraType = Enum.CameraType.Custom
						if player.Character and player.Character:FindFirstChild("Humanoid") then
							cam.CameraSubject = player.Character.Humanoid
						end
					end
				end
			end)
		end

		local function getEligibleFuseKeys()
			local inv = extractInventory(DataController and DataController.Inventory)
			local EntryRegistry = nil
			pcall(function() EntryRegistry = require(Features.Inventory.EntryRegistry) end)
			local FusingUtil = nil
			pcall(function() FusingUtil = require(Features.Fusing.FusingUtil) end)
			local UnitController = nil
			pcall(function() UnitController = require(Features.Inventory.Kinds.Unit.UnitController) end)

			local equippedKey = nil
			pcall(function()
				if UnitController and UnitController.EquippedUnit then
					equippedKey = UnitController.EquippedUnit()
				end
			end)

			
			local protectedUnitKeys = {}
			pcall(function()
				local raw = (typeof(DataController) == "function" and DataController()) or
					(DataController and DataController.___X) or {}
				if raw and raw.Slots then
					for _, sData in pairs(raw.Slots) do
						if sData and sData.unitId then
							protectedUnitKeys[tostring(sData.unitId)] = true
						end
					end
				end
				if raw and raw.TowerTeam then
					for _, tUnitId in pairs(raw.TowerTeam) do
						if tUnitId then
							protectedUnitKeys[tostring(tUnitId)] = true
						end
					end
				end
			end)

			local eligible = {}
			for key, u in pairs(inv) do
				local keyStr = tostring(key)
				if isUnitEntry(key, u) and (u.amount == nil or u.amount == 1) then
					local attrs = u.attributes or {}
					local isLocked = isUnitLocked(key, u)
					local isMutated = (attrs.mutation ~= nil and attrs.mutation ~= "" and attrs.mutation ~= "None")

					local isEquipped = (equippedKey and keyStr == tostring(equippedKey))
					local isPlotOrTower = (protectedUnitKeys[keyStr] == true)

					local skip = false
					if isEquipped or isPlotOrTower then
						skip = true
					end
					if (cfg.autoFuseNeverLocked ~= false) and isLocked then
						skip = true
					end
					if (cfg.autoFuseNeverMutated == true) and isMutated then
						skip = true
					end

					if not skip then
						local isFusable = false
						if FusingUtil and FusingUtil.GetChance then
							local chanceOk, chance = pcall(function() return FusingUtil.GetChance(u) end)
							if chanceOk and chance ~= nil then
								isFusable = true
							end
						end
						if not isFusable and EntryRegistry and EntryRegistry.getEntryConfig then
							local cfgOk, cfgModule = pcall(function() return EntryRegistry.getEntryConfig(u.name) end)
							if cfgOk and cfgModule and cfgModule.kind == "Unit" and not cfgModule.limited then
								isFusable = true
							end
						end

						if isFusable then
							local cfgModule = nil
							if EntryRegistry and EntryRegistry.getEntryConfig then
								pcall(function() cfgModule = EntryRegistry.getEntryConfig(u.name) end)
							end
							local unitRarity = (cfgModule and cfgModule.getRarity and cfgModule.getRarity(attrs)) or
								(cfgModule and cfgModule.rarity) or "Common"

							local matchesCriteria = true
							if cfg.autoFuseByRarity then
								if not (cfg.autoFuseRarities and cfg.autoFuseRarities[unitRarity] == true) then
									matchesCriteria = false
								end
							end

							if cfg.autoFuseByChance and matchesCriteria then
								local chanceVal = 0
								if FusingUtil and FusingUtil.GetChance then
									local okChance, c = pcall(function() return FusingUtil.GetChance(u) end)
									if okChance and type(c) == "number" then
										chanceVal = c
									end
								end
								if chanceVal <= 0 then
									chanceVal = getUnitChance(u.name, attrs)
								end

								local th = parseChance(cfg.autoFuseChanceThreshold or "1 in 10sx")
								local mode = cfg.autoFuseChanceMode or "Below (<=)"
								if mode == "Below (<=)" and chanceVal > th then
									matchesCriteria = false
								elseif mode == "Above (>=)" and chanceVal < th then
									matchesCriteria = false
								end
							end

							if cfg.autoFuseByMoney and matchesCriteria then
								local income = getUnitIncome(u.name, attrs)
								local th = parseMoneyValue(cfg.autoFuseMoneyThreshold or "0.1")
								local mode = cfg.autoFuseMoneyMode or "Below (<=)"
								if mode == "Below (<=)" and income > th then
									matchesCriteria = false
								elseif mode == "Above (>=)" and income < th then
									matchesCriteria = false
								end
							end

							if matchesCriteria then
								table.insert(eligible, keyStr)
							end
						end
					end
				end
			end
			return eligible
		end

		local function doFuseBatch()
			local keys = getEligibleFuseKeys()
			if #keys >= 3 then
				local k1, k2, k3 = keys[1], keys[2], keys[3]
				local inv = extractInventory(DataController and DataController.Inventory)
				local u1Name = (inv[k1] and inv[k1].name) or "Unit 1"
				local u2Name = (inv[k2] and inv[k2].name) or "Unit 2"
				local u3Name = (inv[k3] and inv[k3].name) or "Unit 3"

				if fuseRE then
					fuseRE:FireServer(k1, k2, k3)
					logger.Log(string.format("Fusing 3 units: %s, %s, %s...", u1Name, u2Name, u3Name),
						UI.Colors.accentCyan)
					if cfg.skipFuseCutscene ~= false then
						task.defer(dismissFusingCutscene)
					end
					return true
				end
			end
			return false
		end

		UI.CreateButton(fuseSec, "Fuse 3 Eligible Units Once", function()
			local keys = getEligibleFuseKeys()
			if #keys < 3 then
				logger.Log(
					string.format(
						"Not enough eligible units to fuse (found %d, need at least 3). Check rarity/mutation/lock filters.",
						#keys), UI.Colors.warningYellow)
			else
				doFuseBatch()
			end
		end, 13)

		
		if fuseResultRE then
			fuseResultRE.OnClientEvent:Connect(function(resultData, errMsg)
				if cfg.skipFuseCutscene ~= false then
					dismissFusingCutscene()
				end
				if resultData and resultData.name then
					local mutStr = (resultData.attributes and resultData.attributes.mutation and (" | " .. resultData.attributes.mutation)) or
						""
					logger.Log(string.format("Fusion Success! Obtained: %s%s", tostring(resultData.name), mutStr),
						UI.Colors.successGreen)
					if UI.Notify then
						UI.Notify("Fusion Result", string.format("Created %s%s!", tostring(resultData.name), mutStr),
							UI.Colors.successGreen)
					end
					task.delay(0.3, refreshUnitDropdownList)
				elseif errMsg then
					logger.Log("Fusion failed: " .. tostring(errMsg), UI.Colors.warningYellow)
				end
			end)
		end

		local function isTraitSatisfied(currentTrait)
			if not currentTrait or currentTrait == "" or currentTrait == "None" then return false end
			if cfg.targetTraits and type(cfg.targetTraits) == "table" then
				local hasAny = false
				for _, sel in pairs(cfg.targetTraits) do
					if sel == true then
						hasAny = true
						break
					end
				end
				if hasAny then
					return (cfg.targetTraits[currentTrait] == true)
				end
			end
			return (currentTrait == (cfg.targetTrait or "Genesis"))
		end

		local function isGradeSatisfied(currentGrade)
			if not currentGrade or currentGrade == "" or currentGrade == "None" then return false end
			if cfg.targetGrades and type(cfg.targetGrades) == "table" then
				local hasAny = false
				for _, sel in pairs(cfg.targetGrades) do
					if sel == true then
						hasAny = true
						break
					end
				end
				if hasAny then
					return (cfg.targetGrades[currentGrade] == true)
				end
			end
			return (currentGrade == (cfg.targetGrade or "Ω"))
		end

		local function isQuirkSatisfied(currentQuirk)
			if not currentQuirk or currentQuirk == "" or currentQuirk == "None" then return false end
			if cfg.targetQuirks and type(cfg.targetQuirks) == "table" then
				local hasAny = false
				for _, sel in pairs(cfg.targetQuirks) do
					if sel == true then
						hasAny = true
						break
					end
				end
				if hasAny then
					return (cfg.targetQuirks[currentQuirk] == true)
				end
			end
			return (currentQuirk == (cfg.targetQuirk or "Fortune's Favor"))
		end

		
		
		
		local ROLL_ZONE_ORDER = { { "Traits", "autoRollTrait" }, { "Grades", "autoRollGrade" }, { "Quirks", "autoRollQuirk" } }
		local function claimRollZone(name)
			for _, z in ipairs(ROLL_ZONE_ORDER) do
				if cfg[z[2]] == true then
					if z[1] ~= name then return false end
					break
				end
			end
			local zones = workspace:FindFirstChild("Zones")
			local zone = zones and zones:FindFirstChild(name)
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not zone or not hrp then return false end
			local target = Vector3.new(zone.Position.X, zone.Position.Y - zone.Size.Y / 2 + 5, zone.Position.Z)
			local dist = (hrp.Position - target).Magnitude
			if dist <= 20 then return true end
			if dist > 1000 then
				
				pcall(function()
					ReplicatedStorage.Network.HalloweenService.RF.Teleport:InvokeServer("Hub")
				end)
				task.wait(1)
			end
			char:PivotTo(CFrame.new(target))
			return false 
		end

		
		task.spawn(function()
			while scriptRunning do
				if cfg.autoRollTrait == true and DataController and claimRollZone("Traits") then
					pcall(function()
						local targetKeys = getTargetUnitKeysList()
						if #targetKeys == 0 then
							logger.Log("No units selected or available for trait rolling. Stopping.",
								UI.Colors.warningYellow)
							cfg.autoRollTrait = false
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollGrade then cfg.bulkAutoRollBoth = false end
							if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(false) end
							if not cfg.autoRollGrade and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							return
						end

						local rerolls = getTraitPotCount()
						if rerolls <= 0 then
							logger.Log("No Trait Rerolls left! Stopping trait roller.", UI.Colors.dangerRed)
							cfg.autoRollTrait = false
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollGrade then cfg.bulkAutoRollBoth = false end
							if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(false) end
							if not cfg.autoRollGrade and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							refreshUnitDropdownList()
							if UI.Notify then
								UI.Notify("Trait Rerolls Depleted", "You have no Trait Rerolls left in inventory.",
									UI.Colors.dangerRed)
							end
							return
						end

						local allTraitDone = true
						for unitIdx, unitKey in ipairs(targetKeys) do
							local unitData = getLiveUnitData(unitKey)
							if unitData then
								local currentTrait = (unitData.attributes and unitData.attributes.trait) or "None"
								local uName = unitData.name or "Unit"

								if not isTraitSatisfied(currentTrait) then
									allTraitDone = false
									doRollTrait(unitKey)
									logger.Log(string.format("[Trait Roll %d/%d %s]: Current: %s (Rerolls: %d)",
											unitIdx, #targetKeys, tostring(uName), tostring(currentTrait), rerolls),
										UI.Colors.accentCyan)
									break
								end
							end
						end

						if allTraitDone then
							logger.Log(
								string.format("All %d selected unit(s) reached target trait! Trait roller finished.",
									#targetKeys), UI.Colors.successGreen)
							cfg.autoRollTrait = false
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollGrade then cfg.bulkAutoRollBoth = false end
							if autoRollTraitToggle and autoRollTraitToggle.Set then autoRollTraitToggle.Set(false) end
							if not cfg.autoRollGrade and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollGrade or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							refreshUnitDropdownList()
							if UI.Notify then
								UI.Notify("Trait Roll Complete!",
									string.format("All %d units reached target traits!", #targetKeys),
									UI.Colors.successGreen, 5)
							end
						end
					end)
				end
				local rollDelay = math.max(0.05, tonumber(cfg.rollDelayTraitGrade) or 0.25)
				task.wait(rollDelay)
			end
		end)

		
		task.spawn(function()
			while scriptRunning do
				if cfg.autoRollGrade == true and DataController and claimRollZone("Grades") then
					pcall(function()
						local targetKeys = getTargetUnitKeysList()
						if #targetKeys == 0 then
							logger.Log("No units selected or available for grade rolling. Stopping.",
								UI.Colors.warningYellow)
							cfg.autoRollGrade = false
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollTrait then cfg.bulkAutoRollBoth = false end
							if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(false) end
							if not cfg.autoRollTrait and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							return
						end

						local gems = getGemsCount()
						if gems <= 0 then
							logger.Log("No Gems left! Stopping grade roller.", UI.Colors.dangerRed)
							cfg.autoRollGrade = false
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollTrait then cfg.bulkAutoRollBoth = false end
							if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(false) end
							if not cfg.autoRollTrait and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							refreshUnitDropdownList()
							if UI.Notify then
								UI.Notify("Gems Depleted", "You have no Gems left in inventory.", UI.Colors.dangerRed)
							end
							return
						end

						local allGradeDone = true
						for unitIdx, unitKey in ipairs(targetKeys) do
							local unitData = getLiveUnitData(unitKey)
							if unitData then
								local currentGrade = (unitData.attributes and unitData.attributes.grade) or "None"
								local uName = unitData.name or "Unit"

								if not isGradeSatisfied(currentGrade) then
									allGradeDone = false
									doRollGrade(unitKey)
									logger.Log(string.format("[Grade Roll %d/%d %s]: Current: %s (Gems: %d)",
											unitIdx, #targetKeys, tostring(uName), tostring(currentGrade), gems),
										UI.Colors.accentCyan)
									break
								end
							end
						end

						if allGradeDone then
							logger.Log(
								string.format("All %d selected unit(s) reached target grade! Grade roller finished.",
									#targetKeys), UI.Colors.successGreen)
							cfg.autoRollGrade = false
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) then cfg.bulkAutoRollAll = false end
							if not cfg.autoRollTrait then cfg.bulkAutoRollBoth = false end
							if autoRollGradeToggle and autoRollGradeToggle.Set then autoRollGradeToggle.Set(false) end
							if not cfg.autoRollTrait and autoRollBothToggle and autoRollBothToggle.Set then
								autoRollBothToggle.Set(false)
							end
							if not (cfg.autoRollTrait or cfg.autoRollQuirk) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							refreshUnitDropdownList()
							if UI.Notify then
								UI.Notify("Grade Roll Complete!",
									string.format("All %d units reached target grades!", #targetKeys),
									UI.Colors.successGreen, 5)
							end
						end
					end)
				end
				local rollDelay = math.max(0.05, tonumber(cfg.rollDelayTraitGrade) or 0.25)
				task.wait(rollDelay)
			end
		end)

		
		task.spawn(function()
			while scriptRunning do
				if cfg.autoRollQuirk == true and DataController and rollQuirkRE and claimRollZone("Quirks") then
					pcall(function()
						local targetKeys = getTargetUnitKeysList()
						if #targetKeys == 0 then
							logger.Log("No units selected or available for quirk rolling. Stopping.",
								UI.Colors.warningYellow)
							cfg.autoRollQuirk = false
							if not (cfg.autoRollTrait or cfg.autoRollGrade) then cfg.bulkAutoRollAll = false end
							if autoRollQuirkToggle and autoRollQuirkToggle.Set then autoRollQuirkToggle.Set(false) end
							if not (cfg.autoRollTrait or cfg.autoRollGrade) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							return
						end

						local okM, mVal = pcall(DataController.Money)
						local playerMoney = (okM and tonumber(mVal)) or 0

						local allQuirkDone = true
						for unitIdx, unitKey in ipairs(targetKeys) do
							local unitData = getLiveUnitData(unitKey)
							if unitData then
								local currentQuirk = (unitData.attributes and unitData.attributes.quirk) or "None"
								local uName = unitData.name or "Unit"

								if not isQuirkSatisfied(currentQuirk) then
									allQuirkDone = false
									local rollCost = getQuirkRollCost(unitData)
									if playerMoney < rollCost then
										logger.Log(
											string.format(
												"Insufficient Money ($%s < $%s) for quirk roll! Stopping quirk roller.",
												formatNumber(playerMoney), formatNumber(rollCost)), UI.Colors.dangerRed)
										cfg.autoRollQuirk = false
										if not (cfg.autoRollTrait or cfg.autoRollGrade) then cfg.bulkAutoRollAll = false end
										if autoRollQuirkToggle and autoRollQuirkToggle.Set then autoRollQuirkToggle.Set(false) end
										if not (cfg.autoRollTrait or cfg.autoRollGrade) and autoRollAllToggle and autoRollAllToggle.Set then
											autoRollAllToggle.Set(false)
										end
										if Settings and Settings.Save then Settings.Save() end
										refreshUnitDropdownList()
										if UI.Notify then
											UI.Notify("Insufficient Money", "You cannot afford more Quirk rolls.",
												UI.Colors.dangerRed)
										end
										return
									end

									doRollQuirk(unitKey)
									logger.Log(string.format("[Quirk Roll %d/%d %s]: Current: %s (Cost: $%s)",
										unitIdx, #targetKeys, tostring(uName), tostring(currentQuirk),
										formatNumber(rollCost)), UI.Colors.accentCyan)
									break
								else
									if cfg.autoProtectQuirks and setQuirkProtectedRE and currentQuirk ~= "None" then
										pcall(function()
											setQuirkProtectedRE:FireServer(currentQuirk, true)
										end)
									end
								end
							end
						end

						if allQuirkDone then
							logger.Log(
								string.format("All %d selected unit(s) reached target quirk! Quirk roller finished.",
									#targetKeys), UI.Colors.successGreen)
							cfg.autoRollQuirk = false
							if not (cfg.autoRollTrait or cfg.autoRollGrade) then cfg.bulkAutoRollAll = false end
							if autoRollQuirkToggle and autoRollQuirkToggle.Set then autoRollQuirkToggle.Set(false) end
							if not (cfg.autoRollTrait or cfg.autoRollGrade) and autoRollAllToggle and autoRollAllToggle.Set then
								autoRollAllToggle.Set(false)
							end
							if Settings and Settings.Save then Settings.Save() end
							refreshUnitDropdownList()
							if UI.Notify then
								UI.Notify("Quirk Roll Complete!",
									string.format("All %d units reached target quirks!", #targetKeys),
									UI.Colors.successGreen, 5)
							end
						end
					end)
				end
				local rollDelay = math.max(0.05, tonumber(cfg.rollDelayTraitGrade) or 0.25)
				task.wait(rollDelay)
			end
		end)

		
		task.spawn(function()
			while scriptRunning do
				if cfg.autoFuse and fuseRE and DataController then
					pcall(function()
						local keys = getEligibleFuseKeys()
						if #keys >= 3 then
							fuseRE:FireServer(keys[1], keys[2], keys[3])
							if cfg.skipFuseCutscene ~= false then
								dismissFusingCutscene()
							end
							task.wait(0.75)
						end
					end)
				end
				task.wait(0.5)
			end
		end)
	end

	
	
	
	do
		local tradeTab = UI.Tabs.Shop or UI.Tabs.Trade or UI.Tabs.Trading

		local currentTradeState = nil
		local currentTradePartner = nil
		local tradeOfferPopulated = false
		local tradeOfferInProgress = false

		
		local function getPlayerNames()
			local names = { "None" }
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player then
					table.insert(names, p.Name)
				end
			end
			return names
		end

		
		local tradeSec = UI.CreateSection(tradeTab, "Trading Automation & Control", 3, true)

		UI.CreateDivider(tradeSec, "Target Player & Requests", 1)

		local playerDropdown = Settings.CreateControl("selectedTradePlayer", "CreateDropdown", tradeSec, "Target Player", getPlayerNames(),
			cfg.selectedTradePlayer or "None", function(v)
				cfg.selectedTradePlayer = v
				if Settings and Settings.Save then Settings.Save() end
				logger.Log("Trading target player set to: " .. tostring(v), UI.Colors.accentCyan)
			end, 2)

		UI.CreateButton(tradeSec, "Refresh Server Players", function()
			local names = getPlayerNames()
			playerDropdown.Refresh(names, cfg.selectedTradePlayer or "None")
			logger.Log(string.format("Refreshed player list (%d other players online).", #names - 1),
				UI.Colors.accentCyan)
		end, 3)

		
		Players.PlayerAdded:Connect(function()
			task.wait(0.5)
			pcall(function()
				local names = getPlayerNames()
				playerDropdown.Refresh(names, cfg.selectedTradePlayer or "None")
			end)
		end)

		Players.PlayerRemoving:Connect(function(leftPlayer)
			task.wait(0.5)
			pcall(function()
				local names = getPlayerNames()
				local cur = cfg.selectedTradePlayer
				if cur == leftPlayer.Name then
					cur = "None"
					cfg.selectedTradePlayer = "None"
				end
				playerDropdown.Refresh(names, cur)
			end)
		end)

		Settings.CreateControl("autoSendTrade", "CreateToggle", tradeSec, "Auto Send Trade Request", cfg.autoSendTrade, function(v)
			cfg.autoSendTrade = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Send Trade Request enabled.", UI.Colors.successGreen) end
		end, 4)

		Settings.CreateControl("autoAcceptTrade", "CreateToggle", tradeSec, "Auto Accept Trade Request", cfg.autoAcceptTrade, function(v)
			cfg.autoAcceptTrade = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Accept Trade Request enabled.", UI.Colors.successGreen) end
		end, 5)

		Settings.CreateControl("autoAcceptAnyPlayer", "CreateToggle", tradeSec, "Accept From Any Player", cfg.autoAcceptAnyPlayer, function(v)
			cfg.autoAcceptAnyPlayer = v
			if Settings and Settings.Save then Settings.Save() end
		end, 6)

		
		local syncTradeOffer

		
		UI.CreateDivider(tradeSec, "Auto Offer Items, Gears & Potions", 7)

		Settings.CreateControl("tradeOfferPotions", "CreateToggle", tradeSec, "Auto Offer Selected Items & Gears", cfg.tradeOfferPotions, function(v)
			cfg.tradeOfferPotions = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Offer Selected Items & Gears enabled.", UI.Colors.successGreen) end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 8)

		Settings.CreateControl("selectedTradePotions", "CreateMultiDropdown", tradeSec, "Select Items / Gears to Offer", ALL_TRADE_ITEMS, cfg.selectedTradePotions,
			function(newMap)
				cfg.selectedTradePotions = newMap
				if Settings and Settings.Save then Settings.Save() end
				tradeOfferPopulated = false
				if syncTradeOffer then syncTradeOffer() end
			end, 9)

		Settings.CreateControl("tradePotionAmount", "CreateTextBox", tradeSec, "Offer Quantity per Item (Custom)",
			tostring(cfg.tradePotionAmount or "All"), "e.g. All, 10, 100, 1k, 10k, 50k, 100k, 1M",
			function(v)
				cfg.tradePotionAmount = v
				if Settings and Settings.Save then Settings.Save() end
				logger.Log("Trade offer quantity set to: " .. tostring(v), UI.Colors.accentCyan)
				tradeOfferPopulated = false
				if syncTradeOffer then syncTradeOffer() end
			end, 10)

		
		UI.CreateDivider(tradeSec, "Auto Offer Units", 11)

		Settings.CreateControl("tradeOfferUnitsByMoney", "CreateToggle", tradeSec, "Offer Units by Money/s", cfg.tradeOfferUnitsByMoney, function(v)
			cfg.tradeOfferUnitsByMoney = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Offer Units by Money/s enabled.", UI.Colors.successGreen) end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 12)

		Settings.CreateControl("tradeUnitMoneyMode", "CreateDropdown", tradeSec, "Unit Money Condition", { "Below (<=)", "Above (>=)" },
			cfg.tradeUnitMoneyMode or "Below (<=)", function(v)
				cfg.tradeUnitMoneyMode = v
				if Settings and Settings.Save then Settings.Save() end
				tradeOfferPopulated = false
				if syncTradeOffer then syncTradeOffer() end
			end, 13)

		local initialTradeVal = tostring(cfg.tradeUnitMoneyThreshold or "0.1")
		if initialTradeVal:find("in") then
			initialTradeVal = "0.1"
			cfg.tradeUnitMoneyThreshold = "0.1"
		end
		Settings.CreateControl("tradeUnitMoneyThreshold", "CreateTextBox", tradeSec, "Offer Value Threshold", initialTradeVal, "e.g. 100k, 1M, 1T", function(v)
			cfg.tradeUnitMoneyThreshold = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Trade Unit Money/s threshold set to: " .. tostring(v), UI.Colors.textSecondary)
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 14)

		Settings.CreateControl("tradeOfferUnitsByRarity", "CreateToggle", tradeSec, "Offer Units by Rarity Tier", cfg.tradeOfferUnitsByRarity, function(v)
			cfg.tradeOfferUnitsByRarity = v
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 15)

		Settings.CreateControl("tradeUnitRarities", "CreateMultiDropdown", tradeSec, "Rarities to Offer", ALL_RARITIES, cfg.tradeUnitRarities, function(newMap)
			cfg.tradeUnitRarities = newMap
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 16)

		Settings.CreateControl("tradeOfferUnitsByQuirk", "CreateToggle", tradeSec, "Offer Units by Quirk", cfg.tradeOfferUnitsByQuirk, function(v)
			cfg.tradeOfferUnitsByQuirk = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Offer Units by Quirk enabled.", UI.Colors.successGreen) end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 17)

		Settings.CreateControl("tradeUnitQuirks", "CreateMultiDropdown", tradeSec, "Quirks to Offer", ALL_TRADE_QUIRKS, cfg.tradeUnitQuirks or {
			["Any Quirk"] = true,
			["Fortune's Favor"] = false,
			["Midas Touch"] = false,
			["Tycoon"] = false,
			["Prodigy"] = false,
			["Fortune III"] = false,
			["Wealth III"] = false,
			["Refined III"] = false,
			["Gifted III"] = false,
			["Swift III"] = false,
			["Fortune II"] = false,
			["Wealth II"] = false,
			["Refined II"] = false,
			["Gifted II"] = false,
			["Swift II"] = false,
			["Fortune I"] = false,
			["Wealth I"] = false,
			["Refined I"] = false,
			["Gifted I"] = false,
			["Swift I"] = false
		}, function(newMap)
			cfg.tradeUnitQuirks = newMap
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 18)

		Settings.CreateControl("tradeOnlyOfferQuirks", "CreateToggle", tradeSec, "Only Offer Units With Quirks", cfg.tradeOnlyOfferQuirks, function(v)
			cfg.tradeOnlyOfferQuirks = v
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 19)

		Settings.CreateControl("tradeNeverOfferLocked", "CreateToggle", tradeSec, "Never Offer Locked Units", cfg.tradeNeverOfferLocked, function(v)
			cfg.tradeNeverOfferLocked = v
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
		end, 20)

		Settings.CreateControl("tradeNeverOfferMutated", "CreateToggle", tradeSec, "Never Offer Mutated Units", cfg.tradeNeverOfferMutated, function(v)
			cfg.tradeNeverOfferMutated = v
			if Settings and Settings.Save then Settings.Save() end
			tradeOfferPopulated = false
		end, 21)

		
		UI.CreateDivider(tradeSec, "Trade Actions & Control", 22)

		Settings.CreateControl("autoReadyTrade", "CreateToggle", tradeSec, "Auto Ready (Offer Phase)", cfg.autoReadyTrade, function(v)
			cfg.autoReadyTrade = v
			if Settings and Settings.Save then Settings.Save() end
		end, 23)

		Settings.CreateControl("autoAcceptTradeFinal", "CreateToggle", tradeSec, "Auto Accept Final Trade", cfg.autoAcceptTradeFinal, function(v)
			cfg.autoAcceptTradeFinal = v
			if Settings and Settings.Save then Settings.Save() end
		end, 24)

		UI.CreateButton(tradeSec, "Put Selected Items / Units into Trade", function()
			tradeOfferPopulated = false
			if syncTradeOffer then syncTradeOffer() end
		end, 25)

		UI.CreateButton(tradeSec, "Send Trade Request Now", function()
			pcall(function()
				if not requestTradeRE then return end
				if not cfg.selectedTradePlayer or cfg.selectedTradePlayer == "None" then
					logger.Log("Please select a target player first.", UI.Colors.warningYellow)
					return
				end
				local target = Players:FindFirstChild(cfg.selectedTradePlayer)
				if target and target ~= player then
					requestTradeRE:FireServer(target)
					logger.Log("Sent trade request to: " .. target.Name, UI.Colors.accentCyan)
				else
					logger.Log("Target player not found in server.", UI.Colors.warningYellow)
				end
			end)
		end, 26)

		UI.CreateButton(tradeSec, "Cancel / Close Trade", function()
			pcall(function()
				if cancelTradeRE then
					cancelTradeRE:FireServer()
					logger.Log("Cancelled active trade.", UI.Colors.accentCyan)
				end
			end)
		end, 27)

		
		if tradeEventRE then
			tradeEventRE.OnClientEvent:Connect(function(eventType, data)
				if eventType == "RequestReceived" and data and data.player then
					local sender = data.player
					local shouldAccept = false
					if cfg.autoAcceptTrade then
						if cfg.autoAcceptAnyPlayer or (cfg.selectedTradePlayer and (sender.Name == cfg.selectedTradePlayer or sender.DisplayName == cfg.selectedTradePlayer)) then
							shouldAccept = true
						end
					end
					if shouldAccept and respondToRequestRE then
						respondToRequestRE:FireServer(true)
						logger.Log("Auto Accepted trade request from: " .. sender.Name, UI.Colors.successGreen)
					end
				elseif eventType == "Started" and data then
					currentTradePartner = data.partner
					currentTradeState = {
						phase = "Offer",
						ownReady = false,
						otherReady = false,
						ownAccepted = false,
						otherAccepted = false,
						ownOffer = {},
						otherOffer = {}
					}
					tradeOfferPopulated = false
					tradeOfferInProgress = false
					logger.Log("Trade started with: " .. (currentTradePartner and currentTradePartner.Name or "Partner"),
						UI.Colors.accentCyan)
				elseif eventType == "Updated" and data then
					currentTradeState = data
					currentTradePartner = data.partner or currentTradePartner
				elseif eventType == "Ended" then
					currentTradePartner = nil
					currentTradeState = nil
					tradeOfferPopulated = false
					tradeOfferInProgress = false
					logger.Log("Trade ended. Reason: " .. tostring(data and data.reason or "Closed"), UI.Colors
						.textMuted)
				end
			end)
		end

		local function parseOfferQuantity(valStr, totalAmount)
			if not valStr or valStr == "All" or valStr == "all" then return totalAmount end
			if type(valStr) == "number" then return math.min(math.floor(valStr), totalAmount) end
			local clean = string.lower(tostring(valStr)):gsub("%s+", ""):gsub(",", "")
			if clean == "all" or clean == "max" or clean == "" then return totalAmount end
			local num, suffix = clean:match("^([%d%.]+)([a-z]*)$")
			if not num then
				local directNum = tonumber(clean)
				if directNum then return math.min(math.floor(directNum), totalAmount) end
				return totalAmount
			end
			local val = tonumber(num) or totalAmount
			if suffix == "k" then
				val = val * 1e3
			elseif suffix == "m" then
				val = val * 1e6
			elseif suffix == "b" then
				val = val * 1e9
			elseif suffix == "t" then
				val = val * 1e12
			end
			return math.min(math.floor(val), totalAmount)
		end

		local lastSyncTime = 0
		syncTradeOffer = function()
			local UIReferences = nil
			pcall(function()
				UIReferences = require(Features.UI.UIReferences)
			end)
			local tradeScreenOpen = false
			pcall(function()
				if UIReferences and UIReferences.Root and UIReferences.Root.Trading and UIReferences.Root.Trading.TradeScreen then
					tradeScreenOpen = UIReferences.Root.Trading.TradeScreen.Visible
				end
			end)

			if not currentTradeState and tradeScreenOpen then
				currentTradeState = {
					phase = "Offer",
					ownReady = false,
					otherReady = false,
					ownAccepted = false,
					otherAccepted = false,
					ownOffer = {},
					otherOffer = {}
				}
			end

			if not currentTradeState or currentTradeState.phase ~= "Offer" or not changeOfferRE or not DataController or not DataController.Inventory then
				return
			end
			if tradeOfferInProgress then return end
			if os.clock() - lastSyncTime < 0.25 then return end
			lastSyncTime = os.clock()
			tradeOfferInProgress = true

			local ok, err = pcall(function()
				local inv = extractInventory(DataController.Inventory)
				if not currentTradeState.ownOffer then
					currentTradeState.ownOffer = {}
				end
				local ownOffer = currentTradeState.ownOffer
				local desiredOffer = {}
				local offeredCount = 0

				
				if cfg.tradeOfferPotions and cfg.selectedTradePotions then
					for _, itemName in ipairs(ALL_TRADE_ITEMS) do
						if cfg.selectedTradePotions[itemName] == true and itemName ~= "Tickets" then
							local itemData = inv[itemName]
							if itemData then
								local totalAmount = itemData.amount or 1
								local targetAmt = parseOfferQuantity(cfg.tradePotionAmount or "All", totalAmount)
								if targetAmt > 0 and offeredCount < 18 then
									desiredOffer[itemName] = targetAmt
									offeredCount = offeredCount + 1
								end
							end
						end
					end
				end

				
				if (cfg.tradeOfferUnitsByMoney or cfg.tradeOfferUnitsByRarity or cfg.tradeOfferUnitsByQuirk) and offeredCount < 18 then
					for key, unit in pairs(inv) do
						if offeredCount >= 18 then break end
						local unitName = unit.name
						local attributes = unit.attributes or {}
						local isLocked = (attributes.locked == true)
						local mutation = attributes.mutation
						local unitQuirk = attributes.quirk

						local skipUnit = false
						if isLocked and cfg.tradeNeverOfferLocked then skipUnit = true end
						if mutation and cfg.tradeNeverOfferMutated then skipUnit = true end
						
						pcall(function()
							if not require(Features.Trading.TradeConfig).IsTradeable(unit) then skipUnit = true end
						end)
						if cfg.tradeOnlyOfferQuirks and (not unitQuirk or unitQuirk == "") then skipUnit = true end

						if not skipUnit then
							local shouldOffer = false

							if cfg.tradeOfferUnitsByQuirk and unitQuirk and unitQuirk ~= "" then
								if cfg.tradeUnitQuirks then
									if cfg.tradeUnitQuirks["Any Quirk"] == true or cfg.tradeUnitQuirks[unitQuirk] == true then
										shouldOffer = true
									end
								end
							end

							if not shouldOffer and cfg.tradeOfferUnitsByMoney then
								local unitIncome = getUnitIncome(unitName, attributes)
								local thresholdVal = parseMoneyValue(cfg.tradeUnitMoneyThreshold or "0.1")
								local mode = cfg.tradeUnitMoneyMode or "Below (<=)"
								if mode == "Below (<=)" and unitIncome <= thresholdVal then
									shouldOffer = true
								elseif mode == "Above (>=)" and unitIncome >= thresholdVal then
									shouldOffer = true
								end
							end

							if not shouldOffer and cfg.tradeOfferUnitsByRarity and Rarities and unitName then
								local configModule = require(Features.Inventory.EntryRegistry).getEntryConfig(unitName)
								if configModule and configModule.getRarity then
									local r = configModule.getRarity(attributes)
									if cfg.tradeUnitRarities and cfg.tradeUnitRarities[r] == true then
										shouldOffer = true
									end
								end
							end

							if shouldOffer then
								desiredOffer[key] = 1
								offeredCount = offeredCount + 1
							end
						end
					end
				end

				
				local needsChanges = false
				for key, targetAmt in pairs(desiredOffer) do
					if (ownOffer[key] or 0) ~= targetAmt then
						needsChanges = true
						break
					end
				end
				if not needsChanges then
					for key, currAmt in pairs(ownOffer) do
						if (desiredOffer[key] or 0) ~= currAmt then
							needsChanges = true
							break
						end
					end
				end

				if not needsChanges then
					tradeOfferPopulated = true
					tradeOfferInProgress = false
					return
				end

				
				if currentTradeState.ownReady and advanceTradeRE then
					advanceTradeRE:FireServer()
					currentTradeState.ownReady = false
					task.wait(0.15)
				end

				
				for key, currAmt in pairs(ownOffer) do
					local targetAmt = desiredOffer[key] or 0
					if currAmt > targetAmt then
						local delta = targetAmt - currAmt
						changeOfferRE:FireServer(key, delta)
						ownOffer[key] = (targetAmt > 0) and targetAmt or nil
						task.wait(0.08)
					end
				end

				
				for _, itemName in ipairs(ALL_TRADE_ITEMS) do
					local targetAmt = desiredOffer[itemName]
					if targetAmt then
						local currAmt = (currentTradeState and currentTradeState.ownOffer and currentTradeState.ownOffer[itemName]) or
							ownOffer[itemName] or 0
						if targetAmt > currAmt then
							local delta = targetAmt - currAmt
							changeOfferRE:FireServer(itemName, delta)
							ownOffer[itemName] = targetAmt
							logger.Log(string.format("Put %s (x%d) into trade.", itemName, targetAmt),
								UI.Colors.accentCyan)
							task.wait(1.5)
						end
					end
				end

				for key, targetAmt in pairs(desiredOffer) do
					if not table.find(ALL_TRADE_ITEMS, key) then
						local currAmt = (currentTradeState and currentTradeState.ownOffer and currentTradeState.ownOffer[key]) or
							ownOffer[key] or 0
						if targetAmt > currAmt then
							local delta = targetAmt - currAmt
							changeOfferRE:FireServer(key, delta)
							ownOffer[key] = targetAmt
							task.wait(0.12)
						end
					end
				end

				
				local allItemsPresent = true
				for key, targetAmt in pairs(desiredOffer) do
					local liveAmt = (currentTradeState and currentTradeState.ownOffer and currentTradeState.ownOffer[key]) or
						0
					if liveAmt < targetAmt then
						allItemsPresent = false
						break
					end
				end

				if allItemsPresent then
					tradeOfferPopulated = true
					logger.Log(string.format("All %d items/units confirmed in trade offer.", offeredCount),
						UI.Colors.successGreen)
				else
					tradeOfferPopulated = false
				end
			end)

			if not ok then
				logger.Log("Trade sync error: " .. tostring(err), UI.Colors.warningYellow)
			end

			tradeOfferInProgress = false
		end

		
		task.spawn(function()
			while true do
				
				if cfg.autoSendTrade and not currentTradeState and requestTradeRE and cfg.selectedTradePlayer and cfg.selectedTradePlayer ~= "None" then
					pcall(function()
						local target = Players:FindFirstChild(cfg.selectedTradePlayer)
						if target and target ~= player then
							requestTradeRE:FireServer(target)
						end
					end)
					task.wait(5.0)
				end

				
				if currentTradeState and currentTradeState.phase == "Offer" and not tradeOfferPopulated and not tradeOfferInProgress then
					syncTradeOffer()
				end

				
				if currentTradeState and advanceTradeRE then
					pcall(function()
						if currentTradeState.phase == "Offer" and tradeOfferPopulated and not tradeOfferInProgress and not currentTradeState.ownReady and cfg.autoReadyTrade then
							task.wait(0.4)
							advanceTradeRE:FireServer()
							logger.Log("Auto Readied trade.", UI.Colors.accentCyan)
						elseif currentTradeState.phase == "Confirm" and not currentTradeState.ownAccepted and cfg.autoAcceptTradeFinal then
							task.wait(0.4)
							advanceTradeRE:FireServer()
							logger.Log("Auto Accepted trade confirmation.", UI.Colors.successGreen)
						end
					end)
				end

				task.wait(0.5)
			end
		end)
	end

	
	
	
	do
		local rewTab = UI.Tabs.Misc or UI.Tabs.Rewards
		local rewSec = UI.CreateSection(rewTab, "Claim Automation", 1, true)

		Settings.CreateControl("autoClaimDaily", "CreateToggle", rewSec, "Auto Claim Daily Rewards", cfg.autoClaimDaily, function(v)
			cfg.autoClaimDaily = v
			if Settings and Settings.Save then Settings.Save() end
		end, 1)

		Settings.CreateControl("autoClaimGroup", "CreateToggle", rewSec, "Auto Claim Group Rewards", cfg.autoClaimGroup, function(v)
			cfg.autoClaimGroup = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		Settings.CreateControl("autoClaimOffline", "CreateToggle", rewSec, "Auto Claim Offline Earnings", cfg.autoClaimOffline, function(v)
			cfg.autoClaimOffline = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		Settings.CreateControl("autoClaimQuests", "CreateToggle", rewSec, "Auto Claim Finished Quests", cfg.autoClaimQuests, function(v)
			cfg.autoClaimQuests = v
			if Settings and Settings.Save then Settings.Save() end
		end, 4)

		UI.CreateButton(rewSec, "Claim All Finished Quests Now", function()
			pcall(function()
				local QuestConfig = require(Features.Quests.QuestConfig)
				local raw = (typeof(DataController) == "function" and DataController()) or
					(DataController and DataController.___X)
				local quests = (raw and raw.Quests) or {}
				local count = 0
				for _, period in ipairs({ "Daily", "Weekly" }) do
					local questData = quests[period] or
						(DataController.Quests and DataController.Quests[period] and DataController.Quests[period]())
					if questData and questData.progress and QuestConfig and QuestConfig.Periods and QuestConfig.Periods[period] then
						local expAt = questData.expiresAt or 0
						for _, q in ipairs(QuestConfig.Periods[period].quests) do
							local cur = questData.progress[q.id] or 0
							local claimed = questData.claimed and questData.claimed[q.id] == true
							if not claimed and cur >= q.target then
								claimQuestRE:FireServer(period, q.id, expAt)
								count = count + 1
								logger.Log(string.format("Claimed %s Quest: %s", period, q.id), UI.Colors.successGreen)
								task.wait(0.15)
							end
						end
					end
				end
				if count > 0 then
					logger.Log(string.format("Claimed %d finished quest(s)!", count), UI.Colors.successGreen)
				else
					logger.Log("No unclaimed finished quests found.", UI.Colors.textMuted)
				end
			end)
		end, 5)

		UI.CreateButton(rewSec, "Redeem All Active Codes", function()
			pcall(function()
				if not redeemCodeRE then
					logger.Log("CodesService remote not found.", UI.Colors.dangerRed)
					return
				end
				local CodesConfig = nil
				pcall(function()
					CodesConfig = require(Features.Codes.CodesConfig)
				end)
				local codeList = (CodesConfig and type(CodesConfig) == "table" and (function()
					local list = {}
					for codeName, _ in pairs(CodesConfig) do
						table.insert(list, codeName)
					end
					return list
				end)()) or {
					"UPDATE10", "UPDATE8", "UPDATE7", "UPDATE6", "UPDATE5", "UPDATE4", "UPDATE3", "UPDATE2", "UPDATE1",
					"RELEASE",
					"400KLIKES", "250KLIKES", "100KLIKES", "40KCCU", "30KCCU", "20KCCU", "10KCCU", "5KCCU", "1KCCU"
				}

				logger.Log("Redeeming all active codes...", UI.Colors.accentCyan)
				for _, codeStr in ipairs(codeList) do
					redeemCodeRE:FireServer(codeStr)
					task.wait(0.2)
				end
				logger.Log("Finished submitting codes!", UI.Colors.successGreen)
				UI.Notify("Codes Redeemed", "Submitted all promo codes.", UI.Colors.successGreen, 3)
			end)
		end, 6)

		local rebSec = UI.CreateSection(UI.Tabs.Upgrades, "Rebirth Automation", 2, true)

		Settings.CreateControl("autoRebirth", "CreateToggle", rebSec, "Auto Rebirth When Affordable", cfg.autoRebirth, function(v)
			cfg.autoRebirth = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Rebirth enabled.", UI.Colors.successGreen) end
		end, 1)

		UI.CreateButton(rebSec, "Use Reset Token (Reset Stats)", function()
			pcall(function()
				if useResetTokenRE then
					useResetTokenRE:FireServer()
					logger.Log("Fired Reset Token to reset Rebirth Stats.", UI.Colors.successGreen)
					UI.Notify("Reset Token", "Rebirth stats reset requested.", UI.Colors.successGreen, 3)
				else
					logger.Log("UseResetToken remote not found.", UI.Colors.dangerRed)
				end
			end)
		end, 2)

		
		local RebirthStatsConfig = nil
		pcall(function() RebirthStatsConfig = require(Features.Rebirth.RebirthStatsConfig) end)
		local addStatRE = Net:WaitForChild("RebirthService"):WaitForChild("RE"):FindFirstChild("AddStat")
		local REBIRTH_STATS = {}
		for _, st in ipairs(RebirthStatsConfig and RebirthStatsConfig.Stats or {}) do
			table.insert(REBIRTH_STATS, st.name)
		end

		Settings.CreateControl("autoRebirthStats", "CreateToggle", rebSec, "Auto Upgrade Rebirth Stats", cfg.autoRebirthStats, function(v)
			cfg.autoRebirthStats = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Rebirth Stats enabled.", UI.Colors.successGreen) end
		end, 3)

		Settings.CreateControl("rebirthStatFocus", "CreateMultiDropdown", rebSec, "Rebirth Stat Focus", REBIRTH_STATS, cfg.rebirthStatFocus or { Luck = true },
			function(newMap)
				cfg.rebirthStatFocus = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 4)

		task.spawn(function()
			while scriptRunning do
				local waitFor = 1
				if cfg.autoRebirthStats and addStatRE and RebirthStatsConfig and DataController then
					pcall(function()
						local stats = DataController.RebirthStats() or {}
						if RebirthStatsConfig.GetRemaining(DataController.Rebirth() or 0, stats) < 1 then return end
						
						local focus = cfg.rebirthStatFocus or {}
						local pick, low = nil, math.huge
						for _, name in ipairs(REBIRTH_STATS) do
							if focus[name] and (stats[name] or 0) < low then
								pick, low = name, stats[name] or 0
							end
						end
						if pick then
							addStatRE:FireServer(pick)
							logger.Log(string.format("Rebirth Stat +1 %s (now %d)", pick, low + 1),
								UI.Colors.successGreen)
							waitFor = 0.4 
						end
					end)
				end
				task.wait(waitFor)
			end
		end)

		local ticketShopSec = UI.CreateSection(UI.Tabs.Shop, "Ticket Shop Automation", 2, true)

		Settings.CreateControl("autoBuyTicketShop", "CreateToggle", ticketShopSec, "Auto Buy Ticket Shop Items", cfg.autoBuyTicketShop, function(v)
			cfg.autoBuyTicketShop = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Buy Ticket Shop items enabled.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("selectedTicketShopItems", "CreateMultiDropdown", ticketShopSec, "Select Items to Auto Buy", ALL_TICKET_SHOP_ITEMS,
			cfg.selectedTicketShopItems or {
				["Trait Reroll"] = true,
				["Gems"] = false,
				["Reset Token"] = false,
				["Lucky Spin"] = false,
				["Jackpot Spin"] = false,
				["Luck"] = false,
				["Ultra Luck"] = false,
				["More Cash"] = false,
				["Roll Speed"] = false,
				["More Grades"] = false,
				["More Traits"] = false
			}, function(newMap)
				cfg.selectedTicketShopItems = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		UI.CreateButton(ticketShopSec, "Buy Selected Ticket Items Now", function()
			pcall(function()
				local inv = extractInventory(DataController and DataController.Inventory)
				local tickets = (inv and inv["Tickets"] and (inv["Tickets"].amount or 1)) or 0
				if tickets <= 0 and DataController and DataController.Inventory and DataController.Inventory.Tickets then
					local t = DataController.Inventory.Tickets()
					tickets = t and (t.amount or 1) or 0
				end

				local count = 0
				for itemName, isSelected in pairs(cfg.selectedTicketShopItems or {}) do
					if isSelected == true then
						local price = TICKET_SHOP_PRICES[itemName] or 1
						local isGamepass = (TICKET_SHOP_GAMEPASSES and TICKET_SHOP_GAMEPASSES[itemName] == true) or
							table.find({ "Luck", "Ultra Luck", "More Cash", "Roll Speed", "More Grades", "More Traits" },
								itemName)
						local owned = false
						if isGamepass and DataController and DataController.OwnedGamepasses and DataController.OwnedGamepasses[itemName] then
							owned = (DataController.OwnedGamepasses[itemName]() == true)
						end
						if not owned and tickets >= price then
							if buyQuestRE then
								buyQuestRE:FireServer(itemName)
								count = count + 1
								tickets = tickets - price
								logger.Log(string.format("Purchased %s for %d Tickets.", itemName, price),
									UI.Colors.successGreen)
								task.wait(0.25)
							end
						end
					end
				end
				if count == 0 then
					logger.Log("No affordable unowned selected ticket items found.", UI.Colors.textMuted)
				end
			end)
		end, 3)

		local spinSec = UI.CreateSection(UI.Tabs.Misc, "Wheel Spins Automation", 2, true)

		Settings.CreateControl("autoUseSpins", "CreateToggle", spinSec, "Auto Use Lucky / Jackpot Spins", cfg.autoUseSpins, function(v)
			cfg.autoUseSpins = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Auto Use Spins enabled.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("selectedSpins", "CreateMultiDropdown", spinSec, "Select Spins to Auto-Use",
			{ "Grand Jackpot", "Mega Jackpot", "Jackpot Spin", "Lucky Spin", "Pumpkin Spin", "Pumpkin Jackpot",
				"Witch's Jackpot" },
			cfg.selectedSpins or { ["Jackpot Spin"] = true, ["Lucky Spin"] = true }, function(newMap)
				cfg.selectedSpins = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		UI.CreateButton(spinSec, "Use All Selected Spins Now", function()
			pcall(function()
				if not useSpinRE then
					logger.Log("SpinService remote not found.", UI.Colors.dangerRed)
					return
				end
				local inv = extractInventory(DataController and DataController.Inventory)
				local usedCount = 0
				for spinName, isSelected in pairs(cfg.selectedSpins or {}) do
					if isSelected == true and inv and inv[spinName] then
						local amount = inv[spinName].amount or 1
						for _ = 1, amount do
							useSpinRE:FireServer(spinName)
							usedCount = usedCount + 1
							task.wait(0.2)
						end
					end
				end
				if usedCount > 0 then
					logger.Log(string.format("Used %d spin(s)!", usedCount), UI.Colors.successGreen)
				else
					logger.Log("No selected spins found in inventory.", UI.Colors.textMuted)
				end
			end)
		end, 3)


		task.spawn(function()
			while true do
				if cfg.autoClaimDaily then
					pcall(function()
						
						local last = DataController and DataController.LastDailyRewardClaim and
							DataController.LastDailyRewardClaim() or 0
						local cd = require(Features.Rewards.DailyRewardConfig).Cooldown
						if last == 0 or os.time() - last >= cd then
							claimDailyRE:FireServer()
							logger.Log("Claimed Daily Reward!", UI.Colors.successGreen)
						end
					end)
				end

				if cfg.autoClaimGroup then
					pcall(function() claimGroupRE:FireServer() end)
				end

				if cfg.autoClaimOffline then
					pcall(function() claimOfflineRE:FireServer() end)
				end

				if cfg.autoClaimQuests and DataController then
					pcall(function()
						local QuestConfig = require(Features.Quests.QuestConfig)
						local raw = (typeof(DataController) == "function" and DataController()) or
							(DataController and DataController.___X)
						local quests = (raw and raw.Quests) or {}
						for _, period in ipairs({ "Daily", "Weekly" }) do
							local questData = quests[period] or
								(DataController.Quests and DataController.Quests[period] and DataController.Quests[period]())
							if questData and questData.progress and QuestConfig and QuestConfig.Periods and QuestConfig.Periods[period] then
								local expAt = questData.expiresAt or 0
								for _, q in ipairs(QuestConfig.Periods[period].quests) do
									local cur = questData.progress[q.id] or 0
									local claimed = questData.claimed and questData.claimed[q.id] == true
									if not claimed and cur >= q.target then
										claimQuestRE:FireServer(period, q.id, expAt)
										logger.Log(string.format("Auto Claimed %s Quest: %s", period, q.id),
											UI.Colors.successGreen)
										task.wait(0.2)
									end
								end
							end
						end
					end)
				end

				if cfg.autoBuyTicketShop and buyQuestRE and DataController then
					pcall(function()
						local inv = extractInventory(DataController.Inventory)
						local tickets = (inv and inv["Tickets"] and (inv["Tickets"].amount or 1)) or 0
						if tickets <= 0 and DataController.Inventory and DataController.Inventory.Tickets then
							local t = DataController.Inventory.Tickets()
							tickets = t and (t.amount or 1) or 0
						end

						if tickets > 0 then
							for itemName, isSelected in pairs(cfg.selectedTicketShopItems or {}) do
								if isSelected == true then
									local price = TICKET_SHOP_PRICES[itemName] or 1
									local isGamepass = (TICKET_SHOP_GAMEPASSES and TICKET_SHOP_GAMEPASSES[itemName] == true) or
										table.find(
											{ "Luck", "Ultra Luck", "More Cash", "Roll Speed", "More Grades",
												"More Traits" },
											itemName)
									local owned = false
									if isGamepass and DataController.OwnedGamepasses and DataController.OwnedGamepasses[itemName] then
										owned = (DataController.OwnedGamepasses[itemName]() == true)
									end
									if not owned and tickets >= price then
										buyQuestRE:FireServer(itemName)
										logger.Log(string.format("Auto Bought %s (%d Tickets)!", itemName, price),
											UI.Colors.successGreen)
										tickets = tickets - price
										task.wait(0.3)
									end
								end
							end
						end
					end)
				end

				if cfg.autoUseSpins and useSpinRE and DataController then
					pcall(function()
						local inv = extractInventory(DataController.Inventory)
						for spinName, isSelected in pairs(cfg.selectedSpins or {}) do
							if isSelected == true and inv and inv[spinName] then
								local amount = inv[spinName].amount or 1
								if amount > 0 then
									useSpinRE:FireServer(spinName)
									logger.Log(string.format("Auto Used %s! (luck applied to next roll)", spinName),
										UI.Colors.accentYellow)
									task.wait(0.5)
								end
							end
						end
					end)
				end

				if cfg.autoRebirth and DataController then
					pcall(function()
						local RebirthsModule = require(Features.Rebirth.Rebirths)
						local raw = (typeof(DataController) == "function" and DataController()) or
							(DataController and DataController.___X)
						local curRebirth = tonumber(raw and raw.Rebirth) or
							(DataController.Rebirth and tonumber(DataController.Rebirth())) or 0
						local nextRebirth = RebirthsModule.GetNext(curRebirth)
						local curMoney = tonumber(raw and raw.Money) or
							(DataController.Money and tonumber(DataController.Money())) or 0
						if nextRebirth and curMoney >= nextRebirth.cost then
							rebirthRE:FireServer()
							logger.Log("Triggered Rebirth!", UI.Colors.successGreen)
						end
					end)
				end

				task.wait(3.0)
			end
		end)
	end

	
	
	
	do
		local evTab = UI.Tabs.Halloween or UI.Tabs.Misc
		local CollectionService = game:GetService("CollectionService")

		local function evRemote(svc, kind, name)
			local s = Net:FindFirstChild(svc)
			local k = s and s:FindFirstChild(kind)
			return k and k:FindFirstChild(name)
		end
		local hTeleportRF = evRemote("HalloweenService", "RF", "Teleport")
		local hBuyOfferRE = evRemote("HalloweenService", "RE", "BuyOffer")
		local hClaimAllPathRE = evRemote("HalloweenService", "RE", "ClaimAllPath")
		local hQuestClaimRE = evRemote("HalloweenQuestService", "RE", "Claim")
		local pumpkinRollRF = evRemote("PumpkinDiceService", "RF", "Roll")
		local pumpkinAutoSellRE = evRemote("PumpkinDiceService", "RE", "SetAutoSell")
		local totKnockedRE = evRemote("TrickOrTreatService", "RE", "Knocked")

		local HalloweenShop, HalloweenQuests, PumpkinPass, PumpkinDice = nil, nil, nil, nil
		pcall(function()
			local hf = Features:FindFirstChild("Halloween")
			HalloweenShop = require(hf.HalloweenShop)
			HalloweenQuests = require(hf.HalloweenQuests)
			PumpkinPass = require(hf.PumpkinPass)
			PumpkinDice = require(hf.PumpkinDice)
		end)

		local PUMPKIN_COST = (PumpkinDice and PumpkinDice.COST) or 100
		local PUMPKIN_MULTI = (PumpkinDice and PumpkinDice.MULTI) or 5

		local function getAmt(name)
			local ok, v = pcall(function() return DataController.Inventory[name]() end)
			return (ok and type(v) == "table" and tonumber(v.amount)) or 0
		end

		local function getHalloween()
			local ok, v = pcall(function() return DataController.Halloween() end)
			return (ok and type(v) == "table") and v or nil
		end

		local function hTeleport(where)
			if not hTeleportRF then return false end
			local ok, res = pcall(function() return hTeleportRF:InvokeServer(where) end)
			return ok and res == true
		end

		
		local statSec = UI.CreateSection(evTab, "Halloween Stats", 1, true)
		local evStats = {
			candy = UI.CreateStatBox(statSec, "Candy", "0", 1),
			pumpkins = UI.CreateStatBox(statSec, "Pumpkins", "0", 2),
			floor = UI.CreateStatBox(statSec, "Haunted Best Floor", "0", 3),
			pass = UI.CreateStatBox(statSec, "Pumpkin Pass Candy Earned", "0", 4),
		}
		UI.CreateStatBox(statSec, "Haunted House", "Tower tab: Front Yard .. Catacombs .. The Abyss", 5)

		task.spawn(function()
			while scriptRunning do
				pcall(function()
					local H = getHalloween()
					evStats.candy.Set(formatNumber(getAmt("Candy")))
					evStats.pumpkins.Set(formatNumber(getAmt("Pumpkins")))
					if H then
						evStats.floor.Set(tostring(H.BestFloor or 0))
						evStats.pass.Set(formatNumber(H.CandyEarned or 0))
					end
				end)
				task.wait(2)
			end
		end)

		
		local totSec = UI.CreateSection(evTab, "Island & Trick-or-Treat", 2, true)

		UI.CreateButton(totSec, "Teleport to Halloween Island", function()
			logger.Log(hTeleport("Island") and "Teleported to Halloween Island." or "Island teleport failed.",
				UI.Colors.accentCyan)
		end, 1)

		UI.CreateButton(totSec, "Teleport to Hub", function()
			logger.Log(hTeleport("Hub") and "Teleported to Hub." or "Hub teleport failed.", UI.Colors.accentCyan)
		end, 2)

		Settings.CreateControl("autoTrickOrTreat", "CreateToggle", totSec, "Auto Trick-or-Treat", cfg.autoTrickOrTreat, function(v)
			cfg.autoTrickOrTreat = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		Settings.CreateControl("trickOrTreatMethod", "CreateDropdown", totSec, "Trick-or-Treat Method", { "Walk", "Teleport" }, cfg.trickOrTreatMethod or "Walk",
			function(v)
				cfg.trickOrTreatMethod = v
				if Settings and Settings.Save then Settings.Save() end
			end, 4)

		
		
		
		
		local function doorKey(part)
			local home = part:GetAttribute("TrickOrTreatHome")
			local p = typeof(home) == "CFrame" and home.Position or part.Position
			return string.format("%.1f,%.1f,%.1f", p.X, p.Y, p.Z)
		end
		local doorReadyAt = {}
		if totKnockedRE then
			totKnockedRE.OnClientEvent:Connect(function(part, _, readyAt)
				if part and tonumber(readyAt) then
					doorReadyAt[doorKey(part)] = tonumber(readyAt)
				end
			end)
		end

		local function flatDist(a, b)
			return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
		end

		
		
		
		
		local noclipSaved = {}
		local totFloorY, totLastGood = nil, nil
		RunService.Stepped:Connect(function()
			if not cfg.autoTrickOrTreat then return end
			local char = player.Character
			if not char then return end
			for _, p in ipairs(char:GetChildren()) do
				if p:IsA("BasePart") and p.CanCollide then
					noclipSaved[p] = true
					p.CanCollide = false
				end
			end
			local hum = char:FindFirstChildOfClass("Humanoid")
			local hrp = hum and hum.RootPart
			if not hrp or not totFloorY then return end
			local y = hrp.Position.Y
			if y < totFloorY - 6 and y > totFloorY - 500 then 
				local back = totLastGood and (totLastGood.Position - hrp.Position).Magnitude < 60 and totLastGood
					or CFrame.new(hrp.Position.X, totFloorY, hrp.Position.Z)
				hrp.CFrame = back + Vector3.new(0, 3, 0)
				hrp.AssemblyLinearVelocity = Vector3.zero
			elseif y >= totFloorY - 4 and hum.FloorMaterial ~= Enum.Material.Air then
				totLastGood = hrp.CFrame
			end
		end)
		local function restoreCollision()
			for p in pairs(noclipSaved) do
				if p.Parent then p.CanCollide = true end
			end
			table.clear(noclipSaved)
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true) end
		end

		
		
		
		local function walkTo(hum, hrp, pos, done)
			local bestD, progAt, moveAt = math.huge, os.clock(), 0
			hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			while cfg.autoTrickOrTreat and hum.Health > 0 do
				if done and done() then return true end
				local d = flatDist(pos, hrp.Position)
				if d <= 1 then return true end
				if d < bestD - 0.5 then bestD, progAt = d, os.clock() end
				if os.clock() - progAt > 4 then break end
				
				if os.clock() - moveAt > 1 then
					hum:MoveTo(pos)
					moveAt = os.clock()
				end
				task.wait()
			end
			return flatDist(pos, hrp.Position) <= 2
		end

		
		
		local HOP_STUDS, HOP_SPEED = 100, 45
		local function hopTo(hum, hrp, pos, done)
			local target = pos + Vector3.new(0, 3, 0)
			while cfg.autoTrickOrTreat and hum.Health > 0 do
				if done and done() then return true end
				local delta = target - hrp.Position
				local d = delta.Magnitude
				if d <= 1 then return true end
				local step = math.min(d, HOP_STUDS)
				hrp.CFrame = CFrame.new(hrp.Position + delta.Unit * step)
				hrp.AssemblyLinearVelocity = Vector3.zero
				task.wait(step / HOP_SPEED)
			end
			return flatDist(pos, hrp.Position) <= 2
		end

		task.spawn(function()
			while scriptRunning do
				if cfg.autoTrickOrTreat then
					pcall(function()
						local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
						local hrp = hum and hum.RootPart
						if not hrp or hum.Health <= 0 then return end

						
						
						local doors = CollectionService:GetTagged("TrickOrTreatDoor")
						local nearest = math.huge
						for _, d in ipairs(doors) do
							local home = d:GetAttribute("TrickOrTreatHome")
							if typeof(home) == "CFrame" then
								nearest = math.min(nearest, (home.Position - hrp.Position).Magnitude)
							end
						end
						if nearest > 400 then
							logger.Log(hTeleport("Island") and "Trick-or-Treat: teleported to Halloween Island."
								or "Trick-or-Treat: island teleport failed, retrying.", UI.Colors.accentCyan)
							task.wait(2)
							return
						end

						
						local now = workspace:GetServerTimeNow()
						local joinReady = player:GetAttribute("TrickOrTreatReadyAt") or 0
						local teleport = cfg.trickOrTreatMethod == "Teleport"
						local speed = teleport and HOP_SPEED or math.max(hum.WalkSpeed, 8)
						local best, bestArrive, bestLeaveIn, bestPoint = nil, math.huge, 0, nil
						for _, d in ipairs(doors) do
							local home, front = d:GetAttribute("TrickOrTreatHome"), d:GetAttribute("TrickOrTreatFront")
							if typeof(home) == "CFrame" and typeof(front) == "Vector3" then
								local point = home.Position + front * 6
								totFloorY = math.min(totFloorY or math.huge, point.Y)
								local travel = (point - hrp.Position).Magnitude / speed
								local readyIn = (doorReadyAt[doorKey(d)] or joinReady) - now
								local arrive = math.max(readyIn, travel)
								if arrive < bestArrive then
									best, bestArrive, bestLeaveIn, bestPoint = d, arrive, readyIn - travel, point
								end
							end
						end
						if not best then return end
						if bestLeaveIn > 0 then
							task.wait(math.min(bestLeaveIn, 1))
							return
						end

						local key = doorKey(best)
						local before = doorReadyAt[key]
						
						local function knocked() return doorReadyAt[key] ~= before end
						if (teleport and hopTo or walkTo)(hum, hrp, bestPoint, knocked) or flatDist(bestPoint, hrp.Position) < 8 then
							
							local t0 = os.clock()
							while doorReadyAt[key] == before and os.clock() - t0 < 3 do
								task.wait(0.05)
							end
						end
						if doorReadyAt[key] == before then
							doorReadyAt[key] = workspace:GetServerTimeNow() + 5
						end
					end)
					task.wait(0.1)
				else
					if next(noclipSaved) then restoreCollision() end
					task.wait(1)
				end
			end
		end)

		
		local diceSec = UI.CreateSection(evTab, "Pumpkin Dice", 3, true)

		Settings.CreateControl("pumpkinRollAmount", "CreateDropdown", diceSec, "Roll Amount", { "x1", "x" .. PUMPKIN_MULTI }, cfg.pumpkinRollAmount or "x5",
			function(v)
				cfg.pumpkinRollAmount = v
				if Settings and Settings.Save then Settings.Save() end
			end, 1)

		Settings.CreateControl("autoPumpkinDice", "CreateToggle", diceSec, "Auto Roll Pumpkin Dice", cfg.autoPumpkinDice, function(v)
			cfg.autoPumpkinDice = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		
		Settings.CreateControl("autoPumpkinDiceMoon", "CreateToggle", diceSec, "Auto Roll Pumpkin Dice on Haunted Night (Moon)", cfg.autoPumpkinDiceMoon, function(v)
			cfg.autoPumpkinDiceMoon = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		
		Settings.CreateControl("autoUseJackpotMoon", "CreateToggle", diceSec, "Auto Use Halloween Jackpots on Haunted Night (Moon)", cfg.autoUseJackpotMoon,
			function(v)
				cfg.autoUseJackpotMoon = v
				if Settings and Settings.Save then Settings.Save() end
			end, 4)

		local pumpkinUnitNames = {}
		for _, u in ipairs((PumpkinDice and PumpkinDice.Units) or {}) do
			table.insert(pumpkinUnitNames, u.id)
		end

		
		local function getServerAutoSell()
			local H = getHalloween()
			return (H and type(H.DiceAutoSell) == "table") and H.DiceAutoSell or {}
		end
		local initialAutoSell = {}
		for name, on in pairs(getServerAutoSell()) do
			initialAutoSell[name] = on == true
		end

		UI.CreateMultiDropdown(diceSec, "Pumpkin Units to Auto-Sell", pumpkinUnitNames, initialAutoSell, function(newMap)
			if not pumpkinAutoSellRE then return end
			task.spawn(function()
				local current = getServerAutoSell()
				for _, name in ipairs(pumpkinUnitNames) do
					local want = newMap[name] == true
					if (current[name] == true) ~= want then
						pcall(function() pumpkinAutoSellRE:FireServer(name, want) end)
						task.wait(0.25)
					end
				end
			end)
		end, 5)

		local function isHauntedNight()
			return WeatherTracker.Active and WeatherTracker.Name == "Haunted Night"
		end

		
		local HALLOWEEN_JACKPOTS = { "Witch's Jackpot", "Pumpkin Jackpot" }
		task.spawn(function()
			while scriptRunning do
				if cfg.autoUseJackpotMoon and useSpinRE and isHauntedNight() then
					pcall(function()
						local active = DataController.ActiveEntries() or {}
						for _, name in ipairs(HALLOWEEN_JACKPOTS) do
							if active[name] then return end
						end
						for _, name in ipairs(HALLOWEEN_JACKPOTS) do
							local item = DataController.Inventory[name]()
							if item and (item.amount or 0) > 0 then
								useSpinRE:FireServer(name)
								logger.Log(string.format("Haunted Night: Used %s (Left: %d)", name, item.amount - 1),
									UI.Colors.accentYellow)
								return
							end
						end
					end)
				end
				task.wait(1)
			end
		end)

		
		local moonPotionSec = UI.CreateSection(evTab, "Haunted Night Potions", 7, true)

		Settings.CreateControl("autoUsePotionMoon", "CreateToggle", moonPotionSec, "Auto Use Potions on Haunted Night (Moon)", cfg.autoUsePotionMoon, function(v)
			cfg.autoUsePotionMoon = v
			if Settings and Settings.Save then Settings.Save() end
		end, 1)

		Settings.CreateControl("moonPotions", "CreateMultiDropdown", moonPotionSec, "Potions to Use on Haunted Night", ALL_POTIONS, cfg.moonPotions,
			function(newMap)
				cfg.moonPotions = newMap
				if Settings and Settings.Save then Settings.Save() end
			end, 2)

		task.spawn(function()
			while scriptRunning do
				if cfg.autoUsePotionMoon and useBoostRE and isHauntedNight() then
					pcall(function()
						local inv = extractInventory(DataController.Inventory)
						local active = (DataController.ActiveEntries and DataController.ActiveEntries()) or {}
						local serverTime = workspace:GetServerTimeNow()
						for _, name in ipairs(ALL_POTIONS) do
							local item = cfg.moonPotions and cfg.moonPotions[name] == true and inv[name]
							local count = item and (item.amount or 1) or 0
							
							local act, running = active[name], false
							if typeof(act) == "number" then
								running = act > 1
							elseif typeof(act) == "table" and typeof(act.remaining) == "number" then
								local left = act.remaining
								if typeof(act.startedAt) == "number" then left = left - (serverTime - act.startedAt) end
								running = left > 1
							end
							if count > 0 and not running then
								useBoostRE:FireServer(name)
								logger.Log(string.format("Haunted Night: Used %s (Left: %d)", name, count - 1),
									UI.Colors.accentYellow)
								task.wait(0.15)
							end
						end
					end)
				end
				task.wait(2)
			end
		end)

		task.spawn(function()
			while scriptRunning do
				local moonOn = cfg.autoPumpkinDiceMoon and isHauntedNight()
				if (cfg.autoPumpkinDice or moonOn) and pumpkinRollRF then
					local count = (cfg.pumpkinRollAmount == "x1") and 1 or PUMPKIN_MULTI
					local have = getAmt("Pumpkins")
					if have < PUMPKIN_COST * count then
						count = 1
					end
					if have >= PUMPKIN_COST * count then
						local ok, res = pcall(function() return pumpkinRollRF:InvokeServer(count) end)
						if ok and type(res) == "table" and res.ok and type(res.results) == "table" then
							local names = {}
							for _, r in ipairs(res.results) do
								table.insert(names,
									tostring(r.name) .. (r.isNew and " (NEW)" or "") .. (r.sold and " (sold)" or ""))
							end
							logger.Log("Pumpkin Dice: " .. table.concat(names, ", "), UI.Colors.accentYellow)
						elseif ok and type(res) == "table" and res.message then
							logger.Log("Pumpkin Dice: " .. tostring(res.message), UI.Colors.dangerRed)
							task.wait(8)
						end
					end
					task.wait(2.1) 
				else
					task.wait(1)
				end
			end
		end)

		
		local shopSec = UI.CreateSection(evTab, "Candy Shop", 4, true)
		local shopNames = {}
		for _, offer in ipairs(HalloweenShop or {}) do
			table.insert(shopNames, offer.name)
		end

		Settings.CreateControl("candyShopItems", "CreateMultiDropdown", shopSec, "Items to Auto Buy", shopNames, cfg.candyShopItems or {}, function(newMap)
			cfg.candyShopItems = newMap
			if Settings and Settings.Save then Settings.Save() end
		end, 1)

		Settings.CreateControl("autoBuyCandyShop", "CreateToggle", shopSec, "Auto Buy Candy Shop", cfg.autoBuyCandyShop, function(v)
			cfg.autoBuyCandyShop = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		task.spawn(function()
			while scriptRunning do
				if cfg.autoBuyCandyShop and hBuyOfferRE and HalloweenShop then
					pcall(function()
						for i, offer in ipairs(HalloweenShop) do
							if (cfg.candyShopItems or {})[offer.name] == true and getAmt("Candy") >= offer.candy then
								hBuyOfferRE:FireServer(i)
								logger.Log(string.format("Candy Shop: bought %s (%s Candy)", offer.name,
									formatNumber(offer.candy)), UI.Colors.successGreen)
								task.wait(1.2) 
							end
						end
					end)
				end
				task.wait(2)
			end
		end)

		
		
		do
			local hBuyUpgradeRE = evRemote("HalloweenService", "RE", "BuyUpgrade")
			local CandyUpgrades = nil
			pcall(function() CandyUpgrades = require(Features.Halloween.CandyUpgrades) end)
			local upgNames = {}
			for _, u in ipairs((CandyUpgrades and CandyUpgrades.List) or {}) do
				table.insert(upgNames, u.title)
			end

			local upgSec = UI.CreateSection(evTab, "Candy Upgrades", 5, true)
			Settings.CreateControl("autoBuyCandyUpgrades", "CreateToggle", upgSec, "Auto Buy Candy Upgrades", cfg.autoBuyCandyUpgrades, function(v)
				cfg.autoBuyCandyUpgrades = v
				if Settings and Settings.Save then Settings.Save() end
			end, 1)

			
			
			Settings.CreateControl("candyUpgradeFocusSet", "CreateMultiDropdown", upgSec, "Focus Upgrades (empty = cheapest of all)", upgNames,
				cfg.candyUpgradeFocusSet or {}, function(newMap)
					cfg.candyUpgradeFocusSet = newMap
					if Settings and Settings.Save then Settings.Save() end
				end, 2)

			local nextBox = UI.CreateStatBox(upgSec, "Next Upgrade", "-", 3)

			task.spawn(function()
				while scriptRunning do
					if cfg.autoBuyCandyUpgrades and hBuyUpgradeRE and CandyUpgrades then
						pcall(function()
							local function cheapest(onlyFocus)
								local best, bestCost, bestLvl = nil, math.huge, 0
								for _, u in ipairs(CandyUpgrades.List) do
									if not onlyFocus or (cfg.candyUpgradeFocusSet or {})[u.title] == true then
										local lvl = DataController.CandyUpgrades[u.id]() or 0
										local cost = CandyUpgrades.GetCost(u, lvl + 1)
										if lvl < u.maxLevel and cost < bestCost then
											best, bestCost, bestLvl = u, cost, lvl
										end
									end
								end
								return best, bestCost, bestLvl
							end
							local best, bestCost, bestLvl = cheapest(true)
							if not best then best, bestCost, bestLvl = cheapest(false) end
							local candy = getAmt("Candy")
							nextBox.Set(best and string.format("%s Lv%d - %s/%s Candy", best.title, bestLvl + 1,
								formatNumber(candy), formatNumber(bestCost)) or "All maxed")
							if best and candy >= bestCost then
								hBuyUpgradeRE:FireServer(best.id)
								logger.Log(
								string.format("Candy Upgrade: %s -> Lv %d (%s Candy)", best.title, bestLvl + 1,
									formatNumber(bestCost)), UI.Colors.successGreen)
								task.wait(1.2)
							end
						end)
					end
					task.wait(2)
				end
			end)
		end

		
		
		
		do
			local exchangeRE = Net:FindFirstChild("ExchangeService") and Net.ExchangeService:FindFirstChild("RE") and
				Net.ExchangeService.RE:FindFirstChild("Exchange")
			local recipes = {}
			pcall(function() recipes = require(Features.Exchange.ExchangeConfig).recipes end)
			local recipeNames = {}
			for _, r in ipairs(recipes) do
				table.insert(recipeNames, string.format("%d %s -> %s", r.cost, r.input, r.output))
			end

			local function spinAmt(name)
				local ok, v = pcall(function() return DataController.Inventory[name]() end)
				return (ok and type(v) == "table" and tonumber(v.amount)) or 0
			end

			
			local function runExchange(selected)
				local char = player.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local zone = workspace:FindFirstChild("Zones") and workspace.Zones:FindFirstChild("Exchange")
				if not (exchangeRE and hrp and zone) then return 0 end
				local todo = false
				for i, r in ipairs(recipes) do
					if selected[recipeNames[i]] == true and spinAmt(r.input) >= r.cost then todo = true end
				end
				if not todo then return 0 end

				local back = hrp.CFrame
				if (hrp.Position - zone.Position).Magnitude > 1000 then
					
					pcall(function() ReplicatedStorage.Network.HalloweenService.RF.Teleport:InvokeServer("Hub") end)
					task.wait(1)
					back = nil
				end
				char:PivotTo(CFrame.new(zone.Position.X, zone.Position.Y - zone.Size.Y / 2 + 5, zone.Position.Z))
				task.wait(0.4)
				local crafted = 0
				for i, r in ipairs(recipes) do
					if selected[recipeNames[i]] == true then
						local n = math.floor(spinAmt(r.input) / r.cost)
						for _ = 1, n do
							exchangeRE:FireServer(i)
							crafted = crafted + 1
							task.wait(0.3)
						end
						if n > 0 then
							logger.Log(string.format("Exchange: %d %s -> %d %s", n * r.cost, r.input, n, r.output),
								UI.Colors.successGreen)
							task.wait(0.5) 
						end
					end
				end
				if back and char.Parent then char:PivotTo(back) end
				return crafted
			end

			local exSec = UI.CreateSection(evTab, "Exchange Machine", 8, true)

			Settings.CreateControl("exchangeRecipes", "CreateMultiDropdown", exSec, "Recipes to Auto Exchange", recipeNames, cfg.exchangeRecipes or {},
				function(newMap)
					cfg.exchangeRecipes = newMap
					if Settings and Settings.Save then Settings.Save() end
				end, 1)

			Settings.CreateControl("autoExchangeSpins", "CreateToggle", exSec, "Auto Exchange Spins (Lucky -> Jackpot -> Mega -> Grand)", cfg.autoExchangeSpins,
				function(v)
					cfg.autoExchangeSpins = v
					if Settings and Settings.Save then Settings.Save() end
				end, 2)

			UI.CreateButton(exSec, "Exchange Selected Now", function()
				task.spawn(function()
					local ok, n = pcall(runExchange, cfg.exchangeRecipes or {})
					if not ok or n == 0 then
						logger.Log("Exchange: nothing to craft (check recipes / spin counts).", UI.Colors.textMuted)
					end
				end)
			end, 3)

			task.spawn(function()
				while scriptRunning do
					if cfg.autoExchangeSpins then
						pcall(runExchange, cfg.exchangeRecipes or {})
					end
					task.wait(10)
				end
			end)
		end

		
		local claimSec = UI.CreateSection(evTab, "Halloween Quests & Pumpkin Pass", 6, true)

		Settings.CreateControl("autoClaimHalloweenQuests", "CreateToggle", claimSec, "Auto Claim Halloween Quests", cfg.autoClaimHalloweenQuests, function(v)
			cfg.autoClaimHalloweenQuests = v
			if Settings and Settings.Save then Settings.Save() end
		end, 1)

		Settings.CreateControl("autoClaimPumpkinPass", "CreateToggle", claimSec, "Auto Claim Pumpkin Pass", cfg.autoClaimPumpkinPass, function(v)
			cfg.autoClaimPumpkinPass = v
			if Settings and Settings.Save then Settings.Save() end
		end, 2)

		local function claimHalloweenQuests()
			local H = getHalloween()
			if not (H and hQuestClaimRE and HalloweenQuests) then return 0 end
			local count = 0
			for _, period in ipairs(HalloweenQuests.PERIODS or {}) do
				local def = HalloweenQuests[period]
				local data = def and H[def.dataKey]
				if data and type(data.ids) == "table" then
					for _, id in ipairs(data.ids) do
						local q = nil
						for _, p in ipairs(def.pool) do
							if p.id == id then
								q = p
								break
							end
						end
						local prog = (data.progress and data.progress[id]) or 0
						if q and not (data.claimed and data.claimed[id]) and prog >= q.target then
							hQuestClaimRE:FireServer(period, id)
							count = count + 1
							logger.Log(string.format("Halloween %s Quest claimed: %s", period, q.title or id),
								UI.Colors.successGreen)
							task.wait(0.3)
						end
					end
				end
			end
			return count
		end

		local function claimPumpkinPass()
			local H = getHalloween()
			if not (H and hClaimAllPathRE and PumpkinPass) then return false end
			local earned = tonumber(H.CandyEarned) or 0
			for i, tier in ipairs(PumpkinPass) do
				if earned < tier.candy then break end
				local key = tostring(i)
				local freeLeft = not (H.PathClaimed and H.PathClaimed[key])
				local premLeft = H.PathPremium == true and not (H.PathPremiumClaimed and H.PathPremiumClaimed[key])
				if freeLeft or premLeft then
					hClaimAllPathRE:FireServer()
					logger.Log("Pumpkin Pass: claimed all unlocked tiers.", UI.Colors.successGreen)
					return true
				end
			end
			return false
		end

		UI.CreateButton(claimSec, "Claim Quests + Pass Now", function()
			local n = claimHalloweenQuests()
			local passed = claimPumpkinPass()
			if n == 0 and not passed then
				logger.Log("Nothing to claim for Halloween right now.", UI.Colors.textMuted)
			end
		end, 3)

		task.spawn(function()
			while scriptRunning do
				if cfg.autoClaimHalloweenQuests then
					pcall(claimHalloweenQuests)
				end
				if cfg.autoClaimPumpkinPass then
					pcall(claimPumpkinPass)
				end
				task.wait(5)
			end
		end)
	end

	
	
	
	do
		local miscTab = UI.Tabs.Misc
		local playerSec = UI.CreateSection(miscTab, "Movement Modifications", 3, true)

		local function applySpeed()
			pcall(function()
				local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.WalkSpeed = cfg.walkSpeedEnabled and cfg.walkSpeedValue or 16
				end
			end)
		end

		local function applyJump()
			pcall(function()
				local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.UseJumpPower = true
					hum.JumpPower = cfg.jumpPowerEnabled and cfg.jumpPowerValue or 50
				end
			end)
		end

		Settings.CreateControl("walkSpeedEnabled", "CreateToggle", playerSec, "Enable Custom WalkSpeed", cfg.walkSpeedEnabled, function(v)
			cfg.walkSpeedEnabled = v
			if Settings and Settings.Save then Settings.Save() end
			applySpeed()
		end, 1)

		Settings.CreateControl("walkSpeedValue", "CreateSlider", playerSec, "WalkSpeed Value", 16, 200, cfg.walkSpeedValue, function(v)
			cfg.walkSpeedValue = v
			if Settings and Settings.Save then Settings.Save() end
			applySpeed()
		end, 2)

		Settings.CreateControl("jumpPowerEnabled", "CreateToggle", playerSec, "Enable Custom JumpPower", cfg.jumpPowerEnabled, function(v)
			cfg.jumpPowerEnabled = v
			if Settings and Settings.Save then Settings.Save() end
			applyJump()
		end, 3)

		Settings.CreateControl("jumpPowerValue", "CreateSlider", playerSec, "JumpPower Value", 50, 300, cfg.jumpPowerValue, function(v)
			cfg.jumpPowerValue = v
			if Settings and Settings.Save then Settings.Save() end
			applyJump()
		end, 4)

		Settings.CreateControl("infiniteJump", "CreateToggle", playerSec, "Infinite Jump", cfg.infiniteJump, function(v)
			cfg.infiniteJump = v
			if Settings and Settings.Save then Settings.Save() end
		end, 5)

		UserInputService.JumpRequest:Connect(function()
			if cfg.infiniteJump and player.Character then
				local hum = player.Character:FindFirstChildOfClass("Humanoid")
				if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
			end
		end)

		local perfSec = UI.CreateSection(miscTab, "Performance & Utilities", 4, true)

		
		local function purgeGameAfkScript()
			pcall(function()
				local ps = player:FindFirstChild("PlayerScripts")
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
			if typeof(hookfunction) == "function" then
				pcall(function()
					local oldTeleport
					oldTeleport = hookfunction(TeleportService.Teleport, function(self, placeId, ...)
						if cfg.antiAfk and self == TeleportService and (placeId == game.PlaceId or placeId == nil) then
							return nil
						end
						return oldTeleport(self, placeId, ...)
					end)
				end)
				pcall(function()
					local oldKick
					oldKick = hookfunction(player.Kick, function(self, message, ...)
						if cfg.antiAfk and self == player then
							local msg = tostring(message or ""):lower()
							if msg:find("afk") or msg:find("idle") or msg:find("inactive") or msg == "" then
								return nil
							end
						end
						return oldKick(self, message, ...)
					end)
				end)
			end

			if typeof(hookmetamethod) == "function" then
				pcall(function()
					local oldNamecall
					oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
						local method = getnamecallmethod()
						if cfg.antiAfk then
							if method == "Teleport" and self == TeleportService then
								local args = { ... }
								if args[1] == game.PlaceId or args[1] == nil then
									return nil
								end
							elseif (method == "Kick" or method == "kick") and self == player then
								local args = { ... }
								local msg = tostring(args[1] or ""):lower()
								if msg:find("afk") or msg:find("idle") or msg:find("inactive") or msg == "" then
									return nil
								end
							end
						end
						return oldNamecall(self, ...)
					end)
				end)
			end
		end

		pcall(hookTeleportAndKick)

		local function disableIdleConnections()
			pcall(function()
				local getconns = rawget(_G, "getconnections") or rawget(_G, "get_signal_cons")
					or (type(getconnections) == "function" and getconnections)

				if getconns then
					for _, conn in pairs(getconns(player.Idled)) do
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
				pcall(function() player:SetAttribute("AntiAfkIdleOverride", 99999999) end)
				runAntiAfkCycle()
			else
				pcall(function() player:SetAttribute("AntiAfkIdleOverride", nil) end)
			end
		end

		Settings.CreateControl("antiAfk", "CreateToggle", perfSec, "Anti-AFK (Multi-Layer & Keep Alive)", cfg.antiAfk, function(v)
			cfg.antiAfk = v
			if Settings and Settings.Save then Settings.Save() end
			applyAntiAfkState(v)
			if v then
				logger.Log("Anti-AFK active (Pure silent keep-alive).", UI.Colors.successGreen)
			else
				logger.Log("Anti-AFK disabled.", UI.Colors.textMuted)
			end
		end, 1)

		if cfg.antiAfk then
			applyAntiAfkState(true)
		end

		player.Idled:Connect(function()
			if cfg.antiAfk then
				runAntiAfkCycle()
				logger.Log("Anti-AFK cleared idle state.", UI.Colors.textSecondary)
			end
		end)

		
		pcall(function()
			local ps = player:WaitForChild("PlayerScripts", 10)
			if ps then
				ps.ChildAdded:Connect(function(child)
					if cfg.antiAfk and child:IsA("LocalScript") and (child.Name == "AFK" or string.find(string.lower(child.Name), "afk")) then
						task.defer(function()
							pcall(function() child:Destroy() end)
						end)
					end
				end)
			end
		end)

		
		task.spawn(function()
			while scriptRunning do
				task.wait(15)
				if not scriptRunning then break end
				if cfg.antiAfk then
					runAntiAfkCycle()
				end
			end
		end)

		
		pcall(function()
			local GuiService = game:GetService("GuiService")
			GuiService.ErrorMessageChanged:Connect(function(msg)
				if cfg.antiAfk and msg and msg ~= "" then
					task.wait(1.5)
					pcall(function()
						if GuiService.ClearError then
							GuiService:ClearError()
						end
					end)
					task.wait(1.5)
					pcall(function()
						local queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or
							(fluxus and fluxus.queue_on_teleport)
						if queue_on_teleport then
							pcall(function()
								queue_on_teleport(game:HttpGet("https://hiphub.vercel.app/api/script-roblox/da/main.lua"))
							end)
						end
						TeleportService:Teleport(game.PlaceId, player)
					end)
				end
			end)
		end)

		local fpsBoosterConn = nil
		local fpsAnimConnections = {}
		local POTATO_COLOR = Color3.fromRGB(210, 210, 215)

		local function suppressAnimator(animator)
			if not animator then return end
			pcall(function()
				for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
					pcall(function() track:Stop(0) end)
				end
				if not fpsAnimConnections[animator] then
					fpsAnimConnections[animator] = animator.AnimationPlayed:Connect(function(track)
						if cfg.fpsBooster then
							pcall(function() track:Stop(0) end)
						end
					end)
				end
			end)
		end

		local function killBalanceModel(bal)
			if not bal or bal.Name ~= "Balance" then return end
			pcall(function()
				for _, c in ipairs(bal:GetDescendants()) do
					if c:IsA("SurfaceGui") or c:IsA("BillboardGui") then
						c:Destroy()
					elseif c:IsA("BasePart") then
						c.Transparency = 1
						c.CastShadow = false
						c:GetPropertyChangedSignal("Transparency"):Connect(function()
							if cfg.fpsBooster then
								c.Transparency = 1
							end
						end)
					end
				end
			end)
		end

		local function flattenObject(obj)
			if not obj or not cfg.fpsBooster then return end
			pcall(function()
				if obj:IsA("Animator") or obj:IsA("AnimationController") then
					suppressAnimator(obj)
				elseif obj.Name == "Balance" and obj:IsA("Model") then
					killBalanceModel(obj)
				elseif obj:IsA("BasePart") then
					obj.Material = Enum.Material.SmoothPlastic
					obj.Color = POTATO_COLOR
					obj.CastShadow = false
					obj.Reflectance = 0
				end

				if obj:IsA("MeshPart") then
					obj.TextureID = ""
					obj.Color = POTATO_COLOR
					obj.Material = Enum.Material.SmoothPlastic
					obj.CastShadow = false
					obj.Reflectance = 0
				elseif obj:IsA("SpecialMesh") then
					obj.TextureId = ""
				elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
					pcall(function() obj.Transparency = 1 end)
					pcall(function() obj.Texture = "" end)
					obj:Destroy()
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Highlight") or obj:IsA("Light") then
					obj.Enabled = false
					obj:Destroy()
				elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
					local pg = player:FindFirstChild("PlayerGui")
					if not (pg and obj:IsDescendantOf(pg)) then
						obj.Enabled = false
						obj:Destroy()
					end
				end
			end)
		end

		local fpsBoosterLoopRunning = false
		local function runDaChunkedSweep()
			local allDescendants = workspace:GetDescendants()
			local count = 0
			for i = 1, #allDescendants do
				if not cfg.fpsBooster or not fpsBoosterLoopRunning then return end
				local obj = allDescendants[i]
				if obj then
					flattenObject(obj)
				end
				count = count + 1
				if count >= 60 then
					count = 0
					task.wait(0.03)
				end
			end
		end

		local function applyFpsBooster(enable)
			if not enable then
				fpsBoosterLoopRunning = false
				if fpsBoosterConn then
					pcall(function() fpsBoosterConn:Disconnect() end)
					fpsBoosterConn = nil
				end
				for _, conn in pairs(fpsAnimConnections) do
					pcall(function() conn:Disconnect() end)
				end
				fpsAnimConnections = {}
				return
			end

			fpsBoosterLoopRunning = true

			
			pcall(function()
				local setFn = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or
					(type(setfpscap) == "function" and setfpscap)
				if setFn then setFn(60) end
			end)
			pcall(function()
				settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
			end)
			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
			end)

			
			local Lighting = game:GetService("Lighting")
			pcall(function()
				Lighting.GlobalShadows = false
				Lighting.FogEnd = 9e9
				Lighting.Brightness = 1
				Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
				Lighting.Ambient = Color3.fromRGB(150, 150, 150)
				for _, effect in ipairs(Lighting:GetDescendants()) do
					if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Clouds") then
						effect.Enabled = false
					end
				end
			end)

			
			pcall(function()
				local terrain = workspace:FindFirstChildOfClass("Terrain")
				if terrain then
					terrain.WaterWaveSize = 0
					terrain.WaterWaveSpeed = 0
					terrain.WaterReflectance = 0
					terrain.WaterTransparency = 0
					terrain.Decoration = false
				end
			end)

			
			pcall(function()
				for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
					if v.Name == "Balance" and v:IsA("Model") then
						killBalanceModel(v)
					end
				end
			end)

			
			task.spawn(function()
				runDaChunkedSweep()

				while cfg.fpsBooster and fpsBoosterLoopRunning do
					task.wait(10)
					if not cfg.fpsBooster or not fpsBoosterLoopRunning then break end
					runDaChunkedSweep()
				end
			end)
		end

		
		local hideMoneyConn = nil
		local function applyHideFloatingMoney(enable)
			if not enable then
				if hideMoneyConn then
					pcall(function() hideMoneyConn:Disconnect() end)
					hideMoneyConn = nil
				end
				return
			end

			
			pcall(function()
				local pg = player:FindFirstChild("PlayerGui")
				local root = pg and pg:FindFirstChild("Root")
				if root then
					for _, child in ipairs(root:GetChildren()) do
						if child.Name == "Cash" and child:IsA("CanvasGroup") then
							child.Visible = false
							child:Destroy()
						end
					end
				end
			end)

			
			pcall(function()
				local debris = workspace:FindFirstChild("Debris")
				if debris then
					for _, child in ipairs(debris:GetChildren()) do
						if child.Name == "Money" or child:FindFirstChild("MoneyBillboard") then
							child:Destroy()
						end
					end
				end
			end)

			
			if not hideMoneyConn then
				task.spawn(function()
					local pg = player:WaitForChild("PlayerGui", 10)
					local root = pg and pg:WaitForChild("Root", 10)
					if root then
						hideMoneyConn = root.ChildAdded:Connect(function(child)
							if cfg.hideFloatingMoney and child.Name == "Cash" and child:IsA("CanvasGroup") then
								child.Visible = false
								task.defer(function()
									if child and child.Parent then
										child:Destroy()
									end
								end)
							end
						end)
					end
				end)
			end
		end

		Settings.CreateControl("hideFloatingMoney", "CreateToggle", perfSec, "Hide Floating Money FX", cfg.hideFloatingMoney, function(v)
			cfg.hideFloatingMoney = v
			if Settings and Settings.Save then Settings.Save() end
			applyHideFloatingMoney(v)
			if v then
				logger.Log("Floating Money FX hidden (Clean screen).", UI.Colors.successGreen)
			else
				logger.Log("Floating Money FX restored.", UI.Colors.textMuted)
			end
		end, 2)

		if cfg.hideFloatingMoney then
			task.spawn(function()
				applyHideFloatingMoney(true)
			end)
		end

		Settings.CreateControl("fpsBooster", "CreateToggle", perfSec, "FPS Booster (Reduce Graphics)", cfg.fpsBooster, function(v)
			cfg.fpsBooster = v
			if Settings and Settings.Save then Settings.Save() end
			applyFpsBooster(v)
			if v then
				logger.Log("FPS Booster activated (ultra potato + animation freeze).", UI.Colors.successGreen)
			else
				logger.Log("FPS Booster deactivated.", UI.Colors.textMuted)
			end
		end, 3)

		if cfg.fpsBooster then
			task.spawn(function()
				applyFpsBooster(true)
			end)
		end

		local function applyFpsCap(enabled, fps)
			local setCap = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or
				(type(setfpscap) == "function" and setfpscap)
			if setCap then
				if enabled then
					pcall(setCap, fps or 3)
				else
					pcall(setCap, cfg.unlockFps and 999 or 60)
				end
			end
		end

		local capFps3Toggle
		local capFps15Toggle

		capFps3Toggle = Settings.CreateControl("capFps3", "CreateToggle", perfSec, "Cap FPS to 3 (Extreme CPU Saver)", cfg.capFps3, function(v)
			cfg.capFps3 = v
			if v then
				cfg.capFps15 = false
				if capFps15Toggle and capFps15Toggle.Set then capFps15Toggle.Set(false) end
			end
			if Settings and Settings.Save then Settings.Save() end
			if v then
				applyFpsCap(true, 3)
				logger.Log("FPS capped to 3 (Extreme CPU Saver active).", UI.Colors.successGreen)
			else
				applyFpsCap(false)
				logger.Log("FPS cap restored.", UI.Colors.textMuted)
			end
		end, 4)

		capFps15Toggle = Settings.CreateControl("capFps15", "CreateToggle", perfSec, "Cap FPS to 15 (CPU Saver)", cfg.capFps15, function(v)
			cfg.capFps15 = v
			if v then
				cfg.capFps3 = false
				if capFps3Toggle and capFps3Toggle.Set then capFps3Toggle.Set(false) end
			end
			if Settings and Settings.Save then Settings.Save() end
			if v then
				applyFpsCap(true, 15)
				logger.Log("FPS capped to 15 (CPU Saver active).", UI.Colors.successGreen)
			else
				applyFpsCap(false)
				logger.Log("FPS cap restored.", UI.Colors.textMuted)
			end
		end, 5)

		Settings.CreateControl("blackScreen", "CreateToggle", perfSec, "Black Screen (GPU Saver)", cfg.blackScreen, function(v)
			cfg.blackScreen = v
			if Settings and Settings.Save then Settings.Save() end
			pcall(function()
				RunService:Set3dRenderingEnabled(not v)
			end)
			logger.Log("3D Rendering set to: " .. tostring(not v), UI.Colors.textSecondary)
		end, 6)

		UI.CreateButton(perfSec, "Unlock FPS (999 Cap)", function()
			cfg.capFps3 = false
			cfg.capFps15 = false
			cfg.unlockFps = true
			if capFps3Toggle and capFps3Toggle.Set then capFps3Toggle.Set(false) end
			if capFps15Toggle and capFps15Toggle.Set then capFps15Toggle.Set(false) end
			if Settings and Settings.Save then Settings.Save() end
			local setCap = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or
				(type(setfpscap) == "function" and setfpscap)
			if setCap then
				pcall(setCap, 999)
				logger.Log("FPS unlocked to 999.", UI.Colors.successGreen)
			end
		end, 7)

		if cfg.capFps3 then
			task.spawn(function()
				applyFpsCap(true, 3)
			end)
		elseif cfg.capFps15 then
			task.spawn(function()
				applyFpsCap(true, 15)
			end)
		end

		player.CharacterAdded:Connect(function()
			task.wait(0.5)
			applySpeed()
			applyJump()
			if cfg.antiAfk then
				applyAntiAfkState(true)
			end
		end)
	end

	
	
	
	do
		local hookTab = UI.Tabs.Misc or UI.Tabs.Webhook
		local hookSec = UI.CreateSection(hookTab, "Discord Notifications", 5, true)

		Settings.CreateControl("webhookEnabled", "CreateToggle", hookSec, "Enable Webhook", cfg.webhookEnabled, function(v)
			cfg.webhookEnabled = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Discord Webhook enabled.", UI.Colors.successGreen) end
		end, 1)

		Settings.CreateControl("webhookUrl", "CreateTextBox", hookSec, "Webhook URL", cfg.webhookUrl, "https://discord.com/api/webhooks/...", function(v)
			cfg.webhookUrl = v
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Webhook URL updated.", UI.Colors.textSecondary)
		end, 2)

		Settings.CreateControl("webhookNotifyRare", "CreateToggle", hookSec, "Notify on Unit Pulls", cfg.webhookNotifyRare, function(v)
			cfg.webhookNotifyRare = v
			if Settings and Settings.Save then Settings.Save() end
		end, 3)

		Settings.CreateControl("webhookUnitPullMode", "CreateDropdown", hookSec, "Unit Pull Filter Condition", { "Above (>=)", "Below (<=)", "All Pulls" },
			cfg.webhookUnitPullMode or "Above (>=)", function(v)
				cfg.webhookUnitPullMode = v
				if Settings and Settings.Save then Settings.Save() end
			end, 4)

		Settings.CreateControl("webhookUnitPullThreshold", "CreateTextBox", hookSec, "Pull Chance Threshold", cfg.webhookUnitPullThreshold or "1 in 10t", "e.g. 1 in 10t",
			function(v)
				cfg.webhookUnitPullThreshold = v
				if Settings and Settings.Save then Settings.Save() end
				logger.Log("Webhook pull threshold set to: " .. tostring(v), UI.Colors.textSecondary)
			end, 5)

		Settings.CreateControl("webhookNotifyTower", "CreateToggle", hookSec, "Notify on Tower Completions", cfg.webhookNotifyTower, function(v)
			cfg.webhookNotifyTower = v
			if Settings and Settings.Save then Settings.Save() end
		end, 6)

		Settings.CreateControl("webhookNotifyGems", "CreateToggle", hookSec, "Notify on Gem Gains", cfg.webhookNotifyGems, function(v)
			cfg.webhookNotifyGems = v
			if Settings and Settings.Save then Settings.Save() end
		end, 7)

		Settings.CreateControl("webhookNotifyTraitPot", "CreateToggle", hookSec, "Notify on Trait Potion Drops", cfg.webhookNotifyTraitPot, function(v)
			cfg.webhookNotifyTraitPot = v
			if Settings and Settings.Save then Settings.Save() end
		end, 8)

		Settings.CreateControl("webhookNotifyWeather", "CreateToggle", hookSec, "Notify on Weather Events", cfg.webhookNotifyWeather, function(v)
			cfg.webhookNotifyWeather = v
			if Settings and Settings.Save then Settings.Save() end
			if v then logger.Log("Weather Event Webhook notifications enabled.", UI.Colors.accentCyan) end
		end, 9)

		UI.CreateButton(hookSec, "Send Test Webhook Message", function()
			sendWebhook(
				"HipHub Webhook Test",
				"Connection successfully verified from Anime Dice script!",
				{
					{ name = "Player", value = player.Name,          inline = true },
					{ name = "Status", value = "Online & Connected", inline = true }
				},
				65535
			)
			logger.Log("Sent test webhook ping.", UI.Colors.accentCyan)
		end, 7)
	end

	
	
	
	do
		local setTab = UI.Tabs.Misc or UI.Tabs.Settings
		local setSec = UI.CreateSection(setTab, "Configuration Management", 6, true)

		UI.CreateButton(setSec, "Save Current Settings", function()
			if Settings and Settings.Save then Settings.Save() end
			logger.Log("Settings saved to HipHub/AnimeDice/config.json", UI.Colors.successGreen)
		end, 1)

		UI.CreateButton(setSec, "Reload Settings from File", function()
			if Settings and Settings.Load then Settings.Load() end
			logger.Log("Reloaded configuration from disk.", UI.Colors.accentCyan)
		end, 2)

		UI.CreateButton(setSec, "Reset Settings to Defaults", function()
			if Settings and Settings.Reset then Settings.Reset() end
			logger.Log("Settings reset to defaults.", UI.Colors.dangerRed)
		end, 3)

		local uiKeySec = UI.CreateSection(setTab, "UI Controls & Info", 7, true)
		UI.CreateStatBox(uiKeySec, "Window Controls", "Topbar Buttons / Floating Orb", 1)
		UI.CreateStatBox(uiKeySec, "Script Version", "HipHub v1.0 - Anime Dice", 2)
	end

	
	
	
	task.spawn(function()
		local serverJoinTime = math.floor(os.time() - workspace.DistributedGameTime)
		_G.daProcessedCommandIds = _G.daProcessedCommandIds or {}
		_G.daPendingAckCommands = _G.daPendingAckCommands or {}
		_G.daCommandQueue = _G.daCommandQueue or {}
		_G.daIsProcessingCommandQueue = _G.daIsProcessingCommandQueue or false

		local function getTelemetryData()
			local telemetry = {
				sheckles = "0",
				inventory = {
					Game = "Anime Dice",
					Version = "v1.0",
					Rebirth = 0,
					Dice = "Basic",
					TotalRolls = 0,
					Gems = 0,
					TraitPotions = 0,
					Tickets = 0,
					ResetTokens = 0,
					UnitCount = 0,
					ItemCount = 0,
					Units = {},
					Items = {},
					Slots = {},
					TowerTeam = {},
					OwnedDice = {},
					UpgradesCount = 0,
					SessionRolls = totalSessionRolls or 0,
					ActiveTower = inTowerActive and tostring(currentActiveTowerName or "In Battle") or "None",
					ActiveWeather = WeatherTracker.Active and WeatherTracker.Name or "None",
					WeatherRemaining = WeatherTracker.Active and WeatherTracker.Remaining or 0,
					Toggles = {}
				}
			}

			pcall(function()
				local function safeGet(fnOrVal)
					if fnOrVal == nil then return nil end
					if typeof(fnOrVal) == "function" then
						local ok, res = pcall(fnOrVal)
						if ok then return res end
					elseif type(fnOrVal) == "table" then
						if getmetatable(fnOrVal) and getmetatable(fnOrVal).__call then
							local ok, res = pcall(fnOrVal)
							if ok then return res end
						end
						if fnOrVal.Get and type(fnOrVal.Get) == "function" then
							local ok, res = pcall(function() return fnOrVal:Get() end)
							if ok then return res end
						end
						if fnOrVal.getValue and type(fnOrVal.getValue) == "function" then
							local ok, res = pcall(function() return fnOrVal:getValue() end)
							if ok then return res end
						end
						if fnOrVal.___P and fnOrVal.___K then return nil end
					end
					return fnOrVal
				end

				local fullData = nil
				if DataController then
					if typeof(DataController) == "function" then
						pcall(function() fullData = DataController() end)
					elseif DataController.GetData and type(DataController.GetData) == "function" then
						pcall(function() fullData = DataController:GetData() end)
					end
				end

				local rawInv = (fullData and type(fullData.Inventory) == "table" and fullData.Inventory)
					or (DataController and DataController.Inventory and safeGet(DataController.Inventory))
					or (extractInventory and extractInventory(DataController and DataController.Inventory))
					or {}

				local slots = (fullData and type(fullData.Slots) == "table" and fullData.Slots)
					or (DataController and DataController.Slots and safeGet(DataController.Slots))
					or {}

				local towerTeam = (fullData and type(fullData.TowerTeam) == "table" and fullData.TowerTeam)
					or (DataController and DataController.TowerTeam and safeGet(DataController.TowerTeam))
					or {}

				local upgrades = (fullData and type(fullData.Upgrades) == "table" and fullData.Upgrades)
					or (DataController and DataController.Upgrades and safeGet(DataController.Upgrades))
					or {}

				local ownedDice = (fullData and type(fullData.OwnedDice) == "table" and fullData.OwnedDice)
					or (DataController and DataController.OwnedDice and safeGet(DataController.OwnedDice))
					or {}

				local rawMoney = (fullData and fullData.Money)
					or (DataController and DataController.Money and safeGet(DataController.Money))
				if rawMoney ~= nil then
					telemetry.sheckles = typeof(rawMoney) == "number" and string.format("%.0f", rawMoney) or tostring(rawMoney)
				end

				local rawRebirth = (fullData and fullData.Rebirth)
					or (DataController and DataController.Rebirth and safeGet(DataController.Rebirth))
				if rawRebirth ~= nil then
					telemetry.inventory.Rebirth = tonumber(rawRebirth) or 0
				end

				local rawDice = (fullData and fullData.Dice)
					or (DataController and DataController.Dice and safeGet(DataController.Dice))
				if rawDice ~= nil then
					telemetry.inventory.Dice = tostring(rawDice or "Basic")
				end

				local rawRolls = (fullData and fullData.Rolls)
					or (DataController and DataController.Rolls and safeGet(DataController.Rolls))
				if rawRolls ~= nil then
					telemetry.inventory.TotalRolls = tonumber(rawRolls) or 0
				end

				if getGemsCount then
					local g = getGemsCount()
					if g and g > 0 then telemetry.inventory.Gems = g end
				end
				if getTraitPotCount then
					local tp = getTraitPotCount()
					if tp and tp > 0 then telemetry.inventory.TraitPotions = tp end
				end

				
				local function getUnitCalc(unitName, attr)
					local stats = {
						rarity = "Common",
						chance = 0,
						chanceStr = "1 in 1",
						income = 0,
						incomeStr = "$0/s",
						damage = 0,
						damageStr = "0",
						health = 0,
						healthStr = "0"
					}
					if not unitName or not UnitConfig or not UnitConfig.entries or not UnitConfig.entries[unitName] then
						return stats
					end
					local entry = UnitConfig.entries[unitName]
					local a = attr or {}

					pcall(function()
						if entry.getRarity then
							stats.rarity = tostring(entry.getRarity(a))
						elseif entry.rarity then
							stats.rarity = tostring(entry.rarity)
						end
					end)

					pcall(function()
						if entry.chance then
							local c = entry.chance(a)
							if c then
								stats.chance = tonumber(c) or 0
								if NumberFormatter and NumberFormatter.FormatCompact then
									stats.chanceStr = "1 in " .. string.lower(NumberFormatter.FormatCompact(c))
								else
									stats.chanceStr = "1 in " .. tostring(c)
								end
							end
						end
					end)

					pcall(function()
						if entry.income then
							local inc = entry.income(a)
							if inc then
								stats.income = tonumber(inc) or 0
								if NumberFormatter and NumberFormatter.FormatCompact then
									stats.incomeStr = "$" .. string.lower(NumberFormatter.FormatCompact(inc)) .. "/s"
								else
									stats.incomeStr = "$" .. tostring(inc) .. "/s"
								end
							end
						end
					end)

					pcall(function()
						if entry.damage then
							local dmg = entry.damage(a)
							if dmg then
								stats.damage = tonumber(dmg) or 0
								if NumberFormatter and NumberFormatter.FormatCompact then
									stats.damageStr = string.lower(NumberFormatter.FormatCompact(dmg))
								else
									stats.damageStr = tostring(dmg)
								end
							end
						end
					end)

					pcall(function()
						if entry.health then
							local hp = entry.health(a)
							if hp then
								stats.health = tonumber(hp) or 0
								if NumberFormatter and NumberFormatter.FormatCompact then
									stats.healthStr = string.lower(NumberFormatter.FormatCompact(hp))
								else
									stats.healthStr = tostring(hp)
								end
							end
						end
					end)

					return stats
				end

				
				local unitList = {}
				local itemsList = {}

				for k, v in pairs(rawInv) do
					if typeof(v) == "table" and v.name then
						local keyStr = tostring(k)
						if (string.find(keyStr, "-") and string.len(keyStr) > 20) or (isUnitEntry and isUnitEntry(k, v)) then
							
							local isPlot = false
							local slotIdx = nil
							local slotBal = 0
							for sIndex, sData in pairs(slots) do
								if sData and sData.unitId == keyStr then
									isPlot = true
									slotIdx = tonumber(sIndex) or sIndex
									slotBal = tonumber(sData.balance) or 0
									break
								end
							end

							local isTower = false
							for _, tUnitId in pairs(towerTeam) do
								if tUnitId == keyStr then
									isTower = true
									break
								end
							end

							local uCalc = getUnitCalc(v.name, v.attributes)

							table.insert(unitList, {
								key = keyStr,
								name = tostring(v.name or "Unknown"),
								grade = tostring(v.attributes and v.attributes.grade or "None"),
								trait = tostring(v.attributes and v.attributes.trait or "None"),
								mutation = tostring(v.attributes and v.attributes.mutation or "None"),
								level = tonumber(v.attributes and v.attributes.level or 1) or 1,
								rarity = uCalc.rarity,
								chance = uCalc.chance,
								chanceStr = uCalc.chanceStr,
								income = uCalc.income,
								incomeStr = uCalc.incomeStr,
								damage = uCalc.damage,
								damageStr = uCalc.damageStr,
								health = uCalc.health,
								healthStr = uCalc.healthStr,
								locked = (v.attributes and v.attributes.locked == true),
								inPlot = isPlot,
								slotIndex = slotIdx,
								slotBalance = slotBal,
								inTower = isTower
							})
						elseif k ~= "Slots" and k ~= "TowerTeam" and k ~= "Upgrades" and k ~= "DiscoveredUnits" and k ~= "AutoSell" and k ~= "EquippedGear" and k ~= "ProtectedGrades" and k ~= "ProtectedTraits" and k ~= "TradeHistory" and k ~= "RedeemedCodes" and k ~= "ActiveEntries" and k ~= "Settings" and k ~= "Quests" then
							
							local cat = "Item"
							local rawItemName = tostring(v.name or k)
							local nameLower = string.lower(rawItemName)
							local isGear = (ALL_GEAR_NAMES and ALL_GEAR_NAMES[rawItemName] == true)
							if not isGear and EntryRegistry and EntryRegistry.getEntryConfig then
								pcall(function()
									local ec = EntryRegistry.getEntryConfig(rawItemName)
									if ec and ec.kind == "Gear" then isGear = true end
								end)
							end

							if isGear then
								cat = "Gear"
							elseif nameLower == "gems" then
								cat = "Currency"
								telemetry.inventory.Gems = tonumber(v.amount or 1) or 0
							elseif nameLower == "tickets" then
								cat = "Currency"
								telemetry.inventory.Tickets = tonumber(v.amount or 1) or 0
							elseif nameLower == "reset token" then
								cat = "Token"
								telemetry.inventory.ResetTokens = tonumber(v.amount or 1) or 0
							elseif nameLower == "trait reroll" or string.find(nameLower, "reroll") then
								cat = "Reroll Potion"
								telemetry.inventory.TraitPotions = tonumber(v.amount or 1) or 0
							elseif string.find(nameLower, "damage") then
								cat = "Damage Potion"
							elseif string.find(nameLower, "income") then
								cat = "Income Potion"
							elseif string.find(nameLower, "luck") then
								cat = "Luck Potion"
							end

							table.insert(itemsList, {
								id = keyStr,
								name = rawItemName,
								amount = tonumber(v.amount or 1) or 1,
								category = cat
							})
						end
					end
				end

				
				if telemetry.inventory.Gems == 0 and rawInv["Gems"] then
					telemetry.inventory.Gems = tonumber(rawInv["Gems"].amount or 1) or 0
				end
				if telemetry.inventory.TraitPotions == 0 and rawInv["Trait Reroll"] then
					telemetry.inventory.TraitPotions = tonumber(rawInv["Trait Reroll"].amount or 1) or 0
				end

				
				table.sort(itemsList, function(a, b)
					if a.category == "Gear" and b.category ~= "Gear" then return true end
					if b.category == "Gear" and a.category ~= "Gear" then return false end
					if a.category == "Currency" and b.category ~= "Currency" then return true end
					if b.category == "Currency" and a.category ~= "Currency" then return false end
					return a.amount > b.amount
				end)

				table.sort(unitList, function(a, b)
					if a.inPlot and not b.inPlot then return true end
					if b.inPlot and not a.inPlot then return false end
					return a.level > b.level
				end)

				telemetry.inventory.UnitCount = #unitList
				telemetry.inventory.Units = unitList
				telemetry.inventory.ItemCount = #itemsList
				telemetry.inventory.Items = itemsList

				
				local slotList = {}
				local totalPlotIncomePerSec = 0

				for sIdx = 1, 10 do
					local sData = slots[tostring(sIdx)] or slots[sIdx]
					if sData then
						local uName = "Empty"
						local uLevel = 1
						local uMutation = "None"
						local uGrade = "None"
						local uTrait = "None"
						local uRarity = "None"
						local uChance = 0
						local uChanceStr = "None"
						local uIncome = 0
						local uIncomeStr = "$0/s"
						local uDamage = 0
						local uDamageStr = "0"
						local uHealth = 0
						local uHealthStr = "0"

						if sData.unitId and rawInv and rawInv[sData.unitId] then
							local u = rawInv[sData.unitId]
							uName = tostring(u.name or "Unknown")
							uLevel = tonumber(u.attributes and u.attributes.level or 1) or 1
							uMutation = tostring(u.attributes and u.attributes.mutation or "None")
							uGrade = tostring(u.attributes and u.attributes.grade or "None")
							uTrait = tostring(u.attributes and u.attributes.trait or "None")

							local uCalc = getUnitCalc(u.name, u.attributes)
							uRarity = uCalc.rarity
							uChance = uCalc.chance
							uChanceStr = uCalc.chanceStr
							uIncome = uCalc.income
							uIncomeStr = uCalc.incomeStr
							uDamage = uCalc.damage
							uDamageStr = uCalc.damageStr
							uHealth = uCalc.health
							uHealthStr = uCalc.healthStr

							totalPlotIncomePerSec = totalPlotIncomePerSec + uIncome
						end

						table.insert(slotList, {
							slot = sIdx,
							unitId = sData.unitId,
							unitName = uName,
							level = uLevel,
							mutation = uMutation,
							grade = uGrade,
							trait = uTrait,
							rarity = uRarity,
							chance = uChance,
							chanceStr = uChanceStr,
							income = uIncome,
							incomeStr = uIncomeStr,
							damage = uDamage,
							damageStr = uDamageStr,
							health = uHealth,
							healthStr = uHealthStr,
							balance = tonumber(sData.balance) or 0
						})
					end
				end
				telemetry.inventory.Slots = slotList
				telemetry.inventory.TotalPlotIncome = totalPlotIncomePerSec
				if NumberFormatter and NumberFormatter.FormatCompact then
					telemetry.inventory.TotalPlotIncomeStr = "$" ..
						string.lower(NumberFormatter.FormatCompact(totalPlotIncomePerSec)) .. "/s"
				else
					telemetry.inventory.TotalPlotIncomeStr = "$" .. tostring(totalPlotIncomePerSec) .. "/s"
				end

				
				local towerTeamUnits = {}
				for _, tUnitId in pairs(towerTeam) do
					if rawInv and rawInv[tUnitId] then
						local u = rawInv[tUnitId]
						local uCalc = getUnitCalc(u.name, u.attributes)
						table.insert(towerTeamUnits, {
							key = tostring(tUnitId),
							name = tostring(u.name or "Unknown"),
							grade = tostring(u.attributes and u.attributes.grade or "None"),
							trait = tostring(u.attributes and u.attributes.trait or "None"),
							mutation = tostring(u.attributes and u.attributes.mutation or "None"),
							level = tonumber(u.attributes and u.attributes.level or 1) or 1,
							rarity = uCalc.rarity,
							chance = uCalc.chance,
							chanceStr = uCalc.chanceStr,
							income = uCalc.income,
							incomeStr = uCalc.incomeStr,
							damage = uCalc.damage,
							damageStr = uCalc.damageStr,
							health = uCalc.health,
							healthStr = uCalc.healthStr
						})
					end
				end
				telemetry.inventory.TowerTeam = towerTeamUnits

				
				local upgCount = 0
				local upgList = {}
				for uName, val in pairs(upgrades) do
					if val == true then
						upgCount = upgCount + 1
						table.insert(upgList, tostring(uName))
					end
				end
				telemetry.inventory.UpgradesCount = upgCount
				telemetry.inventory.Upgrades = upgList

				
				local diceList = {}
				for dName, val in pairs(ownedDice) do
					if val == true then table.insert(diceList, tostring(dName)) end
				end
				telemetry.inventory.OwnedDice = diceList

				
				local equippedGearMap = {}
				pcall(function()
					
					if x and type(x.EquippedGear) == "table" then
						for slotName, gName in pairs(x.EquippedGear) do
							if gName and gName ~= "" and tostring(gName) ~= "nil" then
								equippedGearMap[tostring(slotName)] = tostring(gName)
							end
						end
					end

					
					if DataController and DataController.EquippedGear then
						if typeof(DataController.EquippedGear) == "function" or (type(DataController.EquippedGear) == "table" and getmetatable(DataController.EquippedGear) and getmetatable(DataController.EquippedGear).__call) then
							local okCall, res = pcall(DataController.EquippedGear)
							if okCall and type(res) == "table" then
								for slotName, gName in pairs(res) do
									if gName and gName ~= "" and tostring(gName) ~= "nil" then
										equippedGearMap[tostring(slotName)] = tostring(gName)
									end
								end
							end
						end

						if type(DataController.EquippedGear) == "table" then
							for slotName, valFunc in pairs(DataController.EquippedGear) do
								local cur = nil
								if typeof(valFunc) == "function" then
									pcall(function() cur = valFunc() end)
								elseif type(valFunc) == "table" and type(getmetatable(valFunc)) == "table" and getmetatable(valFunc).__call then
									pcall(function() cur = valFunc() end)
								elseif type(valFunc) == "table" and valFunc.Get then
									pcall(function() cur = valFunc:Get() end)
								elseif type(valFunc) == "string" or type(valFunc) == "number" then
									cur = valFunc
								end
								if cur and cur ~= "" and tostring(cur) ~= "nil" then
									equippedGearMap[tostring(slotName)] = tostring(cur)
								end
							end
						end
					end

					
					if rawInv and type(rawInv.EquippedGear) == "table" then
						for slotName, gName in pairs(rawInv.EquippedGear) do
							if gName and gName ~= "" and tostring(gName) ~= "nil" and not equippedGearMap[tostring(slotName)] then
								equippedGearMap[tostring(slotName)] = tostring(gName)
							end
						end
					end
				end)
				telemetry.inventory.EquippedGear = equippedGearMap

				
				if #slotList > 0 and slotList[1].unitName ~= "Empty" then
					telemetry.inventory.EquippedUnit = {
						name = slotList[1].unitName,
						grade = slotList[1].grade,
						trait = slotList[1].trait,
						mutation = slotList[1].mutation,
						level = slotList[1].level,
						rarity = slotList[1].rarity,
						chanceStr = slotList[1].chanceStr,
						incomeStr = slotList[1].incomeStr,
						damageStr = slotList[1].damageStr,
						healthStr = slotList[1].healthStr
					}
				elseif #unitList > 0 then
					telemetry.inventory.EquippedUnit = {
						name = unitList[1].name,
						grade = unitList[1].grade,
						trait = unitList[1].trait,
						mutation = unitList[1].mutation,
						level = unitList[1].level,
						rarity = unitList[1].rarity,
						chanceStr = unitList[1].chanceStr,
						incomeStr = unitList[1].incomeStr,
						damageStr = unitList[1].damageStr,
						healthStr = unitList[1].healthStr
					}
				end

				
				telemetry.inventory.SessionRolls = totalSessionRolls or 0
				local reportedConfig = {}
				for key in pairs(Settings.Bindings) do reportedConfig[key] = cfg[key] end
				telemetry.inventory.Config = reportedConfig
				telemetry.inventory.ConfigSchema = Settings.Schema
				telemetry.inventory.ConfigResult = Settings.LastConfigResult
				telemetry.inventory.ActiveTower = inTowerActive and tostring(currentActiveTowerName or "In Battle") or
					"None"
				telemetry.inventory.Toggles = {
					autoRoll = (cfg.autoRoll == true),
					autoCollectBalance = (cfg.autoCollectBalance == true),
					autoPlayTower = (cfg.autoPlayTower == true),
					autoRollTrait = (cfg.autoRollTrait == true),
					autoRollGrade = (cfg.autoRollGrade == true),
					autoRollQuirk = (cfg.autoRollQuirk == true),
					bulkAutoRollAll = (cfg.bulkAutoRollAll == true),
					autoSell = (cfg.autoSell == true or cfg.autoSellCustom == true or cfg.autoSellByRarity == true),
					autoLock = (cfg.autoLockRare == true or cfg.autoLockCustom == true or cfg.autoLockMutated == true),
					antiAfk = (cfg.antiAfk == true)
				}
			end)

			return telemetry
		end

		local function executeSingleCommand(cmd)
			if typeof(cmd) ~= "table" then return end
			local action = tostring(cmd.action or cmd.type or ""):lower()

			if action == "notification" or action == "toast" or action == "alert" then
				local title = cmd.title or "HipHub Remote"
				local text = cmd.text or cmd.message or "Notification received."
				if UI.Notify then
					UI.Notify(title, text, UI.Colors.accentCyan, tonumber(cmd.duration) or 5)
				end
				logger.Log("[Remote Alert]: " .. text, UI.Colors.accentCyan)
			elseif action == "kick" or action == "disconnect" then
				pcall(function()
					player:Kick(cmd.reason or "Disconnected via HipHub Dashboard")
				end)
			elseif action == "teleport" or action == "rejoin" then
				pcall(function()
					if cmd.placeId and tonumber(cmd.placeId) then
						TeleportService:Teleport(tonumber(cmd.placeId), player)
					elseif game.JobId and game.JobId ~= "" then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
					else
						TeleportService:Teleport(game.PlaceId, player)
					end
				end)
			elseif action == "setconfig" then
				local applied, failure = Settings.ApplyPatch(cmd.settings)
				Settings.LastConfigResult = { id = tostring(cmd.id or ""), success = applied, error = failure }
				logger.Log(applied and "[Remote Config]: Web settings applied and saved." or
					("[Remote Config]: " .. tostring(failure)), applied and UI.Colors.successGreen or UI.Colors.dangerRed)
			elseif action == "settoggle" then
				if cmd.toggle and type(cfg[cmd.toggle]) == "boolean" then
					Settings.ApplyPatch({ [cmd.toggle] = cmd.value == true })
					logger.Log(string.format("[Remote Config]: Set %s = %s", tostring(cmd.toggle), tostring(cmd.value)),
						UI.Colors.accentViolet)
				end
			elseif action == "saveconfig" then
				if Settings and Settings.Save then
					Settings.Save()
					logger.Log("[Remote Config]: Configuration saved to disk.", UI.Colors.successGreen)
				end
			elseif action == "reloadconfig" then
				if Settings and Settings.Load then
					Settings.Load()
					logger.Log("[Remote Config]: Configuration reloaded from disk.", UI.Colors.accentCyan)
				end
			elseif action == "setmaxslotlevel" or action == "set_max_slot_level" then
				local lvl = tonumber(cmd.level or cmd.value or cmd.maxLevel or 0)
				if lvl then
					cfg.maxSlotLevel = math.max(0, math.floor(lvl))
					if Settings and Settings.Save then Settings.Save() end
					logger.Log(string.format("[Remote Config]: Set Max Slot Level = %d", cfg.maxSlotLevel),
						UI.Colors.accentViolet)
				end
			elseif action == "levelupslot" or action == "levelup_slot" or action == "upgrade_slot" or action == "upgrade_level" then
				pcall(function()
					local slotIdx = tonumber(cmd.slot or cmd.slotIndex or cmd.value or 1)
					local times = tonumber(cmd.count or cmd.times or 1) or 1
					if levelUpSlotRE and slotIdx then
						for _ = 1, math.min(times, 50) do
							levelUpSlotRE:FireServer(slotIdx)
							task.wait(0.04)
						end
						logger.Log(string.format("[Remote Command]: Leveled up Slot #%d (%d times)", slotIdx, times),
							UI.Colors.successGreen)
					end
				end)
			elseif action == "rolltrait" or action == "roll_trait" then
				pcall(function()
					local unitKey = cmd.unitKey or cmd.key
					if not unitKey or unitKey == "" then
						if cmd.slot or cmd.slotIndex then
							local sIdx = tostring(cmd.slot or cmd.slotIndex or 1)
							local ok, raw = pcall(function()
								return typeof(DataController) == "function" and DataController() or
									(DataController and DataController.___X)
							end)
							if ok and raw and raw.Slots and (raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]) then
								local sData = raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]
								unitKey = sData and sData.unitId
							end
						end
					end
					if not unitKey or unitKey == "" then
						unitKey = getActiveRollUnitKey()
					end

					local newMap = {}
					if cmd.targetTraits and type(cmd.targetTraits) == "table" then
						for k, v in pairs(cmd.targetTraits) do
							if type(k) == "number" then
								newMap[tostring(v)] = true
							elseif v == true then
								newMap[tostring(k)] = true
							end
						end
					elseif cmd.targetTrait and cmd.targetTrait ~= "" and cmd.targetTrait ~= "ANY" then
						newMap[tostring(cmd.targetTrait)] = true
					end

					if next(newMap) ~= nil then
						cfg.targetTraits = newMap
						local firstTrait = next(newMap)
						if firstTrait then cfg.targetTrait = tostring(firstTrait) end
					end

					if unitKey then
						cfg.selectedRollUnitKey = tostring(unitKey)
					end

					if cmd.autoRoll == true then
						cfg.autoRollTrait = true
						if autoRollTraitToggle and autoRollTraitToggle.Set then
							autoRollTraitToggle.Set(true)
						end
						if Settings and Settings.Save then Settings.Save() end
						logger.Log(string.format("[Remote Command]: Auto Trait Roll activated on %s", tostring(unitKey)),
							UI.Colors.successGreen)
					else
						
						local times = tonumber(cmd.times or cmd.count or 1) or 1
						if unitKey and rollTraitRE then
							for _ = 1, math.min(times, 10) do
								pcall(function()
									local pGui = player:FindFirstChild("PlayerGui")
									if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Traits") then
										local confirm = pGui.Root.Menus.Traits:FindFirstChild("ConfirmTrait")
										if confirm and confirm.Visible then confirm.Visible = false end
									end
								end)
								rollTraitRE:FireServer(unitKey, true)
								task.wait(0.12)
							end
							logger.Log(
								string.format("[Remote Command]: Fired %dx Trait Roll on %s", times, tostring(unitKey)),
								UI.Colors.accentCyan)
						end
						if Settings and Settings.Save then Settings.Save() end
					end
				end)
			elseif action == "rollgrade" or action == "roll_grade" then
				pcall(function()
					local unitKey = cmd.unitKey or cmd.key
					if not unitKey or unitKey == "" then
						if cmd.slot or cmd.slotIndex then
							local sIdx = tostring(cmd.slot or cmd.slotIndex or 1)
							local ok, raw = pcall(function()
								return typeof(DataController) == "function" and DataController() or
									(DataController and DataController.___X)
							end)
							if ok and raw and raw.Slots and (raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]) then
								local sData = raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]
								unitKey = sData and sData.unitId
							end
						end
					end
					if not unitKey or unitKey == "" then
						unitKey = getActiveRollUnitKey()
					end

					local newMap = {}
					if cmd.targetGrades and type(cmd.targetGrades) == "table" then
						for k, v in pairs(cmd.targetGrades) do
							if type(k) == "number" then
								newMap[tostring(v)] = true
							elseif v == true then
								newMap[tostring(k)] = true
							end
						end
					elseif cmd.targetGrade and cmd.targetGrade ~= "" and cmd.targetGrade ~= "ANY" then
						newMap[tostring(cmd.targetGrade)] = true
					end

					if next(newMap) ~= nil then
						cfg.targetGrades = newMap
						local firstGrade = next(newMap)
						if firstGrade then cfg.targetGrade = tostring(firstGrade) end
					end

					if unitKey then
						cfg.selectedRollUnitKey = tostring(unitKey)
					end

					if cmd.autoRoll == true then
						cfg.autoRollGrade = true
						if autoRollGradeToggle and autoRollGradeToggle.Set then
							autoRollGradeToggle.Set(true)
						end
						if Settings and Settings.Save then Settings.Save() end
						logger.Log(string.format("[Remote Command]: Auto Grade Roll activated on %s", tostring(unitKey)),
							UI.Colors.successGreen)
					else
						
						local times = tonumber(cmd.times or cmd.count or 1) or 1
						if unitKey and rollGradeRE then
							for _ = 1, math.min(times, 10) do
								pcall(function()
									local pGui = player:FindFirstChild("PlayerGui")
									if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Grades") then
										local confirm = pGui.Root.Menus.Grades:FindFirstChild("ConfirmGrade")
										if confirm and confirm.Visible then confirm.Visible = false end
									end
								end)
								rollGradeRE:FireServer(unitKey, true)
								task.wait(0.12)
							end
							logger.Log(
								string.format("[Remote Command]: Fired %dx Grade Roll on %s", times, tostring(unitKey)),
								UI.Colors.accentCyan)
						end
						if Settings and Settings.Save then Settings.Save() end
					end
				end)
			elseif action == "rollquirk" or action == "roll_quirk" then
				pcall(function()
					local unitKey = cmd.unitKey or cmd.key
					if not unitKey or unitKey == "" then
						if cmd.slot or cmd.slotIndex then
							local sIdx = tostring(cmd.slot or cmd.slotIndex or 1)
							local ok, raw = pcall(function()
								return typeof(DataController) == "function" and DataController() or
									(DataController and DataController.___X)
							end)
							if ok and raw and raw.Slots and (raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]) then
								local sData = raw.Slots[sIdx] or raw.Slots[tonumber(sIdx)]
								unitKey = sData and sData.unitId
							end
						end
					end
					if not unitKey or unitKey == "" then
						unitKey = getActiveRollUnitKey()
					end

					local newMap = {}
					if cmd.targetQuirks and type(cmd.targetQuirks) == "table" then
						for k, v in pairs(cmd.targetQuirks) do
							if type(k) == "number" then
								newMap[tostring(v)] = true
							elseif v == true then
								newMap[tostring(k)] = true
							end
						end
					elseif cmd.targetQuirk and cmd.targetQuirk ~= "" and cmd.targetQuirk ~= "ANY" then
						newMap[tostring(cmd.targetQuirk)] = true
					end

					if next(newMap) ~= nil then
						cfg.targetQuirks = newMap
						local firstQuirk = next(newMap)
						if firstQuirk then cfg.targetQuirk = tostring(firstQuirk) end
					end

					if unitKey then
						cfg.selectedRollUnitKey = tostring(unitKey)
					end

					if cmd.autoRoll == true then
						cfg.autoRollQuirk = true
						if autoRollQuirkToggle and autoRollQuirkToggle.Set then
							autoRollQuirkToggle.Set(true)
						end
						if Settings and Settings.Save then Settings.Save() end
						logger.Log(string.format("[Remote Command]: Auto Quirk Roll activated on %s", tostring(unitKey)),
							UI.Colors.successGreen)
					else
						
						local times = tonumber(cmd.times or cmd.count or 1) or 1
						if unitKey and rollQuirkRE then
							for _ = 1, math.min(times, 10) do
								pcall(function()
									local pGui = player:FindFirstChild("PlayerGui")
									if pGui and pGui:FindFirstChild("Root") and pGui.Root:FindFirstChild("Menus") and pGui.Root.Menus:FindFirstChild("Quirks") then
										local confirm = pGui.Root.Menus.Quirks:FindFirstChild("ConfirmQuirk")
										if confirm and confirm.Visible then confirm.Visible = false end
									end
								end)
								rollQuirkRE:FireServer(unitKey, true)
								task.wait(0.12)
							end
							logger.Log(
								string.format("[Remote Command]: Fired %dx Quirk Roll on %s", times, tostring(unitKey)),
								UI.Colors.accentCyan)
						end
						if Settings and Settings.Save then Settings.Save() end
					end
				end)
			elseif action == "setlocked" or action == "set_locked" or action == "lock_unit" then
				pcall(function()
					local unitKey = cmd.unitKey or cmd.key
					local locked = (cmd.locked == true or cmd.value == true)
					if unitKey and setLockedRE then
						setLockedRE:FireServer({ [tostring(unitKey)] = locked })
						logger.Log(
							string.format("[Remote Command]: Set Unit %s Locked = %s", tostring(unitKey),
								tostring(locked)),
							UI.Colors.accentViolet)
					end
				end)
			elseif action == "collectbalance" or action == "collect_balance" then
				pcall(function()
					if collectBalanceRE then
						collectBalanceRE:FireServer()
						logger.Log("[Remote Command]: Collected plot balances", UI.Colors.successGreen)
					end
				end)
			elseif action == "equipbest" or action == "equip_best" then
				pcall(function()
					if equipBestPlotRE then
						equipBestPlotRE:FireServer()
						logger.Log("[Remote Command]: Equipped best plot units", UI.Colors.successGreen)
					end
				end)
			elseif action == "buyupgrade" or action == "buy_upgrade" then
				pcall(function()
					if buyUpgradeRE and cmd.upgradeName then
						buyUpgradeRE:FireServer(tostring(cmd.upgradeName))
						logger.Log(string.format("[Remote Command]: Purchased upgrade %s", tostring(cmd.upgradeName)),
							UI.Colors.successGreen)
					end
				end)
			elseif action == "claimquests" or action == "claim_quests" then
				pcall(function()
					local QuestConfig = require(Features.Quests.QuestConfig)
					local raw = (typeof(DataController) == "function" and DataController()) or
						(DataController and DataController.___X)
					local quests = (raw and raw.Quests) or {}
					local count = 0
					for _, period in ipairs({ "Daily", "Weekly" }) do
						local questData = quests[period] or
							(DataController.Quests and DataController.Quests[period] and DataController.Quests[period]())
						if questData and questData.progress and QuestConfig and QuestConfig.Periods and QuestConfig.Periods[period] then
							local expAt = questData.expiresAt or 0
							for _, q in ipairs(QuestConfig.Periods[period].quests) do
								local cur = questData.progress[q.id] or 0
								local claimed = questData.claimed and questData.claimed[q.id] == true
								if not claimed and cur >= q.target then
									claimQuestRE:FireServer(period, q.id, expAt)
									count = count + 1
									task.wait(0.12)
								end
							end
						end
					end
					logger.Log(string.format("[Remote Command]: Claimed %d finished quest(s)", count),
						UI.Colors.successGreen)
				end)
			elseif action == "claimrewards" or action == "claim_rewards" then
				pcall(function()
					if claimDailyRE then claimDailyRE:FireServer() end
					if claimGroupRE then claimGroupRE:FireServer() end
					if claimOfflineRE then claimOfflineRE:FireServer() end
					logger.Log("[Remote Command]: Claimed Daily, Group, and Offline rewards", UI.Colors.successGreen)
				end)
			elseif action == "execute" and cmd.code then
				pcall(function()
					local fn = loadstring(tostring(cmd.code))
					if fn then fn() end
				end)
			end
		end

		local function processCommand(cmd)
			if typeof(cmd) ~= "table" then return end
			table.insert(_G.daCommandQueue, cmd)

			if not _G.daIsProcessingCommandQueue then
				_G.daIsProcessingCommandQueue = true
				task.spawn(function()
					while #_G.daCommandQueue > 0 do
						local currentCmd = table.remove(_G.daCommandQueue, 1)
						local ok, failure = pcall(function() executeSingleCommand(currentCmd) end)
						if not ok and currentCmd.action == "setconfig" then
							Settings.LastConfigResult = { id = tostring(currentCmd.id or ""), success = false, error = tostring(failure) }
						end
						if currentCmd.id then _G.daPendingAckCommands[currentCmd.id] = true end
						task.wait(1.5)
					end
					_G.daIsProcessingCommandQueue = false
				end)
			end
		end

		local function sendHeartbeat(isDisconnect)
			pcall(function()
				local key = _G.hiphub_key or (getgenv and getgenv().hiphub_key)
				local baseUrl = _G.hiphub_url or (getgenv and getgenv().hiphub_url) or "https://dev-hiphub.vercel.app"
				if not key or key == "" then return end

				local telemetry = getTelemetryData()
				local req = (syn and syn.request) or (http and http.request) or request or http_request or
					(fluxus and fluxus.request)

				local ackList = {}
				for id, _ in pairs(_G.daPendingAckCommands) do
					table.insert(ackList, tostring(id))
				end

				if req then
					local payload = {
						key = tostring(key),
						username = tostring(player.Name),
						userId = player.UserId,
						placeId = game.PlaceId,
						jobId = game.JobId,
						serverJoinTime = serverJoinTime,
						sheckles = telemetry.sheckles,
						inventory = telemetry.inventory,
						disconnect = (isDisconnect == true),
						ackCommands = ackList
					}

					local response = req({
						Url = tostring(baseUrl) .. "/api/keys/heartbeat",
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json"
						},
						Body = HttpService:JSONEncode(payload)
					})

					if response and response.Body then
						local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
						if ok and data and data.success then
							for _, id in ipairs(ackList) do
								_G.daPendingAckCommands[id] = nil
							end

							if data.commands and type(data.commands) == "table" then
								for _, cmd in ipairs(data.commands) do
									local cmdId = cmd.id or (cmd.action .. "_" .. tostring(cmd.timestamp or ""))
									if not _G.daProcessedCommandIds[cmdId] then
										_G.daProcessedCommandIds[cmdId] = true
										processCommand(cmd)
									end
								end
							end
						end
					end
				else
					local url = tostring(baseUrl) .. "/api/keys/heartbeat?key=" .. tostring(key) ..
						"&username=" .. HttpService:UrlEncode(tostring(player.Name)) ..
						"&placeId=" .. tostring(game.PlaceId) ..
						"&jobId=" .. HttpService:UrlEncode(tostring(game.JobId or "")) ..
						"&serverJoinTime=" .. tostring(serverJoinTime) ..
						(isDisconnect and "&disconnect=true" or "")

					local body = game:HttpGet(url)
					if body and body ~= "" then
						local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
						if ok and data and data.success and data.commands then
							for _, cmd in ipairs(data.commands) do
								local cmdId = cmd.id or (cmd.action .. "_" .. tostring(cmd.timestamp or ""))
								if not _G.daProcessedCommandIds[cmdId] then
									_G.daProcessedCommandIds[cmdId] = true
										processCommand(cmd)
								end
							end
						end
					end
				end
			end)
		end

		
		sendHeartbeat(false)

		
		while scriptRunning do
			task.wait(6)
			if not scriptRunning then break end
			sendHeartbeat(false)
		end
	end)

	logger.Log("All systems ready. HipHub loaded successfully.", UI.Colors.successGreen)
end, function(e)
	return tostring(e) .. "\n" .. debug.traceback()
end)

if not success then
	_G.HipHub_DA_LastError = tostring(err)
	warn("[HipHub DA Main Error]: " .. tostring(err))
else
	_G.HipHub_DA_LastError = "SUCCESS"
end

end