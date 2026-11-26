# Infrastructure as Code : ressources des TP

Ce dépôt contient le matériel des travaux pratiques de l'élément Infrastructure as Code du module M355 (filière data, INPT) : les énoncés, les scripts fournis et les fichiers à compléter.

Les TP sont publiés au fil des séances. Pensez à faire un `git pull` avant chaque séance.

## Organisation des TP

| Séance | TP | Thème | Dossier |
| --- | --- | --- | --- |
| 1 | TP1 | Configuration manuelle et automatisée | `tp1/` |
| 2 | TP2, partie 1 | Une machine virtuelle dans le cloud avec Terraform | `tp2/partie1/` |

Les TP suivants s'ajouteront à ce tableau au fil des séances.

## Comment utiliser ce dépôt

Ce dépôt sert de point de départ : on n'y travaille pas directement. Chaque groupe a son propre dépôt GitHub, et y copie les fichiers fournis au début de chaque TP :

```bash
git clone https://github.com/yodim/IaC-course.git ~/IaC-course   # une seule fois
cd ~/IaC-course && git pull                                       # avant chaque séance
cp -r ~/IaC-course/<dossier-du-tp> ~/<depot-du-groupe>/
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
- En fin de séance, aucune ressource Azure ne doit rester active, sauf indication contraire dans l'énoncé du TP.
- Suivez votre consommation dans Education Hub et créez un budget avec une alerte par courriel.
