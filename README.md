# Auto-Healing AWS Infrastructure

Self-healing and auto-scaling AWS infrastructure built with Terraform.

The project is designed to monitor infrastructure health, detect failures, generate alerts, and automatically recover unhealthy instances.

## Tech Stack

Terraform · AWS VPC · EC2 · ALB · Auto Scaling Group · RDS MySQL · CloudWatch · SNS · Lambda · IAM · Linux · Bash

---

## The Problem

Imagine a production EC2 instance becoming unhealthy at 2 AM.

Without automation:

- The issue may not be detected immediately.
- An engineer has to investigate the problem manually.
- Infrastructure recovery requires manual intervention.
- Application availability may be affected.

This project demonstrates a production-style AWS architecture designed to automate monitoring, alerting, and infrastructure recovery.

---

## Architecture

```text
                           Internet
                              │
                              ▼
              Application Load Balancer (ALB)
                    Public Subnets / Multi-AZ
                              │
                 ┌────────────┴────────────┐
                 │                         │
                 ▼                         ▼
            EC2 Instance              EC2 Instance
            Private Subnet            Private Subnet
                 │                         │
                 └────────────┬────────────┘
                              │
                              ▼
                     Auto Scaling Group
                  Min: 2 | Desired: 2
                         Max: 4
                              │
                              ▼
                         RDS MySQL
                       Private Subnets


                         Monitoring
                              │
                              ▼
                         CloudWatch
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
         High CPU Alarm             Unhealthy Host Alarm
                │                           │
                ▼                           ▼
              SNS Email                 SNS / Lambda
                │                           │
                ▼                           ▼
            Notification          Automated Remediation
                                            │
                                            ▼
                                  Auto Scaling Recovery