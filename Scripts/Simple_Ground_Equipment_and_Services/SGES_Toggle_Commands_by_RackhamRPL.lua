--------------------------------------------------------------------------------
-- SGES_Toggle_Commands.lua
-- Toggle commands for Simple Ground Equipment & Services
-- Must be loaded AFTER SGES (via FlyWithLua)
-- By RackhamRPL 31/05/2026
--------------------------------------------------------------------------------
-- Requires: Simple_Ground_Equipment_and_Services.lua loaded first
--------------------------------------------------------------------------------

-- Register all toggle commands once SGES is ready
function register_SGES_toggle_commands()

    -- -------------------------------------------------------------------------
    -- GPU — Ground Power Unit
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/GPU",
        "SGES: Toggle GPU (ground power unit) - generic (Use the GUI for tailored interactions).",
        [[
            show_GPU = not show_GPU
            GPU_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- ASU / ACU — Air Start Unit / Air Conditioning Unit
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/ASU",
        "SGES: Toggle ASU / ACU - generic (Use the GUI for tailored interactions)",
        [[
            show_ASU = not show_ASU
            show_ACU = show_ASU
            ASU_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Stairs Mark I — classic SGES stairs
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/Stairs",
        "SGES: Toggle Stairs Mark I",
        [[
            show_Stairs = not show_Stairs
            Stairs_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Stairs Mark III (XPJ) — forward stairs, ToLiss / pax aircraft
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/StairsXPJ",
        "SGES: Toggle Stairs Mark III (XPJ forward)",
        [[
            show_StairsXPJ = not show_StairsXPJ
            StairsXPJ_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Stairs Mark IV (XPJ2) — aft / service stairs
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/StairsXPJ2",
        "SGES: Toggle Stairs Mark IV (XPJ aft)",
        [[
            show_StairsXPJ2 = not show_StairsXPJ2
            StairsXPJ2_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Stairs Mark V (XPJ3) — third stairset
    -- -------------------------------------------------------------------------
    --~ create_command(
        --~ "Simple_Ground_Equipment_and_Services/Toggle/StairsXPJ3",
        --~ "SGES: Toggle Stairs Mark V (XPJ3)",
        --~ [[
            --~ show_StairsXPJ3 = not show_StairsXPJ3
            --~ StairsXPJ3_chg = true
        --~ ]],
        --~ "", ""
    --~ )

    -- -------------------------------------------------------------------------
    -- Pushback tug
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/PB",
        "SGES: Toggle Pushback tug",
        [[
            show_PB = not show_PB
            PB_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Cargo Ops — Cart + BeltLoader + RearBeltLoader + Baggage
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/CargoOps",
        "SGES: Toggle cargo ops (Cart + Belt loaders + Baggage)",
        [[
            if show_Cart then
                show_Cart           = false
                show_BeltLoader     = false
                show_RearBeltLoader = false
            else
                show_Cart           = true
                show_BeltLoader     = true
                show_RearBeltLoader = true
            end
            Cart_chg           = true
            BeltLoader_chg     = true
            RearBeltLoader_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Passenger bus
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/Bus",
        "SGES: Toggle passenger bus",
        [[
            show_Bus = not show_Bus
            Bus_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Catering truck
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/Catering",
        "SGES: Toggle catering truck",
        [[
            show_Catering = not show_Catering
            Catering_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Fuel truck / hydrant
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/FUEL",
        "SGES: Toggle fuel truck / hydrant",
        [[
            show_FUEL = not show_FUEL
            FUEL_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- De-icing truck
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/Deice",
        "SGES: Toggle de-icing truck",
        [[
            show_Deice = not show_Deice
            Deice_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- PRM — reduced mobility vehicle
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/PRM",
        "SGES: Toggle PRM vehicle (reduced mobility)",
        [[
            show_PRM = not show_PRM
            PRM_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Follow-me car
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/FM",
        "SGES: Toggle follow-me car",
        [[
            show_FM = not show_FM
            FM_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Fire / EMS vehicle
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/FireVehicle",
        "SGES: Toggle EMS / fire vehicle",
        [[
            show_FireVehicle = not show_FireVehicle
            FireVehicle_chg = true
        ]],
        "", ""
    )

    -- -------------------------------------------------------------------------
    -- Remove All — dismiss every ground service at once
    -- -------------------------------------------------------------------------
    create_command(
        "Simple_Ground_Equipment_and_Services/Toggle/RemoveAll",
        "SGES: Remove all ground services",
        [[
            show_GPU            = false   ; GPU_chg            = true
            show_ASU            = false   ; show_ACU = false
                                          ; ASU_chg            = true
            show_Stairs         = false   ; Stairs_chg         = true
            show_StairsXPJ      = false   ; StairsXPJ_chg      = true
            show_StairsXPJ2     = false   ; StairsXPJ2_chg     = true
            show_StairsXPJ3     = false   ; StairsXPJ3_chg     = true
            show_PB             = false   ; PB_chg             = true
            show_Cart           = false   ; Cart_chg           = true
            show_BeltLoader     = false   ; BeltLoader_chg     = true
            show_RearBeltLoader = false   ; RearBeltLoader_chg = true
            show_Bus            = false   ; Bus_chg            = true
            show_Catering       = false   ; Catering_chg       = true
            show_FUEL           = false   ; FUEL_chg           = true
            show_Deice          = false   ; Deice_chg          = true
            show_PRM            = false   ; PRM_chg            = true
            show_FM             = false   ; FM_chg             = true
            show_FireVehicle    = false   ; FireVehicle_chg    = true
        ]],
        "", ""
    )

    --~ print("[SGES Toggle] Commands registered.")
	print("[Ground Equipment " .. version_text_SGES .. "][SGES Toggle by RackhamRPL]  Commands registered.")
end
