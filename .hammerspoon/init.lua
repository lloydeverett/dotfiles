
require("hs.ipc")

local eventtap = hs.eventtap
local eventTypes = eventtap.event.types
local recording = nil

function new_window(app_name)
    local app = hs.appfinder.appFromName(app_name)
    if app then
        hs.eventtap.keyStroke({"cmd"}, "N", 100000, app)
    else
        hs.application.launchOrFocus(app_name)
    end
end

function print_table(t, level)
  level = level or 0
  for key, value in pairs(t) do
    local indent = string.rep("\t", level)
    if type(value) == "table" then
      print(indent .. "[" .. tostring(key) .. "] = {")
      print_table(value, level + 1)
      print(indent .. "}")
    else
      print(indent .. "[" .. tostring(key) .. "] = " .. tostring(value))
    end
  end
end

function flags_to_str(t)
    local ret = ''
    for key, value in pairs(t) do
        if value then
            ret = ret .. key .. ','
        end
    end
    return ret
end

function sdbm_hash(str)
  local hash = 0 for i = 1, #str do
    hash = string.byte(str, i) + (hash << 6) + (hash << 16) - hash
  end
  return hash
end

local keyTap = eventtap.new({eventTypes.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local characters = event:getCharacters()
    local flags = event:getFlags()
    -- print("Key pressed:", sdbm_hash(characters), "Key code:", keyCode)
    recording = recording .. flags_to_str(flags) .. keyCode .. ';'
    return false -- returning false lets the event propagate normally
end)

function record()
    if recording == nil then
        recording = ""
        keyTap:start()
    else
        error("record called, but recording already in progress")
    end
end

function record_done()
    if recording ~= nil then
        keyTap:stop()
        local ret = recording
        recording = nil
        return ret
    else
        error("record_done called, but no recording in progress")
    end
end

