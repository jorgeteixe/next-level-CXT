# Lab 11: Ticket management

## Assignment

Deploy hesk.

## Configuration

### Terraform variables:

- public_key [string]: ssh public key to be added to the created instance
- availability_zone [string]: availability zone in which the instance and volume will be created

> To get availability zones from a region:
> `aws ec2 describe-availability-zones --region <region>`

You can save the variables in a `.tfvars` file and use the `-var-file` argument to terraform.

### Docker environment variables

Copy the `.env.dist` to `.env` inside `20-docker/` and fill with your variables.

- `MYSQL_ROOT_PASSWORD`: MySQL root password
- `MYSQL_DATABASE`: MySQL database created
- `MYSQL_USER`: MySQL created user with permissions over `MYSQL_DATABASE`
- `MYSQL_PASSWORD`: MySQL password for the user
- `DOMAIN`: defaults to `localhost`. Domain to ask for certificate on Caddy.

## Running

To create and prepare the environment run:

1. Inside `10-terraform` directory:
    ```bash
    terraform apply -var-file=".tfvars"
    ```
2. Install docker with the compose plugin on the host, follow [this guide](https://docs.docker.com/engine/install/ubuntu/).
3. After configuring the `.env` file, run `docker compose up -d` and Hesk should be running.
4. Visit your domain and you should see the Hesk docs page. Navigate to `/install`, accept the terms and introduce the following:
    1. Database host: `db`
    2. Database name: same as the `MYSQL_DATABASE` environment variable
    3. Database username: same as the `MYSQL_USER` environment variable
    4. Database password:same as the `MYSQL_PASSWORD` environment variable
5. After hitting install, you have to remove the `install` folder on the container. Do the following:
```bash
$ docker exec -it hesk_php bash
root@af1e7662a138:/var/www/html$ rm -rf install # inside the container
```

6. Navigate to your domain on the path `/admin/` and everything should work properly.

## Cleanup

To remove everything run:

1. Inside `10-terraform` directory:
    ```bash
    terraform destroy -var-file=".tfvars"
    ```