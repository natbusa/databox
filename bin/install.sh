#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}/..}")"

source "${SCRIPT_DIR}/colorize.sh"

################### PRE-REQUIREMENTS ###################
function install_requirements {
  if (which make && which curl && which git) > /dev/null; then
    echo "${BASH_SOURCE}: ${green}make, curl, git${normal}: already installed"
    return
  fi

  pre_reqs=(apt-transport-https ca-certificates make curl git)

  echo "${BASH_SOURCE}: Installing ${green}pre-requirement${normal}: ${pre_reqs[@]}..."
  apt-get update -qq > /dev/null
  apt-get install -y -qq ${pre_reqs[@]}
  echo "${green}pre-requirement${normal} is installed"
}
install_requirements

################### DOCKER ###################
function install_docker {
  if [ "$(which docker)" ]; then
    echo "${BASH_SOURCE}: ${green}docker${normal}: already installed"
    return
  fi
  echo "${BASH_SOURCE}: Installing ${green}docker${normal}..."
  curl -sSL get.docker.io | bash
  usermod -aG docker "$USER"
}
install_docker

################### DOCKER-COMPOSE ###################
DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-1.22.0}

function install_docker_compose {
  if [ "$(which docker-compose)" ]; then
      echo "${BASH_SOURCE}: ${green}docker-compose${normal}: already installed"
      return
  fi
  echo "${BASH_SOURCE}: Installing ${green}docker-compose${normal}..."
  curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}
install_docker_compose

################### BUILD CONTAINERS ###################
pushd ${ROOT_DIR}/docker/containers > /dev/null
for c in $(ls)
do
  pushd $c && make build && popd
done
popd > /dev/null
