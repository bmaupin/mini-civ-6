- Communicate concisely
- Only provide guidance and do not write to any files unless requested
- Use British English spelling
- Don't use rg, use grep
- Civ 6 uses Havok Script Lua which adds types that must be stripped for compatibility with the vscode Lua language server
- Civ 6 uses SQLite
- Prefer simpler, clearer solutions even if they're less concise; code should be prioritised for readability
- Prefer modifications in this order to increase compatibility with other mods:
  1. Database modifications
  2. Custom Lua scripts
  3. Overriding game files
- When creating Lua code, check these references:
  - Game source: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI
  - Game SDK: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI SDK
  - Sukritact's Lua API reference: https://sukritact.github.io/Civilization-VI-Modding-Knowledge-Base/
  - Game symbol map file: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/steamassets/dlc/expansion2/binaries/win64/gamecore_xp2_finalrelease.map
