#!/usr/bin/env bash
conda install $PACKAGE_NAME --channel $CHANNEL --override-channels --yes
/function-runner.py $@