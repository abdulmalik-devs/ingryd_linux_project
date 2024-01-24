# NFS Project Setup

This repository outlines the steps to set up a Network File System (NFS) project involving two Ubuntu virtual machines on VirtualBox. The project aims to establish communication between the server and client VMs, create shared directories on the server, and mount them on the client using NFS.

## Table of Contents
1. [Virtual Machine Setup](#virtual-machine-setup)
2. [Static Network Configuration](#static-network-configuration)
3. [Shared Directory Setup on Server](#shared-directory-setup-on-server)
4. [NFS Server Installation and Configuration](#nfs-server-installation-and-configuration)
5. [Client Setup](#client-setup)
   - [Installing NFS-Common](#installing-nfs-common)
   - [Mounting Shared Directories](#mounting-shared-directories)
   - [Unmounting Shared Directories](#unmounting-shared-directories)
   - [Persistence Setup](#persistence-setup)
   - [On-Demand Mounting with Autofs](#on-demand-mounting-with-autofs)

## 1. Virtual Machine Setup

Create two Ubuntu virtual machines on VirtualBox and configure the network settings with a bridge network adapter to establish communication between the VMs.

![Screenshot 2024-01-23 040019](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/0f64b6a3-989f-451e-aac4-5db2a9cb6ab5)

![Screenshot 2024-01-23 040053](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/1f534a35-d62c-49eb-8912-b82b9f964b45)

![Screenshot 2024-01-23 040105](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/e1b78d1e-a70f-4646-a44a-aa3f55b5d603)

![Screenshot 2024-01-23 040121](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/5b8c5398-7709-478a-96f8-f260a485a09d)

![Screenshot 2024-01-23 040150](https://github.com/abdulmalik-devs/terraform-ecommerce/assets/62616273/25aab10c-9720-421b-85d5-bea451215c51)

## 2. Static Network Configuration

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


## 3. Shared Directory Setup on Server

Create a parent directory on the server VM and two subdirectories. Give the directories recursive permissions using the following command:

```bash
sudo mkdir -p /exports
sudo mkdir /exports/backup
sudo mkdir /exports/sharedDocs
chmod -R 777 /exports
```

## 4. NFS Server Installation and Configuration

Install the NFS server on the server VM:

```bash
sudo apt-get update
sudo apt-get install nfs-kernel-server
```

Check the status of the NFS server:

```bash
sudo systemctl status nfs-kernel-server
```

Edit the export configuration file (`/etc/exports`) to include the directories for the shared folder to the client VM.

```bash
/exports/backup     client-ip(rw,sync,no_subtree_check)
/exports/sharedDoc     client-ip(rw,sync,no_subtree_check)
```

## 5. Client Setup

### 5.1 Installing NFS-Common

On the client VM, install NFS-Common:

```bash
sudo apt-get update
sudo apt-get install nfs-common
```

To view the shared directoires On the client VM

```bash
showmount --export server-ip
```

### 5.2 Mounting Shared Directories

Create mount points for the shared directories:

```bash
sudo mkdir -p /mnt/nfs/backup
sudo mkdir -p /mnt/nfs/sharedDoc
```

Mount the directories:

```bash
sudo mount <server-ip>:/exports/backup /mnt/nfs/backup
sudo mount <server-ip>:/exports/sharedDoc /mnt/nfs/sharedDoc
```

### 5.3 Unmounting Shared Directories

To unmount, type:

```bash
sudo umount /mnt/nfs/backup
sudo umount /mnt/nfs/sharedDoc
```

### 5.4 Persistence Setup

To make the mount point persistent, add the following line to `/etc/fstab`:

```bash
<server-ip>:/exports/backup /mnt/nfs/backup nfs defaults 0 0
<server-ip>:/exports/sharedDoc /mnt/nfs/sharedDoc nfs defaults 0 0
```

## 5.5 On-Demand Mounting with Autofs

Install Autofs on the client VM:

```bash
sudo apt-get install autofs
```

Edit the `/etc/auto.master` with the below config

```bash
/mnt/nfs    /etc/auto.nfs --ghost --timeout=30
```

and `/etc/auto.nfs` config.

```bash
backup  -fstype=nfs4,rw server-ip:/exports/backup
sharedDoc  -fstype=nfs4,rw server-ip:/exports/sharedDoc
```

Restart Autofs:

```bash
sudo systemctl restart autofs
```

Now, the shared directories should be accessible on-demand using Autofs.

You have successfully set up NFS between the server and client VMs with the ability to mount shared directories persistently or on-demand using Autofs.