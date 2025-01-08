--Code Shared by autoslay for ULX, SAM and sAdmin

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
