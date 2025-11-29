--------------------------------------------------------------------------------
-- Simple Ground Equipment & Services - (low tech ground services)
-- aka The Poor Man Ground Services ------------------------------------------
--------------------------------------------------------------------------------
-- USER PREFERENCES ------------------------------------------------------------
-- Version distributed with version 73 and above.


-- ||||||||||||||||| Set the Belt Loader corrective factor ||||||||||||||||||||||||
-- you can search for the parameters live by opening the developper menu ingame :
-- click on the version number inside SGES window to open that.

-- We want to have the correct placement of objects around the aircraft
function AircraftParameters() -- don't remove the function
    --It's interesting to reference the Belt Loader position per aircraft type
    -- BeltLoaderRearPosition is optional
    if AircraftPath == nil then dataref("AircraftPath","sim/aircraft/view/acf_livery_path","readonly",0) end --[[important]]
    if SGES_Author == nil then dataref("SGES_Author","sim/aircraft/view/acf_author","readonly",0) end --[[important]]
    if     PLANE_ICAO == "K35A" then BeltLoaderFwdPosition = 10.1
    elseif PLANE_ICAO == "B703" then BeltLoaderFwdPosition = 10.1	SecondStairsFwdPosition = -14.2	custom_fuel_pump_finalX = 15.50  custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "B720" then BeltLoaderFwdPosition = 10.1	SecondStairsFwdPosition = -11.2 custom_fuel_pump_finalX = 15.50  custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "B732" then BeltLoaderFwdPosition = 6.1
    elseif PLANE_ICAO == "B733" then BeltLoaderFwdPosition = 6.9	SecondStairsFwdPosition = -11.1		BeltLoaderRearPosition = -8.5
    elseif PLANE_ICAO == "B736" then BeltLoaderFwdPosition = 6.5 BeltLoaderRearPosition = -6.1 airstart_unit_factor = 16.4 SecondStairsFwdPosition = -9.5
    elseif PLANE_ICAO == "B737" then BeltLoaderFwdPosition = 6.7 BeltLoaderRearPosition = -7.2 airstart_unit_factor = 16.4 SecondStairsFwdPosition = -10.5 custom_fuel_finalX = -20 custom_fuel_finalY = -5 custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = -4.5
    elseif PLANE_ICAO == "B738" then BeltLoaderFwdPosition = 9.5 BeltLoaderRearPosition = -10 airstart_unit_factor = 16.4 SecondStairsFwdPosition = -13.6 custom_fuel_finalX = -19 custom_fuel_finalY = -4 custom_fuel_pump_finalX = -7.5 custom_fuel_pump_finalY = 0
    elseif PLANE_ICAO == "B739" then BeltLoaderFwdPosition = 11.2 airstart_unit_factor = 16.4 SecondStairsFwdPosition = -14.2 custom_fuel_finalX = -19 custom_fuel_finalY = -5 custom_fuel_pump_finalX = 12.5 custom_fuel_pump_finalY = -4
    elseif PLANE_ICAO == "B721" then BeltLoaderFwdPosition = 9.2	SecondStairsFwdPosition = 14.8
    elseif PLANE_ICAO == "B722" then BeltLoaderFwdPosition = 10.7	SecondStairsFwdPosition = 17.8		custom_fuel_pump_finalX = -16  custom_fuel_pump_finalY = -5
    elseif PLANE_ICAO == "B742" then BeltLoaderFwdPosition = 18.6 	SecondStairsFwdPosition = 13.2		airstart_unit_factor = 21	BeltLoaderRearPosition = -13 sges_refuel_port_longitudinal = 44 sges_refuel_port_elev = 4	custom_fuel_pump_finalX = 18.5 custom_fuel_pump_finalY = -1.5 custom_fuel_finalX = -26 custom_fuel_finalY = -5 airstart_unit_factor = 22.5
    elseif PLANE_ICAO == "B744" then BeltLoaderFwdPosition = 18		custom_fuel_pump_finalX = -12.5 custom_fuel_pump_finalY = -2.5
    elseif PLANE_ICAO == "B748" then BeltLoaderFwdPosition = 23	SecondStairsFwdPosition = -24.5 	airstart_unit_factor = 23	custom_fuel_pump_finalX = 17  custom_fuel_pump_finalY = 0
    elseif PLANE_ICAO == "B752" then BeltLoaderFwdPosition = 11.2 	SecondStairsFwdPosition = 8.5		BeltLoaderRearPosition = -9	custom_fuel_pump_finalX = -7  custom_fuel_pump_finalY = -2
    elseif PLANE_ICAO == "B753" then BeltLoaderFwdPosition = 15 	SecondStairsFwdPosition = -19		BeltLoaderRearPosition = -9	custom_fuel_pump_finalX = -7  custom_fuel_pump_finalY = -2
    elseif PLANE_ICAO == "B762" then BeltLoaderFwdPosition = 10.3	SecondStairsFwdPosition = -13.5		airstart_unit_factor = 20.5	BeltLoaderRearPosition = -9		custom_fuel_pump_finalX = -14.5  custom_fuel_pump_finalY = -5
    elseif PLANE_ICAO == "B762F" then BeltLoaderFwdPosition = 10.3	SecondStairsFwdPosition = -13.5		airstart_unit_factor = 20.5	BeltLoaderRearPosition = -9	custom_fuel_pump_finalX = -14.5  custom_fuel_pump_finalY = -5
    elseif PLANE_ICAO == "B763" then BeltLoaderFwdPosition = 13		SecondStairsFwdPosition = -17		airstart_unit_factor = 20.5	BeltLoaderRearPosition = -12	custom_fuel_pump_finalX = -14.5  custom_fuel_pump_finalY = -5
    elseif PLANE_ICAO == "B764" then BeltLoaderFwdPosition = 17		SecondStairsFwdPosition = -20		airstart_unit_factor = 20.5		custom_fuel_pump_finalX = -14  custom_fuel_pump_finalY = -5
    elseif PLANE_ICAO == "B788" then BeltLoaderFwdPosition = 15.5 	SecondStairsFwdPosition = -15.6 	airstart_unit_factor = 28 custom_fuel_finalX = -17 custom_fuel_finalY = -6 custom_fuel_pump_finalX = -17 custom_fuel_pump_finalY = -6
    elseif PLANE_ICAO == "B789" then BeltLoaderFwdPosition = 18.5 	SecondStairsFwdPosition = -19.7		airstart_unit_factor = 27	custom_fuel_finalX = -17 custom_fuel_finalY = -6 custom_fuel_pump_finalX = 18 custom_fuel_pump_finalY = -6
    elseif PLANE_ICAO == "B772" then BeltLoaderFwdPosition = 17.9	SecondStairsFwdPosition = -20		airstart_unit_factor = 22.8 BeltLoaderRearPosition = -12.40 	custom_fuel_pump_finalX = 15  custom_fuel_pump_finalY = 0.5
    elseif PLANE_ICAO == "B773" then BeltLoaderFwdPosition = 17.5	SecondStairsFwdPosition = -26.5		airstart_unit_factor = 24	custom_fuel_pump_finalX = 15  custom_fuel_pump_finalY = 0.5
    elseif PLANE_ICAO == "B779" then BeltLoaderFwdPosition = 17.5	SecondStairsFwdPosition = -28		airstart_unit_factor = 19
    elseif PLANE_ICAO == "MD82" then BeltLoaderFwdPosition = 12.3										airstart_unit_factor = -1  targetDoorX_alternate = 0.001 targetDoorZ_alternate = 0 targetDoorH_alternate = 0.8 custom_fuel_pump_finalX = 21.5
custom_fuel_pump_finalY = 1.5 -- SecondStairsFwdPosition = -5.9
    elseif PLANE_ICAO == "MD88" then BeltLoaderFwdPosition = 13.8	SecondStairsFwdPosition = -5.3		airstart_unit_factor = -1 targetDoorX_alternate = -0.7 targetDoorZ_alternate = -0.4 targetDoorH_alternate = 1 BeltLoaderRearPosition = -6.7									airstart_unit_factor = -1 -- SecondStairsFwdPosition = -5.9
    elseif PLANE_ICAO == "MD90" then BeltLoaderFwdPosition = 11.9	airstart_unit_factor = 2.4 	BeltLoaderRearPosition = -6.7 custom_fuel_finalX = -17 custom_fuel_finalY = -4 custom_fuel_pump_finalX = 22 custom_fuel_pump_finalY = -7
    elseif PLANE_ICAO == "MD11" then BeltLoaderFwdPosition = 14 	SecondStairsFwdPosition = -15.9		BeltLoaderRearPosition = -12.5	custom_fuel_pump_finalX = 20  custom_fuel_pump_finalY = -2.5
    elseif PLANE_ICAO == "BCS1" then BeltLoaderFwdPosition = 7.5 	SecondStairsFwdPosition = -12 -- airbus A220-100 -- to be refined in the future
    elseif PLANE_ICAO == "A318" then BeltLoaderFwdPosition = 7.5 	SecondStairsFwdPosition = -8.3		BeltLoaderRearPosition = -4.7		custom_fuel_pump_finalX = -8.25  custom_fuel_pump_finalY = 2.5
    elseif PLANE_ICAO == "A319" then BeltLoaderFwdPosition = 7 		SecondStairsFwdPosition = -11		airstart_unit_factor = 16.4   BeltLoaderRearPosition = -6.7	sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 36 sges_refuel_port_elev = 3.5		custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -0.7
    elseif PLANE_ICAO == "A19N" then BeltLoaderFwdPosition = 7 		SecondStairsFwdPosition = -11		airstart_unit_factor = 16.4   BeltLoaderRearPosition = -6.7	sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 36 sges_refuel_port_elev = 3.5		custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -0.7
    elseif PLANE_ICAO == "A320" then BeltLoaderFwdPosition = 8		SecondStairsFwdPosition = -12.7		BeltLoaderRearPosition = -7.6	custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -1.8
    elseif PLANE_ICAO == "A20N" then BeltLoaderFwdPosition = 7.6	SecondStairsFwdPosition = -13.15	BeltLoaderRearPosition = -7.5	custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -1.8
    elseif PLANE_ICAO == "A321" then BeltLoaderFwdPosition = 12 	SecondStairsFwdPosition = -15.8 	airstart_unit_factor = 16.4		BeltLoaderRearPosition = -10	custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -2.5
    elseif PLANE_ICAO == "A21N" then BeltLoaderFwdPosition = 12 	SecondStairsFwdPosition = -15.8 	airstart_unit_factor = 16.4 	BeltLoaderRearPosition = -10	custom_fuel_pump_finalX = -6.75 custom_fuel_pump_finalY = -2.5
    elseif PLANE_ICAO == "A332" then BeltLoaderFwdPosition = 20		SecondStairsFwdPosition = -21.0		airstart_unit_factor = 21		custom_fuel_pump_finalX = -12.25  custom_fuel_pump_finalY = 0
    elseif PLANE_ICAO == "A333" then BeltLoaderFwdPosition = 19.5	SecondStairsFwdPosition = -22.3		airstart_unit_factor = 21		BeltLoaderRearPosition = -15.5		custom_fuel_pump_finalX = 15  custom_fuel_pump_finalY = -2
    elseif PLANE_ICAO == "A339" then BeltLoaderFwdPosition = 20.3 BeltLoaderRearPosition = -14.5 airstart_unit_factor = 22 SecondStairsFwdPosition = -20.5  custom_fuel_finalX = -28 custom_fuel_finalY = -8 custom_fuel_pump_finalX = 15 custom_fuel_pump_finalY = -0.5
    elseif PLANE_ICAO == "A359" then BeltLoaderFwdPosition = 19		SecondStairsFwdPosition = -21.4		custom_fuel_pump_finalX = -11.50  custom_fuel_pump_finalY = -2
    elseif PLANE_ICAO == "A345" then BeltLoaderFwdPosition = 20.6   SecondStairsFwdPosition = 11.5      airstart_unit_factor = 19		custom_fuel_pump_finalX = -10.5  custom_fuel_pump_finalY = -0.5
    elseif PLANE_ICAO == "A346" then BeltLoaderFwdPosition = 28.5 	SecondStairsFwdPosition = 14.2		airstart_unit_factor = 22		BeltLoaderRearPosition = -17		custom_fuel_pump_finalX = -10.50  custom_fuel_pump_finalY = -0.5
    elseif PLANE_ICAO == "A306" then BeltLoaderFwdPosition = 14 	SecondStairsFwdPosition = -17.5	custom_fuel_pump_finalX = 13.50  custom_fuel_pump_finalY = -1
    elseif PLANE_ICAO == "A310" then BeltLoaderFwdPosition = 11  	SecondStairsFwdPosition = -12.5	custom_fuel_pump_finalX = 13.50  custom_fuel_pump_finalY = -1
    elseif PLANE_ICAO == "A3ST" then BeltLoaderFwdPosition = 17		custom_fuel_pump_finalX = 13.50  custom_fuel_pump_finalY = -1
    elseif PLANE_ICAO == "IL96" then BeltLoaderFwdPosition = 14  	SecondStairsFwdPosition = -11.0

    elseif PLANE_ICAO == "E170" then BeltLoaderFwdPosition = 6.1	BeltLoaderRearPosition = -5.7	SecondStairsFwdPosition = -7.80	custom_fuel_pump_finalX = -9  custom_fuel_pump_finalY = 0.5
    elseif PLANE_ICAO == "E175" then BeltLoaderFwdPosition = 6.1	BeltLoaderRearPosition = -6.5	SecondStairsFwdPosition = -8.7	custom_fuel_pump_finalX = -8.50  custom_fuel_pump_finalY = -0.5
    elseif PLANE_ICAO == "E190" then BeltLoaderFwdPosition = 9.1 	BeltLoaderRearPosition = -8.2  SecondStairsFwdPosition = -11.1	custom_fuel_pump_finalX = -8.50  custom_fuel_pump_finalY = -2
    elseif PLANE_ICAO == "E19L" then BeltLoaderFwdPosition = 9.1 	custom_fuel_pump_finalX = -8.50  custom_fuel_pump_finalY = -2	targetDoorH_alternate = 1.25	targetDoorX_alternate = -0.7 targetDoorX_alternate_boarding = 0.9 targetDoorZ_alternate = 0
    elseif PLANE_ICAO == "E195" then BeltLoaderFwdPosition = 9.99	BeltLoaderRearPosition = -9.4	SecondStairsFwdPosition = -12.3	custom_fuel_pump_finalX = -8.50  custom_fuel_pump_finalY = -3

    elseif PLANE_ICAO == "CL30" then BeltLoaderFwdPosition = -5
    elseif PLANE_ICAO == "CL60" then BeltLoaderFwdPosition = -5 targetDoorX_alternate = 0.001 targetDoorZ_alternate = 0 targetDoorH_alternate = 2.0 UseXplane1220Chocks = true UseXplane1220Chocks_specific = true
    elseif PLANE_ICAO == "CRJ7" then BeltLoaderFwdPosition = 5.7	airstart_unit_factor = -1 --Deltawing CRJ-700
    elseif PLANE_ICAO == "CRJ9" or PLANE_ICAO == "CRJ900" then BeltLoaderFwdPosition = 6.7	airstart_unit_factor = -1 --Deltawing CRJ-900
    elseif PLANE_ICAO == "SF34" then BeltLoaderFwdPosition = 5
    elseif PLANE_ICAO == "QX" then BeltLoaderFwdPosition = 3 -- MetroLiner Passenger by "Starvingpilot"
    elseif PLANE_ICAO == "AMF" then BeltLoaderFwdPosition = 3 -- MetroLiner Freight by "Starvingpilot"
    elseif PLANE_ICAO == "DH8D" then BeltLoaderFwdPosition = 6.30  targetDoorX_alternate = 0.001 	targetDoorZ_alternate = 0.01 	targetDoorH_alternate = 0.1 custom_fuel_pump_finalX = -7 custom_fuel_pump_finalY = -1.50 -- Q400
    elseif PLANE_ICAO == "DH8C" then BeltLoaderFwdPosition = 5.1 BeltLoaderFwdPosition = 3.8 	-- Q300 old value then new value
    elseif string.match(PLANE_ICAO,"DH8A")  then BeltLoaderFwdPosition = 3.30 	-- Q300 old value then new value
    elseif string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath,"ZE7") or string.match(AircraftPath,"100") ) then BeltLoaderFwdPosition = -5		custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1
    elseif string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath,"2Q")  or string.match(AircraftPath,"200") ) then BeltLoaderFwdPosition = -4.9 	custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1
    elseif string.match(AIRCRAFT_PATH,"146") and (string.match(AircraftPath,"3Q")  or string.match(AircraftPath,"300") ) then BeltLoaderFwdPosition = -5.5 	custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "B461" then BeltLoaderFwdPosition = -5	custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1 -- BAe-146
    elseif PLANE_ICAO == "B462" then BeltLoaderFwdPosition = -4.9	custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "B463" then BeltLoaderFwdPosition = -5.5	custom_fuel_finalX = -15  custom_fuel_finalY = 1	custom_fuel_pump_finalX = 13 custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "RJ70" then BeltLoaderFwdPosition = -5 		custom_fuel_pump_finalX = -11 custom_fuel_pump_finalY = 1 -- AVRO RJ variants
    elseif PLANE_ICAO == "RJ85" then BeltLoaderFwdPosition = -4.9		custom_fuel_pump_finalX = -11 custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "RJ1H" then BeltLoaderFwdPosition = -5.5		custom_fuel_pump_finalX = -11 custom_fuel_pump_finalY = 1
    elseif PLANE_ICAO == "CONC" then BeltLoaderFwdPosition = 12  	BeltLoaderRearPosition = -12.5 --SecondStairsFwdPosition = 24S
    elseif PLANE_ICAO == "DC4" then  BeltLoaderFwdPosition = -4.5
    elseif PLANE_ICAO == "DC3" then  BeltLoaderFwdPosition = -4.9  targetDoorX_alternate = 0.1	targetDoorZ_alternate = -2.5	targetDoorH_alternate = 0.22
    elseif PLANE_ICAO == "C47" then  BeltLoaderFwdPosition = -4.9  targetDoorX_alternate = 0.1	targetDoorZ_alternate = -2.5	targetDoorH_alternate = 0.22
    elseif PLANE_ICAO == "AN12" then BeltLoaderFwdPosition = -12
    elseif PLANE_ICAO == "AN26" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "L188" then BeltLoaderFwdPosition = 7.50	airstart_unit_factor = 19.4
    elseif PLANE_ICAO == "PC12" then BeltLoaderFwdPosition = -4  targetDoorX_alternate = -0.5 targetDoorZ_alternate = 0.4 targetDoorH_alternate = 1.91
    elseif PLANE_ICAO == "D328" then BeltLoaderFwdPosition = -4	-- Dornier 328
    elseif PLANE_ICAO == "DHC6" and string.match(SGES_Author,"Wilson") then BeltLoaderFwdPosition = -4  custom_fuel_finalX = -19 custom_fuel_finalY = -6	custom_fuel_pump_finalX = -19  custom_fuel_pump_finalY = -6   targetDoorX_alternate = -1.1 targetDoorZ_alternate = 6.7 targetDoorH_alternate = 1.65	-- R. Wilson Twin Otter (Payware)
    elseif PLANE_ICAO == "DHC6" then BeltLoaderFwdPosition = -4  custom_fuel_finalX = -19 custom_fuel_finalY = -6	custom_fuel_pump_finalX = -19  custom_fuel_pump_finalY = -6  targetDoorX_alternate = -0.5 targetDoorZ_alternate = -8 targetDoorH_alternate = 1.95	-- Twin Otter (other than R. Wilson payware)
    elseif PLANE_ICAO == "ASB" then BeltLoaderFwdPosition = 10	custom_fuel_pump_finalX = -8	custom_fuel_pump_finalY = -1 targetDoorX_alternate = 0.01	targetDoorZ_alternate = -20		targetDoorH_alternate = 0.1 -- Br 763 Deux ponts
    elseif PLANE_ICAO == "GLF650ER" then BeltLoaderFwdPosition = -7  airstart_unit_factor = 11.4	custom_fuel_finalX = -22 custom_fuel_finalY = -4 custom_fuel_pump_finalX = 18.5 custom_fuel_pump_finalY = -5.5  targetDoorX_alternate = -0.7 targetDoorZ_alternate = -0.8 targetDoorH_alternate = 1.5
    elseif PLANE_ICAO == "E55P" then BeltLoaderFwdPosition = -3.80 airstart_unit_factor = 1.4 custom_fuel_finalX = -8 custom_fuel_finalY = 0 custom_fuel_pump_finalX = 18 custom_fuel_pump_finalY = -6.5
    elseif PLANE_ICAO == "C525" then BeltLoaderFwdPosition = -3.80 airstart_unit_factor = 1.4 custom_fuel_finalX = -12 custom_fuel_finalY = 0 custom_fuel_pump_finalX = 18 custom_fuel_pump_finalY = -6.5

    -- MILITARY PLANES
    elseif PLANE_ICAO == "C130" then BeltLoaderFwdPosition = -10 sges_refuel_port_elev = 3.5
    elseif PLANE_ICAO == "C17" then BeltLoaderFwdPosition = 13 SecondStairsFwdPosition = -30 sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 25 sges_refuel_port_elev = 6	-- Virtavia Alpeggio Dom C-17
    elseif PLANE_ICAO ~= "C170" and PLANE_ICAO ~= "C172" and string.match(AIRCRAFT_PATH, "C-17") then BeltLoaderFwdPosition = 13 SecondStairsFwdPosition = -30 sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 25	sges_refuel_port_elev = 6 -- Virtavia Alpeggio Dom C-17
    elseif PLANE_ICAO == "L100" then BeltLoaderFwdPosition = -10
    elseif PLANE_ICAO == "VULC" then BeltLoaderFwdPosition = 10  sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 30 sges_refuel_port_elev = -0.3 -- sges_refuel_port is for in flight refueling
    elseif PLANE_ICAO == "SR71" then BeltLoaderFwdPosition = 1.5   targetDoorX_alternate = -7.8  targetDoorZ_alternate = -4.7 sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 19.5
    elseif PLANE_ICAO == "AV8B" then BeltLoaderFwdPosition = -4 sges_refuel_port_lateral = 1.75 sges_refuel_port_longitudinal = 16
    elseif PLANE_ICAO == "HAWK" then BeltLoaderFwdPosition = -2  sges_refuel_port_elev = 0
    elseif PLANE_ICAO == "M346" then  BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = -0.6  sges_refuel_port_longitudinal = 17.8 sges_refuel_port_elev = 1

	elseif PLANE_ICAO == "F35"   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-35 Lightning II
	elseif string.match(PLANE_ICAO, "F-35")   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- AOA XP12 F-35 Lightning II
	elseif PLANE_ICAO == "VF35"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Variant of F-35
	elseif PLANE_ICAO == "SU57"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Sukhoi Su-57
	elseif PLANE_ICAO == "J20"   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Chengdu J-20
    elseif PLANE_ICAO == "F15" then  BeltLoaderFwdPosition = -2 sges_refuel_port_lateral = 1.75 sges_refuel_port_longitudinal = 12  sges_refuel_port_elev = 0.1 -- sges_tank_to_refuel = 5
    elseif PLANE_ICAO == "F16" then  BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 9 sges_refuel_port_elev = 0.2
    elseif PLANE_ICAO == "F18" then  BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20
	elseif PLANE_ICAO == "F18H" then  BeltLoaderFwdPosition = 2 sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20  -- Hornet variant
	elseif PLANE_ICAO == "F18S" then  BeltLoaderFwdPosition = 2 sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20 -- Hornet variant
	elseif PLANE_ICAO == "MIRA"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Mirage III, V
	elseif PLANE_ICAO == "MIR2"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Mirage 2000
	elseif PLANE_ICAO == "EUFI"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Eurofighter Typhoon
	elseif PLANE_ICAO == "J10"   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Chengdu J-10
	elseif PLANE_ICAO == "JH7"   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Xian JH-7
	elseif PLANE_ICAO == "AJET"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Alpha Jet
	elseif PLANE_ICAO == "LCA"   then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- HAL Tejas
	elseif PLANE_ICAO == "KFIR"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- IAI Kfir
	elseif PLANE_ICAO == "JAGR"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- SEPECAT Jaguar
	elseif PLANE_ICAO == "RFAL"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Dassault Rafale
	elseif PLANE_ICAO == "ETAR"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- Super Etandard
	elseif string.match(PLANE_ICAO, "J8") then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- All SHENYANG J8 fighters
	elseif string.match(PLANE_ICAO, "J10") then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- All SHENYANG J10 fighters
	--[[ Legacy Fighters ]]--
    elseif PLANE_ICAO == "F4" then   BeltLoaderFwdPosition = 2 sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 10 -- sges_tank_to_refuel = 8
	elseif PLANE_ICAO == "F5"    then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-5 Tiger II or Modern Asiatic fighter
	elseif PLANE_ICAO == "F8"    then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-8 Crusader
    elseif PLANE_ICAO == "F19" then  BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 11 sges_refuel_port_elev = 0.2 -- Fictionnal fighter
    elseif PLANE_ICAO == "F119" then BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 11 sges_refuel_port_elev = 0.2
	elseif PLANE_ICAO == "F100"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-100 Super Sabre
	elseif PLANE_ICAO == "F102"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-102 Delta Dagger
    elseif PLANE_ICAO == "F104" then BeltLoaderFwdPosition = 2 sges_refuel_port_lateral = 0.75 sges_refuel_port_longitudinal = 19
	elseif PLANE_ICAO == "F106"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-106 Delta Dart
	elseif PLANE_ICAO == "F117"  then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30 -- F-117 Nighthawk
	elseif PLANE_ICAO == "TOR" then  BeltLoaderFwdPosition = 2 SecondStairsFwdPosition = -30
	elseif string.match(AIRCRAFT_PATH, "Tornado") then  BeltLoaderFwdPosition = 2 SecondStairsFwdPosition = -30
	elseif string.match(PLANE_ICAO, "MG2") or string.match(AIRCRAFT_PATH, "MiG%-2") then  BeltLoaderFwdPosition = 2 SecondStairsFwdPosition = -30   -- MIKOYAN MIG-2x
	elseif string.match(PLANE_ICAO, "MG3") or string.match(AIRCRAFT_PATH, "MiG%-3")  then  BeltLoaderFwdPosition = 2   SecondStairsFwdPosition = -30 -- MIKOYAN MIG-3x
	elseif string.match(PLANE_ICAO, "SB3") or string.match(AIRCRAFT_PATH, "SB3") then  BeltLoaderFwdPosition = 2  SecondStairsFwdPosition = -30   -- All Saab fighters
    elseif PLANE_ICAO == "F14" then 														BeltLoaderFwdPosition = 2  sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20 sges_tank_to_refuel = 7
	elseif string.match(AIRCRAFT_PATH, "F-14")   then 										BeltLoaderFwdPosition = -3 sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20 sges_tank_to_refuel = 7
    elseif string.find(SGES_Author,"Alex Unruh") and AIRCRAFT_FILENAME == "F-14D.acf" then  BeltLoaderFwdPosition = -5 sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20 sges_tank_to_refuel = 7
    elseif string.find(SGES_Author,"Brault") and AIRCRAFT_FILENAME == "F104A.acf" then BeltLoaderFwdPosition = 2 sges_refuel_port_lateral = 0.75 sges_refuel_port_longitudinal = 16
    elseif string.find(SGES_Author,"Tom Kyler") and AIRCRAFT_FILENAME == "F-4.acf" then BeltLoaderFwdPosition = -4 sges_refuel_port_lateral = 0 sges_refuel_port_longitudinal = 10	sges_tank_to_refuel = 8	--  Laminar XP12 Phantom II
	elseif string.match(AIRCRAFT_PATH, "Tornado") then BeltLoaderFwdPosition = -4  sges_refuel_port_lateral = -1 sges_refuel_port_longitudinal = 20
	elseif string.match(AIRCRAFT_PATH, "Buckeye") then BeltLoaderFwdPosition = -4	-- print("T2")PLANE_ICAO == "F22"  -- F-22 Raptor


    -- LIGHT AVIATION
    elseif PLANE_ICAO == "C750" then BeltLoaderFwdPosition = -6 -- Laminar XP12 Citation X
    elseif PLANE_ICAO == "BE9L" then BeltLoaderFwdPosition = 2
    elseif string.match(PLANE_ICAO, "P28") then BeltLoaderFwdPosition = 1.7 -- All Piper 28 types
    elseif string.match(PLANE_ICAO, "BN2") then BeltLoaderFwdPosition = -5 -- All BN2 Islander types
    elseif PLANE_ICAO == "B350" then BeltLoaderFwdPosition = -4 -- Beechcraft King Air 350
    elseif PLANE_ICAO == "BE76" then BeltLoaderFwdPosition = -4 -- Beechcraft Duchess 76
    elseif PLANE_ICAO == "BE58" then BeltLoaderFwdPosition = -4 --  Laminar XP12 Beechcraft 58
    elseif PLANE_ICAO == "SR22" then BeltLoaderFwdPosition = -4 --  Laminar XP12 Cirrus SR22
    elseif PLANE_ICAO == "SF50" then BeltLoaderFwdPosition = -4 --  Laminar XP12 Cirrus SR22
    elseif PLANE_ICAO == "EVIC" then BeltLoaderFwdPosition = -4 --  Aerobask Epic Victory
    elseif PLANE_ICAO == "EVOT" then BeltLoaderFwdPosition = -1 --  Laminar XP12 Lancair Evolution
    elseif PLANE_ICAO == "RV10" then BeltLoaderFwdPosition = -4 --  Laminar XP12 RV10
    elseif PLANE_ICAO == "EV55" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "L410" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C206" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C182" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C172" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C152" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C150" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "C140" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "DR40" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "L5" 	then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "PA18" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "PA30" then BeltLoaderFwdPosition = -4 -- Piper Twin Comanche
    elseif PLANE_ICAO == "PA38" then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "MU2" 	then BeltLoaderFwdPosition = -4
    elseif PLANE_ICAO == "AS21" then BeltLoaderFwdPosition = -4 --  Laminar XP12 ASK21 Glider
    elseif PLANE_ICAO == "KODI" then BeltLoaderFwdPosition = 4  targetDoorX_alternate = 0.001 targetDoorZ_alternate = -2.9 targetDoorH_alternate = 1.25
    elseif PLANE_ICAO == "DV20" then BeltLoaderFwdPosition = -1.5  custom_fuel_finalX = -4 custom_fuel_finalY = 2 custom_fuel_pump_finalX = -4 custom_fuel_pump_finalY = 2 targetDoorX_alternate = 1.06 targetDoorZ_alternate = -3.59 targetDoorH_alternate = 0.6 SGES_mirror = 1 -- Diamond DA20 Katana/Evolution
    elseif AIRCRAFT_FILENAME == "Aerolite_103.acf" then BeltLoaderFwdPosition = -4		--  Laminar XP12 Aerolite 103

    -- HELICOPTERS
    elseif PLANE_ICAO == "S76" then BeltLoaderFwdPosition = 0	custom_fuel_finalX = -17 custom_fuel_finalY = -6	targetDoorX_alternate = 0.5 targetDoorZ_alternate = -3.75 targetDoorH_alternate = 0.6 --  Laminar XP11 S-76
    elseif PLANE_ICAO == "S61" then BeltLoaderFwdPosition = 0	custom_fuel_finalX = -17 custom_fuel_finalY = -6	targetDoorZ_alternate = -2.6	--  Sea King S61
    elseif PLANE_ICAO == "CH53" then BeltLoaderFwdPosition = 0	custom_fuel_finalX = -17 custom_fuel_finalY = -6 	targetDoorX_alternate = 0.001 targetDoorZ_alternate = -15 targetDoorH_alternate = -0.37
    elseif PLANE_ICAO == "R22" then BeltLoaderFwdPosition = -4	targetDoorX_alternate = 0.2 targetDoorZ_alternate = 0.3 targetDoorH_alternate = 0.6	--  Laminar XP12 Robinson R-22
    elseif PLANE_ICAO == "S92" then BeltLoaderFwdPosition = -2 	custom_fuel_finalX = -17 custom_fuel_finalY = -6	targetDoorX_alternate = -1.68 targetDoorZ_alternate = -3.909 targetDoorH_alternate = 1.916 SGES_mirror = 1
    elseif PLANE_ICAO == "412" then BeltLoaderFwdPosition = 2
    elseif PLANE_ICAO == "ch47" then BeltLoaderFwdPosition = 2 	 targetDoorX_alternate = -0.6 targetDoorZ_alternate = -6.4 targetDoorH_alternate = 0.25	-- Chinook
    elseif PLANE_ICAO == "LAMA" then BeltLoaderFwdPosition = -4 	-- LAMA
    elseif PLANE_ICAO == "SA341" then BeltLoaderFwdPosition = -4 	-- Gazelle H
    elseif PLANE_ICAO == "SA342" then BeltLoaderFwdPosition = -4 	-- Gazelle H
    elseif PLANE_ICAO == "EC35" then BeltLoaderFwdPosition = -4 	-- Eurocopter H135
    elseif PLANE_ICAO == "EC45" then BeltLoaderFwdPosition = -4 	-- Eurocopter H145
    elseif PLANE_ICAO == "BO-105" then BeltLoaderFwdPosition = -5 	-- Messerschmitt-Bölkow-Blohm Bo 105
    elseif PLANE_ICAO == "Mi-24" then BeltLoaderFwdPosition = -4	-- Hind
    elseif PLANE_ICAO == "W3A" then BeltLoaderFwdPosition = -4		-- Sokol W3A
    elseif PLANE_ICAO == "H125" then BeltLoaderFwdPosition = -5
    elseif string.match(AIRCRAFT_PATH, "AS365")  then  BeltLoaderFwdPosition = 0	custom_fuel_finalX = -17 custom_fuel_finalY = -6	targetDoorX_alternate = 0.5 targetDoorZ_alternate = -3.75 targetDoorH_alternate = 0.6 --  Dauphin
	elseif string.match(AIRCRAFT_PATH, "A318") then BeltLoaderFwdPosition = 7.5 SecondStairsFwdPosition = -8.3	-- print("A318")
    elseif PLANE_ICAO == "ALIA" then BeltLoaderFwdPosition = -4
    elseif string.match(AIRCRAFT_PATH, "Do228-212") then BeltLoaderFwdPosition = -4	-- Dornier 228
    elseif string.match(AIRCRAFT_PATH, "Do228-101") then BeltLoaderFwdPosition = -6	-- Dornier 228
	-- ATR stuff at the final position !
    elseif string.match(PLANE_ICAO,"AT4") then BeltLoaderFwdPosition = 2.5	targetDoorZ_alternate = -11.7	targetDoorH_alternate = 1.40	-- ATR 42-500 by Rivière and henkfix
    elseif (string.match(PLANE_ICAO,"AT7") or SGES_Author == "ATGCAB (Alfredo Torrado & Juan Alcon)") then BeltLoaderFwdPosition = 3	targetDoorZ_alternate = -16.2	targetDoorH_alternate = 1.40	-- ATR 72-500 by Rivière and henkfix or Aerosoft mods
    elseif string.match(AIRCRAFT_PATH, "Nieuport XVII") then BeltLoaderFwdPosition = -3

    --[[important]] -- Do not remove the lines below
    --[[important]] -- Everything SecondStairsFwdPosition = -30  or SecondStairsFwdPosition < -30 kills the rear airstair. That's wanted.
    -- and now, if the user plane wasn't checked by XPJavelin already, we can have some automatic settings :
    elseif get("sim/aircraft/parts/acf_gear_znodef") >= -3 then
		BeltLoaderFwdPosition = -4 SecondStairsFwdPosition = -30
		print("[Ground Equipment " .. version_text_SGES .. "] Small aircraft not customized. Applying smaller ground services.")
		-- automatically recognize small aircraft and apply GA services.
    else BeltLoaderFwdPosition = 10 SecondStairsFwdPosition = -30
		print("[Ground Equipment " .. version_text_SGES .. "] Aircraft not customized. Applying regular ground services.")
		-- all other acft retain the normal, bigger, ground service set.
    end
	print("[Ground Equipment " .. version_text_SGES .. "] AircraftParameters() says aircraft type is " .. PLANE_ICAO ..", provided by " .. AIRCRAFT_FILENAME .. ".")









    -- -------------------------------------------------------------------------
	-- ||||||||||||||||| Refine the airstair location (optional) |||||||||||||||

	-- ADJUST LOCATION OF FWD AIRSTAIR
	-- vertical_door_position = vertical correction
	-- deltaDoorX = lateral distanciation to the fuselage tube
    if PLANE_ICAO == "A321" then     vertical_door_position = -2.05 deltaDoorX = 6.66
    elseif PLANE_ICAO == "A21N" then vertical_door_position = -2.05 deltaDoorX = 6.66
    elseif PLANE_ICAO == "A320" then vertical_door_position = -2.2 deltaDoorX = 7.2
    elseif PLANE_ICAO == "A20N" then vertical_door_position = -2.05 deltaDoorX = 6.58
    elseif PLANE_ICAO == "A319" then vertical_door_position = -2.05 deltaDoorX = 6.66
	elseif PLANE_ICAO == "A318" then vertical_door_position = -1.9 deltaDoorX = 6.7
    elseif PLANE_ICAO == "A306" then vertical_door_position = -2.4 deltaDoorX = 7.9
    elseif PLANE_ICAO == "A310" then vertical_door_position = -2.0 deltaDoorX = 8.65
    elseif PLANE_ICAO == "A332" then vertical_door_position = -1.9 deltaDoorX = 7.6
    --elseif PLANE_ICAO == "A333" then vertical_door_position = -2.1 deltaDoorX = 7.7 -- XP11 freeware model
    elseif PLANE_ICAO == "A333" then vertical_door_position = -2.4 deltaDoorX = 7.9 -- XP12 A333
    elseif PLANE_ICAO == "A339" then vertical_door_position = -3.5 deltaDoorX = 8
    elseif PLANE_ICAO == "A346" then vertical_door_position = -3.9 deltaDoorX = 7.7
    elseif PLANE_ICAO == "A359" then vertical_door_position = -1.7 deltaDoorX = 8.9
    elseif PLANE_ICAO == "A3ST" then vertical_door_position = -3 deltaDoorX = 7.9
	elseif PLANE_ICAO == "MD11" then vertical_door_position = -1.9 deltaDoorX = 7.9
    elseif PLANE_ICAO == "MD82" then vertical_door_position = -2.6 deltaDoorX = 6.1
    elseif PLANE_ICAO == "MD88" then vertical_door_position = -2.2 deltaDoorX = 6.8
    elseif PLANE_ICAO == "K35A" then vertical_door_position = -3.8 deltaDoorX = 4.8 targetDoorZ_alternate = -3.6
    elseif PLANE_ICAO == "B703" then vertical_door_position = -2.8 deltaDoorX = 6.7
    elseif PLANE_ICAO == "B720" then vertical_door_position = -2.6 deltaDoorX = 6.7
    elseif PLANE_ICAO == "B721" then vertical_door_position = -3.8 deltaDoorX = 6.6
    elseif PLANE_ICAO == "B722" then vertical_door_position = -3.8 deltaDoorX = 6.6
    elseif PLANE_ICAO == "B732" then vertical_door_position = -3.2 deltaDoorX = 6.55
    elseif PLANE_ICAO == "B733" then vertical_door_position = -2.35 deltaDoorX = 6.55
    elseif PLANE_ICAO == "B736" then vertical_door_position = -2.7 deltaDoorX = 6.55
    elseif PLANE_ICAO == "B737" then vertical_door_position = -2.7 deltaDoorX = 6.35
    elseif PLANE_ICAO == "B738" then vertical_door_position = -2.7 deltaDoorX = 6.3
    elseif PLANE_ICAO == "B739" then vertical_door_position = -2.7 deltaDoorX = 6.25
    elseif PLANE_ICAO == "B742" then vertical_door_position = -1   deltaDoorX = 8.8
    elseif PLANE_ICAO == "B744" then vertical_door_position = -2.7 deltaDoorX = 9.3
    elseif PLANE_ICAO == "B748" then vertical_door_position = -2.7 deltaDoorX = 9.3
    elseif PLANE_ICAO == "B752" then vertical_door_position = -2.7 deltaDoorX = 6.5
    elseif PLANE_ICAO == "B753" then vertical_door_position = -2.7 deltaDoorX = 6.5
    elseif PLANE_ICAO == "B763" then vertical_door_position = -2.2 deltaDoorX = 7.7
    elseif PLANE_ICAO == "B764" then vertical_door_position = -2.0 deltaDoorX = 7.7
    elseif PLANE_ICAO == "B762" then vertical_door_position = -2.2 deltaDoorX = 7.7
    elseif PLANE_ICAO == "B762F" then vertical_door_position = -2.2 deltaDoorX = 7.7
    elseif PLANE_ICAO == "B788" then vertical_door_position = -1.6 deltaDoorX = 8.6
    elseif PLANE_ICAO == "B789" then vertical_door_position = -1.6 deltaDoorX = 8.8
    elseif PLANE_ICAO == "B772" then vertical_door_position = -2.7 deltaDoorX = 8.85 -- STS/FF 777 v2 : 777-200ER
    elseif PLANE_ICAO == "B773" then vertical_door_position = -3.0 deltaDoorX = 8.6
    elseif PLANE_ICAO == "B779" then vertical_door_position = -3.0 deltaDoorX = 8.6
    elseif PLANE_ICAO == "IL96" then vertical_door_position = -0.1 deltaDoorX = 8.3
    elseif PLANE_ICAO == "CONC" then vertical_door_position = -2.4 deltaDoorX = 5.9
    elseif PLANE_ICAO == "DH8D" then vertical_door_position = -3.8 deltaDoorX = 5.9
    elseif PLANE_ICAO == "CRJ7" then vertical_door_position = -2.1 deltaDoorX = 9	targetDoorX_alternate = 0.09 targetDoorZ_alternate = -0.419 targetDoorH_alternate = 0
    elseif PLANE_ICAO == "CRJ9" then vertical_door_position = -2.1 deltaDoorX = 9	targetDoorX_alternate = 0 targetDoorZ_alternate = 1.7 targetDoorH_alternate = 0
    elseif PLANE_ICAO == "E170" then vertical_door_position = -2.35 deltaDoorX = 5.9
    elseif PLANE_ICAO == "E190" then vertical_door_position = -2.8 deltaDoorX = 5.9
    elseif PLANE_ICAO == "E19L" then vertical_door_position = -2.8 deltaDoorX = 5.9
    elseif PLANE_ICAO == "E175" then vertical_door_position = -2.35 deltaDoorX = 5.9
    elseif PLANE_ICAO == "E195" then vertical_door_position = -2.7 deltaDoorX = 5.6
    elseif string.match(AIRCRAFT_PATH,"146") then 		vertical_door_position = -3.35 deltaDoorX = 6.55
    elseif PLANE_ICAO == "RJ70" then  vertical_door_position = -3.35 deltaDoorX = 6.55
    elseif PLANE_ICAO == "RJ85" then  vertical_door_position = -3.35 deltaDoorX = 6.55
    elseif PLANE_ICAO == "RJ1H" then  vertical_door_position = -3.35 deltaDoorX = 6.55
	elseif string.match(AIRCRAFT_PATH, "Tornado") then 	vertical_door_position = -2.2 deltaDoorX = 4.5
	elseif string.match(AIRCRAFT_PATH, "A318") then 	vertical_door_position = -1.9 deltaDoorX = 6.7
    elseif PLANE_ICAO == "AN12" then  vertical_door_position = -2 deltaDoorX = 5
    elseif PLANE_ICAO ~= "C170" and PLANE_ICAO ~= "C172" and string.match(AIRCRAFT_PATH, "C-17") then vertical_door_position = -4.2 deltaDoorX = 5.6 targetDoorZ_alternate = -5.6
    elseif PLANE_ICAO == "GLF650ER" then vertical_door_position = -4.1 deltaDoorX = 8.2 	targetDoorX_alternate = -0.7 	targetDoorZ_alternate = -0.8	targetDoorH_alternate = 1.5
    elseif PLANE_ICAO == "E55P" then vertical_door_position = -3 deltaDoorX = 13.5 			targetDoorX_alternate = 0.86792 targetDoorZ_alternate = -4.3584 targetDoorH_alternate = 0.00377
    elseif PLANE_ICAO == "A109" then vertical_door_position = -4 deltaDoorX = 9 			targetDoorX_alternate = 0.1 targetDoorZ_alternate = 0.8 	targetDoorH_alternate = 0.8
    elseif string.match(AIRCRAFT_PATH, "AS365") then vertical_door_position = -4 deltaDoorX = 9 			targetDoorX_alternate = 0.1 targetDoorZ_alternate = -3.6 	targetDoorH_alternate = 0.8 -- Dauphin
    else vertical_door_position = -4 deltaDoorX = 9
    end

	-- ADJUST LOCATION OF AFT AIRSTAIR and AIRSTAIR MARK V
	-- vertical_door_position2 = vertical correction
	-- deltaDoorX2 = lateral distanciation to the fuselage tube
	if PLANE_ICAO == "A319" then vertical_door_position2 = -2 deltaDoorX2 = 6.5
	elseif PLANE_ICAO == "MD11" then vertical_door_position2 = -2.1 deltaDoorX2 = 8.1
    elseif PLANE_ICAO == "MD82" then vertical_door_position2 = -2.6 deltaDoorX2  = 6.1
    elseif PLANE_ICAO == "MD88" then vertical_door_position2 = -2.0 deltaDoorX2  = 7.0
	elseif PLANE_ICAO == "A321" then vertical_door_position2 = -2 deltaDoorX2 = 6.5
	elseif PLANE_ICAO == "A21N" then vertical_door_position2 = -2 deltaDoorX2 = 6.5
    elseif PLANE_ICAO == "A320" then vertical_door_position2 = -2.2 deltaDoorX2 = 7.2
    elseif PLANE_ICAO == "A20N" then vertical_door_position2 = -2.1 deltaDoorX2 = 6.55
	elseif PLANE_ICAO == "A318" then vertical_door_position2 = -1.85 deltaDoorX2 = 6.5
    elseif PLANE_ICAO == "A332" then vertical_door_position2 = -1.0 deltaDoorX2 = 7.4
    elseif PLANE_ICAO == "A333" then vertical_door_position2 = -1.4 deltaDoorX2 = 8.0 longitudinal_factor3 = 11.2 -- Changed to XP12 A333
    elseif PLANE_ICAO == "A359" then vertical_door_position2 = -1.7 deltaDoorX2 = 9.25 sges_gs_plane_head_correction2 = -0.2 longitudinal_factor3 = 12.5	height_factor3 = -0.1	lateral_factor3 = 0.3 -- Changed to XP12 A333
    elseif PLANE_ICAO == "A339" then vertical_door_position2 = -2.6 deltaDoorX2 = 7.8 sges_gs_plane_head_correction2 = -0.2 longitudinal_factor3 = 12.3 height_factor3 = 0.1 lateral_factor3 = 0.45
    elseif PLANE_ICAO == "B703" then vertical_door_position2 = -2.6 deltaDoorX2 = 7.7 sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "B720" then vertical_door_position2 = -2.6 deltaDoorX2 = 7.7 sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "B721" then vertical_door_position2 = -3.8 deltaDoorX2 = 6.7
    elseif PLANE_ICAO == "B722" then vertical_door_position2 = -3.8 deltaDoorX2 = 6.6
    elseif PLANE_ICAO == "B733" then vertical_door_position2 = -2.2 deltaDoorX2 = 7.2 sges_gs_plane_head_correction2 = -0.2
    elseif PLANE_ICAO == "B736" then vertical_door_position2 = -2.5 deltaDoorX2 = 6.65 sges_gs_plane_head_correction2 = -0.5
    elseif PLANE_ICAO == "B737" then vertical_door_position2 = -2.5 deltaDoorX2 = 6.7 sges_gs_plane_head_correction2 = -2.3
	elseif PLANE_ICAO == "B738" then vertical_door_position2 = -2.8 deltaDoorX2 = 6.3
	elseif PLANE_ICAO == "B739" then vertical_door_position2 = -2.5 deltaDoorX2 = 6.3 sges_gs_plane_head_correction2 = -0.9
	elseif PLANE_ICAO == "B742" then vertical_door_position2 = -1   deltaDoorX2 = 9.1 sges_gs_plane_head_correction2 = -0.2	longitudinal_factor3 = -23
    elseif PLANE_ICAO == "B748" then vertical_door_position2 = -2.3 deltaDoorX2 = 9.0 longitudinal_factor3 = 13.2 	height_factor3 = 0.23	lateral_factor3 = 0.1
	elseif PLANE_ICAO == "B752" then vertical_door_position2 = -2.7 deltaDoorX2 = 6.7
	elseif PLANE_ICAO == "B753" then vertical_door_position2 = -2.7 deltaDoorX2 = 6.5
    elseif PLANE_ICAO == "B764" then vertical_door_position2 = -1.9 deltaDoorX2 = 7.7	longitudinal_factor3 = 9.8
    elseif PLANE_ICAO == "B763" then vertical_door_position2 = -1.9 deltaDoorX2 = 7.7
    elseif PLANE_ICAO == "B762" then vertical_door_position2 = -1.9 deltaDoorX2 = 7.7
    elseif PLANE_ICAO == "B762F" then vertical_door_position2 = -1.9 deltaDoorX2 = 7.7
    elseif PLANE_ICAO == "B772" then vertical_door_position2 = -2 deltaDoorX2 = 8.8		sges_gs_plane_head_correction2 = -0.2	longitudinal_factor3 = 12.9
    elseif PLANE_ICAO == "B773" then vertical_door_position2 = -3.0 deltaDoorX2 = 9.9	sges_gs_plane_head_correction2 = -0.2
    elseif PLANE_ICAO == "B779" then vertical_door_position2 = -3.0 deltaDoorX2 = 9.9	sges_gs_plane_head_correction2 = -0.2
    elseif PLANE_ICAO == "B788" then vertical_door_position2 = -1.1 deltaDoorX2 = 8.65 	sges_gs_plane_head_correction2 = -1	longitudinal_factor3 = 0 height_factor3 = 0 lateral_factor3 = 0
    elseif PLANE_ICAO == "B789" then vertical_door_position2 = -1.1 deltaDoorX2 = 8.6 sges_gs_plane_head_correction2 = -0.4	longitudinal_factor3 = 23.7 height_factor3 = 0 lateral_factor3 = 0
    elseif PLANE_ICAO == "A310" then vertical_door_position2 = -2.1 deltaDoorX2 = 8.7 sges_gs_plane_head_correction2 = -0.2
    elseif PLANE_ICAO == "A306" then vertical_door_position2 = -1.8 deltaDoorX2 = 8.7 sges_gs_plane_head_correction2 = -0.2
	elseif PLANE_ICAO == "A346" then vertical_door_position2 = -3.5 deltaDoorX2 = 8.2		longitudinal_factor3 = -23.3 height_factor3 = 1.2
	elseif string.match(AIRCRAFT_PATH, "A318") then vertical_door_position2 = -1.85 deltaDoorX2 = 6.5
    elseif PLANE_ICAO == "IL96" then vertical_door_position2 = -0.1 deltaDoorX2 = 9.7 sges_gs_plane_head_correction2 = -0.2
	elseif PLANE_ICAO == "B461" then SecondStairsFwdPosition = -6.40  vertical_door_position2 = -3.3 deltaDoorX2 = 6.45 sges_gs_plane_head_correction2 = -1.1
	elseif PLANE_ICAO == "B462" then SecondStairsFwdPosition = -7.70  vertical_door_position2 = -3.3 deltaDoorX2 = 6.45 sges_gs_plane_head_correction2 = -0.9
	elseif PLANE_ICAO == "B463" then SecondStairsFwdPosition = -8.70  vertical_door_position2 = -3.3 deltaDoorX2 = 6.45 sges_gs_plane_head_correction2 = -0.9
    elseif PLANE_ICAO == "CONC" then vertical_door_position2 = -2.4 deltaDoorX2 = 5.9
    elseif PLANE_ICAO == "E170" then vertical_door_position2 = -2.6 deltaDoorX2 = 6  sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "E175" then vertical_door_position2 = -2.6 deltaDoorX2 = 6  sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "E190" then vertical_door_position2 = -2.2 deltaDoorX2 = 6  sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "E19L" then vertical_door_position2 = -2.2 deltaDoorX2 = 6  sges_gs_plane_head_correction2 = -1
    elseif PLANE_ICAO == "E195" then vertical_door_position2 = -2.1  deltaDoorX2 = 5.  sges_gs_plane_head_correction2 = -0.4
    elseif PLANE_ICAO == "GLF650ER" then vertical_door_position2 = -4  deltaDoorX2 = 11  sges_gs_plane_head_correction2 = 0  	longitudinal_factor3 = 0  height_factor3 = 0  lateral_factor3 = 0
    elseif PLANE_ICAO == "E55P" then vertical_door_position2 = -4 deltaDoorX2 = 11 sges_gs_plane_head_correction2 = 0 			longitudinal_factor3 = 0 height_factor3 = 0 lateral_factor3 = 0
	else vertical_door_position2 = -4 deltaDoorX2 = 11
	end


    -- -------------------------------------------------------------------------
	-- |||| Define the dataref to open the aircraft left front and rear doors for passengers |||||
	-- we also work the dataref regarding the X-Plane aircraft model author
    if SGES_Author == nil then dataref("SGES_Author","sim/aircraft/view/acf_author","readonly") end --[[important]]

    if PLANE_ICAO == "A321"     and SGES_Author == "Gliding Kiwi" then 			dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray" 				index_to_open_the_door = 0 	target_to_open_the_door = 2 index_to_open_the_second_door = 6 -- TOLISS -- possible confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
    elseif PLANE_ICAO == "A21N"     and SGES_Author == "Gliding Kiwi" then 			dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray" 				index_to_open_the_door = 0 	target_to_open_the_door = 2 index_to_open_the_second_door = 6 -- TOLISS -- possible confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
    elseif PLANE_ICAO == "A20N" and SGES_Author == "Gliding Kiwi" then 			dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray" 				index_to_open_the_door = 0	target_to_open_the_door = 2 index_to_open_the_second_door = 2 -- TOLISS -- possible confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
    elseif PLANE_ICAO == "A319" and SGES_Author == "Gliding Kiwi" then 			dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray" 				index_to_open_the_door = 0	target_to_open_the_door = 2 index_to_open_the_second_door = 2 -- TOLISS -- possible confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
    elseif PLANE_ICAO == "A339" and SGES_Author == "GlidingKiwi" then
		dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray"
		index_to_open_the_door = 0
		target_to_open_the_door = 2
		index_to_open_the_second_door = 6  -- TOLISS -- HAS GOT a confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
    elseif PLANE_ICAO == "A346" and SGES_Author == "GlidingKiwi" then 			dataref_to_open_the_door = "AirbusFBW/PaxDoorModeArray"					index_to_open_the_door = 0	target_to_open_the_door = 2 index_to_open_the_second_door = 2 -- TOLISS -- possible confrontation with Speedy Copilot for ToLiSs plugin which loads first the door reference
	elseif PLANE_ICAO == "MD11" and string.find(SGES_Author,"Juan Alcon") then 	dataref_to_open_the_door = "Rotate/aircraft/controls/fwd_l_ckt_door_ctrl"	index_to_open_the_door = 0 	target_to_open_the_door = 1	 -- ROTATE, this command is intercepted as such in the script - not a dataref
	elseif PLANE_ICAO == "MD88" and string.find(SGES_Author,"Juan Alcon") then 	dataref_to_open_the_door = "Rotate/md80/doors/main_cabin_door_ratio"	index_to_open_the_door = 0 	target_to_open_the_door = 1	 -- ROTATE, this command is intercepted as such in the script - not a dataref
    elseif PLANE_ICAO == "B732" and SGES_Author == "" then 						dataref_to_open_the_door = "FJS/732/DoorSta/Door1" 						index_to_open_the_door = 0 target_to_open_the_door = 0.9 index_to_open_the_second_door = 2 --  (FlyJSim)
    elseif PLANE_ICAO == "B748" and string.find(SGES_Author,"Supercritical") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 8 -- SSG 747-8i
    elseif PLANE_ICAO == "B752" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 4 -- FF/STS 757
    elseif PLANE_ICAO == "B753" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 4 -- FF/STS 757
    elseif PLANE_ICAO == "B762" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 4 -- FF/STS 767
    elseif PLANE_ICAO == "B762F" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 -- FF/STS 767
    elseif PLANE_ICAO == "B764" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 4  -- FF/STS 767
    elseif PLANE_ICAO == "B763" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 4  -- FF/STS 767

    elseif PLANE_ICAO == "B772" and string.find(SGES_Author,"FlightFactor") then dataref_to_open_the_door = "1-sim/anim/doorL1"   	index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 5  -- FF/STS 767

    elseif PLANE_ICAO == "B788" and SGES_Author == "Magknight" then 			dataref_to_open_the_door = "aero787/doors/door_open_ratio" 			 	index_to_open_the_door = 0 target_to_open_the_door = 0.9 index_to_open_the_second_door = 1  -- Magknight
    elseif PLANE_ICAO == "B789" and SGES_Author == "Magknight" then 			dataref_to_open_the_door = "aero787/doors/door_open_ratio"  			index_to_open_the_door = 0 target_to_open_the_door = 0.9 index_to_open_the_second_door = 1  -- Magknight
    elseif PLANE_ICAO == "A306" and string.find(SGES_Author,"iniSim") then		dataref_to_open_the_door = "A300/GND/doors_target" 						index_to_open_the_door = 1 target_to_open_the_door = 1 -- IniSimulations A300
    elseif PLANE_ICAO == "A310" and string.find(SGES_Author,"iniSim") then		dataref_to_open_the_door = "A300/GND/doors_target" 						index_to_open_the_door = 1 target_to_open_the_door = 1 -- IniSimulations  A310
    elseif PLANE_ICAO == "A3ST" and string.find(SGES_Author,"iniSim") then		dataref_to_open_the_door = "A300/GND/doors_target" 						index_to_open_the_door = 1 target_to_open_the_door = 1 -- IniSimulations Beluga
    elseif PLANE_ICAO == "CONC" and SGES_Author == "COLIMATA" then 				dataref_to_open_the_door = "Colimata/CON_SW_TO_DOORS_passenger_vi" 		index_to_open_the_door = 0 target_to_open_the_door = 1 -- colimata concorde GUI
    --~ elseif PLANE_ICAO == "E175" then dataref_to_open_the_door =
    --~ elseif PLANE_ICAO == "E190" then dataref_to_open_the_door =
    elseif PLANE_ICAO == "E170" and SGES_Author == "Supercritical Simulations Group" then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   index_to_open_the_door = 0 target_to_open_the_door = 1 -- SSG Embraer
    elseif PLANE_ICAO == "E195" and SGES_Author == "Supercritical Simulations Group" then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"   index_to_open_the_door = 0 target_to_open_the_door = 1 -- SSG Embraer
    elseif string.match(AIRCRAFT_PATH,"146") and string.find(SGES_Author,"Thranda") then  dataref_to_open_the_door = "sim/cockpit2/switches/door_open" 			index_to_open_the_door = 1 target_to_open_the_door = 1 -- Just Flight BAe 146
    elseif PLANE_ICAO == "A359" then											dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 -- not controlled by writable dataref (Flight Factor A350)
    elseif PLANE_ICAO == "B733" then 											dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 -- No door at all (IXEG for X-Plane 11)
    elseif PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" then 		dataref_to_open_the_door = "B742/anim/pax_door_1_left"  index_to_open_the_door = 0 target_to_open_the_door = 1 -- Felis 742
    --elseif PLANE_ICAO == "B742" and SGES_Author == "Felis Leopard" then 		dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 -- No door implemented yet (Felis 742)
    elseif PLANE_ICAO == "B721" and SGES_Author == "" then 						dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 -- No door at all (FlyJSim)
    elseif PLANE_ICAO == "B722" and SGES_Author == "" then 						dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 -- No door at all (FlyJSim)
    elseif PLANE_ICAO == "B736" then 											dataref_to_open_the_door = "laminar/B738/door/fwd_L_toggle" index_to_open_the_door = 0 target_to_open_the_door = 0 index_to_open_the_second_door = 3 -- not controlled by dataref (Zibo/Level Up)
    elseif PLANE_ICAO == "B737" then 											dataref_to_open_the_door = "laminar/B738/door/fwd_L_toggle" index_to_open_the_door = 0 target_to_open_the_door = 0 index_to_open_the_second_door = 3 -- not controlled by dataref (Zibo/Level Up)
    elseif PLANE_ICAO == "B738" then 											dataref_to_open_the_door = "laminar/B738/door/fwd_L_toggle" index_to_open_the_door = 0 target_to_open_the_door = 0 index_to_open_the_second_door = 3 -- not controlled by dataref (Zibo/Level Up)
    elseif PLANE_ICAO == "B739" then 											dataref_to_open_the_door = "laminar/B738/door/fwd_L_toggle" index_to_open_the_door = 0 target_to_open_the_door = 0 index_to_open_the_second_door = 3 -- not controlled by dataref (Zibo/Level Up)
    --elseif PLANE_ICAO == "DH8D" and string.find(SGES_Author,"FlyJSim") then 											dataref_to_open_the_door = "FJS/Q4XP/Animation/Toggle_Rear_Right_Cabin_Door" index_to_open_the_door = 0 target_to_open_the_door = 0 index_to_open_the_second_door = 3 -- not controlled by dataref (Zibo/Level Up)
	elseif (PLANE_ICAO == "E190" or PLANE_ICAO == "E195" or PLANE_ICAO == "E170" or PLANE_ICAO == "E175") and SGES_Author == "Marko Mamula" then dataref_to_open_the_door = "XCrafts/doors/front_main"   index_to_open_the_door = 0 target_to_open_the_door = 1   dataref_to_open_the_second_door = "XCrafts/doors/back_main" -- X-Crafts Embraer
	elseif PLANE_ICAO == "E19L" and SGES_Author == "Marko Mamula" then dataref_to_open_the_door = "XCrafts/doors/front_main"   index_to_open_the_door = 0 target_to_open_the_door = 1   dataref_to_open_the_second_door = "XCrafts/Lineage/animation/airstairs_target" -- X-Crafts Embraer

    elseif string.find(SGES_Author,"Unruh") and (PLANE_ICAO == "A339") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 6
    -- Laminar Research X-Plane 12 default fleet is supported by the following lines.
    elseif string.find(SGES_Author,"Unruh") and (PLANE_ICAO == "A333") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 6
    elseif string.find(SGES_Author,"Austin Meyer") and (PLANE_ICAO == "MD82") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"  index_to_open_the_door = 0 target_to_open_the_door = 1 index_to_open_the_second_door = 2
    elseif string.find(SGES_Author,"Tom Kyler") and (PLANE_ICAO == "BE58") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1
    elseif string.find(SGES_Author,"Austin Meyer") and (PLANE_ICAO == "SR22" or PLANE_ICAO == "EVOT") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1
    elseif string.find(SGES_Author,"Laminar") and (PLANE_ICAO == "SF50") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1
    elseif string.find(SGES_Author,"Fernandez") and (PLANE_ICAO == "RV10") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 0 target_to_open_the_door = 1
    elseif string.find(SGES_Author,"Marcel Felde") and (PLANE_ICAO == "R22") then dataref_to_open_the_door = "sim/cockpit2/switches/door_open"  index_to_open_the_door = 2 target_to_open_the_door = 1
    elseif string.find(SGES_Author,"Alex Unruh") and (AIRCRAFT_FILENAME == "F-14D.acf") then dataref_to_open_the_door = "sim/cockpit2/switches/custom_slider_on"  index_to_open_the_door = 2 target_to_open_the_door = 1

    else dataref_to_open_the_door = nil index_to_open_the_door = nil target_to_open_the_door = 1 index_to_open_the_second_door = nil
    end

    return BeltLoaderFwdPosition
end
-- -----------------------------------------------------------------------------
--~ from the reviews and comments, one thing that is coming very often with my ground services is that the rear belt loader wasn't properly aligned with the rear cargo compartiment door. Many people fail to realize that it is an artistic choice above all. One of the other key factor here is that my script is intended to be plug-an-play for the user. And should he wants to fine tunes things, a very limited set of parameters should be exposed to him in the aircraft configuration files.
--~ At the beginning of SGES, you had BeltLoaderFwdPosition and that was it. That factor helps to set the forward belt loader in front of the forward cargo door, but is also used by almost ALL other vehicles for placement purposes. During the course of the updates, I added several other positioning factors for the users such as SecondStairsFwdPosition, airstart_unit_factor and so on. But the general principle of this remains : only BeltLoaderFwdPosition is really required when someone want to start customizing. And it's not even required as we use default values otherwise for aicraft that we would not already cover.
--~ Finally I added an ultimate parameter available to users, following popular demand : BeltLoaderRearPosition. And guess what it does ? Writing this parameter in the conf file is purely optional, you don't have to add this parameter for all airplanes to be good.
