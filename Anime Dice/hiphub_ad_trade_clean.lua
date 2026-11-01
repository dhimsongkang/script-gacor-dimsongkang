do


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
while not localPlayer do
    task.wait(0.5)
    localPlayer = Players.LocalPlayer
end

local Settings = {
    
    Role = "Sender", 
    AutoTrade = true,
    
    
    HostUsername = "dimsongkang1",   
    AcceptAnyRequester = true,   
    TargetPlayers = {},          
    UnitsPerPlayer = 1,          
    
    
    MinIncome = "100t/s", 
    MaxIncome = "",       
    KeepTopX = 0,         
    AllowEquipped = true, 
    AllowLocked = false,  
    SortStrategy = "LowestQualifying",
    
    
    HasReceived = false,       
    
    
    AutoRequest = true,        
    AutoAcceptRequest = true,  
    AutoAdvance = true,        
    SafetyDelay = 0.8,         
    RequestInterval = 6,       
    AutoReenableTrades = true, 
    
    
    TradedUsers = {},          

    FarmerV5 = {
        Enabled = true,
        ApiKey = "ak_9b01456dd738b682fa9ef5ed989130bf471794cf06e91d6bc9474507cd72d1bc",
        Option = 1,
        BaseUrl = "https://accountops.org",
    },
}

local HttpService = game:GetService("HttpService")
local ROOT_FOLDER = "Hiphub"
local FOLDER = "Hiphub/ad-trade"
local CONFIG_FILE = "Hiphub/ad-trade/config.json"
local HISTORY_FILE = "Hiphub/ad-trade/history.json"

Settings.ROOT_FOLDER = ROOT_FOLDER
Settings.FOLDER = FOLDER
Settings.CONFIG_FILE = CONFIG_FILE
Settings.HISTORY_FILE = HISTORY_FILE

local function ensureFolder()
    pcall(function()
        if makefolder then
            if isfolder then
                if not isfolder(ROOT_FOLDER) then
                    makefolder(ROOT_FOLDER)
                end
                if not isfolder(FOLDER) then
                    makefolder(FOLDER)
                end
            else
                makefolder(ROOT_FOLDER)
                makefolder(FOLDER)
            end
        end
    end)
end


local function detectRole()
    local myName = localPlayer.Name:lower()
    local hostName = tostring(Settings.HostUsername or ""):lower()
    
    if hostName ~= "" and myName == hostName then
        Settings.Role = "Sender"
        return "Sender"
    else
        Settings.Role = "Receiver"
        return "Receiver"
    end
end

function Settings.Save()
    pcall(function()
        ensureFolder()
        if writefile then
            local data = {
                HostUsername = Settings.HostUsername,
                AcceptAnyRequester = Settings.AcceptAnyRequester,
                TargetPlayers = Settings.TargetPlayers,
                MinIncome = Settings.MinIncome,
                MaxIncome = Settings.MaxIncome,
                UnitsPerPlayer = Settings.UnitsPerPlayer,
                KeepTopX = Settings.KeepTopX,
                AllowEquipped = Settings.AllowEquipped,
                AllowLocked = Settings.AllowLocked,
                AutoTrade = Settings.AutoTrade,
                AutoRequest = Settings.AutoRequest,
                AutoAcceptRequest = Settings.AutoAcceptRequest,
                AutoAdvance = Settings.AutoAdvance,
                SafetyDelay = Settings.SafetyDelay,
                RequestInterval = Settings.RequestInterval,
                FarmerV5 = Settings.FarmerV5,
            }
            pcall(function()
                writefile(CONFIG_FILE, HttpService:JSONEncode(data))
            end)
            pcall(function()
                writefile(HISTORY_FILE, HttpService:JSONEncode({
                    TradedUsers = Settings.TradedUsers
                }))
            end)
        end
    end)
end

function Settings.Load()
    pcall(function()
        ensureFolder()
        if isfile and readfile then
            pcall(function()
                local exists = false
                pcall(function() exists = isfile(CONFIG_FILE) end)
                if exists then
                    local ok, content = pcall(function() return readfile(CONFIG_FILE) end)
                    if ok and content and content ~= "" then
                        local data = HttpService:JSONDecode(content)
                        if type(data) == "table" then
                            for k, v in pairs(data) do
                                if k == "FarmerV5" and type(v) == "table" then
                                    Settings.FarmerV5 = Settings.FarmerV5 or {}
                                    for fk, fv in pairs(v) do
                                        Settings.FarmerV5[fk] = fv
                                    end
                                elseif Settings[k] ~= nil then
                                    Settings[k] = v
                                end
                            end
                        end
                    end
                end
            end)
            
            pcall(function()
                local exists = false
                pcall(function() exists = isfile(HISTORY_FILE) end)
                if exists then
                    local ok, content = pcall(function() return readfile(HISTORY_FILE) end)
                    if ok and content and content ~= "" then
                        local hist = HttpService:JSONDecode(content)
                        if type(hist) == "table" and hist.TradedUsers and type(hist.TradedUsers) == "table" then
                            Settings.TradedUsers = hist.TradedUsers
                        end
                    end
                end
            end)
        end
    end)
    
    
    pcall(function()
        local cFile = (isfile and isfile("DuckHub/config.json") and "DuckHub/config.json") or (isfile and isfile("config.json") and "config.json")
        if cFile and readfile then
            local rawCfg = readfile(cFile)
            if rawCfg and rawCfg ~= "" then
                local d = HttpService:JSONDecode(rawCfg)
                local ac = d and (d["Auto Change"] or d.AutoChange)
                local fv5 = ac and (ac.Farmerv5 or ac.FarmerV5)
                if fv5 and (fv5["API Key"] or fv5.ApiKey) then
                    local k = fv5["API Key"] or fv5.ApiKey
                    Settings.FarmerV5 = Settings.FarmerV5 or {}
                    if not Settings.FarmerV5.ApiKey or Settings.FarmerV5.ApiKey == "" then
                        Settings.FarmerV5.ApiKey = k
                    end
                    if Settings.FarmerV5.Option == nil then
                        Settings.FarmerV5.Option = tonumber(fv5["Option"] or fv5.Option) or 1
                    end
                    if not Settings.FarmerV5.BaseUrl or Settings.FarmerV5.BaseUrl == "" then
                        Settings.FarmerV5.BaseUrl = fv5["Base URL"] or fv5.BaseUrl or "https://accountops.org"
                    end
                end
            end
        end
    end)

    if tostring(Settings.HostUsername or ""):lower() == "itrast11" then
        Settings.HostUsername = "dimsongkang1"
    end

    detectRole()
    
    
    local myCount = Settings.TradedUsers[localPlayer.Name] or 0
    Settings.HasReceived = (myCount >= (tonumber(Settings.UnitsPerPlayer) or 1))
end

Settings.Load()
Settings.DetectRole = detectRole

_G.HipHub_AD_Trade_Settings = Settings

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
	accentOrange  = Color3.fromRGB(255, 160, 40),
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

local oldGuis = { "HipHub_AD_Trade_UI", "HipHub_AD_Lite_UI", "HipHubError" }
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

	if opts.stroke ~= false then
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
gui.Name = "HipHub_AD_Trade_UI"
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
	if vp.X < 640 or vp.Y < 460 then
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

local hubTitle = Instance.new("TextLabel")
hubTitle.Name = "HubTitle"
hubTitle.Size = UDim2.new(0, 72, 1, 0)
hubTitle.Position = UDim2.new(0, 14, 0, 0)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "HipHub"
hubTitle.TextColor3 = COLORS.textWhite
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextSize = 15
hubTitle.TextXAlignment = Enum.TextXAlignment.Left
hubTitle.ZIndex = 3
hubTitle.Parent = topBar

local badge = Instance.new("TextLabel")
badge.Name = "GameBadge"
badge.Size = UDim2.new(0, 110, 0, 22)
badge.Position = UDim2.new(0, 88, 0.5, -11)
badge.BackgroundColor3 = COLORS.accentViolet
badge.BackgroundTransparency = 0.25
badge.Text = "Smart Trade"
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


local topStatusBadge = Instance.new("TextLabel")
topStatusBadge.Name = "TopStatusBadge"
topStatusBadge.Size = UDim2.new(0, 145, 0, 22)
topStatusBadge.Position = UDim2.new(1, -260, 0.5, -11)
topStatusBadge.BackgroundColor3 = COLORS.glassSurface
topStatusBadge.BackgroundTransparency = 0.25
topStatusBadge.Text = "STATUS: IDLE"
topStatusBadge.TextColor3 = COLORS.accentCyan
topStatusBadge.Font = Enum.Font.GothamBold
topStatusBadge.TextSize = 9
topStatusBadge.ZIndex = 3
topStatusBadge.Parent = topBar

applyGlass(topStatusBadge, {
	corner = CORNER.pill,
	stroke = true,
	strokeColor = COLORS.accentCyan,
	strokeThickness = 1,
	strokeTransparency = 0.5
})

local fpsBadge = Instance.new("TextLabel")
fpsBadge.Name = "FpsBadge"
fpsBadge.Size = UDim2.new(0, 60, 0, 22)
fpsBadge.Position = UDim2.new(1, -110, 0.5, -11)
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
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0.5, -12)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = COLORS.textSecondary
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.ZIndex = 3
closeButton.Parent = topBar

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.dangerRed }):Play()
end)
closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.textSecondary }):Play()
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -48, 0.5, -12)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = COLORS.textSecondary
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 15
minimizeButton.ZIndex = 3
minimizeButton.Parent = topBar

minimizeButton.MouseEnter:Connect(function()
	TweenService:Create(minimizeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.accentCyan }):Play()
end)
minimizeButton.MouseLeave:Connect(function()
	TweenService:Create(minimizeButton, TweenInfo.new(0.15), { TextColor3 = COLORS.textSecondary }):Play()
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

resizeGrip.MouseEnter:Connect(function() setGripGlow(true) end)
resizeGrip.MouseLeave:Connect(function() if not isResizing then setGripGlow(false) end end)

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




local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreButton"
restoreButton.Size = UDim2.new(0, 130, 0, 32)
restoreButton.Position = UDim2.new(1, -150, 1, -45)
restoreButton.BackgroundColor3 = COLORS.glassSurface
restoreButton.BackgroundTransparency = 0.15
restoreButton.BorderSizePixel = 0
restoreButton.Text = "SMART TRADE"
restoreButton.TextColor3 = COLORS.accentCyan
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 10
restoreButton.Visible = false
restoreButton.ZIndex = 50
restoreButton.Parent = gui

applyGlass(restoreButton, {
	corner = CORNER.pill,
	stroke = true,
	strokeColor = COLORS.accentCyan,
	strokeThickness = 1.2,
	strokeTransparency = 0.3
})

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
	mainFrame.Visible = true
	shadowFrame.Visible = true
	restoreButton.Visible = false
	syncShadow()
	mainFrame.BackgroundTransparency = 1
	shadowFrame.BackgroundTransparency = 1
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = TRANSPARENCY.glassMain }):Play()
	TweenService:Create(shadowFrame, tweenInfo, { BackgroundTransparency = 0.45 }):Play()
end

minimizeButton.MouseButton1Click:Connect(function() minimizeUI(false) end)
restoreButton.MouseButton1Click:Connect(restoreUI)
closeButton.MouseButton1Click:Connect(function() minimizeUI(false) end)




local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, -42)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = COLORS.glassSurface
sidebar.BackgroundTransparency = TRANSPARENCY.glassSidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = mainFrame

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
sidebarDivider.BackgroundColor3 = COLORS.borderGlass
sidebarDivider.BackgroundTransparency = 0.6
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 3
sidebarDivider.Parent = sidebar

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, -54)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContainer.ZIndex = 2
tabContainer.Parent = sidebar

applyListLayout(tabContainer, 3)
applyPadding(tabContainer, 8, 8, 8, 4)


local profileCard = Instance.new("Frame")
profileCard.Name = "UserProfile"
profileCard.Size = UDim2.new(1, -16, 0, 42)
profileCard.Position = UDim2.new(0, 8, 1, -48)
profileCard.BackgroundColor3 = COLORS.glassCard
profileCard.BackgroundTransparency = TRANSPARENCY.glassCard
profileCard.BorderSizePixel = 0
profileCard.ZIndex = 3
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
avatarLabel.Size = UDim2.new(0, 26, 0, 26)
avatarLabel.Position = UDim2.new(0, 6, 0.5, -13)
avatarLabel.BackgroundColor3 = COLORS.glassHover
avatarLabel.BorderSizePixel = 0
avatarLabel.ZIndex = 4
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
usernameLabel.Size = UDim2.new(1, -42, 1, 0)
usernameLabel.Position = UDim2.new(0, 38, 0, 0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = player.DisplayName or player.Name
usernameLabel.TextColor3 = COLORS.textPrimary
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 10
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
usernameLabel.ZIndex = 4
usernameLabel.Parent = profileCard




local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -151, 1, -42)
contentArea.Position = UDim2.new(0, 151, 0, 42)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 2
contentArea.Parent = mainFrame

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

	applyPadding(frame, 12, 12, 12, 12)
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
	button.Size = UDim2.new(1, 0, 0, 32)
	button.BackgroundColor3 = COLORS.glassSurface
	button.BackgroundTransparency = 1
	button.BorderSizePixel = 0
	button.ZIndex = 3
	button.Text = "   " .. name
	button.TextColor3 = COLORS.textSecondary
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 11
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






local function createSection(parent, title, layoutOrder, defaultExpanded)
	local isCollapsed = not (defaultExpanded == nil or defaultExpanded == true)

	local header = Instance.new("TextButton")
	header.Name = "SectionHeader_" .. tostring(title)
	header.Size = UDim2.new(1, 0, 0, 34)
	header.BackgroundColor3 = Color3.fromRGB(22, 26, 48)
	header.BackgroundTransparency = 0.1
	header.BorderSizePixel = 0
	header.Text = ""
	header.LayoutOrder = (layoutOrder or 1) * 2 - 1
	header.ZIndex = 3
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
	accentBar.Size = UDim2.new(0, 3, 0, 16)
	accentBar.Position = UDim2.new(0, 8, 0.5, -8)
	accentBar.BackgroundColor3 = COLORS.accentCyan
	accentBar.BorderSizePixel = 0
	accentBar.ZIndex = 4
	accentBar.Parent = header

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(0, 2)
	accentCorner.Parent = accentBar

	local hTitle = Instance.new("TextLabel")
	hTitle.Name = "HeaderTitle"
	hTitle.Size = UDim2.new(1, -50, 1, 0)
	hTitle.Position = UDim2.new(0, 18, 0, 0)
	hTitle.BackgroundTransparency = 1
	hTitle.Text = string.upper(tostring(title))
	hTitle.TextColor3 = Color3.fromRGB(225, 235, 255)
	hTitle.Font = Enum.Font.GothamBold
	hTitle.TextSize = 11
	hTitle.TextXAlignment = Enum.TextXAlignment.Left
	hTitle.ZIndex = 4
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
	arrow.TextSize = 13
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.TextYAlignment = Enum.TextYAlignment.Center
	arrow.ZIndex = 4
	arrow.Parent = header

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.LayoutOrder = (layoutOrder or 1) * 2
	container.ClipsDescendants = true
	container.Visible = not isCollapsed
	container.ZIndex = 2
	container.Parent = parent

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 0, 0)
	content.Position = UDim2.new(0, 0, 0, 0)
	content.BackgroundTransparency = 1
	content.Visible = not isCollapsed
	content.ZIndex = 2
	content.Parent = container

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.Parent = content

	header.MouseEnter:Connect(function()
		TweenService:Create(header, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 34, 60) }):Play()
		TweenService:Create(accentBar, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 225, 255) }):Play()
		hTitle.TextColor3 = COLORS.textWhite
	end)
	header.MouseLeave:Connect(function()
		TweenService:Create(header, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(22, 26, 48) }):Play()
		TweenService:Create(accentBar, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.accentCyan }):Play()
		hTitle.TextColor3 = Color3.fromRGB(225, 235, 255)
	end)

	local function updateHeight()
		if not isCollapsed then
			local h = contentLayout.AbsoluteContentSize.Y + 4
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
		local targetH = isCollapsed and 0 or (contentLayout.AbsoluteContentSize.Y + 4)

		arrow.Text = isCollapsed and ">" or "v"
		TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Rotation = targetRot }):Play()
		local tween = TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, targetH) })
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
			container.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 4)
			content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 4)
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
	titleLabel.TextSize = 11
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

		TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetThumbPos }):Play()
		TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetBgColor }):Play()
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
		Row = card,
		Frame = card,
		Set = function(v) setState(v, false) end,
		Get = function() return state end
	}
end


local function createTextInput(parent, labelText, defaultText, placeholder, callback, layoutOrder)
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
	titleLabel.Size = UDim2.new(1, -185, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = labelText
	titleLabel.TextColor3 = COLORS.textPrimary
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextSize = 11
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 4
	titleLabel.Parent = card

	local box = Instance.new("TextBox")
	box.Name = "TextBox"
	box.Size = UDim2.new(0, 165, 0, 24)
	box.Position = UDim2.new(1, -173, 0.5, -12)
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
			TweenService:Create(boxStroke, TweenInfo.new(0.15), { Transparency = 0.85, Color = COLORS.borderGlass }):Play()
		end
		TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.glassSurface }):Play()
		if callback then
			task.spawn(callback, box.Text)
		end
	end)

	return {
		card = card,
		Row = card,
		Frame = card,
		Box = box,
		Set = function(v) box.Text = tostring(v or "") end,
		Get = function() return box.Text end
	}
end


local function createDropdownMenu(options, defaultSelectedName, onUpdateCallback)
	local currentSelected = defaultSelectedName or (options and options[1]) or "Select"

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(0, 240, 1, -56)
	overlay.Position = UDim2.new(1, -250, 0, 48)
	overlay.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
	overlay.BackgroundTransparency = 0
	overlay.BorderSizePixel = 0
	overlay.Visible = false
	overlay.ZIndex = 500
	overlay.Parent = mainFrame

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
	searchBox.Size = UDim2.new(1, -20, 0, 28)
	searchBox.Position = UDim2.new(0, 10, 0, 10)
	searchBox.BackgroundColor3 = COLORS.glassSurface
	searchBox.BackgroundTransparency = 0.25
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search options..."
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
	scrollContainer.Size = UDim2.new(1, -16, 1, -50)
	scrollContainer.Position = UDim2.new(0, 8, 0, 44)
	scrollContainer.BackgroundTransparency = 1
	scrollContainer.BorderSizePixel = 0
	scrollContainer.ScrollBarThickness = 2
	scrollContainer.ScrollBarImageColor3 = COLORS.accentCyan
	scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollContainer.ZIndex = 501
	scrollContainer.Parent = overlay

	local scrollLayout = Instance.new("UIListLayout")
	scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	scrollLayout.Padding = UDim.new(0, 4)
	scrollLayout.Parent = scrollContainer

	applyPadding(scrollContainer, 2, 2, 2, 2)

	scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollContainer.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 8)
	end)

	local optionRows = {}

	local function buildOptionRows(optList)
		options = optList or options
		for _, item in ipairs(optionRows) do
			if item.Card and item.Card.Parent then item.Card:Destroy() end
		end
		table.clear(optionRows)

		if #options <= 4 then
			searchBox.Visible = false
			scrollContainer.Position = UDim2.new(0, 8, 0, 8)
			scrollContainer.Size = UDim2.new(1, -16, 1, -16)
			overlay.Size = UDim2.new(0, 220, 0, #options * 36 + 16)
		else
			searchBox.Visible = true
			scrollContainer.Position = UDim2.new(0, 8, 0, 44)
			scrollContainer.Size = UDim2.new(1, -16, 1, -50)
			overlay.Size = UDim2.new(0, 220, 1, -56)
		end

		for idx, name in ipairs(options) do
			local card = Instance.new("TextButton")
			card.Size = UDim2.new(1, 0, 0, 30)
			card.BackgroundColor3 = COLORS.glassActive
			card.BackgroundTransparency = (name == currentSelected) and 0.15 or 1
			card.BorderSizePixel = 0
			card.Text = ""
			card.LayoutOrder = idx
			card.ZIndex = 502
			card.Parent = scrollContainer

			local cCorner = Instance.new("UICorner")
			cCorner.CornerRadius = CORNER.small
			cCorner.Parent = card

			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.new(0, 3, 0, 14)
			indicator.Position = UDim2.new(0, 4, 0.5, -7)
			indicator.BackgroundColor3 = COLORS.accentCyan
			indicator.BorderSizePixel = 0
			indicator.Visible = (name == currentSelected)
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
			label.TextColor3 = (name == currentSelected) and COLORS.textWhite or COLORS.textSecondary
			label.Font = (name == currentSelected) and Enum.Font.GothamBold or Enum.Font.GothamMedium
			label.TextSize = 11
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextTruncate = Enum.TextTruncate.AtEnd
			label.ZIndex = 503
			label.Parent = card

			table.insert(optionRows, { Name = name, Card = card, Indicator = indicator, Label = label })

			card.MouseButton1Click:Connect(function()
				currentSelected = name
				for _, item in ipairs(optionRows) do
					local isSel = (item.Name == currentSelected)
					item.Card.BackgroundTransparency = isSel and 0.15 or 1
					item.Indicator.Visible = isSel
					item.Label.TextColor3 = isSel and COLORS.textWhite or COLORS.textSecondary
					item.Label.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
				end
				if onUpdateCallback then onUpdateCallback(name) end
				closeDropdowns()
			end)
		end
	end

	buildOptionRows(options)

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(searchBox.Text)
		for _, item in ipairs(optionRows) do
			if q == "" or string.find(string.lower(item.Name), q, 1, true) then
				item.Card.Visible = true
			else
				item.Card.Visible = false
			end
		end
	end)

	local function setSelected(val)
		currentSelected = tostring(val)
		for _, item in ipairs(optionRows) do
			local isSel = (item.Name == currentSelected)
			item.Card.BackgroundTransparency = isSel and 0.15 or 1
			item.Indicator.Visible = isSel
			item.Label.TextColor3 = isSel and COLORS.textWhite or COLORS.textSecondary
			item.Label.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
		end
	end

	return overlay, setSelected, buildOptionRows
end


local function createDropdown(parent, labelText, options, defaultOption, callback, layoutOrder)
	local card = Instance.new("Frame")
	card.Name = "DropdownCard_" .. tostring(labelText)
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

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -185, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = COLORS.textPrimary
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.ZIndex = 4
	label.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 165, 0, 24)
	btn.Position = UDim2.new(1, -173, 0.5, -12)
	btn.BackgroundColor3 = Color3.fromRGB(24, 28, 48)
	btn.BackgroundTransparency = 0.2
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.ZIndex = 4
	btn.Parent = card

	applyGlass(btn, {
		corner = CORNER.small,
		stroke = true,
		strokeColor = COLORS.accentCyan,
		strokeThickness = 1.2,
		strokeTransparency = 0.3
	})

	local btnTextLabel = Instance.new("TextLabel")
	btnTextLabel.Name = "ButtonText"
	btnTextLabel.Size = UDim2.new(1, -24, 1, 0)
	btnTextLabel.Position = UDim2.new(0, 8, 0, 0)
	btnTextLabel.BackgroundTransparency = 1
	btnTextLabel.Text = tostring(defaultOption or (options and options[1]) or "Select")
	btnTextLabel.TextColor3 = COLORS.textWhite
	btnTextLabel.Font = Enum.Font.GothamBold
	btnTextLabel.TextSize = 11
	btnTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	btnTextLabel.TextTruncate = Enum.TextTruncate.AtEnd
	btnTextLabel.ZIndex = 5
	btnTextLabel.Parent = btn

	local arrow = Instance.new("TextLabel")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.new(0, 18, 1, 0)
	arrow.Position = UDim2.new(1, -18, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "v"
	arrow.TextColor3 = COLORS.accentCyan
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 10
	arrow.ZIndex = 5
	arrow.Parent = btn

	local currentVal = defaultOption or (options and options[1]) or "Select"
	local overlay, setSelected, rebuildOptions = createDropdownMenu(options, currentVal, function(newOpt)
		currentVal = newOpt
		btnTextLabel.Text = tostring(newOpt)
		if callback then
			task.spawn(callback, newOpt)
		end
	end)

	btn.MouseButton1Click:Connect(function()
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
		card = card,
		Row = card,
		Frame = card,
		Set = function(v)
			currentVal = tostring(v)
			btnTextLabel.Text = tostring(v)
			setSelected(v)
		end,
		Refresh = function(newOptions, newDefault)
			currentVal = newDefault or currentVal or (newOptions and newOptions[1]) or "Select"
			btnTextLabel.Text = tostring(currentVal)
			rebuildOptions(newOptions)
			setSelected(currentVal)
		end,
		Get = function() return currentVal end
	}
end


local function createButton(parent, arg2, arg3, arg4, arg5)
	local title, btnText, callback, layoutOrder, style
	if type(arg2) == "string" and type(arg3) == "function" then
		
		title = arg2
		callback = arg3
		layoutOrder = arg4
		style = arg5

		local isDanger = (style == "danger")
		local isSuccess = (style == "success")
		local isViolet = (style == "violet")

		local bgCol = isDanger and Color3.fromRGB(60, 22, 32)
			or isSuccess and Color3.fromRGB(18, 55, 34)
			or isViolet and Color3.fromRGB(48, 30, 80)
			or Color3.fromRGB(24, 30, 56)

		local strokeCol = isDanger and COLORS.dangerRed
			or isSuccess and COLORS.successGreen
			or isViolet and COLORS.accentViolet
			or COLORS.accentCyan

		local textCol = isDanger and Color3.fromRGB(255, 120, 120)
			or isSuccess and Color3.fromRGB(120, 255, 160)
			or isViolet and Color3.fromRGB(190, 170, 255)
			or COLORS.textWhite

		local btn = Instance.new("TextButton")
		btn.Name = "Button_" .. title
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundColor3 = bgCol
		btn.BackgroundTransparency = 0.15
		btn.BorderSizePixel = 0
		btn.Text = title
		btn.TextColor3 = textCol
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.LayoutOrder = layoutOrder or 1
		btn.ZIndex = 3
		btn.Parent = parent

		applyGlass(btn, {
			corner = CORNER.small,
			stroke = true,
			strokeColor = strokeCol,
			strokeThickness = 1,
			strokeTransparency = 0.6
		})

		btn.MouseButton1Click:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0.4 }):Play()
			task.delay(0.1, function()
				TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0.15 }):Play()
			end)
			if callback then task.spawn(callback) end
		end)

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.05 }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play()
		end)

		return btn
	else
		
		title = tostring(arg2)
		btnText = tostring(arg3 or "Execute")
		callback = arg4
		layoutOrder = arg5

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
		titleLabel.Size = UDim2.new(1, -125, 1, 0)
		titleLabel.Position = UDim2.new(0, 12, 0, 0)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = COLORS.textPrimary
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextSize = 11
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
		titleLabel.ZIndex = 4
		titleLabel.Parent = card

		local actionBtn = Instance.new("TextButton")
		actionBtn.Name = "ActionBtn"
		actionBtn.Size = UDim2.new(0, 105, 0, 24)
		actionBtn.Position = UDim2.new(1, -113, 0.5, -12)
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
			if callback then task.spawn(callback) end
		end)

		actionBtn.MouseEnter:Connect(function()
			TweenService:Create(actionBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 225, 255) }):Play()
		end)
		actionBtn.MouseLeave:Connect(function()
			TweenService:Create(actionBtn, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.accentCyan }):Play()
		end)

		return {
			card = card,
			Row = card,
			Frame = card,
			Button = actionBtn
		}
	end
end


local function createInfoCard(parent, title, desc, layoutOrder)
	local card = Instance.new("Frame")
	card.Name = "InfoCard_" .. tostring(title)
	card.Size = UDim2.new(1, 0, 0, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.BackgroundColor3 = COLORS.glassCard
	card.BackgroundTransparency = TRANSPARENCY.glassCard
	card.BorderSizePixel = 0
	card.LayoutOrder = layoutOrder or 1
	card.ZIndex = 3
	card.Parent = parent

	applyGlass(card, { corner = CORNER.small })
	applyPadding(card, 10, 10, 10, 10)
	applyListLayout(card, 4)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 16)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = COLORS.accentCyan
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 11
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 4
	titleLbl.Parent = card

	local descLbl = Instance.new("TextLabel")
	descLbl.Size = UDim2.new(1, 0, 0, 0)
	descLbl.AutomaticSize = Enum.AutomaticSize.Y
	descLbl.BackgroundTransparency = 1
	descLbl.Text = desc
	descLbl.TextColor3 = COLORS.textSecondary
	descLbl.Font = Enum.Font.Gotham
	descLbl.TextSize = 10
	descLbl.TextWrapped = true
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.ZIndex = 4
	descLbl.Parent = card

	return {
		Card = card,
		SetTitle = function(t) titleLbl.Text = t end,
		SetDesc = function(d) descLbl.Text = d end
	}
end


local function createLogConsole(parent, layoutOrder, maxLines)
	local limit = maxLines or 80
	local frame = Instance.new("ScrollingFrame")
	frame.Name = "LogConsole"
	frame.Size = UDim2.new(1, 0, 0, 140)
	frame.BackgroundColor3 = COLORS.glassPrimary
	frame.BackgroundTransparency = 0.25
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 2
	frame.ScrollBarImageColor3 = COLORS.accentCyan
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.LayoutOrder = layoutOrder or 99
	frame.ZIndex = 3
	frame.Parent = parent

	applyGlass(frame, { corner = CORNER.small, strokeColor = COLORS.borderGlass, strokeTransparency = 0.7 })
	applyPadding(frame, 8, 8, 8, 8)
	applyListLayout(frame, 3)

	local lines = {}

	local function log(text, color)
		local line = Instance.new("TextLabel")
		line.Size = UDim2.new(1, 0, 0, 14)
		line.BackgroundTransparency = 1
		line.Text = string.format("[%s] %s", os.date("%X"), text)
		line.TextColor3 = color or COLORS.textSecondary
		line.Font = Enum.Font.Code
		line.TextSize = 10
		line.TextXAlignment = Enum.TextXAlignment.Left
		line.ZIndex = 4
		line.Parent = frame
		table.insert(lines, line)

		if #lines > limit then
			local old = table.remove(lines, 1)
			if old then old:Destroy() end
		end

		frame.CanvasPosition = Vector2.new(0, 99999)
	end

	return {
		Frame = frame,
		Log = log,
		Clear = function()
			for _, l in ipairs(lines) do l:Destroy() end
			table.clear(lines)
		end
	}
end




local tabTrade = addTab("Smart Trade", 1)
local tabFilters = addTab("Filters & Units", 2)
local tabAutomation = addTab("Automation", 3)
local tabLogs = addTab("Live Logs", 4)

selectTab("Smart Trade")

local UI = {
	Gui = gui,
	MainFrame = mainFrame,
	ShadowFrame = shadowFrame,
	TopStatusBadge = topStatusBadge,
	MinimizeUI = minimizeUI,
	RestoreUI = restoreUI,
	Tabs = {
		Trade = tabTrade,
		Filters = tabFilters,
		Automation = tabAutomation,
		Logs = tabLogs,
	},
	CreateSection = createSection,
	CreateToggle = createToggle,
	CreateTextInput = createTextInput,
	CreateButton = createButton,
	CreateDropdown = createDropdown,
	CreateInfoCard = createInfoCard,
	CreateLogConsole = createLogConsole,
	CloseDropdowns = closeDropdowns,
	SelectTab = selectTab,
	Colors = COLORS,
	SetStatus = function(text, color)
		if topStatusBadge and topStatusBadge.Parent then
			topStatusBadge.Text = "STATUS: " .. string.upper(tostring(text))
			topStatusBadge.TextColor3 = color or COLORS.accentCyan
			local stroke = topStatusBadge:FindFirstChildOfClass("UIStroke")
			if stroke then stroke.Color = color or COLORS.accentCyan end
		end
	end
}

_G.HipHub_AD_Trade_UI = UI

end

do


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local Settings = _G.HipHub_AD_Trade_Settings or (script and script.Parent and script.Parent:FindFirstChild("Settings") and require(script.Parent.Settings)) or {}
local UI = _G.HipHub_AD_Trade_UI or (script and script.Parent and script.Parent:FindFirstChild("UI") and require(script.Parent.UI)) or {}

local DataController = require(ReplicatedStorage.Framework.Features.Data.DataController)
local EntryRegistry = require(ReplicatedStorage.Framework.Features.Inventory.EntryRegistry)
local TradeConfig = require(ReplicatedStorage.Framework.Features.Trading.TradeConfig)
local NumberFormatter = require(ReplicatedStorage.Packages.NumberFormatter)


local TradeNetwork = ReplicatedStorage:WaitForChild("Network"):WaitForChild("TradeService")
local RE = TradeNetwork:WaitForChild("RE")
local RequestTradeRemote = RE:WaitForChild("RequestTrade")
local RespondToRequestRemote = RE:WaitForChild("RespondToRequest")
local ChangeOfferRemote = RE:WaitForChild("ChangeOffer")
local AdvanceTradeRemote = RE:WaitForChild("AdvanceTrade")
local CancelTradeRemote = RE:WaitForChild("CancelTrade")
local SetTradeRequestsEnabledRemote = RE:WaitForChild("SetTradeRequestsEnabled")
local TradeEventRemote = RE:WaitForChild("TradeEvent")




local SUFFIX_MAP = {
    k = 1e3, m = 1e6, b = 1e9, t = 1e12,
    qd = 1e15, qi = 1e18, sx = 1e21, sp = 1e24,
    oc = 1e27, no = 1e30, dc = 1e33, udc = 1e36,
    ddc = 1e39, tdc = 1e42, qadc = 1e45, qidc = 1e48
}

local function parseIncome(str)
    if type(str) == "number" then return str end
    if type(str) ~= "string" or str == "" then return 0 end
    local clean = str:lower():gsub("/s", ""):gsub("%$", ""):gsub(",", ""):gsub("%s+", "")
    local numPart, suffix = clean:match("^([%d%.]+)([a-z]*)$")
    if not numPart then
        return tonumber(clean) or 0
    end
    local val = tonumber(numPart) or 0
    if suffix and SUFFIX_MAP[suffix] then
        return val * SUFFIX_MAP[suffix]
    end
    return val
end

local function formatIncome(val)
    if not val or val == 0 then return "$0/s" end
    pcall(function()
        if NumberFormatter and NumberFormatter.FormatCompact then
            return "$" .. NumberFormatter.FormatCompact(val) .. "/s"
        end
    end)
    return "$" .. string.format("%.2e", val) .. "/s"
end




local logConsole = UI.CreateLogConsole(UI.Tabs.Logs, 1, 100)

local function log(msg, color)
    local col = color or UI.Colors.textSecondary
    logConsole.Log(msg, col)
    print("[HipHub Trade] " .. tostring(msg))
end

local function setStatus(text, color)
    UI.SetStatus(text, color)
end

-- ====================================================================
-- FarmerV5 Autoswap Signal Integration
-- ====================================================================
local isFarmerSwitching = false
local lastFarmerSwitchTime = 0

local function triggerFarmerV5Switch(reason)
    if Settings.Role ~= "Receiver" and reason ~= "Manual Test" then
        return
    end
    if isFarmerSwitching or (tick() - lastFarmerSwitchTime < 15) then
        return
    end
    
    local farmerCfg = Settings.FarmerV5
    if not farmerCfg or not farmerCfg.Enabled then
        return
    end

    local apiKey = farmerCfg.ApiKey
    if not apiKey or apiKey == "" then
        log("FarmerV5: API Key belum diatur! Tidak dapat mengirim sinyal swap.", UI.Colors.dangerRed)
        return
    end

    local req = request or (syn and syn.request) or (http and http.request) or http_request
    if not req then
        log("FarmerV5: Executor tidak mendukung fungsi HTTP request!", UI.Colors.dangerRed)
        return
    end

    isFarmerSwitching = true
    lastFarmerSwitchTime = tick()

    task.spawn(function()
        local why = reason or "Receiver Done"
        log("FarmerV5: Mengirim autoswap (" .. why .. ")...", UI.Colors.accentBlend)
        
        local baseUrl = farmerCfg.BaseUrl or "https://accountops.org"
        if not baseUrl or baseUrl == "" or baseUrl:find("127.0.0.1") or baseUrl:find("localhost") then
            baseUrl = "https://accountops.org"
        end
        baseUrl = baseUrl:gsub("/+$", "")
        local endpoint = baseUrl .. "/api/accounts/autoswap-complete"

        local payload = HttpService:JSONEncode({
            ["username"] = tostring(localPlayer.Name),
            ["option"] = tonumber(farmerCfg.Option) or 1
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
                    log("FarmerV5: Berhasil Swap Akun! Pengganti: " .. tostring(data.replacement or "-"), UI.Colors.successGreen)
                    task.spawn(function()
                        task.wait(2)
                        pcall(function() game:Shutdown() end)
                        task.wait(1)
                        pcall(function() localPlayer:Kick("FarmerV5 Autoswap: Berganti ke " .. tostring(data.replacement or "akun baru")) end)
                    end)
                elseif data.outcome == "moved" then
                    log("FarmerV5: Akun dipindahkan (moved). Menutup game...", UI.Colors.successGreen)
                    task.spawn(function()
                        task.wait(2)
                        pcall(function() game:Shutdown() end)
                        task.wait(1)
                        pcall(function() localPlayer:Kick("FarmerV5: Akun selesai dipanen.") end)
                    end)
                elseif data.outcome == "not_fired" then
                    log("FarmerV5: Autoswap not_fired (cek rule / ketersediaan pengganti).", UI.Colors.textMuted)
                    isFarmerSwitching = false
                else
                    log("FarmerV5: Response: " .. tostring(data.outcome), UI.Colors.accentCyan)
                end
            else
                log(string.format("FarmerV5: Sinyal terkirim (Status: %s)", tostring(statusCode)), UI.Colors.successGreen)
            end
        else
            log("FarmerV5: Gagal kirim sinyal (" .. tostring(res) .. ")", UI.Colors.dangerRed)
            isFarmerSwitching = false
        end
    end)
end




local activeTradePartner = nil
local activeTradeData = nil
local inTradeSession = false
local lastRequestTime = 0
local lastOfferedUnitUUID = nil
local isAdvancing = false
local isConfirming = false
local tradeSessionStartTime = 0
local confirmPhaseStartTime = 0




local function getEquippedUnitUUIDs()
    local equipped = {}
    pcall(function()
        local slots = DataController.___X and DataController.___X.Slots
        if slots then
            for _, slot in pairs(slots) do
                if type(slot) == "table" and slot.unitId then
                    equipped[slot.unitId] = true
                end
            end
        end
    end)
    return equipped
end

local function evaluateInventory()
    local equippedMap = getEquippedUnitUUIDs()
    local allUnits = {}
    
    local inv = DataController.Inventory and DataController.Inventory()
    if not inv then return {}, 0 end
    
    for uuid, itemGetter in pairs(inv) do
        local item = type(itemGetter) == "function" and itemGetter() or itemGetter
        if item and item.name then
            local entryConfig = EntryRegistry.getEntryConfig(item.name)
            if entryConfig and entryConfig.kind == "Unit" then
                local isUntradeable = false
                if TradeConfig and TradeConfig.UNTRADEABLE_ENTRIES then
                    isUntradeable = table.find(TradeConfig.UNTRADEABLE_ENTRIES, item.name) ~= nil
                end
                
                local isLocked = item.attributes and (item.attributes.locked == true) or false
                local isEquipped = equippedMap[uuid] == true
                local incomeVal = 0
                if entryConfig.income then
                    local ok, inc = pcall(function() return entryConfig.income(item.attributes or {}) end)
                    if ok and inc then incomeVal = inc end
                end
                
                table.insert(allUnits, {
                    uuid = uuid,
                    name = item.name,
                    income = incomeVal,
                    formatted = formatIncome(incomeVal),
                    isLocked = isLocked,
                    isEquipped = isEquipped,
                    isUntradeable = isUntradeable,
                    level = item.attributes and item.attributes.level or 1,
                    mutation = item.attributes and item.attributes.mutation or "None"
                })
            end
        end
    end
    
    
    table.sort(allUnits, function(a, b) return a.income > b.income end)
    
    local keepCount = math.max(0, tonumber(Settings.KeepTopX) or 0)
    local protectedBestMap = {}
    for i = 1, math.min(#allUnits, keepCount) do
        protectedBestMap[allUnits[i].uuid] = true
    end
    
    local minIncomeVal = parseIncome(Settings.MinIncome)
    local maxIncomeVal = parseIncome(Settings.MaxIncome)
    
    local eligible = {}
    for _, u in ipairs(allUnits) do
        local pass = true
        if u.isUntradeable then pass = false end
        if not Settings.AllowLocked and u.isLocked then pass = false end
        if not Settings.AllowEquipped and u.isEquipped then pass = false end
        if protectedBestMap[u.uuid] then pass = false end
        
        if pass then
            if minIncomeVal > 0 and u.income < minIncomeVal then
                pass = false
            end
            if maxIncomeVal > 0 and u.income > maxIncomeVal then
                pass = false
            end
        end
        
        if pass then
            table.insert(eligible, u)
        end
    end
    
    
    if Settings.SortStrategy == "HighestQualifying" then
        table.sort(eligible, function(a, b) return a.income > b.income end)
    else
        table.sort(eligible, function(a, b) return a.income < b.income end)
    end
    
    return eligible, #allUnits
end




local function isTargetPlayer(username)
    if not username then return false end
    if Settings.AcceptAnyRequester or #(Settings.TargetPlayers or {}) == 0 then
        return true
    end
    local lower = username:lower()
    for _, target in ipairs(Settings.TargetPlayers or {}) do
        if target and target:lower() == lower then
            return true
        end
    end
    return false
end

local function isTargetCompleted(username)
    if not username then return false end
    local count = Settings.TradedUsers[username] or 0
    return count >= (tonumber(Settings.UnitsPerPlayer) or 1)
end

local function findHostPlayer()
    local host = tostring(Settings.HostUsername or ""):lower():gsub("%s+", "")
    if host == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == host and p ~= localPlayer then
            return p
        end
    end
    return nil
end

local function isHostPlayer(playerObj)
    if not playerObj then return false end
    local host = tostring(Settings.HostUsername or ""):lower():gsub("%s+", "")
    return host ~= "" and playerObj.Name:lower() == host
end

local function getNextEligibleTarget()
    if Settings.TargetPlayers and #Settings.TargetPlayers > 0 then
        for _, targetName in ipairs(Settings.TargetPlayers) do
            if targetName and targetName ~= "" and not isTargetCompleted(targetName) then
                local lower = targetName:lower():gsub("%s+", "")
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == lower and p ~= localPlayer then
                        return p
                    end
                end
            end
        end
    elseif Settings.AcceptAnyRequester then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and not isTargetCompleted(p.Name) then
                return p
            end
        end
    end
    return nil
end




TradeEventRemote.OnClientEvent:Connect(function(eventType, payload)
    if not Settings.AutoTrade or Settings.Role == "Off" then
        return
    end
    
    if eventType == "RequestReceived" then
        local sender = payload and payload.player
        if not sender then return end
        
        log(string.format("Trade request received from %s", sender.Name), UI.Colors.accentCyan)
        
        if Settings.Role == "Sender" then
            local isAllowed = isTargetPlayer(sender.Name)
            if isAllowed then
                if isTargetCompleted(sender.Name) then
                    log(string.format("%s has already received their unit limit (%d/%d). Declining.", sender.Name, Settings.TradedUsers[sender.Name] or 0, Settings.UnitsPerPlayer), UI.Colors.accentOrange)
                    RespondToRequestRemote:FireServer(false)
                elseif Settings.AutoAcceptRequest then
                    log(string.format("Accepting trade request from alt %s...", sender.Name), UI.Colors.successGreen)
                    RespondToRequestRemote:FireServer(true)
                end
            else
                log(string.format("Ignoring request from non-target user %s", sender.Name), UI.Colors.textMuted)
            end
        elseif Settings.Role == "Receiver" then
            local isHost = isHostPlayer(sender) or (Settings.AcceptAnyRequester == true)
            if isHost then
                if Settings.HasReceived then
                    log("Self already received unit. Declining trade.", UI.Colors.accentOrange)
                    RespondToRequestRemote:FireServer(false)
                elseif Settings.AutoAcceptRequest then
                    log(string.format("Accepting trade request from Host %s...", sender.Name), UI.Colors.successGreen)
                    RespondToRequestRemote:FireServer(true)
                end
            else
                log(string.format("Ignoring request from non-host user %s (Configured Host: %s)", sender.Name, tostring(Settings.HostUsername)), UI.Colors.textMuted)
            end
        end
        return
    end
    
    if eventType == "RequestSent" then
        local target = payload and payload.player
        if target then
            log(string.format("Trade request successfully sent to %s", target.Name), UI.Colors.accentBlend)
            setStatus("WAITING FOR " .. target.Name:upper(), UI.Colors.accentBlend)
        end
        return
    end
    
    if eventType == "RequestClosed" or eventType == "RequestExpired" then
        log("Trade request expired or closed.", UI.Colors.textMuted)
        if not inTradeSession then
            setStatus("IDLE", UI.Colors.textSecondary)
        end
        return
    end
    
    if eventType == "Started" then
        local partner = payload and payload.partner
        if not partner then return end
        
        activeTradePartner = partner
        lastTradePartnerName = partner.Name
        inTradeSession = true
        activeTradeData = nil
        lastOfferedUnitUUID = nil
        isAdvancing = false
        isConfirming = false
        tradeSessionStartTime = tick()
        confirmPhaseStartTime = 0
        
        log(string.format("Trade session STARTED with %s!", partner.Name), UI.Colors.successGreen)
        setStatus("TRADING WITH " .. partner.Name:upper(), UI.Colors.accentCyan)
        
        if Settings.Role == "Sender" then
            task.spawn(function()
                task.wait(0.5)
                if not inTradeSession then return end
                
                local eligibleUnits = evaluateInventory()
                if #eligibleUnits == 0 then
                    log("No eligible units found matching filter criteria! Cancelling trade.", UI.Colors.dangerRed)
                    CancelTradeRemote:FireServer()
                    return
                end
                
                local unitToGive = eligibleUnits[1]
                lastOfferedUnitUUID = unitToGive.uuid
                log(string.format("Offering Unit: %s (%s, Lvl %d, %s)", unitToGive.name, unitToGive.formatted, unitToGive.level, unitToGive.mutation), UI.Colors.accentGreen)
                ChangeOfferRemote:FireServer(unitToGive.uuid, 1)
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
        local otherReady = payload and payload.otherReady or false
        local otherAccepted = payload and payload.otherAccepted or false
        local ownOffer = payload and payload.ownOffer or {}
        
        
        if phase == "Confirm" or phase == "Saving" then
            if confirmPhaseStartTime == 0 then
                confirmPhaseStartTime = tick()
            end
        end
        
        if Settings.Role == "Sender" and Settings.AutoAdvance then
            if phase == "Offer" then
                local hasOffer = false
                for _, count in pairs(ownOffer) do
                    if count and count > 0 then hasOffer = true break end
                end
                
                if not hasOffer and not lastOfferedUnitUUID then
                    local eligibleUnits = evaluateInventory()
                    if #eligibleUnits > 0 then
                        local unitToGive = eligibleUnits[1]
                        lastOfferedUnitUUID = unitToGive.uuid
                        log(string.format("Offering Unit: %s (%s)", unitToGive.name, unitToGive.formatted), UI.Colors.accentGreen)
                        ChangeOfferRemote:FireServer(unitToGive.uuid, 1)
                    end
                elseif hasOffer and not ownReady and not isAdvancing then
                    isAdvancing = true
                    task.spawn(function()
                        task.wait(math.max(0.3, tonumber(Settings.SafetyDelay) or 0.8))
                        if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                            log("Sender clicking READY...", UI.Colors.accentCyan)
                            AdvanceTradeRemote:FireServer()
                        end
                        isAdvancing = false
                    end)
                end
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isConfirming then
                isConfirming = true
                task.spawn(function()
                    local countdown = (TradeConfig and tonumber(TradeConfig.COUNTDOWN_DURATION)) or 3
                    local delayTime = countdown + 0.3 + math.max(0, tonumber(Settings.SafetyDelay) or 0.5)
                    task.wait(delayTime)
                    local retries = 0
                    while inTradeSession and activeTradeData and (activeTradeData.phase == "Confirm" or activeTradeData.phase == "Saving") and not activeTradeData.ownAccepted and retries < 15 do
                        log(string.format("Sender clicking CONFIRM ACCEPT (attempt %d)...", retries + 1), UI.Colors.accentGreen)
                        AdvanceTradeRemote:FireServer()
                        retries = retries + 1
                        task.wait(0.6)
                    end
                    isConfirming = false
                end)
            end
        end
        
        if Settings.Role == "Receiver" and Settings.AutoAdvance then
            if phase == "Offer" and not ownReady and not isAdvancing then
                isAdvancing = true
                task.spawn(function()
                    task.wait(math.max(0.4, tonumber(Settings.SafetyDelay) or 0.8))
                    if inTradeSession and activeTradeData and activeTradeData.phase == "Offer" and not activeTradeData.ownReady then
                        log("Receiver clicking READY...", UI.Colors.accentCyan)
                        AdvanceTradeRemote:FireServer()
                    end
                    isAdvancing = false
                end)
            elseif (phase == "Confirm" or phase == "Saving") and not ownAccepted and not isConfirming then
                isConfirming = true
                task.spawn(function()
                    local countdown = (TradeConfig and tonumber(TradeConfig.COUNTDOWN_DURATION)) or 3
                    local delayTime = countdown + 0.3 + math.max(0, tonumber(Settings.SafetyDelay) or 0.5)
                    task.wait(delayTime)
                    local retries = 0
                    while inTradeSession and activeTradeData and (activeTradeData.phase == "Confirm" or activeTradeData.phase == "Saving") and not activeTradeData.ownAccepted and retries < 15 do
                        log(string.format("Receiver clicking CONFIRM ACCEPT (attempt %d)...", retries + 1), UI.Colors.accentGreen)
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
    
    if eventType == "Ended" then
        local reason = (type(payload) == "table" and payload.reason) or (type(payload) == "string" and payload) or "Completed"
        local partnerName = (activeTradePartner and activeTradePartner.Name) or lastTradePartnerName or "Unknown"
        local wasSuccessful = (reason == "Completed" or reason == "Success" or (lastOfferedUnitUUID ~= nil and activeTradeData and activeTradeData.phase == "Saving"))
        
        log(string.format("Trade session ENDED. Reason: %s", tostring(reason)), (wasSuccessful and UI.Colors.successGreen or UI.Colors.dangerRed))
        
        if wasSuccessful or reason == "Completed" then
            if Settings.Role == "Sender" and partnerName ~= "Unknown" then
                Settings.TradedUsers[partnerName] = (Settings.TradedUsers[partnerName] or 0) + 1
                Settings.Save()
                log(string.format("[SUCCESS] Unit successfully given to %s (%d/%d done)!", partnerName, Settings.TradedUsers[partnerName], Settings.UnitsPerPlayer), UI.Colors.successGreen)
            elseif Settings.Role == "Receiver" then
                Settings.HasReceived = true
                Settings.Save()
                log("[SUCCESS] Successfully received unit from Host! Receiver task complete.", UI.Colors.successGreen)
                triggerFarmerV5Switch("Receiver Unit Received")
            end
        end
        
        inTradeSession = false
        activeTradePartner = nil
        activeTradeData = nil
        lastOfferedUnitUUID = nil
        isAdvancing = false
        isConfirming = false
        tradeSessionStartTime = 0
        confirmPhaseStartTime = 0
        setStatus("IDLE", UI.Colors.textSecondary)
        return
    end
end)




-- Trade Watchdog: Anti-Stuck & Auto-Recovery Loop
task.spawn(function()
    while task.wait(1) do
        if inTradeSession and Settings.AutoTrade and Settings.AutoAdvance then
            local phase = activeTradeData and activeTradeData.phase
            local ownAccepted = activeTradeData and activeTradeData.ownAccepted
            
            -- Anti-stuck for Confirm/Saving phase (server countdown is 3s)
            if (phase == "Confirm" or phase == "Saving") and not ownAccepted then
                local countdown = (TradeConfig and tonumber(TradeConfig.COUNTDOWN_DURATION)) or 3
                if confirmPhaseStartTime > 0 and (tick() - confirmPhaseStartTime >= countdown + 0.8) then
                    AdvanceTradeRemote:FireServer()
                end
            end
            
            -- Anti-stuck for entire trade session: if stuck for > 35s, cancel and reset
            if tradeSessionStartTime > 0 and (tick() - tradeSessionStartTime > 35) then
                log("[Watchdog] Trade session stuck for > 35s! Cancelling trade to recover...", UI.Colors.dangerRed)
                CancelTradeRemote:FireServer()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            
            if Settings.AutoReenableTrades and DataController.TradeRequestsEnabled and not DataController.TradeRequestsEnabled() then
                SetTradeRequestsEnabledRemote:FireServer(true)
            end
            
            if not Settings.AutoTrade or Settings.Role == "Off" or inTradeSession then
                return
            end
            
            local now = tick()
            local interval = tonumber(Settings.RequestInterval) or 6
            if now - lastRequestTime < interval then
                return
            end
            
            
            pcall(function()
                local historyFile = Settings.HISTORY_FILE or "Hiphub/ad-trade/history.json"
                if isfile and readfile and isfile(historyFile) then
                    local raw = readfile(historyFile)
                    if raw and raw ~= "" then
                        local h = game:GetService("HttpService"):JSONDecode(raw)
                        if h and h.TradedUsers and type(h.TradedUsers) == "table" then
                            Settings.TradedUsers = h.TradedUsers
                        end
                    end
                end
            end)
            
            
            if Settings.Role == "Receiver" then
                local myCount = Settings.TradedUsers[localPlayer.Name] or 0
                local isDone = (myCount >= (tonumber(Settings.UnitsPerPlayer) or 1)) or Settings.HasReceived
                
                if isDone then
                    Settings.HasReceived = true
                    if toggleHasReceived and toggleHasReceived.Set then
                        toggleHasReceived.Set(true)
                    end
                    setStatus("RECEIVED (DONE)", UI.Colors.successGreen)
                    triggerFarmerV5Switch("Receiver Status Done")
                    return 
                else
                    if toggleHasReceived and toggleHasReceived.Set and toggleHasReceived.Get() ~= false then
                        toggleHasReceived.Set(false)
                    end
                end
            end
            
            
            if Settings.Role == "Sender" and Settings.AutoRequest then
                local nextTarget = getNextEligibleTarget()
                if nextTarget then
                    lastRequestTime = now
                    log(string.format("Auto-sending trade request to next queue target: %s", nextTarget.Name), UI.Colors.accentBlend)
                    RequestTradeRemote:FireServer(nextTarget)
                else
                    if Settings.AcceptAnyRequester or #(Settings.TargetPlayers or {}) == 0 then
                        setStatus("WAITING FOR ALTS TO REQUEST", UI.Colors.textSecondary)
                    else
                        
                        local anyPending = false
                        for _, t in ipairs(Settings.TargetPlayers or {}) do
                            if t ~= "" and not isTargetCompleted(t) then
                                anyPending = true
                                break
                            end
                        end
                        if not anyPending and #(Settings.TargetPlayers or {}) > 0 then
                            setStatus("ALL TARGETS COMPLETED", UI.Colors.successGreen)
                        else
                            setStatus("WAITING FOR TARGETS", UI.Colors.textSecondary)
                        end
                    end
                end
            end
            
            
            if Settings.Role == "Receiver" and Settings.AutoRequest then
                if Settings.HasReceived then
                    setStatus("RECEIVED (DONE)", UI.Colors.successGreen)
                    triggerFarmerV5Switch("Receiver Status Done")
                    return
                end
                
                local hostPlayer = findHostPlayer()
                if hostPlayer then
                    lastRequestTime = now
                    log(string.format("Auto-sending trade request to Host: %s", hostPlayer.Name), UI.Colors.accentBlend)
                    RequestTradeRemote:FireServer(hostPlayer)
                else
                    setStatus("WAITING FOR HOST: " .. tostring(Settings.HostUsername), UI.Colors.accentOrange)
                end
            end
        end)
    end
end)





local secRole = UI.CreateSection(UI.Tabs.Trade, "1. ROLE & MASTER SWITCH", 1)
local toggleMaster = UI.CreateToggle(secRole, "Enable Smart Auto Trade", Settings.AutoTrade, function(s)
    Settings.AutoTrade = s
    Settings.Save()
    log("Auto Trade master switch: " .. (s and "ENABLED" or "DISABLED"), s and UI.Colors.accentCyan or UI.Colors.dangerRed)
end, 1)

local dropRole = UI.CreateDropdown(secRole, "Active Account Role", { "Sender", "Receiver", "Off" }, Settings.Role, function(role)
    Settings.Role = role
    Settings.Save()
    log("Switched role to: " .. tostring(role), UI.Colors.accentViolet)
    setStatus(role == "Off" and "OFF" or "IDLE", UI.Colors.textSecondary)
end, 2)

local secHost = UI.CreateSection(UI.Tabs.Trade, "2. HOST & ALT DISTRIBUTION CONFIG", 2)
local inputHost = UI.CreateTextInput(secHost, "Host Account Username", Settings.HostUsername, "e.g. itrast11", function(text)
    Settings.HostUsername = text:gsub("%s+", "")
    Settings.Save()
    log("Updated Host Username to: " .. Settings.HostUsername, UI.Colors.accentCyan)
end, 1)

local toggleAcceptAny = UI.CreateToggle(secHost, "Accept Any Alt Requester", Settings.AcceptAnyRequester, function(s)
    Settings.AcceptAnyRequester = s
    Settings.Save()
    log("Accept Any Alt Requester: " .. tostring(s), UI.Colors.accentCyan)
end, 2)

local inputTargets = UI.CreateTextInput(secHost, "Target Alts (Optional Whitelist)", table.concat(Settings.TargetPlayers or {}, ", "), "Leave empty for all alts", function(text)
    local list = {}
    for name in string.gmatch(text, "[^,%s]+") do
        table.insert(list, name)
    end
    Settings.TargetPlayers = list
    Settings.Save()
    log("Updated Target Players whitelist: " .. table.concat(list, ", "), UI.Colors.accentCyan)
end, 3)

local btnResetHistory = UI.CreateButton(secHost, "Reset All Completed Traded History", function()
    Settings.TradedUsers = {}
    Settings.HasReceived = false
    Settings.Save()
    log("Reset all completed traded records!", UI.Colors.accentOrange)
    setStatus("IDLE", UI.Colors.textSecondary)
end, 4, "danger")

local secReceiver = UI.CreateSection(UI.Tabs.Trade, "3. ALT (RECEIVER) STATUS", 3)
local toggleHasReceived = UI.CreateToggle(secReceiver, "Has Received Unit (Done Flag)", Settings.HasReceived, function(s)
    Settings.HasReceived = s
    Settings.Save()
    log("Receiver Done state set to: " .. tostring(s), UI.Colors.accentCyan)
    if s and Settings.Role == "Receiver" then
        triggerFarmerV5Switch("Receiver Manual Toggle")
    end
end, 1)

local toggleFarmerReceiver = UI.CreateToggle(secReceiver, "Auto Swap FarmerV5 on Done", Settings.FarmerV5.Enabled, function(s)
    Settings.FarmerV5.Enabled = s
    Settings.Save()
    log("FarmerV5 Auto Swap set to: " .. tostring(s), UI.Colors.accentCyan)
end, 2)


local secFilters = UI.CreateSection(UI.Tabs.Filters, "UNIT DISTRIBUTION CRITERIA", 1)
local inputMinIncome = UI.CreateTextInput(secFilters, "Min Income (e.g. 100t/s)", Settings.MinIncome, "100t/s, 1qd, 100b", function(text)
    Settings.MinIncome = text
    Settings.Save()
    log(string.format("Min Income threshold set to: %s (%s)", text, formatIncome(parseIncome(text))), UI.Colors.accentCyan)
end, 1)

local inputMaxIncome = UI.CreateTextInput(secFilters, "Max Income (Optional Limit)", Settings.MaxIncome, "Leave empty for unlimited", function(text)
    Settings.MaxIncome = text
    Settings.Save()
    log("Max Income limit set to: " .. tostring(text), UI.Colors.accentCyan)
end, 2)

local inputKeepTop = UI.CreateTextInput(secFilters, "Keep Top X Best Units (Protect)", tostring(Settings.KeepTopX), "0 = don't protect, 5 = keep top 5", function(text)
    local num = tonumber(text) or 0
    Settings.KeepTopX = num
    Settings.Save()
    log(string.format("Protecting top %d best units from trade.", num), UI.Colors.accentCyan)
end, 3)

local toggleEquipped = UI.CreateToggle(secFilters, "Allow Trading Equipped Units", Settings.AllowEquipped, function(s)
    Settings.AllowEquipped = s
    Settings.Save()
    log("Allow Equipped Units: " .. tostring(s), UI.Colors.accentCyan)
end, 4)

local toggleLocked = UI.CreateToggle(secFilters, "Allow Trading Locked Units", Settings.AllowLocked, function(s)
    Settings.AllowLocked = s
    Settings.Save()
    log("Allow Locked Units: " .. tostring(s), UI.Colors.accentCyan)
end, 5)

local previewCard = UI.CreateInfoCard(secFilters, "Eligible Units Preview", "Loading unit stats...", 6)

local function updatePreview()
    pcall(function()
        local eligible, total = evaluateInventory()
        local minInc = formatIncome(parseIncome(Settings.MinIncome))
        local desc = string.format("Total Units in Backpack: %d\nEligible for Trade (>= %s): %d", total, minInc, #eligible)
        if #eligible > 0 then
            desc = desc .. string.format("\nFirst Unit to Distribute: %s (%s, Lvl %d, %s)", eligible[1].name, eligible[1].formatted, eligible[1].level, eligible[1].mutation)
        else
            desc = desc .. "\nNo units meet the current criteria!"
        end
        previewCard.SetDesc(desc)
    end)
end

task.spawn(function()
    while task.wait(3) do
        updatePreview()
    end
end)
updatePreview()


local secAuto = UI.CreateSection(UI.Tabs.Automation, "AUTOMATION & TIMINGS", 1)
local toggleAutoReq = UI.CreateToggle(secAuto, "Auto Send Trade Requests", Settings.AutoRequest, function(s)
    Settings.AutoRequest = s
    Settings.Save()
end, 1)

local toggleAutoAccept = UI.CreateToggle(secAuto, "Auto Accept Incoming Requests", Settings.AutoAcceptRequest, function(s)
    Settings.AutoAcceptRequest = s
    Settings.Save()
end, 2)

local toggleAutoAdv = UI.CreateToggle(secAuto, "Auto Ready & Accept (Advance Trade)", Settings.AutoAdvance, function(s)
    Settings.AutoAdvance = s
    Settings.Save()
end, 3)

local inputDelay = UI.CreateTextInput(secAuto, "Safety Delay (Seconds)", tostring(Settings.SafetyDelay), "0.8", function(text)
    local n = tonumber(text) or 0.8
    Settings.SafetyDelay = n
    Settings.Save()
end, 4)

local inputReqInterval = UI.CreateTextInput(secAuto, "Request Interval (Seconds)", tostring(Settings.RequestInterval), "6", function(text)
    local n = tonumber(text) or 6
    Settings.RequestInterval = n
    Settings.Save()
end, 5)


local secFarmer = UI.CreateSection(UI.Tabs.Automation, "FARMERV5 AUTO CHANGE (GANTI AKUN)", 2)

local toggleFarmer = UI.CreateToggle(secFarmer, "Enable FarmerV5 Signal (Receiver Done)", Settings.FarmerV5.Enabled, function(s)
    Settings.FarmerV5.Enabled = s
    Settings.Save()
    log("FarmerV5 Auto Change set to: " .. tostring(s), UI.Colors.accentCyan)
end, 1)

local inputFarmerKey = UI.CreateTextInput(secFarmer, "FarmerV5 API Key", tostring(Settings.FarmerV5.ApiKey or ""), "ak_...", function(text)
    Settings.FarmerV5.ApiKey = text
    Settings.Save()
end, 2)

local inputFarmerOption = UI.CreateTextInput(secFarmer, "Autoswap Rule (Option)", tostring(Settings.FarmerV5.Option or 1), "1", function(text)
    Settings.FarmerV5.Option = tonumber(text) or 1
    Settings.Save()
end, 3)

local inputFarmerUrl = UI.CreateTextInput(secFarmer, "Base URL (Domain / IP)", tostring(Settings.FarmerV5.BaseUrl or "https://accountops.org"), "https://accountops.org", function(text)
    Settings.FarmerV5.BaseUrl = text
    Settings.Save()
end, 4)

UI.CreateButton(secFarmer, "Test Send FarmerV5 Signal", function()
    log("FarmerV5: Manual test trigger initiated...", UI.Colors.accentBlend)
    triggerFarmerV5Switch("Manual Test")
end, 5, "primary")


UI.CreateButton(UI.Tabs.Logs, "Clear Log History", function()
    logConsole.Clear()
end, 2, "secondary")

log("Smart Auto Trade system initialized successfully!", UI.Colors.successGreen)
log(string.format("Loaded as role: %s | Target count: %d", Settings.Role, #(Settings.TargetPlayers or {})), UI.Colors.accentCyan)

_G.HipHub_AD_Trade = {
    Settings = Settings,
    UI = UI,
    EvaluateInventory = evaluateInventory,
    ParseIncome = parseIncome,
    FormatIncome = formatIncome,
    TriggerFarmerV5Switch = triggerFarmerV5Switch
}

end