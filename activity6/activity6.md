# Query Analysis and Optimization

# Scenario 1: The Slow Author Profile Page

## Before Query Plan and Execution
```txt
EXPLAIN ANALYZE SELECT id, title FROM posts WHERE author_id = 1 ORDER BY date DESC;
QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Sort  (cost=625.38..625.42 rows=18 width=52) (actual time=1.314..1.316 rows=23.00 loops=1)
   Sort Key: date DESC
   Sort Method: quicksort  Memory: 26kB
   Buffers: shared hit=500
   ->  Seq Scan on posts  (cost=0.00..625.00 rows=18 width=52) (actual time=0.101..1.289 rows=23.00 loops=1)
         Filter: (author_id = 1)
         Rows Removed by Filter: 9977
         Buffers: shared hit=500
 Planning Time: 0.158 ms
 Execution Time: 1.352 ms
(10 rows)
```


## After Query Plan and Execution:
```txt
EXPLAIN ANALYZE SELECT id, title FROM posts WHERE author_id = 1 ORDER BY date DESC;
QUERY PLAN    
--------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=66.78..66.82 rows=18 width=52) (actual time=0.123..0.125 rows=23.00 loops=1)
   Sort Key: date DESC
   Sort Method: quicksort  Memory: 26kB
   Buffers: shared hit=25
   ->  Bitmap Heap Scan on posts  (cost=4.42..66.40 rows=18 width=52) (actual time=0.047..0.108 rows=23.00 loops=1)
         Recheck Cond: (author_id = 1)
         Heap Blocks: exact=23
         Buffers: shared hit=25
         ->  Bitmap Index Scan on idx_author_id_post  (cost=0.00..4.42 rows=18 width=0) (actual time=0.024..0.025 rows=23.00 loops=1)
               Index Cond: (author_id = 1)
               Index Searches: 1
               Buffers: shared hit=2
 Planning Time: 0.142 ms
 Execution Time: 0.156 m
```


## Analysis Questions:

## Question 1: What is the primary node causing the slowness in the initial execution plan?
 - The primary node causing slowness in the initial execution plan is the Sequential Scan, because it is scanning every row for the values needed in the query.
## Question 2: How can you optimize both the WHERE clause filtering and the ORDER BY operation with a single change?
 - The optimization that can be implemented for this scenario is the creation of an index for the author_id and with the date included.
## Question 3: Implement your fix and record the new plan. How much faster is the query now?
 - The query is much faster now, lessening the time by 1.204ms which is a huge gap already when doing query for a database such as this.


# Scenario 2: The Unsearchable Blog

## Before Query Plan and Execution Times

```txt
EXPLAIN ANALYZE SELECT title FROM posts WHERE title LIKE '%dolor%';
QUERY PLAN                       
---------------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_title_post on posts  (cost=0.29..515.28 rows=1212 width=44) (actual time=0.159..4.061 rows=2015.00 loops=1)
   Filter: ((title)::text ~~ '%dolor%'::text)
   Rows Removed by Filter: 7985
   Heap Fetches: 0
   Index Searches: 1
   Buffers: shared hit=1 read=84
 Planning:
   Buffers: shared hit=18 read=1
 Planning Time: 0.654 ms
 Execution Time: 4.175 ms
(10 rows)
```

## Query: 

```txt
EXPLAIN ANALYZE SELECT title FROM posts WHERE title LIKE 'dolor%';
QUERY PLAN                       
---------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_title_post on posts  (cost=0.29..515.28 rows=1 width=44) (actual time=1.672..1.673 rows=0.00 loops=1)
   Filter: ((title)::text ~~ 'dolor%'::text)
   Rows Removed by Filter: 10000
   Heap Fetches: 0
   Index Searches: 1
   Buffers: shared hit=85
 Planning:
   Buffers: shared hit=3
 Planning Time: 0.284 ms
 Execution Time: 1.699 ms
(10 rows)
```


## Analysis Questions:

## First, try adding a standard B-Tree index on the title column. Run EXPLAIN ANALYZE again. Did the planner use your index? Why or why not? Place your answer here
 - The planner did not use my index, because of the LIKE '%dolor%' that checks every middle part of every string . 
## The business team agrees that searching by a prefix is acceptable for the first version. Rewrite the query to use a prefix search (e.g., database%). Place your answer here
 - 
```txt
EXPLAIN ANALYZE SELECT title FROM posts WHERE title LIKE 'dolor%';
QUERY PLAN                       
---------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_title_post on posts  (cost=0.29..515.28 rows=1 width=44) (actual time=1.672..1.673 rows=0.00 loops=1)
   Filter: ((title)::text ~~ 'dolor%'::text)
   Rows Removed by Filter: 10000
   Heap Fetches: 0
   Index Searches: 1
   Buffers: shared hit=85
 Planning:
   Buffers: shared hit=3
 Planning Time: 0.284 ms
 Execution Time: 1.699 ms
(10 rows)
```
## Does the index work for the prefix-style query? Explain the difference in the execution plan. Place your answer here
 - Yes, the execution plan for the first one is to search every title with a dolor in the middle part, while the other is focused on searching titles starting with dolor.

# Scenario 3: The Monthly Performance Report

## Before Query Plan and Execution

## NONS-ARGable
```txt
EXPLAIN ANALYZE SELECT id, title, date FROM posts WHERE EXTRACT(YEAR FROM date) = 2015 AND EXTRACT(MONTH FROM date) = 1;
QUERY PLAN    
-------------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..700.00 rows=1 width=52) (actual time=1.448..7.146 rows=22.00 loops=1)
   Filter: ((EXTRACT(year FROM date) = '2015'::numeric) AND (EXTRACT(month FROM date) = '1'::numeric))
   Rows Removed by Filter: 9978
   Buffers: shared hit=500
 Planning:
   Buffers: shared hit=12
 Planning Time: 0.553 ms
 Execution Time: 7.193 ms
(8 rows)
```

## S-ARGable
```txt
EXPLAIN ANALYZE SELECT id, title, date FROM posts WHERE date >= '2015-01-01' AND date < '2015-02-01';
QUERY PLAN    
-------------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..650.00 rows=16 width=52) (actual time=0.095..1.796 rows=22.00 loops=1)
   Filter: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
   Rows Removed by Filter: 9978
   Buffers: shared hit=500
 Planning:
   Buffers: shared hit=8
 Planning Time: 0.185 ms
 Execution Time: 1.826 ms
(8 rows)
```

## Query

## NONS-ARGable
```txt
EXPLAIN ANALYZE SELECT id, title, date FROM posts WHERE EXTRACT(YEAR FROM date) = 2015 AND EXTRACT(MONTH FROM date) = 1;
QUERY PLAN    
-------------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..700.00 rows=1 width=52) (actual time=0.072..2.145 rows=22.00 loops=1)
   Filter: ((EXTRACT(year FROM date) = '2015'::numeric) AND (EXTRACT(month FROM date) = '1'::numeric))
   Rows Removed by Filter: 9978
   Buffers: shared hit=500
 Planning:
   Buffers: shared hit=16 read=1
 Planning Time: 0.284 ms
 Execution Time: 2.158 ms
(8 rows)
```

## S-ARGable
```txt
EXPLAIN ANALYZE SELECT id, title, date FROM posts WHERE date >= '2015-01-01' AND date < '2015-02-01';
QUERY PLAN                        
---------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on posts  (cost=4.45..60.10 rows=16 width=52) (actual time=0.160..0.206 rows=22.00 loops=1)
   Recheck Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
   Heap Blocks: exact=22
   Buffers: shared hit=22 read=2
   ->  Bitmap Index Scan on idx_date_post  (cost=0.00..4.45 rows=16 width=0) (actual time=0.132..0.132 rows=22.00 loops=1)
         Index Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
         Index Searches: 1
         Buffers: shared read=2
 Planning Time: 0.173 ms
 Execution Time: 0.243 ms
(10 rows)
```

## Analysis Questions:

## This query is not S-ARGable. What does that mean in the context of this query? Why can't the query planner use a simple index on the date column effectively? Place your answer here
 - The original query used EXTRACT(YEAR FROM date), this is not S-ARGable because PostgreSQL must apply a function to every row's date value before it can filter. Meaning that it cannot use an index created on the date columng. 
## Rewrite the query to use a direct date range comparison, making it S-ARGable. Place your answer here
 - 
 ```txt
EXPLAIN ANALYZE SELECT id, title, date FROM posts WHERE date >= '2015-01-01' AND date < '2015-02-01';
QUERY PLAN                        
---------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on posts  (cost=4.45..60.10 rows=16 width=52) (actual time=0.160..0.206 rows=22.00 loops=1)
   Recheck Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
   Heap Blocks: exact=22
   Buffers: shared hit=22 read=2
   ->  Bitmap Index Scan on idx_date_post  (cost=0.00..4.45 rows=16 width=0) (actual time=0.132..0.132 rows=22.00 loops=1)
         Index Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
         Index Searches: 1
         Buffers: shared read=2
 Planning Time: 0.173 ms
 Execution Time: 0.243 ms
(10 rows)
```
## Create an appropriate index to support your rewritten query. Place your answer here
 - ```CREATE INDEX idx_date_post ON posts(date);```
## Compare the performance of the original query and your optimized version. Place your answer here
 - Non-S-ARGable(Without Index): 7.193ms execution time with Sequential Scan
 - S-ARGABLE(Without Index): 1.826ms execution time with Sequential Scan
 - Non-S-ARGable(With Index): 2.158ms execution time with Sequential Scan
 - S-ARGable(With Index): 0.243ms exection time with Bitmap Index Scan
 - The S-ARGable query with index uses Bitmap Index Scan instead of the Sequential Scan which reduced the execution time by 6.95ms or approximately 96.6%.

