# Mini Civ 6

📌 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

This is a mod to Sid Meier's Civilization VI to allow much shorter games.

## Installation

Because the mod is [unfinished](#status), only [manual installation](#manual-installation) is possible at this time.

## Status

The mod works although development has been halted before all features were implemented.

Civ 6 makes modding easier in many aspects, but the game itself is more complex in terms of the number of different systems and lacks a lot of built-in options that Civ 5 had to disable these systems such as religion, espionage, and even war. This makes modding more time-consuming and less enjoyable. Rather than spend more time on this, it seems there are games designed from the beginning to respect the player's time such as [Ozymandias](https://goblinzstudio.com/game/ozymandias/).

## Features

#### Very small maps

Map sizes have been reduced to 16% of their original size (40% of their height and 40% of their width). This alone has the biggest impact on the length of the game. In addition to games being shorter, the game as a whole runs faster as there is less to process (e.g. much less wait time between turns).

#### Default game speed set to online

The default game speed has been set to online in order to speed up gameplay.

#### Reduced barbarian difficulty

Barbarians in Civ 6 are notoriously more aggressive, and dealing with them takes up a lot more time in the early game. Their aggressiveness has been drastically reduced for quicker gameplay.

See [Credits](#credits) below for more information

#### Changes to builders

Default charges for builders have been doubled (from 3 to 6) in order to speed up gameplay.

#### City state features removed

If city states are set to 0 and Barbarian Clans mode isn't checked, city state features are removed from the game such as the ability to acquire envoys as well as UI elements referencing city states.

#### New game options

Some new game options have been added to better facilitate quicker games:

👉 Note that there hasn't been much work to balance these

- No Great People
  - Removes great people from the game
- No Military
  - Removes military and all related items (units, buildings, techs, etc) from the game and also disables barbarians
- No Policies
  - Removes policy cards completely from the game and modifies the Governments screen to not show the Policy tab
- No Religion
  - Removes religion, faith, pantheons and all related items from the game

#### Civic/tech boosted popups disabled

> Disables the Tech Boosted (Eureka) and Civic Boosted (Inspiration) popup windows which interrupts your gameplay. Tech boosted and Civic boosted notification still appear on notification panel and the popup can be displayed by clicking on notification.

See [Credits](#credits) below for more information

## Manual installation

1. Download the repository source file from [Releases](https://github.com/bmaupin/mini-civ-6/releases) and extract it
1. Rename the `src` directory to `Mini Civ 6` and copy it to [your Mods directory](https://www.pcgamingwiki.com/wiki/Sid_Meier%27s_Civilization_VI#Configuration_file.28s.29_location):

   - Linux: ~/.local/share/aspyr-media/Sid Meier's Civilization VI/Mods
   - Mac: /Users/[user]/Library/Application Support/Sid Meier's Civilization VI/Mods
   - Windows: Documents/My Games/Sid Meier's Civilization VI/Mods

## Wishlist

- [ ] Additional game options
  - [ ] No amenities?
    - Untested, see [src/Data/MiniCivVI_RemoveAmenities.sql](src/Data/MiniCivVI_RemoveAmenities.sql)
  - [ ] No espionage?
    - Untested, see [src/Data/MiniCivVI_RemoveEspionage.xml](src/Data/MiniCivVI_RemoveEspionage.xml)
  - [ ] Always peace?
  - [ ] Remove districts?
    - All buildings would be built in the city centre
  - [ ] Auto-renew trade routes?
  - [ ] Manual road building?
    - à la CivRev, basically a build option for a road that connects cities
    - Remove road building from trader unit?
    - Reuse trader UI?
- [ ] CivRev ruleset/scenario/game mode?

## Credits

#### Civic/tech boosted popups disabled

Functionality copied from [Disable Tech Boosted and Civic Boosted Popup Windows](https://steamcommunity.com/sharedfiles/filedetails/?id=1730111532) mod by [Zur13](https://steamcommunity.com/id/zur13/myworkshopfiles/)

#### Reduced barbarian difficulty

Functionality copied from [https://steamcommunity.com/sharedfiles/filedetails/?id=2492747881](https://steamcommunity.com/sharedfiles/filedetails/?id=2492747881) mod by [Zegangani](https://steamcommunity.com/id/Zegangani216/myworkshopfiles/)
