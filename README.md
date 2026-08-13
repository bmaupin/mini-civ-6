# Mini Civ 6

📌 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

This is a mod to Sid Meier's Civilization VI to allow much shorter games.

## Installation

Because the mod is [unfinished](#status), only [manual installation](#manual-installation) is possible at this time.

## Status

> [!TIP]
> If you would like a Civ-like game that plays much more quickly, I recommend [Ozymandias](https://goblinzstudio.com/game/ozymandias/) instead.

Work in progress.

## Features

#### Very small maps

Map sizes have been significantly reduced ([20% of their original size](src/Data/MiniCivVI_SmallerMaps.sql)). This alone has the biggest impact on the length of the game. In addition to games being shorter, the game as a whole runs faster as there is less to process (e.g. much less wait time between turns).

#### Default game speed set to online

The default game speed has been set to online in order to speed up gameplay.

#### Reduced barbarian difficulty

Barbarians in Civ 6 are notoriously more aggressive, and dealing with them takes up a lot more time in the early game. Their aggressiveness has been drastically reduced for quicker gameplay.

See [Credits](#credits) below for more information

#### City state features removed

If city states are set to 0 and Barbarian Clans mode isn't checked, city state features are removed from the game such as the ability to acquire envoys as well as UI elements referencing city states.

#### New game options

Some new game options have been added to better facilitate quicker games:

👉 Note that there hasn't been much work to balance these

- No Amenities
  - Sets the required number of amenities to 0 for all cities
- No Great People
  - Removes great people from the game
- No Military
  - Removes military and all related items (units, buildings, techs, etc) from the game and also disables barbarians
- No Policies
  - Removes policy cards completely from the game and modifies the Governments screen to not show the Policy tab
- No Religion
  - Removes religion, faith, pantheons and all related items from the game
- Remove Most Districts
  - Removes most districts from the game. Buildings are instead built in the city centre.

#### Other small tweaks

- Civic/tech boosted popups disabled
- Removed AI warning for settling too close

## Manual installation

<!-- 1. Download the repository source file from [Releases](https://github.com/bmaupin/mini-civ-6/releases) and extract it -->

1. Download the repository
   - In GitHub, click _Code_ > _Download ZIP_, or check out the repository using git
1. Rename the `src` directory to `Mini Civ 6` and copy it to [your Mods directory](https://www.pcgamingwiki.com/wiki/Sid_Meier%27s_Civilization_VI#Configuration_file.28s.29_location):
   - Linux: ~/.local/share/aspyr-media/Sid Meier's Civilization VI/Mods
   - Mac: /Users/[user]/Library/Application Support/Sid Meier's Civilization VI/Mods
   - Windows: Documents/My Games/Sid Meier's Civilization VI/Mods

## Credits

#### Civic/tech boosted popups disabled

Functionality copied from [Disable Tech Boosted and Civic Boosted Popup Windows](https://steamcommunity.com/sharedfiles/filedetails/?id=1730111532) mod by [Zur13](https://steamcommunity.com/id/zur13/myworkshopfiles/)

#### Reduced barbarian difficulty

Functionality copied from [https://steamcommunity.com/sharedfiles/filedetails/?id=2492747881](https://steamcommunity.com/sharedfiles/filedetails/?id=2492747881) mod by [Zegangani](https://steamcommunity.com/id/Zegangani216/myworkshopfiles/)
