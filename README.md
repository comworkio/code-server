# code-server

Docker images which inherits [this one](https://hub.docker.com/r/codercom/code-server) from [coder.com](https://coder.com) and which embed docker cli, k3d and kubectl for your self-hosted "gitpod's like" environments.

## Table of contents

[[_TOC_]]

## Git repositories

* Main repo: https://gitlab.comwork.io/oss/code-server
* Github mirror: https://github.com/idrissneumann/code-server.git
* Gitlab mirror: https://gitlab.com/ineumann/code-server.git

## Getting started

### Docker image

The image is available on docker hub [here](https://hub.docker.com/repository/docker/comworkio/code-server).

Very simple example with docker-compose:

```yaml
version: "3.3"

services: 
  code-server:
    image: comworkio/code-server
    container_name: code-server
    volumes:
      - ./code-config.yaml:/home/coder/.config/code-server/config.yaml:z
      - /var/run/docker.sock:/var/run/docker.sock
    ports: 
      - {{ coder_port }}:8080
```

And the `code-config.yaml` :

```yaml
bind-addr: 127.0.0.1:8080
auth: password
password: changeit
cert: false
```

Then you can add volum with your workspaces git repositories.

### Ansible role

You can automate your workspaces on a classic VM or compute instance using this [ansible role](./ansible/roles/code) which supports CentOS with docker and docker-compose installed.

You'll just have to complete this yaml repository inventory:

```yaml
code_git_workspaces:
  - name: code-server
    git: https://gitlab.comwork.io/oss/code-server.git
```

## Expose your containers with localtunnel

You can expose your containers on internet using [Localtunnel](https://localtunnel.github.io/www/)

For example if you want to expose the 8080 port:

```shell
lt --port 8080
```

You containers will have to map the same tcp port on the local network.

You can also use the comwork.io instance of server tunnels if you've been authorized by comwork this way:

```shell
lt --port 8080 $COMWORK_LOCAL_TUNNEL_SERVER
```

Either way, you'll get an url as output that you'll be able to share with other people arround the world !
