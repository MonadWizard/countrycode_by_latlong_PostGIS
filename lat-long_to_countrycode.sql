CREATE EXTENSION IF NOT EXISTS postgis;

-- -- execute as postgres user
--     sudo cp -r ne_10m_admin_0_countries /var/lib/postgresql/country_lat-long_data
--         cd /var/lib/postgresql/country_lat-long_data/ne_10m_admin_0_countries
--     shp2pgsql -I -s 4326 ne_10m_admin_0_countries.shp public.countries | psql -d aggamedb

--      postgres=# \c aggamedb
-- -- You are now connected to database "aggamedb" as user "postgres".
--      aggamedb=# ALTER TABLE countries OWNER TO aggame_dev;




-- -- new dataset
-- shp2pgsql -I -s 4326 ne_110m_admin_0_countries.shp public.countries_110m | psql -d aggamedb







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
SELECT get_country_code(40.7128, -74.0060); -- Returns 'US' (USA)
SELECT get_country_code(23.684994, 90.356331); -- Returns 'BD' (BD)


SELECT iso_a2, name
FROM countries_with_code_latlong
WHERE ST_Contains(geom, ST_SetSRID(ST_MakePoint(2.3522, 48.8566), 4326));

select * from countries_with_code_latlong;
select * from countries_with_code_latlong where iso_a2 = '-99';


select * from countries_110m;


CREATE TABLE countries_with_code_latlong AS
SELECT name,iso_a2,geom
FROM countries_110m;


CREATE INDEX countries_with_code_latlong_idx
ON countries_with_code_latlong
USING GIST (geom);







