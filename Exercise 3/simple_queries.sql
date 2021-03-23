BEGIN;

--------------------------------------------------Outer Join Queries--------------------------------------------------------

/*OUTER JOIN -> Listings,Reviews
Emfanizei to id twn dwmatiwn me id anamesa sto 42655854 kai to 42706603, thn kritikh, kathws kai to
onoma tou krith pou thn egrapse(epeidh einai outer join mas vgazei kai ta null apotelesmata)
25 rows */

SELECT Listings.id, Reviews.reviewer_name, Reviews.comments
FROM Listings
LEFT OUTER JOIN Reviews ON Listings.id=Reviews.listing_id
WHERE Listings.id BETWEEN '42655854' AND '42706603';

/*OUTER JOIN -> Reviews_summary,Listings
Emfanizei oles tis pleiades(apo 1 fora efoson yparxei to distinct pou afairei ta diplotypa)pou periexoyn to id toy dwmatioy 
,thn hmeromhnia pou vathmologithikai kai thn vathmologia tou sta 100,me thn proypothesh oti einai diathesimo olo ton xrono.
10284 rows 
XWRIS DISTINCT 10300 rows
(Eite vazame left outer join eite full opws twra to apotelesma tha htan to idio dioti kathe stoixeio id tou Listings
syndeetai me 1 stoixeio listing_id tou Reviews_summary(kai perissotera afou yparxoyn diplotypa omws me to distinct 
pairnoume ta monadika)).*/

SELECT DISTINCT Listings.id,Reviews_summary.date,Listings.review_scores_rating
FROM Listings
FULL OUTER JOIN Reviews_summary ON Listings.id = Reviews_summary.listing_id
WHERE Listings.availability_365 = 365;

--------------------------------------------------Inner Join Queries--------------------------------------------------------

/*INNER JOINS -> Calendar,Listings * 2 AND UNION ALL
Emfanizei ta onomata kai to id olwn twn diamerismatwn pou einai diathesima sthn akropolh apo tis
16-7-2020 ews kai tis 18-7-2020 h twn spitiwn pou einai diathesima sto gkazi apo tis 16-7-2020 ews
kai tis 22-7-2020 kathws kai to poso pou prepei na katavlithei gia ena zeugari touristwn upo thn 
proupothesh to poso na mhn ksepernaei ta 100 eurw.
25 rows*/

(SELECT Listings.name,Listings.id, CAST(Calendar.price AS money)*3 AS total_cost
FROM Listings,Calendar
WHERE Listings.id=Calendar.listing_id AND Calendar.date BETWEEN '2020-7-16'
AND '2020-7-18' AND Calendar.available='t' AND CAST(Calendar.price AS money)*3<'100' AND
Listings.neighbourhood_cleansed='ΑΚΡΟΠΟΛΗ' AND Listings.beds='2' AND Listings.property_type='Apartment')
UNION ALL
(SELECT Listings.name,Listings.id, CAST(Calendar.price AS money)*7 AS total_cost
FROM Listings,Calendar
WHERE Listings.id=Calendar.listing_id AND Calendar.date BETWEEN '2020-7-16' AND '2020-7-24' AND Calendar.available='t'
AND CAST(Calendar.price AS money)*7<'100' AND Listings.neighbourhood_cleansed='ΓΚΑΖΙ' AND Listings.beds='2' AND Listings.property_type='House');

/*INNER JOIN -> Listings,Geolocation
Emfanizei to megisto poso pou tha plhrwne kapoios se kapoia perioxh
pou thelei na noikiasei gia ena mhna mia sofita
8 rows */

SELECT MAX(Listings.monthly_price), Listings.neighbourhood_cleansed,Geolocation.geometry_coordinates_0_0_0_0, Geolocation.geometry_coordinates_0_0_0_1
FROM Listings
INNER JOIN Geolocation ON Listings.neighbourhood_cleansed=Geolocation.properties_neighbourhood
WHERE listings.property_type='Loft' AND monthly_price IS NOT NULL 
GROUP BY Listings.neighbourhood_cleansed,Geolocation.geometry_coordinates_0_0_0_0, Geolocation.geometry_coordinates_0_0_0_1;

/*INNER JOIN -> Listings,Reviews
Emfanizei ta id kai tis perioxes pou vriskontai ta dwmatia pou periexoun orismena apospasmata thetikwn sxoliwn kathws 
kai to onoma kai oloklhro to sxolio pou egrapsan oi episkeptes
140 rows */

SELECT Listings.id, Reviews.reviewer_name, Reviews.comments,Listings.neighbourhood_cleansed
FROM Listings
INNER JOIN Reviews ON Listings.id=Reviews.listing_id
WHERE Reviews.comments LIKE 'beautiful apartment %' OR Reviews.comments LIKE 'Great hospitality %' OR
Reviews.comments LIKE 'very comfortable %' OR Reviews.comments LIKE 'fantastic host %' ;

/*INNER JOIN -> Neighbourhoods,Listings
Emfanizei tis geitonies poy arxizoyn apo 'K' kathws kai ton meso oro diathesimothtas twn diamerismatwn twn geitoniwn poy 
arxizoyn apo 'K'
6 rows*/

SELECT Neighbourhoods.neighbourhood,AVG(Listings.availability_365) AS average_availability_per_year
FROM Listings
INNER JOIN Neighbourhoods ON Neighbourhoods.neighbourhood = Listings.neighbourhood_cleansed
WHERE Neighbourhoods.neighbourhood LIKE 'Κ%'
GROUP BY (Neighbourhoods.neighbourhood);

/*INNER JOINS -> Listings,Neighbourhoods AND Listings,Geolocation
Emfanizei ta spitia me to id tous , thn geitonia kathws kai tis sydetagmenes toys, ta opoia exoyn tis ekshs idiothtes:
Ksekinoun me to prothema: ANW oi geitonies twn spitiwn kai vriskode se sydetagmenes me gewgrafiko mhkos 23.5-24 kai 
gewgrafiko platos 37.5-40
180 rows*/

SELECT Listings.id,Neighbourhoods.neighbourhood,Geolocation.geometry_coordinates_0_0_0_0,Geolocation.geometry_coordinates_0_0_0_1
FROM Listings
INNER JOIN Neighbourhoods ON Listings.neighbourhood_cleansed = Neighbourhoods.neighbourhood 
INNER JOIN Geolocation ON Geolocation.properties_neighbourhood = Listings.neighbourhood_cleansed
WHERE Neighbourhoods.neighbourhood LIKE 'ΑΝΩ%' AND (Geolocation.geometry_coordinates_0_0_0_0 BETWEEN '23.5' AND '24') AND (Geolocation.geometry_coordinates_0_0_0_1 BETWEEN '37.5' AND '40');

/*INNER JOIN -> Calendar,Listings
Emfanizei mexri 3 apo ta dwmatia pou einai eleythera apo 10-12 aprilioy toy 2020 kai ta opoia filoxenoyn toylaxiston 23 
atoma(P.X.Mia podosfairikh omada me 18 paiktes 1 proponhth 2 voithous kai 2 giatrous)
3 rows 
Xwris LIMIT 9 rows*/

SELECT Listings.id,Calendar.date,Listings.neighbourhood_cleansed,Listings.price,Listings.beds
FROM Listings
INNER JOIN Calendar ON Listings.id = Calendar.listing_id
WHERE (Calendar.date BETWEEN '2020-4-10' AND '2020-4-12') AND Listings.has_availability = true AND Listings.beds >= 23
LIMIT 3;

/*INNER JOIN -> Listings,Reviews
Emfanizei se fthinousa seira me vash tοn arithmo twn kritikwn, ta id, ta onomata twn dwmatiwn, tis perioxes 
pou vriskontai ta dwmatia kai ton arithmo twn kritikwn to etos 2015
657 rows*/

SELECT Listings.id,Listings.name,Listings.neighbourhood_cleansed,COUNT(Reviews.listing_id) AS number_of_reviews
FROM Listings
INNER JOIN Reviews ON Listings.id=Reviews.listing_id
WHERE Reviews.date BETWEEN '2015-1-1' AND '2015-12-31' 
GROUP BY Listings.id
ORDER BY COUNT(Reviews.listing_id) DESC;

/*INNER JOIN -> Listings,Calendar
Emfanizei gia kathe perioxh to kostos ths diamonhs mias hmeras sto fthinotero ksenodoxeio kathe perioxhs
(dedomenou oti h airbnb katoikia epitrepei elaxisth diamonh mias hmeras)
44 rows*/

SELECT MIN(Calendar.price) AS minimum_cost , Listings.neighbourhood_cleansed
FROM Listings
INNER JOIN Calendar ON Listings.id=Calendar.listing_id
WHERE Calendar.minimum_nights=1
GROUP BY Listings.neighbourhood_cleansed;

/*INNER JOIN -> Listings ,Calendar 
Emfanizei ta dwmatia me id apo 10.000-11.000 opou einai eleuthera kathws kai tis hmeromhnies aytes
1406 rows*/

SELECT Listings.id,Calendar.date
FROM Listings
INNER JOIN Calendar ON Calendar.listing_id = Listings.id
WHERE ((Listings.id BETWEEN 10000 AND 11000)AND Calendar.available = true);

/*INNER JOIN -> Reviews ,Listings
Emfanizei tis kritikes twn atomwn pou emeinan sta dwmatia ton Genarh toy 2019 ,to dwmatio kai to id tou,taksinomhmena basei
tou onomatos twn kritwn.
6476 rows*/

SELECT Reviews.reviewer_name,Reviews.date,Reviews.comments,Listings.id,Listings.name
FROM Listings
INNER JOIN Reviews ON Reviews.listing_id = Listings.id
WHERE Reviews.date>='2019-01-01' AND Reviews.date <= '2019-01-31'
ORDER BY (Reviews.reviewer_name);

COMMIT;