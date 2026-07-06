local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService")
local React = require(ReplicatedStorage.Packages.React)
local LabelUI = require(ReplicatedStorage.Shared.UI.Mini.LabelUI)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)

local function LoadingScreenUI(props)
   local progress, setProgress = React.useState(0)
   local message, setMessage = React.useState("")
   local frameRef = React.useRef(nil)
   React.useEffect(function()
      local connection = TriggerManager.getPrivateEvent("loading_status").Event:Connect(function(_message: string, _progress: number)
         setProgress(function(_: number)
            return _progress
         end)

         setMessage(function(_: number)
            return _message
         end)
         if _progress >= 1 then
            task.delay(1, function()
               local frame = frameRef.current
               local animation = TweenService:Create(frame, TweenInfo.new(.8,
               Enum.EasingStyle.Back,
               Enum.EasingDirection.In), {
                  Position = UDim2.fromScale(2,0.5),
               })
               animation.Completed:Once(props.onComplete)
               animation:Play()
            end)
         end
      end)
      return function()
        connection:Disconnect()
      end
   end, { props.onComplete })

   local childrens = {
      LabelUI({
         value = "Progress: "..string.format("%.2f", progress*100).."%",
         size = UDim2.fromScale(1,.5),
         position = UDim2.fromScale(.5,.49),
      }),
      LabelUI({
         value = message, 
         size = UDim2.fromScale(.6, .1),
         position = UDim2.fromScale(.5,.6),
      })
   }

   return React.createElement("Frame", {
      key = "LoadingScreen",
      Size = UDim2.fromScale(1,1),
      Position = UDim2.fromScale(.5,.5),
      AnchorPoint = Vector2.new(0.5,0.5),
      BackgroundTransparency = 0,
      BackgroundColor3 = Color3.fromRGB(0, 0, 0),
      ref = frameRef
   }, childrens)
end

return LoadingScreenUI