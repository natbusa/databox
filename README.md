# datalabframework-env: Environment for Demos and Tutorials
A collections of demos for the datalabframework package

### 1. Tools

This demos require the following tools to be installed.

  - make
  - docker
  - docker-compose

Please run `sudo scripts/install.sh` to install the above.

### 2. Available demos

Demos are all located under the `demos` directory or
type `ls demos` to print the list of the available demos.

#### 3. Setup the docker environment for the demo 'tuto'

Run `bin/env up <demo-name>`. For

### 4. How to stop the docker environment

After running the demo, stop the environment by typing `bin/env down <demo-name>`
