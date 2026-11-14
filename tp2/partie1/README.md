# TP2, partie 1 : une machine virtuelle sur Azure

Séance 2.

## Objectif

Écrire une configuration Terraform qui crée une machine virtuelle Linux accessible en SSH depuis la salle, puis la faire évoluer et la détruire.

## L'architecture à déployer

Dans votre abonnement Azure for Students :

- un groupe de ressources `rg-tp2-<groupe>` ;
- un réseau virtuel `10.0.0.0/16` et un sous-réseau `10.0.1.0/24` ;
- un NSG qui n'autorise SSH (port 22) que depuis l'IP de la salle, associé au sous-réseau ;
- une IP publique Standard et statique ;
- une carte réseau ;
- une VM Linux Ubuntu 24.04, taille `Standard_B1s`.

## Fichiers fournis

Les fichiers de ce dossier sont un point de départ. Les parties marquées `À compléter` sont à écrire par le groupe.

| Fichier | Contenu | À faire |
| --- | --- | --- |
| `providers.tf` | Bloc `terraform` et provider `azurerm` | Rien, à relire |
| `variables.tf` | Variables d'entrée et préfixe des noms | Rien, à relire |
| `terraform.tfvars` | Valeurs du groupe | Mettre le nom du groupe et l'IP de la salle |
| `network.tf` | Groupe de ressources, réseau, sous-réseau | Écrire le NSG et son association |
| `vm.tf` | Indications | Écrire l'IP publique, la carte réseau et la VM |
| `outputs.tf` | Sortie `public_ip` | Rien, à relire |
| `.gitignore` | Fichiers à ne jamais versionner | Rien |

## Étape 1 : préparer l'environnement

Dans WSL :

```bash
# Se connecter à Azure et choisir l'abonnement
az login
az account show --query "{nom:name, id:id}" -o table
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Générer une paire de clés SSH, si ~/.ssh/id_rsa.pub n'existe pas
ssh-keygen -t rsa -b 4096

# Connaître l'IP publique de la salle
curl -s https://ifconfig.me

# Préparer le dossier dans le dépôt du groupe
cd ~/<depot-du-groupe>
cp -r ~/IaC-course/tp2/partie1 tp2
cd tp2
```

- Le provider a besoin de l'identifiant de l'abonnement. La variable d'environnement `ARM_SUBSCRIPTION_ID` évite de l'écrire dans le code. Elle est à exporter dans chaque nouveau terminal.
- L'IP de la salle sert à n'ouvrir SSH qu'aux postes de l'école, et non à tout Internet.

## Étape 2 : providers et variables

1. Relire `providers.tf` et `variables.tf`.
2. Renseigner `terraform.tfvars` : identifiant du groupe et IP de la salle.
3. Vérifier que `.gitignore` est bien présent avant le premier commit.
4. Lancer `terraform init`, puis `terraform validate`.

## Étape 3 : le réseau

Le groupe de ressources, le réseau et le sous-réseau sont déjà dans `network.tf`. À écrire par le groupe :

- un `azurerm_network_security_group` avec un bloc `security_rule` : règle entrante, TCP, port 22, accès autorisé, priorité 100 ;
- la source de la règle est `var.allowed_ssh_ip` ;
- une `azurerm_subnet_network_security_group_association`, qui associe le NSG au sous-réseau.

Sans l'association, le NSG existe mais ne protège rien.

## Étape 4 : la machine virtuelle

À écrire dans `vm.tf` :

| Ressource | Arguments clés |
| --- | --- |
| `azurerm_public_ip` | `sku = "Standard"`, `allocation_method = "Static"` |
| `azurerm_network_interface` | bloc `ip_configuration` : `subnet_id`, `private_ip_address_allocation = "Dynamic"`, `public_ip_address_id` |
| `azurerm_linux_virtual_machine` | `size`, `admin_username`, `network_interface_ids`, `admin_ssh_key`, `os_disk` (`caching`, `storage_account_type`), `source_image_reference` |

Une IP publique Standard bloque le trafic entrant par défaut : seul le NSG ouvre le port 22.

La documentation de chaque ressource se trouve sur le registre Terraform : <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs>.

## Étape 5 : déployer et se connecter

```bash
terraform init
terraform fmt
terraform validate
terraform plan -out tp2.plan
terraform apply tp2.plan
terraform output public_ip
ssh azureuser@$(terraform output -raw public_ip)
```

Vérifiez aussi les ressources créées dans le portail Azure.

À observer :

1. Combien de ressources le plan annonce-t-il ?
2. Dans quel ordre sont-elles créées ?
3. Quels nouveaux fichiers sont apparus dans le dossier ?

## Étape 6 : modifier, puis détruire

1. Ajouter une étiquette (`tags`) à la VM, puis lancer `terraform plan`. Quel symbole apparaît ?
2. Changer `admin_username` dans `terraform.tfvars`, puis lancer `terraform plan`. Que devient la VM ? Ne pas appliquer, et remettre la valeur d'origine.
3. Lancer `terraform destroy`, puis vérifier dans le portail que le groupe de ressources a disparu.

## Suivre ses dépenses

- Créer un budget sur l'abonnement (Cost Management, Budgets) avec une alerte par courriel.
- Suivre la consommation du crédit dans Education Hub, page Overview.
- En fin de séance, aucune ressource ne doit rester active.

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
└── captures/
```

Captures : la sortie du plan et la connexion SSH. Aucun fichier d'état, aucun plan, aucune clé privée.

## Question de réflexion

Que se passe-t-il si deux membres du groupe lancent `terraform apply` en même temps, chacun avec son propre fichier d'état ?

## Pour la séance 3

- Pousser le code du TP2 sur la branche principale du dépôt du groupe.
- Vérifier que `terraform destroy` a bien tout supprimé.
- Lire la documentation Terraform sur les modules.
- Le code doit pouvoir être redéployé sans modification en début de séance 3.
