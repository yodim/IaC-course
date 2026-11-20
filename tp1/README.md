# TP1 : configuration manuelle et automatisée

Séance 1. Durée : environ 50 minutes.

## Objectif

Comparer la gestion traditionnelle et l'Infrastructure as Code sur une même machine : vous installez Nginx à la main, puis PostgreSQL avec un script bash que vous lancez deux fois. Le formateur montre ensuite le même travail avec un playbook Ansible. La question qui nous intéresse : que se passe-t-il quand on relance ?

## Déroulement

| Étape | Qui | Où | Durée |
| --- | --- | --- | --- |
| 1. Nginx à la main | Le groupe | La VM du groupe, `vm-<groupe>` | 20 min |
| 2. PostgreSQL par script, lancé deux fois | Le groupe | La même VM | 15 min |
| 3. Playbook Ansible, lancé deux fois | Le formateur, en démonstration | Le poste du formateur | 5 min |
| 4. Bilan | Toute la classe | Tableau de comparaison | 10 min |

Une seule personne au clavier à la fois : si deux membres lancent une installation ou le script en même temps, les commandes se gênent et les résultats de l'étape 2 deviennent illisibles. Changez de personne entre les étapes.

## Fichiers fournis

| Fichier | Usage |
| --- | --- |
| `runbook.md` | Modèle de runbook à remplir pendant l'étape 1 |
| `install.sh` | Le script de l'étape 2 |
| `site.yml` | Le playbook de la démonstration (étape 3), pour lecture : il est lancé par le formateur, pas par les groupes |
| `comparaison.md` | Le tableau de comparaison et les questions de l'étape 2 |

## Accès à la VM

Chaque groupe reçoit une fiche d'accès avec l'IP de sa VM et son mot de passe. On se connecte avec l'utilisateur `etudiant` :

```bash
ssh etudiant@<ip-vm>
```

La VM est une Ubuntu 24.04 vierge. Elle n'est joignable que depuis la salle.

## Étape 1 : Nginx à la main

Sur la VM du groupe, tapez les commandes une par une, et documentez au fur et à mesure dans `runbook.md` : la commande exécutée, le résultat obtenu, le temps passé, chaque erreur ou faute de frappe et chaque recherche sur Internet. Ces mesures serviront au bilan.

1. Se connecter en SSH à la VM du groupe.
2. Mettre à jour la liste des paquets :

   ```bash
   sudo apt-get update
   ```

3. Installer Nginx :

   ```bash
   sudo apt-get install -y nginx
   ```

4. Vérifier que Nginx tourne et qu'il démarrera au prochain boot :

   ```bash
   systemctl status nginx --no-pager
   systemctl is-enabled nginx
   ```

5. Remplacer la page d'accueil par le nom du groupe :

   ```bash
   echo "<h1>Groupe 1</h1>" | sudo tee /var/www/html/index.html
   ```

6. Vérifier que la page répond sur le port 80 :

   ```bash
   curl http://localhost
   ```

À la fin de l'étape, le runbook doit être complet : une autre personne doit pouvoir refaire l'installation en le suivant, sans aide.

## Étape 2 : PostgreSQL par script

Le script `install.sh` installe PostgreSQL, crée un utilisateur `app` et une base `appdb`, et déclare le nom `db.local` dans `/etc/hosts`. Téléchargez-le sur la VM (ou recréez-le avec `nano install.sh`), puis lancez-le deux fois de suite :

```bash
curl -fsSLO https://raw.githubusercontent.com/yodim/IaC-course/main/tp1/install.sh
sudo bash install.sh   # une fois
sudo bash install.sh   # et une deuxième
```

Pour voir ce que le script a créé :

```bash
grep db.local /etc/hosts
sudo -u postgres psql -c '\du'    # les utilisateurs PostgreSQL
sudo -u postgres psql -l          # les bases
```

À observer et à noter dans `comparaison.md` :

1. Que se passe-t-il à la deuxième exécution ?
2. Regardez `/etc/hosts` : combien de lignes `db.local` contient-il ?
3. La commande `createdb` a-t-elle tourné ? Pourquoi ?
4. Et si l'erreur était sur la première ligne ?

## Étape 3 : démonstration avec Ansible

Le formateur lance `site.yml` deux fois de suite sur son poste. Le playbook fait d'un coup ce que vous avez fait en deux parties : Nginx et sa page, PostgreSQL et la ligne `db.local`.

Comparez le `PLAY RECAP` des deux exécutions, en particulier la valeur de `changed`. Vous n'avez rien à lancer : on reviendra sur ce playbook en séance 4.

## Étape 4 : bilan

Remplissez `comparaison.md` avec vos mesures pour les lignes « À la main » et « Script ». Pour la colonne « Temps », estimez le temps qu'il faudrait pour faire votre partie sur 20 serveurs, pas sur un seul. La ligne « Playbook Ansible » se remplit avec toute la classe, à partir de la démonstration. La colonne la plus importante est celle de la deuxième exécution.

## Pour la séance 2

- Installer WSL2 avec Ubuntu (sous Windows).
- Installer VS Code et Git.
- Installer Terraform, Ansible et Azure CLI dans WSL.
- Avoir un compte GitHub, et créer le dépôt du groupe.
- Activer Azure for Students avec votre adresse de l'école.
- Vérifier : `terraform -version` et `az login`.
