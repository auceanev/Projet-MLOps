# Projet MLOps - Prédiction de la qualité du vin

Ce projet est une application Flask containerisée déployée sur AWS App Runner. Elle utilise un modèle de machine learning pour prédire la qualité du vin en fonction de ses caractéristiques chimiques. Tout est automatisé : du build de l'image Docker au déploiement grâce à GitHub Actions.

PARTIE 1: /terraform
PARTIE 2: /app
PARTIE 3: /.github

Dockerfile à la fois pour Partie 1 et 3

---

## Table des matières

1. [Architecture](#architecture)
2. [Prérequis](#prérequis)
3. [Installation pas à pas](#installation-pas-à-pas)
4. [Documentation des API](#documentation-des-api)
5. [Sécurité et gestion des secrets](#sécurité-et-gestion-des-secrets)
6. [Choix techniques](#choix-techniques)

---

## Architecture

L’architecture du projet repose sur les composants suivants :

- **GitHub Actions** : Automatisation des builds et déploiements.
- **AWS ECR** : Stockage des images Docker.
- **AWS App Runner** : Exécution des conteneurs pour déployer l’application Flask.
- **Terraform** : Gestion de l’infrastructure as code (ECR, App Runner).
- **Poetry** : Gestionnaire des dépendances Python.
- **MLflow** : Suivi des expériences machine learning.

### Diagramme d’architecture

```plaintext
+------------------+        +------------------+         +------------------+
|  Developer Push  +------->|  GitHub Actions  +-------->|      ECR         |
+------------------+        +------------------+         +------------------+
                                                                |
                                                                v
                                                        +------------------+
                                                        |  App Runner      |
                                                        +------------------+
                                                                |
                                                                v
                                                    +--------------------------+
                                                    | Flask Application (API)  |
                                                    +--------------------------+
```

---

## Prérequis

Avant de commencer, assurez-vous d’avoir les éléments suivants installés sur votre machine :

1. **Terraform** (version >= 1.10.0)
    - [Documentation officielle](https://developer.hashicorp.com/terraform/downloads)
2. **AWS CLI** (version >= 2.0)
    - [Installation AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. **Un compte AWS**
    - [Créer un compte AWS](https://aws.amazon.com/)

---

## Installation pas à pas

### Étape 1 : Bootstrapper l’infrastructure

1. Clonez ce dépôt :
   ```bash
   git clone <url_du_projet>
   cd <nom_du_dossier>
   ```

2. Initialisez Terraform dans le dossier `01_bootstrap` :
   ```bash
   cd 01_bootstrap
   terraform init
   terraform apply
   ```
   Cela créera un repository Amazon ECR pour stocker les images Docker.

---

### Étape 3 : Build de l'image

1. Sur Github, ajoutez les secrets:
   ```
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   AWS_REGION
   ECR_REPOSITORY (output repository_url venant de l'étape 1)
   ```
   
    Puis, relancez le workflow `Deploy to App Runner - Image based` pour build l'image et la pousser sur ECR.

### Étape 3 : Déployer l’application

1. Retournez à la racine et exécutez Terraform dans `02_deploy` :
   ```bash
   cd ../02_deploy
   terraform init
   terraform apply
   ```
   Cela déploiera l’application sur AWS App Runner en utilisant l’image stockée dans ECR.

---

### Pour la suite : Automatisation via GitHub Actions

La **GitHub Actions** automatise la génération et le déploiement des images Docker :

- Sur chaque `push`, l’image Docker est :
    1. Buildée via l’action GitHub.
    2. Poussée sur Amazon ECR.
    3. Déployée automatiquement sur App Runner.

- Une fois le trois étapes réalisées, l'application est en ligne et prête à être utilisée. Vous pourez mettre à jour les éléments de chaque étapes indépendamment.

---

## Documentation des API

L’API Flask dispose de deux routes principales :

1. **GET `/`**
    - **Description** : Teste si l’API est en ligne.
    - **Réponse attendue** : `"Hello World!"`

2. **POST `/predict`**
    - **Description** : Prédiction de la qualité du vin.Il

3. **GET `/metrics`**
    - **Description** : Récupère les métriques de l'API.

---

### Monitoring avec Grafana et Prometheus

1. Prometheus est configuré, il n'est manque récupération dynamique de l'url de l'API pour pouvoir récupérer les informations.
2. Grafana est configuré, il faut ajouter un dashboard pour pouvoir visualiser les métriques de l'API.
3. Sur l'API, un plugin pour exporter les données a été ajouté.

La problématique non résolu par manque de temps est le partage dynamique de l'url de l'API et de prometheus entre prometheus et Grafana.

---

## Sécurité et gestion des secrets

1. **Secrets GitHub Actions** :
    - Les clés AWS (`AWS_ACCESS_KEY_ID` et `AWS_SECRET_ACCESS_KEY`) sont stockées dans les **Secrets GitHub**. Bien que cela fonctionne, il est recommandé d'utiliser **OIDC** pour une meilleure sécurité.

2. **OIDC (OpenID Connect)** :
    - GitHub permet d’associer des rôles AWS directement via OIDC, sans clés statiques.
    - [Documentation OIDC GitHub-AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

3. **Bonnes pratiques** :
    - Ne jamais committer vos clés AWS dans le code.
    - Envisagez d’utiliser des solutions comme AWS Secrets Manager pour centraliser les secrets.

---

## Choix techniques

1. **Infrastructure** :
    - Utilisation de **AWS App Runner** pour simplifier le déploiement de conteneurs, sans gérer d'instances.
    - **Amazon ECR** est utilisé pour stocker l’image Docker.

2. **CI/CD** :
    - **GitHub Actions** assure l’automatisation totale du pipeline, du build à la mise à jour d’App Runner.

3. **Infrastructure as Code** :
    - **Terraform** permet de gérer toute l’infrastructure de manière déclarative.
    - Le backend Terraform est local pour simplifier la configuration. Une migration vers S3 peut être envisagée pour un usage en équipe.

4. **Application** :
    - L’application est entièrement containerisée.
    - Les dépendances Python sont gérées avec **Poetry** pour une meilleure reproductibilité.

5. **Améliorations possibles** :
    - Configuration d’OIDC pour sécuriser les secrets.
    - Déploiement Terraform directement depuis GitHub Actions pour une chaîne CI/CD entièrement automatisée.

---

## Notes finales

Ce projet met en œuvre un pipeline moderne avec un déploiement sans serveur sur AWS. Les bonnes pratiques d’automatisation et de gestion des conteneurs sont au cœur de la solution, avec des améliorations possibles pour optimiser encore la sécurité et la scalabilité.