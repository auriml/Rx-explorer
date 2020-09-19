#!/bin/bash

# PadChest script to obtain all images from a given finding. No need to unzip PadChest files.
# Instructions: Create a folder called "scripts" in the PadChest root folder and run:
# ./extractFinding <finding>. A folder with name <finding> will be created with the images

if [ $# -eq 1 ]
  then
  	for f in ../image_zips/*.zip; do 
		unzip -l $f| awk '{print $4}' > $f.list
	done
	  
 	mkdir "$1" 
 
	grep -i "'$1'" ../labels_csv/PADCHEST_chest_x_ray_images_labels_160K_01.02.19.csv > "$1".txt
	
	cat "$1".txt|awk 'BEGIN{FS=","}{print $2}' | while read line
	do
		echo "FILE: " $line
	  	for f in ../image_zips/*.list; do 
			if grep -q $line $f; then
				echo "$line found in $f"
				name=${f%.list};
				echo $name
				unzip -j $name $line -d "$1"
				break
			fi
		done
				
	done
	
else
	echo "Syntax: $0 <search_term>" 
	echo "Example: ./extractFinding.sh \"pleural effusion\""
fi

