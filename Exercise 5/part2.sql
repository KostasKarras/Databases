BEGIN;

-----------------------------------------------INNER JOIN QUERIES-----------------------------------------------------------
/*INNER JOIN  -> Room,Price
Emfanizei to listing_id, thn minaia timh kai ta krevatia opou h timh einai mikroterh apo 1000
,ta krevatia perissotera h isa me 2 taksinomhmena apo ta perissotera pros ta ligotera krevatia(fthinousa seira)
65 rows*/
SELECT Room.listing_id,Price.monthly_price,Room.bedrooms FROM Room
INNER JOIN Price ON Room.listing_id = Price.listing_id
WHERE Price.monthly_price < 1000
GROUP BY(Room.listing_id,Price.listing_id)
HAVING Room.bedrooms >= 2
ORDER BY(Room.bedrooms) DESC;

/*INNER JOINS -> 1)Listing,Price 2)Listing,Location
Emfanizei to listing_id,thn hmerhsia timh, thn evdomadiaia timh kai thn perioxh
(opou o Listing syndeetai me tous pinakes mesw tou id kai twn listing_id twn allwn pinakwn)
pou isxyei oti to listing_id tha periexetai sto synolo pou tha epistrepsei to eswteriko query
(dhladh tis perioxes opou ksekinane me Pl) KAI opou symferei ton pelath na noikiasei to spiti gia 1 endomada
para gia 4 meres(afou h hmerhsia misthwsh einai gia 4 meres megalyterh apo thn evdomadiaia misthwsh)
2 rows*/
SELECT Price.listing_id,Price.price,Price.weekly_price,Location.neighbourhood FROM Listing
INNER JOIN Price ON Listing.id = Price.listing_id INNER JOIN Location ON Listing.id = Location.listing_id
WHERE Listing.id IN (SELECT listing_id FROM Location WHERE neighbourhood LIKE 'Pl%') AND weekly_price < 4 * price;

/*INNER JOINS -> 1)Listing,Location 2)Listing,Host
Emfanizei to listing_id, to host_id, thn geitonia(pou einai sigoura to kolwnaki, to gewgrafiko mhkos, 
to gewgrafiko platos, ton taxydromiko kwdika, ton xrono apokrishs, to an einai o ekmisthwths superhost kai thn fwtografia 
toy), opou h geitonia periexetai ston geolocation kai einai to kolwnaki kathws epishs tha prepei na isxyei oti
ta spitia poy tha emfanizei tha vriskode voreiodytika tou 1ou zeygous sydetagmenwn poy orizei to polygwno ths perioxhs
toy Kolwnakioy taksinomhmena me vasei to listing_id (kata auksousa seira)
21 rows*/
SELECT Location.listing_id,Host.id AS host_id,Location.neighbourhood_cleansed AS neighbourhood,Location.longitude,Location.latitude,Location.zipcode,Host.response_time,Host.is_superhost,Host.picture_url FROM Listing 
INNER JOIN Location ON Listing.id = Location.listing_id INNER JOIN Host ON Listing.host_id = Host.id
WHERE(Location.neighbourhood_cleansed IN(
								SELECT properties_neighbourhood FROM Geolocation 
								GROUP BY(properties_neighbourhood) 
								HAVING (properties_neighbourhood = 'ΚΟΛΩΝΑΚΙ'))
	AND Location.longitude  <   (SELECT geometry_coordinates_0_0_0_0 FROM Geolocation 
							    WHERE (properties_neighbourhood = 'ΚΟΛΩΝΑΚΙ'))
	AND Location.latitude   >   (SELECT geometry_coordinates_0_0_0_1 FROM Geolocation 
						        WHERE (properties_neighbourhood = 'ΚΟΛΩΝΑΚΙ'))
	)
ORDER BY(Listing.id);

-----------------------------------------------OUTER JOIN QUERIES-----------------------------------------------------------
/*INNER JOIN -> Listing,Host
OUTER JOIN -> Listing,Review
Emfanizei to listing_id , to listing_url, to onoma tou idiokthth kai to
megalutero(an uparxoun panw apo 1)apo ta sxolia pou egrapse kapoios episkepths
twn diamerismatwn opou o idiokthths exei toulaxiston alla 3 akomh dwmatia sthn katoxh tou,
to onoma tou arxizei apo 'M'. Aparaithth proupothesh to sxolio twn episkeptwn na periexei mia
toulaxiston apo tis parakatw lekseis: sunny,fully rennovated,cozy, bright.
119 rows(20 grammes exoun null timh sta comment)*/
SELECT Listing.id,Listing.listing_url,Listing.host_id,max(Review.comments) as comment
FROM Listing
INNER JOIN Host ON Host.id=Listing.host_id
LEFT OUTER JOIN Review ON Listing.id=Review.listing_id
WHERE Host.name LIKE 'M%' AND total_listings_count>3 AND property_type='Apartment' AND (Listing.description LIKE '%sunny%'
OR Listing.description LIKE '%fully rennovated%' OR Listing.description LIKE '%cozy%' OR Listing.description LIKE '%bright%')
GROUP BY Listing.id;

/*INNER JOINS -> 1)Listing,Price 2)Listing,Calendar
OUTER JOIN Listing,Review_summary
Emfanizei to listing_id, thn timh, thn perigrafh tou diamerismatos kai thn hmeromhnia ths teleutaias perigrafhs 
efoson h timh hmrhsiws einai mikroterh apo 20$, oi kalesmenoi isoi me 2 kai sthn perigrafh periexetai h leksh anakainismeno
(renovated)
18 rows(1 grammh exei null timh sto last_review)*/
SELECT DISTINCT Listing.id,Price.price,Listing.description,Listing.last_review FROM Listing
INNER JOIN Price ON Price.listing_id = Listing.id INNER JOIN Calendar ON Calendar.listing_id = Listing.id 
FULL OUTER JOIN Review_summary ON Review_summary.listing_id = Listing.id
WHERE Price.price < 20 AND Price.guests_included = 2 AND Listing.description LIKE '%renovated%';

COMMIT;