# 🎪 Community Festival Management System

> **A production-grade relational database system** that manages every moving piece of a cultural festival — from ticket sales and artist scheduling to sponsor tracking and volunteer coordination — built entirely on PostgreSQL.

---

## 📌 What This Project Is (In Plain English)

Imagine you're running a music and arts festival with **thousands of attendees**, dozens of artists, multiple venues, sponsors writing checks, and volunteers keeping the lights on. Tracking all of that on spreadsheets? That's a disaster waiting to happen — double bookings, lost ticket revenue, no idea which sponsor paid what.

This project replaces that chaos with a **real, structured database** that:
- Knows exactly which artist is performing at which event, in which venue, and when
- Tracks every ticket sold, who bought it, and how much revenue it brought in
- Manages participant registrations and ties them to specific festivals
- Logs every piece of feedback so organizers can see what worked and what didn't
- Keeps sponsor contributions organized by tier (Gold, Silver, Bronze, etc.)
- Schedules volunteers across roles and availability windows

It's not a toy demo — the database runs on **33,000+ records** of realistic synthetic data, generated with Python's Faker library, to simulate a real-world production load.

---

## 🧠 Skills Demonstrated

| Skill Area | What Was Done | Why It Matters |
|:---|:---|:---|
| **Database Design & Normalization** | Designed 11 interconnected tables with proper primary keys, foreign keys, and constraints | Shows ability to model complex real-world domains into clean, normalized schemas |
| **DDL (Data Definition Language)** | Wrote production-ready `CREATE TABLE` statements with data types, serial IDs, defaults, and `CASCADE` delete rules | Demonstrates understanding of schema-level data integrity |
| **DML (Data Manipulation Language)** | Wrote `INSERT`, `UPDATE`, and `DELETE` queries with verification selects | Covers day-to-day data operations that every backend engineer handles |
| **Complex SQL Queries** | Multi-table JOINs, GROUP BY with aggregation, ORDER BY, correlated subqueries with HAVING, window functions (`ROW_NUMBER() OVER`) | Proves ability to extract meaningful business insights from raw data |
| **Stored Functions & Procedures** | Created PL/pgSQL functions (`insert_new_artist`) and procedures (`insert_new_volunteer_and_show`) with parameterized inputs and `RAISE NOTICE` logging | Shows server-side logic skills — the kind used in enterprise database layers |
| **Transactions & Atomicity** | Wrote `BEGIN`/`COMMIT` transaction blocks with loop-based bulk inserts to test constraint violations | Demonstrates understanding of ACID properties and how databases protect data consistency |
| **Triggers & Event-Driven Logic** | Built a trigger function (`handle_transaction_failure`) that fires `AFTER INSERT OR UPDATE OR DELETE` to log errors automatically | Shows ability to build reactive, self-healing database behavior |
| **Query Performance Optimization** | Used `EXPLAIN ANALYZE` to identify slow queries, then created targeted indexes (including covering indexes with `INCLUDE`) | Proves you can diagnose and fix real performance bottlenecks — a high-value production skill |
| **Synthetic Data Generation** | Python + Faker to generate 3,000 records per table (33,000+ total) with realistic names, dates, emails, and prices | Demonstrates data engineering and automation skills beyond pure SQL |
| **Business Intelligence & Dashboarding** | Built a Power BI dashboard with live metrics — total artists by genre, top revenue events, ticket trends by month, registration types | Shows the ability to turn raw data into visual stories for stakeholders |

---

## 🏗️ Database Architecture

### Entity-Relationship Overview

The system is built around **11 tables** with carefully designed relationships:

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  Festival    │──1:N──│    Event     │──1:N──│   Ticket    │
│             │       │             │       │             │
│ FestivalID  │       │ EventID     │       │ TicketID    │
│ Name        │       │ FestivalID  │       │ EventID     │
│ StartDate   │       │ Title       │       │ BuyerName   │
│ EndDate     │       │ EventDate   │       │ Price       │
│ Description │       │ VenueID     │       │ TicketType  │
└─────────────┘       └──────┬──────┘       └─────────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────┴─────┐   ┌──────┴──────┐
              │Performance│   │  Feedback   │
              │           │   │             │
              │ EventID   │   │ EventID     │
              │ ArtistID  │   │ Rating      │
              │ Duration  │   │ Comments    │
              └─────┬─────┘   └─────────────┘
                    │
              ┌─────┴─────┐
              │   Artist   │
              │           │
              │ ArtistID  │
              │ Name      │
              │ Genre     │
              │ Bio       │
              └───────────┘

┌─────────────┐       ┌──────────────┐       ┌─────────────┐
│ Participant │──1:1──│ Registration │──N:1──│  Festival   │
│             │       │              │       │             │
│ Email (PK)  │       │ RegistrationID│      └─────────────┘
│ Name        │       │ FestivalID   │
│ RegDate     │       │ Email (FK+UQ)│
│ RegType     │       └──────────────┘
└─────────────┘

┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   Venue     │       │   Sponsor   │       │  Volunteer  │
│             │       │             │       │             │
│ VenueID     │       │ SponsorID   │       │ VolunteerID │
│ Name        │       │ Name        │       │ Name        │
│ Address     │       │ Contribution│       │ Availability│
│ Capacity    │       │ Type (Tier) │       │ Role        │
└─────────────┘       └─────────────┘       └─────────────┘
```

### Key Constraints & Integrity Rules
- **Foreign Keys with CASCADE** — Deleting a festival automatically removes its events, tickets, and performances. No orphaned data.
- **Unique Email Constraint** — Each participant can only register once per festival. Prevents duplicates at the database level.
- **Default Values** — Volunteer availability defaults to `'Available'`, so new volunteers don't need manual status setting.

---

## ⚡ Query Performance Optimization (Before vs. After)

One of the most valuable parts of this project: identifying slow queries on 3,000+ record tables and fixing them with targeted indexes.

### The Approach
1. **Ran `EXPLAIN ANALYZE`** on real queries to get the actual execution plan and timing
2. **Identified bottlenecks** — sequential scans on large tables, expensive sort operations
3. **Created indexes** — standard B-tree indexes on foreign keys and a **covering index** with `INCLUDE` to avoid table lookups entirely
4. **Re-ran the queries** and measured the improvement

### Indexes Created

| Index | Table | Column(s) | Type | Purpose |
|:---|:---|:---|:---|:---|
| `idx_ticket_event` | Ticket | EventID | B-tree | Speed up ticket-to-event joins |
| `idx_event_festival` | Event | FestivalID | B-tree | Speed up event-to-festival lookups |
| `idx_ticket_event_covering` | Ticket | EventID + TicketID (INCLUDE) | Covering Index | Eliminates extra table lookups for ticket counts |
| `idx_event_festivalid` | Event | FestivalID | B-tree | Optimize event filtering by festival |
| `idx_registration_festivalid` | Registration | FestivalID | B-tree | Optimize registration lookups by festival |

> 📸 **Before/After execution plan screenshots** are available in the [`Phase 2 Screenshots/Part_3 Indexing & Query Execution Analysis`](Phase%202%20Screenshots/Part_3%20Indexing%20%26%20Query%20Execution%20Analysis) folder — showing real `EXPLAIN ANALYZE` output with timing comparisons.

---

## 🔄 Transactions, Triggers & Server-Side Logic

### Transactions
Wrote a transaction block that intentionally tests constraint handling by attempting to insert 100 records with a **duplicate primary key** inside a `BEGIN`/`COMMIT` block. This demonstrates understanding of:
- **Atomicity** — either all inserts succeed or none do
- **Constraint enforcement** — the database rejects invalid data automatically
- **Rollback behavior** — how PostgreSQL protects data consistency under failure

### Triggers
Built an **event-driven error logging system**:
1. A **trigger function** (`handle_transaction_failure`) catches errors and logs them to an `error_log` table
2. A **trigger** fires automatically `AFTER INSERT OR UPDATE OR DELETE` on the Volunteer table
3. This creates a self-monitoring database that records its own failure events — a real production pattern

### Stored Functions & Procedures
- **`insert_new_artist()`** — A PL/pgSQL function that encapsulates artist creation logic. Takes name, genre, contact, and bio as parameters. Called via `SELECT insert_new_artist(...)`.
- **`insert_new_volunteer_and_show()`** — A stored procedure that inserts a new volunteer AND logs the action with `RAISE NOTICE`. Called via `CALL`. Includes default parameter values for availability and role.

---

## 📊 Power BI Dashboard

A live, interactive dashboard deployed on the web that gives festival organizers instant visibility into:

| Metric | What It Shows |
|:---|:---|
| **Artists by Genre** | Distribution of performers across Rock, Jazz, Pop, Classical, etc. |
| **Top Revenue Events** | Which events brought in the most ticket revenue |
| **Registration Types** | Breakdown of Attendees vs. Volunteers vs. Exhibitors per event |
| **Monthly Ticket Sales** | Ticket volume trends over time for demand forecasting |

🔗 **[View the Live Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiYzExN2Y1NWMtYzJiYS00MjhhLWFiNDUtZGE1NTEyNDU3MDY2IiwidCI6Ijk2NDY0YThhLWY4ZWQtNDBiMS05OWUyLTVmNmI1MGEyMDI1MCIsImMiOjN9&pageName=91ecc1bbd1259d65666e)**

---

## 📁 Project Structure

```
Community-Festival-Management/
│
├── Database_Setup_Queries/           # Phase 1: Schema & Data
│   ├── create.sql                    # DDL — all 11 tables with constraints & foreign keys
│   ├── insert_artist.sql             # 3,000 artist records
│   ├── insert_event.sql              # 3,000 event records
│   ├── insert_feedback.sql           # 3,000 feedback records
│   ├── insert_festival.sql           # 3,000 festival records
│   ├── insert_participant.sql        # 3,000 participant records
│   ├── insert_performance.sql        # 3,000 performance records
│   ├── insert_registration.sql       # 3,000 registration records
│   ├── insert_sponsor.sql            # 3,000 sponsor records
│   ├── insert_ticket.sql             # 3,000 ticket records
│   ├── insert_venue.sql              # 3,000 venue records
│   └── insert_volunteer.sql          # 3,000 volunteer records
│
├── Phase 2 SQL Files/                # Phase 2: Advanced SQL
│   ├── Part_1 *.sql                  # 10+ queries — JOINs, GROUP BY, subqueries, 
│   │                                 #   window functions, functions, procedures,
│   │                                 #   INSERT, UPDATE, DELETE
│   ├── Part_2 *.sql                  # Transactions, trigger functions, triggers
│   └── Part_3 *.sql                  # EXPLAIN ANALYZE, indexing, query optimization
│
├── Phase 2 Screenshots/             # Proof of execution
│   ├── Part 1_More than 10 Queries/  # Screenshots of query results
│   ├── Part_2 Transactions & Triggers/ # Screenshots of trigger & transaction behavior
│   └── Part_3 Indexing & Query Execution Analysis/ # Before/after EXPLAIN ANALYZE
│
├── Faker_Data_Insertion.ipynb        # Jupyter notebook — Python + Faker data generation
│
└── Bonus - Event Management Dashboard.pbix  # Power BI dashboard file
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|:---|:---|
| **Database** | PostgreSQL |
| **Schema Design** | pgAdmin 4 ERD Tool |
| **Query Language** | SQL (DDL, DML, PL/pgSQL) |
| **Data Generation** | Python 3.9+ with Faker library |
| **Notebook** | Jupyter / Google Colab |
| **Dashboarding** | Microsoft Power BI |

---

## 🚀 How to Run

### 1. Set Up the Database
```bash
# In psql or pgAdmin PSQL Tool:
\i path/to/Database_Setup_Queries/create.sql
```

### 2. Load the Data
```bash
\i path/to/Database_Setup_Queries/insert_festival.sql
\i path/to/Database_Setup_Queries/insert_venue.sql
\i path/to/Database_Setup_Queries/insert_artist.sql
\i path/to/Database_Setup_Queries/insert_event.sql
\i path/to/Database_Setup_Queries/insert_participant.sql
\i path/to/Database_Setup_Queries/insert_registration.sql
\i path/to/Database_Setup_Queries/insert_performance.sql
\i path/to/Database_Setup_Queries/insert_ticket.sql
\i path/to/Database_Setup_Queries/insert_feedback.sql
\i path/to/Database_Setup_Queries/insert_sponsor.sql
\i path/to/Database_Setup_Queries/insert_volunteer.sql
```

> **Note:** Load parent tables first (Festival, Venue, Artist, Participant) before child tables to satisfy foreign key constraints.

### 3. Run Phase 2 Queries
Open any `.sql` file from the `Phase 2 SQL Files/` directory in pgAdmin or psql to execute.

### 4. Generate Fresh Data (Optional)
```bash
pip install faker
# Open and run Faker_Data_Insertion.ipynb in Jupyter or Google Colab
```

---

## 📈 Project Metrics at a Glance

| Metric | Value |
|:---|:---|
| Total tables designed | **11** |
| Total records generated | **33,000+** |
| Foreign key relationships | **8** |
| Unique SQL queries written | **20+** |
| Stored functions & procedures | **2** |
| Triggers implemented | **1** (with trigger function) |
| Indexes created for optimization | **5** |
| Dashboard metrics visualized | **4** |
| Languages used | **SQL, Python** |

---

## 🎯 Who This Is For

This project is a strong fit for roles in:
- **Database Engineering** — schema design, normalization, constraint management
- **Backend Development** — server-side logic with stored procedures, triggers, transactions
- **Data Engineering** — synthetic data generation, ETL patterns, data pipeline thinking
- **Data Analytics / BI** — turning raw data into actionable dashboards
- **Software Engineering** — working with relational databases as part of a larger system

---

<p align="center">
  <b>Built with PostgreSQL · Python · Power BI</b>
</p>
