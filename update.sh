#!/bin/bash

echo "Fetching from FreeRTOS upstream"
git svn fetch

git checkout freertos-master

echo "Rebasing local patches ontop of latest FreeRTOS code"
git svn rebase

svn_tags=$(git branch -r | grep "tags/" | grep V | sed 's/ tags\///')
git_tags=$(git tag)


# Migrating SVN tags.
echo "Migrating/Maintaining SVN tags"
for tag in $svn_tags ; do
	if [[ $git_tags =~ $tag ]]
	then
		echo "Maintaining SVN tag: $tag"
	else
		git tag -a -m "Converting SVN tags" $tag tags/$tag; 
		echo "Creating new TAG from: $tag"
	fi
done

# Pushing to github
git push gh freertos-master
git push gh master
git push gh --tags -f
git checkout master

