function Chocks_position_settle()

	-- probably the sole and most important value is  gear2X

	--print("[Ground Equipment " .. version_text_SGES .. "] Settle Chocks position...")
	-- some aircraft don't feed the dataref or we want to be more accurate :
	if PLANE_ICAO == "A321" then     gear1X = -0.25 gear1Z = 15.6 gear2X = 4.5 gear2Z = -1.6
	elseif PLANE_ICAO == "A320" then gear1X = -0.25 gear1Z = 11.30 gear2X = -3.9 gear2Z = -1.09
	elseif PLANE_ICAO == "A319" then gear1X = -0.25 gear1Z = 9.85 gear2X = 4.5 gear2Z = -1.5
	elseif PLANE_ICAO == "A333" then  gear1X = 0 gear1Z = 22.293073654175 gear2X = -6.14 gear2Z = -2.39
	elseif PLANE_ICAO == "A339" then  gear1X = 0 gear1Z = 22.293073654175 gear2X = -6.14 gear2Z = -2.39
	elseif PLANE_ICAO == "A346" then gear1X = -0.31 gear1Z = 31.2 gear2X = 4.59 gear2Z = -0.51
	elseif PLANE_ICAO == "MD88" then gear1X = 0.7 gear1Z = 20.7 gear2X = 3.2 gear2Z = -1.20
	elseif PLANE_ICAO == "B736" then gear1X = 0.3 gear1Z = 9.924 gear2X = -3.35 gear2Z = -1.31
	elseif PLANE_ICAO == "B737" then gear1X = 0.2 gear1Z = 11.3 gear2X = -3.25 gear2Z = -1.48
	elseif PLANE_ICAO == "B739" then gear1X = 0.2 gear1Z = 16.04 gear2X = -3.35 gear2Z = -1.28
	elseif PLANE_ICAO == "B738" then gear1X = -0.2 gear1Z = 13.9 gear2X = 3.3 gear2Z = -1.6
	elseif PLANE_ICAO == "B762" then gear1X = -0.4 gear1Z = 17.27 gear2X = 5.02 gear2Z = -2.7
	elseif PLANE_ICAO == "B763" then gear1X = 0.29 gear1Z = 20.18 gear2X = 3.89 gear2Z = -3.1
	elseif PLANE_ICAO == "B764" then gear1X = 0.29 gear1Z = 23.88 gear2X = 3.89 gear2Z = -2.8
	elseif PLANE_ICAO == "B772" then gear1X = -0.41 gear1Z = 23.75 gear2X = -6.29 gear2Z = -0.94
	elseif PLANE_ICAO == "E170" then gear1X = 0.13 gear1Z = 9.42 gear2X = 2.19 gear2Z = -1.16
	elseif PLANE_ICAO == "E175" then gear1X = 0.13 gear1Z = 10.36 gear2X = 2.19 gear2Z = -1.16
	elseif PLANE_ICAO == "E190" then gear1X = 0.13 gear1Z = 12.43 gear2X = 2.6 gear2Z = -1.35
	elseif PLANE_ICAO == "E19L" then gear1X = 0.13 gear1Z = 12.43 gear2X = 2.6 gear2Z = -1.35
	elseif PLANE_ICAO == "E195" then gear1X = 0.13 gear1Z = 13.33 gear2X = 2.6 gear2Z = -1.35
	elseif PLANE_ICAO == "DH8D" then gear1X = -0.21 gear1Z = 12.72 gear2X = -4.64 gear2Z = -1.27
	elseif string.match(PLANE_ICAO, "P28A") then gear1X = 0.4 gear1Z = 1.3
	elseif string.match(PLANE_ICAO, "P28R") then gear1X = 0.4 gear1Z = 1.8
	elseif PLANE_ICAO == "C750" then gear1X = 0.1 gear1Z = 8.83 gear2X = -1.58 gear2Z = -0.16  -- Citation X
	elseif PLANE_ICAO == "C172" then gear1X = 0 gear1Z = 1.29 gear2X = 1.3 gear2Z = -0.62
	elseif PLANE_ICAO == "RV10" then gear1X = 0 gear1Z = 1.39 gear2X = -1.3 gear2Z = -0.57
	elseif PLANE_ICAO == "ALIA" then gear1X = -1.3 gear1Z = -2.18 gear2X = -1.3 gear2Z = 2.74
	elseif PLANE_ICAO == "L5"   then gear1X = 1.6 gear1Z = -3.8
	elseif PLANE_ICAO == "KODI" then gear1Z = 2.9 gear1X  = 0 gear2X = 1.8 -- the attachement point is not the ground contact point, so we need to input gear2X
	elseif PLANE_ICAO == "PA38" then gear1X = 0.3 gear1Z = 1.08
	elseif PLANE_ICAO == "AV8B" then gear1X = 0 gear1Z = 3.03 gear2X = -0.25 gear2Z = -0.63
	elseif PLANE_ICAO == "HAWK" then gear1X = 0 gear1Z = 4.17 gear2X = 1.710000038147 gear2Z = -0.57
	elseif PLANE_ICAO == "F16" then  gear1X = 0 gear1Z = 3.38 gear2X = -1.2 gear2Z = -0.7
	elseif PLANE_ICAO == "F14" then  gear1X = 0 gear1Z = 6.11 gear2X = -2.5 gear2Z = -0.93
	elseif PLANE_ICAO == "F15" then  gear1X = 0 gear1Z = 5.19
	elseif PLANE_ICAO == "F104" then gear1X = 0 gear1Z = 4.26 gear2X = 1.28 gear2Z = -0.4
	elseif PLANE_ICAO == "SF50" then gear2Z = -0.5
	elseif PLANE_ICAO == "DV20" then gear1X = -0.1 gear1Z = 1.95 gear2X = -1.11 gear2Z = -0.57
	elseif PLANE_ICAO == "CT4" then  gear1X = 0 gear1Z = 1.35 gear2X = -1.6 gear2Z = -0.3
	elseif PLANE_ICAO == "PA18" then gear1X = 0 gear1Z = -4.46 gear2X = -1 gear2Z = 0.31
	elseif PLANE_ICAO == "SR22" then gear1X = 0 gear1Z = 1.65
	elseif PLANE_ICAO == "BE33" then gear1X = 0 gear1Z = 1.77 gear2X = 1.3716000318527 gear2Z = -0.37
	elseif PLANE_ICAO == "B350" then gear1X = 0.4 gear1Z = 4.35 gear2X = -2.0 gear2Z = -0.5
	elseif PLANE_ICAO == "BE9L" then gear1X = 0.4 gear1Z = 3.2 gear2X = 2.2 gear2Z = -1.15
	elseif PLANE_ICAO == "CL30" then gear1X = 0.55 gear1Z = 7.9 gear2X = 1.95 gear2Z = -0.95
	elseif PLANE_ICAO == "B461" or (string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath ,"ZE7") or string.match(AircraftPath ,"100") )) then gear1X = -0.2 gear1Z = 9.33 gear2X = 2 gear2Z = -0.62
	elseif PLANE_ICAO == "B462" or (string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath ,"2Q") or string.match(AircraftPath ,"200") )) then gear1X = -0.2 gear1Z = 10.48 gear2X = 2 gear2Z = -0.62
	elseif PLANE_ICAO == "B463" or (string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath ,"3Q") or string.match(AircraftPath ,"300") )) then gear1X = -0.2 gear1Z = 11.62 gear2X = 2 gear2Z = -0.62
	elseif PLANE_ICAO == "CONC" then gear1X = 0.2 gear1Z = 17.39 gear2X = 4.09 gear2Z = -1.4
	elseif PLANE_ICAO == "F104" then gear1X = 0.1 gear1Z = 3.82 gear2X = 1.2 gear2Z = -0.4
	elseif PLANE_ICAO == "ch47" or PLANE_ICAO == "CH47" then gear1X = -1.75 gear1Z = 1.9 gear2X = 1.7465040683746 gear2Z = -4.898136138916
    elseif PLANE_ICAO == "DC3" or PLANE_ICAO == "C47" then  gear1Z = -10.36 gear1X = 0   gear2X = -2.853 gear2Z = 1.34
	elseif PLANE_ICAO == "CAML" then gear1X = 0 gear1Z = -4 gear2X = -0.7 gear2Z = 0.14
	elseif PLANE_ICAO == "DR1" then  gear2X = -0.62 gear2Z = 0.44
    elseif string.match(AIRCRAFT_PATH, "Nieuport XVII") then gear2X = -0.58
	-- ACFT not checked recently starts/
	elseif PLANE_ICAO == "C152" then gear1X = 0.3 gear1Z = 1.25
	elseif PLANE_ICAO == "C140" then gear1X = 1.2 gear1Z = 0.45
	elseif PLANE_ICAO == "B721" then gear1X = 0.8 gear1Z = 15.1 gear2X = 3.5 gear2Z = -0.9
	elseif PLANE_ICAO == "B722" then gear1X = 0.8 gear1Z = 18.1 gear2X = 3.5 gear2Z = -0.9
	elseif PLANE_ICAO == "B732" then gear1X = 0.6 gear1Z = 10.5 gear2X = 3.2 gear2Z = -1.35
	elseif PLANE_ICAO == "B733" then gear1X = 0.7 gear1Z = 11.4 gear2X = 3.2 gear2Z = -1.40
	elseif PLANE_ICAO == "B742" then gear1X = 0.5 gear1Z = 24.25 gear2X = 6.06 gear2Z = -0.7
	elseif PLANE_ICAO == "B744" then gear1X = 0.7 gear1Z = 24.7 gear2X = 4.9 gear2Z = -1.4
	elseif PLANE_ICAO == "B748" then gear1X = -0.2 gear1Z = 27.5 gear2X = 4.9 gear2Z = -1.4
	elseif PLANE_ICAO == "B752" then gear1X = 0.29 gear1Z = 16.48 gear2X = 3.99 gear2Z = -2.2
	elseif PLANE_ICAO == "B753" then gear1X = 0.29 gear1Z = 20.6 gear2X = 3.99 gear2Z = -2.2
	elseif PLANE_ICAO == "B788" then gear1X = 0.3 gear1Z = 21.26 gear2X = 5.81 gear2Z = -1.85
	elseif PLANE_ICAO == "B789" then gear1X = 0.3 gear1Z = 24.31 gear2X = 4.47 gear2Z = -2.48
	elseif PLANE_ICAO == "L410" then gear1X = 0.4 gear1Z = 3.2 	gear2X = 1.9 gear2Z = -0.85
	elseif PLANE_ICAO == "QX" or PLANE_ICAO == "AMF" then gear1X = 0.2 gear1Z = 5.5 gear2X = 2.3 gear2Z = -0.7
	elseif string.match(PLANE_ICAO, "BN2") then gear1X = 0.2 gear1Z = 3.55
	elseif string.match(AIRCRAFT_PATH, "AS365") then  gear1X = 0 gear1Z = 2.86
	elseif PLANE_ICAO == "Alouette"   then gear1X = 0 gear1Z = 2.02
	-- ACFT not checked recently ends.
	end
	-- patch for the new 2025 chocks without having to recheck all the custom value above sampled in the history of SGES. We just have to center always the chocks :
	if gear1X ~= nil and math.abs(gear1X) > 0.6  and math.abs(gear1X) < 1 then gear1X = 0 end -- lateral displacement is X
	-- values less than math.abs(0.6) are considered set after 2024 and good values
	-- we filter values higher than 0.6 and less than 1 because they were written with a different, older, geometry of chocks


	if gear2X == nil then
		dataref("gear2Y",   "sim/aircraft/parts/acf_gear_ynodef",   "readonly",1)
		dataref("gear2Xm",   "sim/aircraft/parts/acf_gear_xnodef",   "readonly",1)
		if gear2Xm == nil then gear2X = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		if gear2Y == nil then gear2Y = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		print("[Ground Equipment " .. version_text_SGES .. "] Gear 2 lateral position must be obtained from acf for this model. " .. gear2Xm)
	end
	if gear2Xm ~= nil and math.abs(gear2Xm) < 1 then
		gear2X = -1.3
	elseif gear2Xm ~= nil then
		gear2X = gear2Xm
	end -- values less than 1 are a sign of the attachement point, not the contact with the ground point so we make an assumption

	if gear2Z == nil then
		print("[Ground Equipment " .. version_text_SGES .. "] Gear 2 longitudinal position must be obtained from acf for this model.")
		if gear2Y == nil then dataref("gear2Y",   "sim/aircraft/parts/acf_gear_ynodef",   "readonly",1) end
		dataref("gear2Zm",   "sim/aircraft/parts/acf_gear_znodef",  "readonly",1)
		if gear2Zm == nil then gear2Zm = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		gear2Z = -1*gear2Zm
		if gear2Y == nil then gear2Y = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
	end

	if gear1Z == nil then
		-- gear position
		print("[Ground Equipment " .. version_text_SGES .. "] Gear 1 position must be obtained from acf.")
		dataref("gear1Xm",   "sim/aircraft/parts/acf_gear_xnodef",   "readonly",0)
		dataref("gear1Y",   "sim/aircraft/parts/acf_gear_ynodef",   "readonly",0)
		dataref("gear1Zm",   "sim/aircraft/parts/acf_gear_znodef",  "readonly",0)
		if gear1Xm == nil then gear1Xm = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		if gear1Zm == nil then gear1Zm = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		gear1Z = -1*gear1Zm
		gear1X = gear1Xm
		if gear1X == nil then gear1X = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		if gear1Y == nil then gear1Y = 0 end -- patch applied in January 2023 to save the day in SGES v61.5 when author have not defined the gear in the ACF file.
		--print("[Ground Equipment " .. version_text_SGES .. "] Gear position to set chocks obtained from aircraft via dataref acf_gear_znodef " .. gear1Zm .. " so gear is " .. gear1Z)
	end
end
