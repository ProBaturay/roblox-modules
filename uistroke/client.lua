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
