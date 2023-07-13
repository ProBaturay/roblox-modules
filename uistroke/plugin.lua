--15:51 UTC+3 2021/07/12
--!strict

type TextObject = TextLabel | TextBox | TextButton

local CURRENT_SCALE_TYPE = "UpperScale"
local TESTING_PROCESS = false
local TEXTSIZE_METHOD = "GetTextSize"
local option_background = Color3.fromRGB(15, 178, 227)

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
				
				if UIStroke:GetAttribute("UseScale") then
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
						local vector2 = TextService:GetTextSize((parent :: TextObject).Text, (parent :: TextObject).TextSize, (parent :: TextObject).Font, (parent :: TextObject).AbsoluteSize)
						local a, b = vector2.X, vector2.Y
						return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
					end

					local function update()
						if absoluteSizeChanged and absoluteSizeChanged.Connected then
							absoluteSizeChanged:Disconnect()
						end

						parent = UIStroke.Parent :: GuiObject

						if not parent or not parent:IsA("GuiObject") then
							return
						end
						
						if UIStroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
							absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
								UIStroke.Thickness = determineDimension(scaleType) * UIStroke:GetAttribute(scaleType)
							end)
						else
							if isTextObject(parent :: TextObject) then
								if UIStroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Contextual then
									if TEXTSIZE_METHOD == "GetTextSize" then
										absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
											UIStroke.Thickness = determineDimension(scaleType) * UIStroke:GetAttribute(scaleType)
										end)
									else

									end
								end
							else
								absoluteSizeChanged = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
									UIStroke.Thickness = determineDimension(scaleType) * UIStroke:GetAttribute(scaleType)
								end)
							end
						end
					end
					
					UIStroke.AncestryChanged:Connect(update)

					update()
					--UIStroke:GetAttributeChangedSignal("LowerScale"):Connect(update)
					--UIStroke:GetAttributeChangedSignal("UpperScale"):Connect(update)
					
					UIStroke:GetAttributeChangedSignal("ScaleType"):Connect(function()
						scaleType = UIStroke:GetAttribute("ScaleType")
					end)
				elseif UIStroke:GetAttribute("UseScale") == false then

				end

				local useScale = UIStroke:GetAttribute("UseScale")
				local debounce = false

				UIStroke:GetAttributeChangedSignal("UseScale"):Connect(function()
					warn(SCALING_WARNINGTEXT)

					if not debounce then
						debounce = true
						UIStroke:SetAttribute("UseScale", useScale)

						local conn: RBXScriptConnection
						conn = LogService.MessageOut:Connect(function(message: string, messageType: Enum.MessageType)
							if message == SCALING_WARNINGTEXT then
								debounce = false
								conn:Disconnect()
							end
						end)
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
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 0, 0, 15)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(172, 172, 172)
TextLabel.Text = "Scale UIStroke Thickness"
TextLabel.TextWrapped = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.Parent = Main

local Frame2 = Instance.new("Frame")
Frame2.AnchorPoint = Vector2.new(0.5, 0)
Frame2.Size = UDim2.new(0, 220, 0, 135)
Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame2.Position = UDim2.new(0.5, 0, 0.1, 0)
Frame2.BorderSizePixel = 0
Frame2.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Frame2.Parent = Main

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame2

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.AnchorPoint = Vector2.new(0.5, 0)
TextLabel1.Size = UDim2.new(0, 134, 0, 30)
TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0.3318182, 0, 0, 0)
TextLabel1.BorderSizePixel = 0
TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Current viewport size"
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.Parent = Frame2

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = Frame2

local ViewportSize = Instance.new("TextLabel")
ViewportSize.Name = "ViewportSize"
ViewportSize.AnchorPoint = Vector2.new(0.5, 0)
ViewportSize.Size = UDim2.new(0, 78, 0, 30)
ViewportSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
ViewportSize.BackgroundTransparency = 1
ViewportSize.Position = UDim2.new(0.8199675, 0, -0.001389, 0)
ViewportSize.BorderSizePixel = 0
ViewportSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ViewportSize.TextSize = 14
ViewportSize.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewportSize.Text = "1920x1080"
ViewportSize.Font = Enum.Font.Gotham
ViewportSize.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(0, 89, 0, 16)
TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(0, 8, 0.22, 0)
TextLabel2.BorderSizePixel = 0
TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextSize = 14
TextLabel2.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel2.Text = "For all"
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.Parent = Frame2

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.AnchorPoint = Vector2.new(1, 0)
TextLabel3.Size = UDim2.new(0, 87, 0, 16)
TextLabel3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Position = UDim2.new(1, -8, 0.22, 0)
TextLabel3.BorderSizePixel = 0
TextLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.TextSize = 14
TextLabel3.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel3.Text = "Choose"
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.Parent = Frame2

local Frame3 = Instance.new("Frame")
Frame3.AnchorPoint = Vector2.new(0, 1)
Frame3.Size = UDim2.new(0.4, 0, 0, 76)
Frame3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame3.BackgroundTransparency = 1
Frame3.Position = UDim2.new(0, 8, 1, -8)
Frame3.BorderSizePixel = 0
Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame3.Parent = Frame2

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Thickness = 2
UIStroke1.Parent = Frame3

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = Frame3

local InsertScaleButton = Instance.new("TextButton")
InsertScaleButton.AnchorPoint = Vector2.new(0.5, 0)
InsertScaleButton.Size = UDim2.new(1, -10, 0, 26)
InsertScaleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
InsertScaleButton.Position = UDim2.new(0.5, 0, 0, 6)
InsertScaleButton.BorderSizePixel = 0
InsertScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
InsertScaleButton.TextSize = 14
InsertScaleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InsertScaleButton.Text = "Insert scale"
InsertScaleButton.TextWrapped = true
InsertScaleButton.Font = Enum.Font.Gotham
InsertScaleButton.Parent = Frame3

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Thickness = 2
UIStroke2.Parent = InsertScaleButton

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = InsertScaleButton

local DeleteScaleButton = Instance.new("TextButton")
DeleteScaleButton.AnchorPoint = Vector2.new(0.5, 1)
DeleteScaleButton.Size = UDim2.new(1, -10, 0, 26)
DeleteScaleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DeleteScaleButton.Position = UDim2.new(0.5, 0, 1, -6)
DeleteScaleButton.BorderSizePixel = 0
DeleteScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
DeleteScaleButton.TextSize = 14
DeleteScaleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteScaleButton.Text = "Delete scale"
DeleteScaleButton.TextWrapped = true
DeleteScaleButton.Font = Enum.Font.Gotham
DeleteScaleButton.Parent = Frame3

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Thickness = 2
UIStroke3.Parent = DeleteScaleButton

local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = DeleteScaleButton

local Frame4 = Instance.new("Frame")
Frame4.AnchorPoint = Vector2.new(1, 1)
Frame4.Size = UDim2.new(0.4, 0, 0, 76)
Frame4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame4.BackgroundTransparency = 1
Frame4.Position = UDim2.new(1, -8, 1, -8)
Frame4.BorderSizePixel = 0
Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame4.Parent = Frame2

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Thickness = 2
UIStroke4.Parent = Frame4

local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = Frame4

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel4.Size = UDim2.new(1, -8, 1, -8)
TextLabel4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel4.BorderSizePixel = 0
TextLabel4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel4.TextSize = 14
TextLabel4.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel4.Text = "Use this feature on the next update!"
TextLabel4.TextWrapped = true
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.Parent = Frame4

local Frame5 = Instance.new("Frame")
Frame5.AnchorPoint = Vector2.new(0.5, 1)
Frame5.Size = UDim2.new(0, 2, 0, 100)
Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame5.Position = UDim2.new(0.5, 0, 1, -4)
Frame5.BorderSizePixel = 0
Frame5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame5.Parent = Frame2

local Frame6 = Instance.new("Frame")
Frame6.AnchorPoint = Vector2.new(0.5, 1)
Frame6.Size = UDim2.new(0, 220, 0, 50)
Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame6.BackgroundTransparency = 1
Frame6.Position = UDim2.new(0.5000001, 0, 1, 0)
Frame6.BorderSizePixel = 0
Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame6.Parent = Main

local Frame7 = Instance.new("Frame")
Frame7.AnchorPoint = Vector2.new(0, 1)
Frame7.Size = UDim2.new(0, 48, 0, 48)
Frame7.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame7.Position = UDim2.new(0, 0, 1, 0)
Frame7.BorderSizePixel = 0
Frame7.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame7.Parent = Frame6

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Thickness = 2
UIStroke5.Parent = Frame7

local UICorner5 = Instance.new("UICorner")
UICorner5.Parent = Frame7

local InfoButton = Instance.new("TextButton")
InfoButton.Name = "InfoButton"
InfoButton.AnchorPoint = Vector2.new(0.5, 0.5)
InfoButton.Size = UDim2.new(1, 0, 1, 0)
InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
InfoButton.Position = UDim2.new(0.5, 0, 0.5, 0)
InfoButton.BorderSizePixel = 0
InfoButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
InfoButton.TextSize = 14
InfoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoButton.Text = "Info"
InfoButton.Font = Enum.Font.Gotham
InfoButton.Parent = Frame7

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Thickness = 2
UIStroke6.Parent = InfoButton

local UICorner6 = Instance.new("UICorner")
UICorner6.Parent = InfoButton

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Size = UDim2.new(0, 158, 0, 50)
TextLabel5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel5.Position = UDim2.new(1.2920001, 0, 0, 0)
TextLabel5.BorderSizePixel = 0
TextLabel5.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextLabel5.TextSize = 14
TextLabel5.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel5.Text = "Scale stroke thickness. For more info, click the button on the left."
TextLabel5.TextWrapped = true
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.Parent = Frame7

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Thickness = 2
UIStroke7.Parent = TextLabel5

local UICorner7 = Instance.new("UICorner")
UICorner7.Parent = TextLabel5

local Info = Instance.new("Frame")
Info.Name = "Info"
Info.AnchorPoint = Vector2.new(0.5, 0.5)
Info.Size = UDim2.new(1, -40, 0, 250)
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(1.5, 0, 0.5, 0)
Info.Parent = Frame

local TextLabel6 = Instance.new("TextLabel")
TextLabel6.AnchorPoint = Vector2.new(0.5, 0)
TextLabel6.Size = UDim2.new(1, 0, 0, 15)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Position = UDim2.new(0.5, 0, 0, 0)
TextLabel6.TextSize = 12
TextLabel6.TextColor3 = Color3.fromRGB(172, 172, 172)
TextLabel6.Text = "Scale UIStroke Thickness"
TextLabel6.TextWrapped = true
TextLabel6.Font = Enum.Font.Gotham
TextLabel6.Parent = Info

local Frame8 = Instance.new("Frame")
Frame8.AnchorPoint = Vector2.new(0.5, 1)
Frame8.Size = UDim2.new(0, 220, 0, 207)
Frame8.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame8.Position = UDim2.new(0.5, 0, 0.828, 0)
Frame8.BorderSizePixel = 0
Frame8.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Frame8.Parent = Info

local UICorner8 = Instance.new("UICorner")
UICorner8.Parent = Frame8

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel7.Size = UDim2.new(0, 210, 0, 200)
TextLabel7.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Position = UDim2.new(0.5, 0, 0.5028177, 0)
TextLabel7.BorderSizePixel = 0
TextLabel7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel7.TextSize = 14
TextLabel7.RichText = true
TextLabel7.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel7.Text = "There are two types of scaling internally programmed in the plugin: UpperScale and LowerScale. UpperScale is used in accordance with one UDim value if it is larger than the other dimension, whereas LowerScale is used with the one which is smaller than the other.<br/><br/>You have to scale them while you have the viewport size adjusted at the desired."
TextLabel7.TextWrapped = true
TextLabel7.Font = Enum.Font.Gotham
TextLabel7.Parent = Frame8

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Thickness = 2
UIStroke8.Parent = Frame8

local Frame9 = Instance.new("Frame")
Frame9.AnchorPoint = Vector2.new(0.5, 1)
Frame9.Size = UDim2.new(0, 150, 0, 30)
Frame9.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame9.Position = UDim2.new(0.5, 0, 1, 0)
Frame9.BorderSizePixel = 0
Frame9.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame9.Parent = Info

local ReturnFromInfoButton = Instance.new("TextButton")
ReturnFromInfoButton.AnchorPoint = Vector2.new(0.5, 0.5)
ReturnFromInfoButton.Size = UDim2.new(1, 0, 1, 0)
ReturnFromInfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ReturnFromInfoButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ReturnFromInfoButton.BorderSizePixel = 0
ReturnFromInfoButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ReturnFromInfoButton.TextSize = 14
ReturnFromInfoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnFromInfoButton.Text = "Return to main menu"
ReturnFromInfoButton.Font = Enum.Font.Gotham
ReturnFromInfoButton.Parent = Frame9

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Thickness = 2
UIStroke9.Parent = ReturnFromInfoButton

local UICorner9 = Instance.new("UICorner")
UICorner9.Parent = ReturnFromInfoButton

local ScaleOptionFrame = Instance.new("Frame")
ScaleOptionFrame.ZIndex = 2
ScaleOptionFrame.AnchorPoint = Vector2.new(0.5, 1)
ScaleOptionFrame.Size = UDim2.new(0, 220, 0, 23)
ScaleOptionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScaleOptionFrame.BackgroundTransparency = 1
ScaleOptionFrame.Position = UDim2.new(0.5, 0, 0, 192)
ScaleOptionFrame.BorderSizePixel = 0
ScaleOptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScaleOptionFrame.Parent = Main

local UpperScaleButton = Instance.new("TextButton")
UpperScaleButton.AutoButtonColor = false
UpperScaleButton.Size = UDim2.new(0, 23, 1, 0)
UpperScaleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UpperScaleButton.BorderSizePixel = 0
UpperScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
UpperScaleButton.TextSize = 14
UpperScaleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
UpperScaleButton.Text = ""
UpperScaleButton.Font = Enum.Font.SourceSans
UpperScaleButton.Parent = ScaleOptionFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Parent = UpperScaleButton

local UICorner = Instance.new("UICorner")
UICorner.Parent = UpperScaleButton

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0, 0.5)
TextLabel.Size = UDim2.new(0, 75, 0, 30)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(1, 6, 0.5, 0)
TextLabel.BorderSizePixel = 0
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Upper scale"
TextLabel.Font = Enum.Font.Gotham
TextLabel.Parent = UpperScaleButton

local LowerScaleButton = Instance.new("TextButton")
LowerScaleButton.AutoButtonColor = false
LowerScaleButton.Size = UDim2.new(0, 23, 1, 0)
LowerScaleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
LowerScaleButton.Position = UDim2.new(0.5272727, 0, 0, 0)
LowerScaleButton.BorderSizePixel = 0
LowerScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
LowerScaleButton.TextSize = 14
LowerScaleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
LowerScaleButton.Text = ""
LowerScaleButton.Font = Enum.Font.SourceSans
LowerScaleButton.Parent = ScaleOptionFrame

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke1.Thickness = 2
UIStroke1.Parent = LowerScaleButton

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = LowerScaleButton

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.AnchorPoint = Vector2.new(0, 0.5)
TextLabel1.Size = UDim2.new(0, 77, 0, 30)
TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(1, 6, 0.5, 0)
TextLabel1.BorderSizePixel = 0
TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Lower scale"
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.Parent = LowerScaleButton

local TInfo_Slide = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

InfoButton.Activated:Connect(function()
	TweenService:Create(Main, TInfo_Slide, {Position = UDim2.fromScale(-0.5, 0.5)}):Play()
	TweenService:Create(Info, TInfo_Slide, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
end)

ReturnFromInfoButton.Activated:Connect(function()
	TweenService:Create(Info, TInfo_Slide, {Position = UDim2.fromScale(1.5, 0.5)}):Play()
	TweenService:Create(Main, TInfo_Slide, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
end)

UpperScaleButton.Activated:Connect(function()
	CURRENT_SCALE_TYPE = "UpperScale"
	UpperScaleButton.BackgroundColor3 = option_background
	LowerScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
end)

LowerScaleButton.Activated:Connect(function()
	CURRENT_SCALE_TYPE = "LowerScale"
	LowerScaleButton.BackgroundColor3 = option_background
	UpperScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
end)

local function getViewportSize()
	local camera = workspace:FindFirstChild("Camera")

	if camera then
		return camera.ViewportSize
	end
	
	local temporaryScreenGui = Instance.new("ScreenGui")
	temporaryScreenGui.Parent = StarterGui

	local temporaryFrame = Instance.new("Frame")
	temporaryFrame.Active = false
	temporaryFrame.BackgroundTransparency = 1
	temporaryFrame.Size = UDim2.new(1, 0, 1, 0)
	temporaryFrame.Position = UDim2.new(10, 0, 10, 0)
	temporaryFrame.Parent = temporaryScreenGui
	
	task.defer(function()
		temporaryScreenGui:Destroy()
	end)
	
	return temporaryFrame.AbsoluteSize
end

local function isTextObject(object: TextObject)
	return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
end

local function scaleAll(enable: boolean)
	local objects = {}
	for i, v in game:GetDescendants() do
		if v:IsA("UIStroke") then
			if enable then
				local parent = v.Parent
				
				if not (parent and parent:IsA("GuiObject")) then 
					return
				end
				
				v:SetAttribute("ScaleType", CURRENT_SCALE_TYPE)
				v:SetAttribute("UseScale", true)

				local function determineDimension(condition)
					local a, b = parent.AbsoluteSize.X, parent.AbsoluteSize.Y
					return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
				end

				local function determineDimensionForText(condition)
					local vector2 = TextService:GetTextSize((parent :: TextObject).Text, (parent :: TextObject).TextSize, (parent :: TextObject).Font, (parent :: TextObject).AbsoluteSize)
					local a, b = vector2.X, vector2.Y
					return if condition == "LowerScale" then (if a > b then b else a) else (if a > b then a else b)
				end
				
				if v.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
					v:SetAttribute("LowerScale", v.Thickness / determineDimension("LowerScale"))
					v:SetAttribute("UpperScale", v.Thickness / determineDimension("UpperScale"))
				else
					if isTextObject(parent :: TextObject) then
						if TEXTSIZE_METHOD == "GetTextSize" then
							v:SetAttribute("LowerScale", v.Thickness / determineDimensionForText("LowerScale"))
							v:SetAttribute("UpperScale", v.Thickness / determineDimensionForText("UpperScale"))
						end
					else
						v:SetAttribute("LowerScale", v.Thickness / determineDimension("LowerScale"))
						v:SetAttribute("UpperScale", v.Thickness / determineDimension("UpperScale"))
					end
				end
			else
				v:SetAttribute("UseScale", false)
				v:SetAttribute("LowerScale", nil)
				v:SetAttribute("UpperScale", nil)
				v:SetAttribute("ScaleType", nil)
			end
			
			table.insert(objects, v)
		end
	end
	
	Selection:Set(objects)
end

InsertScaleButton.Activated:Connect(function()
	scaleAll(true)
	warn("UIStroke objects were applied scale.")
end)

DeleteScaleButton.Activated:Connect(function()
	scaleAll(false)
	warn("No scale will be applied to UIStroke objects.")
end)

if TESTING_PROCESS then
	plugin.Parent = workspace
end

-- Starter

LowerScaleButton.BackgroundColor3 = option_background
UpperScaleButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)

-- Loop

while true do
	task.wait(1)
	local size = getViewportSize()
	ViewportSize.Text = math.floor(size.X) .. "x" .. math.floor(size.Y)
end
