
--    --------------------------------------------------------------------------
--          LICENSE
--    --------------------------------------------------------------------------
--    Copyright (c) 2022-2025, XPJavelin

--    Permission is hereby granted, free of charge, to any person obtaining a copy
--    of this software and associated documentation files (the "Software"), to deal
--    in the Software without restriction, including without limitation the rights to
--    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
--    the Software, and to permit persons to whom the Software is furnished to do so,
--    subject to the following conditions:
--
--    The above copyright notice and this permission notice shall be included in all copies
--    or substantial portions of the Software.
--
--    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
--    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
--    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
--    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
--    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--    DEALINGS IN THE SOFTWARE.
--


--------------------------------------------------------------------------------
require("bit")
require("graphics")
local ffi = require ("ffi")
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
-- create declarations of C types
local cdefs = [[
	typedef struct {
	int                       structSize;
	float                     x;
	float                     y;
	float                     z;
	float                     pitch;
	float                     heading;
	float                     roll;
  } XPLMDrawInfo_t;

  typedef struct {
	int                       structSize;
	float                     locationX;
	float                     locationY;
	float                     locationZ;
	float                     normalX;
	float                     normalY;
	float                     normalZ;
	float                     velocityX;
	float                     velocityY;
	float                     velocityZ;
	int                       is_wet;
  } XPLMProbeInfo_t;
  typedef void *inRefcon;
  typedef void *XPLMDataRef;
  typedef void *XPLMObjectRef;
  typedef void *XPLMInstanceRef;
  typedef void *XPLMProbeRef;
  typedef int XPLMProbeType;
  typedef int XPLMProbeResult;
  typedef void (*XPLMObjectLoaded_f)(XPLMObjectRef inObject, void *inRefcon);
  typedef int (*XPLMGetDatai_f)(void *inRefcon);
  typedef void (*XPLMSetDatai_f)(void *inRefcon, int inValue);
  typedef float (*XPLMGetDataf_f)(void *inRefcon);
  typedef void (*XPLMSetDataf_f)(void *inRefcon, float inValue);
  typedef double (*XPLMGetDatad_f)(void *inRefcon);
  typedef void (*XPLMSetDatad_f)(void *inRefcon, double inValue);
  typedef int (*XPLMGetDatavi_f)(void *inRefcon,
								  int *outValues,    /* Can be NULL */
								  int inOffset,
								  int inMax);
  typedef void (*XPLMSetDatavi_f)(void *inRefcon,
								   int *inValues,
								   int inOffset,
								   int inCount);
  typedef int (*XPLMGetDatavf_f)(void *inRefcon,
								  float *outValues,    /* Can be NULL */
								  int inOffset,
								  int inMax);
  typedef void (*XPLMSetDatavf_f)(void *inRefcon,
								   float *inValues,
								   int inOffset,
								   int inCount);
  typedef int (*XPLMGetDatab_f)(void *inRefcon,
								 void *outValue,    /* Can be NULL */
								 int inOffset,
								 int inMaxLength);
  typedef void (*XPLMSetDatab_f)(void *inRefcon,
								  void *inValue,
								  int inOffset,
								  int inLength);
  XPLMDataRef XPLMRegisterDataAccessor(
						 const char *         inDataName,
						 int                  inDataType,
						 int                  inIsWritable,
						 XPLMGetDatai_f       inReadInt,
						 XPLMSetDatai_f       inWriteInt,
						 XPLMGetDataf_f       inReadFloat,
						 XPLMSetDataf_f       inWriteFloat,
						 XPLMGetDatad_f       inReadDouble,
						 XPLMSetDatad_f       inWriteDouble,
						 XPLMGetDatavi_f      inReadIntArray,
						 XPLMSetDatavi_f      inWriteIntArray,
						 XPLMGetDatavf_f      inReadFloatArray,
						 XPLMSetDatavf_f      inWriteFloatArray,
						 XPLMGetDatab_f       inReadData,
						 XPLMSetDatab_f       inWriteData,
						 void *               inReadRefcon,
						 void *               inWriteRefcon);
  XPLMObjectRef XPLMLoadObject( const char *inPath);
  void XPLMLoadObjectAsync( const char * inPath, XPLMObjectLoaded_f inCallback, void *inRefcon);
  XPLMInstanceRef XPLMCreateInstance(XPLMObjectRef obj, const char **datarefs);
  void XPLMInstanceSetPosition(XPLMInstanceRef instance, const XPLMDrawInfo_t *new_position, const float *data);
  XPLMProbeRef XPLMCreateProbe(XPLMProbeType inProbeType);
  XPLMProbeResult XPLMProbeTerrainXYZ( XPLMProbeRef inProbe, float inX, float inY, float inZ, XPLMProbeInfo_t *outInfo);
  void XPLMUnregisterDataAccessor(XPLMDataRef inDataRef);
  void XPLMDestroyInstance(XPLMInstanceRef instance);
  void XPLMUnloadObject(XPLMObjectRef inObject);
  void XPLMDestroyProbe(XPLMProbeRef inProbe);
  void XPLMWorldToLocal( double inLatitude, double inLongitude, double inAltitude, double *outX, double *outY, double *outZ);
  void XPLMLocalToWorld( double inX, double inY, double inZ, double *outLatitude, double *outLongitude, double *outAltitude);
  void XPLMGetSystemPath(char * outSystemPath);
]]
-- add these types to the FFI:
ffi.cdef(cdefs)
-- Variables to handle C pointers
local char_str = ffi.new("char[256]")
local datarefs_addr = ffi.new("const char**")
local dataref_name = ffi.new("char[150]")         -- define the length of the string to store the name of the dataref. can be longer but not shorter
local dataref_register7 = ffi.new("XPLMDataRef")
local dataref_array2 = ffi.new("const char*[2]")  -- this is for the signboard, one dataref and one null dataref
-- used arbitrary to store info about the object
local objpos_addr =  ffi.new("const XPLMDrawInfo_t*")
local objpos_value = ffi.new("XPLMDrawInfo_t[1]")
local paxpos_value = ffi.new("XPLMDrawInfo_t[1]")
-- use arbitrary to store float value & addr of float value
local float_addr = ffi.new("const float*")
local float_value = ffi.new("float[1]")
-- meant for the probe
local probeinfo_addr =  ffi.new("XPLMProbeInfo_t*")
local probeinfo_value = ffi.new("XPLMProbeInfo_t[1]")
local probetype = ffi.new("int[1]");
-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")
-- to store in values of the local nature of the terrain (wet / land)
local terrain_nature = ffi.new("int[1]")
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- PARAMETER TO START THE TURN OF PRE-PLANNED PUSH-BACK
-- local radius_pushback = 22 	-- before V65, worked well then PB was too long
-- local radius_pushback = 29 	--  then before X-Plane 12.0.8, worked well then PB was too short
-- local radius_pushback = 24		-- for X-Plane 12.0.9
--~ local radius_pushback = 18.5		-- for X-Plane 12.0.9
local radius_pushback = 18		-- for X-Plane 12.2.0  (push was too short), plus whe have an anti-overrun piece of code now
local maximum_speed_reduction_factor = 3 -- to avoid overrunning the aiming point, reducing the longitudinal push when approaching the target
-- This parameter needs tuning with X-Plane versions
local SGES_pushback_start_delay = 8
local SGES_pushback_start_time = -99

local	Prefilled_PushBack1Object_backup = Prefilled_PushBack1Object
local	Prefilled_PushBackObject_backup =  Prefilled_PushBackObject
local 	Prefilled_GenericDriverObject_backup = Prefilled_GenericDriverObject

local		wingwalker1_greenflag = false
local		wingwalker2_greenflag = false

last_heading = sges_gs_plane_head[0]
local speed_reduction_factor = 1
local cleared_to_start_played = false
SGES_Author 			= get("sim/aircraft/view/acf_author")
if test_777v2_a == nil then test_777v2_a = false end
if test_777v2_b == nil then test_777v2_b = false end
if test_777v2_c == nil then test_777v2_c = false end

--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
print("[Ground Equipment " .. version_text_SGES .. "] The sub-script Pushback.lua will now load the required datarefs.")
if XPLMFindDataRef("1-sim/ckpt/rightYokeRoll/anim") ~= nil and  XPLMFindDataRef("1-sim/ckpt/rightYokePitch/anim") ~= nil  and PLANE_ICAO == "B772" then
	-- Flight factor does not activate the usual dataref, I'm looking for the private dataref for animation as a workaround :
	dataref("SGES_777_pushTurn_ratio","1-sim/ckpt/rightYokeRoll/anim")
	dataref("SGES_777_yoke_pitch_ratio","1-sim/ckpt/rightYokePitch/anim")
	SGES_pushTurn_ratio = SGES_777_pushTurn_ratio / 80 -- init, important!
	SGES_yoke_pitch_ratio = -SGES_777_yoke_pitch_ratio / 10  -- init, important!
	function update_777_yoke_values()
		-- the output needs to be tamed !
		SGES_pushTurn_ratio = SGES_777_pushTurn_ratio / 80
		SGES_yoke_pitch_ratio = -SGES_777_yoke_pitch_ratio / 10
	end
	do_often("update_777_yoke_values()")
	print("[Ground Equipment " .. version_text_SGES .. "] The sub-script Pushback.lua uses 1-sim/ckpt/rightYokeRoll/anim and 1-sim/ckpt/rightYokePitch/anim (only in the Boeing 777 v2)")
--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
--------- STS/FF 777v2 YOKE AND PITCH PATCH --------------------------------
else
	if SGES_pushTurn_ratio == nil 	then dataref("SGES_pushTurn_ratio","sim/joystick/yoke_roll_ratio") end
	if SGES_yoke_pitch_ratio == nil then dataref("SGES_yoke_pitch_ratio","sim/joystick/yoke_pitch_ratio") end
	print("[Ground Equipment " .. version_text_SGES .. "] The sub-script Pushback.lua uses sim/joystick/yoke_roll_ratio and sim/joystick/yoke_pitch_ratio (perfectly normal)")
end
--------------------------------------------------------------------------------

-- ||||||||||||||||| QUATERNION FUNCTION |||||||||||||||||||||||||||||||||||||||||||||
-- Orienting the Aircraft in Space

--if q == nil then q = dataref_table("sim/flightmodel/position/q","writable") end
-- The aircraft’s orientation is described by three rotations, “psi” (heading), “theta” (pitch), and “phi” (roll).
function update_quaternion(theta,phi,psi)
	if q == nil then q = dataref_table("sim/flightmodel/position/q","writable") print("[Ground Equipment " .. version_text_SGES .. "] Quaternion loaded (Orienting the Aircraft in Space) !") end
	--theta=0 --pitch
	--phi = 0 --roll
	--psi = 100 -- desired final magnetic angle
	psiP = math.pi / 360 * psi
	thetaP = math.pi / 360 * theta
	phiP = math.pi / 360 * phi
	q[0] =  math.cos(psiP) * math.cos(thetaP) * math.cos(phiP) + math.sin(psiP) * math.sin(thetaP) * math.sin(phiP)
	q[1] =  math.cos(psiP) * math.cos(thetaP) * math.sin(phiP) - math.sin(psiP) * math.sin(thetaP) * math.cos(phiP)
	q[2] =  math.cos(psiP) * math.sin(thetaP) * math.cos(phiP) + math.sin(psiP) * math.cos(thetaP) * math.sin(phiP)
	q[3] = -math.cos(psiP) * math.sin(thetaP) * math.sin(phiP) + math.sin(psiP) * math.cos(thetaP) * math.cos(phiP)
end

-- update_quaternion(pitch,roll,yaw)
-- USE : update_quaternion(0,0,360)


function service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation) -- The Aiming Plane model
	if TargetSelfPushback_chg == true then
	  if show_TargetSelfPushback then
		 load_TargetSelfPushback()
		 SelfPushback_requested = true
	  else
		TargetSelfPushback_chg,TargetSelfPushback_instance[0],rampservicerefTargetSelfPushback = common_unload("TargetSelfPushback",TargetSelfPushback_instance[0],rampservicerefTargetSelfPushback)
		SelfPushback_requested = false
		--~ TargetSelfPushbackH = sges_gs_plane_head[0]
		--~ TargetSelfPushbackY = sges_gs_plane_y[0]
		--~ TargetSelfPushbackX_stored = sges_gs_plane_x[0] + 10
		--~ TargetSelfPushbackZ_stored = sges_gs_plane_z[0] + 10
	  end
	  if TargetSelfPushback_instance[0] ~= nil then
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT()
			local h = 0
			local x = 0
			local z = -2
			if SPB_distance == nil then SPB_distance = 0 end
			if SPB_orientation == nil then SPB_orientation = 0 end

			z = SPB_distance
			h = SPB_orientation -- is now an angle

			if SPB_orientation > center_line_sticky_heading_threshold then x = 10
			elseif SPB_orientation < - 1 * center_line_sticky_heading_threshold then x = -10
			else x = 0 end


			--print("Sending the pushback truck backward : " .. z)
			TargetSelfPushback_chg = draw_static_object(x,z,h,TargetSelfPushback_instance[0],"TargetSelfPushback") -- Nop !
			-- save marker position
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT()
			TargetSelfPushbackX_stored = g_shifted_x
			TargetSelfPushbackZ_stored = g_shifted_z
			TargetSelfPushbackH_stored = sges_gs_plane_head[0] + h
			Initial_Gate_heading = math.floor(sges_gs_plane_head[0]) -- the pushback truck will return to the gate, so we need to note the gate heading for the final sequence -- new 2024-09-17
			--Initial_Gate_heading only exists with a preplanned pushback, and that is intended
			-- correct negative or more than 360 degrees values :
			if TargetSelfPushbackH_stored > 360 then
				TargetSelfPushbackH_stored = TargetSelfPushbackH_stored - 360
			end
			if TargetSelfPushbackH_stored < 0 then
				TargetSelfPushbackH_stored = TargetSelfPushbackH_stored + 360
			end

			load_WingWalkers()
	  end
	end
end





function service_object_physics_Push_back()
  if PB_chg == true then
	  if show_PB then
		load_PB()
		if (test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
			set("1-sim/service/lights/emerlights",1)
			set("1-sim/service/lights/backheadlight",1)
			set("1-sim/service/lights/frontheadlight",0)
			set("1-sim/service/lights/backredlight",1)
		end

		  --~ if sges_override_planepath[0] == 0 then sges_override_planepath[0] = 1 print("disabling flight model for PB") end -- room for future improvement  -- disable flight model


	 --elseif PB_instance[0] ~= nil and PB_instance[1] ~= nil and GenericDriver_instance[0] ~= nil and PBFinalX ~= nil and PBFinalY ~= nil and PB1FinalX ~= nil and PB1FinalY ~= nil and GDriverFinalX ~= nil and GDriverFinalY ~= nil then
	 else
		if PB_instance[1] ~= nil then
				if PB1FinalX ~= nil then 		PB_chg,PB_instance[1],rampservicerefPB1,PB1FinalX,PB1FinalY = Common_draw_departing_vehicles(PB1FinalX,PB1FinalY,PB_instance[1],"PB",rampservicerefPB1,0) end
				SGES_pushback_start_time = -99
		end
		if  GenericDriver_instance[0] ~= nil  then
				if GDriverFinalX ~= nil then 	PB_chg,GenericDriver_instance[0],rampservicerefGenericDriver,GDriverFinalX,GDriverFinalY = Common_draw_departing_vehicles(GDriverFinalX,GDriverFinalY,GenericDriver_instance[0],"GenericDriver",rampservicerefGenericDriver,0) end
		end
		if PB_instance[0] ~= nil  then
				if PBFinalX ~= nil then 		PB_chg,PB_instance[0],rampservicerefPB,PBFinalX,PBFinalY = Common_draw_departing_vehicles(PBFinalX,PBFinalY,PB_instance[0],"Pushback",rampservicerefPB,0) end -- bar
		end

			--_,PB_instance[0],rampservicerefPB = common_unload("Pushback",PB_instance[0],rampservicerefPB)
			--_,GenericDriver_instance[0],rampservicerefGenericDriver = common_unload("GenericDriver",GenericDriver_instance[0],rampservicerefGenericDriver)

		  if PB_instance[1] == nil or GenericDriver_instance[0] == nil or PB_instance[0] == nil  then
		  -- unload_PB()
			if PB_instance[1] ~= nil then _,PB_instance[1],rampservicerefPB1 = common_unload("PB",PB_instance[1],rampservicerefPB1) print("[Ground Equipment " .. version_text_SGES .. "]  Removed the tractor.") end
			if PB_instance[0] ~= nil then _,PB_instance[0],rampservicerefPB = common_unload("Pushback",PB_instance[0],rampservicerefPB) print("[Ground Equipment " .. version_text_SGES .. "]  Removed also the push-back bar.") end
			if GenericDriver_instance[0] ~= nil then PB_chg,GenericDriver_instance[0],rampservicerefGenericDriver = common_unload("GenericDriver",GenericDriver_instance[0],rampservicerefGenericDriver) print("[Ground Equipment " .. version_text_SGES .. "]  Removed also the push-back driver.") end
			PBFinalX = nil
			PBFinalY = nil
			PB1FinalX = nil
			PB1FinalY = nil
			GDriverFinalX = nil
			GDriverFinalY = nil
			currentX = nil
			currentY = nil
			current_X["PB"] = nil
			current_Z["PB"] = nil
			current_X["Pushback"] = nil
			current_Z["Pushback"] = nil
			current_X["GenericDriver"] = nil
			current_Z["GenericDriver"] = nil
			heading_corr["PB"] = nil
			Initial_Gate_heading = nil
			--~ if sges_override_planepath[0] == 1 and not show_Chocks then -- reenable flight model
				--~ sges_override_planepath[0] = 0
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Reenabling flight model after PB")
			--~ end
		  end
	  end

	  if PB_instance[0] ~= nil and show_PB then
		  draw_PB()
	  end
	  if PB_instance[1] ~= nil and show_PB and GenericDriver_instance[0] ~= nil then
		  draw_PB1()
	  end
	  --~ if GenericDriver_instance[0] ~= nil then
		  --~ draw_GenericDriver()
	  --~ end
  end

  load_WingWalkers()
end

function load_WingWalkers()
	-----------------------------------------------------------------------
	-- WING walkers -- IAS 24
	-- triggered by pushback
	if not show_Baggage and show_PB and show_WingWalkers then -- not show_Baggage  avoids a too many call back issue on line 5006 of main script 2024-09
	--if PB_chg and show_PB and show_WingWalkers then
		--  manage the human :
		if Baggage_instance[4] == nil or Baggage_instance[3] == nil then
			wingwalker1_greenflag = false
			wingwalker2_greenflag = false
			------ human handlers :
			if Baggage_instance[3] == nil and baggage3_show_only_once and not UseXplaneDefaultObject then
				if military == 1 or military_default == 1 then
					Baggage3Object = Prefilled_PassengerMilObject
				else
					Baggage3Object = Prefilled_GenericDriverObject_anim
				end
				print("[Ground Equipment " .. version_text_SGES .. "] LOAD wing walker 1 /instance[3]")
				XPLM.XPLMLoadObjectAsync(Baggage3Object,
							function(inObject, inRefcon)
								Baggage_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefBaggage3 = inObject
							end,
							inRefcon )
				baggage3_show_only_once = false
			end

			-- front handler
			if Baggage_instance[4] == nil and baggage4_show_only_once and not UseXplaneDefaultObject   then
				Baggage4Object = Baggage3Object
				print("[Ground Equipment " .. version_text_SGES .. "] LOAD wing walker 2 /instance[4]")
				XPLM.XPLMLoadObjectAsync(Baggage4Object,
							function(inObject, inRefcon)
								Baggage_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefBaggage4 = inObject
							end,
							inRefcon )
				baggage4_show_only_once = false
			end
		end
	elseif PB_chg and not show_Baggage and (Baggage_instance[3] ~= nil or Baggage_instance[4] ~= nil) then -- not show_Baggage because we dont remove the people if the people are currently handling baggage
		remove_wingwalkers()
	end

end

function remove_wingwalkers()
		if Baggage_instance[3] ~= nil then _,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3) end
		if Baggage_instance[4] ~= nil then _,Baggage_instance[4],rampservicerefBaggage4 = common_unload("Baggage4",Baggage_instance[4],rampservicerefBaggage4) end
		baggage3_show_only_once = true
		baggage4_show_only_once = true
		baggage_x3 = nil
		baggage_z3 = nil
		baggage_x4 = nil
		baggage_z4 = nil
		wingwalker1_greenflag = false
		wingwalker2_greenflag = false
		print("[Ground Equipment " .. version_text_SGES .. "] Removed wing walkers")
end

local function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end



function load_PB()
	if PB_show_only_once then



		-- make the wing walkers always available for some aircrfat :
		--~ if  pushback_manual ~= nil and not pushback_manual then -- but in automated pushback we are time limited, so remove them
			--~ show_WingWalkers = false
		if math.abs(BeltLoaderFwdPosition) >= 19 or ((PLANE_ICAO == "B789" or PLANE_ICAO == "B788" or PLANE_ICAO == "A346" or PLANE_ICAO == "A339") and (SGES_local_time_in_simulator_hours < 10 or SGES_local_time_in_simulator_hours > 17)) then
			-- call wingwlkers for big aircraft as a general use (I also do systematically call wingwalkers for some other aircraft types during the night)
			show_WingWalkers = true
			print("[Ground Equipment " .. version_text_SGES .. "] The airport manager claims wing walkers are available for this " .. PLANE_ICAO .. ".")
		-- otherwise check if it is a big airport in which we put wing walkers.
		elseif math.abs(BeltLoaderFwdPosition) > 4 then
			show_WingWalkers,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time)
			-- at big airports, wingwalkers will show except for general aviation and helicopters (small aircrfat)
			if show_WingWalkers then
					print("[Ground Equipment " .. version_text_SGES .. "] The airport manager claims wing walkers are available here.")
				else
					print("[Ground Equipment " .. version_text_SGES .. "] This airport is not on the list of airfields where wing walkers are available.")
			end
		else -- do not load wing walkers if the conditions above aren't satisfied (ie small aircraft or not big airport)
			show_WingWalkers = false
			print("[Ground Equipment " .. version_text_SGES .. "] Wing walkers are not available for this " .. PLANE_ICAO .. ".")
		end
		if show_WingWalkers then
			print("[Ground Equipment " .. version_text_SGES .. "] Note that by design wing walkers aren't available more than once in a session !")
		end


		-- THE ENGINE
		if PB_instance[1] == nil and PB_show_only_once then
			-- I will intevene here to offer the X-Plane 12 default big pushback tug
			if BeltLoaderFwdPosition >= 6 or (sges_big_airport ~= nil and sges_big_airport) or (SGES_IsAirliner ~= nil and SGES_IsAirliner == 1) then
				math.randomseed(os.time())
				local randompouchbaq = math.random()
				if randompouchbaq > 0.50 or (sges_big_airport ~= nil and sges_big_airport) or BeltLoaderFwdPosition >= 13 then
					if UseXplane1214DefaultObject and file_exists(Native_PushBack_Tug) then
						logMsg("[Ground Equipment " .. version_text_SGES .. "] Object exists: default scenery/airport scenery/Dynamic_Vehicles/Tug_GT110.obj.")
						logMsg("[Ground Equipment " .. version_text_SGES .. "] After 2025-10-09 we decided to sample as well the native X-Plane pushback tug.")
						Prefilled_PushBack1Object = Native_PushBack_Tug
						if (LATITUDE > 48 and LATITUDE < 50) and (LONGITUDE > -5 and LONGITUDE < 8) then
							Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_1.obj" -- White -- French towbar
						elseif (LATITUDE > 29 and LATITUDE < 43) and (LONGITUDE > 18 and LONGITUDE < 49) then
							Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_2.obj" -- Mediterranean towbar
						elseif (LATITUDE >= 48 and LATITUDE < 72) and (LONGITUDE > -10 and LONGITUDE < 28) then
							Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_3.obj" -- Blue -- Nordic EU towbar
						elseif (LATITUDE >= 43 and LATITUDE < 48) and (LONGITUDE > 8 and LONGITUDE < 28) then
							Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_1.obj" -- White -- Eastern Eu towbar
						elseif  (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69) then
							Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_1.obj" -- White -- -- East Coast USA towbar
						end
						-- else default towbar selection started at session starts applies.
						-- You can safely load it
					elseif file_exists(Native_PushBack_Tug) and Prefilled_PushBack1Object == Native_PushBack_Tug then
						logMsg("[Ground Equipment " .. version_text_SGES .. "] Object exists: default scenery/airport scenery/Dynamic_Vehicles/Tug_GT110.obj.")
						logMsg("[Ground Equipment " .. version_text_SGES .. "] But SGES options state to not use it.")
						Prefilled_PushBack1Object = Prefilled_PushBack1Object_backup
						Prefilled_PushBackObject =  Prefilled_PushBackObject_backup
					end
				end
			end

			   XPLM.XPLMLoadObjectAsync(Prefilled_PushBack1Object,
						function(inObject, inRefcon)
							PB_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefPB1 = inObject
						end,
						inRefcon )
		end

		-- THE TOW BAR
		if PB_instance[0] == nil then
		-- note that when there is only one instance, the instance array index must be 0, NOT 1.
		-- otherwise, xplane will crash --> hey that looks pretty normal since 0 is the first case. GF
			--print("[Ground Equipment " .. version_text_SGES .. "] 5 load_rampserviceD _PushBack")
			   XPLM.XPLMLoadObjectAsync(Prefilled_PushBackObject,
						function(inObject, inRefcon)
							PB_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefPB = inObject
						end,
						inRefcon )
		end


		Load_Cami_de_Bellis_Objects()

		if GenericDriver_instance[0] == nil then


			if Prefilled_PushBack1Object == Native_PushBack_Tug then
				Prefilled_GenericDriverObject =  SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/People/Airport_Driver_for_GT110.obj"
			elseif file_exists(Native_PushBack_Tug) and Prefilled_PushBack1Object == Native_PushBack_Tug then
				Prefilled_GenericDriverObject = Prefilled_GenericDriverObject_backup
			end

			print("Prefilled_GenericDriverObject " .. Prefilled_GenericDriverObject)
			   XPLM.XPLMLoadObjectAsync(Prefilled_GenericDriverObject,
						function(inObject, inRefcon)
							GenericDriver_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefGenericDriver = inObject
						end,
						inRefcon )
		end
		cleared_to_start_played = false
		PB_show_only_once = false
	end
end


function draw_PB() -- the bar
		float_value[0] = 0
		float_addr = float_value
		if acft_y == nil then acft_y = 0 end
		objpos_value[0].y = acft_y

		if IsXPlane1209 then
			objpos_value[0].y = acft_y - 0.3
		end

		--~ if SGES_Vertical_position_gear_strut_extended[0]
		--~ if SGES_strut_compression[0]
		-- POSITIVE LEFT < x > NEGATIVE RIGHT
		-- POSITIVE FWD < z > NEGATIVE AFT
		local x_corr = 0
		local z_corr = 0
		if IsXPlane1209 then
			z_corr = 0.1
		end
		if PLANE_ICAO == "ch47" then z_corr = 7 x_corr = 1.6 end
		if PLANE_ICAO == "S61" then z_corr = 6.9 x_corr = 1.9 end
		if PLANE_ICAO == "H125" or PLANE_ICAO == "BO-105" or PLANE_ICAO == "B06" then x_corr = 1.0 end
		if PLANE_ICAO == "L5" then x_corr = 1.0 end
		if PLANE_ICAO == "F16" then z_corr = 4.0 end
		if PLANE_ICAO == "ALIA" then x_corr = 1.0 end
		if PLANE_ICAO == "LAMA" then z_corr = 2.5 x_corr = 1.2 end
		if PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then z_corr = 11.5 x_corr = 3.15 end
		if PLANE_ICAO == "A3ST" then z_corr = 0.55 end
		if PLANE_ICAO == "F104" then z_corr = 0.6 	end  -- long nose
		if PLANE_ICAO == "E170" and SGES_Author == "Marko Mamula" then z_corr = 0	end
		if PLANE_ICAO == "E175" and SGES_Author == "Marko Mamula" then z_corr = 1 	end
		if PLANE_ICAO == "E190" and SGES_Author == "Marko Mamula" then z_corr = 2.8	end
		if PLANE_ICAO == "E195" and SGES_Author == "Marko Mamula" then z_corr = 3.8	end

		if ((test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") or Prefilled_PushBackObject == 	SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj" )then
			-- in this case, the bar is not a bar, it's the integrated lifting tug, not an assembly of tractor and bar.
			z_corr = 2 - math.abs(sges_nosewheel[0] / 50)
			-- anticipate the rotation of the tug by moving it lateraly :
			x_corr = sges_nosewheel[0] / 20
		end



		coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0+x_corr, gear1Z + 0.01*gear1Z + z_corr, sges_gs_plane_head[0] )

		-- store final position
		PBFinalX = 0+x_corr
		PBFinalY = gear1Z + 0.01*gear1Z + z_corr

		local bar_hdg = sges_gs_plane_head[0] - 0.7 * sges_nosewheel[0] --default


		if math.abs(sges_nosewheel[0]) > 19.90 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.2 * sges_nosewheel[0] / 1.5

		elseif math.abs(sges_nosewheel[0]) > 19.80 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.3 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.70 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.4 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.60 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.5 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.50 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.6 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.40 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.80 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.30 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.90 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.20 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.95 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.10 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 0.99 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 19.00 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.02 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 18.90 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.05 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 18.80 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.08 * sges_nosewheel[0] / 1.5

		elseif math.abs(sges_nosewheel[0]) > 18.75 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.10 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 18.5 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.20 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 18.25 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.30 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 18 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.35 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 17.75 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.40 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 17.5 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.45 * sges_nosewheel[0] / 1.5
		elseif math.abs(sges_nosewheel[0]) > 17.25 then   --turnratenoroll
			bar_hdg = sges_gs_plane_head[0] - 1.5 * sges_nosewheel[0] / 1.5
		else
			bar_hdg = sges_gs_plane_head[0] - 1.5  * sges_nosewheel[0] / 1.5
		end
		if ((test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") or Prefilled_PushBackObject == SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj") then
			-- in this case, the bar is not a bar, it's the integrated lifting tug, not an assembly of tractor and bar.
			-- the orientation follow a different rule than when the object is a bar
			bar_hdg = sges_gs_plane_head[0] - 1.7 * sges_nosewheel[0]
		end
		if (test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
			set("1-sim/anim/frontGearAngle",sges_nosewheel[0]*1.75) -- animate the 777-200 ER gear
			set("1-sim/anim/frontGearCopress",0.15)
			set("sim/joystick/yoke_heading_ratio",sges_nosewheel[0]*1.75)
		end
		bar_hdg = bar_hdg
		objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,bar_hdg,nil,"Pushback")
		-- patch for carrier pushback
		--~ if SGES_Vertical_position_gear_strut_extended[0]
		--~ if SGES_strut_compression[0]
		if wetness == 1 and math.abs(sges_gs_plane_y[0]-acft_y) > 5 then
			objpos_value[0].y = sges_gs_plane_y[0] + ref_to_default  + SGES_Vertical_position_gear_strut_extended[0]  - SGES_strut_compression[0] - 0.05 -- all is in meters
			-- SGES_Vertical_position_gear_strut_extended[0] is a negative value usually
			objpos_addr = objpos_value
		end
		--if wetness == 0 then
			XPLM.XPLMInstanceSetPosition(PB_instance[0], objpos_addr, float_addr)    -- TOWBAR
		--~ else
			--~ show_PB = false
			--~ XPLMSpeakString("not on dry terrain")
		--~ end
		objpos_value[0].pitch =     0

end



function draw_PB1() -- the motor engine AND wing walkers at the en !
		float_value[0] = 0
		float_addr = float_value
		-- POSITIVE LEFT < x > NEGATIVE RIGHT
		-- POSITIVE FWD < z > NEGATIVE AFT
		local x_corr = 0
		local z_corr = 0
		-- when using MisterX tractor :
		if string.find(Prefilled_PushBack1Object,"MisterX_Lib") then
			z_corr = 1.2
		end
		--
		if string.find(Prefilled_PushBack1Object,"Hyster60_Forklift_Loaded") then
			z_corr = z_corr + 0.75
		elseif string.find(Prefilled_PushBack1Object,"Willys") then
			z_corr = z_corr + 0.75
		elseif string.find(Prefilled_PushBack1Object,"Van") then
			z_corr = z_corr + 0.65
		elseif Prefilled_PushBack1Object == Native_PushBack_Tug then -- added 2025-10-09
			z_corr = z_corr + 2.6
		end
		-- the below have been calibrated with the SGES PB tractor

		if PLANE_ICAO == "ch47" then z_corr = 5.75 x_corr = 1.6 end
		if PLANE_ICAO == "S61" then z_corr = 5.65 x_corr = 1.9 end
		if PLANE_ICAO == "H125" or PLANE_ICAO == "BO-105" or PLANE_ICAO == "B06" then x_corr = 1.0 end
		--~ if PLANE_ICAO == "A3ST" then z_corr = 1.3 end
		if PLANE_ICAO == "L5" then x_corr = 1.0  end
		if PLANE_ICAO == "F16" then z_corr = 3.85 end
		if PLANE_ICAO == "ALIA" then x_corr = 1.0 end
		if PLANE_ICAO == "LAMA" then z_corr = 2.9 x_corr = 1.2 end
		if PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then z_corr = 8.7 x_corr = 3.15 end
		if PLANE_ICAO == "A3ST" then z_corr = 0.35 end -- ineffective
		if PLANE_ICAO == "F104" then z_corr = 1.6 	end  -- long nose
		if PLANE_ICAO == "E175" and SGES_Author == "Marko Mamula" then z_corr = 0.6 	end
		if PLANE_ICAO == "E190" and SGES_Author == "Marko Mamula" then z_corr = 1.75	end
		if PLANE_ICAO == "E195" and SGES_Author == "Marko Mamula" then z_corr = 2.4	end
		-- when using MisterX tractor :
		if string.find(Prefilled_PushBack1Object,"MisterX_Lib") and PLANE_ICAO == "A3ST" then -- the beluga uses the very small tractor
			z_corr = 1.2 + 0.35
		end

		-- LONGITUDINAL CORRECTIONS
		if string.find (Prefilled_PushBack1Object,"MisterX_Lib") then
			if math.abs(sges_nosewheel[0]) > 21.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.75 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 21 then   --
				z_corr = 0.77 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 20.75 then   --
				z_corr = 0.79 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 21.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.75 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 21 then   --
				z_corr = 0.77 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 30.50 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.4 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 30.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.45 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 30.00 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.5 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 29.75 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.55 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 29.50 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.6 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 29.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.65 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 29.00 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.70 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 28.75 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.75 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 28.50 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.78 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 28.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.82 * z_corr
			elseif math.abs(sges_nosewheel[0]) <= 20.75 then
				z_corr = 1.54 * z_corr --when the tug is in the aircraft axis; it is at nominal distance from the nose wheel
			end

		elseif Prefilled_PushBack1Object == Native_PushBack_Tug then
			if math.abs(sges_nosewheel[0]) > 30 then   --
				z_corr = 1.33 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 27 then   --
				z_corr = 1.36 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 25 then   --
				z_corr = 1.38 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 23 then   --
				z_corr = 1.39 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 21 then   --
				z_corr = 1.37 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 19 then   --
				z_corr = 1.39 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 15 then   --
				z_corr = 1.41 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 13 then   --
				z_corr = 1.43 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 11 then   --
				z_corr = 1.45 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 9 then   --
				z_corr = 1.47 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 7 then   --
				z_corr = 1.49 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 5 then   --
				z_corr = 1.51 * z_corr
			elseif math.abs(sges_nosewheel[0]) <= 5 then
				z_corr = 1.54 * z_corr --when the tug is in the aircraft axis; it is at nominal distance from the nose wheel
			end
		else

			if math.abs(sges_nosewheel[0]) > 21.25 then   -- when the tug is much oriented, he is nearer the nose
				z_corr = 0.75 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 21 then   --
				z_corr = 0.77 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 20.75 then   --
				z_corr = 0.79 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 20.50 then   --
				z_corr = 0.81 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 20.25 then   --
				z_corr = 0.87 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 20 then   --
				z_corr = 0.90 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 19.75 then   --
				z_corr = 0.93 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 19.5 then   --
				z_corr = 0.95 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 19.25 then   --
				z_corr = 1.00 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 19 then   --
				z_corr = 1.02 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 18.75 then   --
				z_corr = 1.04 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 18.5 then   --
				z_corr = 1.02 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 18.25 then   --
				z_corr = 1.0 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 18 then   --
				z_corr = 0.98* z_corr
			elseif math.abs(sges_nosewheel[0]) > 17.75 then   --
				z_corr = 1.00 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 17.5 then   --
				z_corr = 1.03 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 17.25 then   --
				z_corr = 1.06 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 17.00 then   --
				z_corr = 1.08 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 16.5 then   --
				z_corr = 1.10 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 16.0 then   --
				z_corr = 1.12 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 15.5 then   --
				z_corr = 1.14 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 15.0 then   --
				z_corr = 1.16 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 14.0 then   --
				z_corr = 1.18 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 13.0 then   --
				z_corr = 1.20 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 12.0 then   --
				z_corr = 1.23 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 11.0 then   --
				z_corr = 1.26 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 10.0 then   --
				z_corr = 1.28 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 9.0 then   --
				z_corr = 1.30 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 8.0 then   --
				z_corr = 1.33 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 7.5 then   --
				z_corr = 1.36 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 7.0 then   --
				z_corr = 1.37 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 6.5 then   --
				z_corr = 1.38 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 6.0 then   --
				z_corr = 1.39 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 5.5 then   --
				z_corr = 1.42 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 5.0 then   --
				z_corr = 1.45 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 4.5 then   --
				z_corr = 1.48 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 4.0 then   --
				z_corr = 1.50 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 3.5 then   --
				z_corr = 1.51 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 3.0 then   --
				z_corr = 1.52 * z_corr
			elseif math.abs(sges_nosewheel[0]) > 2.5 then   --
				z_corr = 1.53 * z_corr
			elseif math.abs(sges_nosewheel[0]) <= 2.5 then
				z_corr = 1.54 * z_corr --when the tug is in the aircraft axis; it is at nominal distance from the nose wheel
			end
		end
		-- when using betterpushback tractor :
		if betterpushback_installed then
			z_corr = z_corr + 3.4
		end

		-- LATERAL CORRECTIONS WHEN THE TUG TURNS

		--~ if Prefilled_PushBack1Object == Native_PushBack_Tug  then
			--~ lateral_move =  x_corr + 0.057 * sges_nosewheel[0]
			--print("lateral_move " .. lateral_move)
		if not string.find (Prefilled_PushBack1Object,"MisterX_Lib")   then
			if math.abs(sges_nosewheel[0]) > 20.5  then lateral_move =  x_corr +0.02 * sges_nosewheel[0] --print("max turn for the bigger pushback tractor")
			elseif math.abs(sges_nosewheel[0]) > 20.25  then lateral_move =  x_corr +0.02 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 20.00  then lateral_move =  x_corr +0.020 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 19.75  then lateral_move =  x_corr +0.025 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 19.5    then lateral_move =  x_corr +0.030 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 19.25  then lateral_move =  x_corr +0.035 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 19.0  then lateral_move =  x_corr +0.03 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 18.5  then lateral_move =  x_corr +0.04 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 18   then lateral_move =  x_corr +0.05 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 17.5  then lateral_move =  x_corr +0.06 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 17  then lateral_move =  x_corr +0.07 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 16.5   then lateral_move =  x_corr +0.07 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 16   then lateral_move =  x_corr +0.068 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 15   then lateral_move =  x_corr +0.065 * sges_nosewheel[0]
			elseif math.abs(sges_nosewheel[0]) > 14   then lateral_move =  x_corr +0.060 * sges_nosewheel[0] --print("max turn for the little pushback tractor")
			elseif math.abs(sges_nosewheel[0]) > 13  then lateral_move =  x_corr +0.055 * sges_nosewheel[0]
			else lateral_move =  x_corr +0.05 * sges_nosewheel[0]
			end
			if Prefilled_PushBack1Object == Native_PushBack_Tug then
				if math.abs(sges_nosewheel[0]) < 19 then
					lateral_move = 1 * lateral_move
				else
					lateral_move = 4 * lateral_move
				end
			end
		elseif math.abs(sges_nosewheel[0]) > 18 and string.find (Prefilled_PushBack1Object,"MisterX_Lib")   then
			lateral_move =  x_corr +0.07 * sges_nosewheel[0]
		else
			lateral_move =  x_corr +0.05 * sges_nosewheel[0]
		end


		--~ if PLANE_ICAO == "A3ST" then
			--~ coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_move, gear1Z + 0.01*gear1Z + 6.8 + z_corr, sges_gs_plane_head[0] )
		--~ else
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_move, gear1Z + 0.01*gear1Z + 5.45 + z_corr, sges_gs_plane_head[0] )
		--~ end
		objpos_value[0].x = g_shifted_x
		objpos_value[0].z = g_shifted_z
		--~ if math.abs(sges_nosewheel[0]) > 21.75 then   --turnratenoroll
			--~ objpos_value[0].heading = sges_gs_plane_head[0] - 2.3 * sges_nosewheel[0]
		--~ elseif math.abs(sges_nosewheel[0]) > 21.50 then   --turnratenoroll
			--~ objpos_value[0].heading = sges_gs_plane_head[0] - 2.2 * sges_nosewheel[0]

		if Prefilled_PushBack1Object == Native_PushBack_Tug then
			scalling_heading_factor = 0.45
		else
			scalling_heading_factor = 1
		end


		if math.abs(sges_nosewheel[0]) > 35 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 2.1 * last_heading * scalling_heading_factor
			-- the truck wont' turn more even if turning force goes on.
		elseif math.abs(sges_nosewheel[0]) > 21.25 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 2.1 * sges_nosewheel[0] * scalling_heading_factor
			last_heading = sges_nosewheel[0]
		elseif math.abs(sges_nosewheel[0]) > 21 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 1.9 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 20.75 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 1.8 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 20.50 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 1.7 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 20.25 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 1.6 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 20 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 1.5 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 19.75 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 0.9 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 19.5 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 0.4 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 19.25 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] - 0.2 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 19 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 0.2 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 18.75 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 0.4 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 18.5 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 0.6 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 18.25 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 0.8 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 18 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 1.0 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 17.75 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 1.2 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 17.5 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 1.35 * sges_nosewheel[0] * scalling_heading_factor
		elseif math.abs(sges_nosewheel[0]) > 17.25 then   --turnratenoroll
			objpos_value[0].heading = sges_gs_plane_head[0] + 1.5 * sges_nosewheel[0] * scalling_heading_factor
		else
			objpos_value[0].heading = sges_gs_plane_head[0] + 1.5  * sges_nosewheel[0] * scalling_heading_factor
		end
		-- when using MisterX tractor :
		if string.find(Prefilled_PushBack1Object,"MisterX_Lib") then
			objpos_value[0].heading = objpos_value[0].heading + 180
		end
		--
		-- we fix human as tractor :
		if Prefilled_PushBack1Object == Prefilled_PassengerMilObject then
			objpos_value[0].heading = objpos_value[0].heading + 180
		end
		-- when using betterpushback tractor :
		if betterpushback_installed then
			objpos_value[0].heading = objpos_value[0].heading + 180
		end
		-- When using X-Plane Tug (added 2025-10-09)
		if Prefilled_PushBack1Object == Native_PushBack_Tug then
			objpos_value[0].heading = objpos_value[0].heading + 180
		end
		acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
		float_value[0] = 0
		float_addr = float_value
		objpos_value[0].y = acft_y
		if betterpushback_installed then objpos_value[0].y = objpos_value[0].y + 0.35 end
		if wetness == 1 and math.abs(sges_gs_plane_y[0]-acft_y) > 5 then
			objpos_value[0].y = sges_gs_plane_y[0] + ref_to_default  + SGES_Vertical_position_gear_strut_extended[0]  - SGES_strut_compression[0] - 0.05
			--print("compression : " .. SGES_strut_compression[0] .. " strut length : " .. SGES_Vertical_position_gear_strut_extended[0])
			--- 0.05 is the captain approximation :-)
		end
		objpos_addr = objpos_value
		--if wetness == 0 then
			XPLM.XPLMInstanceSetPosition(PB_instance[1], objpos_addr, float_addr)    -- TOW TRACTOR
		--~ else
			--~ show_PB = false
		--~ end
				-- store final position
		PB1FinalX = lateral_move
		PB1FinalY = gear1Z + 0.01*gear1Z + 5.45 + z_corr

		-- That human driver needs reposition in relation to the pushback object
		-- Moreover, draw the driver only if it is the normal, big, tractor :
		if string.find(Prefilled_PushBack1Object,"Tow_Tractor_2") or Prefilled_PushBack1Object == Native_PushBack_Tug then
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_move, gear1Z + 0.01*gear1Z + 5.45 + z_corr + 0.45 , sges_gs_plane_head[0] )
			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			objpos_value[0].y = acft_y + 0.4
			--~ if sges_nosewheel[0] < -2 or sges_nosewheel[0] > 2 then objpos_value[0].y = acft_y - 4 end -- hide austin when turning (limitation of re-using this object)
			if Prefilled_PushBack1Object == Native_PushBack_Tug then objpos_value[0].heading = objpos_value[0].heading + 180 end
			float_addr = float_value
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(GenericDriver_instance[0], objpos_addr, float_addr)    -- GENERIC DRIVER
					-- store final position
			GDriverFinalX = lateral_move
			GDriverFinalY = gear1Z + 0.01*gear1Z + 5.45 + z_corr + 0.45
		end

		-- wingwalkers  wing walkers

		if gear1X ~= nil and gear1Z ~= nil  and not show_Baggage then
			if Baggage_instance[4] ~= nil then

				if SGES_handler4_timer == nil then SGES_handler4_timer = SGES_total_flight_time_sec end

				if baggage_x4 == nil then
					if math.abs(BeltLoaderFwdPosition) > 10 then
						baggage_x4 = gear1X - 12
					else
						baggage_x4 = gear1X - 8
					end
				end
				if baggage4_angle == nil then baggage4_angle = -45 end
				if baggage_z4 == nil then baggage_z4 = gear1Z + 2.5 end

				if baggage_z4 > gear1Z - 1.75* math.abs(BeltLoaderFwdPosition) then baggage_x4 = baggage_x4 - 0.01 baggage_z4 = baggage_z4 - 0.0202 baggage4_angle = -45
				else
					if SGES_yoke_pitch_ratio ~= nil and SGES_yoke_pitch_ratio <= -0.05 and pushback_manual ~= nil and pushback_manual then
						baggage4_angle = 180
					else
						baggage4_angle = 0
					end
					wingwalker1_greenflag = true
				end
				draw_static_object(baggage_x4,baggage_z4,baggage4_angle,Baggage_instance[4],"Baggage4")
			end
			-- rear human :
			if Baggage_instance[3] ~= nil then
				if baggage_x3 == nil then
					if math.abs(BeltLoaderFwdPosition) > 10 then
						baggage_x3 = gear1X + 12
					else
						baggage_x3 = gear1X + 8
					end
				end
				if baggage3_angle == nil then baggage3_angle = 180 end
				if baggage_z3 == nil then baggage_z3 = gear1Z + 1 end
				if baggage_z3 > gear1Z - 1.80* math.abs(BeltLoaderFwdPosition) then baggage_x3 = baggage_x3 + 0.009 baggage_z3 = baggage_z3 - 0.015 baggage3_angle = 40
				else
					if SGES_yoke_pitch_ratio ~= nil and SGES_yoke_pitch_ratio <= -0.04 and pushback_manual ~= nil and pushback_manual then
						baggage3_angle = 180
					else
						baggage3_angle = 0
					end
					wingwalker2_greenflag = true
				end

				_ = draw_static_object(baggage_x3,baggage_z3,baggage3_angle,Baggage_instance[3],"Baggage3")

				if IsPassengerPlane and baggage_x2 ~= nil and baggage_x3 ~= nil then
					if baggage_x3 > baggage_x2 + 12 or baggage_x3 > -2.5 then -- once the human handler as reached the fuselage, switch direction for the human
						baggage3_angle = -95
					elseif baggage_x3 < baggage_x2 + 0.5 then -- once the human handler as reached the cart, switch direction for the human
						baggage3_angle = 85
					end
				elseif baggage_x3 ~= nil then -- the cargo don't have all the objects and it apparently cause a different situaiton in the animation where the man never turns 180°.'
					if baggage_x3 > -1 then -- once the human handler as reached the fuselage, switch direction for the human
						baggage3_angle = -95
					elseif baggage_x3 < -20 then -- once the human handler as reached the cart, switch direction for the human
						baggage3_angle = 85
					end
				end
			end
		end
end



function execute_PUSHBACK_service_objects ()

-- ////////////////////////////// PUSH-BACK ////////////////////////////////
		--------------------------------------------------------------------------------------------------------------
		-- forces override,
		-- without deactivating the flight controls, so soft deactivation with nulling alpha and speeds is required
		if show_PB and (Go_PB or pushback_manual) and sges_gs_gnd_spd[0] < 3 and wetness == 0 and SGES_parkbrake < 0.8 and SGES_XPlaneIsPaused == 0 and sges_EngineState[0] < 80 then
			set("sim/flightmodel/position/local_vz",0)
			set("sim/flightmodel/position/local_vy",0)
			set("sim/flightmodel/position/local_vx",0)
			set("sim/flightmodel/position/local_az",0)
			set("sim/flightmodel/position/local_ay",0)
			set("sim/flightmodel/position/local_ax",0)
			if XPLMFindDataRef("sim/operation/override/override_engine_forces") ~= nil and SGES_override_engine_forces == nil then
				dataref("SGES_override_engine_forces","sim/operation/override/override_engine_forces","writable")
			end
			if SGES_override_engine_forces ~= nil and (SGES_override_engine_forces == 0) then
				SGES_override_engine_forces = 1
				print("[Ground Equipment " .. version_text_SGES .. "] Activating the SGES pushback. SGES_override_engine_forces = " .. SGES_override_engine_forces)
			end
		elseif show_PB  and sges_gs_gnd_spd[0] < 3 and wetness == 0 and SGES_parkbrake < 0.8 and SGES_XPlaneIsPaused == 0 and sges_EngineState[0] >= 80 then
			if SGES_override_engine_forces ~= nil and SGES_override_engine_forces == 1 then
				SGES_override_engine_forces = 0
				print("[Ground Equipment " .. version_text_SGES .. "] Engine force bypassing the SGES pushback. SGES_override_engine_forces = " .. SGES_override_engine_forces)
			end
		end

		--------------------------------------------------------------------------------------------------------------
		-- configuring the push-back
		if show_PB and (Go_PB or pushback_manual) and sges_gs_gnd_spd[0] < 3 and wetness == 0 and SGES_parkbrake < 0.8 and SGES_XPlaneIsPaused == 0 and
		  (
		  (SelfPushback_requested == false and show_WingWalkers and (wingwalker1_greenflag or wingwalker2_greenflag)) --MANUAL PUSH WITH WW
		   or (pushback_manual and SelfPushback_requested == false and not show_WingWalkers) --MANUAL PUSH WITHOUT WW
		   or (Go_PB and SelfPushback_requested == false and show_WingWalkers == false)  -- REMOVED WINGWALKERS WHEN THEY WERE THERE
		   or (Go_PB and SelfPushback_requested)  -- AUTOPUSH
		   ) then

			if SGES_pushback_start_time == -99 then
				SGES_pushback_start_time = os.clock() + SGES_pushback_start_delay
				print("[Ground Equipment " .. version_text_SGES .. "] Going to start the push back in less than " .. SGES_pushback_start_delay .. " seconds.")
			end

		   if os.clock() > SGES_pushback_start_time then

				--~ if pushback_manual == false then
					--~ load_WingWalkers()
					--~ show_WingWalkers = false
					--~ PB_chg = true
					--~ remove_wingwalkers()
				--~ end

				local force_factor = -0.02
				if sges_EngineState[0] > 20 then force_factor = -0.03 end
				--~ if sges_EngineState[0] > 30  then
						--~ adjust_Strength = true
				--~ end
				if force_factor_forced ~= -0.02 then force_factor = force_factor_forced end

				if  pushback_manual then
					force_factor = -0.04*SGES_yoke_pitch_ratio
					--~ if string.match(AIRCRAFT_PATH,"JF12_BAe_146") then
						--~ force_factor = -10*SGES_yoke_pitch_ratio
						--~ print("force_factor : " .. force_factor)
					--~ end
					--print("manual " .. force_factor)
					SelfPushback_requested = false
					show_TargetSelfPushback = false
					TargetSelfPushback_chg = true
					service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
				end



				if show_Cones and wingwalker1_greenflag and wingwalker2_greenflag then show_Cones = false Cones_chg = true end

				if math.abs(sges_nosewheel[0]) > 0.2 then set("sim/flightmodel/position/Rrad",-SGES_pushTurn_ratio/17)  -- change the heading before applying coordinates translations
				else set("sim/flightmodel/position/Rrad",-SGES_pushTurn_ratio/50) end -- limited autority in this case, but not zero as before version 61


				-- Self pushback semi-intelligent function :
				if SelfPushback_requested then
					-- turn as required
					-- POSITIVE FWD < z > NEGATIVE AFT()

					--- just a sound to clear for start :
					if cleared_to_start_played == false and os.time() > SGES_startPB_time + 0.25*math.abs(SPB_distance) and
					(( math.abs(sges_gs_plane_x[0]) > math.abs(TargetSelfPushbackX_stored) - radius_pushback *1.5 and
					   math.abs(sges_gs_plane_x[0]) < math.abs(TargetSelfPushbackX_stored) + radius_pushback *1.5 ) and -- or is easing
					 ( math.abs(sges_gs_plane_z[0]) > math.abs(TargetSelfPushbackZ_stored) - radius_pushback *1.5 and
					   math.abs(sges_gs_plane_z[0]) < math.abs(TargetSelfPushbackZ_stored) + radius_pushback *1.5 )) then
						if SGES_sound then
							play_sound(Clear_to_start_sound)
						end
						print("[Ground Equipment " .. version_text_SGES .. "] Cleared to start...")
						cleared_to_start_played = true
					end

					-- critical : start the turn
					if turn_flag == false and os.time() > SGES_startPB_time + 0.25*math.abs(SPB_distance) and
					(( math.abs(sges_gs_plane_x[0]) > math.abs(TargetSelfPushbackX_stored) - radius_pushback and
					   math.abs(sges_gs_plane_x[0]) < math.abs(TargetSelfPushbackX_stored) + radius_pushback ) and
					 ( math.abs(sges_gs_plane_z[0]) > math.abs(TargetSelfPushbackZ_stored) - radius_pushback and
					   math.abs(sges_gs_plane_z[0]) < math.abs(TargetSelfPushbackZ_stored) + radius_pushback )) then -- or is facilitating
						print("[Ground Equipment " .. version_text_SGES .. "] Start the turn for push-back by radius_pushback to aiming point (and time) " .. radius_pushback)
						final_heading = false
						turn_flag = true
						speed_reduction_factor = 1
					end

					-- avoid overrunning the stopping area by reducing the longitudinal push force
					if turn_flag and not final_heading and speed_reduction_factor <= maximum_speed_reduction_factor + 0.01 and

						(
						(( math.abs(sges_gs_plane_x[0]) > math.abs(TargetSelfPushbackX_stored) - radius_pushback / 2.5 and
						   math.abs(sges_gs_plane_x[0]) < math.abs(TargetSelfPushbackX_stored) + radius_pushback / 2.5 ) and
						 ( math.abs(sges_gs_plane_z[0]) > math.abs(TargetSelfPushbackZ_stored) - radius_pushback / 2.5 and
						   math.abs(sges_gs_plane_z[0]) < math.abs(TargetSelfPushbackZ_stored) + radius_pushback / 2.5 ))

					   or -- when plane is aleady engaged in reduction and we don't want to interrupt the drop in speed
							speed_reduction_factor > 1.02
						)
						then
						--~ print(speed_reduction_factor) -- for dev
						if speed_reduction_factor == 1 then print("[Ground Equipment " .. version_text_SGES .. "] Reducing the push force to reach the aiming point.") end
						--~ if speed_reduction_factor == maximum _speed_reduction_factor then print("[Ground Equipment " .. version_text_SGES .. "] Push force reduced now.") end
						if speed_reduction_factor < maximum_speed_reduction_factor then speed_reduction_factor = speed_reduction_factor + 0.01 end -- smooth !
						force_factor = force_factor / speed_reduction_factor

					elseif turn_flag and final_heading and speed_reduction_factor > 1 and os.time() < SGES_stopPB_time then
						if speed_reduction_factor >= maximum_speed_reduction_factor then print("[Ground Equipment " .. version_text_SGES .. "] Augmenting the push force back to normal. " .. speed_reduction_factor) end
						if speed_reduction_factor > 1.01 then speed_reduction_factor = speed_reduction_factor - 0.01 end -- smooth !
						force_factor = force_factor / speed_reduction_factor
					end

					if turn_flag then -- turn when approaching target vicinity

						if math.abs(sges_gs_plane_head[0]) > math.abs(TargetSelfPushbackH_stored) - 1 and math.abs(sges_gs_plane_head[0]) < math.abs(TargetSelfPushbackH_stored) + 1 and final_heading == false then
							final_heading = true
							incremental_degrees = 0
							-- save the timing to stop the pushback
							print("[Ground Equipment " .. version_text_SGES .. "] Approaching intended position. Heading target : " .. math.floor(TargetSelfPushbackH_stored) .. "° Plane heading : " .. math.floor(sges_gs_plane_head[0]) .. "°")

							if (SPB_orientation > -1* center_line_sticky_heading_threshold and SPB_orientation < center_line_sticky_heading_threshold) then
								SGES_stopPB_delay = 35 -- ok, checked with the B738
							else
								SGES_stopPB_delay = 13 -- ok, checked
							end
							SGES_stopPB_time = os.time() + SGES_stopPB_delay

							--Go_PB = false
						elseif SPB_orientation <= -center_line_sticky_heading_threshold  and final_heading == false  then
							incremental_degrees = -0.03
							if math.abs(BeltLoaderFwdPosition) < 5 then
								set("sim/flightmodel/position/Rrad",-0.052)
							else
								set("sim/flightmodel/position/Rrad",-0.049)
							end
							final_heading = false
							--print("TURN nose to the left. Heading target : " .. math.floor(TargetSelfPushbackH_stored) .. "° Plane heading : " .. math.floor(sges_gs_plane_head[0]) .. "°")
							--~ -- save the timing to stop the pushback
							--~ SGES_stopPB_delay = 4
							--~ SGES_stopPB_time = os.time() + SGES_stopPB_delay
						elseif SPB_orientation >= center_line_sticky_heading_threshold and final_heading == false   then
							incremental_degrees = 0.03
							if math.abs(BeltLoaderFwdPosition) < 5 then
								set("sim/flightmodel/position/Rrad",0.052)
							else
								set("sim/flightmodel/position/Rrad",0.049)
							end
							final_heading = false
							--print("TURN nose to the right. Heading target : " .. math.floor(TargetSelfPushbackH_stored) .. "° Plane heading : " .. math.floor(sges_gs_plane_head[0]) .. "°")
							--~ -- save the timing to stop the pushback
							--~ SGES_stopPB_delay = 4
							--~ SGES_stopPB_time = os.time() + SGES_stopPB_delay
						end
						--update_quaternion(0,0,gs_plane_head+incremental_degrees) --update_quaternion(pitch,roll,yaw) -- tighten the turn -- BUT SLIDES LATERALLY ?
					end

					if os.time() >= SGES_stopPB_time and turn_flag and speed_reduction_factor < 10 then
					-- going to stop but add a smoothing in reducing the tractor speed
						if os.time() < SGES_stopPB_time + 0.01 and speed_reduction_factor < 1.03 then print("[Ground Equipment " .. version_text_SGES .. "] Reducing the push back roll speed. " .. speed_reduction_factor) end
						if speed_reduction_factor < 10 then speed_reduction_factor = speed_reduction_factor + 0.01 end -- smooth !
						force_factor = force_factor / speed_reduction_factor

					elseif os.time() >= SGES_stopPB_time and turn_flag then
							speed_reduction_factor = 1 -- reset
							--print("STOP PB by timing after turn")
							Go_PB = false
							turn_flag = false
							speed_reduction_factor = 1 -- reset
							set("sim/flightmodel/position/local_vz",0)
							set("sim/flightmodel/position/local_vy",0)
							set("sim/flightmodel/position/local_vx",0)
							set("sim/flightmodel/position/local_az",0)
							set("sim/flightmodel/position/local_ay",0)
							set("sim/flightmodel/position/local_ax",0)
							set("sim/flightmodel/position/Rrad",0)

							show_TargetSelfPushback = false
							TargetSelfPushback_chg = true
							service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)

							print("[Ground Equipment " .. version_text_SGES .. "] Set the parking brake.")
							if ((test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") ) or Prefilled_PushBackObject ==	SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj" then
								show_People2 = true
								People2_chg = true
							else
								show_People1 = true
								People1_chg = true
							end

							if (test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
								set("1-sim/service/lights/emerlights",0)
								set("1-sim/service/lights/backheadlight",0)
								set("1-sim/service/lights/frontheadlight",1)
								set("1-sim/service/lights/backredlight",0)
							end

							if SGES_sound then
								play_sound(Set_ParkBrake_sound)
							end
							final_heading = false
							if SGES_override_engine_forces ~= nil and SGES_override_engine_forces == 1 then
								SGES_override_engine_forces = 0
								set("sim/operation/override/override_wing_forces",0) -- important
								print("[Ground Equipment " .. version_text_SGES .. "] Set the parking brake. SGES_override_engine_forces = " .. SGES_override_engine_forces)
							end
					end



					-- backup stop :
					if math.abs(sges_gs_plane_x[0]) > math.abs(TargetSelfPushbackX_stored) - 0.005 and math.abs(sges_gs_plane_x[0]) < math.abs(TargetSelfPushbackX_stored) + 0.005 and math.abs(sges_gs_plane_z[0]) > math.abs(TargetSelfPushbackZ_stored) - 0.005 and math.abs(sges_gs_plane_z[0]) < math.abs(TargetSelfPushbackZ_stored) + 0.005 then
							print("[Ground Equipment " .. version_text_SGES .. "]  STOP PB by vicinity to aimed position")
							Go_PB = false
							turn_flag = false
							set("sim/flightmodel/position/local_vz",0)
							set("sim/flightmodel/position/local_vy",0)
							set("sim/flightmodel/position/local_vx",0)
							set("sim/flightmodel/position/local_az",0)
							set("sim/flightmodel/position/local_ay",0)
							set("sim/flightmodel/position/local_ax",0)
							set("sim/flightmodel/position/Rrad",0)
							show_TargetSelfPushback = false
							TargetSelfPushback_chg = true
							service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
							if SGES_sound then
								play_sound(Set_ParkBrake_sound)
							end
							SelfPushback_requested = false
							show_TargetSelfPushback = false
							TargetSelfPushback_chg = true
							final_heading = false
							turn_flag = false
							TargetSelfPushbackH_stored = -999
							TargetSelfPushbackX_stored = 0
							TargetSelfPushbackZ_stored = 0
							SGES_stopPB_time = 9999999999999
							SGES_startPB_time = SGES_stopPB_time
							SGES_stopPB_delay = 0
							SPB_distance = 38 -- minimal pushback to take into account the braking radius
							SPB_orientation = 0
							if SGES_override_engine_forces ~= nil and SGES_override_engine_forces == 1 then
								SGES_override_engine_forces = 0
								set("sim/operation/override/override_wing_forces",0) -- important
								print("[Ground Equipment " .. version_text_SGES .. "] STOP PB by vicinity. SGES_override_engine_forces = " .. SGES_override_engine_forces)
							end
					end

				end


				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, force_factor, sges_gs_plane_head[0])
				set("sim/flightmodel/position/local_x",g_shifted_x)
				set("sim/flightmodel/position/local_z",g_shifted_z)
			end

		elseif show_PB and not Go_PB and SGES_parkbrake < 0.8 and wetness == 0 then
			-- acft attached and locked
			set("sim/flightmodel/position/local_vz",0)
			set("sim/flightmodel/position/local_vy",0)
			set("sim/flightmodel/position/local_vx",0)
			set("sim/flightmodel/position/local_az",0)
			set("sim/flightmodel/position/local_ay",0)
			set("sim/flightmodel/position/local_ax",0)
			set("sim/flightmodel/position/Rrad",0)
			--~ adjust_Strength = true
		elseif show_PB and (show_People1 or show_People2) and Go_PB == false and pushback_manual == false and turn_flag == false and show_TargetSelfPushback == false and SGES_parkbrake > 0.8 then
			if (test_777v2_a or test_777v2_b or test_777v2_c) and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
				set("1-sim/service/lights/emerlights",0)
				set("1-sim/service/lights/backheadlight",0)
				set("1-sim/service/lights/frontheadlight",1)
				set("1-sim/service/lights/backredlight",0)
			end
			show_PB = false
			PB_chg = true
			show_People1 = false
			People1_chg = true
			show_People2 = false
			People2_chg = true
			print("[Ground Equipment " .. version_text_SGES .. "] Disconnecting tow.")
			if SGES_sound then
				play_sound(Tow_disconnected_sound)
			end
			-- reset
			SelfPushback_requested = false
			show_TargetSelfPushback = false
			TargetSelfPushback_chg = true
			final_heading = false
			turn_flag = false
			TargetSelfPushbackH_stored = -999
			TargetSelfPushbackX_stored = 0
			TargetSelfPushbackZ_stored = 0
			SGES_stopPB_time = 9999999999999
			SGES_startPB_time = SGES_stopPB_time
			SGES_stopPB_delay = 0
			SPB_distance = 38 -- minimal pushback to take into account the braking radius

			if SGES_override_engine_forces ~= nil and SGES_override_engine_forces == 1 then
				SGES_override_engine_forces = 0
				set("sim/operation/override/override_wing_forces",0) -- important
				print("[Ground Equipment " .. version_text_SGES .. "] Disconnecting tow. SGES_override_engine_forces = " .. SGES_override_engine_forces)
			end
		end

	-- make it compatible with an aircaft carrier at sea (2022 10 23)
		if show_PB and pushback_manual and sges_gs_gnd_spd[0] <= 17 and wetness == 1 and SGES_parkbrake < 0.8 then
			-- make the aircraft carrier truck more powerfull
			local force_factor = -0.05*SGES_yoke_pitch_ratio
			if math.abs(SGES_pushTurn_ratio) > 0.25 then set("sim/flightmodel/position/Rrad",-SGES_pushTurn_ratio/10) end -- change the heading before applying translations
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, force_factor, sges_gs_plane_head[0])
			set("sim/flightmodel/position/local_x",g_shifted_x)
			set("sim/flightmodel/position/local_z",g_shifted_z)
		end

	-- Exit the P-B
		if show_PB and sges_gs_gnd_spd[0] > 3 and wetness == 0 then -- change from 3 to 16 for carrier pushback over the sea
			set("sim/flightmodel/position/local_vz",0)
			set("sim/flightmodel/position/local_vy",0)
			set("sim/flightmodel/position/local_vx",0)
			set("sim/flightmodel/position/local_az",0)
			set("sim/flightmodel/position/local_ay",0)
			set("sim/flightmodel/position/local_ax",0)
			set("sim/flightmodel/position/Rrad",0)
		elseif show_PB and sges_gs_gnd_spd[0] > 17 then -- change from 3 to 17 for carrier pushback over the sea
			--XPLMSpeakString("Push back disconnected. Goodbye.")
			Go_PB = false
			show_PB = false
			PB_chg = true
		end
	-- ////////////////////////////// PUSHBACK /////////////////////////////////
	--return force_factor
end
print("[Ground Equipment " .. version_text_SGES .. "] The sub-script Pushback.lua is ready for action, good !")
