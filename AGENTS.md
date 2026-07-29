- Be concise
- Merely provide guidance and do not write to any files unless otherwise requested
- Use British English spelling
- Don't use rg, use grep
- Civ 6 uses the Havok Script Lua which adds types to Lua that must be stripped for compatibility with the Lua language server used by the vscode Lua extension
- Prefer modifications in this order:
  1. Database modifications are ideal as they ensure compatibility with other mods
  2. Custom Lua scripts when database changes aren't possible
  3. When custom Lua isn't possible, overriding game files may be necessary in some cases but is not preferred as it is most likely to break compatibility with other mods
- When creating Lua code, check these references:
  - Game source: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI
  - Game SDK: ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI SDK
  - Sukritact's Lua API reference: https://sukritact.github.io/Civilization-VI-Modding-Knowledge-Base/
  - The game symbol map files:
    - ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/steamassets/dlc/expansion1/binaries/win64/gamecore_xp1_finalrelease.map
    - ~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/steamassets/dlc/expansion2/binaries/win64/gamecore_xp2_finalrelease.map
