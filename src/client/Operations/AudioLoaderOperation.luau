local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AudioManager = require(ReplicatedStorage.Shared.Core.AudioManager)
local AudioLoaderOperation = {}
AudioLoaderOperation.__index = AudioLoaderOperation
AudioLoaderOperation.__className = "AudioLoaderOperation"

function AudioLoaderOperation.start()
    AudioManager.init()
    AudioManager.next()
end

return AudioLoaderOperation;