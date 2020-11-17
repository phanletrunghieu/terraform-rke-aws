terraform {
    required_providers {
        rke = {
            source  = "rancher/rke"
            version = "1.1.0"
        }
    }
}

module "nodes" {
    source                 = "./aws"
    # region               = "ap-southeast-1"
    cluster_id           = "rke"
    # master_instance_type = "t3a.micro"
    # worker_instance_type = "t3a.small"
}

provider "rke" {
    debug = false
    log_file = "rke.log"
}

resource "rke_cluster" "cluster1" {
    cloud_provider {
        name = "aws"
    }

    nodes {
        hostname_override = "master-0"
        address          = module.nodes.master_addresses[0]
        internal_address = module.nodes.master_internal_ips[0]
        user             = module.nodes.ssh_username
        ssh_key          = module.nodes.private_key
        role             = ["controlplane", "etcd", "worker"]
    }

    nodes {
        hostname_override = "node-0"
        address           = module.nodes.worker_addresses[0]
        internal_address  = module.nodes.worker_internal_ips[0]
        user              = module.nodes.ssh_username
        ssh_key           = module.nodes.private_key
        role              = ["worker"]
    }

    ingress {
        provider = "none"
    }
    
    upgrade_strategy {
        drain = true
        max_unavailable_worker = "50%"
    }

    addons = <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
    name: gp2
    annotations:
        storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
parameters:
    fsType: ext4
    type: gp2
EOF
}

resource "local_file" "kube_cluster_yaml" {
    filename = "./kube_config_cluster.yml"
    content  = rke_cluster.cluster1.kube_config_yaml
}