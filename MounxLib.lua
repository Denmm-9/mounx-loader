local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

pcall(function() if Library.ScreenGui then Library.ScreenGui.Enabled = false end end)

local HttpService = game:GetService("HttpService")

ThemeManager.BuiltInThemes['Default'] = nil
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, HttpService:JSONDecode('{"FontColor":"f0f0f8","MainColor":"12121a","AccentColor":"818cf8","BackgroundColor":"0c0d14","OutlineColor":"0c0d14"}') }
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
        local kf = Library.KeybindFrame
        
        -- Hide the original ugly frame completely
        kf.BackgroundTransparency = 1
        kf.BorderSizePixel = 0
        pcall(function() for _, c in ipairs(kf:GetChildren()) do c.Visible = false end end)
        
        -- Create a completely custom keybind overlay
        if not kf:FindFirstChild("MounxKBOverlay") then
            local overlay = Instance.new("Frame")
            overlay.Name = "MounxKBOverlay"
            overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
            overlay.BackgroundTransparency = 0.08
            overlay.BorderSizePixel = 0
            overlay.Size = UDim2.new(1, 10, 1, 10)
            overlay.Position = UDim2.new(0, -5, 0, -5)
            overlay.ZIndex = kf.ZIndex + 10
            overlay.ClipsDescendants = true
            overlay.Parent = kf
            addCorner(overlay, 10)
            
            -- Outer glow stroke
            local outerStroke = Instance.new("UIStroke")
            outerStroke.Name = "KBGlow"
            outerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            outerStroke.Thickness = 1
            outerStroke.Transparency = 0.6
            outerStroke.Parent = overlay
            Library:AddToRegistry(outerStroke, { Color = "AccentColor" })
            
            -- Background gradient (top to bottom fade)
            local bgGrad = Instance.new("UIGradient")
            bgGrad.Rotation = 180
            bgGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0),
                NumberSequenceKeypoint.new(1, 0.15),
            })
            bgGrad.Parent = overlay
            
            -- Top accent line (horizontal, faded edges)
            local accentLine = Instance.new("Frame")
            accentLine.Name = "AccentLine"
            accentLine.BackgroundColor3 = Library.AccentColor
            accentLine.BorderSizePixel = 0
            accentLine.Size = UDim2.new(1, -20, 0, 1)
            accentLine.Position = UDim2.new(0, 10, 0, 0)
            accentLine.ZIndex = overlay.ZIndex + 1
            accentLine.Parent = overlay
            Library:AddToRegistry(accentLine, { BackgroundColor3 = "AccentColor" })
            
            local lineGrad = Instance.new("UIGradient")
            lineGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.15, 0),
                NumberSequenceKeypoint.new(0.85, 0),
                NumberSequenceKeypoint.new(1, 1),
            })
            lineGrad.Parent = accentLine
            
            -- Title row
            local titleRow = Instance.new("Frame")
            titleRow.Name = "TitleRow"
            titleRow.BackgroundTransparency = 1
            titleRow.Size = UDim2.new(1, 0, 0, 22)
            titleRow.Position = UDim2.new(0, 0, 0, 4)
            titleRow.ZIndex = overlay.ZIndex + 2
            titleRow.Parent = overlay
            
            local titleIcon = Instance.new("TextLabel")
            titleIcon.Name = "TitleIcon"
            titleIcon.BackgroundTransparency = 1
            titleIcon.Size = UDim2.new(0, 22, 1, 0)
            titleIcon.Position = UDim2.new(0, 8, 0, 0)
            titleIcon.Font = Enum.Font.GothamBold
            titleIcon.Text = "//"
            titleIcon.TextSize = 10
            titleIcon.TextColor3 = Library.AccentColor
            titleIcon.TextXAlignment = Enum.TextXAlignment.Center
            titleIcon.ZIndex = overlay.ZIndex + 3
            titleIcon.Parent = titleRow
            Library:AddToRegistry(titleIcon, { TextColor3 = "AccentColor" })
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "TitleLabel"
            titleLabel.BackgroundTransparency = 1
            titleLabel.Size = UDim2.new(1, -35, 1, 0)
            titleLabel.Position = UDim2.new(0, 28, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.Text = "KEYBINDS"
            titleLabel.TextSize = 11
            titleLabel.TextColor3 = Color3.fromRGB(200, 200, 215)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.ZIndex = overlay.ZIndex + 3
            titleLabel.Parent = titleRow
            
            -- Separator under title
            local sep = Instance.new("Frame")
            sep.Name = "TitleSep"
            sep.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            sep.BorderSizePixel = 0
            sep.Size = UDim2.new(1, -20, 0, 1)
            sep.Position = UDim2.new(0, 10, 0, 26)
            sep.ZIndex = overlay.ZIndex + 2
            sep.Parent = overlay
            
            -- Container for keybind entries
            local entryContainer = Instance.new("Frame")
            entryContainer.Name = "EntryContainer"
            entryContainer.BackgroundTransparency = 1
            entryContainer.Size = UDim2.new(1, 0, 1, -30)
            entryContainer.Position = UDim2.new(0, 0, 0, 30)
            entryContainer.ZIndex = overlay.ZIndex + 2
            entryContainer.Parent = overlay
            
            local entryLayout = Instance.new("UIListLayout")
            entryLayout.SortOrder = Enum.SortOrder.LayoutOrder
            entryLayout.Padding = UDim.new(0, 2)
            entryLayout.Parent = entryContainer
            
            local entryPadding = Instance.new("UIPadding")
            entryPadding.PaddingLeft = UDim.new(0, 8)
            entryPadding.PaddingRight = UDim.new(0, 8)
            entryPadding.PaddingTop = UDim.new(0, 2)
            entryPadding.Parent = entryContainer
            
            -- Function to create a styled keybind entry
            local function createEntry(keyText, actionText, typeText)
                local row = Instance.new("Frame")
                row.Name = "KBEntry_" .. keyText
                row.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                row.BackgroundTransparency = 0.3
                row.BorderSizePixel = 0
                row.Size = UDim2.new(1, 0, 0, 22)
                row.ZIndex = overlay.ZIndex + 3
                row.Parent = entryContainer
                addCorner(row, 5)
                
                -- Key badge
                local badge = Instance.new("Frame")
                badge.Name = "KeyBadge"
                badge.BackgroundColor3 = Library.AccentColor
                badge.BackgroundTransparency = 0.75
                badge.BorderSizePixel = 0
                badge.Size = UDim2.new(0, 24, 0, 16)
                badge.Position = UDim2.new(0, 4, 0.5, -8)
                badge.ZIndex = overlay.ZIndex + 4
                badge.Parent = row
                addCorner(badge, 4)
                Library:AddToRegistry(badge, { BackgroundColor3 = "AccentColor" })
                
                local badgeText = Instance.new("TextLabel")
                badgeText.Name = "BadgeText"
                badgeText.BackgroundTransparency = 1
                badgeText.Size = UDim2.new(1, 0, 1, 0)
                badgeText.Font = Enum.Font.GothamBold
                badgeText.Text = keyText
                badgeText.TextSize = 10
                badgeText.TextColor3 = Library.AccentColor
                badgeText.ZIndex = overlay.ZIndex + 5
                badgeText.Parent = badge
                Library:AddToRegistry(badgeText, { TextColor3 = "AccentColor" })
                
                -- Action name
                local actionLabel = Instance.new("TextLabel")
                actionLabel.Name = "ActionLabel"
                actionLabel.BackgroundTransparency = 1
                actionLabel.Size = UDim2.new(1, -75, 1, 0)
                actionLabel.Position = UDim2.new(0, 34, 0, 0)
                actionLabel.Font = Enum.Font.GothamMedium
                actionLabel.Text = actionText
                actionLabel.TextSize = 11
                actionLabel.TextColor3 = Color3.fromRGB(185, 185, 200)
                actionLabel.TextXAlignment = Enum.TextXAlignment.Left
                actionLabel.TextTruncate = Enum.TextTruncate.AtEnd
                actionLabel.ZIndex = overlay.ZIndex + 5
                actionLabel.Parent = row
                
                -- Type indicator (Toggle/Hold)
                local typeLabel = Instance.new("TextLabel")
                typeLabel.Name = "TypeLabel"
                typeLabel.BackgroundTransparency = 1
                typeLabel.Size = UDim2.new(0, 38, 0, 14)
                typeLabel.Position = UDim2.new(1, -42, 0.5, -7)
                typeLabel.Font = Enum.Font.Gotham
                typeLabel.Text = typeText
                typeLabel.TextSize = 9
                typeLabel.ZIndex = overlay.ZIndex + 5
                typeLabel.Parent = row
                
                if typeText == "Hold" then
                    typeLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
                else
                    typeLabel.TextColor3 = Library.AccentColor
                    Library:AddToRegistry(typeLabel, { TextColor3 = "AccentColor" })
                end
                
                return row
            end
            
            -- Function to sync overlay with LinoriaLib keybind data
            local function syncKeybinds()
                -- Clear old entries
                for _, child in ipairs(entryContainer:GetChildren()) do
                    if child:IsA("Frame") and child.Name:find("KBEntry_") then
                        child:Destroy()
                    end
                end
                
                -- Parse original keybind labels from LinoriaLib
                for _, child in ipairs(kf:GetChildren()) do
                    if child:IsA("TextLabel") and child.Name ~= "Title" then
                        local raw = child.Text or ""
                        -- LinoriaLib format: "  [V] Trajectory Curve (Toggle)"
                        local key, action, ktype = raw:match("%[(.-)%]%s*(.-)%s*%((.-)%)")
                        if key and action and ktype then
                            createEntry(key, action, ktype)
                        end
                    end
                end
                
                -- Resize overlay to fit content
                task.wait(0.05)
                local contentHeight = entryLayout.AbsoluteContentSize.Y + 38
                overlay.Size = UDim2.new(1, 10, 0, math.max(contentHeight, 40))
            end
            
            -- Initial sync + listen for changes
            task.delay(0.2, syncKeybinds)
            kf.ChildAdded:Connect(function() task.wait(0.1) syncKeybinds() end)
            kf.ChildRemoved:Connect(function() task.wait(0.1) syncKeybinds() end)
            
            -- Also re-sync when text changes on existing labels
            task.spawn(function()
                while task.wait(1) do
                    if kf and kf.Parent then
                        syncKeybinds()
                    else
                        break
                    end
                end
            end)
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

        for _, child in ipairs(gui:GetDescendants()) do 
        styleObj(child) 
        local v = child
        if v:IsA("ScrollingFrame") and v.CanvasSize == UDim2.new(0, 0, 2, 0) then
            local function updateTabs()
                for _, btn in ipairs(v:GetChildren()) do
                    if btn:IsA("Frame") and btn.Name == "Frame" then
                        local isBlockerVisible = false
                        for _, c in ipairs(btn:GetChildren()) do
                            if c:IsA("Frame") and c.Size == UDim2.new(1, 0, 0, 1) and c.BackgroundTransparency == 0 then
                                isBlockerVisible = true
                            end
                        end
                        
                        local title = btn:FindFirstChildWhichIsA("TextLabel")
                        
                        if isBlockerVisible or btn.BackgroundColor3 == Library.MainColor then
                            if title then title.TextColor3 = Library.AccentColor end
                        else
                            if title then title.TextColor3 = Library.FontColor end
                        end
                        
                        if not btn:GetAttribute("Hooked") then
                            btn:SetAttribute("Hooked", true)
                            btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                                if not btn:GetAttribute("Updating") then
                                    btn:SetAttribute("Updating", true)
                                    updateTabs()
                                    btn:SetAttribute("Updating", false)
                                end
                            end)
                        end
                    end
                end
            end
            v.ChildAdded:Connect(updateTabs)
            task.delay(0.1, updateTabs)
        end
        

    end
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

function MounxHub:BuildServerTab(ServerTab)
    local SrvInfoBox = ServerTab:AddLeftGroupbox('Server Info')
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown Game"
    SrvInfoBox:AddLabel('Game: ' .. gameName)
    local lblPlayers = SrvInfoBox:AddLabel('Players: ' .. #game.Players:GetPlayers() .. '/' .. game.Players.MaxPlayers)
    local jobIdStr = (game.JobId ~= "" and game.JobId:sub(1,8).."...") or "Private/Studio"
    SrvInfoBox:AddLabel('JobId: ' .. jobIdStr)
    
    local SrvHopBox = ServerTab:AddRightGroupbox('Server Hop')
    SrvHopBox:AddDropdown('ServerListDrop', { Values = {"Fetching servers..."}, Default = 1, Multi = false, Text = 'Public Servers' })
    local actualJobIds = {}
    
    SrvHopBox:AddButton('Refresh Servers', function()
        Library.Options.ServerListDrop:SetValues({"Fetching..."})
        Library.Options.ServerListDrop:SetValue("Fetching...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local req = (request or http_request or (syn and syn.request))
            local placeId = game.PlaceId
            local urls = {
                "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100",
                "https://games.roproxy.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
            }
            
            local finalData = nil
            for _, url in ipairs(urls) do
                local success, result = pcall(function()
                    if req then return req({Url = url, Method = "GET"}).Body
                    else return game:HttpGet(url) end
                end)
                
                if success and result then
                    local s, data = pcall(function() return HttpService:JSONDecode(result) end)
                    if s and data and data.data then
                        finalData = data; break
                    end
                end
            end
            
            if finalData then
                local list = {}
                actualJobIds = {}
                local count = 1
                for _, srv in ipairs(finalData.data) do
                    if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                        local p = srv.ping and math.floor(srv.ping) or "?"
                        local srvName = "Srv #" .. count .. " [" .. srv.playing .. "/" .. srv.maxPlayers .. "] | Ping: " .. p .. "ms"
                        while actualJobIds[srvName] do srvName = srvName .. " " end
                        table.insert(list, srvName)
                        actualJobIds[srvName] = srv.id
                        count = count + 1
                    end
                end
                if #list > 0 then
                    Library.Options.ServerListDrop:SetValues(list)
                    Library.Options.ServerListDrop:SetValue(list[1])
                else
                    Library.Options.ServerListDrop:SetValues({"No servers found"})
                    Library.Options.ServerListDrop:SetValue("No servers found")
                end
            else
                Library.Options.ServerListDrop:SetValues({"API Blocked/Down"})
                Library.Options.ServerListDrop:SetValue("API Blocked/Down")
            end
        end)
    end)
    
    SrvHopBox:AddButton('Teleport', function()
        local selected = Library.Options.ServerListDrop.Value
        if actualJobIds[selected] then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, actualJobIds[selected], game.Players.LocalPlayer)
        end
    end)
    
    SrvHopBox:AddButton('Rejoin Current', function()
        local ts = game:GetService("TeleportService")
        local p = game.Players.LocalPlayer
        if #game.Players:GetPlayers() <= 1 then
            ts:Teleport(game.PlaceId, p)
        else
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
        end
    end)
    
    local SrvMiscBox = ServerTab:AddLeftGroupbox('Misc')
    SrvMiscBox:AddToggle('AntiAFKMounx', { Text = 'Anti-AFK', Default = false, Tooltip = 'Prevents the 20-minute idle kick.' })
    Library.Toggles.AntiAFKMounx:OnChanged(function()
        if Library.Toggles.AntiAFKMounx.Value then
            pcall(function() for _,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end end)
        else
            pcall(function() for _,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Enable() end end)
        end
    end)
    
    SrvMiscBox:AddToggle('AutoExecuteTPMounx', { Text = 'Auto-Execute on TP', Default = false, Tooltip = 'Automatically injects the script when changing servers.' })
    Library.Toggles.AutoExecuteTPMounx:OnChanged(function()
        if Library.Toggles.AutoExecuteTPMounx.Value then
            local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
            if qot then
                local autoCode = getgenv().MounxAutoExecCode or [[
                    task.wait(3)
                    pcall(function()
                        if isfile and isfile("MounxLoader.lua") then
                            loadstring(readfile("MounxLoader.lua"))()
                        else
                            game.StarterGui:SetCore("SendNotification", {
                                Title = "Mounx Auto-Execute",
                                Text = "If using a Loader, define getgenv().MounxAutoExecCode in your base script.",
                                Duration = 10
                            })
                        end
                    end)
                ]]
                qot(autoCode)
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(5) do
            if lblPlayers then
                pcall(function() lblPlayers:SetText('Players: ' .. #game.Players:GetPlayers() .. '/' .. game.Players.MaxPlayers) end)
            end
        end
    end)
end

function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Close')
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'X', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    local ExtrasGroup = SettingsTab:AddRightGroupbox('Menu Extras')
    local wmToggle = ExtrasGroup:AddToggle('WatermarkToggle', {
        Text = 'Show Watermark', Default = false,
        Callback = function(v) Library:SetWatermarkVisibility(v) end
    })
    
    if not isMobile then
        ExtrasGroup:AddToggle('KeybindsToggle', {
            Text = 'Show Keybinds', Default = false,
            Callback = function(v) 
                local kf = Library.KeybindFrame
                if not kf then return end
                local ts = game:GetService("TweenService")
                if v then
                    kf.Visible = true
                    kf.BackgroundTransparency = 1
                    ts:Create(kf, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
                    for _, c in ipairs(kf:GetChildren()) do
                        if c:IsA("TextLabel") then
                            c.TextTransparency = 1
                            ts:Create(c, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
                        end
                    end
                else
                    ts:Create(kf, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                    for _, c in ipairs(kf:GetChildren()) do
                        if c:IsA("TextLabel") then
                            ts:Create(c, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                        end
                    end
                    task.delay(0.25, function() if not Library.Toggles.KeybindsToggle.Value then kf.Visible = false end end)
                end
            end
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
        local RunService = game:GetService("RunService")
        
        -- FPS counter (safe: updates every 0.5s, NOT every frame)
        local frameCount = 0
        local currentFPS = 0
        local lastTime = tick()
        
        RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
        end)
        
        -- Update watermark with FPS every 0.5 seconds
        task.spawn(function()
            while not Library.Unloaded do
                task.wait(0.5)
                local now = tick()
                local delta = now - lastTime
                if delta > 0 then
                    currentFPS = math.floor(frameCount / delta)
                end
                frameCount = 0
                lastTime = now
                
                pcall(function()
                    if Library and not Library.Unloaded then
                        local text = "Mounx | " .. tostring(gName) .. " | " .. tostring(pName) .. " | " .. tostring(currentFPS) .. " FPS"
                        Library:SetWatermark(text)
                    end
                end)
            end
        end)
        
        -- Initial set
        if Library and not Library.Unloaded then
            local text = "Mounx | " .. tostring(gName) .. " | " .. tostring(pName) .. " | 0 FPS"
            pcall(function() Library:SetWatermark(text) end)
            pcall(function() Library:SetWatermarkVisibility(wmToggle.Value) end)
            pcall(function() if Library.WatermarkOuter then Library.WatermarkOuter.Visible = wmToggle.Value end end)
        end
    end)
    
    task.spawn(function()
        ApplyMounxStyle(Library)
        -- AUTOLOAD FIX: Execute at the end to load config if exists
        pcall(function() SaveManager:LoadAutoloadConfig() end)
        pcall(function() Library.ScreenGui.Enabled = true end)
    end)
end

return MounxHub








