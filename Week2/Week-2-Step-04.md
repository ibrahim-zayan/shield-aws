# Operational Event-Driven Monitoring & Alerting

**Owner:** Hazem Elsayed | **Region:** Europe (Stockholm) `eu-north-1` | **Account:** `253957900169`

---

## Summary
This task implements an automated monitoring and event-driven alerting architecture using **Amazon EventBridge** and **Amazon SNS** in the Stockholm region. Infrastructure state changes and health alerts are captured by EventBridge rules and delivered to the engineering team by email through an SNS topic.

* **Amazon EventBridge Rules:** Three event pattern rules monitor operational events (SSH access, Auto Scaling lifecycle events, and CloudWatch Alarm state changes).
* **Amazon SNS Topic:** A standard topic with two confirmed email subscriptions and an access policy restricted to the account owner.

---

## Part 1: EventBridge Architecture & Event Pattern Rules

### 1.1 Event Bus Overview
The **default** event bus is used to capture system-generated events across the region. No custom bus, schema discovery, or discoverer is configured.

* **Event Bus Name:** `default`
* **Event Bus ARN:** `arn:aws:events:eu-north-1:253957900169:event-bus/default`
* **Schema Discovery:** Not initiated
* **Rules attached to the bus:** 3

**Screenshot: EventBridge > Event buses > default**

![EventBridge Default Event Bus](<img width="1917" height="1003" alt="Screenshot 2026-10-22 204845" src="https://github.com/user-attachments/assets/5d335511-f94a-4f87-861e-4c1c13c6f89d" />
)

---

### 1.2 Event Pattern Rules Configuration
Three **Standard** event pattern rules are created on the `default` bus. All of them are in the **Enabled** state.

| Rule Name | Status | Type | Event Bus | Purpose |
|---|---|---|---|---|
| `notify-alarm-state` | Enabled | Standard | default | Monitors CloudWatch Alarm state transitions |
| `notify-asg-events` | Enabled | Standard | default | Captures Auto Scaling Group lifecycle notifications |
| `notify-ssh-open` | Enabled | Standard | default | Tracks inbound SSH connections and potential security events |

**Rule ARNs:**
* `arn:aws:events:eu-north-1:253957900169:rule/notify-alarm-state`
* `arn:aws:events:eu-north-1:253957900169:rule/notify-asg-events`
* `arn:aws:events:eu-north-1:253957900169:rule/notify-ssh-open`

**Screenshot: Event pattern rules list**

![Event Pattern Rules](<img width="1890" height="913" alt="Screenshot 2026-10-22 205350" src="https://github.com/user-attachments/assets/6cd391bb-1018-4679-b990-451ac50b43c4" />
)

---

## Part 2: Amazon SNS Notification Infrastructure

### 2.1 Topic Details & Subscriptions
A dedicated SNS topic delivers critical system alerts to the engineering team via the email protocol.

* **Topic Name:** `Un_healthy_alert`
* **Topic ARN:** `arn:aws:sns:eu-north-1:253957900169:Un_healthy_alert`
* **Type:** Standard
* **Topic Owner:** `253957900169`
* **Maximum Message Size:** 256 KiB
* **Confirmed Subscriptions (2):**

| Endpoint | Protocol | Status |
|---|---|---|
| `omarmohamedu309@gmail.com` | EMAIL | Confirmed |
| `hazemelsaied37@gmail.com` | EMAIL | Confirmed |

**Screenshot: SNS > Topics > Un_healthy_alert > Subscriptions**

![SNS Subscriptions](<img width="1906" height="903" alt="Screenshot 2026-10-22 205237" src="https://github.com/user-attachments/assets/978cbbfd-ba59-437c-ab8b-4f4fe8ed3798" />
)

---

### 2.2 SNS Topic Access Policy
The access policy defines who can publish to and subscribe to the topic. It uses policy version `2008-10-17` with the default policy ID, and grants the following actions on the topic:

* `SNS:GetTopicAttributes`
* `SNS:SetTopicAttributes`
* `SNS:AddPermission`
* `SNS:RemovePermission`
* `SNS:DeleteTopic`
* `SNS:Subscribe`
* `SNS:ListSubscriptionsByTopic`
* `SNS:Publish`

Access is restricted to the topic owner's account using the condition `StringEquals` on `AWS:SourceOwner` with the value `253957900169`. The policy applies to the resource `arn:aws:sns:eu-north-1:253957900169:Un_healthy_alert`.

**Screenshot: Access policy (statement, principal and actions)**

![SNS Access Policy - Statement and Actions](<img width="1873" height="875" alt="Screenshot 2026-10-22 205357" src="https://github.com/user-attachments/assets/076d0bd9-e104-4d2b-b421-5032c2387cf0" />
)

**Screenshot: Access policy (resource and condition)**

![SNS Access Policy - Resource and Condition](<img width="1890" height="913" alt="Screenshot 2026-10-22 205350" src="https://github.com/user-attachments/assets/a3a4c0df-7528-4445-b074-00eac5aea2af" />
)

---

## Part 3: Verification & Status Summary

* The `default` event bus holds **3 enabled** event pattern rules.
* The SNS topic `Un_healthy_alert` has **2 confirmed** email subscriptions.
* The SNS Topics page lists 2 standard topics in `eu-north-1`: `Un_healthy_alert` (this task) and `aws-cloudtrail-logs-253957900169-c487c730` (CloudTrail).

All resources were verified active in the `eu-north-1` region.

**Screenshot: Amazon SNS > Topics overview**

![SNS Topics List](<img width="1907" height="906" alt="Screenshot 2026-10-22 205414" src="https://github.com/user-attachments/assets/9ab199eb-718c-4b8f-be21-24a78d9a4694" />
)
