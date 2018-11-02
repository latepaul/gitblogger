#!/bin/sh
#
# new_entry.sh - new entry for my new "git blog"
#                What this does is touch a file, add it, commit it and then
#                the commit message is the blog post

CTEMPLATE=/tmp/commit.$$.template
export EDITOR=`which vi`

git pull
if [ $? -ne 0 ]
then
    echo "Failed git pull"
    exit 1
fi

if [ ! -f FILE ]
then
    NUM=-1
else
    NUM=`cat FILE`
fi

NUM=`expr $NUM + 1`
echo $NUM > FILE

echo "" > $CTEMPLATE
echo "" >> $CTEMPLATE
echo "($NUM)" >> $CTEMPLATE
git add FILE new_entry.sh
git commit -t $CTEMPLATE

if [ $? -eq 0 ]
then
    git push
    tput clear
    echo "+------------------------------------------------------------------------------+ "
    git log -1
    echo "+------------------------------------------------------------------------------+ "
    echo " "
else
    git reset FILE
    git checkout FILE
fi
rm -f $CTEMPLATE
