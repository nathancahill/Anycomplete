## Anycomplete

The magic of Google Autocomplete while you're typing. Anywhere.

![](http://i.imgur.com/kYoE7hs.gif)

### Installation

Anycomplete is an extension for [Hammerspoon](http://hammerspoon.org/). Once Hammerspoon is installed (see [install Hammerspoon](#install-hammerspoon) below) you can run the following script to install Autocomplete.

    $ curl -sSL https://raw.githubusercontent.com/nathancahill/Anycomplete/master/install.sh | bash

[install.sh](https://github.com/nathancahill/Anycomplete/blob/master/install.sh) just clones this repository into `~/.hammerspoon`, loads it into Hammerspoon and sets `⌃⌥⌘G` as the default keybinding.

#### Manual installation

    $ git clone https://github.com/nathancahill/anycomplete.git ~/.hammerspoon/anycomplete

To initialize, add to `~/.hammerspoon/init.lua` (creating it if it does not exist):

    local anycomplete = require "anycomplete/anycomplete"
    anycomplete.registerDefaultBindings()

Alternatively, copy `anycomplete.lua` from this repository to wherever
you keep other Hammerspoon modules and load it appropriately.

Reload the Hammerspoon config.

#### Install Hammerspoon

Hammerspoon can be installed using [homebrew/caskroom](https://caskroom.github.io/).

    $ brew cask install hammerspoon
    $ open -a /Applications/Hammerspoon.app

Accessibility must be enabled for Anycomplete to work.

![](https://cloud.githubusercontent.com/assets/220827/20860328/a7dc4344-b975-11e6-893a-bb139ba8a102.png)

### Usage

Trigger with the hotkey `⌃⌥⌘G`. Once you start typing, suggestions will populate.
They can be choosen with `⌘1-9` or by pressing the arrow keys and Enter.
Pressing `⌘C` copies the selected item to the clipboard.

The hotkey can be changed by passing in arguments to
`registerDefaultBindings` call (in your `~/.hammerspoon/init.lua` file)
such as:

    anycomplete.registerDefaultBindings({"cmd", "ctrl"}, 'L')

### Warning

Google might block your IP address if you use this. See [#26](https://github.com/nathancahill/Anycomplete/issues/26).

### Privacy

No keystrokes are sent to Google until you trigger the hotkey and start typing. If you prefer DuckDuckGo, replace `GOOGLE_ENDPOINT` with:
`'https://duckduckgo.com/ac/?q=%s'` and the `imap` function with this:

```
choices = hs.fnutils.imap(results, function(result)
    return {
        ["text"] = result["phrase"],
    }
end)
```
