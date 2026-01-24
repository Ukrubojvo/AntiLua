assert(isfolder and makefolder, "Unable to create folder")
local _xpcall, _pcall, _task, _math = xpcall, pcall, task, math
if not isfolder("AntiLua") then
    makefolder("AntiLua")
end
if shared.AntiLuaLoading then
    return "Already Loaded"
end
if shared.AntiLuaLoader then
    return "already"
end
local function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
local run = function(func)
    _xpcall(func, function(err)
        shared.AntiLuaLoading = false
        shared.AntiLuaLoader = false
        warn("[AntiLua] An error has occurred!\n- Loader Script\n\n"..err)
    end)
end
local cloneref = missing("function", cloneref, function(...) return ... end)
local Services = setmetatable({}, {
    __index = function(self, name)
        self[name] = cloneref(game:GetService(name))
        return self[name]
    end
})
local lp = Services.Players.LocalPlayer
local printcolor = {
    coloredMessages = {},
    processedLabels = {},
    config = {
        showTimestamp = false
    }
}

local HttpService = Services.HttpService

function printcolor:getTimestamp()
    local time = os.date("*t")
    return string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
end

function printcolor:print(text, color, options)
    options = options or {}
    local showTime = options.showTimestamp
    if showTime == nil then
        showTime = self.config.showTimestamp
    end
    
    local displayText = text
    if showTime then displayText = self:getTimestamp() .. " - " .. text end
    local uniqueID = "[#" .. HttpService:GenerateGUID(false):sub(1, 8) .. "#]"
    local markedText = displayText .. uniqueID
    print(markedText)
    
    local finalColor
    if typeof(color) == "Color3" then
        finalColor = color
    elseif type(color) == "string" then
        local hex = color:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16) / 255
            local g = tonumber(hex:sub(3,4), 16) / 255
            local b = tonumber(hex:sub(5,6), 16) / 255
            finalColor = Color3.new(r, g, b)
        else
            warn("Incorrect hex format. Please use the #RRGGBB format.")
            return
        end
    elseif type(color) == "table" and #color == 3 then
        finalColor = Color3.fromRGB(color[1], color[2], color[3])
    else
        warn("The colour must be specified as Color3, a hex string, or an RGB table.")
        return
    end
    
    local iconId = options.icon
    
    self.coloredMessages[uniqueID] = {
        originalText = displayText,
        markedText = markedText,
        color = finalColor,
        icon = iconId,
        timestamp = os.clock()
    }
    
    local currentTime = os.clock()
    for id, data in pairs(self.coloredMessages) do
        if currentTime - data.timestamp > 300 then
            self.coloredMessages[id] = nil
        end
    end
end

function printcolor:processLabel(label)
    if self.processedLabels[label] then return end
    
    local labelText = label.Text
    for uniqueID, messageData in pairs(self.coloredMessages) do
        if labelText:find(uniqueID, 1, true) then
            label.TextColor3 = messageData.color
            label.Text = messageData.originalText
            self.processedLabels[label] = true
            
            if messageData.icon then
                local parent = label.Parent
                if parent then
                    local iconLabel = parent:FindFirstChildOfClass("ImageLabel")
                    if iconLabel then
                        iconLabel.Image = messageData.icon
                    end
                end
            end
            
            break
        end
    end
end

function printcolor:applyColors(devConsole)
    for _, child in ipairs(devConsole:GetDescendants()) do
        if (child:IsA("TextLabel") or child:IsA("TextButton")) and child.Text ~= "" then
            self:processLabel(child)
        end
    end
end

run(function()
    _task.spawn(function()
        local CoreGui = Services.CoreGui
        local DevConsole = CoreGui:WaitForChild("DevConsoleMaster", 10)
        if not DevConsole then return end
        
        _task.wait(0.5)
        printcolor:applyColors(DevConsole)
        
        DevConsole.DescendantAdded:Connect(function(descendant)
            if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and descendant.Text ~= "" then
                _task.wait(0.02)
                printcolor:processLabel(descendant)
            end
        end)
        
        while _task.wait(1) do
            printcolor:applyColors(DevConsole)
        end
    end)
end)

local LoadingUI = {}
run(function()
    shared.AntiLuaLoader = true
    local TweenService = Services.TweenService
    local isAnimating = false

    LoadingUI["1"] = Instance.new("ScreenGui", gethui() or Services.CoreGui)
    LoadingUI["1"]["Name"] = "LoadingUI"
    LoadingUI["1"]["DisplayOrder"] = 2147483647
    LoadingUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    LoadingUI["1"]["IgnoreGuiInset"] = true
    LoadingUI["1"]["ResetOnSpawn"] = false
    LoadingUI["1"]["AutoLocalize"] = false
    
    LoadingUI["2"] = Instance.new("Frame", LoadingUI["1"])
    LoadingUI["2"]["BorderSizePixel"] = 0
    LoadingUI["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
    LoadingUI["2"]["BackgroundTransparency"] = 0.3
    LoadingUI["2"]["Size"] = UDim2.new(1, 0, 1, 0)
    LoadingUI["2"]["Name"] = "BlurBG"
    
    LoadingUI["3"] = Instance.new("Frame", LoadingUI["1"])
    LoadingUI["3"]["BorderSizePixel"] = 0
    LoadingUI["3"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 25)
    LoadingUI["3"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    LoadingUI["3"]["Size"] = UDim2.new(0, 420, 0, 260)
    LoadingUI["3"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    LoadingUI["3"]["Name"] = "MainContainer"
    
    LoadingUI["4"] = Instance.new("UICorner", LoadingUI["3"])
    LoadingUI["4"]["CornerRadius"] = UDim.new(0, 12)
    
    LoadingUI["5"] = Instance.new("TextLabel", LoadingUI["3"])
    LoadingUI["5"]["BorderSizePixel"] = 0
    LoadingUI["5"]["TextSize"] = 38
    LoadingUI["5"]["BackgroundTransparency"] = 1
    LoadingUI["5"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    LoadingUI["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    LoadingUI["5"]["Size"] = UDim2.new(1, 0, 0, 60)
    LoadingUI["5"]["Position"] = UDim2.new(0, 0, 0, 35)
    LoadingUI["5"]["Text"] = "AntiLua"
    LoadingUI["5"]["Name"] = "Logo"
    
    LoadingUI["5b"] = Instance.new("TextLabel", LoadingUI["3"])
    LoadingUI["5b"]["BorderSizePixel"] = 0
    LoadingUI["5b"]["TextSize"] = 14
    LoadingUI["5b"]["BackgroundTransparency"] = 1
    LoadingUI["5b"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    LoadingUI["5b"]["TextColor3"] = Color3.fromRGB(86, 255, 128)
    LoadingUI["5b"]["Size"] = UDim2.new(1, 0, 0, 20)
    LoadingUI["5b"]["Position"] = UDim2.new(0, 0, 0, 90)
    LoadingUI["5b"]["Text"] = "Script Loader"
    LoadingUI["5b"]["Name"] = "Subtitle"
    
    LoadingUI["6"] = Instance.new("Frame", LoadingUI["3"])
    LoadingUI["6"]["BorderSizePixel"] = 0
    LoadingUI["6"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 35)
    LoadingUI["6"]["AnchorPoint"] = Vector2.new(0.5, 0)
    LoadingUI["6"]["Size"] = UDim2.new(0, 340, 0, 4)
    LoadingUI["6"]["Position"] = UDim2.new(0.5, 0, 0.54, 0)
    LoadingUI["6"]["Name"] = "ProgressBG"
    LoadingUI["6"]["ClipsDescendants"] = true
    
    LoadingUI["7"] = Instance.new("UICorner", LoadingUI["6"])
    LoadingUI["7"]["CornerRadius"] = UDim.new(1, 0)
    
    LoadingUI["8"] = Instance.new("Frame", LoadingUI["6"])
    LoadingUI["8"]["BorderSizePixel"] = 0
    LoadingUI["8"]["BackgroundColor3"] = Color3.fromRGB(86, 255, 128)
    LoadingUI["8"]["Size"] = UDim2.new(0.3, 0, 1, 0)
    LoadingUI["8"]["Position"] = UDim2.new(-0.3, 0, 0, 0)
    LoadingUI["8"]["Name"] = "ProgressBar"
    
    LoadingUI["9"] = Instance.new("UICorner", LoadingUI["8"])
    LoadingUI["9"]["CornerRadius"] = UDim.new(1, 0)
    
    LoadingUI["a"] = Instance.new("TextLabel", LoadingUI["3"])
    LoadingUI["a"]["BorderSizePixel"] = 0
    LoadingUI["a"]["TextSize"] = 15
    LoadingUI["a"]["BackgroundTransparency"] = 1
    LoadingUI["a"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    LoadingUI["a"]["TextColor3"] = Color3.fromRGB(180, 180, 185)
    LoadingUI["a"]["AnchorPoint"] = Vector2.new(0.5, 0)
    LoadingUI["a"]["Size"] = UDim2.new(1, -40, 0, 25)
    LoadingUI["a"]["Position"] = UDim2.new(0.5, 0, 0.64, 0)
    LoadingUI["a"]["Text"] = "Loading Software..."
    LoadingUI["a"]["Name"] = "Status"
    
    LoadingUI["b"] = Instance.new("TextLabel", LoadingUI["3"])
    LoadingUI["b"]["BorderSizePixel"] = 0
    LoadingUI["b"]["TextSize"] = 12
    LoadingUI["b"]["BackgroundTransparency"] = 1
    LoadingUI["b"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)
    LoadingUI["b"]["TextColor3"] = Color3.fromRGB(110, 110, 120)
    LoadingUI["b"]["RichText"] = true
    LoadingUI["b"]["AnchorPoint"] = Vector2.new(0.5, 1)
    LoadingUI["b"]["Size"] = UDim2.new(1, 0, 0, 20)
    LoadingUI["b"]["Position"] = UDim2.new(0.5, 0, 0.94, 0)
    LoadingUI["b"]["Text"] = '<font color="rgb(130,130,140)">Powered by</font> <font color="rgb(86,255,128)">.antilua.</font> <font color="rgb(90,90,100)">v1.3.5</font>'
    LoadingUI["b"]["Name"] = "PowerBy"
    
    LoadingUI["c"] = Instance.new("ImageLabel", LoadingUI["3"])
    LoadingUI["c"]["ZIndex"] = 0
    LoadingUI["c"]["BorderSizePixel"] = 0
    LoadingUI["c"]["ScaleType"] = Enum.ScaleType.Slice
    LoadingUI["c"]["SliceCenter"] = Rect.new(49, 49, 450, 450)
    LoadingUI["c"]["ImageTransparency"] = 0.5
    LoadingUI["c"]["ImageColor3"] = Color3.fromRGB(0, 0, 0)
    LoadingUI["c"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    LoadingUI["c"]["Image"] = "rbxassetid://6014261993"
    LoadingUI["c"]["Size"] = UDim2.new(1, 47, 1, 47)
    LoadingUI["c"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    LoadingUI["c"]["BackgroundTransparency"] = 1
    LoadingUI["c"]["Name"] = "Shadow"
    
    function LoadingUI.startLoadingAnimation()
        if isAnimating then return end
        isAnimating = true
        _task.spawn(function()
            while isAnimating do
                local moveTween = TweenService:Create(
                    LoadingUI["8"],
                    TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(1, 0, 0, 0)}
                )
                moveTween:Play()
                moveTween.Completed:Wait()
                
                if not isAnimating then break end
                LoadingUI["8"].Position = UDim2.new(-0.3, 0, 0, 0)
                
                _task.wait(0.1)
            end
        end)
    end
    
    function LoadingUI.stopLoadingAnimation()
        if not isAnimating then return end
        isAnimating = false
        LoadingUI["8"].Size = UDim2.new(1, 0, 1, 0)
        LoadingUI["8"].Position = UDim2.new(0, 0, 0, 0)
        
        _task.wait(0.3)
        
        local fadeOut = TweenService:Create(
            LoadingUI["3"],
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local fadeOutBG = TweenService:Create(
            LoadingUI["2"],
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        for _, v in pairs(LoadingUI["3"]:GetDescendants()) do
            if v:IsA("TextLabel") then
                _task.spawn(function()
                    TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1
                    }):Play()
                end)
            elseif v:IsA("ImageLabel") then
                _task.spawn(function()
                    TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 1
                    }):Play()
                end)
            elseif v:IsA("Frame") and v.Name ~= "MainContainer" then
                _task.spawn(function()
                    TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end
        end
        
        fadeOut:Play()
        fadeOutBG:Play()
        fadeOut.Completed:Wait()
        
        LoadingUI["1"]:Destroy()
        LoadingUI = {}
    end
    
    LoadingUI.startLoadingAnimation()
end)

run(function()
    printcolor:print([[

	ANTILUA HUB SCRIPT

	This made by AntiLua ( discord .antilua. )
	Modification of the script, including attempting to bypass
	or crack the script for any reason is not allowed.

	Copyright ⓒ 2026 AntiLua Hub - Script. All Rights Reserved.
]], Color3.fromHex("#10FFF8"), {showTimestamp = true})
    if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Anti-AFK is being applied..." end
	local GC = getconnections
    if GC then
        for i,v in pairs(GC(lp.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        local VirtualInputManager = Services.VirtualInputManager
        lp.Idled:Connect(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 2, true, workspace.CurrentCamera, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 2, false, workspace.CurrentCamera, 0)
        end)
    end
    _task.spawn(function()
        if game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/"..game.PlaceId) ~= "" then
            _xpcall(function()
                loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/"..game.PlaceId), "AntiLua")()
            end, function()
                shared.AntiLuaLoading = false
                shared.AntiLuaLoader = false
                warn("[AntiLua] An error has occurred!\n- Game: "..game.PlaceId)
            end)
        else
            local allowObbyGames = {
                ["obby"] = true,
                ["teamwork"] = false,
                [79785575696273] = true,
                [74867125612764] = true,
                [80008336782967] = true,
                [88028100567622] = true,
                [83140422496132] = true,
                [109007300866569] = true,
                [80673149078292] = true,
                [90109156331835] = true,
                [106037267025935] = true,
                [136716862797951] = true,
                [86372216924917] = true,
                [84053068285721] = true,
                [76309923415247] = true,
                [79475221338886] = true,
                [91596534260315] = true,
                [102658108494784] = true,
                [92953974055156] = true,
                [114356678581428] = true,
                [115960524559552] = true,
                [109467157409576] = true,
                [98380282291426] = true,
                [78266413016841] = true,
                [114421096651273] = true,
                [83891831887653] = true,
                [80692223709267] = false,
                [107105227790657] = false,
                [95145490867665] = false,
                [17732590459] = false,
                [9099326192] = false,
                [15864327873] = false,
                [13703839980] = false,
                [16141640360] = false
            }

            local placeId = game.PlaceId
            local GameName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
            local obbyallowed = false

            for key, value in pairs(allowObbyGames) do
                if type(key) == "string" and GameName then
                    if string.find(string.lower(GameName), string.lower(key)) then obbyallowed = value end
                elseif type(key) == "number" and placeId then
                    if placeId == key then obbyallowed = value end
                end
            end

            if obbyallowed then
                _xpcall(function()
                    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/ObbyAuto.lua"), "AntiLua")()
                end, function()
                    shared.AntiLuaLoading = false
                    shared.AntiLuaLoader = false
                    warn("[AntiLua] An error has occurred!\n- Game:", GameName, placeId)
                end)
            else
                _xpcall(function()
                    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/Universal.lua"), "AntiLua")()
                end, function()
                    shared.AntiLuaLoading = false
                    shared.AntiLuaLoader = false
                    warn("[AntiLua] An error has occurred!\n- Game:", GameName, placeId)
                end)
            end
        end
        printcolor:print("The script has successfully finished loading! enjoy", Color3.fromRGB(0, 255, 0), {
            showTimestamp = true,
            icon = "rbxassetid://4485364377"
        })
    end)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading Services..." end
	_task.wait(_math.random() * 0.4 + 0.3)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading Variables..." end
	_task.wait(_math.random() * 0.4 + 0.8)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading Tables..." end
	_task.wait(_math.random() * 0.3 + 0.3)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading Functions..." end
	_task.wait(_math.random() * 0.5 + 1)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading User Interface..." end
	_task.wait(_math.random() * 0.5 + 0.5)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Loading Assets..." end
	_task.wait(_math.random() * 0.4 + 0.4)
	if LoadingUI["a"] then LoadingUI["a"]["Text"] = "Finalizing Setup..." end
	_task.wait(_math.random() * 0.6 + 0.5)
    if LoadingUI.stopLoadingAnimation then LoadingUI.stopLoadingAnimation() end
end)
