BEGIN;

ALTER TABLE Listings RENAME TO Listing;
ALTER TABLE Listings_summary RENAME TO Listing_summary;
ALTER TABLE Neighbourhoods RENAME TO Neighbourhood;
ALTER TABLE Reviews RENAME TO Review;
ALTER TABLE Reviews_summary RENAME TO Review_summary;

COMMIT;