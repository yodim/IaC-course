# TP2, partie 1 : une machine virtuelle dans le cloud

Séance 2.

## Objectif

Écrire une configuration Terraform qui crée une machine virtuelle Linux accessible en SSH depuis la salle, puis la faire évoluer et la détruire.

Le TP se fait sur Azure. Un groupe qui n'a pas pu activer Azure peut le faire sur AWS, avec un compte personnel : les étapes et les questions sont les mêmes, seul le code change. Chaque groupe choisit **un seul** cloud pour tout le TP.

## Choisir son cloud

| | Azure | AWS |
| --- | --- | --- |
| Compte | Azure for Students (adresse de l'école) | Compte AWS personnel, plan Free |
| Dossier de départ | `azure/` | `aws/` |
| Région par défaut | `francecentral` | `eu-west-3` (Paris) |
| Taille de la VM | `Standard_B1s` | `t3.micro` |
| Outil en ligne de commande | Azure CLI (`az`) | AWS CLI (`aws`), version 2.32 ou plus |

## L'architecture à déployer

Sur Azure, dans l'abonnement Azure for Students :

- un groupe de ressources `rg-tp2-<groupe>` ;
- un réseau virtuel `10.0.0.0/16` et un sous-réseau `10.0.1.0/24` ;
- un NSG qui n'autorise SSH (port 22) que depuis l'IP de la salle, associé au sous-réseau ;
- une IP publique Standard et statique ;
- une carte réseau ;
- une VM Linux Ubuntu 24.04, taille `Standard_B1s`.

Sur AWS, dans la région `eu-west-3` :

- un VPC `10.0.0.0/16` et un sous-réseau public `10.0.1.0/24` ;
- une passerelle Internet et une table de routage associée au sous-réseau : sur AWS, un réseau n'a pas accès à Internet sans elles ;
- un groupe de sécurité qui n'autorise SSH (port 22) que depuis l'IP de la salle, attaché à la VM ;
- une instance EC2 Ubuntu 24.04, type `t3.micro`, avec une IP publique.

## Fichiers fournis

Les fichiers de `azure/` et de `aws/` sont un point de départ. Les parties marquées `À compléter` sont à écrire par le groupe.

| Fichier | Contenu (Azure) | Contenu (AWS) | À faire |
| --- | --- | --- | --- |
| `providers.tf` | Bloc `terraform` et provider `azurerm` | Bloc `terraform` et provider `aws` | Rien, à relire |
| `variables.tf` | Variables d'entrée et préfixe des noms | Variables d'entrée, préfixe des noms et plage SSH | Rien, à relire |
| `terraform.tfvars` | Valeurs du groupe | Valeurs du groupe | Mettre le nom du groupe et l'IP de la salle |
| `network.tf` | Groupe de ressources, réseau, sous-réseau | VPC, passerelle Internet, sous-réseau, table de routage | Azure : le NSG et son association. AWS : le groupe de sécurité et ses deux règles |
| `vm.tf` | Indications | Image Ubuntu et indications | Azure : l'IP publique, la carte réseau et la VM. AWS : l'instance |
| `outputs.tf` | Sortie `public_ip`, en commentaire | Sortie `public_ip`, en commentaire | La décommenter à l'étape 5 |
| `.gitignore` | Fichiers à ne jamais versionner | Fichiers à ne jamais versionner | Rien |

## Étape 1 : préparer l'environnement

Dans WSL, pour les deux clouds :

```bash
# Générer une paire de clés SSH, si ~/.ssh/id_rsa.pub n'existe pas
ssh-keygen -t rsa -b 4096

# Connaître l'IP publique de la salle
curl -s https://ifconfig.me
```

L'IP de la salle sert à n'ouvrir SSH qu'aux postes de l'école, et non à tout Internet.

### Azure

```bash
# Se connecter à Azure et choisir l'abonnement
az login
az account show --query "{nom:name, id:id}" -o table
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Préparer le dossier dans le dépôt du groupe
cd ~/<depot-du-groupe>
cp -r ~/IaC-course/tp2/partie1/azure tp2
cd tp2
```

Le provider a besoin de l'identifiant de l'abonnement. La variable d'environnement `ARM_SUBSCRIPTION_ID` évite de l'écrire dans le code. Elle est à exporter dans chaque nouveau terminal.

### AWS

Il faut l'AWS CLI en version 2.32 ou plus récente : `aws --version` pour vérifier.

Évitez de travailler avec l'utilisateur racine du compte. Dans la console AWS, service IAM, créez un utilisateur, par exemple `terraform`, avec l'accès à la console et la stratégie `AdministratorAccess`. Connectez-vous ensuite à la console avec cet utilisateur.

Puis, dans WSL :

```bash
# Se connecter avec ses identifiants de console
aws login                          # à la question de la région, répondre eu-west-3
aws sts get-caller-identity        # doit afficher l'utilisateur terraform, pas root

# Préparer le dossier dans le dépôt du groupe
cd ~/<depot-du-groupe>
cp -r ~/IaC-course/tp2/partie1/aws tp2
cd tp2
```

`aws login` ouvre le navigateur sur la page de connexion d'AWS. Depuis WSL, si le navigateur ne s'ouvre pas, ouvrez l'adresse affichée dans le terminal, ou lancez `aws login --remote` et recopiez le code d'autorisation. La session dure jusqu'à 12 heures : il suffit de relancer `aws login` à la séance suivante. Aucun secret n'est stocké dans le dépôt, et le provider retrouve la session tout seul.

Si Terraform répond `No valid credential sources found` alors que `aws sts get-caller-identity` fonctionne, revenez à une clé d'accès :

1. Dans IAM, utilisateur `terraform`, onglet « Security credentials », créer une clé d'accès de type « Command Line Interface (CLI) ».
2. Dans WSL, `aws configure` : clé, clé secrète, région `eu-west-3`, sortie `json`.

`aws configure` écrit la clé dans `~/.aws/credentials`, sur votre poste. Elle ne doit jamais apparaître dans le dépôt, ni dans le code.

Si vous avez un AWS Academy Learner Lab plutôt qu'un compte personnel, copiez les identifiants de la page du lab (AWS Details) dans `~/.aws/credentials`, et ajoutez `region = "us-east-1"` dans `terraform.tfvars`.

## Étape 2 : providers et variables

1. Relire `providers.tf` et `variables.tf`.
2. Renseigner `terraform.tfvars` : identifiant du groupe et IP de la salle.
3. Vérifier que `.gitignore` est bien présent avant le premier commit.
4. Lancer `terraform init`, puis `terraform validate`.

## Étape 3 : le réseau

### Azure

Le groupe de ressources, le réseau et le sous-réseau sont déjà dans `network.tf`. À écrire par le groupe :

- un `azurerm_network_security_group` avec un bloc `security_rule` : règle entrante, TCP, port 22, accès autorisé, priorité 100 ;
- la source de la règle est `var.allowed_ssh_ip` ;
- une `azurerm_subnet_network_security_group_association`, qui associe le NSG au sous-réseau.

Sans l'association, le NSG existe mais ne protège rien.

### AWS

Le VPC, la passerelle Internet, le sous-réseau et la table de routage sont déjà dans `network.tf`. À écrire par le groupe :

- un `aws_security_group` dans le VPC, avec une description sans accent (AWS les refuse) ;
- une `aws_vpc_security_group_ingress_rule` : TCP, port 22, source `local.ssh_cidr` ;
- une `aws_vpc_security_group_egress_rule` : tout le trafic sortant (`ip_protocol = "-1"`) vers `0.0.0.0/0`.

Sans la règle de sortie, la VM ne peut rien télécharger : Terraform retire la règle de sortie qu'AWS crée par défaut.

## Étape 4 : la machine virtuelle

### Azure

À écrire dans `vm.tf` :

| Ressource | Arguments clés |
| --- | --- |
| `azurerm_public_ip` | `sku = "Standard"`, `allocation_method = "Static"` |
| `azurerm_network_interface` | bloc `ip_configuration` : `subnet_id`, `private_ip_address_allocation = "Dynamic"`, `public_ip_address_id` |
| `azurerm_linux_virtual_machine` | `size`, `admin_username`, `network_interface_ids`, `admin_ssh_key`, `os_disk` (`caching`, `storage_account_type`), `source_image_reference` |

Une IP publique Standard bloque le trafic entrant par défaut : seul le NSG ouvre le port 22.

Documentation : <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs>.

### AWS

L'image Ubuntu est déjà trouvée par la source de données `aws_ami` de `vm.tf`. À écrire :

| Ressource | Arguments clés |
| --- | --- |
| `aws_instance` | `ami`, `instance_type`, `subnet_id`, `vpc_security_group_ids`, `user_data`, `user_data_replace_on_change = true`, `tags` |

Le bloc `user_data` est fourni en commentaire dans `vm.tf` : au premier démarrage, cloud-init crée l'utilisateur `azureuser` et y installe votre clé publique. C'est l'équivalent du bloc `admin_ssh_key` d'Azure, et c'est le même utilisateur sur les deux clouds.

Documentation : <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>.

## Étape 5 : déployer et se connecter

Décommentez d'abord la sortie `public_ip` dans `outputs.tf`, puis :

```bash
terraform init
terraform fmt
terraform validate
terraform plan -out tp2.plan
terraform apply tp2.plan
terraform output public_ip
ssh azureuser@$(terraform output -raw public_ip)
```

Vérifiez aussi les ressources créées dans le portail Azure, ou dans la console AWS (service EC2, région `eu-west-3`). Sur AWS, cloud-init met environ une minute à créer l'utilisateur : si SSH répond `Permission denied` juste après l'`apply`, attendez un peu.

À observer :

1. Combien de ressources le plan annonce-t-il ?
2. Dans quel ordre sont-elles créées ?
3. Quels nouveaux fichiers sont apparus dans le dossier ?

## Étape 6 : modifier, puis détruire

1. Ajouter une étiquette (`tags`) à la VM, puis lancer `terraform plan`. Quel symbole apparaît ?
2. Changer `admin_username` dans `terraform.tfvars`, puis lancer `terraform plan`. Que devient la VM ? Ne pas appliquer, et remettre la valeur d'origine.
3. Lancer `terraform destroy`, puis vérifier dans le portail ou la console que tout a disparu : sur Azure, le groupe de ressources ; sur AWS, le VPC et l'instance.

## Suivre ses dépenses

Sur Azure :

- Créer un budget sur l'abonnement (Cost Management, Budgets) avec une alerte par courriel.
- Suivre la consommation du crédit dans Education Hub, page Overview.

Sur AWS :

- Créer un budget avec le modèle « Zero spend budget » (Billing and Cost Management, Budgets) : un courriel arrive dès le premier centime dépensé.
- Suivre les crédits restants dans Billing and Cost Management, page Credits.

Dans les deux cas, en fin de séance, aucune ressource ne doit rester active.

## Rapport à rendre

Chaque groupe rend un rapport en PDF, de 3 à 5 pages avec les captures. Il explique ce que vous avez fait, étape par étape, avec les réponses aux questions (étape 5 et 6).

Un `README.md` dans le dossier `tp2` est souhaitable.


## À pousser dans le dépôt du groupe

```text
tp2/
├── providers.tf
├── variables.tf
├── network.tf
├── vm.tf
├── outputs.tf
├── terraform.tfvars
├── .terraform.lock.hcl
├── .gitignore
├── README.md          (souhaitable)
└── captures/
```

Aucun fichier d'état, aucun plan, aucune clé privée, aucune clé d'accès AWS.

## Question de réflexion

Que se passe-t-il si deux membres du groupe lancent `terraform apply` en même temps, chacun avec son propre fichier d'état ?