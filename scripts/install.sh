#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
source "${SCRIPT_DIR}/colorize.sh"

################### PRE-REQUIREMENTS ###################
function install_pre_reqs {
    if (which make && which curl) > /dev/null; then
        return
    fi
    pre_reqs=( apt-transport-https ca-certificates make curl )

    echo "Installing ${green}pre-requirement${normal}: ${pre_reqs[@]}..."
    apt-get update -qq > /dev/null
    apt-get install -y -qq ${pre_reqs[@]}
    echo "${green}pre-requirement${normal} is installed"
}
install_pre_reqs

################### DOCKER ###################
function install_docker {
    echo "Installing ${green}docker${normal}..."
    curl -sSL get.docker.io | bash
    usermod -aG docker "$USER"
    echo "${green}docker${normal} is installed"
}
if [ -z "$(which docker)" ]; then
    install_docker
else
    echo "${yellow}SKIP${normal} ${green}docker${normal} is already installed"
fi

################### DOCKER-COMPOSE ###################
DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-1.22.0}

function install_docker_compose {
    echo "Installing ${green}docker-compose${normal}..."
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "${green}docker-compose${normal} is installed"
}
if [ -z "$(which docker-compose)" ]; then
    install_docker_compose
else
    echo "${yellow}SKIP${normal} ${green}docker-compose${normal} is already installed"
fi
