# Terraform Jenkins Lab

This lab uses Jenkins to validate and apply Terraform configuration that provisions an Amazon EC2 instance.

## What it creates

- One `t3.micro` EC2 instance in the `ap-south-1` (Asia Pacific - Mumbai) region.
- The latest Amazon Linux 2023 x86-64 AMI, looked up from the AWS Systems Manager public parameter `/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64`.
- Resource tags:
  - `Name`: `terraform-jenkins-lab`
  - `ManagedBy`: `Terraform`
  - `Project`: `Lab23`

Terraform outputs the instance ID, instance type, and availability zone.

## Repository files

| File | Purpose |
| --- | --- |
| `main.tf` | Looks up the Amazon Linux AMI and defines the EC2 instance. |
| `provider.tf` | Configures the AWS provider for `ap-south-1`. |
| `outputs.tf` | Declares the instance ID, instance type, and availability zone outputs. |
| `variables.tf` | Terraform variable definitions (currently empty). |
| `jenkinsfile` | Jenkins declarative pipeline for checkout, validation, planning, approval, and apply. |

## Prerequisites

- An AWS account and credentials authorized to read the public SSM parameter and create/manage the EC2 instance and its associated resources.
- Terraform installed and available on the Jenkins agent's `PATH`.
- Git installed and available on the Jenkins agent's `PATH`.
- A Jenkins agent running on Windows, since the pipeline uses Windows `bat` steps.
- Jenkins configured to check out this repository through the `checkout scm` step.
- A Jenkins Username/Password credential with the ID `aws-lab-creds`. Set the username to the AWS access key ID and the password to the AWS secret access key. The pipeline exposes these to Terraform as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

Use an appropriately scoped IAM identity and follow your organization's credential-management policies. Do not put AWS credentials in the Terraform files or commit them to this repository.

## Run with Jenkins

1. Create a Jenkins Pipeline job configured to use this repository and its `jenkinsfile`.
2. Add the `aws-lab-creds` Jenkins credential described above.
3. Run the job.

The pipeline performs these stages:

1. Checks out the repository and reports Git status.
2. Checks that Git and Terraform are available.
3. Checks Terraform formatting with `terraform fmt -check -recursive`.
4. Initializes Terraform and validates the configuration.
5. Creates a saved plan (`tfplan`) using the configured AWS credentials.
6. Pauses for manual review and approval.
7. Applies the approved saved plan.

The AWS region is configured as `ap-south-1` in both the Terraform provider and the Jenkins pipeline environment. The pipeline does not automatically destroy resources.

## Run locally

From the repository directory, with Terraform installed and AWS credentials supplied through your normal AWS credential provider:

```powershell
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
```

To create the instance locally after reviewing the plan:

```powershell
terraform apply
```

## Cleanup

After you have finished with the lab, destroy the resources using the same Terraform working directory and state that created them:

```powershell
terraform destroy
```

For a Jenkins-created instance, run the destroy command in an environment with access to the corresponding Terraform state and AWS credentials. The configuration does not define a remote backend, so Terraform uses local state by default. Preserve that state between Jenkins runs; losing it can prevent Terraform from tracking and safely cleaning up the instance.

EC2 resources may incur AWS charges while they exist. Confirm the plan and verify the instance has been removed when the lab is complete.
