\# Demo \& Practice: Inventory Management with Triggers



\## Objective



This exercise demonstrates how to use triggers to enforce business rules and automate data updates between related tables. You will build a system for a bookstore that both validates and manages book inventory during a sale.



This demo covers:

\- Using a `BEFORE INSERT` trigger for data validation.

\- Raising exceptions to cancel an operation.

\- Using an `AFTER INSERT` trigger to create side-effects in another table.

\- The importance of separating validation and action logic.



\## Scenario



In our bookstore database, we have a `books` table that tracks `stock\_quantity` and a `sales` table that records each sale. We need to ensure two things:

1\.  A customer cannot buy more copies of a book than are currently in stock.

2\.  When a sale is successfully recorded, the `stock\_quantity` for that book must be automatically decreased.



\## Database Setup



First, run the SQL script from `demo\_inventory\_setup.sql` to create and populate the `books` and `sales` tables.



```sql

DROP TABLE IF EXISTS sales;

DROP TABLE IF EXISTS books;



CREATE TABLE books (

&nbsp;   book\_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

&nbsp;   title TEXT NOT NULL,

&nbsp;   author TEXT NOT NULL,

&nbsp;   price NUMERIC(10, 2) NOT NULL,

&nbsp;   stock\_quantity INT NOT NULL DEFAULT 0

);



CREATE TABLE sales (

&nbsp;   sale\_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

&nbsp;   book\_id INT NOT NULL REFERENCES books(book\_id),

&nbsp;   quantity\_sold INT NOT NULL,

&nbsp;   sale\_date TIMESTAMPTZ DEFAULT NOW()

);



INSERT INTO books (title, author, price, stock\_quantity) VALUES

('The Hitchhiker''s Guide to the Galaxy', 'Douglas Adams', 12.50, 5),

('Pride and Prejudice', 'Jane Austen', 9.75, 10),

('Dune', 'Frank Herbert', 15.00, 2);

```



---



\## Part 1: Validating Stock Before a Sale



We'll start by creating a trigger that prevents a sale from happening if there isn't enough stock.



\### Task 1.1: The Validation Function



Create a PL/pgSQL function `check\_stock\_before\_sale()` that returns a `TRIGGER`.



\*\*Requirements:\*\*

\- The function needs to get the available stock for the `book\_id` specified in the `NEW` sale record.

\- It must compare that stock to the `NEW.quantity\_sold`.

\- If `quantity\_sold` is greater than the available stock, it must raise an exception. The message should be clear, e.g., `'Not enough stock: Cannot sell X copies when only Y are available.'`.

\- If there is enough stock, it should `RETURN NEW` to allow the sale to proceed.



\### Task 1.2: The `BEFORE` Trigger



Create a trigger `sales\_check\_stock\_trigger` on the `sales` table that executes the `check\_stock\_before\_sale()` function `BEFORE` every `INSERT`.



---



\## Part 2: Decrementing Stock After a Sale



Next, we'll create a separate trigger that updates the inventory \*after\* a sale has been successfully validated and inserted.



\### Task 2.1: The Decrement Function



Create a PL/pgSQL function `decrement\_stock\_after\_sale()` that returns a `TRIGGER`.



\*\*Requirements:\*\*

\- This function will execute an `UPDATE` statement on the `books` table.

\- It will subtract `NEW.quantity\_sold` from the `stock\_quantity` column for the `book\_id` in the `NEW` sale record.

\- It should `RETURN NEW`.



\### Task 2.2: The `AFTER` Trigger



Create a trigger `sales\_decrement\_stock\_trigger` on the `sales` table that executes the `decrement\_stock\_after\_sale()` function `AFTER` every `INSERT`.



\*\*Discussion Point:\*\* Why use two separate triggers (`BEFORE` and `AFTER`) instead of one? This separation of concerns is a robust pattern. The `BEFORE` trigger is purely for validation. The `AFTER` trigger handles the consequences of the action, and it only runs if the action (the `INSERT`) was successful.



---



\## Part 3: Testing



Run the following statements to test your complete trigger system.



\### Test 3.1: A Successful Sale



Attempt to sell 2 copies of "The Hitchhiker's Guide to the Galaxy" (book\_id 1), which has 5 in stock.



```sql

-- This should succeed

INSERT INTO sales (book\_id, quantity\_sold) VALUES (1, 2);



-- Check the stock

SELECT title, stock\_quantity FROM books WHERE book\_id = 1;

-- Expected stock\_quantity: 3

```



\### Test 3.2: An Unsuccessful Sale



Attempt to sell 3 copies of "Dune" (book\_id 3), which only has 2 in stock.



```sql

-- This should fail and raise an exception

INSERT INTO sales (book\_id, quantity\_sold) VALUES (3, 3);



-- Check that the stock was not changed

SELECT title, stock\_quantity FROM books WHERE book\_id = 3;

-- Expected stock\_quantity: 2

```



\### Test 3.3: A Sale That Empties the Stock


Attempt to sell the last 2 copies of "Dune".



```sql

-- This should succeed

INSERT INTO sales (book\_id, quantity\_sold) VALUES (3, 2);



-- Check the stock

SELECT title, stock\_quantity FROM books WHERE book\_id = 3;

-- Expected stock\_quantity: 0

```


