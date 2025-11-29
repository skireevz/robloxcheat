-- 1. Завантажуємо бібліотеку Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. Створюємо вікно меню
local Window = OrionLib:MakeWindow({
    Name = "Мій Скрипт (Speed & Jump)", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "MyConfig"
})

-- 3. Створюємо вкладку "Player"
local PlayerTab = Window:MakeTab({
	Name = "Персонаж",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- === СЛАЙДЕР ШВИДКОСТІ ===
PlayerTab:AddSlider({
	Name = "Швидкість бігу (WalkSpeed)",
	Min = 16,   -- Мінімальна швидкість (стандартна)
	Max = 300,  -- Максимальна швидкість
	Default = 16,
	Color = Color3.fromRGB(0, 255, 0), -- Зелений колір
	Increment = 1,
	ValueName = "шв.",
	Callback = function(Value)
        -- Ця функція спрацьовує, коли ти рухаєш повзунок
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
		    player.Character.Humanoid.WalkSpeed = Value
        end
	end    
})

-- === СЛАЙДЕР СТРИБКА ===
PlayerTab:AddSlider({
	Name = "Сила стрибка (JumpPower)",
	Min = 50,   -- Мінімальний стрибок (стандартний)
	Max = 350,  -- Максимальний стрибок
	Default = 50,
	Color = Color3.fromRGB(0, 150, 255), -- Синій колір
	Increment = 1,
	ValueName = "сила",
	Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
		    player.Character.Humanoid.JumpPower = Value
        end
	end    
})

-- 4. Запускаємо бібліотеку
OrionLib:Init()