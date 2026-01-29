Ce document contient le commentaire, avec exemples, du modèle conceptuel.

## Person

Tout être humain. 
Il s'agit d'une classe objet (persistent item).

Exemple : 'Louise Leakey' est une personne.

### Propriétés
Nom standard, le genre, une définition (contenant les métiers ou activités exercés par la personne durant sa vie), les dates de naissance et de mort, le domaine d'expertise (ou spécialité), le lieu de naissance.

### Relations
Des relations depuis les tables *Formation* pour savoir quelle formation la personne a suivie ;
vers *Geographical place* pour savoir où la personne est née ;
depuis *Organisation* pour savoir à quelle organisation la personne a appartenu ;
depuis *Persons' Relationship* pour savoir quel genre de relation la personne a eu et avec qui ;
depuis *Pursuit* pour savoir quelle occupation la personne a eu et où et/ou dans quelle organisation ;
depuis *Site* pour savoir quel site la personne a fouillé.


## Occupation

Un métier, une activité ou tout autre type d'occupation.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Directeur de fouilles' est une occupation.

Remarque : nous avons utilisé principalement des noms communs au masculin pour les différentes occupations pour plus de simplicité et pour ne pas trop alourdir (en incluant aussi le féminin ou le langage épicène) une base déjà dense.

### Propriétés
Nom standard, éventuellement le type d'occupation.

### Relations
Une relation réfléxive de spécialisation (termes plus génériques associés à des termes plus précis).
Par exemple, 'chercheur postdoctoral' est un type de 'chercheur'.

Une relation depuis la table *Pursuit* pour savoir quelle occupation est poursuivie. 


## Pursuit

Le fait d'avoir ou de poursuivre telle occupation ou activité durant telle période.
Il s'agit d'une classe temporalité (temporal entity).

Exemple: 'Helge Marcus Ingstad a été gouverneur de la Terre d'Erik le Rouge de 1932 à 1933'.

### Propriétés
Une personne, une occupation, éventuellement une date de début, une date de fin, une organisation, un lieu géographique et un employeur.

### Relations
Une *Pursuit* comprend une et une seule personne, une et une seule occupation (ces deux relations sont nécessaires). On peut éventuellement associer une (et une seule) organisation auprès de laquelle l'activité est exercée, un (et un seul) lieu géographique dans lequel l'occupation est poursuivie ou un (et un seul) employeur pour lequel l'activité est exercée.

Si plusieurs organisations, plusieurs lieux géographiques ou plusieurs employeurs sont concernés par une activité, plusieurs individus de la classe *Pursuit* seront créés.

Des relations vers les tables *Geographical place* pour savoir où se déroule l'occupation qui est poursuivie ;
vers *Occupation* pour savoir quelle occupation a été ou est poursuivie ;
vers *Organisation* pour savoir avec ou dans quelle organisation l'occupation a été ou est poursuivie ;
vers *Person* pour savoir par quelle autre personne la personne a été ou est employée.


## Organisation

Un organisme, un établissement ou tout autre type de groupe d'êtres humains réunis avec un certain but ou le cadre dans lequel ils se réunissent.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Université d'Uppsala', 'Coryndon Museum', 'Société berlinoise d'anthropologie, d'ethnologie et de préhistoire' et 'Projet de recherches "Koobi Fora"' sont tous des organisations.

### Propriétés
Nom standard, définition, lieu géographique et type d'organisation, éventuellement une date de fondation.

### Relations
Des relations depuis les tables *Formation* pour savoir dans quelle organisation se déroule une formation ;
vers *Geographical place* pour savoir où se situe l'organisation ;
vers *Person* pour savoir quelle personne appartient à l'organisation ;
vers *Organisation type* pour savoir à quel type d'organisation l'organisation appartient ;
depuis *Pursuit* pour savoir quelle personne poursuit quelle occupation dans l'organisation.


## Organisation type

Type d'organisation, généralement un nom commun ou un groupe nominal (nom et adjectif) désignant une catégorie générale de groupe de personnes ou d'établissement (accueillant parfois un tel groupe).
Il s'agit d'une classe objet (persistent item).

Exemple : 'Agence publique' est un type d'organisation.

### Propriétés
Nom du type, éventuellement précision du type avec un nom de type général.

Exemple : 'Académie des sciences' est un type d'organisation.

### Relations
Une relation réfléxive de spécialisation (termes plus génériques associés à des termes plus précis).
Par exemple, 'Musée' est un type d'"Institution".

Une relation depuis la table *Organisation* pour savoir quelle organisation est qualifiée par le type.


## Formation

Le fait de suivre des cours ou de pratiquer un activité dans le but de développer des compétences ou d'obtenir une certification, un diplôme ou toute autre sorte de reconnaissance desdites compétences.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Un doctorat en archéologie et histoire ancienne, une formation universitaire dans le domaine des sciences humaines, a été suivi à l'Université Paris-I-Panthéon-Sorbonne'.

### Propriétés
Le domaine, un type de formation et une organisation, éventuellement une spécialité et un diplôme.

Remarque : Pour les propriétés *domain* et *diploma*, nous avons choisi de mettre 'Non spécifié' au lieu de laisser la case vide lorsque l'information n'était pas disponible sur Wikipédia et que nous étions bel et bien sûrs que la formation avait abouti à un diplôme, car nous considérons que les formations que nous étudions (formation secondaire et suivantes) sont toujours comprises dans un domaine et se terminent généralement par un diplôme.

### Relations
Une *Formation* comprend une et une seule organisation et un et un seul type de formation (ces deux relations sont nécessaires). On peut éventuellement associer un (et un seul) domaine, une (ou plusieurs) spécialité et un (et un seul) diplôme.

Si plusieurs organisations, plusieurs types de formation, plusieurs diplômes ou plusieurs domaines sont concernés par une formation, plusieurs individus de la classe *Formation* seront créés. Si plusieurs spécialités sont concernées par une formation, nous avons choisi de simplement les lister à la suite (ou parfois avec un 'et') dans la case correspondante de la base de données.

Des relations vers les tables *Formation type* pour savoir à quel type de formation la formation appartient ;
vers *Organisation* pour savoir dans quelle organisation la formation a lieu ;
vers *Person* pour savoir quelle personne a suivi la formation.


## Formation type

Type de formation, généralement un nom commun ou un groupe nominal (nom et adjectif) désignant une catégorie générale de formation.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Formation professionnelle' est un type de formation.

### Propriétés
Nom du type, éventuellement précision du type avec un nom de type général.

### Relations
Une relation réfléxive de spécialisation (termes plus génériques associés à des termes plus précis).
Par exemple, 'Formation universitaire' est un type de 'Formation supérieure'.

Une relation depuis la table *Formation* pour savoir quelle formation est qualifiée par le type.


## Site

Un lieu possédant des vestiges archéologiques (monuments, mobilier, restes fauniques, ossements humains, etc.), enfouis ou non.
Il s'agit d'une classe objet (persistent item).

Exemple : Le 'Temple de Baalshamin' est un site.

### Propriétés
Nom standard, période(s) chronologique(s), lieu géographique, éventuellement une date de découverte.

Remarque : La date de découverte peut correspondre au moment où on découvre un site, mais aussi à la première fois où le lieu est reconnu comme un site archéologique (par ex. lors d'une première description par un archéologue ou lorsqu'on se rend compte que le lieu, déjà connu auparavant, contient des vestiges) ou au moment où on identifie la position géographique d'un site connu seulement par les sources littéraires ou iconographiques.

### Relations
Des relations vers les tables *Geographical place* pour savoir dans quel lieu se trouve le site ;
vers *Person* pour savoir quelle personne a fouillé le site.


## Geographic place

Un point géographique précis, une région ou tout autre type de lieu géographiquement référencé.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Dresde' est un lieu géographique.

### Propriétés
Nom standard, définition avec la nature du lieu et le pays dans lequel il se trouve, type de lieu géographique, éventuellement la longitude et la latitude

Remarque : Lorsque la latitude est au sud ou la longitude à l'ouest, nous avons choisi d'ajouter un '-' devant les nombres de la coordonnée.

### Relations
Des relations vers les tables *Geographic place type* pour savoir à quel type de lieu géographique le lieu appartient ;
depuis *Organisation* pour savoir quelle organisation se trouve dans le lieu ;
depuis *Person* pour savoir quelle personne est née dans le lieu ;
depuis *Pursuit* pour savoir quelle occupation est poursuivie dans le lieu (et par qui) ;
depuis *Site* pour savoir quel site se trouve dans le lieu.


## Geographic place type

Type de lieu géographique, généralement un nom commun ou un groupe nominal (nom et adjectif) désignant une catégorie générale de lieu géographique.
Il s'agit d'une classe objet (persistent item).

Exemple : 'Commune' est un type de lieu géographique

### Propriétés
Nom du type, éventuellement une définition et précision du type avec un nom de type général.

### Relations
Une relation réfléxive de spécialisation (termes plus génériques associés à des termes plus précis).
Par exemple, 'Ville-arrondissement' est un type d'"Arrondissement".

Une relation depuis la table *Geographical place* pour savoir quel lieu géographique est qualifié par le type.


## Persons' Relationship

Le fait d'avoir tels liens de parenté ou de poursuivre telle relation professionnelle ou académique, ou tout autre type de relation avec  une autre personne durant telle période.
Il s'agit d'une classe temporalité (temporal entity).

Exemple : 'Paul Kosok a employé Maria Reiche de 1938 à 1948'.

### Propriétés
Type de relation, personne source, personne cible, éventuellement date de début et date de fin.

### Relations
Une *Persons' Relationship* comprend un et un seul type de relation et exactement deux personnes (ces deux relations sont nécessaires). On peut éventuellement associer une (et une seule) date de début et une (et une seule) date de fin à la relation.

Si plus de deux personnes sont concernées par une relation, si la relation a plusieurs dates de début et plusieurs dates de fin (elle recommence après un certain temps), si la relation entre deux personnes change de type au cours du temps, plusieurs individus de la classe *Persons' Relationship* seront créés.

Des relations vers les tables *Person* pour savoir quelles personnes sont concernées par la relation ;
vers la table *Persons' Relationship type* pour savoir à quel type de relation entre personnes appartient la relation.


## Persons' Relationship type

Type de relation entre personnes, généralement un adjectif ou un groupe nominal (par ex. un nom et un adjectif) désignant une catégorie générale de relation.
Il s'agit d'une classe objet (persistent item).

Exemple : Une relation 'maritale' est un type de relation.

### Propriétés
Nom du type, définition, éventuellement précision du type avec un nom de type général.

### Relations
Une relation réfléxive de spécialisation (termes plus génériques associés à des termes plus précis).
Par exemple, une relation 'filiale' est un type de relation 'familiale'.

Une relation depuis la table *Persons' Relationship* pour savoir quelle relation est qualifiée par le type.