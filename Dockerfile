# Étape 1 : Utiliser une image de base Python 3.12
FROM python:3.12

# Étape 2 : Installer Poetry
RUN pip install --no-cache-dir poetry

# Étape 3 : Définir le répertoire de travail
WORKDIR /app

# Étape 4 : Copier les fichiers nécessaires
COPY ./app/README.md ./README.md
COPY ./app/data/raw/winequality-red.csv ./data/raw/winequality-red.csv
COPY ./app/training/winequality-pred.py ./app-pred.py
COPY ./app/winequality.py ./app.py

COPY pyproject.toml poetry.lock ./

# Étape 5 : Installer les dépendances avec Poetry
RUN poetry install --sync --no-interaction --no-ansi --no-cache

# Étape 6 : Exposer le port (par variable d'environnement)
EXPOSE 5000

# Étape 7 : Définir la commande par défaut
CMD ["poetry", "run", "python3", "./app.py"]