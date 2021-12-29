ARG CODE_SERVER_VERSION

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

ENV NODE_HOME=/usr/share/nodejs \
    COMWORK_LOCAL_TUNNEL_SERVER=http://lt.comwork.io:3200

COPY ./assets/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon-dark-support.svg
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon.svg
COPY ./bash_config.sh /home/coder/.bash_aliases
COPY ./bash_config.sh /root/.bashrc

ARG NODE_VERSION
ARG NODE_ARCH
ARG NODE_OS
ARG YQ_VERSION
ARG YQ_OS
ARG YQ_ARCH

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose net-tools iputils-ping wget vim jq && \
    git config --global core.editor "vim" && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    sudo chmod +x /usr/bin/kubectl && \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.tar.gz" -o node.tgz && \
    tar xvzf node.tgz > /dev/null 2>&1 && \
    sudo mv "node-v${NODE_VERSION}-linux-${NODE_ARCH}" "${NODE_HOME}" && \
    sudo ln -s "${NODE_HOME}/bin/node" /usr/bin && \
    sudo ln -s "${NODE_HOME}/bin/npm" /usr/bin && \
    sudo chmod +x /usr/bin/node && \
    sudo chmod +x /usr/bin/npm && \
    sudo wget "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${YQ_OS}_${YQ_ARCH}" -O /usr/bin/yq && \
    sudo chmod +x /usr/bin/yq && \
    rm -rf node.tgz && \
    sudo npm install -g localtunnel && \
    sudo ln -s "${NODE_HOM}/bin/lt" /usr/bin/lt && \
    sudo chown -R coder:coder /home/coder/.bash_aliases
