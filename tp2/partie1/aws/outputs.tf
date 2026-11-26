# À décommenter à l'étape 5, une fois l'instance écrite dans vm.tf :
# tant que la ressource n'existe pas, terraform validate refuse cette référence.
#
# output "public_ip" {
#   description = "IP publique de la VM"
#   value       = aws_instance.vm.public_ip
# }
