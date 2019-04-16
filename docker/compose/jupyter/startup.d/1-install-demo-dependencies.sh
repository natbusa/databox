#!/bin/bash -e

if [ -f "$DEMO_PATH/binder/environment.yml" ]; then
    conda env update -n base -f $DEMO_PATH/binder/environment.yml
fi
