# Project Overview

## Bash Script for File Backup, System Metrics Reporting, Oracle Database Schema Backup, and Email Notification

This repository contains a set of bash scripts designed to automate various tasks. The scripts perform the following four tasks:

1. **File Backup**: Automatically backs up specified files to a designated directory. If the backup directory doesn't exist, it creates one.

2. **System Metrics Reporting**: Generates a report on system metrics such as CPU usage, memory usage, disk usage, and network stats for the past week.

3. **Oracle Database Schema Backup:** Establishes a connection to an Oracle database and backs up a specified schema to a remote destination.

4. **Email Notification**: Sends an email notification with attachments of the system metrics report.

## Script Breakdown

### 1. File Backup

* **Functionality:**
    - Creates source and destination directories if they don't exist.
    - Creates specified files in the source directory if they don't exist.
    - Compresses files in the source directory into a .tar.gz archive.
    - Stores the archive in the destination directory.
* **Key Variables:**
    - `backup_destination`: Path to the backup destination directory.
    - `source_dir`: Path to the source directory containing files to be backed up.
    - `files`: Array of filenames to be backed up.

- **Usage:**
    ```bash
    ./backup_files.sh
    ```

### 2. System Metrics

* **Functionality:**
    - Generates reports for CPU, memory, disk, and network usage for the past week.
    - Saves the reports to a text file.
* **Key Variables:**
    - `output_file`: Path to the output file for the system metrics report.

- **Prerequisites:**
  - Install sysstat: `sudo apt-get install sysstat`
  - Install ifstat: `sudo apt-get install ifstat`

- **Usage:**
    ```bash
    ./system_metrics.sh
    ```

### 3. Oracle Database Schema Backup

* **Functionality:**
    - Connects to an Oracle database and backs up a specified schema to a remote host.
* **Key Variables:**
    - `username`: Database username.
    - `password`: Database password.
    - `schema_name`: Name of the schema to back up.
    - `remote_host`: IP address of the remote host for backup storage.
    - `remote_destination`: Full path to the backup file on the remote host.

- **Usage:**
    ```bash
    ./oracle_backup.sh
    ```

- **Instructions:**
  - Provide necessary parameters like `username`, `password`, `schema_name`, `remote_host`, and `remote_destination`.

### 4. Email Sending

* **Functionality:**
    - Uses the `mutt` command-line email client to send an email with the generated reports and backups as attachments.
* **Key Variables:**
    - `sender`: Email address of the sender.
    - `subject`: Subject of the email.
    - `recipient`: Email address of the recipient.
    - `body`: Body of the email.

- **Prerequisites:**
  - Install mutt: `sudo apt install mutt`

- **Usage:**
    ```bash
    ./send_email.sh
    ```

- **Instructions:**
  - Edit `muttrc` configuration file with your email details.
  - Ensure necessary directories and files are created.


### Additional Notes

* Please review and modify the scripts according to your system configuration.

* Ensure necessary permissions are granted to execute the scripts.

* The script provides informative output throughout its execution.

* It handles potential errors, such as invalid database credentials or email sending failures.

* It can be easily modified to customize backup directories, file names, email settings, and other parameters.

- For any issues or suggestions, contact the author via the provided email.

Feel free to contribute to the project and improve the scripts!


### Author

- **Author:** Abdulmalik Ololade
- **Contact:** [Abdulmalik Ololade](mailto:malexmazzy@gmail.com)