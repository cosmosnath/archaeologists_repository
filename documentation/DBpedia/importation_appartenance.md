# Importer des appartenances et autres propriétés de type 'membership' depuis DBpedia

## Identifier Les propriétés de type 'membership'
On souhaite identifier les propriétés liées à des concepts qui se rapprochent du concept d'appartenance à une organisation (i.e., à la classe membership).

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?p1 (COUNT(*) as ?eff)
WHERE { 
dbr:List_of_archaeologists ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    ?p1 ?object.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    ### noter le filtre qui cherche uniquement les propriétés nettoyées de type 'ontology'
    FILTER (( ?birthYear > 1770) && (CONTAINS(STR(?p1), 'ontology') ))
}
GROUP BY ?p1
ORDER BY DESC(?eff)

Les propriétés qui ressortent grâce à cette requête sont :
- http://dbpedia.org/ontology/almaMater pour 124 cas
- http://dbpedia.org/ontology/institution pour 74 cas

### Récupérer les données - Universités fréquentées

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?person (?almaMater AS ?organisation) 
                            ("almaMater" as ?membership_type) (2 AS ?fk_sparql_query)
                              (STR("Importation 7 décembre 2025") as ?metadata)
WHERE { 
dbr:List_of_astronomers ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    dbo:almaMater ?almaMater.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770)
}

Ces données serviront à créer une table appelée dbp_appartenance.
-> à mettre en italique !

### Récupérer les données - Institutions (comme appartenance)

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?person (?institution AS ?organisation)
                               ("institution" as ?membership_type) (3 AS ?fk_sparql_query)
                              (STR("Importation 7 decembre 2025") as ?metadata)
WHERE { 
dbr:List_of_archaeologists ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    dbo:institution ?institution.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770)
}

Ces données seront ajoutées à la table dbp_appartenance.
-> à mettre en italique !

### Inspecter le résultat de l'importation des appartenances aux organisations

-- regrouper par type d'appartenance

SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;

    -> Il y a 124 alma mater et 74 institutions.

-- compter les organisations impliquées dans les appartenances

SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;

    -> Celle qui apparaît le plus grand nombre de fois dans la table est University_of_Cambridge (8 occurrences).

## Récuperer les noms des organisations des deux types de relations d'appartenance

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?organisation (STR(?organisationLabel) AS ?label)
                                (group_concat(DISTINCT  ?type, ',') as ?types)
                                (4 AS ?fk_sparql_query)
                                (STR("Importation 25 novembre 2025") as ?metadata)
        WHERE { 
        {
        dbr:List_of_archaeologists ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            dbo:institution ?organisation.
        ?organisation rdfs:label ?organisationLabel
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            BIND('institution' as ?type)
            FILTER ( ?birthYear > 1770 && LANG(?organisationLabel)='en')
    }
    UNION
    {
        dbr:List_of_archaeologists ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            dbo:almaMater ?organisation.
        ?organisation rdfs:label ?organisationLabel
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            BIND('almaMater' as ?type)
            FILTER ( ?birthYear > 1770 && LANG(?organisationLabel)='en')
    }
        }
    GROUP BY ?organisation ?organisationLabel

## Importer les organisations

### Inspecter le résultat de la création de la table dbp_organisations
-> à mettre en italique !

-- Vérifier s'il y a des lignes à double:

-- si le résultat est vide (pas de lignes) il n'y a pas de doublons

SELECT lp.organisation 
    FROM dbp_organisations_avec_noms lp 
    GROUP BY organisation
    HAVING COUNT(*) > 1 ;

    -> Il y en a un : UCL_Institute_of_Archaeology.

-- Retenir seulement le premier nom dans l'ordre alphabétique afin d'éliminer les organisations à double

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

    -> Il y en a 134 (au lieu de 135 avec le doublon, i.e., sans le min devant label).

### Insertion des organisations (insérer les données dans la table 'organisation')
-> à mettre en italique !

INSERT INTO organisation (name, dbpedia_uri, import_metadata)
    SELECT min(label), organisation, "Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. table dbp_organisations_avec_noms"
        FROM dbp_organisations_avec_noms
	    GROUP BY organisation ;

### Créer les lignes dans la table 'reference' contenant l'URI de chaque personne et la clé étrangère désignant la requête SPARQL correspondante dans la table 'sparql_query'

INSERT INTO reference (fk_organisation, exact_reference, fk_sparql_query)
SELECT pk_organisation, dbpedia_uri, 4
FROM organisation p;
