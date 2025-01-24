#!/bin/bash

# Define variables
REPO_URL="https://github.com/MostafaKashwaa/powerprompt-lite/main"
INSTALL_DIR="$HOME/.powerprompt"

PROMPT_SCRIPT_URL="$REPO_URL/scripts/powerprompt.sh"
PROMPT_SCRIPT_NAME="powrprompt.sh"
PROMPT_SCRIPT_PATH="$INSTALL_DIR/$PROMPT_SCRIPT_NAME"

CONFIG_FILE_URL="$REPO_URL/scripts/prompt_config.conf"
CONFIG_FILE_NAME="prompt_config.conf"
CONFIG_FILE_PATH="$INSTALL_DIR/$CONFIG_FILE_NAME"

STYLES_FILE_URL="$REPO_URL/scripts/styles.sh"
STYLES_FILE_NAME="styles.sh"
STYLES_FILE_PATH="$INSTALL_DIR/$STYLES_FILE_NAME"

# Create the directory for the prompt script if it doesn't exist
mkdir -p "$INSTALL_DIR"

files=(PROMPT_SCRIPT_PATH CONFIG_FILE_PATH STYLES_FILE_PATH)

function download_file {
  local url=$1 path=$2 
  if [[ -f "$path" ]]; then
    echo "File already exists at $path"
  else
    echo -e "Downloading $url..."
    curl -fo "$path" "$url" 2>/dev/null
    if [ $? -ne 0 ]; then
      echo -e "Failed to download $url. Exiting.\n"
      rm -r $INSTALL_DIR
      exit 1
    fi
  fi
}

echo
download_file $PROMPT_SCRIPT_URL $PROMPT_SCRIPT_PATH
download_file $CONFIG_FILE_URL $CONFIG_FILE_PATH
download_file $STYLES_FILE_URL $STYLES_FILE_PATH
echo

# Add source command to .bashrc if it's not already there
SOURCE_LINE="    source $PROMPT_SCRIPT_PATH"
PATTERNIF='if \[ \"\$color_prompt\" = yes \]; then'
PATTERNPS="PS1=*"
MARKER='#source ~/.bash_profile'

if grep -q "$SOURCE_LINE" "$HOME/.bashrc"; then
  echo -e "Prompt configuration already present in .bashrc\n"
  exit 0
else
  awk -v src="$SOURCE_LINE" -v patternif="$PATTERNIF" -v patternps="$PATTERNPS" '
  {
    e = "else*"
    if ($0 ~ patternif) {
      inside_if = 1
      print; 
    } else if (inside_if && $0 ~ patternps) {
       print; 
       print src; 
       inserted = 1
       inside_if = 0
     } else if ($0 ~ e) { 
      inside_if = 0
      print; 
     } else {
       print;
     }
  } END {
    if (!inserted) {
      print src
    }
  }
  ' "$HOME/.bashrc" > "$HOME/.bashrc.tmp" && mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"

    echo -e "Prompt configuration added to .bashrc\n"
fi

# Source .bashrc to apply changes
source "$HOME/.bashrc"

echo -e "Installation complete.\nPlease restart your terminal or run:\n\nsource $HOME/.bashrc\n"

