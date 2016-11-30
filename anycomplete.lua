
-- Anycomplete
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local GOOGLE_ENDPOINT = 'https://suggestqueries.google.com/complete/search?client=firefox&q=%s'
    local current = hs.application.frontmostApplication()
    local timer;

    local chooser = hs.chooser.new(function(choosen)
        current:activate()
        hs.eventtap.keyStrokes(choosen.text)
    end)

    chooser:queryChangedCallback(function(string)
        if timer and timer:running() then
            timer:stop()
        end

        timer = hs.timer.doAfter(0.3, function()
            if not string or string == "" then return end

            -- hs.alert.show(string)
            local query = hs.http.encodeForQuery(string)

            hs.http.asyncGet(string.format(GOOGLE_ENDPOINT, query), nil, function(status, data)
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
    end)

    chooser:searchSubText(false)

    chooser:show()
end)
