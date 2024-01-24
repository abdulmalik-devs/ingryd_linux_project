#!/bin/bash

# ------------------------------
# Date: 11/23/2023
# Author: Abdulmalik Ololade
# Modified: 11/24/2023 
# Modified by: Abdulmalik Ololade
# -------------------------------

# -------------------------------------------------------------------------------------
# ******************The scripts below performs four (4) Tasks**************************
# 1. A Script for backing a files
# 2. A Script for generating system metrics
# 3. A Script for ruuning oracle database schema backup
# 4. A Script for sending the system_metric report to a specific email
# ---------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------
# This below script is used to backup your files automatically to a specified directory.
# It will create a source and destination directory if it does not existIt automatically 
# create the files to be backedup in the source directory, and throw and erorr if it exist.
# It then create a zip file in the destination directory consisting of the files 
# -----------------------------------------------------------------------------------------


echo "--------------------------------------------------"
echo "*******RUNNING SCRIPT FOR BACKING UP FILE*********"
echo "--------------------------------------------------"

# Define important files and directories
backup_destination="$HOME/ingryd_Backup" # This is the backup destination
source_dir="$HOME/ingryd_Docs" # This is the source destination
files=("file1.txt" "file2.doc" "file3.pdf" "file4.html") # Theses are all the files to be backedup

# Function to create backup directory if it doesn't exist
create_backup_dir() {
 if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Backup directory '$1' created"
    backup_dir_created=true
 else
    if [ "$backup_dir_created" = false ]; then
        echo "Backup directory '$1' already exists."
        backup_dir_created=true
    fi
 fi
}

# Function to check and create source directory as necessary
check_create_source_dir() {
 if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Source directory '$1' created."
 else
    echo "Source directory '$1' already exists."
 fi
}

# Function to check and create files in the source directory
check_create_files() {
 for file in "${files[@]}"; do
    if [ ! -f "$1/$file" ]; then
        touch "$1/$file"
        echo "File '$file' created in directory '$1'."
    else
        echo "File '$file' already exists in directory '$1'."
    fi
 done
}

# Check and create source directory
check_create_source_dir "$source_dir"

# Check and create files in source directory
check_create_files "$source_dir"

# Function to perform backup of files and compress them
perform_backup() {
 backup_dir="$1"
 source_dir="$2"

 # Check if backup destination exists else create it
 create_backup_dir "$backup_dir"

 # Create tar.gz archive of all files
 tar -czf "$backup_dir/backups_files.tar.gz" -C "$source_dir" "${files[@]}"
 echo "Backup of all files completed."
}

# Perform backup for all files
perform_backup "$backup_destination" "$source_dir"

echo "---------------------------------------------------------------------------------------"
echo "---Backup Files sucessfully generated into this directory ----> $backup_destination"---
echo "---------------------------------------------------------------------------------------"
echo "*"
echo "*"
echo "*"
echo "--------------------------------------------------"
echo "*******RUNNING SCRIPT FOR SYSTEM METRICS*********"
echo "--------------------------------------------------"

# PRE-REQUISITES
# I have used the following commands to install the required packages
# sudo apt-get install sysstat
# sudo apt-get install ifstat
# The above commands will install the required packages


# ----------------------------------------------------------------------------------------------------
# 1. These below script is used to report the system metrics for CPU USAGE, MEMOMRY USAGE, DISK USAGE
# AND NETWORK STATS For the past week, i.e the past seven days and save it to filename called (system_metrics_report.txt)


# -------------------EXPLANTION OF THE BELOW SCRIPT LINE BY LINE------------------------
# This script generates a report where each row represents a day's disk space usage data, 
# separated into columns with the respective headers and formatted as specified by print. 
# The data for each day is appended to the specified output file ($output_file).
# Function to generate CPU usage report for the past week
# ----------------------------------------------------------------------------------------------------


#---------------------Generate CPU Report Code Block Explanation--------------------------
# Line 1: This initiates a loop to go through the last seven days.
# Line 2: This calculates the date for each iteration by subtracting the loop counter
         #($i) from the current date, formatted as day of the month (+%d)
# Line 3: Retrieves CPU usage data from SAR logs for the specified date.
         # Pipes the output to tail to fetch the last line of the SAR output and enters a while loop to read each line.
# Lone 4: Uses IFS (Internal Field Separator) to split the line into an array named ADDR based on spaces
# Line 5: Formats and appends the extracted CPU usage data into the $output_file in a tabular form, 
         # including the date and different CPU usage statistics.
# Line 6: This appends a newline character (\n) to the specified file indicated by the variable $output_file
touch system_metrics_report.txt
output_file="$HOME/system_metrics_report.txt" # Output file for the system metrics report

# generate_cpu_report() {
#    echo "CPU Usage (past week):" >> "$output_file" # Appending (CPU Usage to the output file)
#    echo -e "Date\t%user\t%nice\t%system\t%iowait\t%steal\t%idle" >> "$output_file" # Adding column headers
#    for i in {1..7}; do # Line1
#        current_date=$(date -d "$i days ago" +%d) # Line2
#        sar -u -f /var/log/sysstat/sa$current_date | tail -n 1 | while read line; do # Line3
#            IFS=' ' read -ra ADDR <<< "$line" # Line4
#            printf "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n" "$current_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" "${ADDR[4]}" "${ADDR[5]}" "${ADDR[6]}" >> "$output_file" # Line5
#        done
#    done
#    echo -e "\n" >> "$output_file" # Line6
# }
generate_cpu_report() {
    echo "CPU Usage (past week):" >> "$output_file" # Appending (CPU Usage to the output file)
    echo -e "Date\t%user\t%nice\t%system\t%iowait\t%steal\t%idle" >> "$output_file" # Adding column headers
    
    found_data=false

    for i in {1..7}; do # Line1
        current_date=$(date -d "$i days ago" +%d) # Line2

        # Check if SAR log file for the current date exists
        if [ -f "/var/log/sysstat/sa$current_date" ]; then
            found_data=true
            sar -u -f "/var/log/sysstat/sa$current_date" | tail -n 1 | while read line; do # Line3
                IFS=' ' read -ra ADDR <<< "$line" # Line4
                printf "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n" "$current_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" "${ADDR[4]}" "${ADDR[5]}" "${ADDR[6]}" >> "$output_file" # Line5
            done
        fi
    done

    # If no data was found for the past seven days, get the report for the most recent day
    if [ "$found_data" = false ]; then
        most_recent_date=$(date -d "1 day ago" +%d)
        sar -u -f "/var/log/sysstat/sa$most_recent_date" | tail -n 1 | while read line; do
            IFS=' ' read -ra ADDR <<< "$line"
            printf "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n" "$most_recent_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" "${ADDR[4]}" "${ADDR[5]}" "${ADDR[6]}" >> "$output_file"
        done
    fi

    echo -e "\n" >> "$output_file" # Line6
}


#---------------------Generate Memory Report Code Block Explanation--------------------------
# Line 1: This initiates a loop to go through the last seven days.
# Line 2: This calculates the date for each iteration by subtracting the loop counter
         # ($i) from the current date, formatted as day of the month (+%d)
# Line 3: Retrieves CPU usage data from SAR logs for the specified date.
         # Pipes the output to tail to fetch the last line of the SAR output and enters a while loop to read each line.
# Lone 4: It checks if the line begins with "Average" (the header of df command output) and skips it if true.
# Line 5: Uses IFS (Internal Field Separator) to split the line into an array named ADDR based on spaces
# Line 6: This appends a newline character (\n) to the specified file indicated by the variable $output_file

generate_memory_report() { # Function to generate Memory usage report for the past week
   echo "Memory Usage (past week):" >> "$output_file" # generate the memomry result into the output file
   echo -e "Date\tkbmemfree\tkbavail\tkbmemused\t%memused\tkbbuffers\tkbcached\kbcommit\%commit\kbactive\kbinact\kbdirty" >> "$output_file" # Adding column headers
   # This initiates a loop to go through the last seven days.
   for i in {1..7}; do # Line 1
       current_date=$(date -d "$i days ago" +%d) # Line 2
       sar -r -f /var/log/sysstat/sa$current_date | while read line; do # Line 3
           if [[ $line == "Average" ]]; then # Line 4
               continue
           fi
           IFS=' ' read -ra ADDR <<< "$line" # Line 5
           printf "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n" "$current_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" "${ADDR[4]}" "${ADDR[5]}" "${ADDR[6]}" "${ADDR[7]}" "${ADDR[8]}" "${ADDR[9]}" "${ADDR[10]}" >> "$output_file"
       done
   done
   echo -e "\n" >> "$output_file" # Line 6
}


#---------------------Generate Memory Report Code Block Explanation--------------------------
# Line 1: This calculates the date for each iteration by subtracting the loop counter
         # ($i) from the current date, formatted as day of the month (+%d)
# Line 2: This command fetches disk usage details in a human-readable format and processes the output line by line.
         # Pipes the output to tail to fetch the last line of the SAR output and enters a while loop to read each line.
# Lone 3:It checks if the line begins with "Filesystem" (the header of df command output) and skips it if true.
# Line 4: This line splits each line by space and stores the elements into an array called ADDR.
# Line 5: This appends a newline character (\n) to the specified file indicated by the variable $output_file


generate_disk_report() { # Function to generate Disk space usage report for the past week
   echo "Disk Space Usage (past week):" >> "$output_file" # Appending (Disk Space Usage to the output file)
   echo -e "Filesystem\tSize\tUsed\tAvailable\tPercentage" >> "$output_file" # Adding column headers
     
   for i in {1..7}; do #Line 1
       current_date=$(date -d "$i days ago" +%d)
       df -h --output=source,size,used,avail,pcent | while read line; do #Line 2
           if [[ $line == "Filesystem" ]]; then #Line 3
               continue
           fi
           IFS=' ' read -ra ADDR <<< "$line" # Line 4
             # The formatted output includes:
             # The current date.
             # ADDR[0] (Filesystem)
             # ADDR[1] (Size)
             # ADDR[2] (Used)
             # ADDR[3] (Available)
             # ADDR[4] (Percentage) 
           printf "%-15s\t%-10s\t%-10s\t%-10s\t%-10s\n" "$current_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" >> "$output_file"
       done
   done
   echo -e "\n" >> "$output_file"
}

# Function to generate Network Statistics report for the past week
generate_network_stats() {
   echo "Network Statistics (past week):" >> "$output_file"
   echo -e "Date\tRX packets/s\tTX packets/s\tRX KB/s\tTX KB/s" >> "$output_file" # Adding column headers

   for i in {1..7}; do
       current_date=$(date -d "$i days ago" +%d)
       sar -n DEV -f /var/log/sysstat/sa$current_date | while read line; do
           if [[ $line == DEV ]]; then
               continue
           fi
           IFS=' ' read -ra ADDR <<< "$line"
           printf "%-10s\t%-15s\t%-15s\t%-15s\t%-15s\n" "$current_date" "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}" >> "$output_file"
       done
   done

   echo -e "\n" >> "$output_file"
}

# Generate each section of the report
generate_cpu_report
generate_memory_report
generate_disk_report
generate_network_stats

echo "---------------------------------------------------------------------------------------"
echo "--System metrics report generated sucessfully into this directory ----> $output_file"--
echo "---------------------------------------------------------------------------------------"
echo "*"
echo "*"
echo "*"
echo "---------------------------------------------------------------------------------------"
echo "------------------RUNNING SCRIPT FOR ORACLE DATABASE SCHEMA BACKUP"--------------------
echo "---------------------------------------------------------------------------------------"

# ----------------------------------INSTRUCTIONS----------------------------------
# The below script will setup and establish a connection with oracle database.
# First you need to provide the details for connecting to your database, username,
# password, schema_name and remote host ip address
# --------------------------------------------------------------------------------

# Input parameters
username="TEST_USERNAME"
password="TEST_PASSWORD"
schema_name="TEST_ORACLE_SCHEMA"
remote_host="123.123.123.1"
remote_destination="$username@$remote_host:$HOME/backup/directory/schema_backup.dmp"

# This below script Checks if the username, password and schema_name 
# provided is valid, else it produce an error message

# Check if necessary parameters are provided
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$schema_name" ]; then
  echo "Please provide the necessary parameters to run the script"
	echo "Unable to connect to the remote destination. Invalid credentails!!"
else
	echo "Connected the $username@$remote_host..."
  echo "Backing up the $schema_name to the remote destination $remote_host..."
	sleep 1
	echo "Back up in progress..."
	sleep 2
  echo "Back up completed..."
  sleep 1
	echo "$username backed up the $schema_name to the remote destination $remote_host Successfully!"
  echo "Backup file is located at $remote_destination"
fi
echo "*"
echo "*"
echo "*"
echo "---------------------------------------------------------------------------"
echo "------------------RRUNNING SCRIPT FOR SENDING AN EMAIL"--------------------
echo "---------------------------------------------------------------------------"

# PRE-REQUISITES
# - Install mutt on your server
#       $ sudo apt install mutt

# - Make directories and files using the below commands
#       $ mkdir -p ~/.mutt/cache/bodies
#       $ mkdir ~/.mutt/cache/headers
#       $ touch ~/.mutt/certificates
#       $ touch ~/.mutt/muttrc

# - Edit the muttrc configuration file with the following details
            # set ssl_starttls=yes
            # set ssl_force_tls=yes
            
            # set imap_user = 'xxxxxx@gmail.com'
            # set imap_pass = 'Password'
            
            # set from='xxxxxxxx@gmail.com'
            # set realname='Your-Name'
            
            # set folder = imaps://imap.gmail.com/
            # set spoolfile = imaps://imap.gmail.com/INBOX
            # set postponed="imaps://imap.gmail.com/[Gmail]/Drafts"
            
            # set header_cache = "~/.mutt/cache/headers"
            # set message_cachedir = "~/.mutt/cache/bodies"
            # set certificate_file = "~/.mutt/certificates"
            
            # set smtp_url = 'smtps://xxxxxxxx@gmail.com:Passwordsmtp.gmail.com:465/'
            
            # set move = no
            # set imap_keepalive = 900 

# - Enable / Activate the muttrc configuration file
#       $ source ~/.mutt/muttrc

# - Start the mutt program
#       $ mutt

sender="ABDULMALIK OLOLADE"
subject="$sender Pre-Project Script"
recipient="malexmazzy@gmail.com"
body="Please find the attached files."

echo "Sending mail now..."
echo "$body" | mutt -s "$subject" -e "my_hdr From: $sender <$sender>" -a "$HOME/system_metrics_report.txt" -- "$recipient"

muttStat=$?

if [ $muttStat -eq 0 ]; then
    echo "----------------------------------------------------------------------------------"
    echo "---------------------------Mail sent successfully---------------------------------"
    echo "Message Body: >> $body"
    echo "Email sent from : >> $sender"
    echo "Subject of the Mail : >> $subject"
    echo "Attachment: >> system_metrics_report.txt"
    echo "----------------------------------------------------------------------------------"

else
    echo "Failed to send message"
fi
