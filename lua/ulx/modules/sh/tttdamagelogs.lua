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

