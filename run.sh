#!/usr/bin/env bash

output=$(./main.py $@)
if [ $? -eq 3 ]; then
    eval "$output"
else
    echo "$output"
fi