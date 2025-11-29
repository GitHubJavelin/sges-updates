
-- //////////////////////////////////////////////////// --
-- Exclude Aircraft types for SGES
-- //////////////////////////////////////////////////// --

-- This list allows aircraft to raise a red flag : ie, do NOT activate SGES

PLANE_ICAO_exclusions_t = {"JohnDoe", "JohnDeere", "JohnDue", "JohnDie", "JohnDae"}

-- Please replace the values by your aircraft PLANE_ICAO code
-- For instance "BE76" is PLANE_ICAO for the Beechcraft Duchess Model 76
--PLANE_ICAO_exclusions_t = {"BE76", "JohnDeere", "JohnDue", "JohnDie", "JohnDae"}

-- the maximum size of this table is 5, so please only replace the temporary data
-- but do not expand the table. You can disable SGES for 5 aircraft types at max.

-- To obtain the PLANE_ICAO value go to Plugins -> FlyWithLua -> Macros -> Enter
-- a line of code -> type "PLANE_ICAO" in the bottom bar.
