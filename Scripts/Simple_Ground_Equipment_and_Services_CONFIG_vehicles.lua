--------------------------------------------------------------------------------
-- Simple Ground Equipment & Services - (low tech ground services)
-- aka The Poor Man Ground Services ------------------------------------------
--------------------------------------------------------------------------------
-- USER PREFERENCES ------------------------------------------------------------
-- Version distributed with version 77.0 and above.

-- ||||||||||||||||| Set the strategy |||||||||||||||||||||||||||||||||||||||||||

-- defaulting the sole usage of default X-Plane 11 vehicles to FALSE. (ie, allow to use custom objects !)
UseXplaneDefaultObject = false
-- UseXplaneDefaultObject must be understood as "revert to legacy X-Plane objects instead of using some fancy new stuff".
-- When you don't use the SGES custom 3D vehicles, you revert to legacy X-Plane 11 vehicles where possible.


-- ||||||||||||||||| Set the paths |||||||||||||||||||||||||||||||||||||||||||||
--   Root for custom objects folders
local MisterX_Lib =   SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"
--local Custom_Scenery_root3 =   SCRIPT_DIRECTORY .. "../../../../Custom Scenery/LGKO - Gaya_Sim_LGKO_Ippokratis/Objects/"
if XPlane_Ramp_Equipment_directory == nil then XPlane_Ramp_Equipment_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Ramp_Equipment/" end -- safety

-- ||||||||||||||||| Set the objects |||||||||||||||||||||||||||||||||||||||||||

-- edit that as required :
-- if you want to use custom object, set the paths here

-- BUS OBJECT ------------------------------------------------------------------
User_Custom_Prefilled_AlternativeBusObject = 		XPlane_Ramp_Equipment_directory   .. "Cargo_Container_6.obj" -- when "passengers set" deactivated
User_Custom_Prefilled_BusObject_option1 = 			MisterX_Lib   .. "Cobus/Cobus_2700_Generic.obj"
User_Custom_Prefilled_BusObject_option2 =			MisterX_Lib   .. "Cobus/Cobus_2700_2.obj"
User_Custom_Prefilled_BusObject_doublet = 			MisterX_Lib   .. "Cobus/Cobus_2700_doublet.obj"
--User_Custom_Prefilled_BusObject_option2   = 		Custom_Scenery_root3   .. "Misc/LGOKO_cobus3000_anim.obj"

-- MILITARY BUS OBJECT ---------------------------------------------------------
User_Custom_Prefilled_BusObject_military_large  = 	MisterX_Lib   .. "Cobus/Cobus_2700_Mil.obj"  -- the Mil Pax bus
User_Custom_Prefilled_BusObject_military_small  = 	MisterX_Lib   .. "Cobus/Van_Mil_Pax.obj"     -- the Mil Pax van

-- Fuel TRUCK ------------------------------------------------------------------
User_Custom_Prefilled_FuelObject_option1 = 			MisterX_Lib   .. "Fuel_Trucks/Fuel.obj" 			-- large
User_Custom_Prefilled_FuelObject_option2 = 			MisterX_Lib   .. "Fuel_Trucks/Swissport.obj" 	-- small
User_Custom_Prefilled_FuelObject_Mil 	= 			MisterX_Lib   .. "Fuel_Trucks/Fuel_Mil.obj"		-- only for military option
User_Custom_Prefilled_FuelObject_USA 	= 			MisterX_Lib   .. "Fuel_Trucks/Fuel_EXXON.obj"		-- only for USA airports
User_Custom_Prefilled_FuelObject_USA_2 	= 			MisterX_Lib   .. "Fuel_Trucks/Fuel_long_nose.obj" -- only for USA airports
--User_Custom_Prefilled_FuelObject_option1 = 		Custom_Scenery_root3   .. "Vehicles/fuel_truck1.obj"

-- STAIRS ----------------------------------------------------------------------
User_Custom_Prefilled_StairsObject =            	XPlane_Ramp_Equipment_directory .. "Stair_Maint_1.obj"

-- GPU -------------------------------------------------------------------------
---User_Custom_Prefilled_GPUObject =				MisterX_Lib   .. "GPUs/Generic.obj"
User_Custom_Prefilled_GPUObject = 					MisterX_Lib   .. "GPUs/Generictld.obj"
User_Custom_Prefilled_GA_GPUObject = 				XPlane_Ramp_Equipment_directory   .. "GPU_2.obj"
User_Custom_Prefilled_MilGPUObject = 				MisterX_Lib   .. "GPUs/Mil_GPU.obj"
User_Custom_Prefilled_ASUObject = 					XPlane_Ramp_Equipment_directory   .. "Air_Start_2.obj"

-- CATERING --------------------------------------------------------------------
User_Custom_Prefilled_CateringObject			= 	MisterX_Lib   .. "Catering/Catering_low_part.obj"
User_Custom_Prefilled_CateringHighPartObject 	= 	MisterX_Lib   .. "Catering/Catering_high_part.obj"
User_Custom_Prefilled_CateringHighPart_GG_Object = 	MisterX_Lib   .. "Catering/Catering_high_part_GateGourmet.obj"
User_Custom_Prefilled_CateringHighPart_NR_Object = 	MisterX_Lib   .. "Catering/Catering_high_part_Newrest.obj"
User_Custom_Prefilled_CateringHighPart_MI_Object = 	MisterX_Lib   .. "Catering/Catering_high_part_Minoan.obj"
User_Custom_Prefilled_AlternativeCateringObject = 	MisterX_Lib   .. "Catering/Van_Catering.obj"

-- REAR LEFT TRUCK -------------------------------------------------------------
User_Custom_Prefilled_CleaningTruckObject = 		MisterX_Lib   .. "Cleaning/Van_White.obj"

-- CARGO HOLD BELT LOADER -----------------------------------------------------------
User_Custom_Prefilled_BeltLoaderObject = 			MisterX_Lib   .. "BeltLoader/Generic.obj"

-- BAGGAGE CARTS TRAIN ------------------------------------------------------
User_Custom_Prefilled_2BaggageTrainObject = 		MisterX_Lib   .. "BeltLoader/Bagage_Train_2.obj"
User_Custom_Prefilled_5BaggageTrainObject = 		MisterX_Lib   .. "BeltLoader/Bagage_Train_5.obj"

-- CARGO FREIGHTER ULD TRAIN ------------------------------------------------------
User_Custom_Prefilled_ULDTrainObject = 				MisterX_Lib   .. "ULDLoader/ULD_AAD_Train.obj"

-- CARGO FREIGHTER LOADER ------------------------------------------------------
User_Custom_Prefilled_ULDLoaderObject = 			MisterX_Lib   .. "ULDLoader/Generic.obj"
-- replaced by SGES when X-Plane 12.1 minimum is detected

-- FOLLOW ME VEHICLE -----------------------------------------------------------
User_Custom_Prefilled_FMObject = 					MisterX_Lib   .. "FollowMe/FollowMe_passat_grey_blue.obj"
User_Custom_Prefilled_FMObject_2 = 					MisterX_Lib   .. "FollowMe/FollowMe_passat_blue.obj"
User_Custom_Prefilled_FMObject_3 = 					MisterX_Lib   .. "FollowMe/FollowMe_passat_grey_blue.obj"

-- PEOPLE WITH REDUCED MOBILITY CAR --------------------------------------------
User_Custom_Prefilled_PRM_carObject =				MisterX_Lib   .. "PRM/PRM_passat_white.obj"

-- FIRE DEP VEHICLE ------------------------------------------------------------
User_Custom_Prefilled_FireObject 			= 		MisterX_Lib   .. "Fire/Yellow_1.obj"
User_Custom_Prefilled_WaterSaluteObject 	= 		MisterX_Lib   .. "Fire/Yellow_1_watersalute.obj"
User_Custom_Prefilled_AlternativeFireObject = 		MisterX_Lib   .. "Fire/Firetruck_blue.obj"

-- AIRPORT PEOPLE --------------------------------------------------------------
User_Custom_Prefilled_PeopleObject4 = 				MisterX_Lib   .. "People/Pilot_2.obj"
--User_Custom_Prefilled_PeopleObject3 = 			MisterX_Lib   .. "People/Airport_Worker_1_Broom_anim.obj" -- cleaner before 04/24
User_Custom_Prefilled_PeopleObject3 = 				MisterX_Lib   .. "People/Airport_Worker_4.obj" -- Yellow cleaner April 24
User_Custom_Prefilled_PeopleObject2 = 				MisterX_Lib   .. "People/Airport_Worker_3.obj"
User_Custom_Prefilled_PeopleObject1 = 				MisterX_Lib   .. "People/Airport_Worker_1_Ear_Muffs.obj" -- aircraft master
User_Custom_Prefilled_PeopleObject5 = 				MisterX_Lib   .. "People/Airport_Driver.obj" -- for push-back tug driver
User_Custom_Prefilled_PeopleObject6 = 				MisterX_Lib   .. "People/Airport_Driver_anim2.obj" -- Airport worker, yellow, animated, April 2024

-- PASSENGERS ------------------------------------------------------------------
User_Custom_Prefilled_PassengerMilObject = 			MisterX_Lib   .. "Passengers/Man_Military_1.obj"
User_Custom_Prefilled_Passenger1Object = 			MisterX_Lib   .. "Passengers/Man_Shirt_1_anim2.obj"
User_Custom_Prefilled_Passenger2Object = 			MisterX_Lib   .. "Passengers/Woman_4_anim2.obj"
User_Custom_Prefilled_Passenger3Object = 			MisterX_Lib   .. "Passengers/Man_Shirt_2_anim2.obj"
User_Custom_Prefilled_Passenger4Object = 			MisterX_Lib   .. "Passengers/Man_Suit_1_anim2.obj"
User_Custom_Prefilled_Passenger5Object = 			MisterX_Lib   .. "Passengers/Man_Jacket_1_anim2.obj"
User_Custom_Prefilled_Passenger6Object = 			MisterX_Lib   .. "Passengers/Woman_5_anim2.obj"
User_Custom_Prefilled_Passenger7Object = 			MisterX_Lib   .. "Passengers/Man_Suit_2_anim2.obj"
User_Custom_Prefilled_Passenger8Object = 			MisterX_Lib   .. "Passengers/Woman_6_anim2.obj"
User_Custom_Prefilled_Passenger13Object = 			MisterX_Lib   .. "Passengers/Man_Jacket_2_anim2.obj"
User_Custom_Prefilled_Passenger14Object = 			MisterX_Lib   .. "Passengers/Man_Jacket_3_anim2.obj"

-- SHIPS AT SEA -----------------------------------------------------------
User_Custom_Prefilled_SubmarineObject = 			MisterX_Lib   .. "Ships/Akula1.obj"
User_Custom_Prefilled_SmallShipObject = 			MisterX_Lib   .. "Ships/Fishing_Boat_1.obj"
User_Custom_Prefilled_LargeShipObject = 			MisterX_Lib   .. "Ships/Sentosa_Leader.obj"

-- CANOE -----------------------------------------------------------------------
User_Custom_Prefilled_CanoeObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Canot_painted.obj"

-- SURFACE TO AIR SITE ---------------------------------------------------------
SAM_object_1	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_AAA.obj" -- active SAM vehicle (selecting another vehicle kills the SAM site)
SAM_object_2	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_Camo.obj" -- support for SAM vehicle
SAM_object_3 	= 	SCRIPT_DIRECTORY    .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_radar.obj"	 -- mimics search radar


-- IN FLIGHT REFUELING OBJECT --------------------------------------------------
Prefilled_AAR_object =  SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/In_flight_refueler/Refueler.obj"
--Prefilled_AAR_object = SCRIPT_DIRECTORY   .. "../../../../Aircraft/Military Jets/XP12-VSL Test-Pilot SR-71-TB AU v1.0/objects/VSL-M3T-KC135.obj" -- for instance






-- part below not for user modification



-- X-Plane objects light enhancements ------------------------------------------
-- not intended for user modification
      Van_light_addonObject = 					SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Van_X_Plane12_1_4_light_addon.obj"
      Van_light_turning_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Van_X_Plane12_1_4_light_addon_turning_lights.obj"
      Van_light_flashing_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Van_X_Plane12_1_4_light_addon_flashing_lights.obj"
   Pickup_light_addonObject = 					SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Pickup_X_Plane12_1_4_light_addon.obj"
   Pickup_light_flashing_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Pickup_X_Plane12_1_4_light_addon_flashing_lights.obj"
      SUV_light_addonObject = 					SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/SUV_X_Plane12_1_4_light_addon.obj"
      SUV_light_flashing_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/SUV_X_Plane12_1_4_light_addon_flashing_lights.obj"
Ambulance_light_turning_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Ambulance_X_Plane12_1_4_light_addon_turning_lights.obj"
Ambulance_light_flashing_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Ambulance_X_Plane12_1_4_light_addon_flashing_lights.obj"
    Cobus_light_turning_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Cobus_X_Plane12_1_4_light_addon_turning_lights.obj"
    Cobus_light_flashing_lights_addonObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Cobus_X_Plane12_1_4_light_addon_flashing_lights.obj"

--------------------------------------------------------------------------------
 -- Set path to object  ------------------- -- DEPRECATED do that only if not automatically  detected in game
 -- Set path to the folder of the X-Trident CH-47 Chinook (https://store.x-plane.org/CH47-D-Chinook_p_1428.html)
XTrident_Chinook_Directory = nil -- DEPRECATED do that only if not automatically detected in game
--XTrident_Chinook_Directory = SCRIPT_DIRECTORY ..  "../../../../Aircraft/Helicopters/CH47 v2.0 for x-plane 12.00+"
 -- Set path to object X-Trident Harrier (https://store.x-plane.org/Harrier-AV-8B_p_919.html) -- to display the Italian aircraft carrier
XTrident_NaveCavour_Object = nil -- DEPRECATED do that only if not automatically detected in game
--XTrident_NaveCavour_Object = SCRIPT_DIRECTORY ..  "../../../../Aircraft/AV-8B v2.0 for x-plane 11.50+/extra/Nave Cavour/Nimitz.obj"
-- External optional ships :
MekoFrigate_Object = nil -- path to Meko frigate by juanik0  https://forums.x-plane.org/index.php?/files/file/65422-ara-almirante-brown-d10-argentinian-meko-360-class-frigate
TarawaLHA1_Object = nil -- path to Tarawa by juanik0 	https://forums.x-plane.org/index.php?/files/file/68300-uss-tarawa-lha-1-amphibious-assault-carrier-ship
HMSEagle_Object = nil -- path to the HMS Eagle  by Alpeggio https://forums.x-plane.org/index.php?/files/file/66899-hms-eagle/
USSBlueback_Object = nil -- path to the SS-581 submarine by Alpeggio

-- TESTING AUTOMATICALLY THIRD PARTY OBJECTS -- DID YOU INSTALL THEM ? ----------
-- if you don't declare anything above, we try to test several locations for you automatically :
local function check_external_assets(path)
	local file = io.open(path, "r")
	if file ~= nil then io.close(file) print("[Ground Equipment " .. version_text_SGES .. "] External asset found : " .. string.sub(path,-75,-1)) return path	else	return nil	end
end
if MekoFrigate_Object == nil then MekoFrigate_Object = check_external_assets(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/ARA_AlteBrown/Resources/default scenery/sim objects/dynamic/Perry.obj" ) end
-- ||||||||||||||||| juanik0 USS Tarawa LHA-1 present ? (automatic attempt) ||||||
if TarawaLHA1_Object == nil then TarawaLHA1_Object = check_external_assets(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/juanik0_helodriver89_Tarawa/Nimitz.obj" ) end
-- ||||||||||||||||| X-Trident Nave Cavour present ? (automatic attempt) ||||||
if HMSEagle_Object == nil then HMSEagle_Object = check_external_assets(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/HMS Eagle/HMS Eagle.obj" ) end
-- ||||||||||||||||| Alpeggio USS Blueback (SS-581) present ? (automatic attempt) ||||||
if USSBlueback_Object == nil then USSBlueback_Object = check_external_assets(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/HMS Eagle/SS-581.obj" ) end
-- ||||||||||||||||| Back2TheBike Type 45 Destroyer - HMS Dragon present ? (automatic attempt) ||||||
if Type45Destroyer_Object == nil then Type45Destroyer_Object = check_external_assets(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/HMS_Dragon/Variant 1 - Basic obj/Type 45 hard deck.obj" ) end
--------------------------------------------------------------------------------
