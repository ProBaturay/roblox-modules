--21:37 UTC+3 24/07/2023
--!strict

local SELECTION_BACKGROUND = Color3.fromRGB(15, 178, 227)
local ACTIVE_SCRIPT_BACKGROUND = Color3.fromRGB(142, 114, 255)
local currentTheme = "Dark"

local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local HTTPService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ScriptEditorService = game:GetService("ScriptEditorService")

if RunService:IsRunning() then
	return
end

local plugin = plugin or getfenv().PluginManager():CreatePlugin()
plugin.Name = "ScriptPropertiesPlugin"

local dockWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	300,
	315,
	300,
	315
)

local toolbar = plugin:CreateToolbar("Script Source Properties")

local button = toolbar:CreateButton("Open Menu", "Check total lines and characters of your scripts!", "http://www.roblox.com/asset/?id=14050607586") -- TODO change icon
button.ClickableWhenViewportHidden = true

local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui(
	"385026300",
	dockWidgetInfo
)

widget.ResetOnSpawn = false
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widget.Title = "Character and Line Counter"

button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

local mainBackground = Instance.new("Frame")
mainBackground.Name = "scripts"
mainBackground.ZIndex = 2
mainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
mainBackground.Size = UDim2.new(1, 0, 1, 0)
mainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
mainBackground.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
mainBackground.Parent = widget

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.new(1, -40, 1, -40)
Main.BackgroundTransparency = 1
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Parent = mainBackground

local Settings = Instance.new("Frame")
Settings.Position = UDim2.new(0.5, 0, 1, -25)
Settings.AnchorPoint = Vector2.new(0.5, 1)
Settings.Size = UDim2.new(1, 0, 0, 56)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Settings

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = Settings

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 15)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Script Character & Line Counter"
TextLabel.TextWrapped = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.Parent = Main

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.AnchorPoint = Vector2.new(0.5, 1)
TextLabel1.Size = UDim2.new(1, 0, 0, 15)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0.5, 0, 1, 0)
TextLabel1.TextSize = 12
TextLabel1.RichText = true
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Made by <b>@ProBaturay</b> with love!"
TextLabel1.TextWrapped = true
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.Parent = Main

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -240)
ScrollingFrame.ClipsDescendants = true
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 25)
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = Main

local UIStrokeScrolling = Instance.new("UIStroke")
UIStrokeScrolling.Thickness = 2
UIStrokeScrolling.Parent = ScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 6)
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.Parent = ScrollingFrame

local Example = Instance.new("Frame")
Example.Name = "Example"
Example.Size = UDim2.new(1, -16, 0, 25)
Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
Example.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Example.LayoutOrder = 1
Example.Parent = ScrollingFrame

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Parent = Example

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = Example

local FullName = Instance.new("TextLabel")
FullName.Name = "FullName"
FullName.Size = UDim2.new(1, -110, 1, 0)
FullName.BorderColor3 = Color3.fromRGB(0, 0, 0)
FullName.BackgroundTransparency = 1
FullName.Position = UDim2.new(0, 8, 0, 0)
FullName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FullName.TextTruncate = Enum.TextTruncate.AtEnd
FullName.TextSize = 14
FullName.TextColor3 = Color3.fromRGB(163, 162, 165)
FullName.Text = "Directory"
FullName.Font = Enum.Font.Gotham
FullName.TextXAlignment = Enum.TextXAlignment.Left
FullName.Parent = Example

local Characters = Instance.new("TextLabel")
Characters.Name = "Characters"
Characters.AnchorPoint = Vector2.new(1, 0)
Characters.Size = UDim2.new(0, 70, 1, 0)
Characters.BorderColor3 = Color3.fromRGB(0, 0, 0)
Characters.BackgroundTransparency = 1
Characters.Position = UDim2.new(1, -38, 0, 0)
Characters.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Characters.TextTruncate = Enum.TextTruncate.AtEnd
Characters.TextSize = 14
Characters.TextColor3 = Color3.fromRGB(163, 162, 165)
Characters.Text = "Characters"
Characters.Font = Enum.Font.Gotham
Characters.Parent = Example

local Lines = Instance.new("TextLabel")
Lines.Name = "Lines"
Lines.AnchorPoint = Vector2.new(1, 0)
Lines.Size = UDim2.new(0, 40, 1, 0)
Lines.BorderColor3 = Color3.fromRGB(0, 0, 0)
Lines.BackgroundTransparency = 1
Lines.Position = UDim2.new(1, 0, 0, 0)
Lines.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Lines.TextTruncate = Enum.TextTruncate.AtEnd
Lines.TextSize = 14
Lines.TextColor3 = Color3.fromRGB(163, 162, 165)
Lines.Text = "Lines"
Lines.Font = Enum.Font.Gotham
Lines.Parent = Example

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, -16, 0, 2)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.LayoutOrder = 2
Frame.Parent = ScrollingFrame

local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.AnchorPoint = Vector2.new(0.5, 1)
Settings.Size = UDim2.new(1, 0, 0, 56)
Settings.BackgroundTransparency = 1
Settings.Position = UDim2.new(0.5, 0, 1, -25)
Settings.BorderSizePixel = 0
Settings.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(10, 10, 10)
UIStroke.Parent = Settings

local UICorner = Instance.new("UICorner")
UICorner.Parent = Settings

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 20, 0, 20)
Frame.Position = UDim2.new(0, 4, 0, 4)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame.Parent = Settings

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Thickness = 2
UIStroke1.Color = Color3.fromRGB(10, 10, 10)
UIStroke1.Parent = Frame

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = Frame

local Whitespace = Instance.new("TextButton")
Whitespace.Name = "Whitespace"
Whitespace.AnchorPoint = Vector2.new(0.5, 0.5)
Whitespace.Size = UDim2.new(1, 0, 1, 0)
Whitespace.Position = UDim2.new(0.5, 0, 0.5, 0)
Whitespace.BorderSizePixel = 0
Whitespace.BackgroundColor3 = Color3.fromRGB(15, 178, 227)
Whitespace.AutoButtonColor = false
Whitespace.TextSize = 14
Whitespace.TextColor3 = Color3.fromRGB(255, 255, 255)
Whitespace.Text = ""
Whitespace.Font = Enum.Font.Gotham
Whitespace.Parent = Frame

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Thickness = 2
UIStroke2.Color = Color3.fromRGB(10, 10, 10)
UIStroke2.Parent = Whitespace

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = Whitespace

local Frame1 = Instance.new("Frame")
Frame1.AnchorPoint = Vector2.new(0, 1)
Frame1.Size = UDim2.new(0, 20, 0, 20)
Frame1.Position = UDim2.new(0, 4, 1, -4)
Frame1.BorderSizePixel = 0
Frame1.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame1.Parent = Settings

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Thickness = 2
UIStroke3.Color = Color3.fromRGB(10, 10, 10)
UIStroke3.Parent = Frame1

local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = Frame1

local OpenCloseScript = Instance.new("TextButton")
OpenCloseScript.Name = "OpenCloseScript"
OpenCloseScript.AnchorPoint = Vector2.new(0.5, 0.5)
OpenCloseScript.Size = UDim2.new(1, 0, 1, 0)
OpenCloseScript.Position = UDim2.new(0.5, 0, 0.5, 0)
OpenCloseScript.BorderSizePixel = 0
OpenCloseScript.BackgroundColor3 = Color3.fromRGB(15, 178, 227)
OpenCloseScript.AutoButtonColor = false
OpenCloseScript.TextSize = 14
OpenCloseScript.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseScript.Text = ""
OpenCloseScript.Font = Enum.Font.Gotham
OpenCloseScript.Parent = Frame1

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Thickness = 2
UIStroke4.Color = Color3.fromRGB(10, 10, 10)
UIStroke4.Parent = OpenCloseScript

local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = OpenCloseScript

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0, 1)
TextLabel.Size = UDim2.new(1, -36, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 28, 1, -4)
TextLabel.BorderSizePixel = 0
TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Toggle script visibility when clicked above"
TextLabel.TextWrapped = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Settings

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.Size = UDim2.new(1, -36, 0, 20)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0, 28, 0, 4)
TextLabel1.BorderSizePixel = 0
TextLabel1.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Whitespace included"
TextLabel1.TextWrapped = true
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
TextLabel1.Parent = Settings


local Stats_ = Instance.new("Frame")
Stats_.Name = "Stats"
Stats_.AnchorPoint = Vector2.new(0.5, 1)
Stats_.Size = UDim2.new(1, 0, 0, 100)
Stats_.BackgroundTransparency = 1
Stats_.Position = UDim2.new(0.5, 0, 1, -90)
Stats_.BorderSizePixel = 0
Stats_.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(10, 10, 10)
UIStroke.Parent = Stats_

local UICorner = Instance.new("UICorner")
UICorner.Parent = Stats_

local Frame = Instance.new("Frame")
Frame.ZIndex = 3
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Size = UDim2.new(1, -8, 0, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.5, 0, 0, 4)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame.Parent = Stats_

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Color = Color3.fromRGB(10, 10, 10)
UIStroke1.Parent = Frame

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = Frame

local TextLabel = Instance.new("TextLabel")
TextLabel.ZIndex = 3
TextLabel.AnchorPoint = Vector2.new(0, 0.5)
TextLabel.Size = UDim2.new(0, 90, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 4, 0.5, 0)
TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Script"
TextLabel.TextWrapped = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local ScriptLines = Instance.new("TextLabel")
ScriptLines.Name = "ScriptLines"
ScriptLines.ZIndex = 3
ScriptLines.AnchorPoint = Vector2.new(1, 0.5)
ScriptLines.Size = UDim2.new(0, 40, 0, 20)
ScriptLines.BackgroundTransparency = 1
ScriptLines.Position = UDim2.new(1, 0, 0.5, 0)
ScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
ScriptLines.TextSize = 14
ScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptLines.Text = "0"
ScriptLines.TextWrapped = true
ScriptLines.Font = Enum.Font.Gotham
ScriptLines.Parent = Frame

local ScriptCharacters = Instance.new("TextLabel")
ScriptCharacters.Name = "ScriptCharacters"
ScriptCharacters.ZIndex = 3
ScriptCharacters.AnchorPoint = Vector2.new(1, 0.5)
ScriptCharacters.Size = UDim2.new(0, 70, 0, 20)
ScriptCharacters.BackgroundTransparency = 1
ScriptCharacters.Position = UDim2.new(0.6, 60, 0.5, 0)
ScriptCharacters.BorderSizePixel = 0
ScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
ScriptCharacters.TextSize = 14
ScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptCharacters.Text = "0"
ScriptCharacters.TextWrapped = true
ScriptCharacters.Font = Enum.Font.Gotham
ScriptCharacters.Parent = Frame

local ScriptObjects = Instance.new("TextLabel")
ScriptObjects.Name = "ScriptObjects"
ScriptObjects.ZIndex = 3
ScriptObjects.AnchorPoint = Vector2.new(1, 0.5)
ScriptObjects.Size = UDim2.new(0, 70, 0, 20)
ScriptObjects.BackgroundTransparency = 1
ScriptObjects.Position = UDim2.new(0.2, 100, 0.5, 0)
ScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
ScriptObjects.TextSize = 14
ScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptObjects.Text = "0"
ScriptObjects.TextWrapped = true
ScriptObjects.Font = Enum.Font.Gotham
ScriptObjects.Parent = Frame

local Frame1 = Instance.new("Frame")
Frame1.ZIndex = 3
Frame1.AnchorPoint = Vector2.new(0.5, 0)
Frame1.Size = UDim2.new(1, -8, 0, 20)
Frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame1.Position = UDim2.new(0.5, 0, 0, 28)
Frame1.BorderSizePixel = 0
Frame1.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame1.Parent = Stats_

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(10, 10, 10)
UIStroke2.Parent = Frame1

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = Frame1

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.ZIndex = 3
TextLabel1.AnchorPoint = Vector2.new(0, 0.5)
TextLabel1.Size = UDim2.new(0, 90, 0, 20)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0, 4, 0.5, 0)
TextLabel1.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "LocalScript"
TextLabel1.TextWrapped = true
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
TextLabel1.Parent = Frame1

local LocalScriptLines = Instance.new("TextLabel")
LocalScriptLines.Name = "LocalScriptLines"
LocalScriptLines.ZIndex = 3
LocalScriptLines.AnchorPoint = Vector2.new(1, 0.5)
LocalScriptLines.Size = UDim2.new(0, 40, 0, 20)
LocalScriptLines.BackgroundTransparency = 1
LocalScriptLines.Position = UDim2.new(1, 0, 0.5, 0)
LocalScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptLines.TextSize = 14
LocalScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptLines.Text = "0"
LocalScriptLines.TextWrapped = true
LocalScriptLines.Font = Enum.Font.Gotham
LocalScriptLines.Parent = Frame1

local LocalScriptCharacters = Instance.new("TextLabel")
LocalScriptCharacters.Name = "LocalScriptCharacters"
LocalScriptCharacters.ZIndex = 3
LocalScriptCharacters.AnchorPoint = Vector2.new(1, 0.5)
LocalScriptCharacters.Size = UDim2.new(0, 70, 0, 20)
LocalScriptCharacters.BackgroundTransparency = 1
LocalScriptCharacters.Position = UDim2.new(0.6, 60, 0.5, 0)
LocalScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptCharacters.TextSize = 14
LocalScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptCharacters.Text = "0"
LocalScriptCharacters.TextWrapped = true
LocalScriptCharacters.Font = Enum.Font.Gotham
LocalScriptCharacters.Parent = Frame1

local LocalScriptObjects = Instance.new("TextLabel")
LocalScriptObjects.Name = "LocalScriptObjects"
LocalScriptObjects.ZIndex = 3
LocalScriptObjects.AnchorPoint = Vector2.new(1, 0.5)
LocalScriptObjects.Size = UDim2.new(0, 70, 0, 20)
LocalScriptObjects.BackgroundTransparency = 1
LocalScriptObjects.Position = UDim2.new(0.2, 100, 0.5, 0)
LocalScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptObjects.TextSize = 14
LocalScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptObjects.Text = "0"
LocalScriptObjects.TextWrapped = true
LocalScriptObjects.Font = Enum.Font.Gotham
LocalScriptObjects.Parent = Frame1

local Frame2 = Instance.new("Frame")
Frame2.ZIndex = 3
Frame2.AnchorPoint = Vector2.new(0.5, 0)
Frame2.Size = UDim2.new(1, -8, 0, 20)
Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame2.Position = UDim2.new(0.5, 0, 0, 52)
Frame2.BorderSizePixel = 0
Frame2.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame2.Parent = Stats_

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Color = Color3.fromRGB(10, 10, 10)
UIStroke3.Parent = Frame2

local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.ZIndex = 3
TextLabel2.AnchorPoint = Vector2.new(0, 0.5)
TextLabel2.Size = UDim2.new(0, 90, 0, 20)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(0, 4, 0.5, 0)
TextLabel2.BorderSizePixel = 0
TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel2.TextSize = 14
TextLabel2.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel2.Text = "ModuleScript"
TextLabel2.TextWrapped = true
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame2

local ModuleScriptLines = Instance.new("TextLabel")
ModuleScriptLines.Name = "ModuleScriptLines"
ModuleScriptLines.ZIndex = 3
ModuleScriptLines.AnchorPoint = Vector2.new(1, 0.5)
ModuleScriptLines.Size = UDim2.new(0, 40, 0, 20)
ModuleScriptLines.BackgroundTransparency = 1
ModuleScriptLines.Position = UDim2.new(1, 0, 0.5, 0)
ModuleScriptLines.BorderSizePixel = 0
ModuleScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptLines.TextSize = 14
ModuleScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptLines.Text = "0"
ModuleScriptLines.TextWrapped = true
ModuleScriptLines.Font = Enum.Font.Gotham
ModuleScriptLines.Parent = Frame2

local ModuleScriptCharacters = Instance.new("TextLabel")
ModuleScriptCharacters.Name = "ModuleScriptCharacters"
ModuleScriptCharacters.ZIndex = 3
ModuleScriptCharacters.AnchorPoint = Vector2.new(1, 0.5)
ModuleScriptCharacters.Size = UDim2.new(0, 70, 0, 20)
ModuleScriptCharacters.BackgroundTransparency = 1
ModuleScriptCharacters.Position = UDim2.new(0.6, 60, 0.5, 0)
ModuleScriptCharacters.BorderSizePixel = 0
ModuleScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptCharacters.TextSize = 14
ModuleScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptCharacters.Text = "0"
ModuleScriptCharacters.TextWrapped = true
ModuleScriptCharacters.Font = Enum.Font.Gotham
ModuleScriptCharacters.Parent = Frame2

local ModuleScriptObjects = Instance.new("TextLabel")
ModuleScriptObjects.Name = "ModuleScriptObjects"
ModuleScriptObjects.ZIndex = 3
ModuleScriptObjects.AnchorPoint = Vector2.new(1, 0.5)
ModuleScriptObjects.Size = UDim2.new(0, 70, 0, 20)
ModuleScriptObjects.BackgroundTransparency = 1
ModuleScriptObjects.Position = UDim2.new(0.2, 100, 0.5, 0)
ModuleScriptObjects.BorderSizePixel = 0
ModuleScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptObjects.TextSize = 14
ModuleScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptObjects.Text = "0"
ModuleScriptObjects.TextWrapped = true
ModuleScriptObjects.Font = Enum.Font.Gotham
ModuleScriptObjects.Parent = Frame2

local Frame3 = Instance.new("Frame")
Frame3.ZIndex = 3
Frame3.AnchorPoint = Vector2.new(0.5, 0)
Frame3.Size = UDim2.new(1, -8, 0, 20)
Frame3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame3.Position = UDim2.new(0.5, 0, 0, 76)
Frame3.BorderSizePixel = 0
Frame3.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame3.Parent = Stats_

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.ZIndex = 3
TextLabel3.AnchorPoint = Vector2.new(0, 0.5)
TextLabel3.Size = UDim2.new(0, 130, 0, 20)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Position = UDim2.new(0, 4, 0.5, 0)
TextLabel3.BorderSizePixel = 0
TextLabel3.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel3.TextSize = 14
TextLabel3.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel3.Text = "All"
TextLabel3.TextWrapped = true
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = Frame3

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Color = Color3.fromRGB(10, 10, 10)
UIStroke4.Parent = Frame3

local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = Frame3

local AllLines = Instance.new("TextLabel")
AllLines.Name = "AllLines"
AllLines.ZIndex = 3
AllLines.AnchorPoint = Vector2.new(1, 0.5)
AllLines.Size = UDim2.new(0, 40, 0, 20)
AllLines.BackgroundTransparency = 1
AllLines.Position = UDim2.new(1, 0, 0.5, 0)
AllLines.TextTruncate = Enum.TextTruncate.AtEnd
AllLines.TextSize = 14
AllLines.TextColor3 = Color3.fromRGB(188, 188, 188)
AllLines.Text = "0"
AllLines.TextWrapped = true
AllLines.Font = Enum.Font.Gotham
AllLines.Parent = Frame3

local AllCharacters = Instance.new("TextLabel")
AllCharacters.Name = "AllCharacters"
AllCharacters.ZIndex = 3
AllCharacters.AnchorPoint = Vector2.new(1, 0.5)
AllCharacters.Size = UDim2.new(0, 70, 0, 20)
AllCharacters.BackgroundTransparency = 1
AllCharacters.Position = UDim2.new(0.6, 60, 0.5, 0)
AllCharacters.TextTruncate = Enum.TextTruncate.AtEnd
AllCharacters.TextSize = 14
AllCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
AllCharacters.Text = "0"
AllCharacters.TextWrapped = true
AllCharacters.Font = Enum.Font.Gotham
AllCharacters.Parent = Frame3

local AllObjects = Instance.new("TextLabel")
AllObjects.Name = "AllObjects"
AllObjects.ZIndex = 3
AllObjects.AnchorPoint = Vector2.new(1, 0.5)
AllObjects.Size = UDim2.new(0, 70, 0, 20)
AllObjects.BackgroundTransparency = 1
AllObjects.Position = UDim2.new(0.2, 100, 0.5, 0)
AllObjects.TextTruncate = Enum.TextTruncate.AtEnd
AllObjects.TextSize = 14
AllObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
AllObjects.Text = "0"
AllObjects.TextWrapped = true
AllObjects.Font = Enum.Font.Gotham
AllObjects.Parent = Frame3

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.ZIndex = 3
TextLabel4.AnchorPoint = Vector2.new(1, 1)
TextLabel4.Size = UDim2.new(0, 70, 0, 20)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Position = UDim2.new(0.6, 60, 0, 0)
TextLabel4.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel4.TextSize = 14
TextLabel4.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel4.Text = "Characters"
TextLabel4.TextWrapped = true
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.Parent = Stats_

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.ZIndex = 3
TextLabel5.AnchorPoint = Vector2.new(1, 1)
TextLabel5.Size = UDim2.new(0, 40, 0, 20)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Position = UDim2.new(1, -4, 0, 0)
TextLabel5.BorderSizePixel = 0
TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel5.TextSize = 14
TextLabel5.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel5.Text = "Lines"
TextLabel5.TextWrapped = true
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.Parent = Stats_

local TextLabel6 = Instance.new("TextLabel")
TextLabel6.ZIndex = 3
TextLabel6.AnchorPoint = Vector2.new(1, 1)
TextLabel6.Size = UDim2.new(0, 70, 0, 20)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Position = UDim2.new(0.2, 102, 0, 0)
TextLabel6.BorderSizePixel = 0
TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel6.TextSize = 14
TextLabel6.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel6.Text = "Objects"
TextLabel6.TextWrapped = true
TextLabel6.Font = Enum.Font.Gotham
TextLabel6.Parent = Stats_

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.ZIndex = 3
TextLabel7.AnchorPoint = Vector2.new(0, 1)
TextLabel7.Size = UDim2.new(0, 42, 0, 20)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Position = UDim2.new(0, 0, 0, 0)
TextLabel7.BorderSizePixel = 0
TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel7.TextSize = 14
TextLabel7.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel7.Text = "Type"
TextLabel7.TextWrapped = true
TextLabel7.Font = Enum.Font.Gotham
TextLabel7.Parent = Stats_

for _, object in widget:GetDescendants() do
	if object:IsA("UIStroke") then
		object.Color = Color3.fromRGB(10, 10, 10)
	end

	if object:IsA("GuiObject") then
		object.BorderSizePixel = 0
	end
end

local intValue = Instance.new("IntValue")
intValue.Value = 0
intValue.Parent = script

local bindable = Instance.new("BindableEvent")
bindable.Parent = script

local whitespace_included, toggle_visibility = true, false

local TInfo_TextChange = TweenInfo.new(
	1,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local servicesToLookFor = {
	[1] = "ReplicatedFirst",
	[2] = "ReplicatedStorage",
	[3] = "Workspace",
	[4] = "ServerStorage",
	[5] = "ServerScriptService",
	[6] = "StarterPlayer",
	[7] = "StarterPlayerScripts",
	[8] = "StarterGui",
}

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
		["VaryingText"] = Color3.fromRGB(24, 25, 25),
		["ScrollBar"] = Color3.fromRGB(240, 240, 240),
		["Stroke"] = Color3.fromRGB(200, 200, 200)
	},
}

local function table_find<k, v>(tab: {[k]: v}, val): k?
	for k, v in tab do
		if val == v then
			return k
		end
	end
	
	return nil
end

local function isTextTruncate(text: TextLabel | TextBox | TextButton)
	return not text.TextFits
end

local function changeStudioTheme()
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
	
	local theme = settings().Studio.Theme :: Instance
	
	if theme.Name :: any ~= currentTheme then
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

	currentTheme = theme.Name :: any
end

local inScriptGUIDs = {}

local function attachGUID(scr: Script, newFrame: Frame)
	if newFrame:GetAttribute("ID") == nil then
		local id = HTTPService:GenerateGUID()
		inScriptGUIDs[id] = scr
		intValue.Value += 1
		newFrame:SetAttribute("ID", id)
	end
end

local function isScriptEligible(scr: LuaSourceContainer): boolean
	if scr then
		if scr:IsA("LuaSourceContainer") then
			for i, service in servicesToLookFor do
				if scr:FindFirstAncestorOfClass(service) then
					return true
				end
			end
		end
	end
	
	return false
end

local function calculateCanvasPosition(frame: Frame): Vector2
	local examplesBefore = frame.LayoutOrder - 3
	local numberOfPaddings = frame.LayoutOrder - 1
	local formula = Vector2.new(0, (examplesBefore * Example.Size.Y.Offset) + Frame.Size.Y.Offset + Example.Size.Y.Offset + (numberOfPaddings * (UIListLayout.Padding.Offset)) - frame.Size.Y.Offset / 2)
	
	return formula
end

local function tryOpeningDoc(scr: LuaSourceContainer)
	local s, e = pcall(function()
		ScriptEditorService:OpenScriptDocumentAsync(scr)
	end)

	if not s then
		warn("Script could not be opened:", e)
	end
end

local function setSelectionState(scr: Script, frame: Frame)
	local objects = Selection:Get()
	local pos = table.find(objects, scr)
	
	if pos then
		table.remove(objects, pos)
		frame.BackgroundColor3 = themeColors[currentTheme]["FrameBackground"]
		
		if toggle_visibility then
			local s, e = pcall(function()
				local doc = ScriptEditorService:FindScriptDocument(scr)
				doc:CloseAsync()
			end)
			
			if not s then
				warn("Script could not be closed:", e)
			end
		end
	else
		if toggle_visibility then
			TweenService:Create(ScrollingFrame, TInfo_TextChange, {CanvasPosition = calculateCanvasPosition(frame)}):Play()
			tryOpeningDoc(scr)
		end
		
		table.insert(objects, scr)
		frame.BackgroundColor3 = SELECTION_BACKGROUND
	end
	
	Selection:Set(objects)
end

local function adjustScriptStats()
	ModuleScriptLines.Text = "0"
	ModuleScriptCharacters.Text = "0"
	ScriptLines.Text = "0"
	ScriptCharacters.Text = "0"
	LocalScriptLines.Text = "0"
	LocalScriptCharacters.Text = "0"
	
	for i, frame in ScrollingFrame:GetDescendants() do
		local id = frame:GetAttribute("ID")
		if id and inScriptGUIDs[id] then
			local scr = inScriptGUIDs[id] :: any

			if scr:IsA("ModuleScript") then
				ModuleScriptLines.Text = tostring(tonumber(ModuleScriptLines.Text) :: number + tonumber(frame.Lines.Text) :: number)
				ModuleScriptCharacters.Text = tostring(tonumber(ModuleScriptCharacters.Text) :: number + tonumber(frame.Characters.Text) :: number)
			elseif scr:IsA("LocalScript") then
				LocalScriptLines.Text = tostring(tonumber(LocalScriptLines.Text) :: number + tonumber(frame.Lines.Text) :: number)
				LocalScriptCharacters.Text = tostring(tonumber(LocalScriptCharacters.Text) :: number + tonumber(frame.Characters.Text) :: number)
			elseif scr:IsA("Script") then
				ScriptLines.Text = tostring(tonumber(ScriptLines.Text) :: number + tonumber(frame.Lines.Text) :: number)
				ScriptCharacters.Text = tostring(tonumber(ScriptCharacters.Text) :: number + tonumber(frame.Characters.Text) :: number)
			end
			
			AllLines.Text = tostring(tonumber(LocalScriptLines.Text) :: number + tonumber(ScriptLines.Text) :: number + tonumber(ModuleScriptLines.Text) :: number)
			AllCharacters.Text = tostring(tonumber(LocalScriptCharacters.Text) :: number + tonumber(ScriptCharacters.Text) :: number + tonumber(ModuleScriptCharacters.Text) :: number)
		end
	end
end

local function changeLayoutOrder()
	local order = 3

	for i, v in ScrollingFrame:GetChildren() do
		if v:IsA("Frame") and v:GetAttribute("ID") and v.Visible then
			v.LayoutOrder = order
			order += 1
		end
	end
end

local function insert(scr: Script)
	if isScriptEligible(scr) and not table_find(inScriptGUIDs, scr) then
		local onFullName = false
		
		local newFrame = Example:Clone()
		newFrame.Visible = false
		newFrame.LayoutOrder = #ScrollingFrame:GetDescendants() - 2
		newFrame.Parent = ScrollingFrame
		
		attachGUID(scr, newFrame)
		
		local Lines, Characters, FullName = newFrame:WaitForChild("Lines") :: TextLabel, newFrame:WaitForChild("Characters") :: TextLabel, newFrame:WaitForChild("FullName") :: TextLabel
		
		Lines.Text = "0"
		Characters.Text = "0"

		Lines.TextColor3 = themeColors[currentTheme]["VaryingText"]
		Characters.TextColor3 = themeColors[currentTheme]["VaryingText"]
		FullName.TextColor3 = themeColors[currentTheme]["VaryingText"]
		
		local UIStroke = Instance.new("UIStroke")
		UIStroke.Thickness = 0.3
		UIStroke.Color = themeColors[currentTheme]["VaryingText"]
		UIStroke.Enabled = false
		UIStroke.Parent = FullName
		
		local UIStroke1 = Instance.new("UIStroke")
		UIStroke1.Thickness = 0.3
		UIStroke1.Color = themeColors[currentTheme]["VaryingText"]
		UIStroke1.Enabled = false
		UIStroke1.Parent = Characters
		
		local UIStroke2 = Instance.new("UIStroke")
		UIStroke2.Thickness = 0.3
		UIStroke2.Color = themeColors[currentTheme]["VaryingText"]
		UIStroke2.Enabled = false
		UIStroke2.Parent = Lines
		
		local function set()
			local source = scr.Source
			
			local tableOfLines = string.split(source, "\n")

			if whitespace_included then
				Lines.Text = tostring(#tableOfLines)
				Characters.Text = tostring(#source)
			else
				for i, line in tableOfLines do
					if line == "" or string.match(line, "^%s+$") then
						table.remove(tableOfLines, i)
					end
				end
				
				local without_whitespace = string.gsub(source, "%s+", "")
				
				Lines.Text = tostring(#tableOfLines)
				Characters.Text = tostring(#without_whitespace)
			end
			
			FullName.Text = scr:GetFullName()
			
			coroutine.wrap(function()
				adjustScriptStats()
			end)()
		end

		set()
		
		local last_Lines, last_Characters, last_FullName = Lines.Text, Characters.Text, FullName.Text

		scr:GetPropertyChangedSignal("Source"):Connect(set)

		scr:GetPropertyChangedSignal("Parent"):Connect(function()
			local id = newFrame:GetAttribute("ID")
		
			if not scr.Parent then
				inScriptGUIDs[id] = nil
				intValue.Value += 1
				newFrame.Visible = false
				changeLayoutOrder()
			else
				newFrame.Visible = true
				inScriptGUIDs[id] = scr
				intValue.Value += 1
				changeLayoutOrder()
				set()
			end
		end)
		
		scr:GetPropertyChangedSignal("Name"):Connect(function()
			FullName.Text = scr:GetFullName()
		end)
		
		Lines:GetPropertyChangedSignal("Text"):Connect(function()
			Lines.TextColor3 = if tonumber(last_Lines) :: number > tonumber(Lines.Text) :: number then  Color3.fromRGB(255, 0, 0) else Color3.fromRGB(0, 255, 0)
			TweenService:Create(Lines, TInfo_TextChange, {TextColor3 = themeColors[currentTheme]["VaryingText"]}):Play()
			last_Lines = Lines.Text
		end)
		
		Characters:GetPropertyChangedSignal("Text"):Connect(function()
			Characters.TextColor3 = if tonumber(last_Characters) :: number > tonumber(Characters.Text) :: number then Color3.fromRGB(255, 0, 0) else Color3.fromRGB(0, 255, 0)
			TweenService:Create(Characters, TInfo_TextChange, {TextColor3 = themeColors[currentTheme]["VaryingText"]}):Play()
			last_Characters = Characters.Text
		end)
		
		FullName:GetPropertyChangedSignal("Text"):Connect(function()
			FullName.TextColor3 = SELECTION_BACKGROUND
			TweenService:Create(FullName, TInfo_TextChange, {TextColor3 = themeColors[currentTheme]["VaryingText"]}):Play()
			last_FullName = FullName.Text
		end)
		
		newFrame.InputEnded:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.End then
				setSelectionState(scr, newFrame)
			end
		end)
		
		newFrame.InputChanged:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if isTextTruncate(FullName) then
					onFullName = false
					FullName.Text = scr.Name
				else
					if onFullName then
						FullName.Text = scr:GetFullName()
					end
				end
				
				UIStroke.Enabled = true
				UIStroke2.Enabled = true
				UIStroke1.Enabled = true
			end
		end)
		
		newFrame.MouseLeave:Connect(function()
			onFullName = true
			UIStroke.Enabled = false
			UIStroke1.Enabled = false
			UIStroke2.Enabled = false
			FullName.Text = scr:GetFullName()
		end)
		
		bindable.Event:Connect(set)
		newFrame.Visible = true
	end
end

local function isObjectSelected(object)
	local objects = Selection:Get()
	
	if table.find(objects, object) then
		return true
	end
	
	return false
end

local function findFrameByDoc(doc: ScriptDocument): Frame
	local scr = doc:GetScript()
	local id = table_find(inScriptGUIDs, scr)

	for _, frame in ScrollingFrame:GetDescendants() do
		local frameId = frame:GetAttribute("ID")

		if frame:IsA("Frame") and frameId and frameId == id then
			return frame
		end
	end

	return nil :: never
end

local function changeDocFrameBackground(doc: ScriptDocument, state: boolean)
	local scr = doc:GetScript()
	local frame = findFrameByDoc(doc)
	if frame then
		frame.BackgroundColor3 = if state then ACTIVE_SCRIPT_BACKGROUND else (if isObjectSelected(scr) then SELECTION_BACKGROUND else themeColors[currentTheme]["FrameBackground"])
	end
end

local function changeObjectCounters()
	local Scr_Script, Scr_ModuleScript, Scr_LocalScript = 0, 0, 0

	for _, scr: any in inScriptGUIDs do
		if scr:IsA("ModuleScript") then
			Scr_ModuleScript += 1
		elseif scr:IsA("LocalScript") then
			Scr_LocalScript += 1
		elseif scr:IsA("Script") then
			Scr_Script += 1
		end
	end

	AllObjects.Text = tostring(Scr_Script + Scr_ModuleScript + Scr_LocalScript)
	ScriptObjects.Text = tostring(Scr_Script)
	ModuleScriptObjects.Text = tostring(Scr_ModuleScript)
	LocalScriptObjects.Text = tostring(Scr_LocalScript)
end

Selection.SelectionChanged:Connect(function()
	local objects = Selection:Get()
	
	for i, frame in ScrollingFrame:GetDescendants() do
		if frame:IsA("Frame") then
			local id = frame:GetAttribute("ID")
			local scr = inScriptGUIDs[id]

			frame.BackgroundColor3 = if table.find(objects, scr) then (if ScriptEditorService:FindScriptDocument(scr) then ACTIVE_SCRIPT_BACKGROUND else SELECTION_BACKGROUND) else (if ScriptEditorService:FindScriptDocument(scr) then ACTIVE_SCRIPT_BACKGROUND else themeColors[currentTheme]["FrameBackground"])
		end
	end
end)

Whitespace.Activated:Connect(function()
	Whitespace.BackgroundColor3 = if Whitespace.BackgroundColor3 == SELECTION_BACKGROUND then themeColors[currentTheme]["Button"] else SELECTION_BACKGROUND
	whitespace_included = not whitespace_included
	bindable:Fire()	
end)

OpenCloseScript.Activated:Connect(function()
	OpenCloseScript.BackgroundColor3 = if OpenCloseScript.BackgroundColor3 == SELECTION_BACKGROUND then themeColors[currentTheme]["Button"] else SELECTION_BACKGROUND
	toggle_visibility = not toggle_visibility
end)

ScrollingFrame.DescendantAdded:Connect(changeLayoutOrder)
ScrollingFrame.DescendantRemoving:Connect(changeLayoutOrder)

game.DescendantAdded:Connect(insert)

settings().Studio.ThemeChanged:Connect(function()
	changeStudioTheme()
end)

intValue.Changed:Connect(changeObjectCounters)

ScriptEditorService.TextDocumentDidOpen:Connect(function(doc: ScriptDocument)
	changeDocFrameBackground(doc, true)

	local frame = findFrameByDoc(doc)
	if frame then
		TweenService:Create(ScrollingFrame, TInfo_TextChange, {CanvasPosition = calculateCanvasPosition(frame)}):Play()
	end
end)

ScriptEditorService.TextDocumentDidClose:Connect(function(doc: ScriptDocument)
	changeDocFrameBackground(doc, false)
end)

for _, v in game:GetDescendants() do
	insert(v)
end

for i, document: ScriptDocument in ScriptEditorService:GetScriptDocuments() do
	changeDocFrameBackground(document, true)
end

Whitespace.BackgroundColor3 = SELECTION_BACKGROUND
OpenCloseScript.BackgroundColor3 = themeColors[currentTheme]["Button"]

changeStudioTheme()
changeObjectCounters()
