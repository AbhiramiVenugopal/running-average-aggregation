# running-average-aggregation
User-defined aggregate to handle a running-average aggregation in a one-pass manner (“streaming”).Using the database system PostgreSQL.

This project focuses on implementing a user-defined aggregate in PostgreSQL to handle a running-average aggregation in a one-pass manner, simulating a streaming data scenario using SQL. The project leverages the concept of pipelining, which minimizes data scans to a single pass, making it ideal for stream-processing tasks.

Key Objectives
Develop a SQL-based stream-processing program that computes the running average of measurements for each group within a table.
Ensure the query performs in a purely pipelined way, necessitating only a single scan of the table.

Prerequisites
PostgreSQL: The assignment requires a PostgreSQL database. Ensure PostgreSQL is installed and running on your system. Refer to the PostgreSQL installation guide for setup instructions.




