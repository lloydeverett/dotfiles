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
    return os.time{ year = year, month = month, day = day, hour = hour, min = min, sec = sec }
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

local function filter(t, fn)
    local ret = {}
    for i, v in ipairs(t) do
        if fn(i, v) then
            ret[i] = v
        end
    end
    for k, v in pairs(t) do
        if fn(k, v) then
            ret[k] = v
        end
    end
    return ret
end

local function pretty_print(x)
    print(serpent.block(x, { comment = false }))
end

local function print_err(str)
    io.stderr:write(str .. "\n")
end

local NEOCRON_DIR_PATH = os.getenv("HOME") .. "/.neocron"
local JOB_DEFS_PATH = NEOCRON_DIR_PATH .. "/jobs.lua"
local LAST_RUN_PATH = NEOCRON_DIR_PATH .. "/last_run"
local MAX_HISTORY_LENGTH = 20
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
    filter = filter,
    pretty_print = pretty_print,
    print_err = print_err,
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

local ERR_GENERAL = 1
local ERR_USAGE = 64
local ERR_INPUT = 66
local USAGE = "usage: neocron [--as-at YYYY-MM-DDTHH:MM:SS] [--help]"

local now_dt = date()
local reading_flag = nil
for _, a in ipairs(arg) do
    if reading_flag ~= nil then
        if reading_flag == "--as-at" then
            local ok, result = pcall(function() return parse_dt(a) end)
            if ok then
                now_dt = result
                reading_flag = nil
            else
                print_err(USAGE)
                os.exit(ERR_USAGE)
            end
        else
            print_err(USAGE)
            os.exit(ERR_USAGE)
        end
    elseif a == "--as-at" then
        reading_flag = "--as-at"
    elseif a == "--help" then
        print(USAGE)
        os.exit(0)
    else
        print(USAGE)
        os.exit(ERR_USAGE)
    end
end
if reading_flag ~= nil then
    print_err(USAGE)
    os.exit(ERR_USAGE)
end
print("[neocron] evaluating as at " .. format_dt(now_dt))

local jobs_load_ok, jobs_load_result = pcall(function ()
    local ok, value = serpent.load(read_to_str(JOB_DEFS_PATH), { safe = false })
    if not ok then
        error("could not deserialize contents of job definitions file")
    end
    return value
end)
if not jobs_load_ok or type(jobs_load_result) ~= "table" then
    print_err("[neocron] " .. jobs_load_result)
    print_err("[neocron] failed to read '" .. JOB_DEFS_PATH .. "'; exiting")
    os.exit(ERR_INPUT)
end
local jobs = jobs_load_result

local last_dts_history = { }
local needs_write = false
local dts_load_ok, dts_load_result = pcall(function ()
    local ok, value = serpent.load(read_to_str(LAST_RUN_PATH), { safe = true })
    if not ok or type(value) ~= "table" then
        error("could not deserialize contents of last run file")
    end
    for _, history_elem in ipairs(value) do
        history_elem[1] = parse_dt(history_elem[1])
        if time(now_dt) <= time(history_elem[1]) then
            print_err("[neocron] there are runs more recent than the as at date " .. format_dt(now_dt) .. "; exiting")
            print_err("[neocron] you may want to adjust or remove '" .. LAST_RUN_PATH .. "' or specify a different --as-at date")
            os.exit(ERR_GENERAL)
        end
    end
    return value
end)
if dts_load_ok then
    last_dts_history = dts_load_result
else
    print_err("[neocron] " .. dts_load_result)
    print_err("[neocron] failed to read '" .. LAST_RUN_PATH .. "'; assuming all jobs were never run before")
    needs_write = true
    local ok, content = pcall(function() return read_to_str(LAST_RUN_PATH) end)
    if ok then
        local backup_path = LAST_RUN_PATH .. "." .. os.date("%Y%m%dT%H%M%S", time(now_dt))
        print_err("[neocron] backing up '" .. LAST_RUN_PATH .. "' to '" .. backup_path .. "'")
        write_to_file(backup_path, content)
    end
end

local last_dts = map(jobs, function(_) return LONG_AGO end)
for i = #last_dts_history, 1, -1 do
    local history_elem = last_dts_history[i]
    local dt = history_elem[1]
    for k, _ in pairs(history_elem) do
        last_dts[k] = dt
    end
end

local jobs_that_ran = { }
for k, j in pairs(jobs) do
    local next_dt_ok, next_dt = pcall(function() return j.next_dt(last_dts[k], k) end)
    if not next_dt_ok then
        print_err("[neocron] " .. k .. " failed due to error:")
        print_err("[neocron] " .. next_dt)
    elseif time(next_dt) <= time(now_dt) then
        print("[neocron] " .. k .. " now starting (prev next = " .. format_dt(last_dts[k]) .. ")")
        local ok, result = pcall(function()
            local ret = j.run(now_dt, k)
            if ret == nil then
                return { }
            else
                return ret
            end
        end)
        if ok then
            print("[neocron] " .. k .. " completed (new next = " .. format_dt(j.next_dt(now_dt)) .. ")")
            last_dts[k] = now_dt
            jobs_that_ran[k] = result
        else
            print_err("[neocron] " .. k .. " failed; not marking as run and will be attempted again on next evaluation")
        end
    else
        print("[neocron] " .. k .. " next runs on " .. format_dt(next_dt))
    end
end

local new_history_elem = clone_table(jobs_that_ran)
new_history_elem[1] = now_dt
table.insert(last_dts_history, 1, new_history_elem)
last_dts_history = { table.unpack(last_dts_history, 1, MAX_HISTORY_LENGTH) }

if needs_write or next(jobs_that_ran) then
    local ser_last_dts_history = map(last_dts_history, function(v)
        local ret = clone_table(v)
        ret[1] = format_dt(ret[1])
        return ret
    end)
    print("[neocron] writing run info to '" .. LAST_RUN_PATH .. "'...")
    print(serpent.block(ser_last_dts_history[1], { comment = false }))
    local output = serpent.block(ser_last_dts_history, { comment = false }) .. "\n"
    write_to_file(LAST_RUN_PATH, output)
end

