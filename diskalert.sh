#This will change based on location of scriptdump dir
cd /usr/safetrax/scriptdump/
if [[ $? -ne 0 ]]; then
        echo "Path: /usr/backup/i247/ not found"
        exit 1
fi
#ALERT=90 
today=`date +%y%m%d`
yesterday=`date -d "-1 days" +"%y%m%d"`
thirdday=`date -d "-2 days" +"%y%m%d"`
fourthday=`date -d "-3 days" +"%y%m%d"`
fifthday=`date -d "-4 days" +"%y%m%d"`
sixthday=`date -d "-5 days" +"%y%m%d"`
seventhday=`date -d "-6 days" +"%y%m%d"`
eighthday=`date -d "-7 days" +"%y%m%d"`
ninthday=`date -d "-8 days" +"%y%m%d"`
tenthday=`date -d "-9 days" +"%y%m%d"`
eleventhday=`date -d "-10 days" +"%y%m%d"`
twelvethday=`date -d "-11 days" +"%y%m%d"`
thirteenthday=`date -d "-12 days" +"%y%m%d"`
fourteenthday=`date -d "-13 days" +"%y%m%d"`
firstweek="dump"`date -d "-19 days" +"%y%m%d"`
secondweek="dump"`date -d "-26 days" +"%y%m%d"`
firstmonth="dump"`date -d "-70 days" +"%y%m%d"`
secondmonth="dump"`date -d "-100 days" +"%y%m%d"`
DAY=`date +%y`
todayDump="dump"$today;
yesterdayDump="dump"$yesterday;
thirddayDump="dump"$thirdday;
fourthdayDump="dump"$fourthday;
fifthdayDump="dump"$fifthday;
sixthdayDump="dump"$sixthday;
seventhdayDump="dump"$seventhday;
eighthdayDump="dump"$eighthday;
ninthdayDump="dump"$ninthday;
tenthdayDump="dump"$tenthday;
eleventhdayDump="dump"$eleventhday;
twelvethdayDump="dump"$twelvethday;
thirteenthdayDump="dump"$thirteenthday;
fourteenthdayDump="dump"$fourteenthday;
weeklycount=0;
monthlycount=0;
    for i in `find *`
      do
        var1=$(echo $i | cut -f1 -d-)
	#Extract date number from dump string dir name
	var2=$(echo $i | cut -f1 -d- | tr -dc '0-9');
	datestr=`date -d "$var2"`;
	#Get date number
	dateNum=${var2:4:2};
	#Gives Sat for saturday
	daystr=$(date --date="$datestr" +"%a");
        if [ "$var1" = "$todayDump" ] || [ "$var1" = "$yesterdayDump" ] || [ "$var1" = "$thirddayDump" ] || [ "$var1" = "$fourthdayDump" ];then
   		echo "leaving dump=>"$vari1;
	elif [ "$var1" = "$fifthdayDump" ] || [ "$var1" = "$sixthdayDump" ] || [ "$var1" = "$seventhdayDump" ] || [ "$var1" = "$eighthdayDump" ] || [ "$var1" = "$ninthdayDump" ] || [ "$var1" = "$tenthdayDump" ] || [ "$var1" = "$eleventhdayDump" ] || [ "$var1" = "$twelvethdayDump" ] || [ "$var1" = "$thirteenthdayDump" ] || [ "$var1" = "$fourteenthdayDump" ];then
		echo "one dump per day=>"$var1;
		rm -rf $var1-{0[^0]*,1*,2[^3]*};
	elif [ "$daystr" = "Sat" ] && [ $weeklycount -lt 4 ];then
		echo "weekly sat dump=>"$var1;
		if [[ $weeklycount -gt 0 ]]; then
			if [[ "${weekdumparray[$weeklycount-1]}" = "$var1" ]]; then
				continue
			fi
		fi
		weekdumparray[$weeklycount]=$var1;
		#echo ${weekdumparray[@]};
		rm -rf $var1-{0*,1*,2[^3]*};
		#read dummy
		weeklycount=`expr $weeklycount + 1`;
		echo $weeklycount;
	elif [ "$daystr" = "Sat" ] && [ $weeklycount -eq 4 ];then
		echo "weekly sat dump recent=>"$var1;
		if [[ "${weekdumparray[$weeklycount-1]}" = "$var1" ]]; then
			continue
		fi
		rm -rf $var1-{0*,1*,2[^3]*};
		echo "old weekly dump removing=>"${weekdumparray[0]};
		if [ $dateNum != 01 ]; then
			rm -rf ${weekdumparray[0]}*;
		fi
		weekdumparray[0]=${weekdumparray[1]};
		weekdumparray[1]=${weekdumparray[2]};
		weekdumparray[2]=${weekdumparray[3]};
		weekdumparray[3]=$var1;
		weeklycount=4;
	elif [  $dateNum = 01 ] && [ $monthlycount -lt 10 ];then 
	#&& [ $monthlycount -lt 10 ];then
                echo "monthly dump=>"$var1;
                if [[ $monthlycount -gt 0 ]]; then
                        if [[ "${monthdumparray[$monthlycount-1]}" = "$var1" ]]; then
                                continue
                        fi
                fi
                monthdumparray[$monthlycount]=$var1;
                #echo ${weekdumparray[@]};
                rm -rf $var1-{0*,1*,2[^3]*};
                #read dummy
                monthlycount=`expr $monthlycount + 1`;
                echo $monthlycount;
	elif [  $dateNum = 01 ] && [ $monthlycount -eq 10 ];then
                echo "monthly dump recent=>"$var1;
		if [[ "${monthdumparray[$monthlycount-1]}" = "$var1" ]]; then
                        continue
                fi
                rm -rf $var1-{0*,1*,2[^3]*};
                echo "old monthly dump removing=>"${monthdumparray[0]};
                rm -rf ${monthdumparray[0]}*;
                monthdumparray[0]=${monthdumparray[1]};
                monthdumparray[1]=${monthdumparray[2]};
                monthdumparray[2]=${monthdumparray[3]};
                monthdumparray[3]=${monthdumparray[4]};
                monthdumparray[4]=${monthdumparray[5]};
                monthdumparray[5]=${monthdumparray[6]};
                monthdumparray[6]=${monthdumparray[7]};
                monthdumparray[7]=${monthdumparray[8]};
                monthdumparray[8]=${monthdumparray[9]};
                monthdumparray[9]=$var1;
                monthlycount=10;
   	else
   	  	rm -rf $i;
	  	echo "old dump removing=>"$var1;
        fi
      done
