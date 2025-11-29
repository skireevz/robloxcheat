-- 1. Завантажуємо бібліотеку Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. Створюємо головне вікно
local Window = OrionLib:MakeWindow({
    Name = "Мій Супер Скрипт v2", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "MySuperConfig"
})

-- ==========================
-- Вкладка: ПЕРСОНАЖ (Player)
-- ==========================
local PlayerTab = Window:MakeTab({
	Name = "Персонаж",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Слайдер Швидкості    
PlayerTab:AddSlider({
	Name = "Швидкість бігу",
	Min = 16,
	Max = 300,
	Default = 16,
	Color = Color3.fromRGB(0, 255, 0),
	Increment = 1,
	ValueName = "шв.",
	Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
	end    
})

-- Слайдер Стрибка
PlayerTab:AddSlider({
	Name = "Сила стрибка",
	Min = 50,
	Max = 350,
	Default = 50,
	Color = Color3.fromRGB(0, 150, 255),
	Increment = 1,
	ValueName = "сила",
	Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end)
	end    
})

-- Noclip (Прохід крізь стіни)
local Noclip = false
local RunService = game:GetService("RunService")

PlayerTab:AddToggle({
	Name = "Noclip (Крізь стіни)",
	Default = false,
	Callback = function(Value)
		Noclip = Value
	end    
})

-- Логіка Noclip: постійно вимикаємо колізію, поки Noclip увімкнено
RunService.Stepped:Connect(function()
    if Noclip then
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

-- ==========================
-- Вкладка: ТЕЛЕПОРТ (Teleport)
-- ==========================
local TeleportTab = Window:MakeTab({
	Name = "Телепорт",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Отримуємо список гравців для меню
local playersTable = {}
for i, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        table.insert(playersTable, v.Name)
    end
end

-- Випадаюче меню (Dropdown) з гравцями
TeleportTab:AddDropdown({
	Name = "Телепорт до гравця",
	Default = "",
	Options = playersTable,
	Callback = function(Value)
        -- Код телепортації
        local targetPlayer = game.Players:FindFirstChild(Value)
        local localPlayer = game.Players.LocalPlayer
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        end
	end    
})

-- Кнопка оновлення списку гравців (якщо хтось зайшов/вийшов)
TeleportTab:AddButton({
	Name = "Оновити список гравців",
	Callback = function()
      	playersTable = {}
        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                table.insert(playersTable, v.Name)
            end
        end
        -- Примітка: Orion поки не дозволяє динамічно оновлювати Dropdown без перезавантаження UI,
        -- тому в простих скриптах це перезавантажує логіку, але для ідеалу треба перестворювати об'єкт.
        OrionLib:MakeNotification({
            Name = "Увага",
            Content = "Щоб побачити нових гравців, перезапустіть скрипт (це обмеження бібліотеки)",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
  	end    
})

-- Інструмент Click TP
TeleportTab:AddButton({
	Name = "Отримати Click TP Tool",
	Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        
        tool.Activated:Connect(function()
            local mouse = game.Players.LocalPlayer:GetMouse()
            local pos = mouse.Hit
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
            end)
        end)
        
        tool.Parent = game.Players.LocalPlayer.Backpack
        
        OrionLib:MakeNotification({
            Name = "Успіх!",
            Content = "Інструмент додано у твій інвентар.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
  	end    
})

-- 4. Запускаємо
OrionLib:Init()
