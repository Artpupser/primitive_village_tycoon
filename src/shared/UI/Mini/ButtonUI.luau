local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local DecorateUI = require(ReplicatedStorage.Shared.UI.Mini.DecorateUI)

local function ButtonUI(props: {value: string, click: (me: Object) -> {}})
    local childrens = {
        DecorateUI()
    }

    return React.createElement("TextButton", {
        Text = props.value,
        Size = UDim2.fromScale(1,1),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        TextXAlignment = "Center",
        TextYAlignment = "Center",
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        Font = Enum.Font.FredokaOne,
        TextScaled = true,
        TextTruncate = "SplitWord",
        TextWrapped = true,
        [React.Event.MouseButton1Click] = props.click,
        [React.Event.TouchPan] = props.click,
    }, childrens)
end

return ButtonUI