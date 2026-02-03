# i RECORDED TIMES

Initial Data Insertion Time (100,000 rows): 175.309ms

Query Execution Time (Non-Indexed): 6.744ms

Query Execution Time (Indexed): 0.119ms

Single Row Insertion Time (With Index): 6.538ms

# ii ANALYSIS QUESTIONS

1. How did the query execution time change after creating the index? Was it faster or slower? By approximately how much?
- The query execution time changed drastically, becoming faster by almost 90%.

2. Why do you think the query performance changed as you observed?
- Because it applied the b-tree indexing strategy, instead of scanning the entirety of the table, it skips certain parts because of its sorted data.

3. What is the trade-off of having an index on a table? (Hint: Compare the initial bulk insertion time with the single row insertion time after the index was created).
- The trade-off for having an index on a table is that, when it comes to write process, such as INSERT the time that it will take to execute is much slower.

# iii SCREENSHOTS

ROW COUNT VERIFICATION
![](/activity5/images/image1.png)

EXPLAIN ANALYZE OUTPUT FOR NON-INDEXED QUERY
![](/activity5/images/image2.png)
![](/activity5/images/image3.png)

EXPLAIN ANALYZE OUTPUT FOR INDEXED QUERY
![](/activity5/images/image4.png)


