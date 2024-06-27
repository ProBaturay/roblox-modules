--Created 00:41 23/06/24 DD:MM:YY +3

local pluginName = "Template"
local widgetId = "385026300-Template"
local testing = false

local toolbarButtonBottomText = ""
local toolbarButtonHoverText = ""
local toolbarButtonImage = "" 

local interruptIfRunning = true
local testActive = false
local AUTO_PLUGIN = "Auto"

local RunService = game:GetService("RunService")
local StudioService = game:GetService("StudioService")
local PluginGuiService = game:GetService("PluginGuiService")
local MarketplaceService = game:GetService("MarketplaceService")

local ThemeButton: TextButton = nil

-- If a server is created, interrupt.
if RunService:IsRunning() and interruptIfRunning then
	return
end

for i, PluginGui in PluginGuiService:GetChildren() do
	local createdBy = PluginGui:GetAttribute("CreatedBy")

	if createdBy and createdBy == 385026300 and PluginGui.Name == pluginName then
		pluginName = pluginName .. " (Local)"
		testing = true
	end
end

local plugin: Plugin = plugin or getfenv().PluginManager():CreatePlugin()
plugin.Name = pluginName

local toolbar: PluginToolbar = plugin:CreateToolbar(pluginName)

local toolbarButton: PluginToolbarButton = toolbar:CreateButton(toolbarButtonBottomText, toolbarButtonHoverText, toolbarButtonImage)
toolbarButton.ClickableWhenViewportHidden = true

local dockWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	340,
	600,
	300,
	300
)

local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui(
	widgetId,
	dockWidgetInfo
)

widget.ResetOnSpawn = false
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widget.Title = pluginName
widget.Name = pluginName
widget:SetAttribute("CreatedBy", 385026300)

toolbarButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

local productInfo = nil
local activateUpdateInfo = false
local lastUpdate = plugin:GetSetting("LastUpdated")

pcall(function()
	productInfo = MarketplaceService:GetProductInfo(14193928464)
end)

if productInfo then
	if not ((lastUpdate == nil or type(lastUpdate) ~= "string")) then
		if lastUpdate ~= productInfo.Updated then
			activateUpdateInfo = true
		end
	end

	plugin:SetSetting("LastUpdated", productInfo.Updated)
end

if activateUpdateInfo and not testing then
	local UpdateLabel = Instance.new("TextLabel")
	UpdateLabel.Name = "UpdateLabel"
	UpdateLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	UpdateLabel.Size = UDim2.new(1, -10, 1, -10)
	UpdateLabel.BackgroundTransparency = 1
	UpdateLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	UpdateLabel.BorderSizePixel = 0
	UpdateLabel.LayoutOrder = 10000
	UpdateLabel.ZIndex = 10000
	UpdateLabel.FontSize = Enum.FontSize.Size12
	UpdateLabel.TextTruncate = Enum.TextTruncate.AtEnd
	UpdateLabel.TextSize = 12
	UpdateLabel.RichText = true
	UpdateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	UpdateLabel.Text = "\u{26a0} Please install the new update via the Plugins tab or the Toolbox menu."
	UpdateLabel.TextWrapped = true
	UpdateLabel.Font = Enum.Font.GothamBold
	UpdateLabel.Parent = widget

	return
end

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	toolbarButton:SetActive(widget.Enabled)
end)

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
		["ScrollBar"] = Color3.fromRGB(29, 29, 29),
		["Stroke"] = Color3.fromRGB(10, 10, 10)
	},
	["Light"] = {
		["Background"] = Color3.fromRGB(255, 255, 255),
		["FrameBackground"] = Color3.fromRGB(242, 242, 242),
		["Button"] = Color3.fromRGB(219, 219, 219),
		["ScrollBar"] = Color3.fromRGB(240, 240, 240),
		["Stroke"] = Color3.fromRGB(200, 200, 200)
	},
}

local SettingsFolder = Instance.new("Folder")
SettingsFolder.Name = "Settings"
SettingsFolder.Parent = plugin

local Plugin = Instance.new("Folder")
Plugin.Name = "PluginValue"
Plugin.Parent = SettingsFolder

local ThemeValue = Instance.new("StringValue")
ThemeValue.Name = "ThemeValue"
ThemeValue.Parent = Plugin

local function table_nextone<v>(tab: {[any]: v}, index: number): v
	if #tab == index then
		return tab[1]
	else
		return tab[index + 1]
	end
end

local function retrieveAllSettings()
	return {
		Plugin = {
			Theme = {
				[1] = AUTO_PLUGIN,
				[2] = "Light",
				[3] = "Dark"
			}
		},
		Booleans = {
			ShowWarnings = true
		},
	}
end

local function forEachDescendantOf(object, func)
	for i, descendant in object:GetDescendants() do
		func(descendant)
	end
end

local function forEachSettingValue(func)
	forEachDescendantOf(SettingsFolder, function(value: nValueBase)
		if value:IsA("ValueBase") then
			func(value)
		end
	end)
end

local function RGBToString(color3: Color3, round: boolean?)
	local r = if round then math.round(color3.R * 255) elseif round == false then color3.R * 255 else math.round(color3.R * 255)
	local g = if round then math.round(color3.G * 255) elseif round == false then color3.G * 255 else math.round(color3.G * 255)
	local b = if round then math.round(color3.B * 255) elseif round == false then color3.B * 255 else math.round(color3.B * 255)

	return r .. ", " .. g .. ", " .. b
end

local function stringToRGB(str: string)
	local tab = string.split(str, ",")

	return Color3.fromRGB(tonumber(tab[1]), tonumber(tab[2]), tonumber(tab[3]))
end

local function getStudioTheme()
	return (settings().Studio.Theme :: Instance).Name
end

local currentTheme = "Dark"

local function changeTheme(theme: string?)	
	if not theme then
		theme = getStudioTheme()
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

local function setTheme(val)
	ThemeButton.Text = if ThemeButton.Text ~= "Auto" then val else "Auto"
	changeTheme(if val == "Auto" then getStudioTheme() else val)
end

settings().Studio.ThemeChanged:Connect(function()
	local theme = settings().Studio.Theme :: Instance

	changeTheme(theme.Name)
end)

local themeBeingSet = false

ThemeButton.Activated:Connect(function()
	themeBeingSet = true

	local value = ThemeValue.Value
	local stngs = retrieveAllSettings().Plugin.Theme

	local newValue = table_nextone(stngs, table.find(stngs, value) :: number)
	ThemeValue.Value = newValue
	ThemeButton.Text = newValue

	if newValue == "Auto" then
		newValue = getStudioTheme()
	end

	setTheme(newValue)

	themeBeingSet = false
end)

ThemeValue.Changed:Connect(function(newVal)
	if not themeBeingSet then
		setTheme(newVal)
	end
end)

for i, settingsValue: nValueBase in SettingsFolder:GetDescendants() do
	if settingsValue:IsA("ValueBase") then
		settingsValue.Changed:Connect(function()			
			local valueToSet = settingsValue.Value

			plugin:SetSetting(settingsValue.Name, valueToSet)
		end)
	end
end

local settingsSaved = plugin:GetSetting("SettingsSaved")

if not settingsSaved or testActive then
	plugin:SetSetting("SettingsSaved", true)

	ThemeValue.Value = AUTO_PLUGIN
else
	forEachSettingValue(function(value)
		local s, e = pcall(function()
			local setting = plugin:GetSetting(value.Name)

			value.Value = setting
		end)
	end)
end

changeTheme(nil)
