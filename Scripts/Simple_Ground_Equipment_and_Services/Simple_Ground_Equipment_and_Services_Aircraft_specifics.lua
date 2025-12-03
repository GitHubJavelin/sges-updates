-- /////////////////////////////////////////// --
-- This script contains aircraft specific stuff.
-- This stuff is only triggered when a specific
-- aircraft type or X-Plane model is detected.
-- /////////////////////////////////////////// --

--
---- ////////////////////// A GENERIC set of instructions loaded at startup //////////////////

function prepare_special_vehicles_for_aircraft()
	if PLANE_ICAO == "B06"  then
			Prefilled_PushBack1Object = Prefilled_Mil_Van
	elseif PLANE_ICAO == "H125" or PLANE_ICAO == "BO-105" or PLANE_ICAO == "AS21" then
			Prefilled_PushBack1Object = Prefilled_PassengerMilObject
			Prefilled_BusObject_option2 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/crew_car.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
			Prefilled_BusObject_option1 = Prefilled_CleaningTruckObject
	--elseif PLANE_ICAO == "A3ST" or math.abs(BeltLoaderFwdPosition) <= 3  then Prefilled_PushBack1Object = XPlane_Ramp_Equipment_directory   .. "Luggage_Truck.obj" end
	elseif PLANE_ICAO == "A3ST" or math.abs(BeltLoaderFwdPosition) <= 4  then Prefilled_PushBack1Object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Tractor.obj"
	elseif PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then
		-- nothing, otherwise the position is so wrong
		Prefilled_PushBack1Object = Prefilled_LightObject
		Prefilled_PushBack1Object = Prefilled_PassengerMilObject
	end
	if PLANE_ICAO == "ALIA" or PLANE_ICAO == "LAMA" then
		Prefilled_PushBack1Object = Prefilled_CleaningTruckObject
		if IsXPlane12 then
			Prefilled_BusObject_option2 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Limo.obj"
			Prefilled_BusObject_option1 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		else
			Prefilled_BusObject_option2 = XPlane_objects_directory   .. "/limo/Limo.obj"

			Prefilled_BusObject_option1 = XPlane_objects_directory   .. "/limo/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		end
		--~ if PLANE_ICAO == "LAMA" and IsXPlane12 then
			--~ Prefilled_BusObject_option2 = SCRIPT_DIRECTORY .. "../../../default scenery/1000 roads/objects/cars/dynamic/police_car_var1.obj"
			--~ Prefilled_BusObject_option1 = SCRIPT_DIRECTORY .. "../../../default scenery/1000 roads/objects/cars/dynamic/police_car_var4.obj"
			--~ Prefilled_BusObject_option2 = Prefilled_Peugeot308_black_Object
			--~ Prefilled_BusObject_option1 = Prefilled_Peugeot308_black_Object
		--~ end
	end --easter egg



	-- when Business jet, then bring a car, not a bus :
	if PLANE_ICAO == "PC12" or PLANE_ICAO == "E55P" or PLANE_ICAO == "C525" or PLANE_ICAO == "C555" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E50P" or PLANE_ICAO == "EVIC" or PLANE_ICAO == "CL30" or PLANE_ICAO == "CL60" or PLANE_ICAO == "C55B" or PLANE_ICAO == "C56X" or string.match(PLANE_ICAO, "C25") or string.match(PLANE_ICAO, "LJ") or string.match(PLANE_ICAO, "C50") or string.match(PLANE_ICAO, "C51") or string.match(PLANE_ICAO, "C52") or string.match(PLANE_ICAO, "C55") or string.match(PLANE_ICAO, "C25") or string.match(PLANE_ICAO, "C56") or string.match(PLANE_ICAO, "C65") or string.match(PLANE_ICAO, "C68") or string.match(PLANE_ICAO, "C75") or string.match(PLANE_ICAO, "EA4") or string.match(PLANE_ICAO, "EA5") or string.match(PLANE_ICAO, "C750") or PLANE_ICAO == "AS21" or PLANE_ICAO == "KODI" or PLANE_ICAO == "C208" or string.match(PLANE_ICAO, "GLF") then
		-- that list should cover many aircraft from the org labelled as BUIZJETS
		Prefilled_BusObject_option1 = Prefilled_CleaningTruckObject
		if IsXPlane12 then
			Prefilled_BusObject_option2 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		else
			Prefilled_BusObject_option2 = XPlane_objects_directory   .. "/limo/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		end
		--Prefilled_CateringObject = Prefilled_AlternativeCateringObject
		Prefilled_CateringObject = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/crew_car.obj"
		--~ if IsXPlane1214 then
			--~ Prefilled_CateringObject = 	Dayonly_airsideops_SUV_yellow
		--~ end
		Prefilled_CateringHighPartObject = Prefilled_LightObject
		Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPartObject
		Prefilled_PRMHighPartObject = Prefilled_LightObject
		if PLANE_ICAO ~= "E19L"  then -- note : E19L (Lineage 1000) is a large, very large business jet
			Prefilled_BeltLoaderObject = XPlane_Ramp_Equipment_directory   .. "Towbar_1.obj"
			if IsXPlane1209 then
				Prefilled_BeltLoaderObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_10ft_1.obj"
			end
		end
		Transporting_Jetsetpeople = true
	end

	-- when Helicopter  then :
	if (SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) or PLANE_ICAO == "H125" or PLANE_ICAO == "BO-105" or PLANE_ICAO == "EC45" or PLANE_ICAO == "EC35" or PLANE_ICAO == "EC30" or PLANE_ICAO == "AS35" or PLANE_ICAO == "SA341" or PLANE_ICAO == "SA342" or PLANE_ICAO == "C172" or PLANE_ICAO == "S92" or IsSimcoders or PLANE_ICAO =="Alouette" then
		Prefilled_BusObject_option1 = Prefilled_FMObject
		if IsXPlane12 then
			Prefilled_BusObject_option2 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		else
			Prefilled_BusObject_option2 = XPlane_objects_directory   .. "/limo/Limo.obj"
			Dayonly_BusObject_option = Prefilled_BusObject_option2
		end
		--Prefilled_CateringObject = Prefilled_CleaningTruckObject
		Prefilled_CateringHighPartObject = Prefilled_LightObject
		Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPartObject
		Prefilled_PRMHighPartObject = Prefilled_LightObject
		Prefilled_BeltLoaderObject = Prefilled_CleaningTruckObject

		if UseXplane1214DefaultObject then
			get_hospital_ambulance = true
			Stored_CateringObject = Prefilled_PRM_carObject -- Important to reset !
		end
	end

	-- set Pax or Freight variant of the ground handling : --------------------
	if (string.find(AircraftPath ,"reight") or string.find(AircraftPath ,"argo"))
	or (string.find(AIRCRAFT_FILENAME,"Cargo") or string.find(AIRCRAFT_FILENAME,"Freight"))

	or string.find(AircraftPath ,"Chinese Spy Balloon")

	or (PLANE_ICAO == "A3ST" or PLANE_ICAO == "MD11" or PLANE_ICAO == "AN12" or PLANE_ICAO == "C130" or PLANE_ICAO == "L100" or (string.match(AIRCRAFT_PATH, "C-17") and not PLANE_ICAO == "C172" and not PLANE_ICAO == "C170") or (PLANE_ICAO == "C17" or PLANE_ICAO == "3383"))

	or (string.match(AircraftPath ,"146") and string.match(AircraftPath ,"3Q"))
	or (string.match(AircraftPath ,"146") and string.match(AircraftPath ,"2Q"))

	or (string.match(AircraftPath ,"321") and (string.find(AircraftPath ,"reight") or string.find(AircraftPath ,"argo") or string.find(AircraftPath ,"P2F") or string.find(AircraftPath ,"PCF") or string.find(AircraftPath ,"Titan") or string.find(AircraftPath ,"NAC") or string.find(AircraftPath ,"Fedex") or string.find(AircraftPath ,"UPS")))

	then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end

	if PLANE_ICAO == "CONC" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175" or PLANE_ICAO == "E190" or PLANE_ICAO == "E195" or PLANE_ICAO == "E19L" then
		IsPassengerPlane = 1
		GUIIsPassengerPlane = true
	end
	----------------------------------------------------------------------------

	-- when a 748F
	if PLANE_ICAO == "B742" or PLANE_ICAO == "B748" or PLANE_ICAO == "A3ST" then
		--~ Prefilled_ForkliftObject = 	SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/Generic.obj"-- force Mister X
		Prefilled_ForkliftObject = Prefilled_CargoDeck_ULDLoaderObject
	end

	-- Default Laminar chocks instead of SGES chocks for aircraft that use them natively after XP 12.2 :
	if IsXPlane1220 then
		if PLANE_ICAO == "UH60M" and string.find(SGES_Author,"melbo") then
			UseXplane1220Chocks = true
		end
	end

	-- When a military asset :
	-- and when the CH47D is installed and found, bring a hummer and the M978 HEMMET refueling truck
	-- when the CH47 D is not installed, bring Paul Mort Willys Jeep
	-- define the military status for some identified mil planes
	if PLANE_ICAO == "VULC" or PLANE_ICAO == "AV8B" or PLANE_ICAO == "F4" or PLANE_ICAO == "F5" or PLANE_ICAO == "F14" or PLANE_ICAO == "F15" or PLANE_ICAO == "F16" or PLANE_ICAO == "F18" or PLANE_ICAO == "F22" or PLANE_ICAO == "F35" or PLANE_ICAO == "F104" or PLANE_ICAO == "F119" or PLANE_ICAO == "F19" or PLANE_ICAO == "HAWK" or PLANE_ICAO == "M346"
	or PLANE_ICAO == "S92"
	or PLANE_ICAO == "ch47"
	or string.find(PLANE_ICAO,"UH60")
	or (string.find(SGES_Author,"Tom Kyler") and AIRCRAFT_FILENAME == "F-4.acf")
	or string.match(AIRCRAFT_PATH, "Tornado")
	or string.match(AIRCRAFT_PATH, "Buckeye")
	or (string.find(SGES_Author,"Alex Unruh") and AIRCRAFT_FILENAME == "F-14D.acf")
	or (string.find(SGES_Author,"Brault") and AIRCRAFT_FILENAME == "F104A.acf")
	or string.match(AIRCRAFT_PATH, "Military")
	then
		sges_military_default = 1
		GUImilitary_default_sges = true
		sges_military = 0
		milheight = 1
		GUImilitary_sges = false
		print("[Ground Equipment " .. version_text_SGES .. "] Switching to MILITARY assets.")
		BushObjectsToggle(sges_military_default)
		if XTrident_Chinook_Directory ~= nil and file_exists(SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj") then
			sges_military = 1
			milheight = 1.1
			sges_military_default = 0 -- destroy default military
			GUImilitary_sges = true
			GUImilitary_default_sges = false
			print("[Ground Equipment " .. version_text_SGES .. "] with assets from " .. XTrident_Chinook_Directory)
			BushObjectsToggle(sges_military)
		end
	end

	-- -- put two bus for long airliners and the concorde :
	if (SecondStairsFwdPosition <= -20.0 and SecondStairsFwdPosition ~= -30) or PLANE_ICAO == "CONC" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N" or PLANE_ICAO == "A20N" or string.match(AIRCRAFT_PATH, "C-17") or (PLANE_ICAO == "C17" or PLANE_ICAO == "3383") then
		--Prefilled_BusObject_option2 = Prefilled_BusObject_doublet
		Prefilled_BusObject_option1 = Prefilled_BusObject_doublet
	end

	if PLANE_ICAO == "SR71" then
		Prefilled_BusObject_option2 = SAM_object_2
		Prefilled_BusObject_option1 = SAM_object_2
	end

	if PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then
		Prefilled_StairsObject =            XPlane_objects_directory .. "../../1000 autogen/global_objects/constructions/ramp_2_100cm.obj"
		targetDoorX_alternate = 8.2 targetDoorZ_alternate = -11.7 targetDoorH_alternate = 160
	end

	-- /////////////////////////////////////////// --
	--# BUSH Planes
	if PLANE_ICAO == "KODI" or PLANE_ICAO == "DV20" or PLANE_ICAO == "C208" or PLANE_ICAO == "DH2T" or PLANE_ICAO == "DH3T" or string.match(PLANE_ICAO,"DH8A") or PLANE_ICAO == "DH8B" or PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" or PLANE_ICAO == "PC6P" or string.match(PLANE_ICAO,"BN2") or PLANE_ICAO == "C337" or PLANE_ICAO == "PA18" or (PLANE_ICAO == "C172" and string.find(SGES_Author,"Thranda")) or string.match(AIRCRAFT_PATH, "Do228") or PLANE_ICAO == "D328" or AIRCRAFT_FILENAME == "AW109SP.acf" or PLANE_ICAO == "BE33" or PLANE_ICAO == "Alouette" or PLANE_ICAO == "AS350" or PLANE_ICAO == "EC30" then
		SGES_BushMode = true
	else
		SGES_BushMode = false
	end

	print("[Ground Equipment " .. version_text_SGES .. "] Applied specific programmation for the aircraft type (if any).")
end

---- ////////////////////// End of GENERIC considerations //////////////////

-- /////////////////////////////////////////// --
-- Define some functions for the Zibo B738 or LevelUp 737NG Series
if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then

	function ZIBOToggleGPU()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6") -- ground services
			command_once("laminar/B738/tab/menu1") -- GPU icon
	end
	show_Zibo_Chocks = false
	function ZIBOToggleChocks()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6") -- ground services
			command_once("laminar/B738/tab/menu2") -- Chocks icon
	end
	function ZIBOToggleASU()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6") -- ground services
			command_once("laminar/B738/tab/menu4") -- ASU icon
	end
	function ZIBOToggleStairs()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6") -- ground services
			command_once("laminar/B738/tab/menu6") -- Stairs icon
	end
	function ZIBOToggleStairsOption()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/right") -- right
			command_once("laminar/B738/tab/menu1") -- Configure
			command_once("laminar/B738/tab/menu1") -- Configure
			command_once("laminar/B738/tab/menu1") -- Configure
			command_once("laminar/B738/tab/menu1") -- Configure
			command_once("laminar/B738/tab/line2") -- Airstairs
	end
	function ZIBOToggleServicesOption()
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/right") -- ground services
			command_once("laminar/B738/tab/menu1") -- Configure
			command_once("laminar/B738/tab/menu5") -- General config
			command_once("laminar/B738/tab/right") -- Right
			command_once("laminar/B738/tab/line5") -- Built-in GND SERV  ZIBO V4.03.08 Dec 2024
	end
	if XPLMFindDataRef("laminar/B738/fwd_stairs_hide") ~= nil and  XPLMFindDataRef("laminar/B738/aft_stairs_hide") ~= nil and XPLMFindDataRef("737u/doors/L1") ~= nil and XPLMFindDataRef("737u/doors/L2") ~= nil then

		sges_zibodoorhandling1 		= dataref_table("laminar/B738/fwd_stairs_hide")
		sges_zibodoorhandling2 		= dataref_table("laminar/B738/aft_stairs_hide")
		sges_zibodoorhandling3 		= dataref_table("737u/doors/L1")
		sges_zibodoorhandling4 		= dataref_table("737u/doors/L2")


		function sges_zibodoorhandling()
			-- if FWD door open and fwd_stairs_hide == 0 then print an alert ro remove the SGES stairs
			if sges_zibodoorhandling3[1] > 0 and sges_zibodoorhandling1[1] == 0 then
				show_StairsXPJ = false
				StairsXPJ_chg = true
			end

			-- if AFT door open and aft_stairs_hide == 0 then print an alert ro remove the SGES stairs
			if sges_zibodoorhandling4[1] > 0 and sges_zibodoorhandling2[1] == 0 then
				show_StairsXPJ2 = false
				StairsXPJ2_chg = true
			end

			if show_Bus and (sges_zibodoorhandling1[1] == 0 or sges_zibodoorhandling2[1] == 0) then
				show_Bus = false
				Bus_chg = true
			end
		end
		do_sometimes("sges_zibodoorhandling()")

	end
end
-- /////////////////////////////////////////// --



-- /////////////////////////////////////////// --
-- X-Trident AW 109 : remove the engine and pitot covers
if IsXPlane12 and SGES_IsHelicopter == 1 and AIRCRAFT_FILENAME == "AW109SP.acf" then
	-- avoid setting engine on fire by inadvertance
	set("aw109/anim/rbf/engine1_cover",0)
	set("aw109/anim/rbf/engine1_plug",0)
	set("aw109/anim/rbf/engine2_cover",0)
	set("aw109/anim/rbf/engine2_plug",0)
	-- I dont remove all remove before flight flags, just the ones relative to the engines.
end
-- I don't like having the cones for the X-Trident May 2024 A109.
if sges_gs_plane_y_agl[0] < 1 and
 (
    (AIRCRAFT_FILENAME == "AW109SP.acf" and PLANE_AUTHOR == "X-Trident")
 ) then
	show_Cones = false Cones_chg = true
	show_Chocks = true Chocks_chg = true
	print("[Ground Equipment " .. version_text_SGES .. "] Applying " .. PLANE_AUTHOR .. " " .. AIRCRAFT_FILENAME .. " startup (no cones, chocks set).")
end
-- /////////////////////////////////////////// --


-- /////////////////////////////////////////// --
-- Q4XP FlyJSim DH8D
if IsXPlane12 and AIRCRAFT_FILENAME == "Q4XP.acf" then
	print("[Ground Equipment " .. version_text_SGES .. "] Applying " .. PLANE_AUTHOR .. " " .. AIRCRAFT_FILENAME .. " startup specifics.")
	set_array("FJS/Q4XP/Manips/CockpitDoor_Anim",0,0)
	--~ set_array("FJS/Q4XP/Manips/JumpSeat_Anim",0,0)
end
-- /////////////////////////////////////////// --

-- /////////////////////////////////////////// --
-- Personnal variant of the PC-12
--~ if string.match(PLANE_ICAO,"PC12") and string.match(AIRCRAFT_FILENAME,"Thranda_PC12") and  XPLMFindDataRef("thranda/cockpit/animations/windowmanip") ~= nil then
	--~ set_array("thranda/cockpit/animations/windowmanip",23,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",24,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",25,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",26,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",27,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",28,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",29,1)
	--~ set_array("thranda/cockpit/animations/windowmanip",30,1)
	--~ print("[Ground Equipment " .. version_text_SGES .. "] Applying " .. PLANE_AUTHOR .. " " .. AIRCRAFT_FILENAME .. " startup (closing shades).")
--~ end
-- /////////////////////////////////////////// --

-- /////////////////////////////////////////// --
-- # Mirror fuel, and passenger car/bus position around the aircraft longitudinal axis.
-- Usually this should and shall be done in the aircraft configuraiton file or the user profile.
-- Demonstrator for the Diamond DA20
--~ if PLANE_ICAO == "DV20" then
	--~ SGES_mirror = 1
--~ end
-- /////////////////////////////////////////// --



-- /////////////////////////////////////////// --
-- Aircraft with a cargo hold on the left hand side
-- For instance, the Dash-8, the CRJ, the ERJ-140.
-- Do not touch if not necessary, many regional airliners
-- are already taken care of (outside of the code below).

if PLANE_ICAO == "E45X" -- EMBRAER	ERJ-145XR
or PLANE_ICAO == "E45Y" -- Replace E45Y by your new favourite aircraft code with the cargo hold on the port side -- See https://www.icao.int/publications/DOC8643/Pages/Search.aspx
then
	plane_has_cargo_hold_on_the_left_hand_side = true
	print("[Ground Equipment " .. version_text_SGES .. "] " .. PLANE_AUTHOR .. " " .. AIRCRAFT_FILENAME .. " : plane_has_cargo_hold_on_the_left_hand_side = true.")
end
-- /////////////////////////////////////////// --

if PLANE_ICAO == "CAML" or
   PLANE_ICAO == "DR1" or
   AIRCRAFT_FILENAME == "BE2c.acf" or
   AIRCRAFT_FILENAME == "Nieuport17.acf" or
   AIRCRAFT_FILENAME == "Red Tag SPAD S.XIII.acf" or
   AIRCRAFT_FILENAME == "Red Tag SPAD S.XIV Floats.acf"
   then
		print("[Ground Equipment " .. version_text_SGES .. "] Early XXth century aircraft.")

		set("sim/cockpit/weapons/guns_armed",1)
		-- Allows the Clairmarais aerodrome objects to be attributed to the Sopwith Camel by the Same author
		--https://store.x-plane.org/Sopwith-F1-Camel_p_2028.html
		--https://forums.x-plane.org/files/file/95289-clairmarais-aerodrome-wwi-historical-airport/
		Prefilled_PushBack1Object = Prefilled_PassengerMilObject
		Prefilled_PushBackObject = Prefilled_LightObject
		if IsXPlane12 then
			function Clairmarais_Aerodrome_lib()
				Clairmarais_Aerodrome_directory_prefill =          SCRIPT_DIRECTORY .. "../../../../Custom Scenery/Clairmarais_Aerodrome/Objects/" -- do not edit
				if  file_exists(Clairmarais_Aerodrome_directory_prefill   .. "Misc/Maintenance_objects/Step_Ladder.obj") then
					Clairmarais_Aerodrome_directory =          Clairmarais_Aerodrome_directory_prefill -- do not edit, acts as a trigger in the main.

					Prefilled_StairsObject =            Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Step_Ladder.obj"
					Prefilled_BusObject_option1 =       Clairmarais_Aerodrome_directory   .. "Vehicles/StaffCarDest.obj"
					Prefilled_BusObject_option2 =       Clairmarais_Aerodrome_directory   .. "Vehicles/StaffCar.obj"
					Prefilled_BusObject_doublet =       Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj"
					Dayonly_BusObject_option =  	    Clairmarais_Aerodrome_directory   .. "Vehicles/StaffCarDest.obj"
					Prefilled_FuelObject_option1 =      Clairmarais_Aerodrome_directory   .. "Vehicles/FuelTruck.obj"
					Prefilled_FuelObject_option2 =      Clairmarais_Aerodrome_directory   .. "Vehicles/FuelTruckDest.obj"
					Prefilled_StairsObject =            XPlane_Ramp_Equipment_directory .. "Stair_Maint_1.obj"
					Prefilled_GPUObject =               Clairmarais_Aerodrome_directory   .. "Vehicles/StarterTruckDest.obj"
					Prefilled_GA_GPUObject = 			Clairmarais_Aerodrome_directory   .. "Vehicles/StarterTruck.obj"
					Prefilled_CateringObject =          Clairmarais_Aerodrome_directory   .. "Vehicles/UtilityTruckDest.obj"
					Prefilled_CateringHighPartObject =	XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
					Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPartObject
					Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPartObject
					Prefilled_CleaningTruckObject =     Clairmarais_Aerodrome_directory   .. "Vehicles/UtilityTruck.obj"
					Prefilled_AlternativeCateringObject = Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Cart.obj"
					Prefilled_FMObject =                Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj"
					PRM_carObject = 					Clairmarais_Aerodrome_directory   .. "Vehicles/Truck_Ambulance.obj"
					Prefilled_BeltLoaderObject =        XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
					Prefilled_2CartObject =				Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj"-- baggage cart XP11
					Prefilled_5CartObject = 			Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj" -- baggage cart
					Prefilled_ULDLoaderObject = 		XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
					Prefilled_CargoDeck_ULDLoaderObject = Prefilled_ULDLoaderObject
					Prefilled_ULDTrainObject =			Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj"
					Prefilled_AlternativeBusObject =    Clairmarais_Aerodrome_directory   .. "Vehicles/UtilityTruck.obj"
					Prefilled_FireObject =              Clairmarais_Aerodrome_directory   .. "Vehicles/Truck_Ambulance.obj"
					Prefilled_AlternativeFireObject =   Clairmarais_Aerodrome_directory   .. "Vehicles/Truck_Ambulance.obj"
					Prefilled_ConeObject =     			Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Fuel_Drum.obj"
					Prefilled_BollardObject =     		Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Supplies.obj"
					Linked_cones =     					Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Fuel_Drum.obj"
					Prefilled_PeopleObject1 =           Clairmarais_Aerodrome_directory   .. "Figures/Standing_Pilot.obj"
					Prefilled_PeopleObject2 =           Clairmarais_Aerodrome_directory   .. "Figures/Mech_Waiting01.obj"
					Prefilled_PeopleObject3 =           Clairmarais_Aerodrome_directory   .. "Figures/NCO.obj"
					Prefilled_PeopleObject3 =           Clairmarais_Aerodrome_directory   .. "Figures/woman4.obj"
					Prefilled_PeopleObject3 =           Clairmarais_Aerodrome_directory   .. "Figures/British_Officer.obj"
					Prefilled_PeopleObject4 =           Clairmarais_Aerodrome_directory   .. "Figures/Mech_Waiting03.obj"

					Chocks_91= 							Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Wheel_Chock.obj"
					Chocks_92= 							Clairmarais_Aerodrome_directory   .. "Misc/Maintenance_objects/Wheel_Chock.obj" gear1Z = -3.72  gear2Z = 0.54
				end
			end
			Clairmarais_Aerodrome_lib()
		end
end





if PLANE_ICAO == "AV8B" and AIRCRAFT_FILENAME == "AV8B.acf" and string.find(PLANE_AUTHOR,"X-ALBERTO") then
	--~ Radar limits for the X-Trident Harrier II
	--~ The scripts unlocks targets as they pass behind your AV8B. The real aircraft radar cannot
	--~ see behind the plane !
	--~ The scripts also limits the availability of the radar in AV8B Harrier II AN/APG-65 equipped
	--~ (“Harrier II Plus”), like the USMC or Italian Harriers II. The radar cannot be activated in the
	--~ X-Trident Night Attack variants (“AV-8B(NA)”) without a radar in the nose.

	print("[Ground Equipment " .. version_text_SGES .. "] X-Trident AV8B Harrier II : loading datarefs and limiting radar capabilities if any.")

	dataref("targetDist", "AV8/RADAR_target/dist_3d", "writable")
	dataref("targetIndex", "AV8/RADAR_target/index", "writable")

	dataref("HorizAngle", "AV8/RADAR_target/horizontal_angle_deg", "writable")
	dataref("VerticalAngle", "AV8/RADAR_target/vertical_angle_deg", "writable")

	dataref("MFD_RADAR_range", "AV8/MFD_RADAR_range", "writable")
	dataref("RadarButton", "AV8/cockpit/pedestal/rot_switch/radar", "writable")
	dataref("ScanRatio", "AV8/radar/scan_ratio", "writable")
	dataref("RadarOnHud", "AV8/radar/on_hud", "writable")

	dataref("INS", "AV8/cockpit/pedestal/rot_switch/ins", "readonly")

	-- to supress the radar when the Harrier is a british Gr9
	-- also suppress Nav if INS is OFF
	dataref("MFD_left_app", "AV8/MFD_left_app", "writable") -- radar = 3 AND 14  Nav = 4
	dataref("MFD_right_app", "AV8/MFD_right_app", "writable")
	dataref("MFD_center", "AV8/MFD_floating_app", "writable")
	dataref("AV8variantsbritish", "AV8/variants/short_nose", "readonly")
	local RadarChrono = os.clock() - 10 -- safety
	local HorizLimit = 100 -- degrees
	local VerticalLimit = 100 -- degrees
	local HA = 0
	local VA = 0
	RadarOnHud = 1 -- default now.

	function SGES_XTRIDENT_AV8_RadarLimits()

		-- suppress INS when INS not set
		if INS < 3 then
			if MFD_left_app == 4 then MFD_left_app = 0 end
			if MFD_right_app == 4 then MFD_right_app = 0 end
			if MFD_center == 4 then MFD_center = 0 end
		end
		-- to suppress the radar when the Harrier is a british Gr9
		if AV8variantsbritish == 1 then
			if (MFD_left_app == 3 or MFD_left_app == 14) then MFD_left_app = 0 end
			if (MFD_right_app == 3 or MFD_right_app == 14) then MFD_right_app = 0 end
			if (MFD_center == 3 or MFD_center == 14) then MFD_center = 0 end
			if RadarButton > 0 then
				RadarButton = 0
				print("[Ground Equipment " .. version_text_SGES .. "] Not an AV8B Harrier II with an AN/APG-65. It's a Night Attack variant (AV-8B(NA)).")
			elseif RadarButton == 0 then  MFD_RADAR_range = 0.01 ScanRatio = 2 targetIndex = 0 RadarChrono = os.clock() + 9999 end -- when radar is not on, we can't useit.
		else
			-- when you have a radar in the american variant AV8B
			if RadarButton == 0 and MFD_RADAR_range > 0 then  MFD_RADAR_range = 0.01 ScanRatio = 2 targetIndex = 0 RadarChrono = os.clock() + 9999 end -- when radar is not on, we can't useit.
			if RadarButton == 1 then  MFD_RADAR_range = 0.01 ScanRatio = 0 targetIndex = 0 RadarChrono = os.clock() --start spool up time
			elseif RadarButton == 2 and os.clock() < RadarChrono + 10 then  MFD_RADAR_range = 0.01 ScanRatio = 1 --start spool up time
			elseif RadarButton == 2 and os.clock() >= RadarChrono + 10 and MFD_RADAR_range < 4 then  MFD_RADAR_range = 32 RadarOnHud = 1 -- when radar is on, we restablish radar range
			elseif RadarButton == 3 and MFD_RADAR_range < 4 then  MFD_RADAR_range = 32 RadarOnHud = 1 RadarChrono = os.clock() - 10 end -- when radar is on, we restablish radar range
			if MFD_RADAR_range > 32 then MFD_RADAR_range = 40 -- we see at 80 nm max (double the value) -- this is the physical radar max range
			elseif MFD_RADAR_range < 32 and MFD_RADAR_range >= 20 then MFD_RADAR_range = 32 end -- RESET to initial range increment after going to non standard max range

			if RadarButton > 0 and targetIndex > 0 then -- When a target is selected
				--~ if targetDist > 600000 then
				if targetDist > 120000 then
					targetIndex = 0
					print("[Ground Equipment " .. version_text_SGES .. "] AV8B Harrier II AN/APG-65 radar lock range limit reached")
				end -- efficient radar range is 60 nm, beyond that, let's say you can't lock.
				HA = math.abs(HorizAngle)
				VA = math.abs(VerticalAngle)
				if HA > HorizLimit then
					targetIndex = 0
					HorizAngle = 0
					print("[Ground Equipment " .. version_text_SGES .. "] AV8B Harrier II AN/APG-65 radar horizontal limit reached")
				end
				if VA > VerticalLimit then
					targetIndex = 0
					VerticalAngle = 0
					print("[Ground Equipment " .. version_text_SGES .. "] AV8B Harrier II AN/APG-65 radar vertical limit reached")
				end
			end
			-- should also hide IFF
		end
	end
	do_every_frame("SGES_XTRIDENT_AV8_RadarLimits()")
	--~ do_often("SGES_XTRIDENT_AV8_RadarLimits()")
end


--------------------------------------------------------------------------------

		----------   FELIS BOEING 747-200 -------------


--------------------------------------------------------------------------------

if PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis") then

	--~ if B742ProcNumber == nil then	B742ProcNumber = -1 end
	if LuaJITForFelis then
		set("B742/anim/jit_off",1)
	end
	if SpeedyCopilotForFelis == nil then SpeedyCopilotForFelis = true end

	local crew_accent_used = ""

	local actions_BeforeStart = {
			function()
				if XPLMFindDataRef("B742/SND/crew_accent_used") ~= nil then
					crew_accent_used = get("B742/SND/crew_accent_used") -- actualize
				else
					crew_accent_used = "" -- the 742P doesn't have so far crew choice !
				end
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/checked.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Some sound files will not be loaded with the passenger variant of the B742.")
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				print("[Ground Equipment " .. version_text_SGES .. "]  Before Start Procedure " .. crew_accent_used)
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				set("B742/cockpit_light/FE_crkt_brk_main",1)
				set("B742/cockpit_light/FE_crkt_brk_ovhd",1)
				set("B742/cockpit_light/ovhd",0.3)
				set("B742/cockpit_light/dome",1)
			end,

			function()
				set("B742/cockpit_light/control_stand_panel",0.3)
				set("B742/cockpit_light/center_fwd_panel",0.3)
				set("B742/cockpit_light/FE_panel",0.3)
			end,

			function()
				set("B742/OVHD/stall_warn_sw",0)
				set("B742/OVHD/radio_master_bus_ESS_on",1)
				set("B742/OVHD/radio_master_bus_NO2_on",1)
			end,

			function()
				set("B742/ELEC/standby_power_sw",1)
			end,

			function()
				set("B742/ELEC/ESS_bus_sel",0)
				set("B742/ELEC/ESS_bus_sel",1)
				if XPLMFindDataRef("B742/FE/FWD_cargo_heat_sw") == nil  then -- is a freighter
					print("[Ground Equipment " .. version_text_SGES .. "] Close nose and side cargo doors")
					for i=3,4 do set_array("B742/anim/commanded_cargo_doors", i, -1) end
				end
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Mach warning test")
				set("B742/OVHD/mach_as_warn_test_sw",1)
			end,

			function()
				set("B742/OVHD/mach_as_warn_test_sw",0)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Over rotation warning test")
				set("B742/OVHD/overrot_test_sw",1)
			end,

			function()
				set("B742/OVHD/overrot_test_sw",0)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Stall warning test")
				set("B742/OVHD/stall_warn_sw",-1)
			end,

			function()
				set("B742/OVHD/stall_warn_sw",0)
			end,

			function()
				set("B742/ext_light/logo_sw",1)
				set("B742/cockpit_light/main_panel_bkgr",0.75)
			end,

			function()
				set("B742/cockpit_light/FE_panel_bkgrd",0.6)
				set("B742/cockpit_light/FE_panel_map",0.5)
				set("B742/cockpit_light/dome_on_off",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/cabinSigns.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Cabin Signs")
				set("B742/OVHD/no_smoking_button",1)
				set("B742/OVHD/fasten_belts",1)
				set("B742/OVHD/flt_dk_door_rel",1)
			end,

			function()
				set("B742/OVHD/emerg_lights_cap",1)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/hydraulics.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] HYD SYS 4 : Elec HYD Pump to provide brake pressure")
				set("B742/HYD/elec_pump_sys4_cap",1)
				set("B742/HYD/elec_pump_sys4_sw",1)
				print("[Ground Equipment " .. version_text_SGES .. "] HYD : engine driven pumps to OFF")
				for i=0,3 do set_array("B742/HYD/eng_pump_sw", i, 0) end -- engine driven pumps to OFF
				print("[Ground Equipment " .. version_text_SGES .. "] HYD : air driven pumps 1-3 to OFF")
				for i=1,3 do set_array("B742/HYD/air_pump_sw", i, 0) end -- air driven pumps to OFF
				set_array("B742/HYD/air_pump_sw",0,1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/APU.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] APU start")
				set("B742/APU/APU_start_sw",2)
			end,

			function()
				set("B742/APU/APU_start_sw",1)
			end,


			function()
				set("B742/OVHD/window_heat_sw_2L",1)
				set("B742/OVHD/window_heat_sw_2R",1)
				set("B742/OVHD/window_heat_sw_1L",1)
				set("B742/OVHD/window_heat_sw_1R",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/probeHeat.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] pitot heat")
				set("B742/OVHD/probe_heater_R",1)
				set("B742/OVHD/probe_heater_L",1)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] cargo heat on")
				if XPLMFindDataRef("B742/FE/AFT_cargo_heat_sw") ~= nil then set("B742/FE/AFT_cargo_heat_sw",1) end
				if XPLMFindDataRef("B742/FE/FWD_cargo_heat_sw") ~= nil then set("B742/FE/FWD_cargo_heat_sw",1) end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/fuel.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] fuel boost pumps on")
				for i=0,9 do set_array("B742/FUEL/fuel_boost_pump_sw", i, 1) end
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] crossfeed valves 1 & 4 open")
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",4,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",5,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",0,1)
			end,


			function()
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",3,1)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",1,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",2,0)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] radar")
				set("B742/radar/mode_sel",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/transponder.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] transponder TARA, Alt off at this point")
				set("B742/TCAS/main_mode_sel",1)
				set("B742/TCAS/alt_1_off_2",0) -- off
			end,
			function()
				for _,eng in ipairs({0,1,2,3}) do
					set_array("B742/OVHD/engine_ignition_sys_2", eng, 0)
					set_array("B742/OVHD/engine_ignition_sys_1", eng, 0)
				end
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] APU GEN CLOSE")
				set("B742/AUX_PWR/APU_GEN1_trip_sw",1)
				set("B742/AUX_PWR/APU_GEN2_trip_sw",1)
				set("B742/AUX_PWR/APU_GEN1_close_sw",1)
				set("B742/AUX_PWR/APU_GEN2_close_sw",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/APUbleedAirSwitch.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] APU BLEED")
				set("B742/APU/APU_bleed_air_sw",1)
			end,
			function()
				set("B742/AUX_PWR/APU_GEN1_trip_sw",0)
				set("B742/AUX_PWR/APU_GEN2_trip_sw",0)
				set("B742/AUX_PWR/APU_GEN2_close_sw",0)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/packValves.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Packvalves")
				set_array("B742/AIR_COND/pack_valves_rotary",0,0)
				set_array("B742/AIR_COND/pack_valves_rotary",2,0)
			end,

			function()
				set_array("B742/AIR_COND/pack_valves_rotary",1,1) -- On open (like seen in Felis checklist)
				--~ set_array("B742/AIR_COND/pack_valves_rotary",1,0) -- more logical to close all as seen in FCOM
				set("B742/AIR_COND/trim_air_sw",0)
			end,
			function()
				for i=0,3 do set_array("B742/AIR_COND/recilc_fan_zones_sw", i, 1) end
			end,


			function()
				print("[Ground Equipment " .. version_text_SGES .. "] BLEED open for starter operation")
				for i=0,3 do set_array("B742/AIR_COND/bleed_air_valves", i, 1) end
				set("B742/AIR_COND/mode_sel_rotary",1)
			end,



			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/GalleyPower.wav")
				set_array("B742/FE/galley_pwr_sw",2,0)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/off.wav")
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/exteriorLights.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] beacon")
				set("B742/ext_light/beacon_sw",1)
				set("B742/ext_light/NAV_sw",1)
				set("B742/ext_light/logo_sw",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/on.wav")
				if XPLMFindDataRef("B742/OVHD/auto_brake_takeoff_sw") ~= nil then  set("B742/OVHD/auto_brake_takeoff_sw",0) end
			end,

			function()
				set("B742/OVHD/body_gear_steer_cap",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/bodyGearSteering.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] body gear steering disarmed")
				set("B742/OVHD/body_gear_steer_sw",0)
			end,


			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Close doors")
				for i=0,2 do set_array("B742/anim/commanded_cargo_doors", i, 0) end
				set_array("B742/anim/commanded_pax_doors",0,0)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/beforeStartChecklist.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Ready for the before start checklist following the procedure.")
				collectgarbage()
			end
		}


	local actions_TO = {
			function()
				if XPLMFindDataRef("B742/SND/crew_accent_used") ~= nil then
					crew_accent_used = get("B742/SND/crew_accent_used") -- actualize
				else
					crew_accent_used = "" -- the 742P doesn't have so far crew choice !
				end
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/checked.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Some sound files will not be loaded with the passenger variant of the B742.")
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				print("[Ground Equipment " .. version_text_SGES .. "]  Before Takeoff Procedure " .. crew_accent_used)
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				set("B742/cockpit_light/FE_crkt_brk_main",1)
				set("B742/cockpit_light/FE_crkt_brk_ovhd",0.5)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLightsAndStrobes.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] strobe lights")
				set("B742/ext_light/strobe_sw",1)
				command_once("B742/menu/showHideEPRL")
			end,

			function()
				set("B742/cockpit_light/dome",0)
				set("B742/ext_light/logo_sw",1)
				set("B742/cockpit_light/main_panel_bkgr",0.2)
			end,

			function()
				set("B742/cockpit_light/FE_panel_bkgrd",0)
				set("B742/cockpit_light/FE_panel_map",1)
				set("B742/cockpit_light/dome_on_off",0)
			end,

			function()
				set("B742/OVHD/window_heat_sw_2L",1)
				set("B742/OVHD/window_heat_sw_2R",1)
				set("B742/OVHD/window_heat_sw_1L",1)
				set("B742/OVHD/window_heat_sw_1R",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/probeHeat.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] pitot heat")
				set("B742/OVHD/probe_heater_R",1)
				set("B742/OVHD/probe_heater_L",1)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] cargo heat on")
				if XPLMFindDataRef("B742/FE/AFT_cargo_heat_sw") ~= nil then set("B742/FE/AFT_cargo_heat_sw",1) end
				if XPLMFindDataRef("B742/FE/FWD_cargo_heat_sw") ~= nil then set("B742/FE/FWD_cargo_heat_sw",1) end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/fuel.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] fuel boost pumps off")
				for i=0,9 do set_array("B742/FUEL/fuel_boost_pump_sw", i, 1) end
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] crossfeed valves 1 & 4 open")
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",4,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",5,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",0,1)
			end,


			function()
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",3,1)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",1,0)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",2,0)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/radar.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] radar")
				set("B742/radar/mode_sel",2)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/transponder.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] transponder")
				set("B742/TCAS/main_mode_sel",1)
				set("B742/TCAS/alt_1_off_2",-1)
			end,


			function()
				SGES_B742_sound = nil
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/ignition.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] ignition FLT")

				math.randomseed(os.time())
				randomView = math.random()
				if randomView >= 0.50 then
					for _,eng in ipairs({0,1,2,3}) do
						set_array("B742/OVHD/engine_ignition_sys_2", eng, 0)
						set_array("B742/OVHD/engine_ignition_sys_1", eng, -1)
					end
				else
					for _,eng in ipairs({0,1,2,3}) do
						set_array("B742/OVHD/engine_ignition_sys_2", eng, -1)
						set_array("B742/OVHD/engine_ignition_sys_1", eng, 0)
					end
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/packValves.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Pack OFF")
				set_array("B742/AIR_COND/pack_valves_rotary",0,0)
				set_array("B742/AIR_COND/pack_valves_rotary",2,0)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/closed.wav")
				set_array("B742/AIR_COND/pack_valves_rotary",1,0)
				set("B742/AIR_COND/trim_air_sw",0)
			end,
			function()
				for i=0,3 do set_array("B742/AIR_COND/recilc_fan_zones_sw", i, 1) end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/GalleyPower.wav")
				set_array("B742/FE/galley_pwr_sw",2,0)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/off.wav")
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLights.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] landing_lights")
				set("B742/ext_light/landing_outbd_L_sw",1)
				set("B742/ext_light/landing_outbd_R_sw",1)
			end,

			function()
				set("B742/ext_light/landing_inbd_L_sw",1)
				set("B742/ext_light/landing_inbd_R_sw",1)
			end,

			function()
				set("B742/ext_light/runway_turnoff_L_sw",1)
				set("B742/ext_light/runway_turnoff_R_sw",1)
			end,



			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/on.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] auto brake switch for takeoff")
				if XPLMFindDataRef("B742/OVHD/auto_brake_takeoff_sw") ~= nil then  set("B742/OVHD/auto_brake_takeoff_sw",1) end
			end,

			function()
				set("B742/OVHD/body_gear_steer_cap",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/bodyGearSteering.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] body gear steering disarmed")
				set("B742/OVHD/body_gear_steer_sw",1)
			end,
			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/disarm.wav")
				set("B742/OVHD/body_gear_steer_cap",0)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/beforeTakeoffChecklist.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Ready for the before takeoff checklist following the procedure.")
				collectgarbage()
				B742ProcNumber = 3
				step_proc_742 = 1
			end
		}


	local actions_Accel = {

			function()
				if SGES_vvi_fpm_pilot[0] > 100 and sges_gs_ias_spd[0] >= 110 then
					print("[Ground Equipment " .. version_text_SGES .. "] In the climb segment...")
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				if XPLMFindDataRef("B742/SND/crew_accent_used") ~= nil then
					crew_accent_used = get("B742/SND/crew_accent_used") -- actualize
				else
					crew_accent_used = "" -- the 742P doesn't have so far crew choice !
				end
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/letSee.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Some sound files will not be loaded with the passenger variant of the B742.")
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				print("[Ground Equipment " .. version_text_SGES .. "]  Climb Procedure " .. crew_accent_used)
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Confirming that crossfeed valves 1 & 4 still open. All takeoff are made using main tanks to engine,fuel feed with 1 and 4 crossfeed valves open. Continue until fuel in tanks 1 and 4 is 21 000 LBS and then switch to center tank to all engines fuel feed if available, or main tanks 2 and 3 to all engines if the center tank is not available.")
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",0,1)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",3,1)
			end,


			function()
				if SGES_vvi_fpm_pilot[0] > 300 and sges_gs_ias_spd[0] >= 130 then
					set("B742/controls/gear_lever_pos",-1) -- UP
				print("[Ground Equipment " .. version_text_SGES .. "] Gear UP")
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				if get("sim/flightmodel/controls/flaprqst") > 0.5 then
					if SGES_vvi_fpm_pilot[0] > 500 and sges_gs_ias_spd[0] >= 165 then
						SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
						print("[Ground Equipment " .. version_text_SGES .. "] Flaps retract to 10")
						set("sim/flightmodel/controls/flaprqst",0.5) -- FLAPS 10 DEGREES
						--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
						--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
						--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
						--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
						--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
						--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
					else -- wait for the condition to realize, do not progress later
						step_proc_742 = step_proc_742 - 1
					end
				else
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps already at 10, skipping step.")
				end
			end,

			function()
				if SGES_vvi_fpm_pilot[0] > 100 and sges_gs_ias_spd[0] >= 185 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps retract to 5")
					set("sim/flightmodel/controls/flaprqst",0.33) -- FLAPS 5 DEGREES
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/ignition.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] ignition OFF")

				for _,eng in ipairs({0,1,2,3}) do
					set_array("B742/OVHD/engine_ignition_sys_2", eng, 0)
					set_array("B742/OVHD/engine_ignition_sys_1", eng, 0)
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/APUbleedAirSwitch.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] APU BLEED")
				set("B742/APU/APU_bleed_air_sw",0)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] BLEED from engines")
				for i=0,3 do set_array("B742/AIR_COND/bleed_air_valves", i, 1) end
				set("B742/AIR_COND/mode_sel_rotary",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/packValves.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Pack ON")
				set_array("B742/AIR_COND/pack_valves_rotary",0,1)
				set_array("B742/AIR_COND/pack_valves_rotary",2,1)
			end,

			function()
				set_array("B742/AIR_COND/pack_valves_rotary",1,1)
				set("B742/AIR_COND/trim_air_sw",1)
			end,

			function()
				set("B742/APU/APU_start_sw",0)
			end,


			function()
				for i=0,3 do set_array("B742/AIR_COND/recilc_fan_zones_sw", i, 1) end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/GalleyPower.wav")
				set_array("B742/FE/galley_pwr_sw",2,1)
			end,

			function()
				if sges_gs_ias_spd[0] >= 205 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					set("sim/flightmodel/controls/flaprqst",0.16) -- FLAPS 1 DEGREES
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps retract to 1")
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				if sges_gs_ias_spd[0] >= 225 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					set("sim/flightmodel/controls/flaprqst",0) -- FLAPS 0 DEGREES
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps retract to UP position")
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLights.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] landing_lights OFF")
				set("B742/ext_light/landing_outbd_L_sw",0)
				set("B742/ext_light/landing_outbd_R_sw",0)
			end,

			function()
				set("B742/ext_light/landing_inbd_L_sw",0)
				set("B742/ext_light/landing_inbd_R_sw",0)
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/set.wav")
				set("B742/ext_light/runway_turnoff_L_sw",0)
				set("B742/ext_light/runway_turnoff_R_sw",0)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] GEAR lever to OFF")
				set("B742/controls/gear_lever_pos",0) -- OFF
			end,


			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/afterTakeoffChecklist.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Ready for the after takeoff checklist following the procedure.")
				SGES_B742_sound = nil
				collectgarbage()
			end
		}

	local actions_Descent = {

			function()
				if (SGES_vvi_fpm_pilot[0] < -600 or sges_gs_plane_y_agl[0] < 2000) and sges_gs_ias_spd[0] < 255 then
					--~ SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Below 250 knots IAS in descent in the Boeing 747-200")
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
					SGES_B742_sound = nil
				end
			end,

			function()
				if XPLMFindDataRef("B742/SND/crew_accent_used") ~= nil then
					crew_accent_used = get("B742/SND/crew_accent_used") -- actualize
				else
					crew_accent_used = "" -- the 742P doesn't have so far crew choice !
				end
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/letSee.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Some sound files will not be loaded with the passenger variant of the B742.")
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
				print("[Ground Equipment " .. version_text_SGES .. "]  Descent  and approach Procedure " .. crew_accent_used)
				print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLights.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] landing_lights ON")
				set("B742/ext_light/landing_outbd_L_sw",1)
				set("B742/ext_light/landing_outbd_R_sw",1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/set.wav")
				set("B742/ext_light/landing_inbd_L_sw",1)
				set("B742/ext_light/landing_inbd_R_sw",1)
				set("B742/cockpit_light/FE_panel_bkgrd",0.15)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/cabinSigns.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Cabin Signs")
				set("B742/OVHD/no_smoking_button",1)
				set("B742/OVHD/fasten_belts",1)
				set("B742/OVHD/flt_dk_door_rel",1)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Reserve tank valves open")
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",4,1)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",5,1)
			end,

			function()
				print("[Ground Equipment " .. version_text_SGES .. "] Confirming that crossfeed valves 1 & 4 still open. All takeoff are made using main tanks to engine,fuel feed with 1 and 4 crossfeed valves open. Continue until fuel in tanks 1 and 4 is 21 000 LBS and then switch to center tank to all engines fuel feed if available, or main tanks 2 and 3 to all engines if the center tank is not available.")
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",0,1)
				set_array("B742/FUEL/fuel_crossfeed_valve_rot",3,1)
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/ignition.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Ignition ON")
				for _,eng in ipairs({0,1,2,3}) do
					set_array("B742/OVHD/engine_ignition_sys_2", eng, -1)
					set_array("B742/OVHD/engine_ignition_sys_1", eng, -1)
				end
			end,

			function()
				if sges_gs_ias_spd[0] <= 230 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					set("sim/flightmodel/controls/flaprqst",0.16) -- FLAPS 1 DEGREES
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 1")
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				if (SGES_vvi_fpm_pilot[0] < 100 or sges_gs_plane_y_agl[0] < 4000) and sges_gs_ias_spd[0] <= 220 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 5")
					set("sim/flightmodel/controls/flaprqst",0.33) -- FLAPS 5 DEGREES
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,


			function()
				if sges_gs_ias_spd[0] <= 200 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 10")
					set("sim/flightmodel/controls/flaprqst",0.5) -- FLAPS 10 DEGREES
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,



			function()
				if sges_gs_ias_spd[0] < 189 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 20")
					set("sim/flightmodel/controls/flaprqst",0.66) -- FLAPS 20 DEGREES
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,



			function()
				if SGES_vvi_fpm_pilot[0] < -10 and sges_gs_ias_spd[0] < 160 then
					set("B742/controls/gear_lever_pos",1) -- DOWN
					print("[Ground Equipment " .. version_text_SGES .. "] Gear Down")
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/packValves.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Pack AUTO")
				set_array("B742/AIR_COND/pack_valves_rotary",0,1)
				set_array("B742/AIR_COND/pack_valves_rotary",2,1)
				set("B742/ext_light/runway_turnoff_L_sw",1)
			end,

			function()
				set_array("B742/AIR_COND/pack_valves_rotary",1,1)
				set("B742/AIR_COND/trim_air_sw",1)
				set("B742/ext_light/runway_turnoff_R_sw",1)
			end,

			function()
				set("B742/APU/APU_start_sw",1)
			end,

			function()
				if SGES_vvi_fpm_pilot[0] <= -100 and sges_gs_ias_spd[0] < 157 then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/checked.wav")
					print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 25")
					set("sim/flightmodel/controls/flaprqst",0.83) -- FLAPS 10 DEGREES
					--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
					--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
					--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
					--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
					--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
					--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/flaps30.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Flaps deploy to 30 perhaps ?")
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/ohWait.wav")
			end,

			function()
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/beforeLandingChecklist.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] Ready for the Before Landing checklist following the procedure.")
				SGES_B742_sound = nil
				collectgarbage()
			end,


			function()
				if sges_gs_ias_spd[0] < 80 then
					B742ProcNumber = 2 -- arm after landing procedure
					step_proc_742 = 1
				else -- wait for the condition to realize, do not progress later
					step_proc_742 = step_proc_742 - 1
				end
			end
		}


	local actions_vacating = {
		function()
			if XPLMFindDataRef("B742/SND/crew_accent_used") ~= nil then
				crew_accent_used = get("B742/SND/crew_accent_used") -- actualize
			else
				crew_accent_used = "" -- the 742P doesn't have so far crew choice !
			end
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/checked.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] Some sound files will not be loaded with the passenger variant of the B742.")
			print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
			print("[Ground Equipment " .. version_text_SGES .. "]  After Landing Procedure " .. crew_accent_used)
			print("[Ground Equipment " .. version_text_SGES .. "] ==============================")
			set("B742/cockpit_light/ovhd_noname",0.25)
			set("B742/cockpit_light/main_panel_bkgr",0.9)
		end,

		function()
			if math.abs(sges_gs_gnd_spd[0]) < 40 then
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/bodyGearSteering.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] body gear steering armed")
				set("B742/OVHD/body_gear_steer_cap",1)
				set("B742/OVHD/body_gear_steer_sw",0)
			else
				step_proc_742 = step_proc_742 - 1
			end
		end,


		function()
			if math.abs(sges_gs_gnd_spd[0]) <= 15 then
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/speedbrakes.wav")
				print("[Ground Equipment " .. version_text_SGES .. "] speed brake handle")
				set("B742/controls/spd_brake_lever",0)
			else
				step_proc_742 = step_proc_742 - 1
			end
		end,

		function()
			if math.abs(sges_gs_gnd_spd[0]) <= 10 then
				set("sim/flightmodel/controls/flaprqst",0.5)
				--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
				--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
				--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
				--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
				--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
				--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
			else
				step_proc_742 = step_proc_742 - 1
			end
		end,

		function()
			set("sim/flightmodel/controls/flaprqst",0.33)
			--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
			--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
			--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
			--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
			--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
			--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Flaps retraction after landing")
			--~ set("sim/flightmodel/controls/flaprqst",0)
			--~ sim/flightmodel/controls/flaprqst = 0.16 <=> FLAPS 1
			--~ sim/flightmodel/controls/flaprqst = 0.33 <=> FLAPS 5
			--~ sim/flightmodel/controls/flaprqst = 0.5  <=> FLAPS 10
			--~ sim/flightmodel/controls/flaprqst = 0.66 <=> FLAPS 20
			--~ sim/flightmodel/controls/flaprqst = 0.83 <=> FLAPS 25
			--~ sim/flightmodel/controls/flaprqst = 1    <=> FLAPS 30
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] auto brake switch off")
			set("B742/OVHD/auto_brake_sel",0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLights.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] landing_lights")
			set("B742/ext_light/landing_outbd_L_sw",0)
			set("B742/ext_light/landing_outbd_R_sw",0)
		end,

		function()
			if SGES_local_time_in_simulator_hours[0] > 8 and SGES_local_time_in_simulator_hours[0] < 18 then set("B742/ext_light/landing_inbd_L_sw",0) end
			set("B742/ext_light/landing_inbd_R_sw",0)
		end,

		function()
			set("B742/ext_light/runway_turnoff_L_sw",1)
			set("B742/ext_light/runway_turnoff_R_sw",1)
			set("B742/ext_light/logo_sw",1)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Retracting flaps (UP)")
			set("sim/cockpit2/controls/flap_handle_request_ratio",0)
		end,


		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Waiting (1/1)")
		end,


		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Waiting (2/2)")
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/radar.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] radar")
			set("B742/radar/mode_sel",0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/transponder.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] transponder")
			set("B742/TCAS/main_mode_sel",1)
			set("B742/TCAS/alt_1_off_2",0)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] stab trim 3 units")
			set("B742/controls/elev_trim_lever_both",0.8)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/set.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] ignition off")
			for _,eng in ipairs({0,1,2,3}) do
				set_array("B742/OVHD/engine_ignition_sys_2", eng, 0)
				set_array("B742/OVHD/engine_ignition_sys_1", eng, 0)
			end
			set("B742/OVHD/stby_ignition_sel",0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/windowHeat.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] window heat")
			set("B742/OVHD/window_heat_sw_2L",0)
			set("B742/OVHD/window_heat_sw_2R",0)
			set("B742/OVHD/window_heat_sw_1L",0)
			set("B742/OVHD/window_heat_sw_1R",0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/COP/probeHeat.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] pitot heat")
			set("B742/OVHD/probe_heater_R",0)
			set("B742/OVHD/probe_heater_L",0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/outflowValves.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] outflow valve open?")
			set("B742/AIR_COND/outflow_valve_sw_L",1)
			set("B742/AIR_COND/outflow_valve_sw_R",1)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] cargo heat off")
			if XPLMFindDataRef("B742/FE/AFT_cargo_heat_sw") ~= nil then set("B742/FE/AFT_cargo_heat_sw",0) end
			if XPLMFindDataRef("B742/FE/FWD_cargo_heat_sw") ~= nil then set("B742/FE/FWD_cargo_heat_sw",0) end
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/fuel.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] fuel boost pumps off")
			for i=0,9 do set_array("B742/FUEL/fuel_boost_pump_sw", i, 0) end
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] reserve tank valves closed")
			set_array("B742/FUEL/fuel_crossfeed_valve_rot",4,0)
			set_array("B742/FUEL/fuel_crossfeed_valve_rot",5,0)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/APU.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] APU start")
			set("B742/APU/APU_start_sw",2)
		end,

		function()
			set("B742/APU/APU_start_sw",1)
		end,


		function()
			print("[Ground Equipment " .. version_text_SGES .. "] APU GEN CLOSE")
			set("B742/AUX_PWR/APU_GEN1_trip_sw",1)
			set("B742/AUX_PWR/APU_GEN2_trip_sw",1)
			set("B742/AUX_PWR/APU_GEN1_close_sw",1)
			set("B742/AUX_PWR/APU_GEN2_close_sw",1)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/APUbleedAirSwitch.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] APU BLEED")
			set("B742/APU/APU_bleed_air_sw",1)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/landingLightsAndStrobes.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] strobe lights")
			set("B742/ext_light/strobe_sw",0)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] (relaxing spring switches)")
			set("B742/AIR_COND/outflow_valve_sw_L",0)
			set("B742/AIR_COND/outflow_valve_sw_R",0)
		end,

		function()
			set("B742/AUX_PWR/APU_GEN1_trip_sw",0)
			set("B742/AUX_PWR/APU_GEN2_trip_sw",0)
			set("B742/AUX_PWR/APU_GEN2_close_sw",0)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Waiting (1/3)")
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Waiting (2/3)")
			set("B742/cockpit_light/ovhd_noname",1)
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Waiting (3/3) - reduce ground speed to continue.")
			set("B742/cockpit_light/FE_panel_bkgrd",0.75)
		end,

		function()
			if math.abs(sges_gs_gnd_spd[0]) <= 7 then
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/cutoff.wav")
			else
				step_proc_742 = step_proc_742 - 1
			end
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/num3.wav")
		end,

		function()
			if sges_EngineState[2] < 40 and math.abs(sges_gs_gnd_spd[0]) <= 7 then
				SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/shutdown.wav")
				if XPLMFindDataRef("B742/OVHD/auto_brake_takeoff_sw") == nil then
					SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/off.wav")
				end
			else
				step_proc_742 = step_proc_742 - 1
			end
		end,

		function()
			print("[Ground Equipment " .. version_text_SGES .. "] Eng 3 shutdown")
			set("B742/controls/fuel_cut_off_pos_3",0)
		end,

		function()
			set("B742/cockpit_light/dome",0.95)
		end,

		function()
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/FE/GalleyPower.wav")
			set_array("B742/FE/galley_pwr_sw",2,0)
		end,

		function()
			SGES_B742_sound = nil
			SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/" .. crew_accent_used .. "/CPT/afterLandingChecklist.wav")
			print("[Ground Equipment " .. version_text_SGES .. "] Ready for the after landing checklist following the procedure.")
			set("B742/cockpit_light/dome_on_off",1)
			collectgarbage()
		end
	}
	-------------------------------------------------
	-- MOTEUR DE SÉQUENCE (1 action/ n secondes)
	-------------------------------------------------
	--~ B742ProcNumber = -1
	local last_time = os.clock()

	function B742_Procedure_sequence(i)
		local now = os.clock()
		if now - last_time < 3 then return end  -- attendre n secondes
		last_time = now

		if  i == 0 and step_proc_742 > #actions_BeforeStart or
			i == 1 and step_proc_742 > #actions_TO    or
			i == 2 and step_proc_742 > #actions_vacating or
			i == 3 and step_proc_742 > #actions_Accel or
			i == 4 and step_proc_742 > #actions_Descent
		then
			step_proc_742 = 99
			return
		end
		--~ print("B742_Procedure_sequence " .. i)

		if     i == 0 then
			actions_BeforeStart[step_proc_742]()  -- exécuter l'étape
		elseif i == 1 then
			actions_TO[step_proc_742]()  -- exécuter l'étape
		elseif i == 2 then
			actions_vacating[step_proc_742]()  -- exécuter l'étape
		elseif i == 3 then
			actions_Accel[step_proc_742]()  -- exécuter l'étape
		elseif i == 4 then
			actions_Descent[step_proc_742]()  -- exécuter l'étape
		end

		if SGES_B742_sound ~= nil then
			set_sound_gain(SGES_B742_sound, 1)
			play_sound(SGES_B742_sound)
			SGES_B742_sound = nil
		end
		step_proc_742 = step_proc_742 + 1
	end

	function B742_Drive_Procedure_sequence(proc)
		if step_proc_742 == nil then step_proc_742 = 99  end
		if step_proc_742 >= 0    and step_proc_742 ~= 99 then
			--~ print("B742_Drive_Procedure_sequence")
			B742_Procedure_sequence(proc)
			--~ print("proc " .. proc)
		end
	end

	do_often("if B742ProcNumber ~= nil and SGES_XPlaneIsPaused == 0 and SpeedyCopilotForFelis ~= nil and SpeedyCopilotForFelis then B742_Drive_Procedure_sequence(B742ProcNumber) end")


	function B742_monitor_sequence()
		-- auto-monitor the need of the descent and approach procedure
		if (SGES_vvi_fpm_pilot[0] < -950 or sges_gs_plane_y_agl[0] < 2000) and sges_gs_ias_spd[0] < 260 and (B742ProcNumber == nil or B742ProcNumber ~= 4) then
			print("[Ground Equipment " .. version_text_SGES .. "] Passing the gate for the descent and approach procedure.")
			B742ProcNumber = 4
			step_proc_742 = 1
		end
	end

	do_sometimes("if SGES_XPlaneIsPaused == 0 and sges_gs_ias_spd[0] > 200 and SpeedyCopilotForFelis ~= nil and SpeedyCopilotForFelis then B742_monitor_sequence() end")
end

--~ print("[Ground Equipment " .. version_text_SGES .. "] PLAY SOUND.")
--~ SGES_B742_sound = load_WAV_file(AircraftPath .. "../../" .. "Custom Sounds/crew/US/FE/letSee.wav")
--~ set_sound_gain(SGES_B742_sound, 1)
--~ play_sound(SGES_B742_sound)
--~ SGES_B742_sound = nil
