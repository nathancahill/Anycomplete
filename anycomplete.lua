local mod = {}

-- Anycomplete
function mod.anycomplete()
    local GOOGLE_ENDPOINT = 'https://suggestqueries.google.com/complete/search?client=firefox&q=%s'
    local current = hs.application.frontmostApplication()
    local tab

    local chooser = hs.chooser.new(function(choosen)
        tab:disable()
        current:activate()
        hs.eventtap.keyStrokes(choosen.text)
    end)

    -- Removes all items in list
    function reset()
        chooser:choices({})
    end

    tab = hs.hotkey.bind('', 'tab', function()
        local id = chooser:selectedRow()
        local row = chooser:rows(id)
        chooser:query(choices[id].text)
        reset()
        updateChooser()
    end)

    function updateChooser()
        local string = chooser:query()
        -- Reset list when no query is given
        if string:len() == 0 then return reset() end
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
    end

    chooser:queryChangedCallback(updateChooser)

    chooser:searchSubText(false)

    chooser:show()
end

function mod.registerDefaultBindings(mods, key)
    mods = mods or {"cmd", "alt", "ctrl"}
    key = key or "G"
    hs.hotkey.bind(mods, key, mod.anycomplete)
end

return mod
