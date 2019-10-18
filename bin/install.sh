#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}/..}")"

################### PRE-REQUIREMENTS ###################
function install_requirements {
  if (which make && which curl && which git) > /dev/null; then
    echo "${BASH_SOURCE}: make, curl, git: already installed"
    return
  fi

  pre_reqs=(apt-transport-https ca-certificates make curl git)

  echo "${BASH_SOURCE}: Installing pre-requirement: ${pre_reqs[@]}..."
  apt-get update -qq > /dev/null
  apt-get install -y -qq ${pre_reqs[@]}
}
install_requirements

################### DOCKER ###################
function install_docker {
  if [ "$(which docker)" ]; then
    echo "${BASH_SOURCE}: docker: already installed"
    echo "${BASH_SOURCE}: docker: adding $SUDO_USER} to docker group"
    usermod -aG docker "${SUDO_USER}"
    return
  fi
  echo "${BASH_SOURCE}: Installing docker..."
  curl -sSL get.docker.io | bash
  echo "${BASH_SOURCE}: docker: creating docker group"
  groupadd docker
  echo "${BASH_SOURCE}: docker: adding ${SUDO_USER} to docker group"
  usermod -aG docker "${SUDO_USER}"

}
install_docker

################### DOCKER-COMPOSE ###################
DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-1.22.0}

function install_docker_compose {
  if [ "$(which docker-compose)" ]; then
      echo "${BASH_SOURCE}: docker-compose: already installed"
      return
  fi
  echo "${BASH_SOURCE}: Installing docker-compose..."
  curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}
install_docker_compose
