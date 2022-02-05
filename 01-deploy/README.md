# Lab 1: Deploy infrastructure

## Assignment

1. Create an AWS account (already have one).
2. Configure billing alert (already have a 30$ budget with alert configured).
3. Create IAM users.
    - In my case, as I am going to do the labs alone, I have created a new IAM user
      with only programmatic access. This is to challenge myself and practice IaC.
4. Deploy an EC2 instance.
5. Configure a web server in that instance.
6. Create an EBS volume, attatch it to the instance and prepare it for use.

## Peculiarities

- Won't use default VPC, but configure a custom one.
- Allow only inbound to ssh from the "master node" (cxt.jtei.io) from which I
  do everything on the subject CXT.
- Will assign a DNS name to the created instance: 1.cxt.jtei.io.

## Configuration

### Terraform variables:

- public_key [string]: ssh public key to be added to the created instance
- availability_zone [string]: availability zone in which the instance and volume will be created

> To get availability zones from a region:
> `aws ec2 describe-availability-zones --region <region>`

You can save the variables in a `.tfvars` file and use the `-var-file` argument to terraform.

## Running

To create and prepare the environment run:


1. Inside `10-terraform` directory:
    ```bash
    terraform apply -var-file=".tfvars"
    ```

2. Inside `20-ansible` directory:
    ```bash
    ansible-playbook -i hosts playbook.yml
    ```
