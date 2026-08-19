# Auto-Healing AWS Infrastructure

Self-healing, auto-scaling cloud infrastructure built with Terraform — designed to detect failures and recover automatically without manual intervention.

**Tech Stack:** Terraform · AWS (VPC, EC2, ALB, ASG, RDS, CloudWatch, SNS, Lambda)

## The Problem

A production EC2 instance crashes at 2 AM. No auto-recovery exists. The on-call engineer has to diagnose the issue manually and recover the infrastructure.

This project rebuilds that scenario as a fully automated, self-healing system.

## Architecture

Users → ALB (Multi-AZ, public subnets) → EC2 (private subnets, ASG-managed)

↓
CloudWatch Alarms
↓
SNS Topic
↙        ↘
Email      Lambda
↓
ASG replaces unhealthy instance

## Results

*(Numbers will be updated after live testing)*

| Metric | Manual Baseline | Automated (Measured) | Improvement |
|---|---|---|---|
| MTTR (infrastructure failure) | ~45 min | TBD | TBD |

## Modules

- **VPC** — Multi-AZ network, public/private subnet split, single NAT Gateway
- **Security Groups** — Identity-based access chain (ALB → EC2 → RDS)
- **EC2** — Launch Template with dynamic AMI lookup and user_data bootstrap
- **ALB** — Health-checked load balancing across 2 Availability Zones
- **ASG** — Self-healing with min=2, max=4, desired=2
- **RDS** — Multi-AZ MySQL for database resilience
- **CloudWatch** — Alarms for unhealthy hosts and high CPU utilization
- **SNS** — Notifications through email and Lambda
- **Lambda** — Automated remediation of unhealthy instances

## Key Design Decisions

- **Single NAT Gateway** — Cost-optimization trade-off for a learning/portfolio project.
- **Multi-AZ RDS** — Provides database resilience.
- **Identity-based Security Groups** — Uses Security Group IDs instead of hardcoded IPs.
- **Selective Lambda remediation** — Only unhealthy-host alarms trigger instance termination.
- **Remote state management** — S3 backend with state locking for safer Terraform operations.

## How to Deploy

```bash
terraform init
terraform plan
terraform apply