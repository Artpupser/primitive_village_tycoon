local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.React)
local LabelUI = require(ReplicatedStorage.Shared.UI.Mini.LabelUI)
local UI = require(ReplicatedStorage.Shared.Utils.UI)
local ButtonUI = require(ReplicatedStorage.Shared.UI.Mini.ButtonUI)
local DecorateUI = require(ReplicatedStorage.Shared.UI.Mini.DecorateUI)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local TweenService = game:GetService("TweenService")


local NOTIFICATION_UI_LIFETIME : number = 5

local function NotificationElementlUI(props:any)
    local item = props.item
    React.useEffect(function()
        local timer = task.delay(NOTIFICATION_UI_LIFETIME, function()
            props.onRemove(item.id)
        end)

        return function()
            task.cancel(timer)
        end
    end, {item.id})

    local childrens = {
        DecorateUI(),
        ButtonUI({value=item.message,click=UI.removeMeParent})
    }

    return React.createElement('Frame', {
        Size = UDim2.fromScale(1,.05),
        AnchorPoint = Vector2.new(.5,.5),
        Interactable = true,
    }, childrens)
end

local function NotificationContainerUI()
    local messages, setMessages = React.useState({})
    React.useEffect(function()
        local connection = TriggerManager.getRemoteEvent("notification").OnClientEvent:Connect(function(message: string)
            setMessages(function(prev)
                return UI.createChildren(prev, {message=message})
            end)
        end)
        
        return function()
            connection:Disconnect()
        end
    end, {})

    local childrens = {
        React.createElement("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 5),
        })
    }

    for _, message in ipairs(messages) do
        table.insert(childrens, React.createElement(NotificationElementlUI, {
            key = message.id,
            item = message,
            onRemove = function(id)
                setMessages(function(prev)
                    return UI.exceptHandler(prev, id)
                end)
            end
        }))
    end

    return React.createElement("Frame", {
        Size = UDim2.fromScale(.25,0.8),
        Position = UDim2.new(1,-10,.5,0),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        key = "NotificationContainer",
        -- [React.Event.MouseEnter] = function(me)
        --     TweenService:Create(me, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
        --        Size = UDim2.fromScale(0.3, 0.8),
        --     }):Play()
        --  end,

        --  [React.Event.MouseLeave] = function(me)
        --     TweenService:Create(me, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
        --        Size = UDim2.fromScale(0.2, 0.8),
        --     }):Play()
        --  end,
    }, childrens)
end

return NotificationContainerUI