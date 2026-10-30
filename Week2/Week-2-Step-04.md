# Operational Event-Driven Monitoring & Alerting

**Owner:** Hazem Elsayed | **Region:** Europe (Stockholm) `eu-north-1`

---

## Summary
This task implements an automated monitoring and event-driven alerting architecture using **Amazon EventBridge** and **Amazon SNS** in the Stockholm region. The system routes infrastructure state changes and health alerts directly to designated endpoints.

* **Amazon EventBridge Rules:** Configured to monitor specific operational pattern events (SSH access, Auto Scaling lifecycles, and CloudWatch Alarm state changes).
* **Amazon SNS Topic:** Configured with confirmed email subscriptions and explicit access policies to handle alert delivery securely.

---

## Part 1: EventBridge Architecture & Event Pattern Rules

### 1.1 Event Buses Overview
The default EventBridge bus is utilized to capture system-generated events across the region.
* **Bus Name:** `default`
* **ARN:** `arn:aws:events:eu-north-1:253957900169:event-bus/default`

**Screenshot: EventBridge > Event buses**

![EventBridge Buses](./screenshots/Screenshot-2026-10-22-204845_2.png)

---

### 1.2 Event Pattern Rules Configuration
Three active event rules are deployed to handle specific operational triggers:
* `notify-alarm-state`: Monitors CloudWatch Alarm transitions.
* `notify-asg-events`: Captures Auto Scaling Group lifecycle notifications.
* `notify-ssh-open`: Tracks inbound SSH connections and potential security events.

**Screenshot: Event pattern rules list**

![Event Pattern Rules](./screenshots/Screenshot-2026-10-22-205211_2.png)

---

## Part 2: Amazon SNS Notification Infrastructure

### 2.1 Topic Details & Subscriptions
A dedicated SNS topic routes critical system alerts to the engineering team via email protocols.
* **Topic Name:** `Un_healthy_alert`
* **Topic ARN:** `arn:aws:sns:eu-north-1:253957900169:Un_healthy_alert`
* **Confirmed Subscriptions:**
  * `omarmohamedu309@gmail.com` (Email Protocol - Confirmed)
  * `hazemelsaied37@gmail.com` (Email Protocol - Confirmed)

**Screenshot: SNS > Topics > Un_healthy_alert > Subscriptions**

![SNS Subscriptions](./screenshots/Screenshot-2026-10-22-205237_2.png)

---

### 2.2 SNS Topic Access Policy
The IAM Access Policy defines publish and subscribe permissions restricted strictly to the topic owner resource scope (`253957900169`).

**Screenshot: Access policy configuration**

![SNS Access Policy 1](./screenshots/Screenshot-2026-10-22-205350_2.png)

![SNS Access Policy 2](./screenshots/Screenshot-2026-10-22-205357_2.png)

---

## Part 3: Verification & Status Summary

All SNS topics and EventBridge event rules have been verified active and confirmed within the `eu-north-1` region.

**Screenshot: Amazon SNS Topics Overview**

![SNS Topics List](./screenshots/Screenshot-2026-10-22-205414_2.png)
