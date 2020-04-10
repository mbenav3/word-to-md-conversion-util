#!/bin/bash

######### setup #########
CUR_DIR=$(dirname $0)
cd ${CUR_DIR}
set -e
timeout=60

######### get args #########
while getopts ":w:i:g:" opt; do
  case $opt in
      w) _WORD_FILE="$OPTARG"
      ;;
      i) _IMG_INC="$OPTARG"
      ;;
      g) _GIT_IGNORE_ADD="$OPTARG"
      ;;
      \?) echo "Invalid option -$OPTARG" >&3
      ;;
  esac
done

# TODO:
# 1. logging
# 2. error handling


################################################ CONVERT DOCX TO MD ################################################
function convert_docx_to_md() {
    ######### Add to .gitnore file #########
    if [ -z "$_GIT_IGNORE_ADD" ]; then
      if grep -Fxq "docx_to_md.sh" .gitignore; then
          echo ""
      else
        echo "docx_to_md.sh" >> .gitignore
      fi
    else
        echo ""  
    fi
    
    ######### extract images, if necessary #########
    if [ -z "$_IMG_INC" ]; then
      pandoc -f docx -t gfm $_WORD_FILE -o README.md
    else
      pandoc -f docx -t gfm --extract-media=. $_WORD_FILE -o README.md
    fi
}

convert_docx_to_md
