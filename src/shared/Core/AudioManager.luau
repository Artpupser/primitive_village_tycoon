local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Randomizer = require(ReplicatedStorage.Shared.Utils.Randomizer)
local Types = require(ReplicatedStorage.Shared.Types)


local AudioManager : Types.AudioManagerType = {
    Groups = {
        Music = SoundService.Music,
        Sound = SoundService.Sound,
    },
    AudiosMap = {},
    AudiosList = {},
    Current = nil
}

function AudioManager.all()
    return AudioManager.Audios;
end

function AudioManager.init()
    for groupName : string, group : SoundGroup in pairs(AudioManager.Groups) do
        print("Sound group "..groupName)
        AudioManager.AudiosList[groupName] = table.create(0, {})
        AudioManager.AudiosMap[groupName] = table.create(0, {})
        for soundIndex, sound : Sound in pairs(group:GetChildren()) do
            sound.SoundGroup = group
            AudioManager.AudiosMap[groupName][sound.Name] = sound
            AudioManager.AudiosList[groupName][soundIndex] = sound
            print("["..soundIndex.."]".." Sound id "..sound.SoundId.." loaded "..sound.Name)
        end
    end
end

function AudioManager.random(groupName: string, except : Sound?) : Sound
    local group : SoundGroup = AudioManager.Groups[groupName]
    if group ~= nil then
        local sounds = AudioManager.AudiosList[groupName]
        local soundsLength = #sounds;
        if soundsLength == 1 then
            return sounds[soundsLength]
        end
        local sound = nil
        while sound == nil or sound == except do
            sound = sounds[Randomizer.integer(0, soundsLength)]
        end
        return sound
    end
end

function AudioManager.next()
    AudioManager.stop()
    AudioManager.Current = AudioManager.random("Music")
    AudioManager.Current.SoundGroup = AudioManager.Groups.Music
    AudioManager.Current.Ended:Once(function()
        AudioManager.next()
    end)
    AudioManager.continue()
end

function AudioManager.stop()
    if AudioManager.Current ~= nil then
        AudioManager.Current:Stop()
    end
end

function AudioManager.continue()
    if AudioManager.Current ~= nil then
        AudioManager.Current:Play()
        print("Playing "..AudioManager.Current.SoundId)
    end
end

function AudioManager.volume(volume: number)
    AudioManager.Current.Volume = volume;
end

function AudioManager.playSound(sound: Sound)
    if sound ~= nil then
        sound.SoundGroup = AudioManager.Groups.Sound
        sound:Play()
    end
end

function AudioManager.play(id: string, group: string?)
    local sound : Sound = AudioManager.AudiosMap[if group ~= nil then group else "Sound"][id]
    if sound ~= nil then
        sound.SoundGroup = AudioManager.Groups.Sound
        sound:Play()
    end
end

return AudioManager;
