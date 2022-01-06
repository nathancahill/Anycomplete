--- === Anycomplete ===
---
--- The magic of Google Autocomplete while you're typing. Anywhere.
---
--- Configurable properties (with default values):
---     engine = "google", -- or "duckduckgo"
---
--- Download: [https://github.com/nathancahill/Anycomplete](https://github.com/nathancahill/Anycomplete)

local obj = {}

-- Options
obj.engine = "google"

-- Metadata
obj.name = "Anycomplete"
obj.version = "1.0"
obj.author = "Nathan Cahill <nathan@nathancahill.com>"
obj.homepage = "https://github.com/nathancahill/Anycomplete"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local endpoints = {
    google = "https://suggestqueries.google.com/complete/search?client=firefox&q=%s",
    duckduckgo = "https://duckduckgo.com/ac/?q=%s",
}

-- Anycomplete
function obj:anycomplete()
    local current = hs.application.frontmostApplication()
    local tab = nil
    local copy = nil
    local choices = {}

    local chooser = hs.chooser.new(function(choosen)
        if copy then copy:delete() end
        if tab then tab:delete() end
        current:activate()

        if not choosen then return end
        hs.eventtap.keyStrokes(choosen.text)
    end)

    -- Removes all items in list
    function reset()
        chooser:choices({})
    end

    tab = hs.hotkey.bind('', 'tab', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        -- If no row is selected, but tab was pressed
        if not item then return end
        chooser:query(item.text)
        reset()
        updateChooser()
    end)

    copy = hs.hotkey.bind('cmd', 'c', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        if item then
            chooser:hide()
            hs.pasteboard.setContents(item.text)
            hs.alert.show("Copied to clipboard", 1)
        else
            hs.alert.show("No search result to copy", 1)
        end
    end)

    function updateChooser()
        local string = chooser:query()
        local query = hs.http.encodeForQuery(string)
        -- Reset list when no query is given
        if string:len() == 0 then return reset() end

        hs.http.asyncGet(string.format(endpoints[self.engine], query), nil, function(status, data)
            if not data then return end

            local ok, results = pcall(function() return hs.json.decode(data) end)
            if not ok then return end

            if self.engine == "google" then
                choices = hs.fnutils.imap(results[2], function(result)
                    return {
                        ["text"] = result,
                    }
                end)
            elseif self.engine == "duckduckgo" then
                choices = hs.fnutils.imap(results, function(result)
                    return {
                        ["text"] = result["phrase"],
                    }
                end)
            end

            chooser:choices(choices)
        end)
    end

    chooser:queryChangedCallback(updateChooser)
    chooser:searchSubText(false)
    chooser:show()
end

function obj:bindHotkeys(mapping)
    mapping = mapping or {{"cmd", "alt", "ctrl"}, "g"}
    hs.hotkey.bind(mapping[1], mapping[2], function() obj:anycomplete() end)
end

return obj
