## Anycomplete

The magic of Google Autocomplete while you're typing. Anywhere.

![](http://i.imgur.com/kYoE7hs.gif)

### Installation

Anycomplete is an extension for [Hammerspoon](http://hammerspoon.org/). Once Hammerspoon is installed, you can install the Autocomplete Spoon:

    $ git clone https://github.com/nathancahill/anycomplete.git ~/.hammerspoon/Spoons/Anycomplete.spoon

To initialize, add to `~/.hammerspoon/init.lua` (creating it if it does not exist):

```lua
anycomplete = hs.loadSpoon("Anycomplete")
anycomplete.bindHotkeys()
```

Reload the Hammerspoon config.

### Usage

Trigger with the hotkey `⌃⌥⌘G`. Once you start typing, suggestions will populate.
They can be choosen with `⌘1-9` or by pressing the arrow keys and Enter.
Pressing `⌘C` copies the selected item to the clipboard.

The hotkey can be changed by passing an argument to
`bindHotkeys` call (in your `~/.hammerspoon/init.lua` file)
such as:

```lua
anycomplete:bindHotkeys({{"cmd", "ctrl"}, "L"})
```

### Warning

Google might block your IP address if you use this. See [#26](https://github.com/nathancahill/Anycomplete/issues/26).

### Privacy

No keystrokes are sent to Google until you trigger the hotkey and start typing. If you prefer DuckDuckGo,
set the `engine` option:

```lua
anycomplete = hs.loadSpoon("Anycomplete")
anycomplete.engine = "duckduckgo"
anycomplete.bindHotkeys()
```
