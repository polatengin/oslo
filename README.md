# Oslo Project

Sample project for beginners to learn Microservice architecture.

It's consist of several components, such as, couple of .Net Core BackEnd Services, a FrontEnd UI developed with Angular.

All the components are packaged with Docker.

Project is running inside of a Kubernetes.

## Backend Services

_User Service_ and _Product Service_ APIs are developed and built with .Net Core 3.1

## Frontend UI

_Web Frontend_ developed with Angular

## Deployment

All components are packaged with Docker

## Executing

Docker Images are stored in a Azure Container Registry, in order to store them privately.

Docker Containers are running inside of a Azure Kubernetes Service.

In AKS (Azure Kubernetes Service) Nginx used as LoadBalancer and Ingress Controller.