Damagelog.SQLiteDatabase = {}

function Damagelog.SQLiteDatabase.Query(queryString)
    local result = sql.Query(queryString)
    if(result == false) then
        local queryShort = queryString
        if(string.len(queryShort) > 20) then 
            queryShort = string.sub(queryString, 1, 20) .. "..."
        end
        assert(false, string.format("%s:\n[SQL Error] %s", "Error performing query " .. queryShort, sql.LastError()))
    end

    return result
end

function Damagelog.SQLiteDatabase.QuerySingle(queryString)
    local result = Damagelog.SQLiteDatabase.Query(queryString)
    if result == nil then return nil end

    return result[1]
end

function Damagelog.SQLiteDatabase.QueryValue(queryString)
    local result = Damagelog.SQLiteDatabase.QuerySingle(queryString)
    if result == nil then return nil end

    for k, v in pairs(result) do return v end
    return result
end
