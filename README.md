# CodicaTask
## Task

Create a template for AWS and a few extra things to speed up the whole process.

Write with Terraform :
- VPC (CIDR 10.0.0.0/16) with subnets (2 private and 2 public, CIDR doesn’t matter here)
- NAT and Internet gateways
- Application load balancer and target group
- RDS database db.t3.micro with custom subnet group and EC2 instance t3.micro(latest ubuntu AMI)
- Security groups, route tables, and other required resources
- Follow naming conventions from [here](https://www.terraform-best-practices.com/).
- Try to keep infra as secure as possible, and do not use any custom modules here.
- The state should be in a private S3 bucket

Ansible:
- The simple playbook that will install docker, docker-compose v2, and required dependencies
- Make it work with both RHEL and Debian-like operating systems

Docker:
- Launch this [template](https://github.com/docker/awesome-compose/tree/master/wordpress-mysql) but instead of using the database defined in compose use your
RDS instance

## How to run
### 1 STEP - Download prerequisites

Clone repository to your computer
```
git clone https://github.com/DanyaCt/CodicaTask
```
Additionally, you need to download Terraform, AWS CLI, and Ansible. You can use the following links:

>Terraform: https://developer.hashicorp.com/terraform/downloads
>
>AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
>
>Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

Next, you must log in to your AWS account. Here's a guide for this:
>https://docs.aws.amazon.com/cli/latest/reference/configure/

### 2 STEP - Create key pair and private S3 bucket

Note: Your key pair and S3 bucket must be in the same region as all your other resources (eu-central-1).

Create a key pair in AWS using the following guide:

>https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

Then, install your key in the project folder and enter the name of the key in the code (line 2).

Next, create a private S3 bucket and enable versioning using the following guide:

>https://www.simplified.guide/aws/s3/create-private-bucket

Then, enter your bucket name in the code (line 15)

### 3 STEP - Run Terraform

Run these commands:
```
terraform init
terraform apply -auto-approve -parallelism=15
```

### 4 STEP - Change compose.yaml file 

Go to the compose.yaml file and change "WORDPRESS_DB_HOST" from Terraform output.

It should look something like this:
```
services:
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    restart: always
    environment:
      - WORDPRESS_DB_HOST=terraform-20230304115008252200000004.c7qoidvlik6t.eu-central-1.rds.amazonaws.com:3306
      - WORDPRESS_DB_USER=user
      - WORDPRESS_DB_PASSWORD=password
      - WORDPRESS_DB_NAME=mydb
volumes:
  db_data:
```

### 5 STEP - SSH to your instance and run Wordpress container

Run the following command in your terminal:
```
ssh -i "<your key here with .pem>" ubuntu@<ip of your instance from terraform output>
```
You will be inside your instance.

Next, create the compose.yaml file:
```
vi compose.yaml
```
Copy the text from the previous step and paste it into the compose.yaml file on your instance.

Then, type :wq and press enter.

Finally, run the following command:
```
sudo docker compose up -d
```
The Wordpress container has started, and you can check if it works by pasting this URL into your browser:
```
http://<instance public_ip from Terraform output>
```
