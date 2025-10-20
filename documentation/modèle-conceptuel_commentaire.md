Ce document contient le commentaire, avec exemples, du modèle conceptuel.

## Person

Tout être humain. 

### Propriétés
Nom standard, notice, le genre, éventuellement la date de mort.
Il s'agit d'une classe objet (persistent item)


## Occupation

Un métier ou tout autre type d'occupation
Il s'agit d'une classe objet (persistent item)

### Propriétés
Nom standard, notice

### Relations
Une relation réfléxive de spécialisation, termes plus génériques associés à des termes plus précis.
Par exemple 'épicier' spécialise le terme de 'négociant'.


## Pursuit

Le fait d'avoir telle occupation ou activité durant telle période 
Il s'agit d'une classe temporalité (temporal entity)

Exemple: 

### Relations
Une _Pursuit_ peut comprend une et une seule personne, une et une seule occupation (ces deux relations sont nécessaires) et éventuellement on peut associer une (et une seule) organisation auprès de laquelle l'activité est exercée.

Si plusieurs organisation sont concernées par une activité, plusieurs individus de la classe _Pursuit_ seront créées.


## Formation

Le fait de suivre des cours ou de pratiquer un activité dans le but d'obtenir une certification, un diplôme ou toute autre sorte de reconnaissance de compétences
Il s'agit d'une classe temporalité ?