#!/bin/bash

#Start "help" module
#Functions
help()
{
   # Display Help
   echo "----------------------------------------------------------------------------------------"
   echo "This program created by Stanislav Zapasko special for Hillel IT School"
   echo "----------------------------------------------------------------------------------------"
   echo
   echo "----------------------------------------------------------------------------------------"
   echo "!!!Words in file must be once in line!!!"
   echo "----------------------------------------------------------------------------------------"
   echo 
   echo "----------------------------------------------------------------------------------------"
   echo "Syntax: ./script_name -argument path/to/dictionary"
   echo "----------------------------------------------------------------------------------------"
   echo
   echo "----------------------------------------------------------------------------------------"
   echo "Options:"
   echo "-h        Print this Help."
   echo
   echo "-s        Search words starting with arguments"
   echo
   echo "-e        Search words ending with argument"
   echo
   echo "-l        Search words by numbers of argument characters (#sample: -l 5 10)"
   echo "----------------------------------------------------------------------------------------"
   echo 
   echo "----------------------------------------------------------------------------------------"
   echo "logfile is /var/log/dictionary.log"
   echo "----------------------------------------------------------------------------------------"
}

#global variables
logfile=dictionary.log
user=`whoami`
time=`date '+%X'`
dir=`pwd`

#Main program with arguments
OPTSTRING=":ehls" #avaibles arguments
while getopts ${OPTSTRING} opt; do #cycle for arguments
echo $opt >> tmp.txt #temporary file for filter arguments
echo "$user run a script from $dir with '$opt' argument at $time with PID $$" >> $logfile #added information about user, arguments,start time and PID to log 
  if [[ `cat tmp.txt | wc -l` -gt 1 ]]; then #Checking only one argument
    echo -e "\n-----------------------------------------------------------------------"
    echo "Multiple arguments are not supported! Result only for first argument!."         #error message for multiple arguments
    echo -e "-----------------------------------------------------------------------"
    break
  else              #start program
      case ${opt} in #checking argument value
        e)                      #code for ending (first argument by alphabet)
          if [ -e $3 ]; then
            end= awk '/'$2'$/' $3
            endcount=$(awk '/'$2'$/' $3 | wc -l)
            echo -e "$endcount words ending in '$2' are found in $3."
          else
            echo "File not exist. Please, enter file/filepath correctly."
          fi
          ;;
        h)                      #code for help (second argument by alphabet)
          help
          ;;
        l)                      #code for len (third argument by alphabet)
          if [ -e $4 ]; then
            len= awk 'length($0)>='$2' && length($0)<='$3'' $4
            lencount=$(awk 'length($0)>='$2' && length($0)<='$3'' $4 | wc -l)
            echo -e "$lencount words from $2 to $3 symbols are found in $4."
          else
            echo "File not exist. Please, enter file/filepath correctly."
          fi
          ;;
        s)                      #code for start (four argument by alphabet)
        if [ -e $3 ]; then
            start= awk '/^'$2'/' $3
            startcount=$(awk '/^'$2'/' $3 | wc -l)
            echo -e "$startcount words starting from '$2' are found in $3."
          else
            echo "File not exist. Please, enter file/filepath correctly."
          fi
          ;;
        ?)                       #code for inavaible arguments error message
          echo "Invalid option: -${OPTARG}. Please, use -h argument for help."
          exit 1
          ;;
      esac
  fi
  echo "Script with $$ PID from $user with '$opt' argument has been ended at $time" >> $logfile #adding information ro log
done
rm -rf tmp.txt        #remove temporary file for filter arguments
