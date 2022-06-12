#!/bin/bash

if [[ -f ".credentials" && -f ".runner" ]]; then
    ./run.sh
else
    ./config.sh
fi
