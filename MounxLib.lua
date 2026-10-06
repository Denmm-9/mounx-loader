local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==================================================
-- TEMAS PERSONALIZADOS MOUNX (V4)
-- ==================================================
ThemeManager.BuiltInThemes['Default'] = nil

-- Nuevo Mounx Default (Mas profesional, oscuro y vibrante)
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, game:GetService("HttpService"):JSONDecode('{"FontColor":"e6e6fa","MainColor":"0e0e14","AccentColor":"b366ff","BackgroundColor":"08080c","OutlineColor":"1f1f2e"}') }

ThemeManager.BuiltInThemes['Dark Neon'] = { 2, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a0a0a","AccentColor":"00ff88","BackgroundColor":"050505","OutlineColor":"1a1a1a"}') }
ThemeManager.BuiltInThemes['Bloody Red'] = { 3, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"140000","AccentColor":"ff0000","BackgroundColor":"0a0000","OutlineColor":"280000"}') }
ThemeManager.BuiltInThemes['Deep Ocean'] = { 4, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"000a14","AccentColor":"0088ff","BackgroundColor":"00050a","OutlineColor":"001428"}') }
ThemeManager.BuiltInThemes['Cyberpunk'] = { 5, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a001a","AccentColor":"ff00ff","BackgroundColor":"0d000d","OutlineColor":"330033"}') }

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

--// ============================================================
--// MOUNX STYLE ENGINE (PREMIUM V4)
--// ============================================================
local function ApplyMounxStyle(Library)
    if not Library or not Library.ScreenGui then return end
    local gui = Library.ScreenGui
    local TweenService = game:GetService("TweenService")
    
    local Config = {
        WindowRadius = 14,
        GroupRadius = 8,
        ControlRadius = 6,
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

    -- Nuevo Hover: Usa Glow Lineal (UIStroke) para no manchar el interior!
    local function applyHoverStroke(obj, color)
        if not obj or obj:FindFirstChild("HoverStroke") then return end
        local stroke = Instance.new("UIStroke")
        stroke.Name = "HoverStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = color or Library.AccentColor or Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 1
        stroke.Thickness = 1
        stroke.Parent = obj

        local tIn = TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.1})
        local tOut = TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1})

        obj.MouseEnter:Connect(function() tIn:Play() end)
        obj.MouseLeave:Connect(function() tOut:Play() end)
        obj.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tIn:Play() end end)
        obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tOut:Play() end end)
    end

    local function addShadow(obj, size, trans)
        if not obj or obj:FindFirstChild("MounxShadow") then return end
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "MounxShadow"
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Position = UDim2.fromScale(0.5, 0.5)
        shadow.Size = UDim2.new(1, size or 60, 1, size or 60)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://6014261993"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = trans or 0.35
        shadow.ZIndex = 0
        shadow.Parent = obj
    end

    local function styleObj(obj)
        if not obj then return end
        
        -- Fuente Global Pro
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() 
                if obj.Font == Enum.Font.Code or obj.Font == Enum.Font.SourceSans then
                    obj.Font = Enum.Font.GothamMedium
                end
            end)
        end

        -- MOBILE BOTONES: Toggle UI -> Hide/Show
        if obj:IsA("TextButton") then
            if obj.Text == "Toggle UI" then
                obj.Text = Library.Toggled and "Hide" or "Show"
                addCorner(obj, 100)
                applyHoverStroke(obj, Library.AccentColor)
                obj.MouseButton1Down:Connect(function()
                    task.wait(0.05)
                    obj.Text = Library.Toggled and "Hide" or "Show"
                end)
            elseif obj.Text == "Lock UI" or obj.Text == "Unlock UI" then
                addCorner(obj, 100)
                applyHoverStroke(obj, Library.AccentColor)
            end
        end

        if not obj:IsA("Frame") then return end
        local name = obj.Name

        -- 1. WINDOW (Exterior super Premium con borde resplandeciente)
        if name == "Window" then
            addCorner(obj, Config.WindowRadius)
            addShadow(obj, 70, 0.3) -- Sombra mas agresiva
            obj.BorderSizePixel = 0
            
            -- Borde Neon (Accent) al exterior
            if not obj:FindFirstChild("WindowGlow") then
                local glow = Instance.new("UIStroke")
                glow.Name = "WindowGlow"
                glow.Color = Library.AccentColor or Color3.fromRGB(179, 102, 255)
                glow.Thickness = 2
                glow.Transparency = 0.4
                glow.Parent = obj
            end
            
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Frame") and child.Name ~= "WindowGlow" then
                    addCorner(child, Config.WindowRadius - 1)
                    child.BorderSizePixel = 0
                    for _, subChild in ipairs(child:GetChildren()) do
                        if subChild:IsA("Frame") then
                            addCorner(subChild, Config.WindowRadius - 2)
                            subChild.BorderSizePixel = 0
                            for _, topBar in ipairs(subChild:GetChildren()) do
                                if topBar:IsA("Frame") and topBar.Size.Y.Offset == 1 then
                                    topBar.Visible = false
                                end
                            end
                        end
                    end
                end
            end
            return
        end

        -- WATERMARK Y KEYBINDS (Widgets flotantes)
        if name == "Watermark" or name == "Keybinds" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
            addShadow(obj, 40, 0.4)
            if not obj:FindFirstChild("WidgetGlow") then
                local glow = Instance.new("UIStroke")
                glow.Name = "WidgetGlow"
                glow.Color = Library.AccentColor
                glow.Thickness = 1
                glow.Transparency = 0.3
                glow.Parent = obj
            end
        end

        -- CONTENEDORES
        if name == "TabContainer" or name == "MainSectionOuter" or name == "MainSectionInner" or name == "BoxOuter" or name == "BoxInner" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
            
            if (name == "BoxInner" or name == "MainSectionInner") and not obj:FindFirstChildOfClass("UIGradient") then
                local grad = Instance.new("UIGradient")
                grad.Rotation = 90
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(0.95, 0.95, 0.95))
                })
                grad.Parent = obj
            end
        end

        -- HIGHLIGHT (Top line difuminada)
        if obj.Size == UDim2.new(1, 0, 0, 2) and obj.Parent and obj.Parent.Name == "BoxInner" then
            if not obj:FindFirstChild("FadeGrad") then
                local g = Instance.new("UIGradient")
                g.Name = "FadeGrad"
                g.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                g.Parent = obj
                addCorner(obj, 100)
            end
        end

        -- CHECKBOXES
        if obj.Size == UDim2.new(0, 13, 0, 13) then
            addCorner(obj, 100)
            obj.BorderSizePixel = 0
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then
                    addCorner(inner, 100)
                    inner.BorderSizePixel = 0
                end
            end
            if obj.Parent and obj.Parent:IsA("TextLabel") then
                applyHoverStroke(obj.Parent)
            end
        end

        -- SLIDERS
        if obj.Size == UDim2.new(1, -4, 0, 13) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then
                    addCorner(inner, Config.ControlRadius)
                    inner.BorderSizePixel = 0
                    for _, fill in ipairs(inner:GetChildren()) do
                        if fill:IsA("Frame") then
                            -- DESTRUIR LA LINEA DEL SLIDER PARA SIEMPRE
                            if fill.Size.X.Offset == 1 and fill.Size.X.Scale == 0 then
                                fill:Destroy()
                            else
                                addCorner(fill, 100) -- Capsula perfecta
                                fill.BorderSizePixel = 0
                            end
                        end
                    end
                end
            end
            applyHoverStroke(obj)
        end

        -- BOTONES / DROPDOWNS
        if obj.Size == UDim2.new(1, -4, 0, 20) or obj.Size == UDim2.new(1, -4, 0, 22) or obj.Size == UDim2.new(1, 0, 0, 20) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then
                    addCorner(inner, Config.ControlRadius)
                    inner.BorderSizePixel = 0
                end
            end
            applyHoverStroke(obj)
        end
        
        -- COLORPICKERS
        if obj.Size == UDim2.new(0, 14, 0, 14) or obj.Size == UDim2.new(0, 20, 0, 14) then
            addCorner(obj, 4)
            obj.BorderSizePixel = 0
            applyHoverStroke(obj)
        end

        -- BOTONES TABS
        if obj:IsA("TextButton") and obj.Parent and obj.Parent.Name == "TabboxButtons" then
            addCorner(obj, 6)
            obj.BorderSizePixel = 0
            applyHoverStroke(obj)
        end

        -- SCROLLFRAME
        if obj:IsA("ScrollingFrame") then
            obj.ScrollBarThickness = 1
            obj.ScrollBarImageTransparency = 0.8
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
    
    -- Configurar UI y Temas
    if ThemeManager.Options and ThemeManager.Options.ThemeManager_ThemeList then
        ThemeManager:ApplyTheme('Mounx Default')
    end
    
    pcall(function() if Library.Options.VideoLink then Library.Options.VideoLink:SetVisible(false) end end)
    
    -- Activar Watermark y Keybinds por defecto
    Library:SetWatermarkVisibility(true)
    Library:SetWatermark('Mounx Premium | ' .. tostring(game.PlaceId))
    pcall(function() Library.KeybindFrame.Visible = true end)
    
    task.spawn(function()
        task.wait(0.2)
        ApplyMounxStyle(Library)
    end)
end

return MounxHub
