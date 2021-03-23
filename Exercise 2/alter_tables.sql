BEGIN;

ALTER TABLE Reviews
ADD FOREIGN KEY (listing_id) REFERENCES Listings(id);

ALTER TABLE Reviews_summary
ADD FOREIGN KEY (listing_id) REFERENCES Listings(id);

ALTER TABLE Calendar
ADD FOREIGN KEY (listing_id) REFERENCES Listings(id);

ALTER TABLE Listings_summary
ADD FOREIGN KEY (id) REFERENCES Listings(id);

ALTER TABLE Listings
ADD FOREIGN KEY (neighbourhood_cleansed) REFERENCES Neighbourhoods(neighbourhood);

ALTER TABLE Geolocation
ADD FOREIGN KEY (properties_neighbourhood) REFERENCES Neighbourhoods(neighbourhood);

COMMIT;