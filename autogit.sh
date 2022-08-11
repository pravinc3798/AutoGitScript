#!/bin/bash

read -p " Input Git Link " link;

git clone $link

read -p " Input Name of Folder that is to be uploaded " input;
read -p " Input Git Directory " gitInput;

for i in $(ls $input | grep -v .cs)
do
	cd $input
	cp -r $i ../$gitInput;
	cd ..
done

read -p " Input Project File Name " projectfile;
read -p " Entry Point Class Name " programfile;

cd $input

cp $projectfile ../$gitInput
cp $programfile ../$gitInput

cd ..

for i in $(ls $input | grep .cs)
do
	if [ $i == $programfile ]
	then
		echo "Skipping "$i;
	elif [ $i == $projectfile ]
	then
		echo "Skipping Project File" $i
	else
		echo $i
		cd $input
		cp -r $i ../$gitInput
		cd ../$gitInput
		bname=$(echo $i | awk -F . '{print $1}')
		git checkout -b $bname
		git add .
		git commit -m "Added $bname class"
		git push origin -u $bname
		git checkout main
		git merge $bname
		git push
		cd ..
	fi
done
