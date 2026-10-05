local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==================================================
-- TEMA PERSONALIZADO "MOUNX" POR DEFECTO
-- ==================================================
-- Puedes cambiar estos colores cuando quieras
Library.AccentColor = Color3.fromRGB(168, 85, 247) -- Morado Mounx
Library.MainColor = Color3.fromRGB(20, 20, 25) -- Fondo oscuro elegante
Library.FontColor = Color3.fromRGB(255, 255, 255)

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

-- ==================================================
-- CONSTRUCTOR AUTOMÁTICO DE SETTINGS Y MOBILE
-- ==================================================
function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    -- 1. CREAR MENÚ DE KEYBIND Y UNLOAD
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Cerrar')
    
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Options.MenuKeybind
    
    -- 2. CONFIGURAR THEME Y SAVE MANAGER
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:BuildThemeSection(SettingsTab)
    
    -- 3. INYECTAR ADAPTADOR MÓVIL AUTOMÁTICAMENTE
    local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    if isMobile then
        local LP = game:GetService("Players").LocalPlayer
        local camera = workspace.CurrentCamera
        
        -- Auto-Escalado para pantallas de celular
        if Library.ScreenGui then
            local uiScale = Instance.new("UIScale")
            uiScale.Parent = Library.ScreenGui
            local function updateScale()
                local vpY = camera.ViewportSize.Y
                if vpY < 650 then uiScale.Scale = math.clamp(vpY / 700, 0.55, 1) else uiScale.Scale = 1 end
            end
            updateScale()
            camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
        end

        -- Botón flotante Mounx
        local toggleGui = Instance.new("ScreenGui")
        toggleGui.Name = "MounxMobileToggle"
        toggleGui.ResetOnSpawn = false
        
        local success = pcall(function() toggleGui.Parent = gethui() end)
        if not success then toggleGui.Parent = LP:WaitForChild("PlayerGui") end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 48)
        btn.Position = UDim2.new(0, 15, 0.5, -24)
        btn.BackgroundColor3 = Library.MainColor
        btn.Text = "M"
        btn.TextColor3 = Library.AccentColor
        btn.TextSize = 24
        btn.Font = Enum.Font.GothamBold
        btn.Parent = toggleGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Library.AccentColor
        stroke.Thickness = 1.5
        stroke.Parent = btn

        -- Lógica de arrastre
        local isDragging, hasMoved, dragStart, startPos = false, false, nil, nil
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true; hasMoved = false; dragStart = input.Position; startPos = btn.Position
            end
        end)
        btn.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and isDragging then
                local delta = input.Position - dragStart
                if delta.Magnitude > 5 then hasMoved = true end
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false; if not hasMoved then Library:Toggle() end
            end
        end)
        
        -- Override Unload para limpiar el botón
        local oldUnload = Library.Unload
        Library.Unload = function(...)
            if toggleGui then toggleGui:Destroy() end
            if oldUnload then return oldUnload(...) end
        end
    end
end

return MounxHub
