# OS X Setup

Docker Desktop:
https://docs.docker.com/docker-for-mac/install/

Enable kubernetes for docker:
* Click on the docker icon in the menu bar
* Choose preferences
* Click on the kubernetes tab
* Click "Enable Kubernetes"
* Click "Apply"

CLI utilities
```
brew install skaffold
brew install kubectx
brew install kubernetes-cli
brew install kubernetes-helm
```

Fire up your development environment:
Here, we will setup our kubernetes context, initialize helm, and then deploy our helm chart with skaffold
```
kubectx docker-for-desktop
helm init # we only need to do this once 
skaffold dev --port-forward --cleanup=false
```

This should bring up all containers related to the project. check the status of the pods in a new window:
```
kubectl get pods
```
Your output should looks something like this 
```
NAME                        READY   STATUS    RESTARTS   AGE
cho-local-b6c6ffdd9-pmc6s   1/1     Running   0          47s
cho-local-postgresql-0      1/1     Running   0          47s
cho-local-redis-0           1/1     Running   0          47s
cho-local-solr-0            1/1     Running   0          47s
```

If you have pods that aren't in a ready stage you can look at the logs, or describe the object to find out why. For example:

```
kubectl describe po cho-local-b6c6ffdd9-pmc6s 
[AND]
kubectl logs cho-local-b6c6ffdd9-pmc6s 
```

When running skaffold in dev mode, it will port-forward your localhost:3000 to the rails app, sync filechanges to the container, and tail out the logs for you

when all of the pods are in a ready state you will be ready to setup solr! 

Setup Solr:
Setting up solr is kind of a manual task right now. We hope to automate this further *soon*

from the cho directory run:
```
./k8s/setup_solr.sh
```

this will create the 'cho' core, and copy solr/config/schema.xml and solr/config/solrconfig.xml into the newly created core, then restart solr

At this point cho should be up and running. you may need to run some rake tasks to get things where you want them. 

[WIP]

I've been running the following:
```
./k8s/rake_task.sh cho:clean
./k8s/rake_task.sh cho:benchmark:works
```

cho:benchmark:works fails for me, i think becuase fits isn't installed. i'm going to be workign on that soon


