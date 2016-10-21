---
layout: post
title:  "Create Elasticsearch Snapshots"
date:   2014-12-06 12:40:37
categories: Tutorials
tags: Elasticsearch 
comments: true
---
<img class="image-left" src="/img/Elasticsearch-snapshots.png" width="150px"/>Benjamin Franklin once wrote “…in this world nothing can be said to be certain, except death and taxes”. In this computerized world of ours, I would add having to backup your data to free up disk space to that list of eventualities.

For Elasticsearch users, backups are done using the Elasticsearch snapshot facility. In this article I’ll go through the design of an Elasticsearch backup system that you can use to create snapshots of your cluster’s indices and documents.

<!--more-->

### Elasticsearch Snapshot Storage System

For Elasticsearch snapshots to work, you must first set up a shared storage node that is accessible to all the nodes in your cluster over the common network which connects all the systems. The shared storage node can be either another computer system with volumes that are mounted on each of the nodes or a network storage drive.

![](/img/Elasticsearch-Shared-Storage.png)

The system described in this article is the former variety, that uses an SMB file server to store the snapshots.

#### Configure Shared Storage Node

Setting up a SMB file server starts on the server side where you define the shared drives. Let’s assume that for the Elasticsearch cluster in this article there is one drive on the shared storage node that. Follow these steps to create a shared SMB drive:

1. Add this stanza to */etc/smb.conf* file identifying the shared drive:
   ```
    [snaps]  
        comment = Elasticsearch snapshot directory  
        path = /data/snapshots  
        public = yes  
        writable = yes  
        write list = +elasticsearch  
   ```  
   
   - `path` – location on the file server where snapshots will be stored.
   - `public` – set to yes to make he drive visible on the network
   - `writable` – set to yes to make the drive read/write.
   - `write list` – user permitted to mount the drive, in this case `elasticsearch` 
   
   Note that the path and settings are just an example. You should tailor them to your system needs.

2. If you want more than 1 shared drive, repeat step 1 for each drive.
3. Create a system and SMB user named `elasticsearch` by running these commands:
   ```
    adduser elasticsearch
    mbpasswd -a elasticsearch -p
   ```

4. Start the SMB file server with these commands:
   ```
    service smb start
    service nmb start
   ```

### Configure Mount Points on the Cluster Nodes

At this point you have an SMB file server running on the shared storage node.  Next let’s set up the mount points and mount the shared drive. Follow this procedure for each node in your Elasticsearch cluster.

1. Create a mount drive in */media* and set the ownership of it to `elasticsearch`.
   ```
    mkdir /media/snaps
    chown elasticsearch:elasticsearch /media/snaps
   ``` 

2. Add the following line to the */etc/fstab* file to be able to mount the shared drive on the SMB file server:
   ```
    //<SMB server IP>/snaps /media/snaps cifs  user,uid=UID,gid=GID,rw,exec,suid,auto,username=elasticsearch,password=PASSWORD   0 0
   ```
    
   - `SMB server IP` – IP address of the shared storage node.
   - `UID` – user ID of the `elasticsearch` user.
   - `GID` – group ID of the `elasticsearch` user.
   - `PASSWORD` – `elasticsearch` SMB password set in step 3 of the previous section.

3. With the entry you added to */etc/fstab*, you can then mount the shared drive like this:
   ```
    mount //<SMB server IP>/snaps
   ```


