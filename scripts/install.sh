#!/usr/bin/env bash

if ! command -v yq &> /dev/null; then
    echo "yq is not installed. Please install yq to run this script."
    exit 1
fi

mod_name=$(yq -p xml -oy ".Mod.Properties.Name" src/*.modinfo)

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

echo "Copying mod files ..."
mod_directory="${user_directory}/Mods/${mod_name}"
# Always clean up the mod directory first in case we delete files from the mod source
rm -rf "${mod_directory}"
cp -ar src "${mod_directory}"
