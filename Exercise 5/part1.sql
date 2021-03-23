BEGIN;

CREATE TABLE Amenity AS
(SELECT DISTINCT UNNEST(CAST(amenities AS text[])) AS amenity_name FROM Room);

ALTER TABLE Amenity ADD COLUMN amenity_id serial;
ALTER TABLE Amenity ADD PRIMARY KEY (amenity_id);

UPDATE 
	Room
SET 
	amenities = REPLACE(amenities,'{','');
	
UPDATE 
	Room
SET 
	amenities = REPLACE(amenities,'}','');
	
UPDATE 
	Room
SET 
	amenities = REPLACE(amenities,'"','');

CLUSTER Room USING room_pkey;

CREATE TABLE Additional_table AS
(SELECT DISTINCT listing_id,amenity_id FROM Room,regexp_split_to_table(Room.amenities,',') AS reg 
INNER JOIN Amenity ON reg = Amenity.amenity_name
WHERE reg IN(SELECT amenity_name FROM Amenity)
ORDER BY(listing_id));

ALTER TABLE Additional_table ADD FOREIGN KEY (listing_id) REFERENCES Room(listing_id);
ALTER TABLE Additional_table ADD FOREIGN KEY (amenity_id) REFERENCES Amenity(amenity_id);
ALTER TABLE Additional_table ADD PRIMARY KEY (listing_id,amenity_id);
ALTER TABLE Room DROP COLUMN amenities;

COMMIT;