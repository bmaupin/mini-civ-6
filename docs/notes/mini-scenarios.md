# Mini scenarios

## To do

- [ ] Document scenario creation steps
- [ ] Get one minimal scenario working
- [ ] Play test to refine map size

## Goal

- 4-6 players
- About 1 hour of playtime

## Steps

#### Planning

1. Decide a scenario
1. Determine the list of civs
   - Look up on wikipedia
   - If the inspiration is a podcast (e.g. Fall of Civilizations), ask ChatGPT (it has access to transcripts)
   - chronas.org
1. For each civ
   1. Map those civs to in-game civs
   1. Get city names
   1. Find leader images
      - e.g. [public-domain art](https://standardebooks.org/manual/1.7.0/10-art-and-images#10.3.3.7.1)
1. Get a map
   - Start with [the maps that come with the game](<https://civilization.fandom.com/wiki/Map_(Civ6)>)
   - Check [Steam workshop](https://steamcommunity.com/workshop/browse/?appid=289070&section=readytouseitems&requiredtags%5B%5D=Map+Packs)
   - Or this can be used to create a map from scratch: https://github.com/je-suis-tm/Sid-Meier-s-Civilization-6-modding

#### Implement the map

1. Make sure the map is big enough
   1. The map file should end in .civ6map
   1. Copy the map to ~/.local/share/aspyr-media/Sid Meier's Civilization VI/Saves/WorldBuilder/
   1. Start the game > _World Builder_ > _Load Map_ > select the map > _Load Map_
   1. Get an idea of where the map will be cropped on all sides to make sure the remaining map will be big enough
1. Determine which part of an existing map to use

West: 14
North:
East: 38
South:

```
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install ipykernel pandas numpy matplotlib opencv-python basemap scikit-learn
```

## Map size

#### Idea

- Start with small map (74x46)
- Halve each side
- Result: 36x24

#### Default maps

- Tiny map
  - Default players: 4
  - Default size: 60x38
- Small
  - Default players: 6
  - Default size: 74x46

## Scenarios

### Sumeria

Inspirations

- [Fall of Civilizations podcast](https://fallofcivilizationspodcast.com/2019/10/25/episode-8-is-now-live/)
- [Literature and History podcast](https://literatureandhistory.com/episode-001-the-tower-of-babel/)
- [Ozymandias game](https://ozymandiasgame.fandom.com/wiki/Fertile_Crescent)
  - ??x20 map

Map

- ~~Built-in map for Alexander scenario~~
  - Way too small, max 26 tiles wide for the area we want
- [Moda's Huge Earth Map Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1801916483)
  - Barely big enough but we could make it work
  - Terrain is very heterogenous but maybe not a big deal
- [Apry’s Bronze Age Map](https://steamcommunity.com/sharedfiles/filedetails/?id=3556194548)
  - Not sure about terrain, looks too dry
  - Definitely big enough
- ~~[Ancient Mesopotamia and Levant](https://steamcommunity.com/sharedfiles/filedetails/?id=2809277529)~~
  - Big but no mountains in the East
- ~~[Saph's Middle East: Cradle of Civilization](https://steamcommunity.com/sharedfiles/filedetails/?id=2844607622)~~
  - The whole thing is rotated; bizarre
  - Requires YnAMP
- ~~[The Fertile Crescent](https://steamcommunity.com/sharedfiles/filedetails/?id=2569001270)~~
  - Close; stops at the mountains on the east
  - Very big

### Persia

#### Prompts

> I have created an empty 36x24 map here: Persia.Civ6Map
>
> I want you to take this map: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/steamassets/dlc/alexanderscenario/map/alexander.civ6map
>
> It's a map that's 66x38
>
> I want you to shrink it. The 36x24 map isn't quite the right dimentions, so you'll need to modify it so that it's 38x22, then shrink the alexander map to fit in it. If need be I can create an empty 38x22 map
>
> Copy all of the appropriate values as needed into the new map, including
>
> - plot terrains, rivers, features, cliffs, etc
>
> Do not copy changes from these tables:
>
> - Buildings
> - Cities
> - CityAttributes
> - Districts
> - MapAttributes
> - MetaData
> - PlayerAttributes
> - Players
> - PlotImprovements
> - PlotOwners
> - PlotRoutes
> - Units

> Similar to the Sumeria map, I would like starting locations set.
>
> These will be the civilisations on the map:
>
> - Persia
> - Macedon
> - Babylon
> - Egypt
> - Lydia: use the Ottomans
> - Medes: use Georgia
>
> Find the appropriate starting locations for these civilisations and set them on the map
>
> also don't make any more changes to the Mods needed for the map. I can manage that myself
