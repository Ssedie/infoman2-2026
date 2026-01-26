# Lab Activity: Implementing an Audit Trail with Triggers

## Objective

In this activity, you will apply your knowledge of PL/pgSQL and database triggers to create a comprehensive audit trail for a `products` table. You will create a system that automatically logs all insertions, meaningful updates, and deletions of product data.

This exercise will reinforce your understanding of:
- Creating trigger functions.
- Using the special `TG_OP`, `NEW`, and `OLD` variables.
- Binding a trigger function to a table for `INSERT`, `UPDATE`, and `DELETE` events.
- The difference between `BEFORE` and `AFTER` triggers.

## Scenario

You are the database administrator for a new e-commerce platform. To ensure data integrity and track all changes to product information, you have been tasked with creating an audit log. Every time a new product is added, a product's details are changed, or a product is removed, a record of that event must be saved into a separate `products_audit` table.

## Database Setup

First, you need to set up the necessary tables. You can use the provided `activity2_setup.sql` file, or run the SQL script below in your database using `psql` or your preferred SQL client.

```sql
-- Drop tables if they exist to ensure a clean slate
DROP TABLE IF EXISTS products_audit;
DROP TABLE IF EXISTS products;

-- Create the main table for products
CREATE TABLE products (
    product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_modified TIMESTAMPTZ DEFAULT NOW()
);

-- Create the audit table to log changes to the products table
CREATE TABLE products_audit (
    audit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    change_type TEXT NOT NULL, -- e.g., 'INSERT', 'UPDATE', 'DELETE'
    old_name TEXT,
    new_name TEXT,
    old_price NUMERIC(10, 2),
    new_price NUMERIC(10, 2),
    change_timestamp TIMESTAMPTZ DEFAULT NOW(),
    db_user TEXT DEFAULT current_user
);

-- Insert some initial data to work with
INSERT INTO products (name, description, price, stock_quantity) VALUES
('Super Widget', 'A high-quality widget for all your needs.', 29.99, 100),
('Mega Gadget', 'The latest and greatest gadget.', 199.50, 50),
('Basic Gizmo', 'A simple gizmo for everyday tasks.', 9.75, 250);
```

## Your Tasks

### Task 1: Create the Trigger Function

Create a PL/pgSQL function named `log_product_changes()` that returns type `TRIGGER`. This function will contain the logic for handling the different event types.

**Requirements:**
1.  **If the operation is an `INSERT`**:
    - Insert a new row into `products_audit`.
    - Set `change_type` to `'INSERT'`.
    - Set `product_id` and `new_name`, `new_price` from the `NEW` record.
2.  **If the operation is a `DELETE`**:
    - Insert a new row into `products_audit`.
    - Set `change_type` to `'DELETE'`.
    - Set `product_id` and `old_name`, `old_price` from the `OLD` record.
3.  **If the operation is an `UPDATE`**:
    - **Only** create a log entry if the product's `name` OR `price` has changed. Use the `IS DISTINCT FROM` operator for a safe comparison that handles `NULL` values correctly.
    - If a change is detected, insert a new row into `products_audit`.
    - Set `change_type` to `'UPDATE'`.
    - Record the `product_id`, `old_name`, `new_name`, `old_price`, and `new_price` from the `OLD` and `NEW` records.
4.  The function should correctly return the `NEW` or `OLD` record as appropriate for the operation.

### Task 2: Create the Trigger Definition

Create a trigger named `product_audit_trigger` that binds your `log_product_changes()` function to the `products` table.

**Requirements:**
- The trigger should fire `AFTER` any `INSERT`, `UPDATE`, or `DELETE` operation.
- The trigger must be a row-level trigger (`FOR EACH ROW`).

### Task 3: Test Your Trigger

After creating the function and the trigger, perform the following SQL operations to test your work:

```sql
-- 1. Test the INSERT trigger
INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Miniature Thingamabob', 'A very small thingamabob.', 4.99, 500);

-- 2. Test the UPDATE trigger (with a meaningful change)
UPDATE products
SET price = 225.00, name = 'Mega Gadget v2'
WHERE name = 'Mega Gadget';

-- 3. Test an UPDATE with no meaningful change (should not create a log entry)
UPDATE products
SET description = 'An even simpler gizmo for all your daily tasks.'
WHERE name = 'Basic Gizmo';

-- 4. Test the DELETE trigger
DELETE FROM products
WHERE name = 'Super Widget';
```

### Task 4: Verify the Results

Check the contents of your `products_audit` table. You should see three new rows corresponding to the `INSERT`, the meaningful `UPDATE`, and the `DELETE`.

```sql
SELECT * FROM products_audit ORDER BY audit_id;
```

**Expected Output (values for `change_timestamp` and `db_user` will vary):**

| audit_id | product_id | change_type | old_name     | new_name                | old_price | new_price | change_timestamp                   | db_user |
|----------|------------|-------------|--------------|-------------------------|-----------|-----------|------------------------------------|---------|
| 1        | 4          | INSERT      | *null*       | Miniature Thingamabob   | *null*    | 4.99      | 2026-01-26...                      | your_user |
| 2        | 2          | UPDATE      | Mega Gadget  | Mega Gadget v2          | 199.50    | 225.00    | 2026-01-26...                      | your_user |
| 3        | 1          | DELETE      | Super Widget | *null*                  | 29.99     | *null*    | 2026-01-26...                      | your_user |


## Bonus Challenge: Automatically Update `last_modified`

The `products` table has a `last_modified` column. Create a *second*, separate trigger to automatically update this column to the current timestamp whenever a row is updated.

1.  Create a new, generic trigger function named `set_last_modified()`.
2.  This function should set `NEW.last_modified = NOW()`.
3.  This must be a `BEFORE UPDATE` trigger. Why is `BEFORE` the correct choice here?
4.  Create the trigger definition and test it by running an `UPDATE` on any product.