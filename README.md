# three-tier-app-iac

## Description
The project contains the configuration files for a three tier application. It consists of terraform files, kubernetes manifests files and helm charst[TODO]. The kubernetes infrastructure is provisioned on AWS using AWS Elastic Kubernetes Service, Route 53, AWS Certificate Manager, S3 bucket, EC2 instances, Elastic Load balancer, VPC, IAM roles and policies. 

> The application can be deployed as is in any kubernetes cluster as long as we have the done the similar setup and configuration.

> For testing purposes, we can use minikube but that would require certain changes with respect to cluster type and port-forwarding to be able to access via localhost.

> *Recommended to deploy the cluster in AWS EKS cluster which is provisioned using the provided terraform scripts.*

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

## Tools required to be installed
1. AWS CLI - Install and configure AWS CLI using ACCESS KEY and SECRET
2. Terraform
3. Kubectl
4. Helm

## Pre-requisites:
1. Create a hosted zone using Amazon Route53 or a third-party accredited domain registrar. In my case; I have used Route 53 and created mycloudapphosting.com.
2. Before setting up a custom domain name for an API, you must have an SSL/TLS certificate ready in AWS Certificate Manager and is validated so that it is in issued state.
3. Take note of the Hosted Zone Name and Hosted Zone ID to be used later for Kubernetes deployment.

## Provisioning with Terraform
We will use the terraform scripts to provision and managing an Amazon Elastic Kubernetes Service (EKS). We will create the below resources using Terraform:
- EKS cluster.
- ALB ingress controller and External DNS.
- OpenID connect provider using Terraform. The provider will be able to assign IAM roles to Kubernetes service accounts.
- ACM certificate validated with our Route53 domain.

Some features of the terrform scripts:
- Remote backed       : Used AWS S3 for storing the terrform state file.
- Modules             : Use of modules for re-using already existing terrform code. For example: VPC, IAM_ROLES, Cluster Autoscaler, EKS etc.
- HELM Provider

## Steps to provision the cluster
1. Clone the repo
2. Change directory to *terraform* and run the below commands:
   - terraform init
   - terraform plan
   - terraform apply --auto-approve

This will provision the cluster and all associated resources. The operation will take a while before all the resources are successfully provisioned.

```
update the Kubernetes context
aws eks update-kubeconfig --name my-eks-cluster --region us-east-1
```

## Deploy Kubernetes manifests

1. Once the EKS cluster is up and running, we are ready to deploy our three-tier application.
2. Change directory to *k8s_manifests* and apply the terraform manifests.
   
   - MongoDB    : cd into *mongo* folder and run ```terrform apply -f .```
   - Backend    : cd into *backend* folder and run ```terrform apply -f .```
   - Frontend   : cd into *frontend* folder and run ```terrform apply -f .```
   - Ingress    : cd  back to *k8s_manifests* and run ``` terraform apply -f ingress.yaml```

Update your hosted zone and create the CNAME records for the ingress and monitoring addresses. 

- In ingress for the main app, I have used *app.mycloudapphosting.com* as host
    ```
    spec:
      ingressClassName: alb
      rules:
        - host: app.mycloudapphosting.com
    ```
> In Route 53, create a CNAME record for mycloudapphosting.com. The key is *api* and value will be *ADDRESS* of the ingress. For example: *k8s-demolb-fa1658a882-147059283.us-east-1.elb.amazonaws.com*

- In ingress for monitor, I have used *monitor.mycloudapphosting.com* as host
    ```
    spec:
      ingressClassName: alb
      rules:
        - host: monitor.mycloudapphosting.com
    ```
> In Route 53, create a CNAME record for mycloudapphosting.com. The key is *monitor* and value will be *ADDRESS* of the ingress. For example: *k8s-demolb-fa1658a882-147059283.us-east-1.elb.amazonaws.com*

- Below image for reference:
<kbd>
<img width="394" alt="image" src="https://github.com/asif-ahmedb/three-tier-app-iac/assets/24711835/c398eb6e-92e5-432e-b2fc-7631b26975fa">
</kbd>

Once this is done, please wait for few seconds or minutes for the change to reflect in AWS. 

## Now we are ready to access the application via https://app.mycloudapphosting.com and access the prometheus dashboard via https://monitor.mycloudapphosting.com

