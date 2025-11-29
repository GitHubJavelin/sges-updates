--------------------------------------------------------------------------------
-- ACTIVE SAM SITE (delivered with SGES 67, november 2023)
--------------------------------------------------------------------------------

--~ We used artistic licence to represent an imaginary low cost anti-aircraft site.
--~ Our imagination led us to compose the threat by short to medium range missiles complemented by
--~ an active search and tracking radar to help designate their target.
--~ While we depicted heat-seeking missile on their launcher, we elected to slave them to the radar
--~ station for initial target designation. Afterwards they can fly using their own sensor when reaching
--~ the vicinity of it.


print("[Ground Equipment " .. version_text_SGES .. "] Loading threat module from Simple Ground Equipment and Services")

Threat_module_loaded = true

local sges_admitted_circular_error = 20 -- to destroy the SAM site parts
local SGES_launching_time = 10000 * SGES_total_flight_time_sec
local SGES_locking_time = 10000 * SGES_total_flight_time_sec
shot_down_twice = false
shot_down = false
radar_has_us_locked_said = false
local shot_fired = 0
local max_shot_admissible = 3*4 -- typically the number of missiles available in short term for the battery
if ChaffNumber == nil then	ChaffNumber = dataref_table("sim/cockpit/weapons/chaff_now") end
if FlareNumber == nil then	FlareNumber = dataref_table("sim/cockpit/weapons/flare_now") end
local PreviousChaffNumber = ChaffNumber[0]
local PreviousFlareNumber = FlareNumber[0]

Radar_warning_missile_lock_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Radar_warning_missile_lock.wav") -- -- sound number 7
set_sound_gain(Radar_warning_missile_lock_sound, 0.3)
Radar_warning_tracking_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Radar_warning_tracking.wav") -- -- sound number 7
set_sound_gain(Radar_warning_tracking_sound, 0.3)
Hit_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Crash_big.wav") -- -- sound number 7
set_sound_gain(Hit_sound, 1)
CYAC_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Welcome_to_air_combat.wav") -- -- sound number 7
set_sound_gain(CYAC_sound, 1)
play_sound(CYAC_sound)
Trying_an_easier_mission_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Trying_an_easier_mission.wav") -- -- sound number 7
set_sound_gain(Trying_an_easier_mission_sound, 1)
Been_hit_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Been_hit.wav") -- -- sound number 7
set_sound_gain(Been_hit_sound, 1)
Hit_the_silk_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Hit_the_silk.wav") -- -- sound number 7
set_sound_gain(Hit_the_silk_sound, 1)
Radar_has_us_locked_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Radar_has_us_locked.wav") -- -- sound number 7
set_sound_gain(Radar_has_us_locked_sound, 1)
Break_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Break.wav") -- -- sound number 7
set_sound_gain(Break_sound, 1)
Chaff_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Chaff.wav") -- -- sound number 7
set_sound_gain(Chaff_sound, 1)
Victory_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Victory.wav") -- -- sound number 7
set_sound_gain(Victory_sound, 1)
Missed_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Missed.wav") -- -- sound number 7
set_sound_gain(Missed_sound, 1)
-----------------------------------
--DATAREFS
-----------------------------------
-- load the XPLM library
local ffi = require("ffi")

-- find the right lib to load
local XPLMlib = ""
if SYSTEM == "IBM" then
	-- Windows OS (no path and file extension needed)
	if SYSTEM_ARCHITECTURE == 64 then
			XPLMlib = "XPLM_64"  -- 64bit
	else
			XPLMlib = "XPLM"     -- 32bit
	end
elseif SYSTEM == "LIN" then
	-- Linux OS (we need the path "Resources/plugins/" here for some reason)
	if SYSTEM_ARCHITECTURE == 64 then
			XPLMlib = "Resources/plugins/XPLM_64.so"  -- 64bit
	else
			XPLMlib = "Resources/plugins/XPLM.so"     -- 32bit
	end
elseif SYSTEM == "APL" then
	-- Mac OS (we need the path "Resources/plugins/" here for some reason)
	XPLMlib = "Resources/plugins/XPLM.framework/XPLM" -- 64bit and 32 bit
else
	return -- this should not happen
end

-- load the lib and store in local variable
local XPLM = ffi.load(XPLMlib)


local StoredSamX = sges_gs_plane_x[0] + 30
local StoredSamY = sges_gs_plane_y[0]
local StoredSamZ = sges_gs_plane_z[0] - 30
local altiSam_y = sges_gs_plane_y_agl[0]


local sam_1_local_x = StoredSamX
local sam_1_local_z = StoredSamZ
local sam_2_local_x = StoredSamX
local sam_2_local_z = StoredSamZ
local sam_3_local_x = StoredSamX
local sam_3_local_z = StoredSamZ
local sam_4_local_x = StoredSamX
local sam_4_local_z = StoredSamZ
local sam_5_local_x = StoredSamX
local sam_5_local_z = StoredSamZ
local sam_6_local_x = StoredSamX
local sam_6_local_z = StoredSamZ

-- used arbitrary to store info about the object
local objpos_addr =  ffi.new("const XPLMDrawInfo_t*")
local objpos_value = ffi.new("XPLMDrawInfo_t[1]")

-- use arbitrary to store float value & addr of float value
local float_addr = ffi.new("const float*")
local float_value = ffi.new("float[1]")

-- meant for the probe
local probeinfo_addr =  ffi.new("XPLMProbeInfo_t*")
local probeinfo_value = ffi.new("XPLMProbeInfo_t[1]")

local SurfaceToAir_ref0 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref1 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref2 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref3 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref4 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref5 = ffi.new("XPLMObjectRef")            -- for the ground service
local SurfaceToAir_ref6 = ffi.new("XPLMObjectRef")            -- for the ground service

local Sam_instance = ffi.new("XPLMInstanceRef[7]")
-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")

-- to store in values of the local nature of the terrain (wet / land)
local terrain_nature = ffi.new("int[1]")

ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")
-----------------------------------
-- FIND SAM SITE LOCATION
-----------------------------------

function sges_Neareast_Airport()
		--if Idling_airport_index == "nil" then
			math.randomseed(os.time())
			randomWord = math.random()
			if randomWord > 0.10 then
				Idling_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
			else
				Idling_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_VOR)
			end

			-- let's examine the name of the airport we found, all variables should be local
			-- we do not waste Lua with variables to avoid conflicts with other scripts
			-- all output we are not interested in can be send to variable _ (a dummy variable)
			_, StoredSamX, StoredSamZ, outHeight, _, _, _, SamAirport = XPLMGetNavAidInfo( Idling_airport_index )
			StoredSamY = math.floor(outHeight*3.28084) -- meters to feet

			-- the last step is to create a global variable that function can read out end
			print(string.format("[Ground Equipment " .. version_text_SGES .. "] Expecting threat to airplanes at %s (%s ft)", SamAirport, StoredSamY))
			return SamAirport
		--end
end

-----------------------------------
-- STORE WEAPONS LOCATION
-----------------------------------

local weapon_index = 0
sges_weapon_x = dataref_table("sim/weapons/x")
sges_weapon_z = dataref_table("sim/weapons/z")
sges_weapon_fired = dataref_table("sim/weapons/action_mode")
-- 0 = In carriage/still in the gun/reloaded, 1 = firing, and 2 = destroyed
bombs_not_already_exploded = {bomb0=true,bomb1=true,bomb2=true,bomb3=true,bomb4=true,bomb5=true,bomb6=true,bomb7=true,bomb8=true,bomb9=true,bomb10=true,bomb11=true,bomb12=true,bomb13=true,bomb14=true,bomb15=true,bomb16=true,bomb17=true,bomb18=true,bomb19=true,bomb20=true,bomb21=true,bomb22=true,bomb23=true,bomb24=true,bomb25=true,bomb26=true,bomb27=true,bomb28=true,bomb29=true,bomb30=true,bomb31=true}

-----------------------------------
-- STATIC VEHICLES for the SAM
-----------------------------------

function load_Sam()
	if Sam_instance[0] == nil then
		if file_exists(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj") then
			SAM_object_4 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj"
			SAM_object_5 = SAM_object_4
			print("[Ground Equipment " .. version_text_SGES .. "] BTR-80 by Alpeggio : https://forums.x-plane.org/files/file/96027-btr-80-player-and-target-versions/")
		else
			SAM_object_4 = User_Custom_Prefilled_BusObject_military_small
			SAM_object_5 = SAM_object_2
		end
		if file_exists(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/M-48_A1.obj") then
			SAM_object_6 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/M-48_A1.obj"
			print("[Ground Equipment " .. version_text_SGES .. "] Battle tank by Alpeggio : https://forums.x-plane.org/files/file/96006-m-48a1-usa-main-battle-tank-1952/")
		else
			SAM_object_6 = SAM_object_1
		end

	   XPLM.XPLMLoadObjectAsync(SAM_object_1,
				function(inObject, inRefcon)
				Sam_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref0 = inObject
				end,
				inRefcon )

		math.randomseed(os.time())
		randomWord = math.random()
		--~ if randomWord > 0.5 then
		if randomWord >= 0.60 then
		   XPLM.XPLMLoadObjectAsync(SAM_object_1,
					function(inObject, inRefcon)
					Sam_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					SurfaceToAir_ref1 = inObject
					end,
					inRefcon )

		else -- Battle tank
		   max_shot_admissible = max_shot_admissible - 3
		   XPLM.XPLMLoadObjectAsync(SAM_object_6,
					function(inObject, inRefcon)
					Sam_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					SurfaceToAir_ref1 = inObject
					end,
					inRefcon )
		end

	   XPLM.XPLMLoadObjectAsync(SAM_object_1,
				function(inObject, inRefcon)
				Sam_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref2 = inObject
				end,
				inRefcon )
	   XPLM.XPLMLoadObjectAsync(SAM_object_2, -- van
				function(inObject, inRefcon)
				Sam_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref3 = inObject
				end,
				inRefcon )
	   XPLM.XPLMLoadObjectAsync(SAM_object_3, -- search radar
				function(inObject, inRefcon)
				Sam_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref4 = inObject
				end,
				inRefcon )
	   XPLM.XPLMLoadObjectAsync(SAM_object_4, -- passenger van or BTR-80
				function(inObject, inRefcon)
				Sam_instance[5] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref5 = inObject
				end,
				inRefcon )
	   XPLM.XPLMLoadObjectAsync(SAM_object_5, --  van or BTR-80
				function(inObject, inRefcon)
				Sam_instance[6] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				SurfaceToAir_ref6 = inObject
				end,
				inRefcon )
	end
end



function unload_SamObjects()
	print("[Ground Equipment " .. version_text_SGES .. "] Unloading threat module from Simple Ground Equipment and Services")
	if Sam_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[0]) end
	if Sam_instance[1] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[1]) end
	if Sam_instance[2] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[2]) end
	if Sam_instance[3] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[3]) end
	if Sam_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[4]) end
	if Sam_instance[5] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[5]) end
	if Sam_instance[6] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[6]) end
	if SurfaceToAir_ref0 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref0)  end
	if SurfaceToAir_ref1 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref1)  end
	if SurfaceToAir_ref2 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref2)  end
	if SurfaceToAir_ref3 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref3)  end
	if SurfaceToAir_ref4 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref4)  end
	if SurfaceToAir_ref5 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref5)  end
	if SurfaceToAir_ref6 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref6)  end
	Sam_instance[0] = nil
	Sam_instance[1] = nil
	Sam_instance[2] = nil
	Sam_instance[3] = nil
	Sam_instance[4] = nil
	Sam_instance[5] = nil
	Sam_instance[6] = nil
	SurfaceToAir_ref0 = nil
	SurfaceToAir_ref1 = nil
	SurfaceToAir_ref2 = nil
	SurfaceToAir_ref3 = nil
	SurfaceToAir_ref4 = nil
	SurfaceToAir_ref5 = nil
	SurfaceToAir_ref6 = nil
	Sam_chg = false
	sam_shifted_x = nil
	sam_shifted_z = nil
	for j=21,31 do --critical before bombs_not_already_exploded[]
		if IndustrialFire_instance[j] ~= nil and IndustrialFire_ref[j] ~= nil then
			print("[Ground Equipment " .. version_text_SGES .. "] Unloading smoke #" .. j .. ".")
			_,IndustrialFire_instance[j],IndustrialFire_ref[j] = common_unload("Fireball",IndustrialFire_instance[j],IndustrialFire_ref[j])
		end
	end
	bombs_not_already_exploded = {bomb0=true,bomb1=true,bomb2=true,bomb3=true,bomb4=true,bomb5=true,bomb6=true,bomb7=true,bomb8=true,bomb9=true,bomb10=true,bomb11=true,bomb12=true,bomb13=true,bomb14=true,bomb15=true,bomb16=true,bomb17=true,bomb18=true,bomb19=true,bomb20=true,bomb21=true,bomb22=true,bomb23=true,bomb24=true,bomb25=true,bomb26=true,bomb27=true,bomb28=true,bomb29=true,bomb30=true,bomb31=true}
end


--~ do_on_exit("unload_SamObjects()") -- put in main

function draw_Sam()
	if Sam_instance[0] ~= nil and Sam_instance[1] ~= nil and Sam_instance[2] ~= nil then

		sges_Neareast_Airport()

		print("[Ground Equipment " .. version_text_SGES .. "] Drawing static objects part of the SAM site " .. StoredSamX .. " ; " .. StoredSamZ)
		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX-0.001,StoredSamZ-0.001,0)
		altiSam_y,wetness = probe_y(sam_shifted_x, 0, sam_shifted_z)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] - 20
		objpos_value[0].pitch = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[0], objpos_addr, float_addr) end
		sam_0_local_x = objpos_value[0].x
		sam_0_local_z = objpos_value[0].z

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX+0.001,StoredSamZ-0.0012,0)
		altiSam_y,wetness = probe_y(sam_shifted_x, 0, sam_shifted_z)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] + 110
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[1], objpos_addr, float_addr)  end
		sam_1_local_x = objpos_value[0].x
		sam_1_local_z = objpos_value[0].z

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX-0.0013,StoredSamZ+0.001,0)
		altiSam_y,wetness = probe_y(sam_shifted_x, 0, sam_shifted_z)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] + 210
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[2], objpos_addr, float_addr)  end
		sam_2_local_x = objpos_value[0].x
		sam_2_local_z = objpos_value[0].z

		-- support vehicles

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX-0.0012,StoredSamZ-0.0012,0) -- van
		altiSam_y,wetness = probe_y(sam_shifted_x + 8, 0, sam_shifted_z + 8)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] - 24
		objpos_value[0].pitch = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[3], objpos_addr, float_addr) end
		sam_3_local_x = objpos_value[0].x
		sam_3_local_z = objpos_value[0].z

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX-0.00075,StoredSamZ+0.00075,0)  -- search radar
		altiSam_y,wetness = probe_y(sam_shifted_x, 0, sam_shifted_z)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = 0
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[4], objpos_addr, float_addr)  end
		sam_4_local_x = objpos_value[0].x
		sam_4_local_z = objpos_value[0].z

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX-0.0012,StoredSamZ+0.0013,0)
		altiSam_y,wetness = probe_y(sam_shifted_x + 8, 0, sam_shifted_z + 8)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] + 114
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[5], objpos_addr, float_addr)  end
		sam_5_local_x = objpos_value[0].x
		sam_5_local_z = objpos_value[0].z

		sam_shifted_x,_,sam_shifted_z = latlon_to_local(StoredSamX+0.0012,StoredSamZ-0.0011,0)
		altiSam_y,wetness = probe_y(sam_shifted_x + 2, 0, sam_shifted_z - 10)
		objpos_value[0].y = altiSam_y
		objpos_value[0].x = sam_shifted_x
		objpos_value[0].z = sam_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] + 214
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(Sam_instance[6], objpos_addr, float_addr)  end
		sam_6_local_x = objpos_value[0].x
		sam_6_local_z = objpos_value[0].z



		Sam_chg = false
	end
end

function trigger_fire()

	if sam_shifted_x ~= nil and randomShot ~= nil and SGES_locking_time ~= nil  and SGES_XPlaneIsPaused == 0  then
		if randomShot >= 0.8 and SGES_total_flight_time_sec > SGES_locking_time + 6 and shot_fired <= max_shot_admissible  then
			shot_fired = shot_fired + 1
			print("[Ground Equipment " .. version_text_SGES .. "] SAM is firing #" .. shot_fired .. ". This battery can fire " .. max_shot_admissible .. " times.")
			stop_sound(Radar_warning_tracking_sound)
			play_sound(Radar_warning_missile_lock_sound)
			play_sound(Break_sound)
			-- save the time of launching
			SGES_launching_time = SGES_total_flight_time_sec
			SGES_locking_time = 10000 * SGES_total_flight_time_sec
		end
	end

	-- WEAPON ATTACK ON SAM ------------------------------------------------
	-- I'll just use the same function for :
	-- check if a dropped weapon has reached a target, whith the ultimate goal to remove the target
	-- since x-plane stores the weapon coordinates even after it has died, then it's possible to check with a delay if the impact is successfull
	if SGES_XPlaneIsPaused == 0 and sges_gs_plane_y_agl[0] > 1 and sam_shifted_x ~= nil and sam_shifted_z ~= nil and show_Sam then
		for weapon_index=0,10 do

			--~ if sges_weapon_fired[weapon_index] == 2 and IndustrialFire_instance[weapon_index+21] ~= nil and bombs_not_already_exploded["bomb" .. weapon_index]
				--~ then
				--~ -- don't worry : it will not draw if the instance is not set :
				--~ print("[Ground Equipment " .. version_text_SGES .. "] " .. weapon_index)
				--~ draw_TargetFire(weapon_index+21,sges_weapon_x[weapon_index],sges_weapon_z[weapon_index])

			if sges_weapon_fired[weapon_index] >= 1 and bombs_not_already_exploded["bomb" .. weapon_index] then
				if SurfaceToAir_ref0 ~= nil and SurfaceToAir_ref4 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_0_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_0_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_0_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_0_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air launcher (0)." )
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 1-20 is for AI crash site, range 21-31 is for target destroyed
					if Sam_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[0]) end
					if SurfaceToAir_ref0 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref0)  end
					Sam_instance[0] = nil
					SurfaceToAir_ref0 = nil
					max_shot_admissible = max_shot_admissible - 4

					if Sam_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[4]) end
					if SurfaceToAir_ref4 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref4)  end
					Sam_instance[4] = nil
					SurfaceToAir_ref4 = nil
					--~ bombs_already_exploded["bomb" .. weapon_index] = true

				elseif  SurfaceToAir_ref4 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_4_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_4_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_4_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_4_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air pursuit radar (4)." )
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 1-20 is for AI crash site, range 21-31 is for target destroyed
					play_sound(Victory_sound)
					if Sam_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[0]) end
					if SurfaceToAir_ref0 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref0)  end
					Sam_instance[0] = nil
					SurfaceToAir_ref0 = nil

					if Sam_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[4]) end
					if SurfaceToAir_ref4 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref4)  end
					Sam_instance[4] = nil
					SurfaceToAir_ref4 = nil
					--~ bombs_already_exploded["bomb" .. weapon_index] = true

				-- elseif another part of the sam site :
				elseif SurfaceToAir_ref1 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_1_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_1_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_1_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_1_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air launcher (1).")
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 0-20 is for AI crash site, range 21-31 is for target destroyed
					play_sound(Victory_sound)
					if Sam_instance[1] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[1]) end
					if SurfaceToAir_ref1 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref1)  end
					Sam_instance[1] = nil
					SurfaceToAir_ref1 = nil
					max_shot_admissible = max_shot_admissible - 4
					--~ bombs_already_exploded["bomb" .. weapon_index] = true


				-- elseif another part of the sam site :
				elseif SurfaceToAir_ref2 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_2_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_2_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_2_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_2_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air launcher (2).")
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 0-20 is for AI crash site, range 21-31 is for target destroyed
					if Sam_instance[2] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[2]) end
					if SurfaceToAir_ref2 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref2)  end
					Sam_instance[2] = nil
					SurfaceToAir_ref2 = nil
					max_shot_admissible = max_shot_admissible - 4
					--~ bombs_already_exploded["bomb" .. weapon_index] = true

				-- elseif another part of the sam site :
				elseif SurfaceToAir_ref3 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_3_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_3_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_3_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_3_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air support vehicle (3).")
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 0-20 is for AI crash site, range 21-31 is for target destroyed
					if Sam_instance[3] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[3]) end
					if SurfaceToAir_ref3 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref3)  end
					Sam_instance[3] = nil
					SurfaceToAir_ref3 = nil
					max_shot_admissible = max_shot_admissible - 1
					--~ bombs_already_exploded["bomb" .. weapon_index] = true


				-- elseif another part of the sam site :
				elseif SurfaceToAir_ref5 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_5_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_5_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_5_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_5_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air support vehicle (5).")
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 0-20 is for AI crash site, range 21-31 is for target destroyed
					if Sam_instance[5] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[5]) end
					if SurfaceToAir_ref5 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref5)  end
					Sam_instance[5] = nil
					SurfaceToAir_ref5 = nil
					max_shot_admissible = max_shot_admissible - 1
					--~ bombs_already_exploded["bomb" .. weapon_index] = true

				-- elseif another part of the sam site :
				elseif SurfaceToAir_ref6 ~= nil
				-- same as SAM coordinates
				and sges_weapon_x[weapon_index] < sam_6_local_x + sges_admitted_circular_error
				and sges_weapon_x[weapon_index] > sam_6_local_x - sges_admitted_circular_error
				and sges_weapon_z[weapon_index] < sam_6_local_z + sges_admitted_circular_error
				and sges_weapon_z[weapon_index] > sam_6_local_z - sges_admitted_circular_error
				then
					-- draw the fire
					print("[Ground Equipment " .. version_text_SGES .. "] Weapon " .. weapon_index .. " has hit a surface-to-air support vehicle (6).")
					load_TargetFire(weapon_index+21) -- IndustrialFire_instance = ffi.new("XPLMInstanceRef[31]")
					-- range 0-20 is for AI crash site, range 21-31 is for target destroyed
					if Sam_instance[6] ~= nil then       XPLM.XPLMDestroyInstance(Sam_instance[6]) end
					if SurfaceToAir_ref6 ~= nil then     XPLM.XPLMUnloadObject(SurfaceToAir_ref6)  end
					Sam_instance[6] = nil
					SurfaceToAir_ref6 = nil
					max_shot_admissible = max_shot_admissible - 1
					--~ bombs_already_exploded["bomb" .. weapon_index] = true
				end
			end
		end
	end
	-- WEAPON ATTACK ON SAM ------------------------------------------------

end


function SurfaceToAir_object_physics()




	if Sam_chg == true then
	  if show_Sam then
		load_Sam()
		shot_down = false
		shot_down_twice = false
		Sam_button_text = " SAM "
	  else
		unload_SamObjects()
		Sam_button_text = " SAM "
		--~ set("sim/operation/failures/rel_engfir0",0)
		--~ set("sim/operation/failures/rel_engfir1",0)
		--~ set("sim/operation/failures/rel_engsep0",0)
		--~ set("sim/operation/failures/rel_gen_esys",0)
		--~ set("sim/operation/failures/rel_fcon_ailn_1_lft_lock",0)
		--~ set("sim/operation/failures/rel_fcon_ailn_2_lft_lock",0)
		--~ set("sim/operation/failures/rel_fcon_ailn_1_rgt_lock",0)
		--~ set("sim/operation/failures/rel_fcon_ailn_2_rgt_lock",0)
		--~ set("sim/operation/failures/rel_R_flp_off",0) -- remove flap
		--~ set("sim/operation/failures/rel_rud_trim_run",0) --trim rudder runwaway
		--~ set("sim/operation/failures/rel_L_flp_off",0) -- remove flap
		--~ set("sim/operation/failures/rel_collapse1",0) -- gear collapse
		--~ set("sim/operation/failures/rel_collapse2",0) -- gear collapse
		if radar_has_us_locked_said and shot_down then
			play_sound(Trying_an_easier_mission_sound)
		elseif radar_has_us_locked_said then
			play_sound(Victory_sound)
		end
		shot_down = false
		shot_down_twice = false
		shot_fired = 0
		SamAirport = nil
	  end
	  if Sam_instance[0] ~= nil and Sam_instance[1] ~= nil  and Sam_instance[2] ~= nil  then
		  draw_Sam()
	  end
	end
	if sam_shifted_x ~= nil and SGES_XPlaneIsPaused == 0 then
		-- sometimes the SAM site is shooting at the user :

		if show_Sam and sges_gs_ias_spd[0] > 20 and sges_gs_ias_spd[0] < 400 and (sges_gs_plane_y_agl[0]  < 6000 or PLANE_ICAO == "SR71") and sges_gs_plane_y_agl[0]  > 100 and SAM_object_1	==	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_AAA.obj" then
		-- 6000 m thats 19000 feet
		-- also we want the SAM to shoot only if the airport with SAM site is still the nearest one.
			New_current_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
			_, navLat, navLon, navAlt, _, navH, _, outNew = XPLMGetNavAidInfo( New_current_airport_index )

			math.randomseed(os.time())
			randomLock = math.random()
			if  outNew == SamAirport and shot_down_twice == false and randomLock > 0.5 then -- -- locks if the selected airport is still the nearest one plus randomly

				-- also of the distance is not too far
				navX,navY,navZ = latlon_to_local(navLat,navLon,navAlt)
				local range = sges_distance_to_target(sges_gs_plane_x[0], sges_gs_plane_z[0], navX, navZ, navH, navY )

				if range < 1915*10 then -- locks if below this distance (10 nm)
					if shot_fired == 0 then print("[Ground Equipment " .. version_text_SGES .. "] The battery radar locked you, you are at " .. math.floor((range/1915)*10)/10 .. " nm from the defended site (< 10 nm with the pursuit radar active or < 1 nm when the pursuit radar is out)." ) end
					stop_sound(Radar_warning_missile_lock_sound)
					stop_sound(Break_sound)
					if Sam_instance[4] ~= nil then
						play_sound(Radar_warning_tracking_sound)
						set("sim/cockpit/weapons/incoming_missile_lock",1) -- actuates RWR when equipped
						if not radar_has_us_locked_said then
							play_sound(Radar_has_us_locked_sound)
							radar_has_us_locked_said = true
						end
					end
					-- save the time of locking
					if Sam_instance[4] == nil then -- penalty, the missiles are shot without the pursuit radar, closer and with more delay
						if range < 1915*1 then
							SGES_locking_time = SGES_total_flight_time_sec + 4
						end
					else
						SGES_locking_time = SGES_total_flight_time_sec
					end
					-- fool the SAM site : we need to track the number of chaff to see when it decreases.
					PreviousChaffNumber = ChaffNumber[0]
					PreviousFlareNumber = FlareNumber[0]
					math.randomseed(os.time())
					randomShot = math.random()
				--~ else
					--~ print("The battery didn't radar locked you, you are far at " .. math.floor((range/1915)*10)/10 .. " nm." )
				end
			end
		end


		if SGES_total_flight_time_sec > SGES_launching_time + 5 and SGES_total_flight_time_sec < SGES_launching_time + 20 and sges_gs_plane_y_agl[0]  > 50 and sges_gs_plane_y_agl[0]  < 7000 then
			set("sim/cockpit/weapons/incoming_missile_lock",1) -- actuates RWR when equipped
		end

		-- missile collision
		if SGES_total_flight_time_sec > SGES_launching_time + 20 then
			--~ print("[Ground Equipment " .. version_text_SGES .. "] Missile " .. shot_fired .. " incoming " .. SGES_total_flight_time_sec .. " for " .. SGES_launching_time .. " + 20" )
			print("[Ground Equipment " .. version_text_SGES .. "] Missile #" .. shot_fired .. " incoming.")
			-- fool the SAM site : we need to track the number of chaff to see when it decreases.
			if sges_gs_plane_y_agl[0]  < 50 or sges_gs_plane_y_agl[0]  > 6000 then -- missile missed
				stop_sound(Radar_warning_missile_lock_sound)
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
				math.randomseed(os.time())
				randomWord = math.random()
				if randomWord > 0.9 then
					play_sound(Victory_sound)
				else
					play_sound(Missed_sound)
				end
				print("[Ground Equipment " .. version_text_SGES .. "] Missile missed !")
			elseif ChaffNumber[0] == PreviousChaffNumber and sges_gs_plane_y_agl[0]  > 50 and sges_gs_plane_y_agl[0]  < 6000 and shot_down == false and PLANE_ICAO ~= "SR71" then -- when no chaff was dropped
				-- some conditions here mimic the evading manoeuvers
				-- save the time of launching
				play_sound(Hit_sound)
				play_sound(Been_hit_sound)
				print("shot down once")
				set("sim/operation/failures/rel_engfir0",6)
				set("sim/operation/failures/rel_engsep0",6)
				set("sim/operation/failures/rel_fcon_ailn_1_lft_lock",6)
				set("sim/operation/failures/rel_fcon_ailn_2_lft_lock",6)
				set("sim/operation/failures/rel_fcon_ailn_1_rgt_lock",6)
				set("sim/operation/failures/rel_fcon_ailn_2_rgt_lock",6)
				set("sim/operation/failures/rel_collapse1",6) -- gear collapse
				set("sim/operation/failures/rel_collapse2",6) -- gear collapse
				set("sim/operation/failures/rel_R_flp_off",6) -- remove flap
				shot_down = true
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
			elseif ChaffNumber[0] == PreviousChaffNumber and sges_gs_plane_y_agl[0]  > 50 and sges_gs_plane_y_agl[0]  < 6000 and shot_down == false and PLANE_ICAO == "SR71" then -- when no chaff was dropped
				-- some conditions here mimic the evading manoeuvers
				-- save the time of launching
				play_sound(Radar_warning_missile_lock_sound)
				-- the SR-71 don't get shot !
				shot_down = true -- the SR-71 only get fired at once !
				shot_down_twice = true -- the SR-71 only get fired at once !
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
				print("The SR-71 Habu was fired at !")
			elseif ChaffNumber[0] == PreviousChaffNumber and sges_gs_plane_y_agl[0]  > 50 and sges_gs_plane_y_agl[0]  < 6000 and shot_down_twice == false and PLANE_ICAO ~= "SR71"  then -- already shot ? add some failures !
				play_sound(Hit_sound)
				play_sound(Hit_the_silk_sound)
				print("shot down twice, hit the silk !")
				set("sim/operation/failures/rel_rud_trim_run",6) --trim rudder runwaway
				set("sim/operation/failures/rel_L_flp_off",6) -- remove flap
				set("sim/operation/failures/rel_engfir1",6)
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
				shot_down_twice = true
			elseif ChaffNumber[0] < PreviousChaffNumber then
				-- escaped !
				play_sound(Chaff_sound)
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
				print("[Ground Equipment " .. version_text_SGES .. "] Missile missed due to chaff being released precluding the initial target designation by the radar director station !")
			elseif FlareNumber[0] < PreviousFlareNumber then
				-- escaped !
				play_sound(Missed_sound)
				play_sound(Hit_sound)
				SGES_launching_time = 10000 * SGES_total_flight_time_sec
				print("[Ground Equipment " .. version_text_SGES .. "] Missile missed due to flare being released during its terminal flightpath using the heat seeking sensor!")
			end
		end

	end
end

IndustrialFire_ref = ffi.new("char *[7]")
function load_TargetFire(i)
	if IndustrialFire_instance[i] == nil and i-21 > 0 then
		Sam_button_text = "Destroyed"
		print("[Ground Equipment " .. version_text_SGES .. "] Loading the fire instance #" .. i .. " because the weapon " .. i-21 .. " has reached a target.")
		local industrial_fire_sges = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround.obj"
		if IsXPlane12 then
			math.randomseed(os.time())
			randomWord = math.random()
			if randomWord >= 0.25 then
				industrial_fire_sges = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround_XP12.obj"
			else
				industrial_fire_sges = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround_XP12_extended.obj"
			end
		end
		XPLM.XPLMLoadObjectAsync(industrial_fire_sges,
		function(inObject, inRefcon)
			IndustrialFire_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
			IndustrialFire_ref[i] = inObject
		end,
		inRefcon )
	end
end

function draw_TargetFire()
	if SGES_XPlaneIsPaused == 0 and sges_gs_plane_y_agl[0] > 10 and sges_gs_gnd_spd[0] >= 0.5 and show_Sam then
		for weapon_index=0,10 do
			--~ print("[Ground Equipment " .. version_text_SGES .. "] Preparing to draw the fire instance #" .. weapon_index .. ".")
			if sges_weapon_fired[weapon_index] ~= nil and sges_weapon_fired[weapon_index] == 2
			and IndustrialFire_instance[weapon_index+21] ~= nil
			and bombs_not_already_exploded["bomb" .. weapon_index] ~= nil and bombs_not_already_exploded["bomb" .. weapon_index] then -- enforce draw only once using the status not yet changed
				print("[Ground Equipment " .. version_text_SGES .. "] Drawing the fire instance #" .. weapon_index .. ".")
				bombs_not_already_exploded["bomb" .. weapon_index] = draw_from_simulator_coordinates(sges_weapon_x[weapon_index],sges_weapon_z[weapon_index],0,IndustrialFire_instance[weapon_index+21],"Target_destroyed")
			end
		end
	end
end

do_sometimes("if SGES_XPlaneIsPaused == 0 then  draw_TargetFire() end") --make that once by button pressure
do_sometimes("if SGES_XPlaneIsPaused == 0 then  SurfaceToAir_object_physics() end") --make that once by button pressure
do_often("if SGES_XPlaneIsPaused == 0 then trigger_fire() end") --make that once by button pressure


local Site_x,Site_y,Site_z,Site_Distance,Site_heading,Site_absolute_heading,Site_relative_heading,Site_Delta_altitude
function sges_distance_to_target(plane_x, plane_z, in_target_x, in_target_z, in_heading, in_target_y )
  in_delta_x = plane_x - in_target_x
  in_delta_z = plane_z - in_target_z
  -- in_delta_x refers to the difference between the x coordinates (left/right) of the ref pt and the shifted position
  -- in_delta_z refers to the difference between the z coordinates (up/down) of the ref pt and the shifted position
  -- If the shifted position is below the ref pt, in_delta_z is negative.
  -- If the shifted position is to the right of the ref pt, in_delta_x is positive
  -- in_heading is the heading that the ref pt is facing
  -- in_ref_x, in_ref_z refers to the ref point which we know the x, z coordinates and we are using that to determine the shifted pos coordinates
  Site_Distance = math.floor(math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) ))
  --~ Site_heading = math.fmod ( ( math.deg ( math.atan2 ( in_delta_x , in_delta_z  ) ) + 360 ),  360 )
  --~ Site_absolute_heading = math.floor(360-Site_heading )
  --~ Site_relative_heading = math.floor(Site_absolute_heading-in_heading)
  --~ if AccidentSite_relative_heading < 0 then Site_relative_heading = math.floor(Site_absolute_heading+360-in_heading) end
  --~ Site_Delta_altitude = math.floor((sges_gs_plane_y[0]-target_y)*10)/10
  --~ -- corrective factor, because of the height of the aircraft CG in AGL.
  --~ Site_x,Site_y,Site_z=local_to_latlon(in_target_x,in_target_y,in_target_z)
  return Site_Distance
end

add_macro("SGES : reload aircraft weapons (if chocks set)", "if show_Chocks then command_once(\"sim/weapons/re_arm_aircraft\") end")
add_macro("SGES : forward controler smoke (set dist. in menu)", "if show_FireSmoke then show_FireSmoke = false FireSmoke_chg = true else  show_FireSmoke = true FireSmoke_chg = true  end")


	-- Initialisation du dernier temps de largage et de l'intervalle en secondes
	local last_decoy_time = 0
	local interval = 5  -- Remplacez par le nombre de secondes souhaité

