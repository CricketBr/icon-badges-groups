Icon Badges Groups is a library to make it easier to use Icon Badges (by Galdoc). https://mods.factorio.com/mod/icon-badges

Everything specific to a modpack is in a separate mod, such as Icon Badges Groups Nullius https://mods.factorio.com/mod/icon-badges-nullius and Icon Badges SeaBlock https://mods.factorio.com/mod/icon-badges-seablock. These have the data, function calls to the library, and sometimes a bit of automation.

Icon Badges Groups Nullius is a good template for other modpacks, since it requires boxing and unboxing.

This description assumes you are familiar with Factorio prototypes and recipe main-product .

Library functions in Icon Badges Groups include:

##cb.ibg.csv_to_lua()

This function converts a lua file with csv data to a lua table. It is much easier to manage large amounts of data in csv format than in lua format. (SeaBlock has over 400 lines, and Nullius has over 1000 -- before counting multiple badge groups, eg metals-group-english and metals-group-scientific.)

Format:

return[[
"name";"badge";"type";"badgegroup";"subgroup";"localization"
"iron-ore";"Irn";"item";"metallurgy-group-english";"iron";
"iron-ore";"Fe";"item";"metallurgy-group-scientific";"iron";
"iron-ingot-2";"Irn";"recipe";"metallurgy-group-english";"iron";
"iron-ingot-2";"Fe";"recipe";"metallurgy-group-scientific";"iron";
]]

The columns can be in any order. Name, badge, type and badgegroup are the only ones used by this mod. The rest are for ease of data wrangling. You can add more columns.

LibreOffice works well for the data wrangling. Use SaveAs CSV and check Data Filter. Sort the rows so there are no blank rows in the csv file.

Any other way of creating the lua table will work, if you don't want to use the csv-to-lua function.
{
	{ name = "iron-ore", badge = "I", type = "item", badgegroup = "metals-group-english" }
	{ name = "iron-ore", badge ="Fe", type = "item", badgegroup = "metals-group-scientific" }
	{ name = "iron-ingot", badge ="I", type = "item", badgegroup = "metals-group-english" }
	{ name = "iron-ingot", badge ="Fe", type = "item", badgegroup = "metals-group-scientific" }
}

##cb.ibg.do_settings()

This function takes a simple table and turns it into game settings. The next function also uses this table to decide which badges to use.

##cb.ibg.do_badges()

This function looks at the player settings and the entire big data table, then calls Build_badge from Icon Badges.

It automatically checks each fluid and adds the badge to the barrel, if there is one.

---

Many thanks to Galdoc. My bit for SeaBlock was long but fairly easy. Creating Icon Badges, with all its features, plus getting it to work with SeaBlock's image formats, was much harder. Also thanks to jodokus31 for the csv import function.
