local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
--local RooutUI = require(ReplicatedStorage.Shared.UI.RootUI)
local Screens = ReplicatedStorage.Shared.UI.Screens

local function MountUI(screen: string)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local container = Instance.new("ScreenGui")
    container.Name = "React"
    container.IgnoreGuiInset = true
    container.ResetOnSpawn = false
    container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    container.ClipToDeviceSafeArea = false
    container.Parent = playerGui
    local root = ReactRoblox.createRoot(container)
    local app = React.createElement(require(Screens:WaitForChild(screen.."ScreenUI")), {
        onComplete = function()
            root:unmount()
            container:Destroy()
        end
    }) 
    root:render(app)
end

return MountUI