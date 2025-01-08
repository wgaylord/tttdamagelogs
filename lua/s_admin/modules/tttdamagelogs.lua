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
