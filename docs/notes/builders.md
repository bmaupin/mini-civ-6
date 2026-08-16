# Builders

## Problems

Previous Civ games had workers that could be automated, which I almost always chose to do. But Civ 6 has builders that cannot be automated and have a limited number of actions (charges) before they go away and a new builder must be built.

But this ends up feeling like it creates more manual work for the player, and I don't find it interesting. Most of the time there's only one improvement to build on a particular tile, so there's no decision at all, just manual work. And because improvements are only unlocked by certain technologies, you have to constantly keep track of which improvements are available and then decide if it's time to build a builder. And then because they only have a limited number of actions, you may be in the middle of adding improvements when this happens, and then have to go through the manual process of building a new one.

## Solutions

#### Increase builder charges

I tried this first by doubling builder charges (to 6). It does somewhat alleviate the issue of the builder running out of charges when you're in the middle of building a number of improvements, but it only seems to highlight more that builders aren't that interesting because there is often only one improvement to build per tile.

#### Remove builders

My next thought was to remove builders altogether, however this presented some challenges:

- Improvements are necessary for access to strategic resources (e.g. iron needs mines)
- The map looked sparse and not as much like a Civ game. Even CivRev (which doesn't have workers) changes tiles worked by a city, e.g. to look like a farm
- Improvements need to be repaired after pillaging or cleaned up after fallout

#### Automate improvements

Since builders can't be removed without a negative visual and gameplay impact, the next solution seems to be to automate improvements. The game has a method for recommended improvements but this is only available when there's a builder unit. Instead:

- If a tile has a resource, automate the improvement needed to get yields from that resource
- Automate basic improvements (farms, mines, lumber mills) for a specific set of terrains/features since this seems pretty straightforward
- Ignore all other improvements
- ~~Automate removal of fallout from tiles; Civ 7 does this after 10 turns~~
  - No need! Apparently Civ 6 removes fallout as well after a certain number of turns
- Automate repairing pillaged improvements? Similarly to how Civ 7 removes fallout from tiles after 10 turns
  - After 20 turns? 10 seems too short

Then we could either remove builders from the game altogether, or allow them to be in the game only for building special improvements (e.g. unique improvements, special improvements for game modes or scenarios).

- If we did this, it might be good to remove automated improvements from the builders
