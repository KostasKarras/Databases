BEGIN;
-----------------------------------------------------------TABLES-----------------------------------------------------------
-------------------------------------------------------MOVIES_METADATA------------------------------------------------------
CREATE TABLE Movies_metadata(
	adult boolean,
	belongs_to_collection text,
	budget int,
	genres text,
	homepage text,
	id int,
	imdb_id text,
	original_language text,
	original_title text,
	overview text,
	popularity double precision,
	poster_path text,
	production_companies text,
	production_countries text,
	release_date date,
	revenue bigint,
	runtime double precision,
	spoken_languages text,
	status text,
	tagline text,
	title text,
	video boolean,
	vote_average double precision,
	vote_count int
);
CREATE TABLE temp AS(
	SELECT DISTINCT * FROM Movies_metadata);

DELETE FROM Movies_metadata;

INSERT INTO Movies_metadata SELECT * FROM temp;
DROP TABLE temp;
--epeidh den mporw na orisw akoma primary key epilegw na diagrapsw tis pleiades pou exoun mikrotero popularity kai idio id thewrwdas pws einai pio prosfata ananewmenes
CREATE TABLE temp AS(
	SELECT * FROM Movies_metadata WHERE id IN(SELECT id FROM Movies_metadata GROUP BY(id) HAVING COUNT(id) > 1));

DELETE FROM Movies_metadata mm USING temp t1 WHERE t1.id = mm.id AND mm.popularity < t1.popularity;
DROP TABLE temp;
ALTER TABLE Movies_metadata ADD PRIMARY KEY(id);
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------CREDITS----------------------------------------------------------
CREATE TABLE Credits(
	"cast" varchar,
	crew varchar,
	id int
);
CREATE TABLE temp AS(
	SELECT DISTINCT * FROM Credits);

DELETE FROM Credits;

INSERT INTO Credits SELECT * FROM temp;
DROP TABLE temp;
/*sthn arxh afairesa ta diplotypa.OMWS den teleiwse ekei dioti kapoies egrafes eixan to idio id kai diforetiko crew me 
apotelesma na mhn mporw na prosthesw primary key.Opote auto pou kanw sthn synexeia einai h synxwneysh tvn 2 diaforetikwn crew me idio id se mia pleon (apo 2 pou htan) grammh*/
CREATE TABLE temp AS(
	SELECT * FROM Credits WHERE id IN(SELECT id FROM Credits GROUP BY(id) HAVING COUNT(id) > 1));
CREATE TABLE temp2 AS(
	SELECT * FROM Credits WHERE id IN(SELECT id FROM Credits GROUP BY(id) HAVING COUNT(id) > 1));

UPDATE 
	temp
SET 
	crew = CONCAT(temp.crew,temp2.crew) FROM temp2 WHERE temp2.id = temp.id;--synxwneysh twn 2 crew.OMWS exw pali diplotypa kathws pleon ston temp exv kati san: [x][y] kai [y][x] dhladh exw eggrafes me to idio id oi opoies einai pleon oloklhres alla kai pali den einai monadikes

UPDATE 
	temp
SET
	crew = replace(crew,'][','');--afairw ta endiamesa ][ dld apo [x][y] -> [xy] kai [y][x]->[yx]

CREATE TABLE temp3 AS(SELECT * FROM temp);

UPDATE
	TEMP
SET 
	crew = TEMP3.crew FROM TEMP3 WHERE TEMP3.id = TEMP.id;--Twra pia o temp exei sto crew mono tis deyteres eggrafes gia to idio id.Dhladh kathws adigrafei apo to temp3 ginetai to ekshs:[xy] ,[xy] gia to idio id kai stis 2 eggrafes kai afou yparxei ksana 2o id(idio me to 1o ennoeitai) ston temp3 tote ston temp adigrafetai mono to [yx],[yx] kai stis 2 eggrafes.Ara pleon kathe eggrafh me to idio id ston temp mporei na thewrithei perrith kathws den einai pia [xy],[yx] me to idio id alla [yx],[yx] me to idio id!

CREATE TABLE temp4 AS (SELECT DISTINCT * FROM temp);--epilegw mono tis monadikes eggrafes se enan neo pinaka temp4

DROP TABLE temp;
CREATE TABLE temp AS (SELECT * FROM temp4);--tis adigrafw ston temp

UPDATE 
	Credits
SET 
	crew = temp.crew FROM temp WHERE temp.id = Credits.id;--Twra kathe eggrafh poy exei apomeinei (afou exoyn svhstei ta diplotypa sthn arxh) einai monadikh, dioti oi eggrafes poy eixan idio id exoun pleon ola ta pedia idia

DROP TABLE temp,temp2,temp3,temp4;

CREATE TABLE temp AS (SELECT DISTINCT * FROM Credits);--adigrafw ston temp tis pleon monadikes eggrafes tou credits

DELETE FROM Credits;--svhnw ta panta apo ton credits

INSERT INTO Credits SELECT * FROM temp;--ksanaprosthetw ston credits tis pleon monadikes eggrafes
DROP TABLE temp;--svhnw ton proswrino pinaka temp

ALTER TABLE Credits ADD PRIMARY KEY(id);--epitelous mporw na prosthesw primary key ston credits!!!
--ANALYTIKOTATH EPEKSHGHSH GIA THN DHMIOURGIA TOY PINAKA KAI THN EPISTROFH TWN APOTELESMATWN YPARXEI STO PDF
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------RATINGS-----------------------------------------------------------
CREATE TABLE Ratings(
	userId int,
	movieId int,
	rating double precision,
	timestamp bigint,
	PRIMARY KEY(userId,movieId)
);
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------LINKS------------------------------------------------------------
CREATE TABLE Links(
	movieId int,
	imdbId int,
	tmdbId int
);
CREATE TABLE temp AS(
	SELECT DISTINCT * FROM Links);

DELETE FROM Links;

INSERT INTO Links SELECT * FROM temp;
DROP TABLE temp;

ALTER TABLE Links ADD PRIMARY KEY(movieId);
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------KEYWORDS----------------------------------------------------------
CREATE TABLE KEYWORDS(
	id int,
	keywords text
);
CREATE TABLE temp AS(
	SELECT DISTINCT * FROM Keywords);

DELETE FROM Keywords;

INSERT INTO Keywords SELECT * FROM temp;
DROP TABLE temp;

ALTER TABLE Keywords ADD PRIMARY KEY(id);
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------DELETES-----------------------------------------------------------
DELETE FROM Credits WHERE Credits.id NOT IN(SELECT id FROM Movies_metadata);
DELETE FROM Keywords WHERE Keywords.id NOT IN(SELECT id FROM Movies_metadata);
DELETE FROM Links WHERE Links.tmdbId NOT IN(SELECT id FROM Movies_metadata);
DELETE FROM Ratings WHERE Ratings.movieId NOT IN(SELECT id FROM Movies_metadata);
----------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------FOREIGN KEYS--------------------------------------------------------
ALTER TABLE Credits
ADD FOREIGN KEY(id) REFERENCES Movies_metadata(id);

ALTER TABLE Keywords
ADD FOREIGN KEY(id) REFERENCES Movies_metadata(id);

ALTER TABLE Links
ADD FOREIGN KEY(tmdbId) REFERENCES Movies_metadata(id);

ALTER TABLE Ratings
ADD FOREIGN KEY(movieId) REFERENCES Movies_metadata(id);
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
COMMIT;