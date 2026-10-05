local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==================================================
-- TEMA PERSONALIZADO "MOUNX" POR DEFECTO
-- ==================================================
Library.AccentColor = Color3.fromRGB(168, 85, 247) 
Library.MainColor = Color3.fromRGB(20, 20, 25)
Library.FontColor = Color3.fromRGB(255, 255, 255)

-- Agregando tus temas personalizados a ThemeManager
ThemeManager.BuiltInThemes['Dark Neon'] = { 9, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a0a0a","AccentColor":"00ff88","BackgroundColor":"050505","OutlineColor":"1a1a1a"}') }
ThemeManager.BuiltInThemes['Bloody Red'] = { 10, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"140000","AccentColor":"ff0000","BackgroundColor":"0a0000","OutlineColor":"280000"}') }
ThemeManager.BuiltInThemes['Deep Ocean'] = { 11, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"000a14","AccentColor":"0088ff","BackgroundColor":"00050a","OutlineColor":"001428"}') }
ThemeManager.BuiltInThemes['Cyberpunk'] = { 12, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a001a","AccentColor":"ff00ff","BackgroundColor":"0d000d","OutlineColor":"330033"}') }
ThemeManager.BuiltInThemes['Gold Luxury'] = { 13, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141100","AccentColor":"ffd700","BackgroundColor":"0a0900","OutlineColor":"282200"}') }
ThemeManager.BuiltInThemes['Amethyst'] = { 14, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0f0a14","AccentColor":"9b59b6","BackgroundColor":"0a0510","OutlineColor":"1e1428"}') }
ThemeManager.BuiltInThemes['Emerald'] = { 15, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a140f","AccentColor":"2ecc71","BackgroundColor":"050a08","OutlineColor":"14281e"}') }
ThemeManager.BuiltInThemes['Crimson Night'] = { 16, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffdddd","MainColor":"110000","AccentColor":"dc143c","BackgroundColor":"050000","OutlineColor":"220000"}') }
ThemeManager.BuiltInThemes['Ice White'] = { 17, game:GetService("HttpService"):JSONDecode('{"FontColor":"000000","MainColor":"f0f5ff","AccentColor":"00aaff","BackgroundColor":"ffffff","OutlineColor":"d0e0ff"}') }


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
    
    -- Corrección: Usar Library.Options
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    -- 2. CONFIGURAR THEME Y SAVE MANAGER
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    -- Corrección: ThemeManager usa ApplyToTab en esta versión de Linoria, no BuildThemeSection
    ThemeManager:ApplyToTab(SettingsTab)
    
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
                if vpY < 650 then uiScale.Scale = math.clamp(vpY / 600, 0.75, 1) else uiScale.Scale = 1 end
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
        btn.Text = ""
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

