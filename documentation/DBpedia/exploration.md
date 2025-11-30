
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