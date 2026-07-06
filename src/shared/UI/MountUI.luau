local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Screens = ReplicatedStorage.Shared.UI.Screens

local MountMap = {
    ["loading"] = function(root: ReactRoblox.RootType, container: ScreenGui)
        container.DisplayOrder = 10
        return React.createElement(require(Screens.LoadingScreenUI), {
            onComplete = function()
                root:unmount()
                container:Destroy()
            end
        })
    end,

    ["root"] = function(_: ReactRoblox.RootType, _: ScreenGui)
        return React.createElement(require(Screens.RootScreenUI), {

        })
    end
}

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
    root:render(MountMap[screen](root, container))
end

return MountUI