# TP1 : configuration manuelle et automatisée

Séance 1. Durée : environ 55 minutes.

## Objectif

Comparer la gestion traditionnelle et l'Infrastructure as Code en réalisant la même installation (Nginx et PostgreSQL) de trois façons : à la main, avec un script bash, puis avec un playbook Ansible. On relance ensuite le script et le playbook pour voir ce qui se passe à la deuxième exécution.

## Déroulement

| Étape | Qui | Où | Durée |
| --- | --- | --- | --- |
| 1. Installation à la main | Le groupe | La VM du groupe, `vm-<groupe>` | 20 min |
| 2. Script bash, lancé deux fois | Le groupe | La même VM | 15 min |
| 3. Playbook Ansible, lancé deux fois | Le formateur, en démonstration | La VM `vm-demo` | 10 min |
| 4. Bilan | Toute la classe | Tableau de comparaison | 10 min |

## Fichiers fournis

| Fichier | Usage |
| --- | --- |
| `runbook.md` | Modèle de runbook à remplir pendant l'étape 1 |
| `install.sh` | Le script de l'étape 2 |
| `site.yml` | Le playbook de la démonstration (étape 3), pour lecture : il est lancé par le formateur, pas par les groupes |
| `comparaison.md` | Le tableau de comparaison de l'étape 4 |

## Accès à la VM

Chaque groupe reçoit une fiche d'accès avec l'IP de sa VM et son mot de passe. On se connecte avec l'utilisateur `etudiant` :

```bash
ssh etudiant@<ip-vm>
```

La VM est une Ubuntu 24.04 vierge. Elle n'est joignable que depuis la salle.

## Étape 1 : installation à la main

Sur la VM du groupe, tapez les commandes une par une, et documentez au fur et à mesure dans `runbook.md` : la commande exécutée, le résultat obtenu, le temps passé, chaque erreur ou faute de frappe et chaque recherche sur Internet. Ces mesures serviront au bilan.

1. Se connecter en SSH à la VM du groupe.
2. Mettre à jour la liste des paquets :

   ```bash
   sudo apt-get update
   ```

3. Installer Nginx et PostgreSQL :

   ```bash
   sudo apt-get install -y nginx postgresql
   ```

4. Démarrer et activer les deux services :

   ```bash
   sudo systemctl enable --now nginx postgresql
   ```

5. Remplacer la page d'accueil par le nom du groupe :

   ```bash
   echo "<h1>Groupe 1</h1>" | sudo tee /var/www/html/index.html
   ```

6. Vérifier que tout répond :

   ```bash
   curl http://localhost
   systemctl status nginx --no-pager
   systemctl status postgresql --no-pager
   sudo -u postgres psql -c "SELECT version();"
   ```

À la fin de l'étape, le runbook doit être complet : une autre personne doit pouvoir refaire l'installation en le suivant, sans aide.

## Étape 2 : installation par script

Copiez `install.sh` sur la VM (ou recréez-le avec `nano install.sh`), adaptez le nom du groupe, puis lancez-le deux fois de suite sur la même VM :

```bash
sudo bash install.sh   # une fois
sudo bash install.sh   # et une deuxième
```

À observer et à noter :

1. Que se passe-t-il à la deuxième exécution ?
2. Regardez `/etc/hosts` : combien de lignes `db.local` contient-il ?
3. Le script s'est-il arrêté avant la fin ? Pourquoi ?
4. Comment le rendre idempotent, et à quel prix ?

## Étape 3 : démonstration avec Ansible

Le formateur lance `site.yml` deux fois de suite sur la VM `vm-demo`, une VM vierge à part :

```bash
ansible-playbook site.yml
ansible-playbook site.yml
```

Comparez le `PLAY RECAP` des deux exécutions, en particulier la valeur de `changed`. Vous n'avez rien à lancer : on reviendra sur ce playbook en séance 4.

## Étape 4 : bilan

Remplissez `comparaison.md` avec vos mesures pour les lignes « À la main » et « Script bash ». La ligne « Playbook Ansible » se remplit avec toute la classe, à partir de la démonstration. La colonne la plus importante est celle de la deuxième exécution.

## Pour la séance 2

- Installer WSL2 avec Ubuntu (sous Windows).
- Installer VS Code et Git.
- Installer Terraform, Ansible et Azure CLI dans WSL.
- Avoir un compte GitHub, et créer le dépôt du groupe.
- Activer Azure for Students avec votre adresse de l'école.
- Vérifier : `terraform -version` et `az login`.
