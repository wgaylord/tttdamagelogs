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
