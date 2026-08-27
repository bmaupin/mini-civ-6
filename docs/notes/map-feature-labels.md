# Map feature labels

Gathering Storm added labels to map features, similar to CivRev.

## Implementation

#### Base off Gathering Storm

If we add `<GameCore>Expansion2</GameCore>` to the `RuleSets` in MiniCivVI_CivRev_Config.xml, it will base the CivRev ruleset on Gathering Storm, but this pulls in all features of Gathering Storm and Rise and Fall, which we would then need to prune.

We'd also need to add Gathering Storm as a dependency of the mod.

#### Manual implementation

It seems the logic is in MapLabelManager.lua and some of it could be manually implemented without bringing in all the features from Gathering Storm.

However a lot of it relies on Lua functionality only exposed in the Gathering Storm (expansion 2) game core (`MapTerritories`, `RiverManager`, etc). So implementing it would probably not be trivial.

A quick test with an LLM was only able to generate labels for natural wonders before it started running into problems.
