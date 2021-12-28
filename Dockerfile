ARG CODE_SERVER_VERSION

FROM codercom/code-server:${CODE_SERVER_VERSION} AS code-server

RUN sudo apt-get update -y && \
    sudo apt-get install -y docker docker-compose && \
    sudo usermod -aG docker coder && \
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl
