BEGIN;

CREATE TABLE Price AS
(SELECT id as listing_id, price, weekly_price, monthly_price, security_deposit, cleaning_fee,
guests_included, extra_people, minimum_nights, maximum_nights,
minimum_minimum_nights, maximum_minimum_nights, minimum_maximum_nights,
maximum_maximum_nights, minimum_nights_avg_ntm, maximum_nights_avg_ntm FROM Listings);

UPDATE
	Price
SET
	price = REPLACE(price,'$',''),
	weekly_price = REPLACE(weekly_price,'$',''),
	monthly_price = REPLACE(monthly_price,'$',''),
	security_deposit = REPLACE(security_deposit,'$',''),
	cleaning_fee = REPLACE(cleaning_fee,'$',''),
	extra_people = REPLACE(extra_people,'$','');

UPDATE
	Price
SET
	price = REPLACE(price,',',''),
	weekly_price = REPLACE(weekly_price,',',''),
	monthly_price = REPLACE(monthly_price,',',''),
	security_deposit = REPLACE(security_deposit,',','');

ALTER TABLE Price
ALTER COLUMN price TYPE numeric USING price::numeric,
ALTER COLUMN weekly_price TYPE numeric USING weekly_price::numeric,
ALTER COLUMN monthly_price TYPE numeric USING monthly_price::numeric,
ALTER COLUMN security_deposit TYPE numeric USING security_deposit::numeric,
ALTER COLUMN cleaning_fee TYPE numeric USING cleaning_fee::numeric,
ALTER COLUMN extra_people TYPE numeric USING extra_people::numeric,
ALTER COLUMN minimum_nights_avg_ntm TYPE numeric USING minimum_nights_avg_ntm::numeric,
ALTER COLUMN maximum_nights_avg_ntm TYPE numeric USING maximum_nights_avg_ntm::numeric;

ALTER TABLE Price ADD PRIMARY KEY (listing_id);

ALTER TABLE Price ADD FOREIGN KEY (listing_id) REFERENCES Listings (id);

ALTER TABLE Listings
DROP COLUMN cleaning_fee,
DROP COLUMN guests_included,
DROP COLUMN extra_people,
DROP COLUMN minimum_nights,
DROP COLUMN maximum_nights,
DROP COLUMN minimum_minimum_nights,
DROP COLUMN maximum_minimum_nights,
DROP COLUMN minimum_maximum_nights,
DROP COLUMN maximum_maximum_nights,
DROP COLUMN minimum_nights_avg_ntm,
DROP COLUMN maximum_nights_avg_ntm;

COMMIT;