Damagelog.ExtraDeathSceneEntities = Damagelog.ExtraDeathSceneEntities or {}

function Damagelog:saveExtraEntityList()
     file.Write("damagelog/extra_entities.json",util.TableToJSON(Damagelog.ExtraDeathSceneEntities,true))
end

function Damagelog:loadExtraEntityList() --Returns 0 on good load, returns -1 on failure due to corrupted file.
    if not file.Exists("damagelog/extra_entities.json", "DATA") then --If no config exists save the default config (config.lua) and return as if we loaded one.
        Damagelog:saveExtraEntityList()
        return 0
    end
    local config = util.JSONToTable(file.Read("damagelog/extra_entities.json", "DATA"))
    if not config then
        ErrorNoHalt("Damagelogs: ERROR - Extra Entity List exists but is not valid JSON!")
        return -1
    end
    Damagelog.ExtraDeathSceneEntities = config
    return 0
end
