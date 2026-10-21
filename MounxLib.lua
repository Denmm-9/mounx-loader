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
        addCorner(kf, 10)
        kf.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
        kf.BackgroundTransparency = 0
        kf.BorderSizePixel = 0
        
        -- Outer glow stroke (subtle accent border)
        if not kf:FindFirstChild("KBStroke") then
            local stroke = Instance.new("UIStroke")
            stroke.Name = "KBStroke"
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Thickness = 1
            stroke.Transparency = 0.5
            stroke.Parent = kf
            Library:AddToRegistry(stroke, { Color = "AccentColor" })
        end
        
        -- Inner panel container with gradient background
        if not kf:FindFirstChild("KBInnerPanel") then
            local panel = Instance.new("Frame")
            panel.Name = "KBInnerPanel"
            panel.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
            panel.BackgroundTransparency = 0.3
            panel.BorderSizePixel = 0
            panel.Size = UDim2.new(1, -4, 1, -4)
            panel.Position = UDim2.new(0, 2, 0, 2)
            panel.ZIndex = kf.ZIndex
            panel.Parent = kf
            addCorner(panel, 8)
            
            -- Vertical gradient on inner panel
            local panelGrad = Instance.new("UIGradient")
            panelGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 24, 38)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 16)),
            })
            panelGrad.Rotation = 90
            panelGrad.Parent = panel
        end
        
        -- Top accent bar (full width glow line)
        if not kf:FindFirstChild("KBAccentLine") then
            local line = Instance.new("Frame")
            line.Name = "KBAccentLine"
            line.BackgroundColor3 = Library.AccentColor
            line.BorderSizePixel = 0
            line.Size = UDim2.new(1, 0, 0, 2)
            line.Position = UDim2.new(0, 0, 0, 0)
            line.ZIndex = kf.ZIndex + 10
            line.Parent = kf
            addCorner(line, 2)
            Library:AddToRegistry(line, { BackgroundColor3 = "AccentColor" })
            
            local lineGrad = Instance.new("UIGradient")
            lineGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.1, 0.2),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.9, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            })
            lineGrad.Parent = line
        end
        
        -- Accent glow haze under top bar
        if not kf:FindFirstChild("KBGlowHaze") then
            local haze = Instance.new("Frame")
            haze.Name = "KBGlowHaze"
            haze.BackgroundColor3 = Library.AccentColor
            haze.BackgroundTransparency = 0.85
            haze.BorderSizePixel = 0
            haze.Size = UDim2.new(1, -8, 0, 20)
            haze.Position = UDim2.new(0, 4, 0, 2)
            haze.ZIndex = kf.ZIndex + 1
            haze.Parent = kf
            addCorner(haze, 8)
            Library:AddToRegistry(haze, { BackgroundColor3 = "AccentColor" })
            
            local hazeGrad = Instance.new("UIGradient")
            hazeGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            })
            hazeGrad.Rotation = 90
            hazeGrad.Parent = haze
        end
        
        -- Style the title label
        local title = kf:FindFirstChildWhichIsA("TextLabel")
        if title then
            title.Font = Enum.Font.GothamBold
            title.TextSize = 11
            title.TextColor3 = Library.AccentColor
            title.ZIndex = kf.ZIndex + 8
            Library:AddToRegistry(title, { TextColor3 = "AccentColor" })
        end
        
        -- Separator line under title
        if not kf:FindFirstChild("KBSeparator") then
            local sep = Instance.new("Frame")
            sep.Name = "KBSeparator"
            sep.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
            sep.BorderSizePixel = 0
            sep.Size = UDim2.new(1, -16, 0, 1)
            sep.Position = UDim2.new(0, 8, 0, 22)
            sep.ZIndex = kf.ZIndex + 6
            sep.Parent = kf
            
            local sepGrad = Instance.new("UIGradient")
            sepGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.3),
                NumberSequenceKeypoint.new(0.8, 0.3),
                NumberSequenceKeypoint.new(1, 1),
            })
            sepGrad.Parent = sep
        end
        
        -- Track entry index for alternating colors
        local entryIndex = 0
        
        -- Style each keybind entry with advanced look
        local function styleEntry(label)
            if not label or not label:IsA("TextLabel") then return end
            if label == title then return end
            if label:FindFirstChild("KBStyled") then return end
            
            entryIndex = entryIndex + 1
            local isEven = (entryIndex % 2 == 0)
            
            -- Hide original text (we render our own overlay)
            label.TextTransparency = 1
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.ClipsDescendants = true
            local originalText = label.Text or ""
            
            -- Entry card container
            local card = Instance.new("Frame")
            card.Name = "KBCard"
            card.BackgroundColor3 = isEven and Color3.fromRGB(22, 19, 30) or Color3.fromRGB(18, 15, 24)
            card.BackgroundTransparency = 0.1
            card.BorderSizePixel = 0
            card.Size = UDim2.new(1, -6, 1, -2)
            card.Position = UDim2.new(0, 3, 0, 1)
            card.ZIndex = label.ZIndex + 1
            card.Parent = label
            addCorner(card, 6)
            
            -- Left accent bar (thin glowing strip)
            local accentBar = Instance.new("Frame")
            accentBar.Name = "AccentBar"
            accentBar.BackgroundColor3 = Library.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Size = UDim2.new(0, 2, 0.7, 0)
            accentBar.Position = UDim2.new(0, 1, 0.15, 0)
            accentBar.ZIndex = card.ZIndex + 2
            accentBar.Parent = card
            addCorner(accentBar, 2)
            Library:AddToRegistry(accentBar, { BackgroundColor3 = "AccentColor" })
            
            -- Parse the text: "  [KEY] Action Name (Type)"
            local keyStr, actionName, typeName = "", originalText, ""
            local keyMatch = originalText:match("%[(.-)%]")
            if keyMatch then
                keyStr = keyMatch
                local afterKey = originalText:match("%]%s*(.+)") or ""
                local typeMatch = afterKey:match("%((.-)%)%s*$")
                if typeMatch then
                    typeName = typeMatch
                    actionName = afterKey:gsub("%s*%(" .. typeMatch .. "%)%s*$", "")
                else
                    actionName = afterKey
                end
            end
            actionName = actionName:match("^%s*(.-)%s*$") or actionName
            
            -- Key badge (styled pill)
            local keyBadge = Instance.new("Frame")
            keyBadge.Name = "KeyBadge"
            keyBadge.BackgroundColor3 = Library.AccentColor
            keyBadge.BackgroundTransparency = 0.82
            keyBadge.BorderSizePixel = 0
            keyBadge.Size = UDim2.new(0, 22, 0, 14)
            keyBadge.Position = UDim2.new(0, 8, 0.5, -7)
            keyBadge.ZIndex = card.ZIndex + 3
            keyBadge.Parent = card
            addCorner(keyBadge, 4)
            Library:AddToRegistry(keyBadge, { BackgroundColor3 = "AccentColor" })
            
            -- Key badge border
            local keyStroke = Instance.new("UIStroke")
            keyStroke.Name = "KeyStroke"
            keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            keyStroke.Thickness = 1
            keyStroke.Transparency = 0.4
            keyStroke.Parent = keyBadge
            Library:AddToRegistry(keyStroke, { Color = "AccentColor" })
            
            -- Key text inside badge
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Name = "KeyText"
            keyLabel.BackgroundTransparency = 1
            keyLabel.Size = UDim2.new(1, 0, 1, 0)
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.TextSize = 9
            keyLabel.TextColor3 = Library.AccentColor
            keyLabel.Text = keyStr
            keyLabel.ZIndex = card.ZIndex + 4
            keyLabel.Parent = keyBadge
            Library:AddToRegistry(keyLabel, { TextColor3 = "AccentColor" })
            
            -- Adjust badge width to fit key text
            local textWidth = math.max(12, #keyStr * 7 + 8)
            keyBadge.Size = UDim2.new(0, textWidth, 0, 14)
            
            -- Action name label
            local actionLabel = Instance.new("TextLabel")
            actionLabel.Name = "ActionText"
            actionLabel.BackgroundTransparency = 1
            actionLabel.Size = UDim2.new(1, -(textWidth + 16 + (typeName ~= "" and 50 or 0)), 1, 0)
            actionLabel.Position = UDim2.new(0, textWidth + 14, 0, 0)
            actionLabel.Font = Enum.Font.GothamMedium
            actionLabel.TextSize = 10
            actionLabel.TextColor3 = Color3.fromRGB(200, 195, 215)
            actionLabel.TextXAlignment = Enum.TextXAlignment.Left
            actionLabel.TextTruncate = Enum.TextTruncate.AtEnd
            actionLabel.Text = actionName
            actionLabel.ZIndex = card.ZIndex + 3
            actionLabel.Parent = card
            
            -- Type tag (Toggle/Hold) as a subtle pill on the right
            if typeName ~= "" then
                local typeTag = Instance.new("Frame")
                typeTag.Name = "TypeTag"
                typeTag.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
                typeTag.BackgroundTransparency = 0.2
                typeTag.BorderSizePixel = 0
                typeTag.Size = UDim2.new(0, 42, 0, 12)
                typeTag.Position = UDim2.new(1, -48, 0.5, -6)
                typeTag.ZIndex = card.ZIndex + 3
                typeTag.Parent = card
                addCorner(typeTag, 4)
                
                local typeLabel = Instance.new("TextLabel")
                typeLabel.Name = "TypeText"
                typeLabel.BackgroundTransparency = 1
                typeLabel.Size = UDim2.new(1, 0, 1, 0)
                typeLabel.Font = Enum.Font.Gotham
                typeLabel.TextSize = 8
                typeLabel.TextColor3 = Color3.fromRGB(140, 135, 160)
                typeLabel.Text = typeName
                typeLabel.ZIndex = card.ZIndex + 4
                typeLabel.Parent = typeTag
            end
            
            -- Hover effect on card
            local hoverStroke = Instance.new("UIStroke")
            hoverStroke.Name = "HoverGlow"
            hoverStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            hoverStroke.Thickness = 1
            hoverStroke.Transparency = 1
            hoverStroke.Parent = card
            Library:AddToRegistry(hoverStroke, { Color = "AccentColor" })
            
            local tIn = TweenService:Create(hoverStroke, TweenInfo.new(0.15), {Transparency = 0.5})
            local tOut = TweenService:Create(hoverStroke, TweenInfo.new(0.25), {Transparency = 1})
            card.MouseEnter:Connect(function() tIn:Play() end)
            card.MouseLeave:Connect(function() tOut:Play() end)
            
            -- Watch for text changes to update our overlay
            label:GetPropertyChangedSignal("Text"):Connect(function()
                local newText = label.Text or ""
                local nKey = newText:match("%[(.-)%]") or ""
                local nAction = newText:match("%]%s*(.+)") or newText
                local nType = nAction:match("%((.-)%)%s*$") or ""
                if nType ~= "" then
                    nAction = nAction:gsub("%s*%(" .. nType .. "%)%s*$", "")
                end
                nAction = nAction:match("^%s*(.-)%s*$") or nAction
                pcall(function() keyLabel.Text = nKey end)
                pcall(function() actionLabel.Text = nAction end)
                local tw = math.max(12, #nKey * 7 + 8)
                pcall(function() keyBadge.Size = UDim2.new(0, tw, 0, 14) end)
                pcall(function() actionLabel.Position = UDim2.new(0, tw + 14, 0, 0) end)
                local typeTag = card:FindFirstChild("TypeTag")
                if typeTag then
                    local tl = typeTag:FindFirstChild("TypeText")
                    if tl then tl.Text = nType end
                end
            end)
            
            local tag = Instance.new("BoolValue")
            tag.Name = "KBStyled"
            tag.Parent = label
        end
        
        -- Style existing entries
        for _, child in ipairs(kf:GetChildren()) do
            styleEntry(child)
        end
        
        -- Style new entries when they appear
        kf.ChildAdded:Connect(function(child)
            task.wait(0.05)
            styleEntry(child)
        end)
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








