#!/usr/bin/env lua

local serpent = require("serpent")

local function date(t)
    return os.date("*t", t)
end

local function time(dt)
    return os.time(dt)
end

local function format_t(t)
    return os.date("%Y-%m-%dT%H:%M:%S", t)
end

local function format_dt(dt)
    return format_t(time(dt))
end

local function parse_t(str)
    local year, month, day, hour, min, sec = str:match("(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
    return os.time{ year=year, month=month, day=day, hour=hour, min=min, sec=sec }
end

local function parse_dt(str)
    return date(parse_t(str))
end

local function plus_days(dt, days)
    return date(time(dt) + (days * 24 * 60 * 60))
end

local function clone_table(t, alterations)
    local ret = {}
    for i, v in ipairs(t) do
        ret[i] = v
    end
    for k, v in pairs(t) do
        ret[k] = v
    end
    if alterations ~= nil then
        for i, v in ipairs(alterations) do
            ret[i] = v
        end
        for k, v in pairs(alterations) do
            ret[k] = v
        end
    end
    return ret
end

local function map(t, fn)
    local ret = {}
    for i, v in ipairs(t) do
        ret[i] = fn(v)
    end
    for k, v in pairs(t) do
        ret[k] = fn(v)
    end
    return ret
end

local function pretty_print(x)
    print(serpent.block(x, { comment = false }))
end

local NEOCRON_DIR_PATH = os.getenv("HOME") .. "/.neocron"
local JOB_DEFS_PATH = NEOCRON_DIR_PATH .. "/jobs.lua"
local LAST_RUN_PATH = NEOCRON_DIR_PATH .. "/last_run"
local MAX_HISTORY_LENGTH = 2 -- 20
local LONG_AGO = date(time({ year = 1970, month = 1, day = 1, hour = 0, min = 0, sec = 0 }))

-- global exports to allow access from within job definitions
G = {
    date = date,
    time = time,
    parse_t = parse_t,
    parse_dt = parse_dt,
    format_t = format_t,
    format_dt = format_dt,
    plus_days = plus_days,
    clone_table = clone_table,
    map = map,
    pretty_print = pretty_print,
    NEOCRON_DIR_PATH = NEOCRON_DIR_PATH,
    JOB_DEFS_PATH = JOB_DEFS_PATH,
    LAST_RUN_PATH = LAST_RUN_PATH,
    LONG_AGO = LONG_AGO,
}

local function read_to_str(filename)
    local file = io.open(filename, "r")
    if file == nil then
        error("file '" .. filename .. "' not found")
    end
    local content = file:read("*all")
    file:close()
    return content
end

local function write_to_file(filename, content)
    local file = io.open(filename, "w")
    if not file then
        error("could not open file '" .. filename .. "' for write")
    end
    file:write(content)
    file:close()
end

local jobs_load_ok, jobs_load_result = pcall(function ()
    local ok, value = serpent.load(read_to_str(JOB_DEFS_PATH), { safe = false })
    if not ok then
        error("could not deserialize contents of job definitions file")
    end
    return value
end)
if not jobs_load_ok or type(jobs_load_result) ~= "table" then
    io.stderr:write("[neocron] " .. jobs_load_result .. "\n")
    io.stderr:write("[neocron] failed to read '" .. JOB_DEFS_PATH .. "'; exiting\n")
    os.exit(1)
end
local jobs = jobs_load_result

local default_last_dts = map(jobs, function(_) return LONG_AGO end)
local last_dts
local last_dts_history
local dts_load_ok, dts_load_result = pcall(function ()
    local ok, value = serpent.load(read_to_str(LAST_RUN_PATH), { safe = true })
    if not ok then
        error("could not deserialize contents of last run file")
    end
    return map(value, function(dts)
        return map(dts, parse_dt)
    end)
end)
if dts_load_ok then
    last_dts_history = dts_load_result
    last_dts = clone_table(default_last_dts, last_dts_history[1])
else
    io.stderr:write("[neocron] " .. dts_load_result .. "\n")
    io.stderr:write("[neocron] failed to read '" .. LAST_RUN_PATH .. "'; assuming all jobs were never run before\n")
    last_dts = clone_table(default_last_dts)
    last_dts_history = { }
end

local now_dt = date()
last_dts[1] = now_dt
local something_ran = false
for k, j in pairs(jobs) do
    local next_dt = j.next_dt(last_dts[k], k)
    if time(next_dt) <= time(now_dt) then
        print("[neocron] " .. k .. " now starting (prev next = " .. format_dt(last_dts[k]) ..
                                      ", now = " .. format_dt(now_dt) ..
                                      ", new next = " .. format_dt(j.next_dt(now_dt)) .. ")")
        j.run(now_dt, k)
        print("[neocron] " .. k .. " completed")
        last_dts[k] = now_dt
        something_ran = true
    else
        print("[neocron] " .. k .. " next runs on " .. format_dt(next_dt))
    end
end

--  TODO: Output should look like:
--        {
--            "2025-10-20T08:17:03",
--            menubar_tint = {} -- meta output from run
--        },
--        {
--            "2025-10-20T08:17:03",
--            memelord = {} -- meta output from run
--        }
--        Obtain last_dts by aggregating this on load.

table.insert(last_dts_history, 1, last_dts)
last_dts_history = { table.unpack(last_dts_history, 1, MAX_HISTORY_LENGTH) }

if something_ran then
    print("[neocron] writing run info to '" .. LAST_RUN_PATH .. "'...")
    print(serpent.block(map(last_dts_history[1], format_dt), { comment = false }))
    local output = map(last_dts_history, function(dts)
        return map(dts, format_dt)
    end)
    write_to_file(LAST_RUN_PATH, serpent.block(output, { comment = false }))
end

