-- ?? trying to recall how I did this
-- iirc new method doesn't activate this file, so it shouldn't exist.
-- It's the other file, group_badges, that has the fn that is called.



if not cb then cb = {} end
if not cb.ibg then cb.ibg = {} end

local function logit(m, v) -- print a message and the item?? to log file
    local l_logging = true
    if l_logging then
        log('icon-badges-groups cbdebug : ' ..
            ' name = ' ..
            v.name .. ', type = ' .. v.type .. ', badge = ' .. v.badge .. ', group = ' .. v.badgegroup .. ' : ' .. m)
    end
end

function cb.ibg.do_badges(settings_table, bigtable, debugflags)
    local l_debugflags = {}
    if debugflags then
        l_debugflages = debugflags
    else
        l_debugflags.log_success = true
        l_debugflags.log_fail = true
    end


    local badge_groups_to_do = {}
    for i, v in pairs(settings_table) do
        badge_groups_to_do[settings.startup[i].value] = true
    end

    for _, v in ipairs(bigtable) do
        local l_typetest = false
        local l_rawtest = false
        local l_grouptest = false


        if 1 == 1 then
            l_typetest = true -- used to test to see if in list of allowed types
            if badge_groups_to_do[v.badgegroup] then
                l_grouptest = true
                if data.raw[v.type][v.name] then
                    l_rawtest = true
                end
            end
        end

        if not l_typetest then
            logit('l_typetest fail : ', v)
        end
        -- if not l_grouptest then logit('l_grouptest fail : ', v) end
        if l_grouptest and not l_rawtest then
            logit('l_rawtest fail : ', v)
        end


        if l_rawtest then
            local ib_data = { ib_let_badge = v.badge, ib_let_corner = 'right-top' }

            if pcall(Build_badge, data.raw[v.type][v.name], ib_data) then
                -- if l_debugflags.log_success then logit('badge built', v) end
            else
                if l_debugflags.log_fail then logit('fail in Build_badge', v) end
            end

            if v.type == 'fluid' then -- do barrelS
                local bname = v.name .. '-barrel'
                if data.raw.item[bname] then
                    if pcall(Build_badge, data.raw['item'][bname], ib_data) then
                        -- if l_debugflags.log_success then logit('success barrel', v) end
                    else
                        if l_debugflags.log_fail then logit('fail barrel', v) end
                    end
                end
            end
        end
        local b = 1
    end

    local b = 1
end
