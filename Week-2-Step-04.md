# Operational Self-Healing (Compute) - Step Details

**Owner:** Hazem Elsayed | **Region:** Europe (Stockholm) `eu-north-1`

---

## Overview
This step documents the configuration and verification of compute self-healing mechanisms using **Amazon EC2 Auto Scaling Groups (ASG)** and **Application Load Balancers (ALB)** within the Stockholm region.

---

## Configuration & Setup

### 1. Target Group Health Checks
The Application Load Balancer is configured with rigorous health checks to continuously monitor the state of instances in the target group (`Team-Compute-TG`).
* **Protocol:** HTTP[cite: 22]
* **Path:** `/`[cite: 22]
* **Interval:** 30 seconds[cite: 22]
* **Timeout:** 5 seconds[cite: 22]
* **Healthy Threshold:** 2 consecutive successes[cite: 22]
* **Unhealthy Threshold:** 2 consecutive failures[cite: 22]
* **Success Codes:** 200[cite: 22]

**Screenshot: Target Group > Health checks tab**
![Target Group Health Checks](./screenshots/target-group-health.png)

---

### 2. Auto Scaling Group (ASG) Integration
The Auto Scaling Group (`Team-Compute-SG`) is successfully attached to the Target Group, ensuring dynamic traffic distribution and automatic scaling limits management.
* **Desired Capacity:** 2 instances[cite: 23, 24]
* **Scaling Limits:** Min: 2, Max: 4[cite: 23, 24]
* **Target Group Attached:** `Team-Compute-TG`[cite: 23, 24]

**Screenshot: ASG > Integrations tab > Load balancing**
![ASG Load Balancing Integration](./screenshots/ASG-integrations.png)

---

## Test and Evidence

### Test Method & Execution
To test the self-healing capability, `sudo systemctl stop httpd` was manually executed on a running instance inside the ASG[cite: 24]. 

### Result
* The target instance failed the ALB health check and was marked unhealthy[cite: 24].
* The Auto Scaling Group automatically terminated the unhealthy instance and provisioned a fresh replacement instance[cite: 24].
* The Target Group successfully restored a stable state with 2 healthy targets[cite: 24].

**Replacement Cycles Logged:**
| Time | Terminated Instance | Launched Instance |
| :--- | :--- | :--- |
| **08:07 PM** | `i-09f720104bfee4457`[cite: 24] | `i-0b802ff0ed4410345`[cite: 24] |
| **08:19 PM** | `i-0b802ff0ed4410345`[cite: 24] | `i-0ece750a0c7fc2084`[cite: 24] |

**Screenshot: Target Group before the test (2 Healthy / 0 Unhealthy)**
![Target Group Status](./screenshots/target-group-status.png)
