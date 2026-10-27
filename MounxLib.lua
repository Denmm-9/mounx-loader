local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

pcall(function() if Library.ScreenGui then Library.ScreenGui.Enabled = false end end)

local HttpService = game:GetService("HttpService")

ThemeManager.BuiltInThemes['Default'] = nil
ThemeManager.BuiltInThemes['Mounx Default'] = { 1, HttpService:JSONDecode('{"FontColor":"f5edf0","MainColor":"1a1018","AccentColor":"ff6b9d","BackgroundColor":"110a10","OutlineColor":"110a10"}') }
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
        
        -- ============================================================
        -- CUSTOM KEYBIND PANEL (fully replaces LinoriaLib's default)
        -- ============================================================
        local mxKB = Instance.new("Frame")
        mxKB.Name = "MounxKB"
        mxKB.BackgroundColor3 = Color3.fromRGB(14, 11, 18)
        mxKB.BackgroundTransparency = 0
        mxKB.BorderSizePixel = 0
        mxKB.Size = UDim2.new(0, 200, 0, 0)
        mxKB.AutomaticSize = Enum.AutomaticSize.Y
        mxKB.Position = kf.Position
        mxKB.AnchorPoint = kf.AnchorPoint
        mxKB.Visible = false
        mxKB.ZIndex = 200
        mxKB.ClipsDescendants = true
        mxKB.Parent = kf.Parent
        addCorner(mxKB, 10)
        
        -- Sync position if kf moves
        pcall(function()
            kf:GetPropertyChangedSignal("Position"):Connect(function()
                mxKB.Position = kf.Position
            end)
        end)
        
        -- >> Outer accent stroke
        local mxStroke = Instance.new("UIStroke")
        mxStroke.Name = "OuterStroke"
        mxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        mxStroke.Thickness = 1
        mxStroke.Transparency = 0.45
        mxStroke.Parent = mxKB
        Library:AddToRegistry(mxStroke, { Color = "AccentColor" })
        
        -- >> Top accent glow bar
        local topBar = Instance.new("Frame")
        topBar.Name = "TopBar"
        topBar.BackgroundColor3 = Library.AccentColor
        topBar.BorderSizePixel = 0
        topBar.Size = UDim2.new(1, 0, 0, 2)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.ZIndex = mxKB.ZIndex + 15
        topBar.Parent = mxKB
        Library:AddToRegistry(topBar, { BackgroundColor3 = "AccentColor" })
        
        local topBarGrad = Instance.new("UIGradient")
        topBarGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.12, 0.15),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.88, 0.15),
            NumberSequenceKeypoint.new(1, 1),
        })
        topBarGrad.Parent = topBar
        
        -- >> Soft glow haze under top bar
        local haze = Instance.new("Frame")
        haze.Name = "GlowHaze"
        haze.BackgroundColor3 = Library.AccentColor
        haze.BackgroundTransparency = 0.88
        haze.BorderSizePixel = 0
        haze.Size = UDim2.new(1, 0, 0, 28)
        haze.Position = UDim2.new(0, 0, 0, 0)
        haze.ZIndex = mxKB.ZIndex
        haze.Parent = mxKB
        Library:AddToRegistry(haze, { BackgroundColor3 = "AccentColor" })
        
        local hazeGrad = Instance.new("UIGradient")
        hazeGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
        hazeGrad.Rotation = 90
        hazeGrad.Parent = haze
        
        -- >> Content container (holds title + entries via UIListLayout)
        local content = Instance.new("Frame")
        content.Name = "Content"
        content.BackgroundTransparency = 1
        content.Size = UDim2.new(1, 0, 0, 0)
        content.AutomaticSize = Enum.AutomaticSize.Y
        content.ZIndex = mxKB.ZIndex + 1
        content.Parent = mxKB
        
        local contentPad = Instance.new("UIPadding")
        contentPad.PaddingTop = UDim.new(0, 7)
        contentPad.PaddingBottom = UDim.new(0, 7)
        contentPad.PaddingLeft = UDim.new(0, 6)
        contentPad.PaddingRight = UDim.new(0, 6)
        contentPad.Parent = content
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 3)
        contentLayout.Parent = content
        
        -- >> Header row: pulsing dot + title
        local headerRow = Instance.new("Frame")
        headerRow.Name = "Header"
        headerRow.BackgroundTransparency = 1
        headerRow.Size = UDim2.new(1, 0, 0, 16)
        headerRow.LayoutOrder = 0
        headerRow.ZIndex = content.ZIndex + 2
        headerRow.Parent = content
        
        local titleDot = Instance.new("Frame")
        titleDot.Name = "Dot"
        titleDot.BackgroundColor3 = Library.AccentColor
        titleDot.Size = UDim2.new(0, 5, 0, 5)
        titleDot.Position = UDim2.new(0, 2, 0.5, -2)
        titleDot.BorderSizePixel = 0
        titleDot.ZIndex = content.ZIndex + 3
        titleDot.Parent = headerRow
        addCorner(titleDot, 100)
        Library:AddToRegistry(titleDot, { BackgroundColor3 = "AccentColor" })
        
        -- Pulsing animation on the dot
        task.spawn(function()
            while mxKB and mxKB.Parent do
                TweenService:Create(titleDot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
                task.wait(1.2)
                if not mxKB or not mxKB.Parent then break end
                TweenService:Create(titleDot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
                task.wait(1.2)
            end
        end)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, -14, 1, 0)
        titleLabel.Position = UDim2.new(0, 13, 0, 0)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 11
        titleLabel.TextColor3 = Color3.fromRGB(215, 210, 230)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = "Keybinds"
        titleLabel.ZIndex = content.ZIndex + 3
        titleLabel.Parent = headerRow
        
        -- >> Gradient separator under header
        local sep = Instance.new("Frame")
        sep.Name = "Separator"
        sep.BackgroundColor3 = Color3.fromRGB(50, 44, 68)
        sep.BackgroundTransparency = 0.2
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.LayoutOrder = 1
        sep.BorderSizePixel = 0
        sep.ZIndex = content.ZIndex + 1
        sep.Parent = content
        
        local sepGrad = Instance.new("UIGradient")
        sepGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0),
            NumberSequenceKeypoint.new(0.85, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
        sepGrad.Parent = sep
        
        -- ======================
        -- ENTRY BUILDER (with active/inactive state)
        -- ======================
        local function createEntry(keyStr, actionName, typeName, isActive, order)
            local isOdd = (order % 2 == 1)
            
            local entry = Instance.new("Frame")
            entry.Name = "KBEntry"
            entry.BorderSizePixel = 0
            entry.Size = UDim2.new(1, 0, 0, 26)
            entry.LayoutOrder = order + 10
            entry.ZIndex = content.ZIndex + 4
            entry.Parent = content
            entry:SetAttribute("IsEntry", true)
            addCorner(entry, 6)
            
            -- Colors based on state
            if isActive then
                entry.BackgroundColor3 = isOdd and Color3.fromRGB(22, 18, 30) or Color3.fromRGB(26, 22, 36)
                entry.BackgroundTransparency = 0
            else
                entry.BackgroundColor3 = Color3.fromRGB(30, 26, 40)
                entry.BackgroundTransparency = 0
            end
            
            -- Left accent bar (visible only when active)
            local leftBar = Instance.new("Frame")
            leftBar.Name = "LeftBar"
            leftBar.BorderSizePixel = 0
            leftBar.Size = UDim2.new(0, 2, 0.5, 0)
            leftBar.Position = UDim2.new(0, 3, 0.25, 0)
            leftBar.ZIndex = entry.ZIndex + 1
            leftBar.Parent = entry
            addCorner(leftBar, 2)
            
            if isActive then
                leftBar.BackgroundColor3 = Library.AccentColor
                leftBar.BackgroundTransparency = 0
                Library:AddToRegistry(leftBar, { BackgroundColor3 = "AccentColor" })
            else
                leftBar.BackgroundColor3 = Color3.fromRGB(70, 62, 90)
                leftBar.BackgroundTransparency = 0
            end
            
            -- Key badge
            local badgeW = math.max(22, #keyStr * 8 + 12)
            local badge = Instance.new("Frame")
            badge.Name = "KeyBadge"
            badge.BorderSizePixel = 0
            badge.Size = UDim2.new(0, badgeW, 0, 16)
            badge.Position = UDim2.new(0, 10, 0.5, -8)
            badge.ZIndex = entry.ZIndex + 2
            badge.Parent = entry
            addCorner(badge, 4)
            
            local bStroke = Instance.new("UIStroke")
            bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            bStroke.Thickness = 1
            bStroke.Parent = badge
            
            local keyText = Instance.new("TextLabel")
            keyText.Name = "KeyText"
            keyText.BackgroundTransparency = 1
            keyText.Size = UDim2.new(1, 0, 1, 0)
            keyText.Font = Enum.Font.GothamBold
            keyText.TextSize = 9
            keyText.Text = keyStr
            keyText.ZIndex = entry.ZIndex + 3
            keyText.Parent = badge
            
            if isActive then
                badge.BackgroundColor3 = Library.AccentColor
                badge.BackgroundTransparency = 0.78
                bStroke.Transparency = 0.4
                bStroke.Color = Library.AccentColor
                keyText.TextColor3 = Library.AccentColor
                Library:AddToRegistry(badge, { BackgroundColor3 = "AccentColor" })
                Library:AddToRegistry(bStroke, { Color = "AccentColor" })
                Library:AddToRegistry(keyText, { TextColor3 = "AccentColor" })
            else
                badge.BackgroundColor3 = Color3.fromRGB(55, 48, 72)
                badge.BackgroundTransparency = 0.1
                bStroke.Transparency = 0.45
                bStroke.Color = Color3.fromRGB(90, 80, 115)
                keyText.TextColor3 = Color3.fromRGB(145, 135, 170)
            end
            
            -- Type tag pill (right side)
            local typeTagW = 0
            if typeName ~= "" then
                typeTagW = math.max(36, #typeName * 5 + 14)
                local typeTag = Instance.new("Frame")
                typeTag.Name = "TypeTag"
                typeTag.BorderSizePixel = 0
                typeTag.Size = UDim2.new(0, typeTagW, 0, 12)
                typeTag.Position = UDim2.new(1, -(typeTagW + 6), 0.5, -6)
                typeTag.ZIndex = entry.ZIndex + 2
                typeTag.Parent = entry
                addCorner(typeTag, 3)
                
                local typeLabel = Instance.new("TextLabel")
                typeLabel.BackgroundTransparency = 1
                typeLabel.Size = UDim2.new(1, 0, 1, 0)
                typeLabel.Font = Enum.Font.Gotham
                typeLabel.TextSize = 7
                typeLabel.ZIndex = entry.ZIndex + 3
                typeLabel.Parent = typeTag
                
                if isActive then
                    if typeName == "Toggle" then
                        typeTag.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
                        typeTag.BackgroundTransparency = 0.15
                        typeLabel.TextColor3 = Color3.fromRGB(80, 200, 115)
                        typeLabel.Text = "ON"
                    elseif typeName == "Hold" then
                        typeTag.BackgroundColor3 = Color3.fromRGB(45, 35, 18)
                        typeTag.BackgroundTransparency = 0.15
                        typeLabel.TextColor3 = Color3.fromRGB(220, 170, 60)
                        typeLabel.Text = "Held"
                    else
                        typeTag.BackgroundColor3 = Library.AccentColor
                        typeTag.BackgroundTransparency = 0.8
                        typeLabel.TextColor3 = Library.AccentColor
                        typeLabel.Text = typeName
                        Library:AddToRegistry(typeTag, { BackgroundColor3 = "AccentColor" })
                        Library:AddToRegistry(typeLabel, { TextColor3 = "AccentColor" })
                    end
                else
                    typeTag.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
                    typeTag.BackgroundTransparency = 0
                    typeLabel.TextColor3 = Color3.fromRGB(130, 120, 160)
                    if typeName == "Toggle" then
                        typeLabel.Text = "Toggle"
                    elseif typeName == "Hold" then
                        typeLabel.Text = "Hold"
                    else
                        typeLabel.Text = typeName
                    end
                end
            end
            
            -- Action name
            local actionLabel = Instance.new("TextLabel")
            actionLabel.Name = "ActionText"
            actionLabel.BackgroundTransparency = 1
            actionLabel.Size = UDim2.new(1, -(badgeW + 18 + (typeTagW > 0 and typeTagW + 12 or 6)), 1, 0)
            actionLabel.Position = UDim2.new(0, badgeW + 16, 0, 0)
            actionLabel.Font = Enum.Font.GothamMedium
            actionLabel.TextSize = 10
            actionLabel.TextXAlignment = Enum.TextXAlignment.Left
            actionLabel.TextTruncate = Enum.TextTruncate.AtEnd
            actionLabel.Text = actionName
            actionLabel.ZIndex = entry.ZIndex + 3
            actionLabel.Parent = entry
            
            if isActive then
                actionLabel.TextColor3 = Color3.fromRGB(220, 215, 235)
            else
                actionLabel.TextColor3 = Color3.fromRGB(155, 145, 180)
            end
            
            -- Active glow stroke on entry
            if isActive then
                local activeGlow = Instance.new("UIStroke")
                activeGlow.Name = "ActiveGlow"
                activeGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                activeGlow.Thickness = 1
                activeGlow.Transparency = 0.6
                activeGlow.Parent = entry
                Library:AddToRegistry(activeGlow, { Color = "AccentColor" })
            end
            
            -- Hover effect
            local hGlow = Instance.new("UIStroke")
            hGlow.Name = "HoverGlow"
            hGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            hGlow.Thickness = 1
            hGlow.Transparency = 1
            hGlow.Parent = entry
            Library:AddToRegistry(hGlow, { Color = "AccentColor" })
            
            entry.MouseEnter:Connect(function()
                TweenService:Create(hGlow, TweenInfo.new(0.12), {Transparency = 0.3}):Play()
            end)
            entry.MouseLeave:Connect(function()
                TweenService:Create(hGlow, TweenInfo.new(0.2), {Transparency = 1}):Play()
            end)
            
            return entry
        end
        
        -- ======================
        -- SYNC ENGINE v2 — live entry table, in-place state updates
        -- ======================
        local ACCENT = Library.AccentColor

        -- Gather all KeyPicker options from Library.Options
        -- Filters out the menu keybind (should never appear in the panel)
        local function collectKPs()
            local list = {}
            local menuKeyName = nil
            pcall(function()
                -- Detect menu key option name
                if Library.MenuKeyOption then
                    menuKeyName = Library.MenuKeyOption
                end
            end)
            pcall(function()
                for optName, opt in pairs(Library.Options) do
                    pcall(function()
                        local kp = nil
                        if opt and opt.Type == "KeyPicker" then
                            kp = opt
                        elseif opt and opt.KeyPicker then
                            kp = opt.KeyPicker
                        end
                        if kp then
                            local keyVal = kp.Value
                            local lowerName = optName:lower()
                            -- Skip the menu keybind entirely
                            local isMenuKey = lowerName:find("menu") ~= nil
                                and (lowerName:find("key") ~= nil or lowerName:find("bind") ~= nil or lowerName:find("toggle") ~= nil)
                            if isMenuKey then return end
                            if menuKeyName and optName == menuKeyName then return end
                            if keyVal and tostring(keyVal) ~= "" and tostring(keyVal) ~= "None" and tostring(keyVal) ~= "Unknown" then
                                table.insert(list, { kp = kp, optName = optName })
                            end
                        end
                    end)
                end
            end)
            return list
        end

        -- Resolve the active state of a KeyPicker correctly per mode
        local function resolveActive(kp, optName)
            local mode = (kp.Mode or "Toggle")
            -- Always mode: always shown as active
            if mode == "Always" then return true end
            -- Hold mode: ONLY active while the key is physically held (kp.Toggled = true during hold)
            -- Do NOT check Library.Toggles for Hold — that would show wrong state
            if mode == "Hold" then
                return kp.Toggled == true
            end
            -- Toggle mode: check kp.Toggled first, then find the linked toggle
            if kp.Toggled == true then return true end
            local linkedName = optName:gsub("Key$", ""):gsub("Keybind$", ""):gsub("KB$", "")
            if Library.Toggles then
                -- Exact match on stripped name
                if Library.Toggles[linkedName] and Library.Toggles[linkedName].Value == true then
                    return true
                end
                -- Prefix match: "SpeedKey" -> find toggle whose name is inside optName
                for tName, tog in pairs(Library.Toggles) do
                    if tName ~= "" and linkedName ~= "" then
                        if optName:find(tName, 1, true) or tName:find(linkedName, 1, true) then
                            if tog.Value == true then return true end
                        end
                    end
                end
            end
            return false
        end

        -- Apply visual state to an existing entry frame IN-PLACE (no destroy/recreate)
        local function applyEntryState(entry, isActive)
            if not entry or not entry.Parent then return end
            pcall(function()
                -- Background
                if isActive then
                    TweenService:Create(entry, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(26, 20, 36),
                        BackgroundTransparency = 0
                    }):Play()
                else
                    TweenService:Create(entry, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(30, 26, 40),
                        BackgroundTransparency = 0
                    }):Play()
                end

                local leftBar = entry:FindFirstChild("LeftBar")
                if leftBar then
                    if isActive then
                        TweenService:Create(leftBar, TweenInfo.new(0.18), {
                            BackgroundColor3 = ACCENT,
                            BackgroundTransparency = 0
                        }):Play()
                    else
                        TweenService:Create(leftBar, TweenInfo.new(0.18), {
                            BackgroundColor3 = Color3.fromRGB(70, 62, 90),
                            BackgroundTransparency = 0
                        }):Play()
                    end
                end

                local badge = entry:FindFirstChild("KeyBadge")
                if badge then
                    local stroke = badge:FindFirstChildOfClass("UIStroke")
                    local keyTxt = badge:FindFirstChild("KeyText")
                    if isActive then
                        TweenService:Create(badge, TweenInfo.new(0.18), {
                            BackgroundColor3 = ACCENT,
                            BackgroundTransparency = 0.78
                        }):Play()
                        if stroke then
                            TweenService:Create(stroke, TweenInfo.new(0.18), {
                                Color = ACCENT, Transparency = 0.4
                            }):Play()
                        end
                        if keyTxt then
                            TweenService:Create(keyTxt, TweenInfo.new(0.18), {
                                TextColor3 = ACCENT
                            }):Play()
                        end
                    else
                        TweenService:Create(badge, TweenInfo.new(0.18), {
                            BackgroundColor3 = Color3.fromRGB(55, 48, 72),
                            BackgroundTransparency = 0.1
                        }):Play()
                        if stroke then
                            TweenService:Create(stroke, TweenInfo.new(0.18), {
                                Color = Color3.fromRGB(90, 80, 115), Transparency = 0.45
                            }):Play()
                        end
                        if keyTxt then
                            TweenService:Create(keyTxt, TweenInfo.new(0.18), {
                                TextColor3 = Color3.fromRGB(145, 135, 170)
                            }):Play()
                        end
                    end
                end

                local typeTag = entry:FindFirstChild("TypeTag")
                if typeTag then
                    local typeLbl = typeTag:FindFirstChildOfClass("TextLabel")
                    local mode = entry:GetAttribute("Mode") or "Toggle"
                    if isActive then
                        if mode == "Toggle" then
                            TweenService:Create(typeTag, TweenInfo.new(0.18), {
                                BackgroundColor3 = Color3.fromRGB(25, 45, 30),
                                BackgroundTransparency = 0.15
                            }):Play()
                            if typeLbl then
                                TweenService:Create(typeLbl, TweenInfo.new(0.18), {
                                    TextColor3 = Color3.fromRGB(80, 200, 115)
                                }):Play()
                                typeLbl.Text = "ON"
                            end
                        elseif mode == "Hold" then
                            TweenService:Create(typeTag, TweenInfo.new(0.18), {
                                BackgroundColor3 = Color3.fromRGB(45, 35, 18),
                                BackgroundTransparency = 0.15
                            }):Play()
                            if typeLbl then
                                TweenService:Create(typeLbl, TweenInfo.new(0.18), {
                                    TextColor3 = Color3.fromRGB(220, 170, 60)
                                }):Play()
                                typeLbl.Text = "Held"
                            end
                        else
                            TweenService:Create(typeTag, TweenInfo.new(0.18), {
                                BackgroundColor3 = ACCENT,
                                BackgroundTransparency = 0.8
                            }):Play()
                            if typeLbl then
                                TweenService:Create(typeLbl, TweenInfo.new(0.18), {
                                    TextColor3 = ACCENT
                                }):Play()
                            end
                        end
                    else
                        TweenService:Create(typeTag, TweenInfo.new(0.18), {
                            BackgroundColor3 = Color3.fromRGB(45, 40, 60),
                            BackgroundTransparency = 0
                        }):Play()
                        if typeLbl then
                            TweenService:Create(typeLbl, TweenInfo.new(0.18), {
                                TextColor3 = Color3.fromRGB(130, 120, 160)
                            }):Play()
                            if mode == "Toggle" then typeLbl.Text = "Toggle"
                            elseif mode == "Hold" then typeLbl.Text = "Hold"
                            end
                        end
                    end
                end

                local actionLbl = entry:FindFirstChild("ActionText")
                if actionLbl then
                    if isActive then
                        TweenService:Create(actionLbl, TweenInfo.new(0.18), {
                            TextColor3 = Color3.fromRGB(220, 215, 235)
                        }):Play()
                    else
                        TweenService:Create(actionLbl, TweenInfo.new(0.18), {
                            TextColor3 = Color3.fromRGB(155, 145, 180)
                        }):Play()
                    end
                end

                local activeGlow = entry:FindFirstChild("ActiveGlow")
                if isActive then
                    if not activeGlow then
                        activeGlow = Instance.new("UIStroke")
                        activeGlow.Name = "ActiveGlow"
                        activeGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        activeGlow.Thickness = 1
                        activeGlow.Transparency = 1
                        activeGlow.Color = ACCENT
                        activeGlow.Parent = entry
                    end
                    TweenService:Create(activeGlow, TweenInfo.new(0.18), { Transparency = 0.6 }):Play()
                else
                    if activeGlow then
                        TweenService:Create(activeGlow, TweenInfo.new(0.18), { Transparency = 1 }):Play()
                    end
                end
            end)
        end

        -- Live entry map: optName -> frame (persists across state updates)
        local liveEntries = {}
        local kpConnections = {}
        -- Tracks Hold keybinds for fast polling: { optName = { kp=kp } }
        local holdEntries = {}

        local function buildEntries()
            -- Clear removed entries
            for name, frame in pairs(liveEntries) do
                if not frame or not frame.Parent then
                    liveEntries[name] = nil
                end
            end

            local kps = collectKPs()
            local seen = {}

            for i, item in ipairs(kps) do
                local kp = item.kp
                local oName = item.optName
                local keyVal = tostring(kp.Value)
                local mode = kp.Mode or "Toggle"
                local label = kp.Text or oName
                local isActive = resolveActive(kp, oName)
                seen[oName] = true

                if liveEntries[oName] and liveEntries[oName].Parent then
                    -- Entry exists — just update state for Toggle/Always modes
                    -- Hold mode is handled by its own fast loop, skip here to avoid lag
                    if mode ~= "Hold" then
                        applyEntryState(liveEntries[oName], isActive)
                    end
                    -- Update key text in case key changed
                    local badge = liveEntries[oName]:FindFirstChild("KeyBadge")
                    if badge then
                        local kt = badge:FindFirstChild("KeyText")
                        if kt then kt.Text = keyVal end
                    end
                else
                    -- New entry — create it
                    local frame = createEntry(keyVal, label, mode, isActive, i)
                    frame:SetAttribute("Mode", mode)
                    liveEntries[oName] = frame

                    -- Register Hold entries for fast polling
                    if mode == "Hold" then
                        holdEntries[oName] = { kp = kp }
                    end

                    -- Hook the linked Toggle for instant visual response (Toggle mode)
                    if not kpConnections[oName] then
                        kpConnections[oName] = true
                        if mode ~= "Hold" then
                            pcall(function()
                                local linkedName = oName:gsub("Key$",""):gsub("Keybind$",""):gsub("KB$","")
                                if Library.Toggles and Library.Toggles[linkedName] then
                                    Library.Toggles[linkedName]:OnChanged(function()
                                        task.wait()
                                        if liveEntries[oName] then
                                            applyEntryState(liveEntries[oName], resolveActive(kp, oName))
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end
            end

            -- Remove stale entries no longer in kps
            for name, frame in pairs(liveEntries) do
                if not seen[name] then
                    if frame and frame.Parent then frame:Destroy() end
                    liveEntries[name] = nil
                    holdEntries[name] = nil
                end
            end

            -- Empty state
            local hasEntries = false
            for _ in pairs(liveEntries) do hasEntries = true; break end
            local emptyLbl = content:FindFirstChild("EmptyState")
            if not hasEntries then
                if not emptyLbl then
                    local empty = Instance.new("TextLabel")
                    empty.Name = "EmptyState"
                    empty.BackgroundTransparency = 1
                    empty.Size = UDim2.new(1, 0, 0, 22)
                    empty.LayoutOrder = 11
                    empty.Font = Enum.Font.Gotham
                    empty.TextSize = 9
                    empty.TextColor3 = Color3.fromRGB(65, 60, 85)
                    empty.Text = "No keybinds assigned"
                    empty.ZIndex = content.ZIndex + 2
                    empty.Parent = content
                end
            else
                if emptyLbl then emptyLbl:Destroy() end
            end
        end

        -- Public alias used by visibility hooks
        local function syncContent()
            buildEntries()
        end

        -- Hold-mode instant detection via UserInputService
        -- kp.Toggled is a plain Lua field — GetPropertyChangedSignal never fires on it.
        -- We detect the actual key directly so response is instant (no polling lag).
        local holdKeyStates = {}

        local function getKeyCode(keyStr)
            local ok, kc = pcall(function() return Enum.KeyCode[keyStr] end)
            if ok and kc then return kc end
            return nil
        end

        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            for oName, data in pairs(holdEntries) do
                local kp = data.kp
                local kc = getKeyCode(tostring(kp.Value))
                if kc and input.KeyCode == kc then
                    if holdKeyStates[oName] ~= true then
                        holdKeyStates[oName] = true
                        local entry = liveEntries[oName]
                        if entry and entry.Parent then
                            applyEntryState(entry, true)
                        end
                    end
                end
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            for oName, data in pairs(holdEntries) do
                local kp = data.kp
                local kc = getKeyCode(tostring(kp.Value))
                if kc and input.KeyCode == kc then
                    if holdKeyStates[oName] ~= false then
                        holdKeyStates[oName] = false
                        local entry = liveEntries[oName]
                        if entry and entry.Parent then
                            applyEntryState(entry, false)
                        end
                    end
                end
            end
        end)
        
        -- ======================
        -- VISIBILITY & DATA SYNC
        -- ======================
        -- Hide original kf content (make transparent, not invisible - preserves toggle logic)
        local function hideKF()
            kf.BackgroundTransparency = 1
            kf.BorderSizePixel = 0
            for _, desc in ipairs(kf:GetDescendants()) do
                pcall(function()
                    if desc:IsA("TextLabel") then
                        desc.TextTransparency = 1
                        desc.BackgroundTransparency = 1
                    elseif desc:IsA("Frame") then
                        desc.BackgroundTransparency = 1
                    elseif desc:IsA("UIStroke") then
                        desc.Transparency = 1
                    elseif desc:IsA("ImageLabel") then
                        desc.ImageTransparency = 1
                        desc.BackgroundTransparency = 1
                    end
                end)
            end
        end
        hideKF()
        
        -- Block kf from showing any content (fight tweens from toggle callback)
        kf:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
            if kf.BackgroundTransparency < 1 then kf.BackgroundTransparency = 1 end
        end)
        
        -- Hide new children in kf + sync data
        kf.ChildAdded:Connect(function(child)
            task.wait(0.05)
            pcall(function()
                if child:IsA("TextLabel") then
                    child.TextTransparency = 1
                    child.BackgroundTransparency = 1
                    child:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                        if child.TextTransparency < 1 then child.TextTransparency = 1 end
                    end)
                elseif child:IsA("Frame") then
                    child.BackgroundTransparency = 1
                    -- Also hide any nested TextLabels/images inside
                    for _, desc in ipairs(child:GetDescendants()) do
                        pcall(function()
                            if desc:IsA("TextLabel") then
                                desc.TextTransparency = 1
                                desc.BackgroundTransparency = 1
                            elseif desc:IsA("ImageLabel") then
                                desc.ImageTransparency = 1
                            end
                        end)
                    end
                end
            end)
            if mxKB.Visible then syncContent() end
        end)
        
        kf.ChildRemoved:Connect(function()
            task.wait(0.05)
            if mxKB.Visible then syncContent() end
        end)
        
        -- Also catch descendants being added/removed (for nested structures)
        kf.DescendantAdded:Connect(function(desc)
            task.wait(0.05)
            pcall(function()
                if desc:IsA("TextLabel") then
                    desc.TextTransparency = 1
                    desc.BackgroundTransparency = 1
                    desc:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                        if desc.TextTransparency < 1 then desc.TextTransparency = 1 end
                    end)
                elseif desc:IsA("Frame") then
                    desc.BackgroundTransparency = 1
                elseif desc:IsA("ImageLabel") then
                    desc.ImageTransparency = 1
                end
            end)
            if mxKB.Visible then syncContent() end
        end)
        
        kf.DescendantRemoving:Connect(function()
            task.delay(0.1, function()
                if mxKB.Visible then syncContent() end
            end)
        end)
        
        -- Also block text showing on existing children
        for _, child in ipairs(kf:GetChildren()) do
            if child:IsA("TextLabel") then
                pcall(function()
                    child:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                        if child.TextTransparency < 1 then child.TextTransparency = 1 end
                    end)
                end)
            end
        end
        
        -- Visibility sync: MIRROR kf.Visible to mxKB (never set kf.Visible = false!)
        -- Keeping kf visible but transparent lets LinoriaLib populate entries normally.
        kf:GetPropertyChangedSignal("Visible"):Connect(function()
            mxKB.Visible = kf.Visible
            if kf.Visible then
                hideKF()
                task.wait(0.1)
                syncContent()
            end
        end)
        
        -- Also hook toggle directly (more reliable)
        pcall(function()
            if Library.Toggles and Library.Toggles.KeybindsToggle then
                Library.Toggles.KeybindsToggle:OnChanged(function(v)
                    mxKB.Visible = v
                    if v then
                        task.wait(0.1)
                        hideKF()
                        syncContent()
                    end
                end)
            end
        end)
        
        -- Periodic sync: fast updates for dynamic keybind state changes
        task.spawn(function()
            while mxKB and mxKB.Parent do
                task.wait(0.3)
                if mxKB.Visible then
                    hideKF()
                    syncContent()
                end
            end
        end)
        
        -- Initial state: mirror kf
        mxKB.Visible = kf.Visible
        if kf.Visible then syncContent() end
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
                            
                            -- Window title gradient (on the title bar frame)
                            local titleLabel = subChild:FindFirstChildWhichIsA("TextLabel")
                            if titleLabel and not subChild:FindFirstChild("TitleGradOverlay") then
                                local gradOverlay = Instance.new("Frame")
                                gradOverlay.Name = "TitleGradOverlay"
                                gradOverlay.BackgroundColor3 = Library.AccentColor
                                gradOverlay.BackgroundTransparency = 0.88
                                gradOverlay.BorderSizePixel = 0
                                gradOverlay.Size = UDim2.new(1, 0, 1, 0)
                                gradOverlay.ZIndex = subChild.ZIndex
                                gradOverlay.Parent = subChild
                                addCorner(gradOverlay, Config.WindowRadius - 2)
                                Library:AddToRegistry(gradOverlay, { BackgroundColor3 = "AccentColor" })
                                
                                local titleGrad = Instance.new("UIGradient")
                                titleGrad.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0),
                                    NumberSequenceKeypoint.new(0.5, 0.5),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                titleGrad.Parent = gradOverlay
                            end
                        end
                    end
                end
            end
            
            -- Footer status bar
            if not obj:FindFirstChild("MounxFooter") then
                local footer = Instance.new("Frame")
                footer.Name = "MounxFooter"
                footer.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
                footer.BackgroundTransparency = 0.3
                footer.BorderSizePixel = 0
                footer.Size = UDim2.new(1, -8, 0, 18)
                footer.Position = UDim2.new(0, 4, 1, -22)
                footer.ZIndex = obj.ZIndex + 10
                footer.ClipsDescendants = true
                footer.Parent = obj
                addCorner(footer, 6)
                
                -- Footer accent line at top
                local footerLine = Instance.new("Frame")
                footerLine.Name = "FooterLine"
                footerLine.BackgroundColor3 = Library.AccentColor
                footerLine.BorderSizePixel = 0
                footerLine.Size = UDim2.new(1, -20, 0, 1)
                footerLine.Position = UDim2.new(0, 10, 0, 0)
                footerLine.ZIndex = footer.ZIndex + 1
                footerLine.Parent = footer
                Library:AddToRegistry(footerLine, { BackgroundColor3 = "AccentColor" })
                
                local footerLineGrad = Instance.new("UIGradient")
                footerLineGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.2, 0.3),
                    NumberSequenceKeypoint.new(0.8, 0.3),
                    NumberSequenceKeypoint.new(1, 1),
                })
                footerLineGrad.Parent = footerLine
                
                -- Footer text
                local footerText = Instance.new("TextLabel")
                footerText.Name = "FooterText"
                footerText.BackgroundTransparency = 1
                footerText.Size = UDim2.new(1, -16, 1, 0)
                footerText.Position = UDim2.new(0, 8, 0, 1)
                footerText.Font = Enum.Font.Gotham
                footerText.TextSize = 9
                footerText.TextColor3 = Color3.fromRGB(120, 115, 135)
                footerText.TextXAlignment = Enum.TextXAlignment.Left
                footerText.ZIndex = footer.ZIndex + 1
                footerText.Parent = footer
                
                -- Version on right side
                local footerVersion = Instance.new("TextLabel")
                footerVersion.Name = "FooterVersion"
                footerVersion.BackgroundTransparency = 1
                footerVersion.Size = UDim2.new(0, 60, 1, 0)
                footerVersion.Position = UDim2.new(1, -68, 0, 1)
                footerVersion.Font = Enum.Font.Gotham
                footerVersion.TextSize = 9
                footerVersion.TextColor3 = Library.AccentColor
                footerVersion.TextXAlignment = Enum.TextXAlignment.Right
                footerVersion.Text = "v1.0"
                footerVersion.ZIndex = footer.ZIndex + 1
                footerVersion.Parent = footer
                Library:AddToRegistry(footerVersion, { TextColor3 = "AccentColor" })
                
                -- Dynamic footer text update
                task.spawn(function()
                    task.wait(1)
                    local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
                    local gName = (ok and info) and info.Name or "Game"
                    pcall(function() footerText.Text = "Mounx Hub | " .. gName end)
                end)
            end
            return
        end

        if name == "TabContainer" or name == "MainSectionOuter" or name == "MainSectionInner" or name == "BoxOuter" or name == "BoxInner" then
            addCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
            
            -- Groupbox title accent dot
            if name == "BoxInner" then
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("TextLabel") and not child:FindFirstChild("GBAccentDot") then
                        local dot = Instance.new("Frame")
                        dot.Name = "GBAccentDot"
                        dot.BackgroundColor3 = Library.AccentColor
                        dot.BorderSizePixel = 0
                        dot.Size = UDim2.new(0, 4, 0, 4)
                        dot.Position = UDim2.new(0, -1, 0, 5)
                        dot.ZIndex = child.ZIndex + 1
                        dot.Parent = child
                        addCorner(dot, 100)
                        Library:AddToRegistry(dot, { BackgroundColor3 = "AccentColor" })
                    end
                end
            end
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
            
            -- Toggle pulse glow
            if not obj:FindFirstChild("TogglePulse") then
                local pulseStroke = Instance.new("UIStroke")
                pulseStroke.Name = "TogglePulse"
                pulseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                pulseStroke.Thickness = 1.0
                pulseStroke.Transparency = 1
                pulseStroke.Parent = obj
                Library:AddToRegistry(pulseStroke, { Color = "AccentColor" })
                
                -- Watch for fill color changes (toggle ON/OFF)
                local function checkToggleState()
                    local isOn = false
                    for _, inner in ipairs(obj:GetChildren()) do
                        if inner:IsA("Frame") and inner.Name ~= "CheckRing" and inner.Name ~= "TogglePulse" and inner.Name ~= "MounxCorner" then
                            if inner.BackgroundTransparency < 0.5 then
                                isOn = true
                                break
                            end
                        end
                    end
                    
                    if isOn then
                        -- Pulse animation loop
                        task.spawn(function()
                            while obj and obj.Parent and pulseStroke and pulseStroke.Parent do
                                local stillOn = false
                                for _, inner in ipairs(obj:GetChildren()) do
                                    if inner:IsA("Frame") and inner.Name ~= "CheckRing" and inner.Name ~= "TogglePulse" and inner.Name ~= "MounxCorner" then
                                        if inner.BackgroundTransparency < 0.5 then stillOn = true; break end
                                    end
                                end
                                if not stillOn then
                                    TweenService:Create(pulseStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
                                    break
                                end
                                TweenService:Create(pulseStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
                                task.wait(1.0)
                                if not obj or not obj.Parent then break end
                                TweenService:Create(pulseStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.92}):Play()
                                task.wait(1.0)
                            end
                        end)
                    else
                        pulseStroke.Transparency = 1
                    end
                end
                
                -- Monitor changes
                for _, inner in ipairs(obj:GetChildren()) do
                    if inner:IsA("Frame") and inner.Name ~= "CheckRing" and inner.Name ~= "TogglePulse" then
                        inner:GetPropertyChangedSignal("BackgroundTransparency"):Connect(checkToggleState)
                    end
                end
                obj.ChildAdded:Connect(function(child)
                    task.wait(0.05)
                    if child:IsA("Frame") and child.Name ~= "CheckRing" and child.Name ~= "TogglePulse" then
                        child:GetPropertyChangedSignal("BackgroundTransparency"):Connect(checkToggleState)
                    end
                end)
                
                task.delay(0.1, checkToggleState)
            end
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
                            
                            -- Slider fill glow
                            if not fill:FindFirstChild("SliderGlow") and fill.Size.X.Scale > 0 then
                                local sliderGlow = Instance.new("UIStroke")
                                sliderGlow.Name = "SliderGlow"
                                sliderGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                                sliderGlow.Thickness = 1
                                sliderGlow.Transparency = 0.4
                                sliderGlow.Parent = fill
                                Library:AddToRegistry(sliderGlow, { Color = "AccentColor" })
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
    -- =====================
    -- Menu groupbox (always first on left)
    -- =====================
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu')
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'X', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind

    -- =====================
    -- Interface groupbox (notification side, font, auto re-exec)
    -- =====================
    local InterfaceGroup = SettingsTab:AddLeftGroupbox('Interface')

    InterfaceGroup:AddDropdown('NotifPositionDrop', {
        Text = 'Notification Side', Values = { 'Right', 'Left' }, Default = 1, Multi = false,
        Tooltip = 'Side of the screen where notifications appear'
    })
    Library.Options.NotifPositionDrop:OnChanged(function()
        local side = Library.Options.NotifPositionDrop.Value
        pcall(function()
            local gui = Library.ScreenGui
            for _, v in ipairs(gui:GetChildren()) do
                if v:IsA("Frame") and v.BackgroundTransparency == 1 then
                    local list = v:FindFirstChildWhichIsA("UIListLayout")
                    if list then
                        if side == "Right" then
                            v.AnchorPoint = Vector2.new(1, 0)
                            v.Position = UDim2.new(1, -15, 0, 15)
                            list.HorizontalAlignment = Enum.HorizontalAlignment.Right
                        else
                            v.AnchorPoint = Vector2.new(0, 0)
                            v.Position = UDim2.new(0, 15, 0, 15)
                            list.HorizontalAlignment = Enum.HorizontalAlignment.Left
                        end
                    end
                end
            end
        end)
    end)

    InterfaceGroup:AddDropdown('MenuFontDrop', {
        Text = 'Menu Font', Default = 1, Multi = false,
        Values = { 'GothamBold', 'Gotham', 'GothamMedium', 'GothamSemibold', 'Arimo', 'Ubuntu', 'Code' },
        Tooltip = 'Changes the font of all text in the menu'
    })
    Library.Options.MenuFontDrop:OnChanged(function()
        local fontName = Library.Options.MenuFontDrop.Value
        local ok, font = pcall(function() return Enum.Font[fontName] end)
        if not ok or not font then font = Enum.Font.GothamBold end
        pcall(function()
            for _, v in ipairs(Library.ScreenGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                    pcall(function() v.Font = font end)
                end
            end
        end)
    end)

    InterfaceGroup:AddToggle('AutoReExecToggle', {
        Text = 'Auto Re-Execute on Teleport', Default = false,
        Tooltip = 'Automatically re-runs your script after any teleport (queues with queue_on_teleport)'
    })
    Library.Toggles.AutoReExecToggle:OnChanged(function()
        if Library.Toggles.AutoReExecToggle.Value then
            local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
            if qot then
                local code = getgenv().MounxAutoExecCode or [[
                    task.wait(3)
                    pcall(function()
                        if isfile and isfile("MounxLoader.lua") then
                            loadstring(readfile("MounxLoader.lua"))()
                        end
                    end)
                ]]
                pcall(function() qot(code) end)
            end
        end
    end)


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
        local startTime = tick()
        
        -- FPS counter (safe: updates every 0.5s, NOT every frame)
        local frameCount = 0
        local currentFPS = 0
        local lastTime = tick()
        
        RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
        end)
        
        -- Helper: enforce watermark visibility based on toggle
        local function enforceWmVisibility()
            if not Library.Toggles.WatermarkToggle or not Library.Toggles.WatermarkToggle.Value then
                pcall(function() Library:SetWatermarkVisibility(false) end)
                pcall(function() Library.WatermarkOuter.Visible = false end)
            end
        end
        
        -- Set initial watermark text (but enforce toggle state)
        pcall(function()
            local text = tostring(pName) .. " | " .. tostring(gName) .. " | 0 FPS | 0m 0s"
            Library:SetWatermark(text)
            enforceWmVisibility()
        end)
        
        -- Update watermark text with FPS every 0.5 seconds
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
                
                -- Calculate runtime
                local elapsed = tick() - startTime
                local mins = math.floor(elapsed / 60)
                local secs = math.floor(elapsed % 60)
                
                pcall(function()
                    if Library and not Library.Unloaded then
                        local text = tostring(pName) .. " | " .. tostring(gName) .. " | " .. tostring(currentFPS) .. " FPS | " .. tostring(mins) .. "m " .. tostring(secs) .. "s"
                        Library:SetWatermark(text)
                        enforceWmVisibility()
                    end
                end)
            end
        end)
    end)
    
    task.spawn(function()
        ApplyMounxStyle(Library)
        -- AUTOLOAD FIX: Execute at the end to load config if exists
        pcall(function() SaveManager:LoadAutoloadConfig() end)
        pcall(function() Library.ScreenGui.Enabled = true end)
    end)
end

function MounxHub:BuildVisuals(VisualsTab, options)
    -- =============================================
    -- Internal polyfill: patch AddColorPicker + AddDependencyBox
    -- on this tab's groupboxes so LinoriaLib forks work correctly.
    -- This is safe — it only patches the specific tab object, not globals.
    -- =============================================
    do
        local function patchGB(gb)
            if not gb then return gb end
            if not gb.AddColorPicker then
                gb.AddColorPicker = function(s, id, info)
                    local lbl = s:AddLabel((info and (info.Text or info.Title)) or id)
                    return lbl:AddColorPicker(id, info)
                end
            end
            local origDep = gb.AddDependencyBox
            if origDep then
                gb.AddDependencyBox = function(s, ...)
                    local dep = origDep(s, ...)
                    if type(dep) == "table" and not dep.SetVisible then
                        dep.SetVisible = function(dSelf, vis)
                            pcall(function()
                                if dSelf.Container and dSelf.Container.Parent then
                                    dSelf.Container.Parent.Visible = vis
                                end
                            end)
                            pcall(function() if dSelf.Resize then dSelf:Resize() end end)
                        end
                    end
                    return dep
                end
            end
            return gb
        end
        local origLeft  = VisualsTab.AddLeftGroupbox
        local origRight = VisualsTab.AddRightGroupbox
        VisualsTab.AddLeftGroupbox = function(self, ...)
            return patchGB(origLeft(self, ...))
        end
        VisualsTab.AddRightGroupbox = function(self, ...)
            return patchGB(origRight(self, ...))
        end
    end

    -- =============================================
    -- Left: ESP groupbox
    -- =============================================
    -- =============================================
    -- Left: ESP groupbox
    -- =============================================
    local ESPGroup = VisualsTab:AddLeftGroupbox('ESP')

    ESPGroup:AddToggle('ESPEnabled', { Text = 'Enable ESP', Default = false })

    ESPGroup:AddDropdown('ESPTarget', {
        Text = 'Target', Values = { 'Players', 'NPCs', 'Both' }, Default = 1, Multi = false
    })

    ESPGroup:AddDropdown('BoxStyle', {
        Text = 'Box Style', Values = { '2D Box', '3D Box', 'Corner Box', 'Full Box' }, Default = 1, Multi = false
    })

    ESPGroup:AddSlider('ESPMaxDist', {
        Text = 'Max Distance', Min = 50, Max = 4000, Default = 1500, Rounding = 0
    })

    -- =============================================
    -- Left: Box Settings groupbox
    -- =============================================
    local BoxSettingsGroup = VisualsTab:AddLeftGroupbox('Box Settings')

    BoxSettingsGroup:AddToggle('BoxFilled', { Text = 'Filled Box', Default = false })
    BoxSettingsGroup:AddSlider('BoxFillTransparency', {
        Text = 'Fill Transparency', Min = 0, Max = 1, Default = 0.5, Rounding = 1
    })
    BoxSettingsGroup:AddColorPicker('BoxColorPlayers', {
        Text = 'Player Box Color', Default = Color3.fromRGB(255, 100, 100)
    })
    BoxSettingsGroup:AddColorPicker('BoxColorNPCs', {
        Text = 'NPC Box Color', Default = Color3.fromRGB(100, 200, 100)
    })

    -- =============================================
    -- Left: Text groupbox
    -- =============================================
    local TextGroup = VisualsTab:AddLeftGroupbox('Text')

    TextGroup:AddToggle('NameESP',       { Text = 'Name',        Default = false })
    TextGroup:AddToggle('DistanceESP',   { Text = 'Distance',    Default = false })
    TextGroup:AddToggle('HealthTextESP', { Text = 'Health Text', Default = false })
    TextGroup:AddToggle('WeaponESP',     { Text = 'Equipped Tool/Weapon', Default = false })
    TextGroup:AddToggle('HeadDotESP',    { Text = 'Head Dot',    Default = false })
    TextGroup:AddColorPicker('TextColor', {
        Text = 'Text Color', Default = Color3.fromRGB(255, 255, 255)
    })

    -- =============================================
    -- Right: Health Bar groupbox
    -- =============================================
    local HealthBarGroup = VisualsTab:AddRightGroupbox('Health Bar')

    HealthBarGroup:AddToggle('HealthBarESP',  { Text = 'Health Bar',    Default = false })
    HealthBarGroup:AddToggle('HealthBarText', { Text = 'Show HP Value (100 HP)', Default = false })
    HealthBarGroup:AddColorPicker('HealthBarColor', {
        Text = 'Bar Color', Default = Color3.fromRGB(0, 255, 100)
    })

    -- =============================================
    -- Right: Tracers groupbox
    -- =============================================
    local TracerGroup = VisualsTab:AddRightGroupbox('Tracers')

    TracerGroup:AddToggle('TracerESP', { Text = 'Tracers', Default = false })
    TracerGroup:AddDropdown('TracerOrigin', {
        Text = 'Origin', Values = { 'Bottom', 'Center', 'Top', 'Mouse' }, Default = 1, Multi = false
    })
    TracerGroup:AddColorPicker('TracerColor', {
        Text = 'Tracer Color', Default = Color3.fromRGB(255, 107, 157)
    })

    -- =============================================
    -- Right: Chams groupbox
    -- =============================================
    local ChamsGroup = VisualsTab:AddRightGroupbox('Chams')

    ChamsGroup:AddToggle('ChamsESP', { Text = 'Chams', Default = false })
    ChamsGroup:AddColorPicker('ChamsColorVisible', {
        Text = 'Visible Color', Default = Color3.fromRGB(255, 107, 157)
    })
    ChamsGroup:AddColorPicker('ChamsColorHidden', {
        Text = 'Hidden Color', Default = Color3.fromRGB(150, 50, 80)
    })

    -- =============================================
    -- Right: Off-Screen Arrow groupbox
    -- =============================================
    local ArrowGroup = VisualsTab:AddRightGroupbox('Off-Screen Arrow')

    ArrowGroup:AddToggle('ArrowESP', { Text = 'Arrow', Default = false })
    ArrowGroup:AddColorPicker('ArrowColor', {
        Text = 'Arrow Color', Default = Color3.fromRGB(255, 255, 255)
    })

    -- =============================================
    -- Right: ESP Preview groupbox
    -- =============================================
    local PreviewGroup = VisualsTab:AddRightGroupbox('ESP Preview')

    PreviewGroup:AddToggle('ESPPreviewToggle', {
        Text = 'Show Preview', Default = false,
        Tooltip = 'Shows a live 3D preview of your character with ESP overlays'
    })

    -- ============================================================
    -- IN-GAME ESP RENDERING ENGINE (Drawings & Highlights)
    -- ============================================================
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local hasDrawing = false
    pcall(function()
        local test = Drawing.new("Line")
        test:Remove()
        hasDrawing = true
    end)

    local ESPCache = {} -- [instance] = { drawings... }
    local cachedNPCs = {}

    local function getTargetColor(isPlayer)
        local opt = isPlayer and Library.Options.BoxColorPlayers or Library.Options.BoxColorNPCs
        return opt and opt.Value or Color3.fromRGB(255, 100, 100)
    end

    local function createEntryDrawings()
        if not hasDrawing then return {} end
        local d = {}
        -- 2D Box
        d.boxOutline = Drawing.new("Square")
        d.boxOutline.Thickness = 3
        d.boxOutline.Filled = false
        d.boxOutline.Color = Color3.fromRGB(0, 0, 0)
        d.boxOutline.Visible = false

        d.box = Drawing.new("Square")
        d.box.Thickness = 1.5
        d.box.Filled = false
        d.box.Visible = false

        -- 8 Corner Lines + 8 Outlines
        d.corners = {}
        d.cornerOutlines = {}
        for i = 1, 8 do
            local co = Drawing.new("Line")
            co.Thickness = 3
            co.Color = Color3.fromRGB(0, 0, 0)
            co.Visible = false
            table.insert(d.cornerOutlines, co)

            local c = Drawing.new("Line")
            c.Thickness = 1.5
            c.Visible = false
            table.insert(d.corners, c)
        end

        -- 12 3D Box Lines
        d.box3D = {}
        for i = 1, 12 do
            local l = Drawing.new("Line")
            l.Thickness = 1.5
            l.Visible = false
            table.insert(d.box3D, l)
        end

        -- Health bar
        d.healthBarOutline = Drawing.new("Square")
        d.healthBarOutline.Thickness = 1
        d.healthBarOutline.Filled = true
        d.healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
        d.healthBarOutline.Visible = false

        d.healthBar = Drawing.new("Square")
        d.healthBar.Thickness = 1
        d.healthBar.Filled = true
        d.healthBar.Visible = false

        d.healthText = Drawing.new("Text")
        d.healthText.Size = 11
        d.healthText.Center = false
        d.healthText.Outline = true
        d.healthText.OutlineColor = Color3.fromRGB(0, 0, 0)
        d.healthText.Color = Color3.fromRGB(255, 255, 255)
        d.healthText.Visible = false

        -- Texts
        d.nameText = Drawing.new("Text")
        d.nameText.Size = 13
        d.nameText.Center = true
        d.nameText.Outline = true
        d.nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
        d.nameText.Visible = false

        d.distText = Drawing.new("Text")
        d.distText.Size = 11
        d.distText.Center = true
        d.distText.Outline = true
        d.distText.OutlineColor = Color3.fromRGB(0, 0, 0)
        d.distText.Visible = false

        d.weaponText = Drawing.new("Text")
        d.weaponText.Size = 11
        d.weaponText.Center = true
        d.weaponText.Outline = true
        d.weaponText.OutlineColor = Color3.fromRGB(0, 0, 0)
        d.weaponText.Color = Color3.fromRGB(210, 200, 230)
        d.weaponText.Visible = false

        -- Head dot
        d.headDot = Drawing.new("Circle")
        d.headDot.Radius = 4
        d.headDot.Filled = true
        d.headDot.Color = Color3.fromRGB(255, 255, 255)
        d.headDot.Visible = false

        d.headDotOutline = Drawing.new("Circle")
        d.headDotOutline.Radius = 5
        d.headDotOutline.Filled = false
        d.headDotOutline.Thickness = 1.5
        d.headDotOutline.Color = Color3.fromRGB(0, 0, 0)
        d.headDotOutline.Visible = false

        -- Tracer
        d.tracerOutline = Drawing.new("Line")
        d.tracerOutline.Thickness = 3
        d.tracerOutline.Color = Color3.fromRGB(0, 0, 0)
        d.tracerOutline.Visible = false

        d.tracer = Drawing.new("Line")
        d.tracer.Thickness = 1.5
        d.tracer.Visible = false

        -- Off-screen Arrow (with Outline!)
        d.arrowOutline = Drawing.new("Triangle")
        d.arrowOutline.Thickness = 2
        d.arrowOutline.Filled = false
        d.arrowOutline.Color = Color3.fromRGB(0, 0, 0)
        d.arrowOutline.Visible = false

        d.arrow = Drawing.new("Triangle")
        d.arrow.Filled = true
        d.arrow.Visible = false

        d.animHP = 100

        return d
    end

    local function hideDrawings(d)
        if not d then return end
        if d.box then d.box.Visible = false end
        if d.boxOutline then d.boxOutline.Visible = false end
        if d.corners then for _, l in ipairs(d.corners) do l.Visible = false end end
        if d.cornerOutlines then for _, l in ipairs(d.cornerOutlines) do l.Visible = false end end
        if d.box3D then for _, l in ipairs(d.box3D) do l.Visible = false end end
        if d.healthBar then d.healthBar.Visible = false end
        if d.healthBarOutline then d.healthBarOutline.Visible = false end
        if d.healthText then d.healthText.Visible = false end
        if d.nameText then d.nameText.Visible = false end
        if d.distText then d.distText.Visible = false end
        if d.weaponText then d.weaponText.Visible = false end
        if d.headDot then d.headDot.Visible = false end
        if d.headDotOutline then d.headDotOutline.Visible = false end
        if d.tracer then d.tracer.Visible = false end
        if d.tracerOutline then d.tracerOutline.Visible = false end
        if d.arrow then d.arrow.Visible = false end
        if d.arrowOutline then d.arrowOutline.Visible = false end
    end

    local function destroyDrawings(d)
        if not d then return end
        hideDrawings(d)
        pcall(function()
            if d.box then d.box:Remove() end
            if d.boxOutline then d.boxOutline:Remove() end
            if d.corners then for _, l in ipairs(d.corners) do l:Remove() end end
            if d.cornerOutlines then for _, l in ipairs(d.cornerOutlines) do l:Remove() end end
            if d.box3D then for _, l in ipairs(d.box3D) do l:Remove() end end
            if d.healthBar then d.healthBar:Remove() end
            if d.healthBarOutline then d.healthBarOutline:Remove() end
            if d.healthText then d.healthText:Remove() end
            if d.nameText then d.nameText:Remove() end
            if d.distText then d.distText:Remove() end
            if d.weaponText then d.weaponText:Remove() end
            if d.headDot then d.headDot:Remove() end
            if d.headDotOutline then d.headDotOutline:Remove() end
            if d.tracer then d.tracer:Remove() end
            if d.tracerOutline then d.tracerOutline:Remove() end
            if d.arrow then d.arrow:Remove() end
            if d.arrowOutline then d.arrowOutline:Remove() end
        end)
    end

    -- Background NPC scan (runs every 1.5s, strictly filters out LocalPlayer)
    task.spawn(function()
        while not Library.Unloaded do
            task.wait(1.5)
            local targetMode = Library.Options.ESPTarget and Library.Options.ESPTarget.Value or "Players"
            if Library.Toggles.ESPEnabled and Library.Toggles.ESPEnabled.Value and (targetMode == "NPCs" or targetMode == "Both") then
                local list = {}
                local lpChar = LocalPlayer and LocalPlayer.Character
                pcall(function()
                    for _, desc in ipairs(workspace:GetDescendants()) do
                        if desc:IsA("Humanoid") and desc.Health > 0 and desc.MaxHealth > 0 then
                            local model = desc.Parent
                            if model and model:IsA("Model") and model ~= lpChar and not (lpChar and model:IsDescendantOf(lpChar)) then
                                if not Players:GetPlayerFromCharacter(model) then
                                    local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
                                    if root and root:IsA("BasePart") then
                                        table.insert(list, { model = model, humanoid = desc, root = root })
                                    end
                                end
                            end
                        end
                    end
                end)
                cachedNPCs = list
            else
                cachedNPCs = {}
            end
        end
    end)

    -- Main In-Game ESP Render Loop
    RunService.RenderStepped:Connect(function(dt)
        if not Library or Library.Unloaded then return end
        local espOn = Library.Toggles.ESPEnabled and Library.Toggles.ESPEnabled.Value

        if not espOn then
            for model, d in pairs(ESPCache) do
                hideDrawings(d)
                local hl = model:FindFirstChild("MounxCham")
                if hl then hl.Enabled = false end
            end
            return
        end

        local targetMode = Library.Options.ESPTarget and Library.Options.ESPTarget.Value or "Players"
        local boxStyle = Library.Options.BoxStyle and Library.Options.BoxStyle.Value or "2D Box"
        local boxFilled = Library.Toggles.BoxFilled and Library.Toggles.BoxFilled.Value
        local fillTrans = Library.Options.BoxFillTransparency and Library.Options.BoxFillTransparency.Value or 0.5
        local textColor = Library.Options.TextColor and Library.Options.TextColor.Value or Color3.fromRGB(255, 255, 255)
        local tracerColor = Library.Options.TracerColor and Library.Options.TracerColor.Value or Color3.fromRGB(255, 107, 157)
        local arrowColor = Library.Options.ArrowColor and Library.Options.ArrowColor.Value or Color3.fromRGB(255, 255, 255)
        local maxDistance = Library.Options.ESPMaxDist and Library.Options.ESPMaxDist.Value or 1500

        -- Gather active targets (NEVER include LocalPlayer)
        local targets = {}
        local lpChar = LocalPlayer and LocalPlayer.Character

        if targetMode == "Players" or targetMode == "Both" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character ~= lpChar then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                    if hum and root and hum.Health > 0 then
                        table.insert(targets, {
                            model = p.Character,
                            humanoid = hum,
                            root = root,
                            name = p.DisplayName or p.Name,
                            isPlayer = true
                        })
                    end
                end
            end
        end
        if targetMode == "NPCs" or targetMode == "Both" then
            for _, npc in ipairs(cachedNPCs) do
                if npc.model and npc.model.Parent and npc.model ~= lpChar and npc.humanoid and npc.humanoid.Health > 0 and npc.root and npc.root.Parent then
                    table.insert(targets, {
                        model = npc.model,
                        humanoid = npc.humanoid,
                        root = npc.root,
                        name = npc.model.Name,
                        isPlayer = false
                    })
                end
            end
        end

        local seenModels = {}

        for _, t in ipairs(targets) do
            local model = t.model
            seenModels[model] = true
            local root = t.root
            local hum = t.humanoid
            local isPlayer = t.isPlayer
            local rootPos = root.Position
            local camPos = Camera.CFrame.Position
            local dist = (camPos - rootPos).Magnitude

            -- Distance filter
            if dist <= maxDistance then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPos)

                -- Chams (Highlights work regardless of Drawing)
                if Library.Toggles.ChamsESP and Library.Toggles.ChamsESP.Value then
                    local hl = model:FindFirstChild("MounxCham")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "MounxCham"
                        hl.Adornee = model
                        hl.Parent = model
                    end
                    local chamCol = Library.Options.ChamsColorVisible and Library.Options.ChamsColorVisible.Value or Color3.fromRGB(255, 107, 157)
                    hl.FillColor = chamCol
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                else
                    local hl = model:FindFirstChild("MounxCham")
                    if hl then hl.Enabled = false end
                end

                -- Drawing components
                if hasDrawing then
                    local d = ESPCache[model]
                    if not d then
                        d = createEntryDrawings()
                        ESPCache[model] = d
                    end

                    if onScreen then
                        -- Hide off-screen arrow
                        if d.arrow then d.arrow.Visible = false end
                        if d.arrowOutline then d.arrowOutline.Visible = false end

                        local topScreen = Camera:WorldToViewportPoint(rootPos + Vector3.new(0, 2.7, 0))
                        local botScreen = Camera:WorldToViewportPoint(rootPos - Vector3.new(0, 3.2, 0))
                        local boxHeight = math.abs(botScreen.Y - topScreen.Y)
                        local boxWidth = math.max(10, boxHeight * 0.65)
                        local boxX = screenPos.X - (boxWidth / 2)
                        local boxY = topScreen.Y
                        local themeColor = getTargetColor(isPlayer)

                        -- 1. BOXES
                        if boxStyle == "2D Box" or boxStyle == "Full Box" then
                            if d.corners then for _, l in ipairs(d.corners) do l.Visible = false end end
                            if d.cornerOutlines then for _, l in ipairs(d.cornerOutlines) do l.Visible = false end end
                            if d.box3D then for _, l in ipairs(d.box3D) do l.Visible = false end end

                            d.box.Visible = true
                            d.box.Size = Vector2.new(boxWidth, boxHeight)
                            d.box.Position = Vector2.new(boxX, boxY)
                            d.box.Color = themeColor
                            d.box.Filled = boxFilled
                            d.box.Transparency = boxFilled and (1 - fillTrans) or 1

                            d.boxOutline.Visible = not boxFilled
                            d.boxOutline.Size = Vector2.new(boxWidth + 2, boxHeight + 2)
                            d.boxOutline.Position = Vector2.new(boxX - 1, boxY - 1)

                        elseif boxStyle == "Corner Box" then
                            -- Corner Box WITH FILLED SUPPORT!
                            if d.box3D then for _, l in ipairs(d.box3D) do l.Visible = false end end

                            if boxFilled then
                                d.box.Visible = true
                                d.box.Size = Vector2.new(boxWidth, boxHeight)
                                d.box.Position = Vector2.new(boxX, boxY)
                                d.box.Color = themeColor
                                d.box.Filled = true
                                d.box.Transparency = 1 - fillTrans
                                d.boxOutline.Visible = false
                            else
                                d.box.Visible = false
                                d.boxOutline.Visible = false
                            end

                            local cl = math.clamp(boxWidth * 0.28, 4, 18)
                            local segs = {
                                { Vector2.new(boxX, boxY), Vector2.new(boxX + cl, boxY) },
                                { Vector2.new(boxX, boxY), Vector2.new(boxX, boxY + cl) },
                                { Vector2.new(boxX + boxWidth, boxY), Vector2.new(boxX + boxWidth - cl, boxY) },
                                { Vector2.new(boxX + boxWidth, boxY), Vector2.new(boxX + boxWidth, boxY + cl) },
                                { Vector2.new(boxX, boxY + boxHeight), Vector2.new(boxX + cl, boxY + boxHeight) },
                                { Vector2.new(boxX, boxY + boxHeight), Vector2.new(boxX, boxY + boxHeight - cl) },
                                { Vector2.new(boxX + boxWidth, boxY + boxHeight), Vector2.new(boxX + boxWidth - cl, boxY + boxHeight) },
                                { Vector2.new(boxX + boxWidth, boxY + boxHeight), Vector2.new(boxX + boxWidth, boxY + boxHeight - cl) },
                            }
                            for i = 1, 8 do
                                local seg = segs[i]
                                local co = d.cornerOutlines[i]
                                local c = d.corners[i]
                                if co and c then
                                    co.Visible = true
                                    co.From = seg[1]
                                    co.To = seg[2]
                                    c.Visible = true
                                    c.From = seg[1]
                                    c.To = seg[2]
                                    c.Color = themeColor
                                end
                            end

                        elseif boxStyle == "3D Box" then
                            d.box.Visible = false
                            d.boxOutline.Visible = false
                            if d.corners then for _, l in ipairs(d.corners) do l.Visible = false end end
                            if d.cornerOutlines then for _, l in ipairs(d.cornerOutlines) do l.Visible = false end end

                            local cf = root.CFrame
                            local sx, sy, sz = 1.8, 2.8, 1.2
                            local pts = {
                                cf * Vector3.new(-sx,  sy, -sz),
                                cf * Vector3.new( sx,  sy, -sz),
                                cf * Vector3.new( sx, -sy, -sz),
                                cf * Vector3.new(-sx, -sy, -sz),
                                cf * Vector3.new(-sx,  sy,  sz),
                                cf * Vector3.new( sx,  sy,  sz),
                                cf * Vector3.new( sx, -sy,  sz),
                                cf * Vector3.new(-sx, -sy,  sz),
                            }
                            local sPts = {}
                            local allVis = true
                            for i = 1, 8 do
                                local sp, v = Camera:WorldToViewportPoint(pts[i])
                                if not v then allVis = false break end
                                sPts[i] = Vector2.new(sp.X, sp.Y)
                            end
                            if allVis then
                                local edges = {
                                    {1,2}, {2,3}, {3,4}, {4,1},
                                    {5,6}, {6,7}, {7,8}, {8,5},
                                    {1,5}, {2,6}, {3,7}, {4,8}
                                }
                                for i = 1, 12 do
                                    local edge = edges[i]
                                    local l = d.box3D[i]
                                    if l then
                                        l.Visible = true
                                        l.From = sPts[edge[1]]
                                        l.To = sPts[edge[2]]
                                        l.Color = themeColor
                                    end
                                end
                            else
                                for _, l in ipairs(d.box3D) do l.Visible = false end
                            end
                        end

                        -- 2. HEALTH BAR (Animated + "100 HP" format)
                        if Library.Toggles.HealthBarESP and Library.Toggles.HealthBarESP.Value then
                            local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
                            local hp = math.clamp(hum.Health, 0, maxHp)

                            -- Smooth animation
                            d.animHP = d.animHP or hp
                            d.animHP = d.animHP + (hp - d.animHP) * math.clamp(dt * 12, 0.08, 1)

                            local hpPercent = math.clamp(d.animHP / maxHp, 0, 1)
                            local barWidth = 3
                            local barX = boxX - barWidth - 5
                            local barY = boxY
                            local barH = boxHeight

                            d.healthBarOutline.Visible = true
                            d.healthBarOutline.Position = Vector2.new(barX - 1, barY - 1)
                            d.healthBarOutline.Size = Vector2.new(barWidth + 2, barH + 2)

                            local fillH = math.floor(barH * hpPercent)
                            d.healthBar.Visible = true
                            d.healthBar.Position = Vector2.new(barX, barY + (barH - fillH))
                            d.healthBar.Size = Vector2.new(barWidth, fillH)

                            local customHpColor = Library.Options.HealthBarColor and Library.Options.HealthBarColor.Value
                            local hpGrad = Color3.fromRGB(255, 40, 40):Lerp(Color3.fromRGB(40, 255, 100), hpPercent)
                            d.healthBar.Color = customHpColor or hpGrad

                            if Library.Toggles.HealthBarText and Library.Toggles.HealthBarText.Value then
                                d.healthText.Visible = true
                                d.healthText.Text = math.floor(hp) .. " HP"
                                d.healthText.Position = Vector2.new(barX - 44, barY + (barH - fillH) - 6)
                            else
                                d.healthText.Visible = false
                            end
                        else
                            d.healthBar.Visible = false
                            d.healthBarOutline.Visible = false
                            d.healthText.Visible = false
                        end

                        -- 3. TEXTS (Name, Distance, Weapon)
                        if Library.Toggles.NameESP and Library.Toggles.NameESP.Value then
                            d.nameText.Visible = true
                            d.nameText.Text = t.name
                            d.nameText.Position = Vector2.new(boxX + (boxWidth / 2), boxY - 16)
                            d.nameText.Color = textColor
                        else
                            d.nameText.Visible = false
                        end

                        local botOffset = 2
                        if Library.Toggles.DistanceESP and Library.Toggles.DistanceESP.Value then
                            local dVal = math.floor(dist)
                            d.distText.Visible = true
                            d.distText.Text = dVal .. " studs"
                            d.distText.Position = Vector2.new(boxX + (boxWidth / 2), boxY + boxHeight + botOffset)
                            d.distText.Color = textColor
                            botOffset = botOffset + 13
                        else
                            d.distText.Visible = false
                        end

                        if Library.Toggles.WeaponESP and Library.Toggles.WeaponESP.Value then
                            local tool = model:FindFirstChildOfClass("Tool")
                            if tool then
                                d.weaponText.Visible = true
                                d.weaponText.Text = "[" .. tool.Name .. "]"
                                d.weaponText.Position = Vector2.new(boxX + (boxWidth / 2), boxY + boxHeight + botOffset)
                            else
                                d.weaponText.Visible = false
                            end
                        else
                            d.weaponText.Visible = false
                        end

                        -- Head Dot
                        if Library.Toggles.HeadDotESP and Library.Toggles.HeadDotESP.Value then
                            local head = model:FindFirstChild("Head")
                            if head then
                                local headScreen, hVis = Camera:WorldToViewportPoint(head.Position)
                                if hVis then
                                    d.headDotOutline.Visible = true
                                    d.headDotOutline.Position = Vector2.new(headScreen.X, headScreen.Y)
                                    d.headDot.Visible = true
                                    d.headDot.Position = Vector2.new(headScreen.X, headScreen.Y)
                                    d.headDot.Color = themeColor
                                else
                                    d.headDot.Visible = false
                                    d.headDotOutline.Visible = false
                                end
                            end
                        else
                            d.headDot.Visible = false
                            d.headDotOutline.Visible = false
                        end

                        -- 4. TRACERS
                        if Library.Toggles.TracerESP and Library.Toggles.TracerESP.Value then
                            local origMode = Library.Options.TracerOrigin and Library.Options.TracerOrigin.Value or "Bottom"
                            local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            if origMode == "Center" then
                                origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            elseif origMode == "Top" then
                                origin = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            elseif origMode == "Mouse" then
                                origin = UIS:GetMouseLocation()
                            end

                            local targetPt = Vector2.new(boxX + (boxWidth / 2), boxY + boxHeight)
                            d.tracerOutline.Visible = true
                            d.tracerOutline.From = origin
                            d.tracerOutline.To = targetPt

                            d.tracer.Visible = true
                            d.tracer.From = origin
                            d.tracer.To = targetPt
                            d.tracer.Color = tracerColor
                        else
                            d.tracer.Visible = false
                            d.tracerOutline.Visible = false
                        end

                    else
                        -- Target is OFF-SCREEN: Show Outlined Arrow if enabled
                        hideDrawings(d)

                        if Library.Toggles.ArrowESP and Library.Toggles.ArrowESP.Value then
                            local camCF = Camera.CFrame
                            local toTarget = (rootPos - camCF.Position).Unit
                            local rel = camCF:VectorToObjectSpace(toTarget)
                            local angle = math.atan2(rel.X, rel.Z)

                            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local radius = math.min(center.X, center.Y) * 0.74
                            local dir = Vector2.new(math.sin(angle), -math.cos(angle))
                            local arrowCenter = center + dir * radius

                            local fwd = dir * 14
                            local rgt = Vector2.new(-dir.Y, dir.X) * 7

                            -- Crisp Black Outline
                            d.arrowOutline.Visible = true
                            d.arrowOutline.PointA = arrowCenter + fwd * 1.25
                            d.arrowOutline.PointB = arrowCenter - fwd * 0.45 + rgt * 1.25
                            d.arrowOutline.PointC = arrowCenter - fwd * 0.45 - rgt * 1.25

                            -- Colored Fill
                            d.arrow.Visible = true
                            d.arrow.PointA = arrowCenter + fwd
                            d.arrow.PointB = arrowCenter - fwd * 0.4 + rgt
                            d.arrow.PointC = arrowCenter - fwd * 0.4 - rgt
                            d.arrow.Color = arrowColor
                        else
                            d.arrow.Visible = false
                            if d.arrowOutline then d.arrowOutline.Visible = false end
                        end
                    end
                end
            else
                -- Target exceeds max distance
                local d = ESPCache[model]
                if d then hideDrawings(d) end
                local hl = model:FindFirstChild("MounxCham")
                if hl then hl.Enabled = false end
            end
        end

        -- Clean up dead / unrendered models from cache
        for model, d in pairs(ESPCache) do
            if not seenModels[model] then
                destroyDrawings(d)
                ESPCache[model] = nil
                local hl = model:FindFirstChild("MounxCham")
                if hl then hl.Enabled = false end
            end
        end
    end)

    -- Clean up drawings on Library Unload
    if Library.Unload then
        local oldUnload = Library.Unload
        Library.Unload = function(s, ...)
            for _, d in pairs(ESPCache) do
                destroyDrawings(d)
            end
            ESPCache = {}
            return oldUnload(s, ...)
        end
    end

    -- ============================================================
    -- ANCHORED 3D ESP PREVIEW PANEL WITH LIVE ESP OVERLAYS
    -- ============================================================
    local espPreviewPanel = nil
    local espPreviewCamera = nil
    local espViewport = nil
    local worldModel = nil
    local rotY = 0
    local rotX = 0
    local isMouseDown = false
    local lastMousePos = Vector2.new()

    -- Live Preview ESP Overlay Elements
    local pvOverlayContainer = nil
    local pvBox = nil
    local pvBoxStroke = nil
    local pvCornerFrames = {}
    local pvHealthBarBg = nil
    local pvHealthBarFill = nil
    local pvHealthText = nil
    local pvNameText = nil
    local pvDistText = nil

    -- Helper to find Linoria's main window frame
    local function getMainFrame()
        if not Library.ScreenGui then return nil end
        for _, child in ipairs(Library.ScreenGui:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "KeybindFrame" and child.Name ~= "MounxKB" and child.Name ~= "WatermarkOuter" and child.Name ~= "ESPPreviewPanel" then
                if child:FindFirstChild("TabContainer", true) or child.Size.Y.Offset > 250 then
                    return child
                end
            end
        end
        return nil
    end

    local function populatePreviewCharacter()
        if not worldModel then return end
        worldModel:ClearAllChildren()

        local char = LocalPlayer and LocalPlayer.Character
        if char then
            pcall(function()
                char.Archivable = true
                local clone = char:Clone()
                if not clone then return end
                clone.Archivable = true

                for _, v in ipairs(clone:GetDescendants()) do
                    if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("Sound") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        pcall(function() v:Destroy() end)
                    elseif v:IsA("BasePart") then
                        v.Anchored = true
                        v.CanCollide = false
                    end
                end

                local root = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
                if root then
                    local offset = root.CFrame
                    for _, part in ipairs(clone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CFrame = offset:ToObjectSpace(part.CFrame)
                        end
                    end
                end
                clone.Parent = worldModel
            end)
        end
    end

    local function createESPPreview()
        if espPreviewPanel then return end
        local gui = Library.ScreenGui
        if not gui then return end

        local mainWin = getMainFrame()
        local winHeight = mainWin and mainWin.AbsoluteSize.Y or 450
        local previewW = 300 -- Wider, spacious preview as requested!

        -- Outer Panel (anchored to main window, themed accent border)
        espPreviewPanel = Instance.new("Frame")
        espPreviewPanel.Name = "ESPPreviewPanel"
        espPreviewPanel.Size = UDim2.new(0, previewW, 0, winHeight)
        espPreviewPanel.BackgroundColor3 = Color3.fromRGB(14, 11, 18)
        espPreviewPanel.BorderSizePixel = 0
        espPreviewPanel.Visible = false
        espPreviewPanel.ZIndex = 500
        espPreviewPanel.ClipsDescendants = true
        espPreviewPanel.Parent = gui

        local panelCorner = Instance.new("UICorner")
        panelCorner.CornerRadius = UDim.new(0, 10)
        panelCorner.Parent = espPreviewPanel

        -- Bright, distinct Accent Stroke
        local panelStroke = Instance.new("UIStroke")
        panelStroke.Thickness = 1.5
        panelStroke.Transparency = 0.1
        panelStroke.Color = Library.AccentColor
        panelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        panelStroke.Parent = espPreviewPanel
        Library:AddToRegistry(panelStroke, { Color = "AccentColor" })

        -- Top accent line
        local topBar = Instance.new("Frame")
        topBar.Name = "TopBar"
        topBar.Size = UDim2.new(1, 0, 0, 2)
        topBar.BorderSizePixel = 0
        topBar.ZIndex = 502
        topBar.Parent = espPreviewPanel
        Library:AddToRegistry(topBar, { BackgroundColor3 = "AccentColor" })

        local tbGrad = Instance.new("UIGradient")
        tbGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.85, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
        tbGrad.Parent = topBar

        -- Title bar
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 32)
        titleBar.Position = UDim2.new(0, 0, 0, 2)
        titleBar.BackgroundColor3 = Color3.fromRGB(20, 16, 26)
        titleBar.BackgroundTransparency = 0.4
        titleBar.BorderSizePixel = 0
        titleBar.ZIndex = 501
        titleBar.Parent = espPreviewPanel

        -- Pulsing title dot
        local titleDot = Instance.new("Frame")
        titleDot.Name = "Dot"
        titleDot.BackgroundColor3 = Library.AccentColor
        titleDot.Size = UDim2.new(0, 6, 0, 6)
        titleDot.Position = UDim2.new(0, 12, 0.5, -3)
        titleDot.BorderSizePixel = 0
        titleDot.ZIndex = 503
        titleDot.Parent = titleBar
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = titleDot
        Library:AddToRegistry(titleDot, { BackgroundColor3 = "AccentColor" })

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -28, 1, 0)
        titleLabel.Position = UDim2.new(0, 26, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = "ESP Preview"
        titleLabel.TextColor3 = Color3.fromRGB(250, 245, 255)
        titleLabel.ZIndex = 503
        titleLabel.Parent = titleBar

        -- Bottom Hint
        local hintLabel = Instance.new("TextLabel")
        hintLabel.Size = UDim2.new(1, 0, 0, 18)
        hintLabel.Position = UDim2.new(0, 0, 1, -20)
        hintLabel.BackgroundTransparency = 1
        hintLabel.Font = Enum.Font.Gotham
        hintLabel.TextSize = 10
        hintLabel.TextColor3 = Color3.fromRGB(130, 120, 150)
        hintLabel.Text = "Drag on viewport to manually rotate in 3D"
        hintLabel.ZIndex = 503
        hintLabel.Parent = espPreviewPanel

        -- Viewport Frame
        espViewport = Instance.new("ViewportFrame")
        espViewport.Size = UDim2.new(1, -12, 1, -56)
        espViewport.Position = UDim2.new(0, 6, 0, 34)
        espViewport.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
        espViewport.BackgroundTransparency = 0
        espViewport.BorderSizePixel = 0
        espViewport.ZIndex = 501
        espViewport.Ambient = Color3.fromRGB(230, 230, 235)
        espViewport.LightColor = Color3.fromRGB(255, 255, 255)
        espViewport.LightDirection = Vector3.new(-1, -1.5, -1)
        espViewport.Parent = espPreviewPanel

        local vpCorner = Instance.new("UICorner")
        vpCorner.CornerRadius = UDim.new(0, 6)
        vpCorner.Parent = espViewport

        worldModel = Instance.new("WorldModel")
        worldModel.Parent = espViewport

        espPreviewCamera = Instance.new("Camera")
        espPreviewCamera.FieldOfView = 50
        espPreviewCamera.Parent = espViewport
        espViewport.CurrentCamera = espPreviewCamera

        -- Default: looking straight at the character (no sideways rotation!)
        rotY = 0
        rotX = 0

        populatePreviewCharacter()

        -- ============================================================
        -- LIVE ESP PREVIEW OVERLAY ELEMENTS (Inside Preview Window)
        -- ============================================================
        pvOverlayContainer = Instance.new("Frame")
        pvOverlayContainer.Name = "ESPPreviewOverlays"
        pvOverlayContainer.Size = UDim2.new(1, 0, 1, 0)
        pvOverlayContainer.BackgroundTransparency = 1
        pvOverlayContainer.ZIndex = 505
        pvOverlayContainer.Parent = espViewport

        -- Preview 2D Box
        pvBox = Instance.new("Frame")
        pvBox.Name = "PreviewBox"
        pvBox.BorderSizePixel = 0
        pvBox.BackgroundTransparency = 1
        pvBox.ZIndex = 506
        pvBox.Visible = false
        pvBox.Parent = pvOverlayContainer

        pvBoxStroke = Instance.new("UIStroke")
        pvBoxStroke.Thickness = 1.5
        pvBoxStroke.Color = Color3.fromRGB(255, 100, 100)
        pvBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        pvBoxStroke.Parent = pvBox

        -- Preview Corner Box brackets (8 Frame segments)
        pvCornerFrames = {}
        for i = 1, 8 do
            local cf = Instance.new("Frame")
            cf.BorderSizePixel = 0
            cf.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            cf.ZIndex = 507
            cf.Visible = false
            cf.Parent = pvOverlayContainer
            table.insert(pvCornerFrames, cf)
        end

        -- Preview Health Bar Background
        pvHealthBarBg = Instance.new("Frame")
        pvHealthBarBg.Name = "PreviewHB_Bg"
        pvHealthBarBg.BorderSizePixel = 0
        pvHealthBarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pvHealthBarBg.ZIndex = 506
        pvHealthBarBg.Visible = false
        pvHealthBarBg.Parent = pvOverlayContainer

        pvHealthBarFill = Instance.new("Frame")
        pvHealthBarFill.Name = "Fill"
        pvHealthBarFill.BorderSizePixel = 0
        pvHealthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        pvHealthBarFill.Size = UDim2.new(1, 0, 1, 0)
        pvHealthBarFill.ZIndex = 507
        pvHealthBarFill.Parent = pvHealthBarBg

        -- Preview Health Text ("100 HP")
        pvHealthText = Instance.new("TextLabel")
        pvHealthText.Name = "PreviewHPText"
        pvHealthText.BackgroundTransparency = 1
        pvHealthText.Font = Enum.Font.GothamBold
        pvHealthText.TextSize = 10
        pvHealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
        pvHealthText.TextStrokeTransparency = 0
        pvHealthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        pvHealthText.Text = "100 HP"
        pvHealthText.ZIndex = 508
        pvHealthText.Visible = false
        pvHealthText.Parent = pvOverlayContainer

        -- Preview Name Text
        pvNameText = Instance.new("TextLabel")
        pvNameText.Name = "PreviewNameText"
        pvNameText.BackgroundTransparency = 1
        pvNameText.Font = Enum.Font.GothamBold
        pvNameText.TextSize = 12
        pvNameText.TextColor3 = Color3.fromRGB(255, 255, 255)
        pvNameText.TextStrokeTransparency = 0
        pvNameText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        pvNameText.Text = LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "LocalPlayer"
        pvNameText.ZIndex = 508
        pvNameText.Visible = false
        pvNameText.Parent = pvOverlayContainer

        -- Preview Distance Text
        pvDistText = Instance.new("TextLabel")
        pvDistText.Name = "PreviewDistText"
        pvDistText.BackgroundTransparency = 1
        pvDistText.Font = Enum.Font.Gotham
        pvDistText.TextSize = 10
        pvDistText.TextColor3 = Color3.fromRGB(255, 255, 255)
        pvDistText.TextStrokeTransparency = 0
        pvDistText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        pvDistText.Text = "0 studs"
        pvDistText.ZIndex = 508
        pvDistText.Visible = false
        pvDistText.Parent = pvOverlayContainer

        -- Auto-refresh character if local character respawns
        if LocalPlayer then
            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.6)
                if espPreviewPanel and espPreviewPanel.Parent then
                    populatePreviewCharacter()
                end
            end)
        end

        -- Manual interactive 3D rotation via mouse/touch drag
        espViewport.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isMouseDown = true
                lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if isMouseDown and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local currentPos = Vector2.new(input.Position.X, input.Position.Y)
                local delta = currentPos - lastMousePos
                rotY = rotY + delta.X * 0.015
                rotX = math.clamp(rotX + delta.Y * 0.015, -0.4, 0.4)
                lastMousePos = currentPos
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isMouseDown = false
            end
        end)
    end

    local function destroyESPPreview()
        if espPreviewPanel then
            espPreviewPanel:Destroy()
            espPreviewPanel = nil
            espPreviewCamera = nil
            espViewport = nil
            worldModel = nil
            pvOverlayContainer = nil
        end
    end

    -- Toggle hook
    Library.Toggles.ESPPreviewToggle:OnChanged(function(v)
        if v then
            createESPPreview()
        else
            destroyESPPreview()
        end
    end)

    -- Anchor, Camera, & LIVE ESP OVERLAY update loop for ESP Preview (runs in RenderStepped)
    RunService.RenderStepped:Connect(function()
        if not espPreviewPanel or not espPreviewPanel.Parent or not espViewport then return end

        local mainWin = getMainFrame()
        local isMenuOpen = Library.Toggled and (mainWin and mainWin.Visible) and Library.ScreenGui.Enabled
        local isToggleOn = Library.Toggles.ESPPreviewToggle and Library.Toggles.ESPPreviewToggle.Value

        if not (isMenuOpen and isToggleOn) then
            espPreviewPanel.Visible = false
            return
        end

        espPreviewPanel.Visible = true

        -- Match main window height & anchor right next to it with 8px gap
        local mainPos = mainWin.AbsolutePosition
        local mainSize = mainWin.AbsoluteSize
        local previewW = math.clamp(math.floor(mainSize.X * 0.52), 280, 330)
        local gap = 8

        local targetX = mainPos.X + mainSize.X + gap
        -- Responsive check for narrow screens / mobile: flip to left side if no space on right
        if targetX + previewW > Camera.ViewportSize.X - 10 then
            targetX = math.max(10, mainPos.X - previewW - gap)
        end

        espPreviewPanel.Position = UDim2.new(0, targetX, 0, mainPos.Y)
        espPreviewPanel.Size = UDim2.new(0, previewW, 0, mainSize.Y)

        -- 3D Camera Orbit & Rotation (Manual only, default looking straight from front!)
        if espPreviewCamera then
            local camDist = 8.6
            local camY = math.sin(rotX) * camDist
            local camPlane = math.cos(rotX) * camDist
            local camX = math.sin(rotY) * camPlane
            local camZ = math.cos(rotY) * camPlane
            -- Target is center of the character (0, 0, 0), perfectly framed!
            espPreviewCamera.CFrame = CFrame.new(Vector3.new(camX, camY + 0.3, camZ), Vector3.new(0, 0, 0))
        end

        -- ============================================================
        -- RENDER LIVE ESP OVERLAYS ON PREVIEW CHARACTER
        -- ============================================================
        local espEnabled = Library.Toggles.ESPEnabled and Library.Toggles.ESPEnabled.Value
        if not espEnabled or not pvOverlayContainer then
            if pvBox then pvBox.Visible = false end
            for _, f in ipairs(pvCornerFrames) do f.Visible = false end
            if pvHealthBarBg then pvHealthBarBg.Visible = false end
            if pvHealthText then pvHealthText.Visible = false end
            if pvNameText then pvNameText.Visible = false end
            if pvDistText then pvDistText.Visible = false end
            return
        end

        -- Project top and bottom points of the 3D model inside ViewportFrame
        if espPreviewCamera then
            local topWorld = Vector3.new(0, 2.65, 0)
            local botWorld = Vector3.new(0, -3.1, 0)
            local topScr, tVis = espPreviewCamera:WorldToViewportPoint(topWorld)
            local botScr, bVis = espPreviewCamera:WorldToViewportPoint(botWorld)

            local boxH = math.abs(botScr.Y - topScr.Y)
            local boxW = math.floor(boxH * 0.58)
            local vpW = espViewport.AbsoluteSize.X
            local boxX = math.floor((vpW / 2) - (boxW / 2))
            local boxY = math.floor(topScr.Y)

            local boxColor = Library.Options.BoxColorPlayers and Library.Options.BoxColorPlayers.Value or Color3.fromRGB(255, 100, 100)
            local boxStyle = Library.Options.BoxStyle and Library.Options.BoxStyle.Value or "2D Box"
            local boxFilled = Library.Toggles.BoxFilled and Library.Toggles.BoxFilled.Value
            local fillTrans = Library.Options.BoxFillTransparency and Library.Options.BoxFillTransparency.Value or 0.5
            local textColor = Library.Options.TextColor and Library.Options.TextColor.Value or Color3.fromRGB(255, 255, 255)

            -- 1. Preview Box & Corners
            if boxStyle == "2D Box" or boxStyle == "Full Box" then
                for _, f in ipairs(pvCornerFrames) do f.Visible = false end
                pvBox.Visible = true
                pvBox.Position = UDim2.new(0, boxX, 0, boxY)
                pvBox.Size = UDim2.new(0, boxW, 0, boxH)
                pvBoxStroke.Color = boxColor
                pvBoxStroke.Thickness = 1.5

                if boxFilled then
                    pvBox.BackgroundColor3 = boxColor
                    pvBox.BackgroundTransparency = fillTrans
                else
                    pvBox.BackgroundTransparency = 1
                end

            elseif boxStyle == "Corner Box" then
                -- Corner Box Live Preview!
                if boxFilled then
                    pvBox.Visible = true
                    pvBox.Position = UDim2.new(0, boxX, 0, boxY)
                    pvBox.Size = UDim2.new(0, boxW, 0, boxH)
                    pvBox.BackgroundColor3 = boxColor
                    pvBox.BackgroundTransparency = fillTrans
                    pvBoxStroke.Transparency = 1
                else
                    pvBox.Visible = false
                end

                local cl = math.clamp(math.floor(boxW * 0.28), 5, 20)
                local th = 2
                local segs = {
                    { UDim2.new(0, boxX, 0, boxY), UDim2.new(0, cl, 0, th) },
                    { UDim2.new(0, boxX, 0, boxY), UDim2.new(0, th, 0, cl) },
                    { UDim2.new(0, boxX + boxW - cl, 0, boxY), UDim2.new(0, cl, 0, th) },
                    { UDim2.new(0, boxX + boxW - th, 0, boxY), UDim2.new(0, th, 0, cl) },
                    { UDim2.new(0, boxX, 0, boxY + boxH - th), UDim2.new(0, cl, 0, th) },
                    { UDim2.new(0, boxX, 0, boxY + boxH - cl), UDim2.new(0, th, 0, cl) },
                    { UDim2.new(0, boxX + boxW - cl, 0, boxY + boxH - th), UDim2.new(0, cl, 0, th) },
                    { UDim2.new(0, boxX + boxW - th, 0, boxY + boxH - cl), UDim2.new(0, th, 0, cl) },
                }
                for i = 1, 8 do
                    local f = pvCornerFrames[i]
                    if f then
                        f.Visible = true
                        f.Position = segs[i][1]
                        f.Size = segs[i][2]
                        f.BackgroundColor3 = boxColor
                    end
                end

            else
                pvBox.Visible = false
                for _, f in ipairs(pvCornerFrames) do f.Visible = false end
            end

            -- 2. Preview Health Bar & HP Text ("100 HP")
            if Library.Toggles.HealthBarESP and Library.Toggles.HealthBarESP.Value then
                local barW = 3
                local barX = boxX - barW - 5
                pvHealthBarBg.Visible = true
                pvHealthBarBg.Position = UDim2.new(0, barX, 0, boxY)
                pvHealthBarBg.Size = UDim2.new(0, barW, 0, boxH)

                local hbColor = Library.Options.HealthBarColor and Library.Options.HealthBarColor.Value or Color3.fromRGB(0, 255, 100)
                pvHealthBarFill.BackgroundColor3 = hbColor

                if Library.Toggles.HealthBarText and Library.Toggles.HealthBarText.Value then
                    pvHealthText.Visible = true
                    pvHealthText.Position = UDim2.new(0, barX - 44, 0, boxY - 4)
                    pvHealthText.Text = "100 HP"
                else
                    pvHealthText.Visible = false
                end
            else
                pvHealthBarBg.Visible = false
                pvHealthText.Visible = false
            end

            -- 3. Preview Name Text
            if Library.Toggles.NameESP and Library.Toggles.NameESP.Value then
                pvNameText.Visible = true
                pvNameText.Position = UDim2.new(0, boxX - 40, 0, boxY - 17)
                pvNameText.Size = UDim2.new(0, boxW + 80, 0, 14)
                pvNameText.TextColor3 = textColor
            else
                pvNameText.Visible = false
            end

            -- 4. Preview Distance Text
            if Library.Toggles.DistanceESP and Library.Toggles.DistanceESP.Value then
                pvDistText.Visible = true
                pvDistText.Position = UDim2.new(0, boxX - 40, 0, boxY + boxH + 2)
                pvDistText.Size = UDim2.new(0, boxW + 80, 0, 14)
                pvDistText.TextColor3 = textColor
            else
                pvDistText.Visible = false
            end

            -- 5. Preview Chams (Tint character parts inside ViewportFrame!)
            if worldModel then
                local isChams = Library.Toggles.ChamsESP and Library.Toggles.ChamsESP.Value
                local chamCol = Library.Options.ChamsColorVisible and Library.Options.ChamsColorVisible.Value or Color3.fromRGB(255, 107, 157)
                for _, part in ipairs(worldModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if isChams then
                            part.Color = chamCol
                            part.Material = Enum.Material.Neon
                        else
                            part.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end
            end
        end
    end)
end

return MounxHub








