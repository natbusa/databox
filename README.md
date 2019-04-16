# datalabframework-demos
A collections of demos for the datalabframework package

### 1. Tools

This demos require the following tools to be installed.
  
  - make
  - docker
  - docker-compose
  - gcloud sdk

Please run `sudo scripts/install.sh` to install the above.

### 2. How to run the demos

Demos are all located under the `demos` directory or
type `make list-demos` to print the list of the available demos.

#### 3. Select your demo

select a demo by adding `DEMO=<name of the demo>` to the make command.
List the available demos by typing `make list-demos`

For example, if the selected demo is `basic`

 - `make up DEMO=basic` creates the environment

The datalabframework is illustrated via notebooks, and markdown files.
Start by opening the README.md file in the demo directory

### 4. How to stop the Demos

After running the demo, tear down the environment by typing `make down DEMO=basic`

### 5. Regression Test

if developing/updateing the demos, run the demos in background mode and check that everything still works. For testing purposes, use `make regression` to test the demo in background mode.

### 6. Develop

if you wish to develop the datalabframework library, this repo acts as integration test suite. add `MODE=dev` to the make commands, for instance: `make run MODE=dev` and `make regression MODE=dev`. This will start the jupyter notebook with the datalabframework package mounted in editable mode.

In MODE=dev, you must specify the path of your local datalabframework package source in the `DLF_DIR` environment variable. 

You can export the variable as in `export DLF_DIR=<your datalabframeworkdir>`  
or prepend it to the make command as in `DLF_DIR=<your datalabframeworkdir> make up DEMO=basic`  
or provide this path in a local .env file as such `echo DLF_DIR=<your datalabframeworkdir> > .env`
