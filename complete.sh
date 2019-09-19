#! /bin/bash
#case1
present_date=`date +"%d%b%Y"`
previous_date=`date +"%d%b%Y" -d "-$1 days"`


source_directory=/home/pavankumar/Pictures
destination_daily=/home/pavankumar/Videos/daily/
destination_day=/home/pavankumar/Videos/days/
destination_week=/home/pavankumar/Videos/weekly/
destination_month=/home/pavankumar/Videos/monthly/

if [ $1 -eq 2 ] ;
     then
	#find $source_directory -type f -newermt $previous_date ! -newermt $present_date -exec cp {} $destination_daily \;
	find $source_directory -type f -newermt $previous_date ! -newermt $present_date | head -n1 >> $destination_daily/preserve.txt
	find $source_directory -type f -newermt $previous_date ! -newermt $present_date -exec mv {} $destination_daily \;
     else
	echo "please check argument."
fi
while read -r line0 ;
do
rm -v !("$line0")
done <(`cat"/home/pavankumar/Videos/daily/preserve.txt"`)

for i in 0 1 2 3 4 5 6 7 8
  do
	di=$(($1+$i));
 	previous_date1=`date +"%d%b%Y" -d "-$di days"`
	dii=$(($di+1));
 	previous_date2=`date +"%d%b%Y" -d "-$dii days"`

	#find $source_directory -type f -newermt $previous_date ! -newermt $present_date -exec cp {} $destination_day \;
        find $source_directory -type f -newermt $previous_date ! -newermt $present_date | head -n1 >> $destination_day/preserve.txt
	find $source_directory -type f -newermt $previous_date2 ! -newermt $previous_date1 -exec mv {} $destination_day \;
done

while read -r line0 ;
do
rm -v !("$line0")
done <(`cat"/home/pavankumar/Videos/days/preserve.txt"`)

#case3

for i in 9 17 25 33
do
	dw=$(($1+$i));
 	previous_date3=`date +"%d%b%Y" -d "-$dw days"`
	dww=$(($dw+7));
 	previous_date4=`date +"%d%b%Y" -d "-$dww days"`

	#find $source_directory -type f -newermt $previous_date ! -newermt $present_date -exec cp {} $destination_week \;
        find $source_directory -type f -newermt $previous_date ! -newermt $present_date | head -n1 >> $destination_week/preserve.txt

	find $source_directory -type f -newermt $previous_date4 ! -newermt $previous_date3 -exec cp {} $destination_week \;

done
while read -r line0 ;
do
rm -v !("$line0")
done <(`cat"/home/pavankumar/Videos/weekly/preserve.txt"`)


#case4


for i in 41 73 105 137 169 201 233 260 292 324 356
do
	dm=$(($1+$i));
	 previous_date5=`date +"%d%b%Y" -d "-$dm days"`
	dmm=$(($dm+31));
	 previous_date6=`date +"%d%b%Y" -d "-$dmm days"`
	#find $source_directory -type f -newermt $previous_date ! -newermt $present_date -exec cp {} $destination_month \;
        find $source_directory -type f -newermt $previous_date ! -newermt $present_date | head -n1 >> $destination_month/preserve.txt

	find $source_directory -type f -newermt $previous_date6 ! -newermt $previous_date5 -exec cp {} $destination_month \;

done
while read -r line0 ;
do
rm -v !("$line0")
done <(`cat"/home/pavankumar/Videos/monthly/preserve.txt"`)

