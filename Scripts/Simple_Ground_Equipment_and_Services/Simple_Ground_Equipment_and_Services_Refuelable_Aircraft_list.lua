
-- //////////////////////////////////////////////////// --
-- Force Air-to-Air capabilities for a list of aircraft
-- //////////////////////////////////////////////////// --

-- This list allows aircraft without air to air receiver in the x-plane model
-- to be nevertheless accounted as refuelable aircraft.

-- Since some aircraft are identified via string.match(), they cover multiple
-- sub-variants (e.g., SU2 includes SU22, SU25, etc.),so the total actual
-- aircraft types detected may exceed 100 models.

-- Another option is to tick the air to air receiver option in Plane Maker.

if  -- Do not edit this line
--[[ Air Superiority / Multirole Fighters ]]--
PLANE_ICAO == "F22"  -- F-22 Raptor
or PLANE_ICAO == "F35"  -- F-35 Lightning II
or PLANE_ICAO == "F-35A"  -- AOA XP12 F-35 Lightning II
or PLANE_ICAO == "F-35B"  -- AOA XP12 F-35 Lightning II
or PLANE_ICAO == "F-35C"  -- AOA XP12 F-35 Lightning II
or PLANE_ICAO == "VF35" -- Variant of F-35
or PLANE_ICAO == "SU57" -- Sukhoi Su-57
or PLANE_ICAO == "J20"  -- Chengdu J-20
or PLANE_ICAO == "F14"  -- F-14 Tomcat
or PLANE_ICAO == "F15"  -- F-15 Eagle
or PLANE_ICAO == "F16"  -- F-16 Fighting Falcon
or PLANE_ICAO == "F18"  -- F/A-18 Hornet
or PLANE_ICAO == "F18H" -- Hornet variant
or PLANE_ICAO == "F18S" -- Hornet variant
or PLANE_ICAO == "MIRA" -- Mirage III, V
or PLANE_ICAO == "MIR2" -- Mirage 2000
or PLANE_ICAO == "EUFI" -- Eurofighter Typhoon
or PLANE_ICAO == "J10"  -- Chengdu J-10
or PLANE_ICAO == "JH7"  -- Xian JH-7
or PLANE_ICAO == "AJET" -- Alpha Jet
or PLANE_ICAO == "LCA"  -- HAL Tejas
or PLANE_ICAO == "KFIR" -- IAI Kfir
or PLANE_ICAO == "JAGR" -- SEPECAT Jaguar
or PLANE_ICAO == "RFAL" -- Dassault Rafale
or PLANE_ICAO == "ETAR" -- Super Etandard
or PLANE_ICAO == "ATLA" -- Atlas
or string.match(PLANE_ICAO, "J8") -- All SHENYANG J8 fighters
or string.match(PLANE_ICAO, "J10") -- All SHENYANG J10 fighters

--[[ Legacy Fighters ]]--
or PLANE_ICAO == "F4"   -- F-4 Phantom II
or PLANE_ICAO == "F5"   -- F-5 Tiger II
or PLANE_ICAO == "F8"   -- F-8 Crusader
or PLANE_ICAO == "F19"  -- Fictional fighter
or PLANE_ICAO == "F100" -- F-100 Super Sabre
or PLANE_ICAO == "F102" -- F-102 Delta Dagger
or PLANE_ICAO == "F104" -- F-104 Starfighter
or PLANE_ICAO == "F106" -- F-106 Delta Dart
or PLANE_ICAO == "F117" -- F-117 Nighthawk
or PLANE_ICAO == "TOR"
or string.match(AIRCRAFT_PATH, "Tornado")
or string.match(PLANE_ICAO, "MG2") or string.match(AIRCRAFT_PATH, "MiG%-2") -- MIKOYAN MIG-2x
or string.match(PLANE_ICAO, "MG3") or string.match(AIRCRAFT_PATH, "MiG%-3") -- MIKOYAN MIG-3x
or string.match(PLANE_ICAO, "SB3") -- All Saab fighters

--[[ Bombers / Attack Aircraft ]]--
or PLANE_ICAO == "B2"   -- B-2 Spirit
or PLANE_ICAO == "B21"  -- B-21 Raider
or PLANE_ICAO == "B29"  -- B-29 Superfortress
or PLANE_ICAO == "B52"  -- B-52 Stratofortress
or PLANE_ICAO == "VULC" -- Avro Vulcan
or PLANE_ICAO == "A10"  -- A-10 Thunderbolt II
or PLANE_ICAO == "A4"   -- A-4 Skyhawk
or PLANE_ICAO == "A6"   -- A-6 Intruder
or PLANE_ICAO == "A37"  -- A-37 Dragonfly
or string.match(PLANE_ICAO, "SU1") -- Some SUKHOI SU-2x
or string.match(PLANE_ICAO, "SU2")  or string.match(AIRCRAFT_PATH, "SU%-2") -- SUKHOI SU-2x
or string.match(PLANE_ICAO, "SU3") -- SUKHOI SU-2x
or string.match(PLANE_ICAO, "TU22") -- SUKHOI SU-2x
or PLANE_ICAO == "JH7"  -- Xian JH-7
or PLANE_ICAO == "AMX"  -- AMX International

--[[ Close Air Support / Carrier Ops ]]--
or PLANE_ICAO == "AV8B" -- AV-8B Harrier II
or PLANE_ICAO == "HAR"  -- Harrier variant
or PLANE_ICAO == "V22"  -- V-22 Osprey

--[[ Training Aircraft ]]--
or PLANE_ICAO == "T33"  -- T-33 Shooting Star
or PLANE_ICAO == "HAWK" -- BAE Hawk
or PLANE_ICAO == "M339" -- Aermacchi MB-339
or PLANE_ICAO == "M346" -- Leonardo M-346
or string.match(PLANE_ICAO, "L29") -- Aero L-29 Delfín
or string.match(PLANE_ICAO, "L39") -- Aero L-39 Albatros

--[[ Reconnaissance & Surveillance ]]--
or PLANE_ICAO == "U2"   -- Lockheed U-2
or PLANE_ICAO == "SR71" -- Lockheed SR-71 Blackbird
or PLANE_ICAO == "R135" -- RC-135
or PLANE_ICAO == "C135" -- C-135 variant
or PLANE_ICAO == "W135" -- WC-135

--[[ Tankers & Airborne Early Warning ]]--
or string.match(PLANE_ICAO, "E3") -- All Boeing 	E-3 Sentry variants
or PLANE_ICAO == "E3"   -- Boeing E-3 Sentry
or PLANE_ICAO == "E2"   -- Northrop Grumman E-2 Hawkeye
or PLANE_ICAO == "E737" -- Boeing E-737 AEW&C
or PLANE_ICAO == "E545" -- Embraer E-545 AEW
or PLANE_ICAO == "E550" -- Embraer E-550 AEW
or PLANE_ICAO == "B742" -- Boeing 747-200 (E-4 variant)
or PLANE_ICAO == "K35A" -- KC-135 Stratotanker
or PLANE_ICAO == "K35C" -- KC-135 variant
or PLANE_ICAO == "K35R" -- KC-135 variant
or PLANE_ICAO == "K35E" -- KC-135 variant
or PLANE_ICAO == "K50"  -- KC-50

--[[ Transport & Utility ]]--
or PLANE_ICAO == "C17"  -- Boeing C-17 Globemaster III
or PLANE_ICAO == "C130" -- Lockheed C-130 Hercules
or PLANE_ICAO == "C30J" -- C-130J Super Hercules
or PLANE_ICAO == "L100" -- Civilian C-130 variant
or PLANE_ICAO == "E390" -- Embraer KC-390

--[[ Maritime Patrol & ASW ]]--
or PLANE_ICAO == "P2"   -- Lockheed P-2 Neptune
or PLANE_ICAO == "P3"   -- Lockheed P-3 Orion
or PLANE_ICAO == "P8"   -- Boeing P-8 Poseidon
or string.match(PLANE_ICAO, "S2") -- Grumman S-2 Tracker
or string.match(PLANE_ICAO, "S3") -- Lockheed S-3 Viking

--[[ Drones / UAVs ]]--
or PLANE_ICAO == "Q4"   -- RQ-4 Global Hawk
or string.match(PLANE_ICAO, "Q")  -- Other drones

--[[ Commercial & Civilian Aircraft (Military Paints) ]]--
or PLANE_ICAO == "A319"  -- Airbus A319
or PLANE_ICAO == "B738"  -- Boeing 737-800 (Military livery)
--~ or PLANE_ICAO == "B78M"  -- Boeing 737 MAX (Military livery)
or PLANE_ICAO == "C919" -- COMAC C919 (For fun)
or PLANE_ICAO == "C172" -- COMAC C919 (For testing purpose only)
then								-- Do not edit this line
	-- Activate air refueling		-- Do not edit this line
	sges_ahr = 1				 	-- Do not edit this line
end									-- Do not edit this line
-- https://www.icao.int/publications/doc8643/pages/search.aspx
