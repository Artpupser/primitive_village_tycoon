local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleInstance = require(ReplicatedStorage:WaitForChild("Shared").Utils.SimpleInstance)
local Me = Players.LocalPlayer


local blackScreen :StarterGui = SimpleInstance.new("ScreenGui") 
    :rename("BlackScreen")
    :parent(Me.PlayerGui)
    :build()

blackScreen.IgnoreGuiInset = true
blackScreen.ResetOnSpawn = false
blackScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
blackScreen.ClipToDeviceSafeArea = false
blackScreen.DisplayOrder = 99

local black:Frame = SimpleInstance.new("Frame")
    :rename("Black")
    :parent(blackScreen)
    :build()

black.Size = UDim2.fromScale(1,1)
black.BackgroundColor3 = Color3.fromRGB(0,0,0)

