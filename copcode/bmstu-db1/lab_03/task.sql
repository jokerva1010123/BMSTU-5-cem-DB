-- Какие поставщики производят красное полусухое.

CREATE OR REPLACE FUNCTION get_mfctrs(value_color VARCHAR, value_sugar VARCHAR)
RETURNS TABLE (id INTEGER, name VARCHAR, 
               country VARCHAR, experience INTEGER, rating INTEGER)
AS
$$
BEGIN
	RETURN QUERY
	SELECT mws.manufacture_id, mws.name, mws.country, mws.experience, mws.rating
 	FROM (manufactures AS m JOIN
 		 (sales AS s JOIN wines AS w ON s.wine_id = w.id) AS ws
 		 ON m.id = ws.manufacture_id) AS mws
 	WHERE mws.color = value_color AND mws.sugar = value_sugar;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM get_mfctrs('red', 'semi-dry');