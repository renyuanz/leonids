---
layout: post
title:  "Running Elasticsearch on Kubernetes"
date:   2016-10-16 12:40:37
categories: [tutorial]
tags: Elastisearch Kubernetes 
comments: true
---
[Kubernetes](http://kubernetes.io/){:target="_blank"} gives you the capabilities to easily spin up clusters to run your Docker application containers. As such, Kubernetes is an ideal environment for running [Elasticsearch](https://www.elastic.co/){:target="_blank"} clusters in the cloud.  

I’ve been working with Elasticsearch on Kubernetes quite a bit lately so I thought I’d share with you how you can deploy your own Elasticsearch cluster with all the latest bells and whistles.

<!--more-->

**Contents**
* TOC
{:toc}

### Build a Kubernetes Ready Elasticsearch Container
For starters, you’ll need an Elasticsearch Docker container that is tailored for Kubernetes, which you can get from the [pires/docker-elasticsearch-kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes){:target="_blank"} repo on Github.  The Dockerfile for this container installs all the necessary components for Elasticsearch including Elasticsearch itself (version 2.3.5_1 as of this writing) and the io.fabric8/elasticsearch-cloud-kubernetes plugin that enables the Elasticsearch nodes to discover each other without having to specify the IP addresses of the nodes in the elasticsearch.yml configuration file.  Get a copy of the [pires/docker-elasticsearch-kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes){:target="_blank"} repo then build your Elasticsearch image by running this command in the docker-elasticsearch-kubernetes directory:

{% highlight bash %}
docker build –t gcr.io/my_gke_project/elasticsearch:latest .
{% endhighlight %}

In this example, I’m assuming you have a Google Container Engine account that uses the default container registry at gcr.io and a GKE project called my_gke_project.  I’ve arbitrarily set the Elasticsearch image label to elasticsearch:latest.  You can, of course, use different settings that better suits your environment.

After building your Elasticsearch image, push it to your GKE account: 

{% highlight bash %}
gcloud docker push gcr.io/my_gke_project/elasticsearch:latest
{% endhighlight %}

### Elasticsearch Environment Variables
If you take a look at the elasticsearch.yml configuration file, included below, you’ll see a number of environment variables that enable you to customize your Elasticsearch cluster.

{% highlight ruby %}
cluster:
  name: ${CLUSTER_NAME}
node:
  master: ${NODE_MASTER}
  data: ${NODE_DATA}
network.host: ${NETWORK_HOST}
path:
  data: /data/data
  logs: /data/log
  plugins: /elasticsearch/plugins
  work: /data/work
bootstrap.mlockall: true
http:
  enabled: ${HTTP_ENABLE}
  compression: true
cloud:
  kubernetes:
    service: ${DISCOVERY_SERVICE}
    namespace: ${NAMESPACE}
discovery:
    type: kubernetes
    zen:
      minimum_master_nodes: ${NUMBER_OF_MASTERS}
index:
    number_of_shards: ${NUMBER_OF_SHARDS}
    number_of_replicas: ${NUMBER_OF_REPLICAS}
{% endhighlight %}
    
Checking the Dockerfile you can see that the [pires/docker-elasticsearch-kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes){:target="_blank"} repo is derived from [pires/docker-elasticsearch](https://github.com/pires/docker-elasticsearch){:target="_blank"}. The Dockerfile in that repo sets the Elasticsearch cluster defaults to create a cluster consisting of 1 node. Our cluster, however, will consist of separate master, data, and client nodes for better Elasticsearch performance so we'll have to customize these configuration settings in the Kubernetes service files later:

- `${NODE_MASTER}` – If set to true the node is eligible to elected as a master node. Master nodes control the cluster.

- `${NODE_DATA}` – If set to true the node will be a data node. Data nodes store data and perform data operations such as CRUD, search, and aggregations.
If both `${NODE_MASTER}` and `${NODE_DATA}` are set to true the node will act as a data node and is eligible to become a master node. If  both `${NODE_MASTER}` and `${NODE_DATA}` are set to false the node will be a dedicated client. Client nodes are essentially Elasticsearch command routers, forwarding cluster level requests to master nodes and data-related requests, such as search, to data nodes.

- `${NUMBER_OF_SHARDS}` – Set to the desired number of primary shards, usually 1 for every data node.

- `${NUMBER_OF_REPLICAS}` – Set the desired number of replica node sets. The total number of shards on your cluster is determined by this expression:
 
  ```
  Total Shards = ${NUMBER_OF_SHARDS}+${NUMBER_OF_SHARDS}*${NUMBER_OF_REPLICAS}
  ```

  Note that `${NUMBER_OF_SHARDS}` and `${NUMBER_OF_SHARDS}` are relevant only for data nodes, not master or client only nodes since they do not index data.
 
- `${NUMBER_OF_MASTERS}` – Sets the minimum number of master nodes that must be present in a cluster to for a master eligible mode to be elected master. Note this setting is only relevant for master eligible nodes. Data and client only nodes are not affected by this setting since they cannot become master nodes.

- `${ES_HEAP_SIZE}` – This variable is not exposed in the elasticsearch.yml file, instead it is baked into the Docker image. Set it to the amount of RAM that should be devoted to the Elasticsearch heap. Ideally for data only nodes, this value will be set to ½ the RAM, up to 30g, in which the Elasticsearch node container runs.

The path variables all map to directories that are created in the source Docker container obtained from [pires/docker-elasticsearch](https://github.com/pires/docker-elasticsearch){:target="_blank"}.

### Create Elasticsearch Kubernetes Services

#### Elasticsearch Kubernetes Cluster
Now that we have an Elasticsearch container let’s create the Kubernetes service files for our Elasticsearch cluster. The pires/kubernetes-elasticsearch-cluster repo on Github includes the Kubernetes service files that enable you to create an Elasticsearch cluster service that is comprised of dedicated master, data, and client nodes, like the one shown here, consisting of 2 client nodes, 4 data nodes, and 3 master nodes. I've created a fork of the this repo at [vichargrave/kubernetes-elasticsearch-cluster](https://github.com/vichargrave/kubernetes-elasticsearch-cluster){:target="_blank"} that includes the service modifications discussed in the sections that follow, so you could just clone mine to save yourself some time.

![](/img/Elasticsearch-Kubernetes-Cluster.png)

In the sections that follow we’ll modify the [pires/docker-elasticsearch-kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes){:target="_blank"} service files to use the Elasticsearch container image created earlier and to size the Elasticsearch cluster. I won’t go over all the settings in the files – the [Kubernetes online docs](http://kubernetes.io/docs/){:target="_blank"} do a better job of that. Instead I’ll focus on the lines that were added or modified to create the cluster and a few that could use some explaining.

#### Front End Service ####

The front end cluster Kubernetes service file is *es_svc.yaml*.  It sets up a load balancer on TCP port 9200 that distributes network traffic to the client nodes. 

{% highlight ruby linenos %}
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch
  namespace: es-cluster
  labels:
    component: elasticsearch
    role: client
spec:
  selector:
    component: elasticsearch
    role: client
  ports:
  - name: http
    port: 9200
    protocol: TCP
  type: LoadBalancer
{% endhighlight %}

**[Line 5]** The namespace is arbitrarily set to `es-cluster`. You can set this field to some other name according to your needs. Note you must create a namespace with this name before creating the Elasticsearch service and deployments.

**[Lines 7-12]** The component name is arbitrarily set to `elasticsearch`. You can set this field to some other name according to your needs.

**[Lines 15-16]** The service port and protocol define the TCP port on which the service will listen for connections.  In this case they are set to the traditional Elasticsearch values 9200 and TCP 9200 and TCP respectively.

#### Client Nodes

The Kubernetes service file for Elasticsearch client nodes is *es_client.yaml*. 

{% highlight ruby linenos %}
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: es-client
  namespace: es-cluster
  labels:
    component: elasticsearch
    role: client
spec:
  template:
    metadata:
      labels:
        component: elasticsearch
        role: client
    spec:
      containers:
      - name: es-client
        securityContext:
          privileged: true
          capabilities:
            add:
              - IPC_LOCK
        image: gcr.io/my_gke_project/elasticsearch:latest
        imagePullPolicy: Always
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: CLUSTER_NAME
          value: "my_es_cluster"
        - name: NODE_MASTER
          value: "false"
        - name: NODE_DATA
          value: "false"
        - name: HTTP_ENABLE
          value: "true"
        - name: ES_HEAP_SIZE
          value: "512m"
        ports:
        - containerPort: 9200
          name: http
          protocol: TCP
        - containerPort: 9300
          name: transport
          protocol: TCP
        resources:
          limits:
            memory: 1Gi
        volumeMounts:
        - name: storage
          mountPath: /data
      volumes:
          - emptyDir:
              medium: ""
            name: "storage"
{% endhighlight %}

**Note: The following settings are the same for client, data, and master nodes, so they will be mentioned here only**.

**[Line 5]** The namespace is arbitrarily set to `es-cluster`. You can set this field to some other name according to your needs, but it must match the name set in *es_svc.yaml*.

**[Lines 7-13]** The component names in the `metadata` and `spec` sections should match the component names in the *es-service.yaml* file.

**[Lines 18-22]** The `securityContext` must be set to `privileged` and the `IPC_LOCK` capability enabled to allow Elasticsearch to lock the heap in memory so it won’t be swapped.

**[Line 23]** Substituted the Elasticsearch image path created in the first section. 

**[Lines 26-29]** This section will get the namespace tag from the field of the same name under metadata.

**[Lines 30-31]** The cluster name is arbitrarily set to `my_es_cluster`. You can set it to whatever name you find appropriate, but the name chosen must be the same across all deployment file.

**Note: These settings are specific to each kind of node**.

**[Lines 32-35]** To create an Elasticsearch client node set the `NODE_MASTER` to  `false` and the `NODE_DATA` to  `false`.

**[Lines 37-38]** The heap size is set to 512 MB which means the size of the client container should be 1 GB.These values are too small for most clusters, so you will have to increase them as necessary. 

**[Lines 41-46]** Two ports are exposed for clients. TCP port 9200 is used for RESTful requests and responses with the front service. TCP port 9300 is used for inter-node network traffic to handle Elasticsearch internal command communication and is not exposed as a service. The data and master nodes will only use this port and not 9200.

**[Line 49]** Set the pod memory size to twice the `ES_HEAP_SIZE`.

#### Data Nodes

The Kubernetes service file for Elasticsearch data nodes is *es_data.yaml*.

{% highlight ruby linenos %}
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: es-data
  namespace: es-cluster
  labels:
    component: elasticsearch
    role: data
spec:
  template:
    metadata:
      labels:
        component: elasticsearch
        role: data
    spec:
      containers:
      - name: es-data
        securityContext:
          privileged: true
          capabilities:
            add:
              - IPC_LOCK
        image: gcr.io/my_gke_project/elasticsearch:latest
        imagePullPolicy: Always
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: "CLUSTER_NAME"
          value: "my_es_cluster"
        - name: NODE_MASTER
          value: "false"
        - name: NODE_DATA
          value: "true"
        - name: HTTP_ENABLE
          value: "false"
        - name: ES_HEAP_SIZE
          value: "1g"
        - name: NUMBER_OF_SHARDS
          value: "4"
        - name: NUMBER_OF_REPLICAS
          value: "1"
        ports:
        - containerPort: 9300
          name: transport
          protocol: TCP
        resources:
          limits:
            memory: 2Gi
        volumeMounts:
        - name: storage
          mountPath: /data
      volumes:
          - emptyDir:
              medium: ""
            name: "storage"
{% endhighlight %}

**[Lines 32-35]** To create an Elasticsearch data node set the `NODE_MASTER` to `false` and the `NODE_DATA` to `true`.

**[Lines 36-37]** `HTTP_ENABLE` is set to `false` to allow only TCP network I/O between nodes.

**[Lines 38-39]** The heap size is set to 1 GB which means the size of the client container should be 2 GB. These values are too small for most clusters, so you will have to increase them as necessary. 

**[Lines 40-41]** The number of primary shards. The rule of thumb is to create 1 primary shard for each data node. You can also set this to a higher number if you anticipate adding data nodes to the cluster for increased capacity. If you do set a higher value, then when you do add nodes, Elasticsearch will rebalance the primary and replica nodes to make sure there is an even distribution of shards across the cluster. 

**[Lines 42-43]** The number of replica shards. Note this is a replica set, meaning 1 replica shard per primary shard. Usually 1 is a good number, but you can also set this to a higher value if you want to add more data nodes later.

**[Lines 45-47]** TCP port 9300 is used for inter-node network traffic to handle Elasticsearch internal command communication and is not exposed as a service. The data and master nodes will only use this port and not 9200.

**[Line 50]** Set the pod memory size to twice the `ES_HEAP_SIZE`.

#### Master Nodes

The Kubernetes service file for Elasticsearch master nodes is *es_master.yaml*.

{% highlight ruby linenos %}
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: es-master
  namespace: es-cluster
  labels:
    component: elasticsearch
    role: master
spec:
  template:
    metadata:
      labels:
        component: elasticsearch
        role: master
    spec:
      containers:
      - name: es-master
        securityContext:
          privileged: true
          capabilities:
            add:
              - IPC_LOCK
        image: gcr.io/my_gke_project/elasticsearch:latest
        imagePullPolicy: Always
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: "CLUSTER_NAME"
          value: "my_es_cluster"
        - name: NODE_MASTER
          value: "true"
        - name: NODE_DATA
          value: "false"
        - name: HTTP_ENABLE
          value: "false"
        - name: ES_HEAP_SIZE
          value: "512m"
        - name: NUMBER_OF_SHARDS
          value: "4"
        - name: NUMBER_OF_REPLICAS
          value: "1"
        - name: NUMBER_OF_MASTERS
          value: "2"
        ports:
        - containerPort: 9300
          name: transport
          protocol: TCP
        resources:
          limits:
            memory: 1Gi
        volumeMounts:
        - name: storage
          mountPath: /data
      volumes:
          - emptyDir:
              medium: ""
            name: "storage" 
{% endhighlight %}

**[Lines 32-35]** To create an Elasticsearch master node set the `NODE_MASTER` to `true` and the `NODE_DATA` to  `false`.

**[Lines 38-39]** The heap size is set to 512 MB which means the size of the client container should be 1 GB. These values are too small for most clusters, so you will have to increase them as necessary. 

**[Lines 40-41]** The number of primary shards. For this setting to take effect it must match the corresponding setting in *es-data.yaml*.

**[Lines 42-43]** The number of replica shards. For this setting to take effect it must match the corresponding setting in *es-data.yaml*.

**[Lines 44-45]** The minimum number of master nodes must be set to 2 for a master node cluster of 3. This setting prevents split brain syndrome when one of the master nodes fails, drops out of the (master node) cluster, then rejoins the cluster.

**[Lines 47-49]** TCP port 9300 is used for inter-node network traffic to handle Elasticsearch internal command communication and is not exposed as a service. The data and master nodes will only use this port and not 9200.

**[Line 52]** Set the pod memory size to twice the `ES_HEAP_SIZE`.

### Run the Elasticsearch Cluster

#### Startup Script

To start the cluster requires  series of kubectl commands which is more easily done in a script. The following script – *start-es.sh* – starts the deployments, waits for each to become active, scales the cluster to the desired size, and finally waits for a public Elasticsearch service IP. 

{% highlight bash %}
#!/bin/bash
 
echo "Creating Elasticsearch services..."
kubectl create -f es-discovery.yaml
kubectl create -f es-svc.yaml
kubectl create -f es-master.yaml --validate=false
kubectl create -f es-client.yaml --validate=false
kubectl create -f es-data.yaml --validate=false
 
# Check to see if the deployments are running
while true; do
    active=`kubectl get deployments --all-namespaces | grep es-master | awk '{print $6}'`
    if [ "$active" == "1" ]; then
    break
    fi
    sleep 2
done
while true; do
    active=`kubectl get deployments --all-namespaces | grep es-client | awk '{print $6}'`
    if [ "$active" == "1" ]; then
    break
    fi
    sleep 2
done
while true; do
    active=`kubectl get deployments --all-namespaces | grep es-data | awk '{print $6}'`
    if [ "$active" == "1" ]; then
    break
    fi
    sleep 2
done
 
# Scale the cluster to 3 master, 4 data, and 2 client nodes
kubectl scale deployment es-master --replicas 3
kubectl scale deployment es-client --replicas 2
kubectl scale deployment es-data --replicas 4
 
echo "Waiting for Elasticsearch public service IP..."
while true; do
    es_ip=`kubectl get svc elasticsearch | grep elasticsearch | awk '{print $3}'`
    if [ "$es_ip" != "<pending>" ]; then
    break
    fi
    sleep 2
done   
echo "Elasticsearch public IP:    "$es_ip"
{% endhighlight %}

You can start with a larger number of data nodes if you want by changing the number of es-data replicas. If you do this, make sure the `NUMBER_OF_SHARDS` in the data and master node deployment files are set to that number. 

Run the script, then wait for it to finish. The output should look something like this:

{% highlight bash %}
$ ./start-es.sh
Creating Elasticsearch services...
namespace "es-cluster" created
service "elasticsearch-discovery" created
service "elasticsearch" created
deployment "es-master" created
deployment "es-client" created
deployment "es-data" created
Scaling cluster...
deployment "es-master" scaled
deployment "es-client" scaled
deployment "es-data" scaled
Waiting for Elasticsearch public service IP...
Elasticsearch public IP:    104.196.121.33
{% endhighlight %}

Check to make sure you got all the pods running.

{% highlight bash %}
$ kubectl get pods --namespace=es-cluster
NAME                         READY     STATUS    RESTARTS   AGE
es-client-1692123692-ff8ms   1/1       Running   0          4m
es-client-1692123692-nfjpl   1/1       Running   0          4m
es-data-2061351218-a14hh     1/1       Running   0          4m
es-data-2061351218-a7jr1     1/1       Running   0          4m
es-data-2061351218-dasnd     1/1       Running   0          4m
es-data-2061351218-p8ws1     1/1       Running   0          4m
es-master-2164439597-4t5z8   1/1       Running   0          4m
es-master-2164439597-je66g   1/1       Running   0          4m
es-master-2164439597-uzf02   1/1       Running   0          4m
{% endhighlight %}

#### Test the Cluster

To test out cluster, let’s add some data. This set is taken from the [Aggregation Test-Drive](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/_aggregation_test_drive.html) chapter in [Elasticsearch: The Definitive Guide 2.x](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/index.html):

{% highlight bash %}
$ curl 'http://104.196.121.33:9200/cars/transactions/_bulk' -d '
{ "index": {}}
{ "price" : 10000, "color" : "red", "make" : "honda", "sold" : "2014-10-28" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 30000, "color" : "green", "make" : "ford", "sold" : "2014-05-18" }
{ "index": {}}
{ "price" : 15000, "color" : "blue", "make" : "toyota", "sold" : "2014-07-02" }
{ "index": {}}
{ "price" : 12000, "color" : "green", "make" : "toyota", "sold" : "2014-08-19" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 80000, "color" : "red", "make" : "bmw", "sold" : "2014-01-01" }
{ "index": {}}
{ "price" : 25000, "color" : "blue", "make" : "ford", "sold" : "2014-02-12" }'
{% endhighlight %}

Then run a query to make sure the data was indexed:

{% highlight bash %}
$ curl 'http://104.196.121.33:9200/cars/transactions' -d '
{ "query": { "match": { "color": "red" } } }'
{% endhighlight %}

You should get 4 hits back.

#### Teardown the Cluster

Normally you would leave Elastisearch cluster running. However, if you are just doing testing you can tear down the cluster with this script (contained in *stop-es.sh*):

{% highlight bash %}
#!/bin/bash
 
echo "Tearing down cluster services..."
kubectl delete svc --namespace=es-cluster elasticsearch
kubectl delete svc --namespace=es-cluster elasticsearch-discovery
kubectl delete deployment --namespace=es-cluster es-master
kubectl delete deployment --namespace=es-cluster es-client
kubectl delete deployment --namespace=es-cluster es-data
kubectl delete namespace es-cluster
sleep 60
echo "Done"
{% endhighlight %}

When you run the script, the output will look like this:

{% highlight bash %}
$ ./stop-es.sh
Tearing down cluster services...
service "elasticsearch" deleted
service "elasticsearch-discovery" deleted
deployment "es-master" deleted
deployment "es-client" deleted
deployment "es-data" deleted
namespace "es-cluster" deleted
Done
{% endhighlight %}

### What’s Next?

If you’ve gotten this far, you have a working Elasticsearch cluster running on Kubernetes. So what’s to do now. Primarily you’ll need a persistent form of disk storage to make sure you don’t loose your data between restarts of your cluster. There are several ways to do that, so I did not cover that here. The Kubernetes online documentation have a chapter on [Persistent Volumes](http://kubernetes.io/docs/user-guide/persistent-volumes/) that can get you going with that. 

