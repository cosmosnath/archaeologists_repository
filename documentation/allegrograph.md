# Serveur AllegroGraph

## Identifiants du serveur
Name: agraph-113-cosmosnath

AllegroGraph WebView: https://ag1g6r37fkqqzppm.allegrograph.cloud/webview/welcome

## Remplir le serveur
Alimenter un triplestore pour la recherche personnelle

### Importer les triplets de la population (les personnes)

#### Inspecter les personnes à importer

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person ?label
WHERE {
SERVICE <https://dbpedia.org/sparql> {
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1799  && LANG(?label) = 'en')
    }
}

    -> Il y a 307 lignes donc 307 personnes qui seront importées.

#### Construire les données à importer

Observer si le résultat correspond à ce qu'on souhaite obtenir.

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


CONSTRUCT {?person rdfs:label ?label;
                    a dbo:Person;
                    dbo:birthYear ?bYI.
           }
WHERE {
SERVICE <https://dbpedia.org/sparql> {
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1799  && LANG(?label) = 'en')
    }
  
}

#### Insérer les triplets

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


INSERT {?person rdfs:label ?label;
                    a dbo:Person;
                    dbo:birthYear ?birthYear.
           }
WHERE {
SERVICE <https://dbpedia.org/sparql> {
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1799  && LANG(?label) = 'en')
    }
  
}

#### Inspecter les triplets importés

Les compter

PREFIX dbo: <http://dbpedia.org/ontology/> 

SELECT (COUNT(*) as ?number)
WHERE {?s a dbo:Person}

    -> Résultat : 307 -> cela correspond au nombre obtenu plus haut.

Les inspecter

PREFIX dbo: <http://dbpedia.org/ontology/> 
SELECT ?s ?p ?o
WHERE {?s a dbo:Person;
        ?p ?o.
FILTER (?o != dbo:Person)
    }
ORDER BY ?s ?p
LIMIT 100

### Importer les URI de Wikidata

On veut importer les alignements (les personnes présentes chez DBpedia et chez Wikidata) chez nous pour pouvoir ensuite plus facilement les inspecter et interroger leurs propriétés.

#### Inspecter les triplets à importer

On peut demander à DBpedia comment s'appellent les personnes sur Wikidata.

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

SELECT ?person  ?wikidataUri
    WHERE {

    ?person a dbo:Person.

    SERVICE <https://dbpedia.org/sparql> {
        ?person owl:sameAs ?wikidataUri.
            FILTER (CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
}

#### Insérer les triples d'alignement DBPedia / Wikidata

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

-- CONSTRUCT {?person owl:sameAs ?wikidataUri.}
INSERT {?person owl:sameAs ?wikidataUri.}
    WHERE {

    ?person a dbo:Person.

    SERVICE <https://dbpedia.org/sparql> {
        ?person owl:sameAs ?wikidataUri.
            FILTER (CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
}

#### Inspecter les données importées

PREFIX dbo: <http://dbpedia.org/ontology/> 

SELECT ?s ?p ?o
WHERE {?s a dbo:Person;
        ?p ?o.
FILTER (?o != dbo:Person)
    }
ORDER BY ?s ?p

### Inspecter les informations disponibles dans Wikidata

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?s ?wPerson ?p ?o
WHERE {
?s owl:sameAs ?wPerson;
        a dbo:Person.
OPTIONAL {
SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson ?p ?o.
    FILTER(CONTAINS(STR(?p), 'direct'))
    }     
    }
    
}

#### Compter les propriétés

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?p (count(*) as ?number) ('' as ?label)
WHERE {
?s owl:sameAs ?wPerson;
        a dbo:Person.
OPTIONAL {
SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson ?p ?o.
    FILTER(CONTAINS(STR(?p), 'direct'))
    }     
    }
}
GROUP by ?p
ORDER BY DESC(?number)

La propriété apparaissant le plus de fois parmi les triples importés est P106, avec 1089 occurences.

### Inspecter les propriétés de Wikidata

#### Récupérer un ensemble de personnes et explorer leurs propriétés

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT DISTINCT ?p ?propLabel (count(*) as ?number)
WHERE {
    VALUES ?list {<http://www.wikidata.org/entity/Q15115813> 
            <http://www.wikidata.org/entity/Q32178355>
            <http://www.wikidata.org/entity/Q14837>
            <http://www.wikidata.org/entity/Q17523828>
            <http://www.wikidata.org/entity/Q335189>
        }
        ?list  ?p ?o .
    FILTER(CONTAINS(STR(?p), 'direct'))
    ?propLabel wikibase:directClaim ?p.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
    }
GROUP BY ?p ?propLabel
ORDER BY DESC (?number)

    -> La requête ne donne aucun résultat, pourquoi ?
    -> J'ai dû ajouter les deux préfixes wikibase: et bd:, et changer ?prop en ?propLabel (sinon le serveur me retournait une erreur disant que ?propLabel n'était pas un aggrégat, alors que toutes les variables devaient l'être).