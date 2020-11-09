resource "tls_private_key" "node-key" {
    algorithm = "RSA"
}

resource "aws_key_pair" "rke-node-key" {
    key_name   = "rke-node-key"
    public_key = tls_private_key.node-key.public_key_openssh
}

resource "local_file" "ssh_pub_key" {
    filename = "./ssh_keys/rsa.pub"
    content  = tls_private_key.node-key.public_key_openssh
}

resource "local_file" "ssh_priv_key" {
    filename = "./ssh_keys/rsa"
    content  = tls_private_key.node-key.private_key_pem
}