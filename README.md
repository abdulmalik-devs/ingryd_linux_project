# Samba Project Setup

This repository contains the configuration files and steps for setting up a Samba server and client on two Ubuntu virtual machines using VirtualBox. The goal is to create a shared directory on the server VM accessible from both the client VM and a Windows machine.

## Table of Contents
1. [Virtual Machine Setup](#virtual-machine-setup)
2. [Static Network Configuration](#static-network-configuration)
3. [Samba Installation and Configuration](#samba-installation-and-configuration)
4. [Shared Directory Setup](#shared-directory-setup)
5. [Accessing the Shared Directory](#accessing-the-shared-directory)

## Virtual Machine Setup

Create two Ubuntu virtual machines on VirtualBox. Configure the network settings by setting the bridge network adapter to establish communication between the VMs.

--------------------------------------------------------------------------------------------------------------

![Screenshot 2024-01-23 040019](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/0f64b6a3-989f-451e-aac4-5db2a9cb6ab5)

![Screenshot 2024-01-23 040053](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/1f534a35-d62c-49eb-8912-b82b9f964b45)

![Screenshot 2024-01-23 040105](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/e1b78d1e-a70f-4646-a44a-aa3f55b5d603)

![Screenshot 2024-01-23 040121](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/5b8c5398-7709-478a-96f8-f260a485a09d)

![Screenshot 2024-01-23 040150](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/25aab10c-9720-421b-85d5-bea451215c51)


## Static Network Configuration

Configure a static network on both VMs using Netplan. Set the hostname for the server VM to "server" and for the client VM to "client." Add the hostnames with static IPs to the `/etc/hosts` file on each VM.


### Server VM
![Screenshot 2024-01-23 151806](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/485667da-9e10-4bbf-9ce4-36f9f64717b8)

### CLient VM
![Screenshot 2024-01-23 151751](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/b33001e2-00ad-4f7b-8752-34f1f69cb69d)


### On the Server VM type the below command
```bash
sudo hostnamectl set-hostname server
```

### On the Cleint VM type the below command
```bash
sudo hostnamectl set-hostname client
```

On the Server VM edit the hosts file to include both the server and client hostname with respective IP

```bash
sudo nano /etc/hosts
```
### Server VM
![Screenshot 2024-01-23 152343](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/ab6b3f09-90e6-4144-afe2-971847ee1f6d)

### Client VM
![Screenshot 2024-01-23 152316](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/1cc65440-a5a4-4720-9ab1-719a6ce35505)


## Samba Installation and Configuration

### Install the Samba package on the server VM by running:

```bash
sudo apt-get update
sudo apt-get install samba
```

### Create a share directory on the server VM and populate it with files. Provide read-write-execute (rwx) permissions to the directory by running:

```bash
sudo mkdir /share
sudo chmod 777 /share
cd /share
touch file1{1..3}.txt
```

### Create a Samba user and password for the shared directory using the following commands:

```bash
sudo useradd -s /sbin/nologin admin
sudo useradd -s /sbin/nologin finance
sudo useradd -s /sbin/nologin devs

sudo smbpasswd -a admin
sudo smbpasswd -a finace
sudo smbpasswd -a devs

```

Modify the Samba configuration file (`/etc/samba/smb.conf`) to include the shared path and specify users with specific permissions.

```bash
[shared_directory]
path = /share
public = yes
valid users = admin, finance, devs
read list = finance, devs
write list = admin
create mask - 0777
directory mask = 0777
browseable = yes
guest ok = yes
comment = "This is a shared directory for samba"
```
Use `sudo testparm` to verify and set the configuration file:

```bash
testparm
sudo service smbd restart
```

## Shared Directory Setup

The shared directory is now set up on the server VM with appropriate permissions and Samba configuration.

## Accessing the Shared Directory

### From the Client VM

Use the following command to access the shared directory:

```bash
smb://<server-ip>
```
### From a Windows Machine

1. Press `Win + R` to open the Run command dialog box.
2. Type `\\<server-ip>` and press Enter.
3. Provide the specific user credentials when prompted.

Now, you should have successfully set up and accessed the shared directory between the server VM, client VM, and a Windows machine.