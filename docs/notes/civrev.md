# CivRev mode

## Governments

### Problem

The original idea was to completely eliminate the civics tree and merge everything into the tech tree. But governments don't have a PrereqTech column, only PrereqCivic.

### Solutions

#### Remove governments

Not a bad idea. In Civ 6 they're mostly for unlocking policy cards, which we won't use in CivRev mode anyway.

#### Leave the civics tree

For now it's probably simplest to just leave the civics tree. It will already be vastly simplified.

## Great people

### Problem

When the player has enough points to get a great person, they have to click Claim Great Person, which opens the Great People dialogue, then they have to find the eligible great person and click Recruit. It would be nice if great people appeared as in previous Civ games.

### Solutions

First, we can disable the Reject button in the Great People dialogue with a simple database modification (`CAPABILITY_GREAT_PEOPLE_CAN_REJECT`). This removes a decision point.

We can also similarly disable recruiting great people with gold.

Ideally we would fully automate great people acquisition. This would require Lua to listen for when a player is eligible to get a great person and manually triggering this. See greatpeoplepopup.lua for relevant logic.
