if not SUPPORTS_FLOATING_WINDOWS then
    logMsg("Floating windows are not supported by your FlyWithLua version.")
    return
end

function create_VR_GUI()
	-- Création d'une nouvelle fenêtre flottante
	local SGES_vr_Window = float_wnd_create(350, 700, 1, true)
	if SGES_vr_Window then
		time_opening_groundservices_float_wnd = SGES_total_flight_time_sec
		float_wnd_set_title(SGES_vr_Window, "SGES : Hello, VR World!")
		--~ float_wnd_set_position(SGES_vr_Window, 100, 100)
		float_wnd_set_imgui_builder(SGES_vr_Window, "build_windoz")
		--~ float_wnd_set_vr(SGES_vr_Window, true)
	else
		logMsg("Failed to create floating window.")
	end
end
