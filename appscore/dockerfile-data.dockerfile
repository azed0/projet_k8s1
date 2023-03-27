FROM mcr.microsoft.com/mssql/server:2017-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Pass@word

# Copie des fichiers SQL
COPY ./Database/entrypoint.sh .
COPY ./Database/SqlCmdScript.sql .
COPY ./Database/SqlCmdStartup.sh .

# Changement des permissions sur le fichier SqlCmdStartup.sh pour le rendre exécutable
RUN chmod +x ./SqlCmdStartup.sh

# Exécution du script SQL au démarrage du conteneur

CMD /bin/bash ./entrypoint.sh
EXPOSE 1433