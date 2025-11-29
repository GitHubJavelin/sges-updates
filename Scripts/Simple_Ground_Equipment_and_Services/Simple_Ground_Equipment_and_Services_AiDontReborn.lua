--------------------------------------------------------------------------------
-- Downed aircraft : prevent respawn :

print("[Ground Equipment " .. version_text_SGES .. "] Loading respawn prevention module from Simple Ground Equipment and Services")

-----------------------------------------------------------------------
--~ I have a problem in X-Plane 12. When AI got shot down by missile, they often go into a crazy whirling when they meet the ground. At this moment, X-Plane crashes.to the desktop, and outputs in the Log a fatal flight model error associated with the throttle management. In 12.07. So the combat actually is dangerous because at any moment a CTD can happen. I didn't have that before. I tested with the default F4 Phantom selected as AI aircraft after having got the problem with many AI models and still the same prob.
--~ I am coding an anti respawn function which captures the aircraft so hopefully I can catch any aircraft approaching the ground vicinity and disable it before the infamous whirling occurs. In order to be effective, I will need to capture the aircraft high enough above the ground though.
--~ https://forums.x-plane.org/index.php?/forums/topic/298110-fatal-flight-model-error-when-downed-ai-aircraft-reach-the-ground-and-depart-from-stable-flying/#comment-2643326
-----------------------------------------------------------------------

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
local w1 = ffi.new("int[1]")
local w2 = ffi.new("int[1]")
local w3 = ffi.new("int[1]")
local AIRCRAFT_FILENAME = ffi.new("char[1024]")
local AIRCRAFT_PATH = ffi.new("char[1024]")
local PLANE_COUNT
local PLANE_TOTAL
local PLANE_PLUGIN
ffi.cdef("typedef int XPLMPluginID")
ffi.cdef("void XPLMCountAircraft (int * outPLANE_COUNT, int * outPLANE_TOTAL, XPLMPluginID * outController)")
ffi.cdef("typedef void (* XPLMPlanesAvailable_f)(void * inRefcon)")
ffi.cdef("int XPLMAcquirePlanes ( char ** inAIRCRAFT_PATH, XPLMPlanesAvailable_f inCallback, void * inRefcon)")
ffi.cdef("void XPLMDisableAIForPlane (int inAI)")
ffi.cdef("void XPLMReleasePlanes(void)")
ffi.cdef("void XPLMSetActiveAircraftCount(int  inAct)")
ffi.cdef("void XPLMGetNthAircraftModel(int  inIndex,  char * outFileName, char * outPath)")
XPLM.XPLMCountAircraft (w1 , w2 , w3)
PLANE_COUNT, PLANE_TOTAL, PLANE_PLUGIN = w1[0], w2[0], w3[0]
local ground_intersection

--~ We will also replace the plane by a wildfire at the location where the airplane shot down went to the earth
-- lets prepare some 3D objects instantiations

IndustrialFire_ref = ffi.new("char *[7]")

function load_IndustrialFire(i)

	if IndustrialFire_instance[i] == nil and math.floor(plane_x["plane" .. i][0]) ~= 0 then
		print("[Ground Equipment " .. version_text_SGES .. "] Loading IndustrialFire_instance[" .. i .. "] because the adversary " .. i+1 .. " reached the Earth.")
			if IsXPlane12 then --force industrial fire, instead of wildfire. Best way to do this is to NOT use the prefilled fire object.
				XPLM.XPLMLoadObjectAsync(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround_XP12.obj",
				function(inObject, inRefcon)
					IndustrialFire_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					IndustrialFire_ref[i] = inObject
				end,
				inRefcon )
			else -- X-Plane 11 variant of the fire.
				XPLM.XPLMLoadObjectAsync(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround.obj",
				function(inObject, inRefcon)
					IndustrialFire_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					IndustrialFire_ref[i] = inObject
				end,
				inRefcon )
			end
	end
end

smoke_planes_chg = {plane1=false,plane2=false,plane3=false,plane4=false,plane5=false,plane6=false,plane7=false,plane8=false,plane9=false,plane10=false,plane11=false,plane12=false,plane13=false,plane14=false,plane15=false,plane16=false,plane17=false,plane18=false,plane19=false}

function draw_IndustrialFire(i)
	if IndustrialFire_instance[i] ~= nil and not smoke_planes_chg["plane" .. i] then -- enforce draw only once using the status not yet changed
		print("[Ground Equipment " .. version_text_SGES .. "] Drawing the fire [" .. i .. "] because the adversary " .. i+1 .. " reached the Earth.")
		_ = draw_from_simulator_coordinates(tonumber(plane_x["plane" .. i][0]), tonumber(plane_z["plane" .. i][0]),90,IndustrialFire_instance[i],"Fireball")

		-- enforce plane on the ground : (found to be unreliable withotu this second pass)
		local ground_intersection,_ = probe_y (plane_x["plane" .. i][0], plane_y["plane" .. i][0], plane_z["plane" .. i][0]) -- again, at exact location
		set("sim/multiplayer/position/plane" .. i .. "_y",ground_intersection-0.5)
		smoke_planes_chg["plane" .. i] = true
	end
end

function AcquireAircraft_sges()
	XPLM.XPLMCountAircraft (w1 , w2 , w3)
	PLANE_COUNT, PLANE_TOTAL, PLANE_PLUGIN = w1[0], w2[0], w3[0]
	local ai_plane_array = ffi.new("char *[7]")
	for i = 1, PLANE_COUNT-1 do  --  Grab the AI Plane details
		--~ print("[Ground Equipment " .. version_text_SGES .. "] Acquire i " .. i )
		--~ if disabled_planes["plane" .. i] == 2  then
			-- elevate all aircraft to avoid the infamous XP12 CTD near the ground with airplanes whirling
			if ground_intersection == nil then ground_intersection = 1000 end
			set("sim/multiplayer/position/plane" .. i .. "_y", ground_intersection + 4 * sges_capture_elevation_threshold)
			set("sim/multiplayer/position/plane" .. i .. "_the",0)
			set("sim/multiplayer/position/plane" .. i .. "_phi",0)
			set("sim/multiplayer/position/plane" .. i .. "_psi",0)
			set("sim/multiplayer/position/plane" .. i .. "_throttle",0,0.5)
		--~ end
		XPLM.XPLMGetNthAircraftModel(i, AIRCRAFT_FILENAME, AIRCRAFT_PATH)
		ai_plane_array[i] = AIRCRAFT_PATH
	end
	XPLM.XPLMAcquirePlanes(ai_plane_array, acquire_planes_callback, nil)
	XPLM.XPLMSetActiveAircraftCount(1)
end


function ReleaseAircraft_sges()
	-- remove the fire of downed AI :
	for j=1,19 do
		if disabled_planes["plane" .. j] == 2 then
			print("[Ground Equipment " .. version_text_SGES .. "] Removing crash site " .. j+1)
			_,IndustrialFire_instance[j],IndustrialFire_ref[j] = common_unload("Fireball",IndustrialFire_instance[j],IndustrialFire_ref[j])
			disabled_planes["plane" .. j] = -1
			smoke_planes_chg["plane" .. j] = false
		end
	end
	print("[Ground Equipment " .. version_text_SGES .. "] SGES Release AI aircraft. Total PLANE_COUNT " .. PLANE_COUNT)
	XPLM.XPLMReleasePlanes()
	XPLM.XPLMCountAircraft (w1 , w2 , w3)
	PLANE_COUNT, PLANE_TOTAL, PLANE_PLUGIN = w1[0], w2[0], w3[0]
	XPLM.XPLMSetActiveAircraftCount(PLANE_COUNT)
end
--~ Note There is no enableAIForPlane() function: you cannot simple re-enable AI.
--~ However, if you acquire all planes, set the active count to 1 (User aircraft only) and
--~ then reset the count to something larger than 1, all of the added aircraft will have their AI re-enabled once you call xp.releasePlanes()


-- we have the airplane multiplayer sim/multiplayer/position/plane1_el
	--~ sim/multiplayer/position/plane1_el	double	n	meters
	-- for active plane this value is above zero, otherwise is negative

-- we can sense the ground elevation below the active plane regularly
-- I'm doing a simlification : sense the ground elvel at user aircraft, to sense if we are in the Himalaya, or over the sea, that should be sufficient to trigger the down status

-- if the elevation and ground are the same, remove the aircraft from the game

-- declare the datarefs in a table we will watch
 plane_y = {plane1=-1,Plane2=-1,plane3=-1,plane4=-1,plane5=-1,plane6=-1,plane7=-1,plane8=-1,plane9=-1,plane10=-1,plane11=-1,plane12=-1,plane13=-1,plane14=-1,plane15=-1,plane16=-1,plane17=-1,plane18=-1,plane19=-1}
 plane_x = {plane1=-1,Plane2=-1,plane3=-1,plane4=-1,plane5=-1,plane6=-1,plane7=-1,plane8=-1,plane9=-1,plane10=-1,plane11=-1,plane12=-1,plane13=-1,plane14=-1,plane15=-1,plane16=-1,plane17=-1,plane18=-1,plane19=-1}
 plane_z = {plane1=-1,Plane2=-1,plane3=-1,plane4=-1,plane5=-1,plane6=-1,plane7=-1,plane8=-1,plane9=-1,plane10=-1,plane11=-1,plane12=-1,plane13=-1,plane14=-1,plane15=-1,plane16=-1,plane17=-1,plane18=-1,plane19=-1}

ground_intersectionation_meters = {plane1=-1,Plane2=-1,plane3=-1,plane4=-1,plane5=-1,plane6=-1,plane7=-1,plane8=-1,plane9=-1,plane10=-1,plane11=-1,plane12=-1,plane13=-1,plane14=-1,plane15=-1,plane16=-1,plane17=-1,plane18=-1,plane19=-1}

disabled_planes = {plane1=-1,plane2=-1,plane3=-1,plane4=-1,plane5=-1,plane6=-1,plane7=-1,plane8=-1,plane9=-1,plane10=-1,plane11=-1,plane12=-1,plane13=-1,plane14=-1,plane15=-1,plane16=-1,plane17=-1,plane18=-1,plane19=-1}


local j=1
for j=1,19 do
	plane_y["plane" .. j] = dataref_table("sim/multiplayer/position/plane" .. j .. "_y")
	plane_x["plane" .. j] = dataref_table("sim/multiplayer/position/plane" .. j .. "_x")
	plane_z["plane" .. j] = dataref_table("sim/multiplayer/position/plane" .. j .. "_z")
	if math.floor(plane_x["plane" .. j][0]) ~= 0 then
		local worldx,worldz,_ =local_to_latlon(tonumber(plane_x["plane" .. j][0]),0,tonumber(plane_z["plane" .. j][0]))
		print("[Ground Equipment " .. version_text_SGES .. "] AI airplane " .. j+1 .. " seen at x;z :" .. worldx .. " ; " .. worldz)
	--~ else
		--~ print("[Ground Equipment " .. version_text_SGES .. "] No AI airplane " .. j+1)
	end
	if j == 19 then print("[Ground Equipment " .. version_text_SGES .. "] plane_x and plane_z dataref table prepared." ) end
end

-- watch the AI elevations
function watch_AI_altitudes()
	if PLANE_COUNT > 1 then
		local i=1
		for i=1,PLANE_COUNT-1 do
			if disabled_planes["plane" .. i] == -1  then

				ground_intersection,_ = probe_y (plane_x["plane" .. i][0], plane_y["plane" .. i][0], plane_z["plane" .. i][0])
				--~ print("Aircraft " .. i+1 .. " ground_intersection is " .. math.floor(ground_intersection) .. "ua and aircraft y is " .. math.floor(plane_y["plane" .. i][0]) .. "ua." .. disabled_planes["plane" .. i] )
				if plane_y["plane" .. i][0] < ground_intersection + sges_capture_elevation_threshold then -- THE ACFT IS DOWN
					-- disabled it from the sim
					disabled_planes["plane" .. i] = 2
					print("[Ground Equipment " .. version_text_SGES .. "] Going to disable AIRCRAFT " .. i+1 .. "...")
					XPLM.XPLMDisableAIForPlane(i)
					-- put that in a semi-buried attitude :
					set("sim/multiplayer/position/plane" .. i .. "_the",-45)
					set("sim/multiplayer/position/plane" .. i .. "_phi",90)
					set("sim/multiplayer/position/plane" .. i .. "_psi",0)
					set("sim/multiplayer/position/plane" .. i .. "_throttle",0,0)
					set("sim/multiplayer/position/plane" .. i .. "_x",tonumber(plane_x["plane" .. i][0]))
					set("sim/multiplayer/position/plane" .. i .. "_z",tonumber(plane_z["plane" .. i][0]))
					set("sim/multiplayer/position/plane" .. i .. "_nav_lights_on",0)
					set("sim/multiplayer/position/plane" .. i .. "_strobe_lights_on",0)
					set("sim/multiplayer/position/plane" .. i .. "_beacon_lights_on",0)
					set("sim/multiplayer/position/plane" .. i .. "_landing_lights_on",0)
					set("sim/multiplayer/position/plane" .. i .. "_taxi_light_on",0)
					ground_intersection,_ = probe_y (plane_x["plane" .. i][0], plane_y["plane" .. i][0], plane_z["plane" .. i][0]) -- again, at exact location
					set("sim/multiplayer/position/plane" .. i .. "_y",ground_intersection-0.5)
					----------------------
					-- show a fire on the ground :
					if tonumber(plane_x["plane" .. i][0]) ~= 0 then print("[Ground Equipment " .. version_text_SGES .. "] Airplane " .. i+1 .. " crashed at x;z :" .. tonumber(plane_x["plane" .. i][0]) .. " ; " .. tonumber(plane_z["plane" .. i][0])) end
					load_IndustrialFire(i)
					----------------------
					print("[Ground Equipment " .. version_text_SGES .. "] Killed in action : AIRCRAFT " .. i+1 .. " (KIA).")
				end
			elseif disabled_planes["plane" .. i] == 2 then
					draw_IndustrialFire(i)
			end
		end
	end
end

function watch_AI_count()
	if PLANE_COUNT <= 2 then
		XPLM.XPLMCountAircraft (w1 , w2 , w3)
		PLANE_COUNT, PLANE_TOTAL, PLANE_PLUGIN = w1[0], w2[0], w3[0]
	end
end

do_sometimes("if prevent_respawn and SGES_XPlaneIsPaused == 0  then watch_AI_count() end")
do_often("if prevent_respawn and SGES_XPlaneIsPaused == 0  then watch_AI_altitudes() end")
sges_respawn_loaded = true


