#!/usr/bin/env bash
eval $(minikube -p minikube docker-env)
docker build -f Dockerfile -t hello-python:latest .
