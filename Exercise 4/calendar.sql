BEGIN;

UPDATE
	Calendar
SET
	price = REPLACE(price,'$',''),
	adjusted_price = REPLACE(adjusted_price,'$','');

UPDATE
	Calendar
SET
	price = REPLACE(price,',',''),
	adjusted_price = REPLACE(adjusted_price,',','');

ALTER TABLE Calendar
ALTER COLUMN price TYPE numeric USING price::numeric,
ALTER COLUMN adjusted_price TYPE numeric USING adjusted_price::numeric,
ALTER COLUMN available TYPE boolean USING available::boolean;

COMMIT;