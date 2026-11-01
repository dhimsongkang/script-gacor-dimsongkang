-- NODEHUB_STATUS_TOAST
-- Popup status kanan-bawah, tema NODE HUB (hitam + emas)

local function NodeHubToast(kind, title, text, dur)
	kind = tostring(kind or "info")
	title = tostring(title or "NODE HUB")
	text = tostring(text or "")
	dur = tonumber(dur) or 5
	if dur < 2 then
		dur = 2
	end

	local accent = Color3.fromRGB(255, 217, 0)
	if kind == "error" then
		accent = Color3.fromRGB(255, 72, 72)
	elseif kind == "success" then
		accent = Color3.fromRGB(86, 214, 132)
	elseif kind == "warn" then
		accent = Color3.fromRGB(255, 176, 64)
	elseif kind == "expired" then
		accent = Color3.fromRGB(255, 72, 72)
		kind = "error"
	end

	task.spawn(function()
		pcall(function()
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end
		end)

		local Players = game:GetService("Players")
		local CoreGui = game:GetService("CoreGui")
		local TweenService = game:GetService("TweenService")
		local lp = Players.LocalPlayer
		if not lp then
			lp = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		end

		local function wipe(parent)
			if not parent then
				return
			end
			for _, ch in ipairs(parent:GetChildren()) do
				if ch.Name == "NodeHubStatusToast" then
					pcall(function()
						ch:Destroy()
					end)
				end
			end
		end
		wipe(CoreGui)
		if lp then
			wipe(lp:FindFirstChild("PlayerGui"))
		end

		local sg = Instance.new("ScreenGui")
		sg.Name = "NodeHubStatusToast"
		sg.ResetOnSpawn = false
		sg.IgnoreGuiInset = true
		sg.DisplayOrder = 1000001
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
		pcall(function()
			if syn and syn.protect_gui then
				syn.protect_gui(sg)
			end
		end)
		local okParent = pcall(function()
			sg.Parent = CoreGui
		end)
		if not okParent or not sg.Parent then
			if lp then
				sg.Parent = lp:WaitForChild("PlayerGui", 8)
			end
		end
		if not sg.Parent then
			return
		end

		local root = Instance.new("Frame")
		root.Name = "Card"
		root.AnchorPoint = Vector2.new(1, 1)
		root.Position = UDim2.new(1, 18, 1, -14)
		root.Size = UDim2.fromOffset(188, 38)
		root.AutomaticSize = Enum.AutomaticSize.Y
		root.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		root.BackgroundTransparency = 0.06
		root.BorderSizePixel = 0
		root.ZIndex = 1000002
		root.Parent = sg

		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, 6)
		pad.PaddingBottom = UDim.new(0, 7)
		pad.PaddingLeft = UDim.new(0, 8)
		pad.PaddingRight = UDim.new(0, 8)
		pad.Parent = root

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = root

		local stroke = Instance.new("UIStroke")
		stroke.Color = accent
		stroke.Thickness = 1
		stroke.Transparency = 0.32
		stroke.Parent = root

		local bar = Instance.new("Frame")
		bar.Name = "Accent"
		bar.Size = UDim2.new(0, 2, 1, 0)
		bar.Position = UDim2.fromOffset(0, 0)
		bar.BackgroundColor3 = accent
		bar.BorderSizePixel = 0
		bar.ZIndex = 1000003
		bar.Parent = root

		local barCorner = Instance.new("UICorner")
		barCorner.CornerRadius = UDim.new(1, 0)
		barCorner.Parent = bar

		local kicker = Instance.new("TextLabel")
		kicker.BackgroundTransparency = 1
		kicker.Position = UDim2.fromOffset(8, 0)
		kicker.Size = UDim2.new(1, -8, 0, 10)
		kicker.Font = Enum.Font.GothamBold
		kicker.TextSize = 8
		kicker.TextXAlignment = Enum.TextXAlignment.Left
		kicker.TextColor3 = accent
		kicker.Text = string.upper(title)
		kicker.ZIndex = 1000003
		kicker.Parent = root

		local body = Instance.new("TextLabel")
		body.BackgroundTransparency = 1
		body.Position = UDim2.fromOffset(8, 11)
		body.Size = UDim2.new(1, -8, 0, 16)
		body.AutomaticSize = Enum.AutomaticSize.Y
		body.Font = Enum.Font.Gotham
		body.TextSize = 11
		body.TextXAlignment = Enum.TextXAlignment.Left
		body.TextYAlignment = Enum.TextYAlignment.Top
		body.TextWrapped = true
		body.TextColor3 = Color3.fromRGB(228, 228, 228)
		body.Text = text
		body.ZIndex = 1000003
		body.Parent = root

		TweenService:Create(
			root,
			TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(1, -12, 1, -14) }
		):Play()

		task.delay(dur, function()
			if not sg.Parent then
				return
			end
			local tw = TweenService:Create(
				root,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{
					Position = UDim2.new(1, 22, 1, -14),
					BackgroundTransparency = 1,
				}
			)
			TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
			TweenService:Create(kicker, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			TweenService:Create(body, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			TweenService:Create(bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
			tw:Play()
			tw.Completed:Wait()
			pcall(function()
				sg:Destroy()
			end)
		end)
	end)
end

local _env = (getgenv and getgenv()) or _G
_env.NodeHubToast = NodeHubToast
_G.NodeHubToast = NodeHubToast
local ENV = (getgenv and getgenv()) or _G
-- Flag di getgenv bisa terbawa dari server lama (Arceus) → hanya blok kalau JobId sama.
-- BUSY/LOADING yang macet terlalu lama dianggap basi supaya re-exec manual tetap bisa.
do
    local jobNow = tostring(game.JobId or "")
    local sameJob = jobNow ~= "" and ENV.__NODEHUB_BOOT_JOB == jobNow
    local age = os.clock() - (tonumber(ENV.__NODEHUB_BOOT_AT) or 0)
    local running = ENV.__NODEHUB_BOOT_RUNNING == true
    local pending = (ENV.__NODEHUB_BOOT_BUSY == true or ENV.__NODEHUB_BOOT_LOADING == true) and age < 120
    if sameJob and (running or pending) then
        NodeHubToast("warn", "NODE HUB", "Script already running", 4)
        return
    end
    ENV.__NODEHUB_BOOT_LOADING = nil
    ENV.__NODEHUB_BOOT_RUNNING = nil
    ENV.__NODEHUB_BOOT_JOB = jobNow
    ENV.__NODEHUB_BOOT_AT = os.clock()
end
ENV.__NODEHUB_BOOT_BUSY = true
NodeHubToast("info", "NODE HUB", "Checking license...", 6)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local player = Players.LocalPlayer
if not player then
    player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
if player then
    pcall(function()
        player:WaitForChild("PlayerGui", 5)
    end)
end
local url = "https://golaspay.net/verify_v2_bQXVf5a7Ek/VOeYa4nTAk0/eAfoZYkaG1NTpNImX1qb/7607"
if not player then
    ENV.__NODEHUB_BOOT_BUSY = false
    NodeHubToast("error", "NODE HUB", "LocalPlayer belum ready", 8)
    return
end
local function runBody(res, fallback)
    local body = nil
    if type(res) == "table" then
        body = res.Body or res.body
    end
    if type(body) == "string" and #body > 8 then
        local fn = loadstring(body)
        if type(fn) == "function" then
            local ok, err = pcall(fn)
            ENV.__NODEHUB_BOOT_BUSY = false
            if not ok then
                NodeHubToast("error", "NODE HUB", tostring(err), 8)
            end
            return
        end
    end
    ENV.__NODEHUB_BOOT_BUSY = false
    NodeHubToast("error", "NODE HUB", tostring(fallback or "Request failed"), 8)
end
local bodyData = {
    b5Nvcn0H = player.Name,
    kA2ltThLcI = player.UserId,
    wR8Da4uXTwx = game.PlaceId,
    ejBJ5iYyu = game.JobId,
    alT23urpc8ve = game.GameId,
    multiplayer = "0",
    player  = player.Name,
    userId  = player.UserId,
    placeId = game.PlaceId,
    jobId   = game.JobId,
    gameId  = game.GameId
}
local jsonBody = HttpService:JSONEncode(bodyData)
local function resBody(res)
    if type(res) ~= "table" then
        return nil
    end
    local b = res.Body or res.body
    if type(b) == "string" then
        return b
    end
    return nil
end
local function httpOk(res)
    if type(res) ~= "table" then
        return false
    end
    local code = tonumber(res.StatusCode or res.Status or res.status_code or res.statusCode)
    local body = resBody(res)
    return code == 200 and body ~= nil and #body > 8
end
local function doPost(targetUrl, body)
    local req = {
        Url = targetUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["User-Agent"] = "MyExecutorLoader"
        },
        Body = body
    }
    local ok, res = pcall(function()
        if syn and syn.request then
            return syn.request(req)
        end
        if http_request then
            return http_request(req)
        end
        if request then
            return request(req)
        end
        return nil
    end)
    if ok then
        return res
    end
    return nil
end
-- Fast path: 1 attempt dulu. Retry singkat hanya jika gagal (Arceus hang).
local function doPostRetry(targetUrl, body, tries, label)
    tries = tonumber(tries) or 2
    local last = nil
    for i = 1, tries do
        if i == 1 then
            NodeHubToast("info", "NODE HUB", tostring(label or "Loading"), 4)
        else
            NodeHubToast("warn", "NODE HUB", tostring(label or "Retry") .. " " .. tostring(i) .. "/" .. tostring(tries), 3)
            task.wait(0.25)
        end
        last = doPost(targetUrl, body)
        if httpOk(last) then
            return last
        end
    end
    return last
end
local okBoot, bootErr = pcall(function()
    local res1 = doPostRetry(url, jsonBody, 2, "Checking license")
    if not httpOk(res1) then
        runBody(res1, "Verify failed")
        return
    end
    local raw = resBody(res1)
    local okDec, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not (okDec and type(decoded) == "table" and decoded.status == "ok" and type(decoded.sc_link) == "string" and decoded.sc_link ~= "") then
        runBody(res1, "Verify rejected")
        return
    end
    if decoded.roblox_id ~= nil then
        bodyData.userId = decoded.roblox_id
    end
    if decoded.job_id ~= nil then
        bodyData.jobId = decoded.job_id
    end
    jsonBody = HttpService:JSONEncode(bodyData)
    local res2 = doPostRetry(decoded.sc_link, jsonBody, 2, "Downloading script")
    if httpOk(res2) then
        runBody(res2, "Failed to load script")
    else
        ENV.__NODEHUB_BOOT_BUSY = false
        NodeHubToast("error", "NODE HUB", "Script download failed - execute lagi", 8)
    end
end)
if not okBoot then
    ENV.__NODEHUB_BOOT_BUSY = false
    NodeHubToast("error", "NODE HUB", "Boot error: " .. tostring(bootErr), 8)
end