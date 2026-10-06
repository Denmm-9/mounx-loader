--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                     MOUNX STYLE ENGINE                     ║
    ║              Premium UI layer for LinoriaLib               ║
    ║                                                            ║
    ║  Designed for: mstudio45/LinoriaLib                       ║
    ║  Does not replace Linoria's controls or functionality.     ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local MounxStyle = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// ============================================================
--// CONFIGURATION
--// ============================================================

local Config = {

    -- Main shape
    WindowRadius = 15,
    SectionRadius = 11,
    GroupRadius = 9,
    ControlRadius = 7,
    SmallRadius = 5,

    -- Borders
    BorderThickness = 1,
    BorderTransparency = 0.55,

    -- Animation
    AnimationSpeed = 0.16,
    HoverSpeed = 0.12,

    -- Glow
    EnableGlow = true,
    GlowTransparency = 0.90,
    GlowSize = 22,

    -- Header
    HeaderHeight = 30,

    -- Tabs
    TabHeight = 25,
    TabRadius = 7,

    -- Controls
    ButtonHeight = 27,
    ControlHeight = 25,

    -- Shadows
    EnableShadow = true,
    ShadowTransparency = 0.72,

    -- Background
    MainTransparency = 0,
    SectionTransparency = 0,

    -- Typography
    Font = Enum.Font.Gotham,
    FontMedium = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,

    -- Mobile
    MobileControlScale = 1.08,

    -- Accent behavior
    AccentGlow = true,
    AccentGlowTransparency = 0.82,

    -- Do not touch these
    ProtectExistingControls = true,
}

MounxStyle.Config = Config

--// ============================================================
--// INTERNAL STATE
--// ============================================================

local Library
local Window
local Holder

local Connections = {}
local Styled = {}
local HoverStates = {}

local AccentObjects = {}
local DynamicObjects = {}

--// ============================================================
--// UTILITY
--// ============================================================

local function Safe(callback, ...)
    local ok, result = pcall(callback, ...)
    if ok then
        return result
    end

    return nil
end

local function IsGui(object)
    return typeof(object) == "Instance"
        and object:IsA("GuiObject")
end

local function IsAlive(object)
    return object
        and typeof(object) == "Instance"
        and object.Parent ~= nil
end

local function GetAccent()
    if Library and Library.AccentColor then
        return Library.AccentColor
    end

    return Color3.fromRGB(168, 85, 247)
end

local function GetMain()
    if Library and Library.MainColor then
        return Library.MainColor
    end

    return Color3.fromRGB(20, 20, 25)
end

local function GetBackground()
    if Library and Library.BackgroundColor then
        return Library.BackgroundColor
    end

    return Color3.fromRGB(10, 10, 15)
end

local function GetOutline()
    if Library and Library.OutlineColor then
        return Library.OutlineColor
    end

    return Color3.fromRGB(30, 30, 40)
end

local function GetFontColor()
    if Library and Library.FontColor then
        return Library.FontColor
    end

    return Color3.fromRGB(255, 255, 255)
end

local function Lighten(color, amount)
    local h, s, v = Color3.toHSV(color)

    return Color3.fromHSV(
        h,
        math.clamp(s - 0.03, 0, 1),
        math.clamp(v + amount, 0, 1)
    )
end

local function Darken(color, amount)
    local h, s, v = Color3.toHSV(color)

    return Color3.fromHSV(
        h,
        math.clamp(s + 0.02, 0, 1),
        math.clamp(v - amount, 0, 1)
    )
end

local function Tween(object, properties, duration, style, direction)
    if not IsAlive(object) then
        return
    end

    Safe(function()
        TweenService:Create(
            object,
            TweenInfo.new(
                duration or Config.AnimationSpeed,
                style or Enum.EasingStyle.Quint,
                direction or Enum.EasingDirection.Out
            ),
            properties
        ):Play()
    end)
end

local function Register(object, properties)
    if not Library
        or not Library.AddToRegistry
        or not IsAlive(object) then
        return
    end

    Safe(function()
        Library:AddToRegistry(object, properties)
    end)
end

--// ============================================================
--// INSTANCE HELPERS
--// ============================================================

local function GetOrCreateCorner(object, radius)
    if not IsGui(object) then
        return
    end

    local corner = object:FindFirstChild("MounxCorner")

    if corner and corner:IsA("UICorner") then
        corner.CornerRadius = UDim.new(0, radius)
        return corner
    end

    corner = Instance.new("UICorner")
    corner.Name = "MounxCorner"
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object

    return corner
end

local function GetOrCreateStroke(object, color, transparency, thickness)
    if not IsGui(object) then
        return
    end

    local stroke = object:FindFirstChild("MounxStroke")

    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "MounxStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = object
    end

    stroke.Color = color or GetOutline()
    stroke.Transparency = transparency or Config.BorderTransparency
    stroke.Thickness = thickness or Config.BorderThickness

    return stroke
end

local function GetOrCreateGradient(object)
    if not IsGui(object) then
        return
    end

    local gradient = object:FindFirstChild("MounxGradient")

    if gradient and gradient:IsA("UIGradient") then
        return gradient
    end

    gradient = Instance.new("UIGradient")
    gradient.Name = "MounxGradient"
    gradient.Rotation = 90
    gradient.Parent = object

    return gradient
end

local function SetGradient(object, first, second, rotation)
    local gradient = GetOrCreateGradient(object)

    if not gradient then
        return
    end

    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, first),
        ColorSequenceKeypoint.new(0.48, second),
        ColorSequenceKeypoint.new(1, first),
    })

    gradient.Rotation = rotation or 90

    return gradient
end

local function AddPadding(object, left, right, top, bottom)
    if not IsGui(object) then
        return
    end

    local padding = object:FindFirstChild("MounxPadding")

    if not padding then
        padding = Instance.new("UIPadding")
        padding.Name = "MounxPadding"
        padding.Parent = object
    end

    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)

    return padding
end

--// ============================================================
--// SOFT SHADOW
--// ============================================================

local function CreateShadow(target)
    if not Config.EnableShadow then
        return
    end

    if not IsGui(target) then
        return
    end

    if target:FindFirstChild("MounxShadow") then
        return target.MounxShadow
    end

    local shadow = Instance.new("ImageLabel")

    shadow.Name = "MounxShadow"

    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(
        1,
        Config.GlowSize,
        1,
        Config.GlowSize
    )

    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 0

    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = Config.ShadowTransparency

    shadow.ZIndex = math.max(target.ZIndex - 1, 0)

    shadow.Parent = target

    return shadow
end

--// ============================================================
--// ACCENT GLOW
--// ============================================================

local function CreateAccentGlow(target, size)
    if not Config.AccentGlow then
        return
    end

    if not IsGui(target) then
        return
    end

    local existing = target:FindFirstChild("MounxAccentGlow")

    if existing then
        return existing
    end

    local glow = Instance.new("Frame")

    glow.Name = "MounxAccentGlow"

    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.fromScale(0.5, 0.5)

    glow.Size = UDim2.new(
        1,
        size or 12,
        1,
        size or 12
    )

    glow.BackgroundColor3 = GetAccent()
    glow.BackgroundTransparency = Config.AccentGlowTransparency

    glow.BorderSizePixel = 0
    glow.ZIndex = math.max(target.ZIndex - 1, 0)

    glow.Parent = target

    GetOrCreateCorner(
        glow,
        (size or 12) / 2
    )

    table.insert(AccentObjects, glow)

    return glow
end

--// ============================================================
--// WINDOW
--// ============================================================

local function StyleWindow()
    if not Holder then
        return
    end

    -- Outer window
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0

    GetOrCreateCorner(
        Holder,
        Config.WindowRadius
    )

    CreateShadow(Holder)

    -- Main inner window
    local inner = Holder:FindFirstChild("Frame")

    if inner then
        inner.BackgroundColor3 = GetMain()
        inner.BorderSizePixel = 0

        GetOrCreateCorner(
            inner,
            Config.WindowRadius - 2
        )

        local stroke = GetOrCreateStroke(
            inner,
            GetAccent(),
            0.35,
            1
        )

        Register(inner, {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "AccentColor",
        })

        if stroke then
            Register(stroke, {
                Color = "AccentColor",
            })
        end

        SetGradient(
            inner,
            Lighten(GetMain(), 0.025),
            GetMain(),
            90
        )
    end
end

--// ============================================================
--// WINDOW TITLE
--// ============================================================

local function StyleWindowTitle()
    if not Holder then
        return
    end

    for _, object in ipairs(Holder:GetDescendants()) do
        if object:IsA("TextLabel") then

            local text = object.Text or ""

            if text == ""
                or text == Window.Title then

                object.Font = Config.FontBold
                object.TextSize = 15
                object.TextColor3 = GetFontColor()

                object.TextStrokeTransparency = 1

                Register(object, {
                    TextColor3 = "FontColor",
                })
            end
        end
    end
end

--// ============================================================
--// MAIN CONTENT CONTAINER
--// ============================================================

local function StyleMainContainers()
    if not Holder then
        return
    end

    for _, object in ipairs(Holder:GetDescendants()) do

        if object:IsA("Frame") then

            local name = object.Name:lower()

            -- Main section
            if name:find("mainsection") then

                object.BorderSizePixel = 0

                GetOrCreateCorner(
                    object,
                    Config.SectionRadius
                )

                Register(object, {
                    BackgroundColor3 = "BackgroundColor",
                    BorderColor3 = "OutlineColor",
                })

            -- Tab container
            elseif name == "tabcontainer" then

                object.BorderSizePixel = 0

                GetOrCreateCorner(
                    object,
                    Config.SectionRadius
                )

                local stroke = GetOrCreateStroke(
                    object,
                    GetOutline(),
                    0.55
                )

                Register(object, {
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                })

                if stroke then
                    Register(stroke, {
                        Color = "OutlineColor",
                    })
                end

            end
        end
    end
end

--// ============================================================
--// TAB SYSTEM
--// ============================================================

local function StyleTabButton(tabButton)
    if not IsGui(tabButton) then
        return
    end

    if Styled[tabButton] then
        return
    end

    Styled[tabButton] = true

    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false

    GetOrCreateCorner(
        tabButton,
        Config.TabRadius
    )

    Register(tabButton, {
        BackgroundColor3 = "BackgroundColor",
    })

    -- Find the label
    local label

    for _, child in ipairs(tabButton:GetChildren()) do
        if child:IsA("TextLabel") then
            label = child
            break
        end
    end

    if label then
        label.Font = Config.FontMedium
        label.TextSize = 13
        label.TextColor3 = GetFontColor()

        Register(label, {
            TextColor3 = "FontColor",
        })
    end

    -- Active indicator
    local indicator = Instance.new("Frame")

    indicator.Name = "MounxTabIndicator"

    indicator.AnchorPoint = Vector2.new(0.5, 1)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)

    indicator.Size = UDim2.new(
        0,
        0,
        0,
        2
    )

    indicator.BackgroundColor3 = GetAccent()
    indicator.BackgroundTransparency = 0

    indicator.BorderSizePixel = 0

    indicator.ZIndex = tabButton.ZIndex + 5

    indicator.Parent = tabButton

    GetOrCreateCorner(
        indicator,
        2
    )

    Register(indicator, {
        BackgroundColor3 = "AccentColor",
    })

    -- Soft active glow
    local glow = Instance.new("Frame")

    glow.Name = "MounxTabGlow"

    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.fromScale(0.5, 0.5)

    glow.Size = UDim2.new(
        1,
        -6,
        1,
        -4
    )

    glow.BackgroundColor3 = GetAccent()
    glow.BackgroundTransparency = 1

    glow.BorderSizePixel = 0

    glow.ZIndex = tabButton.ZIndex + 1

    glow.Parent = tabButton

    GetOrCreateCorner(
        glow,
        Config.TabRadius
    )

    Register(glow, {
        BackgroundColor3 = "AccentColor",
    })

    local function HoverIn()
        if not IsAlive(tabButton) then
            return
        end

        HoverStates[tabButton] = true

        Tween(tabButton, {
            BackgroundColor3 = Lighten(
                GetBackground(),
                0.025
            ),
        }, Config.HoverSpeed)

        Tween(indicator, {
            Size = UDim2.new(
                0.52,
                0,
                0,
                2
            )
        }, Config.HoverSpeed)

        if label then
            Tween(label, {
                TextColor3 = GetAccent(),
            }, Config.HoverSpeed)
        end
    end

    local function HoverOut()
        if not IsAlive(tabButton) then
            return
        end

        HoverStates[tabButton] = false

        Tween(tabButton, {
            BackgroundColor3 = GetBackground(),
        }, Config.HoverSpeed)

        Tween(indicator, {
            Size = UDim2.new(
                0,
                0,
                0,
                2
            )
        }, Config.HoverSpeed)

        if label then
            Tween(label, {
                TextColor3 = GetFontColor(),
            }, Config.HoverSpeed)
        end
    end

    tabButton.MouseEnter:Connect(HoverIn)
    tabButton.MouseLeave:Connect(HoverOut)

    -- Touch feedback
    tabButton.InputBegan:Connect(function(input)

        if input.UserInputType
            == Enum.UserInputType.Touch then

            Tween(glow, {
                BackgroundTransparency = 0.92
            }, 0.08)

            task.delay(0.12, function()
                if IsAlive(glow) then
                    Tween(glow, {
                        BackgroundTransparency = 1
                    }, 0.18)
                end
            end)
        end
    end)
end

local function StyleTabs()
    if not Holder then
        return
    end

    for _, object in ipairs(
        Holder:GetDescendants()
    ) do

        if object.Name == "TabFrame" then
            continue
        end

        if object:IsA("Frame") then

            local parent = object.Parent

            if parent
                and parent:IsA("ScrollingFrame")
                and parent.Parent then

                if parent.Parent.Name == "MainSectionInner" then
                    StyleTabButton(object)
                end
            end
        end
    end
end

--// ============================================================
--// GROUPBOXES
--// ============================================================

local function StyleGroupbox(box)
    if not IsGui(box) then
        return
    end

    if Styled[box] then
        return
    end

    Styled[box] = true

    box.BorderSizePixel = 0

    GetOrCreateCorner(
        box,
        Config.GroupRadius
    )

    Register(box, {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
    })

    local stroke = GetOrCreateStroke(
        box,
        GetOutline(),
        0.58
    )

    if stroke then
        Register(stroke, {
            Color = "OutlineColor",
        })
    end

    -- Find inner container
    local inner

    for _, child in ipairs(box:GetChildren()) do
        if child:IsA("Frame") then
            inner = child
            break
        end
    end

    if inner then

        inner.BorderSizePixel = 0

        GetOrCreateCorner(
            inner,
            Config.GroupRadius - 1
        )

        Register(inner, {
            BackgroundColor3 = "BackgroundColor",
        })

        SetGradient(
            inner,
            Lighten(
                GetBackground(),
                0.015
            ),
            GetBackground(),
            90
        )
    end

    -- Replace the traditional horizontal accent
    -- with a subtle top highlight.
    for _, child in ipairs(box:GetDescendants()) do

        if child:IsA("Frame")
            and child.Name == "Highlight" then

            child.BorderSizePixel = 0

            child.Size = UDim2.new(
                1,
                -18,
                0,
                2
            )

            child.Position = UDim2.new(
                0,
                9,
                0,
                0
            )

            GetOrCreateCorner(
                child,
                2
            )

            Register(child, {
                BackgroundColor3 = "AccentColor",
            })
        end
    end
end

local function StyleGroupboxes()
    if not Holder then
        return
    end

    for _, object in ipairs(
        Holder:GetDescendants()
    ) do

        if object:IsA("Frame") then

            local name = object.Name:lower()

            if name == "boxouter" then
                StyleGroupbox(object)
            end
        end
    end
end

--// ============================================================
--// TEXT
--// ============================================================

local function StyleText(object)
    if not object:IsA("TextLabel")
        and not object:IsA("TextButton")
        and not object:IsA("TextBox") then
        return
    end

    if not Holder
        or not object:IsDescendantOf(Hold
