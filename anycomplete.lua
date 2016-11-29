
local urlencode = require("urlencode")

-- Anycomplete
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local GOOGLE_SUGGEST_ENDPOINT = 'https://suggestqueries.google.com/complete/search?client=firefox&q=%s'
    local GOOGLE_SEARCH_ENDPOINT = 'https://www.google.co.uk/#q=%s'

    local current = hs.application.frontmostApplication()

    local chooser = hs.chooser.new(function(choosen)
        if hs.eventtap.checkKeyboardModifiers()['shift'] then
          -- holding shift as they choose so load in google instead
          hs.execute("open " .. string.format(GOOGLE_SEARCH_ENDPOINT, choosen.text))
        else
          -- default behaviour: type out text to previously frontmost app
          current:activate()
          hs.eventtap.keyStrokes(choosen.text)
      end
    end)

    chooser:queryChangedCallback(function(string)
        local query = urlencode.string(string)

        hs.http.asyncGet(string.format(GOOGLE_SUGGEST_ENDPOINT, query), nil, function(status, data)
            if not data then return end

            local ok, results = pcall(function() return hs.json.decode(data) end)
            if not ok then return end

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
