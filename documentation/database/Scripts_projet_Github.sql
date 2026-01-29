SELECT diploma, COUNT(*) as number
FROM formation
GROUP by diploma ;

SELECT COUNT(*) FROM formation
WHERE diploma is 'Doctorat' ;

SELECT COUNT(*) FROM formation
WHERE diploma is 'Doctorat'and fk_organisation is 7 ;

SELECT nationality, COUNT(*) as number
FROM person p
GROUP by nationality ;

SELECT COUNT(*) FROM person p 
WHERE nationality is 'britannique' ;

SELECT COUNT(*) FROM persons_relationship pr 
WHERE pr.fk_persons_relationship_type is 4 ;

SELECT COUNT(*)
FROM (SELECT pr.fk_persons_relationship_type, prt.name, prt.pk_person_relationship_type, prt.fk_specialize_relationship_type 
from persons_relationship pr 
    JOIN persons_relationship_type prt ON pr.fk_persons_relationship_type = prt.pk_person_relationship_type  
where prt.fk_specialize_relationship_type is 1
GROUP by prt.name) ;

SELECT prt.name, COUNT(*) as number
-- pr.fk_persons_relationship_type, prt.pk_person_relationship_type, prt.fk_specialize_relationship_type
from persons_relationship pr 
    JOIN persons_relationship_type prt ON pr.fk_persons_relationship_type = prt.pk_person_relationship_type
WHERE prt.fk_specialize_relationship_type is 1
GROUP by prt.name ;

SELECT gender, COUNT(*) as number
FROM person
GROUP by gender

SELECT p.gender, COUNT(*) as number
FROM person p
	JOIN following fo ON p.pk_person = fo.fk_person 
	JOIN formation f ON fo.fk_formation = f.fk_formation_type
WHERE f.diploma = "License"
-- f.fk_formation_type is 1
GROUP by gender ;

-- il faudrait un script pour trier les archéologues par période ou siècle
SELECT COUNT(p.pk_person) as person
FROM person p
WHERE p.birth_date < 1850 ;
