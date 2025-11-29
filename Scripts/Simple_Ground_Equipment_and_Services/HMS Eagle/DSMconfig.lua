settings = {
	displayed_name = {
		English = "HMS_Eagle",
		
	},
	author = "Juanik0",
	carrier_deck_height_mtr = 14.6,
	carrier_ILS_offset_x_mtr = 0.0,
	carrier_ILS_offset_z_mtr = 0.0,
	carrier_approach_heading = 0.0,
	carrier_catshot_heading =  5.1,
	carrier_catshot_start_x_mtr = -9.24,
	carrier_catshot_start_z_mtr = -21.57,
	carrier_catshot_end_x_mtr = 3.06,
	carrier_catshot_end_z_mtr = -90.50,
	test = "HMS_Eagle config is good",
}

-------------------------------------------------------------------------------------------------------------
--------------------------END OF CONFIG SETTINGS, DO NOT EDIT PAST THIS POINT--------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------






-------------------------------------------------------------------------------------------------------------
----------------------------EXAMPLE CONFIG (for reference only, do not edit)---------------------------------
-------------------------------------------------------------------------------------------------------------
--[[
These are the Default config values, all fields are optional, just add any, in any order, to the above section that need to be set for your object type, and omit any that will not be needed by your object type. Absent and inaplicable fields will be left unchanged. For example, if you do not include carrier_deck_height_mtr for a carrier object, the deck height will stay at what ever it was before the oject was changed. If you include 'carrier' settings in a config-file for a ballon, the carrier settings will not be read or changed. Default carrier settings are for Nimitz, default frigate settings are for Perry.

settings = {
	has_custom_logic =  "unused",				--not yet used; future feature
	displayed_name = "Default",					--name as you would like it to appear in th GUI. Must be in "" double quotes
	--or optionally:
	displayed_name = {
		English = "Default",					--include or omit any and all languages in any order you like. Only Languages currently 
		Español = "Predeterminado",				--supported by X-Plane will be used, but if you add non-supported ones here, I may add 
		Pусский = "По умолчанию",				--them to DSM in the future, and then they'll show up. If the users' selected language is
		Deutsch = "Standardeinstellung",		--not included here, then the folder name will be used instead.
	}
	author = "Laminar Reasearch or partners",	--self explanitory really. Who made it? Must be in "" double quotes.
	region = "unused",							--not yet used; future feature
	latitiude_northern_limit = "unused",		--not yet used; future feature
	latitude_southern_limit = "unused",			--not yet used; future feature
	longitude_western_limit = "unused",			--not yet used; future feature
	longitude_estern_limit = "unused",			--not yet used; future feature
	carrier_deck_height_mtr = 20.224701,		--float,	meters,	Deck height of the carrier (in coordinates of the OBJ model)
	carrier_ILS_offset_x_mtr = -5.0,			--float,	meters,	X position of the carrier ILS transmitter (in coordinates of the OBJ model)
	carrier_ILS_offset_z_mtr = 117.0,			--float,	meters,	Z position of the carrier ILS transmitter (in coordinates of the OBJ model)
	carrier_approach_heading = -8.0,			--float,	degrees(true),	Relative heading of the approach path from the carrier's heading
	carrier_catshot_heading =  -1.047977,		--float,	degrees(true),	Relative heading of the catshot relative to the carrier's heading
	carrier_catshot_start_x_mtr = -8.8,			--float,	meters,	X position (in model coordinates) of the start of the cat-shot track
	carrier_catshot_start_z_mtr = -66.0,		--float,	meters,	Z position (in model coordinates) of the start of the cat-shot track
	carrier_catshot_end_x_mtr = -10.6,			--float,	meters,	X position (in model coordinates) of the end of the cat-shot track
	carrier_catshot_end_z_mtr = -164.399994,	--float,	meters,	Z position (in model coordinates) of the end of the cat-shot track
	frigate_deck_height_mtr = 7.0607,			--float,	meters,	Deck height of the frigate (in coordinates of the OBJ model)
	frigate_ILS_offset_x_mtr = 0.0,				--float,	meters,	X position of the frigate ILS transmitter (in coordinates of the OBJ model)
	frigate_ILS_offset_z_mtr = 48.299999,		--float,	meters,	Z position of the frigate ILS transmitter (in coordinates of the OBJ model)
	test = "Example config file is good",		--output on load for debug, must be in "" double quotes
}

]]--
-------------------------------------------------------------------------------------------------------------
---------------------------------------END OF EXAMPLE CONFIG-------------------------------------------------
-------------------------------------------------------------------------------------------------------------

