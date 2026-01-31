# Library Management System - SQL Advanced Implementation

## 📌 Project Overview
This project demonstrates a robust SQL database schema for a Library Management System. It covers the full lifecycle of database development, from initial design and data seeding to advanced normalization and automation using triggers.

## 🚀 Key Features
- **Relational Schema Design**: Implemented structured tables for Books, Authors, Users, and Loans.
- **Database Normalization**: Performed a schema re-engineering to decouple Authors from the Books table, ensuring data integrity and reducing redundancy.
- **Business Logic Automation**: Created SQL Triggers to automatically manage book availability (`disponible`) based on loan and return events.
- **Performance Optimization**: Strategic use of Indexes (`idx_libros_titulo`, `idx_prestamos_usuario`) to accelerate search queries and reporting.
- **Advanced Querying**: Utilized complex `JOIN` operations, session variables, and subqueries for analytical reporting.

## 🛠️ Tech Stack
- **Database Engine**: MySQL 8.0+
- **Tooling**: MySQL Workbench
- **Language**: SQL (DDL, DML, DQL)

## 📂 Database Structure
The project follows a normalized relational model:
* **Authors (1) <-> Books (N)**: Each book is linked to a unique author via `autor_id`.
* **Books (1) <-> Loans (N)**: Tracks the history of book circulation.
* **Users (1) <-> Loans (N)**: Tracks user borrowing activity.



## 📋 How to Use
1. Clone the repository.
2. Execute the script in your MySQL environment.
3. The triggers will automatically handle book availability—no manual updates required when inserting into the `prestamos` table.

## 🧠 Lessons Learned
- Implementing `SQL_SAFE_UPDATES` toggles for maintenance tasks.
- Using `DELIMITER` to define complex multi-line triggers.
- Managing referential integrity with `FOREIGN KEY` constraints during schema alterations.