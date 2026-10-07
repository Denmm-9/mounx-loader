local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

pcall(function() if Library.ScreenGui then Library.ScreenGui.Enabled = false end end)

local HttpService = game:GetService("HttpService")

ThemeManager.BuiltInThemes['Default'] = nil
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141419","AccentColor":"a855f7","BackgroundColor":"0a0a0f","OutlineColor":"0a0a0f"}') }
ThemeManager.BuiltInThemes['Bloody Red']    = { 2, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191414","AccentColor":"ff3333","BackgroundColor":"0f0a0a","OutlineColor":"0f0a0a"}') }
ThemeManager.BuiltInThemes['Dark Neon']     = { 3, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141922","AccentColor":"00f0ff","BackgroundColor":"0a0f14","OutlineColor":"0a0f14"}') }
ThemeManager.BuiltInThemes['Cyberpunk']     = { 4, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"22141c","AccentColor":"ff00ff","BackgroundColor":"140a12","OutlineColor":"140a12"}') }
ThemeManager.BuiltInThemes['Toxic Green']   = { 5, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141e14","AccentColor":"39ff14","BackgroundColor":"0a120a","OutlineColor":"0a120a"}') }
ThemeManager.BuiltInThemes['Ocean Blue']    = { 6, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141a22","AccentColor":"0077ff","BackgroundColor":"0a0f14","OutlineColor":"0a0f14"}') }
ThemeManager.BuiltInThemes['Golden Luxury'] = { 7, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"221d14","AccentColor":"ffb700","BackgroundColor":"14100a","OutlineColor":"14100a"}') }
ThemeManager.BuiltInThemes['Amethyst']      = { 8, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a1422","AccentColor":"b366ff","BackgroundColor":"100a14","OutlineColor":"100a14"}') }
ThemeManager.BuiltInThemes['Ruby Blood']    = { 9, HttpService:JSONDecode('{"FontColor":"ffffff","MainColor":"221010","AccentColor":"ff0044","BackgroundColor":"110808","OutlineColor":"110808"}') }
ThemeManager.BuiltInThemes['Ghost White']   = { 10, HttpService:JSONDecode('{"FontColor":"000000","MainColor":"f0f0f5","AccentColor":"000000","BackgroundColor":"e0e0e5","OutlineColor":"e0e0e5"}') }

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled

local function safeDestroy(obj)
    pcall(function() obj.Visible = false end)
    pcall(function() obj.BackgroundTransparency = 1 end)
    pcall(function() obj.Transparency = 1 end)
end

local function ApplyMounxStyle(Library)
    if not Library or not Library.ScreenGui then return end
    local gui = Library.ScreenGui
    local TweenService = game:GetService("TweenService")
    
    local Config = { WindowRadius = 14, GroupRadius = 8, ControlRadius = 6 }

    local function addCorner(obj, rad)
        if not obj or not obj:IsA("GuiObject") then return end
        if not obj:FindFirstChild("MounxCorner") then
            local c = Instance.new("UICorner")
            c.Name = "MounxCorner"
            c.CornerRadius = UDim.new(0, rad)
            c.Parent = obj
        end
    end

    local function applyProHover(obj, customStroke)
        if not obj or obj:FindFirstChild("ProHover") then return end
        local stroke = customStroke or Instance.new("UIStroke")
        stroke.Name = "ProHover"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1.2
        stroke.Transparency = 1
        stroke.Parent = obj
        Library:AddToRegistry(stroke, { Color = "AccentColor" })
        
        local tIn = TweenService:Create(stroke, TweenInfo.new(0.12), {Transparency = 0})
        local tOut = TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1})

        local trigger = obj
        if obj.Size == UDim2.new(0, 13, 0, 13) and obj.Parent then trigger = obj.Parent end
        
        trigger.MouseEnter:Connect(function() tIn:Play() end)
        trigger.MouseLeave:Connect(function() tOut:Play() end)
        trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tIn:Play() end end)
        trigger.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tOut:Play() end end)
    end

    local function styleWidget(widget)
        if not widget then return end
        addCorner(widget, 8) -- RECTANGULO COMO LINORIA
        pcall(function() widget.BorderSizePixel = 0 end)
        
        for _, inner in ipairs(widget:GetDescendants()) do
            if inner:IsA("GuiObject") then 
                -- Hacer circulares solo a los puntitos de estado!
                if inner.Size.X.Offset <= 15 and inner.Size.X.Scale == 0 then
                    addCorner(inner, 100)
                else
                    addCorner(inner, 8)
                end
                pcall(function() inner.BorderSizePixel = 0 end)
            end
            
            if inner:IsA("Frame") and inner.Size.Y.Offset <= 2 and inner.BorderSizePixel == 0 and inner.BackgroundColor3 == Library.AccentColor then
                safeDestroy(inner)
            end
        end
        
        if not widget:FindFirstChild("WidgetGlow") then
            local glow = Instance.new("UIStroke")
            glow.Name = "WidgetGlow"
            glow.Thickness = 1.2
            glow.Transparency = 0.2
            glow.Parent = widget
            Library:AddToRegistry(glow, { Color = "AccentColor" })
        end
    end

    if Library.WatermarkOuter then styleWidget(Library.WatermarkOuter) end
            if Library.KeybindFrame then 
        styleWidget(Library.KeybindFrame) 
        Library.KeybindFrame.BackgroundTransparency = 0.1
        Library.KeybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        
        local title = Library.KeybindFrame:FindFirstChildWhichIsA("TextLabel")
        if title then
            title.Font = Enum.Font.GothamBold
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            if not title:FindFirstChild("TitleDivider") then
                local div = Instance.new("Frame")
                div.Name = "TitleDivider"
                div.BackgroundColor3 = Library.AccentColor
                div.BorderSizePixel = 0
                div.Size = UDim2.new(1, -10, 0, 2)
                div.Position = UDim2.new(0, 5, 1, 3)
                div.Parent = title
            end
        end
        
        if not Library.KeybindFrame:FindFirstChild("ProGradient") then
            local grad = Instance.new("UIGradient")
            grad.Name = "ProGradient"
            grad.Rotation = 45
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
            })
            grad.Parent = Library.KeybindFrame
        end
    end

    local function styleObj(obj)
        if not obj then return end

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
                
                local p = obj.Parent
                for i = 1, 3 do
                    if p and p:IsA("Frame") then
                        p.BackgroundTransparency = 1
                        p.BorderSizePixel = 0
                        p.ClipsDescendants = false
                        p = p.Parent
                    end
                end

                                -- Make dragging easier on mobile
                if Library.IsMobile and obj.Parent and obj.Parent:IsA("Frame") then
                    obj.Parent.Size = UDim2.new(0, 90, 0, 45)
                    obj.Size = UDim2.new(1, 0, 1, -15)
                    obj.Position = UDim2.new(0, 0, 0, 15)
                    
                    if not obj.Parent:FindFirstChild("DragHandle") then
                        local drag = Instance.new("Frame")
                        drag.Name = "DragHandle"
                        drag.Size = UDim2.new(0, 30, 0, 4)
                        drag.Position = UDim2.new(0.5, -15, 0, 5)
                        drag.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                        drag.BackgroundTransparency = 0.5
                        drag.BorderSizePixel = 0
                        Instance.new("UICorner", drag).CornerRadius = UDim.new(1, 0)
                        drag.Parent = obj.Parent
                    end

                    if txt == "Lock UI" or txt == "Unlock UI" then
                        obj.Parent.Position = UDim2.new(0.5, 0, 0, 60)
                    else
                        obj.Parent.Position = UDim2.new(0.5, 0, 0, 20)
                    end
                else
                    obj.Size = UDim2.new(0, 90, 0, 28)
                end
                
                addCorner(obj, 100)
                obj.BorderSizePixel = 0
                obj.BackgroundTransparency = 0
                
                obj.Font = Enum.Font.GothamBold
                obj.TextXAlignment = Enum.TextXAlignment.Center
                pcall(function() obj.TextStrokeTransparency = 1 end)
                
                Library:AddToRegistry(obj, { 
                    BackgroundColor3 = "MainColor",
                    TextColor3 = "FontColor" 
                })
                
                if not obj:FindFirstChild("ButtonGlass") then
                    local grad = Instance.new("UIGradient")
                    grad.Name = "ButtonGlass"
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(0.65, 0.65, 0.65))
                    })
                    grad.Rotation = 90
                    grad.Parent = obj
                end
                
                if not obj:FindFirstChild("MobileOutline") then
                    local stroke = Instance.new("UIStroke")
                    stroke.Name = "MobileOutline"
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Thickness = 2
                    stroke.Transparency = 0.1
                    stroke.Parent = obj
                    Library:AddToRegistry(stroke, { Color = "AccentColor" })
                end
            end
        end

        if not obj:IsA("Frame") then return end
        local name = obj.Name

        if obj.Size.Y.Offset <= 2 and obj.BorderSizePixel == 0 and obj.Parent and (obj.Parent.Name == "BoxInner" or obj.Parent.Name == "MainSectionInner" or obj.Parent.Name == "TabContainer") then
            safeDestroy(obj)
            return
        end

        if name == "Window" then
            addCorner(obj, Config.WindowRadius)
            obj.BorderSizePixel = 0
            if not obj:FindFirstChild("WindowGlow") then
                local glow = Instance.new("UIStroke")
                glow.Name = "WindowGlow"
                glow.Thickness = 1.2
                glow.Transparency = 0.3
                glow.Parent = obj
                Library:AddToRegistry(glow, { Color = "AccentColor" })
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

        if name == "TabContainer" or name == "MainSectionOuter" or name == "MainSectionInner" or name == "BoxOuter" or name == "BoxInner" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
        end

        if obj.Size == UDim2.new(0, 13, 0, 13) then
            addCorner(obj, 100)
            obj.BorderSizePixel = 0
            
            local ring = obj:FindFirstChild("CheckRing")
            if not ring then
                ring = Instance.new("UIStroke")
                ring.Name = "CheckRing"
                ring.Thickness = 1
                ring.Transparency = 0.5
                ring.Parent = obj
                Library:AddToRegistry(ring, { Color = "OutlineColor" })
            end
            
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") and inner.Name ~= "CheckRing" then
                    addCorner(inner, 100)
                    inner.BorderSizePixel = 0
                end
            end
            
            if obj.Parent then
                local oldHover = obj.Parent:FindFirstChild("ProHover")
                if oldHover then safeDestroy(oldHover) end
            end
            
            applyProHover(obj)
        end

        if obj.Size == UDim2.new(1, -4, 0, 13) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            
            local isToggleRow = false
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then
                    if inner.Size == UDim2.new(0, 13, 0, 13) then
                        isToggleRow = true
                    end
                    addCorner(inner, Config.ControlRadius)
                    inner.BorderSizePixel = 0
                    for _, fill in ipairs(inner:GetChildren()) do
                        if fill:IsA("Frame") then
                            addCorner(fill, 100)
                            fill.BorderSizePixel = 0
                            for _, secretLine in ipairs(fill:GetChildren()) do
                                if secretLine:IsA("Frame") then safeDestroy(secretLine) end
                            end
                        end
                    end
                end
            end
            if not isToggleRow then
                applyProHover(obj)
            end
        end

        if obj.Size == UDim2.new(1, -4, 0, 20) or obj.Size == UDim2.new(1, -4, 0, 22) or obj.Size == UDim2.new(1, 0, 0, 20) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            local isToggleRow = false
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then
                    if inner.Size == UDim2.new(0, 13, 0, 13) then isToggleRow = true end
                    addCorner(inner, Config.ControlRadius)
                    inner.BorderSizePixel = 0 
                end
            end
            if not isToggleRow then
                applyProHover(obj)
            end
        end
        
        if obj.Size == UDim2.new(0, 14, 0, 14) or obj.Size == UDim2.new(0, 20, 0, 14) then
            addCorner(obj, 4)
            obj.BorderSizePixel = 0
            applyProHover(obj)
        end

        if obj:IsA("TextButton") and obj.Parent and obj.Parent.Name == "TabboxButtons" then
            addCorner(obj, 6)
            obj.BorderSizePixel = 0
            applyProHover(obj)
        end

        if obj:IsA("ScrollingFrame") then
            if isMobile then
                obj.ScrollBarThickness = 18
                obj.ScrollBarImageTransparency = 0.4
            else
                obj.ScrollBarThickness = 2
                obj.ScrollBarImageTransparency = 0.8
            end
        end
    end

    for _, child in ipairs(gui:GetDescendants()) do styleObj(child) end
    gui.DescendantAdded:Connect(function(child) task.wait() styleObj(child) end)
    
    pcall(function() Library:UpdateColorsUsingRegistry() end)
            local oldNotify = Library.Notify
    function Library:Notify(text, time)
        local result = oldNotify(self, text, time)
        if Library.IsMobile then
            task.spawn(function()
                task.wait(0.05)
                local guis = {}
                pcall(function() for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do table.insert(guis, g) end end)
                pcall(function() if game.Players.LocalPlayer then for _, g in ipairs(game.Players.LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do table.insert(guis, g) end end end)
                
                for _, gui in ipairs(guis) do
                    if gui:IsA("ScreenGui") then
                        for _, v in ipairs(gui:GetChildren()) do
                            if v:IsA("Frame") and v.BackgroundTransparency == 1 then
                                local list = v:FindFirstChildWhichIsA("UIListLayout")
                                if list and (list.VerticalAlignment == Enum.VerticalAlignment.Bottom or list.VerticalAlignment == Enum.VerticalAlignment.Top) then
                                    v.Position = UDim2.new(1, -15, 0, 15)
                                    v.AnchorPoint = Vector2.new(1, 0)
                                    list.VerticalAlignment = Enum.VerticalAlignment.Top
                                    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
                                end
                            end
                        end
                    end
                end
            end)
        end
        return result
    end
end

function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Close')
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    local ExtrasGroup = SettingsTab:AddRightGroupbox('Menu Extras')
    local wmToggle = ExtrasGroup:AddToggle('WatermarkToggle', {
        Text = 'Show Watermark', Default = false,
        Callback = function(v) Library:SetWatermarkVisibility(v) end
    })
    
    if not isMobile then
        ExtrasGroup:AddToggle('KeybindsToggle', {
            Text = 'Show Keybinds', Default = false,
            Callback = function(v) Library.KeybindFrame.Visible = v end
        })
    else
        pcall(function() if Library.KeybindFrame then Library.KeybindFrame:Destroy() end end)
    end
    
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:ApplyToTab(SettingsTab)
    
    if ThemeManager.Options and ThemeManager.Options.ThemeManager_ThemeList then
        ThemeManager:ApplyTheme('Mounx Default')
    end
    
    Library:SetWatermarkVisibility(false)
    if Library.WatermarkOuter then Library.WatermarkOuter.Visible = false end
    pcall(function() if Library.Options.VideoLink then Library.Options.VideoLink:SetVisible(false) end end)
    
    task.spawn(function()
                local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
                local gName = (ok and info) and info.Name or "Game"
        local pName = game.Players.LocalPlayer and game.Players.LocalPlayer.DisplayName or "User"
        
        if Library and not Library.Unloaded then
            Library:SetWatermark(string.format("Mounx | %s | %s | %d FPS", gName, pName, 0))
            Library:SetWatermarkVisibility(false)
            if Library.WatermarkOuter then Library.WatermarkOuter.Visible = false end
        end
        
        local RS = game:GetService("RunService")
        local frames = 0
        local lastTime = tick()
        local fps = 60
        
                RS.RenderStepped:Connect(function()
            frames = frames + 1
            if tick() - lastTime >= 1 then
                fps = frames
                frames = 0
                lastTime = tick()
            end
                                    if Library and not Library.Unloaded then
                if Library.WatermarkOuter and Library.WatermarkOuter.Visible then
                    Library:SetWatermark(string.format("Mounx | %s | %s | %d FPS", gName, pName, fps))
                end
            end
        end)
        
        Library:SetWatermarkVisibility(wmToggle.Value)
    end)
    
    task.spawn(function()
        ApplyMounxStyle(Library)
        -- ARREGLO DEL AUTOLOAD: Lo ejecutamos al final para que cargue la config si existe
        pcall(function() SaveManager:LoadAutoloadConfig() end)
        pcall(function() Library.ScreenGui.Enabled = true end)
    end)
end

return MounxHub








