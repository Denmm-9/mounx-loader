return function(Library)
    local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- Si no es móvil, no hacemos nada y el script sigue normal en PC
    if not isMobile then return end
    
    local LP = game:GetService("Players").LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- 1. Auto-Escalado
    if Library.ScreenGui then
        local uiScale = Instance.new("UIScale")
        uiScale.Parent = Library.ScreenGui
        local function updateScale()
            local vpY = camera.ViewportSize.Y
            if vpY < 650 then
                uiScale.Scale = math.clamp(vpY / 700, 0.55, 1)
            else
                uiScale.Scale = 1
            end
        end
        updateScale()
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    -- 2. Botón flotante
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "MounxMobileToggle"
    toggleGui.ResetOnSpawn = false
    
    local success = pcall(function()
        if gethui then toggleGui.Parent = gethui() 
        else toggleGui.Parent = game:GetService("CoreGui") end
    end)
    if not success then toggleGui.Parent = LP:WaitForChild("PlayerGui") end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 48, 0, 48)
    btn.Position = UDim2.new(0, 15, 0.5, -24)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = "M"
    btn.TextColor3 = Color3.fromRGB(168, 85, 247)
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    btn.Parent = toggleGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(168, 85, 247)
    stroke.Thickness = 1.5
    stroke.Parent = btn

    local isDragging, hasMoved, dragStart, startPos = false, false, nil, nil
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    btn.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and isDragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            if not hasMoved then Library:Toggle() end
        end
    end)
    
    -- Interceptar el Unload original para borrar también el botón flotante
    local oldUnload = Library.Unload
    Library.Unload = function(...)
        if toggleGui then toggleGui:Destroy() end
        if oldUnload then return oldUnload(...) end
    end
end
