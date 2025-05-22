-- CREATE EXTENSION IF NOT EXISTS postgis;
--
--
-- CREATE INDEX countries_with_code_latlong_idx
-- ON countries_with_code_latlong
-- USING GIST (geom);




CREATE OR REPLACE FUNCTION get_country_code(lat double precision, lon double precision)
RETURNS text AS $$
DECLARE
    country_code text;
BEGIN
    SELECT iso_a2 INTO country_code
    FROM countries_with_code_latlong
    WHERE ST_Contains(geom, ST_SetSRID(ST_MakePoint(lon, lat), 4326))
    LIMIT 1;

    RETURN country_code;
END;
$$ LANGUAGE plpgsql IMMUTABLE;



SELECT get_country_code(48.8566, 2.3522);  -- Returns 'FR' (France)
SELECT get_country_code(23.7612256, 90.420766);  -- Returns 'BD' (Bangladesh)
SELECT get_country_code(40.7128, -74.0060); -- Returns 'US' (USA)
SELECT get_country_code(23.684994, 90.356331); -- Returns 'BD' (BD)











