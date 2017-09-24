# Create a container to run an http server for Custom Conda repository 

Conda organizes repositories into namespaces called [channels](http://conda-test.pydata.org/docs/custom-channels.html). Currently the container creates a single channel called `functions`.

### Start the container with a volume mounted on the functions directory.  
```bash
$ docker build . --rm -t [docker-repo]/conda-repository
$ docker volume create --opt type=none --opt device="$PWD/functions" --opt o=bind functions
$ docker run -d -it -p8000:8000 --mount source=functions,target=/opt/functions [docker-repo]/conda-repository
```
The repository can be accessed at http://localhost:8000


###Build a distibution for the sample function

Install [anaconda](https://conda.io/docs/user-guide/install/index.html) or [miniconda](https://conda.io/miniconda.html)

Install conda-build
```bash
$ conda install conda-build
```
See https://conda.io/docs/user-guide/tasks/build-packages/index.html


```bash
$ conda-build sample --output-folder functions
```

###Publish the package distribution for all platforms to the channel
```bash
$ conda convert --platform all [path-to-tar.bz2-package] -o functions/
$ conda index functions/osx-64 functions/linux-64 #index all if necessary
``` 

###Install the package in a virtual environment

```bash
$ conda env create --file sample/environment.yml
$ source activate sample-function
```
### Perform a quick test

```bash
$ python -m sample.functions hello world
$ source deactivate
```

##Function Runner

This is a sample Python app that runs a function and args passed on the command line. The container uses the `conda` functions channel
at `http://conda:8000/functions` to match the K8s service URL. To run it locally, edit `/etc/hosts` and add an entry for the container 
host:

`[container IpAddress]  conda` 

To get the container IP address

```bash
$docker ps
$ docker inspect [container-id] | grep IPAddress
```

The function runner sets the following environment variables:

`ENV CHANNEL http://conda:8000/functions`
`ENV PACKAGE_NAME="sample"`

These values can be overridden on the command line. The package name is the name of a package that will be installed at run time from the channel, using
`conda install`. This takes a few seconds for a small package like we have here. The fully qualified function name (prefixed with the module) is
the first command line argument, the remaining arguments are passed as function arguments.

```bash
$ docker build --rm  app -t [docker-repo]/function-runner
$ docker run -it [docker-repo]/function-runner functions.upper hello
$ docker run -it [docker-repo]/function-runner functions.concat org springframework cloud function
```

## Deploy to Kubernetes

If you built the conda-repository image, docker push the image and edit conda.yaml to mach the image name

###Upload the files

```bash
$kubectl apply -f conda.yaml
$kubectl get pods
$kubectl cp functions [conda-repository-container]:/opt/functions
```

