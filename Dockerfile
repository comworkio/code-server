ARG CODE_SERVER_VERSION
ARG NODE_VERSION
ARG NODE_ARCH

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

ENV NODE_HOME=/usr/share/nodejs \
    COMWORK_LOCAL_TUNNEL_SERVER=http://lt.comwork.io:3200

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    curl -fsSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$NODE_ARCH.tar.gz" -o node.tgz && \
    tar xvzf node.tgz > /dev/null 2>&1 && \
    mkdir -p $NODE_HOME && \
    mv "node-v$NODE_VERSION-linux-$NODE_ARCH" "$NODE_HOME" && \
    ln -s "$NODE_HOME/bin/node" /usr/bin && \
    ln -s "$NODE_HOME/bin/npm" /usr/bin && \
    rm -rf node.tgz && \
    rm -rf "node-v$NODE_VERSION-linux-$NODE_ARCH"
    npm install -g localtunnel
