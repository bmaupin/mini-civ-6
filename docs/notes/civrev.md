# CivRev mode

## Barracks

### Problem

Barracks in CivRev makes all newly created military units veterans. Barracks in Civ 6 only improves ground units and excludes siege and cavalry units, which is handled by Stable, which is mutually exclusive with Barracks.

Naval units are improved by Lighthouse, Shipyard, Seaport.

Air units are improved by Hangar and Airport.

### Solutions

First, make sure we have at least one of each building for improving unit types

- Air: airport (hangar removed)
- Naval: lighthouse (shipyard and seaport removed)
- Ground: remove armory, military academy

Now, we need to decide:

- Keep Barracks and Stable
  - We need to make them not mutually exclusive
    - Very simple database operation
- Or allow Barracks to improve all ground units
  - Relatively simple database operation
  - Tech tree description won't match, but neither would it if we make it not mutually exclusive with Stable

Let's go with the simplest approach:

- Allow Barracks to improve all ground units
  - More consistent with naval and air units
  - One less building to deal with

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
