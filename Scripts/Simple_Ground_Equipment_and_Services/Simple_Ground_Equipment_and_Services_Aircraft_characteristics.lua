-- this subscript offers a quick briefing in game of the current aircraft reference speeds and then suggest climb and approach speeds

if sges_acf_Vso == nil then	sges_acf_Vso = dataref_table("sim/aircraft/view/acf_Vso") end -- kias  Various speed maxima for the aircraft.
if sges_acf_Vs  == nil then	sges_acf_Vs = dataref_table("sim/aircraft/view/acf_Vs") end
if sges_acf_Vfe == nil then	sges_acf_Vfe = dataref_table("sim/aircraft/view/acf_Vfe") end  -- kias	Vfe describes the aircrafts max speed with full flaps extended.
if sges_acf_Vno == nil then	sges_acf_Vno = dataref_table("sim/aircraft/view/acf_Vno") end -- kias	Maximum structural cruising speed, not to be exceeded except in smooth air
if sges_acf_Vne == nil then	sges_acf_Vne = dataref_table("sim/aircraft/view/acf_Vne") end -- kias	Vne is the never exceed (redline) speed

-- VLE, or Maximum Landing Gear Extended Speed, is the highest speed at which an aircraft can safely fly with the landing gear extended. On the other hand, VLO, or Maximum Landing Gear Operating Speed, is the top speed at which you can safely extend or retract the landing gear.

--~ Désignation	Description
--~ VP	Vitesse propre - Corrigée des écarts atmosphériques
--~ Vi	Vitesse indiquée - Lue à l'anémomètre
--~ VR	Vitesse de rotation – Pour les avions monomoteur, VR ne doit pas être > à VS1
--~ VS1	Vitesse de décrochage dans une configuration spécifique
--~ VS0	Vitesse de décrochage en configuration atterrissage
--~ VFE	Vitesse maximale pour la manœuvre et l'utilisation des dispositifs hypersustentateurs
--~ VLO	Vitesse maximale d'ouverture et de fermeture du train d'atterrissage
--~ VLE	Vitesse maximale trains sortis verrouillés
--~ VA	Vitesse maximale d'évolution avec débattement maximale des commandes de vol
--~ VNO	Vitesse maximale structurale en croisière (Normal Operating Speed)
--~ VNE	Vitesse à ne jamais dépasser (Velocity Never Exceed)
--~ VZ	Vitesse verticale
--~ VX	Vitesse du meilleur angle de montée – Pente max
--~ VXSE	Vitesse du meilleur angle de montée sur un seul moteur (multimoteur)
--~ VY	Vitesse du meilleur taux de montée – VZ max
--~ VYSE	Vitesse du meilleur taux de montée sur un seul moteur (multimoteur)
--~ VMC	Vitesse minimale de contrôle au décollage, ne doit pas être inférieure à 1,2 de la VS
--~ VMCG	Vitesse minimale de contrôle au sol
--~ VMCA	Vitesse minimale de contrôle en vol
--~ VMCL	Vitesse minimale de contrôle durant l'approche
--~ VD	Vitesse en piqué

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local rounding_param = 0
local ref_vs = "Vs"
if sges_acf_Vso[0] > 0 then reference_stall_speed = sges_acf_Vso[0]  ref_vs = "Vs0" else reference_stall_speed = sges_acf_Vs[0] ref_vs = "Vs1" end

local sges_base_turn_speed = round(((1.45 * reference_stall_speed) + 10), -1)  -- 58 + 10 = 68 -> round -> 70 (C172S)
local sges_final_rwy_speed = round(((1.30 * reference_stall_speed) + 10), -1)  -- 52 + 10 = 62 -> round -> 60 (C172S)
local sges_touchdown_speed = round(((1.10 * reference_stall_speed) +  0),  0)
local sges_Vrotation_speed = round(((1.10 * sges_acf_Vs[0]       ) +  0),  0)
local sges_ini_climb_speed = round(((1.45 * reference_stall_speed) + 10), -1)
local sges_climb_out_speed = round(((1.75 * reference_stall_speed) + 10), -1)

if sges_Vrotation_speed > sges_ini_climb_speed + 50 then -- F104 COLIMATA
	sges_Vrotation_speed = round(((1.10 * sges_acf_Vso[0]       ) +  10), -1)
	sges_Vrotation_speed = "(with flaps) " .. sges_Vrotation_speed
end


sges_flight_profile = " == " .. PLANE_ICAO .. " by " .. SGES_Author .. " ==\n\nRotate at " .. sges_Vrotation_speed .. " KIAS,\ninitial climb around " .. sges_ini_climb_speed .. " KIAS\nthen climb at " .. sges_climb_out_speed .. " KIAS. \n\nBase leg at " .. sges_base_turn_speed .. " KIAS, \nfinal descent at " .. sges_final_rwy_speed .. " KIAS,\ntouchdown toward " .. sges_touchdown_speed .. " KIAS,\n(when reference is " .. ref_vs .. ").\n\nSuggestion for flight simulation only. MTOW, SL assumed with margins. Always consult the POH, the checklist for guidelines."

print(sges_flight_profile)
