print("[Ground Equipment " .. version_text_SGES .. "] Loading front Line module from Simple Ground Equipment and Services")

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



-- used arbitrary to store info about the object
local objpos_addr =  ffi.new("const XPLMDrawInfo_t*")
local objpos_value = ffi.new("XPLMDrawInfo_t[1]")

-- use arbitrary to store float value & addr of float value
local float_addr = ffi.new("const float*")
local float_value = ffi.new("float[1]")

-- meant for the probe
local probeinfo_addr =  ffi.new("XPLMProbeInfo_t*")
local probeinfo_value = ffi.new("XPLMProbeInfo_t[1]")

local FrontLineRef = {}

local FrontLine_instance = ffi.new("XPLMInstanceRef[101]")
-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")

-- to store in values of the local nature of the terrain (wet / land)
ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")
-----------------------------------
-- FIND FRONT LINE LOCATION
-----------------------------------

-- Déclarations des tableaux
FLx = {}
FLz = {}
-- Fonction de chargement des coordonnées
if Default_Front_line_profile == nil then Default_Front_line_profile = true end
function sges_Load_locations()
    local file_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/" .. "France-1917.txt"
	if Default_Front_line_profile ~= nil and not Default_Front_line_profile then
		file_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/" .. "Custom.txt"
	end

    local file = io.open(file_path, "r")

    if file == nil then
		print("[Ground Equipment " .. version_text_SGES .. "] Impossible to open " .. file_path)
        return
    end

    local index = 1

    for line in file:lines() do
        -- Supprimer les espaces inutiles
        line = string.gsub(line, "%s+", "")
        -- Remplacer la virgule décimale par un point
        line = string.gsub(line, ",", ".")
        -- Extraire latitude et longitude séparées par un point-virgule
        local lat_str, lon_str = string.match(line, "([%d%.%-]+);([%d%.%-]+)")
        if lat_str ~= nil and lon_str ~= nil then
            local lat = tonumber(lat_str)
            local lon = tonumber(lon_str)
            print("[Ground Equipment " .. version_text_SGES .. "] Front Line point " .. lat .. " ; " .. lon)
            FLx[index], _, FLz[index] = latlon_to_local(lat, lon, 0)
            index = index + 1
        else
            print("[Ground Equipment " .. version_text_SGES .. "] Ignored : " .. line)
        end
    end

    file:close()
	print("[Ground Equipment " .. version_text_SGES .. "] " .. file_path)
	print("[Ground Equipment " .. version_text_SGES .. "] Front Line has " .. tostring(index - 1) .. " couples of coordinates.")
end



function load_Front_Line()
	--~ if file_exists(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj") then
		--~ FL_object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj"
	--~ else
		--~ FL_object = User_Custom_Prefilled_BusObject_military_small
	--~ end
	--~ if file_exists(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/M-48_A1.obj") then
		--~ FL1_object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/M-48_A1.obj"
	--~ else
		--~ FL1_object = FL_object
	--~ end

	for i = 1, #FLx do
		--~ print("[Ground Equipment " .. version_text_SGES .. "] Checking Front Line... ...point " .. i)
		if FrontLine_instance[i] == nil then

			--~ print("[Ground Equipment " .. version_text_SGES .. "] Loading Front Line... ...point " .. i)
			local object = Prefilled_FireAndSmokeObject -- X-Plane 11
			if IsXPlane12 then object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/FlameGround_XP12_battle.obj" end
		   XPLM.XPLMLoadObjectAsync(object,
					function(inObject, inRefcon)
					FrontLine_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					FrontLineRef[i] = inObject
					end,
					inRefcon )


		end
	end
end

function unload_Front_Line_Objects()
	print("[Ground Equipment " .. version_text_SGES .. "] Unloading Front Line...")
	for i = 1, #FLx do
		if FrontLine_instance[i] ~= nil then
			--~ print("[Ground Equipment " .. version_text_SGES .. "] Unloading Front Line... ...point " .. i)
			if FrontLine_instance[i] ~= nil then       XPLM.XPLMDestroyInstance(FrontLine_instance[i]) end
			if FrontLineRef[i] ~= nil then     XPLM.XPLMUnloadObject(FrontLineRef[i])  end
			FrontLine_instance[i] = nil
			FrontLineRef[i] = nil
		end
	end
	-- Vider les coordonnées
	FLx = {}
	FLz = {}
	Front_Line_chg = false
end

function draw_Front_Line()
	for i = 1, #FLx do
		if FrontLine_instance[i] ~= nil then
			print("[Ground Equipment " .. version_text_SGES .. "] Drawing the Front Line point " .. i .. " at " .. FLx[i] .. " ; " .. FLz[i])
			objpos_value[0].x = FLx[i]
			objpos_value[0].z = FLz[i]
			objpos_value[0].y,_ = probe_y(objpos_value[0].x, 0, objpos_value[0].z)
			math.randomseed(os.time())
			randomView = math.random()
			if randomView > 0.50 then
				objpos_value[0].heading = sges_gs_plane_head[0] - 180
			else
				objpos_value[0].heading = sges_gs_plane_head[0]
			end
			objpos_value[0].pitch = 0
			float_addr = float_value
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(FrontLine_instance[i], objpos_addr, float_addr)
		end
	end
	Front_Line_chg = false
end

function Front_Line_object_physics()

    --~ print("Appel de Front_Line_object_physics()")  -- DEBUG
	if Front_Line_chg == true then
		if show_Front_Line then
			if FrontLine_instance[1] == nil then
				sges_Load_locations()
				load_Front_Line()
			end
		else
			unload_Front_Line_Objects()
		end
		if FrontLine_instance[1] ~= nil  then
			draw_Front_Line()
		end
	end
end

do_often("if SGES_XPlaneIsPaused == 0 then Front_Line_object_physics() end") --make that once by button pressure
