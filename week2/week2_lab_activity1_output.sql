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

#3
CREATE OR REPLACE PROCEDURE book_flight(p_passenger_id NUMERIC, p_flight_id NUMERIC, p_seat_number VARCHAR)
AS $$
BEGIN
	INSERT INTO bookings(passenger_id, flight_id, seat_number)
	VALUES(p_passenger_id, p_flight_id, p_seat_number);
END;

$$  LANGUAGE plpgsql

#4
CREATE OR REPLACE PROCEDURE increase_prices_for_airline(p_airline_id NUMERIC, p_percentage_increase NUMERIC)
AS $$
DECLARE
	increased_price RECORD;
BEGIN

	FOR increased_price IN SELECT flight_id, base_price FROM flights WHERE airline_id = p_airline_id LOOP
		UPDATE flights
		SET base_price = base_price * (1 + p_percentage_increase / 100)
		WHERE flight_id = increased_price.flight_id;
	END LOOP;

END;

$$ LANGUAGE plpgsql;