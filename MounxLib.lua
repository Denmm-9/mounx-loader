local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

pcall(function() if Library.ScreenGui then Library.ScreenGui.Enabled = false end end)

-- ==================================================
-- MOUNX CUSTOM THEMES (V12)
-- ==================================================
ThemeManager.BuiltInThemes['Default'] = nil
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141419","AccentColor":"a855f7","BackgroundColor":"0a0a0f","OutlineColor":"0a0a0f"}') }

local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

-- Deteccion de Movil
local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled

--// ============================================================
--// MOUNX STYLE ENGINE (PREMIUM V12)
--// ============================================================
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

    local function applyProHover(obj)
        if not obj or obj:FindFirstChild("ProHover") then return end
        local stroke = Instance.new("UIStroke")
        stroke.Name = "ProHover"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Library.AccentColor or Color3.fromRGB(179, 102, 255)
        stroke.Thickness = 1.2
        stroke.Transparency = 1
        stroke.Parent = obj
        
        local tIn = TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.15})
        local tOut = TweenService:Create(stroke, TweenInfo.new(0.35), {Transparency = 1})

        obj.MouseEnter:Connect(function() tIn:Play() end)
        obj.MouseLeave:Connect(function() tOut:Play() end)
        obj.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tIn:Play() end end)
        obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tOut:Play() end end)
    end

    local function applyCheckboxGlow(circleObj)
        if not circleObj or circleObj:FindFirstChild("CheckGlow") then return end
        local glow = Instance.new("Frame")
        glow.Name = "CheckGlow"
        glow.Size = UDim2.new(1, 0, 1, 0)
        glow.BackgroundColor3 = Color3.new(1, 1, 1)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.ZIndex = circleObj.ZIndex + 2
        glow.Parent = circleObj
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = glow
        
        local tIn = TweenService:Create(glow, TweenInfo.new(0.15), {BackgroundTransparency = 0.85})
        local tOut = TweenService:Create(glow, TweenInfo.new(0.35), {BackgroundTransparency = 1})

        local parentRow = circleObj.Parent
        if parentRow and parentRow:IsA("TextLabel") then
            parentRow.MouseEnter:Connect(function() tIn:Play() end)
            parentRow.MouseLeave:Connect(function() tOut:Play() end)
            parentRow.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tIn:Play() end end)
            parentRow.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then tOut:Play() end end)
        end
    end

    if Library.WatermarkOuter then
        addCorner(Library.WatermarkOuter, 100)
        pcall(function() Library.WatermarkOuter.BorderSizePixel = 0 end)
        for _, inner in ipairs(Library.WatermarkOuter:GetDescendants()) do
            if inner:IsA("GuiObject") then addCorner(inner, 100); pcall(function() inner.BorderSizePixel = 0 end) end
        end
        if not Library.WatermarkOuter:FindFirstChild("WidgetGlow") then
            local glow = Instance.new("UIStroke")
            glow.Name = "WidgetGlow"
            glow.Color = Library.AccentColor
            glow.Thickness = 1.5
            glow.Transparency = 0.2
            glow.Parent = Library.WatermarkOuter
        end
    end
    
    if Library.KeybindFrame then
        addCorner(Library.KeybindFrame, 10)
        pcall(function() Library.KeybindFrame.BorderSizePixel = 0 end)
        for _, inner in ipairs(Library.KeybindFrame:GetDescendants()) do
            if inner:IsA("GuiObject") then addCorner(inner, 10); pcall(function() inner.BorderSizePixel = 0 end) end
        end
        if not Library.KeybindFrame:FindFirstChild("WidgetGlow") then
            local glow = Instance.new("UIStroke")
            glow.Name = "WidgetGlow"
            glow.Color = Library.AccentColor
            glow.Thickness = 1.5
            glow.Transparency = 0.2
            glow.Parent = Library.KeybindFrame
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
                        p = p.Parent
                    end
                end

                obj.Size = UDim2.new(1, 0, 1, 0) 
                if obj.Parent then obj.Parent.Size = UDim2.new(0, 100, 0, 26) end
                
                addCorner(obj, 100)
                obj.BorderSizePixel = 0
                obj.BackgroundColor3 = Library.MainColor
                obj.BackgroundTransparency = 0
                obj.TextColor3 = Color3.new(1,1,1)
                obj.Font = Enum.Font.GothamMedium
                pcall(function() obj.TextStrokeTransparency = 1 end)
                
                if not obj:FindFirstChild("MobileOutline") then
                    local stroke = Instance.new("UIStroke")
                    stroke.Name = "MobileOutline"
                    stroke.Color = Library.AccentColor
                    stroke.Thickness = 1.5
                    stroke.Transparency = 0
                    stroke.Parent = obj
                end
            end
        end

        if not obj:IsA("Frame") then return end
        local name = obj.Name

        if name == "Window" then
            addCorner(obj, Config.WindowRadius)
            obj.BorderSizePixel = 0
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

        if obj.Size == UDim2.new(0, 13, 0, 13) then
            addCorner(obj, 100)
            obj.BorderSizePixel = 0
            if not obj:FindFirstChild("CheckRing") then
                local ring = Instance.new("UIStroke")
                ring.Name = "CheckRing"
                ring.Color = Color3.new(0.3, 0.3, 0.3)
                ring.Thickness = 1
                ring.Transparency = 0.5
                ring.Parent = obj
            end
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") and inner.Name ~= "CheckRing" and inner.Name ~= "CheckGlow" then
                    addCorner(inner, 100)
                    inner.BorderSizePixel = 0
                end
            end
            if obj.Parent then
                local oldHover = obj.Parent:FindFirstChild("ProHover")
                if oldHover then oldHover:Destroy() end
            end
            applyCheckboxGlow(obj)
        end

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

        if obj.Size == UDim2.new(1, -4, 0, 20) or obj.Size == UDim2.new(1, -4, 0, 22) or obj.Size == UDim2.new(1, 0, 0, 20) then
            addCorner(obj, Config.ControlRadius)
            obj.BorderSizePixel = 0
            for _, inner in ipairs(obj:GetChildren()) do
                if inner:IsA("Frame") then addCorner(inner, Config.ControlRadius); inner.BorderSizePixel = 0 end
            end
            applyProHover(obj)
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
        pcall(function() if Library.KeybindFrame then Library.KeybindFrame.Visible = false end end)
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
        local pName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or "User"
        
        Library:SetWatermark(gName .. " | " .. pName .. " | Mounx")
        Library:SetWatermarkVisibility(wmToggle.Value)
    end)
    
    task.spawn(function()
        task.wait(0.1)
        ApplyMounxStyle(Library)
        pcall(function() Library.ScreenGui.Enabled = true end)
    end)
end

return MounxHub
