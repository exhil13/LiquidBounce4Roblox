local function chat(msg)
	local args = {
		[1] = msg,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

end
local lplr = game.Players.LocalPlayer
local cam = game:GetService("Workspace").CurrentCamera
local uis = game:GetService("UserInputService")
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end
local repstorage = game:GetService("ReplicatedStorage")
local bedwars = {
	["DropItemRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
	["SprintController"] = KnitClient.Controllers.SprintController,
	["CombatConstant"] = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
	["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
	["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
	["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
	["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
	["SwordController"] = KnitClient.Controllers.SwordController,
	["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
	["ClientHandler"] = Client,
	["AppController"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
	["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
}
local canReturn = false
function getnearestplayer(maxdist)
	local obj = lplr
	local dist = math.huge
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and isalive(lplr) then
			local mag = (v.Character:WaitForChild("HumanoidRootPart").Position - lplr.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
			if (mag < dist) and (mag < maxdist) then
				dist = mag
				obj = v
			end
			if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and isalive(lplr) then
				canReturn = true
			end
		end
	end
	if canReturn then
		canReturn = false
		return obj
	end
end
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
function isalive(plr)
	plr = plr or lplr
	if not plr.Character then return false end
	if not plr.Character:FindFirstChild("Head") then return false end
	if not plr.Character:FindFirstChild("Humanoid") then return false end
	return true
end

local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsSwords
function hashFunc(vec) 
	return {value = vec}
end
local function GetInventory(plr)
	if not plr then 
		return {items = {}, armor = {}}
	end

	local suc, ret = pcall(function() 
		return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(plr)
	end)

	if not suc then 
		return {items = {}, armor = {}}
	end

	if plr.Character and plr.Character:FindFirstChild("InventoryFolder") then 
		local invFolder = plr.Character:FindFirstChild("InventoryFolder").Value
		if not invFolder then return ret end
		for i,v in next, ret do 
			for i2, v2 in next, v do 
				if typeof(v2) == 'table' and v2.itemType then
					v2.instance = invFolder:FindFirstChild(v2.itemType)
				end
			end
			if typeof(v) == 'table' and v.itemType then
				v.instance = invFolder:FindFirstChild(v.itemType)
			end
		end
	end

	return ret
end
local function getSword()
	local highest, returning = -9e9, nil
	for i,v in next, GetInventory(lplr).items do 
		local power = table.find(BedwarsSwords, v.itemType)
		if not power then continue end
		if power > highest then 
			returning = v
			highest = power
		end
	end
	return returning
end
local HitRemote = Client:Get(bedwars["SwordRemote"])
local Distance = {["Value"] = 18}
local Enabled = true

local uiCount = 0
local scriptName = "Moon"

local modules = {}

local states = {}

local installed = isfile(scriptName)
if not installed then
	makefolder(scriptName)
end
local userInput = game:GetService("UserInputService")


function newTab(name)
	uiCount += 1
	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Frame_2 = Instance.new("ScrollingFrame")
	Frame_2.Name = "Frame"
	Frame_2.ScrollBarThickness = 0
	Frame_2.BorderSizePixel = 0
	local UIGridLayout = Instance.new("UIListLayout")
	UIGridLayout.Name = "UIGridLayout"
	local TextLabel = Instance.new("TextLabel")
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = name
	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Frame.Position = UDim2.new(0.439486176*uiCount/2.7, 0, 0.301745594, 0)
	Frame.Size = UDim2.new(0, 157, 0, 400)

	UICorner.Parent = Frame

	Frame_2.Parent = Frame
	Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_2.BackgroundTransparency = 1.000
	Frame_2.Position = UDim2.new(0.0438880287*uiCount/2.7, 0, 0.154345199, 0)
	Frame_2.Size = UDim2.new(0, 163, 0, 303)

	UIGridLayout.Parent = Frame_2
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.Padding = UDim.new(0.0004,0,0,0)


	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0.0438881814*uiCount/2.7, 0, 0.0199366361, 0)
	TextLabel.Size = UDim2.new(0, 163, 0, 50)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 29.000
	TextLabel.Text = name
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	userInput.InputBegan:Connect(function(input,gameProcessed)
		if input.KeyCode == Enum.KeyCode.RightShift then
			local check = Frame_2
			local check2 = TextLabel
			local check3 = Frame
			if check.Visible == true then
				check.Visible = false
				check2.Visible = false
				check3.Visible = false
			elseif check.Visible == false then
				check.Visible = true
				check2.Visible = true
				check3.Visible = true
			end

		end
	end)
end

local windowapi = {}

windowapi["CreateButton"] = function(argstablemain)
	local buttonapi = {}
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()

	local bind = "nil"


	buttonapi["Name"] = argstablemain["Name"]
	buttonapi["Tab"] = argstablemain["Tab"]
	buttonapi["Function"] = argstablemain["Function"]
	--local enabled = isfile(buttonapi["Name"]..".txt")

	--if enabled then
	--table.insert(modules,buttonapi["Name"])
	--modules[buttonapi["Name"]] = true
	--bind = readfile(buttonapi["Name"]..".txt")
	--else
	--table.insert(modules,buttonapi["Name"])
	--modules[buttonapi["Name"]] = false
	--end

	local TextButton = Instance.new("TextButton")
	local UICorner_2 = Instance.new("UICorner")

	TextButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")[buttonapi["Tab"]].Frame.Frame
	TextButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
	TextButton.Size = UDim2.new(0, 150, 0, 60)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.Text = buttonapi["Name"]
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = 14.000
	mouse.KeyDown:connect(function(key)
		if key == bind then
			if buttonapi["Function"] ~= true then
				buttonapi["Function"] = true
				table.insert(states,argstablemain["Function"])
				states[buttonapi["Name"]] = true
				argstablemain["Function"](true)
				TextButton.BackgroundColor3 = Color3.fromRGB(150, 24, 222)
			else
				table.insert(states,argstablemain["Function"])
				states[buttonapi["Name"]] = false
				argstablemain["Function"](false)
				TextButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
				buttonapi["Function"] = false
			end
		end
	end)
	TextButton.MouseButton1Down:Connect(function()

		if buttonapi["Function"] ~= true then
			--if not enabled then

			--end
			table.insert(states,argstablemain["Function"])
			states[buttonapi["Name"]] = true
			buttonapi["Function"] = true
			TextButton.BackgroundColor3 = Color3.fromRGB(150, 24, 222)
		else
			table.insert(states,argstablemain["Function"])
			states[buttonapi["Name"]] = false
			TextButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
			buttonapi["Function"] = false
		end
		if buttonapi["Function"] ~= true then
			argstablemain["Function"](false)
		else
			argstablemain["Function"](true)
		end
	end)

	TextButton.MouseButton2Down:Connect(function()
		local ScreenGui = Instance.new("ScreenGui")
		local TextBox = Instance.new("TextBox")
		local UICorner = Instance.new("UICorner")

		--Properties:

		ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

		TextBox.Parent = ScreenGui
		TextBox.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		TextBox.BackgroundTransparency = 0.050
		TextBox.Position = UDim2.new(0.411009163, 0, 0.848780513, 0)
		TextBox.Size = UDim2.new(0, 290, 0, 47)
		TextBox.ZIndex = 99999
		TextBox.Font = Enum.Font.SourceSans
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.TextScaled = true
		TextBox.TextSize = 14.000
		TextBox.TextWrapped = true

		UICorner.Parent = TextBox
		TextBox.FocusLost:Connect(function()
			bind = TextBox.Text
			TextBox:Destroy()
			--if enabled then
			--delfile(buttonapi["Name"],scriptName)
			--writefile(buttonapi["Name"]..".txt",bind)
			--else
			--writefile(buttonapi["Name"]..".txt",bind)
			--end
		end)
	end)
	UICorner_2.Parent = TextButton
end

local function GetArgs(plr)
	return {
		[1] = {
			[1] = {
				[1] = "\18",
				[2] = game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name,
				[3] = "\1",
				[4] = CFrame.lookAt(game:GetService("Players").LocalPlayer.Character.PrimaryPart.Position,plr.Character.PrimaryPart.Position),
				[5] = workspace:GetPartBoundsInRadius(game:GetService("Players").LocalPlayer.Character.PrimaryPart.Position, 13)
			}
		}
	}
end

newTab("Combat")
newTab("Movement")
newTab("Visuals")
newTab("Utility")
local count = 0
local Killaura = windowapi.CreateButton({
	["Name"] = "Killaura",
	["Tab"] = "Combat",
	["Function"] = function(callback)
		if callback then
			local anims = {
				Normal = {
					{CFrame = CFrame.new(1, -1, 2) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.25},
					{CFrame = CFrame.new(-1, 1, -2.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.25}
				},
			}
			local origC0 = cam.Viewmodel.RightHand.RightWrist.C0
			repeat
				task.wait(0.12)
				local nearest = getnearestplayer(Distance["Value"])
				if nearest ~= nil and nearest.Team ~= lplr.Team and isalive(nearest) and nearest.Character:FindFirstChild("Humanoid").Health > 0.1 and isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 then
					local sword = getSword()
					spawn(function()
						for i,v in pairs(anims.Normal) do 
							local anim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(v.Time), {C0 = origC0 * v.CFrame})
							anim:Play()
							task.wait(v.Time+0.1)
							pcall(function()
								anim:Cancel()
							end)
							anim2 = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0})
							anim2:Play()
						end
						--local anim = Instance.new("Animation")
						--anim.AnimationId = "rbxassetid://4947108314"
						--local animator = lplr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
						--animator:LoadAnimation(anim):Play()
						--anim:Destroy()
						--bedwars["ViewmodelController"]:playAnimation(15)
						if sword ~= nil then
							bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
							HitRemote:SendToServer({
								["weapon"] = sword.tool,
								["entityInstance"] = nearest.Character,
								["validate"] = {
									["raycast"] = {
										["cameraPosition"] = hashFunc(cam.CFrame.Position),
										["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
									},
									["targetPosition"] = hashFunc(nearest.Character:FindFirstChild("HumanoidRootPart").Position),
									["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - nearest.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
								},
								["chargedAttack"] = {["chargeRatio"] = 0.6}
							})
						end
						
					end)
				end
			until not Enabled
		else
			Enabled = false
		end
	end,
})

local Velocity = windowapi.CreateButton({
	["Name"] = "Velocity",
	["Tab"] = "Combat",
	["Function"] = function(callback)
		if callback then
			KnockbackTable["kbDirectionStrength"] = 0
			KnockbackTable["kbUpwardStrength"] = 0
		else
			KnockbackTable["kbDirectionStrength"] = 100
			KnockbackTable["kbUpwardStrength"] = 100
		end
	end,
})

local CFrameSpeed = windowapi.CreateButton({
	["Name"] = "CFrameSpeed",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			local Speed = 0.1
			_G.Speed1 = true
			local You = game.Players.LocalPlayer.Name
			local UIS = game:GetService("UserInputService")
			while _G.Speed1 do wait()
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-Speed,0,0)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(Speed,0,0)
				end;
			end
		else
			local Speed = 0.1
			_G.Speed1 = false
			local You = game.Players.LocalPlayer.Name
			local UIS = game:GetService("UserInputService")
			while _G.Speed1 do wait()
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-Speed,0,0)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(Speed,0,0)
				end;
			end

		end
	end,
})

local longjumpenabled = nil
local LongJump = windowapi.CreateButton({
	["Name"] = "LongJump",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			longjumpenabled = true
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			game.Workspace.Gravity = 10
			for i = 1,66 do wait(0.01)
				if longjumpenabled then
					lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0,0.154,0)
				end
			end
		else
			game.Workspace.Gravity = 192.6
			longjumpenabled = false
		end
	end,
})

local HighJump = windowapi.CreateButton({
	["Name"] = "HighJump",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			game.Workspace.Gravity = 0
			lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,150,0)
		else
			game.Workspace.Gravity = 192.6
			lplr.Character.HumanoidRootPart.Velocity1:Destroy()
		end
	end,
})

local HighJumpV2 = windowapi.CreateButton({
	["Name"] = "VeloHighJump",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			local Velocity = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
			Velocity.Name = "Velocity1"
			game.Workspace.Gravity = 0
			Velocity.Velocity = Vector3.new(0,500,0)
		else
			game.Workspace.Gravity = 192.6
			game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity1:Destroy()
		end
	end,
})

local BedwarsFly = windowapi.CreateButton({
	["Name"] = "BedwarsFly",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			_G.BedwarsFly = true
			game.Workspace.Gravity = 0
			while _G.BedwarsFly == true do wait(0.2)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
				wait(0.9)
			end
		else
			_G.BedwarsFly = false
			
			while _G.BedwarsFly == true do wait(0.2)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.9
				wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.6
			end
			game.Workspace.Gravity = 192.6
		end
	end,
})

local isFlying = nil
local flytime = 2.6
local inverse = false
local status
Flight = windowapi.CreateButton({
	["Name"] = "Flight | New Fly Timer",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			isFlying = true
			workspace.Gravity = 0
			flytimer = Instance.new("ScreenGui")
			timer = Instance.new("TextLabel")
			UIS = game:GetService("UserInputService")
			repeat wait(0.1)
				flytime = flytime - 0.1
				if flytime <= 0.5 then
					status = "unsafe"
					timer.TextColor3 = Color3.fromRGB(255, 0, 4)
				else
					status = "safe"
					timer.TextColor3 = Color3.fromRGB(0, 255, 21)
				end

				if flytime > 0.5 and flytime < 1.4 then
					status = "safe"
					timer.TextColor3 = Color3.fromRGB(255, 225, 0)
				end
				flytimer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
				timer.Parent = flytimer
				timer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				timer.BackgroundTransparency = 1.000
				timer.Position = UDim2.new(0.499694198, 0, 0.486585349, 0)
				timer.Size = UDim2.new(0, 59, 0, 22)
				timer.Font = Enum.Font.SourceSans
				timer.Text = status
				timer.TextScaled = true
				timer.TextSize = 14.000
				timer.TextWrapped = true
			until not isFlying
		else
			timer.TextTransparency = 1
			flytime = 2.6
			isFlying = false
			workspace.Gravity = 196.2	
		end
	end,
})

local FunnyFly = windowapi.CreateButton({
	["Name"] = "FunnyFly",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			_G.Velo = true

			while _G.Velo do
				game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = game.Players.LocalPlayer.character.HumanoidRootPart.Velocity + Vector3.new(0,40,0)
				wait(0.2)
			end
		else
			_G.Velo = false

			while _G.Velo do
				game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = game.Players.LocalPlayer.character.HumanoidRootPart.Velocity + Vector3.new(0,40,0)
				wait(0.2)
			end
		end
	end,
})

local FunnyModeEnabled = nil
local FunnyMode = windowapi.CreateButton({
	["Name"] = "FunnyMode | New",
	["Tab"] = "Visuals",
	["Function"] = function(callback)
		if callback then
			FunnyModeEnabled = true
			damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
			damagetab.strokeThickness = 12
			damagetab.textSize = 28
			damagetab.blowUpDuration = 1
			damagetab.blowUpSize = 999999
		else
			damagetab.strokeThickness = 1.5
			damagetab.textSize = 28
			damagetab.blowUpDuration = 0.125
			damagetab.blowUpSize = 76
		end
	end,
})

local Chams = windowapi.CreateButton({
	["Name"] = "Chams",
	["Tab"] = "Visuals",
	["Function"] = function(callback)
		if callback then
			local players = game.Players:GetPlayers()

			for i,v in pairs(players) do
				esp = Instance.new("Highlight")
				esp.Name = v.Name
				esp.FillTransparency = 0.5
				esp.FillColor = Color3.new(1, 0, 1)
				esp.OutlineColor = Color3.new(1, 0, 1)
				esp.OutlineTransparency = 0
				esp.Parent = v.Character
			end
		else
			esp:Destroy()
		end
	end,
})

local NoFall = windowapi.CreateButton({
	["Name"] = "NoFall",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			while true do wait()
				game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
			end
		else
			print("cope")
		end
	end,
})
local isSprinting = nil
local Sprint = windowapi.CreateButton({
	["Name"] = "Sprint",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			isSprinting = true
			repeat wait()
				if (not bedwars["SprintController"].sprinting) then
					bedwars["SprintController"]:startSprinting()
				end
			until not isSprinting
		else
			isSprinting = false
		end
	end,
})
local AntivoidEnabled = nil
local AntiVoid = windowapi.CreateButton({
	["Name"] = "AntiVoid",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			AntivoidEnabled = true
			repeat wait()
				if lplr.Character.HumanoidRootPart.Position.Y < 10 then
					local e = Instance.new("BodyVelocity",lplr.Character.HumanoidRootPart)
					workspace.Gravity = 0
					e.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X,130,lplr.Character.HumanoidRootPart.Velocity.Z)
					task.wait(0.5)
					e:Destroy()
					workspace.Gravity = 196.2
				end
			until not AntivoidEnabled
		else
			AntivoidEnabled = false
		end
	end,
})

local stealerEnabled = nil
local Stealer = windowapi.CreateButton({
	["Name"] = "Stealer",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			stealerEnabled = true
			repeat wait()
				if bedwars["AppController"]:isAppOpen("ChestApp") then
					local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
					local items = chest and chest.Value and chest.Value:GetChildren() or {}
					if #items > 0 then
						for itemNumber,Item in pairs(items) do
							if Item:IsA("Accessory") then
								task.spawn(function()
									pcall(function()
										bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(chest.Value, Item)
									end)
								end)
							end
						end
					end
				end
			until not stealerEnabled
		else
			stealerEnabled = false
		end
	end,
})

local NoBob = windowapi.CreateButton({
	["Name"] = "NoBob",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(25 / 10))
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (8 / 10))
		else
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(8 / 10))
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (8 / 10))
		end
	end,
})

AutoToxicEnabled = nil
local AutoToxic = windowapi.CreateButton({
	["Name"] = "AutoToxic",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			AutoToxicEnabled = true
			local vals = {}
			repeat task.wait(5)
				for _,v in pairs( game.Players:GetPlayers()) do
					if (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude < 15 then
						table.insert(vals,v.Name)
					end
					for i,z in pairs(vals) do
						if v.Name == z then
							table.clear(vals)
							local pick = math.random(1,3)
							if pick == 1 then
								chat("L"..v.Name.." Looks like you forgot to get moon.")
							elseif pick == 2 then
								chat(v.Name.." do you eat losses for breakfast?")
							elseif pick == 3 then
								chat("Moon is sponsored by edp445, "..v.Name.." L.")
							end
						end
					end
				end	
			until not AutoToxicEnabled
		else
			AutoToxicEnabled = false
		end
	end,
})

--[[for _,v in pairs(states) do
	if v == true then
		v()
	end
end--]]

function AddTag(plr, tag, color)
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Plr = plr
	local ChatTag = {}
	ChatTag[Plr] =
		{
			TagText = tag, --Text
			TagColor = color, --Rgb
			NameColor = color
		}



	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}

	--// Chat Listener
	for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
		if
			v.Function
			and #debug.getupvalues(v.Function) > 0
			and type(debug.getupvalues(v.Function)[1]) == "table"
			and getmetatable(debug.getupvalues(v.Function)[1])
			and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
		then
			oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
			oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
			getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
				local tab = oldchannelfunc(Self, Name)
				if tab and tab.AddMessageToChannel then
					local addmessage = tab.AddMessageToChannel
					if oldchanneltabs[tab] == nil then
						oldchanneltabs[tab] = tab.AddMessageToChannel
					end
					tab.AddMessageToChannel = function(Self2, MessageData)
						if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
							if ChatTag[Players[MessageData.FromSpeaker].Name] then
								MessageData.ExtraData = {
									NameColor = ChatTag[Players[MessageData.FromSpeaker].Name].NameColor
										or Players[MessageData.FromSpeaker].TeamColor.Color,
									Tags = {
										table.unpack(MessageData.ExtraData.Tags),
										{
											TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
											TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
										},
									},
								}
							end
						end
						return addmessage(Self2, MessageData)
					end
				end
				return tab
			end
		end
	end
end

AddTag("bedwarsisbedwars_6 ","Moon Owner", Color3.fromRGB(255, 0, 0))
AddTag("mymomisstinky5333","Moon Beta", Color3.fromRGB(77, 255, 0))
AddTag("ewfwefdfewfdwefdw","Head Moon Dev", Color3.fromRGB(77, 255, 0))
AddTag("thisaccountajokeIS","Head Moon Dev", Color3.fromRGB(77, 255, 0))
AddTag("PrismUserz","NightBed Owner", Color3.fromRGB(77, 255, 0))
AddTag("Monia_9266","NightBed Owner", Color3.fromRGB(77, 255, 0))
AddTag("noboline_w","NightBed Owner", Color3.fromRGB(77, 255, 0))
