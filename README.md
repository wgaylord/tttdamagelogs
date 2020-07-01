TTT Damagelogs
==============

TTT Damagelogs is an administration tool designed for TTT to allow handling RDM situations using different tools.



## Improvements found in this fork of the addon

* Improves discord integration: [images](https://imgur.com/a/kKgondH) - [discord.lua](https://github.com/BadgerCode/tttdamagelogs/blob/master/lua/damagelogs/server/discord.lua)
    * **IMPORTANT**: Unfortunately, Discord's servers block webhook messages sent from Garry's Mod servers.
    * You will need to proxy your requests through another website.
* Adds support for custom equipment events
```lua
-- In your weapon's code

function SWEP:PrimaryAttack()
    hook.Call("TTTEquipmentUse", nil, self:GetOwner(), self, "C4 placed")
end
```
* Fixes issues with highlighting, admin chat close not working, no default aslay reason: [#1](https://github.com/BadgerCode/tttdamagelogs/pull/1)

<br><br><br><br><br>

----


# Original README


**Do not directly download the addon from the repo ! It may contain untested or experimental code. Download the addon from the releases tab : https://github.com/Tommy228/TTTDamagelogs/releases**


## Features
- Damagelogs *with filter and highlight options*
- Shot logs
- Damage informations
- Old logs *which saves and displays all features listed above*
- RDM Manager 
- Chat system
- Report and respond system
- Punishment options: Autoslay and Autojail
- Visual Deathscene
- Translation support: English, German, French, Russian and Polish
- Storage support for MySQL and SQLite
- Support for ULX and Serverguard: User groups and RDM punishments
- Easy configuration via config file and F1 settings menu


### Installation

##### For *stable* releases look here: https://github.com/Tommy228/TTTDamagelogs/releases

Just drop the TTTDamagelogs folder to addons/. The addon can be configured on the *lua/damagelogs/config/config.lua* file.

**On Linux servers, you need to make the foldername lowercase!**


## Support
- [Facepunch Thread](https://gmod.facepunch.com/f/gmodaddon/jjah/TTT-Damagelogs-MySQL-Edition/1/)
- [GitHub issues](https://github.com/Tommy228/TTTDamagelogs/issues)


# License

    TTT Damagelogs is an administration tool designed for TTT to allow handling RDM situations using different tools.
    Copyright (C) 2012-2018 Ismail Ouazzany
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
