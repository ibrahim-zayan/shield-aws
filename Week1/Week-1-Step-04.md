# Week 1: AWS Cloud Infrastructure & Database Setup (Stockholm Region)

## Overview
This documentation covers the core tasks completed during Week 1, focusing on deploying and securing an AWS RDS MySQL database within a custom VPC infrastructure in the **Stockholm (`eu-north-1`)** region.

---

## Architecture & Resources Configured

### 1. Amazon RDS (Relational Database Service)
* **DB Identifier:** `db-primary`[cite: 6, 7]
* **Engine:** MySQL Community (Instance Class: `db.t3.micro`)[cite: 6, 7]
* **Region & AZ:** `eu-north-1` (Availability Zone: `eu-north-1a`)[cite: 6, 7]
* **Status:** Available & Active[cite: 6, 7]
* **Public Accessibility:** Disabled (Secure internal deployment)[cite: 10]

### 2. Networking & Subnet Groups
* **VPC ID:** `Primary-vpc` (`vpc-0bc4b5580c679f013`)[cite: 8, 9, 10]
* **Subnet Group Name:** `primary-db-subnet-group`[cite: 9, 10]
* **Configured Subnets (Multi-AZ):**
  * `Primary-subnet-private-db1-eu-north-1a` (`10.0.21.0/24`)[cite: 9]
  * `Primary-subnet-private-db2-eu-north-1b` (`10.0.22.0/24`)[cite: 9]

### 3. Security & Access Control (Security Groups)
* **Security Group Name:** `Primary-DB-RDS-SG` (`sg-025701f7eaec9cecb`)[cite: 8, 10]
* **Inbound Rules:**
  * **Type:** `MYSQL/Aurora` (Port `3306`)[cite: 8]
  * **Source:** Restricted traffic allowed exclusively from the Primary App EC2 Security Group.

---

## Verification Screenshots

### Database Status & Summary
![Database Summary](./Screenshoots/Screenshot%202026-10-19%20224359.png)

### Database List in Stockholm Region
![Databases List](./Screenshoots/Screenshot%202026-10-19%20224340.png)

### Security Group Configuration (Inbound Rules)
![Security Groups](./Screenshoots/Screenshot%202026-10-19%20224643.png)

### Subnet Groups Setup
![Subnet Groups](./Screenshoots/Screenshot%202026-10-19%20224527.png)

### Database Connectivity & Additional Configurations
![Connectivity and Security](./Screenshoots/Screenshot%202026-10-19%20224427.png)
