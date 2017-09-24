# Create a container to run an http server for Custom Conda repository 

Conda organizes repositories into namespaces called [channels](http://conda-test.pydata.org/docs/custom-channels.html). Currently the container creates a single channel called `functions`.

### Start the container with a volume mounted on the functions directory.  
```bash
$ docker build . --rm -t dturanski/conda-server
$ docker volume create --opt type=none --opt device="$PWDsample" --opt o=bind functions
$ docker run -d -it -p8000:8000 --mount source=functions,target=/opt/functions dturanski/conda-server
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
