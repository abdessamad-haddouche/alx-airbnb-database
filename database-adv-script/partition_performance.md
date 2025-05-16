# Table Partitioning Performance Analysis

This report analyzes the performance impact of implementing **RANGE partitioning** on the `booking` table in the AirBnB database. As the `booking` table increases in size, query performance—particularly for date-range queries—can significantly degrade.

Date-range queries are frequently executed in booking systems for availability checks, analytics, and reporting. To address performance bottlenecks associated with these queries, **table partitioning** was introduced. Specifically, **RANGE partitioning** was applied, dividing the `booking` table into smaller, more manageable partitions based on `booking` dates.

This approach aims to improve query efficiency, reduce I/O operations, and ensure scalability as the dataset continues to grow.