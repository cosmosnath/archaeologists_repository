-- si le résultat est vide (pas de lignes) il n'y a pas de doublons
SELECT person_uri
FROM dbp_liste_personnes lp 
GROUP BY person_uri
HAVING COUNT(*) > 1 ;


-- compter les personnes à importer
SELECT COUNT(person_uri)
FROM dbp_liste_personnes lp;


INSERT INTO person (birth_date, dbpedia_uri, name, import_metadata)
SELECT birthYear, person_uri, persname, "Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. archaeologists/DBpedia/importation_personnes.md"
FROM dbp_liste_personnes lp ;

INSERT INTO reference (fk_person , exact_reference , fk_sparql_query)
SELECT pk_person, dbpedia_uri, 1
FROM person p;