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
        -- ENTRY BUILDER
        -- ======================
        local function createEntry(text, order)
            local isOdd = (order % 2 == 1)
            
            local entry = Instance.new("Frame")
            entry.Name = "KBEntry"
            entry.BackgroundColor3 = isOdd and Color3.fromRGB(20, 17, 26) or Color3.fromRGB(24, 20, 32)
            entry.BackgroundTransparency = 0.05
            entry.BorderSizePixel = 0
            entry.Size = UDim2.new(1, 0, 0, 26)
            entry.LayoutOrder = order + 10
            entry.ZIndex = content.ZIndex + 4
            entry.Parent = content
            entry:SetAttribute("IsEntry", true)
            addCorner(entry, 6)
            
            -- Left accent bar
            local leftBar = Instance.new("Frame")
            leftBar.Name = "LeftBar"
            leftBar.BackgroundColor3 = Library.AccentColor
            leftBar.BorderSizePixel = 0
            leftBar.Size = UDim2.new(0, 2, 0.5, 0)
            leftBar.Position = UDim2.new(0, 3, 0.25, 0)
            leftBar.ZIndex = entry.ZIndex + 1
            leftBar.Parent = entry
            addCorner(leftBar, 2)
            Library:AddToRegistry(leftBar, { BackgroundColor3 = "AccentColor" })
            
            -- Parse: "  [KEY] Action Name (Type)"
            local keyStr = text:match("%[(.-)%]") or "?"
            local afterKey = text:match("%]%s*(.+)") or text
            local typeName = ""
            local actionName = afterKey
            
            local typeMatch = afterKey:match("%((.-)%)%s*$")
            if typeMatch then
                typeName = typeMatch
                -- Escape special pattern chars for gsub
                local escaped = typeMatch:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
                actionName = afterKey:gsub("%s*%(" .. escaped .. "%)%s*$", "")
            end
            actionName = actionName:match("^%s*(.-)%s*$") or actionName
            
            -- Key badge (accent-tinted pill)
            local badgeW = math.max(22, #keyStr * 8 + 12)
            local badge = Instance.new("Frame")
            badge.Name = "KeyBadge"
            badge.BackgroundColor3 = Library.AccentColor
            badge.BackgroundTransparency = 0.82
            badge.BorderSizePixel = 0
            badge.Size = UDim2.new(0, badgeW, 0, 16)
            badge.Position = UDim2.new(0, 10, 0.5, -8)
            badge.ZIndex = entry.ZIndex + 2
            badge.Parent = entry
            addCorner(badge, 4)
            Library:AddToRegistry(badge, { BackgroundColor3 = "AccentColor" })
            
            -- Badge border stroke
            local bStroke = Instance.new("UIStroke")
            bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            bStroke.Thickness = 1
            bStroke.Transparency = 0.5
            bStroke.Parent = badge
            Library:AddToRegistry(bStroke, { Color = "AccentColor" })
            
            -- Key letter inside badge
            local keyText = Instance.new("TextLabel")
            keyText.Name = "KeyText"
            keyText.BackgroundTransparency = 1
            keyText.Size = UDim2.new(1, 0, 1, 0)
            keyText.Font = Enum.Font.GothamBold
            keyText.TextSize = 9
            keyText.TextColor3 = Library.AccentColor
            keyText.Text = keyStr
            keyText.ZIndex = entry.ZIndex + 3
            keyText.Parent = badge
            Library:AddToRegistry(keyText, { TextColor3 = "AccentColor" })
            
            -- Type tag pill (right side) - styled by type
            local typeTagW = 0
            if typeName ~= "" then
                typeTagW = math.max(40, #typeName * 6 + 14)
                local typeTag = Instance.new("Frame")
                typeTag.Name = "TypeTag"
                typeTag.BorderSizePixel = 0
                typeTag.Size = UDim2.new(0, typeTagW, 0, 14)
                typeTag.Position = UDim2.new(1, -(typeTagW + 6), 0.5, -7)
                typeTag.ZIndex = entry.ZIndex + 2
                typeTag.Parent = entry
                addCorner(typeTag, 4)
                
                -- Color-code by type
                if typeName == "Toggle" then
                    typeTag.BackgroundColor3 = Color3.fromRGB(20, 35, 25)
                    typeTag.BackgroundTransparency = 0.15
                    local typeLabel = Instance.new("TextLabel")
                    typeLabel.BackgroundTransparency = 1
                    typeLabel.Size = UDim2.new(1, 0, 1, 0)
                    typeLabel.Font = Enum.Font.GothamBold
                    typeLabel.TextSize = 8
                    typeLabel.TextColor3 = Color3.fromRGB(80, 190, 110)
                    typeLabel.Text = "TOGGLE"
                    typeLabel.ZIndex = entry.ZIndex + 3
                    typeLabel.Parent = typeTag
                elseif typeName == "Hold" then
                    typeTag.BackgroundColor3 = Color3.fromRGB(35, 25, 18)
                    typeTag.BackgroundTransparency = 0.15
                    local typeLabel = Instance.new("TextLabel")
                    typeLabel.BackgroundTransparency = 1
                    typeLabel.Size = UDim2.new(1, 0, 1, 0)
                    typeLabel.Font = Enum.Font.GothamBold
                    typeLabel.TextSize = 8
                    typeLabel.TextColor3 = Color3.fromRGB(220, 160, 60)
                    typeLabel.Text = "HOLD"
                    typeLabel.ZIndex = entry.ZIndex + 3
                    typeLabel.Parent = typeTag
                else
                    typeTag.BackgroundColor3 = Color3.fromRGB(30, 26, 42)
                    typeTag.BackgroundTransparency = 0.15
                    local typeLabel = Instance.new("TextLabel")
                    typeLabel.BackgroundTransparency = 1
                    typeLabel.Size = UDim2.new(1, 0, 1, 0)
                    typeLabel.Font = Enum.Font.GothamBold
                    typeLabel.TextSize = 8
                    typeLabel.TextColor3 = Color3.fromRGB(140, 135, 165)
                    typeLabel.Text = string.upper(typeName)
                    typeLabel.ZIndex = entry.ZIndex + 3
                    typeLabel.Parent = typeTag
                end
            end
            
            -- Action name (center text)
            local actionLabel = Instance.new("TextLabel")
            actionLabel.Name = "ActionText"
            actionLabel.BackgroundTransparency = 1
            actionLabel.Size = UDim2.new(1, -(badgeW + 18 + (typeTagW > 0 and typeTagW + 12 or 6)), 1, 0)
            actionLabel.Position = UDim2.new(0, badgeW + 16, 0, 0)
            actionLabel.Font = Enum.Font.GothamMedium
            actionLabel.TextSize = 10
            actionLabel.TextColor3 = Color3.fromRGB(195, 190, 212)
            actionLabel.TextXAlignment = Enum.TextXAlignment.Left
            actionLabel.TextTruncate = Enum.TextTruncate.AtEnd
            actionLabel.Text = actionName
            actionLabel.ZIndex = entry.ZIndex + 3
            actionLabel.Parent = entry
            
            -- Hover glow effect
            local hGlow = Instance.new("UIStroke")
            hGlow.Name = "HoverGlow"
            hGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            hGlow.Thickness = 1
            hGlow.Transparency = 1
            hGlow.Parent = entry
            Library:AddToRegistry(hGlow, { Color = "AccentColor" })
            
            entry.MouseEnter:Connect(function()
                TweenService:Create(hGlow, TweenInfo.new(0.12), {Transparency = 0.35}):Play()
                TweenService:Create(entry, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
            end)
            entry.MouseLeave:Connect(function()
                TweenService:Create(hGlow, TweenInfo.new(0.2), {Transparency = 1}):Play()
                TweenService:Create(entry, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
            end)
            
            return entry
        end
        
        -- ======================
        -- SYNC ENGINE
        -- ======================
        local function syncContent()
            -- Remove old entries
            for _, child in ipairs(content:GetChildren()) do
                if child:GetAttribute("IsEntry") then child:Destroy() end
            end
            
            -- Find title in kf to skip it
            local kfTitle = nil
            for _, child in ipairs(kf:GetChildren()) do
                if child:IsA("TextLabel") then kfTitle = child; break end
            end
            
            -- Collect keybind entries from kf (search deep with GetDescendants)
            local entries = {}
            
            -- Strategy 1: direct TextLabel children
            for _, child in ipairs(kf:GetChildren()) do
                if child:IsA("TextLabel") and child ~= kfTitle and child.Text ~= "" then
                    table.insert(entries, child.Text)
                end
            end
            
            -- Strategy 2: if none found, search ALL descendants for [KEY] pattern
            if #entries == 0 then
                for _, desc in ipairs(kf:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc ~= kfTitle and desc.Text:match("%[.-%]") then
                        table.insert(entries, desc.Text)
                    end
                end
            end
            
            -- Strategy 3: if still none, read from Library's internal keybind options
            if #entries == 0 then
                pcall(function()
                    for optName, opt in pairs(Library.Options) do
                        if opt and opt.KeyPicker and opt.Value then
                            local kp = opt.KeyPicker
                            local keyVal = kp.Value or opt.Value
                            local mode = kp.Mode or "Toggle"
                            local label = kp.Text or opt.Text or optName
                            if keyVal and tostring(keyVal) ~= "" and tostring(keyVal) ~= "None" and tostring(keyVal) ~= "Unknown" then
                                table.insert(entries, "[" .. tostring(keyVal) .. "] " .. tostring(label) .. " (" .. tostring(mode) .. ")")
                            end
                        end
                    end
                end)
            end
            
            -- Build entries in custom panel
            local idx = 0
            for _, text in ipairs(entries) do
                idx = idx + 1
                createEntry(text, idx)
            end
            
            -- Empty state
            if idx == 0 then
                local empty = Instance.new("TextLabel")
                empty.Name = "EmptyState"
                empty.BackgroundTransparency = 1
                empty.Size = UDim2.new(1, 0, 0, 22)
                empty.LayoutOrder = 11
                empty.Font = Enum.Font.Gotham
                empty.TextSize = 9
                empty.TextColor3 = Color3.fromRGB(80, 75, 100)
                empty.Text = "No active keybinds"
                empty.ZIndex = content.ZIndex + 2
                empty.Parent = content
                empty:SetAttribute("IsEntry", true)
            end
        end
        
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
        
        -- Periodic sync: catch entries added/changed while panel is open
        task.spawn(function()
            while mxKB and mxKB.Parent do
                task.wait(1)
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

return MounxHub








