
https://en.wikipedia.org/wiki/Gertrude_Bell URL

http://dbpedia.org/resource/Gertrude_Bell URI IRI
-> pk de Gertrude Bell dans la base de données relationnelles

## Trouver une ressource (ou une instance) en particulier
PREFIX dbr: <http://dbpedia.org/resource/>
SELECT *
WHERE 
{
  dbr:Gertrude_Bell ?p ?o
}

## Compter le nombre de personnes dans la liste Wikipédia d'archéologues (en anglais).
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>

SELECT (COUNT(?person) AS ?number) ?p
WHERE { 
  dbr:List_of_archaeologists ?p ?person.
  ?person a dbo:Person.
  }
## Résultat : 744

## Trouver une ressource dans la liste qui n'est pas une personne +...
PREFIX dbr: <http://dbpedia.org/resource/>
  PREFIX dbo: <http://dbpedia.org/ontology/>
  PREFIX dbp: <http://dbpedia.org/property/>
  SELECT ?s1
  WHERE { ?s1 dbo:occupation dbr:Archaeologist.
              MINUS { ?s1 a dbo:Person.}
  }

## Obtenir les 10 premiers individus qui font partie de la liste et sont des personnes.
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?p ?o1 
WHERE { 
  dbr:List_of_archaeologists ?p ?o1.
  ?o1 a dbo:Person.
  }
LIMIT 10


PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?person ?object
WHERE { 
dbr:List_of_astronomers ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    <http://www.w3.org/2002/07/owl#sameAs> ?object.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770)
}
LIMIT 100


## Ici, on met la propriété <http://www.w3.org/2002/07/owl:sameAs> en préfixe et on insère juste owl:sameAs dans la partie ...
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
SELECT ?addr (COUNT(*) AS ?number)
WHERE { 
dbr:List_of_archaeologists ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    owl:sameAs ?object.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770)
BIND(SUBSTR(STR(?object), 1, 20) as ?addr)
}
GROUP BY ?addr
ORDER BY DESC(?number)


PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

SELECT ?person ?object
WHERE { 
dbr:List_of_archaeologists ?p ?person.
?person a dbo:Person;
        dbo:birthDate ?birthDate ;
    owl:sameAs ?object.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
}
LIMIT 10


##Le script suivant ne fonctionne pas, car il affiche une seule personne au lieu de 3. 
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?person ?gndUri ?p1 ?o1
WHERE {

SERVICE <https://dbpedia.org/sparql> {
SELECT ?person ?gndUri ?object
    WHERE { 
    dbr:List_of_archaeologists ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        owl:sameAs ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
        BIND( URI(REPLACE(STR(?object), 'http', 'https'))  AS ?gndUri)
    }
    LIMIT 3
}

?gndUri ?p1 ?o1
}


PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

PREFIX owl: <http://www.w3.org/2002/07/owl#>
SELECT ?p1 (COUNT(*) AS ?number) WHERE {
  SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?gndUri ?object WHERE {
      dbr:List_of_archaeologists ?p ?person .
      ?person a dbo:Person ;
              dbo:birthDate ?birthDate ;
              owl:sameAs ?object .
      BIND (xsd:integer(SUBSTR(STR(?birthDate),1,4)) AS ?birthYear)
      FILTER (?birthYear > 1770 && CONTAINS(STR(?object),'gnd'))
      BIND (URI(REPLACE(STR(?object), 'http', 'https')) AS ?gndUri)
    }
  }
  ?gndUri ?p1 ?o1
}
GROUP BY ?p1
ORDER BY DESC(?number)