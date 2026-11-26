resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "vpc-${local.prefix}" }
}

# Sur AWS, un réseau n'a pas accès à Internet par défaut : il faut une passerelle
# et une route vers elle. Azure fait ce travail sans ressource visible.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "igw-${local.prefix}" }
}

data "aws_availability_zones" "dispo" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.dispo.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "snet-${local.prefix}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "rt-${local.prefix}" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public.id
}

# À compléter : le groupe de sécurité (l'équivalent du NSG d'Azure)
# - ressource aws_security_group "sg", nommée "sg-${local.prefix}", dans le VPC
# - sa description ne doit pas contenir d'accents (AWS les refuse)
# - attention : il s'attache à la VM, et non au sous-réseau comme le NSG


# À compléter : la règle d'entrée SSH
# - ressource aws_vpc_security_group_ingress_rule "ssh"
# - TCP, port 22 (from_port et to_port), source : local.ssh_cidr


# À compléter : la règle de sortie
# - ressource aws_vpc_security_group_egress_rule "sortie"
# - tout le trafic sortant (ip_protocol = "-1") vers 0.0.0.0/0
# - sans elle, la VM ne peut rien télécharger : Terraform retire la règle
#   de sortie qu'AWS crée par défaut

