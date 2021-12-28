ARG CODE_SERVER_VERSION

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

ARG NODE_VERSION
ARG NODE_ARCH
ARG NODE_OS

ENV NODE_HOME=/usr/share/nodejs \
    COMWORK_LOCAL_TUNNEL_SERVER=http://lt.comwork.io:3200 \
    PATH="${PATH}:${NODE_HOME}/bin"

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose net-tools vim && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    sudo chmod +x /usr/bin/kubectl && \
    curl -fsSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-$NODE_OS-$NODE_ARCH.tar.gz" -o node.tgz && \
    tar xvzf node.tgz > /dev/null 2>&1 && \
    sudo mv "node-v$NODE_VERSION-linux-$NODE_ARCH" "$NODE_HOME" && \
    sudo chmod +x "$NODE_HOME/bin/node" /usr/bin && \
    sudo chmod +x "$NODE_HOME/bin/npm" /usr/bin && \
    rm -rf node.tgz && \
    rm -rf "node-v$NODE_VERSION-$NODE_OS-$NODE_ARCH" && \
    sudo npm install -g localtunnel
