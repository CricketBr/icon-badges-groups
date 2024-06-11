-- from https://github.com/Factorio-Xander-Mod/Xander-Mod/commit/76896d2d0c1d9da58a286c96141647d1b7ccf7fb#diff-6c2b930bdb4762f2079066c35c72fa5697cea9b7341afa02a9e9d31e74df8aef
-- by jodokus31
-- slightly changed by Cricket

-- rev 2024-06-08
-- Can leave quote marks in header row.
-- Can use numbers (including decimals) and blank in data; no need to put in quotes.

-- function cb.ibg.import_table.csv_to_lua(the_file)

-- format of the data file, from the spreadsheet, (remove --)
-- see README for suggestions for which spreadsheet, and settings
-- No spaces!

-- return [[
-- badge;name;type;badgegroup
--"Fe";"iron-plate";"item";"metals-group-scientific"
--"Fe";"iron-coil";"item";"metals-group-scientific"
--"I";"iron-plate";"item";"metals-group-english"
--"I";"iron-coil";"item";"metals-group-english"
--]]

-- This returns a structure:
-- {
-- 	{ badge = "Fe", name = "iron-plate", type = "item", badgegroup = "metals-group-scientific" },
-- 	{ badge = "Fe", name = "iron-coil",  type = "item", badgegroup = "metals-group-scientific" },
-- 	{ badge = "I",  name = "iron-plate", type = "item", badgegroup = "metals-group-english" },
-- 	{ badge = "I",  name = "iron-coil",  type = "item", badgegroup = "metals-group-english" },
-- }




if not cb then cb = {} end
if not cb.ibg then cb.ibg={} end
-- if not cb.import_table then cb.import_table = {} end
-- if not cb.import_table.table then cb.import_table.table = {} end

local logtools = {}

logtools.mode = 1

function logtools.log(mode, x, y, z)
	if not logtools.mode then
		return
	end

	-- only display, if mode is equal or lower
	if mode <= logtools.mode then
		if x then log(serpent.block(x)) end
		if y then log(serpent.block(y)) end
		if z then log(serpent.block(z)) end
	end
end

local csvtools = {}

local DELIM = ";"
local CELLPATTERNHEADER = "\"?([^" .. DELIM .. "\"]*)\"?" .. DELIM
local CELLPATTERN       = "([^" .. DELIM .. "]*)" .. DELIM

function csvtools.read_lines(lines_string)
	local lines = {}
	for line in string.gmatch(lines_string, "[^\r\n]+") do
		lines[#lines + 1] = line
		-- log('cbdebug - csv-to-lua '..lines_string) -- debug
	end
	return lines
end

function csvtools.string_as_value(str)
	-- if string is an unknown identifier return as string and dont call it
	if str ~= "nil" and str ~= "true" and str ~= "false" and str:match("^[A-Za-z_][A-Za-z0-9_]*$") then
		return str
  -- numbers are should be returned as string
  elseif str:match("^[0-9]*$") then
    return str
	else
		return load("return " .. str)()
	end
end

function csvtools.get_linepattern(line)
	local linepattern = ""
	local column_names = {}

	-- f.e. group;subgroup;name;xm;recipes;specials;prerequisites;count;ingredients;time;;icon
	for cell in string.gmatch(line, CELLPATTERNHEADER) do
		logtools.log(5, "cell: ", cell)

		linepattern = linepattern .. CELLPATTERN
		column_names[#column_names + 1] = cell
	end

	return linepattern, column_names
end

function csvtools.read_data_from_csv_lines(lines)
	local data = {}

	local linepattern = ""
	local column_names = {}

	local firstline = true

	for _, line in ipairs(lines) do
		-- skip empty lines
		if line and line ~= "" then
			-- always add the delimeter at the end
			local line_with_trailing_delim = line .. DELIM

			if firstline then
				-- the first line contains the column_names
				-- linepattern is a regex for the whole line
				linepattern, column_names = csvtools.get_linepattern(line_with_trailing_delim)
				logtools.log(4, "linepattern: ", linepattern)
				logtools.log(4, "column_names", column_names)
				firstline = false
			else
				-- values is an array of all cell values
				local values = { line_with_trailing_delim:match(linepattern) }

				logtools.log(5, "values: ", values)

				local data_entry = {}
				for i, column_name in ipairs(column_names) do
					if column_name and column_name ~= "" then
						local value = values[i]
						data_entry[column_name] = csvtools.string_as_value(value)
					end
				end

				logtools.log(4, "data_entry: ", data_entry)

				data[#data + 1] = data_entry
			end
		end
		-- log('cbdebug import table success line '..line) -- debug option
	end

	return data
end

-- local bigtable_csv = require('bigtable-csv')
-- local bigtable_lines = csvtools.read_lines(bigtable_csv)
-- cb.import_table.table = csvtools.read_data_from_csv_lines(bigtable_lines)

function cb.ibg.csv_to_lua(the_file)
	local bigtable_lines = csvtools.read_lines(the_file)
	return csvtools.read_data_from_csv_lines(bigtable_lines)
end
