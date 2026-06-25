local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.React)
local NotificationContainerUI = require(ReplicatedStorage.Shared.UI.NotificationContainerUI)

local function RootScreenUI()
   return React.createElement("Frame", {
         -- ref = frameRef,
         Size = UDim2.fromScale(1,1),
         Position = UDim2.fromScale(.5,.5),
         AnchorPoint = Vector2.new(0.5,0.5),
         BackgroundTransparency = 0.9,
   }, {
      NotificationContainerUI()
   })
end

return RootScreenUI