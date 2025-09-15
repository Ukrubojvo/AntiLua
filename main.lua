assert(isfolder and makefolder, "폴더를 생성할 수 없습니다")
if not isfolder("AntiLua") then
    makefolder("AntiLua")
end

task.spawn(function()
	if shared.AntiLuaV1 then return end
    local sound
    writefile("AntiLua/start.mp3", game:HttpGetAsync("https://github.com/Ukrubojvo/api/raw/refs/heads/main/win11start.mp3"))
    sound = Instance.new("Sound", workspace)
    sound.SoundId = getcustomasset("AntiLua/start.mp3")
    sound.Volume = 5
    sound.Looped = false
    sound.PlayOnRemove = true
	shared.AntiLuaV1 = true
    sound:Play()
	sound.Ended:Wait()
	shared.AntiLuaV1 = false
end)
task.spawn(function()
	if shared.AntiLuaV2 then return end
	shared.AntiLuaV2 = true
	local TweenService = game:GetService('TweenService')
	local Lighting = game:GetService("Lighting")
	local gui = Instance.new("ScreenGui")
	gui.Name = "intro"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
    gui.DisplayOrder = 214748367
    gui.AutoLocalize = false
	gui.Parent = gethui() or game:GetService("CoreGui")
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.new(0.5, 0, 0.5, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.Text = ""
	label.TextTransparency = 1
    label.ZIndex = math.huge
	label.Parent = gui
	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting
	local function fade(text, duration)
		label.Text = text
		local f_in = TweenService:Create(label, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.1})
		f_in:Play()
		TweenService:Create(blur, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24}):Play()
		f_in.Completed:Wait()
		task.wait(1.2)
		local f_out = TweenService:Create(label, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
		f_out:Play()
		TweenService:Create(blur, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0}):Play()
		f_out.Completed:Wait()
	end
	fade("Anti Lua", 1.2)
	gui:Destroy()
	blur:Destroy()
	shared.AntiLuaV2 = false
end)

if game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/"..game.PlaceId) then
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Ukrubojvo/AntiLua/run/games/"..game.PlaceId, true), "AntiLua")()
    return
else
    warn("[Anti Lua] 지원하지 않는 게임입니다.")
end
