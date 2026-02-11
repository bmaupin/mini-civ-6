#!/usr/bin/env bash

# NOTE: This install script is only meant for local development. For all other purposes,
#       see README.md for installation instructions.

if ! command -v yq &> /dev/null; then
    echo "yq is not installed. Please install yq to run this script."
    exit 1
fi

mod_name=$(yq -p xml -oy ".Mod.Properties.Name" src/*.modinfo)

# Validate files

pushd src > /dev/null

# ⚠️ This will fail if there are spaces in any of the file names
action_files=($(yq -p xml -oy '.Mod.FrontEndActions.*.File | .[]? // .' "${mod_name}.modinfo"))
action_files+=($(yq -p xml -oy ".Mod.InGameActions.ReplaceUIScript[].Properties.LuaReplace" Mini\ Civ\ 6.modinfo))
action_files+=($(yq -p xml -oy '.Mod.InGameActions.UpdateDatabase[].File | select (.) | .[]? // .' "${mod_name}.modinfo"))
action_files+=($(yq -p xml -oy '.Mod.InGameActions.UpdateIcons[].File | select (.) | .[]? // .' "${mod_name}.modinfo"))

files_section_files=($(yq -p xml -oy '.Mod.Files.File | .[]? // .' "${mod_name}.modinfo"))

for file in "${action_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Missing file: $file"
        exit 1
    fi
done

for file in "${files_section_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Missing file: $file"
        exit 1
    fi
done

for file in "${action_files[@]}"; do
  found=false
  for checkfile in "${files_section_files[@]}"; do
    if [[ "$file" == "$checkfile" ]]; then
      found=true
      break
    fi
  done
  if [[ "$found" == false ]]; then
    echo "Error: File '$file' from action_files is not listed in the <Files> section"
    exit 1
  fi
done

popd >/dev/null

echo "Installing mod: ${mod_name}"

# Detect whether we're using native or Proton
if [[ -f "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization VI/Civ6" ]]; then
    user_directory="/home/${USER}/.local/share/aspyr-media/Sid Meier's Civilization VI"
fi

if [[ -f "/home/$USER/.steam/steam/steamapps/common/Sid Meier's Civilization VI/Base/Binaries/Win64Steam/CivilizationVI.exe" ]]; then
    echo "TODO: Implement Proton support for Civ VI"
    exit 1
    # user_directory="/home/${USER}/.steam/steam/steamapps/compatdata/289070/pfx/drive_c/users/steamuser/Documents/My Games/Sid Meier's Civilization VI"
fi

# Inject the current date into the mod description. This makes it easier to tell if the
# mod has been updated when doing development.
sed -i "s|\(<Description>\)[^<]*\(</Description>\)|\1$(date)\2|" "src/${mod_name}.modinfo"

echo
mod_directory="${user_directory}/Mods/${mod_name}"
# Always clean up the mod directory first in case we delete files from the mod source
rm -rf "${mod_directory}"
cp -ar src "${mod_directory}"
rm -rf "${mod_directory}/Archive"

ls -l "${user_directory}/Mods"
