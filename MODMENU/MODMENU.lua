local string = require("string")
local os = require("os")
local md5 = require("md5")
local hwid = 0

function generateHWID()
    local getInfo = tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION"))
    return md5.sumhexa(getInfo)
end

function readSavedHWID()
    local filePath = getMoonloaderFolderPath() .. "\\config\\hwid.txt"
    local file = io.open(filePath, "r")

    if file then
        local savedHWID = file:read("*all")
        file:close()
        return savedHWID
    else
        return nil
    end
end

function writeHWIDToFile(hwid)
    local filePath = getMoonloaderFolderPath() .. "\\config\\hwid.txt"
    local file = io.open(filePath, "w")
    
    if file then
        file:write(hwid)
        file:close()
    else
        print("Error writing to file.")
    end
end

function getMoonloaderFolderPath()
    local scriptPath = debug.getinfo(1).source:match("@(.*)\\")
    return scriptPath
end

function main()
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage('ola', -1)

    local savedHWID = readSavedHWID()

    if not savedHWID then
        local currentHWID = generateHWID()
        writeHWIDToFile(currentHWID)
        print("First run. HWID saved.")
    else
        local currentHWID = generateHWID()

        if savedHWID ~= currentHWID then
            print("HWID mismatch! Script will exit.")
            return
        end
    end

    while true do
        wait(0)
    end
end