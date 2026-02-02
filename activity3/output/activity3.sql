--TASK 1
--CREATE A TRIGGER FUNCITON named log_product_changes that logs changes that happened in the products table
CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS TIRGGER AS $$
BEGIN
    IF(TG_OP = 'INSERT') THEN
        INSERT INTO product_audit(product_id, change_type, change_timestamp)
        VALUES(NEW.product_id, 'INSERT', CURRENT_TIMESTAMP);
        RETURN NEW;
    ELSIF(TG_OP = 'DELETE') THEN
        INSERT INTO product_audit(product_id, change_type, change_timestamp)
        VALUES(OLD.product_id, 'DELETE', CURRENT_TIMESTAMP);
        RETURN OLD;
    ELSIF(TG_OP = 'UPDATE') THEN
        IF(OLD.name IS NOT DISTINCT FROM NEW.name) OR (OLD.price IS NOT DISTINCT FROM NEW.price) THEN
            INSERT INTO product_audit(product_id, change_type, old_name, new_name, old_price, new_price)
            VALUES(OLD.product_id, 'UPDATE', OLD.name, NEW.name, OLD.price, NEW.price);

        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--TASK 2
--CREATE A TRIGGER named product_audit_trigger that only happens after any INSERT, UPDATE or DELETE on the products table.
CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();


--TASK 3
--Testing of the trigger and trigger function by performing INSERT, UPDATE and DELETE operations on the products table.

--Testing of insert operation
INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Miniature Thingamabob', 'A very small thingamabob.', 4.99, 500);

--Update with meaningful changes made
UPDATE products
SET price = 225.00, name = 'Mega Gadget v2'
WHERE name = 'Mega Gadget';

--Update with no meaningful changes made
UPDATE products
SET description = 'An even simpler gizmo for all your daily tasks.'
WHERE name = 'Basic Gizmo';

--Testing of delete operation
DELETE FROM products
WHERE name = 'Super Widget';


--TASK 4 
--Verification of results
SELECT * FROM products_audit ORDER BY audit_id;

--BONUS CHALLENGE
--CREATE A TRIGGER function THAT AUTOMATICALLY UPDATES last_modified
CREATE OR REPLACE FUNCTION set_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--CREATE a TRIGGER for execution of set_last_modified
CREATE TRIGGER last_modified_trigger
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION set_last_modified();