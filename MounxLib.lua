local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Evitar el Flash
pcall(function() if Library.ScreenGui then Library.ScreenGui.Enabled = false end end)

-- ==================================================
-- MOUNX CUSTOM THEMES (V8)
-- ==================================================
ThemeManager.BuiltInThemes['Default'] = nil
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141419","AccentColor":"a855f7","BackgroundColor":"0a0a0f","OutlineColor":"0a0a0f"}') }

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

--// ============================================================
--// MOUNX STYLE ENGINE (PREMIUM V8)
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

    -- HOVER V8: Glow muy sutil y solo donde importa
    local function applyProHover(obj, customRad)
        if not obj or obj:FindFirstChild("ProHover") then return end
        local stroke = Instance.new("UIStroke")
        stroke.Name = "ProHover"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Library.AccentColor or Color3.fromRGB(179, 102, 255)
        stroke.Transparency = 1
        stroke.Thickness = 1
        stroke.Parent = obj
        
        local tIn = TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.15})
        local tOut = TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1})

        -- Asignamos eventos
        obj.MouseEnter:Connect(function() tIn:Play() end)
        obj.MouseLeave:Connect(function() tOut:Play() end)
        obj.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tIn:Play() end end)
        obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tOut:Play() end end)
    end

    local function styleObj(obj)
        if not obj then return end

        -- SOLUCIÓN BOTONES MÓVIL (Deducción inversa porque Linoria no los nombra)
        if obj:IsA("TextButton") then
            local txt = obj.Text
            if txt == "Toggle UI" or txt == "Lock UI" or txt == "Unlock UI" or txt == "Hide UI" or txt == "Show UI" or txt == "Hide" or txt == "Show" then
                if txt == "Toggle UI" or txt == "Hide" or txt == "Show" then
                    obj.Text = Library.Toggled and "Hide UI" or "Show UI"
                    obj.MouseButton1Down:Connect(function()
                        task.wait(0.05)
                        obj.Text = Library.Toggled and "Hide UI" or "Show UI"
                    end)
                end
                
                addCorner(obj, 100)
                obj.BorderSizePixel = 0
                obj.BackgroundTransparency = 1
                pcall(function() obj.TextStrokeTransparency = 1 end)
                
                local p1 = obj.Parent
                local p2 = p1 and p1.Parent
                local p3 = p2 and p2.Parent
                
                if p1 and p1:IsA("Frame") then addCorner(p1, 100); p1.BorderSizePixel = 0; p1.BackgroundTransparency = 1 end
                if p2 and p2:IsA("Frame") then addCorner(p2, 100); p2.BorderSizePixel = 0; p2.BackgroundTransparency = 1 end
                if p3 and p3:IsA("Frame") then 
                    addCorner(p3, 100); 
                    p3.BorderSizePixel = 0; 
                    p3.BackgroundColor3 = Library.BackgroundColor
                    if not p3:FindFirstChild("MobileGlow") then
                        local mg = Instance.new("UIStroke")
                        mg.Name = "MobileGlow"
                        mg.Color = Library.AccentColor
                        mg.Thickness = 1.2
                        mg.Transparency = 0.3
                        mg.Parent = p3
                    end
                    applyProHover(p3)
                end
            end
        end

        if not obj:IsA("Frame") then return end
        local name = obj.Name

        -- 1. WINDOW (Animación Pop-In y estilo fino)
        if name == "Window" then
            addCorner(obj, Config.WindowRadius)
            obj.BorderSizePixel = 0
            
            -- ANIMACION DE FADE / ZOOM AL INICIAR
            if not obj:FindFirstChild("PopInScale") then
                local scale = Instance.new("UIScale")
                scale.Name = "PopInScale"
                scale.Scale = 0.85
                scale.Parent = obj
                TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end
            
            if not obj:FindFirstChild("WindowGlow") then
                local glow = Instance.new("UIStroke")
                glow.Name = "WindowGlow"
                glow.Color = Library.AccentColor or Color3.fromRGB(179, 102, 255)
                glow.Thickness = 1.2
                glow.Transparency = 0.3
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
                                if topBar:IsA("Frame") and topBar.Size.Y.Offset == 1 then topBar.Visible = false end
                            end
                        end
                    end
                end
            end
            return
        end

        -- WATERMARK Y KEYBINDS
        if name == "Watermark" or name == "Keybinds" then
            addCorner(obj, 10)
            obj.BorderSizePixel = 0
            
            for _, inner in ipairs(obj:GetDescendants()) do
                if inner:IsA("Frame") or inner:IsA("TextLabel") then
                    addCorner(inner, 10)
                    pcall(function() inner.BorderSizePixel = 0 end)
                end
            end

            if not obj:FindFirstChild("WidgetGlow") then
                local glow = Instance.new("UIStroke")
                glow.Name = "WidgetGlow"
                glow.Color = Library.AccentColor
                glow.Thickness = 1.2
                glow.Transparency = 0.2
                glow.Parent = obj
            end
        end

        -- CONTENEDORES
        if name == "TabContainer" or name == "MainSectionOuter" or name == "MainSectionInner" or name == "BoxOuter" or name == "BoxInner" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
        end

        if obj.Size == UDim2.new(1, 0, 0, 2) and obj.Parent and obj.Parent.Name == "BoxInner" then
            if not obj:FindFirstChild("FadeGrad") then
                local g = Instance.new("UIGradient")
                g.Name = "FadeGrad"
                g.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
                g.Parent = obj
                addCorner(obj, 100)
            end
        end

        -- CHECKBOXES (Hover solo en el circulito!)
        if obj.Size == UDim2.new(0, 13, 0, 13) then
            addCorner(obj, 100)
            obj.BorderSizePixel = 0
            applyProHover(obj) -- Aplicado directamente al círculo, no a toda la fila
            
            if not obj:FindFirstChild("CheckRing") then
                local ring = Instance.new("UIStroke")
                ring.Name = "CheckRing"
                ring.Color = Color3.new(0.3, 0.3, 0.3)
                ring.Thickness = 1
                ring.Transparency = 0.5
                ring.Parent = obj
            end
            
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") and inner.Name ~= "CheckRing" and inner.Name ~= "ProHover" then
                    addCorner(inner, 100)
                    inner.BorderSizePixel = 0
                end
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
                            addCorner(fill, 100)
                            fill.BorderSizePixel = 0
                            for _, secretLine in ipairs(fill:GetChildren()) do
                                if secretLine:IsA("Frame") then secretLine:Destroy() end
                            end
                        end
                    end
                end
            end
            applyProHover(obj)
        end

        -- BOTONES / DROPDOWNS
        if obj.Size == UDim2.new(1, -4, 0, 20) or obj.Size == UDim2.new(1, -4, 0, 22) or obj.Size == UDim2.new(1, 0, 0, 20) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then addCorner(inner, Config.ControlRadius); inner.BorderSizePixel = 0 end
            end
            applyProHover(obj)
        end
        
        -- COLORPICKERS
        if obj.Size == UDim2.new(0, 14, 0, 14) or obj.Size == UDim2.new(0, 20, 0, 14) then
            addCorner(obj, 4)
            obj.BorderSizePixel = 0
            applyProHover(obj)
        end

        -- BOTONES TABS
        if obj:IsA("TextButton") and obj.Parent and obj.Parent.Name == "TabboxButtons" then
            addCorner(obj, 6)
            obj.BorderSizePixel = 0
            applyProHover(obj)
        end
    end

    for _, child in ipairs(gui:GetDescendants()) do styleObj(child) end
    gui.DescendantAdded:Connect(function(child) task.wait() styleObj(child) end)
end

function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Close')
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    local ExtrasGroup = SettingsTab:AddRightGroupbox('Menu Extras')
    ExtrasGroup:AddToggle('WatermarkToggle', {
        Text = 'Show Watermark', Default = false,
        Callback = function(v) Library:SetWatermarkVisibility(v) end
    })
    ExtrasGroup:AddToggle('KeybindsToggle', {
        Text = 'Show Keybinds', Default = false,
        Callback = function(v) Library.KeybindFrame.Visible = v end
    })
    
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:ApplyToTab(SettingsTab)
    
    if ThemeManager.Options and ThemeManager.Options.ThemeManager_ThemeList then
        ThemeManager:ApplyTheme('Mounx Default')
    end
    
    -- Apagar Watermark/Keybinds desde el inicio!
    Library:SetWatermarkVisibility(false)
    pcall(function() Library.KeybindFrame.Visible = false end)
    pcall(function() if Library.Options.VideoLink then Library.Options.VideoLink:SetVisible(false) end end)
    
    task.spawn(function()
        local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
        local gName = (ok and info) and info.Name or "Game"
        local pName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or "User"
        Library:SetWatermark(gName .. " | " .. pName .. " | Mounx")
    end)
    
    task.spawn(function()
        task.wait(0.15)
        ApplyMounxStyle(Library)
        pcall(function() Library.ScreenGui.Enabled = true end)
    end)
end

return MounxHub
