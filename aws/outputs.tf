output "private_key" {
    value = tls_private_key.node-key.private_key_pem
}

output "ssh_username" {
    value = "ubuntu"
}

output "master_addresses" {
    value = aws_instance.rke-master-node[*].public_dns
}

output "worker_addresses" {
    value = aws_instance.rke-worker-node[*].public_dns
}

output "master_internal_ips" {
    value = aws_instance.rke-master-node[*].private_ip
}

output "worker_internal_ips" {
    value = aws_instance.rke-worker-node[*].private_ip
}
