-- library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jumpernaut/CodeHub/main/Library"))()

-- Racing
local race = "V1"
-- Hoops
local hoop = "V2"
-- Orb Farming
local optionSpeed = 0
local optionOrb = ""
local optionCity = ""
-- Rebirthing
local rebirthSuccessful = false
local pendingRebirthTp = ""
local selectedCity = ""
local rebtextfinal = ""
local rebamount = 0

-- services
local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GroupService = game:GetService("GroupService")

-- functions
local function teleportToBaseplate()
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(20, 2, 20)
    baseplate.Anchored = true
    baseplate.Position = Vector3.new(0, 2000, 0)
    baseplate.Parent = game.Workspace
    game.Players.LocalPlayer.Character:MoveTo(baseplate.Position)
end

local function teleportBack()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 0, 0))
end

game:GetService('ReplicatedStorage').raceInProgress.Changed:Connect(function()
	if _G.AR == true then		
		if game:GetService('ReplicatedStorage').raceInProgress.Value == true then
			game:GetService('ReplicatedStorage').rEvents.raceEvent:FireServer("joinRace")
		end
	end
end)

game:GetService('ReplicatedStorage').raceStarted.Changed:Connect(function()
	if _G.AR == true then
		if game:GetService('ReplicatedStorage').raceStarted.Value == true then
			for i, v in pairs(game:GetService('Workspace').raceMaps:GetChildren()) do
				local OldFinishPosition = v.finishPart.CFrame
				v.finishPart.CFrame = Player.Character.HumanoidRootPart.CFrame
				wait()
				v.finishPart.CFrame = OldFinishPosition
			end
		end
		wait(2)
	end
end)

-- window
local Window = Library:CreateWindow("CodeHub", "Legends Of Speed")

-- tabs
local Tab1 = Window:CreateTab("General")
local Tab2 = Window:CreateTab("Farming")
local Tab3 = Window:CreateTab("Teleporting")
local Tab4 = Window:CreateTab("Crystals")

-- general
Tab1:CreateSection("Race Farm")
Tab1:CreateDropdown("Race Type", {"Race V1","Race V2"}, function(ddrace)
    if ddrace == "Race V1" then
        race = "V1"
    elseif ddrace == "Race V2" then
        race = "V2"
    end
end)
Tab1:CreateToggle("Auto Racing", function(state)
	if state then 
	    if race == "V1" then
			_G.AR = true 
	    elseif race == "V2" then
	 _G.loop = true 
        while _G.loop do 
            wait()
            local args = {
               [1] = "joinRace"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("raceEvent"):FireServer(unpack(args))
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(48.3109131, 36.3147125, -8680.45312, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            wait(0.4)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1686.07495, 36.3147125, -5946.63428, -0.984812617, 0, 0.173621148, 0, 1, 0, -0.173621148, 0, -0.984812617)
            wait(0.4)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1001.33118, 36.3147125, -10986.2178, -0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, -0.996191859)
            wait(0.4)
        end 
	    end
	else 
		_G.AR = false 
		_G.loop = false 
	end
end)

Tab1:CreateSection("Hoop Farm")
Tab1:CreateDropdown("Hoop Type", {"Hoop V1","Hoop V2"}, function(ddhoop)
    if ddhoop == "Hoop V1" then
        hoop = "V1"
    elseif ddhoop == "Hoop V2" then
        hoop = "V2"
    end
end)
Tab1:CreateToggle("Auto Hoops", function(state)
	if state then 
	    if hoop == "V1" then
	        _G.loop = true 
            teleportToBaseplate()
        while _G.loop do 
            wait()
            for i,v in pairs(game:GetService("Workspace").Hoops:GetChildren()) do
                firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                wait()
                firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
            end
        end 
        elseif hoop == "V2" then
            _G.loop = true 
            teleportToBaseplate()
        while _G.loop do 
            wait()
            local children = workspace.Hoops:GetChildren()
                    for i, child in ipairs(children) do
                        if child.Name == "Hoop" then
                        child.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end    
                end
        end 
	    end
	else 
		_G.AR = false 
		_G.loop = false 
		teleportBack()
	end
end)
Tab1:CreateSection("Rebirth Farm")
Tab1:CreateBox("Rebirth Stopping Point", function(rebamountbb)
	rebamount = tonumber(rebamountbb) or 0
end)
Tab1:CreateToggle("Auto Rebirth", function(state)
    if state then 
        _G.loop = true
        while _G.loop do 
            wait()
            local success, err = pcall(function()
                local rebirthsBefore = game.Players.LocalPlayer.leaderstats.Rebirths.Value
                game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
                wait(0.5)
                local rebirthsAfter = game.Players.LocalPlayer.leaderstats.Rebirths.Value
                if rebirthsAfter > rebirthsBefore then
                    rebirthSuccessful = true
                    wait(0.7)
                    rebirthSuccessful = false
                end
                if rebirthsAfter >= rebamount then
                    _G.loop = false
                end
            end)
            if not success then
                _G.loop = false
            end
        end 
    else 
        _G.loop = false 
    end 
end)
Tab1:CreateToggle("Teleport After Rebirth", function(state)
    if state then 
        _G.loop = true 
        while _G.loop do 
            wait()
            if rebirthSuccessful then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11054.9688, 232.791656, 4898.62842, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
                wait(2)
                local x, y = getButtonCenter()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(x, y, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(x, y, 0, false, game, 1)
            end
        end 
    else 
        _G.loop = false 
    end
end)
Tab1:CreateSection("Miscellaneous")
Tab1:CreateToggle("Strengthen", function(state)
	if state then 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local newProperties = PhysicalProperties.new(30, 0.3, 0.5)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = newProperties
            end
        end
	else 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = nil
            end
        end
	end 
end)
Tab1:CreateBox("Enter FPS Cap", function(fpsamountbb)
        fpsamount = tonumber(fpsamountbb)
end)
Tab1:CreateButton("Apply FPS", function()
    RunService:Set3dRenderingEnabled(true)
    setfpscap(fpsamount)
end)

-- farming
Tab2:CreateSection("Orb Farm")
Tab2:CreateDropdown("Select Orb", {"Yellow Orb","Orange Orb","Blue Orb","Red Orb","Gem"}, function(ddmorbs)
    if ddmorbs == "Yellow Orb" then
        optionOrb = "Yellow Orb"
    elseif ddmorbs == "Orange Orb" then
        optionOrb = "Orange Orb"
    elseif ddmorbs == "Blue Orb" then
        optionOrb = "Blue Orb"
    elseif ddmorbs == "Red Orb" then
         optionOrb = "Red Orb"
     elseif ddmorbs == "Gem" then
         optionOrb = "Gem"
    end
end)
Tab2:CreateDropdown("Select City", {"City","Snow City","Magma City","Legends Highway","Space","Desert"}, function(ddmcities)
    if ddmcities == "City" then
        optionCity = "City"
    elseif ddmcities == "Snow City" then
        optionCity = "Snow City"
    elseif ddmcities == "Magma City" then
        optionCity = "Magma City"
    elseif ddmcities == "Legends Highway" then
         optionCity = "Legends Highway"
    elseif ddmcities == "Space" then
        optionCity = "Space"
    elseif ddmcities == "Desert" then
         optionCity = "Desert"
    end
end)
Tab2:CreateDropdown("Select Remote Multiplier", {"50 Orbs Per Remote","100 Orbs Per Remote","150 Orbs Per Remote","200 Orbs Per Remote","250 Orbs Per Remote"}, function(ddmspeed)
    if ddmspeed == "50 Orbs Per Remote" then
        optionSpeed = 50
    elseif ddmspeed == "100 Orbs Per Remoted" then
        optionSpeed = 100
    elseif ddmspeed == "150 Orbs Per Remote" then
        optionSpeed = 150
    elseif ddmspeed == "200 Orbs Per Remote" then
         optionSpeed = 200
	elseif ddmspeed == "250 Orbs Per Remote" then
		optionSpeed = 250
    end
end)
Tab2:CreateToggle("Auto Orb", function(state)
	if state then 
            _G.loop = true 
            while _G.loop do 
                for i = 1, optionSpeed do
                    game:GetService('ReplicatedStorage').rEvents.orbEvent:FireServer("collectOrb", optionOrb, optionCity)
                end
                wait(0.25)
            end 
    else 
        _G.loop = false 
    end
end)

-- teleporting
Tab3:CreateSection("City Destinations")
Tab3:CreateDropdown("Select Destination", {"City","Snow City","Magma City","Legends Highway","Space","Desert"}, function(ddtpplace)
    if ddtpplace == "City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9682.98828, 74.8522873, 3099.03394, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
    elseif ddtpplace == "Snow City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9676.13867, 74.8522873, 3782.69385, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    elseif ddtpplace == "Magma City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11054.9688, 232.791656, 4898.62842, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
    elseif ddtpplace == "Legends Highway" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13098.8711, 232.791656, 5907.62793, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
    elseif ddtpplace == "Space" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-331.764069, 5.45415115, 585.201721, -1.03712082e-05, 0.93968749, 0.34203434, -1, -1.03712082e-05, -1.81794167e-06, 1.81794167e-06, -0.34203434, 0.939687431)
    elseif ddtpplace == "Desert" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2519.90063, 15.7072296, 4355.74072, 1.69873238e-05, 0.93922013, 0.343315423, -0.99999994, 1.69873238e-05, 2.9951334e-06, -2.9951334e-06, -0.343315423, 0.93922019)
    end
end)

Tab3:CreateSection("Race Destinations")
Tab3:CreateDropdown("Select Destination", {"Desert","Magma","Grassland"}, function(ddtprace)
    if ddtprace == "Desert" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(48.3109131, 36.3147125, -8680.45312, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    elseif ddtprace == "Magma" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1001.33118, 36.3147125, -10986.2178, -0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, -0.996191859)
    elseif ddtprace == "Grassland" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1686.07495, 36.3147125, -5946.63428, -0.984812617, 0, 0.173621148, 0, 1, 0, -0.173621148, 0, -0.984812617)
    end
end)

Tab4:CreateSection("Crystal Farm")
Tab4:CreateToggle("Red Crystal",function(state)
    if state then 
        _G.loop = true 
        while _G.loop == true do wait() 
            local args = {
                [1] = "openCrystal",
                [2] = "Red Crystal"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
        end 
    else 
        _G.loop = false 
    end 
end)
Tab4:CreateToggle("Lightning Crystal",function(state)
    if state then 
        _G.loop = true 
        while _G.loop == true do wait() 
            local args = {
                [1] = "openCrystal",
                [2] = "Lightning Crystal"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
        end 
    else 
        _G.loop = false 
    end 
end)

Tab4:CreateToggle("Yellow Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Yellow Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Purple Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Purple Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Blue Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Blue Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Snow Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Snow Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Lava Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Lava Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Inferno Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Inferno Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Electro Legends Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Electro Legends Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateSection("Space Crystals")

Tab4:CreateToggle("Space Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Space Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Alien Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Alien Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateSection("Desert Crystals")

Tab4:CreateToggle("Desert Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Desert Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

Tab4:CreateToggle("Electro Crystal",function(state)
    if state then 
            _G.loop = true 
            while _G.loop == true do wait() 
               local args = {
    [1] = "openCrystal",
    [2] = "Electro Crystal"
}

game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer(unpack(args))
            end 
         else 
            _G.loop = false 
         end 
end)

--[[
Tab1:CreateLabel("Label Example")
Tab1:CreateSlider("Slider Example",10,120,function(value)
	print(value)
end)
Tab1:CreateButton("Button Example",function()
	print("works")
end)
Tab1:CreateBox("Box Example", function(input)
	print(input)
end)
Tab1:CreateToggle("Toggle Example", function(state)
	print(state)
end)
Tab1:CreateDropdown("Dropdown Example", {"Option 1","Option 2","Option 3"}, function(selected)
	print(selected)
end)
]]--
