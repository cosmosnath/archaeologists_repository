/*
 * Inspecter le résultat de la création de la table dbp_organisations
 */

-- Vérifier s'il y a des lignes à double:
-- si le résultat est vide (pas de lignes) il n'y a pas de doublons
SELECT lp.organisation 
    FROM dbp_organisations_avec_noms lp 
    GROUP BY organisation
    HAVING COUNT(*) > 1 ;
-- il y en a une : UCL_Institute_of_Archaeology

-- Retenir seulement le premier nom dans l'ordre alphabétique
-- afin d'éliminer les organisations à double
SELECT organisation, min(label),  "Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
	FROM dbp_organisations_avec_noms
	GROUP BY organisation;

-- compter les organisations à importer (sans doublons)
SELECT COUNT(*)
FROM (SELECT organisation, min(label),  
"Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. table dbp_organisations_avec_noms"
	FROM dbp_organisations_avec_noms
	GROUP BY organisation);

-- insérer les données dans la table 'organisation'
INSERT INTO organisation (name, dbpedia_uri, import_metadata)
    SELECT min(label), organisation, "Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. table dbp_organisations_avec_noms"
    FROM dbp_organisations_avec_noms
	GROUP BY organisation ;

-- insérer la référence de chaque ligne de la table 'organisation' dans la table 'reference'
INSERT INTO reference (fk_organisation, exact_reference, fk_sparql_query)
SELECT pk_organisation, dbpedia_uri, 4
FROM organisation p;

/*
 * Première tentative d'exploration de la table 'organisation'
 */

-- personnes qui étudient et travaillent dans la même organisation
SELECT p.name, da1.person, da1.organisation, da2.organisation 
from dbp_appartenance da1 
    JOIN dbp_appartenance da2 ON da1.person = da2.person 
    join person p on p.dbpedia_uri = da1.person 
where da1.membership_type = 'almaMater'
and da2.membership_type = 'institution'
and da1.organisation = da2.organisation 
-- elles sont au nombre de 9.