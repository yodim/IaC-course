# Infrastructure as Code : ressources des TP

Ce dépôt contient le matériel des travaux pratiques de l'élément Infrastructure as Code du module M355 (filière data, INPT) : les énoncés, les scripts fournis et les fichiers à compléter.

Les TP sont publiés au fil des séances. Pensez à faire un `git pull` avant chaque séance.

## Organisation des TP

| Séance | TP | Thème | Dossier |
| --- | --- | --- | --- |
| 1 | TP1 | Configuration manuelle et automatisée | `tp1/` |
| 2 | TP2, partie 1 | Une machine virtuelle sur Azure avec Terraform | `tp2/partie1/` |
| 3 | TP2, partie 2 | Modules et état distant | `tp2/partie2/` |
| 4 | TP3, partie 1 | Configurer les VM avec Ansible | `tp3/partie1/` |
| 5 | TP3, partie 2 | Rôles, Ansible Vault et déploiement | `tp3/partie2/` |
| 6 | TP4 | Pipeline CI/CD et sécurité | `tp4/` |

Un dossier qui n'apparaît pas encore ici n'a pas encore été publié.

## Comment utiliser ce dépôt

Ce dépôt sert de point de départ : on n'y travaille pas directement. Chaque groupe a son propre dépôt GitHub, et y copie les fichiers fournis au début de chaque TP. Par exemple, pour la séance 2 :

```bash
git clone https://github.com/yodim/IaC-course.git ~/IaC-course   # une seule fois
cd ~/IaC-course && git pull                                       # avant chaque séance
cp -r ~/IaC-course/tp2/partie1 ~/<depot-du-groupe>/tp2
```

Chaque TP ajoute une brique au précédent, et le projet de groupe assemble le tout. Gardez donc votre code d'une séance à l'autre.

## Environnement de travail

À préparer avant la séance 2 :

- Sous Windows, WSL2 avec Ubuntu. Travaillez dans le dossier personnel de WSL (`~/`), pas sous `/mnt/c`.
- VS Code et Git.
- Terraform, Ansible et Azure CLI, installés dans WSL.
- Un compte GitHub.
- Un abonnement Azure for Students, activé avec votre adresse de l'école (100 $ de crédit, sans carte bancaire).

Pour vérifier :

```bash
terraform -version
ansible --version
az login
```

## Règles communes

- Aucun secret dans un dépôt : pas de clé privée, pas de mot de passe en clair, pas de fichier d'état Terraform.
- En fin de séance, aucune ressource Azure ne doit rester active, sauf le compte de stockage de l'état à partir de la séance 3.
- Suivez votre consommation dans Education Hub et créez un budget avec une alerte par courriel.
