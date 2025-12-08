# Importation des personnes depuis DBpedia

## Production de données à exporter
### Liste des archéologues à exporter - Requête sur le serveur SPARQL de DBPedia
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT DISTINCT ?person_uri (STR(?label) AS ?persName) ?birthYear
WHERE { 
    dbr:List_of_archaeologists ?p ?person_uri.
    ?person_uri a dbo:Person;
            dbo:birthDate ?birthDate;
            rdfs:label ?label.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770
            && LANG(?label) = 'en')
}
ORDER BY ?birthYear

## Importer les personnes
### Vérifier l'absence de doublons
-- si le résultat est vide (pas de lignes) il n'y a pas de doublons

SELECT person_uri
FROM dbp_liste_personnes lp 
GROUP BY person_uri
HAVING COUNT(*) > 1 ;

        -> Résultat sur DBeaver = 0 ligne, donc aucun doublon

-- compter les personnes à importer

SELECT COUNT(*)
FROM dbp_liste_personnes lp;

        -> Résultat sur DBeaver = 318

### Comparaison avec les données de DBpedia
Compter les personnes dans la liste directement à partir de DBpedia pour vérifier que j'ai le bon nombre de personnes à importer sur DBeaver

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT (COUNT(DISTINCT ?person) AS ?number)
WHERE { 
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate;
            rdfs:label ?label.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770
            && LANG(?label) = 'en')
}

        -> Résultat obtenu du serveur SPARQL de DBpedia = 222 -> ne correspond pas au résultat de la requête SQL sur DBeaver

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT (COUNT(?person) AS ?number)
WHERE { 
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate;
            rdfs:label ?label.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770
            && LANG(?label) = 'en')
}

        -> Résultat obtenu du serveur SPARQL de DBpedia = 318 -> correspond au résultat de la requête SQL sur DBeaver

Pourquoi la différence ?


### Insertion des personnes
INSERT INTO person (birth_date, dbpedia_uri, name, import_metadata)
SELECT birthYear, person_uri, persname, "Importé le 7 décembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. archaeologists/DBpedia/importation_personnes.md"
FROM dbp_liste_personnes lp ;

### Créer les lignes dans la table 'reference' contenant l'URI de chaque personne et la clé étrangère désignant la requête SPARQL correspondante dans la table 'sparql_query'
INSERT INTO reference (fk_person , exact_reference , fk_sparql_query)
SELECT pk_person, dbpedia_uri, 1
FROM person p;