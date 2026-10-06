local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==================================================
-- TEMAS PERSONALIZADOS MOUNX
-- ==================================================
ThemeManager.BuiltInThemes['Default'] = nil

ThemeManager.BuiltInThemes['Mounx Default'] = { 1, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141419","AccentColor":"a855f7","BackgroundColor":"0a0a0f","OutlineColor":"1e1e28"}') }
ThemeManager.BuiltInThemes['Dark Neon'] = { 2, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a0a0a","AccentColor":"00ff88","BackgroundColor":"050505","OutlineColor":"1a1a1a"}') }
ThemeManager.BuiltInThemes['Bloody Red'] = { 3, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"140000","AccentColor":"ff0000","BackgroundColor":"0a0000","OutlineColor":"280000"}') }
ThemeManager.BuiltInThemes['Deep Ocean'] = { 4, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"000a14","AccentColor":"0088ff","BackgroundColor":"00050a","OutlineColor":"001428"}') }
ThemeManager.BuiltInThemes['Cyberpunk'] = { 5, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a001a","AccentColor":"ff00ff","BackgroundColor":"0d000d","OutlineColor":"330033"}') }
ThemeManager.BuiltInThemes['Gold Luxury'] = { 6, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141100","AccentColor":"ffd700","BackgroundColor":"0a0900","OutlineColor":"282200"}') }
ThemeManager.BuiltInThemes['Amethyst'] = { 7, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0f0a14","AccentColor":"9b59b6","BackgroundColor":"0a0510","OutlineColor":"1e1428"}') }
ThemeManager.BuiltInThemes['Emerald'] = { 8, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a140f","AccentColor":"2ecc71","BackgroundColor":"050a08","OutlineColor":"14281e"}') }
ThemeManager.BuiltInThemes['Crimson Night'] = { 9, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffdddd","MainColor":"110000","AccentColor":"dc143c","BackgroundColor":"050000","OutlineColor":"220000"}') }
ThemeManager.BuiltInThemes['Ice White'] = { 10, game:GetService("HttpService"):JSONDecode('{"FontColor":"000000","MainColor":"f0f5ff","AccentColor":"00aaff","BackgroundColor":"ffffff","OutlineColor":"d0e0ff"}') }
ThemeManager.BuiltInThemes['Midnight Purple'] = { 11, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"150020","AccentColor":"8a2be2","BackgroundColor":"0f0015","OutlineColor":"2a0040"}') }
ThemeManager.BuiltInThemes['Toxic Green'] = { 12, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"051505","AccentColor":"39ff14","BackgroundColor":"000a00","OutlineColor":"0a2a0a"}') }
ThemeManager.BuiltInThemes['Royal Blue'] = { 13, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"00051a","AccentColor":"4169e1","BackgroundColor":"000010","OutlineColor":"000a33"}') }
ThemeManager.BuiltInThemes['Sunset Orange'] = { 14, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a0a00","AccentColor":"ff4500","BackgroundColor":"100500","OutlineColor":"331400"}') }
ThemeManager.BuiltInThemes['Rose Gold'] = { 15, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a1014","AccentColor":"b76e79","BackgroundColor":"100a0d","OutlineColor":"332028"}') }

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

--// ============================================================
--// MOUNX STYLE ENGINE (PREMIUM V2)
--// ============================================================
local function ApplyMounxStyle(Library)
    if not Library or not Library.ScreenGui then return end
    local gui = Library.ScreenGui
    
    local Config = {
        WindowRadius = 12,
        GroupRadius = 6,
        ControlRadius = 5,
        ShadowTransparency = 0.5,
    }

    local function addCorner(obj, rad)
        if not obj or not obj:IsA("GuiObject") then return end
        if not obj:FindFirstChild("MounxCorner") then
            local c = Instance.new("UICorner")
            c.Name = "MounxCorner"
            c.CornerRadius = UDim.new(0, rad)
            c.Parent = obj
        end
    end

    local function addShadow(obj)
        if not obj or obj:FindFirstChild("MounxShadow") then return end
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "MounxShadow"
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Position = UDim2.fromScale(0.5, 0.5)
        shadow.Size = UDim2.new(1, 40, 1, 40)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://6014261993"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = Config.ShadowTransparency
        shadow.ZIndex = 0
        shadow.Parent = obj
    end

    local function styleObj(obj)
        if not obj then return end
        
        -- CAMBIO DE FUENTE (De Code/Roboto a GothamMedium para un look premium)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() 
                if obj.Font == Enum.Font.Code or obj.Font == Enum.Font.SourceSans then
                    obj.Font = Enum.Font.GothamMedium
                end
            end)
        end

        if not obj:IsA("Frame") then return end
        local name = obj.Name

        -- REDISEÑO COMPLETO DE VENTANA Y LIMPIEZA
        if name == "Window" then
            addCorner(obj, Config.WindowRadius)
            addShadow(obj)
            obj.BorderSizePixel = 0
            
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Frame") then
                    addCorner(child, Config.WindowRadius - 1)
                    child.BorderSizePixel = 0
                    for _, subChild in ipairs(child:GetChildren()) do
                        if subChild:IsA("Frame") then
                            addCorner(subChild, Config.WindowRadius - 2)
                            subChild.BorderSizePixel = 0
                            
                            -- Eliminar la línea top de LinoriaLib
                            for _, topBar in ipairs(subChild:GetChildren()) do
                                if topBar:IsA("Frame") and topBar.Size.Y.Offset == 1 then
                                    topBar.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end

        if name == "TabContainer" or name == "MainSectionOuter" or name == "MainSectionInner" or name == "BoxOuter" or name == "BoxInner" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
            
            -- Añadir un sutil gradiente a las cajas interiores para dar profundidad de lujo
            if (name == "BoxInner" or name == "MainSectionInner") and not obj:FindFirstChildOfClass("UIGradient") then
                local grad = Instance.new("UIGradient")
                grad.Rotation = 90
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(0.9, 0.9, 0.9))
                })
                grad.Parent = obj
            end
        end

        if name == "Button" or name == "Slider" or name == "Dropdown" or name == "List" or name == "ColorPicker" or name == "Toggle" then
            addCorner(obj, Config.ControlRadius)
        end
        
        if name == "SliderOuter" or name == "SliderInner" then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
        end
        
        -- INDICADORES (Las casillas de los Checkboxes) ahora son circulares
        if name == "Indicator" then
            addCorner(obj, 100) -- Redondo total
            obj.BorderSizePixel = 0
        end
        
        -- ScrollFrame más invisible y delgado para móvil
        if obj:IsA("ScrollingFrame") then
            obj.ScrollBarThickness = 1
            obj.ScrollBarImageTransparency = 0.6
        end
    end

    for _, child in ipairs(gui:GetDescendants()) do styleObj(child) end
    gui.DescendantAdded:Connect(function(child) task.wait() styleObj(child) end)
end

function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Cerrar')
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:ApplyToTab(SettingsTab)
    ThemeManager:ApplyTheme('Mounx Default')
    
    pcall(function()
        if Library.Options.VideoLink then Library.Options.VideoLink:SetVisible(false) end
    end)
    
    task.spawn(function()
        task.wait(0.2)
        ApplyMounxStyle(Library)
    end)
end

return MounxHub
