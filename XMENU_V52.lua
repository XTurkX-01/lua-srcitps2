--!nonstrict
--[[
	=====================================================================
	  X MENU V52  |  LIFE TOGETHER — TEK DOSYA FINAL BUILD
	  by XRIPX
	=====================================================================
	  Script Turu   : LocalScript
	  Yerlesim      : StarterPlayer > StarterPlayerScripts > XMENU_V52
	  On Hazirlik   : Yok (harici RemoteEvent / ServerScript gerekmez)
	  Oyun          : Roblox Life Together (yerel / client-side arac menusu)
	----------------------------------------------------------------------
	  ONEMLI UYARI
	  Bu script tamamen YERELDIR. Sadece SENIN ekraninda gorunur ve sadece
	  SENIN client tarafinda calisir. Sunucu tarafi yetki, para, hasar veya
	  oyun ici ekonomi ile ilgilidir ve HIC dokunmaz.
	  Fling / track gibi ozellikler baska oyuncularin deneyimini bozabilir;
	  Roblox ToS'a aykiridir. Yalnizca kendi test ortaminda/yetkili oldugun
	  sistemlerde kullan. Sorumluluk kullaniciya aittir.
	----------------------------------------------------------------------
	  NOTLAR
	  - Tum API cagrilari gercek Roblox API'sidir; hayali API yoktur.
	  - Tum Event:Connect() baglantilari TaskManager / Cleanup ile izlenir.
	  - Agir donguler os.clock() ile seyreltilir; frame basina is yoktur.
	  - Riskli cagrilar (SetNetworkOwner, ApplyImpulse, SetCore, Http)
	    daima pcall icinde korunur.
	  - Cift tirnak icinde degil, tek tirnak string'ler kullanilir ki
	    kabuk (shell) aktariminda hicbir sey bozulmaz.
	=====================================================================
]]

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0: SERVİSLER (önbelleğe alınmış, tek noktadan)
-- ──────────────────────────────────────────────────────────────────────────

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local Debris             = game:GetService("Debris")
local Workspace          = game:GetService("Workspace")
local Lighting           = game:GetService("Lighting")
local SoundService       = game:GetService("SoundService")
local StarterGui         = game:GetService("StarterGui")
local HttpService        = game:GetService("HttpService")
local GuiService         = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local Stats              = game:GetService("Stats")

-- TextChatService yeni oyunlarda var, eski oyunlarda olmayabilir -> pcall
local okTextChat, TextChatService = pcall(function()
	return game:GetService("TextChatService")
end)
if not okTextChat then
	TextChatService = nil
end

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	return
end

local Services = {
	Players = Players,
	RunService = RunService,
	UserInputService = UserInputService,
	TweenService = TweenService,
	Debris = Debris,
	Workspace = Workspace,
	Lighting = Lighting,
	SoundService = SoundService,
	StarterGui = StarterGui,
	HttpService = HttpService,
	GuiService = GuiService,
	LocalizationService = LocalizationService,
	Stats = Stats,
	TextChatService = TextChatService,
}

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0.1: CONFIG (tüm sabitler tek yerde)
-- ──────────────────────────────────────────────────────────────────────────

local Config = {
	Theme = {
		Background     = Color3.fromRGB(12, 12, 18),
		Surface        = Color3.fromRGB(20, 20, 28),
		SurfaceLight   = Color3.fromRGB(30, 30, 40),
		SurfaceDark    = Color3.fromRGB(15, 15, 21),
		Accent         = Color3.fromRGB(220, 50, 50),
		AccentDark     = Color3.fromRGB(160, 30, 30),
		AccentBright   = Color3.fromRGB(255, 80, 80),
		TextPrimary    = Color3.fromRGB(240, 240, 245),
		TextSecondary  = Color3.fromRGB(160, 160, 170),
		TextMuted      = Color3.fromRGB(100, 100, 110),
		Success        = Color3.fromRGB(50, 200, 100),
		Warning        = Color3.fromRGB(255, 180, 50),
		Error          = Color3.fromRGB(255, 60, 60),
		Info           = Color3.fromRGB(80, 180, 255),
		Border         = Color3.fromRGB(60, 60, 75),
		Overlay        = Color3.fromRGB(0, 0, 0),
		Glass          = Color3.fromRGB(28, 28, 40),
	},
	Sizes = {
		WindowWidthDesktop  = 560,
		WindowHeightDesktop = 460,
		WindowWidthMobile   = 460,
		WindowHeightMobile  = 400,
		TabBarWidthDesktop  = 132,
		TabBarWidthMobile   = 112,
		TitleBarHeight      = 38,
		RowHeight           = 34,
		RowSpacing          = 5,
		Padding             = 12,
		CornerRadius        = UDim.new(0, 12),
		CornerRadiusSmall   = UDim.new(0, 8),
		MinTouchTarget      = 44,
		WidgetWidth         = 148,
		WidgetHeight        = 34,
	},
	Animation = {
		Fast   = 0.15,
		Normal = 0.25,
		Slow   = 0.4,
	},
	Notification = {
		Width      = 330,
		Height     = 68,
		Duration   = 3.5,
		MaxVisible = 3,
		Position   = "Top",
	},
	Password = {
		Value      = "1234",
		MaxAttempts = 5,
		Lockout    = 30,
	},
	Physics = {
		FlingPowerDefault    = 3500,
		FlingPowerMin        = 100,
		FlingPowerMax        = 10000,
		FlingVerticalBias    = 1.0,
		SpinSpeedMax         = 600,
		FlySpeed             = 250,
		FlySpeedMax          = 1200,
		WaypointSpeed        = 250,
		WalkFlingRange       = 10,
		MultiFlingRange      = 40,
		TrackInterval        = 0.3,
		TrackPrediction      = 0.18,
		VehicleCacheTTL      = 3600,
		AntiFlingVelocity    = 200,
		AntiFlingAngular     = 80,
		LinearVelocityLife   = 1.2,
	},
	Command = {
		ChatPrefix    = "!",
		ConsolePrefix = ";",
		MaxHistory    = 40,
		MaxMacros     = 24,
	},
	Keys = {
		Menu     = Enum.KeyCode.F1,
		Console  = Enum.KeyCode.Semicolon,
		Widgets  = Enum.KeyCode.F2,
		FlyPanel = Enum.KeyCode.F3,
		Spy      = Enum.KeyCode.F4,
		Chat     = Enum.KeyCode.F5,
		Theme    = Enum.KeyCode.F6,
	},
	Analytics = {
		GraphSamples   = 60,
		RefreshRate    = 0.5,
		TickSampleTime = 2.0,
	},
	Social = {
		SpamWindow     = 3.0,
		SpamMaxRepeat  = 3,
		WhisperMax     = 120,
		ChatLogMax     = 400,
		VoiceRange     = 60,
	},
	Accessibility = {
		JoystickDeadzone = 0.25,
		TTSVoice         = "1",
		TTSVolume        = 0.8,
		TTSMaxChars      = 280,
		HapticType       = "UIClick",
		SwipeMinDistance  = 90,
		AutoHideDelay    = 45,
	},
	Voice = {
		Volume = 0.35,
		Pitch  = 1,
	},
	Menu = {
		Scale         = 1,
		Tab           = "Home",
		Minimalist    = false,
		OneHand       = false,
		AutoHide      = false,
		SoundEnabled  = true,
		SoundPack     = "Default",
		Collapsed     = {},
		WatermarkText = "X MENU V52",
		WatermarkPos  = "TopRight",
		WatermarkSize = 13,
		IconSet       = "Emoji",
		QuickBar      = true,
	},
	Layout = {
		-- Menü düzen kaydı: pencere konumu/ölçüsü/sekme
		WindowX = 0.5,
		WindowY = 0.5,
		Width   = 560,
		Height  = 460,
	},
}

-- Tema değişkenleri (dinamik renk seçici bunları günceller)
local Theme = {
	Accent      = Config.Theme.Accent,
	AccentDark  = Config.Theme.AccentDark,
	AccentBright = Config.Theme.AccentBright,
	Background  = Config.Theme.Background,
	Surface     = Config.Theme.Surface,
	TextPrimary = Config.Theme.TextPrimary,
	HighContrast = false,
	ColorBlind   = false,
	Palette      = "Default",
}

-- On ileri bildirimler (forward declarations)
-- Asagidaki moduller birbirlerine referans veriyor; isimleri dosyanin basinda
-- baglayarak "global" yanlis kullanimini onluyoruz.
local MainApp = nil
local AppInstance = nil
local ExampleFeature = nil
local Analytics = nil

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0.2: STATE (merkezi durum yönetimi)
-- ──────────────────────────────────────────────────────────────────────────

local State = {}
State.__index = State

function State.new()
	local self = setmetatable({}, State)
	self._data = {}
	self._listeners = {}
	return self
end

function State:Set(key, value)
	local oldValue = self._data[key]
	if oldValue == value then
		return
	end
	self._data[key] = value
	local list = self._listeners[key]
	if list then
		for i = #list, 1, -1 do
			local callback = list[i]
			if callback then
				local ok, err = pcall(callback, value, oldValue)
				if not ok then
					warn("[X52] State listener error for '" .. tostring(key) .. "': " .. tostring(err))
				end
			end
		end
	end
end

function State:Get(key)
	return self._data[key]
end

function State:OnChange(key, callback)
	if not self._listeners[key] then
		self._listeners[key] = {}
	end
	table.insert(self._listeners[key], callback)
	return {
		Disconnect = function()
			local list = self._listeners[key]
			if not list then
				return
			end
			for i = #list, 1, -1 do
				if list[i] == callback then
					table.remove(list, i)
					break
				end
			end
		end,
	}
end

function State:Keys()
	local out = {}
	for key in pairs(self._data) do
		table.insert(out, key)
	end
	table.sort(out)
	return out
end

function State:Clear()
	self._data = {}
	self._listeners = {}
end

local _stateInstance = State.new()
_stateInstance:Set("MenuOpen", false)
_stateInstance:Set("IsUnlocked", false)
_stateInstance:Set("CurrentTab", "Home")
_stateInstance:Set("SearchQuery", "")
_stateInstance:Set("Minimized", false)
_stateInstance:Set("TargetPlayer", nil)
_stateInstance:Set("FrameCount", 0)
_stateInstance:Set("ActiveFeatures", {})

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0.3: CLEANUP / JANITOR (bağlantı, tween, instance temizliği)
-- ──────────────────────────────────────────────────────────────────────────

local Cleanup = {}
Cleanup.__index = Cleanup

function Cleanup.new()
	local self = setmetatable({}, Cleanup)
	self._items = {}
	self._tweens = {}
	self._delays = {}
	self._destroyed = false
	return self
end

function Cleanup:Add(item)
	if not item then
		return item
	end
	table.insert(self._items, item)
	return item
end

function Cleanup:Connect(signal, callback)
	if not signal or not callback then
		return nil
	end
	local connection = signal:Connect(callback)
	table.insert(self._items, connection)
	return connection
end

function Cleanup:Tween(tween)
	if not tween then
		return tween
	end
	table.insert(self._tweens, tween)
	return tween
end

function Cleanup:Delay(seconds, callback)
	local connection
	local frame = Instance.new("Frame")
	connection = frame:GetPropertyChangedSignal("Parent"):Connect(function() end)
	task.delay(seconds, function()
		if connection then
			pcall(function() connection:Disconnect() end)
		end
		pcall(function() frame:Destroy() end)
		if callback then
			local ok, err = pcall(callback)
			if not ok then
				warn("[X52] Cleanup delay error: " .. tostring(err))
			end
		end
	end)
	table.insert(self._delays, { connection = connection, frame = frame })
	return connection
end

function Cleanup:AddChild(child)
	if not child then
		return child
	end
	table.insert(self._items, child)
	return child
end

function Cleanup:IsDestroyed()
	return self._destroyed
end

function Cleanup:Destroy()
	if self._destroyed then
		return
	end
	self._destroyed = true
	for _, tween in ipairs(self._tweens) do
		pcall(function() tween:Cancel() end)
	end
	self._tweens = {}
	for _, delay in ipairs(self._delays) do
		pcall(function() delay.connection:Disconnect() end)
		pcall(function() delay.frame:Destroy() end)
	end
	self._delays = {}
	for i = #self._items, 1, -1 do
		local item = self._items[i]
		if typeof(item) == "RBXScriptConnection" then
			pcall(function() item:Disconnect() end)
		elseif typeof(item) == "Instance" then
			pcall(function() item:Destroy() end)
		elseif type(item) == "table" and item.Destroy then
			pcall(function() item:Destroy() end)
		end
	end
	self._items = {}
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0.4: TASK MANAGER (global bağlantı + thread + throttled tick)
-- ──────────────────────────────────────────────────────────────────────────

local TaskManager = {
	_connections = {},
	_threads = {},
	_ticks = {},
	_active = true,
}

function TaskManager:Connect(signal, callback)
	if not self._active or not signal or not callback then
		return nil
	end
	local connection = signal:Connect(callback)
	table.insert(self._connections, connection)
	return connection
end

function TaskManager:Spawn(callback, ...)
	if not self._active or not callback then
		return nil
	end
	local thread = task.spawn(callback, ...)
	table.insert(self._threads, thread)
	return thread
end

-- os.clock tabanlı seyreltilmiş çağrı: her frame değil, belirli aralıkta
function TaskManager:Every(interval, callback)
	if not self._active or not callback then
		return nil
	end
	local entry = { interval = interval, callback = callback, last = 0 }
	table.insert(self._ticks, entry)
	return entry
end

function TaskManager:RemoveTick(entry)
	for i, tick in ipairs(self._ticks) do
		if tick == entry then
			table.remove(self._ticks, i)
			return
		end
	end
end

function TaskManager:RunTicks(now)
	for i = #self._ticks, 1, -1 do
		local tick = self._ticks[i]
		if now - tick.last >= tick.interval then
			tick.last = now
			local ok, err = pcall(tick.callback)
			if not ok then
				warn("[X52] Tick error: " .. tostring(err))
			end
		end
	end
end

-- UI bilesenlerinin janitor'larini da kaydet (script kapaninca baglantilari
-- otomatik temizlensin, memory leak olusmasin)
function TaskManager:AddJanitor(janitor)
	if not janitor or not self._active then
		return janitor
	end
	self._janitors = self._janitors or {}
	table.insert(self._janitors, janitor)
	return janitor
end

function TaskManager:Delay(seconds, callback)
	if not self._active or not callback then
		return nil
	end
	return task.delay(seconds, function()
		if self._active then
			local ok, err = pcall(callback)
			if not ok then
				warn("[X52] Task delay error: " .. tostring(err))
			end
		end
	end)
end

function TaskManager:Cleanup()
	self._active = false
	if self._janitors then
		for _, janitor in ipairs(self._janitors) do
			pcall(function() janitor:Destroy() end)
		end
		self._janitors = {}
	end
	for _, connection in ipairs(self._connections) do
		pcall(function() connection:Disconnect() end)
	end
	self._connections = {}
	for _, thread in ipairs(self._threads) do
		pcall(function() task.cancel(thread) end)
	end
	self._threads = {}
	self._ticks = {}
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 0.5: UTILITIES
-- ──────────────────────────────────────────────────────────────────────────

local Utilities = {}

function Utilities.Clamp(value, min, max)
	if value ~= value then
		return min
	end
	return math.max(min, math.min(max, value))
end

function Utilities.Round(value, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.floor(value * mult + 0.5) / mult
end

function Utilities.Round_UI(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 8)
	corner.Parent = instance
	return corner
end

function Utilities.Stroke(instance, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Config.Theme.Border
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = instance
	return stroke
end

function Utilities.Padding(instance, pixels)
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, pixels)
	padding.PaddingRight = UDim.new(0, pixels)
	padding.PaddingTop = UDim.new(0, pixels)
	padding.PaddingBottom = UDim.new(0, pixels)
	padding.Parent = instance
	return padding
end

function Utilities.SafeCall(fn, ...)
	if type(fn) ~= "function" then
		return false, "not a function"
	end
	local ok, result = pcall(fn, ...)
	if not ok then
		warn("[X52] SafeCall error: " .. tostring(result))
	end
	return ok, result
end

function Utilities.Debounce(seconds)
	local lastTime = 0
	return function()
		local now = os.clock()
		if now - lastTime < seconds then
			return false
		end
		lastTime = now
		return true
	end
end

function Utilities.IsSmallScreen()
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	return camera.ViewportSize.X < 820
end

function Utilities.GetViewportSize()
	local camera = Workspace.CurrentCamera
	if not camera then
		return Vector2.new(1920, 1080)
	end
	return camera.ViewportSize
end

function Utilities.ScrollIntoView(scrollingFrame, target)
	if not scrollingFrame or not target then
		return
	end
	local absPos = target.AbsolutePosition
	local absSize = target.AbsoluteSize
	local scrollPos = scrollingFrame.AbsolutePosition
	local scrollSize = scrollingFrame.AbsoluteSize
	local targetBottom = absPos.Y + absSize.Y
	local scrollBottom = scrollPos.Y + scrollSize.Y
	if targetBottom > scrollBottom then
		scrollingFrame.CanvasPosition = Vector2.new(
			scrollingFrame.CanvasPosition.X,
			scrollingFrame.CanvasPosition.Y + (targetBottom - scrollBottom)
		)
	elseif absPos.Y < scrollPos.Y then
		scrollingFrame.CanvasPosition = Vector2.new(
			scrollingFrame.CanvasPosition.X,
			scrollingFrame.CanvasPosition.Y - (scrollPos.Y - absPos.Y)
		)
	end
end

function Utilities.GetMainPart(vehicle)
	if not vehicle then
		return nil
	end
	if vehicle:IsA("BasePart") then
		return vehicle
	end
	local seat = vehicle:FindFirstChild("VehicleSeat") or vehicle:FindFirstChild("Seat")
	if seat and seat:IsA("BasePart") then
		return seat
	end
	if vehicle.PrimaryPart then
		return vehicle.PrimaryPart
	end
	for _, child in ipairs(vehicle:GetChildren()) do
		if child:IsA("BasePart") then
			return child
		end
	end
	return nil
end

function Utilities.GetRootPart(character)
	if not character then
		return nil
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end
	return nil
end

function Utilities.GetCharacter(player)
	if not player or not player.Parent then
		return nil
	end
	return player.Character
end

function Utilities.GetHumanoid(character)
	if not character then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	return humanoid
end

function Utilities.IsAlive(instance)
	return instance ~= nil and instance.Parent ~= nil
end

function Utilities.GetDistance(pos1, pos2)
	if not pos1 or not pos2 then
		return math.huge
	end
	return (pos1 - pos2).Magnitude
end

function Utilities.GetDirection(from, to)
	if not from or not to then
		return Vector3.zero
	end
	local diff = to - from
	if diff.Magnitude < 0.001 then
		return Vector3.zero
	end
	return diff.Unit
end

function Utilities.FormatNumber(value)
	if type(value) ~= "number" then
		return "?"
	end
	if value >= 1000000 then
		return string.format("%.1fM", value / 1000000)
	elseif value >= 1000 then
		return string.format("%.1fK", value / 1000)
	end
	return string.format("%d", math.floor(value + 0.5))
end

function Utilities.FormatTime(seconds)
	if type(seconds) ~= "number" or seconds < 0 then
		return "00:00"
	end
	local total = math.floor(seconds)
	local hours = math.floor(total / 3600)
	local minutes = math.floor((total % 3600) / 60)
	local secs = total % 60
	if hours > 0 then
		return string.format("%02d:%02d:%02d", hours, minutes, secs)
	end
	return string.format("%02d:%02d", minutes, secs)
end

function Utilities.FormatClock(timestamp)
	local t = math.floor(timestamp or os.time())
	return os.date("%H:%M:%S", t)
end

function Utilities.GetDateClock(timestamp)
	local t = math.floor(timestamp or os.time())
	return os.date("%d.%m.%Y %H:%M", t)
end

function Utilities.Trim(text)
	if type(text) ~= "string" then
		return ""
	end
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function Utilities.Split(text, separator)
	local out = {}
	if type(text) ~= "string" then
		return out
	end
	for part in string.gmatch(text, "([^" .. separator .. "]+)") do
		table.insert(out, part)
	end
	return out
end

function Utilities.CopyTable(source)
	local result = {}
	if type(source) ~= "table" then
		return result
	end
	for key, value in pairs(source) do
		if type(value) == "table" then
			result[key] = Utilities.CopyTable(value)
		else
			result[key] = value
		end
	end
	return result
end

function Utilities.IsOnScreen(worldPosition)
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	local screenPoint, onScreen = camera:WorldToViewportPoint(worldPosition)
	if not onScreen then
		return false
	end
	local viewport = camera.ViewportSize
	return screenPoint.X >= 0 and screenPoint.Y >= 0
		and screenPoint.X <= viewport.X and screenPoint.Y <= viewport.Y
end

function Utilities.HasLineOfSight(fromPart, toPart)
	if not fromPart or not toPart or not fromPart.Parent or not toPart.Parent then
		return false
	end
	local direction = toPart.Position - fromPart.Position
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { fromPart:FindFirstAncestorWhichIsA("Model") }
	local result = Workspace:Raycast(fromPart.Position, direction, params)
	if not result then
		return true
	end
	return result.Instance == toPart or result.Instance:IsDescendantOf(toPart)
end

function Utilities.GetPlayerHead(player)
	local character = Utilities.GetCharacter(player)
	if not character then
		return nil
	end
	local head = character:FindFirstChild("Head")
	if head and head:IsA("BasePart") then
		return head
	end
	return Utilities.GetRootPart(character)
end

function Utilities.GetPlayerFromCharacter(character)
	if not character then
		return nil
	end
	return Players:GetPlayerFromCharacter(character)
end

function Utilities.GetPing(player)
	if not player then
		return 0
	end
	local ok, ping = pcall(function()
		return player:GetNetworkPing()
	end)
	if ok and type(ping) == "number" then
		return math.floor(ping)
	end
	return 0
end

function Utilities.FindPlayer(partial)
	if not partial or partial == "" then
		return nil
	end
	local lower = string.lower(partial)
	local best = nil
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local nameLower = string.lower(player.Name)
			local displayLower = string.lower(player.DisplayName)
			if nameLower == lower or displayLower == lower then
				return player
			end
			if string.find(nameLower, lower, 1, true) or string.find(displayLower, lower, 1, true) then
				best = best or player
			end
		end
	end
	return best
end

function Utilities.PlaySound(soundId, volume, pitch)
	if not Config.Menu.SoundEnabled then
		return
	end
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = volume or 0.3
	sound.PlaybackSpeed = pitch or 1
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = 8
	sound.RollOffMaxDistance = 64
	sound.Parent = SoundService
	sound:Play()
	Debris:AddItem(sound, 1.5)
end

function Utilities.GetSoundPack(id)
	local packs = {
		Default = {
			Click = "rbxasset://sounds/clickfast.wav",
			Hover = "rbxasset://sounds/electronicpingshort.wav",
			Open  = "rbxasset://sounds/impact_water.mp3",
			Error = "rbxasset://sounds/uuhhh.mp3",
		},
		Soft = {
			Click = "rbxasset://sounds/switch.wav",
			Hover = "rbxasset://sounds/switch.wav",
			Open  = "rbxasset://sounds/electronicpingshort.wav",
			Error = "rbxasset://sounds/uuhhh.mp3",
		},
		Retro = {
			Click = "rbxasset://sounds/electronicpingshort.wav",
			Hover = "rbxasset://sounds/switch.wav",
			Open  = "rbxasset://sounds/clickfast.wav",
			Error = "rbxasset://sounds/uuhhh.mp3",
		},
	}
	return packs[id] or packs.Default
end

function Utilities.PlayUI(kind)
	local pack = Utilities.GetSoundPack(Config.Menu.SoundPack)
	local soundId = pack[kind]
	if soundId then
		Utilities.PlaySound(soundId, 0.25)
	end
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 1: UI BİLEŞENLERİ (Button, Toggle, Slider, Section, Dropdown, ...)
-- ──────────────────────────────────────────────────────────────────────────

local Tooltips = {}

function Tooltips.Attach(guiObject, text)
	if not guiObject or not text or text == "" then
		return nil
	end
	local holder = Instance.new("Frame")
	holder.Name = "X52Tooltip"
	holder.Size = UDim2.new(0, 0, 0, 0)
	holder.BackgroundTransparency = 1
	holder.Visible = false
	holder.ZIndex = 60
	holder.Parent = guiObject

	local shadow = Instance.new("TextLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Size = UDim2.new(0, 0, 0, 22)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.25
	shadow.Text = ""
	shadow.TextSize = 11
	shadow.Font = Enum.Font.Gotham
	shadow.TextColor3 = Config.Theme.TextPrimary
	shadow.TextXAlignment = Enum.TextXAlignment.Left
	shadow.TextYAlignment = Enum.TextYAlignment.Center
	shadow.Parent = holder
	Utilities.Round_UI(shadow, UDim.new(0, 6))
	Utilities.Padding(shadow, 8)

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Size = UDim2.new(0, 0, 0, 22)
	label.BackgroundTransparency = 1
	label.Text = tostring(text)
	label.TextSize = 11
	label.Font = Enum.Font.GothamMedium
	label.TextColor3 = Config.Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.ZIndex = 61
	label.Parent = holder

	local stroke = Instance.new("UIStroke")
	stroke.Color = Config.Theme.Accent
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	stroke.Parent = shadow

	local function show()
		label.Size = UDim2.fromOffset(shadow.TextSize + 16, 22)
		shadow.Size = UDim2.fromOffset(shadow.TextSize + 16, 22)
		holder.Visible = true
		local guiPos = guiObject.AbsolutePosition
		local guiSize = guiObject.AbsoluteSize
		holder.Position = UDim2.fromOffset(
			guiPos.X + guiSize.X / 2 - shadow.Size.X.Offset / 2,
			guiPos.Y - 26
		)
	end

	local function hide()
		holder.Visible = false
	end

	guiObject.MouseEnter:Connect(show)
	guiObject.MouseLeave:Connect(hide)
	guiObject.MouseButton1Click:Connect(function()
		task.delay(2.2, hide)
	end)

	return {
		Show = show,
		Hide = hide,
		Destroy = function()
			holder:Destroy()
		end,
	}
end

local Button = {}
Button.__index = Button

function Button.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)

	local button = Instance.new("TextButton")
	button.Name = "Button_" .. tostring(props.Text or "Untitled")
	button.Size = props.Size or UDim2.new(1, 0, 0, Config.Sizes.RowHeight)
	button.BackgroundColor3 = props.Color or Config.Theme.Accent
	button.TextColor3 = Config.Theme.TextPrimary
	button.Text = props.Text or ""
	button.Font = Enum.Font.GothamBold
	button.TextSize = props.TextSize or 13
	button.AutoButtonColor = false
	button.LayoutOrder = props.LayoutOrder or 0
	button.TextWrapped = props.TextWrapped or false
	button.TextTruncate = Enum.TextTruncate.AtEnd
	button.Parent = parent
	Utilities.Round_UI(button, Config.Sizes.CornerRadiusSmall)
	janitor:Add(button)

	if props.Tooltip then
		Tooltips.Attach(button, props.Tooltip)
	end

	local disabled = props.Disabled or false
	local holdMode = props.Hold or false

	local function render()
		if disabled then
			button.BackgroundColor3 = Config.Theme.SurfaceLight
			button.TextColor3 = Config.Theme.TextMuted
		else
			button.BackgroundColor3 = props.Color or Config.Theme.Accent
			button.TextColor3 = Config.Theme.TextPrimary
		end
	end
	render()

	local debounced = Utilities.Debounce(0.18)
	local holding = false

	local function trigger()
		if disabled then
			return
		end
		Utilities.PlayUI("Click")
		if props.OnClick then
			Utilities.SafeCall(props.OnClick)
		end
	end

	janitor:Connect(button.MouseButton1Down, function()
		if disabled then
			return
		end
		if holdMode then
			holding = true
			local interval = props.HoldInterval or 0.12
			janitor:Delay(interval, function()
				while holding and not janitor:IsDestroyed() do
					if props.OnHold then
						Utilities.SafeCall(props.OnHold)
					end
					task.wait(interval)
				end
			end)
		end
	end)

	janitor:Connect(button.MouseButton1Up, function()
		holding = false
	end)

	janitor:Connect(button.MouseButton1Click, function()
		if disabled then
			return
		end
		if not debounced() then
			return
		end
		if holdMode then
			return
		end
		trigger()
	end)

	local api = {}
	api.Instance = button
	api.Janitor = janitor

	function api.SetDisabled(state)
		disabled = state
		render()
	end

	function api.SetText(text)
		button.Text = text
	end

	function api.SetColor(color)
		props.Color = color
		render()
	end

	function api.IsDisabled()
		return disabled
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local value = props.Default or false

	local row = Instance.new("TextButton")
	row.Name = "Toggle_" .. tostring(props.Text or "Untitled")
	row.Size = UDim2.new(1, 0, 0, Config.Sizes.RowHeight)
	row.BackgroundColor3 = Config.Theme.Surface
	row.AutoButtonColor = false
	row.Text = ""
	row.LayoutOrder = props.LayoutOrder or 0
	row.Parent = parent
	Utilities.Round_UI(row, Config.Sizes.CornerRadiusSmall)
	janitor:Add(row)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Text = tostring(props.Text or "")
	label.TextColor3 = Config.Theme.TextPrimary
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = row

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 44, 0, 24)
	track.Position = UDim2.new(1, -56, 0.5, -12)
	track.BackgroundColor3 = Config.Theme.SurfaceLight
	track.Parent = row
	Utilities.Round_UI(track, UDim.new(1, 0))
	janitor:Add(track)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 3, 0.5, -9)
	knob.BackgroundColor3 = Config.Theme.TextPrimary
	knob.Parent = track
	Utilities.Round_UI(knob, UDim.new(1, 0))

	if props.Tooltip then
		Tooltips.Attach(row, props.Tooltip)
	end

	local function render(animated)
		local trackColor = value and Theme.Accent or Config.Theme.SurfaceLight
		local knobPos = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		if animated then
			local tween = TweenService:Create(track, TweenInfo.new(Config.Animation.Fast), {
				BackgroundColor3 = trackColor,
			})
			janitor:Tween(tween)
			tween:Play()
			local knobTween = TweenService:Create(knob, TweenInfo.new(Config.Animation.Fast, Enum.EasingStyle.Quad), {
				Position = knobPos,
			})
			janitor:Tween(knobTween)
			knobTween:Play()
		else
			track.BackgroundColor3 = trackColor
			knob.Position = knobPos
		end
	end
	render(false)

	local debounced = Utilities.Debounce(0.12)
	janitor:Connect(row.MouseButton1Click, function()
		if debounced() then
			value = not value
			render(true)
			Utilities.PlayUI("Click")
			if props.OnChanged then
				Utilities.SafeCall(props.OnChanged, value)
			end
		end
	end)

	local api = {}
	api.Instance = row
	api.Janitor = janitor
	api._value = value

	function api.Get()
		return value
	end

	function api.Set(newValue, silent)
		value = newValue
		render(true)
		if not silent and props.OnChanged then
			Utilities.SafeCall(props.OnChanged, value)
		end
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local minValue = props.Min or 0
	local maxValue = props.Max or 100
	local step = props.Step or 1
	local value = Utilities.Clamp(props.Default or minValue, minValue, maxValue)
	local suffix = props.Suffix or ""

	local container = Instance.new("Frame")
	container.Name = "Slider_" .. tostring(props.Text or "Untitled")
	container.Size = UDim2.new(1, 0, 0, Config.Sizes.RowHeight + 16)
	container.BackgroundColor3 = Config.Theme.Surface
	container.LayoutOrder = props.LayoutOrder or 0
	container.Parent = parent
	Utilities.Round_UI(container, Config.Sizes.CornerRadiusSmall)
	janitor:Add(container)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -20, 0, 18)
	label.Position = UDim2.new(0, 10, 0, 4)
	label.Text = tostring(props.Text or "")
	label.TextColor3 = Config.Theme.TextPrimary
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = container

	local valueLabel = label:Clone()
	valueLabel.Text = tostring(value) .. suffix
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.TextColor3 = Theme.AccentBright
	valueLabel.Parent = container

	local hitbox = Instance.new("TextButton")
	hitbox.Text = ""
	hitbox.AutoButtonColor = false
	hitbox.BackgroundTransparency = 1
	hitbox.Size = UDim2.new(1, -20, 0, Config.Sizes.MinTouchTarget)
	hitbox.Position = UDim2.new(0, 10, 0, 24)
	hitbox.Parent = container

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0.5, -3)
	track.BackgroundColor3 = Config.Theme.SurfaceLight
	track.Parent = hitbox
	Utilities.Round_UI(track, UDim.new(1, 0))
	janitor:Add(track)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.Accent
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.Parent = track
	Utilities.Round_UI(fill, UDim.new(1, 0))

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = Config.Theme.TextPrimary
	knob.Parent = track
	Utilities.Round_UI(knob, UDim.new(1, 0))

	if props.Tooltip then
		Tooltips.Attach(container, props.Tooltip)
	end

	local function alphaFromValue(v)
		if maxValue == minValue then
			return 0
		end
		return (v - minValue) / (maxValue - minValue)
	end

	local function render()
		local alpha = alphaFromValue(value)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = tostring(Utilities.Round(value, 2)) .. suffix
	end
	render()

	local function setFromScreenX(x)
		local relative = (x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
		relative = Utilities.Clamp(relative, 0, 1)
		local raw = minValue + relative * (maxValue - minValue)
		local stepped = Utilities.Round(raw / step) * step
		local newValue = Utilities.Clamp(stepped, minValue, maxValue)
		if newValue ~= value then
			value = newValue
			render()
			if props.OnChanged then
				Utilities.SafeCall(props.OnChanged, value)
			end
		end
	end

	local dragging = false
	janitor:Connect(hitbox.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromScreenX(input.Position.X)
		end
	end)

	janitor:Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			setFromScreenX(input.Position.X)
		end
	end)

	janitor:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local api = {}
	api.Instance = container
	api.Janitor = janitor

	function api.Get()
		return value
	end

	function api.Set(newValue, silent)
		value = Utilities.Clamp(newValue, minValue, maxValue)
		render()
		if not silent and props.OnChanged then
			Utilities.SafeCall(props.OnChanged, value)
		end
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local Section = {}
Section.__index = Section

function Section.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)

	local container = Instance.new("Frame")
	container.Name = "Section_" .. tostring(props.Title or "Untitled")
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.LayoutOrder = props.LayoutOrder or 0
	container.Parent = parent
	janitor:Add(container)

	local outerLayout = Instance.new("UIListLayout")
	outerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	outerLayout.Padding = UDim.new(0, 6)
	outerLayout.Parent = container

	local title = nil
	if props.Title then
		title = Instance.new("TextButton")
		title.BackgroundTransparency = 1
		title.Size = UDim2.new(1, 0, 0, 20)
		title.Text = string.upper(tostring(props.Title))
		title.TextColor3 = Config.Theme.TextMuted
		title.Font = Enum.Font.GothamBold
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.AutoButtonColor = false
		title.LayoutOrder = 0
		title.Parent = container
		janitor:Add(title)
	end

	local content = Instance.new("Frame")
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Size = UDim2.new(1, 0, 0, 0)
	content.BackgroundTransparency = 1
	content.LayoutOrder = 1
	content.Parent = container

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, Config.Sizes.RowSpacing)
	contentLayout.Parent = content

	local collapsed = false

	local function applyCollapsed()
		content.Visible = not collapsed
		if title then
			title.Text = string.upper(tostring(props.Title)) .. (collapsed and "  ▸" or "  ▾")
		end
	end

	if title and props.Collapsible ~= false then
		janitor:Connect(title.MouseButton1Click, function()
			collapsed = not collapsed
			applyCollapsed()
			Utilities.PlayUI("Click")
		end)
	end
	applyCollapsed()

	local api = {}
	api.Instance = container
	api.Content = content
	api.Janitor = janitor

	function api.SetCollapsed(state)
		collapsed = state
		applyCollapsed()
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local options = props.Options or {}
	local selected = props.Default or options[1]
	local open = false

	local container = Instance.new("Frame")
	container.Name = "Dropdown_" .. tostring(props.Text or "Untitled")
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundColor3 = Config.Theme.Surface
	container.LayoutOrder = props.LayoutOrder or 0
	container.ClipsDescendants = true
	container.Parent = parent
	Utilities.Round_UI(container, Config.Sizes.CornerRadiusSmall)
	janitor:Add(container)

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = container

	local header = Instance.new("TextButton")
	header.Size = UDim2.new(1, 0, 0, Config.Sizes.RowHeight)
	header.BackgroundTransparency = 1
	header.AutoButtonColor = false
	header.Text = ""
	header.LayoutOrder = 1
	header.Parent = container

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.45, -12, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Text = tostring(props.Text or "")
	label.TextColor3 = Config.Theme.TextPrimary
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = header

	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.Size = UDim2.new(0.45, -30, 1, 0)
	selectedLabel.Position = UDim2.new(0.55, 0, 0, 0)
	selectedLabel.Text = tostring(selected or "")
	selectedLabel.TextColor3 = Theme.AccentBright
	selectedLabel.Font = Enum.Font.GothamBold
	selectedLabel.TextSize = 13
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
	selectedLabel.Parent = header

	local arrow = Instance.new("TextLabel")
	arrow.BackgroundTransparency = 1
	arrow.Size = UDim2.new(0, 20, 1, 0)
	arrow.Position = UDim2.new(1, -22, 0, 0)
	arrow.Text = "▾"
	arrow.TextSize = 14
	arrow.TextColor3 = Config.Theme.TextSecondary
	arrow.Font = Enum.Font.GothamBold
	arrow.Parent = header

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 0, #options * Config.Sizes.MinTouchTarget)
	list.BackgroundTransparency = 1
	list.LayoutOrder = 2
	list.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = list

	local optionButtons = {}

	local function refreshHighlight()
		for _, entry in ipairs(optionButtons) do
			entry.button.TextColor3 = (entry.option == selected)
				and Theme.AccentBright
				or Config.Theme.TextSecondary
		end
	end

	local function setOpen(state)
		open = state
		arrow.Text = open and "▴" or "▾"
		local tween = TweenService:Create(container, TweenInfo.new(Config.Animation.Normal), {
			Size = UDim2.new(1, 0, 0, open and (Config.Sizes.RowHeight + #options * Config.Sizes.MinTouchTarget) or 0),
		})
		janitor:Tween(tween)
		tween:Play()
	end

	for i, option in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, Config.Sizes.MinTouchTarget)
		optBtn.BackgroundTransparency = 1
		optBtn.AutoButtonColor = false
		optBtn.Text = tostring(option)
		optBtn.Font = Enum.Font.Gotham
		optBtn.TextSize = 13
		optBtn.TextColor3 = Config.Theme.TextSecondary
		optBtn.TextXAlignment = Enum.TextXAlignment.Left
		optBtn.LayoutOrder = i
		optBtn.Parent = list
		janitor:Add(optBtn)

		janitor:Connect(optBtn.MouseButton1Click, function()
			selected = option
			selectedLabel.Text = tostring(option)
			refreshHighlight()
			setOpen(false)
			Utilities.PlayUI("Click")
			if props.OnChanged then
				Utilities.SafeCall(props.OnChanged, option)
			end
		end)

		table.insert(optionButtons, { option = option, button = optBtn })
	end

	refreshHighlight()

	janitor:Connect(header.MouseButton1Click, function()
		setOpen(not open)
		Utilities.PlayUI("Click")
	end)

	local api = {}
	api.Instance = container
	api.Janitor = janitor

	function api.Get()
		return selected
	end

	function api.Set(option, silent)
		selected = option
		selectedLabel.Text = tostring(option)
		refreshHighlight()
		if not silent and props.OnChanged then
			Utilities.SafeCall(props.OnChanged, option)
		end
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)

	local box = Instance.new("TextBox")
	box.Name = "TextBox_" .. tostring(props.Placeholder or "Untitled")
	box.Size = props.Size or UDim2.new(1, 0, 0, Config.Sizes.RowHeight)
	box.BackgroundColor3 = Config.Theme.Surface
	box.TextColor3 = Config.Theme.TextPrimary
	box.PlaceholderText = tostring(props.Placeholder or "")
	box.PlaceholderColor3 = Config.Theme.TextMuted
	box.Text = tostring(props.Default or "")
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.ClearTextOnFocus = props.ClearOnFocus or false
	box.LayoutOrder = props.LayoutOrder or 0
	box.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	box.Parent = parent
	Utilities.Round_UI(box, Config.Sizes.CornerRadiusSmall)
	Utilities.Padding(box, 10)
	Utilities.Stroke(box, Config.Theme.SurfaceLight, 1)
	janitor:Add(box)

	if props.Tooltip then
		Tooltips.Attach(box, props.Tooltip)
	end

	if props.OnChanged then
		janitor:Connect(box:GetPropertyChangedSignal("Text"), function()
			Utilities.SafeCall(props.OnChanged, box.Text)
		end)
	end

	janitor:Connect(box.FocusLost, function(enterPressed)
		if enterPressed and props.OnSubmit then
			Utilities.SafeCall(props.OnSubmit, box.Text)
		end
	end)

	local api = {}
	api.Instance = box
	api.Janitor = janitor

	function api.Get()
		return box.Text
	end

	function api.Set(text)
		box.Text = text
	end

	function api.Focus()
		box:CaptureFocus()
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local SearchBar = {}
SearchBar.__index = SearchBar

function SearchBar.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)

	local box = Instance.new("TextBox")
	box.Name = "SearchBar"
	box.Size = UDim2.new(1, 0, 0, Config.Sizes.RowHeight)
	box.BackgroundColor3 = Config.Theme.Surface
	box.TextColor3 = Config.Theme.TextPrimary
	box.PlaceholderText = props.Placeholder or "Ara..."
	box.PlaceholderColor3 = Config.Theme.TextMuted
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.ClearTextOnFocus = false
	box.LayoutOrder = props.LayoutOrder or 0
	box.Parent = parent
	Utilities.Round_UI(box, Config.Sizes.CornerRadiusSmall)
	Utilities.Padding(box, 12)
	janitor:Add(box)

	local icon = Instance.new("TextLabel")
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(0, 20, 1, 0)
	icon.Position = UDim2.new(1, -26, 0, 0)
	icon.Text = "🔍"
	icon.TextSize = 12
	icon.Font = Enum.Font.Gotham
	icon.Parent = box

	janitor:Connect(box:GetPropertyChangedSignal("Text"), function()
		_stateInstance:Set("SearchQuery", box.Text)
		if props.OnChanged then
			Utilities.SafeCall(props.OnChanged, box.Text)
		end
	end)

	local api = {}
	api.Instance = box
	api.Janitor = janitor

	function api.Get()
		return box.Text
	end

	function api.Clear()
		box.Text = ""
		_stateInstance:Set("SearchQuery", "")
	end

	function api.Destroy()
		janitor:Destroy()
		if _stateInstance:Get("SearchQuery") ~= "" then
			_stateInstance:Set("SearchQuery", "")
		end
	end

	return api
end

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local hue = props.Hue or 0
	local sat = props.Saturation or 0.85
	local val = props.Value or 0.75

	local container = Instance.new("Frame")
	container.Name = "ColorPicker"
	container.Size = UDim2.new(1, 0, 0, 92)
	container.BackgroundColor3 = Config.Theme.Surface
	container.LayoutOrder = props.LayoutOrder or 0
	container.Parent = parent
	Utilities.Round_UI(container, Config.Sizes.CornerRadiusSmall)
	janitor:Add(container)

	local preview = Instance.new("Frame")
	preview.Size = UDim2.new(0, 56, 1, -16)
	preview.Position = UDim2.new(0, 8, 0, 8)
	preview.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	preview.Parent = container
	Utilities.Round_UI(preview, Config.Sizes.CornerRadiusSmall)
	janitor:Add(preview)

	local hexLabel = Instance.new("TextLabel")
	hexLabel.BackgroundTransparency = 1
	hexLabel.Size = UDim2.new(0, 80, 0, 16)
	hexLabel.Position = UDim2.new(0, 70, 0, 6)
	hexLabel.Text = "#000000"
	hexLabel.TextColor3 = Config.Theme.TextSecondary
	hexLabel.Font = Enum.Font.Code
	hexLabel.TextSize = 11
	hexLabel.Parent = container

	local function currentColor()
		return Color3.fromHSV(hue, sat, val)
	end

	local function render()
		local color = currentColor()
		preview.BackgroundColor3 = color
		hexLabel.Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
		if props.OnChanged then
			Utilities.SafeCall(props.OnChanged, color)
		end
	end

	local function makeTrack(name, yPosition, initial, onChange)
		local track = Instance.new("Frame")
		track.Name = name
		track.Size = UDim2.new(1, -16, 0, 14)
		track.Position = UDim2.new(0, 8, 0, yPosition)
		track.BackgroundColor3 = Config.Theme.SurfaceLight
		track.Parent = container
		Utilities.Round_UI(track, UDim.new(1, 0))
		janitor:Add(track)

		local gradient = Instance.new("UIGradient")
		gradient.Parent = track

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(initial, 0, 0.5, 0)
		knob.BackgroundColor3 = Config.Theme.TextPrimary
		knob.Parent = track
		Utilities.Round_UI(knob, UDim.new(1, 0))

		local dragging = false
		local function setFromX(x)
			local relative = (x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
			relative = Utilities.Clamp(relative, 0, 1)
			knob.Position = UDim2.new(relative, 0, 0.5, 0)
			onChange(relative)
		end

		janitor:Connect(track.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(input.Position.X)
			end
		end)
		janitor:Connect(UserInputService.InputChanged, function(input)
			if not dragging then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then
				setFromX(input.Position.X)
			end
		end)
		janitor:Connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		return track
	end

	makeTrack("Hue", 30, hue, function(relative)
		hue = relative
		render()
	end)

	makeTrack("Sat", 50, sat, function(relative)
		sat = relative
		render()
	end)

	makeTrack("Val", 70, val, function(relative)
		val = relative
		render()
	end)

	render()

	local api = {}
	api.Instance = container
	api.Janitor = janitor

	function api.Get()
		return currentColor()
	end

	function api.Set(color)
		local h, s, v = color:Hsv()
		hue, sat, val = h, s, v
		render()
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local KeybindBox = {}
KeybindBox.__index = KeybindBox

function KeybindBox.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local binding = props.Default or Enum.KeyCode.Unknown

	local box = Instance.new("TextButton")
	box.Name = "Keybind"
	box.Size = UDim2.new(0, 120, 0, Config.Sizes.RowHeight)
	box.BackgroundColor3 = Config.Theme.Surface
	box.TextColor3 = Config.Theme.TextPrimary
	box.Text = binding == Enum.KeyCode.Unknown and "Ayarla" or binding.Name
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	box.AutoButtonColor = false
	box.LayoutOrder = props.LayoutOrder or 0
	box.Parent = parent
	Utilities.Round_UI(box, Config.Sizes.CornerRadiusSmall)
	Utilities.Stroke(box, Config.Theme.SurfaceLight, 1)
	janitor:Add(box)

	local capturing = false

	janitor:Connect(box.MouseButton1Click, function()
		capturing = true
		box.Text = "Tuşu bas..."
		box.TextColor3 = Theme.AccentBright
	end)

	janitor:Connect(UserInputService.InputBegan, function(input, processed)
		if not capturing then
			return
		end
		if processed and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		capturing = false
		binding = input.KeyCode
		box.Text = binding == Enum.KeyCode.Unknown and "Ayarla" or binding.Name
		box.TextColor3 = Config.Theme.TextPrimary
		if props.OnChanged then
			Utilities.SafeCall(props.OnChanged, binding)
		end
	end)

	local api = {}
	api.Instance = box
	api.Janitor = janitor

	function api.Get()
		return binding
	end

	function api.Set(keyCode)
		binding = keyCode
		box.Text = binding == Enum.KeyCode.Unknown and "Ayarla" or binding.Name
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar.new(parent, props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)

	local container = Instance.new("Frame")
	container.Name = "ProgressBar"
	container.Size = props.Size or UDim2.new(1, 0, 0, 8)
	container.BackgroundColor3 = Config.Theme.SurfaceLight
	container.LayoutOrder = props.LayoutOrder or 0
	container.Parent = parent
	Utilities.Round_UI(container, UDim.new(1, 0))
	janitor:Add(container)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	fill.Parent = container
	Utilities.Round_UI(fill, UDim.new(1, 0))

	local api = {}
	api.Instance = container
	api.Janitor = janitor

	function api.Set(ratio)
		fill.Size = UDim2.new(Utilities.Clamp(ratio or 0, 0, 1), 0, 1, 0)
	end

	function api.SetColor(color)
		fill.BackgroundColor3 = color
	end

	function api.Destroy()
		janitor:Destroy()
	end

	return api
end

local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

local NOTIFICATION_COLORS = {
	Info = Config.Theme.Accent,
	Success = Config.Theme.Success,
	Warning = Config.Theme.Warning,
	Error = Config.Theme.Error,
}

function NotificationSystem.new()
	local self = setmetatable({}, NotificationSystem)
	self.Janitor = Cleanup.new()
	self._activeCount = 0
	self._queue = {}
	self._cards = {}

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_Notifications"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 400
	screenGui.Parent = playerGui
	self.Janitor:Add(screenGui)

	local container = Instance.new("Frame")
	container.Name = "NotificationContainer"
	container.AnchorPoint = Vector2.new(0.5, 0)
	container.Size = UDim2.new(0, Config.Notification.Width, 1, -10)
	container.BackgroundTransparency = 1
	container.Parent = screenGui

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = container

	self._container = container
	self._screenGui = screenGui
	return self
end

function NotificationSystem:_processQueue()
	if self._activeCount >= Config.Notification.MaxVisible then
		return
	end
	local data = table.remove(self._queue, 1)
	if not data then
		return
	end
	self._activeCount = self._activeCount + 1
	self:_display(data)
end

function NotificationSystem:_display(data)
	local color = NOTIFICATION_COLORS[data.Type] or NOTIFICATION_COLORS.Info
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, Config.Notification.Height)
	card.BackgroundColor3 = Config.Theme.Surface
	card.BackgroundTransparency = 1
	card.Parent = self._container
	Utilities.Round_UI(card, Config.Sizes.CornerRadiusSmall)
	Utilities.Stroke(card, color, 1.5)

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 4, 1, -14)
	accentBar.Position = UDim2.new(0, 7, 0, 7)
	accentBar.BackgroundColor3 = color
	accentBar.BackgroundTransparency = 1
	accentBar.Parent = card
	Utilities.Round_UI(accentBar, UDim.new(1, 0))

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 20, 0, 9)
	titleLabel.Size = UDim2.new(1, -30, 0, 18)
	titleLabel.Text = tostring(data.Title or "")
	titleLabel.TextColor3 = Config.Theme.TextPrimary
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.TextTransparency = 1
	titleLabel.Parent = card

	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.Position = UDim2.new(0, 20, 0, 30)
	textLabel.Size = UDim2.new(1, -30, 0, 30)
	textLabel.Text = tostring(data.Text or "")
	textLabel.TextColor3 = Config.Theme.TextSecondary
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 11
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.TextTransparency = 1
	textLabel.Parent = card

	local cardJanitor = Cleanup.new()
	cardJanitor:Add(card)
	self.Janitor:AddChild(cardJanitor)

	local function fadeIn()
		local t1 = TweenService:Create(card, TweenInfo.new(Config.Animation.Normal), { BackgroundTransparency = 0.05 })
		local t2 = TweenService:Create(accentBar, TweenInfo.new(Config.Animation.Normal), { BackgroundTransparency = 0 })
		local t3 = TweenService:Create(titleLabel, TweenInfo.new(Config.Animation.Normal), { TextTransparency = 0 })
		local t4 = TweenService:Create(textLabel, TweenInfo.new(Config.Animation.Normal), { TextTransparency = 0 })
		for _, tween in ipairs({ t1, t2, t3, t4 }) do
			cardJanitor:Tween(tween)
			tween:Play()
		end
	end

	local function fadeOutAndRemove()
		local tween = TweenService:Create(card, TweenInfo.new(Config.Animation.Normal), {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
		})
		cardJanitor:Tween(tween)
		tween:Play()
		tween.Completed:Wait()
		cardJanitor:Destroy()
		self._activeCount = math.max(0, self._activeCount - 1)
		self:_processQueue()
	end

	fadeIn()
	cardJanitor:Delay(data.Duration or Config.Notification.Duration, function()
		Utilities.SafeCall(fadeOutAndRemove)
	end)
end

function NotificationSystem:Notify(data)
	if not data then
		return
	end
	data.Type = data.Type or "Info"
	table.insert(self._queue, data)
	self:_processQueue()
end

function NotificationSystem:Success(title, text)
	self:Notify({ Title = title, Text = text, Type = "Success" })
end

function NotificationSystem:Error(title, text)
	self:Notify({ Title = title, Text = text, Type = "Error" })
end

function NotificationSystem:Info(title, text)
	self:Notify({ Title = title, Text = text, Type = "Info" })
end

function NotificationSystem:Destroy()
	self.Janitor:Destroy()
	table.clear(self._queue)
end

local Notifications = NotificationSystem.new()


-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 1.1: CONFIRM DIALOG (orijinal dosyadan korundu, hata düzeltmeli)
-- ──────────────────────────────────────────────────────────────────────────

local ConfirmDialog = {}

function ConfirmDialog.Show(props)
	props = props or {}
	local janitor = Cleanup.new()
	TaskManager:AddJanitor(janitor)
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_ConfirmDialog"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 500
	screenGui.Parent = playerGui
	janitor:Add(screenGui)

	local scrim = Instance.new("TextButton")
	scrim.Text = ""
	scrim.AutoButtonColor = false
	scrim.Size = UDim2.new(1, 0, 1, 0)
	scrim.BackgroundColor3 = Color3.new(0, 0, 0)
	scrim.BackgroundTransparency = 1
	scrim.Parent = screenGui
	janitor:Add(scrim)

	local card = Instance.new("Frame")
	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.new(0.5, 0, 0.5, 0)
	card.Size = UDim2.new(0, 300, 0, 180)
	card.BackgroundColor3 = Config.Theme.Background
	card.BorderSizePixel = 0
	card.Parent = screenGui
	Utilities.Round_UI(card, Config.Sizes.CornerRadius)
	Utilities.Stroke(card, Theme.Accent, 1.5)
	Utilities.Padding(card, 16)
	janitor:Add(card)

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 24)
	title.Text = props.Title or "Emin misiniz?"
	title.TextColor3 = Config.Theme.TextPrimary
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = card

	local text = Instance.new("TextLabel")
	text.BackgroundTransparency = 1
	text.Position = UDim2.new(0, 0, 0, 30)
	text.Size = UDim2.new(1, 0, 0, 60)
	text.Text = props.Text or ""
	text.TextColor3 = Config.Theme.TextSecondary
	text.Font = Enum.Font.Gotham
	text.TextSize = 12
	text.TextWrapped = true
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Top
	text.Parent = card

	local buttonRow = Instance.new("Frame")
	buttonRow.Position = UDim2.new(0, 0, 1, -Config.Sizes.MinTouchTarget)
	buttonRow.Size = UDim2.new(1, 0, 0, Config.Sizes.MinTouchTarget)
	buttonRow.BackgroundTransparency = 1
	buttonRow.Parent = card

	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.Padding = UDim.new(0, 10)
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	buttonLayout.Parent = buttonRow

	local closed = false
	local function closeDialog(callback)
		if closed then
			return
		end
		closed = true
		local tweenOut = TweenService:Create(scrim, TweenInfo.new(Config.Animation.Fast), { BackgroundTransparency = 1 })
		local cardOut = TweenService:Create(card, TweenInfo.new(Config.Animation.Fast), { Size = UDim2.new(0, 0, 0, 0) })
		janitor:Tween(tweenOut)
		janitor:Tween(cardOut)
		tweenOut:Play()
		cardOut:Play()
		task.delay(Config.Animation.Fast + 0.05, function()
			janitor:Destroy()
		end)
		if callback then
			Utilities.SafeCall(callback)
		end
	end

	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0, 110, 1, 0)
	cancelBtn.BackgroundColor3 = Config.Theme.SurfaceLight
	cancelBtn.Text = props.CancelText or "Vazgec"
	cancelBtn.TextColor3 = Config.Theme.TextPrimary
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.TextSize = 13
	cancelBtn.AutoButtonColor = false
	cancelBtn.LayoutOrder = 1
	cancelBtn.Parent = buttonRow
	Utilities.Round_UI(cancelBtn, Config.Sizes.CornerRadiusSmall)
	janitor:Add(cancelBtn)

	local confirmBtn = Instance.new("TextButton")
	confirmBtn.Size = UDim2.new(0, 110, 1, 0)
	confirmBtn.BackgroundColor3 = Theme.Accent
	confirmBtn.Text = props.ConfirmText or "Onayla"
	confirmBtn.TextColor3 = Config.Theme.TextPrimary
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.TextSize = 13
	confirmBtn.AutoButtonColor = false
	confirmBtn.LayoutOrder = 2
	confirmBtn.Parent = buttonRow
	Utilities.Round_UI(confirmBtn, Config.Sizes.CornerRadiusSmall)
	janitor:Add(confirmBtn)

	janitor:Connect(cancelBtn.MouseButton1Click, function()
		closeDialog(props.OnCancel)
	end)

	janitor:Connect(scrim.MouseButton1Click, function()
		closeDialog(props.OnCancel)
	end)

	janitor:Connect(confirmBtn.MouseButton1Click, function()
		closeDialog(props.OnConfirm)
	end)

	card.Size = UDim2.new(0, 0, 0, 0)
	local scrimTween = TweenService:Create(scrim, TweenInfo.new(Config.Animation.Fast), { BackgroundTransparency = 0.5 })
	local cardTween = TweenService:Create(card, TweenInfo.new(Config.Animation.Normal, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 300, 0, 180),
	})
	janitor:Tween(scrimTween)
	janitor:Tween(cardTween)
	scrimTween:Play()
	cardTween:Play()
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 2: PENCERELER (MainWindow, TabSystem, Password, Command, Widget...)
-- ──────────────────────────────────────────────────────────────────────────

-- Ortak FloatingWindow: sürüklenebilir, kapatılabilir yardımcı pencere
local FloatingWindow = {}
FloatingWindow.__index = FloatingWindow

function FloatingWindow.new(opts)
	opts = opts or {}
	local self = setmetatable({}, FloatingWindow)
	self.Janitor = Cleanup.new()

	local parent = opts.Parent
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_" .. tostring(opts.Name or "Window")
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = opts.DisplayOrder or 200
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent
	self.Janitor:Add(screenGui)
	self.ScreenGui = screenGui

	local root = Instance.new("Frame")
	root.Name = "Root"
	root.Size = opts.Size or UDim2.fromOffset(320, 220)
	root.Position = opts.Position or UDim2.fromOffset(60, 200)
	root.BackgroundColor3 = Config.Theme.Background
	root.BackgroundTransparency = 0.06
	root.Active = true
	root.Visible = opts.Visible ~= false
	root.Parent = screenGui
	Utilities.Round_UI(root, Config.Sizes.CornerRadius)
	Utilities.Stroke(root, Theme.Accent, 1.5)
	self.Root = root

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, Config.Sizes.TitleBarHeight)
	titleBar.BackgroundColor3 = Config.Theme.Surface
	titleBar.Parent = root
	Utilities.Round_UI(titleBar, Config.Sizes.CornerRadius)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.Text = tostring(opts.Title or "X52")
	titleLabel.TextColor3 = Config.Theme.TextPrimary
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.Parent = titleBar

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -32, 0.5, -14)
	closeBtn.BackgroundColor3 = Theme.Accent
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Config.Theme.TextPrimary
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 12
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = titleBar
	Utilities.Round_UI(closeBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(closeBtn)

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -Config.Sizes.TitleBarHeight)
	content.Position = UDim2.new(0, 0, 0, Config.Sizes.TitleBarHeight)
	content.BackgroundTransparency = 1
	content.Parent = root
	self.Content = content

	self.Janitor:Connect(closeBtn.MouseButton1Click, function()
		self:SetVisible(false)
		if opts.OnClose then
			Utilities.SafeCall(opts.OnClose)
		end
	end)

	if opts.Draggable ~= false then
		local dragging = false
		local dragStart, startPos
		self.Janitor:Connect(titleBar.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = root.Position
			end
		end)
		self.Janitor:Connect(UserInputService.InputChanged, function(input)
			if not dragging then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				root.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
		self.Janitor:Connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	return self
end

function FloatingWindow:SetVisible(state)
	self.Root.Visible = state
	if state then
		Utilities.PlayUI("Open")
	end
end

function FloatingWindow:Toggle()
	self:SetVisible(not self.Root.Visible)
end

function FloatingWindow:IsVisible()
	return self.Root.Visible
end

function FloatingWindow:SetTitle(text)
	self.Root:FindFirstChild("TitleBar"):FindFirstChildOfClass("TextLabel").Text = text
end

function FloatingWindow:Destroy()
	self.Janitor:Destroy()
end

-- ── MainWindow ────────────────────────────────────────────────────────────
local MainWindow = {}
MainWindow.__index = MainWindow

local function getWindowSize()
	if Utilities.IsSmallScreen() then
		return Config.Sizes.WindowWidthMobile, Config.Sizes.WindowHeightMobile
	end
	return Config.Sizes.WindowWidthDesktop, Config.Sizes.WindowHeightDesktop
end

local function getTabBarWidth()
	if Utilities.IsSmallScreen() then
		return Config.Sizes.TabBarWidthMobile
	end
	return Config.Sizes.TabBarWidthDesktop
end

function MainWindow.new(parentGui)
	local self = setmetatable({}, MainWindow)
	self.Janitor = Cleanup.new()

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_MainWindow"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 300
	screenGui.Parent = parentGui or playerGui
	self.Janitor:Add(screenGui)
	self.ScreenGui = screenGui

	local width, height = getWindowSize()

	local root = Instance.new("Frame")
	root.Name = "Root"
	root.Size = UDim2.fromOffset(width, height)
	root.Position = UDim2.new(Config.Layout.WindowX, -width / 2, Config.Layout.WindowY, -height / 2)
	root.BackgroundColor3 = Config.Theme.Background
	root.BackgroundTransparency = 0.05
	root.Active = true
	root.Parent = screenGui
	Utilities.Round_UI(root, Config.Sizes.CornerRadius)
	Utilities.Stroke(root, Theme.Accent, 1.5)
	self.Root = root

	-- Hareketli arka plan (gradient animasyonu)
	local background = Instance.new("Frame")
	background.Name = "AnimatedBackground"
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Config.Theme.Surface
	background.BackgroundTransparency = 0.92
	background.Parent = root
	background.ZIndex = 0

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Accent),
		ColorSequenceKeypoint.new(1, Config.Theme.Background),
	})
	gradient.Rotation = 0
	gradient.Parent = background
	self.BackgroundGradient = gradient

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = Config.Menu.Scale
	uiScale.Parent = root
	self.UIScale = uiScale

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, Config.Sizes.TitleBarHeight)
	titleBar.BackgroundColor3 = Config.Theme.Surface
	titleBar.Parent = root
	Utilities.Round_UI(titleBar, Config.Sizes.CornerRadius)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -150, 1, 0)
	titleLabel.Position = UDim2.new(0, 14, 0, 0)
	titleLabel.Text = "X MENU V52"
	titleLabel.TextColor3 = Config.Theme.TextPrimary
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar
	self.TitleLabel = titleLabel

	-- Hızlı erişim çubuğu (butonlar buraya eklenir)
	local quickBar = Instance.new("Frame")
	quickBar.Name = "QuickBar"
	quickBar.Size = UDim2.new(1, -150, 0, Config.Sizes.TitleBarHeight)
	quickBar.Position = UDim2.new(0, 140, 0, 0)
	quickBar.BackgroundTransparency = 1
	quickBar.Parent = titleBar
	self.QuickBar = quickBar

	local quickLayout = Instance.new("UIListLayout")
	quickLayout.FillDirection = Enum.FillDirection.Horizontal
	quickLayout.Padding = UDim.new(0, 4)
	quickLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	quickLayout.Parent = quickBar

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 30, 0, 28)
	minimizeBtn.Position = UDim2.new(1, -70, 0.5, -14)
	minimizeBtn.BackgroundColor3 = Config.Theme.SurfaceLight
	minimizeBtn.Text = "—"
	minimizeBtn.TextColor3 = Config.Theme.TextPrimary
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 16
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.Parent = titleBar
	Utilities.Round_UI(minimizeBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(minimizeBtn)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 28)
	closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
	closeBtn.BackgroundColor3 = Theme.Accent
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Config.Theme.TextPrimary
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = titleBar
	Utilities.Round_UI(closeBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(closeBtn)

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -Config.Sizes.TitleBarHeight)
	content.Position = UDim2.new(0, 0, 0, Config.Sizes.TitleBarHeight)
	content.BackgroundTransparency = 1
	content.Parent = root
	self.Content = content

	local tabBarWidth = getTabBarWidth()

	local tabBar = Instance.new("ScrollingFrame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(0, tabBarWidth, 1, 0)
	tabBar.BackgroundTransparency = 1
	tabBar.BorderSizePixel = 0
	tabBar.ScrollBarThickness = 2
	tabBar.ScrollBarImageColor3 = Theme.Accent
	tabBar.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabBar.Parent = content
	Utilities.Padding(tabBar, 6)
	self.TabBarContainer = tabBar

	local pageArea = Instance.new("Frame")
	pageArea.Name = "PageArea"
	pageArea.Size = UDim2.new(1, -tabBarWidth, 1, 0)
	pageArea.Position = UDim2.new(0, tabBarWidth, 0, 0)
	pageArea.BackgroundTransparency = 1
	pageArea.Parent = content
	self.PageAreaContainer = pageArea

	-- Watermark
	local watermark = Instance.new("TextLabel")
	watermark.Name = "Watermark"
	watermark.AnchorPoint = Vector2.new(1, 0)
	watermark.Size = UDim2.new(0, 220, 0, 20)
	watermark.Position = UDim2.new(1, -10, 0, 6)
	watermark.BackgroundTransparency = 1
	watermark.Text = Config.Menu.WatermarkText
	watermark.TextColor3 = Theme.AccentBright
	watermark.Font = Enum.Font.GothamBold
	watermark.TextSize = Config.Menu.WatermarkSize
	watermark.TextXAlignment = Enum.TextXAlignment.Right
	watermark.TextTransparency = 0.25
	watermark.Parent = screenGui
	self.Watermark = watermark

	self:_setupDragging(titleBar, root)

	local expandedSize = root.Size

	self.Janitor:Connect(minimizeBtn.MouseButton1Click, function()
		local minimized = not _stateInstance:Get("Minimized")
		_stateInstance:Set("Minimized", minimized)
		content.Visible = not minimized
		quickBar.Visible = not minimized
		local targetSize = minimized
			and UDim2.new(0, expandedSize.X.Offset, 0, Config.Sizes.TitleBarHeight)
			or expandedSize
		local tween = TweenService:Create(root, TweenInfo.new(Config.Animation.Normal), { Size = targetSize })
		self.Janitor:Tween(tween)
		tween:Play()
		minimizeBtn.Text = minimized and "▢" or "—"
		Utilities.PlayUI("Click")
	end)

	self.Janitor:Connect(closeBtn.MouseButton1Click, function()
		self:SetVisible(false)
		_stateInstance:Set("MenuOpen", false)
		Utilities.PlayUI("Click")
	end)

	local camera = Workspace.CurrentCamera
	if camera then
		self.Janitor:Connect(camera:GetPropertyChangedSignal("ViewportSize"), function()
			self:_clampToScreen()
		end)
	end

	_stateInstance:Set("MenuOpen", true)
	return self
end

function MainWindow:_setupDragging(handle, target)
	local dragging = false
	local dragStart, startPos

	local function onInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end

	local function onInputChanged(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end

	local function onInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			self:_clampToScreen()
		end
	end

	self.Janitor:Connect(handle.InputBegan, onInputBegan)
	self.Janitor:Connect(UserInputService.InputChanged, onInputChanged)
	self.Janitor:Connect(UserInputService.InputEnded, onInputEnded)
end

function MainWindow:_clampToScreen()
	local viewport = Utilities.GetViewportSize()
	local absSize = self.Root.AbsoluteSize
	local absPos = self.Root.AbsolutePosition
	local clampedX = Utilities.Clamp(absPos.X, 0, math.max(0, viewport.X - absSize.X))
	local clampedY = Utilities.Clamp(absPos.Y, 0, math.max(0, viewport.Y - absSize.Y))
	if clampedX ~= absPos.X or clampedY ~= absPos.Y then
		self.Root.Position = UDim2.new(0, clampedX, 0, clampedY)
	end
end

function MainWindow:SetTitle(text)
	self.TitleLabel.Text = text
end

function MainWindow:SetVisible(state)
	self.Root.Visible = state
	self.Watermark.Visible = state
	_stateInstance:Set("MenuOpen", state)
end

function MainWindow:IsVisible()
	return self.Root.Visible
end

function MainWindow:AddQuickAction(text, callback)
	if not Config.Menu.QuickBar then
		return nil
	end
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 26, 0, 26)
	btn.BackgroundColor3 = Config.Theme.SurfaceLight
	btn.Text = text
	btn.TextColor3 = Config.Theme.TextPrimary
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	btn.Parent = self.QuickBar
	Utilities.Round_UI(btn, UDim.new(1, 0))
	self.Janitor:Add(btn)
	self.Janitor:Connect(btn.MouseButton1Click, function()
		Utilities.PlayUI("Click")
		if callback then
			Utilities.SafeCall(callback)
		end
	end)
	return btn
end

function MainWindow:ApplyScale(scale)
	Config.Menu.Scale = scale
	self.UIScale.Scale = scale
end

function MainWindow:ApplyTheme()
	local stroke = self.Root:FindFirstChildOfClass("UIStroke")
	if stroke then
		stroke.Color = Theme.Accent
	end
	self.BackgroundGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Accent),
		ColorSequenceKeypoint.new(1, Config.Theme.Background),
	})
	self.Watermark.TextColor3 = Theme.AccentBright
end

function MainWindow:Destroy()
	self.Janitor:Destroy()
end

-- ── TabSystem ─────────────────────────────────────────────────────────────
local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(tabBarParent, pageAreaParent)
	local self = setmetatable({}, TabSystem)
	self.Janitor = Cleanup.new()
	self._tabs = {}
	self._tabBarParent = tabBarParent
	self._pageAreaParent = pageAreaParent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = tabBarParent
	self.Janitor:Add(layout)

	self._onCurrentTabChanged = _stateInstance:OnChange("CurrentTab", function(newTab)
		self:_applySelection(newTab)
	end)

	return self
end

function TabSystem:AddTab(id, displayName)
	local button = Instance.new("TextButton")
	button.Name = "Tab_" .. tostring(id)
	button.Size = UDim2.new(1, 0, 0, Config.Sizes.MinTouchTarget)
	button.BackgroundColor3 = Config.Theme.Surface
	button.TextColor3 = Config.Theme.TextSecondary
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	button.Text = displayName
	button.AutoButtonColor = false
	button.LayoutOrder = #self._tabs + 1
	button.Parent = self._tabBarParent
	Utilities.Round_UI(button, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(button)

	local page = Instance.new("ScrollingFrame")
	page.Name = "Page_" .. tostring(id)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Theme.Accent
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	page.Visible = false
	page.Parent = self._pageAreaParent
	self.Janitor:Add(page)

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, Config.Sizes.RowSpacing)
	pageLayout.Parent = page
	Utilities.Padding(page, Config.Sizes.Padding)

	self._tabs[id] = { button = button, page = page, name = displayName }

	self.Janitor:Connect(button.MouseButton1Click, function()
		_stateInstance:Set("CurrentTab", id)
		Utilities.PlayUI("Click")
	end)

	if _stateInstance:Get("CurrentTab") == id then
		self:_applySelection(id)
	end

	return page
end

function TabSystem:_applySelection(activeId)
	for id, entry in pairs(self._tabs) do
		local isActive = (id == activeId)
		entry.page.Visible = isActive
		entry.button.BackgroundColor3 = isActive and Theme.Accent or Config.Theme.Surface
		entry.button.TextColor3 = isActive and Config.Theme.TextPrimary or Config.Theme.TextSecondary
	end
end

function TabSystem:SelectTab(id)
	if self._tabs[id] then
		_stateInstance:Set("CurrentTab", id)
	end
end

function TabSystem:GetTab(id)
	local entry = self._tabs[id]
	return entry and entry.page or nil
end

function TabSystem:GetTabNames()
	local names = {}
	for id, entry in pairs(self._tabs) do
		table.insert(names, { id = id, name = entry.name })
	end
	table.sort(names, function(a, b)
		return a.id < b.id
	end)
	return names
end

function TabSystem:Destroy()
	if self._onCurrentTabChanged then
		self._onCurrentTabChanged:Disconnect()
	end
	self.Janitor:Destroy()
	table.clear(self._tabs)
end

-- ── PasswordScreen ────────────────────────────────────────────────────────
local PasswordScreen = {}
PasswordScreen.__index = PasswordScreen

function PasswordScreen.new(notifications)
	local self = setmetatable({}, PasswordScreen)
	self.Janitor = Cleanup.new()
	self.Notifications = notifications
	self.Attempts = 0
	self.MaxAttempts = Config.Password.MaxAttempts
	self.LockoutTime = Config.Password.Lockout
	self.OnUnlock = nil
	self.Unlocked = false

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_Password"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 1000
	screenGui.Parent = playerGui
	self.Janitor:Add(screenGui)

	local blur = Instance.new("BlurEffect")
	blur.Name = "Blur"
	blur.Size = 12
	blur.Parent = screenGui
	self.Blur = blur

	local scrim = Instance.new("Frame")
	scrim.Size = UDim2.new(1, 0, 1, 0)
	scrim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	scrim.BackgroundTransparency = 0.55
	scrim.BorderSizePixel = 0
	scrim.Parent = screenGui
	self.Janitor:Add(scrim)

	local card = Instance.new("Frame")
	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.new(0.5, 0, 0.5, 0)
	card.Size = UDim2.new(0, 350, 0, 275)
	card.BackgroundColor3 = Config.Theme.Background
	card.BorderSizePixel = 0
	card.Parent = screenGui
	Utilities.Round_UI(card, Config.Sizes.CornerRadius)
	local cardStroke = Utilities.Stroke(card, Theme.Accent, 2)
	self.Janitor:Add(card)

	local pulseTween = TweenService:Create(cardStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Color = Theme.AccentDark,
	})
	self.Janitor:Tween(pulseTween)
	pulseTween:Play()

	local logo = Instance.new("TextLabel")
	logo.BackgroundTransparency = 1
	logo.Size = UDim2.new(0, 80, 0, 80)
	logo.Position = UDim2.new(0.5, -40, 0, 18)
	logo.Text = "X"
	logo.TextColor3 = Theme.AccentBright
	logo.Font = Enum.Font.GothamBlack
	logo.TextSize = 72
	logo.Parent = card

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 24)
	title.Position = UDim2.new(0, 0, 0, 104)
	title.Text = "X MENU V52"
	title.TextColor3 = Config.Theme.TextPrimary
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.Parent = card

	local subtitle = Instance.new("TextLabel")
	subtitle.BackgroundTransparency = 1
	subtitle.Size = UDim2.new(1, 0, 0, 18)
	subtitle.Position = UDim2.new(0, 0, 0, 130)
	subtitle.Text = "by XRIPX"
	subtitle.TextColor3 = Config.Theme.TextSecondary
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 12
	subtitle.Parent = card

	local input = Instance.new("TextBox")
	input.Name = "PasswordInput"
	input.PlaceholderText = "Sifre (" .. Config.Password.Value .. ")"
	input.Size = UDim2.new(1, -40, 0, 42)
	input.Position = UDim2.new(0, 20, 0, 158)
	input.BackgroundColor3 = Config.Theme.Surface
	input.TextColor3 = Config.Theme.TextPrimary
	input.PlaceholderColor3 = Config.Theme.TextMuted
	input.Font = Enum.Font.GothamBold
	input.TextSize = 14
	input.ClearTextOnFocus = false
	input.TextXAlignment = Enum.TextXAlignment.Center
	input.Parent = card
	Utilities.Round_UI(input, Config.Sizes.CornerRadiusSmall)
	Utilities.Stroke(input, Config.Theme.SurfaceLight, 1)
	self.Janitor:Add(input)

	local errorLabel = Instance.new("TextLabel")
	errorLabel.BackgroundTransparency = 1
	errorLabel.Size = UDim2.new(1, 0, 0, 16)
	errorLabel.Position = UDim2.new(0, 0, 1, -34)
	errorLabel.Text = ""
	errorLabel.TextColor3 = Config.Theme.Error
	errorLabel.Font = Enum.Font.GothamBold
	errorLabel.TextSize = 11
	errorLabel.Parent = card
	self.ErrorLabel = errorLabel

	local submitBtn = Instance.new("TextButton")
	submitBtn.Size = UDim2.new(1, -40, 0, 42)
	submitBtn.Position = UDim2.new(0, 20, 0, 204)
	submitBtn.BackgroundColor3 = Config.Theme.Success
	submitBtn.Text = "GIRIS"
	submitBtn.TextColor3 = Config.Theme.TextPrimary
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.TextSize = 14
	submitBtn.AutoButtonColor = false
	submitBtn.Parent = card
	Utilities.Round_UI(submitBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(submitBtn)

	local function shake()
		local originalPos = input.Position
		for i = 1, 3 do
			local t1 = TweenService:Create(input, TweenInfo.new(0.04), {
				Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset),
			})
			t1:Play()
			task.wait(0.04)
			local t2 = TweenService:Create(input, TweenInfo.new(0.04), {
				Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset),
			})
			t2:Play()
			task.wait(0.04)
		end
		local t3 = TweenService:Create(input, TweenInfo.new(0.04), { Position = originalPos })
		t3:Play()
	end

	local function tryUnlock()
		if self.Attempts >= self.MaxAttempts then
			errorLabel.Text = string.format("Cok fazla deneme - %d saniye bekle", self.LockoutTime)
			if self.Notifications then
				self.Notifications:Notify({
					Title = "Cok fazla deneme",
					Text = string.format("%d saniye sonra tekrar deneyin.", self.LockoutTime),
					Type = "Error",
				})
			end
			self.Janitor:Delay(self.LockoutTime, function()
				self.Attempts = 0
				errorLabel.Text = ""
			end)
			return
		end

		if input.Text == Config.Password.Value then
			self.Unlocked = true
			_stateInstance:Set("IsUnlocked", true)
			_stateInstance:Set("MenuOpen", true)

			if self.Notifications then
				self.Notifications:Notify({
					Title = "Erişim Onaylandı",
					Text = "X MENU V52 hazır.",
					Type = "Success",
				})
			end

			local fadeOut = TweenService:Create(scrim, TweenInfo.new(0.3), { BackgroundTransparency = 1 })
			local cardOut = TweenService:Create(card, TweenInfo.new(0.3), { Size = UDim2.new(0, 0, 0, 0) })
			self.Janitor:Tween(fadeOut)
			self.Janitor:Tween(cardOut)
			fadeOut:Play()
			cardOut:Play()
			cardOut.Completed:Connect(function()
				blur.Enabled = false
				if self.OnUnlock then
					Utilities.SafeCall(self.OnUnlock)
				end
			end)
		else
			self.Attempts = self.Attempts + 1
			errorLabel.Text = string.format("Hatali! (%d/%d)", self.Attempts, self.MaxAttempts)
			input.Text = ""
			Utilities.PlayUI("Error")
			task.spawn(shake)
			self.Janitor:Delay(3, function()
				if errorLabel.Text:find("Hatali") then
					errorLabel.Text = ""
				end
			end)
		end
	end

	self.Janitor:Connect(submitBtn.MouseButton1Click, tryUnlock)
	self.Janitor:Connect(input.FocusLost, function(enterPressed)
		if enterPressed then
			tryUnlock()
		end
	end)

	card.Size = UDim2.new(0, 0, 0, 0)
	local grow = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 350, 0, 275),
	})
	grow:Play()

	return self
end

function PasswordScreen:Destroy()
	self.Janitor:Destroy()
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 3: MOTORLAR (Hibrit Fizik, Karakter, Araç, Waypoint, Track, Kamera)
-- ──────────────────────────────────────────────────────────────────────────

local PhysicsEngine = {}

PhysicsEngine.LastKnownVehicle = nil
PhysicsEngine.LastVehicleTime = 0
PhysicsEngine.LastVehicleCache = nil
PhysicsEngine.LastVehicleCacheTime = 0

function PhysicsEngine.SetNetworkOwner(part)
	if not part or not part:IsA("BasePart") then
		return false
	end
	local ok = pcall(function()
		part:SetNetworkOwner(LocalPlayer)
	end)
	return ok
end

-- HİBRİT FİZİK MOTORU
-- 1) SetNetworkOwner (pcall)  2) ApplyImpulse  3) LinearVelocity  4) AssemblyLinearVelocity
function PhysicsEngine.ApplyImpulse(part, impulse, options)
	options = options or {}
	if not part or not part:IsA("BasePart") or not part.Parent then
		return false, "gecersiz parca"
	end

	PhysicsEngine.SetNetworkOwner(part)

	local success, err = pcall(function()
		part:ApplyImpulse(impulse)
	end)
	if success then
		return true, "impulse"
	end

	-- Fallback 1: LinearVelocity constraint
	local lvSuccess = pcall(function()
		local existing = part:FindFirstChild("X52LinearVelocity")
		if existing then
			existing:Destroy()
		end
		local linear = Instance.new("LinearVelocity")
		linear.Name = "X52LinearVelocity"
		linear.Attachment0 = nil
		linear.RelativeTo = Enum.ActuatorRelativeTo.World
		linear.MaxForce = math.huge
		linear.ForceLimitMode = Enum.ForceLimitMode.Magnitude
		linear.VectorVelocity = impulse * (options.VelocityScale or 1)
		linear.Parent = part
		Debris:AddItem(linear, Config.Physics.LinearVelocityLife)
	end)
	if lvSuccess then
		return true, "linearvelocity"
	end

	-- Fallback 2: AssemblyLinearVelocity
	local avSuccess = pcall(function()
		part.AssemblyLinearVelocity = impulse * (options.VelocityScale or 1)
	end)
	if avSuccess then
		return true, "assembly"
	end

	return false, tostring(err)
end

function PhysicsEngine.SetVelocity(part, velocity)
	if not part or not part:IsA("BasePart") or not part.Parent then
		return false
	end
	PhysicsEngine.SetNetworkOwner(part)
	local ok = pcall(function()
		part.AssemblyLinearVelocity = velocity
	end)
	return ok
end

function PhysicsEngine.ApplySpin(part, axis, speed)
	if not part or not part:IsA("BasePart") or not part.Parent then
		return false
	end
	PhysicsEngine.SetNetworkOwner(part)
	return pcall(function()
		part.AssemblyAngularVelocity = axis.Unit * speed
	end)
end

function PhysicsEngine.GetSeatPart(humanoid)
	if not humanoid then
		return nil
	end
	local ok, seat = pcall(function()
		return humanoid:GetSeatPart()
	end)
	if ok and seat then
		return seat
	end
	local legacy = humanoid.SeatPart
	return legacy
end

function PhysicsEngine.IsVehicleModel(model)
	if not model or not model:IsA("Model") then
		return false
	end
	if model:FindFirstChild("VehicleSeat") or model:FindFirstChild("Seat") then
		return true
	end
	local hum = model:FindFirstChildOfClass("Humanoid")
	return hum ~= nil
end

function PhysicsEngine.SetLastVehicle(vehicle)
	if not vehicle then
		return
	end
	PhysicsEngine.LastKnownVehicle = vehicle
	PhysicsEngine.LastVehicleTime = os.clock()
end

-- Araç bulma: 1) oturulan koltuk  2) son bilinen araç (3600 sn)  3) yakin tarama
function PhysicsEngine.GetVehicle()
	local character = Utilities.GetCharacter(LocalPlayer)
	if character then
		local humanoid = Utilities.GetHumanoid(character)
		local seat = PhysicsEngine.GetSeatPart(humanoid)
		if seat and seat.Parent then
			local model = seat.Parent
			if model:IsA("Model") then
				PhysicsEngine.SetLastVehicle(model)
				return model
			end
		end
	end

	local cached = PhysicsEngine.LastKnownVehicle
	if cached and cached.Parent and (os.clock() - PhysicsEngine.LastVehicleTime) < Config.Physics.VehicleCacheTTL then
		return cached
	end

	-- 5 saniyede bir yakin model taramasi
	if os.clock() - PhysicsEngine.LastVehicleCacheTime > 5 then
		PhysicsEngine.LastVehicleCacheTime = os.clock()
		local root = Utilities.GetRootPart(character)
		if root then
			local best = nil
			local bestDist = math.huge
			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Model") and PhysicsEngine.IsVehicleModel(child) then
					local part = Utilities.GetMainPart(child)
					if part then
						local dist = (part.Position - root.Position).Magnitude
						if dist < 80 and dist < bestDist then
							bestDist = dist
							best = child
						end
					end
				end
			end
			PhysicsEngine.LastVehicleCache = best
		end
	end

	return PhysicsEngine.LastVehicleCache
end

function PhysicsEngine.GetPlayersInRadius(radius, origin)
	local result = {}
	if not origin then
		return result
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local character = Utilities.GetCharacter(player)
			local root = Utilities.GetRootPart(character)
			if root and (root.Position - origin).Magnitude <= radius then
				table.insert(result, player)
			end
		end
	end
	return result
end

-- Karakter fizik işlemleri
local CharacterController = {}
CharacterController.Flying = false
CharacterController.FlySpeed = Config.Physics.FlySpeed
CharacterController.Noclip = false
CharacterController.Frozen = false
CharacterController._savedCollide = {}
CharacterController._savedWalkSpeed = nil
CharacterController._freezeTarget = nil
CharacterController._freezeOriginal = nil

function CharacterController.GetCharacter()
	return Utilities.GetCharacter(LocalPlayer)
end

function CharacterController.GetRoot()
	return Utilities.GetRootPart(CharacterController.GetCharacter())
end

function CharacterController.SetFly(enabled)
	CharacterController.Flying = enabled
	local character = CharacterController.GetCharacter()
	if not character then
		return false
	end
	local humanoid = Utilities.GetHumanoid(character)
	if enabled then
		if humanoid then
			CharacterController._savedWalkSpeed = humanoid.WalkSpeed
			humanoid.WalkSpeed = 0
		end
		local root = CharacterController.GetRoot()
		if root then
			PhysicsEngine.SetNetworkOwner(root)
		end
	else
		if humanoid and CharacterController._savedWalkSpeed then
			humanoid.WalkSpeed = CharacterController._savedWalkSpeed
			CharacterController._savedWalkSpeed = nil
		end
	end
	return true
end

function CharacterController.SetNoclip(enabled)
	CharacterController.Noclip = enabled
	local character = CharacterController.GetCharacter()
	if not character then
		return false
	end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			if enabled then
				if CharacterController._savedCollide[part] == nil then
					CharacterController._savedCollide[part] = part.CanCollide
				end
				part.CanCollide = false
			else
				local saved = CharacterController._savedCollide[part]
				if saved ~= nil then
					part.CanCollide = saved
					CharacterController._savedCollide[part] = nil
				end
			end
		end
	end
	if not enabled then
		CharacterController._savedCollide = {}
	end
	return true
end

function CharacterController.SetFrozen(enabled, targetPlayer)
	CharacterController.Frozen = enabled
	if not enabled then
		CharacterController._freezeTarget = nil
		CharacterController._freezeOriginal = nil
		return true
	end
	local character = targetPlayer and Utilities.GetCharacter(targetPlayer) or CharacterController.GetCharacter()
	local root = Utilities.GetRootPart(character)
	if not root then
		return false
	end
	CharacterController._freezeTarget = root
	CharacterController._freezeOriginal = root.CFrame
	return true
end

function CharacterController.Update(dt)
	local character = CharacterController.GetCharacter()
	if not character then
		return
	end
	local root = CharacterController.GetRoot()
	if not root then
		return
	end

	if CharacterController.Frozen and CharacterController._freezeTarget then
		local target = CharacterController._freezeTarget
		if target.Parent then
			target.CFrame = CharacterController._freezeOriginal or target.CFrame
		else
			CharacterController.Frozen = false
		end
	end

	if CharacterController.Flying then
		local camera = Workspace.CurrentCamera
		if camera then
			local direction = CharacterController.FlyDirection
			if direction and direction.Magnitude > 0.01 then
				local velocity = direction.Unit * CharacterController.FlySpeed
				PhysicsEngine.SetVelocity(root, velocity)
			else
				PhysicsEngine.SetVelocity(root, Vector3.new(0, root.AssemblyLinearVelocity.Y, 0))
			end
		end
	end
end

-- Araç kontrolü
local VehicleController = {}
VehicleController.Flying = false
VehicleController.Vehicle = nil
VehicleController.FlySpeed = Config.Physics.FlySpeed
VehicleController.Noclip = false
VehicleController._align = nil
VehicleController._velocity = nil
VehicleController._savedCollide = {}
VehicleController._inputVector = Vector3.zero

function VehicleController.GetVehicle()
	local vehicle = PhysicsEngine.GetVehicle()
	VehicleController.Vehicle = vehicle
	return vehicle
end

function VehicleController.SetInput(vector)
	VehicleController._inputVector = vector
end

function VehicleController.GetInput()
	return VehicleController._inputVector
end

function VehicleController.SetNoclip(enabled)
	VehicleController.Noclip = enabled
	local vehicle = VehicleController.GetVehicle()
	if not vehicle then
		return false
	end
	for _, part in ipairs(vehicle:GetDescendants()) do
		if part:IsA("BasePart") then
			if enabled then
				if VehicleController._savedCollide[part] == nil then
					VehicleController._savedCollide[part] = part.CanCollide
				end
				part.CanCollide = false
			else
				local saved = VehicleController._savedCollide[part]
				if saved ~= nil then
					part.CanCollide = saved
					VehicleController._savedCollide[part] = nil
				end
			end
		end
	end
	if not enabled then
		VehicleController._savedCollide = {}
	end
	return true
end

function VehicleController.SetFly(enabled)
	local vehicle = VehicleController.GetVehicle()
	if not vehicle then
		return false, "arac bulunamadi"
	end
	local part = Utilities.GetMainPart(vehicle)
	if not part then
		return false, "arac parcasi yok"
	end

	if not enabled then
		VehicleController.Flying = false
		if VehicleController._align then
			VehicleController._align:Destroy()
			VehicleController._align = nil
		end
		if VehicleController._velocity then
			VehicleController._velocity:Destroy()
			VehicleController._velocity = nil
		end
		return true
	end

	VehicleController.Flying = true
	VehicleController.Vehicle = vehicle
	PhysicsEngine.SetNetworkOwner(part)

	pcall(function()
		if VehicleController._align then
			VehicleController._align:Destroy()
		end
		local align = Instance.new("AlignPosition")
		align.Name = "X52AlignPosition"
		align.MaxForce = math.huge
		align.Mode = Enum.PositionAlignmentMode.OneAttachment
		align.RigidityEnabled = false
		align.Responsiveness = 20
		align.Position = part.Position
		align.Parent = part
		VehicleController._align = align
	end)

	pcall(function()
		if VehicleController._velocity then
			VehicleController._velocity:Destroy()
		end
		local linear = Instance.new("LinearVelocity")
		linear.Name = "X52VehicleVelocity"
		linear.MaxForce = math.huge
		linear.RelativeTo = Enum.ActuatorRelativeTo.World
		linear.VectorVelocity = Vector3.zero
		linear.Parent = part
		VehicleController._velocity = linear
	end)

	return true
end

function VehicleController.Update(dt)
	if not VehicleController.Flying then
		return
	end
	local vehicle = VehicleController.Vehicle
	if not vehicle or not vehicle.Parent then
		vehicle = VehicleController.GetVehicle()
		if not vehicle then
			return
		end
	end
	local part = Utilities.GetMainPart(vehicle)
	if not part then
		return
	end

	local input = VehicleController._inputVector
	local camera = Workspace.CurrentCamera
	local speed = VehicleController.FlySpeed

	if input.Magnitude > 0.01 then
		local worldDirection = input
		if camera then
			local cf = camera.CFrame
			worldDirection = cf.LookVector * input.Z + cf.RightVector * input.X + Vector3.new(0, input.Y, 0)
		end
		if worldDirection.Magnitude > 0.001 then
			worldDirection = worldDirection.Unit
		end
		local velocity = worldDirection * speed
		if VehicleController._velocity then
			VehicleController._velocity.VectorVelocity = velocity
		else
			PhysicsEngine.SetVelocity(part, velocity)
		end
		if VehicleController._align then
			VehicleController._align.Position = part.Position + velocity * dt
		end
	else
		if VehicleController._velocity then
			VehicleController._velocity.VectorVelocity = Vector3.zero
		end
	end
end

-- Waypoint (iki nokta arası ping-pong, durmadan)
local WaypointController = {}
WaypointController.Active = false
WaypointController.PointA = nil
WaypointController.PointB = nil
WaypointController.Direction = 1
WaypointController.Speed = Config.Physics.WaypointSpeed
WaypointController.AutoFling = true
WaypointController.FlingPower = Config.Physics.FlingPowerDefault
WaypointController._lastFling = 0

function WaypointController.SetWaypoints(pointA, pointB)
	WaypointController.PointA = pointA
	WaypointController.PointB = pointB
	return true
end

function WaypointController.Start()
	if not WaypointController.PointA or not WaypointController.PointB then
		return false
	end
	local character = CharacterController.GetCharacter()
	local root = CharacterController.GetRoot()
	if not root then
		return false
	end
	WaypointController.Active = true
	WaypointController.Direction = 1
	WaypointController._lastFling = os.clock()
	local start = WaypointController.Direction > 0 and WaypointController.PointA or WaypointController.PointB
	if start then
		root.CFrame = CFrame.new(start)
	end
	return true
end

function WaypointController.Stop()
	WaypointController.Active = false
end

function WaypointController.Update(dt)
	if not WaypointController.Active then
		return
	end
	local root = CharacterController.GetRoot()
	if not root then
		WaypointController.Active = false
		return
	end

	local target = WaypointController.Direction > 0 and WaypointController.PointB or WaypointController.PointA
	local origin = WaypointController.Direction > 0 and WaypointController.PointA or WaypointController.PointB
	if not target or not origin then
		WaypointController.Active = false
		return
	end

	local direction = Utilities.GetDirection(root.Position, target)
	if direction.Magnitude < 0.001 then
		WaypointController.Direction = -WaypointController.Direction
		return
	end

	-- Hedefe dogru ilerle, durma payi yok
	PhysicsEngine.SetVelocity(root, direction * WaypointController.Speed)

	-- Yoldaki oyunculari otomatik firlat
	if WaypointController.AutoFling and os.clock() - WaypointController._lastFling > 0.35 then
		WaypointController._lastFling = os.clock()
		for _, player in ipairs(PhysicsEngine.GetPlayersInRadius(8, root.Position)) do
			local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(player))
			if targetRoot then
				PhysicsEngine.ApplyImpulse(targetRoot, Vector3.new(0, WaypointController.FlingPower, 0))
			end
		end
	end
end

-- Track & Spam Kill (hedef takibi + surekli fling)
local TrackController = {}
TrackController.Active = false
TrackController.Targets = {}
TrackController.Speed = Config.Physics.FlySpeed
TrackController.FlingPower = Config.Physics.FlingPowerDefault
TrackController.Interval = Config.Physics.TrackInterval
TrackController._lastFling = 0

function TrackController.AddTarget(player)
	if not player then
		return false
	end
	for _, existing in ipairs(TrackController.Targets) do
		if existing == player then
			return false
		end
	end
	table.insert(TrackController.Targets, player)
	return true
end

function TrackController.RemoveTarget(player)
	for i, existing in ipairs(TrackController.Targets) do
		if existing == player then
			table.remove(TrackController.Targets, i)
			return true
		end
	end
	return false
end

function TrackController.Clear()
	table.clear(TrackController.Targets)
end

function TrackController.Start()
	if #TrackController.Targets == 0 then
		return false
	end
	TrackController.Active = true
	TrackController._lastFling = 0
	return true
end

function TrackController.Stop()
	TrackController.Active = false
end

function TrackController.GetPredictedPosition(targetPlayer)
	local character = Utilities.GetCharacter(targetPlayer)
	local root = Utilities.GetRootPart(character)
	if not root then
		return nil, nil
	end
	local velocity = root.AssemblyLinearVelocity
	local predicted = root.Position + velocity * Config.Physics.TrackPrediction
	return predicted, root
end

function TrackController.Update(dt)
	if not TrackController.Active then
		return
	end
	local root = CharacterController.GetRoot()
	if not root then
		return
	end

	local primary = nil
	for _, player in ipairs(TrackController.Targets) do
		if player and player.Parent then
			primary = player
			break
		end
	end
	if not primary then
		TrackController.Stop()
		return
	end

	local predicted = TrackController.GetPredictedPosition(primary)
	if not predicted then
		return
	end

	local direction = Utilities.GetDirection(root.Position, predicted)
	if direction.Magnitude > 0.001 then
		PhysicsEngine.SetVelocity(root, direction * TrackController.Speed)
	end

	if os.clock() - TrackController._lastFling >= TrackController.Interval then
		TrackController._lastFling = os.clock()
		for _, player in ipairs(TrackController.Targets) do
			if player and player.Parent then
				local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(player))
				if targetRoot then
					PhysicsEngine.ApplyImpulse(targetRoot, Vector3.new(0, TrackController.FlingPower, 0))
				end
			end
		end
	end
end

-- Kamera kontrolleri
local CameraController = {}
CameraController.Noclip = false
CameraController.SpectateTarget = nil
CameraController.ForceMode = nil
CameraController.PathRecording = false
CameraController.PathPoints = {}
CameraController.PathPlayback = false
CameraController.BlockAdminCam = false
CameraController._lastCameraType = nil

function CameraController.SetNoclip(enabled)
	CameraController.Noclip = enabled
	return true
end

function CameraController.Spectate(player)
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	if not player then
		camera.CameraSubject = nil
		CameraController.SpectateTarget = nil
		return true
	end
	local character = Utilities.GetCharacter(player)
	if not character then
		return false
	end
	local humanoid = Utilities.GetHumanoid(character)
	if humanoid then
		camera.CameraSubject = humanoid
	else
		camera.CameraSubject = Utilities.GetRootPart(character)
	end
	CameraController.SpectateTarget = player
	return true
end

function CameraController.Unspectate()
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local character = CharacterController.GetCharacter()
	local humanoid = Utilities.GetHumanoid(character)
	camera.CameraSubject = humanoid or Utilities.GetRootPart(character)
	CameraController.SpectateTarget = nil
end

function CameraController.SetForceMode(mode)
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	CameraController.ForceMode = mode
	if mode == "Classic" then
		camera.CameraType = Enum.CameraType.Classic
	elseif mode == "LockFirstPerson" then
		camera.CameraType = Enum.CameraType.LockFirstPerson
	elseif mode == "Scriptable" then
		camera.CameraType = Enum.CameraType.Scriptable
	end
	return true
end

function CameraController.StartPathRecord()
	CameraController.PathRecording = true
	CameraController.PathPlayback = false
	table.clear(CameraController.PathPoints)
	return true
end

function CameraController.StopPathRecord()
	CameraController.PathRecording = false
	return #CameraController.PathPoints
end

function CameraController.PlayPath()
	if #CameraController.PathPoints < 2 then
		return false
	end
	CameraController.PathPlayback = true
	CameraController._pathIndex = 1
	return true
end

function CameraController.StopPath()
	CameraController.PathPlayback = false
	CameraController.PathPoints = {}
end

function CameraController.Update(dt)
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end

	-- Kamera noclip: duvar arkasina girmesin
	if CameraController.Noclip then
		local subject = camera.CameraSubject
		local position = nil
		if subject and subject:IsA("BasePart") then
			position = subject.Position
		elseif subject and subject:IsA("Model") then
			local part = subject:FindFirstChild("HumanoidRootPart") or subject:FindFirstChild("Head")
			if part and part:IsA("BasePart") then
				position = part.Position
			end
		end
		if position then
			local direction = camera.CFrame.Position - position
			local distance = direction.Magnitude
			if distance > 0.1 then
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				local character = CharacterController.GetCharacter()
				if character then
					params.FilterDescendantsInstances = { character }
				end
				local result = Workspace:Raycast(position, direction.Unit, params)
				if result then
					local safeDistance = math.max(0.5, (result.Distance - 0.3) / math.max(distance, 0.1))
					camera.CFrame = CFrame.new(position + direction.Unit * (distance * safeDistance)) * (camera.CFrame - camera.CFrame.Position)
				end
			end
		end
	end

	-- Admin kamera engeli: baska biri kamerani degistirirse geri al
	if CameraController.BlockAdminCam then
		local expected = nil
		if CameraController.ForceMode then
			expected = CameraController.ForceMode
		end
		if expected == "Classic" and camera.CameraType ~= Enum.CameraType.Classic then
			camera.CameraType = Enum.CameraType.Classic
		elseif expected == "LockFirstPerson" and camera.CameraType ~= Enum.CameraType.LockFirstPerson then
			camera.CameraType = Enum.CameraType.LockFirstPerson
		elseif expected == "Scriptable" and camera.CameraType ~= Enum.CameraType.Scriptable then
			camera.CameraType = Enum.CameraType.Scriptable
		end
		if camera.CameraSubject == nil then
			local character = CharacterController.GetCharacter()
			camera.CameraSubject = Utilities.GetHumanoid(character) or Utilities.GetRootPart(character)
		end
	end

	-- Kamera yolu kaydi
	if CameraController.PathRecording then
		local key = CFrame.new(camera.CFrame.Position, camera.CFrame.LookVector)
		local last = CameraController.PathPoints[#CameraController.PathPoints]
		if not last or (key.Position - last.Position).Magnitude > 1 then
			table.insert(CameraController.PathPoints, key)
			if #CameraController.PathPoints > 500 then
				table.remove(CameraController.PathPoints, 1)
			end
		end
	end

	if CameraController.PathPlayback and #CameraController.PathPoints > 1 then
		CameraController._pathTime = (CameraController._pathTime or 0) + dt
		local index = math.floor(CameraController._pathTime * 4) % #CameraController.PathPoints + 1
		local point = CameraController.PathPoints[index]
		if point then
			camera.CFrame = CFrame.lookAt(point.Position, point.Position + point.LookVector)
		end
	end
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 4: ORTAM KONTROLLERİ (ışık, sis, yerçekimi, partikül, mesh)
-- ──────────────────────────────────────────────────────────────────────────

local EnvironmentController = {}
EnvironmentController.LightEnabled = false
EnvironmentController.LightRange = 40
EnvironmentController.LightBrightness = 2
EnvironmentController._light = nil
EnvironmentController._savedFog = nil
EnvironmentController._savedGravity = nil
EnvironmentController.TimeFrozen = false
EnvironmentController._frozenTime = os.time()
EnvironmentController.HideMeshes = false
EnvironmentController.HideParticles = false
EnvironmentController._hiddenMeshes = {}
EnvironmentController._hiddenParticles = {}

function EnvironmentController.SetLocalLight(enabled)
	EnvironmentController.LightEnabled = enabled
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	if enabled then
		if not EnvironmentController._light or not EnvironmentController._light.Parent then
			local light = Instance.new("PointLight")
			light.Name = "X52LocalLight"
			light.Range = EnvironmentController.LightRange
			light.Brightness = EnvironmentController.LightBrightness
			light.Shadows = false
			light.Parent = camera
			EnvironmentController._light = light
		else
			EnvironmentController._light.Enabled = true
		end
	else
		if EnvironmentController._light then
			EnvironmentController._light.Enabled = false
		end
	end
	return true
end

function EnvironmentController.SetFog(enabled, fogEnd, fogColor)
	if enabled then
		if not EnvironmentController._savedFog then
			EnvironmentController._savedFog = {
				Start = Lighting.FogStart,
				End = Lighting.FogEnd,
				Color = Lighting.FogColor,
			}
		end
		Lighting.FogStart = 0
		Lighting.FogEnd = fogEnd or 500
		Lighting.FogColor = fogColor or Color3.fromRGB(120, 120, 130)
	else
		if EnvironmentController._savedFog then
			Lighting.FogStart = EnvironmentController._savedFog.Start
			Lighting.FogEnd = EnvironmentController._savedFog.End
			Lighting.FogColor = EnvironmentController._savedFog.Color
			EnvironmentController._savedFog = nil
		end
	end
	return true
end

function EnvironmentController.SetGravity(value)
	if value == nil then
		if EnvironmentController._savedGravity then
			Workspace.Gravity = EnvironmentController._savedGravity
			EnvironmentController._savedGravity = nil
		end
		return true
	end
	if not EnvironmentController._savedGravity then
		EnvironmentController._savedGravity = Workspace.Gravity
	end
	Workspace.Gravity = Utilities.Clamp(value, 0, 500)
	return true
end

function EnvironmentController.SetTimeFrozen(enabled)
	EnvironmentController.TimeFrozen = enabled
	if enabled then
		EnvironmentController._frozenTime = os.time()
	else
		EnvironmentController._frozenTime = nil
	end
	return true
end

function EnvironmentController.GetTime()
	if EnvironmentController.TimeFrozen and EnvironmentController._frozenTime then
		return EnvironmentController._frozenTime
	end
	return os.time()
end

function EnvironmentController.ToggleMeshes(enabled)
	EnvironmentController.HideMeshes = enabled
	if enabled then
		for _, instance in ipairs(Workspace:GetDescendants()) do
			if instance:IsA("MeshPart") or instance:IsA("Decal") or instance:IsA("Texture") then
				if EnvironmentController._hiddenMeshes[instance] == nil then
					EnvironmentController._hiddenMeshes[instance] = instance.Transparency or 0
				end
				if instance:IsA("Decal") or instance:IsA("Texture") then
					instance.Transparency = 1
				else
					instance.Transparency = 1
				end
			end
		end
	else
		for instance, transparency in pairs(EnvironmentController._hiddenMeshes) do
			if instance.Parent then
				instance.Transparency = transparency
			end
		end
		EnvironmentController._hiddenMeshes = {}
	end
	return true
end

function EnvironmentController.ToggleParticles(enabled)
	EnvironmentController.HideParticles = enabled
	if enabled then
		for _, instance in ipairs(Workspace:GetDescendants()) do
			if instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam") then
				if EnvironmentController._hiddenParticles[instance] == nil then
					EnvironmentController._hiddenParticles[instance] = instance.Enabled
				end
				instance.Enabled = false
			end
		end
	else
		for instance, wasEnabled in pairs(EnvironmentController._hiddenParticles) do
			if instance.Parent then
				instance.Enabled = wasEnabled
			end
		end
		EnvironmentController._hiddenParticles = {}
	end
	return true
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 5: ADMIN / GÖZLEM ARAÇLARI (30 özellik, tamamı yerel)
-- ──────────────────────────────────────────────────────────────────────────

local AdminTools = {}
AdminTools.ActivityLog = {}
AdminTools.MutedPlayers = {}
AdminTools.BlockedPlayers = {}
AdminTools.NameTags = {}
AdminTools.Clones = {}
AdminTools.SoundList = {}
AdminTools.FrozenTarget = nil
AdminTools.FrozenOriginal = nil
AdminTools.ObjectInspectMode = false

local function LogActivity(text)
	table.insert(AdminTools.ActivityLog, {
		Time = os.clock(),
		Text = tostring(text),
	})
	if #AdminTools.ActivityLog > 300 then
		table.remove(AdminTools.ActivityLog, 1)
	end
	_stateInstance:Set("ActivityCount", #AdminTools.ActivityLog)
end

function AdminTools.GetTarget()
	local target = _stateInstance:Get("TargetPlayer")
	if target and target.Parent then
		return target
	end
	return nil
end

function AdminTools.SetTarget(player)
	_stateInstance:Set("TargetPlayer", player)
	if player then
		LogActivity("Hedef degisti: " .. player.DisplayName)
	end
end

function AdminTools.TeleportToTarget()
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(target))
	local myRoot = CharacterController.GetRoot()
	if not targetRoot or not myRoot then
		return false, "karakter bulunamadi"
	end
	local newCFrame = targetRoot.CFrame * CFrame.new(0, 0, -5)
	myRoot.CFrame = newCFrame
	PhysicsEngine.SetVelocity(myRoot, Vector3.zero)
	LogActivity("Teleport: " .. target.DisplayName)
	return true
end

function AdminTools.BringTarget()
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(target))
	local myRoot = CharacterController.GetRoot()
	if not targetRoot or not myRoot then
		return false, "karakter bulunamadi"
	end
	local newCFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
	targetRoot.CFrame = newCFrame
	LogActivity("Bring (yerel illuzyon): " .. target.DisplayName)
	return true
end

function AdminTools.FreezeTarget(enabled)
	local target = AdminTools.GetTarget()
	if not enabled then
		AdminTools.FrozenTarget = nil
		AdminTools.FrozenOriginal = nil
		return true
	end
	local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(target))
	if not targetRoot then
		return false, "hedef bulunamadi"
	end
	AdminTools.FrozenTarget = targetRoot
	AdminTools.FrozenOriginal = targetRoot.CFrame
	LogActivity("Yerel dondurma: " .. target.DisplayName)
	return true
end

function AdminTools.MuteTarget(enabled)
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	AdminTools.MutedPlayers[target.UserId] = enabled and true or nil
	if enabled then
		LogActivity("Yerel susturma: " .. target.DisplayName)
	end
	return true
end

function AdminTools.SetNameTag(player, text, color)
	if not player then
		return false
	end
	local character = Utilities.GetCharacter(player)
	local head = Utilities.GetPlayerHead(player)
	if not character or not head then
		return false
	end
	local existing = head:FindFirstChild("X52NameTag")
	if existing then
		existing:Destroy()
		AdminTools.NameTags[player.UserId] = nil
	end
	if text == nil or text == "" then
		return true
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "X52NameTag"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(200, 46)
	billboard.StudsOffset = Vector3.new(0, 2.6, 0)
	billboard.AlwaysOnTop = false
	billboard.MaxDistance = 120
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Theme.AccentBright
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.4
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextWrapped = true
	label.Parent = billboard

	AdminTools.NameTags[player.UserId] = billboard
	return true
end

function AdminTools.HighlightTarget(enabled)
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	local head = Utilities.GetPlayerHead(target)
	if not head then
		return false, "hedef bulunamadi"
	end
	local existing = head:FindFirstChild("X52Highlight")
	if existing then
		existing:Destroy()
		AdminTools.NameTags[target.UserId .. "_hl"] = nil
	end
	if not enabled then
		return true
	end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "X52Highlight"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(120, 26)
	billboard.StudsOffset = Vector3.new(0, 3.4, 0)
	billboard.AlwaysOnTop = false
	billboard.MaxDistance = 100
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "▼ " .. target.DisplayName
	label.TextColor3 = Config.Theme.Warning
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.3
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.Parent = billboard

	AdminTools.NameTags[target.UserId .. "_hl"] = billboard
	return true
end

function AdminTools.CloneAvatar()
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	local character = Utilities.GetCharacter(target)
	if not character then
		return false, "karakter bulunamadi"
	end
	local clone = character:Clone()
	clone.Name = "X52Clone_" .. target.Name
	for _, instance in ipairs(clone:GetDescendants()) do
		if instance:IsA("BasePart") then
			instance.Anchored = true
			instance.CanCollide = false
			instance.CanQuery = false
			instance.Transparency = math.max(instance.Transparency, 0.4)
		end
		if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
			instance:Destroy()
		end
	end
	local head = clone:FindFirstChild("Head")
	local root = clone:FindFirstChild("HumanoidRootPart")
	if head and root then
		clone:PivotTo(root.CFrame * CFrame.new(0, 0, -4))
	end
	clone.Parent = Workspace
	table.insert(AdminTools.Clones, clone)
	LogActivity("Avatar klonlandi: " .. target.DisplayName)
	return true
end

function AdminTools.ScaleAvatar(scale)
	local target = AdminTools.GetTarget()
	if not target then
		return false, "hedef yok"
	end
	local character = Utilities.GetCharacter(target)
	if not character then
		return false, "karakter bulunamadi"
	end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			local ok = pcall(function()
				part.Size = part.Size * scale
			end)
			if not ok then
				return false, "olcek degistirilemedi"
			end
		end
	end
	LogActivity("Yerel olcek: " .. target.DisplayName)
	return true
end

function AdminTools.PlayAnimation(animationId)
	local character = CharacterController.GetCharacter()
	if not character then
		return false, "karakter yok"
	end
	local animator = character:FindFirstChildOfClass("Animator")
	if not animator then
		return false, "animator yok"
	end
	local ok, animation = pcall(function()
		local anim = Instance.new("Animation")
		anim.AnimationId = animationId
		return anim
	end)
	if not ok then
		return false, "animasyon olusturulamadi"
	end
	local played = pcall(function()
		animator:LoadAnimation(animation):Play()
	end)
	return played
end

function AdminTools.CollectSounds()
	AdminTools.SoundList = {}
	for _, instance in ipairs(Workspace:GetDescendants()) do
		if instance:IsA("Sound") and instance.IsPlaying then
			table.insert(AdminTools.SoundList, {
				Name = instance.Name,
				Volume = instance.Volume,
				Length = instance.TimeLength,
				Path = instance:GetFullName(),
			})
			if #AdminTools.SoundList >= 40 then
				break
			end
		end
	end
	return #AdminTools.SoundList
end

function AdminTools.SetLocalMute(enabled)
	SoundService.Volume = enabled and 0 or 1
	LogActivity(enabled and "Ses kapatildi" or "Ses acildi")
	return true
end

function AdminTools.GetDistanceRadar()
	local myRoot = CharacterController.GetRoot()
	if not myRoot then
		return {}
	end
	local list = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local root = Utilities.GetRootPart(Utilities.GetCharacter(player))
			if root then
				local distance = (root.Position - myRoot.Position).Magnitude
				table.insert(list, {
					Player = player,
					Distance = distance,
					Visible = Utilities.IsOnScreen(root.Position),
				})
			end
		end
	end
	table.sort(list, function(a, b)
		return a.Distance < b.Distance
	end)
	return list
end

function AdminTools.GetPlayerStatus(player)
	local character = Utilities.GetCharacter(player)
	if not character then
		return "Yok"
	end
	local humanoid = Utilities.GetHumanoid(character)
	local root = Utilities.GetRootPart(character)
	local status = "Duruyor"
	if humanoid then
		if humanoid.Sit then
			status = "Oturuyor"
		elseif humanoid:GetState() == Enum.HumanoidStateType.Jumping then
			status = "Zipliyor"
		elseif humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
			status = "Dusuyor"
		elseif root and root.AssemblyLinearVelocity.Magnitude > 2 then
			status = "Hareketli"
		end
		if humanoid.Health <= 0 then
			status = "Oldu"
		end
	end
	return status
end

function AdminTools.Update()
	-- Yerel dondurma loopu (sadece ekranda)
	if AdminTools.FrozenTarget and AdminTools.FrozenTarget.Parent then
		if AdminTools.FrozenOriginal then
			AdminTools.FrozenTarget.CFrame = AdminTools.FrozenOriginal
		end
	else
		AdminTools.FrozenTarget = nil
		AdminTools.FrozenOriginal = nil
	end
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 6: SOHBET / SOSYAL SİSTEM
-- ──────────────────────────────────────────────────────────────────────────

local ChatSystem = {}
ChatSystem.Log = {}
ChatSystem.Whispers = {}
ChatSystem.Macros = {
	{ Label = "Selam", Text = "Merhaba!" },
	{ Label = "Nerede?", Text = "Neredesin?" },
	{ Label = "Bekle", Text = "Bir saniye bekliyorum." },
	{ Label = "Gorusuruz", Text = "Gorusuruz!" },
	{ Label = "Teşekkür", Text = "Tesekkurler!" },
	{ Label = "-yardim", Text = "Bana yardim eder misin?" },
}
ChatSystem.SpamFilter = false
ChatSystem.SpamMaxRepeat = Config.Social.SpamMaxRepeat
ChatSystem.LocalSilence = false
ChatSystem.BlockList = {}
ChatSystem.PinnedMessages = {}
ChatSystem.QuickReplies = {}
ChatSystem.ChatRoles = {}
ChatSystem.AutoStatus = false
ChatSystem.AutoStatusText = "Hayalperde oynuyorum."
ChatSystem.AutoStatusInterval = 120
ChatSystem._lastStatus = 0
ChatSystem._recentMessages = {}
ChatSystem._translationDictionary = {
	["hello"] = "merhaba",
	["hi"] = "selam",
	["goodbye"] = "gorusuruz",
	["thanks"] = "tesekkurler",
	["yes"] = "evet",
	["no"] = "hayir",
}

function ChatSystem.AddLog(player, message, kind)
	local entry = {
		Player = player,
		Name = player and player.DisplayName or "Sistem",
		Text = tostring(message),
		Kind = kind or "chat",
		Time = os.clock(),
	}
	table.insert(ChatSystem.Log, entry)
	if #ChatSystem.Log > Config.Social.ChatLogMax then
		table.remove(ChatSystem.Log, 1)
	end
	_stateInstance:Set("ChatLogCount", #ChatSystem.Log)
	return entry
end

function ChatSystem.IsSpam(player, message)
	local now = os.clock()
	for i = #ChatSystem._recentMessages, 1, -1 do
		local recent = ChatSystem._recentMessages[i]
		if now - recent.Time > Config.Social.SpamWindow then
			table.remove(ChatSystem._recentMessages, i)
		elseif recent.Player == player and recent.Text == message then
			recent.Count = recent.Count + 1
			return recent.Count > ChatSystem.SpamMaxRepeat
		end
	end
	table.insert(ChatSystem._recentMessages, {
		Player = player,
		Text = message,
		Time = now,
		Count = 1,
	})
	return false
end

function ChatSystem.Send(text)
	if type(text) ~= "string" or text == "" then
		return false, "bos mesaj"
	end
	-- Yeni sohbet sistemi
	if TextChatService then
		local ok = pcall(function()
			local channel = TextChatService.TextChannels and TextChatService.TextChannels["RBXGeneral"]
			if channel then
				channel:SendAsync(text)
				return
			end
		end)
		if ok then
			ChatSystem.AddLog(LocalPlayer, text, "sent")
			return true
		end
	end
	-- Eski sohbet sistemi / engine yardimcisi
	local ok2 = pcall(function()
		StarterGui:SetCore("ChatSend", { Text = text })
	end)
	if ok2 then
		ChatSystem.AddLog(LocalPlayer, text, "sent")
		return true
	end
	return false, "mesaj gonderilemedi"
end

function ChatSystem.SystemMessage(text)
	if TextChatService then
		local ok = pcall(function()
			local channel = TextChatService.TextChannels and TextChatService.TextChannels["RBXGeneral"]
			if channel then
				channel:DisplaySystemMessage(text)
				return
			end
		end)
		if ok then
			return true
		end
	end
	local ok2 = pcall(function()
		StarterGui:SetCore("ChatMakeSystemMessage", { Text = text })
	end)
	return ok2
end

function ChatSystem.Translate(text)
	if type(text) ~= "string" then
		return text
	end
	local result = text
	for english, turkish in pairs(ChatSystem._translationDictionary) do
		result = string.lower(result):gsub(english, turkish)
	end
	return result
end

function ChatSystem.ScheduleMessage(text, delaySeconds)
	TaskManager:Delay(delaySeconds, function()
		local ok = ChatSystem.Send(text)
		if ok then
			ChatSystem.SystemMessage("[X52] Zamanlanmis mesaj gonderildi: " .. text)
		end
	end)
	return true
end

function ChatSystem.ExportLog()
	local lines = {}
	for _, entry in ipairs(ChatSystem.Log) do
		table.insert(lines, string.format("[%s] %s: %s", Utilities.FormatClock(entry.Time), entry.Name, entry.Text))
	end
	local text = table.concat(lines, "\n")
	local ok = pcall(function()
		writefile("x52_chat_log.txt", text)
	end)
	return text, ok
end

function ChatSystem.AddMacro(label, text)
	table.insert(ChatSystem.Macros, { Label = label, Text = text })
	if #ChatSystem.Macros > Config.Command.MaxMacros then
		table.remove(ChatSystem.Macros, 1)
	end
	return true
end

function ChatSystem.RemoveMacro(index)
	if ChatSystem.Macros[index] then
		table.remove(ChatSystem.Macros, index)
		return true
	end
	return false
end

function ChatSystem.Update()
	if ChatSystem.AutoStatus and os.clock() - ChatSystem._lastStatus > ChatSystem.AutoStatusInterval then
		ChatSystem._lastStatus = os.clock()
		pcall(function()
			ChatSystem.Send(ChatSystem.AutoStatusText)
		end)
	end
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 7: ERİŞİLEBİLİRLİK (10 özellik, tamamı ayarlanabilir)
-- ──────────────────────────────────────────────────────────────────────────

local Accessibility = {}
Accessibility.Enabled = {
	HighContrast = false,
	ColorBlind = false,
	OneHand = false,
	HoldMode = false,
	TTS = false,
	CustomCursor = false,
	Swipe = false,
	Haptics = false,
	KeyboardNav = false,
}
Accessibility.Deadzone = Config.Accessibility.JoystickDeadzone
Accessibility.CursorSize = 18
Accessibility.CursorColor = Theme.AccentBright
Accessibility.SwipeActions = {}
Accessibility._cursor = nil
Accessibility._tts = nil
Accessibility._ttsOutput = nil
Accessibility._wire = nil
Accessibility._focusIndex = 1
Accessibility._focusables = {}

local COLOR_BLIND_PALETTE = {
	Accent = Color3.fromRGB(0, 114, 178),
	AccentDark = Color3.fromRGB(0, 78, 122),
	AccentBright = Color3.fromRGB(86, 180, 233),
	Background = Color3.fromRGB(12, 14, 18),
	Surface = Color3.fromRGB(22, 25, 30),
	TextPrimary = Color3.fromRGB(245, 245, 245),
	TextSecondary = Color3.fromRGB(170, 175, 180),
}

local HIGH_CONTRAST_PALETTE = {
	Accent = Color3.fromRGB(255, 255, 0),
	AccentDark = Color3.fromRGB(180, 180, 0),
	AccentBright = Color3.fromRGB(255, 255, 120),
	Background = Color3.fromRGB(0, 0, 0),
	Surface = Color3.fromRGB(16, 16, 16),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(220, 220, 220),
}

function Accessibility.ApplyPalette()
	local palette = Theme.Palette
	if palette == "ColorBlind" then
		for key, value in pairs(COLOR_BLIND_PALETTE) do
			Theme[key] = value
		end
	elseif palette == "HighContrast" then
		for key, value in pairs(HIGH_CONTRAST_PALETTE) do
			Theme[key] = value
		end
	else
		Theme.Accent = Config.Theme.Accent
		Theme.AccentDark = Config.Theme.AccentDark
		Theme.AccentBright = Config.Theme.AccentBright
		Theme.Background = Config.Theme.Background
		Theme.Surface = Config.Theme.Surface
		Theme.TextPrimary = Config.Theme.TextPrimary
		Theme.TextSecondary = Config.Theme.TextSecondary
	end
	_stateInstance:Set("ThemeChanged", true)
end

function Accessibility.SetOneHand(enabled)
	Accessibility.Enabled.OneHand = enabled
	Config.Menu.OneHand = enabled
	_stateInstance:Set("OneHandMode", enabled)
	return true
end

function Accessibility.SetHighContrast(enabled)
	Accessibility.Enabled.HighContrast = enabled
	Theme.HighContrast = enabled
	Theme.Palette = enabled and "HighContrast" or (Accessibility.Enabled.ColorBlind and "ColorBlind" or "Default")
	Accessibility.ApplyPalette()
	return true
end

function Accessibility.SetColorBlind(enabled)
	Accessibility.Enabled.ColorBlind = enabled
	Theme.ColorBlind = enabled
	Theme.Palette = enabled and "ColorBlind" or (Accessibility.Enabled.HighContrast and "HighContrast" or "Default")
	Accessibility.ApplyPalette()
	return true
end

function Accessibility.Speak(text)
	if type(text) ~= "string" or text == "" then
		return false
	end
	local clipped = string.sub(text, 1, Config.Accessibility.TTSMaxChars)
	local ok = pcall(function()
		if not Accessibility._tts or not Accessibility._tts.Parent then
			local device = Instance.new("AudioDeviceOutput")
			device.Name = "X52TTSOutput"
			device.Parent = SoundService

			local tts = Instance.new("AudioTextToSpeech")
			tts.Name = "X52TTS"
			tts.VoiceId = Config.Accessibility.TTSVoice
			tts.Volume = Config.Accessibility.TTSVolume
			tts.Parent = SoundService

			local wire = Instance.new("Wire")
			wire.SourceInstance = tts
			wire.TargetInstance = device
			wire.Parent = device

			Accessibility._tts = tts
			Accessibility._ttsOutput = device
			Accessibility._wire = wire
		end
		Accessibility._tts.Text = clipped
		Accessibility._tts:Play()
	end)
	return ok
end

function Accessibility.SetCustomCursor(enabled)
	Accessibility.Enabled.CustomCursor = enabled
	if enabled then
		if not Accessibility._cursor or not Accessibility._cursor.Parent then
			local cursor = Instance.new("Frame")
			cursor.Name = "X52Cursor"
			cursor.Size = UDim2.fromOffset(Accessibility.CursorSize, Accessibility.CursorSize)
			cursor.AnchorPoint = Vector2.new(0.5, 0.5)
			cursor.BackgroundTransparency = 1
			cursor.ZIndex = 900
			cursor.Parent = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("X52_CursorGui") or LocalPlayer:WaitForChild("PlayerGui")

			local dot = Instance.new("Frame")
			dot.Size = UDim2.fromOffset(Accessibility.CursorSize, Accessibility.CursorSize)
			dot.BackgroundColor3 = Accessibility.CursorColor
			dot.BackgroundTransparency = 0.25
			dot.BorderSizePixel = 0
			dot.Parent = cursor
			Utilities.Round_UI(dot, UDim.new(1, 0))

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.new(1, 1, 1)
			stroke.Thickness = 1.5
			stroke.Parent = dot

			Accessibility._cursor = cursor
		end
		Accessibility._cursor.Visible = true
		UserInputService.MouseIconEnabled = false
	else
		if Accessibility._cursor then
			Accessibility._cursor.Visible = false
		end
		UserInputService.MouseIconEnabled = true
	end
	return true
end

function Accessibility.SetHaptics(enabled)
	Accessibility.Enabled.Haptics = enabled
	return true
end

function Accessibility.Haptic(kind)
	if not Accessibility.Enabled.Haptics then
		return false
	end
	local ok = pcall(function()
		local effect = Instance.new("HapticEffect")
		effect.Type = Enum.HapticEffectType[(kind or Config.Accessibility.HapticType)] or Enum.HapticEffectType.UIClick
		effect.Parent = Workspace
		effect:Play()
		Debris:AddItem(effect, 1)
	end)
	return ok
end

function Accessibility.SetDeadzone(value)
	Accessibility.Deadzone = Utilities.Clamp(value, 0, 0.9)
	return Accessibility.Deadzone
end

function Accessibility.RegisterSwipe(action, direction)
	table.insert(Accessibility.SwipeActions, { Action = action, Direction = direction })
	return true
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 8: ANALİTİK VE WIDGET SİSTEMİ
-- ──────────────────────────────────────────────────────────────────────────

Analytics = {}
Analytics.FPS = 0
Analytics.Ping = 0
Analytics.FrameTime = 0
Analytics.TickRate = 0
Analytics.PlayTime = 0
Analytics.JoinTime = os.clock()
Analytics._frames = 0
Analytics._framesWindow = 0
Analytics._lastMeasure = os.clock()
Analytics._tickSamples = {}
Analytics._lastTickSample = os.clock()
Analytics._tickCount = 0
Analytics.Graph = { FPS = {}, Ping = {} }
Analytics.Widgets = {}
Analytics._gui = nil

function Analytics.GetFPS()
	local frameTime = Stats.FrameTime
	if type(frameTime) == "number" and frameTime > 0 then
		return math.floor(1 / frameTime)
	end
	return Analytics.FPS
end

function Analytics.GetPing()
	return Utilities.GetPing(LocalPlayer)
end

function Analytics.GetTickRate()
	return Analytics.TickRate
end

function Analytics.GetMemory()
	local values = {}
	local ok, instances = pcall(function()
		return Stats.InstanceCount
	end)
	if ok and type(instances) == "number" then
		table.insert(values, "Instance: " .. Utilities.FormatNumber(instances))
	end
	local ok2, mb = pcall(function()
		return Stats:GetTotalMemoryUsageMb()
	end)
	if ok2 and type(mb) == "number" and mb > 0 then
		table.insert(values, "Bellek: " .. string.format("%.1f MB", mb))
	end
	local ok3, gcCount = pcall(function()
		return collectgarbage("count")
	end)
	if ok3 and type(gcCount) == "number" then
		table.insert(values, "Lua: " .. string.format("%.2f MB", gcCount / 1024))
	end
	if #values == 0 then
		table.insert(values, "Bellek: N/A")
	end
	return table.concat(values, "  |  ")
end

function Analytics.GetServerInfo()
	local pieces = {}
	table.insert(pieces, "Place: " .. tostring(game.PlaceId))
	table.insert(pieces, "Job: " .. string.sub(tostring(game.JobId), 1, 8))
	local locale = "N/A"
	pcall(function()
		locale = LocalizationService.RobloxLocaleId
	end)
	table.insert(pieces, "Locale: " .. tostring(locale))
	table.insert(pieces, "Studio: " .. tostring(RunService:IsStudio()))
	return table.concat(pieces, "  |  ")
end

function Analytics.GetRobloxVersion()
	local candidates = { "VersionService", "Settings", "RuntimeService" }
	for _, serviceName in ipairs(candidates) do
		local ok, service = pcall(function()
			return game:GetService(serviceName)
		end)
		if ok and service then
			local version = nil
			pcall(function()
				version = service.Version
			end)
			if not version then
				pcall(function()
					version = service.RobloxVersion
				end)
			end
			if type(version) == "string" and version ~= "" then
				return serviceName .. ": " .. version
			end
		end
	end
	return "istemci surumu API'si yok (N/A)"
end

function Analytics.GetRegion()
	local region = "N/A"
	pcall(function()
		local country = LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
		if country and country ~= "" then
			region = tostring(country)
		end
	end)
	return region
end

function Analytics.TestLatency()
	local startTime = os.clock()
	local ok = pcall(function()
		HttpService:RequestAsync({
			Url = "https://www.roblox.com/",
			Method = "GET",
		})
	end)
	local elapsed = (os.clock() - startTime) * 1000
	if ok then
		return string.format("%.0f ms (HTTP)", elapsed)
	end
	return "N/A (HTTPS kapali olabilir)"
end

function Analytics.PushGraphSample()
	table.insert(Analytics.Graph.FPS, Analytics.GetFPS())
	if #Analytics.Graph.FPS > Config.Analytics.GraphSamples then
		table.remove(Analytics.Graph.FPS, 1)
	end
	table.insert(Analytics.Graph.Ping, Analytics.GetPing())
	if #Analytics.Graph.Ping > Config.Analytics.GraphSamples then
		table.remove(Analytics.Graph.Ping, 1)
	end
end

function Analytics.Update(dt)
	Analytics._frames = Analytics._frames + 1
	Analytics._framesWindow = Analytics._framesWindow + 1
	Analytics._tickCount = Analytics._tickCount + 1
	Analytics.PlayTime = os.clock() - Analytics.JoinTime

	local now = os.clock()
	if now - Analytics._lastMeasure >= Config.Analytics.RefreshRate then
		Analytics.FPS = math.floor(Analytics._framesWindow / (now - Analytics._lastMeasure))
		Analytics._framesWindow = 0
		Analytics._lastMeasure = now
		Analytics.Ping = Analytics.GetPing()
		Analytics.FrameTime = Stats.FrameTime or 0
		Analytics.PushGraphSample()
	end

	if now - Analytics._lastTickSample >= Config.Analytics.TickSampleTime then
		local elapsed = now - Analytics._lastTickSample
		Analytics.TickRate = math.floor(Analytics._tickCount / elapsed)
		Analytics._tickCount = 0
		Analytics._lastTickSample = now
	end
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 9: KOMUT SİSTEMİ (! sohbet prefix + ; sessiz panel prefix)
-- ──────────────────────────────────────────────────────────────────────────

local CommandSystem = {}
CommandSystem.Commands = {}
CommandSystem.History = {}
CommandSystem.HistoryIndex = 0
CommandSystem._initialized = false
CommandSystem.OnResult = nil

local function reply(text, kind)
	if CommandSystem.OnResult then
		Utilities.SafeCall(CommandSystem.OnResult, text, kind)
	else
		ChatSystem.SystemMessage(text)
	end
end

function CommandSystem.Register(name, definition)
	CommandSystem.Commands[string.lower(name)] = definition
end

function CommandSystem.Get(name)
	return CommandSystem.Commands[string.lower(name)]
end

function CommandSystem.List()
	local names = {}
	for name in pairs(CommandSystem.Commands) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function CommandSystem.AddHistory(text)
	table.insert(CommandSystem.History, text)
	if #CommandSystem.History > Config.Command.MaxHistory then
		table.remove(CommandSystem.History, 1)
	end
	CommandSystem.HistoryIndex = #CommandSystem.History
end

function CommandSystem.Run(rawText, source)
	if type(rawText) ~= "string" then
		return false, "gecersiz komut"
	end
	local text = Utilities.Trim(rawText)
	if text == "" then
		return false, "bos komut"
	end

	local prefix = Config.Command.ChatPrefix
	local body = text
	if text:sub(1, 1) == prefix or text:sub(1, 1) == Config.Command.ConsolePrefix then
		body = text:sub(2)
	end
	body = Utilities.Trim(body)
	if body == "" then
		return false, "bos komut"
	end

	local parts = Utilities.Split(body, " ")
	local name = string.lower(parts[1] or "")
	local args = {}
	for i = 2, #parts do
		table.insert(args, parts[i])
	end
	local argString = table.concat(args, " ")

	local command = CommandSystem.Commands[name]
	if not command then
		reply("Bilinmeyen komut: " .. name .. "  (!help)", "Error")
		return false, "bilinmeyen komut"
	end

	CommandSystem.AddHistory(text)
	local ok, result = pcall(function()
		return command.Handler(args, argString, source)
	end)
	if not ok then
		reply("Komut hatasi: " .. tostring(result), "Error")
		return false, tostring(result)
	end
	return true, result
end

function CommandSystem.Init()
	if CommandSystem._initialized then
		return
	end
	CommandSystem._initialized = true

	-- ! prefix: sohbet komutlari
	TaskManager:Connect(LocalPlayer.Chatted, function(message)
		if type(message) ~= "string" then
			return
		end
		local first = message:sub(1, 1)
		if first == Config.Command.ChatPrefix then
			CommandSystem.Run(message, "chat")
		end
	end)
end

-- ── Komut kayıtları (hepsi gerçek davranışa bağlı) ───────────────────────

CommandSystem.Register("help", {
	Usage = "!help",
	Description = "Tum komutlari listeler",
	Handler = function()
		local names = CommandSystem.List()
		local lines = {}
		for i = 1, #names, 6 do
			local chunk = {}
			for j = i, math.min(i + 5, #names) do
				table.insert(chunk, names[j])
			end
			table.insert(lines, table.concat(chunk, ", "))
		end
		reply("X52 komutlari (" .. #names .. "):\n" .. table.concat(lines, "\n"))
		return true
	end,
})

CommandSystem.Register("menu", {
	Usage = "!menu",
	Description = "Menuyu acar / kapatir",
	Handler = function()
		local open = not _stateInstance:Get("MenuOpen")
		_stateInstance:Set("MenuOpen", open)
		if open and MainApp and AppInstance.Window then
			AppInstance.Window:SetVisible(true)
		end
		reply("Menu " .. (open and "acildi" or "kapatildi"))
		return true
	end,
})

CommandSystem.Register("fly", {
	Usage = "!fly",
	Description = "Karaktere uçuşu açar",
	Handler = function()
		local ok = CharacterController.SetFly(true)
		reply(ok and "Ucus aktif" or "Karakter bulunamadi")
		return ok
	end,
})

CommandSystem.Register("nofly", {
	Usage = "!nofly",
	Description = "Uçuşu kapatir",
	Handler = function()
		CharacterController.SetFly(false)
		reply("Ucus kapatildi")
		return true
	end,
})

CommandSystem.Register("noclip", {
	Usage = "!noclip",
	Description = "Duvardan gecmeyi açar/kapatır",
	Handler = function()
		local enabled = not CharacterController.Noclip
		CharacterController.SetNoclip(enabled)
		reply("Noclip " .. (enabled and "acik" or "kapali"))
		return true
	end,
})

CommandSystem.Register("speed", {
	Usage = "!speed <deger>",
	Description = "Yürüme hızını değiştirir",
	Handler = function(args)
		local value = tonumber(args[1])
		if not value then
			return false, "gecerli bir sayi gir"
		end
		local humanoid = Utilities.GetHumanoid(CharacterController.GetCharacter())
		if not humanoid then
			return false, "karakter yok"
		end
		humanoid.WalkSpeed = Utilities.Clamp(value, 0, 500)
		reply("Yuruş hizi: " .. humanoid.WalkSpeed)
		return true
	end,
})

CommandSystem.Register("fov", {
	Usage = "!fov <deger>",
	Description = "Kamera gorus acisini degistirir",
	Handler = function(args)
		local value = tonumber(args[1])
		if not value then
			return false, "gecerli bir sayi gir"
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			return false, "kamera yok"
		end
		camera.FieldOfView = Utilities.Clamp(value, 30, 120)
		reply("FOV: " .. camera.FieldOfView)
		return true
	end,
})

CommandSystem.Register("fling", {
	Usage = "!fling [isim]",
	Description = "Hedefi firlatir",
	Handler = function(args)
		local target = args[1] and Utilities.FindPlayer(args[1]) or AdminTools.GetTarget()
		if not target then
			return false, "hedef bulunamadi"
		end
		local root = Utilities.GetRootPart(Utilities.GetCharacter(target))
		if not root then
			return false, "hedef karaktersiz"
		end
		local ok, method = PhysicsEngine.ApplyImpulse(root, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
		reply("Fling: " .. target.DisplayName .. " (" .. tostring(method) .. ")")
		return ok
	end,
})

CommandSystem.Register("flingall", {
	Usage = "!flingall",
	Description = "Menzildeki tum oyunculari firlatir",
	Handler = function()
		local root = CharacterController.GetRoot()
		if not root then
			return false, "karakter yok"
		end
		local count = 0
		for _, player in ipairs(PhysicsEngine.GetPlayersInRadius(Config.Physics.MultiFlingRange, root.Position)) do
			local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(player))
			if targetRoot then
				PhysicsEngine.ApplyImpulse(targetRoot, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
				count = count + 1
			end
		end
		reply("Multi fling: " .. count .. " oyuncu")
		return true
	end,
})

CommandSystem.Register("tp", {
	Usage = "!tp <isim>",
	Description = "Hedefin yanina isinlanir",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		AdminTools.SetTarget(player)
		local ok = AdminTools.TeleportToTarget()
		reply(ok and ("Teleport: " .. player.DisplayName) or "Teleport basarisiz")
		return ok
	end,
})

CommandSystem.Register("bring", {
	Usage = "!bring <isim>",
	Description = "Hedefi yanina ceker (yerel illuzyon)",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		AdminTools.SetTarget(player)
		local ok = AdminTools.BringTarget()
		reply(ok and ("Bring: " .. player.DisplayName) or "Bring basarisiz")
		return ok
	end,
})

CommandSystem.Register("spectate", {
	Usage = "!spectate <isim|off>",
	Description = "Oyuncuyu izlemeye alir",
	Handler = function(args)
		if not args[1] or args[1] == "off" then
			CameraController.Unspectate()
			reply("Izleme bitti")
			return true
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		local ok = CameraController.Spectate(player)
		reply(ok and ("Izlenecek: " .. player.DisplayName) or "Izlenecek oyuncu yok")
		return ok
	end,
})

CommandSystem.Register("freeze", {
	Usage = "!freeze <isim|off>",
	Description = "Hedefi yerel olarak dondurur",
	Handler = function(args)
		if not args[1] or args[1] == "off" then
			AdminTools.FreezeTarget(false)
			reply("Dondurma kaldirildi")
			return true
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		AdminTools.SetTarget(player)
		local ok = AdminTools.FreezeTarget(true)
		reply(ok and ("Donduruldu: " .. player.DisplayName) or "Dondurma basarisiz")
		return ok
	end,
})

CommandSystem.Register("spy", {
	Usage = "!spy",
	Description = "Sohbet casus penceresini acar",
	Handler = function()
		if AppInstance and AppInstance.ChatWindow then
			AppInstance.ChatWindow:SetVisible(true)
			reply("Sohbet casusu aktif")
			return true
		end
		return false, "penceresiz"
	end,
})

CommandSystem.Register("players", {
	Usage = "!players",
	Description = "Sunucudaki oyunculari listeler",
	Handler = function()
		local lines = {}
		for _, player in ipairs(Players:GetPlayers()) do
			table.insert(lines, string.format("%s (#%d) ping=%d", player.DisplayName, player.UserId, Utilities.GetPing(player)))
		end
		reply("Oyuncular (" .. #lines .. "):\n" .. table.concat(lines, "\n"))
		return true
	end,
})

CommandSystem.Register("ping", {
	Usage = "!ping",
	Description = "Gecikme bilgisini gosterir",
	Handler = function()
		reply("Ping: " .. tostring(Analytics.GetPing()) .. " ms")
		return true
	end,
})

CommandSystem.Register("fps", {
	Usage = "!fps",
	Description = "Kare hizini gosterir",
	Handler = function()
		reply("FPS: " .. tostring(Analytics.GetFPS()) .. "  |  Frame: " .. string.format("%.1f ms", (Analytics.FrameTime or 0) * 1000))
		return true
	end,
})

CommandSystem.Register("time", {
	Usage = "!time",
	Description = "Gercek zamanli saati gosterir",
	Handler = function()
		reply("Saat: " .. Utilities.GetDateClock(EnvironmentController.GetTime()))
		return true
	end,
})

CommandSystem.Register("widget", {
	Usage = "!widget <fps|ping|time|profiler>",
	Description = "Widget goster/gizle",
	Handler = function(args)
		if not args[1] then
			return false, "fps|ping|time|profiler"
		end
		if AppInstance and AppInstance.Widgets then
			local ok = AppInstance.Widgets.Toggle(args[1])
			reply("Widget " .. args[1] .. ": " .. (ok and "acik" or "kapali"))
			return true
		end
		return false, "widget sistemi yok"
	end,
})

CommandSystem.Register("msg", {
	Usage = "!msg <metin>",
	Description = "Sistem mesaji gonderir",
	Handler = function(args, argString)
		if argString == "" then
			return false, "metin gerekli"
		end
		ChatSystem.SystemMessage(argString)
		return true
	end,
})

CommandSystem.Register("macro", {
	Usage = "!macro <numara>",
	Description = "Hazir mesaj sablonunu gonderir",
	Handler = function(args)
		local index = tonumber(args[1])
		if not index then
			local names = {}
			for i, macro in ipairs(ChatSystem.Macros) do
				table.insert(names, i .. ") " .. macro.Label)
			end
			reply("Makrolar:\n" .. table.concat(names, "\n"))
			return true
		end
		local macro = ChatSystem.Macros[index]
		if not macro then
			return false, "boyle bir makro yok"
		end
		ChatSystem.Send(macro.Text)
		reply("Makro gonderildi: " .. macro.Text)
		return true
	end,
})

CommandSystem.Register("whisper", {
	Usage = "!whisper <isim> <metin>",
	Description = "Oyuncuya fısıltı gönderir ve kaydeder",
	Handler = function(args, argString)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		local message = argString:sub(#args[1] + 2)
		table.insert(ChatSystem.Whispers, {
			Target = player.DisplayName,
			Text = message,
			Time = os.clock(),
		})
		if #ChatSystem.Whispers > Config.Social.WhisperMax then
			table.remove(ChatSystem.Whispers, 1)
		end
		ChatSystem.Send("@" .. player.DisplayName .. " " .. message)
		reply("Fisilti kaydedildi -> " .. player.DisplayName)
		return true
	end,
})

CommandSystem.Register("mute", {
	Usage = "!mute <isim>",
	Description = "Oyuncuyu yerel olarak susturur",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		AdminTools.SetTarget(player)
		AdminTools.MuteTarget(true)
		reply("Susturuldu: " .. player.DisplayName)
		return true
	end,
})

CommandSystem.Register("unmute", {
	Usage = "!unmute <isim>",
	Description = "Yerel susturmayi kaldirir",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		AdminTools.SetTarget(player)
		AdminTools.MuteTarget(false)
		reply("Susturma kaldirildi: " .. player.DisplayName)
		return true
	end,
})

CommandSystem.Register("block", {
	Usage = "!block <isim>",
	Description = "Oyuncuyu yerel engel listesine ekler",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		ChatSystem.BlockList[player.UserId] = true
		reply("Engel listesine eklendi: " .. player.DisplayName)
		return true
	end,
})

CommandSystem.Register("unblock", {
	Usage = "!unblock <isim>",
	Description = "Engel listesinden cikarir",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		ChatSystem.BlockList[player.UserId] = nil
		reply("Engel listesinden cikarildi: " .. player.DisplayName)
		return true
	end,
})

CommandSystem.Register("light", {
	Usage = "!light <on|off>",
	Description = "Yerel isigi açar/kapatır",
	Handler = function(args)
		local enabled = (args[1] or "on") ~= "off"
		EnvironmentController.SetLocalLight(enabled)
		reply("Yerel isik " .. (enabled and "acik" or "kapali"))
		return true
	end,
})

CommandSystem.Register("fog", {
	Usage = "!fog <on|off>",
	Description = "Yerel sisi açar/kapatır",
	Handler = function(args)
		local enabled = (args[1] or "on") ~= "off"
		EnvironmentController.SetFog(enabled, 300)
		reply("Yerel sis " .. (enabled and "acik" or "kapali"))
		return true
	end,
})

CommandSystem.Register("gravity", {
	Usage = "!gravity <deger>",
	Description = "Yerel yercekimini degistirir",
	Handler = function(args)
		local value = tonumber(args[1])
		if not value then
			reply("Yercekimi: " .. tostring(Workspace.Gravity))
			return true
		end
		EnvironmentController.SetGravity(value)
		reply("Yercekimi: " .. tostring(Workspace.Gravity))
		return true
	end,
})

CommandSystem.Register("cam", {
	Usage = "!cam <classic|fp|scriptable>",
	Description = "Kamera modunu zorlar",
	Handler = function(args)
		local mode = args[1] or "classic"
		local map = { classic = "Classic", fp = "LockFirstPerson", scriptable = "Scriptable" }
		local resolved = map[string.lower(mode)]
		if not resolved then
			return false, "classic|fp|scriptable"
		end
		CameraController.SetForceMode(resolved)
		reply("Kamera modu: " .. resolved)
		return true
	end,
})

CommandSystem.Register("tts", {
	Usage = "!tts <metin>",
	Description = "Metni sesli okur",
	Handler = function(args, argString)
		if argString == "" then
			return false, "metin gerekli"
		end
		local ok = Accessibility.Speak(argString)
		reply(ok and "TTS baslatildi" or "TTS kullanilamiyor (istemci destegi)")
		return ok
	end,
})

CommandSystem.Register("translate", {
	Usage = "!translate <metin>",
	Description = "Yerel sozluk ile cevirir",
	Handler = function(args, argString)
		if argString == "" then
			return false, "metin gerekli"
		end
		reply("Ceviri: " .. ChatSystem.Translate(argString))
		return true
	end,
})

CommandSystem.Register("reset", {
	Usage = "!reset",
	Description = "Tum aktif ozellikleri sifirlar",
	Handler = function()
		CharacterController.SetFly(false)
		CharacterController.SetNoclip(false)
		CharacterController.SetFrozen(false)
		VehicleController.SetFly(false)
		VehicleController.SetNoclip(false)
		WaypointController.Stop()
		TrackController.Stop()
		CameraController.Unspectate()
		CameraController.SetForceMode(nil)
		AdminTools.FreezeTarget(false)
		reply("Tum ozellikler sifirlandi")
		return true
	end,
})

CommandSystem.Register("clear", {
	Usage = "!clear",
	Description = "Sohbet logunu temizler",
	Handler = function()
		table.clear(ChatSystem.Log)
		_stateInstance:Set("ChatLogCount", 0)
		reply("Sohbet logu temizlendi")
		return true
	end,
})

CommandSystem.Register("theme", {
	Usage = "!theme <default|colorblind|contrast>",
	Description = "Temayi degistirir",
	Handler = function(args)
		local palette = string.lower(args[1] or "default")
		if palette == "colorblind" then
			Accessibility.SetColorBlind(true)
			Accessibility.SetHighContrast(false)
		elseif palette == "contrast" then
			Accessibility.SetHighContrast(true)
			Accessibility.SetColorBlind(false)
		else
			Accessibility.SetHighContrast(false)
			Accessibility.SetColorBlind(false)
		end
		reply("Tema: " .. palette)
		return true
	end,
})

CommandSystem.Register("waypoint", {
	Usage = "!waypoint <x> <y> <z> <x2> <y2> <z2>",
	Description = "Iki nokta arasinda gidip gelir",
	Handler = function(args)
		if #args < 6 then
			return false, "6 koordinat gerekli"
		end
		local a = Vector3.new(tonumber(args[1]) or 0, tonumber(args[2]) or 0, tonumber(args[3]) or 0)
		local b = Vector3.new(tonumber(args[4]) or 0, tonumber(args[5]) or 0, tonumber(args[6]) or 0)
		WaypointController.SetWaypoints(a, b)
		local ok = WaypointController.Start()
		reply(ok and "Waypoint basladi" or "Waypoint baslatilamadi")
		return ok
	end,
})

CommandSystem.Register("track", {
	Usage = "!track <isim>",
	Description = "Hedefi takip edip firlatir",
	Handler = function(args)
		if not args[1] then
			return false, "isim gerekli"
		end
		local player = Utilities.FindPlayer(args[1])
		if not player then
			return false, "oyuncu bulunamadi"
		end
		TrackController.AddTarget(player)
		local ok = TrackController.Start()
		reply(ok and ("Takip: " .. player.DisplayName) or "Takip baslatilamadi")
		return ok
	end,
})

CommandSystem.Register("untrack", {
	Usage = "!untrack",
	Description = "Takibi durdurur",
	Handler = function()
		TrackController.Stop()
		TrackController.Clear()
		reply("Takip durduruldu")
		return true
	end,
})

CommandSystem.Register("stop", {
	Usage = "!stop",
	Description = "Tum hareketleri durdurur",
	Handler = function()
		CharacterController.SetFly(false)
		VehicleController.SetFly(false)
		WaypointController.Stop()
		TrackController.Stop()
		VehicleController.SetInput(Vector3.zero)
		reply("Hareketler durduruldu")
		return true
	end,
})

CommandSystem.Register("size", {
	Usage = "!size <carpan>",
	Description = "Hedefin boyutunu yerel olarak degistirir",
	Handler = function(args)
		local value = tonumber(args[1])
		if not value then
			return false, "carpan gerekli"
		end
		local ok = AdminTools.ScaleAvatar(Utilities.Clamp(value, 0.3, 3))
		reply(ok and "Boyut degistirildi" or "Olcek degistirilemedi")
		return ok
	end,
})

CommandSystem.Register("clone", {
	Usage = "!clone",
	Description = "Hedefin avatarini yerel olarak klonlar",
	Handler = function()
		local ok = AdminTools.CloneAvatar()
		reply(ok and "Avatar klonlandi" or "Klonlanamadi")
		return ok
	end,
})

CommandSystem.Register("radar", {
	Usage = "!radar",
	Description = "Mesafe radarini gosterir",
	Handler = function()
		local list = AdminTools.GetDistanceRadar()
		local lines = {}
		for i = 1, math.min(8, #list) do
			local entry = list[i]
			table.insert(lines, string.format("%s - %.1f stud%s", entry.Player.DisplayName, entry.Distance, entry.Visible and "" or " (gorunmuyor)"))
		end
		reply("Radar:\n" .. table.concat(lines, "\n"))
		return true
	end,
})

CommandSystem.Register("sounds", {
	Usage = "!sounds",
	Description = "Calan sesleri listeler",
	Handler = function()
		local count = AdminTools.CollectSounds()
		reply("Calan ses sayisi: " .. count)
		return true
	end,
})

CommandSystem.Register("status", {
	Usage = "!status <isim>",
	Description = "Oyuncunun durumunu gosterir",
	Handler = function(args)
		local player = args[1] and Utilities.FindPlayer(args[1]) or AdminTools.GetTarget()
		if not player then
			return false, "hedef yok"
		end
		reply(player.DisplayName .. ": " .. AdminTools.GetPlayerStatus(player))
		return true
	end,
})

CommandSystem.Register("nametag", {
	Usage = "!nametag <metin>",
	Description = "Hedefin isim etiketini degistirir",
	Handler = function(args, argString)
		local target = AdminTools.GetTarget()
		if not target then
			return false, "hedef yok"
		end
		local ok = AdminTools.SetNameTag(target, argString)
		reply(ok and "Isim etiketi guncellendi" or "Isim etiketi degistirilemedi")
		return ok
	end,
})

CommandSystem.Register("highlight", {
	Usage = "!highlight <on|off>",
	Description = "Hedefi isaretler",
	Handler = function(args)
		local enabled = (args[1] or "on") ~= "off"
		local ok = AdminTools.HighlightTarget(enabled)
		reply(ok and "Isaret guncellendi" or "Isaretlenemedi")
		return ok
	end,
})

CommandSystem.Register("inspect", {
	Usage = "!inspect",
	Description = "Hedef oyuncunun detay bilgisini acar",
	Handler = function()
		if AppInstance and AppInstance.Inspector then
			AppInstance.Inspector:SetVisible(true)
			reply("Inspector acildi")
			return true
		end
		return false, "penceresiz"
	end,
})

CommandSystem.Register("export", {
	Usage = "!export",
	Description = "Sohbet logunu dosyaya yazar",
	Handler = function()
		local text, ok = ChatSystem.ExportLog()
		reply(ok and "Sohbet logu dosyaya yazildi" or ("Log hazir (" .. #text .. " karakter) - dosya yazilamadi"))
		return true
	end,
})

CommandSystem.Register("exit", {
	Usage = "!exit",
	Description = "Menuyu kapatir",
	Handler = function()
		_stateInstance:Set("MenuOpen", false)
		if AppInstance and AppInstance.Window then
			AppInstance.Window:SetVisible(false)
		end
		reply("Menu kapatildi")
		return true
	end,
})

CommandSystem.Register("toggle", {
	Usage = "!toggle <panel>",
	Description = "Panel açar/kapatır (console|widgets|fly|spy)",
	Handler = function(args)
		local panel = string.lower(args[1] or "")
		if AppInstance then
			if panel == "console" and AppInstance.CommandPanel then
				AppInstance.CommandPanel:Toggle()
			elseif panel == "widgets" and AppInstance.Widgets then
				AppInstance.Widgets.ToggleAll()
			elseif panel == "fly" and AppInstance.FlyPanel then
				AppInstance.FlyPanel:Toggle()
			elseif panel == "spy" and AppInstance.ChatWindow then
				AppInstance.ChatWindow:Toggle()
			else
				return false, "console|widgets|fly|spy"
			end
			return true
		end
		return false, "panel yok"
	end,
})

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 10: YARDIMCI PENCERELER (Komut paneli, Fly paneli, Widget, Chat, Inspector)
-- ──────────────────────────────────────────────────────────────────────────

-- ── WidgetManager ─────────────────────────────────────────────────────────
local WidgetManager = {}
WidgetManager.__index = WidgetManager

function WidgetManager.new(parentGui)
	local self = setmetatable({}, WidgetManager)
	self.Janitor = Cleanup.new()
	self.Widgets = {}
	self._positions = {}

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_Widgets"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 250
	screenGui.Parent = parentGui
	self.Janitor:Add(screenGui)
	self.ScreenGui = screenGui

	local container = Instance.new("Frame")
	container.Name = "WidgetContainer"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Parent = screenGui
	self.Container = container

	local definitions = {
		{ Id = "FPS", Title = "FPS", Width = 92 },
		{ Id = "Ping", Title = "PING", Width = 104 },
		{ Id = "Time", Title = "SAAT", Width = 118 },
		{ Id = "Profiler", Title = "PROFILER", Width = 128 },
		{ Id = "Graph", Title = "GRAF", Width = 150, Height = 56 },
	}

	for index, definition in ipairs(definitions) do
		local width = definition.Width or Config.Sizes.WidgetWidth
		local height = definition.Height or Config.Sizes.WidgetHeight

		local widget = Instance.new("Frame")
		widget.Name = "Widget_" .. definition.Id
		widget.Size = UDim2.fromOffset(width, height)
		widget.Position = UDim2.fromOffset(10, 10 + (index - 1) * (height + 8))
		widget.BackgroundColor3 = Config.Theme.Surface
		widget.BackgroundTransparency = 0.1
		widget.Active = true
		widget.Visible = false
		widget.Parent = container
		Utilities.Round_UI(widget, Config.Sizes.CornerRadiusSmall)
		Utilities.Stroke(widget, Theme.Accent, 1)
		self.Janitor:Add(widget)

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, -8, 1, -6)
		label.Position = UDim2.new(0, 4, 0, 2)
		label.BackgroundTransparency = 1
		label.Text = definition.Title
		label.TextColor3 = Config.Theme.TextPrimary
		label.Font = Enum.Font.GothamBold
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.Parent = widget

		if definition.Id == "Graph" then
			local graph = Instance.new("Frame")
			graph.Name = "Graph"
			graph.Size = UDim2.new(1, -10, 1, -18)
			graph.Position = UDim2.new(0, 5, 0, 16)
			graph.BackgroundTransparency = 1
			graph.Parent = widget
			self.Janitor:Add(graph)

			local bars = {}
			for i = 1, 24 do
				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(0.04, 0, 0.2, 0)
				bar.Position = UDim2.new((i - 1) / 24, 0, 0.8, 0)
				bar.BackgroundColor3 = Theme.Accent
				bar.BorderSizePixel = 0
				bar.Parent = graph
				bars[i] = bar
			end
			self._graphBars = bars
		end

		-- surukleme
		local dragging = false
		local dragStart, startPos
		self.Janitor:Connect(widget.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = widget.Position
			end
		end)
		self.Janitor:Connect(UserInputService.InputChanged, function(input)
			if not dragging then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				widget.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
		self.Janitor:Connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		self.Widgets[definition.Id] = { Instance = widget, Label = label, Visible = false }
	end

	return self
end

function WidgetManager:SetVisible(id, visible)
	local widget = self.Widgets[id]
	if not widget then
		return false
	end
	widget.Instance.Visible = visible
	self.Widgets[id].Visible = visible
	return true
end

function WidgetManager:Toggle(id)
	local widget = self.Widgets[id]
	if not widget then
		return false
	end
	local newState = not widget.Visible
	widget.Instance.Visible = newState
	widget.Visible = newState
	return newState
end

function WidgetManager:ToggleAll()
	local anyVisible = false
	for _, widget in pairs(self.Widgets) do
		if widget.Visible then
			anyVisible = true
			break
		end
	end
	for id, widget in pairs(self.Widgets) do
		widget.Instance.Visible = not anyVisible
		widget.Visible = not anyVisible
	end
	return not anyVisible
end

function WidgetManager:Update()
	local fpsWidget = self.Widgets.FPS
	if fpsWidget and fpsWidget.Visible then
		fpsWidget.Label.Text = string.format("FPS %d", Analytics.GetFPS())
	end
	local pingWidget = self.Widgets.Ping
	if pingWidget and pingWidget.Visible then
		pingWidget.Label.Text = string.format("PING %d ms", Analytics.GetPing())
	end
	local timeWidget = self.Widgets.Time
	if timeWidget and timeWidget.Visible then
		timeWidget.Label.Text = Utilities.GetDateClock(EnvironmentController.GetTime())
	end
	local profilerWidget = self.Widgets.Profiler
	if profilerWidget and profilerWidget.Visible then
		profilerWidget.Label.Text = string.format("Frame %.1f ms", (Analytics.FrameTime or 0) * 1000)
	end
	if self._graphBars then
		local samples = Analytics.Graph.FPS
		local count = #self._graphBars
		for i = 1, count do
			local index = #samples - count + i
			local value = index > 0 and samples[index] or 0
			local ratio = Utilities.Clamp(value / 120, 0.05, 1)
			local bar = self._graphBars[i]
			bar.Size = UDim2.new(0.04, 0, ratio, 0)
			bar.Position = UDim2.new((i - 1) / count, 0, 1 - ratio, 0)
		end
	end
end

-- ── CommandPanel (sessiz komut paneli) ────────────────────────────────────
local CommandPanel = {}
CommandPanel.__index = CommandPanel

function CommandPanel.new(parentGui)
	local self = setmetatable({}, CommandPanel)
	self.Janitor = Cleanup.new()

	self.Window = FloatingWindow.new({
		Name = "CommandPanel",
		Title = "SESSIZ KOMUT PANELI",
		Size = UDim2.fromOffset(340, 320),
		Position = UDim2.new(1, -356, 1, -340),
		Parent = parentGui,
		DisplayOrder = 350,
		Visible = false,
	})

	-- Acilma butonu (sag kenar, her zaman gorunur)
	local openBtn = Instance.new("TextButton")
	openBtn.Name = "OpenButton"
	openBtn.AnchorPoint = Vector2.new(1, 0.5)
	openBtn.Size = UDim2.fromOffset(44, 44)
	openBtn.Position = UDim2.new(1, -8, 0.5, 0)
	openBtn.BackgroundColor3 = Theme.Accent
	openBtn.Text = "⌨"
	openBtn.TextColor3 = Config.Theme.TextPrimary
	openBtn.Font = Enum.Font.GothamBold
	openBtn.TextSize = 18
	openBtn.AutoButtonColor = false
	openBtn.Parent = self.Window.ScreenGui
	Utilities.Round_UI(openBtn, UDim.new(1, 0))
	Utilities.Stroke(openBtn, Config.Theme.SurfaceLight, 1)
	self.Janitor:Add(openBtn)
	self.OpenButton = openBtn

	local content = self.Window.Content

	local inputLabel = Instance.new("TextLabel")
	inputLabel.BackgroundTransparency = 1
	inputLabel.Size = UDim2.new(1, -20, 0, 16)
	inputLabel.Position = UDim2.new(0, 10, 0, 4)
	inputLabel.Text = "Komut gir (" .. Config.Command.ConsolePrefix .. " prefix otomatik eklenir)"
	inputLabel.TextColor3 = Config.Theme.TextMuted
	inputLabel.Font = Enum.Font.Gotham
	inputLabel.TextSize = 10
	inputLabel.TextXAlignment = Enum.TextXAlignment.Left
	inputLabel.Parent = content

	local input = Instance.new("TextBox")
	input.Name = "CommandInput"
	input.Size = UDim2.new(1, -90, 0, Config.Sizes.RowHeight)
	input.Position = UDim2.new(0, 10, 0, 22)
	input.BackgroundColor3 = Config.Theme.Surface
	input.TextColor3 = Config.Theme.TextPrimary
	input.PlaceholderText = "orn: fly, noclip, tp oyuncu"
	input.PlaceholderColor3 = Config.Theme.TextMuted
	input.Font = Enum.Font.Gotham
	input.TextSize = 13
	input.ClearTextOnFocus = false
	input.Parent = content
	Utilities.Round_UI(input, Config.Sizes.CornerRadiusSmall)
	Utilities.Padding(input, 8)
	self.Janitor:Add(input)
	self.Input = input

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.fromOffset(70, Config.Sizes.RowHeight)
	sendBtn.Position = UDim2.new(1, -80, 0, 22)
	sendBtn.BackgroundColor3 = Theme.Accent
	sendBtn.Text = "GONDER"
	sendBtn.TextColor3 = Config.Theme.TextPrimary
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 11
	sendBtn.AutoButtonColor = false
	sendBtn.Parent = content
	Utilities.Round_UI(sendBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(sendBtn)

	local function submit()
		local text = input.Text
		if Utilities.Trim(text) == "" then
			Notifications:Error("Komut", "Bos komut gonderilemez.")
			return
		end
		local prefixed = text
		local first = prefixed:sub(1, 1)
		if first ~= Config.Command.ChatPrefix and first ~= Config.Command.ConsolePrefix then
			prefixed = Config.Command.ConsolePrefix .. prefixed
		end
		CommandSystem.Run(prefixed, "console")
		input.Text = ""
	end

	self.Janitor:Connect(sendBtn.MouseButton1Click, submit)

	self.Janitor:Connect(input.FocusLost, function(enterPressed)
		if enterPressed then
			submit()
		end
	end)

	-- Gecmis (yukari/asagi tuslari)
	self.Janitor:Connect(UserInputService.InputBegan, function(input, processed)
		if processed then
			return
		end
		if not self.Window:IsVisible() then
			return
		end
		if UserInputService:GetFocusedTextBox() ~= input then
			return
		end
		if input.KeyCode == Enum.KeyCode.Up then
			CommandSystem.HistoryIndex = math.max(1, CommandSystem.HistoryIndex - 1)
			local entry = CommandSystem.History[CommandSystem.HistoryIndex]
			if entry then
				input.Text = entry
			end
		elseif input.KeyCode == Enum.KeyCode.Down then
			CommandSystem.HistoryIndex = math.min(#CommandSystem.History, CommandSystem.HistoryIndex + 1)
			local entry = CommandSystem.History[CommandSystem.HistoryIndex]
			input.Text = entry or ""
		end
	end)

	-- Hizli komut butonlari
	local quickTitle = Instance.new("TextLabel")
	quickTitle.BackgroundTransparency = 1
	quickTitle.Size = UDim2.new(1, -20, 0, 16)
	quickTitle.Position = UDim2.new(0, 10, 0, 62)
	quickTitle.Text = "Hizli komutlar"
	quickTitle.TextColor3 = Config.Theme.TextMuted
	quickTitle.Font = Enum.Font.GothamBold
	quickTitle.TextSize = 10
	quickTitle.TextXAlignment = Enum.TextXAlignment.Left
	quickTitle.Parent = content

	local grid = Instance.new("Frame")
	grid.Size = UDim2.new(1, -20, 0, 90)
	grid.Position = UDim2.new(0, 10, 0, 80)
	grid.BackgroundTransparency = 1
	grid.Parent = content

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.fromOffset(70, 26)
	gridLayout.CellPadding = UDim2.fromOffset(4, 4)
	gridLayout.FillDirectionMaxCells = 4
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = grid

	local quickCommands = { "fly", "noclip", "flingall", "tts", "radar", "status", "spy", "reset", "help", "theme", "teleport", "players" }
	for index, name in ipairs(quickCommands) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 70, 0, 26)
		btn.LayoutOrder = index
		btn.BackgroundColor3 = Config.Theme.Surface
		btn.Text = name
		btn.TextColor3 = Config.Theme.TextSecondary
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 10
		btn.AutoButtonColor = false
		btn.Parent = grid
		Utilities.Round_UI(btn, UDim.new(0, 6))
		self.Janitor:Add(btn)
		self.Janitor:Connect(btn.MouseButton1Click, function()
			input.Text = name
			submit()
		end)
	end

	-- Sonuc / gecmis listesi
	local historyTitle = Instance.new("TextLabel")
	historyTitle.BackgroundTransparency = 1
	historyTitle.Size = UDim2.new(1, -20, 0, 16)
	historyTitle.Position = UDim2.new(0, 10, 0, 176)
	historyTitle.Text = "Son islemler"
	historyTitle.TextColor3 = Config.Theme.TextMuted
	historyTitle.Font = Enum.Font.GothamBold
	historyTitle.TextSize = 10
	historyTitle.TextXAlignment = Enum.TextXAlignment.Left
	historyTitle.Parent = content

	local log = Instance.new("ScrollingFrame")
	log.Name = "HistoryLog"
	log.Size = UDim2.new(1, -20, 1, -196)
	log.Position = UDim2.new(0, 10, 0, 194)
	log.BackgroundTransparency = 1
	log.BorderSizePixel = 0
	log.ScrollBarThickness = 3
	log.CanvasSize = UDim2.new(0, 0, 0, 0)
	log.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	log.Parent = content

	local logLayout = Instance.new("UIListLayout")
	logLayout.Padding = UDim.new(0, 2)
	logLayout.SortOrder = Enum.SortOrder.LayoutOrder
	logLayout.Parent = log

	self.HistoryLog = log

	self.Janitor:Connect(openBtn.MouseButton1Click, function()
		self.Window:Toggle()
		if self.Window:IsVisible() then
			input:CaptureFocus()
		end
	end)

	CommandSystem.OnResult = function(text, kind)
		local entry = Instance.new("TextLabel")
		entry.Size = UDim2.new(1, -6, 0, 0)
		entry.AutomaticSize = Enum.AutomaticSize.Y
		entry.BackgroundTransparency = 1
		entry.Text = tostring(text)
		entry.TextColor3 = kind == "Error" and Config.Theme.Error or Config.Theme.TextSecondary
		entry.Font = Enum.Font.Gotham
		entry.TextSize = 11
		entry.TextWrapped = true
		entry.TextXAlignment = Enum.TextXAlignment.Left
		entry.Parent = log
		Utilities.ScrollIntoView(log, entry)
	end

	return self
end

function CommandPanel:Toggle()
	self.Window:Toggle()
end

function CommandPanel:Destroy()
	self.Janitor:Destroy()
end

-- ── FlyPanel (arac uçuş yön tuşları) ──────────────────────────────────────
local FlyPanel = {}
FlyPanel.__index = FlyPanel

function FlyPanel.new(parentGui)
	local self = setmetatable({}, FlyPanel)
	self.Janitor = Cleanup.new()

	self.Window = FloatingWindow.new({
		Name = "FlyPanel",
		Title = "UCUS PANELI",
		Size = UDim2.fromOffset(220, 300),
		Position = UDim2.new(0, 14, 0.5, -105),
		Parent = parentGui,
		DisplayOrder = 340,
		Visible = false,
	})

	local content = self.Window.Content

	local function makeButton(text, x, y, vector)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.fromOffset(46, 40)
		btn.Position = UDim2.fromOffset(x, y)
		btn.BackgroundColor3 = Config.Theme.Surface
		btn.Text = text
		btn.TextColor3 = Config.Theme.TextPrimary
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.AutoButtonColor = false
		btn.Parent = content
		Utilities.Round_UI(btn, Config.Sizes.CornerRadiusSmall)
		self.Janitor:Add(btn)

		local function apply(value)
			local current = VehicleController.GetInput()
			VehicleController.SetInput(Vector3.new(
				value.X or current.X,
				value.Y or current.Y,
				value.Z or current.Z
			))
		end

		self.Janitor:Connect(btn.MouseButton1Down, function()
			apply(vector)
			btn.BackgroundColor3 = Theme.Accent
			Accessibility.Haptic("UIClick")
		end)
		self.Janitor:Connect(btn.MouseButton1Up, function()
			apply({ X = 0, Y = 0, Z = 0 })
			btn.BackgroundColor3 = Config.Theme.Surface
		end)
		return btn
	end

	makeButton("▲", 82, 8, { Y = 1 })
	makeButton("◀", 30, 56, { X = -1 })
	makeButton("▶", 134, 56, { X = 1 })
	makeButton("▼", 82, 104, { Y = -1 })
	makeButton("W", 12, 150, { Z = 1 })
	makeButton("S", 62, 150, { Z = -1 })
	makeButton("A", 112, 150, { X = -1 })
	makeButton("D", 162, 150, { X = 1 })

	local speedSlider = Slider.new(content, {
		Text = "Hiz",
		Min = 20, Max = 800, Step = 10, Default = Config.Physics.FlySpeed,
		LayoutOrder = 20,
		OnChanged = function(value)
			VehicleController.FlySpeed = value
			CharacterController.FlySpeed = value
		end,
	})
	speedSlider.Instance.Position = UDim2.fromOffset(10, 200)

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(1, -20, 0, 30)
	toggleBtn.Position = UDim2.new(0, 10, 0, 182)
	toggleBtn.BackgroundColor3 = Theme.Accent
	toggleBtn.Text = "ARAC UCUSU: KAPALI"
	toggleBtn.TextColor3 = Config.Theme.TextPrimary
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 12
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = content
	Utilities.Round_UI(toggleBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(toggleBtn)

	self.Janitor:Connect(toggleBtn.MouseButton1Click, function()
		if VehicleController.Flying then
			VehicleController.SetFly(false)
			toggleBtn.Text = "ARAC UCUSU: KAPALI"
			toggleBtn.BackgroundColor3 = Theme.Accent
		else
			local ok, err = VehicleController.SetFly(true)
			if ok then
				toggleBtn.Text = "ARAC UCUSU: ACIK"
				toggleBtn.BackgroundColor3 = Config.Theme.Success
			else
				Notifications:Error("Araç uçuşu", tostring(err))
			end
		end
	end)

	return self
end

function FlyPanel:SetVisible(state)
	self.Window:SetVisible(state)
end

function FlyPanel:Toggle()
	self.Window:Toggle()
end

function FlyPanel:Destroy()
	self.Janitor:Destroy()
end

-- ── ChatWindow (sohbet casusu + log + arama) ──────────────────────────────
local ChatWindow = {}
ChatWindow.__index = ChatWindow

function ChatWindow.new(parentGui)
	local self = setmetatable({}, ChatWindow)
	self.Janitor = Cleanup.new()
	self.Mode = "Live"
	self._lastEntry = 0

	self.Window = FloatingWindow.new({
		Name = "ChatWindow",
		Title = "SOHBET CASUSU / LOG",
		Size = UDim2.fromOffset(350, 330),
		Position = UDim2.new(0, 14, 0.3, 0),
		Parent = parentGui,
		DisplayOrder = 330,
		Visible = false,
	})

	local content = self.Window.Content

	local modeRow = Instance.new("Frame")
	modeRow.Size = UDim2.new(1, -20, 0, 28)
	modeRow.Position = UDim2.new(0, 10, 0, 4)
	modeRow.BackgroundTransparency = 1
	modeRow.Parent = content

	local modeLayout = Instance.new("UIListLayout")
	modeLayout.FillDirection = Enum.FillDirection.Horizontal
	modeLayout.Padding = UDim.new(0, 5)
	modeLayout.Parent = modeRow

	local modes = { "Live", "Log", "Whisper", "Search" }
	for index, mode in ipairs(modes) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 70, 0, 26)
		btn.LayoutOrder = index
		btn.BackgroundColor3 = Config.Theme.Surface
		btn.Text = mode
		btn.TextColor3 = Config.Theme.TextSecondary
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.AutoButtonColor = false
		btn.Parent = modeRow
		Utilities.Round_UI(btn, UDim.new(0, 6))
		self.Janitor:Add(btn)
		self.Janitor:Connect(btn.MouseButton1Click, function()
			self.Mode = mode
			self:Refresh()
		end)
	end

	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchBox"
	searchBox.Size = UDim2.new(1, -20, 0, Config.Sizes.RowHeight)
	searchBox.Position = UDim2.new(0, 10, 0, 36)
	searchBox.BackgroundColor3 = Config.Theme.Surface
	searchBox.TextColor3 = Config.Theme.TextPrimary
	searchBox.PlaceholderText = "Sohbetlerde ara..."
	searchBox.PlaceholderColor3 = Config.Theme.TextMuted
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 12
	searchBox.Text = ""
	searchBox.ClearTextOnFocus = false
	searchBox.Visible = false
	searchBox.Parent = content
	Utilities.Round_UI(searchBox, Config.Sizes.CornerRadiusSmall)
	Utilities.Padding(searchBox, 8)
	self.Janitor:Add(searchBox)
	self.SearchBox = searchBox

	self.Janitor:Connect(searchBox:GetPropertyChangedSignal("Text"), function()
		self:Refresh()
	end)

	local list = Instance.new("ScrollingFrame")
	list.Name = "ChatList"
	list.Size = UDim2.new(1, -20, 1, -46)
	list.Position = UDim2.new(0, 10, 0, 40)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 3
	list.ScrollBarImageColor3 = Theme.Accent
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	list.Parent = content

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 3)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = list

	self.List = list

	return self
end

function ChatWindow:AddEntry(entry)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -6, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.RichText = true
	local color = Config.Theme.TextSecondary
	if entry.Kind == "system" then
		color = Config.Theme.Info
	elseif entry.Kind == "self" then
		color = Theme.AccentBright
	elseif entry.Kind == "whisper" then
		color = Config.Theme.Warning
	end
	label.Text = string.format("[%s] <font color=\"#%02X%02X%02X\">%s</font>: %s",
		Utilities.FormatClock(entry.Time),
		math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255),
		entry.Name, entry.Text)
	label.TextColor3 = color
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = self.List
	Utilities.ScrollIntoView(self.List, label)
end

function ChatWindow:Refresh()
	for _, child in ipairs(self.List:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	self.SearchBox.Visible = (self.Mode == "Search")

	if self.Mode == "Whisper" then
		for _, entry in ipairs(ChatSystem.Whispers) do
			self:AddEntry({
				Time = entry.Time,
				Name = "-> " .. entry.Target,
				Text = entry.Text,
				Kind = "whisper",
			})
		end
		return
	end

	local query = ""
	if self.Mode == "Search" then
		query = string.lower(self.SearchBox.Text)
	end

	for _, entry in ipairs(ChatSystem.Log) do
		if self.Mode == "Search" then
			if query == "" or string.find(string.lower(entry.Text), query, 1, true)
				or string.find(string.lower(entry.Name), query, 1, true) then
				self:AddEntry(entry)
			end
		else
			self:AddEntry(entry)
		end
	end
end

function ChatWindow:Update()
	if not self.Window:IsVisible() then
		return
	end
	local count = #ChatSystem.Log
	if count == self._lastEntry then
		return
	end
	self._lastEntry = count
	if self.Mode == "Live" or self.Mode == "Search" then
		self:Refresh()
	end
end

function ChatWindow:SetVisible(state)
	self.Window:SetVisible(state)
	if state then
		self:Refresh()
	end
end

function ChatWindow:Toggle()
	self.Window:Toggle()
	if self.Window:IsVisible() then
		self:Refresh()
	end
end

function ChatWindow:Destroy()
	self.Janitor:Destroy()
end

-- ── InspectorWindow (oyuncu / nesne detaylari) ───────────────────────────
local InspectorWindow = {}
InspectorWindow.__index = InspectorWindow

function InspectorWindow.new(parentGui)
	local self = setmetatable({}, InspectorWindow)
	self.Janitor = Cleanup.new()
	self._lastRefresh = 0

	self.Window = FloatingWindow.new({
		Name = "Inspector",
		Title = "PLAYER INSPECTOR",
		Size = UDim2.fromOffset(300, 300),
		Position = UDim2.new(1, -316, 0.2, 0),
		Parent = parentGui,
		DisplayOrder = 320,
		Visible = false,
	})

	local content = self.Window.Content

	local info = Instance.new("TextLabel")
	info.Name = "Info"
	info.Size = UDim2.new(1, -20, 1, -20)
	info.Position = UDim2.new(0, 10, 0, 6)
	info.BackgroundTransparency = 1
	info.Text = "Hedef secilmedi."
	info.TextColor3 = Config.Theme.TextSecondary
	info.Font = Enum.Font.Gotham
	info.TextSize = 12
	info.TextWrapped = true
	info.TextXAlignment = Enum.TextXAlignment.Left
	info.TextYAlignment = Enum.TextYAlignment.Top
	info.Parent = content

	self.Info = info

	local selectBtn = Instance.new("TextButton")
	selectBtn.Size = UDim2.new(1, -20, 0, 30)
	selectBtn.Position = UDim2.new(0, 10, 1, -36)
	selectBtn.BackgroundColor3 = Theme.Accent
	selectBtn.Text = "HEDEF OYUNCU SEC"
	selectBtn.TextColor3 = Config.Theme.TextPrimary
	selectBtn.Font = Enum.Font.GothamBold
	selectBtn.TextSize = 12
	selectBtn.AutoButtonColor = false
	selectBtn.Parent = content
	Utilities.Round_UI(selectBtn, Config.Sizes.CornerRadiusSmall)
	self.Janitor:Add(selectBtn)

	self.Janitor:Connect(selectBtn.MouseButton1Click, function()
		if AppInstance and AppInstance._cycleTarget then
			MainApp:_cycleTarget()
		end
	end)

	return self
end

function InspectorWindow:Toggle()
	self.Window:Toggle()
end

function InspectorWindow:SetVisible(state)
	self.Window:SetVisible(state)
	if state then
		self:Refresh()
	end
end

function InspectorWindow:Refresh()
	local target = AdminTools.GetTarget()
	if not target then
		self.Info.Text = "Hedef secilmedi.\n\nSol panelden hedef sec veya 'HEDEF OYUNCU SEC' butonunu kullan."
		return
	end
	local character = Utilities.GetCharacter(target)
	local root = Utilities.GetRootPart(character)
	local humanoid = Utilities.GetHumanoid(character)
	local lines = {}
	table.insert(lines, "ISIM: " .. target.DisplayName .. " (@" .. target.Name .. ")")
	table.insert(lines, "USER ID: " .. tostring(target.UserId))
	table.insert(lines, "HESAP YASI: " .. tostring(target.AccountAge) .. " gun")
	table.insert(lines, "PING: " .. tostring(Utilities.GetPing(target)) .. " ms")
	table.insert(lines, "TAKIM: " .. (target.Team and target.Team.Name or "-"))
	table.insert(lines, "DURUM: " .. AdminTools.GetPlayerStatus(target))
	if humanoid then
		table.insert(lines, "CAN: " .. string.format("%.0f / %.0f", humanoid.Health, humanoid.MaxHealth))
	end
	if root then
		table.insert(lines, "KONUM: " .. string.format("%.0f, %.0f, %.0f", root.Position.X, root.Position.Y, root.Position.Z))
		local myRoot = CharacterController.GetRoot()
		if myRoot then
			table.insert(lines, "MESAFE: " .. string.format("%.1f stud", (root.Position - myRoot.Position).Magnitude))
		end
	end
	self.Info.Text = table.concat(lines, "\n")
end

function InspectorWindow:Update()
	if not self.Window:IsVisible() then
		return
	end
	if os.clock() - self._lastRefresh < 0.5 then
		return
	end
	self._lastRefresh = os.clock()
	self:Refresh()
end

function InspectorWindow:Destroy()
	self.Janitor:Destroy()
end

-- ── ActivityLogWindow ─────────────────────────────────────────────────────
local ActivityLogWindow = {}
ActivityLogWindow.__index = ActivityLogWindow

function ActivityLogWindow.new(parentGui)
	local self = setmetatable({}, ActivityLogWindow)
	self.Janitor = Cleanup.new()
	self._lastCount = 0

	self.Window = FloatingWindow.new({
		Name = "ActivityLog",
		Title = "AKTIVITE KAYDI",
		Size = UDim2.fromOffset(320, 300),
		Position = UDim2.new(0, 14, 0.62, 0),
		Parent = parentGui,
		DisplayOrder = 310,
		Visible = false,
	})

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, -20, 1, -16)
	list.Position = UDim2.new(0, 10, 0, 8)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 3
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	list.Parent = self.Window.Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	self.List = list

	return self
end

function ActivityLogWindow:Update()
	if not self.Window:IsVisible() then
		return
	end
	local count = #AdminTools.ActivityLog
	if count == self._lastCount then
		return
	end
	self._lastCount = count
	for _, child in ipairs(self.List:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	for _, entry in ipairs(AdminTools.ActivityLog) do
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -6, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.BackgroundTransparency = 1
		label.Text = "[" .. Utilities.FormatClock(entry.Time) .. "] " .. entry.Text
		label.TextColor3 = Config.Theme.TextSecondary
		label.Font = Enum.Font.Gotham
		label.TextSize = 11
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = self.List
	end
end

function ActivityLogWindow:Toggle()
	self.Window:Toggle()
end

function ActivityLogWindow:SetVisible(state)
	self.Window:SetVisible(state)
end

function ActivityLogWindow:Toggle()
	self.Window:Toggle()
end

function ActivityLogWindow:Destroy()
	self.Janitor:Destroy()
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 11: UI KİT + ÖZELLİK KAYIT (arama ve hızlı erişim için)
-- ──────────────────────────────────────────────────────────────────────────

local UIKit = {}
UIKit.Features = {}
UIKit._order = 0

function UIKit.NextOrder()
	UIKit._order = UIKit._order + 10
	return UIKit._order
end

function UIKit.RegisterFeature(id, name, category, description, action)
	UIKit.Features[id] = {
		Id = id,
		Name = name,
		Category = category,
		Description = description,
		Action = action,
	}
end

function UIKit.BuildRows(parent, items)
	for index, item in ipairs(items) do
		local kind = item.type
		local order = item.order or (index * 10)
		if kind == "toggle" then
			Toggle.new(parent, {
				Text = item.text,
				Default = item.default,
				LayoutOrder = order,
				Tooltip = item.tooltip,
				OnChanged = item.onChanged,
			})
		elseif kind == "button" then
			Button.new(parent, {
				Text = item.text,
				Color = item.color,
				LayoutOrder = order,
				Tooltip = item.tooltip,
				OnClick = item.onClick,
			})
		elseif kind == "slider" then
			Slider.new(parent, {
				Text = item.text,
				Min = item.min,
				Max = item.max,
				Step = item.step,
				Default = item.default,
				Suffix = item.suffix or "",
				LayoutOrder = order,
				Tooltip = item.tooltip,
				OnChanged = item.onChanged,
			})
		elseif kind == "dropdown" then
			Dropdown.new(parent, {
				Text = item.text,
				Options = item.options,
				Default = item.default,
				LayoutOrder = order,
				Tooltip = item.tooltip,
				OnChanged = item.onChanged,
			})
		elseif kind == "text" then
			TextBox.new(parent, {
				Placeholder = item.placeholder,
				Default = item.default,
				Size = item.size,
				LayoutOrder = order,
				Tooltip = item.tooltip,
				OnChanged = item.onChanged,
				OnSubmit = item.onSubmit,
			})
		elseif kind == "color" then
			ColorPicker.new(parent, {
				LayoutOrder = order,
				OnChanged = item.onChanged,
			})
		elseif kind == "keybind" then
			KeybindBox.new(parent, {
				Default = item.default,
				LayoutOrder = order,
				OnChanged = item.onChanged,
			})
		end
	end
end

-- Tema disi yardimci: her sekmenin altina "Iptal Et" koyar
local function AddCancelRow(parent, order)
	Button.new(parent, {
		Text = "IPTAL ET / MENUYU KAPAT",
		Color = Config.Theme.SurfaceLight,
		LayoutOrder = order or 9999,
		OnClick = function()
			if AppInstance and AppInstance.Window then
				AppInstance.Window:SetVisible(false)
			end
			_stateInstance:Set("MenuOpen", false)
		end,
	})
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 12: SEKMELERİN KURULUMU
-- ──────────────────────────────────────────────────────────────────────────

local MenuBuilder = {}

-- ── ANA SEKME ─────────────────────────────────────────────────────────────
function MenuBuilder.BuildHome(tab)
	local quick = Section.new(tab, { Title = "Hizli Erisim", LayoutOrder = 1 })

	UIKit.BuildRows(quick.Content, {
		{ type = "button", text = "UCUS", order = 10, color = Theme.Accent, onClick = function()
			local enabled = not CharacterController.Flying
			CharacterController.SetFly(enabled)
			Notifications:Info("Ucus", enabled and "Ucus aktif" or "Ucus kapatildi")
		end },
		{ type = "button", text = "NOCLIP", order = 20, color = Theme.Accent, onClick = function()
			local enabled = not CharacterController.Noclip
			CharacterController.SetNoclip(enabled)
			Notifications:Info("Noclip", enabled and "Duvarlardan geciyorsun" or "Noclip kapali")
		end },
		{ type = "button", text = "ARAC UCUSU", order = 30, color = Theme.Accent, onClick = function()
			if AppInstance and AppInstance.FlyPanel then
				AppInstance.FlyPanel:Toggle()
			end
		end },
		{ type = "button", text = "WIDGETS", order = 40, color = Theme.Accent, onClick = function()
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:ToggleAll()
			end
		end },
		{ type = "button", text = "SOHBET CASUSU", order = 50, color = Theme.Accent, onClick = function()
			if AppInstance and AppInstance.ChatWindow then
				AppInstance.ChatWindow:Toggle()
			end
		end },
		{ type = "button", text = "INSPECTOR", order = 60, color = Theme.Accent, onClick = function()
			if AppInstance and AppInstance.Inspector then
				AppInstance.Inspector:Toggle()
			end
		end },
		{ type = "button", text = "KOMUT PANELI", order = 70, color = Theme.Accent, onClick = function()
			if AppInstance and AppInstance.CommandPanel then
				AppInstance.CommandPanel:Toggle()
			end
		end },
	})

	local status = Section.new(tab, { Title = "Durum", LayoutOrder = 2 })
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, 0, 0, 64)
	statusLabel.BackgroundTransparency = 1
	statusLabel.TextColor3 = Config.Theme.TextSecondary
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 11
	statusLabel.TextWrapped = true
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.TextYAlignment = Enum.TextYAlignment.Top
	statusLabel.Parent = status.Content
	_stateInstance:Set("StatusLabel", statusLabel)

	local menuSettings = Section.new(tab, { Title = "Menu Ayarlari (Kategori 1)", LayoutOrder = 3 })

	UIKit.BuildRows(menuSettings.Content, {
		{ type = "button", text = "MENU DUZENINI KAYDET", order = 10, tooltip = "Pencere konumu, sekme ve ayarlari disa aktarir", onClick = function()
			local payload = {
				WindowX = AppInstance.Window.Root.Position.X.Scale,
				WindowY = AppInstance.Window.Root.Position.Y.Scale,
				Width = AppInstance.Window.Root.Size.X.Offset,
				Height = AppInstance.Window.Root.Size.Y.Offset,
				Tab = _stateInstance:Get("CurrentTab"),
				Scale = Config.Menu.Scale,
				Minimalist = Config.Menu.Minimalist,
				OneHand = Config.Menu.OneHand,
				SoundPack = Config.Menu.SoundPack,
			}
			local json = HttpService:JSONEncode(payload)
			_stateInstance:Set("SavedLayout", json)
			local ok = pcall(function()
				writefile("x52_layout.json", json)
			end)
			Notifications:Success("Kaydedildi", ok and "Menu duzeni kaydedildi (x52_layout.json)" or "Yerel dosya yazilamadi, veri panoda")
		end },
		{ type = "button", text = "KAYITLI DUZENI YUKLE", order = 20, onClick = function()
			local json = nil
			pcall(function()
				json = readfile("x52_layout.json")
			end)
			if not json then
				Notifications:Error("Yukleme", "Kayitli duzen bulunamadi")
				return
			end
			local ok, data = pcall(function()
				return HttpService:JSONDecode(json)
			end)
			if ok and type(data) == "table" then
				Config.Layout.WindowX = data.WindowX or 0.5
				Config.Layout.WindowY = data.WindowY or 0.5
				Config.Menu.Scale = data.Scale or 1
				AppInstance.Window.Root.Position = UDim2.new(Config.Layout.WindowX, 0, Config.Layout.WindowY, 0)
				AppInstance.Window:ApplyScale(Config.Menu.Scale)
				Notifications:Success("Yuklendi", "Menu duzeni geri yuklendi")
			else
				Notifications:Error("Yukleme", "Dosya okunamadi")
			end
		end },
		{ type = "keybind", text = "Menu tusu", default = Config.Keys.Menu, order = 30, onChanged = function(key)
			Config.Keys.Menu = key
		end },
		{ type = "keybind", text = "Komut paneli tusu", default = Config.Keys.Console, order = 40, onChanged = function(key)
			Config.Keys.Console = key
		end },
		{ type = "keybind", text = "Widget tusu", default = Config.Keys.Widgets, order = 50, onChanged = function(key)
			Config.Keys.Widgets = key
		end },
		{ type = "keybind", text = "Fly panel tusu", default = Config.Keys.FlyPanel, order = 60, onChanged = function(key)
			Config.Keys.FlyPanel = key
		end },
		{ type = "keybind", text = "Sohbet casusu tusu", default = Config.Keys.Spy, order = 70, onChanged = function(key)
			Config.Keys.Spy = key
		end },
		{ type = "toggle", text = "Minimalist Mod", default = false, order = 80, onChanged = function(enabled)
			Config.Menu.Minimalist = enabled
			Notifications:Info("Minimalist Mod", enabled and "Acik" or "Kapali")
		end },
		{ type = "button", text = "KOMUT GECMISI", order = 90, onClick = function()
			if AppInstance and AppInstance.ChatWindow then
				AppInstance.ChatWindow.Mode = "Log"
				AppInstance.ChatWindow:SetVisible(true)
				AppInstance.ChatWindow:Refresh()
			end
		end },
		{ type = "color", order = 100, onChanged = function(color)
			local h, s, v = color:Hsv()
			Theme.Accent = color
			Theme.AccentBright = Color3.fromHSV(h, math.min(1, s * 1.1), math.min(1, v * 1.15))
			Theme.AccentDark = Color3.fromHSV(h, s, v * 0.7)
			if AppInstance and AppInstance.Window then
				AppInstance.Window:ApplyTheme()
			end
		end },
		{ type = "toggle", text = "Bildirim Kuyrugu", default = true, order = 110, onChanged = function(enabled)
			Config.Notification.MaxVisible = enabled and 3 or 1
		end },
		{ type = "slider", text = "Bildirim suresi", min = 1, max = 10, step = 0.5, default = Config.Notification.Duration, order = 120, onChanged = function(value)
			Config.Notification.Duration = value
		end },
		{ type = "toggle", text = "Hizli Erisim Cubugu", default = true, order = 130, onChanged = function(enabled)
			Config.Menu.QuickBar = enabled
		end },
		{ type = "toggle", text = "Baglamsal Ipuclari", default = true, order = 140, onChanged = function(enabled)
			_stateInstance:Set("TooltipsEnabled", enabled)
		end },
		{ type = "dropdown", text = "Menu Ses Paketi", options = { "Default", "Soft", "Retro" }, default = Config.Menu.SoundPack, order = 150, onChanged = function(value)
			Config.Menu.SoundPack = value
			Utilities.PlayUI("Open")
		end },
		{ type = "toggle", text = "Menu Sesi", default = true, order = 160, onChanged = function(enabled)
			Config.Menu.SoundEnabled = enabled
		end },
		{ type = "toggle", text = "Otomatik Gizleme", default = false, order = 170, onChanged = function(enabled)
			Config.Menu.AutoHide = enabled
		end },
		{ type = "slider", text = "Gizleme suresi (sn)", min = 5, max = 300, step = 5, default = Config.Accessibility.AutoHideDelay, order = 180, onChanged = function(value)
			Config.Accessibility.AutoHideDelay = value
		end },
	})

	local wm = Section.new(tab, { Title = "Watermark", LayoutOrder = 4 })
	UIKit.BuildRows(wm.Content, {
		{ type = "text", placeholder = "Watermark metni", default = Config.Menu.WatermarkText, order = 10, onChanged = function(value)
			Config.Menu.WatermarkText = value
			if AppInstance and AppInstance.Window then
				AppInstance.Window.Watermark.Text = value
			end
		end },
		{ type = "slider", text = "Watermark boyutu", min = 8, max = 30, step = 1, default = Config.Menu.WatermarkSize, order = 20, onChanged = function(value)
			Config.Menu.WatermarkSize = value
			if AppInstance and AppInstance.Window then
				AppInstance.Window.Watermark.TextSize = value
			end
		end },
		{ type = "dropdown", text = "Watermark konumu", options = { "TopRight", "TopLeft", "BottomRight", "BottomLeft" }, default = Config.Menu.WatermarkPos, order = 30, onChanged = function(value)
			Config.Menu.WatermarkPos = value
			if not MainApp or not AppInstance.Window then
				return
			end
			local mark = AppInstance.Window.Watermark
			if value == "TopRight" then
				mark.AnchorPoint = Vector2.new(1, 0)
				mark.Position = UDim2.new(1, -10, 0, 6)
			elseif value == "TopLeft" then
				mark.AnchorPoint = Vector2.new(0, 0)
				mark.Position = UDim2.new(0, 10, 0, 6)
			elseif value == "BottomRight" then
				mark.AnchorPoint = Vector2.new(1, 1)
				mark.Position = UDim2.new(1, -10, 1, -6)
			else
				mark.AnchorPoint = Vector2.new(0, 1)
				mark.Position = UDim2.new(0, 10, 1, -6)
			end
		end },
	})

	local scale = Section.new(tab, { Title = "Ekran Olcegi", LayoutOrder = 5 })
	UIKit.BuildRows(scale.Content, {
		{ type = "dropdown", text = "Menu olcegi", options = { "0.8", "0.9", "1.0", "1.1", "1.2" }, default = "1.0", order = 10, onChanged = function(value)
			local number = tonumber(value) or 1
			if AppInstance and AppInstance.Window then
				AppInstance.Window:ApplyScale(number)
			end
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── FİZİK SEKMESİ ────────────────────────────────────────────────────────
function MenuBuilder.BuildPhysics(tab)
	local fling = Section.new(tab, { Title = "Fling Motoru", LayoutOrder = 1 })
	UIKit.BuildRows(fling.Content, {
		{ type = "slider", text = "Fling gucu", min = Config.Physics.FlingPowerMin, max = Config.Physics.FlingPowerMax, step = 100, default = Config.Physics.FlingPowerDefault, order = 10, onChanged = function(value)
			Config.Physics.FlingPowerDefault = value
		end },
		{ type = "toggle", text = "Walk Fling (yururken otomatik)", default = false, order = 20, onChanged = function(enabled)
			_stateInstance:Set("WalkFling", enabled)
		end },
		{ type = "button", text = "CLICK FLING (ekrana tikla)", order = 30, tooltip = "Secili oyuncuya tiklayinca aninda firlatir", onClick = function()
			local target = AdminTools.GetTarget()
			if not target then
				Notifications:Error("Click Fling", "Once hedef oyuncu sec")
				return
			end
			local root = Utilities.GetRootPart(Utilities.GetCharacter(target))
			if not root then
				Notifications:Error("Click Fling", "Hedef karaktersiz")
				return
			end
			local ok, method = PhysicsEngine.ApplyImpulse(root, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
			Notifications:Info("Click Fling", tostring(method))
		end },
		{ type = "slider", text = "Multi Fling menzili", min = 10, max = 200, step = 5, default = Config.Physics.MultiFlingRange, order = 40, onChanged = function(value)
			Config.Physics.MultiFlingRange = value
		end },
		{ type = "button", text = "MULTI FLING", order = 50, onClick = function()
			local root = CharacterController.GetRoot()
			if not root then
				Notifications:Error("Multi Fling", "Karakter bulunamadi")
				return
			end
			local count = 0
			for _, player in ipairs(PhysicsEngine.GetPlayersInRadius(Config.Physics.MultiFlingRange, root.Position)) do
				local targetRoot = Utilities.GetRootPart(Utilities.GetCharacter(player))
				if targetRoot then
					PhysicsEngine.ApplyImpulse(targetRoot, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
					count = count + 1
				end
			end
			Notifications:Success("Multi Fling", count .. " oyuncu firlatildi")
		end },
		{ type = "button", text = "HEDEFI FIRLAT (hedef secili)", order = 60, onClick = function()
			local target = AdminTools.GetTarget()
			if not target then
				Notifications:Error("Fling", "Hedef secili degil")
				return
			end
			local root = Utilities.GetRootPart(Utilities.GetCharacter(target))
			if root then
				local ok, method = PhysicsEngine.ApplyImpulse(root, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
				Notifications:Info("Fling", tostring(method))
			end
		end },
		{ type = "toggle", text = "Fling sirasinda dondur", default = false, order = 70, onChanged = function(enabled)
			_stateInstance:Set("FlingSpin", enabled)
		end },
	})

	local move = Section.new(tab, { Title = "Hareket", LayoutOrder = 2 })
	UIKit.BuildRows(move.Content, {
		{ type = "toggle", text = "Karakter ucusu", default = false, order = 10, onChanged = function(enabled)
			CharacterController.SetFly(enabled)
		end },
		{ type = "slider", text = "Ucus hizi", min = 20, max = Config.Physics.FlySpeedMax, step = 10, default = Config.Physics.FlySpeed, order = 20, onChanged = function(value)
			CharacterController.FlySpeed = value
			VehicleController.FlySpeed = value
		end },
		{ type = "toggle", text = "Noclip", default = false, order = 30, onChanged = function(enabled)
			CharacterController.SetNoclip(enabled)
		end },
		{ type = "slider", text = "Yurus hizi", min = 0, max = 300, step = 1, default = 16, order = 40, onChanged = function(value)
			local humanoid = Utilities.GetHumanoid(CharacterController.GetCharacter())
			if humanoid and not CharacterController.Flying then
				humanoid.WalkSpeed = value
			end
		end },
		{ type = "toggle", text = "Karakteri dondur (kendi)", default = false, order = 50, onChanged = function(enabled)
			CharacterController.SetFrozen(enabled)
		end },
		{ type = "toggle", text = "Arac ucusu", default = false, order = 60, onChanged = function(enabled)
			local ok, err = VehicleController.SetFly(enabled)
			if not ok then
				Notifications:Error("Arac ucusu", tostring(err))
			end
		end },
		{ type = "toggle", text = "Arac noclip", default = false, order = 70, onChanged = function(enabled)
			VehicleController.SetNoclip(enabled)
		end },
		{ type = "button", text = "SON BILINEN ARACI GOSTER", order = 80, onClick = function()
			local vehicle = PhysicsEngine.GetVehicle()
			Notifications:Info("Arac", vehicle and vehicle.Name or "Arac bulunamadi")
		end },
		{ type = "slider", text = "Yercekimi (yerel)", min = 0, max = 400, step = 5, default = 196, order = 90, onChanged = function(value)
			EnvironmentController.SetGravity(value)
		end },
	})

	local waypoint = Section.new(tab, { Title = "Waypoint (iki nokta arasi)", LayoutOrder = 3 })
	local pointA = { X = 0, Y = 0, Z = 0 }
	local pointB = { X = 0, Y = 0, Z = 0 }
	UIKit.BuildRows(waypoint.Content, {
		{ type = "text", placeholder = "A noktasi X", default = "0", order = 10, onChanged = function(value) pointA.X = tonumber(value) or 0 end },
		{ type = "text", placeholder = "A noktasi Y", default = "0", order = 20, onChanged = function(value) pointA.Y = tonumber(value) or 0 end },
		{ type = "text", placeholder = "A noktasi Z", default = "0", order = 30, onChanged = function(value) pointA.Z = tonumber(value) or 0 end },
		{ type = "text", placeholder = "B noktasi X", default = "0", order = 40, onChanged = function(value) pointB.X = tonumber(value) or 0 end },
		{ type = "text", placeholder = "B noktasi Y", default = "0", order = 50, onChanged = function(value) pointB.Y = tonumber(value) or 0 end },
		{ type = "text", placeholder = "B noktasi Z", default = "0", order = 60, onChanged = function(value) pointB.Z = tonumber(value) or 0 end },
		{ type = "button", text = "WAYPOINT BASLAT", order = 70, onClick = function()
			WaypointController.SetWaypoints(Vector3.new(pointA.X, pointA.Y, pointA.Z), Vector3.new(pointB.X, pointB.Y, pointB.Z))
			local ok = WaypointController.Start()
			Notifications:Info("Waypoint", ok and "Basladi" or "Baslatilamadi")
		end },
		{ type = "button", text = "WAYPOINT DURDUR", order = 80, onClick = function()
			WaypointController.Stop()
			Notifications:Info("Waypoint", "Durduruldu")
		end },
		{ type = "toggle", text = "Yol boyunca otomatik fling", default = true, order = 90, onChanged = function(enabled)
			WaypointController.AutoFling = enabled
		end },
		{ type = "slider", text = "Waypoint hizi", min = 30, max = 600, step = 10, default = Config.Physics.WaypointSpeed, order = 100, onChanged = function(value)
			WaypointController.Speed = value
		end },
	})

	local track = Section.new(tab, { Title = "Track & Spam Kill", LayoutOrder = 4 })
	local trackName = ""
	UIKit.BuildRows(track.Content, {
		{ type = "text", placeholder = "Hedef oyuncu adi", default = "", order = 10, onChanged = function(value)
			trackName = value
		end },
		{ type = "button", text = "HEDEFI TAKIP LISTESINE EKLE", order = 20, onClick = function()
			local player = Utilities.FindPlayer(trackName)
			if not player then
				Notifications:Error("Track", "Oyuncu bulunamadi")
				return
			end
			TrackController.AddTarget(player)
			Notifications:Success("Track", player.DisplayName .. " listeye eklendi")
		end },
		{ type = "button", text = "TAKIPI BASLAT", order = 30, onClick = function()
			local ok = TrackController.Start()
			Notifications:Info("Track", ok and "Basladi" or "Hedef listesi bos")
		end },
		{ type = "button", text = "TAKIPI DURDUR", order = 40, onClick = function()
			TrackController.Stop()
			TrackController.Clear()
			Notifications:Info("Track", "Durduruldu")
		end },
		{ type = "slider", text = "Fling araligi (sn)", min = 0.1, max = 2, step = 0.05, default = Config.Physics.TrackInterval, order = 50, onChanged = function(value)
			TrackController.Interval = value
		end },
		{ type = "slider", text = "Tahmin (sn)", min = 0, max = 1, step = 0.02, default = Config.Physics.TrackPrediction, order = 60, onChanged = function(value)
			Config.Physics.TrackPrediction = value
		end },
		{ type = "slider", text = "Takip hizi", min = 30, max = 600, step = 10, default = Config.Physics.FlySpeed, order = 70, onChanged = function(value)
			TrackController.Speed = value
		end },
	})

	local guard = Section.new(tab, { Title = "Anti-Fling (kendi koruman)", LayoutOrder = 5 })
	UIKit.BuildRows(guard.Content, {
		{ type = "toggle", text = "Anti-fling korumasi", default = false, order = 10, onChanged = function(enabled)
			_stateInstance:Set("AntiFling", enabled)
		end },
		{ type = "slider", text = "Hiz esigi", min = 50, max = 1000, step = 10, default = Config.Physics.AntiFlingVelocityThreshold, order = 20, onChanged = function(value)
			Config.Physics.AntiFlingVelocityThreshold = value
		end },
		{ type = "slider", text = "Donme esigi", min = 10, max = 500, step = 5, default = Config.Physics.AntiFlingAngularThreshold, order = 30, onChanged = function(value)
			Config.Physics.AntiFlingAngularThreshold = value
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── OYUNCU / ADMIN SEKMESİ (30 araç) ─────────────────────────────────────
function MenuBuilder.BuildPlayers(tab)
	local targetSection = Section.new(tab, { Title = "Hedef Oyuncu", LayoutOrder = 1 })
	local playerNames = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(playerNames, player.DisplayName .. " (@" .. player.Name .. ")")
		end
	end
	if #playerNames == 0 then
		table.insert(playerNames, "Oyuncu yok")
	end

	local targetDropdown = Dropdown.new(targetSection.Content, {
		Text = "Hedef",
		Options = playerNames,
		Default = playerNames[1],
		LayoutOrder = 10,
		OnChanged = function(value)
			local display = string.match(value, "^(.-) %(")
			local player = display and Utilities.FindPlayer(display) or nil
			AdminTools.SetTarget(player)
		end,
	})

	UIKit.BuildRows(targetSection.Content, {
		{ type = "button", text = "LISTEYI YENILE", order = 20, onClick = function()
			Notifications:Info("Hedef", "Yenilemek icin sekmeyi kapatip acabilirsin")
		end },
		{ type = "button", text = "EN YAKIN OYUNCUYU SEC", order = 30, onClick = function()
			local myRoot = CharacterController.GetRoot()
			if not myRoot then
				return
			end
			local best, bestDist = nil, math.huge
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					local root = Utilities.GetRootPart(Utilities.GetCharacter(player))
					if root then
						local dist = (root.Position - myRoot.Position).Magnitude
						if dist < bestDist then
							bestDist = dist
							best = player
						end
					end
				end
			end
			if best then
				AdminTools.SetTarget(best)
				Notifications:Success("Hedef", best.DisplayName .. " (" .. string.format("%.1f", bestDist) .. " stud)")
			end
		end },
		{ type = "button", text = "HEDEFI TEMIZLE", order = 40, onClick = function()
			AdminTools.SetTarget(nil)
		end },
	})

	local observe = Section.new(tab, { Title = "Gozlem", LayoutOrder = 2 })
	UIKit.BuildRows(observe.Content, {
		{ type = "button", text = "SPECTATE (izle)", order = 10, onClick = function()
			local target = AdminTools.GetTarget()
			if not target then
				Notifications:Error("Spectate", "Hedef sec")
				return
			end
			local ok = CameraController.Spectate(target)
			Notifications:Info("Spectate", ok and "Kamera hedefe gecti" or "Hedef bulunamadi")
		end },
		{ type = "button", text = "SPECTATE BITIR", order = 20, onClick = function()
			CameraController.Unspectate()
		end },
		{ type = "toggle", text = "Camera Noclip", default = false, order = 30, onChanged = function(enabled)
			CameraController.SetNoclip(enabled)
		end },
		{ type = "dropdown", text = "Kamera modu", options = { "Classic", "LockFirstPerson", "Scriptable" }, default = "Classic", order = 40, onChanged = function(value)
			CameraController.SetForceMode(value)
		end },
		{ type = "toggle", text = "Admin Cam Block", default = false, order = 50, tooltip = "Baskasinin kamera degistirmesini engeller", onChanged = function(enabled)
			CameraController.BlockAdminCam = enabled
		end },
		{ type = "button", text = "KAMERA YOLU KAYDET", order = 60, onClick = function()
			CameraController.StartPathRecord()
			Notifications:Info("Kamera yolu", "Kayit basladi")
		end },
		{ type = "button", text = "KAMERA YOLU OYNAT", order = 70, onClick = function()
			local ok = CameraController.PlayPath()
			Notifications:Info("Kamera yolu", ok and "Oynatiliyor" or "Kayitli yol yok")
		end },
		{ type = "button", text = "KAMERA YOLU SIL", order = 80, onClick = function()
			CameraController.StopPath()
		end },
		{ type = "button", text = "DISTANCE RADAR", order = 90, onClick = function()
			local list = AdminTools.GetDistanceRadar()
			local lines = {}
			for i = 1, math.min(10, #list) do
				table.insert(lines, string.format("%s - %.1f stud", list[i].Player.DisplayName, list[i].Distance))
			end
			Notifications:Info("Radar", table.concat(lines, " | "))
		end },
		{ type = "button", text = "PING & LATENCY MONITOR", order = 100, onClick = function()
			local lines = {}
			for _, player in ipairs(Players:GetPlayers()) do
				table.insert(lines, player.DisplayName .. ": " .. Utilities.GetPing(player) .. "ms")
			end
			Notifications:Info("Ping", table.concat(lines, " | "))
		end },
	})

	local control = Section.new(tab, { Title = "Oyuncu Kontrolu (yerel)", LayoutOrder = 3 })
	UIKit.BuildRows(control.Content, {
		{ type = "button", text = "TELEPORT TO PLAYER", order = 10, onClick = function()
			local ok, err = AdminTools.TeleportToTarget()
			if ok then
				Notifications:Success("Teleport", ok and "Hedefin yanina isinlandin" or tostring(err))
			else
				Notifications:Error("Teleport", ok and "Hedefin yanina isinlandin" or tostring(err))
			end
		end },
		{ type = "button", text = "BRING PLAYER (yerel illuzyon)", order = 20, onClick = function()
			local ok, err = AdminTools.BringTarget()
			if ok then
				Notifications:Success("Bring", ok and "Hedef senin yanina cekildi (yerel)" or tostring(err))
			else
				Notifications:Error("Bring", ok and "Hedef senin yanina cekildi (yerel)" or tostring(err))
			end
		end },
		{ type = "toggle", text = "FREEZE PLAYER (yerel)", default = false, order = 30, onChanged = function(enabled)
			local ok, err = AdminTools.FreezeTarget(enabled)
			if not ok then
				Notifications:Error("Freeze", tostring(err))
			end
		end },
		{ type = "toggle", text = "MUTE PLAYER (yerel susturma)", default = false, order = 40, onChanged = function(enabled)
			AdminTools.MuteTarget(enabled)
		end },
		{ type = "slider", text = "Yerel boyut carpani", min = 0.4, max = 2.5, step = 0.1, default = 1, order = 50, onChanged = function(value)
			_stateInstance:Set("TargetScale", value)
		end },
		{ type = "button", text = "BOYUTU UYGULA", order = 60, onClick = function()
			local scale = _stateInstance:Get("TargetScale") or 1
			local ok = AdminTools.ScaleAvatar(scale)
			if ok then
				Notifications:Success("Boyut", ok and "Uygulandi" or "Uygulanamadi")
			else
				Notifications:Error("Boyut", ok and "Uygulandi" or "Uygulanamadi")
			end
		end },
		{ type = "button", text = "AVATAR CLONE (yerel)", order = 70, onClick = function()
			local ok, err = AdminTools.CloneAvatar()
			if ok then
				Notifications:Success("Clone", ok and "Avatar klonlandi" or tostring(err))
			else
				Notifications:Error("Clone", ok and "Avatar klonlandi" or tostring(err))
			end
		end },
		{ type = "text", placeholder = "Animation ID", default = "", order = 80, onChanged = function(value)
			_stateInstance:Set("AnimationId", value)
		end },
		{ type = "button", text = "YEREL ANIMASYON OYNAT", order = 90, onClick = function()
			local animationId = _stateInstance:Get("AnimationId")
			if not animationId or animationId == "" then
				Notifications:Error("Animasyon", "Animation ID gir")
				return
			end
			local ok = AdminTools.PlayAnimation(animationId)
			if ok then
				Notifications:Success("Animasyon", ok and "Oynatildi" or "Oynatilamadi")
			else
				Notifications:Error("Animasyon", ok and "Oynatildi" or "Oynatilamadi")
			end
		end },
		{ type = "toggle", text = "TARGET HIGHLIGHTER", default = false, order = 100, onChanged = function(enabled)
			AdminTools.HighlightTarget(enabled)
		end },
		{ type = "text", placeholder = "Ozel isim etiketi", default = "", order = 110, onChanged = function(value)
			_stateInstance:Set("CustomNameTag", value)
		end },
		{ type = "button", text = "ISIM ETIKETINI UYGULA", order = 120, onClick = function()
			local text = _stateInstance:Get("CustomNameTag")
			local ok = AdminTools.SetNameTag(AdminTools.GetTarget(), text)
			if ok then
				Notifications:Success("Isim etiketi", ok and "Guncellendi" or "Guncellenemedi")
			else
				Notifications:Error("Isim etiketi", ok and "Guncellendi" or "Guncellenemedi")
			end
		end },
		{ type = "toggle", text = "YEREL ENGEL LISTESI", default = false, order = 130, onChanged = function(enabled)
			local target = AdminTools.GetTarget()
			if target then
				ChatSystem.BlockList[target.UserId] = enabled and true or nil
			end
		end },
	})

	local env = Section.new(tab, { Title = "Yerel Ortam", LayoutOrder = 4 })
	UIKit.BuildRows(env.Content, {
		{ type = "toggle", text = "LOCAL LIGHT CONTROL", default = false, order = 10, onChanged = function(enabled)
			EnvironmentController.SetLocalLight(enabled)
		end },
		{ type = "slider", text = "Isik mesafesi", min = 10, max = 200, step = 5, default = Config.Physics.WaypointSpeed, order = 20, onChanged = function(value)
			EnvironmentController.LightRange = value
			if EnvironmentController._light then
				EnvironmentController._light.Range = value
			end
		end },
		{ type = "slider", text = "Isik parlakligi", min = 0, max = 10, step = 0.5, default = 2, order = 30, onChanged = function(value)
			EnvironmentController.LightBrightness = value
			if EnvironmentController._light then
				EnvironmentController._light.Brightness = value
			end
		end },
		{ type = "toggle", text = "LOCAL FOG CONTROL", default = false, order = 40, onChanged = function(enabled)
			EnvironmentController.SetFog(enabled, 300)
		end },
		{ type = "slider", text = "Sis mesafesi", min = 50, max = 2000, step = 25, default = 300, order = 50, onChanged = function(value)
			EnvironmentController.SetFog(true, value)
		end },
		{ type = "toggle", text = "PARTICLE MANAGER", default = false, order = 60, tooltip = "Yerel partikulleri gizler/gosterir", onChanged = function(enabled)
			EnvironmentController.ToggleParticles(enabled)
		end },
		{ type = "toggle", text = "MESH HIDER", default = false, order = 70, onChanged = function(enabled)
			EnvironmentController.ToggleMeshes(enabled)
		end },
		{ type = "toggle", text = "LOCAL TIME FREEZE", default = false, order = 80, onChanged = function(enabled)
			EnvironmentController.SetTimeFrozen(enabled)
		end },
		{ type = "toggle", text = "LOCAL MUTE / DEAFEN", default = false, order = 90, onChanged = function(enabled)
			AdminTools.SetLocalMute(enabled)
		end },
	})

	local inspect = Section.new(tab, { Title = "Inceleme & Kayit", LayoutOrder = 5 })
	UIKit.BuildRows(inspect.Content, {
		{ type = "button", text = "PLAYER INSPECTOR", order = 10, onClick = function()
			if AppInstance and AppInstance.Inspector then
				AppInstance.Inspector:SetVisible(true)
			end
		end },
		{ type = "toggle", text = "OBJECT INSPECTOR MODU", default = false, order = 20, tooltip = "Aciklik sonrasi bir nesneye tikla", onChanged = function(enabled)
			AdminTools.ObjectInspectMode = enabled
		end },
		{ type = "button", text = "SOUND CATCHER", order = 30, onClick = function()
			local count = AdminTools.CollectSounds()
			local names = {}
			for i = 1, math.min(5, #AdminTools.SoundList) do
				table.insert(names, AdminTools.SoundList[i].Name)
			end
			Notifications:Info("Sound Catcher", count .. " ses caliyor: " .. table.concat(names, ", "))
		end },
		{ type = "button", text = "ACTIVITY LOGGER", order = 40, onClick = function()
			if AppInstance and AppInstance.ActivityLog then
				AppInstance.ActivityLog:Toggle()
			end
		end },
		{ type = "button", text = "PLAYER STATUS PREDICTOR", order = 50, onClick = function()
			local target = AdminTools.GetTarget()
			if not target then
				Notifications:Error("Status", "Hedef sec")
				return
			end
			Notifications:Info("Status", target.DisplayName .. ": " .. AdminTools.GetPlayerStatus(target))
		end },
		{ type = "button", text = "CHAT FILTER BYPASS (yerel)", order = 60, tooltip = "Filtrelenen mesajlari kendi pencerende gor", onClick = function()
			if AppInstance and AppInstance.ChatWindow then
				AppInstance.ChatWindow:SetVisible(true)
				AppInstance.ChatWindow:Refresh()
			end
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── SOHBET / SOSYAL SEKMESİ ──────────────────────────────────────────────
function MenuBuilder.BuildChat(tab)
	local basic = Section.new(tab, { Title = "Temel Sohbet", LayoutOrder = 1 })
	UIKit.BuildRows(basic.Content, {
		{ type = "toggle", text = "CHAT SPY (canli)", default = true, order = 10, onChanged = function(enabled)
			if AppInstance and AppInstance.ChatWindow then
				AppInstance.ChatWindow:SetVisible(enabled)
			end
		end },
		{ type = "button", text = "HIZLI YANIT: Merhaba", order = 20, onClick = function()
			ChatSystem.Send("Merhaba!")
		end },
		{ type = "button", text = "HIZLI YANIT: Geliyorum", order = 30, onClick = function()
			ChatSystem.Send("Geliyorum!")
		end },
		{ type = "text", placeholder = "Hizli yanit metni", default = "", order = 40, onChanged = function(value)
			_stateInstance:Set("QuickReply", value)
		end },
		{ type = "button", text = "HIZLI YANITI GONDER", order = 50, onClick = function()
			local text = _stateInstance:Get("QuickReply")
			if not text or text == "" then
				Notifications:Error("Hizli yanit", "Once metin gir")
				return
			end
			ChatSystem.Send(text)
		end },
		{ type = "dropdown", text = "Sohbet makrosu", options = (function()
			local names = {}
			for i, macro in ipairs(ChatSystem.Macros) do
				table.insert(names, i .. ") " .. macro.Label)
			end
			return names
		end)(), default = nil, order = 60, onChanged = function(value)
			local index = tonumber(string.match(value, "^(%d+)"))
			local macro = index and ChatSystem.Macros[index]
			if macro then
				ChatSystem.Send(macro.Text)
			end
		end },
		{ type = "text", placeholder = "Yeni makro adi", default = "", order = 70, onChanged = function(value)
			_stateInstance:Set("MacroLabel", value)
		end },
		{ type = "text", placeholder = "Yeni makro metni", default = "", order = 80, onChanged = function(value)
			_stateInstance:Set("MacroText", value)
		end },
		{ type = "button", text = "MAKRO EKLE", order = 90, onClick = function()
			local label = _stateInstance:Get("MacroLabel")
			local text = _stateInstance:Get("MacroText")
			if not label or label == "" or not text or text == "" then
				Notifications:Error("Makro", "Ad ve metin gerekli")
				return
			end
			ChatSystem.AddMacro(label, text)
			Notifications:Success("Makro", "Eklendi: " .. label)
		end },
		{ type = "toggle", text = "FISILTI KAYDEDI", default = false, order = 100, onChanged = function(enabled)
			if enabled and MainApp and AppInstance.ChatWindow then
				AppInstance.ChatWindow.Mode = "Whisper"
				AppInstance.ChatWindow:SetVisible(true)
				AppInstance.ChatWindow:Refresh()
			end
		end },
		{ type = "toggle", text = "MESAJ SABITLEME", default = false, order = 110, onChanged = function(enabled)
			_stateInstance:Set("PinEnabled", enabled)
		end },
		{ type = "toggle", text = "YEREL OZEL DURUM", default = false, order = 120, onChanged = function(enabled)
			_stateInstance:Set("LocalStatus", enabled)
			if enabled then
				ChatSystem.SystemMessage("Yerel durum: " .. ChatSystem.AutoStatusText)
			end
		end },
		{ type = "toggle", text = "SPAM FILTRESI", default = false, order = 130, onChanged = function(enabled)
			ChatSystem.SpamFilter = enabled
		end },
		{ type = "slider", text = "Tekrar siniri", min = 1, max = 10, step = 1, default = Config.Social.SpamMaxRepeat, order = 140, onChanged = function(value)
			ChatSystem.SpamMaxRepeat = value
		end },
		{ type = "toggle", text = "GRUP ETIKETI FILTRESI", default = false, order = 150, onChanged = function(enabled)
			_stateInstance:Set("GroupFilter", enabled)
		end },
		{ type = "text", placeholder = "Gizlenecek grup/rozet", default = "", order = 160, onChanged = function(value)
			_stateInstance:Set("GroupFilterText", value)
		end },
		{ type = "toggle", text = "SESLI SOHBET MENZILI", default = false, order = 170, onChanged = function(enabled)
			if enabled and MainApp and AppInstance.ChatWindow then
				AppInstance.ChatWindow:SetVisible(true)
			end
		end },
		{ type = "slider", text = "Ses menzili (stud)", min = 10, max = 200, step = 5, default = Config.Social.VoiceRange, order = 180, onChanged = function(value)
			Config.Social.VoiceRange = value
		end },
		{ type = "toggle", text = "CEVRIMICI ARKADAS TAKIBI", default = false, order = 190, onChanged = function(enabled)
			_stateInstance:Set("FriendsTracker", enabled)
		end },
	})

	local advanced = Section.new(tab, { Title = "Gelismis Sohbet", LayoutOrder = 2 })
	UIKit.BuildRows(advanced.Content, {
		{ type = "toggle", text = "YEREL SOHBET CEVIRISI", default = false, order = 10, tooltip = "Yerel sozluk ile basit ceviri", onChanged = function(enabled)
			_stateInstance:Set("TranslateEnabled", enabled)
		end },
		{ type = "toggle", text = "CEVIRILI SOHBET GOSTER", default = false, order = 20, onChanged = function(enabled)
			_stateInstance:Set("TranslateDisplay", enabled)
		end },
		{ type = "text", placeholder = "Sohbet rolu etiketi (orn. [Admin])", default = "", order = 30, onChanged = function(value)
			ChatSystem.ChatRoles[LocalPlayer.UserId] = value
		end },
		{ type = "text", placeholder = "Zamanlanmis mesaj metni", default = "", order = 40, onChanged = function(value)
			_stateInstance:Set("ScheduledText", value)
		end },
		{ type = "slider", text = "Zamanlama (sn)", min = 5, max = 600, step = 5, default = 30, order = 50, onChanged = function(value)
			_stateInstance:Set("ScheduledDelay", value)
		end },
		{ type = "button", text = "ZAMANLANMIS MESAJ AYARLA", order = 60, onClick = function()
			local text = _stateInstance:Get("ScheduledText")
			if not text or text == "" then
				Notifications:Error("Zamanlanmis mesaj", "Once metin gir")
				return
			end
			local delay = _stateInstance:Get("ScheduledDelay") or 30
			ChatSystem.ScheduleMessage(text, delay)
			Notifications:Success("Zamanlanmis mesaj", delay .. " sn sonra gonderilecek")
		end },
		{ type = "button", text = "SOHBET DISA AKTAR", order = 70, onClick = function()
			local text, ok = ChatSystem.ExportLog()
			if ok then
				Notifications:Success("Sohbet exportu", ok and "Dosyaya yazildi" or ("Dosya yazilamadi, " .. #text .. " karakter"))
			else
				Notifications:Info("Sohbet exportu", ok and "Dosyaya yazildi" or ("Dosya yazilamadi, " .. #text .. " karakter"))
			end
		end },
		{ type = "toggle", text = "SES DALGASI GORSELLESTIRICI", default = false, order = 80, onChanged = function(enabled)
			_stateInstance:Set("WaveVisualizer", enabled)
		end },
		{ type = "toggle", text = "SOHBET BALONU DUGZENLEYICI", default = false, order = 90, onChanged = function(enabled)
			local ok = false
			if TextChatService then
				ok = pcall(function()
					local config = TextChatService:FindFirstChild("BubbleChatConfiguration")
					if config then
						config.Enabled = enabled
					end
				end)
			end
			if ok then
				Notifications:Success("Sohbet balonu", ok and "Balon gorunurlugu degistirildi" or "Bu oyunda balon yapilandirmasi yok")
			else
				Notifications:Info("Sohbet balonu", ok and "Balon gorunurlugu degistirildi" or "Bu oyunda balon yapilandirmasi yok")
			end
		end },
		{ type = "toggle", text = "YEREL ENGELLEME LISTESI", default = false, order = 100, onChanged = function(enabled)
			_stateInstance:Set("BlockListEnabled", enabled)
		end },
		{ type = "toggle", text = "OTOMATIK DURUM GUNCELLEYICI", default = false, order = 110, onChanged = function(enabled)
			ChatSystem.AutoStatus = enabled
		end },
		{ type = "text", placeholder = "Otomatik durum metni", default = ChatSystem.AutoStatusText, order = 120, onChanged = function(value)
			ChatSystem.AutoStatusText = value
		end },
		{ type = "slider", text = "Durum araligi (sn)", min = 30, max = 900, step = 30, default = ChatSystem.AutoStatusInterval, order = 130, onChanged = function(value)
			ChatSystem.AutoStatusInterval = value
		end },
		{ type = "toggle", text = "GELISMIS FISILTI YONETICISI", default = false, order = 140, onChanged = function(enabled)
			_stateInstance:Set("WhisperManager", enabled)
		end },
		{ type = "toggle", text = "SOHBET TEMIZLEYICI", default = false, order = 150, tooltip = "Sistem mesajlarini ve reklamlari gizler", onChanged = function(enabled)
			_stateInstance:Set("ChatCleaner", enabled)
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── ERİŞİLEBİLİRLİK SEKMESİ (10 özellik) ─────────────────────────────────
function MenuBuilder.BuildAccessibility(tab)
	local section = Section.new(tab, { Title = "Erisilebilirlik", LayoutOrder = 1 })
	UIKit.BuildRows(section.Content, {
		{ type = "toggle", text = "TEK EL MODU", default = false, order = 10, onChanged = function(enabled)
			Accessibility.SetOneHand(enabled)
		end },
		{ type = "toggle", text = "YUKSEK KONTRAST METIN", default = false, order = 20, onChanged = function(enabled)
			Accessibility.SetHighContrast(enabled)
			if AppInstance and AppInstance.Window then
				AppInstance.Window:ApplyTheme()
			end
		end },
		{ type = "toggle", text = "TTS (ekran okuyucu)", default = false, order = 30, onChanged = function(enabled)
			Accessibility.Enabled.TTS = enabled
			if enabled then
				Notifications:Info("TTS", "Aktif - menu metinleri okunabilir")
			end
		end },
		{ type = "button", text = "MENU METNINI OKU", order = 40, onClick = function()
			local ok = Accessibility.Speak("X Menu V52 hazir. Sayfa: " .. tostring(_stateInstance:Get("CurrentTab")))
			if ok then
				Notifications:Success("TTS", ok and "Okundu" or "TTS bu istemcide calismiyor")
			else
				Notifications:Error("TTS", ok and "Okundu" or "TTS bu istemcide calismiyor")
			end
		end },
		{ type = "toggle", text = "OZEL IMLEC", default = false, order = 50, onChanged = function(enabled)
			Accessibility.SetCustomCursor(enabled)
		end },
		{ type = "slider", text = "Imlec boyutu", min = 8, max = 48, step = 2, default = Accessibility.CursorSize, order = 60, onChanged = function(value)
			Accessibility.CursorSize = value
			if Accessibility._cursor then
				Accessibility._cursor.Size = UDim2.fromOffset(value, value)
			end
		end },
		{ type = "toggle", text = "BASILI TUT MODU", default = false, order = 70, onChanged = function(enabled)
			Accessibility.Enabled.HoldMode = enabled
		end },
		{ type = "toggle", text = "HAREKETLE KONTROL (SWIPE)", default = false, order = 80, onChanged = function(enabled)
			Accessibility.Enabled.Swipe = enabled
		end },
		{ type = "toggle", text = "DOKUNSAL GERI BILDIRIM", default = false, order = 90, onChanged = function(enabled)
			Accessibility.SetHaptics(enabled)
		end },
		{ type = "toggle", text = "RENK KORLUGU MODU", default = false, order = 100, onChanged = function(enabled)
			Accessibility.SetColorBlind(enabled)
			if AppInstance and AppInstance.Window then
				AppInstance.Window:ApplyTheme()
			end
		end },
		{ type = "slider", text = "Joystick olu bolge", min = 0, max = 0.9, step = 0.05, default = Config.Accessibility.JoystickDeadzone, order = 110, onChanged = function(value)
			Accessibility.SetDeadzone(value)
		end },
		{ type = "toggle", text = "KLAVYE ILE NAVIGASYON", default = false, order = 120, onChanged = function(enabled)
			Accessibility.Enabled.KeyboardNav = enabled
		end },
		{ type = "button", text = "KISAYOLLAR", order = 130, onClick = function()
			Notifications:Info("Kisayollar", "F1 menu | F2 widget | F3 fly | F4 casus | F5 sohbet | F6 tema | ; komut paneli")
		end },
	})

	local shortcut = Section.new(tab, { Title = "Erisilebilirlik Kisayollari", LayoutOrder = 2 })
	UIKit.BuildRows(shortcut.Content, {
		{ type = "keybind", text = "Widget kisayolu", default = Config.Keys.Widgets, order = 10, onChanged = function(key)
			Config.Keys.Widgets = key
		end },
		{ type = "keybind", text = "Fly panel kisayolu", default = Config.Keys.FlyPanel, order = 20, onChanged = function(key)
			Config.Keys.FlyPanel = key
		end },
		{ type = "keybind", text = "Sohbet casusu kisayolu", default = Config.Keys.Spy, order = 40, onChanged = function(key)
			Config.Keys.Spy = key
		end },
		{ type = "keybind", text = "Tema kisayolu", default = Config.Keys.Theme, order = 50, onChanged = function(key)
			Config.Keys.Theme = key
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── ANALİTİK SEKMESİ ─────────────────────────────────────────────────────
function MenuBuilder.BuildAnalytics(tab)
	local widgets = Section.new(tab, { Title = "Widget Sistemi", LayoutOrder = 1 })
	UIKit.BuildRows(widgets.Content, {
		{ type = "toggle", text = "FPS WIDGET", default = false, order = 10, onChanged = function(enabled)
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("FPS", enabled)
			end
		end },
		{ type = "toggle", text = "PING WIDGET", default = false, order = 20, onChanged = function(enabled)
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("Ping", enabled)
			end
		end },
		{ type = "toggle", text = "TIME WIDGET", default = false, order = 30, onChanged = function(enabled)
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("Time", enabled)
			end
		end },
		{ type = "toggle", text = "PROFILER WIDGET", default = false, order = 40, onChanged = function(enabled)
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("Profiler", enabled)
			end
		end },
		{ type = "toggle", text = "GRAF WIDGET", default = false, order = 50, onChanged = function(enabled)
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("Graph", enabled)
			end
		end },
		{ type = "button", text = "TUM WIDGETLARI AC", order = 60, onClick = function()
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:ToggleAll()
			end
		end },
	})

	local info = Section.new(tab, { Title = "Bilgi & Analitik", LayoutOrder = 2 })
	UIKit.BuildRows(info.Content, {
		{ type = "button", text = "FPS & PING GRAFIGI", order = 10, onClick = function()
			if AppInstance and AppInstance.Widgets then
				AppInstance.Widgets:SetVisible("Graph", true)
				AppInstance.Widgets:SetVisible("FPS", true)
				AppInstance.Widgets:SetVisible("Ping", true)
			end
		end },
		{ type = "button", text = "SUNUCU BOLGE TESPITCISI", order = 20, onClick = function()
			Notifications:Info("Sunucu", Analytics.GetServerInfo() .. " | Bolge(oyuncu): " .. Analytics.GetRegion())
		end },
		{ type = "button", text = "OYNANMA SURESI", order = 30, onClick = function()
			Notifications:Info("Oynanma suresi", Utilities.FormatTime(Analytics.PlayTime))
		end },
		{ type = "button", text = "AG PAKETI MONITORU", order = 40, onClick = function()
			local down = Stats.DataReceiveKbps or 0
			local up = Stats.DataSendKbps or 0
			Notifications:Info("Ag", string.format("Alinan: %.1f KB/s | Gonderilen: %.1f KB/s", down, up))
		end },
		{ type = "button", text = "OYUN SURUMU KONTROLU", order = 50, onClick = function()
			Notifications:Info("Surum", Analytics.GetRobloxVersion())
		end },
		{ type = "toggle", text = "YEREL FPS KILIDI (arayuz)", default = false, order = 60, tooltip = "Motor FPS'i kilitleyemez; menu yenilemesini sinirlar", onChanged = function(enabled)
			_stateInstance:Set("FpsLock", enabled)
			Config.Analytics.RefreshRate = enabled and 1 or 0.5
		end },
		{ type = "button", text = "BELLEK KULLANIM GOSTERGESI", order = 70, onClick = function()
			Notifications:Info("Bellek", Analytics.GetMemory())
		end },
		{ type = "button", text = "GIRIS GECIKMESI TESTI", order = 80, onClick = function()
			Notifications:Info("Gecikme testi", Analytics.TestLatency())
		end },
		{ type = "button", text = "SUNUCU TICK RATE", order = 90, onClick = function()
			Notifications:Info("Tick rate", tostring(Analytics.GetTickRate()) .. " Hz (yerel olcum)")
		end },
		{ type = "button", text = "PROFILER (performans izleyici)", order = 100, onClick = function()
			Notifications:Info("Profiler", string.format("Frame %.2f ms | Heartbeat %.2f ms | Instance %d",
				(Stats.FrameTime or 0) * 1000, (Stats.HeartbeatTimeMs or 0), Stats.InstanceCount or 0))
		end },
		{ type = "button", text = "BILGI PANELINI GUNCELLE", order = 110, onClick = function()
			Notifications:Info("Guncel", Analytics.GetServerInfo())
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── ARAYÜZ SEKMESİ (10 gelişmiş UI özelliği) ─────────────────────────────
function MenuBuilder.BuildInterface(tab)
	local section = Section.new(tab, { Title = "Gelisimis Arayuz", LayoutOrder = 1 })
	UIKit.BuildRows(section.Content, {
		{ type = "toggle", text = "HAREKETLI ARKA PLAN", default = true, order = 10, onChanged = function(enabled)
			_stateInstance:Set("AnimatedBackground", enabled)
			if AppInstance and AppInstance.Window then
				AppInstance.Window.BackgroundGradient.Parent.Visible = enabled
			end
		end },
		{ type = "toggle", text = "WIDGET SISTEMI (panel)", default = true, order = 20, onChanged = function(enabled)
			_stateInstance:Set("WidgetPanel", enabled)
		end },
		{ type = "text", placeholder = "Tema JSON (disa aktar)", default = "", order = 30, onChanged = function(value)
			_stateInstance:Set("ThemeExport", value)
		end },
		{ type = "button", text = "TEMAYI DISA AKTAR", order = 40, onClick = function()
			local payload = {
				Accent = { Theme.Accent.R, Theme.Accent.G, Theme.Accent.B },
				Scale = Config.Menu.Scale,
				SoundPack = Config.Menu.SoundPack,
				Watermark = Config.Menu.WatermarkText,
			}
			local json = HttpService:JSONEncode(payload)
			_stateInstance:Set("ThemeExport", json)
			Notifications:Success("Tema exportu", "Metin kutusuna yazildi, kopyalayabilirsin")
		end },
		{ type = "text", placeholder = "Tema JSON (ice aktar)", default = "", order = 50, onChanged = function(value)
			_stateInstance:Set("ThemeImport", value)
		end },
		{ type = "button", text = "TEMAYI ICE AKTAR", order = 60, onClick = function()
			local json = _stateInstance:Get("ThemeImport")
			if not json or json == "" then
				Notifications:Error("Tema", "Once JSON yapistir")
				return
			end
			local ok, data = pcall(function()
				return HttpService:JSONDecode(json)
			end)
			if ok and type(data) == "table" and data.Accent then
				Theme.Accent = Color3.new(data.Accent[1], data.Accent[2], data.Accent[3])
				if AppInstance and AppInstance.Window then
					AppInstance.Window:ApplyTheme()
				end
				Notifications:Success("Tema", "Ice aktarildi")
			else
				Notifications:Error("Tema", "Gecersiz JSON")
			end
		end },
		{ type = "dropdown", text = "Ozel font", options = { "Gotham", "GothamBold", "Code", "Foundation", "SciFi", "PermanentMarker" }, default = "Gotham", order = 70, onChanged = function(value)
			_stateInstance:Set("FontName", value)
		end },
		{ type = "dropdown", text = "Menu ses kartlari", options = { "Default", "Soft", "Retro" }, default = Config.Menu.SoundPack, order = 80, onChanged = function(value)
			Config.Menu.SoundPack = value
		end },
		{ type = "dropdown", text = "Bildirim konumu", options = { "Top", "Bottom" }, default = Config.Notification.Position, order = 90, onChanged = function(value)
			Config.Notification.Position = value
		end },
		{ type = "dropdown", text = "Ekran olcegi on ayarlari", options = { "0.8", "0.9", "1.0", "1.1", "1.2" }, default = "1.0", order = 100, onChanged = function(value)
			local number = tonumber(value) or 1
			if AppInstance and AppInstance.Window then
				AppInstance.Window:ApplyScale(number)
			end
		end },
		{ type = "toggle", text = "KATLANABILIR SEKMELER", default = true, order = 110, onChanged = function(enabled)
			_stateInstance:Set("CollapsibleSections", enabled)
		end },
		{ type = "dropdown", text = "Ozel ikon seti", options = { "Emoji", "Sembol", "Minimal" }, default = Config.Menu.IconSet, order = 120, onChanged = function(value)
			Config.Menu.IconSet = value
		end },
	})

	AddCancelRow(tab, 900)
end

-- ── KOMUTLAR SEKMESİ ─────────────────────────────────────────────────────
function MenuBuilder.BuildCommands(tab)
	local section = Section.new(tab, { Title = "Komut Sistemi", LayoutOrder = 1 })
	UIKit.BuildRows(section.Content, {
		{ type = "text", placeholder = "Komut gir (Enter ile calistir)", default = "", order = 10, onChanged = function(value)
			_stateInstance:Set("CommandDraft", value)
		end },
		{ type = "button", text = "KOMUTU CALISTIR", order = 20, onClick = function()
			local draft = _stateInstance:Get("CommandDraft")
			if not draft or draft == "" then
				Notifications:Error("Komut", "Once komut gir")
				return
			end
			CommandSystem.Run(draft, "menu")
		end },
		{ type = "button", text = "GECMISI TEMIZLE", order = 30, onClick = function()
			table.clear(CommandSystem.History)
			Notifications:Info("Komut", "Gecmis temizlendi")
		end },
		{ type = "button", text = "TUM KOMUTLARI GOSTER", order = 40, onClick = function()
			local names = CommandSystem.List()
			Notifications:Info("Komutlar (" .. #names .. ")", table.concat(names, ", "))
		end },
	})

	local listSection = Section.new(tab, { Title = "Kayitli Komutlar", LayoutOrder = 2 })
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1, 0, 0, 220)
	listFrame.BackgroundTransparency = 1
	listFrame.BorderSizePixel = 0
	listFrame.ScrollBarThickness = 3
	listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	listFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	listFrame.Parent = listSection.Content

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 3)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = listFrame

	for _, name in ipairs(CommandSystem.List()) do
		local command = CommandSystem.Commands[name]
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -6, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.BackgroundTransparency = 1
		label.Text = string.format("%s  -  %s", command.Usage or name, command.Description or "")
		label.TextColor3 = Config.Theme.TextSecondary
		label.Font = Enum.Font.Gotham
		label.TextSize = 11
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = listFrame
	end

	AddCancelRow(tab, 900)
end

-- ── ARA SEKMESİ (arama + örnek feature) ──────────────────────────────────
function MenuBuilder.BuildSearch(tab)
	local searchSection = Section.new(tab, { Title = "Ozelliklerde Ara", LayoutOrder = 1 })
	local searchBar = SearchBar.new(searchSection.Content, {
		Placeholder = "Ozellik ara (orn. fling, widget, sohbet)...",
		LayoutOrder = 1,
	})

	local results = Section.new(tab, { Title = "Sonuclar", LayoutOrder = 2 })
	local resultFrame = Instance.new("ScrollingFrame")
	resultFrame.Size = UDim2.new(1, 0, 0, 200)
	resultFrame.BackgroundTransparency = 1
	resultFrame.BorderSizePixel = 0
	resultFrame.ScrollBarThickness = 3
	resultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	resultFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
	resultFrame.Parent = results.Content

	local resultLayout = Instance.new("UIListLayout")
	resultLayout.Padding = UDim.new(0, 3)
	resultLayout.SortOrder = Enum.SortOrder.LayoutOrder
	resultLayout.Parent = resultFrame

	local function renderResults(query)
		for _, child in ipairs(resultFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		local lower = string.lower(query or "")
		local order = 0
		for id, feature in pairs(UIKit.Features) do
			if lower == "" or string.find(string.lower(feature.Name), lower, 1, true)
				or string.find(string.lower(feature.Category or ""), lower, 1, true) then
				order = order + 1
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -6, 0, 0)
				btn.AutomaticSize = Enum.AutomaticSize.Y
				btn.BackgroundTransparency = 1
				btn.Text = string.format("%s  (%s)", feature.Name, feature.Category or "")
				btn.TextColor3 = Config.Theme.TextSecondary
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 11
				btn.TextWrapped = true
				btn.TextXAlignment = Enum.TextXAlignment.Left
				btn.AutoButtonColor = false
				btn.LayoutOrder = order
				btn.Parent = resultFrame
				Utilities.SafeCall(function()
					btn.MouseButton1Click:Connect(function()
						if feature.Action then
							feature.Action()
						end
					end)
				end)
			end
		end
	end

	searchBar.Janitor:Connect(searchBar.Instance:GetPropertyChangedSignal("Text"), function()
		renderResults(searchBar.Instance.Text)
	end)
	renderResults("")

	-- Orijinal ornek feature korundu
	ExampleFeature.BuildUI(tab, Notifications)

	AddCancelRow(tab, 900)
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 13: ÖRNEK FEATURE (orijinal dosyadan korundu)
-- ──────────────────────────────────────────────────────────────────────────

ExampleFeature = {}

function ExampleFeature.BuildUI(page, notifications)
	local Lighting = Services.Lighting
	local SoundService = Services.SoundService
	local Workspace = Services.Workspace

	local videoSection = Section.new(page, { Title = "Görüntü", LayoutOrder = 3 })

	Slider.new(videoSection.Content, {
		Text = "Kamera Görüş Açısı (FOV)",
		Min = 60, Max = 100, Step = 1, Default = 70,
		LayoutOrder = 1,
		OnChanged = function(value)
			local camera = Workspace.CurrentCamera
			if camera then
				camera.FieldOfView = value
			end
		end,
	})

	Toggle.new(videoSection.Content, {
		Text = "Basit Grafikler (performans modu)",
		Default = false,
		LayoutOrder = 2,
		OnChanged = function(enabled)
			Lighting.GlobalShadows = not enabled
			if notifications then
				notifications:Notify({
					Title = "Grafik Modu",
					Text = enabled and "Performans modu açıldı" or "Performans modu kapatıldı",
					Type = "Info",
				})
			end
		end,
	})

	local audioSection = Section.new(page, { Title = "Ses", LayoutOrder = 4 })

	Slider.new(audioSection.Content, {
		Text = "Genel Ses Seviyesi",
		Min = 0, Max = 1, Step = 0.05, Default = SoundService.Volume or 1,
		LayoutOrder = 1,
		OnChanged = function(value)
			SoundService.Volume = value
		end,
	})

	local resetSection = Section.new(page, { Title = "Sıfırlama", LayoutOrder = 5 })

	Button.new(resetSection.Content, {
		Text = "Ayarları Sıfırla",
		Color = Config.Theme.AccentDark,
		LayoutOrder = 1,
		OnClick = function()
			ConfirmDialog.Show({
				Title = "Ayarları sıfırla?",
				Text = "Görüntü ve ses ayarları varsayılana dönecek.",
				ConfirmText = "Sıfırla",
				CancelText = "Vazgeç",
				OnConfirm = function()
					local camera = Workspace.CurrentCamera
					if camera then
						camera.FieldOfView = 70
					end
					Lighting.GlobalShadows = true
					SoundService.Volume = 1
					if notifications then
						notifications:Notify({
							Title = "Sıfırlandı",
							Text = "Ayarlar varsayılana döndürüldü.",
							Type = "Success",
						})
					end
				end,
			})
		end,
	})
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 14: ÖZELLİK KAYDI (arama sekmesi ve hızlı erişim için)
-- ──────────────────────────────────────────────────────────────────────────

UIKit.RegisterFeature("fling", "Hibrit Fling", "Fizik", "Oyunculari ApplyImpulse -> LinearVelocity -> AssemblyLinearVelocity zinciriyle firlatir", function()
	local target = AdminTools.GetTarget()
	if not target then
		Notifications:Error("Fling", "Once hedef sec")
		return
	end
	local root = Utilities.GetRootPart(Utilities.GetCharacter(target))
	if root then
		PhysicsEngine.ApplyImpulse(root, Vector3.new(0, Config.Physics.FlingPowerDefault, 0))
	end
end)

UIKit.RegisterFeature("fly", "Karakter Ucusu", "Fizik", "Karakteri hizli hareket ettirir", function()
	CharacterController.SetFly(not CharacterController.Flying)
end)

UIKit.RegisterFeature("noclip", "Noclip", "Fizik", "Duvarlardan gecer", function()
	CharacterController.SetNoclip(not CharacterController.Noclip)
end)

UIKit.RegisterFeature("vehiclefly", "Arac Ucusu", "Fizik", "Araci havada uçurur (AlignPosition + LinearVelocity)", function()
	local ok, err = VehicleController.SetFly(not VehicleController.Flying)
	if not ok then
		Notifications:Error("Arac ucusu", tostring(err))
	end
end)

UIKit.RegisterFeature("waypoint", "Waypoint", "Fizik", "Iki nokta arasinda durmadan gidip gelir", function()
	WaypointController.Stop()
	Notifications:Info("Waypoint", "Fizik sekmesinden nokta gir")
end)

UIKit.RegisterFeature("track", "Track & Spam Kill", "Fizik", "Hedefi takip edip firlatir", function()
	TrackController.Stop()
	TrackController.Clear()
	Notifications:Info("Track", "Fizik sekmesinden hedef ekle")
end)

UIKit.RegisterFeature("spectate", "Spectate", "Admin", "Secili oyuncunun kamerasina gecer", function()
	local target = AdminTools.GetTarget()
	if target then
		CameraController.Spectate(target)
	end
end)

UIKit.RegisterFeature("teleport", "Teleport to Player", "Admin", "Hedefin yanina isinlanir", function()
	AdminTools.TeleportToTarget()
end)

UIKit.RegisterFeature("bring", "Bring Player", "Admin", "Hedefi yerel illuzyonla yanina ceker", function()
	AdminTools.BringTarget()
end)

UIKit.RegisterFeature("freeze", "Local Freeze", "Admin", "Hedefi sadece kendi ekraninda dondurur", function()
	AdminTools.FreezeTarget(not (AdminTools.FrozenTarget ~= nil))
end)

UIKit.RegisterFeature("spy", "Chat Spy", "Sosyal", "Tum sohbet mesajlarini gizlice gorur", function()
	if AppInstance and AppInstance.ChatWindow then
		AppInstance.ChatWindow:Toggle()
	end
end)

UIKit.RegisterFeature("inspector", "Player Inspector", "Admin", "Oyuncu ID, yas, ping bilgisi", function()
	if AppInstance and AppInstance.Inspector then
		AppInstance.Inspector:SetVisible(true)
	end
end)

UIKit.RegisterFeature("nametag", "Name Tag Customizer", "Admin", "Oyuncu isim etiketini yerel degistirir", function()
	Notifications:Info("Isim etiketi", "Oyuncu sekmesinden metin gir")
end)

UIKit.RegisterFeature("cameranoclip", "Camera Noclip", "Admin", "Kamera duvarlarin icinden gecer", function()
	CameraController.SetNoclip(not CameraController.Noclip)
end)

UIKit.RegisterFeature("widgets", "Widget Sistemi", "Arayuz", "Suruklenebilir FPS/Ping/Saat widgetlari", function()
	if AppInstance and AppInstance.Widgets then
		AppInstance.Widgets:ToggleAll()
	end
end)

UIKit.RegisterFeature("macros", "Sohbet Makrolari", "Sosyal", "Hazir mesaj sablonlari", function()
	Notifications:Info("Makrolar", "Sohbet sekmesinden duzenlenir")
end)

UIKit.RegisterFeature("whisper", "Fisilti Kaydedici", "Sosyal", "Ozel mesajlari kaydeder", function()
	if AppInstance and AppInstance.ChatWindow then
		AppInstance.ChatWindow.Mode = "Whisper"
		AppInstance.ChatWindow:SetVisible(true)
		AppInstance.ChatWindow:Refresh()
	end
end)

UIKit.RegisterFeature("search", "Chat Search", "Sosyal", "Sohbet gecmisinde arama", function()
	if AppInstance and AppInstance.ChatWindow then
		AppInstance.ChatWindow.Mode = "Search"
		AppInstance.ChatWindow:SetVisible(true)
		AppInstance.ChatWindow:Refresh()
	end
end)

UIKit.RegisterFeature("pin", "Mesaj Sabitleme", "Sosyal", "Onemli mesajlari ekranda sabitler", function()
	_stateInstance:Set("PinEnabled", not _stateInstance:Get("PinEnabled"))
end)

UIKit.RegisterFeature("contrast", "Yuksek Kontrast", "Erisilebilirlik", "Yuksek kontrastli palet", function()
	Accessibility.SetHighContrast(not Accessibility.Enabled.HighContrast)
end)

UIKit.RegisterFeature("colorblind", "Renk Korlugu Modu", "Erisilebilirlik", "Renk korlugu dostu palet", function()
	Accessibility.SetColorBlind(not Accessibility.Enabled.ColorBlind)
end)

UIKit.RegisterFeature("onehand", "Tek El Modu", "Erisilebilirlik", "Tek elle erisilebilir yerlesim", function()
	Accessibility.SetOneHand(not Accessibility.Enabled.OneHand)
end)

UIKit.RegisterFeature("tts", "TTS (Ekran Okuyucu)", "Erisilebilirlik", "Menu metinlerini sesli okur", function()
	Accessibility.Speak("X Menu V52 hazir.")
end)

UIKit.RegisterFeature("cursor", "Ozel Imlec", "Erisilebilirlik", "Kendi imlecini cizer", function()
	Accessibility.SetCustomCursor(not Accessibility.Enabled.CustomCursor)
end)

UIKit.RegisterFeature("haptic", "Dokunsal Geri Bildirim", "Erisilebilirlik", "Mobilde titreme (HapticEffect)", function()
	Accessibility.SetHaptics(not Accessibility.Enabled.Haptics)
	Accessibility.Haptic("UIClick")
end)

UIKit.RegisterFeature("deadzone", "Joystick Olu Bolge", "Erisilebilirlik", "Joystick olu bolge ayari", function()
	Notifications:Info("Olu bolge", "Deger: " .. tostring(Accessibility.Deadzone))
end)

UIKit.RegisterFeature("keyboardnav", "Klavye Navigasyon", "Erisilebilirlik", "Ok tuslariyla menu gezinimi", function()
	Accessibility.Enabled.KeyboardNav = not Accessibility.Enabled.KeyboardNav
end)

UIKit.RegisterFeature("tickrate", "Sunucu Tick Rate", "Analitik", "Yerel olcum ile tick rate", function()
	Notifications:Info("Tick rate", tostring(Analytics.GetTickRate()) .. " Hz")
end)

UIKit.RegisterFeature("memory", "Bellek Kullanimi", "Analitik", "Instance ve bellek gostergesi", function()
	Notifications:Info("Bellek", Analytics.GetMemory())
end)

UIKit.RegisterFeature("latency", "Giris Gecikmesi Testi", "Analitik", "HTTP istek suresi ile gecikme olcumu", function()
	Notifications:Info("Gecikme", Analytics.TestLatency())
end)

UIKit.RegisterFeature("version", "Oyun Surumu Kontrolu", "Analitik", "Yerel surum / place / job bilgisi", function()
	Notifications:Info("Surum", Analytics.GetRobloxVersion() .. " | " .. Analytics.GetServerInfo())
end)

UIKit.RegisterFeature("region", "Sunucu Bolge Tespitcisi", "Analitik", "Locale ve bolge bilgisi", function()
	Notifications:Info("Bolge", Analytics.GetServerInfo() .. " | Bolge: " .. Analytics.GetRegion())
end)

UIKit.RegisterFeature("netmon", "Ag Paketi Monitoru", "Analitik", "Alinan/gonderilen KB/s", function()
	Notifications:Info("Ag", string.format("Alinan %.1f KB/s | Gonderilen %.1f KB/s", Stats.DataReceiveKbps or 0, Stats.DataSendKbps or 0))
end)

UIKit.RegisterFeature("playtime", "Oynanma Suresi", "Analitik", "Oturum suresi", function()
	Notifications:Info("Oynanma suresi", Utilities.FormatTime(Analytics.PlayTime))
end)

UIKit.RegisterFeature("watermark", "Watermark Duzenleyici", "Arayuz", "Watermark metni, boyutu ve konumu", function()
	Notifications:Info("Watermark", Config.Menu.WatermarkText)
end)

UIKit.RegisterFeature("themeexport", "Tema Ice/Disa Aktarma", "Arayuz", "Tema JSON olarak aktarilir", function()
	Notifications:Info("Tema", "Arayuz sekmesinden JSON alabilirsin")
end)

UIKit.RegisterFeature("quickbar", "Hizli Erisim Cubugu", "Arayuz", "Baslik barindaki hizli butonlar", function()
	Config.Menu.QuickBar = not Config.Menu.QuickBar
end)

UIKit.RegisterFeature("autohide", "Otomatik Gizleme", "Arayuz", "Hareketsizlikte menuyu gizler", function()
	Config.Menu.AutoHide = not Config.Menu.AutoHide
end)

UIKit.RegisterFeature("minimode", "Minimalist Mod", "Arayuz", "Sade gorunum", function()
	Config.Menu.Minimalist = not Config.Menu.Minimalist
	Notifications:Info("Minimalist", Config.Menu.Minimalist and "Acik" or "Kapali")
end)

UIKit.RegisterFeature("keybind", "Ozel Tus Atayici", "Arayuz", "Tum kisayollari degistir", function()
	Notifications:Info("Tus atayici", "Ana sekmeden tuslari degistirebilirsin")
end)

UIKit.RegisterFeature("history", "Komut Gecmisi", "Arayuz", "Calistirilan komutlarin gecmisi", function()
	Notifications:Info("Gecmis", #CommandSystem.History .. " komut kayitli")
end)

UIKit.RegisterFeature("sounds", "Menu Ses Paketi", "Arayuz", "UI sesleri", function()
	Utilities.PlayUI("Open")
	Notifications:Info("Ses", "Paket: " .. Config.Menu.SoundPack)
end)

UIKit.RegisterFeature("notificationqueue", "Bildirim Kuyrugu", "Arayuz", "Bildirim sirasi", function()
	Config.Notification.MaxVisible = Config.Notification.MaxVisible == 3 and 1 or 3
	Notifications:Info("Bildirim", "Maks: " .. Config.Notification.MaxVisible)
end)

UIKit.RegisterFeature("tooltip", "Baglamsal Ipuclari", "Arayuz", "Uzerine gelince ipucu", function()
	_stateInstance:Set("TooltipsEnabled", not _stateInstance:Get("TooltipsEnabled"))
end)

UIKit.RegisterFeature("scale", "Ekran Olcegi", "Arayuz", "Menu olcegi on ayarlari", function()
	Notifications:Info("Olcek", tostring(Config.Menu.Scale))
end)

UIKit.RegisterFeature("collapsible", "Katlanabilir Sekmeler", "Arayuz", "Bolumleri kapatma", function()
	_stateInstance:Set("CollapsibleSections", not _stateInstance:Get("CollapsibleSections"))
end)

UIKit.RegisterFeature("icons", "Ozel Ikon Yukleyici", "Arayuz", "Sekme ikon seti", function()
	Notifications:Info("Ikon seti", Config.Menu.IconSet)
end)

UIKit.RegisterFeature("commandpanel", "Sessiz Komut Paneli", "Komut", "; prefix ile sessiz komut girisi", function()
	if AppInstance and AppInstance.CommandPanel then
		AppInstance.CommandPanel:Toggle()
	end
end)

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 15: ANA UYGULAMA (pencere kurulumu, girdi, sohbet, ana dongu)
-- ──────────────────────────────────────────────────────────────────────────

MainApp = {}
MainApp.__index = MainApp

function MainApp.new()
	local self = setmetatable({}, MainApp)
	self.Janitor = Cleanup.new()
	self.Features = {}
	self._keyStates = {}
	self._lastInput = os.clock()
	self._lastActivity = 0
	self._swipeStart = nil
	self._focusables = {}
	self._focusIndex = 1
	return self
end

function MainApp:Initialize()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "X52_Windows"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 250
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	self.Janitor:Add(screenGui)
	self.ScreenGui = screenGui

	self.Notifications = Notifications

	self.PasswordScreen = PasswordScreen.new(self.Notifications)
	self.PasswordScreen.OnUnlock = function()
		self:_onUnlocked()
	end
	self.Janitor:AddChild(self.PasswordScreen.Janitor)

	CommandSystem.Init()
	self:_setupChatHooks()
	self:_setupInput()

	return self
end

function MainApp:_onUnlocked()
	if self.Window then
		return
	end

	self.Window = MainWindow.new(self.ScreenGui)
	self.Window:SetTitle("X MENU V52")
	self.Janitor:AddChild(self.Window.Janitor)

	self.Tabs = TabSystem.new(self.Window.TabBarContainer, self.Window.PageAreaContainer)
	self.Janitor:AddChild(self.Tabs.Janitor)

	self.Widgets = WidgetManager.new(self.ScreenGui)
	self.Janitor:AddChild(self.Widgets.Janitor)

	self.CommandPanel = CommandPanel.new(self.ScreenGui)
	self.Janitor:AddChild(self.CommandPanel.Janitor)

	self.FlyPanel = FlyPanel.new(self.ScreenGui)
	self.Janitor:AddChild(self.FlyPanel.Janitor)

	self.ChatWindow = ChatWindow.new(self.ScreenGui)
	self.Janitor:AddChild(self.ChatWindow.Janitor)

	self.Inspector = InspectorWindow.new(self.ScreenGui)
	self.Janitor:AddChild(self.Inspector.Janitor)

	self.ActivityLog = ActivityLogWindow.new(self.ScreenGui)
	self.Janitor:AddChild(self.ActivityLog.Janitor)

	local homeTab = self.Tabs:AddTab("Home", "🏠 Ana")
	local physicsTab = self.Tabs:AddTab("Physics", "⚡ Fizik")
	local playerTab = self.Tabs:AddTab("Players", "👤 Oyuncu")
	local chatTab = self.Tabs:AddTab("Chat", "💬 Sohbet")
	local accessTab = self.Tabs:AddTab("Access", "♿ Erisilebilirlik")
	local analyticsTab = self.Tabs:AddTab("Analytics", "📊 Analitik")
	local uiTab = self.Tabs:AddTab("Interface", "🎨 Arayuz")
	local commandTab = self.Tabs:AddTab("Commands", "⌨️ Komutlar")
	local searchTab = self.Tabs:AddTab("Search", "🔍 Ara")

	MenuBuilder.BuildHome(homeTab)
	MenuBuilder.BuildPhysics(physicsTab)
	MenuBuilder.BuildPlayers(playerTab)
	MenuBuilder.BuildChat(chatTab)
	MenuBuilder.BuildAccessibility(accessTab)
	MenuBuilder.BuildAnalytics(analyticsTab)
	MenuBuilder.BuildInterface(uiTab)
	MenuBuilder.BuildCommands(commandTab)
	MenuBuilder.BuildSearch(searchTab)

	self.Tabs:SelectTab("Home")

	-- Hizli erisim cubugu
	self.Window:AddQuickAction("⚡", function()
		CharacterController.SetFly(not CharacterController.Flying)
	end)
	self.Window:AddQuickAction("◈", function()
		if self.Widgets then
			self.Widgets:ToggleAll()
		end
	end)
	self.Window:AddQuickAction("⌨", function()
		if self.CommandPanel then
			self.CommandPanel:Toggle()
		end
	end)
	self.Window:AddQuickAction("👤", function()
		if self.Inspector then
			self.Inspector:SetVisible(true)
		end
	end)

	self.Notifications:Notify({
		Title = "Hoş Geldin",
		Text = "X MENU V52 by XRIPX hazır. F1 menü, ; komut paneli.",
		Type = "Success",
	})
end

-- ── Sohbet kancalari ──────────────────────────────────────────────────────
function MainApp:_setupChatHooks()
	local connections = {}

	local function attach(player)
		if connections[player] then
			return
		end
		connections[player] = player.Chatted:Connect(function(message)
			if type(message) ~= "string" then
				return
			end
			if player == LocalPlayer then
				return
			end
			if ChatSystem.BlockList[player.UserId] then
				return
			end
			if AdminTools.MutedPlayers[player.UserId] then
				return
			end
			if ChatSystem.SpamFilter and ChatSystem.IsSpam(player, message) then
				return
			end
			local text = message
			if _stateInstance:Get("TranslateDisplay") then
				text = ChatSystem.Translate(message)
			end
			local entry = ChatSystem.AddLog(player, text, "chat")
			if AppInstance.ChatWindow then
				AppInstance.ChatWindow:AddEntry(entry)
			end
			-- Yerel ayna: oyunun chatinde gorunmeyen mesajlar burada gorunur
			if _stateInstance:Get("ChatCleaner") then
				return
			end
			ChatSystem.SystemMessage("[" .. player.DisplayName .. "] " .. text)
		end)
	end

	for _, player in ipairs(Players:GetPlayers()) do
		attach(player)
	end

	TaskManager:Connect(Players.PlayerAdded, function(player)
		attach(player)
		if _stateInstance:Get("FriendsTracker") then
			Notifications:Info("Oyuncu girdi", player.DisplayName .. " sunucuya katildi")
		end
	end)

	TaskManager:Connect(Players.PlayerRemoving, function(player)
		local connection = connections[player]
		if connection then
			pcall(function() connection:Disconnect() end)
			connections[player] = nil
		end
		ChatSystem.BlockList[player.UserId] = nil
		AdminTools.MutedPlayers[player.UserId] = nil
		if _stateInstance:Get("FriendsTracker") then
			Notifications:Info("Oyuncu cikti", player.DisplayName .. " sunucudan ayrildi")
		end
	end)
end

-- ── Girdi yonetimi ───────────────────────────────────────────────────────
function MainApp:_setupInput()
	TaskManager:Connect(UserInputService.InputBegan, function(input, processed)
		self._lastInput = os.clock()

		if input.UserInputType == Enum.UserInputType.Touch then
			self._swipeStart = { Position = input.Position, Time = os.clock() }
		end

		local typing = UserInputService:GetFocusedTextBox() ~= nil
		if not typing and not processed then
			if input.KeyCode == Config.Keys.Menu then
				if self.Window then
					self.Window:SetVisible(not self.Window:IsVisible())
				end
			elseif input.KeyCode == Config.Keys.Widgets then
				if self.Widgets then
					self.Widgets:ToggleAll()
				end
			elseif input.KeyCode == Config.Keys.FlyPanel then
				if self.FlyPanel then
					self.FlyPanel:Toggle()
				end
			elseif input.KeyCode == Config.Keys.Spy then
				if self.ChatWindow then
					self.ChatWindow:Toggle()
				end
			elseif input.KeyCode == Config.Keys.Chat then
				if self.ChatWindow then
					self.ChatWindow.Mode = "Search"
					self.ChatWindow:SetVisible(true)
					self.ChatWindow:Refresh()
				end
			elseif input.KeyCode == Config.Keys.Theme then
				local order = { "Default", "ColorBlind", "HighContrast" }
				local current = Theme.Palette or "Default"
				local index = 1
				for i, name in ipairs(order) do
					if name == current then
						index = i
					end
				end
				local nextName = order[(index % #order) + 1]
				if nextName == "ColorBlind" then
					Accessibility.SetColorBlind(true)
					Accessibility.SetHighContrast(false)
				elseif nextName == "HighContrast" then
					Accessibility.SetHighContrast(true)
					Accessibility.SetColorBlind(false)
				else
					Accessibility.SetHighContrast(false)
					Accessibility.SetColorBlind(false)
				end
				if self.Window then
					self.Window:ApplyTheme()
				end
				Notifications:Info("Tema", nextName)
			elseif input.KeyCode == Config.Keys.Console then
				if self.CommandPanel then
					self.CommandPanel:Toggle()
				end
			elseif input.KeyCode == Enum.KeyCode.Escape then
				if self.Window and self.Window:IsVisible() then
					self.Window:SetVisible(false)
				end
			end
		end

		-- Ucus tuslari
		if input.KeyCode == Enum.KeyCode.W then
			self._keyStates.forward = true
		elseif input.KeyCode == Enum.KeyCode.S then
			self._keyStates.back = true
		elseif input.KeyCode == Enum.KeyCode.A then
			self._keyStates.left = true
		elseif input.KeyCode == Enum.KeyCode.D then
			self._keyStates.right = true
		elseif input.KeyCode == Enum.KeyCode.E then
			self._keyStates.up = true
		elseif input.KeyCode == Enum.KeyCode.Q then
			self._keyStates.down = true
		elseif input.KeyCode == Enum.KeyCode.Space then
			self._keyStates.up = true
		end

		-- Object inspector modu
		if AdminTools.ObjectInspectMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local camera = Workspace.CurrentCamera
			if camera then
				local unitRay = camera:ViewportPointToRay(input.Position.X, input.Position.Y)
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				local character = CharacterController.GetCharacter()
				if character then
					params.FilterDescendantsInstances = { character }
				end
				local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 2000, params)
				if result then
					local instance = result.Instance
					local info = string.format(
						"ISIM: %s\nSINIF: %s\nKONUM: %.1f, %.1f, %.1f\nYOL: %s",
						instance.Name,
						instance.ClassName,
						result.Position.X, result.Position.Y, result.Position.Z,
						instance:GetFullName()
					)
					if instance:IsA("BasePart") then
						info = info .. string.format("\nBOYUT: %.1f, %.1f, %.1f", instance.Size.X, instance.Size.Y, instance.Size.Z)
					end
					if self.Inspector then
						self.Inspector:SetVisible(true)
						self.Inspector.Info.Text = info
					end
					Notifications:Info("Object Inspector", instance.Name .. " (" .. instance.ClassName .. ")")
				end
			end
		end
	end)

	TaskManager:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.Touch and self._swipeStart then
			local delta = input.Position - self._swipeStart.Position
			local distance = delta.Magnitude
			local elapsed = os.clock() - self._swipeStart.Time
			self._swipeStart = nil
			if Accessibility.Enabled.Swipe and distance > Config.Accessibility.SwipeMinDistance and elapsed < 0.6 then
				local direction = "sag"
				if math.abs(delta.X) > math.abs(delta.Y) then
					direction = delta.X > 0 and "sag" or "sol"
				else
					direction = delta.Y > 0 and "asagi" or "yukari"
				end
				Notifications:Info("Swipe", "Yon: " .. direction)
				if direction == "sag" and self.Tabs then
					self.Tabs:SelectTab(self.Tabs:GetTabNames()[1].id)
				end
			end
		end

		if input.KeyCode == Enum.KeyCode.W then
			self._keyStates.forward = nil
		elseif input.KeyCode == Enum.KeyCode.S then
			self._keyStates.back = nil
		elseif input.KeyCode == Enum.KeyCode.A then
			self._keyStates.left = nil
		elseif input.KeyCode == Enum.KeyCode.D then
			self._keyStates.right = nil
		elseif input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Space then
			self._keyStates.up = nil
		elseif input.KeyCode == Enum.KeyCode.Q then
			self._keyStates.down = nil
		end
	end)

	-- Klavye navigasyonu (ok tuslari)
	TaskManager:Connect(UserInputService.InputBegan, function(input, processed)
		if not Accessibility.Enabled.KeyboardNav then
			return
		end
		if processed or UserInputService:GetFocusedTextBox() then
			return
		end
		if input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Up then
			self:_moveFocus(input.KeyCode == Enum.KeyCode.Down and 1 or -1)
		end
	end)

	-- Karakter yeniden dogdugunda ayarlari yeniden uygula
	local function onCharacterAdded(character)
		task.defer(function()
			if CharacterController.Noclip then
				CharacterController.SetNoclip(true)
			end
			if CharacterController.Flying then
				CharacterController.SetFly(true)
			end
		end)
	end

	local character = LocalPlayer.Character
	if character then
		onCharacterAdded(character)
	end
	TaskManager:Connect(LocalPlayer.CharacterAdded, onCharacterAdded)
end

function MainApp:_cycleTarget()
	local list = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(list, player)
		end
	end
	if #list == 0 then
		Notifications:Error("Hedef", "Sunucuda baska oyuncu yok")
		return
	end
	self._targetIndex = ((self._targetIndex or 0) % #list) + 1
	local player = list[self._targetIndex]
	AdminTools.SetTarget(player)
	if self.Inspector then
		self.Inspector:Refresh()
	end
	Notifications:Info("Hedef", player.DisplayName .. " (" .. self._targetIndex .. "/" .. #list .. ")")
end

function MainApp:_moveFocus(direction)
	if not self.Window or not self.Window:IsVisible() then
		return
	end
	local page = self.Tabs and self.Tabs:GetTab(_stateInstance:Get("CurrentTab"))
	if not page then
		return
	end
	local focusables = {}
	for _, child in ipairs(page:GetDescendants()) do
		if child:IsA("TextButton") and child.Visible then
			table.insert(focusables, child)
		end
	end
	if #focusables == 0 then
		return
	end
	self._focusIndex = (self._focusIndex + direction - 1) % #focusables + 1
	local target = focusables[self._focusIndex]
	if target then
		Utilities.ScrollIntoView(page, target)
		Utilities.PlayUI("Hover")
	end
end

-- ── Ana dongu ─────────────────────────────────────────────────────────────
function MainApp:_updateFlyDirection()
	local states = self._keyStates
	local vector = Vector3.new(0, 0, 0)
	if states.forward then
		vector = vector + Vector3.new(0, 0, -1)
	end
	if states.back then
		vector = vector + Vector3.new(0, 0, 1)
	end
	if states.left then
		vector = vector + Vector3.new(-1, 0, 0)
	end
	if states.right then
		vector = vector + Vector3.new(1, 0, 0)
	end
	if states.up then
		vector = vector + Vector3.new(0, 1, 0)
	end
	if states.down then
		vector = vector + Vector3.new(0, -1, 0)
	end
	CharacterController.FlyDirection = vector
	if vector.Magnitude > 0.01 and not VehicleController.Flying then
		VehicleController.SetInput(vector)
	end
end

function MainApp:_heartbeat(dt)
	local frame = (_stateInstance:Get("FrameCount") or 0) + 1
	_stateInstance:Set("FrameCount", frame)

	self:_updateFlyDirection()
	CharacterController.Update(dt)
	VehicleController.Update(dt)
	WaypointController.Update(dt)
	TrackController.Update(dt)
	AdminTools.Update()
	ChatSystem.Update()
	Analytics.Update(dt)
	TaskManager:RunTicks(os.clock())

	-- Otomatik gizleme
	if Config.Menu.AutoHide and self.Window and self.Window:IsVisible() then
		if os.clock() - self._lastInput > Config.Accessibility.AutoHideDelay then
			self.Window:SetVisible(false)
		end
	end
end

function MainApp:_render(dt)
	-- Kamera ve gorunum guncellemeleri
	CameraController.Update(dt)

	if self.Widgets then
		self.Widgets:Update()
	end
	if self.ChatWindow then
		self.ChatWindow:Update()
	end
	if self.Inspector then
		self.Inspector:Update()
	end
	if self.ActivityLog then
		self.ActivityLog:Update()
	end

	-- Hareketli arka plan
	if self.Window and self.Window.BackgroundGradient then
		self.Window.BackgroundGradient.Rotation = (self.Window.BackgroundGradient.Rotation + 12 * dt) % 360
	end

	-- Ozel imlec
	if Accessibility.Enabled.CustomCursor and Accessibility._cursor then
		local location = UserInputService:GetMouseLocation()
		Accessibility._cursor.Position = UDim2.fromOffset(location.X, location.Y)
	end

	-- Durum etiketi
	local statusLabel = _stateInstance:Get("StatusLabel")
	if statusLabel and statusLabel.Parent then
		local lines = {
			string.format("FPS: %d  |  Ping: %d ms  |  Oyuncu: %d", Analytics.GetFPS(), Analytics.GetPing(), #Players:GetPlayers()),
			string.format("Oynama: %s  |  Frame: %.1f ms  |  Tick: %d Hz",
				Utilities.FormatTime(Analytics.PlayTime), (Analytics.FrameTime or 0) * 1000, Analytics.GetTickRate()),
			string.format("Hedef: %s  |  Ucus: %s  |  Noclip: %s",
				(AdminTools.GetTarget() and AdminTools.GetTarget().DisplayName) or "-",
				tostring(CharacterController.Flying),
				tostring(CharacterController.Noclip)),
		}
		statusLabel.Text = table.concat(lines, "\n")
	end
end

function MainApp:Start()
	TaskManager:Connect(RunService.Heartbeat, function(dt)
		local ok, err = pcall(self._heartbeat, self, dt)
		if not ok then
			warn("[X52] Heartbeat error: " .. tostring(err))
		end
	end)

	TaskManager:Connect(RunService.RenderStepped, function(dt)
		local ok, err = pcall(self._render, self, dt)
		if not ok then
			warn("[X52] RenderStepped error: " .. tostring(err))
		end
	end)
end

function MainApp:Destroy()
	self.Janitor:Destroy()
	TaskManager:Cleanup()
end

-- ──────────────────────────────────────────────────────────────────────────
-- BÖLÜM 16: GİRİŞ NOKTASI
-- ──────────────────────────────────────────────────────────────────────────

local app = MainApp.new()
AppInstance = app
app:Initialize()
app:Start()

game:BindToClose(function()
	app:Destroy()
end)

print("===============================================================")
print(" X MENU V52 | by XRIPX | FINAL BUILD")
print(" Sifre: " .. Config.Password.Value)
print(" Kisayollar: F1 menu | F2 widget | F3 fly | F4 casus | F5 sohbet | F6 tema | ; komut paneli")
print(" Uyari: Tum ozellikler yerel (client-side) calisir.")
print("===============================================================")
