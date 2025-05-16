# Database Performance Monitoring and Refinement

This document outlines the process of monitoring database performance, identifying bottlenecks, implementing optimizations, and measuring improvements for the AirBnB database. Continuous performance monitoring is essential for maintaining responsiveness as the application grows and query patterns evolve.


For this analysis, several SQL tools were utilized to monitor query performance:

- **EXPLAIN ANALYZE**: To examine query execution plans and actual execution times.
- **SHOW PROFILE**: To obtain detailed timing information for different query execution phases.
- **SHOW STATUS**: To monitor system-wide performance metrics.
- **Performance Schema**: To track query resource usage and identify bottlenecks.