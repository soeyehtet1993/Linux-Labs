# Automating Nginx Deployment with Ansible

# Lab Objective

1. Run the Ansible Container and Two Ubuntu Containers
2. Install Nginx Service in two Ubuntu Containers via Ansible Playbook

# Number of components

| Type | Name | Quantity |
| --- | --- | --- |
| Container | Ansible | 1 |
| Container | Ubuntu | 2 |
| YAML File | docker-compose | 1 |
| INI | inventory | 1 |
| YAML File | nginx-setup | 1 |

# Required Files for this lab

docker-compose.yml [Purpose: To run the containers]

```yaml
services:
  ansible-control:
    image: quay.io/ansible/ansible-runner
    container_name: ansible-control
    volumes:
      - E:/Study/Ansible/playbook:/ansible # to store Ansible playbooks persistently. Please change the path from E:/Study/Ansible according to your test.
    networks:
      - ansible_network
    tty: true # For TTY
    stdin_open: true # For Interactive
    command: |
      /bin/bash -c "
      mkdir -p ~/.ssh && \
      mkdir -p /ansible && \
      ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N '' && \
      sshpass -p 'ansible' ssh-copy-id -o StrictHostKeyChecking=no ansible@web-server-1 && \
      sshpass -p 'ansible' ssh-copy-id -o StrictHostKeyChecking=no ansible@web-server-2 && \
      tail -f /dev/null
      "
#sshpass command is for each web server. 
  web-server-1:
    image: docker.io/08061993/ssh:ubuntu
    container_name: web-server-1
    ports:
      - 80:80
    networks:
      - ansible_network
    tty: true
    stdin_open: true
  web-server-2:
    image: docker.io/08061993/ssh:ubuntu
    container_name: web-server-2
    ports:
      - 81:80
    networks:
      - ansible_network
    tty: true
    stdin_open: true

networks:
  ansible_network:

```

inventory [Purpose: To use as the inventory for ansible]

```bash
[web]
web-server-1 ansible_host=web-server-1 ansible_user=ansible ansible_ssh_pass=ansible
web-server-2 ansible_host=web-server-2 ansible_user=ansible ansible_ssh_pass=ansible
```

nginx_setup.yml  [Purpose: Ansible Playbook]

```bash
---
- name: Instllation Nginx Service
  hosts: web
  become: yes
  tasks:
    - name: Install Nginx\
      apt:
        name: nginx
        state: present
    - name: Start Nginx Service
      service:
        name: nginx
        state: started
```

Local Folder Structure in Window OS Host

```bash
E:/
│── Study
│	│── Ansible
│	│	│── docker-compose.yml
│	│	│	│── playbook/
│	│	│	│	│   ├── inventory
│	│	│	│	│   ├── nginx_setup.yml
```

Since SSH connection is required for ansible, ssh connection has been built in docker-compose.yml file.

### Start the Lab

Run the docker compose file in order to build the ansible-control, web-server-1 and web-server-2

```yaml
PS E:\Study\Ansible> docker compose up -d
[+] Running 4/4
 ✔ Network ansible_ansible_network  Created                                                                        0.0s
 ✔ Container ansible-control        Started                                                                        0.9s
 ✔ Container web-server-2           Started                                                                        0.9s
 ✔ Container web-server-1           Started                                                                        0.9s
PS E:\Study\Ansible> docker exec -it ansible-control bash
bash-4.4# cd /ansible
```

Verifying the number of running containers

```bash
PS E:\Study\Ansible> docker ps
CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS
               NAMES
a30fd0df0929   08061993/ssh:ubuntu              "/usr/sbin/sshd -D -e"   41 minutes ago   Up 41 minutes   22/tcp, 0.0.0.0:81->80/tcp   web-server-2
a404bbd9a1ef   08061993/ssh:ubuntu              "/usr/sbin/sshd -D -e"   41 minutes ago   Up 41 minutes   22/tcp, 0.0.0.0:80->80/tcp   web-server-1
810685d5ba73   quay.io/ansible/ansible-runner   "entrypoint /bin/bas…"   41 minutes ago   Up 41 minutes
               ansible-control
```

Verifying the SSH and nginx status in web-server-1 and web-server-2 before we run the ansible playbook.

In web-server-1 container

```yaml
PS C:\Users\soeye> docker exec -it web-server-1 bash
root@18a1fac9807e:/# service ssh status
 * sshd is running
root@18a1fac9807e:/# service nginx status
nginx: unrecognized service
root@18a1fac9807e:/#
```

In web-server-2 container

```yaml
PS C:\Users\soeye> docker exec -it web-server-2 bash
root@3f3a5c795bb9:/# service ssh status
 * sshd is running
root@3f3a5c795bb9:/# service nginx status
nginx: unrecognized service
root@3f3a5c795bb9:/#
```

As we can see, nginx service is unrecognized while ssh service is running.

Now we run the ansible playbook with the file name ‘nginx_setup.yml’

```bash
bash-4.4# ansible-playbook -i inventory nginx_setup.yml

PLAY [Instllation Nginx Service] ***************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [web-server-1]
ok: [web-server-2]

TASK [Install Nginx\] **************************************************************************************************
changed: [web-server-1]
changed: [web-server-2]

TASK [Start Nginx Service] *********************************************************************************************
changed: [web-server-1]
changed: [web-server-2]

PLAY RECAP *************************************************************************************************************
web-server-1               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web-server-2               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

bash-4.4#
```

Verifying the SSH and nginx status in web-server-1 and web-server-2 after we run the ansible playbook.

In web-server-1 container

```bash
PS C:\Users\soeye> docker exec -it web-server-1 bash
root@a404bbd9a1ef:/# service nginx status
 * nginx is running
```

In web-server-2 container

```bash
PS C:\Users\soeye> docker exec -it web-server-2 bash
root@a30fd0df0929:/# service nginx status
 * nginx is running
```

Now nginx service is running in web-server-1 and web-server-2

Since we expose the port for web-server-1 and web-server-2 at port 80 and 81, we will verify the nginx service via making the http request to “http://localhost:80” and “http://localhost:81” with curl command.

```bash
PS C:\Users\soeye> curl http://localhost:80

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }                                                                                      body { width: 35em; margin: 0 auto;                                                                                     font-family: Tahoma, Verdana, Arial, sans-serif; }                                                                      </style...                                                                                          RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 615
                    Content-Type: text/html
                    Date: Sat, 15 Feb 2025 06:41:36 GMT
                    ETag: "67b0355a-267"
                    Last-Modified: Sat, 15 Feb 2025 ...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615], [Content-Type,
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=nginx.org; innerText=nginx.org; outerHTML=<A href="http://nginx.org/">nginx.org</A>;
                    outerText=nginx.org; tagName=A; href=http://nginx.org/}, @{innerHTML=nginx.com;
                    innerText=nginx.com; outerHTML=<A href="http://nginx.com/">nginx.com</A>; outerText=nginx.com;
                    tagName=A; href=http://nginx.com/}}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 615

PS C:\Users\soeye> curl http://localhost:81

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 615
                    Content-Type: text/html
                    Date: Sat, 15 Feb 2025 06:41:44 GMT
                    ETag: "67b0355b-267"
                    Last-Modified: Sat, 15 Feb 2025 ...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615], [Content-Type,
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=nginx.org; innerText=nginx.org; outerHTML=<A href="http://nginx.org/">nginx.org</A>;
                    outerText=nginx.org; tagName=A; href=http://nginx.org/}, @{innerHTML=nginx.com;
                    innerText=nginx.com; outerHTML=<A href="http://nginx.com/">nginx.com</A>; outerText=nginx.com;
                    tagName=A; href=http://nginx.com/}}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 615
```

As we can send the http request to “http://localhost:80” and “http://localhost:81” with curl command, we can say the verification is success.
