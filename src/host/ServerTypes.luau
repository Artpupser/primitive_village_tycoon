local ServerTypes = {}

export type TycoonModel = {
    Instance : Model,
    Decorations : Folder,
    NPC : Folder,
    Interact : Folder,
}

export type TycoonProvider = {
    Id : string,
    Index : number,
    TycoonModel : TycoonModel,
    Owner: Player,
    isOwner: () -> boolean,
    own: (player: Player) -> boolean,
    unown: (player: Player) -> boolean,
    start: () -> (),
    clear: () -> (),
}

-- See DataService to change this type. IMPORTANT!
export type PlayerData = {
    Scores: {
        Gold: number
    },
    Version: number
}

export type TycoonService = {
    Folder : Folder,
    TycoonProviders : { TycoonProvider },
}

return ServerTypes