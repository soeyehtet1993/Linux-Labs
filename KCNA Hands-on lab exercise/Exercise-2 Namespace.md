# Exercise-2 Namespace

First, lets see how many current namespaces in Kubernetes cluster

```bash
root@control-plane:~# kubectl get namespaces
NAME              STATUS   AGE
default           Active   23h
kube-node-lease   Active   23h
kube-public       Active   23h
kube-system       Active   23h
```

There are four namespaces in our kubernetes cluster and the detail about namespace can be found in [namespace](https://www.notion.so/namespace-17ba7f93ac8180a1b7e6f42cb8263f69?pvs=21) 

Now lets create the one namespace which is “soenamespace”

```bash
root@control-plane:~# kubectl create namespace soenamespace
namespace/soenamespace created

root@control-plane:~# kubectl get namespaces
NAME              STATUS   AGE
default           Active   23h
kube-node-lease   Active   23h
kube-public       Active   23h
kube-system       Active   23h
soenamespace      Active   74s
```

now we will create nginx pod with 

```bash
root@control-plane:~# kubectl run nginx --image=nginx 
pod/nginx created

root@control-plane:~# kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          26s   10.42.3.5   worker-2   <none>           <none>
```

Lets look detail about pod/nginx 

```bash
root@control-plane:~# kubectl describe pod/nginx
Name:             nginx
Namespace:        default
Priority:         0
Service Account:  default
Node:             worker-2/172.20.0.5
Start Time:       Thu, 23 Jan 2025 08:38:42 +0000
Labels:           run=nginx
Annotations:      <none>
Status:           Running
IP:               10.42.3.5
IPs:
  IP:  10.42.3.5
Containers:
  nginx:
    Container ID:   containerd://d75196ceee017421646072b9d11bb8c9774384a4427d0d6d477b643b4322db32
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:0a399eb16751829e1af26fea27b20c3ec28d7ab1fb72182879dcae1cca21206a
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 23 Jan 2025 08:38:54 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-r8kd2 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-r8kd2:
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
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  2m    default-scheduler  Successfully assigned default/nginx to worker-2
  Normal  Pulling    2m    kubelet            Pulling image "nginx"
  Normal  Pulled     109s  kubelet            Successfully pulled image "nginx" in 11.147s (11.147s including waiting). Image size: 72080558 bytes.
  Normal  Created    109s  kubelet            Created container nginx
  Normal  Started    109s  kubelet            Started container nginx
```

If we look carefully pod/nginx is running in default namespace. We will look how many running pod in “soenamespace” by using the following command and there is no pod in “soenamesapce”

```bash
root@control-plane:~# kubectl -n soenamespace get pods
No resources found in soenamespace namespace.
```

now we will run nginx-soe pod in soenamespace.

```bash
root@control-plane:~# kubectl get pods -o wide -n soenamespace
NAME        READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
nginx-soe   1/1     Running   0          14s   10.42.1.8   worker-1   <none>           <none>
```

Lets look detain about pod/nginx-soe

```bash
root@control-plane:~# kubectl describe -n soenamespace pod/nginx-soe
Name:             nginx-soe
Namespace:        soenamespace
Priority:         0
Service Account:  default
Node:             worker-1/172.20.0.3
Start Time:       Thu, 23 Jan 2025 08:49:25 +0000
Labels:           run=nginx-soe
Annotations:      <none>
Status:           Running
IP:               10.42.1.8
```

now pod/nginx-soe is running in soenamespace. 

now lets clear the pod/nginx and soenamespace

```bash
root@control-plane:~# kubectl get pods --all-namespaces
NAMESPACE      NAME                                      READY   STATUS    RESTARTS      AGE
default        nginx                                     1/1     Running   0             14m
kube-system    coredns-5dd589bf46-fjc4z                  1/1     Running   1 (85m ago)   24h
kube-system    local-path-provisioner-846b9dcb6c-g4x4t   1/1     Running   2 (84m ago)   24h
kube-system    metrics-server-5dc58b587c-xvj8r           1/1     Running   2 (84m ago)   24h
soenamespace   nginx-soe                                 1/1     Running   0             3m46s
root@control-plane:~# kubectl delete namespace/soenamespace --now 
namespace "soenamespace" deleted
```

```bash
oot@control-plane:~# kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS      AGE
default       nginx                                     1/1     Running   0             16m
kube-system   coredns-5dd589bf46-fjc4z                  1/1     Running   1 (86m ago)   24h
kube-system   local-path-provisioner-846b9dcb6c-g4x4t   1/1     Running   2 (86m ago)   24h
kube-system   metrics-server-5dc58b587c-xvj8r           1/1     Running   2 (86m ago)   24h
```

When we delete the soenamespace, nginx-soe pod is also deleted.

```bash
root@control-plane:~# kubectl delete pod/nginx
pod "nginx" deleted
```