# three-tier-app-iac

## Description
The project contains the configuration files for a three tier application. It consists of terraform files, kubernetes manifests files and helm charst[TODO]. The kubernetes infrastructure is provisioned on AWS using AWS Elastic Kubernetes Service, Route 53, AWS Certificate Manager, S3 bucket, EC2 instances, Elastic Load balancer, VPC, IAM roles and policies. 

> The application can be deployed as is in any kubernetes cluster as long as we have the done the similar setup and configuration.

> For testing purposes, we can use minikube but that would require certain changes with respect to cluster type and port-forwarding to be able to access via localhost.

> Recommended to deploy the cluster in AWS EKS cluster which is provisioned using the provided terraform scripts.

```
├── README.md
├── helm
│   └── TODO
├── k8s_manifests
│   ├── backend
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   ├── frontend
│   │   ├── frontend-deployment.yaml
│   │   └── frontend-service.yaml
│   ├── ingress.yaml
│   ├── mongo
│   │   ├── deploy.yaml
│   │   ├── secrets.yaml
│   │   └── service.yaml
│   ├── monitor.yaml
│   └── values.yaml
└── terraform
    ├── autoscaler-iam.tf
    ├── autoscaler-manifest.tf
    ├── backend.tf
    ├── eks.tf
    ├── helm-load-balancer-controller.tf
    ├── helm-provider.tf
    ├── iam.tf
    ├── provider.tf
    ├── variables.tf
    └── vpc.tf
```
More details of the application and the GitHub repository is here: (https://github.com/asif-ahmedb/three-tier-app)

## Pre-requisites
1. AWS CLI - Install and configure AWS CLI using ACCESS KEY and SECRET
2. Terraform
3. Kubectl
4. Helm

## Steps:
1. Create a hosted zone using Amazon Route53 or a third-party accredited domain registrar. In my case; I have used Route 53 and created mycloudapphosting.com.
2. Before setting up a custom domain name for an API, you must have an SSL/TLS certificate ready in AWS Certificate Manager and is validated so that it is in issued state.
3. Take note of the Hosted Zone Name and Hosted Zone ID to be used later for Kubernetes deployment. 


