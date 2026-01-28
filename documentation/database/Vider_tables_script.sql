/*
La ligne est commentée (ajout de "--" avant la commande) afin d'éviter toute erreur de manipulation — décommenter la ligne afin de l'exécuter, puis recommenter.
Noter que ces instructions se trouvent elles-mêmes dans un commentaire long du langage SQL. Elles ne sont pas 'vues' par le logiciel qui exécute les requêtes, précisément car elles sont 'commentées', ce sont des commentaires du code.
*/
DELETE FROM "person" ;
UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name ='person';
VACUUM;