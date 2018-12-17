#!/bin/bash


while read -r line1
do
	if [[ ! $line1 =~ [^[:space:]] ]] ; then
       		continue
     	fi
git show --oneline --name-status --pretty="format:BEGIN %h:%s" "$line1" | cut -d ']' -f1 |sed 's/\[PMS //'|awk '/BEGIN/ {hed=$2" "$3" "$4" "$6" "$5" "$8" "$7" "$9" "$10" "$11; next} {if (length($0) != 0) printf "\n%s %s", hed,$0} END {print ""}' >> pmsRelease/1.txt
echo $filecommand 
done < <(cat pmsRelease/shavalues.txt |grep -v "testing")
sed '/^$/d' pmsRelease/1.txt >> pmsRelease/2.txt
