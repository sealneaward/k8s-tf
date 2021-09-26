#!/usr/bin/env bash

export $(cat env/cleanup.env | xargs)
bash bootstrap/entrypoint.sh
