function notify(msg)
	for i,v in pairs(game.Players.LocalPlayer:WaitForChild("PlayerGui").Notifications:GetChildren()) do
		v:Destroy()
	end
	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local top = Instance.new("Frame")

	--Properties:

	

	ScreenGui.Parent = Notifications

	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.850764513, 0, 0.871951222, 0)
	Frame.Size = UDim2.new(0, 244, 0, 67)

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0, 0, 0.179104477, 0)
	TextLabel.Size = UDim2.new(0, 244, 0, 55)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true
	TextLabel.Text = msg

	top.Name = "top"
	top.Parent = ScreenGui
	top.BackgroundColor3 = Color3.fromRGB(196, 0, 231)
	top.BorderSizePixel = 0
	top.Position = UDim2.new(0.850764513, 0, 0.871951222, 0)
	top.Size = UDim2.new(0, 244, 0, 12)
	top.ZIndex = 2
	task.wait(1.2)
	ScreenGui:Destroy()
end
