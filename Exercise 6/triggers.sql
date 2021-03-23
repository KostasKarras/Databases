CREATE FUNCTION firstly() RETURNS TRIGGER AS
$$
BEGIN
IF tg_op = 'INSERT' THEN
	UPDATE Host
	SET listings_count = listings_count + 1
	WHERE new.host_id=id;
ELSIF tg_op = 'DELETE' THEN
	UPDATE Host
	SET listings_count = listings_count - 1
	WHERE old.host_id=id;
END IF;
RETURN NEW;
END;
$$
Language plpgsql;

CREATE TRIGGER change
AFTER INSERT OR DELETE ON Listing
FOR EACH ROW
EXECUTE PROCEDURE firstly();

/*Otan diagrafetai ena dwmatio apo ton Listing tote diagrafetai kai to antistoixo pedio tou Price(opou 
Listing.id = Price.listing_id) afou to dwmatio den yfistatai pleon*/
CREATE FUNCTION secondly() RETURNS TRIGGER AS
$$
BEGIN
DELETE FROM Price
	WHERE Price.listing_id = old.id;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER change2
AFTER DELETE ON Listing
FOR EACH ROW
EXECUTE PROCEDURE secondly();