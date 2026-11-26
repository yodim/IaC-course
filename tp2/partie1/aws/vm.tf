# Image : la dernière Ubuntu 24.04 LTS publiée par Canonical (compte 099720109477).
# Une source de données lit un objet existant sans le gérer.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# À compléter : la machine virtuelle
# - ressource aws_instance "vm", avec l'étiquette Name = "vm-${local.prefix}"
# - ami, instance_type, subnet_id, vpc_security_group_ids
# - user_data_replace_on_change = true
#
# Le bloc ci-dessous est à placer dans la ressource : cloud-init crée
# l'utilisateur admin_username et y installe votre clé publique.
#
#   user_data = <<-EOT
#     #cloud-config
#     users:
#       - name: ${var.admin_username}
#         groups: [sudo]
#         shell: /bin/bash
#         sudo: "ALL=(ALL) NOPASSWD:ALL"
#         ssh_authorized_keys:
#           - ${trimspace(file("~/.ssh/id_rsa.pub"))}
#   EOT

