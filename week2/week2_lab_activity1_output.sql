#1
CREATE OR REPLACE FUNCTION get_flight_duration(param_id numeric)
RETURNS INTERVAL AS $$
DECLARE
        flight_duration INTERVAL;
BEGIN
        SELECT SUM(arrival_time - departure_time)
        INTO flight_duration
        FROM flights
        WHERE flight_id = param_id;

        RETURN flight_duration;
END;

$$ LANGUAGE plpgsql;

#2
CREATE OR REPLACE FUNCTION get_price_category(param_id NUMERIC)
RETURNS TEXT AS $$
DELCARE
    price NUMERIC;
BEGIN
    SELECT base_price
    INTO price
    FROM flights
    WHERE flight_id = param_id;

    IF price > 800.00 THEN
        RETURN 'Premium';
    ELSIF price > 300.00 THEN
        RETURN 'Standard';
    ELSE
        RETURN 'Budget';
    END IF;
END;

$$ LANGUAGE plpgsql;
