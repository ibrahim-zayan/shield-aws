# Step 2 — Compute & Application Load Balancer

**Owner:** Ibrahim

## Objective

Run the team's primary application on EC2 instances across two Availability
Zones, with traffic distributed through an Application Load Balancer.

## Implementation Summary

- Used the team's existing VPC, public and private subnets, and security groups.
- Configured an EC2 Launch Template with Amazon Linux 2023 and `t3.micro`.
- Required IMDSv2 and used the existing `Primary-EC2-SSM-Role` instance profile.
- Left out an SSH key pair.
- Used instance user data to install Apache and display each instance's ID and
  Availability Zone.
- Configured a public Application Load Balancer across the two public subnets.
- Connected its HTTP listener and target group to an Auto Scaling Group in the
  two private subnets.
- Set the Auto Scaling Group to keep two instances running, with an ELB health
  check.

## Security Groups

- The ALB uses the existing `Primary-ALB-SG`.
- The EC2 instances use the existing `Primary-App-EC2-SG`.
- The application security group allows inbound HTTP traffic from the ALB
  security group.

## Validation

- The Auto Scaling Group launched two instances in separate Availability Zones:
  `eu-north-1a` and `eu-north-1b`.
- Both instances became healthy targets.
- Repeated requests to the ALB returned both instance IDs.

## Screenshots

<img src="./Screenshots/step-02-asg-in-service.png" alt="ASG with two instances in service" width="700">

<img src="./Screenshots/step-02-targets-healthy.png" alt="Healthy targets" width="700">

<img src="./Screenshots/step-02-alb-response-1.png" alt="ALB response from instance 1" width="700">

<img src="./Screenshots/step-02-alb-response-2.png" alt="ALB response from instance 2" width="700">
