local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Мій Чіт (Rayfield)",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true, -- Залишаємо true, щоб працювали конфігурації
      FolderName = "MyRayfieldConfig",
      FileName = "BigHub" -- Це основний файл, який завантажується автоматично
   },
   KeySystem = false,
})

-- ==================== Вкладка ПЕРСОНАЖ ====================

local PlayerTab = Window:CreateTab("Персонаж", 4483362458) -- Іконка

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

-- ==================== Вкладка КОНФІГУРАЦІЇ (НОВА) ====================

local ConfigTab = Window:CreateTab("Конфігурації", 6071060965) -- Іконка шестерні для налаштувань

-- Створення елементу управління конфігураціями
-- Цей елемент автоматично додає: 
-- 1. Випадаючий список збережених конфігів.
-- 2. Поле для введення назви нового конфіга.
-- 3. Кнопки "Зберегти", "Завантажити" та "Видалити".
local ConfigManager = ConfigTab:CreateConfig({
    Name = "Керування Конфігураціями" 
})

-- Завантажує останню використану конфігурацію при запуску
Rayfield:LoadConfiguration()
