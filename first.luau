local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Global flags for Auto Farm
_G.BloxFruitsAutoFarm = false 
_G.Questing = false 
_G.QuestNPCName = "" 
_G.Noclip = false

local Window = Rayfield:CreateWindow({
   Name = "My Cheat Hub (Fixed)",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true, 
      FolderName = "MyRayfieldConfig",
      FileName = "BigHub" 
   },
   KeySystem = false,
})

-- === SAFETY CHECK: Apply initial safe values ===
pcall(function()
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end)

-- ==================== TAB: PLAYER ====================

local PlayerTab = Window:CreateTab("Player", 4483362458) 

-- Speed Slider
local SpeedSlider = PlayerTab:CreateSlider({
   Name = "Speed (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", 
   Callback = function(Value)
        pcall(function()
             game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
   end,
})

-- Jump Slider
local JumpSlider = PlayerTab:CreateSlider({
   Name = "Jump (JumpPower)",
   Range = {50, 350},
   Increment = 1,
   Suffix = "Jump",
   CurrentValue = 50,
   Flag = "Slider2", 
   Callback = function(Value)
        pcall(function()
             game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end)
   end,
})

-- Noclip Toggle
local NoclipToggle = PlayerTab:CreateToggle({
   Name = "Noclip (Through Walls)",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
        _G.Noclip = Value
   end,
})

-- Noclip Logic
game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip then
        pcall(function()
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    end
end)

---
## Configuration and Auto Farm Tabs
---

-- ==================== TAB: CONFIGS ====================

local ConfigTab = Window:CreateTab("Configs", 6071060965) 

local ConfigManager = ConfigTab:CreateConfig({
    Name = "Configuration Manager" 
})

-- ==================== TAB: AUTO FARM (Requires RemoteEvents!) ====================

local BloxFruitsTab = Window:CreateTab("Auto Farm", 6069006093) 

-- NPC Name Input
local NPCBox = BloxFruitsTab:CreateTextBox({
   Name = "Quest NPC Name",
   Placeholder = "Enter NPC name (e.g., 'Quest Giver')",
   Flag = "QuestNPCName",
   Callback = function(Value)
        _G.QuestNPCName = Value 
   end,
})

-- Auto Farm Toggle
local AutoFarmToggle = BloxFruitsTab:CreateToggle({
   Name = "Enable Auto Farm (Blox Fruits)",
   CurrentValue = false,
   Flag = "BloxFruitsAutoFarmToggle", 
   Callback = function(Value)
        _G.BloxFruitsAutoFarm = Value
   end,
})

-- Function to find nearest mob (Utility for Auto Farm)
local function FindNearestMob(mobName)
    local nearestMob = nil
    local minDistance = math.huge
    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    for _, mob in ipairs(game.Workspace:GetChildren()) do
        if mob.Name:find(mobName) and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
            local distance = (mob.PrimaryPart.Position - playerPos).magnitude
            if distance < minDistance then
                minDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

-- MAIN AUTO FARM LOGIC (Still uses placeholders!)
coroutine.wrap(function()
    while wait(1) do
        if _G.BloxFruitsAutoFarm and game.Players.LocalPlayer.Character then
            -- We don't use the questing flag here to keep the main loop simple, 
            -- rely on the 1-second wait and user interaction.
            
            pcall(function()
                local LocalPlayer = game.Players.LocalPlayer
                local MyRoot = LocalPlayer.Character.HumanoidRootPart
                
                -- 1. Check if NPC name is set and try to find it
                local QuestNPC = game.Workspace:FindFirstChild(_G.QuestNPCName, true)

                if QuestNPC and QuestNPC.PrimaryPart then
                    
                    -- 2. TELEPORT TO NPC & QUEST ACCEPT (PLACEHOLDER)
                    MyRoot.CFrame = QuestNPC.PrimaryPart.CFrame * CFrame.new(0, 5, 5)
                    wait(0.5)

                    -- *** REPLACE THIS WITH ACTUAL QUEST REMOTE CALL ***
                    local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Your_Quest_RemoteEvent_Here") 
                    if QuestRemote then
                         -- Example: QuestRemote:FireServer(Arguments)
                         -- QuestRemote:FireServer("StartQuest", "Bandit")
                         Rayfield:Notify("Quest", "Attempting to accept quest...", 1)
                    end
                    
                    -- 3. FARM MOBS (PLACEHOLDER)
                    local TargetMobName = "Bandit" -- Change this to the target mob name
                    local MobsToKill = 10 
                    
                    for i = 1, MobsToKill do
                        if not _G.BloxFruitsAutoFarm then break end 
                        
                        local Mob = FindNearestMob(TargetMobName)
                        if Mob and Mob.PrimaryPart then
                            MyRoot.CFrame = Mob.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                            wait(0.1) 
                            
                            -- *** REPLACE THIS WITH ACTUAL ATTACK REMOTE CALL ***
                            local AttackRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Your_Attack_RemoteEvent_Here")
                            if AttackRemote then
                                -- AttackRemote:FireServer("SwordSkill1", Mob)
                                Rayfield:Notify("Farm", "Attacking " .. Mob.Name, 0.5)
                            end
                            
                            wait(1.5) 
                        else
                            wait(5)
                        end
                    end
                    
                else
                    Rayfield:Notify("Error", "NPC name not set or NPC not found.", 1)
                end
                
            end)
        end
        wait(1)
    end
end)()

Rayfield:LoadConfiguration()
