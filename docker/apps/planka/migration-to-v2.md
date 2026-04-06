Voici un guide de migration structuré pour passer de Planka v1.26.2 à la v2.x en adaptant la configuration officielle à votre fichier Docker Compose actuel.
## Points clés de la migration v2 :

1. Changement d'image : L'image passe de ghcr.io/plankanban/planka à plankanban/planka.
2. Gestion des ports : Le port interne par défaut passe de 1337 à 3000.
3. Volume des Avatars : Le dossier /app/public/user-avatars n'est plus utilisé. Les avatars sont maintenant stockés dans le dossier des pièces jointes (/app/private/attachments).
4. Variables d'environnement : Introduction de TRUST_PROXY (recommandé si vous avez un reverse proxy).

------------------------------

# Guide de Migration Planka v1.26.2 vers v2.x
Ce guide détaille les étapes pour mettre à jour votre instance Planka personnalisée vers la version 2.
## Étape 1 : Sauvegarde de sécuritéAvant toute opération, assurez-vous que votre sauvegarde automatique a fonctionné ou lancez un dump manuel :
```bash
docker exec db-planka pg_dump -U ${PLK_DB_USER} ${PLK_DB_NAME} > backup_pre_v2.sql

## Étape 2 : Préparation des données (Avatars)
En v2, Planka centralise les avatars dans le dossier des pièces jointes. Pour conserver vos avatars actuels : [1] 

   1. Identifiez le contenu de /opt/data-docker/planka/app/user-avatars sur votre hôte.
   2. Copiez (ou déplacez) ce contenu vers /opt/data-docker/planka/app/attachments/user-avatars.

## Étape 3 : Mise à jour du fichier docker-compose.yml
Modifiez votre fichier avec les changements suivants (Image, Ports, Volumes) :

name: plankanetworks:
  planka-network:
    external: false
services:
  planka:
    image: plankanban/planka:latest  # Changement de dépôt et version
    container_name: planka
    security_opt:
      - no-new-privileges:true
    volumes:
      # Suppression du volume user-avatars (maintenant géré dans attachments)
      - /opt/data-docker/planka/app/project-background-images:/app/public/project-background-images
      - /opt/data-docker/planka/app/attachments:/app/private/attachments
    restart: unless-stopped
    ports:
      - "7812:3000" # Passage du port interne 1337 à 3000
    networks:
      - planka-network
    environment:
      - BASE_URL=${PLK_BASE_URL}
      - DATABASE_URL=postgresql://${PLK_DB_USER}:${PLK_DB_PWD}@db-planka:5432/${PLK_DB_NAME}
      - SECRET_KEY=${PLK_SECRET_KEY}
      - TOKEN_EXPIRES_IN=365
      - TRUST_PROXY=1 # Recommandé pour v2 si derrière un reverse proxy
      - DEFAULT_ADMIN_EMAIL=${DEFAULT_ADMIN_EMAIL}
      - DEFAULT_ADMIN_PASSWORD=${DEFAULT_ADMIN_PASSWORD}
      - DEFAULT_ADMIN_NAME=${DEFAULT_ADMIN_NAME}
      - DEFAULT_ADMIN_USERNAME=${DEFAULT_ADMIN_USERNAME}
      - SMTP_HOST=$SMTP_HOST
      - SMTP_PORT=$SMTP_PORT
      - SMTP_NAME=$SMTP_NAME
      - SMTP_SECURE=$SMTP_SECURE
      - SMTP_USER=$SMTP_USER
      - SMTP_PASSWORD=$SMTP_PASSWORD
      - SMTP_FROM=$SMTP_FROM
      - SMTP_TLS_REJECT_UNAUTHORIZED=$SMTP_TLS_REJECT_UNAUTHORIZED
    depends_on:
      db-planka:
        condition: service_healthy
    labels:
      - "docker-volume-backup.stop-during-backup=true"

  db-planka:
    image: postgres:17
    container_name: db-planka
    # ... (reste de votre config inchangé)
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    environment:
      POSTGRES_USER: ${PLK_DB_USER}
      POSTGRES_PASSWORD: ${PLK_DB_PWD}
      POSTGRES_DB: ${PLK_DB_NAME}
      POSTGRESQL_REPLICATION_USE_PASSFILE: false
      TZ: "America/Toronto"
    healthcheck:
      test: [ "CMD-SHELL", "pg_isready -U ${PLK_DB_USER} -d ${PLK_DB_NAME}" ]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - planka-network
    volumes:
      - "/opt/data-docker/planka/postgres:/var/lib/postgresql/data"
      - "/opt/data-docker/planka/db-backups:/opt/db-backups"
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
    labels:
      - "docker-volume-backup.stop-during-backup=true"
      - docker-volume-backup.archive-pre=/bin/bash -c 'pg_dump -U $PLK_DB_USER $PLK_DB_NAME > /opt/db-backups/bck_db_planka$(date +%Y%m%d-%H%M).sql'

  adminer:
    image: adminer:latest
    container_name: planka_adminer
    depends_on:
      - db-planka
    environment:
      ADMINER_DEFAULT_SERVER: db-planka
    networks:
      - planka-network
    restart: unless-stopped
    ports:
      - "7813:8080"

## Étape 4 : Déploiement
Exécutez les commandes suivantes dans l'ordre :

   1. Arrêtez l'ancienne version :
   
   docker compose down
   
   2. Téléchargez la nouvelle image :
   
   docker compose pull
   
   3. Relancez les conteneurs :
   
   docker compose up -d
   
   
## Étape 5 : Vérification

* Accédez à http://votre-ip:7812.
* Vérifiez que vos anciens tableaux et cartes sont présents.
* Allez dans votre profil pour confirmer que votre avatar est toujours visible.


Souhaitez-vous que je vérifie également la configuration de votre **reverse proxy** (Nginx, Traefik, etc.) pour m'assurer que le changement de port ne bloque pas l'accès ?


[1] [https://wiki.crowncloud.net](https://wiki.crowncloud.net/?How_to_Install_Planka_with_Docker_on_CentOS_Stream_9)
