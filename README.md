# Running Average Aggregation in PostgreSQL

## Overview

This project demonstrates the implementation of a **streaming running-average aggregation** using **PostgreSQL**. The solution processes data in a single pass by leveraging SQL window functions and user-defined database objects, simulating a real-time stream processing workflow.

Rather than repeatedly scanning data, the implementation maintains incremental aggregate state, making it an efficient approach for continuous data processing scenarios.

---

## Project Highlights

- Developed a custom running-average aggregation solution in PostgreSQL
- Implemented a user-defined aggregate using PL/pgSQL
- Simulated streaming data processing using a one-pass execution model
- Utilized SQL window functions for efficient incremental calculations
- Designed reusable database objects including custom types, functions, and aggregates
- Demonstrated stateful aggregation without requiring multiple table scans

---

## Technologies Used

- PostgreSQL
- SQL
- PL/pgSQL
- Window Functions
- User-Defined Aggregates (UDA)
- Common Table Expressions (CTEs)

---

## Problem Statement

Traditional aggregate functions calculate results only after all rows have been processed. Modern streaming systems, however, require statistics to be updated continuously as new records arrive.

This project addresses that challenge by implementing a running average that:

- Processes incoming records sequentially
- Maintains aggregate state during execution
- Produces updated averages as new measurements arrive
- Mimics real-world stream processing techniques

---

## Dataset

The project uses a sample `Stream` table containing:

| Column | Description |
|---------|-------------|
| `id` | Sequential event identifier |
| `grp` | Logical group identifier |
| `measure` | Numeric measurement value |

Each group maintains its own running average independently.

---

## Implementation

The solution consists of several database components.

### 1. Stream Table

Creates a sample streaming dataset with integrity constraints.

### 2. Custom Aggregate State

Defines a composite type that stores:

- Running sum
- Running count

This state is maintained throughout execution.

### 3. State Transition Function

The transition function updates the aggregate state for every incoming record by:

- Updating the cumulative sum
- Incrementing the observation count
- Returning the updated state

### 4. Final Function

Calculates the running average using:

```
Average = Sum / Count
```

### 5. User-Defined Aggregate

A custom PostgreSQL aggregate combines the transition and final functions to produce reusable running-average functionality.

### 6. Window-Based Streaming Logic

The implementation uses:

- `LAG()`
- `SUM() OVER`
- `AVG() OVER`
- Common Table Expressions (CTEs)

to identify group boundaries and calculate incremental averages while preserving stream order.

---

## Example Output

| ID | Group | Measure | Running Average |
|----|-------|---------|----------------:|
| 0 | 0 | 2 | 2.00 |
| 1 | 0 | 3 | 2.50 |
| 2 | 1 | 5 | 5.00 |
| 3 | 1 | 7 | 6.00 |
| 4 | 1 | 11 | 7.67 |

Each group's running average is calculated independently as new records arrive.

---

## Repository Structure

```
.
├── runningAvg.sql      # Complete SQL implementation
└── README.md           # Project documentation
```

---

## Key Concepts Demonstrated

- Streaming data processing
- Stateful computation
- Incremental aggregation
- PostgreSQL user-defined aggregates
- Window functions
- Common Table Expressions (CTEs)
- Database programming with PL/pgSQL
- Query optimization through single-pass execution

---

## Learning Outcomes

Through this project I gained practical experience with:

- Designing custom aggregate functions in PostgreSQL
- Building reusable database components
- Implementing stateful computations in SQL
- Applying window functions to streaming-style problems
- Processing ordered datasets efficiently using a single-pass approach
- Writing modular, maintainable SQL for analytical workloads

---

## Why This Project Matters

Streaming analytics are widely used in modern data platforms for monitoring, financial transactions, IoT, telemetry, and event-driven systems. This project demonstrates how advanced SQL features can be used to build efficient, incremental analytics without relying on external stream-processing frameworks.

The implementation showcases practical database engineering techniques that are applicable to data engineering, analytics, and backend software development.
