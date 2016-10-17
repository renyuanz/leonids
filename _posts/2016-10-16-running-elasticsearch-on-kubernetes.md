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

### Build a Kubernetes Ready Elasticsearch Container
For starters, you’ll need an Elasticsearch Docker container that is tailored for Kubernetes, which you can get from the [pires/docker-elasticsearch-kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes){:target="_blank"} repo on Github.  The Dockerfile for this container installs all the necessary components for Elasticsearch including Elasticsearch itself (version 2.3.5_1 as of this writing) and the io.fabric8/elasticsearch-cloud-kubernetes plugin that enables the Elasticsearch nodes to discover each other without having to specify the IP addresses of the nodes in the elasticsearch.yml configuration file.  Get a copy of the pires/docker-elasticsearch-kubernetes repo then build your Elasticsearch image by running this command in the docker-elasticsearch-kubernetes directory:

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
    
Checking the Dockerfile you can see that the pires/docker-elasticsearch-kubernetes repo is derived from pires/docker-elasticsearch. The Dockerfile in that repo sets the Elasticsearch cluster defaults to create a cluster consisting of 1 node. Our cluster, however, will consist of separate master, data, and client nodes for better Elasticsearch performance so we'll have to customize these configuration settings in the Kubernetes service files later:

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

The path variables all map to directories that are created in the source Docker container obtained from pires/docker-elasticsearch.

### Create Elasticsearch Kubernetes Services

#### Elasticsearch Kubernetes Cluster
Now that we have an Elasticsearch container let’s create the Kubernetes service files for our Elasticsearch cluster. The pires/kubernetes-elasticsearch-cluster repo on Github includes the Kubernetes service files that enable you to create an Elasticsearch cluster service that is comprised of dedicated master, data, and client nodes, like the one shown here, consisting of 2 client nodes, 4 data nodes, and 3 master nodes. I've created a fork of the this repo at vichargrave/kubernetes-elasticsearch-cluster that includes the service modifications discussed in the sections that follow, so you could just clone mine to save yourself some time.

![](/img/Elasticsearch-Kubernetes-Cluster.png)
