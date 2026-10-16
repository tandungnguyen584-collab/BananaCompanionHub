-- Banana-inspired Blox Fruits Companion Hub
-- Safe UI prototype for Roblox Studio. This is NOT an exploit/executor script.
-- Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
-- It provides a draggable menu and informational toggles only; it does not automate
-- gameplay, read hidden game state, teleport, reveal players, or modify Blox Fruits.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("BananaCompanionHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "BananaCompanionHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = playerGui

local YELLOW = Color3.fromRGB(255, 205, 55)
local BG = Color3.fromRGB(22, 23, 29)
local PANEL = Color3.fromRGB(31, 33, 41)
local TEXT = Color3.fromRGB(245, 245, 245)
local MUTED = Color3.fromRGB(170, 174, 185)
local GREEN = Color3.fromRGB(100, 220, 145)

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local main = make("Frame", {
    Name = "Main", Size = UDim2.new(0, 350, 0, 390),
    Position = UDim2.new(0.5, -175, 0.5, -195),
    BackgroundColor3 = BG, BorderSizePixel = 0
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
make("UIStroke", {Color = YELLOW, Thickness = 1.5, Transparency = 0.15}, main)

local top = make("Frame", {
    Name = "TopBar", Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = PANEL, BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, top)
make("Frame", {Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = PANEL, BorderSizePixel = 0}, top)

make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 0),
    Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.GothamBold,
    Text = "🍌  BANANA • COMPANION", TextColor3 = YELLOW,
    TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = make("TextButton", {
    Size = UDim2.new(0, 34, 0, 30), Position = UDim2.new(1, -42, 0, 9),
    BackgroundColor3 = Color3.fromRGB(75, 43, 43), Text = "×",
    TextColor3 = TEXT, TextSize = 22, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0, AutoButtonColor = true
}, top)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Drag with mouse or touch
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local tabs = make("Frame", {
    Position = UDim2.new(0, 10, 0, 58), Size = UDim2.new(1, -20, 0, 36),
    BackgroundTransparency = 1
}, main)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, tabs)

local content = make("ScrollingFrame", {
    Name = "Content", Position = UDim2.new(0, 10, 0, 102),
    Size = UDim2.new(1, -20, 1, -112), BackgroundColor3 = PANEL,
    BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = YELLOW,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, content)
make("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, content)
local contentLayout = make("UIListLayout", {Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder}, content)

local pages = {}
local tabButtons = {}
local function newPage(name)
    local page = make("Frame", {Name = name, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false}, content)
    make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    pages[name] = page
    return page
end

local function label(parent, text, color, height)
    return make("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height or 42),
        Font = Enum.Font.Gotham, Text = text, TextColor3 = color or TEXT,
        TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function actionButton(parent, title, description, callback)
    local b = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = BG,
        BorderSizePixel = 0, Text = "", AutoButtonColor = true
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 4),
        Size = UDim2.new(1, -20, 0, 20), Font = Enum.Font.GothamBold,
        Text = title, TextColor3 = YELLOW, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left}, b)
    make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 24),
        Size = UDim2.new(1, -20, 0, 20), Font = Enum.Font.Gotham,
        Text = description, TextColor3 = MUTED, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left}, b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local farm = newPage("Farm")
label(farm, "PLAYER COMPANION", YELLOW, 24)
label(farm, "These are checklists, not automation. Use the in-game quest giver and controls.", MUTED, 42)
local questNote = label(farm, "Quest checklist: talk to the NPC → accept a quest for your level → defeat the listed enemies → return if required.", TEXT, 58)
actionButton(farm, "Quest checklist", "Show a quick reminder", function()
    questNote.Text = "1) Find the quest NPC.  2) Check the level requirement.  3) Accept the quest.  4) Defeat only the listed targets."
end)
actionButton(farm, "Grinding tips", "Legitimate gameplay reminders", function()
    questNote.Text = "Use a fighting style or fruit that suits your build, spend stats deliberately, and choose quests close to your level."
end)
actionButton(farm, "Auto Farm", "Not available in this safe companion", function()
    questNote.Text = "Auto Farm is not implemented: this companion does not control your character or automate combat."
end)

local utility = newPage("Utility")
label(utility, "PLAYER UTILITIES", YELLOW, 24)
local utilNote = label(utility, "Choose a helper below. Nothing here scans hidden game data.", MUTED, 42)
actionButton(utility, "Fruit Finder", "Manual search checklist", function()
    utilNote.Text = "Fruit reminder: check the game's official fruit dealer/stock interface and explore public areas. This tool cannot locate hidden fruit spawns."
end)
actionButton(utility, "Teleport", "Use in-game travel methods", function()
    utilNote.Text = "Teleport helper: use only travel/teleport options provided by the game itself. No remote calls or position spoofing are used."
end)
actionButton(utility, "ESP", "Fair-play alternative", function()
    utilNote.Text = "ESP is not included. This companion does not reveal players, NPCs, or objects through walls."
end)

local raid = newPage("Raid")
label(raid, "RAID HELPER", YELLOW, 24)
local raidNote = label(raid, "Raid prep checklist: bring a suitable build, confirm the raid type, and coordinate with teammates.", TEXT, 54)
actionButton(raid, "Preparation checklist", "Review before starting", function()
    raidNote.Text = "Before raid: check your build and available resources, tell teammates your role, and use the game's own raid-start interaction."
end)
actionButton(raid, "Team roles", "Simple coordination reminder", function()
    raidNote.Text = "Team tip: agree who clears groups, who handles tougher enemies, and when to regroup. Adapt to your team's actual abilities."
end)

local settings = newPage("Settings")
label(settings, "SETTINGS", YELLOW, 24)
local status = label(settings, "Status: Companion UI loaded.", GREEN, 28)
actionButton(settings, "Reset panel position", "Move the menu to the center", function()
    main.Position = UDim2.new(0.5, -175, 0.5, -195)
    status.Text = "Status: Panel position reset."
end)
actionButton(settings, "About", "What this prototype does", function()
    status.Text = "Status: UI prototype only. No exploit executor, game-state scraping, or automated gameplay."
end)

local function showPage(name)
    for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
    for tabName, button in pairs(tabButtons) do
        button.BackgroundColor3 = (tabName == name) and YELLOW or BG
        button.TextColor3 = (tabName == name) and BG or TEXT
    end
end

for i, name in ipairs({"Farm", "Utility", "Raid", "Settings"}) do
    local b = make("TextButton", {
        Name = name .. "Tab", Size = UDim2.new(0, 78, 0, 34),
        BackgroundColor3 = BG, BorderSizePixel = 0, Text = name,
        TextColor3 = TEXT, TextSize = 12, Font = Enum.Font.GothamBold,
        LayoutOrder = i, AutoButtonColor = true
    }, tabs)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    tabButtons[name] = b
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

showPage("Farm")
