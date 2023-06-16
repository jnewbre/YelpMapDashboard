terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

resource "aws_security_group" "ports_security_group" {
    name        = "Allow Ports"
    description = "SSH & Apache"
    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "allow_ports"
    }
}


resource "tls_private_key" "custom_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
    key_name_prefix = var.key_name
    public_key      = tls_private_key.custom_key.public_key_openssh
}

resource "local_file" "pem_file" {
    filename = pathexpand("~/.ssh/${var.ssh_key_name}.pem")
    file_permission = "600"
    directory_permission = "700"
    sensitive_content = tls_private_key.custom_key.private_key_pem
}

resource "aws_instance" "map_ec2" {
    ami             = "ami-053b0d53c279acc90"
    instance_type   = var.instance_type

    key_name        = aws_key_pair.generated_key.key_name
    security_groups = [aws_security_group.ports_security_group.name]

    tags = {
        Name = "map_ec2"
    }

  user_data = <<EOF
#!/bin/bash

echo "-------------------------START SETUP---------------------------"
sudo apt-get -y update

sudo apt-get -y install \
ca-certificates \
curl \
gnupg \
lsb-release

sudo apt -y install unzip

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo chmod 666 /var/run/docker.sock

sudo apt install make

echo 'Clone git repo to EC2'
cd /home/ubuntu && git clone ${var.repo_url}

echo 'CD to GitHub directory'
cd YelpMapDashboard

sudo chown -R ubuntu:ubuntu .

mkdir bobby

make up

docker exec -it postgres_container  bash
psql postgresql://root:root@localhost:5432/test_db
CREATE SCHEMA dbo;
CREATE TABLE dbo.restaurants (name varchar(50), address varchar(50));


echo "-------------------------END SETUP---------------------------"
EOF
}

resource "aws_budgets_budget" "ec2" {
    name              = "budget-ec2-monthly"
    budget_type       = "COST"
    limit_amount      = "5"
    limit_unit        = "USD"
    time_period_end   = "2087-06-15_00:00"
    time_period_start = "2023-02-19_00:00"
    time_unit         = "MONTHLY"

    notification {
        comparison_operator        = "GREATER_THAN"
        threshold                  = 100
        threshold_type             = "PERCENTAGE"
        notification_type          = "FORECASTED"
        subscriber_email_addresses = [var.alert_email_id]
    }
}
