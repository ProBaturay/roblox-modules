--21:37 UTC+3 24/07/2023
--Last update: 17:13 UTC+3 11/11/2023
--!nonstrict
--!native

type nLuaSourceContainer = LuaSourceContainer & {Source: any}

--local SELECTION_BACKGROUND = Color3.fromRGB(15, 178, 227)
--local ACTIVE_SCRIPT_BACKGROUND = Color3.fromRGB(142, 114, 255)
--local INCREASE = Color3.fromRGB(0, 255, 0)
--local DECREASE = Color3.fromRGB(255, 0, 0)
--local CHANGE_TEXT = Color3.fromRGB(15, 178, 227)

local constants = {
	[1] = Color3.fromRGB(15, 178, 227), -- selection
	[2] = Color3.fromRGB(15, 178, 227), -- delta
	[3] = Color3.fromRGB(255, 0, 0),    -- decrease
	[4] = Color3.fromRGB(0, 255, 0),    -- increase
	[5] = Color3.fromRGB(142, 114, 255) -- active
}

local textColorTweens = {}
local currentTheme = "Dark"
local AUTO_PLUGIN = "Auto"

local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local HTTPService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local StudioService = game:GetService("StudioService")

if RunService:IsRunning() then
	return
end

local plugin = plugin or getfenv().PluginManager():CreatePlugin()
plugin.Name = "ScriptProperties"

local dockWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	340,
	340,
	340,
	340
)

local toolbar = plugin:CreateToolbar("Script Properties")

local button = toolbar:CreateButton("Open Menu", "Check total lines and characters of your scripts!", "http://www.roblox.com/asset/?id=14329255055") -- TODO change icon
button.ClickableWhenViewportHidden = true

local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui(
	"385026300",
	dockWidgetInfo
)

widget.ResetOnSpawn = false
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widget.Title = "Script Properties"
widget.Name = "ScriptProperties"

button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

local Whole = Instance.new("Frame")
Whole.Parent = widget
Whole.Name = "Whole"
Whole.ZIndex = 2
Whole.AnchorPoint = Vector2.new(0.5, 0.5)
Whole.Size = UDim2.new(1, 0, 1, 0)
Whole.Position = UDim2.new(0.5, 0, 0.5, 0)
Whole.BackgroundColor3 = Color3.fromRGB(46, 46, 46)

local BackgroundSafe = Instance.new("Frame")
BackgroundSafe.Name = "BackgroundSafe"
BackgroundSafe.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundSafe.Size = UDim2.new(1, -40, 1, -40)
BackgroundSafe.BackgroundTransparency = 1
BackgroundSafe.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundSafe.Parent = Whole

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Size = UDim2.new(1, 0, 0, 15)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, 0, 0, 0)
Title.TextSize = 12
Title.TextColor3 = Color3.fromRGB(188, 188, 188)
Title.Text = "Script Character & Line Counter"
Title.TextWrapped = true
Title.TextWrap = true
Title.Font = Enum.Font.Gotham
Title.Parent = BackgroundSafe

local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubLabel"
SubLabel.AnchorPoint = Vector2.new(0.5, 1)
SubLabel.Size = UDim2.new(1, 0, 0, 15)
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0.5, 0, 1, 0)
SubLabel.TextSize = 12
SubLabel.RichText = true
SubLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
SubLabel.Text = "Made by <b>@ProBaturay</b> with love!"
SubLabel.TextWrapped = true
SubLabel.TextWrap = true
SubLabel.Font = Enum.Font.Gotham
SubLabel.Parent = BackgroundSafe

local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
MainMenu.Size = UDim2.new(1, 0, 1, -60)
MainMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainMenu.BackgroundTransparency = 1
MainMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
MainMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainMenu.Parent = BackgroundSafe

local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsButton.Size = UDim2.new(1, 0, 0, 30)
SettingsButton.Position = UDim2.new(0.5, 0, 1, -25)
SettingsButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsButton.AutoButtonColor = false
SettingsButton.TextSize = 14
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Text = "Go to Settings"
SettingsButton.Font = Enum.Font.Gotham
SettingsButton.Parent = MainMenu

local ScriptScrollingFrame = Instance.new("ScrollingFrame")
ScriptScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
ScriptScrollingFrame.Size = UDim2.new(1, 0, 1, -200)
ScriptScrollingFrame.BackgroundTransparency = 1
ScriptScrollingFrame.Position = UDim2.new(0.5, 0, 0, 0)
ScriptScrollingFrame.Active = true
ScriptScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptScrollingFrame.CanvasSize = UDim2.fromScale(0, 0)
ScriptScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
ScriptScrollingFrame.ScrollBarThickness = 3
ScriptScrollingFrame.Parent = MainMenu

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Thickness = 2
UIStroke1.Color = Color3.fromRGB(10, 10, 10)
UIStroke1.Parent = ScriptScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScriptScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 6)
UIPadding.PaddingRight = UDim.new(0, 6)
UIPadding.Parent = ScriptScrollingFrame

local Directory = Instance.new("Frame")
Directory.Name = "Directory"
Directory.Size = UDim2.new(1, -16, 0, 25)
Directory.BorderColor3 = Color3.fromRGB(0, 0, 0)
Directory.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Directory.Parent = ScriptScrollingFrame

local FullName = Instance.new("TextLabel")
FullName.Name = "FullName"
FullName.Size = UDim2.new(0.9, -100, 1, 0)
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
FullName.Parent = Directory

local Characters = Instance.new("TextLabel")
Characters.Name = "Characters"
Characters.AnchorPoint = Vector2.new(0.5, 0)
Characters.Size = UDim2.new(0.2, 72, 1, 0)
Characters.BorderColor3 = Color3.fromRGB(0, 0, 0)
Characters.BackgroundTransparency = 1
Characters.Position = UDim2.new(0.9, -58, 0, 0)
Characters.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Characters.TextTruncate = Enum.TextTruncate.AtEnd
Characters.TextSize = 14
Characters.TextColor3 = Color3.fromRGB(163, 162, 165)
Characters.Text = "Characters"
Characters.Font = Enum.Font.Gotham
Characters.Parent = Directory

local Lines = Instance.new("TextLabel")
Lines.Name = "Lines"
Lines.AnchorPoint = Vector2.new(0.5, 0)
Lines.Size = UDim2.new(0.2, 40, 1, 0)
Lines.BorderColor3 = Color3.fromRGB(0, 0, 0)
Lines.BackgroundTransparency = 1
Lines.Position = UDim2.new(1, -30, 0, 0)
Lines.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Lines.TextTruncate = Enum.TextTruncate.AtEnd
Lines.TextSize = 14
Lines.TextColor3 = Color3.fromRGB(163, 162, 165)
Lines.Text = "Lines"
Lines.Font = Enum.Font.Gotham
Lines.Parent = Directory

local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(1, -16, 0, 2)
Separator.LayoutOrder = 1
Separator.BorderColor3 = Color3.fromRGB(0, 0, 0)
Separator.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Separator.Parent = ScriptScrollingFrame

local Stats_ = Instance.new("Frame")
Stats_.Name = "Stats"
Stats_.AnchorPoint = Vector2.new(0.5, 1)
Stats_.Size = UDim2.new(1, 0, 0, 100)
Stats_.BackgroundTransparency = 1
Stats_.Position = UDim2.new(0.5, 0, 1, -60)
Stats_.BorderSizePixel = 0
Stats_.Parent = MainMenu

local Frame = Instance.new("Frame")
Frame.ZIndex = 3
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Size = UDim2.new(1, -12, 0, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.5, 0, 0, 4)
Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame.Parent = Stats_

local ScriptNameScript = Instance.new("TextLabel")
ScriptNameScript.Name = "ScriptNameScript"
ScriptNameScript.ZIndex = 3
ScriptNameScript.AnchorPoint = Vector2.new(0, 0.5)
ScriptNameScript.Size = UDim2.new(0, 90, 0, 20)
ScriptNameScript.BackgroundTransparency = 1
ScriptNameScript.Position = UDim2.new(0, 4, 0.5, 0)
ScriptNameScript.TextTruncate = Enum.TextTruncate.AtEnd
ScriptNameScript.TextSize = 14
ScriptNameScript.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptNameScript.Text = "Script"
ScriptNameScript.TextWrapped = true
ScriptNameScript.TextWrap = true
ScriptNameScript.Font = Enum.Font.Gotham
ScriptNameScript.TextXAlignment = Enum.TextXAlignment.Left
ScriptNameScript.Parent = Frame

local ScriptLines = Instance.new("TextLabel")
ScriptLines.Name = "ScriptLines"
ScriptLines.ZIndex = 3
ScriptLines.AnchorPoint = Vector2.new(0.5, 0.5)
ScriptLines.Size = UDim2.new(0.2, 40, 0, 20)
ScriptLines.BackgroundTransparency = 1
ScriptLines.Position = UDim2.new(1, -44, 0.5, 0)
ScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
ScriptLines.TextSize = 14
ScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptLines.Text = "Lines"
ScriptLines.TextWrapped = true
ScriptLines.TextWrap = true
ScriptLines.Font = Enum.Font.Gotham
ScriptLines.Parent = Frame

local ScriptCharacters = Instance.new("TextLabel")
ScriptCharacters.Name = "ScriptCharacters"
ScriptCharacters.ZIndex = 3
ScriptCharacters.AnchorPoint = Vector2.new(0.5, 0.5)
ScriptCharacters.Size = UDim2.new(0, 72, 0, 20)
ScriptCharacters.BackgroundTransparency = 1
ScriptCharacters.Position = UDim2.new(0.9, -73, 0.5, 0)
ScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
ScriptCharacters.TextSize = 14
ScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptCharacters.Text = "Characters"
ScriptCharacters.TextWrapped = true
ScriptCharacters.TextWrap = true
ScriptCharacters.Font = Enum.Font.Gotham
ScriptCharacters.Parent = Frame

local ScriptObjects = Instance.new("TextLabel")
ScriptObjects.Name = "ScriptObjects"
ScriptObjects.ZIndex = 3
ScriptObjects.AnchorPoint = Vector2.new(0.5, 0.5)
ScriptObjects.Size = UDim2.new(0, 70, 0, 20)
ScriptObjects.BackgroundTransparency = 1
ScriptObjects.Position = UDim2.new(0.8, -113, 0.5, 0)
ScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
ScriptObjects.TextSize = 14
ScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptObjects.Text = "Objects"
ScriptObjects.TextWrapped = true
ScriptObjects.TextWrap = true
ScriptObjects.Font = Enum.Font.Gotham
ScriptObjects.Parent = Frame

local Frame1 = Instance.new("Frame")
Frame1.ZIndex = 3
Frame1.AnchorPoint = Vector2.new(0.5, 0)
Frame1.Size = UDim2.new(1, -12, 0, 20)
Frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame1.Position = UDim2.new(0.5, 0, 0, 28)
Frame1.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame1.Parent = Stats_

local ScriptNameLocal = Instance.new("TextLabel")
ScriptNameLocal.Name = "ScriptNameLocal"
ScriptNameLocal.ZIndex = 3
ScriptNameLocal.AnchorPoint = Vector2.new(0, 0.5)
ScriptNameLocal.Size = UDim2.new(0, 90, 0, 20)
ScriptNameLocal.BackgroundTransparency = 1
ScriptNameLocal.Position = UDim2.new(0, 4, 0.5, 0)
ScriptNameLocal.TextTruncate = Enum.TextTruncate.AtEnd
ScriptNameLocal.TextSize = 14
ScriptNameLocal.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptNameLocal.Text = "LocalScript"
ScriptNameLocal.TextWrapped = true
ScriptNameLocal.TextWrap = true
ScriptNameLocal.Font = Enum.Font.Gotham
ScriptNameLocal.TextXAlignment = Enum.TextXAlignment.Left
ScriptNameLocal.Parent = Frame1

local LocalScriptLines = Instance.new("TextLabel")
LocalScriptLines.Name = "LocalScriptLines"
LocalScriptLines.ZIndex = 3
LocalScriptLines.AnchorPoint = Vector2.new(0.5, 0.5)
LocalScriptLines.Size = UDim2.new(0.2, 40, 0, 20)
LocalScriptLines.BackgroundTransparency = 1
LocalScriptLines.Position = UDim2.new(1, -44, 0.5, 0)
LocalScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptLines.TextSize = 14
LocalScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptLines.Text = "Lines"
LocalScriptLines.TextWrapped = true
LocalScriptLines.TextWrap = true
LocalScriptLines.Font = Enum.Font.Gotham
LocalScriptLines.Parent = Frame1

local LocalScriptCharacters = Instance.new("TextLabel")
LocalScriptCharacters.Name = "LocalScriptCharacters"
LocalScriptCharacters.ZIndex = 3
LocalScriptCharacters.AnchorPoint = Vector2.new(0.5, 0.5)
LocalScriptCharacters.Size = UDim2.new(0, 72, 0, 20)
LocalScriptCharacters.BackgroundTransparency = 1
LocalScriptCharacters.Position = UDim2.new(0.9, -73, 0.5, 0)
LocalScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptCharacters.TextSize = 14
LocalScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptCharacters.Text = "Characters"
LocalScriptCharacters.TextWrapped = true
LocalScriptCharacters.TextWrap = true
LocalScriptCharacters.Font = Enum.Font.Gotham
LocalScriptCharacters.Parent = Frame1

local LocalScriptObjects = Instance.new("TextLabel")
LocalScriptObjects.Name = "LocalScriptObjects"
LocalScriptObjects.ZIndex = 3
LocalScriptObjects.AnchorPoint = Vector2.new(0.5, 0.5)
LocalScriptObjects.Size = UDim2.new(0, 70, 0, 20)
LocalScriptObjects.BackgroundTransparency = 1
LocalScriptObjects.Position = UDim2.new(0.8, -113, 0.5, 0)
LocalScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
LocalScriptObjects.TextSize = 14
LocalScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
LocalScriptObjects.Text = "Objects"
LocalScriptObjects.TextWrapped = true
LocalScriptObjects.TextWrap = true
LocalScriptObjects.Font = Enum.Font.Gotham
LocalScriptObjects.Parent = Frame1

local Frame2 = Instance.new("Frame")
Frame2.ZIndex = 3
Frame2.AnchorPoint = Vector2.new(0.5, 0)
Frame2.Size = UDim2.new(1, -12, 0, 20)
Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame2.Position = UDim2.new(0.5, 0, 0, 52)
Frame2.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame2.Parent = Stats_

local ScriptNameModule = Instance.new("TextLabel")
ScriptNameModule.Name = "ScriptNameModule"
ScriptNameModule.ZIndex = 3
ScriptNameModule.AnchorPoint = Vector2.new(0, 0.5)
ScriptNameModule.Size = UDim2.new(0, 90, 0, 20)
ScriptNameModule.BackgroundTransparency = 1
ScriptNameModule.Position = UDim2.new(0, 4, 0.5, 0)
ScriptNameModule.TextTruncate = Enum.TextTruncate.AtEnd
ScriptNameModule.TextSize = 14
ScriptNameModule.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptNameModule.Text = "ModuleScript"
ScriptNameModule.TextWrapped = true
ScriptNameModule.TextWrap = true
ScriptNameModule.Font = Enum.Font.Gotham
ScriptNameModule.TextXAlignment = Enum.TextXAlignment.Left
ScriptNameModule.Parent = Frame2

local ModuleScriptLines = Instance.new("TextLabel")
ModuleScriptLines.Name = "ModuleScriptLines"
ModuleScriptLines.ZIndex = 3
ModuleScriptLines.AnchorPoint = Vector2.new(0.5, 0.5)
ModuleScriptLines.Size = UDim2.new(0.2, 40, 0, 20)
ModuleScriptLines.BackgroundTransparency = 1
ModuleScriptLines.Position = UDim2.new(1, -44, 0.5, 0)
ModuleScriptLines.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptLines.TextSize = 14
ModuleScriptLines.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptLines.Text = "Lines"
ModuleScriptLines.TextWrapped = true
ModuleScriptLines.TextWrap = true
ModuleScriptLines.Font = Enum.Font.Gotham
ModuleScriptLines.Parent = Frame2

local ModuleScriptCharacters = Instance.new("TextLabel")
ModuleScriptCharacters.Name = "ModuleScriptCharacters"
ModuleScriptCharacters.ZIndex = 3
ModuleScriptCharacters.AnchorPoint = Vector2.new(0.5, 0.5)
ModuleScriptCharacters.Size = UDim2.new(0, 72, 0, 20)
ModuleScriptCharacters.BackgroundTransparency = 1
ModuleScriptCharacters.Position = UDim2.new(0.9, -73, 0.5, 0)
ModuleScriptCharacters.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptCharacters.TextSize = 14
ModuleScriptCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptCharacters.Text = "Characters"
ModuleScriptCharacters.TextWrapped = true
ModuleScriptCharacters.TextWrap = true
ModuleScriptCharacters.Font = Enum.Font.Gotham
ModuleScriptCharacters.Parent = Frame2

local ModuleScriptObjects = Instance.new("TextLabel")
ModuleScriptObjects.Name = "ModuleScriptObjects"
ModuleScriptObjects.ZIndex = 3
ModuleScriptObjects.AnchorPoint = Vector2.new(0.5, 0.5)
ModuleScriptObjects.Size = UDim2.new(0, 70, 0, 20)
ModuleScriptObjects.BackgroundTransparency = 1
ModuleScriptObjects.Position = UDim2.new(0.8, -113, 0.5, 0)
ModuleScriptObjects.TextTruncate = Enum.TextTruncate.AtEnd
ModuleScriptObjects.TextSize = 14
ModuleScriptObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
ModuleScriptObjects.Text = "Objects"
ModuleScriptObjects.TextWrapped = true
ModuleScriptObjects.TextWrap = true
ModuleScriptObjects.Font = Enum.Font.Gotham
ModuleScriptObjects.Parent = Frame2

local Frame3 = Instance.new("Frame")
Frame3.ZIndex = 3
Frame3.AnchorPoint = Vector2.new(0.5, 0)
Frame3.Size = UDim2.new(1, -12, 0, 20)
Frame3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame3.Position = UDim2.new(0.5, 0, 0, 76)
Frame3.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Frame3.Parent = Stats_

local ScriptNameAll = Instance.new("TextLabel")
ScriptNameAll.Name = "ScriptNameAll"
ScriptNameAll.ZIndex = 3
ScriptNameAll.AnchorPoint = Vector2.new(0, 0.5)
ScriptNameAll.Size = UDim2.new(0, 134, 0, 20)
ScriptNameAll.BackgroundTransparency = 1
ScriptNameAll.Position = UDim2.new(0, 4, 0.5, 0)
ScriptNameAll.TextTruncate = Enum.TextTruncate.AtEnd
ScriptNameAll.TextSize = 14
ScriptNameAll.TextColor3 = Color3.fromRGB(188, 188, 188)
ScriptNameAll.Text = "All"
ScriptNameAll.TextWrapped = true
ScriptNameAll.TextWrap = true
ScriptNameAll.Font = Enum.Font.Gotham
ScriptNameAll.TextXAlignment = Enum.TextXAlignment.Left
ScriptNameAll.Parent = Frame3

local AllLines = Instance.new("TextLabel")
AllLines.Name = "AllLines"
AllLines.ZIndex = 3
AllLines.AnchorPoint = Vector2.new(0.5, 0.5)
AllLines.Size = UDim2.new(0.2, 40, 0, 20)
AllLines.BackgroundTransparency = 1
AllLines.Position = UDim2.new(1, -44, 0.5, 0)
AllLines.TextTruncate = Enum.TextTruncate.AtEnd
AllLines.TextSize = 14
AllLines.TextColor3 = Color3.fromRGB(188, 188, 188)
AllLines.Text = "Lines"
AllLines.TextWrapped = true
AllLines.TextWrap = true
AllLines.Font = Enum.Font.Gotham
AllLines.Parent = Frame3

local AllCharacters = Instance.new("TextLabel")
AllCharacters.Name = "AllCharacters"
AllCharacters.ZIndex = 3
AllCharacters.AnchorPoint = Vector2.new(0.5, 0.5)
AllCharacters.Size = UDim2.new(0, 72, 0, 20)
AllCharacters.BackgroundTransparency = 1
AllCharacters.Position = UDim2.new(0.9, -73, 0.5, 0)
AllCharacters.TextTruncate = Enum.TextTruncate.AtEnd
AllCharacters.TextSize = 14
AllCharacters.TextColor3 = Color3.fromRGB(188, 188, 188)
AllCharacters.Text = "Characters"
AllCharacters.TextWrapped = true
AllCharacters.TextWrap = true
AllCharacters.Font = Enum.Font.Gotham
AllCharacters.Parent = Frame3

local AllObjects = Instance.new("TextLabel")
AllObjects.Name = "AllObjects"
AllObjects.ZIndex = 3
AllObjects.AnchorPoint = Vector2.new(0.5, 0.5)
AllObjects.Size = UDim2.new(0, 70, 0, 20)
AllObjects.BackgroundTransparency = 1
AllObjects.Position = UDim2.new(0.8, -113, 0.5, 0)
AllObjects.TextTruncate = Enum.TextTruncate.AtEnd
AllObjects.TextSize = 14
AllObjects.TextColor3 = Color3.fromRGB(188, 188, 188)
AllObjects.Text = "Objects"
AllObjects.TextWrapped = true
AllObjects.TextWrap = true
AllObjects.Font = Enum.Font.Gotham
AllObjects.Parent = Frame3

local CharactersLabel = Instance.new("TextLabel")
CharactersLabel.Name = "CharactersLabel"
CharactersLabel.ZIndex = 3
CharactersLabel.AnchorPoint = Vector2.new(0.5, 1)
CharactersLabel.Size = UDim2.new(0, 72, 0, 20)
CharactersLabel.BackgroundTransparency = 1
CharactersLabel.Position = UDim2.new(0.9, -78, 0, -4)
CharactersLabel.TextTruncate = Enum.TextTruncate.AtEnd
CharactersLabel.TextSize = 14
CharactersLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
CharactersLabel.Text = "Characters"
CharactersLabel.TextWrapped = true
CharactersLabel.TextWrap = true
CharactersLabel.Font = Enum.Font.Gotham
CharactersLabel.Parent = Stats_

local LinesLabel = Instance.new("TextLabel")
LinesLabel.Name = "LinesLabel"
LinesLabel.ZIndex = 3
LinesLabel.AnchorPoint = Vector2.new(0.5, 1)
LinesLabel.Size = UDim2.new(0.2, 40, 0, 20)
LinesLabel.BackgroundTransparency = 1
LinesLabel.Position = UDim2.new(1, -50, 0, -4)
LinesLabel.TextTruncate = Enum.TextTruncate.AtEnd
LinesLabel.TextSize = 14
LinesLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
LinesLabel.Text = "Lines"
LinesLabel.TextWrapped = true
LinesLabel.TextWrap = true
LinesLabel.Font = Enum.Font.Gotham
LinesLabel.Parent = Stats_

local ObjectsLabel = Instance.new("TextLabel")
ObjectsLabel.Name = "ObjectsLabel"
ObjectsLabel.ZIndex = 3
ObjectsLabel.AnchorPoint = Vector2.new(0.5, 1)
ObjectsLabel.Size = UDim2.new(0, 70, 0, 20)
ObjectsLabel.BackgroundTransparency = 1
ObjectsLabel.Position = UDim2.new(0.8, -117, 0, -4)
ObjectsLabel.TextTruncate = Enum.TextTruncate.AtEnd
ObjectsLabel.TextSize = 14
ObjectsLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
ObjectsLabel.Text = "Objects"
ObjectsLabel.TextWrapped = true
ObjectsLabel.TextWrap = true
ObjectsLabel.Font = Enum.Font.Gotham
ObjectsLabel.Parent = Stats_

local TypeLabel = Instance.new("TextLabel")
TypeLabel.Name = "TypeLabel"
TypeLabel.ZIndex = 3
TypeLabel.AnchorPoint = Vector2.new(0, 1)
TypeLabel.Size = UDim2.new(0, 98, 0, 20)
TypeLabel.BackgroundTransparency = 1
TypeLabel.Position = UDim2.new(0, 8, 0, -4)
TypeLabel.TextTruncate = Enum.TextTruncate.AtEnd
TypeLabel.TextSize = 14
TypeLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TypeLabel.Text = "Type"
TypeLabel.TextWrapped = true
TypeLabel.TextWrap = true
TypeLabel.Font = Enum.Font.Gotham
TypeLabel.TextXAlignment = Enum.TextXAlignment.Left
TypeLabel.Parent = Stats_

local SettingsMenu = Instance.new("Frame")
SettingsMenu.Name = "Settings"
SettingsMenu.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsMenu.Size = UDim2.new(1, 0, 1, -60)
SettingsMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsMenu.Position = UDim2.new(2, 0, 0.5, 0)
SettingsMenu.BackgroundTransparency = 1
SettingsMenu.Parent = BackgroundSafe

local SettingsScrollingFrame = Instance.new("ScrollingFrame")
SettingsScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
SettingsScrollingFrame.Size = UDim2.new(1, 0, 1, -60)
SettingsScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsScrollingFrame.BackgroundTransparency = 1
SettingsScrollingFrame.Position = UDim2.new(0.5, 0, 0, 0)
SettingsScrollingFrame.Active = true
SettingsScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsScrollingFrame.CanvasSize = UDim2.fromScale(0, 0)
SettingsScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
SettingsScrollingFrame.Parent = SettingsMenu

local PluginSettings = Instance.new("TextLabel")
PluginSettings.Name = "PluginSettings"
PluginSettings.LayoutOrder = 7
PluginSettings.ZIndex = 3
PluginSettings.AnchorPoint = Vector2.new(0, 0.5)
PluginSettings.Size = UDim2.new(1, 0, 0, 40)
PluginSettings.BackgroundTransparency = 1
PluginSettings.Position = UDim2.new(0, 0, 0, 10)
PluginSettings.TextTruncate = Enum.TextTruncate.AtEnd
PluginSettings.TextSize = 14
PluginSettings.TextColor3 = Color3.fromRGB(188, 188, 188)
PluginSettings.TextYAlignment = Enum.TextYAlignment.Bottom
PluginSettings.Text = "Plugin"
PluginSettings.TextWrapped = true
PluginSettings.TextWrap = true
PluginSettings.Font = Enum.Font.Gotham
PluginSettings.TextXAlignment = Enum.TextXAlignment.Left
PluginSettings.Parent = SettingsScrollingFrame

local Separator2 = Instance.new("Frame")
Separator2.Name = "Separator2"
Separator2.LayoutOrder = 8
Separator2.Size = UDim2.new(1, 0, 0, 2)
Separator2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Separator2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Separator2.Parent = SettingsScrollingFrame

local Separator3 = Instance.new("Frame")
Separator3.Name = "Separator3"
Separator3.LayoutOrder = 10
Separator3.Size = UDim2.new(1, 0, 0, 2)
Separator3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Separator3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Separator3.Parent = SettingsScrollingFrame

local ListSettings = Instance.new("TextLabel")
ListSettings.Name = "ListSettings"
ListSettings.LayoutOrder = 9
ListSettings.ZIndex = 3
ListSettings.AnchorPoint = Vector2.new(0, 0.5)
ListSettings.Size = UDim2.new(1, 0, 0, 40)
ListSettings.BackgroundTransparency = 1
ListSettings.Position = UDim2.new(0, 0, 0, 10)
ListSettings.TextTruncate = Enum.TextTruncate.AtEnd
ListSettings.TextSize = 14
ListSettings.TextColor3 = Color3.fromRGB(188, 188, 188)
ListSettings.TextYAlignment = Enum.TextYAlignment.Bottom
ListSettings.Text = "Script list"
ListSettings.TextWrapped = true
ListSettings.TextWrap = true
ListSettings.Font = Enum.Font.Gotham
ListSettings.TextXAlignment = Enum.TextXAlignment.Left
ListSettings.Parent = SettingsScrollingFrame

local WhileScriptingSettings = Instance.new("TextLabel")
WhileScriptingSettings.Name = "WhileScriptingSettings"
WhileScriptingSettings.LayoutOrder = 1
WhileScriptingSettings.ZIndex = 3
WhileScriptingSettings.AnchorPoint = Vector2.new(0, 0.5)
WhileScriptingSettings.Size = UDim2.new(1, 0, 0, 20)
WhileScriptingSettings.BackgroundTransparency = 1
WhileScriptingSettings.Position = UDim2.new(0, 0, 0, 10)
WhileScriptingSettings.TextTruncate = Enum.TextTruncate.AtEnd
WhileScriptingSettings.TextSize = 14
WhileScriptingSettings.TextColor3 = Color3.fromRGB(188, 188, 188)
WhileScriptingSettings.Text = "While scripting"
WhileScriptingSettings.TextWrapped = true
WhileScriptingSettings.TextWrap = true
WhileScriptingSettings.Font = Enum.Font.Gotham
WhileScriptingSettings.TextXAlignment = Enum.TextXAlignment.Left
WhileScriptingSettings.Parent = SettingsScrollingFrame

local Separator1 = Instance.new("Frame")
Separator1.Name = "Separator1"
Separator1.LayoutOrder = 2
Separator1.Size = UDim2.new(1, 0, 0, 2)
Separator1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Separator1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Separator1.Parent = SettingsScrollingFrame

local Factor = Instance.new("Frame")
Factor.Name = "Factor"
Factor.LayoutOrder = 12
Factor.Size = UDim2.new(1, 0, 0, 30)
Factor.BorderColor3 = Color3.fromRGB(0, 0, 0)
Factor.BackgroundTransparency = 1
Factor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Factor.Parent = SettingsScrollingFrame

local Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, 0, 1, 0)
Frame4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame4.BackgroundTransparency = 1
Frame4.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame4.Parent = Factor

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 3
UIAspectRatioConstraint.Parent = Frame4

local FactorButton = Instance.new("TextButton")
FactorButton.Name = "FactorButton"
FactorButton.AnchorPoint = Vector2.new(0.5, 0.5)
FactorButton.Size = UDim2.new(1, 0, 1, 0)
FactorButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FactorButton.BackgroundTransparency = 0
FactorButton.Position = UDim2.new(0.5, 0, 0.5, 0)
FactorButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
FactorButton.TextSize = 14
FactorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FactorButton.Text = "Name"
FactorButton.Font = Enum.Font.Gotham
FactorButton.Parent = Frame4

local UICornerFactorButton = Instance.new("UICorner")
UICornerFactorButton.CornerRadius = UDim.new(0, 8)
UICornerFactorButton.Parent = FactorButton

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0, 0.5)
TextLabel.Size = UDim2.new(1, -100, 1, 0)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Position = UDim2.new(0, 96, 0.5, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel.Text = "Factor"
TextLabel.TextWrapped = true
TextLabel.TextWrap = true
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Factor

local UIListLayout1 = Instance.new("UIListLayout")
UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout1.Padding = UDim.new(0, 6)
UIListLayout1.Parent = SettingsScrollingFrame

local UIPadding1 = Instance.new("UIPadding")
UIPadding1.PaddingTop = UDim.new(0, 10)
UIPadding1.PaddingBottom = UDim.new(0, 10)
UIPadding1.PaddingLeft = UDim.new(0, 10)
UIPadding1.PaddingRight = UDim.new(0, 10)
UIPadding1.Parent = SettingsScrollingFrame

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Thickness = 2
UIStroke9.Color = Color3.fromRGB(10, 10, 10)
UIStroke9.Parent = SettingsScrollingFrame

local ToggleScriptVisibility = Instance.new("Frame")
ToggleScriptVisibility.Name = "ToggleScriptVisibility"
ToggleScriptVisibility.LayoutOrder = 4
ToggleScriptVisibility.Size = UDim2.new(1, 0, 0, 20)
ToggleScriptVisibility.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleScriptVisibility.BackgroundTransparency = 1
ToggleScriptVisibility.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleScriptVisibility.Parent = SettingsScrollingFrame

local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(1, 0, 1, 0)
Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame5.BackgroundTransparency = 1
Frame5.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame5.Parent = ToggleScriptVisibility

local UIAspectRatioConstraint1 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint1.Parent = Frame5

local ToggleScriptVisibilityButton = Instance.new("TextButton")
ToggleScriptVisibilityButton.Name = "ToggleScriptVisibilityButton"
ToggleScriptVisibilityButton.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleScriptVisibilityButton.Size = UDim2.new(1, 0, 1, 0)
ToggleScriptVisibilityButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleScriptVisibilityButton.BackgroundTransparency = 0
ToggleScriptVisibilityButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleScriptVisibilityButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ToggleScriptVisibilityButton.TextSize = 14
ToggleScriptVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleScriptVisibilityButton.Text = ""
ToggleScriptVisibilityButton.Font = Enum.Font.Gotham
ToggleScriptVisibilityButton:SetAttribute("ExcludeAutoButtonColorRule", true)
ToggleScriptVisibilityButton.Parent = Frame5

local UICornerToggleScriptVisibilityButton = Instance.new("UICorner")
UICornerToggleScriptVisibilityButton.CornerRadius = UDim.new(1, 0)
UICornerToggleScriptVisibilityButton.Parent = ToggleScriptVisibilityButton

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.AnchorPoint = Vector2.new(0, 0.5)
TextLabel1.Size = UDim2.new(1, -40, 1, 0)
TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel1.Position = UDim2.new(0, 28, 0.5, 0)
TextLabel1.BackgroundTransparency = 1
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel1.Text = "Toggle script visibility by clicking on the list"
TextLabel1.TextWrapped = true
TextLabel1.TextWrap = true
TextLabel1.Font = Enum.Font.Gotham
TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
TextLabel1.Parent = ToggleScriptVisibility

local IncludeWhitespace = Instance.new("Frame")
IncludeWhitespace.Name = "IncludeWhitespace"
IncludeWhitespace.LayoutOrder = 3
IncludeWhitespace.Size = UDim2.new(1, 0, 0, 20)
IncludeWhitespace.BorderColor3 = Color3.fromRGB(0, 0, 0)
IncludeWhitespace.BackgroundTransparency = 1
IncludeWhitespace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IncludeWhitespace.Parent = SettingsScrollingFrame

local Frame6 = Instance.new("Frame")
Frame6.Size = UDim2.new(1, 0, 1, 0)
Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame6.BackgroundTransparency = 1
Frame6.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame6.Parent = IncludeWhitespace

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Parent = Frame6

local WhitespaceButton = Instance.new("TextButton")
WhitespaceButton.Name = "WhitespaceButton"
WhitespaceButton.AnchorPoint = Vector2.new(0.5, 0.5)
WhitespaceButton.Size = UDim2.new(1, 0, 1, 0)
WhitespaceButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
WhitespaceButton.BackgroundTransparency = 0
WhitespaceButton.Position = UDim2.new(0.5, 0, 0.5, 0)
WhitespaceButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
WhitespaceButton.TextSize = 14
WhitespaceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WhitespaceButton.Text = ""
WhitespaceButton.Font = Enum.Font.Gotham
WhitespaceButton.Parent = Frame6
WhitespaceButton:SetAttribute("ExcludeAutoButtonColorRule", true)

local UICornerWhitespaceButton = Instance.new("UICorner")
UICornerWhitespaceButton.CornerRadius = UDim.new(1, 0)
UICornerWhitespaceButton.Parent = WhitespaceButton

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.AnchorPoint = Vector2.new(0, 0.5)
TextLabel2.Size = UDim2.new(1, -40, 1, 0)
TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel2.Position = UDim2.new(0, 28, 0.5, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextSize = 14
TextLabel2.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel2.Text = "Include whitespace characters"
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = IncludeWhitespace

local ColorEffects = Instance.new("Frame")
ColorEffects.Name = "ColorEffects"
ColorEffects.LayoutOrder = 5
ColorEffects.Size = UDim2.new(1, 0, 0, 20)
ColorEffects.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorEffects.BackgroundTransparency = 1
ColorEffects.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorEffects.Parent = SettingsScrollingFrame

local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(1, 0, 1, 0)
Frame7.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame7.BackgroundTransparency = 1
Frame7.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame7.Parent = ColorEffects

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Parent = Frame7

local ColorEffectsButton = Instance.new("TextButton")
ColorEffectsButton.Name = "ColorEffectsButton"
ColorEffectsButton.AnchorPoint = Vector2.new(0.5, 0.5)
ColorEffectsButton.Size = UDim2.new(1, 0, 1, 0)
ColorEffectsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorEffectsButton.BackgroundTransparency = 0
ColorEffectsButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ColorEffectsButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ColorEffectsButton.TextSize = 14
ColorEffectsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorEffectsButton.Text = ""
ColorEffectsButton.Font = Enum.Font.Gotham
ColorEffectsButton:SetAttribute("ExcludeAutoButtonColorRule", true)
ColorEffectsButton.Parent = Frame7

local UICornerColorEffectsButton = Instance.new("UICorner")
UICornerColorEffectsButton.CornerRadius = UDim.new(1, 0)
UICornerColorEffectsButton.Parent = ColorEffectsButton

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.AnchorPoint = Vector2.new(0, 0.5)
TextLabel3.Size = UDim2.new(1, -40, 1, 0)
TextLabel3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel3.Position = UDim2.new(0, 28, 0.5, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.TextSize = 14
TextLabel3.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel3.Text = "Create color effects"
TextLabel3.TextWrapped = true
TextLabel3.TextWrap = true
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = ColorEffects

local Theme = Instance.new("Frame")
Theme.Name = "Theme"
Theme.LayoutOrder = 8
Theme.Size = UDim2.new(1, 0, 0, 30)
Theme.BorderColor3 = Color3.fromRGB(0, 0, 0)
Theme.BackgroundTransparency = 1
Theme.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Theme.Parent = SettingsScrollingFrame

local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(1, 0, 1, 0)
Frame8.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame8.BackgroundTransparency = 1
Frame8.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame8.Parent = Theme

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.AspectRatio = 3
UIAspectRatioConstraint4.Parent = Frame8

local ThemeButton = Instance.new("TextButton")
ThemeButton.Name = "ThemeButton"
ThemeButton.AnchorPoint = Vector2.new(0.5, 0.5)
ThemeButton.Size = UDim2.new(1, 0, 1, 0)
ThemeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ThemeButton.BackgroundTransparency = 0
ThemeButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ThemeButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ThemeButton.TextSize = 14
ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ThemeButton.Text = "Auto"
ThemeButton.Font = Enum.Font.Gotham
ThemeButton.Parent = Frame8

local UICornerThemeButton = Instance.new("UICorner")
UICornerThemeButton.CornerRadius = UDim.new(0, 8)
UICornerThemeButton.Parent = ThemeButton

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.AnchorPoint = Vector2.new(0, 0.5)
TextLabel4.Size = UDim2.new(1, -100, 1, 0)
TextLabel4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel4.Position = UDim2.new(0, 96, 0.5, 0)
TextLabel4.BackgroundTransparency = 1
TextLabel4.TextSize = 14
TextLabel4.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel4.Text = "Theme"
TextLabel4.TextWrapped = true
TextLabel4.TextWrap = true
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.Parent = Theme

local Order = Instance.new("Frame")
Order.Name = "Order"
Order.LayoutOrder = 11
Order.Size = UDim2.new(1, 0, 0, 30)
Order.BorderColor3 = Color3.fromRGB(0, 0, 0)
Order.BackgroundTransparency = 1
Order.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Order.Parent = SettingsScrollingFrame

local Frame9 = Instance.new("Frame")
Frame9.Size = UDim2.new(1, 0, 1, 0)
Frame9.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame9.BackgroundTransparency = 1
Frame9.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
Frame9.Parent = Order

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.AspectRatio = 5
UIAspectRatioConstraint5.Parent = Frame9

local OrderButton = Instance.new("TextButton")
OrderButton.Name = "OrderButton"
OrderButton.AnchorPoint = Vector2.new(0.5, 0.5)
OrderButton.Size = UDim2.new(1, 0, 1, 0)
OrderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
OrderButton.BackgroundTransparency = 0
OrderButton.Position = UDim2.new(0.5, 0, 0.5, 0)
OrderButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
OrderButton.TextSize = 14
OrderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OrderButton.Text = "Random"
OrderButton.Font = Enum.Font.Gotham
OrderButton.Parent = Frame9

local UICornerOrderButton = Instance.new("UICorner")
UICornerOrderButton.CornerRadius = UDim.new(0, 8)
UICornerOrderButton.Parent = OrderButton

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.AnchorPoint = Vector2.new(0, 0.5)
TextLabel5.Size = UDim2.new(1, -160, 1, 0)
TextLabel5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel5.Position = UDim2.new(0, 156, 0.5, 0)
TextLabel5.BackgroundTransparency = 1
TextLabel5.TextSize = 14
TextLabel5.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel5.Text = "Order"
TextLabel5.TextWrapped = true
TextLabel5.TextWrap = true
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
TextLabel5.Parent = Order

local ColorEditor = Instance.new("Frame")
ColorEditor.Name = "ColorEditor"
ColorEditor.LayoutOrder = 6
ColorEditor.Size = UDim2.new(1, 0, 0, 156)
ColorEditor.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorEditor.BackgroundTransparency = 1
ColorEditor.Position = UDim2.new(0, 0, 0.2352941, 0)
ColorEditor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorEditor.Parent = SettingsScrollingFrame

local ColorEditorSub = Instance.new("Frame")
ColorEditorSub.Size = UDim2.new(1, 0, 1, 0)
ColorEditorSub.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorEditorSub.BackgroundTransparency = 1
ColorEditorSub.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
ColorEditorSub.Parent = ColorEditor

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.AspectRatio = 1.71
UIAspectRatioConstraint6.DominantAxis = Enum.DominantAxis.Height
UIAspectRatioConstraint6.Parent = ColorEditorSub

local ChangeFrame = Instance.new("Frame")
ChangeFrame.Name = "1"
ChangeFrame.LayoutOrder = 1
ChangeFrame.Size = UDim2.new(0, 24, 0, 24)
ChangeFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChangeFrame.BackgroundColor3 = Color3.fromRGB(15, 178, 227)
ChangeFrame.Parent = ColorEditorSub

local TextLabel6 = Instance.new("TextLabel")
TextLabel6.AnchorPoint = Vector2.new(0, 0.5)
TextLabel6.Size = UDim2.new(0, 120, 1, 0)
TextLabel6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel6.Position = UDim2.new(0, 135, 0.5, 0)
TextLabel6.BackgroundTransparency = 1
TextLabel6.TextSize = 14
TextLabel6.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel6.Text = "Change"
TextLabel6.TextWrapped = true
TextLabel6.TextWrap = true
TextLabel6.Font = Enum.Font.Gotham
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = ChangeFrame

local ChangeTextBox = Instance.new("TextBox")
ChangeTextBox.AnchorPoint = Vector2.new(0, 0.5)
ChangeTextBox.Size = UDim2.new(4, 0, 1, 0)
ChangeTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChangeTextBox.BackgroundTransparency = 1
ChangeTextBox.Position = UDim2.new(1, 8, 0.5, 0)
ChangeTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ChangeTextBox.TextSize = 14
ChangeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeTextBox.Text = "15, 178, 227"
ChangeTextBox.Font = Enum.Font.Gotham
ChangeTextBox.Parent = ChangeFrame

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.Padding = UDim.new(0, 6)
UIListLayout2.Parent = ColorEditorSub

local UIPadding2 = Instance.new("UIPadding")
UIPadding2.PaddingTop = UDim.new(0, 6)
UIPadding2.PaddingBottom = UDim.new(0, 6)
UIPadding2.PaddingLeft = UDim.new(0, 6)
UIPadding2.PaddingRight = UDim.new(0, 6)
UIPadding2.Parent = ColorEditorSub

local SelectedFrame = Instance.new("Frame")
SelectedFrame.Name = "2"
SelectedFrame.LayoutOrder = 2
SelectedFrame.Size = UDim2.new(0, 24, 0, 24)
SelectedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedFrame.BackgroundColor3 = Color3.fromRGB(15, 178, 227)
SelectedFrame.Parent = ColorEditorSub

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.AnchorPoint = Vector2.new(0, 0.5)
TextLabel7.Size = UDim2.new(0, 120, 1, 0)
TextLabel7.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel7.Position = UDim2.new(0, 135, 0.5, 0)
TextLabel7.BackgroundTransparency = 1
TextLabel7.TextSize = 14
TextLabel7.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel7.Text = "Selected"
TextLabel7.TextWrapped = true
TextLabel7.TextWrap = true
TextLabel7.Font = Enum.Font.Gotham
TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
TextLabel7.Parent = SelectedFrame

local SelectedTextBox = Instance.new("TextBox")
SelectedTextBox.AnchorPoint = Vector2.new(0, 0.5)
SelectedTextBox.Size = UDim2.new(4, 0, 1, 0)
SelectedTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedTextBox.BackgroundTransparency = 1
SelectedTextBox.Position = UDim2.new(1, 8, 0.5, 0)
SelectedTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedTextBox.TextSize = 14
SelectedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedTextBox.Text = "15, 178, 227"
SelectedTextBox.Font = Enum.Font.Gotham
SelectedTextBox.Parent = SelectedFrame

local UIStroke19 = Instance.new("UIStroke")
UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke19.Thickness = 2
UIStroke19.Color = Color3.fromRGB(10, 10, 10)
UIStroke19.Parent = SelectedTextBox

local UICorner18 = Instance.new("UICorner")
UICorner18.Parent = SelectedTextBox

local OpenScriptFrame = Instance.new("Frame")
OpenScriptFrame.Name = "3"
OpenScriptFrame.LayoutOrder = 3
OpenScriptFrame.Size = UDim2.new(0, 24, 0, 24)
OpenScriptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
OpenScriptFrame.BackgroundColor3 = Color3.fromRGB(142, 114, 255)
OpenScriptFrame.Parent = ColorEditorSub

local UICorner19 = Instance.new("UICorner")
UICorner19.Parent = OpenScriptFrame

local UIStroke20 = Instance.new("UIStroke")
UIStroke20.Thickness = 2
UIStroke20.Color = Color3.fromRGB(10, 10, 10)
UIStroke20.Parent = OpenScriptFrame

local TextLabel8 = Instance.new("TextLabel")
TextLabel8.AnchorPoint = Vector2.new(0, 0.5)
TextLabel8.Size = UDim2.new(0, 120, 1, 0)
TextLabel8.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel8.Position = UDim2.new(0, 135, 0.5, 0)
TextLabel8.BackgroundTransparency = 1
TextLabel8.TextSize = 14
TextLabel8.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel8.Text = "Open script"
TextLabel8.TextWrapped = true
TextLabel8.TextWrap = true
TextLabel8.Font = Enum.Font.Gotham
TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
TextLabel8.Parent = OpenScriptFrame

local OpenScriptTextBox = Instance.new("TextBox")
OpenScriptTextBox.AnchorPoint = Vector2.new(0, 0.5)
OpenScriptTextBox.Size = UDim2.new(4, 0, 1, 0)
OpenScriptTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
OpenScriptTextBox.BackgroundTransparency = 1
OpenScriptTextBox.Position = UDim2.new(1, 8, 0.5, 0)
OpenScriptTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenScriptTextBox.TextSize = 14
OpenScriptTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenScriptTextBox.Text = "142, 114, 255"
OpenScriptTextBox.Font = Enum.Font.Gotham
OpenScriptTextBox.Parent = OpenScriptFrame

local UIStroke21 = Instance.new("UIStroke")
UIStroke21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke21.Thickness = 2
UIStroke21.Color = Color3.fromRGB(10, 10, 10)
UIStroke21.Parent = OpenScriptTextBox

local UICorner20 = Instance.new("UICorner")
UICorner20.Parent = OpenScriptTextBox

local UISizeConstraint = Instance.new("UISizeConstraint")
UISizeConstraint.MinSize = Vector2.new(156, 156)
UISizeConstraint.MaxSize = Vector2.new(math.huge, 156)
UISizeConstraint.Parent = ColorEditorSub

local IncreaseFrame = Instance.new("Frame")
IncreaseFrame.Name = "4"
IncreaseFrame.LayoutOrder = 4
IncreaseFrame.Size = UDim2.new(0, 24, 0, 24)
IncreaseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
IncreaseFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
IncreaseFrame.Parent = ColorEditorSub

local UICorner21 = Instance.new("UICorner")
UICorner21.Parent = IncreaseFrame

local UIStroke22 = Instance.new("UIStroke")
UIStroke22.Thickness = 2
UIStroke22.Color = Color3.fromRGB(10, 10, 10)
UIStroke22.Parent = IncreaseFrame

local TextLabel9 = Instance.new("TextLabel")
TextLabel9.AnchorPoint = Vector2.new(0, 0.5)
TextLabel9.Size = UDim2.new(0, 120, 1, 0)
TextLabel9.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel9.Position = UDim2.new(0, 135, 0.5, 0)
TextLabel9.BackgroundTransparency = 1
TextLabel9.TextSize = 14
TextLabel9.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel9.Text = "Increase"
TextLabel9.TextWrapped = true
TextLabel9.TextWrap = true
TextLabel9.Font = Enum.Font.Gotham
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = IncreaseFrame

local IncreaseTextBox = Instance.new("TextBox")
IncreaseTextBox.AnchorPoint = Vector2.new(0, 0.5)
IncreaseTextBox.Size = UDim2.new(4, 0, 1, 0)
IncreaseTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
IncreaseTextBox.BackgroundTransparency = 1
IncreaseTextBox.Position = UDim2.new(1, 8, 0.5, 0)
IncreaseTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IncreaseTextBox.TextSize = 14
IncreaseTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseTextBox.Text = "0, 255, 0"
IncreaseTextBox.Font = Enum.Font.Gotham
IncreaseTextBox.Parent = IncreaseFrame

local DecreaseFrame = Instance.new("Frame")
DecreaseFrame.Name = "5"
DecreaseFrame.LayoutOrder = 5
DecreaseFrame.Size = UDim2.new(0, 24, 0, 24)
DecreaseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
DecreaseFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DecreaseFrame.Parent = ColorEditorSub

local TextLabel10 = Instance.new("TextLabel")
TextLabel10.AnchorPoint = Vector2.new(0, 0.5)
TextLabel10.Size = UDim2.new(0, 120, 1, 0)
TextLabel10.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel10.Position = UDim2.new(0, 135, 0.5, 0)
TextLabel10.BackgroundTransparency = 1
TextLabel10.TextSize = 14
TextLabel10.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel10.Text = "Decrease"
TextLabel10.TextWrapped = true
TextLabel10.TextWrap = true
TextLabel10.Font = Enum.Font.Gotham
TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
TextLabel10.Parent = DecreaseFrame

local DecreaseTextBox = Instance.new("TextBox")
DecreaseTextBox.AnchorPoint = Vector2.new(0, 0.5)
DecreaseTextBox.Size = UDim2.new(4, 0, 1, 0)
DecreaseTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
DecreaseTextBox.BackgroundTransparency = 1
DecreaseTextBox.Position = UDim2.new(1, 8, 0.5, 0)
DecreaseTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DecreaseTextBox.TextSize = 14
DecreaseTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseTextBox.Text = "255, 0, 0"
DecreaseTextBox.Font = Enum.Font.Gotham
DecreaseTextBox.Parent = DecreaseFrame

local ListSettings1 = Instance.new("TextLabel")
ListSettings1.Name = "ListSettings"
ListSettings1.LayoutOrder = 13
ListSettings1.ZIndex = 3
ListSettings1.AnchorPoint = Vector2.new(0, 0.5)
ListSettings1.Size = UDim2.new(1, 0, 0, 40)
ListSettings1.BackgroundTransparency = 1
ListSettings1.Position = UDim2.new(0, 0, 0, 10)
ListSettings1.TextTruncate = Enum.TextTruncate.AtEnd
ListSettings1.TextSize = 14
ListSettings1.RichText = true
ListSettings1.TextColor3 = Color3.fromRGB(188, 188, 188)
ListSettings1.TextYAlignment = Enum.TextYAlignment.Bottom
ListSettings1.Text = "Any issues? Report them to <b>@ProBaturay</b> through DevForum, via Roblox."
ListSettings1.TextWrapped = true
ListSettings1.TextWrap = true
ListSettings1.Font = Enum.Font.Gotham
ListSettings1.Parent = SettingsScrollingFrame

local ReturnToMainMenuButton = Instance.new("TextButton")
ReturnToMainMenuButton.Name = "ReturnToMainMenuButton"
ReturnToMainMenuButton.AnchorPoint = Vector2.new(0.5, 0.5)
ReturnToMainMenuButton.Size = UDim2.new(1, 0, 0, 30)
ReturnToMainMenuButton.Position = UDim2.new(0.5, 0, 1, -25)
ReturnToMainMenuButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ReturnToMainMenuButton.AutoButtonColor = false
ReturnToMainMenuButton.TextSize = 14
ReturnToMainMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnToMainMenuButton.Text = "Return to Main Menu"
ReturnToMainMenuButton.Font = Enum.Font.Gotham
ReturnToMainMenuButton.Parent = SettingsMenu

local Assets = Instance.new("Folder")
Assets.Name = "Assets"
Assets.Parent = Whole

local CheckboxCheckedDark = Instance.new("ImageLabel")
CheckboxCheckedDark.Name = "CheckboxCheckedDark"
CheckboxCheckedDark.Visible = false
CheckboxCheckedDark.Size = UDim2.new(0, 20, 0, 20)
CheckboxCheckedDark.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckboxCheckedDark.BackgroundTransparency = 1
CheckboxCheckedDark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckboxCheckedDark.Image = "rbxasset://textures/DeveloperFramework/checkbox_checked_dark.png"
CheckboxCheckedDark.Parent = Assets

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CheckboxCheckedDark

local CheckboxCheckedLight = Instance.new("ImageLabel")
CheckboxCheckedLight.Name = "CheckboxCheckedLight"
CheckboxCheckedLight.Visible = false
CheckboxCheckedLight.Size = UDim2.new(0, 20, 0, 20)
CheckboxCheckedLight.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckboxCheckedLight.BackgroundTransparency = 1
CheckboxCheckedLight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckboxCheckedLight.Image = "rbxasset://textures/DeveloperFramework/checkbox_checked_light.png"
CheckboxCheckedLight.Parent = Assets

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CheckboxCheckedLight

local CheckboxUncheckedLight = Instance.new("ImageLabel")
CheckboxUncheckedLight.Name = "CheckboxUncheckedLight"
CheckboxUncheckedLight.Visible = false
CheckboxUncheckedLight.Size = UDim2.new(0, 20, 0, 20)
CheckboxUncheckedLight.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckboxUncheckedLight.BackgroundTransparency = 1
CheckboxUncheckedLight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckboxUncheckedLight.Image = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_disabled_light.png"
CheckboxUncheckedLight.Parent = Assets

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CheckboxUncheckedLight

local CheckboxUncheckedDark = Instance.new("ImageLabel")
CheckboxUncheckedDark.Name = "CheckboxUncheckedDark"
CheckboxUncheckedDark.Visible = false
CheckboxUncheckedDark.Size = UDim2.new(0, 20, 0, 20)
CheckboxUncheckedDark.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckboxUncheckedDark.BackgroundTransparency = 1
CheckboxUncheckedDark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckboxUncheckedDark.Image = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_dark.png"
CheckboxUncheckedDark.Parent = Assets

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CheckboxUncheckedDark

local SettingsFolder = Instance.new("Folder")
SettingsFolder.Name = "Settings"
SettingsFolder.Parent = Whole

local Bool = Instance.new("Folder")
Bool.Name = "Bool"
Bool.Parent = SettingsFolder

local ToggleScriptVisibilityValue = Instance.new("BoolValue")
ToggleScriptVisibilityValue.Name = "ToggleScriptVisibility"
ToggleScriptVisibilityValue.Parent = Bool

local IncludeWhitespaceValue = Instance.new("BoolValue")
IncludeWhitespaceValue.Name = "IncludeWhitespace"
IncludeWhitespaceValue.Parent = Bool

local CreateColorEffectsValue = Instance.new("BoolValue")
CreateColorEffectsValue.Name = "CreateColorEffects"
CreateColorEffectsValue.Parent = Bool

local Plugin = Instance.new("Folder")
Plugin.Name = "Plugin"
Plugin.Parent = SettingsFolder

local ThemeValue = Instance.new("StringValue")
ThemeValue.Name = "Theme"
ThemeValue.Parent = Plugin

local Colors = Instance.new("Folder")
Colors.Name = "Colors"
Colors.Parent = SettingsFolder

local ChangeValue = Instance.new("Color3Value")
ChangeValue.Name = "Change"
ChangeValue.Parent = Colors

local SelectedValue = Instance.new("Color3Value")
SelectedValue.Name = "Selected"
SelectedValue.Parent = Colors

local OpenScriptValue = Instance.new("Color3Value")
OpenScriptValue.Name = "OpenScript"
OpenScriptValue.Parent = Colors

local IncreaseValue = Instance.new("Color3Value")
IncreaseValue.Name = "Increase"
IncreaseValue.Parent = Colors

local DecreaseValue = Instance.new("Color3Value")
DecreaseValue.Name = "Decrease"
DecreaseValue.Parent = Colors

local List = Instance.new("Folder")
List.Name = "List"
List.Parent = SettingsFolder

local OrderValue = Instance.new("StringValue")
OrderValue.Name = "Order"
OrderValue.Parent = List

local FactorValue = Instance.new("StringValue")
FactorValue.Name = "Factor"
FactorValue.Parent = List

do --obviate 200 local limit
	local UIStroke = Instance.new("UIStroke")
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Thickness = 2
	UIStroke.Color = Color3.fromRGB(10, 10, 10)
	UIStroke.Parent = SettingsButton

	local UICorner = Instance.new("UICorner")
	UICorner.Parent = SettingsButton
	
	local UIStroke2 = Instance.new("UIStroke")
	UIStroke2.Color = Color3.fromRGB(10, 10, 10)
	UIStroke2.Parent = Directory

	local UICorner1 = Instance.new("UICorner")
	UICorner1.Parent = Directory
	
	local UIStroke3 = Instance.new("UIStroke")
	UIStroke3.Thickness = 2
	UIStroke3.Color = Color3.fromRGB(10, 10, 10)
	UIStroke3.Parent = Stats_

	local UICorner2 = Instance.new("UICorner")
	UICorner2.Parent = Stats_
	
	local UIStroke4 = Instance.new("UIStroke")
	UIStroke4.Color = Color3.fromRGB(10, 10, 10)
	UIStroke4.Parent = Frame

	local UICorner3 = Instance.new("UICorner")
	UICorner3.Parent = Frame
	
	local UIStroke5 = Instance.new("UIStroke")
	UIStroke5.Color = Color3.fromRGB(10, 10, 10)
	UIStroke5.Parent = Frame1

	local UICorner4 = Instance.new("UICorner")
	UICorner4.Parent = Frame1

	local UIStroke6 = Instance.new("UIStroke")
	UIStroke6.Color = Color3.fromRGB(10, 10, 10)
	UIStroke6.Parent = Frame2

	local UICorner5 = Instance.new("UICorner")
	UICorner5.Parent = Frame2
	
	local UIStroke7 = Instance.new("UIStroke")
	UIStroke7.Color = Color3.fromRGB(10, 10, 10)
	UIStroke7.Parent = Frame3

	local UICorner6 = Instance.new("UICorner")
	UICorner6.Parent = Frame3
	
	local UICorner7 = Instance.new("UICorner")
	UICorner7.Parent = Frame4

	local UIStroke8 = Instance.new("UIStroke")
	UIStroke8.Thickness = 2
	UIStroke8.Color = Color3.fromRGB(10, 10, 10)
	UIStroke8.Parent = Frame4
	
	local UIStroke10 = Instance.new("UIStroke")
	UIStroke10.Thickness = 2
	UIStroke10.Color = Color3.fromRGB(10, 10, 10)
	UIStroke10.Parent = Frame5

	local UICorner8 = Instance.new("UICorner")
	UICorner8.CornerRadius = UDim.new(1, 0)
	UICorner8.Parent = Frame5
	
	local UIStroke11 = Instance.new("UIStroke")
	UIStroke11.Thickness = 2
	UIStroke11.Color = Color3.fromRGB(10, 10, 10)
	UIStroke11.Parent = Frame6

	local UICorner9 = Instance.new("UICorner")
	UICorner9.CornerRadius = UDim.new(1, 0)
	UICorner9.Parent = Frame6
	
	local UIStroke12 = Instance.new("UIStroke")
	UIStroke12.Thickness = 2
	UIStroke12.Color = Color3.fromRGB(10, 10, 10)
	UIStroke12.Parent = Frame7

	local UICorner10 = Instance.new("UICorner")
	UICorner10.CornerRadius = UDim.new(1, 0)
	UICorner10.Parent = Frame7
	
	local UICorner11 = Instance.new("UICorner")
	UICorner11.Parent = Frame8

	local UIStroke13 = Instance.new("UIStroke")
	UIStroke13.Thickness = 2
	UIStroke13.Color = Color3.fromRGB(10, 10, 10)
	UIStroke13.Parent = Frame8
	
	local UICorner12 = Instance.new("UICorner")
	UICorner12.Parent = Frame9

	local UIStroke14 = Instance.new("UIStroke")
	UIStroke14.Thickness = 2
	UIStroke14.Color = Color3.fromRGB(10, 10, 10)
	UIStroke14.Parent = Frame9

	local UICorner13 = Instance.new("UICorner")
	UICorner13.Parent = SettingsScrollingFrame
	
	local UIStroke15 = Instance.new("UIStroke")
	UIStroke15.Thickness = 2
	UIStroke15.Color = Color3.fromRGB(10, 10, 10)
	UIStroke15.Parent = ColorEditorSub

	local UICorner14 = Instance.new("UICorner")
	UICorner14.Parent = ColorEditorSub
	
	local UICorner15 = Instance.new("UICorner")
	UICorner15.Parent = ChangeFrame

	local UIStroke16 = Instance.new("UIStroke")
	UIStroke16.Thickness = 2
	UIStroke16.Color = Color3.fromRGB(10, 10, 10)
	UIStroke16.Parent = ChangeFrame
end

do 
	local UIStroke26 = Instance.new("UIStroke")
	UIStroke26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke26.Thickness = 2
	UIStroke26.Color = Color3.fromRGB(10, 10, 10)
	UIStroke26.Parent = ReturnToMainMenuButton

	local UICorner25 = Instance.new("UICorner")
	UICorner25.Parent = ReturnToMainMenuButton
	
	local UICorner16 = Instance.new("UICorner")
	UICorner16.Parent = ChangeTextBox

	local UIStroke17 = Instance.new("UIStroke")
	UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke17.Thickness = 2
	UIStroke17.Color = Color3.fromRGB(10, 10, 10)
	UIStroke17.Parent = ChangeTextBox

	local UICorner17 = Instance.new("UICorner")
	UICorner17.Parent = SelectedFrame

	local UIStroke18 = Instance.new("UIStroke")
	UIStroke18.Thickness = 2
	UIStroke18.Color = Color3.fromRGB(10, 10, 10)
	UIStroke18.Parent = SelectedFrame
	
	local UIStroke23 = Instance.new("UIStroke")
	UIStroke23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke23.Thickness = 2
	UIStroke23.Color = Color3.fromRGB(10, 10, 10)
	UIStroke23.Parent = IncreaseTextBox

	local UICorner22 = Instance.new("UICorner")
	UICorner22.Parent = IncreaseTextBox
	
	local UICorner23 = Instance.new("UICorner")
	UICorner23.Parent = DecreaseFrame

	local UIStroke24 = Instance.new("UIStroke")
	UIStroke24.Thickness = 2
	UIStroke24.Color = Color3.fromRGB(10, 10, 10)
	UIStroke24.Parent = DecreaseFrame
	
	local UIStroke25 = Instance.new("UIStroke")
	UIStroke25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke25.Thickness = 2
	UIStroke25.Color = Color3.fromRGB(10, 10, 10)
	UIStroke25.Parent = DecreaseTextBox

	local UICorner24 = Instance.new("UICorner")
	UICorner24.Parent = DecreaseTextBox
end

for _, object in widget:GetDescendants() do
	if object:IsA("UIStroke") then
		object.Color = Color3.fromRGB(10, 10, 10)
	elseif object:IsA("GuiObject") then
		object.BorderSizePixel = 0
	end
	
	if object:IsA("TextButton") and not object:GetAttribute("ExcludeAutoButtonColorRule") then
		object.AutoButtonColor = true
	end
end

for i, frame in ColorEditorSub:GetChildren() do
	if frame:IsA("Frame") and tonumber(frame.Name) then
		frame:SetAttribute("ExcludeThemeRule", true)
	end
end

local intValue = Instance.new("IntValue")
intValue.Value = 0
intValue.Parent = script

local bindable = Instance.new("BindableEvent")
bindable.Parent = script

local TInfo_TextChange = TweenInfo.new(
	1,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local TInfo_UISlide = TweenInfo.new(
	0.4,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local services = {
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
		["VaryingText"] = Color3.fromRGB(24, 24, 24),
		["ScrollBar"] = Color3.fromRGB(240, 240, 240),
		["Stroke"] = Color3.fromRGB(200, 200, 200)
	},
}

local function retrievePossibleSettings()
	return {
		List = {
			Factor = {
				[1] = "Name",
				[2] = "ClassName"
			},
			Order = {
				[1] = "Random",
				[2] = "Char (ascending)",
				[3] = "Char (descending)",
				[4] = "Lines (ascending)",
				[5] = "Lines (descending)"
			}
		},
		Plugin = {
			Theme = {
				[1] = AUTO_PLUGIN,
				[2] = "Light",
				[3] = "Dark"
			}
		}
	}
end

local function retrieveSettings()
	return {
		Booleans = {
			ToggleScriptVisibility = ToggleScriptVisibilityValue.Value,
			IncludeWhitespace = IncludeWhitespaceValue.Value,
			CreateColorEffects = CreateColorEffectsValue.Value
		},
		Colors = {
			Change = ChangeValue.Value,
			Decrease = DecreaseValue.Value,
			Increase = IncreaseValue.Value,
			OpenScript = OpenScriptValue.Value,
			Selected = SelectedValue.Value
		},
		List = {
			Factor = FactorValue.Value,
			Order = OrderValue.Value
		},
		Plugin = {
			Theme = ThemeValue.Value
		}
	}
end

local settingsValues = {
	[1] = ChangeValue,
	[2] = SelectedValue,
	[3] = DecreaseValue,
	[4] = IncreaseValue,
	[5] = OpenScriptValue
}

local settingsTextBoxes = {
	[ChangeValue] = ChangeTextBox,
	[SelectedValue] = SelectedTextBox,
	[DecreaseValue] = DecreaseTextBox,
	[IncreaseValue] = IncreaseTextBox,
	[OpenScriptValue] = OpenScriptTextBox
}

local textBoxColorEquivalents = {
	[ChangeValue] = ChangeFrame,
	[SelectedValue] = SelectedFrame,
	[DecreaseValue] = DecreaseFrame,
	[IncreaseValue] = IncreaseFrame,
	[OpenScriptValue] = OpenScriptFrame
}

local inScriptGUIDs = {}

--| Functions

-- An implementation of table.find which includes keys

local function table_find<k, v>(tab: {[k]: v}, val): k?
	for k, v in tab do
		if val == v then
			return k
		end
	end
	
	return nil
end

local function table_nextone<v>(tab: {[any]: v}, index): v
	if #tab == index then
		return tab[1]
	else
		return tab[index + 1]
	end
end

local function isObjectSelected(object)
	local objects = Selection:Get()

	if table.find(objects, object) then
		return true
	end

	return false
end

local function isTextTruncate(text: TextLabel | TextBox | TextButton)
	return not text.TextFits
end

local function isScriptEligible(scr: LuaSourceContainer): boolean
	if scr then
		if scr:IsA("LuaSourceContainer") then
			for i, service in services do
				if scr:FindFirstAncestorOfClass(service) then
					return true
				end
			end
		end
	end

	return false
end

local function RGBToString(color3: Color3, round: boolean?)
	local r = if round then math.round(color3.R * 255) elseif round == false then color3.R * 255 else math.round(color3.R * 255)
	local g = if round then math.round(color3.G * 255) elseif round == false then color3.G * 255 else math.round(color3.G * 255)
	local b = if round then math.round(color3.B * 255) elseif round == false then color3.B * 255 else math.round(color3.B * 255)

	return r .. ", " .. g .. ", " .. b
end

local function changeTheme(theme: string?)	
	if not theme then
		theme = (settings().Studio.Theme :: Instance).Name
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
	
	if ThemeValue.Value == theme or ThemeValue.Value == "Auto" then
		-- guaranteed to change the theme
		
		for label, tween: Tween in textColorTweens do
			if tween.PlaybackState ~= Enum.PlaybackState.Completed then
				print("234")
				tween:Cancel()
				
				local instance = tween.Instance :: TextLabel
				instance.TextColor3 = themeColors[currentTheme]["VaryingText"]
			end
			
			textColorTweens[label] = nil
		end
		
		if theme :: any ~= currentTheme then
			for i, v in widget:GetDescendants() do
				for i, property in properties do
					pcall(function()
						if typeof(v[property]) == "Color3" and not v:GetAttribute("ExcludeThemeRule") then
							v[property] = findCorrespondingColor(v[property])
						end
					end)
				end
			end
		end
		
		currentTheme = theme :: any
	end
end

local function attachAttributes(scr: Script, newFrame: Frame)
	if newFrame:GetAttribute("ID") == nil then
		local id = HTTPService:GenerateGUID()
		inScriptGUIDs[id] = scr
		intValue.Value += 1
				
		newFrame:SetAttribute("ID", id)
		newFrame:SetAttribute("ExcludeThemeRule", false)
		newFrame:SetAttribute("SourceContainerName", script.Name)
		newFrame:SetAttribute("SourceContainerType", script.ClassName)
		
		local Object = Instance.new("ObjectValue")
		Object.Value = scr
		Object.Name = "ScriptAttached"
		Object.Parent = newFrame
	end
end

local function calculateCanvasPosition(frame: Frame): Vector2
	local examplesBefore = frame.LayoutOrder - 3
	local numberOfPaddings = frame.LayoutOrder
	
	local totalScriptStatsLength = (examplesBefore * Directory.Size.Y.Offset)
	local totalGapLength = (numberOfPaddings * (UIListLayout.Padding.Offset))
	
	local formula = Vector2.new(0, totalScriptStatsLength + Separator.Size.Y.Offset + Directory.Size.Y.Offset + (numberOfPaddings * (UIListLayout.Padding.Offset)) - frame.Size.Y.Offset / 2)
	return formula
end

local function tryOpeningDoc(scr: LuaSourceContainer)
	local s, e = pcall(function()
		ScriptEditorService:OpenScriptDocumentAsync(scr)
	end)

	if not s then
		warn("Script" .. scr.Name .. " could not be opened:", e)
	end
end

local function findFrameByDoc(doc: ScriptDocument): Frame
	local scr = doc:GetScript()
	local id = table_find(inScriptGUIDs, scr)

	for _, frame in ScriptScrollingFrame:GetDescendants() do
		local frameId = frame:GetAttribute("ID")

		if frame:IsA("Frame") and frameId and frameId == id then
			return frame
		end
	end

	return nil :: never
end

local function findDocFromScript(scr: LuaSourceContainer)
	return ScriptEditorService:FindScriptDocument(scr)
end

local function setSelectionState(scr: Script, frame: Frame)
	local objects = Selection:Get()
	local pos = table.find(objects, scr)
		
	if pos then
		table.remove(objects, pos)
		frame:SetAttribute("ExcludeThemeRule", false)
		
		if ToggleScriptVisibilityValue.Value then
			local s, e = pcall(function()
				local doc = findDocFromScript(scr)
				doc:CloseAsync()
			end)
			
			if not s then
				warn("Script could not be closed:", e)
			end
		end
	else
		if ToggleScriptVisibilityValue.Value then
			TweenService:Create(ScriptScrollingFrame, TInfo_UISlide, {CanvasPosition = calculateCanvasPosition(frame)}):Play()
			tryOpeningDoc(scr)
		end
		
		table.insert(objects, scr)
		
		if CreateColorEffectsValue.Value then
			frame:SetAttribute("ExcludeThemeRule", true)
		end
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
	
	for i, frame in ScriptScrollingFrame:GetDescendants() do
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

local function createCheckBoxAtPosition(newValue: boolean, button: TextButton)
	local newImage
	
	if newValue == true then
		if currentTheme == "Dark" then
			newImage = CheckboxCheckedDark:Clone()
		else
			newImage = CheckboxCheckedLight:Clone()
		end
	else
		if currentTheme == "Dark" then
			newImage = CheckboxUncheckedDark:Clone()
		else
			newImage = CheckboxUncheckedLight:Clone()
		end
	end
	
	local oldImage = button:FindFirstChildOfClass("ImageLabel")
	
	if oldImage then
		oldImage:Destroy()
	end
	
	newImage.Visible = true
	newImage.Parent = button
end

local function changeLayoutOrder(order: string?)
	local function setInTheOrder(tab)
		local initialOrder = 3

		for index, data in tab do
			local frame = data["Frame"]
			if frame:IsA("Frame") and frame:GetAttribute("ID") and frame.Visible then
				frame.LayoutOrder = initialOrder
				initialOrder += 1
			end
		end
	end
	
	local function createTable2(Label)
		local tab = {}

		for i, frame in ScriptScrollingFrame:GetChildren() do
			if frame:IsA("Frame") and not string.find(frame.Name, "Separator") and not string.find(frame.Name, "Directory") then
				table.insert(tab, {
					Frame = frame,
					N = tonumber(frame[Label].Text)
				})
			end
		end
		
		return tab
	end
	
	local function finalize(label, operator)
		local tab = createTable2(label)

		table.sort(tab, function(a, b)
			return if operator == ">" then a["N"] > b["N"] else a["N"] < b["N"]
		end)

		setInTheOrder(tab)
	end
	
	if not order then
		local initialOrder = 3

		for index, frame in ScriptScrollingFrame:GetChildren() do
			if frame:IsA("Frame") and frame:GetAttribute("ID") and frame.Visible then
				frame.LayoutOrder = initialOrder
				initialOrder += 1
			end
		end
	elseif order == "Char (descending)" then
		finalize("Characters", ">")
	elseif order == "Char (ascending)" then
		finalize("Characters", "<")
	elseif order == "Lines (ascending)" then
		finalize("Lines", "<")
	elseif order == "Lines (descending)" then
		finalize("Lines", ">")
	end
end

local function changeDocFrameBackground(doc: ScriptDocument, state: boolean)
	-- if state is true, script is selected or active
	local scr = doc:GetScript()
	local frame = findFrameByDoc(doc)

	if frame and CreateColorEffectsValue.Value then
		if state then
			if not frame:GetAttribute("ExcludeThemeRule") then
				frame.BackgroundColor3 = (if findDocFromScript(scr) then constants[5] elseif isObjectSelected(scr) then constants[2] else themeColors[currentTheme]["FrameBackground"])
			end
		else
			frame.BackgroundColor3 = themeColors[currentTheme]["FrameBackground"]
			frame:SetAttribute("ExcludeThemeRule", false)
		end
	end
end

local function refreshCheckboxes()
	createCheckBoxAtPosition(IncludeWhitespaceValue.Value, WhitespaceButton)
	createCheckBoxAtPosition(ToggleScriptVisibilityValue.Value, ToggleScriptVisibilityButton)
	createCheckBoxAtPosition(CreateColorEffectsValue.Value, ColorEffectsButton)
end

local function getNumberOfFrames(scrollingFrame: ScrollingFrame)
	local total = 0
	
	for i, frame in scrollingFrame:GetChildren() do
		if frame:IsA("Frame") and not string.find(frame.Name, "Separator") then
			total += 1
		end
	end
	
	return total
end

local function insert(scr: nLuaSourceContainer)
	if isScriptEligible(scr) and not table_find(inScriptGUIDs, scr) then
		local hovered = false
		
		local newFrame = Directory:Clone()
		newFrame.Name = "ScriptStatsBase"
		newFrame.Visible = false
		newFrame.LayoutOrder = getNumberOfFrames(ScriptScrollingFrame) + 2
		newFrame.Parent = ScriptScrollingFrame
		
		attachAttributes(scr, newFrame)
		
		local tab = {
			["Lines"] = newFrame.Lines,
			["Characters"] = newFrame.Characters,
			["FullName"] = newFrame.FullName
		}

		local function setStrokeState(boolean: boolean)
			for i, label in tab do
				label.UIStroke.Enabled = boolean
			end
		end
		
		local last = {}
		
		for name, label in tab do	
			label.Text = "0"
			label.TextColor3 = themeColors[currentTheme]["VaryingText"]
			
			last[name] = label.Text

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Thickness = 0.3
			UIStroke.Color = themeColors[currentTheme]["VaryingText"]
			UIStroke.Enabled = false
			UIStroke.Parent = label
						
			local function tween()
				local tween = TweenService:Create(label, TInfo_TextChange, {TextColor3 = themeColors[currentTheme]["VaryingText"]})
				tween:Play()
				textColorTweens[label] = tween

				tween.Completed:Connect(function()
					textColorTweens[label] = nil

					if tween.PlaybackState == Enum.PlaybackState.Completed then
						label.TextColor3 = themeColors[currentTheme]["VaryingText"]
					end
				end)
			end
			
			label:GetPropertyChangedSignal("Text"):Connect(function()
				if CreateColorEffectsValue.Value then
					if name == "Lines" or name == "Characters" then
						label.TextColor3 = if tonumber(last[name]) :: number > tonumber(label.Text) :: number then constants[3] else constants[4]
					else
						label.TextColor3 = constants[2]
					end
					
					tween()
				end
				
				last[name] = label.Text
			end)
		end
		
		newFrame.InputChanged:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				hovered = false
				tab["FullName"].Text = scr:GetFullName()
			end

			setStrokeState(true)
		end)

		newFrame.MouseLeave:Connect(function()
			hovered = true
			setStrokeState(false)
			tab["FullName"].Text = scr.Name
		end)
		
		newFrame.InputEnded:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.End then
				setSelectionState(scr, newFrame)
			end
		end)
		
		local function set()
			local source = scr.Source
			
			local tableOfLines = string.split(source, "\n")

			if IncludeWhitespaceValue.Value then
				tab["Lines"].Text = tostring(#tableOfLines)
				local len = utf8.len(source)
				tab["Characters"].Text = tostring(len)
			else
				local newTab = {}
				
				for i, line in tableOfLines do
					if not (line == "" or string.match(line, "^%s*$")) then
						table.insert(newTab, line)
					end
				end
				
				local without_whitespace = string.gsub(source, "%s*", "")
				
				tab["Lines"].Text = tostring(#newTab)
				local len = utf8.len(without_whitespace)
				tab["Characters"].Text = tostring(len)
			end
			
			tab["FullName"].Text = scr.Name

			coroutine.wrap(function()
				adjustScriptStats()
				changeLayoutOrder(OrderValue.Value)
			end)()
		end

		set()
		
		scr:GetPropertyChangedSignal("Source"):Connect(set)

		scr:GetPropertyChangedSignal("Parent"):Connect(function()
			local id = newFrame:GetAttribute("ID")
		
			if not scr.Parent then
				inScriptGUIDs[id] = nil
				intValue.Value += 1
				newFrame:Destroy()
				changeLayoutOrder(OrderValue.Value)
			else
				newFrame.Visible = true
				inScriptGUIDs[id] = scr
				intValue.Value += 1
				changeLayoutOrder(OrderValue.Value)
				set()
			end
		end)
		
		scr:GetPropertyChangedSignal("Name"):Connect(function()
			tab["FullName"].Text = scr.Name
		end)
		
		local function changeBackground()
			if not CreateColorEffectsValue.Value then
				newFrame.BackgroundColor3 = themeColors[currentTheme]["FrameBackground"]
				newFrame:SetAttribute("ExcludeThemeRule", false)
			else
				if findDocFromScript(scr) then
					newFrame:SetAttribute("ExcludeThemeRule", true)
					newFrame.BackgroundColor3 = constants[5]
				elseif isObjectSelected(scr) then
					newFrame:SetAttribute("ExcludeThemeRule", true)
					newFrame.BackgroundColor3 = constants[2]
				else
					newFrame:SetAttribute("ExcludeThemeRule", false)
					newFrame.BackgroundColor3 = themeColors[currentTheme]["FrameBackground"]
				end
			end
		end
		
		CreateColorEffectsValue.Changed:Connect(changeBackground)
		
		for i, value in settingsValues do
			value.Changed:Connect(changeBackground)
		end
		
		bindable.Event:Connect(set)
		changeLayoutOrder(OrderValue.Value)
		newFrame.Visible = true
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

local function findFrameAndSetCanvasPosition(doc: ScriptDocument)
	local frame = findFrameByDoc(doc)
	
	if frame then
		TweenService:Create(ScriptScrollingFrame, TInfo_UISlide, {CanvasPosition = calculateCanvasPosition(frame)}):Play()
	end
end

local function parseTextBox(textBox): Color3?
	if textBox.Text ~= "" then
		local tab = string.split(textBox.Text, ",")

		if #tab == 3 then
			local num1, num2, num3 = tonumber(tab[1]), tonumber(tab[2]), tonumber(tab[3])

			if num1 and num2 and num3 then
				if num1 >= 0 and num1 <= 255 and num2 >= 0 and num2 <= 255 and num3 >= 0 and num3 <= 255 then
					return Color3.fromRGB(num1, num2, num3)
				end
			end
		end

		if string.find(textBox.Text, "^#%d+$") then
			return Color3.fromHex(textBox.Text)
		end
	end

	return nil
end

--| Events

Selection.SelectionChanged:Connect(function()
	local objects = Selection:Get()
	
	for i, frame in ScriptScrollingFrame:GetDescendants() do
		if frame:IsA("Frame") then
			local id = frame:GetAttribute("ID")
			local scr = inScriptGUIDs[id]
			
			if CreateColorEffectsValue.Value then
				frame.BackgroundColor3 = if table.find(objects, scr) then (if findDocFromScript(scr) then constants[5] else constants[2]) else (if findDocFromScript(scr) then constants[5] else themeColors[currentTheme]["FrameBackground"])
			end
		end
	end
end)

OrderValue.Changed:Connect(changeLayoutOrder)

SettingsButton.Activated:Connect(function()
	TweenService:Create(MainMenu, TInfo_UISlide, {Position = UDim2.fromScale(-2, MainMenu.Position.Y.Scale)}):Play()
	TweenService:Create(SettingsMenu, TInfo_UISlide, {Position = UDim2.fromScale(0.5, MainMenu.Position.Y.Scale)}):Play()
end)
	
ReturnToMainMenuButton.Activated:Connect(function()
	TweenService:Create(SettingsMenu, TInfo_UISlide, {Position = UDim2.fromScale(2, MainMenu.Position.Y.Scale)}):Play()
	TweenService:Create(MainMenu, TInfo_UISlide, {Position = UDim2.fromScale(0.5, MainMenu.Position.Y.Scale)}):Play()
end)

ScriptScrollingFrame.DescendantAdded:Connect(changeLayoutOrder)
ScriptScrollingFrame.DescendantRemoving:Connect(changeLayoutOrder)

settings().Studio.ThemeChanged:Connect(function()
	local theme = settings().Studio.Theme :: Instance
	
	changeTheme(theme.Name)
	
	refreshCheckboxes()
end)

intValue.Changed:Connect(changeObjectCounters)

ScriptEditorService.TextDocumentDidOpen:Connect(function(doc: ScriptDocument)
	changeDocFrameBackground(doc, true)
	findFrameAndSetCanvasPosition(doc)
end)

ScriptEditorService.TextDocumentDidClose:Connect(function(doc: ScriptDocument)
	changeDocFrameBackground(doc, false)
end)

StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
	local doc = findDocFromScript(StudioService.ActiveScript)
	
	if doc then
		findFrameAndSetCanvasPosition(doc)
	end
end)

WhitespaceButton.Activated:Connect(function()
	IncludeWhitespaceValue.Value = not IncludeWhitespaceValue.Value
	createCheckBoxAtPosition(IncludeWhitespaceValue.Value, WhitespaceButton)
	
	bindable:Fire()
end)

ToggleScriptVisibilityButton.Activated:Connect(function()
	ToggleScriptVisibilityValue.Value = not ToggleScriptVisibilityValue.Value
	createCheckBoxAtPosition(ToggleScriptVisibilityValue.Value, ToggleScriptVisibilityButton)
end)

ColorEffectsButton.Activated:Connect(function()
	CreateColorEffectsValue.Value = not CreateColorEffectsValue.Value
	createCheckBoxAtPosition(CreateColorEffectsValue.Value, ColorEffectsButton)
	
	ColorEditor.Visible = if CreateColorEffectsValue.Value then true else false
end)

CreateColorEffectsValue.Changed:Connect(function()
	ColorEditor.Visible = if CreateColorEffectsValue.Value then true else false
end)

ThemeButton.Activated:Connect(function()
	local value = ThemeValue.Value
	local stngs = retrievePossibleSettings().Plugin.Theme
	
	local newValue = table_nextone(stngs, table.find(stngs, value))
	ThemeButton.Text = newValue
	ThemeValue.Value = newValue
	
	if newValue == "Auto" then
		newValue = (settings().Studio.Theme :: Instance).Name
	end
	
	changeTheme(newValue)
	refreshCheckboxes()
end)

FactorButton.Activated:Connect(function()
	return -- next
end)

OrderButton.Activated:Connect(function()
	local value = OrderValue.Value
	local tab = retrievePossibleSettings().List.Order
	
	local newValue = table_nextone(tab, table.find(tab, value))
	OrderButton.Text = newValue
	OrderValue.Value = newValue
end)

game.DescendantAdded:Connect(insert)

for value, textBox in settingsTextBoxes do
	local last = ""
	local debounce = false

	textBox:GetPropertyChangedSignal("Text"):Connect(function()
		if not debounce then
			last = textBox.Text
		end
	end)

	textBox.Focused:Connect(function()
		debounce = true
	end)

	textBox.FocusLost:Connect(function()
		local text = textBox.Text
		local parsed = parseTextBox(textBox)
		
		local num = table.find(settingsValues, value)
		
		if parsed then
			constants[num] = parsed
			textBox.Text = text
			textBoxColorEquivalents[value].BackgroundColor3 = parsed
		else
			textBox.Text = RGBToString(constants[num])
		end
		
		for value, TextBox in settingsTextBoxes do
			value.Value = parseTextBox(TextBox)
		end
		
		debounce = false
	end)
end

if not widget:GetAttribute("Setup") then
	widget:SetAttribute("Setup", true)
	
	ColorEditor.Visible = false
	ThemeValue.Value = AUTO_PLUGIN
	CreateColorEffectsValue.Value = true
	OrderValue.Value = "Random"
	FactorValue.Value = "Name"
end

--| To be released

Factor.Visible = false

--

for _, v in game:GetDescendants() do
	insert(v)
end

for i, document: ScriptDocument in ScriptEditorService:GetScriptDocuments() do
	changeDocFrameBackground(document, true)
end

changeTheme(nil)
changeObjectCounters()
refreshCheckboxes()
