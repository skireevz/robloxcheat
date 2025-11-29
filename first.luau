local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === ДОПОМІЖНІ ФУНКЦІЇ ДЛЯ КОНФІГУРАЦІЇ ===
-- Ці функції використовують вбудовані методи Rayfield і додають сповіщення.
local function SaveConfig(name)
    if name and name ~= "" then
        Rayfield:SaveConfiguration(name)
        Rayfield:Notify("Збережено", "Конфігурацію '" .. name .. "' збережено.", 5)
    else
        Rayfield:Notify("Помилка", "Будь ласка, введіть назву конфігурації для збереження.", 5)
    end
end

local function LoadConfig(name)
    if name and name ~= "" then
        Rayfield:LoadConfiguration(name)
        Rayfield:Notify("Завантажено", "Конфігурацію '" .. name .. "' завантажено.", 5)
    else
        Rayfield:Notify("Помилка", "Будь ласка, введіть назву конфігурації для завантаження.", 5)
    end
end
-- ==========================================

-- ==================== СТВОРЕННЯ ВІКНА ====================

local Window = Rayfield:CreateWindow({
   Name = "Мій Чіт (Rayfield)",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true, -- Залишаємо true для ручного керування конфігами
      FolderName = "MyRayfieldConfig",
      FileName = "BigHub" 
   },
   KeySystem = false,
})

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

-- Використовуємо вбудований Rayfield Config Manager
local ConfigManager = ConfigTab:CreateConfig({
    Name = "Керування Конфігураціями" 
})

-- === БЕЗПЕКА ПРИ ЗАПУСКУ (НОВЕ) ===
-- Цей блок гарантує, що швидкість і стрибок встановлюються на стандартні значення (16 і 50) 
-- одразу після запуску скрипта, щоб запобігти кіку.
pcall(function()
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end)

-- !!! ВАЖЛИВО: Автоматичне завантаження конфігурації видалено !!!
-- Тепер налаштування за замовчуванням (16, 50, false) будуть активні при запуску.
-- Для завантаження збережених конфігів використовуйте вкладку "Конфігурації".
