--15:51 UTC+3 2021/07/12
--!strict

type TextObject = TextLabel | TextBox | TextButton

-- Constants
local TESTING_PROCESS = false
local TEXTSIZE_METHOD = "GetTextSize"

local MINMAX_FIXFACTOR = true -- true -> max lowered to min

local SCALE_OPTION_BACKGROUND = Color3.fromRGB(15, 178, 227)
local WORKPLACE_POSITION = UDim2.new(1.5, 0, 1, -8)
local OPTIONS_POSITION = UDim2.new(-0.5, 0, 1, -8)
local MUTUAL_POSITION = UDim2.new(0.5, 0, 1, -8)
local DEFAULT_THICKNESS = 2

-- Default
local forAll_ScaleType, individual_ScaleType = "LowerScale", "LowerScale"
local forAll_Variable = "..."

local forAll_min, forAll_max = "0", tostring(math.huge)
local individual_min, individual_max = "0", tostring(math.huge)
local individual_lower, individual_upper = "0", "0"

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TextService = game:GetService("TextService")
local Selection = game:GetService("Selection")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

if RunService:IsRunning() then
	return
end

local properties = {
	[1] = "BackgroundColor3",
	[2] = "Color",
	[3] = "TextColor3"
}

local themeColors = {
	["Dark"] = {
		["Background"] = Color3.fromRGB(46, 46, 46),
		["FrameBackground"] = Color3.fromRGB(53, 53, 53),
		["Button"] = Color3.fromRGB(45, 45, 45),
		["StaticText"] = Color3.fromRGB(188, 188, 188),
		["VaryingText"] = Color3.fromRGB(255, 255, 255),
		["ScrollBar"] = Color3.fromRGB(29, 29, 29),
		["Stroke"] = Color3.fromRGB(10, 10, 10)
	},
	["Light"] = {
		["Background"] = Color3.fromRGB(255, 255, 255),
		["FrameBackground"] = Color3.fromRGB(242, 242, 242),
		["Button"] = Color3.fromRGB(219, 219, 219),
		["StaticText"] = Color3.fromRGB(0, 0, 0),
		["VaryingText"] = Color3.fromRGB(25, 25, 25),
		["ScrollBar"] = Color3.fromRGB(240, 240, 240),
		["Stroke"] = Color3.fromRGB(200, 200, 200)
	},
}

local plugin = plugin or getfenv().PluginManager():CreatePlugin()
plugin.Name = "UIStrokeScalingPlugin"

local dockWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	250,
	300,
	250,
	300
)

local toolbar = plugin:CreateToolbar("Scale UIStroke")

local button = toolbar:CreateButton("Open Menu", "Start scaling your UIStroke objects!", "http://www.roblox.com/asset/?id=14050607586")
button.ClickableWhenViewportHidden = true

local widget = plugin:CreateDockWidgetPluginGui(
	"385026300",
	dockWidgetInfo
)

widget.Title = "Scale UIStroke Thickness"

button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

local currentTheme = "Dark"

local scr = ReplicatedFirst:FindFirstChild("UIStrokeThicknessScaling")

if scr then
	scr:Destroy()
end

local handler = Instance.new("LocalScript")
handler.Name = "UIStrokeThicknessScaling"
handler.Source = [[
--!strict

type TextObject = TextLabel | TextBox | TextButton

local TextService = game:GetService("TextService")
local LogService = game:GetService("LogService")

local SCALING_WARNINGTEXT = "Scaling must be done on studio."
local TEXTSIZE_METHOD = "GetTextSize"

local function isTextObject(object: TextObject)
	return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
end

local function onAdded(UIStroke: UIStroke)
	pcall(function()
		if UIStroke and UIStroke:IsA("UIStroke") then
			if UIStroke:GetAttribute("Scaled") ~= true then
				UIStroke:SetAttribute("Scaled", true)

				local function onUseScale()
					local scaleType = UIStroke:GetAttribute("ScaleType")

					local desiredThickness = UIStroke.Thickness
					local absoluteSizeChanged: RBXScriptConnection = nil
					local parent

					repeat
						task.wait()
						parent = UIStroke.Parent :: GuiObject
					until parent and parent:IsA("GuiObject")

					local function determineDimension(condition)
						local a, b = parent.AbsoluteSize.X, parent.AbsoluteSize.Y
						return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
					end

					local function determineDimensionForText(condition)
						local vector2

						pcall(function()
							vector2 = TextService:GetTextSize((parent :: TextObject).Text, (parent :: TextObject).TextSize, (parent :: TextObject).Font, (parent :: TextObject).AbsoluteSize)
						end)

						if vector2 then
							local a, b = vector2.X, vector2.Y
							return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
						else
							return determineDimension(condition)
						end
					end

					local function update()
						if absoluteSizeChanged and absoluteSizeChanged.Connected then
							absoluteSizeChanged:Disconnect()
						end

						parent = UIStroke.Parent :: GuiObject

						if not parent or not parent:IsA("GuiObject") then
							return
						end
						
						local targetThickness

						local function onViewportSizeChange()
							targetThickness = determineDimension(scaleType) * UIStroke:GetAttribute(scaleType)

							if targetThickness < UIStroke:GetAttribute("MinThickness") then
								UIStroke.Thickness = UIStroke:GetAttribute("MinThickness")
							elseif targetThickness > UIStroke:GetAttribute("MaxThickness") then
								UIStroke.Thickness = UIStroke:GetAttribute("MaxThickness")
							else
								UIStroke.Thickness = targetThickness
							end
						end
						
						if UIStroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
							absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
								onViewportSizeChange()
							end)
						else
							if isTextObject(parent :: TextObject) then
								if UIStroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Contextual then
									absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
										onViewportSizeChange()
									end)
								end
							else
								absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
									onViewportSizeChange()
								end)
							end
						end
					end

					UIStroke.AncestryChanged:Connect(update)

					update()
					UIStroke:GetAttributeChangedSignal("LowerScale"):Connect(update)
					UIStroke:GetAttributeChangedSignal("UpperScale"):Connect(update)

					UIStroke:GetAttributeChangedSignal("ScaleType"):Connect(function()
						scaleType = UIStroke:GetAttribute("ScaleType")
					end)
				end

				local useScale = UIStroke:GetAttribute("UseScale")
				local mission = if useScale then task.spawn(onUseScale) else nil

				UIStroke:GetAttributeChangedSignal("UseScale"):Connect(function()
					if UIStroke:GetAttribute("UseScale") then
						if not mission then
							mission = task.spawn(onUseScale)
						end
					else
						if mission then
							task.cancel(mission)
						end
					end
				end)
			end
		end
	end)
end

for i, object in game:GetDescendants() do
	onAdded(object)
end

game.DescendantAdded:Connect(function(object)
	onAdded(object)
end)
]]
handler.Parent = ReplicatedFirst
warn("[Scale UIStroke Thickness by @ProBaturay] New script " .. handler.Name .. " was added in ReplicatedFirst. Please, don't delete it.")

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame.Parent = widget

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.new(1, -40, 0, 250)
Main.BackgroundTransparency = 1
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Parent = Frame

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 15)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Scale UIStroke Thickness"
TextLabel.TextWrapped = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.Parent = Main

local Workplace = Instance.new("Frame")
Workplace.Name = "Workplace"
Workplace.AnchorPoint = Vector2.new(0.5, 0)
Workplace.Size = UDim2.new(0, 220, 0, 135)
Workplace.ClipsDescendants = true
Workplace.Position = UDim2.new(0.5, 0, 0.1, 0)
Workplace.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Workplace.Parent = Main

local UICorner = Instance.new("UICorner")
UICorner.Parent = Workplace

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.AnchorPoint = Vector2.new(0.5, 0)
TextLabel1.Size = UDim2.new(0, 131, 0, 30)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0.3340909, 0, 0, 0)
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Current viewport size:"
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.Parent = Workplace

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = Workplace

local ViewportSize = Instance.new("TextLabel")
ViewportSize.Name = "ViewportSize"
ViewportSize.AnchorPoint = Vector2.new(0.5, 0)
ViewportSize.Size = UDim2.new(0, 58, 0, 30)
ViewportSize.BackgroundTransparency = 1
ViewportSize.Position = UDim2.new(0.8304384, 0, -0.001389, 0)
ViewportSize.TextSize = 14
ViewportSize.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewportSize.Text = "1000x1000"
ViewportSize.Font = Enum.Font.Gotham
ViewportSize.Parent = Workplace

local OptionsMenu = Instance.new("Frame")
OptionsMenu.Name = "OptionsMenu"
OptionsMenu.AnchorPoint = Vector2.new(0.5, 1)
OptionsMenu.Size = UDim2.new(1, -16, 0.8, -8)
OptionsMenu.BackgroundTransparency = 1
OptionsMenu.Position = UDim2.new(0.5, 0, 1, -8)
OptionsMenu.Parent = Workplace

local IndividualFrame = Instance.new("Frame")
IndividualFrame.Name = "IndividualFrame"
IndividualFrame.AnchorPoint = Vector2.new(1, 1)
IndividualFrame.Size = UDim2.new(0.4, 0, 0, 76)
IndividualFrame.BackgroundTransparency = 1
IndividualFrame.Position = UDim2.new(1, -5, 1, 0)
IndividualFrame.Parent = OptionsMenu

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Thickness = 2
UIStroke1.Parent = IndividualFrame

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = IndividualFrame

local IndividualButton = Instance.new("TextButton")
IndividualButton.Name = "IndividualButton"
IndividualButton.AnchorPoint = Vector2.new(0.5, 0.5)
IndividualButton.Size = UDim2.new(1.0000001, -10, 0.3289474, 26)
IndividualButton.Position = UDim2.new(0.5, 0, 0.5, 0)
IndividualButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
IndividualButton.TextSize = 14
IndividualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualButton.Text = "Choose from Explorer"
IndividualButton.TextWrapped = true
IndividualButton.Font = Enum.Font.Gotham
IndividualButton.Parent = IndividualFrame

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Thickness = 2
UIStroke2.Parent = IndividualButton

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = IndividualButton

local ForAllFrame = Instance.new("Frame")
ForAllFrame.Name = "ForAllFrame"
ForAllFrame.AnchorPoint = Vector2.new(0, 1)
ForAllFrame.Size = UDim2.new(0.4, 0, 0, 76)
ForAllFrame.BackgroundTransparency = 1
ForAllFrame.Position = UDim2.new(0, 5, 1, 0)
ForAllFrame.Parent = OptionsMenu

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Thickness = 2
UIStroke3.Parent = ForAllFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = ForAllFrame

local AdjustScaleForAll = Instance.new("TextButton")
AdjustScaleForAll.Name = "AdjustScale"
AdjustScaleForAll.AnchorPoint = Vector2.new(0.5, 0)
AdjustScaleForAll.Size = UDim2.new(1, -10, 0, 26)
AdjustScaleForAll.Position = UDim2.new(0.5, 0, 0, 6)
AdjustScaleForAll.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
AdjustScaleForAll.TextSize = 14
AdjustScaleForAll.TextColor3 = Color3.fromRGB(255, 255, 255)
AdjustScaleForAll.Text = "Scale"
AdjustScaleForAll.TextWrapped = true
AdjustScaleForAll.Font = Enum.Font.Gotham
AdjustScaleForAll.Parent = ForAllFrame

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Thickness = 2
UIStroke4.Parent = AdjustScaleForAll

local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = AdjustScaleForAll

local AdjustMaxMinForAll = Instance.new("TextButton")
AdjustMaxMinForAll.Name = "AdjustMaxMin"
AdjustMaxMinForAll.AnchorPoint = Vector2.new(0.5, 1)
AdjustMaxMinForAll.Size = UDim2.new(1, -10, 0, 26)
AdjustMaxMinForAll.Position = UDim2.new(0.5, 0, 1, -6)
AdjustMaxMinForAll.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
AdjustMaxMinForAll.TextSize = 14
AdjustMaxMinForAll.TextColor3 = Color3.fromRGB(255, 255, 255)
AdjustMaxMinForAll.Text = "Max / Min"
AdjustMaxMinForAll.TextWrapped = true
AdjustMaxMinForAll.Font = Enum.Font.Gotham
AdjustMaxMinForAll.Parent = ForAllFrame

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Thickness = 2
UIStroke5.Parent = AdjustMaxMinForAll

local UICorner5 = Instance.new("UICorner")
UICorner5.Parent = AdjustMaxMinForAll

local Frame1 = Instance.new("Frame")
Frame1.BorderSizePixel = 0
Frame1.AnchorPoint = Vector2.new(0.5, 1)
Frame1.Size = UDim2.new(0, 2, 0.9, 0)
Frame1.Position = UDim2.new(0.5, 0, 1, 0)
Frame1.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame1.Parent = OptionsMenu

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.AnchorPoint = Vector2.new(1, 0)
TextLabel2.Size = UDim2.new(0.4, 0, 0, 16)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(1, -5, 0, 4)
TextLabel2.TextSize = 14
TextLabel2.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel2.Text = "Individual"
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.Parent = OptionsMenu

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Size = UDim2.new(0.4, 0, 0, 16)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Position = UDim2.new(0, 5, 0, 4)
TextLabel3.TextSize = 14
TextLabel3.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel3.Text = "For all"
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.Parent = OptionsMenu

local Individual = Instance.new("Frame")
Individual.Name = "Individual"
Individual.AnchorPoint = Vector2.new(0.5, 1)
Individual.Visible = false
Individual.Size = UDim2.new(1, -16, 0.8, -8)
Individual.BackgroundTransparency = 1
Individual.Position = UDim2.new(0.5, 0, 1, -8)
Individual.Parent = Workplace

local UIStrokeInfo = Instance.new("Frame")
UIStrokeInfo.Name = "UIStrokeInfo"
UIStrokeInfo.AnchorPoint = Vector2.new(0.5, 1)
UIStrokeInfo.Visible = false
UIStrokeInfo.Size = UDim2.new(1, 0, 0, 76)
UIStrokeInfo.BackgroundTransparency = 1
UIStrokeInfo.Position = UDim2.new(0.5, 0, 1, 0)
UIStrokeInfo.Parent = Individual

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Thickness = 2
UIStroke6.Parent = UIStrokeInfo

local UICorner6 = Instance.new("UICorner")
UICorner6.Parent = UIStrokeInfo

local DeselectText = Instance.new("TextLabel")
DeselectText.Name = "DeselectText"
DeselectText.AnchorPoint = Vector2.new(0.5, 1)
DeselectText.Size = UDim2.new(1, 0, -0.02, 16)
DeselectText.BackgroundTransparency = 1
DeselectText.Position = UDim2.new(0.5, 0, 0, -4)
DeselectText.TextSize = 14
DeselectText.RichText = true
DeselectText.TextColor3 = Color3.fromRGB(188, 188, 188)
DeselectText.Text = "Deselect to return to main menu"
DeselectText.TextWrapped = true
DeselectText.Font = Enum.Font.Gotham
DeselectText.Parent = UIStrokeInfo

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ScrollingFrame.Active = true
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 230)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(29, 29, 29)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasPosition = Vector2.new(0, 154)
ScrollingFrame.Parent = UIStrokeInfo

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.AnchorPoint = Vector2.new(0.5, 0)
TextLabel4.Size = UDim2.new(0.9, 0, 0, 16)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Position = UDim2.new(0.5, 0, 0, 4)
TextLabel4.TextSize = 14
TextLabel4.RichText = true
TextLabel4.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel4.Text = "Scale options"
TextLabel4.TextWrapped = true
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.Parent = ScrollingFrame

local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(0, 20, 0, 20)
Frame2.Position = UDim2.new(0, 16, 0, 30)
Frame2.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame2.Parent = ScrollingFrame

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Thickness = 2
UIStroke7.Parent = Frame2

local UICorner7 = Instance.new("UICorner")
UICorner7.Parent = Frame2

local IndividualLowerScale = Instance.new("TextButton")
IndividualLowerScale.Name = "IndividualLowerScale"
IndividualLowerScale.AnchorPoint = Vector2.new(0.5, 0.5)
IndividualLowerScale.Size = UDim2.new(1, 0, 1, 0)
IndividualLowerScale.Position = UDim2.new(0.5, 0, 0.5, 0)
IndividualLowerScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
IndividualLowerScale.AutoButtonColor = false
IndividualLowerScale.TextSize = 14
IndividualLowerScale.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualLowerScale.Text = ""
IndividualLowerScale.Font = Enum.Font.Gotham
IndividualLowerScale.Parent = Frame2

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Thickness = 2
UIStroke8.Parent = IndividualLowerScale

local UICorner8 = Instance.new("UICorner")
UICorner8.Parent = IndividualLowerScale

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Size = UDim2.new(0, 50, 1, 0)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Position = UDim2.new(1, 8, 0, 0)
TextLabel5.TextSize = 14
TextLabel5.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel5.Text = "Lower"
TextLabel5.TextWrapped = true
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
TextLabel5.Parent = Frame2

local IndividualLowerIndicator = Instance.new("TextLabel")
IndividualLowerIndicator.Name = "IndividualLowerIndicator"
IndividualLowerIndicator.TextTruncate = Enum.TextTruncate.AtEnd
IndividualLowerIndicator.AnchorPoint = Vector2.new(0, 0.5)
IndividualLowerIndicator.Size = UDim2.new(0, 50, 1, 0)
IndividualLowerIndicator.BackgroundTransparency = 1
IndividualLowerIndicator.Position = UDim2.new(0, 120, 0.5, 0)
IndividualLowerIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualLowerIndicator.TextSize = 14
IndividualLowerIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualLowerIndicator.Text = "0.1"
IndividualLowerIndicator.Font = Enum.Font.Gotham
IndividualLowerIndicator.Parent = Frame2

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = IndividualLowerIndicator

local UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = IndividualLowerIndicator

local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(0, 20, 0, 20)
Frame3.Position = UDim2.new(0, 16, 0, 55)
Frame3.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame3.Parent = ScrollingFrame

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Thickness = 2
UIStroke10.Parent = Frame3

local UICorner10 = Instance.new("UICorner")
UICorner10.Parent = Frame3

local IndividualUpperScale = Instance.new("TextButton")
IndividualUpperScale.Name = "IndividualUpperScale"
IndividualUpperScale.AnchorPoint = Vector2.new(0.5, 0.5)
IndividualUpperScale.Size = UDim2.new(1, 0, 1, 0)
IndividualUpperScale.Position = UDim2.new(0.5, 0, 0.5, 0)
IndividualUpperScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
IndividualUpperScale.AutoButtonColor = false
IndividualUpperScale.TextSize = 14
IndividualUpperScale.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualUpperScale.Text = ""
IndividualUpperScale.Font = Enum.Font.Gotham
IndividualUpperScale.Parent = Frame3

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Thickness = 2
UIStroke11.Parent = IndividualUpperScale

local UICorner11 = Instance.new("UICorner")
UICorner11.Parent = IndividualUpperScale

local TextLabel6 = Instance.new("TextLabel")
TextLabel6.Size = UDim2.new(0, 50, 1, 0)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Position = UDim2.new(1, 8, 0, 0)
TextLabel6.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel6.TextSize = 14
TextLabel6.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel6.Text = "Upper"
TextLabel6.TextWrapped = true
TextLabel6.Font = Enum.Font.Gotham
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = Frame3

local IndividualUpperIndicator = Instance.new("TextLabel")
IndividualUpperIndicator.Name = "IndividualUpperIndicator"
IndividualUpperIndicator.TextTruncate = Enum.TextTruncate.AtEnd
IndividualUpperIndicator.AnchorPoint = Vector2.new(0, 0.5)
IndividualUpperIndicator.Size = UDim2.new(0, 50, 1, 0)
IndividualUpperIndicator.BackgroundTransparency = 1
IndividualUpperIndicator.Position = UDim2.new(0, 120, 0.5, 0)
IndividualUpperIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualUpperIndicator.TextSize = 14
IndividualUpperIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualUpperIndicator.Text = "0.1"
IndividualUpperIndicator.Font = Enum.Font.Gotham
IndividualUpperIndicator.Parent = Frame3

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = IndividualUpperIndicator

local UICorner12 = Instance.new("UICorner")
UICorner12.CornerRadius = UDim.new(1, 0)
UICorner12.Parent = IndividualUpperIndicator

local IndividualInsert = Instance.new("TextButton")
IndividualInsert.Name = "IndividualInsert"
IndividualInsert.Size = UDim2.new(0, 80, 0, 26)
IndividualInsert.Position = UDim2.new(0, 16, 0, 110)
IndividualInsert.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
IndividualInsert.TextSize = 14
IndividualInsert.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualInsert.Text = "Insert"
IndividualInsert.TextWrapped = true
IndividualInsert.Font = Enum.Font.Gotham
IndividualInsert.Parent = ScrollingFrame

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Thickness = 2
UIStroke13.Parent = IndividualInsert

local UICorner13 = Instance.new("UICorner")
UICorner13.Parent = IndividualInsert

local IndividualDelete = Instance.new("TextButton")
IndividualDelete.Name = "IndividualDelete"
IndividualDelete.AnchorPoint = Vector2.new(1, 0)
IndividualDelete.Size = UDim2.new(0, 80, 0, 26)
IndividualDelete.Position = UDim2.new(1, -16, 0, 110)
IndividualDelete.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
IndividualDelete.TextSize = 14
IndividualDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualDelete.Text = "Delete"
IndividualDelete.TextWrapped = true
IndividualDelete.Font = Enum.Font.Gotham
IndividualDelete.Parent = ScrollingFrame

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Thickness = 2
UIStroke14.Parent = IndividualDelete

local UICorner14 = Instance.new("UICorner")
UICorner14.Parent = IndividualDelete

local Frame4 = Instance.new("Frame")
Frame4.AnchorPoint = Vector2.new(0.5, 0)
Frame4.Size = UDim2.new(0, 175, 0, 1)
Frame4.Position = UDim2.new(0.5, 0, 0, 150)
Frame4.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame4.Parent = ScrollingFrame

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.AnchorPoint = Vector2.new(0.5, 0)
TextLabel7.Size = UDim2.new(0.9, 0, 0, 16)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Position = UDim2.new(0.5, 0, 0, 155)
TextLabel7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel7.TextSize = 14
TextLabel7.RichText = true
TextLabel7.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel7.Text = "Limit options"
TextLabel7.TextWrapped = true
TextLabel7.Font = Enum.Font.Gotham
TextLabel7.Parent = ScrollingFrame

local IndividualCurrentScale = Instance.new("TextLabel")
IndividualCurrentScale.Name = "IndividualCurrentScale"
IndividualCurrentScale.AnchorPoint = Vector2.new(0.5, 0)
IndividualCurrentScale.Size = UDim2.new(1, -32, 0, 16)
IndividualCurrentScale.BackgroundTransparency = 1
IndividualCurrentScale.Position = UDim2.new(0.5, 0, 0, 85)
IndividualCurrentScale.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualCurrentScale.TextSize = 14
IndividualCurrentScale.RichText = true
IndividualCurrentScale.TextColor3 = Color3.fromRGB(188, 188, 188)
IndividualCurrentScale.Text = "Current scale: no scale"
IndividualCurrentScale.TextWrapped = true
IndividualCurrentScale.Font = Enum.Font.Gotham
IndividualCurrentScale.TextXAlignment = Enum.TextXAlignment.Left
IndividualCurrentScale.Parent = ScrollingFrame

local Frame5 = Instance.new("Frame")
Frame5.AnchorPoint = Vector2.new(0.5, 0)
Frame5.Size = UDim2.new(1, -32, 0, 20)
Frame5.BackgroundTransparency = 1
Frame5.Position = UDim2.new(0.5, 0, 0, 205)
Frame5.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame5.Parent = ScrollingFrame

local TextLabel8 = Instance.new("TextLabel")
TextLabel8.Size = UDim2.new(0, 115, 1, 0)
TextLabel8.BackgroundTransparency = 1
TextLabel8.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel8.TextSize = 14
TextLabel8.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel8.Text = "Maximum pixels"
TextLabel8.TextWrapped = true
TextLabel8.Font = Enum.Font.Gotham
TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
TextLabel8.Parent = Frame5

local IndividualMaxPixelsBox = Instance.new("TextBox")
IndividualMaxPixelsBox.Name = "IndividualMaxPixelsBox"
IndividualMaxPixelsBox.TextTruncate = Enum.TextTruncate.AtEnd
IndividualMaxPixelsBox.AnchorPoint = Vector2.new(0, 0.5)
IndividualMaxPixelsBox.Size = UDim2.new(0, 50, 1, 0)
IndividualMaxPixelsBox.BackgroundTransparency = 1
IndividualMaxPixelsBox.Position = UDim2.new(0, 120, 0.5, 0)
IndividualMaxPixelsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualMaxPixelsBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
IndividualMaxPixelsBox.TextSize = 14
IndividualMaxPixelsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualMaxPixelsBox.Text = "0.1"
IndividualMaxPixelsBox.Font = Enum.Font.Gotham
IndividualMaxPixelsBox.Parent = Frame5

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = IndividualMaxPixelsBox

local UICorner15 = Instance.new("UICorner")
UICorner15.CornerRadius = UDim.new(1, 0)
UICorner15.Parent = IndividualMaxPixelsBox

local Frame6 = Instance.new("Frame")
Frame6.AnchorPoint = Vector2.new(0.5, 0)
Frame6.Size = UDim2.new(1, -32, 0, 20)
Frame6.BackgroundTransparency = 1
Frame6.Position = UDim2.new(0.5, 0, 0, 180)
Frame6.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame6.Parent = ScrollingFrame

local TextLabel9 = Instance.new("TextLabel")
TextLabel9.Size = UDim2.new(0, 115, 1, 0)
TextLabel9.BackgroundTransparency = 1
TextLabel9.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel9.TextSize = 14
TextLabel9.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel9.Text = "Minimum pixels"
TextLabel9.TextWrapped = true
TextLabel9.Font = Enum.Font.Gotham
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = Frame6

local IndividualMinPixelsBox = Instance.new("TextBox")
IndividualMinPixelsBox.Name = "IndividualMinPixelsBox"
IndividualMinPixelsBox.TextTruncate = Enum.TextTruncate.AtEnd
IndividualMinPixelsBox.AnchorPoint = Vector2.new(0, 0.5)
IndividualMinPixelsBox.Size = UDim2.new(0, 50, 1, 0)
IndividualMinPixelsBox.BackgroundTransparency = 1
IndividualMinPixelsBox.Position = UDim2.new(0, 120, 0.5, 0)
IndividualMinPixelsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualMinPixelsBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
IndividualMinPixelsBox.TextSize = 14
IndividualMinPixelsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IndividualMinPixelsBox.Text = "0.1"
IndividualMinPixelsBox.Font = Enum.Font.Gotham
IndividualMinPixelsBox.Parent = Frame6

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke16.Parent = IndividualMinPixelsBox

local UICorner16 = Instance.new("UICorner")
UICorner16.CornerRadius = UDim.new(1, 0)
UICorner16.Parent = IndividualMinPixelsBox

local SelectText = Instance.new("TextLabel")
SelectText.Name = "SelectText"
SelectText.AnchorPoint = Vector2.new(0.5, 0)
SelectText.Size = UDim2.new(0.8921568, 0, 0.145, 16)
SelectText.BackgroundTransparency = 1
SelectText.Position = UDim2.new(0.5, 0, 0.2, 0)
SelectText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectText.TextSize = 14
SelectText.RichText = true
SelectText.TextColor3 = Color3.fromRGB(188, 188, 188)
SelectText.Text = "Select one UIStroke from the <b>Explorer</b> menu."
SelectText.TextWrapped = true
SelectText.Font = Enum.Font.Gotham
SelectText.Parent = Individual

local ReturnFromIndividual = Instance.new("TextButton")
ReturnFromIndividual.Name = "ReturnFromIndividual"
ReturnFromIndividual.AnchorPoint = Vector2.new(0.5, 1)
ReturnFromIndividual.Size = UDim2.new(0.7, 0, -0.09, 30)
ReturnFromIndividual.Position = UDim2.new(0.5, 0, 1, 0)
ReturnFromIndividual.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ReturnFromIndividual.AutoButtonColor = true
ReturnFromIndividual.TextSize = 14
ReturnFromIndividual.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnFromIndividual.Text = "Return to main menu"
ReturnFromIndividual.Font = Enum.Font.Gotham
ReturnFromIndividual.Parent = Individual

local UIStroke17 = Instance.new("UIStroke")
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke17.Thickness = 2
UIStroke17.Parent = ReturnFromIndividual

local UICorner17 = Instance.new("UICorner")
UICorner17.Parent = ReturnFromIndividual

local ForAllScale = Instance.new("Frame")
ForAllScale.Name = "ForAllScale"
ForAllScale.AnchorPoint = Vector2.new(0.5, 1)
ForAllScale.Visible = false
ForAllScale.Size = UDim2.new(1, -16, 0.8, -8)
ForAllScale.BackgroundTransparency = 1
ForAllScale.Position = UDim2.new(0.5, 0, 1, -8)
ForAllScale.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ForAllScale.Parent = Workplace

local ReturnFromForAllScale = Instance.new("TextButton")
ReturnFromForAllScale.Name = "ReturnFromForAllScale"
ReturnFromForAllScale.AnchorPoint = Vector2.new(0.5, 1)
ReturnFromForAllScale.Size = UDim2.new(0.7, 0, -0.09, 30)
ReturnFromForAllScale.Position = UDim2.new(0.5, 0, 1, 0)
ReturnFromForAllScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ReturnFromForAllScale.TextSize = 14
ReturnFromForAllScale.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnFromForAllScale.Text = "Return to main menu"
ReturnFromForAllScale.Font = Enum.Font.Gotham
ReturnFromForAllScale.Parent = ForAllScale

local UIStroke18 = Instance.new("UIStroke")
UIStroke18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke18.Thickness = 2
UIStroke18.Parent = ReturnFromForAllScale

local UICorner18 = Instance.new("UICorner")
UICorner18.Parent = ReturnFromForAllScale

local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(0, 20, 0, 20)
Frame7.Position = UDim2.new(0, 16, 0, 16)
Frame7.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame7.Parent = ForAllScale

local UIStroke19 = Instance.new("UIStroke")
UIStroke19.Thickness = 2
UIStroke19.Parent = Frame7

local UICorner19 = Instance.new("UICorner")
UICorner19.Parent = Frame7

local ForAllLowerScale = Instance.new("TextButton")
ForAllLowerScale.Name = "ForAllLowerScale"
ForAllLowerScale.AnchorPoint = Vector2.new(0.5, 0.5)
ForAllLowerScale.Size = UDim2.new(1, 0, 1, 0)
ForAllLowerScale.Position = UDim2.new(0.5, 0, 0.5, 0)
ForAllLowerScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ForAllLowerScale.AutoButtonColor = false
ForAllLowerScale.TextSize = 14
ForAllLowerScale.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllLowerScale.Text = ""
ForAllLowerScale.Font = Enum.Font.Gotham
ForAllLowerScale.Parent = Frame7

local UIStroke20 = Instance.new("UIStroke")
UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke20.Thickness = 2
UIStroke20.Parent = ForAllLowerScale

local UICorner20 = Instance.new("UICorner")
UICorner20.Parent = ForAllLowerScale

local TextLabel10 = Instance.new("TextLabel")
TextLabel10.Size = UDim2.new(0, 50, 1, 0)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Position = UDim2.new(1, 8, 0, 0)
TextLabel10.TextSize = 14
TextLabel10.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel10.Text = "Lower"
TextLabel10.TextWrapped = true
TextLabel10.Font = Enum.Font.Gotham
TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
TextLabel10.Parent = Frame7

local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(0, 20, 0, 20)
Frame8.Position = UDim2.new(0, 110, 0, 16)
Frame8.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame8.Parent = ForAllScale

local UIStroke22 = Instance.new("UIStroke")
UIStroke22.Thickness = 2
UIStroke22.Parent = Frame8

local UICorner22 = Instance.new("UICorner")
UICorner22.Parent = Frame8

local ForAllUpperScale = Instance.new("TextButton")
ForAllUpperScale.Name = "ForAllUpperScale"
ForAllUpperScale.AnchorPoint = Vector2.new(0.5, 0.5)
ForAllUpperScale.Size = UDim2.new(1, 0, 1, 0)
ForAllUpperScale.Position = UDim2.new(0.5, 0, 0.5, 0)
ForAllUpperScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ForAllUpperScale.AutoButtonColor = false
ForAllUpperScale.TextSize = 14
ForAllUpperScale.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllUpperScale.Text = ""
ForAllUpperScale.Font = Enum.Font.Gotham
ForAllUpperScale.Parent = Frame8

local UIStroke23 = Instance.new("UIStroke")
UIStroke23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke23.Thickness = 2
UIStroke23.Parent = ForAllUpperScale

local UICorner23 = Instance.new("UICorner")
UICorner23.Parent = ForAllUpperScale

local TextLabel11 = Instance.new("TextLabel")
TextLabel11.Size = UDim2.new(0, 50, 1, 0)
TextLabel11.BackgroundTransparency = 1
TextLabel11.Position = UDim2.new(1, 8, 0, 0)
TextLabel11.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel11.TextSize = 14
TextLabel11.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel11.Text = "Upper"
TextLabel11.TextWrapped = true
TextLabel11.Font = Enum.Font.Gotham
TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
TextLabel11.Parent = Frame8

local ForAllDelete = Instance.new("TextButton")
ForAllDelete.Name = "ForAllDelete"
ForAllDelete.AnchorPoint = Vector2.new(1, 0)
ForAllDelete.Size = UDim2.new(0, 80, 0, 20)
ForAllDelete.Position = UDim2.new(1, -16, 0, 45)
ForAllDelete.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ForAllDelete.TextSize = 14
ForAllDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllDelete.Text = "Delete"
ForAllDelete.TextWrapped = true
ForAllDelete.Font = Enum.Font.Gotham
ForAllDelete.Parent = ForAllScale

local UIStroke25 = Instance.new("UIStroke")
UIStroke25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke25.Thickness = 2
UIStroke25.Parent = ForAllDelete

local UICorner25 = Instance.new("UICorner")
UICorner25.Parent = ForAllDelete

local ForAllInsert = Instance.new("TextButton")
ForAllInsert.Name = "ForAllInsert"
ForAllInsert.Size = UDim2.new(0, 80, 0, 20)
ForAllInsert.Position = UDim2.new(0, 16, 0, 45)
ForAllInsert.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ForAllInsert.TextSize = 14
ForAllInsert.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllInsert.Text = "Insert"
ForAllInsert.TextWrapped = true
ForAllInsert.Font = Enum.Font.Gotham
ForAllInsert.Parent = ForAllScale

local UIStroke26 = Instance.new("UIStroke")
UIStroke26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke26.Thickness = 2
UIStroke26.Parent = ForAllInsert

local UICorner26 = Instance.new("UICorner")
UICorner26.Parent = ForAllInsert

local ForAllMaxMin = Instance.new("Frame")
ForAllMaxMin.Name = "ForAllMaxMin"
ForAllMaxMin.AnchorPoint = Vector2.new(0.5, 1)
ForAllMaxMin.Visible = false
ForAllMaxMin.Size = UDim2.new(1, -16, 0.8, -8)
ForAllMaxMin.BackgroundTransparency = 1
ForAllMaxMin.Position = UDim2.new(0.5, 0, 1, -8)
ForAllMaxMin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ForAllMaxMin.Parent = Workplace

local ReturnFromForAllMaxMin = Instance.new("TextButton")
ReturnFromForAllMaxMin.Name = "ReturnFromForAllScale"
ReturnFromForAllMaxMin.AnchorPoint = Vector2.new(0.5, 1)
ReturnFromForAllMaxMin.Size = UDim2.new(0.7, 0, -0.09, 30)
ReturnFromForAllMaxMin.Position = UDim2.new(0.5, 0, 1, 0)
ReturnFromForAllMaxMin.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ReturnFromForAllMaxMin.TextSize = 14
ReturnFromForAllMaxMin.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnFromForAllMaxMin.Text = "Return to main menu"
ReturnFromForAllMaxMin.Font = Enum.Font.Gotham
ReturnFromForAllMaxMin.Parent = ForAllMaxMin

local UIStroke27 = Instance.new("UIStroke")
UIStroke27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke27.Thickness = 2
UIStroke27.Parent = ReturnFromForAllMaxMin

local UICorner27 = Instance.new("UICorner")
UICorner27.Parent = ReturnFromForAllMaxMin

local Frame9 = Instance.new("Frame")
Frame9.AnchorPoint = Vector2.new(0.5, 0)
Frame9.Size = UDim2.new(1, -32, 0, 20)
Frame9.BackgroundTransparency = 1
Frame9.Position = UDim2.new(0.5, 0, 0, 40)
Frame9.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame9.Parent = ForAllMaxMin

local TextLabel12 = Instance.new("TextLabel")
TextLabel12.Size = UDim2.new(0, 115, 1, 0)
TextLabel12.BackgroundTransparency = 1
TextLabel12.TextSize = 14
TextLabel12.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel12.Text = "Maximum pixels"
TextLabel12.TextWrapped = true
TextLabel12.Font = Enum.Font.Gotham
TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
TextLabel12.Parent = Frame9

local ForAllMaxPixelsBox = Instance.new("TextBox")
ForAllMaxPixelsBox.Name = "ForAllMinPixelsBox"
ForAllMaxPixelsBox.ClearTextOnFocus = true
ForAllMaxPixelsBox.AnchorPoint = Vector2.new(0, 0.5)
ForAllMaxPixelsBox.Size = UDim2.new(0, 50, 1, 0)
ForAllMaxPixelsBox.BackgroundTransparency = 1
ForAllMaxPixelsBox.Position = UDim2.new(0, 120, 0.5, 0)
ForAllMaxPixelsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ForAllMaxPixelsBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
ForAllMaxPixelsBox.TextSize = 14
ForAllMaxPixelsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllMaxPixelsBox.Text = "0.1"
ForAllMaxPixelsBox.Font = Enum.Font.Gotham
ForAllMaxPixelsBox.Parent = Frame9

local UIStroke28 = Instance.new("UIStroke")
UIStroke28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke28.Parent = ForAllMaxPixelsBox

local UICorner28 = Instance.new("UICorner")
UICorner28.CornerRadius = UDim.new(1, 0)
UICorner28.Parent = ForAllMaxPixelsBox

local Frame10 = Instance.new("Frame")
Frame10.AnchorPoint = Vector2.new(0.5, 0)
Frame10.Size = UDim2.new(1, -32, 0, 20)
Frame10.BackgroundTransparency = 1
Frame10.Position = UDim2.new(0.5, 0, 0, 15)
Frame10.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame10.Parent = ForAllMaxMin

local TextLabel13 = Instance.new("TextLabel")
TextLabel13.Size = UDim2.new(0, 115, 1, 0)
TextLabel13.BackgroundTransparency = 1
TextLabel13.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel13.TextSize = 14
TextLabel13.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel13.Text = "Minimum pixels"
TextLabel13.TextWrapped = true
TextLabel13.Font = Enum.Font.Gotham
TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
TextLabel13.Parent = Frame10

local ForAllMinPixelsBox = Instance.new("TextBox")
ForAllMinPixelsBox.Name = "ForAllMinPixelsBox"
ForAllMinPixelsBox.ClearTextOnFocus = true
ForAllMinPixelsBox.AnchorPoint = Vector2.new(0, 0.5)
ForAllMinPixelsBox.Size = UDim2.new(0, 50, 1, 0)
ForAllMinPixelsBox.BackgroundTransparency = 1
ForAllMinPixelsBox.Position = UDim2.new(0, 120, 0.5, 0)
ForAllMinPixelsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ForAllMinPixelsBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
ForAllMinPixelsBox.TextSize = 14
ForAllMinPixelsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ForAllMinPixelsBox.Text = "0.1"
ForAllMinPixelsBox.Font = Enum.Font.Gotham
ForAllMinPixelsBox.Parent = Frame10

local UIStroke29 = Instance.new("UIStroke")
UIStroke29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke29.Parent = ForAllMinPixelsBox

local UICorner29 = Instance.new("UICorner")
UICorner29.CornerRadius = UDim.new(1, 0)
UICorner29.Parent = ForAllMinPixelsBox

local IndividualWarning = Instance.new("Frame")
IndividualWarning.Name = "IndividualWarning"
IndividualWarning.AnchorPoint = Vector2.new(0.5, 1)
IndividualWarning.Visible = false
IndividualWarning.Size = UDim2.new(1, -16, 0.8, -8)
IndividualWarning.BackgroundTransparency = 1
IndividualWarning.Position = UDim2.new(0.5, 0, 1, -8)
IndividualWarning.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IndividualWarning.Parent = Workplace

local SelectText1 = Instance.new("TextLabel")
SelectText1.Name = "SelectText"
SelectText1.AnchorPoint = Vector2.new(0.5, 0.5)
SelectText1.Size = UDim2.new(1, 0, 0, 50)
SelectText1.BackgroundTransparency = 1
SelectText1.Position = UDim2.new(0.5, 0, 0.5, 0)
SelectText1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectText1.TextSize = 14
SelectText1.RichText = true
SelectText1.TextColor3 = Color3.fromRGB(188, 188, 188)
SelectText1.Text = "Please select only one UIStroke object and not other objects."
SelectText1.TextWrapped = true
SelectText1.Font = Enum.Font.Gotham
SelectText1.Parent = IndividualWarning

local Frame11 = Instance.new("Frame")
Frame11.AnchorPoint = Vector2.new(0.5, 1)
Frame11.Size = UDim2.new(0, 220, 0, 50)
Frame11.BackgroundTransparency = 1
Frame11.Position = UDim2.new(0.5, 0, 0.88, 0)
Frame11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame11.Parent = Main

local Frame12 = Instance.new("Frame")
Frame12.AnchorPoint = Vector2.new(0, 1)
Frame12.Size = UDim2.new(0, 48, 0, 48)
Frame12.Position = UDim2.new(0, 0, 1, 0)
Frame12.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame12.Parent = Frame11

local UIStroke30 = Instance.new("UIStroke")
UIStroke30.Thickness = 2
UIStroke30.Parent = Frame12

local UICorner30 = Instance.new("UICorner")
UICorner30.Parent = Frame12

local InfoButton = Instance.new("TextButton")
InfoButton.Name = "InfoButton"
InfoButton.AnchorPoint = Vector2.new(0.5, 0.5)
InfoButton.Size = UDim2.new(1, 0, 1, 0)
InfoButton.Position = UDim2.new(0.5, 0, 0.5, 0)
InfoButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
InfoButton.TextSize = 14
InfoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoButton.Text = "Info"
InfoButton.Font = Enum.Font.Gotham
InfoButton.Parent = Frame12

local UIStroke31 = Instance.new("UIStroke")
UIStroke31.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke31.Thickness = 2
UIStroke31.Parent = InfoButton

local UICorner31 = Instance.new("UICorner")
UICorner31.Parent = InfoButton

local TextLabel14 = Instance.new("TextLabel")
TextLabel14.Size = UDim2.new(0, 158, 0, 50)
TextLabel14.Position = UDim2.new(1.2920001, 0, 0, 0)
TextLabel14.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel14.TextSize = 14
TextLabel14.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel14.Text = "Scale stroke thickness. For more info, click the button on the left."
TextLabel14.TextWrapped = true
TextLabel14.Font = Enum.Font.Gotham
TextLabel14.Parent = Frame12

local UIStroke32 = Instance.new("UIStroke")
UIStroke32.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke32.Thickness = 2
UIStroke32.Parent = TextLabel14

local UICorner32 = Instance.new("UICorner")
UICorner32.Parent = TextLabel14

local TextLabel15 = Instance.new("TextLabel")
TextLabel15.AnchorPoint = Vector2.new(0.5, 1)
TextLabel15.Size = UDim2.new(1, 0, 0, 15)
TextLabel15.BackgroundTransparency = 1
TextLabel15.Position = UDim2.new(0.5, 0, 1, 0)
TextLabel15.TextSize = 12
TextLabel15.RichText = true
TextLabel15.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel15.Text = "Made by <b>@ProBaturay</b> with passion!"
TextLabel15.TextWrapped = true
TextLabel15.Font = Enum.Font.Gotham
TextLabel15.Parent = Main

local Info = Instance.new("Frame")
Info.Name = "Info"
Info.AnchorPoint = Vector2.new(0.5, 0.5)
Info.Size = UDim2.new(1, -40, 0, 250)
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(1.5, 0, 0.5, 0)
Info.Parent = Frame

local TextLabel16 = Instance.new("TextLabel")
TextLabel16.AnchorPoint = Vector2.new(0.5, 0)
TextLabel16.Size = UDim2.new(1, 0, 0, 15)
TextLabel16.BackgroundTransparency = 1
TextLabel16.Position = UDim2.new(0.5, 0, 0, 0)
TextLabel16.TextSize = 12
TextLabel16.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel16.Text = "Scale UIStroke Thickness"
TextLabel16.TextWrapped = true
TextLabel16.Font = Enum.Font.Gotham
TextLabel16.Parent = Info

local Frame13 = Instance.new("Frame")
Frame13.AnchorPoint = Vector2.new(0.5, 1)
Frame13.Size = UDim2.new(0, 220, 0, 207)
Frame13.Position = UDim2.new(0.5, 0, 0.828, 0)
Frame13.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Frame13.Parent = Info

local UICorner33 = Instance.new("UICorner")
UICorner33.Parent = Frame13

local TextLabel17 = Instance.new("TextLabel")
TextLabel17.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel17.Size = UDim2.new(0, 210, 0, 200)
TextLabel17.BackgroundTransparency = 1
TextLabel17.Position = UDim2.new(0.5, 0, 0.5028177, 0)
TextLabel17.TextSize = 14
TextLabel17.RichText = true
TextLabel17.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel17.Text = "There are two types of scaling internally programmed in the plugin: UpperScale and LowerScale. UpperScale is used in accordance with one dimension if it is larger than the other dimension, whereas LowerScale is used with the one which is smaller than the other.<br/><br/>You have to scale them while you have the viewport size adjusted at the desired."
TextLabel17.TextWrapped = true
TextLabel17.Font = Enum.Font.Gotham
TextLabel17.Parent = Frame13

local UIStroke33 = Instance.new("UIStroke")
UIStroke33.Thickness = 2
UIStroke33.Parent = Frame13

local Frame14 = Instance.new("Frame")
Frame14.AnchorPoint = Vector2.new(0.5, 1)
Frame14.Size = UDim2.new(0, 150, 0, 30)
Frame14.Position = UDim2.new(0.5, 0, 1, 0)
Frame14.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame14.Parent = Info

local ReturnFromInfo = Instance.new("TextButton")
ReturnFromInfo.Name = "ReturnFromInfo"
ReturnFromInfo.AnchorPoint = Vector2.new(0.5, 0.5)
ReturnFromInfo.Size = UDim2.new(1, 0, 1, 0)
ReturnFromInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
ReturnFromInfo.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ReturnFromInfo.TextSize = 14
ReturnFromInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnFromInfo.Text = "Return to main menu"
ReturnFromInfo.Font = Enum.Font.Gotham
ReturnFromInfo.Parent = Frame14

local UIStroke34 = Instance.new("UIStroke")
UIStroke34.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke34.Thickness = 2
UIStroke34.Parent = ReturnFromInfo

local UICorner34 = Instance.new("UICorner")
UICorner34.Parent = ReturnFromInfo

for i, object in widget:GetDescendants() do
	if object:IsA("UIStroke") then
		object.Color = Color3.fromRGB(10, 10, 10)
	end
	
	if object:IsA("GuiObject") then
		object.BorderSizePixel = 0
	end
end

local TInfo_Slide = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local function adjustViewportSize()
	local camera = workspace:FindFirstChild("Camera")

	if camera then
		ViewportSize.Text = math.floor(camera.ViewportSize.X) .. "x" .. math.floor(camera.ViewportSize.Y)
		return
	end
	
	--local temporaryScreenGui = Instance.new("ScreenGui")
	--temporaryScreenGui.Parent = StarterGui

	--local temporaryFrame = Instance.new("Frame")
	--temporaryFrame.Active = false
	--temporaryFrame.BackgroundTransparency = 1
	--temporaryFrame.Size = UDim2.new(1, 0, 1, 0)
	--temporaryFrame.Position = UDim2.new(10, 0, 10, 0)
	--temporaryFrame.Parent = temporaryScreenGui
	
	--task.defer(function()
	--	temporaryScreenGui:Destroy()
	--end)
	
	--return temporaryFrame.AbsoluteSize
end

local function isTextObject(object: TextObject)
	return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
end

local function isNumber(num): boolean
	if num then
		if type(tonumber(num)) == "number" then
			return true
		end
	end

	return false
end

local function adjustAttributes(object: UIStroke, originalThickness, useScale, lowerScale, upperScale, scaleType, minThickness, maxThickness)
	object:SetAttribute("OriginalThickness", originalThickness)
	object:SetAttribute("UseScale", useScale)
	object:SetAttribute("LowerScale", lowerScale)
	object:SetAttribute("UpperScale", upperScale)
	object:SetAttribute("ScaleType", scaleType)
	object:SetAttribute("MinThickness", minThickness)
	object:SetAttribute("MaxThickness", maxThickness)
end

local function scale(stroke: UIStroke, enable, typeOfAction: "ForAll" | "Individual")
	if enable then
		local parent = stroke.Parent

		if not (parent and parent:IsA("GuiObject")) then 
			return
		end

		local desiredThickness = stroke.Thickness
		local lower, upper

		local function determineDimension(condition)
			local a, b = parent.AbsoluteSize.X, parent.AbsoluteSize.Y
			return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
		end

		local function determineDimensionForText(condition)
			local vector2

			pcall(function()
				vector2 = TextService:GetTextSize((parent :: TextObject).Text, (parent :: TextObject).TextSize, (parent :: TextObject).Font, (parent :: TextObject).AbsoluteSize)
			end)

			if vector2 then
				local a, b = vector2.X, vector2.Y
				return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
			else
				return determineDimension(condition)
			end
		end

		if stroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
			lower = stroke.Thickness / determineDimension("LowerScale")
			upper = stroke.Thickness / determineDimension("UpperScale")
		else
			if isTextObject(parent :: TextObject) then
				if TEXTSIZE_METHOD == "GetTextSize" then
					lower = stroke.Thickness / determineDimension("LowerScale")
					upper = stroke.Thickness / determineDimension("UpperScale")
				end
			else
				lower = stroke.Thickness / determineDimension("LowerScale")
				upper = stroke.Thickness / determineDimension("UpperScale")
			end
		end

		if lower == math.huge or upper == math.huge then
			if stroke:GetAttribute("UseScale") and not stroke:GetAttribute("ScaleType") then
				warn("This UIStroke needs to be manually updated: " .. stroke:GetFullName())
			end
		else
			adjustAttributes(stroke, desiredThickness, true, lower, upper, if typeOfAction == "ForAll" then forAll_ScaleType else individual_ScaleType, 0, math.huge)
		end
	else
		if stroke:GetAttribute("OriginalThickness") then
			stroke.Thickness = stroke:GetAttribute("OriginalThickness")

			adjustAttributes(stroke, nil, false, nil, nil, nil, nil)
		end
	end
end

local function scaleAll(enable: boolean)
	for i, v in game:GetDescendants() do
		if v:IsA("UIStroke") then
			scale(v, enable, "ForAll")
		end
	end
end

local function setMinMaxAll(min: number?, max: number?)
	for i, v in game:GetDescendants() do
		if v:IsA("UIStroke") and v:GetAttribute("UseScale") then
			if min then
				v:SetAttribute("MinThickness", min)
			end
			
			if max then
				v:SetAttribute("MaxThickness", max)
			end
		end
	end
end

local function setMinMax(object, minOrMax, num)
	if object:GetAttribute("UseScale") then
		if minOrMax == "Max" then
			object:SetAttribute("MaxMinThickness", num)
		else
			object:SetAttribute("MinMinThickness", num)
		end
	end
end

local function checkLimitsSameForAll(minOrMax: "Max" | "Min")
	local a = nil
	
	for i, v in game:GetDescendants() do
		if v:IsA("UIStroke") then
			if a ~= v:GetAttribute(minOrMax .. "Thickness") then
				if a ~= nil then
					return false
				else
					a = v:GetAttribute(minOrMax .. "Thickness")
					
					if minOrMax == "Max" then
						if v:GetAttribute("MaxThickness") < v:GetAttribute("MinThickness") then
							v:SetAttribute("MinThickness", v:GetAttribute("MaxThickness"))
						end
					else
						if v:GetAttribute("MinThickness") > v:GetAttribute("MaxThickness") then
							v:SetAttribute("MaxThickness", v:GetAttribute("MinThickness"))
						end
					end
				end
			end
		end
	end
	
	return true
end

AdjustScaleForAll.Activated:Connect(function()
	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = OPTIONS_POSITION}):Play()
	TweenService:Create(ForAllScale, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

AdjustMaxMinForAll.Activated:Connect(function()
	ForAllMinPixelsBox.Text = if checkLimitsSameForAll("Min") then ForAllMinPixelsBox.Text else forAll_Variable
	ForAllMaxPixelsBox.Text = if checkLimitsSameForAll("Max") then ForAllMaxPixelsBox.Text else forAll_Variable
	forAll_max = ForAllMaxPixelsBox.Text
	forAll_min = ForAllMinPixelsBox.Text

	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = OPTIONS_POSITION}):Play()
	TweenService:Create(ForAllMaxMin, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

IndividualButton.Activated:Connect(function()
	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = OPTIONS_POSITION}):Play()
	TweenService:Create(Individual, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

InfoButton.Activated:Connect(function()
	TweenService:Create(Main, TInfo_Slide, {Position = UDim2.fromScale(-0.5, 0.5)}):Play()
	TweenService:Create(Info, TInfo_Slide, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
end)

ReturnFromInfo.Activated:Connect(function()
	TweenService:Create(Info, TInfo_Slide, {Position = UDim2.fromScale(1.5, 0.5)}):Play()
	TweenService:Create(Main, TInfo_Slide, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
end)

ReturnFromIndividual.Activated:Connect(function()
	TweenService:Create(Individual, TInfo_Slide, {Position = WORKPLACE_POSITION}):Play()
	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

ReturnFromForAllScale.Activated:Connect(function()
	TweenService:Create(ForAllScale, TInfo_Slide, {Position = WORKPLACE_POSITION}):Play()
	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

ReturnFromForAllMaxMin.Activated:Connect(function()
	TweenService:Create(ForAllMaxMin, TInfo_Slide, {Position = WORKPLACE_POSITION}):Play()
	TweenService:Create(OptionsMenu, TInfo_Slide, {Position = MUTUAL_POSITION}):Play()
end)

IndividualUpperScale.Activated:Connect(function()
	individual_ScaleType = "UpperScale"
	IndividualUpperScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
	IndividualLowerScale.BackgroundColor3 = themeColors[currentTheme]["Button"]
end)

IndividualLowerScale.Activated:Connect(function()
	individual_ScaleType = "LowerScale"
	IndividualUpperScale.BackgroundColor3 = themeColors[currentTheme]["Button"]
	IndividualLowerScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
end)

ForAllInsert.Activated:Connect(function()
	scaleAll(true)
	warn("UIStroke objects were applied scale.")
end)

ForAllDelete.Activated:Connect(function()
	scaleAll(false)
	warn("No scale will be applied to UIStroke objects.")
end)

ForAllMaxPixelsBox.FocusLost:Connect(function()
	local input = ForAllMaxPixelsBox.Text

	if isNumber(input) then
		if forAll_max ~= forAll_Variable or tonumber(forAll_min) then
			if (tonumber(input) :: number) < tonumber(forAll_min) :: number then
				ForAllMaxPixelsBox.Text = forAll_max
				return warn("MaxThickness cannot be smaller than MinThickness")
			end
		end
		
		if (tonumber(input) :: number) < 0 then
			ForAllMaxPixelsBox.Text = forAll_max
			return warn("Must be a positive number")
		end

		setMinMaxAll(nil, tonumber(input))
		ForAllMaxPixelsBox.Text = input
		forAll_max = input
		warn("All UIStroke objects' thickness now can be raised to " .. input .. " maximum")
	elseif input == "" then

	else
		ForAllMaxPixelsBox.Text = forAll_max
	end
end)

ForAllMinPixelsBox.FocusLost:Connect(function()
	local input = ForAllMinPixelsBox.Text

	if isNumber(input) then
		if forAll_min ~= forAll_Variable or tonumber(forAll_max) then
			if tonumber(input) :: number > tonumber(forAll_max) :: number then
				warn("MinThickness cannot be larger than MaxThickness")
				ForAllMinPixelsBox.Text = forAll_min
				return
			end
		end
		
		if (tonumber(input) :: number) < 0 then
			ForAllMinPixelsBox.Text = forAll_min
			return warn("Must be a positive number")
		end
		
		setMinMaxAll(tonumber(input), nil)
		ForAllMinPixelsBox.Text = input
		forAll_min = input
		warn("All UIStroke objects' thickness now can be lowered to " .. input .. " minimum")
	elseif input == "" then

	else
		ForAllMinPixelsBox.Text = forAll_min
	end
end)

ForAllUpperScale.Activated:Connect(function()
	forAll_ScaleType = "UpperScale"
	ForAllUpperScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
	ForAllLowerScale.BackgroundColor3 = themeColors[currentTheme]["Button"]
end)

ForAllLowerScale.Activated:Connect(function()
	forAll_ScaleType = "LowerScale"
	ForAllUpperScale.BackgroundColor3 = themeColors[currentTheme]["Button"]
	ForAllLowerScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
end)

Selection.SelectionChanged:Connect(function()
	local objects = Selection:Get()
	
	local function setState(a)
		ReturnFromIndividual.Visible = a
		SelectText.Visible = a
		IndividualWarning.Visible = not a
		UIStrokeInfo.Visible = false
	end
	
	if #objects > 1 then
		setState(false)
	elseif #objects == 0 then
		setState(true)
	else
		local stroke = objects[1]
		
		pcall(function()
			if stroke:IsA("UIStroke") then
				ReturnFromIndividual.Visible = false
				SelectText.Visible = false
				IndividualWarning.Visible = false

				if stroke:GetAttribute("UseScale") == false then
					IndividualMaxPixelsBox.TextEditable = false
					IndividualMinPixelsBox.TextEditable = false
				else
					IndividualMaxPixelsBox.TextEditable = true
					IndividualMinPixelsBox.TextEditable = true
				end

				individual_min = tostring(if stroke:GetAttribute("MinThickness") then stroke:GetAttribute("MinThickness") else 0)
				individual_max = tostring(if stroke:GetAttribute("MaxThickness") then stroke:GetAttribute("MaxThickness") else math.huge)
				individual_lower = stroke:GetAttribute("LowerScale")
				individual_upper = stroke:GetAttribute("UpperScale")

				IndividualUpperIndicator.Text = if stroke:GetAttribute("UpperScale") then stroke:GetAttribute("UpperScale") else "No info"
				IndividualLowerIndicator.Text = if stroke:GetAttribute("LowerScale") then stroke:GetAttribute("LowerScale") else "No info"
				IndividualMaxPixelsBox.Text = if stroke:GetAttribute("MaxThickness") then stroke:GetAttribute("MaxThickness") else "No info"
				IndividualMinPixelsBox.Text = if stroke:GetAttribute("MinThickness") then stroke:GetAttribute("MinThickness") else "No info"

				IndividualCurrentScale.Text = "Current scale type: " .. if stroke:GetAttribute("ScaleType") then stroke:GetAttribute("ScaleType") else "No info"

				UIStrokeInfo.Visible = true
			else
				setState(true)
			end
		end)
	end
end)

IndividualMaxPixelsBox.FocusLost:Connect(function()
	local input = IndividualMaxPixelsBox.Text

	if isNumber(input) then
		if (tonumber(input) :: number) < tonumber(individual_min) :: number then
			warn("MaxThickness cannot be smaller than MinThickness")
			IndividualMaxPixelsBox.Text = individual_max
			return
		end

		if (tonumber(input) :: number) < 0 then
			IndividualMaxPixelsBox.Text = individual_max
			return warn("Must be a positive number")
		end

		setMinMaxAll(nil, tonumber(input))
		IndividualMaxPixelsBox.Text = input
		individual_max = input
	elseif input == "" then
		
	else
		IndividualMaxPixelsBox.Text = individual_max
	end
end)

IndividualMinPixelsBox.FocusLost:Connect(function()
	local input = IndividualMinPixelsBox.Text

	if isNumber(input) then
		if (tonumber(input) :: number) > tonumber(individual_max) :: number then
			warn("MinThickness cannot be larger than MaxThickness")
			IndividualMinPixelsBox.Text = individual_min
			return
		end

		if (tonumber(input) :: number) < 0 then
			IndividualMinPixelsBox.Text = individual_min
			return warn("Must be a positive number")
		end

		setMinMaxAll(tonumber(input), nil)
		IndividualMinPixelsBox.Text = input
		individual_min = input
	elseif input == "" then

	else
		IndividualMinPixelsBox.Text = individual_min
	end
end)

IndividualInsert.Activated:Connect(function()
	local stroke = Selection:Get()[1]
	scale(stroke, true, "Individual")
	individual_min = "0"
	individual_max = tostring(math.huge)
	individual_lower = stroke:GetAttribute("LowerScale")
	individual_upper = stroke:GetAttribute("UpperScale")
	IndividualMaxPixelsBox.TextEditable = true
	IndividualMinPixelsBox.TextEditable = true
	IndividualMinPixelsBox.Text = individual_min
	IndividualMaxPixelsBox.Text = individual_max
	IndividualLowerIndicator.Text = stroke:GetAttribute("LowerScale")
	IndividualUpperIndicator.Text = stroke:GetAttribute("UpperScale")
	IndividualCurrentScale.Text = "Current type: " .. individual_ScaleType
end)

IndividualDelete.Activated:Connect(function()
	scale(Selection:Get()[1], false, "Individual")
	individual_min = "No info"
	individual_max = "No info"
	individual_lower = "No info"
	individual_upper = "No info"
	IndividualMaxPixelsBox.TextEditable = false
	IndividualMinPixelsBox.TextEditable = false
	IndividualMinPixelsBox.Text = "No info"
	IndividualMaxPixelsBox.Text = "No info"
	IndividualLowerIndicator.Text = "No info"
	IndividualUpperIndicator.Text = "No info"
	IndividualCurrentScale.Text = "Current type: No info"
end)

-- Starter
ForAllMaxPixelsBox.Text = forAll_Variable
ForAllMinPixelsBox.Text = forAll_Variable

Individual.Position = WORKPLACE_POSITION
ForAllMaxMin.Position = WORKPLACE_POSITION
ForAllScale.Position = WORKPLACE_POSITION
OptionsMenu.Position = MUTUAL_POSITION

Individual.Visible = true
ForAllMaxMin.Visible = true
ForAllScale.Visible = true
OptionsMenu.Visible = true

ForAllUpperScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ForAllLowerScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
IndividualLowerScale.BackgroundColor3 = SCALE_OPTION_BACKGROUND
IndividualUpperScale.BackgroundColor3 = Color3.fromRGB(46, 46, 46)

for i, v in game:GetDescendants() do
	if v:IsA("UIStroke") then
		local min, max = v:GetAttribute("MinThickness"), v:GetAttribute("MaxThickness")
		if min and max then
			if min > max then
				if MINMAX_FIXFACTOR then
					v:SetAttribute("MaxThickness", v:GetAttribute("MinThickness"))
				else
					v:SetAttribute("MinThickness", v:GetAttribute("MaxThickness"))
				end
			end
		end
	end
end

if TESTING_PROCESS then
	plugin.Parent = workspace
end

local function checkColorEquality(color1: Color3, color2: Color3)
	return if color1.R == color2.R and color1.G == color2.G and color1.B == color2.B then true else false
end

local function findCorrespondingColor(property)
	local function other()
		return if currentTheme == "Dark" then "Light" else "Dark"
	end
	
	for name, color in themeColors[other()] do
		if checkColorEquality(themeColors[currentTheme][name], property) then
			return color
		end
	end
	
	return
end

local function changeColors()
	if settings().Studio.Theme.Name :: any ~= currentTheme then
		for i, v in widget:GetDescendants() do
			for i, property in properties do
				pcall(function()
					if typeof(v[property]) == "Color3" then
						v[property] = findCorrespondingColor(v[property])
					end
				end)
			end
		end
	end
	
	currentTheme = settings().Studio.Theme.Name :: any
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	adjustViewportSize()
end)

adjustViewportSize()

settings().Studio.ThemeChanged:Connect(function()
	changeColors()
end)

changeColors()
