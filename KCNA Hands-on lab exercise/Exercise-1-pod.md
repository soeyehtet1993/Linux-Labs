# Lab1-Pod

Running single container from the control node 

```bash
root@control-plane:~# kubectl run nginx --image=nginx
pod/nginx created
root@control-plane:~# kubectl get pods 
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          5s

root@control-plane:~# kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          5m10s   10.42.3.121   worker-2   <none>           <none>
```

Now nginx pod is running and we can also check the pod list via kubectl get pods -o wide

We can check the log of pod/nginx

```bash
root@control-plane:~# kubectl logs pod/nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/01/22 06:52:12 [notice] 1#1: using the "epoll" event method
2025/01/22 06:52:12 [notice] 1#1: nginx/1.27.3
2025/01/22 06:52:12 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14) 
2025/01/22 06:52:12 [notice] 1#1: OS: Linux 5.15.167.4-microsoft-standard-WSL2
2025/01/22 06:52:12 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/01/22 06:52:12 [notice] 1#1: start worker processes
2025/01/22 06:52:12 [notice] 1#1: start worker process 29
2025/01/22 06:52:12 [notice] 1#1: start worker process 30
2025/01/22 06:52:12 [notice] 1#1: start worker process 31
2025/01/22 06:52:12 [notice] 1#1: start worker process 32
2025/01/22 06:52:12 [notice] 1#1: start worker process 33
2025/01/22 06:52:12 [notice] 1#1: start worker process 34
2025/01/22 06:52:12 [notice] 1#1: start worker process 35
2025/01/22 06:52:12 [notice] 1#1: start worker process 36
2025/01/22 06:52:12 [notice] 1#1: start worker process 37
2025/01/22 06:52:12 [notice] 1#1: start worker process 38
2025/01/22 06:52:12 [notice] 1#1: start worker process 39
2025/01/22 06:52:12 [notice] 1#1: start worker process 40
2025/01/22 06:52:12 [notice] 1#1: start worker process 41
2025/01/22 06:52:12 [notice] 1#1: start worker process 42
2025/01/22 06:52:12 [notice] 1#1: start worker process 43
2025/01/22 06:52:12 [notice] 1#1: start worker process 44
root@control-plane:~# 
```

The IP address of pod/nginx is “10.42.3.121” and that pod is placed at worker-2 and we are going to ping from control node. 

```bash
root@control-plane:~# ping 10.42.3.121
PING 10.42.3.121 (10.42.3.121) 56(84) bytes of data.
64 bytes from 10.42.3.121: icmp_seq=1 ttl=63 time=0.102 ms
64 bytes from 10.42.3.121: icmp_seq=2 ttl=63 time=0.075 ms
64 bytes from 10.42.3.121: icmp_seq=3 ttl=63 time=0.088 ms
64 bytes from 10.42.3.121: icmp_seq=4 ttl=63 time=0.086 ms
^C
--- 10.42.3.121 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3131ms
rtt min/avg/max/mdev = 0.075/0.087/0.102/0.009 ms
```

The ping from control node to pod/nginx is successful. 

Now lets ping from worker-1 node and worker-2 node to pod/nginx

```bash
root@worker-1:~# ping 10.42.3.121
PING 10.42.3.121 (10.42.3.121) 56(84) bytes of data.
64 bytes from 10.42.3.121: icmp_seq=1 ttl=63 time=0.118 ms
64 bytes from 10.42.3.121: icmp_seq=2 ttl=63 time=0.119 ms
64 bytes from 10.42.3.121: icmp_seq=3 ttl=63 time=0.137 ms
```

```bash
root@worker-2:~# ping 10.42.3.121
PING 10.42.3.121 (10.42.3.121) 56(84) bytes of data.
64 bytes from 10.42.3.121: icmp_seq=1 ttl=64 time=0.043 ms
64 bytes from 10.42.3.121: icmp_seq=2 ttl=64 time=0.076 ms
64 bytes from 10.42.3.121: icmp_seq=3 ttl=64 time=0.044 ms
```

Now lets forward that pod/nginx to localhost:8080

```bash
root@control-plane:~# kubectl port-forward pod/nginx 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80

root@control-plane:~# curl http://localhost:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

now we can call [http://localhost:8080](http://localhost:8080) and we will create one pod with “curl image” [[https://hub.docker.com/r/curlimages/curl](https://hub.docker.com/r/curlimages/curl)] in order to access http://<ip_pod/nginx>from that container 

```bash
root@control-plane:~# kubectl run -it --rm web-test --image=curlimages/curl:8.11.1 --restart=Never -- http://10.42.3.121
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
pod "web-test" deleted
```

Explanation 

```bash
# -it = For interactive
# --rm = to remove the pod after exit 
# --restart=Never if fail, do not restart that pod 
```

Now the pod/web-test can call the  http://<ip_pod/nginx> successfully and delete the nginx pod now 

```bash
root@control-plane:~# kubectl delete pod/nginx
pod "nginx" deleted
```

We can also execute bash shell inside the container. Lets run the pod with alpine image

```bash
root@control-plane:~# kubectl run ubuntu --image=ubuntu /bin/bash
pod/ubuntu created
root@control-plane:~# kubectl get pods
NAME     READY   STATUS      RESTARTS   AGE
ubuntu   0/1     Completed   0          4s

#Explanation:
#kubectl run: Creates a pod with the specified parameters.
#ubuntu: The name of the pod.
#--image=ubuntu: Specifies the Ubuntu image.
#--restart=Never: Ensures a standalone pod is created rather than a deployment.
#-- /bin/bash: Executes the bash shell in the container.
```

⇒ If we run kubectl run ubuntu --image=ubuntu /bin/bash command, the ubuntu pod is immediately completed because the command /bin/bash was executed and immediately exited. Therefore we will sleep infinity to ubuntu pod. 

```bash
root@control-plane:~# kubectl run ubuntu --image=ubuntu -- sleep infinity
pod/ubuntu created

root@control-plane:~# kubectl get pods -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
ubuntu   1/1     Running   0          31s   10.42.1.4   worker-1   <none>           <none>
```

now the pod is running 

```bash
root@control-plane:~# kubectl exec -it pod/ubuntu -- bash
root@ubuntu:/# 
```

now we access inside the ubuntu container running at woker-1 node

Lets clean it now 

```bash
root@control-plane:~# kubectl delete pod/ubuntu --now
pod "ubuntu" deleted
root@control-plane:~# kubectl get pods -o wide
No resources found in default namespace.
```

=================================================================

### Running with manifest file

Now lets run the nginx image with .yaml file and export the yaml file first. 

```bash
root@control-plane:~# kubectl run nginx --image=nginx --dry-run=client -o yaml > nginx.yaml
root@control-plane:~# ls
nginx.yaml
```

- **`-dry-run=client`**:
- This flag ensures that the command only simulates the creation of the Pod without actually creating it in the cluster.
- The `client` value means the dry-run validation is performed locally on the client side

```bash
root@control-plane:~# cat nginx.yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@control-plane:~# kubectl get pods -o wide
No resources found in default namespace.
```

now we can see manifest file <nginx.yaml> but there is no pod/nginx yet. Let’s apply the nginx.yaml file.

```bash
root@control-plane:~# kubectl apply -f nginx.yaml 
pod/nginx created

root@control-plane:~# kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          51s   10.42.1.5   worker-1   <none>           <none>
```

Now Pod/nginx is running and delete the pod/nginx. 

```bash
root@control-plane:~# kubectl delete pod/nginx
pod "nginx" deleted
```

=================================================================

# Init Containers

Now lets crate a manifest file with .yaml format with the following command line 

```bash
root@control-plane:~# kubectl run init --image=nginx -o yaml --dry-run=client > init.yaml
root@control-plane:~# ls
init.yaml
```

now we generate the init.yaml file. lets modify it 

the old yaml file is 

```bash
root@control-plane:~# cat init.yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: init
  name: init
spec:
  containers:
  - image: nginx
    name: init
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

now we modify by adding the initcontainer

```bash
root@control-plane:~# cat init.yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: init
  name: init
spec:
  initContainers:
  - name: init-container
    image: busybox
    command : ['sh','-c','echo "running init container"; sleep 5; echo "Done for init container"'] 
  containers:
  - image: nginx
    name: main-container
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

Lets apply the manifest file 

```bash
root@control-plane:~# kubectl apply -f init.yaml 
pod/init created
```

Verification 

```bash
root@control-plane:~# kubectl describe pod init
Name:             init
Namespace:        default
Priority:         0
Service Account:  default
Node:             worker-1/172.20.0.3
Start Time:       Thu, 23 Jan 2025 08:07:12 +0000
Labels:           run=init
Annotations:      <none>
Status:           Running
IP:               10.42.1.7
IPs:
  IP:  10.42.1.7
Init Containers:
  init-container:
    Container ID:  containerd://1edc0cded8814730e1f75322ca542a56be292b3ff726dfaa2eb82a2acb15a632
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:a5d0ce49aa801d475da48f8cb163c354ab95cab073cd3c138bd458fc8257fbf1
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      echo "running init container"; sleep 5; echo "Done for init container"
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 23 Jan 2025 08:07:14 +0000
      Finished:     Thu, 23 Jan 2025 08:07:19 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zrprc (ro)
Containers:
  main-container:
    Container ID:   containerd://43990611888bb16ccc1e758a17a0411ee6002380c61266f3dfea67fdf22e9c3c
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:0a399eb16751829e1af26fea27b20c3ec28d7ab1fb72182879dcae1cca21206a
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 23 Jan 2025 08:07:20 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zrprc (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-zrprc:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m37s  default-scheduler  Successfully assigned default/init to worker-1
  Normal  Pulling    2m37s  kubelet            Pulling image "busybox"
  Normal  Pulled     2m36s  kubelet            Successfully pulled image "busybox" in 732ms (732ms including waiting). Image size: 2167089 bytes.
  Normal  Created    2m36s  kubelet            Created container init-container
  Normal  Started    2m36s  kubelet            Started container init-container
  Normal  Pulling    2m31s  kubelet            Pulling image "nginx"
  Normal  Pulled     2m30s  kubelet            Successfully pulled image "nginx" in 965ms (965ms including waiting). Image size: 72080558 bytes.
  Normal  Created    2m30s  kubelet            Created container main-container
  Normal  Started    2m30s  kubelet            Started container main-container
```

if we see state of init-container is Terminated and main-container state is still running. Lets check the log of init-container

```bash
root@control-plane:~# kubectl logs pod/init -c init-container
running init container
Done for init container
```

Now we will delete pod/init and delete the .yaml file.

```bash
root@control-plane:~# kubectl delete pod/init 
pod "init" deleted
root@control-plane:~# rm init.yaml 
```