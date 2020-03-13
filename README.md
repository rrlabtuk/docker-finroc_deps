# docker-finroc_deps
An ubuntu image with basic dependencies to build and run a finroc environment.

## [Image on Docker Hub](https://hub.docker.com/repository/docker/finrocunofficial/finroc_deps)

## Prerequisites
- `docker`
- optional `docker-compose`

# Running
## Getting the container image
`docker pull finrocunoffical/finroc_deps:latest` or `docker pull finrocunoffical/finroc_deps:v1` or `docker pull finrocunoffical/finroc_deps:extra_libs`
## Via Docker
- `docker run -v ./finroc_user:/home/finroc_user -v /etc/localtime:/etc/localtime:ro -i -t finrocunoffical/finroc_deps bash`
  - `-v /etc/localtime:/etc/localtime:ro` is optional, but you can get compile errors (unit tests) related to time zone
## Via Docker compose
- `docker-compose run finroc bash`

### Note: Adjust volumes if necessary!
By default (for `docker-compose`) the folder `./finroc_user` (relative to the current console) is mounted as `/home/finroc_user` within the container
### Tip:
When setting up a folder for use as volume, `chmod -R 777 <folder>` allows any user to write to this folder. This allows you to edit files from within the container and from your host computer.

# Running a docker container WITHOUT any volumes will not save any data at all between runs. All user data is lost !

# Extending image with further packages
Write a new Dockerfile
```
FROM finrocunoffical/finroc_deps:latest

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    <YOUR_NEW_PACKAGES> \
    && rm -rf /var/lib/apt/lists/*  
    
USER finroc_user
```

# Running Finroc
We will not provide a finroc installation here, only the system and dependencies to build and run it.
Some finroc libraries or projects may need additional dependencies. You should be notified about them when building.

You can download your finroc installation from within the container or download it externally to the folder mounted at `/home/finroc_user`. You can treat the environment within the container as a normal linux home. Thus you can create authorization files for mercurial (`.hgrc)` or git if necessary within `/home/finroc_user`.

# X11 Session for graphical interfaces or simulation
[https://github.com/finrocunoffical/docker-finroc_deps-x11](https://github.com/finrocunoffical/docker-finroc_deps-x11)

# Using Eclipse to build inside the docker container
- `docker pull finrocunoffical/finroc_deps:latest` to get the latest image
- Go to `Project -> Properties`, then `C/C++ Build -> Settings` and in the `Container Settigns` tab check `Build inside Docker image`
    - Select the docker image `finrocunoffical/finroc_deps:latest`
    - Add your folder that is mounted at `/home/finroc_user` or `/home/finroc_user/finroc`
    ![eclipse-docker-finroc](img/eclipse-docker-finroc.png)
    ![eclipse-docker-finroc_user](img/eclipse-docker-finroc_user.png)
- Now you should be able to build within eclipse using this Docker image

# Using eclipse to run program inside container
- Install `C/C++ Docker Container Launch Support` under `Help -> Install New Software`
- Add new "run configuration" as `C/C++ Container Launcher`
- Go to tab "Container" and select Image `finrocunofficial/finroc_deps`
- In tab "Main" select the "C/C++ Application" to launch (recommended to use "Search Project" function)


# Using eclipse to debug inside container
- Install `C/C++ Docker Container Launch Support` under `Help -> Install New Software`
- Add new "Debug configuration" as `C/C++ Container Launcher`
- Go to tab "Container" and select Image `finrocunofficial/finroc_deps`
- In tab "Main" select the "C/C++ Application" to launch (recommended to use "Search Project" function)
![eclipse-docker-finroc](img/eclipse-debug1.png)
![eclipse-docker-finroc](img/eclipse-debug2.png)
