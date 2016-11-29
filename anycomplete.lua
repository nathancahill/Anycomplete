
local urlencode = require("urlencode")

-- Anycomplete
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local GOOGLE_ENDPOINT = 'https://suggestqueries.google.com/complete/search?client=firefox&q=%s'
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
                    ["text"] = result,
                }
            end)

            chooser:choices(choices)
        end)
    end)

    chooser:searchSubText(false)

    chooser:show()
end)
