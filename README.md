# P5 DMS: Docker based operation scenarios
P5 DMS: container based configuration examples
## Getting started
This repository contains the configuration of the **P5 Document Management** in a container-based scenario and explains how the **P5 DMS Components** work together using the **Retrieval** and **P52 Connector** component.

Beyond the specific examples, the configurations are transferable to most other ** P5 DMS components **.
## Installing 
1.) clone the repository
```bash
$ git clone https://github.com/wilken-entire-gmbh/wds_dockerops_demo.git 
```
2.) change docker image referencee in [global/docker.env](global/docker.env) to your repository location and version. Maybe you prefer other port numbers...
```bash
$ cat global/docker.env 

DOCKER_MONGO=mongo:4.2.3
DOCKER_MONGO_ADMIN=mongo-express:0.54.0

DOCKER_RETRIEVAL=wds_retrieval:1.0.15
DOCKER_P52_CONNECTOR=wds_p52_connector:1.0.8
DOCKER_DISPATCH=wds_dispatch:1.0.5

DBADMIN_PORT=5000
CONNECTOR_PORT=8080
RETRIEVAL_PORT=8090
```
3.) invoke [setenv.sh](setenv.sh) to set demo environment
```bash
$ . ./setenv.sh
```
## P5 DMS Components
The P5 DMS consists of a number of components. Depending on the use case, some or all of them are used.
Due to the instantiation options, there are two types of components:
| **type**    | **description**   |  
| ----------- | ---------- | 
| plugin | Plugin components can be created standalone (***detached***) as an independent docker container, or activated as part of a host component (***attached***) in the host docker container. |
| host | Host components can activate plugin components and are always created standalone (***detached***). The plugins that can be activated are stored in the host component.|  

The **Retrieval** is a typical host component and the **P52 Connector** is a typical plugin.
