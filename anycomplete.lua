
local urlencode = require("urlencode")

-- Anycomplete
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local GOOGLE_ENDPOINT = 'https://www.google.com/complete/search?client=hp&hl=en&xhr=t&q=%s'
    local current = hs.application.frontmostApplication()

    local chooser = hs.chooser.new(function(choosen)
        current:activate()
        hs.eventtap.keyStrokes(choosen.text)
    end)

    chooser:queryChangedCallback(function(string)
        local query = urlencode.string(string)

        hs.http.asyncGet(string.format(GOOGLE_ENDPOINT, query), nil, function(status, data)
            if not data then return end

            local results = hs.json.decode(data)

            if not results then return end

            choices = hs.fnutils.imap(results[2], function(result)
                return {
                    ["text"] = string.gsub(result[1], '</?b>', ''),
                }
            end)

            chooser:choices(choices)
        end)
    end)

    chooser:searchSubText(false)

    chooser:show()
end)
