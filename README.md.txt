Icon Badges Groups is a library.

Icon Badges Groups Nullius and Icon Badges SeaBlock, are the data and a few function calls. Icon Badges Groups can be used by other modpacks without modifications.

Icon Badges Groups Nullius is a good template for other modpacks, since it requires boxing and unboxing.

Library functions include:

- cb.ibg.csv_to_lua()

It is much easier to wrangle large amounts of data in csv format than in lua format. (SeaBlock has over 400 lines, and Nullius has over 1000 -- before counting multiple badge groups, eg metals-group-english and metals-group-scientific.)

require ([[
name;badge;type;badgegroup
"iron-ore";"I";"item";"metals-group-english"
"iron-ore";"Fe";"item";"metals-group-scientific"
"iron-ingot";"I";"item";"metals-group-english"
"iron-ingot";"Fe";"item";"metals-group-scientific"
...
]]

(LibreOffice works well for the data wrangling. Use SaveAs CSV and check Data Filter.)

Any other way of creating the lua table will work, if you don't want to use the csv-to-lua function.
{
	{ name = "iron-ore", badge = "I", type = "item", badgegroup = "metals-group-english"
	{ name = "iron-ore", badge ="Fe", type = "item", badgegroup = "metals-group-scientific"
	{ name = "iron-ingot", badge ="I", type = "item", badgegroup = "metals-group-english"
	{ name = "iron-ingot", badge ="Fe", type = "item", badgegroup = "metals-group-scientific"
}

- cb.ibg.do_settings()

This function takes a simple table and turns it into game settings. The next function also uses this table to decide which badges to use.

- cb.ibg.do_badges()

This function looks at the player settings and the entire big data table, and calls Build_badge from Icon Badges.

It automatically checks each fluid and adds the badge to the barrel, if there is one.


Many thanks to Galdoc. My bit for SeaBlock was long but fairly easy. Creating Icon Badges, with all its features, plus getting it to work with SeaBlock's image formats, was much harder. Also thanks to jodokus31 for the csv import function.
