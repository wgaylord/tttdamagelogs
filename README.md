# TTT Damagelogs
Created by Tommy228

This is an administration tool which allows server admins to handle player reports during a game of Trouble in Terrorist Town.

<br>

## Features
- Damagelogs *with filter and highlight options*
- Shot logs
- Damage informations
- Old logs (*which saves and displays all features listed above*)
- RDM Manager 
- Chat system
- Report and respond system
- Punishment options: Autoslay and Autojail
- Visual Deathscene
- Translation support: English, German, French, Russian and Polish
- Storage support for MySQL and SQLite
- Support for ULX and Serverguard: User groups and RDM punishments
- Easy configuration via config file and F1 settings menu
- Discord notifications for reports

<br>

## Latest Version

Get the latest version from the [Releases](https://github.com/BadgerCode/tttdamagelogs/releases) section.

<br>

## Support
For guides on using & configuring this addon, please check our [wiki](https://github.com/BadgerCode/tttdamagelogs/wiki).

If you have a question, issue or feature request, please raise an issue in the [Issues](https://github.com/BadgerCode/tttdamagelogs/issues) section.


<br>

## Installation

1. Go to the [Releases](https://github.com/BadgerCode/tttdamagelogs/releases) section
2. Download the **Source Code (zip)** for the latest version
3. Extract the zip to a folder called `tttdamagelogs`
    * Make sure the folder name is all lowercase
4. Copy this folder into your server's addons folder
5. Configure the addon via the configuration lua file - `lua/config/config.lua`

### Example

![Example installation](https://i.imgur.com/ihPY6EI.png)

* The server's folder is `gmod-test-server`
* The server's addon folder is `gmod-test-server/garrysmod/addons`
* The damage logs addon folder is `gmod-test-server/garrysmod/addons/tttdamagelogs`
* The config file can be found at `gmod-test-server/garrysmod/addons/tttdamagelogs/lua/config/config.lua`


<br>

---

<br>


## Original Version
The original version of this project can be found here: https://github.com/Tommy228/TTTDamagelogs <br>
The original version is no longer being maintained.

<br>

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
