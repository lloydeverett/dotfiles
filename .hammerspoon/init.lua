require("hs.ipc")
require("hs.eventtap")
require("hs.hotkey")
require("hs.alert")
require("hs.pasteboard")

local eventtap = hs.eventtap
local eventTypes = eventtap.event.types

--- begin boilerplate util methods

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

function sdbm_hash(str)
  local hash = 0 for i = 1, #str do
    hash = string.byte(str, i) + (hash << 6) + (hash << 16) - hash
  end
  return hash
end

--- end boilerplate util methods

--- begin app launching

function new_window(app_name)
    local app = hs.appfinder.appFromName(app_name)
    if app then
        hs.eventtap.keyStroke({"cmd"}, "N", 100000, app)
    else
        hs.application.launchOrFocus(app_name)
    end
end

--- end app launching

--- begin macros

local recording = nil

local keyMap = {
    [12] = 'q', ['q'] = 12, ['Q'] = 12,
    [13] = 'w', ['w'] = 13, ['W'] = 13,
    [14] = 'e', ['e'] = 14, ['E'] = 14,
    [15] = 'r', ['r'] = 15, ['R'] = 15,
    [17] = 't', ['t'] = 17, ['T'] = 17,
    [16] = 'y', ['y'] = 16, ['Y'] = 16,
    [32] = 'u', ['u'] = 32, ['U'] = 32,
    [34] = 'i', ['i'] = 34, ['I'] = 34,
    [31] = 'o', ['o'] = 31, ['O'] = 31,
    [35] = 'p', ['p'] = 35, ['P'] = 35,
    [ 0] = 'a', ['a'] =  0, ['A'] =  0,
    [ 1] = 's', ['s'] =  1, ['S'] =  1,
    [ 2] = 'd', ['d'] =  2, ['D'] =  2,
    [ 3] = 'f', ['f'] =  3, ['F'] =  3,
    [ 5] = 'g', ['g'] =  5, ['G'] =  5,
    [ 4] = 'h', ['h'] =  4, ['H'] =  4,
    [38] = 'j', ['j'] = 38, ['J'] = 38,
    [40] = 'k', ['k'] = 40, ['K'] = 40,
    [37] = 'l', ['l'] = 37, ['L'] = 37,
    [ 6] = 'z', ['z'] =  6, ['Z'] =  6,
    [ 7] = 'x', ['x'] =  7, ['X'] =  7,
    [ 8] = 'c', ['c'] =  8, ['C'] =  8,
    [ 9] = 'v', ['v'] =  9, ['V'] =  9,
    [11] = 'b', ['b'] = 11, ['B'] = 11,
    [45] = 'n', ['n'] = 45, ['N'] = 45,
    [46] = 'm', ['m'] = 46, ['M'] = 46,
    [18] = '1', ['1'] = 18,
    [19] = '2', ['2'] = 19,
    [20] = '3', ['3'] = 20,
    [21] = '4', ['4'] = 21,
    [23] = '5', ['5'] = 23,
    [22] = '6', ['6'] = 22,
    [26] = '7', ['7'] = 26,
    [28] = '8', ['8'] = 28,
    [25] = '9', ['9'] = 25,
    [29] = '0', ['0'] = 29,
}

function flags_to_str(t)
    local ret = ''
    for key, value in pairs(t) do
        if value then
            ret = ret .. key .. '+'
        end
    end
    return ret
end

local keyTap = eventtap.new({eventTypes.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local characters = event:getCharacters()
    local flags = flags_to_str(event:getFlags())
    if flags ~= '' then
        recording = recording .. '^' .. flags
    end
    if keyMap[keyCode] then
        recording = recording .. keyMap[keyCode]
    else
        recording = recording .. '[' .. keyCode .. ']'
    end
    if flags ~= '' then
        recording = recording .. ';'
    end
    return false -- returning false lets the event propagate normally
end)

function record()
    if recording == nil then
        recording = ";;;"
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

function parse(str, emit_function_outer)
    local i = 1

    local consume_keycode_literal = function(seen_char, emit_function)
        assert(seen_char == '[', "consume_keycode_literal called with seen_char != '['")
        local first = i - 1
        while i <= #str do
            local c = str:sub(i, i); i = i + 1
            if c == ']' then
                local last = i - 1
                local value = tonumber(str:sub(first + 1, last - 1))
                if value == nil then
                    error("parse failed: [ sequence beginning at character " .. first .. " contains non-numeric digits")
                end
                emit_function({
                    ['keycode'] = value
                })
                return
            end
        end
        error("parse failed: unterminated [ sequence beginning at character " .. first)
    end

    local consume_key = function(seen_char, emit_function)
        if seen_char == '[' then
            consume_keycode_literal('[', emit_function)
        elseif keyMap[seen_char] then
            emit_function({
                ['keycode'] = keyMap[seen_char]
            })
        else
            error("parse failed: unexpected character " .. seen_char .. " (ordinal: " .. string.byte(seen_char) .. ")")
        end
    end

    local consume_modifier_sequence = function(seen_char, emit_function)
        assert(seen_char == '^', "consume_modifier_sequence called with seen_char != '^'")
        local first = i - 1

        -- consume flags
        local flags = {
            ['shift'] = false,
            ['ctrl'] = false,
            ['alt'] = false,
            ['cmd'] = false,
        }
        local flag_pattern = "^(%a+)%+"
        local flag_match = string.match(str, flag_pattern, i)
        if flag_match == nil then
            error("parse failed: ^ sequence beginning at character " .. first .. " does not begin with a modifier (e.g. 'shift+')")
        end
        while flag_match ~= nil do
            if flags[flag_match] == nil then
                error('parse failed: unknown flag ' .. flag_match)
            end
            if flags[flag_match] == true then
                error('parse failed: flag ' .. flag_match .. ' repeated in the same ^ sequence')
            end
            assert(flags[flag_match] == false, 'consume_modifier_sequence has unexpected value in flags table')
            flags[flag_match] = true
            i = i + #flag_match + 1 -- add one to skip past +
            flag_match = string.match(str, flag_pattern, i)
        end

        -- consume key
        if i > #str then
            error("parse failed: reached end of input before finding key for ^ sequence beginning at character " .. first)
        end
        local c = str:sub(i, i); i = i + 1
        local consume_key_emit_function = function(production)
            modifiers = {}
            for key, value in pairs(flags) do
                if value == true then
                    table.insert(modifiers, key)
                end
            end
            production["modifiers"] = modifiers
            emit_function(production)
        end
        consume_key(c, consume_key_emit_function)

        -- consume ';'
        if i > #str then
            error("parse failed: expected terminating ; at the end of ^ sequence but reached end of input")
        end
        c = str:sub(i, i); i = i + 1
        if c ~= ';' then
            error("parse failed: expected terminating ; at the end of ^ sequence but found '" .. c .. "'")
        end
    end

    local consume_comment = function(seen_char)
        assert(seen_char == '#', "consume_comment called with seen_char != '#'")
        local first = i - 1
        while i <= #str do
            local c = str:sub(i, i); i = i + 1
            if c == ';' then
                return
            end
        end
        error("parse failed: unterminated comment beginning at character " .. first)
    end

    local consume_app_name = function(seen_char, emit_function)
        assert(seen_char == '>' or seen_char == '@', "consume_app_name called with seen_char != '>' nor '@'")
        local app_directive = ({['>'] = 'target', ['@'] = 'focus'})[seen_char]
        local first = i - 1
        while i <= #str do
            local c = str:sub(i, i); i = i + 1
            if c == ';' then
                local last = i - 1
                local app_name = str:sub(first + 1, last - 1)
                emit_function({
                    ['app_name'] = app_name,
                    ['app_directive'] = app_directive,
                })
                return
            end
        end
        error("parse failed: unterminated > sequence beginning at character " .. first)
    end

    local consume_stream = function(emit_function)
        while i <= #str do
            local c = str:sub(i, i); i = i + 1
            if c == '^' then
                consume_modifier_sequence('^', emit_function)
            elseif c == '>' or c == '@' then
                consume_app_name(c, emit_function)
            elseif c == '#' then
                consume_comment(c)
            elseif c == ';' or c == ' ' or c == '\t' or c =='\r' or c =='\n' then
                -- ignore
            else
                consume_key(c, emit_function)
            end
        end
    end

    consume_stream(emit_function_outer)
end

function apply(str)
    local current_app_target = nil
    parse(str, function(production)
        if production["app_directive"] ~= nil then
            local app_name = production["app_name"]
            local app_directive = production["app_directive"]

            if app_directive == 'target' then
                if app_name == '' then
                    current_app_target = nil
                    print('>')
                else
                    current_app_target = hs.appfinder.appFromName(app_name)
                    if current_app_target == nil then
                        error("apply failed: could not find app '" .. app_name .. "'")
                    end
                    print('>' .. app_name)
                end
            elseif app_directive == 'focus' then
                local will_launch_app = hs.appfinder.appFromName(app_name) == nil
                hs.application.launchOrFocus(app_name)
                print('@' .. app_name)
                if will_launch_app then
                    print('sleeping for 250ms')
                    os.execute("sleep 0.25")
                end
            else
                assert(false, 'apply saw production with unknown app_directive')
            end
        end

        if production["keycode"] ~= nil then
            print_table({ ['keypress'] = production })
            hs.eventtap.keyStroke(production["modifiers"], production["keycode"], 100000, current_app_target)
        end
    end)
end

hs.hotkey.bind({"cmd", "shift", "alt", "ctrl"}, "Q", function()
    if recording == nil then
        hs.alert.show("Recording...")
        record()
    else
        local full_result = record_done()
        -- regex to remove the last keypress event because it ended the macro
        local result = string.match(full_result, "^(.+)%^[%w%+%[%]]+;$")
        hs.pasteboard.setContents(result)
        hs.alert.show("Saved to clipboard")
    end
end)

hs.hotkey.bind({"cmd", "shift", "alt", "ctrl"}, "2", function()
    local str = hs.pasteboard.getContents()
    if str:sub(1, #';;;') ~= ';;;' then
        hs.alert.show("Clipboard does not look like a macro (does not start with ';;;')")
        return
    end
    apply(str)
end)

--- end macros

