---
layout: post
title: XEN PAE with LVM on IA-64
date: 2007-05-14
categories:
- Linux
tags:
- virtualisation
---
<p>Quick How to set up a XEN installation . The following howto describes a way to:</p>
<ul>
<li> install a host xen0 system using Debian IA-64 distro,</li>
<li> create LVM volumes for Virtual Machines,</li>
<li> create VMs using LVM volumes,</li>
<li> set up auto-run of the VMs.</li>
</ul>
<p><!--more--></p>
<p>The first step is to install a plain Debian hosting system. I have used for this an netinst image from here <a href="http://www.debian.org/devel/debian-installer/">http://www.debian.org/devel/debian-installer/</a>. I'm assuming that you have the machine connected to Internet, so downloading needed packages won't be a problem. However, you can download a full CD image if you prefer.</p>
<p>Then you boot the CD using EFI bootmanager and set up a standard Debian installation... *click*click*.</p>
<p>The version from 05/2007 that I have used, was using a 2.6.18-4-mckinley kernel.  When booted the new system, we have to install some tools:</p>
<pre colla="+">
aptitude install mercurial make gcc libncurses5-dev bzip2 screen \
 gettext patch binutils zlib1g-dev python-dev libssl-dev libx11-dev bridge-utils \
 iproute udev ssh lvm2 parted postfix modutils debootstrap yaird
</pre>
<p>Mercurial is a versioning SVN/CVS-like system, used by developers of XEN. Next, we issue the following commands:</p>
<pre colla="+">
cd /usr/src; 
hg clone http://xenbits.xensource.com/ext/xen-ia64-unstable.hg make \ 
   linux-2.6-xen-config CONFIGMODE=menuconfig make install-xen install-tools \
   install-kernels KERNELS="linux-2.6-xen0 linux-2.6-xenU"
</pre>
<p>Next, we have to edit elilo /etc/elilo.conf  config to put there our new kernel lines. After editing, mine looked like this:</p>
<pre colla="+">
boot=/dev/sda1
delay=3 
default=xen 
relocatable
image=/boot/vmlinuz-2.6.18-4-mckinley
label=Linux
root=/dev/sda2 
read-only 
initrd=/boot/initrd.img-2.6.18-4-mckinley
image=/boot/vmlinuz-2.6.18-xen0 
label=Xen 
root=/dev/sda2 
vmm=/boot/xen.gz 
read-only
append="com2=115200,8n1 console=com2 dom0_mem=3500M -- 
console=tty0 console=ttyS1,115200,8n1 root=/dev/sda2" 
</pre>
<p>Few words of comments. Look on the append line. <em> console=tty0 console=ttyS1,115200,8n1</em> gives you the ability of viewing the inside XEN kernel hypervisor boot messages on console <strong>tty0</strong> and additionally on the serial console <strong>ttyS1</strong>.</p>
<p> Next we run command <b>elilo -v</b><br />
and check if there are no warnings. Now, we have to create an initrd image of the xenU (guest) kernel modules for the Virtual Machines. We will do it using yaird, because it looks like mkinitrd is no longer supported by Debian.</p>
<div class="code">xen0-host:~# yaird 2.6.18-xenU -o /boot/initrd.img-2.6.18-xenU</div>
<h5>Setting up LVM</h5>
<p>Firstly, I assume that I have prepared a partition for LVM on /dev/sda4. My partition table looked like this:</p>
<pre colla="+">
parted /dev/sda print

Disk /dev/sda: 36.7GB 
Sector size (logical/physical): 512B/512B 
Partition Table: gpt  
Number  Start   End     Size    File system  Name  Flags 
1      17.4kB  130MB   130MB   fat16              boot 
2      130MB   10.1GB  10.0GB  ext3 
3      10.1GB  14.1GB  4000MB  linux-swap 
4      14.1GB  36.7GB  22.6GB                     lvm
</pre>
<p>Then we create:</p>
<ol>
<li>Physical LVM volume</li>
<li>Volume group using the above PV (Physical Volume) (I called it <strong>lvmxen</strong>)</li>
</ol>
<pre colla="+">
xen0-host:~# pvcreate /dev/sda4  
Physical volume "/dev/sda4" successfully created  
xen0-host:~# vgcreate lvmxen /dev/sda4  
Volume group "lvmxen" successfully created
</pre>
<p>Now, we have a ready Host XEN machine to run some Virtuals. Below, you can see a simple sample bash script that:   The last thing is to create a config file for virtual machine. In each config file you define a set of variables that dignifies each VM. The config file must be placed in <strong>/etc/xen</strong> or in <strong>/etc/xen/auto/</strong> if you want the VM to be run automatically after startup. Of course, most of them are common for a set of VMs. Check the sample below:</p>
<pre colla="+">
xen0-host:/etc/xen# cat test1.cfg

kernel = "/boot/vmlinuz-2.6.18-xenU"
ramdisk = "/boot/initrd.img-2.6.18-xenU"
memory = 1500
name = test1
root = "/dev/hda2 ro"
vif = [ 'mac=00:00:00:99:00:01, bridge=xenbr0' ]
disk = [ 'phy:/dev/lvmxen/test1,hda1,w', 'phy:/dev/lvmxen/test1-swap,hda2,w' ]

</pre>
<p>This sample is pretty obvious. One thing worth mentioning is the MAC address. MAC addresses of each VM's NIC must be unique. The line <strong>vif = [ 'mac=00:00:00:99:00:01, bridge=xenbr0' ]</strong> says: bind interface xenbr0 (so, first bridged interface from host machine) to first NIC in the VM, and give it MAC address 00:00:00:99:00:01. The MAC field can be left out, however, due that udevfs is used inside the guest machines, If you will decide not to put a static mac address there, the following will happen:</p>
<ul>
<li>each restart of the VM, the MAC will be set randomly from the available ones</li>
<li>udev will increment ethX number, as it will see it as a new NIC.</li>
</ul>
<p>Below you can find a simple bash script that automatically creates a virtual machine. The script has the following steps:</p>
<ul>
<li>Creates two LVM volumes, 8GB and 2GB. One for the / partition, and the second for the swap space of the VM.</li>
<li>Creates the ext3 filesystem,</li>
<li>mounts the volume in the filesystem,</li>
<li>install a clean Debian distro in the volume using debootstrap,</li>
<li>sets a hostname,</li>
<li>sets /etc/fstab of the VM.</li>
</ul>
<pre colla="+">
lvcreate lvmxen -L8GB -n test1
lvcreate lvmxen -L2GB -n test1-swap
mkfs.ext3 /dev/lvmxen/test1
mkdir -p /mnt/test1
mount /dev/lvmxen/test1 /mnt/test1
debootstrap etch /mnt/test1 http://ftp.pl.debian.org/debian
echo "test1" &gt; /mnt/test1/etc/hostname
echo -en "proc /proc proc defaults    0     0\n" &gt;
/mnt/test1/etc/fstab
echo -en "/dev/sda1    /          ext3    defaults,errors=remount-ro 0       1\n" >>  /mnt/test1/etc/fstab
echo -en "/dev/sda2       none        swap    sw         0      0\n" >> /mnt/test1/etc/fstab umount /mnt/test1
</pre>
<p>Last but not least...  Remember to set up your starting procedure:</p>
<pre colla="+">
ln -s /etc/init.d/xen-setup /etc/rc2.d/S93xen-setup 
ln -s /etc/init.d/xend /etc/rc2.d/S94xend 
ln -s /etc/init.d/xendomains /etc/rc2.d/S95xendomains 
</pre>
<p>Those lines say that you are starting the services in specified order in runlevel 2 automatically.  /etc/init.d/xend and /etc/init.d/xendomains are provided by XEN during the installation. /etc/init.d/xen-setup is my script that customizes the XEN network shape. This time it is quite simple:</p>
<pre colla="+">/etc/xen/scripts/network-bridge start</pre>
<p>This starts a bridge on the default NIC(Network Inteface Card). However, if you have multiple NICs, you may be using config like this:</p>
<pre colla="+">
/etc/xen/scripts/network-bridge start
/etc/xen/scripts/network-bridge start vifnum=2 netdev= eth2
/etc/xen/scripts/network-bridge start vifnum=3 netdev=eth3
/etc/xen/scripts/network-bridge start vifnum=4 netdev=eth4
/etc/xen/scripts/network-bridge start vifnum=5 netdev=eth5

</pre>
<p>Refer to the scripts inside /etc/xen/scripts/ for explanation of the arguments. You can do bridging physical interfaces with XEN virtual interfaces (as above) or NATing.</p>
<p>That's all! </p>
