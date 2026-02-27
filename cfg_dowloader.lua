local screen_gui = Instance.new('ScreenGui')
local main = Instance.new('Frame')
local title = Instance.new('TextLabel')
local subtitle = Instance.new('TextLabel')
local input_box = Instance.new('TextBox')
local download_btn = Instance.new('TextButton')
local status_label = Instance.new('TextLabel')
local close_btn = Instance.new('TextButton')
local top_bar = Instance.new('Frame')

screen_gui.Name = 'ConfigDownloader'
screen_gui.ResetOnSpawn = false
screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen_gui.Parent = game:GetService('CoreGui')

main.Name = 'Main'
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 380, 0, 235)
main.Parent = screen_gui

local main_corner = Instance.new('UICorner')
main_corner.CornerRadius = UDim.new(0, 10)
main_corner.Parent = main

local main_stroke = Instance.new('UIStroke')
main_stroke.Color = Color3.fromRGB(45, 45, 45)
main_stroke.Thickness = 1
main_stroke.Parent = main

top_bar.Name = 'TopBar'
top_bar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
top_bar.Size = UDim2.new(1, 0, 0, 40)
top_bar.Parent = main

local top_corner = Instance.new('UICorner')
top_corner.CornerRadius = UDim.new(0, 10)
top_corner.Parent = top_bar

title.Name = 'Title'
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(1, -50, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = 'Config Downloader'
title.TextColor3 = Color3.fromRGB(210, 210, 210)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top_bar

close_btn.Name = 'CloseBtn'
close_btn.AnchorPoint = Vector2.new(1, 0.5)
close_btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
close_btn.Position = UDim2.new(1, -12, 0.5, 0)
close_btn.Size = UDim2.new(0, 20, 0, 20)
close_btn.Font = Enum.Font.GothamBold
close_btn.Text = '×'
close_btn.TextColor3 = Color3.fromRGB(180, 180, 180)
close_btn.TextSize = 12
close_btn.TextScaled = true
close_btn.AutoButtonColor = false
close_btn.Parent = top_bar

local close_corner = Instance.new('UICorner')
close_corner.CornerRadius = UDim.new(1, 0)
close_corner.Parent = close_btn

subtitle.Name = 'Subtitle'
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 14, 0, 50)
subtitle.Size = UDim2.new(1, -28, 0, 18)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = 'Paste the config link you want to download'
subtitle.TextColor3 = Color3.fromRGB(100, 100, 100)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

input_box.Name = 'InputBox'
input_box.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
input_box.Position = UDim2.new(0, 14, 0, 76)
input_box.Size = UDim2.new(1, -28, 0, 40)
input_box.Font = Enum.Font.Gotham
input_box.PlaceholderText = 'https://cdn.discordapp.com/...'
input_box.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
input_box.Text = ''
input_box.TextColor3 = Color3.fromRGB(200, 200, 200)
input_box.TextSize = 12
input_box.TextXAlignment = Enum.TextXAlignment.Left
input_box.ClearTextOnFocus = false
input_box.Parent = main

local input_corner = Instance.new('UICorner')
input_corner.CornerRadius = UDim.new(0, 7)
input_corner.Parent = input_box

local input_padding = Instance.new('UIPadding')
input_padding.PaddingLeft = UDim.new(0, 10)
input_padding.Parent = input_box

local input_stroke = Instance.new('UIStroke')
input_stroke.Color = Color3.fromRGB(45, 45, 45)
input_stroke.Thickness = 1
input_stroke.Parent = input_box

download_btn.Name = 'DownloadBtn'
download_btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
download_btn.Position = UDim2.new(0, 14, 0, 130)
download_btn.Size = UDim2.new(1, -28, 0, 40)
download_btn.Font = Enum.Font.GothamBold
download_btn.Text = 'Download'
download_btn.TextColor3 = Color3.fromRGB(200, 200, 200)
download_btn.TextSize = 13
download_btn.AutoButtonColor = false
download_btn.Parent = main

local btn_corner = Instance.new('UICorner')
btn_corner.CornerRadius = UDim.new(0, 7)
btn_corner.Parent = download_btn

status_label.Name = 'StatusLabel'
status_label.BackgroundTransparency = 1
status_label.Position = UDim2.new(0, 14, 0, 184)
status_label.Size = UDim2.new(1, -28, 0, 30)
status_label.Font = Enum.Font.Gotham
status_label.Text = ''
status_label.TextColor3 = Color3.fromRGB(100, 100, 100)
status_label.TextSize = 12
status_label.TextXAlignment = Enum.TextXAlignment.Center
status_label.Parent = main

local dragging, drag_input, drag_start, start_pos

top_bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        drag_start = input.Position
        start_pos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top_bar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        drag_input = input
    end
end)

game:GetService('UserInputService').InputChanged:Connect(function(input)
    if input == drag_input and dragging then
        local delta = input.Position - drag_start
        main.Position = UDim2.new(
            start_pos.X.Scale,
            start_pos.X.Offset + delta.X,
            start_pos.Y.Scale,
            start_pos.Y.Offset + delta.Y
        )
    end
end)

download_btn.MouseEnter:Connect(function()
    download_btn.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
end)

download_btn.MouseLeave:Connect(function()
    download_btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
end)

close_btn.MouseEnter:Connect(function()
    close_btn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
end)

close_btn.MouseLeave:Connect(function()
    close_btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
end)

close_btn.MouseButton1Click:Connect(function()
    screen_gui:Destroy()
end)

download_btn.MouseButton1Click:Connect(function()
    local url = input_box.Text

    if url == '' or url == nil then
        status_label.TextColor3 = Color3.fromRGB(180, 80, 80)
        status_label.Text = 'Please enter a link'
        return
    end

    local file_name = url:match('([^/]+)$')
    if file_name then
        file_name = file_name:match('([^?]+)')
    end

    if not file_name then
        status_label.TextColor3 = Color3.fromRGB(180, 80, 80)
        status_label.Text = 'Invalid link'
        return
    end

    status_label.TextColor3 = Color3.fromRGB(100, 100, 100)
    status_label.Text = 'Downloading...'
    download_btn.Text = 'Downloading...'
    download_btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local success, err = pcall(function()
        local content = game:HttpGet(url)
        local path = 'milinium/configs/' .. game.PlaceId .. '/'

        if not isfolder(path) then
            makefolder(path)
        end

        writefile(path .. file_name, content)
    end)

    download_btn.Text = 'Download'
    download_btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)

    if success then
        status_label.TextColor3 = Color3.fromRGB(100, 170, 100)
        status_label.Text = 'Saved Successfully  -  ' .. file_name
    else
        status_label.TextColor3 = Color3.fromRGB(180, 80, 80)
        status_label.Text = 'Download Failed: ' .. err
    end
end)
