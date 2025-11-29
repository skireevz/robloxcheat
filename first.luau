local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Зберігаємо стан авто-фарму Blox Fruits
_G.BloxFruitsAutoFarm = false 
_G.Questing = false -- Чи зайнятий скрипт взяттям квесту/фармом

-- === ДОПОМІЖНІ ФУНКЦІЇ ===

--- Зберігає поточні налаштування під заданим ім'ям
local function SaveConfig(name)
    if name and name ~= "" then
        Rayfield:SaveConfiguration(name)
        Rayfield:Notify("Збережено", "Конфігурацію '" .. name .. "' збережено.", 5)
    else
        Rayfield:Notify("Помилка", "Будь ласка, введіть назву конфігурації для збереження.", 5)
    end
end

--- Завантажує налаштування за заданим ім'ям
local function LoadConfig(name)
    if name and name ~= "" then
        Rayfield:LoadConfiguration(name)
        Rayfield:Notify("Завантажено", "Конфігурацію '" .. name .. "' завантажено.", 5)
    else
        Rayfield:Notify("Помилка", "Будь ласка, введіть назву конфігурації для завантаження.", 5)
    end
end

-- Функція для пошуку найближчого моба
local function FindNearestMob(mobName)
    local nearestMob = nil
    local minDistance = math.huge
    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    for _, mob in ipairs(game.Workspace:GetChildren()) do
        -- Зміни 'Enemy' на те, як моб насправді називається в Workspace
        if mob.Name:find(mobName) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local distance = (mob.PrimaryPart.Position - playerPos).magnitude
            if distance < minDistance then
                minDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

-- ==================== СТВОРЕННЯ ВІКНА ====================

local Window = Rayfield:CreateWindow({
   Name = "Мій Чіт (Rayfield)",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true, 
      FolderName = "MyRayfieldConfig",
      FileName = "BigHub" 
   },
   KeySystem = false,
})

-- === БЕЗПЕКА ПРИ ЗАПУСКУ ===
pcall(function()
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end)

-- ==================== Вкладка ПЕРСОНАЖ ====================

local PlayerTab = Window:CreateTab("Персонаж", 4483362458) 

-- Слайдер Швидкості
local SpeedSlider = PlayerTab:CreateSlider({
   Name = "Швидкість (WalkSpeed)",
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

-- Слайдер Стрибка
local JumpSlider = PlayerTab:CreateSlider({
   Name = "Стрибок (JumpPower)",
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

-- Кнопка Noclip
local NoclipToggle = PlayerTab:CreateToggle({
   Name = "Noclip (Крізь стіни)",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
        _G.Noclip = Value
   end,
})

-- Логіка Noclip
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

-- ==================== Вкладка КОНФІГУРАЦІЇ ====================

local ConfigTab = Window:CreateTab("Конфігурації", 6071060965) 

local ConfigManager = ConfigTab:CreateConfig({
    Name = "Керування Конфігураціями" 
})

-- ==================== 🍇 Вкладка BLDX FRUITS ФАРМ 🍇 ====================

local BloxFruitsTab = Window:CreateTab("Blox Fruits", 6069006093) -- Іконка фрукта

-- Поле для назви NPC, що видає квест
local NPCBox = BloxFruitsTab:CreateTextBox({
   Name = "Назва NPC для квесту",
   Placeholder = "Введіть назву NPC (наприклад, 'Quest Giver')",
   Flag = "QuestNPCName",
   Callback = function(Value)
        _G.QuestNPCName = Value 
   end,
})

-- Перемикач Авто Фарм
local AutoFarmBFToggle = BloxFruitsTab:CreateToggle({
   Name = "Увімкнути Авто Фарм (Blox Fruits)",
   CurrentValue = false,
   Flag = "BloxFruitsAutoFarmToggle", 
   Callback = function(Value)
        _G.BloxFruitsAutoFarm = Value
   end,
})


-- ==================== ОСНОВНА ЛОГІКА АВТО ФАРМУ ====================

-- Цикл, який постійно перевіряє стан фарму
coroutine.wrap(function()
    while wait(1) do
        if _G.BloxFruitsAutoFarm and game.Players.LocalPlayer.Character and not _G.Questing then
            _G.Questing = true
            pcall(function()
                local LocalPlayer = game.Players.LocalPlayer
                local MyRoot = LocalPlayer.Character.HumanoidRootPart
                
                -- 1. ЗНАХОДИМО NPC
                local QuestNPC = game.Workspace:FindFirstChild(_G.QuestNPCName, true)

                if QuestNPC and QuestNPC.PrimaryPart then
                    
                    -- 2. ТЕЛЕПОРТ ДО NPC
                    MyRoot.CFrame = QuestNPC.PrimaryPart.CFrame * CFrame.new(0, 5, 5)
                    wait(0.5)

                    -- 3. ВЗЯТТЯ КВЕСТУ (ВАЖЛИВО: ЗМІНІТЬ ЦЕЙ КОД)
                    -- ЦЕ ЗАГЛУШКА! Вам потрібно знайти правильний RemoteEvent та його аргументи.
                    local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Ваш_Квест_RemoteEvent") 
                    if QuestRemote then
                         -- ПРИКЛАД: RemoteEvent:FireServer(АргументиКвесту)
                         QuestRemote:FireServer("StartQuest", "Bandit")
                         Rayfield:Notify("Квест", "Квест взято. Починаємо фарм...", 3)
                    else
                         Rayfield:Notify("Помилка", "Не знайдено RemoteEvent для квесту.", 5)
                    end

                    -- Отримуємо інформацію про ціль (якщо вдалося взяти квест)
                    -- У Blox Fruits інформація про ціль зазвичай зберігається у LocalPlayer.PlayerGui
                    local TargetMobName = "Bandit" -- Припустімо, що це "Bandit"
                    local MobsToKill = 10 
                    
                    -- 4. ФАРМ МОБІВ
                    for i = 1, MobsToKill do
                        if not _G.BloxFruitsAutoFarm then break end -- Якщо користувач вимкнув чит
                        
                        local Mob = FindNearestMob(TargetMobName)
                        if Mob and Mob.PrimaryPart then
                            -- Телепорт до моба
                            MyRoot.CFrame = Mob.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                            wait(0.1) -- Затримка, щоб уникнути кіку
                            
                            -- АТАКА (ВАЖЛИВО: ЗМІНІТЬ ЦЕЙ КОД)
                            -- Вам потрібно знайти RemoteEvent для вашої атаки (наприклад, фрукт чи меч)
                            local AttackRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Ваш_Атака_RemoteEvent")
                            if AttackRemote then
                                -- ПРИКЛАД: AttackRemote:FireServer("НазваАтаки", Mob)
                                AttackRemote:FireServer("SwordSkill1", Mob)
                            end
                            
                            wait(1.5) -- Обов'язкова затримка після атаки
                        else
                            Rayfield:Notify("Пошук", "Ціль '" .. TargetMobName .. "' не знайдено. Чекаю на респавн.", 3)
                            wait(5)
                        end
                    end
                    
                    -- 5. ПОВЕРНЕННЯ ДЛЯ ЗДАЧІ КВЕСТУ (опціонально, Blox Fruits часто здає авто)
                    -- MyRoot.CFrame = QuestNPC.PrimaryPart.CFrame * CFrame.new(0, 5, 5)
                    -- QuestRemote:FireServer("CompleteQuest")
                    
                else
                    Rayfield:Notify("Помилка", "Не знайдено NPC '" .. tostring(_G.QuestNPCName) .. "'", 5)
                end
                
            end)
            _G.Questing = false
        end
        wait(1)
    end
end)()
