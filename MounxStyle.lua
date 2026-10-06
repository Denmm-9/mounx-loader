local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==================================================
-- TEMAS PERSONALIZADOS MOUNX
-- ==================================================
Library.AccentColor = Color3.fromRGB(168, 85, 247) 
Library.MainColor = Color3.fromRGB(20, 20, 25)
Library.FontColor = Color3.fromRGB(255, 255, 255)

ThemeManager.BuiltInThemes['Mounx Default'] = { 1, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141419","AccentColor":"a855f7","BackgroundColor":"0a0a0f","OutlineColor":"1e1e28"}') }
ThemeManager.BuiltInThemes['Dark Neon'] = { 9, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a0a0a","AccentColor":"00ff88","BackgroundColor":"050505","OutlineColor":"1a1a1a"}') }
ThemeManager.BuiltInThemes['Bloody Red'] = { 10, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"140000","AccentColor":"ff0000","BackgroundColor":"0a0000","OutlineColor":"280000"}') }
ThemeManager.BuiltInThemes['Deep Ocean'] = { 11, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"000a14","AccentColor":"0088ff","BackgroundColor":"00050a","OutlineColor":"001428"}') }
ThemeManager.BuiltInThemes['Cyberpunk'] = { 12, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"1a001a","AccentColor":"ff00ff","BackgroundColor":"0d000d","OutlineColor":"330033"}') }
ThemeManager.BuiltInThemes['Gold Luxury'] = { 13, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"141100","AccentColor":"ffd700","BackgroundColor":"0a0900","OutlineColor":"282200"}') }
ThemeManager.BuiltInThemes['Amethyst'] = { 14, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0f0a14","AccentColor":"9b59b6","BackgroundColor":"0a0510","OutlineColor":"1e1428"}') }
ThemeManager.BuiltInThemes['Emerald'] = { 15, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffffff","MainColor":"0a140f","AccentColor":"2ecc71","BackgroundColor":"050a08","OutlineColor":"14281e"}') }
ThemeManager.BuiltInThemes['Crimson Night'] = { 16, game:GetService("HttpService"):JSONDecode('{"FontColor":"ffdddd","MainColor":"110000","AccentColor":"dc143c","BackgroundColor":"050000","OutlineColor":"220000"}') }
ThemeManager.BuiltInThemes['Ice White'] = { 17, game:GetService("HttpService"):JSONDecode('{"FontColor":"000000","MainColor":"f0f5ff","AccentColor":"00aaff","BackgroundColor":"ffffff","OutlineColor":"d0e0ff"}') }


local MounxHub = {}
MounxHub.Library = Library
MounxHub.ThemeManager = ThemeManager
MounxHub.SaveManager = SaveManager

-- ==================================================
-- CONSTRUCTOR AUTOMÁTICO DE SETTINGS
-- ==================================================


--// ============================================================
--// MOUNX STYLE ENGINE (Premium UI layer for LinoriaLib)
--// ============================================================
local MounxStyle = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Config = {
    WindowRadius = 12,
    SectionRadius = 8,
    GroupRadius = 6,
    ControlRadius = 4,
    AnimationSpeed = 0.15,
    HoverSpeed = 0.12,
    ShadowTransparency = 0.7,
}

local function Safe(cb, ...) local ok, res = pcall(cb, ...); return ok and res or nil end

local function GetOrCreateCorner(obj, rad)
    if not obj or not obj:IsA("GuiObject") then return end
    local corner = obj:FindFirstChild("MounxCorner")
    if not corner then
        corner = Instance.new("UICorner")
        corner.Name = "MounxCorner"
        corner.Parent = obj
    end
    corner.CornerRadius = UDim.new(0, rad)
    return corner
end

local function GetOrCreateStroke(obj, color, trans, thick)
    if not obj or not obj:IsA("GuiObject") then return end
    local stroke = obj:FindFirstChild("MounxStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "MounxStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj
    end
    if color then stroke.Color = color end
    if trans then stroke.Transparency = trans end
    if thick then stroke.Thickness = thick end
    return stroke
end

local function CreateShadow(target)
    if not target or not target:IsA("GuiObject") then return end
    if target:FindFirstChild("MounxShadow") then return end
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "MounxShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = Config.ShadowTransparency
    shadow.ZIndex = math.max(target.ZIndex - 1, 0)
    shadow.Parent = target
    return shadow
end

function MounxStyle:Apply(Library)
    if not Library or not Library.ScreenGui then return end
    local ScreenGui = Library.ScreenGui

    local function applyToObj(obj)
        if not obj:IsA("Frame") and not obj:IsA("TextButton") and not obj:IsA("TextBox") then return end
        local name = obj.Name:lower()
        
        -- Window Outer
        if name == "window" then
            GetOrCreateCorner(obj, Config.WindowRadius)
            CreateShadow(obj)
            obj.BorderSizePixel = 0
        end
        
        -- Window Inner Main
        if name == "main" or name == "inner" then
            GetOrCreateCorner(obj, Config.WindowRadius - 2)
            obj.BorderSizePixel = 0
        end
        
        -- Tab Containers and Inner frames
        if name == "tabcontainer" or name == "mainsectioninner" then
            GetOrCreateCorner(obj, Config.SectionRadius)
            obj.BorderSizePixel = 0
        end
        
        -- Groupboxes
        if name == "boxouter" then
            GetOrCreateCorner(obj, Config.GroupRadius)
            obj.BorderSizePixel = 0
        end
        if name == "boxinner" then
            GetOrCreateCorner(obj, Config.GroupRadius - 1)
            obj.BorderSizePixel = 0
        end

        -- Controls (Buttons, Toggles, Sliders, Dropdowns)
        if name == "button" or name == "slider" or name == "dropdown" or name == "list" then
            GetOrCreateCorner(obj, Config.ControlRadius)
        end
        
        -- Tab Buttons
        if obj:IsA("TextButton") and obj.Parent and obj.Parent.Name == "TabboxButtons" then
            GetOrCreateCorner(obj, 6)
            obj.BorderSizePixel = 0
        end
        
        -- Smooth out strokes
        if obj:FindFirstChildOfClass("UIStroke") and obj.Name ~= "MounxStroke" then
            local str = obj:FindFirstChildOfClass("UIStroke")
            str.LineJoinMode = Enum.LineJoinMode.Round
        end
    end

    -- Apply to existing
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        applyToObj(obj)
    end
    
    -- Apply to dynamically created elements (like dropdown lists)
    ScreenGui.DescendantAdded:Connect(function(obj)
        task.wait()
        if obj and obj.Parent then applyToObj(obj) end
    end)
end

function MounxHub:BuildSettings(SettingsTab, ConfigFolderName)
    -- 1. CREAR MENÚ DE KEYBIND Y UNLOAD
    local MenuGroup = SettingsTab:AddLeftGroupbox('Menu & Cerrar')
    
    MenuGroup:AddButton('Unload Script', function() Library:Unload() end)
    MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    -- 2. CONFIGURAR THEME Y SAVE MANAGER
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    
    ThemeManager:SetFolder('MounxHub')
    SaveManager:SetFolder('MounxHub/' .. (ConfigFolderName or 'GeneralConfigs'))
    
    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:ApplyToTab(SettingsTab)
    
    -- 3. FORZAR EL TEMA MOUNX DEFAULT
    ThemeManager:ApplyTheme('Mounx Default')
    
    -- 3.5 APLICAR ESTILO MOUNX
    task.spawn(function()
        task.wait(0.5)
        MounxStyle:Apply(Library)
    end)
    
    -- 4. OCULTAR OPCIONES MOLESTAS (.webm video background)
    pcall(function()
        if Library.Options.VideoLink then
            Library.Options.VideoLink:SetVisible(false)
        end
    end)
end

return MounxHub



