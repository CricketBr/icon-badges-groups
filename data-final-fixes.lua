-- ?? trying to recall how I did this
-- iirc new method doesn't activate this file, so it shouldn't exist.
-- It's the other file, group_badges, that has the fn that is called.

if not cb then cb = {} end
if not cb.ibg then cb.ibg = {} end


local function log_it(m, v) -- print a message and the item?? to log file
    log('icon-badges-groups : ' .. ' name = ' .. v.name .. ', type = ' .. v.type .. ', badge = ' .. v.badge .. ' : ' .. m)
end

function cb.ibg.do_badges(settings_table, bigtable)
    local ldebugflags = {}
    ldebugflags.log_entry = false
    ldebugflags.log_success = false
    ldebugflags.log_fail = true

    local badge_groups_to_do = {}
    for i, v in pairs(settings_table) do
        badge_groups_to_do[settings.startup[i].value] = true
    end

    for _, v in ipairs(bigtable) do
        local l_typetest, l_rawtest

        if v.type == 'item'
            or v.type == 'fluid'
            or v.type == 'recipe'
            or v.type == 'module'
            or v.type == 'tool'
            or v.type == 'ammo'
            or v.type == 'capsule'
        then
            l_typetest = true
            if data.raw[v.type][v.name] then
                l_rawtest = true
            else
                l_rawtest = false
                log_it('prototype not in data.raw', v)
            end
        else
            l_typetest = false
            log_it('not in allowed types', v)
        end

        if badge_groups_to_do[v.badgegroup] and l_typetest and l_rawtest then
            local ib_data = { ib_let_badge = v.badge, ib_let_corner = 'right-top' }
            -- log_it('doing',v)
            if pcall(Build_badge, data.raw[v.type][v.name], ib_data) then
                log_it('success', v)
            else
                log_it('fail in Build_badge', v)
            end

            if v.type == 'fluid' then -- do barrel
                local bname = v.name .. '-barrel'
                if data.raw.item[bname] then
                    if pcall(Build_badge, data.raw['item'][bname], ib_data) then
                        if ldebugflags.log_success then log_it('success barrel', v) end
                    else
                        if ldebugflags.log_fail then log_it('fail barrel', v) end
                    end
                end
            end
        else
            log_it('fail 2', v)
        end
        local a = 1
    end

    local b = 1
end

-- local function do_badge(v)
--     if ldebugflags.log_entry then log_it('entering', v) end
--     local ib_data = { ib_let_badge = v.badge, ib_let_corner = 'right-top' }
--     if pcall(Build_badge, data.raw[v.type][v.name], ib_data) then
--         -- if ldebugflags.log_success then log_it('success', v) end
--     else
--         if ldebugflags.log_fail then log_it('fail', v) end
--     end
-- end
