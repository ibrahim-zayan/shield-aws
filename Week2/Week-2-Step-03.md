# Step 3 — Security Self-Healing: SSH Remediation

**Owner:** Ibrahim

## Objective

Detect and remove public SSH access from the team's application security group to reduce exposure of the application servers.

## Implementation Summary

- Created the `Team-SSH-Remediation` Lambda function to inspect security group ingress rules.
- Configured the `Team-SSH-Public-Ingress-Remediation` EventBridge rule to detect EC2 `AuthorizeSecurityGroupIngress` events recorded through CloudTrail.
- Connected the EventBridge rule to the Lambda function.
- Scoped remediation to the existing `Primary-App-EC2-SG`.
- The function looks for public IPv4 SSH access (`TCP/22` from `0.0.0.0/0`) and removes matching ingress rules.
- Added a dedicated execution role with permissions to inspect security group rules, revoke ingress on the application security group, and write CloudWatch Logs.
- Configured a CloudWatch log group with 30-day retention.
  
## Remediation Flow

1. A user or process attempts to authorize an ingress rule in EC2.
2. CloudTrail records the `AuthorizeSecurityGroupIngress` API event.
3. EventBridge sends the event to the `Team-SSH-Remediation` Lambda function.
4. The function checks `Primary-App-EC2-SG` for public SSH ingress.
5. If a matching rule is found, the function removes it and writes the result to CloudWatch Logs.
6. If no matching rule is found, the security group is left unchanged.
   
## Response Scope

- Removing a public SSH rule from the shared application security group protects all instances that use that group.
- Opening SSH is treated as exposure, not proof that an instance is compromised.
- If there is evidence that a specific instance is compromised, quarantine that instance individually using `Quarantine-SG`.
- Quarantine is a manual response and is not performed by this Lambda function.

## Validation

- Confirm that the EventBridge rule is enabled and connected to the Lambda function.
- After a remediation test, verify that the public SSH rule has been removed from `Primary-App-EC2-SG`.
- Review the Lambda execution logs in CloudWatch to confirm the event was processed.
- Record the remediation test as successful only after confirming both the security group change and the Lambda execution logs.

## Screenshots

[Lambda function overview](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-lambda-overview.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-lambda-overview.png))

[Lambda configuration and execution role](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-lambda-configuration.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-lambda-configuration.png))

[EventBridge rule and Lambda target](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-eventbridge-rule.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-eventbridge-rule.png))

[Lambda IAM permissions](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-iam-permissions.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-iam-permissions.png))

[Lambda CloudWatch logs](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-cloudwatch-logs.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-cloudwatch-logs.png))

[Application security group after remediation test](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-security-group-after-test.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-security-group-after-test.png))
