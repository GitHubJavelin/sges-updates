--------------------------------------------------------------------------------
-- VDGS, April 2024
--------------------------------------------------------------------------------


VDGS_module_loaded = true
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
-- init, will be overwritten dynamically later :
local VDGS_x = 0
local VDGS_z =0 -- make the VDGS stand outside the parking location
local VDGS_h = 0
local alti_VDGS_y = 0
VDGS_slider_factor = 0 --IAS24
if BeltLoaderFwdPosition >= 15 then VDGS_slider_factor = 2 end --IAS24

--~ local VDGSFixed_object = SCRIPT_DIRECTORY .. "../../../default scenery/900 us objects/obstacles/radio_50.obj"
local VDGSFixed_object_local = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/VDGS/VDGSFixed.obj"
local VDGSFixed_object_zulu = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/VDGS/VDGSFixed-zulu.obj"
SGES_VDGS_object_geometry_factor = 0 -- hide part of the object as required depending on the 3D
local VDGSMobile_object = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/VDGS/VDGSMobile.obj"

show_VDGS_only_once = true

-- used arbitrary to store info about the object
local objpos_addr =  ffi.new("const XPLMDrawInfo_t*")
local objpos_value = ffi.new("XPLMDrawInfo_t[1]")

-- use arbitrary to store float value & addr of float value
local float_addr = ffi.new("const float*")
local float_value = ffi.new("float[1]")

-- meant for the probe
local probeinfo_addr =  ffi.new("XPLMProbeInfo_t*")
local probeinfo_value = ffi.new("XPLMProbeInfo_t[1]")

local VDGSFixed_ref = ffi.new("XPLMObjectRef")            -- for the ground service
local VDGSMobile_ref = ffi.new("XPLMObjectRef")            -- for the ground service

local VDGS_instance = ffi.new("XPLMInstanceRef[2]")
-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")

-- to store in values of the local nature of the terrain (wet / land)
--~ local terrain_nature = ffi.new("int[1]")

--~ ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")
--~ ffi.cdef("void XPLMLocalToWorld(double inX,  double inY,   double inZ,   double *   outLatitude,      double *     outLongitude,   double *     outAltitude);")

-----------------------------------
-- ANIMATION PARAMETERS
-----------------------------------


--~ local sges_gs_plane_gear_x 		= dataref_table("sim/aircraft/parts/acf_gear_xnodef") -- treat as zero
--~ local sges_gs_plane_gear_z 		= dataref_table("sim/aircraft/parts/acf_gear_znodef")
-- we'll hope that  sges_gs_plane_gear_x[0]  sges_gs_plane_gear_z[0] is always for the nose gear.
-- location of the Nth gear's attach point relative to the CG, airplane coordinates. This does not change as gear is raised.

function VDGS_stand_distance_calc(plane_x, plane_z, in_target_x, in_target_z, in_heading, VDGS_y )
 local  in_delta_x = plane_x - in_target_x
  local in_delta_z = plane_z - in_target_z
  local stand_distance = math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) )
  --~ print("VDGS : stand_distance = " .. stand_distance)
  return stand_distance/20 -- the movement quantify the distance to the parking stand
end

-----------------------------------
-- 3D OBJECTS for the VDGS
-----------------------------------

function load_VDGS()
	if VDGS_instance[0] == nil and show_VDGS_only_once then
	print("[Ground Equipment " .. version_text_SGES .. "] load_VDGS(). We use the aircraft gear indexed as 0.")
	if VDGS_time ~= nil and VDGS_time== "zulu" then VDGSFixed_object = VDGSFixed_object_zulu
	else VDGSFixed_object = VDGSFixed_object_local end
	   XPLM.XPLMLoadObjectAsync(VDGSFixed_object,
				function(inObject, inRefcon)
				VDGS_instance[0] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				VDGSFixed_ref = inObject
				end,
				inRefcon )
	end

	if VDGS_instance[1] == nil then
	   XPLM.XPLMLoadObjectAsync(VDGSMobile_object,
				function(inObject, inRefcon)
				VDGS_instance[1] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
				VDGSMobile_ref = inObject
				end,
				inRefcon )
	end
	show_VDGS_only_once = false
end

function unload_VDGS()
	print("[Ground Equipment " .. version_text_SGES .. "] Unloading VDGS module")
	if VDGS_instance[0] ~= nil then       XPLM.XPLMDestroyInstance(VDGS_instance[0]) end
	if VDGS_instance[1] ~= nil then       XPLM.XPLMDestroyInstance(VDGS_instance[1]) end
	if VDGSFixed_ref ~= nil then     XPLM.XPLMUnloadObject(VDGSFixed_ref)  end
	if VDGSMobile_ref ~= nil then     XPLM.XPLMUnloadObject(VDGSMobile_ref)  end
	VDGS_instance[0] = nil
	VDGS_instance[1] = nil
	VDGSFixed_ref = nil
	VDGSMobile_ref = nil
	show_VDGS_only_once = true
end

	

do_on_exit("unload_VDGS()")



function draw_VDGS()
	if VDGS_instance[0] ~= nil and VDGS_instance[1] ~= nil then

		if retained_parking_position_heading == nil or VDGS_manual then retained_parking_position_heading = sges_gs_plane_head[0] end

		--VDGS_manual is true when the manual stand is requested by contrast to wide or narrow automatic search

		-- update all data with current selected stand coordinates :
		if TargetMarkerX_stored ~= nil and TargetMarkerZ_stored ~= nil then
			VDGS_x = TargetMarkerX_stored -- save the value, since that has some interactions
			VDGS_z = TargetMarkerZ_stored   -- make the VDGS stand outside the parking location
		elseif VDGS_x == nil or VDGS_z == nil then
			VDGS_x = 0
			VDGS_z = 0 -- safety
		end

		VDGS_h = retained_parking_position_heading - 180
		-- those are already given in local simulator coordinates !

		-- fixed part
		if VDGS_slider_factor == nil then VDGS_slider_factor = 0 end
		coordinates_of_adjusted_ref_rampservice(VDGS_x, VDGS_z, 0, 15+VDGS_slider_factor, retained_parking_position_heading)

		-- no need of World to local in this very case
		local alti_VDGS_y,wetness = probe_y(g_shifted_x, 0, g_shifted_z)
		objpos_value[0].y = alti_VDGS_y + SGES_VDGS_object_geometry_factor
		objpos_value[0].x = g_shifted_x
		objpos_value[0].z = g_shifted_z
		objpos_value[0].heading = VDGS_h
		objpos_value[0].pitch = 0
		objpos_value[0].roll = 0
		float_value[0] = 0
		float_addr = float_value
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(VDGS_instance[0], objpos_addr, float_addr) end

		------------------------------------------------------------------------
		------------------------------------------------------------------------
		--			MOBILE PART

		local mobile_VDGS_movement = VDGS_stand_distance_calc(NosePositionX, NosePositionZ, VDGS_x, VDGS_z, VDGS_h, alti_VDGS_y)

		-- mobile part, only the vertical component is changing
		if mobile_VDGS_movement * 20 < 25.55 then
			objpos_value[0].y = alti_VDGS_y + mobile_VDGS_movement -- the indicator is visible only when on the screen
		else -- outside the range defined by the size of the Safe dock screen, I'll just hide it far below the ground
			objpos_value[0].y = alti_VDGS_y - 200
		end
		objpos_addr = objpos_value
		if wetness == 0 then 		XPLM.XPLMInstanceSetPosition(VDGS_instance[1], objpos_addr, float_addr)  end

		------------------------------------------------------------------------
		------------------------------------------------------------------------
	end
end


function VDGS_object_physics()


	if VDGS_chg == true then
	  if show_VDGS then

		--~ print("[Ground Equipment " .. version_text_SGES .. "] Loading 3D objects part of the visual docking guidance system " .. VDGS_x .. " ; " .. VDGS_z)
		load_VDGS()
	  else
		unload_VDGS()
		VDGS_chg = false
		show_VDGS = false
	  end
	  if VDGS_instance[0] ~= nil and VDGS_instance[1] ~= nil then
		  draw_VDGS()
	  end
	end
end

--~ print("[Ground Equipment " .. version_text_SGES .. "] VDGS do_often")
do_every_draw("if SGES_XPlaneIsPaused == 0 and (show_VDGS or VDGS_chg) then VDGS_object_physics() end") --make that once by button pressure

print("[Ground Equipment " .. version_text_SGES .. "] VDGS ready !")



