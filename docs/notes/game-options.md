# Game options

## Adding a new game option

#### Research

- There are no `GAMEOPTION` types like Civ 5/BE had
- Take "No Barbarians" as an example
  - GameData
    - `FrontEndText`
        - `LOC_GAME_NO_BARBARIANS`
  - GameInfo > Parameters
    - `<Row Key1="Ruleset" Key2="RULESET_STANDARD" ParameterId="NoBarbarians" Name="LOC_GAME_NO_BARBARIANS" Description="" Domain="bool" DefaultValue="0" ConfigurationGroup="Game" ConfigurationId="GAME_NO_BARBARIANS" GroupId="AdvancedOptions" SortIndex="2010"/>`

Scenarios

- Conquests of Alexander
  - "The technology and civics trees, policy cards, diplomacy, and religion are all disabled"
- Outback Tycoon has no combat