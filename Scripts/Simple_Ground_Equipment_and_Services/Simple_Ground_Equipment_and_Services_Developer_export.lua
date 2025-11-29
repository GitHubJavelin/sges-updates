-- 74.4 and above.
function SGES_13march2024_WriteToDisk(option)
	if option == nil then option = 0 end
	-- 0 is temp file export
	-- 1 is profile export


	if PLANE_ICAO ~= nil and option == 0 then
		SGES_FileNameExport = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_EXPORT." .. PLANE_ICAO .. ".tempo.txt"
	elseif AIRCRAFT_FILENAME ~= nil and  option == 1 then
			SGES_FileNameExport = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_CONFIG_" .. AIRCRAFT_FILENAME .. ".lua"
	else
		SGES_FileNameExport = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services_CONFIG_EXPORT.tempo.txt"
	end


	file = io.open(SGES_FileNameExport, "w")
	if option == 0 then
		file:write('-- This export allows you to add or amend manually an aircraft configuration in SGES_CONFIG_Aircraft.lua \n\n')
	elseif option == 1 then
		file:write("--Exported ".. string.format("%02d",os.date("%H")) .. "h" ..  string.format("%02d",os.date("%M")))
		file:write('-- This profile is optional, lots of aircraft are already defined in the general file FlyWithLua/Scripts/Simple_Ground_Equipment_and_Services_CONFIG_aircraft.lua.\n--This profile allows customisation only. You can remove it safely.\n\n')
	end
	file:write("\n--Aircraft-----------------------------------\n\n")
	if option == 0 then
		if PLANE_ICAO ~= nil then file:write("--PLANE_ICAO = " .. PLANE_ICAO .. "\n") 		else  file:write("--PLANE_ICAO = undefined for this aircraft\n") end
		if SGES_Author ~= nil then file:write("--SGES_Author = " .. SGES_Author .. "\n") 		else  file:write("--SGES_Author = undefined for this aircraft\n") end
		if AIRCRAFT_FILENAME ~= nil then file:write("--AIRCRAFT_FILENAME = " .. AIRCRAFT_FILENAME .. "\n") 		else  file:write("--AIRCRAFT_FILENAME = undefined for this aircraft\n") end
	elseif option == 1 then
		if PLANE_ICAO ~= nil then file:write("SGES_CONFIG_PLANE_ICAO = \"" .. PLANE_ICAO .. "\"\n") 		else  file:write("--PLANE_ICAO = undefined for this aircraft\n") end
		if SGES_Author ~= nil then file:write("SGES_CONFIG_SGES_Author = \"" .. SGES_Author .. "\"\n") 		else  file:write("--SGES_Author = undefined for this aircraft\n") end
		if AIRCRAFT_FILENAME ~= nil then file:write("SGES_CONFIG_AIRCRAFT_FILENAME = \"" .. AIRCRAFT_FILENAME .. "\"\n") 		else  file:write("--AIRCRAFT_FILENAME = undefined for this aircraft\n") end
	end


	if option == 1 then
		file:write("\n--Simulator version--------------------------\n\n")
		if SGES_xplane_internal_version ~= nil then file:write("--X-Plane " .. SGES_xplane_internal_version .. "\n") 		else  file:write("--SGES_xplane_internal_version = undefined\n") end
	end

	file:write("\n--Services location--------------------------\n\n")
	if BeltLoaderFwdPosition ~= nil then file:write("BeltLoaderFwdPosition = " .. BeltLoaderFwdPosition .. "\n") 		else  file:write("--BeltLoaderFwdPosition = undefined for this aircraft\n") end
	file:write("\n--Optional parameters------------------------\n\n")
	if BeltLoaderRearPosition ~= nil then file:write("BeltLoaderRearPosition = " .. BeltLoaderRearPosition .. "\n") 			else  file:write("--BeltLoaderRearPosition = undefined for this aircraft\n") end
	if airstart_unit_factor ~= nil then file:write("airstart_unit_factor = " .. airstart_unit_factor .. "\n") 				else  file:write("--airstart_unit_factor = undefined for this aircraft\n") end
	if SecondStairsFwdPosition ~= nil and SecondStairsFwdPosition ~= -30 then file:write("SecondStairsFwdPosition = " .. SecondStairsFwdPosition .. "\n") 		else  file:write("--SecondStairsFwdPosition = -30 -- undefined for this aircraft\n") end
	if vertical_door_position2 ~= nil then file:write("vertical_door_position2 = " .. vertical_door_position2 .. "\n") 		else  file:write("--vertical_door_position2 = undefined for this aircraft\n") end
	if deltaDoorX2 ~= nil then file:write("deltaDoorX2 = " .. deltaDoorX2 .. "\n") 											else  file:write("--deltaDoorX2 = undefined for this aircraft\n") end
	if sges_gs_plane_head_correction2 ~= nil then file:write("sges_gs_plane_head_correction2 = " .. sges_gs_plane_head_correction2 .. "\n") 											else  file:write("--sges_gs_plane_head_correction2 = undefined for this aircraft\n") end
	if vertical_door_position ~= nil then file:write("vertical_door_position = " .. vertical_door_position .. "\n") 			else  file:write("--vertical_door_position = undefined for this aircraft\n") end
	if deltaDoorX ~= nil then file:write("deltaDoorX = " .. deltaDoorX .. "\n") 												else  file:write("--deltaDoorX = undefined for this aircraft\n") end
	if longitudinal_factor3 ~= nil then file:write("longitudinal_factor3 = " .. longitudinal_factor3 .. "\n") 												else  file:write("--longitudinal_factor3 = undefined for this aircraft\n") end
	if height_factor3 ~= nil then file:write("height_factor3 = " .. height_factor3 .. "\n") 												else  file:write("--height_factor3 = undefined for this aircraft\n") end
	if lateral_factor3 ~= nil then file:write("lateral_factor3 = " .. lateral_factor3 .. "\n") 												else  file:write("--lateral_factor3 = undefined for this aircraft\n") end
	if gs_plane_head_correction3 ~= nil then file:write("gs_plane_head_correction3 = " .. gs_plane_head_correction3 .. "\n") 												else  file:write("--gs_plane_head_correction3 = undefined\n") end

	if gear1X ~= nil then file:write("gear1X = " .. gear1X .. "\n") end
	if gear1Z ~= nil then file:write("gear1Z = " .. gear1Z .. "\n") end
	if gear2X ~= nil then file:write("gear2X = " .. gear2X .. "\n") end
	if gear2Z ~= nil then file:write("gear2Z = " .. gear2Z .. "\n") end


	file:write("\n--Refueling parameters-----------------------\n\n")

	if custom_fuel_finalX ~= nil then file:write("custom_fuel_finalX = " .. custom_fuel_finalX .. "\n") 												else  file:write("--custom_fuel_finalX = undefined for this aircraft\n") end
	if custom_fuel_finalY ~= nil then file:write("custom_fuel_finalY = " .. custom_fuel_finalY .. "\n") 												else  file:write("--custom_fuel_finalY = undefined for this aircraft\n") end


	if custom_fuel_pump_finalX ~= nil then file:write("custom_fuel_pump_finalX = " .. custom_fuel_pump_finalX .. "\n") 												else  file:write("--custom_fuel_pump_finalX = undefined for this aircraft\n") end
	if custom_fuel_pump_finalY ~= nil then file:write("custom_fuel_pump_finalY = " .. custom_fuel_pump_finalY .. "\n") 												else  file:write("--custom_fuel_pump_finalY = undefined for this aircraft\n") end

	if sges_ahr ~= nil and sges_ahr == 1 then file:write("sges_ahr = " .. sges_ahr .. "\n") else  file:write("--refueler not available. Add this airplane type to _Refuelable_Aircraft_list.lua\n") end
	if sges_refuel_port_lateral ~= nil then file:write("sges_refuel_port_lateral = " .. sges_refuel_port_lateral .. "\n") 	else  file:write("--sges_refuel_port_lateral = undefined for this aircraft\n") end
	if sges_refuel_port_longitudinal ~= nil then file:write("sges_refuel_port_longitudinal = " .. sges_refuel_port_longitudinal .. "\n") else  file:write("--sges_refuel_port_longitudinal = undefined for this aircraft\n") end
	if sges_refuel_port_elev ~= nil then file:write("sges_refuel_port_elev = " .. sges_refuel_port_elev .. "\n") else  file:write("--sges_refuel_port_elev = undefined for this aircraft\n") end

	file:write("\n--Door opening parameters--------------------\n\n")
	if dataref_to_open_the_door ~= nil then file:write("dataref_to_open_the_door = \"" .. dataref_to_open_the_door .. "\"\n") else  file:write("--dataref_to_open_the_door = undefined for this aircraft\n") end
	if index_to_open_the_door ~= nil then file:write("index_to_open_the_door = " .. index_to_open_the_door .. "\n") else  file:write("--index_to_open_the_door = undefined for this aircraft\n") end
	if index_to_open_the_second_door ~= nil then file:write("index_to_open_the_second_door = " .. index_to_open_the_second_door .. "\n") else  file:write("--index_to_open_the_second_door = undefined for this aircraft\n") end
	if target_to_open_the_door ~= nil then file:write("target_to_open_the_door = " .. target_to_open_the_door .. "\n") else  file:write("--target_to_open_the_door = undefined for this aircraft\n") end

	if targetDoorX_alternate and targetDoorX_alternate ~= 0 and SGES_stairs_type ~= nil and SGES_stairs_type == "Boarding_without_stairs" then -- when it was amended by the user via in game sliders
		file:write("\n--Passengers attachement point (direct boarding ops)--------\n\n") -- added December 2024
		if targetDoorX_alternate ~= nil then file:write("targetDoorX_alternate = " .. targetDoorX_alternate .. "\n") else  file:write("--targetDoorX_alternate = undefined for this aircraft\n") end
		if targetDoorX_alternate_boarding ~= nil then file:write("targetDoorX_alternate_boarding = " .. targetDoorX_alternate_boarding .. "\n") else  file:write("--targetDoorX_alternate_boarding = undefined (usually expected)\n") end
		if targetDoorZ_alternate ~= nil then file:write("targetDoorZ_alternate = " .. targetDoorZ_alternate .. "\n") else  file:write("--targetDoorZ_alternate = undefined for this aircraft\n") end
		if targetDoorH_alternate ~= nil then file:write("targetDoorH_alternate = " .. targetDoorH_alternate .. "\n") else  file:write("--targetDoorH_alternate = undefined for this aircraft\n") end
	end
	if SGES_stairs_type ~= nil and SGES_stairs_type == "Boarding_without_stairs" then file:write("-- SGES_stairs_type = " .. SGES_stairs_type .. "\n") end -- INEFFECTIVE, NOT a problem.
	if BeltLoaderFwdPosition < 5 and SGES_mirror ~= nil and SGES_mirror == 1 then file:write("SGES_mirror = " .. SGES_mirror .. " -- Mirror ground services. 1 if in force. 0 if not.\n") end -- Mirror ground services (for SMALL aircraft)
	if plane_has_cargo_hold_on_the_left_hand_side ~= nil and plane_has_cargo_hold_on_the_left_hand_side then file:write("\n\nplane_has_cargo_hold_on_the_left_hand_side = true") end

	if UseXplane1220Chocks_specific ~= nil and UseXplane1220Chocks_specific then
		file:write("\n") file:write("UseXplane1220Chocks = true UseXplane1220Chocks_specific = true\n")
		if LoadXplane1220Chocks_specific ~= nil and LoadXplane1220Chocks_specific then file:write("show_Chocks = true Chocks_chg = true LoadXplane1220Chocks_specific = true \n") end
	end

	file:close()
end




function WriteToDisk_SGES_USER_CONFIG()
	SGES_FileNameExport = SCRIPT_DIRECTORY .. "Simple_Ground_Equipment_and_Services/aircraft_optional_profiles/SGES_USER_CONFIG.lua"
	file = io.open(SGES_FileNameExport, "w")
	file:write("\n--USER OPTIONS if different than default value-----\n\n")
	if aviationweather_source_us ~= nil and aviationweather_source_us and aviationweather_source_eu ~= nil and aviationweather_source_es ~= nil then -- default is Europe
		file:write("\naviationweather_source_us = true")
	    file:write("\naviationweather_source_eu = false")
	    file:write("\naviationweather_source_es = false")
	end
	if aviationweather_source_us ~= nil and aviationweather_source_es ~= nil and aviationweather_source_es and aviationweather_source_eu ~= nil then -- default is Europe
		file:write("\naviationweather_source_us = false")
	    file:write("\naviationweather_source_eu = false")
	    file:write("\naviationweather_source_es = true")
	end
	if not stairs_authorized then	file:write("\nstairs_authorized = false")	end
	if IsXPlane1214 and UseXplane1214DefaultObject ~= nil and not UseXplane1214DefaultObject then file:write("\nUseXplane1214DefaultObject = false") end  -- only need to save it when false, because default is true
	if show_auto_stairs ~= nil and show_auto_stairs then file:write("\nshow_auto_stairs = true")  end
	if User_prefers_containerized_freight ~= nil and User_prefers_containerized_freight~= false then file:write("\nUser_prefers_containerized_freight = true") end
	if reduce_even_more_the_number_of_passengers ~= nil and reduce_even_more_the_number_of_passengers~= false then file:write("\nreduce_even_more_the_number_of_passengers = true") end
	if SGES_sound ~= nil and not SGES_sound then file:write("\nSGES_sound = false")  end -- only need to save it when false, because default is true
	if show_Cones_initially ~= nil and not show_Cones_initially then file:write("\nshow_Cones_initially = false")  end -- only need to save it when false, because default is true
	if scan_third_party_initially ~= nil and not scan_third_party_initially then file:write("\nscan_third_party_initially = false")  end
	if scan_third_party_initially ~= nil and scan_third_party_initially then file:write("\nscan_third_party_initially = true")  end
	if Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand ~= 2700 and Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand >= 900 then
		file:write("\nAntiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = " .. Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand)
	end
	if Cami_de_Bellis_authorized ~= nil and not Cami_de_Bellis_authorized then file:write("\nCami_de_Bellis_authorized = false")  end -- only need to save it when false, because default is true
	if sequence_debug_factor ~= nil and sequence_debug_factor ~= 1 then file:write("\nsequence_debug_factor = " .. sequence_debug_factor .. " -- used for the timing of the ground service sequence")  end
	if not play_sound_SGES_is_available then 		file:write("\nplay_sound_SGES_is_available = false") end
	if XTrident_Chinook_Directory ~= nil then 		file:write("\nXTrident_Chinook_Directory = \"" .. XTrident_Chinook_Directory .. "\"") end
	if XTrident_NaveCavour_Directory ~= nil then 	file:write("\nXTrident_NaveCavour_Directory = \"" .. XTrident_NaveCavour_Directory .. "\"") end
	if FFSTS_777v2_Directory ~= nil then 	file:write("\nFFSTS_777v2_Directory = \"" .. FFSTS_777v2_Directory .. "\"") end
	if Cami_de_Bellis_Directory ~= nil then 	file:write("\nCami_de_Bellis_Directory = \"" .. Cami_de_Bellis_Directory .. "\"") end
	file:close()
end

function Wipe_SGES_USER_CONFIG()
	-- if the user continues to use the script without reloading we must reset the option
	-- to avoid overtaking and writing the old status of the option with WriteToDisk_SGES_USER_CONFIG()
	aviationweather_source_us = false
	aviationweather_source_eu = true -- default is Europe
	aviationweather_source_es = false
	stairs_authorized = true
	Cami_de_Bellis_authorized = true
	UseXplane1214DefaultObject = true
	show_auto_stairs = false
	reduce_even_more_the_number_of_passengers = false
	SGES_sound = true
	Antiice_application_elapsed_time_ie_duration_of_the_active_protection_gained_from_the_deice_stand = 2700
	play_sound_SGES_is_available = true
	show_Cones_initially = true
	scan_third_party_initially = true
	sequence_debug_factor = 1
	XTrident_Chinook_Directory = nil
	XTrident_NaveCavour_Directory = nil
	FFSTS_777v2_Directory = nil
	Cami_de_Bellis_Directory = nil
	WriteToDisk_SGES_USER_CONFIG()
end
