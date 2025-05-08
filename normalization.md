# Database Normalization Analysis

## Introduction

Normalization is a database design technique that reduces data redundancy and improves data integrity by organizing fields and tables in a way that minimizes dependencies. This document analyzes the AirBnB database schema against the first three normal forms (1NF, 2NF, and 3NF) to ensure proper design and identify any potential issues.

## Normalization Principles

### First Normal Form (1NF)

- Each table cell should contain a single value  
- Each record needs to be unique  
- Each column contains atomic values  
- No repeating groups  

---

### Second Normal Form (2NF)

- Table must be in 1NF  
- All non-key attributes must depend on the entire primary key  
- If a table has a single-column primary key, it automatically satisfies 2NF  

---

### Third Normal Form (3NF)

- Table must be in 2NF  
- No transitive dependencies (non-key attributes shouldn't depend on other non-key attributes)  


## Database Schemas Analysis

### User Table

| Field Name     | Data Type | Constraints                         |
|----------------|-----------|-------------------------------------|
| User ID        | UUID      | Primary Key, Indexed                |
| First Name     | VARCHAR   | NOT NULL                            |
| Last Name      | VARCHAR   | NOT NULL                            |
| Email          | VARCHAR   | NOT NULL, UNIQUE                    |
| Password Hash  | VARCHAR   | NOT NULL                            |
| Phone Number   | VARCHAR   | NULL                                |
| Role           | ENUM      | (guest, host, admin), NOT NULL      |
| Created At     | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP           |

#### First Normal Form (1NF)

- Each field holds a single, atomic value.
- There are no repeating groups or arrays.
- `User ID` serves as the unique identifier.

**Conclusion:** The User table satisfies 1NF.

#### Second Normal Form (2NF)

- The primary key is a single attribute: `User ID`.
- All non-key attributes (e.g., `First Name`, `Email`, `Role`) depend fully on `User ID`.

**Conclusion:** The User table satisfies 2NF.

#### Third Normal Form (3NF)

- No non-key attributes depend on other non-key attributes
- All fields directly depend on the primary key

**Conclusion:** The User table satisfies 3NF.

### Property Table

| Field Name       | Data Type | Constraints                              |
|------------------|-----------|------------------------------------------|
| Property ID      | UUID      | Primary Key, Indexed                     |
| Host ID          | UUID      | Foreign Key → User(User ID)              |
| Name             | VARCHAR   | NOT NULL                                 |
| Description      | TEXT      | NOT NULL                                 |
| Location         | VARCHAR   | NOT NULL                                 |
| Price Per Night  | DECIMAL   | NOT NULL                                 |
| Created At       | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                |
| Updated At       | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP              |

#### First Normal Form (1NF)

- All columns store atomic values.
- No repeating groups or arrays are present.
- `Property ID` uniquely identifies each record.

**Conclusion:** The Property table satisfies 1NF.

#### Second Normal Form (2NF)

- The primary key is a single attribute: `Property ID`.
- All non-key attributes (e.g., `Name`, `Host ID`, `Location`) depend directly and entirely on `Property ID`.

**Conclusion:** The Property table satisfies 2NF. 

#### Third Normal Form (3NF)

- Each attribute is directly dependent on the primary key (`Property ID`).
- `Host ID` is a foreign key, but it is not dependent on any other non-key attribute.
- There are no derived or computed fields that introduce transitive dependencies.

**Conclusion:** The Property table satisfies 3NF.

### Booking Table

| Field Name   | Data Type | Constraints                                |
|--------------|-----------|--------------------------------------------|
| Booking ID   | UUID      | Primary Key, Indexed                       |
| Property ID  | UUID      | Foreign Key → Property(Property ID)        |
| User ID      | UUID      | Foreign Key → User(User ID)                |
| Start Date   | DATE      | NOT NULL                                   |
| End Date     | DATE      | NOT NULL                                   |
| Total Price  | DECIMAL   | NOT NULL                                   |
| Status       | ENUM      | (pending, confirmed, canceled), NOT NULL   |
| Created At   | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                  |

#### First Normal Form (1NF)

- All columns store atomic values.
- No repeating groups or arrays are present.
- `Booking ID` uniquely identifies each record.

**Conclusion:** The Booking table satisfies 1NF.

#### Second Normal Form (2NF)

- The primary key is a single attribute: `Booking ID`.
- All non-key attributes depend directly and entirely on `Booking ID`.

**Conclusion:** The Booking table satisfies 2NF.

#### Third Normal Form (3NF)

- `Total Price` might be calculated from `Price Per Night` in `Property` and the duration (`End Date` - `Start Date`). This could create a transitive dependency where `Total Price` depends on other attributes rather than directly on the primary key. However, storing `Total Price` is justified because prices may change over time Since `Total Price` represents a business value at booking time, it should be stored.
- Each attribute is directly dependent on the primary key (`Booking ID`).
- `Property ID` and `User ID` are foreign keys, but they are not dependent on any other non-key attribute.

**Conclusion:** The Booking table satisfies 3NF.

### Payment Table

| Field Name   | Data Type | Constraints                                    |
|--------------|-----------|------------------------------------------------|
| Payment ID   | UUID      | Primary Key, Indexed                           |
| Booking ID   | UUID      | Foreign Key → Booking(Booking ID)              |
| Amount       | DECIMAL   | NOT NULL                                       |
| Payment Date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                      |
| Payment Method | ENUM    | (credit_card, paypal, stripe), NOT NULL        |

#### First Normal Form (1NF)

- All columns store atomic values.
- No repeating groups or arrays are present.
- Payment ID uniquely identifies each record.

**Conclusion:** The Payment table satisfies 1NF. 

#### Second Normal Form (2NF)

- The primary key is a single attribute: Payment ID.
- All non-key attributes depend directly and entirely on Payment ID.

**Conclusion:** The Payment table satisfies 2NF.

#### Third Normal Form (3NF)

- Each attribute is directly dependent on the primary key (Payment ID).
- Booking ID is a foreign key, but it is not dependent on any other non-key attribute.
- There are no derived or computed fields that introduce transitive dependencies.

**Conclusion:** The Payment table satisfies 3NF.

### Review Table

| Field Name   | Data Type | Constraints                                                    |
|--------------|-----------|----------------------------------------------------------------|
| Review ID    | UUID      | Primary Key, Indexed                                           |
| Property ID  | UUID      | Foreign Key → Property(Property ID)                            |
| User ID      | UUID      | Foreign Key → User(User ID)                                    |
| Rating       | INTEGER   | NOT NULL, CHECK (rating >= 1 AND rating <= 5)                  |
| Comment      | TEXT      | NOT NULL                                                       |
| Created At   | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                                      |

#### First Normal Form (1NF)

- All columns store atomic values.
- No repeating groups or arrays are present.
- `Review ID` uniquely identifies each record.

**Conclusion:** The Review table satisfies 1NF.

#### Second Normal Form (2NF)

- The primary key is a single attribute: `Review ID`.
- All non-key attributes depend directly and entirely on Review ID.

**Conclusion:** The Review table satisfies 2NF.

#### Third Normal Form (3NF)

- No transitive dependencies
- All non-key attributes depend directly on the primary key

**Conclusion:** The Review table satisfies 3NF.

### Message Table

| Field Name     | Data Type | Constraints                                   |
|----------------|-----------|-----------------------------------------------|
| Message ID     | UUID      | Primary Key, Indexed                          |
| Sender ID      | UUID      | Foreign Key → User(User ID)                   |
| Recipient ID   | UUID      | Foreign Key → User(User ID)                   |
| Message Body   | TEXT      | NOT NULL                                      |
| Sent At        | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                     |

#### First Normal Form (1NF)

- All columns store atomic values.
- No repeating groups or arrays are present.
- Message ID uniquely identifies each record.

**Conclusion:** The Message table satisfies 1NF

#### Second Normal Form (2NF)

- The primary key is a single attribute: `Message ID`.
- All non-key attributes depend directly and entirely on Message ID.

**Conclusion:** The Message table satisfies 2NF.

#### Third Normal Form (3NF)

- Each attribute is directly dependent on the primary key (`Message ID`).
- `Sender ID` and `Recipient ID` are foreign keys, but they are not dependent on any other non-key attribute.
- There are no transitive dependencies between non-key attributes.

**Conclusion:** The Message table satisfies 3NF.