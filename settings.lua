if not cb then cb = {} end
if not cb.ibg then cb.ibg = {} end


function cb.ibg.do_settings(settings_table)
    for i, v in pairs(settings_table) do
        table.insert(v, 'none')
        -- add the "none" menu option to each line
        data:extend({
            {
                type = 'string-setting',
                name = i,
                setting_type = 'startup',
                default_value = v[1],
                allowed_values = v
            }
        })
    end
end
