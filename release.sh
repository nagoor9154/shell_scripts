#!/bin/bash

if [ "$1" != "" ];then
echo "Mentioned branch name is $1"
else 
echo "Please enter the branch name as a argument" 
exit 1
fi 

rm -rf pmsRelease/shavalues.txt
rm -rf pmsRelease/sortshavalues.txt
rm -rf pmsRelease/pms-list-files.txt
rm -rf pmsRelease/fullshas.txt
rm -rf pmsRelease/comp.txt
rm -rf pmsRelease/full-files.txt
rm -rf pmsRelease/comparedsha.txt
rm -rf pmsRelease/null.txt
rm -rf pmsRelease/common-files.txt
rm -rf pmsRelease/duplicate.txt
greptext=""
echo "Taking Shavalues from pmslist"

while read -r line0
do
       if [[ ! $line0 =~ [^[:space:]] ]] ; then
       continue
     fi
greptext=$greptext" --grep='\[PMS \w*"$line0"\w*]'"
done < <(cat "pmsRelease/pmslist.txt")
#echo $greptext
command="git log  --oneline $greptext RELEASE_FLOATING_PMS_TESTING^..$1 "'|cut -d " " -f 1'
echo $1
eval "$command"  >> pmsRelease/shavalues.txt
eval "$command" |sort >> pmsRelease/sortshavalues.txt
echo "Shavalues are copied to shavalues.txt"

echo "Taking files from pmslisted shavalues"

while read -r line1
do
	if [[ ! $line1 =~ [^[:space:]] ]] ; then
       		continue
     	fi
git show --oneline --name-status --pretty="format:BEGIN %h:%s" "$line1" | cut -d ']' -f1 |sed 's/\[PMS //'|awk '/BEGIN/ {hed=$2" "$3" "$4" "$6" "$5" "$8" "$7" "$9" "$10" "$11; next} {if (length($0) != 0) printf "\n%s %s", hed,$0} END {print ""}' >> pmsRelease/duplicate.txt
#sed '/^$/d' pmsRelease/duplicate.txt >> pmsRelease/officialfiles.txt
echo $filecommand 
done < <(cat "pmsRelease/shavalues.txt")
sed '/^$/d' pmsRelease/duplicate.txt >> pmsRelease/pms-list-files.txt
rm -rf pmsRelease/duplicate.txt

echo "Files copied to pms-list-files.txt"

echo "Taking all PMS sha values"
head="head -1 pmsRelease/shavalues.txt"
eval $head

git log  --pretty="format:%h %N" RELEASE_FLOATING_PMS_TESTING..`$head` | grep -v 'moved to release branch'| sed '/^$/d' |sort > pmsRelease/fullshas.txt
#git log  --oneline  RELEASE_FLOATING_PMS_TESTING^..`$head` | cut -d " " -f 1|sort >> pmsRelease/fullshas.txt

echo "All shavalues copied fullshas.txt"
echo "Taking difference between shavalues"
diffcommand="comm -1 -3  pmsRelease/sortshavalues.txt pmsRelease/fullshas.txt"
eval $diffcommand  >> pmsRelease/comparedsha.txt
echo "Taken difference between shavalues"
#sedcommand="sed 's/>/ /g' pmsRelease/comp.txt"
#eval $sedcommand  >> pmsRelease/comparedsha.txt
#rm -rf pmsRelease/comp.txt
echo "Taking Files from compared sha values"
while read -r line2
do

git show --oneline --name-status --pretty="format:BEGIN %h:%s" "$line2" | cut -d ']' -f1 |sed 's/\[PMS //'|awk '/BEGIN/ {hed=$2" "$3" "$4" "$6" "$5" "$8" "$7" "$9" "$10" "$11; next} {if (length($0) != 0) printf "\n%s %s", hed,$0} END {print ""}' >> pmsRelease/duplicate.txt

done < <(cat "pmsRelease/comparedsha.txt")
sed '/^$/d' pmsRelease/duplicate.txt >> pmsRelease/full-files.txt 2>pmsRelease/null.txt
rm -rf pmsRelease/duplicate.txt

#comm -1 -3 pmsRelease/pms-list-files.txt  pmsRelease/diff.txt |sort >>pmsRelease/semifinal.txt

echo "making final list comapare between diff files and pms-list-files.txt"
#rm  pmsRelease/1.txt
while read -r line3
do
if ( grep -i "$line3" pmsRelease/full-files.txt >> pmsRelease/duplicate.txt ); then
   echo $line3
fi;
#echo $line3 >> pmsRelease/duplicate.txt
done < <(cat pmsRelease/pms-list-files.txt | rev | cut  -f1 | rev)
sort pmsRelease/duplicate.txt | uniq -d >> pmsRelease/common-files.txt
#rm -rf pmsRelease/duplicate.txt
echo end of run
