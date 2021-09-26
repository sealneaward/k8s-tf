# k8s-tf
Create a expiremental repository to learn/showcase what can be done in the DevOps realm.

### Setup

1. Install Docker, minikube, kubectl etc.

2. Run minikube and enable the tunnel to create the Python LoadBalancer
```
minikube start
minikube tunnel
```

3. Build the Python image
```
cd helloword
./build-image.sh
```

4. Run setup to create the resources
```
cd ../
./setup.sh
```

5. Access the LoadBalancer created for the Python service from this command
```
minikube service hello-python
```

6. Cleanup the resources
```
./cleanup.sh
```
