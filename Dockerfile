ARG CODE_SERVER_VERSION

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

ENV NODE_HOME=/usr/share/nodejs \
    HELM_HOME=/usr/share/helm \
    K9S_HOME=/usr/share/k9s \
    KUBESEAL_HOME=/usr/share/kubeseal \
    CODER_HOME=/home/coder \
    COMWORK_LOCAL_TUNNEL_SERVER=http://lt.comwork.io:3200

COPY ./assets/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon-dark-support.svg
COPY ./assets/favicon.svg /usr/lib/code-server/src/browser/media/favicon.svg
COPY ./bash_config.sh /home/coder/.bash_aliases
COPY ./bash_config.sh /root/.bashrc

ARG OS
ARG OS_ARCH
ARG NODE_ARCH
ARG K9S_ARCH
ARG K9S_OS
ARG NODE_VERSION
ARG YQ_VERSION
ARG HELM_VERSION
ARG TERRAGRUNT_VERSION
ARG K9S_VERSION
ARG KUBESEAL_ARCH
ARG KUBESEAL_VERSION
ARG MC_ARCH
ARG CWC_VERSION
ARG CWC_ARCH

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose net-tools iputils-ping wget vim jq gnupg software-properties-common python3 python3-pip ansible tmux && \
    sudo pip3 install --upgrade pip && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=${OS_ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-add-repository "deb https://packages.cloud.google.com/apt cloud-sdk main" && \
    sudo apt-get update -y && \
    sudo apt-get install -y terraform google-cloud-sdk && \
    git config --global core.editor "vim" && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${OS_ARCH}/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    sudo chmod +x /usr/bin/kubectl && \
    curl -LO "https://dl.min.io/client/mc/release/linux-${MC_ARCH}/mc" && \
    sudo mv mc /usr/bin && \
    sudo chmod +x /usr/bin/mc && \
    curl -fsSL "https://gitlab.comwork.io/oss/cwc/cwc/-/releases/v${CWC_VERSION}/downloads/cwc_${CWC_VERSION}_linux_${CWC_ARCH}.tar.gz" -o "cwc_cli.tar.gz" && \
    mkdir cwc_cli && tar -xf cwc_cli.tar.gz -C cwc_cli && \
    chmod +x ./cwc_cli/install.sh && \
    sudo ./cwc_cli/install.sh && \
    rm -rf cwc_cli.tar.gz && \
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
    sudo mv "${OS}-${OS_ARCH}" "${HELM_HOME}" && \
    sudo ln -s "${HELM_HOME}/helm" /usr/bin && \
    sudo chmod +x /usr/bin/helm && \
    rm -rf helm.tgz && \
    sudo mkdir -p "${K9S_HOME}" && \
    curl -fsSL "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_${K9S_OS}_${K9S_ARCH}.tar.gz" -o k9s.tgz && \
    sudo tar xvzf k9s.tgz -C "${K9S_HOME}" > /dev/null 2>&1 && \
    sudo ln -s "${K9S_HOME}/k9s" /usr/bin/k9s && \
    sudo chmod +x /usr/bin/k9s && \
    rm -rf k9s.tgz && \
    sudo mkdir -p "${KUBESEAL_HOME}" && \
    wget -q "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-${OS}-${KUBESEAL_ARCH}.tar.gz" -O kubeseal.tgz && \
    sudo tar xvzf kubeseal.tgz -C "${KUBESEAL_HOME}" > /dev/null 2>&1 && \
    sudo ln -s "${KUBESEAL_HOME}/kubeseal" /usr/bin/kubeseal && \
    sudo chmod +x /usr/bin/kubeseal && \
    rm -rf kubeseal.tgz && \
    sudo wget -q "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${OS}_${OS_ARCH}" -O /usr/bin/yq && \
    sudo chmod +x /usr/bin/yq && \
    sudo wget -q "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${OS}_${OS_ARCH}" -O /usr/bin/terragrunt && \
    sudo chmod +x /usr/bin/terragrunt && \
    sudo npm install -g localtunnel && \
    sudo ln -s "${NODE_HOME}/bin/lt" /usr/bin/lt && \
    sudo mkdir -p "${CODER_HOME}/.local/share/code-server/extensions" && \
    sudo chown -R coder:coder "${CODER_HOME}" && \
    sudo mkdir -p "${CODER_HOME}/.config/gcloud/configurations" && \
    sudo chown -R coder:coder "${CODER_HOME}/.config/gcloud" && \
    sudo mkdir -p "${CODER_HOME}/.config/mc" && \
    sudo chown -R coder:coder "${CODER_HOME}/.config/mc" && \
    sudo apt remove -y software-properties-common && \
    sudo rm -rf /var/lib/apt/lists/* && \
    rm -rf .wget-hsts
