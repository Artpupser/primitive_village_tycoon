local Types = {}

export type AudioManagerType = {
    Groups : { SoundGroup },
    AudiosMap : { { Sound } },
    AudiosList : { { Sound } },
    Current : Sound?
}

return Types