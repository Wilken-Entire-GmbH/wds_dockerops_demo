# P5 DMS: Docker based operation scenarios
P5 DMS: container based configuration examples

- [Getting started](#getting-started)
- [Installing](#installing)
- [P5 DMS Components](#p5-dms-components)
  - [Common Component Features](#common-component-features)
  - [Plugin Components](#plugin-components)
- [Examples](#examples)
  - [Behaviour](#behaviour)
    - [Docker Loadbalancer](#docker-loadbalancer)
    - [Scaleable Retrieval](#scalable-retrieval)
    - [Attached Vs. Detached](#attached-vs-detached)

## Getting started
This repository contains the configuration of the **P5 Document Management** in a container-based scenario and explains how the **P5 DMS Components** work together using the **Retrieval** and **P52 Connector** component.

Beyond the specific examples, the configurations are transferable to most other ** P5 DMS components **.
## Installing 
1.) clone the repository
```bash
$ git clone https://github.com/wilken-entire-gmbh/wds_dockerops_demo.git 
```
2.) change docker image references in [global/docker.env](global/docker.env) to your repository location and version. Maybe you prefer other port numbers...
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

4.) Start the mongo database
```bash
$ wds_start nosql 
```
## P5 DMS Components
The P5 DMS consists of a number of components. Depending on the use case, some or all of them are used. Components communicate with each other and with the outside world via HTTP.
### Common Component Features
Components have some common basic features:
| **feature** | **description** |
|-------------|-----------------|
| swagger | All routes are described via swagger. The embedded Swagger UI is accessible via `/api-docs` or `/`, while the Swagger file can be accessed via `/api/openapi.yaml.` |
| metrics | Every component implements a [Prometheus](http://www.prometheus.io/) metric client. The metric data is accessible via `/metrics` | 
| metric UI | In addition to the possibility to visualize metric data with [Prometheus](http://www.prometheus.io/) and [Grafana](https://grafana.com/), each component has an embedded visualization of metric basic data via `/swagger-stats/ux`. |

### Plugin Components
Due to the instantiation options, there are two types of components:
| **type**    | **description**   |  
| ----------- | ---------- | 
| plugin | Plugin components can be created standalone (***detached***) as an independent docker container, or activated as part of a host component (***attached***) in the host docker container. |
| host | Host components can activate plugin components and are always created standalone (***detached***). The plugins that can be activated are stored in the host component.|  

**Retrieval** is a host component while **P52 Connector** is a plugin.

## Examples
Due to the possibilities regarding component instantiation (***detached***/**attached**) and scaling, the demo consists of four examples. Each example creates a docker stack. Since all examples use the same port mappings, only one example can run at a time.

| **example** | **description** |  
| ----------- | ---------- |
| detached | creates a **Retrieval** and an scalable **P52 Connector**. See [detached.yml](config/detached.yml) |
| attached | creates a **Retrieval** with the **P52 Connector** as a plugin. See [attached.yml](config/attached.yml) | 
| scale_detached | creates a scalable **Retrieval** and an scalable **P52 Connector**. See [scale_detached.yml](config/scale_detached.yml) and [Scalable Retrieval](#scalable-retrieval) |
| scale_attached | creates a scalable **Retrieval** with the **P52 Connector** as a plugin. See [scale_attached.yml](config/scale_attached.yml) and [Scalable Retrieval](#scalable-retrieval) |

To start an example call `wds_start <example>`. F.e. with example 'attached'

```bash
# start the example attached
$ wds_start attached

# stop the example attached 
$ wds_stop attached 
```
### Behaviour

#### Docker Loadbalancer
No matter which configuration, the internal component communication always takes place via the internal docker loadbalancer. As a result, in the "scale_attached" example, the P52 connector can also access another retrieval instances.

#### Scalable Retrieval 
The **Retrieval** component has a special behaviour in scaling, because on startup it caches the whole configuration data. At runtime, configuration changes have to be reflected to all **Retrieval** instances. That is the task of the wds_dispatch container instance. The **Retrieval** instance which process the change, sends via a web-socket an event to wds_dispatch. wds_dispatch then broadcast the information back all **Retrieval** instances.

#### Attached Vs. Detached
Attached configurations have the advantage that significantly less memory is required. This is particularly important in multi tenant environments, since a large number of instances is required. Use `docker stats` to see the effect.

On the other hand, plugins share the degree of scaling and CPU usage with the host component. The ** P52 Connector ** is not critical here, in contrast for e.g. the **OCR** component.

Detached configurations can be scaled more independently. This independence is paid for with higher memory usage.

Both configurations make sense in production, depending on the functionality of the component and the use case.


