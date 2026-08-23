# Technologies

## Dead-end and orphaned techs

#### Problem

After removing various database objects (units, districts, etc), some techs are left empty. I've added logic to delete techs if they don't have any database objects that rely on them (so they're basically empty). However, this leaves orphaned techs (with no prerequisites) and dead-end techs (that aren't the prerequisite of any other techs).

#### Solutions

Various approaches were tried. Automating prerequisites ended up creating a tech tree with sensible predetermined tech dependencies alongside random dependencies that could be complex and/or illogical.

I considered forcing tech and civic randomisation, but what if players don't want this? I considered hard-coding all dependencies, but then it would be brittle and could break if other mods are used.

I then implemented logic that preserved the tech dependencies as-is, accounting for deleted techs. But for orphaned techs this ended up creating many dependencies that crossed eras, making techs available too soon.

However, that logic seemed to work well for dead-end techs, so I adopted a hybrid approach where dependencies for dead-end techs are automated and dependencies for orphaned techs are manually defined to keep them from crossing multiple eras.
