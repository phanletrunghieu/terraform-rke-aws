locals {
    cluster_id_tag = {
        "kubernetes.io/cluster/${var.cluster_id}" = "owned"
    }
}

data "aws_availability_zones" "az" {
    state = "available"
}

resource "aws_default_subnet" "default" {
    availability_zone = data.aws_availability_zones.az.names[count.index]
    tags              = local.cluster_id_tag
    count             = length(data.aws_availability_zones.az.names)
}

resource "aws_security_group" "allow-all" {
    name        = "rke-default-security-group"
    description = "rke"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = local.cluster_id_tag
}

resource "aws_instance" "rke-master-node" {
    count = 1

    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.master_instance_type
    key_name               = aws_key_pair.rke-node-key.id
    iam_instance_profile   = aws_iam_instance_profile.rke-master-aws.name
    vpc_security_group_ids = [aws_security_group.allow-all.id]
    tags                   = local.cluster_id_tag
    availability_zone      = data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)]

    provisioner "remote-exec" {
        connection {
            host        = coalesce(self.public_ip, self.private_ip)
            type        = "ssh"
            user        = "ubuntu"
            private_key = tls_private_key.node-key.private_key_pem
        }

        inline = [
            "curl ${var.docker_install_url} | sh",
            "sudo usermod -a -G docker ubuntu",
        ]
    }
}

resource "aws_instance" "rke-worker-node" {
    count = 1

    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.worker_instance_type
    key_name               = aws_key_pair.rke-node-key.id
    iam_instance_profile   = aws_iam_instance_profile.rke-worker-aws.name
    vpc_security_group_ids = [aws_security_group.allow-all.id]
    tags                   = local.cluster_id_tag
    availability_zone      = data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)]

    provisioner "remote-exec" {
        connection {
            host        = coalesce(self.public_ip, self.private_ip)
            type        = "ssh"
            user        = "ubuntu"
            private_key = tls_private_key.node-key.private_key_pem
        }

        inline = [
            "curl ${var.docker_install_url} | sh",
            "sudo usermod -a -G docker ubuntu",
        ]
    }
}