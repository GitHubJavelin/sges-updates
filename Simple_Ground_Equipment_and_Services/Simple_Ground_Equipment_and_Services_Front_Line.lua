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
local FrontLine3DRef = {}
local FrontLineSandbagsRef = {}

--~ local FrontLine_instance = ffi.new("XPLMInstanceRef[101]")
FrontLine_instance = {} -- allow more than 101
FrontLine_threeD_instance = {} -- allow more than 101
FrontLine_sandbags_instance = {}
heading_object_modifier = {}
local max_objects = 350
local draw_distance_max = 15000  -- en mètres 15km

-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")

-- to store in values of the local nature of the terrain (wet / land)
ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")



LoadedObjects = {}   -- cache global

function load_object_once(path)
    if LoadedObjects[path] ~= nil then
        return LoadedObjects[path]
    end

    XPLM.XPLMLoadObjectAsync(path,
        function(obj)
            LoadedObjects[path] = obj
        end,
        nil
    )
end

function all_instances_created()
    for i = 1, #FLx_densified do
        if FrontLine_instance[i] == nil then
            return false
        end
    end
    return true
end


local Front_Line_chg_bat1 = true
local Front_Line_chg_bat2 = true
local Front_Line_chg_bat3 = true

-----------------------------------
-- FIND FRONT LINE LOCATION
-----------------------------------

-- Déclarations des tableaux
FLx = {}
FLz = {}
frontline_points = 0

--------------- FIND ALL PROFILES
--~ local profile_files = {"Arras-1917.txt","France-1917.txt","Clairmarais-1917.txt","Normandy-1944.txt","Custom-1.txt","Custom-2.txt","Custom-3.txt","Custom-4.txt"}
local profile_files = {"Arras-1917.txt","Clairmarais-1917.txt","Normandy-1944.txt","AShau-1965.txt","Custom-1.txt","Custom-2.txt","Custom-3.txt","Custom-4.txt"}

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

	if front_line_file_path == nil then
		front_line_file_path = load_next_profile()
		file_path  = front_line_file_path
		file_path = "Custom-2.txt"
		preselected_Front_line_title = sges_retrieve_profile_title()
	end --default for when called via macro

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
				--~ FLx[index], _, FLz[index] = latlon_to_local(lat, lon, 0)
				FLx[index] = lat
				FLz[index] = lon
				index = index + 1
			--~ else
				--~ print("[Front Line] Ignored : " .. line)
			end
		elseif string.match(line, "^@") then
			Front_line_title = string.sub(string.match(line, "^@(.+)"),1,30)
			--~ Front_line_title = line
			print("[Front Line] In use now : " .. line)
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
		-- calculer en local mais stocker en lat lon les vrais coordonées pour ne pas les rendre sensibles aux coordonnées DSF locales dans X-Plane
		--~ local x1 = FLx[i]
		--~ local z1 = FLz[i]
		--~ local x2 = FLx[i+1]
		--~ local z2 = FLz[i+1]

		local x1, _, z1 = latlon_to_local(FLx[i],   FLz[i],   0)
		local x2, _, z2 = latlon_to_local(FLx[i+1], FLz[i+1], 0)

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
			FLx_densified[densified_index], FLz_densified[densified_index], _  = local_to_latlon(x, 0, z)

			densified_index = densified_index + 1
		end
	end
	--~ print("[Front Line] Total in-between points added : " .. tostring(#FLx_densified))
end


function load_Front_Line()
	local count_all_gaps = 0
	local gap_threshold = 0.125
	local battles_with_sounds = 0
	math.randomseed(os.time())


				-- 2026 04 11  adding optional 3D objects

	local SandbagsObject = io.open(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/pak38/SANDBAGS.obj", "r")
	if SandbagsObject ~= nil then
		SandbagsObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/pak38/SANDBAGS.obj"-- 1.9 Mo
	else
		print("[Front Line] Optional SANDBAGS.obj not found. It's here : https://forums.x-plane.org/files/file/99551-pak-38-anti-tank-gun-and-pak-38-anti-tank-gun-nest/")
	end


	local targetObject = io.open(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/Chi-nu/chinu.obj", "r")
	if targetObject ~= nil then
		targetObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/Chi-nu/chinu.obj" -- 8,3 Mo
		targetObject4 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/Chi-nu/chinu.obj" -- 8,3 Mo- 1.9 Mo
	else
		print("[Front Line] Optional chinu.obj not found. It's here : https://forums.x-plane.org/files/file/99525-chi-nu/")
	end

	local targetObject4 = io.open(SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/pak38/pak38.obj", "r")
	if targetObject4 ~= nil then
		targetObject4 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Front_Lines_optional_objects/pak38/pak38.obj" -- 8,3 Mo
	end
	local targetObject2 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/WillysMB.obj" -- 4.4 Mo
	local targetObject3 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/M-48_A1.obj" -- 31Mo
	if targetObject4 == nil then targetObject4 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/WillysMB.obj" end

	if modern_assets ~= nil and modern_assets then
		targetObject = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Ground_carts/Van_Camo_b.obj" -- 112 Ko
		targetObject2 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj" -- 942 Ko
		targetObject3 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj" -- 942 Ko
		targetObject4 = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/BTR-80_Target/objects/BTR-80.obj" -- 942 Ko
	end


	for i = 1, #FLx_densified do
		-- February 2026, add some randmness to avoid having a continuous front, add some gaps without firearms action for a more realistic landscape

		randomBattleGap = math.random()
		if frontline_points <= 2 then randomBattleGap = 1 end -- we want the battle always displayed when only one point is in the dataset or when only a few coordinates define the battle
		--~ print("[Ground Equipment " .. version_text_SGES .. "] Checking Front Line... ...point " .. i)
		if (i == 1 or i == #FLx_densified or randomBattleGap > gap_threshold) and FrontLine_instance[i] == nil then -- always draw at least one battle
			local object = Prefilled_FireAndSmokeObject -- X-Plane 11
			if IsXPlane12 then
				if i == #FLx_densified - 1 then -- this one will be used for FLAK !
					object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12_AAA.obj"
				elseif (i == 1 or i == #FLx_densified) or (i % 10 == 0) then
					object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12_battle.obj"
					battles_with_sounds = battles_with_sounds + 1
				elseif randomBattleGap > 0.97 then
					object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12.obj"
				else
					object = SCRIPT_DIRECTORY   .. "Simple_Ground_Equipment_and_Services/Structures/FlameGround_XP12_battle_no_sound.obj"
				end
			end
			--~ enqueue_frontline_object(object, i)
			--~ XPLM.XPLMLoadObjectAsync(object,
					--~ function(inObject, inRefcon)
					--~ FrontLine_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
					--~ FrontLineRef[i] = inObject
					--~ end,
					--~ inRefcon )
			load_object_once(object)
			FrontLineRef[i] = LoadedObjects[object]
			if LoadedObjects[object] then
				FrontLine_instance[i] = XPLM.XPLMCreateInstance(LoadedObjects[object], datarefs_addr)
				--~ print("NOT waiting")
				Front_Line_chg_bat1 = false
			else
				-- On attend que l’objet soit chargé
				-- On retentera au prochain passage de Front_Line_object_physics()
				Front_Line_chg = true -- restores the loop to allow a second pass
				--~ print("waiting")
			end


			--~ if (#FLx_densified > 100 and randomBattleGap > 2.5*gap_threshold) or (#FLx_densified <= 100 and randomBattleGap > gap_threshold) then
				randomTarget = math.random()
				if targetObject ~= nil and randomTarget >= 0.5 and randomTarget < 0.9 then
					selectedTargetObject = targetObject
				elseif targetObject2 ~= nil and randomTarget < 0.2 then
					selectedTargetObject = targetObject2
				elseif targetObject4 ~= nil and randomTarget >= 0.2 then
					selectedTargetObject = targetObject4
				elseif targetObject3 ~= nil and randomTarget >= 0.9 then
					selectedTargetObject = targetObject3
				end

				if selectedTargetObject ~= nil then
					--~ XPLM.XPLMLoadObjectAsync(selectedTargetObject,
							--~ function(inObject, inRefcon)
							--~ FrontLine_threeD_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							--~ FrontLine3DRef[i] = inObject
							--~ end,
							--~ inRefcon )
					load_object_once(selectedTargetObject)
					FrontLine3DRef[i] = LoadedObjects[selectedTargetObject]
					if LoadedObjects[selectedTargetObject] then
						FrontLine_threeD_instance[i] = XPLM.XPLMCreateInstance(FrontLine3DRef[i], datarefs_addr)
						Front_Line_chg_bat2 = false
					else
						-- On attend que l’objet soit chargé
						-- On retentera au prochain passage de Front_Line_object_physics()
						Front_Line_chg = true -- restores the loop to allow a second pass
					end



					--~ print("[Front Line] Also loaded " .. selectedTargetObject .. ", " .. i)
					if selectedTargetObject ~= nil and string.find(selectedTargetObject,"pak38") then
						heading_object_modifier[i] = 90
					elseif selectedTargetObject ~= nil and string.find(selectedTargetObject,"chinu") then
						heading_object_modifier[i] = 270
					elseif selectedTargetObject ~= nil and string.find(selectedTargetObject,"BTR") then
						heading_object_modifier[i] = 180
					else
						heading_object_modifier[i] = 0
					end
				--~ end
				--~ if selectedTargetObject ~= nil and SandbagsObject ~= nil and (string.find(selectedTargetObject,"pak38") or string.find(selectedTargetObject,"BTR-80")) then
				if selectedTargetObject ~= nil and SandbagsObject ~= nil and (string.find(selectedTargetObject,"pak38") or string.find(selectedTargetObject,"BTR-80")) then
					--~ XPLM.XPLMLoadObjectAsync(SandbagsObject,
							--~ function(inObject, inRefcon)
							--~ FrontLine_sandbags_instance[i] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
							--~ FrontLineSandbagsRef[i] = inObject
							--~ end,
							--~ inRefcon )
					load_object_once(SandbagsObject)
					FrontLineSandbagsRef[i] = LoadedObjects[SandbagsObject]
					if LoadedObjects[SandbagsObject] then
						FrontLine_sandbags_instance[i] = XPLM.XPLMCreateInstance(FrontLineSandbagsRef[i], datarefs_addr)
						Front_Line_chg_bat3 = false
					else
						-- On attend que l’objet soit chargé
						-- On retentera au prochain passage de Front_Line_object_physics()
						Front_Line_chg = true -- restores the loop to allow a second pass
					end
					--~ print("[Front Line] And loaded " .. SandbagsObject .. ", " .. i)
				end
				selectedTargetObject = nil -- RESET THAT !
			end

		elseif randomBattleGap <= gap_threshold and FrontLine_instance[i] == nil then
			count_all_gaps = count_all_gaps + 1
			--~ print("[Front Line] Creating a small gap in the front line.")
		end
	end
	if count_all_gaps > 0 then print("[Front Line] Leaving room for " .. count_all_gaps .. " more peacefull gaps.") end
	print("[Front Line] Loaded " .. math.floor(#FLx_densified)-count_all_gaps .. " battles in total.")
	if battles_with_sounds > 0 then print("[Front Line] Only " .. battles_with_sounds .. " battles have sounds to reduce the load.") end

	return 1
end


function unload_Front_Line_Objects()
	print("[Front Line] Unloading Front Line...")
	for i = 1, #FLx_densified do
		if FrontLine_instance[i] ~= nil then
			--~ print("[Ground Equipment " .. version_text_SGES .. "] Unloading Front Line... ...point " .. i)
			if FrontLine_instance[i] ~= nil then       XPLM.XPLMDestroyInstance(FrontLine_instance[i]) end
			--~ if FrontLineRef[i] ~= nil then     XPLM.XPLMUnloadObject(FrontLineRef[i])  end
			FrontLine_instance[i] = nil
			--~ FrontLineRef[i] = nil
		end
		if FrontLine_threeD_instance[i] ~= nil then
			if FrontLine_threeD_instance[i] ~= nil then       XPLM.XPLMDestroyInstance(FrontLine_threeD_instance[i]) end
			--~ if FrontLine3DRef[i] ~= nil then     XPLM.XPLMUnloadObject(FrontLine3DRef[i])  end
			FrontLine_threeD_instance[i] = nil
			--~ FrontLine3DRef[i] = nil
		end
		if FrontLine_sandbags_instance[i] ~= nil then
			if FrontLine_sandbags_instance[i] ~= nil then       XPLM.XPLMDestroyInstance(FrontLine_sandbags_instance[i]) end
			--~ if FrontLineSandbagsRef[i] ~= nil then     XPLM.XPLMUnloadObject(FrontLineSandbagsRef[i])  end
			FrontLine_sandbags_instance[i] = nil
			--~ FrontLineSandbagsRef[i] = nil
		end
	end
	-- Vider les coordonnées
	FLx = {}
	FLz = {}
	FLx_densified = {}
	FLz_densified = {}
	--~ FrontLineRef = {}
	--~ FrontLine3DRef = {}
	--~ FrontLineSandbagsRef = {}
	heading_object_modifier = {}
	--~ Front_Line_chg = false
	Front_Line_object_spacing = Front_Line_object_spacing_init
	--~ Front_line_title  = nil
	total_number_of_battles = nil
	-- Force un passage du garbage collector
	collectgarbage("collect")
	--~ FrontLine_load_queue = {} -- vider la queue
end

function draw_Front_Line()
	local heading_modifier = 90
	if FrontLine_instance[0] ~= nil then
		print("[Front Line] Draw " .. #FLx_densified .. " battles on their calculated positions (pass " .. draw_front_line .. ").")
	end
	for i = 1, #FLx_densified do

		if FrontLine_instance[i] ~= nil then
			objpos_value[0].x, _, objpos_value[0].z = latlon_to_local(FLx_densified[i], FLz_densified[i], 0)
			objpos_value[0].y, _ = probe_y(objpos_value[0].x, 0, objpos_value[0].z)
			--~ if i == 1 then
				--~ print("[Front Line] First battle : " .. FLx_densified[i] .. " ; " .. FLz_densified[i])
				--~ print("[Front Line] First battle : " .. objpos_value[0].x .. " ; " .. objpos_value[0].z)
			--~ end
			-- Orientation perpendiculaire à la ligne (entre i et i+1)
			if i < #FLx_densified then
				local NextX, _, NextZ = latlon_to_local(FLx_densified[i+1], FLz_densified[i+1], 0)
				local sx = NextX - objpos_value[0].x
				local sz = NextZ - objpos_value[0].y
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

		-- and also draw as required additional objects
		if FrontLine_threeD_instance[i] ~= nil then
			--~ objpos_value[0].x = objpos_value[0].x
			--~ objpos_value[0].z = objpos_value[0].z
			--~ if string.find(selectedTargetObject,"pak38") then
				objpos_value[0].heading = objpos_value[0].heading + heading_object_modifier[i]
			--~ end
			float_addr = float_value
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(FrontLine_threeD_instance[i], objpos_addr, float_addr)
		end
		if FrontLine_sandbags_instance[i] ~= nil then
			objpos_value[0].x = objpos_value[0].x - 2
			objpos_value[0].z = objpos_value[0].z - 2
			objpos_value[0].heading = objpos_value[0].heading - heading_object_modifier[i]
			float_addr = float_value
			objpos_addr = objpos_value
			XPLM.XPLMInstanceSetPosition(FrontLine_sandbags_instance[i], objpos_addr, float_addr)
		end
	end
	return draw_front_line + 1
end

function draw_AAA()
	local heading_modifier = 90
	local global_dist2_from_Front_Line = 4000000
	-- Calcul de distance à l'avion
	for i = 1, #FLx_densified do
		local HereX, _, HereZ = latlon_to_local(FLx_densified[i], FLz_densified[i], 0)

		local dx = HereX - sges_gs_plane_x[0]
		local dz = HereZ - sges_gs_plane_z[0]
		local dist2 = dx * dx + dz * dz
		if dist2 < global_dist2_from_Front_Line then
			global_dist2_from_Front_Line = dist2
		end -- the distance found to any points of the Front LIne
	end
	if FrontLine_instance[#FLx_densified - 1] ~= nil then
		-- Pour éviter de faire un math.sqrt() à chaque point (plus lent), on compare le carré de la distance directement :

		if sges_gs_ias_spd[0] >= 60 and sges_gs_ias_spd[0] < 600 and global_dist2_from_Front_Line < 3000000 then -- the FLAK object
			objpos_value[0].x = sges_gs_plane_x[0]
			objpos_value[0].z = sges_gs_plane_z[0]
			objpos_value[0].y = sges_gs_plane_y[0] + 10 -- merge AAA explostion with the suspect aircraft when above the Front Line
			--~ print("[Front Line] #" .. #FLx_densified - 1 .. " : AAA explosions. " ..math.floor(global_dist2_from_Front_Line))
			if global_dist2_from_Front_Line < 1000000 then
				local randomFailure = math.random()
				if sges_gs_ias_spd[0] < 400 and randomFailure > 0.95 then
					-- a failure
					set("sim/flightmodel/failures/smoking",6)
					set("sim/operation/failures/rel_engfla0",6)
					--~ set("sim/operation/failures/rel_brown_out",6)
					set("sim/operation/failures/rel_bird_strike",6)
					--~ set("sim/flightmodel/forces/fside_plug_acf",1000)
					set("sim/operation/failures/rel_wing4R",6)
					set("sim/operation/failures/rel_vstb1",6)
					set("sim/operation/failures/rel_wind_shear",6)
					set("sim/operation/failures/rel_fcon_elev_1_lft_cntr",6)
					command_once("sim/operation/fail_system")
					--~ print("[Front Line] A failure due to AAA !")

					--~ 0 = always working
					--~ 1 = mean time until failure
					--~ 2 = exact time until failure
					--~ 3 = fail at exact speed KIAS
					--~ 4 = fail at exact altitude AGL
					--~ 5 = fail if CTRL f or JOY
					--~ 6 = inoperative
				end
			end
		elseif sges_gs_ias_spd[0] >= 60 and sges_gs_ias_spd[0] < 600 then

			objpos_value[0].x, _, objpos_value[0].z = latlon_to_local(FLx_densified[#FLx_densified - 1], FLz_densified[#FLx_densified - 1], 0)
			objpos_value[0].y, _ = probe_y(objpos_value[0].x, 0, objpos_value[0].z)
		--~ print("[Front Line] Done setting #" .. #FLx_densified - 1 .. " battle on its calculated position on the ground.")
		end
	-- Orientation perpendiculaire à la ligne (entre i et i+1)
		local NextX, _, NextZ = latlon_to_local(FLx_densified[#FLx_densified], FLz_densified[#FLx_densified], 0)
		local sx = NextX - objpos_value[0].x
		local sz = NextZ - objpos_value[0].y

		local sx = FLx_densified[#FLx_densified] - FLx_densified[#FLx_densified - 1]
		local sz = FLz_densified[#FLx_densified] - FLz_densified[#FLx_densified - 1]
		local angle = math.atan2(sz, sx)
		local heading = angle + math.pi / 2  -- perpendiculaire
		objpos_value[0].heading = math.deg(heading) + heading_modifier

		objpos_value[0].pitch = 0
		float_addr = float_value
		objpos_addr = objpos_value
		XPLM.XPLMInstanceSetPosition(FrontLine_instance[#FLx_densified - 1], objpos_addr, float_addr)
	end
end


--~ Front_Line_density = false
local Front_Line_object_spacing = 250
local Front_Line_object_spacing_init = 250
draw_front_line = 0
drawing_time = os.clock()
local WitnessFLx_densified = -3.14159
function Front_Line_object_physics()

	if Front_Line_chg == true then
		if show_Front_Line then
			if FrontLine_instance[1] == nil then
				Front_Line_chg_bat1 = true
				Front_Line_chg_bat2 = true
				Front_Line_chg_bat3 = true
				sges_Load_locations()
				densify_Front_Line(Front_Line_object_spacing)  -- <-- ICI : densification tous les 100 m ou 5000 m
				if #FLx_densified > frontline_points then
					while(#FLx_densified > max_objects)
					do
						Front_Line_object_spacing = Front_Line_object_spacing * 1.25
						densify_Front_Line(Front_Line_object_spacing)
						--~ print("[Front Line] Trying " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
					end
				end
				total_number_of_battles = tonumber(#FLx_densified)
				print("[Front Line] Distributing " .. math.floor(#FLx_densified) .. " battles every " .. math.floor(Front_Line_object_spacing) .. " meters.")
				draw_front_line = load_Front_Line()
				WitnessFLx_densified = FLx_densified[#FLx_densified]
				Front_Line_object_spacing = Front_Line_object_spacing_init -- reinit
			end
			--~ draw_Front_Line()
			--~ Front_Line_chg = false
			--~ if 	Front_Line_chg_bat1 == false and Front_Line_chg_bat2 == false and Front_Line_chg_bat3 == false then
			if 	Front_Line_chg_bat1 == false and Front_Line_chg_bat2 == false then
				Front_Line_chg = false
				print("[Front Line] Front_Line_chg = false (it's good, we loaded all assets).")
			end
			--~ print("[Front Line] Done setting " .. #FLx_densified .. " battles on their calculated positions.")
		else
			unload_Front_Line_Objects()
			Front_Line_chg = false -- Ceinture et bretelles
		end
	end

	if show_Front_Line then
		--emprical results show this needs to be done not just once :
		if draw_front_line >= 1 and draw_front_line <= 3 then -- a unique draw pass doesn't succeed, we need several passes, empirically.
			draw_front_line = draw_Front_Line()
			drawing_time = os.clock()
		elseif draw_front_line > 3 and  os.clock() >= drawing_time + 240 then -- redraw periodically
		-- When loading a new DSF the battles can disappear, we need to redrawn them in this case, from the original coordinates.
			Front_Line_chg = true -- force a load, should include draw_front_line = true but ONLY if if FrontLine_instance[1] == nil
			draw_front_line = 2 -- we need it
			draw_front_line = draw_Front_Line()
			drawing_time = os.clock()
			-- we need to redraw eventualy, becaus elaoding a new DSF reset the openGL coordinates and make stuff disappear.
		end
		draw_AAA() -- We make a second pass to recapture the final-1 object as FLAK and change it dynamically
	end
end


do_often("if SGES_XPlaneIsPaused == 0 and (Front_Line_chg or show_Front_Line) then Front_Line_object_physics() end") --make that once by button pressure
