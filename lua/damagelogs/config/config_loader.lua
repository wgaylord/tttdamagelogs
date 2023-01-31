
function Damagelog:saveConfig()
    local config = {}
    --Permissions
    config.Permissions = {}
    for user,right in pairs(Damagelog.User_rights) do    
        config.Permissions[user] = {right,Damagelog.RDM_Manager_Rights[user]}
    end
    config.Key = Damagelog.Key
    config.AbuseMessageMode = Damagelog.AbuseMessageMode
    config.RDM_Manager_Enabled = Damagelog.RDM_Manager_Enabled
    --Commands
    config.Commands = {}
    config.Commands.RDM_Manager_Command = Damagelog.RDM_Manager_Command
    config.Commands.Respond_Command = Damagelog.Respond_Command

    config.Use_MySQL = Damagelog.Use_MySQL
    --Autoslay stuff
    config.Autoslay = {}
    config.Autoslay.ShowRemainingSlays = Damagelog.ShowRemainingSlays
    config.Autoslay.ULX_AutoslayMode = Damagelog.ULX_AutoslayMode
    config.Autoslay.ULX_Autoslay_ForceRole = Damagelog.ULX_Autoslay_ForceRole
    config.Autoslay.Autoslay_CheckCustom = Damagelog.Autoslay_CheckCustom
    config.Autoslay.DefaultReason = Damagelog.Autoslay_DefaultReason
    config.Autoslay.DefaultReason1 = Damagelog.Autoslay_DefaultReason1
    config.Autoslay.DefaultReason2 = Damagelog.Autoslay_DefaultReason2
    config.Autoslay.DefaultReason3 = Damagelog.Autoslay_DefaultReason3
    config.Autoslay.DefaultReason4 = Damagelog.Autoslay_DefaultReason4
    config.Autoslay.DefaultReason5 = Damagelog.Autoslay_DefaultReason5
    config.Autoslay.DefaultReason6 = Damagelog.Autoslay_DefaultReason6
    config.Autoslay.DefaultReason7 = Damagelog.Autoslay_DefaultReason7
    config.Autoslay.DefaultReason8 = Damagelog.Autoslay_DefaultReason8
    config.Autoslay.DefaultReason9 = Damagelog.Autoslay_DefaultReason9
    config.Autoslay.DefaultReason10 = Damagelog.Autoslay_DefaultReason10
    config.Autoslay.DefaultReason11 = Damagelog.Autoslay_DefaultReason11
    config.Autoslay.DefaultReason12 = Damagelog.Autoslay_DefaultReason12
    --Ban Stuff
    config.Ban = {}
    config.Ban.DefaultReason1 = Damagelog.Ban_DefaultReason1
    config.Ban.DefaultReason2 = Damagelog.Ban_DefaultReason2
    config.Ban.DefaultReason3 = Damagelog.Ban_DefaultReason3
    config.Ban.DefaultReason4 = Damagelog.Ban_DefaultReason4
    config.Ban.DefaultReason5 = Damagelog.Ban_DefaultReason5
    config.Ban.DefaultReason6 = Damagelog.Ban_DefaultReason6
    config.Ban.DefaultReason7 = Damagelog.Ban_DefaultReason7
    config.Ban.DefaultReason8 = Damagelog.Ban_DefaultReason8
    config.Ban.DefaultReason9 = Damagelog.Ban_DefaultReason9
    config.Ban.DefaultReason10 = Damagelog.Ban_DefaultReason10
    config.Ban.DefaultReason11 = Damagelog.Ban_DefaultReason11
    config.Ban.DefaultReason12 = Damagelog.Ban_DefaultReason12
    config.Ban.AllowBanningThruManager = Damagelog.AllowBanningThruManager
    
    config.LogDays = Damagelog.LogDays
    config.HideDonateButton = Damagelog.HideDonateButton
    config.UseWorkshop = Damagelog.UseWorkshop
    config.ForcedLanguage = Damagelog.ForcedLanguage
    --Report stuff
    config.Reports = {}
    config.Reports.NoStaffReports = Damagelog.NoStaffReports
    config.Reports.MoreReportsPerRound = Damagelog.MoreReportsPerRound
    config.Reports.ReportsBeforePlaying = Damagelog.ReportsBeforePlaying

    config.PrivateMessagePrefix = Damagelog.PrivateMessagePrefix
    config.DiscordWebhookMode = Damagelog.DiscordWebhookMode
    
    file.Write("damagelog/config.json",util.TableToJSON(config,true))
end

function Damagelog:loadConfig() --Returns 0 on good load, returns -1 on failure due to corrupted file, returns 1 if entries are missing. 
    local missing = 0
    if not file.Exists("damagelog/config.json", "DATA") then --If no config exists save the default config (config.lua) and return as if we loaded one.
        Damagelog:saveConfig()
        return 0
    end
    local config = util.JSONToTable(file.Read("damagelog/config.json", "DATA"))
    if not config then
        ErrorNoHalt("Damagelogs: ERROR - Config Exists but is not valid JSON!")
        return -1
    end

    --Each part of the config is checked to see if it exists since if this is a update their config may not have new values. 
    if config.Permissions then
        Damagelog.User_rights = {}
        Damagelog.RDM_Manager_Rights = {}
        
        for user,data in pairs(config.Permissions) do
            Damagelog:AddUser(user,data[1],data[2])
        end
    else missing = 1 end

    if config.Key != nil then
        Damagelog.Key = config.Key
    else missing = 1 end

    if config.AbuseMessageMode != nil then
        Damagelog.AbuseMessageMode = config.AbuseMessageMode
    else missing = 1 end

    if config.RDM_Manager_Enabled != nil then
        Damagelog.RDM_Manager_Enabled = config.RDM_Manager_Enabled
    else missing = 1 end

    if config.Commands then 
        if config.Commands.RDM_Manager_Command != nil then
            Damagelog.RDM_Manager_Command = config.Commands.RDM_Manager_Command
        else missing = 1 end

        if config.Commands.Respond_Command != nil then
            Damagelog.Respond_Command = config.Commands.Respond_Command
        else missing = 1 end
    else missing = 1 end
    
    if config.Use_MySQL != nil then
        Damagelog.Use_MySQL = Damagelog.Use_MySQL
    else missing = 1 end
    
    if config.Autoslay then
        if config.Autoslay.ShowRemainingSlays != nil then
            Damagelog.ShowRemainingSlays = config.Autoslay.ShowRemainingSlays
        else missing = 1 end

        if config.Autoslay.ULX_AutoslayMode != nil then
            Damagelog.ULX_AutoslayMode = config.Autoslay.ULX_AutoslayMode
        else missing = 1 end

        if config.Autoslay.ULX_Autoslay_ForceRole != nil then
            Damagelog.ULX_Autoslay_ForceRole = config.Autoslay.ULX_Autoslay_ForceRole
        else missing = 1 end
       
        if config.Autoslay.Autoslay_CheckCustom != nil then
            Damagelog.ULX_Autoslay_ForceRole = config.Autoslay.Autoslay_CheckCustom
        else missing = 1 end

        if config.Autoslay.DefaultReason != nil then
            Damagelog.Autoslay_DefaultReason = config.Autoslay.DefaultReason
        else missing = 1 end

        if config.Autoslay.DefaultReason1 != nil then
            Damagelog.Autoslay_DefaultReason1 = config.Autoslay.DefaultReason1
        else missing = 1 end

        if config.Autoslay.DefaultReason2 != nil then
            Damagelog.Autoslay_DefaultReason2 = config.Autoslay.DefaultReason2
        else missing = 1 end

        if config.Autoslay.DefaultReason3 != nil then
            Damagelog.Autoslay_DefaultReason3 = config.Autoslay.DefaultReason3
        else missing = 1 end

        if config.Autoslay.DefaultReason4 != nil then
            Damagelog.Autoslay_DefaultReason4 = config.Autoslay.DefaultReason4
        else missing = 1 end

        if config.Autoslay.DefaultReason5 != nil then
            Damagelog.Autoslay_DefaultReason5 = config.Autoslay.DefaultReason5
        else missing = 1 end

        if config.Autoslay.DefaultReason6 != nil then
            Damagelog.Autoslay_DefaultReason6 = config.Autoslay.DefaultReason6
        else missing = 1 end

        if config.Autoslay.DefaultReason7 != nil then
            Damagelog.Autoslay_DefaultReason7 = config.Autoslay.DefaultReason7
        else missing = 1 end

        if config.Autoslay.DefaultReason8 != nil then
            Damagelog.Autoslay_DefaultReason8 = config.Autoslay.DefaultReason8
        else missing = 1 end

        if config.Autoslay.DefaultReason9 != nil then
            Damagelog.Autoslay_DefaultReason9 = config.Autoslay.DefaultReason9
        else missing = 1 end

        if config.Autoslay.DefaultReason10 != nil then
            Damagelog.Autoslay_DefaultReason10 = config.Autoslay.DefaultReason10
        else missing = 1 end

        if config.Autoslay.DefaultReason11 != nil then
            Damagelog.Autoslay_DefaultReason11 = config.Autoslay.DefaultReason11
        else missing = 1 end
        
        if config.Autoslay.DefaultReason12 != nil then
            Damagelog.Autoslay_DefaultReason12 = config.Autoslay.DefaultReason12
        else missing = 1 end
    else missing = 1 end
   
    if config.Ban then
        if config.Ban.AllowBanningThruManager != nil then
            Damagelog.AllowBanningThruManager = config.Ban.AllowBanningThruManager
        else missing = 1 end

        if config.Ban.DefaultReason1 != nil then
            Damagelog.Ban_DefaultReason1 = config.Ban.DefaultReason1
        else missing = 1 end

        if config.Ban.DefaultReason2 != nil then
            Damagelog.Ban_DefaultReason2 = config.Ban.DefaultReason2
        else missing = 1 end

        if config.Ban.DefaultReason3 != nil then
            Damagelog.Ban_DefaultReason3 = config.Ban.DefaultReason3
        else missing = 1 end

        if config.Ban.DefaultReason4 != nil then
            Damagelog.Ban_DefaultReason4 = config.Ban.DefaultReason4
        else missing = 1 end

        if config.Ban.DefaultReason5 != nil then
            Damagelog.Ban_DefaultReason5 = config.Ban.DefaultReason5
        else missing = 1 end

        if config.Ban.DefaultReason6 != nil then
            Damagelog.Ban_DefaultReason6 = config.Ban.DefaultReason6
        else missing = 1 end

        if config.Ban.DefaultReason7 != nil then
            Damagelog.Ban_DefaultReason7 = config.Ban.DefaultReason7
        else missing = 1 end

        if config.Ban.DefaultReason8 != nil then
            Damagelog.Ban_DefaultReason8 = config.Ban.DefaultReason8
        else missing = 1 end

        if config.Ban.DefaultReason9 != nil then
            Damagelog.Ban_DefaultReason9 = config.Ban.DefaultReason9
        else missing = 1 end

        if config.Ban.DefaultReason10 != nil then
            Damagelog.Ban_DefaultReason10 = config.Ban.DefaultReason10
        else missing = 1 end

        if config.Ban.DefaultReason11 != nil then
            Damagelog.Ban_DefaultReason11 = config.Ban.DefaultReason11
        else missing = 1 end
        
        if config.Ban.DefaultReason12 != nil then
            Damagelog.Ban_DefaultReason12 = config.Ban.DefaultReason12
        else missing = 1 end
    else missing = 1 end
    
    if config.Reports then  
        if config.Reports.NoStaffReports != nil then
            Damagelog.NoStaffReports = config.Reports.NoStaffReports
        else missing = 1 end
        if config.Reports.MoreReportsPerRound != nil then
            Damagelog.MoreReportsPerRound = config.Reports.MoreReportsPerRound
        else missing = 1 end
        if config.Reports.ReportsBeforePlaying != nil then
            Damagelog.ReportsBeforePlaying = config.Reports.ReportsBeforePlaying
        else missing = 1 end
    else missing = 1 end    

    if config.LogDays != nil then
        Damagelog.LogDays = config.LogDays
    else missing = 1 end

    if config.HideDonateButton != nil then
        Damagelog.HideDonateButton = config.HideDonateButton
    else missing = 1 end

    if config.UseWorkshop != nil then
        Damagelog.UseWorkshop = config.UseWorkshop
    else missing = 1 end

    if config.ForcedLanguage != nil then
        Damagelog.ForcedLanguage = config.ForcedLanguage
    else missing = 1 end

    if config.PrivateMessagePrefix != nil then
        Damagelog.PrivateMessagePrefix = config.PrivateMessagePrefix
    else missing = 1 end

    if config.DiscordWebhookMode != nil then
        Damagelog.DiscordWebhookMode = config.DiscordWebhookMode
    else missing = 1 end

    return missing
end

function Damagelog:loadMySQLConfig()
    if not file.Exists("damagelog/mysql.json", "DATA") then --If no mysql config exists save the default and return as if we loaded one.
        Damagelog:saveMySQLConfig()
        return 0
    end
    local config = util.JSONToTable(file.Read("damagelog/mysql.json", "DATA"))
    if not config then
        ErrorNoHalt("Damagelogs: ERROR - MySQL Config Exists but is not valid JSON!")
        return -1
    end
    Damagelog.MySQL_Informations = config
end

function Damagelog:saveMySQLConfig()
    file.Write("damagelog/mysql.json",util.TableToJSON(Damagelog.MySQL_Informations,true))
end

