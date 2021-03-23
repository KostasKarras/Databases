BEGIN;

----------------------------------------------------------1o------------------------------------------------------------------
CREATE INDEX host_id_at_Listing ON Listing(host_id);
DROP INDEX host_id_at_Listing;
----------------------------------------------------------2o------------------------------------------------------------------
CREATE INDEX guests_included_price_at_Price ON Price(guests_included,price) WHERE Price.guests_included > 5 AND Price.price > 40;
DROP INDEX guests_included_price_at_Price;
----------------------------------------------------------3o------------------------------------------------------------------
CREATE INDEX monthly_price_at_Price ON Price(monthly_price);
DROP INDEX monthly_price_at_Price;
----------------------------------------------------------4o------------------------------------------------------------------
CREATE INDEX price_weekly_price_at_Price ON Price(weekly_price,price) WHERE weekly_price < 4 * price;
CREATE INDEX neighbourhood_at_Location ON Location(neighbourhood) WHERE neighbourhood LIKE 'Pl%';
DROP INDEX price_weekly_price_at_Price;
DROP INDEX neighbourhood_at_Location;
----------------------------------------------------------5o------------------------------------------------------------------
CREATE INDEX neighbourhood_cleansed_at_Location ON Location(neighbourhood_cleansed);
DROP INDEX neighbourhood_cleansed_at_Location;
----------------------------------------------------------6o------------------------------------------------------------------
CREATE INDEX listing_id_at_Review ON Review(listing_id);
CREATE INDEX host_id2_at_Listing ON Listing(host_id);
DROP INDEX listing_id_at_Review;
DROP INDEX host_id2_at_Listing;
----------------------------------------------------------7o------------------------------------------------------------------
CREATE INDEX guests_included_price_at_Price ON Price(price,guests_included) WHERE (Price.price < 20 AND guests_included = 2);
DROP INDEX guests_included_price_at_Price;

COMMIT;