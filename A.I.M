local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Pembolehubah
local espEnabled = false
local espSize = 1
local hitboxSizeMultiplier = 1
local espColor = Color3.fromRGB(0, 0, 255) -- Biru
local hitboxColor = Color3.fromRGB(255, 0, 0) -- Merah
local gui, scanFrame
local partDetectionEnabled = false

-- Senarai warna yang tersedia
local colors = {
    ["red"] = Color3.fromRGB(255, 0, 0),
    ["blue"] = Color3.fromRGB(0, 0, 255),
    ["green"] = Color3.fromRGB(0, 255, 0),
    ["yellow"] = Color3.fromRGB(255, 255, 0),
    ["purple"] = Color3.fromRGB(128, 0, 128),
    ["orange"] = Color3.fromRGB(255, 165, 0),
    ["white"] = Color3.fromRGB(255, 255, 255),
    ["black"] = Color3.fromRGB(0, 0, 0),
    ["merah"] = Color3.fromRGB(255, 0, 0),
    ["biru"] = Color3.fromRGB(0, 0, 255),
    ["hijau"] = Color3.fromRGB(0, 255, 0),
    ["kuning"] = Color3.fromRGB(255, 255, 0),
    ["ungu"] = Color3.fromRGB(128, 0, 128),
    ["jingga"] = Color3.fromRGB(255, 165, 0),
    ["putih"] = Color3.fromRGB(255, 255, 255),
    ["hitam"] = Color3.fromRGB(0, 0, 0),
}

-- Fungsi untuk toggle ESP
local function toggleESP()
    espEnabled = not espEnabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if espEnabled then
                        local espBox = Instance.new("BoxHandleAdornment")
                        espBox.Size = part.Size * espSize
                        espBox.Color3 = espColor
                        espBox.AlwaysOnTop = true
                        espBox.ZIndex = 5
                        espBox.Adornee = part
                        espBox.Parent = part
                    else
                        for _, adornment in ipairs(part:GetChildren()) do
                            if adornment:IsA("BoxHandleAdornment") then
                                adornment:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Fungsi untuk toggle hitboxes
local function toggleHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hitbox = player.Character:FindFirstChild("HumanoidRootPart")
            if hitbox then
                hitbox.Size = Vector3.new(2, 2, 1) * hitboxSizeMultiplier
                hitbox.Color3 = hitboxColor
                hitbox.Transparency = 0.5
                local highlight = Instance.new("SelectionBox", hitbox)
                highlight.Adornee = hitbox
                highlight.LineThickness = 0.1
                highlight.Color3 = hitboxColor
            end
        end
    end
end

-- Fungsi untuk menjadikan GUI boleh digerakkan
local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Penyiapan GUI
local function createGUI()
    if gui then gui:Destroy() end

    gui = Instance.new("ScreenGui")
    gui.Name = "UtilityGUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 15)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -30, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "HB Script"
    title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Active = true

    makeDraggable(frame)  -- Jadikan keseluruhan bingkai boleh digerakkan

    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true

    local espButton = Instance.new("TextButton", frame)
    espButton.Size = UDim2.new(0.9, 0, 0, 50)
    espButton.Position = UDim2.new(0.05, 0, 0.5, -25)
    espButton.Text = "Toggle ESP"
    espButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.TextScaled = true

    local hitboxButton = Instance.new("TextButton", frame)
    hitboxButton.Size = UDim2.new(0.9, 0, 0, 50)
    hitboxButton.Position = UDim2.new(0.05, 0, 0.8, -25)
    hitboxButton.Text = "Toggle Hitbox"
    hitboxButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    hitboxButton.TextColor3 = Color3.new(1, 1, 1)
    hitboxButton.TextScaled = true

    espButton.MouseButton1Click:Connect(toggleESP)
    hitboxButton.MouseButton1Click:Connect(toggleHitboxes)

    closeButton.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    scanFrame = Instance.new("Frame", gui)
    scanFrame.Size = UDim2.new(0, 300, 0, 100)
    scanFrame.Position = UDim2.new(0.5, -150, 0.5, 100)
    scanFrame.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    scanFrame.Visible = false

    local scanLabel = Instance.new("TextLabel", scanFrame)
    scanLabel.Size = UDim2.new(1, 0, 1, 0)
    scanLabel.Position = UDim2.new(0, 0, 0, 0)
    scanLabel.Text = "Scanning..."
    scanLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    scanLabel.TextColor3 = Color3.new(1, 1, 1)
    scanLabel.TextScaled = true
end

-- Memulakan GUI
createGUI()

-- Fungsi untuk memproses perintah sembang
local function processChatCommand(message)
    local args = {}
    for word in message:gmatch("%S+") do
        table.insert(args, word)
    end

    if args[1] == "/esp" and args[2] then
        -- Ubah saiz atau warna ESP
        local newSize = tonumber(args[2])
        if newSize then
            espSize = newSize
            print("ESP size set to:", espSize)
        elseif colors[args[2]:lower()] then
            espColor = colors[args[2]:lower()]
            print("ESP color set to:", args[2])
        end
    elseif args[1] == "/hitbox" and args[2] then
        -- Ubah saiz atau warna Hitbox
        local newSize = tonumber(args[2])
        if newSize then
            hitboxSizeMultiplier = newSize
            print("Hitbox size set to:", hitboxSizeMultiplier)
        elseif colors[args[2]:lower()] then
            hitboxColor = colors[args[2]:lower()]
            print("Hitbox color set to:", args[2])
        end
    elseif args[1] == "/refresh" then
        createGUI()
        print("GUI refreshed")
    elseif args[1] == "/parton" then
        partDetectionEnabled = true
        print("Part detection enabled")
    elseif args[1] == "/partoff" then
        partDetectionEnabled = false
        print("Part detection disabled")
    end
end

-- Pastikan GUI kekal selepas respawn
LocalPlayer.CharacterAdded:Connect(function()
    RunService.RenderStepped:Wait()
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

-- Sambungkan perintah sembang
LocalPlayer.Chatted:Connect(function(message)
    if message == "/hb" then
        gui.Enabled = true
    else
        processChatCommand(message)
    end
end)

-- Fungsi untuk mengesan sentuhan part
local function enablePartDetection()
    if Character then
        Character:FindFirstChildOfClass("Humanoid").Touched:Connect(function(hit)
            if partDetectionEnabled and hit:IsA("BasePart") then
                print("Touched part:", hit.Name)
            end
        end)
    end
end

enablePartDetection()
