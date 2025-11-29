sges_ship_cancelled_cause_land = false
local inbound_vessel_annoucement_done = false

function switch_static_sges_boat()
	if show_XP12Carrier then
		show_XP12Carrier = false
	else
		show_XP12Carrier = true

		local boatFound = false
		local attempts = 0 -- Compteur pour éviter une boucle infinie

		-- Boucle jusqu'à trouver un bateau disponible
		while not boatFound and attempts < 6 do
			attempts = attempts + 1

			if selected_boat == 97 then
				selected_boat = 0
				Prefilled_XP12Boat = Prefilled_XP12Carrier
			elseif selected_boat == 0 then
				selected_boat = 1
				Prefilled_XP12Boat = Prefilled_XP12Frigate
			elseif selected_boat == 1 then
				if MekoFrigate_Object ~= nil then
					selected_boat = 99
					Prefilled_XP12Boat = MekoFrigate_Object
				else
					selected_boat = 99
					Prefilled_XP12Boat = Prefilled_CanoeObject -- objet temporaire
				end
			elseif selected_boat == 99 then
				if XTrident_NaveCavour_Object ~= nil and file_exists(XTrident_NaveCavour_Object) then
					selected_boat = 98
					Prefilled_XP12Boat = XTrident_NaveCavour_Object
				else
					selected_boat = 98
					Prefilled_XP12Boat = Prefilled_CanoeObject -- objet temporaire
				end
			elseif selected_boat == 98 then
				if TarawaLHA1_Object ~= nil then
					selected_boat = 101
					Prefilled_XP12Boat = TarawaLHA1_Object
				else
					selected_boat = 101
					Prefilled_XP12Boat = Prefilled_CanoeObject -- objet temporaire
				end
			elseif selected_boat == 101 then
				if HMSEagle_Object ~= nil then
					selected_boat = 100
					Prefilled_XP12Boat = HMSEagle_Object
				else
					selected_boat = 100
					Prefilled_XP12Boat = Prefilled_CanoeObject -- objet temporaire
				end
			elseif selected_boat == 100 then
				if Type45Destroyer_Object ~= nil then
					selected_boat = 97
					Prefilled_XP12Boat = Type45Destroyer_Object
				else
					selected_boat = 97
					Prefilled_XP12Boat = Prefilled_CanoeObject -- objet temporaire
				end
			end

			-- Vérifier si l'objet sélectionné est installé
			if Prefilled_XP12Boat ~= Prefilled_CanoeObject then
				boatFound = true
			else
				print("[Ground Equipment] Selected object is not installed, trying next one.")
			end
		end

		-- Si aucun bateau n'est trouvé, on garde l'objet temporaire
		if not boatFound then
			print("[Ground Equipment] No valid boat found, using Canoe as fallback.")
		end
	end
	sges_ship_cancelled_cause_land = false
	XP12Carrier_chg = true
end

-- Fonction pour vérifier si un objet est défini
function isObjectInstalled(object)
	return object ~= nil
end




function switch_moving_sges_boat()

local ships = {
	{name = "Akula", object = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/" .. "Ships/Akula1.obj"},
	{name = "Virginia", object = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/MisterX_Lib/" .. "Ships/Virginia.obj"},
	{name = "Barbel", object = USSBlueback_Object},
	{name = "Meko", object = MekoFrigate_Object},
	{name = "Cavour", object = XTrident_NaveCavour_Object},
	{name = "Tarawa", object = TarawaLHA1_Object},
	{name = "HMS Eagle", object = HMSEagle_Object},
	{name = "Dragon", object = Type45Destroyer_Object}
}
    -- Si aucun objet n'est sélectionné ou qu'il est vide, débuter avec l'Akula
    if User_Custom_Prefilled_SubmarineObject == nil then
        User_Custom_Prefilled_SubmarineObject = ships[8].object
        print("[Ground Equipment " .. version_text_SGES .. "] No object selected, defaulting to Akula class")
    end

    -- Trouver l'index actuel dans la liste des navires
    local currentIndex = 1
    for i, ship in ipairs(ships) do
        if User_Custom_Prefilled_SubmarineObject == ship.object then
            currentIndex = i
			--~ print("[Debug] Match found at index: " .. tostring(i))
            break
        end
    end

    -- Avancer dans la liste jusqu'à trouver un navire installé
    local totalShips = #ships
    local nextIndex = (currentIndex % totalShips) + 1 -- Passer à l'index suivant dans la liste (cycle)

    -- Boucle pour chercher un navire installé
    while not isObjectInstalled(ships[nextIndex].object) do
        print("[Ground Equipment " .. version_text_SGES .. "] " .. ships[nextIndex].name .. " not installed, switching to the next ship.")
        nextIndex = (nextIndex % totalShips) + 1 -- Continuer à avancer dans la liste

        -- Si nous avons parcouru tous les navires sans en trouver, arrêter pour éviter une boucle infinie
        if nextIndex == currentIndex then
            print("[Ground Equipment " .. version_text_SGES .. "] No available ships installed.")
            return
        end
    end

    -- Sélectionner le navire installé
    User_Custom_Prefilled_SubmarineObject = ships[nextIndex].object
    print("[Ground Equipment " .. version_text_SGES .. "] Switching to " .. ships[nextIndex].name .. " class")
	sges_ship_cancelled_cause_land = false
    show_Submarine = true
    if inbound_vessel_annoucement_done then inbound_vessel_annoucement_done = false end -- rearm " Call the ball !" sound
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

print("[Ground Equipment " .. version_text_SGES .. "] A module with ships-related functions has been loaded.")

function execute_DYNAMIC_service_objects()

	if sges_gs_ias_spd[0] < 40 then --FPS saver


			--
			-- is a FPS Saver : execute_DYNAMIC_service_objects_wigwag
			--

		if SGES_XPlaneIsPaused == 0 and execute_DYNAMIC_service_objects_wigwag == 0 then
			service_object_physics_Ponev()
			service_object_physics_Marshaller()
			if IsXPlane12 and (show_Cart or show_Baggage or Baggage_chg) then service_object_physics_Baggage() end  --  to avoid "too many callback" error
			if IsXPlane1211 and (show_CargoULD or CargoULD_chg) and show_ULDLoader and (IsPassengerPlane == 0 or Baggage_instance[5] ~= nil) and not SGES_BushMode then service_object_physics_ULD() end --  to avoid "too many callback" error
			--~ if IsXPlane1211 then print("IsXPlane1211") end
			--~ if show_CargoULD then print("show_CargoULD") end
			--~ if CargoULD_chg then print("CargoULD_chg") end
			--~ if show_ULDLoader then print("show_ULDLoader") end
			--~ if IsPassengerPlane == 0 then print("Not a PassengerPlane") end
			--~ if not SGES_BushMode then print("not SGES_BushMode") end
			-- services here must be blocked once in the fonction load_xxx()
			-- arriving and departing ground services
			execute_DYNAMIC_service_objects_wigwag = 1 -- slow down to avoid "too many callback" error
		elseif SGES_XPlaneIsPaused == 0 and execute_DYNAMIC_service_objects_wigwag == 1 then
			execute_DYNAMIC_service_objects_wigwag = 0
		end

		if SGES_XPlaneIsPaused == 0 then
			service_object_physics_Push_back()
			service_object_physics_Follow_me() -- FM
			service_object_physics_EMS() -- Fire Vehicle
			service_object_physics_Bus() -- Passenger Bus
			service_object_physics_Fuel() -- Fuel truck
			service_object_physics_Cart() -- Cart
			if UseXplaneDefaultObject == false and sges_gs_gnd_spd[0] < 1 then -- do not arm passengers
				service_object_physicsPax()
			end
			if IsXPlane12 then service_object_physicsXP12Helicopters()  end
		end
		------------------------------------------------------------------------
		--
		------------------------------------------------------------------------
		-- ///////////// CHOCKS ENGINE ///////////////////////////////////////--
		-------------------------------------------------------------------------
		-- we will also lock the aircraft firmly on its position
		-- when the chocks are ON
		-- by acting on x-plane aircaft and not at all on the brake system
		-- we avoid side effects that may arise from interacting with aircraft systems
		-- and that's also more true to life
		--~ if show_Chocks == true and wetness == 0 then
			--~ -- don't put the chocks when spawned on the aircraft carrier at sea.
			--~ _,wetness = probe_y(sges_gs_plane_x[0], 0, sges_gs_plane_z[0])
			--~ if wetness == 1 then
				--~ show_Chocks = false
			--~ end
		--~ end
		if show_Chocks and sges_gs_gnd_spd[0] < 20 then
			show_PB = false
			chg_PB = true
			if not UseXplane1220Chocks then

				if (SGES_IsHelicopter ~= nil and SGES_IsHelicopter == 1 and (SGES_Throttle[0] >= 20  or sges_gs_plane_y_agl[0] > 1)) then
					--Caution, SGES_Throttle is PROP WASH for an HELICOPTER !
					if SGES_override_engine_forces == 1 then
						SGES_override_engine_forces = 0
						set("sim/operation/override/override_wing_forces",0)
						print("[Ground Equipment " .. version_text_SGES .. "] Because an helicopter, chocks cannot retain you now !")
						show_Chocks = false
						Chocks_chg = true
					end
				else
					if XPLMFindDataRef("sim/operation/override/override_engine_forces") ~= nil and SGES_override_engine_forces == nil then
							dataref("SGES_override_engine_forces","sim/operation/override/override_engine_forces","writable")
					end
					if SGES_override_engine_forces ~= nil and SGES_override_engine_forces == 0 then
						SGES_override_engine_forces = 1
						set("sim/operation/override/override_wing_forces",1)
						print("[Ground Equipment " .. version_text_SGES .. "] Activating the SGES chocks. SGES_override_engine_forces = " .. SGES_override_engine_forces)
					end

					set("sim/flightmodel/position/local_vz",0) -- beforehand action, generic
					set("sim/flightmodel/position/local_vy",0)
					set("sim/flightmodel/position/local_vx",0)
					--~ if (PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA") or PLANE_ICAO == "CAML" then
					if (PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA") then
						set("sim/flightmodel/position/local_vy",-0.02) -- retain the aircraft firmly
					end
					if sges_position_static_psi == nil   then sges_position_static_psi   = get("sim/flightmodel/position/psi")   end
					--~ if sges_position_static_z == nil then sges_position_static_z = get("sim/flightmodel/position/local_z") end
					--~ if sges_position_static_x == nil   then sges_position_static_x   = get("sim/flightmodel/position/local_x")   end
					--~ if sges_position_static_y == nil   then sges_position_static_y   = get("sim/flightmodel/position/local_y")   end
					set("sim/flightmodel/position/R",0)	-- The yaw rotation rates (relative to the flight)
					--~ set("sim/flightmodel/position/local_z",sges_position_static_z) -- not mandatory
					--~ set("sim/flightmodel/position/local_x",sges_position_static_x) -- not mandatory
					--~ set("sim/flightmodel/position/local_y",sges_position_static_y) -- not mandatory
					set("sim/flightmodel/position/psi",sges_position_static_psi)
				end
				if show_Chocks and show_GPU and PLANE_ICAO == "F104" and PLANE_AUTHOR == "COLIMATA" then -- toggle F104 chocks
					set("Colimata/F104_A_SW_GROUND_gpu_i",1) -- force the GPU because GPU disconnections occurs with COLIMATA F104
				end
			end
		elseif SGES_override_engine_forces ~= nil and not show_Chocks and not show_PB and  SGES_override_engine_forces == 1 and PLANE_ICAO ~= "CL60"  then -- regular
			SGES_override_engine_forces = 0
			set("sim/operation/override/override_wing_forces",0)
			print("[Ground Equipment " .. version_text_SGES .. "] Removing tire chocks action. SGES_override_engine_forces = " .. SGES_override_engine_forces)
		elseif SGES_override_engine_forces ~= nil and not show_Chocks and not show_PB and  SGES_override_engine_forces == 1 and Chocks_chg and PLANE_ICAO == "CL60" and string.find(PLANE_AUTHOR,"Hot") then -- Hot Start CL650 Challenger
			SGES_override_engine_forces = 0
			set("sim/operation/override/override_wing_forces",0)
			print("[Ground Equipment " .. version_text_SGES .. "] Removing SGES chocks action once for the Hot Start Challenger, then the plane will hopefully handle the rest later.")
		end

		------------------------------------------------------------------------
		-- ///////////// CHOCKS ENGINE  ends /////////////////////////////////--
		-------------------------------------------------------------------------
		------------------------------------------------------------------------
		--
		------------------------------------------------------------------------
	end

	-- we will also lock the aircraft firmly on ground, as if landed,
	-- when colocated with the X-Plane 12 deck of the CVN-78 Geralrd R Ford.

	if sges_gs_ias_spd[0] < 220 then --FPS saver
		if IsXPlane12 then
		local pos_range = 100
		if selected_boat == 1 then deck_altitude = 3.6 pos_range = 100 -- meters 	-- O.H. Perry frigate
		elseif selected_boat == 97 then deck_altitude = 6.4 pos_range = 60 -- meters 	-- T45 Destroyer
		elseif selected_boat == 98 then deck_altitude = 15.5 pos_range = 120 -- meters 	-- CAVE NAVOUR AIRCRAFT CARRIER
		elseif selected_boat == 99 then deck_altitude = 3.8 pos_range = 100 -- meters 	-- Meko 360 frigate
		elseif selected_boat == 101 then deck_altitude = 18.5 	pos_range = 120 -- meters 	-- USS TARAWA
		elseif selected_boat == 100 then deck_altitude = 12.15	 	pos_range = 95 -- meters 	-- HMS Eagle
		else deck_altitude = 18.5 	 pos_range = 200				-- CVN78
		end
		-- if the boat is display, if the plane is in the boat area
		if show_XP12Carrier and SGES_vvi_fpm_pilot[0] < 0.1 and sges_gs_plane_y_agl[0] <= deck_altitude + 0.001 and sges_gs_plane_y_agl[0] > deck_altitude - 1.6 and sges_gs_plane_x[0] < XP12boat_location_x + pos_range and  sges_gs_plane_x[0] > XP12boat_location_x - pos_range and sges_gs_plane_z[0] < XP12boat_location_z + pos_range and  sges_gs_plane_z[0] > XP12boat_location_z - pos_range  then
			--print(sges_gs_ias_spd[0])
			if sgesvz == nil then
				sgesvz = get("sim/flightmodel/position/local_vz")
				sgesvx = get("sim/flightmodel/position/local_vx")
				sgesy  = get("sim/flightmodel/position/local_y")  -- prevents user craft from sinking into the "hard" surface
				sgestheta = get("sim/flightmodel/position/theta")
				sgesphi  = get("sim/flightmodel/position/phi")
				-- nice to have :
				command_once("sim/electrical/recharge") -- mimics maintenance on the deck
				command_once("sim/operation/fix_all_systems") -- mimics maintenance on the deck
				end_pitch_down_action = false

			else
				-- reduce the speed as if landed on hard deck
				sgesvz = sgesvz / 1.1
				sgesvx = sgesvx / 1.1
				if sgestheta > 0.1 then sgestheta = sgestheta / 1.1 end
				if sgesphi > 0.1 then sgesphi = sgesphi / 1.5 end
				if sgesy ~= nil then set("sim/flightmodel/position/local_y",sgesy) end -- prevents user craft from sinking into the "hard" surface
				if sgesphi ~= nil then set("sim/flightmodel/position/phi",sgesphi) end		--roll
				set("sim/flightmodel/position/P",0) 	 	 -- roll			--

				-- calculate actual angular attitude :
				sgestrue_theta = get("sim/flightmodel/position/true_theta")
				-- apply a downward movement until the value is near zero.
				if sgestrue_theta > 0.000001 and not end_pitch_down_action then --I'm happy ! great success !!
					set("sim/flightmodel/position/Q",-15) 		 --decrease pitch		--

				else
					set("sim/flightmodel/position/Q",0) 		 --pitch		--
					end_pitch_down_action = true
				end

			end
			set("sim/flightmodel/position/local_vy",0)  -- as if touching thard surface of the deck (before any other calculation)
			if (SGES_Throttle[0] < 0.60 or SGES_IsHelicopter == 1) and sgesvz ~= nil then set("sim/flightmodel/position/local_vz",sgesvz) end -- as if landed on deck
			if (SGES_Throttle[0] < 0.60 or SGES_IsHelicopter == 1)  and sgesvx ~= nil then set("sim/flightmodel/position/local_vx",sgesvx) end	 -- as if landed on deck
			if SGES_Throttle[0] < 0.60 or SGES_IsHelicopter == 1 then set("sim/flightmodel/position/Rrad",0)  end					--
			if SGES_Throttle[0] < 0.40 or SGES_IsHelicopter == 1 then set("sim/flightmodel/position/indicated_airspeed",0) end 	--
			if sgestheta ~= nil then set("sim/flightmodel/position/theta",sgestheta) end --pitch

		elseif show_XP12Carrier and SGES_vvi_fpm_pilot[0] > 0.1 and sges_gs_plane_y_agl[0] > deck_altitude + 0.1 and sgesvz ~= nil  then
			sgesvz = nil
			sgesvx = nil
			sgesy = nil
		end

		-- Do the same thing for the submarine (sauf qu'en plus, il se déplace) --IAS24
		-- This was expanded to accept other types than submarin as moving ships
		if show_Submarine and submarine_x ~= nil and submarine_z ~= nil and sges_gs_ias_spd[0] < 210 and SGES_vvi_fpm_pilot[0] < 0.2 then  --IAS24
			--~ Un F/A-18 Hornet, utilisé par l'U.S. Navy, a une vitesse d'appontage typique d'environ 135 nœuds (environ 250 km/h).
			--~ Le Dassault Rafale M, utilisé par la Marine nationale française, a une vitesse d'appontage similaire, autour de 125 à 140 nœuds.
			local submarine_deck_altitude = 1.2 -- Virginia class submarine
			local subpos_range = 15 -- centered on the back segment of the SNA
			if string.find(User_Custom_Prefilled_SubmarineObject,"Akula") then 			submarine_deck_altitude = submarine_deck_altitude + 1.4  		-- deck of Akula class is higher
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"581") then 	submarine_deck_altitude = 4  subpos_range = 25		-- deck of Barbel class is higher
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"Cavour") then 		submarine_deck_altitude = 15.5 + 0.5	 	subpos_range = 100  -- deck of CAVE
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"Meko") then 		submarine_deck_altitude = 3.8 + 0.3	 		subpos_range = 100  -- deck of Mecko 360
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"Dragon") then 		submarine_deck_altitude = 6.4 + 0.3	 		subpos_range = 100  -- deck of the British T45
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"Tarawa") then 	submarine_deck_altitude = 18.5 + 0.3	 	subpos_range = 100  -- deck of TARAWA
			elseif string.find(User_Custom_Prefilled_SubmarineObject,"Eagle") then 		submarine_deck_altitude = 12.15 + 0.7	 	subpos_range = 100 end -- deck of HMS Eagle aircraft carrier

			-- make an announcement when inbound

			if not inbound_vessel_annoucement_done and sges_gs_plane_y_agl[0] > submarine_deck_altitude and sges_gs_plane_y_agl[0] > 75 and sges_gs_plane_y_agl[0] < 300 and
			sges_gs_plane_x[0] < submarine_x + 20 * subpos_range and  sges_gs_plane_x[0] > submarine_x -  20 * subpos_range and
			sges_gs_plane_z[0] < submarine_z +  20 * subpos_range and  sges_gs_plane_z[0] > submarine_z -  20 * subpos_range then
				print("approaching " .. sges_gs_plane_x[0] .. " " .. submarine_x  .. " " .. sges_gs_plane_z[0] .. " " .. submarine_z )


				if Call_the_ball_sound == nil then
					if string.find(User_Custom_Prefilled_SubmarineObject,"Cavour") or string.find(User_Custom_Prefilled_SubmarineObject,"Meko") then
					Call_the_ball_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Call_the_Ball_ITA.wav")

					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Virginia") or string.find(User_Custom_Prefilled_SubmarineObject,"581")  or string.find(User_Custom_Prefilled_SubmarineObject,"Barbel") then
					Call_the_ball_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/PleaseIdentify_USA.wav")

					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Tarawa") or string.find(User_Custom_Prefilled_SubmarineObject,"Eagle") then
					Call_the_ball_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Call_the_Ball_USA.wav")

					elseif string.find(User_Custom_Prefilled_SubmarineObject,"Akula") then
					Call_the_ball_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/PleaseIdentify_RU.wav")

					elseif string.find(User_Custom_Prefilled_SubmarineObject,"45") or string.find(User_Custom_Prefilled_SubmarineObject,"Dragon") then
					Call_the_ball_sound = load_WAV_file(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/Sounds/Call_the_Ball_USA.wav")

					end
					if Call_the_ball_sound ~= nil then
						set_sound_gain(Call_the_ball_sound, 1)
						--print("[Ground Equipment " .. version_text_SGES .. "] Loading in memory the sound 'Call_the_ball_sound'.")
					end
				end

				if Call_the_ball_sound ~= nil then play_sound(Call_the_ball_sound) end
				inbound_vessel_annoucement_done = true
			end

			--print("approaching sub " .. sges_gs_plane_x[0] .. " " .. submarine_x  .. " " .. sges_gs_plane_z[0] .. " " .. submarine_z )
			if sges_gs_plane_y_agl[0] <= submarine_deck_altitude and sges_gs_plane_y_agl[0] > 0 and
			sges_gs_plane_x[0] < submarine_x + subpos_range and  sges_gs_plane_x[0] > submarine_x - subpos_range and
			sges_gs_plane_z[0] < submarine_z + subpos_range and  sges_gs_plane_z[0] > submarine_z - subpos_range then
				--print("ON sub " .. sges_gs_plane_x[0] .. " " .. submarine_x  .. " " .. sges_gs_plane_z[0] .. " " .. submarine_z )
				if sges_sub_y == nil then sges_sub_y  = get("sim/flightmodel/position/local_y")
				elseif sges_sub_y ~= nil then
					set("sim/flightmodel/position/local_y",sges_sub_y) -- prevents user craft from sinking into the "hard" surface
				end
				-- also reduce the speed as if landed on deck
				if sges_sub_vz == nil or show_PB then -- allow pushback to change position !
					sges_sub_vz = get("sim/flightmodel/position/local_vz")
					sges_sub_vx = get("sim/flightmodel/position/local_vx")
				else
					sges_sub_vz = sges_sub_vz / 1.1
					sges_sub_vx = sges_sub_vx / 1.1
					if (SGES_Throttle[0] < 0.80 or SGES_IsHelicopter == 1) and sges_sub_vz ~= nil then set("sim/flightmodel/position/local_vz",sges_sub_vz) end -- as if landed on deck
					if (SGES_Throttle[0] < 0.80 or SGES_IsHelicopter == 1)  and sges_sub_vx ~= nil then set("sim/flightmodel/position/local_vx",sges_sub_vx) end	 -- as if landed on deck

					-- une fois que la vitesse est réduite : (permet le ralentissement au toucher des roues)
					-- /////////////////////////////////////
					if sges_gs_gnd_spd[0] < 1 then
					-- enregistrer au toucher des roues la position de l'avion par rapport au sous-marin
						if difference_x_sub == nil then difference_x_sub = sges_gs_plane_x[0] - submarine_x  end
						if difference_z_sub == nil then difference_z_sub = sges_gs_plane_z[0] - submarine_z  end -- catch once the touchdown position
					end
					-- /////////////////////////////////////
				end
				set("sim/flightmodel/position/local_vy",0.02) --0.11 best compromise. Retested on sept 24

				-- calculate actual angular attitude :
				sgestrue_theta = get("sim/flightmodel/position/true_theta")
				-- apply a downward movement until the value is near zero.
				if sgestrue_theta > 0.000001 and not end_pitch_down_action then --I'm happy ! great success !!
					set("sim/flightmodel/position/Q",-15) 		 --decrease pitch		--

				else
					set("sim/flightmodel/position/Q",0) 		 --pitch		--
					end_pitch_down_action = true
				end

				-- but the boat is moving so the movement of the helicopter must accompany the movement of the submarine
					-- la position submarine_x change mais pas difference_x_sub, ce qui fait que on avance à la même vitesse que le sub
					if difference_x_sub ~= nil and difference_z_sub ~= nil and (SGES_Throttle[0] < 0.80 or SGES_IsHelicopter == 1) and not show_PB then
						set("sim/flightmodel/position/local_x",submarine_x + difference_x_sub)
						set("sim/flightmodel/position/local_z",submarine_z + difference_z_sub)
						set("sim/flightmodel/position/Rrad",0)
					end
					set("sim/flightmodel/position/Prad",0)
					-- only for true submarines -- we will reduce the difference as if the submarine was tying the helicopter on deck, to ensure it will stay still.
					if submarine_deck_altitude ~= nil and submarine_deck_altitude < 4 and difference_z_sub ~= nil and difference_x_sub ~= nil and not string.find(User_Custom_Prefilled_SubmarineObject,"581") then -- I catch the sub exploiting the fact that the top of the sub is low on the sea
						-- don't do it for the barbel, to to the 3D geometry
						if math.abs(difference_z_sub) > 0.001 then difference_z_sub = difference_z_sub/1.01 end -- progressively tying the helicopter on deck, to ensure it will stay still.
						if math.abs(difference_x_sub) > 0.001 then difference_x_sub = difference_x_sub/1.01 end -- progressively tying the helicopter on deck, to ensure it will stay still.
						--print("ON sub " .. difference_x_sub .. " " .. difference_z_sub)
						z_sub = z_sub - 0.1
					end
			elseif sges_gs_plane_y_agl[0] >= submarine_deck_altitude + 0.05 then
				if difference_x_sub ~= nil then difference_x_sub = nil end
				if difference_z_sub ~= nil then difference_z_sub = nil end
				if sges_sub_vz ~= nil then sges_sub_vz = nil end
				if sges_sub_vx ~= nil then sges_sub_vx = nil end
				if sges_sub_y ~= nil then sges_sub_y = nil end
				if inbound_vessel_annoucement_done and Call_the_ball_sound ~= nil then
					Call_the_ball_sound = nil   -- Assigner à `nil` pour indiquer que l'objet n'est plus utilisé
					collectgarbage()            -- Déclenche manuellement le ramassage de la mémoire
				end
			end
			if sges_gs_plane_y_agl[0] <= submarine_deck_altitude + 0.1 and sges_gs_plane_y_agl[0] > 0 and
			sges_gs_plane_x[0] < submarine_x + subpos_range and  sges_gs_plane_x[0] > submarine_x - subpos_range and
			sges_gs_plane_z[0] < submarine_z + subpos_range and  sges_gs_plane_z[0] > submarine_z - subpos_range and
			submarine_deck_altitude ~= nil and submarine_deck_altitude > 4 then
				--if it is an aircraft carrier, to reduce the stutter we need to reduce forward speed of the vessel which was accelerated for vessels
				z_sub = z_sub - 0.1
			end
		end
	end
	end



	-- we will also lock the aircraft firmly on its position
	-- when the net barrier or the arrestor cable are ON
	-- by acting on x-plane aircaft and not at all on the brake system
	-- we avoid side effects that may arise from interacting with aircraft systems
	-- and that's also more true to life
	if sges_gs_ias_spd[0] < 150 then --FPS saver
		if show_ArrestorSystem then
			if sges_gs_plane_y_agl[0] < 2 and
				--show_FireVehicle == false and
				sges_gs_plane_x[0] < StopZoneX + ArrestorSystem_sensitivity and sges_gs_plane_x[0] > StopZoneX - ArrestorSystem_sensitivity and
				sges_gs_plane_z[0] < StopZoneZ + ArrestorSystem_sensitivity and sges_gs_plane_z[0] > StopZoneZ - ArrestorSystem_sensitivity and
				sges_gs_gnd_spd[0] > 20 then
				if (sges_HookDown[0] > 0.1 and IsCable) or not IsCable then
					catched_time=math.floor(os.clock())
					if SGES_sound then
						play_sound(CatchWire_sound)
					end
				end
				ArrestorSystem_chg = false -- keep that dynamic until reaching a good runway end !
			end


			if IsEMAS then
				ArrestorSystem_delay = 0.03
			else
				ArrestorSystem_delay = ArrestorSystem_delay_basis
			end
			if sges_gs_plane_y_agl[0] < 2 and sges_current_time >= catched_time + ArrestorSystem_delay and sges_current_time <= catched_time + 1 then
				set("sim/flightmodel/position/local_vz",2)
				set("sim/flightmodel/position/local_vy",0)
				set("sim/flightmodel/position/local_vx",0)
				show_FireVehicle = true
				FireVehicle_chg = true
				if IsCable then set("sim/cockpit2/switches/tailhook_deploy",0) end
				if IsEMAS then
					show_Chocks = true -- aircraft is trapped undefinitely
					Chocks_chg = true
					--show_ArrestorSystem = false
					ArrestorSystem_chg = true
				end
			end
		end
	end

	if sges_gs_ias_spd[0] < 50 then --FPS saver
		if show_TargetMarker or show_VDGS or guidance_active then
				coordinates_of_nose_gear(sges_gs_plane_x[0], sges_gs_plane_z[0], 0, gear1Z, sges_gs_plane_head[0] )
				-- find nose gear position.
				 NosePositionX = nose_x
				 NosePositionZ = nose_z
		end

		if sges_gs_gnd_spd[0] < 10 then
			service_object_physicsTargetMarker() -- stand coordinates
		end
		if sges_gs_gnd_spd[0] > 0 and sges_gs_gnd_spd[0] < 30 and (show_TargetMarker or guidance_active) and TargetMarkerX_stored ~= nil and TargetMarkerZ_stored ~= nil then
			SayInfoOnRampTargetMarker() --IAS24
		end
	end

	-- ////////////////////////////// BOAT STEERING /////////////////////////////////

	if IsXPlane12 then
		if boat_manual_control then

			steer_the_boats(1)
			steer_the_boats(0)
		end
	end
-- ////////////////////////////// BOAT STEERING /////////////////////////////////

end

--------------------------------------------------------------------------------


function  Read_the_aircraft_profile_if_any()
	local optional_profile = file_exists(SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_CONFIG_" .. AIRCRAFT_FILENAME..".lua")
	if optional_profile then
		print("[Ground Equipment " .. version_text_SGES .. "] Reading aircraft_optional_profiles/SGES_CONFIG_" .. AIRCRAFT_FILENAME ..".lua" .. "")
		dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_CONFIG_" .. AIRCRAFT_FILENAME ..".lua") -- user settings and preferences
		if SGES_Author == nil then SGES_Author 	= get("sim/aircraft/view/acf_author") end
			--~ print("[Ground Equipment " .. version_text_SGES .. "] test " .. SGES_CONFIG_SGES_Author .. " " .. SGES_CONFIG_PLANE_ICAO .. " profile settings.")
			--~ print("[Ground Equipment " .. version_text_SGES .. "] vers " .. SGES_Author .. " " .. PLANE_ICAO .. " profile settings.")
		if PLANE_ICAO 		== SGES_CONFIG_PLANE_ICAO and
		 SGES_Author 		== SGES_CONFIG_SGES_Author and
		 AIRCRAFT_FILENAME 	== SGES_CONFIG_AIRCRAFT_FILENAME then
			--accept the profile settings
			print("- Good. I accept " .. SGES_CONFIG_SGES_Author .. " " .. SGES_CONFIG_PLANE_ICAO .. " profile settings.")
		else
			-- reject and reload main configuration
			print("- I REJECT the " .. SGES_CONFIG_PLANE_ICAO .. " profile, not exactly the current airplane ! Reloading general config.")
			dofile (SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_aircraft.lua") -- overwritte settings when rejected by the general user settings and preferences
			AircraftParameters()
		end
	end
end



-- in GAME GUI sliders to adjust airrcaft door location
function Adjust_Alternate_Passenger_Attachement_Point_via_sliders(titl)
				local Hvar = 3
				local Xvar = 3
				local Zvar = 6
				local Hname = "H"
				local Hunit = ""
				if titl == nil then titl = "Door height" end
				if titl ~= nil and titl == "Angle" then Hvar = 180 Xvar = 10 Zvar = 20 Hname = "A" Hunit ="°" end


				if titl ~= nil and titl ~= "Angle" then
					if math.abs(BeltLoaderFwdPosition) >= 4.5 then
						Xvar = 2 Zvar = 1 Hvar = 1
					end
				end

				if titl ~= nil and titl ~= "Angle" then
					if math.abs(BeltLoaderFwdPosition) < 4.5 or SGES_stairs_type == "Boarding_without_stairs"  then
						if  imgui.Button("Reset from " .. PLANE_ICAO .. " config.",220,20)  then
							BeltLoaderRearPosition = nil
							targetDoorX_alternate_boarding = nil
							SecondStairsFwdPosition = -30
							--print("[Ground Equipment " .. version_text_SGES .. "] Reading aircraft parameters from the general config file.")
							targetDoorZ_alternate = targetDoorZ -- tempo, will be overwiten as required by custom values -- only works for small BeltLoaderFwdPosition
							AircraftParameters()
							Read_the_aircraft_profile_if_any()
							developer_change()
						end
					end
				end
				if targetDoorX_alternate ~= nil and targetDoorZ_alternate ~= nil and targetDoorH_alternate ~= nil then
					local gui_note = ""
					if targetDoorX_alternate_boarding ~= nil then
						gui_note = " (deboard.)"
					end
					local changed, newVal1 = imgui.SliderFloat("X", targetDoorX_alternate, -1 * Xvar, Xvar, "Lateral " .. math.floor(targetDoorX_alternate*10)/10 .. gui_note)
					if changed then
						targetDoorX_alternate = newVal1
						if targetDoorX_alternate == 0 then
							targetDoorX_alternate = 0.0001 -- I don't accept zero as a value after a modification has been applied via the slider because I use the value zero
							-- to determine ("if targetDoorX_alternate and targetDoorX_alternate ~= 0 then -- when it was amended by the user via in game sliders") if
							-- the value was touched or not.
						end
						StairsXPJ_chg = true
						Stairs_chg = true
					end
					imgui.SameLine()
					if  imgui.Button("Reset X",44,20)  then
						targetDoorX_alternate = 0.0001
						StairsXPJ_chg = true
						PRM_chg = true
						Stairs_chg = true
					end
					if targetDoorX_alternate_boarding ~= nil then
						local changed, newVal1 = imgui.SliderFloat("Xb", targetDoorX_alternate_boarding, -1 * Xvar, Xvar, "Lateral " .. math.floor(targetDoorX_alternate_boarding*10)/10 .. " (boarding)")
						if changed then
							targetDoorX_alternate_boarding = newVal1
							StairsXPJ_chg = true
							Stairs_chg = true
						end
						imgui.SameLine()
						if  imgui.Button("Reset Xb",34,20)  then
							targetDoorX_alternate_boarding = 0.0001
							StairsXPJ_chg = true
							Stairs_chg = true
						end
					end

					if PLANE_ICAO == "ch47" or PLANE_ICAO == "CH53" then
						local changed, newVal2 = imgui.SliderFloat("Z", targetDoorZ_alternate, -15, 0, "Longitudinal " .. math.floor(targetDoorZ_alternate*10)/10)
						if changed then
							targetDoorZ_alternate = newVal2
						end
					else
						local Zborn = 1
						if SGES_stairs_type == "Boarding_without_stairs" and BeltLoaderFwdPosition > 6 then
							Zborn = 7
						end
						local changed, newVal2 = imgui.SliderFloat("Z", targetDoorZ_alternate, -1 * Zborn * Zvar, Zborn * Zvar, "Longitudinal " .. math.floor(targetDoorZ_alternate*10)/10)
						if changed then
							targetDoorZ_alternate = newVal2
							StairsXPJ_chg = true
							PRM_chg = true
							Stairs_chg = true
						end
					end

					imgui.SameLine()
					if  imgui.Button("Reset Z",44,20)  then
						targetDoorZ_alternate = 0
						l_changed = true
						StairsXPJ_chg = true
						PRM_chg = true
						Stairs_chg = true
					end

					if math.abs(BeltLoaderFwdPosition) < 4.5  then
						imgui.TextUnformatted("")
						imgui.SameLine()
						if  imgui.SmallButton("-1")  then
							targetDoorZ_alternate = targetDoorZ_alternate - 1
							StairsXPJ_chg = true
							PRM_chg = true
							Stairs_chg = true
						end
						imgui.SameLine()
						if  imgui.SmallButton("-0.1")  then
							targetDoorZ_alternate = targetDoorZ_alternate - 0.1
							StairsXPJ_chg = true
							PRM_chg = true
							Stairs_chg = true
						end
						imgui.SameLine()
						imgui.TextUnformatted(" ")
						imgui.SameLine()
						if  imgui.SmallButton("+0.1")  then
							targetDoorZ_alternate = targetDoorZ_alternate + 0.1
							StairsXPJ_chg = true
							PRM_chg = true
							Stairs_chg = true
						end
						imgui.SameLine()
						if  imgui.SmallButton("+1")  then
							targetDoorZ_alternate = targetDoorZ_alternate + 1
							StairsXPJ_chg = true
							PRM_chg = true
							Stairs_chg = true
						end
						imgui.SameLine()
						imgui.TextUnformatted("Z")
					end

					local changed, newVal3 = imgui.SliderFloat(Hname, targetDoorH_alternate, -1*Hvar, Hvar, titl .. " " .. math.floor(targetDoorH_alternate*100)/100 .. Hunit)
					if changed then
						targetDoorH_alternate = newVal3
						if titl ~= nil and titl == "Angle" then targetDoorH_alternate = math.floor(targetDoorH_alternate) end
						l_changed = true
						StairsXPJ_chg = true
						PRM_chg = true
						Stairs_chg = true
					end
					imgui.SameLine()
					if  imgui.Button("Reset " .. Hname,44,20)  then
						targetDoorH_alternate = 0
						l_changed = true
						StairsXPJ_chg = true
						PRM_chg = true
						Stairs_chg = true
					end
					if targetDoorX_alternate_boarding == nil then
						if imgui.SmallButton("Set different lateral offsets\nfor boarding and deboarding") then
							targetDoorX_alternate_boarding = targetDoorX_alternate
						end
					end
				end
end

function open_that_sges_url(url)
	if url ~= nil then
		if package.config:sub(1, 1) == "\\" then
			print("[Ground Equipment " .. version_text_SGES .. "] Start " .. url)
			os.execute('start "" "' .. url .. '"')
		else
			print("[Ground Equipment " .. version_text_SGES .. "] Open " .. url)
			os.execute('open "' .. url .. '"')
		end
	end
end

function aircraft_refueling_in_SGES()
	if sges_tank_to_refuel > 0 and show_FUEL and fuel_currentX ~= nil and fuel_currentY ~= nil and active_fueling_is_possible then

		if sges_tank_full_flag == nil then
			if sges_tank_to_refuel > 9 then sges_tank_to_refuel = 9 end -- dataref is max = 9
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
		end
		if sges_tank_ == nil then sges_tank_ = dataref_table("sim/flightmodel/weight/m_fuel") end
		if sges_tank_all == nil then dataref("sges_tank_all","sim/flightmodel/weight/m_fuel_total", "readonly") end
		-- what are the maximums of each tank
		if sges_tank_ratios_ == nil then sges_tank_ratios_ = dataref_table("sim/aircraft/overflow/acf_tank_rat") end -- RATIO
		if sges_max_tanks == nil then sges_max_tanks = get("sim/aircraft/weight/acf_m_fuel_tot") end -- kg
		if max_for_tank == nil then
			local n=0
			max_for_tank = {}
			for n=0,sges_tank_to_refuel-1 do
				max_for_tank[n] = math.floor((sges_tank_ratios_[n] * sges_max_tanks) - 10) -- EACH TANK MAX in kilograms
				print("[Ground Equipment " .. version_text_SGES .. "] We read that max fuel for tank " .. n+1 .. " is " .. math.floor(max_for_tank[n]) .. " kg.")
			end
			print("[Ground Equipment " .. version_text_SGES .. "] We have read max fuel for each tank. Ready.")
		end

		local i=0

		-- refuel
		-- /////////////////////////////////////////////////////////////////////
		for i=0,sges_tank_to_refuel-1 do
			if max_for_tank[i] - 5 >= sges_tank_[i] and sges_tank_full_flag[i] == false then
				--~ sges_tank_[i] = sges_tank_[i] + 2/sges_tank_to_refuel  -- FAST
				sges_tank_[i] = sges_tank_[i] + 1.5/sges_tank_to_refuel		--SLOWER
				--~ print("refueling tank #" .. i+1 .. ".")
			elseif sges_tank_full_flag[i] == false then
				sges_tank_full_flag[i] = true
				print("[Ground Equipment " .. version_text_SGES .. "] Tank #" .. i+1 .. " is FULL.")
			end
			-- calculate the total amount of fuel loaded
		end
		-- /////////////////////////////////////////////////////////////////////
		--~ print("-- refueling " .. sges_tank_to_refuel .. " tanks --")

		if sges_tank_full_flag[0] and sges_tank_full_flag[1] and sges_tank_full_flag[2] and sges_tank_full_flag[3] and sges_tank_full_flag[4] and sges_tank_full_flag[5] and sges_tank_full_flag[6] and sges_tank_full_flag[7] and sges_tank_full_flag[8] then
			print("[Ground Equipment " .. version_text_SGES .. "] -- Finished refueling all " .. sges_tank_to_refuel .. " declared internal tanks --")
			sges_tank_to_refuel = 0 -- conclude the refueling.
			play_sound(AAR_Refueling_completed_sound)
			active_fueling_is_possible = false
			sges_tank_ = nil
			sges_tank_all = nil
			sges_tank_full_flag = nil
			sges_tank_to_refuel = user_sges_tank_to_refuel
			-- make the engine depart
			show_FUEL = false
			FUEL_chg = true
		end
	elseif FUEL_chg and sges_tank_ ~= nil then
		sges_tank_ = nil
		sges_tank_all = nil
		sges_tank_full_flag = nil
		sges_tank_to_refuel = user_sges_tank_to_refuel
	end
end

-- Vehicles recursive detection
function sanitize_pattern(pattern)
    local special_chars = { "%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?" }
    for _, char in ipairs(special_chars) do
        pattern = string.gsub(pattern, "%" .. char, "%%%1")
    end
    return pattern
end

print("[Ground Equipment " .. version_text_SGES .. "] Loading a function to scan for third-party assets in the X-Plane folders.")


function scan_for_external_asset(aircraft, aircraft2, verbose)
    local found_path = nil
    -- Utiliser un chemin relatif à SCRIPT_DIRECTORY
    local root_dir = "../../../../Aircraft"  -- Le chemin sera relatif à SCRIPT_DIRECTORY
    if aircraft == "is in custom scenery folder" then
        root_dir = "../../../../Custom Scenery"  -- Adaptation pour Custom Scenery
    end
    if verbose == nil then verbose = 0 end

    -- Nettoyer les caractères spéciaux pour le pattern
    aircraft = sanitize_pattern(aircraft)
    aircraft2 = sanitize_pattern(aircraft2)

    if verbose == 1 then
        print("[Ground Equipment " .. version_text_SGES .. "] Looking if third-party enhancement is installed: " .. aircraft)
    end

    -- Détecter l'OS et choisir la commande correcte
    local command
    if package.config:sub(1,1) == "\\" then
        -- Commande pour Windows
        command = 'dir /b /ad "' .. SCRIPT_DIRECTORY .. root_dir .. '" 2>nul'
    else
        -- Commande pour Linux/macOS
        command = 'ls -1 "' .. SCRIPT_DIRECTORY .. root_dir .. '" 2>/dev/null'
    end

    -- Ouvrir la liste des répertoires
    local handle = io.popen(command)
    if handle then
        for entry in handle:lines() do
            -- Assurez-vous que le chemin est relatif
            entry = entry:gsub("\\", "/")  -- Remplacer les antislashs par des slashs

            if verbose == 1 then
                --~ print("[Ground Equipment " .. version_text_SGES .. "]    From " .. SCRIPT_DIRECTORY)
                print("[Ground Equipment " .. version_text_SGES .. "]    Scanning " .. entry)
            end

            if string.match(entry, aircraft) or string.match(entry, aircraft2) then
                found_path = root_dir .. "/" .. entry  -- Chemin relatif
                handle:close()
                print("[Ground Equipment " .. version_text_SGES .. "] Found " .. string.sub(found_path, -60, -1))
                return found_path  -- Arrêter la recherche une fois trouvé
            end

            -- Vérification dans les sous-dossiers (1 niveau de profondeur)
            local subcommand
            if package.config:sub(1,1) == "\\" then
                -- Commande pour Windows
                subcommand = 'dir /b /ad "' .. SCRIPT_DIRECTORY .. root_dir .. '/' .. entry .. '" 2>nul'
            else
                -- Commande pour Linux/macOS
                subcommand = 'ls -1 "' .. SCRIPT_DIRECTORY .. root_dir .. '/' .. entry .. '" 2>/dev/null'
            end

            local subhandle = io.popen(subcommand)
            if subhandle then
                for subentry in subhandle:lines() do
                    -- Remplacer les antislashs pour Windows par des slashs pour l'universalité
                    subentry = subentry:gsub("\\", "/")
                    if string.match(subentry, aircraft) or string.match(subentry, aircraft2) then
                        found_path = root_dir .. "/" .. entry .. "/" .. subentry  -- Chemin relatif
                        subhandle:close()
                        -- transform that to relative path
                        found_path = found_path:gsub("^" .. SCRIPT_DIRECTORY, "")
                        print("[Ground Equipment " .. version_text_SGES .. "] Found " .. string.sub(found_path, -60, -1))
                        return found_path  -- Arrêter la recherche une fois trouvé
                    end
                end
                subhandle:close()
            end
        end
        handle:close()
    end

    return nil  -- Aucun résultat trouvé
end




print("[Ground Equipment " .. version_text_SGES .. "] A module with ships, dynamic and secondary functions has been loaded.")
