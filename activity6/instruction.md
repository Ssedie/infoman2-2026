# Lab Activity: PostgreSQL Query Optimization

**Objective:** This activity will test your ability to analyze, diagnose, and optimize slow SQL queries in a PostgreSQL environment. You will use your knowledge of `EXPLAIN`, indexing strategies, and query rewriting to improve the performance of a sample application.

The database will be populated with a large dataset:
*   `authors`: ~500 records (authors.sql)
*   `posts`: ~10,000 records (posts.sql)

---

## Part 1: Schema Migration and Setup

Your first task is to prepare the database schema and load the data.

### 1.1. Convert MySQL Schema to PostgreSQL

The initial schema is provided in `schema.sql`. This file uses MySQL-specific syntax.

**Task:**
1.  Create a new SQL file named `schema_postgres.sql`.
2.  Copy the contents of `schema.sql` into it.
3.  Modify the DDL statements in `schema_postgres.sql` to be fully compatible with PostgreSQL.
4.  **Add a Foreign Key:** The original schema is missing a critical relationship constraint. Add a foreign key constraint to the `posts` table that links `author_id` to the `id` in the `authors` table.

### 1.2. Load the Data

**Task:**
1.  Execute your `schema_postgres.sql` script in your PostgreSQL database to create the tables.
2.  Import the data from `authors.sql` and `posts.sql` into the respective tables.

---

## Part 2: Query Analysis and Optimization

For each scenario below, you must:
1.  Provided query with `EXPLAIN ANALYZE`.
2.  Capture the execution plan and the total execution time.
3.  In your analysis, identify the bottleneck (e.g., `Seq Scan` on a large table) and explain *why* the query is inefficient.
4.  Propose and implement a fix. This will typically involve creating an index or rewriting the query to be S-ARGable.
5.  Run `EXPLAIN ANALYZE` on the *optimized* query to verify the improvement.
6.  Compare the "before" and "after" execution times and plans to demonstrate the success of your optimization.

### Scenario 1: The Slow Author Profile Page

A user's profile (pick 1 author from schema) page needs to display all their posts (id and title), with the most recent ones first.

**Query:**
```sql
--- Provide the query
```

**Analysis Questions:**
*   What is the primary node causing the slowness in the initial execution plan?
*   How can you optimize both the `WHERE` clause filtering and the `ORDER BY` operation with a single change?
*   Implement your fix and record the new plan. How much faster is the query now?

### Scenario 2: The Unsearchable Blog

The website needs a feature to search for posts by a keyword in the title using a "contains" search (e.g., `'%database%'`).

**Query:**
```sql
--- Provide the query
```

**Analysis Questions:**
*   First, try adding a standard B-Tree index on the `title` column. Run `EXPLAIN ANALYZE` again. Did the planner use your index? Why or why not?
*   The business team agrees that searching by a *prefix* is acceptable for the first version. Rewrite the query to use a prefix search (e.g., `database%`).
*   Does the index work for the prefix-style query? Explain the difference in the execution plan.

### Scenario 3: The Monthly Performance Report

An internal dashboard needs to pull all posts published in January, 2015. 

**Query:**
```sql
--- Provide a non-sargable query. (e.g.: use EXTRACT function to extract month and year)
```

**Analysis Questions:**
*   This query is not S-ARGable. What does that mean in the context of this query? Why can't the query planner use a simple index on the `date` column effectively?
*   Rewrite the query to use a direct date range comparison, making it S-ARGable.
*   Create an appropriate index to support your rewritten query.
*   Compare the performance of the original query and your optimized version.

---

## Part 3: Submission and Rubric (20 Points Total)

Please submit the following:

1.  Your final `schema_postgres.sql` file.
2.  A separate SQL file named `indexes.sql` containing all the `CREATE INDEX` statements you used to optimize the queries.
3.  A Markdown document containing your analysis for each of the four scenarios. This document must include:
    *   The "before" and "after" execution plans from `EXPLAIN ANALYZE`.
    *   The "before" and "after" query execution times.
    *   The provided queries for each scenario with EXPLAIN ANALYZE
    *   Your answers to the analysis questions for each scenario.

