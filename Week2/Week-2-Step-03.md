# Step 3 — Security Self-Healing: SSH Remediation

**Owner:** Ibrahim

## Objective

Automatically detect and remove public SSH ingress rules from the team's application security group.

## Implementation Summary

- Implemented the remediation handler in Python using `boto3`.
- Deployed the handler as the `Team-SSH-Remediation` AWS Lambda function.
- Configured a dedicated EventBridge rule, `Team-SSH-Public-Ingress-Remediation`, to detect EC2 `AuthorizeSecurityGroupIngress` events recorded through CloudTrail.
- Connected the EventBridge rule to the Lambda function and allowed EventBridge to invoke it.
- Scoped the function to the existing `Primary-App-EC2-SG`.
- Configured the Lambda function to find and revoke public IPv4 SSH ingress rules (`TCP/22` from `0.0.0.0/0`).
- Created a dedicated IAM execution role with permissions to inspect security group rules, revoke ingress on the application security group, and write CloudWatch Logs.
- Configured a CloudWatch log group with 30-day retention.
- Provisioned the Lambda and its supporting resources with Terraform.

## Response Scope

- The Lambda removes the public SSH rule from the shared application security group.
- Opening SSH is treated as exposure, not proof that an instance is compromised.
- Instance quarantine is a manual response when there is evidence of compromise; the Lambda does not quarantine instances.
- GuardDuty was unavailable in the team account during implementation.

## Validation

- Terraform planned 7 resources to add, 0 to change, and 0 to destroy.
- The existing Compute resources were not included in the planned changes.
- Capture the Lambda execution logs and the security group state after a remediation test before documenting the test as successful.

## Screenshots

[Lambda function overview](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-lambda-overview.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-lambda-overview.png))

[Lambda configuration and execution role](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-lambda-configuration.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-lambda-configuration.png))

[EventBridge rule and Lambda target](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-eventbridge-rule.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-eventbridge-rule.png))

[Lambda IAM permissions](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-iam-permissions.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-iam-permissions.png))

[Lambda CloudWatch logs](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-cloudwatch-logs.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-cloudwatch-logs.png))

[Application security group after remediation test](https://github.com/ibrahim-zayan/shield-aws/blob/main/Week2/Screenshoots/step-03-security-group-after-test.png) ([image](https://github.com/ibrahim-zayan/shield-aws/raw/main/Week2/Screenshoots/step-03-security-group-after-test.png))
