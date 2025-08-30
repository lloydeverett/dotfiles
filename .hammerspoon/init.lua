
require("hs.ipc")

function new_window(app_name)
    local app = hs.appfinder.appFromName(app_name)
    local success = hs.application.launchOrFocus(app_name)
    if success and app then
        hs.timer.doAfter(0.1, function()
            hs.eventtap.keyStroke({"cmd"}, "N")
        end)
    end
end

