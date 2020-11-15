variable "region" {
    default = "ap-southeast-1"
}

variable "master_instance_count" {
    default = 1
}

variable "master_instance_type" {
    default = "t3a.small"
}

variable "worker_instance_count" {
    default = 1
}

variable "worker_instance_type" {
    default = "t3a.small"
}

variable "cluster_id" {
    default = "rke"
}

variable "docker_install_url" {
    default = "https://releases.rancher.com/install-docker/19.03.sh"
}
