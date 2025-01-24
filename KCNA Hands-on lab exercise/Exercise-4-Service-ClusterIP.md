# Exercise-4-Service-ClusterIP

## Cluster-IP Service

According to the lab exercise from James Spurin (Docker Captain, CNCF Ambassador, and Kubestronaut), we will use spurin/nginx-debug and we will create nginx deployment with 3 replicas.

We will generate nginx deployment manfiest file with yaml format.

```yaml
root@control-plane:~# kubectl create deployment nginx --image=spurin/nginx-debug --port=80 --replicas=5 -o yaml --dry-run=client > nginx.yaml
root@control-plane:~# ls
nginx.yaml
root@control-plane:~# cat nginx.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 5
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
      - image: spurin/nginx-debug
        name: nginx-debug
        ports:
        - containerPort: 80
        resources: {}
status: {}
root@control-plane:~# 
```

```yaml
root@control-plane:~# kubectl apply -f nginx.yaml 
deployment.apps/nginx created

root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS              RESTARTS   AGE   IP       NODE            NOMINATED NODE   READINESS GATES
nginx-5c96586dc6-f86j5   0/1     ContainerCreating   0          17s   <none>   worker-1        <none>           <none>
nginx-5c96586dc6-hh4zv   0/1     ContainerCreating   0          17s   <none>   control-plane   <none>           <none>
nginx-5c96586dc6-ld5fg   0/1     ContainerCreating   0          17s   <none>   worker-2        <none>           <none>
nginx-5c96586dc6-pdphw   0/1     ContainerCreating   0          17s   <none>   worker-1        <none>           <none>
nginx-5c96586dc6-zb9lh   0/1     ContainerCreating   0          17s   <none>   worker-2        <none>           <none>
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
nginx-5c96586dc6-f86j5   1/1     Running   0          30s   10.42.1.34   worker-1        <none>           <none>
nginx-5c96586dc6-hh4zv   1/1     Running   0          30s   10.42.0.34   control-plane   <none>           <none>
nginx-5c96586dc6-ld5fg   1/1     Running   0          30s   10.42.3.30   worker-2        <none>           <none>
nginx-5c96586dc6-pdphw   1/1     Running   0          30s   10.42.1.33   worker-1        <none>           <none>
nginx-5c96586dc6-zb9lh   1/1     Running   0          30s   10.42.3.31   worker-2        <none>           <none>
```

now there are 5 pods are running in woker-1, worker-2 and control plane. 

However, nginx deployment are not exposed yet and there is nginx service in the default namespace.

```yaml
root@control-plane:~# kubectl get service 
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   43h

root@control-plane:~# kubectl expose deployment/nginx
service/nginx exposed
root@control-plane:~# kubectl get service 
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP   43h
nginx        ClusterIP   10.43.203.60   <none>        80/TCP    3s

nginx        ClusterIP   10.43.203.60   <none>        80/TCP    3s
root@control-plane:~# kubectl get endpoints
NAME         ENDPOINTS                                               AGE
kubernetes   172.20.0.2:6443                                         43h
nginx        10.42.0.34:80,10.42.1.33:80,10.42.1.34:80 + 2 more...   2m5s
```

After we expose deployment/nginx, cluster IP service is used. Now lets see the detail of service/nginx.

```yaml
root@control-plane:~# kubectl describe service/nginx
Name:                     nginx
Namespace:                default
Labels:                   app=nginx
Annotations:              <none>
Selector:                 app=nginx
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.43.203.60
IPs:                      10.43.203.60
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
Endpoints:                10.42.3.30:80,10.42.0.34:80,10.42.3.31:80 + 2 more...
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>
```

We are now trying to curl the cluster IP which is 10.43.203.60. 

```bash
root@control-plane:~# curl http://10.43.203.60
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-hh4zv</em></p>
<p><em>IP Address: 10.42.0.34:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: 8ff3746506542d16c44735eaa810998a</em></p>
</body>
</html>
root@control-plane:~# curl http://10.43.203.60
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-ld5fg</em></p>
<p><em>IP Address: 10.42.3.30:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: f90acf4095e9b96c8e0fc23f0e8bf7fb</em></p>
</body>
</html>
root@control-plane:~# curl http://10.43.203.60
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-ld5fg</em></p>
<p><em>IP Address: 10.42.3.30:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: 4ed22b24e984ecfa3430ab508ad31626</em></p>
</body>
</html>
root@control-plane:~# curl http://10.43.203.60
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-ld5fg</em></p>
<p><em>IP Address: 10.42.3.30:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: 112e83155e5597d8ba8927911f6497c7</em></p>
</body>
</html>
root@control-plane:~# curl http://10.43.203.60
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-f86j5</em></p>
<p><em>IP Address: 10.42.1.34:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: 7289c4df09a99a4dad25c955f44e7b6f</em></p>
</body>
</html>
```

Now if we see, the traffic is load balanced between the pods [ <p><em>IP Address: 10.42.0.34:80</em></p>, <p><em>IP Address: 10.42.3.30:80</em></p>, <p><em>IP Address: 10.42.1.34:80</em></p>] 

We will also curl with DNS name which <my-svc.my-namespace.svc.cluster.local> by running another pod with the curl image and curl from that pod. Now the pod with pod/curl has been running.

```bash
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE    IP           NODE            NOMINATED NODE   READINESS GATES
curl                     1/1     Running   0          110s   10.42.3.33   worker-2        <none>           <none>
nginx-5c96586dc6-f86j5   1/1     Running   0          24m    10.42.1.34   worker-1        <none>           <none>
nginx-5c96586dc6-hh4zv   1/1     Running   0          24m    10.42.0.34   control-plane   <none>           <none>
nginx-5c96586dc6-ld5fg   1/1     Running   0          24m    10.42.3.30   worker-2        <none>           <none>
nginx-5c96586dc6-pdphw   1/1     Running   0          24m    10.42.1.33   worker-1        <none>           <none>
nginx-5c96586dc6-zb9lh   1/1     Running   0          24m    10.42.3.31   worker-2        <none>           <none>

root@control-plane:~# kubectl run --rm -it curl --image=curlimages/curl --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
~ $ 

root@control-plane:~# kubectl run --rm -it curl --image=curlimages/curl --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
~ $ curl nginx.default.svc.cluster.local
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-hh4zv</em></p>
<p><em>IP Address: 10.42.0.34:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: c90489bbaaccaf957bb97586cb1ce691</em></p>
</body>
</html>
~ $ 
```

We will clean every resource we test.

```bash
root@control-plane:~# kubectl delete deployment/nginx --now
deployment.apps "nginx" deleted

root@control-plane:~# kubectl get pods -o wide
No resources found in default namespace.

root@control-plane:~# kubectl get service
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP   44h
nginx        ClusterIP   10.43.203.60   <none>        80/TCP    25m
```

When we delete the deployment, pods are also deleted. However nginx service is still exposed. 

```bash
root@control-plane:~# kubectl delete service/nginx --now
service "nginx" deleted
```