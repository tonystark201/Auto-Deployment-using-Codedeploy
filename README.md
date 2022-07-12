# Auto Deployment using Codedeploy

## CodeDeploy

> __*AWS CodeDeploy is a fully managed deployment service that automates software deployment to various compute services such as Amazon EC2, AWS Fargate, AWS Lambda, and on-premises servers.*__
>
> With AWS CodeDeploy, you can more easily release new features quickly, avoid downtime during application deployment, and simplify application updates. You can use AWS CodeDeploy to automate software deployments without the need for manual, error-prone actions.
>
> Advantages:
>
> + Automatic deployment
> + Centralized control
> + Minimize downtime
> + Easy to use

## Blueprint

![codedeploy1](https://github.com/tonystark201/Auto-Deployment-using-Codedeploy/blob/main/img/codedeploy1.png)

## Terraform

__*All the code of build infrastructure, you can check and review them in the folder of `IaC`*__

### Steps

It`s very easy to contribute the infrastructure by Terraform. You can use the commands as below to initialize terraform and bulid the AWS infrastructure.

+ Initialize terraform and install provider and module

  ```shell
  terraform init
  ```

+ Validate the script you have been wrote done.

  ```shell
  terraform validate
  ```

+ Show your build plan

  ```shell
  terraform plan
  ```

+ Apply the code to build infrastructure.

  ```shell
  terraform apply
  ```

+ Destroy the infrastructure you have been built.

  ```shell
  terraform destroy
  ```


### Resource

The resources we need are listed below.

+ CodeDeploy

  We need to codedeploy application to deploy the revision to EC2 Instance.

+ ASG

  We need auto scaling group to control the EC2 instance group auto scaling up and down.

+ S3

  We need a Bucket to store the code version.
  
+ SG

  We need security gateway to control the traffic.

+ IAM Role

  We need different Role for Codedeploy and EC2.

+ ALB

  We need application load balance to bind with auto scaling group. We can visit the service by the DNS of the ALB.

+ VPC

  We need a custom VPC. And the ALB and ASG all in the same VPC.

+ Launch Configuration

  We need launch configuration for the EC2 groups.

+ SNS

  We need SNS topic for the Codedeploy.

### Tips

You must provide your AWS key and secret, and give the value in the `terraform.tfvars` as below:

```shell
# provider
aws_region = "us-east-1"
aws_access_key = "xxxxxx"
aws_secret_key = "xxxxxx"
```
When the infrastructure build successfully, you will see the output as below.

```
Apply complete! Resources: 55 added, 0 changed, 0 destroyed.

Outputs:

alb_hostname = "DemoA-alb-1321370709.us-east-1.elb.amazonaws.com"
bucket_name = "codedeploy-factually-fully-top-pony"
codedeploy_group_name = "dg_one"
codedeploy_app_name = "demo_app"
```

## GitHub Action

We use the github action workflow to automate the deployment of code to the cloud. __*You can check and view the github action configuration in the folder of ".github" in this Repo*__

### Workflow

The workflow as below:

+ CI
  + Checkout the Code to the github runner
  + Lint the code, you can run flake8 or other tools to check the code format.
  + Run the unittest, you can use tox, pytets, unittest or some tools to implement the unit test of the code.
+ CD
  + Checkout the Code to the github runner
  + Configure AWS credentials
  + Generate zip package
  + Upload the zip file to S3.
  + Create CodeDeploy Deployment

### Tips

1. You need to add your secret key in the Repo.(Click settings of the Repo you will find the place to add secret key)
2. You must update the `env` parameters in the `.github.yml` file.

## Summary

This demo code mainly relies on the PaaS service provided by AWS. The Code demonstrates how to use CodeDeploy to automatically deploy code from a Github repository to an EC2 cluster (The cluster uses Auto Scaling Group for automated scaling). We also use ALB for flow balancing.

__*Thank you for your reading, and welcome to fork and star.*__

## Reference

+ [Deploying AWS CodeDeploy - Automated Software Deployment on AWS](https://www.youtube.com/watch?v=jcR9iIWdU7E)
+ [CodeDeploy AppSpec File reference](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html)
+ [Health checks for Auto Scaling instances](https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-health-checks.html#available-health-checks)
+ [Prerequisites for getting started with Elastic Load Balancing](https://docs.aws.amazon.com/autoscaling/ec2/userguide/getting-started-elastic-load-balancing.html)
+ [How to create target type of ELB](https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html)
+ [Create a service role for CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html)

