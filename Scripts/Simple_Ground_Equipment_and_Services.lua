-- By XPJavelin, contributions from "RamdomUser" at xplane.org
--    --------------------------------------------------------------------------
--          LICENSE
--    --------------------------------------------------------------------------
--    Copyright (c) 2022,, 2023, 2024 XPJavelin

--    Permission is hereby granted, free of charge, to any person obtaining a copytargetDoorX_alternate
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


--------------------------------------------------------------------------------
-- Simple Ground Equipment & Services
-- aka The Poor Man Ground Services --------------------------------------------
version_text_SGES = "77.2"
--------------------------------------------------------------------------------
--[[





        USERS SHOULD NOT CHANGE ANYTHING HERE, PLEASE REPORT YOURSELF TO THE USER CONFIG FILE






]]
SGES_start_delay = 0
SGES_start_time = os.clock() + SGES_start_delay
SGES_loaded = false
local rebours_delay = 2
PLANE_ICAO_exclusions_t = {}
read_the_SGES_startup_options_delayed_elapsed = false
print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " will be loaded after a delay of " .. SGES_start_delay .. " seconds.")
function delay_SGES_loading()
	if os.clock() > SGES_start_time and SGES_loaded == false then

		SGES_loaded = true

		-- make a ding to warn SGES is loaded !



		-- now we read if "true" is allowed (the user can now exclude certain aircraft types from triggering SGES) :
		dofile(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_EXCLUSIONS_Aircraft_list.lua")
		-- SGES_script() -- critical launch deported into the exclusion file
		-- check if the current aircraft PLANE_ICAO was excluded in the exclusion list :
		exclusion_exists = false
		local exclusion_ICAO = nil
		for item=1,5 do -- table starts at 1, not zero !
			exclusion_ICAO = 	tostring(PLANE_ICAO_exclusions_t[item])
			--print(item .. " " .. exclusion_ICAO .. "\n")
			if PLANE_ICAO == exclusion_ICAO then exclusion_exists = true end
			if exclusion_exists then break end
		end
		if exclusion_exists then
			print("====\n\n[Ground Equipment " .. version_text_SGES .. "] This aircraft (" .. PLANE_ICAO .. ") prevents Simple Ground Equipment & Services to run because it is volontarily written in your exclusion list to do so.\n\n====")
		else
			print("====================================\n\n[Ground Equipment " .. version_text_SGES .. "] To prevent activating me, you may write up to five aircraft codes in Simple_Ground_Equipment_and_Services_EXCLUSIONS_Aircraft_list.lua\n")

			SGES_script()					-- Do not edit this line
			print("[Ground Equipment " .. version_text_SGES .. "] Loading at " .. string.format("%02d",SGES_zulu_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " Z   " .. string.format("%02d",SGES_local_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " Loc.    " .. string.format("%02d",os.date("%H")) .. "h" ..  string.format("%02d",os.date("%M")) .. " at real computer time")
			-- we need functions, even if the script is loaded in the air :
			dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Specific_airports.lua") -- big airports with specific ground services
		end

	end

	if os.clock() > SGES_start_time + rebours_delay * SGES_start_delay and read_the_SGES_startup_options_delayed_elapsed == false and not exclusion_exists then

		startup_options__delayed() -- important, services whished at startup
		-- but a delay is required to allow the situation and plane to settle
		read_the_SGES_startup_options_delayed_elapsed = true
		-- remark : for display, change the variable "rebours" if you change the delay above
	end
end

do_sometimes("delay_SGES_loading()")



function SGES_script()

	function file_exists(name)
		local f=io.open(name,"r")
		if f~=nil then io.close(f) return true else return false end
	end


	-- test it is x-plane 12 instead of 11
	if IsXPlane12 == nil then IsXPlane12 = false  IsXPlane1209 = false IsXPlane1211 = false end-- safety

	if XPLMFindDataRef("sim/version/xplane_internal_version") ~= nil then
		if SGES_xplane_internal_version == nil 		then  SGES_xplane_internal_version = get("sim/version/xplane_internal_version") end
		print("[Ground Equipment " .. version_text_SGES .. "] sim/version/xplane_internal_version " .. SGES_xplane_internal_version .. ".")
		if string.find(SGES_xplane_internal_version,"12") then
			IsXPlane12 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane is X-Plane 12.")
		else
			IsXPlane12 = false
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane is not X-Plane 12.")
		end


		if SGES_xplane_internal_version >= 120907 then -- 3D objects changed in X-Plane 12.0.9 and subsequent editions, so we need to test that
			IsXPlane1209 = true
			print("[Ground Equipment " .. version_text_SGES .. "] Utilizing 3D objects introduced in : ")
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.0.9")
		end
		if SGES_xplane_internal_version >= 121100 then -- 3D objects changed in X-Plane 12.1.1 and subsequent editions, so we need to test that
			IsXPlane1211 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.1")
		end
		if SGES_xplane_internal_version >= 121200 then -- 3D objects changed in X-Plane 12.1.2 and subsequent editions, so we need to test that
			IsXPlane1212 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.2")
		else
			IsXPlane1212 = false
		end
		if SGES_xplane_internal_version >= 121400 then  -- I think you undestood it by now.
			IsXPlane1214 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.4")
		else
			IsXPlane1214 = false
		end
		if SGES_xplane_internal_version >= 122000 then  -- I think you undestood it by now.
			IsXPlane1220 = true -- true !
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.2.0")
		else
			IsXPlane1220 = false
		end
		if SGES_xplane_internal_version >= 122100 then
			IsXPlane1221 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.2.1")
		else
			IsXPlane1221 = false
		end
		if SGES_xplane_internal_version >= 123000 then
			IsXPlane1230 = true
			print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.3.0")
		else
			IsXPlane1230 = false
		end
	end
	----------------------------------------------------------------------------
	-- FOR DEVELOPMENT PURPOSE -------------------------------------------------
	--~ IsXPlane12 = false  IsXPlane1209 = false IsXPlane1211 = false -- do not activate this -- only for XPJavelin
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------

	IsSimcoders = false
	if XPLMFindDataRef("simcoders/rep/landinggear/tires/show_chocks_2") ~= nil then
		IsSimcoders = true
		print("[Ground Equipment " .. version_text_SGES .. "] REP from simcoders detected.")
	end

	if XPLMFindDataRef("opensam/jetway/status") ~= nil then
		sges_openSAM 		= dataref_table("opensam/jetway/status")
		print("[Ground Equipment " .. version_text_SGES .. "] openSAM, an open source replacement for SAM, detected. https://forums.x-plane.org")
	else
		print("[Ground Equipment " .. version_text_SGES .. "] openSAM not installed or dataref 'opensam/jetway/status' not found.")
	end


	SGES_stopPB_time = 9999999999999
	SGES_startPB_time = SGES_stopPB_time
	SGES_stopPB_delay = 0

	--########################################
	--#  CLOCK                               #
	--########################################
	-- keep track of the current time
	-- init :
	sges_current_time = math.floor(os.clock())
	--	then update :
	function SGESTime()
		sges_current_time = math.floor(os.clock())
	end
	print("[Ground Equipment " .. version_text_SGES .. "] Loading SGESTime() function in main")
	do_every_frame("SGESTime()") -- mind the constraint : DO NOT MOVE that function
	--########################################

	-- -----------------------------------------------------------------------------
	if not SUPPORTS_FLOATING_WINDOWS then
		-- to make sure the script doesn't stop old FlyWithLua versions
		logMsg("imgui not supported by your FlyWithLua version")
		return
	end

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
	  void XPLMSetAircraftModel(int                  inIndex, const char *         inAircraftPath );

	  typedef void *XPLMDataRef;
      XPLMDataRef XPLMFindDataRef(const char *inDataRefName);
      int  XPLMGetDatab(XPLMDataRef          inDataRef,
                         void *               outValue,    /* Can be NULL */
                         int                  inOffset,
                         int                  inMaxBytes);
	]]

	-- 	  void XPLMSetAircraftModel(int                  inIndex, const char *         inAircraftPath ); -- is for threat module





	-- add these types to the FFI:
	ffi.cdef(cdefs)


	-- Variables to handle C pointers
	local char_str = ffi.new("char[256]")


	local datarefs_addr = ffi.new("const char**")
	local dataref_name = ffi.new("char[150]")         -- define the length of the string to store the name of the dataref. can be longer but not shorter

	local dataref_register7 = ffi.new("XPLMDataRef")
	local dataref_array2 = ffi.new("const char*[2]")  -- this is for the signboard, one dataref and one null dataref

	--========= Update below for new objects to draw =================
	local proberef = ffi.new("XPLMProbeRef")           -- for the probe
	local rampserviceref0 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref1 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref2 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref3 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref4 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref4L = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref5 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref6 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref7 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref7L = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref8 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref8h = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampservicerefPRM = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampservicerePRM2 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref9 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref52 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref53 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref71 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampserviceref71L = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref710 = ffi.new("XPLMObjectRef")            -- for the ground service
	 rampserviceref72 = ffi.new("XPLMObjectRef")            -- for the ground serviceULD
	 rampserviceref722 = ffi.new("XPLMObjectRef")            -- for the ground serviceULD plate
	local rampserviceref73 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref74 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref75 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref76 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref91 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref92 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref93 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref100 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref101 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref102 = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampserviceref200 = ffi.new("XPLMObjectRef")            -- for the ground light
	local rampserviceref300 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	local rampserviceref301 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	local rampserviceref302 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	local rampserviceref303 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	rampserviceref304 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	rampserviceref305 = ffi.new("XPLMObjectRef")            -- for the custom stairs
	rampservicerefTargetMarker = ffi.new("XPLMObjectRef")            -- for the Target Marker, not local, but global
	local rampservicerefTargetSelfPushback = ffi.new("XPLMObjectRef")            -- for the Target Marker
	local rampservicerefASU_ACU = ffi.new("XPLMObjectRef")
	local rampservicerefASU_ACU1 = ffi.new("XPLMObjectRef")
	local rampserviceref010 = ffi.new("XPLMObjectRef")            -- for the ground service
	 rampservicerefBo = ffi.new("XPLMObjectRef")            -- right wing traffic pole 1
	 rampservicerefBo4 = ffi.new("XPLMObjectRef")            -- right wing traffic pole 2
	local rampservicerefRBL = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampservicerefPonev = ffi.new("XPLMObjectRef")            -- for the ground service
	local rampservicerefForklift = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefGenericDriver = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefAAR = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage1 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage2 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage3 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage4 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefBaggage5 = ffi.new("XPLMObjectRef")            -- for the ground service
	rampservicerefArms = ffi.new("XPLMObjectRef")            -- for the ground service

	if IsXPlane12 then
		rampservicerefXP12Carrier = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP2 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP3 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP4 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP5 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP6 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefXP12CarrierP7 = ffi.new("XPLMObjectRef")            -- for the ground service
		rampservicerefCockpitLight = ffi.new("XPLMObjectRef")            -- for the cockpit light
		rampservicerefXP12Helicopter0 = ffi.new("XPLMObjectRef")
		rampservicerefXP12Helicopter1 = ffi.new("XPLMObjectRef")
		rampservicerefXP12Helicopter2 = ffi.new("XPLMObjectRef")
		rampservicerefXP12Helicopter3 = ffi.new("XPLMObjectRef")
	end
	if UseXplaneDefaultObject == false then -- do not arm passengers
		 Paxref0 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref1 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref2 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref3 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref4 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref5 = ffi.new("XPLMObjectRef")            -- for the ground service
		--~ for i=0,3 do
			--~ local temp_name = tostring(i)
			--~ local temp_var = "Paxref" .. temp_name
			--~ temp_var = ffi.new("XPLMObjectRef")
			--~ print("[Ground Equipment " .. version_text_SGES .. "] " .. temp_var)
		--~ end
		-- added december 2022 :
		 Paxref6 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref7 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref8 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref9 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref10 = ffi.new("XPLMObjectRef")            -- for the ground service
		 Paxref11 = ffi.new("XPLMObjectRef")            -- for the ground service
	end

	local Cones_instance = ffi.new("XPLMInstanceRef[5]")
	local GPU_instance = ffi.new("XPLMInstanceRef[1]")
	local FUEL_instance = ffi.new("XPLMInstanceRef[1]")
	local Cleaning_instance = ffi.new("XPLMInstanceRef[2]")
	local BeltLoader_instance = ffi.new("XPLMInstanceRef[3]")   -- one more for the associated cart -- one more for rear Loader
	local Stairs_instance = ffi.new("XPLMInstanceRef[1]")
	local StairsXPJ_instance = ffi.new("XPLMInstanceRef[2]")
	local StairsXPJ2_instance = ffi.new("XPLMInstanceRef[2]")
	local StairsXPJ3_instance = ffi.new("XPLMInstanceRef[2]")
	local Bus_instance = ffi.new("XPLMInstanceRef[2]")
	local Catering_instance = ffi.new("XPLMInstanceRef[2]")
	local PRM_instance = ffi.new("XPLMInstanceRef[2]")
	local FM_instance = ffi.new("XPLMInstanceRef[1]")
	local FireVehicle_instance = ffi.new("XPLMInstanceRef[4]")
	local ArrestorSystem_instance = ffi.new("XPLMInstanceRef[1]")
	local FireSmoke_instance = ffi.new("XPLMInstanceRef[1]")
	local ULDLoader_instance = ffi.new("XPLMInstanceRef[2]")
	local People4_instance = ffi.new("XPLMInstanceRef[1]")
	local People3_instance = ffi.new("XPLMInstanceRef[1]")
	local People2_instance = ffi.new("XPLMInstanceRef[1]")
	local People1_instance = ffi.new("XPLMInstanceRef[1]")
	local Ship1_instance = ffi.new("XPLMInstanceRef[2]")
	local Ship2_instance = ffi.new("XPLMInstanceRef[2]")
	local Chocks_instance = ffi.new("XPLMInstanceRef[3]")
	local Deice_instance = ffi.new("XPLMInstanceRef[3]")
	local Light_instance = ffi.new("XPLMInstanceRef[2]")
	TargetMarker_instance = ffi.new("XPLMInstanceRef[3]") -- global, not local !
	TargetSelfPushback_instance = ffi.new("XPLMInstanceRef[1]")
	PB_instance = ffi.new("XPLMInstanceRef[2]")
	local ASU_ACU_instance = ffi.new("XPLMInstanceRef[2]")
	local Passenger_instance = ffi.new("XPLMInstanceRef[12]")
	local Ponev_instance = ffi.new("XPLMInstanceRef[1]")
	local Forklift_instance = ffi.new("XPLMInstanceRef[1]")
	GenericDriver_instance = ffi.new("XPLMInstanceRef[1]")
	local AAR_instance = ffi.new("XPLMInstanceRef[1]")
	Baggage_instance = ffi.new("XPLMInstanceRef[6]") -- must not be loca, for subscript

	-- Generic
	local Instance = ffi.new("XPLMInstanceRef[5]")
	if IsXPlane12 then
		XP12Carrier_instance = ffi.new("XPLMInstanceRef[7]")
		CockpitLight_instance = ffi.new("XPLMInstanceRef[1]")
		Helicopters_instance = ffi.new("XPLMInstanceRef[4]")
		Submarine_instance = ffi.new("XPLMInstanceRef[1]")
	end
	IndustrialFire_instance = ffi.new("XPLMInstanceRef[32]") -- 31 is critical for the threat.lua



	local acft_x, acft_y, acft_z = 0, 0, 0     -- position in local coordinates

	--~ local BusFinalX = 29
	--~ local BusFinalY = 7

	local StairFinalX = targetDoorX
	local StairFinalY = targetDoorZ

	local StairHigherPartX_stairIII = StairFinalX

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

	--local Runway = ffi.new("XPLMDrawInfo_t[4]")
	Runway = {{name="Name"},{name="EndName"},{name="RunwayEnd_lat"},{name="RunwayEnd_lon"},{name="RunwayEnd_hdg"},{name="outHeading"},{name="7"},{name="8"},{name="7"},{name="8"},{name="7"},{name="8"}} -- weird


	for i=1,12 do
		Runway[i].Name = "**"
	end

	-- Access to acf_livery_path

	-- added 19th november 2023 :
	-- dataref("AircraftPath","sim/aircraft/view/acf_livery_path","readonly",0)
	-- https://forums.x-plane.org/index.php?/forums/topic/296938-with-1208-beta-12-mapping-simaircraftviewacf_livery_path-sends-fwl-into-an-internal-loop/&page=2#comment-2633523
	-- If you followed the discussion in the FWL forum you may have noticed that this particular dataref is not the best candidate for retrieval through the "modern"  FWL dataref interface.
    -- With the attached code snippet it can be retrieved when needed through the ffi interface and that may be a more future proof solution.
    local acf_livery_path_dr = ffi.new("XPLMDataRef")
    local acf_livery_path_dr = XPLM.XPLMFindDataRef("sim/aircraft/view/acf_livery_path");
	local buffer  = ffi.new("char[256]")
    local n = XPLM.XPLMGetDatab(acf_livery_path_dr, buffer, 0, 255)
    AircraftPath = ffi.string(buffer)
    --print("\nacf_livery_path='" .. AircraftPath .. "'\n")
	--===========================================================================================================






	-- ||||||||||||||||| Set the paths |||||||||||||||||||||||||||||||||||||||||||||
	local global_apt_dat = SCRIPT_DIRECTORY .. "../../../default scenery/default apt dat/Earth nav data/apt.dat" -- commented out in january 2022
	--local global_apt_dat = SCRIPT_DIRECTORY .. "../../../../Custom Scenery/Global Airports/Earth nav data/apt.dat" -- Added in january 2022 but removed since it does ont contain enough runways. Not sure why There are more updated, but not worldwide

	if IsXPlane12 then -- global_apt_dat was relocated in 12 !
		global_apt_dat = SCRIPT_DIRECTORY .. "../../../../Global Scenery/Global Airports/Earth nav data/apt.dat"
	end
	--   X-Plane objects folders (you must NOT edit)
	XPlane_objects_directory =          SCRIPT_DIRECTORY .. "../../../default scenery/sim objects/apt_vehicles/" -- do not edit
	XPlane_Ramp_Equipment_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Ramp_Equipment/" -- do not edit
	XPlane12_Common_Equipment_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Common_Elements/Miscellaneous/" -- do not edit
	XPlane12_Common_Vehicules_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Common_Elements/Vehicles/" -- do not edit
	XPlane12_BushObjects_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/1000 autogen/global_objects/objects/" -- do not edit
	XPlane12_ford_carrier_accessories_directory  =  SCRIPT_DIRECTORY ..  "../../../default scenery/sim objects/dynamic/ford_carrier_accessories/"

	-- ||||||||| LOOK FOR USER PREFERENCES |||||||||||||||||||||||||||||||||||||||||

	-- detection of the nearest parking stand. Which distance threshold from the aircaft to allow detection ?
	automatic_marshaller_capture_position_threshold = 0.0004 -- calibrated at LTBA facing North and facing West
	local RunwayEnd_capture_position_threshold = 0.1

	-- For safety, we initialize a variable that directs toward the use of X-Plane objects by default
	UseXplaneDefaultObject = true -- user should NOT intervene here, but in the user config file
	UseXplane1214DefaultObject = true
	UseXplane1220Chocks = false
	UseXplane1220Chocks_specific = UseXplane1220Chocks
	LoadXplane1220Chocks_specific = false
	-- if they want some custom objects instead, as this master setting is amended later from the config file

	debugging_passengers = false -- accelerate testing conditions

	--anti-ice / deice stuff :
	Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = 2700 -- 45 min
	temperature_below_which_we_display_the_active_deicing_service = 10

	ULDthresholdx = 13 -- above this value, an ULD loader instead of a Belt Loader

	-- many variable are just temporary set, and should not be changed here, but changed in the configuration files instead !
	User_prefers_containerized_freight = false
	reduce_even_more_the_number_of_passengers = false
	walking_direction_changed_armed = false
	get_hospital_ambulance = false
	BeltLoaderFwdPosition = 10 -- do not change here
	SecondStairsFwdPosition = -30 	-- do NOT (not !) change here
	sges_tank_to_refuel = 0 -- when zero is default to all aircaft, prevent refueling aircraft to fill any tank at all -- do not change here
	sges_gs_plane_head_correction = 0
	sges_gs_plane_head_correction2 = 0
	sges_gs_plane_head_correction3 = 0
	vertical_door_position = -799 	-- initial value before config file loading
	vertical_door_position2 = -799 	-- initial value before config file loading
	height_factor3 = 0
	longitudinal_factor3 = 0
	lateral_factor3 = 0
	-- USE SOME ENGINE SOUND WITH SGES SERVICES ?
	SGES_sound = true -- set that to false to remove sounds -- only applicable to X-Plane 11 -- initial value before config file loading
	-- in X-Plane 12, this setting is applicable only to Pushback crew communications
	-- SHOW THE FRONT STAIRS WHEN THE 1L DOOR IS OPENED ?
	show_auto_stairs = false		-- initial value before config file loading
	-- setting the show_auto_stairs value to "true" will allow the stairs to be shown automatically on door opening
	-- this will work only with a selection of airplanes, when the dataref is referenced in the acft config file.
	-- setting the show_auto_stairs value to "false" will disable all automatic stairs appearance
	config_helper = false
	config_options = false
	PRM_is_catering = false

	show_Front_Line = false
	Front_Line_chg = false

	pitch_hel = -8
	targetDoorX_alternate = 0
	targetDoorZ_alternate = 0
	targetDoorH_alternate = 0
	plane_has_cargo_hold_on_the_left_hand_side = false
	play_sound_SGES_is_available = true

	SGES_Embraer_catering_is_small = true
	sges_airport_ID = "ZZZZ"
	current_X = {}
	current_Z = {}
	heading_corr = {}
	dZ_depart = {}
	dX_depart = {}
	object_name_t = {}
	groundAlt = {}
	groundPitch = {}
	selected_boat = 97 --IAS24
	-- WHICH DISTANCE TO CRASH AND WRECKRAGE SITES ?
	DistanceToCrashSite = 1000 -- DEPRECATED settings : can be set in game
	 -- 1920 au = 1 nm
	-- When you set emergency services ahead to simulate a car accident site
	-- You can increase that in-game
	DistanceToShipWreckSite = 2000  -- DEPRECATED settings : can be set in game
	-- When you set boats on sea ahead to simulate a boat accident site
	-- You can increase that in-game
	SGES_mirror = 0 -- mirror some services to inverse left and right services around the plane. The value 1 is set somewhere else.
	sges_tank_to_refuel = get("sim/aircraft/overflow/acf_num_tanks")
	print("[Ground Equipment " .. version_text_SGES .. "] SGES thinks there are " .. sges_tank_to_refuel .. " fuel tanks to refuel from the air refueler.")
	-- we'll chek if updated by user in the configuration file.

	-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	-- then load the user preferences :

	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_aircraft.lua") -- user settings and preferences
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_vehicles.lua") -- user settings and preferences
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Menu_position.lua") -- user settings and preferences
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Developer_export.lua") -- user settings and preferences

	--------------------------------------------------------------------

	-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

	BeltLoaderFwdPosition = AircraftParameters()
	if SGES_mirror == 1 and BeltLoaderFwdPosition > 5 then SGES_mirror = 0 print("[Ground Equipment " .. version_text_SGES .. "] =!= SGES has cancelled mirrored ground services read from the aircraft definition. Conditions are not met for that. =!=") end -- we need to forbid acess to mirrorring passengers when this is NOT suitable to mirror
	user_sges_tank_to_refuel = sges_tank_to_refuel

	FileName_Menu_position = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Menu_position.lua"
	function SGES_WriteToDisk()
		fileES = io.open(FileName_Menu_position, "w")
		fileES:write("float_wnd_saved_position_x = " .. float_wnd_saved_position_x)
		fileES:close()
	end

	--print("[Ground Equipment " .. version_text_SGES .. "] BeltLoaderFwdPosition " .. BeltLoaderFwdPosition)
	--print("[Ground Equipment " .. version_text_SGES .. "] " .. PLANE_ICAO)

	if UseXplaneDefaultObject == false then -- use some user objects
	 -- BUS OBJECT -------------------------------------------------------------
		Prefilled_BusObject_option1 = User_Custom_Prefilled_BusObject_option1
		Prefilled_BusObject_option2 = User_Custom_Prefilled_BusObject_option2
		Prefilled_BusObject_doublet = User_Custom_Prefilled_BusObject_doublet
		Prefilled_AlternativeBusObject = User_Custom_Prefilled_AlternativeBusObject
		--

		-- Fuel TRUCK -------------------------------------------------------------
		Prefilled_FuelObject_option1 = User_Custom_Prefilled_FuelObject_option1
		Prefilled_FuelObject_option2 = User_Custom_Prefilled_FuelObject_option2

		-- STAIRS -----------------------------------------------------------------
		Prefilled_StairsObject = User_Custom_Prefilled_StairsObject

		-- GPU --------------------------------------------------------------------
		Prefilled_GPUObject = User_Custom_Prefilled_GPUObject
		Prefilled_GA_GPUObject = User_Custom_Prefilled_GA_GPUObject

		-- CATERING ----------------------------------------------------------------
		Prefilled_CateringObject		 = User_Custom_Prefilled_CateringObject
		Prefilled_CateringHighPartObject = User_Custom_Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_GG_Object = User_Custom_Prefilled_CateringHighPart_GG_Object
		Prefilled_CateringHighPart_NR_Object = User_Custom_Prefilled_CateringHighPart_NR_Object
		Prefilled_CateringHighPart_MI_Object = User_Custom_Prefilled_CateringHighPart_MI_Object
		Prefilled_AlternativeCateringObject = User_Custom_Prefilled_AlternativeCateringObject

		-- REAR LEFT TRUCK ---------------------------------------------------------
		Prefilled_CleaningTruckObject = User_Custom_Prefilled_CleaningTruckObject

		-- CARGO HOLD LOADER ------------------------------------------------------
		Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
		-- BAGAGE CARTS TRAIN ------------------------------------------------------
		Prefilled_2CartObject = User_Custom_Prefilled_2BaggageTrainObject
		Prefilled_5CartObject = User_Custom_Prefilled_5BaggageTrainObject

		-- CARGO FREIGHTER LOADER & TRAIN ------------------------------------------
		Prefilled_ULDLoaderObject = User_Custom_Prefilled_ULDLoaderObject
		Prefilled_ULDTrainObject  = User_Custom_Prefilled_ULDTrainObject
		Prefilled_CargoDeck_ULDLoaderObject = Prefilled_ULDLoaderObject

		if IsXPlane1211 then
			Prefilled_ULDLoaderObject = XPlane_Ramp_Equipment_directory .. "cargo_loader_ch70w.obj"
			Prefilled_CargoDeck_ULDLoaderObject = XPlane_Ramp_Equipment_directory .. "cargo_loader_ch70w_up.obj"
		end


		-- FOLLOW ME VEHICLE ------------------------------------------------------
		if BeltLoaderFwdPosition < 4 and (not string.match(PLANE_ICAO,"B46") and not string.match(PLANE_ICAO,"RJ") ) then
			-- for the smaller aircraft, use the smallest follow-me we provide
			Prefilled_FMObject = User_Custom_Prefilled_FMObject
		else
			if User_Custom_Prefilled_FMObject_2 == nil then User_Custom_Prefilled_FMObject_2 = User_Custom_Prefilled_FMObject end
			if User_Custom_Prefilled_FMObject_3 == nil then User_Custom_Prefilled_FMObject_3 = User_Custom_Prefilled_FMObject end
			-- two lines for safety if the user has a vehicle configuration file without 3 follow-me links
			-- then show randomly a follow-me vehicle :
			math.randomseed(os.time())
			randomView = math.random()
			if randomView > 0.40 then
				Prefilled_FMObject = User_Custom_Prefilled_FMObject_2 -- the yellow
			else
				Prefilled_FMObject = User_Custom_Prefilled_FMObject_3 -- the grey one
			end
		end

		-- FIRE DEP VEHICLE --------------------------------------------------------
		Prefilled_FireObject = User_Custom_Prefilled_FireObject
		Prefilled_AlternativeFireObject = User_Custom_Prefilled_AlternativeFireObject
		function XP12_Fire_VH()
			if IsXPlane1221 and UseXplane1214DefaultObject then
				Prefilled_FireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_2.obj" -- red
				Prefilled_AlternativeFireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_1.obj" -- yellow
				if IsPassengerPlane == 0 then -- for cargo airplanes, add the deployable hose
					Prefilled_FireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_2_hret.obj" -- red
					Prefilled_AlternativeFireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_1_hret.obj" -- yellow
				end
				Prefilled_FireObject_lights = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "Fire/Striker_lights.obj"
				Prefilled_AlternativeFireObject_lights = Prefilled_FireObject_lights
			else
				Prefilled_FireObject = User_Custom_Prefilled_FireObject
				Prefilled_AlternativeFireObject = User_Custom_Prefilled_AlternativeFireObject
			end
			if show_FireVehicleAhead then Prefilled_FireObject = User_Custom_Prefilled_AlternativeFireObject end
		end
		XP12_Fire_VH()

		-- PRM CAR --------------------------------------------------------------
		Prefilled_PRM_carObject = User_Custom_Prefilled_PRM_carObject

		-- HOT START CHALLENGER 650 DEICING VEHICLE ----------------------------
		Prefilled_DeiceObject =  User_Custom_Prefilled_DeiceObject -- can be "nil"
		Prefilled_DeiceObject2 =  User_Custom_Prefilled_DeiceObject -- can be "nil"

		-- PEOPLE ------------------------------------------------------------------
		Prefilled_PeopleObject4 = User_Custom_Prefilled_PeopleObject4
		Prefilled_PeopleObject3 = User_Custom_Prefilled_PeopleObject3
		Prefilled_PeopleObject2 = User_Custom_Prefilled_PeopleObject2
		Prefilled_PeopleObject1 = User_Custom_Prefilled_PeopleObject1
		Prefilled_GenericDriverObject = User_Custom_Prefilled_PeopleObject5
		Prefilled_GenericDriverObject_anim = 	User_Custom_Prefilled_PeopleObject6


		function Load_Cami_de_Bellis_Objects()
			if not string.match(Prefilled_CleaningTruckObject,"lsu") then
				if Cami_de_Bellis_authorized == nil then Cami_de_Bellis_authorized = true end

				if Cami_de_Bellis_Directory ~= nil and Cami_de_Bellis_authorized and not file_exists(SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/pilots/peeps_pilots_P2-goingup.obj") then
					print("[Ground Equipment " .. version_text_SGES .. "] Problem with Cami de Bellis library path in SGES " .. Prefilled_PeopleObject4 .. "\nReverting to MisterX People. An immediate solution is to deactivate the use of the CDB-LIbrary in SGES options.")
					Cami_de_Bellis_authorized = false
				end

				if Cami_de_Bellis_Directory ~= nil and Cami_de_Bellis_authorized and file_exists(SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/pilots/peeps_pilots_P2-goingup.obj") then

					-- test if no error

					Prefilled_PeopleObject4 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/pilots/peeps_pilots_P2-goingup.obj" -- Pilot
					--~ print("[Ground Equipment " .. version_text_SGES .. "]  Loading Cami de Bellis people in SGES " .. Prefilled_PeopleObject4)
					Prefilled_PeopleObject3 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/airMarshall/peeps_ramp_agentM3.obj" -- Cleaner
					if BeltLoaderFwdPosition < 5 or PLANE_ICAO == "E19L"  then
						Prefilled_PeopleObject2 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/airMarshall/peeps_ramp_agentF2.obj" -- agent near the fuselage door
					else
						Prefilled_PeopleObject2 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/AA_peeps/AA_peepsF2.obj" -- agent near the fuselage door
					end
					Prefilled_PeopleObject1 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/airMarshall/peeps_AirMarshallM2.obj" -- Air Marshall
					-- military handler
					--~ Prefilled_GenericDriverObject = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/airMarshall/peeps_AirMarshallM1.obj"
					Prefilled_Ponev =  SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/Militare_Peeps/peeps_militareF1.obj"


					if Transporting_Jetsetpeople ~= nil and Transporting_Jetsetpeople and outsideAirTemp > 10 and sges_big_airport ~= nil and not sges_big_airport then
						Prefilled_PeopleObject3 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Flora_Fauna/Birds_pets/fauna_dog5.obj" -- Cleaner
					end

					if SGES_BushMode then
						Prefilled_PeopleObject3 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/polynesian/polynesian/polynesian_peeps_airstaff_vigili.obj" -- Cleaner
						Prefilled_PeopleObject2 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/polynesian/polynesian/aitutaki3_peeps_F4.obj" -- agent near the fuselage door
						Prefilled_PeopleObject4 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/polynesian/polynesian/polynesian_passF1.obj" -- Pilot
					end

					if Transporting_Jetsetpeople ~= nil and Transporting_Jetsetpeople and outsideAirTemp >= 27 and SGES_BushMode and sges_big_airport ~= nil and not sges_big_airport then
						Prefilled_PeopleObject2 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/beach/peeps_beachF13.obj" -- agent near the fuselage door
						Prefilled_PeopleObject4 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/beach/peeps_beachM2.obj" -- Pilot
					end


					if GUImilitary_default_sges or GUImilitary_sges then
						--~ print("military objects CDB-Library")
						Prefilled_PeopleObject3 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/Militare_Peeps/peeps_militareF1.obj" -- Cleaner
						Prefilled_PeopleObject2 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/Militare_Peeps/peeps_militareM18.obj" -- agent near the fuselage door
						Prefilled_PeopleObject4 = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/Militare_Peeps/peeps_rampAgentF1.obj" -- Pilot
						Prefilled_GenericDriverObject = SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/Militare_Peeps/peeps_rampAgentM1.obj" -- Push Back driver
					else
						Prefilled_GenericDriverObject = User_Custom_Prefilled_PeopleObject5
					end
				else
					Prefilled_PeopleObject4 = User_Custom_Prefilled_PeopleObject4
					Prefilled_PeopleObject3 = User_Custom_Prefilled_PeopleObject3
					Prefilled_PeopleObject2 = User_Custom_Prefilled_PeopleObject2
					Prefilled_PeopleObject1 = User_Custom_Prefilled_PeopleObject1
					Prefilled_GenericDriverObject = User_Custom_Prefilled_PeopleObject5
					Prefilled_Ponev = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/3d_marshaller_animated/Ponev.obj"
				end
			end
		end

		-- PASSENGERS ------------------------------------------------------------------
		Prefilled_PassengerMilObject = User_Custom_Prefilled_PassengerMilObject
		Prefilled_Passenger1Object = User_Custom_Prefilled_Passenger1Object
		Prefilled_Passenger2Object = User_Custom_Prefilled_Passenger2Object
		Prefilled_Passenger3Object = User_Custom_Prefilled_Passenger3Object
		Prefilled_Passenger4Object = User_Custom_Prefilled_Passenger4Object
		Prefilled_Passenger5Object = User_Custom_Prefilled_Passenger5Object
		Prefilled_Passenger6Object = User_Custom_Prefilled_Passenger6Object
		Prefilled_Passenger7Object = User_Custom_Prefilled_Passenger7Object

		Prefilled_Passenger8Object = User_Custom_Prefilled_Passenger8Object
		Prefilled_Passenger9Object = User_Custom_Prefilled_Passenger2Object
		Prefilled_Passenger10Object = User_Custom_Prefilled_Passenger3Object
		Prefilled_Passenger11Object = User_Custom_Prefilled_Passenger4Object
		Prefilled_Passenger12Object = User_Custom_Prefilled_Passenger5Object
		Prefilled_Passenger13Object = User_Custom_Prefilled_Passenger13Object
		Prefilled_Passenger14Object = User_Custom_Prefilled_Passenger14Object

		--~ Prefilled_Passenger8Object = User_Custom_Prefilled_CanoeObject
		--~ Prefilled_Passenger9Object = User_Custom_Prefilled_CanoeObject
		--~ Prefilled_Passenger10Object = User_Custom_Prefilled_CanoeObject
		--~ Prefilled_Passenger11Object = User_Custom_Prefilled_CanoeObject
		--~ Prefilled_Passenger12Object = User_Custom_Prefilled_CanoeObject

		-- SMALL SHIP AT SEA -------------------------------------------------------
		Prefilled_SmallShipObject = User_Custom_Prefilled_SmallShipObject

		-- LARGE SHIP AT SEA ----------------------------------------------------------
		Prefilled_LargeShipObject = User_Custom_Prefilled_LargeShipObject

		Prefilled_CanoeObject = User_Custom_Prefilled_CanoeObject

	end


	-- ||||||||||||||||| Set the Belt Loader corrective factor ||||||||||||||||||||||||



	-- -----------------------------------------------------------------------------












	--                  USER ACCESS NOT REQUIRED BELOW THIS LIMIT












	-- INITIALISATION OF REQUIRED OBJECTS ------------------------------------------

	--~ XPlane_objects_directory =          SCRIPT_DIRECTORY .. "../../../default scenery/sim objects/apt_vehicles/" -- do not edit
	--~ XPlane_Ramp_Equipment_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Ramp_Equipment/" -- do not edit


	if IsXPlane12 then
		XPlane_objects_directory =          SCRIPT_DIRECTORY .. "../../../default scenery/sim objects/apt_vehicles/" -- do not edit
	end
	-- never edit that please :

		-- LAMINAR BUS (XP12.1.2)
	if IsXPlane1212 then
		Dayonly_BusObject_option =       XPlane_Ramp_Equipment_directory  .. "pax_bus_1.obj" -- not lighted at night
		--~ Dayonly_BusObject_option =       XPlane_Ramp_Equipment_directory  .. "pax_bus_2.obj" -- PROTERRA : The company filed for Chapter 11 bankruptcy in August 2023
	end
		-- LAMINAR objects (XP12.1.4)
	if IsXPlane1214 then
		-- not lighted at night, we will use it day only !
		-- we will keep our lighted objects at night.
		Dayonly_airsideops_pickup_white =       XPlane12_Common_Vehicules_directory  .. "airsideops_pickup_04.obj"
		Dayonly_airsideops_SUV_white =       	XPlane12_Common_Vehicules_directory  .. "airsideops_vw2_04.obj"
		Dayonly_airsideops_van_white =       	XPlane12_Common_Vehicules_directory  .. "airsideops_vw_04.obj"
		Dayonly_airsideops_pickup_yellow =      XPlane12_Common_Vehicules_directory  .. "airsideops_pickup_03.obj"
		Dayonly_airsideops_SUV_yellow =     	XPlane12_Common_Vehicules_directory  .. "airsideops_vw2_03.obj"
		Dayonly_airsideops_van_yellow =       	XPlane12_Common_Vehicules_directory  .. "airsideops_vw_03.obj"
		Dayonly_airsideops_pickup_checkerboard = XPlane12_Common_Vehicules_directory  .. "airsideops_pickup_01.obj"
		Dayonly_airsideops_SUV_checkerboard =   XPlane12_Common_Vehicules_directory  .. "airsideops_vw2_01.obj"
		Dayonly_airsideops_van_checkerboard =   XPlane12_Common_Vehicules_directory  .. "airsideops_vw_01.obj"

		Dayonly_airsideops_Ambulance_yellow =   XPlane12_Common_Vehicules_directory  .. "ambulance_us_03.obj"

		Dayonly_truck_flatbed_01 =       		XPlane12_Common_Vehicules_directory  .. "truck_flatbed_01.obj"
		Dayonly_truck_tanker_01 =       		XPlane12_Common_Vehicules_directory  .. "truck_tanker_01.obj"
		Dayonly_deicing_truck_01 =       		XPlane12_Common_Vehicules_directory  .. "../../snow_equipment/aircraft_deicing_truck_1.obj"
	end






	--local XPlane_objects_directory = SCRIPT_DIRECTORY .. "../../../default scenery/sim objects/apt_vehicles/" -- do not edit
	--local XPlane_Ramp_Equipment_directory  =  SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Ramp_Equipment/" -- do not edit
	if Prefilled_FMObject == nil then
		Prefilled_BusObject_option1 =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_01.obj"
		Prefilled_BusObject_option2 =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_02.obj"
		Prefilled_BusObject_doublet =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_02.obj"
		Prefilled_FuelObject_option1 =      XPlane_objects_directory   .. "fuel/fuelHydDisp_truck.obj"
		Prefilled_FuelObject_option2 =      XPlane_objects_directory   .. "fuel/fuelHydDisp_truck.obj"
		Prefilled_StairsObject =            XPlane_Ramp_Equipment_directory .. "Stair_Maint_1.obj"
		Prefilled_GPUObject =               XPlane_Ramp_Equipment_directory   .. "GPU_1.obj"
		Prefilled_GA_GPUObject = 			XPlane_Ramp_Equipment_directory   .. "GPU_2.obj"
		Prefilled_CateringObject =          XPlane_Ramp_Equipment_directory   .. "catering_truck.obj"
		Prefilled_CateringHighPartObject =	XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
		Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_MI_Object = Prefilled_CateringHighPartObject
		Prefilled_CleaningTruckObject =     XPlane_Ramp_Equipment_directory   .. "XPlane_objects_directory"
		Prefilled_AlternativeCateringObject = XPlane_Ramp_Equipment_directory   .. "crew_car.obj"
		Prefilled_FMObject =                XPlane_Ramp_Equipment_directory   .. "crew_car.obj"
		PRM_carObject = Prefilled_FMObject
		Prefilled_BeltLoaderObject =        XPlane_Ramp_Equipment_directory   .. "Belt_Loader.obj"
		Prefilled_2CartObject =				XPlane_Ramp_Equipment_directory   .. "Lugg_Train_Str2.obj" -- baggage cart XP11
		Prefilled_5CartObject = 			XPlane_Ramp_Equipment_directory   .. "Lugg_Train_Str5.obj" -- baggage cart
		if IsXPlane12 then -- 2024 April
			Prefilled_2CartObject = 			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str2.obj" -- baggage cart XP12
			Prefilled_5CartObject = 			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str4.obj" -- baggage cart
		end
		--~ Prefilled_ULDLoaderObject =         XPlane_Ramp_Equipment_directory   .. "Cargo_Loader_1.obj" -- doesn't work very well after 2023 at least
		Prefilled_ULDLoaderObject = 		SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/Generic.obj"-- force Mister X
		Prefilled_CargoDeck_ULDLoaderObject = Prefilled_ULDLoaderObject
		Prefilled_ULDTrainObject =			XPlane_Ramp_Equipment_directory   .. "Lugg_Train_Str2.obj" -- baggage cart
		Prefilled_AlternativeBusObject =    XPlane_Ramp_Equipment_directory   .. "Cargo_Container_6.obj"
		Prefilled_FireObject =              XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars/dynamic/police_car_var1.obj"
		Prefilled_AlternativeFireObject =   XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars/dynamic/police_car_var1.obj"
		Prefilled_PeopleObject1 =           XPlane_Ramp_Equipment_directory   .. "Towbar_1.obj"
		if IsXPlane1209 then
			Prefilled_PeopleObject1 = 		XPlane_Ramp_Equipment_directory   .. "towbar_10ft_1.obj"
		end
		Prefilled_PeopleObject2 =           XPlane_Ramp_Equipment_directory   .. "Chocks_1.obj"
		Prefilled_PeopleObject3 =           XPlane_Ramp_Equipment_directory   .. "Chocks_2.obj"
		Prefilled_PeopleObject4 =           XPlane_Ramp_Equipment_directory   .. "Chocks_1.obj"
		Prefilled_GenericDriverObject = 	Prefilled_PeopleObject2
		Prefilled_GenericDriverObject_anim = 	Prefilled_PeopleObject2
		Prefilled_PassengerMilObject =		Prefilled_PeopleObject2
		Prefilled_Passenger1Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger2Object = 		Prefilled_PeopleObject3
		Prefilled_Passenger3Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger4Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger5Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger6Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger7Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger8Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger9Object = 		Prefilled_PeopleObject3
		Prefilled_Passenger10Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger11Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger12Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger13Object = 		Prefilled_PeopleObject2
		Prefilled_Passenger14Object = 		Prefilled_PeopleObject2
		Prefilled_SmallShipObject =         XPlane_objects_directory   .. "../dynamic/SailBoat.obj"
		Prefilled_LargeShipObject =         XPlane_objects_directory   .. "../dynamic/Perry.obj"
		if IsXPlane12 then
			Prefilled_BusObject_option1 =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_01.obj"
			Prefilled_BusObject_option2 =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_02.obj"
			Prefilled_BusObject_doublet =       XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_02.obj"
			Prefilled_FuelObject_option1 =      XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Fuel_Truck_Large.obj"
			Prefilled_FuelObject_option2 =      XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj"
			Prefilled_CateringObject =          XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/catering_truck.obj"
			Prefilled_CleaningTruckObject =     XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_mercedes_C2.obj"
			Prefilled_LargeShipObject =         XPlane_objects_directory   .. "../ships/parts/BulkCarrier_342B_BaseModel.obj"
			Prefilled_SmallShipObject =         XPlane_objects_directory   .. "../ships/Sail_1500_02.obj"
			-- crew car was moved :
			Prefilled_AlternativeCateringObject = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/crew_car.obj"
			Prefilled_FMObject =                XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/crew_car.obj"
			Prefilled_PRM_carObject = Prefilled_FMObject
		end
		Prefilled_CanoeObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/Canot.obj"
	end




	----------------------------------------------------------------------------
	-- non customisable objects :
	----------------------------------------------------------------------------

	Prefilled_TargetSelfPushbackObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Airplane_model_aplaned.obj" -- Target
	--~ Prefilled_TargetMarkerObject =       XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj" -- Target for noseweel on stand TEMPO
	Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular_noticeable.obj" -- Target for noseweel on stand --IAS24
	Original_CleaningTruckObject = Prefilled_CleaningTruckObject
	Prefilled_Mil_Van =  			SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Cleaning/Van_Mil.obj"
	if IsXPlane12 then
		Prefilled_XP12_LargeShip_1 =         XPlane_objects_directory   .. "../ships/parts/BulkCarrier_342B_BaseModel.obj"
		Prefilled_XP12_LargeShip_2 =         XPlane_objects_directory   .. "../ships/parts/BulkCarrier_190C_BaseModel.obj"
		Prefilled_XP12_LargeShip_3 =         XPlane_objects_directory   .. "../ships/parts/OilTanker_250A_BaseModel.obj"
		Prefilled_XP12_LargeShip_4 =         Prefilled_LargeShipObject
		Prefilled_XP12Carrier =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_Hull.obj"
		Prefilled_XP12CarrierP2 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_Deck.obj"
		Prefilled_XP12CarrierP3 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_Island.obj"
		Prefilled_XP12CarrierP4 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_HangarPavement.obj"
		Prefilled_XP12CarrierP5 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_Bridge.obj"
		Prefilled_XP12CarrierP6 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_Glass.obj"
		--Prefilled_XP12CarrierP7 =         	 SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Landable_area.obj"
		Prefilled_XP12CarrierP7 =         	 XPlane_objects_directory   .. "../dynamic/ford_carrier_parts/Gerald_R_Ford_SmallDetails.obj"
		Prefilled_XP12Frigate =         	 XPlane_objects_directory   .. "../dynamic/Perry.obj"

		Prefilled_XP12Helicopter =         	 XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"
	end
	Prefilled_CartObject =		Prefilled_2CartObject
	Prefilled_LD3CartObject	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/LD3_Train.obj"
	Prefilled_LightObject = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Empty.obj" -- [IMPORTANT !] used as alternative catering for small acft !!
	Prefilled_CockpitLightObject = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/CockpitLight.obj" -- [IMPORTANT !] used as alternative catering for small acft !!
	Prefilled_LightObject_height = 0.5
	Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "Towbar_1.obj" --  was yellow
	if IsXPlane1209 then
		math.randomseed(os.time())
		randomView = math.random()
		if PLANE_ICAO == "A320" or PLANE_ICAO == "A20N" then -- just for fun
			if randomView > 0.7 then
				Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_3.obj" -- Blue
			elseif randomView > 0.4 then
				Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_1.obj" -- White
			else
				Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_2.obj" -- Yellow
			end

		else
			if randomView > 0.65 then
				Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_1.obj" -- White
			else
				Prefilled_PushBackObject = 	XPlane_Ramp_Equipment_directory   .. "towbar_15ft_2.obj" -- Yellow
			end
		end
	end
	PushBackBar = Prefilled_PushBackObject
	Prefilled_PushBack1Object = XPlane_Ramp_Equipment_directory   .. "Tow_Tractor_2.obj"
	Prefilled_ForkliftObject = 	SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Euro_Airports/Vehicles/Forklifts/Forklift_DFG430_red_barrel_up.obj"
	Prefilled_MilForkliftObject = SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Euro_Airports/Vehicles/Forklifts/Forklift_DFG430_green_bags_up.obj"
	Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround.obj"
	if IsXPlane12 then
		Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12.obj"
	end
	Prefilled_ArrestorNet = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/NetBarrier.obj"
	Prefilled_ArrestorCable = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/ArrestorCable.obj"
	Prefilled_EMAS = 			SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/EMAS.obj"
	Prefilled_ASU_ACU = 		SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/ASU_ACU.obj"
	Prefilled_StopSignObject =  XPlane_Ramp_Equipment_directory   .. "../Euro_Airports/Objects/Traffic_Signs/Germany/sign_stop.obj" -- Target for noseweel on stand
	Prefilled_StopSignArms =  XPlane_Ramp_Equipment_directory   .. "../Euro_Airports/Objects/Traffic_Signs/Germany/sign_stop.obj" -- Target for noseweel on stand
	Prefilled_StopSignFixedObject =  XPlane_Ramp_Equipment_directory   .. "../Euro_Airports/Objects/Traffic_Signs/Germany/sign_stop.obj" -- Target for noseweel on stand
	Prefilled_Ponev = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/3d_marshaller_animated/Ponev.obj"
	if Prefilled_DeiceObject == nil then
		-- DEICING VEHICLE --------------------------------------------------------
		Prefilled_DeiceObject =  SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/De_Icing_Trucks/DeicingTruck_mod.obj" -- Deicing truck
		Prefilled_DeiceObject2 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/De_Icing_Trucks/DeicingTruck_mod.obj" -- Deicing truck
	end
		if UseXplaneDefaultObject == false then
		-- PRM ---------------------------------------------------------------------
		Prefilled_PRMHighPartObject 	= SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "PRM/Ambulift_high_part.obj"
	end
	-- for a small aircraft, the custom object PRM LOADER is replaced by a small vehicle :
	if  UseXplaneDefaultObject == false and BeltLoaderFwdPosition < 2.5 then
		-- PRM ---------------------------------------------------------------------
		Prefilled_CateringObject =      Prefilled_PRM_carObject
		--~ FollowMe_passat_white
		Prefilled_PRMHighPartObject 	= XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
	elseif  UseXplaneDefaultObject == false and (PLANE_ICAO == "GLF650ER" or PLANE_ICAO == "DH8D" or string.match(PLANE_ICAO,"AT4") or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)")) then
		-- PRM ---------------------------------------------------------------------
		Prefilled_CateringObject =      Prefilled_PRM_carObject
		Prefilled_PRMHighPartObject 	= XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
	end

	----------------------------------------------------------------------------
	Prefilled_Peugeot308_grey_Object	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/308_XPJavelin2.obj"
	Prefilled_Peugeot308_black_Object	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/308_XPJavelin3.obj"
	Prefilled_Peugeot308_police_Object	=	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/308_XPJavelin4.obj"

	Native_PushBack_Tug 	= SCRIPT_DIRECTORY   ..  "../../../default scenery/airport scenery/Dynamic_Vehicles/Tug_GT110.obj" --X-Plane stuff
	Prefilled_ULDObject 	= SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/ULD.obj" -- to be updated in load_ULD()

	-- traffic cones have changef in XP12.03

	Legacy_Cones_installed = false
	XP1203_Cones_installed = false
	Legacy_Cones_installed = file_exists(XPlane_Ramp_Equipment_directory   .. "Traffic_Cone_1.obj")
	XP1203_Cones_installed = file_exists(XPlane12_Common_Equipment_directory    .. "traffic_cone_2.obj")
	Bollard_installed = file_exists(XPlane12_Common_Equipment_directory    .. "traffic_pole_1.obj")
	if Legacy_Cones_installed then
		Prefilled_ConeObject = XPlane_Ramp_Equipment_directory   .. "Traffic_Cone_1.obj"
	elseif XP1203_Cones_installed then
		Prefilled_ConeObject = XPlane12_Common_Equipment_directory    .. "traffic_cone_2.obj"
	else
		Prefilled_ConeObject = XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
	end

	if Bollard_installed then
		if BeltLoaderFwdPosition < 2 then  --  8th march 2024
			Prefilled_BollardObject = XPlane12_Common_Equipment_directory    .. "traffic_cone_1.obj" -- prefered the more visble Lübeck conus when avail.
		else -- before 8 march 2024 only that
			Prefilled_BollardObject = XPlane12_Common_Equipment_directory   .. "traffic_pole_1.obj"
		end
	else
		Prefilled_BollardObject = Prefilled_ConeObject
	end
	-- 14th July 2023 cones with strips :
	Linked_cones = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/XPJ_conus.obj"

	if string.find(Prefilled_CargoDeck_ULDLoaderObject,"cargo_loader_ch70w") then
		CargoDeck_ULDLoaderPlateObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/ULD_plate.obj"
	end




	----------------------------------------------------------------------------
	-- SPECIAL PUSHBACK TRACTOR/HUMAN and special vehicles
	----------------------------------------------------------------------------

	-- Find if the buddy betterpushback is installed
	------------------------------------------------
	betterpushback_installed = false
	--~ function file_exists(name)
		--~ local f=io.open(name,"r")
		--~ if f~=nil then io.close(f) return true else return false end
	--~ end
	--~ betterpushback_truck = SCRIPT_DIRECTORY .. "../../BetterPushback/objects/tugs/AST-3F.tug/AST-3F.obj"
	--~ betterpushback_installed = file_exists(betterpushback_truck)
	--~ if betterpushback_installed then
		--~ Prefilled_PushBack1Object = betterpushback_truck
	--~ end
	 --~ function SGESCopyFile(old_path, new_path)
		--~ print("Ground equipment : copy " .. old_path)
		--~ local old_file = io.open(old_path, "rb")
		--~ local new_file = io.open(new_path, "wb")
		--~ local old_file_sz, new_file_sz = 0, 0
		--~ if not old_file or not new_file then
			--~ print("Ground equipment : didn't copy " .. old_path)
			--~ return false
		--~ end
		--~ while true do
			--~ local block = old_file:read(2^17)
			--~ if not block then
			  --~ old_file_sz = old_file:seek( "end" )
			  --~ break
			--~ end
			--~ new_file:write(block)
		--~ end
		--~ old_file:close()
		--~ new_file_sz = new_file:seek( "end" )
		--~ new_file:close()
		--~ print("Ground equipment : copied " .. new_path)
		--~ return new_file_sz == old_file_sz
	--~ end
	--~ if not file_exists(SCRIPT_DIRECTORY .. "../../BetterPushback/objects/tugs/AST-3F.tug/AST-1X_tex.png") then
		--~ SGESCopyFile(SCRIPT_DIRECTORY .. "../../BetterPushback/objects/tugs/AST-3F.tug/liveries/generic.livery/AST-1X_tex.png", SCRIPT_DIRECTORY .. "../../BetterPushback/objects/tugs/AST-3F.tug/AST-1X_tex.png")
	--~ end

	---------------------------

	-- /////////////////////////////////////////// --
	----------------------------------------------------------------------------
	-- Special FlightFactor 777 V2 objects :
	----------------------------------------------------------------------------
	function load_special_B777v2_objects(test_777v2_a)
		--~ if test_777v2_a and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
		if test_777v2_a then --and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
			print("[Ground Equipment " .. version_text_SGES .. "] Loading STS/FF objects found in the Boeing 777-200ER folder.")
			if BeltLoaderFwdPosition >= 7 then
				Prefilled_CateringObject = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/cater.obj" if PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then set("1-sim/anim/service/caterigtrucklift",1) end
				Prefilled_CateringHighPartObject = 	Prefilled_LightObject
				Prefilled_CateringHighPart_GG_Object = Prefilled_LightObject
				Prefilled_CateringHighPart_NR_Object = Prefilled_LightObject
				Prefilled_CateringHighPart_MI_Object = Prefilled_LightObject
				Prefilled_PRMHighPartObject	=		Prefilled_LightObject
			end
			--~ Prefilled_BusObject_option2 = 		SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/bus.obj"
			Prefilled_FuelObject_option2 = 		SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/fuelL.obj"
			Prefilled_BollardObject = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/workers/cone.obj"
			Prefilled_PeopleObject1 = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/workers/worker2.obj"
			Prefilled_PeopleObject2 = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/workers/worker6.obj"
			Prefilled_PeopleObject3 = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/workers/worker3.obj"
			Prefilled_PeopleObject4 = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/workers/worker2.obj"
			Prefilled_CleaningTruckObject = 	SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/lsu.obj"	if PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then set("1-sim/anim/service/lavatoryservicelift",0.9) end Original_CleaningTruckObject = Prefilled_CleaningTruckObject
			if PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
				Prefilled_PushBack1Object = 		Prefilled_LightObject
				Prefilled_PushBackObject = 			SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/Tug2.obj"
			end
		end
	end
	----------------------------------------------------------------------------


	-- to allow X-Plane to toggle between bush mode or not, we save the current selection of objects


		Prefilled_BusObject_option1_civ =	Prefilled_BusObject_option1
		Prefilled_BusObject_option2_civ =	Prefilled_BusObject_option2
		Prefilled_ConeObject_civ 		=	Prefilled_ConeObject
		Prefilled_BollardObject_civ 	=	Prefilled_BollardObject
		Prefilled_CateringTruckObject_civ		=	Prefilled_CateringTruckObject
		Prefilled_CateringHighPartObject_civ 	=	Prefilled_CateringHighPartObject
		Prefilled_CateringHighPart_GG_Object_civ = Prefilled_CateringHighPart_GG_Object
		Prefilled_CateringHighPart_NR_Object_civ = Prefilled_CateringHighPart_NR_Object
		Prefilled_CateringHighPart_MI_Object_civ = Prefilled_CateringHighPart_MI_Object
		Prefilled_CleaningTruckObject_civ 		=	Prefilled_CleaningTruckObject
		Prefilled_PushBack1Object_civ 			=	Prefilled_PushBack1Object
		Prefilled_FuelObject_option1_civ 		=	Prefilled_FuelObject_option1
		Prefilled_FuelObject_option2_civ		=	Prefilled_FuelObject_option2
		Prefilled_StairsObject_civ 		=	Prefilled_StairsObject
		Prefilled_PeopleObject1_civ 	=	Prefilled_PeopleObject1
		Prefilled_PeopleObject3_civ 	=	Prefilled_PeopleObject3
		Prefilled_ForkliftObject_civ 	=	Prefilled_ForkliftObject

	function BushObjectsToggle(milStatus)
		if SGES_BushMode and IsXPlane12 then
			--print("[Ground Equipment " .. version_text_SGES .. "] is toggling ground bush objects")
			Prefilled_BusObject_option1 = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/crew_car.obj"
			Prefilled_BusObject_option2 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/WillysMB.obj"
			Prefilled_ConeObject = XPlane12_BushObjects_directory   .. "barrel_05.obj"
			Prefilled_BollardObject = XPlane12_BushObjects_directory   .. "barrel_open_05.obj"
			Prefilled_CateringTruckObject = XPlane12_BushObjects_directory   .. "clut_small_5x2_06.obj"
			Prefilled_CateringHighPartObject = Prefilled_LightObject
			Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPartObject
			Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPartObject
			Prefilled_CateringHighPart_MI_Object = Prefilled_CateringHighPartObject
			Prefilled_CleaningTruckObject = XPlane12_BushObjects_directory   .. "DkGrpMed1.obj"
			Prefilled_PushBack1Object = XPlane12_ford_carrier_accessories_directory .. "Hyster60_Forklift_Loaded.obj"
			Prefilled_FuelObject_option1 = XPlane_Ramp_Equipment_directory .. "../Dynamic_vehicles/Fuel_Truck_Small.obj"
			Prefilled_FuelObject_option2 = XPlane_Ramp_Equipment_directory .. "../Dynamic_vehicles/Fuel_Truck_Small.obj"
			Prefilled_StairsObject = XPlane12_BushObjects_directory   .. "tennis_judge_01.obj"
			Prefilled_PeopleObject1 =   XPlane12_BushObjects_directory   .. "barrel_open_06.obj"
			Prefilled_PeopleObject3 =   XPlane12_BushObjects_directory   .. "goods_various_02.obj"
			Prefilled_ForkliftObject = 	SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Euro_Airports/Vehicles/Forklifts/Forklift_DFG430_yellow_barrel_up.obj"
			if PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then
				--~ Prefilled_StairsObject =            XPlane_objects_directory .. "../../1000 autogen/global_objects/objects/goods_various_02.obj"
				--~ targetDoorX_alternate = 1.07 targetDoorZ_alternate = -11.95 targetDoorH_alternate = 69
				Prefilled_StairsObject =            XPlane_objects_directory .. "../../airport scenery/Common_Elements/Misc_Buildings/entrance_stairs_3a.obj"
				targetDoorX_alternate = 0.4 targetDoorZ_alternate = -11.7 targetDoorH_alternate = -22
			end
		else
			Prefilled_BusObject_option1 = Prefilled_BusObject_option1_civ
			Prefilled_BusObject_option2 = Prefilled_BusObject_option2_civ
			Prefilled_ConeObject  = Prefilled_ConeObject_civ
			Prefilled_BollardObject = Prefilled_BollardObject_civ
			Prefilled_CateringTruckObject = Prefilled_CateringTruckObject_civ
			Prefilled_CateringHighPartObject = Prefilled_CateringHighPartObject_civ
			Prefilled_CateringHighPart_GG_Object = Prefilled_CateringHighPart_GG_Object_civ
			Prefilled_CateringHighPart_NR_Object = Prefilled_CateringHighPart_NR_Object_civ
			Prefilled_CateringHighPart_MI_Object = Prefilled_CateringHighPart_MI_Object_civ
			Prefilled_CleaningTruckObject = Prefilled_CleaningTruckObject_civ
			Prefilled_PushBack1Object = Prefilled_PushBack1Object_civ
			Prefilled_FuelObject_option1 = Prefilled_FuelObject_option1_civ
			--Prefilled_FuelObject_option2 = Prefilled_FuelObject_option2_civ -- in function
			Prefilled_StairsObject  = Prefilled_StairsObject_civ
			Prefilled_PeopleObject1 = Prefilled_PeopleObject1_civ
			Prefilled_PeopleObject3 = Prefilled_PeopleObject3_civ
			Prefilled_ForkliftObject = Prefilled_ForkliftObject_civ
			Prefilled_ForkliftObject = 	SCRIPT_DIRECTORY .. "../../../default scenery/airport scenery/Euro_Airports/Vehicles/Forklifts/Forklift_DFG430_yellow_barrel_up.obj"
			if PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then
				Prefilled_StairsObject =            XPlane_objects_directory .. "../../1000 autogen/global_objects/constructions/ramp_2_100cm.obj"
				targetDoorX_alternate = 8.2 targetDoorZ_alternate = -11.7 targetDoorH_alternate = 160
			end
		end
		if SGES_BushMode and IsXPlane12 and milStatus == 1 then
			print("[Ground Equipment " .. version_text_SGES .. "] is activating ground military objects in bush mode")
			Prefilled_StairsObject = XPlane12_ford_carrier_accessories_directory   .. "AS32A-35.obj"
			Prefilled_PeopleObject1 = XPlane12_ford_carrier_accessories_directory   .. "Nitrogen_Unit.obj"
			Prefilled_ConeObject = XPlane12_ford_carrier_accessories_directory   .. "Cartridge_Pallet.obj"
			--Prefilled_CateringHighPartObject = Prefilled_LightObject
			Prefilled_BollardObject = XPlane12_ford_carrier_accessories_directory   .. "GBU-38_Cart_Loaded.obj"
			Prefilled_PushBack1Object = XPlane12_ford_carrier_accessories_directory .. "Hyster60_Forklift_Loaded.obj"
			--Prefilled_FuelObject_option2 = XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj" --in function
		elseif SGES_BushMode and IsXPlane12 and milStatus == 0 then
			print("[Ground Equipment " .. version_text_SGES .. "] is deactivating ground military objects in bush mode")
		end
	end
	BushObjectsToggle(military) -- once

	--Prefilled_PushBack1Object = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/all_named_lights.obj"
	----------------------------------------------------------------------------



	----------------------------------------------------------------------------
	-- INITIALISATION OF ALL WHAT IS REQUIRED
	----------------------------------------------------------------------------
	-- Dataref inits
	----------------------------------------------------------------------------



	if XPLMFindDataRef("AirbusFBW/Chocks") ~= nil and string.find(SGES_Author,"Kiwi") then
		IsToLiSs = true
	else
		IsToLiSs = false
		if not IsXPlane12 then
			Prefilled_ASU_ACU = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/ASU_ACU_generic.obj"
			Prefilled_ASU_duct = nil
		else
			Prefilled_ASU_ACU = User_Custom_Prefilled_ASUObject
			if randomView > 0.25 then
				Prefilled_ASU_duct = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/SGES_ASU_duct.obj"
			else
				Prefilled_ASU_duct = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/SGES_ASU_duct2.obj" -- full orange
			end
		end
	end

	Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject

	print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " is loading datarefs. ==0==.")

	if XPLMFindDataRef("sim/graphics/scenery/sun_pitch_degrees") ~= nil then
		sges_sun_pitch 		= dataref_table("sim/graphics/scenery/sun_pitch_degrees")
		--~ print("Sun is " .. sges_sun_pitch[0] .. " degrees above the horizon.")
	end
	--~ print(string.format("TEST TEST1 FlyWithLua Debug Info: Modules directory = %s", MODULES_DIRECTORY))
    --~ print(string.format("TEST TEST2 FlyWithLua Info: Discovered %i HID devices.", NUMBER_OF_HID_DEVICES))

	local SGES_parking_position_cache = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/global_stand_coordinates.cache"
	local SGES_parking_position_cache_CST = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/custom_scenery_stand_coordinates.temp"
	local SGES_parking_position_cache_CS = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/custom_scenery_stand_coordinates.cache"

	local SGES_runway_position_cache = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/global_runway_coordinates.cache"
	local SGES_runway_position_cache_CS = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/custom_scenery_runway_coordinates.cache"
	if IsXPlane12 then
		SGES_IsHelicopter = get("sim/aircraft2/metadata/is_helicopter")

		SGES_IsAirliner= get("sim/aircraft2/metadata/is_airliner")
		print("[Ground Equipment " .. version_text_SGES .. "] sim/aircraft2/metadata/is_helicopter = " .. SGES_IsHelicopter .. ".")
	end

	if SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1 then
		SGES_Throttle = dataref_table("sim/flightmodel2/engines/propwash_mtr_sec") --Caution, SGES_Throttle is PROP WASH for an HELICOPTER !
	else
		SGES_Throttle = dataref_table("sim/cockpit2/engine/actuators/throttle_ratio")
	end
	sges_gs_plane_x			= dataref_table("sim/flightmodel/position/local_x")
	sges_gs_plane_y 		= dataref_table("sim/flightmodel/position/local_y") -- meters !
	sges_gs_plane_y_agl 	= dataref_table("sim/flightmodel/position/y_agl")  -- Altitude above ground level in meter ! /!\
	sges_gs_plane_z 		= dataref_table("sim/flightmodel/position/local_z")
	sges_gs_gnd_spd 		= dataref_table("sim/flightmodel/position/groundspeed")   -- ground speed is in m/sec2
	sges_gs_plane_head 		= dataref_table("sim/flightmodel/position/psi")       -- this is the heading in local coordinate. Note heading in global is different
	sges_gs_ias_spd			= dataref_table("sim/flightmodel/position/indicated_airspeed")
	sges_EngineState 			= dataref_table("sim/flightmodel2/engines/N1_percent")
	sges_StarterState 			= dataref_table("sim/cockpit/engine/ignition_on")
	SGES_vvi_fpm_pilot 	= dataref_table("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
	sges_nosewheel 			= dataref_table("sim/flightmodel/misc/turnrate_noroll")
	sges_HookDown 				= dataref_table("sim/flightmodel2/misc/tailhook_deploy_ratio")
	targetDoorX 			= get("sim/aircraft/view/acf_door_x")
	targetDoorZ 			= get("sim/aircraft/view/acf_door_z")
	targetDoorAltitude 		= get("sim/aircraft/view/acf_door_y")
	SGES_is_glider 			= get("sim/aircraft2/metadata/is_glider")
	SGES_Author 			= get("sim/aircraft/view/acf_author")
	if XPLMFindDataRef("sim/cockpit/electrical/strobe_lights_on") ~= nil and XPLMFindDataRef("sim/cockpit/electrical/landing_lights_on") ~= nil then
		sges_strobe_lights_on		= dataref_table("sim/cockpit/electrical/strobe_lights_on")
		sges_landing_lights_on		= dataref_table("sim/cockpit/electrical/landing_lights_on")
	end

	--~ SGES_scenery_load 			= dataref_table("sim/graphics/scenery/async_scenery_load_in_progress")
	if XPLMFindDataRef("sim/time/local_date_days") then
		SGES_date_in_simulator = dataref_table("sim/time/local_date_days")
		--~ print("[Ground Equipment " .. version_text_SGES .. "] local_date_days " .. SGES_date_in_simulator[0])
	end
	SGES_local_time_in_simulator_hours = dataref_table("sim/cockpit2/clock_timer/local_time_hours")
	SGES_local_time_in_simulator_mins = dataref_table("sim/cockpit2/clock_timer/local_time_minutes")
	SGES_zulu_time_in_simulator_hours= dataref_table("sim/cockpit2/clock_timer/zulu_time_hours")
	SGES_aircraft_has_crashed= dataref_table("sim/flightmodel2/misc/has_crashed")


	--AircraftPath 			= get("sim/aircraft/view/acf_livery_path") -- this dataref is SLOW !

	 -- force Air-to-Air capabilities for a list of aircraft :
	dofile(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Refuelable_Aircraft_list.lua")
	--~ if string.match(AIRCRAFT_PATH, "Tornado") or PLANE_ICAO == "A319" or PLANE_ICAO == "C17" or PLANE_ICAO == "C130" or PLANE_ICAO == "L100" or PLANE_ICAO == "M346" then -- force AAR capabilities
		--~ sges_ahr = 1
	--~ end
	if sges_ahr == 0 and (PLANE_ICAO ~= "C170" and PLANE_ICAO ~= "C172") and string.match(AIRCRAFT_PATH, "C-17") then
		sges_ahr = 1
	elseif sges_ahr == 0 then
		sges_ahr = get("sim/aircraft/overflow/acf_has_refuel")
	end


	if outsideAirTemp == nil 	then
		if IsXPlane12 then
			dataref("outsideAirTemp","sim/weather/aircraft/temperature_ambient_deg_c","readonly") -- °C
			sges_wind		 		= dataref_table("sim/weather/aircraft/wind_speed_kts")
				print("[Ground Equipment " .. version_text_SGES .. "] SGES chooses sim/weather/aircraft/temperature_ambient_deg_c (X-Plane 12 updated dataref).")
		else
			dataref("outsideAirTemp","sim/weather/temperature_ambient_c","readonly") -- °C
			sges_wind		 		= dataref_table("sim/weather/wind_speed_kt")
				print("[Ground Equipment " .. version_text_SGES .. "] SGES chooses sim/weather/temperature_ambient_c (X-Plane 11 legacy dataref).")
		end
	end
	if SGES_parkbrake == nil 		then dataref("SGES_parkbrake","sim/cockpit2/controls/parking_brake_ratio") end



	if SGES_XPlaneIsPaused == nil 	then dataref("SGES_XPlaneIsPaused","sim/time/paused","readonly") end
	if SGES_total_flight_time_sec == nil then dataref("SGES_total_flight_time_sec","sim/time/total_flight_time_sec","readonly") end
	-- gear - ground contact altitude datarefs : https://forums.x-plane.org/index.php?/forums/topic/276142-contact-points-altitude/#comment-2438424
	if IsXPlane12 and ref_to_default == nil 						then  dataref("ref_to_default","sim/flightmodel2/misc/cg_offset_z")
	elseif ref_to_default == nil 									then  dataref("ref_to_default","sim/flightmodel/misc/cgz_ref_to_default")  end
		-- "sim/flightmodel/misc/cgz_ref_to_default" is deprecated in XP12
	if SGES_Vertical_position_gear_strut_extended == nil			then SGES_Vertical_position_gear_strut_extended = dataref_table("sim/flightmodel/parts/tire_y_no_deflection") end
	if SGES_strut_compression == nil								then SGES_strut_compression = dataref_table("sim/flightmodel2/gear/tire_vertical_deflection_mtr") end

	--ALIA
	local SGES_ELEC = dataref_table("sim/cockpit2/electrical/battery_on")

	--~ sges_WoW = dataref_table("sim/cockpit2/tcas/targets/position/weight_on_wheels")

	function delayed_loading_ships_datarefs()
		print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " looks for some required datarefs (wind direction and speed).")
		if IsXPlane12 and XPLMFindDataRef("sim/weather/aircraft/wind_now_direction_degt")  then
			if SGES_Sim_WindDir == nil then dataref("SGES_Sim_WindDir", "sim/weather/aircraft/wind_now_direction_degt","readonly") end
			if SGES_Sim_WindSpd == nil then SGES_Sim_WindSpd = dataref_table("sim/weather/aircraft/wind_speed_kts") end -- kts has a "s" in X-Plane 12
			print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " has loaded extra X-Plane 12 datarefs.")
		elseif XPLMFindDataRef("sim/weather/wind_speed_kt") then -- it's confirmed to be wind_speed_kt (without final s) in X-Plane 11
			if SGES_Sim_WindDir == nil then dataref("SGES_Sim_WindDir", "sim/weather/wind_direction_degt", "readonly") end
			if SGES_Sim_WindSpd == nil then SGES_Sim_WindSpd = dataref_table("sim/weather/wind_speed_kt") end
			print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " has loaded extra X-Plane 11 datarefs.")
		else
			print("[Ground Equipment " .. version_text_SGES .. "] ======== WARNING : CANNOT FIND the required datarefs ! ========")
			print(string.format("[Ground Equipment " .. version_text_SGES .. "] FlyWithLua Debug Info: Modules directory = %s", MODULES_DIRECTORY))
			print("[Ground Equipment " .. version_text_SGES .. "] sim/version/xplane_internal_version " .. SGES_xplane_internal_version .. ".")
		end
	end

	print("[Ground Equipment " .. version_text_SGES .. "] Ground Equipment script " .. version_text_SGES .. " has loaded datarefs. ==0==")
	--print("[Ground Equipment " .. version_text_SGES .. "] Aircraft type is " .. PLANE_ICAO ..", provided by " .. AIRCRAFT_FILENAME .. ".")

	----------------------------------------------------------------------------
	-- Variables inits
	----------------------------------------------------------------------------
	-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	--print("[Ground Equipment " .. version_text_SGES .. "] Will read Pushback sub-script")
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Pushback.lua") -- user settings and preferences
	--normally set in Pushback.lua but you never know :
	if SGES_pushTurn_ratio == nil 	then dataref("SGES_pushTurn_ratio","sim/joystick/yoke_roll_ratio") print("[Ground Equipment " .. version_text_SGES .. "] SGES backup : sim/joystick/yoke_roll_ratio") end
	if SGES_yoke_pitch_ratio == nil then dataref("SGES_yoke_pitch_ratio","sim/joystick/yoke_pitch_ratio") print("[Ground Equipment " .. version_text_SGES .. "] SGES backup : sim/joystick/yoke_pitch_ratio") end
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Aircraft_characteristics.lua") -- user settings and preferences
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Ships_and_secondary_functions.lua")
	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Aircraft_specifics.lua")
	-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

	SGES_stairs_type = "New_Normal"

	prevent_respawn = false


	prepare_special_vehicles_for_aircraft() -- once datarefs have been loaded

	if PLANE_ICAO == "CONC"
		or PLANE_ICAO == "MD11"
		or PLANE_ICAO == "B720"
		or PLANE_ICAO == "B703"
		or string.match(PLANE_ICAO,"B74")
		or string.match(PLANE_ICAO,"B75")
		or string.match(PLANE_ICAO,"B76")
		or string.match(PLANE_ICAO,"B77")
		or string.match(PLANE_ICAO,"B78")
		or string.match(PLANE_ICAO,"A3")
		or string.match(PLANE_ICAO,"A20N")
		or string.match(PLANE_ICAO,"DC")
		or string.match(PLANE_ICAO,"IL96")
		--or string.match(AIRCRAFT_PATH, "C-17") or PLANE_ICAO == "C17"
	then SGES_stairs_type = "New_Normal"
	else SGES_stairs_type = "New_Small"
	end

			------------------------------------------
			-- Boarding_without_stairs /
			------------------------------------------
	-- Aircraft with embedded ladder that don't get mobile stairs from me :
	if string.match(PLANE_ICAO,"DH8")
	or string.match(PLANE_ICAO,"CRJ")
	or ((string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko"))
	or (PLANE_ICAO == "C17" or PLANE_ICAO == "3383")
	or PLANE_ICAO == "ch47"
	or string.match(PLANE_ICAO,"CL")
	or string.match(PLANE_ICAO,"MD8")
	or PLANE_ICAO == "MD90"
	or PLANE_ICAO == "DHC6"
	or PLANE_ICAO == "DC3"
	or PLANE_ICAO == "C47"
	or PLANE_ICAO == "E55P"
	or PLANE_ICAO == "C525"
	or PLANE_ICAO == "E19L"
	or string.match(PLANE_ICAO,"K35")
	or string.match(PLANE_ICAO,"AT4")
	or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)")
	or AIRCRAFT_FILENAME == "AW109SP.acf" and PLANE_AUTHOR == "X-Trident"
	or PLANE_ICAO == "ASB" -- Breguet deux ponts
	or string.match(PLANE_ICAO,"GLF")
	then
		SGES_stairs_type = "Boarding_without_stairs"
	end
	-- added december 2024 :
	-- for small aircraft, activate the passengers
	if (math.abs(BeltLoaderFwdPosition) < 4.5 and not IsXPlane12) or (IsXPlane12 and SGES_IsAirliner ~= nil and SGES_IsAirliner == 0 and math.abs(BeltLoaderFwdPosition) < 4.5) or (IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) then
		-- except for military types
		if PLANE_ICAO == "AV8B" or PLANE_ICAO == "F4" or PLANE_ICAO == "F5" or PLANE_ICAO == "F14" or PLANE_ICAO == "F15" or PLANE_ICAO == "F16" or PLANE_ICAO == "F18" or PLANE_ICAO == "F22" or PLANE_ICAO == "F35" or PLANE_ICAO == "F104" or PLANE_ICAO == "F119" or PLANE_ICAO == "F19" or PLANE_ICAO == "HAWK" or PLANE_ICAO == "M346"
		or (string.find(SGES_Author,"Tom Kyler") and AIRCRAFT_FILENAME == "F-4.acf")
		or string.match(AIRCRAFT_PATH, "Tornado")
		or string.match(AIRCRAFT_PATH, "Buckeye")
		or (string.find(SGES_Author,"Alex Unruh") and AIRCRAFT_FILENAME == "F-14D.acf")
		or (string.find(SGES_Author,"Brault") and AIRCRAFT_FILENAME == "F104A.acf")
		or (string.match(AIRCRAFT_PATH, "Military") and math.abs(BeltLoaderFwdPosition) < 4.5)
		then
			-- do nothing
		else
			SGES_stairs_type = "Boarding_without_stairs" -- civilian type : enable pax
		end
	end
	if targetDoorX_alternate == 0 then -- when it wasn't amended by the aircraft profile
		if (math.abs(BeltLoaderFwdPosition) < 4.5 and not IsXPlane12) or (IsXPlane12 and SGES_IsAirliner ~= nil and SGES_IsAirliner == 0 and math.abs(BeltLoaderFwdPosition) < 4.5) or (IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) then
			targetDoorX_alternate = 0.01
			targetDoorZ_alternate = targetDoorZ
			targetDoorH_alternate = 0.6
		end
	end
			------------------------------------------
			-- / Boarding_without_stairs
			------------------------------------------

	-- when the aircraft is small, our advanced mobile airstairs object wont fit, we revert to our previous smaller object.
	--if (targetDoorAltitude < -0.6) then SGES_stairs_type = "Adaptative" end

	if SGES_stairs_type == "New_Normal" then
		Prefilled_StairsXPJObject 		= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider.obj"
		Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsBase.obj"
		-- toliss or IniSimulations A300-600
		if string.match(PLANE_ICAO,"A20N") or PLANE_ICAO == "A306" then
		Prefilled_StairsXPJObject 		= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider_Blue.obj"
		end
	elseif SGES_stairs_type == "Boarding_without_stairs" then
		Prefilled_StairsXPJObject 		= Prefilled_LightObject
		Prefilled_StairsXPJObject_base 	= XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
	else
		Prefilled_StairsXPJObject 		= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/small/MobileAirstairsSlider_small.obj"
		Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/small/MobileAirstairsBase_small.obj"
	end

	Prefilled_StairsXPJ2Object = Prefilled_StairsXPJObject
	Prefilled_StairsXPJ2Object_base = Prefilled_StairsXPJObject_base
	---------------------------------------------------------------------------------------------------------------------------------
	pushback_manual = false

	local custom_scenery_only = true

	local NotFirstLoad = 0
	IsPassengerPlane = 1
	local GUIIsPassengerPlane = true



	if string.match(AircraftPath ,"321") and (string.find(AircraftPath ,"reight") or string.find(AircraftPath ,"argo") or string.find(AircraftPath ,"P2F") or string.find(AircraftPath ,"PCF") or string.find(AircraftPath ,"Titan") or string.find(AircraftPath ,"NAC") or string.find(AircraftPath ,"Fedex") or string.find(AircraftPath ,"UPS")) then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end
	if string.find(AircraftPath ,"reight") or string.find(AircraftPath ,"argo") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end

	if string.find(AIRCRAFT_FILENAME,"Cargo") or string.find(AIRCRAFT_FILENAME,"Freight") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end


	if string.find(AircraftPath ,"Chinese Spy Balloon") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end

	if PLANE_ICAO == "A3ST" or PLANE_ICAO == "MD11" or PLANE_ICAO == "AN12" or PLANE_ICAO == "C130" or PLANE_ICAO == "L100" or (string.match(AIRCRAFT_PATH, "C-17") and not PLANE_ICAO == "C172" and not PLANE_ICAO == "C170") or (PLANE_ICAO == "C17" or PLANE_ICAO == "3383") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	end

	-- detect a freighter by avoid an F16 or F22 or F35 fighter to be flagged as freighter
	--~ if AIRCRAFT_FILENAME:match("F") and not AIRCRAFT_FILENAME:match("JF") and not string.find(PLANE_ICAO,"F1") and not PLANE_ICAO:match("F1") and not PLANE_ICAO:match("F2") and not PLANE_ICAO:match("F3") then
		--~ IsPassengerPlane = 0
		--~ GUIIsPassengerPlane = false
	--~ end
	-- commented out because of false positives

	if PLANE_ICAO == "CONC" then
		IsPassengerPlane = 1
		GUIIsPassengerPlane = true
	end

	if string.match(AircraftPath ,"146") and string.match(AircraftPath ,"3Q") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	elseif string.match(AircraftPath ,"146") and string.match(AircraftPath ,"2Q") then
		IsPassengerPlane = 0
		GUIIsPassengerPlane = false
	elseif string.match(AircraftPath ,"146") then
		IsPassengerPlane = 1
		GUIIsPassengerPlane = true
	end


	if PLANE_ICAO == "E170" or PLANE_ICAO == "E175" then
		IsPassengerPlane = 1
		GUIIsPassengerPlane = true
	end
	if PLANE_ICAO == "E190" or PLANE_ICAO == "E195" or PLANE_ICAO == "E19L" then
		IsPassengerPlane = 1
		GUIIsPassengerPlane = true
	end

	GUImilitary_sges = false
	GUImilitary_default_sges = false
	GUImoreShip = false
	local military = 0
	local military_default = 0

	-- define the military status for some identified mil planes
	if PLANE_ICAO == "VULC" or PLANE_ICAO == "AV8B" or PLANE_ICAO == "F4" or PLANE_ICAO == "F5" or PLANE_ICAO == "F14" or PLANE_ICAO == "F15" or PLANE_ICAO == "F16" or PLANE_ICAO == "F18" or PLANE_ICAO == "F22" or PLANE_ICAO == "F35" or PLANE_ICAO == "F104" or PLANE_ICAO == "F119" or PLANE_ICAO == "F19" or PLANE_ICAO == "HAWK" or PLANE_ICAO == "M346"
	or PLANE_ICAO == "S92"
	or PLANE_ICAO == "ch47"
	or (string.find(SGES_Author,"Tom Kyler") and AIRCRAFT_FILENAME == "F-4.acf")
	or string.match(AIRCRAFT_PATH, "Tornado")
	or string.match(AIRCRAFT_PATH, "Buckeye")
	or (string.find(SGES_Author,"Alex Unruh") and AIRCRAFT_FILENAME == "F-14D.acf")
	or (string.find(SGES_Author,"Brault") and AIRCRAFT_FILENAME == "F104A.acf")
	or string.match(AIRCRAFT_PATH, "Military")
	then
		military_default = 1
		GUImilitary_default_sges = true
		print("[Ground Equipment " .. version_text_SGES .. "] Switching to MILITARY assets.")
	end



	sges_big_airport = false
	local milheight = 0
	local RunwayEnd_name = ""
	aviationweather_source_us = false
	aviationweather_source_eu = true
	aviationweather_source_es = false
	Cones_chg = false
	GPU_chg = false
	ASU_chg = false
	FUEL_chg = false
	ELEC_chg = false
	Cleaning_chg = false
	BeltLoader_chg = false
	RearBeltLoader_chg = false
	Cart_chg = false
	Stairs_chg = false
	StairsH_chg = false  -- remnant from Stairs Mark II (older versions of the script)
	StairsXPJ_chg = false
	StairsXPJ2_chg = false
	StairsXPJ3_chg = false
	Bus_chg = false
	Catering_chg = false
	FM_chg = false
	FireVehicle_chg = false
	FireSmoke_chg = false
	ULDLoader_chg = false
	People2_chg = false
	People1_chg = false
	People4_chg = false
	People3_chg = false
	Pax_chg = false
	PB_chg = false
	Ship2_chg = false
	Ship1_chg = false
	Chocks_chg = false
	Deice_chg = false
	Light_chg = false
	TargetSelfPushback_chg = false
	TargetMarker_chg = false
	user_targeting_factor = 0
	show_StopSign = false
	StopSign_chg = true
	guidance_active = false
	ArrestorSystem_chg = false
	PRM_chg = false
	Ponev_chg = false
	XP12Carrier_chg = false
	Forklift_chg = false
	DualBoard = false -- false is important beacause on boarding th animation is less good than on deboarding
	CockpitLight_chg = false
	show_Sam = false
	Sam_chg = false
	AAR_chg = false
	Baggage_chg = false
	CargoULD_chg = false
	Helicopters_chg = false

	show_CargoULD = false
	Cami_de_Bellis_authorized = true
	scan_third_party_initially = false
	show_Cones_initially = true
	show_Cones =  false
	show_ASU =  false
	show_ACU =  false
	show_Helicopters = false
	show_WingWalkers = true --IAS24
	--wingwalkers_chg = false --IAS24

	pax1_disapp = false -- used to circumvent the unability in LUA to test multiple table values at the same time when progressively shutting down the (de)boarding
	pax2_disapp = false
	pax3_disapp = false
	pax4_disapp = false
	pax5_disapp = false
	pax6_disapp = false
	pax7_disapp = false
	pax8_disapp = false
	pax9_disapp = false
	pax10_disapp = false
	pax11_disapp = false
	pax12_disapp = false

	-- probe toliss state to avoid removing GPU if it is already connected at SGES script launch.
	if XPLMFindDataRef("AirbusFBW/EnableExternalPower") ~= nil then
		EnableExternalPower = dataref_table("AirbusFBW/EnableExternalPower","readonly")
		-- making a temporary access to the ToLiss dataref to reduce the most possible interactions with the ToLiss model.
		if EnableExternalPower[0] == 1 then show_GPU = true else show_GPU = false end
		EnableExternalPower = nil -- unload dataref
		GPU_chg = true
		if show_GPU and not show_ASU and IsToLiSs then -- add ToLiss GPU
			show_ASU =  true -- also prepare the Low pressure and High pressure object depiction, but then their appearance is 3D animation driven.
			ASU_chg = true
		end
	else
		show_GPU =  false -- <- regular init when no ToLiSs
		IsToLiSs = false -- safety net :-)
	end
	show_FUEL =  false
	show_Pump = false
	if show_ELEC == nil then show_ELEC =  false end
	show_Cleaning =  false
	show_BeltLoader =  false
	show_RearBeltLoader = false
	show_Cart =  false
	hide_temporarily_cart = false
	show_Stairs =  false
	show_StairsH =  false -- remnant from Stairs Mark II (older versions of the script)
	show_StairsXPJ =  false
	show_StairsXPJ2 =  false
	show_StairsXPJ3 =  false
	show_Bus =  false
	boarding_from_the_terminal = false
	terminate_passenger_action = false
	show_Catering =  false
	show_FM =  false
	show_FireVehicle = false
	show_FireSmoke = false
	show_ULDLoader = false
	show_People4 = false
	show_People3 = false
	show_People2 = false
	show_People1 = false
	show_Ship2 = false
	show_Ship1 = false
	show_Chocks = false
	show_PB = false
	show_Deice = false
	show_Light = false
	show_TargetMarker = false
	show_TargetSelfPushback = false
	show_ArrestorSystem = false
	show_Pax = false
	show_PRM = false
	show_DoorOpen = false
	show_Ponev = false
	show_XP12Carrier = false
	show_Forklift = false
	adjust_StairsXPJ = false
	option_StairsXPJ = false
	protect_StairsXPJ = false
	stairs_authorized = true
	option_StairsXPJ_override = false
	adjust_BeltLoader = false
	force_factor_forced = -0.02
	adjust_Strength = false
	show_CockpitLight = false
	read_the_SGES_startup_options = false
	stand_searched_flag = false
	direct_Marshaller = false
	show_ColimataFUEL = false
	show_AAR = false
	show_Baggage = false
	show_VDGS = false

	automatic_display_EMS_acceptable = false

	user_boat_lat = nil
	user_boat_lon = nil

	SelfPushback_requested = false
	TargetSelfPushbackH_stored = -999
	SPB_distance = 38 -- minimal pushback to take into account the braking radius
	turn_flag = false
	SPB_orientation = 0
	SGES_HandlingSpeeds = false
	VDGS_time = "local"

	VDGS_manual = false
	boat_manual_control = false
	heading_flag_selected = 0

	center_line_sticky_heading_threshold = 10
	reduced_custom_scenery_folder_name = "no scenery explored yet"
	carrier_rank = 1 -- carrier group, index of the list
	DistanceToShipWreckSite_initial = DistanceToShipWreckSite

	Passenger_step_t = {Pax1=-1,Pax2=-1,Pax3=-1,Pax4=-1,Pax5=-1,Pax6=-1,Pax7=-1,Pax8=-1,Pax9=-1,Pax10=-1,Pax11=-1,Pax12=-1}

	Threat_module_loaded = false
	VDGS_module_loaded = false
	--~ VDGS_suitable_airport = false
	sges_respawn_loaded = false

	FrontLoader_x = 0
	FrontLoader_z = 0

	longitudinal_factor3_ULDLoader = 0
	lateral_factor_ULDLoader = 0

	-- prepare loading of optional aircraft profile :
	SGES_CONFIG_PLANE_ICAO = "none"
	SGES_CONFIG_SGES_Author = "none"
	SGES_CONFIG_AIRCRAFT_FILENAME = "none"

	function developer_change()
		FireVehicle_chg = true
		GPU_chg = true
		ASU_chg = true
		RearBeltLoader_chg = true
		FUEL_chg = true
		Cleaning_chg = true
		PRM_chg = true
		BeltLoader_chg = true
		Cart_chg = true
		ULDLoader_chg = true
		Stairs_chg = true
		StairsH_chg = true
		Catering_chg = true
		Cones_chg = true
		People1_chg = true
		People2_chg = true
		People3_chg = true
		People4_chg = true
		Bus_chg = true
		Pax_chg = true
		Deice_chg = true
		Light_chg = true
		StairsXPJ_chg = true
		StairsXPJ2_chg = true
		StairsXPJ3_chg = true
		Forklift_chg = true
		PRM_chg = true
		Ponev_chg = true
		AAR_chg = true
	end

	--~ function SGES_mouse_wheel_action(value_by_wheel)
		--~ if MOUSE_WHEEL_CLICKS ~= nil then
			--~ value_by_wheel = tonumber(value_by_wheel) + MOUSE_WHEEL_CLICKS / 10
			--~ RESUME_MOUSE_WHEEL = true
		--~ end
		--~ return value_by_wheel
	--~ end


	-- replace those values with the user values :
	--print("[Ground Equipment " .. version_text_SGES .. "] Will read user configuration from Simple_Ground_Equipment_and_Services_CONFIG_default_options")


	function startup_options__delayed()

		------------------------------------------------------------------------
		------------------------------------------------------------------------
		if PLANE_AUTHOR == nil then
			print("[Ground Equipment " .. version_text_SGES .. "] PLANE_AUTHOR == nil")
			PLANE_AUTHOR = "SGES_temporary_value_null"
		elseif PLANE_AUTHOR == "" then
			print("[Ground Equipment " .. version_text_SGES .. "] PLANE_AUTHOR == empty")
			PLANE_AUTHOR = "SGES_temporary_value_empty"
		--~ else
			--~ print("[Ground Equipment " .. version_text_SGES .. "] PLANE_AUTHOR loaded.")
		end

		if PLANE_ICAO == nil then
			print("[Ground Equipment " .. version_text_SGES .. "] PLANE_ICAO == nil")
			PLANE_ICAO = "ZZZZ"
		elseif PLANE_ICAO == "" then
			print("[Ground Equipment " .. version_text_SGES .. "] PLANE_ICAO == empty")
			PLANE_ICAO = "ZZZZ"
		--~ else
			--~ print("[Ground Equipment " .. version_text_SGES .. "] PLANE_ICAO loaded.")
		end

		if AIRCRAFT_PATH == nil then
			print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_PATH == nil")
			AIRCRAFT_PATH = "ZZZZ"
		elseif PLANE_ICAO == "" then
			print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_PATH == empty")
			AIRCRAFT_PATH = "ZZZZ"
		--~ else
			--~ print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_PATH loaded.")
		end


		if AIRCRAFT_FILENAME == nil then
			print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_FILENAME == nil")
			AIRCRAFT_FILENAME = "ZZZZ.acf"
		elseif AIRCRAFT_FILENAME == "" then
			print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_FILENAME == empty")
			AIRCRAFT_FILENAME = "ZZZZ.acf"
		--~ else
			--~ print("[Ground Equipment " .. version_text_SGES .. "] AIRCRAFT_FILENAME loaded.")
		end
		------------------------------------------------------------------------
		------------------------------------------------------------------------


		if sges_EngineState[0] < 5 and sges_StarterState[0] == 0 and SGES_is_glider == 0 and sges_gs_plane_y_agl[0] < 2 then
			read_the_SGES_startup_options = true
			dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_options.lua") -- user settings and preferences
			if SGES_start_delay == 0 then
				print("[Ground Equipment " .. version_text_SGES .. "] Applying startup options from FlyWithLua/Scripts/Simple_Ground_Equipment_and_Services_CONFIG_options.lua without delay.")
			else
				print("[Ground Equipment " .. version_text_SGES .. "] Applying startup options from Simple_Ground_Equipment_and_Services_CONFIG_options.lua with a " .. SGES_start_delay .." a.u. delay.")
			end

			-- MODULATE FORWARD AIRSTAIRS
			-- forward STAIRS set to TRUE isn't recommended because is compatible with a few aircraft
			-- so let allow that for airliners only :
			if show_StairsXPJ == true and SecondStairsFwdPosition == -30 then
				-- I know that aircraft with the parameter "SecondStairsFwdPosition" ~= than "-30" are airliners that I tuned particularly well, it's safe to go.
				show_StairsXPJ = false -- otherwise I kill the stairs no matter what the user wrote.
			end

			-- allow the change in case selected by the user :
			Chocks_chg = true -- reset chocks to avoid drifting
			  --~ On 1/4/2024 at 10:24 PM, l_bratch said: --~ when they are enabled *at startup* using SGES this rotation happens.
			-- Retain "show_Chocks = false" by default.
			-- This setting is deactivated because if set to true, this has detrimental effects
			-- such as having the plane slide or change its heading after the initial X-Plane
			-- session load.  A long discussion occured between me and users and in the end, it's
			-- better to always have show_Chocks = false at X-Plane startup.
			-- My explanation is that the chocks are generated too early at X-Plane startup while
			-- we need to allow the situation to load completely and the plane to settle in a
			-- "comfortable attitude" first.
			Cones_chg =  	true	-- Cones around the aircraft
			FUEL_chg =  	true	-- Fuel truck
			Cleaning_chg =  true -- AFT van or vehicule
			BeltLoader_chg =  true	-- Forward beltloader or ULD
			RearBeltLoader_chg = true -- Aft baggage conveyor
			Cart_chg =  	true	-- Baggage cart
			Catering_chg =  true	-- Catering vehicle
			FireVehicle_chg = true	-- Emergency vehicule
			PRM_chg = 		true -- People with reduced mobility
			Bus_chg =  		true	-- passengers bus (for pax aircraft)
			ULDLoader_chg = true	-- CARGO loader (for freighters)
			StairsXPJ_chg =  true		-- forward STAIRS
			--~ VDGS_chg = true

			-- also open the aircraft door when defined in the aircraft set
			if show_DoorOpen and dataref_to_open_the_door ~= nil and target_to_open_the_door ~= nil then
				if PaxDoor1L == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil and PLANE_ICAO ~= "MD88"  and PLANE_ICAO ~= "MD11" and not string.find(PLANE_ICAO,"B73") then
					dataref("PaxDoor1L",dataref_to_open_the_door,"writable",index_to_open_the_door)
				end
				if index_to_open_the_second_door ~= nil and PaxDoorRearLeft == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil then
					dataref("PaxDoorRearLeft",dataref_to_open_the_door,"writable",index_to_open_the_second_door)
					print("[Ground Equipment " .. version_text_SGES .. "]  PaxDoorRearLeft dataref is loaded from Simple Ground Equipment, via a second index (same dataref)")
				elseif dataref_to_open_the_second_door ~= nil and PaxDoorRearLeft == nil and XPLMFindDataRef(dataref_to_open_the_second_door) ~= nil then
					dataref("PaxDoorRearLeft",dataref_to_open_the_second_door,"writable",index_to_open_the_door)
					print("[Ground Equipment " .. version_text_SGES .. "]  PaxDoorRearLeft dataref is loaded from Simple Ground Equipment, via a second dataref.")
				end
				if show_DoorOpen and PaxDoor1L ~= nil and PaxDoor1L ~= target_to_open_the_door then
					PaxDoor1L = target_to_open_the_door
				end
			end

		end

		if sges_airport_ID == nil then sges_airport_ID = "ZZZZ" end
		sges_big_airport,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,sges_airport_ID)
		if BeltLoaderFwdPosition > 8 and sges_big_airport then show_Pump = sges_big_airport end

		--------------------------------------------------------------------
		--Read the aircraft profile if any.
		-- This profile is optional, lots of aircraft are already defined in
		-- the general file FlyWithLua/Scripts/Simple_Ground_Equipment_and_
		-- Services_CONFIG_aircraft.lua. This profile allows personnalisation
		-- only. You can remove any custom profile safely.
		--~ print("[Ground Equipment " .. version_text_SGES .. "] Checking if aircraft_optional_profiles/SGES_CONFIG_" .. AIRCRAFT_FILENAME ..".lua exists...")
		Read_the_aircraft_profile_if_any()

		--~ print("[Ground Equipment " .. version_text_SGES .. "] Checking if aircraft_optional_profiles/SGES_USER_CONFIG.lua exists...")
		if file_exists(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_USER_CONFIG.lua") then -- this file isn't distributed by XPJavelin
			-- users can make their own settings file
			dofile(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_USER_CONFIG.lua")
			print("[Ground Equipment " .. version_text_SGES .. "] Reading user settings inside aircraft_optional_profiles/SGES_USER_CONFIG.lua")

			if not show_Cones_initially and show_Cones then
				show_Cones = false
				Cones_chg =  true
			end
		end

		if sges_ahr ~= nil then print("[Ground Equipment " .. version_text_SGES .. "] Aircraft has in-flight refueling capabilities. 	sges_ahr = " .. sges_ahr) end
		if sges_ahr ~= nil and sges_ahr == 1 then
			create_command("Simple_Ground_Equipment_and_Services/AAR/Display_Tanker", "Refuel from the tanker (if avail.)", "if not show_AAR and show_Sam == false then show_AAR = true AAR_chg = true else show_AAR = false  AAR_chg = true end", "", "")
		end


		-- detect external assert from third party.
		if scan_third_party_initially ~= nil and scan_third_party_initially then
			-- we do this delayed, because we need to interrogate USER_CONFIG.lua first
			if XTrident_Chinook_Directory == nil then XTrident_Chinook_Directory = scan_for_external_asset("CH47 v2.0","CH47-D Chinook v1.0",0)
			else
				print("[Ground Equipment " .. version_text_SGES .. "] X-Trident Chinook path is already referenced in the local user settings (no new scan done).")
			end -- 0 is not verbose
			if XTrident_NaveCavour_Directory == nil then XTrident_NaveCavour_Directory = scan_for_external_asset("AV-8B v2","AV-8B v3",0)
			else
				print("[Ground Equipment " .. version_text_SGES .. "] X-Trident Cavour aircraft carrier path is already referenced in the local user settings (no new scan done).")
			end -- 0 is not verbose
			if XTrident_NaveCavour_Directory ~= nil then XTrident_NaveCavour_Object =  SCRIPT_DIRECTORY .. XTrident_NaveCavour_Directory .. "/extra/Nave Cavour/Nimitz.obj" end
			if FFSTS_777v2_Directory == nil then
				FFSTS_777v2_Directory= scan_for_external_asset("Boeing777-200ER","Boeing777-200ER",0)
			else
				print("[Ground Equipment " .. version_text_SGES .. "] FlightFactor/StepToSky Boeing777-200 path is already referenced in the local user settings (no new scan done).")
			end
			if Cami_de_Bellis_Directory == nil then
				Cami_de_Bellis_Directory= scan_for_external_asset("is in custom scenery folder","CDB-Library",0)
			else
				print("[Ground Equipment " .. version_text_SGES .. "] Cami de Bellis library is already referenced in the local user settings (no new scan done).")
			end
		end
		-- When the Boeing 777 from Flight Factor and STS, load their own objects instead.
		if FFSTS_777v2_Directory ~= nil and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then 	load_special_B777v2_objects(FFSTS_777v2_Directory)	end
		if XTrident_NaveCavour_Directory ~= nil then XTrident_NaveCavour_Object =  SCRIPT_DIRECTORY .. XTrident_NaveCavour_Directory .. "/extra/Nave Cavour/Nimitz.obj" end


		if sges_EngineState[0] < 5 and sges_StarterState[0] == 0 and SGES_is_glider == 0 and sges_gs_plane_y_agl[0] < 2 then
			-- only ring SGES ready when aircraft is parked.
			if play_sound_SGES_is_available then
				SGES_is_available_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/SGES_is_available.wav") -- -- sound number 2
				set_sound_gain(SGES_is_available_sound, 0.25)
				play_sound(SGES_is_available_sound)
				SGES_is_available_sound = nil
			end
			print("[Ground Equipment " .. version_text_SGES .. "] Good to go, we should have loaded everything by now.")
		else
			print("[Ground Equipment " .. version_text_SGES .. "] Good, we have loaded everything by now (with aircraft already running).") -- make a viual differenciation in the log for the dev.
		end

		automatic_display_EMS_acceptable = true --enabling the EMS upon crash only once the situation is stable and loaded. Important.

		print("\n====================================")
		--------------------------------------------------------------------

		read_the_SGES_startup_options = false -- permit that only once
	end

	automatic_marshaller_requested = false
	automatic_marshaller_already_requested_once = false
	approaching_TargetMarker = 0

	local TargetMarkerX = sges_gs_plane_x[0]
	local TargetMarkerZ = sges_gs_plane_z[0]
	local TargetMarkerH = sges_gs_plane_head[0]
	local TargetMarkerY = sges_gs_plane_y[0]
	--~ local TargetMarkerX_stored = sges_gs_plane_x[0] + 10
	--~ local TargetMarkerZ_stored = sges_gs_plane_z[0] + 10

	local follow_me_x = sges_gs_plane_x[0]
	local follow_me_z = sges_gs_plane_z[0]
	local follow_me_y = sges_gs_plane_y[0]
	local follow_me_h = 180
	local targetX = 0
	local targetZ = 0
	local outHeading = 0

	target_boat_course = 180
	target_rudder_course = 0
	target_boat_speed = 11
	target_boat_knots = 21

	StairFinalY_stairIII = 0
	StairFinalH_stairIII = 0
	StairFinalX_stairIII = 0
	StairFinalX_stairIII = 0
	InitialPaxHeight_stairIII = 0
	StairFinalY_stairIV =  SecondStairsFwdPosition - 0.15
	StairFinalH_stairIV = 0
	StairFinalX_stairIV = 0
	StairFinalX_stairIV = 0
	InitialPaxHeight_stairIV = 0
			--
	local	approaching_TargetMarker = 0
	local	stand_found_flag = 0

	local Busobject = XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_01.obj"
	local CatObject = XPlane_Ramp_Equipment_directory   .. "../../1000 roads/objects/cars_EU/dynamic/d_busIC_01.obj"
	--targetDoorX = 0
	--targetDoorZ = 0
	--targetDoorAltitude = 0
	local radioaltFM = 0
	g_shifted_x = sges_gs_plane_x[0]
	g_shifted_z = sges_gs_plane_z[0]
	local aircraftPositionSaved = false
	local parking_position_heading = 0
	retained_parking_position_heading = 0

	stairs_LEFT_RIGHT = 10
	stairs_AFT_FWD = 10
	plate_vert = 0

	starting_deice_time = -9999
	if airstart_unit_factor == nil then airstart_unit_factor = 16.4 end


	-- SETTINGS FOR PASSENGERS BOARDING
	X_speed_part_1 = 0.0073
	H_speed_part_1 = 0.0053
	X_speed_part_2 = 0.005
	H_speed_part_2 = 0.005
	walking_direction = "boarding"

	StopZoneX = -1
	StopZoneZ = -1
	StopzoneY = -1
	local syspath = ""
	local BUFSIZE = 102400  -- read in blocks of 100Kb
	local groundservices_wnd = nil
	local holder_wnd = nil
	local screen_width = 1920
	local Holder_len = 30
	local prev_mouse_Y = 0
	local holder_drag = 0
	local toggle_windoz = false
	local windoz_is_open = false
	local prepare_show_objects = false
	local prepare_kill_objects = false
	local init_load = 0
	local windoz_first_access = false
	local Win_Y = 500
	local rampservice_chg = false           -- to draw the new service location whenever a chg to the arrival or depart gate is detected
	local rampserviceD_chg = false           -- to draw the new service location whenever a chg to the arrival or depart gate is detected

	local fuel_show_only_once = true
	bus_show_only_once = true
	cart_show_only_once = true
	FM_show_only_once = true
	PB_show_only_once = true
	Ponev_show_only_once = true
	baggage_show_only_once = true
	baggage1_show_only_once = true
	baggage2_show_only_once = true
	baggage3_show_only_once = true
	baggage4_show_only_once = true
	baggage5_show_only_once = false
	passenger1_show_only_once = true
	passenger2_show_only_once = true
	passenger3_show_only_once = true
	passenger4_show_only_once = true
	passenger5_show_only_once = true
	passenger6_show_only_once = true

	passenger7_show_only_once = true
	passenger8_show_only_once = true
	passenger9_show_only_once = true
	passenger10_show_only_once = true
	passenger11_show_only_once = true
	passenger12_show_only_once = true

	StopSign_show_only_once = true
	TargetMarker_show_only_once = true
	TargetSelfPushback_show_only_once = true
	CockpitLight_show_only_once = true

	StairsXPJ2_0_show_only_once = true
	StairsXPJ2_1_show_only_once = true
	StairsXPJ_0_show_only_once = true
	StairsXPJ_1_show_only_once = true
	StairsXPJ3_0_show_only_once = true
	StairsXPJ3_1_show_only_once = true
	Deice_0_show_only_once = true
	Deice_1_show_only_once = true
	Deice_2_show_only_once = true
	People1_show_only_once = true
	People2_show_only_once = true
	People3_show_only_once = true
	People4_show_only_once = true
	ULDLoader_show_only_once = true
	ULD_show_only_once = true
	PRM_0_show_only_once = true
	PRM_1_show_only_once = true
	stairs_LR_show_only_once = true
	RearBeltLoader_show_only_once = true
	BeltLoader_show_only_once = true
	Cleaning_show_only_once = true
	Catering_show_only_once = true
	ASU_show_only_once = true
	Forklift_show_only_once = true

	Helicopters_draw_only_once = true

	Submarine_draw_only_once = true

	show_Watersalute = false
	final_heading = false

	distance_to_fuselage = 0 -- belt loader
	TargetSelfPushbackX_stored = 0
	TargetSelfPushbackZ_stored = 0
	CargoDeck_ULDLoaderObject = "high_variant" -- regular variant

--------------------------------------------------------------------------------

	function Support_Arrestor_Heading_With_ILS(searchX,searchZ,runwayBearing)

		ILS_Heading_support = nil
		outName = nil
		outX = nil
		outZ = nil
		heading = nil
		ffi.cdef("void XPLMLocalToWorld(double inX,  double inY,   double inZ,   double *   outLatitude,      double *     outLongitude,   double *     outAltitude);")
		local inAltitudeW = 0
		local outX = ffi.new("double[1]")
		local outY = ffi.new("double[1]")
		local outZ = ffi.new("double[1]")
		XPLM.XPLMLocalToWorld(searchX, 0, searchZ, outX, outZ, outY )
		--~ print("X " .. searchX .. " out X : " .. outX[0])
		--~ print("Z " .. searchZ .. " out Z : " .. outZ[0])
		Idling_airport_index = XPLMFindNavAid( nil, nil, outX[0], outZ[0], nil, xplm_Nav_ILS) --xplm_Nav_ILS xplm_Nav_Localizer

		-- all output we are not interested in can be send to variable _ (a dummy variable)
		_, ilsX, ilsZ, _, _, ILS_Heading_support, _, outName = XPLMGetNavAidInfo( Idling_airport_index )

		-- FILTER ILS BYT PROXIMITY AND ANGLE

		local Tolerance = 0.005 -- LLOV carring ILS info from LLER is a problem which led to carefull calibration to 0.001 but at the same time catching ILS at LLER runway end is 0.004. Tradeoff.
		local angleTolerance = 9
		local keeper = false
		--~ print("runway end X " .. outX[0] .. " nearest ILS X : " .. ilsX .. " (" .. outName .. ") difference is " .. ilsX - Tolerance )
		--~ print("runway end Z " .. outZ[0] .. " nearest ILS Z : " .. ilsZ .. " (" .. outName .. ") difference is " .. ilsZ - Tolerance )
		-- second filtering of the use (or not) of the ILS : by the Long and Lat
		if ILS_Heading_support ~= nil and ((ilsX - Tolerance < outX[0] and  outX[0] < ilsX + Tolerance ) and (ilsZ - Tolerance < outZ[0] and  outZ[0] < ilsZ + Tolerance ))	 then
			-- second filtering of the use (or not) of the ILS : by the angle
			if ILS_Heading_support >= 0 and ILS_Heading_support - angleTolerance < runwayBearing and runwayBearing < ILS_Heading_support + angleTolerance then
				--print("[Ground Equipment " .. version_text_SGES .. "] Nearby ILS : " .. outName .. " at heading " .. ILS_Heading_support .. "°.")
				keeper = true -- keep ILS_Heading_support
			else keeper = false -- annihilate this result.
			end
		end

		return ILS_Heading_support,outName,keeper
	end

	function ArrestorSystemAirportILS()
		Idling_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_ILS) --xplm_Nav_ILS xplm_Nav_Localizer

		-- let's examine the name of the airport we found, all variables should be local
		-- we do not waste Lua with variables to avoid conflicts with other scripts
		outHeight = 0
		outName = "nil"
		outX = 0
		outX = "nil"
		outZ = 0
		outZ = "nil"

		-- all output we are not interested in can be send to variable _ (a dummy variable)
		_, outX, outZ, outHeight, _, outHeading, _, outName = XPLMGetNavAidInfo( Idling_airport_index )
		outHeight = math.floor(outHeight*3.28084) -- meters to feet
		ArrestorX=outX
		ArrestorZ=outZ

		-- the last step is to create a global variabling function can read out end
	end

	local retained_RunwayEnd_lat = 0
	local retained_RunwayEnd_lon = 0
	--local RunwayEnd_name = 0

	local function inverse_runway_name(inbound)
			if inbound ~= nil then

				if previous_Runway_numbers == nil then previous_Runway_numbers = "null" end
				if count_runways == nil then count_runways = 1 end
				if runways_t == nil then runways_t = {} end

				RunwayEnd_chiffre = tonumber(string.match(inbound, "(%d*%d)%u-"))
				if RunwayEnd_chiffre ~= nil and RunwayEnd_chiffre > 18 then Runway_numbers = RunwayEnd_chiffre - 18 else Runway_numbers = RunwayEnd_chiffre + 18 end
				local RunwayEnd_letter = string.match(inbound, "%d*%d(%u*)")
				if RunwayEnd_letter ~= nil and string.find(RunwayEnd_letter,"R") then Runway_letter = "L"
				elseif RunwayEnd_letter ~= nil and  string.find(RunwayEnd_letter,"L") then Runway_letter = "R" end




				if Runway_letter ~= nil then
					RunwayName = Runway_numbers .. Runway_letter
				else
					RunwayName = Runway_numbers
				end

				-- two different buttons cannot share the same name, so several runways from diff airport in the vicinity must be differenciated in the GUI :
				for index,previous_name in pairs(runways_t) do
					local previous_name = 	tostring(runways_t[index])
					if previous_name ~= nil and string.match(previous_name,RunwayName) then
						-- differenciate the name by adding a wee something to it.
						RunwayName = RunwayName .. "."
						break
					end
				end

				-- store the current name in the table :
				runways_t[count_runways] = RunwayName

				--~ print("New runway name   " .. RunwayName .. " from " .. RunwayEnd_chiffre)
				Runway_letter = nil
				RunwayEnd_chiffre = nil
				count_runways = count_runways + 1
				return RunwayName
			end
	end

	function ObtainArrestorCoordinates(i)
	-- to be stored into TargerMarker
		if Runway[i].Name ~= nil then
			ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")
			local inAltitudeW = 0
			local outX = ffi.new("double[1]")
			local outY = ffi.new("double[1]")
			local outZ = ffi.new("double[1]")
			XPLM.XPLMWorldToLocal(Runway[i].RunwayEnd_lat, Runway[i].RunwayEnd_lon, inAltitudeW, outX, outY, outZ )
			--print("lat " .. Runway[i].RunwayEnd_lat .. " Lon " .. Runway[i].RunwayEnd_lon)
			ArrestorZ = outZ[0]
			ArrestorX = outX[0]
			outHeight = 0
		end
	end


	local function ArrestorSystemAirportRWY()
		local runway_found_flag = 0

		io.input(SGES_runway_position_cache)
		local count = 1
		while true do
			local apt_content = io.read()
			if apt_content == nil then break end -- when the file is finished
			local RunwayEnd_lat = string.match(apt_content, "%d*%d%u-%s+(%--%d+%.%d+)%s+%--%d+%.%d")
			local RunwayEnd_lon = string.match(apt_content, "%d*%d%u-%s+%--%d+%.%d+%s+(%--%d+%.%d+)")
			local RunwayEnd_heading = string.match(apt_content, "(%d*%d)%u-%s+%--%d+%.%d+%s+%--%d+%.%d+")

			-- ADD HERE THE RWY BEARING
			local RunwayEnd_calculated_bearing = string.match(apt_content, ";(%d+);")



			if RunwayEnd_lat == nil then RunwayEnd_lat = 0 end
			if RunwayEnd_lon == nil then RunwayEnd_lon = 0 end
			if RunwayEnd_heading == nil then RunwayEnd_heading = sges_gs_plane_head[0] end

			RunwayEnd_lat = tonumber(RunwayEnd_lat)
			RunwayEnd_lon = tonumber(RunwayEnd_lon)
			--RunwayEnd_heading = tonumber(RunwayEnd_heading)*10
			RunwayEnd_heading = tonumber(RunwayEnd_calculated_bearing)
			if RunwayEnd_heading ~= nil and RunwayEnd_heading > 0 and RunwayEnd_heading < 361 and RunwayEnd_lon ~= nil and RunwayEnd_lat ~= nil then
				--print("Runway " .. RunwayEnd_name)
				--print(RunwayEnd_lat)
				--print(RunwayEnd_lon)
				--print(RunwayEnd_heading)

				difference_lat = 0
				difference_lon = 0

				difference_lat = math.abs(RunwayEnd_lat - LATITUDE)
				difference_lon = math.abs(RunwayEnd_lon - LONGITUDE)

				--print(RunwayEnd_lat)
				--print(RunwayEnd_lon)
				--print(difference_lat)
				--print(difference_lon)
				local capture_threshold_lat = RunwayEnd_capture_position_threshold
				local capture_threshold_lon = RunwayEnd_capture_position_threshold


				if difference_lat < capture_threshold_lat and difference_lon < capture_threshold_lon then
					runway_found_flag = runway_found_flag + 1   -- we display an arrestor system no matter if the user made a runway selecion

					--~ Runway[5].Name = 			RunwayName -- inversed for the GUI
					--~ Runway[5].EndName = 		RunwayEnd_name
					--~ Runway[5].RunwayEnd_lat = 	RunwayEnd_lat
					--~ Runway[5].RunwayEnd_lon = 	RunwayEnd_lon
					--~ Runway[5].RunwayEnd_hdg = 	RunwayEnd_heading
					--~ Runway[5].outHeading = RunwayEnd_heading - 180

					RunwayEnd_name = string.match(apt_content, "(%d*%d%u-)%s+%--%d+%.%d+%s+%--%d+%.%d+")
					--inverse runway name

					-- ie when landing on runway 22L at KJFK, the actual system was intended for the runway end 4R
					RunwayName = inverse_runway_name(RunwayEnd_name)
					--~ print("RunwayEnd_name : " .. RunwayEnd_name .. " and RunwayName : " .. RunwayName)

					for i=1,12 do							-- prepares the user runway selection
						if runway_found_flag == i then
							Runway[i].Name = 			RunwayName -- inversed for the GUI
							Runway[i].EndName = 		RunwayEnd_name
							Runway[i].RunwayEnd_lat = 	RunwayEnd_lat
							Runway[i].RunwayEnd_lon = 	RunwayEnd_lon
							Runway[i].RunwayEnd_hdg = 	RunwayEnd_heading
							Runway[i].outHeading = 		RunwayEnd_heading - 180
							if RunwayEnd_heading - 180 < 0 then Runway[i].outHeading = 		RunwayEnd_heading + 180 end
							--print("[Ground Equipment " .. version_text_SGES .. "] runway avail. :   " .. RunwayName .. " /" .. i)
							--print(Runway[i].outHeading)
						end
					end
				end
				count = count + 1
				if runway_found_flag == 13 then break end
			end
		end

		--if runway_autoselected then
		--	ObtainArrestorCoordinates(5)
		--end
	end


	-- -----------------------------------------------------------------------------


	-- documentation :
	-- draw_static_object(target X, target Z, object heading correction, instance, object informatic name)
	-- X is controlling left / right axis
	-- Z is controllong forward / aft axis
	latcone = 8 -- for passengers walk to the aft stairs
	loncone = 0 -- for passengers walk to the aft stairs

	function service_object_physics_Cones()

	  if Cones_chg == true then

		if show_Cones and PLANE_ICAO == "M346" and PLANE_AUTHOR == "Kostas Koronakis Dimitris Koronakis Andrzej Borysewicz" then -- toggle M346 Remove before flight ON
			set("DWSim/m346/external/rbf",0)
		elseif not show_Cones and PLANE_ICAO == "M346" and PLANE_AUTHOR == "Kostas Koronakis Dimitris Koronakis Andrzej Borysewicz" then -- toggle M346 Remove before flight OFF
			set("DWSim/m346/external/rbf",1)
		end


		  if show_Cones == true then
			load_Cones()
			if IsXPlane12 and SGES_IsHelicopter == 1 and AIRCRAFT_FILENAME == "Bell412.acf" and sges_gs_plane_y_agl[0] < 1 and sges_gs_gnd_spd[0] < 1 then
				command_once("412/buttons/remove_before_flight_on")
				command_once("412/buttons/PATIENT_off")
			end
		  else
			if IsXPlane12 and SGES_IsHelicopter == 1 and AIRCRAFT_FILENAME == "Bell412.acf" and sges_gs_plane_y_agl[0] < 1 and sges_gs_gnd_spd[0] < 1 then
				command_once("412/buttons/remove_before_flight_off")
			end
			 -- unload_Cones()
			 Cones_chg,Cones_instance[0],rampserviceref0 = common_unload("Cones",Cones_instance[0],rampserviceref0)
			 Cones_chg,Cones_instance[1],rampserviceref3 = common_unload("Cones",Cones_instance[1],rampserviceref3)
			 Cones_chg,Cones_instance[2],rampserviceref010 = common_unload("Cones",Cones_instance[2],rampserviceref010)
			 Cones_chg,Cones_instance[3],rampservicerefBo = common_unload("Cones",Cones_instance[3],rampservicerefBo)
			 Cones_chg,Cones_instance[4],rampservicerefBo4 = common_unload("Cones",Cones_instance[4],rampservicerefBo4)
		  end

		  if Cones_instance[0] ~= nil and Cones_instance[1] ~= nil and Cones_instance[2] ~= nil and Cones_instance[3] ~= nil and Cones_instance[4] ~= nil then
			-- FIRST cone (for the engine supposely)
			local x = 5
			local z = 5.5
			if BeltLoaderFwdPosition >= 14 then -- bigger wingspan supposed
				x = 10
				z = 10
			elseif string.match(PLANE_ICAO,"CRJ")  then -- away
				x = 5
				z = 3
			elseif PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- away
				x = 5
				z = 1
			end
			draw_static_object(x,z,15,Cones_instance[0],"Cones") -- FIRST cone (for the engine supposely)

			 -- Right Engine cone
			x = -x
			-- or use it on the left hand side if conditions apply :
			if PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- away
				x = -0.15
				z = 10.5
			elseif math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5  then  -- on the left hand side only
				x = 15.5
				z = -3.2
			elseif string.match(PLANE_ICAO,"CRJ")  then -- away
				x = 0.25
				z = -16
			end
			Cones_chg = draw_static_object(x,z,35,Cones_instance[2],"Cones") -- Right Wing cone

			 -- Left Wing cone
			x = 15
			z= -3
			if PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- away
				x = 4.5
				z = -3.5
			elseif math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5  then
				x = 9
				z = 0

			elseif BeltLoaderFwdPosition >= 19 then
				-- B748, A330, A340
				x = 24
				z = -2
			elseif BeltLoaderFwdPosition >= 14 then -- bigger wingspan supposed
				x = 22
				z = -2
			elseif string.match(PLANE_ICAO,"CRJ") then -- away
				x = 13
				z = -5
			elseif string.match(AIRCRAFT_PATH,"146")  then -- away
				x = 13
				z = -1
			end
			draw_static_object(x,z,-5,Cones_instance[1],"Cones") -- Left Wing cone
			latcone = x -- export for passenger path
			loncone = z -- export for passenger path

			-- X is controlling left / right axis
			-- Z is controllong forward / aft axis
			--~ -- Right Wingtip cone (added 15-07-2023)
			--~ draw_static_object(-x-0.5,z-0.8,-10,Cones_instance[3],"Cones") -- Right Wingtip cone (added 15-07-2023)

			--~ if math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5  then
				--~ draw_static_object(-x-0.5,z-0.8,-10,Cones_instance[4],"Cones") -- Right Wingtip cone 3 (added 15-07-2023)
				--~ -- draw only one cone for small airplanes bu superposition
			--~ else
				--~ draw_static_object(-x-0.8,z+0.8,15,Cones_instance[4],"Cones") -- Right Wingtip cone 3 (added 15-07-2023)
			--~ end

			-- Right Wingtip cone (added 15-07-2023, mod 02-03-2024, for a fire extinguisher in XP12)
			draw_static_object(-x-0.5,z-0.8,-10,Cones_instance[3],"Cones") -- Right Wingtip cone (added 15-07-2023)

			if (math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5) and not IsXPlane12 then
				--draw_static_object(-x-0.5,z-0.8,-10,Cones_instance[4],"Cones") -- Right Wingtip cone 3 (added 15-07-2023)
				-- draw only one cone for small airplanes by superposition in XP11
			elseif (math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5) and IsXPlane12 and military ~= 1 and military_default ~= 1 then
				--~ -- change for fire extinguisher in XP12 for small airplanes
				draw_static_object(-x-0.35,z+0.5,85,Cones_instance[4],"Extinguisher")
				--~ print("exting")
			elseif (math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5) and IsXPlane12 and (military == 1 or military_default == 1) then
				--draw_static_object(-x-0.5,z-0.8,-10,Cones_instance[4],"Cones")
				-- Here draw only one cone for small airplanes by superposition in XP12
			else
				draw_static_object(-x-0.8,z+0.8,15,Cones_instance[4],"Cones") -- Right Wingtip cone 3 (added 15-07-2023)
			end
		  end
	  end
	end



	function service_object_physics_GPU()

	  if GPU_chg == true then
		  if show_GPU then
			  load_GPU()
		  else
			  GPU_chg,GPU_instance[0],rampserviceref1 = common_unload("GPU",GPU_instance[0],rampserviceref1)
			  --unload_GPU()
		  end
		  if GPU_instance[0] ~= nil then
			local x = -5
			local z = BeltLoaderFwdPosition + 10
			if (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) then
				GPU_chg = false
			else
				-- send it :
				GPU_chg = draw_static_object(x,z,-55,GPU_instance[0],"GPU")
			end
		  end
	  end
	end

	function service_object_physics_Fuel()

	  if FUEL_chg == true then
		  if active_fueling_is_possible then active_fueling_is_possible = false end  			-- in every case as soon as the fuel is touched, active fueling will be stoped.
		  if show_FUEL then
			  load_FUEL()
			  hide_temporarily_cart = false
				if (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) and Prefilled_FuelObject == XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" and Linked_cones ~= Prefilled_ConeObject then
					-- definitively change linked cones for a single cone to not disturb the ULD loader on main cargo deck
					Cones_chg,Cones_instance[1],rampserviceref3 = common_unload("BAe146QTCones",Cones_instance[1],rampserviceref3)
					Linked_cones = Prefilled_ConeObject
					Cones_chg =  true
				elseif (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) and Prefilled_FuelObject ~= XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" and Linked_cones == Prefilled_ConeObject and not show_CargoULD then
					-- restore true linked cones with strip for next manual round of laying cones.
					Linked_cones = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/Ground_carts/XPJ_conus.obj"
					-- only manual is important, or we have to test the ground denivelation
				end
		  elseif FUEL_instance[0] ~= nil and FuelFinalY ~= nil and FuelFinalX ~= nil then
			if Fuel_heading_correcting_factor == nil then Fuel_heading_correcting_factor = -27 end

			if Prefilled_FuelObject == XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" then
				-- Watch your steps in load_FUEL() !
				FUEL_chg,FUEL_instance[0],rampserviceref2,FuelFinalX,FuelFinalY = Common_draw_departing_vehicles(FuelFinalX,FuelFinalY,FUEL_instance[0],"Hydrant",rampserviceref2,Fuel_heading_correcting_factor)

				if show_Cart and Fuel_heading_correcting_factor > 8 and hide_temporarily_cart == false then -- if on the starboard side :
					print("[Ground Equipment " .. version_text_SGES .. "]  Hydrant dispenser : \"move the baggage cart out of the way please !\"")
					-- need to remove temporarily the bagage cart :
					show_Cart = false
					Cart_chg = true
					hide_temporarily_cart = true
				elseif show_Bus and Fuel_heading_correcting_factor < -8 and hide_temporarily_cart == false then -- if on the port side :
					print("[Ground Equipment " .. version_text_SGES .. "]  Hydrant dispenser : \"move the port side vehicles out of the way please !\"")
					-- need to remove temporarily the bus :
					show_Bus = false
					Bus_chg = true
					show_Pax = false
					Pax_chg = true
					hide_temporarily_cart = true
					walking_direction_changed_armed = false -- VERY important FALSE
				end

			else
				FUEL_chg,FUEL_instance[0],rampserviceref2,FuelFinalX,FuelFinalY = Common_draw_departing_vehicles(FuelFinalX,FuelFinalY,FUEL_instance[0],"FUEL",rampserviceref2,Fuel_heading_correcting_factor)
			end

			-- reset
			fuel_currentX = nil
			fuel_currentY = nil
		  else
			FUEL_chg,FUEL_instance[0],rampserviceref2 = common_unload("FUEL",FUEL_instance[0],rampserviceref2)
			fuel_currentX = nil
			fuel_currentY = nil
		  end
		  if FUEL_instance[0] ~= nil and show_FUEL  then
			  draw_FUEL()
		  end
	  end

	end
	function service_object_physics_Cleaning()
	  if Cleaning_chg == true then
		  if show_Cleaning then
			  load_Cleaning()
		  --~ elseif Cleaning_instance[0] ~= nil and CleaningFinalX ~= nil then
			    --~ Cleaning_chg,Cleaning_instance[0],rampserviceref4,CleaningFinalX,CleaningFinalX = Common_draw_departing_vehicles(CleaningFinalX,CleaningFinalX,Cleaning_instance[0],"Cleaning",rampserviceref4,10)
				--~ -- reset
				--~ CleaningFinalX = nil
				--~ CleaningFinalX = nil
		  else
			 Cleaning_chg,Cleaning_instance[0],rampserviceref4 = common_unload("Cleaning",Cleaning_instance[0],rampserviceref4)
			 _,Cleaning_instance[1],rampserviceref4L = common_unload("CleaningLight",Cleaning_instance[1],rampserviceref4L)
			 --unload_Cleaning()
		  end
		  if Cleaning_instance[0] ~= nil and show_Cleaning then
			local x = 8
			local z = -2.35*math.abs(BeltLoaderFwdPosition)
			if show_FireVehicleAhead == false then -- normal use of the truck on parking stand
				objpos_value[0].roll = 0
				objpos_value[0].pitch = 0
				if SecondStairsFwdPosition ~= - 30 and SecondStairsFwdPosition < -12 then -- if SecondStairsFwdPosition is defined in the aircraft config
					z = SecondStairsFwdPosition - 9
				end
				-- then peculiarities :
				if PLANE_ICAO == "QX" or PLANE_ICAO == "AMF" then
					x = -4.5*math.abs(BeltLoaderFwdPosition)
				elseif PLANE_ICAO == "A346" then
					x = 10
					z = -0.5*math.abs(BeltLoaderFwdPosition)
				end
				-- with an X-Plane 12.1.4 vehicle, I need to back it a little bit
				if string.find(Prefilled_CleaningTruckObject,"airsideops")	then
					z = z - 5
				end

			else -- use the object as if on the crash site, usefull for me as a simmer helicopter flyer
				x = -1
				z = DistanceToCrashSite+20
				objpos_value[0].roll = 20
				objpos_value[0].pitch = -5
			end
			-- send it :
			Cleaning_chg = draw_static_object(x,z,15,Cleaning_instance[0],"Cleaning")
			if Cleaning_instance[1] ~= nil then _ = draw_static_object(x,z,15,Cleaning_instance[1],"CleaningLight") end
		  end
	  end

	end
	function service_object_physics_Beltloader()
	  if BeltLoader_chg == true then
			if show_BeltLoader then
				load_BeltLoader()
			else
				show_Baggage = false
				Baggage_chg = true
				BeltLoader_chg,BeltLoader_instance[0],rampserviceref5 =  common_unload("BeltLoader",BeltLoader_instance[0],rampserviceref5)
			end

			if BeltLoader_instance[0] ~= nil then
				--draw_BeltLoader()
				local x = -1.3*(targetDoorX + 6.6)
				local z = BeltLoaderFwdPosition
				local h = -90


				-- special handling
				if PLANE_ICAO == "A306" then 		x = -1.3*(targetDoorX + 6.6)	z = BeltLoaderFwdPosition
				elseif PLANE_ICAO == "A310" then	x = -1.9*(targetDoorX + 6.6)	z = -0.55*BeltLoaderFwdPosition end
				if BeltLoaderFwdPosition >= ULDthresholdx and UseXplaneDefaultObject == true then
					x= -1.9*(targetDoorX + 8.6)
					z = BeltLoaderFwdPosition
					-- modifiers
					if targetDoorX == 0 then x = x + 3 - 1.5 * targetDoorX_alternate end-- alternate should stay zero unless modified in GUI on the go
				elseif BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
					x = -1.9*(targetDoorX + 6.6)
					z = BeltLoaderFwdPosition
					-- modifiers
					if targetDoorX == 0 then x = x + 3 - 1.5 * targetDoorX_alternate end-- alternate should stay zero unless modified in GUI on the go
				end

				-- regional turboprops
				if PLANE_ICAO == "SF34" or string.match(PLANE_ICAO,"CRJ") or ((string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko")) then
					ULDLoaderFwdPositionFactor = -1.12
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+6	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.8	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif string.match(PLANE_ICAO,"DH8A") or PLANE_ICAO == "DH8D" or PLANE_ICAO == "DH8C" then
					ULDLoaderFwdPositionFactor = -1.4
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+5.2	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.5	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif string.match(PLANE_ICAO,"AT4") then
					-- ATR 42 and ATR 72
					ULDLoaderFwdPositionFactor = 2.6 -- positivive !
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+5.2	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.5	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then
					-- ATR 42 and ATR 72
					ULDLoaderFwdPositionFactor = 2.9 -- positivive !
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+5.2	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.5	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif PLANE_ICAO == "QX" or PLANE_ICAO == "AMF" then
					ULDLoaderFwdPositionFactor = -1.6
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+4.6	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif PLANE_ICAO == "ASB" then -- Breguet deux pont Provence
					ULDLoaderFwdPositionFactor = -1.1
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+5.2	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.5	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif string.match(PLANE_ICAO,"GLF") then
					ULDLoaderFwdPositionFactor = -1.4
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+5.2	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.5	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				elseif plane_has_cargo_hold_on_the_left_hand_side then
					ULDLoaderFwdPositionFactor = -1.12
					h = 90
					if UseXplaneDefaultObject == true then
						x = targetDoorX+6	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					else
						x = targetDoorX+6.8	z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
					end
				end

				-- if special distance to the fuselage was required :
				if distance_to_fuselage ~= 0 then x = x + distance_to_fuselage end


			   if PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" and military_default == 1 then
					-- This 747 is for the White House (E4B modification)
					x = x + 1.4
			   end



				-- modifier apply after new cargo loader in X-Plane 12.1 :
				if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then
					x = x - 3.5
					-- The engine is obstructing for the A319 case when containerized cargo is in used
					if PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" then
						z = BeltLoaderFwdPosition + 0.45
						show_PRM = false -- there is no room for the PRM truck in this case
						PRM_chg = true
					end
					Cones_chg,Cones_instance[0],rampserviceref0 = common_unload("Cones",Cones_instance[0],rampserviceref0)
					print("[Ground Equipment " .. version_text_SGES .. "] Loading the X-Plane 12.1 ULD loader object into position with geometry modifier (FWD).")
				end

				-- send it :
				if BeltLoaderFwdPosition > 2 then
					BeltLoader_chg 		= draw_static_object(x,z,h,BeltLoader_instance[0],"BeltLoader")
					FrontLoader_x = x
					FrontLoader_z = z
					-- Now for the A319 case when containerized cargo is in use, set the ULD location on the ULD loader :
					if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and (PLANE_ICAO == "A319" or PLANE_ICAO == "A19N") then z = BeltLoaderFwdPosition - 0.50 end
					if x < 0 then -- cargo hold on the right hand side
						if walking_direction == "boarding" then
							baggage_x = x - 4.2
							baggage_x_stored = baggage_x
							baggage_z = z + 0.2
							baggage_z_stored = baggage_z
							baggage_vert = 0.9
							if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then baggage_vert = 0.37 end -- when those are LD3 and not baggages, the path is different

							-- modifier applies after new cargo loader in X-Plane 12.1 :
							if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
								baggage_x = baggage_x_stored + 3.5
								baggage_x_stored = baggage_x
								baggage_vert = 0.52 -- moving_deck_altitude
							end

							baggage_vert_stored = baggage_vert
						else
							baggage_x = x + 4.2 --
							baggage_x_stored = baggage_x --
							baggage_z = z + 0.2 --
							baggage_z_stored = baggage_z --
							baggage_vert = 1.30 --
							if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then baggage_vert = 1.74 end -- when those are LD3 and not baggages, the path is different

							--~ -- modifier applies after new cargo loader in X-Plane 12.1 :
							if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
								baggage_x = baggage_x_stored + 3.5
								baggage_x_stored = baggage_x
								baggage_vert = 1.79
							end

							baggage_vert_stored = baggage_vert --
						end
					else -- cargo hold on the left hand side
						if walking_direction == "boarding" then
							baggage_x = x + 4.2
							baggage_x_stored = baggage_x
							baggage_z = z - 0.2
							baggage_z_stored = baggage_z
							baggage_vert = 0.8
							baggage_vert_stored = baggage_vert
						else
							baggage_x = x - 4.2 --
							baggage_x_stored = baggage_x --
							baggage_z = z - 0.2 --
							baggage_z_stored = baggage_z --
							baggage_vert = 1.20 --
							baggage_vert_stored = baggage_vert --
						end
					end
				end
			end
	  end
	end

	function service_object_physics_RearBeltloader()
	  if RearBeltLoader_chg == true then
		  if show_RearBeltLoader then
			if PLANE_ICAO ~= "SF34" and not string.match(PLANE_ICAO,"CRJ") and not string.match(PLANE_ICAO,"DH8A")  and PLANE_ICAO ~= "DH8D" and PLANE_ICAO ~= "DH8C" and PLANE_ICAO ~= "QX" and  PLANE_ICAO ~= "AMF"  and  PLANE_ICAO ~= "GLF650ER" and not plane_has_cargo_hold_on_the_left_hand_side then
				load_RearBeltLoader()
			else
				show_RearBeltLoader = false -- for airplanes with special handlling (loader on the left side)
			end
		  else
			 RearBeltLoader_chg,BeltLoader_instance[2],rampservicerefRBL =  common_unload("RearBeltLoader",BeltLoader_instance[2],rampservicerefRBL)
		  end
			if BeltLoader_instance[2] ~= nil then
				local x = -1.4*(targetDoorX + 8.6)
				local z = -0.9*BeltLoaderFwdPosition
				local h = -77



				if BeltLoaderFwdPosition >= ULDthresholdx  then
					z = -0.65*BeltLoaderFwdPosition
					h = -82
				end
				-- following massive user request, that was added december 2023 :
				-- allowing definition in the aircraft profile of the rear belt loader position
				if BeltLoaderRearPosition ~= nil then
					x = -1.3*(targetDoorX + 6.6)
					if BeltLoaderFwdPosition >= ULDthresholdx then x = -1.9*(targetDoorX + 7) end
					z = BeltLoaderRearPosition
					h = -88
				end


				-- if special distance to the fuselage was required :
				if distance_to_fuselage ~= 0 and BeltLoaderRearPosition == nil  then
					x = x + (0.4 * distance_to_fuselage)
					h = h - (5 * distance_to_fuselage)
				elseif distance_to_fuselage ~= 0 then
					x = x + distance_to_fuselage
					h = h - (2 * distance_to_fuselage)
					if h < -90 then h = -90 end
				end -- mod 12/2023

				-- modifier apply after new cargo loader in X-Plane 12.1 :
				if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
					x = x - 3.5
					print("[Ground Equipment " .. version_text_SGES .. "] Loading the X-Plane 12.1 ULD loader object into position with geometry modifier (REAR).")
				end

				if BeltLoaderFwdPosition > 6 then
					RearBeltLoader_chg 	= draw_static_object(x,z,h,BeltLoader_instance[2],"RearBeltLoader")
					if x < 0 then
						baggage_x2 = x - 6
						-- modifier apply after new cargo loader in X-Plane 12.1 :
						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
							baggage_x2 = x - 2
						end
					else
						baggage_x2 = x + 6
						-- modifier apply after new cargo loader in X-Plane 12.1 :
						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
							baggage_x2 = x + 2
						end
					end
					baggage_z2 = z
				end
			end
	  end
	end

	function service_object_physics_XPlane_stairs()
	  if Stairs_chg == true then
		  if show_Stairs then
			  load_Stairs()
		  else
			Stairs_chg,Stairs_instance[0],rampserviceref6 = common_unload("Stairs",Stairs_instance[0],rampserviceref6)
			--unload_Stairs()
		  end
		  if Stairs_instance[0] ~= nil then
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
			-- if UseXplaneDefaultObject then DeltaX = 3 else DeltaX = 6.5 end
			local DeltaX = 9 -- tempo, made the object away, interest is ambiance
			if BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then DeltaX = 10 end
			local x = targetDoorX + DeltaX
			local z = -1 * targetDoorZ
			local h = 90 + 180
			if UseXplaneDefaultObject then h = 90+180	end
			-- specific airplane adaptations for Mark I stairs : ------------ --
			if PLANE_ICAO == "C47" or PLANE_ICAO == "DC3" then
				x = targetDoorX + 3.5
				z = targetDoorZ + 0.5
				--
				x = targetDoorX + 0.6
				z = targetDoorZ + 2.3
				h = 90 + 201
			end
			-- -------------------------------------------------------------- --
			Stairs_chg = draw_static_object(x+ targetDoorX_alternate, z+ targetDoorZ_alternate, h+ targetDoorH_alternate,Stairs_instance[0],"Stairs")
		  end
	  end
	end


	function service_object_physics_Bus()
	  if Bus_chg == true then
		  if stairs_authorized and not option_StairsXPJ_override and sges_openSAM ~= nil and sges_openSAM[0] == 2 then show_Bus = false end -- patch to prevent bus with an Open SAM jetway when stairs are authorized

		  if show_Bus and (stairs_authorized or option_StairsXPJ_override) then
			load_Bus()

			--print("[Ground Equipment " .. version_text_SGES .. "]  load_Bus")
		  elseif Bus_instance[0] ~= nil and BusFinalX ~= nil and BusFinalY ~= nil then

			if boarding_from_the_terminal then
				if Bus_instance [1] ~= nil then _,Bus_instance[1],rampserviceref7L = common_unload("BusLight",Bus_instance[1],rampserviceref7L) end -- there is no real bus here, so remove the aiming cue immediately
				Bus_chg,Bus_instance[0],rampserviceref7 = common_unload("Bus",Bus_instance[0],rampserviceref7) -- there is no real bus here, so remove the aiming cue immediately
				print("REMOVING TERMINAL DESTINATION")
				boarding_from_the_terminal = false
				if SGES_mirror then BusFinalX = -1 * BusFinalX end
			else
				if Bus_instance [1] ~= nil then _,Bus_instance[1],rampserviceref7L,_,_ = Common_draw_departing_vehicles(BusFinalX,BusFinalY,Bus_instance[1],"BusLight",rampserviceref7L,15) end -- flag bus to allow the lights to turn with the 3D model
				Bus_chg,Bus_instance[0],rampserviceref7,BusFinalX,BusFinalY = Common_draw_departing_vehicles(BusFinalX,BusFinalY,Bus_instance[0],"Bus",rampserviceref7,15)
			end
			-- reset
			currentX = nil
			currentY = nil
		  else
			Bus_chg,Bus_instance[0],rampserviceref7 = common_unload("Bus",Bus_instance[0],rampserviceref7)
			_,Bus_instance[1],rampserviceref7L = common_unload("BusLight",Bus_instance[1],rampserviceref7L)
			-- reset
			currentX = nil
			currentY = nil
		  end
		  if show_Bus and Bus_instance[0] ~= nil then
			  draw_Bus()
		  end
	  end

	end

	function service_object_physics_Catering()
	  if Catering_chg == true then
		  if show_Catering then
			if show_Chocks and PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104 chocks
				set("Colimata/F104_A_SW_DOORS_gun_front_i",1)
				set("Colimata/F104_A_SW_DOORS_avionics_i",1)
				set("Colimata/F104_A_SW_DOORS_electrics_i",1)
				set("Colimata/F104_A_SW_GROUND_pins_i",1)
			end
			if Catering_instance[0] == nil and PLANE_ICAO == "DH8D" and AIRCRAFT_FILENAME == "Q4XP.acf" then				command_once("FJS/Q4XP/Animation/Toggle_Rear_Right_Cabin_Door")				end
			load_Catering()
		  else

			if Catering_instance[0] ~= nil and PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104 chocks
				set("Colimata/F104_A_SW_DOORS_gun_front_i",0)
				set("Colimata/F104_A_SW_DOORS_gun_rear_i",0)
				set("Colimata/F104_A_SW_DOORS_avionics_i",0)
				set("Colimata/F104_A_SW_DOORS_electrics_i",0)
			end
			if Catering_instance[0] ~= nil and PLANE_ICAO == "DH8D" and AIRCRAFT_FILENAME == "Q4XP.acf" then				command_once("FJS/Q4XP/Animation/Toggle_Rear_Right_Cabin_Door")				end

			Catering_chg,Catering_instance[0],rampserviceref8 = common_unload("Catering",Catering_instance[0],rampserviceref8)
			Catering_chg,Catering_instance[1],rampserviceref8h = common_unload("CateringHighPart",Catering_instance[1],rampserviceref8h)
			--unload_Catering()
			CatObject = nil
			if CateringHighPart_is_night_lighting ~= nil then CateringHighPart_is_night_lighting = nil end
		  end
		  if Catering_instance[0] ~= nil then
			local x = -targetDoorX-deltaDoorX-1
			local z = -1.35*math.abs(BeltLoaderFwdPosition)

			if SecondStairsFwdPosition ~= - 30 and SecondStairsFwdPosition < -6 then -- if SecondStairsFwdPosition is defined in the aircraft config
				z = SecondStairsFwdPosition
			end

			if SGES_Embraer_catering_is_small == nil then SGES_Embraer_catering_is_small = true end
			if PLANE_ICAO == "A306" then
				z = -1.25*math.abs(BeltLoaderFwdPosition)
			elseif string.match(AIRCRAFT_PATH,"146") then
				z = -1.70*math.abs(BeltLoaderFwdPosition)
			elseif PLANE_ICAO == "SF34" or PLANE_ICAO == "QX" or PLANE_ICAO == "AMF" then
				z = -2*math.abs(BeltLoaderFwdPosition)
			elseif PLANE_ICAO == "B742" then
				z = -23.5
			elseif PLANE_ICAO == "A346" then
				z = -0.85*math.abs(BeltLoaderFwdPosition)
			elseif PLANE_ICAO == "MD11" and IsPassengerPlane == 0 then
				z = -1.20*math.abs(BeltLoaderFwdPosition)
			elseif string.match(PLANE_ICAO,"CRJ") then
				x = -targetDoorX-8
				z = 2*math.abs(BeltLoaderFwdPosition)
			elseif (string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko") then
				x = -targetDoorX-8
				z = 2*math.abs(BeltLoaderFwdPosition)
			elseif PLANE_ICAO == "MD88" then
				x = 2
				z = - (BeltLoaderFwdPosition + 5.5)
			elseif PLANE_ICAO == "E170" and SGES_Embraer_catering_is_small then
				x = 9
				z = BeltLoaderFwdPosition - 1
			elseif PLANE_ICAO == "E175" and SGES_Embraer_catering_is_small then
				x = 10
				z = BeltLoaderFwdPosition - 1
			elseif PLANE_ICAO == "E19L" and SGES_Embraer_catering_is_small then
				x = 7
				z = BeltLoaderFwdPosition - 2
			elseif PLANE_ICAO == "MD82" or PLANE_ICAO == "MD90" then
				x = -targetDoorX-9
				z = BeltLoaderFwdPosition + 5.5
			elseif PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then
				x = -targetDoorX - 7
				z = 1.40*math.abs(BeltLoaderFwdPosition)
			end
			local object_hdg_correction= - 85
			if SGES_Embraer_catering_is_small and (string.match(PLANE_ICAO,"B46") or PLANE_ICAO == "RJ70" or PLANE_ICAO == "RJ85" or PLANE_ICAO == "RJ1H" or string.match(PLANE_ICAO,"DH8A") or PLANE_ICAO == "DH8C" or PLANE_ICAO == "DH8D" or string.match(PLANE_ICAO,"AT4") or string.match(PLANE_ICAO,"GLF650ER") or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)")) then
				object_hdg_correction = 150 -- make room for the baggage cart
				z = -2.25*math.abs(BeltLoaderFwdPosition)
			end
			-- At the White House
			if CatObject == SAM_object_3 or CatObject == SAM_object_1 or CatObject == SAM_object_2 then
				x = 7*x
				object_hdg_correction = 150
			end

			if CatObject == Dayonly_truck_flatbed_01 then
				object_hdg_correction = 90
			end

			-- When this is an X-Plane 12.1.4 object, allow more room toward the fuselage
			if string.find(CatObject,"Common_Elements/Vehicles") then
				x = 1.25 * x
			end

			draw_static_object(x,z,object_hdg_correction,Catering_instance[0],"Catering")
			--"CateringHighPart" is only a good keyword here for the elevated vehicles, otherwise trouble trouble :
			if CateringHighPart_is_night_lighting ~= nil and CateringHighPart_is_night_lighting then
				Catering_chg = draw_static_object(x,z,object_hdg_correction,Catering_instance[1],"CateringLight") -- when it's the night lighting of X-Plane 12.1.4 van
			else
				Catering_chg = draw_static_object(x,z,object_hdg_correction,Catering_instance[1],"CateringHighPart") -- otherwise use CateringHighPart to affect the elevation
			end
		  end
	  end

	end

	function service_object_physics_PRM()
	  if PRM_chg == true then
		  if show_PRM then
			  load_PRM()
			  -- make more space :
			  show_Cart = false
			  Cart_chg = true -- reset the baggage cart to the new positions
		  else
			PRM_chg,PRM_instance[0],rampservicerefPRM = common_unload("PRM",PRM_instance[0],rampservicerefPRM)
			PRM_chg,PRM_instance[1],rampservicerefPRM2 = common_unload("PRMHighPart",PRM_instance[1],rampservicerefPRM2)
			--unload_PRM()
			if ServiceDoor1R ~= nil and ServiceDoor1R == target_to_open_the_door then
				ServiceDoor1R = target_to_open_the_door-1
			end
			if PRMHighPart_is_night_lighting ~= nil then PRMHighPart_is_night_lighting = nil end
		  end
		  if PRM_instance[0] ~= nil then
			local x = -targetDoorX-deltaDoorX-1.3-targetDoorX_alternate
			local z = -targetDoorZ+targetDoorZ_alternate
			local PRM_heading = -94



			if string.match(PLANE_ICAO,"B46") or PLANE_ICAO == "RJ70" or PLANE_ICAO == "RJ85" or PLANE_ICAO == "RJ1H" then
				object_hdg_correction = 150 -- make room for the baggage cart
				x = -targetDoorX-deltaDoorX-2+targetDoorX_alternate
			end

			-- when we use the X-Plane 12 ambulance_us object, we need to back it a little bit
			if (string.find(Prefilled_CateringObject,"ambulance_us") or string.find(Prefilled_CateringObject,"ambulance_eu"))
			or (PRMHighPart_is_night_lighting ~= nil and PRMHighPart_is_night_lighting)
			then
				z = z + 16 + math.abs(BeltLoaderFwdPosition)
				x = 0
				PRM_heading = 120
				if SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1 and get_hospital_ambulance then
					z = targetDoorZ
					x = -10
					PRM_heading = 87
				end
			end

			if (PLANE_ICAO == "A319" or PLANE_ICAO == "A19N") and Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and show_BeltLoader then
				x = x - 15
				z = z + 5
				PRM_heading = -74
			end

			-- alternate variables should stay zero if untouched in the GUI
			draw_static_object(x,z,PRM_heading,PRM_instance[0],"PRM")
			PRM_chg = draw_static_object(x,z,PRM_heading,PRM_instance[1],"CateringHighPart") -- flag is important
			--"CateringHighPart" is only a good keyword here for the elevated vehicles, otherwise trouble trouble :
			if (string.find(Prefilled_CateringObject,"ambulance_us") or string.find(Prefilled_CateringObject,"ambulance_eu")) or (PRMHighPart_is_night_lighting ~= nil and PRMHighPart_is_night_lighting) then
				PRM_chg = draw_static_object(x,z,PRM_heading,PRM_instance[1],"PRMLight") -- when it's the night lighting of X-Plane 12.1.4 van
			else
				PRM_chg = draw_static_object(x,z,PRM_heading,PRM_instance[1],"CateringHighPart") -- otherwise use CateringHighPart to affect the elevation
			end


			if index_to_open_the_door ~= nil then
				local index_to_open_the_service_door = index_to_open_the_door + 1
				if string.match(AIRCRAFT_PATH,"146") then index_to_open_the_service_door = index_to_open_the_door + 2 end
				if dataref_to_open_the_door ~= nil and index_to_open_the_service_door ~= nil then
					if dataref_to_open_the_door == "laminar/B738/door/fwd_L_toggle" and string.match(PLANE_ICAO,"B73") then			-- ZIBO / LevelUp
						command_once("laminar/B738/door/fwd_R_toggle")
					elseif PLANE_ICAO ~= "MD88" and PLANE_ICAO ~= "MD11" then -- those ones have commands, not datarefs
						if ServiceDoor1R == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil then
							dataref("ServiceDoor1R",dataref_to_open_the_door,"writable",index_to_open_the_service_door)
						end
						if show_PRM and ServiceDoor1R ~= nil and ServiceDoor1R < target_to_open_the_door then
							ServiceDoor1R = target_to_open_the_door
							print("[Ground Equipment " .. version_text_SGES .. "] open the service door with " .. dataref_to_open_the_door .. ":" .. index_to_open_the_service_door)
						end
					end
				--~ elseif dataref_table_to_open_the_door ~= nil then -- second case when the dataref is a table !
					--~ if ServiceDoor1R == nil and XPLMFindDataRef(dataref_table_to_open_the_door_table) ~= nil then
						--~ ServiceDoors = dataref_table(dataref_table_to_open_the_door_table,"writable")
						--~ ServiceDoor1R = ServiceDoors[index_to_open_the_service_door]
						--~ print("[Ground Equipment " .. version_text_SGES .. "] open the door with dataref table " .. dataref_table_to_open_the_door_table .. ":" .. index_to_open_the_door)
					--~ end
					--~ if show_PRM and ServiceDoor1R ~= nil and ServiceDoor1R < target_to_open_the_door then
						--~ ServiceDoor1R = target_to_open_the_door
						--~ print("[Ground Equipment " .. version_text_SGES .. "] open the door with dataref table " .. dataref_table_to_open_the_door_table .. ":" .. index_to_open_the_door+1)
					--~ end
				end
			end


		  end
	  end

	end

	function service_object_physics_Follow_me()
		if math.abs(sges_gs_gnd_spd[0]) > 0.08 and show_FM and approaching_TargetMarker <= 2 then
			FM_chg = true               -- dynamic vehicle
		end
	  if FM_chg == true then
		  if show_FM then
			  load_FM()
		  else
			FM_chg,FM_instance[0],rampserviceref53 = common_unload("FM",FM_instance[0],rampserviceref53)
			--unload_FM()
			parameter_TM = nil
		  end
		  if FM_instance[0] ~= nil then
			  draw_FM()
			if approaching_TargetMarker > 2 then FM_chg = false parameter_TM = nil end  -- locking position of car

			--auto hide when in runway configuration :
			if show_FM and sges_strobe_lights_on ~= nil and sges_landing_lights_on ~= nil and sges_strobe_lights_on[0] == 1 and sges_landing_lights_on[0] == 1 and sges_gs_gnd_spd[0] > 1 then
				show_FM = false
				FM_chg = true
				print("[Ground Equipment " .. version_text_SGES .. "] Approaching the runway perhaps ? Auto-hide the follow-me with landing lights and strobe both ON.")
			end
		  end
	  end

	end


	function service_object_physics_EMS()
		if math.abs(sges_gs_gnd_spd[0]) > 0.2 and show_FireVehicleAhead == false and show_Watersalute == false and show_FireVehicle and show_Pelicandrome == false then
			FireVehicle_chg = true               -- dynamic vehicle
		end
		if FireVehicle_chg == true then
			if show_FireVehicle then
				if not show_Pelicandrome and FireVehicle_instance[3] ~= nil then
					_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
				end
				load_FireVehicle()
			else
				_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
				_,FireVehicle_instance[2],rampserviceref71b = common_unload("FireVehicle",FireVehicle_instance[2],rampserviceref71b)
				_,FireVehicle_instance[1],rampserviceref71L = common_unload("FireVehicle",FireVehicle_instance[1],rampserviceref71L)
				FireVehicle_chg,FireVehicle_instance[0],rampserviceref71 = common_unload("FireVehicle",FireVehicle_instance[0],rampserviceref71)
				--unload_FireVehicle()
			end
			if FireVehicle_instance[0] ~= nil then
				draw_FireVehicle()
				if math.abs(sges_gs_gnd_spd[0]) <= 0.2 or show_Watersalute or show_FireVehicleAhead or show_Pelicandrome then
					FireVehicle_chg = false               -- stop drawing dynamic vehicle
				end
			end
		end

	end

	function service_object_physics_ArrestorSystem()

	  if ArrestorSystem_chg == true then
		  if show_ArrestorSystem then
			  load_ArrestorSystem()
		  else
			ArrestorSystem_chg,ArrestorSystem_instance[0],rampservicerefAS = common_unload("ArrestorSystem",ArrestorSystem_instance[0],rampservicerefAS)
			--unload_ArrestorSystem()
		  end
		  if ArrestorSystem_instance[0] ~= nil then
			draw_ArrestorSystem()
			--ArrestorSystem_chg = false               -- stop drawing dynamic vehicle
		  end
	   end

	end



	function service_object_physics_WildFire()
		if FireSmoke_chg == true then
			if show_FireSmoke then
				load_FireSmoke()
				if sges_fire_retardant_m == nil then dataref("sges_fire_retardant_m","sim/flightmodel/weight/m_jettison",readonly) end
			else
				FireSmoke_chg,FireSmoke_instance[0],rampserviceref710 = common_unload("FireSmoke",FireSmoke_instance[0],rampserviceref710)
				sges_fire_retardant_m = nil
				sges_fire_retardant_m_stored = nil
				--unload_FireSmoke()
			end
			if FireSmoke_instance[0] ~= nil then
				if show_Ship2 then
					FireSmoke_chg = draw_static_object(-100, DistanceToCrashSite+20,7,FireSmoke_instance[0],"FireSmoke")
				else
					FireSmoke_chg = draw_static_object(0, DistanceToCrashSite+20,2,FireSmoke_instance[0],"FireSmoke")
				end
			end
		end
		if show_FireSmoke and sges_fire_retardant_m ~= nil and sges_fire_retardant_m > 0 and sges_gs_plane_y_agl[0] > 10 and sges_gs_plane_y_agl[0] <= 200 then
			if sges_fire_retardant_m_stored == nil then sges_fire_retardant_m_stored = sges_fire_retardant_m end
			if sges_fire_retardant_m < sges_fire_retardant_m_stored then
				print("[Ground Equipment " .. version_text_SGES .. "] Monitoring fire retardant jettison... " .. sges_fire_retardant_m)
				service_Waterbomber_drop(40)
			end
		end
	end

	function service_Waterbomber_drop(sges_circular_error)
		-- If the payload is jettison on trop of the wildfire coordinates, then remove the fire
		-- we dont have the water coordinates as a weapon. So we will just analyses a decreasing fire retardant quantity
		if wildfire_x ~= nil and wildfire_z ~= nil and sges_fire_retardant_m ~= nil
		and	sges_gs_plane_x[0] < wildfire_x + sges_circular_error
		and	sges_gs_plane_x[0] > wildfire_x - sges_circular_error
		and	sges_gs_plane_z[0] < wildfire_z + sges_circular_error
		and	sges_gs_plane_z[0] > wildfire_z - sges_circular_error
		--~ and sges_fire_retardant_m < sges_fire_retardant_m_stored
		then
			print("[Ground Equipment " .. version_text_SGES .. "] Extinguising the fire...")
			show_FireSmoke = false
			FireSmoke_chg = true
			sges_fire_retardant_m_stored = nil
		end
	end

	function service_object_physics_ULDloader()
	  if ULDLoader_chg == true then
		  if show_ULDLoader then
			  load_ULDLoader()
		  else
			show_CargoULD = false
			CargoULD_chg = true
			-- apply this directly :
			CargoULD_chg,Baggage_instance[5],rampservicerefBaggage5 = common_unload("CargoULD",Baggage_instance[5],rampservicerefBaggage5)

			-- then
			ULDLoader_chg,ULDLoader_instance[0],rampserviceref72 = common_unload("ULDLoader",ULDLoader_instance[0],rampserviceref72)

			--unload_ULDLoader()
		  end


		  if ULDLoader_instance[0] ~= nil then
			if PLANE_ICAO == "A321" then ULDLoaderFwdPositionFactor = 0.72
			elseif PLANE_ICAO == "A320" then ULDLoaderFwdPositionFactor = 1.0
			elseif PLANE_ICAO == "A20N" then ULDLoaderFwdPositionFactor = 1.0
			elseif PLANE_ICAO == "A346" then ULDLoaderFwdPositionFactor = 0.5
			elseif PLANE_ICAO == "A306" then ULDLoaderFwdPositionFactor = 0.96
			elseif PLANE_ICAO == "MD11" then ULDLoaderFwdPositionFactor = 1.45
			elseif PLANE_ICAO == "B722" then ULDLoaderFwdPositionFactor = 1.13
			elseif PLANE_ICAO == "B738" then ULDLoaderFwdPositionFactor = 0.95
			elseif PLANE_ICAO == "B748" then ULDLoaderFwdPositionFactor = -0.53
			elseif PLANE_ICAO == "B742" then ULDLoaderFwdPositionFactor = -0.67 lateral_factor_ULDLoader = -1.2
			elseif PLANE_ICAO == "B744" then ULDLoaderFwdPositionFactor = -0.7
			elseif PLANE_ICAO == "B763" then ULDLoaderFwdPositionFactor = 0.9
			elseif PLANE_ICAO == "B772" then ULDLoaderFwdPositionFactor = 1
			elseif PLANE_ICAO == "B752" then ULDLoaderFwdPositionFactor = 1.15
			elseif PLANE_ICAO == "SF34" then ULDLoaderFwdPositionFactor = -1.1
			elseif PLANE_ICAO == "B462" then ULDLoaderFwdPositionFactor = 1.03
			else ULDLoaderFwdPositionFactor = 1.1 end
			-- then :
			local x = targetDoorX+10
			if PLANE_ICAO == "MD11" then x = targetDoorX+9 end
			if PLANE_ICAO == "B752" then x = targetDoorX+9.5 end
			if PLANE_ICAO == "B763" then x = targetDoorX+8 end
			if PLANE_ICAO == "A306" then x = targetDoorX+8 end
			if PLANE_ICAO == "B722" then x = targetDoorX+9.5 end
			local z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition
			local h = 90
			if UseXplaneDefaultObject == true then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], targetDoorX+15, ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition, sges_gs_plane_head[0] )
				if PLANE_ICAO == "A310" then			x = targetDoorX-7.5				y = 11				h = -90
				elseif PLANE_ICAO == "A3ST" then			x = targetDoorX-7.5				y = -12.8			h = -90
				end
			else
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], targetDoorX+10, ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition, sges_gs_plane_head[0] )
				if PLANE_ICAO == "A310" then			x = targetDoorX-3.5				y = 11				h = -90
				elseif PLANE_ICAO == "A3ST" then			x = targetDoorX-3.5				y = -11.8			h = -90
				end

				if string.find(Prefilled_CargoDeck_ULDLoaderObject,"cargo_loader_ch70w") then
					x = x + 3
				end
				-- doesn't work for big airplanes so I add :
				if  BeltLoaderFwdPosition >= ULDthresholdx  and string.find(Prefilled_CargoDeck_ULDLoaderObject,"cargo_loader_ch70w") then
					x = x + 3
				end

			end

			if (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) and IsPassengerPlane == 0 then
				x = x - 0.9
				-- definitively change linked cones for a single cone to not disturb the ULD loader on main cargo deck
				if Linked_cones ~= Prefilled_ConeObject then
					Cones_chg,Cones_instance[1],rampserviceref3 = common_unload("BAe146QTCones",Cones_instance[1],rampserviceref3)
					Linked_cones = Prefilled_ConeObject
					Cones_chg =  true
				end
			end
			x = x + lateral_factor_ULDLoader
			z = z + longitudinal_factor3_ULDLoader
			uld_x = x
			uld_x_stored = x
			uld_z = z
			ULDLoader_chg = draw_static_object(x,z,h,ULDLoader_instance[0],"ULD Loader")
		  end
	  end
	end


	function service_object_physics_People1()
	  if People1_chg == true then
		  if show_People1 then
			if PLANE_ICAO ~= "DC3" and PLANE_ICAO ~= "DC3" then
			  Load_Cami_de_Bellis_Objects()
			  if Clairmarais_Aerodrome_directory ~= nil then Clairmarais_Aerodrome_lib() end
			  load_People1()
			end
		  else
			People1_chg,People1_instance[0],rampserviceref73 = common_unload("People1",People1_instance[0],rampserviceref73)
			--unload_People1()
		  end
		  if People1_instance[0] ~= nil then
			if show_PB then
			  People1_chg = draw_static_object(targetDoorX+4,-targetDoorZ+5,310,People1_instance[0],"People1")
			else
			  People1_chg = draw_static_object(targetDoorX+3,-targetDoorZ+5,310,People1_instance[0],"People1")
			end
		  end
	  end
	end
	function service_object_physics_People2()
	  if People2_chg == true then
		  if show_People2 then
			  load_People2()
		  else
			People2_chg,People2_instance[0],rampserviceref74 = common_unload("People2",People2_instance[0],rampserviceref74)
			--unload_People2()
		  end
		  if People2_instance[0] ~= nil then
			local x = targetDoorX+4
			local z = BeltLoaderFwdPosition+2
			if PLANE_ICAO == "E195" then
				x = targetDoorX+9
				z = BeltLoaderFwdPosition
			elseif PLANE_ICAO == "A346" then
				x = 9
				z = 0.57*math.abs(BeltLoaderFwdPosition)
			end
			People2_chg = draw_static_object(x,z,80,People2_instance[0],"People2")
		  end
	  end
	end
	function service_object_physics_People3()
	  if People3_chg == true then
		  if show_People3 then
			 load_People3()
		  else
			People3_chg,People3_instance[0],rampserviceref75 = common_unload("People3",People3_instance[0],rampserviceref75)
			--unload_People3()
		  end
		  if People3_instance[0] ~= nil then
			local x = 11
			local z = -2.1*math.abs(BeltLoaderFwdPosition)


			if SecondStairsFwdPosition ~= - 30 and SecondStairsFwdPosition < -12 then -- if SecondStairsFwdPosition is defined in the aircraft config
				z = SecondStairsFwdPosition - 6
			end

			-- then peculiarities :
			if PLANE_ICAO == "E195" then
				x = targetDoorX+8
				z = BeltLoaderFwdPosition
			elseif PLANE_ICAO == "A346" then
				x = 8
				z = -0.5*math.abs(BeltLoaderFwdPosition)
			end
			People3_chg = draw_static_object(x,z,-160,People3_instance[0],"People3")
		  end
	  end
	end
	function service_object_physics_People4()
	  if People4_chg == true then
		  if show_People4 then
			  load_People4()
		  else
			People4_chg,People4_instance[0],rampserviceref76 = common_unload("People4",People4_instance[0],rampserviceref76)
			--unload_People4()
		  end
		  if People4_instance[0] ~= nil then
			local x = targetDoorX+4
			local z = 4
			if PLANE_ICAO == "E195" then
				y = 5.5
			end
			People4_chg = draw_static_object(targetDoorX+5, 4,50,People4_instance[0],"People4")
		  end
	  end
	end

	if UseXplaneDefaultObject == false then -- do not arm passengers
		function service_object_physicsPax()


			--------------
			-- delay door closing after airstairs is folded
			if PLANE_ICAO == "E19L"
			and PaxLineageStairs_time ~= nil and SGES_total_flight_time_sec > PaxLineageStairs_time + 16
			and PaxDoor1L ~= nil and PaxDoor1L ~= target_to_open_the_door-1
			and PaxLineageStairs ~= nil and PaxLineageStairs ~= target_to_open_the_door then
				-- insist on closing the Embraer Lineage jet door : waiting for stairs
				Pax_chg = true
				print("[Ground Equipment " .. version_text_SGES .. "] Lineage, allowing delayed door closing after stairs are retracted.")
				PaxLineageStairs_time = nil -- very important otherwise the user looses control on the door in a permanent fashion
			end
			--------------

		  if Pax_chg then
			if show_Pax then
				if BusFinalX == nil then BusFinalX = 29 end -- very important to secure passenger movement even without bus.
				if BusFinalY == nil then BusFinalY = 7 end
				load_Passengers()
				pax1_disapp = false
				pax2_disapp = false
				pax3_disapp = false
				pax4_disapp = false
				pax5_disapp = false
				pax6_disapp = false
				pax7_disapp = false
				pax8_disapp = false
				pax9_disapp = false
				pax10_disapp = false
				pax11_disapp = false
				pax12_disapp = false
				if PaxLineageStairs_time ~= nil then PaxLineageStairs_time = nil end
			else
				unload_Passengers() --triggers an unwanted walking_direction_changed_armed = true at first in a new flight session, So I'll revert initial status of walking direciton to "Deboarding"
				------------------
				if PLANE_ICAO == "E19L" and PaxLineageStairs ~= nil and PaxLineageStairs == target_to_open_the_door then
					PaxLineageStairs = target_to_open_the_door-1
					if PaxLineageStairs_time == nil then PaxLineageStairs_time = SGES_total_flight_time_sec end
				end
				--------------

				if PaxDoor1L ~= nil and PaxDoor1L == target_to_open_the_door then
					PaxDoor1L = target_to_open_the_door-1 -- we will try with -1 if that's Ok for the airplane, otherwise the user will hopefully correct that manually in game
				end
				if PaxDoorRearLeft ~= nil and PaxDoorRearLeft == target_to_open_the_door then
					PaxDoorRearLeft = target_to_open_the_door-1 -- we will try with -1 if that's Ok for the airplane, otherwise the user will hopefully correct that manually in game
				end
			end



			  if walking_direction == "boarding" then
				  if Passenger_instance[0] ~= nil then


					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[0],"Pax1") -- for future usage and rationalisation
				  end
				  if Passenger_instance[1] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[1],"Pax2")
				  end
				  if Passenger_instance[2] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[2],"Pax3")
				  end
				  if Passenger_instance[3] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[3],"Pax4")
				  end
				  if Passenger_instance[4] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[4],"Pax5")
					  --~ draw_Passenger5()
				  end
				  if Passenger_instance[5] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[5],"Pax6")
				  end
				  -- added 12-2022 :
				  if Passenger_instance[6] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[6],"Pax7")
				  end
				  if Passenger_instance[7] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[7],"Pax8")
				  end
				  if Passenger_instance[8] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[8],"Pax9")
				  end
				  if Passenger_instance[9] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[9],"Pax10")
				  end
				  if Passenger_instance[10] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[10],"Pax11")
				  end
				  if Passenger_instance[11] ~= nil then
					draw_all_Passengers(StairFinalX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[11],"Pax12")
				  end

			   elseif  walking_direction == "deboarding" then
				  if Passenger_instance[0] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[0],"Pax1")
				  end
				  if Passenger_instance[1] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[1],"Pax2")
				  end
				  if Passenger_instance[2] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[2],"Pax3")
				  end
				  if Passenger_instance[3] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[3],"Pax4")
				  end
				  if Passenger_instance[4] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[4],"Pax5")
				  end
				  if Passenger_instance[5] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[5],"Pax6")
				  end
				  -- added 12-2022
				  if Passenger_instance[6] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[6],"Pax7")
				  end
				  if Passenger_instance[7] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[7],"Pax8")
				  end
				  if Passenger_instance[8] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[8],"Pax9")
				  end
				  if Passenger_instance[9] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[9],"Pax10")
				  end
				  if Passenger_instance[10] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[10],"Pax11")
				  end
				  if Passenger_instance[11] ~= nil then
					draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[11],"Pax12")
				  end
			  end
		  end
		end

	end

	function service_object_physics_smallShip()
	  if Ship1_chg == true then
		  if show_Ship1 then
			  load_Ship1()
		  else
			        _,Ship1_instance[1],rampserviceref81F = common_unload("Ship1",Ship1_instance[1],rampserviceref81F)
			Ship1_chg,Ship1_instance[0],rampserviceref81 = common_unload("Ship1",Ship1_instance[0],rampserviceref81)
			--unload_Ship1()
		  end
		  if Ship1_instance[0] ~= nil then
			local x = -1
			local z = DistanceToShipWreckSite - 60
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT


			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
			_,wetness = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)

			if wetness == 0 then
				-- expand until the sea
				local j=0
				for j=1,10 do -- abandon quickly if dry terrain cannot be easily found
					z = z + 900 -- at each iteration
					coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
					_,wetness = probe_y (g_shifted_x, g_shifted_y, g_shifted_z)
					if wetness == 1 then
						print("[Ground Equipment " .. version_text_SGES .. "] Moved the static ships to reach a more humid terrain. Step " .. j .. " wetness " .. wetness .. " - forward_increment " .. z)
						break
					end
				end
			end
			if Ship1_instance[1] ~= nil then
				    _ = draw_static_object(x,z,169,Ship1_instance[1],"Ship1") -- final wetness test performed here - on fire
			end
			Ship1_chg = draw_static_object(x,z,169,Ship1_instance[0],"Ship1") -- final wetness test performed here
		  end
	  end
	end

	function service_object_physics_largeShip()
		if Ship2_chg == true then
		  if show_Ship2 then
			  load_Ship2()
		  else
			        _,Ship2_instance[1],rampserviceref82F = common_unload("Ship2",Ship2_instance[1],rampserviceref82F)
			Ship2_chg,Ship2_instance[0],rampserviceref82 = common_unload("Ship2",Ship2_instance[0],rampserviceref82)
			--unload_Ship2()
		  end
		  if Ship2_instance[0] ~= nil then
			local x = -1
			local z = DistanceToShipWreckSite + 20
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT


			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
			_,wetness = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)

			if wetness == 0 then
				-- expand until the sea
				local j=0
				for j=1,10 do -- abandon quickly if dry terrain cannot be easily found
					z = z + 900 -- at each iteration
					coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
					_,wetness = probe_y (g_shifted_x, g_shifted_y, g_shifted_z)
					if wetness == 1 then
						break
					end
				end
			end

			if Ship2_instance[1] ~= nil then
				    _ = draw_static_object(x,z,169,Ship2_instance[1],"Ship2") -- final wetness test performed here - on fire
			end
			Ship2_chg = draw_static_object(x,z,49,Ship2_instance[0],"Ship2")  -- final wetness test performed here
		  end
		end
	end

	show_XP12Carrier = false

	if IsXPlane12 then


		function service_object_physicsXP12Helicopters()
			if x_hel == nil then
				x_hel = 0
				z_hel = -800
			end
		  if Helicopters_chg == true then
			  if show_Helicopters then
				  load_Helicopters()
			  else
				_,Helicopters_instance[0],rampservicerefXP12Helicopter0 = common_unload("Helicopter",Helicopters_instance[0],rampservicerefXP12Helicopter0)
				Helicopters_chg,Helicopters_instance[1],rampservicerefXP12Helicopter1 = common_unload("Helicopter",Helicopters_instance[1],rampservicerefXP12Helicopter1)
				Helicopters_chg,Helicopters_instance[2],rampservicerefXP12Helicopter2 = common_unload("Helicopter",Helicopters_instance[2],rampservicerefXP12Helicopter2)
				Helicopters_chg,Helicopters_instance[3],rampservicerefXP12Helicopter3 = common_unload("Helicopter",Helicopters_instance[3],rampservicerefXP12Helicopter3)
				x_hel = nil
				z_hel = nil
				--~ init_x_hel = nil
				--~ init_z_hel = nil
				init_SGES_Sim_WindDir = nil
				Helicopters_draw_only_once = true
			  end
			  if Helicopters_instance[0] ~= nil then
				if SGES_Sim_WindDir == nil then
					delayed_loading_ships_datarefs()
				end
				if init_SGES_Sim_WindDir == nil  then
					init_SGES_Sim_WindDir = SGES_Sim_WindDir
				end
				if patrol_spacing == nil then
					patrol_spacing = 800
					patrol_spacing = math.random(200, 800)
				end
				if show_FireVehicle then
					-- decrease the speed when an helicopter requested by the fire brigade
					z_hel = z_hel + 0.2
					pitch_hel = -2
				elseif XP12Helicopter ~= nil and XP12Helicopter == XPlane12_ford_carrier_accessories_directory .. "FA-18E_static_spreadedwings.obj" then
					z_hel = z_hel + 2 -- increase speed when not the Sea Hawk
					pitch_hel = 0
				else
					z_hel = z_hel + 0.9 pitch_hel = -8
				end


				Helicopters_chg,_,_ = draw_static_object(x_hel,z_hel,init_SGES_Sim_WindDir,Helicopters_instance[0],"Helicopter") -- no heading corr required, the ref HDG with be the wind direction but we will specialy use the object corr factor as object heading in this case in the draw_static_function
				if Helicopters_instance[1] ~= nil then
					_,_,_ = draw_static_object(x_hel+45,z_hel-45,init_SGES_Sim_WindDir,Helicopters_instance[1],"Helicopter1")
				end
				if Helicopters_instance[2] ~= nil then
					_,_,_ = draw_static_object(x_hel-20,z_hel-patrol_spacing,init_SGES_Sim_WindDir,Helicopters_instance[2],"Helicopter")
				end
				if Helicopters_instance[3] ~= nil then
					Helicopters_chg,_,_ = draw_static_object(x_hel-65,z_hel-patrol_spacing-45,init_SGES_Sim_WindDir,Helicopters_instance[3],"Helicopter1")
				end
				if z_hel > 10000 then show_Helicopters = false print("[Ground Equipment " .. version_text_SGES .. "] Helicopters disappeared far far way.") end -- remove the helicopters when they reached the infiny
				Helicopters_chg = true
			  end
		  end
		end

		function service_object_physicsSubmarine()
			-- save performance
			if frame_counter_perf_saver == nil then frame_counter_perf_saver = 0 end
			frame_counter_perf_saver = frame_counter_perf_saver + 1
			if frame_counter_perf_saver >= 5 or  sges_gs_plane_y_agl[0] < 500  then --save FPS when user aircraft is not near the surface

				if x_sub == nil then
				x_sub = 0
				z_sub = 400
				end
				if Submarine_chg == true then
					  if show_Submarine then
						if reference_x_sub == nil then
							-- 72.1 and aboce, move the ship ahead of the aircraft, more convenient after all

						coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, 2000, sges_gs_plane_head[0])
						reference_x_sub = g_shifted_x
						reference_z_sub = g_shifted_z
							--print("[Ground Equipment " .. version_text_SGES .. "] Trying to load the submarine (or surface vessel). Will only appear over some water !")
						end
						load_Submarine()

					  else
						Submarine_chg,Submarine_instance[0],rampservicerefSubmarine = common_unload("Submarine",Submarine_instance[0],rampservicerefSubmarine)
						--print("[Ground Equipment " .. version_text_SGES .. "] Unloading the submarine (or surface vessel).") --IAS24
						x_sub = nil
						z_sub = nil
						reference_x_sub = nil
						reference_z_sub = nil
						submarine_x = nil-- IAS24, from drawing
						submarine_z = nil -- IAS24, from drawing
						init_SGES_Sim_WindDir = nil
						Submarine_draw_only_once = true
					  end
					  if Submarine_instance[0] ~= nil then
						if SGES_Sim_WindDir == nil then
							delayed_loading_ships_datarefs()
						end
						if init_SGES_Sim_WindDir == nil then
							init_SGES_Sim_WindDir = SGES_Sim_WindDir
						end
						z_sub = z_sub + 0.03 -- speed for all
						-- I contourned the use of this funciton initialy reserved for submarine to also display mobing boats, so I'll adapt the speed for surface vessels if they are not a sub.
						if not (string.find(User_Custom_Prefilled_SubmarineObject,"Akula") or string.find(User_Custom_Prefilled_SubmarineObject,"Virginia") or string.find(User_Custom_Prefilled_SubmarineObject,"581") or string.find(User_Custom_Prefilled_SubmarineObject,"Barbel") or string.find(User_Custom_Prefilled_SubmarineObject,"Blueback") or string.find(User_Custom_Prefilled_SubmarineObject,"Sub")) then
							z_sub = z_sub + 0.09	-- additive to the previous speed for all
						end
						-- if is an akula soviet submarine, increase the speed. --IAS24
						--if string.find(User_Custom_Prefilled_SubmarineObject,"Akula") then z_sub = z_sub + 0.02 end
						--~ if string.find(User_Custom_Prefilled_SubmarineObject,"Akula") then z_sub = z_sub -0.06 end --TEMPO
						Submarine_chg,_,_ = draw_static_object(x_sub,z_sub,init_SGES_Sim_WindDir,Submarine_instance[0],"Submarine") -- no heading corr required, the ref HDG with be the wind direction but we will specialy use the object corr factor as object heading in this case in the draw_static_function
						--~ if z_sub > 10000 then show_Submarine = false print("[Ground Equipment " .. version_text_SGES .. "] show_Submarine disappeared far far way.") end -- remove the show_Submarine when it reached the infinity
						Submarine_chg = true
					  end
				end
				frame_counter_perf_saver = 0
			end
		end







		function service_object_physicsXP12Carrier()
			local x = 100
			local z = DistanceToShipWreckSite  + 300
		  if XP12Carrier_chg == true then
			  if show_XP12Carrier then
				  load_XP12Carrier()
			  else
				if Prefilled_XP12Boat == Prefilled_XP12Carrier then
					_,XP12Carrier_instance[6],rampservicerefXP12CarrierP7 = common_unload("XP12Carrier",XP12Carrier_instance[6],rampservicerefXP12CarrierP7)
					_,XP12Carrier_instance[5],rampservicerefXP12CarrierP6 = common_unload("XP12Carrier",XP12Carrier_instance[5],rampservicerefXP12CarrierP6)
					_,XP12Carrier_instance[4],rampservicerefXP12CarrierP5 = common_unload("XP12Carrier",XP12Carrier_instance[4],rampservicerefXP12CarrierP5)
					_,XP12Carrier_instance[3],rampservicerefXP12CarrierP4 = common_unload("XP12Carrier",XP12Carrier_instance[3],rampservicerefXP12CarrierP4)
					_,XP12Carrier_instance[2],rampservicerefXP12CarrierP3 = common_unload("XP12Carrier",XP12Carrier_instance[2],rampservicerefXP12CarrierP3)
					_,XP12Carrier_instance[1],rampservicerefXP12CarrierP2 = common_unload("XP12Carrier",XP12Carrier_instance[1],rampservicerefXP12CarrierP2)
				end
				XP12Carrier_chg,XP12Carrier_instance[0],rampservicerefXP12Carrier = common_unload("XP12Carrier",XP12Carrier_instance[0],rampservicerefXP12Carrier)
				show_XP12Carrier = false
			  end
			  if XP12Carrier_instance[0] ~= nil then
				x = -100
				z = DistanceToShipWreckSite  + 300

				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
				_,wetness = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)
				-- In X-Plane 12 advance the carrier to the shore
				if wetness == 0 and GUIcoordinates == false then
					-- expand until the sea
					local j=0
					for j=1,60 do -- abandon quickly if dry terrain cannot be easily found
						z = z + 670 -- at each iteration
						if selected_boat == 0 then z = z + 680 end -- avoid superpositions
						coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x, z, sges_gs_plane_head[0] )
						_,wetness = probe_y (g_shifted_x, g_shifted_y, g_shifted_z)
						if wetness == 1 then
							print("[Ground Equipment " .. version_text_SGES .. "] Moved the static boat to reach a more humid terrain. Step " .. j .. " wetness " .. wetness .. " - forward_increment " .. z)
							break
						end
					end
				end

				if wetness == 1 or GUIcoordinates then
					-- POSITIVE LEFT < x > NEGATIVE RIGHT
					-- POSITIVE FWD < z > NEGATIVE AFT
					if SGES_Sim_WindDir == nil then
						delayed_loading_ships_datarefs()
					end

					if Prefilled_XP12Boat == Prefilled_XP12Carrier then
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[6],"XP12Carrier")
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[5],"XP12Carrier")
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[4],"XP12Carrier")
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[3],"XP12Carrier")
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[2],"XP12Carrier")
						_ = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[1],"XP12Carrier")
					end
					XP12Carrier_chg,XP12boat_location_x,XP12boat_location_z = draw_static_object(x,z,SGES_Sim_WindDir,XP12Carrier_instance[0],"XP12Carrier")
					show_XP12Carrier = true
				end
			  end
		  end
		  return XP12boat_location_x,XP12boat_location_z
		end
	end

	function service_object_physicsTargetMarker() -- The Aiming arrow
		if TargetMarker_chg == true then
		  if show_TargetMarker then

			 load_TargetMarker()
		  else
			TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker)
			--unload_TargetMarker()
			TargetMarkerH = sges_gs_plane_head[0]
			TargetMarkerY = sges_gs_plane_y[0]
			TargetMarkerX_stored = nil
			TargetMarkerZ_stored = nil
		  end
		  if TargetMarker_instance[0] ~= nil then
				if automatic_marshaller_requested then
					-- we need to cycle through 4 saved positions
					--~ retained_parkings_position_local_Z
					--~ retained_parkings_position_local_X
					--~ retained_parkings_position_heading
					--~ Park1, Park2, Park3, Park4
					-- if value different than zero
					TargetMarkerX_stored = retained_parkings_position_local_X[park] -- park is manually selected by button to browse the spots
					TargetMarkerZ_stored = retained_parkings_position_local_Z[park]
					retained_parking_position_heading = retained_parkings_position_heading[park]

					TargetMarker_chg = draw_from_simulator_coordinates(TargetMarkerX_stored,TargetMarkerZ_stored,retained_parking_position_heading,TargetMarker_instance[0],"TargetMarker")
					--print("Draw arrow for " .. park .. " at X=" .. retained_parkings_position_local_X[park] .. " and Z=" .. retained_parkings_position_local_Z[park] .. "    for " .. retained_parkings_position_lon[park] .. " ; " .. retained_parkings_position_lat[park])
				else
					local x = 0
					local z = 4*math.abs(BeltLoaderFwdPosition)+user_targeting_factor
					local h = TargetMarkerH
					TargetMarker_chg = draw_static_object(x,z,h-sges_gs_plane_head[0],TargetMarker_instance[0],"TargetMarker")
					-- save marker position
					TargetMarkerX_stored = g_shifted_x
					TargetMarkerZ_stored = g_shifted_z
					--print("Draw arrow for " .. TargetMarkerH .. "° at X=" .. TargetMarkerX_stored.. " and Z=" .. TargetMarkerZ_stored)
				end
		  end
		end
		--IAS24 start
		-- replace the big noticeable arrow which is used during the selection to a discrete arrow
		if show_TargetMarker and SGES_park_designation_flight_time_sec ~= nil and SGES_total_flight_time_sec >= SGES_park_designation_flight_time_sec + 20 then
				if Prefilled_TargetMarkerObject ~=  SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" and TargetMarker_instance[0] ~= nil then --IAS24
					TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) --IAS24
					Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" --IAS24
					TargetMarker_show_only_once = true
					TargetMarker_chg = true
				end
		end  --IAS24 end
	end

	function service_object_physics_AllCHOCKS()
		if Chocks_chg == true then
			--~ print("[Ground Equipment " .. version_text_SGES .. "] CHG chocks.")
			if show_Chocks == true then
				-- don't put the chocks when spawned on the aircraft carrier at sea.
				_,wetness = probe_y(sges_gs_plane_x[0], 0, sges_gs_plane_z[0])
				--~ if wetness == 1 then
					--~ show_Chocks = false
				--~ end
				if sges_fire_retardant_m_stored ~= nil then sges_fire_retardant_m_stored = nil end -- allow water replenishing
			end
			-- for a few seconds the aircraft will stabilize on the deck, because it's
			-- applying the physical blocage first at line 9440+ of this script
			-- but that's an improvement over the previous situation
			-- and I don't want to probe for wetness on a per second fashion there.

			if IsXPlane1220 and UseXplane1220Chocks then
				Chocks_chg = false
				print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.2 and above chocks.")
			end
			if show_Chocks then
				-- this section as aircrfat specific stuff so we keep it active even with UseXplane1220Chocks == false

				--~ if PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then command_once("CL650/hand_signals/chocks_in") end
				if string.match(AIRCRAFT_PATH,"146") then if XPLMFindDataRef("thranda/views/chocks") ~= nil then set("thranda/views/chocks",1) end end
				if PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104 chocks
					set("Colimata/F104_A_SW_GROUND_chocks_i",1)
					set("Colimata/F104_A_SW_GROUND_pins_i",1)
					set("Colimata/F104_A_SW_GROUND_ladder_i",1)
					--~ set("Colimata/F104_A_SW_canopy_i",1)
				end

				if AIRCRAFT_FILENAME == "AW109SP.acf" and PLANE_AUTHOR == "X-Trident" then set("aw109/servicing/wheel_chocks",1) end


				if (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko") and XPLMFindDataRef("XCrafts/other/ground_objects") ~= nil then set("XCrafts/other/ground_objects",0) end

				if PLANE_ICAO == "M346" and PLANE_AUTHOR == "Kostas Koronakis Dimitris Koronakis Andrzej Borysewicz" then -- toggle M346 chocks
					set("DWSim/m346/external/ladder",0)
					set("DWSim/m346/external/choks",0)
				end

				if PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis") and sges_EngineState[2] < 5 then
					--~ print("[FlyWithLua Debug] PLANE_ICAO is B742, and we look for specific action when chocks are set, like calling the GPU as well.")
					print("[Ground Equipment " .. version_text_SGES .. "] B747-200, calling the GPU along with chocks.")
					set("B742/INT_PA/connect_gpu",1)
				end


				if (string.match(PLANE_ICAO,"P28") and PLANE_AUTHOR == "JustFlight") or (string.match(PLANE_AUTHOR,"Thranda") and not string.match(AIRCRAFT_PATH,"146")) then -- toggle Jusflight Piper
					if XPLMFindDataRef("thranda/covers/TieDownR") ~= nil then	set("thranda/covers/TieDownR",1) end
					if XPLMFindDataRef("thranda/covers/TieDownL") ~= nil then	set("thranda/covers/TieDownL",1) end
					if XPLMFindDataRef("thranda/covers/TieDownT") ~= nil then	set("thranda/covers/TieDownT",1) end
					if XPLMFindDataRef("thranda/views/chockR") ~= nil then	set("thranda/views/chockR",1) end
					if XPLMFindDataRef("thranda/views/chockL") ~= nil then	set("thranda/views/chockL",1) end
					if XPLMFindDataRef("thranda/views/chockN") ~= nil then	set("thranda/views/chockN",1) end
					if XPLMFindDataRef("thranda/views/chocks") ~= nil then	set("thranda/views/chocks",1) end
					if XPLMFindDataRef("thranda/cockpit/animations/door") ~= nil then
						set_array("thranda/cockpit/animations/doormanip",0,1)
						set_array("thranda/cockpit/animations/door",0,1)
						-- if door 2 :
						--~ set_array("thranda/cockpit/animations/door",1,1)
						--~ set_array("thranda/cockpit/animations/doormanip",1,1)
						if not string.match(PLANE_ICAO,"PC12") then -- do not open the door for the Pilatus
							set_array("thranda/cockpit/animations/door",2,1)
							set_array("thranda/cockpit/animations/doormanip",2,1)
						end
						set_array("thranda/cockpit/animations/door",3,1)
						set_array("thranda/cockpit/animations/doormanip",3,1)
					end


					-- xplane 11 versions :
					if XPLMFindDataRef("thranda/views/staticelements") ~= nil then
						set("thranda/views/staticelements",1)
					end
				end

				if UseXplane1220Chocks == false and wetness == 0  then
					load_Chocks() -- don't draw the chocks over water
				end

			elseif not show_Chocks then
				-- this section as aircrfat specific stuff so we keep it active even with UseXplane1220Chocks == false
				----------------------------------------------------------------
				-- debugging
				if PLANE_ICAO == nil then
					print("[FlyWithLua Debug] PLANE_ICAO is nil!")
				end
				if PLANE_AUTHOR == nil then
					print("[FlyWithLua Debug] PLANE_AUTHOR is nil!")
				end
				----------------------------------------------------------------
				--~ if PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then command_once("CL650/hand_signals/chocks_out") end
				if PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104 chocks
					set("Colimata/F104_A_SW_GROUND_chocks_i",0)
					set("Colimata/F104_A_SW_GROUND_pins_i",0)
					set("Colimata/F104_A_SW_GROUND_ladder_i",0)
				end


				if AIRCRAFT_FILENAME == "AW109SP.acf" and PLANE_AUTHOR == "X-Trident" then set("aw109/servicing/wheel_chocks",0) end

				if (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko") and XPLMFindDataRef("XCrafts/other/ground_objects") ~= nil then
					set("XCrafts/other/ground_objects",1)
					--~ set("XCrafts/other/remove_before_flight",1)
				end

				if PLANE_ICAO == "M346" and PLANE_AUTHOR == "Kostas Koronakis Dimitris Koronakis Andrzej Borysewicz" then -- toggle M346 chocks
					set("DWSim/m346/external/ladder",1)
					set("DWSim/m346/external/choks",1)
				end

				if not string.match(AIRCRAFT_PATH,"146") and ((PLANE_ICAO and string.match(PLANE_ICAO, "P28") and PLANE_AUTHOR == "JustFlight")
					or (PLANE_AUTHOR and string.match(PLANE_AUTHOR, "Thranda"))) then 					-- toggle JustFlight Piper

					if XPLMFindDataRef("thranda/covers/TieDownR") ~= nil then	set("thranda/covers/TieDownR",0) end
					if XPLMFindDataRef("thranda/covers/TieDownL") ~= nil then	set("thranda/covers/TieDownL",0) end
					if XPLMFindDataRef("thranda/covers/TieDownT") ~= nil then	set("thranda/covers/TieDownT",0) end
					if XPLMFindDataRef("thranda/views/chockR") ~= nil then	set("thranda/views/chockR",0) end
					if XPLMFindDataRef("thranda/views/chockL") ~= nil then	set("thranda/views/chockL",0) end
					if XPLMFindDataRef("thranda/views/chockN") ~= nil then	set("thranda/views/chockN",0) end
					if XPLMFindDataRef("thranda/views/chocks") ~= nil then	set("thranda/views/chocks",0) end
					-- doors
					if XPLMFindDataRef("thranda/cockpit/animations/door") ~= nil then
						set_array("thranda/cockpit/animations/door",0,0)
						set_array("thranda/cockpit/animations/doormanip",0,0)
						-- if door 2 :
						set_array("thranda/cockpit/animations/door",1,0)
						set_array("thranda/cockpit/animations/doormanip",1,0)
						set_array("thranda/cockpit/animations/door",2,0)
						set_array("thranda/cockpit/animations/doormanip",2,0)
						set_array("thranda/cockpit/animations/door",3,0)
						set_array("thranda/cockpit/animations/doormanip",3,0)
					end
					-- remove covers if not initial SGES loading :
					if os.clock() > SGES_start_time + 30 then
						if XPLMFindDataRef("thranda/covers/PitotCoverR") ~= nil then	set("thranda/covers/PitotCoverR",0) end
						if XPLMFindDataRef("thranda/covers/PitotCoverL") ~= nil then	set("thranda/covers/PitotCoverL",0) end
						if XPLMFindDataRef("thranda/covers/IntakeCoverR") ~= nil then	set("thranda/covers/IntakeCoverR",0) end
						if XPLMFindDataRef("thranda/covers/IntakeCoverL") ~= nil then	set("thranda/covers/IntakeCoverL",0) end
						if XPLMFindDataRef("thranda/covers/IntakeCover") ~= nil then	set("thranda/covers/IntakeCover",0) end
						if XPLMFindDataRef("thranda/covers/ExhaustCoverL") ~= nil then	set("thranda/covers/ExhaustCoverL",0) end
						if XPLMFindDataRef("thranda/covers/ExhaustCoverR") ~= nil then	set("thranda/covers/ExhaustCoverR",0) end
						if XPLMFindDataRef("thranda/covers/ElevatorCoverR") ~= nil then	set("thranda/covers/ElevatorCoverR",0) end
						if XPLMFindDataRef("thranda/covers/ElevatorCoverL") ~= nil then	set("thranda/covers/ElevatorCoverL",0) end
						if XPLMFindDataRef("thranda/views/hidepilot") ~= nil then		set("thranda/views/hidepilot",0) end
						if XPLMFindDataRef("thranda/views/hidecopilot") ~= nil then		set("thranda/views/hidecopilot",0) end
						-- metal tail support :
						if PLANE_ICAO == "KODI" and XPLMFindDataRef("sim/aircraft/parts/acf_gear_leglen") ~= nil then	set_array("sim/aircraft/parts/acf_gear_leglen",5,0) end
						if PLANE_ICAO == "PC12" and XPLMFindDataRef("sim/aircraft/parts/acf_gear_leglen") ~= nil then	set_array("sim/aircraft/parts/acf_gear_leglen",3,0) end
					end
					-- xplane 11 versions :
					if XPLMFindDataRef("thranda/views/staticelements") ~= nil then
						set("thranda/views/staticelements",0)
					end

				end

				if Chocks_instance[1]~= nil then _,Chocks_instance[1],rampserviceref92 = common_unload("Chock2",Chocks_instance[1],rampserviceref92) end
				if Chocks_instance[2]~= nil then _,Chocks_instance[2],rampserviceref93 = common_unload("Chock3",Chocks_instance[2],rampserviceref93) end
				if Chocks_instance[0]~= nil then Chocks_chg,Chocks_instance[0],rampserviceref91 = common_unload("Chocks",Chocks_instance[0],rampserviceref91) end

				--~ unload_Chocks()
				sges_position_static_psi 	= nil
				sges_position_static_z 		= nil
				sges_position_static_x 		= nil
				sges_position_static_y 		= nil
			end

			-- here only applicable when not UseXplane1220Chocks, we draw the chocks :
			-- Chocks_instance[0] is not loaded in load_Chocks() when UseXplane1220Chocks == true
			if Chocks_instance[0] ~= nil then
				if Chocks_instance[2] ~= nil then draw_static_object(gear2X,gear2Z+0.08,180,Chocks_instance[2],"RightChock") end
				if Chocks_instance[1] ~= nil  and BeltLoaderFwdPosition > 5 then
					draw_static_object(-1*gear2X,gear2Z+0.08,180,Chocks_instance[1],"LeftChock")
				end
				-- front chock :
				Chocks_chg = draw_static_object(gear1X,gear1Z+0.08,0,Chocks_instance[0],"Chocks")
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Draw chocks")
				-- MEMO :
				--dataref("gear1X",   "sim/aircraft/parts/acf_gear_xnodef[0]",   "readonly")
				--dataref("gear1Y",   "sim/aircraft/parts/acf_gear_ynodef[0]",   "readonly")
				--dataref("gear1Z",   "sim/aircraft/parts/acf_gear_znodef[0]",   "readonly")
				--dataref("gear2X",   "sim/aircraft/parts/acf_gear_xnodef[1]",   "readonly")
				--dataref("gear2Y",   "sim/aircraft/parts/acf_gear_ynodef[1]",   "readonly")
				--dataref("gear2Z",   "sim/aircraft/parts/acf_gear_znodef[1]",   "readonly")
			end
		end
	end

	Cart_heading_correcting_factor = 0

	Intervention_on_walking_direction_only_once = false
	function service_object_physics_Cart()
		if Cart_chg == true then
		  if show_Cart then
			  load_Cart()
		  elseif BeltLoader_instance[1] ~= nil and CartFinalX ~= nil then
					-- POSITIVE LEFT < x > NEGATIVE RIGHT
					-- POSITIVE FWD < z > NEGATIVE AFT
				--~ if CartFinalX > gear1X then
					--~ print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name .. " is on the left")
				--~ end
				if Cart_heading_correcting_factor == 180 then
					Cart_chg,BeltLoader_instance[1],rampserviceref9,CartFinalX,CartFinalY = Common_draw_departing_vehicles(CartFinalX,CartFinalY,BeltLoader_instance[1],"Cart",rampserviceref9,5)	-- UGLY PATCH
				else
					Cart_chg,BeltLoader_instance[1],rampserviceref9,CartFinalX,CartFinalY = Common_draw_departing_vehicles(CartFinalX,CartFinalY,BeltLoader_instance[1],"Cart",rampserviceref9,-10)
				end
				-- reset
				if Baggage_instance[3] ~= nil then _,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3) end
				if Baggage_instance[4] ~= nil then _,Baggage_instance[4],rampservicerefBaggage4 = common_unload("Baggage4",Baggage_instance[4],rampservicerefBaggage4) end
				Cart_currentX = nil
				Cart_currentY = nil
		  else
			  Cart_chg,BeltLoader_instance[1],rampserviceref9 = common_unload("Cart",BeltLoader_instance[1],rampserviceref9)
				show_Baggage = false
				Baggage_chg = true
			  --unload_Cart()
				-- reset
				Cart_currentX = nil
				Cart_currentY = nil
		  end
		  if BeltLoader_instance[1] ~= nil and show_Cart then
			  draw_Cart()
		  end

		end
	end

	function service_object_physics_Baggage() --actuated in Simple_Ground_Equipment_and_Services_Ships_functions

		local baggage_vertical_step = 0.0003 -- by belt loader slope and baggage speed
		local baggage_vertical_step_down = 0.0004

		-- when those are LD3, not baggage, the slope is 0, because we dont have a belt conveyer but a flat Cargo laoder :
		if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then baggage_vertical_step = 0 baggage_vertical_step_down = 0 end



		if baggage1_angle == nil then
			baggage1_angle = -80
			-- also make the  ** initial ** direction to be compatible will the last step of bus drawing, when the direction is applied by the bus :
			--~ if SGES_total_flight_time_sec < 3600 then
				--~ walking_direction = "boarding" -- the same direction as what will set the bus
				--~ print("Intervention on walking_direction " .. walking_direction)
			--~ elseif SGES_total_flight_time_sec >= 3600 then
				--~ walking_direction = "deboarding"  -- the same direction as what will set the bus
				--~ print("Intervention on walking_direction " .. walking_direction)
			--~ end -- so there will be no visual disruption
		end

		if Baggage_chg == true then
			if show_Baggage then
			--~ if show_Baggage and show_Cart then
			  load_Baggage()
			  if baggage_pass == nil then baggage_pass = 0 end -- init
			else
				_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
				_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
				_,Baggage_instance[2],rampservicerefBaggage2 = common_unload("Baggage2",Baggage_instance[2],rampservicerefBaggage2)
				_,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)
				Baggage_chg,Baggage_instance[4],rampservicerefBaggage4 = common_unload("Baggage4",Baggage_instance[4],rampservicerefBaggage4)
				ULDLoader_chg,ULDLoader_instance[1],rampserviceref722 = common_unload("ULDLoader",ULDLoader_instance[1],rampserviceref722)
			end

			-- animated baggage are present only during a limited period of time:
			if baggage_pass ~= nil then
				if (baggage_pass > 30 and BeltLoaderFwdPosition > 7) or baggage_pass > 15 then
					show_Baggage = false
					Baggage_chg = true
					baggage_pass = 0
					show_Cart = false
					Cart_chg = true
					if baggage_x > 0 then -- remove the cones to allow the cart departure
						_,Cones_instance[1],rampserviceref3 = common_unload("Cones",Cones_instance[1],rampserviceref3)
					end
				end
			end

			-- rear static baggages deposit near the rear belt loader when it is available
		  if Baggage_instance[2] ~= nil and show_Cart and show_RearBeltLoader and baggage_x2 ~= nil then
			if IsPassengerPlane == 0 then
				draw_static_object(baggage_x2-1,baggage_z2+2,-175,Baggage_instance[2],"Baggage2") -- the dolly is a wide 3D object, we don't want it to intersect with the human handler
			else
				draw_static_object(baggage_x2,baggage_z2,-175,Baggage_instance[2],"Baggage2") -- normal baggages
			end
		  end




		  -- forward baggages
		  if  show_Cart and baggage_x ~= nil then
				--~ print("LOAD function service_object_physics_Baggage")
				if Baggage_instance[0] ~= nil then
					Baggage_chg = draw_static_object(baggage_x,baggage_z,-92,Baggage_instance[0],"Baggage")
				end
				if baggage_x1 == nil then baggage_x1 = baggage_x-1.5 end
				if baggage_vert1 == nil then baggage_vert1 = baggage_vert end
				if Baggage_instance[1] ~= nil  then
					Baggage_chg = draw_static_object(baggage_x1,baggage_z,baggage1_angle,Baggage_instance[1],"Baggage1")
				end

				  -- forward baggages ULD plate
				local moving_deck_altitude = 0.52
				if CargoDeck_ULDLoaderPlateObject ~= nil then

					if walking_direction == "boarding" and baggage_vert >= moving_deck_altitude and baggage_x > baggage_x_stored + 6.1 then
						plate_vert = plate_vert - 0.0075
						if plate_vert < moving_deck_altitude then plate_vert = moving_deck_altitude end
					elseif walking_direction == "deboarding" and baggage_x_stored - baggage_x < 1 then
						plate_vert = moving_deck_altitude
					elseif walking_direction == "deboarding" and baggage_vert > 1.78 and plate_vert <= 1.79 and baggage_x_stored - baggage_x >= 1 then
						plate_vert = plate_vert + 0.015
						if plate_vert > 1.79 then plate_vert = 1.79 end
					else
						plate_vert = baggage_vert
					end

					if ULDLoader_instance[1] ~= nil then draw_static_object(FrontLoader_x,FrontLoader_z,-90,ULDLoader_instance[1],"ULDLoaderplate") end
					-- I needed to merge the moving plate and the fixed ULD loader base

				end

				if Baggage_chg == false then
					Baggage_chg = true -- draw only once
				end


				if baggage_x < 0 then -- cargo hold on the right hand side



					if walking_direction == "boarding" then
						--~ baggage_x = baggage_x + (0.005 * 1.5) -- animate the baggage
						baggage_x1 = baggage_x1 + (0.005 * 1.5) -- animate the baggage
						baggage_vert = baggage_vert + (baggage_vertical_step * 1.5)
						baggage_vert1 = baggage_vert1 + (baggage_vertical_step * 1.5)

						-- the case of the LD3 altitude :
						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and baggage_x > baggage_x_stored + 6 then
							baggage_x = baggage_x + 0.004  -- very slowly
						elseif Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and baggage_x > baggage_x_stored + 4 then

							if string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") and baggage_vert <= 1.79 then
								baggage_vert = baggage_vert + 0.008 -- climbing
								baggage_x = baggage_x  -- waiting
								--~ print(baggage_vert)
							elseif not string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") and baggage_vert <= 1.73 then
								baggage_vert = baggage_vert + 0.02 -- climbing
								baggage_x = baggage_x  -- waiting
							else
								baggage_x = baggage_x + (0.005 * 1.5) -- animate the baggage
							end
						elseif Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then
							baggage_vert = baggage_vert_stored
							baggage_x = baggage_x + (0.005 * 1.5) -- animate the baggage
						else
							baggage_x = baggage_x + (0.005 * 1.5) -- animate the baggage
						end
						-- ULD loader step, one time


						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and baggage_x > baggage_x_stored + 7  then   -- once the LD3 as reached the fuselage, restart
							if Baggage_instance[0] ~= nil then
								_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
							end
							baggage_x 	= baggage_x_stored + 0.5
							baggage_vert = baggage_vert_stored
							load_Baggage()
							baggage_pass = baggage_pass + 0.5 -- make it twice as long as passenger luggage
						elseif baggage_x > - 2 then -- once the baggage as reached the fuselage, restart
							if Baggage_instance[0] ~= nil then
								_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
							end
							baggage_x 	= baggage_x_stored
							baggage_vert = baggage_vert_stored
							load_Baggage()
							baggage_pass = baggage_pass + 1
						end

						if baggage_x1 > - 2 then -- once the baggage as reached the fuselage, restart
							if Baggage_instance[1] ~= nil then
								_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
							end
							baggage_x1 	= baggage_x_stored
							baggage_vert1 = baggage_vert_stored
							randomView = math.random()
							if randomView > 0.50 then baggage1_angle = -80 else	baggage1_angle = 100 end
						end
					else -- deboarding situation
						--~ baggage_x = baggage_x - 0.01 -- animate the baggage --
						baggage_x1 = baggage_x1 - 0.01 -- animate the baggage --
						baggage_vert = baggage_vert - baggage_vertical_step_down --
						baggage_vert1 = baggage_vert1 - baggage_vertical_step_down --

						-- the case of the LD3 altitude :
						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and baggage_x < baggage_x_stored - 4.5 then

														--~ -- modifier applies after new cargo loader in X-Plane 12.1 :
							if string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") and baggage_vert >= moving_deck_altitude then
								baggage_vert = baggage_vert - 0.01 -- descending
								baggage_x = baggage_x - 0.0001 -- waiting
								--~ print(baggage_vert)
							elseif not string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") and baggage_vert >= 0.37 then -- MisterX ULD, before XP 12.1
								baggage_vert = baggage_vert - 0.02 -- descending
								baggage_x = baggage_x - 0.0001 -- waiting
							else
								baggage_x = baggage_x - 0.005 -- slowly animate the baggage --
							end
						elseif Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then
							baggage_vert = baggage_vert_stored
							baggage_x = baggage_x - 0.01 -- animate the baggage --
						else
							baggage_x = baggage_x - 0.01 -- animate the baggage --
						end
						-- ULD loader step, one time


						if baggage_x < - 10 then --
							if Baggage_instance[0] ~= nil then
								_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
							end
							baggage_x 	= baggage_x_stored --
							baggage_vert = baggage_vert_stored --
							load_Baggage() -- change the luggage
							baggage_pass = baggage_pass + 1
							--~ print("baggage_pass + 1 D")
						end -- once the baggage as reached the fuselage, restart
						if baggage_x1 < - 10 then --
							if Baggage_instance[1] ~= nil then
								_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
							end
							baggage_x1	= baggage_x_stored --
							baggage_vert1 = baggage_vert_stored
							randomView = math.random()
							if randomView > 0.50 then
								baggage1_angle = -80
							else
								baggage1_angle = 100
							end
						end -- once the baggage as reached the fuselage, restart
					end
					-- independantly of the boarding of deboarding situation, manage the human :
					if Baggage_instance[4] ~= nil then

						if SGES_handler4_timer == nil then SGES_handler4_timer = SGES_total_flight_time_sec end

						if baggage_x4 == nil then baggage_x4 = baggage_x-1 end
						if baggage4_angle == nil then baggage4_angle = 90 end
						if baggage_z4 == nil and IsPassengerPlane == 0 then baggage_z4 = baggage_z + 2.5
						elseif baggage_z4 == nil then baggage_z4 = baggage_z - 2.5 end -- the ULD loader is wider, so make the man farther

						if baggage4_angle > 0 then baggage_x4 = baggage_x4 + (0.007) baggage_z4 = baggage_z4 - 0.0002 else baggage_x4 = baggage_x4 - (0.008) baggage_z4 = baggage_z4 + 0.0002 end
						draw_static_object(baggage_x4,baggage_z4,baggage4_angle,Baggage_instance[4],"Baggage4")

						if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and baggage_x4 > - 3 then -- once the human handler as reached the fuselage, switch direction for the human
							baggage4_angle = -95
							SGES_handler4_timer = SGES_total_flight_time_sec
						elseif Prefilled_BeltLoaderObject ~= Prefilled_ULDLoaderObject  and baggage_x4 > baggage_x or baggage_x4 > -4 or baggage_x4 > baggage_x_stored + 2 then -- once the human handler as reached the fuselage, switch direction for the human
						--~ if baggage_x4 > -8 then -- once the human handler as reached the fuselage, switch direction for the human
							baggage4_angle = -95
							SGES_handler4_timer = SGES_total_flight_time_sec
						elseif Prefilled_BeltLoaderObject ~= Prefilled_ULDLoaderObject  and baggage_x4 < baggage_x_stored - 0.5 and SGES_total_flight_time_sec > SGES_handler4_timer + 5 then -- once the human handler as reached the cart, switch direction for the human
							baggage4_angle = 85
						elseif baggage_x4 < - 10 and SGES_total_flight_time_sec > SGES_handler4_timer + 5  then
							baggage4_angle = 85
						end
						--
						--~ SGES_total_flight_time_sec > SGES_handler4_timer + 5
						-- this timer avoids frenetic changes of direction as it sometimes - rarely - happened before this patch. Found on the A340-600.
					end
					-- rear human :
					if Baggage_instance[3] ~= nil and baggage_x2 ~= nil and show_RearBeltLoader then
						if baggage_x3 == nil then baggage_x3 = baggage_x2 end
						if baggage3_angle == nil then baggage3_angle = 80 end
						if baggage_z3 == nil then baggage_z3 = baggage_z2 - 2 end
						if baggage3_angle > 0 then baggage_x3 = baggage_x3 + (0.0075) baggage_z3 = baggage_z3 - 0.0002 else baggage_x3 = baggage_x3 - (0.0085) baggage_z3 = baggage_z3 + 0.0002 end


						_ = draw_static_object(baggage_x3,baggage_z3,baggage3_angle,Baggage_instance[3],"Baggage3")

						if IsPassengerPlane then
							if baggage_x3 > baggage_x2 + 12 or baggage_x3 > -2.5 then -- once the human handler as reached the fuselage, switch direction for the human
								baggage3_angle = -95
							elseif baggage_x3 < baggage_x2 + 0.5 then -- once the human handler as reached the cart, switch direction for the human
								baggage3_angle = 85
							end
						else -- the cargo don't have all the objects and it apparently cause a different situaiton in the animation where the man never turns 180°.'
							if baggage_x3 > -1 then -- once the human handler as reached the fuselage, switch direction for the human
								baggage3_angle = -95
							elseif baggage_x3 < -20 then -- once the human handler as reached the cart, switch direction for the human
								baggage3_angle = 85
							end
						end
					elseif not show_RearBeltLoader and Baggage_instance[3] ~= nil then
						--~ print("unload baggage3 = rear handler")
						_,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)

					end



				else -- cargo hold on the left hand side




					if Baggage_instance[0] ~= nil and Baggage_instance[1] ~= nil then
						if walking_direction == "boarding" then
							baggage_x = baggage_x - (0.005 * 1.5) -- animate the baggage
							baggage_x1 = baggage_x1 - (0.005 * 1.5) -- animate the baggage
							baggage_vert = baggage_vert + (baggage_vertical_step * 1.5)
							baggage_vert1 = baggage_vert1 + (baggage_vertical_step * 1.5)
							if baggage_x < 1.7 then
								_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
								baggage_x 	= baggage_x_stored
								baggage_vert = baggage_vert_stored
								load_Baggage()
								baggage_pass = baggage_pass + 1
							end -- once the baggage as reached the fuselage, restart
							if baggage_x1 < 1.7 then
								_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
								baggage_x1 	= baggage_x_stored
								baggage_vert1 = baggage_vert_stored
								randomView = math.random()
								if randomView > 0.10 then
									baggage1_angle = -80
								else
									baggage1_angle = 100
								end
							end -- once the baggage as reached the fuselage, restart
						else -- deboarding situation
							baggage_x = baggage_x + 0.01 -- animate the baggage --
							baggage_x1 = baggage_x1 + 0.01 -- animate the baggage --
							baggage_vert = baggage_vert - baggage_vertical_step_down --
							baggage_vert1 = baggage_vert1 - baggage_vertical_step_down --
							if baggage_x > 10 then --
								_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
								baggage_x 	= baggage_x_stored --
								baggage_vert = baggage_vert_stored
								load_Baggage() -- change the luggage
								baggage_pass = baggage_pass + 1
							end -- once the baggage as reached the fuselage, restart
							if baggage_x1 > 10 then --
								_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
								baggage_x1 	= baggage_x_stored --
								baggage_vert1 = baggage_vert_stored
								randomView = math.random()
								if randomView > 0.10 then
									baggage1_angle = -80
								else
									baggage1_angle = 100
								end
							end -- once the baggage as reached the fuselage, restart
						end
					end
					-- independantly of the boarding of deboarding situation, manage the human :
					if Baggage_instance[4] ~= nil then
						if baggage_x4 == nil then baggage_x4 = baggage_x + 3 end
						if baggage4_angle == nil then baggage4_angle = -90 end
						if baggage_z4 == nil then baggage_z4 = baggage_z - 1.3 end
						if baggage4_angle < 0 then baggage_x4 = baggage_x4 - (0.007) else baggage_x4 = baggage_x4 + (0.008) end
						draw_static_object(baggage_x4,baggage_z4,baggage4_angle,Baggage_instance[4],"Baggage4")
						if baggage_x4 < 10.5 then -- once the human handler as reached the fuselage, switch direction for the human
							baggage4_angle = 90
						elseif walking_direction == "boarding" and baggage_x4 > baggage_x_stored + 4.5 then -- once the human handler as reached the cart, switch direction for the human
							baggage4_angle = -90
						elseif walking_direction == "deboarding" and baggage_x4 > 14 then -- once the human handler as reached the cart, switch direction for the human
							baggage4_angle = -90
						end
					end
				end
		  end
		end


	end

	baggage_heading_swap = 0
	local left_ULD_heading = math.random(-3,3)
	function service_object_physics_ULD()

		local baggage_vertical_step = 0 --.0003
		local baggage_vertical_step_down = 0 --.0004

		if CargoULD_chg == true then
			if show_CargoULD and show_ULDLoader and uld_x ~= nil and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
				load_ULD()
			else
				CargoULD_chg,Baggage_instance[5],rampservicerefBaggage5 = common_unload("CargoULD",Baggage_instance[5],rampservicerefBaggage5)
			end

		  if show_Bus and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") and uld_x ~= nil and uld_x > -2  and Baggage_instance[5] ~= nil  then
			if uld_z == nil then uld_z = ULDLoaderFwdPositionFactor*BeltLoaderFwdPosition end
				CargoULD_chg = draw_static_object(uld_x,uld_z,left_ULD_heading + baggage_heading_swap,Baggage_instance[5],"CargoULD")

				if CargoULD_chg == false and show_Bus then
					CargoULD_chg = true -- draw only once
				end

				if walking_direction == "boarding" then
					--~ uld_x = uld_x - 0.0025	 -- animate the baggage
					if ((string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or CargoDeck_ULDLoaderObject == "low_variant") then
						uld_x = uld_x - 0.0050
					else
						uld_x = uld_x - 0.0025
					end

					-- when using a low ULD Loader, we cannot start the cargo pallet far away from the fuselage, because it would be on the empty.
					if ((string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or
					CargoDeck_ULDLoaderObject == "low_variant") and uld_x > 4 then
						uld_x = 4
					end
					if string.find(PLANE_ICAO,"B73") and uld_x < 4 then
						uld_x 	= uld_x_stored - 0.8
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
					elseif BeltLoaderFwdPosition >= ULDthresholdx and uld_x < 4 then
						uld_x 	= uld_x_stored - 0.8
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-3,3)
					elseif uld_x < 0 then
						uld_x 	= uld_x_stored - 0.8
						-- when using a low ULD Loader, we cannot REstart the cargo pallet far away from the fuselage
						if ((string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or CargoDeck_ULDLoaderObject == "low_variant") and uld_x > 4 then
							uld_x = 4.25
						end
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-3,3)
					end -- once the baggage as reached the fuselage, restart
				else -- deboarding situation
					uld_x = uld_x + 0.0025 -- animate the baggage --
					if (PLANE_ICAO == "B722" or string.find(PLANE_ICAO,"B73")) and uld_x >= uld_x_stored - 0.75 then
						uld_x = 4 --
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-3,3)
					elseif BeltLoaderFwdPosition >= ULDthresholdx  and uld_x >= uld_x_stored - 0.75 then --
						uld_x = 4 --
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-3,3)

					-- when using a low ULD Loader, we cannot move the cargo pallet far away from the fuselage
					elseif ((string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or CargoDeck_ULDLoaderObject == "low_variant") and uld_x > 4.5 then
						uld_x = 0.5
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-5,5)
					elseif uld_x >= uld_x_stored - 0.75 then --
						uld_x = 0 --
						if baggage_heading_swap == 0 then baggage_heading_swap = 180
						elseif baggage_heading_swap== 180 then baggage_heading_swap = 0 end
						left_ULD_heading = math.random(-3,3)
					end -- once the baggage as reached the fuselage, restart
				end
		  end
		end
	end


	function service_object_physics_AllDeicing()
		if Deice_chg == true then
		  if show_Deice then
			  load_Deice()
		  else
			 -- unload_Deice()
			Deice_chg,Deice_instance[0],rampserviceref100 = common_unload("Deice",Deice_instance[0],rampserviceref100)
			Deice_chg,Deice_instance[1],rampserviceref101 = common_unload("Deice1",Deice_instance[1],rampserviceref101)
			Deice_chg,Deice_instance[2],rampserviceref102 = common_unload("Deice2",Deice_instance[2],rampserviceref102)
		  end
		  if Deice_instance[0] ~= nil then
				Deice_chg = draw_static_object(-15,-1.9*math.abs(BeltLoaderFwdPosition),-30,Deice_instance[0],"Deice")
				-- for some big planes, put the second deice truck
				if (BeltLoaderFwdPosition > 5 or PLANE_ICAO == "CL60") and show_Deice and Deice_instance[1] ~= nil then
					draw_static_object(targetDoorX+18,-1.6*math.abs(BeltLoaderFwdPosition),-30,Deice_instance[1],"Deice1")
				end
				if Dayonly_deicing_truck_01 ~= nil and BeltLoaderFwdPosition > ULDthresholdx and show_Deice and Deice_instance[2] ~= nil then
					draw_static_object(targetDoorX+43,1.2*math.abs(BeltLoaderFwdPosition),145,Deice_instance[2],"Deice2")
				end
		  end
		end
	end


	function service_object_physics_EnvLight()
		if Light_chg == true then
		  if show_Light then
			  load_Light()
		  else
			Light_chg,Light_instance[0],rampserviceref200 = common_unload("Light",Light_instance[0],rampserviceref200)
			 --unload_Light()
		  end
		  if Light_instance[0] ~= nil then
			local x = -0
			local z = gear1Z + 0.7*gear1Z
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
			Light_chg = draw_static_object(x,z,180,Light_instance[0],"Light")
		  end
		end
	end


	function CockpitLight_physics()
		if show_CockpitLight and (math.abs(sges_gs_gnd_spd[0]) >= 1 or Go_PB) then
			show_CockpitLight = false
			CockpitLight_chg = true
		end
		if CockpitLight_chg == true  then
			  if show_CockpitLight then
				  load_CockpitLight()
				  if CockpitLight_instance[0] ~= nil then
					local x =  0 -- -1* get("sim/graphics/view/pilots_head_x") -- lateralness
					local z =  -1 * get("sim/graphics/view/pilots_head_z") -- forwardness
					CockpitLight_chg = draw_static_object(x,z,0,CockpitLight_instance[0],"CockpitLight")
				  end
			  else
				CockpitLight_chg,CockpitLight_instance[0],rampservicerefCockpitLight = common_unload("CockpitLight",CockpitLight_instance[0],rampservicerefCockpitLight)
			  end
		end
	end


	function service_object_physics_stairsXPJ()
		if StairsXPJ_chg == true then

			if stairs_authorized and sges_openSAM ~= nil and sges_openSAM[0] == 2 then show_StairsXPJ = false option_StairsXPJ_override = false end -- patch to prevent stairs with an Open SAM jetway when stairs are authorized

		  if show_StairsXPJ and (stairs_authorized or option_StairsXPJ_override) then
			  load_StairsXPJ()
		  else
			--unload_StairsXPJ()
			StairsXPJ_chg,StairsXPJ_instance[0],rampserviceref300 = common_unload("StairsXPJ",StairsXPJ_instance[0],rampserviceref300)
			StairsXPJ_chg,StairsXPJ_instance[1],rampserviceref301 = common_unload("StairsXPJ1",StairsXPJ_instance[1],rampserviceref301)
		  end
		  if StairsXPJ_instance[0] ~= nil and StairsXPJ_instance[1] ~= nil then
			  draw_StairsXPJ()
		  end
		end
	end

	function service_object_physics_stairsXPJ2()
		if StairsXPJ2_chg == true then
		  if show_StairsXPJ2 then
			  load_StairsXPJ2()
		  else
			--unload_StairsXPJ2()
			StairsXPJ2_chg,StairsXPJ2_instance[0],rampserviceref302 = common_unload("StairsXPJ2",StairsXPJ2_instance[0],rampserviceref302)
			StairsXPJ2_chg,StairsXPJ2_instance[1],rampserviceref303 = common_unload("StairsXPJ21",StairsXPJ2_instance[1],rampserviceref303)
				-- restore position for passenger deplacement back to forward stair if it is shown
				if show_StairsXPJ and StairsXPJ_instance[0] ~= nil then
					StairFinalY = StairFinalY_stairIII
					StairFinalH = StairFinalH_stairIII
					StairFinalX = StairFinalX_stairIII
					InitialPaxHeight = InitialPaxHeight_stairIII
					BoardStairsXPJ = true
					BoardStairsXPJ2 = false
				end
		  end
		  if StairsXPJ2_instance[0] ~= nil and StairsXPJ2_instance[1] ~= nil then
			  draw_StairsXPJ2()
		  end
		end
	end

	function service_object_physics_stairsXPJ3()
		if StairsXPJ3_chg == true then
		  if show_StairsXPJ3 then
			if sign3 == nil then
				_,Cones_instance[0],rampserviceref0 = common_unload("Cones",Cones_instance[0],rampserviceref0) -- remove engine left conus, to make rooms for stairs
			elseif sign3 > 0 then -- when stairs is on the left hand sie
				_,Cones_instance[0],rampserviceref0 = common_unload("Cones",Cones_instance[0],rampserviceref0) -- remove engine left conus, to make rooms for stairs
			else -- when stairs is on the left hand side
				_,Cones_instance[2],rampserviceref010 = common_unload("Cones",Cones_instance[2],rampserviceref010) -- remove engine right conus, to make rooms for stairs
			end

			load_StairsXPJ3()

		  else
			StairsXPJ3_chg,StairsXPJ3_instance[0],rampserviceref302 = common_unload("StairsXPJ3",StairsXPJ3_instance[0],rampserviceref304)
			StairsXPJ3_chg,StairsXPJ3_instance[1],rampserviceref303 = common_unload("StairsXPJ31",StairsXPJ3_instance[1],rampserviceref305)
			Cones_chg = true -- put back cones to their anterior status
		  end
		  if StairsXPJ3_instance[0] ~= nil and StairsXPJ3_instance[1] ~= nil then
			  draw_StairsXPJ3()
		  end
		end
	end


	function service_object_physics_Ponev()
	  if Ponev_chg == true then
		  if show_Ponev then
			  Load_Cami_de_Bellis_Objects()
			  load_Ponev()
		  else
				Ponev_chg,Ponev_instance[0],rampservicerefPonev = common_unload("Ponev",Ponev_instance[0],rampservicerefPonev)
		  end
		  if Ponev_instance[0] ~= nil then
			  draw_Ponev()
		  end
	  end
	end


	function service_object_physics_ASU()
		if ASU_chg then
		  if show_ASU or show_ACU then
			  load_ASU_ACU()
		  else
			ASU_chg,ASU_ACU_instance[0],rampservicerefASU_ACU = common_unload("ASU",ASU_ACU_instance[0],rampservicerefASU_ACU)
			ASU_chg,ASU_ACU_instance[1],rampservicerefASU_ACU1 = common_unload("duct",ASU_ACU_instance[1],rampservicerefASU_ACU1)
			--unload_ASU_ACU()
		  end
		-- POSITIVE LEFT < x > NEGATIVE RIGHT
		-- POSITIVE FWD < z > NEGATIVE AFT
		  if ASU_ACU_instance[0] ~= nil then
			if airstart_unit_factor == nil then airstart_unit_factor = 0 end
			local x = 0
			local z = airstart_unit_factor-6.4
			if PLANE_ICAO == "A346" then
				x = 10
			elseif PLANE_ICAO == "B720" or PLANE_ICAO == "B707" then
				z = airstart_unit_factor-2.4
			end

			if Prefilled_ASU_ACU == User_Custom_Prefilled_ASUObject then
				x = x + 9
				if BeltLoaderFwdPosition > ULDthresholdx then x = x + 3 end -- for large airliners, make it farther
				z = z - 5.85
			end

			ASU_chg = draw_static_object(x,z,1,ASU_ACU_instance[0],"ASU_ACU")
			if Prefilled_ASU_duct ~= nil then ASU_chg = draw_static_object(x,z,1,ASU_ACU_instance[1],"ASU_ACU") end
		  end
		end
	end

	function service_object_physicsForklift()
		if Forklift_chg == true then
		  if show_Forklift then
			  load_Forklift()
		  else
			Forklift_chg,Forklift_instance[0],rampservicerefForklift = common_unload("Forklift",Forklift_instance[0],rampservicerefForklift)
			 --unload_Light()
		  end
		  if Forklift_instance[0] ~= nil then
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT

			if Prefilled_ForkliftObject == 	Prefilled_ULDLoaderObject or Prefilled_ForkliftObject == Prefilled_CargoDeck_ULDLoaderObject then
				if PLANE_ICAO == "B742" then
					Forklift_chg = draw_static_object(0,1.63 * gear1Z,181,Forklift_instance[0],"Forklift") -- Beluga
				elseif PLANE_ICAO == "A3ST" then
					Forklift_chg = draw_static_object(0,2.1 * gear1Z,179,Forklift_instance[0],"Forklift") -- Beluga
				else
					Forklift_chg = draw_static_object(0,1.35 * gear1Z,179,Forklift_instance[0],"Forklift") -- B748
				end
			elseif SGES_BushMode and IsXPlane12 then
				Forklift_chg = draw_static_object(5,-1.85 * gear1Z,70,Forklift_instance[0],"Forklift") -- checked with Thranda Cessna 337
			else
				Forklift_chg = draw_static_object(0,-1.75 * gear1Z,350,Forklift_instance[0],"Forklift") -- checked with default Laminar C-130
			end
		  end
		end
	end

	if sges_ahr == 1 then
		if config_helper ~= nil then config_helper = false end
		function service_object_physicsAAR()
			if (math.abs(sges_gs_gnd_spd[0]) >= 0 or config_helper) and show_AAR then
				AAR_chg = true               -- dynamic vehicle
			end
			if delta_refuel_x ~= nil then
				if math.abs(delta_refuel_x) > 8000 or math.abs(delta_refuel_z) > 8000 then -- or sges_gs_ias_spd[0] < 105 or sges_gs_ias_spd[0] > 595 then
					-- to avoid an FMOD sound error, kill the refuler when it is becomming to be very far
					show_AAR = false
					play_sound(AAR_Clear_to_disco_sound)
				end
			end
			if AAR_chg == true then
				if show_AAR then
					if Prefilled_AAR_object == nil then --safety
						Prefilled_AAR_object =  SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/In_flight_refueler/Refueler.obj"
						print("Switching to default AAR aircraft. Simple_Ground_Equipment_and_Services/In_flight_refueler/Refueler.obj")
					end

					if sges_tank_to_refuel > 9 then sges_tank_to_refuel = 9 end -- dataref is max = 9
					if sges_tank_full_flag == nil then
						sges_tank_full_flag = {}
							--declaring tank as not full
						local i = 0
						for i=0,sges_tank_to_refuel-1 do
							sges_tank_full_flag[i] = false
						end
						--declaring unused tank as full = true
						local o=0
						for o=sges_tank_to_refuel,8 do
							sges_tank_full_flag[o] = true
						end
						if not config_helper then play_sound(AAR_Clear_contact_sound) end
					end
					if captured_tanker == nil then captured_tanker = false end
					load_AAR()
				else
					AAR_chg,AAR_instance[0],rampservicerefAAR = common_unload("AAR",AAR_instance[0],rampservicerefAAR)
					delta_RefuelerX_stored = nil
					delta_RefuelerZ_stored = nil
					saved_refuel_alt = nil
					SplaceToBeX = nil
					Sreference_heading = nil
					Sreference_x = nil
					Sreference_z = nil
					delta_refuel_altitude = nil
					delta_refuel_x = nil
					delta_refuel_z = nil
					frame = nil
					sges_plane17_nav_lights_on = nil
					sges_plane18_nav_lights_on = nil
					sges_plane19_nav_lights_on = nil
					sges_framerate_period = nil
					sges_tank_ = nil
					sges_tank_full_flag = nil
					sges_tank_to_refuel = get("sim/aircraft/overflow/acf_num_tanks")
					sges_tank_to_refuel = user_sges_tank_to_refuel
					captured_tanker = false
					--~ play_sound(AAR_Clear_to_disco_sound)
				end
				if AAR_instance[0] ~= nil then
					if sges_refuel_port_lateral == nil then sges_refuel_port_lateral = 0 end
					if sges_refuel_port_longitudinal == nil then sges_refuel_port_longitudinal = 20 end
					AAR_chg = draw_AAR_object(sges_refuel_port_lateral,sges_refuel_port_longitudinal,0,AAR_instance[0],"AAR")
				end
			end
		end
		do_every_frame("if (SGES_XPlaneIsPaused == 0 and (sges_gs_ias_spd[0] >= 100) and sges_gs_ias_spd[0] < 600) or config_helper then service_object_physicsAAR() end")
	end

	-- ////////////////////////////////// GROUND SERVICE /////////////////////////////////////////////////////////



	--print("[Ground Equipment " .. version_text_SGES .. "] Preparing GROUNDSERVICE")
	function load_Cones()
		if Cones_instance[0] == nil then
		-- note that when there is only one instance, the instance array index must be 0, NOT 1.
		-- otherwise, xplane will crash --> hey that looks pretty normal since 0 is the first case. GF
			--print("load_rampservice")
			--- GROUND HANDLING

			   XPLM.XPLMLoadObjectAsync(Prefilled_ConeObject,
						function(inObject, inRefcon)
						Cones_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref0 = inObject
						end,
						inRefcon )
		end
		if Cones_instance[1] == nil then -- left wing cone
				local ConeObject1 = Prefilled_ConeObject -- default proposition, a single cone object provided by X-Plane

				-- let us see if we can now update ConeObject1 with a wider cones set --

				-- probing terrain in front and behind the cones to see if the terrain is flat enough to receive the wide set of cones
				-- X is controlling left / right axis
				-- Z is controllong forward / aft axis
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, 5, sges_gs_plane_head[0] )
				local y_forward,_ = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, -5, sges_gs_plane_head[0] )
				local y_aft,_ 	= probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				local ground_level_difference = math.abs(y_forward-y_aft)*100


				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 5, -3, sges_gs_plane_head[0] )
				local y_R,_ = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, -3, sges_gs_plane_head[0] )
				local y_L,_ 	= probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				local ground_level_difference_LR = math.abs(y_R-y_L)*100

				-- can be a set of three cones linked by a strip
				if (
				   string.match(PLANE_ICAO,"B7")
				or string.match(PLANE_ICAO,"A3") -- Airbus
				or string.match(PLANE_ICAO,"A2") -- Airbus
				or string.match(PLANE_ICAO,"B4") -- BAe 146
				or string.match(PLANE_ICAO,"RJ") -- avro RJ
				or string.match(PLANE_ICAO,"E1") -- embraers
				or string.match(PLANE_ICAO,"MD")
				or string.match(PLANE_ICAO,"CL")
				or string.match(PLANE_ICAO,"CR")
				or string.match(PLANE_ICAO,"DH")
				or string.match(PLANE_ICAO,"EVIC")
				or string.match(PLANE_ICAO,"BN")
				or string.match(PLANE_ICAO,"ch47")
				or string.match(PLANE_ICAO,"ALIA")
				or string.match(PLANE_ICAO,"VULC")
				or string.match(PLANE_ICAO,"CL650") --CL650
				)
				--and IsPassengerPlane == 1 -- only pax planes -- removed because the ground flat is already a big constraint
				-- calibration at LPPS apron (light slope), OJAI (flat), GMMX is decisive
				-- as the object is wide, we only display it if the terrain if flat in the wing area, we have to avoid slopes.
				and ground_level_difference < 11 	-- takes into account the pitch of the terrain slope in the acft axis
				and ground_level_difference_LR < 11 -- takes into account the roll of the terrain slope in the acft axis
				then

					ConeObject1 = Linked_cones
					--~ print("[Ground Equipment " .. version_text_SGES .. "] OGL_plane_pitch " .. math.abs(OGL_plane_pitch) .. "°. OGL_plane_roll " .. math.abs(OGL_plane_roll) .. "°. The wide set of cones can be used.")
					--print("[Ground Equipment " .. version_text_SGES .. "] ground_level_difference= " .. ground_level_difference .. ".")
					--print("[Ground Equipment " .. version_text_SGES .. "] ground_level_difference_LR= " .. ground_level_difference_LR .. ". The wide set of cones with a fabric strip is used.")
					--~ print("[Ground Equipment " .. version_text_SGES .. "] The enhanced set of cones with a fabric strip is used.")
				--~ else -- (COMMENTED OUT TO SAVE SOME CONSOLE WRITTING - JANUARY 2025)
					--~ print("[Ground Equipment " .. version_text_SGES .. "] OGL_plane_pitch " .. math.abs(OGL_plane_pitch) .. "°. OGL_plane_roll " .. math.abs(OGL_plane_roll) .. "°. The wide set of cones cannot be used.")
					--~ print(string.format("[Ground Equipment %s] ground_level_difference= %.2f.", version_text_SGES, ground_level_difference))
					--~ print(string.format("[Ground Equipment %s] ground_level_difference_LR = %.2f (threshold is 11). The enhanced cones won't be used because of slope and/or aircraft type. (It's fine).", version_text_SGES, ground_level_difference_LR))
				end

				-- We load the selected cones, by default it stays the single Prefilled_ConeObject :
			   XPLM.XPLMLoadObjectAsync(ConeObject1,
						function(inObject, inRefcon)
						Cones_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref3 = inObject
						end,
						inRefcon )
		end

		if Cones_instance[2] == nil then
			   XPLM.XPLMLoadObjectAsync(Prefilled_ConeObject,
						function(inObject, inRefcon)
						Cones_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref010 = inObject
						end,
						inRefcon )
		end

		if Cones_instance[3] == nil then --15-7-23
			   XPLM.XPLMLoadObjectAsync(Prefilled_BollardObject,
						function(inObject, inRefcon)
						Cones_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefBo = inObject
						end,
						inRefcon )
		end

		if Cones_instance[4] == nil then --15-7-23

			if (math.abs(BeltLoaderFwdPosition) <= 4 or BeltLoaderFwdPosition == -5) and IsXPlane12 and military ~= 1 and military_default ~= 1 and not SGES_BushMode then
			   XPLM.XPLMLoadObjectAsync(XPlane12_Common_Equipment_directory   .. "fire_extinguisher_1.obj",
						function(inObject, inRefcon)
						Cones_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefBo4 = inObject
						end,
						inRefcon )
			else
			   XPLM.XPLMLoadObjectAsync(Prefilled_BollardObject,
						function(inObject, inRefcon)
						Cones_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefBo4 = inObject
						end,
						inRefcon )
			end
		end

	end

	function load_GPU()

		if GPU_instance[0] == nil then

			GPUObject = Prefilled_GPUObject
			if IsXPlane12 and math.abs(BeltLoaderFwdPosition) <= 4 or PLANE_ICAO == "DH8D" then GPUObject = Prefilled_GA_GPUObject end

			if UseXplaneDefaultObject == false and (military == 1 or military_default == 1) and User_Custom_Prefilled_MilGPUObject ~= nil then
				GPUObject = User_Custom_Prefilled_MilGPUObject
			end

			--------------------- aircraft specifics ------------------------
			if string.match(AIRCRAFT_PATH,"146") and XPLMFindDataRef("thranda/electrical/ExtPwrGPUAvailable") ~= nil then set("thranda/electrical/ExtPwrGPUAvailable",1) end
			if AIRCRAFT_FILENAME == "Bell412.acf" then command_once("412/buttons/GPU_on")  command_once("412/buttons/remove_before_flight_off") end
			if AIRCRAFT_FILENAME == "CH47.acf" then set("ch47/other/GPU",1) set("ch47/weapons/remove_before_flight",0) end
			if AIRCRAFT_FILENAME == "AW109SP.acf" then set("sim/cockpit/electrical/gpu_on",1) end
			if (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko") and XPLMFindDataRef("XCrafts/other/GPU") ~= nil then set("XCrafts/other/GPU",0) end -- zero, for ON
			if (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko") then
				set("XCrafts/other/remove_before_flight",1) -- on for OFF
			end
			--------------------- aircraft specifics ------------------------

			if not ((PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko")) then
			-- load the GPU 3D unit, except for E-Jets which already have a 3D object and we don't want two objects
			   XPLM.XPLMLoadObjectAsync(GPUObject,
						function(inObject, inRefcon)
							GPU_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref1 = inObject
						end,
						inRefcon )
			end
		end
	end

	function load_FUEL()
		if FUEL_instance[0] == nil and fuel_show_only_once then

			if IsXPlane12 and show_Pump then-- fuel pump choice activated and forced
				Prefilled_FuelObject = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj"
				-- watch your steps ! in service_object_physics_Fuel()
			elseif PLANE_ICAO == "SR71" then -- special JP-7 fuel for the SR-71 means a special truck everywhere :-)
				Prefilled_FuelObject = User_Custom_Prefilled_FuelObject_USA_2
			else
				math.randomseed(os.time())
				randomView = math.random()
				if randomView > 0.4 then
					Prefilled_FuelObject = Prefilled_FuelObject_option1
					-- but update that to the USA cistern truck as required :
					if sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1 then
						Prefilled_FuelObject = User_Custom_Prefilled_FuelObject_USA_2
						print("[Ground Equipment " .. version_text_SGES .. "] Fuel truck for the USA.")

						------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
						if (IsXPlane1214 and Dayonly_truck_tanker_01 ~= nil) -- make safety code verifications and version check
							and sges_sun_pitch[0] > 5 and UseXplane1214DefaultObject  -- restrict replacement by an X-Plane 12.1.4 vehicule to day
							and math.abs(BeltLoaderFwdPosition) > ULDthresholdx -- limit the big fuel truck to big aircraft
							then
								-- Native X-Plane 12.1.4 day hours Common Equipment Vehicle (has no lights ! Use day only !)
								Prefilled_FuelObject = Dayonly_truck_tanker_01
								print("[Ground Equipment " .. version_text_SGES .. "] Large aircraft + In the USA + X-Plane 12.1.4+ : changing the EXXON fuel truck for an X-Plane 12.1.4+ truck tank.")
						end
						------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
					end
				else
					Prefilled_FuelObject = Prefilled_FuelObject_option2
					-- but update that to the USA cistern truck as required :
					if sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1 and math.abs(BeltLoaderFwdPosition) > 6 then
						Prefilled_FuelObject = User_Custom_Prefilled_FuelObject_USA
						print("[Ground Equipment " .. version_text_SGES .. "] Fuel truck for the USA and airliners.")
					end
				end
				if military == 1 and XTrident_Chinook_Directory ~= nil then Prefilled_FuelObject = SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/misc/M978.obj" end
				if military_default == 1 and User_Custom_Prefilled_FuelObject_Mil ~= nil then Prefilled_FuelObject = User_Custom_Prefilled_FuelObject_Mil end
				if SGES_BushMode and IsXPlane12 and (military == 1 or military_default == 1) then

					if randomView > 0.20 then Prefilled_FuelObject = Prefilled_FuelObject_option1 else
						Prefilled_FuelObject_option2=XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"
						Prefilled_FuelObject = Prefilled_FuelObject_option2
					end
				end


			end



			XPLM.XPLMLoadObjectAsync(Prefilled_FuelObject,
					function(inObject, inRefcon)
						FUEL_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref2 = inObject
					end,
					inRefcon )
			fuel_show_only_once = false
		end
	end

	function load_Cleaning()
		if Cleaning_instance[0] == nil and Cleaning_show_only_once then
			   --print("[Ground Equipment " .. version_text_SGES .. "] 4 load_rampservice Prefilled_CleaningTruckObject")


			if (military_default == 1 or string.find(PLANE_ICAO,"F")) and sges_airport_ID ~= nil and string.find(sges_airport_ID,"LG") then
				Prefilled_CleaningTruckObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "Cleaning/Van_Mil_b.obj"
			elseif military_default == 1 then
				Prefilled_CleaningTruckObject = Prefilled_Mil_Van
				if SecondStairsFwdPosition <= 4 and SGES_BushMode and IsXPlane12 then
					Prefilled_CleaningTruckObject = Prefilled_Peugeot308_black_Object
					------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
					if (IsXPlane1214 and Dayonly_airsideops_SUV_white ~= nil) -- make safety code verifications and version check
						--and sges_sun_pitch[0] > 5 -- restrict replacement by an X-Plane 12.1.4 vehicule to day
						and string.find(Prefilled_CleaningTruckObject,"308_XPJavelin") -- this check restrict the replacement only when using this original library object, like in normal, civilian configuration and without user mods.
						then
							-- Native X-Plane 12.1.4 day hours Common Equipment Vehicle (has no lights ! Use day only !)
							Prefilled_CleaningTruckObject = Dayonly_airsideops_SUV_white
						   XPLM.XPLMLoadObjectAsync(SUV_light_addonObject,
							function(inObject, inRefcon)
								Cleaning_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampserviceref4L = inObject
							end,
							inRefcon )
							--~ print("[Ground Equipment " .. version_text_SGES .. "] Bush mode + Military mode + X-Plane 12.1.4+ : changing the Peugeot car for an X-Plane 12.1.4+ SUV.")
					end
					------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
				end
			elseif military == 1 and XTrident_Chinook_Directory ~= nil then Prefilled_CleaningTruckObject = SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj"
			elseif SGES_BushMode and IsXPlane12 then
				Prefilled_CleaningTruckObject = XPlane12_BushObjects_directory   .. "DkGrpMed1.obj"
			else
				Prefilled_CleaningTruckObject = Original_CleaningTruckObject
				------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
				if (IsXPlane1214 and Dayonly_airsideops_van_white ~= nil) -- make safety code verifications and version check
					--and sges_sun_pitch[0] > 5 -- restrict replacement by an X-Plane 12.1.4 vehicule to day
					and UseXplane1214DefaultObject
					and not SGES_BushMode -- restrict it to normal mode
					and ( string.find(Prefilled_CleaningTruckObject,"Van_White") or  string.find(Prefilled_CleaningTruckObject,"airsideops")) -- this check restrict the replacement only when using this original library object, like in normal, civilian configuration and without user mods.
					then
						--~ -- Native X-Plane 12.1.4 day hours Common Equipment Vehicle (has no lights ! Use day only !)
						Prefilled_CleaningTruckObject = Dayonly_airsideops_van_white
						if IsPassengerPlane == 0 then Prefilled_CleaningTruckObject = Dayonly_airsideops_van_yellow end -- diversity + no true cleaning with a cargo plane !
						if sges_airport_ID ~= nil and string.find(sges_airport_ID,"E") ~= nil and string.find(sges_airport_ID,"E") == 1 then

							randomView = math.random()
							if randomView > 0.30 then
								Prefilled_CleaningTruckObject = Dayonly_airsideops_van_checkerboard
							else
								Prefilled_CleaningTruckObject = Dayonly_airsideops_SUV_checkerboard
							end


						elseif ((sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1)		-- USA
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1))	-- Canada
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"LLBG") ~= nil )	-- LLBG (like in the US)
						 then
							Prefilled_CleaningTruckObject = Dayonly_airsideops_pickup_white
						end
						local Night_lighting_for_xplane_trucks = Van_light_addonObject
						if string.find(Prefilled_CleaningTruckObject,"airsideops_pickup") then
							randomView = math.random()
							if randomView <= 0.20 then
								Night_lighting_for_xplane_trucks = Pickup_light_flashing_lights_addonObject
							else
								Night_lighting_for_xplane_trucks = Pickup_light_addonObject
							end
						end
						if string.find(Prefilled_CleaningTruckObject,"airsideops_vw2_01") then
							Night_lighting_for_xplane_trucks = SUV_light_flashing_lights_addonObject
						end


					   XPLM.XPLMLoadObjectAsync(Night_lighting_for_xplane_trucks,
						function(inObject, inRefcon)
							Cleaning_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref4L = inObject
						end,
						inRefcon )

						--~ print("[Ground Equipment " .. version_text_SGES .. "] Regular civilian mode + X-Plane 12.1.4+ : changing the cleaning van for an X-Plane 12.1.4+ van.")
				end
				------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
			end
			if Clairmarais_Aerodrome_directory ~= nil then Clairmarais_Aerodrome_lib() end

			   --XPLM.XPLMLoadObjectAsync( Custom_Scenery_root2 .. "tech_2/gazel.obj",
			   XPLM.XPLMLoadObjectAsync(Prefilled_CleaningTruckObject,
						function(inObject, inRefcon)
							Cleaning_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref4 = inObject
						end,
						inRefcon )

			 -- Wherever I make a change here, that will then crash XpLane then. To repair, empty function draw_rampservice() and repopulate
			 Cleaning_show_only_once = false
		end
	end
	function load_BeltLoader()
		if BeltLoader_instance[0] == nil and BeltLoader_show_only_once then
		-- note that when there is only one instance, the instance array index must be 0, NOT 1.
		-- otherwise, xplane will crash --> hey that looks pretty normal since 0 is the first case. GF

			-- B742 option to board via the Cargo door (White House)  (E4B modification)
		   if PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" and military_default == 1 then
				print("[Ground Equipment " .. version_text_SGES .. "] This B747 is for the White House : stairs to the right cargo hole.")
				Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject
				Prefilled_BeltLoaderObject = Prefilled_StairsXPJObject
		   elseif BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
			-- in case of very large aircraft, we don't want a belt loader, rather an ULD loader
				Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject
				Prefilled_BeltLoaderObject = Prefilled_ULDLoaderObject
		   elseif ((PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and IsPassengerPlane == 0) or
		   ((PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and User_prefers_containerized_freight) then
				Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject
				Prefilled_BeltLoaderObject = Prefilled_ULDLoaderObject
		   elseif Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and IsPassengerPlane == 1 and not User_prefers_containerized_freight and
		   ((PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N")) then
				Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
				Stored_Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
		   else Prefilled_BeltLoaderObject = Stored_Prefilled_BeltLoaderObject end

		   --print("[Ground Equipment " .. version_text_SGES .. "] 5 load_rampserviceD _loader01")
		   XPLM.XPLMLoadObjectAsync(Prefilled_BeltLoaderObject,
					function(inObject, inRefcon)
						BeltLoader_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref5 = inObject
					end,
					inRefcon )

			BeltLoader_show_only_once = false
		end
	end

	function load_RearBeltLoader()
		if BeltLoader_instance[2] == nil and RearBeltLoader_show_only_once then
			-- in case of very large aircraft, we don't want a belt loader, rather an ULD loader
		   if BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
				Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject
				Prefilled_BeltLoaderObject = Prefilled_ULDLoaderObject
		   elseif ((PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and IsPassengerPlane == 0) or
		   ((PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and User_prefers_containerized_freight) then
				Stored_Prefilled_BeltLoaderObject = Prefilled_BeltLoaderObject
				Prefilled_BeltLoaderObject = Prefilled_ULDLoaderObject
		   elseif Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and IsPassengerPlane == 1 and not User_prefers_containerized_freight and
		   ((PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N")) then
				Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
				Stored_Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
		   else Prefilled_BeltLoaderObject = Stored_Prefilled_BeltLoaderObject end
			--print("rearbeltloader")
		   XPLM.XPLMLoadObjectAsync(Prefilled_BeltLoaderObject,
					function(inObject, inRefcon)
						BeltLoader_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefRBL = inObject
					end,
					inRefcon )
			RearBeltLoader_show_only_once = false
		end
	end

	function load_Cart()
			   --print("[Ground Equipment " .. version_text_SGES .. "] Do we load the cart ?")
		if BeltLoader_instance[1] == nil and cart_show_only_once then
			   --print("[Ground Equipment " .. version_text_SGES .. "] 9 load_rampserviceD _cart")
			   -- selection of equipment depending on aircraft size


				local local_time_in_simulator = get("sim/cockpit2/clock_timer/local_time_hours")

				CartObject = Prefilled_CartObject

			   if BeltLoaderFwdPosition <= 7 then
				if IsXPlane12 then
					-- if it is X-Plane 12, we can use the new luggage train also to bring diversity
					-- the X-Plane cart hasn't lights, so restrict that to the day
					randomView = math.random()
					if randomView <= 0.25 and (local_time_in_simulator >= 7 and local_time_in_simulator < 19) then
						CartObject = XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str2.obj"
					else
						CartObject = Prefilled_2CartObject
					end
				else
					CartObject = Prefilled_2CartObject
				end

				-- LD3 train instead, for cargo ops :
			   elseif BeltLoaderFwdPosition >= ULDthresholdx or PLANE_ICAO == "IL96" or PLANE_ICAO == "A306" or PLANE_ICAO == "A3ST" or PLANE_ICAO == "A310" then
				CartObject = Prefilled_LD3CartObject

			   elseif PLANE_ICAO == "B720" or PLANE_ICAO == "B707" then
				CartObject = Prefilled_2CartObject

			   elseif BeltLoaderFwdPosition > 13 then -- not seen if ULDthresholdx = 13 :-)
				if IsXPlane12 then
					-- if it is X-Plane 12, we can use the new luggage train also to bring diversity
					randomView = math.random()
					if randomView <= 0.25 and (local_time_in_simulator >= 7 and local_time_in_simulator < 19) then
						CartObject = XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str4.obj"
					else
						CartObject = Prefilled_5CartObject
					end
				else CartObject = Prefilled_5CartObject end

			   elseif BeltLoaderFwdPosition > 10 then
				if IsXPlane12 then
					-- if it is X-Plane 12, we can use the new luggage train also to bring diversity
					randomView = math.random()
					if randomView <= 0.25 and (local_time_in_simulator >= 7 and local_time_in_simulator < 19) then
						CartObject = XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str4.obj"
					else
						CartObject = Prefilled_5CartObject
					end
				else CartObject = Prefilled_5CartObject end
			   end

			   -- in case this is an A321 P2F/PCF/SDF/CCF
				if ((PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and IsPassengerPlane == 0) or ((PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and User_prefers_containerized_freight) then
				--CartObject = XPlane_Ramp_Equipment_directory   .. "Cargo_Dolly_1.obj"
				   -- Cargo_Dolly_1
				   CartObject = Prefilled_LD3CartObject
			   end
				if wetness == 1 then
					CartObject = Prefilled_CanoeObject
				end

			   XPLM.XPLMLoadObjectAsync(CartObject,
						function(inObject, inRefcon)
							BeltLoader_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref9 = inObject
						end,
						inRefcon )
				cart_show_only_once = false


		end
	end

	function load_Stairs()
		if Stairs_instance[0] == nil and stairs_LR_show_only_once then
			   XPLM.XPLMLoadObjectAsync(Prefilled_StairsObject,
						function(inObject, inRefcon)
							Stairs_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref6 = inObject
						end,
						inRefcon )
		stairs_LR_show_only_once = false
		end
	end


	function load_Bus()
		if Bus_instance[0] == nil and bus_show_only_once then
			math.randomseed(os.time())
			randomView = math.random()
			if SGES_date_in_simulator ~= nil and
			((SGES_date_in_simulator[0] >= 350 and SGES_date_in_simulator[0] <= 360) or
			(SGES_date_in_simulator[0] >= 0 and SGES_date_in_simulator[0] <= 2))
			and string.find(Prefilled_BusObject_option1,"bus") and string.find(Prefilled_BusObject_option2,"bus")
			then
				-- Winter bus from 17th of december to 26th of december
				local MisterX_Lib =   SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"
				Prefilled_BusObject = MisterX_Lib   .. "Cobus/Cobus_2700_doublet_red.obj"
			elseif (IsXPlane1212 and Dayonly_BusObject_option ~= nil)
			and sges_sun_pitch[0] > -45
			and UseXplane1214DefaultObject
			and not SGES_BushMode
			and string.find(Prefilled_BusObject_option1,"bus") and string.find(Prefilled_BusObject_option2,"bus")
			then
				-- Native X-Plane day hours bus
				Prefilled_BusObject = Dayonly_BusObject_option
				-- but
				--for bigger airplanes when dual bus are allowed, still allow dual bus :
				if Prefilled_BusObject_option1 == Prefilled_BusObject_doublet then
					if randomView > 0.4 then -- randomly
						Prefilled_BusObject = Prefilled_BusObject_option1 -- allow dual MisterX Bus for marge airliners
					else
						Prefilled_BusObject = Dayonly_BusObject_option -- or provide the new X-Plane 12.1 single bus
					end
				end

			elseif randomView > 0.4 then
				Prefilled_BusObject = Prefilled_BusObject_option1
			else
				Prefilled_BusObject = Prefilled_BusObject_option2
			end

			if IsPassengerPlane == 1 then
				--nothing
			if (military_default == 1 or string.find(PLANE_ICAO,"F")) and sges_airport_ID ~= nil and string.find(sges_airport_ID,"LG") then
				Prefilled_BusObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "Cobus/Van_Mil_b_pax.obj"
			elseif military_default == 1 and not SGES_BushMode and User_Custom_Prefilled_BusObject_military_large ~= nil and User_Custom_Prefilled_BusObject_military_small ~= nil then
				if BeltLoaderFwdPosition > 3 then Prefilled_BusObject = User_Custom_Prefilled_BusObject_military_large else Prefilled_BusObject = User_Custom_Prefilled_BusObject_military_small end
			elseif military == 1 and XTrident_Chinook_Directory ~= nil then Prefilled_BusObject = SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" end
			elseif UseXplaneDefaultObject == false then
				Prefilled_BusObject = Prefilled_ULDTrainObject
			else
				Prefilled_BusObject = Prefilled_AlternativeBusObject
			end


			-- At the White House
			-- Andrews is LATITUDE 38.8108 LONGITUDE -76.8755
			-- White House is LATITUDE 38.896 LONGITUDE -77.036
			if LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) ) then
				Prefilled_BusObject = XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/Limo.obj"
			end

			if boarding_from_the_terminal then
				-- if the user doesn't want a vehcile to bring tyhe passenger, we will keep the framework, but use an idle oject instead.
				--Prefilled_BusObject = User_Custom_Prefilled_PeopleObject5
				Prefilled_BusObject = Prefilled_ConeObject
			end

			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
			-- ALTERNATIVES TO BUS, LIKE VAN, WITH CUSTOM NIGHT LIGHTING ON TOP
			if (IsXPlane1214 and Dayonly_airsideops_van_white ~= nil)
			--and sges_sun_pitch[0] > 5
			and UseXplane1214DefaultObject
			and (string.find(Prefilled_BusObject,"Van_White") or  string.find(Prefilled_BusObject,"airsideops"))
			then
				-- Native X-Plane day hours mini bus
				Prefilled_BusObject = Dayonly_airsideops_van_white
				if sges_airport_ID ~= nil and string.find(sges_airport_ID,"E") ~= nil and string.find(sges_airport_ID,"E") == 1 then
					Prefilled_BusObject = Dayonly_airsideops_van_checkerboard
				elseif ((sges_airport_ID ~= nil and string.find(sges_airport_ID,"LLBG") ~= nil)		-- LLBG - keep the white van for the US
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1)		-- Canada
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"O") ~= nil and string.find(sges_airport_ID,"O") == 1)		-- Middle East
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"H") ~= nil and string.find(sges_airport_ID,"H") == 1))	-- Egypt
				then
					Prefilled_BusObject = Dayonly_airsideops_van_yellow
				end
				local Bus_Van_ligthing = Van_light_flashing_lights_addonObject
				if string.find(Prefilled_BusObject,"airsideops_vw_01") then
					Bus_Van_ligthing = Van_light_addonObject -- the checkerboard van hasn't the same top lights !
				end
				if Bus_instance[1] == nil then -- add custom night lighting to the day-only x-plane native vehicle
					XPLM.XPLMLoadObjectAsync(Bus_Van_ligthing,
						function(inObject, inRefcon)
							Bus_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref7L = inObject
						end,
						inRefcon )
				end
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Regular civilian mode + X-Plane 12.1.4+ : changing the minibus for an X-Plane 12.1.4+ van.")
			end
			if (IsXPlane1214 and Dayonly_truck_flatbed_01 ~= nil) and sges_sun_pitch[0] > 3 and UseXplane1214DefaultObject
			and Prefilled_BusObject == Prefilled_ULDTrainObject and (SGES_BushMode or (math.abs(BeltLoaderFwdPosition) < 5 and not string.match(AIRCRAFT_PATH,"146")))
			then
				-- Native X-Plane truck
				Prefilled_BusObject = Dayonly_truck_flatbed_01
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Bush mode + small aircraft + X-Plane 12.1.4+ : changing the ULD train for an X-Plane 12.1.4+ truck.")
			end
			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------

			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
			-- CASE OF THE REGULAR DAY ONLY BUS WITH ENHANCED CUSTOM LIGHTS
			if (IsXPlane1214 and Cobus_light_flashing_lights_addonObject ~= nil)
			--and sges_sun_pitch[0] > 5
			and UseXplane1214DefaultObject
			--~ and Prefilled_BusObject == Dayonly_BusObject_option -- inoperant to discriminate the LImo !
			and string.find(Prefilled_BusObject,"pax_bus")
			then
				if Bus_instance[1] == nil then -- add custom night lighting to the day-only x-plane native vehicle
					local Cobus_light_addonObject = Cobus_light_turning_lights_addonObject
					randomView = math.random()
					if randomView >= 0.5 then
						Cobus_light_addonObject = Cobus_light_flashing_lights_addonObject
						--~ print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.4+ : loading custom flashing night lighting for the X-Plane 12 native Cobus.")
					else
						--~ print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.4+ : loading custom night lighting for the X-Plane 12 native Cobus.")
					end
					XPLM.XPLMLoadObjectAsync(Cobus_light_addonObject,
						function(inObject, inRefcon)
							Bus_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref7L = inObject
						end,
						inRefcon )
				end
				print("[Ground Equipment " .. version_text_SGES .. "] X-Plane 12.1.4+ : loading custom night lighting for the X-Plane 12 native Cobus. " .. Prefilled_BusObject)
			end
			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------


			--print("[Ground Equipment " .. version_text_SGES .. "] load Bus Object : " .. Prefilled_BusObject)
			XPLM.XPLMLoadObjectAsync(Prefilled_BusObject,
				function(inObject, inRefcon)
					Bus_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					rampserviceref7 = inObject
				end,
				inRefcon )






			bus_show_only_once = false
		end
	end
	local FMonce = 0
	function load_FM()
		if FM_instance[0] == nil and FMonce == 0  and FM_show_only_once then

			if XTrident_Chinook_Directory ~= nil then
				if military == 1 then Prefilled_FMObject = SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" end

				 if military == 0 and XTrident_Chinook_Directory ~= nil and Prefilled_FMObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" then
						-- FOLLOW ME VEHICLE --RESET----------------------------------------------------
						if BeltLoaderFwdPosition < 4 and (not string.match(PLANE_ICAO,"B46") and not string.match(PLANE_ICAO,"RJ") ) then
							-- for the smaller aircraft, use the smallest follow-me we provide
							Prefilled_FMObject = User_Custom_Prefilled_FMObject
						else
							if User_Custom_Prefilled_FMObject_2 == nil then User_Custom_Prefilled_FMObject_2 = User_Custom_Prefilled_FMObject end
							Prefilled_FMObject = User_Custom_Prefilled_FMObject_2 -- the yellow
						end
				 end
			end

			FMonce = 1
		   XPLM.XPLMLoadObjectAsync(Prefilled_FMObject,
					function(inObject, inRefcon)
						FM_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref53 = inObject
					end,
					inRefcon )
			FM_show_only_once = false
		end
	end

	function load_Catering()
		if Catering_instance[0] == nil and Catering_show_only_once then
				-- At the White House
				-- Andrews is LATITUDE 38.8108 LONGITUDE -76.8755
				-- White House is LATITUDE 38.896 LONGITUDE -79.036
				if LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) ) then
					math.randomseed(os.time())
					randomView = math.random()
					if randomView > 0.3 then
						CatObject = SAM_object_3
					else
						CatObject = SAM_object_1
					end
					CateringHighPartObject =  Prefilled_LightObject				-- no second part

				elseif (military_default == 1 or string.find(PLANE_ICAO,"F")) and sges_airport_ID ~= nil and string.find(sges_airport_ID,"LG") then
					CatObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_Camo_b.obj"
					CateringHighPartObject = Prefilled_LightObject

				elseif ( military_default == 1 or military == 1 ) and Prefilled_Mil_Van ~= nil then
					CatObject = Prefilled_Mil_Van
					CateringHighPartObject = Prefilled_LightObject				-- no second part
				elseif IsPassengerPlane == 0 and not SGES_BushMode then
					CatObject = Prefilled_CleaningTruckObject
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				elseif (PLANE_ICAO == "E170" or PLANE_ICAO == "E175" or PLANE_ICAO == "E19L") and SGES_Embraer_catering_is_small then
					CatObject = Prefilled_AlternativeCateringObject
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				elseif IsXPlane1214 and UseXplane1214DefaultObject and Dayonly_truck_flatbed_01 ~= nil and PLANE_ICAO == "DH8D" and not SGES_Embraer_catering_is_small then
					CatObject = Dayonly_truck_flatbed_01
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				elseif string.match(PLANE_ICAO,"BN2") or PLANE_ICAO == "MD88" or string.match(PLANE_ICAO,"B46") or PLANE_ICAO == "RJ70" or PLANE_ICAO == "RJ85" or PLANE_ICAO == "RJ1H" or string.match(PLANE_ICAO,"DH8A") or PLANE_ICAO == "DH8C" or PLANE_ICAO == "DH8D" or string.match(PLANE_ICAO,"AT4") or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then
					CatObject = Prefilled_AlternativeCateringObject
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				elseif SGES_BushMode and IsXPlane12 then
					CatObject = XPlane12_BushObjects_directory   .. "clut_small_5x2_06.obj"
					CateringHighPartObject = Prefilled_LightObject
				elseif BeltLoaderFwdPosition <= 5 then
					CatObject = Prefilled_CleaningTruckObject
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				elseif BeltLoaderFwdPosition < 6 then
					CatObject = Prefilled_AlternativeCateringObject
					CateringHighPartObject =  Prefilled_LightObject				-- no second part
				else
					-- normal catering for airliners

					-- comes in several flavors
					CatObject = Prefilled_CateringObject						-- first  part of the normal catering object
					CateringHighPartObject = Prefilled_CateringHighPartObject	-- second part of the normal catering object

					if sges_airport_ID == nil then
						sges_big_airport,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,sges_airport_ID)
					end

					if ((sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1)		-- USA
					or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
					or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
					or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1))	-- Canada
					 then
						-- US Airports : LSG skychef
						CateringHighPartObject = Prefilled_CateringHighPartObject
					elseif sges_big_airport ~= nil and sges_big_airport and sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") == nil then
						-- big airports outside the USA : newrest or Gate Gourmet
						math.randomseed(os.time())
						randomView = math.random()
						if randomView > 0.6 then
							CateringHighPartObject = Prefilled_CateringHighPart_NR_Object -- Newrest
						else
							CateringHighPartObject = Prefilled_CateringHighPart_GG_Object -- Gate Gourmet
						end
					elseif string.find(AircraftPath,"minoan") or string.find(AircraftPath,"Minoan") then
						CateringHighPartObject = Prefilled_CateringHighPart_MI_Object -- MINOAN gourmet
					end
				end


				------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
				if (IsXPlane1214 and Dayonly_airsideops_van_yellow ~= nil) -- make safety code verifications and version check
					--~ and sges_sun_pitch[0] > 5 and UseXplane1214DefaultObject  -- restrict replacement by an X-Plane 12.1.4 vehicule to day
					and UseXplane1214DefaultObject  -- less restricted replacement
					and not SGES_BushMode -- restrict it to normal mode
					and (string.find(CatObject,"Van_White") or string.find(CatObject,"Van_Catering")  or string.find(CatObject,"airsideops")) -- this check restricts the replacement only when using this original library object, like in normal, passenger, civilian SGES in-game configuration
					then
						-- Native X-Plane 12.1.4 day hours Common Equipment Vehicle (has no lights ! Use day only !)
						CatObject = Dayonly_airsideops_van_yellow
						CateringHighPartObject =  Prefilled_LightObject	 -- defaulting

						if sges_airport_ID ~= nil and string.find(sges_airport_ID,"E") ~= nil and string.find(sges_airport_ID,"E") == 1 then
							CatObject = Dayonly_airsideops_van_checkerboard
						end
						if ((sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1)		-- USA
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1))	-- Canadapickup_yellow
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"LLBG") ~= nil )	-- LLBG (like in the US)
						 then
							CatObject = Dayonly_airsideops_pickup_white
						end
						-- then ADD the night lighting to the x-Plane 12 van or X-Plane 12 pickup
						math.randomseed(os.time())
						randomView = math.random()
						CateringHighPart_is_night_lighting = true
						-- Allow a small variation in the night lighting carried by the vehicle.
						if randomView < 0.8 then
							CateringHighPartObject = Van_light_turning_lights_addonObject -- majority has turning lights and no flashing lights active
						else
							CateringHighPartObject = Van_light_flashing_lights_addonObject
							if string.find(CatObject,"airsideops_vw_01") then
								CateringHighPartObject = Van_light_addonObject -- the checkerboard van hasn't the same top lights !
							end
						end

						if string.find(CatObject,"pickup") then
							if randomView > 0.20 then
								CateringHighPartObject = Pickup_light_flashing_lights_addonObject
							else
								CateringHighPartObject = Pickup_light_addonObject
							end
						end
						--~ print("[Ground Equipment " .. version_text_SGES .. "] Small catering + X-Plane 12.1.4+ : changing the catering car for an X-Plane 12.1.4+ van.")
				end
				------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
				if Clairmarais_Aerodrome_directory ~= nil then Clairmarais_Aerodrome_lib() end

				--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Catering Object ")
			   XPLM.XPLMLoadObjectAsync(CatObject,
						function(inObject, inRefcon)
							Catering_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref8 = inObject
						end,
						inRefcon )
		end

		if Catering_instance[1] == nil and Catering_show_only_once then -- then an instance is called to be drawn but is missing !
			   XPLM.XPLMLoadObjectAsync(CateringHighPartObject,
						function(inObject, inRefcon)
							Catering_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref8h = inObject
						end,
						inRefcon )
			Catering_show_only_once = false
		end
	end


	function load_PRM()
		if PRM_instance[0] == nil and PRM_0_show_only_once then


			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------
			if IsXPlane1221 -- make safety code verifications and version check
				and UseXplane1214DefaultObject  -- restrict replacement by an X-Plane 12.1.4 vehicule to day
				and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1
				and get_hospital_ambulance -- restrict replacement to the PRM_passat_white
				then
					Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_us_02.obj" -- US and default ambulance. Always true.
					-- then look for regional variants if applicable :
					if IsXPlane1230 then
						if (LATITUDE > 43 and LATITUDE < 50) and (LONGITUDE > -5 and LONGITUDE < 8) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_02.obj" -- French ambulance squared
							if PLANE_ICAO == "Alouette" then
								Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_05.obj" -- French ambulance rounded
							end
						elseif (LATITUDE > 41 and LATITUDE < 43) and (LONGITUDE > 8.5 and LONGITUDE < 9.5) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_05.obj" -- French ambulance rounded
						elseif (LATITUDE > 29 and LATITUDE < 43) and (LONGITUDE > -10 and LONGITUDE < 49) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_07.obj" -- Mediterranean ambulance
						elseif (LATITUDE >= 48 and LATITUDE < 72) and (LONGITUDE > -10 and LONGITUDE < 28) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_06.obj" -- Nordic EU ambulance
						elseif (LATITUDE >= 43 and LATITUDE < 48) and (LONGITUDE > 8 and LONGITUDE < 28) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_eu_01.obj" -- Eastern Eu ambulance
						elseif  (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69) then
							Prefilled_CateringObject = XPlane12_Common_Vehicules_directory  .. "ambulance_us_04.obj" -- -- East Coast USA FDNY-like
						end
					end
					PREMHighPart_is_night_lighting = false
					Prefilled_PRMHighPartObject = Prefilled_LightObject

			elseif (IsXPlane1214 and Dayonly_airsideops_Ambulance_yellow ~= nil) -- make safety code verifications and version check
				and UseXplane1214DefaultObject  -- restrict replacement by an X-Plane 12.1.4 vehicule to day
				and not SGES_BushMode
				and (string.find(Prefilled_CateringObject,"PRM_passat_white") ~= nil or string.find(Prefilled_CateringObject,"crew_car") ~= nil or string.find(Prefilled_CateringObject,"ambulance_us") ~= nil) -- restrict replacement to the PRM_passat_white
				and ((sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1)		-- USA
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1))	-- Canada
				or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"LLBG") ~= nil )	-- LLBG (like in the US)
				then
					Prefilled_CateringObject = Dayonly_airsideops_Ambulance_yellow
					-- Native X-Plane 12.1.4 day hours Common Equipment Vehicle (has no lights ! Use day only !)

					PREMHighPart_is_night_lighting = true
					randomView = math.random()
					if randomView > 0.20 then
						Prefilled_PRMHighPartObject = Ambulance_light_turning_lights_addonObject
					else
						Prefilled_PRMHighPartObject = Ambulance_light_flashing_lights_addonObject
					end
			elseif IsXPlane1214 and Prefilled_CateringObject == Dayonly_airsideops_Ambulance_yellow and PREMHighPart_is_night_lighting == nil then -- revert
					Prefilled_CateringObject = Prefilled_PRM_carObject
					Prefilled_PRMHighPartObject = Prefilled_LightObject
			end
			------------------ VEHICLE REPLACEMENT AFTER X-PLANE 12.1.4 ----------------


			   XPLM.XPLMLoadObjectAsync(Prefilled_CateringObject,
						function(inObject, inRefcon)
							PRM_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefPRM = inObject
						end,
						inRefcon )
			PRM_0_show_only_once = false
		end

		if PRM_instance[1] == nil and PRM_1_show_only_once then
				PRMHighPartObject = Prefilled_PRMHighPartObject
				if PRM_is_catering and CateringHighPartObject ~= nil then
					PRMHighPartObject = CateringHighPartObject
				elseif PRM_is_catering then
					PRMHighPartObject = Prefilled_CateringHighPartObject
				else
					PRMHighPartObject = Prefilled_PRMHighPartObject
			    end
				XPLM.XPLMLoadObjectAsync(PRMHighPartObject,
						function(inObject, inRefcon)
							PRM_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefPRM2 = inObject
						end,
						inRefcon )
			PRM_1_show_only_once = false
		end
	end

	local FireObject = Prefilled_FireObject
	local  FVonce = 0
	function load_FireVehicle()


		if FireVehicle_instance[0] == nil and FVonce == 0 then
			FVonce = 0.5
			if IsXPlane1221 and show_Watersalute  and UseXplane1214DefaultObject and not show_FireVehicleAhead then
				FireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_2.obj"

				if (         (sges_airport_ID ~= nil and string.find(sges_airport_ID,"K") ~= nil and string.find(sges_airport_ID,"K") == 1)		-- USA
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"M") ~= nil and string.find(sges_airport_ID,"M") == 1)		-- Central America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"S") ~= nil and string.find(sges_airport_ID,"S") == 1)		-- South America
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"C") ~= nil and string.find(sges_airport_ID,"C") == 1))	-- Canada
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"LLBG") ~= nil )	-- LLBG (like in the US)
						or   (sges_airport_ID ~= nil and string.find(sges_airport_ID,"LGTL") ~= nil )	-- New Iraklio airport at Kastelli
				then
					FireObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/striker_6x6_1.obj"
				end
			elseif  (LATITUDE > 24 and LATITUDE < 71) and (LONGITUDE > -157 and LONGITUDE < -51) then -- USA
				FireObject = Prefilled_AlternativeFireObject -- yellow Striker
			elseif  (LATITUDE > 29 and LATITUDE < 34) and (LONGITUDE > 33 and LONGITUDE < 34.8) then -- ISR
				FireObject = Prefilled_AlternativeFireObject -- yellow Striker
			elseif  (LATITUDE > -40 and LATITUDE < 7) and (LONGITUDE > 102 and LONGITUDE < 154) then -- Asia (Singapour, Java), Australia
				FireObject = Prefilled_AlternativeFireObject -- yellow Striker
			else -- Everywhere else
				FireObject = Prefilled_FireObject --red Striker
			end

		    XPLM.XPLMLoadObjectAsync(FireObject,
				function(inObject, inRefcon)
					FireVehicle_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					rampserviceref71 = inObject
				end,
				inRefcon )
		end
		if FireVehicle_instance[1] == nil and FVonce == 0.5 and IsXPlane1221 and UseXplane1214DefaultObject and string.match(FireObject,"striker") then
			FVonce = 0.75
			if FireObject == Prefilled_FireObject then
				FireObject_lights = Prefilled_FireObject_lights
			else
				FireObject_lights = Prefilled_AlternativeFireObject_lights -- the same at the moment as Prefilled_FireObject_lights
			end

			if show_Watersalute then
				FireObject_lights = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "Fire/Striker_watersalute.obj"
			end

			XPLM.XPLMLoadObjectAsync(FireObject_lights,
				function(inObject, inRefcon)
					FireVehicle_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					rampserviceref71L = inObject
				end,
				inRefcon )
		end


		if FireVehicle_instance[2] == nil and FVonce <= 0.75 and IsXPlane1221 and UseXplane1214DefaultObject and string.match(FireObject,"striker") and not show_Watersalute then
			FVonce = 1
			if IsPassengerPlane == 1 then
				Prefilled_FireCommandObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/fire_command_2.obj"
			else
				Prefilled_FireCommandObject = XPlane_Ramp_Equipment_directory .. "../Common_Elements/fire_department/fire_command_1.obj"
			end

			--~ if not show_FireVehicleAhead then
			XPLM.XPLMLoadObjectAsync(Prefilled_FireCommandObject,
				function(inObject, inRefcon)
					FireVehicle_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					rampserviceref71b = inObject
				end,
				inRefcon )
			--~ end
		end
		if show_Pelicandrome and FireVehicle_instance[3] == nil then
			--~ print("Loading hose")
			XPLM.XPLMLoadObjectAsync(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/SGES_ASU_duct2.obj",
				function(inObject, inRefcon)
					FireVehicle_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					rampserviceref71d = inObject
				end,
				inRefcon )
		end



		if FVonce <= 0.75 then
			FVonce = 1
		end

	end

	ASonce = 0
	IsEMAS = true -- the most common arresting system in the 21th century will be EMAS. Let's make it default.
	IsNet = false
	function load_ArrestorSystem()
		if IsCable then
			IsNet = false
			Prefilled_ArrestorSystem = Prefilled_ArrestorCable
		elseif IsEMAS then
			IsNet = false
			Prefilled_ArrestorSystem = Prefilled_EMAS
		else
			IsNet = true
			Prefilled_ArrestorSystem = Prefilled_ArrestorNet
		end
		if ArrestorSystem_instance[0] == nil and ASonce == 0 then
			--print("[Ground Equipment " .. version_text_SGES .. "] load arrestor system " .. Prefilled_ArrestorSystem)
			--print(string.format("Arrestor location : %s (%s ft, HDG %s °) ", outName, outHeight,outHeading))
			ASonce = 1
			ASObject = Prefilled_ArrestorSystem

			   XPLM.XPLMLoadObjectAsync(ASObject,
						function(inObject, inRefcon)
							ArrestorSystem_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefAS = inObject
						end,
						inRefcon )
		end
	end



	function load_FireSmoke()
		if FireSmoke_instance[0] == nil then


			if IsXPlane12 then
				math.randomseed(os.time())
				if outsideAirTemp >= temperature_below_which_we_display_the_active_deicing_service + 10 and not show_FireVehicleAhead then
					Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12_extended.obj"
				else -- back to normal
					Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12.obj"
				end
			end

			   XPLM.XPLMLoadObjectAsync(Prefilled_FireAndSmokeObject,
						function(inObject, inRefcon)
							FireSmoke_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref710 = inObject
						end,
						inRefcon )
		end
	end


	function load_ULDLoader()
		if ULDLoader_instance[0] == nil and ULDLoader_show_only_once then
		   if PLANE_ICAO == "A346" then Prefilled_CargoDeck_ULDLoaderObject = XPlane_Ramp_Equipment_directory   .. "Belt_Loader.obj" end
			if (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or string.match(PLANE_ICAO,"B73") or string.match(PLANE_ICAO,"B72") or string.match(PLANE_ICAO,"MD8") or string.match(PLANE_ICAO,"MD9") or string.match(PLANE_ICAO,"E19") or string.match(PLANE_ICAO,"E17") then
				-- The ULD Loader from Laminar Research is too high for the BAe-146 QT Main cargo door.
				if IsXPlane1211 then
					Prefilled_CargoDeck_ULDLoaderObject = XPlane_Ramp_Equipment_directory .. "cargo_loader_ch70w.obj"
				else
					Prefilled_CargoDeck_ULDLoaderObject = SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/"   .. "ULDLoader/Generic.obj"
				end
				print("The ULD Loader from Laminar Research is too high for the BAe-146 Quiet trader or the " .. PLANE_ICAO .. ". Let's change it.")
				CargoDeck_ULDLoaderObject = "low_variant" -- used to trigger othr animations
			else
				CargoDeck_ULDLoaderObject = "high_variant" --normal
			end
		   XPLM.XPLMLoadObjectAsync(Prefilled_CargoDeck_ULDLoaderObject,
					function(inObject, inRefcon)
						ULDLoader_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref72 = inObject
					end,
					inRefcon )
			ULDLoader_show_only_once = false
		end
	end
	function load_People1()
		if People1_instance[0] == nil and People1_show_only_once then
		   XPLM.XPLMLoadObjectAsync(Prefilled_PeopleObject1,
					function(inObject, inRefcon)
						People1_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref73 = inObject
					end,
					inRefcon )
			People1_show_only_once = false
		end
	end
	function load_People2()
		if People2_instance[0] == nil and People2_show_only_once then
		   XPLM.XPLMLoadObjectAsync(Prefilled_PeopleObject2,
					function(inObject, inRefcon)
						People2_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref74 = inObject
					end,
					inRefcon )
			People2_show_only_once = false
		end
	end
	function load_People3()
		if People3_instance[0] == nil and People3_show_only_once then
			if military == 1 or military_default == 1 then PeopleObject3 = Prefilled_PassengerMilObject
			elseif LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) ) then
			 PeopleObject3 = User_Custom_Prefilled_Passenger4Object -- USSS at the White House
			else PeopleObject3 = Prefilled_PeopleObject3
			end
		   XPLM.XPLMLoadObjectAsync(PeopleObject3,
					function(inObject, inRefcon)
						People3_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref75 = inObject
					end,
					inRefcon )
			People3_show_only_once = false
		end
	end
	function load_People4()
		if People4_instance[0] == nil and People4_show_only_once then
			if LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) ) then
			PeopleObject4 = User_Custom_Prefilled_Passenger7Object  -- USSS at the White House
			else PeopleObject4 = Prefilled_PeopleObject4
			end
		   XPLM.XPLMLoadObjectAsync(PeopleObject4,
					function(inObject, inRefcon)
						People4_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref76 = inObject
					end,
					inRefcon )
			People4_show_only_once = false
		end
	end
	if UseXplaneDefaultObject == false then -- do not arm passengers
		function load_Passengers() -- this part crashes
			-- open the ToLiSs A319/A321 door
			if dataref_to_open_the_door ~= nil and index_to_open_the_door ~= nil then


				if dataref_to_open_the_door == "laminar/B738/door/fwd_L_toggle" and string.match(PLANE_ICAO,"B73") then			-- ZIBO / LevelUp
					if PaxDoor1L == nil and XPLMFindDataRef("laminar/B738/doors/status") ~= nil then								-- ZIBO / LevelUp
							dataref("PaxDoor1L","laminar/B738/doors/status","readonly",index_to_open_the_door)						-- ZIBO / LevelUp
					end																												-- ZIBO / LevelUp
					if show_Pax and PaxDoor1L ~= nil and PaxDoor1L == 2 then														-- ZIBO / LevelUp
						command_once("laminar/B738/door/fwd_L_toggle")
						--print("[Ground Equipment " .. version_text_SGES .. "] open the laminar/B738 door via toggle command.")
					end
				elseif string.find(dataref_to_open_the_door,"md80") then			-- Rotate MD80

					if PaxDoor1L == nil and XPLMFindDataRef("Rotate/md80/doors/main_cabin_door_ratio") ~= nil then
						print("[Ground Equipment " .. version_text_SGES .. "] The door has the command " .. dataref_to_open_the_door)
						dataref("PaxDoor1L","Rotate/md80/doors/main_cabin_door_ratio","readonly",index_to_open_the_door)
					end
					if show_Pax and PaxDoor1L ~= nil and PaxDoor1L == 0 then
						command_once("Rotate/md80/doors/main_cabin_door_open")
						print("[Ground Equipment " .. version_text_SGES .. "] Opening the Rotate MD-88 door via command.")
						PaxDoor1L = nil
					end
				elseif show_StairsXPJ then
					if PaxDoor1L == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil then
						print("[Ground Equipment " .. version_text_SGES .. "] The door has the dataref " .. dataref_to_open_the_door .. ":" .. index_to_open_the_door)
						dataref("PaxDoor1L",dataref_to_open_the_door,"writable",index_to_open_the_door)
					end
					if show_Pax and PaxDoor1L ~= nil and PaxDoor1L ~= target_to_open_the_door then
						PaxDoor1L = target_to_open_the_door
						--print("[Ground Equipment " .. version_text_SGES .. "] open the door with dataref " .. dataref_to_open_the_door .. ":" .. index_to_open_the_door)
					end
					-- Peculiar case of Embraer Lineage stairs :
					if PaxLineageStairs == nil and PLANE_ICAO == "E19L" and SGES_Author == "Marko Mamula" and dataref_to_open_the_second_door ~= nil and XPLMFindDataRef(dataref_to_open_the_second_door) ~= nil then
						dataref("PaxLineageStairs",dataref_to_open_the_second_door,"writable",index_to_open_the_second_door)
						print("[Ground Equipment " .. version_text_SGES .. "] The Embraer Lineage stairs have the dataref " .. dataref_to_open_the_second_door .. ":" .. index_to_open_the_door)
					end
					if PLANE_ICAO == "E19L" and show_Pax and PaxLineageStairs ~= nil and PaxLineageStairs ~= target_to_open_the_door then
						PaxLineageStairs = target_to_open_the_door
					end
				end

			--~ elseif dataref_table_to_open_the_door ~= nil and index_to_open_the_door ~= nil then -- second case when the dataref is a table !

				--~ if BoardStairsXPJ then -- open the door only when it's the front door at which we board. As a simplificaiton, the human will take care of opening the rear door.
					--~ if PaxDoor1L == nil and XPLMFindDataRef(dataref_table_to_open_the_door) ~= nil then
						--~ PaxDoors = dataref_table(dataref_table_to_open_the_door)
						--~ PaxDoor1L = PaxDoors[target_to_open_the_door]
						--~ print("[Ground Equipment " .. version_text_SGES .. "]  arm the door with dataref table " .. dataref_table_to_open_the_door .. ":" .. index_to_open_the_door)
					--~ end
					--~ if show_Pax and PaxDoor1L ~= nil and PaxDoor1L < target_to_open_the_door then
						--~ PaxDoor1L = target_to_open_the_door
						--~ print("[Ground Equipment " .. version_text_SGES .. "] open the door with dataref table " .. dataref_table_to_open_the_door .. ":" .. index_to_open_the_door)
					--~ end
				--~ end
			end

			if dataref_to_open_the_door ~= nil and (index_to_open_the_second_door ~= nil or dataref_to_open_the_second_door ~= nil) then

				if dataref_to_open_the_door == "laminar/B738/door/fwd_L_toggle" and string.match(PLANE_ICAO,"B73") then				-- ZIBO / LevelUp
					if index_to_open_the_second_door ~= nil and  PaxDoorRearLeft == nil and XPLMFindDataRef("laminar/B738/doors/status") ~= nil then								-- ZIBO / LevelUp
							dataref("PaxDoorRearLeft","laminar/B738/doors/status","readonly",index_to_open_the_second_door)				-- ZIBO / LevelUp
					end																												-- ZIBO / LevelUp
					if show_Pax and PaxDoorRearLeft ~= nil and PaxDoorRearLeft == 2 then														-- ZIBO / LevelUp
						command_once("laminar/B738/door/aft_L_toggle")																-- ZIBO / LevelUp
					end

				elseif show_StairsXPJ2 then
					if index_to_open_the_second_door ~= nil and PaxDoorRearLeft == nil and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then
						dataref("PaxDoorRearLeft","1-sim/anim/doorL5","writable",index_to_open_the_second_door)
					elseif index_to_open_the_second_door ~= nil and  PaxDoorRearLeft == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil then
						dataref("PaxDoorRearLeft",dataref_to_open_the_door,"writable",index_to_open_the_second_door)
						print("[Ground Equipment " .. version_text_SGES .. "]  PaxDoorRearLeft dataref is loaded via a second index for the door dataref.")
					elseif dataref_to_open_the_second_door ~= nil and PaxDoorRearLeft == nil and XPLMFindDataRef(dataref_to_open_the_second_door) ~= nil then
						dataref("PaxDoorRearLeft",dataref_to_open_the_second_door,"writable",index_to_open_the_door)
						print("[Ground Equipment " .. version_text_SGES .. "]  PaxDoorRearLeft dataref is loaded via a second dataref.")
					end

					if show_Pax and PaxDoorRearLeft ~= nil and PaxDoorRearLeft ~= target_to_open_the_door then
						PaxDoorRearLeft = target_to_open_the_door
					end
				end

			end

			if walking_direction_changed_armed
			--~ and passenger1_show_only_once and passenger2_show_only_once and passenger3_show_only_once and passenger4_show_only_once and passenger5_show_only_once and passenger6_show_only_once
			--~ and passenger7_show_only_once and passenger8_show_only_once and passenger9_show_only_once and passenger10_show_only_once and passenger11_show_only_once and passenger12_show_only_once
			then
				-- revert boarding and deboarding for upcoming pax cycle
				if walking_direction == "deboarding" then walking_direction = "boarding" else walking_direction = "deboarding" end
				print("[Ground Equipment " .. version_text_SGES .. "] Walking direction change executed after walking_direction_changed_armed = true. Pax are " .. walking_direction .. ".")
				-------- PATCH TO SECURE DEBOARDING AFTER A FLIGHT -------------
				if Intervention_on_walking_direction_only_once == false and SGES_total_flight_time_sec >= 3600 then
					walking_direction = "deboarding"  -- upon arrival at gate, calling this service will ensure everything is set for deboarding
					print("[Ground Equipment " .. version_text_SGES .. "] Intervention on walking_direction (once) : now " .. walking_direction .. " direction is enforced.")
					Intervention_on_walking_direction_only_once = true -- do this intervention only once, to allow manual cycling boarding/deboarding by the user
				end
				----------------------------------------------------------------


				BeltLoader_chg = true -- this steps allow the inversion of the animated baggages
				walking_direction_changed_armed = false
			end

			--print("[Ground Equipment " .. version_text_SGES .. "] Passenger is " .. Prefilled_Passenger1Object)
			if Passenger_instance[0] == nil and passenger1_show_only_once and terminate_passenger_action == false then

				if outsideAirTemp < 10 then
						Passenger1Object = Prefilled_Passenger13Object
				elseif military == 1 or military_default == 1 then
						Passenger1Object = Prefilled_PassengerMilObject
				else Passenger1Object = Prefilled_Passenger1Object end

				--print("[Ground Equipment " .. version_text_SGES .. "] Passenger_instance[0] == nil, load_Passengers ")
				XPLM.XPLMLoadObjectAsync(Passenger1Object,
					function(inObject, inRefcon)
						Passenger_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						Paxref0 = inObject
					end,
					inRefcon )
				passenger1_show_only_once = false
			end
			if IsPassengerPlane == 1 then

				if Passenger_instance[1] == nil and passenger2_show_only_once and terminate_passenger_action == false then
					if military == 1 or military_default == 1 then Passenger2Object = Prefilled_PassengerMilObject  else Passenger2Object = Prefilled_Passenger2Object  end
					XPLM.XPLMLoadObjectAsync(Passenger2Object,
						function(inObject, inRefcon)
							Passenger_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref1 = inObject
						end,
						inRefcon )
					passenger2_show_only_once = false
				end
				if Passenger_instance[2] == nil and passenger3_show_only_once and terminate_passenger_action == false then

					if military == 1 or military_default == 1 then Passenger3Object = Prefilled_PassengerMilObject else Passenger3Object = Prefilled_Passenger3Object  end

					XPLM.XPLMLoadObjectAsync(Passenger3Object,
						function(inObject, inRefcon)
							Passenger_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref2 = inObject
						end,
						inRefcon )
					passenger3_show_only_once = false
				end

				if Passenger_instance[3] == nil and passenger4_show_only_once and terminate_passenger_action == false then
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger4Object,
						function(inObject, inRefcon)
							Passenger_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref3 = inObject
						end,
						inRefcon )
					passenger4_show_only_once = false
				end

				if Passenger_instance[4] == nil and passenger5_show_only_once and terminate_passenger_action == false then
					if military == 1 or military_default == 1 then Passenger6Object = Prefilled_PassengerMilObject else Passenger6Object = Prefilled_Passenger8Object  end
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger6Object,
						function(inObject, inRefcon)
							Passenger_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref4 = inObject
						end,
						inRefcon )
					passenger5_show_only_once = false
				end


				if Passenger_instance[5] == nil and passenger6_show_only_once and terminate_passenger_action == false then --
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger7Object,
						function(inObject, inRefcon)
							Passenger_instance[5] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref5 = inObject
						end,
						inRefcon )
					passenger6_show_only_once = false
				end


				-- added 12-2022 :


				if Passenger_instance[6] == nil and passenger7_show_only_once and terminate_passenger_action == false then --
					if military == 1 or military_default == 1 then Passenger8Object = Prefilled_PassengerMilObject else Passenger3Object = Prefilled_Passenger8Object  end
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger8Object,
						function(inObject, inRefcon)
							Passenger_instance[6] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref6 = inObject
						end,
						inRefcon )
					passenger7_show_only_once = false
				end
				if Passenger_instance[7] == nil and passenger8_show_only_once and terminate_passenger_action == false then
					if military == 1 or military_default == 1 then Passenger9Object = Prefilled_PassengerMilObject else Passenger9Object = Prefilled_Passenger9Object end
					XPLM.XPLMLoadObjectAsync(Passenger9Object,
						function(inObject, inRefcon)
							Passenger_instance[7] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref7 = inObject
						end,
						inRefcon )
					passenger8_show_only_once = false
				end
				if Passenger_instance[8] == nil and passenger9_show_only_once and terminate_passenger_action == false then --

					if military == 1 or military_default == 1 then Passenger10Object = Prefilled_PassengerMilObject else Passenger10Object = Prefilled_Passenger10Object end
					XPLM.XPLMLoadObjectAsync(Passenger10Object,
						function(inObject, inRefcon)
							Passenger_instance[8] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref8 = inObject
						end,
						inRefcon )
					passenger9_show_only_once = false
				end
				if Passenger_instance[9] == nil and passenger10_show_only_once and terminate_passenger_action == false then --
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger11Object,
						function(inObject, inRefcon)
							Passenger_instance[9] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref9 = inObject
						end,
						inRefcon )
					passenger10_show_only_once = false
				end
				if Passenger_instance[10] == nil and passenger11_show_only_once and terminate_passenger_action == false then --
					if military == 1 or military_default == 1 then Passenger12Object = Prefilled_PassengerMilObject else Passenger12Object = Prefilled_Passenger8Object  end
					XPLM.XPLMLoadObjectAsync(Prefilled_Passenger12Object,
						function(inObject, inRefcon)
							Passenger_instance[10] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref10 = inObject
						end,
						inRefcon )
					passenger11_show_only_once = false
				end
				if Passenger_instance[11] == nil and passenger12_show_only_once and terminate_passenger_action == false then -- MIL
					XPLM.XPLMLoadObjectAsync(Prefilled_PassengerMilObject,
						function(inObject, inRefcon)
							Passenger_instance[11] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							Paxref11 = inObject
						end,
						inRefcon )
					passenger12_show_only_once = false
				end
			end
		end
	end

	function load_Ship1()
		if Ship1_instance[0] == nil then
				--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Small Ship Object " .. Prefilled_SmallShipObject)
			   XPLM.XPLMLoadObjectAsync(Prefilled_SmallShipObject,
						function(inObject, inRefcon)
							Ship1_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref81 = inObject
						end,
						inRefcon )
		end
		math.randomseed(os.time())
		randomView = math.random()
		if Ship1_instance[1] == nil and randomView > 0.5 then -- on fire
				--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Small Ship Object " .. Prefilled_SmallShipObject)
				Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround.obj"
				if IsXPlane12 then
					Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12.obj"
				end
			   XPLM.XPLMLoadObjectAsync(Prefilled_FireAndSmokeObject,
						function(inObject, inRefcon)
							Ship1_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref81F = inObject
						end,
						inRefcon )
		end
	end

	function load_Ship2()
		if Ship2_instance[0] == nil then
				--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Large Ship Object " .. Prefilled_LargeShipObject)
			   XPLM.XPLMLoadObjectAsync(Prefilled_LargeShipObject,
						function(inObject, inRefcon)
							Ship2_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref82 = inObject
						end,
						inRefcon )
		end
		if IsXPlane12 and Ship2_instance[1] == nil and Prefilled_LargeShipObject == Prefilled_XP12_LargeShip_3 then -- on fire
				--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Small Ship Object " .. Prefilled_SmallShipObject)
				Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround.obj"
				if IsXPlane12 then
					randomView = math.random()
					if randomView > 0.5 then
						Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12_extended.obj"
					else
						Prefilled_FireAndSmokeObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12.obj"
					end
				end
			   XPLM.XPLMLoadObjectAsync(Prefilled_FireAndSmokeObject,
						function(inObject, inRefcon)
							Ship2_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref82F = inObject
						end,
						inRefcon )
		end
	end

	if IsXPlane12 then


		function load_Helicopters()
			if Helicopters_draw_only_once then

			--~ if show_FireVehicle then
				--~ XP12Helicopter = XPlane12_ford_carrier_accessories_directory .. "FA-18E_static_spreadedwings.obj"
			--~ else
				XP12Helicopter = Prefilled_XP12Helicopter
			--~ end

				if Helicopters_instance[0] == nil then
					   XPLM.XPLMLoadObjectAsync(XP12Helicopter,
								function(inObject, inRefcon)
									Helicopters_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									rampservicerefXP12Helicopter0 = inObject
								end,
								inRefcon )
				end
				if not show_FireVehicle then -- when the helicopters are requested automatically by the fire brigade, it's not a fly-by, it's a unique helicopter for rescue
					-- therefore we don't load the 3 extras helos -- changed 9-nov-2025
					if Helicopters_instance[1] == nil then
						   XPLM.XPLMLoadObjectAsync(Prefilled_XP12Helicopter,
									function(inObject, inRefcon)
										Helicopters_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										rampservicerefXP12Helicopter1 = inObject
									end,
									inRefcon )
					end
					if Helicopters_instance[2] == nil then
						   XPLM.XPLMLoadObjectAsync(Prefilled_XP12Helicopter,
									function(inObject, inRefcon)
										Helicopters_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										rampservicerefXP12Helicopter2 = inObject
									end,
									inRefcon )
					end
					if Helicopters_instance[3] == nil then
						   XPLM.XPLMLoadObjectAsync(Prefilled_XP12Helicopter,
									function(inObject, inRefcon)
										Helicopters_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										rampservicerefXP12Helicopter3 = inObject
									end,
									inRefcon )
					end
				end
				Helicopters_draw_only_once = false
			end
		end


		function load_Submarine()
			if Submarine_draw_only_once then
				if Submarine_instance[0] == nil and User_Custom_Prefilled_SubmarineObject ~= nil then
					   XPLM.XPLMLoadObjectAsync(User_Custom_Prefilled_SubmarineObject,
								function(inObject, inRefcon)
									Submarine_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									rampservicerefSubmarine = inObject
								end,
								inRefcon )
				end
				Submarine_draw_only_once = false
			end
		end

		function load_XP12Carrier()
			if XP12Carrier_instance[0] == nil then
					--print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_Small Ship Object " .. Prefilled_SmallShipObject)
				if Prefilled_XP12Boat == nil then Prefilled_XP12Boat = Prefilled_XP12Frigate end
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12Boat,
							function(inObject, inRefcon)
								XP12Carrier_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12Carrier = inObject
							end,
							inRefcon )

				if Prefilled_XP12Boat == Prefilled_XP12Carrier then
				-- draw the other parts of the CVN 78 Gerald Ford

				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP2,
							function(inObject, inRefcon)
								XP12Carrier_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP2 = inObject
							end,
							inRefcon )
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP3,
							function(inObject, inRefcon)
								XP12Carrier_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP3 = inObject
							end,
							inRefcon )
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP4,
							function(inObject, inRefcon)
								XP12Carrier_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP4 = inObject
							end,
							inRefcon )
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP5,
							function(inObject, inRefcon)
								XP12Carrier_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP5 = inObject
							end,
							inRefcon )
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP6,
							function(inObject, inRefcon)
								XP12Carrier_instance[5] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP6 = inObject
							end,
							inRefcon )
				   XPLM.XPLMLoadObjectAsync(Prefilled_XP12CarrierP7,
							function(inObject, inRefcon)
								XP12Carrier_instance[6] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefXP12CarrierP7 = inObject
							end,
							inRefcon )

				end
			end
		end
	end

	function load_Chocks()

		Chocks_91=XPlane_Ramp_Equipment_directory   .. "Chocks_3.obj"
		Chocks_92=XPlane_Ramp_Equipment_directory   .. "Chocks_2.obj"
		Chocks_93=XPlane_Ramp_Equipment_directory   .. "Chocks_1.obj"

		Chocks_91= SCRIPT_DIRECTORY    .. "/Simple_Ground_Equipment_and_Services/Ground_carts/SGES_chocks_small.obj"
		Chocks_92= SCRIPT_DIRECTORY    .. "/Simple_Ground_Equipment_and_Services/Ground_carts/SGES_chocks_small_back.obj"
		if math.abs(BeltLoaderFwdPosition) > 6 then
			Chocks_91= SCRIPT_DIRECTORY    .. "/Simple_Ground_Equipment_and_Services/Ground_carts/SGES_chocks_large.obj"
			Chocks_92= SCRIPT_DIRECTORY    .. "/Simple_Ground_Equipment_and_Services/Ground_carts/SGES_chocks_large.obj"
		end
		--~ if SGES_BushMode and IsXPlane12 then
			--~ Chocks_91=XPlane12_BushObjects_directory   .. "../natural/emb_stones1m_01.obj"
			--~ Chocks_92=XPlane12_BushObjects_directory   .. "../natural/emb_stones1m_02.obj"
			--~ Chocks_93=XPlane12_BushObjects_directory   .. "../natural/emb_stones1m_03.obj"
		--~ end


	  if Clairmarais_Aerodrome_directory ~= nil then Clairmarais_Aerodrome_lib() end

		if Chocks_instance[0] == nil then
		-- note that when there is only one instance, the instance array index must be 0, NOT 1.
		-- otherwise, xplane will crash --> hey that looks pretty normal since 0 is the first case. GF
			--print("load_chocks")
			--- GROUND HANDLING

			   --print("[Ground Equipment " .. version_text_SGES .. "] load_Chocks 1")
			   XPLM.XPLMLoadObjectAsync(Chocks_91,
						function(inObject, inRefcon)
						Chocks_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref91 = inObject
						end,
						inRefcon )
		end
		if Chocks_instance[1] == nil then
			   --print("[Ground Equipment " .. version_text_SGES .. "] load_Chocks 2")
			   XPLM.XPLMLoadObjectAsync(Chocks_92,
						function(inObject, inRefcon)
						Chocks_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref92 = inObject
						end,
						inRefcon )
		end
		if Chocks_instance[2] == nil then
			   --print("[Ground Equipment " .. version_text_SGES .. "] load_Chocks 3")
			   XPLM.XPLMLoadObjectAsync(Chocks_92,
						function(inObject, inRefcon)
						Chocks_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref93 = inObject
						end,
						inRefcon )
		end
	end

	function load_Deice()
		if Deice_instance[0] == nil and Deice_0_show_only_once then
		   --print("[Ground Equipment " .. version_text_SGES .. "] load Deicing service Object " .. Prefilled_DeiceObject)
		   XPLM.XPLMLoadObjectAsync(Prefilled_DeiceObject,
					function(inObject, inRefcon)
						Deice_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref100 = inObject
					end,
					inRefcon )
			Deice_0_show_only_once = false
		end
		if Deice_instance[1] == nil and Deice_1_show_only_once then
		   --print("[Ground Equipment " .. version_text_SGES .. "] load Deicing service Object " .. Prefilled_DeiceObject2)
		   XPLM.XPLMLoadObjectAsync(Prefilled_DeiceObject2,
					function(inObject, inRefcon)
						Deice_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref101 = inObject
					end,
					inRefcon )
			Deice_1_show_only_once = false
		end

		if Dayonly_deicing_truck_01 ~= nil and BeltLoaderFwdPosition > ULDthresholdx and Deice_instance[2] == nil and Deice_2_show_only_once then
		   --print("[Ground Equipment " .. version_text_SGES .. "] load Deicing service Object " .. Prefilled_DeiceObject2)
		   XPLM.XPLMLoadObjectAsync(Dayonly_deicing_truck_01,
					function(inObject, inRefcon)
						Deice_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref102 = inObject
					end,
					inRefcon )
			Deice_2_show_only_once = false
		end

	end

	function load_Baggage()
		math.randomseed(os.time())

		if Baggage_instance[0] == nil and baggage_show_only_once then
			randomView = math.random()
			if randomView > 0.7 then
				BaggageObject=XPlane_Ramp_Equipment_directory   .. "baggage_troll_07.obj" -- the red anbd brown
			elseif randomView < 0.2 then
				BaggageObject=XPlane_Ramp_Equipment_directory   .. "baggage_troll_01.obj" -- the grey
			else
				BaggageObject=XPlane_Ramp_Equipment_directory   .. "baggage_troll_02.obj" -- the black
			end

			-- LD3 loading instead of baggage
			if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject then
				randomView = math.random()
				if BeltLoaderFwdPosition > 12 then
					if randomView > 0.4 then
						BaggageObject=XPlane_Ramp_Equipment_directory   .. "container_LD3_01.obj" -- the metalic LD3
					else
						BaggageObject=XPlane_Ramp_Equipment_directory   .. "container_LD3_03.obj" -- the orange LD3
					end
				else -- narrow body airliners permit only small containers
					if randomView > 0.4 then
						BaggageObject=XPlane_Ramp_Equipment_directory   .. "container_LD3-45_01.obj" -- the metalic LD3-45
					else
						BaggageObject=XPlane_Ramp_Equipment_directory   .. "container_LD3-45_02.obj" -- the white LD3-45
					end

				end
			end

			XPLM.XPLMLoadObjectAsync(BaggageObject,
						function(inObject, inRefcon)
							Baggage_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefBaggage = inObject
						end,
						inRefcon )



			if ULDLoader_instance[1] == nil and CargoDeck_ULDLoaderPlateObject ~= nil and Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and string.find(Prefilled_ULDLoaderObject,"cargo_loader_ch70w") then
			   XPLM.XPLMLoadObjectAsync(CargoDeck_ULDLoaderPlateObject,
						function(inObject, inRefcon)
							ULDLoader_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref722 = inObject
						end,
						inRefcon )
			end


			baggage_show_only_once = false
		end

		if Prefilled_BeltLoaderObject ~= Prefilled_ULDLoaderObject and Baggage_instance[1] == nil and baggage1_show_only_once then
			-- that should not be changed by the other bagagge disappearance, but I can see that, strange
			randomView = math.random()
			if randomView > 0.8 then
				Baggage1Object=XPlane_Ramp_Equipment_directory   .. "baggage_troll_08.obj" -- the 3 luggages
			elseif randomView < 0.3 then
				Baggage1Object=XPlane_Ramp_Equipment_directory   .. "baggage_troll_01.obj" -- the grey
			else
				Baggage1Object=XPlane_Ramp_Equipment_directory   .. "baggage_troll_02.obj" -- the black
			end
		    XPLM.XPLMLoadObjectAsync(Baggage1Object,
						function(inObject, inRefcon)
							Baggage_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefBaggage1 = inObject
						end,
						inRefcon )
			baggage1_show_only_once = false
		end

		if Baggage_instance[2] == nil and baggage2_show_only_once then

			if IsPassengerPlane == 0 then
				Baggage2Object=XPlane_Ramp_Equipment_directory   .. "cont_dolly_LD3_1.obj"
			elseif military == 1 or military_default == 1 then
				Baggage2Object=XPlane_Ramp_Equipment_directory   .. "pallet_04.obj"
			else
				randomView = math.random()
				if randomView > 0.5 then
					Baggage2Object=XPlane_Ramp_Equipment_directory   .. "baggage_8f_6.obj"
				else
					Baggage2Object=XPlane_Ramp_Equipment_directory   .. "baggage_8f_2.obj"
				end
			end
		    XPLM.XPLMLoadObjectAsync(Baggage2Object,
						function(inObject, inRefcon)
							Baggage_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefBaggage2 = inObject
						end,
						inRefcon )
			baggage2_show_only_once = false
		end

		------ human handlers :
		if show_RearBeltLoader  then
			if Baggage_instance[3] == nil and baggage3_show_only_once and not UseXplaneDefaultObject then
				if IsPassengerPlane == 0 then
					Baggage3Object = Prefilled_GenericDriverObject_anim
				elseif military == 1 or military_default == 1 then
					Baggage3Object = Prefilled_PassengerMilObject
				else
					randomView = math.random()
					if randomView > 0.5 then
						Baggage3Object = Prefilled_GenericDriverObject_anim
					else
						Baggage3Object = Prefilled_GenericDriverObject_anim
					end
				end
				--~ print("LOAD baggage3 = rear handler")
				XPLM.XPLMLoadObjectAsync(Baggage3Object,
							function(inObject, inRefcon)
								Baggage_instance[3] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefBaggage3 = inObject
							end,
							inRefcon )
				baggage3_show_only_once = false
			end
		end

		-- front handler
		if Baggage_instance[4] == nil and baggage4_show_only_once and not UseXplaneDefaultObject   then
			Baggage4Object = Prefilled_GenericDriverObject_anim
		    XPLM.XPLMLoadObjectAsync(Baggage4Object,
						function(inObject, inRefcon)
							Baggage_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefBaggage4 = inObject
						end,
						inRefcon )
			baggage4_show_only_once = false
		end


	end

	function load_ULD()
		if Baggage_instance[5] == nil and baggage5_show_only_once and not UseXplaneDefaultObject then

			if IsXPlane12 and (military_default == 1 or military == 1) then
				Prefilled_ULDObject = XPlane12_ford_carrier_accessories_directory   .. "Cartridge_Pallet.obj"
			--~ elseif BeltLoaderFwdPosition >= ULDthresholdx then
				--~ Prefilled_ULDObject 	= SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/ULD.obj"
			--~ else
				--~ Prefilled_ULDObject 	= SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/ULD_halfsized.obj"
			--~ end
			else
				Prefilled_ULDObject 	= SCRIPT_DIRECTORY ..  "Simple_Ground_Equipment_and_Services/MisterX_Lib/ULDLoader/ULD.obj"
			end
			   print("[Ground Equipment " .. version_text_SGES .. "]  Load the Cargo ULD once.")
			   XPLM.XPLMLoadObjectAsync(Prefilled_ULDObject,
						function(inObject, inRefcon)
							Baggage_instance[5] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefBaggage5 = inObject
						end,
						inRefcon )
			baggage5_show_only_once = false
		end
	end

	function load_Light()
		if Light_instance[0] == nil then
			   --print("[Ground Equipment " .. version_text_SGES .. "] load Light Object " .. Prefilled_LightObject)
			   XPLM.XPLMLoadObjectAsync(Prefilled_LightObject,
						function(inObject, inRefcon)
							Light_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampserviceref200 = inObject
						end,
						inRefcon )
		end
	end

	function load_CockpitLight()
		--if CockpitLight_show_only_once then
			if CockpitLight_instance[0] == nil then
				   --print("[Ground Equipment " .. version_text_SGES .. "] load Cockpit Light Object " .. Prefilled_LightObject)
				   XPLM.XPLMLoadObjectAsync(Prefilled_CockpitLightObject,
							function(inObject, inRefcon)
								CockpitLight_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefCockpitLight = inObject
							end,
							inRefcon )
				   print("[Ground Equipment " .. version_text_SGES .. "] loaded Cockpit night ambiance.")
			end
		    CockpitLight_show_only_once = false
		--end
	end

	function load_AAR()
		if AAR_instance[0] == nil then
				-- FMOD Crash
				show_SAM = false
				SAM_chg = true
			   --~ print("[Ground Equipment " .. version_text_SGES .. "] load AAR " .. Prefilled_AAR_object)
			   XPLM.XPLMLoadObjectAsync(Prefilled_AAR_object,
						function(inObject, inRefcon)
							AAR_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefAAR = inObject
						end,
						inRefcon )
		end
	end

	function determine_airstairtype()
		if SGES_stairs_type == "New_Small" then
			Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY  ..  "Simple_Ground_Equipment_and_Services/Airstairs/new/small/MobileAirstairsBase_small.obj"
			Prefilled_StairsXPJObject 	= SCRIPT_DIRECTORY   	.. 	"Simple_Ground_Equipment_and_Services/Airstairs/new/small/MobileAirstairsSlider_small.obj"
			Prefilled_StairsXPJ2Object 		= Prefilled_StairsXPJObject
			Prefilled_StairsXPJ2Object_base = Prefilled_StairsXPJObject_base
		elseif SGES_stairs_type == "Boarding_without_stairs" then -- I have decided to make that transparent, no stairs, as if the aircraft ladder was used.
			Prefilled_StairsXPJObject 		= Prefilled_LightObject
			Prefilled_StairsXPJObject_base 	= XPlane_objects_directory   .. "../apt_lights/slow/inset_edge_rwy_WW.obj"
			-- display a red carpet for VIP, when not in the bush, when a small aircraft, and only in certain geograpical areas. And when the airport apro nis flat (ConeObject1 == Linked_cones)
			if not SGES_BushMode and Transporting_Jetsetpeople ~= nil and Transporting_Jetsetpeople and show_Cones then
				if (LATITUDE > 36 and LATITUDE < 55) and (LONGITUDE > -5 and LONGITUDE < 19) then -- Occidental Europe
					Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Red_carpet.obj"
				    print("[Ground Equipment " .. version_text_SGES .. "] Red carpet for VIP (Europe).")
				elseif  (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69) then -- East Coast USA
					Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Red_carpet.obj"
				    print("[Ground Equipment " .. version_text_SGES .. "] Red carpet for VIP (USA).")
				end
			end
			Prefilled_StairsXPJ2Object 		= Prefilled_StairsXPJObject
			Prefilled_StairsXPJ2Object_base = Prefilled_StairsXPJObject_base
		else
			if show_FireVehicle then
				Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY  ..  "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsBase_EMS.obj"
				Prefilled_StairsXPJObject 	= SCRIPT_DIRECTORY   	.. 	"Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider_EMS.obj"
			elseif military == 1 or military_default == 1 then
				Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY  ..  "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsBase_Mil.obj"
				Prefilled_StairsXPJObject 	= SCRIPT_DIRECTORY   	.. 	"Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider_Mil.obj"
			else
				Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY  ..  "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsBase.obj"
				Prefilled_StairsXPJObject 	= SCRIPT_DIRECTORY   	.. 	"Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider.obj"
				if string.match(PLANE_ICAO,"A20N") or PLANE_ICAO == "A306" or string.match(PLANE_ICAO,"A33") then
					Prefilled_StairsXPJObject 		= SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider_Blue.obj"
				end
			end
			Prefilled_StairsXPJ2Object 		= Prefilled_StairsXPJObject
			Prefilled_StairsXPJ2Object_base = Prefilled_StairsXPJObject_base
			if sges_big_airport and not show_FireVehicle then -- front stairs only
				Prefilled_StairsXPJObject_base 	= SCRIPT_DIRECTORY  ..  "Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsBase_Servisair.obj"
				Prefilled_StairsXPJObject 	= SCRIPT_DIRECTORY   	.. 	"Simple_Ground_Equipment_and_Services/Airstairs/new/normal/MobileAirstairsSlider_Servisair_rain.obj"
			end
		end
		--print("[Ground Equipment " .. version_text_SGES .. "] loading stairs and selecting stairs model " .. SGES_stairs_type)
	end


	function load_StairsXPJ()
		if 	StairsXPJ_0_show_only_once then
			if StairsXPJ_instance[0] == nil then
				   determine_airstairtype()
				   --print("[Ground Equipment " .. version_text_SGES .. "] load custom stairs Object " .. Prefilled_StairsXPJObject)
				   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJObject,
							function(inObject, inRefcon)
								StairsXPJ_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampserviceref300 = inObject
							end,
							inRefcon )
			end
			StairsXPJ_0_show_only_once = false
		end
		if StairsXPJ_1_show_only_once then
			if StairsXPJ_instance[1] == nil then
				   --print("[Ground Equipment " .. version_text_SGES .. "] load custom stairs base Object " .. Prefilled_StairsXPJObject_base)
				   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJObject_base,
							function(inObject, inRefcon)
								StairsXPJ_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampserviceref301 = inObject
							end,
							inRefcon )
			end
			StairsXPJ_1_show_only_once = false
		end
	end

	function load_StairsXPJ2()
		if StairsXPJ2_instance[0] == nil and StairsXPJ2_0_show_only_once then
		   determine_airstairtype()
		   --print("[Ground Equipment " .. version_text_SGES .. "] load custom stairs 2 Object " .. Prefilled_StairsXPJObject)
		   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJ2Object,
					function(inObject, inRefcon)
						StairsXPJ2_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref302 = inObject
					end,
					inRefcon )
			StairsXPJ2_0_show_only_once = false
		end
		if StairsXPJ2_instance[1] == nil and StairsXPJ2_1_show_only_once then
		   --print("[Ground Equipment " .. version_text_SGES .. "] load custom stairs 2 base Object " .. Prefilled_StairsXPJObject_base)
		   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJ2Object_base,
					function(inObject, inRefcon)
						StairsXPJ2_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref303 = inObject
					end,
					inRefcon )
			StairsXPJ2_1_show_only_once = false
		end
	end


	function load_StairsXPJ3()
		if StairsXPJ3_instance[0] == nil and StairsXPJ3_0_show_only_once then
		   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJObject,
					function(inObject, inRefcon)
						StairsXPJ3_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref304 = inObject
					end,
					inRefcon )
			StairsXPJ3_0_show_only_once = false
		end
		if StairsXPJ3_instance[1] == nil and StairsXPJ3_1_show_only_once then
		   XPLM.XPLMLoadObjectAsync(Prefilled_StairsXPJObject_base,
					function(inObject, inRefcon)
						StairsXPJ3_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampserviceref305 = inObject
					end,
					inRefcon )
			StairsXPJ3_1_show_only_once = false
		end
	end

	function load_TargetSelfPushback()
		if TargetSelfPushback_show_only_once then
			if TargetSelfPushback_instance[0] == nil then
				   --print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_TargetSelfPushback Object " .. Prefilled_TargetSelfPushbackObject)
				   XPLM.XPLMLoadObjectAsync(Prefilled_TargetSelfPushbackObject,
							function(inObject, inRefcon)
								TargetSelfPushback_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefTargetSelfPushback = inObject
							end,
							inRefcon )
			end
			TargetSelfPushback_show_only_once = false
		end
	end


	function load_TargetMarker()
		if TargetMarker_show_only_once then
			if TargetMarker_instance[0] == nil then
				   --print("[Ground Equipment " .. version_text_SGES .. "] load Prefilled_TargetMarker Object " .. Prefilled_TargetMarkerObject)
				   XPLM.XPLMLoadObjectAsync(Prefilled_TargetMarkerObject,
							function(inObject, inRefcon)
								TargetMarker_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefTargetMarker = inObject
							end,
							inRefcon )
			end
			TargetMarker_show_only_once = false
		end
	end


	function load_Ponev()
		if Ponev_show_only_once then
			if Ponev_instance[0] == nil then
			-- note that when there is only one instance, the instance array index must be 0, NOT 1.
			-- otherwise, xplane will crash --> hey that looks pretty normal since 0 is the first case. GF
				--print("[Ground Equipment " .. version_text_SGES .. "] 5 load_rampserviceD _PushBack")
				   XPLM.XPLMLoadObjectAsync(Prefilled_Ponev,
							function(inObject, inRefcon)
								Ponev_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
								rampservicerefPonev = inObject
							end,
							inRefcon )
			end
			Ponev_show_only_once = false
		end
	end

	function load_ASU_ACU()
		if ASU_ACU_instance[0] == nil and ASU_show_only_once then
		   --print("[Ground Equipment " .. version_text_SGES .. "] load ASU_ACU Object " .. Prefilled_ASU_ACU)
		   XPLM.XPLMLoadObjectAsync(Prefilled_ASU_ACU,
					function(inObject, inRefcon)
						ASU_ACU_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefASU_ACU = inObject
					end,
					inRefcon )
			if Prefilled_ASU_duct ~= nil and ASU_ACU_instance[1] == nil then
			   --print("[Ground Equipment " .. version_text_SGES .. "] load ASU_ACU Object " .. Prefilled_ASU_ACU)
				randomView = math.random()
				if randomView > 0.25 then
					Prefilled_ASU_duct = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/SGES_ASU_duct.obj"
				else
					Prefilled_ASU_duct = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/SGES_ASU_duct2.obj" -- full orange
				end
			   XPLM.XPLMLoadObjectAsync(Prefilled_ASU_duct
,
						function(inObject, inRefcon)
							ASU_ACU_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							rampservicerefASU_ACU1 = inObject
						end,
						inRefcon )
			end
			ASU_show_only_once = false
		end
	end

	function load_Forklift()
		if Forklift_instance[0] == nil and Forklift_show_only_once then

		if military == 1 or military_default == 1 then ForkliftObject = Prefilled_MilForkliftObject else ForkliftObject = Prefilled_ForkliftObject end
		   XPLM.XPLMLoadObjectAsync(ForkliftObject,
					function(inObject, inRefcon)
						Forklift_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefForklift = inObject
					end,
					inRefcon )
			Forklift_show_only_once = false
		end
	end

	----------------- end of Load functions -------------------------------------



	function coordinates_of_adjusted_ref_rampservice(plane_x, plane_z, in_delta_x, in_delta_z, in_heading )
		-- in_delta_x refers to the difference between the x coordinates (left/right) of the ref pt and the shifted position
		-- in_delta_z refers to the difference between the z coordinates (up/down) of the ref pt and the shifted position
		-- If the shifted position is below the ref pt, in_delta_z is negative.
		-- If the shifted position is to the right of the ref pt, in_delta_x is positive
		-- in_heading is the heading that the ref pt is facing
		-- in_ref_x, in_ref_z refers to the ref point which we know the x, z coordinates and we are using that to determine the shifted pos coordinates
		l_dist = math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) )
		l_heading = math.fmod ( ( math.deg ( math.atan2 ( in_delta_x , in_delta_z  ) ) + 360 ),  360 )
		g_shifted_x  =  plane_x - math.sin ( math.rad ( in_heading - l_heading) ) * l_dist * -1
		g_shifted_z  =  plane_z -  math.cos ( math.rad ( in_heading - l_heading) ) *  l_dist
		g_shifted_y = sges_gs_plane_y[0]
	end

	function coordinates_of_nose_gear(plane_x, plane_z, in_delta_x, in_delta_z, in_heading )

	  l_dist = math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) )
	  l_heading = math.fmod ( ( math.deg ( math.atan2 ( in_delta_x , in_delta_z  ) ) + 360 ),  360 )
	  nose_x  =  plane_x - math.sin ( math.rad ( in_heading - l_heading) ) * l_dist * -1
	  nose_z  =  plane_z  -  math.cos ( math.rad ( in_heading - l_heading) ) *  l_dist

	end
	--local message_time = sges_current_time - 60
	local Accident_x,Accident_y,Accident_z
	--local message_done = 2

	function Recompute_ref_rampservice(plane_x, plane_z, in_target_x, in_target_z, in_heading, in_target_y )
		if in_target_x ~= nil then
		  in_delta_x = plane_x - in_target_x
		  in_delta_z = plane_z - in_target_z
		  -- in_delta_x refers to the difference between the x coordinates (left/right) of the ref pt and the shifted position
		  -- in_delta_z refers to the difference between the z coordinates (up/down) of the ref pt and the shifted position
		  -- If the shifted position is below the ref pt, in_delta_z is negative.
		  -- If the shifted position is to the right of the ref pt, in_delta_x is positive
		  -- in_heading is the heading that the ref pt is facing
		  -- in_ref_x, in_ref_z refers to the ref point which we know the x, z coordinates and we are using that to determine the shifted pos coordinates

		  AccidentSite_Distance = math.floor(math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) ))
		  AccidentSite_heading = math.fmod ( ( math.deg ( math.atan2 ( in_delta_x , in_delta_z  ) ) + 360 ),  360 )
		  AccidentSite_absolute_heading = math.floor(360-AccidentSite_heading )
		  AccidentSite_relative_heading = math.floor(AccidentSite_absolute_heading-in_heading)
		  if AccidentSite_relative_heading < 0 then AccidentSite_relative_heading = math.floor(AccidentSite_absolute_heading+360-in_heading) end
		  --print("AccidentSite_relative_heading " .. AccidentSite_relative_heading)
		  AccidentSite_Delta_altitude = math.floor((sges_gs_plane_y[0]-target_y)*10)/10

		  -- corrective factor, because of the height of the aircraft CG in AGL.
		  Accident_x,Accident_y,Accident_z=local_to_latlon(in_target_x,in_target_y,in_target_z)
		  --print("Target lat " .. math.floor(Accident_x*100)/100 .. " Target Lon " .. math.floor(Accident_z*100)/100 .. " Target altitude " .. math.floor(Accident_y*10)/10 .. " meters (" .. math.floor(Accident_y * 3*10)/10 .. " ft)")
		end
	end

	--------------------------------------------------------------------------------

	function local_to_latlon(l_x, l_y, l_z)

	  x1_value[0] = l_x
	  y1_value[0] = l_y
	  z1_value[0] = l_z

	  -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
	  XPLM.XPLMLocalToWorld(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

	  return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being

	end


	function latlon_to_local(in_lat, in_lon, in_alt)

	  x1_value[0] = in_lat
	  y1_value[0] = in_lon
	  z1_value[0] = in_alt

	  -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
	  XPLM.XPLMWorldToLocal(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

	  return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being

	end



	function probe_y (in_x, in_y, in_z)

	  local l_lat, l_on, l_alt = 0, 0, 0

	  x1_value[0] = in_x
	  y1_value[0] = in_y
	  z1_value[0] = in_z
	  --terrain_nature[0] = is_wet
	  XPLM.XPLMProbeTerrainXYZ(proberef, x1_value[0], y1_value[0], z1_value[0], probeinfo_addr)
	  probeinfo_value = probeinfo_addr --XPLMProbeInfo_t
	  l_lat, l_lon, l_alt = local_to_latlon(probeinfo_value[0].locationX, probeinfo_value[0].locationY, probeinfo_value[0].locationZ)
	  in_x, in_y, in_z = latlon_to_local(l_lat, l_lon, l_alt)
	  local wet = probeinfo_value[0].is_wet -- is Wet is a boolean, 0 not over water, 1 over water.  --IAS24 make it local !
	  --~ print("--------- SGES : Probed terrain at height " .. in_y .." and it is wet =" .. wetness)

	  return in_y,wet --IAS24

	end

	function load_probe()

	  probeinfo_value[0].structSize = ffi.sizeof(probeinfo_value[0])
	  probeinfo_addr = probeinfo_value
	  probetype[1] = 0
	  proberef =  XPLM.XPLMCreateProbe(probetype[1])

	end


	function probe_door()
		coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], targetDoorX, -targetDoorZ, sges_gs_plane_head[0])
		return sges_gs_plane_y[0] + vertical_door_position - 2.82
	end

	function OnScenery(x,z,y,hdg,title,flag)
		if title ~= nil then print("[Ground Equipment " .. version_text_SGES .. "] Drawing the " .. title) end
		if y == nil then y = probe_y (x, y, z) end -- altitude
		ground,wetness = probe_y (x, y, z)
		--if wetness ~= nil then print("[Ground Equipment " .. version_text_SGES .. "] Wetness the " .. wetness) end
		objpos_value[0].x = x
		objpos_value[0].z = z
		objpos_value[0].pitch = 0
		if flag ~= nil and (flag == "possible_military") then -- X-Trident objects are low
			objpos_value[0].y = ground + milheight
			-- when using the civilian passenger bus, that makes it float higher than normal, so I make the follwoing PATCH :
		elseif flag ~= nil and flag == "military_Bus"  then
				objpos_value[0].y = ground + 1.1  -- I have fixed the milheight to be able to mix x-trident and non-x-trident assets (BUS)
		elseif flag ~= nil and flag == "military_FM"  then
				objpos_value[0].y = ground + 1.1  -- I have fixed the milheight to be able to mix x-trident and non-x-trident assets (FM)
		elseif flag ~= nil and (flag == "grd2stairs") then -- passenger on ground (with 3D corrective factor)
			objpos_value[0].y = ground - 0.05
		elseif flag ~= nil and (flag == "stairs") then -- climbing passenger NOT on ground
			objpos_value[0].y = y
		elseif flag ~= nil and (flag == "ASU_ACU") and Prefilled_ASU_ACU ~= User_Custom_Prefilled_ASUObject then -- object not on ground due to 3D
			objpos_value[0].y = ground + 4.28
		--~ elseif flag ~= nil and (flag == "BusLight") then -- object not on ground due to 3D
			--~ objpos_value[0].y = ground - 1
		elseif flag ~= nil and (flag == "PRMLight") then -- object not on ground due to 3D
			objpos_value[0].y = ground - 0.45
		elseif flag ~= nil and (flag == "TargetMarker") and approaching_TargetMarker >= 3 then -- object not on ground due to 3D
				objpos_value[0].y = ground - 1.5 -- burry partially the ramp marker -- this is with MARSHALLER MANUAL MODE ONLY
		elseif  flag ~= nil and (flag == "CateringHighPart") then  -- Catering high at the door level if 3D in range
			local targetAltitudeCatering = ground

			--if StairFinalH_stairIV ~= 0 then targetAltitudeCatering = StairFinalH_stairIV + 2.8 -- no because of PRM
			if StairFinalH_stairIII ~= 0 then targetAltitudeCatering = StairFinalH_stairIII + 2.8
			else  targetAltitudeCatering = probe_door() targetAltitudeCatering = targetAltitudeCatering + 2.8
			end
				--print(targetAltitudeCatering)
			-- the 3D geometry of the catering object is limiting :
			local maxAltitude = ground + 1.6
			local minAltitude = ground - 0.45
			if minAltitude <= targetAltitudeCatering and targetAltitudeCatering <= maxAltitude then targetAltitudeCatering = targetAltitudeCatering
			elseif targetAltitudeCatering > maxAltitude then targetAltitudeCatering = maxAltitude -- keep that in 3D range
			elseif targetAltitudeCatering < minAltitude then targetAltitudeCatering = minAltitude -- keep that in 3D range
			end
			objpos_value[0].y = targetAltitudeCatering

		elseif flag ~= nil and (flag == "Ship1") then -- SMALL FISHING BOAT
			math.randomseed(os.time())
			randomView = math.random()
			if randomView > 0.5 then
				objpos_value[0].roll = 40 + 0.135 * sges_wind[0]
				objpos_value[0].y = ground-3 -- at sea level, always. So it's hidden when triggered over land
			else
				objpos_value[0].roll = 5 + 0.135 * sges_wind[0]
				objpos_value[0].y = ground-1 -- at sea level, always. So it's hidden when triggered over land
			end
			objpos_value[0].pitch = -1
		elseif flag ~= nil and (flag == "Ship2") then
			objpos_value[0].roll = 5
			math.randomseed(os.time())
			randomView = math.random()
			if randomView > 0.75 then
				objpos_value[0].roll = 22
			end
			objpos_value[0].y = ground-5 -- at sea level, always. So it's hidden when triggered over land
			groundPitch[flag] = 2 + 0.25 * math.abs(sges_wind[0])
			randomView = math.random()
			if randomView <= 0.1 then
				groundPitch[flag] = groundPitch[flag] - 10
			end
			objpos_value[0].pitch = groundPitch[flag]
		elseif wetness == 1 then
			objpos_value[0].y = ground - 1.5 -- swimming stuff when over water
		else
			objpos_value[0].y = ground
		end
		if flag ~= nil and (flag == "Pushback") then --bar
			groundPitch[flag] = 5
			if IsXPlane1209 then
				groundPitch[flag] = 7
				objpos_value[0].y = objpos_value[0].y - 0.3
			end

			if (FFSTS_777v2_Directory ~= nil and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") or Prefilled_PushBackObject == SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj") then

				groundPitch[flag] = 0
				objpos_value[0].y = ground
			end
			objpos_value[0].pitch = groundPitch[flag]
		end

		objpos_value[0].heading = hdg
		if flag ~= nil and (flag == "ASU_ACU") and Prefilled_ASU_ACU == User_Custom_Prefilled_ASUObject then
			objpos_value[0].heading = hdg - 90
		end

		if flag ~= nil and Clairmarais_Aerodrome_directory ~= nil and Prefilled_FMObject == Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj" and (flag == "Catering" or flag == "Cleaning" or flag == "PRM" or flag == "Clairmarais")then
			objpos_value[0].heading = hdg + 180
			if flag == "PRM" then objpos_value[0].z = objpos_value[0].z - 5 end
		end

		float_value[0] = 0
		objpos_addr = objpos_value
		float_addr = float_value
		if wetness == 0 and flag ~= nil and string.match(flag,"Ship") then
				show_Ship1 = false
				show_Ship2 = false
				Ship1_chg = true
				Ship2_chg = true
			end
		return objpos_addr, float_addr, wetness
	end
	--------------------------------------------------------------------------------


	--------------------------------------------------------------------------------


	function draw_static_object(placeToBeX,placeToBeZ,object_hdg_corr,Instance,object_name)
		-- MIRROR
		if SGES_mirror == 1 then
			placeToBeX = -1 * placeToBeX
			object_hdg_corr = object_hdg_corr + 180
		end
		--print("[Ground Equipment " .. version_text_SGES .. "]  draw_static_object at " .. placeToBeX .. ", " .. placeToBeZ)
		if object_name ~= nil and Instance ~= nil and placeToBeX ~= nil and placeToBeZ ~= nil then
			if object_hdg_corr == nil then object_hdg_corr = 0 end
			local reference_x = sges_gs_plane_x[0]
			local reference_z = sges_gs_plane_z[0]
			local reference_heading = sges_gs_plane_head[0]
			if object_name == "StopSign" or object_name == "Arms" then -- the marshaller is referenced to the final destination (changed for that option 4/11/23)
				reference_x = TargetMarkerX_stored
				reference_z = TargetMarkerZ_stored
				print("body z = " .. reference_z)
				if automatic_marshaller_requested then
					reference_heading = retained_parking_position_heading
				end
				print("[Ground Equipment " .. version_text_SGES .. "] the reference as anchor :  " .. reference_x .. ", " .. reference_z .. ", " .. math.floor(reference_heading)) -- place the static carrier on world coordinates as required
				print("[Ground Equipment " .. version_text_SGES .. "] placing the Marshaller on " .. TargetMarkerX_stored .. ", " .. TargetMarkerZ_stored .. ", " .. math.floor(reference_heading)) -- place the static carrier on world coordinates as required
			end

			if object_name == "Arms" then
				if distance_to_sges_stand ~= nil then
					--~ --(1.4 * distance_to_sges_stand) -20 = 12
					--~ --32 = 1.4 * distance_to_sges_stand
					--~ --22,857 = distance_to_sges_stand
					reference_x = reference_x - (((1.4 * distance_to_sges_stand) -20)/22.857)*1.75
					-- lateral correction surprisingly :
					--~ reference_z = reference_z - (((1.4 * distance_to_sges_stand) -20)/22.857)/1.75
					--~ --reference_z = reference_z - (((1.4 * distance_to_sges_stand) -20)/22.857)
				end
			end

			if string.find(object_name,"Helicopter") then
				reference_heading = object_hdg_corr -- here, not a corr factor, but a permanent wind direction
				-- then reset to zero to avoid influence on object heading :
				object_hdg_corr = 0
				-- here this varuiable was only used ot carry the fixed wind direction
			end

			if string.find(object_name,"Submarine") then
				reference_heading = object_hdg_corr -- here, not a corr factor, but a permanent wind direction

				--but sometimes the sub needs to turn to avoid running aground --IAS24
				-- sub_turn is used to carry the information of the need of a turn. == 1 is we need to turn --IAS 24
				if sub_turn ~= nil and sub_turn ~= 0 and submarine_x ~= nil and submarine_z ~= nil and init_SGES_Sim_WindDir ~= nil then
					object_hdg_corr = sub_turn -- return object_hdg_corr to origin function in this case
					init_SGES_Sim_WindDir = init_SGES_Sim_WindDir + object_hdg_corr
					reference_heading = init_SGES_Sim_WindDir
					-- but the center of turn cannot anymore be the generating point (ie user coordinates)
					-- thus we replace the center of turn coordiante by the sub currents
					-- caution : placeToBeZ is used to check wetness !!
					reference_x = submarine_x
					reference_z = submarine_z
				else -- normal conditions
					-- here this variable was only used to carry the fixed wind direction
					-- store and fix the reference starting position
					reference_x = reference_x_sub -- reference_x_sub is initialized upon initial GUI sub request, once.
					reference_z = reference_z_sub
					-- then reset to zero to avoid influence on object heading :
					object_hdg_corr = 0
					--z_sub=z_sub+0.3 --dev
				end

			end

			coordinates_of_adjusted_ref_rampservice(reference_x, reference_z, placeToBeX, placeToBeZ, reference_heading)

			if IsXPlane12 and string.match(object_name,"XP12Carrier") and user_boat_lon ~= nil and user_boat_lat ~= nil then
				g_shifted_x,_,g_shifted_z = latlon_to_local(tonumber(user_boat_lat),tonumber(user_boat_lon),0)
				print("[Ground Equipment " .. version_text_SGES .. "] placing the boat on " .. g_shifted_x .. ", " .. g_shifted_z)
			end -- place the static carrier on world coordinates as required

			-- store the OGL coordinates of the submarine to allow landing on it. --IAS24
			if string.find(object_name,"Submarine") then
				submarine_x = g_shifted_x
				submarine_z = g_shifted_z
			end

			-- store the OGL coordinates to allow extinguising the fire
			if string.find(object_name,"FireSmoke") then
				wildfire_x = g_shifted_x
				wildfire_z = g_shifted_z
			end

			objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,reference_heading+object_hdg_corr,nil,object_name)
			local 	changed = object_name .. "_chg"
			local  objpos_target_value_y = ground -- default value

			if string.match(object_name,"TargetSelfPushback")   then -- NOP draw_from_simulator_coordinates
				--~ print("[Ground Equipment " .. version_text_SGES .. "] placing the TargetSelfPushback on " .. g_shifted_x .. ", " .. g_shifted_z .. ", wetness is " .. wetness)
				--~ print("[Ground Equipment " .. version_text_SGES .. "] but our aircraft is located on coords " .. reference_x .. ", " .. reference_z)
				objpos_target_value_y = ground + 3.5
				objpos_value[0].y = objpos_target_value_y
				wetness = 0 -- always depict the pushback target
			end
			if object_name == "Cleaning" and military == 1 then
				--~ object_hdg_corr = object_hdg_corr - 90
				objpos_target_value_y = ground + milheight
				objpos_value[0].y = objpos_target_value_y
			end
			if object_name == "Helicopter" then

				if show_FireVehicle then
					objpos_target_value_y = ground + 30
					else
					objpos_target_value_y = ground + 23  --+ 20 is barely above the aircraft carrier deck
				end
				objpos_value[0].y = objpos_target_value_y
				if wetness == 1 then objpos_target_value_y = ground + 30 end
				objpos_value[0].pitch = pitch_hel
			end
			if object_name == "Helicopter1" then
				objpos_target_value_y = ground + 50
				objpos_value[0].y = objpos_target_value_y
				objpos_value[0].pitch = pitch_hel
			end


			if object_name == "Submarine" then
				if math.abs(sges_gs_gnd_spd[0]) > 20 and (string.find(User_Custom_Prefilled_SubmarineObject,"Akula") or string.find(User_Custom_Prefilled_SubmarineObject,"Virginia") or string.find(User_Custom_Prefilled_SubmarineObject,"581")) then
					-- the submarine is diving with aircaft speed.
					-- we limit that to our sumarine to allow other moving objects
					objpos_target_value_y = ground - math.abs(sges_gs_gnd_spd[0]/20) - 0.8 + 1
				objpos_value[0].y = objpos_target_value_y
				else
					objpos_target_value_y = ground - 0.8
				objpos_value[0].y = objpos_target_value_y
				end
				--~ objpos_target_value_y = ground + 10 -- for DEV
			end
			if object_name == "CockpitLight" then -- the cockpit night ambiance light source is at the head altitude
				objpos_target_value_y = 	g_shifted_y + get("sim/graphics/view/pilots_head_y")
				objpos_value[0].y = objpos_target_value_y
				--objpos_value[0].pitch = get("sim/graphics/view/pilots_head_the") / 1.5
			end

			if object_name == "BeltLoader" and PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" and military_default == 1 then
				objpos_target_value_y = ground - 2.6 -- (E4B modification)
				objpos_value[0].y = objpos_target_value_y
			end


			if object_name == "Baggage" then
				objpos_target_value_y = ground + baggage_vert
				objpos_value[0].y = objpos_target_value_y
				if placeToBeX < 0 and not string.find(BaggageObject,"LD") then objpos_value[0].pitch = 15 elseif not string.find(BaggageObject,"LD") then objpos_value[0].pitch = 1  end

			end

			if object_name == "ULDLoaderplate" then
				objpos_target_value_y = ground + plate_vert - 3.77
				objpos_value[0].y = objpos_target_value_y
			end


			if object_name == "Baggage1" then
				objpos_target_value_y = ground + baggage_vert1 - 0.05
				objpos_value[0].y = objpos_target_value_y
				if placeToBeX < 0 then objpos_value[0].pitch = 15 else objpos_value[0].pitch = 1  end
			end


			if object_name == "Baggage2" and (Baggage2Object==XPlane_Ramp_Equipment_directory   .. "baggage_8f_6.obj" or Baggage2Object==XPlane_Ramp_Equipment_directory   .. "baggage_8f_2.obj") then
				objpos_target_value_y = ground - 0.6  -- compensate the height of the object above the ground in 3D geometry
				objpos_value[0].y = objpos_target_value_y
			end
			if object_name == "Baggage3" or object_name == "Baggage4" then
				objpos_target_value_y = ground -0.05
				objpos_value[0].y = objpos_target_value_y
			end

			if object_name == "CargoULD" then
				objpos_target_value_y = ground + 3.68
				if ((string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) or CargoDeck_ULDLoaderObject == "low_variant") then
					objpos_target_value_y = ground + 1.82
				end
				objpos_value[0].y = objpos_target_value_y
			end


			--~ if object_name == "Chocks" and SGES_Author == "Gliding Kiwi" then
				--~ objpos_target_value_y = ground -0.035 -- we want a visual clue chocks are set but at the same time the orignial toliss chocks must be the sole visible
			if (object_name == "LeftChock" or object_name == "RightChock" ) and (SGES_Author == "Gliding Kiwi" or (AIRCRAFT_FILENAME == "AW109SP.acf" and PLANE_AUTHOR == "X-Trident")) then
				objpos_target_value_y = ground -2 --  the orignial toliss chocks must be the sole visible
				objpos_value[0].y = objpos_target_value_y
			end

			if object_name == "VDGSFixed" then
				objpos_target_value_y = ground - SGES_VDGS_object_geometry_factor
				objpos_value[0].y = objpos_target_value_y
			end

			------------------------------------------------
			-- apply the y target value.
			changed = false
			------------------------------------------------


			if object_name == "Arms" then
				print("arms z = " .. reference_z)
				if distance_to_sges_stand == nil then
					objpos_value[0].pitch = 0
					--~ --objpos_value[0].roll = 0
				else
					objpos_value[0].pitch = 0 -- TEMPO
					--~ --objpos_value[0].roll = distance_to_sges_stand / 2
				end
			end



			if (wetness == 0 and not string.match(object_name,"Ship") and not string.match(object_name,"XP12Carrier") and not string.find(object_name,"Submarine") ) or
			(wetness == 1 and (string.match(object_name,"Ship") or string.match(object_name,"XP12Carrier") or object_name == "AAR" or string.find(object_name,"Helicopter"))) or
			--~ ((wetness == 1 or sub_turn ~= 0) and string.find(object_name,"Submarine"))
			(wetness == 1 and string.find(object_name,"Submarine"))
			then
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)

				--~ if frame_counter_FPS_saver ~= nil and frame_counter_FPS_saver >= 99 and sub_turn ~= 0 then sub_turn = 0 end
			elseif not string.find(object_name,"Submarine") then
				print("[Ground Equipment " .. version_text_SGES .. "] Placing the part on scenery was prevented because terrain is water. That's desirable. (".. object_name .. ").")
			elseif string.find(object_name,"Submarine") then
				show_Submarine = false
				Submarine_chg = true
				sges_ship_cancelled_cause_land = true
				print("[Ground Equipment " .. version_text_SGES .. "] Tried to load a submarine or a surface vessel but there wasn't water ! I cancelled that action.")
			end
			objpos_value[0].roll = 0
			objpos_value[0].pitch = 0



			-- CLOSING ACTIONS --
			------------------------------------------------------------
			-- at the end to avoid interferences with objpos_addr
			if string.find(object_name,"Submarine") then --IAS24
				if frame_counter_FPS_saver == nil then frame_counter_FPS_saver = 9 end
				frame_counter_FPS_saver = frame_counter_FPS_saver + 1
				-- also probe ahead the terrain for water
				-- find the ahead coordinates where to probe :
				if frame_counter_FPS_saver >= 10 then
					-- on the left, probe port side
					--~ coordinates_of_adjusted_ref_rampservice(submarine_x, submarine_z, -100, 300, init_SGES_Sim_WindDir)
					coordinates_of_adjusted_ref_rampservice(submarine_x, submarine_z, 0, 600, init_SGES_Sim_WindDir)
					_,wetness_ahead = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)
					if wetness_ahead == 0 then
						-- arm a turn :
						--~ sub_turn = 0.0075
						sub_turn = 0.5 -- I finally cancelled the fine tuned appraoch for more coarese attitude, but it's saving performance and my testing time aldo, I perform only one terrain check ahead instrad of port / starboard checks
						reference_x_sub = submarine_x --critical to update the initial submarine reference point to the new center of turn
						reference_z_sub = submarine_z --critical to update the initial submarine reference point to the new center of turn
						z_sub = 0 						 --critical to update the initial submarine reference point to the new center of turn
					end
						-- on the right, probe if the left probe return there is still sea head., Now check starboard.
					--~ if wetness_ahead == 1 then
						--~ coordinates_of_adjusted_ref_rampservice(submarine_x, submarine_z, 100, 300, init_SGES_Sim_WindDir)
						--~ _,wetness_ahead = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)
						--~ if wetness_ahead == 0 then
							--~ -- arm a turn :
							--~ sub_turn = -0.0075
							--~ reference_x_sub = submarine_x --critical to update the initial submarine reference point to the new center of turn
							--~ reference_z_sub = submarine_z --critical to update the initial submarine reference point to the new center of turn
							--~ z_sub = 0 						 --critical to update the initial submarine reference point to the new center of turn
						--~ end
					--~ end
					-- fine tune the sub behaviour :
					if wetness_ahead == 0 then
						--print(sub_turn .. " " .. math.floor(init_SGES_Sim_WindDir)) --dev
						-- when approaching the coastline, test if the sub runs ashore
						coordinates_of_adjusted_ref_rampservice(submarine_x, submarine_z, 0, 60, init_SGES_Sim_WindDir)
						_,sub_bow_is_at_sea = probe_y(g_shifted_x, g_shifted_y, g_shifted_z)
						--if sub_bow_is_at_sea == 0 then sub_turn = sub_turn * 500 end --increase the turn, back to see FINE
						if sub_bow_is_at_sea == 0 then sub_turn = sub_turn * 10 end --increase the turn, back to see COARSE
					elseif sub_bow_is_at_sea ~= 1 then
						sub_bow_is_at_sea = 1
					end
					if wetness_ahead == 1 then
						sub_turn = 0
					end
					-- eats 10 FPS
					frame_counter_FPS_saver = 0
				end
			end --IAS24
			------------------------------------------------------------

			if string.match(object_name,"XP12Carrier") then
				return changed,g_shifted_x,g_shifted_z

			else
				return changed
			end
		elseif placeToBeZ == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a static object but couldn't, due to a missing z coordinate.")
		elseif placeToBeX == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a static object but couldn't, due to a missing x coordinate.")
		elseif object_name == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a static object but couldn't, due to a missing name.")
		else
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a static object but couldn't (missing instance for " .. object_name .. ").")
		end
	end

	function draw_AAR_object(placeToBeX,placeToBeZ,object_hdg_corr,Instance,object_name)
		--print("[Ground Equipment " .. version_text_SGES .. "]  draw_static_object at " .. placeToBeX .. ", " .. placeToBeZ)
		if object_name ~= nil and Instance ~= nil and placeToBeX ~= nil and placeToBeZ ~= nil then
			SavedplaceToBeZ = placeToBeZ + 2 -- TEMPO
			SavedplaceToBeX = placeToBeX -- TEMPO

			-- airplane configuration
			local effective_refuel_range = 25
			local effective_vertical_range = 0 -- here it is a corrective parameter
			if sges_refuel_port_elev == nil then sges_refuel_port_elev = 0.8 end
			if math.abs(BeltLoaderFwdPosition) > 6 then effective_refuel_range = 40 effective_vertical_range = 5 end

			-- variable definitions
			local 	changed = object_name .. "_chg"
			if object_hdg_corr == nil then object_hdg_corr = 0 end
			local reference_x = sges_gs_plane_x[0]
			local reference_z = sges_gs_plane_z[0]
			if sges_framerate_period == nil then dataref("sges_framerate_period","sim/time/framerate_period") end
			sges_fps = 1/sges_framerate_period
			local reference_heading = sges_gs_plane_head[0]
			if delta_refuel_altitude == nil then delta_refuel_altitude = 60 end
			if delta_refuel_x == nil then delta_refuel_x = 60 end
			if delta_refuel_z == nil then delta_refuel_z = 60 end
			local number_of_frame_to_count = 200
			if config_helper then number_of_frame_to_count = 5 end
			if frame == nil then frame = 0 end
			-- counting the frames
			frame = frame + 1
			-- mesure the displacement in frames
			if frame == 1 then
				reference_x_frame1 = reference_x
				reference_z_frame1 = reference_z
				fps_frame1= 1/sges_framerate_period
				print("[Ground Equipment " .. version_text_SGES .. "] Saving aircraft position to display the tanker in the vicinity : frame 1 z=" .. reference_z_frame1)
			elseif reference_x_frame1 ~= nil and frame == number_of_frame_to_count then
				reference_x_frame2 = reference_x
				reference_z_frame2 = reference_z
				fps_frame2= 1/sges_framerate_period
				-- difference of displacement in time, an average :
				delta_RefuelerX_stored = (reference_x_frame2 - reference_x_frame1)/number_of_frame_to_count
				delta_RefuelerZ_stored = (reference_z_frame2 - reference_z_frame1)/number_of_frame_to_count
				init_fps = (fps_frame1 + fps_frame2) /2
				print("[Ground Equipment " .. version_text_SGES .. "] Saving aircraft position to display the tanker in the vicinity : frame 2 z=" .. reference_z_frame2)
				print("[Ground Equipment " .. version_text_SGES .. "] dX " .. delta_RefuelerX_stored .. "  dZ " .. delta_RefuelerZ_stored)
			end



			-- commanding the KC767 refueling lights ---------------------------
			if sges_plane19_nav_lights_on == nil then sges_plane19_nav_lights_on = dataref_table("sim/multiplayer/position/plane19_nav_lights_on","writable") end
			if sges_plane18_nav_lights_on == nil then sges_plane18_nav_lights_on = dataref_table("sim/multiplayer/position/plane18_nav_lights_on","writable") end
			if sges_plane17_nav_lights_on == nil then sges_plane17_nav_lights_on = dataref_table("sim/multiplayer/position/plane17_nav_lights_on","writable") end
			if delta_refuel_altitude <= 0.2 and delta_refuel_altitude >= -1.5 then -- connected
				-- ALTITUDE INDICATION
				sges_plane19_nav_lights_on[0] = 1
			elseif sges_plane19_nav_lights_on[0] == 1 then
				sges_plane19_nav_lights_on[0] = 0
			end
			if math.abs(delta_refuel_x) <= 100 and math.abs(delta_refuel_z) <= 100 then
				-- LATERAL OK INDICATION
				sges_plane17_nav_lights_on[0] = 1
			elseif sges_plane17_nav_lights_on[0] == 1 then
				sges_plane17_nav_lights_on[0] = 0
			end
			if delta_refuel_altitude > -2 and delta_refuel_altitude < 5 - effective_vertical_range and math.abs(delta_refuel_x) <= effective_refuel_range and math.abs(delta_refuel_z) <= effective_refuel_range and sges_tank_to_refuel > 0 then
				-- INSIDE REFUELING AREA OK INDICATION, ACTIVE REFUELING
				sges_plane18_nav_lights_on[0] = 1
			elseif sges_plane18_nav_lights_on[0] == 1 then
				sges_plane18_nav_lights_on[0] = 0
			end
			-- commanding the KC767 refueling lights ---------------------------
			-- using AI lights dataref, sorry for hijacking





			--drawing functions
			-- start to place the tanker only when the object displacement was already calculated
			if delta_RefuelerX_stored ~= nil and delta_RefuelerX_stored ~= nil then

				-- commanding the KC767 attitude, among it the lateral displacement
				if delta_refuel_altitude >= -3 then
					-- normal refueling attitude
					--~ placeToBeZ = placeToBeZ + 2 + math.abs(1 * delta_refuel_altitude)
					--~ object_hdg_corr = object_hdg_corr
					--~ reference_heading =  sges_gs_plane_head[0]
					if SplaceToBeX == nil then
						-- init.
						SplaceToBeX = placeToBeX
						Sreference_heading = reference_heading
					end
					if SplaceToBeX > placeToBeX and not captured_tanker then
						SplaceToBeX = SplaceToBeX - 0.1
					end -- tanker replacement

					-- ROLL (below tanker)
					if math.abs(SplaceToBeX - placeToBeX) > 10 and SGES_vvi_fpm_pilot[0] > -200 then
						if objpos_value[0].roll < 8 then objpos_value[0].roll = objpos_value[0].roll + 0.15 end
					else
						if objpos_value[0].roll < -0.5 then objpos_value[0].roll = objpos_value[0].roll + 0.15 end
						if objpos_value[0].roll > 0.5 then objpos_value[0].roll = objpos_value[0].roll - 0.15 end
					end --

				elseif delta_refuel_altitude < -60 and SGES_vvi_fpm_pilot[0] > 0 then -- end of emergency maneouver when user gets too high)
					--~ placeToBeZ = placeToBeZ + 2 + math.abs(2 * delta_refuel_altitude)
					if objpos_value[0].roll < -0.5 then objpos_value[0].roll = objpos_value[0].roll + 0.15 end
					if objpos_value[0].roll > 0.5 then objpos_value[0].roll = objpos_value[0].roll - 0.15 end
					SplaceToBeX = SplaceToBeX + 0   -- tanker emergency movement

				elseif delta_refuel_altitude < -10 and SGES_vvi_fpm_pilot[0] > 0 then -- end of emergency maneouver when user gets too high
					--~ placeToBeZ = placeToBeZ + 2 + math.abs(2 * delta_refuel_altitude)
					if objpos_value[0].roll < -5.5 then objpos_value[0].roll = objpos_value[0].roll + 0.15 end
					if objpos_value[0].roll > 5.5 then objpos_value[0].roll = objpos_value[0].roll - 0.15 end
					if not captured_tanker then SplaceToBeX = SplaceToBeX + 0.1 end   -- tanker emergency movement

				elseif math.abs(delta_refuel_x) <= 50 and math.abs(delta_refuel_z) <= 50 and SGES_vvi_fpm_pilot[0] > 0 then-- tanker emergency maneouver when user gets too high when he is below the tanker
					--~ placeToBeZ = placeToBeZ + 2 + math.abs(2 * delta_refuel_altitude)
					if objpos_value[0].roll > -25 then objpos_value[0].roll = objpos_value[0].roll - 0.15 end
					--~ object_hdg_corr = object_hdg_corr - 2
					--~ reference_heading =  sges_gs_plane_head[0] - 2
					if not captured_tanker then SplaceToBeX = SplaceToBeX + 0.4 end   -- tanker emergency movement
					saved_refuel_alt = saved_refuel_alt + 0.01 -- more is bad for display
					--~ print("emergency escape")

				else
					if objpos_value[0].roll < -0.5 then objpos_value[0].roll = objpos_value[0].roll + 0.15 end
					if objpos_value[0].roll > 0.5 then objpos_value[0].roll = objpos_value[0].roll - 0.15 end
					if SplaceToBeX > placeToBeX and not captured_tanker then
						SplaceToBeX = SplaceToBeX - 0.05
					end -- tanker replacement
				end

				if frame == number_of_frame_to_count then
					coordinates_of_adjusted_ref_rampservice(reference_x, reference_z, SplaceToBeX, SavedplaceToBeZ, Sreference_heading)
					-- SavedplaceToBeZ instead of placeToBeZ tuned above is to get a more constant pattern during developpement.
					-- I'll keep that in production
					tk_reference_x = g_shifted_x
					tk_reference_z = g_shifted_z
					captured_tanker = false
				elseif delta_refuel_altitude >= -2 and delta_refuel_altitude < 4 - effective_vertical_range and math.abs(delta_refuel_x) <= effective_refuel_range and math.abs(delta_refuel_z) <= effective_refuel_range and sges_tank_to_refuel > 0 and math.abs(SGES_vvi_fpm_pilot[0]) < 1000 and objpos_value[0].roll >= -0.5 and objpos_value[0].roll <= 0.5 then
					-- catching the contact position, an helper to maintain refueling position, when the refuleing is in the future.
					--SplaceToBeX = SplaceToBeX -- in this case, we annihilate all eventual variation
					coordinates_of_adjusted_ref_rampservice(reference_x, reference_z, SplaceToBeX, SavedplaceToBeZ, Sreference_heading)
					captured_tanker = true
					-- SavedplaceToBeZ instead of placeToBeZ tuned above is to get a more constant pattern during developpement.
					if math.abs(g_shifted_x-reference_x) < effective_refuel_range * 2 and math.abs(g_shifted_z-reference_z) < effective_refuel_range * 2 then -- damping
					-- going here without really being in position make than tanker jump in the air suddenly. We try to mitigate this by constraints :
					-- -math.abs(SGES_vvi_fpm_pilot[0]) < x
					-- -conditions to save the values if not too abberant
						tk_reference_x = g_shifted_x
						tk_reference_z = g_shifted_z
						--~ print(tk_reference_z .. " tk_reference_z saving ")
					else
						g_shifted_x = tk_reference_x + (delta_RefuelerX_stored * (init_fps / sges_fps))
						g_shifted_z = tk_reference_z + (delta_RefuelerZ_stored * (init_fps / sges_fps))
						--~ print(tk_reference_z .. " tk_reference_z saving rejected")
						tk_reference_x = g_shifted_x
						tk_reference_z = g_shifted_z
					end
					--~ tk_reference_x = tk_reference_x + (delta_RefuelerX_stored * (init_fps / sges_fps))
					--~ tk_reference_x = tk_reference_z + (delta_RefuelerZ_stored * (init_fps / sges_fps))

				else
					captured_tanker = false
					dampening_fps_factor = (init_fps / sges_fps)
					--~ print(dampening_fps_factor)
					g_shifted_x = tk_reference_x + (delta_RefuelerX_stored * (init_fps / sges_fps))
					g_shifted_z = tk_reference_z + (delta_RefuelerZ_stored * (init_fps / sges_fps))
					--~ print("ref x " .. reference_x .. " vs tk ref x " .. tk_reference_x .. "  ref z " .. reference_z .. " vs tk ref z " .. tk_reference_z)
					tk_reference_x = g_shifted_x
					tk_reference_z = g_shifted_z
					--~ coordinates_of_adjusted_ref_rampservice(tk_reference_x, tk_reference_z, SplaceToBeX, SavedplaceToBeZ, Sreference_heading)
				end
				objpos_addr, float_addr, _ = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,Sreference_heading+object_hdg_corr,nil,object_name)

				-- the altitude
				if saved_refuel_alt == nil then
					-- at first pop up of the plane, we save the values like the altitude
					objpos_value[0].y = sges_gs_plane_y[0] + sges_refuel_port_elev
					saved_refuel_alt = objpos_value[0].y
					saved_reference_heading = reference_heading
					print("[Ground Equipment " .. version_text_SGES .. "] Applying the aircraft position to display the tanker / 1st.")
					-- update that :
					fps_frame3= 1/sges_framerate_period
					init_fps = (fps_frame1 + fps_frame2 + fps_frame3) /3
				else -- after the first shifted position was obtained, we use that to increment to next position
					-- for every subsequent frames, use the stored value, eg altitude
					objpos_value[0].y = saved_refuel_alt
					Sreference_heading = saved_reference_heading
					delta_refuel_altitude =  saved_refuel_alt  - (sges_gs_plane_y[0] + sges_refuel_port_elev)
					delta_refuel_x = tk_reference_x - sges_gs_plane_x[0]
					delta_refuel_z = tk_reference_z - sges_gs_plane_z[0]
				end
				if saved_refuel_alt == nil then save_refuel_alt = sges_gs_plane_y[0] + sges_refuel_port_elev end
				-- pitch changes
				objpos_value[0].pitch = 5
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
			end


			-- commanding the KC767 active refueling ----------------------------
			if sges_tank_to_refuel > 0 and (not config_helper or PLANE_ICAO == "HAWK") then
				-- only sges_tank_to_refuel declared in the lua files for aircraft settings can allow refueling, with more than zero tank.
				if sges_tank_ == nil then sges_tank_ = dataref_table("sim/flightmodel/weight/m_fuel") end
				-- what are the maximums of each tank
				if sges_tank_ratios_ == nil then sges_tank_ratios_ = dataref_table("sim/aircraft/overflow/acf_tank_rat") end -- RATIO
				if sges_max_tanks == nil then sges_max_tanks = get("sim/aircraft/weight/acf_m_fuel_tot") end -- kg
				if max_for_tank == nil then
					local n=0
					max_for_tank = {}
					for n=0,sges_tank_to_refuel-1 do
						max_for_tank[n] = math.floor((sges_tank_ratios_[n] * sges_max_tanks) - 10) -- EACH TANK MAX in kilograms
						print("[Ground Equipment " .. version_text_SGES .. "]  Max fuel for each tank (" .. n+1 .. ") " .. math.floor(max_for_tank[n]) .. " kg")
					end
				end

				local i=0
				if delta_refuel_altitude > -3 and delta_refuel_altitude < 5 - effective_vertical_range and math.abs(delta_refuel_x) <= effective_refuel_range and math.abs(delta_refuel_z) <= effective_refuel_range then
					-- INSIDE REFUELING AREA OK
					-- refuel
					for i=0,sges_tank_to_refuel-1 do
						if max_for_tank[i] - 5 >= sges_tank_[i] and sges_tank_full_flag[i] == false then
							sges_tank_[i] = sges_tank_[i] + 2/sges_tank_to_refuel
							--~ print("refueling tank #" .. i+1 .. ".")
						elseif sges_tank_full_flag[i] == false then
							sges_tank_full_flag[i] = true
							print("[Ground Equipment " .. version_text_SGES .. "] Tank #" .. i+1 .. " is FULL.")
						end
					end
					--~ print("-- refueling " .. sges_tank_to_refuel .. " tanks --")
					if sges_tank_full_flag[0] and sges_tank_full_flag[1] and sges_tank_full_flag[2] and sges_tank_full_flag[3] and sges_tank_full_flag[4] and sges_tank_full_flag[5] and sges_tank_full_flag[6] and sges_tank_full_flag[7] and sges_tank_full_flag[8] then
						print("[Ground Equipment " .. version_text_SGES .. "] -- Finished refueling all " .. sges_tank_to_refuel .. " declared internal tanks --")
						sges_tank_to_refuel = 0 -- conclude the refueling.
						play_sound(AAR_Refueling_completed_sound)
					end
				end
			end

			--~ if math.abs(delta_refuel_x) > 2000 or math.abs(delta_refuel_z) > 2000 then
				--~ show_AAR = false
				--~ AAR_chg = true
				--~ changed = true
				--~ play_sound(AAR_Refueling_completed_sound)
			--~ else
				changed = false
			--~ end
			return changed
		end
	end
	-- documentation :
	-- draw_static_object(target X, target Z, object heading correction, object informatic name)
	-- X is controlling left / right axis
	-- Z is controllong forward / aft axis


	function draw_from_simulator_coordinates(sim_x,sim_z,h,Instance,object_name) -- only used for the auto mode
		if (automatic_marshaller_requested or string.match(object_name,"TargetSelfPushback")  or string.match(object_name,"Fireball") or string.match(object_name,"Target_destroyed")) and sim_x ~= nil and sim_z ~= nil and h ~= nil then
			ground,wetness = probe_y (sim_x, 0, sim_z)
			objpos_value[0].x = sim_x
			objpos_value[0].z = sim_z
			objpos_value[0].y = ground
			if string.match(object_name,"Fireball") then
				print("[Ground Equipment " .. version_text_SGES .. "] Fireball at " .. sim_x .. " ; " .. sim_z)
			end
			-- if we draw the arrow which points at the selelected parking stand, we will readuce its visibility when approaching the final marks
			if approaching_TargetMarker > 2 and string.match(object_name,"TargetMarker") then
				if not show_VDGS then
					objpos_value[0].y = ground - 2.5 -- burry partially the ramp marker
				else
					objpos_value[0].y = ground - 10 -- burry the ramp marker
				end
			end
			objpos_value[0].heading = h
			float_value[0] = 0
			float_addr = float_value
			objpos_addr = objpos_value
			--~ if string.match(object_name,"TargetSelfPushback")   then
				--~ print("[Ground Equipment " .. version_text_SGES .. "] placing the TargetSelfPushback on " .. sim_x .. ", " .. sim_z .. ", wetness is " .. wetness)
				--~ print("[Ground Equipment " .. version_text_SGES .. "] but our aircraft is located on coords " .. sges_gs_plane_x[0] .. ", " .. sges_gs_plane_z[0])
				--~ wetness = 0
				--~ objpos_value[0].y = ground + 3.5
			--~ end
			if wetness == 0 then XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr) end
			changed = object_name .. "_chg"
			changed = false
			return changed
		elseif object_name ~= nil then
			print("[Ground Equipment " .. version_text_SGES .. "] I couldn't draw_from_simulator_coordinates " .. object_name ..". Missing coordinate.")
		else
			print("[Ground Equipment " .. version_text_SGES .. "] I couldn't draw_from_simulator_coordinates. Missing coordinate.")
		end
	end

	--------------------------------------------------------------------------------


	--------------------------------------------------------------------------------

	dofile(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Chocks_position.lua")
	Chocks_position_settle() --init

	--------------------------------------------------------------------------------


	--------------------------------------------------------------------------------


	function draw_FUEL()

		-- define final positions :
		if Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
			-- a refueling helicopter needs room to land !
			fuel_finalX = -23
			fuel_finalY = -8
		elseif show_Pump == false and (custom_fuel_finalX ~= nil and custom_fuel_finalY ~= nil) then
			fuel_finalX = custom_fuel_finalX
			fuel_finalY = custom_fuel_finalY

		elseif show_Pump and (custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalY ~= nil) then
			fuel_finalX = custom_fuel_pump_finalX
			fuel_finalY = custom_fuel_pump_finalY
		elseif BeltLoaderFwdPosition <= 5 then
			fuel_finalX = -14
			fuel_finalY = -5
		elseif BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
			fuel_finalX = -30
			fuel_finalY = 0
		else
			fuel_finalX = -20
			fuel_finalY = 2
		end
		-- define initial positions
		if fuel_currentX == nil or fuel_currentY == nil then
			if Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
				fuel_StartX = fuel_finalX - 6
				fuel_StartY = fuel_finalY - 240
				groundPitch["Fuel"] = 15
			else
				fuel_StartX = fuel_finalX - 3
				fuel_StartY = fuel_finalY - 40
				groundPitch["Fuel"] = 0
			end
			fuel_currentX = fuel_StartX
			fuel_currentY = fuel_StartY
			fuel_heading = sges_gs_plane_head[0]
		end



		if  Prefilled_FuelObject == XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" and fuel_currentY < fuel_StartY + 5  then
			-- hide objects in the way when fuel hydrant truck is used :
			if show_Pump and (custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalY ~= nil) then
				if custom_fuel_pump_finalX > 2 and custom_fuel_pump_finalX < 20 then -- left hand side
					StairsXPJ2_chg,StairsXPJ2_instance[0],rampserviceref302 = common_unload("StairsXPJ",StairsXPJ2_instance[0],rampserviceref302)
					StairsXPJ2_chg,StairsXPJ2_instance[1],rampserviceref303 = common_unload("StairsXPJ",StairsXPJ2_instance[1],rampserviceref303)
					People3_chg,People3_instance[0],rampserviceref75 = common_unload("People3",People3_instance[0],rampserviceref75)
					Cleaning_chg,Cleaning_instance[0],rampserviceref4 = common_unload("Cleaning",Cleaning_instance[0],rampserviceref4)
					_,Cleaning_instance[1],rampserviceref4L = common_unload("CleaningLight",Cleaning_instance[1],rampserviceref4L)
				elseif custom_fuel_pump_finalX < -2 and custom_fuel_pump_finalX > -11 then-- right hand side
					RearBeltLoader_chg,BeltLoader_instance[2],rampservicerefRBL =  common_unload("RearBeltLoader",BeltLoader_instance[2],rampservicerefRBL)
					Catering_chg,Catering_instance[0],rampserviceref8 = common_unload("Catering",Catering_instance[0],rampserviceref8)
					Catering_chg,Catering_instance[1],rampserviceref8h = common_unload("CateringHighPart",Catering_instance[1],rampserviceref8h)
				end
				if custom_fuel_pump_finalX < -2 and custom_fuel_pump_finalX > -15 then-- right hand side
					Baggage_chg,Baggage_instance[2],rampservicerefBaggage3 = common_unload("Baggage2",Baggage_instance[2],rampservicerefBaggage2)
					Baggage_chg,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)
				end
			end
		end

		if fuel_currentX < fuel_finalX and fuel_currentY < fuel_finalY  then
			-- slow down as required
			if fuel_currentY < fuel_finalY - 30 and Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj" and objpos_value[0].pitch > 10 then
				groundPitch["Fuel"] =  groundPitch["Fuel"] - 0.035
			elseif fuel_currentY > fuel_finalY - 15 and Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj" and objpos_value[0].pitch > 0 then
				groundPitch["Fuel"] =  groundPitch["Fuel"] - 0.035
			end

			if fuel_currentY < fuel_finalY - 9 then
				fuel_dX= 0.000
				fuel_dY = 0.06
				fuel_heading = sges_gs_plane_head[0]

				-- force again to remove stuff that could have appear in the mean time ue to the timing of the animations :
				if Prefilled_FuelObject == XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" and custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalX < -2 and custom_fuel_pump_finalX > -15 then-- right hand side
					Baggage_chg,Baggage_instance[2],rampservicerefBaggage3 = common_unload("Baggage2",Baggage_instance[2],rampservicerefBaggage2)
					Baggage_chg,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)
				end

			elseif fuel_currentY < fuel_finalY - 8.6 then
				fuel_dX= 0.000
				fuel_dY = 0.05
				fuel_heading = sges_gs_plane_head[0]
			elseif fuel_currentY < fuel_finalY - 8.3 then
				fuel_dX= 0.000
				fuel_dY = 0.04
				fuel_heading = sges_gs_plane_head[0]

				-- force again to remove stuff that could have appear in the mean time ue to the timing of the animations :
				if Prefilled_FuelObject == XPlane_Ramp_Equipment_directory   .. "../Dynamic_Vehicles/fuelHydDisp_truck.obj" and custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalX < -2 and custom_fuel_pump_finalX > -15 then-- right hand side
					Baggage_chg,Baggage_instance[2],rampservicerefBaggage3 = common_unload("Baggage2",Baggage_instance[2],rampservicerefBaggage2)
					Baggage_chg,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)
				end

			elseif fuel_currentY < fuel_finalY - 7.9 then
				fuel_dX= 0.000
				fuel_dY = 0.03
				fuel_heading = sges_gs_plane_head[0]
			elseif fuel_currentY < fuel_finalY - 5 then
				-- renable the vehicles which were on the way :
				if show_Pump and (custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalY ~= nil) then
					StairsXPJ2_0_show_only_once = true
					StairsXPJ2_1_show_only_once = true
					Catering_chg = true
					StairsXPJ2_chg = true
					Cleaning_chg = true
				end
			elseif fuel_currentY < fuel_finalY - 3 then
				fuel_dX= 0.000
				fuel_dY = 0.02
				fuel_heading = sges_gs_plane_head[0]

			elseif fuel_currentY >= fuel_finalY - 3 and show_Pump and custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalX < -2 then
				-- movement of fuel hydrant dispenser on the right hand side, turning right slightly
				if fuel_currentY >= fuel_finalY - 3 and fuel_heading < sges_gs_plane_head[0] + 9 then
					-- variation to object position at each frame
					fuel_dX = -0.002
					fuel_dY = 0.01
					fuel_heading = fuel_heading + 0.2
				elseif fuel_currentY >= fuel_finalY - 3 and fuel_heading > sges_gs_plane_head[0] + 11 then -- SAFETY
					-- variation to object position at each frame
					fuel_dX = 0.0005
					fuel_dY = 0.01
					fuel_heading = fuel_heading - 0.2
				elseif fuel_currentY >= fuel_finalY - 3 then
					fuel_dX = -0.001
					fuel_dY = 0.005
					fuel_heading = fuel_heading
				end
				Fuel_heading_correcting_factor = 10
			elseif fuel_currentY >= fuel_finalY - 3 then
				-- movement of fuel cistern truck, turning left
				if groundPitch["Fuel"] >= 0.1 then -- safety PATCH
					groundPitch["Fuel"] =  groundPitch["Fuel"] - 0.1
					if groundPitch["Fuel"] < 0.5  then print("[Ground Equipment " .. version_text_SGES .. "] Correcting fuel pitch to zero " .. math.floor(groundPitch["Fuel"])) end
				end
				if fuel_currentY >= fuel_finalY - 3 and fuel_heading > sges_gs_plane_head[0] - 27 then
					-- variation to object position at each frame
					fuel_dX = 0.002
					fuel_dY = 0.01
					fuel_heading = fuel_heading - 0.2
				elseif fuel_currentY >= fuel_finalY - 3 and fuel_heading < sges_gs_plane_head[0] - 30 then -- SAFETY
					-- variation to object position at each frame
					fuel_dX = -0.0005
					fuel_dY = 0.01
					fuel_heading = fuel_heading + 0.2
				elseif fuel_currentY >= fuel_finalY - 3 then
					fuel_dX = 0.002
					fuel_dY = 0.005
					fuel_heading = fuel_heading
				end
				Fuel_heading_correcting_factor = -27
			end

			fuel_currentX = fuel_currentX + fuel_dX
			fuel_currentY = fuel_currentY + fuel_dY

			-- MIRROR
			if SGES_mirror == 1 then
				fuel_currentX = -1 * fuel_finalX + 2
				fuel_currentY = fuel_finalY + 2
				Fuel_heading_correcting_factor = 17
				fuel_heading = sges_gs_plane_head[0] + 17
			end

			--print("[Ground Equipment " .. version_text_SGES .. "]  Fuel has reached " .. fuel_currentX .. " going to " .. fuel_finalX)
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], fuel_currentX, fuel_currentY, sges_gs_plane_head[0] )
			--~ if military == 1 then objpos_value[0].heading = objpos_value[0].heading  + 180 end

			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			--objpos_value[0].y = acft_y + 1.5 * milheight
			objpos_value[0].y = acft_y
			if Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
				objpos_value[0].y = acft_y + math.abs(fuel_currentY - fuel_finalY)
			end
			objpos_value[0].heading = fuel_heading
			if XTrident_Chinook_Directory ~= nil then
				if XTrident_Chinook_Directory ~= nil and Prefilled_FuelObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/misc/M978.obj" then -- PATCH
					objpos_value[0].heading = objpos_value[0].heading  + 180
					objpos_value[0].y = acft_y + 1.5 * 1.1 -- I have fixed the milheight to be able to mix departing x-trident and non-x-trident assets
				end
			end

			if Clairmarais_Aerodrome_directory ~= nil and Prefilled_FuelObject_option1 ==   Clairmarais_Aerodrome_directory   .. "Vehicles/FuelTruck.obj" then
				objpos_value[0].heading = objpos_value[0].heading + 180
			end

			objpos_value[0].pitch = groundPitch["Fuel"]
			float_value[0] = 0
			float_addr = float_value
			objpos_addr = objpos_value
			--print(objpos_value[0].pitch .. " <-------------- fuel pitch 2")
			if wetness == 0 then XPLM.XPLMInstanceSetPosition(FUEL_instance[0], objpos_addr, float_addr) end   -- FUEL truck
		else
			-- renable the other vehicles which were on the way :
			if show_Pump and (custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalY ~= nil) then
				Catering_chg = true
				RearBeltLoader_chg = true
				People3_chg = true
				Baggage_chg = true
			end
			if Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
				groundPitch["Fuel"] =  0
				objpos_value[0].pitch = 0 --safety to be adopted on takeoff
			end
			FUEL_chg = false               -- indicate that the possible change in ramp/gate has been processed
			print("[Ground Equipment " .. version_text_SGES .. "]  Fuel truck has reached final position " .. fuel_currentX .. " , " .. fuel_currentY)
			--print("draw_rampservice -- preparing fuel truck done")
			-- store final position to start disappearance later
			FuelFinalX = fuel_currentX
			FuelFinalY = fuel_currentY

		end

	end




	function draw_Bus()
		-- Object with datarefs dependencies now
		local hdg_dev = 0
		--if military_default == 1 then hdg_dev = -90 end

		-- define final positions :
		if BeltLoaderFwdPosition >= 19 then
			-- B747, A340
			finalX = 29
			finalY = 0.8*math.abs(targetDoorZ)
		elseif BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
			finalX = 25
			finalY = 1*math.abs(targetDoorZ)
		elseif string.match(PLANE_ICAO,"AT4") or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then -- ATR42 and ATR 72 rear boarding door
			finalX = 16
			finalY = -5 -- boarding at the rear
		elseif math.abs(BeltLoaderFwdPosition) < 4.5 then -- general aviation, helicopters :
			finalX = 16
			finalY = -3
			--~ print("[Ground Equipment " .. version_text_SGES .. "]  Passengers vehicle for small airplans has a final position of  " .. finalX .. " , " .. finalY .. ".")
		else -- general case :
			finalX = 18
			finalY = 0.8*math.abs(targetDoorZ)
		end
		if boarding_from_the_terminal then
			finalX = 40
			finalY = 50
		end

		if protect_StairsXPJ then finalY = 0 end -- avoid moved-away airstairs

		-- define initial positions
		if currentX == nil or currentY == nil then
			StartX = 38
			StartY = finalY - 40
			if BeltLoaderFwdPosition >= 19 then
				-- B748, A330, A340
				StartX = 45
			end
			if protect_StairsXPJ then StartX = StartX + 3 end -- avoid moved-away airstairs
			if debugging_passengers then
				StartX = finalX -- debugging conditiond for passengers
				StartY = finalY -- debugging conditiond for passengers
			end
			if boarding_from_the_terminal then
				StartX = finalX + 0.2 -- force to draw
				StartY = finalY - 0.2 -- force to draw
				print("[Ground Equipment " .. version_text_SGES .. "]  BOARDING FROM THE TERMINAL")
			end
			currentX = StartX
			currentY = StartY
			currentH = 24
			--print("[Ground Equipment " .. version_text_SGES .. "]  Bus starts from " .. currentX)
		end
		if currentX > finalX and currentY < finalY  then

			if IsPassengerPlane == 0 then  -- when is an ULD AAD train, be slow
				currentH = 24
				if IsPassengerPlane == 0 then
					dX= 0.009
					dY = 0.020
				end
			else -- when a bus
				-- slow down as required
				if currentX < finalX + 0.5 or currentY > finalY - 0.5 then
					-- variation to object position at each frame
					dX= 0.0035
					dY = 0.007
				elseif currentH > 21 and currentX < finalX + 4 then
					currentH = currentH - 0.04
					--~ print("turning bus")
					if dX > 0.0035 then dX= dX - 0.00025 end
					if dY > 0.007 then dY = dY - 0.0005 end
				elseif currentX >= finalX + 5.5 then
					dX= 0.030
					dY = 0.066
				end
			end
			currentX = currentX - dX
			currentY = currentY + dY

			-- MIRROR
			if SGES_mirror == 1 then
				currentX = -1 * finalX - 2
				currentY = finalY + 3
				hdg_dev = - 5
			end

			-- escape when not really a Bus
			--if IsPassengerPlane == 0 then currentX = finalX currentY = finalY end -- dont bother
			if UseXplaneDefaultObject == true then currentX = finalX currentY = finalY end -- dont bother

			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], currentX, currentY, sges_gs_plane_head[0] )

			--if XTrident_Chinook_Directory ~= nil then
				if XTrident_Chinook_Directory ~= nil and Prefilled_BusObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" then
					objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,sges_gs_plane_head[0]+hdg_dev+currentH,nil,"military_Bus")
				else
					objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,sges_gs_plane_head[0]+hdg_dev+currentH,nil,"Bus")
				end
			--end


			if wetness == 0 then XPLM.XPLMInstanceSetPosition(Bus_instance[0], objpos_addr, float_addr)  end  -- Bus UTG
			if wetness == 0 and Bus_instance[1] ~= nil then
				XPLM.XPLMInstanceSetPosition(Bus_instance[1], objpos_addr, float_addr)
			end  -- Bus night lighting after  XP12.1.4

		else
			Bus_chg = false               -- indicate that the possible change in ramp/gate has been processed
			print("[Ground Equipment " .. version_text_SGES .. "]  Bus has reached final position " .. currentX .. " , " .. currentY)
			if show_StairsXPJ and IsPassengerPlane == 1 then
				if math.abs(BeltLoaderFwdPosition) > 5 then
					if not protect_StairsXPJ then  show_Pax = true end
					-- upon bus arrival, enable the passengers automatically, but only for the bigger aircraft.
					-- 		and only when the aircraft is not protected in ZSAR with airstairs away enough.
					-- only offer passengers manually on small aircraft
				end
				Pax_chg = true -- that triggers walking_direction_changed_armed = true which is bad first time, lets change the unload-passengers funciton to arme the reversal only when pax are seen on the scenery !
				terminate_passenger_action = false
				BeltLoader_chg = true -- required for the baggage correct deboarding animation transition
				baggage_pass = 0
			end

			--~ if show_StairsXPJ and IsPassengerPlane == 1 and SGES_total_flight_time_sec < 3600 then
				--~ walking_direction = "boarding"
			--~ elseif show_StairsXPJ and IsPassengerPlane == 1 and SGES_total_flight_time_sec >= 3600 then
				--~ walking_direction = "deboarding" -- deboarding animation !
			--~ end

			-- allow animated baggage
			if IsXPlane1211 and IsPassengerPlane == 0 then
					baggage5_show_only_once = true  -- anti crash too many callback
					show_CargoULD = true
					CargoULD_chg = true
					print("[Ground Equipment " .. version_text_SGES .. "]  Isn't a passenger plane : the arrival of the ULD train unlocked the Cargo ULD once.")
			end
			-- store final position to start passenger deplacement
			BusFinalX = currentX
			BusFinalY = currentY
		end

	end




	local Mashaller_available = false


	function draw_FM()
		--if sges_gs_gnd_spd[0] < 60 then
		  --print("draw_rampservice -- preparing altitude done " .. objpos_value[0].y)
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
				-- attempt at slowing the FM
			if parameter_TM == nil then
				parameter_TM = 49
				if PLANE_ICAO == "A346" then parameter_TM = 70
				elseif PLANE_ICAO == "B742" or PLANE_ICAO == "B744" or PLANE_ICAO == "B748" then parameter_TM = 62 end
			end
			if approaching_TargetMarker == 2 and parameter_TM > 35 then
				parameter_TM = parameter_TM-0.07 -- progressively slowing
				--print(parameter_TM)
			end
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], -0.03 * sges_nosewheel[0], parameter_TM + 1.25 * sges_gs_gnd_spd[0] - 0.15 * math.abs(sges_nosewheel[0]), sges_gs_plane_head[0] )


			local identity = nil
			if XTrident_Chinook_Directory ~= nil then
				if XTrident_Chinook_Directory ~= nil and Prefilled_FMObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" then identity = "military_FM" else identity = nil end
			end
			if Clairmarais_Aerodrome_directory ~= nil and Prefilled_FMObject == Clairmarais_Aerodrome_directory   .. "Vehicles/Truck.obj" then identity = "Clairmarais"	end

			if sges_gs_gnd_spd[0] < 5 then
				objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,sges_gs_plane_head[0] + (0.55 * sges_nosewheel[0])*(0.2*sges_gs_gnd_spd[0]),nil,identity)
			else
				objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,sges_gs_plane_head[0]+ (0.55 * sges_nosewheel[0]),nil,identity)
			end
			-- save a copy for objects attached to the follow me car :
			if approaching_TargetMarker <= 2 or automatic_marshaller_requested then
				follow_me_x = objpos_value[0].x
				follow_me_z = objpos_value[0].z
				follow_me_y = objpos_value[0].y
				follow_me_h = objpos_value[0].heading
			end
			-- also save a copy for the target marker :
			TargetMarkerX = objpos_value[0].x
			TargetMarkerZ = objpos_value[0].z
			TargetMarkerH = objpos_value[0].heading
			TargetMarkerY = objpos_value[0].y
			if wetness == 0 then
				XPLM.XPLMInstanceSetPosition(FM_instance[0], objpos_addr, float_addr)    -- FM truck
				Mashaller_available = true
				--XPLMSpeakString("RELATIVE HDG " .. math.floor(360-l_heading) ..  " ABSOLUTE HDG " ..  math.floor(sges_gs_plane_head[0]-l_heading) .. "  DeltaAltitude = " .. math.floor((sges_gs_plane_y[0]-acft_y)*10)/10 .. " DISTANCE " .. math.floor(l_dist) .. " ")
			else
				show_FM = false
				--XPLMSpeakString("not on dry terrain")
			end
	end

	--------------------------------------------------------------------------------
	--										ULD or BELT LOADERS
	--------------------------------------------------------------------------------




	function draw_Cart()


		-- Now dynamic objects
		heading_correcting_factor = 0



	   -- POSITIVE LEFT < x > NEGATIVE RIGHT
		-- POSITIVE FWD < z > NEGATIVE AFT
		-- define final positions :
		Cart_finalX = -2.3*(targetDoorX + 6.6)
		Cart_finalY = BeltLoaderFwdPosition+10

		--if the PRM boarding truck is displayed, we have to avoid a collision and fall back the final position
		if show_PRM then
			Cart_finalX = -2.8*(targetDoorX + 6.6)
			Cart_finalY = BeltLoaderFwdPosition + 7
		end


		if BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then
			Cart_finalX = -(targetDoorX + 16)
			Cart_finalY = BeltLoaderFwdPosition+2
		elseif PLANE_ICAO == "A306" then
			Cart_finalX = -(targetDoorX + 16)
			Cart_finalY = BeltLoaderFwdPosition+2
		end

		-- regional & turboprops
		if PLANE_ICAO == "SF34" or string.match(PLANE_ICAO,"DH8A") or PLANE_ICAO == "DH8D" or PLANE_ICAO == "DH8C" or string.match(PLANE_ICAO,"CRJ") or ((string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko")) then
			Cart_finalX = -(targetDoorX + 16.7)
			Cart_finalY = 1.5*BeltLoaderFwdPosition
			heading_correcting_factor = heading_correcting_factor + 180
		elseif string.match(PLANE_ICAO,"AT4") or (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then -- ATR42 and ATR 72 forward cargo hold on the left
			--~ finalX = 8
			--~ finalY = BeltLoaderFwdPosition + 4
			Cart_finalX = -14
			Cart_finalY = -12
			heading_correcting_factor = heading_correcting_factor + 180
		elseif PLANE_ICAO == "QX" or PLANE_ICAO == "AMF" then
			Cart_finalX = -(targetDoorX+12)
			Cart_finalY = 1.5*BeltLoaderFwdPosition
			heading_correcting_factor = heading_correcting_factor + 180
		elseif PLANE_ICAO == "ASB" then -- Breguet Deux ponts
			Cart_finalX = -(targetDoorX+14)
			Cart_finalY = 0.6*BeltLoaderFwdPosition
			heading_correcting_factor = heading_correcting_factor + 180
		elseif plane_has_cargo_hold_on_the_left_hand_side then
			Cart_finalX = -(targetDoorX + 16.7)
			Cart_finalY = 1.5*BeltLoaderFwdPosition
			heading_correcting_factor = heading_correcting_factor + 180
		end

		if string.match(PLANE_ICAO,"B46") or PLANE_ICAO == "RJ70" or PLANE_ICAO == "RJ85" or PLANE_ICAO == "RJ1H" then
			Cart_finalX = -2*(targetDoorX + 6.6)
			Cart_finalY = -2
			-- test :
			--~ Cart_finalX = -2.3*(targetDoorX + 6.6)
			--~ Cart_finalY = BeltLoaderFwdPosition+10
		end
		if string.match(PLANE_ICAO,"GLF") then
			Cart_finalX = -2*(targetDoorX + 6.6)
			Cart_finalY = -2
		end

		-- canoe ?
		if wetness == 1 and CartObject == Prefilled_CanoeObject then -- Canoe
			Cart_finalX = -0.7*(targetDoorX + 6.6)
			Cart_finalY = BeltLoaderFwdPosition+10
		end



		if Cart_currentX == nil or Cart_currentY == nil then

			if  heading_correcting_factor == 180 then
				Cart_StartX = Cart_finalX - 0.4
				Cart_StartY = Cart_finalY - 0.2
			else
				Cart_StartX = Cart_finalX - 1.2
				Cart_StartY = Cart_finalY - 10
			end
			Cart_currentX = Cart_StartX
			Cart_currentY = Cart_StartY
			--print("[Ground Equipment " .. version_text_SGES .. "]  BeltLoader starts from " .. currentX)
		end
		if Cart_currentX < Cart_finalX and Cart_currentY < Cart_finalY  then
			-- when not on right side
			if  heading_correcting_factor == 180 then
				Cart_dX= 0.0015 * 2
				Cart_dY = -0.01 * 2
			else
				Cart_dX= 0.0015 * 2
				Cart_dY = 0.01 * 2
			end
			Cart_currentX = Cart_currentX + Cart_dX
			Cart_currentY = Cart_currentY + Cart_dY

			--print("[Ground Equipment " .. version_text_SGES .. "]  Cart has reached " .. Cart_currentX .. " going to " .. Cart_finalX)
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Cart_currentX, Cart_currentY, sges_gs_plane_head[0] + heading_correcting_factor )
			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			--~ if BeltLoaderFwdPosition >= ULDthresholdx or string.find(CartObject,"Dolly") then -- cargo dolly
				--~ objpos_value[0].heading = sges_gs_plane_head[0] +170
				--~ if  heading_correcting_factor == 180  then
					--~ objpos_value[0].heading = sges_gs_plane_head[0] +190
				--~ end
				-- had to be changed, since the new baggage cart are 180° reversed
			--~ else
				objpos_value[0].heading = sges_gs_plane_head[0] -10
				if  heading_correcting_factor == 180  then
					objpos_value[0].heading = sges_gs_plane_head[0] +10
				end
			--~ end
			-- ok, but when using default object, the laminar object is in the opposite direction :
			if  string.find(CartObject,"leg_lugg_train_str") or string.find(CartObject,"Lugg_Train_Str") or string.find(CartObject,"Dolly") then objpos_value[0].heading = objpos_value[0].heading + 180 end -- and is XP12 ?

			if CartObject == Prefilled_CanoeObject then -- Canoe
				objpos_value[0].heading = objpos_value[0].heading - 90
			end
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			objpos_value[0].pitch = 0
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = acft_y
		   -- if PLANE_ICAO == "A3ST" then objpos_value[0].y = acft_y + 3 end -- Prefilled_CartObject = AIRCRAFT_PATH   .. "objects/Ground/Cargo_Heli.obj"
		  --print("draw_rampservice -- preparing altitude done " .. objpos_value[0].y)
			objpos_addr = objpos_value



			if wetness == 0  and (BeltLoaderFwdPosition > 2 or (string.match(PLANE_ICAO,"B46") or string.match(PLANE_ICAO,"RJ") or string.match(AIRCRAFT_PATH,"146") )) then
				XPLM.XPLMInstanceSetPosition(BeltLoader_instance[1], objpos_addr, float_addr)
			end  -- baggage cart
			if wetness == 1 and CartObject == Prefilled_CanoeObject then -- Canoe
				XPLM.XPLMInstanceSetPosition(BeltLoader_instance[1], objpos_addr, float_addr)
			elseif wetness == 1 and CartObject ~= Prefilled_CanoeObject then -- Canoe
				CartObject = Prefilled_CanoeObject -- correct the object to be a raft
				show_Cart = false
				Cart_chg = true
			end

		else
			Cart_chg = false               -- indicate that the possible change in ramp/gate has been processed
			print("[Ground Equipment " .. version_text_SGES .. "]  Baggage cart has reached final position " .. Cart_currentX .. " " .. Cart_currentY)
			-- store final position to start passenger deplacement
			CartFinalX = Cart_currentX
			if  heading_correcting_factor == 180 then CartFinalX = -Cart_currentX end
			CartFinalY = Cart_currentY
			if  heading_correcting_factor == 180 then CartFinalY = -Cart_currentY end
			CartFinalHDG = objpos_value[0].heading
			Cart_heading_correcting_factor = heading_correcting_factor
			-- allow animated baggage
			if IsXPlane12 and show_BeltLoader and baggage_x  ~= nil then
					baggage_show_only_once = true  -- anti crash too many callback
					baggage1_show_only_once = true  -- anti crash too many callback
					baggage2_show_only_once = true  -- anti crash too many callback
					baggage3_show_only_once = true  -- anti crash too many callback
					baggage4_show_only_once = true  -- anti crash too many callback
					show_Baggage = true
					Baggage_chg = true
			end
			Cones_chg = true
		end

	end
	-- get value (float)
	--~ function getvalue(dataRef_ptr)
	  --~ if dataRef_ptr ~= nil then
		--~ return XPLM.XPLMGetDataf(dataRef_ptr)
	  --~ end
	  --~ return nil
	--~ end


	function Common_draw_departing_vehicles(Initial_X,Initial_Z,Instance,object_name,refrce,heading_correcting_factor)

		-- This is restricted to the passenger bus because I have seen interactions when several vehicles are authorized to share the function.
		-- I'll work on that without pressure.

		if heading_correcting_factor == nil then heading_correcting_factor = 0 end
		if heading_corr[object_name] == nil then heading_corr[object_name] = heading_correcting_factor end
		--heading_corr[object_name] = heading_correcting_factor

		if current_X[object_name] == nil and current_Z[object_name] == nil then
			current_X[object_name] = Initial_X
			current_Z[object_name] = Initial_Z
			object_name_t[object_name] = object_name
			print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name .. " starting again from " .. current_X[object_name] .. " and " .. current_Z[object_name] .. " with a heading correction to the airplane nose of ".. heading_corr[object_name] .. "°.")
		end


		if object_name_t[object_name] ~= nil and Instance ~= nil and refrce ~= nil and current_X[object_name] ~= nil and current_Z[object_name] ~= nil then
			--if current_heading == nil then current_heading = sges_gs_plane_head[0] end
			local changed = object_name .. "_chg"
			if XTrident_Chinook_Directory ~= nil then
				if object_name_t[object_name] == "FUEL" and XTrident_Chinook_Directory ~= nil and Prefilled_FuelObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/misc/M978.obj"  then
					heading_corr[object_name] = 180
				end
			end
			if object_name_t[object_name] == "FUEL" and Clairmarais_Aerodrome_directory ~= nil and Prefilled_FuelObject_option1 ==   Clairmarais_Aerodrome_directory   .. "Vehicles/FuelTruck.obj" then
				heading_corr[object_name] = 180
			end

		   -- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
			-- define final positions :
			obj_finalZ = Initial_Z + 25
			if object_name_t[object_name] == "PB" or object_name_t[object_name] == "Pushback" or object_name_t[object_name] == "GenericDriver"  then
			--~ if object_name_t[object_name] == "PB" then -- the tractor will then kill the associated objects
				if BeltLoaderFwdPosition > 9 then obj_finalZ = Initial_Z + 20 else obj_finalZ = Initial_Z + 8 end -- IAS24, extetend a little bit the backward movement for bigger planes
				if BeltLoaderFwdPosition > 16 then obj_finalZ = Initial_Z + 25 end -- IAS24, extetend a little bit the backward movement for bigger planes
			end
			if object_name_t[object_name] == "FUEL" and Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
				obj_finalZ = Initial_Z + 400
			end

			if current_Z[object_name] < obj_finalZ then
				if object_name_t[object_name] ~= "Hydrant" and current_Z[object_name] <= obj_finalZ - 0.5 then
					-- smooth departing angle toward zero, but not for special movements like the fuel hydrant cart
					 heading_corr[object_name] = heading_corr[object_name] / 1.01
				end
				dZ_depart[object_name] = 0.03
				--~ print("bing+")
				if math.abs(heading_corr[object_name]) > 1 then dZ_depart[object_name] = 0.01 end
				if current_Z[object_name] > obj_finalZ - 3 and math.abs(heading_corr[object_name]) > 1 then dZ_depart[object_name] = 0.005 end

				if 		current_Z[object_name] > obj_finalZ - 0.2 then dZ_depart[object_name] = 0.003
				elseif 	current_Z[object_name] > obj_finalZ - 0.5 then dZ_depart[object_name] = 0.004 end


				if object_name_t[object_name] == "FUEL" then

					if heading_corr[object_name] <= 0.2 then --starting is minus 27 (regular fuel truck)
						heading_corr[object_name] = heading_corr[object_name] + 0.2 -- added 16-7-23
					elseif current_Z[object_name] > obj_finalZ - 0.6 then --kept on 16-7-23
						heading_corr[object_name] = heading_corr[object_name] + 0.2
					end
				end

				if object_name_t[object_name] == "Hydrant" then


					if current_X[object_name]  < -2 and heading_corr[object_name] <= 28 then
						-- increase right turn
						heading_corr[object_name] = heading_corr[object_name] + 0.1 -- added 16-7-23
						-- on the left side, no need, the heading is alreading aircraft hdg - 28
					elseif current_Z[object_name] > obj_finalZ - 0.6 then --kept on 16-7-23
						heading_corr[object_name] = heading_corr[object_name] + 0.5
					end
				end

				if 		current_Z[object_name] > obj_finalZ - 0.6 and (object_name_t[object_name] == "Bus" or object_name_t[object_name] == "BusLight") and Prefilled_BusObject ~= Prefilled_BusObject_doublet then heading_corr[object_name] = heading_corr[object_name] - 0.1 end
				-- the pushback will turn toward where it came from :  -- IAS24 start
				if 		current_Z[object_name] > obj_finalZ - 0.4 and (object_name_t[object_name] == "PB" or  object_name_t[object_name] == "GenericDriver")     and SPB_orientation ~= nil and  SPB_orientation < 0 then heading_corr[object_name] = heading_corr[object_name] + 0.4
				elseif 		current_Z[object_name] > obj_finalZ - 0.4 and (object_name_t[object_name] == "PB" or  object_name_t[object_name] == "GenericDriver") and SPB_orientation ~= nil and  SPB_orientation > 0 then heading_corr[object_name] = heading_corr[object_name] - 0.4
				elseif 		current_Z[object_name] > obj_finalZ - 0.4 and (object_name_t[object_name] == "PB" or  object_name_t[object_name] == "GenericDriver") then -- when not a preplanned pushback
					--~ math.randomseed(os.time()) -- done in the GUI to avoid having it multiple times here.
					--~ randomView = math.random()
					if randomView > 0.3 and randomView <= 0.8 then
						heading_corr[object_name] = heading_corr[object_name] + 0.4
					else
						heading_corr[object_name] = heading_corr[object_name] - 0.4
					end
				end  -- IAS24 end

				--print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name .. " has reached X = " .. current_X[object_name] .. "  and Z = " .. current_Z[object_name] .. " going to Z = " .. obj_finalZ)
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], current_X[object_name], current_Z[object_name], sges_gs_plane_head[0] )

				objpos_value[0].x = g_shifted_x
				objpos_value[0].z = g_shifted_z
				objpos_value[0].heading = sges_gs_plane_head[0] + heading_corr[object_name]

				if object_name_t[object_name] == "PB" and Prefilled_PushBack1Object == SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Tractor.obj"   then
					objpos_value[0].heading = objpos_value[0].heading + 180
				end
				if object_name_t[object_name] == "PB" and (Prefilled_PushBack1Object == Prefilled_Mil_Van or Prefilled_PushBack1Object == Prefilled_CleaningTruckObject or Prefilled_PushBack1Object == Native_PushBack_Tug) then
					objpos_value[0].heading = objpos_value[0].heading + 180
				end


				groundAlt[object_name],wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				-- X-Trident escapments, those objects are buried into the ground.
				if XTrident_Chinook_Directory ~= nil then
					if object_name_t[object_name] == "FUEL" and XTrident_Chinook_Directory ~= nil and Prefilled_FuelObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/misc/M978.obj" then
						groundAlt[object_name] = groundAlt[object_name] + 1.5 * 1.1 -- I have fixed the milheight to be able to mix departing x-trident anf non-x-trident assets
					end
					if object_name_t[object_name] == "Bus" and XTrident_Chinook_Directory ~= nil and Prefilled_BusObject == SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj" then
						groundAlt[object_name] = groundAlt[object_name] + 1.1
					end
				end
				if object_name_t[object_name] == "GenericDriver" then
					groundAlt[object_name] = groundAlt[object_name] + 0.4
					--~ objpos_value[0].heading = objpos_value[0].heading + 15
				end
				if object_name_t[object_name] == "Pushback" then --Pushback bar leveled
					groundAlt[object_name] = groundAlt[object_name] - 0.23
					groundPitch[object_name] = 7
					if IsXPlane1209 then
						groundAlt[object_name] = groundAlt[object_name] - 0.18
						groundPitch[object_name] = 8
					end

					if (FFSTS_777v2_Directory ~= nil and PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") or Prefilled_PushBackObject == SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj") then
						groundPitch[object_name] = 0
						if ground ~= nil then groundAlt[object_name] = ground end
					end
				else
					groundPitch[object_name] = 0
				end

				-- SH 60 fuel truck is gaining altitude slowly
				if object_name_t[object_name] == "FUEL" and Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj"	then
					--objpos_value[0].y = objpos_value[0].y + 0.01
					objpos_value[0].y = groundAlt[object_name]  + (math.abs(current_Z[object_name] - Initial_Z) /1)
					if groundPitch[object_name]  > -6 then groundPitch[object_name]  = groundPitch[object_name]  - 0.1 end
				else
					objpos_value[0].y = groundAlt[object_name] -- on ground
				end
				objpos_value[0].pitch = groundPitch[object_name]
				---------------------------------------------------------------
				if object_name_t[object_name] == "Cart" and CartObject == Prefilled_CanoeObject then -- Canoe
					objpos_value[0].heading = objpos_value[0].heading - 90
				end
				if object_name_t[object_name] == "Cart" and	IsXPlane12 and
					(CartObject == 			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str2.obj" -- baggage cart XP12
					or
					CartObject ==			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str3.obj" -- baggage cart
					or
					CartObject ==			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str4.obj" -- baggage cart
					or
					CartObject ==			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str5.obj" -- baggage cart
					or
					CartObject ==			XPlane_Ramp_Equipment_directory   .. "leg_lugg_train_str1.obj") -- baggage cart
					then
					objpos_value[0].heading = objpos_value[0].heading + 180
				end

				if object_name_t[object_name] == "Cart" and CartObject ~= Prefilled_CanoeObject and current_X[object_name] > 0 then
					-- when the baggage cart is on the left hand side, remove the cones bevore rolling on it.
					_,Cones_instance[1],rampserviceref3 = common_unload("Cones",Cones_instance[1],rampserviceref3)
					-- some configuration (rear left hand side cargo hold) are incompatible with crossing pax in front of the departing luggage train.
					if PLANE_ICAO == "SF34" or PLANE_ICAO == "DH8D" or PLANE_ICAO == "DH8C"  or string.match(PLANE_ICAO,"DH8A") or string.match(PLANE_ICAO,"CRJ") or ((string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko")) or plane_has_cargo_hold_on_the_left_hand_side then
						unload_Passengers() -- hide temporarily the passengers (but also invert the boarding and deboarding).
						walking_direction_changed_armed = false -- important, without that, on reappearence the walking direction will be inverted and we don't want that in this context
					end
				end
				---------------------------------------------------------------

				float_value[0] = 0
				float_addr = float_value

				--groundAltCarriermod
				if wetness == 1 and math.abs(sges_gs_plane_y[0]-acft_y) > 5 and (object_name_t[object_name] == "PB" or object_name_t[object_name] == "Pushback" or object_name_t[object_name] == "GenericDriver")  then
					objpos_value[0].y = sges_gs_plane_y[0] + ref_to_default  + SGES_Vertical_position_gear_strut_extended[0]  - SGES_strut_compression[0] - 0.05 -- all is in meters
				end
				objpos_addr = objpos_value
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
				-- increment
				if heading_corr[object_name] >= 20 and object_name_t[object_name] == "Hydrant" then -- fuel hydrant dispenser (right)
					dX_depart[object_name] = - 0.009
					dZ_depart[object_name] = 0.015
				elseif heading_corr[object_name] <= -20 and object_name_t[object_name] == "Hydrant" then -- fuel hydrant dispenser (left)
					dX_depart[object_name] =  0.009
					dZ_depart[object_name] = 0.015
					--~ print(dX_depart[object_name] .. "< dX   HDG corr > " .. heading_corr[object_name])
				elseif  not object_name_t[object_name] == "PB" or not object_name_t[object_name] == "Pushback" or not object_name_t[object_name] == "GenericDriver" then
					dX_depart[object_name] = 0
				end
				if dX_depart[object_name] == nil then dX_depart[object_name] = 0 end
				current_X[object_name] = current_X[object_name] + dX_depart[object_name]
				current_Z[object_name] = current_Z[object_name] + dZ_depart[object_name]

				return true,Instance,refrce,Initial_X,Initial_Z
			else
				if object_name_t[object_name] == "Hydrant" and hide_temporarily_cart then
					-- renable vehicles which were on the way :
					if current_X[object_name] < -2 then -- if on the starboard side :
						show_Cart = true
						Cart_chg = true
						print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name_t[object_name] .. " : renabling starboard side services which where on the way.")
					elseif current_X[object_name] > 2 then
						show_Bus = true
						Bus_chg = true
						walking_direction_changed_armed = false
						--~ show_Pax = true -- will be auto if stairs deployed
						--~ Pax_chg = true
						print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name_t[object_name] .. " : renabling port side services which were on the way.")
					end
				end
				--
				changed = false               -- indicate that the possible change in ramp/gate has been processed
				print("[Ground Equipment " .. version_text_SGES .. "]  " .. object_name_t[object_name] .. " has reached final position before disappearance. Bye bye !")
				--

				-- send the vehicle to Common_unload :
				changed,Instance,refrce = common_unload(object_name_t[object_name],Instance,refrce)
				current_X[object_name] = nil -- important
				current_Z[object_name] = nil -- important
				heading_corr[object_name] = nil -- important
				Initial_X = nil -- important
				Initial_Z = nil -- important
				if object_name_t[object_name] == "Cart" and CartObject ~= Prefilled_CanoeObject then
					Cones_chg = true
					if PLANE_ICAO == "SF34" or PLANE_ICAO == "DH8D" or PLANE_ICAO == "DH8C"  or string.match(PLANE_ICAO,"DH8A") or string.match(PLANE_ICAO,"CRJ") or string.match(PLANE_ICAO,"GLF") or ((string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and string.match(SGES_Author,"Marko")) or plane_has_cargo_hold_on_the_left_hand_side then
						Pax_chg = true -- to avoid collision of the cart with moving passengers, we had to hide them. Make them reappear now.
					end
				end


				return changed,Instance,refrce,Initial_X,Initial_Z
			end
		end
	end



	--------------------------------------------------------------------------------
	--										STAIRS
	--------------------------------------------------------------------------------


	--forbid_only_once_the_stairs_to_appear = false
	function react_to_door_dataref()
		--~ Marci353 said :
		--~ I was wondering, would it be possible to move the stairs in binding with a value of a dataref? I did not find yet the solution in SGES script.
		--~ I mean I fly FF B767, where the left front door dataref is "1-sim/anim/doors/FL/anim ". When its value is 0, the door is closed. When it begins to open (animated), the value starts to increase from 0 to 0.999996, then it is fully open. Top close and open I use the EFB's menu in the cockpit.

		-- ALGO FOR THIS IS :
		-- 1) watch my declared dataref in the ACFT SGES Conf file
		-- 2) if the value is a open door, then show the forward stairs but only if it is not already in place.
		if dataref_to_open_the_door ~= nil and index_to_open_the_door ~= nil and not string.match(PLANE_ICAO, "B73") then -- don't go more forward if stairs already in place

			-- find the dataref
			if PaxDoor1L == nil and XPLMFindDataRef(dataref_to_open_the_door) ~= nil then
					dataref("PaxDoor1L",dataref_to_open_the_door,"writable",index_to_open_the_door)
			end

			if PaxDoor1L ~= nil and PaxDoor1L == target_to_open_the_door  and show_StairsXPJ == false then
				-- then show the forward stairs (and apply consequent actions)
				show_StairsXPJ = true
				StairsXPJ_chg = true
				forbid_only_once_the_stairs_to_appear = true
				if show_StairsXPJ == true and show_StairsXPJ2 == false then
					BoardStairsXPJ2 = false
					BoardStairsXPJ = true
					StairFinalY = StairFinalY_stairIII
					StairFinalH = StairFinalH_stairIII
					StairFinalX = StairFinalX_stairIII
					InitialPaxHeight = InitialPaxHeight_stairIII
				end

				if IsPassengerPlane == 0 then
					show_ULDLoader = true
					ULDLoader_chg = true
				end
				show_BeltLoader = true
				if PLANE_ICAO == "A3ST" then show_BeltLoader = false end
				BeltLoader_chg = true
				show_Cart = true
				Cart_chg = true
				show_Cones = true
				Cones_chg = true
				-- if the door is closed by the user, remove the stairs
			elseif PaxDoor1L ~= nil and PaxDoor1L ~= target_to_open_the_door and show_StairsXPJ then
				show_StairsXPJ2 = false
				StairsXPJ2_chg = true
				show_StairsXPJ = false
				StairsXPJ_chg = true
				--forbid_only_once_the_stairs_to_appear = false
				show_ULDLoader = false
				ULDLoader_chg = true
				show_BeltLoader = false
				BeltLoader_chg = true
				show_Cart = false
				Cart_chg = true
				show_Cones = false
				Cones_chg = true
			end
		end
	end

	local stair_height = 5
	function draw_StairsXPJ()
		--[[

			the higher part of the front airstair

		--]]

		heading_factor = 180
		vertical_position = vertical_door_position - 2.82 + targetDoorH_alternate
		lateral_deviation = targetDoorX+deltaDoorX + 3.6 + targetDoorX_alternate

		if SGES_stairs_type == "Boarding_without_stairs" then --patch
			vertical_position = vertical_door_position - 3.65 + targetDoorH_alternate
			lateral_deviation = targetDoorX+deltaDoorX + 0.99 + targetDoorX_alternate
		end

		if protect_StairsXPJ then lateral_deviation = lateral_deviation + 7.5 + 2 end

		-- targetDoorX_alternate is normally zero and is only different than zero if set manually by user in GUI
		--~ if targetDoorX == 0 then -- Warn
				--~ print("[Ground Equipment " .. version_text_SGES .. "] The longitudinal location of the stairs is NOT set in the aircraft file .acf.")
		--~ end
		StairHigherPartX_stairIII = lateral_deviation
		if SGES_stairs_type == "New_Normal" then
			longitudinal_position = -targetDoorZ+0.12
		else
			longitudinal_position = -targetDoorZ+0.25
		end
		longitudinal_position_higher_part = longitudinal_position + targetDoorZ_alternate
		coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_deviation, longitudinal_position_higher_part, sges_gs_plane_head[0])
		stair_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
		targetDoorAltitude = sges_gs_plane_y[0] + vertical_position -- OK fot ToLiss
		stair_height = targetDoorAltitude - stair_y

		objpos_value[0].x = g_shifted_x
		objpos_value[0].z = g_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] - 88 + heading_factor
		float_value[0] = 0
		float_addr = float_value
		--print("[Ground Equipment " .. version_text_SGES .. "] TARGET DOOR ALTITUDE IS ".. targetDoorAltitude .. " and deltaDoorX = " .. deltaDoorX .. "  sges_gs_plane_y[0] : " .. sges_gs_plane_y[0] .. "\n\n")
		objpos_value[0].y = targetDoorAltitude
		objpos_addr = objpos_value

		if wetness == 0  then XPLM.XPLMInstanceSetPosition(StairsXPJ_instance[0], objpos_addr, float_addr) end

		--[[

			the lower part of the front airstair

		--]]
		-- now, the base of the stairs
		--~ print("targetDoorAltitude = " .. targetDoorAltitude)
		--~ print("stair_y = " .. stair_y)
		--~ print("sges_gs_plane_y[0] = " .. sges_gs_plane_y[0])
		--~ print("stair_height = targetDoorAltitude - stair_y = " .. stair_height)
		if SGES_stairs_type == "New_Normal" then
			delta_base = 1.8 * stair_height + 9.39
			if protect_StairsXPJ then delta_base = delta_base + 7.5 + 2 end
		elseif SGES_stairs_type == "Boarding_without_stairs" then
			delta_base = 0.5 * stair_height + 8
		else

			if string.match(AIRCRAFT_PATH,"146") and string.match(AIRCRAFT_PATH,"E1") then
				delta_base = 3.8
			else
				--delta_base = 4.5 --made dynamic may 2023
				delta_base = lateral_deviation - 3.5 + (0.2 * vertical_position)
			end
		end

		--if stair_height < 0 then delta_base = 15 end
		-- second run once DeltaDoorX has ben obtained
		coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], delta_base, longitudinal_position + targetDoorZ_alternate, sges_gs_plane_head[0]-0.35)
		acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
		objpos_value[0].x = g_shifted_x
		objpos_value[0].z = g_shifted_z
		objpos_value[0].heading = sges_gs_plane_head[0] - 88 + heading_factor
		--objpos_value[0].heading = sges_gs_plane_head[0] - 85 + heading_factor
		--if PLANE_ICAO == "CONC" then objpos_value[0].heading = sges_gs_plane_head[0] - 90 + heading_factor end
		float_value[0] = 0
		float_addr = float_value
		objpos_value[0].y = acft_y
		objpos_addr = objpos_value
		if wetness == 0 then XPLM.XPLMInstanceSetPosition(StairsXPJ_instance[1], objpos_addr, float_addr)   end
		------------------
		StairsXPJ_chg = false               -- indicate that the possible change in ramp/gate has been processed
		-- store position for passenger deplacement
		StairFinalY = longitudinal_position - 0.15 + targetDoorZ_alternate
		StairFinalH = targetDoorAltitude + targetDoorH_alternate
		if SGES_stairs_type == "New_Normal" then
			StairFinalX = delta_base + 5.7 + targetDoorX_alternate
		elseif SGES_stairs_type == "Boarding_without_stairs" then
			StairFinalX = delta_base + 3 + targetDoorX_alternate
		else -- if the stair is the small variant, we start the climb closer to the aircraft
			StairFinalX = delta_base + 4.65 + targetDoorX_alternate
		end
		InitialPaxHeight = stair_y + targetDoorH_alternate
		--  targetDoor(H|Z|X)_alternate is often zero
		BoardStairsXPJ = true
		BoardStairsXPJ2 = false

		-- store position for passenger deplacement change
		StairFinalY_stairIII = StairFinalY
		StairFinalH_stairIII = StairFinalH
		StairFinalX_stairIII = StairFinalX
		InitialPaxHeight_stairIII = InitialPaxHeight
	end

	function draw_StairsXPJ2()

		heading_factor = 180
		vertical_position2 = vertical_door_position2 - 2.82
		lateral_deviation2 = targetDoorX+deltaDoorX2 + 3.55

		if SGES_stairs_type == "Boarding_without_stairs" then --patch
			vertical_position2 = vertical_door_position2 - 3.65
			lateral_deviation2 = targetDoorX+deltaDoorX2 + 0.99
		end


		if protect_StairsXPJ then lateral_deviation2 = lateral_deviation2 + 7.5 + 5 end

		StairHigherPartX_stairIV = lateral_deviation2

		if SecondStairsFwdPosition ~= -30 then
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_deviation2, SecondStairsFwdPosition, sges_gs_plane_head[0] + sges_gs_plane_head_correction2 )
			stair_y = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			targetDoorAltitude2 = sges_gs_plane_y[0] + vertical_position2 -- OK fot ToLiss

			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			objpos_value[0].heading = sges_gs_plane_head[0] + sges_gs_plane_head_correction2 - 90 + heading_factor
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = targetDoorAltitude2
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(StairsXPJ2_instance[0], objpos_addr, float_addr)

			-- now, the base of the stairs
			stair_height = targetDoorAltitude2 - stair_y

			delta_base2 = 1.8 * stair_height + 9.39
			if protect_StairsXPJ then delta_base2 = delta_base2 + 7.5 + 5 end
			if SGES_stairs_type == "Boarding_without_stairs" then
				delta_base2 = 0.5 * stair_height + 8
			end
			-- second run once DeltaDoorX has ben obtauned
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], delta_base2 , SecondStairsFwdPosition, sges_gs_plane_head[0] + sges_gs_plane_head_correction2 )
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			objpos_value[0].heading = sges_gs_plane_head[0] + sges_gs_plane_head_correction2 - 90 + heading_factor
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = acft_y
			objpos_addr = objpos_value
			if wetness == 0 then XPLM.XPLMInstanceSetPosition(StairsXPJ2_instance[1], objpos_addr, float_addr)   end
			------------------
			StairsXPJ2_chg = false               -- indicate that the possible change in ramp/gate has been processed

			-- store position for passenger deplacement change
			StairFinalY_stairIV = SecondStairsFwdPosition - 0.15
			StairFinalH_stairIV = targetDoorAltitude2
			if SGES_stairs_type == "New_Normal" then
				StairFinalX_stairIV = delta_base2 + 5.7
			elseif SGES_stairs_type == "Boarding_without_stairs" then
				StairFinalX_stairIV = delta_base2 + 3
			else

				StairFinalX_stairIV = delta_base2 + 4.65
			end
			InitialPaxHeight_stairIV = stair_y
		end
	end

	function draw_StairsXPJ3()
		if SGES_stairs_type ~= "Boarding_without_stairs" and SecondStairsFwdPosition ~= -30 then

			local vertical_position3 = vertical_position
			local lateral_deviation3 = lateral_deviation

			--~ if protect_StairsXPJ then lateral_deviation3 = lateral_deviation + 7.5 end

			if vertical_position == nil then -- happens when a jetway is connected and the front stairs has therefore not be initiliazed, so we use values directly here.
				vertical_position3 = vertical_door_position - 2.82 + targetDoorH_alternate
				lateral_deviation3 = targetDoorX+deltaDoorX + 3.6 + targetDoorX_alternate
			end
			if sign3 == nil then sign3 = 1 end
			if heading_factor3 == nil then heading_factor3 = 180 end
				--~ height_factor3 = 0
				--~ longitudinal_factor3 = 0
				--~ lateral_factor3 = 0

			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], sign3 * (lateral_deviation3+lateral_factor3), longitudinal_factor3, sges_gs_plane_head[0] + sges_gs_plane_head_correction3 )
			stair_y = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)

			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			objpos_value[0].heading = sges_gs_plane_head[0] + sges_gs_plane_head_correction3 - 90 + heading_factor3
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = sges_gs_plane_y[0] + (vertical_position3 + height_factor3) -- OK fot ToLiss
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(StairsXPJ3_instance[0], objpos_addr, float_addr)

			-- second run once DeltaDoorX has ben obtained
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], sign3 * (1.8 * (objpos_value[0].y  - stair_y) + 9.39 +lateral_factor3), longitudinal_factor3, sges_gs_plane_head[0] + sges_gs_plane_head_correction3 )
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			objpos_value[0].heading = sges_gs_plane_head[0] + sges_gs_plane_head_correction3 - 90 + heading_factor3
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = acft_y
			objpos_addr = objpos_value
			if wetness == 0 then XPLM.XPLMInstanceSetPosition(StairsXPJ3_instance[1], objpos_addr, float_addr)   end
			------------------
			StairsXPJ3_chg = false               -- indicate that the possible change in ramp/gate has been processed
		end
	end
	--------------------------------------------------------------------------------
	local            target_aspect_ratio = 0
	local            target_altitude = 0
	local            target_distance = 0

	function draw_FireVehicle()
		--if (sges_gs_gnd_spd[0] > 1 and sges_gs_gnd_spd[0] < 120) or (sges_gs_gnd_spd[0] < -1 and sges_gs_gnd_spd[0] > -20) then
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = acft_y
			objpos_value[0].pitch = 0
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
			if show_FireVehicleAhead == false and show_Watersalute == false and show_Pelicandrome == false then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 5, -50 - 0.60 * sges_gs_gnd_spd[0] - 0.15 * math.abs(sges_nosewheel[0]), sges_gs_plane_head[0] )
				objpos_value[0].heading = sges_gs_plane_head[0] - 0.6 * sges_nosewheel[0] -- reverse since it's behind
				if Clairmarais_Aerodrome_directory ~= nil and Prefilled_FireObject ==  Clairmarais_Aerodrome_directory   .. "Vehicles/Truck_Ambulance.obj" then objpos_value[0].heading = objpos_value[0].heading + 180	end
			elseif show_FireVehicleAhead == false and show_Watersalute then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 40, 90, sges_gs_plane_head[0] )
				objpos_value[0].heading = sges_gs_plane_head[0] + 90
			elseif show_FireVehicleAhead == false  and show_Pelicandrome then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 14.80, 8, sges_gs_plane_head[0] )
				objpos_value[0].heading = sges_gs_plane_head[0] - 22
			else
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, DistanceToCrashSite, sges_gs_plane_head[0] )
				objpos_value[0].heading = sges_gs_plane_head[0] + 7
			end
			objpos_value[0].x = g_shifted_x
			objpos_value[0].z = g_shifted_z
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			float_value[0] = 0
			float_addr = float_value
			objpos_value[0].y = acft_y
			objpos_addr = objpos_value

			-- save for oral announcements
			target_x = g_shifted_x -- has to be dynamic
			target_y = acft_y
			target_z = g_shifted_z -- has to be dynamic

		if wetness == 0 then
			XPLM.XPLMInstanceSetPosition(FireVehicle_instance[0], objpos_addr, float_addr)
			if FireVehicle_instance[1] ~= nil then XPLM.XPLMInstanceSetPosition(FireVehicle_instance[1], objpos_addr, float_addr) end
			if FireVehicle_instance[2] ~= nil then  -- RED Dog commander
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], -5, -60 - 0.50 * sges_gs_gnd_spd[0] - 0.05 * math.abs(sges_nosewheel[0]), sges_gs_plane_head[0] )
				if show_FireVehicleAhead == false  and show_Pelicandrome then
					coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 11, 18, sges_gs_plane_head[0] )
					objpos_value[0].heading = sges_gs_plane_head[0] + 12
				end
				objpos_value[0].x = g_shifted_x
				objpos_value[0].z = g_shifted_z
				objpos_value[0].y = acft_y
				objpos_addr = objpos_value
				XPLM.XPLMInstanceSetPosition(FireVehicle_instance[2], objpos_addr, float_addr)
			end
			if show_FireVehicleAhead == false and show_Pelicandrome and FireVehicle_instance[3] ~= nil then  -- Hose for Pelicandrome
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 13, 7, sges_gs_plane_head[0] )
				objpos_value[0].heading = sges_gs_plane_head[0] - 85
				objpos_value[0].x = g_shifted_x
				objpos_value[0].z = g_shifted_z
				objpos_value[0].y = acft_y
				objpos_addr = objpos_value
				XPLM.XPLMInstanceSetPosition(FireVehicle_instance[3], objpos_addr, float_addr)
			--~ elseif show_Pelicandrome == false and FireVehicle_instance[3] ~= nil then
				--~ _,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
			end
		else
			--show_FireVehicle = false
		end

		--end
		if show_FireVehicleAhead or show_Watersalute or show_Pelicandrome then
			FireVehicle_chg = false -- make that static if static EMS site ahead
		end

	end


	if UseXplaneDefaultObject == false then -- do not arm passengers when we use default x-plane objects

		StairFinalH = 0

		--~ function deconflict_two_passengers(Paxname,Previouspax)
			--~ local in_conflict = false
			--~ local maxvar = 2
			--~ local in_conflict_lat = false
			--~ local in_conflict_lon = false
			--~ if Pax_lat_t[Previouspax] ~= nil and Pax_lat_t[Paxname] ~= nil and Pax_lon_t[Previouspax] ~= nil and Pax_lon_t[Paxname] ~= nil then
				--~ if  Pax_lat_t[Previouspax] - maxvar < Pax_lat_t[Paxname] and Pax_lat_t[Paxname] < Pax_lat_t[Previouspax] + maxvar then
					--~ in_conflict_lat = true
				--~ end

				--~ if  Pax_lon_t[Previouspax] - maxvar < Pax_lon_t[Paxname] and Pax_lon_t[Paxname] < Pax_lon_t[Previouspax] + maxvar then
					--~ in_conflict_lon = true
				--~ end
			--~ end
			--~ if in_conflict_lon and in_conflict_lat and Passenger_step_t[Previouspax] == 0 and Passenger_step_t[Paxname] == 0 then
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Deconflicts passengers. Slowing " .. Paxname .. ", close to " .. Previouspax .. ".")
				--~ in_conflict = true
			--~ end
			--~ return in_conflict
		--~ end

		function passenger_search_of_stairs(longpos,latpos,lontarget,lattarget,latobstacle,lonobstacle,Paxname,PreviousPax)
			----------------------------------------------------------------
			-- passengers are walking upon each others.
			-- we want to reduce the effect by applying a displacement modifier when it happens
			--~ local pax_in_conflict = deconflict_two_passengers(Paxname,PreviousPax)
			----------------------------------------------------------------

			if latobstacle == nil then latobstacle = lattarget end
			if lonobstacle == nil then lonobstacle = lontarget end
			-- longitudinal position
			longthreshold = 0.01
			-- if passenger is in front of target but after cone, then continue backward and sided
			if longpos > lontarget + longthreshold then longadvance = -0.007	passenger_heading = 45
			-- if passenger is behind of target, then continue forward
			elseif longpos < lontarget - longthreshold then longadvance = 0.007 passenger_heading = 135
			-- if passenger is inside target area, stop longitudinal move
			elseif longpos <= lontarget + longthreshold or longpos >= lontarget - longthreshold then longadvance = 0 passenger_heading = 90
			else longadvance = 0 passenger_heading = 90
			end

			--~ if pax_in_conflict then longadvance = longadvance / 4 end
			longpos = longpos + longadvance

			-- lateral position (made simple but watch the val.abs in the future)    test lontarget < 0 is because we want this for pax going rearward only
			if math.abs(latpos) < math.abs(lattarget) + 0.05 then -- reached the stairs
				latadvance = 0
			elseif lontarget < 0 and show_Cones and longadvance ~= 0 and latpos < latobstacle + 1.25 and longpos < lonobstacle and SecondStairsFwdPosition < 1 then -- reached the cone when walking to aft stairs
				latadvance = 0.0022 passenger_heading = 12
			elseif lontarget < 0 and show_Cones and longadvance ~= 0 and latpos < latobstacle + 1.25 and SecondStairsFwdPosition < 1 then -- reached the cone when walking to aft stairs
				latadvance = 0.0003 passenger_heading = -3
			else
				math.randomseed(os.time())
				randomView = math.random()
				if randomView > 0.3 and randomView <= 0.8 then latadvance = 0.006
				elseif randomView > 0.8 then latadvance = 0.007
				else  latadvance = 0.005
				end
				-- random to deconflict personnas
			end
			--~ if pax_in_conflict then latadvance = latadvance / 4 end
			latpos = latpos - latadvance

			return longpos,latpos,passenger_heading,longadvance,latadvance
		end



		progressions1_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions2_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions3_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions4_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions5_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions6_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions7_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions8_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions9_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions10_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions11_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions12_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
		progressions_t  = {Pax1=progressions1_t, Pax2=progressions2_t, Pax3=progressions3_t, Pax4=progressions4_t, Pax5=progressions5_t, Pax6=progressions6_t, Pax7=progressions7_t, Pax8=progressions8_t, Pax9=progressions9_t, Pax10=progressions10_t, Pax11=progressions11_t, Pax12=progressions12_t}

		Pax_lat_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		Pax_lon_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		Pax_hgt_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		Pax_hdg_t = {Pax1=sges_gs_plane_head[0] - 90,Pax2=sges_gs_plane_head[0] - 90,Pax3=sges_gs_plane_head[0] - 90,Pax4=sges_gs_plane_head[0] - 90,Pax5=sges_gs_plane_head[0] - 90,Pax6=sges_gs_plane_head[0] - 90,Pax7=sges_gs_plane_head[0] - 90,Pax8=sges_gs_plane_head[0] - 90,Pax9=sges_gs_plane_head[0] - 90,Pax10=sges_gs_plane_head[0] - 90,Pax11=sges_gs_plane_head[0] - 90,Pax12=sges_gs_plane_head[0] - 90}
		finalPax_lon_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		last_recorded_pax_height_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		last_recorded_pax_latitude_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		--Passenger_step_t = {Pax1=-1,Pax2=-1,Pax3=-1,Pax4=-1,Pax5=-1,Pax6=-1,Pax7=-1,Pax8=-1,Pax9=-1,Pax10=-1,Pax11=-1,Pax12=-1} --line 890+-
		Pax_chrono_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		checkpoint_chrono_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}

		--~ function avoid_superposed_passengers(longpos,latpos,lontarget,lattarget,latobstacle,lonobstacle)
			--~ return longpos,latpos,passenger_heading,longadvance,latadvance
		--~ end


		--~ To represent records, you use the field name as an index.
		--~ Lua supports this representation by providing a.name as syntactic sugar for a["name"].
		--~ A common mistake for beginners is to confuse a.x with a[x]. The first form
		--~ represents a["x"], that is, a table indexed by the string "x".
		-- https://stackoverflow.com/questions/15730646/variable-names-in-table-field-not-working
		saved_checkpoint_time = 0
		PreviousPax = "none"

		initial_pax_start = true
		if debugging_passengers then
			walking_direction = "deboarding" -- deboarding / boarding
			show_Bus = true
			Bus_chg = true
			show_StairsXPJ = true
			StairsXPJ_chg = true
			show_Pax = true
			Pax_chg = true
			initial_pax_start = true
			SGES_start_delay = 0
		end
		--------------------------------------------------------------------------------------------------------------------------------



		-- BOARDING


		--------------------------------------------------------------------------------------------------------------------------------
		function draw_all_Passengers(StairFinal_lat,StairFinal_lon,BusFinalX,BusFinalY,Instance,Paxname)
			-- wait for stairs or crash !
			if StairFinal_lat == nil then StairFinal_lat = BusFinalX end -- patch march 2024 to avoid FWL crash
			if StairFinal_lon == nil then  StairFinal_lon = BusFinalY end -- patch march 2024 to avoid FWL crash
			-- the patch gives a temporary difinition until updated by "stairs" or "no stairs" (over written)

			-- when a different offset exist as passenger anchor point for boarding, adjust it here the consequences
			if targetDoorX_alternate_boarding ~= nil then StairFinal_lat = StairFinal_lat - targetDoorX_alternate + targetDoorX_alternate_boarding end

			if SGES_mirror == 1 and StairFinal_lat > 0 then
				StairFinal_lat = -1 * StairFinal_lat
			end

			finalPax_lat 			= StairFinal_lat
			finalPax_lon_t[Paxname] 	= StairFinal_lon
			if SGES_stairs_type ~= "Boarding_without_stairs" and  Paxname == "Pax4" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.6 -- suit guy is on the left hand side of the stair
			elseif Paxname == "Pax4" then -- Boarding_without_stairs
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.1 -- suit guy is on the left hand side of the stair
			end


			-- dual boarding section ---------------------------------------
			if DualBoard and (Paxname  == "Pax6" or Paxname  == "Pax7" or Paxname  == "Pax8" or Paxname  == "Pax9" or Paxname  == "Pax10" or Paxname  == "Pax11" or Paxname  == "Pax12") then
			-- it could be random, be let's the the boarding is more organised than the deboarding.
				if BoardStairsXPJ2 then -- then redirect to stair Mk III
					finalPax_lon_t[Paxname] =  		StairFinalY_stairIII
				elseif BoardStairsXPJ then -- then redirect to stair Mk IV
					finalPax_lon_t[Paxname] =  		StairFinalY_stairIV
				end
			end
			----------------------------------------------------------------


			if SGES_stairs_type ~= "Boarding_without_stairs" then
				if Paxname == "Pax6" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.6 -- suit guy 2 is on the left hand side of the stair
				end
				if Paxname == "Pax7" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.4 --  guy is on the right hand side of the stair to avoid colisions
				end
				if Paxname == "Pax9" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.3 --  guy is on the right hand side of the stair to avoid colisions
				end
				if Paxname == "Pax10" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.6 -- suit guy is on the left hand side of the stair
				end
				if Paxname == "Pax11" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.1 --  guy is on the right hand side of the stair to avoid colisions
				end
				if Paxname == "Pax12" then
					finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] + 0.4 -- suit guy 2 is on the left hand side of the stair
				end
			end

			if SGES_stairs_type == "Boarding_without_stairs" then
				if finalPax_lon_t[Paxname] ~= nil then finalPax_lon_t[Paxname] 	= finalPax_lon_t[Paxname] - 0.15 end
			end

			-- define initial positions
			--if Passenger_step_t[Paxname] == -1 and Pax_lat_t[Paxname] == 0 and Pax_lon_t[Paxname] == 0 then
			if Passenger_step_t[Paxname] == -1 then
				--~ if Paxname ~= nil then print("[Ground Equipment " .. version_text_SGES .. "] starting Passenger " .. Paxname) end
				-- taking note of the current elpased time to sequence the passengers departures
				Pax_chrono_t[Paxname] = SGES_total_flight_time_sec

				if Paxname == "Pax1" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY
				elseif Paxname == "Pax2" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY - 1
				elseif Paxname == "Pax3" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY - 4
				elseif Paxname == "Pax4" then
					Pax_lat_t[Paxname] =  		BusFinalX - 3
					Pax_lon_t[Paxname] =  		BusFinalY + 3.5
				elseif Paxname == "Pax5" then
					Pax_lat_t[Paxname] =  		BusFinalX - 1
					Pax_lon_t[Paxname] =  		BusFinalY  - 5
				elseif Paxname == "Pax6" then
					Pax_lat_t[Paxname] =  		BusFinalX - 2
					Pax_lon_t[Paxname] =  		BusFinalY + 2
				end

				-- added12-2022 :

				if Paxname == "Pax7" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY
				elseif Paxname == "Pax8" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY - 1
				elseif Paxname == "Pax9" then
					Pax_lat_t[Paxname] =  		BusFinalX
					Pax_lon_t[Paxname] =  		BusFinalY - 4
				elseif Paxname == "Pax10" then
					Pax_lat_t[Paxname] =  		BusFinalX - 3
					Pax_lon_t[Paxname] =  		BusFinalY - 2
				elseif Paxname == "Pax11" then
					Pax_lat_t[Paxname] =  		BusFinalX - 1
					Pax_lon_t[Paxname] =  		BusFinalY  - 5
				elseif Paxname == "Pax12" then
					Pax_lat_t[Paxname] =  		BusFinalX - 2
					Pax_lon_t[Paxname] =  		BusFinalY + 1
				end

				if SGES_mirror == 1 then
					Pax_lat_t[Paxname] =  		BusFinalX + 2
					Pax_lon_t[Paxname] =  		StairFinal_lon
					-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
					   progressions_t[Paxname] = {-0.008, 0.0075, 0.00, sges_gs_plane_head[0] + 90}
					--~ print(Paxname .. " is starting to board in the mirrored way. " .. StairFinal_lat)
				else
					-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
					   progressions_t[Paxname] = {0.006, 0.0075, 0.00, sges_gs_plane_head[0] - 90}
				end

				if initial_pax_start then

					--~ if spacer == nil then fps = get("sim/time/framerate_period")
						--~ if     fps <= 30 then spacer = 4 print(fps .. "FPS quite low, spacing passengers more")
						--~ elseif fps <= 34 then spacer = 3 print(fps .. "FPS low, spacing passengers")
						--~ elseif fps <= 36 then spacer = 2 print(fps .. "FPS average low, spacing passengers a little more")
						--~ elseif fps <= 40 then spacer = 1.5 print(fps .. "FPS average, spacing passengers a little") end
					--~ end -- WIP
					if spacer == nil and PLANE_ICAO =="DH8D" and string.find(SGES_Author,"FlyJSim") then spacer = 6 else spacer = 0 end -- Q4XP has low frame rate

					-- sequencing every n seconds
					if Passenger_step_t.Pax1 == -1 and Pax_chrono_t.Pax1 ~= 0 					  then  Passenger_step_t.Pax1 = 0 end
					if Passenger_step_t.Pax2 == -1 and Pax_chrono_t.Pax2 >= Pax_chrono_t.Pax1 + spacer + 5 then  Passenger_step_t.Pax2 = 0 end
					if Passenger_step_t.Pax3 == -1 and Pax_chrono_t.Pax3 >= Pax_chrono_t.Pax2 + spacer + 11 then  Passenger_step_t.Pax3 = 0 end
					if Passenger_step_t.Pax4 == -1 and Pax_chrono_t.Pax4 >= Pax_chrono_t.Pax3 + spacer + 7 then  Passenger_step_t.Pax4 = 0 end
					if Passenger_step_t.Pax5 == -1 and Pax_chrono_t.Pax5 >= Pax_chrono_t.Pax4 + spacer + 6 then  Passenger_step_t.Pax5 = 0  end
					if Passenger_step_t.Pax6 == -1 and Pax_chrono_t.Pax6 >= Pax_chrono_t.Pax5 + spacer + 8 then  Passenger_step_t.Pax6 = 0 end --initial_pax_start = false end

					if Passenger_step_t.Pax7 == -1 and Pax_chrono_t.Pax7 >= Pax_chrono_t.Pax6 + spacer + 3 then  Passenger_step_t.Pax7 = 0 if debugging_passengers then print("pax7") end end
					if Passenger_step_t.Pax8 == -1 and Pax_chrono_t.Pax8 >= Pax_chrono_t.Pax7 + spacer + 5 then  Passenger_step_t.Pax8 = 0 if debugging_passengers then print("pax8") end end
					if Passenger_step_t.Pax9 == -1 and Pax_chrono_t.Pax9 >= Pax_chrono_t.Pax8 + spacer + 10 then  Passenger_step_t.Pax9 = 0 if debugging_passengers then print("pax9") end end
					if Passenger_step_t.Pax10 == -1 and Pax_chrono_t.Pax10 >= Pax_chrono_t.Pax9 + spacer + 6 then  Passenger_step_t.Pax10 = 0 if debugging_passengers then print("pax10") end end
					if Passenger_step_t.Pax11 == -1 and Pax_chrono_t.Pax11 >= Pax_chrono_t.Pax10 + spacer + 2 then  Passenger_step_t.Pax11 = 0 if debugging_passengers then print("pax11") end  end
					if Passenger_step_t.Pax12 == -1 and Pax_chrono_t.Pax12 >= Pax_chrono_t.Pax11 + spacer + 9 then  Passenger_step_t.Pax12 = 0 if debugging_passengers then print("pax12") end  initial_pax_start = false end

					-- when boarding into a small aircraft or an helicopter, limit immediatly the number of passengers
					if math.abs(BeltLoaderFwdPosition) < 4.5 or (IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) or PLANE_ICAO == "GLF650ER" or PLANE_ICAO == "E19L" then
						terminate_passenger_action = true
						if Paxname ~= nil and (tonumber(Paxname:sub(-1)) % 2 == 0 or tonumber(Paxname:sub(-1)) > 8 or Paxname == "Pax11") and Passenger_step_t[Paxname] == 0 then
							Passenger_step_t[Paxname] = 5
							print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  removed due to aircraft seating capacity (boarding).")
						end -- kill one pax over 2
					end
					--------------------------------------------------------
					-- user choice to reduce even more the number of passengers
					if  reduce_even_more_the_number_of_passengers and Passenger_instance[2] ~= nil and Paxname ~= nil and Paxname == "Pax3" and Passenger_step_t[Paxname] == 0 then
						Passenger_step_t[Paxname] = 5
						print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  also removed due to seating capacity (boarding) (user option).")
					end
					if  reduce_even_more_the_number_of_passengers and Passenger_instance[6] ~= nil and Paxname ~= nil and Paxname == "Pax7" and Passenger_step_t[Paxname] == 0 then
						Passenger_step_t[Paxname] = 5
						print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  also removed due to seating capacity (boarding) (user option).")
					end
					--------------------------------------------------------
				else
					Passenger_step_t[Paxname] = 0
				end
				--if Passenger_step_t[Paxname] == 0  then print("[Ground Equipment " .. version_text_SGES .. "] starting Passenger " .. Paxname .. " at " .. Pax_chrono_t[Paxname])	end

			end

			if Passenger_step_t[Paxname] == 0  then -- passenger is walking to the boarding stairs
				--if debugging_passengers then print("step 0 " .. Paxname) end
				if SGES_stairs_type == "Boarding_without_stairs" then
					if finalPax_lat == nil then finalPax_lat = 0 end -- PATCH MARCH 2024 to avoid FWL Crash
					if finalPax_lon_t[Paxname] == nil then finalPax_lon_t[Paxname] = 0 end
					finalPax_lat = finalPax_lat -6
					if SGES_mirror == 1 then -- ////// MIRROR BOARDING CASE ///////////
						finalPax_lat = finalPax_lat + 11.96
					end
				end --hugly patch


				--~ Pax_lon_t[Paxname],Pax_lat_t[Paxname],hdg_component,progressions_t[Paxname][2],progressions_t[Paxname][1] = passenger_search_of_stairs(Pax_lon_t[Paxname],Pax_lat_t[Paxname],finalPax_lon_t[Paxname],finalPax_lat,latcone,loncone,Paxname,PreviousPax)

				if SGES_mirror == 1 then -- ////// MIRROR BOARDING CASE ///////////
					Pax_lat_t[Paxname] = Pax_lat_t[Paxname] - progressions_t[Paxname][1]
					Pax_lon_t[Paxname] = StairFinal_lon -- fixed
					hdg_component = -90
				else
					Pax_lon_t[Paxname],Pax_lat_t[Paxname],hdg_component,progressions_t[Paxname][2],progressions_t[Paxname][1] = passenger_search_of_stairs(Pax_lon_t[Paxname],Pax_lat_t[Paxname],finalPax_lon_t[Paxname],finalPax_lat,latcone,loncone,Paxname,PreviousPax)
				end
				Pax_hdg_t[Paxname] = sges_gs_plane_head[0] - hdg_component -- hdg component in this case is variable cause it's defined per the passenger search of stairs

				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )

				if SGES_mirror == 1 then -- ////// MIRROR BOARDING CASE ///////////
					Pax_hgt_t[Paxname] = probe_y (g_shifted_x, 0, g_shifted_z)
				end

				objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,Pax_hdg_t[Paxname],nil,"grd2stairs")
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
				-- SAVE HEIGHT :
				if SGES_mirror == 0 and progressions_t[Paxname][1] == 0 and progressions_t[Paxname][2] == 0 then
					Pax_hgt_t[Paxname] = probe_y (g_shifted_x, 0, g_shifted_z)
					last_recorded_pax_height_t[Paxname] = Pax_hgt_t[Paxname]

					progressions_t[Paxname] = {0, 0, 0, sges_gs_plane_head[0] - 90}
					checkpoint_chrono_t[Paxname] = sges_current_time
					if debugging_passengers then print("paxname " .. Paxname .. " / PreviousPax " .. PreviousPax) end
					-- init
					if PreviousPax == "none" or IsPassengerPlane == 0 then Passenger_step_t[Paxname] = 1 PreviousPax = Paxname else Passenger_step_t[Paxname] = 0.5 end
				elseif SGES_mirror == 1 and Pax_lat_t[Paxname] >= finalPax_lat then	-- a simple trigger in this case, just based on the lateral distance to the targeted aircraft door -- ////// MIRROR BOARDING CASE ///////////
					if terminate_passenger_action then
						Passenger_step_t[Paxname] = 5 --kill the pax instead of recycling it.
						--~ print("[Ground Equipment " .. version_text_SGES .. "] [MIRROR BOARDING] Removed " .. Paxname .. " Lat " .. Pax_lat_t[Paxname] .. " Going to " .. StairFinal_lat .. " / Lon " .. Pax_lon_t[Paxname] .. " Height " .. Pax_hgt_t[Paxname])
						print(string.format("[Ground Equipment %s] [MIRROR BOARDING] Removed %s Lat %.2f (Going to %.2f) | Lon %.2f Height %.2f",
    version_text_SGES, Paxname, Pax_lat_t[Paxname], finalPax_lat, Pax_lon_t[Paxname], Pax_hgt_t[Paxname]))

					else
						Passenger_step_t[Paxname] = -1 -- recycle the pax
						--~ if Paxname == "Pax1" then print("Cycling " .. Paxname) end
					end
				end
				--~ if Paxname == "Pax1" then print("Seeing " .. Paxname .. " Lat " .. Pax_lat_t[Paxname] .. " Lon " .. Pax_lon_t[Paxname] .. " Height " .. Pax_hgt_t[Paxname]) end


 			elseif Passenger_step_t[Paxname] == 0.5 and checkpoint_chrono_t[Paxname] >= checkpoint_chrono_t[PreviousPax] + 5 then -- wait for first part of the stairs if too near from previous pax
					Passenger_step_t[Paxname] = 1
					PreviousPax = Paxname
					if debugging_passengers then print("Passed. Calling PreviousPax " .. PreviousPax .. ".") end
					checkpoint_chrono_t[PreviousPax] = sges_current_time

			elseif Passenger_step_t[Paxname] == 0.5 then
					checkpoint_chrono_t[Paxname] = sges_current_time --update that to watch it
					if debugging_passengers then print("Not Passed for " .. Paxname .. ". Chrono pax was " .. checkpoint_chrono_t[Paxname] .. " and chrono previous pax was " .. checkpoint_chrono_t[PreviousPax]) end

			elseif Passenger_step_t[Paxname] == 1 then -- first part of the stairs
				--if debugging_passengers then print("step 1 " .. Paxname) end
				progressions_t[Paxname] = {X_speed_part_1/1.3, 0.0001, H_speed_part_1/1.3, sges_gs_plane_head[0] - 90}
				if Paxname == "Pax4" or Paxname == "Pax6" then progressions_t[Paxname] = {X_speed_part_1/1.4, 0.0001, H_speed_part_1/1.4, Pax_hdg_t[Paxname]} end --suit guy is slower
				if Paxname == "Pax1" then progressions_t[Paxname] = {X_speed_part_1/1.2, 0.0001, H_speed_part_1/1.2, Pax_hdg_t[Paxname]} end --first guy is faster
				if SGES_stairs_type == "New_Normal" then
					if Pax_hgt_t[Paxname] > last_recorded_pax_height_t[Paxname] - 0.05 + 3.6	then Passenger_step_t[Paxname] = 2  	last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname] end
				else -- if the stair is the small variant, we don't climb that much as above in the taller airstair
					if Pax_hgt_t[Paxname] > StairFinalH - 0.1 + 5.68 		then   Passenger_step_t[Paxname] = 4   	last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname] end
				end





			elseif Passenger_step_t[Paxname] == 2 then -- first platform of the stairs
				progressions_t[Paxname] = {0.01/1.3, 0.001/1.3, 0, sges_gs_plane_head[0] - 90}

				if Pax_lat_t[Paxname] < last_recorded_pax_latitude_t[Paxname] - 0.05 - 0.7 and SGES_stairs_type == "New_Normal" then Passenger_step_t[Paxname] = 3 end
				-- we will sequence also to avoid superposed passengers, and I elect to do this at this first platform arbitrary

			elseif Passenger_step_t[Paxname] == 3 then -- second part of the stairs if any
				progressions_t[Paxname] = {X_speed_part_2, 0.0005, H_speed_part_2, sges_gs_plane_head[0] - 90}
				--~ lateral_progression = 0.005
				--~ height_progression = 0.005
				--~ hdg_component = 90
				if Pax_hgt_t[Paxname] > StairFinalH - 0.1 + 5.68 then Passenger_step_t[Paxname] = 4 last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname] end


			elseif Passenger_step_t[Paxname] == 4 then -- second platform of the stairs
				-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
				progressions_t[Paxname] = {0.01, 0.0007, 0.00, sges_gs_plane_head[0] - 90}
				--~ lateral_progression = 0.01
				--~ height_progression = 0
				--~ longitudinal_progression = 0.0015
				if Pax_lat_t[Paxname] < last_recorded_pax_latitude_t[Paxname] - 0.05 - 9 and Passenger_step_t[Paxname] ~= -99 then Passenger_step_t[Paxname] = 5 if debugging_passengers then print("step 5 - cycle " .. Paxname) end end



			elseif Passenger_step_t[Paxname] == 5 then -- KILL
				Passenger_step_t[Paxname] = -99 -- removed from the loop

				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger " .. Paxname .. " status is " .. Passenger_step_t[Paxname]) end
				--~ if Paxname == "Pax1" then print("[Ground Equipment " .. version_text_SGES .. "] Passenger " .. Paxname .. " status is " .. Passenger_step_t[Paxname]) end
				-- when ALL passengers have been prevented to be recycled (because the user asked to end the boarding)
				-- then remove the passengers for good and the bus :
				--~ if terminate_passeng

				--test_pax_99_status = (Passenger_step_t["Pax1"] == -99) and (Passenger_step_t["Pax2"] == -99) and (Passenger_step_t["Pax3"] == -99) and (Passenger_step_t["Pax4"] == -99) and (Passenger_step_t["Pax5"] == -99) and (Passenger_step_t["Pax6"] == -99) and (Passenger_step_t["Pax7"] == -99) and (Passenger_step_t["Pax8"] == -99) and (Passenger_step_t["Pax9"] == -99) and (Passenger_step_t["Pax10"] == -99) and (Passenger_step_t["Pax11"] == -99) and (Passenger_step_t["Pax12"] == -99)

				-- souci dans le language LUA pas capable de tester dans de nombreux tableaux simultanément. ?!?

				if Passenger_step_t["Pax1"] == -99 then pax1_disapp = true end
				if Passenger_step_t["Pax2"] == -99 then pax2_disapp = true end
				if Passenger_step_t["Pax3"] == -99 then pax3_disapp = true end
				if Passenger_step_t["Pax4"] == -99 then pax4_disapp = true end
				if Passenger_step_t["Pax5"] == -99 then pax5_disapp = true end
				if Passenger_step_t["Pax6"] == -99 then pax6_disapp = true end
				if Passenger_step_t["Pax7"] == -99 then pax7_disapp = true end
				if Passenger_step_t["Pax8"] == -99 then pax8_disapp = true end
				if Passenger_step_t["Pax9"] == -99 then pax9_disapp = true end
				if Passenger_step_t["Pax10"] == -99 then pax10_disapp = true end
				if Passenger_step_t["Pax11"] == -99 then pax11_disapp = true end
				if Passenger_step_t["Pax12"] == -99 then pax12_disapp = true end

				--if test_pax_99_status then print(" ========================== test est vrai ==========================") end

				--if terminate_passenger_action and show_Pax and test_pax_99_status
				if terminate_passenger_action and show_Pax and pax1_disapp and pax2_disapp and pax3_disapp and pax4_disapp and pax5_disapp and pax6_disapp  and pax7_disapp and pax8_disapp and pax9_disapp  and pax10_disapp and pax11_disapp and pax12_disapp
				then
					show_Pax = false
					show_Bus = false
					boarding_from_the_terminal = false
					Pax_chg = true
					Bus_chg = true
					print("[Ground Equipment " .. version_text_SGES .. "] All boarding passengers have progressively disappeared.")
					-- added stuff :
					show_People4 = false
					show_People3 = false
					show_People2 = false
					show_People1 = false
					People2_chg = true
					People1_chg = true
					People4_chg = true
					People3_chg = true
					terminate_passenger_action = false -- reset
				end

				if Instance ~= nil and terminate_passenger_action then       XPLM.XPLMDestroyInstance(Instance) end
			end

			--~ if Pax_lat_t[Paxname] ~= nil and Pax_lat_t[Paxname] < 1.3 then -- RECYCLE
			if SGES_mirror == 0 and Pax_lat_t[Paxname] ~= nil and Pax_lat_t[Paxname] < 1.3 and Passenger_step_t[Paxname] ~= -1 then -- RECYCLE (changed in July 2024 to avoid Too many callback error : Passenger_step_t[Paxname] ~= -1 condition added)

	-- change some passengers, only if they are designed to continue looping

				----------------------------------------------------------------
					------- WARNING JULY 2024 ----------
					-- -- UNLOADING TO RANDOMLY POP UP ANOTHER CHARACTER
					-- -- will cause "too many callback frequently
					-- What I did is to be sure to apply this only once :
					-- when Passenger_step_t[Paxname] == 4 and we now at this time
					-- is going to be -1 or 5 or -99 soon, so limitating
					-- a loop with an XPLM loadin insctruction that the XPLM engine
					-- cannot coop with !
					------------------------------------
				----------------------------------------------------------------

				if terminate_passenger_action == false and show_Pax and Passenger_step_t[Paxname] == 4 and Pax_lat_t[Paxname] ~= 0 and Pax_lon_t[Paxname] ~= 0 then

					if Paxname == "Pax1" then
						-- UNLOADING HERE WILL ALLOW TO RANDOMLY pop ANOTHER CHARACTER
						if Passenger_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[0]) end
						if Paxref0 ~= nil then     XPLM.XPLMUnloadObject(Paxref0)  end
						Passenger_instance[0] = nil
						Paxref0 = nil
						passenger1_show_only_once = true
						--Passenger_step_t[Paxname] = -99 -- removed from the loop

						-- RELOAD WITH ANOTHER HUMAN CHARACTER
						math.randomseed(os.time())
						randomView = math.random()
						if randomView > 0.5 and randomView <= 0.8 then Passenger1Object = Prefilled_Passenger3Object
						elseif randomView > 0.8 and randomView <= 0.9 then Passenger1Object = Prefilled_Passenger2Object
						elseif randomView > 0.9 then Passenger1Object = Prefilled_Passenger5Object
						else Passenger1Object = Prefilled_Passenger1Object end

						if Passenger_instance[0] == nil and passenger1_show_only_once and terminate_passenger_action == false then
							if military == 1 or military_default == 1 then Passenger1Object = Prefilled_PassengerMilObject end
							--~ print("[Ground Equipment " .. version_text_SGES .. "] Randomly loading another Passenger1Object (with corrections to avoid 'too many callbacks' issue)")
							XPLM.XPLMLoadObjectAsync(Passenger1Object,
								function(inObject, inRefcon)
									Passenger_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									Paxref0 = inObject
								end,
								inRefcon )
							passenger1_show_only_once = false
						end
					end


					if Paxname == "Pax5" then
						-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
						if Passenger_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[4]) end
						if Paxref4 ~= nil then     XPLM.XPLMUnloadObject(Paxref4)  end
						Passenger_instance[4] = nil
						Paxref4 = nil
						passenger5_show_only_once = true
						--Passenger_step_t[Paxname] = -99 -- removed from the loop
						-- RELOAD WITH ANOTHER HUMAN CHARACTER
						math.randomseed(os.time())
						randomView = math.random()
						if randomView > 0.2 and randomView <= 0.8 then Passenger5Object = Prefilled_Passenger6Object
						else Passenger5Object = Prefilled_Passenger4Object end
						if Passenger_instance[4] == nil and passenger5_show_only_once then
							if military == 1 or military_default == 1 then Passenger5Object = Prefilled_PassengerMilObject end
							--~ print("[Ground Equipment " .. version_text_SGES .. "] UNLOADING TO RANDOMLY POP UP ANOTHER CHARACTER: Passenger5Object swap")
							XPLM.XPLMLoadObjectAsync(Passenger5Object,
								function(inObject, inRefcon)
									Passenger_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									Paxref4 = inObject
								end,
								inRefcon )
							passenger5_show_only_once = false
						end
					end


					if Paxname == "Pax11" then
						-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
						if Passenger_instance[10] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[10]) end
						if Paxref10 ~= nil then     XPLM.XPLMUnloadObject(Paxref10)  end
						Passenger_instance[10] = nil
						Paxref10 = nil
						passenger11_show_only_once = true
						--Passenger_step_t[Paxname] = -99 -- removed from the loop
						-- RELOAD WITH ANOTHER HUMAN CHARACTER
						math.randomseed(os.time())
						randomView = math.random()
						if randomView < 0.4 then Passenger11Object = Prefilled_Passenger4Object
						else Passenger11Object = Prefilled_Passenger7Object end
						if Passenger_instance[10] == nil and passenger11_show_only_once then
							--~ print("[Ground Equipment " .. version_text_SGES .. "] UNLOADING TO RANDOMLY POP UP ANOTHER CHARACTER: Passenger11Object swap")
							XPLM.XPLMLoadObjectAsync(Passenger11Object,
								function(inObject, inRefcon)
									Passenger_instance[10] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									Paxref10 = inObject
								end,
								inRefcon )
							passenger11_show_only_once = false
						end
					end
					if Paxname == "Pax12" then
						-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
						if Passenger_instance[11] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[11]) end
						if Paxref11 ~= nil then     XPLM.XPLMUnloadObject(Paxref11)  end
						Passenger_instance[11] = nil
						Paxref11 = nil
						passenger12_show_only_once = true
						--Passenger_step_t[Paxname] = -99 -- removed from the loop
						-- RELOAD WITH ANOTHER HUMAN CHARACTER
						math.randomseed(os.time())
						randomView = math.random()
						if randomView < 0.5 then Passenger12Object = Prefilled_Passenger4Object
						else Passenger12Object = Prefilled_Passenger7Object end
						if Passenger_instance[11] == nil and passenger12_show_only_once then

							--~ print("[Ground Equipment " .. version_text_SGES .. "] UNLOADING TO RANDOMLY POP UP ANOTHER CHARACTER: Passenger12Object swap")
							XPLM.XPLMLoadObjectAsync(Passenger12Object,
								function(inObject, inRefcon)
									Passenger_instance[11] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
									Paxref11 = inObject
								end,
								inRefcon )
							passenger12_show_only_once = false
						end
					end
				--~ elseif Passenger_step_t[Paxname] ~= -99 then
					--~ Passenger_step_t[Paxname] = 5
				end
				-- preparation to swap pax objects finished

				-- ACTION TO LOOP? MAIN ACTION IS HERE :


				if terminate_passenger_action == true and Passenger_step_t[Paxname] ~= -99 then Passenger_step_t[Paxname] = 5
					-- arm the kill of passengers in progressive terminating
				elseif show_Pax then Passenger_step_t[Paxname] = -1
					-- make the pax reinitiate the boarding or depoarding pass
				elseif Passenger_step_t[Paxname] ~= -99 then Passenger_step_t[Paxname] = 5 end
				--~ print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  vanishing (has boarded) #code : " .. Passenger_step_t[Paxname])



			end

			------------------------------------------------------------------------
			-- applying modifiers defined above to actual next target location
			if Passenger_step_t[Paxname] ~= nil and (Passenger_step_t[Paxname] >= 1 or (SGES_mirror == 1 and Passenger_step_t[Paxname] >= 0)) and Passenger_step_t[Paxname] <= 4 then
				--if Passenger_step_t[Paxname] == 0 then drapeau = "grd2stairs" end

				-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}

				----------- sub modifiers 11TH JANUARY 2025 --------------------

				----------- sub modifiers 11TH JANUARY 2025 --------------------


				Pax_lat_t[Paxname] = Pax_lat_t[Paxname] - progressions_t[Paxname][1]
				Pax_lon_t[Paxname] = Pax_lon_t[Paxname] - progressions_t[Paxname][2]
				Pax_hgt_t[Paxname] = Pax_hgt_t[Paxname] + progressions_t[Paxname][3]

				Pax_hdg_t[Paxname] = progressions_t[Paxname][4] --sges_gs_plane_head[0] - 90
				--print(Pax_hgt_t[Paxname])

				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )

				objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,Pax_hgt_t[Paxname],Pax_hdg_t[Paxname],nil,"stairs")
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
			end
		end
		--------------------------------------------------------------------------------------------------------------------------------



		-- DEBOARDING

				--~ StairFinalY = StairFinalY_stairIII
				--~ StairFinalH = StairFinalH_stairIII
				--~ StairFinalX = StairFinalX_stairIII
				--~ StairHigherPartX = StairHigherPartX_stairIII
				--~ InitialPaxHeight = InitialPaxHeight_stairIII

				--~ StairFinalY = StairFinalY_stairIV
				--~ StairFinalH = StairFinalH_stairIV
				--~ StairFinalX = StairFinalX_stairIV
				--~ StairHigherPartX = StairHigherPartX_stairIV
				--~ InitialPaxHeight = InitialPaxHeight_stairIV


				-- CALL :	draw_all_Passengers_deboarding(StairHigherPartX,StairFinalY,BusFinalX,BusFinalY,Passenger_instance[0],"Pax1")

		--------------------------------------------------------------------------------------------------------------------------------

		function draw_all_Passengers_deboarding(Depart_lat,Depart_lon,FinalX,FinalY,Instance,Paxname)
			--------------------------------------------------------------------
			--safeguard :
			if Depart_lat == nil then
				Depart_lat =  targetDoorX + targetDoorX_alternate
				--if Passenger_step_t[Paxname] == -1 then print("I don't have the departing coordinates in function draw_all_Passengers_deboarding.") end
			end
			if Depart_lon == nil then Depart_lon = -targetDoorZ + targetDoorZ_alternate end
			finalPax_lat 				= FinalX - 1 --is the bus in reality, I've inversed the entries above
			finalPax_lon_t[Paxname] 	= FinalY

			if groundh == nil then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )
				groundh = probe_y (sges_gs_plane_x[0], 0,sges_gs_plane_z[0])
			end
			local first_stairs_height = 3.4 -- this is the 3D height of the first part of the stairs, linked to the base, on ground.
			local depart_lat_correcting_term = 7.3
			--------------------------------------------------------------------

			-- define initial positions
			if Passenger_step_t[Paxname] == -1 then
				--if Paxname ~= nil then print("[Ground Equipment " .. version_text_SGES .. "] starting Passenger " .. Paxname) end
				-- taking note of the current elapsed time to sequence the passengers departures
				Pax_chrono_t[Paxname] = SGES_total_flight_time_sec

				-- -------------- Pax_lat_t[Paxname] definition ----------------
				--~ if Depart_lat ~= targetDoorX then Pax_lat_t[Paxname] =  		Depart_lat - 7 end
				--~ -- note : applying Depart_lat - 7 is doing that on some occasion the characters are poping up very far outside the fuselage.
				--~ -- therefore I excluded the case when a correction Depart_lat =  targetDoorX was made

				--~ So, some notes for myself as I follow the debugging process : the passengers has got the status 4 (passenger is walking to the bus) correctly. At the end of 4, the passenger normally detects the final destination (has reached the bus). As a consequence, the switch to status -1 (passenger is at the aircraft door ready to disembark) is correct. However, regeneration back from status 4 to status -1 happens on wrong coordinates if the passenger is emanating from the front door, if dual deboarding is activated, if early in the FlyWithLua session run, if dual board happened first. The height goes back correctly to door height, but not the latitude and longitude.
				if SGES_stairs_type ~= "Boarding_without_stairs" then
					if BoardStairsXPJ2 then
						Pax_lat_t[Paxname] =  StairHigherPartX_stairIV - depart_lat_correcting_term-- was missing until 4th of november, 2023 - reported by an user on the forum
					else
						Pax_lat_t[Paxname] =  StairHigherPartX_stairIII - depart_lat_correcting_term -- was missing until 4th of november, 2023 - reported by an user on the forum
					end
				end
				-- in case of dual deboarding, those values above may be rewritten depending on pax attribution : aft or forward door to disembark
				--~ if Paxname == "Pax1" then print("Pax_lat_t[Pax1] (begin) " .. Pax_lat_t[Paxname]) end
				-- -------------- Pax_lon_t[Paxname] definition ----------------
				Pax_lon_t[Paxname] = Depart_lon - 0.1 --  to be able to change the deboarding door


				-- -------------- Pax_lon/lat_t[Paxname] special definitions ---
				-- if center of aircraft is start of the passengers (I have seen that happen !), reatribute to something else less bad :
				if Pax_lon_t[Paxname] == 0 then
					Pax_lon_t[Paxname] =  		-targetDoorZ + targetDoorZ_alternate
					--~ print("Don't have the longitudinal departure of passengers. Recenter by default to targetDoorX + 3 and -targetDoorZ.")
				end
				if Pax_lat_t[Paxname] == 0 then
					Pax_lat_t[Paxname] =  		 targetDoorX + 3 + targetDoorX_alternate
					print("[Ground Equipment " .. version_text_SGES .. "] draw_all_Passengers_deboarding() set automatically the lateral attachement of the passengers to targetDoorX + 3.")
				end
				-- don't change the value 8 anywhere :
				if SGES_stairs_type == "New_Small" 					then Pax_lat_t[Paxname] = StairFinalX_stairIII -8 end -- SMALL STAIRS DEPARTURE
				if SGES_stairs_type == "Boarding_without_stairs" 	then Pax_lat_t[Paxname] = StairFinalX_stairIII -8 end -- NO STAIRS DEPARTURE -- then adjusted in game by the user
				if BoardStairsXPJ2 then
					if SGES_stairs_type == "New_Small"					then Pax_lat_t[Paxname] = StairFinalX_stairIV -8 end -- SMALL STAIRS DEPARTURE
					if SGES_stairs_type == "Boarding_without_stairs" 	then Pax_lat_t[Paxname] = StairFinalX_stairIV -8 end -- NO STAIRS DEPARTURE -- then adjusted in game by the user
				end

				-- -------------- Pax_hgt_t[Paxname] definition ----------------
				if BoardStairsXPJ2 then
					-- when deboarding from aft door, set that to aft door altitude as accurately as possible
					if targetDoorAltitude2 ~= nil then
						Pax_hgt_t[Paxname] = targetDoorAltitude2 + 5.525
					else
						Pax_hgt_t[Paxname] = 		probe_door() + 5.5 -- better than nothing
					end
				else
					-- when deboarding from the front door, set initial height
					Pax_hgt_t[Paxname] = 		probe_door() + 5.525 + targetDoorH_alternate -- better than nothing
					--~ Pax_lat_t[Paxname] = Pax_lat_t[Paxname] + targetDoorX_alternate
					--~ Pax_lon_t[Paxname] = Pax_lon_t[Paxname] + targetDoorZ_alternate
				end
				if SGES_stairs_type == "Boarding_without_stairs" then --hugly patch
					Pax_hgt_t[Paxname] = Pax_hgt_t[Paxname] - 0.75 --descend directly out of the acft door, as if on the ladder
				end



				-- dual deboarding section ---------------------------------------
				--if DualBoard send some pax to the back exit (rewritting departure coordinates)

				if DualBoard then
					math.randomseed(os.time())
					randomView = math.random()
					if randomView > 0.5 then
						-- if aft stair is available, as well as aft stairs, attribute this pax to forward exit
						if BoardStairsXPJ2 and StairHigherPartX_stairIII ~= nil then -- then redirect to stair Mk III
							Pax_lat_t[Paxname] =  		StairHigherPartX_stairIII - depart_lat_correcting_term
							Pax_lon_t[Paxname] =  		StairFinalY_stairIII
							Pax_hgt_t[Paxname] = 		probe_door() + 5.525 -- better than nothing
						-- if aft stair is available, as well as aft stairs, attribute this pax to aft exit
						elseif BoardStairsXPJ and StairHigherPartX_stairIV ~= nil then -- then redirect to stair Mk IV
							Pax_lat_t[Paxname] =  		StairHigherPartX_stairIV - depart_lat_correcting_term
							Pax_lon_t[Paxname] =  		StairFinalY_stairIV
							if targetDoorAltitude2 ~= nil then
								Pax_hgt_t[Paxname] = targetDoorAltitude2 + 5.525
							else
								Pax_hgt_t[Paxname] = 		probe_door() + 5.5 -- better than nothing
							end
						end
					end
				end
				----------------------------------------------------------------

				--~ if Paxname == "Pax1" then print("Pax_lat_t[Pax1] (ends) " .. Pax_lat_t[Paxname]) end

				last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname]
				last_recorded_pax_height_t[Paxname] = Pax_hgt_t[Paxname]

				progressions_t[Paxname] = {0.006, 0.0075, 0.00, sges_gs_plane_head[0] - 90} -- will be rewritten soon in the following timeline

				-- exiting to next step, either 2 for small staires or 0 for big stairs
				-- sequencing every n seconds
				if Passenger_step_t.Pax1 == -1 and Pax_chrono_t.Pax1 ~= 0 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax1 = 0 else Passenger_step_t.Pax1 = 2 end end
				if Passenger_step_t.Pax2 == -1 and Pax_chrono_t.Pax2 >= Pax_chrono_t.Pax1 + 15 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax2 = 0 else Passenger_step_t.Pax2 = 2 end end
				if Passenger_step_t.Pax3 == -1 and Pax_chrono_t.Pax3 >= Pax_chrono_t.Pax2 + 6 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax3 = 0 else Passenger_step_t.Pax3 = 2 end end
				if Passenger_step_t.Pax4 == -1 and Pax_chrono_t.Pax4 >= Pax_chrono_t.Pax3 + 5 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax4 = 0 else Passenger_step_t.Pax4 = 2 end end
				if Passenger_step_t.Pax5 == -1 and Pax_chrono_t.Pax5 >= Pax_chrono_t.Pax4 + 6 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax5 = 0 else Passenger_step_t.Pax5 = 2 end end
				if Passenger_step_t.Pax6 == -1 and Pax_chrono_t.Pax6 >= Pax_chrono_t.Pax5 + 5 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax6 = 0 else Passenger_step_t.Pax6 = 2 end end
				-- added 12-2022 :
				if Passenger_step_t.Pax7 == -1 and Pax_chrono_t.Pax7 >= Pax_chrono_t.Pax6 + 6 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax7 = 0 else Passenger_step_t.Pax7 = 2 end if debugging_passengers then print("pax7 deb") end end
				if Passenger_step_t.Pax8 == -1 and Pax_chrono_t.Pax8 >= Pax_chrono_t.Pax7 + 4 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax8 = 0 else Passenger_step_t.Pax8 = 2 end if debugging_passengers then print("pax8 deb") end end
				if Passenger_step_t.Pax9 == -1 and Pax_chrono_t.Pax9 >= Pax_chrono_t.Pax8 + 5 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax9 = 0 else Passenger_step_t.Pax9 = 2 end if debugging_passengers then print("pax9 deb") end end
				if Passenger_step_t.Pax10 == -1 and Pax_chrono_t.Pax10 >= Pax_chrono_t.Pax9 + 6 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax10 = 0 else Passenger_step_t.Pax10 = 2 end if debugging_passengers then print("pax10 deb") end end
				if Passenger_step_t.Pax11 == -1 and Pax_chrono_t.Pax11 >= Pax_chrono_t.Pax10 + 4 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax11 = 0 else Passenger_step_t.Pax11 = 2 end if debugging_passengers then print("pax11 deb") end  end
				if Passenger_step_t.Pax12 == -1 and Pax_chrono_t.Pax12 >= Pax_chrono_t.Pax11 + 4 then  if SGES_stairs_type == "New_Normal" then Passenger_step_t.Pax12 = 0 else Passenger_step_t.Pax12 = 2 end if debugging_passengers then print("pax12 deb") end  initial_pax_start = false end

				-- when deboarding into a small aircraft or an helicopter, limit immediatly the number of passengers
				if math.abs(BeltLoaderFwdPosition) < 4.5 or (IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) or PLANE_ICAO == "GLF650ER" or PLANE_ICAO == "E19L" then
					terminate_passenger_action = true
					if Paxname ~= nil and (tonumber(Paxname:sub(-1)) % 2 == 0 or tonumber(Paxname:sub(-1)) > 8 or Paxname == "Pax11") and Passenger_step_t[Paxname] >= 0 then
						Passenger_step_t[Paxname] = 5
						print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  removed due to aircraft seating capacity (deboarding).")
					end -- kill one pax over 2
				end
				--------------------------------------------------------
				-- user choice to reduce even more the number of passengers
				if  reduce_even_more_the_number_of_passengers and Passenger_instance[2] ~= nil and Paxname ~= nil and Paxname == "Pax3" and Passenger_step_t[Paxname] >= 0 then
					Passenger_step_t[Paxname] = 5
					print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  also removed due to seating capacity (deboarding) (user option).")
				end
				if  reduce_even_more_the_number_of_passengers and Passenger_instance[6] ~= nil and Paxname ~= nil and Paxname == "Pax7" and Passenger_step_t[Paxname] >= 0 then
					Passenger_step_t[Paxname] = 5
					print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  also removed due to seating capacity (deboarding) (user option).")
				end
				--------------------------------------------------------
			end

			if Passenger_step_t[Paxname] == 4  then -- passenger is walking to the bus
				progressions_t[Paxname] = {X_speed_part_1, -0.001, 0, sges_gs_plane_head[0] - 90}

					-- try to catch the bus longitudinally :
					if Pax_lon_t[Paxname] > finalPax_lon_t[Paxname] + 0.1 then -- if the passenger is forward of the bus, make it walk to the rear
						progressions_t[Paxname][2] = -0.006
						progressions_t[Paxname][4] = sges_gs_plane_head[0] - 90 - 20
				--~ elseif show_Cones and Pax_lon_t[Paxname] < 5 and  Pax_lon_t[Paxname] < finalPax_lon_t[Paxname] - 3 and Pax_lat_t[Paxname] < finalPax_lat - 1 then  -- if the passenger comes from the rear and is far, make it walk forward more
						--~ progressions_t[Paxname][1] = 0.0005
						--~ progressions_t[Paxname][2] =  0.025
						--~ progressions_t[Paxname][4] = sges_gs_plane_head[0] - 90 + 85
						--~ print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. " extending walking leg to the front.")
				elseif Pax_lon_t[Paxname] < 5 and Pax_lon_t[Paxname] < finalPax_lon_t[Paxname] - 0.1 then  -- if the passenger comes from the rear, make it walk forward more
						progressions_t[Paxname][1] = X_speed_part_1/2
						progressions_t[Paxname][2] =  0.015
						progressions_t[Paxname][4] = sges_gs_plane_head[0] - 90 + 80

						if loncone ~= nil and loncone ~= 0 and BeltLoaderFwdPosition >= 17 and (Pax_lon_t[Paxname] > loncone or Pax_lat_t[Paxname] > latcone + 1)  then
							progressions_t[Paxname][1] = 0
							progressions_t[Paxname][2] =  0.02
							progressions_t[Paxname][4] = sges_gs_plane_head[0]
						end

				elseif Pax_lon_t[Paxname] < finalPax_lon_t[Paxname] - 0.1 then
						-- - 0.1 then -- if the passenger is rearward of the bus, make it walk to the front
						progressions_t[Paxname][2] =  0.008
						progressions_t[Paxname][4] = sges_gs_plane_head[0] - 90 + 30
				else   	progressions_t[Paxname][2] =  0					-- if the passenger is forward of the bus, make it walk sideways only. Cancel longitudinal romming.
						progressions_t[Paxname][4] = sges_gs_plane_head[0] - 90 end


				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  walking at " .. Pax_lat_t[Paxname] .. " for " .. finalPax_lat) end
				--if Paxname == "Pax1" then  print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  walking at " .. Pax_lat_t[Paxname] .. " for " .. finalPax_lat) end
				-- VANISH the passenger :
				-- when the latitude is the bus one  Pax_lat_t[Paxname] > finalPax_lat
				-- but also not too far from the bus longitude  when coming from teh rear as a pax  Pax_lon_t[Paxname] > finalPax_lon_t[Paxname] - 5
				if (BeltLoaderFwdPosition >= 10 and Pax_lat_t[Paxname] > finalPax_lat and Pax_lon_t[Paxname] > finalPax_lon_t[Paxname] - 4) or (BeltLoaderFwdPosition < 17 and Pax_lat_t[Paxname] > finalPax_lat and Pax_lon_t[Paxname] > finalPax_lon_t[Paxname] - 7) then -- height is nice enough, hard to do better
					if show_Pax then
						-- regenerate the passenger back to the aircraft door and ready to disembark (cycling)
						Passenger_step_t[Paxname] = -1 -- rechecked on 2023-11-03
						--~ So, some notes for myself as I follow the debugging process : the passengers has got the status 4 (passenger is walking to the bus) correctly. At the end of 4, the passenger normally detects the final destination (has reached the bus). As a consequence, the switch to status -1 (passenger is at the aircraft door ready to disembark) is correct. However, regeneration back from status 4 to status -1 happens on wrong coordinates if the passenger is emanating from the front door, if dual deboarding is activated, if early in the FlyWithLua session run, if dual board happened first. The height goes back correctly to door height, but not the latitude and longitude.
						last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname]
						last_recorded_pax_height_t[Paxname] = Pax_hgt_t[Paxname]
					elseif Passenger_step_t[Paxname] ~= -99 then
						-- kill the passenger is passengers are no more desired
						Passenger_step_t[Paxname] = 5
					end

					if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  vanishing (has deboarded) " .. finalPax_lon_t[Paxname]  - Pax_lon_t[Paxname]) end
					--~ if Paxname == "Pax5" then print("[Ground Equipment " .. version_text_SGES .. "] Passenger  " .. Paxname .. "  vanishing (has deboarded) " .. finalPax_lon_t[Paxname]  - Pax_lon_t[Paxname]) end

					-- specificities

					if not terminate_passenger_action then
						if Paxname == "Pax5" then
							-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
							if Passenger_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[4]) end
							if Paxref4 ~= nil then     XPLM.XPLMUnloadObject(Paxref4)  end
							Passenger_instance[4] = nil
							Paxref4 = nil
							passenger5_show_only_once = true
							-- RELOAD WITH ANOTHER HUMAN CHARACTER
							math.randomseed(os.time())
							randomView = math.random()
							if randomView > 0.3 and randomView <= 0.6 then Passenger5Object = Prefilled_Passenger6Object
							else Passenger5Object = Prefilled_Passenger4Object end
							if Passenger_instance[4] == nil and passenger5_show_only_once then
								if military == 1 or military_default == 1 then Passenger5Object = Prefilled_PassengerMilObject end
								--~ print("[Ground Equipment " .. version_text_SGES .. "] DEBOARDING : XPLM.XPLMLoadObjectAsync: Passenger5Object " .. Passenger5Object)
								XPLM.XPLMLoadObjectAsync(Passenger5Object,
									function(inObject, inRefcon)
										Passenger_instance[4] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										Paxref4 = inObject
									end,
									inRefcon )
								passenger5_show_only_once = false
							end
						end
						if Paxname == "Pax11" then
							-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
							if Passenger_instance[10] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[10]) end
							if Paxref10 ~= nil then     XPLM.XPLMUnloadObject(Paxref10)  end
							Passenger_instance[10] = nil
							Paxref10 = nil
							passenger11_show_only_once = true
							-- RELOAD WITH ANOTHER HUMAN CHARACTER
							math.randomseed(os.time())
							randomView = math.random()
							if randomView < 0.4 then Passenger11Object = Prefilled_Passenger4Object
							else Passenger11Object = Prefilled_Passenger13Object end
							if Passenger_instance[10] == nil and passenger11_show_only_once then
								if military == 1 or military_default == 1  then Passenger11Object = Prefilled_PassengerMilObject end
								XPLM.XPLMLoadObjectAsync(Passenger11Object,
									function(inObject, inRefcon)
										Passenger_instance[10] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										Paxref10 = inObject
									end,
									inRefcon )
								passenger11_show_only_once = false
							end
						end
						if Paxname == "Pax12" then
							-- UNLOADING HERE WILL ALLOW TO RANDOMLY POP ANOTHER CHARACTER
							if Passenger_instance[11] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[11]) end
							if Paxref11 ~= nil then     XPLM.XPLMUnloadObject(Paxref11)  end
							Passenger_instance[11] = nil
							Paxref11 = nil
							passenger12_show_only_once = true
							-- RELOAD WITH ANOTHER HUMAN CHARACTER
							math.randomseed(os.time())
							randomView = math.random()
							if randomView < 0.6 then Passenger12Object = Prefilled_Passenger14Object
							else Passenger12Object = Prefilled_Passenger5Object end
							if Passenger_instance[11] == nil and passenger12_show_only_once then
								if military == 1 or military_default == 1  then Passenger12Object = Prefilled_PassengerMilObject end
								XPLM.XPLMLoadObjectAsync(Passenger12Object,
									function(inObject, inRefcon)
										Passenger_instance[11] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
										Paxref11 = inObject
									end,
									inRefcon )
								passenger12_show_only_once = false
							end
						end
					else
						Passenger_step_t[Paxname] = 5 -- confirm that (not usefull but you know !)
					end
				end


			elseif Passenger_step_t[Paxname] == 3.6 then -- try to avoid engine number 1, smooth the turn on apron, only for rear deboarding pax
				if Pax_lat_t[Paxname] >= last_recorded_pax_latitude_t[Paxname] + 10 or show_Cones == false then
					Passenger_step_t[Paxname] = 4
					if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  skips the engine avoidance.") end
				end
				if ( Pax_lat_t[Paxname] < latcone - 1 ) and Pax_lon_t[Paxname] < finalPax_lon_t[Paxname] then
					progressions_t[Paxname] = {X_speed_part_1, 0.015/2, 0, sges_gs_plane_head[0] - 90 + 35}
					if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  trying to avoid the engine.") end
				else   	Passenger_step_t[Paxname] = 4
						if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  has avoided the engine.") end
				end -- fwd pax don't walk that part

			elseif Passenger_step_t[Paxname] == 3.5 then -- first part on the ground after the stairs, smooth the turn on apron
				progressions_t[Paxname] = {0.01/1.3, 0, 0, sges_gs_plane_head[0] - 90}
				if Pax_lat_t[Paxname] >= last_recorded_pax_latitude_t[Paxname] + 1 then
					Passenger_step_t[Paxname] = 3.6
				end
				--print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  is walking the turn at altitude " .. Pax_hgt_t[Paxname] .. " for ground " .. groundh)


			elseif Passenger_step_t[Paxname] == 3 then -- first part of the stairs
				progressions_t[Paxname] = {X_speed_part_1/1.3, -0.00005, H_speed_part_1/1.3, sges_gs_plane_head[0] - 90}
				if groundh == nil then
					coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )
					groundh = probe_y (sges_gs_plane_x[0], 0,sges_gs_plane_z[0])
				end
				if Pax_hgt_t[Paxname] <= groundh	then Passenger_step_t[Paxname] = 3.5  last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname] end
				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  descending last steps  at altitude " .. Pax_hgt_t[Paxname] .. " for ground " .. groundh) end




			elseif Passenger_step_t[Paxname] == 2  then -- first platform of the stairs
				progressions_t[Paxname] = {0.01/1.3, 0, 0, sges_gs_plane_head[0] - 90}

				Pax_hgt_t[Paxname] = last_recorded_pax_height_t[Paxname]
				if Pax_lat_t[Paxname] > last_recorded_pax_latitude_t[Paxname] + 1.1 and SGES_stairs_type == "New_Normal" then Passenger_step_t[Paxname] = 3 end
				if Pax_lat_t[Paxname] > last_recorded_pax_latitude_t[Paxname] + 4.25 and SGES_stairs_type == "New_Small" then Passenger_step_t[Paxname] = 3 end

				if SGES_stairs_type == "Boarding_without_stairs" then --hugly patch
					Passenger_step_t[Paxname] = 3 --descend directly out of the acft door, as if on the ladder
				end

				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  on 1st plateform : " .. Pax_lat_t[Paxname] .. " and " .. Pax_lon_t[Paxname] .. " at altitude " .. Pax_hgt_t[Paxname]) end




			elseif Passenger_step_t[Paxname] == 1 then -- second part of the stairs descending to the first platform
				progressions_t[Paxname] = {X_speed_part_2, 0.0001, H_speed_part_2, sges_gs_plane_head[0] - 90}
				if Pax_hgt_t[Paxname] <= groundh + first_stairs_height + 0.1	then Passenger_step_t[Paxname] = 2  last_recorded_pax_height_t[Paxname] = Pax_hgt_t[Paxname] last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname] end
				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  descending first steps  at altitude " .. Pax_hgt_t[Paxname] .. " for platform at " .. groundh + first_stairs_height) end




			elseif Passenger_step_t[Paxname] == 0.5 and checkpoint_chrono_t[Paxname] >= checkpoint_chrono_t[PreviousPax] + 4 then -- wait for first part of the stairs if too near from previous pax
					Passenger_step_t[Paxname] = 1
					PreviousPax = Paxname
					if debugging_passengers then print("Passed for descent. Calling PreviousPax " .. PreviousPax .. ".") end
					checkpoint_chrono_t[PreviousPax] = sges_current_time

			elseif Passenger_step_t[Paxname] == 0.5 then
					checkpoint_chrono_t[Paxname] = sges_current_time --update that to watch it
					if debugging_passengers then print("Not Passed for " .. Paxname .. ".") end



			elseif Passenger_step_t[Paxname] == 0 then -- second platform of the stairs if is a big stair

				if groundh == nil then
					coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )
					groundh = probe_y (sges_gs_plane_x[0], 0,sges_gs_plane_z[0])
				end
				-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}
				progressions_t[Paxname] = {0.01, 0, 0.00, sges_gs_plane_head[0] - 90}
				if Pax_lat_t[Paxname] > last_recorded_pax_latitude_t[Paxname] + 4.3 then


					progressions_t[Paxname] = {0, 0, 0, sges_gs_plane_head[0] - 90}
					checkpoint_chrono_t[Paxname] = sges_current_time
					if debugging_passengers then print("paxname " .. Paxname .. " / PreviousPax " .. PreviousPax) end
					-- init
					if PreviousPax == "none" or IsPassengerPlane == 0 then Passenger_step_t[Paxname] = 1 PreviousPax = Paxname else Passenger_step_t[Paxname] = 0.5 end

				end -- here I have a parameter: the geometry of the platform

				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  on 2nd plateform : " .. Pax_lat_t[Paxname] .. " and " .. Pax_lon_t[Paxname] .. " at altitude " .. Pax_hgt_t[Paxname]) end


			elseif Passenger_step_t[Paxname] == 5 then -- KILL
				Passenger_step_t[Paxname] = -99 -- removed from the loop

				--if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger deboarding  " .. Paxname .. "  in final position " .. Pax_lat_t[Paxname] .. " and " .. Pax_lon_t[Paxname]) end

				if debugging_passengers then print("[Ground Equipment " .. version_text_SGES .. "] Passenger " .. Paxname .. " status is " .. Passenger_step_t[Paxname]) end
				if Paxname == "Pax1" then print("[Ground Equipment " .. version_text_SGES .. "] Passenger " .. Paxname .. " status is " .. Passenger_step_t[Paxname]) end

				-- when ALL passengers have been prevented to be recycled (because the user asked to end the boarding)
				-- then remove the passengers for good and the bus :
				--~ if terminate_passeng

				if Passenger_step_t["Pax1"] == -99 then pax1_disapp = true end
				if Passenger_step_t["Pax2"] == -99 then pax2_disapp = true end
				if Passenger_step_t["Pax3"] == -99 then pax3_disapp = true end
				if Passenger_step_t["Pax4"] == -99 then pax4_disapp = true end
				if Passenger_step_t["Pax5"] == -99 then pax5_disapp = true end
				if Passenger_step_t["Pax6"] == -99 then pax6_disapp = true end
				if Passenger_step_t["Pax7"] == -99 then pax7_disapp = true end
				if Passenger_step_t["Pax8"] == -99 then pax8_disapp = true end
				if Passenger_step_t["Pax9"] == -99 then pax9_disapp = true end
				if Passenger_step_t["Pax10"] == -99 then pax10_disapp = true end
				if Passenger_step_t["Pax11"] == -99 then pax11_disapp = true end
				if Passenger_step_t["Pax12"] == -99 then pax12_disapp = true end

				if terminate_passenger_action and show_Pax and pax1_disapp and pax2_disapp and pax3_disapp and pax4_disapp and pax5_disapp and pax6_disapp  and pax7_disapp and pax8_disapp and pax9_disapp  and pax10_disapp and pax11_disapp and pax12_disapp
				then
					show_Pax = false
					show_Bus = false
					boarding_from_the_terminal = false
					Pax_chg = true
					Bus_chg = true
					terminate_passenger_action = false -- reset
					print("[Ground Equipment " .. version_text_SGES .. "] All deboarding passengers have progressively disappeared.")
				end

				if Instance ~= nil and terminate_passenger_action then       XPLM.XPLMDestroyInstance(Instance) end
			end


			------------------------------------------------------------------------
			-- applying modifiers defined above to actual next target location
			if Passenger_step_t[Paxname] ~= nil and Passenger_step_t[Paxname] >= 0 and Passenger_step_t[Paxname] <= 4 then
				-- progressions[pax#]_t = {lateral_progression, longitudinal_progression, height_progression, hdg_component}

				----------- sub modifiers 11TH JANUARY 2025 --------------------
				-- when the ground equipments are mirrored, the passengers are deboarding form the starboard side, instead of the regulat pattern to the laft hand side.
				-- DEBOARDING WAY
				if SGES_mirror == 1 then
					progressions_t[Paxname][1] = -1* progressions_t[Paxname][1]
					progressions_t[Paxname][4] = progressions_t[Paxname][4] + 180
					-- in this specific case, the point where to recycle each passenger is not reached. So we need a specific trigger when the situaiton is mirrored.
					if Pax_lat_t[Paxname] <= FinalX then	-- a simple trigger in this case, just based on the lateral distance to the bus or terminal.
						-- regenerate the passenger back to the aircraft door and ready to disembark (cycling)
						Passenger_step_t[Paxname] = -1 -- rechecked on 2023-11-03
						last_recorded_pax_latitude_t[Paxname] = Pax_lat_t[Paxname]
						last_recorded_pax_height_t[Paxname] = Pax_hgt_t[Paxname]
						if terminate_passenger_action then
							Passenger_step_t[Paxname] = 5 --kill the pax
						end
					end
				end
				----------- sub modifiers 11TH JANUARY 2025 --------------------

				Pax_lat_t[Paxname] = Pax_lat_t[Paxname] + progressions_t[Paxname][1]
				Pax_lon_t[Paxname] = Pax_lon_t[Paxname] + progressions_t[Paxname][2]
				Pax_hgt_t[Paxname] = Pax_hgt_t[Paxname] - progressions_t[Paxname][3]

				Pax_hdg_t[Paxname] = progressions_t[Paxname][4] - 180



				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], Pax_lat_t[Paxname], Pax_lon_t[Paxname], sges_gs_plane_head[0] )
				local flag = "stairs"
				if Passenger_step_t[Paxname] >= 3.5 and Passenger_step_t[Paxname] <= 4 then flag = "grd2stairs" end
				objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,Pax_hgt_t[Paxname],Pax_hdg_t[Paxname],nil,flag)
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
			end
		end
	end

	function draw_Ponev()
			float_value[0] = 0
			float_addr = float_value

			--~ if SGES_Vertical_position_gear_strut_extended[0]
			--~ if SGES_strut_compression[0]
			-- POSITIVE LEFT < x > NEGATIVE RIGHT
			-- POSITIVE FWD < z > NEGATIVE AFT
			local x_corr = -8
			local z_corr = 6
			coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], x_corr, gear1Z + 0.01*gear1Z + z_corr, sges_gs_plane_head[0] )
			objpos_value[0].pitch =     0.1 * math.abs(sges_EngineState[0])
			objpos_value[0].roll =     -0.05 * math.abs(sges_EngineState[0])
			objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,sges_gs_plane_head[0]+90)
			-- patch for carrier pushback
			--~ if SGES_Vertical_position_gear_strut_extended[0]
			--~ if SGES_strut_compression[0]
			objpos_value[0].y = sges_gs_plane_y[0] + ref_to_default  + SGES_Vertical_position_gear_strut_extended[0]  - SGES_strut_compression[0] -- all is in meters
			acft_y,wetness = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
			if wetness == 0 then -- dynamic carrier deck personel only over water
				objpos_value[0].y = acft_y
			end
			objpos_addr = objpos_value
			if sges_gs_gnd_spd[0] < 20 then  -- remove it when the cat shot is taken
				XPLM.XPLMInstanceSetPosition(Ponev_instance[0], objpos_addr, float_addr)    -- PONEV
			else
				show_Ponev = false
				Ponev_chg = true
			end
			if wetness == 0 and IsXPlane12 then -- dynamic carrier deck personel only over water -- does not work sadly on XP11
				Ponev_chg = false
			end
			objpos_value[0].pitch =     0
			objpos_value[0].roll =     0
	end


	-------------------------- ARRESTOR SYSTEM DRAW
	local selected = 5
	IsCable = false
	local ArrestorIsBasedOnILS = false
	local ArrestorDeltaPositioning = -280
	function draw_ArrestorSystem()
		--if (sges_gs_gnd_spd[0] > 1 and sges_gs_gnd_spd[0] < 120) or (sges_gs_gnd_spd[0] < -1 and sges_gs_gnd_spd[0] > -20) then
		float_value[0] = 0
		float_addr = float_value
		objpos_value[0].y = acft_y
		--~ if ArrestorIsBasedOnILS then
			--~ ArrestorSystemAirportILS() -- NAVDATA ILS
		--~ else
			--~ ArrestorSystemAirportRWY()  -- APT.DAT GLOBAL APT
		--~ end

		--~ if ArrestorIsBasedOnILS then
			--~ targetX,targetHeight,targetZ = latlon_to_local(ArrestorX,ArrestorZ,outHeight)
		--~ else
			targetX = ArrestorX
			targetZ = ArrestorZ
			targetHeight = outHeight
		--~ end

		alti_y = probe_y (targetX, targetHeight, targetZ)
		local retained_Heading = Runway[selected].outHeading -- expect that to be modified
		local old_Heading = retained_Heading
		local ILS_validity = false
		--~ if SGESMagVar < 0 then
			--~ retained_Heading = Runway[selected].outHeading - SGESMagVar
		--~ else
			--~ retained_Heading = Runway[selected].outHeading + SGESMagVar
		--~ end
		objpos_value[0].heading = retained_Heading
		ILS_Heading_support,ILSname,ILS_validity = Support_Arrestor_Heading_With_ILS(targetX,targetZ,retained_Heading) -- give it ILS help
		-- was filtered for angular tolerance and coordinates tolerance. Return ILS_validity = false if filtered out
		if ILS_Heading_support ~= nil and ILS_validity then
			objpos_value[0].heading = ILS_Heading_support
			Runway[selected].outHeading = ILS_Heading_support -- that line is critical to calculate deported coordinaates
			retained_Heading = ILS_Heading_support -- that line is critical to calculate deported coordinaates
			print("[Ground Equipment " .. version_text_SGES .. "] Arrestor object heading was " .. old_Heading .. "° and is updated to " .. ILS_Heading_support .. "° thanks to the nearby ILS " .. ILSname ..".")-- .. ")    #i=" .. selected)
		else
			print("[Ground Equipment " .. version_text_SGES .. "] Arrestor object heading : " .. Runway[selected].outHeading .. "°") -- .. " (without ILS to help) #i=" .. selected)
		end


		if IsCable == true and ArrestorIsBasedOnILS then
			ArrestorDeltaPositioning = -831
		elseif IsCable == true and ILS_Heading_support ~= nil and ILS_validity then
			ArrestorDeltaPositioning = -600
		elseif IsCable == true  then
			ArrestorDeltaPositioning = -300 -- reduced accuracy on runway angle, so lets put it not too far from the runway end
		else
			if ArrestorIsBasedOnILS then -- deprecated
				ArrestorDeltaPositioning = -280 -- when ILS
			else
				ArrestorDeltaPositioning = 15 -- when RWY
			end
		end


		coordinates_of_adjusted_ref_rampservice(targetX, targetZ, 0, ArrestorDeltaPositioning, retained_Heading ) -- move the Arrestor System in front along the runway
		objpos_value[0].x = g_shifted_x
		objpos_value[0].z = g_shifted_z
		acft_y,wetness = probe_y (g_shifted_x, alti_y, g_shifted_z) -- probe wetness at the obtained position


		if wetness == 1 then -- move the net barrier forward by iterations until on dry terrain if starting point is wet terrain
			local j=0
			for j=1,5 do -- abandon quickly if dry terrain cannot be easily found
				ArrestorDeltaPositioning = ArrestorDeltaPositioning - 30 -- move the barrier by this factor at each iteration
				coordinates_of_adjusted_ref_rampservice(targetX, targetZ, 0, ArrestorDeltaPositioning, retained_Heading ) -- move the Arrestor System in front along the runway
				objpos_value[0].x = g_shifted_x
				objpos_value[0].z = g_shifted_z
				acft_y,wetness = probe_y (g_shifted_x, alti_y, g_shifted_z)
				if wetness == 0 then break end
			end
		end

		float_value[0] = 0
		float_addr = float_value
		if IsCable == true then
			objpos_value[0].y = acft_y + 0.08
		else
			objpos_value[0].y = acft_y
		end
		objpos_value[0].pitch = 0
		--~ if IsCable == true then
			--~ objpos_value[0].y = acft_y - 4.45
			--~ objpos_value[0].pitch = 40
		--~ end
		objpos_addr = objpos_value
		-- send to trapping mecanism
		StopZoneX = g_shifted_x
		StopZoneZ = g_shifted_z
		StopzoneY = acft_y

		if wetness == 0 then
			XPLM.XPLMInstanceSetPosition(ArrestorSystem_instance[0], objpos_addr, float_addr)
		end
		ArrestorSystem_chg = false   -- comment that to draw dynamicallyif required
		ArrestorSystemCable_chg = false
	end
	--------------------------------------------------------------------------------

	function unload_probe()

		if proberef ~= nil then
			XPLM.XPLMDestroyProbe(proberef)
		end
		proberef = nil

	end

	function common_unload(name,Instance,reference)

				-- https://forums.x-plane.org/index.php?/forums/topic/268535-xplmdestroyinstance-in-a-function/
				--"I'm almost sure that when common_unload sets 'Instance' and 'reference' to nil, the change is local
				-- and not "seen" by the code that calls the function. This might cause the problem if the code
				-- that creates new instances checks that the values are nil before proceeding.

				-- therefore I return them !

				-- regular unload actions :
				if Instance ~= nil then       XPLM.XPLMDestroyInstance(Instance) end -- that does not work.
				if reference ~= nil then     XPLM.XPLMUnloadObject(reference)  end
				Instance = nil
				reference = nil
				SGES_switch = false --(GPU_chg, and so son)

				-- show only once and peculiar SGES cases
				if name == "FUEL" then fuel_show_only_once = true end
				if name == "Hydrant" then fuel_show_only_once = true end
				if name == "Bus" then bus_show_only_once = true end
				if name == "Cart" then cart_show_only_once = true end
				if name == "FM" then Mashaller_available = false FM_show_only_once = true end
				if name == "PB" then PB_show_only_once = true end
				if name == "Ponev" then Ponev_show_only_once = true end
				if name == "StopSign" then StopSign_show_only_once = true end
				if name == "TargetMarker" then TargetMarker_show_only_once = true end
				if name == "TargetSelfPushback" then TargetSelfPushback_show_only_once = true end
				if name == "CockpitLight" then 	  CockpitLight_show_only_once = true end
				if name == "Baggage" and show_Cart then 	  baggage_show_only_once = true end -- anti crash too many callback
				if name == "Baggage1" and show_Cart  then 	  baggage1_show_only_once = true end -- anti crash too many callback
				if name == "Baggage2" and show_Cart  then 	  baggage2_show_only_once = true end -- anti crash too many callback
				if name == "Baggage3" and show_Cart  then 	  baggage3_show_only_once = true end -- anti crash too many callback
				if name == "Baggage4" and show_Cart  then 	  baggage4_show_only_once = true end -- anti crash too many callback
				if name == "Baggage5" and show_Bus and show_ULDLoader then 	  baggage5_show_only_once = true end -- anti crash too many callback

				if name == "StairsXPJ2" then 	  StairsXPJ2_0_show_only_once = true end
				if name == "StairsXPJ21" then 	  StairsXPJ2_1_show_only_once = true end
				if name == "StairsXPJ" then 	  StairsXPJ_0_show_only_once = true end
				if name == "StairsXPJ1" then 	  StairsXPJ_1_show_only_once = true end
				if name == "StairsXPJ3" then 	  StairsXPJ3_0_show_only_once = true end
				if name == "StairsXPJ31" then 	  StairsXPJ3_1_show_only_once = true end
				if name == "Deice" then 	  Deice_0_show_only_once = true end
				if name == "Deice1" then 	  Deice_1_show_only_once = true end
				if name == "Deice2" then 	  Deice_2_show_only_once = true end
				if name == "People1" then 	  People1_show_only_once = true end
				if name == "People2" then 	  People2_show_only_once = true end
				if name == "People3" then 	  People3_show_only_once = true end
				if name == "People4" then 	  People4_show_only_once = true end
				if name == "ULDLoader" then 	  ULDLoader_show_only_once = true end
				if name == "PRM" then 	  PRM_0_show_only_once = true end
				if name == "PRMHighPart" then 	  PRM_1_show_only_once = true end
				if name == "Stairs" then 	  stairs_LR_show_only_once = true end
				if name == "RearBeltLoader" then 	  RearBeltLoader_show_only_once = true end
				if name == "BeltLoader" then 	  BeltLoader_show_only_once = true end
				if name == "Cleaning" then 	  Cleaning_show_only_once = true end
				if name == "CateringHighPart" then 	  Catering_show_only_once = true end
				if name == "ASU" then 	  ASU_show_only_once = true end
				if name == "Forklift" then 	  Forklift_show_only_once = true end

				--~ -- aircraft actions
				if XPLMFindDataRef("thranda/electrical/ExtPwrGPUAvailable") ~= nil then -- check is Thranda plugin is loaded and running
					if string.match(name,"GPU") and string.match(AIRCRAFT_PATH,"146") then set("thranda/electrical/ExtPwrGPUAvailable",0) end
					if string.match(name,"Chock") and  string.match(AIRCRAFT_PATH,"146") then set("thranda/views/chocks",0) end

				end
				if string.match(name,"GPU") and  AIRCRAFT_FILENAME== "Bell412.acf" then command_once("412/buttons/GPU_off") end
				if string.match(name,"GPU")  and AIRCRAFT_FILENAME == "CH47.acf" then set("ch47/other/GPU",0)  end

				if string.match(name,"GPU")  and AIRCRAFT_FILENAME == "AW109SP.acf" then set("sim/cockpit/electrical/gpu_on",0) end

				if string.match(name,"GPU")  and  (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko")   and XPLMFindDataRef("XCrafts/other/GPU") ~= nil then set("XCrafts/other/GPU",1) end -- one, for OFF

			   return SGES_switch,Instance,reference
	end



	function unload_Passengers()
		if UseXplaneDefaultObject == false then -- do not arm passengers
		-- print("[Ground Equipment " .. version_text_SGES .. "] unload_Passengers")



				-- revert boarding and deboarding for next cycling
				if Passenger_instance[0] ~= nil or Passenger_instance[1] ~= nil or Passenger_instance[2] ~= nil or Passenger_instance[3] ~= nil or Passenger_instance[4] ~= nil or Passenger_instance[5] ~= nil or Passenger_instance[6] ~= nil then
					-- reverse when only pax are already in use, otherwise that reverse falsely at first start of the lfight session and that is a bad behavior !
					walking_direction_changed_armed = true
					print("[Ground Equipment " .. version_text_SGES .. "] walking_direction_changed_armed = true. Pax were " .. walking_direction .. ". We will reverse that next time.")
				else
					--print("[Ground Equipment " .. version_text_SGES .. "] First operation of the day ! Pax are expected to be " .. walking_direction .. ".")
				end


				if Passenger_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[0]) end
				if Paxref0 ~= nil then     XPLM.XPLMUnloadObject(Paxref0)  end
				Passenger_instance[0] = nil
				Paxref0 = nil
				passenger1_show_only_once = true

				if Passenger_instance[1] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[1]) end
				if Paxref1 ~= nil then     XPLM.XPLMUnloadObject(Paxref1)  end
				Passenger_instance[1] = nil
				Paxref1 = nil
				passenger2_show_only_once = true

				if Passenger_instance[2] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[2]) end
				if Paxref2 ~= nil then     XPLM.XPLMUnloadObject(Paxref2)  end
				Passenger_instance[2] = nil
				Paxref2 = nil
				passenger3_show_only_once = true

				if Passenger_instance[3] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[3]) end
				if Paxref3 ~= nil then     XPLM.XPLMUnloadObject(Paxref3)  end
				Passenger_instance[3] = nil
				Paxref3 = nil
				passenger4_show_only_once = true


				if Passenger_instance[4] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[4]) end
				if Paxref4 ~= nil then     XPLM.XPLMUnloadObject(Paxref4)  end
				Passenger_instance[4] = nil
				Paxref4 = nil
				passenger5_show_only_once = true


				if Passenger_instance[5] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[5]) end
				if Paxref5 ~= nil then     XPLM.XPLMUnloadObject(Paxref5)  end
				Passenger_instance[5] = nil
				Paxref5 = nil
				passenger6_show_only_once = true

				--Pax_chg = false

				-- added 12-2022

				if Passenger_instance[6] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[6]) end
				if Paxref6 ~= nil then     XPLM.XPLMUnloadObject(Paxref6)  end
				Passenger_instance[6] = nil
				Paxref6 = nil
				passenger7_show_only_once = true

				if Passenger_instance[7] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[7]) end
				if Paxref7 ~= nil then     XPLM.XPLMUnloadObject(Paxref7)  end
				Passenger_instance[7] = nil
				Paxref7 = nil
				passenger8_show_only_once = true

				if Passenger_instance[8] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[8]) end
				if Paxref8 ~= nil then     XPLM.XPLMUnloadObject(Paxref8)  end
				Passenger_instance[8] = nil
				Paxref8 = nil
				passenger9_show_only_once = true

				if Passenger_instance[9] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[9]) end
				if Paxref9 ~= nil then     XPLM.XPLMUnloadObject(Paxref9)  end
				Passenger_instance[9] = nil
				Paxref9 = nil
				passenger10_show_only_once = true


				if Passenger_instance[10] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[10]) end
				if Paxref10 ~= nil then     XPLM.XPLMUnloadObject(Paxref10)  end
				Passenger_instance[10] = nil
				Paxref10 = nil
				passenger11_show_only_once = true


				if Passenger_instance[11] ~= nil then       XPLM.XPLMDestroyInstance(Passenger_instance[11]) end
				if Paxref11 ~= nil then     XPLM.XPLMUnloadObject(Paxref11)  end
				Passenger_instance[11] = nil
				Paxref11 = nil
				passenger12_show_only_once = true

				Pax_chg = false

				initial_pax_start = true
				Pax_lat_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				Pax_lon_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				Pax_hgt_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				Pax_hdg_t = {Pax1=sges_gs_plane_head[0] - 90,Pax2=sges_gs_plane_head[0] - 90,Pax3=sges_gs_plane_head[0] - 90,Pax4=sges_gs_plane_head[0] - 90,Pax5=sges_gs_plane_head[0] - 90,Pax6=sges_gs_plane_head[0] - 90,Pax7=sges_gs_plane_head[0] - 90,Pax8=sges_gs_plane_head[0] - 90,Pax9=sges_gs_plane_head[0] - 90,Pax10=sges_gs_plane_head[0] - 90,Pax11=sges_gs_plane_head[0] - 90,Pax12=sges_gs_plane_head[0] - 90}
				finalPax_lon_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				last_recorded_pax_height_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				last_recorded_pax_latitude_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				Passenger_step_t = {Pax1=-1,Pax2=-1,Pax3=-1,Pax4=-1,Pax5=-1,Pax6=-1,Pax7=-1,Pax8=-1,Pax9=-1,Pax10=-1,Pax11=-1,Pax12=-1}
				Pax_chrono_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
				checkpoint_chrono_t = {Pax1=0,Pax2=0,Pax3=0,Pax4=0,Pax5=0,Pax6=0,Pax7=0,Pax8=0,Pax9=0,Pax10=0,Pax11=0,Pax12=0}
		end
	end



	 ------------------------ DYNAMICS ---------------------------------------
	if not IsXPlane12 then
		function ActiveDeice() -- not for XP12 where we use the native XP12 slider instead
			-- for "Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand" minutes deicing fluid is efficient
			if sges_current_time <= starting_deice_time + Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand then
				set("sim/flightmodel/failures/frm_ice",0)
				set("sim/flightmodel/failures/frm_ice2",0)
				set("sim/flightmodel/failures/pitot_ice",0)
				set("sim/flightmodel/failures/pitot_ice2",0)
				set("sim/flightmodel/failures/prop_ice",0)
				set("sim/flightmodel/failures/stat_ice",0)
				set("sim/flightmodel/failures/stat_ice2",0)
				set("sim/flightmodel/failures/inlet_ice",0)
				set("sim/flightmodel/failures/window_ice",0)
				set("sim/flightmodel/failures/aoa_ice",0)
				set("sim/flightmodel/failures/aoa_ice2",0)
				if IsXPlane12 then
					set_array("sim/flightmodel/failures/window_ice_per_window",0,0)
					set_array("sim/flightmodel/failures/window_ice_per_window",1,0)
					set_array("sim/flightmodel/failures/window_ice_per_window",2,0)
					set_array("sim/flightmodel/failures/window_ice_per_window",3,0)

					set_array("sim/flightmodel/failures/inlet_ice_per_engine",0,0)
					set_array("sim/flightmodel/failures/inlet_ice_per_engine",1,0)
					set_array("sim/flightmodel/failures/inlet_ice_per_engine",2,0)
					set_array("sim/flightmodel/failures/inlet_ice_per_engine",3,0)

					set_array("sim/flightmodel/failures/prop_ice_per_engine",0,0)
					set_array("sim/flightmodel/failures/prop_ice_per_engine",1,0)
					set_array("sim/flightmodel/failures/prop_ice_per_engine",2,0)
					set_array("sim/flightmodel/failures/prop_ice_per_engine",3,0)

					set("sim/flightmodel/failures/stat_ice_stby",0)
					set("sim/flightmodel/failures/pitot_ice_stby",0)
					set("sim/flightmodel/failures/tail_ice",0)
					set("sim/flightmodel/failures/tail_ice2",0)
					--print("anti ice effect")
				end
			 end
			 -- maintain active while service shown :
			 if show_Deice then
				starting_deice_time = math.floor(os.clock())
			 end
		end
		do_sometimes("ActiveDeice()")
	end

	function ActiveDeice_shot() -- one time deicing execution
			set("sim/flightmodel/failures/frm_ice",0)
			set("sim/flightmodel/failures/frm_ice2",0)
			set("sim/flightmodel/failures/pitot_ice",0)
			set("sim/flightmodel/failures/pitot_ice2",0)
			set("sim/flightmodel/failures/prop_ice",0)
			set("sim/flightmodel/failures/stat_ice",0)
			set("sim/flightmodel/failures/stat_ice2",0)
			set("sim/flightmodel/failures/inlet_ice",0)
			set("sim/flightmodel/failures/window_ice",0)
			set("sim/flightmodel/failures/aoa_ice",0)
			set("sim/flightmodel/failures/aoa_ice2",0)
			if IsXPlane12 then
				set_array("sim/flightmodel/failures/window_ice_per_window",0,0)
				set_array("sim/flightmodel/failures/window_ice_per_window",1,0)
				set_array("sim/flightmodel/failures/window_ice_per_window",2,0)
				set_array("sim/flightmodel/failures/window_ice_per_window",3,0)

				set_array("sim/flightmodel/failures/inlet_ice_per_engine",0,0)
				set_array("sim/flightmodel/failures/inlet_ice_per_engine",1,0)
				set_array("sim/flightmodel/failures/inlet_ice_per_engine",2,0)
				set_array("sim/flightmodel/failures/inlet_ice_per_engine",3,0)

				set_array("sim/flightmodel/failures/prop_ice_per_engine",0,0)
				set_array("sim/flightmodel/failures/prop_ice_per_engine",1,0)
				set_array("sim/flightmodel/failures/prop_ice_per_engine",2,0)
				set_array("sim/flightmodel/failures/prop_ice_per_engine",3,0)

				set("sim/flightmodel/failures/stat_ice_stby",0)
				set("sim/flightmodel/failures/pitot_ice_stby",0)
				set("sim/flightmodel/failures/tail_ice",0)
				set("sim/flightmodel/failures/tail_ice2",0)
			end
			print("-> -> Immediate de-ice commanded.")
	end


	-- ////////////////////////////////// GROUND SERVICE /////////////////////////////////////////////////////////



	-- ////////////////////////////////// LOCATE NEAREST STAND POSITION ///////////////////////////////////////////
	local retained_parking_position_lon = 0
	local retained_parking_position_lat = 0

	function create_parking_position_cache()

			print("[Ground Equipment " .. version_text_SGES .. "]  CREATING SGES CACHE FOR MARSHALLER (Global Sc)")
			XPLMSpeakString("Collecting global scenery parking positions. Please wait.")
			-- to ease calculation time on the go
			io.input(global_apt_dat)
			io.output(SGES_parking_position_cache)
			local count = 1
			while true do
				local apt_content = io.read()
				if apt_content == nil then break end -- when the file is finished
				parking_position_description = string.match(apt_content, "%d%d%d%d%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+%a%-*%s*%a*") -- added %-* on 4th Nov 2023 to account for negative angles
				-- WE ONLY RETAIN LINES CONCERNING PARKING POSITIONS
				-- ALSO we remove lines for ground vehicles positions
				--string.match(parking_position_description,"[fuel|crew|baggage|food|pushback|gpu|misc].*")
				if parking_position_description ~= nil then
					if string.find(parking_position_description,"fuel") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"crew") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"food") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"pushback") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"gpu") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"baggage") ~= nil then parking_position_description = nil
					elseif string.find(parking_position_description,"misc") ~= nil then parking_position_description = nil
					elseif parking_position_description ~= nil then io.write(parking_position_description .. "\n") end
				end
				count = count + 1
			end



			if includeCustomParkingPositions == nil then dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_options.lua") end -- read user settings and preferences

			if includeCustomParkingPositions then
				print("[Ground Equipment " .. version_text_SGES .. "]  CREATING SGES CACHE FOR MARSHALLER (Custom Sc.)")
				XPLMSpeakString("Collecting custom scenery positions...")
				local custom_scenery = SCRIPT_DIRECTORY .. "../../../../Custom Scenery/scenery_packs.ini"
				-- we will append custom sceneries
				io.input(custom_scenery)
				io.output(SGES_parking_position_cache_CST)
				local count = 1
				while true do

					local custom_scenery_folder = io.read()
					if custom_scenery_folder == nil then break end
					-- each lines give the folder name to explore
					local custom_scenery_folder_name = string.match(custom_scenery_folder,"SCENERY_PACK%s(.*)")
					if custom_scenery_folder_name == nil then custom_scenery_folder_name ="null/" end
					if string.find(custom_scenery_folder_name,"SCENERY_PACK_DISABLED") then custom_scenery_folder_name = "null/" end
					if string.find(custom_scenery_folder_name,"Global Airports") then custom_scenery_folder_name = "null/" end
					-- we already counted the global airports and that will CTD the sim
					--print("custom_scenery_folder " .. custom_scenery_folder_name)
					reduced_custom_scenery_folder_name = custom_scenery_folder_name
					custom_scenery_folder_name = SCRIPT_DIRECTORY .. "../../../../" .. custom_scenery_folder_name .. "Earth nav data/apt.dat"
					if string.find(custom_scenery_folder_name,"Custom Scenery") then
						--print(custom_scenery_folder)
						--io.input(custom_scenery_folder_name)

						local open = io.open
						local function read_file(path)
							--print("we opên custom_scenery_folder_name : " .. custom_scenery_folder_name)
							local file = open(path, "rb") -- r read mode and b binary mode
							if not file then print("[Ground Equipment " .. version_text_SGES .. "] No apt.dat data from " .. reduced_custom_scenery_folder_name .. "(nothing to collect !)") return nil
							else
								print("[Ground Equipment " .. version_text_SGES .. "] Collecting data from " .. reduced_custom_scenery_folder_name)
							end
							--print("Found it")
							local content = file:read "*a" -- *a or *all reads the whole file
							file:close()
							return content
						end
						local custom_scenery_content = read_file(custom_scenery_folder_name)
						if custom_scenery_content ~= nil then io.write(custom_scenery_content .. "\n") end
						-- simply concatenate, after all, it won't be a monster file, it just a few sceneries compared to global apts
					end
				end
				-- remove bad lines
				io.input(SGES_parking_position_cache_CST) -- temporary cache
				io.output(SGES_parking_position_cache_CS) -- filtered result
				local badlinesfiler = 1
				while true do
					local apt_content = io.read()
					if apt_content == nil then break end -- when the file is finished


					--1300  32.69252015 -016.77783318 136.7 gate jets|turboprops|props|fighters A2
					--1300  32.69201412 -016.77796027 -22.4 tie_down props|helos GA ramp

					parking_position_description = string.match(apt_content, "%d%d%d%d%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+%a%-*%s*%a*") -- added %-* on 4th Nov23 to account for negative angles
					-- WE ONLY RETAIN LINES CONCERNING PARKING POSITIONS
					-- ALSO we remove lines for ground vehicles positions
					--string.match(parking_position_description,"[fuel|crew|baggage|food|pushback|gpu|misc].*")
					if parking_position_description ~= nil then
						if string.find(parking_position_description,"fuel") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"crew") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"food") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"pushback") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"gpu") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"baggage") ~= nil then parking_position_description = nil
						elseif string.find(parking_position_description,"misc") ~= nil then parking_position_description = nil
						elseif parking_position_description ~= nil then io.write(parking_position_description .. "\n") end
					end
					badlinesfiler = badlinesfiler + 1
				end

				local open = io.open
				local function read_fileCS(path)
					local file = open(path, "rb") -- r read mode and b binary mode
					if not file then return nil end
					local content = file:read "*a" -- *a or *all reads the whole file
					file:close()
					return content
				end
				local custom_scenery_content = read_fileCS(SGES_parking_position_cache_CS)
				local open = io.open
				local function append_to_file(path,content)
					local file = open(path, "a+") -- append
					if not file then return nil end
					file:write(content)
					file:close()
				end
				append_to_file(SGES_parking_position_cache,custom_scenery_content)
			else
				print("[Ground Equipment " .. version_text_SGES .. "]  Custom Scenery was EXCLUDED from cache collection, because the human user asked for it.")
			end
		    XPLMSpeakString("Done. ")

		   create_runway_position_cache()

	end
	--~ add_macro("--- Simple Ground Equip. (SGES) --- " .. os.date("%x"),"")
	--~ add_macro("SGES : refresh scenery cache (the normal procedure)", "includeCustomParkingPositions = true create_parking_position_cache() ")
	--~ add_macro("SGES : (refresh cache without the custom sceneries)", "includeCustomParkingPositions = false create_parking_position_cache()")




	function automatic_parking_search() -- - removed for performance on 4th of Nov 2023
		-- when the follow me is activated by the user
		-- and
		-- speed is reduced
		-- beacon is on (or equivalent)
		-- nose light is turned OFF as parking entry procedure (or equivalent)

		--print("[Ground Equipment " .. version_text_SGES .. "] Marshaller : Automatic stand ...")
		-- we launch one short cycle of automatic parking stand search
		if show_FM and sges_gs_gnd_spd[0] < 2 and sges_gs_gnd_spd[0] >= 0.25 and math.abs(sges_nosewheel[0]) < 2 and SGES_parkbrake < 1 and stand_found_flag == 0 and show_TargetMarker == false and automatic_marshaller_already_requested_once == false then
			print("[Ground Equipment " .. version_text_SGES .. "] Marshaller : Automatic stand search (only once per follow-me session) ...")
			automatic_marshaller_requested = true
			automatic_marshaller_already_requested_once = true
			automatic_marshaller_capture_position_threshold = 0.0005
			stand_found_flag = get_airport_intell_Core("automatic")
		end
	end

	retained_parkings_position_lat = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}
	retained_parkings_position_lon = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}
	retained_parkings_position_heading = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}
	retained_parkings_position_local_Z = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}
	retained_parkings_position_local_X = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}
	retained_parkings_position_local_distance = {Park1=0,Park2=0,Park3=0,Park4=0,Park5=0,Park6=0,Park7=0,Park8=0,Park9=0,Park10=0,Park11=0,Park12=0}

	function get_airport_intell_Core(mode)

		if mode == nil then mode = "standard" end
		if custom_scenery_only then io.input(SGES_parking_position_cache_CS) else io.input(SGES_parking_position_cache) end
		local count = 1
		while true do

			local apt_content = io.read()
			if apt_content == nil then break end -- when the file is finished
																	--~ 1300  32.69252015 -016.77783318 136.7 gate
																	--~ 1300  32.69201412 -016.77796027 -22.4 tie
			local parking_position_lat = string.match(apt_content, "%d+%s+(%-*%d+%.%d+)%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+") -- %-* added 4-11-2023
			local parking_position_lon = string.match(apt_content, "%d+%s+%-*%d+%.%d+%s+(%-*%d+%.%d+)%s+%-*%d+%.%d+%s+") -- %-* added 4-11-2023
			local parking_position_heading = string.match(apt_content, "%d+%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+(%-*%d+%.%d+)%s+") -- %-* added 4-11-2023
			--print(parking_position_lat)
			--print(parking_position_lon)

			if parking_position_lat == nil then parking_position_lat = 0 end
			if parking_position_lon == nil then parking_position_lon = 0 end
			if parking_position_heading == nil then parking_position_heading = sges_gs_plane_head[0] end

			parking_position_lat = tonumber(parking_position_lat)
			parking_position_lon = tonumber(parking_position_lon)
			parking_position_heading = tonumber(parking_position_heading)
			if parking_position_heading < 0 then parking_position_heading = parking_position_heading + 360 end -- some ramp headings are negative in x-plane


			difference_lat = math.abs(parking_position_lat - LATITUDE)
			difference_lon = math.abs(parking_position_lon - LONGITUDE)
			--print(parking_position_lat)
			--print(parking_position_lon)
			--print(difference_lat)
			--print(difference_lon)

			local capture_threshold_lat = automatic_marshaller_capture_position_threshold * 4
			local capture_threshold_lon = automatic_marshaller_capture_position_threshold * 4

			--~ if (sges_gs_plane_head[0] > 45 and sges_gs_plane_head[0] <= 135) or (sges_gs_plane_head[0] > 225 and sges_gs_plane_head[0] <= 315) then
				--~ capture_threshold_lat = automatic_marshaller_capture_position_threshold/1.3 -- value changed 4th nov 2023  instead of 1.5
				--~ capture_threshold_lon = automatic_marshaller_capture_position_threshold * 1.8 -- value changed 4th nov 2023  instead of 1.6

			 --~ else
				--~ capture_threshold_lat = automatic_marshaller_capture_position_threshold*1.8 -- value changed 4th nov 2023  instead of 1.6
				 --~ capture_threshold_lon = automatic_marshaller_capture_position_threshold /1.3 -- value changed 4th nov 2023  instead of 1.5
			 --~ end
			 -- value changed 4th nov 2023 : find ramp sport nearer than before of the user, and we can increase the search by one more pass to counterbalance that

			--------------------------------------------------------
			-- that value must be augmented for long airliners where the nose wheel is far from the value of LATITUDE and LONGITUDE, centered on the aircraft center, far behind. --IAS24
			-- otherwise, even the narrow (or "on top") search option, cannot find a stand while we ARE extactly on stand. --IAS24
			if BeltLoaderFwdPosition >= 14 then  --IAS24
				-- increase the threshold for less sensitivity and more tolerance
					 capture_threshold_lat = capture_threshold_lat * 2.1 --IAS24
					 capture_threshold_lon = capture_threshold_lat * 2.1 --IAS24 calibrated with A346 at Saipan PGSN
			else
				 capture_threshold_lat = capture_threshold_lat * 1.4 --IAS24
				 capture_threshold_lon = capture_threshold_lat * 1.4 --IAS24 calibrated with A346 at Saipan PGSN
			end --IAS24
			--------------------------------------------------------

			if difference_lat < capture_threshold_lat and difference_lon < capture_threshold_lon then
			-- collect several parking positions around, instead of just the first one found as before.
				if stand_found_flag < 12 then
					stand_found_flag = stand_found_flag + 1
					Parkname = "Park" .. stand_found_flag
					retained_parkings_position_lon[Parkname] = parking_position_lon
					retained_parkings_position_lat[Parkname] = parking_position_lat
					retained_parkings_position_heading[Parkname] = parking_position_heading
					--print("custom : " .. Parkname .. "retained_parking_position_lat " .. parking_position_lat .. "   retained_parking_position_lon " .. parking_position_lon)
				else
					break
				end
			end

			count = count + 1
		end

		if stand_found_flag >= 1 then print(stand_found_flag .. " stand(s) found in custom scenery. ")
			park = "Park1" -- tempo value
		else --if failed to find in custom scenery, go to global scenery


			-- find where is our aircraft in relation to available parking positions
			-- the user can filter for custom sceneries only
			io.input(SGES_parking_position_cache)
			local count = 1
			while true do

				local apt_content = io.read()
				if apt_content == nil then break end -- when the file is finished
																	--~ 1300  32.69252015 -016.77783318 136.7 gate
																	--~ 1300  32.69201412 -016.77796027 -22.4 tie
				local parking_position_lat = string.match(apt_content, "%d+%s+(%-*%d+%.%d+)%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+") -- %-* added 4-11-2023
				local parking_position_lon = string.match(apt_content, "%d+%s+%-*%d+%.%d+%s+(%-*%d+%.%d+)%s+%-*%d+%.%d+%s+") -- %-* added 4-11-2023
				local parking_position_heading = string.match(apt_content, "%d+%s+%-*%d+%.%d+%s+%-*%d+%.%d+%s+(%-*%d+%.%d+)%s+") -- %-* added 4-11-2023
				--print(parking_position_lat)
				--print(parking_position_lon)

				if parking_position_lat == nil then parking_position_lat = 0 end
				if parking_position_lon == nil then parking_position_lon = 0 end
				if parking_position_heading == nil then parking_position_heading = sges_gs_plane_head[0] end

				parking_position_lat = tonumber(parking_position_lat)
				parking_position_lon = tonumber(parking_position_lon)
				parking_position_heading = tonumber(parking_position_heading)
				if parking_position_heading < 0 then parking_position_heading = parking_position_heading + 360 end -- some ramp headings are negative in x-plane


				difference_lat = math.abs(parking_position_lat - LATITUDE)
				difference_lon = math.abs(parking_position_lon - LONGITUDE)
				--print(parking_position_lat)
				--print(parking_position_lon)
				--print(difference_lat)
				--print(difference_lon)

				local capture_threshold_lat = automatic_marshaller_capture_position_threshold
				local capture_threshold_lon = automatic_marshaller_capture_position_threshold

				if (sges_gs_plane_head[0] > 45 and sges_gs_plane_head[0] <= 135) or (sges_gs_plane_head[0] > 225 and sges_gs_plane_head[0] <= 315) then
					capture_threshold_lat = automatic_marshaller_capture_position_threshold/1.5
					capture_threshold_lon = automatic_marshaller_capture_position_threshold * 1.6

				 else
					capture_threshold_lat = automatic_marshaller_capture_position_threshold*1.6
					 capture_threshold_lon = automatic_marshaller_capture_position_threshold /1.5
				 end


				--------------------------------------------------------
				-- that value must be augmented for long airliners where the nose wheel is far from the value of LATITUDE and LONGITUDE, centered on the aircraft center, far behind. --IAS24
				-- otherwise, even the narrow (or "on top") search option, cannot find a stand while we ARE extactly on stand. --IAS24
				if BeltLoaderFwdPosition >= 14 then  --IAS24
					-- increase the threshold for less sensitivity and more tolerance
					 capture_threshold_lat = capture_threshold_lat * 2.1 --IAS24
					 capture_threshold_lon = capture_threshold_lat * 2.1 --IAS24 calibrated with A346 at Saipan PGSN
				else
					 capture_threshold_lat = capture_threshold_lat * 1.4 --IAS24
					 capture_threshold_lon = capture_threshold_lat * 1.4 --IAS24 calibrated with A346 at Saipan PGSN
				end --IAS24
				--------------------------------------------------------


				if difference_lat < capture_threshold_lat and difference_lon < capture_threshold_lon then
					-- collect several parking positions around, instead of just the first one found as before.
					if (automatic_marshaller_capture_position_threshold < 0.0021 and stand_found_flag < 6) or (automatic_marshaller_capture_position_threshold == 0.0021 and stand_found_flag < 10) or (automatic_marshaller_capture_position_threshold > 0.0021 and stand_found_flag < 12) then -- limit the number of value we store in our table of selectionned parking positions --IAS24
						-- when the search if "FAR" that is, 0.0021 exactly, we allow more stands to be retrieved.
						-- The FIXED value 0.0021 is a flag.
						stand_found_flag = stand_found_flag + 1
						Parkname = "Park" .. stand_found_flag
						print("global : " .. Parkname .. " retained_parking_position_lat " .. parking_position_lat .. "   retained_parking_position_lon " .. parking_position_lon)
						--print("global : " .. Parkname .. " _________________aircraft_lat " .. LATITUDE .. "               _________________aircraft_lon " .. LONGITUDE) --IAS24
						retained_parkings_position_lon[Parkname] = parking_position_lon
						retained_parkings_position_lat[Parkname] = parking_position_lat
						retained_parkings_position_heading[Parkname] = parking_position_heading
					else
						break
					end
				end
				count = count + 1
			end

			if stand_found_flag >= 1 then
				stand_searched_flag = false
				print(stand_found_flag .. " stand(s) found in GLOBAL scenery instead of custom scenery. ")
				park = "Park1" -- tempo value
			else
				if mode == "standard" then
					print("No suitable stand found.")
					stand_searched_flag = true
				end
			end
		end



		if stand_found_flag >= 1 then

			-- the filtered parkinkg must be stored into TargerMarker
			ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")
			local inAltitudeW = 0
			local outX = ffi.new("double[1]")
			local outY = ffi.new("double[1]")
			local outZ = ffi.new("double[1]")

			local previous_value = 999999999999999999999999999999999999999999999

			coordinates_of_nose_gear(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, gear1Z, sges_gs_plane_head[0] )
			-- find nose gear position.
			 NosePositionX = nose_x
			 NosePositionZ = nose_z

			for i,value in pairs(retained_parkings_position_lon) do
				if tonumber(string.sub(i,5)) <= stand_found_flag then
					XPLM.XPLMWorldToLocal(retained_parkings_position_lat[i], retained_parkings_position_lon[i], inAltitudeW, outX, outY, outZ )
					retained_parkings_position_local_Z[i] = outZ[0]
					retained_parkings_position_local_X[i] = outX[0]
					--~ print(i .. " ... " .. outZ[0])
					_,retained_parkings_position_local_distance[i] = Marshaller_stand_distance_calc(NosePositionX, NosePositionZ, outX[0], outZ[0], sges_gs_plane_head[0], 0)
					--~ print(i .. " ... " .. retained_parkings_position_local_distance[i])
					-- preselect the nearest stand :
					if retained_parkings_position_local_distance[i] < previous_value then
						park = i
						p = tonumber(string.sub(park,5)) + 1
						if stand_found_flag == 1 then p = 1 end
					end
					previous_value = retained_parkings_position_local_distance[i]
				end
			end

			show_TargetMarker = true
			TargetMarker_chg = true
			show_StopSign = false
			StopSign_chg = true

			-- if is a big airport, switch VDGS ON automatically -- IAS24

			if not show_VDGS then -- spare the calculation if VDGS already selected  -- IAS24
				show_VDGS,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,sges_airport_ID)
				--~ show_VDGS = true -- for XPJavelin dev only
				----------------------------------------------------------------
				-- if VDGS selected, we need to load the module immediatly :
				if show_VDGS and not VDGS_module_loaded then
					print("[Ground Equipment " .. version_text_SGES .. "] Will read VDGS sub-script because it is requested by SGES detecting a major airport.")
					dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_VDGS.lua") -- threat module
				end
				----------------------------------------------------------------
				VDGS_chg = true
			end  -- IAS24
		end

		return stand_found_flag
	end


	-- ----------###################################################################
	local function calc_bearing(lat1, long1, lat2, long2)
		-- https://forums.x-plane.org/index.php?/forums/topic/238453-how-do-i-find-runway-orientation/&do=findComment&comment=2131098
		--~ lat1=tonumber(lat1)
		--~ lat2=tonumber(lat2)
		--~ long1=tonumber(long1)
		--~ long2=tonumber(long2)
		--print(long2)
		dlat =lat2 - lat1
		dlong = long2 - long1

		la1 = lat1  * math.pi / 180
		la2 = lat2  * math.pi / 180
		lo1 = long1 * math.pi / 180
		lo2 = long2 * math.pi / 180
		dla = dlat  * math.pi / 180
		dlo = dlong * math.pi / 180

		dalpha =  math.log(math.tan(math.pi/4+la2/2)/math.tan(math.pi/4+la1/2))

		if (math.abs(dlo) > math.pi) then
			if dlo>0 then dlo = -(2*math.pi-dlo) else dlo = (2*math.pi+dlo) end
		end

		brng = math.atan2(dlo, dalpha) * 180/math.pi
		if brng < 0 then brng = 360 + brng end

		return brng
	end


	local includeCustomRunways = false
	local includeGlobalRunways = true
	function create_runway_position_cache()

		if includeCustomRunways then
			-- we will append custom sceneries
				print("[Ground Equipment " .. version_text_SGES .. "]  CREATING runways (Custom Sc.)")
				XPLMSpeakString("Reading custom scenery runways...")
				local custom_scenery = SCRIPT_DIRECTORY .. "../../../../Custom Scenery/scenery_packs.ini"
				-- we will append custom sceneries
				io.input(custom_scenery)
				io.output(SGES_runway_position_cache_CS)
				local count = 1
				while true do

					local custom_scenery_folder = io.read()
					if custom_scenery_folder == nil then break end
					-- each lines give the folder name to explore
					local custom_scenery_folder_name = string.match(custom_scenery_folder,"SCENERY_PACK%s(.*)")
					if custom_scenery_folder_name == nil then custom_scenery_folder_name ="null/" end
					if string.find(custom_scenery_folder_name,"SCENERY_PACK_DISABLED") then custom_scenery_folder_name = "null/" end
					if string.find(custom_scenery_folder_name,"Global Airports") then custom_scenery_folder_name = "null/" end
					-- we already counted the global airports and that will CTD the sim
					--print("custom_scenery_folder " .. custom_scenery_folder_name)
					custom_scenery_folder_name = SCRIPT_DIRECTORY .. "../../../../" .. custom_scenery_folder_name .. "Earth nav data/apt.dat"
					if string.find(custom_scenery_folder_name,"Custom Scenery") then
						--io.input(custom_scenery_folder_name)
						local open = io.open
						local function read_file(path)
							--print("we opên custom_scenery_folder_name : " .. custom_scenery_folder_name)
							local file = open(path, "rb") -- r read mode and b binary mode
							if not file then return nil end
							--print("Found it")
							local content = file:read "*a" -- *a or *all reads the whole file
							file:close()
							return content
						end
						local custom_scenery_content = read_file(custom_scenery_folder_name)

						--if string.match(custom_scenery_content, "^100%s+.*") then
							if custom_scenery_content ~= nil then io.write(custom_scenery_content .. "\n") end
							-- simply concatenate, after all, it won't be a monster file, it just a few scneeries compared to global apts
						--end
					end
			  end



			-- remove bad lines
			io.input(SGES_parking_position_cache_CST) -- temporary cache
			io.output(SGES_runway_position_cache_CS)
			local icount = 1
			while true do
				local apt_content = io.read()
				if apt_content == nil then break end -- when the file is finished
				runway_position_description = string.match(apt_content, "^100%s+.*")
				--100 20.00 4 0 0.00 0 0 0 06 -06.05187360 -056.30345475    0    0 0 0 0 0 24 -06.04923751 -056.30098970    0    0 0 0 0 0

				-- WE ONLY RETAIN LINES CONCERNING PARKING POSITIONS
				-- ALSO we remove lines for ground vehicles positions
				--string.match(parking_position_description,"[fuel|crew|baggage|food|pushback|gpu|misc].*")
				if runway_position_description ~= nil then
					--print(runway_position_description)
					--io.write(runway_position_description .. "\n")
					--runway_end_position = string.match(runway_position_description, "%d%d%u-s+%--%d%d%.%d%d%d%d%d%d%d%ds+%--%d%d%.%d%d%d%d%d%d%d%ds+%d%d%u-s+%--%d%d%.%d%d%d%d%d%d%d%ds+%--%d%d%.%d%d%d%d%d%d%d%d")
					--runway_end_position = string.match(runway_position_description, "%d%d?%us+%d%d%.%d*s+?%-%d%*.%d*s+?%-%d%*.%d*")
					local pattern = "%d%d%u-%s+%--%d+%.%d*%s+%--%d+%.%d*%s"
					runway_end_position = string.match(runway_position_description, pattern)
					runway_end_position2 = string.match(runway_position_description:reverse(), "%s%d%d*%.%d+%--%s+%d*%.%d+%--%s+%u-%d%d%s") --catch the last occurence

				   if runway_end_position ~= nil then io.write(runway_end_position .. "\n")  end
				   if runway_end_position2 ~= nil then io.write(string.sub(runway_end_position2:reverse(),2) .. "\n")  end
				end
				icount = icount + 1
			end
			XPLMSpeakString("Done.")
		end






		if includeGlobalRunways then
			print("[Ground Equipment " .. version_text_SGES .. "]  CREATING Runways (Global Sc)")
			XPLMSpeakString("Collecting global scenery runways. Please wait.")
			-- to ease calculation time on the go
			io.input(global_apt_dat)
			io.output(SGES_runway_position_cache)
			local count = 1
			local failed = 0
			local angularDeviationGrosscheck = 22
			--if IsXPlane12 then angularDeviationGrosscheck = 32 end -- be more gentle in the last sim
			--~ local angularDeviationGrosscheck = 359
			local angularDeviationGrosscheck = 30
			while true do
				local apt_content = io.read()
				if apt_content == nil then break end -- when the file is finished
				runway_position_description = string.match(apt_content, "^100%s+.*")

				--100 20.00 4 0 0.00 0 0 0 06 -06.05187360 -056.30345475    0    0 0 0 0 0 24 -06.04923751 -056.30098970    0    0 0 0 0 0

				--[[
				100 60.00 1 0 0.00 1 3 0 09L  49.02471900  002.52489200    0    0 3 2 1 0 27R  49.02669400  002.56168900    0   66 3 2 1 0 -- XP11 LFPG
				100 60.00 1 0 0.00 1 3 0 09L 49.0247190 2.5248920 0 0 3 2 1 0 27R 49.0266940 2.5616890 0 66 3 2 1 0 -- XP12 LFPG

				-->
				100 60.00 1 0 0.00 1 3 0 09L  49.02471900  002.52489200    0    0 3 2 1 0 27R  49.02669400  002.56168900    0   66 3 2 1 0 -- XP11 LFPG
				100 60.00 1 0 0.00 1 3 0 09L  49.0247190     2.5248920     0    0 3 2 1 0 27R  49.0266940     2.5616890     0   66 3 2 1 0 -- XP12 LFPG

				leading zero have disappeared in XP12

				-- US airports are not presented with leading zero to in the databank : be carefull for the regex

				1     13 0 0 KJFK John F Kennedy Intl
				1302 city New York
				100 60.96 2 0 0.00 1 3 0 13R 40.6483670 -73.8167280 623 0 3 0 0 0 31L 40.6279870 -73.7717594 995 0 3 0 0 0
				100 46.02 1 0 0.00 1 3 0 13L 40.6577704 -73.7902515 277 0 3 2 1 0 31R 40.6437240 -73.7592717 314 0 3 8 1 0
				100 60.00 2 0 0.00 1 3 0  4L 40.6220201 -73.7855838 140 0 3 0 0 1 22R 40.6505139 -73.7633201 1044 0 3 0 0 0
				100 60.96 1 0 0.00 1 3 0  4R 40.6254250 -73.7703472 0 0 3 2 1 0 22L 40.6452361 -73.7548639 0 0 3 2 1 0
				--]]

				-- WE ONLY RETAIN LINES CONCERNING PARKING POSITIONS
				-- ALSO we remove lines for ground vehicles positions
				--string.match(parking_position_description,"[fuel|crew|baggage|food|pushback|gpu|misc].*")
				if runway_position_description ~= nil then

				   local runwayEnd1_Lat = nil -- prepares the protection
				   local runwayEnd2_Lat = nil
				   local runwayEnd1_Lon = nil
				   local runwayEnd2_Lon = nil
				   local Runway_numbers = nil
				   local Runway2_numbers = nil
				   local RunwayHDG_crosscheck = nil
				   local Runway2HDG_crosscheck = nil

					--~ local pattern         = "%d%d%u-%s+%--%d+%.%d*%s+%--%d+%.%d*%s"
					--~ local reverse_pattern = "%s%d%d*%.%d+%--%s+%d*%.%d+%--%s+%u-%d%d%s"
					-- above worked but not for the US airports without leading zeros


					local pattern         = "%d*%d%u-%s+%--%d+%.%d*%s+%--%d+%.%d*%s"
					local reverse_pattern = "%d%d*%.%d+%--%s+%d*%.%d+%--%s+%u-%d%d*%s"

					runway_end_position  = string.match(runway_position_description, pattern)
					runway_end_position2 = string.match(runway_position_description:reverse(), reverse_pattern) --catch the last occurence
				   --if runway_end_position ~= nil then io.write("runway_end_position " .. runway_end_position .. "\n") end

				   -- compute runway heading
				   if runway_end_position ~= nil and runway_end_position2 ~= nil then

						runwayEnd1_Lat = tonumber(string.match(runway_end_position, "%d*%d%u-%s+(%--%d+%.%d+)%s+%--%d+%.%d"))
						runwayEnd2_Lat = tonumber(string.match(runway_end_position2:reverse(), "%d*%d%u-%s+(%--%d+%.%d+)%s+%--%d+%.%d"))
						runwayEnd1_Lon = tonumber(string.match(runway_end_position, "%d*%d%u-%s+%--%d+%.%d+%s+(%--%d+%.%d+)"))
						runwayEnd2_Lon = tonumber(string.match(runway_end_position2:reverse(), "%d*%d%u-%s+%--%d+%.%d+%s+(%--%d+%.%d+)"))

						Runway_numbers = string.match(runway_end_position, "(%d*%d)%u-%s+%--%d+%.%d+%s+%--%d+%.%d+")
						Runway2_numbers = string.match(runway_end_position2:reverse(), "(%d*%d)%u-%s+%--%d+%.%d+%s+%--%d+%.%d+")

						if Runway_numbers ~= nil then  RunwayHDG_crosscheck = tonumber(Runway_numbers) * 10 end
						if Runway2_numbers ~= nil then Runway2HDG_crosscheck = tonumber(Runway2_numbers) * 10 end


						--~ if Runway_numbers ~= nil then  RunwayHDG_crosscheck = string.format("%02d",tonumber(Runway_numbers)) * 10 end
						--~ if Runway2_numbers ~= nil then Runway2HDG_crosscheck = string.format("%02d",tonumber(Runway_numbers)) * 10 end


						if runwayEnd1_Lat ~= nil and runwayEnd1_Lon ~= nil and runwayEnd2_Lat ~= nil and runwayEnd2_Lon ~= nil then -- protec the operation

							bearing = math.ceil(calc_bearing(runwayEnd1_Lat, runwayEnd1_Lon, runwayEnd2_Lat, runwayEnd2_Lon) + 0.5)
							--print("bearing = math.ceil(calc_bearing(" .. runwayEnd1_Lat .. ", " .. runwayEnd1_Lon .. ", " .. runwayEnd2_Lat .. ", " .. runwayEnd2_Lon ..") + 0.5)")
						else bearing = -9999
						end


						if runway_end_position ~= nil and Runway_numbers ~= nil and bearing > RunwayHDG_crosscheck - angularDeviationGrosscheck and bearing < RunwayHDG_crosscheck + angularDeviationGrosscheck  then
							--~ if bearing == 1 or bearing == 181 then
								--~ io.write(runway_end_position .. ";" ..  tonumber(Runway_numbers) * 10 .. ";bearing estimation\n")
							--~ else
								io.write(runway_end_position .. ";" .. string.format("%03d",bearing) .. ";\n")
							--~ end
						else
							--print("FAILED CHECK " .. runway_end_position .. ";" .. bearing .. ";")
							--io.write("FAILED CHECK " .. runway_end_position .. ";" .. bearing .. ";\n")
							--~ io.write(string.sub(runway_end_position2:reverse(),2) .. ";" .. tonumber(Runway_numbers) * 10  .. ";\n")
								--~ io.write(runway_end_position .. ";" ..  tonumber(Runway_numbers) * 10 .. ";bearing estimation after bearing calc failed " .. bearing .. "\n")
							failed = failed + 1
						 end

						if bearing > 180 then bearing = bearing - 180 else bearing = bearing + 180 end -- reverse the calculated bearing to write the opposite runway end of the runway

						if runway_end_position2 ~= nil and Runway2_numbers ~= nil and bearing > Runway2HDG_crosscheck - angularDeviationGrosscheck and bearing < Runway2HDG_crosscheck + angularDeviationGrosscheck   then
							--~ if bearing == 1 or bearing == 181 then
								--~ io.write(string.sub(runway_end_position2:reverse(),2) .. ";" .. tonumber(Runway2_numbers) * 10 .. ";reverse bearing estimation\n")
							--~ else
								io.write(string.sub(runway_end_position2:reverse(),2) .. ";" .. string.format("%03d",bearing) .. ";\n")
							--~ end
						else
							--print("FAILED CHECK (rev) " .. runway_end_position .. ";" .. bearing .. ";")
							--~ io.write(string.sub(runway_end_position2:reverse(),2) .. ";" .. tonumber(Runway2_numbers) * 10  .. ";\n")
							--~ io.write(string.sub(runway_end_position2:reverse(),2) .. ";" .. tonumber(Runway2_numbers) * 10 .. ";reverse bearing estimation after bearing calc failed " .. bearing .."\n")
							failed = failed + 1
						 end

					   -- We needed to filter :
						--~ 23 -26.11084175  149.96021169 ;1;
						--~ 23 -26.11084175  149.96021169 ;181;
						--~ 19  38.19792807 -090.38492228 ;1;
						--~ 19  38.19792807 -090.38492228 ;181;
					    runwayEnd1_Lat = nil -- prepares the protection
						runwayEnd2_Lat = nil
						runwayEnd1_Lon = nil
						runwayEnd2_Lon = nil
						Runway_numbers = nil
						Runway2_numbers = nil

						-- KJFK becomes :
						--~ 13R 40.6483670 -73.8167280 ;122;
						--~ 31L 40.6279870 -73.7717594;302;
						--~ 13L 40.6577704 -73.7902515 ;122;
						--~ 31R 40.6437240 -73.7592717;302;
						--~ 4L 40.6220201 -73.7855838 ;032;
						--~ 22R 40.6505139 -73.7633201;212;
						--~ 4R 40.6254250 -73.7703472 ;032;
						--~ 22L 40.6452361 -73.7548639;212;
				   end
				end
				count = count + 1
			end


			XPLMSpeakString("Done.")
			print("Excluded " .. failed .. " lines which failed the grosscheck between runway number and runway calculated bearing.")
		end
	end
	local bearing = -99

	--add_macro("SGES : refresh runway cache", " create_runway_position_cache() ")

	--------------------------------------------------------------------------------
	--				PLACE THE BOAT
	--------------------------------------------------------------------------------

	function PlaceTheBoat(selected_boat)
			if selected_boat == nil then selected_boat = 0 end


			if user_boat_lon ~= nil and user_boat_lat~= nil then
				-- nothing
				g_shifted_x,g_shifted_y,g_shifted_z = latlon_to_local(user_boat_lat,user_boat_lon,0)
				if selected_boat == 1 then g_shifted_x = g_shifted_x - 50	g_shifted_z = g_shifted_z - 150 end

				-- testing forcing override
				if override_boats_table == nil then override_boats_table = dataref_table("sim/operation/override/override_boats") end

				if IsXPlane12  then override_boats_table[0] = 1 end --patch -- XP12 patch
				override_boats_table[selected_boat] = 1


				-- X-Plane 12.04 :
				if SGES_Sim_WindDir == nil then
					delayed_loading_ships_datarefs()
				end
				set_array("sim/world/boat/z_mtr", selected_boat, g_shifted_z)
				set_array("sim/world/boat/x_mtr", selected_boat, g_shifted_x)
				set_array("sim/world/boat/heading_deg", selected_boat, SGES_Sim_WindDir)

				if velocity_msc == nil then velocity_msc = dataref_table("sim/world/boat/velocity_msc","writable") end
				if velocity_msc[selected_boat] < 6 and selected_boat == 0 then velocity_msc[selected_boat] = math.floor(11) --21 knots for the carrier
				else velocity_msc[selected_boat] = math.floor(4) end -- 8 knots for the frigate

				if IsXPlane12 then
					command_once("sim/flight_controls/boats_navaids_on")
				end
				--~ if selected_boat == 0 and IsXPlane12 then
				--~ --
				--~ else
					--~ override_boats_table[selected_boat] = 0
				--~ end


			else
				local longitudinal_delta = DistanceToShipWreckSite
				local lateral_delta = -200
				if selected_boat == 0 then
					lateral_delta = 200
					print("[Ground Equipment " .. version_text_SGES .. "] Placing the aircraft carrier straight ahead.")
				end -- avoid superpositions
				if selected_boat == 1 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing the frigate straight ahead.")
				end
				if selected_boat == 97 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing HMS Dragon (Type45 Destroyer) straight ahead.")
				end
				if selected_boat == 98 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing X-Trident Nave Cavour aircraft carrier straight ahead.")
				end
				if selected_boat == 99 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing the Meko 360 frigate straight ahead.")
				end
				if selected_boat == 101 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing the USS Tarawa LHA-1 straight ahead.")
				end
				if selected_boat == 100 then
					print("[Ground Equipment " .. version_text_SGES .. "] Placing the HMS Eagle straight ahead.")
				end
				--															-- lateral , longitudinal , heading
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_delta, longitudinal_delta, sges_gs_plane_head[0] )
				_,wetness = probe_y (g_shifted_x, g_shifted_y, g_shifted_z)

				if wetness == 0 then -- move forward by iterations until on wet terrain if starting point is dry terrain
					local j=0
					for j=1,60 do -- abandon quickly if dry terrain cannot be easily found
						longitudinal_delta = longitudinal_delta + 670 -- at each iteration
						if selected_boat == 0 then longitudinal_delta = longitudinal_delta + 680 end -- avoid superpositions
						coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], lateral_delta, longitudinal_delta, sges_gs_plane_head[0] )
						_,wetness = probe_y (g_shifted_x, g_shifted_y, g_shifted_z)
						if wetness == 1 then
							print("[Ground Equipment " .. version_text_SGES .. "] Moved the boat to reach a more humid terrain with " .. j .. " iterations. Wetness " .. wetness .. " - forward_increment " .. longitudinal_delta)
							break
						end
					end
				end
				--print("[Ground Equipment " .. version_text_SGES .. "] The boat on a humid terrain ?  " .. wetness)
				-- we must dissociate and not do an elseif to chain the result above !
				if wetness == 1 then
					if override_boats_table == nil then override_boats_table = dataref_table("sim/operation/override/override_boats") end

					-- testing forcing override
					if override_boats_table == nil then override_boats_table = dataref_table("sim/operation/override/override_boats") end
					if IsXPlane12  then override_boats_table[0] = 1 end -- XP12 patch
					override_boats_table[selected_boat] = 1

					--~ if selected_boat == 0 then
						--print("[Ground Equipment " .. version_text_SGES .. "] Placing the ship straight ahead. " .. override_boats_table[selected_boat])
					--~ end -- avoid superpositions

					-- X-Plane 12.04 :
					if SGES_Sim_WindDir == nil then
						delayed_loading_ships_datarefs()
					end

					------------------------------------------------------------
					set_array("sim/world/boat/z_mtr", selected_boat, g_shifted_z)
					set_array("sim/world/boat/x_mtr", selected_boat, g_shifted_x)
					-- if the user wants a specific heading :
					--~ if boat_manual_control then
						--~ set_array("sim/world/boat/heading_deg", selected_boat, target_boat_course)
					--~ else
						set_array("sim/world/boat/heading_deg", selected_boat, SGES_Sim_WindDir)
					--~ end
					------------------------------------------------------------

					if velocity_msc == nil then velocity_msc = dataref_table("sim/world/boat/velocity_msc","writable") end
					if velocity_msc[selected_boat] < 11 then velocity_msc[selected_boat] = math.floor(11) end --21 knots


					if boat_manual_control then -- then reduced speed
						velocity_msc[selected_boat] = math.floor(target_boat_speed)
					end

					if IsXPlane12 then
						command_once("sim/flight_controls/boats_navaids_on")
					end
					--~ if selected_boat == 0 and IsXPlane12 then
						--~ --
					--~ else
						--~ override_boats_table[selected_boat] = 0
					--~ end
				end
			end
			target_boat_course = SGES_Sim_WindDir
			target_boat_speed = 11
			target_rudder_course = 0
			return selected_boat
	end


	if IsXPlane12 then
		function auto_release_boats()
			if boat_manual_control == false then
				set_array("sim/operation/override/override_boats", 0, 0)
				set_array("sim/operation/override/override_boats", 1, 0)
			end
		end
		do_sometimes("auto_release_boats()")
	end

	if IsXPlane12 then

		local lateral_propulsor = 0
		function steer_the_boats(selected_boat)

			if boat_manual_control then


				if override_boats_table == nil then override_boats_table = dataref_table("sim/operation/override/override_boats") end
				if velocity_msc == nil then velocity_msc = dataref_table("sim/world/boat/velocity_msc","writable") end
				if BoatH == nil then BoatH = dataref_table("sim/world/boat/heading_deg","writable") end

				if z_mtr_boats_table == nil then z_mtr_boats_table = dataref_table("sim/world/boat/z_mtr") end
				if x_mtr_boats_table == nil then x_mtr_boats_table = dataref_table("sim/world/boat/x_mtr") end

				-- funny additions :
				if roll_frequency_hz_sges == nil then roll_frequency_hz_sges = dataref_table("sim/world/boat/roll_frequency_hz","writable") end
				if roll_amplitude_deg_mtr_sges == nil then roll_amplitude_deg_mtr_sges = dataref_table("sim/world/boat/roll_amplitude_deg_mtr","writable") end
				if pitch_amplitude_deg_mtr_sges == nil then pitch_amplitude_deg_mtr_sges = dataref_table("sim/world/boat/pitch_amplitude_deg_mtr","writable") end
				if pitch_frequency_hz_sges == nil then pitch_frequency_hz_sges = dataref_table("sim/world/boat/pitch_frequency_hz","writable") end

				--~ if selected_boat == 0 then -- carrier patch
					--~ --
				--~ else
					override_boats_table[selected_boat] = 1
				--~ end

				-- make the boat turn :

				if math.abs(target_rudder_course) > 2  then
				-- turn direct
					BoatH[selected_boat] = BoatH[selected_boat] + 0.0025 * target_rudder_course
				else
					BoatH[selected_boat] = BoatH[selected_boat]
				end
				if BoatH[selected_boat] < 0 then BoatH[selected_boat] = BoatH[selected_boat] + 360 end
				if BoatH[selected_boat] > 360 then BoatH[selected_boat] = BoatH[selected_boat] - 360 end

				--~ -- progressive change of speed toward target speed :

				if velocity_msc[selected_boat] > target_boat_speed + 0.05 then
					if target_boat_speed < 0 then
						-- with reverse, slow down more quickly
						velocity_msc[selected_boat] = velocity_msc[selected_boat] - 0.006
					else
						velocity_msc[selected_boat] = velocity_msc[selected_boat] - 0.004
					end
				end
				if velocity_msc[selected_boat] < target_boat_speed - 0.05 then
					velocity_msc[selected_boat] = velocity_msc[selected_boat] + 0.004
				end

				-- add stuff :

				if selected_boat == 0 then
					roll_frequency_hz_sges[selected_boat] = 0.1
					pitch_frequency_hz_sges[selected_boat] = 0.1
					roll_amplitude_deg_mtr_sges[selected_boat] = 1.5
					pitch_amplitude_deg_mtr_sges[selected_boat] = 0.5
				else -- frigate
					roll_frequency_hz_sges[selected_boat] = 0.6
					pitch_frequency_hz_sges[selected_boat] = 0.4
					roll_amplitude_deg_mtr_sges[selected_boat] = 2
					pitch_amplitude_deg_mtr_sges[selected_boat] = 0.8
				end

				------------------- PATCH XP12.05 BOATS ------------------------
				if SGES_XPlaneIsPaused == 0 then
					-- problem : setting the speed in override mode doesn't make anything
					-- I need to make the ship advance myself !!! :-(
					-- common, I can do it !
					-- August, 2023
					-- probe terrain ahead
					--~ coordinates_of_adjusted_ref_rampservice(x_mtr_boats_table[selected_boat], z_mtr_boats_table[selected_boat], 0, 0, BoatH[selected_boat] )
					--~ _,wetness_b = probe_y (g_shifted_x, 0, g_shifted_z)
					--~ if wetness_b == 0 then -- avoidance
						--~ target_boat_speed = -1 -- for next round
						--~ target_rudder_course = 15 --° rudder
						--~ lateral_propulsor = -10
					--~ elseif wetness_b == 1 and target_rudder_course == 15 then -- end of avoidance
						--~ target_boat_speed = 5 -- for next round
						--~ target_rudder_course = 0 --° rudder
						--~ lateral_propulsor = 0
					--~ end

					-- speed has no effect on the model, we must move it ourselves !
					coordinates_of_adjusted_ref_rampservice(x_mtr_boats_table[selected_boat], z_mtr_boats_table[selected_boat], lateral_propulsor, velocity_msc[selected_boat]/20, BoatH[selected_boat] )
					-- this has to be calibrated so that the 3D ojects move coincidate like the ground speed really wanted


					if target_boat_knots > 200 then -- the jump ahead
						coordinates_of_adjusted_ref_rampservice(x_mtr_boats_table[selected_boat], z_mtr_boats_table[selected_boat], 0, math.abs(velocity_msc[selected_boat]*2), BoatH[selected_boat] )
					end

						set_array("sim/world/boat/z_mtr", selected_boat, g_shifted_z)
						set_array("sim/world/boat/x_mtr", selected_boat, g_shifted_x)
				end
				----------------------------------------------------------------

			end
		end
			--~ do_every_frame("steer_the_boats(1)")
			--~ do_often("steer_the_boats(0)")
	end


	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------



-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
--                      MARSHALLER MODULE
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////





		--------------------------------------------------------------------------------

	Prefilled_StopSignObject = 	SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/3d_marshaller_animated/3DMarshaller_blender.obj" -- marshaller by Paul Mort on "the Org".
	Prefilled_StopSignReachingObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/3d_marshaller_animated/3DMarshaller_blender_end.obj" -- by Paul Mort on "the Org".
	Prefilled_StopSignFixedObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/3d_marshaller_animated/3DMarshaller_blender_ac3d_static.obj" -- by Paul Mort on "the Org".
	StopSignObject = 	Prefilled_StopSignObject -- INIT

	function load_StopSign()
		if StopSign_show_only_once then
		   XPLM.XPLMLoadObjectAsync(StopSignObject,
					function(inObject, inRefcon)
						TargetMarker_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						rampservicerefStopSign = inObject
					end,
					inRefcon )
		   --~ XPLM.XPLMLoadObjectAsync(Prefilled_StopSignArms,
					--~ function(inObject, inRefcon)
						--~ TargetMarker_instance[2] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
						--~ rampservicerefArms = inObject
					--~ end,
					--~ inRefcon )
			--~ print("load marshaller")
			-- reset for next cycle
			StopSignObject = 	Prefilled_StopSignObject
			StopSign_show_only_once = false
		end
	end



	function service_object_physics_Marshaller() -- The Marshaller position
		if StopSign_chg == true then
			if show_StopSign then
				--~ print("command load marshaller")
				load_StopSign()
			else
				--~ print("command unload marshaller")
				if TargetMarker_instance[1] ~= nil then _,TargetMarker_instance[1],rampservicerefStopSign = common_unload("StopSign",TargetMarker_instance[1],rampservicerefStopSign) end
				if TargetMarker_instance[2] ~= nil then StopSign_chg,TargetMarker_instance[2],rampservicerefArms = common_unload("Arms",TargetMarker_instance[2],rampservicerefArms) end
				--unload_StopSign()
			end
			if TargetMarker_instance[1] ~= nil and retained_parking_position_heading ~= nil and TargetMarkerX_stored ~= nil then
				-- POSITIVE LEFT < x > NEGATIVE RIGHT
				-- POSITIVE FWD < z > NEGATIVE AFT()
				--~ print("command draw marshaller")
				local x = 0
				local z = 8.5
				if BeltLoaderFwdPosition > 5 then x = 1 z = 15 end -- for airliner, make him backward
				local h = 0
				-- when the follow me is visible, move the marshaller a bit to the side :
				if show_FM then x = 2 h = -7 end
				if TargetMarker_instance[1] ~= nil  then StopSign_chg = draw_marshaller_object(x,z,h,TargetMarker_instance[1],"StopSign") end
				if TargetMarker_instance[2] ~= nil  then StopSign_chg = draw_marshaller_object(x,z,h,TargetMarker_instance[2],"Arms") end -- optional
			end
		end

	end


	function Marshaller_stand_distance_calc(plane_x, plane_z, in_target_x, in_target_z, in_heading, VDGS_y ) -- the VDGS already had a calculation function that I didn't want to touch
		local  in_delta_x = plane_x - in_target_x
		local in_delta_z = plane_z - in_target_z
		local stand_distance = math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) )
		return (stand_distance/10)+0.5,stand_distance -- the movement quantify the distance to the parking stand
	end -- that function is used in sub modules also.

	function SayInfoOnRampTargetMarker() --IAS24



		if show_TargetMarker or guidance_active then

			local max_allowable_differential_position = 0.3
			if BeltLoaderFwdPosition < 5 then max_allowable_differential_position = 0.35 end
			if BeltLoaderFwdPosition >= 18 then max_allowable_differential_position = 0.5 end
			if automatic_marshaller_requested and custom_scenery_only then max_allowable_differential_position = 3*max_allowable_differential_position
			elseif automatic_marshaller_requested then max_allowable_differential_position = 4*max_allowable_differential_position end

			local distance_factor = 90
			-- if the marshaller is requested without follow-me vehicle, I'll make him appear early
			if direct_Marshaller then
				distance_factor = 180
			end

			_,distance_to_sges_stand =	 Marshaller_stand_distance_calc(NosePositionX, NosePositionZ, TargetMarkerX_stored, TargetMarkerZ_stored, sges_gs_plane_head[0], 0)

			if distance_to_sges_stand < distance_factor and approaching_TargetMarker == 0 then
				approaching_TargetMarker = 1
				-- this step is safety because it can triggered sometimes before marker position reinitialization.
				-- so keep it silent
				--~ print("approaching_TargetMarker = 1,  distance_to_sges_stand = " .. distance_to_sges_stand .. "------------------------------------------------------")

				if not show_VDGS then
					show_StopSign = true
					StopSign_chg = true
				end
				guidance_active = true
				automatic_marshaller_already_requested_once = true -- forbids the automatic search which spoils the experience at this point
			end

			if distance_to_sges_stand < 17 and approaching_TargetMarker == 1 then
				approaching_TargetMarker = 2
				-- for the follow me car
			end

			if distance_to_sges_stand < 15 and approaching_TargetMarker == 2 then
				guidance_active = true
				approaching_TargetMarker = 3.5
				--~ print("approaching_TargetMarker = 2,  distance_to_sges_stand = " .. distance_to_sges_stand)
				--XPLMSpeakString("3")
				--print("Marshaller : 3")
			end

			if distance_to_sges_stand <=3 and approaching_TargetMarker == 3.5 then
				--XPLMSpeakString("1. ")
				--print("Marshaller : 1")
				approaching_TargetMarker = 3.9
				--~ print("approaching_TargetMarker = 4,  distance_to_sges_stand = " .. distance_to_sges_stand)
				if not show_VDGS then
					StopSign_chg,TargetMarker_instance[1],rampservicerefStopSign = common_unload("StopSign",TargetMarker_instance[1],rampservicerefStopSign)
					StopSignObject = 	Prefilled_StopSignReachingObject
					show_StopSign = true -- changing person Prefilled_StopSignFixedObject if not VDGS
					StopSign_chg = true
					StopSign_show_only_once = true
				end
				store_distance_to_sges_stand = distance_to_sges_stand
			end

			if store_distance_to_sges_stand ~= nil and distance_to_sges_stand > store_distance_to_sges_stand and approaching_TargetMarker == 3.9 then
				approaching_TargetMarker = 4 -- emergency exit to the STOP situation, when not passed below distance 0.7
				print("Marshaller : exit do to distance > threshold (i.e. the backup exit).")
			end

			if distance_to_sges_stand <0.7 and approaching_TargetMarker == 3.9 then
				approaching_TargetMarker = 4
				if not show_VDGS then
					StopSign_chg,TargetMarker_instance[1],rampservicerefStopSign = common_unload("StopSign",TargetMarker_instance[1],rampservicerefStopSign)
					StopSignObject = 	Prefilled_StopSignFixedObject
					show_StopSign = true -- changing person Prefilled_StopSignFixedObject if not VDGS
					StopSign_chg = true
					StopSign_show_only_once = true
				end
			end


			if approaching_TargetMarker == 4 then -- save position

				-- when it's a reducing it's ok.
				-- we are looking for the minimum of the function
				-- when it's increasing, we are distancing the reference point

				-- as soon as the new diff is greater than the previous value, raise a flag !
				-- we anticipate slightly
				if distance_to_sges_stand > store_distance_to_sges_stand or distance_to_sges_stand < 0.6 then
						--if diff_X > store_diff_X then XPLMSpeakString("X") end
						--if diff_Z > store_diff_Z then XPLMSpeakString("Z") end
						--~ XPLMSpeakString("Stop")
						if SGES_sound and not show_VDGS then
							play_sound(Stop_sound)
						end
						print("Marshaller : Stop")

						--~ print("approaching_TargetMarker = 4.5,  distance_to_sges_stand = " .. distance_to_sges_stand)
						show_TargetMarker = false
						TargetMarker_chg = true
						Mashaller_available = false
						automatic_marshaller_requested = false
						-----------------------
						--show_Bus = l_newval
						--Bus_chg = true
						--show_GPU = l_newval
						--GPU_chg = true
						--show_Cart = l_newval
						--Cart_chg = true
						--show_Cones = l_newval
						--Cones_chg = true
						store_diff_X = 900000
						store_diff_Z = 900000
						-- ////////////////// EXIT 1 ///////////////////////////
						guidance_active = false
				end
				-- store the current distance for the next round
				store_distance_to_sges_stand = distance_to_sges_stand
			end

		end


	end

	function draw_marshaller_object(placeToBeX,placeToBeZ,object_hdg_corr,Instance,object_name)
		-- HERE, z is lateral
		if object_name ~= nil and Instance ~= nil and placeToBeX ~= nil and placeToBeZ ~= nil then
			if object_hdg_corr == nil then object_hdg_corr = 0 end
			local reference_x = TargetMarkerX_stored
			local reference_z = TargetMarkerZ_stored
			local reference_heading = sges_gs_plane_head[0]
			if automatic_marshaller_requested then
				reference_heading = retained_parking_position_heading
			end
			coordinates_of_adjusted_ref_rampservice(reference_x, reference_z, placeToBeX, placeToBeZ, reference_heading)
			objpos_addr, float_addr, wetness = OnScenery(g_shifted_x,g_shifted_z,g_shifted_y,reference_heading+object_hdg_corr,nil,object_name)
			local 	changed = object_name .. "_chg"

			if wetness == 0 then
				XPLM.XPLMInstanceSetPosition(Instance, objpos_addr, float_addr)
			else
				print("[Ground Equipment " .. version_text_SGES .. "] Placing the marshaller on scenery was prevented because terrain is water. That's desirable.")
			end
			objpos_value[0].roll = 0
			objpos_value[0].pitch = 0
			changed = false
			return changed
		elseif placeToBeZ == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a marshaller object but couldn't, due to a missing z coordinate.")
		elseif placeToBeX == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a marshaller object but couldn't, due to a missing x coordinate.")
		elseif object_name == nil then
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a marshaller object but couldn't, due to a missing name.")
		else
			print("[Ground Equipment " .. version_text_SGES .. "]  We wanted to draw a marshaller object but couldn't (missing instance).")
		end
	end



-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////






	-- ////////////////////////////////// GROUND SERVICE /////////////////////////////////////////////////////////

	local larg = 237
	groundservices_float_wnd = nil
	function show_windoz() -- new version on 27th of June, 2022, floatting variant.
		-- SGES_XPlane_user_interface_scale == 1 or 1.5 or 2
		--if groundservices_float_wnd == nil and sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then -- IAS24
		if groundservices_float_wnd == nil and sges_gs_ias_spd[0] < 295 then -- IAS24
			time_opening_groundservices_float_wnd = SGES_total_flight_time_sec
			larg = 267																											----- GUI SIZE HERE
			local haut = 530
			if SecondStairsFwdPosition ~= -30 and SGES_stairs_type ~= "Boarding_without_stairs" and BeltLoaderFwdPosition >= 17 then
				haut = haut + 15
			end

			if SCREEN_HIGHT == nil then SCREEN_HIGHT = 1024 end -- has a typo in X-Plane ! Beware in XP 12 !
			groundservices_float_wnd = float_wnd_create(larg, haut, 1, true) -- the third parameter is 1  for floating windows, 2 for fixed windows.
			float_wnd_set_title(groundservices_float_wnd, "Ground services " .. version_text_SGES)
			--float_wnd_set_position(groundservices_float_wnd, SCREEN_WIDTH*0.5-larg/2,  SCREEN_HIGHT*0.5-haut/2)
			if posx == nil then posx = SCREEN_WIDTH*0.5-larg/2 end
			if Cat_acting ~= nil then Cat_acting() end
			-- regarding the vertical position on the screen
			-- XPJavelin used until October 2024 :
			--posy = SCREEN_HIGHT*0.5-haut/2

			-- but thensweat @enjxp came with an enjoyable solution :
			-- "I had a try and found it would be better with this tuning :"
			-- posy = SCREEN_HIGHT*0.5-haut/2 - 75   -- line #10163 in SGES 72.0

			-- Then XPJavelin adapted that :
			if IsXPlane12 and SGES_XPlane_user_interface_scale == nil then SGES_XPlane_user_interface_scale = get("sim/graphics/misc/user_interface_scale")
			elseif SGES_XPlane_user_interface_scale == nil then SGES_XPlane_user_interface_scale = 1 end

			if SCREEN_HIGHT > 2* haut then
				posy = SCREEN_HIGHT*0.5-haut/2 - (100 * 2 * SGES_XPlane_user_interface_scale)
			else
				posy = SCREEN_HIGHT*0.5-haut/2
			end
			-- changed 2023 08 :
			posx=100
			--changed 2023 12 :
			if float_wnd_saved_position_x ~= nil then
				if float_wnd_saved_position_x > 101 then
					posx = float_wnd_saved_position_x
				else
					float_wnd_saved_position_x = 100
					posx=100
				end
			end

			if float_wnd_saved_position_x == nil and float_wnd_saved_position_y == nil then
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
			else
				float_wnd_set_position(groundservices_float_wnd, float_wnd_saved_position_x,  posy)
			end -- december 2023 changed to allow saving position
			-- apply some effects : --https://github.com/X-Friese/FlyWithLua/blob/master/FlyWithLua/Scripts%20(disabled)/imgui_demo.lua
			-- put the content inside :
			float_wnd_set_imgui_builder(groundservices_float_wnd, "build_windoz")
			float_wnd_set_onclose(groundservices_float_wnd, "hide_floatting_windoz")
			--~ if PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then command_once("CL650/fbo/debug/tog_status_window") end
			if sges_gs_gnd_spd[0] < 0.1 and sges_gs_plane_y_agl[0] < 1 and SGES_is_glider == 0 and math.abs(BeltLoaderFwdPosition) > 4 then sges_big_airport,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,sges_airport_ID) end
		else
			hide_floatting_windoz()
		end
	end

	-- ////////////////////////////////// GROUND SERVICE /////////////////////////////////////////////////////////

	XPJ_show = false
	groundservices_wnd = nil
	SGES_LegacyGUI = true
	local loadOptions = false

	BoardStairsXPJ = true
	BoardStairsXPJ2 = false
	ladder_state = 0
	GUIcoordinates = false

	function show_fixed_windoz()

		if not SGES_LegacyGUI and not SUPPORTS_FLOATING_WINDOWS then
			-- to make sure the script doesn't stop old FlyWithLua versions
			logMsg("imgui not supported by your FlyWithLua version")
			SGES_LegacyGUI = true
			return
		end

		Cat_acting()

		windoz_first_access = true

		if SGES_LegacyGUI or not groundservices_wnd_open then

			local sges_win_height = 520
			if (SecondStairsFwdPosition ~= -30 and SGES_stairs_type ~= "Boarding_without_stairs" and BeltLoaderFwdPosition >= 17 and show_StairsXPJ and show_StairsXPJ2 and StairFinalY_stairIV ~= nil and StairFinalY_stairIII ~= nil) or show_StairsXPJ3 then
				sges_win_height = sges_win_height + 20
			end

			groundservices_wnd = float_wnd_create(218, sges_win_height, 2, true)
			float_wnd_set_title(groundservices_wnd, "Ground services options")
			if posx == nil then posx=screen_width - 2*screen_width/3 - Holder_len end
			posy=Win_Y-50



			if float_wnd_saved_position_x == nil then
				float_wnd_set_position(groundservices_wnd, posx,  posy)
			else
				float_wnd_set_position(groundservices_wnd, float_wnd_saved_position_x,  posy)
			end -- december 2023 changed to allow saving position

			float_wnd_set_imgui_builder(groundservices_wnd, "build_windoz")
			XPJ_show = true
			if not SGES_LegacyGUI then
				float_wnd_set_onclose(groundservices_wnd, "hide_windoz")
				groundservices_wnd_open = true
				app_is_active = true
				float_wnd_set_geometry(groundservices_wnd, SCREEN_WIDTH- 2*screen_width/3, 450, SCREEN_WIDTH- 2*screen_width/3 + 220, 10)
			end
		end
		--~ if PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then command_once("CL650/fbo/debug/tog_status_window") end
		if sges_gs_gnd_spd[0] < 0.1 and sges_gs_plane_y_agl[0] < 1 and SGES_is_glider == 0 and math.abs(BeltLoaderFwdPosition) > 4 then sges_big_airport,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,sges_airport_ID) end
	end


	function hide_windoz()
		groundservices_wnd_open = false
		if groundservices_wnd ~= nil then
			set_array("sim/operation/override/override_boats", 0, 0) -- carrier
			set_array("sim/operation/override/override_boats", 1, 0) -- frigate
			float_wnd_destroy(groundservices_wnd)
			groundservices_wnd = nil
			Window_is_inactive = true
			if config_helper ~= nil then config_helper = false end
			XPJ_show = false
			--~ if PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then command_once("CL650/fbo/debug/tog_status_window") end
		end
	end

	function hide_floatting_windoz()
		if groundservices_float_wnd ~= nil then
			set_array("sim/operation/override/override_boats", 0, 0) -- carrier
			set_array("sim/operation/override/override_boats", 1, 0) -- frigate
			float_wnd_destroy(groundservices_float_wnd)
			groundservices_float_wnd = nil
			if config_helper ~= nil then config_helper = false end
			sges_ship_cancelled_cause_land = false -- also reset that conveniently
		end
	end

	dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_GUI_for_VR.lua") -- threat module
	add_macro("SGES : display the SGES window","if XPJ_show then hide_windoz() else show_windoz() end")
	add_macro("SGES : display the VR window (beta)","create_VR_GUI()")
    add_macro("SGES : deploy an active SAM site (nearest airport)","show_Sam = true Sam_chg = true 	if show_Sam and not Threat_module_loaded then dofile (SCRIPT_DIRECTORY .. \"Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Threat.lua\") end","show_Sam = false Sam_chg = true","deactivate")
	add_macro("SGES : stop downed AI to respawn in battle","prevent_respawn = true 	if prevent_respawn and not sges_respawn_loaded then dofile (SCRIPT_DIRECTORY .. \"Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_AiDontReborn.lua\") end","prevent_respawn = false if sges_respawn_loaded then AcquireAircraft_sges()  ReleaseAircraft_sges() end","deactivate")
	if sges_ahr == 1 then
	add_macro("SGES : air to air refueling","show_AAR = true AAR_chg = true","show_AAR = false  AAR_chg = true","deactivate")
	end

	function auto_hide_floatting_windoz()
		if groundservices_float_wnd ~= nil and ((sges_gs_ias_spd[0] > 260 and SGES_total_flight_time_sec > time_opening_groundservices_float_wnd + 20)  or (sges_gs_plane_y_agl[0] > 3333 and SGES_total_flight_time_sec > time_opening_groundservices_float_wnd + 20) or SGES_total_flight_time_sec > time_opening_groundservices_float_wnd + 600) then --IAS24
			hide_floatting_windoz() -- avoids OOM
		end
		-- also I will jump on the occasion to remove the chocks if we are flying ! That's a safety to prevent an abrupt stop upon landing.
		-- some addon may trigger chocks falsely an we want to avoid having chocks ON at landing !
		if sges_gs_ias_spd[0] > 80 and sges_gs_plane_y_agl[0] > 100 and show_Chocks ~= nil and Chocks_chg ~= nil and show_Chocks then show_Chocks = false  Chocks_chg = true end -- safety removal of chocks in flight !
		-- I will use this function with do_sometimes to sequences secondary stuff also :


	end
	do_sometimes("auto_hide_floatting_windoz()")  -- avoids OOM

	-- the following function was the key "F" hardcoded to open the menu.
	--[[
	function key_handlerFM()
		if VKEY == 70 and KEY_ACTION == "pressed" then
			if XPJ_show then hide_windoz() else show_windoz() end
			print("GROUND-SERVICE (" .. VKEY .. ")")
		 end
	end
	do_on_keystroke("key_handlerFM()") ]]

	show_FireVehicleAhead = false
	show_samFM = false
	show_Pelicandrome = false



	--~ function build_windoz(groundservices_wnd, x, y)

	--~ end


	function build_windoz(groundservices_wnd, x, y)
		-- get the current time
	  local l_is_selected = false
	  local l_changed = false
	  imgui.SetWindowFontScale(1.0)
	  --imgui.TextUnformatted(curr_ICAO.. "   ".. curr_ICAO_name)
		if SGES_total_flight_time_sec < time_opening_groundservices_float_wnd + 5 and SGES_local_time_in_simulator_hours ~= nil then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted(string.format("%02d",SGES_local_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " L")
			imgui.PopStyleColor()
			-- we sampled the time once to save performance and datref indexation, so this is not a permanent display of the local time
			if imgui.IsItemHovered() then
				if not show_Helicopters and IsXPlane12 and (military == 1 or military_default == 1) then
					show_Helicopters = true
					Helicopters_chg = true
				end
				-- Click & hold tooltip
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Simulator")
				imgui.TextUnformatted(string.format("%02d",SGES_zulu_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " UTC (Z)")
				imgui.TextUnformatted(string.format("%02d",SGES_local_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " Local time ")
				imgui.PopStyleColor()
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		elseif SGES_zulu_time_in_simulator_hours ~= nil then
			imgui.TextUnformatted(string.format("%02d",SGES_zulu_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " Z")
			-- we sampled the time once to save performance and datref indexation, so this is not a permanent display of the local time
			if imgui.IsItemHovered() then
				if not show_Helicopters and IsXPlane12 and (military == 1 or military_default == 1)  then
					show_Helicopters = true
					Helicopters_chg = true
				end
				-- Click & hold tooltip
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.Separator()
				imgui.TextUnformatted("Simulator")
				imgui.TextUnformatted(string.format("%02d",SGES_zulu_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " UTC (Z)")
				imgui.TextUnformatted(string.format("%02d",SGES_local_time_in_simulator_hours[0]) .. "h" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " Local time ")
				imgui.Separator()
				imgui.PopStyleColor()
				imgui.TextUnformatted(string.format("%02d",os.date("%H")) .. "h" ..  string.format("%02d",os.date("%M")) .. " Computer time")
				imgui.TextUnformatted(os.date("%A") .. " " .. os.date("%x"))
				--~ imgui.TextUnformatted("Your computer time,\noutside the simulator.")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		else
			imgui.TextUnformatted("SERVICES")




		end

		if IsXPlane12 then


			if (math.abs(sges_gs_gnd_spd[0]) < 0.5 or show_CockpitLight) then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				if  imgui.SmallButton("Glow",15,10)  then

					if show_CockpitLight then
						show_CockpitLight = false
						CockpitLight_chg = true
					else
						show_CockpitLight = true
						CockpitLight_chg = true
					end
				end
				imgui.PopStyleColor()
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Night ambiance.")
					imgui.TextUnformatted("Available if stopped.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			else
			imgui.SameLine()
			imgui.TextUnformatted("XP12 ")
			end

		else
			imgui.SameLine()
			imgui.TextUnformatted("XP11 ")
		end

	  imgui.SetWindowFontScale(1)
	  if groundservices_float_wnd ~= nil then


			--~ float_wnd_saved_position = imgui.GetWindowPos(groundservices_float_wnd).x
			--~ print(float_wnd_saved_position)
			--~ float_wnd_saved_position_y = imgui.GetWindowPos(groundservices_wnd).y


			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)

			--~ imgui.PushItemWidth(110)
			--~ local changed, newVal2 = imgui.SliderFloat("wp", posx, 100, SCREEN_WIDTH*0.5-larg/2, "Window")
			--~ if changed then
				--~ float_wnd_set_position(groundservices_float_wnd, posx,  posy)
			--~ end

			imgui.SameLine()
			if  imgui.SmallButton("<<")  then
				posx = 100
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
				float_wnd_saved_position_x = posx
				--~ float_wnd_saved_position_y = posy
				SGES_WriteToDisk()
			end
			imgui.SameLine()
			if  imgui.SmallButton("<")  then
				posx = posx - 200
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
				float_wnd_saved_position_x = posx
				--~ float_wnd_saved_position_y = posy
				SGES_WriteToDisk()
			end
			imgui.SameLine()
			if  imgui.SmallButton("^")  then
				posx = SCREEN_WIDTH*0.5-larg/2
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
				float_wnd_saved_position_x = posx
				SGES_WriteToDisk()
			end
			imgui.SameLine()
			if  imgui.SmallButton(">")  then
				posx = posx + 200
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
				float_wnd_saved_position_x = posx
				--~ float_wnd_saved_position_y = posy
				SGES_WriteToDisk()
			end
			imgui.SameLine()
			if  imgui.SmallButton(">>")  then
				posx = screen_width - larg - 100
				float_wnd_set_position(groundservices_float_wnd, posx,  posy)
				float_wnd_saved_position_x = posx
				--~ float_wnd_saved_position_y = posy
				SGES_WriteToDisk()
			end
			imgui.PopStyleColor()
			if sges_gs_ias_spd[0] < 50 and sges_gs_plane_y_agl[0] < 150 then
				imgui.SameLine()
				imgui.PushStyleVar(imgui.constant.StyleVar.FrameRounding, 8)
				if  imgui.Button("W",15,15)  then
					command_once("sim/operation/open_weight_and_balance_window")
				end
				imgui.PopStyleVar()
			end
			imgui.SetWindowFontScale(1.0)
			imgui.PopStyleColor()
		end
	  --if not SGES_LegacyGUI then
		--~ imgui.SameLine()
		--~ if imgui.Button("X",35,17) then
			--~ hide_windoz()
			--~ hide_floatting_windoz() -- bad idea for flaoting windows
		--~ end
	  --end

	  imgui.Separator()
	  if sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then
		if sges_gs_gnd_spd[0] < 30 and not GUImoreShip then
		  l_changed, l_newval = imgui.Checkbox(" Follow-me", show_FM)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("A Follow Me car. You're actually just pretending to follow.")
				imgui.TextUnformatted("Also allows to activate the marshaller.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			--Chocks_position_settle()
			show_FM = l_newval
			FM_chg = true
			FMonce = 0
			show_StopSign = false
			StopSign_chg = true
			show_TargetMarker = false
			TargetMarker_chg = true
			user_targeting_factor = 25
			approaching_TargetMarker = 0
			automatic_marshaller_requested = false
			if show_FM == false then
				stand_found_flag = 0 -- reset to allow auto search once more
				stand_searched_flag = false
				--~ direct_Marshaller = false
			end
			direct_Marshaller = false
		  end
		end
		if sges_gs_gnd_spd[0] < 20 and not GUImoreShip and not show_FM then
			imgui.SameLine()
		  l_changed, l_newval = imgui.Checkbox(" Marshaller", direct_Marshaller)
		  if l_changed then
			direct_Marshaller = l_newval
			Mashaller_available = l_newval
			--~ FMonce = 0
			show_StopSign = false
			StopSign_chg = true
			show_TargetMarker = false
			TargetMarker_chg = true
			user_targeting_factor = 25
			approaching_TargetMarker = 0
			automatic_marshaller_requested = false
			if direct_Marshaller == false then
				stand_found_flag = 0 -- reset to allow auto search once more
				stand_searched_flag = false
			end

			--IAS24 added section below :
			-- to search for stand immediatly

			-- however we want it only hen the aircfrat is a moving at slow pace, because the stutter resulting frmo th stand search i nthe data will be pretty noticeable otherwise.
			-- also we will make the search only once per session.
			if sges_gs_gnd_spd[0] < 5 and direct_Marshaller and not automatic_marshaller_already_requested_once then
				approaching_TargetMarker = 0
				stand_found_flag = 0
				automatic_marshaller_requested = true
				automatic_marshaller_capture_position_threshold = 0.003 -- value is important
				stand_found_flag = get_airport_intell_Core("standard")
				stand_searched_flag = true
				if show_DockingSystem then show_VDGS = true end
				VDGS_manual = false
				automatic_marshaller_already_requested_once = true
				SGES_park_designation_flight_time_sec = SGES_total_flight_time_sec --IAS24
			end
		  end

		  				--~ -- ACTIVATE THE VDGS GUI :
			--~ if IsXPlane12 and (math.abs(BeltLoaderFwdPosition) > 5 or string.match(PLANE_ICAO,"AT") or string.match(PLANE_ICAO,"B4") or string.match(PLANE_ICAO,"RJ")) then
				--~ imgui.SameLine()

				--~ l_changed, l_newval = imgui.Checkbox(" VDGS", show_VDGS)
			--~ end
			--~ if imgui.IsItemActive() then
				--~ -- Click & hold tooltip
				--~ imgui.BeginTooltip()
				--~ -- This function configures the wrapping inside the toolbox and thereby its width
				--~ imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				--~ imgui.TextUnformatted("Visual docking guidance system.")
				--~ imgui.PopStyleColor()
				--~ -- Reset the wrapping, this must always be done if you used PushTextWrapPos
				--~ imgui.PopTextWrapPos()
				--~ imgui.EndTooltip()
			--~ end
			--~ if l_changed then
				--~ show_VDGS = l_newval
				--~ show_VDGS_UTC = not l_newval
				--~ VDGS_chg = true
				--~ if show_VDGS and not VDGS_module_loaded then
					--~ print("[Ground Equipment " .. version_text_SGES .. "] Will read VDGS sub-script")
					--~ dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_VDGS.lua") -- threat module
				--~ end
				--~ show_StopSign = not l_newval
				--~ StopSign_chg = true


				--~ show_TargetMarker = false
				--~ TargetMarker_chg = true
				--~ user_targeting_factor = 25
				--~ approaching_TargetMarker = 0
				--~ automatic_marshaller_requested = false
				--~ if show_FM == false then
					--~ stand_found_flag = 0 -- reset to allow auto search once more
					--~ stand_searched_flag = false
				--~ end
				--~ direct_Marshaller = true

			--~ end

		end

-------------- Marshaller UI ------------------------------------------
		if (show_FM or direct_Marshaller) and sges_gs_gnd_spd[0] < 6 and (Mashaller_available or direct_Marshaller) then

			----------------------------------------------------------------
			-- if the user has set a permanent option to have the VDGS, we need to allow that by loading the module immediatly :
			if show_VDGS and not VDGS_module_loaded then
				print("[Ground Equipment " .. version_text_SGES .. "] Will read VDGS sub-script early because it is requested by the user as a permanent option.")
				dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_VDGS.lua") -- threat module
			end
			-- otherwise that can be avoided if the user hasn't usage of the VDGS
			----------------------------------------------------------------


			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
			imgui.Separator()
			imgui.Bullet()
			imgui.TextUnformatted("Stand automatic search:")
			imgui.TextUnformatted("")
			imgui.SameLine()

			if imgui.Button("Far",50,22) then -- IAS24 added
				approaching_TargetMarker = 0
				stand_found_flag = 0
				automatic_marshaller_requested = true
				automatic_marshaller_capture_position_threshold = 0.0021 -- this value is very important, because we use 0.0021 elsewehre to allow more than 6 parking stands for the user --IAS24
				stand_found_flag = get_airport_intell_Core("standard")
				stand_searched_flag = true
				if show_DockingSystem then show_VDGS = true end
				VDGS_manual = false

				if TargetMarker_instance[0] ~= nil then TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) end --IAS24
				Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular_noticeable.obj" --IAS24
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 17)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Capture the stands around,")
				imgui.PopStyleColor()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
				imgui.TextUnformatted("provided you created the scenery cache.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()

			if imgui.Button("Wide",50,22) then
				approaching_TargetMarker = 0
				stand_found_flag = 0
				automatic_marshaller_requested = true
				automatic_marshaller_capture_position_threshold = 0.0007 -- IAS24 value changed
				stand_found_flag = get_airport_intell_Core("standard")
				stand_searched_flag = true
				if show_DockingSystem then show_VDGS = true end
				VDGS_manual = false
				if TargetMarker_instance[0] ~= nil then TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) end --IAS24
				Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular_noticeable.obj" --IAS24
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Capture the nearest stands,")
				imgui.PopStyleColor()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
				imgui.TextUnformatted("provided you created the scenery cache.")
				imgui.PopStyleColor()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("You need to be on the ramp, near a stand.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			imgui.SetWindowFontScale(0.96)
			if imgui.Button("Narrow",47,22) then
				approaching_TargetMarker = 0
				stand_found_flag = 0
				automatic_marshaller_requested = true
				automatic_marshaller_capture_position_threshold = 0.0003 --IAS24
				stand_found_flag = get_airport_intell_Core("standard")
				stand_searched_flag = true
				if show_DockingSystem then show_VDGS = true end
				VDGS_manual = false
				if TargetMarker_instance[0] ~= nil then TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) end --IAS24
				Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" --IAS24
			end
			imgui.SetWindowFontScale(1)
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Look for the nearest stands, within a narrow range of your aircraft.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end

			if direct_Marshaller and sges_EngineState[0] < 5  then --IAS 24, removed "park == nil"
				-- only for the airrcaft generated on the stand
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
				imgui.SetWindowFontScale(0.96)
				if imgui.Button("Here",45,22) then
					show_VDGS = true
					VDGS_manual = true
					VDGS_chg = true
					approaching_TargetMarker = 0
					stand_found_flag = 0
						automatic_marshaller_requested = true
					automatic_marshaller_capture_position_threshold = 0.0001 --IAS24
					stand_found_flag = get_airport_intell_Core("standard")
					stand_searched_flag = true
					if stand_found_flag > 1 then
						if show_DockingSystem then show_VDGS = true end
						show_StopSign = false --------------------------------------
						StopSign_chg = true
						-- includes some work :
						if p == nil and stand_found_flag > 1 then p = 2 end
						if p == nil then p = 1 end
						park = "Park" .. p
						p = p + 1
						if p > stand_found_flag then p = 1 end -- for user convenience, adjust the number of browsing option to the number of stands found.
						-- (but in reality I didn't cleared the table of eventual previous potiions already found).
						if p > 13 then p = 1 end
						show_StopSign = false
						StopSign_chg = true
						--~ show_VDGS = true
						--~ VDGS_chg = true
						if not VDGS_module_loaded then
							dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_VDGS.lua") -- VDGS module --IAS24 comment update
						end
						load_VDGS()
						direct_Marshaller = false --(close the menu)
					end
					if TargetMarker_instance[0] ~= nil then TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) end --IAS24
					Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" --IAS24
				end
				imgui.SetWindowFontScale(1)
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Select the current stand to display the VDGS.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end

			imgui.Spacing()
			imgui.BeginGroup()
			if park ~= nil then
				imgui.PushStyleColor(imgui.constant.Col.FrameBg,  0xFF00FF09)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF00FF09)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgActive,  0xFF00FF09)
				--imgui.SameLine() --IAS24 comment that out
				if stand_found_flag == 1 then
					imgui.TextUnformatted("") imgui.SameLine()
					imgui.RadioButton(stand_found_flag .. " stand found. ",true) imgui.SameLine() --IAS24
					--imgui.TextUnformatted("    " .. stand_found_flag .. " stand found. ")
				else
					imgui.TextUnformatted("") imgui.SameLine()
					imgui.RadioButton(stand_found_flag .. " stands found. ",true) imgui.SameLine() --IAS24
					--imgui.TextUnformatted("    " .. stand_found_flag .. " stands found. ")
				end
				imgui.SameLine()
				if stand_found_flag > 0 then -- IMPORTANT TO PREVENT XPLANE CRASH !
					if imgui.Button(park,62,22) then
						if p == nil and stand_found_flag > 1 then p = 2 end
						if p == nil then p = 1 end
						park = "Park" .. p
						p = p + 1
						if p > stand_found_flag then p = 1 end -- for user convenience, adjust the number of browsing option to the number of stands found.
						-- (but in reality I didn't cleared the table of eventual previous potiions already found).
						if p > 13 then p = 1 end
						approaching_TargetMarker = 0 -- allow the FM to move
						FM_chg = true
						show_TargetMarker = true
						TargetMarker_chg = true
						show_StopSign = false
						StopSign_chg = true
						automatic_marshaller_requested = true
						-- save the time to reduce the pointing arrow from noticeable to standard after some elapsed time -- IAS24
						SGES_park_designation_flight_time_sec = SGES_total_flight_time_sec
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Browse & select one of the captured stands.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				else
					park = nil
					p = nil
				end
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			elseif stand_found_flag == 0 and stand_searched_flag then
				--imgui.SameLine() --IAS24
				--imgui.TextUnformatted("Too far") --IAS24
				imgui.TextUnformatted("") imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.FrameBg,  0xFF6C6CFF)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF6C6CFF)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgActive,  0xFF6C6CFF)
				imgui.RadioButton("Too far from a stand.",false)
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.Spacing()
			end

			imgui.EndGroup()

			if BeltLoaderFwdPosition >= 15 then BornInf = -60
			elseif BeltLoaderFwdPosition >= 5 then BornInf = -30 else BornInf = -15 end
				--~ imgui.TextUnformatted("")
				--~ imgui.SameLine()



				-- ACTIVATE THE VDGS GUI :
			if (direct_Marshaller or show_FM) and (math.abs(BeltLoaderFwdPosition) > 5 or string.match(PLANE_ICAO,"AT") or string.match(PLANE_ICAO,"B4") or string.match(PLANE_ICAO,"RJ"))  and
			 (stand_found_flag >= 1 or SGES_big_airport) then --IAS24  (removed XP12 condition)
				imgui.TextUnformatted("")
				imgui.SameLine()

				l_changed, l_newval = imgui.Checkbox(" VDGS", show_VDGS)
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 13)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Visual docking guidance system.")
					imgui.Separator()
					imgui.TextUnformatted("Local time or UTC can be set permanently in the options file.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if l_changed then
					show_VDGS = l_newval
					show_VDGS_UTC = not l_newval
					VDGS_chg = true
					if show_VDGS and (direct_Marshaller or show_FM) and not VDGS_module_loaded then
						print("[Ground Equipment " .. version_text_SGES .. "] Will read VDGS sub-script")
						dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_VDGS.lua") -- threat module
					end
					show_StopSign = not l_newval
					StopSign_chg = true
					if not show_VDGS then --IAS24
						VDGS_slider_factor = 0 --IAS24
						if BeltLoaderFwdPosition >= 15 then VDGS_slider_factor = 2 end --IAS24
					end --IAS24
				end

				if show_VDGS then
					imgui.SameLine()
					imgui.TextUnformatted("in")
					imgui.SameLine()
					if VDGS_time ~= nil and VDGS_time == "zulu" then
						if imgui.SmallButton("UTC")  then
							unload_VDGS()
							VDGS_time = "local"
							VDGS_chg = true
						end
					elseif VDGS_time ~= nil then
						if imgui.SmallButton("local")  then
							unload_VDGS()
							VDGS_time = "zulu"
							VDGS_chg = true
						end
					end
				end

			elseif direct_Marshaller or show_FM then --IAS24 (removed XP12 condition)
				imgui.TextUnformatted("")
				imgui.SameLine()
				show_VDGS = false -- important to cancel permanent option where required
				imgui.Checkbox(" VDGS", false)
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 12)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Find a stand first.") --IAS24
					imgui.PopStyleColor()
					imgui.TextUnformatted("Available for airliners.") --IAS24
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end
			imgui.Spacing()  -- IAS24
			imgui.Bullet()
			local changed, newVal = imgui.SliderFloat("Aim", user_targeting_factor, BornInf, 20.000, "Stand (manual aiming)")
				if changed then
					p = nil
					park = nil
					approaching_TargetMarker = 0
					show_TargetMarker = true
					TargetMarker_chg = true
					show_StopSign = false ------------------------------------------------------------------
					StopSign_chg = true
					automatic_marshaller_requested = false

					user_targeting_factor = newVal
					--~ if show_VDGS then unload_VDGS() end
					if show_VDGS then
						VDGS_manual = true
						VDGS_chg = true
					end
					--~ show_VDGS = false -- NO VGDS with manual selection
					if Prefilled_TargetMarkerObject ~=  SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" and TargetMarker_instance[0] ~= nil then --IAS24
						TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker) --IAS24
						Prefilled_TargetMarkerObject =       SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/Arrow_tubular.obj" --IAS24
					end --IAS24
				end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Aim at your intended parking.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end




			if show_VDGS then

				imgui.Bullet()
				if VDGS_slider_factor == nil then
					VDGS_slider_factor = 0 --IAS24
					if BeltLoaderFwdPosition >= 15 then VDGS_slider_factor = 2 end --IAS24
					--IAS 24 WARNING, modify also the subscript !
				end
				local changed, newVal = imgui.SliderFloat("VDGS", VDGS_slider_factor, 0, 9, "VDGS remoteness " .. math.floor(VDGS_slider_factor))
					if changed then
						VDGS_slider_factor = newVal
					end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Change the distance of the VDGS pylon.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end

				--~ imgui.TextUnformatted("VDGS clock in")
				--~ imgui.SameLine()

				--~ if VDGS_time ~= nil and VDGS_time == "zulu" then
					--~ if imgui.SmallButton("UTC")  then
						--~ unload_VDGS()
						--~ VDGS_time = "local"
						--~ VDGS_chg = true
					--~ end
				--~ elseif VDGS_time ~= nil then
					--~ if imgui.SmallButton("local")  then
						--~ unload_VDGS()
						--~ VDGS_time = "zulu"
						--~ VDGS_chg = true
					--~ end
				--~ end
			end

			imgui.Separator()
			imgui.PopStyleColor()
		end
		------------------------------------------------------------------------

		if sges_gs_gnd_spd[0] < 160 then
		  l_changed, l_newval = imgui.Checkbox(" EMS", show_FireVehicle)
		  if l_changed then
			show_FireVehicle = l_newval
			FireVehicle_chg = true
			FVonce = 0

			if automatic_display_EMS_acceptable and SGES_aircraft_has_crashed[0] then automatic_display_EMS_acceptable = false else  automatic_display_EMS_acceptable = true end

			if not show_Watersalute then XP12_Fire_VH() end

			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end
			if show_FireVehicleAhead then
				-- use the truck as an accident site :
				show_Cleaning = l_newval
				Cleaning_chg = true
			end
			if show_FireVehicle == false and show_FireVehicleAhead then
				-- use the truck as an accident site :
				show_Cleaning = false
				Cleaning_chg = true
			end
		  end

		imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFC9C9C9)

		  imgui.SameLine()
		  l_changed, l_newval = imgui.Checkbox(" ahead", show_FireVehicleAhead)

			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Relocate the emergency services on a situation ahead of your aircraft.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			-- change for a civilian and urban fire service :
			if Prefilled_FireObject ~= User_Custom_Prefilled_AlternativeFireObject then
				_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
				_,FireVehicle_instance[2],rampserviceref71b = common_unload("FireVehicle",FireVehicle_instance[2],rampserviceref71b)
				_,FireVehicle_instance[1],rampserviceref71L = common_unload("FireVehicle",FireVehicle_instance[1],rampserviceref71L)
				FireVehicle_chg,FireVehicle_instance[0],rampserviceref71 = common_unload("FireVehicle",FireVehicle_instance[0],rampserviceref71)
				Prefilled_FireObject = User_Custom_Prefilled_AlternativeFireObject
				FireVehicle_chg = true
				FVonce = 0
				load_FireVehicle()
			end
			show_FireVehicleAhead = l_newval
			FireVehicle_chg = true
			if show_FireVehicleAhead then show_Pelicandrome = false end
			if show_FireVehicle then
				-- use the truck as an accident site :
				show_Cleaning = l_newval
				Cleaning_chg = true
			end
		  end
	  end
		if not show_FireVehicleAhead and show_FireVehicle then
			  imgui.SameLine()
			  l_changed, l_newval = imgui.Checkbox(" W/salute", show_Watersalute)
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Water salute.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			  if l_changed then
				show_Watersalute = l_newval
				FireVehicle_chg = true
				if show_Watersalute then show_Pelicandrome = false end
				if not show_Watersalute then load_FireVehicle() end
			  end
			if show_Watersalute and	Prefilled_FireObject ~= User_Custom_Prefilled_WaterSaluteObject then
				-- watersalute object
				_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
				_,FireVehicle_instance[2],rampserviceref71b = common_unload("FireVehicle",FireVehicle_instance[2],rampserviceref71b)
				_,FireVehicle_instance[1],rampserviceref71L = common_unload("FireVehicle",FireVehicle_instance[1],rampserviceref71L)
				FireVehicle_chg,FireVehicle_instance[0],rampserviceref71 = common_unload("FireVehicle",FireVehicle_instance[0],rampserviceref71)
				Prefilled_FireObject = User_Custom_Prefilled_WaterSaluteObject -- ALSO USED AS FLAG EVEN OF XP12 SINCE IN XP12 WE fill directly FireObject not Prefilled_FireObject
				FVonce = 0
				FireVehicle_chg = true
				load_FireVehicle()
			elseif show_Watersalute == false and (Prefilled_FireObject == User_Custom_Prefilled_WaterSaluteObject or Prefilled_FireObject == User_Custom_Prefilled_AlternativeFireObject) then
				-- return to normal fire department vehicle
				_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
				_,FireVehicle_instance[2],rampserviceref71b = common_unload("FireVehicle",FireVehicle_instance[2],rampserviceref71b)
				_,FireVehicle_instance[1],rampserviceref71L = common_unload("FireVehicle",FireVehicle_instance[1],rampserviceref71L)
				FireVehicle_chg,FireVehicle_instance[0],rampserviceref71 = common_unload("FireVehicle",FireVehicle_instance[0],rampserviceref71)
				Prefilled_FireObject = User_Custom_Prefilled_FireObject
				Prefilled_AlternativeFireObject = User_Custom_Prefilled_AlternativeFireObject
				XP12_Fire_VH()
				FVonce = 0
				FireVehicle_chg = true
				load_FireVehicle()
			end
		end
		if show_FireVehicleAhead and show_FireVehicle and not show_Watersalute then
			imgui.SameLine()
			if  imgui.SmallButton("Say")  then
				SayInfoOnTarget()

			end
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Current heading and distance to EMS site when ahead.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if imgui.IsItemActive() and AccidentSite_Distance_nm ~= nil and AccidentSite_OnClock ~= nil then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
				imgui.Separator()
				imgui.TextUnformatted(AccidentSite_OnClock ..  " O'Clock, " .. AccidentSite_Distance_nm .. " nm")
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			elseif imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
				imgui.Separator()
				imgui.TextUnformatted("Click me again !")
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end


	   else
		if math.abs(math.floor(SGES_total_flight_time_sec - time_opening_groundservices_float_wnd)) > 17 then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("Closing the window now.")
			imgui.PopStyleColor()
			imgui.SameLine()
			if imgui.SmallButton("Cancel")  then
				time_opening_groundservices_float_wnd = SGES_total_flight_time_sec + 20
			end
		else
			imgui.TextUnformatted("SERVICES IN FLIGHT ")
		end
		imgui.Separator()
	   end

		if show_Ship1 and show_Ship2 then
			l_changed, l_newval = imgui.Checkbox(" Shipwreck at " .. math.floor((DistanceToShipWreckSite/1915)*1)/1 .. " nm", show_Ship1)
		else
			if show_Chocks and show_FireSmoke and show_FireVehicle and outsideAirTemp >= temperature_below_which_we_display_the_active_deicing_service + 10 then
				l_changed, l_newval = imgui.Checkbox(" Wreck", show_Ship1)
			else
				l_changed, l_newval = imgui.Checkbox(" Shipwreck", show_Ship1)
			end
		end
		if l_changed then
		if IsXPlane12 then
			math.randomseed(os.time())
			randomView = math.random()
			if randomView > 0.75 then
				Prefilled_LargeShipObject = Prefilled_XP12_LargeShip_1
			elseif randomView > 0.50 then
				Prefilled_LargeShipObject = Prefilled_XP12_LargeShip_2
			elseif randomView > 0.25 then
				Prefilled_LargeShipObject = Prefilled_XP12_LargeShip_3
			elseif randomView > 0.20 then
				Prefilled_LargeShipObject = User_Custom_Prefilled_SubmarineObject
			else
				Prefilled_LargeShipObject = Prefilled_XP12_LargeShip_4
			end
		end
			if l_newval then
				DistanceToShipWreckSite = DistanceToShipWreckSite * 2.5
				if DistanceToShipWreckSite > 17 * DistanceToShipWreckSite_initial then DistanceToShipWreckSite = DistanceToShipWreckSite_initial end
			end
			show_Ship1 = l_newval
			Ship1_chg = true
			show_Ship2 = l_newval
			Ship2_chg = true
		end
		if imgui.IsItemActive() then
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("A ship accident site at sea, located ahead.")
			imgui.TextUnformatted("Cycle to cyle the distance.")
			imgui.PopStyleColor()
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end

	   if sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then

		if outsideAirTemp > temperature_below_which_we_display_the_active_deicing_service then
		  imgui.SameLine()
		  --~ if IsXPlane12 then
			  --~ l_changed, l_newval = imgui.Checkbox(" Wildfire", show_FireSmoke)
		  --~ else
			  l_changed, l_newval = imgui.Checkbox(" Fire", show_FireSmoke)
		  --~ end
		  if l_changed then
			show_FireSmoke = l_newval
			FireSmoke_chg = true


			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end
		  end
			 -- imgui.TextUnformatted("(d=" .. DistanceToCrashSite .. ")")
			if show_FireSmoke or show_FireVehicleAhead then
				imgui.SameLine()
				if imgui.SmallButton(math.floor((DistanceToCrashSite/1915)*10)/10 .. " nm") then
					DistanceToCrashSite = DistanceToCrashSite + 1915
					if DistanceToCrashSite > 15000 then DistanceToCrashSite = 1000 end
					FireSmoke_chg = true
					FireVehicle_chg = true
					Cleaning_chg = true
				end
				if imgui.IsItemHovered() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Distance of the fire/smoke, and of the EMS when located ahead of the aircraft.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end


			if show_Chocks and not show_Ship1 and show_FireVehicle and outsideAirTemp >= temperature_below_which_we_display_the_active_deicing_service + 10 then
				imgui.SameLine()
				l_changed, l_newval = imgui.Checkbox(" Pel", show_Pelicandrome)
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Pelicandrome. Ground configuration to refill ground-based fire-fighting aircraft.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if l_changed then
					show_Pelicandrome = l_newval
					if show_Pelicandrome then
						show_Watersalute = false
						show_FireVehicleAhead = false
						show_ASU = false
						show_Bus = false
						Bus_chg = true
						ASU_chg = true
					end
					FireVehicle_chg = true
					if show_Pelicandrome then
						load_FireVehicle()
					end
				end
			elseif show_Pelicandrome then
				show_Pelicandrome = false
			end

			if show_Pelicandrome and get("sim/aircraft/weight/acf_m_jettison") > 0 then
				imgui.Bullet()
				local changed, newVal = imgui.SliderFloat("kg JL", get("sim/flightmodel/weight/m_jettison"), 0, get("sim/aircraft/weight/acf_m_jettison"), "Jett. load " .. math.floor(get("sim/flightmodel/weight/m_jettison")) .. "/" .. math.floor(get("sim/aircraft/weight/acf_m_jettison")))
					if changed then
						set("sim/flightmodel/weight/m_jettison",newVal)
					end
			end



		elseif sges_gs_ias_spd[0] < 40 then --IAS24
			l_changed, l_newval = imgui.Checkbox(" Active deicing", show_Deice)
			if l_changed then
				show_Deice = l_newval
				Deice_chg = true
				if not IsXPlane12 then
					if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
				end
				if IsXPlane12 then
					set("sim/cockpit2/ice/ice_deice_holdover_time_left_minutes",Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand/60)
				else
					starting_deice_time = math.floor(os.clock())
				end
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Aircraft shall be protected from ice for " .. math.abs(Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand/60) .. " minutes.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

		imgui.PopStyleColor()
	   end
		imgui.TextUnformatted("")
	if sges_gs_ias_spd[0] < 200 then --IAS24
		if show_Automatic_sequence_start then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			if SGES_gui_sequence_chronology ~= nil then
				--~ imgui.SameLine() imgui.TextUnformatted("NOW: AUTOMATIC SEQUENCE (" .. math.floor((SGES_gui_sequence_chronology + SGES_Automatic_sequence_start_flight_time_sec/60) - (SGES_total_flight_time_sec/60) +0.5) .. " min)")

				--~ imgui.SameLine() imgui.TextUnformatted("NOW: AUTOMATIC SEQUENCE (" .. math.floor((SGES_total_flight_time_sec-SGES_Automatic_sequence_start_flight_time_sec)/6)/10 .. " min)")
				imgui.SameLine() imgui.TextUnformatted("IN AUTOMATIC SEQUENCE (" .. math.floor((SGES_total_flight_time_sec-SGES_Automatic_sequence_start_flight_time_sec)/60) .. " min)")

			else
				imgui.SameLine() imgui.TextUnformatted("CURRENTLY: AUTOMATIC SEQUENCE")
			end
			imgui.PopStyleColor()
		end


		if PLANE_ICAO == "CL60"  and string.find(PLANE_AUTHOR,"Hot") then
			imgui.SameLine()
			if not show_Automatic_sequence_start then
				if imgui.SmallButton("Status")  then
					command_once("CL650/fbo/debug/tog_status_window")
				end
			else
				if imgui.SmallButton("Sta")  then
					command_once("CL650/fbo/debug/tog_status_window")
				end
			end
		end

		if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			if sges_zibodoorhandling1 ~= nil and sges_zibodoorhandling2 ~= nil then
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				if sges_zibodoorhandling1[1] == 0 or sges_zibodoorhandling2[1] == 0 then
					if not show_Automatic_sequence_start then imgui.SameLine() end
					--~ imgui.TextUnformatted(" Built-in services ON in ZIBO EFB")
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
					imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
					--~ imgui.SetWindowFontScale(0.9)
					if imgui.Button("ZIBO built-in services are ON !",230,15) then
						ZIBOToggleServicesOption()
					end
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Click to suppress the ZIBO / LevelUp built-in ground services to favor SGES services.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					--~ imgui.SetWindowFontScale(1)
					imgui.PopStyleColor(2)
				end
				imgui.PopStyleColor()
			end
		end



		if not read_the_SGES_startup_options_delayed_elapsed then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			local rebours = math.floor((SGES_start_time + rebours_delay * SGES_start_delay) - (os.clock() - 3 ))
			if rebours > 0 then
				imgui.SameLine() imgui.TextUnformatted( rebours  .. " :")
				imgui.SameLine()
				--imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
				if  imgui.SmallButton("APPLYING THE USER OPTIONS")  then
					rebours_delay = 0
				end
				if imgui.IsItemHovered() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Expedite the load of user options.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				--imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				imgui.SameLine() imgui.TextUnformatted("0 : APPLYING THE USER OPTIONS")
			end
			imgui.PopStyleColor()
		end



		imgui.Columns(2)

	  if PLANE_ICAO == "ALIA" or  AIRCRAFT_FILENAME == "AW109SP.acf" then
		l_changed, l_newval = imgui.Checkbox(" Active GPU", show_GPU)
		if show_GPU then
			imgui.NextColumn()
			imgui.TextUnformatted("(charging batt.)")
		end
	  elseif PLANE_ICAO == "412" or string.match(PLANE_ICAO,"CRJ") or PLANE_ICAO == "ALIA" or PLANE_ICAO == "B738" or IsToLiSs or PLANE_ICAO == "PC12" or PLANE_ICAO == "KODI" then
		l_changed, l_newval = imgui.Checkbox(" GPU", show_GPU)
	  elseif (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) then
		l_changed, l_newval = imgui.Checkbox(" BAe-146 GPU", show_GPU)
	  elseif (PLANE_ICAO == "E190" or PLANE_ICAO == "E19L" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and string.match(SGES_Author,"Marko") then
		l_changed, l_newval = imgui.Checkbox(" X-Crafts GPU", show_GPU)
	  elseif (PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA") then
		l_changed, l_newval = imgui.Checkbox(" EPU / ASU", show_GPU)
	  elseif string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh") then --LevelUp series
		l_changed, l_newval = imgui.Checkbox(" GPU", show_GPU)
	  elseif PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis")  then
		l_changed, l_newval = imgui.Checkbox(" GPU", show_GPU)
		--~ imgui.TextUnformatted(" GPU")
		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
		if  imgui.Button("ON",25,18)  then -- Felis 742 command menu
			--~ command_once("B742/menu/showHide2D_EFB")
			--~ command_once("B742/command/connect_gpu")
			--~ command_once("B742/command/toggle_gpu")
			set("B742/INT_PA/connect_gpu",1)
		end
		imgui.SameLine()
		if  imgui.Button("OFF",25,18)  then -- Felis 742 command menu
			--~ command_once("B742/menu/showHide2D_EFB")
			--~ command_once("B742/command/connect_gpu")
			--~ command_once("B742/command/toggle_gpu")
			set("B742/INT_PA/connect_gpu",0)
		end
		imgui.PopStyleColor(2)
	  else
		l_changed, l_newval = imgui.Checkbox(" GPU (visual)", show_GPU)
	  end
	  if l_changed then
		if PLANE_ICAO == string.match(PLANE_ICAO,"CRJ") then command_once("crj700/tablet/menu/settings/hot_external_power_command")
		else
			show_GPU = l_newval
			GPU_chg = true
			if PLANE_ICAO ~= "F104" then -- the F104 should be charged, its starting only with an external power unit
			--if PLANE_ICAO == "ALIA" then -- commented out : nice to have for any aircraft
				--~ if IsXPlane1221 then
					--~ if show_GPU then set("sim/operation/override/override_GPU_volts",1) --https://developer.x-plane.com/article/ground-power-in-x-plane-12-0-8/
					--~ else set("sim/operation/override/override_GPU_volts",0) end
						command_once("sim/electrical/recharge")
				--~ end
			--end
			end



			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end
		end
		if show_GPU  and IsToLiSs then -- add ToLiss GPU
			set("AirbusFBW/EnableExternalPower",1)
		elseif  IsToLiSs then -- remove ToLiss GPU
			set("AirbusFBW/EnableExternalPower",0)
		end
		if show_GPU and PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104
			set("Colimata/F104_A_SW_GROUND_gpu_i",1)
		elseif 			   PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104
			set("Colimata/F104_A_SW_GROUND_gpu_i",0)
		end


		if show_GPU and not show_ASU and IsToLiSs then -- add ToLiss GPU
			show_ASU =  true -- also prepare the Low pressure and High pressure object depiction, but then their appearance is 3D animation driven.
			ASU_chg = true
		elseif show_ASU == true and IsToLiSs then -- remove ToLiss GPU
			show_ASU =  false -- couple the GPU removal with the ASU+ACU object removal (ease of use)
			ASU_chg = true
		end

			if XPLMFindDataRef("thranda/electrical/ExtPwrGPUAvailable") ~= nil and show_GPU then -- toggle Thranda GPU
				set("thranda/electrical/ExtPwrGPUAvailable",1)
			elseif XPLMFindDataRef("thranda/electrical/ExtPwrGPUAvailable") ~= nil  then
				set("thranda/electrical/ExtPwrGPUAvailable",0)
			end


	  end
	  if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			--~ imgui.SetWindowFontScale(0.9)
			if imgui.Button("GPU",50,20) then
				ZIBOToggleGPU()
			end
			--~ imgui.SetWindowFontScale(1)
			imgui.PopStyleColor(2)
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("ZIBO or LevelUp Ground Power Unit")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end


	  if show_ASU or (IsToLiSs == false and SGES_BushMode == false and PLANE_ICAO ~= "F104" and math.abs(BeltLoaderFwdPosition) > 4) then
			imgui.NextColumn()
		  --~ imgui.SameLine()
		  l_changed, l_newval = imgui.Checkbox(" ASU", show_ASU)
		  if l_changed then
			show_ASU = l_newval
			ASU_chg = true

			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end
		  end
		if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			if imgui.Button("ASU",40,20) then
				ZIBOToggleASU()
			end
			imgui.PopStyleColor(2)
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("ZIBO or LevelUp Air Start Unit")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end
	  end

		if PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis")  then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			if  imgui.Button("ACU",38,18)  then -- Felis 742 command menu
				if show_ASU then
					set("B742/anim/ACU_called",1)
				else
					set("B742/anim/ACU_called",0)
				end
			end
			imgui.PopStyleColor(2)
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Felis B742 Air Conditionning Unit.\nIf SGES Air Start Unit is already present, this will request the Felis ACU, in the contrary a request for removal will be sent.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

		if string.match(AircraftPath ,"146") and XPLMFindDataRef("thranda/electrical/ExtPwrGPUAvailable") ~= nil then -- check is Thranda plugin is loaded and running
			imgui.SameLine()
			if  imgui.Button("Ladder",50,20)  then
				if ladder_state ~= 2 and (not show_Stairs and not show_StairsH and not show_StairsXPJ) then set_array("thranda/cockpit/animations/doormanip",2,1) ladder_state = 2
				else
					set_array("thranda/cockpit/animations/doormanip",2,0) ladder_state = 0
				end
			end
		end

		imgui.Columns(1)

	  if PLANE_ICAO ~= "ALIA" then -- ALIA doesn't require petroleum derivatives directly
		if SGES_BushMode and IsXPlane12 and military == 0 and military_default == 0 then
		  l_changed, l_newval = imgui.Checkbox(" Small fuel", show_FUEL)
		elseif  Prefilled_FuelObject == XPlane12_ford_carrier_accessories_directory .. "SH60_Seahawk_animated.obj" then
		  l_changed, l_newval = imgui.Checkbox(" Fuel (air delivery)", show_FUEL)
		else
		  l_changed, l_newval = imgui.Checkbox(" Fuel", show_FUEL)
		end
		  if l_changed then
			show_FUEL = l_newval
			FUEL_chg = true


			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end

		  end

		if show_Chocks and PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then
			imgui.SameLine()
			l_changed, l_newval = imgui.Checkbox(" F-104 Tanker", show_ColimataFUEL)
		  if l_changed then
			show_ColimataFUEL = l_newval
			if l_newval then
				set("Colimata/F104_A_SW_GROUND_tanker_i",1)
				show_People2 = false
				People2_chg = true
				show_People4 = false
				People4_chg = true
			else
				set("Colimata/F104_A_SW_GROUND_tanker_i",0)
				if show_People1 then
					show_People2 = true
					People2_chg = true
					show_People4 = true
					People4_chg = true
				end
			end
		  end
		end
		if sges_ahr == 1 and show_AAR then
				imgui.SameLine()
				l_changed, l_newval = imgui.Checkbox(" AAR", show_AAR)
				if l_changed then
					show_AAR = l_newval
					AAR_chg = true
				end
		end
		if (not show_AAR and sges_big_airport and math.abs(BeltLoaderFwdPosition) > 4.5 and IsXPlane12) or show_Pump then

			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
			--~ imgui.SameLine()
			--~ imgui.TextUnformatted("/")
			imgui.SameLine()
			l_changed, l_newval = imgui.Checkbox(" Is a dispenser", show_Pump)
			if l_changed then
				show_Pump = l_newval
			end
			imgui.PopStyleColor()
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("The fuel truck is an hydrant dispenser in this case. Fuel hydrant is a pressurized fuel supply point.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

		if show_FUEL and fuel_currentX ~= nil and fuel_currentY ~= nil and fuel_finalX ~= nil and fuel_finalY ~= nil and show_Chocks and not IsToLiSs then

			if fuel_currentX < fuel_finalX and fuel_currentY < fuel_finalY then
				-- nothing, the fuel truck is not in place at the moment, arriving.
			else
				imgui.SameLine()
				--~ if active_fueling_is_possible == nil then active_fueling_is_possible = false end
				--~ l_changed, active_fueling_is_possible = imgui.Checkbox(" Replenish", active_fueling_is_possible)
				if imgui.SmallButton("R!") then
					active_fueling_is_possible = true
					aircraft_refueling_in_SGES()
				end
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Replenishing")
					if sges_max_tanks ~= nil and sges_max_tanks > 0 then
						if sges_tank_all ~= nil then imgui.TextUnformatted("Cur : " .. math.floor(sges_tank_all) .. " kg") end
						imgui.TextUnformatted("Max : " .. math.floor(sges_max_tanks) .. " kg")
					end
					imgui.PopStyleColor()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 12)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)
					imgui.TextUnformatted("Custom systems shall not be compatible, use at your own risk")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
					active_fueling_is_possible = true
					aircraft_refueling_in_SGES()
				elseif sges_tank_all ~= nil and imgui.IsItemHovered() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted(" ")
					imgui.TextUnformatted("Cur : " .. math.floor(sges_tank_all) .. " kg")
					imgui.PopStyleColor()
					imgui.EndTooltip()
				end
			end
		end

	  else
		if SGES_ELEC[2] == 1 then show_ELEC = true else show_ELEC = false end
		  l_changed, l_newval = imgui.Checkbox(" Toggle ALL batteries ON.", show_ELEC)
		  if l_changed then
				show_ELEC = l_newval
				ELEC_chg = true
				command_once("sim/electrical/batteries_toggle")
				command_once("sim/electrical/battery_1_toggle")
		end
	  end

		if SGES_BushMode and IsXPlane12 and (military == 1 or military_default == 1) then
			l_changed, l_newval = imgui.Checkbox(" Car", show_Cleaning)
		elseif SGES_BushMode and IsXPlane12 then
			l_changed, l_newval = imgui.Checkbox(" Table & sunshade", show_Cleaning)
		else
			l_changed, l_newval = imgui.Checkbox(" Cleaning van", show_Cleaning)
		end

	  if l_changed then
		show_Cleaning = l_newval
		Cleaning_chg = true
		--show_Light = l_newval
		--Light_chg = true
	  end


	  if BeltLoaderFwdPosition > 2 then
		  if PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" and military_default == 1 then
				 l_changed, l_newval = imgui.Checkbox(" E-4 stairs", show_BeltLoader)
		  elseif BeltLoaderFwdPosition >= ULDthresholdx and PLANE_ICAO ~= "MD88" then l_changed, l_newval = imgui.Checkbox(" Loader", show_BeltLoader)
		  elseif PLANE_ICAO == "A321" and IsPassengerPlane == 0 then l_changed, l_newval = imgui.Checkbox(" LD Loader", show_BeltLoader)
		  elseif PLANE_ICAO == "A21N" and IsPassengerPlane == 0 then l_changed, l_newval = imgui.Checkbox(" LD Loader", show_BeltLoader)
		   elseif (PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") and User_prefers_containerized_freight then l_changed, l_newval = imgui.Checkbox(" LD Loader", show_BeltLoader)
		  else l_changed, l_newval = imgui.Checkbox(" Loader", show_BeltLoader) imgui.SameLine()
		    if  imgui.SmallButton("+")  then
				if adjust_BeltLoader == false then
					adjust_BeltLoader = true
				else
					adjust_BeltLoader = false
				end
			end
			imgui.SameLine()
			--~ imgui.TextUnformatted(" ")
			--~ imgui.SameLine()
		  end
		  if l_changed then
			show_BeltLoader = l_newval
			BeltLoader_chg = true
			-- don't show for the Beluga
			if PLANE_ICAO == "A3ST" then show_BeltLoader = false end
			show_Cart = l_newval
			Cart_chg = true
			-- also link the rear bealot loader when defined in the aircraft set, or on removal always
			if BeltLoaderRearPosition ~= nil or l_newval == false then
				show_RearBeltLoader = l_newval
				RearBeltLoader_chg = true
			end
			if l_newval == false then
				show_Baggage = l_newval
				Baggage_chg = true
			end
		  end
		  imgui.SameLine()
		  -- but user can also manually unlink it :
		  l_changed, l_newval = imgui.Checkbox(" Cart", show_Cart)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Luggage train.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			show_Cart = l_newval
			Cart_chg = true

			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end

		  end

		  if show_RearBeltLoader or BeltLoaderFwdPosition > 6 then
			if PLANE_ICAO ~= "D328" and PLANE_ICAO ~= "SF34" and not string.match(PLANE_ICAO,"CRJ") and not string.match(PLANE_ICAO,"DH8A") and not (string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) and PLANE_ICAO ~= "DH8D" and PLANE_ICAO ~= "DH8C" and PLANE_ICAO ~= "QX" and  PLANE_ICAO ~= "AMF" and PLANE_ICAO ~= "GLF650ER" and not plane_has_cargo_hold_on_the_left_hand_side then
				  imgui.SameLine()
				  l_changed, l_newval = imgui.Checkbox(" Rear", show_RearBeltLoader)
				if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				if BeltLoaderRearPosition == nil then
					imgui.TextUnformatted("A rear loader in the vicinity of the fuselage (but not in direct contact to it : BeltLoaderRearPosition not set in the config).")
				else
					imgui.TextUnformatted("A rear loader (defined by BeltLoaderRearPosition in the config.).")
				end
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
				  if l_changed then
					show_RearBeltLoader = l_newval
					RearBeltLoader_chg = true
				  end
			 end
		   end
	  --elseif math.abs(BeltLoaderFwdPosition) >= 4.9 and dataref_to_open_the_door ~= nil then -- allow at least the luggage cart to show
			-- the |4.9| value allows the cart on some BAe-146 variants (-200)
			-- checking dataref_to_open_the_door ensures my offer of the cart is limited to airliners that I know in X-Plane
			-- and is practical to avoid the offer on General Aviation aircraft

	  -- finally I prefer it to limit it manually to the Avro RJs :
	  elseif string.match(PLANE_ICAO,"B46") or string.match(PLANE_ICAO,"RJ") then
			l_changed, l_newval = imgui.Checkbox(" Baggages cart", show_Cart)
		  if l_changed then
			show_Cart = l_newval
			Cart_chg = true



			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end

		  end
	  elseif wetness == 1 then
			imgui.SameLine() --IAS24 , avoid jumping GUI
			l_changed, l_newval = imgui.Checkbox(" Canoe", show_Cart)
		  if l_changed then
			show_Cart = l_newval
			Cart_chg = true
		  end
	  elseif show_Cart then
			l_changed, l_newval = imgui.Checkbox(" Cart (as available)", show_Cart)
		  if l_changed then
			show_Cart = l_newval
			Cart_chg = true
		  end
	  end

	-- manual slider ajustment of the front beltloader
	if adjust_BeltLoader then
		imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
		local changed, newVal4 = imgui.SliderFloat("D", distance_to_fuselage, -5, 2, "Distance " .. math.floor(distance_to_fuselage*100)/100)
		if changed then
			distance_to_fuselage = newVal4
			--l_changed = true
			BeltLoader_chg = true
			RearBeltLoader_chg = true
			if distance_to_fuselage < -1 then
				show_Cart = false
				Cart_chg = true
				show_Baggage = false
				Baggage_chg = true
			end
		end
		imgui.SameLine()
		if  imgui.Button("Reset D",44,20)  then
			distance_to_fuselage = 0
			--l_changed = true
			BeltLoader_chg = true
			RearBeltLoader_chg = true
		end
		imgui.PopStyleColor()
	end

	if SGES_BushMode and IsXPlane12 then
	  l_changed, l_newval = imgui.Checkbox(" Forklift", show_Forklift)
	  if l_changed then
		show_Forklift = l_newval
		Forklift_chg = true
	  end
	elseif IsPassengerPlane == 0 or show_ULDLoader or show_Forklift then
	  l_changed, l_newval = imgui.Checkbox(" ULD Loader", show_ULDLoader)
	  if l_changed then
		show_ULDLoader = l_newval
		ULDLoader_chg = true
	  end


	  if show_ULDLoader then
		if adjust_ULDLoader == nil then adjust_ULDLoader = false end
		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
		if  imgui.SmallButton("ù")  then
			if adjust_ULDLoader == false then
				adjust_ULDLoader = true
			else
				adjust_ULDLoader = false
			end
		end
		if imgui.IsItemActive() then
			-- Click & hold tooltip
			imgui.BeginTooltip()
			-- This function configures the wrapping inside the toolbox and thereby its width
			imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("Adjust the cargo loader.")
			imgui.PopStyleColor()
			-- Reset the wrapping, this must always be done if you used PushTextWrapPos
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
		imgui.PopStyleColor()


	  if math.abs(BeltLoaderFwdPosition) > 4 then
		  imgui.SameLine()
		  l_changed, l_newval = imgui.Checkbox(" Forklift", show_Forklift)
		  if l_changed then
			show_Forklift = l_newval
			Forklift_chg = true
		  end
	  end

		if show_ULDLoader and adjust_ULDLoader then



			imgui.Separator()
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
			local changed, newVal1 = imgui.SliderFloat("X Loader", lateral_factor_ULDLoader, -1, 1, "Lateral " .. math.floor(lateral_factor_ULDLoader*10)/10)
			if changed then
				lateral_factor_ULDLoader = newVal1
				ULDLoader_chg = true
				CargoULD_chg = true
			end
			local changed, newVal2 = imgui.SliderFloat("Z Loader", longitudinal_factor3_ULDLoader, -5, 5, "Longitudinal " .. math.floor(longitudinal_factor3_ULDLoader*10)/10)
			if changed then
				longitudinal_factor3_ULDLoader = newVal2
				ULDLoader_chg = true
				CargoULD_chg = true
			end
			if imgui.Button("Long. -0.1",79,17) then
				longitudinal_factor3_ULDLoader = longitudinal_factor3_ULDLoader - 0.1
				ULDLoader_chg = true
				CargoULD_chg = true
			end
			imgui.SameLine()
			if imgui.Button("Long. +0.1",79,17) then
				longitudinal_factor3_ULDLoader = longitudinal_factor3_ULDLoader + 0.1
				ULDLoader_chg = true
				CargoULD_chg = true
			end
			imgui.PopStyleColor()
			imgui.Separator()


		  if show_CargoULD then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
				  l_changed, l_newval = imgui.Checkbox(" Keep displaying the ULD", show_CargoULD)
				  if l_changed then
					show_CargoULD = l_newval
					CargoULD_chg = true
				  end

					imgui.PopStyleColor()
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Removes the ULD currently loading on the main deck.")
					imgui.TextUnformatted("You can otherwise immobilize it by removing the ULD train, and make it reappear by recalling the ULD train.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
		   end


		end



	  end
	end



	--[[
	  l_changed, l_newval = imgui.Checkbox(" Stairs Mark I ", show_Stairs) -- deprecated
	  if l_changed then
		show_Stairs = l_newval
		Stairs_chg = true
		show_StairsXPJ = false
		StairsXPJ_chg = true
		show_StairsH = false
		StairsH_chg = true
	  end
	  ]]

	  if (BeltLoaderFwdPosition > 3 or string.match(AIRCRAFT_PATH,"146")) and not string.match(PLANE_ICAO,"CRJ") and not (string.match(PLANE_ICAO,"E14") or string.match(PLANE_ICAO,"E13")) then
		  --imgui.SameLine()
		  if show_auto_stairs then
			  imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF999999)
			  l_changed, l_newval = imgui.Checkbox(" Stairs Mk III", show_StairsXPJ)
			  imgui.PopStyleColor()
				if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Currently controlled by the 1L door. (Auto stairs).")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  else

			if SGES_stairs_type ~= "Boarding_without_stairs" then
				l_changed, l_newval = imgui.Checkbox(" Stairs Mk III", show_StairsXPJ)
			else

				if not SGES_BushMode and Transporting_Jetsetpeople ~= nil and Transporting_Jetsetpeople and show_Cones then
					if (LATITUDE > 36 and LATITUDE < 55) and (LONGITUDE > -5 and LONGITUDE < 19) or (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69)  then
						if show_StairsXPJ then
							l_changed, l_newval = imgui.Checkbox(" Board directly", show_StairsXPJ)
						else
							l_changed, l_newval = imgui.Checkbox(" Board directly (red carpet)", show_StairsXPJ)
						end
					else
						l_changed, l_newval = imgui.Checkbox(" Board directly", show_StairsXPJ)
					end
				else
					l_changed, l_newval = imgui.Checkbox(" Board directly", show_StairsXPJ)
				end

				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Will allow passengers boarding without airport stairs. Please adjust the door coordinates.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end
		  end

		  if show_StairsXPJ  then -- Warn
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
		    if  imgui.SmallButton("*")  then
				if adjust_StairsXPJ == false then
					adjust_StairsXPJ = true
				else
					adjust_StairsXPJ = false
				end
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Adjust the door coordinates.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.PopStyleColor()
			-- Protect as required the aircraft by moving airstairs far away enough :
			if SGES_stairs_type ~= "Boarding_without_stairs" and (not show_Pax or protect_StairsXPJ) then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				if  imgui.SmallButton("P")  then
					if protect_StairsXPJ == false then
						protect_StairsXPJ = true
						-- and close the door as required in ZSAR :
						if PaxDoor1L ~= nil 		and PaxDoor1L == target_to_open_the_door 		then PaxDoor1L = target_to_open_the_door-1				end
						if PaxDoorRearLeft ~= nil 	and PaxDoorRearLeft == target_to_open_the_door 	then	PaxDoorRearLeft = target_to_open_the_door-1 	end
						show_Pax = false
						show_Bus = false
						Pax_chg = true
						Bus_chg = true
					else
						protect_StairsXPJ = false
					end
					StairsXPJ_chg 	= true
					StairsXPJ2_chg 	= true
					--~ StairsXPJ3_chg	= true
				end
				if protect_StairsXPJ then
					imgui.SameLine() imgui.TextUnformatted("Protected")
				end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Protect the aircraft.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.PopStyleColor()
			end

			if show_StairsXPJ and show_StairsXPJ2 == false and show_Pax then
				imgui.SameLine()
				if walking_direction == "boarding" then
					imgui.TextUnformatted("(Boarding)")
				else
					imgui.TextUnformatted("(Deboarding)")
				end
			end
			if adjust_StairsXPJ then
				imgui.Separator()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
				Adjust_Alternate_Passenger_Attachement_Point_via_sliders()
				imgui.PopStyleColor()
				imgui.Separator()
			end
		  end



		  if l_changed then
			show_StairsH = false
			StairsH_chg = true
			show_Stairs = false
			Stairs_chg = true
			show_StairsXPJ = l_newval
			StairsXPJ_chg = true
			option_StairsXPJ_override = l_newval -- once action, absolutely required
			if show_StairsXPJ2 and show_StairsXPJ then
				DualBoard = true
			else
				DualBoard = false
				if PaxDoor1L~= nil then PaxDoor1L = target_to_open_the_door-1 end
			end
			--also stops or remove the passengers if there is no stairs :
			if show_StairsXPJ == false and show_StairsXPJ2 == false and show_Pax then
				show_Pax = l_newval
				Pax_chg = true
				if show_Pax then 	initial_pax_start = true		 end
			end
			if show_StairsXPJ == false and show_StairsXPJ2 == true then
				BoardStairsXPJ2 = true
				BoardStairsXPJ = false
				StairFinalY = StairFinalY_stairIV
				StairFinalH = StairFinalH_stairIV
				StairFinalX = StairFinalX_stairIV
				InitialPaxHeight = InitialPaxHeight_stairIV
				-- was missing december 2022 :
				StairHigherPartX = StairHigherPartX_stairIV
			end

			-- With BAe-146 ladder deplyed, display sthe stairs away form the fuselage :
			if (string.match(PLANE_AUTHOR,"Thranda") and string.match(AIRCRAFT_PATH,"146")) then
				if ladder_state ~= nil and ladder_state == 2 then
					protect_StairsXPJ = true
				end
			end

		  end

		else


			if SGES_stairs_type ~= "Boarding_without_stairs" then
				if SGES_BushMode and IsXPlane12 and (military == 1 or military_default == 1) then
					l_changed, l_newval = imgui.Checkbox(" Mobile crane", show_Stairs)
				elseif SGES_BushMode and IsXPlane12 then
					l_changed, l_newval = imgui.Checkbox(" Inspection ladder", show_Stairs)
				else
					l_changed, l_newval = imgui.Checkbox(" Stairs Mark I", show_Stairs)
				end
			  if l_changed then
				show_Stairs = l_newval
				Stairs_chg = true
				show_StairsXPJ = false
				StairsXPJ_chg = true
				show_StairsH = false
				StairsH_chg = true
			  end
				if show_Stairs then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					if  imgui.SmallButton("*")  then
						if adjust_StairsXPJ == false then
							adjust_StairsXPJ = true
						else
							adjust_StairsXPJ = false
						end
					end
					imgui.PopStyleColor()
				end
			else


				--~ if show_StairsXPJ and not show_Stairs then
					--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
					--~ -- hides the option a little because it is mutually exclusice with the directo boarding without stairs
				--~ end
				l_changed, l_newval = imgui.Checkbox(" Stairs Mark I", show_Stairs)
				if l_changed then
					show_Stairs = l_newval
					Stairs_chg = true
					show_StairsXPJ = false
					StairsXPJ_chg = true
					show_StairsXPJ2 = false
					StairsXPJ2_chg = true
					show_StairsH = false
					StairsH_chg = true
				end

				--~ if show_StairsXPJ then
					--~ imgui.PopStyleColor()
				--~ end
				if show_Stairs then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					if  imgui.SmallButton("*")  then
						if adjust_StairsXPJ == false then
							adjust_StairsXPJ = true
						else
							adjust_StairsXPJ = false
						end
					end
					imgui.PopStyleColor()
				end

				--~ if show_Stairs and not show_StairsXPJ then
					--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
					--~ -- hides the option a little because it is mutually exclusice with the Stairs Mark I
				--~ end
				if show_StairsXPJ then
					if not SGES_BushMode and Transporting_Jetsetpeople ~= nil and Transporting_Jetsetpeople and show_Cones then
						if (LATITUDE > 36 and LATITUDE < 55) and (LONGITUDE > -5 and LONGITUDE < 19) or (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69)  then
							l_changed, l_newval = imgui.Checkbox(" Board directly (red carpet)", show_StairsXPJ)
						else
							l_changed, l_newval = imgui.Checkbox(" Board directly", show_StairsXPJ)
						end
					else
						l_changed, l_newval = imgui.Checkbox(" Board directly", show_StairsXPJ)
					end
				else
					l_changed, l_newval = imgui.Checkbox(" Direct boarding", show_StairsXPJ)
				end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Board or deboard without stair.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if l_changed then
					show_Stairs = false
					Stairs_chg = true
					show_StairsXPJ = l_newval
					StairsXPJ_chg = true
					show_StairsXPJ2 = false
					StairsXPJ2_chg = true
					show_StairsH = false
					StairsH_chg = true
				end
				--~ if show_Stairs then
					--~ imgui.PopStyleColor()
				--~ end
			end



		  if show_Stairs or (show_StairsXPJ and SGES_stairs_type == "Boarding_without_stairs") then -- Warn
			if not show_Stairs then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				if  imgui.SmallButton("*")  then
					if adjust_StairsXPJ == false then
						adjust_StairsXPJ = true
					else
						adjust_StairsXPJ = false
					end
				end
				imgui.PopStyleColor()
			end
		  end

			------------------------- intercalation starts
			if show_StairsXPJ and show_StairsXPJ2 then
				--~ imgui.SameLine()
				--~ if walking_direction == "boarding" then
					--~ l_changed, l_newval = imgui.Checkbox(" Board", BoardStairsXPJ)
				--~ else
					--~ l_changed, l_newval = imgui.Checkbox(" Deboard", BoardStairsXPJ)
				--~ end
				--~ if l_changed and BoardStairsXPJ2 then
					--~ BoardStairsXPJ = true
					--~ BoardStairsXPJ2 = false
					--~ StairFinalY = StairFinalY_stairIII
					--~ StairFinalH = StairFinalH_stairIII
					--~ StairFinalX = StairFinalX_stairIII
					--~ InitialPaxHeight = InitialPaxHeight_stairIII
					--~ StairHigherPartX = StairHigherPartX_stairIII
				--~ end
			elseif show_StairsXPJ and show_StairsXPJ2 == false and show_Pax then
				imgui.SameLine()

				if walking_direction == "boarding" then
					imgui.TextUnformatted("(Boarding)")
				else
					imgui.TextUnformatted("(Deboarding)")
				end
			end
			------------------------- intercalation ends

		  if show_Stairs or (show_StairsXPJ and SGES_stairs_type == "Boarding_without_stairs") then -- Warn
			if show_Stairs and adjust_StairsXPJ then
				imgui.Separator()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				imgui.TextUnformatted("Move the maintenance stairs.")
				Adjust_Alternate_Passenger_Attachement_Point_via_sliders("Angle")
				imgui.PopStyleColor()
				imgui.Separator()
			elseif (show_StairsXPJ and SGES_stairs_type == "Boarding_without_stairs") and adjust_StairsXPJ then
				imgui.Separator()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)

				-- special settings
				-- can be set in the general SGES aircrfat config file !
				imgui.TextUnformatted("Please adjust the passengers path")
				Adjust_Alternate_Passenger_Attachement_Point_via_sliders()
				imgui.PopStyleColor()
				imgui.Separator()
			end
		  end
		end





		if SecondStairsFwdPosition ~= -30 and SGES_stairs_type ~= "Boarding_without_stairs" then
		  --imgui.SameLine()
		  l_changed, l_newval = imgui.Checkbox(" Stairs Mk IV", show_StairsXPJ2)
		  if l_changed then
			show_StairsXPJ2 = l_newval
			StairsXPJ2_chg = true
			if show_StairsXPJ2 and show_StairsXPJ then
				DualBoard = true
			else
				DualBoard = false
				if PaxDoorRearLeft~= nil then PaxDoorRearLeft = target_to_open_the_door-1 end
			end
		  end
			if show_StairsXPJ2 == false and show_StairsXPJ == true then
				BoardStairsXPJ2 = false
				BoardStairsXPJ = true
				StairFinalY = StairFinalY_stairIII
				StairFinalH = StairFinalH_stairIII
				StairFinalX = StairFinalX_stairIII
				StairHigherPartX = StairHigherPartX_stairIII
				InitialPaxHeight = InitialPaxHeight_stairIII
			end
			if show_StairsXPJ == false and show_StairsXPJ2 == true then
				BoardStairsXPJ2 = true
				BoardStairsXPJ = false
				StairFinalY = StairFinalY_stairIV
				StairFinalH = StairFinalH_stairIV
				StairFinalX = StairFinalX_stairIV
				StairHigherPartX = StairHigherPartX_stairIV
				InitialPaxHeight = InitialPaxHeight_stairIV
			end
			--also stops or remove the passengers if there is no stairs :
			if show_StairsXPJ == false and show_StairsXPJ2 == false and show_Pax then
				show_Pax = l_newval
				Pax_chg = true
				if show_Pax then 	initial_pax_start = true		 end
			end
		end




		if show_StairsXPJ2 and show_Pax then
			-- when the stair is already loaded and all bariable already in place :
			--~ if InitialPaxHeight_stairIV ~= 0 then
				--~ imgui.SameLine()
				--~ if walking_direction == "boarding" then
					--~ l_changed, l_newval = imgui.Checkbox(" Board.", BoardStairsXPJ2)
				--~ else
					--~ l_changed, l_newval = imgui.Checkbox(" Deboard.", BoardStairsXPJ2)
				--~ end
				--~ if l_changed and BoardStairsXPJ then
					--~ BoardStairsXPJ2 = l_newval
					--~ BoardStairsXPJ = false
					--~ StairFinalY = StairFinalY_stairIV
					--~ StairFinalH = StairFinalH_stairIV
					--~ StairFinalX = StairFinalX_stairIV
					--~ InitialPaxHeight = InitialPaxHeight_stairIV
					--~ StairHigherPartX = StairHigherPartX_stairIV
				--~ end


				if DualBoard and walking_direction == "boarding" then imgui.SameLine() imgui.TextUnformatted(" (Dual board)")
				elseif DualBoard then imgui.SameLine() imgui.TextUnformatted(" (Dual deboard)") end

				if not DualBoard and walking_direction == "boarding" then imgui.SameLine() imgui.TextUnformatted(" (Boarding)")
				elseif not DualBoard then imgui.SameLine() imgui.TextUnformatted(" (Deboarding)") end
			--~ end
		end


		-- third stairs added 23 th may 2024 :
		-- theird stairs will NOT be used by passengers, to make it easier
		if (SecondStairsFwdPosition ~= -30 and SGES_stairs_type ~= "Boarding_without_stairs" and BeltLoaderFwdPosition >= 17 and (show_StairsXPJ or (sges_openSAM ~= nil and sges_openSAM[0] == 2)) and show_StairsXPJ2 and StairFinalY_stairIV ~= nil and StairFinalY_stairIII ~= nil) or show_StairsXPJ3 then
			if SGES_stairs_type ~= "Boarding_without_stairs" then
				l_changed, l_newval = imgui.Checkbox(" Stairs Mk V", show_StairsXPJ3)
				  if l_changed then
					show_StairsXPJ3 = l_newval
					StairsXPJ3_chg = true
				  end


			end
			if adjust_StairsXPJ3 == nil then adjust_StairsXPJ3 = false end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
		    if  imgui.SmallButton("¤")  then
				if adjust_StairsXPJ3 == false then
					adjust_StairsXPJ3 = true
				else
					adjust_StairsXPJ3 = false
				end
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Adjust the stairs.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.PopStyleColor()

			if show_StairsXPJ3 and adjust_StairsXPJ3 then
				imgui.Separator()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				local changed, newVal1 = imgui.SliderFloat("X MkV", lateral_factor3, -0.5, 10, "Lateral " .. math.floor(lateral_factor3*10)/10)
				if changed then
					lateral_factor3 = newVal1
					StairsXPJ3_chg = true
				end
				local changed, newVal2 = imgui.SliderFloat("Z MkV", longitudinal_factor3, -25, StairFinalY_stairIII, "Longitudinal " .. math.floor(longitudinal_factor3*10)/10)
				if changed then
					longitudinal_factor3 = newVal2
					StairsXPJ3_chg = true
				end
				if imgui.Button("Long. -0.1",79,17) then
					longitudinal_factor3 = longitudinal_factor3 - 0.1
					StairsXPJ3_chg = true
				end
				imgui.SameLine()
				if imgui.Button("Long. +0.1",79,17) then
					longitudinal_factor3 = longitudinal_factor3 + 0.1
					StairsXPJ3_chg = true
				end
				local changed, newVal3 = imgui.SliderFloat("H MkV", height_factor3, -1.25, 1, "Door height " .. math.floor(height_factor3*100)/100)
				if changed then
					height_factor3 = newVal3
					l_changed = true
					StairsXPJ3_chg = true
				end
				local changed, newVal3 = imgui.SliderFloat("Hdg MkV", sges_gs_plane_head_correction3, -6, 6, "Stairway heading " .. math.floor(sges_gs_plane_head_correction3*100)/100)
				if changed then
					sges_gs_plane_head_correction3 = math.floor(newVal3*100)/100
					l_changed = true
					StairsXPJ3_chg = true
				end
				if imgui.Button("Inverse side",165,20) then
					sign3 = -sign3
					heading_factor3 = heading_factor3 + 180
					StairsXPJ3_chg = true
				end
				imgui.TextUnformatted("Please note that the animated \npassengers can't use this way.")
				imgui.PopStyleColor()
				imgui.Separator()
			end
		end

		if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			--~ imgui.SameLine() -- clutter management !
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			if imgui.Button("Stairs",50,20) then
				ZIBOToggleStairs()
			end
			imgui.PopStyleColor(2)


			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("ZIBO or LevelUp aircraft stairs.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end
		if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			if imgui.Button("Option to toggle stairs",25,20) then
				ZIBOToggleStairsOption()
			end
			imgui.PopStyleColor(2)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Toggle the presence of aircraft airstairs in this ZIBO or LevelUp model.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

		imgui.Columns(2)

		if not boarding_from_the_terminal then
			if LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) )  then
				l_changed, l_newval = imgui.Checkbox(" Limousine", show_Bus) -- At the White house
			elseif IsPassengerPlane == 0 then
				l_changed, l_newval = imgui.Checkbox(" ULD train", show_Bus)
			elseif SGES_BushMode and IsXPlane12 then
				l_changed, l_newval = imgui.Checkbox(" Pax car", show_Bus)
			else
				l_changed, l_newval = imgui.Checkbox(" Bus", show_Bus)
			end
			  if l_changed then
				show_Bus = l_newval
				Bus_chg = true
				boarding_from_the_terminal = false
				if l_newval then boarding_from_the_terminal = false end
				option_StairsXPJ_override = l_newval
				if SGES_stairs_type == "Boarding_without_stairs" then
					show_StairsXPJ = l_newval
					StairsXPJ_chg = true
					show_Stairs = false
					Stairs_chg = true
					if not l_newval then terminate_passenger_action = true end
				end

					if not IsXPlane12 then
						if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
					end

			  end
		end

		if not SGES_BushMode and IsPassengerPlane == 1 and (boarding_from_the_terminal or (StairsXPJ_instance[0] ~= nil or StairsXPJ2_instance[0] ~= nil)) and (not show_Bus or boarding_from_the_terminal) then
			if not boarding_from_the_terminal then imgui.SameLine() end

			if not boarding_from_the_terminal then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D) end
			l_changed, l_newval = imgui.Checkbox(" Terminal", boarding_from_the_terminal)
			if not boarding_from_the_terminal then imgui.PopStyleColor() end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Pax walk without bus to or from the terminal building.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				show_Bus = l_newval
				if l_newval then boarding_from_the_terminal = l_newval end
				Bus_chg = true
			end
		end


		if LATITUDE > 38.79 and LATITUDE < 38.90 and ((LONGITUDE > -77.037 and LONGITUDE < -77.035) or (LONGITUDE > -76.88 and LONGITUDE < -76.86) )  then
			l_changed, l_newval = imgui.Checkbox(" Protection", show_Catering) -- At the White house
		elseif SGES_BushMode and IsXPlane12 and military == 0 and military_default == 0 then
			l_changed, l_newval = imgui.Checkbox(" Clutter", show_Catering)
		else
			l_changed, l_newval = imgui.Checkbox(" Catering", show_Catering)

			if PLANE_ICAO == "E170" or PLANE_ICAO == "E175" or PLANE_ICAO == "DH8D" then
				imgui.SameLine()

				imgui.PushStyleVar(imgui.constant.StyleVar.FrameRounding, 12)
				_, SGES_Embraer_catering_is_small = imgui.Checkbox(" (small)", SGES_Embraer_catering_is_small)
				imgui.PopStyleVar()

				if imgui.IsItemHovered() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 14)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Variant of the catering service.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end

		end
	  if l_changed then
		show_Catering = l_newval
		Catering_chg = true
	  end

		if SGES_BushMode and IsXPlane12 and (military == 1 or military_default == 1) then
			l_changed, l_newval = imgui.Checkbox(" Weapons", show_Cones)
		elseif SGES_BushMode and IsXPlane12 then
			l_changed, l_newval = imgui.Checkbox(" Barils", show_Cones)
		else
			l_changed, l_newval = imgui.Checkbox(" Cones", show_Cones)
		end
	  if l_changed then
		show_Cones = l_newval
		Cones_chg = true
		show_TargetMarker = false -- we cancel the nose wheel position marker upon chocks selection
		TargetMarker_chg = true
	  end





		-- TOLISS CHOCKS
		-- added april 2022
		--	if show_Chocks and PLANE_ICAO == "A319" or PLANE_ICAO == "A321" or PLANE_ICAO == "A346" then
		--		imgui.SameLine()
		--		if  imgui.Button("OFF",40,20)  then
		--			set("AirbusFBW/Chocks",0)
		--			show_Chocks = false
		--			Chocks_chg = true
		--		end
		--	end


		if UseXplaneDefaultObject then
			l_changed, l_newval = imgui.Checkbox(" Misc.", show_People1)
		else
			l_changed, l_newval = imgui.Checkbox(" People", show_People1)
		end
		if l_changed then
			show_People1 = l_newval
			People1_chg = true
			show_People2 = l_newval
			People2_chg = true
			show_People3 = l_newval
			People3_chg = true
			show_People4 = l_newval
			People4_chg = true
		end
		if not SGES_BushMode and (military == 1 or military_default == 1) and BeltLoaderFwdPosition < 6 and show_Chocks then
			if imgui.SmallButton("Rearm") then
				command_once("sim/weapons/re_arm_aircraft")
				set("sim/cockpit/weapons/guns_armed",1)
				show_Catering = true
				Catering_chg = true
			end
		elseif SGES_mirror == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFC9C9C9)
			--~ imgui.RadioButton(" Mirrored",true)
			imgui.TextUnformatted("Mirrored (info!)")
			imgui.PopStyleColor()
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 14)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Passengers will use the starboard side. In this mode, some animations are lost, others are simplified.\nPlease use the developper mode to cancel the mirror and board on port side as normal.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

	--------------------------------------------------------------------------------
	imgui.NextColumn()

		if UseXplaneDefaultObject == false then
			if show_Pax or (show_Bus and (show_StairsXPJ or show_StairsXPJ2) and Bus_chg == false) then
			--imgui.SameLine()
				if IsPassengerPlane == 0 then
					l_changed, l_newval = imgui.Checkbox(" Crew", show_Pax)
				else
					if not terminate_passenger_action then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					else imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					end
					if show_Pax then
						l_changed, l_newval = imgui.Checkbox("", show_Pax)
					else
						l_changed, l_newval = imgui.Checkbox(" Passengers", show_Pax)
					end
					if imgui.IsItemHovered() and show_Pax then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 13)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Cycle between boarding and deboarding.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if show_Pax then
						imgui.SameLine()
						if  imgui.SmallButton("Passengers")  then
							terminate_passenger_action = true
						end
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("Conclude progressively the (de)boarding.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					end
					imgui.PopStyleColor()
				end
			  if l_changed then
				 if l_newval == false then
					show_Pax = l_newval
					if protect_StairsXPJ then show_Pax = false end
					Pax_chg = true
					terminate_passenger_action = false
					--~ if show_Pax then terminate_passenger_action = true -- 15-7-2023 : make the disappearance progressive only
					--~ else -- safety exit
						--~ show_Pax = l_newval
						--~ Pax_chg = true
					--~ end
				 elseif (show_StairsXPJ or show_StairsXPJ2) then
					show_Pax = l_newval
					if protect_StairsXPJ then show_Pax = false end
					Pax_chg = true
					terminate_passenger_action = false
					initial_pax_start = true
					baggage_pass = 0


				 end
			  end
			elseif show_Pax or show_Baggage then
				--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				--~ l_changed, l_newval = imgui.Checkbox(" Load/unload", false)
				if  imgui.SmallButton("Load/unload")  then
					baggage_pass = 0
					if walking_direction == "deboarding" then walking_direction = "boarding" else walking_direction = "deboarding" end
					BeltLoader_chg = true -- this steps allow the inversion of the animated baggages
					Baggage_chg = true
				end
				imgui.PopStyleColor()
				if imgui.IsItemHovered() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 13)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Cycle between boarding and deboarding.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				--~ if l_changed then
					--~ baggage_pass = 0
					--~ if walking_direction == "deboarding" then walking_direction = "boarding" else walking_direction = "deboarding" end
					--~ BeltLoader_chg = true -- this steps allow the inversion of the animated baggages
					--~ Baggage_chg = true
				--~ end
			else imgui.TextUnformatted("") -- return line
			end
		end


		--[[
		if show_StairsXPJ and show_StairsXPJ2 and (show_Pax or (show_Bus and (show_StairsXPJ or show_StairsXPJ2) and Bus_chg == false))then
			-- when the stair is already loaded and all bariable already in place :
			if InitialPaxHeight_stairIV ~= 0 then
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				--imgui.SameLine()
				if walking_direction == "boarding" then
					l_changed, l_newval = imgui.Checkbox(" both stairs", DualBoard)
				else
					l_changed, l_newval = imgui.Checkbox(" both stairs", DualBoard)
				end
				if l_changed then
					DualBoard = l_newval
				end
				imgui.PopStyleColor()
			end
		end
		]]

		--~ if  imgui.SmallButton("FORCE PB")  then
			--~ show_WingWalkers = false
			--~ PB_chg = true
			--~ remove_wingwalkers()
		--~ end

		if show_PB and show_WingWalkers and Baggage_instance[3] ~= nil and Baggage_instance[4] ~= nil and not show_Baggage then --IAS24 start
			if (sges_current_time % 2 == 0) then
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			else
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
			end
			if  imgui.SmallButton("CANCEL WALKERS")  then
				show_WingWalkers = false
				PB_chg = true
				remove_wingwalkers()
			end
			imgui.PopStyleColor()
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Remove the wing walkers.")
				imgui.TextUnformatted("The pushback continues.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end  --IAS24 ends

		if UseXplaneDefaultObject == false then
			--~ imgui.SameLine()
			if not PRM_is_catering then
			  l_changed, l_newval = imgui.Checkbox(" PRM", show_PRM)
				if l_changed then
					show_PRM = l_newval
					PRM_chg = true
				end
				if show_PRM and PRM_instance[0] ~= nil and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1 and UseXplane1214DefaultObject then
						imgui.SameLine()
					  l_changed, l_newval = imgui.Checkbox(" Amb", get_hospital_ambulance)
						if l_changed then
							get_hospital_ambulance = l_newval
							if get_hospital_ambulance and Stored_CateringObject == nil then
								Stored_CateringObject = Prefilled_CateringObject
							end
							_,PRM_instance[0],rampservicerefPRM = common_unload("PRM",PRM_instance[0],rampservicerefPRM)
							_,PRM_instance[1],rampservicerefPRM2 = common_unload("PRMHighPart",PRM_instance[1],rampservicerefPRM2)
							PRM_chg = true
							if not get_hospital_ambulance and Stored_CateringObject ~= nil then
								Prefilled_CateringObject = Stored_CateringObject -- Important to reset !
								Prefilled_CateringHighPartObject = Prefilled_LightObject
							end
							PRM_chg = true
						end
				elseif not show_PRM and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 0 then
					get_hospital_ambulance = false
				end
			else
			  l_changed, l_newval = imgui.Checkbox(" Cater.", show_PRM)
			if l_changed then
				show_PRM = l_newval
				PRM_chg = true
				get_hospital_ambulance = false
			end
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Persons with Reduced Mobility boarding.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  end

			if SecondStairsFwdPosition ~= -30 then
			-- only offer the catering truck instead of the PRM when the PRM is not the small car
				imgui.SameLine()
				if imgui.SmallButton("/") then
					if PRM_is_catering then PRM_is_catering = false else PRM_is_catering = true end
				end
			end
			--imgui.TextUnformatted("") -- return line

		  if sges_gs_gnd_spd[0] < 5 or show_Chocks then
			--~ imgui.SameLine() -- added 30 december 2020
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)

			if wetness == 1 then
			  l_changed, l_newval = imgui.Checkbox(" Dock lines", show_Chocks)
			elseif IsXPlane1220 and UseXplane1220Chocks then
			  l_changed, l_newval = imgui.Checkbox(" X-chocks", show_Chocks)
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.TextUnformatted("Laminar Research chocks (only after after X-Plane 12.2).")
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			else
			  l_changed, l_newval = imgui.Checkbox(" Chocks", show_Chocks)
			end
			imgui.PopStyleColor()
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Active chocks allowing you to release the parking brake.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				show_Chocks = l_newval
				Chocks_chg = true -- use SGES chocks
				show_TargetMarker = false -- we cancel the nose wheel position marker upon chocks selection
				TargetMarker_chg = true
				show_StopSign = false
				StopSign_chg = true
				force_factor_forced = -0.02

				if UseXplane1220Chocks and not IsXPlane1220 then
					UseXplane1220Chocks = false -- we cannot use the xplane chocks before XP12.2, so even if the ACFT says we prefer XP chocks, we must force that disabled.
					print("[Ground Equipment " .. version_text_SGES .. "] This very aircraft has been configured by you to use the Laminar Research native chocks published after X-Plane 12.2. However it seems you are using an older version of X-Plane. We are reversing for this session to the use of SGES chocks instead of X-Plane chocks. Allright !")
				elseif IsXPlane1220 and UseXplane1220Chocks then
					if l_newval then command_once("sim/flight_controls/install_chocks")
					else command_once("sim/flight_controls/remove_chocks")
					end
				end
				if show_Chocks and IsToLiSs and not UseXplane1220Chocks then -- add ToLiss chocks
					set("AirbusFBW/Chocks",1)
				elseif 			   IsToLiSs then -- remove ToLiss chocks
					set("AirbusFBW/Chocks",0)
					print("rmove toliss chocks")
				end
				if show_Chocks and IsSimcoders then -- toggle simcoders chocks
					command_once("simcoders/rep/walkaround/static_elements/toggle")
					command_once("sim/flight_controls/door_open_1")
					command_once("sim/flight_controls/door_open_2")
				elseif 			   IsSimcoders then -- toggle simcoders chocks
					command_once("simcoders/rep/walkaround/static_elements/toggle")
					command_once("sim/flight_controls/door_close_1")
					command_once("sim/flight_controls/door_close_2")
				end
				if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh") and not UseXplane1220Chocks  then
					ZIBOToggleChocks()
				end
				if not IsXPlane12 then
					if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
				end

			end
		end


		if string.match(PLANE_ICAO,"B73") and string.find(PLANE_AUTHOR,"Unruh")  then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			--~ imgui.SetWindowFontScale(0.9)
			if imgui.Button("Cho",30,20) then
				ZIBOToggleChocks()
			end
			--~ imgui.SetWindowFontScale(1)
			imgui.PopStyleColor(2)


			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("ZIBO/LevelUp chocks and cones.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		elseif PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis") and not UseXplane1220Chocks then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			--~ imgui.SetWindowFontScale(0.9)
			if imgui.Button("Cho",30,20) then
				if show_Chocks then
					set("B742/INT_PA/set_gear_chokes",1)
					if not UseXplane1220Chocks then
						show_Chocks = false -- replace XP chocks by Felis chocks
						Chocks_chg = true
					end
				else
					set("B742/INT_PA/set_gear_chokes",0)
				end
			end
			--~ imgui.SetWindowFontScale(1)
			imgui.PopStyleColor(2)
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Felis B742 chocks.\nIf SGES chocks are already on, this will replace them by Felis ones")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		elseif PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
			imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
			--~ imgui.SetWindowFontScale(0.9)
			if imgui.Button("Cho",30,20) then
				if show_Chocks then
					command_once("CL650/hand_signals/chocks_in")
					show_Chocks = false -- replace XP chocks by Hot Start chocks
					Chocks_chg = true
					if IsXPlane1220 and UseXplane1220Chocks then
						command_once("sim/flight_controls/remove_chocks")
					end
				else
					command_once("CL650/hand_signals/chocks_out")
				end
			end
			--~ imgui.SetWindowFontScale(1)
			imgui.PopStyleColor(2)
			if imgui.IsItemHovered() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("CL650 chocks.\nIf SGES chocks are already on, this will replace them by Hot Start ones.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end


	  --~ imgui.SameLine() -- added april 2021
		if sges_gs_gnd_spd[0] < 30 and math.abs(BeltLoaderFwdPosition) < 6 and (military == 1 or military_default == 1)  then
			l_changed, l_newval = imgui.Checkbox(" Handler", show_Ponev)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("If on a flight deck, shows an aircraft Handling Officer.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				show_Ponev = l_newval
				Ponev_chg = true
			end
		end


	  --~ imgui.SameLine() -- added april 2021
	  if show_TargetSelfPushback == false or show_PB then
		  l_changed, l_newval = imgui.Checkbox(" PB", show_PB)
			  if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Here's a nice & simple Push-back. You must turn OFF the Parking Brake to be able to move. See the dedicated manual for more.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			show_Chocks = false
			Chocks_chg = true
			if IsToLiSs then -- remove ToLiss chocks
				set("AirbusFBW/Chocks",0)
			end
			show_PB = l_newval
			Go_PB = l_newval
			if Go_PB then pushback_manual = false
			else pushback_manual = true force_factor_forced = -0.02 end
			PB_chg = true


			if not IsXPlane12 then
				if SGES_sound and l_newval == true then	play_sound(Engine_sound) elseif SGES_sound and l_newval == false and show_Bus == false and show_Cart == false and show_GPU == false and show_FireVehicle == false and show_Deice == false and show_PB == false and show_FUEL == false and show_ASU == false then stop_sound(Engine_sound) end
			end

			if show_PB == false then
				set("sim/flightmodel/position/Rrad",0)
				math.randomseed(os.time()) -- this is for the decision to quit left or right in the departing animation -- IAS24
				randomView = math.random()  -- this is for the decision to quit left or right in the departing animation -- IAS24
			end
			--~ show_Light = l_newval
			--~ Light_chg = true
		  end
		  if show_PB then
			  imgui.SameLine() -- added april 2021
			  l_changed, l_newval = imgui.Checkbox("Go", Go_PB)
				  if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("If 'GO', then as soon as the parking brake is released, the push-back is pushing you backward. Otherwise you control it manually with the joystick.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			  if l_changed then
				Go_PB = l_newval
				if Go_PB then pushback_manual = false
				else pushback_manual = true force_factor_forced = -0.02 end
			  end
		   elseif sges_gs_gnd_spd[0] < 20 and BeltLoaderFwdPosition < 5 and (military == 1 or military_default == 1) then -- speed is 15 when on the XP12 carrier
				imgui.SameLine()
				  if imgui.Button("Push",35,17) then
							if SGES_pushTurn_ratio == nil then SGES_pushTurn_ratio = 0 end -- TEMPO, dataref is loaded in the subscript for pushback
							set("sim/flightmodel/position/Rrad",-SGES_pushTurn_ratio/2) -- change the heading before applying coordinates translations
							coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, -1, sges_gs_plane_head[0])
							set("sim/flightmodel/position/local_x",g_shifted_x)
							set("sim/flightmodel/position/local_z",g_shifted_z)
				  end
					 if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("A single push backward, usefull for aircraft carrier operations. You can rotate with the joystick.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end

		   end


		if show_PB and Go_PB then
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
		    if  imgui.SmallButton("f")  then
				if adjust_Strength == false then
					adjust_Strength = true
				else
					adjust_Strength = false
				end
			end

			imgui.PopStyleColor()
			if show_PB and adjust_Strength then
				 local changed, newVal7 = imgui.SliderFloat("PB", force_factor_forced, 0.03, -0.1, "- Force +")
				if changed then
					force_factor_forced = newVal7
				end
				 if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("If the tug cannot push you, increase the force. Otherwise, please keep the cursor aligned with the reference.")
					imgui.PopStyleColor()
					--~ imgui.TextUnformatted("Otherwise, please keep the cursor aligned with the reference.")
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.PushStyleColor(imgui.constant.Col.Text,  imgui.ColorConvertFloat4ToU32(0.690, 0.565, 0.0, 1.0))
				imgui.PushStyleColor(imgui.constant.Col.SliderGrab,  imgui.ColorConvertFloat4ToU32(0.690, 0.565, 0.0, 1.0))
				imgui.PushStyleColor(imgui.constant.Col.SliderGrabActive,  imgui.ColorConvertFloat4ToU32(0.690, 0.565, 0.0, 1.0))
				imgui.PushStyleColor(imgui.constant.Col.FrameBg,  0xFF444444)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF444444)
				imgui.PushStyleColor(imgui.constant.Col.FrameBgActive,  0xFF444444)
				local slider_text = "| | | | | | |"
				if SGES_override_engine_forces == 0 then slider_text = "Override OFF " end

				imgui.PushStyleVar(imgui.constant.Col.Text, 0.75)
				local changed, _ = imgui.SliderFloat("Ref", -0.02, 0.03, -0.1, slider_text)
				imgui.PopStyleVar()
				if changed then
					force_factor_forced = -0.02
				end
				imgui.PopStyleColor(6)
			end

		end

		--elseif show_TargetSelfPushback then

			--imgui.TextUnformatted("")
		end


		-- SELF PUSHBACK COMMAND


		if show_TargetSelfPushback and show_PB == false and SGES_parkbrake < 1 then
		  --imgui.SameLine() -- added april 2021
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
		  if  imgui.Button("Start PB",70,18)  then
			show_Chocks = false
			Chocks_chg = true
			if IsToLiSs then -- remove ToLiss chocks
				set("AirbusFBW/Chocks",0)
			end
			show_PB = true
			Go_PB = true
			pushback_manual = false
			SGES_startPB_time = os.time()
			PB_chg = true
			final_heading = false

			-- clean also other vehicles :


			if SGES_sound then
				play_sound(Starting_PB_sound)
			end
			show_Bus = false
			Bus_chg = true
			show_FireVehicle = false
			FireVehicle_chg = true
			if PLANE_ICAO == string.match(PLANE_ICAO,"CRJ") then command_once("crj700/tablet/menu/settings/hot_external_power_command")
			elseif IsToLiss == false then
				show_GPU = false
				GPU_chg = true
			end
			show_RearBeltLoader = false
			RearBeltLoader_chg = true
			show_FUEL = false
			FUEL_chg = true
			show_Cleaning = false
			Cleaning_chg = true
			show_PRM = false
			PRM_chg = true
			show_Forklift = false
			Forklift_chg = true
			show_BeltLoader = false
			BeltLoader_chg = true
			show_Cart = false
			Cart_chg = true
			show_ULDLoader = false
			ULDLoader_chg = true
			show_Stairs = false
			Stairs_chg = true
			show_StairsH = false
			StairsH_chg = true
			show_Catering = false
			Catering_chg = true
			show_Cones = false
			Cones_chg = true
			show_Pax = false
			Pax_chg = true
			--~ show_People1 = false
			--~ People1_chg = true
			show_People2 = false
			People2_chg = true
			show_People3 = false
			People3_chg = true
			show_People4 = false
			People4_chg = true
			show_Deice = false
			Deice_chg = true
			show_Light = false
			Light_chg = true
			show_StairsXPJ = false
			StairsXPJ_chg = true
			show_StairsXPJ2 = false
			StairsXPJ2_chg = true
			show_StairsXPJ3 = false --IAS24
			StairsXPJ3_chg = true --IAS24
			show_ASU = false
			show_ACU = false
			ASU_chg = true
			show_Baggage = false
			Baggage_chg = true

			--ensure aim is ok :
			show_TargetSelfPushback = true
			TargetSelfPushback_chg = true
			end
			imgui.PopStyleColor()
		end

	  -- SELF PUSHBACK COMMAND


		if show_PB == false and SGES_parkbrake > 0.8 and (math.abs(BeltLoaderFwdPosition) >= 5 or string.match(PLANE_ICAO,"AT") or string.match(PLANE_ICAO,"B4") or string.match(PLANE_ICAO,"RJ")) and IsXPlane12 then
		--if show_PB == false and SGES_parkbrake > 0.8 and IsXPlane12 then -- LINE FOR TESTS ONLY
			if show_PB == false and show_TargetSelfPushback == true then imgui.Checkbox(" PB", false) end
			imgui.SameLine()
			l_changed, l_newval = imgui.Checkbox("Aim", show_TargetSelfPushback)
			if l_changed then
				show_TargetSelfPushback = l_newval
				TargetSelfPushback_chg = true
				pushback_manual = false
				service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
				if l_newval then -- allow to see the pushback marker behind the aircraft
					--~ local psi=get("sim/cockpit/misc/compass_indicated")+180
					--~ -- correct negative or more than 360 degrees values :
					--~ if psi > 360 then
						--~ psi = psi - 360
					--~ end
					--~ if psi < 0 then
						--~ psi = psi + 360
					--~ end
					set("sim/graphics/view/pilots_head_psi",180)--+get("sim/flightmodel/position/magnetic_variation"))
					set("sim/graphics/view/pilots_head_the",-70)  -- pitch
					set("sim/graphics/view/pilots_head_phi",0) -- roll
					set("sim/graphics/view/pilots_head_y",150) -- altitude
					--command_once("sim/view/free_camera")
				end
			end
			 if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("1/ Aim at your desired position at the end of the pushback with parking brake set. 2/ Release the parking brake to continue. 3/ Click on 'Start PB'. 4/ Wait for the pushback to complete. Note : to pause the pushback at any time, set the parking brake.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end


	imgui.Columns(1)
	--------------------------------------------------------------------------------


	imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)


	if show_TargetSelfPushback and SGES_parkbrake > 0.8 then
		imgui.Spacing() --IAS24
		imgui.Spacing() --IAS24
		local changed, newVal2 = imgui.SliderFloat("Nose", SPB_orientation, -110, 110, "Nose orientation")
		if changed then

			SPB_orientation = newVal2

			-- sticky positions : 0° and 90° :

			if SPB_orientation < center_line_sticky_heading_threshold and SPB_orientation > - 1* center_line_sticky_heading_threshold then SPB_orientation = 0
			elseif SPB_orientation <= 99 and SPB_orientation >= 86 then SPB_orientation = 90
			elseif SPB_orientation >= -99 and SPB_orientation <= -86 then SPB_orientation = -90 end

			TargetSelfPushback_chg = true
			if SPB_distance > - 37 then SPB_distance = - 37 end
			service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
		end
		if imgui.IsItemActive() then
			-- Click & hold tooltip
			imgui.BeginTooltip()
			-- This function configures the wrapping inside the toolbox and thereby its width
			imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("Nose orientation after the pushback.")
			imgui.PopStyleColor()
			-- Reset the wrapping, this must always be done if you used PushTextWrapPos
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end


		--imgui.SameLine()

		if PB_extended_length_option == nil then PB_extended_length_option = false PB_extended_length = -95 end

		local changed, newVal1 = imgui.SliderFloat("Length", SPB_distance, -38, PB_extended_length, "Pushback length")
		if changed then
			SPB_distance = newVal1
			show_Chocks = false
			Chocks_chg = true
				--~ show_PB = true
				--~ PB_chg = true
			TargetSelfPushback_chg = true
			service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
		end
		if imgui.IsItemActive() then
			-- Click & hold tooltip
			imgui.BeginTooltip()
			-- This function configures the wrapping inside the toolbox and thereby its width
			imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("Aim at your intended position after the pushback.")
			imgui.PopStyleColor()
			-- Reset the wrapping, this must always be done if you used PushTextWrapPos
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end


		l_changed, l_newval = imgui.Checkbox("Extended length", PB_extended_length_option)
		if l_changed then
			PB_extended_length_option = l_newval
			if l_newval then
				PB_extended_length = -200
			else
				PB_extended_length = -95
				if SPB_distance > PB_extended_length then
					SPB_distance = PB_extended_length
					TargetSelfPushback_chg = true
					service_object_physicsTargetSelfPushback(SPB_distance,SPB_orientation)
				end
			end
		end

		imgui.TextUnformatted("Then release the parking brake.")
	end

	imgui.PopStyleColor()

	imgui.Columns(1)
	--------------------------------------------------------------------------------

		if  imgui.Button("Clean",50,20)  then
			l_newval = false
			show_FireVehicle = l_newval
			FireVehicle_chg = true
			if string.match(PLANE_ICAO,"CRJ") then command_once("crj700/tablet/menu/settings/hot_external_power_command")
			elseif IsToLiss == false then
				show_GPU = l_newval
				GPU_chg = true
			end
			show_RearBeltLoader = l_newval
			RearBeltLoader_chg = true
			show_FUEL = l_newval
			FUEL_chg = true
			show_Cleaning = l_newval
			Cleaning_chg = true
			show_PRM = l_newval
			PRM_chg = true
			show_BeltLoader = l_newval
			BeltLoader_chg = true
			show_Cart = l_newval
			Cart_chg = true
			show_ULDLoader = l_newval
			ULDLoader_chg = true
			show_Stairs = l_newval
			Stairs_chg = true
			show_StairsH = l_newval
			StairsH_chg = true
			show_Catering = l_newval
			Catering_chg = true
			show_Cones = l_newval
			Cones_chg = true
			show_People1 = l_newval
			People1_chg = true
			show_People2 = l_newval
			People2_chg = true
			show_People3 = l_newval
			People3_chg = true
			show_People4 = l_newval
			People4_chg = true
			show_Bus = l_newval
			Bus_chg = true
			show_Pax = l_newval
			Pax_chg = true
			initial_pax_start = true
			terminate_passenger_action = false
			show_Deice = l_newval
			Deice_chg = true
			show_Light = l_newval
			Light_chg = true
			show_StairsXPJ = l_newval
			StairsXPJ_chg = true
			show_StairsXPJ2 = l_newval
			StairsXPJ2_chg = true
			show_StairsXPJ3 = l_newval
			StairsXPJ3_chg = true
			show_TargetMarker = l_newval
			TargetMarker_chg = true
			show_StopSign = l_newval
			StopSign_chg = true
			show_ArrestorSystem = l_newval
			ArrestorSystem_chg = true
			show_ASU = l_newval
			show_ACU = l_newval
			ASU_chg = true
			show_Forklift = l_newval
			Forklift_chg = true
			show_Baggage = l_newval
			Baggage_chg = true
			Baggage_pass = 0
			if SGES_sound and l_newval == false and not IsXPlane12 and show_GPU == false then stop_sound(Engine_sound)  end
		end imgui.SameLine()
		if  imgui.Button("All",50,20)  then
			l_newval = true
			if SecondStairsFwdPosition ~= nil and SecondStairsFwdPosition ~= -30 then
				show_StairsXPJ = l_newval
				StairsXPJ_chg = true

				if IsPassengerPlane == 0  and string.find(AIRCRAFT_FILENAME,"Felis")  then
					show_StairsXPJ3 = l_newval
					StairsXPJ3_chg = true
				else
					show_StairsXPJ2 = l_newval
					StairsXPJ2_chg = true
				end
			end
			show_Bus = l_newval
			Bus_chg = true
			if SGES_stairs_type == "Boarding_without_stairs" and math.abs(BeltLoaderFwdPosition) >= 4.5 then
				show_StairsXPJ = l_newval
				StairsXPJ_chg = true
			end
			show_FireVehicle = false
			FireVehicle_chg = true
			if string.match(PLANE_ICAO,"CRJ") then command_once("crj700/tablet/menu/settings/hot_external_power_command")
			elseif not SGES_BushMode then
				if not string.find(AIRCRAFT_FILENAME,"Felis")  then
					show_GPU = l_newval
					GPU_chg = true
				end
			end
			show_FUEL = l_newval
			FUEL_chg = true
			if not string.match(PLANE_ICAO,"AT4") and not (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then
				show_Cleaning = l_newval
				Cleaning_chg = true
			end
			if math.abs(BeltLoaderFwdPosition) > 4 and IsPassengerPlane == 0 and not SGES_BushMode then
				show_ULDLoader = l_newval
				ULDLoader_chg = true
			end
			if math.abs(BeltLoaderFwdPosition) > 4 and not string.match(PLANE_ICAO,"GLF") then
				show_BeltLoader = l_newval
				if PLANE_ICAO == "A3ST" then show_BeltLoader = false end
				BeltLoader_chg = true
				show_Cart = l_newval
				Cart_chg = true
			end
			if (Prefilled_ForkliftObject == 	Prefilled_ULDLoaderObject or Prefilled_ForkliftObject == Prefilled_CargoDeck_ULDLoaderObject ) and IsPassengerPlane == 0 then
				show_Forklift = l_newval
				Forklift_chg = true
			end
			if math.abs(BeltLoaderFwdPosition) > 4 and BeltLoaderRearPosition ~= nil then -- we want to avoid a rear belt loader when there is no room for it so we display it only when explicitely defined
				show_RearBeltLoader = l_newval -- the user will always have the choice to make it appear manually
				RearBeltLoader_chg = true
			end
			if not string.match(PLANE_ICAO,"MD8") and not string.match(PLANE_ICAO,"MD9") then -- when the catering is forward, don't interfere with belt loader
				show_Catering = l_newval
				Catering_chg = true
			end
			show_Cones = l_newval
			Cones_chg = true
			--show_ACU = l_newval
			--show_ASU = l_newval
			--ASU_chg = true
			show_People1 = l_newval
			People1_chg = true
			show_People2 = l_newval
			People2_chg = true
			show_People3 = l_newval
			People3_chg = true
			show_People4 = l_newval
			People4_chg = true
			--show_Light = l_newval
			--Light_chg = true
			show_StopSign = false
			StopSign_chg = true
			show_Chocks = l_newval
			Chocks_chg = true
			--if string.match(PLANE_ICAO, "B75") or string.match(PLANE_ICAO, "B76") or string.match(PLANE_ICAO, "B74") or string.match(PLANE_ICAO, "A3") then
			--    show_StairsXPJ = l_newval
			--    StairsXPJ_chg = true
			--end
			--if string.match(PLANE_ICAO, "A34") then
			--    show_StairsXPJ2 = l_newval
			 --   StairsXPJ2_chg = true
			 -- faire aussi attention au cas de SGES_stairs_type ~= "Boarding_without_stairs" où on veut eviter l'arriere de l'avion
			--end
			if show_GPU and not show_ASU and IsToLiSs then -- add ToLiss GPU
				show_ASU =  true -- also prepare the Low pressure and High pressure object depiction, but then their appearance is 3D animation driven.
				ASU_chg = true
			elseif show_ASU == true and IsToLiSs then -- remove ToLiss GPU
				show_ASU =  false -- couple the GPU removal with the ASU+ACU object removal (ease of use)
				ASU_chg = true
			end
			if show_Pax then 		initial_pax_start = true end
			if SGES_sound and not IsXPlane12 and l_newval == true then	play_sound(Engine_sound) end
		end

		if show_Automatic_sequence_start then
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.SameLine()
			l_changed, l_newval = imgui.Checkbox("Auto", show_Automatic_sequence_start) imgui.SameLine()
			  if l_changed then
				show_Automatic_sequence_start = false
			end
			imgui.SameLine()
			if  SGES_gui_sequence_chronology == nil then
				SGES_gui_sequence_chronology = math.floor(((SGES_Automatic_sequence_start_flight_time_sec+1140-SGES_total_flight_time_sec)/60)/sequence_debug_factor)
			end
			if imgui.SmallButton(SGES_gui_sequence_chronology) 	then
				sequence_debug_factor = sequence_debug_factor + 0.5
				if sequence_debug_factor > 2 then sequence_debug_factor = 1 end -- cycling
				SGES_gui_sequence_chronology = math.floor(((SGES_Automatic_sequence_start_flight_time_sec+1140-SGES_total_flight_time_sec)/60)/sequence_debug_factor)
				show_Automatic_sequence_start = true
				SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
				initial_pax_start = true
				baggage_pass = 0
				--~ print(sequence_debug_factor)
			end

			imgui.SameLine() imgui.TextUnformatted("min.")
			imgui.PopStyleColor()
		else
		if SGES_total_flight_time_sec < 3600 and sges_gs_gnd_spd[0] < 1 and read_the_SGES_startup_options_delayed_elapsed then
			imgui.SameLine()
			if  imgui.Button("Sequence",80,20)  then
				show_Pump = false -- to avoid handling special 3D geometries in a mode where the user wants everything to be auto
				show_Automatic_sequence_start = true
				SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
				initial_pax_start = true
				baggage_pass = 0
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Start a ground services sequence.\nAlso available as a command in X-Plane preferences.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		elseif sges_gs_gnd_spd[0] < 1 and read_the_SGES_startup_options_delayed_elapsed then
			imgui.SameLine()
			if  imgui.Button("Turn seq.",80,20)  then
				show_Pump = false -- to avoid handling special 3D geometries in a mode where the user wants everything to be auto
				show_Automatic_sequence_start = true
				SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
				initial_pax_start = true
				baggage_pass = 0
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Start a turn-around sequence.\nAlso available as a command in X-Plane preferences.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end
		end




	  l_changed, l_newval = imgui.Checkbox(" Passenger", GUIIsPassengerPlane)
		if imgui.IsItemActive() then
			-- Click & hold tooltip
			imgui.BeginTooltip()
			-- This function configures the wrapping inside the toolbox and thereby its width
			imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
			imgui.TextUnformatted("Switch between a passenger ground services set or a cargo set. Some services have an alternative suited to cargo ops, after recycling them individually.")
			imgui.PopStyleColor()
			-- Reset the wrapping, this must always be done if you used PushTextWrapPos
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
	  if l_changed then
		AircraftParameters() -- it's probable the user has changed aircraft
		if SGES_mirror == 1 and BeltLoaderFwdPosition > 5 then SGES_mirror = 0 print("[Ground Equipment " .. version_text_SGES .. "] SGES has removed mirrored ground services.") end -- we need to forbid acess to mirrorring passengers when this is NOT suitable to mirror
		--print("[Ground Equipment " .. version_text_SGES .. "] Aircraft Path : " .. AircraftPath )
		GUIIsPassengerPlane = l_newval

		if IsPassengerPlane == 1 then
				IsPassengerPlane = 0
		   else
				IsPassengerPlane = 1
			end

		-- reload different set
		show_Bus = false
		show_Catering = false
		Bus_chg = true
		Catering_chg = true
	  end



		imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFC9C9C9)


	  if XTrident_Chinook_Directory ~= nil and file_exists(SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj") then
		  imgui.SameLine()
		   l_changed, l_newval = imgui.Checkbox(" Army", GUImilitary_sges)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("You have the X-Trident Chinook installed.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			GUImilitary_sges = l_newval

			if military == 1 then
					military = 0
					milheight = 0
		    else
					military = 1
					milheight = 1.1
					military_default = 0 -- destroy default military
					GUImilitary_default_sges = not l_newval
			end
			BushObjectsToggle(military)
		  end
	  else
		  imgui.SameLine()
		   imgui.Checkbox(" Army", false)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("If you have the X-Trident Chinook installed, we can display a HEMTT M978 fuel truck and a HMMWV M998 Hummer. Please see the manual how to unlock that.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
	  end
	 -- if GUImilitary_sges == false then
		  imgui.SameLine()
		   l_changed, l_newval = imgui.Checkbox(" Mil.", GUImilitary_default_sges)
			if imgui.IsItemActive() then
				--~ -- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Green painted vehicles will appear instead of the regular ones.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		  if l_changed then
			GUImilitary_default_sges = l_newval

			if military_default == 1 then
					military_default = 0
					milheight = 0
			   else
					military_default = 1
					milheight = 0
					military = 0 -- destroy x-trident
					GUImilitary_sges = not l_newval
				end
				BushObjectsToggle(military_default)
		  end
	 -- end

	 end -- IAS24

	  if (military_default == 1 or military == 1 or sges_gs_ias_spd[0] >= 200 ) and not Mashaller_available then --IAS24
		if imgui.TreeNode("Carrier and frigate, and more") then
			if x_mtr_boats_table == nil then x_mtr_boats_table = dataref_table("sim/world/boat/x_mtr") end
			if z_mtr_boats_table == nil then z_mtr_boats_table = dataref_table("sim/world/boat/z_mtr") end
			if user_boat_lon ~= nil then user_boat_lon_GUI = user_boat_lon end
			if user_boat_lat ~= nil then user_boat_lat_GUI = user_boat_lat end
			-- emergency read of the config file if we cant find the info -- safety
			if user_boat_lon_GUI == nil or user_boat_lat_GUI == nil then
				dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_options.lua") -- user settings and preferences
				-- this embark other stuff but also saves the day regarding undefined values
				if user_boat_lon ~= nil then user_boat_lon_GUI = user_boat_lon else user_boat_lon_GUI = -1 end
				if user_boat_lat ~= nil then user_boat_lat_GUI = user_boat_lat else user_boat_lat_GUI = -1  end
			end


			if GUIcoordinates == false and user_boat_lon ~= nil and user_boat_lat ~= nil then
				user_boat_lon = nil
				user_boat_lat = nil
			end

			-- for user convenience :
		   l_changed, l_newval =  imgui.Checkbox(" Straight ahead at " .. (math.floor((DistanceToShipWreckSite/1915)*1)/1 .. " nm"), not GUIcoordinates)
					if imgui.IsItemHovered() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Cycle to cycle the distance.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
		  if l_changed then
			GUIcoordinates = not l_newval
			if GUIcoordinates then
				user_boat_lon = tonumber(user_boat_lon_GUI)
				user_boat_lat = tonumber(user_boat_lat_GUI)
				carrier_rank = 1
			else
				user_boat_lon = nil
				user_boat_lat = nil
				DistanceToShipWreckSite = DistanceToShipWreckSite * 2.5
				if DistanceToShipWreckSite > 42 * DistanceToShipWreckSite_initial then DistanceToShipWreckSite = DistanceToShipWreckSite_initial end
			end
		  end

		   l_changed, l_newval = imgui.Checkbox(" On defined coordinates", GUIcoordinates)
		  if l_changed then
			GUIcoordinates = l_newval
			if GUIcoordinates then
				user_boat_lon = tonumber(user_boat_lon_GUI)
				user_boat_lat = tonumber(user_boat_lat_GUI)
				carrier_rank = 1
			else
				user_boat_lon = nil
				user_boat_lat = nil
			end
		  end



			if user_boat_location_name ~= nil and GUIcoordinates then
				imgui.PushItemWidth(80)
				local changed, newText = imgui.InputText("Latitude", user_boat_lat_GUI, 15)
				-- Parameters: Label, current text, maximum number of allowed characters
				if changed then
					if string.len(newText) > 2 then
						user_boat_lat = tonumber(newText)
						user_boat_location_name = "User coordinates"
					end
				end
				imgui.PopItemWidth()
				--~ imgui.SameLine()
				imgui.PushItemWidth(80)
				local changed, newText = imgui.InputText("Longitude", user_boat_lon_GUI, 15)
				-- Parameters: Label, current text, maximum number of allowed characters
				if changed then
					if string.len(newText) > 2 then
						user_boat_lon = tonumber(newText)
						user_boat_location_name = "User coordinates"
					end
				end
				imgui.PopItemWidth()

				--imgui.TextUnformatted(user_boat_location_name)
				if imgui.Button("< " .. user_boat_location_name .. " >",190,20) then
					if carrier_rank > 22 then carrier_rank = 1 end
					user_boat_lat = 			tonumber(Carrier_group_lat_t[carrier_rank])
					user_boat_lon = 			tonumber(Carrier_group_lon_t[carrier_rank])
					user_boat_location_name = 	Carrier_group_name_t[carrier_rank]
					if user_boat_lon ~= nil then user_boat_lon_GUI = user_boat_lon else user_boat_lon_GUI = -1 end
					if user_boat_lat ~= nil then user_boat_lat_GUI = user_boat_lat else user_boat_lat_GUI = -1  end
					if user_boat_location_name ~= nil then
						print("[Ground Equipment " .. version_text_SGES .. "] User has selected the carrier group location '" .. user_boat_location_name .. "' #" .. carrier_rank ..".")
					else
						print("[Ground Equipment " .. version_text_SGES .. "] User has selected the carrier group location #" .. carrier_rank .." which somehow failed to be retrieved.")
					end
					carrier_rank = carrier_rank + 1
				end
			end

			--imgui.Separator()


			-- the dynamic ships :

			if imgui.Button("Carrier",60,20) then
				--~ if IsXPlane12 then
					--~ set_array("sim/operation/override/override_boats", 0, 1)
					--~ set_array("sim/operation/override/override_boats", 1, 1)
				--~ end
				PlaceTheBoat(0)
				heading_flag_selected = 0
			end


			imgui.SameLine()
			if imgui.Button("Frigate",60,20) then
				if IsXPlane12 then
					set_array("sim/operation/override/override_boats", 0, 1)
					set_array("sim/operation/override/override_boats", 1, 1) -- a bug prevents the frigate to really be overriden in XP12
				end
				PlaceTheBoat(1)
				heading_flag_selected = 1
			end
			--imgui.Separator()

			-- set speed and course for the boats, only when located on coordinates
			if IsXPlane12 and sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then
				imgui.SameLine()
				-- display more ships options :
				l_changed, l_newval = imgui.Checkbox(" Steer", GUImoreShip)
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Do not steer to let X-Plane drive the ships.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if l_changed then
						if SGES_Sim_WindDir == nil or SGES_Sim_WindSpd[0] == nil then
							delayed_loading_ships_datarefs()
						end
						GUImoreShip = l_newval
						if not GUImoreShip then -- release the steering to automatic navigation by X-Plane
							boat_manual_control = false
							auto_release_boats()
						--~ else
							--~ if posx ~= nil and posy ~= nil and larg ~= nil then
								--~ float_wnd_set_geometry(groundservices_wnd, posx, posy, 100 + larg, 10)
							--~ end
						end
						-- otherwise display manual steering controls
					end

				if GUImoreShip then
					imgui.Separator()


					imgui.PushItemWidth(130)


					if SGES_Sim_WindDir == nil or SGES_Sim_WindSpd[0] == nil then
						delayed_loading_ships_datarefs()
					end

					if BoatH == nil then BoatH = dataref_table("sim/world/boat/heading_deg","writable") end

					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)

					local changed, newVal = imgui.SliderFloat("W.hdg.from", SGES_Sim_WindDir, 0, 360, "wind " .. math.floor(SGES_Sim_WindDir) .. "°/" .. math.floor(SGES_Sim_WindSpd[0]) .. " kts")--local changed, newVal4 = imgui.SliderFloat("Ship CRS", target_boat_course, 0, 360, "Course " .. math.floor(math.abs(target_boat_course)) .. "°")
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("This is the wind at the user aircraft location (readonly).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end

					if heading_flag_selected == 0 then
						local changed, newVal4 = imgui.SliderFloat("Carrier CRS", BoatH[heading_flag_selected], 0, 360, "Course " .. math.floor(BoatH[heading_flag_selected]) .. "°")
						elseif heading_flag_selected == 1 then
						local changed, newVal4 = imgui.SliderFloat("Frigate CRS", BoatH[heading_flag_selected], 0, 360, "Course " .. math.floor(BoatH[heading_flag_selected]) .. "°")
					end

					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("If you popped up both the frigate and the CVN at the same time their two heading should be close (readonly).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					imgui.PopStyleColor()
					imgui.PopItemWidth()

					if IsXPlane1230 then
						imgui.TextUnformatted("X-Plane 12.3 & above :\n steering disabled\n (flywithlua crash).")
						imgui.SliderFloat("Ship", target_boat_knots, -4, 28, "Speed " .. math.floor(target_boat_knots) .. " kts")
					else
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.PushItemWidth(130)
						local changed, newVal = imgui.SliderFloat("Steering", target_rudder_course, -10, 10, "Rudder " .. math.floor(target_rudder_course) .. "°")
						if changed then
							boat_manual_control = true
							target_rudder_course = newVal
							if target_boat_knots > 299 then target_rudder_course = target_rudder_course*30 end
						end
						imgui.PopItemWidth()


						imgui.PushItemWidth(130)
						local changed, newVal2 = imgui.SliderFloat("Ship speed", target_boat_knots, -4, 28, "Speed " .. math.floor(target_boat_knots) .. " kts")
						-- Maximum speed of the Oliver H Perry frigate should be around 30 knots, I set the max to 28 knots above.
						if changed then
							boat_manual_control = true
							target_boat_knots = newVal2
							target_boat_speed = newVal2*0.514444 -- m/sec
						end
						imgui.PopItemWidth()
						imgui.PopStyleColor()
						imgui.TextUnformatted("Steering is optional.")
						--imgui.TextUnformatted("You don't have to steer.")
						imgui.TextUnformatted("X-Plane can do it by default.")

						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)

						if imgui.TreeNode("Acceleration") then
							if imgui.Button("Jump ahead ON/OFF",130,28) then
								boat_manual_control = true
								if target_boat_knots < 300 then
									target_boat_knots = 300
								else
									-- reinit
									target_boat_knots = 5
									target_rudder_course = 0
								end
								target_boat_speed = target_boat_knots*0.514444 -- m/sec
							end

							imgui.SameLine()

							imgui.TextUnformatted("Caution")
						end

						imgui.PopStyleColor()
					end
					--~ if imgui.Button("Auto. nav.",80,20) then
						--~ boat_manual_control = false
						--~ auto_release_boats()
					--~ end
					imgui.Separator()
				end

			end


			-- static carrier and frigate in XP12 -- SGES v 61.9 change of logic
			if IsXPlane12 then
	          if sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then
				if z_mtr_boats_table ~= nil then
					imgui.Spacing()
				--~ if not GUImoreShip and z_mtr_boats_table ~= nil then --IAS24
					if imgui.SmallButton("On deck !") then
						set("sim/flightmodel/position/local_x",x_mtr_boats_table[0])
						set("sim/flightmodel/position/local_z",z_mtr_boats_table[0])
						set("sim/flightmodel/position/local_y",get("sim/world/boat/y_mtr",0)+21)
						set("sim/cockpit2/controls/parking_brake_ratio",1)
						show_Helicopters = true
						Helicopters_chg = true
					end
					imgui.SameLine()
					if imgui.SmallButton("In hangar !") then
						set("sim/flightmodel/position/local_x",x_mtr_boats_table[0])
						set("sim/flightmodel/position/local_z",z_mtr_boats_table[0])
						set("sim/flightmodel/position/local_y",get("sim/world/boat/y_mtr",0)+9)
						set("sim/cockpit2/controls/parking_brake_ratio",1)
					end
					imgui.Spacing()
				end
			  end

				imgui.TextUnformatted("ACFT LAT/LON: " .. math.floor(LATITUDE*1000)/1000 ..  " / " .. math.floor(LONGITUDE*1000)/1000)
				if GUIcoordinates then
					if imgui.SmallButton("On current coordinates") then
						user_boat_lat  = math.floor(LATITUDE*100000)/100000
						user_boat_lon =  math.floor(LONGITUDE*100000)/100000
						user_boat_location_name = "User coordinates"
					end
				end

				imgui.Separator()
				imgui.Columns(2)
				imgui.SetColumnWidth(0, 110)
				imgui.TextUnformatted("Static ship")
				imgui.NextColumn()
				imgui.TextUnformatted("Moving ship")
				imgui.SameLine()
				imgui.SmallButton("?")
				if imgui.IsItemHovered() then
					sges_ship_cancelled_cause_land = false -- also reset that conveniently
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 18)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Supports :")
					imgui.TextUnformatted("Virginia class sub, Akula class sub, Barbel class sub, Type 45 Destroyer, MEKO 360 frigate, Cavour carrier, USS Tarawa, HMS Eagle.")
					imgui.TextUnformatted("See documentation to install from x-plane.org.")
					imgui.Spacing()
					imgui.TextUnformatted("Credits :")
					imgui.PopStyleColor()
					imgui.Spacing()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					imgui.TextUnformatted("Virginia and Akula, XPJavelin's own work.")
					imgui.TextUnformatted("HMS Eagle by Alpeggio and juanik0, authorized use.")
					imgui.TextUnformatted("MEKO 360 by juanik0, authorized use.")
					imgui.TextUnformatted("USS Tarawa by juanik0 and helodriver89, authorized use.")
					imgui.TextUnformatted("Barbel class SS-581 submarine by Alpeggio, authorized use. Original model by Gacek (3dwarehouse). Alpeggio complied with the 3dwarehouse terms of use as a combined work under the General Model licence (GML).")
					imgui.TextUnformatted("In the SAM site, some armoured vehicles are by Alpeggio, with authorization.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.Columns(1)
				imgui.Columns(2)

				if show_XP12Carrier and Prefilled_XP12Boat == Prefilled_XP12Carrier then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
					l_changed, l_newval = imgui.Checkbox(" Carrier", true)
					imgui.PopStyleColor()
					if l_changed then
						switch_static_sges_boat()
					end
				elseif show_XP12Carrier and Prefilled_XP12Boat == Prefilled_XP12Frigate then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
					l_changed, l_newval = imgui.Checkbox(" Frigate", true)
					imgui.PopStyleColor()
					if l_changed then
						switch_static_sges_boat()
					end
				elseif show_XP12Carrier and Type45Destroyer_Object ~= nil and Prefilled_XP12Boat == Type45Destroyer_Object then
					if Type45Destroyer_Object ~= nil then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26) end
					l_changed, l_newval = imgui.Checkbox(" HMS Dragon", true)
					if Type45Destroyer_Object ~= nil then imgui.PopStyleColor() end
					if l_changed then
						switch_static_sges_boat()
					end
				elseif show_XP12Carrier and Prefilled_XP12Boat == MekoFrigate_Object then
					if MekoFrigate_Object ~= nil then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26) end
					l_changed, l_newval = imgui.Checkbox(" Meko 360", true)
					if MekoFrigate_Object ~= nil then imgui.PopStyleColor() end
					if l_changed then
						switch_static_sges_boat()
					end

				elseif show_XP12Carrier and Prefilled_XP12Boat == TarawaLHA1_Object then
					if TarawaLHA1_Object ~= nil then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26) end
					l_changed, l_newval = imgui.Checkbox(" USS Tarawa", true)
					if TarawaLHA1_Object ~= nil then imgui.PopStyleColor() end
					if l_changed then
						switch_static_sges_boat()
					end

				elseif show_XP12Carrier and Prefilled_XP12Boat == XTrident_NaveCavour_Object then
					if XTrident_NaveCavour_Object ~= nil then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26) end
					l_changed, l_newval = imgui.Checkbox(" Cavour", true)
					if XTrident_NaveCavour_Object ~= nil then imgui.PopStyleColor() end
					if l_changed then
						switch_static_sges_boat()
					end

				elseif show_XP12Carrier and Prefilled_XP12Boat == HMSEagle_Object then
					if HMSEagle_Object ~= nil then imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26) end
					l_changed, l_newval = imgui.Checkbox(" HMS Eagle", true)
					if HMSEagle_Object ~= nil then imgui.PopStyleColor() end
					if l_changed then
						switch_static_sges_boat()
					end

				elseif show_XP12Carrier and Prefilled_XP12Boat == Prefilled_CanoeObject  then
						switch_static_sges_boat() --twice is very important
						switch_static_sges_boat() --twice is very important


				elseif not show_XP12Carrier and  XP12Carrier_instance[0] == nil then
					l_changed, l_newval = imgui.Checkbox(" Select", false)
					if l_changed then
						switch_static_sges_boat()
					end
					if imgui.IsItemActive() and (MekoFrigate_Object == nil or TarawaLHA1_Object == nil or Type45Destroyer_Object == nil) then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 17)
						imgui.TextUnformatted("To add the type 45 destroyer or the Cavour carrier, see our doc Optional_Ships.pdf.")
						--imgui.TextUnformatted("https://forums.x-plane.org/index.php?/files/file/65422-ara-almirante-brown-d10-argentinian-meko-360-class-frigate/")
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				elseif not show_XP12Carrier and  XP12Carrier_instance[0] ~= nil then --sort of transparent "please wait before loading next ship"
					-- should only appear very transitoirely
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						imgui.Checkbox(" Select", true)
					imgui.PopStyleColor()
					-- can stay blocked so, add a transparent unload command if the user force click on that setting because unloading didn't went according to plans :
					if XP12Carrier_instance[0] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[0],rampservicerefXP12Carrier =  common_unload("XP12Carrier",XP12Carrier_instance[0],rampservicerefXP12Carrier) end
					if XP12Carrier_instance[1] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[1],rampservicerefXP12CarrierP2 =  common_unload("XP12Carrier",XP12Carrier_instance[1],rampservicerefXP12CarrierP2) end
					if XP12Carrier_instance[2] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[2],rampservicerefXP12CarrierP3 =  common_unload("XP12Carrier",XP12Carrier_instance[2],rampservicerefXP12CarrierP3) end
					if XP12Carrier_instance[3] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[3],rampservicerefXP12CarrierP4 =  common_unload("XP12Carrier",XP12Carrier_instance[3],rampservicerefXP12CarrierP4) end
					if XP12Carrier_instance[4] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[4],rampservicerefXP12CarrierP5 =  common_unload("XP12Carrier",XP12Carrier_instance[4],rampservicerefXP12CarrierP5) end
					if XP12Carrier_instance[5] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[5],rampservicerefXP12CarrierP6 =  common_unload("XP12Carrier",XP12Carrier_instance[5],rampservicerefXP12CarrierP6) end
					if XP12Carrier_instance[6] ~= nil  then XP12Carrier_chg,XP12Carrier_instance[6],rampservicerefXP12CarrierP7 =  common_unload("XP12Carrier",XP12Carrier_instance[6],rampservicerefXP12CarrierP7) end
				end
				imgui.NextColumn()


				-- I will write "Akula.", not "Akula" because to avoid the impossibility of two same captions on the GUI (see static ships above). Lua doesn't support that.
				if show_Submarine and User_Custom_Prefilled_SubmarineObject ~= nil then
					if string.find(User_Custom_Prefilled_SubmarineObject,"Akula") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Akula.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The Akula-class submarines are nuclear-powered attack submarines developed by the Soviet Union during the 1980s. Known for their stealth, they are designed for anti-submarine and anti-ship warfare. They can carry a mix of torpedoes and cruise missiles, making them highly versatile. Despite being an older design, several Akula-class submarines remain in service with the Russian Navy today.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Virginia") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Virginia.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The Virginia-class submarines are nuclear-powered fast attack submarines serving in the U.S. Navy. Designed for a variety of missions, they specialize in anti-submarine warfare, intelligence gathering, and strike operations. Their advanced stealth technology allows them to operate in both deep and shallow waters. The class continues to be built, with ongoing upgrades to enhance their capabilities.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif (string.find(User_Custom_Prefilled_SubmarineObject,"45") or string.find(User_Custom_Prefilled_SubmarineObject,"Dragon")) then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Dragon.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.TextUnformatted("Not a sub, but a moving vessel.")
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The Type 45 Destroyer, aka the Daring-class, is a British Royal Navy warship designed for advanced air defense, equipped with the Sea Viper missile and stealth technology")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif (string.find(User_Custom_Prefilled_SubmarineObject,"Meko") or string.find(User_Custom_Prefilled_SubmarineObject,"ARA")) then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Meko.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.TextUnformatted("Not a sub, but a moving vessel.")
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The MEKO 360 is a class of multi-purpose frigates designed by the German company Blohm + Voss. These ships are known for their modular design, allowing for flexibility in armaments and equipment. The MEKO 360 was built for export, with Argentina being the main operator.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif (string.find(User_Custom_Prefilled_SubmarineObject,"581") or string.find(User_Custom_Prefilled_SubmarineObject,"Barbel") or string.find(User_Custom_Prefilled_SubmarineObject,"Blueback")) then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Barbel.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The Barbel-class submarines were a series of three diesel-electric submarines built for the U.S. Navy in the late 1950s. They featured a teardrop-shaped hull, which significantly improved underwater speed and maneuverability. These submarines were among the last non-nuclear subs commissioned by the U.S. Navy. The class was retired from service in the 1990s.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Eagle") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Eagle.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.TextUnformatted("Not a sub, but a moving carrier.")
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("HMS Eagle was a British aircraft carrier commissioned in 1951 for the Royal Navy. Originally laid down during World War II, it was modernized several times. Eagle played a key role during the Suez Crisis in 1956. The ship was decommissioned in 1972 and eventually scrapped.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Tarawa") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Tarawa.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.TextUnformatted("Not a sub, but a moving carrier.")
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("USS Tarawa (LHA-1) was the lead ship of the Tarawa-class amphibious assault ships in the U.S. Navy, commissioned in 1976. It was designed to carry Marines, helicopters, and landing craft for amphibious operations, essentially acting as a small aircraft carrier. The ship played a significant role in various military and humanitarian missions over its service life. Tarawa was decommissioned in 2009 after over three decades of service. The last of the class to be decommissionned being USS Peleliu (LHA-5) in 2015. These ships have been replaced by the America-class.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Cavour") then -- X-Plane 12/Resources/plugins/FlyWithLua/Scripts/Simple_Ground_Equipment_and_Services/Nave Cavour/Nimitz.obj
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF3DFF26)
						l_changed, l_newval = imgui.Checkbox(" Cavour.", show_Submarine)
						imgui.PopStyleColor()
						if imgui.IsItemActive() then
							-- Click & hold tooltip
							imgui.BeginTooltip()
							-- This function configures the wrapping inside the toolbox and thereby its width
							imgui.PushTextWrapPos(imgui.GetFontSize() * 16)
							imgui.TextUnformatted("Not a sub, but a moving carrier.")
							imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
							imgui.TextUnformatted("The Italian aircraft carrier Cavour (C550), commissioned in 2009, serves as the flagship of the Italian Navy. It can carry helicopters and F-35B jets, and also supports amphibious operations and humanitarian missions. After recent upgrades, Cavour is fully equipped to operate F-35B aircraft, enhancing its versatility and power.")
							imgui.PopStyleColor()
							-- Reset the wrapping, this must always be done if you used PushTextWrapPos
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
					end
				else
					l_changed, l_newval = imgui.Checkbox(" Select.", show_Submarine)
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Only effective when already above the sea.")
						imgui.PopStyleColor()
						--imgui.TextUnformatted("This eats FPS.") -- shapes optimized in Blender since
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if sges_ship_cancelled_cause_land then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Not above water !")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end

				if l_changed then
					if show_Submarine then
						show_Submarine = false
					else
						switch_moving_sges_boat()
					end
					Submarine_chg = true
				end

				imgui.Columns(1)

				if show_Submarine and sges_gs_ias_spd[0] < 210 and sges_gs_plane_y_agl[0] > 1 and sges_gs_plane_y_agl[0] < 1000 then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)

					if SGES_Sim_WindDir == nil or SGES_Sim_WindSpd[0] == nil then
						delayed_loading_ships_datarefs()
					else
						imgui.SliderFloat("Winds", SGES_Sim_WindDir, 0, 360, "wind " .. math.floor(SGES_Sim_WindDir) .. "°/" .. math.floor(SGES_Sim_WindSpd[0]) .. " kts")
					end
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("This is the wind at the user aircraft location (readonly).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					imgui.PopStyleColor()
				end

			end
			imgui.Separator()
			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
			-- SAM SITE
			--~ imgui.SameLine()
			--~ imgui.TextUnformatted(" ")
			--~ imgui.SameLine()
			if Sam_button_text == nil then Sam_button_text = " SAM " end
			l_changed, l_newval = imgui.Checkbox(Sam_button_text, show_Sam)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("A threat to airplanes in the vicinity. Fly low and fast, drop decoys, or hit the silk ! The SAM site can be destroyed by bombs.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				show_Sam = l_newval
				Sam_chg = true
				if show_Sam and not Threat_module_loaded then
					print("[Ground Equipment " .. version_text_SGES .. "] Will read threat sub-script")
					dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Threat.lua") -- threat module
					dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Cat.lua") -- emulating a cat module
				end
			end
			-- PREVENTS RESPAWN
			imgui.SameLine()
			--~ imgui.TextUnformatted(" ")
			--~ imgui.SameLine()
			l_changed, l_newval = imgui.Checkbox(" No respawn", prevent_respawn)
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Downed AI aircraft in battle won't be respawned.")
				imgui.TextUnformatted("Any plane reaching the combat floor of " .. math.floor(sges_capture_elevation_threshold*3.2809) .. " feet AGL will be disabled.")
				imgui.TextUnformatted("To reborn all airplanes, disable this or start a new flight.")
				imgui.TextUnformatted("For this function to work, kill all your plugins which may control AI planes like PilotEdge.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				prevent_respawn = l_newval
				if prevent_respawn and not sges_respawn_loaded then
					dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_AiDontReborn.lua") -- prevent respawn
				elseif not prevent_respawn and sges_respawn_loaded then
					AcquireAircraft_sges() -- reborn the AI
					ReleaseAircraft_sges()
				end
			end
			if prevent_respawn then
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFC9C9C9)
				imgui.PushItemWidth(110)
				local changed, newVal2 = imgui.SliderFloat(" combat floor", sges_capture_elevation_threshold, 300, 1500, math.floor(sges_capture_elevation_threshold) .. " meters AGL")
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Any active plane reaching the combat floor of " .. math.floor(sges_capture_elevation_threshold*3.2809) .. " feet AGL or below will be disabled.")
					imgui.PopStyleColor()
					imgui.TextUnformatted("Capturing planes above the ground also prevents X-Plane to crash when AI reach the earth. That's why 500 m AGL is the minimum recommanded value.")
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if changed then
					sges_capture_elevation_threshold = newVal2
				end
				imgui.PopItemWidth()
				imgui.TextUnformatted("Anyone < " .. math.floor(sges_capture_elevation_threshold*3.2809) .. "ft AGL is OFF.")
				imgui.PopStyleColor()
			end

			if show_Sam and SamAirport ~= nil then
				imgui.Separator()
				imgui.TextUnformatted(string.sub(SamAirport,1,30))
			end

			--~ if prevent_respawn and (military == 1 or military_default == 1) and BeltLoaderFwdPosition < 6 then
				--~ imgui.Separator()
				--~ if imgui.TreeNode("More...") then
						--~ if imgui.SmallButton("Arm guns") then
							--~ set("sim/cockpit/weapons/guns_armed",1)
						--~ end
						--~ imgui.SameLine()
						--~ if imgui.SmallButton("Disarm guns") then
							--~ set("sim/cockpit/weapons/guns_armed",0)
						--~ end
						--~ if imgui.SmallButton("MASTER ARM on") then
							--~ command_once("sim/cockpit/weapons/master_arm_on")
						--~ end
						--~ imgui.SameLine()
						--~ if imgui.SmallButton("MASTER off") then
							--~ command_once("sim/cockpit/weapons/master_arm_off")
						--~ end
					--~ imgui.TreePop()
				--~ end
			--~ end


			imgui.PopStyleColor()
			imgui.Separator()
			if not Front_Line_chg then
				l_changed, l_newval = imgui.Checkbox(" Front Line", show_Front_Line)
				if l_changed and preselected_Front_line_title ~= "Select" then
					show_Front_Line = l_newval
					Front_Line_chg = true
					if show_Front_Line and sges_Load_locations == nil then
						dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Front_Line.lua") -- Front Line module
					end
				end
				--~ if total_number_of_battles ~= nil then
					--~ imgui.SameLine()
					--~ imgui.TextUnformatted(" (" .. total_number_of_battles .. " battles)")
				--~ end
				--~ imgui.SameLine()
				if preselected_Front_line_title == nil then preselected_Front_line_title = "Select" end
				if imgui.Button(preselected_Front_line_title,200,18) then
					if sges_Load_locations == nil then
						dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Front_Line.lua") -- Front Line module
					end
					front_line_file_path = load_next_profile()
					preselected_Front_line_title = sges_retrieve_profile_title()
				end
			else
				imgui.Checkbox(" Front Line...", false)
			end
			if show_Front_Line and not Front_Line_chg and Front_line_title ~= nil then
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Active : " .. string.sub(Front_line_title,1,21))
				imgui.PopStyleColor()
			end
			imgui.TreePop()
		end

	   end



		if not Mashaller_available and not direct_Marshaller then
			imgui.Separator()
				  -- added 2022
			if show_ArrestorSystem then
				imgui.SetWindowFontScale(0.9)
			  l_changed, l_newval = imgui.Checkbox("Arr.", show_ArrestorSystem) -- for window space reasons I diminush the text
			  imgui.SetWindowFontScale(1.0)
			else
			if BeltLoaderFwdPosition > 4.5 then
			  l_changed, l_newval = imgui.Checkbox("Arrestor", show_ArrestorSystem)
			else
				--~ imgui.SetWindowFontScale(0.95)
				l_changed, l_newval = imgui.Checkbox("Arres.", show_ArrestorSystem)
				--~ imgui.SetWindowFontScale(1.0)
			end
			end
			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Select a landing runway to put the arresting system on. You may change EMAS for a cable or a net barrier.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if l_changed then
				show_ArrestorSystem = l_newval
				if show_ArrestorSystem == false then
					ArrestorSystem_chg = true
				end
				if show_ArrestorSystem == false then
					-- reset everything
					for i=1,12 do
						Runway[i].Name = "**"
					end
					count_runways 	= nil
					runways_t 		= nil
				else
					ArrestorSystemAirportRWY()
					ASonce = 0
					runway_autoselected = true
				end
			end

			if sges_gs_ias_spd[0] < 200 then --IAS24
				if (BeltLoaderFwdPosition <= 4.5 or PLANE_ICAO == "ASB") and IsXPlane12 and not show_ArrestorSystem then
					imgui.SameLine()
					l_changed, l_newval = imgui.Checkbox("Bush", SGES_BushMode)
					  if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("BUSH MODE")
						imgui.TextUnformatted("Variant of the vehicles for remote places.")
						imgui.TextUnformatted("Available for the small aircraft.")
						imgui.PopStyleColor()
						imgui.TextUnformatted("Military mode is still available in combination.")
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if l_changed then
						SGES_BushMode = l_newval
						if military == 1 or military_default == 1 then
							BushObjectsToggle(1)
						else
							BushObjectsToggle(0)
						end
						if SGES_BushMode then show_Pump = false sges_big_airport = false end
					end


				end
				if not show_ArrestorSystem then -- declutter
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.FrameBg,  0xFF444444)
					imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF444444)
					if BeltLoaderFwdPosition > 4.5 or config_options then
						l_changed, l_newval = imgui.Checkbox("Options", config_options)
					else
						l_changed, l_newval = imgui.Checkbox("Op", config_options)
					end
					imgui.PopStyleColor(2)
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Display SGES options")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if l_changed then
						config_options = l_newval
						-- save when closing the options :
						if not config_options then WriteToDisk_SGES_USER_CONFIG() end
					end
				end
			end --IAS24

			if BeltLoaderFwdPosition <= 6.5 and SGES_IsHelicopter == 0 and not show_ArrestorSystem and not config_options then -- management of the clutter
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF444444)
				l_changed, l_newval = imgui.Checkbox("Brief", SGES_HandlingSpeeds)
				imgui.PopStyleColor()
				if l_changed then
					SGES_HandlingSpeeds = l_newval
				end
				if imgui.IsItemActive() or SGES_HandlingSpeeds then
					-- Click & hold tooltip
					imgui.SetNextWindowBgAlpha(0.95)
					imgui.PushStyleColor(imgui.constant.Col.PopupBg,  0xFFB393939)
					imgui.BeginTooltip()
					--~ imgui.PushStyleColor(imgui.constant.Col.PopupBg,  0xFF01CCDD)
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 18)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Handling speeds suggestion based on the X-Plane definition file.")
						imgui.Separator()
						imgui.PopStyleColor()
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFFFFFF)
						imgui.TextUnformatted(sges_flight_profile)
						imgui.PopStyleColor()
						imgui.Separator()
						imgui.Bullet()
						imgui.TextUnformatted("VS0 : " .. sges_acf_Vso[0] .. " KIAS")
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
						imgui.Bullet()
						imgui.TextUnformatted("VS1 : " .. sges_acf_Vs[0] .. " KIAS")
						imgui.PopStyleColor()
						imgui.Bullet()
						imgui.TextUnformatted("Vfe : " .. sges_acf_Vfe[0] .. " KIAS")
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.Bullet()
						imgui.TextUnformatted("Vno : " .. sges_acf_Vno[0] .. " KIAS")
						imgui.PopStyleColor()
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)
						imgui.Bullet()
						imgui.TextUnformatted("Vne : " .. sges_acf_Vne[0] .. " KIAS")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
					imgui.EndTooltip()
					imgui.PopStyleColor()
				end
			end


		end

		if show_ArrestorSystem and Runway[1].Name ~= "**" then

			imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)

			if ArrestorX ~= nil then
				imgui.SameLine() -- added 2022
				l_changed, l_newval = imgui.Checkbox("Cable", IsCable)
				  if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Can only catch aircraft with hook down.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if l_changed then
					ASonce = 0
					IsCable = l_newval
					if IsCable then
						IsEMAS = false
					end
					--show_ArrestorSystem = l_newval
					if  show_ArrestorSystem then
						ArrestorSystem_chg,ArrestorSystem_instance[0],rampservicerefAS = common_unload("ArrestorSystem",ArrestorSystem_instance[0],rampservicerefAS)

						load_ArrestorSystem()
					end
					ArrestorSystem_chg = true
					--if IsCable then
					--	set("sim/cockpit2/switches/tailhook_deploy",1)
					--else
					--	set("sim/cockpit2/switches/tailhook_deploy",0)
					--end
				end

				imgui.SameLine() -- added 2022
				l_changed, l_newval = imgui.Checkbox("EMAS", IsEMAS) -- EMAS
				if l_changed then
					ASonce = 0
					IsEMAS = l_newval
					if IsEMAS then
						IsCable = false
					end
					--show_ArrestorSystem = l_newval
					if  show_ArrestorSystem then
						ArrestorSystem_chg,ArrestorSystem_instance[0],rampservicerefAS = common_unload("ArrestorSystem",ArrestorSystem_instance[0],rampservicerefAS)
						load_ArrestorSystem()
					end
					ArrestorSystem_chg = true
					--if IsCable then
					--	set("sim/cockpit2/switches/tailhook_deploy",1)
					--else
					--	set("sim/cockpit2/switches/tailhook_deploy",0)
					--end
				end

				imgui.SameLine() -- added 2022
				l_changed, l_newval = imgui.Checkbox("Net", IsNet) -- -- for info
				if l_changed then
					ASonce = 0
					IsNet = l_newval
					if IsNet then IsCable = false IsEMAS = false end
					if  show_ArrestorSystem then
						ArrestorSystem_chg,ArrestorSystem_instance[0],rampservicerefAS = common_unload("ArrestorSystem",ArrestorSystem_instance[0],rampservicerefAS)
						load_ArrestorSystem()
					end
					ArrestorSystem_chg = true
				end

			end

			imgui.TextUnformatted("")
			--if tonumber(string.gsub(RunwayEnd_name[1],1,2)) > 18 then RunwayEnd_name[1] = RunwayEnd_name[1] - 18 else RunwayEnd_name[1] = RunwayEnd_name[1] + 18 end
			-- imgui.TextUnformatted("Select ")

			--if string.find(RunwayEnd_name[1],"R") then RunwayEnd_name[1] = string.gsub(RunwayEnd_name[1],"R","L") end
			--if string.find(RunwayEnd_name[1],"L") then RunwayEnd_name[1] = string.gsub(RunwayEnd_name[1],"R","L") end

			for i=1,12 do
				if Runway[i].Name ~= "nil" and Runway[i].Name ~= "**"  then
					if i == 5 then imgui.TextUnformatted("") end
					if i == 9 then imgui.TextUnformatted("") end
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFECECFF)
					if imgui.Button(tostring(Runway[i].Name),40,20) then
						selected = i
						runway_autoselected = false
						ObtainArrestorCoordinates(i)
						ArrestorSystem_chg = true
						print("[Ground Equipment " .. version_text_SGES .. "] Runway " .. Runway[i].Name .. " is now equipped with an arrestor system, near the " .. Runway[i].EndName .. " threshold. ")-- .. Runway[i].outHeading .. "°.")
					end
					imgui.PopStyleColor()
				else
					break
				end
			end
			imgui.PopStyleColor()
		elseif show_ArrestorSystem and Runway[1].Name == "**" then -- no runway found !
			imgui.TextUnformatted("No runway in the vicinity.")
			if  imgui.SmallButton("Rebuild the runways databank",200,20)  then
				includeCustomParkingPositions = true create_parking_position_cache()
				show_ArrestorSystem = false
			end
		end
	--~ end -- ?

	 if sges_gs_ias_spd[0] < 260 and sges_gs_plane_y_agl[0] < 3333 then
		if sges_gs_ias_spd[0] < 200 then --IAS24
			--------------------- specific aircraft code
			if not show_ArrestorSystem and not adjust_Strength then
				imgui.Separator()

				if sges_airport_ID ~= nil then
					--~ if  imgui.Button(sges_airport_ID,35,20)  then
					imgui.PushStyleVar(imgui.constant.StyleVar.FrameRounding, 8)
					if  imgui.Button("WT",20,20)  then
						-- actualize the curr position
						 local weather_x,weather_z,_ =local_to_latlon(sges_gs_plane_x[0],0,sges_gs_plane_z[0])
						open_that_sges_url("https://earth.nullschool.net/fr/#current/wind/isobaric/1000hPa/overlay=precip_3hr/equirectangular/loc=" .. weather_z .. "," .. weather_x)
						--~ open_that_sges_url("https://aviationweather.gov/gfa/?tab=obs&center=" .. weather_x .. "," .. weather_z .. "&zoom=6&pop=yes&tab=obs")
						--~ open_that_sges_url("http://skyvector.com/?ll=" .. weather_x .. "," .. weather_z .. "&chart=304&zoom=3")
						_,sges_airport_ID = sges_nearest_airport_type(sges_big_airport,sges_current_time,"ZZZZ") -- force search with ZZZZ
						--~ if sges_airport_ID ~= nil and not string.find(sges_airport_ID,"X") == 1 then
							if aviationweather_source_us then
								open_that_sges_url("https://aviationweather.gov/data/metar/?ids=" .. sges_airport_ID .. "&taf=1")
							elseif aviationweather_source_eu then
								open_that_sges_url("https://api.met.no/weatherapi/tafmetar/1.0/tafmetar.txt?icao=" .. sges_airport_ID)
							elseif aviationweather_source_es then
								open_that_sges_url("https://www.ogimet.com/display_metars2.php?lang=en&tipo=ALL&ord=REV&nil=SI&fmt=txt&nil=NO&lugar=" .. sges_airport_ID)
							end
						--~ end
					end
					imgui.PopStyleVar()
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Request weather at nearest airport.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					imgui.SameLine()
				end

				if XPLMFindDataRef("bp/connected") ~= nil then -- when the plugin is here, offer a button to it.
				--~ imgui.SameLine()
				if  imgui.Button("BPB",40,20)  then
					command_once("BetterPushback/start")

					show_Chocks = false
					Chocks_chg = true
					config_helper = false -- remove any unwanted displaced click to the developper button just below
					if IsToLiSs then
						set("AirbusFBW/Chocks",0)
					end
				end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("BetterPushback (as installed)")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end
		elseif not adjust_Strength then

			if not show_ArrestorSystem then
				-- if we don't have better push back, anyway we'll manage the window arrangement :
				--imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF222222)
				imgui.Button(" ",19,20)
				imgui.PopStyleColor()
				--imgui.PopStyleColor()
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("BetterPushback (not installed)")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end
		end

		if IsXPlane12 and sges_gs_gnd_spd[0] < 0.1 and (show_Chocks or show_PB or sges_EngineState[0] < 5) and wetness == 0 and not show_ArrestorSystem and not adjust_Strength then



			if XPLMFindDataRef("bp/connected") ~= nil then imgui.SameLine() end
			if  imgui.Button("Jetway",56,20)  then
				command_once("sim/ground_ops/jetway")
				show_StairsXPJ = false
				StairsXPJ_chg = true
				--also stops or remove the passengers if there is no stairs :
				if show_StairsXPJ == false and show_StairsXPJ2 == false and show_Pax then
					show_Pax = l_newval
					Pax_chg = true
					if show_Pax then 	initial_pax_start = true end
				end
				if show_StairsXPJ == false and show_StairsXPJ2 == true then
					BoardStairsXPJ2 = true
					BoardStairsXPJ = false
					DualBoard = false
					StairFinalY = StairFinalY_stairIV
					StairFinalH = StairFinalH_stairIV
					StairFinalX = StairFinalX_stairIV
					InitialPaxHeight = InitialPaxHeight_stairIV
				end
			end

			if imgui.IsItemActive() then
				-- Click & hold tooltip
				imgui.BeginTooltip()
				-- This function configures the wrapping inside the toolbox and thereby its width
				imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
				imgui.TextUnformatted("Actuate the X-Plane 12 jetway in range.")
				imgui.PopStyleColor()
				-- Reset the wrapping, this must always be done if you used PushTextWrapPos
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end

			if sges_openSAM ~= nil then
				if sges_openSAM[0] ~= nil and sges_openSAM[0] == 2 then
					imgui.SameLine()
					if  imgui.Button("SAM jwy.",60,20)  then
						command_once("openSAM/undock_jwy")
					end
				elseif sges_openSAM[0] ~= nil and sges_openSAM[0] == 1 then
					imgui.SameLine()
					if  imgui.Button("SAM jwy",60,20)  then
						command_once("openSAM/dock_jwy")
						show_StairsXPJ = false
						StairsXPJ_chg = true
						--also stops or remove the passengers if there is no stairs :
						if show_StairsXPJ == false and show_StairsXPJ2 == false and show_Pax then
							show_Pax = l_newval
							Pax_chg = true
							if show_Pax then 	initial_pax_start = true end
						end
						if show_StairsXPJ == false and show_StairsXPJ2 == true then
							BoardStairsXPJ2 = true
							BoardStairsXPJ = false
							DualBoard = false
							StairFinalY = StairFinalY_stairIV
							StairFinalH = StairFinalH_stairIV
							StairFinalX = StairFinalX_stairIV
							InitialPaxHeight = InitialPaxHeight_stairIV
						end
					end
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Actuate the jetway using openSAM.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				elseif sges_openSAM[0] ~= nil and sges_openSAM[0] == -1 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
					imgui.Button("SAM jwy.",60,20)
					imgui.PopStyleColor()
				end
			end

		end
		if not adjust_Strength then

			if IsToLiSs and sges_gs_gnd_spd[0] < 10 and not show_ArrestorSystem then -- clean a little the interface at higher speeds
				imgui.SameLine()
				if  imgui.Button("ISCS",40,20)  then -- toliss command menu
					command_once("toliss_airbus/iscs_open")
				end

				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Open ToLiss ISCS.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end

			if PLANE_ICAO == "B742" and string.find(AIRCRAFT_FILENAME,"Felis")  and sges_gs_gnd_spd[0] < 10 and not show_ArrestorSystem then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444444)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
				if  imgui.Button("EFB",50,20)  then -- Felis 742 command menu
					command_once("B742/menu/showHide2D_EFB")
				end
				imgui.PopStyleColor(2)

				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Open Felis EFB.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end


				--~ 0xAABBGGRR
				--~ (A = alpha, puis bleu, vert, rouge)
				--~ Ton 0xFF444444 correspond donc à :
				--~ A = FF
				--~ B = 44
				--~ G = 44
				--~ R = 44

				if (SGES_parkbrake > 0.8 or show_Chocks) and sges_EngineState[0] < 5 and
				sges_strobe_lights_on ~= nil and sges_strobe_lights_on[0] == 0 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF444470)
					if  imgui.Button("B/ST",45,20)  then -- Felis 742
						if step_proc_742 == nil or step_proc_742 == 99 then step_proc_742 = 1 end
						B742ProcNumber = 0
					end
					imgui.PopStyleColor()
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("B742 before start procedure (scripted).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				elseif sges_EngineState[0] >= 5 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF447044)
					if  imgui.Button("B/TO",45,20)  then -- Felis 742
						if step_proc_742 == nil or step_proc_742 == 99 then step_proc_742 = 1 end
						B742ProcNumber = 1
					end
					imgui.PopStyleColor()
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("B742 before takeoff procedure (scripted).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
				-- also display the button to launch the after landing procedure form SGES window, but only with lights on and parkbrake off and engines running !
				if SGES_parkbrake < 1 and sges_EngineState[0] >= 5 and not show_Chocks then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF704470)
					if  imgui.Button("A/LDG",50,20)  then -- Felis 742
						if step_proc_742 == nil or step_proc_742 == 99 then step_proc_742 = 1 end
						B742ProcNumber = 2
						--~ do_often("B742_After_Landing_Procedure_sequence()")
					end
					imgui.PopStyleColor()
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("B742 after landing procedure (scripted).")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
			end

			if PLANE_ICAO == "ch47" and not show_ArrestorSystem then
				imgui.SameLine()
				if  imgui.Button("Chinook",80,20)  then
					command_once("ch47/custom/control_panel")
				end
			end


			if PLANE_ICAO == "DH8D" and sges_gs_gnd_spd[0] < 10 and not show_ArrestorSystem then -- clean a little the interface at higher speeds
				--~ imgui.SameLine()
				--~ imgui.TextUnformatted("Q4XP")
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFCAFFCC)
				imgui.SameLine()
				if  imgui.Button("JPAD",38,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/JPad/Toggle_Popup")
				end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Open FlyJSim JPAD.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end

				imgui.SameLine()
				if  imgui.Button("NWS",40,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/Switches/steering")
				end
				if  imgui.Button("MFD1",35,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/popout/MFD1")
				end
				imgui.SameLine()
				if  imgui.Button("MFD2",35,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/popout/MFD2")
				end
				imgui.SameLine()
				if  imgui.Button("Key",30,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/JPad/Toggle_FMS1_keyboard_input")
				end
				imgui.SameLine()
				if  imgui.Button("Y",16,20)  then -- FlyJSim command menu
					command_once("sim/operation/toggle_yoke")
				end
				imgui.SameLine()
				if  imgui.Button("1L D.",40,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/Animation/Toggle_Main_Cabin_Door")
				end
				imgui.SameLine()
				if  imgui.Button("Doors",40,20)  then -- FlyJSim command menu
					command_once("FJS/Q4XP/Animation/Toggle_Main_Cargo_Door")
					command_once("FJS/Q4XP/Animation/Toggle_Fwd_Right_Cabin_Door")
				end
				if SGES_parkbrake > 0 then
					if get("sim/cockpit/engine/APU_switch") == 1 and get("sim/cockpit/engine/APU_running") == 0 then
						if  imgui.Button("Force APU on",90,15)  then -- FlyJSim command menu
							set("sim/cockpit/engine/APU_running",1)
						end
						imgui.SameLine()
						imgui.TextUnformatted("for debug.")
					end
				end
				imgui.PopStyleColor()
			end

			if PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" and sges_gs_gnd_spd[0] < 10 and not show_ArrestorSystem then -- clean a little the interface at higher speeds
				--~ imgui.SameLine()
				--~ imgui.TextUnformatted("F-104 FXP")
				imgui.SameLine()
				if  imgui.Button("GUI",30,20)  then -- FlyJSim command menu
					command_once("Colimata/F104_FXP/GUI/GUI_window_toggle")
				end
				if imgui.IsItemActive() then
					-- Click & hold tooltip
					imgui.BeginTooltip()
					-- This function configures the wrapping inside the toolbox and thereby its width
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Open Colimata F-104 GUI.")
					imgui.PopStyleColor()
					-- Reset the wrapping, this must always be done if you used PushTextWrapPos
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if  imgui.Button("Checks",50,20)  then -- FlyJSim command menu
					command_once("Colimata/F104_FXP/GUI/CHECKLIST_window_toggle")
				end
			end

			if outsideAirTemp < 1 and sges_gs_gnd_spd[0] > 100 and IsXPlane12 then
				imgui.SameLine()
				if  imgui.Button("Deice !",60,28)  then
					ActiveDeice_shot()
				end
			end


		----------------------------------------------

		-- aircraft specific

			if IsXPlane12 and SGES_IsHelicopter == 1 and sges_gs_plane_y_agl[0] < 80 and sges_gs_gnd_spd[0] < 25 and (AIRCRAFT_FILENAME ~= "Bell412.acf" and AIRCRAFT_FILENAME ~= "AW109SP.acf") and not show_ArrestorSystem then

				imgui.Spacing()
				if config_helper == nil then config_helper = false end
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF222222)
				if  imgui.SmallButton("V" .. version_text_SGES .. "")  then
					if config_helper == false and sges_gs_plane_y_agl[0] < 2 and sges_gs_gnd_spd[0] < 2 then
						config_helper = true
					else
						config_helper = false
					end
				end
				imgui.PopStyleColor()
				imgui.PopStyleColor()

				imgui.SameLine()
				imgui.TextUnformatted("Sling load")
				imgui.SameLine()
				if  imgui.Button("Hook",45,25)  then
					command_once("sim/flight_controls/jettison_reset")
				end
				imgui.SameLine()
				if  imgui.Button("Release",60,25)  then
					command_once("sim/flight_controls/jettison_payload")
				end
				imgui.TextUnformatted("Cable length")
				imgui.SameLine()
				if  imgui.Button("15",20,18)  then
					set("sim/flightmodel/misc/jett_len",15)
					command_once("sim/flight_controls/jettison_reset") -- required or die
				end
				imgui.SameLine()
				if  imgui.Button("35",20,18)  then
					set("sim/flightmodel/misc/jett_len",35)
					command_once("sim/flight_controls/jettison_reset") -- required or die
				end
				imgui.SameLine()
				if  imgui.Button("UP",30,18)  then
					set("sim/flightmodel/misc/jett_len",get("sim/flightmodel/misc/jett_len")-5)
					--if get("sim/flightmodel/misc/jett_len") < 0 then set("sim/flightmodel/misc/jett_len",0) -- no, not suited for callbacks
				end
				imgui.SameLine()
				if  imgui.Button("Down",30,18)  then
					set("sim/flightmodel/misc/jett_len",get("sim/flightmodel/misc/jett_len")+5)
					command_once("sim/flight_controls/jettison_reset") -- required or die
				end

			elseif IsXPlane12 and SGES_IsHelicopter == 1 and AIRCRAFT_FILENAME == "Bell412.acf" and not show_ArrestorSystem then
				imgui.Spacing()
				--~ if  sges_gs_plane_y_agl[0] < 80 and sges_gs_gnd_spd[0] < 25 then
					--~ if  imgui.Button("Remove before flight",160,18)  then
						--~ command_once("412/buttons/remove_before_flight_toggle")
						--~ command_once("412/buttons/PATIENT_off")
					--~ end
				--~ end
				--~ if  imgui.Button("Spotlight",80,18)  then
					--~ command_once("412/buttons/spotlight_toggle")
				--~ end
				--~ imgui.SameLine()
				--~ if  imgui.Button("Hide patient",90,18)  then
					--~ command_once("412/buttons/PATIENT_off")
				--~ end
				if  imgui.Button("Cyclic force trim release",190,18)  then
					command_once("SPECIAL/buttons/cmd_ft_cyc_rel")
				end


			elseif IsXPlane12 and SGES_IsHelicopter == 0 and AIRCRAFT_FILENAME == "Thranda_PC12.acf" and  XPLMFindDataRef("thranda/cockpit/animations/windowmanip") ~= nil  and not show_ArrestorSystem then

				imgui.Spacing()
				if  imgui.Button("Open cargo",86,18)  then
					set_array("thranda/cockpit/animations/door",2,1)
					set_array("thranda/cockpit/animations/doormanip",2,1)
				end
				imgui.SameLine()
				if  imgui.Button("Close cargo",86,18)  then
					set_array("thranda/cockpit/animations/door",2,0)
					set_array("thranda/cockpit/animations/doormanip",2,0)
				end

				imgui.SameLine()
				if config_helper == nil then config_helper = false end
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF222222)
				if  imgui.SmallButton("V" .. version_text_SGES .. "")  then
					if config_helper == false and sges_gs_plane_y_agl[0] < 2 and sges_gs_gnd_spd[0] < 2 then
						config_helper = true
					else
						config_helper = false
					end
				end
				imgui.PopStyleColor()
				imgui.PopStyleColor()

				if  imgui.Button("Open windows",86,18)  then
					set_array("thranda/cockpit/animations/windowmanip",21,0)
					set_array("thranda/cockpit/animations/windowmanip",22,0)
					set_array("thranda/cockpit/animations/windowmanip",23,0)
					set_array("thranda/cockpit/animations/windowmanip",24,0)
					set_array("thranda/cockpit/animations/windowmanip",25,0)
					set_array("thranda/cockpit/animations/windowmanip",26,0)
					set_array("thranda/cockpit/animations/windowmanip",27,0)
					set_array("thranda/cockpit/animations/windowmanip",28,0)
					set_array("thranda/cockpit/animations/windowmanip",29,0)
					set_array("thranda/cockpit/animations/windowmanip",30,0)
				end
				imgui.SameLine()
				if  imgui.Button("Close windows",86,18)  then
					set_array("thranda/cockpit/animations/windowmanip",23,1)
					set_array("thranda/cockpit/animations/windowmanip",24,1)
					set_array("thranda/cockpit/animations/windowmanip",25,1)
					set_array("thranda/cockpit/animations/windowmanip",26,1)
					set_array("thranda/cockpit/animations/windowmanip",27,1)
					set_array("thranda/cockpit/animations/windowmanip",28,1)
					set_array("thranda/cockpit/animations/windowmanip",29,1)
					set_array("thranda/cockpit/animations/windowmanip",30,1)
				end
				imgui.SameLine()
				if  imgui.Button("Panel",40,18)  then
					command_once("thranda/switches/SwitchUp15")
					command_once("thranda/switches/SwitchUp18")
				end

			elseif IsXPlane12 and SGES_IsHelicopter == 1 and AIRCRAFT_FILENAME == "AW109SP.acf" and not show_ArrestorSystem then
				imgui.Spacing()
				if config_helper == nil then config_helper = false end
				imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF222222)
				if  imgui.SmallButton("V" .. version_text_SGES .. "")  then
					if config_helper == false and sges_gs_plane_y_agl[0] < 2 and sges_gs_gnd_spd[0] < 2 then
						config_helper = true
					else
						config_helper = false
					end
				end
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.SameLine()
				if  sges_gs_plane_y_agl[0] < 1 and sges_gs_gnd_spd[0] < 5 then
					if  imgui.Button("Remove RbF",110,18)  then
						set("aw109/anim/rbf/cowling_left",0)
						set("aw109/anim/rbf/cowling_right",0)
						set("aw109/anim/rbf/engine1_cover",0)
						set("aw109/anim/rbf/engine1_plug",0)
						set("aw109/anim/rbf/engine2_cover",0)
						set("aw109/anim/rbf/engine2_plug",0)
						set("aw109/anim/rbf/pitot_left",0)
						set("aw109/anim/rbf/pitot_right",0)
						--~ set("aw109/anim/rbf/ignore",0)
						set("aw109/anim/door",2,0)
						set("aw109/anim/door",3,0)
					end
					imgui.SameLine()

					if  imgui.Button("Add RbF",60,18)  then
						set("aw109/anim/rbf/cowling_left",1)
						set("aw109/anim/rbf/cowling_right",1)
						set("aw109/anim/rbf/engine1_cover",1)
						set("aw109/anim/rbf/engine1_plug",1)
						set("aw109/anim/rbf/engine2_cover",1)
						set("aw109/anim/rbf/engine2_plug",1)
						set("aw109/anim/rbf/pitot_left",1)
						set("aw109/anim/rbf/pitot_right",1)
						--~ set("aw109/anim/rbf/ignore",1)
					end
				end


				--~ if  imgui.Button("control_panel",60,18)  then -- non existent May 2024
					--~ command_once("aw109/config_widget/show")
					--~ set("aw109/config_widget/page",1)
					--~ command_once("ch47/custom/control_panel")
				--~ end

				if imgui.TreeNode(AIRCRAFT_FILENAME) then


					if  imgui.Button("Close doors",100,18)  then
						set_array("aw109/anim/door",0,0)
						set_array("aw109/anim/door",1,0)
						set_array("aw109/anim/door",2,0)
						set_array("aw109/anim/door",3,0)


						set_array("aw109/anim/door_handle",0,1)
						set_array("aw109/anim/door_handle",1,1)
						set_array("aw109/anim/door_handle",2,1)
						set_array("aw109/anim/door_handle",3,1)
					end
						imgui.SameLine()
					if  imgui.Button("Open doors",90,18)  then
						set_array("aw109/anim/door",0,1)
						set_array("aw109/anim/door",1,1)
						set_array("aw109/anim/door",2,0.75)
						set_array("aw109/anim/door",3,1)
					end

					if  imgui.Button("Close cabin door",100,18)  then
						set_array("aw109/anim/door",0,0)
						set_array("aw109/anim/door",1,0)

						set_array("aw109/anim/door_handle",0,1)
						set_array("aw109/anim/door_handle",1,1)
					end
						imgui.SameLine()
					if  imgui.Button("Open cabin door",90,18)  then
						set_array("aw109/anim/door",0,0.8)
						set_array("aw109/anim/door",1,0.85)
						if get("aw109/variants/sliding_step_right") == 0 then
							-- RIGHT DOOR
							set_array("aw109/anim/door",1,1)
							-- LEFT DOOR
							set_array("aw109/anim/door",0,1)
						end
					end

					if  imgui.Button("Remove cabin door",120,18)  then
						set_array("aw109/anim/door",0,2000)
						set_array("aw109/anim/door",1,2000)
					end

					imgui.SameLine()

					if  imgui.Button("Load",40,18)  then
						command_once("aw109/menu/options/anim")
					end
				    if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("aw109/menu/options/anim")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					--~ if  imgui.Button("Spotlight",80,18)  then
						--~ command_once("412/buttons/spotlight_toggle")
					--~ end
					--~ imgui.SameLine()
					--~ if  imgui.Button("Hide patient",90,18)  then
						--~ command_once("412/buttons/PATIENT_off")
					--~ end
					imgui.Separator()
					imgui.TextUnformatted("")
					imgui.PushStyleColor(imgui.constant.Col.FrameBg,  0xFF444444)
					imgui.PushStyleColor(imgui.constant.Col.FrameBgHovered,  0xFF444444)
					if  imgui.Button("Cyclic force trim release",190,18)  then
						command_once("SPECIAL/buttons/cmd_ft_cyc_rel")
					end
					if  imgui.Button("Use hat switch as trim",190,18)  then
						command_once("SPECIAL/buttons/trim_shift")
					end
					if  imgui.Button("Disengage upper AP modes",190,18)  then
						command_once("aw109/cyclic/att")
					end
					if  imgui.Button("Collective force trim release",190,18)  then
						command_once("SPECIAL/buttons/cmd_ft_col_rel")
					end
					if  imgui.Button("Pedals force trim release",190,18)  then
						command_once("SPECIAL/buttons/cmd_ft_ped_rel")
					end
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.TreePop()
				end
			else -- in order to simplify the GUI, I don't display the SGES etadata when an helicopter in XP12, to avoid the overdose of information
				--imgui.Separator()
				if UseXplaneDefaultObject then
					imgui.TextUnformatted("Uses X-Plane default objects.")
				end
					if config_helper == nil then config_helper = false end
					imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
					imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF222222)
					if  imgui.SmallButton("V" .. version_text_SGES .. "")  then
						if config_helper == false and sges_gs_plane_y_agl[0] < 2 and sges_gs_gnd_spd[0] < 2 then
							config_helper = true
						else
							config_helper = false
						end
					end
					imgui.PopStyleColor()
					imgui.PopStyleColor()
				    if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Developer mode available on the ground. Do not use if you are not sure.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end

					imgui.SameLine()
					imgui.TextUnformatted("t+ " .. string.format("%03d",math.floor((SGES_total_flight_time_sec/60)+0.5)) .. " min.")


					if IsXPlane12 and (GUImoreShip or Go_PB) then
						imgui.SameLine()
						imgui.TextUnformatted(" GS " .. math.floor(sges_gs_gnd_spd[0]) .. " kts.")
					elseif IsXPlane12 then
						imgui.SameLine()
						imgui.TextUnformatted(string.format("%02d",SGES_zulu_time_in_simulator_hours[0]) .. ":" .. string.format("%02d",SGES_local_time_in_simulator_mins[0]) .. " z")
					end

					if sges_gs_gnd_spd[0] < 10 and sges_fps ~= nil then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6a6a6a)
						imgui.TextUnformatted(math.floor(sges_fps))
						imgui.PopStyleColor()
					end

					--~ imgui.Spacing()
					--~ imgui.SameLine()
					--~ if  imgui.SmallButton("Save window position")  then
						--~ SGES_WriteToDisk()
					--~ end

			end
			imgui.PopStyleColor()

		end -- adjust_Strength


			--~ imgui.SameLine()
			--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF7D7D7D)
			--~ imgui.PushStyleColor(imgui.constant.Col.Button,  0xFF000000)
		    --~ if  imgui.SmallButton("Dev.")  then
				--~ if config_helper == false then
					--~ config_helper = true
				--~ else
					--~ config_helper = false
				--~ end
			--~ end
			--~ imgui.PopStyleColor()
			--~ imgui.PopStyleColor()
			if config_helper then

				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
				imgui.Separator()
				--~ imgui.TextUnformatted("Developer only. This page will \nallow to research in live \nthe configuration to be \nlater hand written in the \naircraft configuration file.\n")
				imgui.TextUnformatted("Developer mode.\n\nThis page will \nallow to research in live \nthe configuration and \nsave it in an optional \naircraft user profile.")

				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				if  imgui.Button("Close this page",125,23)  then
					config_helper = false
				end
				imgui.PopStyleColor()
				imgui.TextUnformatted("")
				if AIRCRAFT_FILENAME ~= nil then imgui.TextUnformatted(AIRCRAFT_FILENAME) end
				if PLANE_ICAO ~= nil then imgui.TextUnformatted(PLANE_ICAO) imgui.SameLine() if sges_airport_ID ~= nil then imgui.TextUnformatted("at " .. sges_airport_ID) end end
				if IsToLiSs then imgui.TextUnformatted("Is a ToLiSs model.") end

				if IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1 then
					imgui.TextUnformatted("Is declared as an helicopter (acf).")
				end
				if IsXPlane12 and SGES_IsAirliner ~= nil and SGES_IsAirliner == 1 then
					imgui.TextUnformatted("Is declared as an airliner (acf).")
				end

				if file_exists(SCRIPT_DIRECTORY .. "SimLoadManager.lua") and not IsToLiSs then
					-- SimLoadManager by RackhamRPL
					-- https://forums.x-plane.org/index.php?/files/file/93858-simload-manager
					--~ imgui.SameLine()
					if imgui.Button("SLM",33,20)  then
						--~ start_embarkation()
					end
					if imgui.IsItemActive() then
						-- Click & hold tooltip
						imgui.BeginTooltip()
						-- This function configures the wrapping inside the toolbox and thereby its width
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("SimLoadManager.lua by RackhamRPL is installed.")
						imgui.TextUnformatted("This button does nothing at the moment.")
						imgui.PopStyleColor()
						-- Reset the wrapping, this must always be done if you used PushTextWrapPos
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
				-------------------------------------------------------
				imgui.Separator()
				imgui.TextUnformatted("")
				if imgui.TreeNode("MASTER PARAMETER (fwd loader)") then
					imgui.PopStyleColor(2)
					imgui.TextUnformatted("Front loader (required)")
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)
					imgui.PushStyleColor(imgui.constant.Col.ButtonHovered,  0xFF555555)
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Beltloader.jpg"), 130, 110)
					if  imgui.SmallButton("F--")  then
						BeltLoaderFwdPosition = BeltLoaderFwdPosition - 0.5
						developer_change()
					end
					imgui.SameLine()
					if  imgui.SmallButton("Fl -")  then
						BeltLoaderFwdPosition = BeltLoaderFwdPosition - 0.1
						developer_change()
					end

					imgui.SameLine()
					if BeltLoaderFwdPosition ~= nil then imgui.TextUnformatted(string.format("%.02f",BeltLoaderFwdPosition)) else imgui.TextUnformatted("ABNORMAL") end
				    --~ if imgui.IsItemHovered() then BeltLoaderFwdPosition = SGES_mouse_wheel_action(BeltLoaderFwdPosition)	 end
					imgui.SameLine()
					if  imgui.SmallButton("Fl +")  then
						BeltLoaderFwdPosition = BeltLoaderFwdPosition + 0.1
						developer_change()
					end
					imgui.SameLine()
					if  imgui.SmallButton("F++")  then
						BeltLoaderFwdPosition = BeltLoaderFwdPosition + 0.5
						developer_change()
					end

					imgui.Spacing()
					if imgui.TreeNode("Left hand side cargo") then
						_,plane_has_cargo_hold_on_the_left_hand_side = imgui.Checkbox("Plane has cargo holds on\n the left hand side",plane_has_cargo_hold_on_the_left_hand_side)
						imgui.TreePop()
					end

					imgui.TreePop()
				end
				imgui.Separator()

				-------------------------------------------------------

				if imgui.TreeNode("Rear loader (optional)") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Rearloader.jpg"), 130, 110)
					if  imgui.SmallButton("Rl -")  then
						if BeltLoaderRearPosition == nil then BeltLoaderRearPosition = -10 end
						BeltLoaderRearPosition = BeltLoaderRearPosition - 0.1
						RearBeltLoader_chg = true
					end
					imgui.SameLine()
					if BeltLoaderRearPosition ~= nil then imgui.TextUnformatted(string.format("%.02f",BeltLoaderRearPosition))  else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Rl +")  then
						if BeltLoaderRearPosition == nil then BeltLoaderRearPosition = -10 end
						BeltLoaderRearPosition = BeltLoaderRearPosition + 0.1
						RearBeltLoader_chg = true
					end
					imgui.TreePop()
				end


				-------------------------------------------------------

				--~ imgui.Separator()
				imgui.Spacing()
				imgui.Spacing()
				imgui.Separator()
				if imgui.TreeNode("Front stairs") then
					imgui.TextUnformatted("Stairs Mark III.")
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Frontstairs.jpg"), 130, 110)
					imgui.TextUnformatted("Front stairs longitudinal pos.")
					if targetDoorZ ~= nil  and targetDoorZ ~= nil then imgui.TextUnformatted(math.floor(targetDoorZ + targetDoorZ_alternate)) else imgui.TextUnformatted("nil") end
					--imgui.SameLine()
					imgui.TextUnformatted("(from Plane Maker)")

					imgui.TextUnformatted("Front stairs longitudinal adjust")
					--~ if  imgui.SmallButton("Fl -")  then
						--~ targetDoorZ_alternate = targetDoorZ_alternate - 0.1
						--~ StairsXPJ_chg = true
					--~ end
					--~ imgui.SameLine()
					if targetDoorZ_alternate ~= nil then imgui.TextUnformatted(string.format("%.02f",targetDoorZ_alternate)) else imgui.TextUnformatted("nil") end
					--~ imgui.SameLine()
					--~ if  imgui.SmallButton("Fl +")  then
						--~ targetDoorZ_alternate = targetDoorZ_alternate + 0.1
						--~ StairsXPJ_chg = true
					--~ end

					imgui.TextUnformatted("Front stairs vertical pos.")
					if  imgui.SmallButton("Fv -")  then
						vertical_door_position = vertical_door_position - 0.1
						StairsXPJ_chg = true
					end
					imgui.SameLine()
					if vertical_door_position ~= nil then imgui.TextUnformatted(string.format("%.02f",vertical_door_position)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Fv +")  then
						vertical_door_position = vertical_door_position + 0.1
						StairsXPJ_chg = true
					end
					imgui.TextUnformatted("Front stairs lat. distance")
					if  imgui.SmallButton("Fd -")  then
						deltaDoorX = deltaDoorX - 0.05
						StairsXPJ_chg = true
					end
					imgui.SameLine()
					if deltaDoorX ~= nil then imgui.TextUnformatted(string.format("%.02f",deltaDoorX)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Fd +")  then
						deltaDoorX = deltaDoorX + 0.05
						StairsXPJ_chg = true
					end
					imgui.TreePop()
				end



				-------------------------------------------------------
				if (SecondStairsFwdPosition ~= -30 and BeltLoaderFwdPosition >= 17) then
					imgui.Separator()
					if imgui.TreeNode("Middle stairs (optional)") then
						imgui.TextUnformatted("Stairs Mark V.")
						imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Thirdstairs.jpg"), 130, 110)
						imgui.Spacing()
						imgui.TextUnformatted("Conditional to III & IV stairs")
						imgui.Spacing()
						imgui.TextUnformatted("Third stairs longitudinal pos.")
						if  imgui.SmallButton("3s -")  then
							longitudinal_factor3 = longitudinal_factor3 - 0.3
							show_StairsXPJ3 = true
							StairsXPJ3_chg = true
						end
						imgui.SameLine()
						if longitudinal_factor3 ~= 0 then imgui.TextUnformatted(string.format("%.02f",longitudinal_factor3)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("3s +")  then
							longitudinal_factor3 = longitudinal_factor3 + 0.3
							show_StairsXPJ3 = true
							StairsXPJ3_chg = true
						end

					-------------------------------------------------------

						imgui.TextUnformatted("3rd stairs vertical pos.")
						if  imgui.SmallButton("3Vp -")  then
							height_factor3 = height_factor3 - 0.1
							if height_factor3 > -0.05 and height_factor3 < 0.05 then height_factor3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.SameLine()
						if height_factor3 ~= nil then imgui.TextUnformatted(string.format("%.02f",height_factor3)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("3Vp +")  then
							height_factor3 = height_factor3 + 0.1
							if height_factor3 > -0.05 and height_factor3 < 0.05 then height_factor3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.TextUnformatted("3rd stairs lat. distance")
						if  imgui.SmallButton("3Ld -")  then
							lateral_factor3 = lateral_factor3 - 0.05
							if lateral_factor3 > -0.05 and lateral_factor3 < 0.05 then lateral_factor3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.SameLine()
						if lateral_factor3 ~= nil then imgui.TextUnformatted(string.format("%.02f",lateral_factor3)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("3Ld +")  then
							lateral_factor3 = lateral_factor3 + 0.05
							if lateral_factor3 > -0.05 and lateral_factor3 < 0.05 then lateral_factor3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.TextUnformatted("3rd stairs heading.")
						if  imgui.SmallButton("3Sh -")  then
							sges_gs_plane_head_correction3 = sges_gs_plane_head_correction3 - 0.5
							if sges_gs_plane_head_correction3 > -0.05 and sges_gs_plane_head_correction3 < 0.05 then sges_gs_plane_head_correction3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.SameLine()
						if sges_gs_plane_head_correction3 ~= nil then imgui.TextUnformatted(string.format("%.02f",sges_gs_plane_head_correction3)) else imgui.TextUnformatted("nil") sges_gs_plane_head_correction3 = 0 end -- avoid FWL crash
						imgui.SameLine()
						if  imgui.SmallButton("3Sh +")  then
							sges_gs_plane_head_correction3 = sges_gs_plane_head_correction3 + 0.5
							if sges_gs_plane_head_correction3 > -0.05 and sges_gs_plane_head_correction3 < 0.05 then sges_gs_plane_head_correction3 = 0 end
							StairsXPJ3_chg = true
						end
						imgui.TextUnformatted("|Angle limit for pax| = 0.2")

						--~ if math.abs(sges_gs_plane_head_correction3) > 0.2 then
							--~ imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Paxunfriendly.jpg"), 130, 110)
						--~ else
							--~ imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Paxfriendly.jpg"), 130, 110)
						--~ end
						-------------------------------------------------------

						imgui.TreePop()
					end
				else

					imgui.Separator()
					if imgui.TreeNode("Middle stairs (not avail.)") then
						imgui.TextUnformatted("Stairs Mark V.")
						imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Thirdstairs.jpg"), 130, 110)
						imgui.TextUnformatted("Not available.")
						imgui.TextUnformatted("This aircraft is too small.")
						imgui.TreePop()
					end
				end

				-------------------------------------------------------

				imgui.Separator()
				if imgui.TreeNode("Rear stairs (optional)") then
					imgui.TextUnformatted("Stairs Mark IV.")
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Rearstairs.jpg"), 130, 110)
					imgui.TextUnformatted("Rear stairs longitudinal pos.")
					if  imgui.SmallButton("Rs -")  then
						SecondStairsFwdPosition = SecondStairsFwdPosition - 0.3
						StairsXPJ2_chg = true
					end
					imgui.SameLine()
					if SecondStairsFwdPosition ~= -30 then imgui.TextUnformatted(string.format("%.02f",SecondStairsFwdPosition)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Rs +")  then
						SecondStairsFwdPosition = SecondStairsFwdPosition + 0.3
						StairsXPJ2_chg = true
					end

					-------------------------------------------------------

					imgui.TextUnformatted("Rear stairs vertical pos.")
					if  imgui.SmallButton("Vp -")  then
						vertical_door_position2 = vertical_door_position2 - 0.1
						StairsXPJ2_chg = true
					end
					imgui.SameLine()
					if vertical_door_position2 ~= nil then imgui.TextUnformatted(string.format("%.02f",vertical_door_position2)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Vp +")  then
						vertical_door_position2 = vertical_door_position2 + 0.1
						StairsXPJ2_chg = true
					end
					imgui.TextUnformatted("Rear stairs lat. distance")
					if  imgui.SmallButton("Ld -")  then
						deltaDoorX2 = deltaDoorX2 - 0.05
							if deltaDoorX2 > -0.05 and deltaDoorX2 < 0.05 then deltaDoorX2 = 0 end
						StairsXPJ2_chg = true
					end
					imgui.SameLine()
					if deltaDoorX2 ~= nil then imgui.TextUnformatted(string.format("%.02f",deltaDoorX2)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("Ld +")  then
						deltaDoorX2 = deltaDoorX2 + 0.05
							if deltaDoorX2 > -0.05 and deltaDoorX2 < 0.05 then deltaDoorX2 = 0 end
						StairsXPJ2_chg = true
					end
					imgui.TextUnformatted("Rear stairs heading.")
					if  imgui.SmallButton("Sh -")  then
						sges_gs_plane_head_correction2 = sges_gs_plane_head_correction2 - 0.1
							if sges_gs_plane_head_correction2 > -0.05 and sges_gs_plane_head_correction2 < 0.05 then sges_gs_plane_head_correction2 = 0 end
						StairsXPJ2_chg = true
					end
					imgui.SameLine()
					if sges_gs_plane_head_correction2 ~= nil then imgui.TextUnformatted(string.format("%.02f",sges_gs_plane_head_correction2)) else imgui.TextUnformatted("nil") sges_gs_plane_head_correction2 = 0 end -- avoid FWL crash
					imgui.SameLine()
					if  imgui.SmallButton("Sh +")  then
						sges_gs_plane_head_correction2 = sges_gs_plane_head_correction2 + 0.1
							if sges_gs_plane_head_correction2 > -0.05 and sges_gs_plane_head_correction2 < 0.05 then sges_gs_plane_head_correction2 = 0 end
						StairsXPJ2_chg = true
					end
					imgui.TextUnformatted("|Angle limit for pax| = 0.2")

						if math.abs(sges_gs_plane_head_correction2) >= 0.3 then
							imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Paxunfriendly.jpg"), 130, 110)
							imgui.TextUnformatted("Geometry not friendly for pax")
						else
							imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Paxfriendly.jpg"), 130, 110)
						end

					imgui.TreePop()
				end

				imgui.Spacing()
				imgui.Spacing()
				if show_ULDLoader then
					imgui.Separator()
					if imgui.TreeNode("ULD loader (cargo deck)") then
						imgui.TextUnformatted("Loader position : " .. ULDLoaderFwdPositionFactor)
						imgui.TextUnformatted("(Edited in main script).")
						imgui.TreePop()
					end
				end

				-------------------------------------------------------
				imgui.Spacing()
				imgui.Spacing()
				if SGES_stairs_type == "Boarding_without_stairs" then
					imgui.Separator()
					if imgui.TreeNode("Direct boarding (optional)") then
						imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/NoStairs.jpg"), 130, 110)
						Adjust_Alternate_Passenger_Attachement_Point_via_sliders()
						imgui.TextUnformatted("Door location for small air-\ncraft without stairs.")
						if  imgui.Button("Erase",44,20)  then
							targetDoorX_alternate = 0
							targetDoorX_alternate_boarding = 0
							targetDoorZ_alternate = 0
							targetDoorH_alternate = 0
							l_changed = true
							StairsXPJ_chg = true
						end
						imgui.SameLine()
						imgui.TextUnformatted("(Prevents saving).")
						imgui.TextUnformatted("This is only saved when \nboarding without stairs is\navailable for the current\nmachine.")
						imgui.TreePop()
					end
				else
					imgui.Separator()
					if imgui.TreeNode("Direct boarding (unavail.)") then
						imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/NoStairsUnavail.jpg"), 130, 110)
						imgui.TextUnformatted("Not for this aircraft.")
						imgui.TextUnformatted("Use stairs.")
						imgui.TreePop()
					end
				end
				-------------------------------------------------------

				--~ imgui.Separator()
				imgui.Spacing()
				imgui.Spacing()
				imgui.Separator()
				if imgui.TreeNode("Air start (optional)") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/AsuAcu.jpg"), 130, 110)
					if  imgui.SmallButton("As -")  then
						airstart_unit_factor = airstart_unit_factor - 1
						show_ASU = true
						developer_change()
					end
					imgui.SameLine()
					if airstart_unit_factor ~= nil then imgui.TextUnformatted(string.format("%.02f",airstart_unit_factor)) else imgui.TextUnformatted("nil") end
					imgui.SameLine()
					if  imgui.SmallButton("As +")  then
						airstart_unit_factor = airstart_unit_factor + 1
						show_ASU = true
						developer_change()
					end
					imgui.TextUnformatted("Change only for 3D\nconflicts.")
					imgui.TreePop()
				end
				-------------------------------------------------------
				imgui.Separator()
				if imgui.TreeNode("Refueling truck (optional)") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Fuel.jpg"), 130, 110)
					if show_FUEL then
						if  imgui.SmallButton("Rx -")  then
							if custom_fuel_finalX == nil then custom_fuel_finalX = fuel_finalX end
							custom_fuel_finalX = custom_fuel_finalX - 1
						end
						imgui.SameLine()
						if custom_fuel_finalX ~= nil then imgui.TextUnformatted(string.format("%.02f",custom_fuel_finalX)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("Rx +")  then
							if custom_fuel_finalX == nil then custom_fuel_finalX = fuel_finalX end
							custom_fuel_finalX = custom_fuel_finalX + 1
						end

						imgui.SameLine() imgui.TextUnformatted("Lateral")

						if  imgui.SmallButton("Ry -")  then
							if custom_fuel_finalY == nil then custom_fuel_finalY = fuel_finalY end
							custom_fuel_finalY = custom_fuel_finalY - 1
						end

						imgui.SameLine()
						if custom_fuel_finalY ~= nil then imgui.TextUnformatted(string.format("%.02f",custom_fuel_finalY)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("Ry +")  then
							if custom_fuel_finalY == nil then custom_fuel_finalY = fuel_finalY end
							custom_fuel_finalY = custom_fuel_finalY + 1
						end

						imgui.SameLine() imgui.TextUnformatted("Longit.")

						if custom_fuel_finalX ~= nil and custom_fuel_finalY ~= nil then
							if imgui.SmallButton("Actuate Fuel truck")  then

								fuel_currentY = custom_fuel_finalY - 0.1
								FuelFinalY = custom_fuel_finalY

								fuel_currentX = custom_fuel_finalX - 2 	-- developer mode offset
								FuelFinalX = custom_fuel_finalX - 2		 -- developer mode offset

								fuel_heading = sges_gs_plane_head[0] - 28

								show_Fuel = true
								developer_change()
							end
						end


					else
						l_changed, l_newval = imgui.Checkbox(" Show the fuel truck", show_FUEL)
						if l_changed then
							show_Pump = false
							show_FUEL = l_newval
							FUEL_chg = true
						end
					end

					imgui.TreePop()
				end

-------------------------------------------------------
				imgui.Separator()
				if imgui.TreeNode("Hydrant dispenser (optional)") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/FuelPump.jpg"), 130, 110)



					if custom_fuel_finalX ~= nil and custom_fuel_finalY ~= nil then
						if imgui.SmallButton("Copy from fuel truck")  then
							custom_fuel_pump_finalY = custom_fuel_finalY
							custom_fuel_pump_finalX = custom_fuel_finalX
						end
					end

					if show_FUEL then
						if  imgui.SmallButton("Px -")  then
							if custom_fuel_pump_finalX == nil then custom_fuel_pump_finalX = fuel_finalX end
							custom_fuel_pump_finalX = custom_fuel_pump_finalX - 0.5
						end
						imgui.SameLine()
						if custom_fuel_pump_finalX ~= nil then imgui.TextUnformatted(string.format("%.02f",custom_fuel_pump_finalX)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("Px +")  then
							if custom_fuel_pump_finalX == nil then custom_fuel_pump_finalX = fuel_finalX end
							custom_fuel_pump_finalX = custom_fuel_pump_finalX + 0.5
						end
						imgui.SameLine()
						if  imgui.SmallButton("Px ++")  then
							if custom_fuel_pump_finalX == nil then custom_fuel_pump_finalX = fuel_finalX end
							custom_fuel_pump_finalX = custom_fuel_pump_finalX + 2
						end

						imgui.SameLine() imgui.TextUnformatted("Lateral")

						if  imgui.SmallButton("Py -")  then
							if custom_fuel_pump_finalY == nil then custom_fuel_pump_finalY = fuel_finalY end
							custom_fuel_pump_finalY = custom_fuel_pump_finalY - 0.5
						end

						imgui.SameLine()
						if custom_fuel_pump_finalY ~= nil then imgui.TextUnformatted(string.format("%.02f",custom_fuel_pump_finalY)) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("Py +")  then
							if custom_fuel_pump_finalY == nil then custom_fuel_pump_finalY = fuel_finalY end
							custom_fuel_pump_finalY = custom_fuel_pump_finalY + 0.5
						end


						imgui.SameLine() imgui.TextUnformatted("Longit.")

						if custom_fuel_pump_finalX ~= nil and custom_fuel_pump_finalY ~= nil then
							if imgui.SmallButton("Actuate dispenser")  then

								fuel_currentY = custom_fuel_pump_finalY - 0.1
								FuelFinalY = custom_fuel_pump_finalY

								if show_Pump and custom_fuel_pump_finalX < -2  then
									fuel_heading = sges_gs_plane_head[0] + 10
									Fuel_heading_correcting_factor = 10
									fuel_currentX = custom_fuel_pump_finalX - 3.5 	-- developer mode offset
									FuelFinalX = custom_fuel_pump_finalX - 3.5		 -- developer mode offset
								else
									fuel_heading = sges_gs_plane_head[0] - 28
									Fuel_heading_correcting_factor = - 28
									fuel_currentX = custom_fuel_pump_finalX - 2 	-- developer mode offset
									FuelFinalX = custom_fuel_pump_finalX - 2		 -- developer mode offset
								end

								show_Fuel = true
								developer_change()
							end
						end


					else
						l_changed, l_newval = imgui.Checkbox(" Show the hydrant dispenser", show_FUEL)
						if l_changed then
							show_Pump = true
							show_FUEL = l_newval
							FUEL_chg = true
						end
					end

					imgui.TreePop()
				end
				-------------------------------------------------------

				imgui.Separator()
				if imgui.TreeNode("Air to air refueling") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Refueler.jpg"), 130, 100)
					if sges_ahr == 1 then
						imgui.TextUnformatted("Refuel available for this \naircraft.")
					elseif PLANE_ICAO ~= nil then
						imgui.TextUnformatted("Refuel not available for \nthis aircraft.\nAdd " .. PLANE_ICAO .." to ...\n_Refuelable_Aircraft_list.lua")
					else
						imgui.TextUnformatted("Refuel not available for \nthis aircraft.\nAdd the type to ...\n_Refuelable_Aircraft_list.lua")
					end
					if sges_refuel_port_lateral ~= nil then
						imgui.TextUnformatted("Refuel lateral (optional)")
						if  imgui.SmallButton("La -")  then
							sges_refuel_port_lateral = sges_refuel_port_lateral - 0.1
							if sges_refuel_port_lateral > -0.05 and sges_refuel_port_lateral < 0.05 then sges_refuel_port_lateral = 0 end
							developer_change()
							AAR_chg = true
						end
						imgui.SameLine()
						if sges_refuel_port_lateral ~= nil then imgui.TextUnformatted(sges_refuel_port_lateral) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("La +")  then
							sges_refuel_port_lateral = sges_refuel_port_lateral + 0.1
							if sges_refuel_port_lateral > -0.05 and sges_refuel_port_lateral < 0.05 then sges_refuel_port_lateral = 0 end
							developer_change()
							AAR_chg = true
						end

						imgui.TextUnformatted("Refuel longitudinal (optional)")
						if  imgui.SmallButton("Lo -")  then
							sges_refuel_port_longitudinal = sges_refuel_port_longitudinal - 0.5
							developer_change()
							AAR_chg = true
						end
						imgui.SameLine()
						if sges_refuel_port_longitudinal ~= nil then imgui.TextUnformatted(sges_refuel_port_longitudinal) else imgui.TextUnformatted("nil") end
						imgui.SameLine()
						if  imgui.SmallButton("Lo +")  then
							sges_refuel_port_longitudinal = sges_refuel_port_longitudinal + 0.5
							developer_change()
							AAR_chg = true
						end
						imgui.TextUnformatted("Add a significant forward\nmargin and test in flight.")
						imgui.TextUnformatted("Add like at least +15 to\nlongitudinal contact \ngeometry.")
						imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Ahr.jpg"), 130, 51)

						imgui.TextUnformatted("Refuel elevation (optional)")
						if  imgui.SmallButton("El -")  then
							sges_refuel_port_elev = sges_refuel_port_elev - 0.1
							if sges_refuel_port_elev > -0.05 and sges_refuel_port_elev < 0.05 then sges_refuel_port_elev = 0 end
							developer_change()
							AAR_chg = true
						end
						imgui.SameLine()
						if sges_refuel_port_elev ~= nil then imgui.TextUnformatted(sges_refuel_port_elev) else imgui.TextUnformatted("nil") sges_refuel_port_elev = 0.8 end
						imgui.SameLine()
						if  imgui.SmallButton("El +")  then
							sges_refuel_port_elev = sges_refuel_port_elev + 0.1
							if sges_refuel_port_elev > -0.05 and sges_refuel_port_elev < 0.05 then sges_refuel_port_elev = 0 end
							developer_change()
							AAR_chg = true
						end
					end
					if sges_ahr == 1 then
						l_changed, l_newval = imgui.Checkbox(" show refueler", show_AAR)
						if l_changed then
							show_AAR = l_newval
							AAR_chg = true
						end
						imgui.SameLine()
						l_changed, l_newval = imgui.Checkbox(" basket", false)
						if l_changed and l_newval then
							set("sim/cockpit/electrical/taxi_light_on",1)
						elseif l_changed then
							set("sim/cockpit/electrical/taxi_light_on",0)
						end
					--~ else
						--~ imgui.Checkbox(" not available", false)
					end

					--~ if sges_ahr == 0 then
						--~ if  imgui.SmallButton("Force refuelable acft")  then -- does not work
							--~ sges_ahr = 1
							--~ if sges_refuel_port_lateral == nil then sges_refuel_port_lateral = 0 end
							--~ if sges_refuel_port_longitudinal == nil then sges_refuel_port_longitudinal = 15 end
							--~ if sges_refuel_port_elev == nil then sges_refuel_port_elev = 3 end
						--~ end
					--~ end
				imgui.TreePop()
				end

				imgui.Separator()
				if imgui.TreeNode("Chocks") then
					imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Chocks.jpg"), 130, 100)

					imgui.TextUnformatted("Nose gear (gear1)")
					if gear1X ~= nil then
						if imgui.SmallButton("g1X-") then
							gear1X = gear1X - 0.1
							Chocks_chg = true
							gear1X = math.floor(gear1X*100)/100
							if gear1X < -1 then gear1X = -1 end
						end
						imgui.SameLine()
						imgui.TextUnformatted("X " .. math.floor(gear1X*1000)/1000)
						imgui.SameLine()
						if imgui.SmallButton("g1X+") then
							gear1X = gear1X + 0.1
							Chocks_chg = true
							gear1X = math.floor(gear1X*100)/100
							if gear1X > 1 then gear1X = 1 end
						end
						imgui.SameLine()
						if imgui.SmallButton("g1X0") then
							gear1X = 0
							Chocks_chg = true
						end
					end
					if gear1Z ~= nil then
						if imgui.SmallButton("1Z-") then
							gear1Z = gear1Z - 0.05
							Chocks_chg = true
							gear1Z = math.floor(gear1Z*100)/100
						end
						imgui.SameLine()
						imgui.TextUnformatted("Z " .. math.floor(gear1Z*1000)/1000)
						imgui.SameLine()
						if imgui.SmallButton("1Z+") then
							gear1Z = gear1Z + 0.05
							Chocks_chg = true
							gear1Z = math.floor(gear1Z*100)/100
						end
					end
					imgui.Spacing()
					imgui.TextUnformatted("Main gear (gear2)")
					if gear2X ~= nil then
						if imgui.SmallButton("2X-") then
							gear2X = gear2X - 0.1
							Chocks_chg = true
							gear2X = math.floor(gear2X*100)/100
						end
						imgui.SameLine()
						imgui.TextUnformatted("X " .. math.floor(gear2X*1000)/1000)
						imgui.SameLine()
						if imgui.SmallButton("2X+") then
							gear2X = gear2X + 0.1
							Chocks_chg = true
							gear2X = math.floor(gear2X*100)/100
						end
					end


					if gear2Z ~= nil then
						if imgui.SmallButton("2Z-") then
							gear2Z = gear2Z - 0.1
							Chocks_chg = true
							gear2Z = math.floor(gear2Z*100)/100
						end
						imgui.SameLine()
						imgui.TextUnformatted("Z " .. math.floor(gear2Z*1000)/1000)
						imgui.SameLine()
						if imgui.SmallButton("2Z+") then
							gear2Z = gear2Z + 0.1
							Chocks_chg = true
							gear2Z = math.floor(gear2Z*100)/100
						end
					end
					--~ if imgui.SmallButton("Cancel chocks changes") then
						--~ Chocks_position_settle()
						--~ Chocks_chg = true
					--~ end
				imgui.TreePop()
				elseif IsXPlane1220 then
					l_changed, l_newval = imgui.Checkbox(" Prefer X-Plane 12 chocks\n (for this model only)", UseXplane1220Chocks_specific)
					if l_changed then
						show_Chocks = false
						Chocks_chg = true
						command_once("sim/flight_controls/remove_chocks")
						UseXplane1220Chocks = l_newval
						UseXplane1220Chocks_specific = l_newval
					end
					if UseXplane1220Chocks_specific then
						l_changed, l_newval = imgui.Checkbox(" Load those X-Plane chocks\n at startup", LoadXplane1220Chocks_specific)
						if l_changed then
							LoadXplane1220Chocks_specific = l_newval
						end
					end
				end

				-------------------------------------------------------
				if BeltLoaderFwdPosition <= 5 and SGES_stairs_type == "Boarding_without_stairs" then
					imgui.Separator()
					if imgui.TreeNode("Mirror everything (optional)") then
						imgui.TextUnformatted("Not standard, some-\nthing more special.\nLeave that alone.")
						-- MIRROR
						if SGES_mirror == 1 then
							imgui.Spacing()
							imgui.TextUnformatted("Currently : is mirrored.")
							imgui.Spacing()
							imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Mirroring.jpg"), 130, 110)
							if  imgui.SmallButton("Cancel mirroring")  then
								SGES_mirror =  0
								developer_change()
							end
							imgui.TextUnformatted("= Some animations are reduced\n while mirroring. =")
							imgui.Spacing()
							imgui.TextUnformatted("Click on the button to\nboard on port side,\nnot starboard.\n\nSome animations will be\nrecovered by doing that.")
						elseif BeltLoaderFwdPosition < 5 then
							imgui.Spacing()
							imgui.TextUnformatted("Currently : is regular config.")
							imgui.Spacing()
							imgui.Image(float_wnd_load_image(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/UI/Mirroring.jpg"), 130, 110)
							if  imgui.SmallButton("Mirror ground equipment")  then
								SGES_mirror =  1
								developer_change()
							end
							imgui.TextUnformatted("Click on the button to\nboard on starboard\ninstead of port.\n\nSome animations will\nbe lost when mirrored.")
						end
						imgui.TreePop()
					end
				elseif SGES_mirror == 1 then SGES_mirror =  0 -- for big airliners, if the value is increased in the developper mode, we want to sancturarise it as normal, port side, config.
				end

				-------------------------------------------------------

				imgui.Separator()
				if imgui.TreeNode("Save") then
					imgui.TextUnformatted("EXPORT TO USER PROFILE\n\n")
					if  imgui.Button("Export to user profile",200,20)  then
						SGES_13march2024_WriteToDisk(1)
						config_helper = false
					end
					imgui.TextUnformatted("aircraft_optional_profiles/\nSGES_CONFIG_" .. AIRCRAFT_FILENAME .. ".lua")
					--~ imgui.TextUnformatted("\nThe SGES embedded files will\nnot be overwritten. You\ncan delete this profile \nlater manually without danger.")
					imgui.TextUnformatted("Your optional export will never\nbe overwritten by SGES, ever !")

					imgui.TextUnformatted("\n")
					imgui.Separator()
					imgui.TextUnformatted("EXPORT TO TEXT FILE")
					--~ imgui.TextUnformatted("You must neverthelesss write \nthem to CONFIG_aircraft.lua.")
					imgui.TextUnformatted("A text file, for information.")
					if  imgui.SmallButton("Export to text file")  then
						SGES_13march2024_WriteToDisk(0)
					end
					imgui.TextUnformatted("(No effect in the sim).")
					imgui.TreePop()
				end

				imgui.TextUnformatted("\n")
				imgui.Separator()
				--~ imgui.TextUnformatted("Cancel ALL changes")
				if  imgui.SmallButton("Cancel ALL changes and reset\nfrom CONFIG_aircraft file")  then
					BeltLoaderRearPosition = nil
					SecondStairsFwdPosition = -30
					AircraftParameters()
					if SGES_mirror == 1 and BeltLoaderFwdPosition > 5 then SGES_mirror = 0 print("[Ground Equipment " .. version_text_SGES .. "] SGES has removed mirrored ground services.") end -- we need to forbid acess to mirrorring passengers when this is NOT suitable to mirror
					developer_change()
				end
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.Spacing()
				imgui.Spacing()
				----------------------------------------------------------------
				imgui.Separator()
				if  imgui.SmallButton("\nRebuild the runways databank\nfor the marshaller and\nthe aircraft arresting systems.\n ")  then
					includeCustomParkingPositions = true create_parking_position_cache()
				end
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF6C6CFF)
				imgui.TextUnformatted("Be patient while we scan all\nthe airports installed.")
				imgui.Separator()
				imgui.Spacing()
				imgui.TextUnformatted("LAT/LON: " .. math.floor(LATITUDE*1000)/1000 ..  " / " .. math.floor(LONGITUDE*1000)/1000 .. " " .. math.floor(sges_fps) .. "FPS")
				if (LATITUDE > 36 and LATITUDE < 55) and (LONGITUDE > -5 and LONGITUDE < 19) then -- Occidental Europe
				imgui.TextUnformatted("We are in Europe today.")
				elseif  (LATITUDE > 24 and LATITUDE < 44) and (LONGITUDE > -84 and LONGITUDE < -69) then -- East Coast USA
				imgui.TextUnformatted("In the Eastern time zones today.")
				end
				imgui.PopStyleColor()

			end
			if config_options then

				--~ if  imgui.Button("Look for SGES updates",230,30)  then
					--~ dofile(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_skinfat_updater.lua") -- threat module
				--~ end
				if  imgui.Button("Check for SGES updates",230,30)  then
					open_that_sges_url("https://forums.x-plane.org/index.php?/files/file/62296-simple-ground-equipment-services-low-tech-services")
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.TextUnformatted("SGES OPTIONS")
				imgui.TextUnformatted("Keep the mouse button down\nfor a description.")
				imgui.Spacing()
				imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
				imgui.TextUnformatted("Options in color aren't saved\nfor the next X-Plane session.")
				imgui.PopStyleColor()
				imgui.Spacing()
				imgui.Separator()
				if IsXPlane1214 then
					l_changed, l_newval = imgui.Checkbox(" Use X-Plane 12.1.4 vehicles", UseXplane1214DefaultObject)
					if l_changed then
						UseXplane1214DefaultObject = l_newval
						if l_newval then UseXplaneDefaultObject = false end
						--~ SGES_WriteToDisk()
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("X-Plane 12.1.4 brings new library objects : Snow and De-Icing Equipment, Ambulances, Trucks Airside and Airport Operations")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
				if IsXPlane1220 then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					if UseXplane1220Chocks_specific ~= nil and UseXplane1220Chocks_specific then
						l_changed, l_newval = imgui.Checkbox(" Prefer X-Plane 12 chocks\n (enforced with this model)", UseXplane1220Chocks)
					else
						l_changed, l_newval = imgui.Checkbox(" Prefer X-Plane 12 chocks\n (a global setting only\n for this session)", UseXplane1220Chocks)
					end
					if l_changed then
						show_Chocks = false
						Chocks_chg = true
						command_once("sim/flight_controls/remove_chocks")
						UseXplane1220Chocks = l_newval
					end
					imgui.PopStyleColor()
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("X-Plane 12.2.0 brings new objects : the chocks.\nThis parameter is global and not carried over the next session. You can instead choose & save your preference for a given model in the developer menu.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if UseXplane1220Chocks_specific ~= nil and UseXplane1220Chocks_specific and LoadXplane1220Chocks_specific ~= nil then
						imgui.Checkbox(" Load X-Plane 12 chocks\n at startup.", LoadXplane1220Chocks_specific)
					end
				elseif not IsXPlane1220 and UseXplane1220Chocks then UseXplane1220Chocks = false
				end

				l_changed, l_newval = imgui.Checkbox(" Use automatic stairs at 1L", show_auto_stairs)
				if l_changed then
					show_auto_stairs = l_newval
					--~ SGES_WriteToDisk()
				end
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Front stairs (and loader, cones) will appear automatically upon 1L door opening. Warning : even with a jetway connected.")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				if not IsXPlane12 or SGES_sound == false then
					l_changed, l_newval = imgui.Checkbox(" Play SGES sounds in X-Plane", SGES_sound)
					if l_changed then
						SGES_sound = l_newval
						if l_newval then load_xp11_sges_sounds() end
						--~ SGES_WriteToDisk()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("When in X-Plane 11, this settings can disable engine sounds. In X-Plane 12, this setting is ONLY applicable to planned pushback communications. Engine sounds in X-Plane 12 made in FMOD cannot be removed.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end

				if (UseXplane1214DefaultObject == nil or not UseXplane1214DefaultObject) or not IsXPlane12 then --and UseXplaneDefaultObject then
					-- this option can only be offered in a way : deactivating this, otherwise, x-plane crashes because of missing functions
					l_changed, l_newval = imgui.Checkbox(" Don't use SGES vehicles\n (Change can only be written\n in CONFIG_vehicles.lua)", UseXplaneDefaultObject)
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("When you don't use the SGES custom 3D vehicles, you revert to legacy X-Plane 11 vehicles where possible.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end

				--~ imgui.Spacing() --IAS24
				--~ imgui.Spacing() --IAS24
				--~ if show_PB == false and math.abs(BeltLoaderFwdPosition) > 5 and PLANE_ICAO ~= "B772" then -- the STS FF B772 will always use a TBL tug
				--~ imgui.Separator()
				--~ imgui.Spacing() --IAS24
				--~ imgui.Spacing() --IAS24
				if button_PB_mention == nil then
					button_PB_mention = "Use a towbarless tug"
				end
				if current_PB_mention == nil then
					current_PB_mention = "tug with towbar"
				end

				if math.abs(BeltLoaderFwdPosition) > 5 then
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					l_changed, l_newval = imgui.Checkbox(" Use a pushback tug with bar\n Currently : " .. current_PB_mention, Prefilled_PushBackObject == 		PushBackBar)
					if  l_changed and math.abs(BeltLoaderFwdPosition) > 5 and PLANE_ICAO ~= "B772" then -- the STS FF B772 will always use a TBL tug  then
						if Prefilled_PushBack1Object == Prefilled_LightObject and Prefilled_PushBackObject_civ ~= nil and Prefilled_PushBack1Object_civ ~= nil then
							--~ Prefilled_PushBackObject = 	Prefilled_PushBackObject_civ
							Prefilled_PushBackObject = 		PushBackBar
							Prefilled_PushBack1Object = 	Prefilled_PushBack1Object_civ
							button_PB_mention = "Use a towbarless tug" -- click to revert to that
							current_PB_mention = "tug with bar\n"
							show_PB = false -- force a user pushback reload
							PB_chg = true
						else
							Prefilled_PushBack1Object_civ = Prefilled_PushBack1Object
							Prefilled_PushBackObject_civ = Prefilled_PushBackObject
							-- Towbarless (TBL) pushback -------------------------------
							Prefilled_PushBack1Object = 		Prefilled_LightObject
							Prefilled_PushBackObject = 			SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/Pushback/Supertug.obj"
							button_PB_mention = "tug with towbar" -- revert to that
							current_PB_mention = "towbarless (TBL)"
							show_PB = false
							PB_chg = true
						end
					end
					imgui.PopStyleColor()
				else
					imgui.Checkbox(" Use a pushback tug with bar\n Currently : " .. current_PB_mention .. "\n Towbar mandatory for " .. PLANE_ICAO, true)
				end
				--~ imgui.TextUnformatted("Currently : " .. current_PB_mention)

				if math.abs(BeltLoaderFwdPosition) > 5 and (PLANE_ICAO == "A319" or PLANE_ICAO == "A19N" or PLANE_ICAO=="A320" or PLANE_ICAO == "A20N" or PLANE_ICAO == "A321" or PLANE_ICAO == "A21N") then
					--~ imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					l_changed, l_newval = imgui.Checkbox(" Prefer containerized cargo\n for the Airbus A320 series.",User_prefers_containerized_freight)
					if  l_changed then
						User_prefers_containerized_freight = l_newval
						-- patch
					   --~ if Prefilled_BeltLoaderObject == Prefilled_ULDLoaderObject and IsPassengerPlane == 1 and not User_prefers_containerized_freight then
							--~ Stored_Prefilled_BeltLoaderObject = User_Custom_Prefilled_BeltLoaderObject
						--~ end
					end
					--~ imgui.PopStyleColor()
				end


				--~ imgui.Spacing() --IAS24
				--~ imgui.Spacing() --IAS24
				--~ imgui.Separator()
				--~ imgui.Spacing() --IAS24

				if math.abs(BeltLoaderFwdPosition) < ULDthresholdx or reduce_even_more_the_number_of_passengers then
					local ttlnmbrpx = 12
					local pxbhvr = "and cycling"
					if math.abs(BeltLoaderFwdPosition) < 4.5 or (IsXPlane12 and SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1) or PLANE_ICAO == "GLF650ER" or PLANE_ICAO == "E19L" then ttlnmbrpx = 4 pxbhvr = "in total" end
					if reduce_even_more_the_number_of_passengers then ttlnmbrpx = ttlnmbrpx - 2 end

					if show_Pax then
						_, _ = imgui.Checkbox(" Reduce the total pax number\n Available without pax shown.\n  Current : " .. ttlnmbrpx .. " " .. pxbhvr .. ".",reduce_even_more_the_number_of_passengers)
					else
						_, reduce_even_more_the_number_of_passengers = imgui.Checkbox(" Reduce the total pax number\n (Read the description please)\n Selected : " .. ttlnmbrpx .. " " .. pxbhvr .. ".",reduce_even_more_the_number_of_passengers)
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 14)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("With small aircraft, the passengers number is already reduced to 4 in total without having to use this option ! With this option selected you remove two passengers to the current total of pax objects (4 with smaller airplanes). For instance, you will only get 2 passengers with smaller aircraft.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end




				if IsXPlane12 and outsideAirTemp < temperature_below_which_we_display_the_active_deicing_service + 7 then
					imgui.Spacing()
					imgui.TextUnformatted("Deicing service : aircraft is\nprotected from ice for " .. math.abs(Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand/60) .. " min.")
					if  imgui.SmallButton("Deice +")  then
						Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand + 300
						if Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand >= 3600 then Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = 3600 end
					end
					imgui.SameLine()
					if  imgui.SmallButton("Deice -")  then
						Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand - 300
						if Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand < 900 then Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = 900 end
					end
					imgui.SameLine()
					if  imgui.SmallButton("Deice 45")  then
						Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = 2700
					end
					imgui.Spacing()
				end

				l_changed, l_newval = imgui.Checkbox(" Ring softly when SGES ready", play_sound_SGES_is_available)
				if l_changed then
					play_sound_SGES_is_available = l_newval
					if l_newval then
						SGES_is_available_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/SGES_is_available.wav") -- -- sound number 2
						set_sound_gain(SGES_is_available_sound, 0.25)
						play_sound(SGES_is_available_sound)
						SGES_is_available_sound = nil
						WriteToDisk_SGES_USER_CONFIG()
					 end
				end
				l_changed, l_newval = imgui.Checkbox(" Show cones at startup", show_Cones_initially)
				if l_changed then
					show_Cones_initially = l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Show cones around the aircraft when SGES loads. A nice visual confirmation SGES is ready !")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end


				imgui.PushStyleColor(imgui.constant.Col.CheckMark,  imgui.ColorConvertFloat4ToU32(0.690, 0.565, 0.0, 1.0))
				imgui.PushStyleVar(imgui.constant.StyleVar.FrameRounding, 12)
				imgui.Bullet()   imgui.SameLine()
				l_changed, l_newval = imgui.Checkbox(" METAR source is in the USA", aviationweather_source_us)
				if l_changed then
					aviationweather_source_us = l_newval
					aviationweather_source_eu = not l_newval
					aviationweather_source_es = not l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end
				imgui.Bullet()   imgui.SameLine()
				l_changed, l_newval = imgui.Checkbox(" METAR source is in Norway", aviationweather_source_eu)
				if l_changed then
					aviationweather_source_eu = l_newval
					aviationweather_source_us = not l_newval
					aviationweather_source_es = not l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Attention, weather reports in Europe will change in 2025. Access to METAR and TAF data will require integrating with the SWIM nodes APIs and adapting to the new IWXXM format in the future.")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.Bullet()   imgui.SameLine()
				l_changed, l_newval = imgui.Checkbox(" METAR source is in Spain", aviationweather_source_es)
				if l_changed then
					aviationweather_source_es = l_newval
					aviationweather_source_us = not l_newval
					aviationweather_source_eu = not l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end
				imgui.PopStyleColor()
				imgui.PopStyleVar()
				l_changed, l_newval = imgui.Checkbox(" Autodetect 3rd-party assets", scan_third_party_initially)
				if l_changed then
					scan_third_party_initially = l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end
				if imgui.IsItemActive() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(imgui.GetFontSize() * 15)
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
					imgui.TextUnformatted("Scan all aircraft at each startup to detect your installation of third-parties.\nX-Trident CH47 and AV-8B come in mind.\nIf already detected in the past, we will never scan even is the option is ON.\n\nIf you relocate your X-Trident folders, revert all options to SGES defaults to allow autoscanning again or use manual detection below.")
					imgui.PopStyleColor()
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end

				if not scan_third_party_initially then
					l_changed, l_newval = imgui.Checkbox(" X-Trident Chinook installed\n Used for the Army set.", XTrident_Chinook_Directory)
					if l_changed then
						XTrident_Chinook_Directory = scan_for_external_asset("CH47 v2.0","CH47-D Chinook v1.0",1) -- 1 is verbose
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Scan Aircraft directory for third-party items now.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if XTrident_Chinook_Directory and not file_exists(SCRIPT_DIRECTORY .. XTrident_Chinook_Directory   .. "/plugins/CH47/mission/loads/humvee.obj") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("ERROR in the CH47 path !\nConsider writting it manually \nto SGES_USER_CONFIG.lua.")
						imgui.PopStyleColor()
					end
					imgui.TextUnformatted("   ") imgui.SameLine()
					if  imgui.Button("Open CH47-D Chinook URL",190,18)  then
						open_that_sges_url("https://store.x-plane.org/CH47-D-Chinook_p_1428.html")
					end
					l_changed, l_newval = imgui.Checkbox(" X-Trident AV8-B installed\n Used for aircraft carrier.", XTrident_NaveCavour_Directory)
					if l_changed then
						XTrident_NaveCavour_Directory= scan_for_external_asset("AV-8B v2","AV-8B v3",1) -- 1 is verbose
						if XTrident_NaveCavour_Directory ~= nil then XTrident_NaveCavour_Object =  SCRIPT_DIRECTORY .. XTrident_NaveCavour_Directory .. "/extra/Nave Cavour/Nimitz.obj" end
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Scan Aircraft directory for third-party assets now.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if XTrident_NaveCavour_Directory and not file_exists(SCRIPT_DIRECTORY .. XTrident_NaveCavour_Directory .. "/extra/Nave Cavour/Nimitz.obj") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("ERROR in the AV-8B path !\nConsider writting it manually \nto SGES_USER_CONFIG.lua.")
						imgui.PopStyleColor()
					end
					imgui.TextUnformatted("   ") imgui.SameLine()
					if  imgui.Button("Open Harrier AV-8B URL",190,18)  then
						open_that_sges_url("https://store.x-plane.org/Harrier-AV-8B-XP11_p_919.html")
					end

					l_changed, l_newval = imgui.Checkbox(" FF/STS B777 v2 installed\n Used for the Boeing 777.", FFSTS_777v2_Directory)
					if l_changed then
						FFSTS_777v2_Directory= scan_for_external_asset("Boeing777-200ER","Boeing777-200ER",1) -- 1 is verbose
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Scan Aircraft directory for third-party assets now.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if FFSTS_777v2_Directory and not file_exists(SCRIPT_DIRECTORY .. FFSTS_777v2_Directory .. "/objects/service/Tug2.obj") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("ERROR in the 777v2 path !\nConsider writting it manually \nto SGES_USER_CONFIG.lua.")
						imgui.PopStyleColor()
					end
					imgui.TextUnformatted("   ") imgui.SameLine()
					if  imgui.Button("Open FF/STS 777v2 URL",190,18)  then
						open_that_sges_url("https://store.x-plane.org/FlightFactor-777-200ER-v2-Ultimate_p_1883.html")
					end
					l_changed, l_newval = imgui.Checkbox(" Activate the CDB-Library\n Used for people.", Cami_de_Bellis_Directory)
					if l_changed then
						Cami_de_Bellis_Directory= scan_for_external_asset("is in custom scenery folder","CDB-Library",1) -- 1 is verbose
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Scan X-Plane for third-party assets now.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					if Cami_de_Bellis_Directory and not file_exists(SCRIPT_DIRECTORY .. Cami_de_Bellis_Directory .. "/Peeps/pilots/peeps_pilots_P2-goingup.obj") then
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("ERROR in the CDB-Library path !\nConsider writting it manually \nto SGES_USER_CONFIG.lua.")
						imgui.PopStyleColor()
						Cami_de_Bellis_authorized = false
					end
					imgui.TextUnformatted("   ") imgui.SameLine()
					if  imgui.Button("Open CDB-Library URL",190,18)  then
						open_that_sges_url("https://forums.x-plane.org/index.php?/files/file/27907-cdb-library")
					end
				end
				if FFSTS_777v2_Directory ~= nil and BeltLoaderFwdPosition > 6.10 and SGES_Author ~= nil
					and (string.find(SGES_Author,"Gliding") or string.find(SGES_Author,"FlightFactor")  or string.find(SGES_Author,"FlyJSim")  or string.find(SGES_Author,"COLIMATA"))
					then -- limit that when 777 is installed and for airliners
					imgui.PushStyleColor(imgui.constant.Col.Text,  0xFFFFCACA)
					l_changed, l_newval = imgui.Checkbox(" Force B777 v2 services once.\n Used only for this session.", string.match(Prefilled_CleaningTruckObject,"lsu"))
					if l_changed then
						if FFSTS_777v2_Directory ~= nil then -- this is not a saved option, because not our objects, so even if the user has paid for the 777v2, we still don't want to hijack their objects
							-- it is therefore more aimed at a demonstration
							load_special_B777v2_objects(FFSTS_777v2_Directory)
						end
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Force to use B777 v2 objects only for this flight. Always true if FF/STS B777 v2 is the current aircraft.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
					imgui.PopStyleColor()
				end

				if Cami_de_Bellis_Directory ~= nil then
					l_changed, Cami_de_Bellis_authorized = imgui.Checkbox(" Use CDB-Library people\n installed on your computer.", Cami_de_Bellis_authorized)
					if l_changed then
						Load_Cami_de_Bellis_Objects()
						WriteToDisk_SGES_USER_CONFIG()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("Cami de Bellis Library 2.6 has some nice people and if the library is installed, we can use that in your scenery.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
				if Clairmarais_Aerodrome_directory ~= nil then
					l_changed, _ = imgui.Checkbox(" Use nhadrian Clairmarais\n aerodrome.", true)
					if l_changed then
						Clairmarais_Aerodrome_lib()
					end
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("By nhadrian (Clairmarais aerodrome). This is only available when you use the nhadrian Sopwith F1 Camel.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				else
					_, _ = imgui.Checkbox(" Use nhadrian Clairmarais\n aerodrome.", false)
					if imgui.IsItemActive() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(imgui.GetFontSize() * 10)
						imgui.PushStyleColor(imgui.constant.Col.Text,  0xFF01CCDD)
						imgui.TextUnformatted("By nhadrian (Clairmarais aerodrome). This is only available when you use the nhadrian Sopwith F1 Camel.")
						imgui.PopStyleColor()
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
					end
				end
				----------------------------------------------------------------
				l_changed, l_newval = imgui.Checkbox(" Load the stairs automatically\n during the loading sequence ?\n (Manual request stays\n available at all times).", stairs_authorized)
				if l_changed then
					stairs_authorized = l_newval
					WriteToDisk_SGES_USER_CONFIG()
				end

				if stairs_authorized then
					imgui.TextUnformatted("Currently : loading the stairs,\nexcept with an OpenSAM jetway,\nduring the loading sequence.")
				else
					imgui.TextUnformatted("Currently : never load the stairs\nduring the SGES sequence.")
				end
				if option_StairsXPJ_override then
					imgui.TextUnformatted("= Manual override is active. =")
				end
				imgui.Separator()
				if  imgui.Button("Revert options to SGES defaults.",230,40)  then
					Wipe_SGES_USER_CONFIG()
				end

				imgui.Separator()
				imgui.TextUnformatted("Marshaller and arresting system:")
				if  imgui.Button("Rebuild the runways databank",230,55)  then
					includeCustomParkingPositions = true create_parking_position_cache()
				elseif  imgui.SmallButton("Rebuild without custom sceneries",200,16)  then
					includeCustomParkingPositions = false create_parking_position_cache()
				end
				imgui.TextUnformatted("(It looks frozen as it progresses\nbut it's not. Please wait.)")
			end


			-------------------------------------------------- aircraft specifics --------------------------
			-- displayed in both XP11 and XP12 !

			if AIRCRAFT_FILENAME== "Bell412.acf" and not show_ArrestorSystem then
				--~ imgui.Separator()
				--~ imgui.TextUnformatted(AIRCRAFT_FILENAME)
				if  imgui.Button("CREW on winch",100,20)  then
					command_once("412/buttons/CREW_on")
					set("412/visible_objects/patient",1)
					set("412/visible_objects/co_pilot",1)
					set ("412/winch/patient",2)
					-- open the door
					set_array("sim/cockpit2/switches/custom_slider_on",1,1)
					set_array("sim/cockpit2/switches/custom_slider_on",3,1)
					--
					-- patient on ground
					set("412/visible_objects/patient",1)
					set ("412/winch/patient",3)
					set("412/special/show_PatientOnGround",2)
				end
				imgui.SameLine() -- added 2022
				if  imgui.Button("off winch",70,20)  then
					command_once("412/buttons/CREW_off")
					set("412/visible_objects/patient",0)
					set("412/visible_objects/co_pilot",0)
					set("412/special/show_PatientOnGround",0)
				end
				imgui.SameLine() -- added 2022
				if  imgui.Button("D",30,20)  then
					-- close the door
					-- right hand side
					set_array("sim/cockpit2/switches/custom_slider_on",1,0)
					set_array("sim/cockpit2/switches/custom_slider_on",3,0)
					-- left hand side
					set_array("sim/cockpit2/switches/custom_slider_on",0,0)
					set_array("sim/cockpit2/switches/custom_slider_on",2,0)
					-- pilot door
					set_array("sim/cockpit2/switches/custom_slider_on",4,0)
					-- copilot door
					set_array("sim/cockpit2/switches/custom_slider_on",5,0)
				end
				if  imgui.Button("Hoist up",70,20)  then
					command_once("412/buttons/HOIST_up")
					set("412/special/show_PatientOnGround",3)
					set ("412/winch/patient",1)
				end
				imgui.SameLine() -- added 2022
				if  imgui.Button("down",60,20)  then
					command_once("412/buttons/HOIST_down")
				end
				imgui.SameLine() -- added 2022
				if  imgui.Button("Stop",60,20)  then
					command_once("412/buttons/HOIST_stop")
				end
				imgui.Separator()
				if  imgui.Button("Attach LOAD",100,20)  then
					set("412/LOAD_current",0)
					command_once("412/LOAD/set_cable_10m")
					set("412/LOAD_cable_len",9)
				end imgui.SameLine()
				if  imgui.Button("Drop LOAD",100,20)  then
					command_once("412/LOAD/set_cable_off")
					command_once("412/LOAD/drop")
					command_once("412/buttons/PATIENT_off")
				end
			end
			if AIRCRAFT_FILENAME== "CH47.acf" and not show_ArrestorSystem then
				--~ imgui.Separator()
				--~ imgui.TextUnformatted(AIRCRAFT_FILENAME)
				if  imgui.Button("Attach LOAD",100,20)  then
					set("ch47/anim/load/current",0)
					set("ch47/anim/load/cable_len",9)
					set("ch47/anim/load_assist/show",0)
				end imgui.SameLine()
				if  imgui.Button("Drop LOAD",100,20)  then
					set("ch47/anim/load/current",-1)
					set("ch47/anim/load_assist/show",0)
					set_array("ch47/system/doors_windows_req",1,0) -- bottom part of 1R door
					set_array("ch47/system/doors_windows_req",3,0) -- floor hatch
				end




			end
			----------------------------------------------------------
		end
	end
	end --IAS24
	--------------------------------------------------------------------

	--------------------------------------------------------------------

	show_Automatic_sequence_start = false
	SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec + 9999
	if sequence_debug_factor == nil then sequence_debug_factor = 1 end -- must be one in normal operaiton, 4 for the developper testing the sequences
	function Automatic_sequence_start()
	   if show_Automatic_sequence_start and SGES_total_flight_time_sec < 3600 then
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1/sequence_debug_factor) and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (3/sequence_debug_factor) and show_Chocks == false then
				print("[Ground Equipment " .. version_text_SGES .. "] Automatic_departure_sequence_start")
				if protect_StairsXPJ then
					protect_StairsXPJ = false
					StairsXPJ_chg 	= true
					StairsXPJ2_chg 	= true
					--~ StairsXPJ3_chg	= true
				end
				--~ StairsXPJ3_chg	= true
				show_Chocks = true Chocks_chg = true
				--XPLMSpeakString("Calling services.")
			end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (3/sequence_debug_factor)  and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (6/sequence_debug_factor) and BeltLoaderFwdPosition > 3 and show_StairsXPJ  == false and stairs_authorized then show_StairsXPJ = true StairsXPJ_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (4/sequence_debug_factor)  and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (9/sequence_debug_factor) and BeltLoaderFwdPosition > 3 and SecondStairsFwdPosition ~= -30  and show_StairsXPJ2  == false then show_StairsXPJ2 = true StairsXPJ2_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (10/sequence_debug_factor)  and show_Cleaning  == false then show_Cleaning = true Cleaning_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (60/sequence_debug_factor)  and show_People4 == false then show_People4 = true People4_chg = true end -- pilot
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (80/sequence_debug_factor)   and show_FUEL == false then show_FUEL = true FUEL_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (140/sequence_debug_factor)  and show_Cones == false then show_Cones = true Cones_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (300/sequence_debug_factor)  and show_People1 == false then show_People1 = true People1_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (400/sequence_debug_factor)  and show_People2 == false then show_People2 = true People2_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (430/sequence_debug_factor)  and show_RearBeltLoader == false and BeltLoaderRearPosition ~= nil then show_RearBeltLoader = true RearBeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (550/sequence_debug_factor)  and show_BeltLoader == false then show_BeltLoader = true BeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (600/sequence_debug_factor)  and show_Cart == false then show_Cart = true Cart_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (610/sequence_debug_factor)  and show_People3 == false then show_People3 = true People3_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (660/sequence_debug_factor)  and show_Bus == false and stairs_authorized and terminate_passenger_action == false then show_Bus = true Bus_chg = true end

			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (570/sequence_debug_factor)  and show_Cleaning  == true then show_Cleaning = false Cleaning_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (680/sequence_debug_factor)   and show_FUEL == true then show_FUEL = false FUEL_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (678/sequence_debug_factor)  and show_People4 == true then show_People4 = false People4_chg = true end -- pilot
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (800/sequence_debug_factor)  and show_Pax == true then terminate_passenger_action = true end -- remove the pax and bus, changed April 2024
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (918/sequence_debug_factor)  and show_Cart == true then show_Cart = false Cart_chg = true show_Baggage = false Baggage_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (950/sequence_debug_factor)  and show_Bus == true then show_Bus = false Bus_chg = true show_Pax = false Pax_chg = true  end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1020/sequence_debug_factor)  and show_BeltLoader == true then show_BeltLoader = false BeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1040/sequence_debug_factor)  and show_RearBeltLoader == true then show_RearBeltLoader = false RearBeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1079/sequence_debug_factor)  and show_StairsXPJ  == true then show_StairsXPJ = false StairsXPJ_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1080/sequence_debug_factor)  and show_Cones == true then
				show_Cones = false Cones_chg = true
				--XPLMSpeakString("Boarding finished, removing chocks.")
			end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1081/sequence_debug_factor)  and show_Chocks == true then show_Chocks = false Chocks_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1083/sequence_debug_factor)  and show_People3 == true then show_People3 = false People3_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1084/sequence_debug_factor)  and show_StairsXPJ2  == true then show_StairsXPJ2 = false StairsXPJ2_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1084/sequence_debug_factor)  and show_StairsXPJ3  == true then show_StairsXPJ3 = false StairsXPJ3_chg = true end --IAS24
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1085/sequence_debug_factor)  and show_People1 == true then show_People1 = false People1_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1087/sequence_debug_factor)  and show_People2 == true then show_People2 = false People2_chg = true  show_Automatic_sequence_start = false print("[Ground Equipment " .. version_text_SGES .. "] Automatic ground services sequence ends.") end
	    elseif show_Automatic_sequence_start and SGES_total_flight_time_sec >= 3600 then
			local sequence_user_factor = sequence_debug_factor -- we will default to max duration but we don't want to ultimately loose the user configuration, save that now.
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1/sequence_debug_factor) and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (3/sequence_debug_factor) and show_Chocks == false then
				if protect_StairsXPJ then
					protect_StairsXPJ = false
					StairsXPJ_chg 	= true
					StairsXPJ2_chg 	= true
					--~ StairsXPJ3_chg	= true
				end
				if sequence_user_factor <= 1 then
					print("[Ground Equipment " .. version_text_SGES .. "] Automatic arrival and turn-around sequence starts, defaulting to its maximum duration (~25 minutes).")
					sequence_debug_factor = 0.75 -- always default to max duration
				else
					print("[Ground Equipment " .. version_text_SGES .. "] Automatic arrival and turn-around sequence starts, using user settings for its duration.")
				end
				SGES_gui_sequence_chronology = math.floor(((SGES_Automatic_sequence_start_flight_time_sec+1140-SGES_total_flight_time_sec)/60)/sequence_debug_factor)
				show_Chocks = true Chocks_chg = true
				--XPLMSpeakString("Calling services.")
			end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (3/sequence_debug_factor)  and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (6/sequence_debug_factor) and BeltLoaderFwdPosition > 3 and show_StairsXPJ  == false and stairs_authorized then show_StairsXPJ = true StairsXPJ_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (4/sequence_debug_factor)  and SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (9/sequence_debug_factor) and BeltLoaderFwdPosition > 3 and SecondStairsFwdPosition ~= -30  and show_StairsXPJ2  == false then show_StairsXPJ2 = true StairsXPJ2_chg = true end
			-- deboarding
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (10/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (15/sequence_debug_factor) and show_Cones == false then show_Cones = true Cones_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (15/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (20/sequence_debug_factor) and show_People1 == false then show_People1 = true People1_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (20/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (25/sequence_debug_factor)  and show_People2 == false then show_People2 = true People2_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (23/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (28/sequence_debug_factor)  and show_BeltLoader == false then show_BeltLoader = true BeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (27/sequence_debug_factor) and
				SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (32/sequence_debug_factor)  and show_RearBeltLoader == false and BeltLoaderRearPosition ~= nil then  show_RearBeltLoader = true RearBeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (30/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (35/sequence_debug_factor)  and show_Bus == false and stairs_authorized then show_Bus = true Bus_chg = true  end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (40/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (45/sequence_debug_factor) and show_People4 == false then show_People4 = true People4_chg = true end -- pilotRearBeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (60/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (65/sequence_debug_factor) and show_Cart == false then show_Cart = true Cart_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (180/sequence_debug_factor) and
			  SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (185/sequence_debug_factor) and show_Pax == true then terminate_passenger_action = true end -- remove the pax and bus, changed April 2024
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (290/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (290/sequence_debug_factor) and show_People3 == false then show_People3 = true People3_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (300/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (305/sequence_debug_factor)  and show_People4 == true then show_People4 = false People4_chg = true end -- pilot
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (360/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (365/sequence_debug_factor) and show_Cleaning  == false then show_Cleaning = true Cleaning_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (390/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (395/sequence_debug_factor)  and show_FUEL == false then show_FUEL = true FUEL_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (450/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (455/sequence_debug_factor) and show_Cart == true then show_Cart = false Cart_chg = true show_Baggage = false Baggage_chg = true end

			-- Reboarding
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (600/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (605/sequence_debug_factor) and show_Bus == true then show_Bus = false Bus_chg = true show_Pax = false Pax_chg = true  end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (600/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (605/sequence_debug_factor)  and show_Cart == false then show_Cart = true Cart_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (660/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (665/sequence_debug_factor)  and show_Bus == false and terminate_passenger_action == false then show_Bus = true Bus_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (680/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (685/sequence_debug_factor) and show_Cleaning  == true then show_Cleaning = false Cleaning_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (900/sequence_debug_factor) and
			SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (905/sequence_debug_factor)  and show_FUEL == true then show_FUEL = false FUEL_chg = true end
			-- finish the boarding
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1000/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1005/sequence_debug_factor) and show_Pax == true then terminate_passenger_action = true end -- remove the pax and bus, changed April 2024
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1032/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1037/sequence_debug_factor)  and show_Cart == true then show_Cart = false Cart_chg = true show_Baggage = false Baggage_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1050/sequence_debug_factor) and
				SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1055/sequence_debug_factor)  and show_BeltLoader == true then show_BeltLoader = false BeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1055/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1060/sequence_debug_factor) and show_RearBeltLoader == true then show_RearBeltLoader = false RearBeltLoader_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1060/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1065/sequence_debug_factor) and show_StairsXPJ  == true then show_StairsXPJ = false StairsXPJ_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1065/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1070/sequence_debug_factor) and show_Chocks == true then show_Chocks = false Chocks_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1070/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1075/sequence_debug_factor) and show_People3 == true then show_People3 = false People3_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1075/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1080/sequence_debug_factor) and show_StairsXPJ2  == true then show_StairsXPJ2 = false StairsXPJ2_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1077/sequence_debug_factor) and --IAS24
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1080/sequence_debug_factor) and show_StairsXPJ3  == true then show_StairsXPJ3 = false StairsXPJ3_chg = true end --IAS24
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1080/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1085/sequence_debug_factor) and show_People1 == true then show_People1 = false People1_chg = true end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1085/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1090/sequence_debug_factor) and show_Cones == true then	show_Cones = false Cones_chg = true		end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1087/sequence_debug_factor) and
			 SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1092/sequence_debug_factor) and show_People2 == true then show_People2 = false People2_chg = true  sequence_debug_factor = sequence_user_factor  print("[Ground Equipment " .. version_text_SGES .. "] Automatic (arrival/turnaround) ground services sequence ends.") end
			if SGES_total_flight_time_sec > SGES_Automatic_sequence_start_flight_time_sec + (1088/sequence_debug_factor) and
			SGES_total_flight_time_sec < SGES_Automatic_sequence_start_flight_time_sec + (1093/sequence_debug_factor) and show_Bus == true then show_Bus = false Bus_chg = true show_Pax = false Pax_chg = true  show_Automatic_sequence_start = false end
		end
	end

	function exit_plugin_part3()
		if unload_SamObjects ~= nil then unload_SamObjects() end
		if unload_Front_Line_Objects ~= nil then unload_Front_Line_Objects() end
		automatic_display_EMS_acceptable = false
	end

	function exit_plugin_part2()
		_,FireVehicle_instance[3],rampserviceref71d = common_unload("FireVehicle",FireVehicle_instance[3],rampserviceref71d)
		_,FireVehicle_instance[2],rampserviceref71b = common_unload("FireVehicle",FireVehicle_instance[2],rampserviceref71b)
		_,FireVehicle_instance[1],rampserviceref71L = common_unload("FireVehicle",FireVehicle_instance[1],rampserviceref71L)
		_,Ship1_instance[1],rampserviceref81F = common_unload("Ship1",Ship1_instance[1],rampserviceref81F)
		_,Ship2_instance[1],rampserviceref82F = common_unload("Ship2",Ship2_instance[1],rampserviceref82F)
		Ponev_chg,Ponev_instance[0],rampservicerefPonev = common_unload("Ponev",Ponev_instance[0],rampservicerefPonev)
		TargetSelfPushback_chg,TargetSelfPushback_instance[0],rampservicerefTargetSelfPushback = common_unload("TargetSelfPushback",TargetSelfPushback_instance[0],rampservicerefTargetSelfPushback)
		Forklift_chg,Forklift_instance[0],rampservicerefForklift = common_unload("Forklift",Forklift_instance[0],rampservicerefForklift)
		PB_chg,GenericDriver_instance[0],rampservicerefGenericDriver = common_unload("GenericDriver",GenericDriver_instance[0],rampservicerefGenericDriver)
		if IsXPlane12 then CockpitLight_chg,CockpitLight_instance[0],rampservicerefCockpitLight =  common_unload("CockpitLight",CockpitLight_instance[0],rampservicerefCockpitLight) end
		AAR_chg,AAR_instance[0],rampservicerefAAR = common_unload("AAR",AAR_instance[0],rampservicerefAAR)
		_,Baggage_instance[0],rampservicerefBaggage = common_unload("Baggage",Baggage_instance[0],rampservicerefBaggage)
		_,Baggage_instance[1],rampservicerefBaggage1 = common_unload("Baggage1",Baggage_instance[1],rampservicerefBaggage1)
		_,Baggage_instance[2],rampservicerefBaggage2 = common_unload("Baggage2",Baggage_instance[2],rampservicerefBaggage2)
		_,Baggage_instance[3],rampservicerefBaggage3 = common_unload("Baggage3",Baggage_instance[3],rampservicerefBaggage3)
		Baggage_chg,Baggage_instance[4],rampservicerefBaggage4 = common_unload("Baggage4",Baggage_instance[4],rampservicerefBaggage4)
		CargoULD_chg,Baggage_instance[5],rampservicerefBaggage5 = common_unload("CargoULD",Baggage_instance[5],rampservicerefBaggage5)
		StairsXPJ_chg,StairsXPJ_instance[0],rampserviceref300 = common_unload("StairsXPJ",StairsXPJ_instance[0],rampserviceref300)
		StairsXPJ_chg,StairsXPJ_instance[1],rampserviceref301 = common_unload("StairsXPJ",StairsXPJ_instance[1],rampserviceref301)
		StairsXPJ2_chg,StairsXPJ2_instance[0],rampserviceref302 = common_unload("StairsXPJ",StairsXPJ2_instance[0],rampserviceref302)
		StairsXPJ2_chg,StairsXPJ2_instance[1],rampserviceref303 = common_unload("StairsXPJ",StairsXPJ2_instance[1],rampserviceref303)
		StairsXPJ3_chg,StairsXPJ3_instance[0],rampserviceref304 = common_unload("StairsXPJ3",StairsXPJ3_instance[0],rampserviceref304)
		StairsXPJ3_chg,StairsXPJ3_instance[1],rampserviceref305 = common_unload("StairsXPJ31",StairsXPJ3_instance[1],rampserviceref305)
		_,Helicopters_instance[0],rampservicerefXP12Helicopter0 = common_unload("Helicopter",Helicopters_instance[0],rampservicerefXP12Helicopter0)
		Helicopters_chg,Helicopters_instance[1],rampservicerefXP12Helicopter1 = common_unload("Helicopter",Helicopters_instance[1],rampservicerefXP12Helicopter1)
		Helicopters_chg,Helicopters_instance[2],rampservicerefXP12Helicopter2 = common_unload("Helicopter",Helicopters_instance[2],rampservicerefXP12Helicopter2)
		Helicopters_chg,Helicopters_instance[3],rampservicerefXP12Helicopter3 = common_unload("Helicopter",Helicopters_instance[3],rampservicerefXP12Helicopter3)
		Submarine_chg,Submarine_instance[0],rampservicerefSubmarine = common_unload("Submarine",Submarine_instance[0],rampservicerefSubmarine)
		set("sim/operation/override/override_engine_forces",0)
		set("sim/operation/override/override_wing_forces",0)
		exit_plugin_part3()
	end

	function exit_plugin()
		if not IsXPlane12 and SGES_sound then
			stop_sound(Engine_sound) -- looped sound
		end
		unload_probe()
		Cones_chg,Cones_instance[0],rampserviceref0 = common_unload("Cones",Cones_instance[0],rampserviceref0)
		Cones_chg,Cones_instance[1],rampserviceref3 = common_unload("Cones",Cones_instance[1],rampserviceref3)
		Cones_chg,Cones_instance[2],rampserviceref010 = common_unload("Cones",Cones_instance[2],rampserviceref010)
		Cones_chg,Cones_instance[3],rampservicerefBo = common_unload("Cones",Cones_instance[3],rampservicerefBo)
		Cones_chg,Cones_instance[4],rampservicerefBo4 = common_unload("Cones",Cones_instance[4],rampservicerefBo4)
		GPU_chg,GPU_instance[0],rampserviceref1 = common_unload("GPU",GPU_instance[0],rampserviceref1)
		FUEL_chg,FUEL_instance[0],rampserviceref2 = common_unload("FUEL",FUEL_instance[0],rampserviceref2)
		Cleaning_chg,Cleaning_instance[0],rampserviceref4 = common_unload("Cleaning",Cleaning_instance[0],rampserviceref4)
		_,Cleaning_instance[1],rampserviceref4L = common_unload("CleaningLight",Cleaning_instance[1],rampserviceref4L)
		Stairs_chg,Stairs_instance[0],rampserviceref6 = common_unload("Stairs",Stairs_instance[0],rampserviceref6)
		Bus_chg,Bus_instance[0],rampserviceref7 = common_unload("Bus",Bus_instance[0],rampserviceref7)
		Bus_chg,Bus_instance[1],rampserviceref7L = common_unload("BusLight",Bus_instance[1],rampserviceref7L)
		Catering_chg,Catering_instance[0],rampserviceref8 = common_unload("Catering",Catering_instance[0],rampserviceref8)
		Catering_chg,Catering_instance[1],rampserviceref8h = common_unload("CateringHighPart",Catering_instance[1],rampserviceref8h)
		PRM_chg,PRM_instance[0],rampservicerefPRM = common_unload("PRM",PRM_instance[0],rampservicerefPRM)
		PRM_chg,PRM_instance[1],rampservicerefPRM2 = common_unload("CateringHighPart",PRM_instance[1],rampservicerefPRM2)
		FM_chg,FM_instance[0],rampserviceref53 = common_unload("FM",FM_instance[0],rampserviceref53)
		FireVehicle_chg,FireVehicle_instance[0],rampserviceref71 = common_unload("FireVehicle",FireVehicle_instance[0],rampserviceref71)
		ArrestorSystem_chg,ArrestorSystem_instance[0],rampservicerefAS = common_unload("ArrestorSystem",ArrestorSystem_instance[0],rampservicerefAS)
		FireSmoke_chg,FireSmoke_instance[0],rampserviceref710 = common_unload("FireSmoke",FireSmoke_instance[0],rampserviceref710)
		ULDLoader_chg,ULDLoader_instance[0],rampserviceref72 = common_unload("ULDLoader",ULDLoader_instance[0],rampserviceref72)
		ULDLoader_chg,ULDLoader_instance[1],rampserviceref722 = common_unload("ULDLoader",ULDLoader_instance[1],rampserviceref722)
		People1_chg,People1_instance[0],rampserviceref73 = common_unload("People1",People1_instance[0],rampserviceref73)
		People2_chg,People2_instance[0],rampserviceref74 = common_unload("People2",People2_instance[0],rampserviceref74)
		People3_chg,People3_instance[0],rampserviceref75 = common_unload("People3",People3_instance[0],rampserviceref75)
		People4_chg,People4_instance[0],rampserviceref76 = common_unload("People4",People4_instance[0],rampserviceref76)
		Ship1_chg,Ship1_instance[0],rampserviceref81 = common_unload("Ship1",Ship1_instance[0],rampserviceref81)
		Ship2_chg,Ship2_instance[0],rampserviceref82 = common_unload("Ship2",Ship2_instance[0],rampserviceref82)
		Chocks_chg,Chocks_instance[1],rampserviceref92 = common_unload("Chock2",Chocks_instance[1],rampserviceref92)
		Chocks_chg,Chocks_instance[2],rampserviceref93 = common_unload("Chock3",Chocks_instance[2],rampserviceref93)
		Chocks_chg,Chocks_instance[0],rampserviceref91 = common_unload("Chocks",Chocks_instance[0],rampserviceref91)
		BeltLoader_chg,BeltLoader_instance[0],rampserviceref5 =  common_unload("BeltLoader",BeltLoader_instance[0],rampserviceref5)
		Cart_chg,BeltLoader_instance[1],rampserviceref9 = common_unload("Cart",BeltLoader_instance[1],rampserviceref9)
		Deice_chg,Deice_instance[0],rampserviceref100 = common_unload("Deice",Deice_instance[0],rampserviceref100)
		Deice_chg,Deice_instance[1],rampserviceref101 = common_unload("Deice",Deice_instance[1],rampserviceref101)
		Deice_chg,Deice_instance[2],rampserviceref102 = common_unload("Deice",Deice_instance[2],rampserviceref102)
		Light_chg,Light_instance[0],rampserviceref200 = common_unload("Light",Light_instance[0],rampserviceref200)
		TargetMarker_chg,TargetMarker_instance[0],rampservicerefTargetMarker = common_unload("TargetMarker",TargetMarker_instance[0],rampservicerefTargetMarker)
		StopSign_chg,TargetMarker_instance[1],rampservicerefStopSign = common_unload("StopSign",TargetMarker_instance[1],rampservicerefStopSign)
		StopSign_chg,TargetMarker_instance[2],rampservicerefArms = common_unload("Arms",TargetMarker_instance[2],rampservicerefArms)
		PB_chg,PB_instance[0],rampservicerefPB = common_unload("Pushback",PB_instance[0],rampservicerefPB)
		PB_chg,PB_instance[1],rampservicerefPB1 = common_unload("PB",PB_instance[1],rampservicerefPB1)
		ASU_chg,ASU_ACU_instance[0],rampservicerefASU_ACU = common_unload("ASU",ASU_ACU_instance[0],rampservicerefASU_ACU)
		ASU_chg,ASU_ACU_instance[1],rampservicerefASU_ACU1 = common_unload("duct",ASU_ACU_instance[1],rampservicerefASU_ACU1)
		RearBeltLoader_chg,BeltLoader_instance[2],rampservicerefRBL =  common_unload("RearBeltLoader",BeltLoader_instance[2],rampservicerefRBL)
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[0],rampservicerefXP12Carrier =  common_unload("XP12Carrier",XP12Carrier_instance[0],rampservicerefXP12Carrier) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[1],rampservicerefXP12CarrierP2 =  common_unload("XP12Carrier",XP12Carrier_instance[1],rampservicerefXP12CarrierP2) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[2],rampservicerefXP12CarrierP3 =  common_unload("XP12Carrier",XP12Carrier_instance[2],rampservicerefXP12CarrierP3) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[3],rampservicerefXP12CarrierP4 =  common_unload("XP12Carrier",XP12Carrier_instance[3],rampservicerefXP12CarrierP4) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[4],rampservicerefXP12CarrierP5 =  common_unload("XP12Carrier",XP12Carrier_instance[4],rampservicerefXP12CarrierP5) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[5],rampservicerefXP12CarrierP6 =  common_unload("XP12Carrier",XP12Carrier_instance[5],rampservicerefXP12CarrierP6) end
		if IsXPlane12 then XP12Carrier_chg,XP12Carrier_instance[6],rampservicerefXP12CarrierP7 =  common_unload("XP12Carrier",XP12Carrier_instance[6],rampservicerefXP12CarrierP7) end
		unload_Passengers()
		exit_plugin_part2()
	end


	local store_diff_X = 9000000 -- just a required initialization with something big
	local store_diff_Z = 9000000 -- just a required initialization with something big
	distance_to_sges_stand = 9000000


	-- get xplane root path using XPLM utilities. Note that the path ends with /
	XPLM.XPLMGetSystemPath(char_str)
	syspath = ffi.string(char_str)

	XP12boat_location_x = 0
	XP12boat_location_z = 0


	function automatic_display_EMS()

			if SGES_aircraft_has_crashed[0] == 1 and not show_FireVehicle and sges_gs_gnd_spd[0] < 15 and automatic_display_EMS_acceptable then
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, 5, sges_gs_plane_head[0] )
				local y_forward,_ = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, -5, sges_gs_plane_head[0] )
				local y_aft,_ 	= probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				local ground_level_difference = math.abs(y_forward-y_aft)*100

				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 5, -3, sges_gs_plane_head[0] )
				local y_R,_ = probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				coordinates_of_adjusted_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], 15, -3, sges_gs_plane_head[0] )
				local y_L,_ 	= probe_y (g_shifted_x, sges_gs_plane_y[0], g_shifted_z)
				local ground_level_difference_LR = math.abs(y_R-y_L)*100

				if ground_level_difference < 20 	-- takes into account the pitch of the terrain slope in the acft axis
				and ground_level_difference_LR < 20 -- takes into account the roll of the terrain slope in the acft axis
				then
					show_FireVehicle = true FireVehicle_chg = true
					print("[Ground Equipment " .. version_text_SGES .. "] Sending fire rescue. SGES_aircraft_has_crashed[0] = " .. SGES_aircraft_has_crashed[0])
				end
					-- add a surprise goodie : helicopter fly-by
				if not show_Helicopters and IsXPlane12 then
					show_Helicopters = true
					Helicopters_chg = true
				end
			end
	end


	function execute_service_objects()
		if SGES_XPlaneIsPaused == 0 then
			if sges_gs_gnd_spd[0] < 1 then
				CockpitLight_physics() -- night ambiance in the cockpit
				service_object_physics_Cones() -- all engines and wind traffic cones
				service_object_physics_GPU() -- GPU Ground power unit
				service_object_physics_Beltloader()
				service_object_physics_RearBeltloader()
				service_object_physics_XPlane_stairs() -- static stairs
				service_object_physics_Catering()	--
				service_object_physics_PRM()	-- People with reduced mobility cart
				service_object_physics_ULDloader()
				--~ service_object_physics_ULD() -- actuated in ships functions .lua
				service_object_physics_People1() -- People1
				service_object_physics_People2() -- People2
				service_object_physics_People3() -- People3
				service_object_physics_People4() -- People4
				service_object_physics_AllCHOCKS() -- Chocks services - all - restricted to the drawing functions
				service_object_physics_AllDeicing() -- Deicing (both carts)
				service_object_physics_EnvLight() -- light (in the environement, not the cockpit light)
				service_object_physics_stairsXPJ() -- stairsXPJ
				service_object_physics_stairsXPJ2() -- stairsXPJ2
				service_object_physics_stairsXPJ3() -- stairsXPJ2
				service_object_physics_ASU()	-- ASU Air start Unit
				service_object_physicsForklift()	-- Forklift
				automatic_display_EMS()
				--automatic_parking_search() -- Marshaller : one cycle of autoamtic search per Follow me -- removed for performance on 4th of Nov 2023
				if show_auto_stairs then react_to_door_dataref() end -- Show the stairs if the doors open, but in auto stairs mode only
			end
			service_object_physics_Cleaning() -- cleaning and multipurpose truck, also used in emergency situation outside the airport scope
			if show_Automatic_sequence_start	then Automatic_sequence_start() end
		end
	end


	--~ sges_override_planepath = dataref_table("sim/operation/override/override_planepath")

	if sges_framerate_period == nil then dataref("sges_framerate_period","sim/time/framerate_period") end
	function execute_environnemental_objects() -- those ones needs to be available at any time
		----------------------------------------------------------------------------
		-- FOR DEVELOPMENT PURPOSE -------------------------------------------------
		--~ IsXPlane12 = false  IsXPlane1209 = false IsXPlane1211 = false -- do not activate this -- only for XPJavelin
		if groundservices_float_wnd ~= nil then
			sges_fps = 1/sges_framerate_period
		end
		----------------------------------------------------------------------------
		----------------------------------------------------------------------------
		if SGES_XPlaneIsPaused == 0 then
			service_object_physics_smallShip() 		-- ship small Ship1
			service_object_physics_largeShip()		-- ship large Ship2
			if IsXPlane12 then XP12boat_location_x,XP12boat_location_z = service_object_physicsXP12Carrier() end
			service_object_physics_WildFire() 		-- wild fire
			service_object_physics_ArrestorSystem() -- arrestor system
			--service_object_physicsTargetSelfPushback()
		end
	end


	ArrestorSystem_sensitivity = 30
	ArrestorSystem_delay_basis = 0.05  -- must be increased when sensitivity is increased !
	catched_time = 9999999999999999999
	deck_altitude = 1
	execute_DYNAMIC_service_objects_wigwag = 0

	--function execute_DYNAMIC_service_objects() -- moved to Ships_functions.lua
	-- end

	load_probe()

	do_often("if SGES_XPlaneIsPaused == 0 and sges_gs_gnd_spd[0] < 20 then execute_service_objects() end")
	do_often("execute_environnemental_objects()") -- those ones needs to be available at any time
	do_every_frame("if SGES_XPlaneIsPaused == 0 and sges_gs_gnd_spd[0] < 250 then execute_DYNAMIC_service_objects() end") -- sometimes too many call back in the baggage function
	do_every_frame("if IsXPlane12 and SGES_XPlaneIsPaused == 0 and (show_Submarine or Submarine_chg) then service_object_physicsSubmarine() end")
	do_every_frame("if SGES_XPlaneIsPaused == 0 and sges_gs_gnd_spd[0] < 40 then execute_PUSHBACK_service_objects() end") -- from X-Plane 12/Resources/plugins/FlyWithLua/Scripts/Simple_Ground_Equipment_and_Services/Simple_Ground_Equipment_and_Services_Pushback.lua
	do_on_exit("exit_plugin()")


	--[[ Toggle Window ]]
	function windoz_toggle()
		if not XPJ_show then show_windoz() else hide_windoz() end
	end

	if not SGES_LegacyGUI then
		create_command("Simple_Ground_Equipment_and_Services/Window/Show", "Show the SGES menu", "loadOptions = true show_windoz()", "", "")
	end
	create_command("Simple_Ground_Equipment_and_Services/Window/Toggle", "Toggle Window", "windoz_toggle()", "", "")


	-- atrap2ss2 suggestion on February 2025
	-- It would be possible to add these 2 dataref in future versions for integration with other plugins, in this way it would be possible to call the services and start the sequence from other plugins.
	create_command("Simple_Ground_Equipment_and_Services/Services/StartSequenceAll", "Call to ground service in automatic sequence", "show_Pump = false show_Automatic_sequence_start = true SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec initial_pax_start = true baggage_pass = 0", "", "")
	-- walking_direction = \"boarding\"

	-- **************** THIS PART WAS ADDED FOR NEW WINDOW STYLE ********************** START **

	loadOptions = true --show_windoz()

		--########################################
		--# Prepare Text To Speak	             #
		--########################################

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

		local SpeakString = ffi.new("char[1024]")
		ffi.cdef("void XPLMSpeakString(const char * inString);")



	function SayInfoOnTarget()
		if show_FireVehicle and target_x ~= nil then
			Recompute_ref_rampservice(sges_gs_plane_x[0], sges_gs_plane_z[0], target_x, target_z, sges_gs_plane_head[0], target_y )

			--print(AccidentSite_absolute_heading .. " degrees Heading to target")
			-- convert relative bearing to Clock
			if AccidentSite_relative_heading >= 345 or AccidentSite_relative_heading < 15 then AccidentSite_OnClock = 12
			elseif AccidentSite_relative_heading >= 15 and AccidentSite_relative_heading < 45 then AccidentSite_OnClock = 1
			elseif AccidentSite_relative_heading >= 45 and AccidentSite_relative_heading < 75 then AccidentSite_OnClock = 2
			elseif AccidentSite_relative_heading >= 75 and AccidentSite_relative_heading < 105 then AccidentSite_OnClock = 3
			elseif AccidentSite_relative_heading >= 105 and AccidentSite_relative_heading < 135 then AccidentSite_OnClock = 4
			elseif AccidentSite_relative_heading >= 135 and AccidentSite_relative_heading < 165 then AccidentSite_OnClock = 5
			elseif AccidentSite_relative_heading >= 165 and AccidentSite_relative_heading < 195 then AccidentSite_OnClock = 6
			elseif AccidentSite_relative_heading >= 195 and AccidentSite_relative_heading < 225 then AccidentSite_OnClock = 7
			elseif AccidentSite_relative_heading >= 225 and AccidentSite_relative_heading < 255 then AccidentSite_OnClock = 8
			elseif AccidentSite_relative_heading >= 255 and AccidentSite_relative_heading < 285 then AccidentSite_OnClock = 9
			elseif AccidentSite_relative_heading >= 285 and AccidentSite_relative_heading < 315 then AccidentSite_OnClock = 10
			elseif AccidentSite_relative_heading >= 315 and AccidentSite_relative_heading < 345 then AccidentSite_OnClock = 11
			else AccidentSite_OnClock = -1 end

			AccidentSite_Distance_nm = math.floor((AccidentSite_Distance * 0.000539957)*10)/10




			if AccidentSite_Distance >= 10000 then XPLMSpeakString("Heading " ..  math.floor(AccidentSite_absolute_heading/10)*10 .. ". Distance " .. AccidentSite_Distance_nm .. " nautical miles")
			elseif AccidentSite_Distance >= 1000 then XPLMSpeakString("Heading " ..  AccidentSite_absolute_heading .. ". Distance " .. AccidentSite_Distance_nm .. " nautical miles")
			elseif AccidentSite_Distance > 100 then XPLMSpeakString("At " .. AccidentSite_OnClock ..  " O'Clock, heading " ..  AccidentSite_absolute_heading .. ". Distance " .. math.floor(AccidentSite_Distance/100)*100 .. " meters ")
			elseif AccidentSite_Distance > 60 then XPLMSpeakString("At " .. AccidentSite_OnClock ..  " O'Clock, heading " ..  AccidentSite_absolute_heading .. ". Distance " .. math.floor(AccidentSite_Distance/10)*10 .. " meters ")
			else XPLMSpeakString("" .. AccidentSite_OnClock ..  " O'Clock, plus " ..  AccidentSite_Delta_altitude .. ". and " .. AccidentSite_Distance .. " meters ")
			end

		end
	end

	create_command("Simple_Ground_Equipment_and_Services/Target_info/Speak", "Say some information about the target", "SayInfoOnTarget()", "", "")




	--------------------------------------------------------------------------------

	function load_xp11_sges_sounds()
		if SGES_sound then -- since SGES 65, this is now restricted to XP11 as we went to FMOD
			--########################################
			--#           SOUNDS                     #
			--########################################
			local	init_time = SGES_total_flight_time_sec

			if PilotHeadX == nil then dataref("PilotHeadX", "sim/graphics/view/view_x", "readonly") end
			if PilotHeadY == nil then dataref("PilotHeadY", "sim/graphics/view/view_y", "readonly") end
			if PilotHeadZ == nil then dataref("PilotHeadZ", "sim/graphics/view/view_z", "readonly") end
			if view_is_external_FEV == nil then dataref("view_is_external_FEV", "sim/graphics/view/view_is_external", "readonly") end


			if not IsXPlane12 then
				Engine_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Engine.wav") -- sound number 0
			end
			CatchWire_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Crash.wav") -- -- sound number 2


			Starting_PB_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Starting_PB.wav") -- sound number 3
			Clear_to_start_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Clear_to_start.wav") -- sound number 4
			Set_ParkBrake_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Set_ParkBrake.wav") -- -- sound number 5
			Tow_disconnected_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Tow_disconnected.wav") -- -- sound number 6

			Approaching_stand_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Approaching_stand.wav") -- -- sound number 7
			Stop_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Stop.wav") -- -- sound number 8

			AAR_Refueling_completed_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/AAR_Refueling_completed.wav")
			AAR_Clear_to_disco_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/AAR_Clear_to_disco.wav")
			AAR_Clear_contact_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/AAR_Clear_contact.wav")


			SGES_SoundLevel = 0.2 --important
			set_sound_gain(CatchWire_sound, 0.9)
			if not IsXPlane12 then
				set_sound_gain(Engine_sound, SGES_SoundLevel)
			end
			set_sound_gain(Starting_PB_sound, 1)
			set_sound_gain(Clear_to_start_sound, 1)
			set_sound_gain(Set_ParkBrake_sound, 1)
			set_sound_gain(Tow_disconnected_sound, 1)
			set_sound_gain(Approaching_stand_sound, 1)
			set_sound_gain(Stop_sound, 1)

			set_sound_gain(AAR_Refueling_completed_sound, 0.9)
			set_sound_gain(AAR_Clear_to_disco_sound, 0.3)
			set_sound_gain(AAR_Clear_contact_sound, 0.8)
			if not IsXPlane12 then
				let_sound_loop(Engine_sound,true) -- 0


				function Set_sound_level()
					-- find the distance to the aircraft
					local distanceX = math.abs(PilotHeadX - sges_gs_plane_x[0])
					local distanceZ = math.abs(PilotHeadZ - sges_gs_plane_z[0])
					local distanceY = math.abs(PilotHeadY - sges_gs_plane_y[0]) -- altitude, max is seven
					--~ print("Lati : " .. distanceX)
					--~ print("longi : " .. distanceZ)
					--~ print("ALTITUDE :" .. distanceY)
					--~ print("-- ")
					local retained_distance = distanceZ + distanceX
					-- when moving away, fade the sound
					if distanceZ > distanceX then retained_distance = distanceZ else retained_distance = distanceX end

					if SGES_XPlaneIsPaused == 1 then
						SGES_SoundLevel = 0.000000000000000000001
					else
						if view_is_external_FEV == 0 then -- reduce the sound from inside the plane
								SGES_SoundLevel = 0.025
						elseif 		(show_GPU or show_ASU or show_ACU or show_FUEL or show_Cart or show_Bus or show_Catering or show_PRM or show_FireVehicle or show_PB or show_Deice)
						then
							if retained_distance < 20 and distanceY < 15 then
									SGES_SoundLevel = 0.45
							elseif 		retained_distance < 30 and distanceY < 25 then
									SGES_SoundLevel = 0.35
							elseif 		retained_distance < 40 and distanceY < 35 then
									SGES_SoundLevel = 0.20
							elseif retained_distance < 50 or  distanceY < 50 then
									SGES_SoundLevel = 0.10
							elseif retained_distance >= 50 or  distanceY >= 50 or  sges_gs_gnd_spd[0] > 2 then
									SGES_SoundLevel = 0.000000000000000000001
							end			-- Baggage cart to test
						else
							SGES_SoundLevel = 0.000000000000000000001
						end
					end

					if not IsXPlane12 and SGES_sound and (show_GPU or show_ASU or show_ACU or show_FUEL or show_Cart or show_Bus or show_Catering or show_PRM or show_FM or show_FireVehicle or show_PB or show_Deice) and sges_gs_gnd_spd[0] < 1 then
					-- apply that :
						--print("set_sound_gain")
						set_sound_gain(Engine_sound, SGES_SoundLevel)
						--print("play sound")
					end


				end
				do_on_keystroke("Set_sound_level()") -- on view change for instance
				do_sometimes("if SGES_XPlaneIsPaused == 0 and sges_gs_gnd_spd[0] < 5 then Set_sound_level() end") -- regular watch
			end -- 		if not IsXPlane12 then
		end
	end
	if SGES_sound then load_xp11_sges_sounds() end

	print("[Ground Equipment " .. version_text_SGES .. "] The ground Equipment main Lua script has been read entirely by now.")

end
