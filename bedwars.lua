repeat wait() until game:IsLoaded()

--[[
    credits:
    Vape - Tables, some other stuff (below)
--]]

--Vapes Stuff | Only skidded part of the script btw

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
local function getremotev2(tab)
	for i,v in pairs(tab) do
		if v == "setLastAttackOnEveryHit" then
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
	["JuggernautAttackRemote"] = getremotev2(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])),
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
local Enabled = true

--End of the skidded stuff (mostly) lol

function notify(name, msg, timer)
    local ScreenGui = Instance.new("ScreenGui")
    local TextLabel = Instance.new("TextLabel")
    local TextLabel_2 = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TextLabel.Parent = ScreenGui
    TextLabel.BackgroundColor3 = Color3.fromRGB(90, 107, 255)
    TextLabel.Position = UDim2.new(0.803960383, 0, 0.906172812, 0)
    TextLabel.Size = UDim2.new(0, 297, 0, 76)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 14.000
    TextLabel.Text = name
    TextLabel_2.Parent = TextLabel
    TextLabel_2.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    TextLabel_2.Position = UDim2.new(0, 0, -0.407894731, 0)
    TextLabel_2.Size = UDim2.new(0, 297, 0, 31)
    TextLabel_2.Font = Enum.Font.SourceSans
    TextLabel_2.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel_2.TextSize = 14.000
    TextLabel_2.Text = msg
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = TextLabel_2
    UICorner_2.CornerRadius = UDim.new(0, 3)
    UICorner_2.Parent = TextLabel
    wait(timer)
    ScreenGui:Destroy()
end

local function chat(msg)
	local args = {
		[1] = msg,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("LiquidBounce", "Ocean")
local Combat = Window:NewTab("Combat")
local Movement = Window:NewTab("Movement")
local Visuals = Window:NewTab("Visuals")
local Utility = Window:NewTab("Utility")
local Scripts = Window:NewTab("Scripts")
local CombatSection = Combat:NewSection("Combat")
local MovementSection = Movement:NewSection("Movement")
local VisualsSection = Visuals:NewSection("Visuals")
local UtilitySection = Utility:NewSection("Utility")
local ScriptsSection = Scripts:NewSection("Scripts")

--Combat

CombatSection:NewToggle("Killaura", "Killaura", function(state)
    if state then
        local anims = { --Moon stuff that was probably helped by vape no cap
            Normal = {
                {CFrame = CFrame.new(1, -1, 2) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.25},
                {CFrame = CFrame.new(-1, 1, -2.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.25}
            },
        }
        local origC0 = cam.Viewmodel.RightHand.RightWrist.C0
        local ui2 = Instance.new("ScreenGui")
        local nearestID = nil
        ui2.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        target = nil
        repeat
                if not isalive(lplr) then
                    repeat wait() until isalive(lplr)
                end
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v ~= lplr then
                        nearestID = v
                        target = v.Name
                        if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude < 20 then
                            local sword = getSword()
                            if sword ~= nil then
                                bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
                                HitRemote:SendToServer({
                                    ["weapon"] = sword.tool,
                                    ["entityInstance"] = v.Character,
                                    ["validate"] = {
                                        ["raycast"] = {
                                            ["cameraPosition"] = hashFunc(cam.CFrame.Position),
                                            ["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, v.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
                                        },
                                        ["targetPosition"] = hashFunc(v.Character:FindFirstChild("HumanoidRootPart").Position),
                                        ["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, v.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
                                    },
                                    ["chargedAttack"] = {["chargeRatio"] = 0.8}
                                })
                            end
                        end
                    end
                end
            task.wait(0.12)
        until not Enabled
    else
        Enabled = false
    end
end)

CombatSection:NewToggle("Velocity", "Velocity", function(state)
    if state then
        KnockbackTable["kbDirectionStrength"] = 0
		KnockbackTable["kbUpwardStrength"] = 0
    else
        KnockbackTable["kbDirectionStrength"] = 100
		KnockbackTable["kbUpwardStrength"] = 100
    end
end)

--Movement

MovementSection:NewToggle("AcSpeed1", "CFrame lol", function(state)
    if state then
        local Speed = 0.22
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
        local Speed = 0.22
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
end)

MovementSection:NewToggle("AcSpeed2", "HeatSeeker lol", function(state)
    if state then
        _G.HeatSeeker = true

        while _G.HeatSeeker do
            lplr.Character.Humanoid.WalkSpeed = 120
            wait(0.05)
            lplr.Character.Humanoid.WalkSpeed = 0
            wait()
            lplr.Character.Humanoid.WalkSpeed = 16
            wait(0.8)
        end
    else
        _G.HeatSeeker = false
    end
end)

MovementSection:NewKeybind("Flight", "Flight", Enum.KeyCode.R, function()
	game.Workspace.Gravity = 0
    wait(2.4)
    game.Workspace.Gravity = 192.6
end)

MovementSection:NewKeybind("Longjump", "Longjump", Enum.KeyCode.J, function()
	lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.48)
    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.48)
    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.48)
    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.48)
    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

MovementSection:NewKeybind("Highjump", "Highjump", Enum.KeyCode.J, function()
	local Velocity = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
    Velocity.Name = "Velocity1"
    game.Workspace.Gravity = 0
    Velocity.Velocity = Vector3.new(0,500,0)
    wait(1.6)
    game.Workspace.Gravity = 192.6
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity1:Destroy()
end)

--Visuals

VisualsSection:NewKeybind("Toggle Ui", "Toggle Ui", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

VisualsSection:NewButton("Chams", "Chams", function()
    local players = game.Players:GetPlayers()

    for i,v in pairs(players) do
        esp = Instance.new("Highlight")
        esp.Name = v.Name
        esp.FillTransparency = 0.5
        esp.FillColor = Color3.new(0.368627, 0.345098, 1)
        esp.OutlineColor = Color3.new(0.258824, 0.517647, 1)
        esp.OutlineTransparency = 0
        esp.Parent = v.Character
    end
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(chr)
            local esp = Instance.new("Highlight")
            esp = Instance.new("Highlight")
            esp.Name = v.Name
            esp.FillTransparency = 0.5
            esp.FillColor = Color3.new(0.368627, 0.345098, 1)
            esp.OutlineColor = Color3.new(0.258824, 0.517647, 1)
            esp.OutlineTransparency = 0
            esp.Parent = v.Character
        end)
    end)
end)

VisualsSection:NewButton("Logo", "Logo", function()
    local Logo = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainFrame2 = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Logo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Logo
    MainFrame.BackgroundColor3 = Color3.fromRGB(90, 107, 255)
    MainFrame.Size = UDim2.new(0, 298, 0, 54)
    MainFrame2.Name = "MainFrame2"
    MainFrame2.Parent = MainFrame
    MainFrame2.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    MainFrame2.Size = UDim2.new(0, 298, 0, 44)
    TextLabel.Parent = MainFrame2
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Size = UDim2.new(0, 298, 0, 44)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "LiquidBounce | Beta | B1.0"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 30.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    while true do wait(3.4)
        if lplr.Character.Humanoid.health == 0 then
            wait(1)
            local Logo = Instance.new("ScreenGui")
            local MainFrame = Instance.new("Frame")
            local MainFrame2 = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            Logo.Name = "Logo"
            Logo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            Logo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            MainFrame.Name = "MainFrame"
            MainFrame.Parent = Logo
            MainFrame.BackgroundColor3 = Color3.fromRGB(90, 107, 255)
            MainFrame.Size = UDim2.new(0, 298, 0, 54)
            MainFrame2.Name = "MainFrame2"
            MainFrame2.Parent = MainFrame
            MainFrame2.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            MainFrame2.Size = UDim2.new(0, 298, 0, 44)
            TextLabel.Parent = MainFrame2
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Size = UDim2.new(0, 298, 0, 44)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "LiquidBounce | Beta | B1.0"
            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.TextSize = 30.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
end)

VisualsSection:NewButton("TabList", "TabList", function()
    local TabList = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Combat = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local Movement = Instance.new("TextLabel")
    local UICorner_2 = Instance.new("UICorner")
    local Visuals = Instance.new("TextLabel")
    local UICorner_3 = Instance.new("UICorner")
    local Utility = Instance.new("TextLabel")
    local UICorner_4 = Instance.new("UICorner")
    local Scripts = Instance.new("TextLabel")
    local UICorner_5 = Instance.new("UICorner")
    TabList.Name = "TabList"
    TabList.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TabList.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Frame.Parent = TabList
    Frame.BackgroundColor3 = Color3.fromRGB(90, 107, 255)
    Frame.Position = UDim2.new(0, 0, 0.0938271582, 0)
    Frame.Size = UDim2.new(0, 166, 0, 256)
    Combat.Name = "Combat"
    Combat.Parent = Frame
    Combat.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    Combat.Position = UDim2.new(0, 0, 0.0386082828, 0)
    Combat.Size = UDim2.new(0, 166, 0, 38)
    Combat.Font = Enum.Font.SourceSans
    Combat.Text = "Combat"
    Combat.TextColor3 = Color3.fromRGB(0, 0, 0)
    Combat.TextSize = 29.000
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = Combat
    Movement.Name = "Movement"
    Movement.Parent = Frame
    Movement.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    Movement.Position = UDim2.new(0, 0, 0.226004571, 0)
    Movement.Size = UDim2.new(0, 166, 0, 38)
    Movement.Font = Enum.Font.SourceSans
    Movement.Text = "Movement"
    Movement.TextColor3 = Color3.fromRGB(0, 0, 0)
    Movement.TextSize = 29.000
    UICorner_2.CornerRadius = UDim.new(0, 3)
    UICorner_2.Parent = Movement
    Visuals.Name = "Visuals"
    Visuals.Parent = Frame
    Visuals.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    Visuals.Position = UDim2.new(0, 0, 0.425638139, 0)
    Visuals.Size = UDim2.new(0, 166, 0, 38)
    Visuals.Font = Enum.Font.SourceSans
    Visuals.Text = "Visuals"
    Visuals.TextColor3 = Color3.fromRGB(0, 0, 0)
    Visuals.TextSize = 29.000
    UICorner_3.CornerRadius = UDim.new(0, 3)
    UICorner_3.Parent = Visuals
    Utility.Name = "Utility"
    Utility.Parent = Frame
    Utility.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    Utility.Position = UDim2.new(0, 0, 0.61562705, 0)
    Utility.Size = UDim2.new(0, 166, 0, 38)
    Utility.Font = Enum.Font.SourceSans
    Utility.Text = "Utility"
    Utility.TextColor3 = Color3.fromRGB(0, 0, 0)
    Utility.TextSize = 29.000
    UICorner_4.CornerRadius = UDim.new(0, 3)
    UICorner_4.Parent = Utility
    Scripts.Name = "Scripts"
    Scripts.Parent = Frame
    Scripts.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
    Scripts.Position = UDim2.new(0, 0, 0.8070333, 0)
    Scripts.Size = UDim2.new(0, 166, 0, 38)
    Scripts.Font = Enum.Font.SourceSans
    Scripts.Text = "Scripts"
    Scripts.TextColor3 = Color3.fromRGB(0, 0, 0)
    Scripts.TextSize = 29.000
    UICorner_5.CornerRadius = UDim.new(0, 3)
    UICorner_5.Parent = Scripts

    while true do wait(3.4)
        if lplr.Character.Humanoid.health == 0 then
            wait(1)
            local TabList = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            local Combat = Instance.new("TextLabel")
            local UICorner = Instance.new("UICorner")
            local Movement = Instance.new("TextLabel")
            local UICorner_2 = Instance.new("UICorner")
            local Visuals = Instance.new("TextLabel")
            local UICorner_3 = Instance.new("UICorner")
            local Utility = Instance.new("TextLabel")
            local UICorner_4 = Instance.new("UICorner")
            local Scripts = Instance.new("TextLabel")
            local UICorner_5 = Instance.new("UICorner")
            TabList.Name = "TabList"
            TabList.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            TabList.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            Frame.Parent = TabList
            Frame.BackgroundColor3 = Color3.fromRGB(90, 107, 255)
            Frame.Position = UDim2.new(0, 0, 0.0938271582, 0)
            Frame.Size = UDim2.new(0, 166, 0, 256)
            Combat.Name = "Combat"
            Combat.Parent = Frame
            Combat.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            Combat.Position = UDim2.new(0, 0, 0.0386082828, 0)
            Combat.Size = UDim2.new(0, 166, 0, 38)
            Combat.Font = Enum.Font.SourceSans
            Combat.Text = "Combat"
            Combat.TextColor3 = Color3.fromRGB(0, 0, 0)
            Combat.TextSize = 29.000
            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = Combat
            Movement.Name = "Movement"
            Movement.Parent = Frame
            Movement.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            Movement.Position = UDim2.new(0, 0, 0.226004571, 0)
            Movement.Size = UDim2.new(0, 166, 0, 38)
            Movement.Font = Enum.Font.SourceSans
            Movement.Text = "Movement"
            Movement.TextColor3 = Color3.fromRGB(0, 0, 0)
            Movement.TextSize = 29.000
            UICorner_2.CornerRadius = UDim.new(0, 3)
            UICorner_2.Parent = Movement
            Visuals.Name = "Visuals"
            Visuals.Parent = Frame
            Visuals.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            Visuals.Position = UDim2.new(0, 0, 0.425638139, 0)
            Visuals.Size = UDim2.new(0, 166, 0, 38)
            Visuals.Font = Enum.Font.SourceSans
            Visuals.Text = "Visuals"
            Visuals.TextColor3 = Color3.fromRGB(0, 0, 0)
            Visuals.TextSize = 29.000
            UICorner_3.CornerRadius = UDim.new(0, 3)
            UICorner_3.Parent = Visuals
            Utility.Name = "Utility"
            Utility.Parent = Frame
            Utility.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            Utility.Position = UDim2.new(0, 0, 0.61562705, 0)
            Utility.Size = UDim2.new(0, 166, 0, 38)
            Utility.Font = Enum.Font.SourceSans
            Utility.Text = "Utility"
            Utility.TextColor3 = Color3.fromRGB(0, 0, 0)
            Utility.TextSize = 29.000
            UICorner_4.CornerRadius = UDim.new(0, 3)
            UICorner_4.Parent = Utility
            Scripts.Name = "Scripts"
            Scripts.Parent = Frame
            Scripts.BackgroundColor3 = Color3.fromRGB(157, 175, 255)
            Scripts.Position = UDim2.new(0, 0, 0.8070333, 0)
            Scripts.Size = UDim2.new(0, 166, 0, 38)
            Scripts.Font = Enum.Font.SourceSans
            Scripts.Text = "Scripts"
            Scripts.TextColor3 = Color3.fromRGB(0, 0, 0)
            Scripts.TextSize = 29.000
            UICorner_5.CornerRadius = UDim.new(0, 3)
            UICorner_5.Parent = Scripts
        end
    end
end)

--Utility

--More vape stuff (i think)
local Distance = {["Value"] = 30}
function getbeds()
    local beds = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if string.lower(v.Name) == "bed" and v:FindFirstChild("Covers") ~= nil and v:FindFirstChild("Covers").Color ~= lplr.Team.TeamColor then
            table.insert(beds,v)
        end
    end
    return beds
end
function isalive(plr)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Head") then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    return true
end
function getserverpos(Position)
    local x = math.round(Position.X/3)
    local y = math.round(Position.Y/3)
    local z = math.round(Position.Z/3)
    return Vector3.new(x,y,z)
end

--end of it

UtilitySection:NewToggle("Bed Aura", "Bed Aura", function(state)
    if state then
        repeat
            task.wait(0.1)
            if isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 then
                local beds = getbeds()
                for i,v in pairs(beds) do
                    local mag = (v.Position - lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                    if mag < Distance["Value"] then
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DamageBlock:InvokeServer({
                            ["blockRef"] = {
                                ["blockPosition"] = getserverpos(v.Position)
                            },
                            ["hitPosition"] = getserverpos(v.Position),
                            ["hitNormal"] = getserverpos(v.Position)
                        })
                    end
                end
            end
        until not Enabled
    else
        Enabled = false
    end
end)

UtilitySection:NewToggle("Antivoid", "Antivoid", function(state)
    if state then
        local e = Instance.new("Part",workspace)
		e.Size = Vector3.new(99999999,2,999999999999)
		e.Position = Vector3.new(0,27,0)
		e.Anchored = true
		e.BrickColor = BrickColor.new("Royal purple")
		e.Transparency = 0.5


		local function PlayerTouched(Part)
			local Parent = Part.Parent
			if game.Players:GetPlayerFromCharacter(Parent) then
				for i = 1,3 do wait()
					Parent.HumanoidRootPart.CFrame = Parent.HumanoidRootPart.CFrame + Vector3.new(0,25,0)
				end

			end
		end

		e.Touched:connect(PlayerTouched)
    else
        e:Destroy()
    end
end)

UtilitySection:NewToggle("NoFall", "NoFall", function(state)
    if state then
        while true do
            wait()
            game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
        end
    else
        print("hi")
    end
end)

UtilitySection:NewSlider("Gravity", "Gravity", 192.6, 1, function(grav) -- 500 (MaxValue) | 0 (MinValue)
    game.Workspace.Gravity = grav
end)
