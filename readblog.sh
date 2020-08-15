#!/bin/sh
#
# readblog.sh - read the gitblogger blog

# set up temp file prefix
TMP=/tmp/readblog.$$.tmp

# remove temp files however we exit
trap "rm -rf ${TMP}*; exit" TERM QUIT INT EXIT

# actual temp files
FULL_BLOG=${TMP}.full
ONE_POST=${TMP}.one
POST_INDEX=${TMP}.list
POST_LIST=${TMP}.index

# get all the blog text
echo "getting all blog posts"
git log > $FULL_BLOG 2>/dev/null
if [ $? -ne 0 ]
then
    echo "ERROR: failed to run git log"
    exit 1
fi

# get post index - list of commit ids in reverse order, numbered from 0
# numbering from 0 matches the FILE number value which is also in () at
# the bottom of post text
grep "^commit [0-9a-f][0-9a-f]" $FULL_BLOG | tac | pr -n -N 0 -t > $POST_INDEX

POST_COUNT=`tail -1 $POST_INDEX | awk '{print $1}'`

# build up a post list - list of numbers with dates and titles
: > $POST_LIST
i=0
while [ $i -le $POST_COUNT ]
do
    COMMIT_LINE=`grep "^[[:space:]]\+${i}[[:space:]]" $POST_INDEX | awk '{print $2,$3}'`
    FIRST_LINE=`grep -A 4 "${COMMIT_LINE}" $FULL_BLOG | tail -1`
    POST_DATE=`grep -A 2 "${COMMIT_LINE}" $FULL_BLOG | tail -1 | cut -c9-31`
    echo "$i $POST_DATE $FIRST_LINE" >> $POST_LIST
    i=`expr $i + 1`
done

# present list and user chooses where to start
tput clear
echo "Post list:"
more $POST_LIST
echo " " 
read -p "Post to start reading from [1] " POST_START
if [ -z "$POST_START" ]
then
    POST_START=0
fi

# find out screen size
SCREEN_HEIGHT=`stty size | cut -d" " -f1`
MORE_SIZE=`expr $SCREEN_HEIGHT - 3`

# starting from POST_START  display the posts until end or user chooses q for quit
i=$POST_START
while [ $i -le $POST_COUNT ]
do
    COMMIT_LINE=`grep "^[[:space:]]\+${i}[[:space:]]" $POST_INDEX | awk '{print $2,$3}'`
    awk -vCOMMIT_LINE="$COMMIT_LINE" '
/^commit [0-9a-f][0-9a-f]/ {PR=0}
$0 ~ COMMIT_LINE {PR=1}
{
    if (PR == 1 ) { print $0 }
}
    ' $FULL_BLOG > $ONE_POST

    tput clear
    echo "Post $i >"
    echo " "
    more -$MORE_SIZE $ONE_POST
    echo " "

    if [ $i -lt $POST_COUNT ]
    then
        read -p "Next/Quit [N] " ans
    else
        ans=q
    fi
    if [ "$ans" = "q" ]
    then
        i=`expr $POST_COUNT + 10`
    else
        i=`expr $i + 1`
    fi
done


