print("[Front Line] Loading front line expansion from Simple Ground Equipment and Services")

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

--~ local FrontLine_instance = ffi.new("XPLMInstanceRef[101]")
FrontLine_instance = {} -- allow more than 101
local max_objects = 400
local draw_distance_max = 15000  -- en mètres 15km

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
frontline_points = 0

--------------- FIND ALL PROFILES

--~ local profile_files = {"Arras-1917.txt","France-1917.txt","Clairmarais-1917.txt","Normandy-1944.txt","Custom-1.txt","Custom-2.txt","Custom-3.txt","Custom-4.txt"}
local profile_files = {"Arras-1917.txt","Clairmarais-1917.txt","Normandy-1944.txt","AShau-1965.txt","Custom-1.txt","Custom-2.txt"}

local current_file_index = 1

function load_next_profile()
    local file_path = profile_files[current_file_index]
    --~ print("[Front Line] Selected profile: " .. file_path)

    -- Prépare l’index pour le prochain appel
    current_file_index = current_file_index + 1
    if current_file_index > #profile_files then
        current_file_index = 1  -- boucle infinie

    end
	return file_path
end

----------------------------------------------

-- Fonction de chargement des coordonnées
if Default_Front_line_profile == nil then Default_Front_line_profile = true end
function sges_Load_locations()

	local folder_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/"
	--~ local file_path = load_next_profile()
	local file_path = front_line_file_path
    --~ local file_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/" .. "France-1917.txt"
	--~ if Default_Front_line_profile ~= nil and not Default_Front_line_profile then
		--~ file_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/" .. "Custom.txt"
	--~ end

    local file = io.open(folder_path .. file_path, "r")

    if file == nil then
		print("[Front Line] Impossible to open " .. folder_path .. file_path)
        return
    end

    local index = 1

    for line in file:lines() do
		if not string.match(line, "^#") and not string.match(line, "^@") then
			-- Supprimer les espaces inutiles
			line = string.gsub(line, "%s+", "")
			-- Remplacer la virgule décimale par un point
			line = string.gsub(line, ",", ".")
			-- Extraire latitude et longitude séparées par un point-virgule
			local lat_str, lon_str = string.match(line, "([%d%.%-]+);([%d%.%-]+)")
			if lat_str ~= nil and lon_str ~= nil then
				local lat = tonumber(lat_str)
				local lon = tonumber(lon_str)
				--~ print("[Front Line] Front Line point " .. lat .. " ; " .. lon)
				FLx[index], _, FLz[index] = latlon_to_local(lat, lon, 0)
				index = index + 1
			--~ else
				--~ print("[Front Line] Ignored : " .. line)
			end
		elseif string.match(line, "^@") then
			Front_line_title = string.sub(string.match(line, "^@(.+)"),1,30)
			--~ Front_line_title = line
			print("[Front Line] " .. line)
		end
    end

    file:close()
	--~ print("[Front Line] " .. string.sub(file_path, -50))
	print("[Front Line] Seeing " .. tostring(index - 1) .. " couples of coordinates.")
	frontline_points = index - 1
	if Front_line_title ~= nil then
		return Front_line_title
	end
end

function sges_retrieve_profile_title()
	local folder_path = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Front_line_profiles/"
	local file_path = front_line_file_path
    local file = io.open(folder_path .. file_path, "r")
    if file == nil then
		print("[Front Line] Impossible to open " .. folder_path .. file_path)
        return
    end
    for line in file:lines() do
		if string.match(line, "^@") then
			preselected_Front_line_title = string.sub(string.match(line, "^@(.+)"),1,30)
			--~ Front_line_title = line
			--~ print("[Front Line] " .. line)
		end
    end
    file:close()
	if preselected_Front_line_title ~= nil then
		return preselected_Front_line_title
	end
end

-- Coordonnées interpolées (densifiées)
FLx_densified = {}
FLz_densified = {}

-- Densification de la ligne de front
function densify_Front_Line(step_distance_m)
	FLx_densified = {}
	FLz_densified = {}
	local densified_index = 1

	if #FLx == 1 then
		FLx_densified = { FLx[1] }
		FLz_densified = { FLz[1] }
		print("[Front Line] Only one battle point in the input profile. We set an object only once.")
		return
	end

	for i = 1, #FLx - 1 do
		local x1 = FLx[i]
		local z1 = FLz[i]
		local x2 = FLx[i+1]
		local z2 = FLz[i+1]

		local dx = x2 - x1
		local dz = z2 - z1
		local dist = math.sqrt(dx*dx + dz*dz)
		--~ print("[Front Line] dist : " .. dist)
		--~ if dist > 10000 then 	step_distance_m = 10000
		--~ else					step_distance_m = 5000
		--~ end
		local steps = math.max(1, math.floor(dist / step_distance_m))  -- au moins un point
		for s = 0, steps do
			local ratio = s / steps
			local x = x1 + dx * ratio
			local z = z1 + dz * ratio
			FLx_densified[densified_index] = x
			FLz_densified[densified_index] = z
			densified_index = densified_index + 1
		end
	end
	--~ print("[Front Line] Total in-between points added : " .. tostring(#FLx_densified))
end

function load_Front_Line()
	for i = 1, #FLx_densified do
		--~ print("[Ground Equipment " .. version_text_SGES .. "] Checking Front Line... ...point " .. i)
		if FrontLine_instance[i] == nil then
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
	print("[Front Line] Unloading Front Line...")
	for i = 1, #FLx_densified do
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
	FLx_densified = {}
	FLz_densified = {}
	FrontLineRef = {}
	Front_Line_chg = false
	Front_Line_object_spacing = Front_Line_object_spacing_init
	--~ Front_line_title  = nil
	total_number_of_battles = nil
end

function draw_Front_Line()
	local heading_modifier = 90
	for i = 1, #FLx_densified do
		if FrontLine_instance[i] ~= nil then

		-- Calcul de distance à l'avion
			local dx = FLx_densified[i] - sges_gs_plane_x[0]
			local dz = FLz_densified[i] - sges_gs_plane_z[0]
			local dist2 = dx * dx + dz * dz

			if sges_gs_ias_spd[0] >= 200 then -- when the aircraft is fast, preload more
				draw_distance_max = 22000
			elseif sges_gs_ias_spd[0] < 1 then -- when the aircraft is stopped
				draw_distance_max = 5000
			else
				draw_distance_max = 15000 -- ortherwise keep FPS high
			end

			-- dessiner uniquement les objets proches de l’avion
			-- Pour éviter de faire un math.sqrt() à chaque point (plus lent), on compare le carré de la distance directement :
			if dist2 <= draw_distance_max * draw_distance_max then
				objpos_value[0].x = FLx_densified[i]
				objpos_value[0].z = FLz_densified[i]
				objpos_value[0].y, _ = probe_y(objpos_value[0].x, 0, objpos_value[0].z)
			else
				--~ print("[Front Line] Hiding battle point " .. i .. " away (because more than " .. math.floor(draw_distance_max/1000) .. " km away from your plane).")
				-- hide away to unload the GPU
				objpos_value[0].x = 0
				objpos_value[0].z = 0
				objpos_value[0].y = -5000  -- sous le sol
			end
			-- Orientation perpendiculaire à la ligne (entre i et i+1)
			if i < #FLx_densified then
				local sx = FLx_densified[i+1] - FLx_densified[i]
				local sz = FLz_densified[i+1] - FLz_densified[i]
				local angle = math.atan2(sz, sx)
				local heading = angle + math.pi / 2  -- perpendiculaire
				objpos_value[0].heading = math.deg(heading) + heading_modifier
				--~ if heading_modifier == 90 then heading_modifier = - 90 else heading_modifier = 90 end

			else
				-- Dernier point : reprendre l'angle du précédent
				objpos_value[0].heading = objpos_value[0].heading or 0
			end
			objpos_value[0].pitch = 0
			float_addr = float_value
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(FrontLine_instance[i], objpos_addr, float_addr)

		end
	end
	Front_Line_chg = false
end

--~ Front_Line_density = false
local Front_Line_object_spacing = 250
local Front_Line_object_spacing_init = 250

function Front_Line_object_physics()

    --~ print("Appel de Front_Line_object_physics()")  -- DEBUG
	if Front_Line_chg == true then
		if show_Front_Line then
			if FrontLine_instance[1] == nil then
				sges_Load_locations()
				densify_Front_Line(Front_Line_object_spacing)  -- <-- ICI : densification tous les 100 m ou 5000 m
				if #FLx_densified > frontline_points then
					while(#FLx_densified > max_objects)
					do
						Front_Line_object_spacing = Front_Line_object_spacing * 2
						densify_Front_Line(Front_Line_object_spacing)
						print("[Front Line] Trying " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
					end
				end
				print("[Front Line] In the end, spacing " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
				print("[Front Line] All battle points away from your plane will be hidden in X-Plane to ease the GPU workload.")
				total_number_of_battles = tonumber(#FLx_densified)
				load_Front_Line()
				Front_Line_object_spacing = Front_Line_object_spacing_init -- reinit
			end
		else
			unload_Front_Line_Objects()
		end
		if FrontLine_instance[1] ~= nil  then
			draw_Front_Line()
		end
	end

	if show_Front_Line and FrontLine_instance[1] ~= nil then
		-- Mise à jour continue pendant le vol
		draw_Front_Line()
	end
end

function Front_Line_object_physics()

	if show_Front_Line then
		if Front_Line_chg and FrontLine_instance[1] == nil then
			sges_Load_locations()
			densify_Front_Line(Front_Line_object_spacing)

			if #FLx_densified > frontline_points then
				while (#FLx_densified > max_objects) do
					Front_Line_object_spacing = Front_Line_object_spacing * 2
					densify_Front_Line(Front_Line_object_spacing)
					print("[Front Line] Trying " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
				end
			end
			print("[Front Line] In the end, spacing " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
			load_Front_Line()
			Front_Line_object_spacing = Front_Line_object_spacing_init
			Front_Line_chg = false
		end

		if FrontLine_instance[1] ~= nil then
			draw_Front_Line()
		end
	elseif Front_Line_chg and not show_Front_Line then
		unload_Front_Line_Objects()
	end
end

do_often("if SGES_XPlaneIsPaused == 0 then Front_Line_object_physics() end") --make that once by button pressure
