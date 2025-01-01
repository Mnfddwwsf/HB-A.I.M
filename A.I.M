local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Pembolehubah
local espEnabled = false
local espSize = 1
local hitboxSizeMultiplier = 1
local espColor = Color3.fromRGB(0, 0, 255) -- Biru
local hitboxColor = Color3.fromRGB(255, 0, 0) -- Merah
local gui, scanFrame

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

-- Fungsi untuk mencetak hasil imbasan
local function printScanResults()
    local playerCount = #Players:GetPlayers()
    local playerId = LocalPlayer.UserId
    local lagStatus = math.random() > 0.5 and "No Lag" or "Lag Detected"
    
    print("Scanning...")
    print(string.format("Player ID: %d", playerId))
    print(string.format("Player Count: %d", playerCount))
    print(string.format("Lag Status: %s", lagStatus))
end

-- Fungsi untuk menunjukkan bingkai imbasan
local function displayScanFrame()
    scanFrame.Visible = true
    wait(3)
    scanFrame.Visible = false
end

-- Fungsi untuk toggle ESP
local function toggleESP()
    espEnabled = not espEnabled
    printScanResults()
    displayScanFrame()
    
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
    printScanResults()
    displayScanFrame()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hitbox = player.Character:FindFirstChild("HumanoidRootPart")
            if hitbox then
                hitbox.Size = Vector3.new(2, 2, 1) * hitboxSizeMultiplier
                hitbox.Color3 = hitboxColor
                hitbox.Transparency = 0.5
            end
        end
    end
end

-- Fungsi untuk menjadikan GUI boleh digerakkan
local function makeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Penyiapan GUI
local function createGUI()
    gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "UtilityGUI"

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

    makeDraggable(frame)

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
