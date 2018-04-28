#!/bin/bash
PS3="Please select a num from menu:"
select name in oldboy oldgirl tingting
do
echo -e "I guess you selected the menu is:\n $REPLY) $name"
done
