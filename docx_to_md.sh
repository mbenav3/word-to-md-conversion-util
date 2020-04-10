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

## 
### The clean_images & update_image_txt functions
### are only invoked when the 
### option to inlcude images is submitted
function update_image_txt(){
    cd ../
    ### for linux
    # sed -i 's/.tiff/.png/g' README.md
    
    ## for MacOSX
    sed -i '' -e 's/.tiff/.png/g' README.md
}

function clean_images(){
    ######### tiff is not supported in gfm format - converting to png is neccessary #########  
    cd media/
    
    for f in *.tiff
    do  
        echo "Converting $f" 
        convert "$f"  "$(basename "$f" .tiff).png"
    done
    
    update_image_txt
}


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
      pandoc -f docx -t gfm --default-image-extension=".png" $_WORD_FILE -o README.md
    else
      rm -rf media
      pandoc -f docx -t gfm --extract-media=. --default-image-extension=".png" $_WORD_FILE -o README.md
      
      clean_images
    fi
}

convert_docx_to_md
