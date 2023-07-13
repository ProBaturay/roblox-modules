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
			print(UIStroke:GetFullName())
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
					
					--local function getScale()
					--	return desiredThickness / determineLowerSize()
					--end

					local function update()
						print(UIStroke:GetFullName())

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
