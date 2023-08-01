local function CreateCommand()
    if ulx then
        local mode = Damagelog.ULX_AutoslayMode
        if mode ~= 1 and mode ~= 2 then return end
        local aslay = mode == 1

        function ulx.autoslay(calling_ply, target, rounds, reason)
            Damagelog:SetSlays(calling_ply, target:SteamID(), rounds, reason, target)
        end

        function ulx.autoslayid(calling_ply, target, rounds, reason)
            if ULib.isValidSteamID(target) then
                for _, v in ipairs(player.GetHumans()) do
                    if v:SteamID() == target then
                        ulx.autoslay(calling_ply, v, rounds, reason)

                        return
                    end
                end

                Damagelog:SetSlays(calling_ply, target, rounds, reason, false)
            else
                ULib.tsayError(calling_ply, "Invalid steamid.", true)
            end
        end

        function ulx.cslays(calling_ply, target)
            -- TODO: Support MySQL
            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(target:SteamID())))
            local txt = aslay and "slays" or "jails"
            local p = "has"

            if calling_ply == target then
                p = "have"
            end

            if data then
                ulx.fancyLogAdmin(calling_ply, "#T " .. p .. " " .. data.slays .. " " .. txt .. " left with the reason : #s", target, data.reason)
            else
                ulx.fancyLogAdmin(calling_ply, "#T " .. p .. " no " .. txt .. " left.", target)
            end
        end

        function ulx.cslaysid(calling_ply, steamid)
            if not ULib.isValidSteamID(steamid) then
                ULib.tsayError(calling_ply, "Invalid steamid.", true)

                return
            end

            -- TODO: Support MySQL
            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(steamid)))
            local txt = aslay and "slays" or "jails"

            if data then
                ulx.fancyLogAdmin(calling_ply, "#s has " .. data.slays .. " " .. txt .. " left with the reason : #s", steamid, data.reason)
            else
                ulx.fancyLogAdmin(calling_ply, "#s has no " .. txt .. " left.", steamid)
            end
        end

        local autoslay = ulx.command("TTT", aslay and "ulx aslay" or "ulx ajail", ulx.autoslay, aslay and "!aslay" or "!ajail")

        autoslay:addParam({
            type = ULib.cmds.PlayerArg
        })

        autoslay:addParam({
            type = ULib.cmds.NumArg,
            min = 0,
            default = 1,
            hint = "rounds (0 to cancel slay)",
            ULib.cmds.optional, ULib.cmds.round
        })

        autoslay:addParam({
            type = ULib.cmds.StringArg,
            hint = aslay and "slay reason" or "jail reason",
            default = Damagelog.Autoslay_DefaultReason,
            ULib.cmds.optional, ULib.cmds.takeRestOfLine
        })

        autoslay:defaultAccess(ULib.ACCESS_ADMIN)
        local help

        if aslay then
            help = "Slays the target for a specified number of rounds. Set the rounds to 0 to cancel the slay."
        else
            help = "Jails the target for a specified number of rounds. Set the rounds to 0 to cancel the jails."
        end

        autoslay:help(help)
        local autoslayid = ulx.command("TTT", aslay and "ulx aslayid" or "ulx ajailid", ulx.autoslayid, aslay and "!aslayid" or "!ajailid")

        autoslayid:addParam({
            type = ULib.cmds.StringArg,
            hint = "steamid"
        })

        autoslayid:addParam({
            type = ULib.cmds.NumArg,
            min = 0,
            default = 1,
            hint = aslay and "rounds (0 to cancel slay)" or "rounds (0 to cancel jails)",
            ULib.cmds.optional, ULib.cmds.round
        })

        autoslayid:addParam({
            type = ULib.cmds.StringArg,
            hint = aslay and "slay reason" or "jail reason",
            default = Damagelog.Autoslay_DefaultReason,
            ULib.cmds.optional, ULib.cmds.takeRestOfLine
        })

        autoslayid:defaultAccess(ULib.ACCESS_ADMIN)

        if aslay then
            help = "Slays the steamid for a specified number of rounds. Set the rounds to 0 to cancel the slay."
        else
            help = "Jails the steamid for a specified number of rounds. Set the rounds to 0 to cancel the jails."
        end

        autoslayid:help(help)
        local cslays = ulx.command("TTT", aslay and "ulx cslays" or "ulx cjails", ulx.cslays, aslay and "!cslays" or "!cjails")

        cslays:addParam({
            type = ULib.cmds.PlayerArg
        })

        cslays:defaultAccess(ULib.ACCESS_ADMIN)
        local cslaysid = ulx.command("TTT", aslay and "ulx cslaysid" or "ulx cjailsid", ulx.cslaysid, aslay and "!cslaysid" or "!cjailsid")

        cslaysid:addParam({
            type = ULib.cmds.StringArg,
            hint = "steamid"
        })

        cslaysid:defaultAccess(ULib.ACCESS_ADMIN)

        return
    elseif sam then
        function sam.autoslay(calling_ply, target, rounds, reason)
            Damagelog:SetSlays(calling_ply, target:SteamID(), rounds, reason, target)
        end

        function sam.autoslayid(calling_ply, target, rounds, reason)
            if sam.is_steamid(target) then
                for _, v in ipairs(player.GetHumans()) do
                    if v:SteamID() == target then
                        sam.autoslay(calling_ply, v, rounds, reason)

                        return
                    end
                end

                Damagelog:SetSlays(calling_ply, target, rounds, reason, false)
            else
                sam.player.send_message(calling_ply, "{V_1} is an invalid steamid.", {
                    V_1 = target
                })
            end
        end

        function sam.cslays(calling_ply, target)
            -- TODO: Support MySQL
            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(target:SteamID())))
            local txt = aslay and "slays" or "jails"
            local p = "has"
            local t = target:Name()

            if calling_ply == target then
                p = "have"
                t = "You"
            end

            if data then
                sam.player.send_message(calling_ply, "{T} {V_1} {V} {V_2} left with the reason : {V_3}", {
                    T = t,
                    V_1 = p,
                    V = data.slays,
                    V_2 = txt,
                    V_3 = data.reason
                })
            else
                sam.player.send_message(calling_ply, "{T} {V_1} no {V_2} left.", {
                    T = t,
                    V_1 = p,
                    V_2 = txt
                })
            end
        end

        function sam.cslaysid(calling_ply, steamid)
            if not sam.is_steamid(steamid) then
                sam.player.send_message(calling_ply, "{V_1} is an invalid steamid.", {
                    V_1 = steamid
                })

                return
            end

            -- TODO: Support MySQL
            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(steamid)))
            local txt = aslay and "slays" or "jails"

            if data then
                sam.player.send_message(calling_ply, "{T} has {V} {V_1} left with the reason : {V_2}", {
                    T = steamid,
                    V = data.slays,
                    V_1 = txt,
                    V_2 = data.reason
                })
            else
                sam.player.send_message(calling_ply, "{T} has no {V_1} left.", {
                    T = steamid,
                    V_1 = txt
                })
            end
        end

        local command = sam.command
        command.set_category("TTT")

        command.new("aslay")
            :SetPermission("aslay", "operator")

            :AddArg("player", {
                single_target = true
            })

            :AddArg("number", {
                hint = "amount",
                optional = true,
                default = 1,
                round = true
            })

            :AddArg("text", {
                hint = "reason",
                optional = true,
                default = "Reason"
            })

            :Help("Add slays to a person")
            :OnExecute(function(admin, targets, slays, reason)
                local target = targets[1]
                Damagelog:SetSlays(admin, target:SteamID(), slays, reason, target)
            end)
        :End()

        command.new("aslayid")
            :SetPermission("aslayid", "operator")
            :AddArg("steamid")

            :AddArg("number", {
                hint = "amount",
                default = 1,
                round = true
            })

            :AddArg("text", {
                hint = "reason",
                default = "Reason"
            })

            :Help("Add slays to a steamid.")

            :GetRestArgs(true)

            :OnExecute(function(admin, promise, slays, reason)
                promise:done(function(data)
                    local steamid, target = data[1], data[2] -- target will be "nil" if player is not online -- target will be "nil" if player is not online
                    Damagelog:SetSlays(admin, steamid, slays, reason, target)
                end)
            end)
        :End()

        command.new("removeslays")
            :SetPermission("removeslays", "operator")

            :AddArg("player", {
                single_target = true
            })

            :Help("Remove slays from a person")

            :OnExecute(function(ply, targets)
                local target = targets[1]
                Damagelog:SetSlays(ply, target:SteamID(), 0, "Removed", target)
            end)
        :End()

        command.new("cslay")
            :SetPermission("cslay", "operator")
            :AddArg("player", {
                single_target = true
            })
            :Help("Get slays of a person.")
            :OnExecute(function(admin, targets, amount, reason)
                local target = targets[1]
                sam.cslays(admin, target)
            end)
        :End()

        command.new("cslayid")
            :SetPermission("cslayid", "operator")

            :AddArg("steamid")

            :Help("Get slays of a person.")

            :OnExecute(function(admin, targets, amount, reason)
                local steamid = targets[1]
                sam.cslaysid(admin, steamid)
            end)
        :End()
    elseif sAdmin then
        function sAdmin.isValidSteamID(steamid)
            return string.match(steamid, "^STEAM_[0-5]:[01]:%d+$") ~= nil
        end

        function sAdmin.autoslay(calling_ply, target, rounds, reason)
            Damagelog:SetSlays(calling_ply, target:SteamID(), rounds, reason, target)
        end

        function sAdmin.autoslayid(calling_ply, steamid, rounds, reason)
            if not sAdmin.isValidSteamID(steamid) then
                sAdmin.msg(calling_ply, "%s is an invalid steamid.", steamid)

                return
            end

            for _, v in ipairs(player.GetHumans()) do
                if v:SteamID() == steamid then
                    sAdmin.autoslay(calling_ply, v, rounds, reason)

                    return
                end
            end

            Damagelog:SetSlays(calling_ply, steamid, rounds, reason, false)
        end

        function sAdmin.cslay(calling_ply, target)
            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(target:SteamID())))

            if data then
                sAdmin.msg(calling_ply, "%s has %s slays left with the reason: %s", target:Nick(), data.slays, data.reason)
            else
                sAdmin.msg(calling_ply, "%s has no slays left.", target:Nick())
            end
        end

        function sAdmin.cslayid(calling_ply, steamid)
            if not sAdmin.isValidSteamID(steamid) then
                sAdmin.msg(calling_ply, "%s is an invalid steamid.", steamid)

                return
            end

            local data = Damagelog.SQLiteDatabase.QuerySingle(string.format("SELECT * FROM damagelog_autoslay WHERE ply = %s", sql.SQLStr(steamid)))

            if data then
                sAdmin.msg(calling_ply, "%s has %s slays left with the reason: %s", steamid, data.slays, data.reason)
            else
                sAdmin.msg(calling_ply, "%s has no slays left.", steamid)
            end
        end

        sAdmin.addCommand({
            name = "aslay",
            category = "TTT Management",
            inputs = {
                {"player", "player_name"},
                {"number", "rounds"},
                {"text", "reason"}
            },
            func = function(admin, args, silent)
                if not args[1] then return end
                local targets = sAdmin.getTargets("autoslay", admin, args[1], 1)
                local rounds = tonumber(args[2]) or 1
                local reason = args[3] or "Reason"

                for k, target in ipairs(targets) do
                    if target and target:IsPlayer() then
                        Damagelog:SetSlays(admin, target:SteamID(), rounds, reason, target)
                    end
                end
            end
        })

        sAdmin.addCommand({
            name = "aslayid",
            category = "TTT Management",
            inputs = {
                {"text", "steamid"},
                {"number", "rounds"},
                {"text", "reason"}
            },
            func = function(admin, args, silent)
                local steamid = args[1]
                if not steamid then return end
                local rounds = tonumber(args[2]) or 1
                local reason = args[3] or "Reason"
                Damagelog:SetSlays(admin, steamid, rounds, reason, false)
            end
        })

        sAdmin.addCommand({
            name = "removeslays",
            category = "TTT Management",
            inputs = {
                {"player", "player_name"}
            },
            func = function(admin, args, silent)
                if not args[1] then return end
                local targets = sAdmin.getTargets("removeslays", admin, args[1], 1)

                for k, target in ipairs(targets) do
                    if target and target:IsPlayer() then
                        Damagelog:SetSlays(admin, target:SteamID(), 0, "Removed", target)
                    end
                end
            end
        })

        sAdmin.addCommand({
            name = "cslay",
            category = "TTT Management",
            inputs = {
                {"player", "player_name"}
            },
            func = function(admin, args, silent)
                if not args[1] then return end
                local targets = sAdmin.getTargets("cslay", admin, args[1], 1)

                for k, target in ipairs(targets) do
                    if target and target:IsPlayer() then
                        sAdmin.cslay(admin, target)
                    end
                end
            end
        })

        sAdmin.addCommand({
            name = "cslayid",
            category = "TTT Management",
            inputs = {
                {"text", "steamid"}
            },
            func = function(admin, args, silent)
                local steamid = args[1]
                if not steamid then return end
                sAdmin.cslayid(admin, steamid)
            end
        })
    end
end

hook.Add("Initialize", "AutoSlay", CreateCommand)

hook.Add("ShouldCollide", "ShouldCollide_Ghost", function(ent1, ent2)
    if IsValid(ent1) and IsValid(ent2) then
        if ent1:IsPlayer() and not ent1.jail and ent2.jailWall then return false end
        if ent2:IsPlayer() and not ent2.jail and ent1.jailWall then return false end
    end
end)

if CLIENT then
    local mode = Damagelog.ULX_AutoslayMode
    if mode ~= 1 and mode ~= 2 then return end
    local aslay = mode == 1

    function Damagelog.SlayMessage()
        chat.AddText(Color(255, 128, 0), "[Autoslay] ", Color(255, 128, 64), net.ReadString())
    end

    net.Receive("DL_SlayMessage", Damagelog.SlayMessage)

    net.Receive("DL_AutoSlay", function()
        local ply = net.ReadEntity()
        local list = net.ReadString()
        local reason = net.ReadString()
        local _time = net.ReadString()
        if not IsValid(ply) or not ply:IsPlayer() or not list or not reason or not _time then return end
        local text = aslay and " has been autoslain by " or " has been autojailed by "
        chat.AddText(Color(255, 62, 62), ply:Nick(), color_white, text, color_lightblue, list .. " ", color_white, _time .. " ago with the reason: '" .. reason .. "'.")
    end)

    net.Receive("DL_AutoSlaysLeft", function()
        local ply = net.ReadEntity()
        local slays = net.ReadUInt(32)
        if not IsValid(ply) or not ply:IsPlayer() or not slays then return end
        ply.AutoslaysLeft = slays
    end)

    net.Receive("DL_PlayerLeft", function()
        local nick = net.ReadString()
        local steamid = net.ReadString()
        local slays = net.ReadUInt(32)
        if not nick or not steamid or not slays then return end
        local auto = aslay and " autoslay" or " autojail"
        chat.AddText(Color(255, 62, 62), nick .. "(" .. steamid .. ") has disconnected with " .. slays .. auto .. (slays > 1 and "s" or "") .. " left!")
    end)

    if aslay then return end

    local jails = {}

    net.Receive("DL_SendJails", function()
        local count = net.ReadUInt(32)
        local walls = {}

        for i = 1, count do
            table.insert(walls, net.ReadEntity())
        end

        for _, v in ipairs(walls) do
            table.insert(jails, v)
        end
    end)

    local function CheckWalls()
        for k, v in ipairs(jails) do
            if IsValid(v) then
                v:SetCustomCollisionCheck(true)
                v.jailWall = true
            end
        end

        jails = {}
    end

    hook.Add("Think", "JailWalls", CheckWalls)
end
