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
    
    -- 4. OCULTAR OPCIONES MOLESTAS (.webm video background)
    pcall(function()
        if Library.Options.VideoLink then
            Library.Options.VideoLink:SetVisible(false)
        end
    end)
end

return MounxHub
