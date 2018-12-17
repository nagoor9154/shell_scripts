#!/bin/bash


while read -r line0
do
#        if [[ ! $line1 =~ [^[:space:]] ]] ; then
 #               continue
  #      fi
git notes add -f -m "moved to release branch" $line0
echo $line0
done < <(cat "pmsRelease/shavalues.txt")



