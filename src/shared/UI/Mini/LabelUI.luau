local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local DecorateUI = require(ReplicatedStorage.Shared.UI.Mini.DecorateUI)

local function LabelUI(props: {value: string, size: UDim2, position: UDim2}) 
    local childrens = {
        DecorateUI()
    }
    return React.createElement("TextLabel", {
        Text = props.value,
        Size = props.size,
        Position = props.position,
        AnchorPoint = Vector2.new(.5,.5),
        TextXAlignment = "Center",
        TextYAlignment = "Center",
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        Font = Enum.Font.FredokaOne,
        TextScaled = true,
        TextTruncate = "SplitWord",
        TextWrapped = true
    }, childrens)
end


return LabelUI