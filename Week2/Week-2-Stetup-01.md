# Operational Self-Healing (Compute)

**Owner:** Omar
**Region:** Europe (Stockholm) `eu-north-1`

## Summary

This task implements automatic replacement of unhealthy EC2 instances using ALB health checks and an Auto Scaling Group (ASG), and prepares a Quarantine Security Group for isolating suspicious instances.

- **Automatic EC2 replacement:** implemented and tested. Stopping `httpd` on an instance made the ALB mark it unhealthy; the ASG terminated it and launched a replacement.
- **Quarantine Security Group:** prepared and verified (zero inbound / zero outbound rules, not attached to any resource).
- **Isolation workflow:** documented, **not yet tested end-to-end**.

---

## Part 1: Automatic EC2 Replacement

### 1.1 Target Group health check

`Team-Compute-TG` (attached to `Team-Compute-ALB`) uses an HTTP health check on path `/` using the traffic port.

| Setting | Value |
|---|---|
| Protocol | HTTP |
| Path | `/` |
| Port | Traffic port |
| Interval | 30 seconds |
| Timeout | 5 seconds |
| Healthy threshold | 2 consecutive successes |
| Unhealthy threshold | 2 consecutive failures |
| Success codes | 200 |

**Screenshot:** Target Group > Health checks tab

![Target Group health check settings](screenshots/Omar's%20task/Targetgrouphealthcheck.png)


### 1.2 ASG health check type

`Team-Compute-ASG` relies on **both EC2 and ELB health checks**, so an instance that fails the ALB health check is replaced even if the EC2 instance itself is still running.

| Setting | Value |
|---|---|
| Health check type | EC2, ELB |
| Health check grace period | 300 seconds |

**Screenshot:** ASG > Details tab > Health checks

![ASG health check type and grace period](screenshots/Omar's%20task/ASGhealthcheck.png)

### 1.3 ASG attached to the Target Group

**Screenshot:** ASG > Integrations tab > Load balancing (`Team-Compute-TG`)

![ASG integrations](screenshots/Omar's%20task/ASG%20integrations.png)
### 1.4 ASG capacity

| Setting | Value |
|---|---|
| Desired capacity | 2 |
| Minimum | 2 |
| Maximum | 4 |

**Screenshot:** ASG > Capacity overview

![ASG capacity](screenshots/Omar's%20task/ASGcapacity.png)

### 1.5 Test and evidence

**Test method:** ran `sudo systemctl stop httpd` on an instance in the ASG.

**Result:** the target became unhealthy, the ASG took the instance out of service due to an ELB health check failure, and a replacement instance was launched. The Target Group returned to 2 healthy targets.

Two replacement cycles were recorded on 2026-10-23 (UTC+03:00):

| Time | Terminated | Launched |
|---|---|---|
| 08:07 PM | `i-09f7201048fee4457` | `i-0b802ff0ed4410345` |
| 08:19 PM | `i-0b802ff0ed4410345` | `i-0ece750a0c7fc2084` |

**Screenshot:** Target Group before the test (2 Healthy / 0 Unhealthy)

![Target Group before test](screenshots/Omar's%20task/targetgroupbeforehealthcheck.png)

**Screenshot:** Target Group during the test (1 Healthy / 1 Unhealthy, "Health checks failed")

![Target Group during test](screenshots/Omar's%20task/Targetgroupduringhealthcheck.png)

**Screenshot:** ASG > Activity history (terminate + launch, all Successful)

![ASG activity history](screenshots/Omar's%20task/ASGactivityhistory.png)

**Screenshot:** CloudWatch alarm email (`unhealthy host count Notice`, OK -> ALARM at 17:07 UTC)

![CloudWatch alarm email](screenshots/Omar's%20task/cloudwatchalarmmail.png)

---

## Part 2: Quarantine Security Group

### 2.1 Configuration

| Property | Value |
|---|---|
| Name | `Quarantine-SG` |
| ID | `sg-00d70d4275c2e615d` |
| Description | Isolated security group for compromised EC2 instances |
| VPC | `vpc-0bc4b5580c679f013` |
| Inbound rules | 0 |
| Outbound rules | 0 |

With no inbound and no outbound rules, an instance placed in this group cannot accept new connections or start new outbound connections.

**Screenshot:** Security Groups > `Quarantine-SG` > Details

![Quarantine-SG details](screenshots/Omar's%20task/Quarantine-SG details.png)

### 2.2 Verification that it is not attached to anything

Checked from three angles:

1. **Network Interfaces** filtered by the SG ID: no matching network interfaces.
2. **Instances** filtered by the SG ID: no matching instances.
3. **Related resources > All resources:** the only related resource is the VPC itself.

**Screenshot:** Network Interfaces filtered by SG ID

![No network interface attached](screenshots/Omar's%20task/Network Interfaces.png")

**Screenshot:** Instances filtered by SG ID

![No instance attached](screenshots/Omar's%20task/Instances.png)

**Screenshot:** Related resources > All resources

![Related resources](screenshots/Omar's%20task/Related resources.png)

### 2.3 Planned isolation workflow 

1. Put the suspect instance in **Standby** or **Detach** it from the ASG so it is not replaced and evidence is preserved.
2. Take a **snapshot** of its EBS volume.
3. Replace its security groups with `Quarantine-SG` only.
4. Investigate using a copy of the snapshot on a separate instance.
5. Terminate the isolated instance afterwards.

### 2.4 Known limitations

- Security groups are stateful: connections established before isolation may persist. A Network ACL or stopping the instance is needed for full isolation.
- A quarantined instance has no network access, so SSH and Session Manager will not work.
- If an instance is isolated while still inside the ASG, it will fail the ALB health check and be replaced, destroying evidence. Detach or Standby first.

---

## Status

| Item | Status |
|---|---|
| ALB/ASG health checks configured | Done |
| Automatic replacement tested | Done |
| `Quarantine-SG` created and verified | Done |
| Quarantine isolation workflow  | Done |