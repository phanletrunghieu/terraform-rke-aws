output "private_key" {
    value = tls_private_key.node_key.private_key_pem
}

output "ssh_username" {
    value = "ubuntu"
}

output "master_addresses" {
    value = aws_eip.rke_master_eip[*].public_dns
}

output "worker_addresses" {
    value = aws_eip.rke_worker_eip[*].public_dns
}

output "master_internal_ips" {
    value = aws_instance.rke_master_node[*].private_ip
}

output "worker_internal_ips" {
    value = aws_instance.rke_worker_node[*].private_ip
}
