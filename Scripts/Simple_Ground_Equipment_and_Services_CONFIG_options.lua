
-- In this file. users may write "true" instead of "false" to
-- display elements or vehicles at startup. depending on personnel preference.

if read_the_SGES_startup_options then -- do not touch this line.
--------------------------------------------------------------------------------
--[[    Available settings. to already display some vehicles at startup	--]]
--------------------------------------------------------------------------------
-- Visual docking guidance system default time :

--VDGS_time = "local" -- local time in the simulator is displayed
VDGS_time = "zulu" -- UTC time is displayed
-- (uncomment the desired value, either zulu or local)
--------------------------------------------------------------------------------

-- Static elements
-- They will be applied after a delay when loading a situation in X-Plane.

show_Cones =  			true	-- Cones around the aircraft
--------------------------------
show_DoorOpen = 		false 	-- Open the aircraft door. if referenced in SGES
--------------------------------
-- Vehicles

show_FUEL =  			false	-- Fuel truck
show_Cleaning =  		false	 -- AFT van or vehicule
show_BeltLoader =  		false	-- Forward beltloader or ULD
show_RearBeltLoader = 	false	 -- Aft baggage conveyor
show_Cart =  			false	-- Bagage cart
show_Catering =  		false	-- Catering vehicle
show_FireVehicle = 		false	-- Emergency vehicule
show_PRM = 			    false 	-- People with reduced mobility

--------------------------------------------------------------------------------
--[[    Other available settings. but keeping them false is recommended	--]]
--------------------------------------------------------------------------------
show_Bus =  			false	-- passengers bus (for pax aircraft)
							--[[ NOT recommended because at this step we don't
							     know if it is a freighter of pax aircraft --]]

show_ULDLoader = 		false	-- CARGO loader (for freighters)
								--[[ NOT recommended because at this step we don't
							     know if it is a freighter or pax aircraft --]]

show_StairsXPJ =  		false	-- forward STAIRS
							-- NOT recommended (compatible with few aircraft)
							-- Will not appear for the smallest planes anyway.

--------------------------------------------------------------------------------
--[[    Deactivated options, you are dettered to use them	--]]
--------------------------------------------------------------------------------
-- show_Chocks = 			true	-- Aircraft active chocks -- deactivated in SGES 67.8
-- Keep that commented out to retain "show_Chocks = false" by default.
-- This setting is deactivated because if set to true, this has detrimental effects
-- such as having the plane slide after the initial X-Plane session load.
-- This, it's better to always have show_Chocks = false at X-Plane startup.
-- My explanation is that the chocks are generated too early at X-Plane startup
-- before the situation is loaded completely and the plane gets a "comfortable attitude".
--------------------------------------------------------------------------------
end -- do not touch this line.

--------------------------------------------------------------------------------
-- Default carrier group decimal coordinates - SGES version 61.9 format

Carrier_group_lat_t  = {35.068178,34.913668,35.479329,3.966679,21.974076,26.169860,37.660522,36.970025,72.961280,21.023470,30.029827,32.579909,35.901390,17.5,-51.715584,3.169851,48.437770,36.014929,21.774075,42.426945,29.507140,0}
Carrier_group_lon_t  = {24.724122,34.691514,24.169004,51.550254,122.995797,124.590442,-76.092816,-76.456974,24.728590,-157.944463,-176.862588,-117.505557,14.529525,108.5,-57.747326,2.775743,-5.002432,-5.112454,62.944697,16.822456,34.957399,0}
Carrier_group_name_t = {"Tympaki, Greece","Cyprus, East Med.","Souda Bay, Greece","Somalia, Indian oc.","Taiwan","Senkaku/Diaoyu islands","Cheasapeake bay, USA","Norfolk VA, USA","Barents sea","Pearl Harbor, USA","Midway islands","San Diego CA, USA","Valetta, Malta","Yankee st., Tonkin Gulf","Port Stanley, Falklands","Guinea Gulf","Ouessant, France","Gibraltar, West Med.","Oman Gulf","Adriatic sea","Red Sea Gulf","custom_2"}
-- max size of this list is 22 locations, per the main script.
-- you may replace custom_1 and custom_2 and their respective 0/0 values
-- I replace all commas by points when I use https://www.bing.com/maps decimal latitude and longitude

-- Preloading a default location :
user_boat_lat = 38.162049
user_boat_lon = 12.413698
user_boat_location_name = "Palermo, Sicilia, It."



-----------------------------------------------------------------------
-- Anti-respawn settings
sges_capture_elevation_threshold = 500 --m AGL This value needs to be high -- default is 500 meters AGL, so 1640 feet AGL

--~ In X-Plane 12 when AI got shot down, they often go into a crazy whirling when they meet the ground. At this moment, X-Plane crashes.to the desktop,
--~ The anti respawn captures any aircraft approaching the ground vicinity and disable it before the infamous whirling occurs. In order to be effective, I will need to capture the aircraft high enough above the ground though.
--~ https://forums.x-plane.org/index.php?/forums/topic/298110-fatal-flight-model-error-when-downed-ai-aircraft-reach-the-ground-and-depart-from-stable-flying/#comment-2643326
-----------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Include parking positions from the folder Custom Scenery when building the cache
includeCustomParkingPositions = true -- DEPRECATED
-- Set that to false ONLY if you have a problem at scenery cache creation in SGES
-- This is deprecated because a drop down menu has been included in-game (v62).
