# adventure-works

## Installation :
- Lancer le dokcer compose : `docker-compose up`

## Contexte :
La direction d'Adventure Works souhaite optimiser ses opérations commerciales et améliorer ses ventes.
Ils ont besoin d'informations détaillées sur les ventes, les produits et les clients pour prendre des décisions éclairées.
L'équipe data d'aventure works a déjà posé les bases de la gestion des données.
Création d'une BDD OLTP et d'un datawarehouse.
Cependant le data engineer et le data analyst ont été débauché la semaine dernière par google et ils ont laissé le projet innachevé.

Vous êtes embauché afin de reprendre le travail accompli et de le terminer. Votre rôle est multiple et il se décompose dans les tâches suivantes :

1) Récupérer les données

      Les données ont été sauvegardées sous la forme d'un .bak et vous devez reconstituer la base de données. Il y a deux fichier de restauration AdventureWorks2019.bak et AdventureWorksDW2019.bak. Vous devez recréer les bases de données en local et faire les tâches suivantes :
      
      Trouver un moyen de faire ce back up en local
      Utiliser un outil pour se connecter à cette BDD
      Faire une visualisation du Entity Relational Diagram (ERD)
      Expliquer le rôle de chaque BDD. Quel est leur utilité ? Quel est leur lien ? Expliquer le concept d’ETL.
      Qu'est ce que OLTP, OLAP, DataWarehouse, Datalake, DataMart et DataMesh?
      
      Pour les étapes suivantes, il est indiqué entre parenthèses quelle BDD utilisée.


2) Faire des requêtes SQL (OLTP)

      L'équipe BI vous a listé 100 problématiques récurrentes que vous transformez en requête SQL. Vous devez sauvegarder ces requêtes dans un script.
      
      Étant donné que vous venez de vous intégrer l'équipe et que vous êtes toujours en période d'essai, votre N+1, le lead data, aimerait évaluer vos compétences en SQL grâce à cette exercice.


3) Déployer la BDD sur Azure (DW)

      Vous pouvez utiliser la méthode de votre choix (instance de container ou Azure SQL Databases).
      Attention, si vous optez pour le deuxième choix, faites valider votre configuration par votre responsable (Charles ou Jérémy) avant de la déployer,
      les coûts peuvent être très élevés.

​

4) Créer un Dashboard (DW)
      
      L’équipe de direction à besoin d’un tableau de bord pour pouvoir faire un suivi d’activité de l’entreprise.
      
      En vous inspirant des requêtes SQL effectués, effectuer un tableau de bord qui sera utilisé par l'équipe de direction.
      
      Vous avez le choix des technos : Django, PowerBI, streamlit, etc
