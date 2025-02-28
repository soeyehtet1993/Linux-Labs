# Manage user privileges

There are two ubuntu machines which are ubuntu server and ubuntu client. 

Objective 1. Create the “client” user in client machine. 

Objective 2. Grant the administrator privilege to the client account by adding sudo group to “client” user.

Creating client account in client machine and set “/bin/bash” as the default shell for client user.

```bash
root@ubuntuclient:/home# useradd -m client -p client
root@ubuntuclient:/home# usermod client -s /bin/bash
soeyehtet@ubuntuclient:/home$ su - client
Password:
client@ubuntuclient:~$ 

```

In order to to grant the administrator privilege to “client” user we will simply add the “client” user to sudo group.

```bash
client@ubuntuclient:~$ sudo su
[sudo] password for client:
client is not in the sudoers file.

client@ubuntuclient:~$ exit
soeyehtet@ubuntuclient:~$ sudo su

soeyehtet@ubuntuclient:~$ groups
soeyehtet adm cdrom sudo dip plugdev lxd

soeyehtet@ubuntuclient:~$ groups client
client : client

soeyehtet@ubuntuclient:~$ sudo su

root@ubuntuclient:/home/soeyehtet# gpasswd --help
Usage: gpasswd [option] GROUP

Options:
  -a, --add USER                add USER to GROUP
  -d, --delete USER             remove USER from GROUP
  -h, --help                    display this help message and exit
  -Q, --root CHROOT_DIR         directory to chroot into
  -r, --remove-password         remove the GROUP's password
  -R, --restrict                restrict access to GROUP to its members
  -M, --members USER,...        set the list of members of GROUP
      --extrausers              use the extra users database
  -A, --administrators ADMIN,...
                                set the list of administrators for GROUP
Except for the -A and -M options, the options cannot be combined.

root@ubuntuclient:/home/soeyehtet# gpasswd -a client sudo
Adding user client to group sudo

root@ubuntuclient:/home/soeyehtet# groups client
client : client sudo
```

Now, client user belong to the “sudo” group and we can see “client” user now the administrator privilege.

```bash
soeyehtet@ubuntuclient:~$ su - client
Password:
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

client@ubuntuclient:~$ sudo su
[sudo] password for client:
root@ubuntuclient:/home/client#
```

Objective 3. Create the “server” user in server machine. 

Objective 4. Grant the administrator privilege to the “server” user by editing the sudoers file. 

First we will change the hostname of the server machine from “ubuntu” to “ubuntuserver” and reboot the machine.

```bash
root@ubuntu:~# cat /etc/hostname
ubuntuserver

root@ubuntu:~# cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 ubuntuserver

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

root@ubuntu:~# reboot

Last login: Fri Feb 28 16:47:48 2025 from 192.168.211.1
soeyehtet@ubuntuserver:~$
```

The hostname of server machine is now changed from “ubuntu” to “ubuntuserver”

We will add the “server” user.

```bash
soeyehtet@ubuntuserver:~$ sudo useradd server -m -s /bin/bash

soeyehtet@ubuntuserver:~$ sudo passwd server
New password:
Retype new password:
passwd: password updated successfully

soeyehtet@ubuntuserver:~$ groups server
server : server
soeyehtet@ubuntuserver:~$
```

Let’s modify the server user privilege in the sudoers file. 

```bash
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
```

Before adding, let me explain the meaning of this command 

Number 1 = who this policy for [in this example, this policy is for sudo group]

Number 2 = Host 

Number 3 = Run as user field (in this example, the second “ALL” here, means that the user at the sudo group can run the command as other regular user) 

Number 4 = Group field (In this example, the third “ALL” here, means that the users belong to the sudo group can run the command as any group) 

Number 5 = The list command that can be executed by sudo 

Now we understand meaning of the command line and we will add server user in the sudoer file 

```bash
soeyehtet@ubuntuserver:~$ sudo visudo
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
server ALL=(ALL:ALL) ALL

soeyehtet@ubuntuserver:~$ groups server
server : server
```

Now server user does not belong in the sudo group but that user should have the administrator privilege now.

```bash
soeyehtet@ubuntuserver:~$ su - server
Password:
server@ubuntuserver:~$ sudo su
[sudo] password for server:
root@ubuntuserver:/home/server#
```

As we can see “server” user can execute the sudo command.