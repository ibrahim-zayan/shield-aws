Step 3 — Monitoring, Auditing & Architecture

Owner: Omar

Objective

Monitor AWS infrastructure health, record account activity for auditing, track cloud spending, and document the initial project architecture.

Implementation Summary

- Configured AWS CloudTrail to record management events for auditing and AWS account activity tracking.
- Created an Amazon CloudWatch dashboard to monitor application and load balancer metrics, including request count, healthy and unhealthy hosts, and target response time.
- Configured a CloudWatch alarm named "unhealthy host count Notice" to monitor unhealthy hosts.
- Verified email notifications by testing the alarm state transition from "OK" to "ALARM".
- AWS Budgets and the initial architecture diagram are not included in the evidence below.

Screenshots

1. AWS CloudTrail — Trail Configuration

The "Depi-Grad_project" trail is enabled and recording events.

![CloudTrail Trail Configuration](Screenshoots/WhatsApp%20Image%202026-10-19%20at%208.55.32%20PM.jpeg)

2. Amazon CloudWatch — Monitoring Dashboard

The dashboard displays key application and load balancer metrics across Availability Zones.

![CloudWatch Dashboard](Screenshoots/WhatsApp%20Image%202026-10-19%20at%208.55.32%20PM%20(1).jpeg)

3. Amazon CloudWatch — Alarm Status

The "unhealthy host count Notice" alarm is shown in the "OK" state, with alarm actions enabled.

![CloudWatch Alarm](Screenshoots/WhatsApp%20Image%202026-10-19%20at%208.55.32%20PM%20(2).jpeg)


4. Amazon CloudWatch — Email Notification

An email notification confirms that the alarm transitioned from "OK" to "ALARM" during testing.

![Email Notification](Screenshoots/WhatsApp%20Image%202026-10-19%20at%208.56.24%20PM.jpeg)
