BEGIN;
----------------------------------------------------------QUERIES-----------------------------------------------------------
-----------------------------------------------------------first------------------------------------------------------------
CREATE TABLE firstquery AS
	(SELECT DISTINCT EXTRACT(YEAR FROM release_date) FROM Movies_metadata WHERE release_date is not null);

ALTER TABLE firstquery ADD COLUMN movies double precision;

UPDATE
	firstquery
SET
	movies = (SELECT COUNT(id) FROM Movies_metadata WHERE EXTRACT(YEAR FROM Movies_metadata.release_date) = firstquery.date_part);

SELECT * FROM firstquery;
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------second-----------------------------------------------------------
CREATE TABLE secondquery AS(SELECT DISTINCT TRIM(reg) as reg FROM Movies_metadata,regexp_split_to_table(TRANSLATE(Movies_metadata.genres,'[]{}",'':0123456789',''),'name') as reg);

UPDATE 
	secondquery
SET 
	reg = replace(reg,'id','');

DELETE FROM secondquery WHERE reg LIKE '';
DELETE FROM secondquery WHERE reg LIKE '% ';
CREATE TABLE temp AS(SELECT DISTINCT * FROM secondquery);
DELETE FROM secondquery;
INSERT INTO secondquery SELECT * FROM temp;
DROP TABLE temp;

SELECT COUNT(id),secondquery.reg FROM Movies_metadata,secondquery WHERE Movies_metadata.genres LIKE CONCAT('%',secondquery.reg,'%') GROUP BY(secondquery.reg) ORDER BY(secondquery.reg);
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------third------------------------------------------------------------
SELECT COUNT(id),date_part,reg FROM Movies_metadata,firstquery,secondquery 
WHERE EXTRACT(YEAR FROM Movies_metadata.release_date) = firstquery.date_part AND Movies_metadata.genres LIKE CONCAT('%',secondquery.reg,'%')
GROUP BY(date_part,reg) ORDER BY(date_part) DESC;
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------fourth-----------------------------------------------------------
SELECT AVG(rating),reg FROM Movies_metadata,secondquery,Ratings
WHERE Ratings.movieId = Movies_metadata.id AND Movies_metadata.genres LIKE CONCAT('%',secondquery.reg,'%')
GROUP BY(reg) ORDER BY(avg) DESC;
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------fifth------------------------------------------------------------
SELECT COUNT(rating),userId FROM Ratings
GROUP BY(userId);
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------sixth------------------------------------------------------------
SELECT AVG(rating),userId FROM Ratings
GROUP BY(userId);
----------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------View_table---------------------------------------------------------
CREATE VIEW View_table AS
	(SELECT COUNT(rating) AS summary_ratings,AVG(rating) AS average_of_all_ratings,userId FROM Ratings GROUP BY(userId));
SELECT * FROM View_table;
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
COMMIT;