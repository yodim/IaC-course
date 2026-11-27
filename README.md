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
