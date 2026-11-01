-- NodeHub Dynamic URL Loader — Grow A Garden 2
-- game.GameId 10200395747
-- Headless: no center NODE HUB popup. Toast only.


local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
LP:WaitForChild("PlayerGui")
task.wait()

------------------------------------------------------------
-- DOUBLE EXECUTE LOCK
------------------------------------------------------------
local ENV = (getgenv and getgenv()) or _G

if ENV.__NODEHUB_BOOT_LOADING == true or ENV.__NODEHUB_BOOT_RUNNING == true then
    pcall(function()
        local toast = ENV.NodeHubToast or _G.NodeHubToast
        if toast then
            toast("warn", "NODE HUB", "Script already running", 4)
        else
            warn("[NodeHub Loader] Already running, double execute blocked.")
        end
    end)
    return {
        ok = false,
        error = "already_running",
    }
end

ENV.__NODEHUB_BOOT_LOADING = true

------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------
local AUTO_QR         = "%auto_qr%"
local NON_BLOCKING    = true
local TIMEOUT_SEC     = 10
local RETRIES         = 5
local RETRY_DELAY     = 5
local CHECK_WORLD_SEC = 2.5

-- Hide popup saat loading
local ALLOW_HIDE_DURING_LOADING = true

------------------------------------------------------------
-- DEBUG CONTROL
-- DEBUG_ENABLED = false    -> warn() debug tidak keluar
-- SHOW_DEBUG_PANEL = false -> panel debug tidak tampil
-- Trace tetap diisi untuk Discord (disensor)
------------------------------------------------------------
local DEBUG_ENABLED    = false
local SHOW_DEBUG_PANEL = false

------------------------------------------------------------
-- CONFIG URL ROUTES (per game.GameId)
-- URL rahasia: jangan print URL langsung.
------------------------------------------------------------
local GAME_ID_GAG2 = "10200395747"

local GAME_ROUTE_SETS = {
    [GAME_ID_GAG2] = {
        {
            name = "gag2",
            url = "https://golaspay.net/getsc_verify/mainuiB0srrj8DVvCpV70kBdHx9Op1793490455__52JEbIHrQOuV6v45",
            query = AUTO_QR,
            default = true,
            key = nil,
        },
    },
}

------------------------------------------------------------
-- SERVICES
------------------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

------------------------------------------------------------
-- STATE
------------------------------------------------------------
local CANCELLED = false
local DEBUG_LINES = {}

------------------------------------------------------------
-- DEBUG HELPERS
------------------------------------------------------------
local function sanitizeText(s)
    s = tostring(s or "")

    -- Sensor URL http/https
    s = s:gsub("https?://[%w%p]+", "[URL_HIDDEN]")

    -- Sensor shortcode: %[[[...]]]%
    s = s:gsub("%%%[%[%[[^%]]+%]%]%]%%", "[SHORTCODE_HIDDEN]")

    -- Sensor query yang mungkin mengandung token
    s = s:gsub("%?[%w%p]+", "?[QUERY_HIDDEN]")

    return s
end

local function pushDebug(...)
    local parts = {}
    for i = 1, select("#", ...) do
        parts[#parts + 1] = sanitizeText(select(i, ...))
    end

    local line = "[NodeHub Loader] " .. table.concat(parts, " ")
    table.insert(DEBUG_LINES, line)

    if #DEBUG_LINES > 80 then
        table.remove(DEBUG_LINES, 1)
    end

    return line
end

local function dbg(...)
    local line = pushDebug(...)
    if DEBUG_ENABLED then
        warn(line)
    end
end

local function bodyPreview(body, maxLen)
    body = tostring(body or "")
    maxLen = tonumber(maxLen) or 180

    -- buang BOM / null yang sering bikin loadstring gagal diam-diam
    body = body:gsub("^\239\187\191", "") -- UTF-8 BOM
    body = body:gsub("%z", "")

    local compact = body:gsub("%s+", " ")
    if #compact > maxLen then
        compact = compact:sub(1, maxLen) .. "..."
    end

    return sanitizeText(compact)
end

local function normalizeBody(body)
    body = tostring(body or "")
    body = body:gsub("^\239\187\191", "")
    body = body:gsub("%z", "")
    -- trim trailing junk whitespace only (keep leading spaces for Lua)
    body = body:gsub("%s+$", "")
    return body
end

------------------------------------------------------------
-- DISCORD DEBUG (GET FALLBACK)
------------------------------------------------------------
local DEBUG_WEBHOOK_URL = "https://gtwaapi.space/sc/webhook_dc.php"

local function urlEncode(s)
    s = tostring(s or "")
    return HttpService:UrlEncode(s)
end

local function sendDiscordDebug(reason, extra)
    if not DEBUG_WEBHOOK_URL or DEBUG_WEBHOOK_URL == "" then
        warn("[NodeHub Discord Debug] DEBUG_WEBHOOK_URL kosong")
        return
    end

    local content = table.concat({
        "**NODE HUB LOADER ERROR**",
        "reason: `" .. sanitizeText(reason) .. "`",
        "player: `" .. tostring(LP and LP.Name or "?") .. "`",
        "userId: `" .. tostring(LP and LP.UserId or "?") .. "`",
        "placeId: `" .. tostring(game.PlaceId) .. "`",
        "jobId: `" .. tostring(game.JobId) .. "`",
        "gameId: `" .. tostring(game.GameId) .. "`",
        "time: `" .. os.date("%Y-%m-%d %H:%M:%S") .. "`",
        "",
        "**extra:**",
        "```",
        sanitizeText(extra or "nil"),
        "```",
        "",
        "**debug lines:**",
        "```",
        sanitizeText(table.concat(DEBUG_LINES, "\n")),
        "```",
    }, "\n")

    if #content > 1800 then
        content = content:sub(1, 1800) .. "\n...CUT..."
    end

    local payload = {
        reason = tostring(reason or "unknown"),
        player = tostring(LP and LP.Name or "?"),
        userId = tostring(LP and LP.UserId or "?"),
        placeId = tostring(game.PlaceId),
        jobId = tostring(game.JobId),
        message = content,
    }

    local json = HttpService:JSONEncode(payload)
    local url = DEBUG_WEBHOOK_URL .. "?data=" .. urlEncode(json)

    pcall(function()
        return game:HttpGet(url)
    end)
end

local function reportDebug(reason, extra)
    task.spawn(function()
        sendDiscordDebug(reason, extra)
    end)
end

------------------------------------------------------------
-- UI HELPERS
------------------------------------------------------------
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


------------------------------------------------------------
-- HEADLESS LOADER API (no center popup)
------------------------------------------------------------
local LOADER = {}

function LOADER.Set(text) end
function LOADER.SetInfo(text) end
function LOADER.SetNote(text) end
function LOADER.Debug(...)
    dbg(...)
end
function LOADER.SetProgress(p, text) end

function LOADER.Done()
    pcall(function() NodeHubToast("success", "NODE HUB", "Script loaded", 4) end)
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = true
end

function LOADER.Error(text)
    pcall(function() NodeHubToast("error", "NODE HUB", tostring(text or "Error"), 8) end)
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = false
end

function LOADER.Close()
    CANCELLED = true
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = false
end
pcall(function() NodeHubToast("info", "NODE HUB", "Loading script...", 5) end)
ENV.__NODEHUB_OUTER_LOADER = LOADER
_G.__NODEHUB_OUTER_LOADER = LOADER
ENV.LOADER = LOADER
_G.LOADER = LOADER

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function appendQuery(url, query)
    url = tostring(url or "")
    query = tostring(query or "")

    if query == "" or query == "%auto_qr%" then
        return url
    end

    if string.find(url, "?", 1, true) then
        return url .. "&" .. query
    end

    return url .. "?" .. query
end

local function hasUnreplacedShortcode(s)
    return tostring(s or ""):find("%%%[%[%[") ~= nil
end

local function booths_has_items(timeout)
    timeout = tonumber(timeout) or 1.5

    local t0 = os.clock()

    while os.clock() - t0 < timeout do
        if CANCELLED then
            return false
        end

        local tw = workspace:FindFirstChild("TradeWorld")
        local booths = tw and tw:FindFirstChild("Booths")

        if booths then
            local kids = booths:GetChildren()
            if #kids > 0 then
                return true
            end
        end

        task.wait(0.15)
    end

    return false
end

-- Garden RootPlaceId 126884695634066, market PlaceId 129954712878723 (GAG1).
local GAG1_MARKET_PLACE_IDS = {
    ["129954712878723"] = true,
}
local GAG1_GARDEN_PLACE_IDS = {
    ["126884695634066"] = true,
}

local function tryRequireRs(path)
    local ok, mod = pcall(function()
        local node = game:GetService("ReplicatedStorage")
        for seg in string.gmatch(path, "[^%.]+") do
            node = node:FindFirstChild(seg)
            if not node then
                return nil
            end
        end
        return require(node)
    end)
    if ok then
        return mod
    end
    return nil
end

local function isInMarketWorld()
    local placeId = tostring(game.PlaceId)

    if GAG1_MARKET_PLACE_IDS[placeId] then
        return true
    end

    if GAG1_GARDEN_PLACE_IDS[placeId] then
        return false
    end

    local data = tryRequireRs("Data.TradeWorldData")
    if type(data) == "table" and data.PlaceId and tostring(data.PlaceId) == placeId then
        return true
    end

    local flag = tryRequireRs("Modules.IsInTradeWorld")
    if flag == true then
        return true
    end

    local ctrl = tryRequireRs("Modules.TradeControllers.TradeWorldController")
    if type(ctrl) == "table" and type(ctrl.IsInWorld) == "function" then
        local ok, inWorld = pcall(function()
            return ctrl:IsInWorld()
        end)
        if ok and inWorld == true then
            return true
        end
    end

    return booths_has_items(CHECK_WORLD_SEC) == true
end

local function routeMatches(route)
    if type(route.condition) == "function" then
        local ok, result = pcall(route.condition)
        return ok and result == true
    end

    if route.mode == "market_when_booths" or route.mode == "market_world" then
        return isInMarketWorld() == true
    end

    return false
end

local function pickRoute(routes)
    local fallback = nil

    for _, route in ipairs(routes or {}) do
        if CANCELLED then
            return nil
        end

        if route.default == true and not fallback then
            fallback = route
        end

        if routeMatches(route) then
            return route
        end
    end

    return fallback or routes[1]
end

local function http_get(url)
    local funcs = {
        function(u)
            if syn and syn.request then
                local r = syn.request({ Url = u, Method = "GET" })
                return r and (r.Body or r.body), r and (r.StatusCode or r.status_code)
            end
        end,

        function(u)
            if http and http.request then
                local r = http.request({ Url = u, Method = "GET" })
                return r and (r.Body or r.body), r and (r.StatusCode or r.status_code)
            end
        end,

        function(u)
            if http_request then
                local r = http_request({ Url = u, Method = "GET" })
                return r and (r.Body or r.body), r and (r.StatusCode or r.status_code)
            end
        end,

        function(u)
            if request then
                local r = request({ Url = u, Method = "GET" })
                return r and (r.Body or r.body), r and (r.StatusCode or r.status_code)
            end
        end,

        function(u)
            return game:HttpGet(u), 200
        end,
    }

    local lastErr = "no_http_method_or_empty_body"

    for _, f in ipairs(funcs) do
        if CANCELLED then
            return false, "cancelled"
        end

        local ok, body, status = pcall(function()
            return f(url)
        end)

        if ok and type(body) == "string" and #body > 0 then
            local code = tonumber(status)
            if code and code >= 400 then
                lastErr = "http_status_" .. tostring(code) .. " | " .. bodyPreview(body, 120)
                -- tetap return body biar detector HTML/502 bisa jalan
                return true, body
            end
            return true, body
        elseif ok then
            lastErr = "empty_or_nil_body status=" .. tostring(status)
        else
            lastErr = tostring(body)
        end
    end

    return false, lastErr
end

local function set_key(key)
    if not key or key == "" then
        return
    end

    local ok = pcall(function()
        local g = (getgenv and getgenv()) or _G

        g.script_key = key
        g.KEY = key
        g.ScriptKey = key

        _G.script_key = key
        _G.KEY = key
        _G.ScriptKey = key

        if shared then
            shared.script_key = key
            shared.KEY = key
            shared.ScriptKey = key
        end
    end)

    if not ok then
        LOADER.Debug("failed to set key")
    end
end

local function inject_key_into_body(body, key)
    if not key or key == "" then
        return body
    end

    local header =
        ("script_key=%q; KEY=%q; ScriptKey=%q; "):format(key, key, key)
        .. "local g=(getgenv and getgenv()) or _G; "
        .. ("pcall(function() g.script_key=%q g.KEY=%q g.ScriptKey=%q _G.script_key=%q if shared then shared.script_key=%q end end); "):format(
            key,
            key,
            key,
            key,
            key
        )

    return header .. "\n" .. body
end

local function bodyLooksLikeServerError(body)
    body = tostring(body or "")
    if body == "" or #body < 10 then
        return true
    end

    local lower = body:lower()
    local head = lower:sub(1, 512)

    -- Response panel error biasanya pendek (bukan script loader)
    if #body < 800 then
        if lower:find('warn("error link kode', 1, true)
            or lower:find("auto_module_not_found", 1, true)
            or lower:find("code_shortcut_not_found", 1, true)
            or lower:find("invalid request", 1, true)
            or lower:find("ulangi request", 1, true)
            or lower:find("secret key expired", 1, true)
            or lower:find("max user for this key", 1, true)
            or lower:find("script untuk game id", 1, true)
            or lower:find("invalid secret key", 1, true)
            or lower:find("verify expired", 1, true)
            or lower:find('print("no script")', 1, true)
            or lower:find("print('no script')", 1, true)
        then
            return true
        end
    end

    -- Halaman HTML / CDN (404, cloudflare, dll.)
    if head:find("<!doctype", 1, true)
        or head:find("<html", 1, true)
        or head:find("cloudflare", 1, true)
        or head:find("bad gateway", 1, true)
        or head:find("service unavailable", 1, true)
        or head:find("gateway timeout", 1, true)
        or head:find("error code 502", 1, true)
        or head:find("error code 520", 1, true)
        or head:find("error code 521", 1, true)
        or head:find("error code 522", 1, true)
        or head:find("error code 524", 1, true)
    then
        return true
    end

    return false
end

local function describeCompileFailure(compileErr, body)
    return table.concat({
        "compileErr=" .. tostring(compileErr or "nil"),
        "len=" .. tostring(#tostring(body or "")),
        "head=" .. bodyPreview(body, 160),
    }, " | ")
end

------------------------------------------------------------
-- PICK ROUTE
------------------------------------------------------------
local currentGameId = tostring(game.GameId)
local URL_ROUTES = GAME_ROUTE_SETS[currentGameId]

LOADER.SetProgress(0.08, "Detecting game...")
LOADER.Debug("gameId:", currentGameId)

if not URL_ROUTES then
    LOADER.Error("Game tidak didukung")
    LOADER.Debug("unsupported gameId:", currentGameId)
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = false
    reportDebug("unsupported_game_id", "gameId=" .. currentGameId)
    return {
        ok = false,
        error = "unsupported_game_id",
        gameId = currentGameId,
    }
end

LOADER.SetProgress(0.12, "Checking world...")
LOADER.SetInfo("Selecting best route...")
LOADER.Debug("start route selection")

local pickedRoute = pickRoute(URL_ROUTES)

if CANCELLED then
    return {
        ok = false,
        error = "cancelled",
    }
end

if not pickedRoute then
    LOADER.Error("No URL route found")
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = false
    reportDebug("no_url_route", "no route")
    return {
        ok = false,
        error = "no_url_route",
    }
end

local pickedName = tostring(pickedRoute.name or "script")
local pickedUrl = appendQuery(pickedRoute.url, pickedRoute.query or AUTO_QR)

LOADER.Debug("picked route:", pickedName, "placeId:", tostring(game.PlaceId))
pcall(function() NodeHubToast("info", "NODE HUB", "Grow A Garden 2 — loading", 5) end)

if hasUnreplacedShortcode(pickedUrl) then
    LOADER.Error("Shortcode not replaced")
    LOADER.Debug("shortcode not replaced for route:", pickedName)
    ENV.__NODEHUB_BOOT_LOADING = false
    ENV.__NODEHUB_BOOT_RUNNING = false
    reportDebug("shortcode_not_replaced", "route=" .. pickedName)
    return {
        ok = false,
        error = "shortcode_not_replaced",
        name = pickedName,
    }
end

local SCRIPTS = {
    {
        url = pickedUrl,
        key = pickedRoute.key,
        name = pickedName,
    },
}

------------------------------------------------------------
-- LOAD AND RUN
------------------------------------------------------------
local function load_and_run(entry)
    if entry.key then
        set_key(entry.key)
    end

    local lastErr = "unknown"
    local lastExtra = "nil"

    local function waitRetry(attempt, reason)
        if attempt >= RETRIES then
            return false
        end

        local delay = math.min(RETRY_DELAY + (attempt * 1.5), 15)

        LOADER.SetProgress(
            0.28,
            tostring(reason or "Failed")
                .. " retry "
                .. tostring(attempt)
                .. "/"
                .. tostring(RETRIES)
        )

        LOADER.SetInfo("Retrying in " .. tostring(math.floor(delay)) .. "s...")
        task.wait(delay)

        return true
    end

    local function setFail(err, extra)
        lastErr = tostring(err or "unknown")
        lastExtra = tostring(extra or "nil")
        pushDebug("fail:", lastErr, lastExtra)
        reportDebug(lastErr, lastExtra)
    end

    local function finalError()
        ENV.__NODEHUB_BOOT_LOADING = false
        ENV.__NODEHUB_BOOT_RUNNING = false

        if lastErr == "server_returned_error" then
            LOADER.Error("Server returned error")
        elseif lastErr == "http_failed" then
            LOADER.Error("HTTP failed")
        elseif lastErr == "empty_body" then
            LOADER.Error("Empty script")
        elseif lastErr == "loadstring_missing" then
            LOADER.Error("loadstring missing")
        elseif lastErr == "loadstring_crashed" then
            LOADER.Error("Compile crashed")
        elseif lastErr == "compile_failed" then
            LOADER.Error("Compile failed")
        elseif lastErr == "runtime_error" then
            LOADER.Error("Runtime error")
        else
            LOADER.Error("Load failed")
        end

        reportDebug(lastErr, "final_error | " .. tostring(lastExtra))
        return false, lastErr
    end

    for attempt = 1, RETRIES do
        if CANCELLED then
            return false, "cancelled"
        end

        LOADER.SetProgress(0.28, "Fetching " .. tostring(entry.name) .. "...")
        LOADER.SetInfo("Connecting to server...")
        LOADER.Debug("fetch attempt:", attempt, "name:", entry.name)

        local okHttp, bodyOrErr = http_get(entry.url)

        if not okHttp then
            setFail("http_failed", bodyOrErr)
            LOADER.Debug("http failed:", bodyOrErr)

            if not waitRetry(attempt, "HTTP failed") then
                break
            end

            continue
        end

        local body = normalizeBody(inject_key_into_body(bodyOrErr, entry.key))
        LOADER.Debug("body length:", #body)

        if bodyLooksLikeServerError(body) then
            setFail(
                "server_returned_error",
                "len=" .. tostring(#body) .. " | head=" .. bodyPreview(body, 160)
            )
            LOADER.Debug("server returned error body hidden")

            if not waitRetry(attempt, "Server returned error") then
                break
            end

            continue
        end

        if #body < 50 then
            setFail("empty_body", "body length = " .. tostring(#body) .. " | head=" .. bodyPreview(body, 80))
            LOADER.Debug("empty body")

            if not waitRetry(attempt, "Empty script") then
                break
            end

            continue
        end

        if type(loadstring) ~= "function" then
            setFail("loadstring_missing", "loadstring is nil")
            break
        end

        LOADER.SetProgress(0.55, "Compiling " .. tostring(entry.name) .. "...")
        LOADER.SetInfo("Preparing protected script...")
        LOADER.Debug("compile:", entry.name)

        -- FIX: tangkap 2 return value loadstring (chunk, err)
        -- pcall(function() return loadstring(body) end) sebelumnya
        -- hanya ambil return pertama → compile_failed extra jadi nil
        local chunk, compileErr
        local okLS, pcallErr = pcall(function()
            chunk, compileErr = loadstring(body)
        end)

        if not okLS then
            setFail("loadstring_crashed", tostring(pcallErr) .. " | " .. describeCompileFailure(nil, body))
            LOADER.Debug("loadstring crashed:", pcallErr)

            if not waitRetry(attempt, "Compile crashed") then
                break
            end

            continue
        end

        if type(chunk) ~= "function" then
            setFail("compile_failed", describeCompileFailure(compileErr, body))
            LOADER.Debug("compile failed:", compileErr)

            if not waitRetry(attempt, "Compile failed") then
                break
            end

            continue
        end

        if CANCELLED then
            return false, "cancelled"
        end

        LOADER.SetProgress(0.78, "Starting " .. tostring(entry.name) .. "...")
        LOADER.SetInfo("Almost done...")
        LOADER.Debug("run:", entry.name)

        local loaderFinished = false

        local function safeDone()
            if loaderFinished then
                return
            end

            loaderFinished = true
            LOADER.Done()
        end

        if NON_BLOCKING then
            local finished = false
            local runOk = false
            local runErr = nil

            task.spawn(function()
                local okRun, errRun = pcall(chunk)

                finished = true
                runOk = okRun
                runErr = errRun

                if not okRun then
                    LOADER.Debug("runtime error:", errRun)
                    return
                end

                safeDone()
            end)

            local t0 = os.clock()

            while not finished and os.clock() - t0 < TIMEOUT_SEC do
                task.wait(0.1)
            end

            if finished then
                if runOk then
                    safeDone()
                    return true, nil
                end

                setFail("runtime_error", tostring(runErr))
                LOADER.Debug("runtime error:", runErr)

                if not waitRetry(attempt, "Runtime error") then
                    break
                end

                continue
            end

            -- masih running setelah timeout → anggap boot lanjut (non-blocking)
            safeDone()
            return true, "running"
        else
            local okRun, errRun = pcall(chunk)

            if okRun then
                safeDone()
                return true, nil
            end

            setFail("runtime_error", tostring(errRun))
            LOADER.Debug("runtime error:", errRun)

            if not waitRetry(attempt, "Runtime error") then
                break
            end

            continue
        end
    end

    return finalError()
end

------------------------------------------------------------
-- RUNNER
------------------------------------------------------------
local results = {}

for i, entry in ipairs(SCRIPTS) do
    if CANCELLED then
        results[entry.name] = {
            ok = false,
            err = "cancelled",
            name = entry.name,
        }
        break
    end

    LOADER.Debug("runner:", i, "/", #SCRIPTS, entry.name)

    local ok, err = load_and_run(entry)

    -- Penting: key result pakai name, bukan URL, supaya URL tidak bocor
    results[entry.name] = {
        ok = ok,
        err = err,
        name = entry.name,
    }
end

return results
