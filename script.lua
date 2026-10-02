local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local GUI_NAME = "PrysmGamingInputHUD"

local NORMAL = Color3.fromRGB(25, 27, 38)
local KEY_PRESS = Color3.fromRGB(100, 70, 255)

local CLICK_COLOR = Color3.fromRGB(0, 200, 255)
local RIGHT_CLICK_COLOR = Color3.fromRGB(190, 70, 255)
local WHEEL_COLOR = Color3.fromRGB(255, 190, 70)

local TEXT = Color3.fromRGB(245, 247, 255)

local FONT = Font.new(
	"rbxasset://fonts/families/FredokaOne.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Italic
)

--==================================================
-- CLEAN OLD GUI
--==================================================

local old = playerGui:FindFirstChild(GUI_NAME)

if old then
	old:Destroy()
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 1000
gui.Parent = playerGui

local root = Instance.new("Frame")
root.Name = "HUD"
root.Size = UDim2.fromOffset(500, 265)
root.Position = UDim2.new(0, 14, 1, -279)
root.BackgroundTransparency = 1
root.Parent = gui

--==================================================
-- KEY SYSTEM
--==================================================

local keyMap = {}

local function createKey(name, text, x, y, w, h, keyCode)
	local key = Instance.new("TextLabel")

	key.Name = name
	key.Size = UDim2.fromOffset(w, h)
	key.Position = UDim2.fromOffset(x, y)

	key.BackgroundColor3 = NORMAL
	key.BackgroundTransparency = 0.12
	key.BorderSizePixel = 0

	key.Text = text
	key.TextColor3 = TEXT
	key.TextSize = 11
	key.FontFace = FONT

	key.Parent = root

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = key

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(90, 110, 150)
	stroke.Transparency = 0.45
	stroke.Thickness = 1
	stroke.Parent = key

	if keyCode then
		keyMap[keyCode] = key
	end

	return key
end

local function keyDown(key)
	if not key then
		return
	end

	local stroke = key:FindFirstChildOfClass("UIStroke")

	TweenService:Create(
		key,
		TweenInfo.new(0.06),
		{
			BackgroundColor3 = KEY_PRESS,
			BackgroundTransparency = 0
		}
	):Play()

	if stroke then
		TweenService:Create(
			stroke,
			TweenInfo.new(0.06),
			{
				Color = CLICK_COLOR,
				Transparency = 0,
				Thickness = 2
			}
		):Play()
	end
end

local function keyUp(key)
	if not key then
		return
	end

	local stroke = key:FindFirstChildOfClass("UIStroke")

	TweenService:Create(
		key,
		TweenInfo.new(0.12),
		{
			BackgroundColor3 = NORMAL,
			BackgroundTransparency = 0.12
		}
	):Play()

	if stroke then
		TweenService:Create(
			stroke,
			TweenInfo.new(0.12),
			{
				Color = Color3.fromRGB(90, 110, 150),
				Transparency = 0.45,
				Thickness = 1
			}
		):Play()
	end
end

--==================================================
-- KEYBOARD
--==================================================

local kw = 30
local kh = 30
local gap = 3

local startX = 4
local startY = 6

local rows = {
	{
		{"ESC", Enum.KeyCode.Escape},
		{"1", Enum.KeyCode.One},
		{"2", Enum.KeyCode.Two},
		{"3", Enum.KeyCode.Three},
		{"4", Enum.KeyCode.Four},
		{"5", Enum.KeyCode.Five},
		{"6", Enum.KeyCode.Six},
		{"7", Enum.KeyCode.Seven},
		{"8", Enum.KeyCode.Eight},
		{"9", Enum.KeyCode.Nine},
		{"0", Enum.KeyCode.Zero},
		{"-", Enum.KeyCode.Minus},
		{"=", Enum.KeyCode.Equals},
	},

	{
		{"TAB", Enum.KeyCode.Tab},
		{"Q", Enum.KeyCode.Q},
		{"W", Enum.KeyCode.W},
		{"E", Enum.KeyCode.E},
		{"R", Enum.KeyCode.R},
		{"T", Enum.KeyCode.T},
		{"Y", Enum.KeyCode.Y},
		{"U", Enum.KeyCode.U},
		{"I", Enum.KeyCode.I},
		{"O", Enum.KeyCode.O},
		{"P", Enum.KeyCode.P},
	},

	{
		{"CAPS", Enum.KeyCode.CapsLock},
		{"A", Enum.KeyCode.A},
		{"S", Enum.KeyCode.S},
		{"D", Enum.KeyCode.D},
		{"F", Enum.KeyCode.F},
		{"G", Enum.KeyCode.G},
		{"H", Enum.KeyCode.H},
		{"J", Enum.KeyCode.J},
		{"K", Enum.KeyCode.K},
		{"L", Enum.KeyCode.L},
	},

	{
		{"SHIFT", Enum.KeyCode.LeftShift},
		{"Z", Enum.KeyCode.Z},
		{"X", Enum.KeyCode.X},
		{"C", Enum.KeyCode.C},
		{"V", Enum.KeyCode.V},
		{"B", Enum.KeyCode.B},
		{"N", Enum.KeyCode.N},
		{"M", Enum.KeyCode.M},
	},
}

for rowIndex, row in ipairs(rows) do
	local x = startX

	for _, data in ipairs(row) do
		local width = kw

		if data[1] == "TAB" then
			width = 40
		elseif data[1] == "CAPS" then
			width = 45
		elseif data[1] == "SHIFT" then
			width = 52
		end

		createKey(
			"Key_" .. data[1],
			data[1],
			x,
			startY + ((rowIndex - 1) * 34),
			width,
			kh,
			data[2]
		)

		x += width + gap
	end
end

-- Bottom keys
local bottomY = startY + 136

createKey(
	"CTRL",
	"CTRL",
	startX,
	bottomY,
	43,
	kh,
	Enum.KeyCode.LeftControl
)

createKey(
	"ALT",
	"ALT",
	startX + 46,
	bottomY,
	38,
	kh,
	Enum.KeyCode.LeftAlt
)

createKey(
	"SPACE",
	"",
	startX + 87,
	bottomY,
	112,
	kh,
	Enum.KeyCode.Space
)

--==================================================
-- ARROWS
--==================================================

local ax = 310
local ay = 143

createKey("LEFT", "←", ax, ay + 34, 31, 31, Enum.KeyCode.Left)
createKey("DOWN", "↓", ax + 34, ay + 34, 31, 31, Enum.KeyCode.Down)
createKey("RIGHT", "→", ax + 68, ay + 34, 31, 31, Enum.KeyCode.Right)
createKey("UP", "↑", ax + 34, ay, 31, 31, Enum.KeyCode.Up)

--==================================================
-- GAMING MOUSE
--==================================================

local mouse = Instance.new("Frame")
mouse.Name = "Mouse"
mouse.Size = UDim2.fromOffset(82, 150)
mouse.Position = UDim2.fromOffset(397, 5)
mouse.BackgroundColor3 = Color3.fromRGB(19, 21, 30)
mouse.BackgroundTransparency = 0.05
mouse.BorderSizePixel = 0
mouse.Parent = root

local mouseCorner = Instance.new("UICorner")
mouseCorner.CornerRadius = UDim.new(0, 30)
mouseCorner.Parent = mouse

local mouseStroke = Instance.new("UIStroke")
mouseStroke.Color = Color3.fromRGB(110, 80, 255)
mouseStroke.Thickness = 2
mouseStroke.Transparency = 0.15
mouseStroke.Parent = mouse

--==================================================
-- LEFT CLICK AREA
--==================================================

local leftClick = Instance.new("Frame")
leftClick.Name = "LMB"
leftClick.Size = UDim2.new(0.5, -3, 0, 62)
leftClick.Position = UDim2.fromOffset(2, 2)
leftClick.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
leftClick.BackgroundTransparency = 0.05
leftClick.BorderSizePixel = 0
leftClick.ZIndex = 3
leftClick.Parent = mouse

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 22)
leftCorner.Parent = leftClick

local leftStroke = Instance.new("UIStroke")
leftStroke.Color = CLICK_COLOR
leftStroke.Thickness = 1
leftStroke.Transparency = 0.3
leftStroke.Parent = leftClick

--==================================================
-- RIGHT CLICK AREA
--==================================================

local rightClick = Instance.new("Frame")
rightClick.Name = "RMB"
rightClick.Size = UDim2.new(0.5, -3, 0, 62)
rightClick.Position = UDim2.new(0.5, 1, 0, 2)
rightClick.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
rightClick.BackgroundTransparency = 0.05
rightClick.BorderSizePixel = 0
rightClick.ZIndex = 3
rightClick.Parent = mouse

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 22)
rightCorner.Parent = rightClick

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = RIGHT_CLICK_COLOR
rightStroke.Thickness = 1
rightStroke.Transparency = 0.3
rightStroke.Parent = rightClick

--==================================================
-- CLICK FLASH
--==================================================

local function createClickFlash(parent, color)
	local flash = Instance.new("Frame")

	flash.Name = "ClickFlash"
	flash.AnchorPoint = Vector2.new(0.5, 0.5)
	flash.Position = UDim2.fromScale(0.5, 0.5)
	flash.Size = UDim2.fromOffset(8, 8)
	flash.BackgroundColor3 = color
	flash.BackgroundTransparency = 1
	flash.BorderSizePixel = 0
	flash.ZIndex = 20
	flash.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = flash

	return flash
end

local leftFlash = createClickFlash(leftClick, CLICK_COLOR)
local rightFlash = createClickFlash(rightClick, RIGHT_CLICK_COLOR)

--==================================================
-- MOUSE LABELS
--==================================================

local function createMouseText(parent, text)
	local label = Instance.new("TextLabel")

	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = TEXT
	label.TextSize = 9
	label.FontFace = FONT
	label.ZIndex = 10
	label.Parent = parent

	return label
end

createMouseText(leftClick, "LMB")
createMouseText(rightClick, "RMB")

--==================================================
-- CENTER DIVIDER
--==================================================

local divider = Instance.new("Frame")
divider.Size = UDim2.fromOffset(1, 58)
divider.Position = UDim2.new(0.5, 0, 0, 3)
divider.BackgroundColor3 = Color3.fromRGB(110, 115, 135)
divider.BackgroundTransparency = 0.2
divider.BorderSizePixel = 0
divider.ZIndex = 8
divider.Parent = mouse

--==================================================
-- MOUSE WHEEL
--==================================================

local wheel = Instance.new("Frame")
wheel.Name = "Wheel"
wheel.Size = UDim2.fromOffset(11, 32)
wheel.Position = UDim2.new(0.5, -5, 0, 15)
wheel.BackgroundColor3 = Color3.fromRGB(130, 135, 155)
wheel.BackgroundTransparency = 0
wheel.BorderSizePixel = 0
wheel.ZIndex = 15
wheel.Parent = mouse

local wheelCorner = Instance.new("UICorner")
wheelCorner.CornerRadius = UDim.new(1, 0)
wheelCorner.Parent = wheel

local wheelStroke = Instance.new("UIStroke")
wheelStroke.Color = WHEEL_COLOR
wheelStroke.Thickness = 1
wheelStroke.Parent = wheel

--==================================================
-- SIDE BUTTONS
--==================================================

local side4 = Instance.new("Frame")
side4.Name = "Mouse4"
side4.Size = UDim2.fromOffset(8, 29)
side4.Position = UDim2.fromOffset(-5, 64)
side4.BackgroundColor3 = NORMAL
side4.BorderSizePixel = 0
side4.ZIndex = 5
side4.Parent = mouse

local side5 = Instance.new("Frame")
side5.Name = "Mouse5"
side5.Size = UDim2.fromOffset(8, 29)
side5.Position = UDim2.fromOffset(79, 64)
side5.BackgroundColor3 = NORMAL
side5.BorderSizePixel = 0
side5.ZIndex = 5
side5.Parent = mouse

for _, side in ipairs({side4, side5}) do
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 4)
	c.Parent = side

	local s = Instance.new("UIStroke")
	s.Color = RIGHT_CLICK_COLOR
	s.Thickness = 1
	s.Transparency = 0.2
	s.Parent = side
end

--==================================================
-- STRONG CLICK ANIMATION
--==================================================

local function clickDown(button, flash, color)
	if not button then
		return
	end

	-- Immediate bright change
	button.BackgroundColor3 = color
	button.BackgroundTransparency = 0

	local stroke = button:FindFirstChildOfClass("UIStroke")

	if stroke then
		stroke.Color = color
		stroke.Transparency = 0
		stroke.Thickness = 3
	end

	-- Flash expands from the center
	if flash then
		flash.Size = UDim2.fromOffset(8, 8)
		flash.BackgroundTransparency = 0.15

		TweenService:Create(
			flash,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = UDim2.fromOffset(55, 55),
				BackgroundTransparency = 1
			}
		):Play()
	end
end

local function clickUp(button, originalColor)
	if not button then
		return
	end

	local stroke = button:FindFirstChildOfClass("UIStroke")

	TweenService:Create(
		button,
		TweenInfo.new(0.12),
		{
			BackgroundColor3 = originalColor,
			BackgroundTransparency = 0.05
		}
	):Play()

	if stroke then
		TweenService:Create(
			stroke,
			TweenInfo.new(0.12),
			{
				Transparency = 0.3,
				Thickness = 1
			}
		):Play()
	end
end

--==================================================
-- INPUT
--==================================================

UserInputService.InputBegan:Connect(function(input)
	-- Keyboard
	local key = keyMap[input.KeyCode]

	if key then
		keyDown(key)
	end

	-- Mouse
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		clickDown(
			leftClick,
			leftFlash,
			CLICK_COLOR
		)

	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		clickDown(
			rightClick,
			rightFlash,
			RIGHT_CLICK_COLOR
		)

	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		clickDown(
			wheel,
			nil,
			WHEEL_COLOR
		)

	elseif input.UserInputType == Enum.UserInputType.MouseButton4 then
		clickDown(
			side4,
			nil,
			SECOND_ACCENT
		)

	elseif input.UserInputType == Enum.UserInputType.MouseButton5 then
		clickDown(
			side5,
			nil,
			SECOND_ACCENT
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	local key = keyMap[input.KeyCode]

	if key then
		keyUp(key)
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		clickUp(leftClick, Color3.fromRGB(35, 38, 52))

	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		clickUp(rightClick, Color3.fromRGB(35, 38, 52))

	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		clickUp(wheel, Color3.fromRGB(130, 135, 155))

	elseif input.UserInputType == Enum.UserInputType.MouseButton4 then
		clickUp(side4, NORMAL)

	elseif input.UserInputType == Enum.UserInputType.MouseButton5 then
		clickUp(side5, NORMAL)
	end
end)

--==================================================
-- MOUSE WHEEL
--==================================================

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel then

		clickDown(
			wheel,
			nil,
			WHEEL_COLOR
		)

		task.delay(0.14, function()
			clickUp(
				wheel,
				Color3.fromRGB(130, 135, 155)
			)
		end)
	end
end)
