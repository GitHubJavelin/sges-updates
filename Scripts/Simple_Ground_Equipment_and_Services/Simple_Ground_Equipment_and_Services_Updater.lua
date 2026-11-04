--------------------------------------------------
-- SGES_Updater.lua
--------------------------------------------------

if type(SGESUpdater) == "table" then
    return
end

SGESUpdater = {}

--------------------------------------------------
-- CONFIG
--------------------------------------------------

SGESUpdater.BaseURL =
"https://tempo"

SGESUpdater.UpdateAvailable = false
SGESUpdater.FilesToUpdate = {}
SGESUpdater.OnceFiles = {}


command_once("sim/operation/dev_console")

--------------------------------------------------
-- UTILS
--------------------------------------------------

local separator = package.config:sub(1,1)

--------------------------------------------------
-- FILE EXISTS
--------------------------------------------------

function SGESUpdater.FileExists(path)

    local f = io.open(path, "rb")

    if f then
        f:close()
        return true
    end

    return false

end

--------------------------------------------------
-- FILE SIZE
--------------------------------------------------

function SGESUpdater.GetFileSize(path)

    local f = io.open(path, "rb")

    if not f then
        return nil
    end

    local size = f:seek("end")

    f:close()

    return size

end

--------------------------------------------------
-- DOWNLOAD
--------------------------------------------------

function SGESUpdater.Download(url, destination)

    local cmd =
        'curl -L -s "' ..
        url ..
        '" -o "' ..
        destination ..
        '"'

    --~ print("[SGES Updater] " .. cmd)

    return os.execute(cmd)

end

--------------------------------------------------
-- CREATE DIRECTORY
--------------------------------------------------

function SGESUpdater.MakePath(path)

    local dir = path:match("^(.*)[/\\]")

    if not dir then
        return
    end

    if separator == "\\" then

        os.execute(
            'if not exist "' ..
            dir ..
            '" mkdir "' ..
            dir ..
            '"'
        )

    else

        os.execute(
            'mkdir -p "' ..
            dir ..
            '"'
        )

    end

end

--------------------------------------------------
-- LOAD ONCELIST
--------------------------------------------------

function SGESUpdater.LoadOnceList(file)

    SGESUpdater.OnceFiles = {}

    if not SGESUpdater.FileExists(file) then
        return
    end

    for line in io.lines(file) do

        line = line:gsub("^%s+", "")
        line = line:gsub("%s+$", "")

        if line ~= "" then
            SGESUpdater.OnceFiles[line] = true
        end

    end

end


--------------------------------------------------
-- CHECK FOR UPDATES
--------------------------------------------------

function SGESUpdater.CheckForUpdates(URL)


    SGESUpdater.BaseURL = URL

    print("[SGES Updater] Checking updates at " .. SGESUpdater.BaseURL)

    SGESUpdater.UpdateAvailable = false
    SGESUpdater.FilesToUpdate = {}

    local tmp_sizes =
        SCRIPT_DIRECTORY ..
        "Simple_Ground_Equipment_and_Services/Updater/updater_sizeslist.txt"

    local tmp_once =
        SCRIPT_DIRECTORY ..
        "Simple_Ground_Equipment_and_Services/Updater/updater_oncelist.txt"

    --------------------------------------------------
    -- DOWNLOAD FILES
    --------------------------------------------------


    SGESUpdater.Download(
        SGESUpdater.BaseURL ..
        "/skunkcrafts_updater_sizeslist.txt",
        tmp_sizes
    )

    SGESUpdater.Download(
        SGESUpdater.BaseURL ..
        "/skunkcrafts_updater_oncelist.txt",
        tmp_once
    )


    --------------------------------------------------
    -- LOAD ONCELIST
    --------------------------------------------------

    SGESUpdater.LoadOnceList(tmp_once)

    --------------------------------------------------
    -- COMPARE FILES
    --------------------------------------------------

    for line in io.lines(tmp_sizes) do

        local filepath, remotesize =
            line:match("(.+)|(%d+)")

        local localpath =
            SCRIPT_DIRECTORY .. filepath:gsub("^Scripts/","")

        if localpath then

            local localsize =
                SGESUpdater.GetFileSize(localpath)

            if localsize == nil then
                print("NOT FOUND : "..localpath)
            end
            --------------------------------------------------
            -- ONCELIST
            --------------------------------------------------

            if SGESUpdater.OnceFiles[filepath] then

                if not SGESUpdater.FileExists(localpath) then

                    table.insert(
                        SGESUpdater.FilesToUpdate,
                        {
                            remote = filepath,
                            localfile = localpath
                        }
                    )
                    
                else
                    print("Already exists (never updated) : "..localpath:match("([^/\\]+)$"))
                end

            --------------------------------------------------
            -- NORMAL FILE
            --------------------------------------------------

            else

                if localsize == nil or
                   tonumber(localsize) ~= tonumber(remotesize)
                then

                    table.insert(
                        SGESUpdater.FilesToUpdate,
                        {
                            remote = filepath,
                            localfile = localpath
                        }
                    )
                    --~ print("TO UPDATE : "..localpath)

                end

            end
        end
    end

    --------------------------------------------------

    SGESUpdater.UpdateAvailable =
        (#SGESUpdater.FilesToUpdate > 0)

    print(
        "[SGES Updater] " ..
        tostring(#SGESUpdater.FilesToUpdate) ..
        " files need update"
    )

    --~ for _,f in ipairs(SGESUpdater.FilesToUpdate) do
        --~ print(f)
    --~ end
    for _,f in ipairs(SGESUpdater.FilesToUpdate) do
        print(f.remote)
    end
    
    return SGESUpdater.UpdateAvailable

end

--------------------------------------------------
-- BACKUP FILE
--------------------------------------------------

function SGESUpdater.BackupFile(path)

    if not SGESUpdater.FileExists(path) then
        return
    end

    local backup = path .. ".bak"

    if separator == "\\" then

        os.execute(
            'copy /Y "' ..
            path ..
            '" "' ..
            backup ..
            '"'
        )

    else

        os.execute(
            'cp "' ..
            path ..
            '" "' ..
            backup ..
            '"'
        )

    end

end

--------------------------------------------------
-- INSTALL UPDATES
--------------------------------------------------

function SGESUpdater.InstallUpdates()


    print("[SGES Updater] installing updates")

    for _,f in ipairs(SGESUpdater.FilesToUpdate) do

        SGESUpdater.MakePath(f.localfile)

        SGESUpdater.BackupFile(f.localfile)

        local url =
            SGESUpdater.BaseURL ..
            "/" ..
            f.remote

        print("URL      : "..url)
        print("LOCAL    : "..f.localfile)

        SGESUpdater.Download(
            url,
            f.localfile
        )

    end
    print("[SGES Updater] updates installed !")
    SGESUpdater.UpdateAvailable = false
    
    return SGESUpdater.UpdateAvailable
end

--------------------------------------------------
-- STATUS
--------------------------------------------------

function SGESUpdater.GetStatus()

    return {

        update_available =
            SGESUpdater.UpdateAvailable,

        file_count =
            #SGESUpdater.FilesToUpdate,

        files =
            SGESUpdater.FilesToUpdate

    }

end

--------------------------------------------------
-- COMPATIBILITE
--------------------------------------------------

function SGESUpdater_Check()

    return SGESUpdater.CheckForUpdates()

end

function SGESUpdater_Install()

    return SGESUpdater.InstallUpdates()

end
