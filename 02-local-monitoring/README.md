# Lab 2: Local monitoring

## Assignment

> TODO

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

## Cleanup

To remove everything run:

1. Inside `10-terraform` directory:
    ```bash
    terraform destroy -var-file=".tfvars"
    ```