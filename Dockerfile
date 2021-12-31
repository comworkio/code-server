ARG CODE_SERVER_VERSION

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

ENV NODE_HOME=/usr/share/nodejs \
    HELM_HOME=/usr/share/helm \
    COMWORK_LOCAL_TUNNEL_SERVER=http://lt.comwork.io:3200

COPY ./assets/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon-dark-support.svg
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon.svg
COPY ./bash_config.sh /home/coder/.bash_aliases
COPY ./bash_config.sh /root/.bashrc

ARG OS
ARG OS_ARCH
ARG NODE_VERSION
ARG NODE_ARCH
ARG YQ_VERSION
ARG HELM_VERSION
ARG TERRAGRUNT_VERSION

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose net-tools iputils-ping wget vim jq gnupg software-properties-common python3 python3-pip ansible && \
    sudo pip3 install --upgrade pip && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=${OS_ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get update -y && \
    sudo apt-get install -y terraform && \
    git config --global core.editor "vim" && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${OS_ARCH}/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    sudo chmod +x /usr/bin/kubectl && \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${OS}-${NODE_ARCH}.tar.gz" -o node.tgz && \
    tar xvzf node.tgz > /dev/null 2>&1 && \
    sudo mv "node-v${NODE_VERSION}-linux-${NODE_ARCH}" "${NODE_HOME}" && \
    sudo ln -s "${NODE_HOME}/bin/node" /usr/bin && \
    sudo ln -s "${NODE_HOME}/bin/npm" /usr/bin && \
    sudo chmod +x /usr/bin/node && \
    sudo chmod +x /usr/bin/npm && \
    rm -rf node.tgz && \
    curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-${OS}-${OS_ARCH}.tar.gz" -o helm.tgz && \
    tar xvzf helm.tgz > /dev/null 2>&1 && \
    sudo mv "${OS}-${ARCH_OS}" "${HELM_HOME}" && \
    sudo ln -s "${HELM_HOME}/helm" /usr/bin && \
    sudo chmod +x /usr/bin/helm && \
    rm -rf helm.tgz && \
    sudo wget "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${OS}_${OS_ARCH}" -O /usr/bin/yq && \
    sudo chmod +x /usr/bin/yq && \
    sudo wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${OS}_${OS_ARCH}" -O /usr/bin/terragrunt && \
    sudo chmod +x /usr/bin/terragrunt && \
    sudo npm install -g localtunnel && \
    sudo ln -s "${NODE_HOME}/bin/lt" /usr/bin/lt && \
    sudo chown -R coder:coder /home/coder/.bash_aliases
