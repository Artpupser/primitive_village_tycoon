local React = require(game:GetService("ReplicatedStorage").Packages.React)
local TweenService = game:GetService("TweenService")

local function DecorateUI()
    return {
    React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 30),
    }), 
    React.createElement("UIStroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0),
        BorderStrokePosition = 'Outer',
        StrokeSizingMode = 'FixedSize',
    })}
end

return DecorateUI