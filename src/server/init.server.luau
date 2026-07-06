local LoadingManager = require(game:GetService("ReplicatedStorage").Shared.Core.LoadingManager)
LoadingManager.operations(script.Operations, function(message, progress)
    print(message.." ".. progress*100 .."%")
end)