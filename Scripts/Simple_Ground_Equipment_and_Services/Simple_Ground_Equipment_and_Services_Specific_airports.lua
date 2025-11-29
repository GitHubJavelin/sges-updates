
-- //////////////////////////////////////////////////// --
-- Airports with specific services
-- //////////////////////////////////////////////////// --

-- This list of airports allows specific services at those places

INTL_AIRPORTS_ICAO_t = {"AYPY";"BGTL";"BIKF";"CYEG";"CYHZ";"CYMX";"CYOW";"CYQB";"CYQM";"CYQR";"CYQX";"CYUL";"CYWG";"CYXE";"CYXY";"PAJN";"CYYJ";"CYYR";"CYYT";"CYYZ";"CYYC";"CYVR";"DAAG";"DFFD";"DIAP";"DNMM";"DRRN";"DTTA";"DTTJ";"EBBR";"EBCI";"EDDB";"EDDC";"EDDF";"EDDH";"EDDM";"EDDN";"EDDP";"EDDS";"EDDV";"EDDW";"EDFH";"EDKH";"EDNY";"EETN";"EFHK";"EGAA";"EGBB";"EGFF";"EGGC";"EGGP";"EGGW";"EGKK";"EGLF";"EGLL";"EGNT";"EGPH";"EGSS";"EIDW";"EINN";"EKBI";"EKCH";"ELLX";"ENBR";"ENGM";"EPGD";"EPMO";"EPPO";"EPWA";"EPWR";"ESGG";"ESSA";"EVRA";"EYSA";"EYVI";"FACT";"FAOR";"FMMI";"GABS";"GBYD";"GMME";"GMMN";"GMMX";"GOBD";"HAAB";"HDAM";"HECA";"HEAZ";"HESH";"HRYR";"LBBG";"LBSF";"LBWN";"LCLK";"LDZA";"LEBL";"LEMD";"LEMG";"LEPA";"LEVC";"LFBO";"LFLL";"LFML";"LFMN";"LFPB";"LFPG";"LFPO";"LFQQ";"LFRN";"LFSB";"LFVP";"LGAV";"LGTL";"LHBP";"LICJ";"LIMC";"LIPE";"LIRF";"LJLJ";"LKPR";"LKPR";"LLBG";"LOWK";"LOWW";"LOWZ";"LPFR";"LPLA";"LPPR";"LPPT";"LROP";"LSGG";"LSZH";"LTAC";"LTAG";"LTAI";"LTFJ";"LTFM";"LUKK";"LUKK";"LYBE";"LZIB";"MMMX";"MMSM";"MMUN";"MPTO";"NTAA";"NWWW";"NZAA";"NZCH";"NZQN";"NZWN";"OEJN";"OEMA";"OEYN";"OIIE";"OJAI";"OKKK";"OLBA";"OMDB";"OPIS";"OPKC";"OSLK";"OTTH";"PANC";"PFYU";"CYDA";"PHNL";"PMDY";"RCKH";"RCTP";"RJAW";"RJBB";"RJCC";"RJCH";"RJGG";"RJOB";"RJSF";"RJTT";"RKJB";"RKNY";"RKPC";"RKPK";"RKSI";"RODN";"RPLL";"SAEZ";"SAME";"SBGL";"SBGR";"SBKP";"SBSP";"SCCI";"SCEL";"SCSN";"SKBO";"SKCL";"SOCA";"SPJC";"SPZO";"TFFF";"TFFR";"UAAA";"UACC";"UBBB";"UGTB";"UHSS";"UHWW";"UIII";"UIII";"UKLL";"UKOH";"UKOO";"ULLI";"ULLI";"URSS";"UTSB";"UUBC";"UUBI";"UUBP";"UUBW";"UUBW";"UUDD";"UUDL";"UUEE";"UUOB";"UUOK";"UUOL";"UUOO";"UUOT";"UUWW";"UUWW";"UUYH";"UUYW";"UUYY";"VAAB";"VDDP";"VECC";"VHHH";"VIDP";"VIJP";"VOCI";"VTBS";"VTSP";"VVNB";"VVTS";"VYYY";"WADD";"WBKK";"WIII";"WSSS";"YBAS";"YBBN";"YBCS";"YMML";"YPAD";"YPDN";"YPPH";"YSCB";"YSSY";"ZBAA";"ZGGG";"ZGHA";"ZGKL";"ZHHH";"ZLLL";"ZMCK";"ZSHC";"ZSNJ";"ZSPD";"ZUCK";"ZUUU";"ZWWW";"ZYHB";"KATL";"KAUS";"KBDL";"KBFI";"KBNA";"KBOS";"KBWI";"KCLT";"KCVG";"KDCA";"KDEN";"KDFW";"KDTW";"KEWR";"KFLL";"KGSO";"KIAD";"KIAH";"KIND";"KJFK";"KLAS";"KLAX";"KLGA";"KLRD";"KMCO";"KMDW";"KMEM";"KMIA";"KMSP";"KOAK";"KONT";"KORD";"KPDX";"KPHL";"KPHX";"KPIT";"KSAN";"KSAT";"KSDF";"KSEA";"KSFO";"KSLC";"KTPA";"TJSJ";"LLER";"OJAQ";"HEGN";"LFMN";"LDDU";}


-- 312 airports were manually curated worldwide. Generally those are international airports, or capital city airports, or airports of international significance, but the list in not exhaustive for airports that fit this category of course.
-- https://skyvector.com/?ll=40.875864502831455,-81.12890624385713&chart=301&zoom=12&fpl=%20LFPG%20AYPY%20BGTL%20BIKF%20CYEG%20CYHZ%20CYMX%20CYOW%20CYQB%20CYQM%20CYQR%20CYQX%20CYUL%20CYWG%20CYXE%20CYXY%20PAJN%20CYYJ%20CYYR%20CYYT%20CYYZ%20CYYC%20CYVR%20DAAG%20DFFD%20DIAP%20DNMM%20DRRN%20DTTA%20DTTJ%20EBBR%20EBCI%20EDDB%20EDDC%20EDDF%20EDDH%20EDDM%20EDDN%20EDDP%20EDDS%20EDDV%20EDDW%20EDFH%20EDKH%20EDNY%20EETN%20EFHK%20EGAA%20EGBB%20EGFF%20EGGP%20EGGW%20EGKK%20EGLF%20EGLL%20EGNT%20EGPH%20EGSS%20EIDW%20EINN%20EKBI%20EKCH%20ELLX%20ENBR%20ENGM%20EPGD%20EPMO%20EPPO%20EPWA%20EPWR%20ESGG%20ESSA%20EVRA%20EYSA%20EYVI%20FACT%20FAOR%20FMMI%20GABS%20GBYD%20GMME%20GMMN%20GMMX%20GOBD%20HAAB%20HDAM%20HECA%20HESH%20HRYR%20LBBG%20LBSF%20LBWN%20LCLK%20LDZA%20LEBL%20LEMD%20LEMG%20LEPA%20LEVC%20LFBO%20LFLL%20LFML%20LFMN%20LFPB%20LFPG%20LFPO%20LFQQ%20LFRN%20LFSB%20LFVP%20LGAV%20LGTL%20LHBP%20LICJ%20LIMC%20LIPE%20LIRF%20LJLJ%20LKPR%20LKPR%20LLBG%20LOWK%20LOWW%20LOWZ%20LPFR%20LPLA%20LPPR%20LPPT%20LROP%20LSGG%20LSZH%20LTAC%20LTAG%20LTAI%20LTFJ%20LTFM%20LUKK%20LUKK%20LYBE%20LZIB%20MMMX%20MMSM%20MMUN%20MPTO%20NTAA%20NWWW%20NZAA%20NZCH%20NZQN%20NZWN%20OEJN%20OEMA%20OEYN%20OIIE%20OJAI%20OKKK%20OLBA%20OMDB%20OPIS%20OPKC%20OSLK%20PANC%20PFYU%20CYDA%20PHNL%20PMDY%20RCKH%20RCTP%20RJAW%20RJBB%20RJCC%20RJCH%20RJGG%20RJOB%20RJSF%20RJTT%20RKJB%20RKNY%20RKPC%20RKPK%20RKSI%20RODN%20RPLL%20SAEZ%20SAME%20SBGL%20SBGR%20SBKP%20SBSP%20SCCI%20SCEL%20SCSN%20SKBO%20SKCL%20SOCA%20SPJC%20SPZO%20TFFF%20TFFR%20UAAA%20UACC%20UBBB%20UGTB%20UHSS%20UHWW%20UIII%20UIII%20UKLL%20UKOH%20UKOO%20ULLI%20ULLI%20URSS%20UTSB%20UUBC%20UUBI%20UUBP%20UUBW%20UUBW%20UUDD%20UUDL%20UUEE%20UUOB%20UUOK%20UUOL%20UUOO%20UUOT%20UUWW%20UUWW%20UUYH%20UUYW%20UUYY%20VECC%20VHHH%20VIDP%20VIJP%20VOCI%20VTBS%20VTSP%20VVNB%20VVTS%20VYYY%20WADD%20WBKK%20WIII%20WSSS%20YBAS%20YBBN%20YBCS%20YMML%20YPAD%20YPDN%20YPPH%20YSCB%20YSSY%20ZBAA%20ZGGG%20ZGHA%20ZGKL%20ZHHH%20ZLLL%20ZMCK%20ZSHC%20ZSNJ%20ZSPD%20ZUCK%20ZUUU%20ZWWW%20ZYHB%20KATL%20KAUS%20KBDL%20KBFI%20KBNA%20KBOS%20KBWI%20KCLT%20KCVG%20KDCA%20KDEN%20KDFW%20KDTW%20KEWR%20KFLL%20KGSO%20KIAD%20KIAH%20KIND%20KJFK%20KLAS%20KLAX%20KLGA%20KLRD%20KMCO%20KMDW%20KMEM%20KMIA%20KMSP%20KOAK%20KONT%20KORD%20KPDX%20KPHL%20KPHX%20KPIT%20KSAN%20KSAT%20KSDF%20KSEA%20KSFO%20KSLC%20KTPA%20TJSJ%20LLER%20OJAQ%20HEGN%20UIII

-- //////////////////////////////////////////////////// --
-- rest of the script is determining if the user aircraft is at one of the airports above

-- //////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////// --

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


-- to store in values of the local nature of the terrain (wet / land)
local terrain_nature = ffi.new("int[1]")

ffi.cdef("void XPLMWorldToLocal(double inLatitude, double inLongitude, double inAltitude, double * outX, double * outY, double * outZ)")



-----------------------------------
-- FIND nearest airport name and location
-----------------------------------

function sges_global_Neareast_Airport()
	local Idling_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
	-- let's examine the name of the airport we found, all variables should be local
	-- we do not waste Lua with variables to avoid conflicts with other scripts
	-- all output we are not interested in can be send to variable _ (a dummy variable)
	local _, airport_x, airport_z, airport_height, _, _, airport_ID, airport_name = XPLMGetNavAidInfo( Idling_airport_index )
	local airport_y = math.floor(airport_height*3.28084) -- meters to feet
	local _,distance_to_airport =	 Marshaller_stand_distance_calc(sges_gs_plane_x[0], sges_gs_plane_z[0], airport_x, airport_z, sges_gs_plane_head[0], 0)
	-- the last step is to create a global variable that function can read out end
	--~ print(string.format("[Ground Equipment " .. version_text_SGES .. "] Near %s (%s ft)", airport_name, airport_y))
	return airport_x, airport_z, airport_y, airport_ID, airport_name, distance_to_airport
end

local sges_nearest_airport_type_execution_time = sges_current_time - 1801

function sges_nearest_airport_type(previous_state,timer,previous_ID)
	if timer > sges_nearest_airport_type_execution_time + 1800 or (previous_ID ~= nil and previous_ID == "ZZZZ") then -- execute only each 30 minutes to let the user fly the aircraft to another destination
		print("[Ground Equipment " .. version_text_SGES .. "] Analyzing the current airport - is it a Capital City airport ?") -- (at time " .. timer .. ")")
		sges_nearest_airport_type_execution_time = timer
		local big_airport = false
		local _, _, _, airport_ID, _, _ = sges_global_Neareast_Airport()
		-- compare the airport ID to our specific list.
		for index,value in pairs(INTL_AIRPORTS_ICAO_t) do
			value = 	tostring(INTL_AIRPORTS_ICAO_t[index])
			if value == airport_ID then big_airport = true break end
		end
		--~ if big_airport then print("Nearest : " .. airport_ID .. " is big.") end
		if big_airport then print("[Ground Equipment " .. version_text_SGES .. "]                                                                Yes       " .. airport_ID) else
			print("[Ground Equipment " .. version_text_SGES .. "]                                                                No       " .. airport_ID)
		 end
		return big_airport,airport_ID
	else
		--~ print("[Ground Equipment " .. version_text_SGES .. "] We already searched very recently if " .. previous_ID .. " is a major airport. The answer was : " .. tostring(previous_state))
		return previous_state,previous_ID
	end
end
