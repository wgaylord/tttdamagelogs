
Damagelog.AttackingEntities = {
    "ttt_c4", 

    --Base grenades
    "ttt_basegrenade_proj",
    "ttt_confgrenade_proj",
    "ttt_firegrenade_proj",

    --Branicle
    "npc_barnacle",

    --MC Trident
    "ttt_mctrident",

    --Knife
    "ttt_knife_proj",

    --Briefcase
    "ttt_briefcase",

    --SLAM
    "ttt_slam_base",
    "ttt_slam_satchel",
    "ttt_slam_tripmine",

    --Banana Bomb
    "ttt_banana_proj",
    "ttt_banana_split",

    --Holy Handgernade
    "ttt_holyhandgrenade_proj",

    --Spring Mine
    "ttt_spring_mine",

    --Shuriken
    "ent_shuriken",

    --Chicken
    "ttt_chicken",
    "ttt_kfc",

    --Melon Mine
    "ent_ttt_mine",

    --Portable Tester
    "ttt_porttest",

    --RCXD
    "ttt_rcxd",
    "ttt_rcxd_wheel",

    
    }

if file.Exists("damagelog_entities.json", "DATA" ) then
    local entities = {}
    for _,x in ipairs(Damagelog.AttackingEntities) do
        entities[x] = true
    end

    local dat = file.Read("damagelog_entities.json")
    if dat then
        data = util.JSONToTable(dat) 
        if data then
            for _,x in ipairs(data) do
                entities[x] = true
            end
        end
    end
    Damagelog.AttackingEntities = table.GetKeys(entities)
end
