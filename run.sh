#!/bin/bash

# global var(allowed to changed base on ur pref.)
#-------------------------------------------#
usrname="urbao"
dirloca="$HOME/Desktop/money tracker"
logfile="$HOME/Desktop/money tracker/log.txt"
helpfile="$HOME/Desktop/money tracker/help.txt"
#-------------------------------------------#

#--------------Side Functions---------------#
# print fnction with color and newline/sameline options
# nl: NewLine/ nnl: No NewLine
function print(){
	local c_code=0
	# color c_code chck
	if [ "$1" == "red" ]; then c_code="31m" 
	elif [ "$1" == "yellow" ]; then c_code="33m" 
	elif [ "$1" == "green" ]; then c_code="32m" 
	elif [ "$1" == "cyan" ]; then c_code="36m" 
	elif [ "$1" == "purple" ]; then c_code="35m"
	#white output(Default)
	else c_code="37m" 
	fi
	# combine c_code with printed line(string combination)
	c_code+="$2"
	# new line or not
	# 'echo -e' enables color hex code identification 
	if [ "$3" == "nl" ]
	then 
		echo -e  "\e[1;${c_code}\e[0m"
	# '-n' parameter means no newline
	else 
		echo -n -e "\e[1;${c_code} \e[0m"
	fi
	return 
}

# backup log.txt with git, and push to GitHub
# Used after any modification with log.txt file
function gitpush(){
	cd "$dirloca" || return
	print "cyan" "---- git add ----" "nl"
	git add log.txt
	print "cyan" "--- git commit ---" "nl"
	git commit -m "update log file"
	print "cyan" "---- git push ----" "nl"
	git push
	print "cyan" "------------------\n" "nl"
	return 
}

# format line with space for prettier storage in log.txt
# parameter order(represent LENGTH of STRING): Date|Type|Amount|Detail|
function format_appd(){
	space1=$(printf '%*s' $((10-"${#2}")) ' ')
	space2=$(printf '%*s' $((7-"${#3}")) ' ')
	space3=$(printf '%*s' $((50-"${#4}")) ' ')
	update_time=$(date "+%a %b %d %T %G")
	result="$1$space1$2$space2$3  $4$space3$update_time"
	echo "$result" >> "$logfile"
	return
}
#-------------------------------------------#

#--------------Main Command-----------------#
# show function that show all contents of log.txt
function show(){
	while IFS= read -r line
	do
	  # colored different lines by their differnet types, using substr to check
	  if [[ $line == *"income"* ]]
	  then
	  	print "green" "$line" "nl"
	  elif [[ $line == *"expense"* ]]
	  then
	  	print "red" "$line" "nl"
	  else 
	  	print "yellow" "$line" "nl"
	  fi
	done < "$logfile"
	printf "\n"
	return
}

# help func that shows all valid options(help function)
function help(){
	while IFS= read -r line
		do echo "$line"
	done < "$helpfile"
	echo
	return
}

# append function that append latest info to log.txt
function append(){
	print "yellow" "------ Append ------" "nl"
	print "purple" "Date:" "nnl"
	read -r dat
	print "purple" "Type:" "nnl"
	read -r type
	print "purple" "Amount:" "nnl"
	read -r amount
	print "purple" "Detail:" "nnl"
	read -r detail
	# make sure before appending
	while true
	do
	   	print "red" "Do you want to append this?[Y/n]" "nnl"
		read -r ans
		if [ "${ans,,}" == "y" ]
		then
			chmod 777 "$logfile"
			format_appd "$dat" "$type" "$amount" "$detail"
			# append line to log file
			print "yellow" "------- Done -------" "nl"
			# backup with gitpush func
			gitpush
			chmod 444 "$logfile"
			return
		elif [ "${ans,,}" == "n" ]
		then
			print "yellow" "------ Cancel ------" "nl"
			return
		else
			print "red" "Error: invalid input\n" "nl"	
		fi
	done
}
#-------------------------------------------#


# main part fuction, keep working until `exit` command typed
while true
do
	print "purple" "${usrname}:" "nnl"
	read -r input
	if [ "$input" == "exit" ]; then exit
	elif [ "$input" == "clear" ]; then clear
	elif [ "$input" == "show" ]; then show 
	elif [ "$input" == "help" ]; then help
	elif [ "$input" == "append" ]; then append
	fi
done
