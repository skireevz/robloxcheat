-- Завантаження Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= Global Flags =================
_G.BloxFruitsAutoFarm = false
_G.Questing = false
_G.QuestNPCName = ""
_G.Noclip = false

-- ================= Create Window =================
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

-- ================= Safety Check =================
pcall(function()
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end)

-- ================= TAB: PLAYER =================
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Speed Slider
PlayerTab:CreateSlider({
    Name = "Speed (WalkSpeed)",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        pcall(function()
            local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = Value
            end
        end)
    end,
})

-- Jump Slider
PlayerTab:CreateSlider({
    Name = "Jump (JumpPower)",
    Range = {50, 350},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "Slider2",
    Callback = function(Value)
        pcall(function()
            local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.JumpPower = Value
            end
        end)
    end,
})

-- Noclip Toggle
PlayerTab:CreateToggle({
    Name = "Noclip (Through Walls)",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.Noclip = Value
    end,
})

-- Noclip Logic
game:GetService("RunService").Stepped:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if _G.Noclip and character then
        pcall(function()
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    end
end)

-- ================= TAB: CONFIGS =================
local ConfigTab = Window:CreateTab("Configs", 6071060965)
ConfigTab:CreateConfig({
    Name = "Configuration Manager"
})

-- ================= TAB: AUTO FARM =================
local BloxFruitsTab = Window:CreateTab("Auto Farm", 6069006093)

-- NPC Name Input
BloxFruitsTab:CreateTextBox({
    Name = "Quest NPC Name",
    Placeholder = "Enter NPC name (e.g., 'Quest Giver')",
    Flag = "QuestNPCName",
    Callback = function(Value)
        _G.QuestNPCName = Value
    end,
})

-- Auto Farm Toggle
BloxFruitsTab:CreateToggle({
    Name = "Enable Auto Farm (Blox Fruits)",
    CurrentValue = false,
    Flag = "BloxFruitsAutoFarmToggle",
    Callback = function(Value)
        _G.BloxFruitsAutoFarm = Value
    end,
})

-- ================= Utility Functions =================
local function FindNearestMob(mobName)
    local nearestMob = nil
    local minDistance = math.huge
    local player = game.Players.LocalPlayer
    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return nil end

    for _, mob in ipairs(game.Workspace:GetChildren()) do
        if mob.Name:find(mobName) and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
            if mob.PrimaryPart then
                local distance = (mob.PrimaryPart.Position - playerRoot.Position).magnitude
                if distance < minDistance then
                    minDistance = distance
                    nearestMob = mob
                end
            end
        end
    end
    return nearestMob
end

-- ================= Main Auto Farm Loop =================
coroutine.wrap(function()
    while wait(1) do
        if _G.BloxFruitsAutoFarm and game.Players.LocalPlayer.Character then
            pcall(function()
                local LocalPlayer = game.Players.LocalPlayer
                local MyRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not MyRoot then return end

                -- Find Quest NPC
                local QuestNPC = game.Workspace:FindFirstChild(_G.QuestNPCName, true)
                if QuestNPC and QuestNPC.PrimaryPart then
                    -- Teleport to NPC
                    MyRoot.CFrame = QuestNPC.PrimaryPart.CFrame * CFrame.new(0, 5, 5)
                    wait(0.5)

                    -- RemoteEvent for quest (replace with correct RemoteEvent)
                    local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Your_Quest_RemoteEvent_Here")
                    if QuestRemote then
                        -- Example:
                        -- QuestRemote:FireServer("StartQuest", _G.QuestNPCName)
                        Rayfield:Notify("Quest", "Attempting to accept quest...", 1)
                    end

                    -- Farm Mobs (replace TargetMobName)
                    local TargetMobName = "Bandit" -- змінити на правильне ім'я моба
                    local MobsToKill = 10

                    for i = 1, MobsToKill do
                        if not _G.BloxFruitsAutoFarm then break end

                        local Mob = FindNearestMob(TargetMobName)
                        if Mob and Mob.PrimaryPart then
                            MyRoot.CFrame = Mob.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                            wait(0.1)

                            local AttackRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Your_Attack_RemoteEvent_Here")
                            if AttackRemote then
                                -- Example:
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

-- ================= Load Configuration =================
Rayfield:LoadConfiguration()
