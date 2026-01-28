/*
 * Inspecter le résultat de l'importation des appartenances aux organisations 
 */

-- regrouper par type d'appartenance
SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;

-- compter les organisations impliquées dans les appartenances
SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;
