# Exercise3-Deployment

```bash
root@control-plane:~# kubectl get deployment
No resources found in default namespace.
```

There is no current deployment in our default namespace. 

```bash
root@control-plane:~# root@control-plane:~# kubectl create deployment nginx --image=nginx --dry-run=client --replicas=3 -o yaml > deployment.yaml
root@control-plane:~# ls
deployment.yaml
```

I generate nginx deployment manifest file with nginx image as deployment.yaml with three replicas. 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```

We will now apply that file. 

```yaml
root@control-plane:~# kubectl apply -f deployment.yaml 
deployment.apps/nginx created
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
nginx-676b6c5bbc-brkhm   1/1     Running   0          15s   10.42.1.9    worker-1        <none>           <none>
nginx-676b6c5bbc-rplq5   1/1     Running   0          15s   10.42.0.11   control-plane   <none>           <none>
nginx-676b6c5bbc-xkbwp   1/1     Running   0          15s   10.42.3.6    worker-2        <none>           <none>
```

now three nginx pods are placed at worker-1, worker-2 and control-plane.

```yaml
root@control-plane:~# kubectl get deployment 
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   3/3     3            3           74s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   3         3         3       78s
```

if we see replicaset is created by deployment when we apply it. 

```yaml
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         <none>
```

There is only section in our rollout history and i will annotate this one as version-1

```yaml
root@control-plane:~# kubectl annotate deployment/nginx kubernetes.io/change-cause="version-1"
deployment.apps/nginx annotated
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
```

now i am going to delete the one pod/nginx-676b6c5bbc-brkhm. 

```yaml
root@control-plane:~# kubectl delete pod/nginx-676b6c5bbc-brkhm --now
pod "nginx-676b6c5bbc-brkhm" deleted
```

However, when we check the running pod list we will see new pod/nginx-676b6c5bbc-lpqfh is created and scheduled at worker-1. The replicaset will make sure the number of desired pod will always be 3.

```yaml
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP           NODE            NOMINATED NODE   READINESS GATES
nginx-676b6c5bbc-lpqfh   1/1     Running   0          6s      10.42.1.10   worker-1        <none>           <none>
nginx-676b6c5bbc-rplq5   1/1     Running   0          5m22s   10.42.0.11   control-plane   <none>           <none>
nginx-676b6c5bbc-xkbwp   1/1     Running   0          5m22s   10.42.3.6    worker-2        <none>           <none>
```

Now, I will scale the replica number from 3 to 10. 

```yaml
root@control-plane:~# kubectl scale deployment/nginx --replicas=10;
deployment.apps/nginx scaled
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP           NODE            NOMINATED NODE   READINESS GATES
nginx-676b6c5bbc-64rl5   1/1     Running   0          5s      10.42.1.12   worker-1        <none>           <none>
nginx-676b6c5bbc-7647r   1/1     Running   0          5s      10.42.3.8    worker-2        <none>           <none>
nginx-676b6c5bbc-7qr5x   1/1     Running   0          5s      10.42.1.13   worker-1        <none>           <none>
nginx-676b6c5bbc-jrlrt   1/1     Running   0          5s      10.42.0.12   control-plane   <none>           <none>
nginx-676b6c5bbc-lpqfh   1/1     Running   0          2m6s    10.42.1.10   worker-1        <none>           <none>
nginx-676b6c5bbc-lwmh2   1/1     Running   0          5s      10.42.1.11   worker-1        <none>           <none>
nginx-676b6c5bbc-rplq5   1/1     Running   0          7m22s   10.42.0.11   control-plane   <none>           <none>
nginx-676b6c5bbc-tp5ft   1/1     Running   0          5s      10.42.3.7    worker-2        <none>           <none>
nginx-676b6c5bbc-xkbwp   1/1     Running   0          7m22s   10.42.3.6    worker-2        <none>           <none>
nginx-676b6c5bbc-zzbsd   1/1     Running   0          5s      10.42.0.13   control-plane   <none>           <none>
```

now if we see the number of pods are increased from 3 to 10.

In the manifest file deployment.yaml, we will change the replica from 10 to 15. 

```yaml
root@control-plane:~# cat deployment.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 15
  selector:
    matchLabels:
      app: nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```

now we see that desired number of pod of the replicaset is changed from 10 to 15. 

```yaml
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   15        15        15      11m
```

```yaml
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
```

if you see, there is no rollout history if we change the replica in the manifest file. Now lets try to change the image from nginx to nginx:stable in the manifest file. 

```yaml
ot@control-plane:~# kubectl apply -f deployment.yaml 
deployment.apps/nginx configured
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   12        12        12      15m
nginx-7596bf6bfb   7         7         0       6s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   9         9         9       15m
nginx-7596bf6bfb   10        10        3       13s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   9         9         9       16m
nginx-7596bf6bfb   10        10        3       14s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   9         9         9       16m
nginx-7596bf6bfb   10        10        3       15s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   6         6         6       16m
nginx-7596bf6bfb   13        11        6       16s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   3         5         5       16m
nginx-7596bf6bfb   15        13        9       17s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   0         0         0       16m
nginx-7596bf6bfb   15        15        14      19s
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-676b6c5bbc   0         0         0       16m
nginx-7596bf6bfb   15        15        15      21s
```

If we carefully the changes, new replicaset is created and the number of pods are gradually increased in the new rollout and the number of desired pod in old replicaset become ‘0’.

```yaml
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
2         version-1
```

now lets annotate to revision 2 as “version-2”

```yaml
root@control-plane:~# kubectl annotate deployment/nginx kubernetes.io/change-cause="version-2"
deployment.apps/nginx annotated
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
2         version-2
```

```yaml
root@control-plane:~# kubectl describe pod/nginx-7596bf6bfb-74xkm
Name:             nginx-7596bf6bfb-74xkm
Namespace:        default
Priority:         0
Service Account:  default
Node:             worker-2/172.20.0.4
Start Time:       Fri, 24 Jan 2025 02:00:25 +0000
Labels:           app=nginx
                  pod-template-hash=7596bf6bfb
Annotations:      <none>
Status:           Running
IP:               10.42.3.14
IPs:
  IP:           10.42.3.14
Controlled By:  ReplicaSet/nginx-7596bf6bfb
Containers:
  nginx:
    Container ID:   containerd://34ce0a8872995319a0bbb21e073e588b6bdfbbad3aa2e9165b8ab67a08ac2cad
    Image:          nginx:stable
    Image ID:       docker.io/library/nginx@sha256:f2c6d8e7b81820cc0186a764d6558935b521e1a3404647247d329273e01a1886
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Fri, 24 Jan 2025 02:00:37 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-c585h (ro)
```

Now let change from nginx:stable to nginx:alpine in the deployment/nginx 

```yaml
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
2         version-2
3         version-2
4         version-2
```

now we see there are four revision and we will annotate latest deployment as “latest_version:alpine”. 

```yaml
root@control-plane:~# kubectl annotate deployment/nginx kubernetes.io/change-cause="latest_version:alpine"
deployment.apps/nginx annotated
root@control-plane:~# kubectl history deployment/nginx
error: unknown command "history" for "kubectl"
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         version-1
2         version-2
3         version-2
4         latest_version:alpine

```

```yaml
root@control-plane:~# kubectl describe pod/nginx-5b6959bd88-4bvgf
Name:             nginx-5b6959bd88-4bvgf
Namespace:        default
Priority:         0
Service Account:  default
Node:             worker-1/172.20.0.5
Start Time:       Fri, 24 Jan 2025 02:06:46 +0000
Labels:           app=nginx
                  pod-template-hash=5b6959bd88
Annotations:      <none>
Status:           Running
IP:               10.42.1.27
IPs:
  IP:           10.42.1.27
Controlled By:  ReplicaSet/nginx-5b6959bd88
Containers:
  nginx:
    Container ID:   containerd://5d1b1f2a33a188e5fa0097eae8b2739bc67d742a87be1767305be4258d4b9672
    Image:          nginx:alpine
```

now we see that the image of pod “nginx-5b6959bd88-4bvgf” is “nginx:alpine”. 

We will go back to the revision 1 where the image is “nginx”. 

```yaml
root@control-plane:~# kubectl rollout undo deployment --to-revision=1
deployment.apps/nginx rolled back
```

```yaml
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
nginx-676b6c5bbc-4lwz2   1/1     Running   0          29s   10.42.1.28   worker-1        <none>           <none>
nginx-676b6c5bbc-5lmcl   1/1     Running   0          27s   10.42.0.31   control-plane   <none>           <none>
nginx-676b6c5bbc-98lfg   1/1     Running   0          26s   10.42.3.28   worker-2        <none>           <none>
nginx-676b6c5bbc-d4qtr   1/1     Running   0          26s   10.42.0.32   control-plane   <none>           <none>
nginx-676b6c5bbc-jkc42   1/1     Running   0          29s   10.42.1.29   worker-1        <none>           <none>
nginx-676b6c5bbc-k7nrg   1/1     Running   0          26s   10.42.1.31   worker-1        <none>           <none>
nginx-676b6c5bbc-k9k42   1/1     Running   0          29s   10.42.0.29   control-plane   <none>           <none>
nginx-676b6c5bbc-ptjr6   1/1     Running   0          29s   10.42.3.25   worker-2        <none>           <none>
nginx-676b6c5bbc-qljhq   1/1     Running   0          24s   10.42.0.33   control-plane   <none>           <none>
nginx-676b6c5bbc-qqbc8   1/1     Running   0          29s   10.42.0.30   control-plane   <none>           <none>
nginx-676b6c5bbc-r45x9   1/1     Running   0          25s   10.42.1.32   worker-1        <none>           <none>
nginx-676b6c5bbc-sfqb9   1/1     Running   0          27s   10.42.3.27   worker-2        <none>           <none>
nginx-676b6c5bbc-tpjfg   1/1     Running   0          29s   10.42.3.26   worker-2        <none>           <none>
nginx-676b6c5bbc-v882q   1/1     Running   0          25s   10.42.3.29   worker-2        <none>           <none>
nginx-676b6c5bbc-xmfb7   1/1     Running   0          29s   10.42.1.30   worker-1        <none>           <none>
root@control-plane:~# kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
nginx-5b6959bd88   0         0         0       76m
nginx-676b6c5bbc   15        15        15      98m
nginx-6857fdb466   0         0         0       77m
nginx-7596bf6bfb   0         0         0       82m
```

Now there are 15 pods running and the replicaset “nginx-676b6c5bbc “ is reused as we rollback to revision 1. 

```yaml
root@control-plane:~# kubectl rollout history deployment/nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
2         version-2
3         version-2
4         latest_version:alpine
5         version-1
```

Now revision=1 is disappeared and it become number 5 with the “version-1” annotate. 

Lets check the detail about the one pod

```yaml
root@control-plane:~# kubectl describe pod/nginx-676b6c5bbc-4lwz2
Name:             nginx-676b6c5bbc-4lwz2
Namespace:        default
Priority:         0
Service Account:  default
Node:             worker-1/172.20.0.5
Start Time:       Fri, 24 Jan 2025 03:22:17 +0000
Labels:           app=nginx
                  pod-template-hash=676b6c5bbc
Annotations:      <none>
Status:           Running
IP:               10.42.1.28
IPs:
  IP:           10.42.1.28
Controlled By:  ReplicaSet/nginx-676b6c5bbc
Containers:
  nginx:
    Container ID:   containerd://279a7f54eb472abce56b90da46b2c0cd8a90a747abdc11d0536aa949ecec8ff2
    Image:          nginx
```

The image is now changed from nginx:alpine to nginx.

We will delete the deployment now. 

```yaml
root@control-plane:~# kubectl delete deployment/nginx
deployment.apps "nginx" deleted

root@control-plane:~# kubectl get pods -o wide
No resources found in default namespace.
root@control-plane:~# kubectl get deployment
No resources found in default namespace.
root@control-plane:~# kubectl get replicasets
No resources found in default namespace.
root@control-plane:~# kubectl get deployment replicasets
```

now we see when we delete the deployment, the pods and replicaset are also deleted.