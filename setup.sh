#!/usr/bin/env bash

export $(cat env/setup.env | xargs)
bash bootstrap/entrypoint.sh
