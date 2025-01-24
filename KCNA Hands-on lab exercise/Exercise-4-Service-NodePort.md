# Exercise-4-Service-NodePort

Now we will rerun the nginx.yaml file what we used in the previous lab. 

```bash
root@control-plane:~# kubectl apply -f nginx.yaml 
deployment.apps/nginx created
root@control-plane:~# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
nginx-5c96586dc6-24h66   1/1     Running   0          4s    10.42.1.39   worker-1        <none>           <none>
nginx-5c96586dc6-9s8pz   1/1     Running   0          4s    10.42.3.34   worker-2        <none>           <none>
nginx-5c96586dc6-dk48s   1/1     Running   0          4s    10.42.1.38   worker-1        <none>           <none>
nginx-5c96586dc6-drkd6   1/1     Running   0          4s    10.42.3.35   worker-2        <none>           <none>
nginx-5c96586dc6-nbpfx   1/1     Running   0          4s    10.42.0.35   control-plane   <none>           <none>

root@control-plane:~# kubectl get services 
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   44h
root@control-plane:~# kubectl get deployment
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   5/5     5            5           58s
root@control-plane:~# kubectl get replicasets
NAME               DESIRED   CURRENT   READY   AGE
nginx-5c96586dc6   5         5         5       64s
```

We will expose the nginx service again as NodePort type. 

```bash
root@control-plane:~# kubectl expose deployment/nginx --type=NodePort
service/nginx exposed
root@control-plane:~# kubectl get service
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP        44h
nginx        NodePort    10.43.253.90   <none>        80:31063/TCP   5s

root@control-plane:~# kubectl get nodes -o wide
NAME            STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION                       CONTAINER-RUNTIME
control-plane   Ready    control-plane,master   44h   v1.31.0+k3s1   172.20.0.2    <none>        Ubuntu 22.04.2 LTS   5.15.167.4-microsoft-standard-WSL2   containerd://1.7.20-k3s1
worker-1        Ready    <none>                 44h   v1.31.0+k3s1   172.20.0.5    <none>        Ubuntu 22.04.2 LTS   5.15.167.4-microsoft-standard-WSL2   containerd://1.7.20-k3s1
worker-2        Ready    <none>                 44h   v1.31.0+k3s1   172.20.0.4    <none>        Ubuntu 22.04.2 LTS   5.15.167.4-microsoft-standard-WSL2   containerd://1.7.20-k3s1
```

now we see that the type is “NodePort” for service/nginx.

80:32613/TCP means 

80 = Port listening on our deployment/application (app side)  

32613 = Port Listening on each of our Kubernetes Node (node side)

The control plane IP is 172.20.0.2.

Now lets curl from one of the worker-control curl <control_plane>:32613

```bash
root@worker-1:~# curl 172.20.0.2:31063
<!DOCTYPE html>
<body>
<p><em>Hostname: nginx-5c96586dc6-9s8pz</em></p>
<p><em>IP Address: 10.42.3.34:80</em></p>
<p><em>URL: /</em></p>
<p><em>Request Method: GET</em></p>
<p><em>Request ID: 7a60ead00a14ff0cba540e74ffcccf94</em></p>
</body>
</html>
root@worker-1:~# 
```

I will delete service/nginx. 

```bash
root@control-plane:~# kubectl delete service/nginx
service "nginx" deleted
```